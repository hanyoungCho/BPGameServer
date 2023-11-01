(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 레인 상황 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPLaneView.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, Data.DB, Vcl.Menus,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxImageComboBox, cxLabel, cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid;

{$I ..\..\common\Common.BPCommon.inc}

const
  LCN_TOOLBTN_COUNT    = 12;
  LCN_LANE_INTERVAL    = 5;
  LCN_LANE_BASE_WIDTH  = 238;
  LCN_LANE_BASE_HEIGHT = 354; //384;

type
  TLaneNoPanel = class(TPanel)
    StatusPanel: TPanel;
  private
    FLaneStatus: Shortint;
    procedure SetLaneStatus(const AValue: Shortint);
  public
    constructor Create(const AIndex: ShortInt; AOwner: TComponent; AParent: TWinControl); reintroduce;
    destructor Destroy; override;

    property LaneStatus: Shortint read FLaneStatus write SetLaneStatus default 0;
  end;

  TBPLaneViewForm = class(TPluginModule)
    panFooter: TPanel;
    panToolBar: TPanel;
    btnGameMenu1: TBitBtn;
    aclLaneMenu: TActionList;
    actPinSetterOn: TAction;
    actMonitorOn: TAction;
    actMonitorOff: TAction;
    actLaneAssign: TAction;
    actLaneControl: TAction;
    actOpenGame: TAction;
    actLeagueGame: TAction;
    actGameNext: TAction;
    actLaneClear: TAction;
    actRallyMode: TAction;
    btnGameMenu3: TBitBtn;
    btnGameMenu4: TBitBtn;
    btnGameMenu5: TBitBtn;
    btnGameMenu6: TBitBtn;
    btnGameMenu7: TBitBtn;
    btnGameMenu8: TBitBtn;
    btnGameMenu9: TBitBtn;
    btnGameMenu12: TBitBtn;
    btnGameMenu10: TBitBtn;
    panMiniMap: TPanel;
    btnLaneSelectAll: TBitBtn;
    sbxLaneView: TScrollBox;
    dsrAssignList: TDataSource;
    btnLaneRefresh: TBitBtn;
    tmrRunOnce: TTimer;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    L1: TcxGridLevel;
    V1assign_no: TcxGridDBBandedColumn;
    V1reserve_datetime: TcxGridDBBandedColumn;
    V1calc_lane_no: TcxGridDBBandedColumn;
    V1bowler_seq: TcxGridDBBandedColumn;
    V1calc_bowler_nm: TcxGridDBBandedColumn;
    V1calc_game_div: TcxGridDBBandedColumn;
    V1calc_payment_type: TcxGridDBBandedColumn;
    V1expected_end_datetime: TcxGridDBBandedColumn;
    V1league_yn: TcxGridDBBandedColumn;
    V1calc_assign_status: TcxGridDBBandedColumn;
    V1game_cnt: TcxGridDBBandedColumn;
    V1game_fin: TcxGridDBBandedColumn;
    V1prod_nm: TcxGridDBBandedColumn;
    V1handy: TcxGridDBBandedColumn;
    panReserveControl: TPanel;
    btnGameMenu13: TBitBtn;
    btnGameMenu2: TBitBtn;
    actPinSetterOff: TAction;
    actGameRefresh: TAction;
    actAssignRefresh: TAction;
    actLaneSelectClear: TAction;
    btnLaneSelectClear: TBitBtn;
    actLaneSelectAll: TAction;
    LanePopupMenu: TPopupMenu;
    mniGameAssign: TMenuItem;
    mniSaleView: TMenuItem;
    N1: TMenuItem;
    mniScoreEdit: TMenuItem;
    mniLaneHold: TMenuItem;
    mniGameCancel: TMenuItem;
    mniLeagueMode: TMenuItem;
    mniGameNext: TMenuItem;
    mniLaneControl: TMenuItem;
    mniPinSetterOn: TMenuItem;
    mniPinSetterOff: TMenuItem;
    mniMonitorOn: TMenuItem;
    mniMonitorOff: TMenuItem;
    mniPinSetting1: TMenuItem;
    mniPinSetting2: TMenuItem;
    mniLaneInit: TMenuItem;
    mniLaneCheck: TMenuItem;
    mniBowlerPause: TMenuItem;
    V1direction: TcxGridDBBandedColumn;
    V1game_min: TcxGridDBBandedColumn;
    btnGameMenu16: TBitBtn;
    btnGameMenu14: TBitBtn;
    actReceiptList: TAction;
    V1lane_no: TcxGridDBBandedColumn;
    actAssignListAll: TAction;
    V1calc_receipt_no: TcxGridDBBandedColumn;
    mniSetChangePaid: TMenuItem;
    V1calc_rally_yn: TcxGridDBBandedColumn;
    btnGameMenu15: TBitBtn;
    btnGameMenu11: TBitBtn;
    actPinSetting1: TAction;
    actPinSetting2: TAction;
    V1shoes_rent_yn: TcxGridDBBandedColumn;
    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleResize(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure tmrRunOnceTimer(Sender: TObject);
    procedure sbxLaneViewMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure G1Enter(Sender: TObject);
    procedure G1Exit(Sender: TObject);
    procedure actLaneSelectClearExecute(Sender: TObject);
    procedure actGameRefreshExecute(Sender: TObject);
    procedure actLaneSelectAllExecute(Sender: TObject);
    procedure actPinSetterOnExecute(Sender: TObject);
    procedure actPinSetterOffExecute(Sender: TObject);
    procedure actMonitorOnExecute(Sender: TObject);
    procedure actMonitorOffExecute(Sender: TObject);
    procedure actLaneAssignExecute(Sender: TObject);
    procedure actOpenGameExecute(Sender: TObject);
    procedure actLeagueGameExecute(Sender: TObject);
    procedure actGameNextExecute(Sender: TObject);
    procedure actLaneClearExecute(Sender: TObject);
    procedure actLaneControlExecute(Sender: TObject);
    procedure actPinSetting1Execute(Sender: TObject);
    procedure actPinSetting2Execute(Sender: TObject);
    procedure actAssignRefreshExecute(Sender: TObject);
    procedure actAssignListAllExecute(Sender: TObject);
    procedure actRallyModeExecute(Sender: TObject);
    procedure actReceiptListExecute(Sender: TObject);

    procedure OnLaneNoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnLaneNoDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure OnLaneNoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LanePopupMenuPopup(Sender: TObject);
    procedure mniGameAssignClick(Sender: TObject);
    procedure mniSaleViewClick(Sender: TObject);
    procedure mniScoreEditClick(Sender: TObject);
    procedure mniLaneHoldClick(Sender: TObject);
    procedure mniGameCancelClick(Sender: TObject);
    procedure mniLeagueModeClick(Sender: TObject);
    procedure mniGameNextClick(Sender: TObject);
    procedure mniPinSetterOnClick(Sender: TObject);
    procedure mniPinSetterOffClick(Sender: TObject);
    procedure mniMonitorOnClick(Sender: TObject);
    procedure mniMonitorOffClick(Sender: TObject);
    procedure mniPinSetting1Click(Sender: TObject);
    procedure mniPinSetting2Click(Sender: TObject);
    procedure mniLaneInitClick(Sender: TObject);
    procedure mniLaneCheckClick(Sender: TObject);
    procedure mniBowlerPauseClick(Sender: TObject);
    procedure mniSetChangePaidClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FPluginVersion: string;
    FBaseTitle: string;
    FLaneColumns: ShortInt;
    FLaneRows: ShortInt;
    FLaneNoPanels: TArray<TLaneNoPanel>;
    FScrollBoxPageControl: Boolean;
    FPopupLaneIndex: ShortInt;
    FPopupLaneStatus: ShortInt;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DrawLaneLayout(const ACreateObject: Boolean=False);
    procedure ResizeControl;
    procedure FirstLaneClick;
    procedure DoPinSetterOnOff(const AJobName: string; const AValue: Boolean);
    procedure DoGameMonitorOnOff(const AJobName: string; const AValue: Boolean);
    procedure DoAssign(const ALaneNo: ShortInt; const AReservedAssignNo: string='');
    procedure DoCancelReservedGame(const AJobName, AAssignNo, AReceiptNo: string; const ALaneNo: ShortInt);
    procedure DoLaneControl;
    procedure DoLeagueGame(const AJobName: string; const AValue: Boolean);
    procedure DoGameNext(const AJobName: string);
    procedure DoInitLane(const AJobName: string);
    procedure DoChangePaymentType;
    procedure DoAssignListFilter(const AFiltered: Boolean; const ALaneNo: ShortInt=0);
    procedure DoPinSettingType(const AValue: ShortInt);

    procedure LaneSelectCallback(Sender: TObject);
    procedure LaneMsgCallback(Sender: TObject; const AMsg: string);

    procedure SetBaseTitle(const AValue: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property BaseTitle: string read FBaseTitle write SetBaseTitle;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs, System.Variants, System.Math, System.StrUtils,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, Common.BPLaneContainer;

{$R *.dfm}

{ TBPLaneViewForm }

constructor TBPLaneViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerId := 0;
  FPluginVersion := GetModuleVersion(GetModuleName(HInstance));
  FBaseTitle := '레인 관리';
  FPopupLaneIndex := 0;
  FPopupLaneStatus := 0;
  FScrollBoxPageControl := True;

  Self.Caption := FBaseTitle;
  sbxLaneView.VertScrollBar.Increment := (LCN_LANE_BASE_HEIGHT + LCN_LANE_INTERVAL);
  SetLength(FLaneNoPanels, Global.LaneInfo.LaneCount);
  for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
  begin
    FLaneNoPanels[I] := TLaneNoPanel.Create(I, Self, panMiniMap);
    FLaneNoPanels[I].OnMouseDown := OnLaneNoMouseDown;
    FLaneNoPanels[I].OnDragOver := OnLaneNoDragOver;
    FLaneNoPanels[I].OnDragDrop := OnLaneNoDragDrop;
  end;
  actAssignListAll.Enabled := False;
  V1.OptionsView.BandHeaders := False;

  DrawLaneLayout(True);
  FirstLaneClick;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  SendToMainForm(CPC_TITLE, FBaseTitle);
  tmrRunOnce.Enabled := True;
end;

destructor TBPLaneViewForm.Destroy;
begin
  Global.Plugin.LaneViewPluginId := 0;

  inherited Destroy;
end;

procedure TBPLaneViewForm.PluginModuleShow(Sender: TObject);
begin
  Global.Plugin.ActivePluginId := Self.PluginID;
end;

procedure TBPLaneViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPLaneViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_PRIOR: //PageUp
      with sbxLaneView do
        if FScrollBoxPageControl then
          VertScrollBar.Position := (VertScrollBar.Position - VertScrollBar.Increment);
    VK_NEXT: //PageDown
      with sbxLaneView do
        if FScrollBoxPageControl then
          VertScrollBar.Position := (VertScrollBar.Position + VertScrollBar.Increment);
    VK_ESCAPE:
      begin
        btnLaneSelectClear.Click;
        if V1.DataController.Filter.Active then
          DoAssignListFilter(False);
      end;
  end;
end;

procedure TBPLaneViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPLaneViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    BaseTitle := FBaseTitle;
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_LANE_VIEW);
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  end
  else if (AMsg.Command = CPC_ACTIVE) then
  begin
    BaseTitle := FBaseTitle;
    if (Self.Align = alClient) then
      Self.BringToFront
    else
      SetForegroundWindow(Self.Handle);
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_LANE_VIEW);
  end
  else if (AMsg.Command = CPC_LANE_STATUS) then
  begin
    var nIndex: ShortInt := AMsg.ParamByInteger(CPP_INDEX);
    var nStatus: ShortInt := AMsg.ParamByInteger(CPP_VALUE);
    if (nIndex <> -1) then
      with FLaneNoPanels[nIndex].StatusPanel do
      begin
        Color := GetLaneStatusColor(nStatus);
        Visible := (nStatus <> CO_LANE_READY);
      end;
  end
  else if (AMsg.Command = CPC_GAME_ASSIGN) then
    DoAssign(AMsg.ParamByInteger(CPP_LANE_NO), AMsg.ParamByString(CPP_ASSIGN_NO))
  else if (AMsg.Command = CPC_CLOSE) then
    Self.Close
  else if (AMsg.Command = CPC_RESIZE) then
    ResizeControl;
end;

procedure TBPLaneViewForm.PluginModuleResize(Sender: TObject);
begin
  ResizeControl;
end;

procedure TBPLaneViewForm.DrawLaneLayout(const ACreateObject: Boolean);
var
  LTop, LLeft, LBaseWidth, LLaneWidth: Integer;
  LRow, LCol, I, J: ShortInt;
begin
  sbxLaneView.VertScrollBar.Position := 0;
  LBaseWidth := (Self.Width - LCN_LANE_INTERVAL);
  FLaneColumns := (LBaseWidth div LCN_LANE_BASE_WIDTH);
  LLaneWidth := (LBaseWidth div FLaneColumns) - LCN_LANE_INTERVAL;
  FLaneRows := (Global.LaneInfo.LaneCount div FLaneColumns);
  if (FLaneRows > 2) then
  begin
    LBaseWidth := (LBaseWidth - 16);
    LLaneWidth := (LBaseWidth div FLaneColumns) - 4; //LCN_LANE_INTERVAL;
  end;

  LRow := 0;
  LCol := 0;
  for I := 0 to Pred(Global.LaneInfo.LaneCount) do
  begin
    if (LCol > Pred(FLaneColumns)) then
    begin
      LCol := 0;
      Inc(LRow);
    end;
    LTop := (LRow * LCN_LANE_INTERVAL) + (LRow * LCN_LANE_BASE_HEIGHT);
    LLeft := LCN_LANE_INTERVAL + (LCol * LLaneWidth) + (LCol * LCN_LANE_INTERVAL);

    with Global.LaneInfo.Lanes[I] do
    begin
      if ACreateObject then
      begin
        Container := TBPLaneContainer.Create(nil);
        Container.Parent := sbxLaneView;
        Container.LaneNoPanel.OnMouseDown := OnLaneNoMouseDown;
        Container.LaneNoPanel.OnDragOver := OnLaneNoDragOver;
        Container.LaneNoPanel.OnDragDrop := OnLaneNoDragDrop;
        Container.LaneSelectCallbackProc := LaneSelectCallback;
        Container.LaneMsgCallbackProc := LaneMsgCallback;
      end;
      Container.LaneIndex := I;
      Container.LaneNo := LaneNo;
      Container.Height := LCN_LANE_BASE_HEIGHT;
      Container.Width := LLaneWidth;
      Container.Top := LTop;
      Container.Left := LLeft;
    end;
    Inc(LCol);
  end;

  if (Global.LaneInfo.SelectedLanes.Count > 0) then
    for I := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
      for J := 0 to Pred(Global.LaneInfo.LaneCount) do
        if (Global.LaneInfo.Lanes[J].LaneNo = Global.LaneInfo.SelectedLanes.Item[I]) then
          Global.LaneInfo.Lanes[J].Container.Selected := True;
end;

procedure TBPLaneViewForm.ResizeControl;
var
  LWidth: Integer;
begin
  if not Global.MainMenuResizing then
    DrawLaneLayout;
  LWidth := (panToolBar.Width div LCN_TOOLBTN_COUNT) - 5;
  btnLaneSelectClear.Width := LWidth;
  btnLaneSelectAll.Width := LWidth;
  btnLaneRefresh.Width := LWidth;
  for var I: ShortInt := 1 to Pred(LCN_TOOLBTN_COUNT) do
    TBitBtn(FindComponent('btnGameMenu' + I.ToString)).Width := LWidth;
  panReserveControl.Width := panToolBar.Width - ((btnGameMenu1.Width + 5) * 11) + 5;
end;

procedure TBPLaneViewForm.FirstLaneClick;
var
  P: TPoint;
begin
  GetCursorPos(P);
  try
    SetCursorPos(Self.Left + 300, Self.Top + 100);
    Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  finally
    SetCursorPos(P.X, P.Y);
  end;
end;

procedure TBPLaneViewForm.DoPinSetterOnOff(const AJobName: string; const AValue: Boolean);
var
  LLaneNo, LLaneIndex: ShortInt;
  LResMsg: string;
begin
  try
    if (Global.LaneInfo.SelectedLanes.Count = 0) then
      raise Exception.Create('선택된 레인이 없습니다.');
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('<B>%s</B>', [Global.LaneInfo.SelectedLaneList])) + ' 레인에 ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' 명령을 전송하시겠습니까?' + _BR +
          '대기 상태인 레인은 적용되지 않습니다.', ['예', '아니오']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
    begin
      LLaneNo := Global.LaneInfo.SelectedLanes.Item[I];
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      if (LLaneIndex = -1) or
         (Global.LaneInfo.Lanes[LLaneIndex].LaneStatus = CO_LANE_READY) then
        Continue;
      if not BPDM.SetPinSetter(LLaneNo, AValue, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.DoGameMonitorOnOff(const AJobName: string; const AValue: Boolean);
var
  LLaneNo: ShortInt;
  LResMsg: string;
begin
  try
    if (Global.LaneInfo.SelectedLanes.Count = 0) then
      raise Exception.Create('선택된 레인이 없습니다.');
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('<B>%s</B>', [Global.LaneInfo.SelectedLaneList])) + ' 레인에 ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' 명령을 전송하시겠습니까?' + _BR +
          '대기 상태인 레인은 적용되지 않습니다.', ['예', '아니오']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
    begin
      LLaneNo := Global.LaneInfo.SelectedLanes.Item[I];
      if not BPDM.SetGameMonitor(LLaneNo, AValue, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.DoAssign(const ALaneNo: ShortInt; const AReservedAssignNo: string);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(Self);
  with PM do
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PM.AddParams(CPP_LANE_NO, ALaneNo); //0이면 화면 표시 후 레인 선택
    PM.AddParams(CPP_ASSIGN_NO, AReservedAssignNo); //빈 값이 아니면 예약 수정
    if (PluginManager.OpenModal('BPAssignGame' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK) then
    begin
      SendToMainForm(CPC_GAME_REFRESH_DELAY);
      //SendToMainForm(CPC_GAME_REFRESH_FORCE);

      BPMsgBox(Self.Handle, mtInformation, '알림', '레인 배정 등록이 완료되었습니다.', ['확인'], 5);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure TBPLaneViewForm.DoCancelReservedGame(const AJobName, AAssignNo, AReceiptNo: string; const ALaneNo: ShortInt);
var
  LSQL, LResMsg: string;
  LCount: Integer;
begin
  try
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [ALaneNo]) + ErrorString(AJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    LSQL := Format('SELECT seq FROM TBPayment WHERE receipt_no = %s;', [AReceiptNo.QuotedString]);
    LCount := BPDM.GetABSRecordCount(LSQL, LResMsg);
    if not LResMsg.IsEmpty then
      raise Exception.Create('결제한 내역을 확인할 수 없습니다.' + _BR + LResMsg);
    if (LCount > 0) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림', '취소할 게임/예약의 결제 내역이 존재합니다.' + _BR + '해당 결제 내역을 먼저 취소하여야 합니다.', ['확인'], 5);
      Exit;
    end;
    if not BPDM.CancelGame(ALaneNo, AAssignNo, LResMsg) then
      raise Exception.Create(LResMsg);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.DoLaneControl;
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(Self);
  with PM do
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginID);
    PluginManager.OpenModal('BPLaneControl' + CO_DEFAULT_EXT_PLUGIN, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TBPLaneViewForm.DoLeagueGame(const AJobName: string; const AValue: Boolean);
var
  LLaneNo, LLaneIndex: ShortInt;
  LResMsg: string;
begin
  try
    if (Global.LaneInfo.SelectedLanes.Count = 0) then
      raise Exception.Create('선택된 레인이 없습니다.');
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('<B>%s</B>', [Global.LaneInfo.SelectedLaneList])) + ' 레인을 ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' 모드로 변경하시겠습니까?' + _BR +
          '대기 상태인 레인은 적용되지 않습니다.', ['예', '아니오']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
    begin
      LLaneNo := Global.LaneInfo.SelectedLanes.Item[I];
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      if (LLaneIndex = -1) or
         (Global.LaneInfo.Lanes[LLaneIndex].LaneStatus = CO_LANE_READY) then
        Continue;
      if not BPDM.SetLeagueMode(LLaneNo, AValue, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.DoGameNext(const AJobName: string);
var
  LLaneNo, LLaneIndex: ShortInt;
  LResMsg: string;
begin
  try
    if (Global.LaneInfo.SelectedLanes.Count = 0) then
      raise Exception.Create('선택된 레인이 없습니다.');
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('<B>%s</B>', [Global.LaneInfo.SelectedLaneList])) + ' 레인에 ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' 명령을 전송하시겠습니까?' + _BR +
          '대기 상태인 레인은 적용되지 않습니다.', ['예', '아니오']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
    begin
      LLaneNo := Global.LaneInfo.SelectedLanes.Item[I];
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      if (LLaneIndex = -1) or
         (Global.LaneInfo.Lanes[LLaneIndex].LaneStatus = CO_LANE_READY) then
        Continue;
      if not BPDM.SetGameNext(LLaneNo, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.DoInitLane(const AJobName: string);
var
  LLaneNo, LLaneIndex, LLaneStatus: ShortInt;
  LResMsg: string;
begin
  try
    if (Global.LaneInfo.SelectedLanes.Count = 0) then
      raise Exception.Create('선택된 레인이 없습니다.');
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('<B>%s</B>', [Global.LaneInfo.SelectedLaneList])) + ' 레인에 ' + ErrorString(Format('<B>%s</B>', [AJobName])) + ' 명령을 전송하시겠습니까?' + _BR +
          '대기 상태인 레인은 적용되지 않습니다.', ['예', '아니오']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
    begin
      LLaneNo := Global.LaneInfo.SelectedLanes.Item[I];
      LLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      LLaneStatus := Global.LaneInfo.Lanes[LLaneIndex].LaneStatus;
      if (LLaneIndex = -1) or
         (LLaneStatus = CO_LANE_READY) then
        Continue;

      if (LLaneStatus = CO_LANE_HOLD) and
         (not BPDM.SetHoldLane(LLaneNo, False, LResMsg)) then
        raise Exception.Create(LResMsg);
      if not BPDM.InitLane(LLaneNo, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [AJobName]), ['확인'], 5);
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [AJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.DoChangePaymentType;
var
  LLaneNo: ShortInt;
  LAssignNo, LBowlerId, LBowlerName, LResMsg: string;
begin
  with V1.DataController.DataSet do
  try
    if (RecordCount = 0) or
       (FieldByName('payment_type').AsInteger <> CO_PAYTYPE_DEFERRED) then
      Exit;
    LLaneNo := FieldByName('lane_no').AsInteger;
    LAssignNo := FieldByName('assign_no').AsString;
    LBowlerId := FieldByName('bowler_id').AsString;
    LBowlerName := FieldByName('bowler_nm').AsString;
    LBowlerName := IfThen(LBowlerId = LBowlerName, '', ' ' + LBowlerName);
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('%d 레인 %s %s (%s)', [LLaneNo, LBowlerId, LBowlerName, LAssignNo])) + ' 님을 결제 완료 상태로 변경하시겠습니까?', ['예', '아니오']) <> mrOK) then
      Exit;

    if not BPDM.SetPaymentType(LAssignNo, LBowlerId, CO_PAYTYPE_PREPAID, LResMsg) then
      raise Exception.Create(LResMsg);
    BPMsgBox(Self.Handle, mtInformation, '알림', ErrorString(Format('%d 레인 %s %s (%s)', [LLaneNo, LBowlerId, LBowlerName, LAssignNo])) + ' 님이 결제 완료 상태로 변경되었습니다.', ['확인'], 5);
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '결제 완료 등록에 실패하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.DoAssignListFilter(const AFiltered: Boolean; const ALaneNo: ShortInt);
var
  BM: TBookmark;
