unit BPCashReceiptPopup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, DBCtrlsEh;

type
  TBPCashReceiptPopupForm = class(TForm)
    panHeader: TPanel;
    btnClose: TSpeedButton;
    panBody: TPanel;
    Label1: TLabel;
    btnEntityPerson: TSpeedButton;
    btnEntityBiz: TSpeedButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ckbSelfCashReceipt: TCheckBox;
    edtCashAmount: TDBNumberEditEh;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure OnCashEntityButtonClick(Sender: TObject);
  private
    { Private declarations }
    FWorking: Boolean;
    FCashAmount: Integer;
    FIdentifyNo: string;
    FCashEntity: ShortInt;
    FApproveNo: string;

    procedure DoReqCashReceipt;
    procedure SetCashAmount(const AValue: Integer);
  public
    { Public declarations }
    property CashAmount: Integer read FCashAmount write SetCashAmount;
    property IdentifyNo: string read FIdentifyNo write FIdentifyNo;
    property CashEntity: ShortInt read FCashEntity write FCashEntity default 0;
    property ApproveNo: string read FApproveNo write FApproveNo;
  end;

var
  BPCashReceiptPopupForm: TBPCashReceiptPopupForm;

implementation

uses
  { Native }
  System.StrUtils,
  { VAN }
  uVanDaemonModule,
  { Project }
  Common.BPGlobal, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPCashReceiptPopupForm }

procedure TBPCashReceiptPopupForm.FormCreate(Sender: TObject);
begin
  FWorking := False;
  FCashAmount := 0;
  FIdentifyNo := '';
  FCashEntity := CO_CASH_RECEIPT_PERSON;
  FApproveNo := '';

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  btnEntityPerson.Tag := CO_CASH_RECEIPT_PERSON;
  btnEntityBiz.Tag := CO_CASH_RECEIPT_BIZ;

  LF := TLayeredForm.Create(nil);
  LF.Show;
end;

procedure TBPCashReceiptPopupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TBPCashReceiptPopupForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      Self.ModalResult := mrCancel;
  end;
end;

procedure TBPCashReceiptPopupForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPCashReceiptPopupForm.SetCashAmount(const AValue: Integer);
begin
  if (FCashAmount <> AValue) then
  begin
    FCashAmount := AValue;
    edtCashAmount.Value := AValue;
  end;
end;

procedure TBPCashReceiptPopupForm.OnCashEntityButtonClick(Sender: TObject);
begin
  CashEntity := TSpeedButton(Sender).Tag;
end;

procedure TBPCashReceiptPopupForm.btnOKClick(Sender: TObject);
begin
  DoReqCashReceipt;
end;

procedure TBPCashReceiptPopupForm.DoReqCashReceipt;
var
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
  LVat: Integer;
begin
  if FWorking then
    Exit;
  FWorking := True;
  try
    try
      if (CashAmount <= 0) then
        raise Exception.Create('결제금액이 입력되지 않았습니다!');

      LVat := (CashAmount - Trunc(CashAmount / 1.1));
      SI.Approval     := True;
      SI.SaleAmt      := Self.CashAmount;
      SI.FreeAmt      := 0;
      SI.SvcAmt       := 0;
      SI.VatAmt       := LVat;
      SI.OrgAgreeNo   := '';
      SI.OrgAgreeDate := '';
      SI.TerminalID   := Global.TerminalInfo.VanTID;
      SI.BizNo        := Global.StoreInfo.BizNo;
      SI.Person       := Self.CashEntity; //1:개인, 2:사업자
      SI.CardNo       := IfThen(ckbSelfCashReceipt.Checked, '0100001234',  '');
      SI.KeyInput     := (SI.CardNo <> '');
      RI := VanModule.CallCash(SI);
      if not RI.Result then
        raise Exception.Create(RI.Msg);
      IdentifyNo := RI.CardNo;
      ApproveNo := RI.AgreeNo;
      BPMsgBox(Self.Handle, mtInformation, '알림', '현금영수증이 정상 발급 되었습니다.', ['확인'], 5);
    finally
      FWorking := True;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '현금영수증 발행에 실패하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

end.
