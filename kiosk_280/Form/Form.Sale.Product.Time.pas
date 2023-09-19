unit Form.Sale.Product.Time;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, Frame.Top;

type
  TSaleProductTime = class(TForm)
    ImgLayout: TLayout;
    BGRectangle: TRectangle;
    recListBG: TRectangle;
    Rectangle18: TRectangle;
    Rectangle19: TRectangle;
    Rectangle20: TRectangle;
    recPriceBG: TRectangle;
    Layout: TLayout;
    TopLayout: TLayout;
    Top1: TTop;
    ProductRectangle: TRectangle;
    Rectangle2: TRectangle;
    Rectangle5: TRectangle;
    Rectangle1: TRectangle;
    Image3: TImage;
    Text2: TText;
    txtAmtShoes: TText;
    Rectangle10: TRectangle;
    Image6: TImage;
    Text3: TText;
    txtAmtGame: TText;
    Rectangle6: TRectangle;
    Text4: TText;
    txtSelRealAmt: TText;
    Rectangle8: TRectangle;
    Text8: TText;
    txtRealAmt: TText;
    Rectangle3: TRectangle;
    Text5: TText;
    txtDCAmt: TText;
    recDcList: TRectangle;
    Text17: TText;
    Rectangle7: TRectangle;
    Rectangle11: TRectangle;
    Text6: TText;
    txtRemainAmt: TText;
    Rectangle12: TRectangle;
    Timer: TTimer;
    ProcessRectangle: TRectangle;
    BottomLayout: TLayout;
    recBottom: TRectangle;
    rrCancel: TRoundRect;
    txtCancel: TText;
    recPrev: TRoundRect;
    txtPrev: TText;
    Image1: TImage;
    recTime: TRectangle;
    txtTime: TText;
    Image7: TImage;
    recBtn: TRectangle;
    CardRectangle: TRectangle;
    Text9: TText;
    Text11: TText;
    EasyRectangle: TRectangle;
    Text15: TText;
    Text16: TText;
    recListTitle: TRectangle;
    txtProductName: TText;
    Text12: TText;
    Text7: TText;
    Text1: TText;
    Text13: TText;
    recTop: TRectangle;
    txtTitle: TText;
    txtTitleTime: TText;
    recGeneral: TRectangle;
    imgGeneralN: TImage;
    imgGeneralY: TImage;
    recLeage: TRectangle;
		imgLeagueN: TImage;
    imgLeagueY: TImage;
    recLane1: TRectangle;
    txtAmt1: TText;
    txtShoesCnt1: TText;
    txtMemberCnt1: TText;
    txtLane1: TText;
    recLane2: TRectangle;
    txtAmt2: TText;
    txtShoesCnt2: TText;
    txtMemberCnt2: TText;
    txtLane2: TText;
    Rectangle9: TRectangle;
    imgPayNonChk1: TImage;
    imgPayChk1: TImage;
    txtLane1Pay: TText;
    recPayFin1: TRectangle;
    Text21: TText;
    Rectangle13: TRectangle;
    imgPayNonChk2: TImage;
    imgPayChk2: TImage;
    txtLane2Pay: TText;
    recPayFin2: TRectangle;
    Text23: TText;
    Timer1: TTimer;
    recNotice: TRectangle;
    txtNotice1: TText;
    txtNotice2: TText;
    txtNotice3: TText;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure recPrevClick(Sender: TObject);
    procedure rrCancelClick(Sender: TObject);
    procedure imgPayChk1Click(Sender: TObject);
    procedure imgPayNonChk2Click(Sender: TObject);
    procedure CardRectangleClick(Sender: TObject);
    procedure recDcListClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
		procedure EasyRectangleClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);

	private
		{ Private declarations }
		FSec: Integer;
		FLane1: Integer;
		FLane2: Integer;
		FLane1Amt: Currency;
		FLane2Amt: Currency;
		FDcAmt1: Currency;
		FDcAmt2: Currency;
		FShoes1Cnt: Integer;
		FShoes2Cnt: Integer;

		procedure ShowAmt;
		procedure LeagueUse(AUse: Boolean);
	public
		{ Public declarations }
		ErrorMsg: string;

		procedure DisplayInit;
		procedure Display;
  end;

