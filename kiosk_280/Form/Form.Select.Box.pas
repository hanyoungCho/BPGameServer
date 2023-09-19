unit Form.Select.Box;

interface

uses
  Uni, JSON, IdGlobal, Winapi.Windows,

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  Generics.Collections, IdContext,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, CPort,
  Frame.Select.Box.Top.Map,Frame.Top,Frame.Bottom,
  frmmediaTest,
  FMX.Media,
  uStruct,
  Frame.Select.Box.Sale, Frame.Select.Box.Lane, FMX.ListBox, FMX.Colors;

const
  TIMER_3 = 3;
  TIMER_5 = 5;

type
  TSelectBox = class(TForm)
    ImgLayout: TLayout;
    Layout: TLayout;
    TopLayout: TLayout;
    BodyLayout: TLayout;
    Timer: TTimer;
    BGImage: TImage;
    Rectangle1: TRectangle;
    LayoutMenu: TLayout;
    TimerPrint: TTimer;
    Text6: TText;
    TimerDelay: TTimer;
    recCallTestBtn: TRectangle;
    recCallTest: TRectangle;
    Image3: TImage;
    Text3: TText;
    recMenuLane: TRectangle;
    txtMenuLane: TText;
    recMenuSale: TRectangle;
    txtMenuSale: TText;
    recGameType: TRectangle;
    txtLaneNm: TText;
    recGameTypeBottom: TRectangle;
    txtTime: TText;
    rrPrev: TRoundRect;
    txtPrev: TText;
    txtGamePrice: TText;
    txtTimePrice: TText;
    layLane: TLayout;
    recGameCnt: TRectangle;
    recGameTime: TRectangle;
    Top1: TTop;
    BottomLayout: TLayout;
    Image5: TImage;
    imgTimeGray: TImage;
    StyleBook1: TStyleBook;
    Bottom1: TBottom;
    imgMenuLane: TImage;
    Rectangle3: TRectangle;
    imgMenuSale: TImage;
    Image1: TImage;
    SelectBoxTopMap1: TSelectBoxTopMap;
    laySale: TLayout;
    Rectangle2: TRectangle;
    Text1: TText;
    imgTimeBlue: TImage;
    Rectangle4: TRectangle;
    txtNotice: TText;
    Image2: TImage;
    SelectBoxLane1: TSelectBoxLane;
    SelectBoxSale1: TSelectBoxSale;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure TimerTimer(Sender: TObject);
    procedure HomeImageClick(Sender: TObject);
    procedure BottomRectangleClick(Sender: TObject);
    procedure BackRectangleClick(Sender: TObject);
    procedure TimerPrintTimer(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure recCallTestBtnClick(Sender: TObject);
    procedure recMenuLaneClick(Sender: TObject);
    procedure txtMenuSaleClick(Sender: TObject);
    procedure txtPrevClick(Sender: TObject);
    procedure txtGamePriceClick(Sender: TObject);
    procedure txtTimePriceClick(Sender: TObject);

  private
    { Private declarations }
    FTimerInc: Integer;
    FIntroCnt: Integer;

    FShowInfo: Boolean;
    FWork: Boolean;
    FBackCnt: Integer; //���θ޴� ȣ�� ���� üũ��
    FCallCnt: Integer; // ���� �˸��� �׽�Ʈ��

    FIntroDelay: Boolean; //��������ũ Ű����ũ
		FIntroDelayCnt: Integer; //��������ũ Ű����ũ

		FUndoList: TStringList; //ksj 230808

		procedure Clear;
	public
		{ Public declarations }

		procedure SelectLane(ALaneInfo: TLaneInfo);
		procedure SelectSale;

		procedure ChangeMenu(AType: Integer);

		function NewMember: Boolean;

		property Work: Boolean read FWork write FWork;
		property BackCnt: Integer read FBackCnt write FBackCnt;
		property CallCnt: Integer read FCallCnt write FCallCnt;
		property IntroCnt: Integer read FIntroCnt write FIntroCnt;
		property TimerInc: Integer read FTimerInc write FTimerInc;

		property UndoList: TStringList read FUndoList write FUndoList;
  end;

var
  SelectBox: TSelectBox;

implementation

uses
  uGlobal, uCommon, uConsts, fx.Logging, Form.Intro, uFunction;

{$R *.fmx}

procedure TSelectBox.FormCreate(Sender: TObject);
begin
  FTimerInc := 0;
  IntroCnt := 0;
  Work := False;

  //chy debug���п�
  if Pos('test', Global.Config.Partners.apiURL) > 0 then
  begin
    text6.Visible := True;
    text6.text := Global.Config.Partners.apiURL;
  end
  else
  begin
    text6.Visible := False;
  end;

  FIntroDelay := False;
  FIntroDelayCnt := 0;
end;

procedure TSelectBox.FormDestroy(Sender: TObject);
begin
	try
    SelectBoxLane1.CloseFrame;
		SelectBoxSale1.CloseFrame;
    SelectBoxTopMap1.CloseFrame; //ksj 230816

    //TextList.Free;
  except
    on E: Exception do
    begin
      Log.E('TSelectBox.FormDestroy', E.Message);
    end;
  end;
end;

procedure TSelectBox.FormShow(Sender: TObject);
var
	AError: Boolean;
begin
	FShowInfo := False;
	FBackCnt := 0;
	FCallCnt := 0;

	Global.SaleModule.SaleDataClear;  // FormShow
  Global.Lane.SampleThread.Resume;

  Timer.Enabled := True;

  SelectBoxLane1.DisplayInit;
  SelectBoxTopMap1.DisplayFloor;
  recGameType.Visible := False;

  Bottom1.Display(False);

	AError := True;
end;

{
procedure TSelectBox.Animate(Index: Integer);
begin
  SelectBoxLane1.Animate(SelectBoxLane1.ItemList[Index]);
end;
}

procedure TSelectBox.recMenuLaneClick(Sender: TObject);
begin
  TouchSound;
  ChangeMenu(0);
end;

procedure TSelectBox.txtMenuSaleClick(Sender: TObject);
begin
  TouchSound;
  ChangeMenu(1);
end;

procedure TSelectBox.txtPrevClick(Sender: TObject);
begin
  Global.LocalApi.LaneHold(Global.SaleModule.LaneInfo.LaneNo, 'N');
  Work := False;
  Global.SaleModule.SaleDataClear;
  recGameType.Visible := False;
end;

procedure TSelectBox.BackRectangleClick(Sender: TObject);
begin
  IntroCnt := 0;
  BackCnt := BackCnt + 1;

  if BackCnt = 5 then
  begin

    BackCnt := 0;
    Global.SaleModule.PopUpLevel := plAuthentication;

    if not ShowPopup then
    begin
      Exit;
    end;

    Close;
  end;
end;

procedure TSelectBox.BottomRectangleClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TSelectBox.ChangeMenu(AType: Integer);
begin
  try

    if AType = 1 then
    begin
      Work := True;

      //chy ȸ��, ��ǰ ���� Ȯ��
      if not Global.SaleModule.MasterReception(True, True, False) then //ȸ��, ȸ�����ǰ, ��ȭ
      begin
				Global.SBMessage.ShowMessage('12', '�˸�', MSG_UPDATE_INFO_FAIL);
        Work := False;
        Exit;
      end;

      layLane.Visible := False;
      laySale.Visible := True;

      SelectBoxSale1.Display;
      SelectBoxSale1.iSec := 0;
      SelectBoxSale1.timer.Enabled := True;

      txtMenuLane.TextSettings.FontColor := $FF4F515E;
      txtMenuSale.TextSettings.FontColor := $FF3D55F5;
      imgMenuLane.Visible := False;
      imgMenuSale.Visible := True;

      txtNotice.Text := '�����Ͻ� ��ǰ�� �������ּ���';
    end
    else
    begin
			Work := False;

			layLane.Visible := True;
			laySale.Visible := False;

			SelectBoxSale1.timer.Enabled := False;
			SelectBoxLane1.DisplayStatus;
			SelectBoxTopMap1.DisplayFloor;

			txtMenuLane.TextSettings.FontColor := $FF3D55F5;
			txtMenuSale.TextSettings.FontColor := $FF4F515E;
			imgMenuLane.Visible := True;
			imgMenuSale.Visible := False;

			txtNotice.Text := '�̿��Ͻ� ������ �������ּ���';
    end;

  except
    on E: Exception do
    begin
			Log.E('TSelectBox.ChangeMenu', E.Message);
    end;
  end;
end;

procedure TSelectBox.Clear;
begin
  try
    Global.SaleModule.SaleDataClear;  // TSelectBox.Clear

    //ActiveFloor := 1;
    {
    if Global.Lane.FloorList.Count <> 0 then
      ActiveFloor := Global.Lane.FloorList[0];
     }

    SelectBoxLane1.DisplayStatus;
  except
    on E: Exception do
    begin
      Log.E('TSelectBox.Clear', E.Message);
    end;
  end;
end;

procedure TSelectBox.HomeImageClick(Sender: TObject);
begin
  TouchSound;
end;

function TSelectBox.NewMember: Boolean;
var
  dtTM: tdatetime;
  dDiffDate: Double;
  nAge: Integer;
  bStudent: Boolean;
begin
	try
		if Global.SaleModule.PayProductList.Count > 0 then
		begin //ksj 230823 ����ȭ�鿡�� ȸ������ ��Ȱ��ȭ
			Exit;
		end;

    Result := False;

    Work := True;

    Global.SaleModule.memberItemType := mitNew;
    Global.SaleModule.PopUpLevel := plNewMemberPolicy;

    if not ShowPopup then
      Exit;

    //ȸ������ �Է�
    if not ShowNewMemberInfoTT then
      Exit;

    // ȸ���űԵ�Ͻ� �����ϸ� ��������� member_no(member.code) ȸ����ȣ �޾ƿ�. SaleModule.newmember �� ����
    if not Global.ErpApi.AddNewMember then
    begin
      Log.E('AddMember', 'False');
      Global.SBMessage.ShowMessage('11', '�˸�', MSG_NEWMEMBER_FAIL);
      Exit;
    end;

    bStudent := False;
    {
    dtTM := DateStrToDateTime(Global.SaleModule.NewMember.BirthDay + '000000');
    dDiffDate := now - dtTM;
    nAge := round(dDiffDate) div 365;
    if Global.Config.Store.Age > nAge then
      bStudent := True;
    }
    if Global.SaleModule.NewMember.MemberDiv = '02' then
      bStudent := True;

    if bStudent = True then
      Global.SaleModule.NewMemberItemType := nmitStudent
    else
      Global.SaleModule.NewMemberItemType := nmitMember;

		if Global.SaleModule.BuyProductList.Count > 0 then
			Global.SBMessage.ShowMessage('11', '�˸�', 'ȸ�������� �Ϸ�Ǿ����ϴ�.')
		else //ksj 230823 �ֹ�ȭ�鿡�� ȸ�����Խ� ȸ���Ǳ��� �̵�X
		begin                          //�ű԰��� �޼��� �л��ΰ��� 22�� ���ٶ������
			Global.SBMessage.ShowMessage('21', '', '�ű԰���', True, 30);
			if Global.SaleModule.NewMemberItemType = nmitMember then
			begin
				ChangeMenu(1);
			end
			else
			begin
				ChangeMenu(0);
				Work := False;
			end;
		end;

    Result := True;
  finally

  end;

end;

procedure TSelectBox.SelectLane(ALaneInfo: TLaneInfo);
begin
  // ������ - ������: ����Ұ�, ���Ӽ�����: ���Ӽ������� ����. �ð���: ���Ӽ�����, �ð��� ����
  try
    FBackCnt := 0;
    FCallCnt := 0;

    //chy ��������ũ Ű����ũ
    if FIntroDelay = True then
    begin
      inc(FIntroDelayCnt);
      if FIntroDelayCnt > 1 then
      begin
        FIntroDelay := False;
        FIntroDelayCnt := 0;
      end;
      Exit;
    end;


    Global.SaleModule.SaleDataClear; // SelectTeeBox  Begin
    Global.SaleModule.MiniMapCursor := True;

    Log.D('SelectLane', 'no - ' + IntToStr(ALaneInfo.LaneNo) + ' / ' + ALaneInfo.LaneNm);

    Work := True;
    IntroCnt := 0;

    //chy ȸ��, ��ǰ ���� Ȯ��
    if not Global.SaleModule.MasterReception(True, False, True) then //ȸ��, ȸ�����ǰ, ��ȭ
    begin
      Global.SBMessage.ShowMessage('12', '�˸�', MSG_UPDATE_INFO_FAIL);
      Work := False;
      Exit;
    end;

    // Ÿ�� Ȧ��
    Global.SaleModule.LaneInfo := ALaneInfo;

    if not Global.LocalApi.LaneHold(Global.SaleModule.LaneInfo.LaneNo, 'Y') then
    begin
      Global.SBMessage.ShowMessage('12', '�˸�', MSG_HOLD_LANE_ERROR);
      Work := False;
      Exit;
    end;

    recGameType.Visible := True;

    //chy 2023-08-02
    txtLaneNm.Text := '���� ����: ' + ALaneInfo.LaneNm + '��';
		if ALaneInfo.GameDiv = '1' then
		begin
			recGameTime.Stroke.Color := $FFA6A7A8;
			txtTimePrice.TextSettings.FontColor := $FFA6A7A8;

			imgTimeBlue.Visible := False;
			imgTimeGray.Visible := True;
		end
		else //�������� ���δ����ٰ� �� ���� �������� ��Ȱ��ȭ�Ȱ� �״�� �������־���
		begin
			recGameTime.Stroke.Color := $FF3D55F5;
			txtTimePrice.TextSettings.FontColor := $FF3D55F5;

			imgTimeBlue.Visible := True;
			imgTimeGray.Visible := False;
		end

  except
    on E: Exception do
      Log.E('SelectLane', E.Message);
  end;
end;

procedure TSelectBox.txtGamePriceClick(Sender: TObject); //���ӿ���� ����
label ReGameBowler;
var
  AModalResult: TModalResult;
	AMsg: String;
	I: Integer;
begin
	try
    try
      Global.SaleModule.GameItemType := gitGameCnt;
      Global.SaleModule.PopUpLevel := plGameSetting;
      Log.D('txtGamePriceClick', 'MemberItemType');

      if not ShowPopup then
      begin
        Global.SaleModule.PopUpLevel := plNone; //Clear;
        Exit;
      end;

      //�Ϲ� ����� �ݾ� ��û
      if Global.SaleModule.GetGameProductAmt('101', Global.Config.Store.GameDefaultProdCd) = False then
      begin
        Global.SBMessage.ShowMessage('11', '�˸�', '����� ������ Ȯ�����ּ���');
				Exit;
			end;

			FUndoList := TStringList.Create;

			ReGameBowler :

			if not ShowSaleGameBowler then
				Exit;

			if Global.SaleModule.RealAmt > 0 then
			begin //ksj 230824 �����ݾ��� ���������� ����ȭ�� �Ѿ��
				AModalResult := ShowSaleProduct;
				if AModalResult = mrRetry then
				begin               //�������� ������ �ִ°��/ ������ �ֹ����� ���ٸ�
					//ksj 230621        ����� �ֹ����� ������ �Ѿ�� ���� �����صΰ� ����ȭ�鴭���� �ٽ� �ֹ�ȭ���϶� ���
					Global.SaleModule.LaneInfo := Global.SaleModule.SaveLaneInfo;
					Global.SaleModule.GameInfo := Global.SaleModule.SaveGameInfo;  //2������ ����Ϸ��ٰ� �Ѱ����λ����Ѱ��
																																				 //������ Ȧ��Ǯ�� ����� ���γѹ�
					Log.D('txtGamePriceClick', 'ReGameBowler');
					goto ReGameBowler;
				end;
			end;

		finally
      Log.D('txtGamePriceClick', 'End');

			if Global.SaleModule.GameInfo.LaneUse = '2' then
			begin
				Global.LocalApi.LaneHold(Global.SaleModule.GameInfo.Lane1, 'N');
				Global.LocalApi.LaneHold(Global.SaleModule.GameInfo.Lane2, 'N');
			end
			else
			begin
				Global.LocalApi.LaneHold(Global.SaleModule.LaneInfo.LaneNo, 'N');

				if Global.SaleModule.SaveGameInfo.LaneUse = '2' then
				begin //ksj 230621
					Global.LocalApi.LaneHold(Global.SaleModule.SaveGameInfo.Lane1, 'N');
					Global.LocalApi.LaneHold(Global.SaleModule.SaveGameInfo.Lane2, 'N');
				end;
			end;

			if FUndoList <> nil then
				FreeAndNil(FUndoList);

			Global.SaleModule.SaleDataClear; // SelectTeeBox  End
			recGameType.Visible := False;

			ChangeMenu(0);
			Work := False;
		end;

  except
    on E: Exception do
      Log.E('txtGamePriceClick', E.Message);
  end;
end;

procedure TSelectBox.txtTimePriceClick(Sender: TObject); //�ð������ ����
label ReGameBowler;
var
	AModalResult: TModalResult;
	I: Integer;
begin
  //chy 2023-08-02
  if imgTimeGray.Visible = True then
    Exit;

  try

    try
      Global.SaleModule.GameItemType := gitGameTime;
      Global.SaleModule.PopUpLevel := plGameSetting;
      Log.D('SelectTeeBox', 'MemberItemType');

      if not ShowPopup then
      begin
        Global.SaleModule.PopUpLevel := plNone; //Clear;
        Exit;
      end;

       //�Ϲ� ����� �ݾ� ��û
			if Global.SaleModule.GetGameProductAmt('102', Global.Config.Store.TimeDefaultProdCd) = False then
      begin
        Global.SBMessage.ShowMessage('11', '�˸�', '����� ������ Ȯ�����ּ���');
        Exit;
			end;

			FUndoList := TStringList.Create;

      ReGameBowler :

      if not ShowSaleTimeBowler then
        Exit;

      if Global.SaleModule.RealAmt > 0 then
			begin //ksj 230824 �����ݾ��� ���������� ����ȭ�� �Ѿ��
				AModalResult := ShowSaleProductTime;
				if AModalResult = mrRetry then
				begin //�ð������� ������ ���ܼ� ���̺����� �ʿ�/�����ϴ´��� �޶����� ���̺����� ����ϴ°� �޶���������
					Global.SaleModule.LaneInfo := Global.SaleModule.SaveLaneInfo;
					Global.SaleModule.GameInfo := Global.SaleModule.SaveGameInfo;

					Log.D('SelectSale', 'ReGameBowler');
					goto ReGameBowler;
				end;
			end;

    finally
      Log.D('SelectTeeBox', 'End');

			if Global.SaleModule.GameInfo.LaneUse = '2' then
			begin
				Global.LocalApi.LaneHold(Global.SaleModule.GameInfo.Lane1, 'N');
				Global.LocalApi.LaneHold(Global.SaleModule.GameInfo.Lane2, 'N');
			end
			else
			begin
				Global.LocalApi.LaneHold(Global.SaleModule.LaneInfo.LaneNo, 'N');

				if Global.SaleModule.SaveGameInfo.LaneUse = '2' then
				begin //ksj 230831
					Global.LocalApi.LaneHold(Global.SaleModule.SaveGameInfo.Lane1, 'N');
					Global.LocalApi.LaneHold(Global.SaleModule.SaveGameInfo.Lane2, 'N');
				end;
			end;

			if FUndoList <> nil then
				FreeAndNil(FUndoList); //ksj 230825 <> nil �����߰�, .Free���� ����

			Global.SaleModule.SaleDataClear; // SelectTeeBox  End
      recGameType.Visible := False;
      ChangeMenu(0);
      Work := False;
    end;

  except
    on E: Exception do
      Log.E('txtTimePriceClick', E.Message);
  end;
end;


procedure TSelectBox.SelectSale;
label RePhone;
var
  AModalResult: TModalResult;
  AMsg, sMsgPostion: String;

begin

  try
    SelectBoxSale1.Timer.Enabled := False;

    FBackCnt := 0;
    FCallCnt := 0;
    try
      Work := True;
      IntroCnt := 0;

      RePhone :

      Global.SaleModule.MemberItemType := mitBuy;
      Global.SaleModule.PopUpFullLevel := pflPhone;
      Log.D('SelectSale', 'pflPhone');

      if not ShowFullPopup then
      begin
        Global.SaleModule.PopUpFullLevel := pflNone; //Clear;
        SelectBoxSale1.Timer.Enabled := True;
        Exit;
      end;

      AModalResult := ShowSaleMember;
      if AModalResult = mrRetry then
      begin
        Log.D('SelectSale', 'RePhone');
        goto RePhone;
      end
      else if AModalResult = mrOk then
      begin
        Global.SaleModule.SaleCompleteMemberProc;

        Clear;
      end;

    finally
      Log.D('SelectTeeBox', 'End');

      //Global.Lane.GetGMTeeBoxList;
      FTimerInc := TIMER_5;

      Global.SaleModule.SaleDataClear; // SelectTeeBox  End
      Work := False;
      TimerPrint.Enabled := True;
    end;

  except
    on E: Exception do
			Log.E(ClassName, sMsgPostion + ' / ' + E.Message);
  end;

end;

{
procedure TSelectBox.ShowErrorMsg(AMsg: string);
begin
	Global.SBMessage.ShowMessage(AMsg);
end;
}

procedure TSelectBox.TimerDelayTimer(Sender: TObject);
begin
  if FIntroDelay = True then
  begin
    FIntroDelay := False;
    FIntroDelayCnt := 0;
  end;
  TimerDelay.Enabled := False;
end;

procedure TSelectBox.TimerPrintTimer(Sender: TObject);
begin
  try
    TimerPrint.Enabled := False;
    Global.SaleModule.Print.PrintStatus := '';
    Global.SaleModule.Print.SewooStatus;
  except
    on E: Exception do
      Log.E('TimerPrintTimer', E.Message);
  end;
end;

procedure TSelectBox.TimerTimer(Sender: TObject);
var
  Index: Integer;
begin

  // �ý��� ����
  if Global.Config.SystemShutdown = True then
  begin
    if (FormatDateTime('hh:nn', now) = Global.Config.Store.SaleEndTime) then //"22:00"
    begin
      Log.D('SystemShutdown', '');
      MyExitWindows(EWX_SHUTDOWN);
      Exit;
    end;
  end;

  // ���� 5�ÿ� ���α׷� ������
  if (FormatDateTime('hhnnss', now) > '050000') and (FormatDateTime('hhnnss', now) < '050010') then
  begin
    MyExitWindows(EWX_REBOOT);
    Exit;
  end;

  if Global.SBMessage.PrintError then
    Exit;

  //���� ���õ� �޴�
  if layLane.Visible = True then
  begin
    txtMenuLane.Visible := not txtMenuLane.Visible;

    if txtMenuSale.Visible = False then
      txtMenuSale.Visible := True;
  end
  else //laySale.Visible := True;
  begin
    txtMenuSale.Visible := not txtMenuSale.Visible;

    if txtMenuLane.Visible = False then
      txtMenuLane.Visible := True;
  end;

  if not Work then
  begin
    if (FTimerInc = 0) and (not FShowInfo) then
    begin
      FShowInfo := True;
      ChangeMenu(0);
    end;

    if FTimerInc = TIMER_5 then
    begin
      FTimerInc := 0;
      ChangeMenu(0);
    end
    else
      Inc(FTimerInc);

		if (FIntroCnt = 40) and True then
		begin
      FIntroCnt := 0;
      Clear;

      //ChangBottomImg;
      Bottom1.ChangeImg;

      if ShowIntro(Bottom1.Image.Bitmap) then
      begin
        FIntroDelay := True;
        TimerDelay.Enabled := True;
      end;
    end;

    if Intro = nil then
      Inc(FIntroCnt);
  end;
end;

procedure TSelectBox.recCallTestBtnClick(Sender: TObject);
begin
  IntroCnt := 0;
  CallCnt := CallCnt + 1;

  if CallCnt = 5 then
  begin

    CallCnt := 0;
    if recCallTest.Visible = True then
      recCallTest.Visible := False
    else
      recCallTest.Visible := True;
  end;
end;

end.
