unit Frame.PromotionList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, Frame.PromotionList.Item;

type
  TFullPopupPrormotionList = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Display;
  end;

implementation

uses
  uGlobal;

{$R *.fmx}

{ TFullPopupPrormotionList }

procedure TFullPopupPrormotionList.Display;
var
  CardName: string;
  Index: Integer;
  Y, X: Single;
  APosition: TPosition;
  APoint: TPointF;
  AFullPopupPromotionListItem: TFullPopupPromotionListItem;
begin
  try
    X := 0;
    Y := 0;
    APoint := TPointF.Create(Y, X);
    APosition := TPosition.Create(APoint);

    //Á¦ÈÞ»ç ¸ñ·Ï
    for Index := 0 to 4 do
    begin
      {
      if Index = 0 then
      begin
        if Global.Config.Wellbeing.Use = False then
          Continue;

        if Global.SaleModule.FProductCdWellbeing = EmptyStr then
          Continue;
      end;

      if Index = 1 then
      begin
        if Global.Config.BCPaybookGolf.Use = False then
          Continue;

        if Global.SaleModule.FProductCdBCPaybookGolf = EmptyStr then
          Continue;
      end;

      if Index = 2 then
      begin
        if Global.Config.RefreshClub.Use = False then
          Continue;

        if Global.SaleModule.FProductCdRefreshclub = EmptyStr then
          Continue;
      end;

      if Index = 3 then
      begin
        if Global.Config.TheLoungeMembers.Use = False then
          Continue;

        if Global.SaleModule.FProductCdTheloungemembers = EmptyStr then
          Continue;
      end;

      if Index = 4 then
      begin
        if Global.Config.Ikozen.Use = False then
          Continue;

        if Global.SaleModule.FProductCdIkozen = EmptyStr then
          Continue;
      end;
      }
      if Index = 0 then
        CardName := 'À£ºùÅ¬·´';

      if Index = 1 then
        CardName := '¹«·á°ñÇÁ';

      if Index = 2 then
        CardName := '¸®ÇÁ·¹½¬Å¬·´';

      if Index = 3 then
        CardName := '´õ¶ó¿îÁö¸â¹ö½º';

      if Index = 4 then
        CardName := '¾ÆÀÌÄÚÁ¨';

      AFullPopupPromotionListItem := TFullPopupPromotionListItem.Create(nil);

      AFullPopupPromotionListItem.Align := TAlignLayout.Top;
      AFullPopupPromotionListItem.Margins.Top := 30;

      AFullPopupPromotionListItem.Display(Index, CardName);
      AFullPopupPromotionListItem.Parent := Rectangle;

    end;
  finally
    APosition.Free;
  end;
end;

end.