var
  SaleProductTime: TSaleProductTime;

implementation

uses
  uGlobal, fx.Logging, uCommon, uConsts, uStruct, uFunction;

{$R *.fmx}

procedure TSaleProductTime.FormCreate(Sender: TObject);
begin
	FSec := 0;
  Timer1.Enabled := True;
end;

procedure TSaleProductTime.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
  DeleteChildren;
end;

procedure TSaleProductTime.FormShow(Sender: TObject);
begin
  DisplayInit;
end;

procedure TSaleProductTime.DisplayInit;
var
  i: Integer;
	sStr, sLaneNo: String;
	rSaleData: TSaleData;
	nDiv, nMod: Integer;
	nLane1Cnt, nLane2Cnt, nShoes1Cnt, nShoes2Cnt: Integer;
	aTime: TDateTime;
  sTime: string;
begin
  //ksj 230823 결제화면에서 회원가입 비활성화
	Top1.Rectangle3.Fill.Color := $FFD9D9D9;
	Top1.Rectangle3.Stroke.Color := $FF909092;
	Top1.txtNewMember.TextSettings.FontColor := $FF909092;

  Top1.lblDay.Text := Global.SaleModule.NowHour;
  Top1.lblTime.Text := Global.SaleModule.NowTime;
	Top1.txtStoreNm.Text := Global.Config.Store.StoreName;
  ErrorMsg := EmptyStr;

  //ksj 230814
	if Global.SaleModule.LaneInfo.ExpectedEndDatetime = '' then
	begin
		aTime := Now + (Global.SaleModule.GameInfo.GameCnt * Global.SaleModule.GetGameProductFee('102', Global.Config.Store.TimeDefaultProdCd).UseGameMin/(24*60));
		sTime := FormatDateTime('hh:nn', aTime);
		txtTitleTime.Text := '[이용시간] ' + Global.SaleModule.NowTime + '~' + sTime;
	end
	else
	begin
		aTime := StrToDateTime(Global.SaleModule.LaneInfo.ExpectedEndDatetime) + (Global.SaleModule.GameInfo.GameCnt * Global.SaleModule.GetGameProductFee('102', Global.Config.Store.TimeDefaultProdCd).UseGameMin/(24*60));
		sTime := FormatDateTime('hh:nn', aTime);
		txtTitleTime.Text := '[이용시간] ' + Copy(Global.SaleModule.LaneInfo.ExpectedEndDatetime, 12, 5) + '~' + sTime;
	end;

  if Timer.Enabled = False then
		recTime.Visible := False;

  ImgLayout.Scale.X := Layout.Scale.X;
  ImgLayout.Scale.Y := Layout.Scale.Y;

  if Global.SaleModule.GameInfo.LaneUse = '2' then
  begin
    if odd(Global.SaleModule.LaneInfo.LaneNo) = True then
    begin
      FLane1 := Global.SaleModule.LaneInfo.LaneNo;
      FLane2 := Global.SaleModule.LaneInfo.LaneNo + 1;
    end
    else
    begin
      FLane1 := Global.SaleModule.LaneInfo.LaneNo - 1;
      FLane2 := Global.SaleModule.LaneInfo.LaneNo;
    end;

    sStr := IntToStr(FLane1) + '-' + IntToStr(FLane2);
  end
  else
  begin
    FLane1 := Global.SaleModule.LaneInfo.LaneNo;
		sStr := IntToStr(FLane1);
  end;

  txtTitle.Text := sStr + '번 레인 시간 요금제';

  try
    nLane1Cnt := 0;
    nLane2Cnt := 0;
    nShoes1Cnt := 0;
    nShoes2Cnt := 0;
		FLane1Amt := 0;
		FLane2Amt := 0;
		FDcAmt1 := 0;
		FDcAmt2 := 0;

		if Global.SaleModule.GameInfo.LaneUse = '2' then
		begin
			for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
			begin
				rSaleData := Global.SaleModule.PayProductList[I];
				if FLane1 = rSaleData.LaneNo then
				begin
					inc(nLane1Cnt);
					if rSaleData.ShoesUse = 'Y' then //rSaleData.ShoesUse = 'F'
					begin
						inc(nShoes1Cnt);
						FLane1Amt := FLane1Amt + Global.SaleModule.SaleShoesProd.ProdAmt;
					end;

					if rSaleData.DcAmt > 0 then
						FDcAmt1 := FDcAmt1 + rSaleData.DcAmt;
				end
				else
				begin
					inc(nLane2Cnt);
					if rSaleData.ShoesUse = 'Y' then
					begin
						inc(nShoes2Cnt);
						FLane2Amt := FLane2Amt + Global.SaleModule.SaleShoesProd.ProdAmt;
					end;

          if rSaleData.DcAmt > 0 then
						FDcAmt2 := FDcAmt2 + rSaleData.DcAmt;
				end;
			end;
			FLane1Amt := FLane1Amt + Global.SaleModule.PayProductList[0].SalePrice;
			FLane2Amt := FLane2Amt + Global.SaleModule.PayProductList[0].SalePrice;

			txtLane1.Text := IntToStr(FLane1);
			txtMemberCnt1.Text := IntToStr(nLane1Cnt);
			txtShoesCnt1.Text := IntToStr(nShoes1Cnt);
			FShoes1Cnt := nShoes1Cnt;
			txtAmt1.Text := Format('%s', [FormatFloat('#,##0.##', FLane1Amt)]);

			txtLane2.Text := IntToStr(FLane2);
			txtMemberCnt2.Text := IntToStr(nLane2Cnt);
			txtShoesCnt2.Text := IntToStr(nShoes2Cnt);
			FShoes2Cnt := nShoes2Cnt;
			txtAmt2.Text := Format('%s', [FormatFloat('#,##0.##', FLane2Amt)]);
		end
		else
		begin
			recLane2.Visible := False;

			for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
			begin
				rSaleData := Global.SaleModule.PayProductList[I];
				inc(nLane1Cnt);
				if rSaleData.ShoesUse = 'Y' then
				begin
					inc(nShoes1Cnt);
					FLane1Amt := FLane1Amt + Global.SaleModule.SaleShoesProd.ProdAmt;
				end;
			end; //ksj 230824 계산로직수정
			FLane1Amt := FLane1Amt + Global.SaleModule.PayProductList[0].SalePrice;

			txtLane1.Text := IntToStr(FLane1);
			txtMemberCnt1.Text := IntToStr(nLane1Cnt);
			txtShoesCnt1.Text := IntToStr(nShoes1Cnt);
			txtAmt1.Text := Format('%s', [FormatFloat('#,##0.##', FLane1Amt)]);
		end;

		txtLane1Pay.Text := 'Y';
		txtLane2Pay.Text := 'Y';

		LeagueUse(Global.SaleModule.GameInfo.LeagueUse);
	finally
		Display;
	end;

