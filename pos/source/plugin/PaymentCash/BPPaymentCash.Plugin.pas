(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 현금/현금영수증 결제 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPPaymentCash.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, Vcl.Imaging.pngimage,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPPaymentCashForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panRight: TPanel;
    imgLogo: TImage;
    btnCashComplete: TBitBtn;
    btnCashApprove: TBitBtn;
    ckbSelfCashReceipt: TCheckBox;
    panBody: TPanel;
    btnEntityPerson: TSpeedButton;
    btnEntityBiz: TSpeedButton;
    Label1: TLabel;
    lblOrgApproveDate: TLabel;
    lblOrgApproveNo: TLabel;
    edtChargeTotal: TDBNumberEditEh;
    edtUnpaidTotal: TDBNumberEditEh;
    edtPaymentAmt: TDBNumberEditEh;
    edtChangeAmt: TDBNumberEditEh;
    ckbManualnput: TCheckBox;
    edtManualApproveNo: TDBEditEh;
    edtManualIdentNo: TDBEditEh;
    btnCheckCheque: TBitBtn;

    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCheckChequeClick(Sender: TObject);
    procedure btnCashApproveClick(Sender: TObject);
    procedure btnCashCompleteClick(Sender: TObject);
    procedure ckbSelfCashReceiptClick(Sender: TObject);
    procedure ckbManualnputClick(Sender: TObject);
    procedure edtPaymentAmtEnter(Sender: TObject);
    procedure edtPaymentAmtChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FInputAmt: Integer;
    FIsApproval: Boolean;
    FIsSaleMode: Boolean;
    FIsManualInput: Boolean;
    FIsSelfCashReceipt: Boolean;
    FReceiptNo: string;
    FApprovalNo: string;
    FApprovalDate: string;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoCashApprove;
    procedure DoCashComplete;
    procedure SetInputAmt(const AValue: Integer);
    procedure SetIsApproval(const AValue: Boolean);
    procedure SetIsManualInput(const AValue: Boolean);
    procedure SetIsSelfCashReceipt(const AValue: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property InputAmt: Integer read FInputAmt write SetInputAmt default 0;
    property IsApproval: Boolean read FIsApproval write SetIsApproval default False;
    property IsManualInput: Boolean read FIsManualInput write SetIsManualInput default False;
    property IsSelfCashReceipt: Boolean read FIsSelfCashReceipt write SetIsSelfCashReceipt default False;
  end;

implementation

uses
  { Native }
  Vcl.Dialogs, System.Variants, System.Math, System.StrUtils,
  { VAN }
  uVanDaemonModule,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPPaymentCashForm }

constructor TBPPaymentCashForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  FInputAmt := 0;
  FReceiptNo := '';
  FApprovalNo := '';
  FApprovalDate := '';
  FIsApproval := False;
  FIsManualInput := False;

  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  IsSelfCashReceipt := Global.Config.SelfCashReceipt;
  lblOrgApproveDate.Visible := False;
  lblOrgApproveNo.Visible := False;
  btnEntityPerson.Down := True;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPPaymentCashForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPPaymentCashForm.PluginModuleActivate(Sender: TObject);
begin
  with edtPaymentAmt do
  begin
    SelStart := Length(Text) + 1;
    if IsApproval then
      Self.SetFocus;
  end;
end;

procedure TBPPaymentCashForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPPaymentCashForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPPaymentCashForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    InputAmt := AMsg.ParamByInteger(CPP_APPROVAL_AMT);
    IsApproval := AMsg.ParamByBoolean(CPP_APPROVAL_YN);
    FIsSaleMode := AMsg.ParamByBoolean(CPP_SALEMODE_YN);
    FReceiptNo := AMsg.ParamByString(CPP_RECEIPT_NO);
    FApprovalNo := AMsg.ParamByString(CPP_APPROVAL_NO);
    FApprovalDate := AMsg.ParamByString(CPP_APPROVAL_DATE);
    if (AMsg.ParamByInteger(CPP_CASH_ENTITY_DIV) = CO_CASH_RECEIPT_BIZ) then
      btnEntityBiz.Down := True
    else
      btnEntityPerson.Down := True;
  end
  else if (AMsg.Command = CPC_CHEQUE_APPPLY) then
  begin
    edtManualIdentNo.Text := AMsg.ParamByString(CPP_CHEQUE_NO);
    InputAmt := AMsg.ParamByInteger(CPP_VALUE);
  end;
end;

procedure TBPPaymentCashForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      if (ActiveControl is TCustomEdit) then
        TCustomEdit(ActiveControl).Clear;
    VK_RETURN:
      if IsApproval then
        btnCashComplete.Click;
    VK_ESCAPE:
      Self.Close;
  end;
end;

procedure TBPPaymentCashForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPPaymentCashForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPPaymentCashForm.btnCheckChequeClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if FWorking then
    Exit;

  FWorking := True;
  PM := TPluginMessage.Create(nil);
  with TBitBtn(Sender) do
  try
    Enabled := False;
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PluginManager.OpenModal('BPChequeApprove' + CO_DEFAULT_EXT_PLUGIN, PM);
  finally
    FreeAndNil(PM);
    Enabled := True;
    FWorking := False;
  end;
end;

procedure TBPPaymentCashForm.btnCashApproveClick(Sender: TObject);
begin
  DoCashApprove;
end;

procedure TBPPaymentCashForm.btnCashCompleteClick(Sender: TObject);
begin
  DoCashComplete;
end;

procedure TBPPaymentCashForm.ckbSelfCashReceiptClick(Sender: TObject);
begin
  IsSelfCashReceipt := TCheckBox(Sender).Checked;
end;

procedure TBPPaymentCashForm.ckbManualnputClick(Sender: TObject);
begin
  IsManualInput := TCheckBox(Sender).Checked;
end;

procedure TBPPaymentCashForm.edtPaymentAmtEnter(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TBPPaymentCashForm.edtPaymentAmtChange(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
  begin
    if VarIsNull(Value) then
      Value := 0;
    InputAmt := Trunc(Value);
    Text := FormatCurr('#,##0', InputAmt);
    SelStart := Length(Text) + 1;
  end;
end;

procedure TBPPaymentCashForm.SetInputAmt(const AValue: Integer);
var
  nUnpaidAmt: Integer;
begin
  FInputAmt := AValue;
  with Global.ReceiptInfo do
  begin
    if (FInputAmt > UnpaidAmt) then
      nUnpaidAmt := 0
    else
      nUnpaidAmt := (UnpaidAmt - FInputAmt);

    edtPaymentAmt.Value := FInputAmt;
    edtChargeTotal.Text := FormatCurr('#,##0', ChargeAmt); //받을금액
    edtUnpaidTotal.Text := FormatCurr('#,##0', nUnpaidAmt); //미결제금액
  end;
end;

procedure TBPPaymentCashForm.SetIsApproval(const AValue: Boolean);
begin
  FIsApproval := AValue;
  panHeader.Caption := '현금 '+ IfThen(FIsApproval, '결제', '취소');
  edtPaymentAmt.ControlLabel.Caption := IfThen(FIsApproval, '최종 결제', '결제 취소') + ' 금액 (원)';
  edtPaymentAmt.ReadOnly := (not FIsApproval);

  ckbManualnput.Enabled := FIsApproval;
  btnCheckCheque.Enabled := FIsApproval;
  lblOrgApproveDate.Caption := Format('원거래일자 : %s', [FApprovalNo]);
  lblOrgApproveNo.Caption := Format('원승인번호 : %s', [FApprovalDate]);
  lblOrgApproveNo.Caption := FApprovalNo;
  lblOrgApproveDate.Caption := FApprovalDate;
  lblOrgApproveNo.Visible := (not FIsApproval);
  lblOrgApproveDate.Visible := (not FIsApproval);
  ckbSelfCashReceipt.Enabled := FIsApproval;
  btnCashApprove.Caption := Format('현금영수증 %s 요청', [IfThen(FIsApproval, '승인', '취소')]);
end;

procedure TBPPaymentCashForm.SetIsManualInput(const AValue: Boolean);
begin
  FIsManualInput := AValue;
  edtManualApproveNo.Enabled := FIsManualInput;
  edtManualIdentNo.Enabled := FIsManualInput;
  btnCashApprove.Enabled := (not FIsManualInput);
  btnCashApprove.Caption := IfThen(FIsManualInput, '결제 등록', '승인 요청');
  if FIsManualInput then
    IsSelfCashReceipt := False;
end;

procedure TBPPaymentCashForm.SetIsSelfCashReceipt(const AValue: Boolean);
begin
  FIsSelfCashReceipt := AValue;
  ckbSelfCashReceipt.Checked := FIsSelfCashReceipt;
  btnCashComplete.Enabled := (not FIsSelfCashReceipt);
  edtManualApproveNo.Enabled :=  (not FIsSelfCashReceipt);
  edtManualIdentNo.Enabled :=  (not FIsSelfCashReceipt);
  if FIsSelfCashReceipt then
  begin
    btnEntityPerson.Down := True;
    edtManualApproveNo.Clear;
    edtManualIdentNo.Clear;
  end;
end;

procedure TBPPaymentCashForm.DoCashApprove;
var
  PM: TPluginMessage;
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
  PR: TPaymentItemRec;
  LVAT: Integer;
  LIdentNo, LApproveNo, LResMsg: string;
begin
  if FWorking then
    Exit;
  FWorking := True;
  btnCashApprove.Enabled := False;
  try
    try
      if (InputAmt <= 0) then
        raise Exception.Create('결제 금액이 입력되지 않았습니다.');
      if (IsApproval and (InputAmt > Global.ReceiptInfo.ChargeAmt)) then
        raise Exception.Create('받을 금액보다 결제할 금액이 더 많습니다.');
      LIdentNo := Trim(edtManualIdentNo.Text);
      if IsApproval and
         IsManualInput then
      begin
        LApproveNo := Trim(edtManualApproveNo.Text);
        if (LIdentNo.IsEmpty or (LApproveNo.Length < 8)) then
          raise Exception.Create('현금영수증 임의 등록(수기 입력)은 승인번호 8자리와 식별번호가 입력되어야 합니다.');
      end;

      LVAT := (InputAmt - Trunc(InputAmt / 1.1));
      SI.Approval     := IsApproval;
      SI.SaleAmt      := InputAmt;
      SI.FreeAmt      := 0;
      SI.SvcAmt       := 0;
      SI.VatAmt       := LVAT;
      SI.OrgAgreeNo   := FApprovalNo;
      SI.OrgAgreeDate := FApprovalDate;
      SI.TerminalID   := Global.TerminalInfo.VanTID;
      SI.BizNo        := Global.StoreInfo.BizNo;
      SI.Person       := IfThen(IsSelfCashReceipt or btnEntityPerson.Down, CO_CASH_RECEIPT_PERSON, CO_CASH_RECEIPT_BIZ);
      SI.CardNo       := IfThen(IsSelfCashReceipt, '0100001234', LIdentNo); //현금영수증 자진발급 여부 결정
      SI.KeyInput     := (SI.CardNo <> '');
      // 취소사유코드 (1:거래취소, 2:오류발급, 3:기타)
      if not IsApproval then
        SI.CancelReason := 1;

      RI := VanModule.CallCash(SI);
      if not RI.Result then
        raise Exception.Create(RI.Msg)
      else
      begin
        if IsApproval then
        begin
          if FIsSaleMode then
          begin
            PayLog(FReceiptNo, IsApproval, IsManualInput, CO_PAYMENT_CASH, RI.CardNo, RI.AgreeNo, InputAmt);
            Global.ReceiptInfo.CashPayAmt := InputAmt;
          end;

          PR.Clear;
          PR.IsApproval := IsApproval;
          PR.IsManualInput := IsManualInput;
          PR.PayMethod := CO_PAYMENT_CASH;
          PR.VanCode := Global.TerminalInfo.VanCode;
          PR.TID := Global.TerminalInfo.VanTID;
          PR.ApproveNo := RI.AgreeNo;
          PR.ApproveAmt := InputAmt;
          PR.VAT := LVAT;
          PR.CashEntity := SI.Person;
          PR.CardNo := RI.CardNo;
          PR.TradeNo := RI.TransNo;
          PR.TradeDate := Global.DateTime.CurrentDate;
          PR.IssuerCode := RI.BalgupsaCode;
          PR.ISsuerName := RI.BalgupsaName;
          PR.BuyerCode := RI.CompCode;
          PR.BuyerName := RI.CompName;
          if not BPDM.UpdatePayment(Global.LaneInfo.SelectedLaneNo, FIsSaleMode, False, PR, LResMsg) then
            raise Exception.Create(LResMsg);
        end
        else
        begin
          if FIsSaleMode then
            Global.ReceiptInfo.CashPayAmt := (Global.ReceiptInfo.CashPayAmt - InputAmt);

          PayLog(FReceiptNo, IsApproval, IsManualInput, CO_PAYMENT_CASH, RI.CardNo, RI.AgreeNo, InputAmt);
          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_CASH_CANCEL;
            PM.AddParams(CPP_APPROVAL_NO, RI.AgreeNo);
            PM.PluginMessageToID(FOwnerId);
          finally
            FreeAndNil(PM);
          end;
        end;

        BPMsgBox(Self.Handle, mtInformation, '알림', '현금영수증이 정상 ' + IfThen(IsApproval, '발급', '취소') + ' 되었습니다.', ['확인'], 5);
        Self.ModalResult := mrOK;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Format('DoCashApprove(%s).Exception = %s', [BoolToStr(IsApproval, True), E.Message]));
        BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
      end;
    end;
  finally
    btnCashApprove.Enabled := True;
    FWorking := False;
  end;
end;

procedure TBPPaymentCashForm.DoCashComplete;
var
  PR: TPaymentItemRec;
  LInputAmt, LVat: Integer;
  LAssignLaneNo: ShortInt;
  LIdentNo, LApproveNo, LResMsg: string;
begin
  if FWorking then
    Exit;
  FWorking := True;
  LAssignLaneNo := Global.LaneInfo.AssignLaneNo(Global.LaneInfo.SelectedLaneNo);
  btnCashComplete.Enabled := False;
  try
    LInputAmt := InputAmt;
    LResMsg := '';
    try
      if (LInputAmt <= 0) then
        raise Exception.Create('결제금액이 입력되지 않았습니다.');
      if (IsApproval and (LInputAmt > Global.ReceiptInfo.ChargeAmt)) then
        raise Exception.Create('받을 금액보다 결제할 금액이 더 많습니다.');
      if IsApproval and
         IsManualInput then
      begin
        LIdentNo := Trim(edtManualIdentNo.Text);
        LApproveNo := Trim(edtManualApproveNo.Text);
        if (LIdentNo.IsEmpty or (LApproveNo.Length < 8)) then
          raise Exception.Create('현금영수증 임의 등록(수기 입력)은 승인번호 8자리와 식별번호가 입력되어야 합니다.');
      end;

      PayLog(FReceiptNo, IsApproval, IsManualInput, CO_PAYMENT_CASH, '', '', LInputAmt);
      Global.ReceiptInfo.CashPayAmt := LInputAmt;
      LVat := (LInputAmt - Trunc(LInputAmt / 1.1));
      PR.Clear;
      PR.IsApproval := FIsApproval;
      PR.IsManualInput := IsManualInput;
      PR.PayMethod := CO_PAYMENT_CASH;
      PR.ApproveAmt := LInputAmt;
      PR.VAT := LVat;
      PR.TradeDate := Global.DateTime.CurrentDate;
      if not BPDM.UpdatePayment(LAssignLaneNo, FIsSaleMode, False, PR, LResMsg) then
        raise Exception.Create(LResMsg);
      Self.ModalResult := mrOK;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    btnCashComplete.Enabled := True;
    FWorking := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPPaymentCashForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.