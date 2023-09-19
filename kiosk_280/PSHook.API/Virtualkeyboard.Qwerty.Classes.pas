unit Virtualkeyboard.Qwerty.Classes;

interface

uses
  Winapi.Windows, Winapi.Imm;

const
  VIRTUAL_KEY_ENGLISH = '`1234567890-=qwertyuiop[]\asdfghjkl;''zxcvbnm,./';
  VIRTUAL_KEY_ENGLISH_SHIFT = '~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?';
  VIRTUAL_KEY_KOREAN = '`1234567890-=げじぇぁさにづちだつ[]\けいしぉぞでったび;''せぜずそばぬぱ,./';
  VIRTUAL_KEY_KOREAN_SHIFT = '~!@#$%^&*()_+こすえあざにづちぢて{}|けいしぉぞでったび:"せぜずそばぬぱ<>?';

procedure ToggleImeMode;
function IsImeModeHangul: boolean;

implementation

uses
  FMX.Platform.Win;

procedure ToggleImeMode;
var
  Mode: HIMC;
  Conversion, Sentence: dword;
begin
  Mode := ImmGetContext(ApplicationHWND);
  ImmGetConversionStatus(Mode, Conversion, Sentence);
  if Conversion = IME_CMODE_ALPHANUMERIC then
    ImmSetConversionStatus(Mode, IME_CMODE_HANGUL, IME_SMODE_NONE)
  else
    ImmSetConversionStatus(Mode, IME_CMODE_ALPHANUMERIC, IME_SMODE_NONE);
end;

function IsImeModeHangul: boolean;
var
  Mode: HIMC;
  Conversion, Sentence: dword;
begin
  Mode := ImmGetContext(ApplicationHWND);
  ImmGetConversionStatus(Mode, Conversion, Sentence);
  result := Conversion = IME_CMODE_HANGEUL;
end;



end.
