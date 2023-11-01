(*******************************************************************************
  Project     : 볼링픽 POS 시스템
  Title       : 레인/볼러 이동 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.
  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.
*******************************************************************************)
unit BPLaneMove.Plugin;
interface
uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { Project}
  Common.BPLaneContainer;
{$I ..\..\common\Common.BPCommon.inc}
type
  TBPLaneMoveForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    btnBowlerToLeft: TBitBtn;
    btnBowlerToRight: TBitBtn;
    btnLaneToLeft: TBitBtn;
    btnLaneToRight: TBitBtn;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnBowlerToRightClick(Sender: TObject);
    procedure btnBowlerToLeftClick(Sender: TObject);
    procedure btnLaneToRightClick(Sender: TObject);
    procedure btnLaneToLeftClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FLaneControl1: TBPLaneContainer;
    FLaneControl2: TBPLaneContainer;
    FLaneNo1: ShortInt;
    FLaneNo2: ShortInt;
    FLaneIndex1: ShortInt;
    FLaneIndex2: ShortInt;
    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DrawLaneLayout;
    procedure RefreshData;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;
implementation
uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs,
  { DevExpress }
  cxGridDBTableView,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;
var
  LF: TLayeredForm;
{$R *.dfm}
{ TBPLaneMoveForm }
constructor TBPLaneMoveForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  FOwnerId := 0;
  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  FLaneNo1 := 0;
  FLaneNo2 := 0;
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;
destructor TBPLaneMoveForm.Destroy;
begin
  LF.Release;
  inherited Destroy;
end;
procedure TBPLaneMoveForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
procedure TBPLaneMoveForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;
procedure TBPLaneMoveForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    FLaneIndex1 := AMsg.ParamByInteger(CPP_VALUE + '1');
    FLaneIndex2 := AMsg.ParamByInteger(CPP_VALUE + '2');
    FLaneNo1 := Global.LaneInfo.Lanes[FLaneIndex1].LaneNo;
    FLaneNo2 := Global.LaneInfo.Lanes[FLaneIndex2].LaneNo;
    DrawLaneLayout;
  end;
end;
procedure TBPLaneMoveForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;
procedure TBPLaneMoveForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;
procedure TBPLaneMoveForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;
procedure TBPLaneMoveForm.btnBowlerToRightClick(Sender: TObject);
var
  LJobName, LAssignNo, LBowlerId, LBowlerName, LResMsg, sTargetAssignNo, sTargetBowlerId: string;
  LAssignLaneNo, LPaymentType: ShortInt;
  LAssignNoT, LBowlerIdT, LBowlerNameT, LReceiptNoT: string;
  LAssignLaneNoT: ShortInt;
  LReceiptNo: String;
