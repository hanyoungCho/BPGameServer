(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 상품 목록 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPProdListView.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Data.DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxCheckBox, cxLabel, cxCurrencyEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPProdListViewForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panProdAmtType: TPanel;
    btnFeeDivBasic: TSpeedButton;
    btnFeeDivClub: TSpeedButton;
    btnFeeDivStudent: TSpeedButton;
    btnFeeDivMember: TSpeedButton;
    shpCategorySeparator: TShape;
    panFooter: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    DataSource: TDataSource;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V2: TcxGridDBBandedTableView;
    V3: TcxGridDBBandedTableView;
    V4: TcxGridDBBandedTableView;
    L1: TcxGridLevel;
    V1prod_nm: TcxGridDBBandedColumn;
    V1prod_detail_div_nm: TcxGridDBBandedColumn;
    V1prod_amt: TcxGridDBBandedColumn;
    V1apply_start_tm: TcxGridDBBandedColumn;
    V1apply_end_tm: TcxGridDBBandedColumn;
    V1use_game_cnt: TcxGridDBBandedColumn;
    V1use_game_min: TcxGridDBBandedColumn;
    V2prod_nm: TcxGridDBBandedColumn;
    V2prod_detail_div_nm: TcxGridDBBandedColumn;
    V2prod_amt: TcxGridDBBandedColumn;
    V2apply_start_time: TcxGridDBBandedColumn;
    V2apply_end_time: TcxGridDBBandedColumn;
    V2use_game_cnt: TcxGridDBBandedColumn;
    V2use_game_min: TcxGridDBBandedColumn;
    V3prod_nm: TcxGridDBBandedColumn;
    V3prod_detail_div_nm: TcxGridDBBandedColumn;
    V3prod_amt: TcxGridDBBandedColumn;
    V3apply_start_time: TcxGridDBBandedColumn;
    V3apply_end_time: TcxGridDBBandedColumn;
    V3use_game_cnt: TcxGridDBBandedColumn;
    V3use_game_min: TcxGridDBBandedColumn;
    V4prod_nm: TcxGridDBBandedColumn;
    V4prod_detail_div_nm: TcxGridDBBandedColumn;
    V4prod_amt: TcxGridDBBandedColumn;
    V4apply_start_time: TcxGridDBBandedColumn;
    V4apply_end_time: TcxGridDBBandedColumn;
    V4use_game_cnt: TcxGridDBBandedColumn;
    V4use_game_min: TcxGridDBBandedColumn;
    V1today_yn: TcxGridDBBandedColumn;
    V2today_yn: TcxGridDBBandedColumn;
    V3today_yn: TcxGridDBBandedColumn;
    V4today_yn: TcxGridDBBandedColumn;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure OnFeeDivButtonClick(Sender: TObject);
    procedure OnGridDBBandedTableViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
  private
    { Private declarations }
    FOwnerId: Integer;
    FIndex: ShortInt;
    FProdDiv: string;
    FProdDetailDiv: string;
    FFeeDiv: string;
    FGameDiv: ShortInt;
    FMemberNo: string;
    FMembershipOnly: Boolean;
    FTodayOnly: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure SetProdDivMode(const AValue: string);
    procedure SetFeeDivMode(const AValue: string);
    procedure RefreshDataSet;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPTemplateForm }

constructor TBPProdListViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  FIndex := -1;
  FFeeDiv := CO_GAMEFEE_BASIC;
  FMemberNo := '';
  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  btnFeeDivBasic.Down := True;
  btnFeeDivBasic.HelpKeyword := CO_GAMEFEE_BASIC; //일반
  btnFeeDivMember.HelpKeyword := CO_GAMEFEE_MEMBER; //회원
  btnFeeDivStudent.HelpKeyword := CO_GAMEFEE_STUDENT; //학생
  btnFeeDivClub.HelpKeyword := CO_GAMEFEE_CLUB; //클럽

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPProdListViewForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPProdListViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPProdListViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPProdListViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    FIndex := AMsg.ParamByInteger(CPP_INDEX); //레인 배정 화면에서 기본설정 상품과 볼러별 상품을 구분하기 위해 사용
    FGameDiv := AMsg.ParamByInteger(CPP_GAME_DIV);
    FProdDiv := AMsg.ParamByString(CPP_PROD_DIV);
    FProdDetailDiv := AMsg.ParamByString(CPP_PROD_DETAIL_DIV);
    FFeeDiv := AMsg.ParamByString(CPP_FEE_DIV);
    FMemberNo := AMsg.ParamByString(CPP_MEMBER_NO);
    FMembershipOnly := AMsg.ParamByBoolean(CPP_MEMBERSHIP_YN);
    FTodayOnly := AMsg.ParamByBoolean(CPP_TODAY_YN);
    btnFeeDivMember.Enabled := (not FMemberNo.IsEmpty);
    SetFeeDivMode(FFeeDiv);
    SetProdDivMode(FProdDiv);
    RefreshDataSet;
  end;
