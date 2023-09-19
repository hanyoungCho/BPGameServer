unit Frame.Popup.Halbu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, Generics.Collections,
  {frame}
  Frame.Popup.Halbu.Item;

type
  TPopupHalbu = class(TFrame)
    recHalbuList: TRectangle;
    Text3: TText;
    recBtn: TRectangle;
    Text5: TText;
    recCancel: TRectangle;
    Text17: TText;
    recOk: TRectangle;
    Text18: TText;
    recAmt: TRectangle;
    Rectangle8: TRectangle;
    txtProductAmtCaption: TText;
    txtProductAmt: TText;
    Rectangle9: TRectangle;
    txtProductVatAmtCaption: TText;
    txtDiscountAmt: TText;
    Rectangle10: TRectangle;
    txtProductTotalAmtCaption: TText;
    txtProductTotalAmt: TText;
    Rectangle13: TRectangle;
    Text2: TText;
    txtProductVatAmt: TText;
    LayoutBG: TLayout;
    LayoutBody: TLayout;
    Rectangle5: TRectangle;
    Text12: TText;
    Text13: TText;
    Text14: TText;
    Text15: TText;
    procedure Rectangle4Click(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
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
  Form.Popup, uGlobal, uCommon, uConsts;

{$R *.fmx}

{ THalbu }

procedure TPopupHalbu.DisPlay;
var
  Index, Loop, RowIndex, ColIndex: Integer;
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

  if Global.SaleModule.memberItemType = mitBuy then
  begin
    Vat := Global.SaleModule.SaleSelectMemberShipProd.ProdAmt - Trunc(Global.SaleModule.SaleSelectMemberShipProd.ProdAmt / 1.1);

    txtProductTotalAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.SaleSelectMemberShipProd.ProdAmt)]);
    txtProductAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.SaleSelectMemberShipProd.ProdAmt)]);
    txtDiscountAmt.Text := '0원';
    txtProductVatAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Vat)]);
  end
  else
  begin
    txtProductAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelTotalAmt)]);
    txtProductVatAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelVatAmt)]);
    txtProductTotalAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelRealAmt)]);
    txtDiscountAmt.Text := Format('%s원', [FormatFloat('#,##0.##', Global.SaleModule.PaySelDCAmt)]);
  end;

  recOk.Enabled := False;
  SelectHalbu(0);
end;

procedure TPopupHalbu.CloseFrame;
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

procedure TPopupHalbu.SelectHalbu(AIdx: Integer);
var
  Index: Integer;
begin
  for Index := 0 to FItemList.Count - 1 do
  begin
    if FItemList[Index].FIdx = AIdx then
      FItemList[Index].SelectDisPlay(True)
    else
      FItemList[Index].SelectDisPlay(False);
  end;
  recOk.Enabled := True;
end;

procedure TPopupHalbu.Rectangle4Click(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TPopupHalbu.Rectangle5Click(Sender: TObject);
var
  AHalbu: Integer;
begin
  //AHalbu := StrToIntDef(txtPw6.Text + txtPw5.Text, 0);
  //Popup.CloseFormStrMrok('');


  TouchSound;
  //Global.SaleModule.CardApplyType := catMagnetic;
  //FullPopup.ApplyCard('', False, False);
end;

end.