end;

procedure TSaleProductTime.EasyRectangleClick(Sender: TObject);
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
			Timer.Enabled := True;
			Timer1.Enabled := True;
      Global.SaleModule.PopUpFullLevel := pflNone;
      Global.SaleModule.PopUpLevel := plNone;
      Global.SaleModule.CardApplyType := catNone;

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

procedure TSaleProductTime.LeagueUse(AUse: Boolean);
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

procedure TSaleProductTime.CardRectangleClick(Sender: TObject);
var
  sResult: String;
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

    //사용가능여부 체크 - 회원
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

    //TouchSound(False, True);

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

procedure TSaleProductTime.Display;
var
  i: Integer;
	rSaleData: TSaleData;
	bLane1PaySelect, bLane2PaySelect: Boolean;
	bLane1PayResult, bLane2PayResult: Boolean;
  AlphaColor: TAlphaColor;
begin
  bLane1PaySelect := False;
  bLane1PayResult := False;
  bLane2PaySelect := False;
  bLane2PayResult := False;

  if Global.SaleModule.GameInfo.LaneUse = '2' then
  begin
    for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
    begin
      rSaleData := Global.SaleModule.PayProductList[I];
      if FLane1 = rSaleData.LaneNo then
      begin
				bLane1PaySelect := rSaleData.PaySelect;
        bLane1PayResult := rSaleData.PayResult;
      end
      else
      begin
        bLane2PaySelect := rSaleData.PaySelect;
        bLane2PayResult := rSaleData.PayResult;
      end;
    end;
  end
  else
  begin
		for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
    begin
      rSaleData := Global.SaleModule.PayProductList[I];
      bLane1PaySelect := rSaleData.PaySelect;
      bLane1PayResult := rSaleData.PayResult;
      Break;
    end;
  end;

  if bLane1PayResult = True then // 결제완료
  begin
    recPayFin1.Visible := True;
    imgPayChk1.Visible := False;
    imgPayNonChk1.Visible := False;

    AlphaColor :=  $FFA6A7A8;

    txtLane1.TextSettings.FontColor := AlphaColor;
    txtMemberCnt1.TextSettings.FontColor := AlphaColor;
    txtShoesCnt1.TextSettings.FontColor := AlphaColor;
    txtAmt1.TextSettings.FontColor := AlphaColor;
    txtAmt1.TextSettings.Font.Style := [TFontStyle.fsStrikeOut];
  end
  else if bLane1PaySelect = True then
  begin
    recPayFin1.Visible := False;
    imgPayChk1.Visible := True;
    imgPayNonChk1.Visible := False;

    AlphaColor :=  $FF3D55F5;

    txtLane1.TextSettings.FontColor := AlphaColor;
    txtMemberCnt1.TextSettings.FontColor := AlphaColor;
    txtShoesCnt1.TextSettings.FontColor := AlphaColor;
    txtAmt1.TextSettings.FontColor := AlphaColor;
    txtAmt1.TextSettings.Font.Style := [];
  end
  else if bLane1PaySelect = False then
  begin
    recPayFin1.Visible := False;
    imgPayChk1.Visible := False;
    imgPayNonChk1.Visible := True;

    AlphaColor :=  $FF212225;

    txtLane1.TextSettings.FontColor := AlphaColor;
    txtMemberCnt1.TextSettings.FontColor := AlphaColor;
    txtShoesCnt1.TextSettings.FontColor := AlphaColor;
    txtAmt1.TextSettings.FontColor := AlphaColor;
    txtAmt1.TextSettings.Font.Style := [];
  end;

  if bLane2PayResult = True then // 결제완료
  begin
    recPayFin2.Visible := True;
    imgPayChk2.Visible := False;
    imgPayNonChk2.Visible := False;

    AlphaColor :=  $FFA6A7A8;

    txtLane2.TextSettings.FontColor := AlphaColor;
    txtMemberCnt2.TextSettings.FontColor := AlphaColor;
    txtShoesCnt2.TextSettings.FontColor := AlphaColor;
    txtAmt2.TextSettings.FontColor := AlphaColor;
    txtAmt2.TextSettings.Font.Style := [TFontStyle.fsStrikeOut];
  end
  else if bLane2PaySelect = True then
  begin
    recPayFin2.Visible := False;
    imgPayChk2.Visible := True;
    imgPayNonChk2.Visible := False;

    AlphaColor :=  $FF3D55F5;

    txtLane2.TextSettings.FontColor := AlphaColor;
    txtMemberCnt2.TextSettings.FontColor := AlphaColor;
    txtShoesCnt2.TextSettings.FontColor := AlphaColor;
    txtAmt2.TextSettings.FontColor := AlphaColor;
    txtAmt2.TextSettings.Font.Style := [];
  end
  else if bLane2PaySelect = False then
  begin
    recPayFin2.Visible := False;
    imgPayChk2.Visible := False;
    imgPayNonChk2.Visible := True;

    AlphaColor :=  $FF212225;

    txtLane2.TextSettings.FontColor := AlphaColor;
    txtMemberCnt2.TextSettings.FontColor := AlphaColor;
    txtShoesCnt2.TextSettings.FontColor := AlphaColor;
    txtAmt2.TextSettings.FontColor := AlphaColor;
    txtAmt2.TextSettings.Font.Style := [];
  end;

  ShowAmt;

