unit Form.Sale.Time.Bowler;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.ListBox,
  Frame.Top, Frame.Sale.Time.List.Item.Style;

type
  TSaleTimeBowler = class(TForm)
    ImgLayout: TLayout;
    BGRectangle: TRectangle;
    Layout: TLayout;
    TopLayout: TLayout;
    recTop: TRectangle;
    txtTitle: TText;
    recLaneListTitle: TRectangle;
		Text2: TText;
    Text7: TText;
    Text10: TText;
    Text12: TText;
    Rectangle2: TRectangle;
    recPriceTotal: TRectangle;
    Text1: TText;
    txtTotalAmt: TText;
    recPriceDc: TRectangle;
    Text3: TText;
    txtDcAmt: TText;
    BottomLayout: TLayout;
    recAmt: TRectangle;
    recOk: TRectangle;
    txtOk: TText;
    recListDesc: TRectangle;
    VertScrollBox: TVertScrollBox;
    recLane1: TRectangle;
    recAmt1: TRectangle;
    txtAmt1: TText;
    recShoesCnt1: TRectangle;
    Text6: TText;
    recMemberCnt1: TRectangle;
    recLane2: TRectangle;
    recAmt2: TRectangle;
    txtAmt2: TText;
    recShoesCnt2: TRectangle;
    Text14: TText;
    recMemberCnt2: TRectangle;
    txtMemberCnt1: TText;
    txtShoesCnt1: TText;
    txtShoesCnt2: TText;
    txtMemberCnt2: TText;
    Top1: TTop;
    recBottom: TRectangle;
    rrPrev: TRoundRect;
    txtPrev: TText;
    txtTitleTime: TText;
    recGeneral: TRectangle;
    imgGeneralN: TImage;
    imgGeneralY: TImage;
    recLeage: TRectangle;
    imgLeagueN: TImage;
    imgLeagueY: TImage;
    recListBG: TRectangle;
    recLane: TRectangle;
    recDcList: TRectangle;
    recLine: TRectangle;
    recListTitle: TRectangle;
    txtBowler: TText;
    txtLane: TText;
    txtShoes: TText;
    recDisType: TText;
    recPriceBG: TRectangle;
    Rectangle8: TRectangle;
    Text17: TText;
    Image1: TImage;
    Timer1: TTimer;
    recNotice: TRectangle;
    txtNotice1: TText;
    txtNotice2: TText;
    txtNotice3: TText;
    recTitle1: TRectangle;
    recTitle5: TRectangle;
    recTitle4: TRectangle;
    recTitle3: TRectangle;
    recTitle2: TRectangle;
    txtDelete: TText;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
    procedure rrPrevClick(Sender: TObject);
    procedure recOkClick(Sender: TObject);
    procedure Rectangle8Click(Sender: TObject);
    procedure imgGeneralYClick(Sender: TObject);
    procedure imgLeagueYClick(Sender: TObject);
		procedure Timer1Timer(Sender: TObject);
	private
    { Private declarations }
    FLaneBowlerCnt: Integer; //레인에 할당된 볼러수
    FLane1: Integer;
    FLane2: Integer;

    FItemList: TList<TSaleTimeItemStyle>;

    procedure DisplayInit;
    procedure Display;
    procedure LeagueUse(AUse: Boolean);
  public
    { Public declarations }
    procedure delBuyProduct(AIdx: Integer); //ksj 230831
    procedure ShowAmt;

    function chgBowlerNm(ASeq: Integer): Boolean;
    function chgLane(AIdx: Integer; AUse: String): Boolean;
    function chgShoes(AIdx: Integer; AUse: String): Boolean;
  end;

var
  SaleTimeBowler: TSaleTimeBowler;

implementation

uses
  uGlobal, uStruct, uFunction, uConsts, uCommon, fx.Logging, Form.Select.Box;

{$R *.fmx}

procedure TSaleTimeBowler.FormCreate(Sender: TObject);
begin
//
end;

procedure TSaleTimeBowler.FormDestroy(Sender: TObject);
var
	Index: Integer;
begin
	if FItemList <> nil then
	begin
		for Index := FItemList.Count - 1 downto 0 do
			RemoveObject(FItemList[Index]);//ItemList.Delete(Index);

		FItemList.Free;
	end;
	DeleteChildren;
end;

