unit Frame.Select.Box.Lane;

interface

uses
  FMX.Ani,
  System.Generics.Collections, System.DateUtils, uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  {frame}
  Frame.Select.Box.Lane.Item.Style, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TSelectBoxLane = class(TFrame)
    Layout: TLayout;
    Image: TImage;
    VertScrollBox: TVertScrollBox;
    recBG: TRectangle;
    recLaneTop: TRectangle;
    Image4: TImage;
    recLaneBottom: TRectangle;
    Image6: TImage;

    procedure VertScrollBoxClick(Sender: TObject);
    procedure VertScrollBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure VertScrollBoxViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
  private
    { Private declarations }
    FItemList: TList<TSelectBoxLaneItemStyle>;

    FMouseDownX: Extended;
    FMouseDownY: Extended;

    FListHeight: single;
  public
    { Public declarations }
    procedure DisplayInit;
    procedure DisplayStatus;

    //procedure Animate(ItemStyle: TSelectBoxLaneItemStyle);
    procedure CloseFrame;

    property ItemList: TList<TSelectBoxLaneItemStyle> read FItemList write FItemList;
  end;

implementation

uses
  uGlobal, uFunction, fx.Logging, uConsts, uCommon, Form.Select.Box;

{$R *.fmx}

{ TSelectBoxProduct }
{
procedure TSelectBoxLane.Animate(ItemStyle: TSelectBoxLaneItemStyle);
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
 }
procedure TSelectBoxLane.CloseFrame;
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

procedure TSelectBoxLane.DisplayInit;
var
  Index, ColIndex, RowIndex: Integer;
  AItemStyle: TSelectBoxLaneItemStyle;
  Rectangle: TRectangle;
  rLaneInfo: TLaneInfo;
begin
  try
    try

      if FItemList = nil then
        FItemList := TList<TSelectBoxLaneItemStyle>.Create;

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

      for Index := 0 to Global.Lane.LaneCnt - 1 do
      begin
        rLaneInfo := Global.Lane.GetLaneInfo(Index);

        if ColIndex = 4 then
        begin
          Inc(RowIndex);
          ColIndex := 0;
        end;

        AItemStyle := TSelectBoxLaneItemStyle.Create(nil);

        AItemStyle.Position.X := ColIndex * AItemStyle.Width;
        if ColIndex = 1 then
          AItemStyle.Position.X := AItemStyle.Position.X + 15
        else if ColIndex = 2 then
          AItemStyle.Position.X := AItemStyle.Position.X + 15 + 50
        else if ColIndex = 3 then
          AItemStyle.Position.X := AItemStyle.Position.X + 15 + 50 + 15;

        AItemStyle.Position.Y := (32 * RowIndex) + (RowIndex * AItemStyle.Height) + 26;

        AItemStyle.Parent := VertScrollBox;//Layout;
        AItemStyle.LaneInfo := rLaneInfo;

        AItemStyle.DisPlayLaneInfo;

        ItemList.Add(AItemStyle);
        Inc(ColIndex);

        if Index = (Global.Lane.LaneCnt - 1) then
          FListHeight := AItemStyle.Position.Y + AItemStyle.Height;

      end;

      recLaneTop.Visible := False;
      recLaneBottom.Visible := False;

      //하단 공관 확보용
      if FListHeight > VertScrollBox.Height then
      begin
        {
        AItemStyle := TSelectBoxLaneItemStyle.Create(nil);
        AItemStyle.Position.X := 0;
        AItemStyle.Position.Y := FListHeight;
        AItemStyle.Height := 26;
        AItemStyle.Parent := VertScrollBox;//Layout;
        }

        Rectangle := TRectangle.Create(nil);
        Rectangle.Position.X := 0;
        Rectangle.Position.Y := FListHeight;
        Rectangle.Fill.Color := TAlphaColorRec.Null;
        Rectangle.Stroke.Thickness := 0;
        Rectangle.Height := 26;
        Rectangle.Parent := VertScrollBox;//Layout;

        FListHeight := FListHeight + 26;

        recLaneBottom.Visible := True;
      end;

    except
      on E: Exception do
        Log.E('TSelectBoxLane.DisplayInit', E.Message);
    end;
  finally

  end;
end;

procedure TSelectBoxLane.DisplayStatus;
var
  Index: Integer;
  rLaneInfo: TLaneInfo;
begin

  try

    if FItemList.Count = 0 then
      Exit;

    for Index := 0 to ItemList.Count - 1 do
    begin
      rLaneInfo := Global.Lane.GetLaneInfo(Index);
      ItemList[Index].LaneInfo := rLaneInfo;
      ItemList[Index].DisPlayLaneInfo;
    end;
  except
    on E: Exception do
      Log.E('TSelectBoxProduct.DisplayStatus', E.Message);
  end;

end;

procedure TSelectBoxLane.VertScrollBoxClick(Sender: TObject);
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

procedure TSelectBoxLane.VertScrollBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
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

procedure TSelectBoxLane.VertScrollBoxViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin
  //memo1.Visible := False;
  //memo1.Lines.Add(FloatToStr(NewViewportPosition.X) + ' / ' + FloatToStr(NewViewportPosition.y));

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
