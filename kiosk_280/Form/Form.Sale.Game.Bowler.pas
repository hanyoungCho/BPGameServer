
unit Form.Sale.Game.Bowler;

interface

uses
  Windows,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, FMX.StdCtrls, FMX.ListBox,
  {common}
  uPaycoNewModul, uStruct,
  CPort,
  {frmae}
  Frame.Top,
  Frame.Sale.Game.List.Item.Style;

type
  TSaleGameBowler = class(TForm)
    ImgLayout: TLayout;
    Layout: TLayout;
    TopLayout: TLayout;
    txtTitle: TText;
    recListTitle: TRectangle;
    recPrice: TRectangle;
    BottomLayout: TLayout;
    recOk: TRectangle;
    recAmt: TRectangle;
    txtOk: TText;
    BGRectangle: TRectangle;
    recTop: TRectangle;
    txtTitleTime: TText;
    recBottom: TRectangle;
    rrPrev: TRoundRect;
    txtPrev: TText;
    txtBowler: TText;
    txtPrice: TText;
    txtShoes: TText;
    txtLane: TText;
    txtGameCnt: TText;
    recListDesc: TRectangle;
    VertScrollBox: TVertScrollBox;
    Text1: TText;
    txtRealAmt: TText;
    txtDcAmt: TText;
    Top1: TTop;
    recListBG: TRectangle;
    recPriceBG: TRectangle;
    recGameCnt: TRectangle;
    recShoes: TRectangle;
    imgGeneralN: TImage;
    recGeneral: TRectangle;
    imgGeneralY: TImage;
    recLeage: TRectangle;
    imgLeagueN: TImage;
    imgLeagueY: TImage;
    Text6: TText;
    recLine: TRectangle;
    Image1: TImage;
    recPriceDc: TRectangle;
    recPriceTotal: TRectangle;
    recCancel: TRoundRect;
    Text2: TText;
    recDcList: TRectangle;
    Text17: TText;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Image3: TImage;
    Text3: TText;
    txtAmtShoes: TText;
    Rectangle10: TRectangle;
    Image6: TImage;
    Text4: TText;
    txtAmtGame: TText;
    Timer1: TTimer;
    recNotice: TRectangle;
    txtNotice1: TText;
    txtNotice2: TText;
    txtNotice3: TText;
    recDelete: TRectangle;
    txtDelete: TText;
    recTitle1: TRectangle;
    recTitle2: TRectangle;
    recTitle6: TRectangle;
    recTitle5: TRectangle;
    recTitle4: TRectangle;
    recTitle3: TRectangle;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure Rectangle1Click(Sender: TObject);

    procedure recOkClick(Sender: TObject);

    procedure FormDestroy(Sender: TObject);
    procedure HomeImageClick(Sender: TObject);
    procedure BottomRectangleClick(Sender: TObject);
    procedure rrPrevClick(Sender: TObject);
    procedure imgGeneralYClick(Sender: TObject);
    procedure imgLeagueYClick(Sender: TObject);
    procedure recCancelClick(Sender: TObject);
    procedure recDcListClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }
		FItemList: TList<TSaleGameItemStyle>;

		FLaneBowlerCnt: Integer; //���ο� �Ҵ�� ������
		FTotalPrice: Integer;

		FSec: Integer;
		FMouseDownX: Extended;
		FMouseDownY: Extended;

		procedure LeagueUse(AUse: Boolean);

	public
		{ Public declarations }
		ErrorMsg: string;

    procedure delBuyProduct(AIdx: Integer); //ksj 230831
		procedure DisplayInit;
		procedure Display;
		procedure ShowAmt;

		function chgBowlerNm(ASeq: Integer): Boolean;
		function chgSaleQty(AIdx, ACnt: Integer): Boolean;
		function chgLane(AIdx: Integer; AUse: String): Boolean;
    function chgShoes(AIdx: Integer; AUse: String): Boolean;

		//property Cnt: Integer read FCnt write FCnt;
  end;

var
  SaleGameBowler: TSaleGameBowler;

implementation

uses
	uGlobal, uConsts, uFunction, fx.Logging, uCommon, Form.Select.Box, Form.Full.Popup;

{$R *.fmx}

procedure TSaleGameBowler.FormCreate(Sender: TObject);
begin
  FTotalPrice := 0;
end;

procedure TSaleGameBowler.FormShow(Sender: TObject);
begin
	if Global.SaleModule.BuyProductList.Count > 0 then
		Display
	else
		DisplayInit;

	Timer1.Enabled := True;
end;

procedure TSaleGameBowler.FormDestroy(Sender: TObject);
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

