(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 라커 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPLockerView.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh, Vcl.NumberBox;

{$I ..\..\common\Common.BPCommon.inc}

type
  TLockerContainer = class(TPanel)
    LockerNameLabel: TLabel; //라커명
    LayerNameLabel: TLabel; //상,하단 구분
    SexDivLabel: TLabel; //성별 구분
    MemberNameLabel: TLabel; //사용 중인 회원
  private
    FActive: Boolean;
    FLockerIndex: SmallInt;
    FSelected: Boolean;
    FLockerStatus: ShortInt;
    FSexDiv: ShortInt;

    procedure SetActive(const AValue: Boolean);
    procedure SetSelected(const AValue: Boolean);
    procedure SetLockerStatus(const AValue: ShortInt);
    procedure SetSexDiv(const AValue: ShortInt);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Active: Boolean read FActive write SetActive default True;
    property Selected: Boolean read FSelected write SetSelected default False;
    property LockerIndex: SmallInt read FLockerIndex write FLockerIndex default 0;
    property LockerStatus: ShortInt read FLockerStatus write SetLockerStatus default -1;
    property SexDiv: ShortInt read FSexDiv write SetSexDiv default -1;
  end;

  TBPLockerViewForm = class(TPluginModule)
    sbxLockerView: TScrollBox;
    TemplateLockerPanel: TPanel;
    panLaneMap: TPanel;
    panLockerLegend: TPanel;
    lblLegendEmpty: TLabel;
    lblLegendUsed: TLabel;
    lblLegendExpired: TLabel;
    lblLegendDisabled: TLabel;
    TemplateLockerNameLabel: TLabel;
    TemplateSexDivNameLabel: TLabel;
    TemplateMamberNameLabel: TLabel;
    TemplateLayerNameLabel: TLabel;
    btnRefresh: TBitBtn;
    panLockerDetail: TPanel;
    panLockerDetailTitle: TPanel;
    mmoLockerMemo: TMemo;
    panHeader: TPanel;
    lblPluginVersion: TLabel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    edtLockerStatus: TDBEditEh;
    edtMemberName: TDBEditEh;
    edtMemberMobileNo: TDBEditEh;
    edtStartDate: TDBEditEh;
    edtEndDate: TDBEditEh;
    edtProductName: TDBEditEh;
    edtLockerPosition: TDBEditEh;
    edtMemberKeepAmt: TDBEditEh;
    btnLockerClear: TBitBtn;
    gbxSelectLocker: TGroupBox;
    edtUseStartDate: TDBDateTimeEditEh;
    btnSelectLocker: TBitBtn;
    edtPurchaseMonth: TNumberBox;
    lblPurchaseMonth: TLabel;

    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PluginModuleResize(Sender: TObject);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sbxLockerViewMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnSelectLockerClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnLockerClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtPurchaseMonthEditButtons0Click(Sender: TObject; var Handled: Boolean);
    procedure edtPurchaseMonthEditButtons1Click(Sender: TObject; var Handled: Boolean);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBaseTitle: string;
    FSelectMode: Boolean;
    FSelectMemberNo: string;
    FActiveIndex: Integer;
    FPrevIndex: Integer;
    FLockerColumns: Integer;
    FLockerWidth: Integer;
    FLockerRows: Integer;
//    FDummyLabel: TLabel;
    FLockerContainer: TArray<TLockerContainer>;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DrawLockerLayout(const ACreateObject: Boolean=False);
    procedure RefreshLockerStatus;
    procedure ResizeControl;
    procedure SelectLocker(const ALockerIndex: Integer);
    procedure DoRefresh;

    procedure OnLockerClick(Sender: TObject);

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
  Vcl.Graphics, Vcl.Dialogs, system.Variants, System.Math,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPLockerViewForm }

const
  LCN_LOCKER_INTERVAL    = 5;
  LCN_LOCKER_BASE_WIDTH  = 90;
  LCN_LOCKER_BASE_HEIGHT = 90;

  LLC_NORMAL      = $00FFFFFF;
  LLC_SELECT_HEAD = $004B69FF;
  LLC_SELECT_BODY = $00D0F8FF;
  LSC_EMPTY       = CO_COLOR_LANE_NO_NORMAL;
  LSC_INUSE       = CO_COLOR_LANE_NO_SELECT;
  LSC_EXPIRED     = $004876B5;
  LSC_DISABLED    = $004D4D4D;

