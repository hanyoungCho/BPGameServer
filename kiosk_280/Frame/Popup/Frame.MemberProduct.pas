unit Frame.MemberProduct;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects,
  Frame.FullPopup.CouponItem, FMX.Layouts;

type
  TMemberProduct = class(TFrame)
    txtTitle: TText;
    recBtn: TRectangle;
    recMemberInfo: TRectangle;
    txtOption: TText;
    txtMemberNm: TText;
    recProductList: TRectangle;
    recPoint: TRectangle;
    txtPoint: TText;
    recOk: TRectangle;
    Text3: TText;
    ImgLayout: TLayout;
    BGRectangle: TRectangle;
    Layout1: TLayout;
    recClose: TRectangle;
    Image2: TImage;
    txtMemberDate: TText;
    Text4: TText;
    recMemberType: TRectangle;
    txtMemberType: TText;
    txtMemberPoint: TText;
    txtVisitCnt: TText;
    Image1: TImage;
    Image3: TImage;
    recLane: TRectangle;
    RoundRect1: TRoundRect;
    recOption1: TRectangle;
    recOption2: TRectangle;
    RoundRect2: TRoundRect;
    Text1: TText;
    recOption3: TRectangle;
    RoundRect3: TRoundRect;
    Text2: TText;
    procedure recCloseClick(Sender: TObject);
    procedure recOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Display;
    procedure selectproduct;
  end;

implementation

uses
  uStruct, uGlobal, Form.Popup;

{$R *.fmx}


procedure TMemberProduct.Display;
var
  Index, RowIndex: Integer;
  AProductInfo: TProductInfo;
  AItem: TFullPopupCouponItem;
begin
  try

    txtMemberNm.Text := Global.SaleModule.Member.Name + ' È¸¿ø´Ô';

    RowIndex := 0;

    for Index := recProductList.ChildrenCount - 1 downto 0 do
      recProductList.Children[Index].Free;
    recProductList.DeleteChildren;

    for Index := 0 to Global.SaleModule.ProductList.Count - 1 do
    begin

      AProductInfo := Global.SaleModule.ProductList[Index];
      {
      if not AProductInfo.Use then
        Continue;
      }
      AItem := TFullPopupCouponItem.Create(nil);
      AItem.Position.X := 0;
      AItem.Position.Y := (RowIndex * AItem.Height) + (RowIndex * 20);
      AItem.DisPlayInfo(AProductInfo);
      AItem.Parent := recProductList;

      Inc(RowIndex);
    end;

  finally

  end;

end;


procedure TMemberProduct.selectproduct;
var
  Index, RowIndex: Integer;
  AProductInfo: TProductInfo;
  AItem: TFullPopupCouponItem;
begin
  try


    for Index := 0 to recProductList.ChildrenCount - 1 do
    begin
      if TFullPopupCouponItem(recProductList.Children[Index]).Product.ProdCd = Global.SaleModule.SelectProduct.ProdCd then
        TFullPopupCouponItem(recProductList.Children[Index]).SelectDisPlay(True)
      else
        TFullPopupCouponItem(recProductList.Children[Index]).SelectDisPlay(False);
    end;

    for Index := 0 to Global.SaleModule.ProductList.Count - 1 do
    begin

      AProductInfo := Global.SaleModule.ProductList[Index];
      {
      if not AProductInfo.Use then
        Continue;
      }
      AItem := TFullPopupCouponItem.Create(nil);
      AItem.Position.X := 0;
      AItem.Position.Y := (RowIndex * AItem.Height) + (RowIndex * 20);
      AItem.DisPlayInfo(AProductInfo);
      AItem.Parent := recProductList;

      Inc(RowIndex);
    end;

  finally

  end;

end;

procedure TMemberProduct.recCloseClick(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TMemberProduct.recOkClick(Sender: TObject);
begin
  Popup.CloseFormStrMrok('');
end;

end.