begin
  LJobName := TBitBtn(Sender).Caption;
  with Global.LaneInfo.Lanes[FLaneIndex1].Container.GameDataSet do
  begin
    if (RecordCount = 0) then
      Exit;
    LAssignLaneNo := FieldByName('assign_lane_no').AsInteger;
    LAssignNo := FieldByName('assign_no').AsString;
    LBowlerId := FieldByName('bowler_id').AsString;
    LBowlerName := FieldByName('bowler_nm').AsString;
    if LBowlerName.IsEmpty then
      LBowlerName := LBowlerId
    else if (LBowlerId <> LBowlerName) then
      LBowlerName := Format('%s-%s', [LBowlerId, LBowlerName]);
    LPaymentType := FieldByName('payment_type').AsInteger;
  end;
  if (BPMsgBox(Self.Handle, mtConfirmation, LJobName, ErrorString(LBowlerName) + ' 볼러를 ' +
        ErrorString(FLaneNo2.ToString) + ' 레인으로 이동하시겠습니까?' + _BR + '이동한 볼러는 배정된 게임에 즉시 적용됩니다.', ['예', '아니오']) <> mrOK) then
    Exit;
  try
    if not BPDM.RelocateBowler(LAssignNo, LBowlerId, FLaneNo2, LResMsg, sTargetAssignNo, sTargetBowlerId) then
      raise Exception.Create(LResMsg);
    {
    if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET assign_lane_no = %d WHERE assign_lane_no = %d AND bowler_id = %s;',
        [FLaneNo2, LAssignLaneNo, QuotedStr(LBowlerId)]), LResMsg) then
      raise Exception.Create(LResMsg);
    }
    if LPaymentType = 1 then
    begin
      RefreshData;
      Exit;
    end;
    with Global.LaneInfo.Lanes[FLaneIndex2].Container.GameDataSet do
    begin
      if (RecordCount = 0) then
      begin
        if not BPDM.MakeNewReceipt(Global.LaneInfo.Lanes[FLaneIndex2].LaneNo, LReceiptNo, LResMsg) then //var LReceiptNo
          raise Exception.Create(LResMsg);

        LAssignLaneNoT := Global.LaneInfo.Lanes[FLaneIndex2].LaneNo;
        LAssignNoT := sTargetAssignNo;
        //LBowlerIdT := FieldByName('bowler_id').AsString;
        LReceiptNoT := LReceiptNo;
      end
      else
      begin
        LAssignLaneNoT := FieldByName('assign_lane_no').AsInteger;
        LAssignNoT := FieldByName('assign_no').AsString;
        //LBowlerIdT := FieldByName('bowler_id').AsString;
        LReceiptNoT := FieldByName('receipt_no').AsString;
      end;
    end;
    if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET receipt_no = %s, assign_lane_no = %d, assign_no = %s, bowler_id = %s WHERE assign_lane_no = %d AND bowler_id = %s;',
      [QuotedStr(LReceiptNoT), FLaneNo2, QuotedStr(LAssignNoT), QuotedStr(sTargetBowlerId), LAssignLaneNo, QuotedStr(LBowlerId)]), LResMsg) then
    raise Exception.Create(LResMsg);
    RefreshData;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, LJobName, LJobName + ' 명령을 처리할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;
procedure TBPLaneMoveForm.btnBowlerToLeftClick(Sender: TObject);
var
  LJobName, LAssignNo, LBowlerId, LBowlerName, LResMsg, sTargetAssignNo, sTargetBowlerId: string;
  LAssignLaneNo, LPaymentType: ShortInt;
  LAssignNoT, LBowlerIdT, LBowlerNameT, LReceiptNoT: string;
  LAssignLaneNoT: ShortInt;
  LReceiptNo: String;
