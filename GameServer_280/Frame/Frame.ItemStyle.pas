unit Frame.ItemStyle;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  { common }
  uStruct;

type
  TFrame1 = class(TFrame)
    Label1: TLabel;
    edBowler1: TEdit;
    Label2: TLabel;
    edBowler2: TEdit;
    edBowler3: TEdit;
    edBowler4: TEdit;
    edBowler5: TEdit;
    edBowler6: TEdit;
    edGameCnt: TEdit;
    etCnt: TEdit;
  private
    { Private declarations }
    FLaneInfo: TLaneInfo;
    FAssignInfo: TAssignInfo;
    FReserveCnt: String;
  public
    { Public declarations }
    procedure DisPlayInfo;

    property AssignInfo: TAssignInfo read FAssignInfo write FAssignInfo;
    property LaneInfo: TLaneInfo read FLaneInfo write FLaneInfo;
    property ReserveCnt: String read FReserveCnt write FReserveCnt;
  end;

implementation

{$R *.dfm}

uses
  uGlobal;

{ TFrame1 }

procedure TFrame1.DisPlayInfo;
begin
  Label1.Caption := LaneInfo.LaneNm;
  Label2.Caption := '[' + IntToStr(LaneInfo.LaneNo) + ']';
  {
  edBowler1.Text := IntToStr(AssignInfo.BowlerList[1].TotalScore);
  edBowler2.Text := IntToStr(AssignInfo.BowlerList[2].TotalScore);
  edBowler3.Text := IntToStr(AssignInfo.BowlerList[3].TotalScore);
  edBowler4.Text := IntToStr(AssignInfo.BowlerList[4].TotalScore);
  edBowler5.Text := IntToStr(AssignInfo.BowlerList[5].TotalScore);
  edBowler6.Text := IntToStr(AssignInfo.BowlerList[6].TotalScore);
  }
  etCnt.Text := FReserveCnt;

  if LaneInfo.HoldUse = 'Y' then
    Self.Color := clGray
  else
    Self.Color := clWhite;
end;

end.
