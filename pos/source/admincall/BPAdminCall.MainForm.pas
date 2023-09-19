{$M+}
unit BPAdminCall.MainForm;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Forms,
  Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus, System.IniFiles,
  { DevExpress }
  dxGDIPlusClasses, cxClasses, cxGraphics,
  { Indy }
  IdBaseComponent, IdComponent, IdContext, IdCustomTCPServer, IdTCPServer,
  { SolbiLib }
  TransparentForm, cyBaseSpeedButton, cySpeedButton, MSNPopUp;

const
  WM_NOTIFY_PUSH_POPUP = WM_USER + 444;

type
  TNotifyStatusThread = class(TThread)
  private
    FNotifyActive: Boolean;
    FLastWorked: TDateTime;
    FInterval: Integer;
    FErrorMode: Boolean;
    FErrorCode: Integer;
    FErrorMsg: string;
    FBlinked: Boolean;

    procedure SetErrorCode(const AValue: Integer);
  protected
    procedure Execute; override;
  published
    constructor Create(const ACreateSuspended: Boolean);
    destructor Destroy; override;

    property NotifyActive: Boolean read FNotifyActive write FNotifyActive;
    property Interval: Integer read FInterval write FInterval default 300;
    property LastWorked: TDateTime read FLastWorked write FLastWorked;
    property ErrorCode: Integer read FErrorCode write SetErrorCode;
    property ErrorMsg: string read FErrorMsg write FErrorMsg;
  end;

  TBPAdminCallForm = class(TForm)
    TransparentForm: TTransparentForm;
    imcStatus: TcxImageCollection;
    itmBlinkOn: TcxImageCollectionItem;
    itmBlinkOff: TcxImageCollectionItem;
    TCPServer: TIdTCPServer;
    imgBack: TImage;
    imgNotify: TImage;
    PopupMenu: TPopupMenu;
    mniConfig: TMenuItem;
    mniClose: TMenuItem;
    tmrClock: TTimer;
    itmReady: TcxImageCollectionItem;
    msnPopup: TMSNPopUp;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TCPServerExecute(AContext: TIdContext);
    procedure tmrClockTimer(Sender: TObject);
    procedure imgNotifyDblClick(Sender: TObject);
    procedure mniConfigClick(Sender: TObject);
    procedure mniCloseClick(Sender: TObject);
    procedure imgNotifyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure msnPopupClick(Sender: TObject);
  private
    { Private declarations }
    FClosing: Boolean;
    FIniFile: TIniFile;
    FHomeDir: string;
    FConfigDir: string;
    FIsFirst: Boolean;
    FServerPort: Integer;

    procedure WindowPosChange(var AMessage: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure ShowConfig;
    procedure CheckConfig;
    procedure ReadConfig;
    procedure UpdateConfig;
    procedure UpdateLog(const AValue: string);
  protected
    procedure CreateParams(var AParams: TCreateParams); override;
    procedure WndProc(var AMsg: TMessage); override;
  public
    { Public declarations }
  end;

var
  BPAdminCallForm: TBPAdminCallForm;
  FMediaDir: string;
  FNotifyWithPopup: Boolean;
  FNotifyWithSound: Boolean;
  FNotifyDuration: Integer;
  FNotifyStatusThread: TNotifyStatusThread;
  FLogList: TStrings;
  FLogCS: TRTLCriticalSection;

implementation

uses
  { Native }
  System.DateUtils, Vcl.Dialogs, Winapi.MMSystem,
  { Indy }
  IdGlobal, IdException, IdStack, JSON,
  { Project }
  BPAdminCall.ConfigForm;

{$R *.dfm}

procedure FreeAndNilJSONObject(AObject: TJSONAncestor);
begin
  try
    if Assigned(AObject) then
    begin
      AObject.Owned := False;
      AObject.Free;
    end;
  except
  end;
end;

function GetAppVersion(const AIndex: integer): string;
const
  VERSION_INFO: array[0..9] of string = (
    'CompanyName',
    'FileDescription',
    'FileVersion',
    'InternalName',
    'LegalCopyright',
    'LegalTradeMarks',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments');
var
  s, Locale: string;
  n, Len: DWORD;
  P: Pointer;
  Buf: PChar;
  Value: PChar;
begin
  Result := '?';
  s := Application.ExeName;
  n := GetFileVersionInfoSize(PChar(s), n);
  if (n > 0) then
  begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(s), 0, n, Buf);
      VerQueryValue(Buf, 'VarFileInfo\Translation', P, Len);
      Locale := IntToHex(MakeLong(HiWord(Longint(P^)), LoWord(Longint(P^))), 8);
      if VerQueryValue(Buf, PChar('StringFileInfo\' + Locale + '\' + VERSION_INFO[AIndex]), Pointer(Value), Len) then
        Result := Trim(Value);
    finally
      FreeMem(Buf, n);
    end;
  end;
end;

{ TBPAdminCallForm }

procedure TBPAdminCallForm.CreateParams(var AParams: TCreateParams);
begin
  inherited;

  AParams.WndParent := 0;
end;

procedure TBPAdminCallForm.WndProc(var AMsg: TMessage);
begin
  case AMsg.Msg of
    WM_NOTIFY_PUSH_POPUP:
      begin
        msnPopup.Text := FormatDateTime('[yyyy-mm-dd hh:nn:ss]', Now) + #13#10 + FNotifyStatusThread.ErrorMsg;
        msnPopup.TextAlignment := taLeftJustify;
        msnPopup.ShowPopUp;
      end;
  end;

  inherited WndProc(AMsg);
end;

procedure TBPAdminCallForm.WindowPosChange(var AMessage: TWMWindowPosChanging);
begin
  //AMessage.WindowPos.X := Left; //Can't X Position Movable
  AMessage.WindowPos.Y := 0; //Can't Y Position Movable
  AMessage.Result := 0;
end;

procedure TBPAdminCallForm.FormCreate(Sender: TObject);
begin
  imgBack.Visible := True;

  FIsFirst := True;
  FLogList := TStringList.Create;
  FHomeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  FConfigDir := FHomeDir + 'config\';
  FMediaDir := FHomeDir + 'media\';
  ForceDirectories(FConfigDir);

  Self.Height := imgBack.Height;
  Self.Width := imgBack.Width;
  Self.FormStyle := fsStayOnTop;
  imgNotify.Picture.Assign(imcStatus.Items[0].Picture);
  imgNotify.Hint := '마우스로 드래그하여 위치를 변경할 수 있습니다.';

  FIniFile := TIniFile.Create(FConfigDir + ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '.config');
  CheckConfig;
  ReadConfig;

  tmrClock.Enabled := True;
end;

procedure TBPAdminCallForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TCPServer.Active := False;
  UpdateConfig;
  FreeAndNil(FLogList);
end;

procedure TBPAdminCallForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FClosing;
end;

procedure TBPAdminCallForm.imgNotifyDblClick(Sender: TObject);
begin
  FNotifyStatusThread.ErrorCode := 0;
  msnPopup.ClosePopUps;
end;

procedure TBPAdminCallForm.imgNotifyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPAdminCallForm.msnPopupClick(Sender: TObject);
begin
  msnPopup.ClosePopUps;
end;

procedure TBPAdminCallForm.mniConfigClick(Sender: TObject);
begin
  ShowConfig;
end;

procedure TBPAdminCallForm.mniCloseClick(Sender: TObject);
begin
  FClosing := True;
  Close;
end;

procedure TBPAdminCallForm.TCPServerExecute(AContext: TIdContext);
var
  RBS: RawByteString;
  JO, RO: TJSONObject;
  nErrorCode: Integer;
  sErrorMsg, sPeerIP, sSenderId, sResultCode, sResultMsg: string;
begin
  if (AContext.Connection = nil) or
     (not AContext.Connection.Connected) then
    Exit;

  try
    sResultCode := '9999';
    sResultMsg := '장애가 발생하여 요청을 처리할 수 없습니다.';
    JO := nil;
    RO := nil;
    try
      AContext.Connection.IOHandler.MaxLineLength := MaxInt;
      sPeerIP := AContext.Connection.Socket.Binding.PeerIP;
      RBS := AContext.Connection.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      try
        JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        RO := TJSONObject.Create;
        if JO.FindValue('error_cd').Null then
        begin
          sResultCode := '9991';
          sResultMsg := '잘못된 요청 전문 = ' + JO.ToString;
          raise Exception.Create('Error Message');
        end;

        nErrorCode := StrToIntDef(JO.GetValue('error_cd').Value, -1);
        sErrorMsg := JO.GetValue('error_msg').Value;
        sSenderId := JO.GetValue('sender_id').Value;
        if (nErrorCode >= 0) then
        begin
          FNotifyStatusThread.ErrorMsg := sErrorMsg;
          FNotifyStatusThread.ErrorCode := nErrorCode;
          if FNotifyWithPopup then
            SendMessage(Self.Handle, WM_NOTIFY_PUSH_POPUP, 0, 0);

          UpdateLog(Format('%s %s %s', [sPeerIP, sSenderId, FNotifyStatusThread.ErrorMsg]));
        end;

        sResultCode := '0000';
        sResultMsg := '정상적으로 처리 되었습니다.';
      except
        on E: Exception do
          UpdateLog(Format('ServerExecute.ListenError=%s', [E.Message]));
      end;

      RO.AddPair(TJSONPair.Create('result_cd', sResultCode));
      RO.AddPair(TJSONPair.Create('result_msg', sResultMsg));
      AContext.Connection.IOHandler.WriteLn(RO.ToString, IndyTextEncoding_UTF8);
    finally
      AContext.Connection.Disconnect;
      FreeAndNilJSONObject(JO);
      FreeAndNilJSONObject(RO);
    end;
  except
    on E: EIdConnClosedGracefully do;
    on E: EIdSocketError do;
    on E: Exception do
    begin
      sResultCode := '9999';
      sResultMsg := E.Message;
      UpdateLog(Format('ServerExecute.SocketError=%s', [E.Message]));
    end;
  end;
end;

procedure TBPAdminCallForm.tmrClockTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    try
      Enabled := False;
      if FIsFirst then
      begin
        FIsFirst := False;
        Interval := 500;

        if not Assigned(FNotifyStatusThread) then
          FNotifyStatusThread := TNotifyStatusThread.Create(True);
        if (not FNotifyStatusThread.Started) then
          FNotifyStatusThread.Start;

        TCPServer.DefaultPort := FServerPort;
        TCPServer.Active := True;

        msnPopup.Title := 'XTouch 알리미';
        msnPopup.Text := '알리미 프로그램이 실행 되었습니다.';
        msnPopup.ShowPopUp;
        UpdateLog('프로그램 시작');
      end;
    finally
      Enabled := True;
    end;
  except
  end;
end;

procedure TBPAdminCallForm.ShowConfig;
var
  CF: TConfigForm;
  nPort: Integer;
begin
  CF := TConfigForm.Create(nil);
  try
    CF.Caption := ' XTouch 알리미 v' + GetAppVersion(2);
    CF.Top := (Self.Top + Self.Height);
    CF.Left := Self.Left;
    CF.edtServerPort.Value := FServerPort;
    CF.edtNotifyDuration.Value := FNotifyDuration;
    CF.ckbNotifyWithPopup.Checked := FNotifyWithPopup;
    CF.ckbNotifyWithSound.Checked := FNotifyWithSound;
    CF.lbxLogView.Items.AddStrings(FLogList);
    if (CF.ShowModal = mrOK) then
    begin
      FNotifyDuration := Trunc(CF.edtNotifyDuration.Value);
      FNotifyWithPopup := CF.ckbNotifyWithPopup.Checked;
      FNotifyWithSound := CF.ckbNotifyWithSound.Checked;
      nPort := Trunc(CF.edtServerPort.Value);
      if (FServerPort <> nPort) then
      begin
        FServerPort := nPort;
        TCPServer.Active := False;
        TCPServer.DefaultPort := FServerPort;
        TCPServer.Active := True;
      end;
      msnPopup.TimeOut := FNotifyDuration;
    end;
  finally
    CF.Close;
  end;
end;

procedure TBPAdminCallForm.CheckConfig;
begin
  with FIniFile do
  begin
    if not SectionExists('Config') then
    begin
      WriteInteger('Config', 'Left', 430);
      WriteInteger('Config', 'ServerPort', 6001);
      WriteInteger('Config', 'NotifyDuration', 0);
      WriteBool('Config', 'NotifyWithPopup', True);
      WriteBool('Config', 'NotifyWithSound', True);
    end;
  end;
end;

procedure TBPAdminCallForm.ReadConfig;
begin
  with FIniFile do
  begin
    Self.Top := 0;
    Self.Left := ReadInteger('Config', 'Left', 430);
    FServerPort := ReadInteger('Config', 'ServerPort', 6001);
    FNotifyDuration := ReadInteger('Config', 'NotifyDuration', 0);
    FNotifyWithPopup := ReadBool('Config', 'NotifyWithPopup', False);
    FNotifyWithSound := ReadBool('Config', 'NotifyWithSound', False);
    msnPopup.TimeOut := FNotifyDuration;
  end;
end;

procedure TBPAdminCallForm.UpdateConfig;
begin
  with FIniFile do
  begin
    if (ReadInteger('Config', 'Left', 430) <> Self.Left) then
      WriteInteger('Config', 'Left', Self.Left);

    if (ReadInteger('Config', 'ServerPort', 6001) <> TCPServer.DefaultPort) then
      WriteInteger('Config', 'ServerPort', TCPServer.DefaultPort);

    if (ReadInteger('Config', 'NotifyDuration', 0) <> FNotifyDuration) then
      WriteInteger('Config', 'NotifyDuration', FNotifyDuration);

    if (ReadBool('Config', 'NotifyWithPopup', False) <> FNotifyWithPopup) then
      WriteBool('Config', 'NotifyWithPopup', FNotifyWithPopup);

    if (ReadBool('Config', 'NotifyWithSound', False) <> FNotifyWithSound) then
      WriteBool('Config', 'NotifyWithSound', FNotifyWithSound);
  end;
end;

procedure TBPAdminCallForm.UpdateLog(const AValue: string);
begin
  with FLogList do
  try
    if (FLogList.Count > 100) then
      FLogList.Delete(0);
    FLogList.Add(Format('[%s] %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now), AValue]));
  except
  end;
end;

{ TNotifyStatusThread }

constructor TNotifyStatusThread.Create;
begin
  inherited Create(ACreateSuspended);

  FreeOnTerminate := True;
  FInterval := 300;
  FLastworked := (Now - 1);
  FErrorCode := 0; //0: No Error
end;

destructor TNotifyStatusThread.Destroy;
begin

  inherited;
end;

procedure TNotifyStatusThread.Execute;
begin
  inherited;

  repeat
    if (MilliSecondsBetween(FLastWorked, Now) > FInterval) then
    begin
      FLastWorked := Now;
      Synchronize(
        procedure
        begin
          if FErrorMode then
          begin
            FBlinked := (not FBlinked);
            if FBlinked then
              BPAdminCallForm.imgNotify.Picture.Assign(BPAdminCallForm.imcStatus.Items[1].Picture)
            else
              BPAdminCallForm.imgNotify.Picture.Assign(BPAdminCallForm.imcStatus.Items[2].Picture);
          end;
        end);
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

procedure TNotifyStatusThread.SetErrorCode(const AValue: Integer);
const
  LCS_ERROR = 'popup.wav';
begin
  if (FErrorCode <> AValue) then
  begin
    FErrorCode := AValue;
    FErrorMode := (FErrorCode <> 0);
    if FErrorMode then
    begin
      BPAdminCallForm.imgNotify.Hint := '마우스로 더블 클릭하여 깜박임을 중지시킵니다.';
      if FNotifyWithSound and
         FileExists(FMediaDir + LCS_ERROR) then
      begin
        sndPlaySound(PChar(FMediaDir + LCS_ERROR), SND_SYNC);
      end;
    end else
    begin
      BPAdminCallForm.imgNotify.Hint := '';
      BPAdminCallForm.imgNotify.Picture.Assign(BPAdminCallForm.imcStatus.Items[0].Picture);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

initialization
  InitializeCriticalSection(FLogCS);
finalization
  DeleteCriticalSection(FLogCS);
end.
