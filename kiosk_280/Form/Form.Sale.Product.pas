
unit Form.Sale.Product;

interface

uses
  Windows,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures, FMX.StdCtrls,
  FMX.Objects,
  Frame.Sale.Payment.List.Item.Style, Frame.Top, uPaycoNewModul,
  uStruct,
  CPort;

type
  TSaleProduct = class(TForm)
    ImgLayout: TLayout;
    Layout: TLayout;
    TopLayout: TLayout;
    ProductRectangle: TRectangle;
    Rectangle2: TRectangle;
    CardRectangle: TRectangle;
    EasyRectangle: TRectangle;
    Rectangle5: TRectangle;
    recSelRealAmt: TRectangle;
    Rectangle7: TRectangle;
    Text4: TText;
    txtSelRealAmt: TText;
    Text6: TText;
    txtRemainAmt: TText;
    Rectangle3: TRectangle;
    Text5: TText;
    txtDcAmt: TText;
    Rectangle8: TRectangle;
    Text8: TText;
    txtRealAmt: TText;
    Timer: TTimer;
    ProcessRectangle: TRectangle;
    BGRectangle: TRectangle;
    BottomLayout: TLayout;
    recBottom: TRectangle;
    rrCancel: TRoundRect;
    txtCancel: TText;
    recPrev: TRoundRect;
    txtPrev: TText;
    txtTime: TText;
    recBtn: TRectangle;
    recTop: TRectangle;
    txtTitle: TText;
    txtTitleTime: TText;
    recListTitle: TRectangle;
    txtBowler: TText;
    txtPrice: TText;
    txtShoes: TText;
    txtLane: TText;
    txtGameCnt: TText;
    VertScrollBox: TVertScrollBox;
    txtPay: TText;
    Top1: TTop;
    recListBG: TRectangle;
    recGameCnt: TRectangle;
    recShoes: TRectangle;
    recLine: TRectangle;
    recPriceBG: TRectangle;
    Image1: TImage;
    recGeneral: TRectangle;
    imgGeneralN: TImage;
    imgGeneralY: TImage;
    recLeage: TRectangle;
    imgLeagueN: TImage;
    imgLeagueY: TImage;
    recPay: TRectangle;
    Rectangle1: TRectangle;
    Rectangle10: TRectangle;
    Image3: TImage;
    Image6: TImage;
    Text2: TText;
    Text3: TText;
    txtAmtShoes: TText;
    txtAmtGame: TText;
    recRemainAmt: TRectangle;
    recLineView: TRectangle;
    recTime: TRectangle;
    Image7: TImage;
    Text9: TText;
    Text11: TText;
    Text15: TText;
    Text16: TText;
    recDcList: TRectangle;
    Text17: TText;
    Timer1: TTimer;
    recNotice: TRectangle;
    txtNotice1: TText;
    txtNotice2: TText;
    txtNotice3: TText;
    recTitle1: TRectangle;
    recTitle6: TRectangle;
    recTitle4: TRectangle;
    recTitle3: TRectangle;
    recTitle2: TRectangle;
    recTitle5: TRectangle;
    procedure FormDestroy(Sender: TObject);

    procedure Rectangle1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CardRectangleClick(Sender: TObject);

    procedure TimerTimer(Sender: TObject);
    procedure BottomRectangleClick(Sender: TObject);
    //procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure rrCancelClick(Sender: TObject);
    procedure recPrevClick(Sender: TObject);
    procedure EasyRectangleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure recDcListClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Top1TimerTimer(Sender: TObject);

  private
    { Private declarations }
    FSec: Integer;
    FMouseDownX: Extended;
    FMouseDownY: Extended;
    FReadStr: string;
    BarcodeIn: Boolean;

    procedure LeagueUse(AUse: Boolean);
    //function TeeboxPlayList: Boolean;
  public
    { Public declarations }
    ErrorMsg: string;

    procedure Display;

    //procedure AddProduct(AProduct: TProductInfo);
    //procedure MinusProduct(AProduct: TProductInfo);

    procedure chgPaySelect(AIdx: Integer; AUse: Boolean);

    procedure Animate(Index: Integer);

    procedure ShowAmt;

    //function DeleteDiscount(AQRCode: string): Boolean;
    function CheckEndTime: Boolean;
  end;

