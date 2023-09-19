(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 사용자 환경 설정 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPSettingLocal.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, Vcl.ComCtrls,
  { EhLib }
  DBCtrlsEh,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPSettingLocalForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    panPageTitle: TPanel;
    pgcSetting: TPageControl;
    tabBasic: TTabSheet;
    tabWakeOnLan: TTabSheet;
    tabWeather: TTabSheet;
    panToolbar: TPanel;
    btnPage2: TSpeedButton;
    btnPage0: TSpeedButton;
    btnSaveSetting: TBitBtn;
    btnPage3: TSpeedButton;
    lblNoticeRemote: TLabel;
    rdgThemeStyle: TRadioGroup;
    ckbHideTaskBar: TDBCheckBoxEh;
    ckbSelfCashReceipt: TDBCheckBoxEh;
    ckbAutoRunAdminCall: TDBCheckBoxEh;
    edtReceiptCopies: TDBNumberEditEh;
    edtWeatherApiKey: TDBEditEh;
    edtWeatherLatitude: TDBEditEh;
    edtWeatherLongitude: TDBEditEh;
    edtWeatherApiHost: TDBEditEh;
    btnWeatherSite: TBitBtn;
    btnWeatherApiTest: TBitBtn;
    mmoWakeOnLan: TMemo;
    btnPage4: TSpeedButton;
    tabTest: TTabSheet;
    mmoTestLog: TMemo;
    panTestToolbar: TPanel;
    btnHexBin: TBitBtn;
    btlSaveLog: TBitBtn;
    btnClearLog: TBitBtn;
    edtTestValue: TDBEditEh;
    cbxTestValueType: TDBComboBoxEh;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure OnPageButtonClick(Sender: TObject);
    procedure btnSaveSettingClick(Sender: TObject);
    procedure edtWeatherApiKeyDblClick(Sender: TObject);
    procedure btnWeatherSiteClick(Sender: TObject);
    procedure btnWeatherApiTestClick(Sender: TObject);
    procedure btnHexBinClick(Sender: TObject);
    procedure btlSaveLogClick(Sender: TObject);
    procedure btnClearLogClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ReadSetting;
    procedure WriteSetting;
    procedure DoHexBinTest(const AInputType: ShortInt);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Winapi.ShellApi, Vcl.Dialogs, System.Math, System.StrUtils,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPSettingLocalForm }

constructor TBPSettingLocalForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
{$IFDEF RELEASE}
  btnHexBin.Visible := False;
{$ENDIF}

  FOwnerId := 0;
  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  cbxTestValueType.ItemIndex := 0;
  with pgcSetting do
  begin
    for var I: ShortInt := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
  end;

  ReadSetting;
  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPSettingLocalForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPSettingLocalForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPSettingLocalForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPSettingLocalForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

procedure TBPSettingLocalForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;

procedure TBPSettingLocalForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPSettingLocalForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPSettingLocalForm.edtWeatherApiKeyDblClick(Sender: TObject);
begin
  with TDBEditEh(Sender) do
    if (PasswordChar = #0) then
      PasswordChar := #42
    else
      PasswordChar := #0;
end;

procedure TBPSettingLocalForm.OnPageButtonClick(Sender: TObject);
begin
  with TSpeedButton(Sender) do
  begin
    panPageTitle.Caption := Caption + ' 설정';
    pgcSetting.ActivePageIndex := Tag;
  end;
end;

procedure TBPSettingLocalForm.btnHexBinClick(Sender: TObject);
begin
  mmoTestLog.Clear;
  DoHexBinTest(cbxTestValueType.ItemIndex);
end;

procedure TBPSettingLocalForm.btlSaveLogClick(Sender: TObject);
begin
  UpdateLog(Global.DirInfo.LogDir + Format('test_%s.log', [Global.DateTime.CurrentDateTime]), mmoTestLog.Text);
end;

procedure TBPSettingLocalForm.btnClearLogClick(Sender: TObject);
begin
  mmoTestLog.Clear;
end;

procedure TBPSettingLocalForm.btnSaveSettingClick(Sender: TObject);
begin
  WriteSetting;
  Self.ModalResult := mrOK;
end;

procedure TBPSettingLocalForm.btnWeatherSiteClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(CO_URL_WEATHER), nil, nil, SW_SHOW);
end;

procedure TBPSettingLocalForm.btnWeatherApiTestClick(Sender: TObject);
var
  LResMsg: string;
begin
  with Global.WeatherInfo do
  begin
    Host := ExcludeTrailingPathDelimiter(edtWeatherApiHost.Text);
    ApiKey := edtWeatherApiKey.Text;
    Latitude := edtWeatherLatitude.Text;
    Longitude := edtWeatherLongitude.Text;
    Enabled := not (Host.IsEmpty or Latitude.IsEmpty or Longitude.IsEmpty or ApiKey.IsEmpty);
  end;

  if BPDM.GetWeatherInfo(LResMsg) then
    BPMsgBox(Self.Handle, mtInformation, '알림', '날씨 정보 조회 API가 정상적으로 완료되었습니다.' , ['확인'], 5)
  else
    BPMsgBox(Self.Handle, mtError, '알림', LResMsg, ['확인'], 5);
end;

