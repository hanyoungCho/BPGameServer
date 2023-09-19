unit Frame.Select.Box.Product.Item.Style;

interface

uses
  uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TSelectBoxProductItemStyle = class(TFrame)
    Layout: TLayout;
    txtGame: TText;
    txtEnd: TText;
    recBody: TRectangle;
    txtLaneNm: TText;
    txtUse: TText;
    recTop: TRectangle;
    imgDottedLine: TImage;
    txtTime: TText;
    SelectRectangle: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    recTimeEnd: TRectangle;
    Image1: TImage;
    txtTimeEnd: TText;
    procedure SelectRectangleClick(Sender: TObject);
  private
    { Private declarations }
    FLaneInfo: TLaneInfo;
    FError: Boolean;
    //FLaneClean: Boolean;
  public
    { Public declarations }

    procedure DisPlayLaneInfo;

    property LaneInfo: TLaneInfo read FLaneInfo write FLaneInfo;
    property Error: Boolean read FError write FError;
    //property LaneClean: Boolean read FLaneClean write FLaneClean;
  end;

implementation

uses
  uFunction, uGlobal, uCommon, uConsts, Form.Select.Box, fx.Logging;

{$R *.fmx}

procedure TSelectBoxProductItemStyle.DisPlayLaneInfo;
var
  LimitTime: Integer;
  nGameCnt: Integer;
begin
  try
    Error := False;

    recTimeEnd.Visible := False; //시간제

    //LaneClean := False;
    txtLaneNm.Text := LaneInfo.LaneNm;

    if odd(LaneInfo.LaneNo) = False then //짝수
      imgDottedLine.Visible := False;

    if LaneInfo.Status = '0' then
    begin
      Rectangle1.Visible := True;
      txtUse.Text := '즉시 사용';

      Rectangle2.Visible := False;
      txtGame.Text := '';
      txtEnd.Text := '';
      txtTime.Text := '';

      recBody.Fill.Color := TAlphaColorRec.white;
      recBody.Stroke.Color := $FF3D55F5;
      recTop.Fill.Color := $FF3D55F5;
    end
    else if LaneInfo.Status = '3' then
    begin
      Rectangle1.Visible := True;
      txtUse.Text := '예약 중';

      Rectangle2.Visible := False;
      txtGame.Text := '';
      txtEnd.Text := '';
      txtTime.Text := '';

      recBody.Fill.Color := TAlphaColorRec.white;
      recBody.Stroke.Color := $FFFD3AA0;
      recTop.Fill.Color := $FFFD3AA0;

      txtUse.Color := $FFFD3AA0;
    end
    else if LaneInfo.Status = '8' then
    begin
      Rectangle1.Visible := True;
      txtUse.Text := '점검 중';

      Rectangle2.Visible := False;
      txtGame.Text := '';
      txtEnd.Text := '';
      txtTime.Text := '';

      recBody.Fill.Color := $FFD9D9D9;
      recBody.Stroke.Color := $FFD9D9D9;
      recTop.Fill.Color := $FFD9D9D9;

      txtUse.Color := $FF909092;
      txtLaneNm.Color := $FF909092;
    end
    else
    begin
      Rectangle1.Visible := False;
      txtUse.Text := '';

      if LaneInfo.ToCnt > 0 then
        nGameCnt := LaneInfo.GameCnt - LaneInfo.GameFin - 1
      else
        nGameCnt := LaneInfo.GameCnt - LaneInfo.GameFin;


      Rectangle2.Visible := True;
      txtGame.Text := '잔여게임';
      txtEnd.Text := '종료';
      txtTime.Text := '분 남음';

      recBody.Fill.Color := TAlphaColorRec.white;
      recBody.Stroke.Color := $FF56D167;
      recTop.Fill.Color := $FF56D167;
    end;

  except
    on E: Exception do
      Log.E('TSelectBoxProductItemStyle.DisPlayTeeBoxInfo', E.Message);
  end;

end;

procedure TSelectBoxProductItemStyle.SelectRectangleClick(Sender: TObject);
begin
  TouchSound(False, True);
  try
    if Error then
    begin
      Global.SBMessage.ShowMessage('11', '알림', MSG_ERROR_TEEBOX);
    end
    else
    begin
      Log.D('SelectTeeBox', 'Click');
//      SelectBox.Animate(Self.Tag);

      SelectBox.SelectLane(FLaneInfo);

      //Log.D('SelectTeeBox', 'Close');

    end;
  except
    on E: Exception do
      Log.E('SelectRectangleClick', E.Message);
  end;
end;

end.