procedure TSaleTimeBowler.FormShow(Sender: TObject);
begin
  if Global.SaleModule.BuyProductList.Count > 0 then
    Display
  else
		DisplayInit;

  Timer1.Enabled := True; //ksj 230816
end;

procedure TSaleTimeBowler.imgGeneralYClick(Sender: TObject);
begin
  LeagueUse(False);
end;

procedure TSaleTimeBowler.imgLeagueYClick(Sender: TObject);
begin
  if Global.SaleModule.GameInfo.LaneUse = '1' then
    Exit;

  LeagueUse(True);
end;

procedure TSaleTimeBowler.DisplayInit;
var
  Index, RowIndex, Loop: Integer;
  AItemStyle: TSaleTimeItemStyle;
  sStr, sLaneNo: String;
  //rBowlerInfo: TBowlerInfo;
	rSaleData: TSaleData;
  nDiv, nMod: Integer;
  //nLane1, nLane2: Integer;
	//rMemberInfo: TMemberInfo;
	sTime: string;
	aTime: TDateTime;
begin
	try
		FLaneBowlerCnt := 0;

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


		//div	정수 나누기의 몫	9 div 2 = 4
		//mod	정수 나누기의 나머지	9 mod 2 = 1
		if Global.SaleModule.GameInfo.LaneUse = '2' then //2개 레인 사용
		begin
			sStr := IntToStr(FLane1) + '-' + IntToStr(FLane2);

			text6.Text := '레인 ' + IntToStr(FLane1);
			text14.Text := '레인 ' + IntToStr(FLane2);

			nDiv := global.SaleModule.GameInfo.BowlerCnt div 2;
			nMod := global.SaleModule.GameInfo.BowlerCnt mod 2;
			FLaneBowlerCnt:= nDiv + nMod;
		end
		else
		begin
      text14.Text := '-';
			recMemberCnt2.Fill.Color := $FFD9D9D9;
			txtMemberCnt2.TextSettings.FontColor := $FF909092;
			txtMemberCnt2.Text := '-';
			recShoesCnt2.Fill.Color := $FFD9D9D9;
			txtShoesCnt2.TextSettings.FontColor := $FF909092;
			txtShoesCnt2.Text := '-';
			recAmt2.Fill.Color := $FFD9D9D9;
			txtAmt2.TextSettings.FontColor := $FF909092;
			txtAmt2.Text := '-';
			if Global.SaleModule.LaneInfo.LaneNo = FLane1 then
			begin
				sStr := IntToStr(FLane1);
				text6.Text := '레인 ' + sStr;
			end
			else
			begin //230907 레인1개 사용시 짝수레인이어도 윗줄에 표시
				sStr := IntToStr(FLane2);
				text6.Text := '레인 ' + sStr;

