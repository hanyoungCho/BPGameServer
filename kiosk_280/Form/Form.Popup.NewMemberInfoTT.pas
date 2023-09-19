unit Form.Popup.NewMemberInfoTT;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Winapi.Windows, Winapi.Messages,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  uTabTipHelper;

type
  TfrmNewMemberInfoTT = class(TForm)
    recBG: TRectangle;
    Layout: TLayout;
    recBodyBG: TRectangle;
    recPhone: TRectangle;
    Text1: TText;
    edtPhone: TEdit;
    recName: TRectangle;
    Text2: TText;
    recBtn: TRectangle;
    recClose: TRectangle;
    Text17: TText;
    recAdd: TRectangle;
    txtOk: TText;
    Rectangle1: TRectangle;
    recTabTip1: TRectangle;
    recBirthday: TRectangle;
    Text4: TText;
    edtBirthday: TEdit;
    recTabTip2: TRectangle;
    Text3: TText;
    recNameBG: TRectangle;
    edtName: TEdit;
    recBirthDayBG: TRectangle;
    recPhoneBG: TRectangle;
    recTabTip3: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure recAddClick(Sender: TObject);
    procedure recCloseClick(Sender: TObject);
    procedure recTabTip1Click(Sender: TObject);
    procedure edtBirthdayCanFocus(Sender: TObject; var ACanFocus: Boolean);
    procedure edtNameCanFocus(Sender: TObject; var ACanFocus: Boolean);
    procedure edtPhoneCanFocus(Sender: TObject; var ACanFocus: Boolean);
    procedure edtPhoneChangeTracking(Sender: TObject);
    procedure edtBirthdayChangeTracking(Sender: TObject);
    procedure edtNameChangeTracking(Sender: TObject);
  private
    { Private declarations }
    TabTip: TTabTip;

    procedure NameFocus(AType: String);
    procedure BirthdayFocus(AType: String);
    procedure PhoneFocus(AType: String);
    procedure ChkBtnOk;

    function NumberCheck(AStr: String): Boolean;
  public
    { Public declarations }
  end;

var
  frmNewMemberInfoTT: TfrmNewMemberInfoTT;

implementation

uses
  uGlobal, uCommon, uConsts, uStruct, fx.Logging;

{$R *.fmx}

procedure TfrmNewMemberInfoTT.FormCreate(Sender: TObject);
var
  AHWND: HWND;
  //TrayButtonWindow: THandle;
begin
  AHWND := THandle(Self.Handle);
  TabTip.Launch(AHWND);

  edtName.SetFocus;
end;

procedure TfrmNewMemberInfoTT.FormDestroy(Sender: TObject);
begin

  if TabTip.IsVisible then
  begin
    TabTip.Close;
    TabTip.Termiante;
    Log.D('TabTip', 'Close !');
  end;

  SetCursorPos(1040, 1540); //마우스 커서가 가야 할 버튼의 위치
  Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
  Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);

  sleep(100);

  SetCursorPos(1040, 1540); //마우스 커서가 가야 할 버튼의 위치
  Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
  Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
end;

procedure TfrmNewMemberInfoTT.edtNameCanFocus(Sender: TObject; var ACanFocus: Boolean);
begin
  NameFocus('1');
  BirthdayFocus('0');
  PhoneFocus('0');
end;
procedure TfrmNewMemberInfoTT.edtNameChangeTracking(Sender: TObject);
begin
  ChkBtnOk;
end;

procedure TfrmNewMemberInfoTT.edtBirthdayCanFocus(Sender: TObject; var ACanFocus: Boolean);
begin
  NameFocus('0');
  BirthdayFocus('1');
  PhoneFocus('0');
end;
procedure TfrmNewMemberInfoTT.edtBirthdayChangeTracking(Sender: TObject);
begin
  ChkBtnOk;
end;

procedure TfrmNewMemberInfoTT.edtPhoneCanFocus(Sender: TObject; var ACanFocus: Boolean);
begin
  NameFocus('0');
  BirthdayFocus('0');
  PhoneFocus('1');
end;

procedure TfrmNewMemberInfoTT.edtPhoneChangeTracking(Sender: TObject);
begin
  ChkBtnOk;
end;

procedure TfrmNewMemberInfoTT.NameFocus(AType: String);
begin
  if AType = '0' then
  begin
    recNameBG.Stroke.Color := $FFA6A7A8;
    edtName.TextSettings.FontColor := $FFD9D9D9;
  end
  else
  begin
    recNameBG.Stroke.Color := $FF3D55F5;
    edtName.TextSettings.FontColor := $FF212225;
  end;
end;

procedure TfrmNewMemberInfoTT.BirthdayFocus(AType: String);
begin
  if AType = '0' then
  begin
    recBirthDayBG.Stroke.Color := $FFA6A7A8;
    edtBirthday.TextSettings.FontColor := $FFD9D9D9;

    if Trim(edtBirthday.Text) = EmptyStr then
      edtBirthday.Text := '예시 19891004';
  end
  else
  begin
    recBirthDayBG.Stroke.Color := $FF3D55F5;
    edtBirthday.TextSettings.FontColor := $FF212225;

    if Trim(edtBirthday.Text) = '예시 19891004' then
      edtBirthday.Text := '';
  end;
