unit Frame.Member.ItemType;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TfrmMemberItemType = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
    txtTitle: TText;
    txtTasukInfo: TText;
    ItemTypeRectangle: TRectangle;
    imgPeriod: TImage;
    imgCoupon: TImage;
    imgDay: TImage;
    CloseRectangle: TRectangle;
    txtTime: TText;
    txtClose: TText;
    Timer: TTimer;
    QnAXGolfRectangle: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    txtPeriodTop: TText;
    txtPeriodBottom: TText;
    txtCouponTop: TText;
    txtCouponBottom: TText;
    Text7: TText;
    Text8: TText;
    txtUseTime: TText;
    Image5: TImage;
    Image6: TImage;
    Text3: TText;
    Text4: TText;
    Text9: TText;
    Image4: TImage;
    ImgXGOLF: TImage;
    NewMemberRectangle: TRectangle;
    imgNewMember: TImage;
    Text10: TText;
    imgCastlexXgolf: TImage;
    imgWellbeing: TImage;
    Text11: TText;
    Text12: TText;
    procedure CloseRectangleClick(Sender: TObject);
    procedure imgPeriodClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure RectangleClick(Sender: TObject);
    procedure imgNewMemberClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    nCnt: Integer;
    iSec: Integer;
  end;

implementation

uses
  Form.Popup, uConsts, uGlobal, uFunction, uCommon;

{$R *.fmx}

procedure TfrmMemberItemType.CloseRectangleClick(Sender: TObject);
begin
  TouchSound;
  Timer.Enabled := False;
  Popup.CloseFormStrMrCancel;
end;

procedure TfrmMemberItemType.imgPeriodClick(Sender: TObject);
begin
  TouchSound;
  Timer.Enabled := False;

  Global.SaleModule.memberItemType := TMemberItemType(Ord(TImage(Sender).Tag));
  Popup.CloseFormStrMrok('');
end;

procedure TfrmMemberItemType.imgNewMemberClick(Sender: TObject);
begin
  TouchSound;
  Timer.Enabled := False;
  Global.SaleModule.memberItemType := mitNew;
  Popup.NewMemberPolicy;
end;

procedure TfrmMemberItemType.RectangleClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TfrmMemberItemType.TimerTimer(Sender: TObject);
begin
  // 2021-11-05 500 ·Î º¯°æ
  if txtPeriodTop.TextSettings.FontColor = $FF333333 then
  begin
    txtPeriodTop.TextSettings.FontColor := $FFBDBDBD;
    txtCouponTop.TextSettings.FontColor := $FFBDBDBD;
    text7.TextSettings.FontColor := $FFBDBDBD;
    text11.TextSettings.FontColor := $FFBDBDBD;
  end
  else
  begin
    txtPeriodTop.TextSettings.FontColor := $FF333333;
    txtCouponTop.TextSettings.FontColor := $FF333333;
    text7.TextSettings.FontColor := $FF333333;
    text11.TextSettings.FontColor := $FF333333;
  end;

  Inc(nCnt);
  if nCnt > 1 then
  begin
    nCnt := 0;

    Inc(iSec);
    txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - iSec), 2, ' ')]);
    if (Time30Sec - iSec) = 0 then
      CloseRectangleClick(nil);
  end;
end;

end.
