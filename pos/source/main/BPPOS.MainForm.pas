(* ******************************************************************************

  Project     : 볼링장 POS 시스템
  Title       : 메인 폼
  Author      : Lee, Sun-Woo
  Description :
  History     :
  Version   Date         Remark
  --------  ----------   -----------------------------------------------------
  1.0.0.0   2022-09-21   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

  ****************************************************************************** *)
unit BPPOS.MainForm;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Data.DB,
  Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ActnList,
  Vcl.WinXCtrls, Vcl.CategoryButtons, System.Actions, Vcl.Imaging.pngimage, Vcl.Grids, Vcl.DBGrids,
  { Solbi VCL }
  BMDThread, LEDFontNum, cyBaseLed, cyLed;

{$I ..\common\Common.BPCommon.inc}

const
  LC_THRED_INTERVAL = 30000; //30초

  LC_BASE_WIDTH  = 1920;
  LC_BASE_HEIGHT = 1080;

  LC_IDX_USER    = 0;
  LC_IDX_SALES   = 1;
  LC_IDX_PARTNER = 2;
  LC_IDX_SYSTEM  = 3;
  LC_IDX_MISC    = 4;

type
  TBPMainForm = class(TForm)
    tmrRunOnce: TTimer;
    panHeader: TPanel;
    panHeaderToolBar: TPanel;
    btnAppClose: TSpeedButton;
    panFooter: TPanel;
    lblPosInfo: TLabel;
    btnWindowSize: TSpeedButton;
    spvLogView: TSplitView;
    btnLogView: TSpeedButton;
    lbxLogView: TListBox;
    panLogViewTitle: TPanel;
    catMainMenu: TCategoryButtons;
    panPluginContainer: TPanel;
    spvMainMenu: TSplitView;
    panScoreboard: TPanel;
    ledBusyCount: TLEDFontNum;
    ledReservedCount: TLEDFontNum;
    ledStoreEndTime: TLEDFontNum;
    lblStoreEndTime: TLabel;
    lblReservedCount: TLabel;
    lblBusyCount: TLabel;
    panMainMenu: TPanel;
    btnMainMenu: TSpeedButton;
    ledLocalDB: TcyLed;
    ledGameServerDB: TcyLed;
    ledGameServer: TcyLed;
    ledPartnerCenter: TcyLed;
    ledUserLogin: TcyLed;
    aclMainMenu: TActionList;
    actLaneView: TAction;
    actSalePos: TAction;
    actPartnerCenter: TAction;
    actOrdersReport: TAction;
    actMemberInfoSearch: TAction;
    actLockerView: TAction;
    actLocalSetting: TAction;
    actSystemSetting: TAction;
    actMasterReceive: TAction;
    actCardReaderVerify: TAction;
    actRunAdminCall: TAction;
    actTestAdminCall: TAction;
    actWakeOnLan: TAction;
    actNoticeView: TAction;
    actEdgeUpdate: TAction;
    actLogin: TAction;
    actReboot: TAction;
    actShutdown: TAction;
    actMainMenu: TAction;
    actLogView: TAction;
    actWindowSize: TAction;
    actAppClose: TAction;
    actRemoteSupport: TAction;
    actReceiptList: TAction;
    actWeatherView: TAction;
    panTableView: TPanel;
    grdTableView: TDBGrid;
    dsrTableView: TDataSource;
    panTableViewTitle: TPanel;
    panTableViewToolbar: TPanel;
    cbxTableList: TComboBox;
    btnTableRefresh: TButton;
    actMember: TAction;
    lblClockInfo: TLabel;
    panVersion: TPanel;
    lblAppVersion: TLabel;
    imgMainLogo: TImage;
    imgLogo: TImage;
    ledLaneStatus: TcyLed;
    panLaneStatusLegend: TPanel;
    panStatusReserved: TPanel;
    panStatusHold: TPanel;
    panStatusBusy: TPanel;
    lblReadyCount: TLabel;
    ledReadyCount: TLEDFontNum;
    panStatusSelect: TPanel;
    sptLogView: TSplitter;
    tmrRefreshDelay: TTimer;
    panStatusMaintenance: TPanel;
    actRallyMode: TAction;
    ThreadGroup: TBMDThreadGroup;
    ThreadAssignList: TBMDThread;
    ThreadLaneStatus: TBMDThread;
    ledAssignList: TcyLed;
    ThreadSaleList: TBMDThread;
    ledSaleList: TcyLed;
    actDeleteView: TAction;

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);

    procedure RefreshLogoImage;
    procedure ActionControl(const AEnabled: Boolean);

    procedure OnHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnHeaderDblClick(Sender: TObject);

    procedure tmrRunOnceTimer(Sender: TObject);
    procedure tmrRefreshDelayTimer(Sender: TObject);
    procedure btnTableRefreshClick(Sender: TObject);

    procedure spvMainMenuClosing(Sender: TObject);
    procedure spvMainMenuOpening(Sender: TObject);
    procedure spvMainMenuClosed(Sender: TObject);
    procedure spvMainMenuOpened(Sender: TObject);

    procedure actMainMenuExecute(Sender: TObject);
    procedure actLogViewExecute(Sender: TObject);
    procedure actWindowSizeExecute(Sender: TObject);
    procedure actAppCloseExecute(Sender: TObject);

    procedure actLoginExecute(Sender: TObject);
    procedure actRebootExecute(Sender: TObject);
    procedure actShutdownExecute(Sender: TObject);

    procedure actLaneViewExecute(Sender: TObject);
    procedure actSalePosExecute(Sender: TObject);
    procedure actLockerViewExecute(Sender: TObject);

    procedure actPartnerCenterExecute(Sender: TObject);
    procedure actOrdersReportExecute(Sender: TObject);
    procedure actMemberInfoSearchExecute(Sender: TObject);

    procedure actLocalSettingExecute(Sender: TObject);
    procedure actSystemSettingExecute(Sender: TObject);
    procedure actMasterReceiveExecute(Sender: TObject);
    procedure actCardReaderVerifyExecute(Sender: TObject);
    procedure actRunAdminCallExecute(Sender: TObject);
    procedure actTestAdminCallExecute(Sender: TObject);
    procedure actWakeOnLanExecute(Sender: TObject);

    procedure actNoticeViewExecute(Sender: TObject);
    procedure actEdgeUpdateExecute(Sender: TObject);
    procedure actRemoteSupportExecute(Sender: TObject);
    procedure actWeatherViewExecute(Sender: TObject);
    procedure actReceiptListExecute(Sender: TObject);
    procedure actMemberExecute(Sender: TObject);
    procedure actRallyModeExecute(Sender: TObject);

    procedure ThreadGroupTerminate(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadGroupThreadStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadGroupThreadTerminate(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadAssignListStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadAssignListExecute(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadLaneStatusStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadLaneStatusExecute(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadSaleListStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadSaleListExecute(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure actDeleteViewExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FIsFirst: Boolean;
    FMaxWindow: Boolean;
    FUserLogged: Boolean;
    FTryConnecting: Boolean;
    FPartnerCenterLoaded: Boolean;
    FStartUrl: string;
    FNoticeUrl: string;
    FThreadSaleDetailOnly: Boolean;

    procedure OnIdleProc(Sender: TObject; var ADone: Boolean);
    procedure AssignListSyncProc(Sender: TObject);
    procedure LaneStatusSyncProc(Sender: TObject);
    procedure SaleListSyncProc(Sender: TObject);

    procedure StartUp;
    function DoAuthorize(var AResMsg: string): Boolean;
    function DoMasterDownload(var AResMsg: string): Boolean;
    procedure DoLogin;
    procedure DoCardReaderVerify;
    function DoLocalSetting: Boolean;
    function DoSystemSetting: Boolean;
    procedure DoShutdown(const AReboot: Boolean);
    procedure OnMessageCallback(const ACommand: string; const AValue: Variant);
    procedure OnExceptionDlgCallback(Sender: TObject);

    procedure SetUserLogged(const AValue: Boolean);
    procedure SetMaxWindow(const AValue: Boolean);
  public
    { Public declarations }
    property UserLogged: Boolean read FUserLogged write SetUserLogged default False;
    property MaxWindow: Boolean read FMaxWindow write SetMaxWindow default False;
  end;

var
  BPMainForm: TBPMainForm;

implementation

uses
  { Native }
  Winapi.ShlObj, Winapi.ActiveX, System.Win.ComObj, System.DateUtils, System.StrUtils, Vcl.Dialogs,
  System.Variants,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPReceiptPrint, Common.BPCommonLib, Common.BPMsgBox,
  Common.BPInputBox, Common.ExceptDlg.VCL;

{$R *.dfm}

procedure MyAssertProc(const AMessage, AFilename: string; ALineNumber: Integer; PErrorAddr: Pointer);
begin
//  OutputDebugString(PChar(Format('[A:%s, L:%d] %s', [String(PErrorAddr^), ALineNumber, AMessage])));
  OutputDebugString(PChar(Format('(%d) %s', [ALineNumber, AMessage])));
end;

{ TBPMainForm }

procedure TBPMainForm.OnIdleProc(Sender: TObject; var ADone: Boolean);
begin
  ADone := UserLogged and (MilliSecondsBetween(Global.AppOnIdleLast, Now) > LC_THRED_INTERVAL);
  if ADone then
  begin
    Global.AppOnIdleLast := Now;
    Global.AppOnIdle := True;
    ThreadGroup.Start;
  end;
end;

procedure TBPMainForm.FormCreate(Sender: TObject);
var
{$IFDEF RELEASE}
  sLinkFile: string;
  hIObject: IUnknown;
  hISLink: IShellLink;
  hIPFile: IPersistFile;
{$ENDIF}
  RS: TResourceStream;
  HC: HCURSOR;
begin
  inherited;

  FIsFirst := True;
  Global.AppInfo.Handle := Self.Handle;
  Global.AppInfo.PluginContainer := panPluginContainer;
  Global.MainFormCallbackProc := OnMessageCallback;
  Global.BaseTitle := panHeader.Caption;
  Global.Log.ListBox := Self.lbxLogView;
  ExceptionDlgCallbackProc := OnExceptionDlgCallback;

  { Using Animation Type Cursor }
  RS := TResourceStream.Create(MainInstance, 'BowlingPick_HourGlass', 'ANICURSOR');
  try
    HC := CreateIconFromResourceEx(RS.Memory, RS.Size, False, $30000, 100, 100, LR_DEFAULTCOLOR);
    {$WARN SYMBOL_PLATFORM OFF}
    Win32Check(HC <> 0);
    {$WARN SYMBOL_PLATFORM ON}
    Screen.Cursors[crSQLWait] := HC;
  finally
    RS.Free;
  end;
  Screen.Cursors[crDrag] := LoadCursor(HInstance, 'BowlingPick_DragDrop');

{$IFDEF RELEASE}
  sLinkFile := GetSysDir(CSIDL_DESKTOP) + '\볼링픽 POS.lnk';
  if not FileExists(sLinkFile) then
  begin
    hIObject := CreateComObject(CLSID_ShellLink);
    hISLink := hIObject as IShellLink;
    hIPFile := hIObject as IPersistFile;
    with hISLink do
    begin
      // SetArguments('/run');
      // SetPath(PChar(GetSysDir(36) + '실행파일명'));
      // SetWorkingDirectory(PChar(GetSysDir(36)));
      SetArguments('/run');
      SetPath(PChar(Global.DirInfo.HomeDir + 'BPLauncher.exe'));
      SetWorkingDirectory(PChar(Global.DirInfo.HomeDir));
    end;
    hIPFile.Save(PChar(sLinkFile), False);
  end;
  sptLogView.Visible := False;
  panTableView.Visible := False;
{$ELSE}
  for var I: Integer := 0 to Pred(BPDM.ComponentCount) do
    if BPDM.Components[I] is TDataSet then
      cbxTableList.Items.Add(BPDM.Components[I].Name);
  cbxTableList.Sorted := True;
{$ENDIF}
  SetDoubleBuffered(Self, True);
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0, nil, 0);
  if Global.Config.HideTaskBar then
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_HIDE);
  if FileExists(Global.Log.LogFileName) then
    Self.lbxLogView.Items.LoadFromFile(Global.Log.LogFileName);

  FStartUrl := 'file://' + ExpandFileName(Global.DirInfo.ContentsDir) + 'index.html';
  FPartnerCenterLoaded := False;
  FTryConnecting := False;
  FThreadSaleDetailOnly := False;

  Self.Left := Global.Config.BaseLeft;
  Self.Top := Global.Config.BaseTop;
  Self.Width := LC_BASE_WIDTH;
  Self.Height := LC_BASE_HEIGHT;

  MakeRoundedControl(panScoreboard, 5, 5);
  panPluginContainer.ShowCaption := False;
  spvMainMenu.Visible := False;
  panPluginContainer.Visible := False;
  panPluginContainer.Align := alClient;
  spvLogView.Opened := False;
  lblPosInfo.Caption := '';

  lblReadyCount.Font.Color := CO_COLOR_LANE_READY;
  ledReadyCount.LightColor := CO_COLOR_LANE_READY;
  lblReservedCount.Font.Color := CO_COLOR_LANE_RESERVED;
  ledReservedCount.LightColor := CO_COLOR_LANE_RESERVED;
  lblBusyCount.Font.Color := CO_COLOR_LANE_BUSY;
  ledBusyCount.LightColor := CO_COLOR_LANE_BUSY;

  panStatusSelect.Color := CO_COLOR_LANE_NO_SELECT;
  panStatusSelect.Font.Color := InvertColor2(panStatusSelect.Color);
  panStatusHold.Color := CO_COLOR_LANE_HOLD;
  panStatusHold.Font.Color := InvertColor2(panStatusHold.Color);
  panStatusReserved.Color := CO_COLOR_LANE_RESERVED;
  panStatusReserved.Font.Color := InvertColor2(panStatusReserved.Color);
  panStatusBusy.Color := CO_COLOR_LANE_BUSY;
  panStatusBusy.Font.Color := InvertColor2(panStatusBusy.Color);
  panStatusMaintenance.Color := CO_COLOR_LANE_MAINTENANCE;
  panStatusMaintenance.Font.Color := InvertColor2(panStatusMaintenance.Color);

  ThreadAssignList.ThreadGroup := ThreadGroup;
  ThreadLaneStatus.ThreadGroup := ThreadGroup;

  with Global.AppInfo do
  begin
    ProductVersion := GetAppVersion(8);
    FileVersion := GetAppVersion(2);
    lblAppVersion.Caption := Format('버전 %s(%s)', [ProductVersion, FileVersion]);
  end;
  with catMainMenu do
    for var I: ShortInt := 1 to Pred(Categories.Count) do
      Categories[I].Collapsed := True;

  ActionControl(False);
  Application.OnIdle := OnIdleProc;

  UpdateLog('프로그램 시작');
  tmrRefreshDelay.Interval := 3000;
  tmrRunOnce.Enabled := True;
end;

procedure TBPMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (BPMsgBox(Self.Handle, mtConfirmation, '확인', '프로그램을 종료하시겠습니까?', ['예', '아니오']) = mrOk);
end;

procedure TBPMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ThreadGroup.Stop;
end;

procedure TBPMainForm.FormDestroy(Sender: TObject);
begin
  ShowCursor(True);
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 1, nil, 0);
  ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_SHOW);
  UpdateLog('프로그램 종료');
end;

procedure TBPMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      if UserLogged then
      begin
        if (Global.Plugin.ActivePluginId = Global.Plugin.SalePosPluginId) then
          actLaneView.Execute;
      end;
  end;
end;

procedure TBPMainForm.FormResize(Sender: TObject);
begin
  RefreshLogoImage;
end;

procedure TBPMainForm.StartUp;
label
  GO_GAME_DB_RECONNECT;
var
  LLocalDB, LTempDB, LResMsg: string;
  LDBRetry: Boolean;
begin
  if Assigned(Global.BaseTimer) and
     (not Global.BaseTimer.Started) then
    Global.BaseTimer.Start;

  RefreshLogoImage;
  spvMainMenu.Visible := True;
  panPluginContainer.Visible := True;
  try
    try
      Screen.Cursor := crSQLWait;
      ShowWebView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer, Global.BaseTitle, FStartUrl);
      LLocalDB := Global.DirInfo.DataDir + Global.AppInfo.AppName + '.db';

      if not BPDM.OpenABSDatabase(LLocalDB, LResMsg) then
      begin
        UpdateLog(Format('로컬 데이터베이스 에러 = %s', [LResMsg]));
        //템플리트 파일로 DB 복구 시작
        LTempDB := Global.DirInfo.DataDir + Global.AppInfo.AppName + '_Template.db';
        if not FileExists(LTempDB) then
        begin
          SendToMainForm(CPC_MAIN_STATUS, CMP_LOCAL_DB_OFF);
          raise Exception.Create(Format('로컬 데이터베이스 파일(%s)을 찾을 수 없습니다.', [LTempDB]));
        end;

        //이전 파일 백업
        CopyFile(PChar(LLocalDB), PChar(Format(Global.DirInfo.DataDir + Global.AppInfo.AppName + '_%s.db', [Global.DateTime.CurrentDate])), False);
        //템플리트 파일로부터 새 DB 생성
        CopyFile(PChar(LTempDB), PChar(LLocalDB), False);
        //재접속 시도
        if not BPDM.OpenABSDatabase(LLocalDB, LResMsg) then
        begin
          SendToMainForm(CPC_MAIN_STATUS, CMP_LOCAL_DB_OFF);
          raise Exception.Create(LResMsg);
        end;

        UpdateLog('로컬 데이터베이스 복구 완료');
      end;

      if not BPDM.CreateABSMemTable(LResMsg) then
        raise Exception.Create(LResMsg);
      SendToMainForm(CPC_MAIN_STATUS, CMP_LOCAL_DB_ON);
    finally
      Screen.Cursor := crDefault;
    end;

    DoCardReaderVerify;
    if not ActivateCkDLL(LResMsg) then
      raise Exception.Create('필수 DLL 구성요소 로드에 실패했습니다.<BR>' + LResMsg);
    if not DoAuthorize(LResMsg) then
      raise Exception.Create(LResMsg);
    if not DoMasterDownload(LResMsg) then
      raise Exception.Create(LResMsg);

    //************
    GO_GAME_DB_RECONNECT:
    //************
    LDBRetry := False;
    //프런트POS일 경우에만
    if (Global.TerminalInfo.SaleZoneCode = CO_SALEZONE_POS_FRONT) then
    begin
      //게임 서버 접속
      Screen.Cursor := crSQLWait;
      Application.ProcessMessages;
      try
        try
          if not BPDM.MariaDB.Connected then
          begin
            BPDM.MariaDB.Options.LocalFailover := True;
            BPDM.MariaDB.Connected := True;
          end;
        finally
          Screen.Cursor := crDefault;
        end;
      except
        on E: Exception do
          if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('게임서버 데이터베이스(%s,%d)에 접속할 수 없습니다.', [Global.GameServer.DBHost, Global.GameServer.DBPort]) + _BR +
                '접속을 재시도하시겠습니까?', ['예', '아니오']) = mrOK) then
            LDBRetry := True
          else
            raise Exception.Create(E.Message);
      end;
    end;

    if LDBRetry then
      goto GO_GAME_DB_RECONNECT;

    //영수증 프린터 출력 클래스
    if not Assigned(Global.ReceiptPrint) then
      Global.ReceiptPrint := TReceiptPrint.Create(dtPos);

    //알리미 실행
    if Global.AdminCall.AutoRun then
      actRunAdminCall.Execute;

    DoLogin;
  except
    on E: Exception do
    begin
      UpdateLog(Format('MainForm.StartUp.Exception = %s', [E.Message]));
      BPMsgBox(Self.Handle, mtError, '알림', '장애가 발생하여 프로그램을 시작할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
    end;
  end;
end;

function TBPMainForm.DoAuthorize(var AResMsg: string): Boolean;
var
  LToken: string;
begin
  Result := False;
  AResMsg := '';
  try
    Screen.Cursor := crSQLWait;
    try
      if not BPDM.GetToken(Global.PartnerCenter.Host, Global.PartnerCenter.TerminalId, Global.PartnerCenter.SecretKey, LToken, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.PartnerCenter.OAuthToken := LToken;
      Global.PartnerCenter.Authorized := True;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      if Result then
        SendToMainForm(CPC_MAIN_STATUS, CMP_PARTNER_CENTER_ON)
      else
        SendToMainForm(CPC_MAIN_STATUS, CMP_PARTNER_CENTER_OFF);
    end;
  except
    on E: Exception do
      AResMsg := '파트너센터 접속에 실패하였습니다.' + _BR + E.Message;
  end;
end;

function TBPMainForm.DoMasterDownload(var AResMsg: string): Boolean;
begin
  Result := False;
  AResMsg := '';
  if Global.MasterUpdated.Downloaded then
  begin
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
        '마스터 수신 작업을 다시 하시겠습니까?' + _BR + '작업이 시작되면 로그아웃 상태로 전환됩니다.', ['예', '아니오']) <> mrOk) then
      Exit(True);
    UserLogged := False;
  end;

  try
    Screen.Cursor := crSQLWait;
    try
      if (PluginManager.OpenModal('BPPrepare' + CO_DEFAULT_EXT_PLUGIN) <> mrOK) then
        raise Exception.Create(Global.PartnerCenter.ErrorText);
      Result := True;
    finally
      Screen.Cursor := crDefault;
      Global.MasterUpdated.Downloaded := Result;
    end;
  except
    on E: Exception do
      AResMsg := '마스터 수신 작업에 실패하였습니다.' + _BR + E.Message;
  end;