end;

procedure TSaleProductTime.ShowAmt;
var
	I: Integer;
	rSaleData, rSaleData1, rSaleData2: TSaleData;
begin //ksj 230801
	txtAmtShoes.Text := Format('+%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayShoesAmt)]);

	Global.SaleModule.GameAmt := Global.SaleModule.PayTotalAmt - Global.SaleModule.PayShoesAmt;
	Global.SaleModule.PayGameAmt := Global.SaleModule.GameAmt;
	txtAmtGame.Text := Format('+%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayGameAmt)]);

	txtDCAmt.Text := Format('%s원', [FormatFloat('#,##0.##', -1 * Global.SaleModule.PayDCAmt)]);
	if Global.SaleModule.PayDCAmt > 0 then
		recDcList.Visible := True
	else
		recDcList.Visible := False;

	Global.SaleModule.PayRealAmt := Global.SaleModule.PayShoesAmt + Global.SaleModule.PayGameAmt;
	txtRealAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayRealAmt)]);

	if Global.SaleModule.GameInfo.LaneUse = '1' then
	begin
		rSaleData1 := Global.SaleModule.PayProductList[0];

		if rSaleData1.PaySelect = False then
		begin
			Global.SaleModule.PaySelRealAmt := 0;
			Global.SaleModule.PayRemainAmt := Global.SaleModule.PayRealAmt - Global.SaleModule.PayDCAmt;
		end
		else
		begin
			Global.SaleModule.PaySelRealAmt := Global.SaleModule.PayRealAmt - Global.SaleModule.PayDCAmt;
			Global.SaleModule.PayRemainAmt := Global.SaleModule.PaySelRealAmt;
		end;
	end
	else
	begin
		for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
		begin
			rSaleData := Global.SaleModule.PayProductList[I];
			if FLane1 = rSaleData.LaneNo then
			begin
				rSaleData1.PaySelect := rSaleData.PaySelect;
				rSaleData1.PayResult := rSaleData.PayResult;
			end
			else
			begin
				rSaleData2.PaySelect := rSaleData.PaySelect;
				rSaleData2.PayResult := rSaleData.PayResult;
			end;
		end;
		//ksj 230803
		rSaleData1.SalePrice := FLane1Amt - FDcAmt1;
		rSaleData2.SalePrice := FLane2Amt - FDcAmt2;
		Global.SaleModule.PayRealAmt := FLane1Amt + FLane2Amt;
		Global.SaleModule.PayDCAmt := FDcAmt1 + FDcAmt2;
		Global.SaleModule.PaySelRealAmt := rSaleData1.SalePrice + rSaleData2.SalePrice;
		Global.SaleModule.PaySelTotalAmt := FLane1Amt + FLane2Amt;
		Global.SaleModule.PayRemainAmt := Global.SaleModule.PayRealAmt - Global.SaleModule.PayDCAmt;

		if (rSaleData1.PaySelect = True) and (rSaleData2.PaySelect = True) then
		begin
			Global.SaleModule.PaySelRealAmt := rSaleData1.SalePrice + rSaleData2.SalePrice;
			Global.SaleModule.PayRemainAmt := 0;
		end;
		if (rSaleData1.PaySelect = True) and (rSaleData2.PaySelect = False) then
		begin
			Global.SaleModule.PaySelRealAmt := Global.SaleModule.PaySelRealAmt - rSaleData2.SalePrice;
			Global.SaleModule.PaySelTotalAmt := Global.SaleModule.PaySelTotalAmt - FLane2Amt;
			Global.SaleModule.PayRemainAmt := Global.SaleModule.PayRemainAmt - rSaleData1.SalePrice;
		end;
		if (rSaleData1.PaySelect = False) and (rSaleData2.PaySelect = True) then
		begin
			Global.SaleModule.PaySelRealAmt := Global.SaleModule.PaySelRealAmt - rSaleData1.SalePrice;
			Global.SaleModule.PaySelTotalAmt := Global.SaleModule.PaySelTotalAmt - FLane1Amt;
			Global.SaleModule.PayRemainAmt := Global.SaleModule.PayRemainAmt - rSaleData2.SalePrice;
		end;
		if (rSaleData1.PaySelect = False) and (rSaleData2.PaySelect = False) then
		begin
			Global.SaleModule.PaySelRealAmt := 0;
			Global.SaleModule.PaySelTotalAmt := 0;
		end;

    //한개레인 먼저 결제했을때 잔여금액에서 빼줘야함
		if rSaleData1.PayResult = True then //결제완료 됐다는걸 체크해야하는데
		begin
			Global.SaleModule.PayRemainAmt := Global.SaleModule.PayRemainAmt - rSaleData1.SalePrice;
		end;
		if rSaleData2.PayResult = True then
		begin
      Global.SaleModule.PayRemainAmt := Global.SaleModule.PayRemainAmt - rSaleData2.SalePrice;
		end;
	end;

	txtSelRealAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelRealAmt)]); //선택금액
	txtRemainAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PayRemainAmt)]); //잔여금액
