(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 대회 모드 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPRallyMode.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages, DBGridEh, Vcl.Mask, DBCtrlsEh, DBLookupEh,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, Data.DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, Vcl.ComCtrls, cxLabel, cxCheckBox;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPRallyModeForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    dsrRallyEntryList: TDataSource;
    pgcMain: TPageControl;
    tabListView: TTabSheet;
    tabSetting: TTabSheet;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    V2rec_no: TcxGridDBBandedColumn;
    V2member_div: TcxGridDBBandedColumn;
    V2club_nm: TcxGridDBBandedColumn;
    V2bowler_nm: TcxGridDBBandedColumn;
    V2mobile_no: TcxGridDBBandedColumn;
    V2birthday: TcxGridDBBandedColumn;
    V2lane_no: TcxGridDBBandedColumn;
    V2game_cnt: TcxGridDBBandedColumn;
    V2handy: TcxGridDBBandedColumn;
    L2: TcxGridLevel;
    Panel1: TPanel;
    gbxGame: TGroupBox;
    cbxShiftCount: TDBComboBoxEh;
    cbxShiftMethod: TDBComboBoxEh;
    gbxSameScore: TGroupBox;
    ckbHighLow: TDBCheckBoxEh;
    ckbSeniorFirst: TDBCheckBoxEh;
    ckbNotHandy: TDBCheckBoxEh;
    gbxTeamRally: TGroupBox;
    ckbTeamMode: TDBCheckBoxEh;
    Panel2: TPanel;
    btnSaveSetting: TBitBtn;
    btnDoAssign: TBitBtn;
    Panel3: TPanel;
    Label2: TLabel;
    edtRallyTitle: TDBEditEh;
    btnRefreshList: TBitBtn;
    Label3: TLabel;
    edtStartDate: TDBDateTimeEditEh;
    edtEndDate: TDBDateTimeEditEh;
    Label4: TLabel;
    cbxClubSeq: TDBLookupComboboxEh;
    Label5: TLabel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1rally_nm: TcxGridDBBandedColumn;
    V1entry_cnt: TcxGridDBBandedColumn;
    V1lane_nm: TcxGridDBBandedColumn;
    V1game_cnt: TcxGridDBBandedColumn;
    V1rally_datetime: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    dsrRallyList: TDataSource;
    btnRallyList: TBitBtn;
    V1club_nm: TcxGridDBBandedColumn;
    btnSelectRally: TBitBtn;
    dsrClubList: TDataSource;
    ckbLeagueMode: TDBCheckBoxEh;
    V1rank_nohandy_yn: TcxGridDBBandedColumn;
    V1rank_highlow_yn: TcxGridDBBandedColumn;
    V1rank_birth_yn: TcxGridDBBandedColumn;
    V1league_yn: TcxGridDBBandedColumn;
    V1team_yn: TcxGridDBBandedColumn;
    edtRallyName: TDBEditEh;
    V1calc_move_method: TcxGridDBBandedColumn;
    V1lane_move_cnt: TcxGridDBBandedColumn;
    V1Column1: TcxGridDBBandedColumn;
    edtPrepareMin: TDBNumberEditEh;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDoAssignClick(Sender: TObject);
    procedure btnSaveSettingClick(Sender: TObject);
    procedure btnRallyListClick(Sender: TObject);
    procedure btnRefreshListClick(Sender: TObject);
    procedure btnSelectRallyClick(Sender: TObject);
    procedure V1CellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure V2rec_noGetDataText(Sender: TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
  private
    { Private declarations }
    FOwnerId: Integer;
    FRallySeq: Integer;
    FRallyTitle: string;
    FLeagueMode: Boolean;
    FShiftMethod: string;
    FShiftCount: ShortInt;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure RefreshRallyList(const AShowMsg: Boolean=True);
    function RefreshEntryList(var AResMsg: string): Boolean;
    function CheckLaneReady: Boolean;
    procedure DoAssignRally;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, System.Variants, Vcl.Dialogs, System.DateUtils, System.StrUtils,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPRallyModeForm }

constructor TBPRallyModeForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  FRallySeq := 0;
  FRallyTitle := '';
  FLeagueMode := False;
  FShiftMethod := '';
  FShiftCount := 0;
  FWorking := False;
  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  with pgcMain do
  begin
    for var I: ShortInt := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
  end;

  edtStartDate.Value := StartOfTheMonth(Now);
  edtEndDate.Value := EndOfTheMonth(Now);
  if not dsrClubList.DataSet.Active then
    dsrClubList.DataSet.Active := True;

  with cbxShiftMethod do
  begin
    for var I: ShortInt := 0 to High(CO_TABLE_SHIFT_LIST) do
      Items.AddObject(CO_TABLE_SHIFT_LIST[I].Caption + ' 이동', TObject(CO_TABLE_SHIFT_LIST[I].Code));
    ItemIndex := 0;
  end;

  with cbxShiftCount do
  begin
    Items.Add('<없음>');
    for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount div 2) do
      Items.Add(Format('%d 레인씩 이동', [Succ(I) * 2]));
    ItemIndex := 0;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPRallyModeForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPRallyModeForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPRallyModeForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPRallyModeForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    RefreshRallyList(False);
  end;
