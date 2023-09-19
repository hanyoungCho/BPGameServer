unit Frame.GameSetting;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects,
  uStruct, uConsts, FMX.Layouts;

type
  TGameSetting = class(TFrame)
    recTop: TRectangle;
    recBottom: TRectangle;
    Rectangle2: TRectangle;
    Text1: TText;
    Rectangle4: TRectangle;
    Text2: TText;
    txtTitle: TText;
    recBodyTop: TRectangle;
    recBodyBottom: TRectangle;
    recBodyCenter: TRectangle;
    recBowlerCnt: TRectangle;
    txtBowlerCnt: TText;
    Text4: TText;
    Text5: TText;
    Text6: TText;
    Text7: TText;
    recGameCnt: TRectangle;
    recGameMinus: TRectangle;
    recGameplus: TRectangle;
    txtGameCnt: TText;
    recLane1: TRectangle;
    txtLane1: TText;
    recLane2: TRectangle;
    imgLane2No: TImage;
    imgLane2Ok: TImage;
    txtLane2: TText;
    Text11: TText;
    Text12: TText;
    recLeague: TRectangle;
    imgLeagueNo: TImage;
    imgLeagueOk: TImage;
    txtLeague: TText;
    recBody: TRectangle;
    recBowlPlus: TRectangle;
    recBowlerCntMinus: TRectangle;
    imgLane1No: TImage;
    imgLane1Ok: TImage;
    txtTitleLane: TText;
    Rectangle3: TRectangle;
    LayoutBG: TLayout;
    LayoutBoby: TLayout;
    Rectangle1: TRectangle;
    Image3: TImage;
    Image6: TImage;
    Rectangle5: TRectangle;
    Image5: TImage;
    Image7: TImage;
    Rectangle6: TRectangle;
    Image8: TImage;
    Text3: TText;
    Rectangle7: TRectangle;
    Image1: TImage;
    Text9: TText;
    recOpen: TRectangle;
    imgOpenNo: TImage;
    imgOpenOk: TImage;
    txtOpen: TText;
    Text13: TText;
    Text14: TText;
    recTitleTime: TRectangle;
    txtTitleTime: TText;
    imgLane2Dis: TImage;
		imgLane1Dis: TImage;
		imgLeagueDis: TImage;
    procedure Rectangle11Click(Sender: TObject);
    procedure Rectangle12Click(Sender: TObject);
    procedure recBowlPlusClick(Sender: TObject);
    procedure recGameplusClick(Sender: TObject);
    procedure recGameMinusClick(Sender: TObject);
    procedure recLane1Click(Sender: TObject);
		procedure recLane2Click(Sender: TObject);
    procedure recLeagueClick(Sender: TObject);
    procedure recBowlerCntMinusClick(Sender: TObject);
    procedure recOpenClick(Sender: TObject);
  private
    { Private declarations }
    FBowlerCnt: Integer;
		FGameCnt: Integer;
		FLane2No: Integer;
    FLane2use: Boolean;
		FProductMin: Integer; //시간제상품의 설정시간

		procedure LaneUseCheck(AType: Integer);
		procedure LeagueUseCheck(AType: Integer);
		//ksj 230911
		function LaneInfoCheck: Boolean;

	public
    { Public declarations }
    FLaneInfo: TLaneInfo;

		procedure Display;
  end;

implementation

uses                   //시간비교
  Form.Popup, uGlobal, DateUtils;

{$R *.fmx}

procedure TGameSetting.Display;
var
  rTimeProduct: TGameProductInfo;
  sTime: String;
