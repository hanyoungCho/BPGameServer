unit Frame.Select.Box.Floor.Item.Ver2.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TSelectBoxFloorItemVer2Style = class(TFrame)
    Layout: TLayout;
    SideRectangle: TRectangle;
    FloorRectangle: TRectangle;
    Text: TText;
    Rectangle: TRectangle;
    procedure RectangleClick(Sender: TObject);
  private
    { Private declarations }
    FFloor: Integer;
  public
    { Public declarations }
    //procedure Display(AFloor: Integer);
    //chy 2020-11-04 Ãþ¸íÄª
    procedure Display(AFloor: Integer; AFloorNm: String);
  end;

implementation

uses
  Form.Select.Box, uCommon, uGlobal;

{$R *.fmx}

{ TSelectBoxFloorItemVer2Style }

//procedure TSelectBoxFloorItemVer2Style.Display(AFloor: Integer);
procedure TSelectBoxFloorItemVer2Style.Display(AFloor: Integer; AFloorNm: String);
begin
  FFloor := AFloor;
  if AFloor = -1 then
    Text.Text := 'ÀüÃ¼'
  else
  begin
    //chy 2020-11-04 Ãþ¸íÄª-¼Ûµµ ¿äÃ»
    //Text.Text := IntToStr(AFloor) + 'F';
    Text.Text := AFloorNm;
  end;

end;

procedure TSelectBoxFloorItemVer2Style.RectangleClick(Sender: TObject);
begin
  TouchSound;
  Global.SaleModule.AllTeeBoxShow := FFloor = -1;
  SelectBox.TimerInc := 0;
  SelectBox.ChangeFloor(FFloor, 1);
end;

end.
