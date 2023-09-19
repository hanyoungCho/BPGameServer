unit Frame.Member.Sale.Product.Item420.Style;

interface

// 좌측정렬 114, 6

uses
  uStruct, FMX.Ani,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TMemberSaleProductItem420Style = class(TFrame)
    Layout: TLayout;
    ImgDay: TImage;
    AniImage: TImage;
    txtVIP: TText;
    ImgPeriod: TImage;
    ImgCoupon: TImage;
    txtProductName: TText;
    txtProductTypeName: TText;
    txtProductPrice: TText;
    txtProductTemp: TText;
    txtXGOLFDiscount: TText;
    Line1: TLine;
    SelectRectangle: TRectangle;
    Image1: TImage;
    XGOLFLINERectangle: TRectangle;
    imgSelectRectangle: TImage;
    Timer: TTimer;
    procedure RectangleClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
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
  uGlobal, Form.Sale.Product, Frame.Member.Sale.Product.List.Style, uFunction, uCommon, uConsts;

{$R *.fmx}

{ TMemberSaleProductItem420Style }

procedure TMemberSaleProductItem420Style.Bind(AProduct: TProductInfo);
var
  a: Integer;
  x, y: string;
begin
  Product := AProduct;

  txtProductTypeName.Text := Format('%s', ['회원권']);
  txtProductPrice.TextSettings.FontColor := $FF2AA430;
  //txtProductTemp.Text := Format('%s개월', [Product.UseMonth]);
  txtProductName.Text := Product.ProdNm;

  txtProductPrice.Text := Format('%s', [FormatFloat('#,##0.##', Product.ProdPriceList[0].prod_amt)]);
  //txtProductPrice.Position.Y := 11;
  //txtProductPrice.TextSettings.Font.Size := txtProductPrice.TextSettings.Font.Size + 8;

  ImgPeriod.Visible := True;

  //Timer.Enabled := True;
end;

procedure TMemberSaleProductItem420Style.RectangleClick(Sender: TObject);
var
  nMin: Integer;
  AProductInfo: TProductInfo;
  sCode, sMsg: String;
begin


  begin
    if Global.SaleModule.TeeBoxInfo.TasukNo <> 0 then //타석번호 0인경우-'C1001' 코리아하이파이브스포츠클럽 게임비, 신규회원가입후 회원권(기간권,쿠폰) 구매시
    begin
      AProductInfo := Global.Database.GetTeeBoxProductTime(FProduct.Code, sCode, sMsg);

      if sCode <> '0000' then
      begin
        Global.SBMessage.ShowMessageModalForm(sMsg);
        Exit;
      end;

      FProduct.One_Use_Time := AProductInfo.One_Use_Time;
    end;
  end;

  TouchSound;
  
  SaleProduct.Animate(Self.Tag);
  SaleProduct.AddProduct(Product);
end;

procedure TMemberSaleProductItem420Style.TimerTimer(Sender: TObject);
begin
  if imgSelectRectangle.Visible = True then
    imgSelectRectangle.Visible := False
  else
    imgSelectRectangle.Visible := True;
end;

end.
