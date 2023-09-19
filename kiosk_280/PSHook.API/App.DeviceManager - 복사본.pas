unit App.DeviceManager;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  PSHook.DllExports,
  PSHook.API;

type
  {$SCOPEDENUMS ON}
  TDeviceEvent = (Up, Down, Move);
  {$SCOPEDENUMS OFF}

  TDeviceNotifier<THook, TNotifier> = class
  private
    FNotifiers: TDictionary<TDeviceEvent, TList<TNotifier>>;
    FEnabled: Boolean;
    FHook: THook;
  protected
    procedure SetEnabled(const Value: Boolean); virtual;
    procedure ConnectEvent; virtual; abstract;
  public
    constructor Create(Hook: THook); virtual;
    destructor Destroy; override;

    procedure Add(Event: TDeviceEvent; Proc: TNotifier);
    procedure Remove(Proc: TNotifier);

    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

  TKeyboardNotifier = class(TDeviceNotifier<IPSKeyboardHook, TPSKeyboardEvent>)
  private
    procedure KeyEvent(DeviceEvent: TDeviceEvent; Key: Word; Shift: TShiftState; var Handled: Boolean);

    procedure on_KeyUp(Key: Word; Shift: TShiftState; var Handled: Boolean);
    procedure on_KeyDown(Key: Word; Shift: TShiftState; var Handled: Boolean);
  protected
    procedure ConnectEvent; override;
    procedure SetEnabled(const Value: Boolean); override;
  end;

  TMouseNotifier = class(TDeviceNotifier<IPSMouseHook, TPSMouseEvent>)
  private
    procedure MouseEvent(DeviceEvent: TDeviceEvent; Button: TPSMouseButton; Shift: TShiftState; X, Y: Integer; var Handled: Boolean);

    procedure on_MouseUp(Button: TPSMouseButton; Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
    procedure on_MouseDown(Button: TPSMouseButton; Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
    procedure on_MouseMove(X, Y: Integer; var Handled: Boolean);
  protected
    procedure ConnectEvent; override;
    procedure SetEnabled(const Value: Boolean); override;
  end;

  TDeviceManager = class
  private
    class var FMouseNotifier: TMouseNotifier;
    class var FKeyboardNotifier: TKeyboardNotifier;
    class var FBlocking: Boolean;
    class constructor Create;
    class destructor Destroy;
  public
    class property Keyboard: TKeyboardNotifier read FKeyboardNotifier;
    class property Mouse: TMouseNotifier read FMouseNotifier;
    class property Blocking: Boolean read FBlocking write FBlocking;
  end;

function IsApplicationActive: Boolean;

implementation

uses
  FMX.Forms;

function IsApplicationActive: Boolean;
begin
  Result := (Application <> nil) and (Application.MainForm <> nil) and (Screen.ActiveForm <> nil);
end;

{ TDeviceNotifier<T> }

procedure TDeviceNotifier<THook, TNotifier>.Add(Event: TDeviceEvent; Proc: TNotifier);
var
  List: TList<TNotifier>;
begin
  if not FNotifiers.TryGetValue(Event, List) then
  begin
    List := TList<TNotifier>.Create;
    FNotifiers.Add(Event, List);
  end;

  List.Add(Proc);
end;

constructor TDeviceNotifier<THook, TNotifier>.Create(Hook: THook);
begin
  FHook := Hook;
  FNotifiers := TObjectDictionary<TDeviceEvent, TList<TNotifier>>.Create([doOwnsValues]);
  FEnabled := False;

  ConnectEvent;
end;

destructor TDeviceNotifier<THook, TNotifier>.Destroy;
begin
  FNotifiers.Free;

  inherited;
end;

procedure TDeviceNotifier<THook, TNotifier>.Remove(Proc: TNotifier);
var
  List: TList<TNotifier>;
begin
  for List in FNotifiers.Values do
    List.Remove(Proc);
end;

procedure TDeviceNotifier<THook, TNotifier>.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

{ TDeviceManager }

class constructor TDeviceManager.Create;
begin
  FMouseNotifier := TMouseNotifier.Create(TPSHook.GetMouseHook());
  FKeyboardNotifier := TKeyboardNotifier.Create(TPSHook.GetKeyboardHook());
  {$IFDEF RELEASE}
  FMouseNotifier.Enabled := True;
  FKeyboardNotifier.Enabled := True;
  {$ENDIF}
  FBlocking := False;
end;

class destructor TDeviceManager.Destroy;
begin
  {$IFDEF RELEASE}
  FMouseNotifier.Enabled := False;
  FKeyboardNotifier.Enabled := False;
  {$ENDIF}

  FMouseNotifier.Free;
  FKeyboardNotifier.Free;
end;

{ TKeyboardNotifier<THook, TNotifier> }

procedure TKeyboardNotifier.ConnectEvent;
begin
  if FHook <> nil then
  begin
    FHook.OnKeyDown := on_KeyDown;
    FHook.OnKeyUp := on_KeyUp;
  end;
end;

procedure TKeyboardNotifier.KeyEvent(DeviceEvent: TDeviceEvent; Key: Word;
  Shift: TShiftState; var Handled: Boolean);
var
  I: Integer;
  List: TList<TPSKeyboardEvent>;
begin
  if not IsApplicationActive then Exit;

  if FEnabled then
  begin
    if TDeviceManager.Blocking then
    begin
      Handled := True;
      Exit;
    end;

    if FNotifiers.TryGetValue(DeviceEvent, List) then
      for I := 0 to List.Count - 1 do
      begin
        if not Handled then
          List.Items[I](Key, Shift, Handled);
      end;
  end;
end;

procedure TKeyboardNotifier.on_KeyDown(Key: Word; Shift: TShiftState;
  var Handled: Boolean);
begin
  KeyEvent(TDeviceEvent.Down, Key, Shift, Handled);
end;

procedure TKeyboardNotifier.on_KeyUp(Key: Word; Shift: TShiftState;
  var Handled: Boolean);
begin
  KeyEvent(TDeviceEvent.Up, Key, Shift, Handled);
end;

procedure TKeyboardNotifier.SetEnabled(const Value: Boolean);
begin
  inherited;

  if FHook <> nil then
  begin
    if FEnabled then
      FHook.Active
    else
      FHook.Deactive;
  end;
end;

{ TMouseNotifier }

procedure TMouseNotifier.ConnectEvent;
var
  MouseHook10: IPSMouseHook10;
begin
  if FHook <> nil then
  begin
    FHook.OnMouseDown := on_MouseDown;
    FHook.OnMouseUp := on_MouseUp;
    if Supports(FHook, IPSMouseHook10, MouseHook10) then
      MouseHook10.OnMouseMove := on_MouseMove;
  end;
end;

procedure TMouseNotifier.MouseEvent(DeviceEvent: TDeviceEvent;
  Button: TPSMouseButton; Shift: TShiftState; X, Y: Integer;
  var Handled: Boolean);
var
  I: Integer;
  List: TList<TPSMouseEvent>;
begin
  if not IsApplicationActive then Exit;

  if FEnabled then
  begin
    if TDeviceManager.Blocking then
    begin
      Handled := True;
      Exit;
    end;

    if FNotifiers.TryGetValue(DeviceEvent, List) then
      for I := 0 to List.Count - 1 do
      begin
        if not Handled then
          List.Items[I](Button, Shift, X, Y, Handled);
      end;
  end;
end;

procedure TMouseNotifier.on_MouseDown(Button: TPSMouseButton;
  Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
begin
  MouseEvent(TDeviceEvent.Down, Button, Shift, X, Y, Handled);
end;

procedure TMouseNotifier.on_MouseMove(X, Y: Integer; var Handled: Boolean);
begin
  MouseEvent(TDeviceEvent.Move, TPSMouseButton.None, [], X, Y, Handled);
end;

procedure TMouseNotifier.on_MouseUp(Button: TPSMouseButton; Shift: TShiftState;
  X, Y: Integer; var Handled: Boolean);
begin
  MouseEvent(TDeviceEvent.Up, Button, Shift, X, Y, Handled);
end;

procedure TMouseNotifier.SetEnabled(const Value: Boolean);
begin
  inherited;

  if FHook <> nil then
  begin
    if FEnabled then
      FHook.Active
    else
      FHook.Deactive;
  end;
end;

end.
