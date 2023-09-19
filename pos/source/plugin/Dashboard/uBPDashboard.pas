(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 대시보드
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit uBPDashboard;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.CategoryButtons,
  Vcl.WinXCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages;

{$I ..\..\common\BPCommon.inc}

type
  TBPDashboardForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolBar: TPanel;
    btnClose: TSpeedButton;
    panHeaderrMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    btnLogin: TSpeedButton;

    procedure PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FWebViewStartPage: string;
    FPartnerCenterLoaded: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoInit;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Project }
  uBPGlobal, uBPDM, uBPCommonLib;

{$R *.dfm}

{ TBPDashboardForm }

constructor TBPDashboardForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOwnerID := 0;
  FWebViewStartPage := 'file://' + ExpandFileName(Global.DirInfo.ContentsDir) + 'index.html';
  FPartnerCenterLoaded := False;

  SetDoubleBuffered(Self, True);
  lblAppVersion.Caption := Format('v%s', [Global.AppInfo.ProductVersion]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPDashboardForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBPDashboardForm.PluginModuleCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  if (XGMsgBox(Self.Handle, mtConfirmation, '확인', '프로그램을 종료하시겠습니까?', ['종료', '취소']) = mrOk) then
//  begin
    CanClose := True;
    SendMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
//  end;
end;

procedure TBPDashboardForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Global.PluginInfo.DashboardId := 0;
  Action := caFree;
end;

procedure TBPDashboardForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPDashboardForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

procedure TBPDashboardForm.DoInit;
begin
end;

procedure TBPDashboardForm.btnLoginClick(Sender: TObject);
begin
  ShowWebView(Self.PluginID, panBaseFrame, FWebViewStartPage);
end;

procedure TBPDashboardForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPDashboardForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.