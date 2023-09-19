unit Frame.Popup.Print;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TPopupPrint = class(TFrame)
    Layout: TLayout;
    Rectangle1: TRectangle;
    txtTitle: TText;
    Image1: TImage;
    Text: TText;
    Rectangle2: TRectangle;
    Text2: TText;
    Rectangle3: TRectangle;
    Layout1: TLayout;
    procedure Rectangle2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Form.Popup, uCommon;

{$R *.fmx}

procedure TPopupPrint.Image1Click(Sender: TObject);
begin
  TouchSound;
end;

procedure TPopupPrint.Rectangle2Click(Sender: TObject);
begin
  TouchSound;
  Popup.PrintCancel;
end;

end.