//				sStr := IntToStr(FLane2);
//				text14.Text := '레인 ' + sStr;
//
//				text6.Text := '-';
//				recMemberCnt1.Fill.Color := $FFD9D9D9;
//				txtMemberCnt1.TextSettings.FontColor := $FF909092;
//				txtMemberCnt1.Text := '-';
//				recShoesCnt1.Fill.Color := $FFD9D9D9;
//				txtShoesCnt1.TextSettings.FontColor := $FF909092;
//				txtShoesCnt1.Text := '-';
//				recAmt1.Fill.Color := $FFD9D9D9;
//				txtAmt1.TextSettings.FontColor := $FF909092;
//				txtAmt1.Text := '-';
			end;
		end;

		txtTitle.Text := sStr + '번 레인 시간 요금제';
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

		ImgLayout.Scale.X := Layout.Scale.X;
		ImgLayout.Scale.Y := Layout.Scale.Y;

		//ShowAmt;
		//Timer.Enabled := True;
		Top1.lblDay.Text := Global.SaleModule.NowHour;
		Top1.lblTime.Text := Global.SaleModule.NowTime;
		Top1.txtStoreNm.Text := Global.Config.Store.StoreName;
		//ErrorMsg := EmptyStr;

		try
			if FItemList = nil then
				FItemList := TList<TSaleTimeItemStyle>.Create;

			if FItemList.Count <> 0 then
			begin
				for Index := FItemList.Count - 1 downto 0 do
					FItemList.Delete(Index);

				FItemList.Clear;
			end;

			RowIndex := 0;

			for Index := VertScrollBox.Content.ChildrenCount - 1 downto 0 do
				VertScrollBox.Content.Children[Index].Free;

			VertScrollBox.Content.DeleteChildren;
			VertScrollBox.Repaint;

			for Index := 0 to Global.SaleModule.GameInfo.BowlerCnt - 1 do
			begin

				AItemStyle := TSaleTimeItemStyle.Create(nil);

				AItemStyle.Position.X := 0;
				AItemStyle.Position.Y := (RowIndex * AItemStyle.Height) + 18; // + (RowIndex * 30);
				AItemStyle.Parent := VertScrollBox;

				rSaleData.BowlerSeq := Index + 1;

				sLaneNo := '';
				if FLaneBowlerCnt > 0 then
				begin
					if FLaneBowlerCnt > Index then
					begin
						sLaneNo := IntToStr(FLane1);
						rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Index];
						rSaleData.BowlerNm := rSaleData.BowlerId;
						rSaleData.LaneNo := FLane1;
					end
					else
					begin
						sLaneNo := IntToStr(FLane2);
						rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Index - FLaneBowlerCnt];
						rSaleData.BowlerNm := rSaleData.BowlerId;
						rSaleData.LaneNo := FLane2;
					end;
				end
				else
				begin
					sLaneNo := IntToStr(Global.SaleModule.LaneInfo.LaneNo);
					rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Index];
					rSaleData.BowlerNm := rSaleData.BowlerId;
					rSaleData.LaneNo := Global.SaleModule.LaneInfo.LaneNo;
				end;

				rSaleData.GameProduct := Global.SaleModule.GetGameProductFee('102', Global.Config.Store.TimeDefaultProdCd);
        //ksj 230817 요금제가 대화료 무료인 경우
				if rSaleData.GameProduct.ShoesFreeYn = 'Y' then
					rSaleData.ShoesUse := 'F'
				else
					rSaleData.ShoesUse := 'Y';

				rSaleData.SaleQty := Global.SaleModule.GameInfo.GameCnt;
				rSaleData.SalePrice := (rSaleData.GameProduct.ProdAmt * rSaleData.SaleQty);

				rSaleData.PaySelect := True;
				rSaleData.PayResult := False;

				rSaleData.DcAmt := 0;
				rSaleData.DiscountList := TList<TDiscount>.Create;

				AItemStyle.Display(rSaleData);
				FItemList.Add(AItemStyle);
				Global.SaleModule.AddSaleData(rSaleData);
				Inc(RowIndex);

			end;
			LeagueUse(Global.SaleModule.GameInfo.LeagueUse);

		finally
			ShowAmt;
		end;
	except
		on E: Exception do
			Log.E('DisplayInit', E.Message);
	end;

end;

procedure TSaleTimeBowler.Display;
var
	I, Index, RowIndex, Loop: Integer;
  AItemStyle: TSaleTimeItemStyle;
  sStr, sLaneNo: String;
  //rBowlerInfo: TBowlerInfo;
	rSaleData1, rSaleData2: TSaleData;
	nDiv, nMod: Integer;
	//nLane1, nLane2: Integer;
	//rMemberInfo: TMemberInfo;
	aTime: TDateTime;
	sTime: string;
begin
	FLaneBowlerCnt := 0;

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

  //div	정수 나누기의 몫	9 div 2 = 4
  //mod	정수 나누기의 나머지	9 mod 2 = 1
  if Global.SaleModule.GameInfo.LaneUse = '2' then //2개 레인 사용
  begin
    sStr := IntToStr(FLane1) + '-' + IntToStr(FLane2);

    text6.Text := '레인 ' + IntToStr(FLane1);
    text14.Text := '레인 ' + IntToStr(FLane2);

    nDiv := global.SaleModule.GameInfo.BowlerCnt div 2;
    nMod := global.SaleModule.GameInfo.BowlerCnt mod 2;
    FLaneBowlerCnt:= nDiv + nMod;
  end
  else
	begin
    text14.Text := '-';
		recMemberCnt2.Fill.Color := $FFD9D9D9;
		txtMemberCnt2.TextSettings.FontColor := $FF909092;
		txtMemberCnt2.Text := '-';
		recShoesCnt2.Fill.Color := $FFD9D9D9;
		txtShoesCnt2.TextSettings.FontColor := $FF909092;
		txtShoesCnt2.Text := '-';
		recAmt2.Fill.Color := $FFD9D9D9;
		txtAmt2.TextSettings.FontColor := $FF909092;
		txtAmt2.Text := '-';
		if Global.SaleModule.LaneInfo.LaneNo = FLane1 then
		begin
			sStr := IntToStr(FLane1);
			text6.Text := '레인 ' + sStr;
    end
    else
		begin
			sStr := IntToStr(FLane2);
			text6.Text := '레인 ' + sStr;

