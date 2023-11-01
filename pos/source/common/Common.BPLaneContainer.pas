unit Common.BPLaneContainer;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes, Vcl.Forms, Vcl.Graphics,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls, Data.DB, Vcl.Menus,
  { Custom Container }
  ccBoxes,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { Absolute Database }
  ABSMain,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxImageComboBox, cxProgressBar, cxLabel, cxCurrencyEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid;

const
  CO_CONTAINER_GRID_SALE_HEIGHT: Shortint = 114; //96;

  CO_POPUP_GAME_ASSIGN    = 1;
  CO_POPUP_SALE_VIEW      = 2;
  CO_POPUP_SCORE_EDIT     = 3;
  CO_POPUP_LANE_HOLD      = 4;
  CO_POPUP_GAME_CANCEL    = 5;
  CO_POPUP_LEAGUE_MODE    = 6;
  CO_POPUP_GAME_NEXT      = 7;
  CO_POPUP_BOWLER_PAUSE   = 8;
  CO_POPUP_PIN_SETTER_ON  = 9;
  CO_POPUP_PIN_SETTER_OFF = 10;
  CO_POPUP_MONITOR_ON     = 11;
  CO_POPUP_MONITOR_OFF    = 12;
  CO_POPUP_PIN_SETTING_1  = 13;
  CO_POPUP_PIN_SETTING_2  = 14;
  CO_POPUP_LANE_INIT      = 15;
  CO_POPUP_LANE_CHECK     = 16;