end;

procedure TfrmNewMemberInfoTT.PhoneFocus(AType: String);
begin
  if AType = '0' then
  begin
    recPhoneBG.Stroke.Color := $FFA6A7A8;
    edtPhone.TextSettings.FontColor := $FFD9D9D9;

    if Trim(edtPhone.Text) = EmptyStr then
      edtPhone.Text := '휴대번호 입력';
  end
  else
  begin
    recPhoneBG.Stroke.Color := $FF3D55F5;
    edtPhone.TextSettings.FontColor := $FF212225;

    if Trim(edtPhone.Text) = '휴대번호 입력' then
      edtPhone.Text := '';
  end;
end;

procedure TfrmNewMemberInfoTT.ChkBtnOk;
var
  bName, bBirth, bPhone: Boolean;
begin
  bName := True;
  bBirth := True;
  bPhone := True;

  if Trim(edtName.Text) = EmptyStr then
    bName := False;
  if (Trim(edtBirthday.Text) = EmptyStr) or (Trim(edtBirthday.Text) = '예시 19891004') then
    bBirth := False;
  if (Trim(edtPhone.Text) = EmptyStr) or (Trim(edtPhone.Text) = '휴대번호 입력') then
    bPhone := False;

  if (bName = True) and (bBirth = True) and (bPhone = True) then
  begin
    recAdd.Fill.Color := $FF3D55F5;
    txtOk.TextSettings.FontColor := TAlphaColorRec.White;
  end
  else
  begin
    recAdd.Fill.Color := $FFD9D9D9;
    txtOk.TextSettings.FontColor := $FF909092;
  end;
end;

procedure TfrmNewMemberInfoTT.recAddClick(Sender: TObject);
var
  sName, sBirthday, sPhone: String;
  bMember: Boolean;
  Index: Integer;
  NewMember: TMemberInfo;
begin
  if recAdd.Fill.Color = $FFD9D9D9 then
    Exit;
  {
  if Trim(edtName.Text) = EmptyStr then
  begin
    Global.SBMessage.ShowMessage('11', '알림', '이름을 입력해주세요');
    edtName.SetFocus;
    Exit;
  end;

  if Trim(edtBirthday.Text) = '예시 891004' then
  begin
    Global.SBMessage.ShowMessage('11', '알림', '생년월일을 입력해주세요');
    edtBirthday.SetFocus;
    Exit;
  end;

  if Trim(edtPhone.Text) = '휴대번호 입력' then
  begin
    Global.SBMessage.ShowMessage('11', '알림', '휴대폰번호를 입력해주세요');
    edtPhone.SetFocus;
    Exit;
  end;
  }
  sName := Trim(edtName.Text);
  sBirthday := Trim(edtBirthday.Text);
  sPhone := Trim(edtPhone.Text);

  //ksj 230821 생년월일,휴대폰번호 글자수 제한
	if Length(sBirthday) <> 8 then
	begin
		edtBirthday.SetFocus;
		Exit;
	end;
	if Length(sPhone) <> 11 then
	begin
		edtPhone.SetFocus;
		Exit;
	end;

  //생년월일
  if NumberCheck(sBirthday) = False then
  begin
    Global.SBMessage.ShowMessage('11', '알림', MSG_NEWMEMBER_BIRTHDAY_FAIL);
    edtBirthday.SetFocus;
    Exit;
  end;

  //휴대폰번호
  if NumberCheck(sPhone) = False then
  begin
    Global.SBMessage.ShowMessage('11', '알림', MSG_NEWMEMBER_PHONE_FAIL);
    edtPhone.SetFocus;
    Exit;
  end;

	bMember := False; //True면 동일정보 회원이 있다는거
	for Index := 0 to Global.SaleModule.MemberUpdateList.Count - 1 do
  begin
    if not Global.SaleModule.MemberUpdateList[Index].Use then
			Continue;

		if Global.SaleModule.MemberUpdateList[Index].MobileNo = sPhone then
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

			if Global.SaleModule.MemberList[Index].MobileNo = sPhone then
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
    Global.SBMessage.ShowMessage('11', '알림', MSG_NEWMEMBER_USE);
    Exit;
  end;

  NewMember.Name := sName;
  NewMember.MobileNo := sPhone;
  NewMember.BirthDay := sBirthday;
  Global.SaleModule.NewMember := NewMember;

  ModalResult := mrOk;
end;

procedure TfrmNewMemberInfoTT.recCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmNewMemberInfoTT.recTabTip1Click(Sender: TObject);
var
  AHWND: HWND;
  TrayButtonWindow: THandle;
begin

  if TabTip.IsVisible then
  begin
    TabTip.Close;
    TabTip.Termiante;
    Log.D('TabTip', 'Close !');
  end;

  AHWND := THandle(Self.Handle);
  TabTip.Launch(AHWND);
end;

function TfrmNewMemberInfoTT.NumberCheck(AStr: String): Boolean;
var
  Index: Integer;
begin
  Result := True;

  for Index := 1 to Length(AStr) do
  begin
    if not CharInSet(AStr[Index], ['0'..'9']) then begin
      Result := False;
      Break;
    end;
  end;

end;

end.
