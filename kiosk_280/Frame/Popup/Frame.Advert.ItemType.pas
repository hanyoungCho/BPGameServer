unit Frame.Advert.ItemType;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TfrmAdvertItemType = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
    txtTitle: TText;
    Text9: TText;
    recMember: TRectangle;
    Text10: TText;
    CloseRectangle: TRectangle;
    Image4: TImage;
    txtClose: TText;
    txtTime: TText;
    recNew: TRectangle;
    imgNew: TImage;
    Text1: TText;
    imgMember: TImage;
    procedure CloseRectangleClick(Sender: TObject);
    procedure RectangleClick(Sender: TObject);
    procedure imgMemberClick(Sender: TObject);
    procedure imgNewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Form.Popup, uConsts, uGlobal, uFunction, uCommon;

{$R *.fmx}

procedure TfrmAdvertItemType.CloseRectangleClick(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TfrmAdvertItemType.imgMemberClick(Sender: TObject);
begin
  Global.SaleModule.memberItemType := mitCoupon;
  Popup.CloseFormStrMrok('');
end;

procedure TfrmAdvertItemType.imgNewClick(Sender: TObject);
begin
  Global.SaleModule.memberItemType := mitNew;
  Popup.CloseFormStrMrok('');
end;

procedure TfrmAdvertItemType.RectangleClick(Sender: TObject);
begin
  TouchSound;
end;

end.