end;

procedure TBPMainForm.DoLogin;
var
  LResMsg: string;
begin
  if UserLogged then
  begin
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', '로그아웃 하시겠습니까?', ['예', '아니오']) = mrOk) then
    begin
      UserLogged := False;
      SendToMainForm(CPC_MAIN_STATUS, CMP_USER_LOG_OFF);
    end;
  end
  else
  begin
    try
      if (Global.TerminalInfo.SaleZoneCode = CO_SALEZONE_POS_FRONT) and
         not BPDM.MariaDB.Connected then
        raise Exception.Create('게임서버 데이터베이스에 연결되지 않았습니다.');
//      if not DoAuthorize(LResMsg) then
//        raise Exception.Create(LResMsg);
      if (PluginManager.OpenModal('BPLogin' + CO_DEFAULT_EXT_PLUGIN) = mrOK) then
      begin
        UserLogged := BPDM.CheckLogin(Global.UserInfo.UserId, Global.UserInfo.TerminalPwd, Global.UserInfo.SaveId, LResMsg);
        if UserLogged then
        begin
          if (Global.Config.LastNoticeDate <> Global.DateTime.CurrentDate) then
            actNoticeView.Execute;
        end
        else
        begin
          SendToMainForm(CPC_MAIN_STATUS, CMP_USER_LOG_OFF);
          raise Exception.Create(LResMsg);
        end;
        SendToMainForm(CPC_MAIN_STATUS, CMP_USER_LOG_ON)
      end;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', ErrorString(E.Message), ['확인'], 5);
    end;
  end;
