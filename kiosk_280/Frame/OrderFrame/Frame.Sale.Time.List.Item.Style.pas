unit Frame.Sale.Time.List.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Objects, FMX.Colors,
  uStruct;

type
  TSaleTimeItemStyle = class(TFrame)
    recLane: TRectangle;
    recLane1: TRectangle;
    txtLane1: TText;
    recLane2: TRectangle;
    txtLane2: TText;
    recShoes: TRectangle;
    Rectangle4: TRectangle;
    Text3: TText;
    imgShoesN: TImage;
    imgShoesY: TImage;
    recBowler: TRectangle;
    recMember: TRectangle;
    txtMemberNm: TText;
    recNonMember: TRectangle;
    txtNonMemberNm: TText;
    txtNonMemberEtc: TText;
    recShoesF: TRectangle;
    Text1: TText;
    recDisType: TRectangle;
    txtDisType: TText;
    Timer1: TTimer;
    recDelete: TRectangle;
    Rectangle1: TRectangle;
    imgDelete: TImage;
    procedure txtLane1Click(Sender: TObject);
    procedure txtLane2Click(Sender: TObject);
    procedure imgShoesYClick(Sender: TObject);
    procedure imgShoesNClick(Sender: TObject);
    procedure txtNonMemberNmClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
  private
    { Private declarations }
    FSaleData: TSaleData;
  public
    { Public declarations }
    procedure Display(ASaleData: TSaleData);

    procedure LaneCheck(AUse: String);
    procedure ShoesCheck(AUse: String);

    property SaleData: TSaleData read FSaleData write FSaleData;
  end;

implementation

uses
  uGlobal, Form.Sale.Time.Bowler;

{$R *.fmx}

procedure TSaleTimeItemStyle.Display(ASaleData: TSaleData);
var
  sPrice, sMemberNm: String;
begin
  FSaleData := ASaleData;

  txtLane1.Text := IntToStr(Global.SaleModule.GameInfo.Lane1);
  txtLane2.Text := IntToStr(Global.SaleModule.GameInfo.Lane2);

  if FSaleData.LaneNo = Global.SaleModule.GameInfo.Lane1 then
    LaneCheck('1')
  else
    LaneCheck('2');

  txtDisType.Text := '-';

  if FSaleData.MemberInfo.Code <> '' then
  begin
    recMember.Visible := True;
    recNonMember.Visible := False;
		Timer1.Enabled := False;

    //ksj 230829 회원명 5글자 넘을때 자르도록
		sMemberNm := FSaleData.MemberInfo.Name;
		if Length(sMemberNm) > 5 then
			sMemberNm := Copy(sMemberNm, 1, 5);

		txtMemberNm.Text := sMemberNm;

		//우대권 미사용으로 주석처리. 적립이 없는 상태
		//if (FSaleData.DcProduct.ProdCd <> EmptyStr) and (FSaleData.DcProduct.SavePointRate > 0) then
			//txtDisType.Text := IntToStr(FSaleData.DcProduct.SavePointRate) + '%적립';

		if FSaleData.DiscountList.Count > 0 then
		begin
			if FSaleData.DiscountList[0].DcType = 'T' then
			begin //ksj 230807 몇 분 차감인지, 몇 포인트를 사용하는지
				txtDisType.Text := IntToStr(FSaleData.GameProduct.UseGameMin * FSaleData.DiscountList[0].DcValue) + '분 사용';
			end
			else if FSaleData.DiscountList[0].DcType = 'P' then  //ksj 230706           FSaleData.dcamt
			begin
				txtDisType.Text := IntToStr(FSaleData.DiscountList[0].DcAmt) + 'P 사용';
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
    recMember.Visible := False;
    recNonMember.Visible := True;
    Timer1.Enabled := True;
    txtNonMemberNm.Text := FSaleData.BowlerNm;
  end;

  ShoesCheck(FSaleData.ShoesUse); //FBowlerInfo.ShoesUse
end;

procedure TSaleTimeItemStyle.imgDeleteClick(Sender: TObject);
var
	sMsg: String;
	I, nCnt, nCnt1, nCnt2: Integer;
