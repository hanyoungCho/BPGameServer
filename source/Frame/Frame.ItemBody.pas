unit Frame.ItemBody;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Generics.Collections,
  uStruct, Vcl.StdCtrls;

type
  TFrame4 = class(TFrame)
    GroupBox1: TGroupBox;
    laAssignNo: TLabel;
    etCnt: TEdit;
    laNm1: TLabel;
    laScore1: TLabel;
    laNm2: TLabel;
    laScore2: TLabel;
    laNm3: TLabel;
    laScore3: TLabel;
    laNm4: TLabel;
    laScore4: TLabel;
    laNm5: TLabel;
    laScore5: TLabel;
    laNm6: TLabel;
    laScore6: TLabel;
  private
    { Private declarations }
    FLaneInfo: TLaneInfo;
    FReserveCnt: String;
  public
    { Public declarations }
    procedure DisPlayInfo;

    property LaneInfo: TLaneInfo read FLaneInfo write FLaneInfo;
    property ReserveCnt: String read FReserveCnt write FReserveCnt;
  end;

implementation

{$R *.dfm}

procedure TFrame4.DisPlayInfo;
var
  I: Integer;
begin
  etCnt.Text := FReserveCnt;

  if LaneInfo.HoldUse = 'Y' then
    etCnt.Color := clTeal
  else
    etCnt.Color := clWindow;

  GroupBox1.Caption := IntToStr(LaneInfo.LaneNo);
  laAssignNo.Caption := LaneInfo.Assign.AssignNo;

  if LaneInfo.Assign.AssignNo = '' then
  begin
    Self.Color := clBtnFace;
    for I := 1 to 6 do
    begin
      Tlabel(FindComponent('laNm'+inttostr(I))).Caption := '';
      Tlabel(FindComponent('laScore'+inttostr(I))).Caption := '';
    end;
  end
  else
  begin
    Self.Color := clWindow;
    for I := 1 to 6 do
    begin
      Tlabel(FindComponent('laNm'+inttostr(I))).Caption := LaneInfo.Assign.BowlerList[I].BowlerId;
      if (LaneInfo.Game.BowlerList[I].Status1 = 'C0') or (LaneInfo.Game.BowlerList[I].Status1 = 'E0') then
        Tlabel(FindComponent('laNm'+inttostr(I))).Font.Color := clTeal
      else
        Tlabel(FindComponent('laNm'+inttostr(I))).Font.Color := clWindowText;

      if LaneInfo.Assign.BowlerList[I].BowlerId <> '' then
        Tlabel(FindComponent('laScore'+inttostr(I))).Caption := IntToStr(LaneInfo.Game.BowlerList[I].TotalScore)
      else
        Tlabel(FindComponent('laScore'+inttostr(I))).Caption := '';
    end;
  end;

  if LaneInfo.UseStatus = '9' then
    Self.Color := clRed;
end;

end.
