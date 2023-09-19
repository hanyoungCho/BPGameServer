unit Frame.Select.Box.Top.Map;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
	FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects,
  Frame.Select.Box.Top.Map.List.Style;

type
  TSelectBoxTopMap = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    SelectBoxTopMapListStyle1: TSelectBoxTopMapListStyle;
    SelectBoxTopMapListStyle2: TSelectBoxTopMapListStyle;
    Layout3: TLayout;
    SelectBoxTopMapListStyle3: TSelectBoxTopMapListStyle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Text1: TText;
    Rectangle3: TRectangle;
    Text2: TText;
    Rectangle4: TRectangle;
    Text3: TText;
    Rectangle5: TRectangle;
    Text4: TText;
    Rectangle6: TRectangle;
    Text5: TText;
    Text6: TText;
    Text7: TText;
    Text8: TText;
    Text9: TText;
    Text10: TText;
  private
    { Private declarations }
  public
    { Public declarations }
    function DisplayFloor: Boolean;
    procedure CloseFrame;
  end;

implementation

uses
	uGlobal, fx.Logging;

{$R *.fmx}

{ TSelectBoxTopMap }

procedure TSelectBoxTopMap.CloseFrame;
begin
  SelectBoxTopMapListStyle1.CloseFrame;
	SelectBoxTopMapListStyle2.CloseFrame;
	SelectBoxTopMapListStyle3.CloseFrame; //ksj 230816
	FreeAndNil(SelectBoxTopMapListStyle1);
	FreeAndNil(SelectBoxTopMapListStyle2);
	FreeAndNil(SelectBoxTopMapListStyle3);
end;

function TSelectBoxTopMap.DisplayFloor: Boolean;
var
	I: Integer; //ksj 230807
	nStatusUseY, nStatusUseN, nStatusTenMin, nStatusReserv, nStatusCheck: Integer;
begin
	try
		Result := True;

		if Global.Config.MiniMap.MiniViewCnt = 1 then
		begin
			SelectBoxTopMapListStyle2.DisPlayFloor(Global.Config.MiniMap.Mini_1_Start, Global.Config.MiniMap.Mini_1_End, Global.Config.MiniMap.Mini_1_View);
		end
		else if Global.Config.MiniMap.MiniViewCnt = 2 then
		begin
			SelectBoxTopMapListStyle1.DisPlayFloor(Global.Config.MiniMap.Mini_1_Start, Global.Config.MiniMap.Mini_1_End, Global.Config.MiniMap.Mini_1_View);
			Layout1.Position.Y := 67;
			SelectBoxTopMapListStyle2.DisPlayFloor(Global.Config.MiniMap.Mini_2_Start, Global.Config.MiniMap.Mini_2_End, Global.Config.MiniMap.Mini_2_View);
			Layout2.Position.Y := 141;
		end
		else
		begin
			SelectBoxTopMapListStyle1.DisPlayFloor(Global.Config.MiniMap.Mini_1_Start, Global.Config.MiniMap.Mini_1_End, Global.Config.MiniMap.Mini_1_View);
			SelectBoxTopMapListStyle2.DisPlayFloor(Global.Config.MiniMap.Mini_2_Start, Global.Config.MiniMap.Mini_2_End, Global.Config.MiniMap.Mini_2_View);
			SelectBoxTopMapListStyle3.DisPlayFloor(Global.Config.MiniMap.Mini_3_Start, Global.Config.MiniMap.Mini_3_End, Global.Config.MiniMap.Mini_3_View);
		end;

		//ksj 230807 ���º� ���ΰ��� ǥ��
		nStatusUseY := 0;
		nStatusUseN := 0;
		nStatusTenMin := 0;
		nStatusReserv := 0;
		nStatusCheck := 0;

		for I := 0 to Global.Lane.LaneCnt - 1 do
		begin
			if Global.Lane.GetLaneInfo(I).Status = '0' then    //���⿡ �Լ����� �ٵ� �Լ��־ ����������
			begin
				if Global.Lane.GetLaneInfo(I).LeagueYn = 'Y' then
					nStatusUseN := nStatusUseN + 1 //�����
				else
					nStatusUseY := nStatusUseY + 1; //��û��
			end
			else if (Global.Lane.GetLaneInfo(I).Status = '3') or (Global.Lane.GetLaneInfo(I).Status = '1') then
			begin  //����� 10�й̸�
				if (Global.Lane.GetLaneInfo(I).RemainMin <> '') and (StrToInt(Global.Lane.GetLaneInfo(I).RemainMin) < 11) then
					nStatusTenMin := nStatusTenMin + 1
				else
					nStatusUseN := nStatusUseN + 1; //�����
			end
			else if Global.Lane.GetLaneInfo(I).Status = '5' then
				nStatusUseN := nStatusUseN + 1 //������� ������ �������� �̰������� �ϴ� ����߿� ����
			else if Global.Lane.GetLaneInfo(I).Status = '2' then
				nStatusReserv := nStatusReserv + 1 //������
			else if Global.Lane.GetLaneInfo(I).Status = '8' then
				nStatusCheck := nStatusCheck + 1; //������
		end;
		//���ӻ���- 0: ��Ÿ��, 1:�����, 2:Ȧ��, 3:����, 4: ����, 5: ����(�̰���), 6: ����, 7: ���, 8: ����
		Text6.Text := IntToStr(nStatusUseY);   //��û��
		Text7.Text := IntToStr(nStatusUseN);   //�����
		Text8.Text := IntToStr(nStatusTenMin);   //10�й̸�
		Text9.Text := IntToStr(nStatusReserv);   //������
		Text10.Text := IntToStr(nStatusCheck);  //������
	except
		on E: Exception do
		begin
			Log.E('TSelectBoxTopMap.DisplayFloor', E.Message);
		end;
	end;
end;

end.
