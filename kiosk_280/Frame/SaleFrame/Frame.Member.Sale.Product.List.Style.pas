unit Frame.Member.Sale.Product.List.Style;

interface

uses
  FMX.Ani,
  DateUtils,
  Generics.Collections,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects,
  uStruct,
  Frame.Member.Sale.Product.Item.Style;

type
  TMemberSaleProductListStyle = class(TFrame)
    Layout: TLayout;
    Rectangle: TRectangle;
    ItemRectangle: TRectangle;
    UpImage: TImage;
    DownImage: TImage;
    Image: TImage;
    VertScrollBox: TVertScrollBox;
    Animation: TFloatAnimation;
    Timer: TTimer;
    ImgDown: TImage;
    ImgUp: TImage;
    ScrollBar1: TScrollBar;
    ScrollRectangle: TRectangle;
    ImgScrollBG: TImage;
    ImgScroll: TImage;
    ImgScrollUp: TImage;
    ImgScrollDown: TImage;
    PageRectangle: TRectangle;
    ImageNext: TImage;
    ImagePrev: TImage;
    procedure UpImageClick(Sender: TObject);
    procedure DownImageClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ImgScrollUpClick(Sender: TObject);
    procedure ImgScrollDownClick(Sender: TObject);
  private
    { Private declarations }
    FActivePage: Integer;
    FMaxPage: Integer;
    FItemList: TList<TMemberSaleProductItemStyle>;

    ShowList: TList<TProductInfo>;


    //FProductSaleType: String; //0:타석, 1:시설, 2:일반
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure TeeboxProductView;

    procedure SelectPage(APage: Integer);
    function ItemListClear: Boolean;

    procedure Display(APage: Integer = 1);
    procedure Animate(ItemStyle: TMemberSaleProductItemStyle);


    property ActivePage: Integer read FActivePage write FActivePage;
    property ItemList: TList<TMemberSaleProductItemStyle> read FItemList write FItemList;
  end;

implementation

uses
  uGlobal, Form.Sale.Product, uConsts, uCommon, uFunction, fx.Logging;

{$R *.fmx}

{ TMemberSaleProductListStyle }

procedure TMemberSaleProductListStyle.Animate(ItemStyle: TMemberSaleProductItemStyle);
var
  Bitmap: TBitmap;
begin
  Bitmap := ItemStyle.MakeScreenshot;
  try
    try
      Image.Bitmap.Assign(Bitmap);
      Image.Visible := True;
      Image.Position.X := ItemStyle.Position.X - VertScrollBox.Position.X;
      Image.Position.Y := VertScrollBox.Margins.Top + ItemStyle.Position.Y - VertScrollBox.Position.Y;
      Image.Width := ItemStyle.Width;
      Image.Height := ItemStyle.Height;
      Image.Scale.X := 1;
      Image.Scale.Y := 1;
      Image.Opacity := 0.8;
    except
//      on E: Exception do
//        Log.E('TOrderItemListStyle.Animate', E.Message);
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

constructor TMemberSaleProductListStyle.Create(AOwner: TComponent);
begin
  inherited;

  begin
    TeeboxProductView;
  end;

end;

destructor TMemberSaleProductListStyle.Destroy;
begin
  PageList.Free;

  if ShowList <> nil then
    ShowList.Free;

  inherited;
end;

procedure TMemberSaleProductListStyle.TeeboxProductView;
var
  Index, nProductIdx, nAdvertIdx: Integer;
  StartTime, EndTime, NowTime, UserSex: string;
  AProduct: TProductInfo;
  ASaleBoxPageItemStyle: TSaleBoxPageItemStyle;
  bProductAdd: Boolean; //추천회원권
