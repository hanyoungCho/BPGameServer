(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 날씨 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPWeather.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages, dxGDIPlusClasses, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, Data.DB, cxDBData, cxCalendar, cxImage,
  cxLabel, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPWeatherForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderMenuBar: TPanel;
    panHeaderToolbar: TPanel;
    imgProvider: TImage;
    lblPluginVersion: TLabel;
    btnMainMenu: TSpeedButton;
    btnClose: TSpeedButton;
    btnRefresh: TSpeedButton;
    rbtToday: TRadioButton;
    rbtWeek: TRadioButton;
    dsrWeatherToday: TDataSource;
    dsrWeatherWeek: TDataSource;
    G1: TcxGrid;
    L1: TcxGridLevel;
    V1: TcxGridDBTableView;
    V1datetime: TcxGridDBColumn;
    V1icon: TcxGridDBColumn;
    V1condition: TcxGridDBColumn;
    V1temper: TcxGridDBColumn;
    V1precipit: TcxGridDBColumn;
    V1humidity: TcxGridDBColumn;
    V1wind_speed: TcxGridDBColumn;
    V2: TcxGridDBTableView;
    V2datetime: TcxGridDBColumn;
    V2icon: TcxGridDBColumn;
    V2condition: TcxGridDBColumn;
    V2temper: TcxGridDBColumn;
    V2precipit: TcxGridDBColumn;
    V2humidity: TcxGridDBColumn;
    V2wind_speed: TcxGridDBColumn;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure rbtTodayClick(Sender: TObject);
    procedure rbtWeekClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPWeatherForm }


constructor TBPWeatherForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOwnerId := 0;
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  MakeRoundedControl(G1);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPWeatherForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPWeatherForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPWeatherForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPWeatherForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TBPWeatherForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;

procedure TBPWeatherForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPWeatherForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPWeatherForm.btnRefreshClick(Sender: TObject);
begin
  BPDM.GetWeatherInfo;
end;

procedure TBPWeatherForm.rbtTodayClick(Sender: TObject);
begin
  panHeader.Caption := '금일 날씨 동향';
  L1.GridView := V1;
end;

procedure TBPWeatherForm.rbtWeekClick(Sender: TObject);
begin
  panHeader.Caption := '주간 날씨 동향';
  L1.GridView := V2;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPWeatherForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.