begin
  with V1.DataController do
  if AFiltered then
  begin
    try
      Filter.BeginUpdate;
      Filter.Root.Clear;
      Filter.Root.AddItem(V1lane_no, foLike, ALaneNo, ALaneNo.ToString);
      //LAItemList := Filter.Root.AddItemList(fboOr);
      Filter.Root.AddItemList(fboOr);
    finally
      Filter.EndUpdate;
      Filter.Active := True;
      actAssignListAll.Enabled := True;
      V1.Bands[0].Caption := Format('예약 목록 ▶ %d 레인', [ALaneNo]);
      V1.OptionsView.BandHeaders := True;
    end;
  end
  else
  begin
    BM := DataSet.GetBookmark;
    try
      actAssignListAll.Enabled := False;
      V1.OptionsView.BandHeaders := False;
      Filter.Active := False;
      if DataSet.BookmarkValid(BM) then
        DataSet.GotoBookmark(BM);
    finally
      DataSet.FreeBookmark(BM);
    end;
  end;
end;

procedure TBPLaneViewForm.DoPinSettingType(const AValue: ShortInt);
var
  LLaneNo: ShortInt;
  LResMsg: string;
begin
  try
    if (Global.LaneInfo.SelectedLanes.Count = 0) then
      raise Exception.Create('선택된 레인이 없습니다.');
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('<B>%s</B>', [Global.LaneInfo.SelectedLaneList])) + ' 레인에 ' +
          ErrorString(Format('<B>핀 세팅 %d</B>', [AValue])) + ' 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;

    for var I: ShortInt := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
    begin
      LLaneNo := Global.LaneInfo.SelectedLanes.Item[I];
      if not BPDM.SetPinSettingType(LLaneNo, AValue, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('핀 세팅 %d 명령 전송을 완료하였습니다.', [AValue]), ['확인'], 5);
    SendToMainForm(CPC_GAME_REFRESH_FORCE);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', Format('핀 세팅 %d 명령 전송에 실패하였습니다.', [AValue]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneViewForm.LaneSelectCallback(Sender: TObject);