end;

procedure TBPMainForm.DoCardReaderVerify;
var
  LResMsg: string;
begin
  if Global.ICCardReader.Enabled and
     (not BPDM.GetICReaderVerify(LResMsg)) then
    BPMsgBox(Self.Handle, mtError, '알림', LResMsg, ['확인'], 5);
end;

function TBPMainForm.DoLocalSetting: Boolean;
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Global.AppInfo.Handle);
    Result := (PluginManager.OpenModal('BPSettingLocal' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOk);
  finally
    FreeAndNil(PM);
  end;
end;

function TBPMainForm.DoSystemSetting: Boolean;
var
  PM: TPluginMessage;
begin
  Result := False;
  with TBPInputBoxForm.Create(nil) do
  try
    Title := '관리자 확인';
    MessageText := '시스템 설정 변경은 관리자 권한입니다.' + _CRLF + '인가된 비밀번호를 입력하여 주십시오.';
    PasswordMode := True;
    if (ShowModal <> mrOk) then
      Exit;
    if (InputText <> Copy(Global.DateTime.CurrentDate, 5, 4)) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림', '비밀번호가 일치하지 않습니다.', ['확인'], 5);
      Exit;
    end;
  finally
    Free;
  end;

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Global.AppInfo.Handle);
    Result := (PluginManager.OpenModal('BPSetting' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOk);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TBPMainForm.RefreshLogoImage;
begin
  imgMainLogo.Visible := True;
  imgMainLogo.Top := (Self.Height div 2) - (imgMainLogo.Height div 2);
  imgMainLogo.Left := (Self.Width div 2) - (imgMainLogo.Width div 2);
  if spvMainMenu.Opened then
    imgMainLogo.Left := imgMainLogo.Left + (spvMainMenu.Width div 2);
end;

procedure TBPMainForm.DoShutdown(const AReboot: Boolean);
var
  LJobName: string;
begin
  LJobName := IfThen(AReboot, '재시작', '전원 끄기');
  if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
        '프로그램을 닫고 ' + ErrorString(LJobName) + '을(를) 진행하시겠습니까?' + _BR +
        '저장하지 않은 데이터는 복구되지 않으니 유의하여 주십시오.', ['예', '아니오']) = mrOk) then
    SystemShutdown(0, True, AReboot);