begin
  LJobName := TBitBtn(Sender).Caption;
  with Global.LaneInfo.Lanes[FLaneIndex2].Container.GameDataSet do
  begin
    if (RecordCount = 0) then
      Exit;
    LAssignLaneNo := FieldByName('assign_lane_no').AsInteger;
    LAssignNo := FieldByName('assign_no').AsString;
    LBowlerId := FieldByName('bowler_id').AsString;
    LBowlerName := FieldByName('bowler_nm').AsString;
    if LBowlerName.IsEmpty then
      LBowlerName := LBowlerId
    else if (LBowlerId <> LBowlerName) then
      LBowlerName := Format('%s-%s', [LBowlerId, LBowlerName]);
    LPaymentType := FieldByName('payment_type').AsInteger;
  end;
  if (BPMsgBox(Self.Handle, mtConfirmation, LJobName, ErrorString(LBowlerName) + ' 볼러를 ' +
        ErrorString(FLaneNo1.ToString) + ' 레인으로 이동하시겠습니까?' + _BR + '이동한 볼러는 배정된 게임에 즉시 적용됩니다.', ['예', '아니오']) <> mrOK) then
    Exit;
  try
    if not BPDM.RelocateBowler(LAssignNo, LBowlerId, FLaneNo1, LResMsg, sTargetAssignNo, sTargetBowlerId) then
      raise Exception.Create(LResMsg);
    {
    if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET assign_lane_no = %d WHERE assign_lane_no = %d AND bowler_id = %s;',
        [FLaneNo1, LAssignLaneNo, QuotedStr(LBowlerId)]), LResMsg) then
      raise Exception.Create(LResMsg);
    }
    if LPaymentType = 1 then
    begin
      RefreshData;
      Exit;
    end;
    with Global.LaneInfo.Lanes[FLaneIndex1].Container.GameDataSet do
    begin
      if (RecordCount = 0) then
      begin
        if not BPDM.MakeNewReceipt(Global.LaneInfo.Lanes[FLaneIndex1].LaneNo, LReceiptNo, LResMsg) then //var LReceiptNo
          raise Exception.Create(LResMsg);

        LAssignLaneNoT := Global.LaneInfo.Lanes[FLaneIndex2].LaneNo;
        LAssignNoT := sTargetAssignNo;
        //LBowlerIdT := FieldByName('bowler_id').AsString;
        LReceiptNoT := LReceiptNo;
      end
      else
      begin
        LAssignLaneNoT := FieldByName('assign_lane_no').AsInteger;
        LAssignNoT := FieldByName('assign_no').AsString;
        LBowlerIdT := FieldByName('bowler_id').AsString;
        LReceiptNoT := FieldByName('receipt_no').AsString;
      end;
    end;
    if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET receipt_no = %s, assign_lane_no = %d, assign_no = %s, bowler_id = %s WHERE assign_lane_no = %d AND bowler_id = %s;',
      [QuotedStr(LReceiptNoT), FLaneNo2, QuotedStr(LAssignNoT), QuotedStr(sTargetBowlerId), LAssignLaneNo, QuotedStr(LBowlerId)]), LResMsg) then
    raise Exception.Create(LResMsg);
    RefreshData;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, LJobName, LJobName + ' 명령을 처리할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;
procedure TBPLaneMoveForm.btnLaneToRightClick(Sender: TObject);
var
  LJobName, LResMsg: string;
  LAssignLaneNo: ShortInt;
  sReceiptNo: String;
