unit Frame.XGolfEvent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TXGolfEvent = class(TFrame)
    Rectangle3: TRectangle;
    Image: TImage;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Image1: TImage;
    Text1: TText;
    Rectangle4: TRectangle;
    Image2: TImage;
    Text2: TText;
    Text3: TText;
    Rectangle5: TRectangle;
    ImgLine1: TImage;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    Image4: TImage;
    Rectangle8: TRectangle;
    Image3: TImage;
    MinusRec: TRectangle;
    PlusRec: TRectangle;
    txtSaleQty: TText;
    Text4: TText;
    Text5: TText;
    Text6: TText;
    Text7: TText;
    Rectangle9: TRectangle;
    Image5: TImage;
    Rectangle10: TRectangle;
    Rectangle11: TRectangle;
    Text8: TText;
    recPolicyAll: TRectangle;
    imgPolicyAllNon: TImage;
    imgPolicyAll: TImage;
    Text9: TText;
    Rectangle12: TRectangle;
    Image6: TImage;
    Image7: TImage;
    Text10: TText;
    Text11: TText;
    Text12: TText;
    Rectangle13: TRectangle;
    Image8: TImage;
    Image9: TImage;
    Text13: TText;
    procedure Rectangle11Click(Sender: TObject);
    procedure Rectangle12Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Form.Popup;

{$R *.fmx}

procedure TXGolfEvent.Rectangle11Click(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TXGolfEvent.Rectangle12Click(Sender: TObject); //응모하기
begin
  Popup.CloseFormStrMrok('');
end;

end.
