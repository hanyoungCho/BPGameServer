(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 숫자키 패드 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPNumPad.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPNumPadForm = class(TPluginModule)
    btnNum7: TBitBtn;
    btnNum8: TBitBtn;
    btnNum9: TBitBtn;
    btnNumBS: TBitBtn;
    btnNumCL: TBitBtn;
    btnNum6: TBitBtn;
    btnNum5: TBitBtn;
    btnNum4: TBitBtn;
    btnNum1: TBitBtn;
    btnNum2: TBitBtn;
    btnNum3: TBitBtn;
    btnNumCR: TBitBtn;
    btnNum000: TBitBtn;
    btnNum00: TBitBtn;
    btnNum0: TBitBtn;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure OnNumPadButtonClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FUseDotKey: Boolean;

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
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib;

{$R *.dfm}

{ TBPNumPadForm }

constructor TBPNumPadForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOwnerId := 0;
  FUseDotKey := False;
  SetDoubleBuffered(Self, True);
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPNumPadForm.Destroy;
begin

  inherited Destroy;
end;

procedure TBPNumPadForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPNumPadForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPNumPadForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId  := AMsg.ParamByInteger(CPP_OWNER_ID);
    FUseDotKey := AMsg.ParamByBoolean(CPP_USE_DOTKEY);
    if FUseDotKey then
    begin
      btnNum000.Caption := '.';
      btnNum000.Tag := 190;
      btnNum000.HelpContext := 0;
    end;
  end;
end;

procedure TBPNumPadForm.OnNumPadButtonClick(Sender: TObject);
var
  nKey, nRepeat: integer;
begin
  with TButton(Sender) do
  begin
    nKey := Tag;
    nRepeat := HelpContext;
  end;

  if (nRepeat = 0) then
    nRepeat := 1;
  for var I: ShortInt := 1 to nRepeat do
  begin
    SimulateKeyDown(nKey);
    SimulateKeyUp(nKey);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPNumPadForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.