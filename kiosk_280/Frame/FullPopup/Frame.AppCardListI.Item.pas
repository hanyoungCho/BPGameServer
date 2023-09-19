unit Frame.AppCardListI.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Effects, System.ImageList, FMX.ImgList;

type
  TFullPopupAppCardListItem = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
    imgPayco: TImage;
    Text1: TText;
    recImg: TRectangle;
    imgNPay: TImage;
    imgKPay: TImage;
    procedure RectangleClick(Sender: TObject);
  private
    { Private declarations }
    FItemIndex: Integer;
    IsClick: Boolean;
  public
    { Public declarations }
    procedure Display(AItemIndex: Integer; AText: string);
  end;

implementation

uses
  Form.Full.Popup;

{$R *.fmx}

{ TFullPopupAppCardListItem }

procedure TFullPopupAppCardListItem.Display(AItemIndex: Integer; AText: string);
begin
  FItemIndex := AItemIndex;
  if FItemIndex = 0 then
    imgPayco.Visible := True;

  if FItemIndex = 1 then
    imgNPay.Visible := True;

  if FItemIndex = 2 then
    imgKPay.Visible := True;

  //Text1.Text := AText;
  IsClick := False;
end;

procedure TFullPopupAppCardListItem.RectangleClick(Sender: TObject);
begin
  if not IsClick then
  begin
    IsClick := True;
    //FullPopup.ApplyAppCard(FItemIndex, Text1.Text);
  end;
end;

end.