begin

  PageList := TList<TSaleBoxPageItemStyle>.Create;
  FMaxPage := 0;
  ShowList := TList<TProductInfo>.Create;
  nAdvertIdx := Global.SaleModule.AdvertListPopupMemberIdx;

  for Index := 0 to Global.SaleModule.SaleList.Count - 1 do
  begin
    AProduct := Global.SaleModule.SaleList[Index];

    if (Global.Config.Store.StoreCode = 'BC001') then //힐스테이트
    begin
      // 0원, 무료상품
    end
    else
    begin
      if AProduct.ProdAmt = 0 then
        Continue;
    end;

    begin
      {
      if (Global.SaleModule.memberItemType in [mitDay, mitAdd]) then
      begin

        if AProduct.Product_Div <> PRODUCT_TYPE_D then
          Continue;

        if (Global.Config.Store.StoreCode = 'C1001') then //코리아하이파이브스포츠클럽
        begin
          if AProduct.Name = '게임비' then
            Continue;
        end;

        //2022-06-21
        //if (AProduct.Sex <> '1') and (AProduct.Sex <> '3') then //여성용 미표시
        if AProduct.Sex = '2' then //여성용 미표시
          Continue;

        if Global.SaleModule.memberItemType = mitAdd then
        begin
          if StrPos(PChar(AProduct.Name), PChar('추가')) = nil then
            Continue;
        end
        else
        begin
          if StrPos(PChar(AProduct.Name), PChar('추가')) <> nil then
            Continue;
        end;

      end
      else    }
      begin
        //2021-06-30 시간제 상품 추가
        if (AProduct.Product_Div <> PRODUCT_TYPE_R) and (AProduct.Product_Div <> PRODUCT_TYPE_C)  then
          Continue;

        UserSex := IfThen(Global.SaleModule.Member.Sex = 'M', '1', '2');


        //2022-06-21 변경
        //if AProduct.Sex <> '3' then
        if AProduct.Sex <> '0' then
        begin
          if AProduct.Product_Div = 'R' then
          begin
            if UserSex <> AProduct.Sex then
              Continue;
          end;
        end;
      end;

      //선택된 타석의 구역구분 포함여부
      //if not (Pos(Global.SaleModule.TeeBoxInfo.ZoneCode, AProduct.AvailableZoneCd) > 0) then
        //Continue;
      {
      if Global.SaleModule.TeeBoxInfo.BtweenTime <> 0 then //타석 전체 잔여시간
      begin
        NowTime := FormatDateTime('yyyymmdd', now) + StringReplace(Global.SaleModule.TeeBoxInfo.End_Time, ':', '', [rfReplaceAll]) + '00';
      end
      else
      begin
        //2021-07-28 상품노출 시간표시시 대기시간 제외. 이종섭 차장
        NowTime := FormatDateTime('yyyymmddhhnn', now);
      end;
      }
      if global.Config.ProductTime = True then //2021-06-01 한강 타석선택시간 기준 타석상품 표출
        NowTime := FormatDateTime('yyyymmddhhnn', now);

      StartTime := StringReplace(AProduct.Start_Time, ':', '', [rfReplaceAll]);
      EndTime := StringReplace(AProduct.End_Time, ':', '', [rfReplaceAll]);

      //chy A4001 유명 체크필요
      if AProduct.Product_Div = PRODUCT_TYPE_D then
      begin
        if StartTime > EndTime then //2021-06-01 유명 익일종료
        begin
          if not ((StartTime <= Copy(NowTime, 9, 4)) or (Copy(NowTime, 9, 4) <= EndTime)) then
            Continue;
        end
        else
        begin
          if not ((StartTime <= Copy(NowTime, 9, 4)) and (Copy(NowTime, 9, 4) <= EndTime)) then
            Continue;
        end;
      end;

      

    end;
    {
    if FormatDateTime('hhnn', now) < '0500' then
    begin
      Log.D('상품시간', '-----------------------------------------------------');
      Log.D('상품시간', AProduct.Code);
      Log.D('상품시간', AProduct.Name);
      Log.D('상품시간', AProduct.Start_Time);
      Log.D('상품시간', AProduct.End_Time);
      Log.D('상품시간', '-----------------------------------------------------');
    end;
    }
    ShowList.Add(AProduct);
  end;

  FMaxPage := ShowList.Count div 4;
  if ShowList.Count mod 4 <> 0 then
    FMaxPage := FMaxPage + 1;

  PageRectangle.Width := PageRectangle.Width * FMaxPage;
  for Index := 0 to FMaxPage - 1 do
  begin
    ASaleBoxPageItemStyle := TSaleBoxPageItemStyle.Create(nil);
    ASaleBoxPageItemStyle.Text.Text := IntToStr(Index + 1);
    ASaleBoxPageItemStyle.Parent := PageRectangle;
    ASaleBoxPageItemStyle.Position := TPosition.Create(TPointF.Create((Index * ASaleBoxPageItemStyle.Width) + (Index * 2), 0));
    ASaleBoxPageItemStyle.IndexPage := Index + 1;

    if Index = 0 then
    begin
      ASaleBoxPageItemStyle.Circle.Fill.Color := TAlphaColorRec.Black;
      ASaleBoxPageItemStyle.Text.TextSettings.FontColor := $FFD9D9D9;
    end
    else
    begin
      ASaleBoxPageItemStyle.Circle.Fill.Color := TAlphaColorRec.White;
      ASaleBoxPageItemStyle.Text.TextSettings.FontColor := $FF37383C;
    end;

    PageList.Add(ASaleBoxPageItemStyle);
  end;
end;



procedure TMemberSaleProductListStyle.Display(APage: Integer);
var
  Index, Loop, AddWidth, ColIndex, RowIndex, ProductCnt: Integer;
  Y, X: Single;
  APosition: TPosition;
  APoint: TPointF;
  //AMemberSaleProductItemStyle: TMemberSaleProductItemStyle;

  StartTime, EndTime, NowTime, AMemberType: string;
