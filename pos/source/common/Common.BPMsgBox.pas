unit Common.BPMsgBox;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  { SolbiLib }
  DzHTMLText;

{$I Common.BPCommon.inc}

type
  TBPMsgBoxForm = class(TForm)
    panHeader: TPanel;
    btnClose: TSpeedButton;
    panButtonSet: TPanel;
    btnAll: TBitBtn;
    btnNo: TBitBtn;
    btnYes: TBitBtn;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    tmrAutoCloser: TTimer;
    lblTimeOut: TLabel;
    lblHtmlText: TDzHTMLText;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrAutoCloserTimer(Sender: TObject);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
  private
    { Private declarations }
    FTimeOutSecs: Integer;
    FTimeOutCount: Integer;

    procedure CMDialogKey(var AMsg: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Public declarations }
  end;

var
  BPMsgBoxForm: TBPMsgBoxForm;
  FWndHook: HHOOK;
  FActiveButtons: Integer=1;

function CallWndProc(AHookCode: Integer; AwParam: WPARAM; AlParam: LPARAM): LRESULT; stdcall;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string): TModalResult; overload;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string): TModalResult; overload;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean): TModalResult; overload;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const ATimeOutSecs: Integer): TModalResult; overload;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean; const ATimeOutSecs: Integer): TModalResult; overload;

implementation

uses
  System.StrUtils,
  { Project }
  Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

function CallWndProc(AHookCode: Integer; AwParam: WPARAM; AlParam: LPARAM): LRESULT; stdcall;
const
  DialogClass = '#32770';
var
  ClassName: array[0..6] of Char;
  Wnd: HWND;
  Rect: TRect;
  X, Y: Integer;
begin
  if (AHookCode = HC_ACTION) and
    (PCWPStruct(AlParam).message = WM_INITDIALOG) then
  begin
    Wnd := PCWPStruct(AlParam).hwnd;
    if Bool(GetClassName(Wnd, @ClassName, SizeOf(ClassName))) and
      (ClassName = DialogClass) then
    begin
      GetWindowRect(Wnd, Rect);

      X := Screen.ActiveForm.Left + (Screen.ActiveForm.Width - (Rect.Right - Rect.Left)) div 2;
      Y := Screen.ActiveForm.Top + (Screen.ActiveForm.Height - (Rect.Bottom - Rect.Top)) div 2;
      if (Y < 0) then Y := 0;
      SetWindowPos(Wnd, 0, X, Y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
    end;
  end;
  Result := CallNextHookEx(FWndHook, AHookCode, AwParam, AlParam);
end;

function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string): TModalResult; overload;
begin
  Result := BPMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, [], True, 0);
end;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string): TModalResult; overload;
begin
  Result := BPMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, AButtonCaptions, False, 0);
end;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean): TModalResult; overload;
begin
  Result := BPMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, AButtonCaptions, AStandbyMode, 0);
end;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const ATimeOutSecs: Integer): TModalResult; overload;
begin
  Result := BPMsgBox(AParentHandle, AMsgDlgType, ACaption, AMessage, AButtonCaptions, False, ATimeOutSecs);
end;
function BPMsgBox(const AParentHandle: HWND; const AMsgDlgType: TMsgDlgType; const ACaption, AMessage: string; const AButtonCaptions: array of string; const AStandbyMode: Boolean; const ATimeOutSecs: Integer): TModalResult; overload;
var
  R: TRect;
  nLeft: Integer;