//			sStr := IntToStr(FLane2);
//			text14.Text := '레인 ' + sStr;
//
//			text6.Text := '-';
//			recMemberCnt1.Fill.Color := $FFD9D9D9;
//			txtMemberCnt1.TextSettings.FontColor := $FF909092;
//			txtMemberCnt1.Text := '-';
//			recShoesCnt1.Fill.Color := $FFD9D9D9;
//			txtShoesCnt1.TextSettings.FontColor := $FF909092;
//			txtShoesCnt1.Text := '-';
//			recAmt1.Fill.Color := $FFD9D9D9;
//			txtAmt1.TextSettings.FontColor := $FF909092;
//      txtAmt1.Text := '-';
    end;
  end;

  txtTitle.Text := sStr + '번 레인 시간 요금제';

  ImgLayout.Scale.X := Layout.Scale.X;
  ImgLayout.Scale.Y := Layout.Scale.Y;

  //ShowAmt;
  //Timer.Enabled := True;
  Top1.lblDay.Text := Global.SaleModule.NowHour;
  Top1.lblTime.Text := Global.SaleModule.NowTime;
  Top1.txtStoreNm.Text := Global.Config.Store.StoreName;
	//ErrorMsg := EmptyStr;

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

  try
    if FItemList = nil then
        FItemList := TList<TSaleTimeItemStyle>.Create;

      if FItemList.Count <> 0 then
      begin
        for Index := FItemList.Count - 1 downto 0 do
          FItemList.Delete(Index);

        FItemList.Clear;
      end;

    RowIndex := 0;

    for Index := VertScrollBox.Content.ChildrenCount - 1 downto 0 do
      VertScrollBox.Content.Children[Index].Free;

    VertScrollBox.Content.DeleteChildren;
    VertScrollBox.Repaint;

    for Index := 0 to Global.SaleModule.BuyProductList.Count - 1 do
    begin
      AItemStyle := TSaleTimeItemStyle.Create(nil);

      AItemStyle.Position.X := 0;
      AItemStyle.Position.Y := (RowIndex * AItemStyle.Height); // + (RowIndex * 30);
      AItemStyle.Parent := VertScrollBox;

      AItemStyle.Display(Global.SaleModule.BuyProductList[Index]);
      FItemList.Add(AItemStyle);
      Inc(RowIndex);
    end;

    LeagueUse(Global.SaleModule.GameInfo.LeagueUse);

  finally
    ShowAmt;
  end;

end;

procedure TSaleTimeBowler.recOkClick(Sender: TObject);
var
	I: Integer;
	rSaleData: TSaleData;
begin
  if Global.SaleModule.RealAmt = 0 then
	begin //ksj 230824 포인트,이용권으로 게임 다 차감 후 대화료도 미사용이거나 무료일때
		Global.SaleModule.regPayList;
		for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
		begin
			rSaleData := Global.SaleModule.PayProductList[I];
			rSaleData.PaySelect := True;
			Global.SaleModule.PayProductList[I] := rSaleData;

			if rSaleData.DcProduct.ProdCd = 'P' then //포인트차감만 매출등록
				Global.SaleModule.SaleCompleteProc
			else
			begin //이용권차감은 매출등록을 안하기때문에 결제가 된것으로
				rSaleData.PayResult := True;
				Global.SaleModule.PayProductList[I] := rSaleData;
			end;
		end;
		Global.SaleModule.SaleCompleteAssign; //배정
		ModalResult := mrOk;
	end
	else
	begin
    //ksj 230831
		Global.SaleModule.SaveLaneInfo := Global.SaleModule.LaneInfo;
		Global.SaleModule.SaveGameInfo := Global.SaleModule.GameInfo;

		Global.SaleModule.regPayList;
		ModalResult := mrOk;
	end;
end;

procedure TSaleTimeBowler.Rectangle8Click(Sender: TObject);
begin
  Global.SaleModule.PopUpLevel := plBuyDcList;
  ShowPopup;
end;