var
  SaleProduct: TSaleProduct;

implementation

uses
  uGlobal, uConsts, uFunction, fx.Logging, uCommon, Form.Select.Box, Form.Full.Popup;

{$R *.fmx}

procedure TSaleProduct.FormCreate(Sender: TObject);
begin
  FSec := 0;
  {
  Comport.Port := 'COM' + IntToStr(Global.Config.Scanner.Port);

  //Comport.BaudRate := br115200; -> 트로스
  //Comport.BaudRate := br9600; -> 씨아이테크
  if Global.Config.Scanner.BaudRate = 9600 then
    Comport.BaudRate := br9600
  else if Global.Config.Scanner.BaudRate = 115200 then
    Comport.BaudRate := br115200
  else
    Comport.BaudRate := br115200;
  }
end;


procedure TSaleProduct.FormDestroy(Sender: TObject);
begin
	Timer1.Enabled := False;
	DeleteChildren;
end;

procedure TSaleProduct.FormShow(Sender: TObject);
begin
  Display;
  Timer1.Enabled := True;
end;

procedure TSaleProduct.Display;
var
  Index, RowIndex, Loop: Integer;
  AItemStyle: TSalePaymentItemStyle;
  sStr, sLaneNo: String;
	//rBowlerInfo: TBowlerInfo;
	rSaleData: TSaleData;
  nDiv, nMod: Integer;
	nLane1, nLane2: Integer;
  sTime: string;
begin
  //ksj 230823 결제화면에서 회원가입 비활성화
	Top1.Rectangle3.Fill.Color := $FFD9D9D9;
	Top1.Rectangle3.Stroke.Color := $FF909092;
	Top1.txtNewMember.TextSettings.FontColor := $FF909092;

  if Global.SaleModule.GameInfo.LaneUse = '2' then
	begin
    nLane1 := Global.SaleModule.GameInfo.Lane1;
    nLane2 := Global.SaleModule.GameInfo.Lane2;

    sStr := IntToStr(nLane1) + '-' + IntToStr(nLane2);
  end
	else
		sStr := IntToStr(Global.SaleModule.LaneInfo.LaneNo);

  txtTitle.Text := sStr + '번 레인 게임 요금제';
  //ksj 230814
	if Global.SaleModule.LaneInfo.ExpectedEndDatetime = '' then
		txtTitleTime.Text := format('%s(%s)', [FormatDateTime('YYYY.MM.DD', now), GetWeekDay(now)]) + ' ' + Global.SaleModule.NowTime
	else
	begin
		sTime := Copy(Global.SaleModule.LaneInfo.ExpectedEndDatetime, 12, 5);
		txtTitleTime.Text := format('%s(%s)', [FormatDateTime('YYYY.MM.DD', now), GetWeekDay(now)]) + ' ' + sTime;
	end;

  ImgLayout.Scale.X := Layout.Scale.X;
  ImgLayout.Scale.Y := Layout.Scale.Y;

	Top1.lblDay.Text := Global.SaleModule.NowHour;
	Top1.lblTime.Text := Global.SaleModule.NowTime;
	Top1.txtStoreNm.Text := Global.Config.Store.StoreName;
	ErrorMsg := EmptyStr;

	if Timer.Enabled = False then
		recTime.Visible := False;

  try
    RowIndex := 0;

    for Index := VertScrollBox.Content.ChildrenCount - 1 downto 0 do
      VertScrollBox.Content.Children[Index].Free;

    VertScrollBox.Content.DeleteChildren;
    VertScrollBox.Repaint;

    for Index := 0 to Global.SaleModule.PayProductList.Count - 1 do
		begin
      AItemStyle := TSalePaymentItemStyle.Create(nil);

      AItemStyle.Position.X := 0;
      AItemStyle.Position.Y := (RowIndex * AItemStyle.Height); // + (RowIndex * 30);
      //AItemStyle.Display(Global.SaleModule.BuyProductList[Index]);
      AItemStyle.Parent := VertScrollBox;

      AItemStyle.Display(Global.SaleModule.PayProductList[Index]);
      Inc(RowIndex);
    end;

    LeagueUse(Global.SaleModule.GameInfo.LeagueUse);

	finally
		ShowAmt;
  end;

