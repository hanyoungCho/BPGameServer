unit frmMediaTest;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Media,
  FMX.Platform, FMX.VirtualKeyboard, Winapi.Windows,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls;

type
  TMediaTest = class(TForm)
    Layout: TLayout;
    Rectangle100: TRectangle;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;

    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    keybdhook: hhook;
  public
    { Public declarations }
  end;

var
  MediaTest: TMediaTest;

implementation

uses
  uGlobal;

{$R *.fmx}

procedure TMediaTest.FormCreate(Sender: TObject);
begin
  //keybdhook := setwindowshookex(wh_keyboard, keybdhookproc, hinstance, getcurrentthreeadid);
end;

procedure TMediaTest.FormShow(Sender: TObject);
var
  FService: IFMXVirtualKeyboardService;
begin

  tplatformservices.Current.SupportsPlatformService(ifmxvirtualkeyboardservice, IInterface(Fservice));
  if (fservice <> nil) then
  begin
    fservice.ShowVirtualKeyboard(edit1);
  end;


end;

procedure TMediaTest.SpeedButton1Click(Sender: TObject);
begin
  //simulatekeydown(ord('A'));
  //simulatekeyup(ord('A'));
end;

procedure simulatekeydown(virtualkey: byte);
begin
  {
  keydb_event(
  virtualkey,
  mapvirtualkey(virtualkey, 0),
  0, 0
  );
  }
end;

procedure simulatekeyup(virtualkey: byte);
begin
  {
  keydb_event(
  virtualkey,
  mapvirtualkey(virtualkey, 0),
  keyeventf_keyup,
  0
  );
  }
end;

end.