procedure TSaleGameBowler.DisplayInit;
var
  Index, RowIndex, Loop: Integer;
  AItemStyle: TSaleGameItemStyle;
  sStr, sLaneNo: String;
  //rBowlerInfo: TBowlerInfo;
  rSaleData: TSaleData;
  nDiv, nMod: Integer;
  nLane1, nLane2: Integer;
	//rMemberInfo: TMemberInfo;
	sTime: string; //ksj 230814
begin

  if Global.SaleModule.GameInfo.LaneUse = '2' then
  begin
    nLane1 := Global.SaleModule.GameInfo.Lane1;
    nLane2 := Global.SaleModule.GameInfo.Lane2;

    sStr := IntToStr(nLane1) + '-' + IntToStr(nLane2);
  end
  else
    sStr := IntToStr(Global.SaleModule.LaneInfo.LaneNo);

	txtTitle.Text := sStr + '�� ���� ���� �����';
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

  //div	���� �������� ��	9 div 2 = 4
  //mod	���� �������� ������	9 mod 2 = 1
  FLaneBowlerCnt := 0;
  if Global.SaleModule.GameInfo.LaneUse = '2' then //2�� ���� ���
  begin
		nDiv := Global.SaleModule.GameInfo.BowlerCnt div 2;
    nMod := Global.SaleModule.GameInfo.BowlerCnt mod 2;
    FLaneBowlerCnt:= nDiv + nMod;
  end;

  try
    if FItemList = nil then
			FItemList := TList<TSaleGameItemStyle>.Create;

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

		//�̿��	1010100001	�Ϲ�	10,000��	������
		for Index := 0 to Global.SaleModule.GameInfo.BowlerCnt - 1 do
		begin
			AItemStyle := TSaleGameItemStyle.Create(nil);

			AItemStyle.Position.X := 0;
			AItemStyle.Position.Y := (RowIndex * AItemStyle.Height) + 18; // + (RowIndex * 30);
      //AItemStyle.Display(Global.SaleModule.BuyProductList[Index]);
      AItemStyle.Parent := VertScrollBox;

      rSaleData.BowlerSeq := Index + 1;

      sLaneNo := '';
      if FLaneBowlerCnt > 0 then
      begin  //���⸦ ���캸�� ����ϸ� �ɰŰ���
        if FLaneBowlerCnt > Index then
        begin
          sLaneNo := IntToStr(nLane1);
          rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Index];
          rSaleData.BowlerNm := rSaleData.BowlerId;
          rSaleData.LaneNo := nLane1;
        end
        else
        begin
          sLaneNo := IntToStr(nLane2);
          rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Index - FLaneBowlerCnt];
          rSaleData.BowlerNm := rSaleData.BowlerId;
          rSaleData.LaneNo := nLane2;
        end;
      end
      else
      begin
        sLaneNo := IntToStr(Global.SaleModule.LaneInfo.LaneNo);
        rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Index];
        rSaleData.BowlerNm := rSaleData.BowlerId;
        rSaleData.LaneNo := Global.SaleModule.LaneInfo.LaneNo;
      end;

			rSaleData.GameProduct := Global.SaleModule.GetGameProductFee('101', Global.Config.Store.GameDefaultProdCd);
			//ksj 230817 ������� ��ȭ�� ������ ���
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

end;

procedure TSaleGameBowler.Display;
var
  Index, RowIndex, Loop: Integer;
  AItemStyle: TSaleGameItemStyle;
  sStr, sLaneNo: String;
  rSaleData: TSaleData;
  nDiv, nMod: Integer;
	nLane1, nLane2: Integer;
  sTime: string;
begin

  if Global.SaleModule.GameInfo.LaneUse = '2' then
  begin
    nLane1 := Global.SaleModule.GameInfo.Lane1;
    nLane2 := Global.SaleModule.GameInfo.Lane2;

		sStr := IntToStr(nLane1) + '-' + IntToStr(nLane2);
	end
	else
	begin
		sStr := IntToStr(Global.SaleModule.LaneInfo.LaneNo);
	end;

	txtTitle.Text := sStr + '�� ���� ���� �����';
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

  try
    if FItemList = nil then
        FItemList := TList<TSaleGameItemStyle>.Create;

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
			AItemStyle := TSaleGameItemStyle.Create(nil);

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

procedure TSaleGameBowler.LeagueUse(AUse: Boolean);
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

  rGameInfo := Global.SaleModule.GameInfo;
  rGameInfo.LeagueUse := AUse;
  Global.SaleModule.GameInfo := rGameInfo;
end;

procedure TSaleGameBowler.BottomRectangleClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TSaleGameBowler.recCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSaleGameBowler.recDcListClick(Sender: TObject);
begin
  Global.SaleModule.PopUpLevel := plBuyDcList;
  ShowPopup;