var
  PM: TPluginMessage;
  LIndex: ShortInt;
begin
  with TBPLaneContainer(Sender) do
  try
    LIndex := Global.LaneInfo.SelectedLanes.IndexOf(LaneNo);
    if Selected then
    begin
      if (not ClickWithShift) and
         (Global.LaneInfo.SelectedLanes.Count > 0) then
        for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
          if (Global.LaneInfo.Lanes[I].LaneNo <> LaneNo) then
            Global.LaneInfo.Lanes[I].Container.Selected := False;

      FLaneNoPanels[LaneIndex].Color := CO_COLOR_LANE_NO_SELECT;
      if (LIndex < 0) then
        Global.LaneInfo.SelectedLanes.Add(LaneNo);

      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_LANE_NO;
        PM.AddParams(CPP_VALUE, LaneIndex);
        PM.PluginMessageToID(Global.Plugin.SalePosPluginId);
      finally
        FreeAndNil(PM);
      end;
      if V1.DataController.DataSet.Active then
        V1.DataController.DataSet.Locate('lane_no;assign_status', VarArrayOf([LaneNo, LaneStatus]), [loPartialKey]);
    end
    else
    begin
      FLaneNoPanels[LaneIndex].Color := CO_COLOR_LANE_NO_NORMAL;
      if (LIndex >= 0) then
        Global.LaneInfo.SelectedLanes.Del(LIndex);
    end;
    DoAssignListFilter(True, LaneNo);
  finally
    Global.LaneInfo.SelectedLanes.Sort;
  end;