constructor TBPLockerViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  MakeRoundedControl(Self);
  FOwnerId := 0;
  FSelectMode := False;
  FSelectMemberNo := '';
  FBaseTitle := '라커 관리';
  FActiveIndex := 0;
  FPrevIndex := 0;
  SetLength(FLockerContainer, Global.LockerInfo.ItemCount);

  Self.Caption := FBaseTitle;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  lblLegendEmpty.Color := LSC_EMPTY;
  lblLegendUsed.Color := LSC_INUSE;
  lblLegendExpired.Color := LSC_EXPIRED;
  lblLegendDisabled.Color := LSC_DISABLED;
  panHeader.Visible := False;
  gbxSelectLocker.Visible := False;
  edtUseStartDate.Value := Now;

  sbxLockerView.VertScrollBar.Increment := (LCN_LOCKER_BASE_HEIGHT + LCN_LOCKER_INTERVAL);
  DrawLockerLayout(True);
  RefreshLockerStatus;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPLockerViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBPLockerViewForm.PluginModuleShow(Sender: TObject);
begin
  Global.Plugin.ActivePluginId := Self.PluginID;
end;

procedure TBPLockerViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Global.Plugin.LockerViewPluginId := 0;
  if Assigned(LF) then
    LF.Release;
  Action := caFree;
end;

procedure TBPLockerViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPLockerViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    FSelectMode := AMsg.ParamByBoolean(CPP_SELECT_LOCKER);
    if FSelectMode then
    begin
      FSelectMemberNo := AMsg.ParamByString(CPP_MEMBER_NO);
      LF := TLayeredForm.Create(nil);
      LF.Show;
      panHeader.Visible := True;
      panHeader.Caption := Format('%s (사용 등록)', [FBaseTitle]);
      gbxSelectLocker.Visible := True;
      btnLockerClear.Enabled := False;
      for var I: Integer := 0 to Pred(Global.LockerInfo.ItemCount) do
        if (FLockerContainer[I].LockerStatus in [CO_LOCKER_INUSE, CO_LOCKER_EXPIRED]) and
           (Global.LockerInfo.Items[I].MemberNo <> FSelectMemberNo) then
          FLockerContainer[I].Active := False;
    end;
    if (Global.LockerInfo.ItemCount > 0) then
      SelectLocker(0);
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_LOCKER_VIEW);
  end
  else if (AMsg.Command = CPC_ACTIVE) then
  begin
    BaseTitle := FBaseTItle;
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_LOCKER_VIEW);
    DoRefresh;
    if (Self.Align = alClient) then
      Self.BringToFront
    else
      SetForegroundWindow(Self.Handle);
  end
  else if (AMsg.Command = CPC_CLOSE) then
    Self.Close
  else if (AMsg.Command = CPC_RESIZE) then
    ResizeControl;
end;

procedure TBPLockerViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_PRIOR: //PageUp
      with sbxLockerView do
        VertScrollBar.Position := (VertScrollBar.Position - VertScrollBar.Increment);
    VK_NEXT: //PageDown
      with sbxLockerView do
        VertScrollBar.Position := (VertScrollBar.Position + VertScrollBar.Increment);
  end;
end;

procedure TBPLockerViewForm.PluginModuleResize(Sender: TObject);
begin
  ResizeControl;
end;

procedure TBPLockerViewForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPLockerViewForm.sbxLockerViewMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  SendMessage(TScrollBox(Sender).Handle, WM_VSCROLL, IfThen(WheelDelta >= 0, SB_LINELEFT, SB_LINERIGHT), 0);
  Handled := True;
end;

procedure TBPLockerViewForm.btnSelectLockerClick(Sender: TObject);
var
  LLockerNo: SmallInt;
  LLockerName, LStartDate: string;
begin
  if (FActiveIndex >= 0) then
  begin
    LLockerNo := Global.LockerInfo.Items[FActiveIndex].LockerNo;
    LLockerName := Global.LockerInfo.Items[FActiveIndex].LockerName;
    LStartDate := FormatDateTime('yyyy-mm-dd', edtUseStartDate.Value);
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(Format('%s 라커를 선택하시겠습니까?', [LLockerName])) + _BR + Format('이용시작일: %s', [LStartDate]), ['예', '아니오']) <> mrOK) then
      Exit;

    Global.MemberInfo.SelectLockerNo := LLockerNo;
    Global.MemberInfo.SelectLockerName := LLockerName;
    Global.MemberInfo.PurchaseMonth := edtPurchaseMonth.ValueInt;
    Global.MemberInfo.UseStartDate := LStartDate;
    Self.ModalResult := mrOK;
  end;