end;

procedure TSaleProduct.LeagueUse(AUse: Boolean);
begin
  if AUse = True then
  begin
    imgLeagueY.Visible := True;
    imgLeagueN.Visible := False;

    imgGeneralY.Visible := False;
    imgGeneralN.Visible := True;
  end
  else
  begin
    imgLeagueY.Visible := False;
    imgLeagueN.Visible := True;

    imgGeneralY.Visible := True;
    imgGeneralN.Visible := False;
  end;
end;

procedure TSaleProduct.EasyRectangleClick(Sender: TObject);
begin
  try
		Log.D('AppCardRectangleClick', 'Begin');
		EasyRectangle.Enabled := False;
		CardRectangle.Enabled := False;

		Timer1.Enabled := False; //점멸 멈춤
		Text9.Visible := True;
		Text16.Visible := True;

		Timer.Enabled := False;
		FSec := 0;
    Global.SaleModule.CardApplyType := catAppCard;
    {
    if not CheckEndTime then
    begin
      Log.D('AppCardRectangleClick CheckEndTime', 'Out');
      //BackImageClick(nil);
      Exit;
    end;
    }
    if not ShowFullPopup then
		begin
			if recTime.Visible = True then
				Timer.Enabled := True;

			Global.SaleModule.PopUpFullLevel := pflNone;
			Global.SaleModule.PopUpLevel := plNone;
			Global.SaleModule.CardApplyType := catNone;

      Timer1.Enabled := True;

      //ksj 230828 에러메세지 길이에 따라 한줄,두줄 표시
			if Length(ErrorMsg) > 18 then
				Global.SBMessage.ShowMessage('12', '알림', ErrorMsg)
			else
				Global.SBMessage.ShowMessage('11', '알림', ErrorMsg);

      ErrorMsg := EmptyStr;
    end;
    //else
      //ModalResult := mrOk;

    Log.D('AppCardRectangleClick', 'End');
  finally
    EasyRectangle.Enabled := True;
    CardRectangle.Enabled := True;

    Global.SaleModule.CardApplyType := catNone;
  end;
end;

procedure TSaleProduct.CardRectangleClick(Sender: TObject);
var
	sResult: String;
	I: Integer;
