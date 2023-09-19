unit Frame.FullPopup.Print;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TFullPopupPrint = class(TFrame)
    Layout: TLayout;
    Rectangle1: TRectangle;
    txtTasukInfo: TText;
    Text4: TText;
    Image1: TImage;
    Text: TText;
    Rectangle2: TRectangle;
    Text2: TText;
    Image2: TImage;
    Text1: TText;
    procedure Rectangle2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Form.Full.Popup, uCommon;

{$R *.fmx}

procedure TFullPopupPrint.Image1Click(Sender: TObject);
begin
  TouchSound;
end;

procedure TFullPopupPrint.Rectangle2Click(Sender: TObject);
begin
  TouchSound;
  FullPopup.PrintCancel; //2021-05-13 이종섭과장 요청
end;

end.
