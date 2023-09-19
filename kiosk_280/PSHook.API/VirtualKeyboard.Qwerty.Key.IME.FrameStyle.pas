unit VirtualKeyboard.Qwerty.Key.IME.FrameStyle;

interface

uses
  VirtualKeyboard.Qwerty.Classes,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  VirtualKeyboard.Qwerty.Key.FrameStyle, FMX.Objects;

type
  TVirtualKeyboardQwertyKeyIMEStyle = class(TVirtualKeyboardQwertyKeyStyle)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ExecutePress; override;
    procedure UpdateDisplayKeyChar; override;
  end;

var
  VirtualKeyboardQwertyKeyIMEStyle: TVirtualKeyboardQwertyKeyIMEStyle;

implementation

{$R *.fmx}

{ TVirtualKeyboardQwertyKeyIMEStyle }

procedure TVirtualKeyboardQwertyKeyIMEStyle.ExecutePress;
var
  I: Integer;
begin
  inherited;

  ToggleImeMode;

  Hangul := IsImeModeHangul;

  for I := 0 to List.Count - 1 do
    List.Items[I].UpdateDisplayKeyChar;
end;

procedure TVirtualKeyboardQwertyKeyIMEStyle.UpdateDisplayKeyChar;
begin
end;

end.
