unit Form.Lock;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects;

type
  TKIOSKLock = class(TForm)
    Layout: TLayout;
    Rectangle: TRectangle;
    Image: TImage;
    Text: TText;
    Text1: TText;
    Text2: TText;
    procedure ImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KIOSKLock: TKIOSKLock;

implementation

uses
  uGlobal, uCommon, uConsts;

{$R *.fmx}

procedure TKIOSKLock.ImageClick(Sender: TObject);
begin
  Global.SaleModule.PopUpLevel := plAuthentication;

  if not ShowPopup then
    Exit;
  Close;
end;

end.