end;

procedure TSaleGameBowler.recOkClick(Sender: TObject);
var
	I: Integer;
	rSaleData: TSaleData;
begin
	if Global.SaleModule.RealAmt = 0 then
	begin //ksj 230824 ����Ʈ,�̿������ ���� �� ���� �� ��ȭ�ᵵ �̻���̰ų� �����϶�
		Global.SaleModule.regPayList;
		for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
		begin
			rSaleData := Global.SaleModule.PayProductList[I];
			rSaleData.PaySelect := True;
			Global.SaleModule.PayProductList[I] := rSaleData;
                                             //�������� �������ҰŰ����� �ѹ����ϳ�??
			if rSaleData.DcProduct.ProdCd = 'P' then //����Ʈ������ ������
				Global.SaleModule.SaleCompleteProc
			else
			begin //�̿�������� �������� ���ϱ⶧���� ������ �Ȱ�����
				rSaleData.PayResult := True;
				Global.SaleModule.PayProductList[I] := rSaleData;
			end;
		end;
		Global.SaleModule.SaleCompleteAssign; //����
		ModalResult := mrOk;
	end
	else
	begin
		//ksj 230621
		Global.SaleModule.SaveLaneInfo := Global.SaleModule.LaneInfo;
		Global.SaleModule.SaveGameInfo := Global.SaleModule.GameInfo;

		Global.SaleModule.regPayList;
		ModalResult := mrOk;
	end;
end;

procedure TSaleGameBowler.HomeImageClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TSaleGameBowler.imgGeneralYClick(Sender: TObject);
begin
  LeagueUse(False);
end;

procedure TSaleGameBowler.imgLeagueYClick(Sender: TObject);
begin
  if Global.SaleModule.GameInfo.LaneUse = '1' then
    Exit;

  LeagueUse(True);
end;

procedure TSaleGameBowler.Rectangle1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSaleGameBowler.rrPrevClick(Sender: TObject);
var
  nIdx, nBowlerIdx, i: Integer;
  sIdx, sId: String;
  bMember: Boolean;
begin
	if SelectBox.UndoList.Count > 0 then
	begin
		nIdx := SelectBox.UndoList.Count - 1;
		sIdx := SelectBox.UndoList[nIdx]; //�ɹ��ڵ尡 ��

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
      txtOk.Text := '�����ϱ�(��ȸ��)';

    ShowAmt;
  end
  else
  begin
		//TouchSound(False, False);
    ModalResult := mrCancel;
  end;
end;

procedure TSaleGameBowler.ShowAmt;
begin
  //chy 2028-08-03 ��ġ����
  txtAmtShoes.Text := Format('+%s��', [FormatFloat('#,##0.##', Global.SaleModule.ShoesAmt)]);
  txtAmtGame.Text := Format('+%s��', [FormatFloat('#,##0.##', Global.SaleModule.GameAmt)]);
	txtRealAmt.Text := Format('%s��', [FormatFloat('#,##0.##', Global.SaleModule.RealAmt)]); //��ü

  if Global.SaleModule.DCAmt = 0 then
  begin
    recPriceBG.Height := 118;
    recPriceDc.Visible := False;
    recPriceTotal.Position.Y := 24;
  end
  else
  begin
    recPriceBG.Height := 182;
    recPriceDc.Visible := True;
    recPriceTotal.Position.Y := 88;

    txtDCAmt.Text := Format('%s��', [FormatFloat('#,##0.##', -1 * Global.SaleModule.DCAmt)]);
  end;
end;

procedure TSaleGameBowler.Timer1Timer(Sender: TObject);
begin
	txtOk.Visible := not txtOk.Visible;
end;

function TSaleGameBowler.chgBowlerNm(ASeq: Integer): Boolean;
var
	nIdx: Integer;
	nSaleQty: Integer; //ksj 230719 ������ ������� ���Ӽ���, �ݾ� ����
	rSaleData: TSaleData;
