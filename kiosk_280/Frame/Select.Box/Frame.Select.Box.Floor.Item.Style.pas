unit Frame.Select.Box.Floor.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TSelectBoxFloorItemStyle = class(TFrame)
    Layout: TLayout;
    Text: TText;
    RoundRect: TRoundRect;
    procedure TextClick(Sender: TObject);
  private
    { Private declarations }
    FFloor: Integer;
  public
    { Public declarations }
    procedure Display(AFloor: Integer);
  end;

implementation

uses
  Form.Select.Box, uCommon, uGlobal;

{$R *.fmx}

{ TSelectBoxPloorItemStyle }

procedure TSelectBoxFloorItemStyle.Display(AFloor: Integer);
begin
  FFloor := AFloor;
  if FFloor = -1 then
    Text.Text := 'ÀüÃ¼'
  else
    Text.Text := IntToStr(AFloor) + 'F';
end;

procedure TSelectBoxFloorItemStyle.TextClick(Sender: TObject);
begin
  TouchSound;
  Global.SaleModule.AllTeeBoxShow := FFloor = -1;
  SelectBox.TimerInc := 0;
  SelectBox.ChangeFloor(FFloor, 1);
end;

end.
