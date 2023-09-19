unit Frame.FullPopup.Phone;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, Frame.KeyBoard, FMX.Layouts;

type
  TFullPopupPhone = class(TFrame)
    Image: TImage;
    recTop: TRectangle;
    txtTitle: TText;
    Rectangle2: TRectangle;
    recBottom: TRectangle;
    KeyBoard1: TKeyBoard;
    recPhone: TRectangle;
    txtPhoneNumber: TText;
    txtTime: TText;
    txtEtc: TText;
    recClose: TRectangle;
    Image14: TImage;
    recOk: TRectangle;
    LayoutBG: TLayout;
    BGRectangle: TRectangle;
    LayoutBody: TLayout;
    txtOk: TText;
    Text1: TText;
    imgQR: TImage;
    Text2: TText;
    recQR: TRectangle;
    procedure Rectangle5Click(Sender: TObject);
    procedure recTopClick(Sender: TObject);
    procedure recCloseClick(Sender: TObject);
  private
    { Private declarations }
    FKeyStr: string;
    FPhoneNumber: string;
  public
    { Public declarations }
    procedure ChangeKey(AKey: string);
    procedure CloseFrame;
    procedure SetPromotionCode(ACode: string);
  end;

implementation

uses
  Form.Full.Popup, uCommon, uGlobal, uStruct, uConsts, uFunction,
  Frame.KeyBoard.Item.Style;

{$R *.fmx}

{ TXGolfMember }

procedure TFullPopupPhone.ChangeKey(AKey: string);
var
  Index, Loop: Integer;
begin

  FKeyStr := '01' + Copy(AKey, 1, 9);
  FKeyStr := Trim(FKeyStr);
  Index := 0;
  if Length(FKeyStr) <> 0 then
  begin
    for Index := 0 to Length(FKeyStr) - 1 do
    begin

      if Index = 10 then
      begin

        recOk.Enabled := True;
      end;
    end;
  end;
end;

procedure TFullPopupPhone.CloseFrame;
begin
  KeyBoard1.CloseFrame;
  KeyBoard1.Free;
end;

procedure TFullPopupPhone.recCloseClick(Sender: TObject);
begin
  FullPopup.CloseFormStrMrCancel;
end;

procedure TFullPopupPhone.recTopClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TFullPopupPhone.Rectangle5Click(Sender: TObject);
var
  CloseFormOk: Boolean;
  sResult: string;
	AMember: TMemberInfo;
	I: Integer;
begin
	CloseFormOk := False;

	if Length(FPhoneNumber) < 11 then
		Exit;

	AMember := Global.SaleModule.SearchPhoneMember(FPhoneNumber);
	if AMember.MobileNo = '' then //ksj 230728 회원목록중 해당 전화번호 없을때
	begin
		FullPopup.edtNumber.Text := EmptyStr;
		SetPromotionCode(EmptyStr);
		Exit;
	end;

	//ksj 230908
	if Global.LocalApi.MemberAssignCheck(AMember.Code) then
	begin
		Global.SBMessage.ShowMessage('11', '알림', '동일 회원 배정 또는 예약 상태입니다.');
		FullPopup.edtNumber.Text := EmptyStr;
		SetPromotionCode(EmptyStr);
		Exit;
	end;

	//ksj 230726 하나에 주문에 같은 회원 중복불가
	for I := 0 to Global.SaleModule.BuyProductList.Count - 1 do
	begin
		if Global.SaleModule.BuyProductList[I].MemberInfo.MobileNo = '' then
			Continue
		else if Global.SaleModule.BuyProductList[I].MemberInfo.MobileNo = FPhoneNumber then
		begin
			Global.SBMessage.ShowMessage('11', '알림', '동일 회원 중복 인증 불가합니다.');
			FullPopup.edtNumber.Text := EmptyStr;
			SetPromotionCode(EmptyStr);
			Exit;
		end;
//			FullPopup.CloseFormStrMrCancel;
	end;

  if AMember.Code <> EmptyStr then
    CloseFormOk := True;

  if CloseFormOk then
  begin
    if Global.SaleModule.memberItemType = mitChange then
      FullPopup.GetMemberInfo('', AMember)
    else
    begin
      Global.SaleModule.Member := AMember;
      FullPopup.CloseFormStrMrok('');
    end;
  end
  else
		FullPopup.CloseFormStrMrCancel;
end;

procedure TFullPopupPhone.SetPromotionCode(ACode: string);
var
  Code1, Code2, Code3: string;
  Index: Integer;
begin
  FPhoneNumber := ACode;

  if Trim(FPhoneNumber) = EmptyStr then
  begin
    txtPhoneNumber.Text := '휴대폰번호 입력';
    txtPhoneNumber.TextSettings.FontColor := $FFD9D9D9;

    TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[9]).KeyRectangle.Fill.Color := $FFB1BBFB;
    TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[9]).Text.Color := $FF212225;
    TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[11]).KeyRectangle.Fill.Color := $FFB1BBFB;
    TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[11]).imgDel.Visible := True;
    TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[11]).imgDelWhite.Visible := False;

    Exit;
  end;

  if Length(FPhoneNumber) < 11 then
  begin
    recOk.Fill.Color := $FFD9D9D9;
    txtOk.TextSettings.FontColor := $FF909092;
  end
  else
  begin
    recOk.Fill.Color := $FF3D55F5;
    txtOk.TextSettings.FontColor := TAlphaColorRec.White;
  end;

  TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[9]).KeyRectangle.Fill.Color := $FF4F515E;
  TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[9]).Text.Color := $FFFFFFFF;
  TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[11]).KeyRectangle.Fill.Color := $FF4F515E;
  TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[11]).imgDel.Visible := False;
  TKeyBoardItemStyle(KeyBoard1.KeyRectangle.Children[11]).imgDelWhite.Visible := True;

  txtPhoneNumber.TextSettings.FontColor := $FF212225;

  Code1 := Trim(Copy(ACode, 1, 3));
  Code2 := Trim(Copy(ACode, 4, 4));
  Code3 := Trim(Copy(ACode, 8, 4));

  txtPhoneNumber.Text := Code1;

  if Code2 <> EmptyStr then
    txtPhoneNumber.Text := Format('%s-%s', [txtPhoneNumber.Text, Code2]);
  if Code3 <> EmptyStr then
    txtPhoneNumber.Text := Format('%s-%s', [txtPhoneNumber.Text, Code3]);
end;

end.