begin
  FBowlerCnt := 1;
	FGameCnt := 1;
  FLane2use := False;
  FProductMin := 0;

	txtBowlerCnt.Text := IntToStr(FBowlerCnt);

	if Global.SaleModule.GameItemType = gitGameCnt then
	begin
		text5.Text := '이용 게임수';
		txtGameCnt.Text := IntToStr(FGameCnt);                    //ksj 230901
		Text3.Text := '2개 레인은 ' + IntToStr(Global.Config.Store.LaneMiniCnt) + '명 이상부터 사용 가능합니다.';
	end
  else
  begin
    text5.Text := '이용 시간(분)';
    rTimeProduct := Global.SaleModule.GetGameProductFee('102', Global.Config.Store.TimeDefaultProdCd);
		FProductMin := rTimeProduct.UseGameMin;
    txtGameCnt.Text := IntToStr(FGameCnt * FProductMin);
  end;

	LaneUseCheck(1);

	//chy 2023-08-02
	txtTitleLane.Text := '선택 레인: ' + IntToStr(Global.SaleModule.LaneInfo.LaneNo) + '번';
	if Global.SaleModule.LaneInfo.ExpectedEndDatetime = '' then
	begin
		recTop.Height := 312;
		Height := 1510;
    recTitleTime.Visible := False;
  end
  else
  begin
    sTime := Copy(Global.SaleModule.LaneInfo.ExpectedEndDatetime, 12, 5);
    txtTitleTime.Text := sTime + ' 이후 이용가능';
  end;

  //선택된 레인 홀수 이면
	if odd(Global.SaleModule.LaneInfo.LaneNo) = True then
    FLane2No := Global.SaleModule.LaneInfo.LaneNo + 1
  else
    FLane2No := Global.SaleModule.LaneInfo.LaneNo - 1;
end;

procedure TGameSetting.recBowlerCntMinusClick(Sender: TObject);
begin
  FBowlerCnt := FBowlerCnt - 1;
  if FBowlerCnt < 1 then
		FBowlerCnt := 1;

  txtBowlerCnt.Text := IntToStr(FBowlerCnt);

	if FBowlerCnt < 7 then
	begin
		if imgLane1Ok.Visible <> True then
		begin
			imgLane1Ok.Visible := False;
			imgLane1No.Visible := True;
			imgLane1Dis.Visible := False;
			Text11.TextSettings.FontColor := $FF212225;
		end;
  end;

	if Global.SaleModule.GameItemType = gitGameCnt then
	begin //ksj 230901 게임제 2개레인 사용시 최소인원 적용
		if FBowlerCnt < Global.Config.Store.LaneMiniCnt then
			LaneUseCheck(1);
	end
	else
	begin
		if FBowlerCnt = 1 then
			LaneUseCheck(1);
  end;
end;

procedure TGameSetting.recBowlPlusClick(Sender: TObject);
begin
  FBowlerCnt := FBowlerCnt + 1;
  if FBowlerCnt > 12 then
    FBowlerCnt := 12;

	txtBowlerCnt.Text := IntToStr(FBowlerCnt);

	if Global.SaleModule.GameItemType = gitGameCnt then
	begin
		if FBowlerCnt >= Global.Config.Store.LaneMiniCnt then
		begin
			imgLane2Dis.Visible := False;
			if imgLane2Ok.Visible = False then
			begin
				imgLane2No.Visible := True;
				imgLane2Ok.Visible := False;
			end;
			Text12.TextSettings.FontColor := $FF212225;
		end;
	end
	else
	begin
		if FBowlerCnt >= 2 then
		begin
			imgLane2Dis.Visible := False;
			if imgLane2Ok.Visible = False then
			begin
				imgLane2No.Visible := True;
				imgLane2Ok.Visible := False;
			end;
			Text12.TextSettings.FontColor := $FF212225;
		end;
	end;

	if FBowlerCnt > 6 then
		LaneUseCheck(2);
end;

procedure TGameSetting.recGameMinusClick(Sender: TObject);
begin

  FGameCnt := FGameCnt - 1;
  if FGameCnt < 1 then
    FGameCnt := 1;

  if Global.SaleModule.GameItemType = gitGameCnt then
    txtGameCnt.Text := IntToStr(FGameCnt)
  else
    txtGameCnt.Text := IntToStr(FGameCnt * FProductMin);
end;

procedure TGameSetting.recGamePlusClick(Sender: TObject);
begin

  FGameCnt := FGameCnt + 1;
  if FGameCnt > 10 then
    FGameCnt := 10;

  if Global.SaleModule.GameItemType = gitGameCnt then
    txtGameCnt.Text := IntToStr(FGameCnt)
  else
    txtGameCnt.Text := IntToStr(FGameCnt * FProductMin);
end;

procedure TGameSetting.recLane1Click(Sender: TObject);
begin
	if imgLane1Dis.Visible = True then
		Exit;

  if FLane2use = True then
  begin
    Global.LocalApi.LaneHold(FLane2No, 'N');
    FLane2use := False;
  end;

  LaneUseCheck(1);
end;

