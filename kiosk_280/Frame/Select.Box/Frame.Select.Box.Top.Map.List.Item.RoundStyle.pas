unit Frame.Select.Box.Top.Map.List.Item.RoundStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, uStruct;

type
  TSelectBoxTopMapItemRoundStyle = class(TFrame)
    ImgLayout: TLayout;
    Layout: TLayout;
    Text: TText;
    RoundRect: TRoundRect;
    Timer: TTimer;
    VipImage: TImage;
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FTeeBoxInfo: TTeeBoxInfo;
    FColor: TAlphaColor;
    procedure SetText(AText: string);
  end;

implementation

uses
  Form.Select.Box, uCommon, uGlobal, uConsts;

{$R *.fmx}

procedure TSelectBoxTopMapItemRoundStyle.TimerTimer(Sender: TObject);
begin
  if RoundRect.Fill.Color <> TAlphaColorRec.Null then
  begin
    if Global.SaleModule.MiniMapCursor then
    begin
      {
      if Global.SaleModule.TeeBoxInfo.TasukNo = FTeeBoxInfo.TasukNo then
      begin
        if Text.TextSettings.FontColor = TAlphaColorRec.Black then
        begin
          RoundRect.Fill.Color := FColor;
          Text.TextSettings.FontColor := TAlphaColorRec.White;
        end
        else
        begin
          RoundRect.Fill.Color := TAlphaColorRec.White;
          Text.TextSettings.FontColor := TAlphaColorRec.Black;
        end;
  //        Circle.Stroke.Thickness := 5;
      end;
      }
    end
    else
    begin
      RoundRect.Fill.Color := FColor;
      Text.TextSettings.FontColor := TAlphaColorRec.White;
    end;
  end;
end;

procedure TSelectBoxTopMapItemRoundStyle.SetText(AText: string);
begin

  if AText <> 'X' then
    Text.TextSettings.Font.Family := 'Roboto';

  if Strpos(PChar(AText), PChar('ROOM')) <> nil then
    AText := Copy(AText, 1, 1);

  Text.Text := AText;

  if (global.Config.Store.StoreCode = 'AD001') then //ÇÑ°­
  begin
    if Length(AText) >= 3 then //20font
      Text.TextSettings.Font.Size := 12
    else
      Text.TextSettings.Font.Size := 14;
  end
 { else if (global.Config.Store.StoreCode = 'A8004') then
  begin
    if Length(AText) >= 3 then //20font
      Text.TextSettings.Font.Size := 15;
  end   }
  else
  begin
    if Length(AText) >= 3 then //20font
      Text.TextSettings.Font.Size := 6
    else
      Text.TextSettings.Font.Size := 8;
  end;

end;

end.
