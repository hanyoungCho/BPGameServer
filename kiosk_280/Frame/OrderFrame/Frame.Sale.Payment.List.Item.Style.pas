unit Frame.Sale.Payment.List.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.ListBox,
  uStruct;

type
  TSalePaymentItemStyle = class(TFrame)
    recBowler: TRectangle;
    txtBowlerNm: TText;
    recGameCnt: TRectangle;
    txtSaleQty: TText;
    recLane: TRectangle;
    recPrice: TRectangle;
    txtPrice: TText;
    recShoes: TRectangle;
    recShoesChk: TRectangle;
    imgShoesNon: TImage;
    imgShoesOk: TImage;
    txtShoes: TText;
    txtLaneNo: TText;
    recPay: TRectangle;
    Rectangle2: TRectangle;
    imgPayNonChk: TImage;
    imgPayChk: TImage;
    Text2: TText;
    imgShoesFin: TImage;
    recPayFin: TRectangle;
    Text1: TText;
    recDc: TRectangle;
    txtDcType: TText;
    txtDcPrice: TText;
    procedure imgPayNonChkClick(Sender: TObject);
  private
    { Private declarations }
    FSaleData: TSaleData;
  public
    { Public declarations }
    procedure Display(ASaleData: TSaleData);

    property SaleData: TSaleData read FSaleData write FSaleData;
  end;

implementation

uses
  uGlobal, Form.Sale.Product;

{$R *.fmx}


procedure TSalePaymentItemStyle.Display(ASaleData: TSaleData);
var
  AlphaColor: TAlphaColor;
  nPrice: Currency;
	sMemberNm: string;
begin
	FSaleData := ASaleData;

	if FSaleData.MemberInfo.Code <> '' then
	begin
    //ksj 230829 회원명 5글자 넘을때 자르도록
		sMemberNm := FSaleData.MemberInfo.Name;
		if Length(sMemberNm) > 5 then
			sMemberNm := Copy(sMemberNm, 1, 5);

		txtBowlerNm.Text := sMemberNm;
	end
  else
    txtBowlerNm.Text := FSaleData.BowlerNm;

  txtSaleQty.Text := IntToStr(FSaleData.SaleQty);
  txtLaneNo.Text := IntToStr(FSaleData.LaneNo);

  imgShoesOk.Visible := False;
  imgShoesNon.Visible := False;
  imgShoesFin.Visible := False;
  txtShoes.Visible := False;

  if FSaleData.ShoesUse = 'N' then
  begin
    txtShoes.Visible := True;
    txtShoes.Text := '-';
  end
  else if FSaleData.ShoesUse = 'F' then
  begin
    txtShoes.Visible := True;
    txtShoes.Text := '무료';
  end;

  nPrice := FSaleData.SalePrice;
  if FSaleData.ShoesUse = 'Y' then
    nPrice := nPrice + Global.SaleModule.SaleShoesProd.ProdAmt;

  if FSaleData.DiscountList.Count > 0 then
  begin
    txtPrice.Visible := False;
    recDc.Visible := True;

    if FSaleData.DiscountList[0].DcType = 'P' then
    begin
      txtDcType.Text := '포인트 사용';
      txtDcType.TextSettings.FontColor := $FFFD3AA0;
    end
    else
    begin
      txtDcType.Text := '이용권 사용'; //ksj 230814 쿠폰 -> 이용권 문구변경
      txtDcType.TextSettings.FontColor := $FF1FC036;
    end;
    nPrice := nPrice - FSaleData.DiscountList[0].DcAmt;
    txtDcPrice.Text := Format('%s원', [FormatFloat('#,##0.##', nPrice)]);
  end
  else
  begin
    txtPrice.Visible := True;
    recDc.Visible := False;
    txtPrice.Text := Format('%s원', [FormatFloat('#,##0.##', nPrice)]);
  end;

  imgPayChk.Visible := False;
  imgPayNonChk.Visible := False;
  recPayFin.Visible := False;

	// #FF3D55F5 결제선택
	// #FF212225 결제 미선택
	// #FFA6A7A8 결제완료

	if FSaleData.PayResult = True then // 결제완료
	begin
		recPayFin.Visible := True;

    AlphaColor :=  $FFA6A7A8;

    if FSaleData.ShoesUse = 'Y' then
      imgShoesFin.Visible := True;

    txtPrice.TextSettings.Font.Style := [TFontStyle.fsStrikeOut];
    txtDcType.TextSettings.FontColor := AlphaColor;
    txtDcPrice.TextSettings.FontColor := AlphaColor;
    txtDcPrice.TextSettings.Font.Style := [TFontStyle.fsStrikeOut];
  end
  else
	begin
    if FSaleData.PaySelect = True then
    begin
      text2.Text := 'Y';
      imgPayChk.Visible := True;
			imgPayNonChk.Visible := False;

      AlphaColor :=  $FF3D55F5;

      if FSaleData.ShoesUse = 'Y' then
        imgShoesOk.Visible := True;

      recDc.Stroke.Color := AlphaColor;
      txtDcType.TextSettings.FontColor := AlphaColor;
      txtDcPrice.TextSettings.FontColor := AlphaColor;
    end
    else
    begin
      text2.Text := 'N';
      imgPayChk.Visible := False;
      imgPayNonChk.Visible := True;

			AlphaColor :=  $FF212225;

      if FSaleData.ShoesUse = 'Y' then
        imgShoesNon.Visible := True;
		end;

  end;

  txtBowlerNm.TextSettings.FontColor := AlphaColor;
  txtSaleQty.TextSettings.FontColor := AlphaColor;
  txtLaneNo.TextSettings.FontColor := AlphaColor;
  txtShoes.TextSettings.FontColor := AlphaColor;
  txtPrice.TextSettings.FontColor := AlphaColor;
end;

procedure TSalePaymentItemStyle.imgPayNonChkClick(Sender: TObject);
var
	bUse: Boolean;
begin              //이게 왜 안먹지??
	if FSaleData.GameProduct.ProdAmt = FSaleData.DcAmt then
	begin //ksj 230824 결제금액 없는경우 체크박스 고정
		if (FSaleData.ShoesUse = 'F') or (FSaleData.ShoesUse = 'N') then
			Exit;
	end;

  if text2.Text = 'N' then
    text2.Text := 'Y'
  else
    text2.Text := 'N';

  bUse := text2.Text = 'Y';
	SaleProduct.chgPaySelect(FSaleData.BowlerSeq, bUse);
end;

end.
