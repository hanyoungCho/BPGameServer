unit Frame.Select.Box.Top.Map.List.Style;

interface

uses
  Math,
  System.Generics.Collections, System.DateUtils,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts,
  Frame.Select.Box.Top.Map.List.Item.Style;

type
  TSelectBoxTopMapListStyle = class(TFrame)
    RightRectangle: TRectangle;
    Layout1: TLayout;
  private
    { Private declarations }
    FItemList: TList<TSelectBoxTopMapItemStyle>;
  public
    { Public declarations }
    function DisPlayFloor(AStart, AEnd: Integer; AView: String): Boolean;
    procedure CloseFrame;

    property ItemList: TList<TSelectBoxTopMapItemStyle> read FItemList write FItemList;
  end;

implementation

uses
	uFunction, uGlobal, uConsts, uStruct, fx.Logging;

{$R *.fmx}

{ TSelectBoxTopMapListStyle }

procedure TSelectBoxTopMapListStyle.CloseFrame;
var
  Index: Integer;
begin

  if ItemList = nil then
    Exit;

  for Index := ItemList.Count - 1 to 0 do
    ItemList.Delete(Index);

  ItemList.Free;

end;

function TSelectBoxTopMapListStyle.DisPlayFloor(AStart, AEnd: Integer; AView: String): Boolean;
var
  Index, Loop, MapIndex: Integer;
  ASelectBoxTopMapItemStyle: TSelectBoxTopMapItemStyle;

  rLaneInfo: TLaneInfo;
  slView: TStringList;
  nPostionX: Single;
	nViewCnt, nViewIdx, nViewNum, nViewIdxCnt: integer;
	str: string;
begin
	try
    BeginUpdate;
    Result := True;

    if FItemList = nil then
      FItemList := TList<TSelectBoxTopMapItemStyle>.Create;

    if FItemList.Count <> 0 then
    begin
      for Index := ItemList.Count - 1 to 0 do
      begin
        ASelectBoxTopMapItemStyle := ItemList[Index];
        FreeAndNil(ASelectBoxTopMapItemStyle);
        ItemList.Delete(Index);
      end;
      FItemList.Clear;
    end;

    RightRectangle.Width := 0;

		for Loop := RightRectangle.ChildrenCount - 1 downto 0 do
			RightRectangle.Children[Loop].Free;

		RightRectangle.DeleteChildren;

    if AView = EmptyStr then
      nViewCnt := 0
    else
    begin
      slView := TStringList.Create;
      ExtractStrings([','], [], PChar(AView), slView);
      nViewCnt := slView.Count;

      nViewIdx := 0;
      nViewNum := StrToInt(slView[nViewIdx]);
      nViewIdxCnt := 1;
		end;

    MapIndex := 0;
    nPostionX := 0;
    for Index := 0 to Global.Lane.LaneCnt - 1 do
    begin
      rLaneInfo := Global.Lane.GetLaneInfo(Index);

      if rLaneInfo.LaneNo < AStart then
        Continue;

      if rLaneInfo.LaneNo > AEnd then
        Continue;

      ASelectBoxTopMapItemStyle := TSelectBoxTopMapItemStyle.Create(nil);

      //간격: 4, 26
      if nViewCnt = 0 then
      begin
        if MapIndex = 0 then
        begin
          ASelectBoxTopMapItemStyle.Position.X := nPostionX;
          nPostionX := ASelectBoxTopMapItemStyle.Width;
        end
        else
        begin
          if odd(MapIndex) = False then //짝수
          begin
            ASelectBoxTopMapItemStyle.Position.X := 26 + nPostionX;
            nPostionX := nPostionX + 26 + ASelectBoxTopMapItemStyle.Width;
          end
          else
          begin
            ASelectBoxTopMapItemStyle.Position.X := 4 + nPostionX;
            nPostionX := nPostionX + 4 + ASelectBoxTopMapItemStyle.Width;
          end;
        end;
      end
      else
      begin

        if MapIndex = 0 then
        begin
          ASelectBoxTopMapItemStyle.Position.X := nPostionX;
          nPostionX := ASelectBoxTopMapItemStyle.Width;
        end
        else
        begin
          if nViewNum < nViewIdxCnt then
          begin
            nViewIdx := nViewIdx + 1;
            nViewNum := StrToInt(slView[nViewIdx]);
            nViewIdxCnt := 1;

            ASelectBoxTopMapItemStyle.Position.X := 26 + nPostionX;
            nPostionX := nPostionX + 26 + ASelectBoxTopMapItemStyle.Width;
          end
          else
          begin
            ASelectBoxTopMapItemStyle.Position.X := 4 + nPostionX;
            nPostionX := nPostionX + 4 + ASelectBoxTopMapItemStyle.Width;
          end;
        end;

      end;

      RightRectangle.Width := ASelectBoxTopMapItemStyle.Position.X + ASelectBoxTopMapItemStyle.Width;

      {
      파랑 #FF3D55F5
      녹색 #FF56D167  / 글자 검정 #FF212225
      회색 #FF909092  / 글자 회색 #FFD9D9D9
      핑크 #FFFD3AA0  / 글자 힌색
      }

      if rLaneInfo.Status = '0' then
      begin
        ASelectBoxTopMapItemStyle.recBody.Fill.Color := $FF3D55F5;
        ASelectBoxTopMapItemStyle.SetText(rLaneInfo.LaneNm);
        ASelectBoxTopMapItemStyle.Text.TextSettings.FontColor := TAlphaColorRec.white;
      end
      else if rLaneInfo.Status = '2' then
      begin
        ASelectBoxTopMapItemStyle.recBody.Fill.Color := $FFA6A7A8;
        ASelectBoxTopMapItemStyle.SetText(rLaneInfo.LaneNm);
        ASelectBoxTopMapItemStyle.Text.TextSettings.FontColor := $FF212225;
      end
      else if rLaneInfo.Status = '8' then
      begin
        ASelectBoxTopMapItemStyle.recBody.Fill.Color := $FF909092;
        ASelectBoxTopMapItemStyle.SetText(rLaneInfo.LaneNm);
        ASelectBoxTopMapItemStyle.Text.TextSettings.FontColor := $FFD9D9D9;
			end
			else if (rLaneInfo.Status = '3') or (rLaneInfo.Status = '1') then
			begin //ksj 230807 미니맵 10분 미만 표시
				if (rLaneInfo.RemainMin <> '') and (StrToInt(rLaneInfo.RemainMin) < 11) then
				begin
					ASelectBoxTopMapItemStyle.recBody.Fill.Color := $FFFD3AA0;
					ASelectBoxTopMapItemStyle.SetText(rLaneInfo.LaneNm);
					ASelectBoxTopMapItemStyle.Text.TextSettings.FontColor := TAlphaColorRec.white;
				end
				else
				begin
					ASelectBoxTopMapItemStyle.recBody.Fill.Color := $FF56D167;
					ASelectBoxTopMapItemStyle.SetText(rLaneInfo.LaneNm);
					ASelectBoxTopMapItemStyle.Text.TextSettings.FontColor := $FF212225;
        end;
      end;

      ASelectBoxTopMapItemStyle.Parent := RightRectangle;
      //ASelectBoxTopMapItemStyle.Align := TAlignLayout.Left;

      ItemList.Add(ASelectBoxTopMapItemStyle);
      Inc(MapIndex);
      Inc(nViewIdxCnt);
    end;
    EndUpdate;

  finally

  end;
end;

end.