begin //ksj 230901
	nCnt := 0;
	nCnt1 := 0;
	nCnt2 := 0;
	for I := 0 to Global.SaleModule.BuyProductList.Count - 1 do
	begin
    nCnt := nCnt + 1;
		if Global.SaleModule.GameInfo.LaneUse = '2' then
		begin
			if odd(Global.SaleModule.BuyProductList[I].LaneNo) then
				nCnt1 := nCnt1 + 1
			else
				nCnt2 := nCnt2 + 1;
		end;
	end;

	if Global.SaleModule.GameInfo.LaneUse = '2' then
	begin
		if nCnt = 2 then
		begin
      Global.SBMessage.ShowMessage('13', '안내', '레인 사용에 필요한 최소 인원을' + #13 + '삭제 할 수 없습니다.' + #13 + '레인 사용 최소 인원은' + ' ' + IntToStr(nCnt) + '명입니다.');
			Exit;
		end
		else
		begin
			if odd(FSaleData.LaneNo) then
			begin
				if nCnt1 = 1 then
				begin
					Global.SBMessage.ShowMessage('13', '안내', '레인 사용에 필요한 최소 인원을' + #13 + '삭제 할 수 없습니다.' + #13 + '레인 사용 최소 인원은' + ' ' + IntToStr(nCnt1) + '명입니다.');
					Exit;
				end;
			end
			else
			begin
				if nCnt2 = 1 then
				begin
					Global.SBMessage.ShowMessage('13', '안내', '레인 사용에 필요한 최소 인원을' + #13 + '삭제 할 수 없습니다.' + #13 + '레인 사용 최소 인원은' + ' ' + IntToStr(nCnt2) + '명입니다.');
					Exit;
				end;
			end
		end;
	end
	else
	begin
		if nCnt = 1 then
		begin
			Global.SBMessage.ShowMessage('13', '안내', '레인 사용에 필요한 최소 인원을' + #13 + '삭제 할 수 없습니다.' + #13 + '레인 사용 최소 인원은' + ' ' + IntToStr(nCnt) + '명입니다.');
			Exit;
		end;
  end;

	if recMember.Visible = True then
	begin
		sMsg := '회원 사용자 삭제를 선택하셨습니다.' + #13#10 + '입력하신 내용이 삭제되며,' + #13#10 + '복구 할 수 없습니다.';
		if Global.SBMessage.ShowMessage('13', '안내', sMsg, False) then
			SaleTimeBowler.delBuyProduct(FSaleData.BowlerSeq);
	end
	else
	begin
		sMsg := '선택하신 ' + txtNonMemberNm.Text + ' 회원을' + #13#10 + '삭제하시겠습니까?';
		if Global.SBMessage.ShowMessage('12', '안내', sMsg, False) then
			SaleTimeBowler.delBuyProduct(FSaleData.BowlerSeq);
	end;
end;

procedure TSaleTimeItemStyle.imgShoesNClick(Sender: TObject);
begin
  SaleTimeBowler.chgShoes(FSaleData.BowlerSeq, 'Y');
end;

procedure TSaleTimeItemStyle.imgShoesYClick(Sender: TObject);
begin
  SaleTimeBowler.chgShoes(FSaleData.BowlerSeq, 'N');
end;

procedure TSaleTimeItemStyle.txtLane1Click(Sender: TObject);
begin
  if Global.SaleModule.GameInfo.LaneUse = '1' then
    Exit;

  SaleTimeBowler.chgLane(FSaleData.BowlerSeq, txtLane1.Text);
end;

procedure TSaleTimeItemStyle.txtLane2Click(Sender: TObject);
begin
  if Global.SaleModule.GameInfo.LaneUse = '1' then
    Exit;

  SaleTimeBowler.chgLane(FSaleData.BowlerSeq, txtLane2.Text);
end;

procedure TSaleTimeItemStyle.txtNonMemberNmClick(Sender: TObject);
begin
	Global.SaleModule.TimeBowlerSeq := FSaleData.BowlerSeq; //ksj 230824
	SaleTimeBowler.chgBowlerNm(FSaleData.BowlerSeq);
end;

procedure TSaleTimeItemStyle.LaneCheck(AUse: String);
begin

  if AUse = '1' then
  begin
    recLane1.Fill.Color := $FF3D55F5;
    txtLane1.TextSettings.FontColor := TAlphaColorRec.White; //TAlphaColorRec.Null

    if Global.SaleModule.GameInfo.LaneUse = '1' then
    begin
      recLane2.Fill.Color := $FFD9D9D9;
      recLane2.Stroke.Color := $FFD9D9D9;
      txtLane2.TextSettings.FontColor := $FFA6A7A8;
    end
    else
    begin
      recLane2.Fill.Color := TAlphaColorRec.White;
      txtLane2.TextSettings.FontColor := $FFB1BBFB;
    end;
  end
  else
  begin
    if Global.SaleModule.GameInfo.LaneUse = '1' then
    begin
      recLane1.Fill.Color := $FFD9D9D9;
      recLane1.Stroke.Color := $FFD9D9D9;
      txtLane1.TextSettings.FontColor := $FFA6A7A8;
    end
    else
    begin
      recLane1.Fill.Color := TAlphaColorRec.White;
      txtLane1.TextSettings.FontColor := $FFB1BBFB;
    end;

		recLane2.Fill.Color := $FF3D55F5;
    txtLane2.TextSettings.FontColor := TAlphaColorRec.White;
  end;

end;

procedure TSaleTimeItemStyle.ShoesCheck(AUse: String);
begin
  if AUse = 'Y' then
  begin
    imgShoesY.Visible := True;
    imgShoesN.Visible := False;
    recShoesF.Visible := False;
  end
  else if AUse = 'N' then
  begin
    imgShoesY.Visible := False;
    imgShoesN.Visible := True;
    recShoesF.Visible := False;
  end
  else
  begin
    imgShoesY.Visible := False;
    imgShoesN.Visible := False;
    recShoesF.Visible := True;
  end;

end;


procedure TSaleTimeItemStyle.Timer1Timer(Sender: TObject);
begin
  if recNonMember.Visible = True then
    txtNonMemberEtc.Visible := not txtNonMemberEtc.Visible;
end;

end.
