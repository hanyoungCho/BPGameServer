unit Frame.DCList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts,
  {frame}
  Frame.Sale.Game.DC.Item.Style;

type
  TDCList = class(TFrame)
    recDCList: TRectangle;
    VertScrollBox1: TVertScrollBox;
    rrecPoint: TRoundRect;
    Text3: TText;
    rrecCoupon: TRoundRect;
    Text4: TText;
    VertScrollBox2: TVertScrollBox;
    recPoint: TRectangle;
    recCoupon: TRectangle;
    recTime: TRectangle;
    rrecTime: TRoundRect;
    Text1: TText;
    VertScrollBox3: TVertScrollBox;
    Text2: TText;
    Image1: TImage;
    recClose: TRectangle;
    recOk: TRectangle;
    Text5: TText;
    recTop: TRectangle;
    recBottom: TRectangle;
    recBody: TRectangle;
    procedure recOkClick(Sender: TObject);
    procedure recCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Display;
  end;

implementation

uses
  Form.Popup, uGlobal, uConsts, uStruct;

{$R *.fmx}

procedure TDCList.Display;
var
  Index, ColIndex, RowIndex: Integer;
  AItemStyle: TSaleGameDCItemStyle;
  sStr, sMemberNm: String;
	rSaleData: TSaleData;
  i: integer;
  nHeigth: Single;
  PointList, CouponList, TimeList: TStringList;
begin

  try
    for Index := VertScrollBox1.Content.ChildrenCount - 1 downto 0 do
      VertScrollBox1.Content.Children[Index].Free;

    VertScrollBox1.Content.DeleteChildren;
    VertScrollBox1.Repaint;

    for Index := VertScrollBox2.Content.ChildrenCount - 1 downto 0 do
      VertScrollBox2.Content.Children[Index].Free;

    VertScrollBox2.Content.DeleteChildren;
    VertScrollBox2.Repaint;

    for Index := VertScrollBox3.Content.ChildrenCount - 1 downto 0 do
      VertScrollBox3.Content.Children[Index].Free;

    VertScrollBox3.Content.DeleteChildren;
    VertScrollBox3.Repaint;

    PointList := TStringList.Create;
		CouponList := TStringList.Create;
    TimeList := TStringList.Create;

		//ksj 230816 조건문 수정
		for Index := 0 to Global.SaleModule.BuyProductList.Count - 1 do
		begin
			rSaleData := Global.SaleModule.BuyProductList[Index];
			if rSaleData.DiscountList.count = 0 then
				Continue;

      //ksj 230829 회원명 5글자 넘을때 자르도록
			sMemberNm := rSaleData.MemberInfo.Name;
			if Length(sMemberNm) > 5 then
				sMemberNm := Copy(sMemberNm, 1, 5);

			for i := 0 to rSaleData.DiscountList.Count - 1 do
			begin
				if rSaleData.DiscountList[i].DcType = 'P' then
				begin   //rSaleData.MemberInfo.Name
					sStr := sMemberNm + ' 회원님 ' + Format('%sP', [FormatFloat('#,##0.##', rSaleData.DiscountList[i].DcAmt)]);
					PointList.Add(sStr);
				end
				else if rSaleData.DiscountList[i].DcType = 'C' then //쿠폰할인-게임수
				begin //ksj 230814 쿠폰 -> 이용권 문구변경
					sStr := sMemberNm + ' 회원님 ' + IntToStr(rSaleData.DiscountList[i].DcValue) + '회 사용';
					CouponList.Add(sStr);
				end
				else if rSaleData.DiscountList[i].DcType = 'T' then //쿠폰할인-게임수
				begin
					sStr := sMemberNm + ' 회원님 ' + IntToStr(rSaleData.DiscountList[i].DcValue * rSaleData.GameProduct.UseGameMin) + '분 사용';
					TimeList.Add(sStr);
				end;
			end;

		end;

    if (PointList.Count < 2) and (CouponList.Count < 2) and (TimeList.Count < 2) then
    begin
      rrecPoint.Position.X := 257;
      rrecCoupon.Position.X := 257;
      rrecTime.Position.X := 257;
      VertScrollBox1.Position.X := 304;
      VertScrollBox2.Position.X := 304;
      VertScrollBox3.Position.X := 304;
    end;

    nHeigth := 0;
    if PointList.Count = 0 then
    begin
      recPoint.Visible := False;
    end
    else
    begin
      ColIndex := 0;
      RowIndex := 0;

      for Index := 0 to PointList.Count - 1 do
      begin

        if ColIndex = 2 then
        begin
          Inc(RowIndex);
          ColIndex := 0;
        end;

        AItemStyle := TSaleGameDCItemStyle.Create(nil);
        AItemStyle.Position.X := ColIndex * (AItemStyle.Width);
        AItemStyle.Position.Y := (RowIndex * AItemStyle.Height);
        AItemStyle.Parent := VertScrollBox1;
        AItemStyle.Display(PointList[Index]);
        Inc(ColIndex);
      end;

      Inc(RowIndex);
      nHeigth := RowIndex * AItemStyle.Height;
      recPoint.Height := RowIndex * AItemStyle.Height;
    end;

    if CouponList.Count = 0 then
    begin
      recCoupon.Visible := False;
    end
    else
    begin
      ColIndex := 0;
      RowIndex := 0;

      for Index := 0 to CouponList.Count - 1 do
      begin

        if ColIndex = 2 then
        begin
          Inc(RowIndex);
          ColIndex := 0;
        end;

        AItemStyle := TSaleGameDCItemStyle.Create(nil);
        AItemStyle.Position.X := ColIndex * (AItemStyle.Width);
        AItemStyle.Position.Y := (RowIndex * AItemStyle.Height);
        AItemStyle.Parent := VertScrollBox2;
        AItemStyle.Display(CouponList[Index]);
        Inc(ColIndex);
      end;

      Inc(RowIndex);
      nHeigth := nHeigth + (RowIndex * AItemStyle.Height);
      recCoupon.Height := RowIndex * AItemStyle.Height;

      if PointList.Count > 0 then
      begin
        recCoupon.Margins.Top := 40;
        nHeigth := nHeigth + 40;
      end;
    end;

    if TimeList.Count = 0 then
    begin
      recTime.Visible := False;
    end
    else
    begin
      ColIndex := 0;
      RowIndex := 0;

      for Index := 0 to TimeList.Count - 1 do
      begin

        if ColIndex = 2 then
        begin
          Inc(RowIndex);
          ColIndex := 0;
        end;

        AItemStyle := TSaleGameDCItemStyle.Create(nil);
        AItemStyle.Position.X := ColIndex * (AItemStyle.Width);
        AItemStyle.Position.Y := (RowIndex * AItemStyle.Height);
        AItemStyle.Parent := VertScrollBox3;
        AItemStyle.Display(TimeList[Index]);
        Inc(ColIndex);
      end;

      Inc(RowIndex);
      nHeigth := nHeigth + (RowIndex * AItemStyle.Height);
      recTime.Height := RowIndex * AItemStyle.Height;

      if (PointList.Count > 0) or (CouponList.Count > 0) then
      begin
        recTime.Margins.Top := 40;
        nHeigth := nHeigth + 40;
      end;
    end;

    Height := 248 + 240 + nHeigth;
  finally
    PointList.Free;
    CouponList.Free;
    TimeList.Free;
  end;

end;

procedure TDCList.recCloseClick(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TDCList.recOkClick(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

end.
