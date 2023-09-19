unit Frame.Sale.Order.List.Item.Style;

interface

uses
  uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TSaleOrderItemStyle = class(TFrame)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    txtProductName: TText;
    Text2: TText;
    txtProductPrice: TText;
    Text4: TText;
    QTYRectangle: TRectangle;
    PlusRectangle: TRectangle;
    MinusRectangle: TRectangle;
    PlusImage: TImage;
    MinusImage: TImage;
    Rectangle5: TRectangle;
    Text5: TText;
    Image: TImage;
    txtSaleQty: TText;
    MinusRec: TRectangle;
    PlusRec: TRectangle;
    Rectangle8: TRectangle;
    Circle: TCircle;
    Text7: TText;
    procedure PlusImageClick(Sender: TObject);
    procedure MinusImageClick(Sender: TObject);
    procedure ImgDeleteClick(Sender: TObject);
  private
    { Private declarations }
    FSaleData: TSaleData;
    FDiscount: TDiscount;
  public
    { Public declarations }
    procedure Display(ASaleData: TSaleData; DisCountIndex: Integer = -1);

    property SaleData: TSaleData read FSaleData write FSaleData;
  end;

implementation

uses
  Form.Sale.Product, uCommon, uConsts, uGlobal;

{$R *.fmx}

{ TSaleOrderItemStyle }

procedure TSaleOrderItemStyle.Display(ASaleData: TSaleData; DisCountIndex: Integer);
begin
  SaleData := ASaleData;

  if DisCountIndex = -1 then
  begin
    //txtProductName.Text := SaleData.Products.Name;
    txtProductName.TextSettings.Font.Style := [];
    txtProductName.TextSettings.Font.Size := 28;
    txtProductName.HorzTextAlign := TTextAlign.Leading;
    txtProductName.Margins.Left := 10;

    txtSaleQty.Text := FormatFloat('#,##0.##', SaleData.SaleQty);
    txtSaleQty.TextSettings.Font.Style := [];
    txtSaleQty.TextSettings.Font.Size := 28;
    txtSaleQty.HorzTextAlign := TTextAlign.Center;
    text2.Visible := False;

    Image.Visible := True;//SaleData.Products.Product_Div <> PRODUCT_TYPE_D;
    MinusRec.Visible := Image.Visible;
    PlusRec.Visible := Image.Visible;
    txtSaleQty.Visible := True;

  //  if SaleData.DcAmt = 0 then
  //    text3.Text := FormatFloat('#,##0.##', SaleData.SalePrice)
  //  else
  //    text3.Text := Format('%s(%s)', [FormatFloat('#,##0.##', SaleData.SalePrice), FormatFloat('#,##0.##', SaleData.DcAmt)]);

  //  if Global.SaleModule.Member.XGolfMember and SaleData.Products.xgolf_dc_yn then
  //    text3.Text := FormatFloat('#,##0.##', SaleData.Products.xgolf_product_amt * SaleData.SaleQty)
  //  else
    txtProductPrice.Text := FormatFloat('#,##0.##', SaleData.SalePrice);

    txtProductPrice.TextSettings.Font.Style := [];
    txtProductPrice.TextSettings.Font.Size := 28;
    txtProductPrice.TextSettings.Font.Family := 'Roboto';
    txtProductPrice.HorzTextAlign := TTextAlign.Leading;
//    txtProductPrice.Margins.Left := 10;
    txtProductPrice.Margins.Right := 50;

    text5.Text := FormatFloat('#,##0.##', SaleData.DcAmt);
    text5.TextSettings.Font.Style := [];
    text5.TextSettings.Font.Size := 28;
    text5.TextSettings.Font.Family := 'Roboto';
    text5.HorzTextAlign := TTextAlign.Leading;
    text5.Margins.Left := 10;

    text4.Visible := False;

    text5.TextSettings.HorzAlign := TTextAlign.Trailing;
    txtProductPrice.TextSettings.HorzAlign := TTextAlign.Trailing;
    txtProductPrice.Margins.Right := 65;

    QTYRectangle.Visible := True;
    //if SaleData.Products.Product_Div = PRODUCT_TYPE_D then
    begin
      PlusRectangle.Visible := False;
      MinusRectangle.Align := TAlignLayout.Center;
    end;
  end
  else
  begin  // 할인 영역
    FDiscount := SaleData.DiscountList[DisCountIndex];
    txtProductName.Text := '  ' + FDiscount.Name;
    txtProductName.TextSettings.Font.Style := [];
    txtProductName.TextSettings.Font.Size := 28;
    txtProductName.HorzTextAlign := TTextAlign.Leading;
    txtProductName.Margins.Left := 10;

    text2.Text := '할인';//FormatFloat('#,##0.##', SaleData.SaleQty);
    text2.TextSettings.Font.Style := [];
    text2.TextSettings.Font.Size := 28;
    text2.HorzTextAlign := TTextAlign.Center;

    txtProductPrice.Text := FormatFloat('#,##0.##', -1 * FDiscount.ApplyAmt);
    text2.Visible := True;
    Image.Visible := False;
    MinusRec.Visible := Image.Visible;
    PlusRec.Visible := Image.Visible;
    txtSaleQty.Visible := False;
    txtProductPrice.TextSettings.Font.Style := [];
    txtProductPrice.TextSettings.Font.Size := 28;
    txtProductPrice.TextSettings.Font.Family := 'Roboto';
//    text3.HorzTextAlign := TTextAlign.Leading;
//
    txtProductPrice.TextSettings.HorzAlign := TTextAlign.Trailing;
    Rectangle2.HitTest := False;
    MinusRec.HitTest := False;
    PlusRec.HitTest := False;
    if FDiscount.Gubun <> 999 then
      Rectangle8.Visible := FDiscount.Gubun <> 999;
//    else
//      text3.Margins.Right := 65;
    txtProductPrice.Margins.Right := 65;
  end;
end;

procedure TSaleOrderItemStyle.ImgDeleteClick(Sender: TObject);
begin
  SaleProduct.DeleteDiscount(FDiscount.QRCode);
end;

procedure TSaleOrderItemStyle.MinusImageClick(Sender: TObject);
begin
  TouchSound;
  //SaleProduct.MinusProduct(SaleData.Products);
end;

procedure TSaleOrderItemStyle.PlusImageClick(Sender: TObject);
begin
  TouchSound;
  //SaleProduct.AddProduct(SaleData.Products);
end;

end.