end;

procedure TBPProdListViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Self.Close;
    VK_RETURN:
      btnOK.Click;
  end;
end;

procedure TBPProdListViewForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPProdListViewForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPProdListViewForm.OnFeeDivButtonClick(Sender: TObject);
var
  LResMsg: string;
begin
  FFeeDiv := TSpeedButton(Sender).HelpKeyword;
  if not BPDM.OpenProdDataSet(FGameDiv, FProdDiv, FProdDetailDiv, FFeeDiv, FMembershipOnly, FTodayOnly, LResMsg) then
    raise Exception.Create(LResMsg);
end;

procedure TBPProdListViewForm.btnOKClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  with DataSource.DataSet do
  begin
    if (RecordCount = 0) or
       not FieldByName('today_yn').AsBoolean then
      Exit;
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_SEL_PROD_GAME;
      PM.AddParams(CPP_INDEX, FIndex); //레인 배정 화면에서 기본설정 상품과 볼러별 상품을 구분하기 위해 사용
      PM.AddParams(CPP_PROD_DIV, FProdDiv);
      PM.AddParams(CPP_PROD_DETAIL_DIV, FieldByName('prod_detail_div').AsString);
      PM.AddParams(CPP_FEE_DIV, FieldByName('fee_div').AsString);
      PM.AddParams(CPP_PROD_CD, FieldByName('prod_cd').AsString);
      PM.AddParams(CPP_PROD_NM, FieldByName('prod_nm').AsString);
      PM.AddParams(CPP_VALUE, FieldByName('prod_amt').AsInteger);
      PM.AddParams(CPP_MEMBERSHIP_SEQ, 0);
      PM.AddParams(CPP_GAME_CNT, FieldByName('use_game_cnt').AsInteger);
      PM.AddParams(CPP_GAME_MIN, FieldByName('use_game_min').AsInteger);
      PM.PluginMessageToId(FOwnerId);
      Self.ModalResult := mrOK;
    finally
      FreeAndNil(PM);
    end;
  end;
end;

procedure TBPProdListViewForm.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TBPProdListViewForm.SetFeeDivMode(const AValue: string);
begin
  if (AValue = CO_GAMEFEE_BASIC) then
    btnFeeDivBasic.Down := True
  else if ((AValue = CO_GAMEFEE_MEMBER) and (not FMemberNo.IsEmpty)) then
    btnFeeDivMember.Down := True
  else if (AValue = CO_GAMEFEE_STUDENT) then
    btnFeeDivStudent.Down := True
  else if (AValue = CO_GAMEFEE_CLUB) then
    btnFeeDivClub.Down := True;
end;

procedure TBPProdListViewForm.SetProdDivMode(const AValue: string);
begin
  if (AValue = CO_PROD_GAME) then
  begin
    panHeader.Caption := '게임 상품 조회';
    case FGameDiv of
      CO_RATEPLAN_GAME:
        panHeader.Caption := '게임 요금제 ' + panHeader.Caption;
      CO_RATEPLAN_TIME:
        panHeader.Caption := '시간 요금제 ' + panHeader.Caption;
    end;
    DataSource.DataSet := BPDM.QRProdGame;
    L1.GridView := V1;
  end
  else if (AValue = CO_PROD_LOCKER) then
  begin
    panHeader.Caption := '라커 상품 조회';
    DataSource.DataSet := BPDM.QRProdLocker;
    L1.GridView := V2;
  end
  else if (AValue = CO_PROD_GENERAL) then
  begin
    panHeader.Caption := '일반 상품 조회';
    DataSource.DataSet := BPDM.QRProdGeneral;
    L1.GridView := V3;
  end
  else if (AValue = CO_PROD_RENT) then
  begin
    panHeader.Caption := '대여 상품 조회';
    DataSource.DataSet := BPDM.QRProdRent;
    L1.GridView := V4;
  end
  else
    DataSource.DataSet := nil;
end;

procedure TBPProdListViewForm.RefreshDataSet;
var
  LResMsg: string;
begin
  try
    if not BPDM.GetProdGameList(LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.OpenProdDataSet(FGameDiv, FProdDiv, FProdDetailDiv, FFeeDiv, FMembershipOnly, FTodayOnly, LResMsg) then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '상품 목록을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPProdListViewForm.OnGridDBBandedTableViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('today_yn').Index] <> True) then
    ACanvas.Font.Color := $00544ED6;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPProdListViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.