unit VirtualKeyboard.Qwerty.Key.Back.FrameStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  VirtualKeyboard.Qwerty.Key.FrameStyle, FMX.Objects;

type
  TVirtualKeyboardQwertyKeyBackStyle = class(TVirtualKeyboardQwertyKeyStyle)
    Image: TImage;
  private
    { Private declarations }
  protected
    procedure UpdateDisplayKeyChar; override;
  public
    { Public declarations }
  end;

var
  VirtualKeyboardQwertyKeyBackStyle: TVirtualKeyboardQwertyKeyBackStyle;

implementation

{$R *.fmx}

{ TVirtualKeyboardQwertyKeyBackStyle }

procedure TVirtualKeyboardQwertyKeyBackStyle.UpdateDisplayKeyChar;
begin
end;

end.
