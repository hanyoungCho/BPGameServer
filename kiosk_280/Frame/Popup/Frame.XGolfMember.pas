unit Frame.XGolfMember;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, Frame.KeyBoard;

type
  TXGolfMember = class(TFrame)
    Image: TImage;
    Rectangle1: TRectangle;
    txtTitle: TText;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Text4: TText;
    Text5: TText;
    KeyBoard1: TKeyBoard;
    PhoneRec: TRectangle;
    Image1: TImage;
    txtPw5: TText;
    Image10: TImage;
    txtPw10: TText;
    Image11: TImage;
    txtPw11: TText;
    Image2: TImage;
    txtPw6: TText;
    Image3: TImage;
    txtPw1: TText;
    Image4: TImage;
    txtPw2: TText;
    Image5: TImage;
    txtPw3: TText;
    Image6: TImage;
    txtPw4: TText;
    Image7: TImage;
    txtPw7: TText;
    Image8: TImage;
    txtPw8: TText;
    Image9: TImage;
    txtPw9: TText;
    ButtonTwolRectangle: TRectangle;
    Rectangle11: TRectangle;
    Image14: TImage;
    Text17: TText;
    PromoRec: TRectangle;
    Rectangle5: TRectangle;
    txtPromotionCode: TText;
    Rectangle12: TRectangle;
    Image15: TImage;
    Text18: TText;
    recPolicy: TRectangle;
    Text1: TText;
    Text2: TText;
    imgPolicyAll: TImage;
    txtTime: TText;
    recParkingPrint: TRectangle;
    imgPark04: TImage;
    txtPark04: TText;
    imgPark10: TImage;
    txtPark10: TText;
    imgPark11: TImage;
    txtPark11: TText;
    imgPark05: TImage;
    txtPark05: TText;
    imgPark01: TImage;
    txtPark01: TText;
    imgPark02: TImage;
    txtPark02: TText;
    imgPark07: TImage;
    txtPark07: TText;
    imgPark03: TImage;
    txtPark03: TText;
    imgPark06: TImage;
    txtPark06: TText;
    imgPark08: TImage;
    txtPark08: TText;
    imgPark09: TImage;
    txtPark09: TText;
    Text20: TText;
    Text21: TText;
    imgPark12: TImage;
    txtPark12: TText;
    procedure Rectangle4Click(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
  private
    { Private declarations }
    FKeyStr: string;
    FPromotionCode: string;
  public
    { Public declarations }
    procedure ChangeKey(AKey: string);
    procedure CloseFrame;
    procedure SetPromotionCode(ACode: string);
  end;

implementation

uses
  Form.Popup, uCommon, uGlobal, uStruct, uConsts, uFunction;

{$R *.fmx}

{ TXGolfMember }

procedure TXGolfMember.ChangeKey(AKey: string);
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
      if Index = 2 then
        txtPw3.Text := FKeyStr[Index + 1]
      else if Index = 3 then
        txtPw4.Text := FKeyStr[Index + 1]
      else if Index = 4 then
        txtPw5.Text := FKeyStr[Index + 1]
      else if Index = 5 then
        txtPw6.Text := FKeyStr[Index + 1]
      else if Index = 6 then
        txtPw7.Text := FKeyStr[Index + 1]
      else if Index = 7 then
        txtPw8.Text := FKeyStr[Index + 1]
      else if Index = 8 then
        txtPw9.Text := FKeyStr[Index + 1]
      else if Index = 9 then
        txtPw10.Text := FKeyStr[Index + 1]
      else if Index = 10 then
        txtPw11.Text := FKeyStr[Index + 1];
    end;
  end;

  for Loop := Index to 11 - 1 do
  begin
    if Loop = 2 then
      txtPw3.Text := EmptyStr
    else if Loop = 3 then
      txtPw4.Text := EmptyStr
    else if Loop = 4 then
      txtPw5.Text := EmptyStr
    else if Loop = 5 then
      txtPw6.Text := EmptyStr
    else if Loop = 6 then
      txtPw7.Text := EmptyStr
    else if Loop = 7 then
      txtPw8.Text := EmptyStr
    else if Loop = 8 then
      txtPw9.Text := EmptyStr
    else if Loop = 9 then
      txtPw10.Text := EmptyStr
    else if Loop = 10 then
      txtPw11.Text := EmptyStr;
  end;

end;

procedure TXGolfMember.CloseFrame;
begin
  KeyBoard1.CloseFrame;
  KeyBoard1.Free;
end;

procedure TXGolfMember.Rectangle1Click(Sender: TObject);
begin
  TouchSound;
end;

procedure TXGolfMember.Rectangle4Click(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TXGolfMember.Rectangle5Click(Sender: TObject);
var
  CloseFormOk: Boolean;
  sResult: string;
  AMember: TMemberInfo;
begin
  CloseFormOk := False;

  if PhoneRec.Visible then
  begin
    {
    if (Global.SaleModule.AdvertPopupType = apEvent) and //이벤트 모드 이고
       (global.Config.AdvertEventXGolf = False) then //xgolf 회원인증을 않하면
    begin
      Global.SaleModule.allianceNumber := FKeyStr;
      CloseFormOk := True;
    end   }
    //else if ((Global.SaleModule.memberItemType = mitperiod) and (Global.Config.MobileOAuth = True)) or
    //        (Global.SaleModule.PaymentAddType = patFacilityPeriod) then
    if (Global.SaleModule.memberItemType = mitperiod) and (Global.Config.MobileOAuth = True) then
    begin
      if Length(FKeyStr) < 11 then
      begin
        Global.SBMessage.ShowMessageModalForm('핸드폰 번호 11자리를 입력해 주세요');
        Exit;
      end;

      AMember := Global.SaleModule.SearchPhoneMember(FKeyStr);

      if AMember.Code <> EmptyStr then
      begin
        Global.SaleModule.Member := AMember;
        CloseFormOk := True;
      end;
    end
    else
    begin

      if Global.SaleModule.CheckXGolfMemberPhone(FKeyStr) then
      begin
        if Global.SaleModule.AdvertPopupType = apEvent then
        begin

        end
        else
        begin
          AMember := Global.SaleModule.Member;

          Global.SaleModule.Member := AMember;
        end;
        CloseFormOk := True;
      end;

    end;
  end
  else if recParkingPrint.Visible then
  begin
    if Length(FKeyStr) < 12 then
    begin
      Global.SBMessage.ShowMessageModalForm('예약번호 12자리를 입력해 주세요');
      Exit;
    end;

    sResult := Global.LocalApi.ParkingPrintCheck(FKeyStr);
    if sResult <> 'Success' then
    begin
      Global.SBMessage.ShowMessageModalForm(sResult);
      Exit;
    end;

    CloseFormOk := True;
  end
  else
  begin
    if Global.Database.SearchPromotion(FPromotionCode) then
      CloseFormOk := True
  end;

  if CloseFormOk then
    Popup.CloseFormStrMrok('')
  else
    Popup.CloseFormStrMrCancel;
end;

procedure TXGolfMember.SetPromotionCode(ACode: string);
var
  Code1, Code2, Code3, Code4: string;
begin
  FPromotionCode := ACode;
  Code1 := Trim(Copy(ACode, 1, 4));
  Code2 := Trim(Copy(ACode, 5, 4));
  Code3 := Trim(Copy(ACode, 9, 4));
  Code4 := Trim(Copy(ACode, 13, 4));

  txtPromotionCode.Text := Code1;

  if Code2 <> EmptyStr then
    txtPromotionCode.Text := Format('%s-%s', [txtPromotionCode.Text, Code2]);
  if Code3 <> EmptyStr then
    txtPromotionCode.Text := Format('%s-%s', [txtPromotionCode.Text, Code3]);
  if Code4 <> EmptyStr then
    txtPromotionCode.Text := Format('%s-%s', [txtPromotionCode.Text, Code4]);
end;

end.
