program BPPOS;

uses
  System.ShareMem,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  System.IniFiles,
  BPPOS.MainForm in 'BPPOS.MainForm.pas' {BPMainForm},
  Common.BPSplash in '..\common\Common.BPSplash.pas' {InitSplash},
  Common.ExceptDlg.VCL in '..\common\Common.ExceptDlg.VCL.pas' {ExceptionDlg};

{$R *.res}
{$R ..\common\BPCursors.resource}

const
  CO_MUTEX_NAME = 'Global\BowlingPick POS System';

var
  hMutex: THandle;
begin
{$IFDEF RELEASE}
  if (ParamCount = 0) or (LowerCase(ParamStr(1)) <> '/run') then
  begin
    MessageBox(0, PChar('런처 프로그램을 이용하여 실행하여 주십시오!'), PChar('알림'), MB_ICONWARNING or MB_OK or MB_TOPMOST or MB_SYSTEMMODAL);
    Halt(0);
    Exit;
  end;
{$ENDIF}
  //ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
  hMutex := CreateMutex(nil, True, CO_MUTEX_NAME);
  try
    if (hMutex <> 0) and
       (ERROR_ALREADY_EXISTS = GetLastError) then
      Exit;

    Application.Initialize;
    if TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'config\' +
        ChangeFileExt(ExtractFileName(ParamStr(0)), '') + 'Local.config').ReadBool('Config', 'DarkMode', False) then
      TStyleManager.TrySetStyle('Windows11 Polar Dark')
    else
      TStyleManager.TrySetStyle('Windows11 Polar Light');

    Application.Title := 'BowlingPick POS System';
    Application.CreateForm(TBPMainForm, BPMainForm);
    InitSplash := TInitSplash.Create(Application);
    InitSplash.LoadSplash(True, True, 225);
    InitSplash.Show;
    Application.Run;
  finally
    ReleaseMutex(hMutex);
  end;
end.