begin
  FActiveButtons := Length(AButtonCaptions);
  with TBPMsgBoxForm.Create(nil) do
  try
    DoubleBuffered := True;
    panHeader.Caption := ACaption;
    lblHtmlText.Lines.Text := StringReplace(AMessage, _CRLF, _BR, [rfReplaceAll]);
    btnCancel.Visible := False;
    btnYes.Visible := False;
    btnNo.Visible := False;
    btnAll.Visible := False;

    nLeft := 45;
    if not AStandbyMode then
    begin
      if (FActiveButtons > 0) then
      begin
        btnOK.Visible := True;
        btnOK.Caption := AButtonCaptions[0];
        nLeft := 249;
      end;
      if (FActiveButtons > 1) then
      begin
        btnCancel.Visible := True;
        btnCancel.Caption := AButtonCaptions[1];
        nLeft := 199;
      end;
      if (FActiveButtons > 2) then
      begin
        btnYes.Visible := True;
        btnYes.Caption := AButtonCaptions[2];
        nLeft := 149;
      end;
      if (FActiveButtons > 3) then
      begin
        btnNo.Visible := True;
        btnNo.Caption := AButtonCaptions[3];
        nLeft := 99;
      end;
      if (FActiveButtons > 4) then
      begin
        btnAll.Visible := True;
        btnAll.Caption := AButtonCaptions[4];
        nLeft := 49;
      end;
    end;

    panButtonSet.AutoSize := True;
    panButtonSet.Left := nLeft;
    FWndHook := SetWindowsHookEx(WH_CALLWNDPROC, CallWndProc, 0, GetCurrentThreadId);

    case AMsgDlgType of
      mtWarning:
        MessageBeep(MB_ICONWARNING); //panHeader.Color := $00004080;
      mtError:
        MessageBeep(MB_ICONERROR); //panHeader.Color := $002C24DA;
      mtConfirmation:
        MessageBeep(MB_ICONQUESTION); //panHeader.Color := $000080FF;
      else
        MessageBeep(MB_ICONINFORMATION); //panHeader.Color := $00FF8000;
    end;

    FTimeOutSecs := ATimeOutSecs;
    FTimeOutCount := 0;
    lblTimeOut.Visible := (FTimeOutSecs > 0);
    if (FTimeOutSecs > 0) then
    begin
      tmrAutoCloser.Interval := 1000;
      tmrAutoCloserTimer(tmrAutoCloser);
    end;

    if (AParentHandle = 0) then
      GetWindowRect(Application.MainForm.Handle, R)
    else
      GetWindowRect(AParentHandle, R);
    Left := R.Left + ((R.Right - R.Left) div 2) - (Width div 2);
    Top := R.Top + ((R.Bottom - R.Top) div 2) - (Height div 2);

    Result := ShowModal;
  finally
    if (FWndHook > 0) then
      UnhookWindowsHookEx(fWndHook);
    Free;
  end;
end;

{ TBPMsgBoxForm }

procedure TBPMsgBoxForm.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
end;

procedure TBPMsgBoxForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Release;
end;

procedure TBPMsgBoxForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      ModalResult := mrOK;
    VK_ESCAPE:
      ModalResult := mrCancel;
  end;
end;

procedure TBPMsgBoxForm.tmrAutoCloserTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;

    lblTimeOut.Caption := Format('(%d초 후 이 메시지 창을 닫음)', [FTimeOutSecs - FTimeOutCount]);
    Inc(FTimeOutCount);
    if (FTimeOutCount > FTimeOutSecs) then
      ModalResult := mrOK;
  finally
    Enabled := True;
  end;
end;

procedure TBPMsgBoxForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPMsgBoxForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPMsgBoxForm.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TBPMsgBoxForm.btnOKClick(Sender: TObject);
begin
  Self.ModalResult := mrOK;
end;

procedure TBPMsgBoxForm.btnYesClick(Sender: TObject);
begin
  Self.ModalResult := mrYesToAll;
end;

procedure TBPMsgBoxForm.btnNoClick(Sender: TObject);
begin
  Self.ModalResult := mrNoToAll;
end;

procedure TBPMsgBoxForm.btnAllClick(Sender: TObject);
begin
  Self.ModalResult := mrAll;
end;

procedure TBPMsgBoxForm.CMDialogKey(var AMsg: TCMDialogKey);
begin
  if (AMsg.CharCode = 32) or
     ((AMsg.CharCode in [VK_UP, VK_LEFT]) and btnOK.Focused) or
     ((AMsg.CharCode in [VK_DOWN, VK_RIGHT]) and
      (((FActiveButtons = 1) and btnOK.Focused) or
       ((FActiveButtons = 2) and btnCancel.Focused) or
       ((FActiveButtons = 3) and btnYes.Focused) or
       ((FActiveButtons = 4) and btnNo.Focused) or
       ((FActiveButtons = 5) and btnAll.Focused))) then
    AMsg.Result := 1
  else
    inherited;
end;

end.