end;

procedure TBPLockerViewForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPLockerViewForm.btnLockerClearClick(Sender: TObject);
var
  LLockerName, LResMsg: string;
begin
  if (FActiveIndex >= 0) and
     (Global.LockerInfo.Items[FActiveIndex].LockerStatus in [CO_LOCKER_INUSE, CO_LOCKER_EXPIRED]) then
  try
    LLockerName := Format('%s(번)', [Global.LockerInfo.Items[FActiveIndex].LockerName]);
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인',
          ErrorString(LLockerName) + ' 라커를 정리하시겠습니까?', ['예', '아니오']) = mrOK) and
       (not BPDM.PostLockerClose(Global.LockerInfo.Items[FActiveIndex].LockerNo, LResMsg)) then
      raise Exception.Create(LResMsg);
    DoRefresh;
    BPMsgBox(Self.Handle, mtInformation, '알림', LLockerName + ' 라커 정리가 완료되었습니다.', ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '라커 정리 작업 중 장애가 발생하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLockerViewForm.btnRefreshClick(Sender: TObject);
begin
  DoRefresh;
end;

procedure TBPLockerViewForm.edtPurchaseMonthEditButtons0Click(Sender: TObject; var Handled: Boolean);
begin
  if (edtPurchaseMonth.Value > edtPurchaseMonth.MinValue) then
    edtPurchaseMonth.Value := (edtPurchaseMonth.Value - 1);
end;

procedure TBPLockerViewForm.edtPurchaseMonthEditButtons1Click(Sender: TObject; var Handled: Boolean);
begin
  if (edtPurchaseMonth.Value < edtPurchaseMonth.MaxValue) then
    edtPurchaseMonth.Value := (edtPurchaseMonth.Value + 1);
end;

procedure TBPLockerViewForm.OnLockerClick(Sender: TObject);
begin
  SelectLocker(TWinControl(Sender).Tag);
end;

procedure TBPLockerViewForm.DrawLockerLayout(const ACreateObject: Boolean);
var
  nTop, nLeft, nRow, nCol, nBaseWidth: Integer;
  bNeedScroll: Boolean;
begin
  sbxLOCKERView.VertScrollBar.Position := 0;
  nBaseWidth := (sbxLockerView.Width - LCN_LOCKER_INTERVAL);
  FLockerColumns := (nBaseWidth div LCN_LOCKER_BASE_WIDTH);
  FLockerWidth := (nBaseWidth div FLockerColumns) - LCN_LOCKER_INTERVAL;
  FLockerRows := (Global.LockerInfo.ItemCount div FLockerColumns);
  bNeedScroll := (FLockerRows >= 2) and ((Global.LockerInfo.ItemCount mod FLockerColumns) > 0);
  if bNeedScroll then
  begin
    nBaseWidth := (nBaseWidth - 10);
    FLockerWidth := (nBaseWidth div FLockerColumns) - LCN_LOCKER_INTERVAL;
  end;

  nRow := 0;
  nCol := 0;
  for var I: Integer := 0 to Pred(Global.LockerInfo.ItemCount) do
  begin
    if (nCol > Pred(FLockerColumns)) then
    begin
      nCol := 0;
      Inc(nRow);
    end;

    nTop := (nRow * LCN_LOCKER_BASE_HEIGHT) + (nRow * LCN_LOCKER_INTERVAL);
    nLeft := (nCol * FLockerWidth) + (nCol * LCN_LOCKER_INTERVAL);
    if ACreateObject then
    begin
      FLockerContainer[I] := TLockerContainer.Create(nil);
      FLockerContainer[I].Parent := sbxLockerView;
      FLockerContainer[I].Tag := I;
      FLockerContainer[I].LockerNameLabel.Tag := I;
      FLockerContainer[I].LockerNameLabel.OnClick := OnLockerClick;
      FLockerContainer[I].LayerNameLabel.Tag := I;
      FLockerContainer[I].LayerNameLabel.OnClick := OnLockerClick;
      FLockerContainer[I].SexDivLabel.Tag := I;
      FLockerContainer[I].SexDivLabel.OnClick := OnLockerClick;
      FLockerContainer[I].MemberNameLabel.Tag := I;
      FLockerContainer[I].MemberNameLabel.OnClick := OnLockerClick;
    end;
    FLockerContainer[I].Height := LCN_LOCKER_BASE_HEIGHT;
    FLockerContainer[I].Width := FLockerWidth;
    FLockerContainer[I].Top := nTop;
    FLockerContainer[I].Left := nLeft;

    Inc(nCol);
  end;

  (*
  //스크롤박스에서 스크롤할 경우 종단 유격을 맞추기 위한 Dummy 생성
  if bNeedScroll then
  begin
    if Assigned(FDummyLabel) then
      FreeAndNil(FDummyLabel);
    FDummyLabel := TLabel.Create(nil);
    with FDummyLabel do
    begin
      Parent := sbxLockerView;
      Top := (nTop + LCN_LOCKER_BASE_HEIGHT);
      Left := LCN_LOCKER_INTERVAL;
      Height := LCN_LOCKER_INTERVAL;
      Caption := '';
    end;
  end;
  *)
end;

procedure TBPLockerViewForm.RefreshLockerStatus;
begin
  with Global.LockerInfo do
    for var I: Integer := 0 to Pred(ItemCount) do
    begin
      FLockerContainer[I].LockerNameLabel.Caption := Items[I].LockerName;
      FLockerContainer[I].LayerNameLabel.Caption := Items[I].LayerName;
      FLockerContainer[I].SexDivLabel.Caption := Items[I].SexDivName;
      FLockerContainer[I].MemberNameLabel.Caption := Items[I].MemberName;
      FLockerContainer[I].SexDiv := Items[I].SexDiv;
      FLockerContainer[I].LockerStatus := Items[I].LockerStatus;
    end;
end;

procedure TBPLockerViewForm.ResizeControl;
begin
  if not Global.MainMenuResizing then
    DrawLockerLayout;
end;

procedure TBPLockerViewForm.SelectLocker(const ALockerIndex: Integer);
begin
  FPrevIndex := FActiveIndex;
  FActiveIndex := ALockerIndex;
  FLockerContainer[FPrevIndex].Selected := False;
  FLockerContainer[FActiveIndex].Selected := True;

  with Global.LockerInfo.Items[FActiveIndex] do
  begin
    case LockerStatus of
      CO_LOCKER_EMPTY: panLockerDetailTitle.Color := LSC_EMPTY;
      CO_LOCKER_INUSE: panLockerDetailTitle.Color := LSC_INUSE;
      CO_LOCKER_EXPIRED: panLockerDetailTitle.Color := LSC_EXPIRED;
    else
      panLockerDetailTitle.Color := LSC_DISABLED;
    end;

    panLockerDetailTitle.Caption := Format('[ %s ] 라커 상세', [LockerName]);
    edtLockerPosition.Text := Format('%s %s %s', [ZoneName, LayerName, SexDivName]);
    edtLockerStatus.Text := LockerStatusName;
    edtMemberName.Text := MemberName;
    edtMemberMobileNo.Text := TelNo;
    edtMemberKeepAmt.Text := FormatCurr('#,##0', KeepAmt);
    edtProductName.Text := ProdName;
    edtStartDate.Text := StartDate;
    edtEndDate.Text := EndDate;
    mmoLockerMemo.Lines.Text := LockerMemo;
  end;
end;

procedure TBPLockerViewForm.DoRefresh;
var
  LResMsg: string;
begin
  try
    Screen.Cursor := crSQLWait;
    try
      if not BPDM.GetLockerList(LResMsg) then
        raise Exception.Create(LResMsg);
      RefreshLockerStatus;
    finally
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '라커 조회 중 장애가 발생하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLockerViewForm.SetBaseTitle(const AValue: string);
begin
  FBaseTitle := AValue;
  Global.Title := FBaseTItle;
end;

{ TLockerContainer }

constructor TLockerContainer.Create(AOwner: TComponent);
begin
  inherited;

  FActive := True;
  FSelected := False;

  Self.AutoSize := False;
  Self.Color := LLC_NORMAL;
  Self.Cursor := crHandPoint;
  Self.DoubleBuffered := True;
  Self.Font.Name := 'Pretendard Variable';
  Self.Font.Color := clBlack;
  Self.Font.Size := 11;
  Self.Font.Style := [];
  Self.ParentColor := False;
  Self.ParentFont := False;
  Self.StyleElements := [seClient, seBorder];

  LockerNameLabel := TLabel.Create(Self);
  with LockerNameLabel do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Color := CO_COLOR_LANE_NO_NORMAL; //LSC_EMPTY;
    Font.Color := LLC_NORMAL;
    Font.Size := 14;
    Font.Style := [fsBold];
    Height := 30;
    Layout := tlCenter;
    ParentColor := False;
    ParentFont := False;
    StyleElements := [];
    Transparent := False;
  end;

  LayerNameLabel := TLabel.Create(Self);
  with LayerNameLabel do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Color := LLC_NORMAL;
    Font.Color := clGreen;
    Height := 20;
    Layout := tlCenter;
    ParentColor := False;
    ParentFont := False;
    StyleElements := [];
    Transparent := False;
  end;

  SexDivLabel := TLabel.Create(Self);
  with SexDivLabel do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Color := LLC_NORMAL;
    Font.Color := clGray;
    Height := 20;
    Layout := tlCenter;
    ParentColor := False;
    ParentFont := False;
    StyleElements := [];
    Transparent := False;
  end;

  MemberNameLabel := TLabel.Create(Self);
  with MemberNameLabel do
  begin
    Parent := Self;
    Align := alClient;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Color := LLC_NORMAL;
    Font.Color := clBlack;
    Height := 20;
    Layout := tlCenter;
    ParentColor := False;
    ParentFont := False;
    StyleElements := [];
    Transparent := False;
  end;
end;

destructor TLockerContainer.Destroy;
begin

  inherited;
end;

procedure TLockerContainer.SetActive(const AValue: Boolean);
begin
  if (FActive <> AValue) then
  begin
    FActive := AValue;
    LockerNameLabel.Enabled := FActive;
    LayerNameLabel.Enabled := FActive;
    SexDivLabel.Enabled := FActive;
    MemberNameLabel.Enabled := FActive;
  end;
end;

procedure TLockerContainer.SetSelected(const AValue: Boolean);
var
  nIndex: Integer;
begin
  if (FSelected <> AValue) then
  begin
    FSelected := AValue;
    nIndex := Self.Tag;
    if FSelected then
    begin
      LockerNameLabel.Color := LLC_SELECT_HEAD;
      LayerNameLabel.Color := LLC_SELECT_BODY;
      SexDivLabel.Color := LLC_SELECT_BODY;
      MemberNameLabel.Color := LLC_SELECT_BODY;
    end
    else
    begin
      case Global.LockerInfo.Items[nIndex].LockerStatus of
        CO_LOCKER_EMPTY: LockerNameLabel.Color := LSC_EMPTY;
        CO_LOCKER_INUSE: LockerNameLabel.Color := LSC_INUSE;
        CO_LOCKER_EXPIRED: LockerNameLabel.Color := LSC_EXPIRED;
        CO_LOCKER_DISABLED: LockerNameLabel.Color := LSC_DISABLED;
      else
        LockerNameLabel.Color := LSC_DISABLED;
      end;
      LayerNameLabel.Color := LLC_NORMAL;
      SexDivLabel.Color := LLC_NORMAL;
      MemberNameLabel.Color := LLC_NORMAL;
    end;
  end;
end;

procedure TLockerContainer.SetLockerStatus(const AValue: ShortInt);
begin
  if (FLockerStatus <> AValue) then
  begin
    Active := True;
    FLockerStatus := AValue;
    case FLockerStatus of
      CO_LOCKER_EMPTY: LockerNameLabel.Color := LSC_EMPTY;
      CO_LOCKER_INUSE: LockerNameLabel.Color := LSC_INUSE;
      CO_LOCKER_EXPIRED: LockerNameLabel.Color := LSC_EXPIRED;
    else
      LockerNameLabel.Color := LSC_DISABLED;
      Active := False;
    end;
  end;
end;

procedure TLockerContainer.SetSexDiv(const AValue: ShortInt);
begin
  if (FSexDiv <> AValue) then
  begin
    FSexDiv := AValue;
    case FSexDiv of
      CO_SEX_ALL: SexDivLabel.Font.Color := clGray;
      CO_SEX_MALE: SexDivLabel.Font.Color := $00FF901E;
      CO_SEX_FEMALE: SexDivLabel.Font.Color := $003535C0;
    else
      SexDivLabel.Font.Color := clGray;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPLockerViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