begin
	try
		Log.D('CardRectangleClick', 'Begin');
		EasyRectangle.Enabled := False;
		CardRectangle.Enabled := False;

		Timer1.Enabled := False; //점멸 멈춤
		Text9.Visible := True;
		Text16.Visible := True;

		Timer.Enabled := False;
    FSec := 0;
		Global.SaleModule.CardApplyType := catMagnetic;
		{
		if not CheckEndTime then
		begin
			Log.D('CardRectangleClick CheckEndTime', 'Out');
			//BackImageClick(nil);
			Exit;
		end;
		}

    //사용가능여부 체크 - 회원      여기 조건들은 다시 살펴봐야함
    sResult := Global.ErpApi.GetAvailableForSalesList;
    if sResult <> 'success' then
    begin
			Global.SBMessage.ShowMessage('11', '알림', sResult);
			Timer1.Enabled := True;
      Exit;
    end;

    if Global.SaleModule.PayProductList.Count = 0 then
    begin
			Global.SBMessage.ShowMessage('11', '알림', MSG_ADD_PRODUCT);
			Timer1.Enabled := True;
			if recTime.Visible = True then
				Timer.Enabled := True;

			Exit;
		end;

		if Global.SaleModule.PaySelRealAmt = 0 then
		begin
			Global.SBMessage.ShowMessage('11', '알림', MSG_NOT_PAY_AMT);
			Timer1.Enabled := True;
			if recTime.Visible = True then
				Timer.Enabled := True;

			Exit;
		end;

		if Global.Config.NoPayModule then
		begin
			Global.SBMessage.ShowMessage('11', '알림', '결제 가능한 장비가 없습니다.');
			Timer1.Enabled := True;
      Exit;
    end;

    TouchSound(False, True);

    Global.SaleModule.PopUpFullLevel := pflPayCard;
    if ShowFullPopup = False then
		begin
			if recTime.Visible = True then
        Timer.Enabled := True;

			Global.SaleModule.PopUpFullLevel := pflNone;
			Global.SaleModule.PopUpLevel := plNone;
			Global.SaleModule.CardApplyType := catNone;

			Timer1.Enabled := True;
		end
		else
		begin
			recPrev.Visible := False;
			rrCancel.Visible := False;

			Global.SaleModule.SaleCompleteProc;
			Display;

			if Global.SaleModule.PayListAllResult = True then
			begin
				Global.SaleModule.SaleCompleteAssign; //배정
				ModalResult := mrOk;
			end
			else
			begin
        recTime.Visible := True;
				Timer.Enabled := True;
				Timer1.Enabled := True;
			end;
    end;

    //모든 결제 완료후 배정요청 필요

		Log.D('CardRectangleClick', 'End');
  finally
    EasyRectangle.Enabled := True;
    CardRectangle.Enabled := True;

    Global.SaleModule.CardApplyType := catNone;
  end;
end;

function TSaleProduct.CheckEndTime: Boolean;
var
  Index: Integer;
begin
  try
  {
    TeeboxPlayList;
    if Global.SaleModule.BuyProductList[0].Products.Product_Div <> PRODUCT_TYPE_D then
      Result := True
    else
      Result := Global.SaleModule.TeeboxTimeCheck;
      }
  finally

  end;
end;
{
procedure TSaleProduct.ComPortRxChar(Sender: TObject; Count: Integer);
var
  TempBuff: string;
  AMember: TMemberInfo;
  ADiscount: TDiscount;
begin
  try
    if BarcodeIn then
      Exit;

    //Comport.ReadStr(TempBuff, Count);

    FReadStr := FReadStr + TempBuff;
    if Copy(FReadStr, Length(FReadStr), 1) = #$D then
    begin
      BarcodeIn := True;
      Global.SaleModule.PaycoModule.SetBarcode(FReadStr);
      Log.D('Payco Barcode', FReadStr);
      FReadStr := EmptyStr;
    end;
  except
    on E: Exception do
    begin
      Log.E('Payco Barcode', E.Message);
    end;
  end;
end;
}
{
function TSaleProduct.DeleteDiscount(AQRCode: string): Boolean;
begin
  //Global.SaleModule.DeleteDiscount(AQRCode);

  ShowAmt;
end;
}
procedure TSaleProduct.recDcListClick(Sender: TObject);
begin
	Timer.Enabled := False;
	FSec := 0;
	Timer1.Enabled := False; //점멸 멈춤
	Text9.Visible := True;
	Text16.Visible := True;
	Global.SaleModule.PopUpLevel := plPayDcList;
	ShowPopup;

  Timer1.Enabled := True;
	if recTime.Visible = True then
		Timer.Enabled := True;
end;

procedure TSaleProduct.recPrevClick(Sender: TObject);
begin
  Global.SaleModule.PayListClear;
  ModalResult := mrRetry;
end;

procedure TSaleProduct.Rectangle1Click(Sender: TObject);
begin
  Global.SaleModule.PayListClear;
  ModalResult := mrCancel;
end;

procedure TSaleProduct.rrCancelClick(Sender: TObject);
begin
  TouchSound(False, False);
  ModalResult := mrCancel;
