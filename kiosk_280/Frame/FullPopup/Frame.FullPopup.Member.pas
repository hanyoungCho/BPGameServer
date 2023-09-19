unit Frame.FullPopup.Member;

interface

uses
  Generics.Collections,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts,
  {common}
  uStruct,
  {frame}
  Frame.FullPopup.Member.Item;

type
  TFullPopupMember = class(TFrame)
    ImgLayout: TLayout;
    BGRectangle: TRectangle;
    Layout1: TLayout;
    recMemberInfo: TRectangle;
    txtMemberDate: TText;
    txtMemberNm: TText;
    recMemberType: TRectangle;
    txtMemberType: TText;
    txtMemberPoint: TText;
    txtVisitCnt: TText;
    Image1: TImage;
    Image3: TImage;
    recLane: TRectangle;
    recOption1: TRectangle;
    RoundRect1: TRoundRect;
    recOption2: TRectangle;
    RoundRect2: TRoundRect;
    txtOption2: TText;
    recOption3: TRectangle;
    RoundRect3: TRoundRect;
    txtOption3: TText;
    recBtn: TRectangle;
    recPoint: TRectangle;
    txtPoint: TText;
    txtOk: TText;
    Image2: TImage;
    txtTitle: TText;
    Text7: TText;
    Layout: TLayout;
    VertScrollBox: TVertScrollBox;
    recClose: TRectangle;
    recOk: TRectangle;
    recOption: TRectangle;
    recNonOption: TRectangle;
    Text1: TText;
    recMemberDate: TRectangle;
    recVisitCnt: TRectangle;
    recLaneBottom: TRectangle;
    Image6: TImage;
    Rectangle1: TRectangle;
    txtOption1: TText;
    procedure recCloseClick(Sender: TObject);
    procedure recOkClick(Sender: TObject);
    procedure recPointClick(Sender: TObject);
  private
    { Private declarations }
    //FProductList: TList<TProductInfo>;
    //FActivePage: Integer;
    FSale: Boolean; //������ ��ǰ����
    FSelect: Boolean; //������ǰ ���ÿ���
    FSaleProductInfo: TMemberProductInfo; //������ ��ǰ
    FItemList: TList<TFullPopupMemberItem>;
  public
    { Public declarations }
    procedure Display;
    procedure CloseFrame;

    procedure SelectProductView;
    //property ProductList: TList<TProductInfo> read FProductList write FProductList;
    //property ActivePage: Integer read FActivePage write FActivePage;
  end;

implementation

uses
  uGlobal, uFunction, uConsts, uCommon, Form.Full.Popup;

{$R *.fmx}

procedure TFullPopupMember.CloseFrame;
var
  Index: Integer;
begin
  if FItemList <> nil then
  begin
    for Index := FItemList.Count - 1 downto 0 do
      RemoveObject(FItemList[Index]);

    FItemList.Free;
  end;
end;

procedure TFullPopupMember.Display;
var
  Index, Loop, RowIndex, ColIndex: Integer;
  AProductInfo: TMemberProductInfo;
	AItem: TFullPopupMemberItem;
	sMemberNm: string;
