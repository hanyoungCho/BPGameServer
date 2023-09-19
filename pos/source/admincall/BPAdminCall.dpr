program BPAdminCall;

uses
  Vcl.Forms,
  Winapi.Windows,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  BPAdminCall.MainForm in 'BPAdminCall.MainForm.pas' {BPAdminCallForm};

{$R *.res}

const
  CO_MUTEX_NAME: string = 'AdminCall for BowllingPick';
var
  hMutex: THandle;
begin
  hMutex := CreateMutex(nil, True, PWideChar(CO_MUTEX_NAME));
  try
    if (hMutex <> 0) and
       (ERROR_ALREADY_EXISTS = GetLastError) then
    begin
      ShowMessage('BowlingPick 알리미 프로그램이 이미 실행 중입니다!');
      Exit;
    end;

    Application.Initialize;
    Application.MainFormOnTaskBar := True;
    Application.Title := CO_MUTEX_NAME;
    TStyleManager.TrySetStyle('Smokey Quartz Kamri');
    Application.CreateForm(TBPAdminCallForm, BPAdminCallForm);
    Application.Run;
  finally
    ReleaseMutex(hMutex);
  end;
end.
