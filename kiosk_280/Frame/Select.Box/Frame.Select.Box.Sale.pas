unit Frame.Select.Box.Sale;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Generics.Collections,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Ani,
  Frame.Select.Box.Sale.Item.Style;

type
  TSelectBoxSale = class(TFrame)
    Timer: TTimer;
    recBG: TRectangle;
    Layout: TLayout;
    VertScrollBox: TVertScrollBox;
    BottomLayout: TLayout;
    BGRectangle: TRectangle;
    recTime: TRectangle;
    txtTime: TText;
    Image7: TImage;
    recLaneBottom: TRectangle;
    Image6: TImage;
    recLaneTop: TRectangle;
    Image4: TImage;
    procedure TimerTimer(Sender: TObject);
    procedure VertScrollBoxViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure VertScrollBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure VertScrollBoxClick(Sender: TObject);
  private
    { Private declarations }
    FItemList: TList<TSelectBoxSaleItemStyle>;

    FMouseDownX: Extended;
    FMouseDownY: Extended;

    FListHeight: single;
  public
    { Public declarations }
    iSec: Integer;

    procedure Display;

    procedure CloseFrame;

    property ItemList: TList<TSelectBoxSaleItemStyle> read FItemList write FItemList;
  end;

implementation

uses
  uGlobal, uStruct, uFunction, uConsts, Form.Select.Box;

{$R *.fmx}


procedure TSelectBoxSale.CloseFrame;
var
  Index: Integer;
begin
  if ItemList <> nil then
  begin
    for Index := ItemList.Count - 1 downto 0 do
      RemoveObject(ItemList[Index]);//ItemList.Delete(Index);

    ItemList.Free;
  end;
end;

procedure TSelectBoxSale.Display;
var
  Index: Integer;
  rLaneInfo: TLaneInfo;
  AProduct: TMemberShipProductInfo;
  AItemStyle: TSelectBoxSaleItemStyle;
  RowIndex, ColIndex, AddWidth: Integer;
  Rectangle: TRectangle;
begin

  if FItemList = nil then
    FItemList := TList<TSelectBoxSaleItemStyle>.Create;

  if FItemList.Count <> 0 then
  begin
    for Index := FItemList.Count - 1 downto 0 do
      FItemList.Delete(Index);

    FItemList.Clear;
  end;

  RowIndex := 0;
  ColIndex := 0;
  AddWidth := 0;

  for Index := 0 to Global.SaleModule.SaleMemberShipProdList.Count - 1 do
  begin
    AProduct := Global.SaleModule.SaleMemberShipProdList[Index];

    //chy 상품 사용,삭제 확인
    if AProduct.DelYn = 'Y' then
      Continue;

    if AProduct.UseYn <> 'Y' then
      Continue;

    if ColIndex = 2 then
    begin
      Inc(RowIndex);
      ColIndex := 0;
      AddWidth := 0;
    end;

    AItemStyle := TSelectBoxSaleItemStyle.Create(nil);
    AItemStyle.Position.X := ColIndex * AItemStyle.Width + 60 + (AddWidth * 52);
    AItemStyle.Position.Y := RowIndex * AItemStyle.Height + (RowIndex * 52);
    AItemStyle.Parent := VertScrollBox;
    AItemStyle.Bind(AProduct);

    FItemList.Add(AItemStyle);
    Inc(ColIndex);
    Inc(AddWidth);

    if Index = (Global.SaleModule.SaleMemberShipProdList.Count - 1) then
      FListHeight := AItemStyle.Position.Y + AItemStyle.Height;
  end;

  recLaneTop.Visible := False;
  recLaneBottom.Visible := False;

  //하단 공관 확보용
  if FListHeight > VertScrollBox.Height then
  begin
    Rectangle := TRectangle.Create(nil);
    Rectangle.Position.X := 0;
    Rectangle.Position.Y := FListHeight;
    Rectangle.Fill.Color := TAlphaColorRec.Null;
    Rectangle.Stroke.Thickness := 0;
    Rectangle.Height := 26;
    Rectangle.Parent := VertScrollBox;//Layout;

    recLaneBottom.Visible := True;
  end;

end;

procedure TSelectBoxSale.TimerTimer(Sender: TObject);
begin
	Inc(iSec);
	txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - iSec), 2, ' ')]);
  if (Time30Sec - iSec) = 0 then
    SelectBox.ChangeMenu(0);
end;

procedure TSelectBoxSale.VertScrollBoxClick(Sender: TObject);
var
  I: Integer;
  MouseService: IFMXMouseService;
  P: TPointF;
begin
  if SupportsPlatformService(IFMXMouseService, MouseService) then
  begin
    P := MouseService.GetMousePos;

    if Abs(P.X - FMouseDownX) > 10 then
      Exit;

    if Abs(P.Y - FMouseDownY) > 10 then
      Exit;
  end;

end;

procedure TSelectBoxSale.VertScrollBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  MouseService: IFMXMouseService;
  P: TPointF;
begin
  if SupportsPlatformService(IFMXMouseService, MouseService) then
  begin
    P := MouseService.GetMousePos;

    FMouseDownX := P.X;
    FMouseDownY := P.Y;
  end;

end;

procedure TSelectBoxSale.VertScrollBoxViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin
  if FListHeight < VertScrollBox.Height then
    Exit;

  if NewViewportPosition.y > 0 then
    recLaneTop.Visible := True
  else
    recLaneTop.Visible := False;

  if NewViewportPosition.y > (FListHeight - VertScrollBox.Height - 10) then
    recLaneBottom.Visible := False
  else
    recLaneBottom.Visible := True;
end;

end.