end;

procedure TSaleProduct.ShowAmt;
begin
  txtAmtShoes.Text := Format('+%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayShoesAmt)]);
  txtAmtGame.Text := Format('+%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayGameAmt)]);

  txtDCAmt.Text := Format('%s원', [FormatFloat('#,##0.##', -1 * Global.SaleModule.PayDCAmt)]);
  if Global.SaleModule.PayDCAmt > 0 then
		recDcList.Visible := True
	else
		recDcList.Visible := False;

  txtRealAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayRealAmt)]);

  txtSelRealAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelRealAmt)]); //선택금액
  txtRemainAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayRemainAmt)]); //잔여금액
  { //화면 표시 변경 보류
  if Global.SaleModule.PaySelRealAmt = 0 then
  begin
    recPriceBG.Height := 362;
    recRemainAmt.Visible := False;
    recLineView.Visible := False;
    recSelRealAmt.Position.Y := 268;
  end
  else
  begin
    recPriceBG.Height := 470;
    recRemainAmt.Visible := True;
    recLineView.Visible := True;
    recSelRealAmt.Position.Y := 376;
  end;
  }
end;
{
function TSaleProduct.TeeboxPlayList: Boolean;
begin
  try
    try
      Log.D('TSaleProduct.TeeboxPlayList', 'Begin');
      Result := False;

      // 타석정보를 다시 읽어 온다.
      //Global.Lane.GetGMTeeBoxList;

      Result := True;
    except
      on E: Exception do
      begin
        Log.E('TSaleProduct.TeeboxPlayList', E.Message);
      end;
    end;
  finally
    Log.D('TSaleProduct.TeeboxPlayList', 'End');
  end;
end;
}
procedure TSaleProduct.Timer1Timer(Sender: TObject);
begin
	Text9.Visible := not Text9.Visible;
	Text16.Visible := not Text16.Visible;
end;

procedure TSaleProduct.TimerTimer(Sender: TObject);
var
	I: Integer;
	rGameInfo: TGameInfo;
begin
	try
		Inc(FSec);
		txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec * 2 - FSec), 2, ' ')]);

		if (Time30Sec * 2 - FSec) = 0 then
		begin
			Timer.Enabled := False;
			Timer1.Enabled := False;
      Text9.Visible := True;
		  Text16.Visible := True;
			//ksj 230904 결제시간 초과시
			if Global.SBMessage.ShowMessage('12', '안내', '결제 시간이 초과되었습니다. 확인시' + #13 + '현재까지 결제한 사용자만 배정됩니다.', False) then
			begin
				for I := Global.SaleModule.PayProductList.Count - 1 downto 0 do
				begin
					if Global.SaleModule.PayProductList[I].PayResult = False then
						Global.SaleModule.PayProductList.Delete(I);
				end;
			end
			else
			begin
				FSec := 0;
				Timer.Enabled := True;
				Timer1.Enabled := True;
      end;
		end;
		if Global.SaleModule.PayListAllResult = True then
		begin
			Global.SaleModule.delLaneCheak; //2개레인인경우 삭제된 레인검증
			Global.SaleModule.SaleCompleteAssign; //배정
			ModalResult := mrOk;
		end;

	except
		on E: Exception do
			Log.E(ClassName, E.Message);
	end;
end;

procedure TSaleProduct.chgPaySelect(AIdx: Integer; AUse: Boolean);
begin
	FSec := 0;
  Global.SaleModule.chgPayListSelect(AIdx, AUse);
	Display;
end;

procedure TSaleProduct.Animate(Index: Integer);
begin
    //MemberSaleProductListStyle1.Animate(MemberSaleProductListStyle1.ItemList[Index]);
end;

procedure TSaleProduct.BottomRectangleClick(Sender: TObject);
begin
  TouchSound;
end;


procedure TSaleProduct.Top1TimerTimer(Sender: TObject);
begin
  Top1.TimerTimer(Sender);

end;

end.
