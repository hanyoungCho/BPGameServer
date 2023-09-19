(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 수표 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPPaymentCheque.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages, Vcl.Mask, DBCtrlsEh, dxGDIPlusClasses,
  Vcl.Imaging.pngimage, Solbi.BitmapButton;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPPaymentChequeForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panRight: TPanel;
    imgLogo: TImage;
    btnApprove: TBitBtn;
    edtChequeAmt: TDBNumberEditEh;
    imgChequeSample: TImage;
    edtChequeNo: TDBEditEh;
    edtBankCode: TDBEditEh;
    edtBranchCode: TDBEditEh;
    edtAccountCode: TDBEditEh;
    edtAccountNo: TDBEditEh;
    edtIssueYear: TDBEditEh;
    edtIssueMonth: TDBEditEh;
    edtIssueDay: TDBEditEh;
    edtResultMsg: TDBEditEh;
    Label6: TLabel;
    btnChequeAmt1: TSpeedButton;
    btnChequeAmt2: TSpeedButton;
    btnChequeAmt3: TSpeedButton;
    btnChequeAmt4: TSpeedButton;
    btnChequeAmtEtc: TSpeedButton;
    btnCheck: TBitBtn;

    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure OnChequeAmtButtonClick(Sender: TObject);
    procedure edtChequeAmtChange(Sender: TObject);
    procedure btnChequeAmtEtcClick(Sender: TObject);
    procedure btnApproveClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure edtChequeAmtEnter(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FChequeAmt: Integer;
    FKindCode: string;
    FCheckResult: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure SetCheckResult(const AValue: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property CheckResult: Boolean read FCheckResult write SetCheckResult default False;
  end;

implementation

uses
  { Native }
  Vcl.Dialogs, System.Variants,
  { VAN }
  uVanDaemonModule,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPPaymentChequeForm }

constructor TBPPaymentChequeForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  (*
  edtChequeAmt.Value := 100000;
  edtChequeNo.Text := '61958825';
  edtBankCode.Text := '88';
  edtBranchCode.Text := '2394';
  edtIssueYear.Text := '2015';
  edtIssueMonth.Text := '07';
  edtIssueDay.Text := '10';
  *)
  FOwnerId := 0;
  FChequeAmt := 100000;
  FKindCode := '13'; //10만원
  CheckResult := False;

  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  btnChequeAmt1.HelpKeyword := '13'; //10만원
  btnChequeAmt1.Tag := 100000;
  btnChequeAmt2.HelpKeyword := '14'; //30만원
  btnChequeAmt2.Tag := 300000;
  btnChequeAmt3.HelpKeyword := '15'; //50만원
  btnChequeAmt3.Tag := 500000;
  btnChequeAmt4.HelpKeyword := '16'; //100만원
  btnChequeAmt4.Tag := 1000000;
  btnChequeAmtEtc.HelpKeyword := '19'; //기타금액
  edtIssueYear.Text := Copy(Global.DateTime.CurrentDate, 1, 4);
  edtIssueMonth.Text := Copy(Global.DateTime.CurrentDate, 5, 2);
  edtIssueDay.Text := Copy(Global.DateTime.CurrentDate, 7, 2);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPPaymentChequeForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPPaymentChequeForm.PluginModuleActivate(Sender: TObject);
begin
  with edtChequeAmt do
  begin
    SelStart := Length(Text) + 1;
    Self.SetFocus;
  end;
end;

procedure TBPPaymentChequeForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPPaymentChequeForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPPaymentChequeForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TBPPaymentChequeForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      if (ActiveControl is TCustomEdit) then
        TCustomEdit(ActiveControl).Clear;
    VK_RETURN:
      btnApprove.Click;
    VK_ESCAPE:
      Self.Close;
  end;
end;

procedure TBPPaymentChequeForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPPaymentChequeForm.edtChequeAmtChange(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
  begin
    if VarIsNull(Value) then
      Value := 0;
    FChequeAmt := Trunc(Value);
    Text := FormatCurr('#,##0', FChequeAmt);
    SelStart := Length(Text) + 1;
  end;
end;

procedure TBPPaymentChequeForm.edtChequeAmtEnter(Sender: TObject);
begin
  with TDBNumberEditEh(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TBPPaymentChequeForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPPaymentChequeForm.OnChequeAmtButtonClick(Sender: TObject);
begin
  with TSpeedButton(Sender) do
  begin
    FKindCode := HelpKeyword;
    edtChequeAmt.Value := Tag;
  end;
end;

procedure TBPPaymentChequeForm.btnChequeAmtEtcClick(Sender: TObject);
begin
  with TSpeedButton(Sender) do
    FKindCode := HelpKeyword;
  FChequeAmt := 0;
  edtChequeAmt.SetFocus;
end;

procedure TBPPaymentChequeForm.btnCheckClick(Sender: TObject);
var
  CR: TChequeRec;
  sResMsg: string;
begin
  try
    CR.ChequeNo := edtChequeNo.Text;
    CR.KindCode := FKindCode;
    CR.ChequeAmt := FChequeAmt;
    CR.BankCode := edtBankCode.Text;
    CR.BranchCode := edtBranchCode.Text;
    CR.AccountCode := edtAccountCode.Text;
    CR.AccountNo := edtAccountNo.Text;
    CR.RegDate := Format('%.4d%.2d%.2d', [StrToIntDef(edtIssueYear.Text, 0), StrToIntDef(edtIssueMonth.Text, 0), StrToIntDef(edtIssueDay.Text, 0)]);
    CheckResult := BPDM.CheckCheque(CR, sResMsg);
    edtResultMsg.Text := sResMsg;
    if not CheckResult then
      raise Exception.Create(sResMsg);
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', '사용 가능한 수표입니다.' + _BR + '이 수표를 결제에 사용하시겠습니까?', ['예', '아니오']) = mrOK) then
      btnApprove.Click;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '사용 불가능한 수표입니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPPaymentChequeForm.btnApproveClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if CheckResult then
  begin
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_CHEQUE_APPPLY;
      PM.AddParams(CPP_CHEQUE_NO, edtChequeNo.Text);
      PM.AddParams(CPP_VALUE, FChequeAmt);
      ModalResult := mrOK;
    finally
      FreeAndNil(PM);
    end;
  end;
end;

procedure TBPPaymentChequeForm.SetCheckResult(const AValue: Boolean);
begin
  if (FCheckResult <> AValue) then
  begin
    FCheckResult := AValue;
    btnApprove.Enabled := FCheckResult;
    edtChequeAmt.Enabled := (not FCheckResult);
    edtChequeNo.Enabled := (not FCheckResult);
    edtChequeAmt.Enabled := (not FCheckResult);
    edtBankCode.Enabled := (not FCheckResult);
    edtBranchCode.Enabled := (not FCheckResult);
    edtAccountCode.Enabled := (not FCheckResult);
    edtAccountNo.Enabled := (not FCheckResult);
    edtIssueYear.Enabled := (not FCheckResult);
    edtIssueMonth.Enabled := (not FCheckResult);
    edtIssueDay.Enabled := (not FCheckResult);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPPaymentChequeForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.