type
  TLaneSelectCallbackProc = reference to procedure(Sender: TObject);
  TLaneMsgCallbackProc = reference to procedure(Sender: TObject; const AMsg: string);

  TBPLaneContainer = class(TBox)
    GameDataSource: TDataSource;
    TitlePanel: TPanel;
    RallyModeImage: TImage;
    ShiftMethodLabel: TLabel;
    SpecialModeLabel: TLabel;
    LeagueModeLabel: TLabel;
    FrameNoLabel: TLabel;
    GameGrid: TcxGrid;
    GameLevel: TcxGridLevel;
    GameView: TcxGridDBTableView;
    GameViewdirection: TcxGridDBColumn;
    GameViewprogress: TcxGridDBColumn;
    GameViewgame_fin: TcxGridDBColumn;
    GameViewbowler_nm: TcxGridDBColumn;
    GameViewprod_nm: TcxGridDBColumn;
    GameViewbowler_id: TcxGridDBColumn;
    GameInfoPanel: TPanel;
    PaymentInfoPanel: TPanel;
    LaneNoPanel: TPanel;
    GameViewgame_cnt: TcxGridDBColumn;
    GameDataSet: TABSQuery;
    StatusPanel: TPanel;
    SaleGrid: TcxGrid;
    SaleView: TcxGridDBTableView;
    SaleLevel: TcxGridLevel;
    SaleDataSet: TABSQuery;
    SaleDataSource: TDataSource;
    SaleViewprod_nm: TcxGridDBColumn;
    SaleViewcalc_charge_amt: TcxGridDBColumn;
    LanePopupMenu: TPopupMenu;
    mniLaneHold: TMenuItem;
    mniGameCancel: TMenuItem;
    mniGameAssign: TMenuItem;
    mniSaleView: TMenuItem;
    mniLaneControl: TMenuItem;
    mniPinSetterOn: TMenuItem;
    mniMonitorOn: TMenuItem;
    mniMonitorOff: TMenuItem;
    mniGameNext: TMenuItem;
    mniScoreEdit: TMenuItem;
    mniLaneInit: TMenuItem;
    SaleVieworder_qty: TcxGridDBColumn;
    mniLaneCheck: TMenuItem;
    mniPinSetterOff: TMenuItem;
    mniPinSetting1: TMenuItem;
    mniPinSetting2: TMenuItem;
    N1: TMenuItem;
    mniLeagueMode: TMenuItem;
    GameViewassign_no: TcxGridDBColumn;
    mniBowlerPause: TMenuItem;
    SaleRemainDataSet: TABSQuery;
    GameViewshoes_yn: TcxGridDBColumn;

    procedure GameViewprogressCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure GridViewSaleDataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure LanePopupMenuPopup(Sender: TObject);
    procedure mniLaneHoldClick(Sender: TObject);
    procedure mniGameCancelClick(Sender: TObject);
    procedure mniGameAssignClick(Sender: TObject);
    procedure mniSaleViewClick(Sender: TObject);
    procedure mniPinSetterOnClick(Sender: TObject);
    procedure mniMonitorOnClick(Sender: TObject);
    procedure mniMonitorOffClick(Sender: TObject);
    procedure mniLaneInitClick(Sender: TObject);
    procedure mniLaneCheckClick(Sender: TObject);
    procedure mniLeagueModeClick(Sender: TObject);
    procedure mniGameNextClick(Sender: TObject);
   	procedure mniScoreEditClick(Sender: TObject);
    procedure mniPinSetterOffClick(Sender: TObject);
    procedure mniPinSetting1Click(Sender: TObject);
    procedure mniPinSetting2Click(Sender: TObject);

    procedure OnBaseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mniBowlerPauseClick(Sender: TObject);
  private
    FLaneNo: ShortInt;
    FAssignLaneNo: ShortInt;
    FLaneIndex: ShortInt;
    FLaneStatus: ShortInt;
    FAssignNo: string;
    FGroupNo: ShortInt;
    FGrouped: Boolean;
    FSelected: Boolean;
    FClickWithShift: Boolean;
    FLeagueMode: Boolean;
    FRallyMode: Boolean;
    FLaneShiftMethod: string;
    FLaneShiftCount: ShortInt;
    FLaneShiftFormat: string;
    FFrameNo: ShortInt;
    FChargeAmt: Integer;
    FChargeRemainAmt: Integer;
    FReceiptNo: string;

    FNormalColor: TColor;
    FSelectColor: TColor;
    FGroupColor: TColor;

    FLaneSelectCallbackProc: TLaneSelectCallbackProc;
    FLaneMsgCallbackProc: TLaneMsgCallbackProc;

    procedure DoGameAssign(const AAssignNo: string='');
    procedure DoBowlerPause(const AJobName: string; const AValue: Boolean);
    procedure DoPinSetterOnOff(const AJobName: string; const AValue: Boolean);
    procedure DoGameMonitorOnOff(const AJobName: string; const AValue: Boolean);
    procedure DoPinSettingType(const AJobName: string; const AValue: ShortInt);

    procedure SetLaneNo(const ALaneNo: ShortInt);
    procedure SetLaneIndex(const ALaneIndex: ShortInt);
    procedure SetLaneStatus(const AValue: ShortInt);
    procedure SetGroupNo(const AGroupNo: ShortInt);
    procedure SetSelected(const AValue: Boolean);
    procedure SetGrouped(const AValue: Boolean);
    procedure SetLeagueMode(const AValue: Boolean);
    procedure SetRallyMode(const AValue: Boolean);
    procedure SetLaneShiftMethod(const AValue: string);
    procedure SetLaneShiftCount(const AValue: ShortInt);
    procedure SetFrameNo(const AValue: ShortInt);
    procedure SetChargeAmt(const AValue: Integer);
    procedure SetChargeRemainAmt(const AValue: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RefreshSale;
    procedure RefreshAll;
    procedure DoPopupMenu(const AMenuId: ShortInt; const AValue: string='');

    property LaneNo: ShortInt read FLaneNo write SetLaneNo default 0;
    property AssignLaneNo: ShortInt read FAssignLaneNo write FAssignLaneNo default 0;
    property LaneIndex: ShortInt read FLaneIndex write SetLaneIndex default 0;
    property LaneStatus: ShortInt read FLaneStatus write SetLaneStatus default 0;
    property AssignNo: string read FAssignNo write FAssignNo;
    property GroupNo: ShortInt read FGroupNo write SetGroupNo default 0;
    property Grouped: Boolean read FGrouped write SetGrouped default False;
    property Selected: Boolean read FSelected write SetSelected default False;
    property ClickWithShift: Boolean read FClickWithShift write FClickWithShift default False;

    property LeagueMode: Boolean read FLeagueMode write SetLeagueMode default False;
    property RallyMode: Boolean read FRallyMode write SetRallyMode default False;
    property LaneShiftMethod: string read FLaneShiftMethod write SetLaneShiftMethod;
    property LaneShiftCount: ShortInt read FLaneShiftCount write SetLaneShiftCount default 0; //2개 레인 단위 좌우 측으로 이동
    property FrameNo: ShortInt read FFrameNo write SetFrameNo default 0;
    property ChargeAmt: Integer read FChargeAmt write SetChargeAmt default 0;
    property ChargeRemainAmt: Integer read FChargeRemainAmt write SetChargeRemainAmt default 0;
    property ReceiptNo: string read FReceiptNo write FReceiptNo;

    property NormalColor: TColor read FNormalColor write FNormalColor;
    property SelectColor: TColor read FSelectColor write FSelectColor;
    property GroupColor: TColor read FGroupColor write FGroupColor;

    property LaneSelectCallbackProc: TLaneSelectCallbackProc read FLaneSelectCallbackProc write FLaneSelectCallbackProc;
    property LaneMsgCallbackProc: TLaneMsgCallbackProc read FLaneMsgCallbackProc write FLaneMsgCallbackProc;
  end;

implementation

uses
  { Native }
  System.DateUtils, System.StrUtils, System.Variants, Vcl.Dialogs,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.BPMsgBox;

{$R *.DFM}

{ TBPLaneContainer }

constructor TBPLaneContainer.Create(AOwner: TComponent);
begin
  inherited;

  FLaneNo := 0;
  FAssignLaneNo := 0;
  FLaneIndex := 0;
  FLaneStatus := -1;
  FAssignNo := '';
  FGroupNo := 0;
  FSelected := False;
  FClickWithShift := False;
  FGrouped := False;
  FLeagueMode := False;
  FRallyMode := False;
  FLaneShiftMethod := '';
  FLaneShiftFormat := '%d';
  FLaneShiftCount := 0;
  FFrameNo := 0;
  FChargeAmt := 0;
  FChargeRemainAmt := 0;
  FReceiptNo := '';
  FNormalColor := CO_COLOR_BASE_NORMAL;
  FSelectColor := CO_COLOR_BASE_SELECT;
  FGroupColor := CO_COLOR_BASE_GROUP;

  LaneNoPanel.Caption := '';
  SpecialModeLabel.Caption := '';
  LeagueModeLabel.Caption := '';
  FrameNoLabel.Caption := '';
  RallyModeImage.Picture.Assign(BPDM.imcIcons.GetBitmap(65, 32, 32)); //트로피 이미지
  RallyModeImage.Visible := False;
  ShiftMethodLabel.Caption := '';
  ShiftMethodLabel.Visible := False;
  GameInfoPanel.Caption := '';
  PaymentInfoPanel.Caption := '';
  GameGrid.BringToFront;
  GameView.OptionsView.Header := False;
  SaleView.OptionsView.Header := False;
  SaleGrid.Height := CO_CONTAINER_GRID_SALE_HEIGHT;
  SaleGrid.Top := 210;

  Self.Color := CO_COLOR_BASE_NORMAL;
  LaneNoPanel.Color := CO_COLOR_LANE_NO_NORMAL;
  StatusPanel.Color := CO_COLOR_LANE_READY;

  LaneNoPanel.OnMouseDown := OnBaseMouseDown;
  TitlePanel.OnMouseDown := OnBaseMouseDown;
  RallyModeImage.OnMouseDown := OnBaseMouseDown;
  ShiftMethodLabel.OnMouseDown := OnBaseMouseDown;
  SpecialModeLabel.OnMouseDown := OnBaseMouseDown;
  LeagueModeLabel.OnMouseDown := OnBaseMouseDown;
  FrameNoLabel.OnMouseDown := OnBaseMouseDown;
  GameInfoPanel.OnMouseDown := OnBaseMouseDown;
  PaymentInfoPanel.OnMouseDown := OnBaseMouseDown;
  GameView.OnMouseDown := OnBaseMouseDown;
  SaleView.OnMouseDown := OnBaseMouseDown;
end;

destructor TBPLaneContainer.Destroy;
begin

  inherited;
end;

procedure TBPLaneContainer.GameViewprogressCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  LBowlerId, LBowlerName, LProdName: Variant;
begin
  with TcxGridDBTableView(Sender) do
  begin
    LBowlerId := AViewInfo.GridRecord.Values[GetColumnByFieldName('bowler_id').Index];
    if VarIsNull(LBowlerId) then
      LBowlerId := '';
    LBowlerName := AViewInfo.GridRecord.Values[GetColumnByFieldName('bowler_nm').Index];
    if VarIsNull(LBowlerName) then
      LBowlerName := '';
    LBowlerName := IfThen(LBowlerId = LBowlerName, '', ' ' + LBowlerName);
    LProdName := AViewInfo.GridRecord.Values[GetColumnByFieldName('prod_nm').Index];
    if VarIsNull(LProdName) then
      LProdName := '';
    AViewInfo.EditViewInfo.Paint(ACanvas);
    ACanvas.Brush.Style := bsClear;
    ACanvas.DrawText(Format('%s%s %s', [LBowlerId, LBowlerName, LProdName]), AViewInfo.TextAreaBounds, cxAlignLeft or cxAlignVCenter);
    ADone := True;
  end;
end;

procedure TBPLaneContainer.GridViewSaleDataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with SaleView.DataController.Summary do
    ChargeAmt := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(SaleViewcalc_charge_amt)]), 0);
