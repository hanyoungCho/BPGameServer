unit Frame.Sale.Game.DC.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TSaleGameDCItemStyle = class(TFrame)
    Layout1: TLayout;
    txtDC: TText;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Display(AData: String);
  end;

implementation

{$R *.fmx}


procedure TSaleGameDCItemStyle.Display(AData: String);
begin
  txtDC.Text := AData;
end;

end.
