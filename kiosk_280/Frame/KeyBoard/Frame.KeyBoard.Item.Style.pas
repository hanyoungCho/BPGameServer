unit Frame.KeyBoard.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, Winapi.Windows;

type
  TKeyBoardItemStyle = class(TFrame)
    Text: TText;
    KeyRectangle: TRectangle;
    imgDel: TImage;
    imgDelWhite: TImage;
    procedure KeyRectangleClick(Sender: TObject);
    procedure FrameKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    FKey: ShortInt;
  public
    { Public declarations }
    procedure ClearFrame;
    property Key: ShortInt read Fkey write FKey;
  end;

implementation

uses
  Form.Full.Popup, uCommon;

{$R *.fmx}

procedure TKeyBoardItemStyle.ClearFrame;
begin
  KeyRectangle.Free;
  Text.Free;
end;

procedure TKeyBoardItemStyle.FrameKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FullPopup.KeyDown(Key, Keychar, Shift);
end;

procedure TKeyBoardItemStyle.KeyRectangleClick(Sender: TObject);
begin
  TouchSound;
  Keybd_Event(Key, Key, 0, 0);
  Keybd_Event(Key, Key, KEYEVENTF_KEYUP, 0);
end;

end.
