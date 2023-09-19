unit Frame.Select.Box.Product;

interface

uses
  Frame.Select.Box.Product.Item.Style, FMX.Ani,
  System.Generics.Collections, System.DateUtils, uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TSelectBoxProduct = class(TFrame)
    Layout: TLayout;
    Image: TImage;
    VertScrollBox: TVertScrollBox;
    BGRectangle: TRectangle;

    procedure VertScrollBoxClick(Sender: TObject);
    procedure VertScrollBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure VertScrollBoxViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
  private
    { Private declarations }
    FItemList: TList<TSelectBoxProductItemStyle>;

    FMouseDownX: Extended;
    FMouseDownY: Extended;
  public
    { Public declarations }
    procedure DisplayInit;
    procedure DisplayStatus;

    procedure Animate(ItemStyle: TSelectBoxProductItemStyle);
    procedure CloseFrame;

    property ItemList: TList<TSelectBoxProductItemStyle> read FItemList write FItemList;
  end;

implementation

uses
  uGlobal, uFunction, fx.Logging, uConsts, uCommon, Form.Select.Box;

{$R *.fmx}

{ TSelectBoxProduct }

procedure TSelectBoxProduct.Animate(ItemStyle: TSelectBoxProductItemStyle);
var
  Bitmap: TBitmap;
begin
  Bitmap := ItemStyle.MakeScreenshot;
  try
    try
      Image.Bitmap.Assign(Bitmap);
      Image.Visible := True;
      Image.Position.X := ItemStyle.Position.X - (VertScrollBox.Position.X - 140);
      Image.Position.Y := VertScrollBox.Margins.Top + ItemStyle.Position.Y - VertScrollBox.Position.Y;
      Image.Width := ItemStyle.Width;
      Image.Height := ItemStyle.Height;
      Image.Scale.X := 1;
      Image.Scale.Y := 1;
      Image.Opacity := 0.8;
    except
      on E: Exception do
        Log.E('TSelectBoxProduct.Animate', E.Message);
    end;
  finally
    Bitmap.Free;
  end;
  TAnimator.AnimateFloat(Image, 'Position.X', Image.Position.X - Image.Width * 0.3, 0.5);
  TAnimator.AnimateFloat(Image, 'Position.Y', Image.Position.Y - Image.Height * 0.3, 0.5);
  TAnimator.AnimateFloat(Image, 'Scale.X', 1.6, 0.5);
  TAnimator.AnimateFloat(Image, 'Scale.Y', 1.6, 0.5);
  TAnimator.AnimateFloat(Image, 'Opacity', 0, 0.5);
//  TAnimator.StopAnimation(Self, '');
end;

procedure TSelectBoxProduct.CloseFrame;
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

procedure TSelectBoxProduct.DisplayInit;
var
  Index, ColIndex, RowIndex: Integer;
  ASelectBoxProductItemStyle: TSelectBoxProductItemStyle;
  rLaneInfo: TLaneInfo;
begin
  try
    try

      if FItemList = nil then
        FItemList := TList<TSelectBoxProductItemStyle>.Create;

      if FItemList.Count <> 0 then
      begin
        for Index := FItemList.Count - 1 downto 0 do
          FItemList.Delete(Index);

        FItemList.Clear;
      end;

      RowIndex := 0;
      ColIndex := 0;

      for Index := VertScrollBox.Content.ChildrenCount - 1 downto 0 do
        VertScrollBox.Content.Children[Index].Free;

      VertScrollBox.Content.DeleteChildren;
      VertScrollBox.Content.Repaint;

      for Index := 0 to Global.Teebox.LaneCnt - 1 do
      begin
        rLaneInfo := Global.Teebox.GetLaneInfo(Index);

        if ColIndex = 4 then
        begin
          Inc(RowIndex);
          ColIndex := 0;
        end;

        ASelectBoxProductItemStyle := TSelectBoxProductItemStyle.Create(nil);

        // юс╫ц 4*4
        ASelectBoxProductItemStyle.Scale.x := 1.3;
        ASelectBoxProductItemStyle.Scale.y := 1.3;
        ASelectBoxProductItemStyle.Position.X := 35 + (14 * ColIndex) + ColIndex * (ASelectBoxProductItemStyle.Width * 1.3);
        ASelectBoxProductItemStyle.Position.Y := 15 + (14 * RowIndex) + RowIndex * (ASelectBoxProductItemStyle.Height * 1.3);

        ASelectBoxProductItemStyle.Parent := VertScrollBox;//Layout;
        ASelectBoxProductItemStyle.LaneInfo := rLaneInfo;

        ASelectBoxProductItemStyle.DisPlayLaneInfo;

        ItemList.Add(ASelectBoxProductItemStyle);
        Inc(ColIndex);

      end;

    except
      on E: Exception do
        Log.E('TSelectBoxProduct.DisplayInit', E.Message);
    end;
  finally

  end;
end;

procedure TSelectBoxProduct.DisplayStatus;
var
  Index: Integer;
  rLaneInfo: TLaneInfo;
begin

  try

    if FItemList.Count = 0 then
      Exit;

    for Index := 0 to ItemList.Count - 1 do
    begin
      rLaneInfo := Global.Teebox.GetLaneInfo(Index);
      ItemList[Index].LaneInfo := rLaneInfo;
      ItemList[Index].DisPlayLaneInfo;
    end;
  except
    on E: Exception do
      Log.E('TSelectBoxProduct.DisplayStatus', E.Message);
  end;

end;

procedure TSelectBoxProduct.VertScrollBoxClick(Sender: TObject);
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

procedure TSelectBoxProduct.VertScrollBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
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

procedure TSelectBoxProduct.VertScrollBoxViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin
//
end;

end.
