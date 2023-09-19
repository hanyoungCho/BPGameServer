unit Frame.AppCardList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, Frame.AppCardListI.Item;

type
  TFullPopupAppCardList = class(TFrame)
    Layout: TLayout;
    recBg: TRectangle;
    recList: TRectangle;
    Text1: TText;
    recBtn: TRectangle;
    Text17: TText;
    Text18: TText;
    LayoutBG: TLayout;
    recCancel: TRectangle;
    recOk: TRectangle;
    procedure recCancelClick(Sender: TObject);
    procedure recOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Display;
  end;

implementation

uses
  uGlobal, Form.Full.Popup;

{$R *.fmx}

{ TFullPopupAppCardList }

procedure TFullPopupAppCardList.Display;
var
  CardName: string;
  Index: Integer;
  AFullPopupAppCardListItem: TFullPopupAppCardListItem;
begin
  try

    for Index := 0 to 2 do
    begin
      if Index = 0 then
      begin
        CardName := 'PAYCO'
      end
      else if Index = 1 then
      begin
        CardName := 'NPay';
      end
      else if Index = 2 then
      begin
        CardName := 'KPay';
      end;

      AFullPopupAppCardListItem := TFullPopupAppCardListItem.Create(nil);

      AFullPopupAppCardListItem.Position.X := 0;
      AFullPopupAppCardListItem.Position.Y := (Index * AFullPopupAppCardListItem.Height) + (Index * 60);

      AFullPopupAppCardListItem.Display(Index, CardName);
      AFullPopupAppCardListItem.Parent := recList;

    end;
  finally

  end;
end;

procedure TFullPopupAppCardList.recCancelClick(Sender: TObject);
begin
  FullPopup.CloseFormStrMrCancel;
end;

procedure TFullPopupAppCardList.recOkClick(Sender: TObject);
begin
   FullPopup.CloseFormStrMrCancel;
end;

end.
