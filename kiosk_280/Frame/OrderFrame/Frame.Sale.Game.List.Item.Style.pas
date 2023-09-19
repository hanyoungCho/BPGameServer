unit Frame.Sale.Game.List.Item.Style;

interface

uses
  uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.ListBox;

type
  TSaleGameItemStyle = class(TFrame)
    recBowler: TRectangle;
    recGameCnt: TRectangle;
    recPrice: TRectangle;
    txtPrice: TText;
    recLane: TRectangle;
    txtSaleQty: TText;
    recMinus: TRectangle;
    recPlus: TRectangle;
    recShoes: TRectangle;
    recMember: TRectangle;
    txtMemberNm: TText;
    Rectangle1: TRectangle;
    recLane1: TRectangle;
    txtLane1: TText;
    recLane2: TRectangle;
    txtLane2: TText;
    Rectangle4: TRectangle;
    Text3: TText;
    Image2: TImage;
    Image3: TImage;
    recNonMember: TRectangle;
    txtNonMemberNm: TText;
    txtNonMemberEtc: TText;
    imgShoesN: TImage;
    imgShoesY: TImage;
    recShoesF: TRectangle;
    recDc: TRectangle;
    txtDcType: TText;
    txtDcPrice: TText;
    Timer1: TTimer;
    recDelete: TRectangle;
    Rectangle2: TRectangle;
    imgDelete: TImage;
    procedure recMinusClick(Sender: TObject);
    procedure recPlusClick(Sender: TObject);
    procedure txtMemberNmClick(Sender: TObject);
    procedure imgShoesYClick(Sender: TObject);
    procedure imgShoesNClick(Sender: TObject);
    procedure txtLane1Click(Sender: TObject);
    procedure txtLane2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject); //ksj 230901
  private
    { Private declarations }
    //FGameCnt: Integer;
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
  Form.Sale.Game.Bowler, uCommon, uConsts, uGlobal;

{$R *.fmx}

{ TSaleGameItemStyle }

procedure TSaleGameItemStyle.Display(ASaleData: TSaleData);
var
  nPrice: Currency;
	//nLane1, nLane2: Integer;
	sMemberNm: string;
begin
  FSaleData := ASaleData;

  txtLane1.Text := IntToStr(Global.SaleModule.GameInfo.Lane1);
  txtLane2.Text := IntToStr(Global.SaleModule.GameInfo.Lane2);

  if FSaleData.LaneNo = Global.SaleModule.GameInfo.Lane1 then
    LaneCheck('1')
  else
    LaneCheck('2');

	//ksj 230829 회원명 5글자 넘을때 자르도록
	sMemberNm := FSaleData.MemberInfo.Name;
	if Length(sMemberNm) > 5 then
		sMemberNm := Copy(sMemberNm, 1, 5);

  if FSaleData.MemberInfo.Code <> '' then
  begin
    recMember.Visible := True;
    recNonMember.Visible := False;
    Timer1.Enabled := False;
		txtMemberNm.Text := sMemberNm;
  end
  else
	begin
    recMember.Visible := False;
    recNonMember.Visible := True;
    Timer1.Enabled := True;
    txtNonMemberNm.Text := FSaleData.BowlerNm;
  end;

	txtSaleQty.Text := IntToStr(FSaleData.SaleQty);

	ShoesCheck(FSaleData.ShoesUse); //FBowlerInfo.ShoesUse

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
    txtDcPrice.Text := Format('%s', [FormatFloat('#,##0.##', nPrice)]);
  end
  else
  begin
    txtPrice.Visible := True;
    recDc.Visible := False;
    txtPrice.Text := Format('%s원', [FormatFloat('#,##0.##', nPrice)]);
  end;
end;

procedure TSaleGameItemStyle.recMinusClick(Sender: TObject);
begin
  FSaleData.SaleQty := FSaleData.SaleQty - 1;
  if FSaleData.SaleQty < 1 then
    FSaleData.SaleQty := 1;

  SaleGameBowler.chgSaleQty(FSaleData.BowlerSeq, FSaleData.SaleQty);
end;

procedure TSaleGameItemStyle.recPlusClick(Sender: TObject);
begin
  FSaleData.SaleQty := FSaleData.SaleQty + 1;
  if FSaleData.SaleQty > 10 then
    FSaleData.SaleQty := 10;

	SaleGameBowler.chgSaleQty(FSaleData.BowlerSeq, FSaleData.SaleQty);
end;

procedure TSaleGameItemStyle.imgDeleteClick(Sender: TObject);
var
	sMsg: String;
	I, nCnt: Integer;
begin //ksj 230901
	nCnt := 0;
	for I := 0 to Global.SaleModule.BuyProductList.Count - 1 do
		nCnt := nCnt + 1;

  if Global.SaleModule.GameInfo.LaneUse = '2' then
	begin
		if nCnt = Global.Config.Store.LaneMiniCnt then
		begin
			Global.SBMessage.ShowMessage('13', '안내', '레인 사용에 필요한 최소 인원을' + #13 + '삭제 할 수 없습니다.' + #13 + '레인 사용 최소 인원은' + ' ' + IntToStr(nCnt) + '명입니다.');
			Exit;
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
			SaleGameBowler.delBuyProduct(FSaleData.BowlerSeq);
	end
	else
	begin
		sMsg := '선택하신 ' + txtNonMemberNm.Text + ' 회원을' + #13#10 + '삭제하시겠습니까?';
		if Global.SBMessage.ShowMessage('12', '안내', sMsg, False) then
			SaleGameBowler.delBuyProduct(FSaleData.BowlerSeq);
	end;
end;

procedure TSaleGameItemStyle.imgShoesNClick(Sender: TObject);
begin
  SaleGameBowler.chgShoes(FSaleData.BowlerSeq, 'Y');
end;

procedure TSaleGameItemStyle.imgShoesYClick(Sender: TObject);
begin
  SaleGameBowler.chgShoes(FSaleData.BowlerSeq, 'N');
end;

procedure TSaleGameItemStyle.txtLane1Click(Sender: TObject);
begin
  if Global.SaleModule.GameInfo.LaneUse = '1' then
    Exit;

  SaleGameBowler.chgLane(FSaleData.BowlerSeq, txtLane1.Text);
end;

procedure TSaleGameItemStyle.txtLane2Click(Sender: TObject);
begin
  if Global.SaleModule.GameInfo.LaneUse = '1' then
    Exit;

  SaleGameBowler.chgLane(FSaleData.BowlerSeq, txtLane2.Text);
end;

procedure TSaleGameItemStyle.LaneCheck(AUse: String);
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

procedure TSaleGameItemStyle.ShoesCheck(AUse: String);
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

procedure TSaleGameItemStyle.Timer1Timer(Sender: TObject);
begin
  if recNonMember.Visible = True then
    txtNonMemberEtc.Visible := not txtNonMemberEtc.Visible;
end;

procedure TSaleGameItemStyle.txtMemberNmClick(Sender: TObject);
begin
  SaleGameBowler.chgBowlerNm(FSaleData.BowlerSeq);
end;

end.