end;

procedure TBPLaneViewForm.mniGameAssignClick(Sender: TObject);
begin
  if (FPopupLaneStatus = CO_LANE_RESERVED) then
    Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_GAME_ASSIGN, BPDM.QRAssignList.FieldByName('assign_no').AsString)
  else
    Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_GAME_ASSIGN);
end;

procedure TBPLaneViewForm.mniSaleViewClick(Sender: TObject);
begin
  with V1.DataController.DataSet do
  begin
//    Global.LaneInfo.Lanes[Global.LaneInfo.LaneIndex(FieldByName('lane_no').AsInteger)].AssignIndex := FieldByName('assign_index').AsInteger;
    Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_SALE_VIEW);
  end;
end;

procedure TBPLaneViewForm.mniSetChangePaidClick(Sender: TObject);
begin
  DoChangePaymentType;
end;

procedure TBPLaneViewForm.mniScoreEditClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_SCORE_EDIT);
end;

procedure TBPLaneViewForm.mniLaneHoldClick(Sender: TObject);
begin
    {if (Global.LaneInfo.SelectedLanes.Count > 0) then
    for I := 0 to Pred(Global.LaneInfo.SelectedLanes.Count) do
      for J := 0 to Pred(Global.LaneInfo.LaneCount) do
        if (Global.LaneInfo.Lanes[J].LaneNo = Global.LaneInfo.SelectedLanes.Item[I]) then
          Global.LaneInfo.Lanes[J].Container.Selected := True;

          }

  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_LANE_HOLD);
