unit Common.TabTip platform;

interface

uses
  Winapi.Windows;

type
  TTabTip = record
  private
  var
    FExePath: string;

    procedure DetermineExePath;
    function DetermineHWND: HWND;
  public
    procedure Launch(const AParentHWND: HWND=0);
    procedure Show;
    procedure Close;
    procedure Termiante;
    function IsVisible: Boolean;
  end;

implementation

uses
  System.IOUtils, System.SysUtils, System.Win.Registry, Winapi.ShellApi, Winapi.Messages, Winapi.TlHelp32;

function ExpandEnvironmentVariables(const AVariable: string): string;
var
  nLen: DWORD;
begin
  nLen := MAX_PATH;
  SetLength(Result, nLen);
  nLen := Winapi.Windows.ExpandEnvironmentStrings(PChar(AVariable), PChar(Result), nLen);
  Win32Check(nLen > 0);
  SetLength(Result, nLen - 1);
end;

function DetermineProcessHandleForExeName(const AExeName: string; out AProcessHandle: THandle): Boolean;
var
  hSnapshot: THandle;
  PE: TProcessEntry32;
  PID: DWORD;
begin
  Result := False;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    PE.dwSize := SizeOf(TProcessEntry32);
    if Process32First(hSnapshot, PE) then
      while Process32Next(hSnapshot, PE) do
        if (String(PE.szExeFile).ToLowerInvariant = AExeName) then
        begin
          PID := PE.th32ProcessID;
          AProcessHandle := OpenProcess(PROCESS_TERMINATE, False, PID);
          Exit(True);
        end;
  finally
    CloseHandle(hSnapshot);
  end;
end;

function FindTrayButtonWindow: THandle;
var
  ShellTrayWnd: THandle;
  TrayNotifyWnd: THandle;
begin
  Result := 0;
  ShellTrayWnd := FindWindow('Shell_TrayWnd', nil);
  if (ShellTrayWnd > 0) then
  begin
    TrayNotifyWnd := FindWindowEx(ShellTrayWnd, 0, 'TrayNotifyWnd', nil);
    if (TrayNotifyWnd > 0) then
      Result := FindWindowEx(TrayNotifyWnd, 0, 'TIPBand', nil);
  end;
end;

{ TTabTip }

procedure TTabTip.Close;
var
  hWindowHandle: HWND;
begin
  hWindowHandle := DetermineHWND;
  PostMessage(hWindowHandle, WM_SYSCOMMAND, SC_CLOSE, 0);
end;

procedure TTabTip.DetermineExePath;
const
  LCS_Path = 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\TabTip.exe';
  LCS_HardcodedPath = 'C:\Program Files\Common Files\microsoft shared\ink\TabTip.exe';
  LCS_ErrorMsg = '화상키보드 프로그램이 설치되어 있지 않습니다.';
var
  R: TRegistry;
  sValue: string;
begin
  R := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    R.OpenKeyReadOnly(LCS_Path);
    sValue := R.ReadString(EmptyStr);
    FExePath := ExpandEnvironmentVariables(sValue);
  finally
    R.Destroy;
  end;

  if not TFile.Exists(FExePath) then
    FExePath := LCS_HardcodedPath;
  if not TFile.Exists(FExePath) then
    raise EFileNotFoundException.Create(LCS_ErrorMsg);
end;

function TTabTip.DetermineHWND: HWND;
const
  pWindowName: PChar = 'IPTip_Main_Window';
begin
  Result := FindWindow(pWindowName, nil);
end;

function TTabTip.IsVisible: Boolean;
begin
  Result := (DetermineHWND <> 0);
end;

procedure TTabTip.Launch(const AParentHWND: HWND);
var
  TrayButtonWindow: THandle;
begin
  if FExePath.IsEmpty then
    DetermineExePath;

  if (ShellExecute(AParentHWND, 'open', PChar(FExePath), nil, nil, SW_SHOWNA) < 32) then
    RaiseLastOSError
  else
  begin
    TrayButtonWindow := FindTrayButtonWindow;
    if (TrayButtonWindow > 0) then
    begin
      PostMessage(TrayButtonWindow, WM_LBUTTONDOWN, MK_LBUTTON, $00010001);
      PostMessage(TrayButtonWindow, WM_LBUTTONUP, 0, $00010001);
    end;
  end;
end;

procedure TTabTip.Show;
var
  TrayButtonWindow: THandle;
begin
  if IsVisible then
  begin
    TrayButtonWindow := FindTrayButtonWindow;
    if (TrayButtonWindow > 0) then
    begin
      PostMessage(TrayButtonWindow, WM_LBUTTONDOWN, MK_LBUTTON, $00010001);
      PostMessage(TrayButtonWindow, WM_LBUTTONUP, 0, $00010001);
    end;
  end
  else
    RaiseLastOSError;
end;

procedure TTabTip.Termiante;
var
  pProcessHandle: THandle;
begin
  if DetermineProcessHandleForExeName('tabtip.exe', pProcessHandle) then
    Win32Check(TerminateProcess(pProcessHandle, ERROR_SUCCESS));
end;

end.
