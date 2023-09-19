program BPMonitor;

uses
  Vcl.Forms,
  BPMonitor.MainForm in 'BPMonitor.MainForm.pas' {BPMonitorForm},
  Vcl.Themes,
  Vcl.Styles,
  Common.MediaPlayThread in '..\common\Common.MediaPlayThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBPMonitorForm, MainForm);
  Application.Run;
end.