end;

procedure TBPMainForm.btnTableRefreshClick(Sender: TObject);
begin
  if (cbxTableList.ItemIndex < 0) then
    Exit;
  dsrTableView.DataSet := TDataSet(BPDM.FindComponent(cbxTableList.Items[cbxTableList.ItemIndex]));
  if not dsrTableView.DataSet.Active then
    dsrTableView.DataSet.Active := True;
end;

procedure TBPMainForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    StartUp;
  finally
    Free;
  end;
end;

procedure TBPMainForm.tmrRefreshDelayTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  ThreadGroup.Start;
end;

procedure TBPMainForm.OnHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPMainForm.OnHeaderDblClick(Sender: TObject);
begin
  MaxWindow := not MaxWindow;
end;

procedure TBPMainForm.spvMainMenuClosed(Sender: TObject);
begin
  Global.MainMenuResizing := False;
  SendToPlugin(CPC_RESIZE, Global.Plugin.LaneViewPluginId);
  SendToPlugin(CPC_RESIZE, Global.Plugin.SalePosPluginId);
end;

procedure TBPMainForm.spvMainMenuClosing(Sender: TObject);
begin
  Global.MainMenuResizing := True;
end;

procedure TBPMainForm.spvMainMenuOpened(Sender: TObject);
begin
  Global.MainMenuResizing := False;
  SendToPlugin(CPC_RESIZE, Global.Plugin.LaneViewPluginId);
  SendToPlugin(CPC_RESIZE, Global.Plugin.SalePosPluginId);
