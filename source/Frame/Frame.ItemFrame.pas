unit Frame.ItemFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uStruct;

type
  TFrame3 = class(TFrame)
    Label1: TLabel;
    laName: TLabel;
    laFrame: TLabel;
    laScore: TLabel;
  private
    { Private declarations }
    FBowlerNm: String;
    FGameCnt: Integer;
    FGameDiv: Integer;
    FBowlerStatus: TBowlerStatus;
  public
    { Public declarations }
    procedure DisPlayInfo;

    property BowlerNm: String read FBowlerNm write FBowlerNm;
    property GameDiv: Integer read FGameDiv write FGameDiv;
    property GameCnt: Integer read FGameCnt write FGameCnt;
    property BowlerStatus: TBowlerStatus read FBowlerStatus write FBowlerStatus;
  end;

implementation

{$R *.dfm}

procedure TFrame3.DisPlayInfo;
var
  sStr: String;
  I: Integer;
begin
  laName.Caption := FBowlerNm;

  if FBowlerNm = '' then
  begin
    laName.Color := clBtnFace;
    laFrame.Caption := '';
    Label1.Caption := '0-0/0';
    laScore.Caption := '';
  end
  else
  begin
    if (FBowlerStatus.Status1 = 'C0') or (FBowlerStatus.Status1 = 'E0') then
      laName.Color := clTeal
    else if FBowlerStatus.Status1 = '3' then
      laName.Color := clRed
    else
      laName.Color := clBtnFace;

    sStr := '';
    for I := 1 to 21 do
    begin
      sStr := sStr + FBowlerStatus.FramePin[I];
    end;

    laFrame.Caption := sStr;

    if GameDiv = 1 then
      Label1.Caption := IntToStr(GameCnt) + '-' + IntToStr(FBowlerStatus.EndGameCnt) + '/' + IntToStr(FBowlerStatus.ResidualGameCnt)
    else
      Label1.Caption := IntToStr(GameCnt) + '-' + IntToStr(FBowlerStatus.EndGameCnt) + '/' + IntToStr(FBowlerStatus.ResidualGameTime);

    laScore.Caption := IntToStr(FBowlerStatus.TotalScore);
  end;
end;

end.