end;

procedure TBPLaneViewForm.mniGameCancelClick(Sender: TObject);
var
  LAssignNo, LReceiptNo: string;
  LLaneNo: ShortInt;
begin
  if (FPopupLaneStatus = CO_LANE_RESERVED) then
  begin
    with V1.DataController.DataSet do
    begin
      LAssignNo := FieldByName('assign_no').AsString;
      LReceiptNo := FieldByName('receipt_no').AsString;
      LLaneNo := FieldByName('lane_no').AsInteger;
    end;
    DoCancelReservedGame(TMenuItem(Sender).Caption, LAssignNo, LReceiptNo, LLaneNo);
  end
  else
    Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_GAME_CANCEL);
end;

procedure TBPLaneViewForm.mniLeagueModeClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_LEAGUE_MODE);
end;

procedure TBPLaneViewForm.mniGameNextClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_GAME_NEXT);
end;

procedure TBPLaneViewForm.mniBowlerPauseClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_BOWLER_PAUSE);
end;

procedure TBPLaneViewForm.mniPinSetterOnClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_PIN_SETTER_ON);
end;

procedure TBPLaneViewForm.mniPinSetterOffClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_PIN_SETTER_OFF);
end;

procedure TBPLaneViewForm.mniMonitorOnClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_MONITOR_ON);
end;

