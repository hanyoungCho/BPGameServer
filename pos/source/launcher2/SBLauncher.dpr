program SBLauncher;

uses
  Vcl.Forms,
  Windows,
  Classes,
  SysUtils,
  TlHelp32,
  PsAPI,
  ShellAPI,
  SBLauncher.MainForm in 'SBLauncher.MainForm.pas' {MainForm};

{$R *.res}

procedure GetPIDsByProgramName(AProcessName: string; IncludeSelf: Boolean; ResultList: TStringList);
var
  isFound: Boolean;
  AHandle, AhProcess: THandle;
  ProcEntry32: TProcessEntry32;
  APath: array[0..MAX_PATH] of char;
begin
  AProcessName := ExtractFileName(AProcessName);
  ResultList.Clear;

  AHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    ProcEntry32.dwSize := Sizeof(TProcessEntry32);
    isFound := Process32First(AHandle, ProcEntry32);

    while isFound do
    begin
      AhProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ProcEntry32.th32ProcessID);
      GetModuleFileNameEx(AhProcess, 0, @APath[0], sizeof(APath));
      CloseHandle(AhProcess);

      if (UpperCase(StrPas(APath)) <> UpperCase(AProcessName)) and
         (UpperCase(StrPas(ProcEntry32.szExeFile)) <> UpperCase(AProcessName)) then
      begin
        isFound := Process32Next(AHandle, ProcEntry32);
        Continue;
      end;

      if ProcEntry32.th32ProcessID = GetCurrentProcessId then
      begin
        if not IncludeSelf then
        begin
          isFound := Process32Next(AHandle, ProcEntry32);
          Continue;
        end;
      End;

      ResultList.Add(IntToStr(ProcEntry32.th32ProcessID));
      isFound := Process32Next(AHandle, ProcEntry32);
    end;
  finally
    CloseHandle(AHandle);
  end;
end;

function KillProcessByPIDList(PIDList: TStringList): Boolean;
var
  KillProcessParam: string;
begin
  Result := True;
  KillProcessParam := '/F /T ';
  for var I: Integer := 0 to Pred(PIDList.Count) do
    KillProcessParam := KillProcessParam + '/PID ' + PIDList[I];

  ShellExecute(0, 'Open', 'TaskKill.exe', PChar(KillProcessParam), '', SW_HIDE);
end;

function KillProcessByProgramName(AProcessName: string=''; IncludeSelf: Boolean=False): Boolean;
var
  PIDList : TStringList;
begin
  Result := True;
  if AProcessName.IsEmpty then
    AProcessName := Application.ExeName;

  AProcessName := ExtractFileName(AProcessName);
  PIDList := TStringList.Create;
  try
    GetPIDsByProgramName(AProcessName, IncludeSelf, PIDList);
    while PIDList.Count > 0 do
    begin
      KillProcessByPIDList(PIDList);
      PIDList.Clear;
      GetPIDsByProgramName(AProcessName, IncludeSelf, PIDList);
    end;
  finally
    FreeAndNil(PIDList);
  end;
end;

var
  hMutex: THandle;
begin
  hMutex := CreateMutex(nil, True, 'Global/XTouch Launcher');
  if (hMutex > 0) and
     (GetLastError = 0) then
  begin
    try
      Application.Initialize;
      KillProcessByProgramName;
      Application.MainFormOnTaskbar := True;
      Application.Title := 'AppLauncher for XPartners';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
    finally
      if (hMutex > 0) then
        CloseHandle(hMutex);
    end;
  end;
end.