end;

procedure TBPMainForm.spvMainMenuOpening(Sender: TObject);
begin
  Global.MainMenuResizing := True;
end;

{ 메인 메뉴 }
procedure TBPMainForm.actMainMenuExecute(Sender: TObject);
begin
  with spvMainMenu do
    Opened := not Opened;
  RefreshLogoImage;
end;

{ 로그 보기 }
procedure TBPMainForm.actLogViewExecute(Sender: TObject);
begin
  with spvLogView do
    Opened := not Opened;
end;

{ 화면 크기 }
procedure TBPMainForm.actWindowSizeExecute(Sender: TObject);
begin
  MaxWindow := not MaxWindow;
end;

{ 프로그램 종료 }
procedure TBPMainForm.actAppCloseExecute(Sender: TObject);
begin
  Self.Close;
end;

{ 로그인 }
procedure TBPMainForm.actLoginExecute(Sender: TObject);
begin
  DoLogin;
end;

{ 시스템 재시작 }
procedure TBPMainForm.actRebootExecute(Sender: TObject);
begin
  DoShutdown(True);
end;

{ 시스템 종료 }
procedure TBPMainForm.actShutdownExecute(Sender: TObject);
begin
  DoShutdown(False);
end;

{ 배정 관리 }
procedure TBPMainForm.actLaneViewExecute(Sender: TObject);
begin
  ShowLaneView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

{ 판매 관리 }
procedure TBPMainForm.actSalePosExecute(Sender: TObject);
begin
  ShowSalePos(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

{ 대회 관리 }
procedure TBPMainForm.actRallyModeExecute(Sender: TObject);
begin
  ShowRallyMode(Global.AppInfo.Handle);
end;

{ 회원 관리 }
procedure TBPMainForm.actMemberExecute(Sender: TObject);
begin
  ShowMemberPopup(Global.AppInfo.Handle, '', 0, CO_DATA_MODE_LIST, CO_SEARCH_MEMBER_NAME, '');
end;

{ 라커 관리 }
procedure TBPMainForm.actLockerViewExecute(Sender: TObject);
begin
  ShowLockerView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

{ 거래 내역 조회 }
procedure TBPMainForm.actReceiptListExecute(Sender: TObject);
begin
  if UserLogged then
    ShowReceiptView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

{ 파트너 센터 - 홈 }
procedure TBPMainForm.actPartnerCenterExecute(Sender: TObject);
begin
  if UserLogged then
    ShowPartnerCenter(Global.AppInfo.Handle, Global.AppInfo.PluginContainer, '파트너센터 - 홈', 'main')
  else
    ShowWebView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer, Global.BaseTitle, FStartUrl);