end;

procedure TBPRallyModeForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.ModalResult := mrCancel;
end;

procedure TBPRallyModeForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPRallyModeForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPRallyModeForm.btnRallyListClick(Sender: TObject);
begin
  pgcMain.ActivePage := tabListView;
  panHeader.Caption := '대회 현황 조회';
end;

procedure TBPRallyModeForm.btnRefreshListClick(Sender: TObject);
begin
  RefreshRallyList;
end;

procedure TBPRallyModeForm.btnSelectRallyClick(Sender: TObject);
var
  LResMsg: string;
begin
  with V1.DataController.DataSet do
  try
    if (RecordCount = 0) then
      Exit;
    FRallySeq := FieldByName('rally_seq').AsInteger;
    FRallyTitle := FieldByName('rally_nm').AsString;
    if not RefreshEntryList(LResMsg) then
      raise Exception.Create(LResMsg);
    FLeagueMode := FieldByName('league_yn').AsBoolean;
    FShiftMethod := FieldByName('move_method').AsString;
    FShiftCount :=  FieldByName('lane_move_cnt').AsInteger;
    for var I:ShortInt := 0 to High(CO_TABLE_SHIFT_LIST) do
      if (CO_TABLE_SHIFT_LIST[I].Code = FShiftMethod) then
      begin
        cbxShiftMethod.ItemIndex := I;
        Break;
      end;
    cbxShiftCount.ItemIndex := (FShiftCount div 2);
    edtRallyName.Text := FRallyTitle;
    ckbLeagueMode.Checked := FLeagueMode;
    ckbNotHandy.Checked := FieldByName('rank_nohandy_yn').AsBoolean;
    ckbHighLow.Checked := FieldByName('rank_highlow_yn').AsBoolean;
    ckbSeniorFirst.Checked := FieldByName('rank_birth_yn').AsBoolean;
    ckbTeamMode.Checked := FieldByName('team_yn').AsBoolean;
    pgcMain.ActivePage := tabSetting;
    panHeader.Caption := '대회 설정 및 배정';
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '대회 참가자 목록을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPRallyModeForm.btnSaveSettingClick(Sender: TObject);
var
  RR: TRallyInfoRec;
  LResMsg: string;
begin
  try
    RR.RallySeq := FRallySeq;
    RR.RallyName := Trim(edtRallyName.Text);
    RR.LeagueMode := ckbLeagueMode.Checked;
    RR.ShiftMethod := String(cbxShiftMethod.Items.Objects[cbxShiftMethod.ItemIndex]);
    RR.ShiftCount := (cbxShiftCount.ItemIndex * 2);
    RR.RankNoHandy := ckbNotHandy.Checked;
    RR.RankHighLow := ckbHighLow.Checked;
    RR.RankBirth := ckbSeniorFirst.Checked;
    RR.TeamMode := ckbTeamMode.Checked;
    if not BPDM.PostRallySetting(RR, LResMsg) then
      raise Exception.Create(LResMsg);
    RefreshRallyList;
    V1.DataController.DataSet.Locate('rally_seq', FRallySeq, []);
    pgcMain.ActivePage := tabListView;
    BPMsgBox(Self.Handle, mtInformation, '알림', '대회 설정 변경 작업이 완료되었습니다.', ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '대회 설정 정보를 저장할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPRallyModeForm.btnDoAssignClick(Sender: TObject);
begin
  if (V2.DataController.DataSet.RecordCount = 0) or
     (BPMsgBox(Self.Handle, mtConfirmation, '확인', '현재 설정된 참가자 목록으로 배정하시겠습니까?' + _BR +
        Format('▶ 대회명: %s (참가자: %d명)', [FRallyTitle, V2.DataController.DataSet.RecordCount]), ['예', '아니오']) <> mrOK) then
    Exit;
  DoAssignRally;
end;

procedure TBPRallyModeForm.V1CellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState;
  var AHandled: Boolean);
begin
  btnSelectRally.Click;
end;

