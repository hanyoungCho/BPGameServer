unit Frame.Select.Box.Lane.Item.Style;

interface

uses
  uStruct,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TSelectBoxLaneItemStyle = class(TFrame)
    Layout: TLayout;
    txtUseTitle: TText;
    txtEnd: TText;
    txtLaneNm: TText;
    txtLineTitle: TText;
    txtGame: TText;
    SelectRectangle: TRectangle;
    recLine1: TRectangle;
    recUse: TRectangle;
    recTimeEnd: TRectangle;
    txtTimeEnd: TText;
    imgNor: TImage;
    imgLock: TImage;
    imgUse: TImage;
    imgUse10: TImage;
    txtEndTime: TText;
    txtGameCnt: TText;
    Text1: TText;
    procedure SelectRectangleClick(Sender: TObject);
  private
    { Private declarations }
    FLaneInfo: TLaneInfo;
    //FError: Boolean;
    //FLaneClean: Boolean;
  public
    { Public declarations }

    procedure DisPlayLaneInfo;

    property LaneInfo: TLaneInfo read FLaneInfo write FLaneInfo;
    //property Error: Boolean read FError write FError;
    //property LaneClean: Boolean read FLaneClean write FLaneClean;
  end;

implementation

uses
  uFunction, uGlobal, uCommon, uConsts, Form.Select.Box, fx.Logging;

{$R *.fmx}

procedure TSelectBoxLaneItemStyle.DisPlayLaneInfo;
var
  LimitTime: Integer;
  //nGameCnt: Integer;
begin
  try
    txtLaneNm.Text := LaneInfo.LaneNm;

    imgLock.Visible := False;
    imgUse.Visible := False;
    imgUse10.Visible := False;
    imgNor.Visible := False;
    //���ӻ���- 0: ����, 1:�����, 2:Ȧ��, 3:����, 4: ����, 5: ����(�̰���), 6: ����, 7: ���, 8: ����
    if LaneInfo.Status = '0' then
    begin
      if LaneInfo.LeagueYn = 'Y' then
      begin
        imgLock.Visible := True;

        txtLaneNm.Color := $FF909092;

        recLine1.Visible := True;
        txtLineTitle.Text := '�̿� ��';
        txtLineTitle.Color := $FF909092;

        recUse.Visible := False;
      end
      else
      begin
        imgNor.Visible := True;

        txtLaneNm.Color := $FF3D55F5;

        recLine1.Visible := True;
        txtLineTitle.Text := '��û��';
        txtLineTitle.Color := $FF3D55F5;

        recUse.Visible := False;
      end;
		end
    else if LaneInfo.Status = '2' then
    begin
      imgLock.Visible := True;

      txtLaneNm.Color := $FF909092;

      recLine1.Visible := True;
      txtLineTitle.Text := '���� ��';
      txtLineTitle.Color := $FF909092;

      recUse.Visible := False;
    end
    else if LaneInfo.Status = '5' then
    begin
      imgLock.Visible := True;

      txtLaneNm.Color := $FF909092;

      recLine1.Visible := True;
      txtLineTitle.Text := '��� ��';
      txtLineTitle.Color := $FF909092;

      recUse.Visible := False;
    end
    else if LaneInfo.Status = '8' then
    begin
      imgLock.Visible := True;

      txtLaneNm.Color := $FF909092;

      recLine1.Visible := True;
      txtLineTitle.Text := '���� ��';
      txtLineTitle.Color := $FF909092;

      recUse.Visible := False;
		end                                 //ksj 230807 ����� ǥ��
    else if (LaneInfo.Status = '3') or (LaneInfo.Status = '1') then
    begin
      recLine1.Visible := False;
      recUse.Visible := True;

      //�̿��� �ܿ��ð� 10������
      if (LaneInfo.RemainMin <> '') and (StrToInt(LaneInfo.RemainMin) < 11) then
      begin
        imgUse.Visible := False;
        imgUse10.Visible := True;

        txtLaneNm.Color := $FFFD3AA0;
				txtUseTitle.Color := $FFFD3AA0;

				recTimeEnd.Fill.Color := $FFFD3AA0;
				txtTimeEnd.Color := $FFFD3AA0;
			end
			else //�̿���
      begin
        imgUse.Visible := True;
        imgUse10.Visible := False;

        txtLaneNm.Color := $FF0F9400;
        txtUseTitle.Color := $FF0F9400;

        recTimeEnd.Fill.Color := $FF0F9400;
        txtTimeEnd.Color := $FF0F9400;
      end;

      if LaneInfo.GameDiv = '2' then //�ð���
      begin
        //recTimeEnd.Visible := False; //�ð���

        txtTimeEnd.Text := LaneInfo.RemainMin + 'min';//'100�� ����';
        txtGame.Visible := False;
        txtGameCnt.Visible := False;
        txtEndTime.Text := copy(LaneInfo.ExpectedEndDatetime, 12, 5); //'15:10';
        txtEnd.position.y := 165;
        txtEndTime.Position.Y := 164;
      end
      else // if LaneInfo.GameDiv = '0' then //������
      begin
        if LaneInfo.GameCnt = 0 then
        begin
          imgLock.Visible := True;

          txtLaneNm.Color := $FF909092;

          recLine1.Visible := True;
          txtLineTitle.Text := '�̿� ��';
          txtLineTitle.Color := $FF909092;

          recUse.Visible := False;
        end
        else
        begin
          txtTimeEnd.Text := LaneInfo.RemainMin + 'min';//'100�� ����';
          txtGameCnt.Text := IntToStr(LaneInfo.GameCnt - LaneInfo.GameFin); //'�ܿ�����100';
          txtEndTime.Text := copy(LaneInfo.ExpectedEndDatetime, 12, 5); //'���� 15:35';
        end;
      end;

    end;

  except
    on E: Exception do
      Log.E('TSelectBoxProductItemStyle.DisPlayTeeBoxInfo', E.Message);
  end;

end;

procedure TSelectBoxLaneItemStyle.SelectRectangleClick(Sender: TObject);
begin                           //ksj 230911 LaneInfo.HoldUser =
  TouchSound(False, True);
  try
    if (LaneInfo.Status = '0') and (LaneInfo.LeagueYn = 'Y')  then
    begin
      Global.SBMessage.ShowMessage('11', '�˸�', '�̿����� �����Դϴ�');
    end
    else if LaneInfo.Status = '5' then
    begin
      Global.SBMessage.ShowMessage('11', '�˸�', '������� �����Դϴ�');
    end
    else if LaneInfo.Status = '8' then
    begin
      Global.SBMessage.ShowMessage('11', '�˸�', '�������� �����Դϴ�');
    end
    else if (LaneInfo.GameDiv = '1') and (LaneInfo.GameCnt = 0) then //������-���Ӽ� ������
    begin
      Global.SBMessage.ShowMessage('12', '�˸�', '���°��� ������ �Դϴ�.'+ #13 + '������ �ϽǼ� �����ϴ�.');
    end
    else
    begin
      Log.D('SelectLane', 'Click');
//      SelectBox.Animate(Self.Tag);
      SelectBox.SelectLane(FLaneInfo);
      Log.D('SelectLane', 'Close');
    end;
  except
    on E: Exception do
      Log.E('SelectRectangleClick', E.Message);
  end;
end;

end.
