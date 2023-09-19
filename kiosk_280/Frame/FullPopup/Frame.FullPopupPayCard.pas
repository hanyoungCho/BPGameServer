unit Frame.FullPopupPayCard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.EditBox, FMX.SpinBox,
  FMX.Layouts,
  Generics.Collections,
  {frame}
  Frame.Popup.Halbu.Item;

type
  TFullPopupPayCard = class(TFrame)
    LayoutBG: TLayout;
    Rectangle14: TRectangle;
    LayoutBody: TLayout;
    recHalbuList: TRectangle;
    recBtn: TRectangle;
    Text6: TText;
    Text7: TText;
    recAmt: TRectangle;
    Rectangle15: TRectangle;
    Text8: TText;
    txtProductAmt: TText;
    Text14: TText;
    Rectangle16: TRectangle;
    Text10: TText;
    txtDiscountAmt: TText;
    Text13: TText;
    Rectangle17: TRectangle;
    Text12: TText;
    txtProductTotalAmt: TText;
    Text16: TText;
    Rectangle18: TRectangle;
    Text19: TText;
    txtProductVatAmt: TText;
    Text21: TText;
    Text22: TText;
    Text23: TText;
    recCancel: TRectangle;
    recOk: TRectangle;
    procedure recOkClick(Sender: TObject);
    procedure recCancelClick(Sender: TObject);
  private
    { Private declarations }
    FItemList: TList<TPopupHalbuItem>;

  public
    { Public declarations }
    procedure DisPlay;
    procedure SelectHalbu(AIdx: Integer);
    procedure CloseFrame;
  end;

implementation

uses
  uGlobal, uCommon, Form.Full.Popup, uConsts;

{$R *.fmx}

{ TFullPopupPayCard }

procedure TFullPopupPayCard.DisPlay;
var
  Index, RowIndex, ColIndex: Integer;
  AItem: TPopupHalbuItem;
  Vat: Currency;
begin

  try
    RowIndex := 0;
    ColIndex := 0;

    if FItemList = nil then
      FItemList := TList<TPopupHalbuItem>.Create;

    if FItemList.Count <> 0 then
    begin
      for Index := FItemList.Count - 1 downto 0 do
        FItemList.Delete(Index);

      FItemList.Clear;
    end;

    for Index := 0 to 7 do
    begin

      if ColIndex = 3 then
      begin
        ColIndex := 0;
        Inc(RowIndex);
      end;

      AItem := TPopupHalbuItem.Create(nil);
      AItem.Position.X := (ColIndex * AItem.Width) + (ColIndex * 22);
      AItem.Position.Y := (RowIndex * AItem.Height) + (RowIndex * 28);
      AItem.DisPlay(Index);
      AItem.Parent := recHalbuList;

      FItemList.Add(AItem);
      Inc(ColIndex);
    end;

  finally

  end;

  txtProductAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelTotalAmt)]);
  txtProductVatAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelVatAmt)]);
  txtProductTotalAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelRealAmt)]);
  txtDiscountAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelDCAmt)]);

  recOk.Enabled := False;
  SelectHalbu(0);

end;

procedure TFullPopupPayCard.CloseFrame;
var
  Index: Integer;
begin
  if FItemList <> nil then
  begin
    for Index := FItemList.Count - 1 downto 0 do
      RemoveObject(FItemList[Index]);

    FItemList.Free;
  end;

end;

procedure TFullPopupPayCard.SelectHalbu(AIdx: Integer);
var
  Index: Integer;
begin
  FullPopup.ResetTimerCnt;

  for Index := 0 to FItemList.Count - 1 do
  begin
    if FItemList[Index].FIdx = AIdx then
      FItemList[Index].SelectDisPlay(True)
    else
      FItemList[Index].SelectDisPlay(False);
  end;
  recOk.Enabled := True;
end;

procedure TFullPopupPayCard.recCancelClick(Sender: TObject);
begin
  TouchSound;
  FullPopup.CloseFormStrMrCancel;
end;

procedure TFullPopupPayCard.recOkClick(Sender: TObject);
begin
  TouchSound;
  Global.SaleModule.CardApplyType := catMagnetic;
  FullPopup.ApplyCard('', False, False);
end;

end.