end;

{ 파트너 센터 - 매출 현황 }
procedure TBPMainForm.actOrdersReportExecute(Sender: TObject);
begin
  if UserLogged then
    ShowPartnerCenter(Global.AppInfo.Handle, Global.AppInfo.PluginContainer, '파트너센터 - 매출 현황', 'sales/ordersList')
end;

{ 파트너 센터 - 회원 정보 검색 }
procedure TBPMainForm.actMemberInfoSearchExecute(Sender: TObject);
begin
  if UserLogged then
    ShowPartnerCenter(Global.AppInfo.Handle, Global.AppInfo.PluginContainer, '파트너센터 - 회원 검색', 'member/memberList')
end;

{ 사용자 설정 }
procedure TBPMainForm.actLocalSettingExecute(Sender: TObject);
begin
  if DoLocalSetting then
    BPMsgBox(Self.Handle, mtInformation, '알림', '변경된 일부 설정값은 프로그램을 재시작 하여야 적용될 수 있습니다.', ['확인'], 5);
end;

{ 시스템 설정 }
procedure TBPMainForm.actSystemSettingExecute(Sender: TObject);
begin
  if DoSystemSetting then
  begin
    BPMsgBox(Self.Handle, mtInformation, '알림',
      '변경된 시스템 설정을 적용하려면 프로그램을 재시작하여야 합니다.' + _BR + '프로그램을 종료하겠습니다.', ['확인']);
    Global.Closing := True;
    Application.Terminate;
  end;
end;

{ 마스터 수신 }
procedure TBPMainForm.actMasterReceiveExecute(Sender: TObject);
var
  LResMsg: string;
begin
  try
    if not DoMasterDownload(LResMsg) then
      raise Exception.Create(LResMsg);
    DoLogin;
  except
    on E: Exception do
        BPMsgBox(Self.Handle, mtError, '마스터 수신 실패', ErrorString(E.Message), ['확인'], 5)
  end;
end;

{ 카드단말기 무결성 검사 }
procedure TBPMainForm.actCardReaderVerifyExecute(Sender: TObject);
begin
  DoCardReaderVerify;
end;

{ 삭제한 판매 내역 조회 }
procedure TBPMainForm.actDeleteViewExecute(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Global.AppInfo.Handle);
    PluginManager.OpenModal('BPDeleteView' + CO_DEFAULT_EXT_PLUGIN, PM);
  finally
    FreeAndNil(PM);
  end;
end;

{ 알리미 실행 }
procedure TBPMainForm.actRunAdminCallExecute(Sender: TObject);
var
  LResMsg: string;
begin
  try
    if not RunAdminCall(LResMsg) then
      raise Exception.Create(LResMsg);
    if not LResMsg.IsEmpty then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '알리미 프로그램을 실행할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

{ 알리미 동작 테스트 }
procedure TBPMainForm.actTestAdminCallExecute(Sender: TObject);
var
  LResMsg: string;
begin
  try
    if not SendToAdminCall(9000, '알리미 테스트', 'POS', LResMsg) then
      BPMsgBox(Self.Handle, mtError, '알림', LResMsg, ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '알리미 프로그램을 실행할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

{ 외부기기 원격 시동 }
procedure TBPMainForm.actWakeOnLanExecute(Sender: TObject);
begin
  //
end;

{ 공지사항 }
procedure TBPMainForm.actNoticeViewExecute(Sender: TObject);
begin
  ShowPopupWebView('공지사항', FNoticeUrl, False, True);
end;

{ 날씨 예보 }
procedure TBPMainForm.actWeatherViewExecute(Sender: TObject);
begin
  ShowWeatherInfo;
end;

{ 웹 브라우저 엔진 업데이트 }
procedure TBPMainForm.actEdgeUpdateExecute(Sender: TObject);
begin
//
end;

{ 원격 지원 요청 }
procedure TBPMainForm.actRemoteSupportExecute(Sender: TObject);
begin
  if not Global.SupportInfo.RemoteUrl.IsEmpty then
    ShowWebView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer, Trim(TAction(Sender).Caption), Global.SupportInfo.RemoteUrl);
end;

procedure TBPMainForm.ActionControl(const AEnabled: Boolean);
var
  I: Integer;
begin
  actLaneView.Enabled := AEnabled;
  actSalePos.Enabled := AEnabled;
  actMember.Enabled := AEnabled;
  actLockerView.Enabled := AEnabled;
  actPartnerCenter.Enabled := AEnabled;
  actOrdersReport.Enabled := AEnabled;
  actMemberInfoSearch.Enabled := AEnabled;
  actNoticeView.Enabled := AEnabled;

  if not AEnabled then
  begin
    for I := 0 to Pred(Global.Plugin.PluginIdList.Count) do
      SendToPlugin(CPC_CLOSE, Global.Plugin.PluginIdList.Item[I]);
    Global.Plugin.PluginIdList.Clear;
  end;

  catMainMenu.Categories[LC_IDX_USER].Collapsed := AEnabled; //사용자
  if AEnabled then
    catMainMenu.Categories[LC_IDX_SALES].Collapsed := False //영업관리
  else
    for I := 1 to Pred(catMainMenu.Categories.Count) do
      catMainMenu.Categories[I].Collapsed := True;

  Global.AppInfo.PluginContainer.Visible := AEnabled;
end;