procedure TBPLaneViewForm.mniMonitorOffClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_MONITOR_OFF);
end;

procedure TBPLaneViewForm.mniPinSetting1Click(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_PIN_SETTING_1);
end;

procedure TBPLaneViewForm.mniPinSetting2Click(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_PIN_SETTING_2);
end;

procedure TBPLaneViewForm.mniLaneInitClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_LANE_INIT);
end;

procedure TBPLaneViewForm.mniLaneCheckClick(Sender: TObject);
begin
  Global.LaneInfo.Lanes[FPopupLaneIndex].Container.DoPopupMenu(CO_POPUP_LANE_CHECK);
end;

procedure TBPLaneViewForm.LaneMsgCallback(Sender: TObject; const AMsg: string);
begin
  if not AMsg.IsEmpty then
    BPMsgBox(Self.Handle, mtInformation, '알림', AMsg, ['확인'], 5);
end;

procedure TBPLaneViewForm.LanePopupMenuPopup(Sender: TObject);
var
  LLaneNo, LPaymentType, LDirection: ShortInt;
  LEnabled, LLeagueMode: Boolean;
begin
  FPopupLaneIndex := -1;
  FPopupLaneStatus := -1;
  LPaymentType := -1;
  LDirection := -1;
  LEnabled := False;
  LLeagueMode := False;
  with V1.DataController.DataSet do
  begin
    if (RecordCount > 0) then
    begin
      LLaneNo := FieldByName('lane_no').AsInteger;
      FPopupLaneIndex := Global.LaneInfo.LaneIndex(LLaneNo);
      LPaymentType := FieldByName('payment_type').AsInteger;
      LDirection := FieldByName('direction').AsInteger;
      LEnabled := (FPopupLaneIndex >= 0);
      if LEnabled then
      begin
        FPopupLaneStatus := FieldByName('assign_status').AsInteger;
        LLeagueMode := FieldByName('league_yn').AsBoolean;
      end;
    end;

    mniGameAssign.Enabled := LEnabled;
      mniGameAssign.Caption := IfThen(FPopupLaneStatus = CO_LANE_RESERVED, '예약 게임 수정', '배정 관리');
    mniSaleView.Enabled := LEnabled;
    mniSetChangePaid.Enabled := (LPaymentType = CO_PAYTYPE_DEFERRED);
    mniScoreEdit.Enabled := (FPopupLaneStatus in [CO_LANE_BUSY, CO_LANE_END_UNPAID]);
    mniLaneHold.Enabled := (FPopupLaneStatus in [CO_LANE_READY, CO_LANE_HOLD]);
      mniLaneHold.Caption := '임시 예약' + IfThen(FPopupLaneStatus = CO_LANE_HOLD, ' 취소', '');
    mniGameCancel.Enabled := (FPopupLaneStatus in [CO_LANE_READY, CO_LANE_RESERVED, CO_LANE_BUSY, CO_LANE_END_UNPAID]);
    mniGameCancel.Caption := IfThen(FPopupLaneStatus = CO_LANE_RESERVED, '예약 ', '') + '게임 취소';
    mniLeagueMode.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
      mniLeagueMode.Caption := IfThen(LLeagueMode, ' 오픈', '리그') + ' 게임으로 전환';
    mniGameNext.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY, CO_LANE_END_UNPAID]);
    mniBowlerPause.Enabled := (RecordCount > 0);
    if mniBowlerPause.Enabled then
      mniBowlerPause.Caption := '볼러 일시정지' + IfThen(LDirection = CO_LANE_DIR_PAUESD, ' 해제', '');
    mniLaneControl.Enabled := LEnabled;
    mniPinSetterOn.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
    mniPinSetterOff.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
    mniMonitorOn.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
    mniMonitorOff.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
    mniPinSetting1.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
    mniPinSetting2.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY]);
    mniLaneInit.Enabled := (FPopupLaneStatus in [CO_LANE_RESERVED, CO_LANE_BUSY, CO_LANE_END_UNPAID]);
    mniLaneCheck.Enabled := LEnabled;
    mniLaneCheck.Caption := '레인 점검' + IfThen(FPopupLaneStatus = CO_LANE_MAINTENANCE, ' 해제', '');
  end;