end;

procedure TSaleProductTime.Timer1Timer(Sender: TObject);
begin
  Text9.Visible := not Text9.Visible;
  Text16.Visible := not Text16.Visible;
end;

procedure TSaleProductTime.TimerTimer(Sender: TObject);
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

procedure TSaleProductTime.imgPayChk1Click(Sender: TObject);
var
  bUse: Boolean;
begin
	if (FLane1Amt = FDcAmt1) and (FShoes1Cnt = 0) then
		Exit;

	if txtLane1Pay.Text = 'N' then
		txtLane1Pay.Text := 'Y'
	else
		txtLane1Pay.Text := 'N';

	bUse := txtLane1Pay.Text = 'Y';
	FSec := 0;
	Global.SaleModule.chgPayListSelect(FLane1, bUse);
	Display;
end;

procedure TSaleProductTime.imgPayNonChk2Click(Sender: TObject);
var
	bUse: Boolean;
begin
	if (FLane2Amt = FDcAmt2) and (FShoes2Cnt = 0) then
		Exit;

  if txtLane2Pay.Text = 'N' then
    txtLane2Pay.Text := 'Y'
  else
    txtLane2Pay.Text := 'N';

  bUse := txtLane2Pay.Text = 'Y';
  FSec := 0;
	Global.SaleModule.chgPayListSelect(FLane2, bUse);
  Display;
end;

procedure TSaleProductTime.recDcListClick(Sender: TObject);
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

procedure TSaleProductTime.recPrevClick(Sender: TObject);
begin
  Global.SaleModule.PayListClear;
  ModalResult := mrRetry;
end;

procedure TSaleProductTime.rrCancelClick(Sender: TObject);
begin
	//TouchSound(False, False);
	Global.SaleModule.TimeLane1DcType := ''; //ksj 230726
  Global.SaleModule.TimeLane1DcType := ''; //ksj 230824
	ModalResult := mrCancel;
end;

end.
