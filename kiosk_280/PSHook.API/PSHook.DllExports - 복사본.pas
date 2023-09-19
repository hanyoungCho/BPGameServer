unit PSHook.DllExports;

interface

uses
  {$IFDEF VER230}
  System.SysUtils,
  Winapi.Windows,
  {$ELSE}
  SysUtils,
  Windows,
  {$ENDIF}
  PSHook.API;

type
  TPSGetMouseHook = function (): IPSMouseHook; stdcall;
  TPSGetKeyboardHook = function (): IPSKeyboardHook; stdcall;

  TPSHook = class
  private
    const PSHook = 'PSHook.dll';
    class var Module: HMODULE;
    class constructor Create;
    class destructor Destroy;
  public
    class var GetMouseHook: TPSGetMouseHook;
    class var GetKeyboardHook: TPSGetKeyboardHook;
  end;

implementation

uses
  fx.Logging;

{ TPSHook }

class constructor TPSHook.Create;
begin
  try
    Module := LoadLibrary(PWideChar(ExtractFilePath(ParamStr(0))+PSHook));
    if Module > 0 then
    begin
      @GetMouseHook := GetProcAddress(Module, 'GetPSMouse');
      @GetKeyboardHook := GetProcAddress(Module, 'GetPSKeyboard');
    end;

    Log.D('TPSHook.Create', PWideChar(ExtractFilePath(ParamStr(0))+PSHook));
    Log.D('TPSHook.Module', IntToStr(Module));

    if(@GetMouseHook = nil) then begin
       Log.D('GetMouseHook', 'nil');
       //Exit;
    End;

    if(@GetKeyboardHook = nil) then begin
       Log.D('GetKeyboardHook', 'nil');
       //Exit;
    End;
  except
    on E: Exception do
    begin
      Log.D('TPSHook.Create', e.Message);
    end;
  end;
end;

class destructor TPSHook.Destroy;
begin
  if Module > 0 then
    FreeLibrary(Module);
end;

end.