end;

procedure TBPLaneContainer.OnBaseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button in [mbLeft]) then
  begin
    ClickWithShift := (ssShift in Shift); //Select Callback Proc에서 처리
    Selected := (not Selected);
  end;
end;

procedure TBPLaneContainer.LanePopupMenuPopup(Sender: TObject);
begin
  mniScoreEdit.Enabled := (LaneStatus in [CO_LANE_BUSY, CO_LANE_END_UNPAID]);
  mniLaneHold.Enabled := (LaneStatus in [CO_LANE_READY, CO_LANE_HOLD]);
    mniLaneHold.Caption := '임시 예약' + IfThen(LaneStatus = CO_LANE_HOLD, ' 취소', '');
  mniGameCancel.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY, CO_LANE_END_UNPAID]);
  mniLeagueMode.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
    mniLeagueMode.Caption := IfThen(LeagueMode, '오픈', '리그') + ' 게임으로 전환';
  mniGameNext.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY, CO_LANE_END_UNPAID]);
  mniBowlerPause.Enabled := (GameView.DataController.RecordCount > 0);
  if mniBowlerPause.Enabled then
    mniBowlerPause.Caption := '볼러 일시정지' + IfThen(GameView.DataController.DataSet.FieldByName('direction').AsInteger = CO_LANE_DIR_PAUESD, ' 해제', '');
  mniPinSetterOn.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
  mniPinSetterOff.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
  mniMonitorOn.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
  mniMonitorOff.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
  mniPinSetting1.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
  mniPinSetting2.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
  mniLaneInit.Enabled := (LaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY, CO_LANE_END_UNPAID]);
  mniLaneCheck.Caption := '레인 점검' + IfThen(LaneStatus = CO_LANE_MAINTENANCE, ' 해제', '');
