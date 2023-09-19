unit PSHook.API;

interface

{$IFDEF MSWINDOWS}
uses
  {$IFDEF VER230}
  Winapi.Windows,
  System.Classes;
  {$ELSE}
  Windows,
  Classes;
  {$ENDIF}

type
  TPSKeyboardEvent = procedure (Key: Word; Shift: TShiftState; var Handled: Boolean) of object;

  IPSKeyboardHook = interface
  ['{C173D5CC-BB37-4E21-AA74-39F7B6C380E4}']
    function GetOnKeyDown: TPSKeyboardEvent;
    procedure SetOnKeyDown(Value: TPSKeyboardEvent);
    function GetOnKeyUp: TPSKeyboardEvent;
    procedure SetOnKeyUp(Value: TPSKeyboardEvent);
    function GetHookHandle: HHOOK;

    procedure Active;
    procedure Deactive;

    property Handle: HHOOK read GetHookHandle;

    property OnKeyDown: TPSKeyboardEvent read GetOnKeyDown write SetOnKeyDown;
    property OnKeyUp: TPSKeyboardEvent read GetOnKeyUp write SetOnKeyUp;
  end;

  {$SCOPEDENUMS ON}
  TPSMouseButton = (Left, Right, Middle, None);
  {$SCOPEDENUMS OFF}

  TPSMouseEvent = procedure (Button: TPSMouseButton; Shift: TShiftState; X, Y: Integer; var Handled: Boolean) of object;

  IPSMouseHook = interface
  ['{C173D5CC-BB37-4E21-AA74-39F7B6C380E4}']
    function GetOnMouseDown: TPSMouseEvent;
    procedure SetOnMouseDown(Value: TPSMouseEvent);
    function GetOnMouseUp: TPSMouseEvent;
    procedure SetOnMouseUp(Value: TPSMouseEvent);
    function GetHookHandle: HHOOK;

    procedure Active;
    procedure Deactive;

    property Handle: HHOOK read GetHookHandle;

    property OnMouseDown: TPSMouseEvent read GetOnMouseDown write SetOnMouseDown;
    property OnMouseUp: TPSMouseEvent read GetOnMouseUp write SetOnMouseUp;
  end;

  TPSMouseMoveEvent = procedure (X, Y: Integer; var Handled: Boolean) of object;

  IPSMouseHook10 = interface(IPSMouseHook)
  ['{FB22CFCC-9D25-4876-9FE1-6EFBF29C387F}']
    function GetOnMouseMove: TPSMouseMoveEvent;
    procedure SetOnMouseMove(Value: TPSMouseMoveEvent);

    property OnMouseMove: TPSMouseMoveEvent read GetOnMouseMove write SetOnMouseMove;
  end;
{$ENDIF}

implementation

end.