procedure TSaleTimeBowler.rrPrevClick(Sender: TObject);
var
	i, nIdx, nBowlerIdx: Integer;
  sIdx, sId: String;
	bMember: Boolean;
	rSaleData: TSaleData;
begin
	if SelectBox.UndoList.Count > 0 then
	begin
		nIdx := SelectBox.UndoList.Count - 1;
		sIdx := SelectBox.UndoList[nIdx];

    for I := 0 to Global.SaleModule.BuyProductList.Count - 1 do
		begin //ksj 230901
			if sIdx = Global.SaleModule.BuyProductList[I].MemberInfo.Code then
			begin
				nBowlerIdx := I;
				Break;
			end;
		end;

		Global.SaleModule.UndoSaleData(nBowlerIdx);
		FItemList[nBowlerIdx].Display(Global.SaleModule.BuyProductList[nBowlerIdx]);

		SelectBox.UndoList.Delete(nIdx);

		if SelectBox.UndoList.Count = 0 then //ksj 230728
		begin
			Global.SaleModule.TimeLane1DcType := '';
			Global.SaleModule.TimeLane2DcType := '';
		end;

		bMember := False;
		for i := 0 to FItemList.Count - 1 do
		begin
			if FItemList[i].SaleData.MemberInfo.Code <> '' then
			begin
				bMember := True;
				Break;
			end;
		end;

		if bMember = False then
			txtOk.Text := '결제하기(비회원)';

		ShowAmt;

    if SelectBox.UndoList.Count > 0 then
		begin
			if Global.SaleModule.GameInfo.LaneUse = '2' then
			begin
				for i := 0 to Global.SaleModule.BuyProductList.Count - 1 do
				begin
					rSaleData := Global.SaleModule.BuyProductList[i];
          if odd(rSaleData.LaneNo) then
					begin
						if rSaleData.DcProduct.ProdCd = 'P' then
						begin
							Global.SaleModule.TimeLane1DcType := 'P';
							Break;
						end
						else if rSaleData.DcProduct.ProdDetailDiv = '502' then
						begin
							Global.SaleModule.TimeLane1DcType := 'T';
							Break;
						end
						else
						begin
							Global.SaleModule.TimeLane1DcType := '';
							Continue;
						end;
					end;
				end;

				for i := 0 to Global.SaleModule.BuyProductList.Count - 1 do
				begin
					rSaleData := Global.SaleModule.BuyProductList[i];
					if not odd(rSaleData.LaneNo) then
					begin
						if rSaleData.DcProduct.ProdCd = 'P' then
						begin
							Global.SaleModule.TimeLane2DcType := 'P';
							Break;
						end
						else if rSaleData.DcProduct.ProdDetailDiv = '502' then
						begin
							Global.SaleModule.TimeLane2DcType := 'T';
							Break;
						end
						else
						begin
							Global.SaleModule.TimeLane2DcType := '';
							Continue;
						end;
					end;
        end;
			end
			else //ksj 230728 포인트or이용권 사용하려고 선택했다가 사용하는 회원 없을시 복합사용 안되는거 해제
			begin
        for i := 0 to Global.SaleModule.BuyProductList.Count - 1 do
				begin
          rSaleData := Global.SaleModule.BuyProductList[i];
					if rSaleData.DcProduct.ProdCd = 'P' then
					begin
						Global.SaleModule.TimeLane1DcType := 'P';
						Exit;
					end
					else if rSaleData.DcProduct.ProdDetailDiv = '502' then
					begin
						Global.SaleModule.TimeLane1DcType := 'T';
						Exit;
					end
					else
					begin
						Global.SaleModule.TimeLane1DcType := '';
						Continue;
					end;
				end;
			end;
		end
		else
		begin
      Global.SaleModule.TimeLane1DcType := '';
			Global.SaleModule.TimeLane2DcType := '';
		end;
	end
	else
	begin
		//TouchSound(False, False);
		Global.SaleModule.TimeLane1DcType := '';
		Global.SaleModule.TimeLane2DcType := '';
    ModalResult := mrCancel;
	end;
end;

procedure TSaleTimeBowler.LeagueUse(AUse: Boolean);
var
	rGameInfo: TGameInfo;
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

  //ksj 230714
  rGameInfo := Global.SaleModule.GameInfo;
  rGameInfo.LeagueUse := AUse;
  Global.SaleModule.GameInfo := rGameInfo;
end;