procedure TGameSetting.recLane2Click(Sender: TObject);
var
	nIdx: Integer;
	rLaneInfo: TLaneInfo;
	nLane1EndTime, nLane2EndTime: TDateTime;
begin
	if imgLane2Dis.Visible = True then
		Exit;

	if not Global.LocalApi.LaneHold(FLane2No, 'Y') then
  begin
    Global.SBMessage.ShowMessage('12', '알림', MSG_HOLD_LANE_ERROR);
    Exit;
  end;

	FLane2use := True;
	LaneUseCheck(2);
end;

function TGameSetting.LaneInfoCheck: Boolean;
var
	nIdx: Integer;
	rLaneInfo: TLaneInfo;
	nLane1EndTime, nLane2EndTime: TDateTime;
begin
	Result := False; //True = 2개레인 사용가능상태

	nIdx := Global.Lane.GetLaneInfoIndex(FLane2No);
	rLaneInfo := Global.Lane.GetLaneInfo(nIdx); //옆 레인의 정보

  if (Global.SaleModule.LaneInfo.ExpectedEndDatetime <> '') and (rLaneInfo.ExpectedEndDatetime <> '') then
	begin
		if Global.SaleModule.LaneInfo.GameDiv = rLaneInfo.GameDiv then
		begin //시간제는 2개레인 끝나는 시간이 같을때(2분차이까지), 게임제는 두 레인이 리그일때 예약가능
			nLane1EndTime := StrToDateTime(Global.SaleModule.LaneInfo.ExpectedEndDatetime);
			nLane2EndTime := StrToDateTime(rLaneInfo.ExpectedEndDatetime);

			if Global.SaleModule.LaneInfo.GameDiv = '2' then
			begin
				if MinutesBetween(nLane1EndTime, nLane2EndTime) < 3 then
				begin
					Result := True;
					Exit;
				end;
			end
			else
			begin
				if (Global.SaleModule.LaneInfo.LeagueYn = 'Y') or (rLaneInfo.LeagueYn = 'Y') then
				begin
					Result := True;
					Exit;
				end;
			end;
		end;
	end;

	if rLaneInfo.Status <> '0' then
	begin //0: 빈레인, 1:예약건, 2:홀드, 3:진행, 4: 미정, 5: 종료(미결제), 6: 종료, 7: 취소, 8: 점검
		if rLaneInfo.Status = '2' then
		begin //같은 기기가 홀드한 레인이면 선택가능
			if Global.Config.AdminID <> rLaneInfo.HoldUser then
				Result := False;
		end
		else
			Result := False;
	end
	else
		Result := True;

	if Result = False then
	begin
		Global.SBMessage.ShowMessage('11', '알림', IntToStr(FLane2No) + '번 레인은 사용중입니다');
		if FBowlerCnt > 6 then
		begin
			FBowlerCnt := 6;
      txtBowlerCnt.Text := IntToStr(FBowlerCnt);
		end;
	end;
end;

procedure TGameSetting.LaneUseCheck(AType: Integer);
begin
	if AType = 1 then
	begin
		if FLane2use = True then
		begin
			Global.LocalApi.LaneHold(FLane2No, 'N');
      FLane2use := False;
		end;

		txtLane1.Text := '1';
		imgLane1Ok.Visible := True;
		imgLane1No.Visible := False;
		imgLane1Dis.Visible := False;

		txtLane2.Text := '0';
    if Global.SaleModule.GameItemType = gitGameCnt then
		begin
			if FBowlerCnt < Global.Config.Store.LaneMiniCnt then
			begin
				imgLane2Ok.Visible := False;
				imgLane2No.Visible := False;
				imgLane2Dis.Visible := True;
				Text12.TextSettings.FontColor := $FF909092;
			end
			else
			begin
				imgLane2Ok.Visible := False;
				imgLane2No.Visible := True;
				imgLane2Dis.Visible := False;
				Text12.TextSettings.FontColor := $FF212225;
			end;
		end
		else
		begin
			if FBowlerCnt < 2 then
			begin
        imgLane2Ok.Visible := False;
				imgLane2No.Visible := False;
				imgLane2Dis.Visible := True;
				Text12.TextSettings.FontColor := $FF909092;
			end
			else
			begin
				imgLane2Ok.Visible := False;
				imgLane2No.Visible := True;
				imgLane2Dis.Visible := False;
				Text12.TextSettings.FontColor := $FF212225;
			end;
    end;

		LeagueUseCheck(1);
	end
	else
	begin
		if not LaneInfoCheck then
		begin
      if FLane2use = True then
			begin
				Global.LocalApi.LaneHold(FLane2No, 'N');
				FLane2use := False;
			end;
      Exit;
		end;

		txtLane1.Text := '0';
		if FBowlerCnt < 7 then
		begin
			imgLane1Ok.Visible := False;
			imgLane1No.Visible := True;
			imgLane1Dis.Visible := False;
			Text11.TextSettings.FontColor := $FF212225;
		end
		else
		begin
			imgLane1Ok.Visible := False;
			imgLane1No.Visible := False;
			imgLane1Dis.Visible := True;
			Text11.TextSettings.FontColor := $FF909092;
		end;

		txtLane2.Text := '1';
		imgLane2Ok.Visible := True;
		imgLane2No.Visible := False;
		imgLane2Dis.Visible := False;

		imgLeagueDis.Visible := False;
		if imgLeagueOk.Visible = False then
		begin
			imgLeagueNo.Visible := True;
			imgLeagueOk.Visible := False;
		end;
		Text14.TextSettings.FontColor := $FF212225;
	end;