procedure TBPRallyModeForm.V2rec_noGetDataText(Sender: TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
var
  LIndex: Integer;
begin
  LIndex := TcxGridDBBandedTableView(Sender.GridView).DataController.GetRowIndexByRecordIndex(ARecordIndex, False);
  AText := IntToStr(LIndex + 1);
end;

procedure TBPRallyModeForm.RefreshRallyList(const AShowMsg: Boolean);
var
  LStartDate, LEndDate, LTitle, LResMsg: string;
  LClubSeq: Integer;
begin
  try
    LStartDate := FormatDateTime('yyyymmdd', edtStartDate.Value);
    LEndDate := FormatDateTime('yyyymmdd', edtEndDate.Value);
    LClubSeq := 0;
    if not VarIsNull(cbxClubSeq.Value) then
      LClubSeq := Integer(cbxClubSeq.Value);
    LTitle := Trim(edtRallyTitle.Text);
    if not BPDM.GetRallyList(LStartDate, LEndDate, LTitle, LClubSeq, LResMsg) then
      raise Exception.Create(LResMsg);
    if AShowMsg and
       (V1.DataController.DataSet.RecordCount = 0) then
      BPMsgBox(Self.Handle, mtInformation, '알림', '조회할 대회 내역이 없습니다.', ['확인'], 5);
  except
    on E: Exception do
      if AShowMsg then
        BPMsgBox(Self.Handle, mtWarning, '알림', '대회 목록을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

function TBPRallyModeForm.RefreshEntryList(var AResMsg: string): Boolean;
begin
  Result := False;
  AResMsg := '';
  try
    if not BPDM.GetRallyEntryList(FRallySeq, AResMsg) then
      raise Exception.Create(AResMsg);
    V2.Bands[0].Caption := Format('대회명: %s (Seq: %d)', [FRallyTitle, FRallySeq]);
    Result := True;
  except
    on E: Exception do
      AResMsg := E.Message;
  end;
end;

function TBPRallyModeForm.CheckLaneReady: Boolean;
var
  LLaneNo: ShortInt;
begin
  SendToMainForm(CPC_GAME_REFRESH_FORCE);
  Application.ProcessMessages;
  with BPDM.GetABSDataSet(Format('SELECT lane_no FROM MEMORY MTRallyEntryList WHERE rally_seq = %d GROUP BY lane_no;', [FRallySeq])) do
  try
    First;
    while not Eof do
    begin
      LLaneNo := FieldByName('lane_no').AsInteger;
      if (Global.LaneInfo.Lanes[Global.LaneInfo.LaneIndex(LLaneNo)].LaneStatus <> CO_LANE_READY) then
      begin
        BPMsgBox(Self.Handle, mtWarning, '알림', Format('%d 번 레인이 이용 가능한 상태가 아닙니다.', [LLaneNo]), ['확인'], 5);
        Result := False;
        Exit;
      end;
      Next;
    end;
    Result := True;
  finally
    Close;
    Free;
  end;
end;

procedure TBPRallyModeForm.DoAssignRally;
var
  GA: TArray<TGameAssignRec>;
  LGame, LBaseLaneNo, LLaneNo, LBowler: ShortInt;
  LResMsg, LErrMsg: string;
  LIsError: Boolean;
begin
  try
    if FWorking then
      Exit;
    FWorking := True;
    with V2.DataController.DataSet do
    try
      Screen.Cursor := crSQLWait;
      DisableControls;
      if not CheckLaneReady then
        Exit;
      LBaseLaneNo := -1;
      LGame := -1;
      LBowler := -1;
      First;
      while not Eof do
      begin
        LLaneNo := FieldByName('lane_no').AsInteger;
        if (LLaneNo <> LBaseLaneNo) then
        begin
          Inc(LGame);
          SetLength(GA, LGame + 1);
          LBaseLaneNo := LLaneNo;
          LBowler := -1
        end;

        with GA[LGame] do
        begin
          LaneNo := LBaseLaneNo;
          GameDiv := CO_RATEPLAN_GAME;
          RallySeq := FRallySeq;
          LeagueMode := FLeagueMode;
          ShiftMethod := FShiftMethod;
          ShiftCount := FShiftCount;
          PrepareMin := Trunc(edtPrepareMin.Value);

          Inc(LBowler);
          SetLength(Bowlers, LBowler + 1);
          Bowlers[LBowler].Clear;
          Bowlers[LBowler].BowlerId := Format('%.2d%s', [LBaseLaneNo, Char(65 + LBowler)]); //'A'..
          Bowlers[LBowler].BowlerName := IfThen(FieldByName('bowler_nm').AsString.IsEmpty, Bowlers[LBowler].BowlerId, FieldByName('bowler_nm').AsString);
          Bowlers[LBowler].EntrySeq := FieldByName('entry_seq').AsInteger;
          Bowlers[LBowler].Handy := FieldByName('handy').AsInteger;
          Bowlers[LBowler].MemberNo := FieldByName('member_no').AsString;
          Bowlers[LBowler].FeeDiv := CO_GAMEFEE_CLUB;
          Bowlers[LBowler].GameCount := FieldByName('game_cnt').AsInteger;
          Bowlers[LBowler].PaymentType := CO_PAYTYPE_DEFERRED;
          Bowlers[LBowler].ProdInfo.ProdName := FRallyTitle;
        end;
        Next;
      end;

      LIsError := False;
      for var I: ShortInt := 0 to High(GA) do
        if not BPDM.SetHoldLane(GA[I].LaneNo, True, LErrMsg) then
        begin
          LIsError := True;
          Break;
        end;
      if not LIsError then
        LIsError := BPDM.AssignGame(True, '', GA, LErrMsg);
      if LIsError then
      begin
        for var I: ShortInt := 0 to High(GA) do
          if not BPDM.SetHoldLane(GA[I].LaneNo, True, LErrMsg) then
            Break;
        raise Exception.Create(LResMsg);
      end;
      Self.ModalResult := mrOK;
    finally
      FWorking := False;
      EnableControls;
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '대회 배정에 실패하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPRallyModeForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.