procedure TSaleTimeBowler.ShowAmt;
var
	I, nLane1Cnt, nLane2Cnt, nShoes1Cnt, nShoes2Cnt: Integer;
	nLane1Amt, nLane2Amt: Currency;
begin

	nLane1Cnt := 0;
	nLane2Cnt := 0;
	nShoes1Cnt := 0;
	nShoes2Cnt := 0;
	nLane1Amt := 0;
	nLane2Amt := 0;

	//ksj 230726 시간요금제 레인당 게임수로 계산
	for I := 0 to FItemList.Count - 1 do
	begin
		if Global.SaleModule.GameInfo.LaneUse = '2' then
		begin
			if FLane1 = FItemList[I].SaleData.LaneNo then
				nLane1Amt := FItemList[0].SaleData.SalePrice
			else    //총금액은 같으니까 레인요금 더할필요가없음  여기 꼭 살펴보고 수정해야함
				nLane2Amt := FItemList[0].SaleData.SalePrice;
		end
		else
		begin
			if FLane1 = FItemList[I].SaleData.LaneNo then
				nLane1Amt := FItemList[0].SaleData.SalePrice
			else
				nLane2Amt := FItemList[0].SaleData.SalePrice;
		end;
	end;

	for I := 0 to FItemList.Count - 1 do
	begin
		if FLane1 = FItemList[I].SaleData.LaneNo then
		begin
			inc(nLane1Cnt);
			if FItemList[I].SaleData.ShoesUse = 'Y' then
			begin
				inc(nShoes1Cnt);
				nLane1Amt := nLane1Amt + Global.SaleModule.SaleShoesProd.ProdAmt;
			end;
		end
		else
		begin
			inc(nLane2Cnt);
			if FItemList[I].SaleData.ShoesUse = 'Y' then
			begin
				inc(nShoes2Cnt);
				nLane2Amt := nLane2Amt + Global.SaleModule.SaleShoesProd.ProdAmt;
			end;
		end;
	end;

	//ksj 230726 시간요금제 레인당 게임수로 계산
	if Global.SaleModule.GameInfo.LaneUse = '2' then
	begin
    txtMemberCnt1.Text := IntToStr(nLane1Cnt);
    txtShoesCnt1.Text := IntToStr(nShoes1Cnt);
    txtAmt1.Text := Format('%s', [FormatFloat('#,##0.##', nLane1Amt)]);

    txtMemberCnt2.Text := IntToStr(nLane2Cnt);
    txtShoesCnt2.Text := IntToStr(nShoes2Cnt);
    txtAmt2.Text := Format('%s', [FormatFloat('#,##0.##', nLane2Amt)]);
  end
  else
	begin
		if Global.SaleModule.LaneInfo.LaneNo = FLane1 then
    begin
      txtMemberCnt1.Text := IntToStr(nLane1Cnt);
      txtShoesCnt1.Text := IntToStr(nShoes1Cnt);
      txtAmt1.Text := Format('%s', [FormatFloat('#,##0.##', nLane1Amt)]);
    end
    else
		begin //230907 레인1개 사용시 짝수레인이어도 윗줄에 표시
			txtMemberCnt1.Text := IntToStr(nLane2Cnt);
			txtShoesCnt1.Text := IntToStr(nShoes2Cnt);
			txtAmt1.Text := Format('%s', [FormatFloat('#,##0.##', nLane2Amt)]);

//      txtMemberCnt2.Text := IntToStr(nLane2Cnt);
//      txtShoesCnt2.Text := IntToStr(nShoes2Cnt);
//			txtAmt2.Text := Format('%s', [FormatFloat('#,##0.##', nLane2Amt)]);
		end;
	end;

	//chy 2023-08-03 이용내역 표시 제외
	if Global.SaleModule.DCAmt = 0 then
	begin
		//recPriceBG.Height := 118;
		//recPriceDc.Visible := False;
		//recPriceTotal.Position.Y := 24;

		if Global.SaleModule.GameInfo.LaneUse = '2' then
			txtTotalAmt.Text := Format('%s원', [FormatFloat('#,##0.##', nLane1Amt + nLane2Amt)])
		else
		begin
			if Global.SaleModule.LaneInfo.LaneNo = FLane1 then
				Global.SaleModule.TotalAmt := nLane1Amt
			else
				Global.SaleModule.TotalAmt := nLane2Amt;

			txtTotalAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.TotalAmt)]); //전체
		end;
	end
	else
	begin
		Global.SaleModule.TotalAmt := nLane1Amt + nLane2Amt;
		Global.SaleModule.RealAmt := Global.SaleModule.TotalAmt - Global.SaleModule.DCAmt;

		//recPriceBG.Height := 182;
		//recPriceDc.Visible := True;
		//recPriceTotal.Position.Y := 88;

		txtDCAmt.Text := Format('%s원', [FormatFloat('#,##0.##', -1 * Global.SaleModule.DCAmt)]);
		txtTotalAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.RealAmt)]);
	end;        //ksj 230719 할인금액 있을때 총금액 표시 변경