end;

procedure TBPLaneContainer.mniGameAssignClick(Sender: TObject);
begin
  DoGameAssign;
end;

procedure TBPLaneContainer.mniSaleViewClick(Sender: TObject);
begin
  Selected := True;
//  Global.LaneInfo.Lanes[LaneIndex].AssignIndex := 0;
  ShowSalePos(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

procedure TBPLaneContainer.mniScoreEditClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  try
    SendToMainForm(CPC_GAME_REFRESH_FORCE);

    PM := TPluginMessage.Create(Self);
    with PM do
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Global.Plugin.LaneViewPluginId);
      PM.AddParams(CPP_LANE_NO, LaneNo);
      PM.AddParams(CPP_DATASET, TObject(GameDataSet));
      if (PluginManager.OpenModal('BPLaneScoreView' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK) then
        SendToMainForm(CPC_GAME_REFRESH_DELAY);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtInformation, '알림', '점수 수정 작업에 실패하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.mniLaneHoldClick(Sender: TObject);
var
  LJoBName, LResMsg: string;
begin
  LJobName := TMenuItem(Sender).Caption;
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(LJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetHoldLane(LaneNo, not (LaneStatus = CO_LANE_HOLD), LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [LJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [LJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.mniGameCancelClick(Sender: TObject);
var
  LJobName, LSQL, LResMsg: string;
  LCount: Integer;
begin
  LJobName := TMenuItem(Sender).Caption;
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(LJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    LSQL := Format('SELECT seq FROM TBPayment WHERE receipt_no = %s;', [ReceiptNo.QuotedString]);
    LCount := BPDM.GetABSRecordCount(LSQL, LResMsg);
    if not LResMsg.IsEmpty then
      raise Exception.Create('결제한 내역을 확인할 수 없습니다.' + _BR + LResMsg);
    if (LCount > 0) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림', '취소할 게임/예약의 결제 내역이 존재합니다.' + _BR + '해당 결제 내역을 먼저 취소하여야 합니다.', ['확인'], 5);
      Exit;
    end;
    if not BPDM.CancelGame(LaneNo, AssignNo, LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [LJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [LJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.mniLeagueModeClick(Sender: TObject);
var
  LJobName, LResMsg: string;
begin
  try
    LJobName := TMenuItem(Sender).Caption;
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          Format('<B>%d</B> 레인을 <B>', [LaneNo]) + ErrorString(LJobName) + '</B> 모드로 변경하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetLeagueMode(LaneNo, (not LeagueMode), LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [LJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [LJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.mniGameNextClick(Sender: TObject);
var
  LJobName, LResMsg: string;
begin
  try
    LJobName := TMenuItem(Sender).Caption;
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(LJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetGameNext(LaneNo, LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [LJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [LJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.mniBowlerPauseClick(Sender: TObject);
var
  LPaused: Boolean;
begin
  LPaused := (GameView.DataController.DataSet.FieldByName('direction').AsInteger = CO_LANE_DIR_PAUESD);
  DoBowlerPause(TMenuItem(Sender).Caption, not LPaused);
end;

procedure TBPLaneContainer.mniPinSetterOnClick(Sender: TObject);
begin
  DoPinSetterOnOff(TMenuItem(Sender).Caption, True);
end;

procedure TBPLaneContainer.mniPinSetterOffClick(Sender: TObject);
begin
  DoPinSetterOnOff(TMenuItem(Sender).Caption, False);
end;

procedure TBPLaneContainer.mniMonitorOnClick(Sender: TObject);
begin
  DoGameMonitorOnOff(TMenuItem(Sender).Caption, True);
end;

procedure TBPLaneContainer.mniMonitorOffClick(Sender: TObject);
begin
  DoGameMonitorOnOff(TMenuItem(Sender).Caption, False);
end;

procedure TBPLaneContainer.mniPinSetting1Click(Sender: TObject);
begin
  DoPinSettingType(TMenuItem(Sender).Caption, 1);
end;

procedure TBPLaneContainer.mniPinSetting2Click(Sender: TObject);
begin
  DoPinSettingType(TMenuItem(Sender).Caption, 2);
end;

procedure TBPLaneContainer.mniLaneInitClick(Sender: TObject);
var
  LJobName, LResMsg: string;
begin
  try
    LJobName := TMenuItem(Sender).Caption;
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(LJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if (LaneStatus = CO_LANE_HOLD) and
       (not BPDM.SetHoldLane(LaneNo, False, LResMsg)) then
      raise Exception.Create(LResMsg);
    if not BPDM.InitLane(LaneNo, LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [LJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [LJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.mniLaneCheckClick(Sender: TObject);
var
  LJobName, LResMsg: string;
  LLockMode: Boolean;
begin
  try
    LLockMode := (LaneStatus = CO_LANE_MAINTENANCE);
    LJobName := TMenuItem(Sender).Caption;
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(LJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetMaintenanceLane(LaneNo, (not LLockMode), LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [LJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [LJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.SetLaneNo(const ALaneNo: ShortInt);
begin
  FLaneNo := ALaneNo;
  LaneNoPanel.Caption := FLaneNo.ToString;
end;

procedure TBPLaneContainer.SetLaneIndex(const ALaneIndex: ShortInt);
begin
  FLaneIndex := ALaneIndex;
  TitlePanel.Tag := FLaneIndex;
  LaneNoPanel.Tag := FLaneIndex;
  SpecialModeLabel.Tag := FLaneIndex;
  LeagueModeLabel.Tag := FLaneIndex;
  FrameNoLabel.Tag := FLaneIndex;
  GameView.Tag := FLaneIndex;
  SaleView.Tag := FLaneIndex;
  GameInfoPanel.Tag := FLaneIndex;
  PaymentInfoPanel.Tag := FLaneIndex;
end;

procedure TBPLaneContainer.SetLaneStatus(const AValue: ShortInt);
var
  LHint: string;
begin
  if (FLaneStatus <> AValue) then
  begin
    FLaneStatus := AValue;
    StatusPanel.Color := GetLaneStatusColor(FLaneStatus);
    StatusPanel.Visible := (FLaneStatus <> CO_LANE_READY);
    SendToPluginLaneStatus(Global.Plugin.LaneViewPluginId, LaneIndex, FLaneStatus);
    SendToPluginLaneStatus(Global.Plugin.AssignGamePluginId, LaneIndex, FLaneStatus);
    LHint := GetLaneStatusName(FLaneStatus);
    TitlePanel.Hint := LHint;
    LaneNoPanel.Hint := LHint;
    StatusPanel.Hint := LHint;
  end;
end;

procedure TBPLaneContainer.SetGroupNo(const AGroupNo: ShortInt);
begin
  if (FGroupNo <> AGroupNo) then
  begin
    FGroupNo := AGroupNo;
    Grouped := (FGroupNo > 0);
  end;
end;

procedure TBPLaneContainer.SetSelected(const AValue: Boolean);
begin
  FSelected := AValue;
  if FSelected then
  begin
    Self.Color := CO_COLOR_LANE_NO_NORMAL; //SelectColor;
    LaneNoPanel.Color := CO_COLOR_LANE_NO_SELECT;
  end
  else
  begin
    if Grouped then
    begin
      Self.Color := GroupColor;
      LaneNoPanel.Color := CO_COLOR_LANE_NO_GROUP;
    end
    else
    begin
      Self.Color := NormalColor;
      LaneNoPanel.Color := CO_COLOR_LANE_NO_NORMAL;
    end;
  end;

  if Assigned(LaneSelectCallbackProc) then
    LaneSelectCallbackProc(Self);
end;

procedure TBPLaneContainer.SetLaneShiftMethod(const AValue: string);
var
  LShiftMode: string;
begin
  if (FLaneShiftMethod <> AValue) then
  begin
    FLaneShiftMethod := AValue;
    if (FLaneShiftMethod = CO_TABLE_SHIFT_GENERAL) then
    begin
      FLaneShiftFormat := '▶▶%d';
      LShiftMode := '일반 이동';
    end
    else if (FLaneShiftMethod = CO_TABLE_SHIFT_LEFT_RIGHT) then
    begin
      FLaneShiftFormat := '◀%d▶';
      LShiftMode := '좌우 이동';
    end
    else if (FLaneShiftMethod = CO_TABLE_SHIFT_CROSS) then
    begin
      FLaneShiftFormat := '▶%d◀';
      LShiftMode := '크로스 이동';
    end
    else
    begin
      FLaneShiftFormat := '[%d]';
      LShiftMode := '';
    end;

    ShiftMethodLabel.Caption := Format(FLaneShiftFormat, [FLaneShiftCount]);
    ShiftMethodLabel.Hint := LShiftMode;
  end;
end;

procedure TBPLaneContainer.SetLaneShiftCount(const AValue: ShortInt);
begin
  if (FLaneShiftCount <> AValue) then
  begin
    FLaneShiftCount := AValue;
    ShiftMethodLabel.Caption := Format(FLaneShiftFormat, [FLaneShiftCount])
  end;
end;

procedure TBPLaneContainer.SetGrouped(const AValue: Boolean);
begin
  IF (FGrouped <> AValue) then
  begin
    FGrouped := AValue;
    if FGrouped then
    begin
      Self.Color := GroupColor;
      LaneNoPanel.Color := CO_COLOR_LANE_NO_GROUP;
    end
    else
    begin
      if Selected then
      begin
        Self.Color := SelectColor;
        LaneNoPanel.Color := CO_COLOR_LANE_NO_SELECT;
      end
      else
      begin
        Self.Color := NormalColor;
        LaneNoPanel.Color := CO_COLOR_LANE_NO_NORMAL;
      end;
    end;
  end;
end;

procedure TBPLaneContainer.SetLeagueMode(const AValue: Boolean);
begin
  if (FLeagueMode <> AValue) then
  begin
    FLeagueMode := AValue;
    LeagueModeLabel.Caption := IfThen(FLeagueMode, 'L', '');
  end;
end;

procedure TBPLaneContainer.SetRallyMode(const AValue: Boolean);
begin
  if (FRallyMode <> AValue) then
  begin
    FRallyMode := AValue;
    RallyModeImage.Left := LaneNoPanel.Width;
    RallyModeImage.Visible := FRallyMode;
    ShiftMethodLabel.Left := (RallyModeImage.Left + RallyModeImage.Width);
    ShiftMethodLabel.Visible := FRallyMode;
  end;
end;

procedure TBPLaneContainer.SetFrameNo(const AValue: ShortInt);
begin
  FFrameNo := AValue;
  FrameNoLabel.Caption := IfThen(LaneStatus in [CO_LANE_RESERVED, CO_LANE_HOLD, CO_LANE_BUSY, CO_LANE_END_UNPAID, CO_LANE_END], FFrameNo.ToString, '');
end;

procedure TBPLaneContainer.SetChargeAmt(const AValue: Integer);
begin
  if (FChargeAmt <> AValue) then
  begin
    FChargeAmt := AValue;
    PaymentInfoPanel.Caption :=
      IfThen(FChargeAmt > 0, FormatCurr('#,##0 원', FChargeAmt), '') +
      IfThen(ChargeRemainAmt > 0, FormatCurr(' (#,##0 원)', ChargeRemainAmt), '');
  end;
end;

procedure TBPLaneContainer.SetChargeRemainAmt(const AValue: Integer);
begin
  if (FChargeRemainAmt <> AValue) then
  begin
    FChargeRemainAmt := AValue;
    PaymentInfoPanel.Caption :=
      IfThen(ChargeAmt > 0, FormatCurr('#,##0 원', ChargeAmt), '') +
      IfThen(FChargeRemainAmt > 0, FormatCurr(' (#,##0 원)', FChargeRemainAmt), '');
  end;
end;

procedure TBPLaneContainer.RefreshSale;
var
  BM: TBookmark;
begin
  AssignLaneNo := Global.LaneInfo.AssignLaneNo(LaneNo);
  with SaleRemainDataSet do
  try
    DisableControls;
    Close;
    Params.ParamByName('p_assign_lane_no').AsInteger := AssignLaneNo;
    Params.ParamByName('p_assign_no').AsString := AssignNo;
    Open;
    if (RecordCount > 0) then
      ChargeRemainAmt := FieldByName('charge_total').AsInteger
    else
      ChargeRemainAmt := 0;
  finally
    EnableControls;
  end;

  with SaleDataSet do
  try
    BM := GetBookmark;
    DisableControls;
    try
      Close;
      Params.ParamByName('p_assign_lane_no').AsInteger := AssignLaneNo;
      Params.ParamByName('p_assign_no').AsString := AssignNo;
//      Params.ParamByName('p_receipt_no').AsString := ReceiptNo;
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    except
      on E: Exception do
        if Assigned(LaneMsgCallbackProc) then
          LaneMsgCallbackProc(Self, E.Message);
    end;
  finally
    if Assigned(BM) then
      FreeBookmark(BM);
    EnableControls;
    SaleGrid.Visible := (RecordCount > 0);
    if SaleGrid.Visible then
      SaleGrid.Top := 210;
  end;
end;

procedure TBPLaneContainer.RefreshAll;
var
  BM: TBookmark;
  LDateTime: string;
begin
  with GameDataSet do
  try
    BM := GetBookmark;
    DisableControls;
    try
      Close;
      Params.ParamByName('p_lane_no').AsInteger := LaneNo;
      Open;
      if (RecordCount = 0) then
      begin
        LaneStatus := CO_LANE_READY;
        LeagueMode := False;
        FrameNo := 0;
        AssignNo := '';
        RallyMode := False;
        LaneShiftmethod := CO_TABLE_SHIFT_GENERAL;
        LaneShiftCount := 0;
        GameInfoPanel.Caption := '';
      end
      else
      begin
        LaneStatus := FieldByName('lane_status').AsInteger;
        LeagueMode := FieldByName('league_yn').AsBoolean;
        FrameNo := FieldByName('frame_no').AsInteger;
        AssignNo := FieldByName('assign_no').AsString;
        RallyMode := (FieldByName('rally_seq').AsInteger > 0);
        LaneShiftmethod := FieldByName('lane_shift_method').AsString;
        LaneShiftCount := FieldByName('lane_shift_cnt').AsInteger;
        Last;
        LDateTime := FieldByName('expected_end_datetime').AsString;
        if (LaneStatus in [CO_LANE_HOLD, CO_LANE_END_UNPAID, CO_LANE_END, CO_LANE_MAINTENANCE]) then
        begin
          GameInfoPanel.Font.Color := GetLaneStatusColor(LaneStatus);
          GameInfoPanel.Caption := GetLaneStatusName(LaneStatus);
        end
        else
        begin
          GameInfoPanel.Font.Color := clWhite;
          GameInfoPanel.Caption := IfThen(LDateTime.IsEmpty, '', LDateTime);
        end;
      end;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    except
      on E: Exception do
        if Assigned(LaneMsgCallbackProc) then
          LaneMsgCallbackProc(Self, E.Message);
    end;
  finally
    if Assigned(BM) then
      FreeBookmark(BM);
    EnableControls;
  end;

  RefreshSale;
end;

procedure TBPLaneContainer.DoGameAssign(const AAssignNo: string);
var
  PM: TPluginMessage;
  LResMsg: string;
  bHold: Boolean;
begin
  bHold := False;

  //if (LaneStatus in [CO_LANE_READY, CO_LANE_HOLD]) then
  begin
    if not BPDM.SetHoldLane(LaneNo, True, LResMsg) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림',
        ErrorString(LaneNo.ToString) + ' 레인은 현재 임시 예약 상태입니다.' + _BR + '임시 예약을 취소하거나, 잠시 후 다시 시도하여 주십시오.', ['확인'], 5);
      Exit;
    end;
    bHold := True;
  end;

  PM := TPluginMessage.Create(nil);
  with PM do
  try
    PM.Command := CPC_GAME_ASSIGN;
    PM.AddParams(CPP_LANE_NO, LaneNo);
    PM.AddParams(CPP_ASSIGN_NO, AAssignNo);
    PM.PluginMessageToID(Global.Plugin.LaneViewPluginId);
  finally
    FreeAndNil(PM);
  end;

  if bHold = True then
  begin
    if (not BPDM.SetHoldLane(LaneNo, False, LResMsg)) then
      BPMsgBox(Self.Handle, mtError, '알림', Format('%s 명령 전송에 실패하였습니다.', ['임시예약']) + _BR + ErrorString(LResMsg), ['확인'], 5);
  end;

end;

procedure TBPLaneContainer.DoBowlerPause(const AJobName: string; const AValue: Boolean);
var
  LBowlerId, LBowlerName, LAssignNo, LResMsg: string;
begin
  with GameDataSet do
  try
    LBowlerId := FieldByName('bowler_id').AsString;
    LAssignNo := FieldByName('assign_no').AsString;
    LBowlerName := FieldByName('bowler_nm').AsString;
    LBowlerName := IfThen(LBowlerId = LBowlerName, '', ' ' + LBowlerName);
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          Format('<B>%d 레인 %s%s (%s)</B> 님을 <B>%s</B> 하시겠습니까?', [LaneNo, LBowlerId, LBowlerName, LAssignNo, ErrorString(AJobName)]), ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetBowlerPause(AssignNo, LBowlerId, AValue, LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + '<FC:$000000FF>' + E.Message + '</FC>', ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.DoPinSetterOnOff(const AJobName: string; const AValue: Boolean);
var
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(AJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetPinSetter(LaneNo, AValue, LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.DoGameMonitorOnOff(const AJobName: string; const AValue: Boolean);
var
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(AJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetGameMonitor(LaneNo, AValue, LResMsg) then
      raise Exception.Create(LResMsg);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.DoPinSettingType(const AJobName: string; const AValue: ShortInt);
var
  LResMsg: string;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [LaneNo]) + ErrorString(AJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetPinSettingType(LaneNo, AValue, LResMsg) then
      raise Exception.Create(LResMsg);
    SendToMainForm(CPC_GAME_REFRESH_DELAY);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneContainer.DoPopupMenu(const AMenuId: ShortInt; const AValue: string);
begin
  Selected := True;
  case AMenuId of
    CO_POPUP_GAME_ASSIGN:
      DoGameAssign(AValue);
    CO_POPUP_SALE_VIEW:
      mniSaleViewClick(mniSaleView);
    CO_POPUP_SCORE_EDIT:
      mniScoreEditClick(mniScoreEdit);
    CO_POPUP_LANE_HOLD:
      mniLaneHoldClick(mniLaneHold);
    CO_POPUP_GAME_CANCEL:
      mniGameCancelClick(mniGameCancel);
    CO_POPUP_LEAGUE_MODE:
      mniLeagueModeClick(mniLeagueMode);
    CO_POPUP_GAME_NEXT:
      mniGameNextClick(mniGameNext);
    CO_POPUP_BOWLER_PAUSE:
      mniBowlerPauseClick(mniBowlerPause);
    CO_POPUP_PIN_SETTER_ON:
      mniPinSetterOnClick(mniPinSetterOn);
    CO_POPUP_PIN_SETTER_OFF:
      mniPinSetterOffClick(mniPinSetterOff);
    CO_POPUP_MONITOR_ON:
      mniMonitorOnClick(mniMonitorOn);
    CO_POPUP_MONITOR_OFF:
      mniMonitorOffClick(mniMonitorOff);
    CO_POPUP_PIN_SETTING_1:
      mniPinSetting1Click(mniPinSetting1);
    CO_POPUP_PIN_SETTING_2:
      mniPinSetting2Click(mniPinSetting2);
    CO_POPUP_LANE_INIT:
      mniLaneInitClick(mniLaneInit);
    CO_POPUP_LANE_CHECK:
      mniLaneCheckClick(mniLaneCheck);
  end;
end;

end.