begin
  try
    ActivePage := APage;
    X := 0;
    Y := 0;

    RowIndex := 0;
    ColIndex := 0;
    AddWidth := 0;
    Loop := 0;
    ProductCnt := 0;

    APoint := TPointF.Create(Y, X);
    APosition := TPosition.Create(APoint);

    if ActivePage <> 1 then
    begin
      if False then
        Loop := (ActivePage - 1) * 11
      else
        Loop := (ActivePage - 1) * 4;
    end
    else
      Loop := 0;

    if ShowList.Count = 0 then
    begin
      Global.SBMessage.ShowMessageModalForm(MSG_SALE_PRODUCT_NOT_CNT);
      Exit;
    end;

    for Index := VertScrollBox.Content.ChildrenCount - 1 downto 0 do
      VertScrollBox.Content.Children[Index].Free;

    VertScrollBox.Content.DeleteChildren;

    ItemList := TList<TMemberSaleProductItemStyle>.Create;

    ImagePrev.Visible := ShowList.Count > 4;
    ImageNext.Visible := ShowList.Count > 4;
    PageRectangle.Visible := ShowList.Count > 4;
    ImagePrev.Visible := APage <> 1;
    ImageNext.Visible := APage <> FMaxPage;

    for Index := Loop to ShowList.Count - 1 do
    begin

      if ColIndex = 2 then
      begin
        Inc(RowIndex);
        ColIndex := 0;
        AddWidth := 0;
      end;
      {
      if ShowList.Count = 1 then
      begin
        APosition.X := 222;
        APosition.Y := 150;
      end
      else
      begin
        APosition.X := ColIndex * AMemberSaleProductItem420Style.Width + (AddWidth * 20);
        APosition.Y := RowIndex * AMemberSaleProductItem420Style.Height + (RowIndex * 20);
      end;
      AMemberSaleProductItem420Style.Position := APosition;
      AMemberSaleProductItem420Style.Tag := ProductCnt;
      AMemberSaleProductItem420Style.Parent := VertScrollBox;
      AMemberSaleProductItem420Style.Bind(ShowList[Index]);

      Item420List.Add(AMemberSaleProductItem420Style);     }
      Inc(ColIndex);
      Inc(AddWidth);
      Inc(ProductCnt);

      if ProductCnt = 4 then
        Break;
    end;

  finally
    APosition.Free;
    //chy test
    //FreeAndNil(APoint);
  end;
end;

procedure TMemberSaleProductListStyle.DownImageClick(Sender: TObject);
begin
  TouchSound;
  SaleProduct.Cnt := 0;
  if (ActivePage * 4) < ShowList.Count then
  begin
    Inc(FActivePage);
    SelectPage(ActivePage);
  end;
end;

procedure TMemberSaleProductListStyle.ImgScrollDownClick(Sender: TObject);
begin
  ScrollBar1.Value := ScrollBar1.Value + 100;
  ScrollBar1Change(ScrollBar1);
end;

procedure TMemberSaleProductListStyle.ImgScrollUpClick(Sender: TObject);
begin
  ScrollBar1.Value := ScrollBar1.Value - 100;
  ScrollBar1Change(ScrollBar1);
end;

function TMemberSaleProductListStyle.ItemListClear: Boolean;
var
  Index: Integer;
begin
  try
    if ItemList <> nil then
    begin
      for Index := ItemList.Count - 1 downto 0 do
        ItemList.Delete(Index);
    end;
       {
    if Item420List <> nil then
    begin
      for Index := Item420List.Count - 1 downto 0 do
        Item420List.Delete(Index);
    end;
             }
    for Index := ShowList.Count - 1 downto 0 do
      ShowList.Delete(Index);

    for Index := PageList.Count - 1 downto 0 do
      PageList.Delete(Index);
  finally

  end;
end;

procedure TMemberSaleProductListStyle.ScrollBar1Change(Sender: TObject);
begin
  ScrollBar1.Max := VertScrollBox.ContentBounds.Height - VertScrollBox.Content.Height;
  VertScrollBox.ViewportPosition := TPointF.Create(0, ((ScrollBar1.Height / 2) - ScrollBar1.ViewportSize) * (ScrollBar1.Value / ScrollBar1.Max));
  ImgScroll.Position := TPosition.Create(TPointF.Create(0, ((ImgScrollBG.Height - ScrollBar1.ViewportSize) * (ScrollBar1.Value / ScrollBar1.Max))));
end;

procedure TMemberSaleProductListStyle.SelectPage(APage: Integer);
var
  Index: Integer;
begin
  for Index := 0 to PageList.Count - 1 do
  begin
    if Index = (APage - 1) then
    begin
      PageList[Index].Circle.Fill.Color := TAlphaColorRec.Black;
      PageList[Index].Text.TextSettings.FontColor := $FFD9D9D9;
    end
    else
    begin
      PageList[Index].Circle.Fill.Color := TAlphaColorRec.White;
      PageList[Index].Text.TextSettings.FontColor := $FF37383C;
    end;
  end;
  Display(APage);

  ImagePrev.Visible := APage <> 1;
  ImageNext.Visible := APage <> FMaxPage;
end;

procedure TMemberSaleProductListStyle.TimerTimer(Sender: TObject);
begin
  Image.Visible := False;
  Timer.Enabled := False;
end;

procedure TMemberSaleProductListStyle.UpImageClick(Sender: TObject);
begin
  TouchSound;
  SaleProduct.Cnt := 0;
  if not ((ActivePage - 1) < 1) then
  begin
    Dec(FActivePage);
    SelectPage(ActivePage);
  end;
end;

end.
