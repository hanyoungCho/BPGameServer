(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 로그인 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPLogin.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, Vcl.Imaging.pngimage,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPLoginForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    lblNotice: TLabel;
    imgLogin: TImage;
    edtUserId: TLabeledEdit;
    edtPassword: TLabeledEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ckbSaveId: TCheckBox;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Project }
  Common.BPGlobal, Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPLoginForm }

constructor TBPLoginForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerID := 0;
  LF := TLayeredForm.Create(nil);
  LF.Show;

  panHeader.Hint := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  if Global.UserInfo.SaveId then
  begin
    edtUserId.Text := Global.UserInfo.UserId;
    {$IFDEF DEBUG}
    edtPassword.Text := '12345678';
    {$ENDIF}
    ckbSaveId.Checked := True;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPLoginForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPLoginForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPLoginForm.PluginModuleShow(Sender: TObject);
begin
  if (edtUserId.Text <> '') then
    edtPassword.SetFocus;
end;

procedure TBPLoginForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPLoginForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
end;

procedure TBPLoginForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Self.Close;
    VK_RETURN:
      SelectNext(ActiveControl, True, True);
  end;
end;

procedure TBPLoginForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPLoginForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPLoginForm.btnOKClick(Sender: TObject);
begin
  Global.UserInfo.UserId := edtUserId.Text;
  Global.UserInfo.TerminalPwd := edtPassword.Text;
  Global.UserInfo.SaveId := ckbSaveId.Checked;
  if not (Global.UserInfo.UserId.IsEmpty or Global.UserInfo.TerminalPwd.IsEmpty) then
    Self.ModalResult := mrOK;
end;

procedure TBPLoginForm.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPLoginForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.