unit Frame.Phone;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, Frame.KeyBoard, FMX.Layouts;

type
  TPhone = class(TFrame)
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
  Form.Popup, uCommon, uGlobal, uStruct, uConsts, uFunction;

{$R *.fmx}

{ TXGolfMember }

procedure TPhone.ChangeKey(AKey: string);
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

procedure TPhone.CloseFrame;
begin
  KeyBoard1.CloseFrame;
  KeyBoard1.Free;
end;

procedure TPhone.recCloseClick(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TPhone.recTopClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TPhone.Rectangle5Click(Sender: TObject);
var
  CloseFormOk: Boolean;
  sResult: string;
  AMember: TMemberInfo;
begin
  CloseFormOk := False;

  if Length(FPhoneNumber) < 11 then
  begin
    Exit;
  end;

  AMember := Global.SaleModule.SearchPhoneMember(FPhoneNumber);

  if AMember.Code <> EmptyStr then
  begin
    Global.SaleModule.Member := AMember;
    CloseFormOk := True;
  end;

  if CloseFormOk then
  begin
    if Global.SaleModule.memberItemType = mitChange then
      Popup.GetMemberInfo
    else
      Popup.CloseFormStrMrok('');
  end
  else
    Popup.CloseFormStrMrCancel;
end;

procedure TPhone.SetPromotionCode(ACode: string);
var
  Code1, Code2, Code3: string;
begin
  FPhoneNumber := ACode;

  if Trim(FPhoneNumber) = EmptyStr then
  begin
    txtPhoneNumber.Text := '휴대폰번호 입력';
    txtPhoneNumber.TextSettings.FontColor := $FFD9D9D9;
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
