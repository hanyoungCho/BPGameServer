unit Form.Intro.Blank;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects;

type
  TIntroBlank = class(TForm)
    Rectangle: TRectangle;
    Layout: TLayout;
    procedure RectangleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroBlank: TIntroBlank;

implementation

uses
  uGlobal, Form.Intro;

{$R *.fmx}

procedure TIntroBlank.FormShow(Sender: TObject);
begin
//  Global.SBMessage.ShowMessageModalForm('1');
end;

procedure TIntroBlank.RectangleClick(Sender: TObject);
begin
  Intro.CloseRectangleClick(nil);
  Close;
end;

end.