begin
  try
    FSale := False;
    FSelect := False;
    RowIndex := 0;
    ColIndex := 0;

    if FItemList = nil then
      FItemList := TList<TFullPopupMemberItem>.Create;

    if FItemList.Count <> 0 then
    begin
      for Index := FItemList.Count - 1 downto 0 do
        FItemList.Delete(Index);

      FItemList.Clear;
    end;

		//ksj 230829 ȸ���� 5���� ������ �ڸ�����
		sMemberNm := Global.SaleModule.Member.Name;
		if Length(sMemberNm) > 5 then
			sMemberNm := Copy(sMemberNm, 1, 5);

    txtMemberNm.Text := sMemberNm + ' ȸ����';

    txtMemberPoint.Text := Format('%sP', [FormatFloat('#,##0.##', Global.SaleModule.Member.SavePoint)]);
    if Global.SaleModule.Member.SavePoint > 0 then
    begin
      recPoint.Fill.Color := $FF3D55F5;
      txtPoint.TextSettings.FontColor := $FFFFFFFF;
			txtPoint.Text := Format('%sP ���', [FormatFloat('#,##0.##', Global.SaleModule.Member.SavePoint)]);

			if Global.SaleModule.GameInfo.LaneUse = '2' then
			begin //ksj 230824
				if Global.SaleModule.TimeLane1DcType = 'T' then
				begin
					if odd(Global.SaleModule.BuyProductList[Global.SaleModule.TimeBowlerSeq - 1].LaneNo) then
					begin
						recPoint.Fill.Color := $FFD9D9D9;
						txtPoint.TextSettings.FontColor := $FF909092;
						txtPoint.Text := '����Ʈ ���Ұ�';
					end;
				end;
				if Global.SaleModule.TimeLane2DcType = 'T' then
				begin
					if not odd(Global.SaleModule.BuyProductList[Global.SaleModule.TimeBowlerSeq - 1].LaneNo) then
					begin
            recPoint.Fill.Color := $FFD9D9D9;
						txtPoint.TextSettings.FontColor := $FF909092;
						txtPoint.Text := '����Ʈ ���Ұ�';
					end;
				end;
			end
			else
			begin
				if Global.SaleModule.TimeLane1DcType = 'T' then
				begin //ksj 230726 �ð������� ������ ����Ʈ�� �Ǵ� �̿�Ǹ� ����
					recPoint.Fill.Color := $FFD9D9D9;
					txtPoint.TextSettings.FontColor := $FF909092;
					txtPoint.Text := '����Ʈ ���Ұ�';
				end;
			end;
    end;

    recMemberDate.Visible := False;
    recVisitCnt.Visible := False;
    recOption.Visible := False;
    recNonOption.Visible := False;

    for Index := 0 to Global.SaleModule.MemberProdList.Count - 1 do
    begin
      AProductInfo := Global.SaleModule.MemberProdList[Index];

      if AProductInfo.GameDiv = '3' then  //������
      begin
        if FSale = True then //�������� �������ΰ�� ù��° ��ǰ�� ����
          Continue;

        FSaleProductInfo := AProductInfo;
        //  01: �Ϲ�, 02:ȸ��, 03:�л�, 04: Ŭ��
        txtMemberType.Text := FeeDivStr[StrToInt(AProductInfo.DiscountFeeDiv)];

        recMemberDate.Visible := True;
        txtMemberDate.Text := '�Ⱓ: ' + AProductInfo.StartDate + '~' + AProductInfo.EndDate;

        if (Trim(AProductInfo.ProdBenefits) <> EmptyStr) or (AProductInfo.ShoesFreeYn = 'Y') or (AProductInfo.SavePointRate > 0) then
        begin
          recOption.Visible := True;

          if Trim(AProductInfo.ProdBenefits) <> EmptyStr then
						txtOption3.Text := AProductInfo.ProdBenefits; //ksj 230825 ���ù��� �ϴ����� ����

					if AProductInfo.ShoesFreeYn = 'Y' then
          begin
//						if txtOption1.Text = EmptyStr then
                txtOption1.Text := '��ȭ�� ����'
//						else
//							txtOption2.Text := '��ȭ�� ����';
					end;

					if AProductInfo.SavePointRate > 0 then
					begin
						if txtOption1.Text = EmptyStr then
							txtOption1.Text := IntToStr(AProductInfo.SavePointRate) + '% ����'
						else if txtOption2.Text = EmptyStr then
							txtOption2.Text := IntToStr(AProductInfo.SavePointRate) + '% ����';
//						else
//							txtOption3.Text := IntToStr(AProductInfo.SavePointRate) + '% ����';
					end;
				end;

				//ksj 230817 ��ǰ������ 1���� 2���� ���
				if txtOption2.Text = EmptyStr then
					RoundRect2.Visible := False;
				if txtOption3.Text = EmptyStr then
					RoundRect3.Visible := False;

        FSale := True;
        Continue;
      end;

      if ColIndex = 2 then
      begin
        ColIndex := 0;
        Inc(RowIndex);
      end;

      AItem := TFullPopupMemberItem.Create(nil);
      AItem.Position.X := (ColIndex * AItem.Width) + (ColIndex * 40);
      AItem.Position.Y := (RowIndex * AItem.Height) + (RowIndex * 60);
      AItem.DisPlayInfo(AProductInfo);
      AItem.Parent := VertScrollBox;

      FItemList.Add(AItem);
      Inc(ColIndex);
    end;

    if FSale = False then
    begin
      txtMemberType.Text := FeeDivStr[1];
			recNonOption.Visible := True;
    end
		else if Global.SaleModule.GameItemType = gitGameTime then
		begin   //ksj 230712 �������� ���ǻ��
			recMemberDate.Visible := False;
			recVisitCnt.Visible := False;
			recOption.Visible := False;

			recNonOption.Visible := True;
			recNonOption.Size.Width := 400;
			recNonOption.Position.X := 240;
			Text1.TextSettings.Horzalign := TTextAlign.Center;
			Text1.Text := '������ ������ �� �����ϴ�'; //���� ������ �����ϴ�

		end;

  finally

  end;

