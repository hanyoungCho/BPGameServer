unit Form.Popup.NewMemberInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Winapi.Windows, Winapi.Messages, ShellAPI, IMM, FMX.Layouts, FMX.Objects,
  FMX.Controls, FMX.Controls.Presentation, FMX.Edit, FMX.Forms, FMX.Types,
  VirtualKeyboard.Qwerty.FrameStyle, FMX.StdCtrls;

type
  TfrmNewMemberInfo = class(TForm)
    recTop: TRectangle;
    Text3: TText;
    Rectangle4: TRectangle;
    Text1: TText;
    Rectangle5: TRectangle;
    Text2: TText;
    recBtn: TRectangle;
    Rectangle11: TRectangle;
    Image3: TImage;
    Text17: TText;
    recAdd: TRectangle;
    Image4: TImage;
    Text18: TText;
    recKiboad: TRectangle;
    edtName: TEdit;
    Layout: TLayout;
    edtPhone: TEdit;
    VirtualKeyboardQwertyStyle1: TVirtualKeyboardQwertyStyle;
    Rectangle7: TRectangle;
    Label1: TLabel;
    Timer1: TTimer;
    Rectangle: TRectangle;
    laError: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Rectangle11Click(Sender: TObject);
    procedure recAddClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetHangulMode(AHangle: Boolean);
  end;

var
  frmNewMemberInfo: TfrmNewMemberInfo;

implementation

uses
  uGlobal, uCommon, uConsts, uStruct;

{$R *.fmx}

procedure TfrmNewMemberInfo.SetHangulMode(AHangle: Boolean);
var
  Data: HIMC;
begin
  //Data := ImmGetContext(THandle(Self.Handle));
  Data := ImmGetContext(global.MainHandle);

  if AHangle then
    ImmSetConversionStatus(Data, IME_CMODE_NATIVE, 0)        // 한글상태로 세팅
  else
    ImmSetConversionStatus(Data, IME_CMODE_ALPHANUMERIC, 0); // 영문상태로 셋팅

  //ImmReleaseContext(THandle(Self.Handle), Data);
  ImmReleaseContext(global.MainHandle, Data);
end;

procedure TfrmNewMemberInfo.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  SetHangulMode(True);
end;

procedure TfrmNewMemberInfo.FormCreate(Sender: TObject);
var
  AHWND: HWND;
begin
  AHWND := THandle(Self.Handle);
  //ShellExecute(AHWND, 'open', PWideChar(ExtractFilePath(ParamStr(0)) + 'Call\KioskCall.exe'), nil, nil, SW_NORMAL);
  //ShellExecute(AHWND, 'open', 'c:\\windows\\system32\\osk.exe', nil, nil, SW_SHOWNORMAL);

  laError.text := '';
  edtName.SetFocus;
  VirtualKeyboardQwertyStyle1.VirtualKeyboardQwertyKeyIMEStyle.ExecutePress;
end;

procedure TfrmNewMemberInfo.FormActivate(Sender: TObject);
begin
  //SetHangulMode(True);
  //Timer1.Enabled := True;
end;

procedure TfrmNewMemberInfo.FormDestroy(Sender: TObject);
begin
  //SetHangulMode(False); // 영문상태로
  VirtualKeyboardQwertyStyle1.VirtualKeyboardQwertyKeyIMEStyle.ExecutePress;
end;

procedure TfrmNewMemberInfo.Rectangle11Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmNewMemberInfo.recAddClick(Sender: TObject);
var
  sName, sPhone, sPhoneCheck, sPhoneTemp: String;
  bNum, bMember: Boolean;
  Index: Integer;
  NewMember: TMemberInfo;
begin

  if (Trim(edtName.Text) = '') or (Trim(edtPhone.Text) = '') then
  begin
    //Global.SBMessage.ShowMessageModalForm(MSG_NEWMEMBER_NULL);
    laError.Text := MSG_NEWMEMBER_NULL;
    Exit;
  end;

  sName := Trim(edtName.Text);
  sPhone := Trim(edtPhone.Text);

  bNum := True;

  sPhoneCheck := StringReplace(sPhone, '-', '', [rfReplaceAll]);
  for Index := 1 to Length(sPhoneCheck) do
  begin
    if not CharInSet(sPhoneCheck[Index], ['0'..'9']) then begin
      bNum := False;
      Break;
    end;
  end;

  if bNum = False then
  begin
    //Global.SBMessage.ShowMessageModalForm(MSG_NEWMEMBER_PHONE_FAIL);
    laError.Text := MSG_NEWMEMBER_PHONE_FAIL;
    Exit;
  end;

  bMember := False;
  for Index := 0 to Global.SaleModule.MemberUpdateList.Count - 1 do
  begin
    if not Global.SaleModule.MemberUpdateList[Index].Use then
      Continue;

    if Global.SaleModule.MemberUpdateList[Index].Name <> sName then
      Continue;

    sPhoneTemp := StringReplace(Global.SaleModule.MemberUpdateList[Index].MobileNo, '-', '', [rfReplaceAll]);
    if sPhoneTemp = sPhoneCheck then
    begin
      bMember := True;
      //Log.D('MemberUpdateList 회원명', Global.SaleModule.MemberUpdateList[Index].Name);
      //Log.D('MemberUpdateList 회원지문', Global.SaleModule.MemberUpdateList[Index].FingerStr);
      //Global.SaleModule.Member := Global.SaleModule.MemberUpdateList[Index];
      Break;
    end;
  end;

  if not bMember then
  begin
    for Index := 0 to Global.SaleModule.MemberList.Count - 1 do
    begin
      if not Global.SaleModule.MemberList[Index].Use then
        Continue;

      if Global.SaleModule.MemberList[Index].Name <> sName then
        Continue;

      sPhoneTemp := StringReplace(Global.SaleModule.MemberList[Index].MobileNo, '-', '', [rfReplaceAll]);
      if sPhoneTemp = sPhoneCheck then
      begin
        bMember := True;
        //Log.D('MemberList 회원명', Global.SaleModule.MemberList[Index].Name);
        //Log.D('MemberList 회원지문', Global.SaleModule.MemberList[Index].FingerStr);
        //Global.SaleModule.Member := Global.SaleModule.MemberList[Index];
        Break;
      end;
    end;
  end;

  if bMember = True then
  begin
    //Global.SBMessage.ShowMessageModalForm(MSG_NEWMEMBER_USE);
    laError.Text := MSG_NEWMEMBER_USE;
    Exit;
  end;

  NewMember.Name := sName;
  NewMember.MobileNo := sPhoneCheck;
  Global.SaleModule.NewMember := NewMember;

  ModalResult := mrOk;
end;

end.
