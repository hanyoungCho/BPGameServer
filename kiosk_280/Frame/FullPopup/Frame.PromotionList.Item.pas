unit Frame.PromotionList.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Effects, FMX.Layouts, System.ImageList, FMX.ImgList;

type
  TFullPopupPromotionListItem = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
    BlurEffect1: TBlurEffect;
    Text1: TText;
    Image1: TImage;
    ImageList: TImageList;
    procedure RectangleClick(Sender: TObject);
  private
    { Private declarations }
    FItemIndex: Integer;
  public
    { Public declarations }
    procedure Display(AItemIndex: Integer; AText: string);
  end;

implementation

uses
  Form.Full.Popup, uGlobal, uConsts;

{$R *.fmx}

{ TFullPopupPromotionListItem }

procedure TFullPopupPromotionListItem.Display(AItemIndex: Integer; AText: string);
var
  s: TSizeF;
begin
  FItemIndex := AItemIndex;
  s.Create(180, 180);
  Image1.MultiResBitmap.Bitmaps[1] := ImageList.Source[FItemIndex].MultiResBitmap.Bitmaps[1];
  Text1.Text := AText;
end;

procedure TFullPopupPromotionListItem.RectangleClick(Sender: TObject);
begin

  if FItemIndex = 0 then
    Global.SaleModule.PromotionType := pttWellbeing;

  //chy bc페이북 -> xpartners에서 자체 qr 발송, 프로모션과 동일하게 처리
  if FItemIndex = 1 then
    Global.SaleModule.PromotionType := pttBCPaybookGolf;

  //리프레쉬클럽
  if FItemIndex = 2 then
    Global.SaleModule.PromotionType := pttRefreshclub;

  //우리카드 더라운지멤버스
  if FItemIndex = 3 then
    Global.SaleModule.PromotionType := pttTheLoungeMembers;

  //아이코젠
  if FItemIndex = 4 then
    Global.SaleModule.PromotionType := pttIkozen;

  FullPopup.ApplyPromotion;
end;

end.
