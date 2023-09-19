unit Frame.FullPopup.Member.Item;

interface  // 417 200         350  170

uses
  uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TFullPopupMemberItem = class(TFrame)
    Layout: TLayout;
    ImgRectangle: TRectangle;
    ImgClock: TImage;
    ImgTicket: TImage;
    recSelectImg: TRectangle;
    imgNon: TImage;
    txtPurchaseGame: TText;
    recSelect: TRectangle;
    imgSelect: TImage;
    recBody: TRectangle;
    txtProductName: TText;
    Text1: TText;
    txtRemainGame: TText;
    imgDis: TImage;
    ImgClockNon: TImage;
    ImgTicketNon: TImage;
    procedure recSelectClick(Sender: TObject);
  private
    { Private declarations }
    FProduct: TMemberProductInfo;
  public
    { Public declarations }
    procedure DisPlayInfo(AProduct: TMemberProductInfo);
    procedure SelectDisPlay(AUse: Boolean);
    property Product: TMemberProductInfo read FProduct write FProduct;
  end;

implementation

uses
  uGlobal, uFunction, uCommon, uConsts, Form.Full.Popup, Form.Popup;

{$R *.fmx}

{ TFullPopupCouponItem }

procedure TFullPopupMemberItem.DisPlayInfo(AProduct: TMemberProductInfo);
begin
  FProduct := AProduct;

  txtProductName.Text := Product.ProdNm;
  if Product.GameDiv = '1' then  //게임요금제
  begin
    txtPurchaseGame.Text := '총 ' + IntToStr(Product.PurchaseGameCnt) + '회권';
    txtRemainGame.Text := IntToStr(Product.RemainGameCnt) + '회';
  end
  else
	begin
		txtPurchaseGame.Text := '총 ' + IntToStr(Product.PurchaseGameMin) + '분';
		txtRemainGame.Text := IntToStr(Product.RemainGameMin) + '분';
	end;

	if Global.SaleModule.GameInfo.GameDiv <> Product.GameDiv then
	begin
		recBody.Fill.Color := $FFD9D9D9;
		txtProductName.TextSettings.FontColor := $FFA6A7A8;
		txtPurchaseGame.TextSettings.FontColor := $FFA6A7A8;
		txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
		Text1.TextSettings.FontColor := $FFA6A7A8;
		txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
		imgDis.Visible :=  True;

		if Product.GameDiv = '1' then  //게임요금제
			ImgTicketNon.Visible := True
		else
			ImgClockNon.Visible := True;
	end
	else
	begin
		if Product.GameDiv = '1' then  //게임요금제
			ImgTicket.Visible := True
		else
		begin
			ImgClock.Visible := True;

			if Global.SaleModule.GameInfo.LaneUse = '2' then
			begin //ksj 230824
        if odd(Global.SaleModule.BuyProductList[Global.SaleModule.TimeBowlerSeq - 1].LaneNo) then
				begin
					if Global.SaleModule.TimeLane1DcType = 'P' then
					begin
						ImgClockNon.Visible := True;
						recBody.Fill.Color := $FFD9D9D9;
						txtProductName.TextSettings.FontColor := $FFA6A7A8;
						txtPurchaseGame.TextSettings.FontColor := $FFA6A7A8;
						txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
						Text1.TextSettings.FontColor := $FFA6A7A8;
						txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
						imgDis.Visible :=  True;
					end;
				end
				else
				begin
          if Global.SaleModule.TimeLane2DcType = 'P' then
					begin
						ImgClockNon.Visible := True;
						recBody.Fill.Color := $FFD9D9D9;
						txtProductName.TextSettings.FontColor := $FFA6A7A8;
						txtPurchaseGame.TextSettings.FontColor := $FFA6A7A8;
						txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
						Text1.TextSettings.FontColor := $FFA6A7A8;
						txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
						imgDis.Visible :=  True;
					end;
				end;
			end
			else
			begin
				if Global.SaleModule.TimeLane1DcType = 'P' then //ksj 230726 시간제에서 할인은 포인트만 또는 이용권만 가능
				begin
					ImgClockNon.Visible := True;
					recBody.Fill.Color := $FFD9D9D9;
					txtProductName.TextSettings.FontColor := $FFA6A7A8;
					txtPurchaseGame.TextSettings.FontColor := $FFA6A7A8;
					txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
					Text1.TextSettings.FontColor := $FFA6A7A8;
					txtRemainGame.TextSettings.FontColor := $FFA6A7A8;
					imgDis.Visible :=  True;
				end;
			end;
		end;



    imgNon.Visible := True;
    imgSelect.Visible := False;
  end;

end;

procedure TFullPopupMemberItem.recSelectClick(Sender: TObject);
begin
  TouchSound;
	if FProduct.ProdCd = EmptyStr then
		Exit;

	if Global.SaleModule.GameInfo.GameDiv <> Product.GameDiv then
		Exit;

	Global.SaleModule.SelectProd := FProduct;

  if Global.SaleModule.GameInfo.LaneUse = '2' then
	begin //ksj 230824
		if Global.SaleModule.GameItemType = gitGameTime then
		begin
			if odd(Global.SaleModule.BuyProductList[Global.SaleModule.TimeBowlerSeq - 1].LaneNo) then
			begin
				if (FProduct.ProdDetailDiv = '502') then
				begin
					if Global.SaleModule.SelectProd.RemainGameMin < Global.SaleModule.BuyProductList[0].GameProduct.UseGameMin then
					begin
						Global.SBMessage.ShowMessage('12', '알림', '해당 회원권의 보유시간이 부족합니다.');
						Exit;
					end;
				end;
			end
			else
			begin
				if (FProduct.ProdDetailDiv = '502') then
				begin
					if Global.SaleModule.SelectProd.RemainGameMin < Global.SaleModule.BuyProductList[0].GameProduct.UseGameMin then
					begin
						Global.SBMessage.ShowMessage('12', '알림', '해당 회원권의 보유시간이 부족합니다.');
						Exit;
					end;
				end;
			end;
		end;
	end
	else
	begin
		if (FProduct.ProdDetailDiv = '502') then
		begin //ksj 230728 시간회원권의 잔여보유시간 < 시간요금제상품의 시간
			if Global.SaleModule.SelectProd.RemainGameMin < Global.SaleModule.BuyProductList[0].GameProduct.UseGameMin then
			begin
				Global.SBMessage.ShowMessage('12', '알림', '해당 회원권의 보유시간이 부족합니다.');
				Exit;
			end;
		end;
	end;

	FullPopup.selectMemberProduct;
end;

procedure TFullPopupMemberItem.SelectDisPlay(AUse: Boolean);
begin
  imgNon.Visible := not AUse;
  imgSelect.Visible := AUse;
end;

end.