procedure TBPSettingLocalForm.ReadSetting;
begin
  { 기본 설정 }
  rdgThemeStyle.ItemIndex := IfThen(Global.Config.DarkMode, 1, 0);
  ckbHideTaskBar.Checked := Global.Config.HideTaskBar;
  ckbSelfCashReceipt.Checked := Global.Config.SelfCashReceipt;
  edtReceiptCopies.Value := Global.ReceiptPrinter.Copies;

  { 알리미 }
  ckbAutoRunAdminCall.Checked := Global.AdminCall.AutoRun;

  { 날씨 정보 }
  edtWeatherApiHost.Text := Global.WeatherInfo.Host;
  edtWeatherLatitude.Text := Global.WeatherInfo.Latitude;
  edtWeatherLongitude.Text := Global.WeatherInfo.Longitude;
  edtWeatherApiKey.Text := Global.WeatherInfo.ApiKey;

  { 원격 시동 설정 }
  if FileExists(Global.WakeupListFileName) then
    mmoWakeOnLan.Lines.LoadFromFile(Global.WakeupListFileName);
end;

procedure TBPSettingLocalForm.WriteSetting;
begin
  with Global.Setting.Local do
  begin
    { 기본 설정 }
    WriteBool('Config', 'DarkMode', (rdgThemeStyle.ItemIndex = 1));
    WriteBool('Config', 'HideTaskBar', ckbHideTaskBar.Checked);
    WriteBool('Config', 'SelfCashReceipt', ckbSelfCashReceipt.Checked);
    WriteInteger('Config', 'ReceiptCopies', edtReceiptCopies.Value);

    { 알리미 }
    WriteBool('AdminCall', 'AutoRun', ckbAutoRunAdminCall.Checked);

    { 날씨 정보 }
    WriteString('Weather', 'Host', edtWeatherApiHost.Text);
    WriteString('Weather', 'Latitude', edtWeatherLatitude.Text);
    WriteString('Weather', 'Longitude', edtWeatherLongitude.Text);
    WriteString('Weather', 'ApiKey', StrEncrypt(edtWeatherApiKey.Text));

    Global.ReadLocalSetting;
  end;

  { 원격 시동 설정 }
  if (mmoWakeOnLan.Lines.Count > 0) then
    mmoWakeOnLan.Lines.SaveToFile(Global.WakeupListFileName)
  else
    DeleteFile(Global.WakeupListFileName);
end;

procedure TBPSettingLocalForm.DoHexBinTest(const AInputType: ShortInt);
var
  LBinStr, LHexStr, LString, LOrdStr: string;
begin
  case AInputType of
    0: //HEX
      begin
        edtTestValue.Text := StringReplace(edtTestValue.Text, ' ', '', [rfReplaceAll]);
        LHexStr := edtTestValue.Text;
        LBinStr := HexaStringToBinString(LHexStr);
        LString := HexaStringToString(LHexStr);
      end;
    1: //BIN
      begin
        edtTestValue.Text := StringReplace(edtTestValue.Text, ' ', '', [rfReplaceAll]);
        LBinStr := edtTestValue.Text;
        LHexStr := IntegerToHexaString(BinStringToInteger(LBinStr), Length(LBinStr) div 8);
        LString := Char(BinStringToInteger(LBinStr));
      end;
    2: //STR
      begin
        LString := edtTestValue.Text;
        LHexStr := StringToHexaString(LString);
        LBinStr := StringToBinString(LString);
      end;
  end;
  mmoTestLog.Lines.Add(Format('HEX = %s', [LHexStr]));
  mmoTestLog.Lines.Add(Format('BIN = %s', [LBinStr]));
  mmoTestLog.Lines.Add(Format('STR = %s', [LString]));
  LOrdStr := '';
  for var I: ShortInt := 1 to Length(LString) do
    LOrdStr := LOrdStr + Format(' #%d', [Ord(LString[I])]);
  mmoTestLog.Lines.Add(Format('CHR = %s', [Trim(LOrdStr)]));
  (*
  LHexStr := '03F7';
  LBinStr := '0000001111110111';
  LHexStr := Trim(edtTestValue.Text);
  LBinStr := RightStr(HexStrToBinStr(LHexStr), Length(LHexStr) * 4);
  mmoTestLog.Lines.Add(Format('INP/BIN = %s -> %s ', [LHexStr, LBinStr]));

  LHexStr := IntToHexStr(BinStrToInt(LBinStr), 4);
  mmoTestLog.Lines.Add(Format('BIN/HEX = %s -> %s ', [LBinStr, LHexStr]));

  LHexStr := IntToHexStr(BinStrToInt(LBinStr), 4);
  LBinStr := RightStr(HexStrToBinStr(LHexStr), Length(LHexStr) * 4);
  mmoTestLog.Lines.Add(Format('HEX/BIN = %s -> %s', [LHexStr, LBinStr]));

  LString := Char(BinStrToInt(LBinStr));
  mmoTestLog.Lines.Add(Format('BIN/STR = %s -> %s (%d)', [LBinStr, LString, Ord(LString[1])]));

  LHexStr := StringToHexStr(LString);
  mmoTestLog.Lines.Add(Format('STR/HEX = %s -> %s', [LString, LHexStr]));
  mmoTestLog.Lines.Add(StringOfChar('-', 50));
  *)
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPSettingLocalForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.