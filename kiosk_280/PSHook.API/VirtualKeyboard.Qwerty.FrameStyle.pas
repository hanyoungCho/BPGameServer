unit VirtualKeyboard.Qwerty.FrameStyle;

interface

uses
  PSHook.API,
  App.DeviceManager,
  Winapi.Windows,
  System.Generics.Collections,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, VirtualKeyboard.Qwerty.Key.Shift.FrameStyle,
  VirtualKeyboard.Qwerty.Key.Back.FrameStyle,
  VirtualKeyboard.Qwerty.Key.FrameStyle,
  VirtualKeyboard.Qwerty.Key.IME.FrameStyle;

type
  TVirtualKeyboardQwertyStyle = class(TFrame)
    Rectangle: TRectangle;
    Key2: TVirtualKeyboardQwertyKeyStyle;
    Key3: TVirtualKeyboardQwertyKeyStyle;
    Key4: TVirtualKeyboardQwertyKeyStyle;
    Key5: TVirtualKeyboardQwertyKeyStyle;
    Key6: TVirtualKeyboardQwertyKeyStyle;
    Key7: TVirtualKeyboardQwertyKeyStyle;
    Key8: TVirtualKeyboardQwertyKeyStyle;
    Key10: TVirtualKeyboardQwertyKeyStyle;
    Key12: TVirtualKeyboardQwertyKeyStyle;
    Key1: TVirtualKeyboardQwertyKeyStyle;
    Key14: TVirtualKeyboardQwertyKeyStyle;
    Key15: TVirtualKeyboardQwertyKeyStyle;
    Key16: TVirtualKeyboardQwertyKeyStyle;
    Key17: TVirtualKeyboardQwertyKeyStyle;
    Key18: TVirtualKeyboardQwertyKeyStyle;
    Key19: TVirtualKeyboardQwertyKeyStyle;
    Key20: TVirtualKeyboardQwertyKeyStyle;
    Key21: TVirtualKeyboardQwertyKeyStyle;
    Key23: TVirtualKeyboardQwertyKeyStyle;
    Key25: TVirtualKeyboardQwertyKeyStyle;
    Key27: TVirtualKeyboardQwertyKeyStyle;
    Key29: TVirtualKeyboardQwertyKeyStyle;
    Key28: TVirtualKeyboardQwertyKeyStyle;
    Key31: TVirtualKeyboardQwertyKeyStyle;
    Key32: TVirtualKeyboardQwertyKeyStyle;
    Key33: TVirtualKeyboardQwertyKeyStyle;
    Key34: TVirtualKeyboardQwertyKeyStyle;
    Key35: TVirtualKeyboardQwertyKeyStyle;
    Key36: TVirtualKeyboardQwertyKeyStyle;
    Key38: TVirtualKeyboardQwertyKeyStyle;
    Key40: TVirtualKeyboardQwertyKeyStyle;
    Key43: TVirtualKeyboardQwertyKeyStyle;
    Key44: TVirtualKeyboardQwertyKeyStyle;
    Key42: TVirtualKeyboardQwertyKeyStyle;
    Key47: TVirtualKeyboardQwertyKeyStyle;
    Key46: TVirtualKeyboardQwertyKeyStyle;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Key22: TVirtualKeyboardQwertyKeyStyle;
    Key24: TVirtualKeyboardQwertyKeyStyle;
    Key26: TVirtualKeyboardQwertyKeyStyle;
    Key9: TVirtualKeyboardQwertyKeyStyle;
    Key11: TVirtualKeyboardQwertyKeyStyle;
    Key13: TVirtualKeyboardQwertyKeyStyle;
    Key37: TVirtualKeyboardQwertyKeyStyle;
    Key30: TVirtualKeyboardQwertyKeyStyle;
    Key45: TVirtualKeyboardQwertyKeyStyle;
    Key41: TVirtualKeyboardQwertyKeyStyle;
    Key39: TVirtualKeyboardQwertyKeyStyle;
    Layout5: TLayout;
    VirtualKeyboardQwertyKeySpaceStyle: TVirtualKeyboardQwertyKeyStyle;
  private
    { Private declarations }
    FKeyList: TList<TVirtualKeyboardQwertyKeyStyle>;
    FControl: IControl;
    DeviceManager: TDeviceManager;

    procedure BindKeys;

    procedure MouseDownEvent(Button: TPSMouseButton; Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
    procedure MouseUpEvent(Button: TPSMouseButton; Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Cleanup;
  end;

implementation

uses
  fx.Logging;

{$R *.fmx}

{ TVirtualKeyboardQwertyStyle }

procedure TVirtualKeyboardQwertyStyle.BindKeys;
var
  I: Integer;
begin
  for I := 0 to FKeyList.Count - 1 do
    FKeyList.Items[I].KeyRef := I + 1;

  VirtualKeyboardQwertyKeySpaceStyle.Key := VK_SPACE;

  VirtualKeyboardQwertyKeyIMEStyle.Key := VK_MODECHANGE;

  VirtualKeyboardQwertyKeyShiftStyle.Key := 0;
  VirtualKeyboardQwertyKeyShiftStyle.KeepPressed := True;

  VirtualKeyboardQwertyKeyBackStyle.Key := VK_BACK;
end;

procedure TVirtualKeyboardQwertyStyle.Cleanup;
begin
  if VirtualKeyboardQwertyKeyShiftStyle.Shift then
    VirtualKeyboardQwertyKeyShiftStyle.ExecutePress;
end;

constructor TVirtualKeyboardQwertyStyle.Create(AOwner: TComponent);
begin
  inherited;

//  {$IFDEF RELEASE}
{
  TDeviceManager.Mouse.Add(TDeviceEvent.Down, MouseDownEvent);
  TDeviceManager.Mouse.Add(TDeviceEvent.Up, MouseUpEvent);
  TDeviceManager.Mouse.Enabled := True;
}
//  {$ENDIF}

  DeviceManager := TDeviceManager.Create;
  DeviceManager.Mouse.Add(TDeviceEvent.Down, MouseDownEvent);
  DeviceManager.Mouse.Add(TDeviceEvent.Up, MouseUpEvent);
  DeviceManager.Mouse.Enabled := True;

  FKeyList := TList<TVirtualKeyboardQwertyKeyStyle>.Create;
  FKeyList.Add(Key1);
  FKeyList.Add(Key2);
  FKeyList.Add(Key3);
  FKeyList.Add(Key4);
  FKeyList.Add(Key5);
  FKeyList.Add(Key6);
  FKeyList.Add(Key7);
  FKeyList.Add(Key8);
  FKeyList.Add(Key9);
  FKeyList.Add(Key10);
  FKeyList.Add(Key11);
  FKeyList.Add(Key12);
  FKeyList.Add(Key13);
  FKeyList.Add(Key14);
  FKeyList.Add(Key15);
  FKeyList.Add(Key16);
  FKeyList.Add(Key17);
  FKeyList.Add(Key18);
  FKeyList.Add(Key19);
  FKeyList.Add(Key20);
  FKeyList.Add(Key21);
  FKeyList.Add(Key22);
  FKeyList.Add(Key23);
  FKeyList.Add(Key24);
  FKeyList.Add(Key25);
  FKeyList.Add(Key26);
  FKeyList.Add(Key27);
  FKeyList.Add(Key28);
  FKeyList.Add(Key29);
  FKeyList.Add(Key30);
  FKeyList.Add(Key31);
  FKeyList.Add(Key32);
  FKeyList.Add(Key33);
  FKeyList.Add(Key34);
  FKeyList.Add(Key35);
  FKeyList.Add(Key36);
  FKeyList.Add(Key37);
  FKeyList.Add(Key38);
  FKeyList.Add(Key39);
  FKeyList.Add(Key40);
  FKeyList.Add(Key41);
  FKeyList.Add(Key42);
  FKeyList.Add(Key43);
  FKeyList.Add(Key44);
  FKeyList.Add(Key45);
  FKeyList.Add(Key46);
  FKeyList.Add(Key47);

  BindKeys;
  Cleanup;

  FControl := nil;
end;

destructor TVirtualKeyboardQwertyStyle.Destroy;
begin
//  {$IFDEF RELEASE}
  {
  TDeviceManager.Mouse.Remove(MouseDownEvent);
  TDeviceManager.Mouse.Remove(MouseUpEvent);
  TDeviceManager.Mouse.Enabled := False;
  }
//  {$ENDIF}
  try
  try

  DeviceManager.Mouse.Remove(MouseDownEvent);
  DeviceManager.Mouse.Remove(MouseUpEvent);
  DeviceManager.Mouse.Enabled := False;
  DeviceManager.Destroy;
  //DeviceManager.Free;
  //FreeAndNil(DeviceManager);

  FKeyList.Free;

  except
    on E: Exception do
    begin
      Log.E('TVirtualKeyboardQwertyStyle', E.Message);
      //FreeAndNil(DeviceManager);
     end;
  end;
  finally

  end;

  inherited;
end;

procedure TVirtualKeyboardQwertyStyle.MouseDownEvent(Button: TPSMouseButton;
  Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
var
  Control: IControl;
begin
  if AbsoluteRect.Contains(PointF(X, Y)) then
  begin
    Control := ObjectAtPoint(PointF(X, Y));
    if (Control <> nil) and (Control.GetObject <> nil)
      and (Control.GetObject is TVirtualKeyboardQwertyKeyStyle) then
    begin
      FControl := Control;

      TVirtualKeyboardQwertyKeyStyle(FControl.GetObject).ExecuteDown;
    end;

    Handled := True;
  end;
end;

procedure TVirtualKeyboardQwertyStyle.MouseUpEvent(Button: TPSMouseButton;
  Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
var
  Control: IControl;
begin
  if AbsoluteRect.Contains(PointF(X, Y)) then
  begin
    Control := ObjectAtPoint(PointF(X, Y));
    if (Control <> nil) and (Control.GetObject <> nil)
      and (Control.GetObject is TVirtualKeyboardQwertyKeyStyle) then
    begin
      if FControl = Control then
        TVirtualKeyboardQwertyKeyStyle(FControl.GetObject).ExecutePress;
    end;

    if FControl <> nil then
      TVirtualKeyboardQwertyKeyStyle(FControl.GetObject).ExecuteUp;

    FControl := nil;

    Handled := True;
  end;
end;

end.
