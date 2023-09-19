program GameServer_280;

uses
  FastMM4 in '..\..\FastMM4-master\FastMM4.pas',
  FastMM4Messages in '..\..\FastMM4-master\FastMM4Messages.pas',
  Vcl.Forms,
  System.SysUtils,
  uXGMainForm in 'uXGMainForm.pas' {MainForm},
  uGlobal in 'uGlobal.pas',
  uStruct in 'Lib\uStruct.pas',
  uConsts in 'Lib\uConsts.pas',
  uLogging in 'Lib\uLogging.pas',
  FILELOG in 'Lib\FILELOG.pas',
  uBowlingDM in 'Api\uBowlingDM.pas' {BowlingDM: TDataModule},
  uXGServer in 'Api\uXGServer.pas',
  uErpApi in 'Api\uErpApi.pas',
  uComBnC in 'Comport\uComBnC.pas',
  uFunction in 'Lib\uFunction.pas',
  uLaneInfo in 'Lane\uLaneInfo.pas',
  uAssignReserve in 'Lane\uAssignReserve.pas',
  uLaneThread in 'Lane\uLaneThread.pas',
  Frame.ItemBody in 'Frame\Frame.ItemBody.pas' {Frame4: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