begin

	Global.SaleModule.MemberItemType := mitChange;
	Global.SaleModule.PopUpFullLevel := pflPhone;
	Log.D('TSaleGame', 'plPhone');

	if not ShowFullPopup then
	begin
		Global.SaleModule.PopUpFullLevel := pflNone; //Clear;
		Exit;
	end;

	nIdx := ASeq - 1;

	//ksj 230719 ������ ������� ���Ӽ���, �ݾ� ����
	nSaleQty := Global.SaleModule.BuyProductList[nIdx].SaleQty;

	//ksj 230714 ���� �����ߴ� ������ǰ ����
	if SelectBox.UndoList.Count > 0 then
		Global.SaleModule.UndoSaleData(nIdx);

	//ksj 230719 ������ ������� ���Ӽ��� ����
	if nSaleQty <> Global.SaleModule.BuyProductList[nIdx].SaleQty then
	begin
		rSaleData := Global.SaleModule.BuyProductList[nIdx];
		rSaleData.SaleQty := nSaleQty;
		rSaleData.SalePrice := rSaleData.GameProduct.ProdAmt * nSaleQty;
		Global.SaleModule.BuyProductList[nIdx] := rSaleData;
	end;

	Global.SaleModule.ChgSaleData(nIdx);
	FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);
	ShowAmt;
	//ksj 230901 UndoList BuyProductList�ε������� ȸ���ڵ�� ����
	SelectBox.UndoList.Add(Global.SaleModule.BuyProductList[nIdx].MemberInfo.Code);
	txtOk.Text := '�����ϱ�';
end;

function TSaleGameBowler.chgSaleQty(AIdx, ACnt: Integer): Boolean;
var
	nIdx: Integer;
	rSaleData: TSaleData; //ksj 230720 ����Ʈ, ���� ��� �Ŀ� ��ǰ���� �ٲ�
begin
	Result := False;

	nIdx := AIdx - 1;
	Global.SaleModule.chgSaleDataSaleQty(nIdx, ACnt);

	//ksj 230720 ����Ʈ, ���� ��� �Ŀ� ��ǰ���� �ٲ�
	if Global.SaleModule.BuyProductList[nIdx].MemberInfo.Code <> '' then
	begin
		rSaleData := Global.SaleModule.BuyProductList[nIdx];
		if (rSaleData.DcProduct.ProdCd = 'P') or (rSaleData.DcProduct.ProdDetailDiv = '501') then
		begin //ksj 230816 ȸ�������� �������� ������ ȸ������ �ٲ��� �ʵ��� ����
			if Global.SaleModule.Member.Code <> rSaleData.MemberInfo.Code then
			begin
				Global.SaleModule.Member := rSaleData.MemberInfo;
				Global.SaleModule.SelectProd := rSaleData.DcProduct;
			end;
			Global.SaleModule.ChgSaleData(nIdx);
		end;
	end;

	FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);
	ShowAmt;

	Result := True;
end;

function TSaleGameBowler.chgLane(AIdx: Integer; AUse: String): Boolean;
var
  nIdx: Integer;
	I, nLane, nCnt, nCnt1, nCnt2: Integer;
begin
	Result := False;

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
			Global.SBMessage.ShowMessage('12', '�˸�', '������ �̵��Ҽ� �����ϴ�.' + #13 + '�ּ� 1�� �̻��̿��� �մϴ�.');
			Exit;
		end;
    //ksj 230821 �����̵��� �ִ� 6�� ��밡��
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
				Global.SBMessage.ShowMessage('12', '�˸�', '������ �̵��Ҽ� �����ϴ�.' + #13 + '���δ� �ִ� 6�� ��밡�� �մϴ�.');
				Exit;
			end;
		end
		else
		begin
			if nCnt2 = 6 then
			begin
				Global.SBMessage.ShowMessage('12', '�˸�', '������ �̵��Ҽ� �����ϴ�.' + #13 + '���δ� �ִ� 6�� ��밡�� �մϴ�.');
				Exit;
			end;
		end;
  end;

	nIdx := AIdx - 1;
	Global.SaleModule.chgSaleDataLane(nIdx, AUse);
	Global.SaleModule.reCountBowlerId; //ksj 230906 �����̵� �� ��ü ����id �缳��
//  FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);
	for nIdx := 0 to Global.SaleModule.BuyProductList.Count - 1 do
    FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);

  Result := True;
end;

function TSaleGameBowler.chgShoes(AIdx: Integer; AUse: String): Boolean;
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

procedure TSaleGameBowler.delBuyProduct(AIdx: Integer);
var
	I, nIdx: Integer;
	sIdx: string;
	bIdx: Boolean;
begin
	if SelectBox.UndoList.Count > 0 then
	begin //ksj 230901
		nIdx := AIdx - 1;
		for I := 0 to SelectBox.UndoList.Count - 1 do
		begin //�ش� �ε����� ��(BuyProductList[��]) ���ϱ�
			sIdx := SelectBox.UndoList[I]; //�ɹ��ڵ�
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

	Global.SaleModule.reCountBowlerId; //ksj 230906 �����̵� �� ��ü ����id �缳��
	for nIdx := 0 to Global.SaleModule.BuyProductList.Count - 1 do
		FItemList[nIdx].Display(Global.SaleModule.BuyProductList[nIdx]);

	Display;
end;

end.