end;

procedure TSaleTimeBowler.Timer1Timer(Sender: TObject);
begin //ksj 230816 결제하기 버튼 점멸
	txtOk.Visible := not txtOk.Visible;
end;

function TSaleTimeBowler.chgBowlerNm(ASeq: Integer): Boolean;
var
	nIdx, i: Integer;
	rSaleData: TSaleData;
begin
	if SelectBox.UndoList.Count > 0 then
	begin
		if Global.SaleModule.GameInfo.LaneUse = '2' then
		begin
			for i := 0 to Global.SaleModule.BuyProductList.Count - 1 do
			begin
				rSaleData := Global.SaleModule.BuyProductList[i];
				if odd(rSaleData.LaneNo) then
				begin
					if rSaleData.DcProduct.ProdCd = 'P' then
					begin
						Global.SaleModule.TimeLane1DcType := 'P';
						Break;
					end
					else if rSaleData.DcProduct.ProdDetailDiv = '502' then
					begin
						Global.SaleModule.TimeLane1DcType := 'T';
						Break;
					end
					else
					begin
						Global.SaleModule.TimeLane1DcType := '';
						Continue;
					end;
				end
			end;
			for i := 0 to Global.SaleModule.BuyProductList.Count - 1 do
			begin
				rSaleData := Global.SaleModule.BuyProductList[i];
				if not odd(rSaleData.LaneNo) then
				begin
					if rSaleData.DcProduct.ProdCd = 'P' then
					begin
						Global.SaleModule.TimeLane2DcType := 'P';
						Break;
					end
					else if rSaleData.DcProduct.ProdDetailDiv = '502' then
					begin
						Global.SaleModule.TimeLane2DcType := 'T';
						Break;
					end
					else
					begin
						Global.SaleModule.TimeLane2DcType := '';
						Continue;
					end;
				end;
			end;
		end
		else //ksj 230728 포인트or이용권 사용하려고 선택했다가 사용하는 회원 없을시 복합사용 안되는거 해제
		begin
			for i := 0 to Global.SaleModule.BuyProductList.Count - 1 do
			begin
        rSaleData := Global.SaleModule.BuyProductList[i];
				if rSaleData.DcProduct.ProdCd = 'P' then
				begin
					Global.SaleModule.TimeLane1DcType := 'P';
					Break;
				end
				else if rSaleData.DcProduct.ProdDetailDiv = '502' then
				begin
					Global.SaleModule.TimeLane1DcType := 'T';
					Break;
				end
				else
				begin
					Global.SaleModule.TimeLane1DcType := '';
					Continue;
				end;
			end;
		end;
	end
	else
	begin
		Global.SaleModule.TimeLane1DcType := '';
    Global.SaleModule.TimeLane2DcType := '';
	end;

	Global.SaleModule.MemberItemType := mitChange;
	Global.SaleModule.PopUpFullLevel := pflPhone;
	Log.D('TSaleGame', 'plPhone');

	if not ShowFullPopup then
	begin
		Global.SaleModule.PopUpFullLevel := pflNone; //Clear;
		Exit;
	end;

	nIdx := ASeq - 1;

	Global.SaleModule.ChgSaleData(nIdx);
	FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);
	ShowAmt;
  //ksj 230901
	SelectBox.UndoList.Add(Global.SaleModule.BuyProductList[nIdx].MemberInfo.Code);
	txtOk.Text := '결제하기';
end;

function TSaleTimeBowler.chgLane(AIdx: Integer; AUse: String): Boolean;
var
	nIdx, I: Integer;
	nLane, nCnt, nCnt1, nCnt2: Integer;
	sIdx: string;
