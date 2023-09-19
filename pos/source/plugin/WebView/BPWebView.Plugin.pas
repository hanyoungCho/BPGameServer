(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 웹 브라우저 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPWebView.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Winapi.WebView2, Winapi.ActiveX, Vcl.Edge,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPWebViewForm = class(TPluginModule)
    WB: TEdgeBrowser;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
  private
    { Private declarations }
    FOwnerID: Integer;
    FBaseTitle: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
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
  Vcl.Dialogs,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib;

{$R *.dfm}

{ TBPWebViewForm }

constructor TBPWebViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerID := 0;
  WB.UserDataFolder := Global.DirInfo.WebCacheDir;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPWebViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBPWebViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Global.Plugin.WebViewPluginId := 0;
  Action := caFree;
end;

procedure TBPWebViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPWebViewForm.ProcessMessages(AMsg: TPluginMessage);
var
  sValue: string;
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
    FBaseTitle := AMsg.ParamByString(CPP_TITLE);
    BaseTitle := FBaseTitle;
  end
  else if (AMsg.Command = CPC_CLOSE) then
    Self.Close
  else if (AMsg.Command = CPC_ACTIVE) then
  begin
    if (GetForegroundWindow <> Self.Handle) then
      SetForegroundWindow(Self.Handle);
    BaseTitle := FBaseTitle;
  end
  else if (AMsg.Command = CPC_NAVIGATE) then
  begin
    FBaseTitle := AMsg.ParamByString(CPP_TITLE);
    BaseTitle := FBaseTitle;
    sValue := AMsg.ParamByString(CPP_VALUE);
    if (Self.Align = alClient) then
      Self.BringToFront
    else
      SetForegroundWindow(Self.Handle);

    if sValue.IsEmpty then
      sValue := 'about:blank';
    WB.Navigate(sValue);
  end;
end;

procedure TBPWebViewForm.SetBaseTitle(const AValue: string);
begin
  FBaseTitle := AValue;
  if not FBaseTitle.IsEmpty then
    Global.Title := FBaseTitle;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPWebViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.