procedure TBPMainForm.OnMessageCallback(const ACommand: string; const AValue: Variant);
begin
  if (ACommand = CPC_TITLE) then
    panHeader.Caption := AValue
  else if (ACommand = CPC_MAIN_STATUS) then
  begin
    case AValue of
      CMP_REFRESH_CLOCK:
        lblClockInfo.Caption := Format('%s(%s) %s',
          [Global.DateTime.FormattedCurrentDate, Global.DateTime.DayOfWeekKR, Global.DateTime.FormattedCurrentTime]);
      CMP_PARTNER_CENTER_OFF:
        begin
          ledPartnerCenter.Enabled := True;
          ledPartnerCenter.LedValue := False;
        end;
      CMP_PARTNER_CENTER_ON:
        begin
          ledPartnerCenter.Enabled := True;
          ledPartnerCenter.LedValue := True;
        end;
      CMP_GAME_SERVER_OFF:
        begin
          ledGameServer.Enabled := True;
          ledGameServer.LedValue := False;
        end;
      CMP_GAME_SERVER_ON:
        begin
          ledGameServer.Enabled := True;
          ledGameServer.LedValue := True;
        end;
      CMP_GAME_SERVER_DB_OFF:
        begin
          ledGameServerDB.Enabled := True;
          ledGameServerDB.LedValue := False;
        end;
      CMP_GAME_SERVER_DB_ON:
        begin
          ledGameServerDB.Enabled := True;
          ledGameServerDB.LedValue := True;
        end;
      CMP_GAME_SERVER_DB_LOST:
        begin
          if FTryConnecting then
            Exit;
          if (BPMsgBox(Self.Handle, mtConfirmation, '확인', '게임서버 데이터베이스와의 접속이 끊어졌습니다.' + _BR + '접속을 재시도하시겠습니까?', ['예', '아니오']) = mrOk) then
          try
            Screen.Cursor := crSQLWait;
            FTryConnecting := True;
            try
              BPDM.MariaDB.Connect;
            finally
              FTryConnecting := False;
              Screen.Cursor := crDefault;
            end;
          except
            on E: Exception do
              BPMsgBox(Self.Handle, mtError, '확인', '게임 데이터베이스에 접속에 실패하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
          end;
        end;
      CMP_LOCAL_DB_OFF:
        begin
          ledLocalDB.Enabled := True;
          ledLocalDB.LedValue := False;
        end;
      CMP_LOCAL_DB_ON:
        begin
          ledLocalDB.Enabled := True;
          ledLocalDB.LedValue := True;
        end;
      CMP_USER_LOG_OFF:
        begin
          ledUserLogin.Enabled := True;
          ledUserLogin.LedValue := False;
        end;
      CMP_USER_LOG_ON:
        begin
          ledUserLogin.Enabled := True;
          ledUserLogin.LedValue := True;
        end;
      CMP_THREAD_LANE_OFF:
        begin
          ledLaneStatus.Enabled := False;
          ledLaneStatus.LedValue := True;
        end;
      CMP_THREAD_LANE_ON:
        begin
          ledLaneStatus.Enabled := True;
          ledLaneStatus.LedValue := True;
        end;
      CMP_THREAD_LANE_ERROR:
        begin
          ledLaneStatus.Enabled := True;
          ledLaneStatus.LedValue := False;
        end;
      CMP_THREAD_ASSIGN_OFF:
        begin
          ledAssignList.Enabled := False;
          ledAssignList.LedValue := True;
        end;
      CMP_THREAD_ASSIGN_ON:
        begin
          ledAssignList.Enabled := True;
          ledAssignList.LedValue := True;
        end;
      CMP_THREAD_ASSIGN_ERROR:
        begin
          ledAssignList.Enabled := True;
          ledAssignList.LedValue := False;
        end;
      CMP_THREAD_SALE_OFF:
        begin
          ledSaleList.Enabled := False;
          ledSaleList.LedValue := True;
        end;
      CMP_THREAD_SALE_ON:
        begin
          ledSaleList.Enabled := True;
          ledSaleList.LedValue := True;
        end;
      CMP_THREAD_SALE_ERROR:
        begin
          ledSaleList.Enabled := True;
          ledSaleList.LedValue := False;
        end;
    end
  end
  else if (ACommand = CPC_GAME_REFRESH_FORCE) then
    ThreadGroup.Start
  else if (ACommand = CPC_GAME_REFRESH_DELAY) then
    tmrRefreshDelay.Enabled := True
  else if (ACommand = CPC_SALE_REFRESH_ALL) then
  begin
    FThreadSaleDetailOnly := Boolean(AValue);
    ThreadSaleList.Start;
  end
  else if (ACommand = CPC_SALE_REFRESH_LANE) then
    Global.LaneInfo.Lanes[Integer(AValue)].Container.RefreshSale
  else if (ACommand = CPC_SELECT_MENU_ITEM) and
          (Integer(AValue) in [CO_MENU_LANE_VIEW..CO_MENU_LOCKER_VIEW]) then
  begin
    catMainMenu.SelectedItem := catMainMenu.Categories[1].Items[Integer(AValue)];
    panLaneStatusLegend.Visible := (Integer(AValue) = CO_MENU_LANE_VIEW);
  end
  else if (ACommand = CPC_READY_COUNT) then
    ledReadyCount.Text := Format('%.3d', [Integer(AValue)])
  else if (ACommand = CPC_RESERVED_COUNT) then
    ledReservedCount.Text := Format('%.3d', [Integer(AValue)])
  else if (ACommand = CPC_BUSY_COUNT) then
    ledBusyCount.Text := Format('%.3d', [Integer(AValue)]);
end;

procedure TBPMainForm.OnExceptionDlgCallback(Sender: TObject);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    lbxLogView.Items.BeginUpdate;
    lbxLogView.Items.Add('##### Start ExceptionDlg Callback #####');
    SL.Text := TExceptionDlg(Sender).ReportAsText;
    for var I: Integer := 0 to Pred(SL.Count) do
      lbxLogView.Items.Add(SL[I]);
    lbxLogView.Items.Add('##### End ExceptionDlg Callback #####');
  finally
    FreeAndNil(SL);
    lbxLogView.Items.EndUpdate;
  end;
end;

procedure TBPMainForm.SetUserLogged(const AValue: Boolean);
begin
  if (FUserLogged <> AValue) then
  try
    FUserLogged := AValue;
    Global.UserInfo.Logged := FUserLogged;
    if FUserLogged then
    begin
      {$WARN SYMBOL_PLATFORM OFF}
      FNoticeUrl := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&redirectUrl=/%s',
        [ExcludeTrailingBackslash(Global.PartnerCenter.Host), Global.StoreInfo.StoreCode, Global.UserInfo.UserId, Global.UserInfo.TerminalPwd, 'system/noticeList']);
      {$WARN SYMBOL_PLATFORM ON}
      actLogin.Caption := '로그아웃 (F1)';
      actLogin.ImageIndex := 5;
      lblPosInfo.Caption := Format('%s | POS-%.2d | %s (%s)',
        [Global.StoreInfo.StoreName, Global.TerminalInfo.PosNo, Global.UserInfo.UserName, Global.UserInfo.UserId]);

      if (Global.TerminalInfo.SaleZoneCode = CO_SALEZONE_POS_FRONT) then
        ThreadGroup.Start;
      ShowLaneView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
      SendToPlugin(CPC_CLOSE, Global.Plugin.WebViewPluginId);
    end
    else
    begin
      FNoticeUrl := '';
      Global.Title := Global.BaseTitle;
      actLogin.Caption := '로그인 (F1)';
      actLogin.ImageIndex := 4;
      lblPosInfo.Caption := '';

      if (Global.TerminalInfo.SaleZoneCode = CO_SALEZONE_POS_FRONT) then
        ThreadGroup.stop;
    end;
  finally
    ActionControl(FUserLogged);
  end;
