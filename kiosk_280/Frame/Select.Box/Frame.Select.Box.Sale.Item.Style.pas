unit Frame.Select.Box.Sale.Item.Style;

interface

// �������� 114, 6

uses
  uStruct, FMX.Ani,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TSelectBoxSaleItemStyle = class(TFrame)
    Layout: TLayout;
    AniImage: TImage;
    txtProductName: TText;
    txtProductPrice: TText;
    SelectRectangle: TRectangle;
    imgClock: TImage;
    Rectangle1: TRectangle;
    imgCoupon: TImage;
    imgClockNon: TImage;
    imgCouponNon: TImage;
    procedure SelectRectangleClick(Sender: TObject);
  private
    { Private declarations }
    FProduct: TMemberShipProductInfo;
  public
    { Public declarations }
    procedure Bind(AProduct: TMemberShipProductInfo);

    property Product: TMemberShipProductInfo read FProduct write FProduct;
  end;

implementation

uses
  uGlobal, uFunction, uCommon, uConsts, Form.Select.Box;

{$R *.fmx}

{ TMemberSaleProductItem420Style }

procedure TSelectBoxSaleItemStyle.Bind(AProduct: TMemberShipProductInfo);
begin
  Product := AProduct;
  //501: ����ȸ����, 502: �ð�ȸ����, 503 : ���ȸ����
  if (Product.ProdDetailDiv = '501') or (Product.ProdDetailDiv = '503') then
  begin
    imgCoupon.Visible := True;
    SelectRectangle.Fill.Color := $FFE7EAFF;
  end
  else
  begin
    imgClock.Visible := True;
    SelectRectangle.Fill.Color := TAlphaColorRec.white;
  end;

  txtProductName.Text := Product.ProdNm;
  txtProductPrice.Text := Format('%s��', [FormatFloat('#,##0.##', Product.ProdAmt)]); //ksj 230828 ��ǥ�� �߰�
end;

procedure TSelectBoxSaleItemStyle.SelectRectangleClick(Sender: TObject);
begin
  TouchSound;

  Global.SaleModule.SaleSelectMemberShipProd := Product;
  SelectBox.SelectSale;
end;

end.
