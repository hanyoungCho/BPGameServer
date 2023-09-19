unit Frame.SaleBox.Page.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TSaleBoxPageItemStyle = class(TFrame)
    Layout: TLayout;
    Circle: TCircle;
    Text: TText;
    procedure TextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IndexPage: Integer;
  end;

implementation

uses
  Form.Sale.Product;

{$R *.fmx}

procedure TSaleBoxPageItemStyle.TextClick(Sender: TObject);
begin
  SaleProduct.SelectPage(IndexPage);
end;

end.
