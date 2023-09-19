unit Frame.NewMember.ItemType;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TfrmNewMemberItemType = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
    txtTitle: TText;
    txtTasukInfo: TText;
    ItemTypeRectangle: TRectangle;
    imgItemTypePeriod: TImage;
    txtItemTypePeriod: TText;
    imgItemTypeCoupon: TImage;
    txtItemTypeCoupon: TText;
    CloseRectangle: TRectangle;
    Image4: TImage;
    txtClose: TText;
    txtTime: TText;
    Timer: TTimer;
    MenuTypeRectangle: TRectangle;
    Image3: TImage;
    Text2: TText;
    Image5: TImage;
    Text3: TText;
    NewMemberRectangle: TRectangle;
    Image1: TImage;
    Text1: TText;
    procedure CloseRectangleClick(Sender: TObject);
    procedure imgItemTypePeriodClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iSec: Integer;
  end;

implementation

uses
  Form.Popup, uConsts, uGlobal, uFunction, uCommon;

{$R *.fmx}

procedure TfrmNewMemberItemType.CloseRectangleClick(Sender: TObject);
begin
  TouchSound;
  Timer.Enabled := False;
  Popup.CloseFormStrMrCancel;
end;

procedure TfrmNewMemberItemType.imgItemTypePeriodClick(Sender: TObject);
begin
  TouchSound;
  Timer.Enabled := False;

  if Global.SaleModule.PopUpLevel = plFacilityProduct then
  begin
    if TImage(Sender).Tag = 1 then
    begin
      Global.SaleModule.PaymentAddType := patFacilityPeriod;
      //Popup.FacilityProductAuth; //번호 인증
      Popup.CloseFormStrMrok('');
    end
    else
    begin
      Global.SaleModule.PaymentAddType := patFacilityDay;
      Popup.CloseFormStrMrok('');
    end;
  end
  else
  begin
    if (Global.Config.Store.StoreCode <> 'C7001') then //유나우 골프스튜디오
    begin
      if Global.SaleModule.VipTeeBox then
      begin
        if TImage(Sender).Tag <> 3 then
        begin
          Global.SBMessage.ShowMessageModalForm(MSG_VIP_ONLY_DAY_PRODUCT);
          Timer.Enabled := True;
          Exit;
        end;
      end;
    end;

    Global.SaleModule.NewMemberItemType := TMemberItemType(Ord(TImage(Sender).Tag));
    Popup.CloseFormStrMrok('');
  end;

end;

procedure TfrmNewMemberItemType.Image1Click(Sender: TObject);
begin
  TouchSound;
  Timer.Enabled := False;
  Global.SaleModule.PaymentAddType := patFacilityNew;
  Popup.NewMemberPolicy;
end;

procedure TfrmNewMemberItemType.Image3Click(Sender: TObject);
begin
  //타석이동
  TouchSound;
  Timer.Enabled := False;
  Global.SaleModule.TeeboxMenuType := TTeeboxMenuType(1);
  Popup.CloseFormStrMrok('');
end;

procedure TfrmNewMemberItemType.Image5Click(Sender: TObject);
begin
  //예약시간 추가
  TouchSound;
  Timer.Enabled := False;
  Global.SaleModule.TeeboxMenuType := TTeeboxMenuType(2);
  Popup.CloseFormStrMrok('');
end;

procedure TfrmNewMemberItemType.TimerTimer(Sender: TObject);
begin
  Inc(iSec);
  txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - iSec), 2, ' ')]);
  if (Time30Sec - iSec) = 0 then
    CloseRectangleClick(nil);
end;

end.
