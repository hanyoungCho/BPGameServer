(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 웹브라우저 팝업형(Modal) 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPWebViewPopup.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Winapi.WebView2, Winapi.ActiveX, Vcl.Edge,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPWebViewPopupForm = class(TPluginModule)
    WB: TEdgeBrowser;
    panHeader: TPanel;
    panNavigator: TPanel;
    panHeaderMenuBar: TPanel;
    ckbNoMoreToday: TCheckBox;
    tmrRunOnce: TTimer;
    btnMainMenu: TSpeedButton;
    btnBack: TSpeedButton;
    btnForward: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnStop: TSpeedButton;
    btnHome: TSpeedButton;
    panClose: TPanel;
    btnClose: TSpeedButton;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WBCreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
    procedure tmrRunOnceTimer(Sender: TObject);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ckbNoMoreTodayClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FNaviUrl: string;

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

{ TBPWebViewPopupForm }

constructor TBPWebViewPopupForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  LF := TLayeredForm.Create(nil);
  LF.Show;
  ckbNoMoreToday.Checked := (Global.Config.LastNoticeDate = Global.DateTime.CurrentDate);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrRunOnce.Enabled := True;
end;

destructor TBPWebViewPopupForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPWebViewPopupForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPWebViewPopupForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPWebViewPopupForm.ProcessMessages(AMsg: TPluginMessage);
var
  sTitle: string;
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    sTitle := AMsg.ParamByString(CPP_TITLE);
    if not sTitle.IsEmpty then
      panHeader.Caption := sTitle;
    panNavigator.Visible := AMsg.ParamByBoolean(CPP_SHOW_NAVBTN);
    ckbNoMoreToday.Visible := AMsg.ParamByBoolean(CPP_SHOW_NOMORE);
    FNaviUrl := AMsg.ParamByString(CPP_URL);
    if FNaviUrl.IsEmpty then
      FNaviUrl := 'about:blank';
  end;
end;

procedure TBPWebViewPopupForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Self.Close;
    VK_ADD:
      if ssCtrl in Shift then
        WB.ZoomFactor := WB.ZoomFactor + 0.1;
    VK_SUBTRACT:
      if ssCtrl in Shift then
        WB.ZoomFactor := WB.ZoomFactor - 0.1;
  end;
end;

procedure TBPWebViewPopupForm.WBCreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
  btnBack.Enabled := WB.CanGoBack;
  btnForward.Enabled := WB.CanGoForward;
  btnRefresh.Enabled := WB.WebViewCreated;
  btnStop.Enabled := True;
  btnHome.Enabled := True;
end;

procedure TBPWebViewPopupForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPWebViewPopupForm.ckbNoMoreTodayClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    Global.Config.LastNoticeDate := Global.DateTime.CurrentDate
  else
    Global.Config.LastNoticeDate := '';

  Global.Setting.Local.WriteString('Config', 'LastNoticeDate', Global.Config.LastNoticeDate);
end;

procedure TBPWebViewPopupForm.btnBackClick(Sender: TObject);
begin
  WB.GoBack;
end;

procedure TBPWebViewPopupForm.btnForwardClick(Sender: TObject);
begin
  WB.GoForward;
end;

procedure TBPWebViewPopupForm.btnRefreshClick(Sender: TObject);
begin
  WB.Refresh;
end;

procedure TBPWebViewPopupForm.btnStopClick(Sender: TObject);
begin
  WB.Stop;
end;

procedure TBPWebViewPopupForm.btnHomeClick(Sender: TObject);
begin
  WB.Navigate(FNaviUrl);
end;

procedure TBPWebViewPopupForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPWebViewPopupForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    WB.Navigate(FNaviUrl);
    WB.SetFocus;
  finally
    Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPWebViewPopupForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.