begin
  LJobName := TBitBtn(Sender).Caption;
  with Global.LaneInfo.Lanes[FLaneIndex1].Container.GameDataSet do
  begin
    if (RecordCount = 0) then
      Exit;
    LAssignLaneNo := FieldByName('assign_lane_no').AsInteger;
    sReceiptNo := FieldByName('receipt_no').AsString;
  end;
  if (BPMsgBox(Self.Handle, mtConfirmation, LJobName, ErrorString(FLaneNo1.ToString) + ' 레인을 ' +
        ErrorString(FLaneNo2.ToString) + ' 레인으로 이동하시겠습니까?' + _BR + '이동한 결과는 즉시 적용됩니다.', ['예', '아니오']) <> mrOK) then
    Exit;
  try
    if not BPDM.SetHoldLane(FLaneNo2, True, LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.RelocateLane(FLaneNo1, FLaneNo2, LResMsg) then
    begin
      if not BPDM.SetHoldLane(FLaneNo2, False, LResMsg) then
        raise Exception.Create(LResMsg);
      raise Exception.Create(LResMsg);
    end;
    if not BPDM.ExecuteABSQuery(Format('UPDATE TBReceipt SET assign_lane_no = %d WHERE assign_lane_no = %d AND receipt_no = %s;', [FLaneNo2, LAssignLaneNo, QuotedStr(sReceiptNo)]), LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET assign_lane_no = %d WHERE assign_lane_no = %d AND receipt_no = %s;', [FLaneNo2, LAssignLaneNo, QuotedStr(sReceiptNo)]), LResMsg) then
      raise Exception.Create(LResMsg);
    RefreshData;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, LJobName, LJobName + ' 명령을 처리할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;
procedure TBPLaneMoveForm.btnLaneToLeftClick(Sender: TObject);
var
  LJobName, LResMsg: string;
  LAssignLaneNo: ShortInt;
begin
  LJobName := TBitBtn(Sender).Caption;
  with Global.LaneInfo.Lanes[FLaneIndex2].Container.GameDataSet do
  begin
    if (RecordCount = 0) then
      Exit;
    LAssignLaneNo := FieldByName('assign_lane_no').AsInteger;
  end;
  if (BPMsgBox(Self.Handle, mtConfirmation, LJobName, ErrorString(FLaneNo2.ToString) + ' 레인을 ' +
        ErrorString(FLaneNo1.ToString) + ' 레인으로로 이동하시겠습니까?' + _BR + '이동한 결과는 즉시 적용됩니다.', ['예', '아니오']) <> mrOK) then
    Exit;
  try
    if not BPDM.SetHoldLane(FLaneNo1, True, LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.RelocateLane(FLaneNo2, FLaneNo1, LResMsg) then
    begin
      if not BPDM.SetHoldLane(FLaneNo1, False, LResMsg) then
        raise Exception.Create(LResMsg);
      raise Exception.Create(LResMsg);
    end;
    if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET assign_lane_no = %d WHERE assign_lane_no = %d;', [FLaneNo1, LAssignLaneNo]), LResMsg) then
      raise Exception.Create(LResMsg);
    RefreshData;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, LJobName, LJobName + ' 명령을 처리할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;
procedure TBPLaneMoveForm.DrawLaneLayout;
begin
  FLaneControl1 := TBPLaneContainer.Create(nil);
  with FLaneControl1 do
  begin
    Align := alLeft;
    LaneIndex := FLaneIndex1;
    LaneNo := FLaneNo1;
    TabOrder := 0;
    Width := 300;
    Parent := panBody;
    LaneStatus := Global.LaneInfo.Lanes[FLaneIndex1].LaneStatus;
    LeagueMode := Global.LaneInfo.Lanes[FLaneIndex1].Container.LeagueMode;
    GameDataSource.DataSet := Global.LaneInfo.Lanes[FLaneIndex1].Container.GameDataSet;
    SaleDataSource.DataSet := Global.LaneInfo.Lanes[FLaneIndex1].Container.SaleDataSet;
    TcxGridDBTableView(GameView).Styles.Inactive := BPDM.StyleInactive;
    TcxGridDBTableView(GameView).Styles.Selection := BPDM.StyleSelection;
  end;
  FLaneControl2 := TBPLaneContainer.Create(nil);
  with FLaneControl2 do
  begin
    Align := alRight;
    LaneIndex := FLaneIndex2;
    LaneNo := FLaneNo2;
    TabOrder := 1;
    Width := 300;
    Parent := panBody;
    LaneStatus := Global.LaneInfo.Lanes[FLaneIndex2].LaneStatus;
    LeagueMode := Global.LaneInfo.Lanes[FLaneIndex2].Container.LeagueMode;
    GameDataSource.DataSet := Global.LaneInfo.Lanes[FLaneIndex2].Container.GameDataSet;
    SaleDataSource.DataSet := Global.LaneInfo.Lanes[FLaneIndex2].Container.SaleDataSet;
    TcxGridDBTableView(GameView).Styles.Inactive := BPDM.StyleInactive;
    TcxGridDBTableView(GameView).Styles.Selection := BPDM.StyleSelection;
    TcxGridDBTableView(SaleView).Styles.Inactive := BPDM.StyleInactive2;
    TcxGridDBTableView(SaleView).Styles.Selection := BPDM.StyleSelection2;
  end;
end;
procedure TBPLaneMoveForm.RefreshData;
begin
  SendToMainForm(CPC_GAME_REFRESH_FORCE);
  Global.LaneInfo.Lanes[FLaneIndex1].Container.RefreshAll;
  Global.LaneInfo.Lanes[FLaneIndex2].Container.RefreshAll;
end;
////////////////////////////////////////////////////////////////////////////////////////////////////
function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPLaneMoveForm.Create(Application, AMsg);
end;
exports
  OpenPlugin;
end.