end;

procedure TFullPopupMember.recOkClick(Sender: TObject);
var
	rSaleProduct: TMemberProductInfo; //ksj 230717
	I: Integer; //ksj 230727
	nSalePrice: Currency;
begin
	if FSelect = False then //������ǰ �̼���
	begin
		if FSale = True then //������ ������
			Global.SaleModule.SelectProd := FSaleProductInfo
		else //ksj 230717 ���� ���� ȸ�� ������ǰ �̼���
			Global.SaleModule.SelectProd := rSaleProduct;
	end
	else if Global.SaleModule.GameItemType = gitGameTime then
	begin //ksj 230726
		if Global.SaleModule.GameInfo.LaneUse = '2' then
		begin  //ksj 230824
			if odd(Global.SaleModule.BuyProductList[Global.SaleModule.TimeBowlerSeq - 1].LaneNo) then
			begin
				if Global.SaleModule.TimeLane1DcType = '' then
					Global.SaleModule.TimeLane1DcType := 'T';
			end
			else
			begin
				if Global.SaleModule.TimeLane2DcType = '' then
					Global.SaleModule.TimeLane2DcType := 'T';
			end;
		end
		else
		begin
			if Global.SaleModule.TimeLane1DcType = '' then
				Global.SaleModule.TimeLane1DcType := 'T';
		end;
	end;
	FullPopup.CloseFormStrMrok('');
end;

procedure TFullPopupMember.recPointClick(Sender: TObject);
var
	rProductInfo: TMemberProductInfo;
	I: Integer; //ksj 230727
	nSalePrice: Currency;
begin
	if Global.SaleModule.GameItemType = gitGameTime then
	begin
		if Global.SaleModule.GameInfo.LaneUse = '2' then
		begin  //ksj 230824
			if odd(Global.SaleModule.BuyProductList[Global.SaleModule.TimeBowlerSeq - 1].LaneNo) then
			begin
				if (Global.SaleModule.Member.SavePoint = 0) or (Global.SaleModule.TimeLane1DcType = 'T') then
					Exit
				else if Global.SaleModule.GameItemType = gitGameTime then
				begin
					if Global.SaleModule.TimeLane1DcType = '' then
						Global.SaleModule.TimeLane1DcType := 'P';
				end;
			end
			else
			begin
				if (Global.SaleModule.Member.SavePoint = 0) or (Global.SaleModule.TimeLane2DcType = 'T') then
					Exit
				else if Global.SaleModule.GameItemType = gitGameTime then
				begin
					if Global.SaleModule.TimeLane2DcType = '' then
						Global.SaleModule.TimeLane2DcType := 'P';
				end;
			end;
		end
		else
		begin
			if (Global.SaleModule.Member.SavePoint = 0) or (Global.SaleModule.TimeLane1DcType = 'T') then
				Exit
			else if Global.SaleModule.GameItemType = gitGameTime then
			begin //ksj 230726
				if Global.SaleModule.TimeLane1DcType = '' then
					Global.SaleModule.TimeLane1DcType := 'P';
			end;
		end;
	end;

  rProductInfo.ProdCd := 'P';
	Global.SaleModule.SelectProd := rProductInfo;

  FullPopup.CloseFormStrMrok('');
end;

procedure TFullPopupMember.recCloseClick(Sender: TObject);
begin
  FullPopup.CloseFormStrMrCancel;
end;

procedure TFullPopupMember.SelectProductView;
var
  Index: Integer;
begin
  FSelect := True;
  for Index := 0 to FItemList.count - 1 do
	begin //ksj 230821 ��ǰ����ǥ�� ��ǰ�ڵ�->ȸ���Ǳ��ż������� ��
		if FItemList[Index].Product.MembershipSeq = Global.SaleModule.SelectProd.MembershipSeq then
			FItemList[Index].SelectDisPlay(True)
		else
			FItemList[Index].SelectDisPlay(False);
	end;
end;

end.
