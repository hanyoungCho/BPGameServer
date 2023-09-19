unit Frame.Select.Box.Top.Map.List.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TSelectBoxTopMapItemStyle = class(TFrame)
    Layout: TLayout;
    Text: TText;
    Timer: TTimer;
    recBody: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetText(AText: string);
  end;

implementation

{$R *.fmx}

{ TSelectBoxTopMapItemStyle }

procedure TSelectBoxTopMapItemStyle.SetText(AText: string);
begin
  Text.Text := AText;
end;

end.
