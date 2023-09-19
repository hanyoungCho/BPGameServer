unit Form.Config;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, Frame.Config.Item.Style, Generics.Collections, JSON,
  InIFiles;

type
  TConfig = class(TForm)
    Layout: TLayout;
    BGImage: TImage;
    BottomLayout: TLayout;
    BottomRectangle: TRectangle;
    BackRectangle: TRectangle;
    BackImage: TImage;
    Text1: TText;
    WhiteImage: TImage;
    VertScrollBox: TVertScrollBox;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Line: TLine;
    procedure BackImageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
//    FItemList: TList<TConfigItemStyle>;
  public
    { Public declarations }
    procedure Display;
//    property ItemList: TList<TConfigItemStyle> read FItemList write FItemList;
  end;

var
  Config: TConfig;

implementation

uses
  uGlobal, uFunction;

{$R *.fmx}

procedure TConfig.BackImageClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;
{
procedure TConfig.Display;
var
  Index: Integer;
  AConfigItemStyle: TConfigItemStyle;
  Y, X: Single;
  APosition: TPosition;
  APoint: TPointF;
  MainJson: TJSONObject;
  JsonValue, ItemValue: TJSONValue;
begin
  try
    X := 0;
    Y := 0;

    APoint := TPointF.Create(Y, X);
    APosition := TPosition.Create(APoint);

    MainJson := TJSONObject.Create;
    JsonValue := TJSONValue.Create;
    ItemValue := TJSONValue.Create;

    JsonValue := MainJson.ParseJSONValue(Global.SaleModule.ConfigJsonText);

    if (JsonValue as TJSONObject).Get('result_cd').JsonValue.Value <> '0000' then
      Exit;

    JsonValue := (JsonValue as TJSONObject).Get('result_data').JsonValue;

    for Index := 0 to (JsonValue as TJSONArray).Count - 1 do
    begin
      ItemValue := (JsonValue as TJSONArray).Items[Index];
      AConfigItemStyle := TConfigItemStyle.Create(nil);

      APosition.X := 0;
      APosition.Y := 2 + Index * AConfigItemStyle.Height;

      AConfigItemStyle.Display((ItemValue as TJSONObject).Get('section_cd').JsonValue.Value,
                               (ItemValue as TJSONObject).Get('item_cd').JsonValue.Value,
                               (ItemValue as TJSONObject).Get('item_value').JsonValue.Value);
      AConfigItemStyle.Position := APosition;
      AConfigItemStyle.Parent := VertScrollBox;

//      ItemList.Add(AConfigItemStyle);
    end;

  finally
    MainJson.Free;
    JsonValue.Free;
    APosition.Free;
    FreeAndNil(AConfigItemStyle);
//    ItemValue.Free;
  end;
end;
}

procedure TConfig.Display;
var
  Index: Integer;
  AConfigItemStyle: TConfigItemStyle;
  Y, X: Single;
  APosition: TPosition;
  APoint: TPointF;
  MainJson: TJSONObject;

  MI: TMemIniFile;
  SL, IL: TStringList;
  SS: TStringStream;
  I, J: Integer;
begin
  try
    X := 0;
    Y := 0;
    Index := 0;

    APoint := TPointF.Create(Y, X);
    APosition := TPosition.Create(APoint);

    //MainJson := TJSONObject.ParseJSONValue(Global.SaleModule.ConfigJsonText) as TJSONObject;

    if MainJson.GetValue('result_cd').Value <> '0000' then
      Exit;

    if MainJson.FindValue('settings') is TJSONNull then
      Exit;

    SS := TStringStream.Create;
    SS.Clear;
    SS.WriteString(MainJson.GetValue('settings').Value);
    MI := TMemIniFile.Create(SS, TEncoding.UTF8);
    SL := TStringList.Create;
    IL := TStringList.Create;

    MI.ReadSections(SL);

    for I := 0 to Pred(SL.Count) do
    begin
      IL.Clear;
      //MI.ReadSectionValues(SL[I], IL);
      MI.ReadSection(SL[I], IL);
      for J := 0 to Pred(IL.Count) do
      begin
        AConfigItemStyle := TConfigItemStyle.Create(nil);

        APosition.X := 0;
        APosition.Y := 2 + Index * AConfigItemStyle.Height;

        AConfigItemStyle.Display( SL[I], IL[J], MI.ReadString(SL[I], IL[J], '') );
        AConfigItemStyle.Position := APosition;
        AConfigItemStyle.Parent := VertScrollBox;

        inc(Index);
      end;
    end;

  finally
    APosition.Free;
    FreeAndNil(AConfigItemStyle);

    FreeAndNil(MainJson);
    FreeAndNil(IL);
    FreeAndNil(SL);
    FreeAndNil(MI);
    SS.Free;
  end;
end;

procedure TConfig.FormCreate(Sender: TObject);
begin
//  ItemList := TList<TConfigItemStyle>.Create;
end;

procedure TConfig.FormDestroy(Sender: TObject);
//var
//  Index: Integer;
begin
//  for Index := ItemList.Count - 1 downto 0 do
//    ItemList.Delete(Index);
//
//  ItemList.Free;
end;

procedure TConfig.FormShow(Sender: TObject);
begin
  Display;
end;

end.