end;

procedure TBPLaneViewForm.OnLaneNoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex, LRow: ShortInt;
  LIsShift: Boolean;
begin
  if (Button in [mbLeft]) then
  begin
    LIsShift := (ssShift in Shift);
    LIndex := TPanel(Sender).Tag;
    if (LIndex > -1) then
    begin
      TPanel(Sender).BeginDrag(False);
      with Global.LaneInfo.Lanes[LIndex].Container do
      begin
        ClickWithshift := LIsShift; //Select Callback Proc에서 처리
        try
          Selected := (not Selected);
        finally
          ClickWithshift := False;
        end;
        LRow := (LaneIndex div FLaneColumns);
        sbxLaneView.VertScrollBar.Position := (LRow * (LCN_LANE_BASE_HEIGHT + LCN_LANE_INTERVAL));
      end;
    end;
  end;
end;

procedure TBPLaneViewForm.OnLaneNoDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TPanel) and
            (Sender is TPanel) and
            (TPanel(Source).Tag <> TPanel(Sender).Tag) and
            ((Global.LaneInfo.Lanes[TPanel(Source).Tag].LaneStatus <> CO_LANE_READY) or
             (Global.LaneInfo.Lanes[TPanel(Sender).Tag].LaneStatus <> CO_LANE_READY));
end;

procedure TBPLaneViewForm.OnLaneNoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  PM: TPluginMessage;
  LSource, LSender: ShortInt;