begin
	Result := False;

	nIdx := AIdx - 1;

	if Global.SaleModule.GameInfo.LaneUse = '2' then
	begin
		nCnt := 0;
		nCnt1 := 0;
		nCnt2 := 0;
		nLane := StrToInt(AUse);
		for I := 0 to FItemList.Count - 1 do
		begin
			if FItemList[I].SaleData.LaneNo <> nLane then
			begin
				Inc(nCnt);
			end;
		end;

		if nCnt = 1 then
		begin
			Global.SBMessage.ShowMessage('12', '알림', '레인을 이동할수 없습니다.' + #13 + '최소 1명 이상이여야 합니다.');
			Exit;
		end;

    //ksj 230821 레인이동시 최대 6명 사용가능
		for I := 0 to FItemList.Count - 1 do
		begin
			if odd(FItemList[I].SaleData.LaneNo) then
				Inc(nCnt1)
			else
				Inc(nCnt2)
		end;

		if odd(StrtoInt(AUse)) then
		begin
			if nCnt1 = 6 then
			begin
				Global.SBMessage.ShowMessage('12', '알림', '레인을 이동할수 없습니다.' + #13 + '레인당 최대 6명 사용가능 합니다.');
				Exit;
			end;
		end
		else
		begin
			if nCnt2 = 6 then
			begin
				Global.SBMessage.ShowMessage('12', '알림', '레인을 이동할수 없습니다.' + #13 + '레인당 최대 6명 사용가능 합니다.');
				Exit;
			end;
		end;

		//ksj 230808 레인별 금액이기 때문에 레인이동시 중복차감방지
		if Global.SaleModule.BuyProductList[nIdx].DcAmt > 0 then
		begin
			if Global.SBMessage.ShowMessage('12', '알림', '레인이동시 회원 인증정보가' + #13 + ' 초기화 됩니다.', False) then
			begin
        for I := 0 to SelectBox.UndoList.Count - 1 do
				begin //해당 인덱스의 값(BuyProductList[값]) 구하기
					sIdx := SelectBox.UndoList[I]; //맴버코드
					if sIdx = Global.SaleModule.BuyProductList[nIdx].MemberInfo.Code then
					begin
						Global.SaleModule.UndoSaleData(nIdx);
						SelectBox.UndoList.Delete(I);
						Break;
					end;
				end;

				Global.SaleModule.chgSaleDataLane(nIdx, AUse);
        Global.SaleModule.reCountBowlerId; //ksj 230906 레인이동 후 전체 볼러id 재설정
				for nIdx := 0 to Global.SaleModule.BuyProductList.Count - 1 do
					FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);

				ShowAmt;
				Result := True;
				Exit;
			end
			else
				Exit;
		end;
	end;

	Global.SaleModule.chgSaleDataLane(nIdx, AUse);
//  FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);
	Global.SaleModule.reCountBowlerId; //ksj 230906 레인이동 후 전체 볼러id 재설정
	for nIdx := 0 to Global.SaleModule.BuyProductList.Count - 1 do
		FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);

  ShowAmt;

  Result := True;
end;

function TSaleTimeBowler.chgShoes(AIdx: Integer; AUse: String): Boolean;
var
  nIdx: Integer;
begin
  Result := False;

  nIdx := AIdx - 1;
  Global.SaleModule.chgSaleDataShoes(nIdx, AUse);
  FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);

  ShowAmt;

  Result := True;
end;

procedure TSaleTimeBowler.delBuyProduct(AIdx: Integer);
var
	I, nIdx: Integer;
	sIdx: string;
	bIdx: Boolean;
begin
	if SelectBox.UndoList.Count > 0 then
	begin //ksj 230901
		nIdx := AIdx - 1;
		for I := 0 to SelectBox.UndoList.Count - 1 do
		begin //해당 인덱스의 값(BuyProductList[값]) 구하기
			sIdx := SelectBox.UndoList[I]; //맴버코드
			if sIdx = Global.SaleModule.BuyProductList[nIdx].MemberInfo.Code then
			begin
				Global.SaleModule.UndoSaleData(nIdx);
				SelectBox.UndoList.Delete(I);
				Break;
			end;
		end;
	end;

	Global.SaleModule.delBuyList(AIdx);
	Global.SaleModule.reCountBowlerSeq;

	Global.SaleModule.reCountBowlerId; //ksj 230906 레인이동 후 전체 볼러id 재설정
	for nIdx := 0 to Global.SaleModule.BuyProductList.Count - 1 do
		FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);

	Display;
end;

end.