end;

procedure TGameSetting.recLeagueClick(Sender: TObject);
begin
	if imgLeagueDis.Visible = True then
		Exit;

  LeagueUseCheck(2);
end;

procedure TGameSetting.recOpenClick(Sender: TObject);
begin
  LeagueUseCheck(1);
end;

procedure TGameSetting.LeagueUseCheck(AType: Integer);
begin
  if AType = 1 then
  begin
    txtOpen.Text := '1';
    imgOpenOk.Visible := True;
    imgOpenNo.Visible := False;

		txtLeague.Text := '0';

		if FLane2use then
		begin
			imgLeagueOk.Visible := False;
			imgLeagueNo.Visible := True;
			imgLeagueDis.Visible := False;
			Text14.TextSettings.FontColor := $FF212225;
		end
		else
		begin
			imgLeagueOk.Visible := False;
			imgLeagueNo.Visible := False;
			imgLeagueDis.Visible := True;
			Text14.TextSettings.FontColor := $FF909092;
		end;
  end
  else
  begin
    txtOpen.Text := '0';
    imgOpenOk.Visible := False;
    imgOpenNo.Visible := True;

    txtLeague.Text := '1';
    imgLeagueOk.Visible := True;
		imgLeagueNo.Visible := False;
		imgLeagueDis.Visible := False;
    Text14.TextSettings.FontColor := $FF212225;
  end;
end;

procedure TGameSetting.Rectangle11Click(Sender: TObject);
begin
	//ksj 230622 게임세팅중 2개레인 사용 체크한채로 취소시에 2개레인 모두 홀드취소
	Global.LocalApi.LaneHold(Global.SaleModule.LaneInfo.LaneNo, 'N');
	if FLane2use = True then
  begin
    Global.LocalApi.LaneHold(FLane2No, 'N');
    FLane2use := False;
	end;

  Popup.CloseFormStrMrCancel;
end;

procedure TGameSetting.Rectangle12Click(Sender: TObject);
var
  rGameInfo: TGameInfo;
begin

  if Global.SaleModule.GameItemType = gitGameCnt then
    rGameInfo.GameDiv := '1'
  else if Global.SaleModule.GameItemType = gitGameTime then
    rGameInfo.GameDiv := '2';

	rGameInfo.BowlerCnt := FBowlerCnt;
  rGameInfo.GameCnt := FGameCnt;

  if txtLane1.Text = '1' then
    rGameInfo.LaneUse := '1'
  else
    rGameInfo.LaneUse := '2';

  if Global.SaleModule.LaneInfo.LaneNo < FLane2No then
  begin
		rGameInfo.Lane1 := Global.SaleModule.LaneInfo.LaneNo;
    rGameInfo.Lane2 := FLane2No;
  end
  else
  begin
    rGameInfo.Lane1 := FLane2No;
    rGameInfo.Lane2 := Global.SaleModule.LaneInfo.LaneNo;
  end;

  rGameInfo.LeagueUse := txtLeague.Text = '1';

  Global.SaleModule.GameInfo := rGameInfo;

  Popup.CloseFormStrMrok('');
end;

end.