begin
  LSource := TPanel(Source).Tag; // 현재 테이블의 인덱스
  LSender := TPanel(Sender).Tag; // 대상 테이블의 인덱스
  PM := TPluginMessage.Create(nil);
  try
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_VALUE + '1', LSource);
      PM.AddParams(CPP_VALUE + '2', LSender);
      if (PluginManager.OpenModal('BPLaneMove' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK) then
      begin
      end;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

//게임 상황 새로 고침
procedure TBPLaneViewForm.actGameRefreshExecute(Sender: TObject);
begin
  SendToMainForm(CPC_GAME_REFRESH_FORCE);
end;

//레인 선택 취소
procedure TBPLaneViewForm.actLaneSelectClearExecute(Sender: TObject);
begin
  if (Global.LaneInfo.SelectedLanes.Count > 0) then
    for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
      Global.LaneInfo.Lanes[I].Container.Selected := False;
end;

//전체 레인 선택
procedure TBPLaneViewForm.actLaneSelectAllExecute(Sender: TObject);
begin
  for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
    try
      Global.LaneInfo.Lanes[I].Container.ClickWithShift := True;
      Global.LaneInfo.Lanes[I].Container.Selected := True;
    finally
      Global.LaneInfo.Lanes[I].Container.ClickWithShift := False;
    end;
end;

//배정 목록 새로 고침
procedure TBPLaneViewForm.actAssignRefreshExecute(Sender: TObject);
var
  LResult: Boolean;
  LResMsg: string;
begin
  LResult := False;
  try
    Screen.Cursor := crSQLWait;
    LResult := BPDM.RefreshAssignList(LResMsg);
  finally
    Screen.Cursor := crDefault;
    if not LResult then
      BPMsgBox(Self.Handle, mtError, '알림', '배정 목록을 조회할 수 없습니다.' + _BR + ErrorString(LResMsg), ['확인'], 5);
  end;
end;

//배정 목록 필터 해제
procedure TBPLaneViewForm.actAssignListAllExecute(Sender: TObject);
begin
  DoAssignListFilter(False);
end;

//핀 세터 On
procedure TBPLaneViewForm.actPinSetterOnExecute(Sender: TObject);
begin
  DoPinSetterOnOff(TAction(Sender).Caption, True);
end;

//핀 세터 Off
procedure TBPLaneViewForm.actPinSetterOffExecute(Sender: TObject);
begin
  DoPinSetterOnOff(TAction(Sender).Caption, False);
end;

//모니터 On
procedure TBPLaneViewForm.actMonitorOnExecute(Sender: TObject);
begin
  DoGameMonitorOnOff(TAction(Sender).Caption, True);
end;

//모니터 Off
procedure TBPLaneViewForm.actMonitorOffExecute(Sender: TObject);
begin
  DoGameMonitorOnOff(TAction(Sender).Caption, False);
end;

//레인 배정
procedure TBPLaneViewForm.actLaneAssignExecute(Sender: TObject);
begin
  DoAssign(0);
end;

//레인 제어
procedure TBPLaneViewForm.actLaneControlExecute(Sender: TObject);
begin
  DoLaneControl;
end;

//오픈 게임
procedure TBPLaneViewForm.actOpenGameExecute(Sender: TObject);
begin
  DoLeagueGame(TAction(Sender).Caption, False);
end;

//리그 게임
procedure TBPLaneViewForm.actLeagueGameExecute(Sender: TObject);
begin
  DoLeagueGame(TAction(Sender).Caption, True);
end;

//게임 넥스트
procedure TBPLaneViewForm.actGameNextExecute(Sender: TObject);
begin
  DoGameNext(TAction(Sender).Caption);
end;

//레인 초기화
procedure TBPLaneViewForm.actLaneClearExecute(Sender: TObject);
begin
  DoInitLane(TAction(Sender).Caption);
end;

//핀 세팅 1
procedure TBPLaneViewForm.actPinSetting1Execute(Sender: TObject);
begin
  DoPinSettingType(1);
end;

//핀 세팅 2
procedure TBPLaneViewForm.actPinSetting2Execute(Sender: TObject);
begin
  DoPinSettingType(2);
end;

//대회 관리
procedure TBPLaneViewForm.actRallyModeExecute(Sender: TObject);
begin
  ShowRallyMode(Self.PluginID);
end;

//거래 내역 조회
procedure TBPLaneViewForm.actReceiptListExecute(Sender: TObject);
begin
  ShowReceiptView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

procedure TBPLaneViewForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    panMiniMap.SetFocus;
  finally
    Free;
  end;
end;

procedure TBPLaneViewForm.sbxLaneViewMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  SendMessage(TScrollBox(Sender).Handle, WM_VSCROLL, IfThen(WheelDelta >= 0, SB_LINELEFT, SB_LINERIGHT), 0);
  Handled := True;
end;

procedure TBPLaneViewForm.G1Enter(Sender: TObject);
begin
  FScrollBoxPageControl := False;
end;

procedure TBPLaneViewForm.G1Exit(Sender: TObject);
begin
  FScrollBoxPageControl := True;
end;

procedure TBPLaneViewForm.SetBaseTitle(const AValue: string);
begin
  FBaseTitle := AValue;
  Global.Title := FBaseTitle;
end;

{ TLaneNoPanel }

constructor TLaneNoPanel.Create(const AIndex: ShortInt; AOwner: TComponent; AParent: TWinControl);
begin
  inherited Create(AOwner);

  FLaneStatus := CO_LANE_READY;

  Self.AutoSize := False;
  Self.Caption := Global.LaneInfo.Lanes[AIndex].LaneNo.ToString;
  Self.Cursor := crHandPoint;
  Self.Tag := AIndex;
  Self.Height := 40;
  Self.Width := 40;
  Self.BevelOuter := bvNone;
  Self.AlignWithMargins := True;
  Self.Color := CO_COLOR_LANE_NO_NORMAL;
  Self.Margins.Left := 0;
  Self.Margins.Right := IfThen(Odd(Global.LaneInfo.Lanes[AIndex].LaneNo), 1, 5);
  Self.Margins.Top := 5;
  Self.Margins.Bottom := 0;
  Self.Font.Color := clWhite;
  Self.Font.Size := 14;
  Self.Font.Style := [fsBold];
  Self.StyleElements := [];
  Self.Align := alLeft;
  Self.Left := (Self.Width + Self.Margins.Right + 100) * AIndex;
  Self.Parent := AParent;
  Self.ShowHint := True;
  Self.Hint := '대기';

  StatusPanel := TPanel.Create(AOwner);
  with StatusPanel do
  begin
    Caption := '';
    Tag := AIndex;
    Height := 5;
    BevelOuter := bvNone;
    Color := CO_LANE_READY;
    StyleElements := [];
    Parent := Self;
    Align := alBottom;
    Visible := False;
  end;
end;

destructor TLaneNoPanel.Destroy;
begin

  inherited;
end;

procedure TLaneNoPanel.SetLaneStatus(const AValue: Shortint);
begin
  if (FLaneStatus <> AValue) then
  begin
    FLaneStatus := AValue;
    Self.Hint := GetLaneStatusName(FLaneStatus);
    StatusPanel.Color := GetLaneStatusColor(FLaneStatus);
    StatusPanel.Visible := (FLaneStatus <> CO_LANE_READY);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPLaneViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
