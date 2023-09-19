unit Frame.Member.Sale.Product.Item.Style;

interface

uses
  uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TMemberSaleProductItemStyle = class(TFrame)
    Layout: TLayout;
    Image: TImage;
    Rectangle: TRectangle;
    txtProductTypeName: TText;
    txtProductPrice: TText;
    txtProductName: TText;
    procedure RectangleClick(Sender: TObject);
  private
    { Private declarations }
    FProduct: TProductInfo;
  public
    { Public declarations }
    procedure Bind(AProduct: TProductInfo);

    property Product: TProductInfo read FProduct write FProduct;
  end;

implementation

uses
  uGlobal, Form.Sale.Product, Frame.Member.Sale.Product.List.Style, uFunction, uCommon;

{$R *.fmx}

{ TMemberSaleProductItemStyle }

procedure TMemberSaleProductItemStyle.Bind(AProduct: TProductInfo);
begin
  Product := AProduct;
  txtProductName.Text := Format('%s', [Product.Name]);
  txtProductTypeName.Text := Format('%s', [Product.Name]);
  if ByteLen(txtProductName.Text) > 16 then
    txtProductName.TextSettings.Font.Size := 22
  else if ByteLen(txtProductName.Text) > 14 then
    txtProductName.TextSettings.Font.Size := 24
  else if ByteLen(txtProductName.Text) > 12 then
    txtProductName.TextSettings.Font.Size := 26;

    txtProductPrice.Text := Format('(%s)', [FormatFloat('#,##0.##', Product.ProdAmt)]);
end;

procedure TMemberSaleProductItemStyle.RectangleClick(Sender: TObject);
begin
  TouchSound;
  SaleProduct.Animate(Self.Tag);
  SaleProduct.AddProduct(Product);
end;

end.
