unit VirtualKeyboard.Qwerty.Key.Shift.FrameStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  VirtualKeyboard.Qwerty.Key.FrameStyle, FMX.Objects;

type
  TVirtualKeyboardQwertyKeyShiftStyle = class(TVirtualKeyboardQwertyKeyStyle)
    Image: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ExecutePress; override;
    procedure UpdateDisplayKeyChar; override;
  end;

var
  VirtualKeyboardQwertyKeyShiftStyle: TVirtualKeyboardQwertyKeyShiftStyle;

implementation

{$R *.fmx}

{ TVirtualKeyboardQwertyKeyShiftStyle }

procedure TVirtualKeyboardQwertyKeyShiftStyle.ExecutePress;
var
  I: Integer;
begin
  inherited;

  Shift := not Shift;

  for I := 0 to List.Count - 1 do
    List.Items[I].UpdateDisplayKeyChar;
end;

procedure TVirtualKeyboardQwertyKeyShiftStyle.UpdateDisplayKeyChar;
begin
end;

end.