end;

procedure TBPMainForm.SetMaxWindow(const AValue: Boolean);
begin
  if (FMaxWindow <> AValue) then
  begin
    FMaxWindow := AValue;
    if FMaxWindow then
    begin
      Self.Left := Global.Config.BaseLeft;
      Self.Top := Global.Config.BaseTop;
      Self.Width := Global.Config.BaseWidth;
      Self.Height := Global.Config.BaseHeight;
      actWindowSize.Hint := '기본 화면';
      btnWindowSize.ImageIndex := 23;
    end
    else
    begin
      Self.Width := LC_BASE_WIDTH;
      Self.Height := LC_BASE_HEIGHT;
      actWindowSize.Hint := '최대 화면';
      btnWindowSize.ImageIndex := 22;
    end;
  end;
end;

procedure TBPMainForm.ThreadGroupTerminate(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_ASSIGN_OFF);
  SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_LANE_OFF);
  SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_SALE_OFF);
end;

procedure TBPMainForm.ThreadGroupThreadStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  Screen.Cursor := crSQLWait;
end;

procedure TBPMainForm.ThreadGroupThreadTerminate(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  Screen.Cursor := crDefault;
end;

procedure TBPMainForm.ThreadAssignListStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_ASSIGN_ON);
end;

procedure TBPMainForm.ThreadAssignListExecute(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  Thread.Synchronize(AssignListSyncProc);
end;

procedure TBPMainForm.ThreadLaneStatusStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_LANE_ON);
end;

procedure TBPMainForm.ThreadLaneStatusExecute(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  Thread.Synchronize(LaneStatusSyncProc);
end;

procedure TBPMainForm.ThreadSaleListStart(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_SALE_ON);
end;

procedure TBPMainForm.ThreadSaleListExecute(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
  Thread.Synchronize(SaleListSyncProc);
end;

procedure TBPMainForm.AssignListSyncProc(Sender: TObject);
var
  LResMsg: string;
begin
  try
    if not BPDM.RefreshAssignList(LResMsg) then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
    begin
      SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_ASSIGN_ERROR);
      UpdateLog('ThreadLaneStatus.Exception = ' + E.Message);
    end;
  end;
end;

procedure TBPMainForm.LaneStatusSyncProc(Sender: TObject);
var
  LResMsg: string;
begin
  try
    if not BPDM.RefreshLaneStatus(LResMsg) then
      raise Exception.Create(LResMsg);
    for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
    begin
      Global.LaneInfo.Lanes[I].Container.RefreshAll;
      Application.ProcessMessages;
    end;
  except
    on E: Exception do
    begin
      SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_LANE_ERROR);
      UpdateLog('ThreadLaneStatus.Exception = ' + E.Message);
    end;
  end;
end;

procedure TBPMainForm.SaleListSyncProc(Sender: TObject);
var
  LResMsg: string;
begin
  try
    try
      if not BPDM.CleanReceipt(LResMsg) then
        raise Exception.Create(LResMsg);
      Application.ProcessMessages;

      if not FThreadSaleDetailOnly then
      begin
        if not BPDM.RefreshReceipt(LResMsg) then
          raise Exception.Create(LResMsg);
        SendToPlugin(CPC_RECEIPT_NO_LIST, Global.Plugin.SalePosPluginId);
        Application.ProcessMessages;
      end;

      if not BPDM.RefreshSaleItem(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
        raise Exception.Create(LResMsg);
      Application.ProcessMessages;

      if not BPDM.RefreshPayment(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
        raise Exception.Create(LResMsg);
      Application.ProcessMessages;
    finally
      SendToMainForm(CPC_GAME_REFRESH_FORCE, Global.LaneInfo.SelectedLaneNo);
    end;
  except
    on E: Exception do
    begin
      SendToMainForm(CPC_MAIN_STATUS, CMP_THREAD_SALE_ERROR);
      UpdateLog('ThreadSaleList.Exception = ' + E.Message);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

initialization
  ReportMemoryLeaksOnShutdown := True;
  Global := TGlobal.Create;
  BPDM := TBPDM.Create(nil);
finalization
  BPDM.Free;
  Global.Free;
  CheckSynchronize;
end.
