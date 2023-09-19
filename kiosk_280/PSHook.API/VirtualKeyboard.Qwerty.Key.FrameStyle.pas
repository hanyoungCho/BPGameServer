unit VirtualKeyboard.Qwerty.Key.FrameStyle;

interface

uses
  VirtualKeyboard.Qwerty.Classes,
  Winapi.Windows,
  System.Generics.Collections,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TVirtualKeyboardQwertyKeyStyle = class(TFrame)
    Rectangle: TRectangle;
    Text: TText;
  private
    class constructor Create;
    class destructor Destroy;
  public
    class var List: TList<TVirtualKeyboardQwertyKeyStyle>;
    class var Shift: Boolean;
    class var Hangul: Boolean;
    class var Event: Boolean;
  private
    { Private declarations }
    FKey: SmallInt;
    FKeepPressed: Boolean;
    FPressed: Boolean;
    FColor: TAlphaColor;
    FPressedColor: TAlphaColor;
    FKeyRef: Integer;
    function GetKeyChar: Char;
    procedure SetKeyRef(const Value: Integer);
    procedure SetKey(const Value: SmallInt);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdateDisplayKeyChar; virtual;

    procedure ExecuteDown; virtual;
    procedure ExecutePress; virtual;
    procedure ExecuteUp; virtual;

    property Key: SmallInt read FKey write SetKey;
    property KeyRef: Integer read FKeyRef write SetKeyRef;
    property KeepPressed: Boolean read FKeepPressed write FKeepPressed;
  end;

implementation

{$R *.fmx}

//uses
//  App.Logging;

{ TVirtualKeyboardQwertyKeyStyle }

constructor TVirtualKeyboardQwertyKeyStyle.Create(AOwner: TComponent);
begin
  inherited;

  FPressed := False;
  FKeepPressed := False;
  FColor := $FFC8C8C8;
  FPressedColor := $FFA0A0A0;
  FKeyRef := -1;

  AutoCapture := True;

  Rectangle.Fill.Color := FColor;

  List.Add(Self);
end;

destructor TVirtualKeyboardQwertyKeyStyle.Destroy;
begin
  List.Remove(Self);

  inherited;
end;

class constructor TVirtualKeyboardQwertyKeyStyle.Create;
begin
  List := TList<TVirtualKeyboardQwertyKeyStyle>.Create;
  Shift := False;
  Hangul := IsImeModeHangul;
  Event := False;
end;

class destructor TVirtualKeyboardQwertyKeyStyle.Destroy;
begin
  List.Free;
end;

function TVirtualKeyboardQwertyKeyStyle.GetKeyChar: Char;
begin
  if FKeyRef > -1 then
  begin
    if IsImeModeHangul then
    begin
      if Shift then
        Result := VIRTUAL_KEY_KOREAN_SHIFT[KeyRef]
      else
        Result := VIRTUAL_KEY_KOREAN[KeyRef];
    end
    else
    begin
      if Shift then
        Result := VIRTUAL_KEY_ENGLISH_SHIFT[KeyRef]
      else
        Result := VIRTUAL_KEY_ENGLISH[KeyRef];
    end;
  end
  else
    Result := Chr(FKey);
end;

procedure TVirtualKeyboardQwertyKeyStyle.ExecuteDown;
begin
  Rectangle.Fill.Color := FPressedColor;
  Capture;
end;

procedure TVirtualKeyboardQwertyKeyStyle.ExecutePress;
begin
  Event := True;
  try
    if FKeepPressed then
    begin
      FPressed := not FPressed;
    end
    else
    begin
      if TVirtualKeyboardQwertyKeyStyle.Shift then
        keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), 0, 0);

      keybd_event(FKey, MapVirtualKey(FKey, 0), 0, 0);
      keybd_event(FKey, MapVirtualKey(FKey, 0), KEYEVENTF_KEYUP, 0);

      if TVirtualKeyboardQwertyKeyStyle.Shift then
        keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0);
    end;
  finally
    Event := False;
  end;
end;

procedure TVirtualKeyboardQwertyKeyStyle.ExecuteUp;
begin
  ReleaseCapture;

  if not FPressed then
    Rectangle.Fill.Color := FColor;
end;

procedure TVirtualKeyboardQwertyKeyStyle.SetKey(const Value: SmallInt);
begin
  FKey := Value;

  UpdateDisplayKeyChar;
end;

procedure TVirtualKeyboardQwertyKeyStyle.SetKeyRef(const Value: Integer);
begin
  FKeyRef := Value;
  FKey := VkKeyScan(VIRTUAL_KEY_ENGLISH[KeyRef]);

  UpdateDisplayKeyChar;
end;

procedure TVirtualKeyboardQwertyKeyStyle.UpdateDisplayKeyChar;
var
  KeyChar: Char;
begin
  KeyChar := GetKeyChar;

  if KeyChar = '&' then
    Text.Text := '&&'
  else
    Text.Text := KeyChar;
end;

end.
