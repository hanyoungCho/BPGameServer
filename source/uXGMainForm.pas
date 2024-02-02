unit uXGMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Types,
  System.Classes, Vcl.Graphics, SvcMgr,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdContext, Vcl.StdCtrls,
  Generics.Collections,
  Vcl.ExtCtrls,
  IdAntiFreezeBase, IdAntiFreeze,
  Frame.ItemBody, uStruct, Vcl.AppEvnts;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    IdAntiFreeze1: TIdAntiFreeze;
    ApplicationEvents1: TApplicationEvents;
    Panel2: TPanel;
    edApiResult: TEdit;
    pnlSeat: TPanel;
    pnlCom: TPanel;
    pnlEmergency: TPanel;
    btnDebug: TButton;
    pnlSingle: TPanel;
    Panel1: TPanel;
    Label3: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    edLaneNo: TEdit;
    btnHoldCancel: TButton;
    Panel3: TPanel;
    laCnt1: TLabel;
    laFrame1: TLabel;
    laName1: TLabel;
    laScore1: TLabel;
    laCnt2: TLabel;
    laFrame2: TLabel;
    laName2: TLabel;
    laScore2: TLabel;
    laCnt3: TLabel;
    laFrame3: TLabel;
    laName3: TLabel;
    laScore3: TLabel;
    laCnt4: TLabel;
    laFrame4: TLabel;
    laName4: TLabel;
    laScore4: TLabel;
    laCnt5: TLabel;
    laFrame5: TLabel;
    laName5: TLabel;
    laScore5: TLabel;
    laCnt6: TLabel;
    laFrame6: TLabel;
    laName6: TLabel;
    laScore6: TLabel;
    Label23: TLabel;
    edlaneMon: TEdit;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button3: TButton;
    Edit1: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnHoldCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    { Private declarations }
    FItemList: TList<TFrame4>;

    FSeatChk: TDateTime;
    FComChk: String;

    procedure StartUp;
    procedure Display;
    procedure DisplayStatus;
  public
    { Public declarations }
    procedure LogView(ALog: string);

    property ItemList: TList<TFrame4> read FItemList write FItemList;
  end;

var
  MainForm: TMainForm;

implementation

uses
  uGlobal, uFunction, uConsts;

{$R *.dfm}

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Global.Log.LogWrite('사용자 종료!!');
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('종료시 레인배정 및 제어를 할수 없습니다.'+#13+'종료하시겠습니까?', mtConfirmation, [mbOK, mbCancel], 0) = mrCancel then
  begin
    CanClose := False;
    Exit;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  StartUp;
  Display;

  Timer1.Enabled := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  Timer1.Enabled := False;
  Global.Free;

  FreeAndNil(FItemList);
end;

procedure TMainForm.StartUp;
begin
  Global := TGlobal.Create;
  Global.StartUp;

  Caption := Global.Store.StoreNm + '[' + Global.Config.StoreCd + '] ' + Global.Config.ApiUrl;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  DisplayStatus;
end;

procedure TMainForm.LogView(ALog: string);
begin

  if FComChk <> ALog then
  begin
    if pnlCom.Color = clBtnFace then
      pnlCom.Color := clGreen
    else
      pnlCom.Color := clBtnFace;

    FComChk := ALog;
  end;
  {
  if FSeatChk <> Global.TeeboxThreadTime then
  begin
    if pnlSeat.Color = clBtnFace then
      pnlSeat.Color := clBlue
    else
      pnlSeat.Color := clBtnFace;

    FSeatChk := Global.TeeboxThreadTime;
  end;
   }
end;

procedure TMainForm.Display;
var
  i, ColIndex, RowIndex: Integer;
  ItemStyle: TFrame4;
  rLaneInfo: TLaneInfo;
  rAssignInfo: TAssignInfo;
  nColIndex: Integer;
begin

  try
    if FItemList = nil then
      FItemList := TList<TFrame4>.Create;

    if FItemList.Count <> 0 then
      FItemList.Clear;

    RowIndex := 0;
    ColIndex := 0;
    nColIndex := 6;

    for i := 0 to Global.Lane.LaneCnt - 1 do
    begin
      rLaneInfo := Global.Lane.GetLaneInfoToIndex(i);

      if ColIndex = nColIndex then
      begin
        Inc(RowIndex);
        ColIndex := 0;
      end;

      ItemStyle := TFrame4.Create(nil);
      ItemStyle.Left := ColIndex * ItemStyle.Width;
      ItemStyle.Top := RowIndex * ItemStyle.Height;
      ItemStyle.Parent := pnlSingle;
      ItemStyle.LaneInfo := rLaneInfo;

      ItemList.Add(ItemStyle);
      Inc(ColIndex);
    end;

  finally

  end;
end;

procedure TMainForm.DisplayStatus;
var
  i, nLaneNo: Integer;
  rLaneInfo: TLaneInfo;
  sStr: String;
  j, k: Integer;
begin
  try
    if FItemList.Count = 0 then
      Exit;

    for i := 0 to FItemList.Count - 1 do
    begin

      nLaneNo := FItemList[i].LaneInfo.LaneNo;
      rLaneInfo := Global.Lane.GetLaneInfo(nLaneNo);

      FItemList[i].LaneInfo := rLaneInfo;
      FItemList[i].ReserveCnt := IntToStr(Global.ReserveList.GetReserveListCnt(rLaneInfo.LaneNo));
      FItemList[i].DisPlayInfo;

      if (trim(edlaneMon.Text) <> '') and (StrToInt(edlaneMon.Text) = nLaneNo) then
      begin
        for j := 1 to 6 do
        begin
          Tlabel(FindComponent('laName' + inttostr(j))).Caption := rLaneInfo.Assign.BowlerList[j].BowlerId;

          sStr := '';
          for k := 1 to 21 do
          begin
            sStr := sStr + rLaneInfo.Game.BowlerList[j].FramePin[k];
          end;
          Tlabel(FindComponent('laFrame' + inttostr(j))).Caption := sStr;

          Tlabel(FindComponent('laScore' + inttostr(j))).Caption := IntToStr(rLaneInfo.Game.BowlerList[j].TotalScore);

          if rLaneInfo.Assign.GameDiv = 1 then
            sStr := IntToStr(rLaneInfo.Assign.BowlerList[j].GameCnt) + '-' + IntToStr(rLaneInfo.Game.BowlerList[j].EndGameCnt) + '/' + IntToStr(rLaneInfo.Game.BowlerList[j].ResidualGameCnt)
          else
            sStr := IntToStr(rLaneInfo.Assign.BowlerList[j].GameCnt) + '-' + IntToStr(rLaneInfo.Game.BowlerList[j].EndGameCnt) + '/' + IntToStr(rLaneInfo.Game.BowlerList[j].ResidualGameTime);

          Tlabel(FindComponent('laCnt' + inttostr(j))).Caption := sStr;
        end;
      end;

    end;
  finally

  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  nLaneNo: Integer;
  I: Integer;
  sStr: String;
  rLaneInfo: TLaneInfo;
begin

  if Trim(edLaneNo.text) = EmptyStr then
    Exit;

  nLaneNo := StrToInt(edLaneNo.text);
  rLaneInfo := Global.Lane.GetLaneInfo(nLaneNo);

  Memo1.Lines.Clear;
  Memo1.Lines.Add('LaneNo : ' + IntToStr(rLaneInfo.LaneNo));
  Memo1.Lines.Add('ReserveNo : ' + rLaneInfo.Assign.AssignNo);
  Memo1.Lines.Add('GameSeq : ' + IntToStr(rLaneInfo.Assign.GameSeq));
  Memo1.Lines.Add('CompetitionSeq : ' + IntToStr(rLaneInfo.Assign.CompetitionSeq));
  Memo1.Lines.Add('LeagueYn : ' + rLaneInfo.Assign.LeagueYn);

  Memo1.Lines.Add('Bowler 1 : ' + rLaneInfo.Assign.BowlerList[1].BowlerNm + '(' + rLaneInfo.Assign.BowlerList[1].BowlerId + ')' + InttoStr(rLaneInfo.Assign.BowlerList[1].GameCnt));
  Memo1.Lines.Add('Bowler 2 : ' + rLaneInfo.Assign.BowlerList[2].BowlerNm + '(' + rLaneInfo.Assign.BowlerList[2].BowlerId + ')');
  Memo1.Lines.Add('Bowler 3 : ' + rLaneInfo.Assign.BowlerList[3].BowlerNm + '(' + rLaneInfo.Assign.BowlerList[3].BowlerId + ')');
  Memo1.Lines.Add('Bowler 4 : ' + rLaneInfo.Assign.BowlerList[4].BowlerNm + '(' + rLaneInfo.Assign.BowlerList[4].BowlerId + ')');
  Memo1.Lines.Add('Bowler 5 : ' + rLaneInfo.Assign.BowlerList[5].BowlerNm + '(' + rLaneInfo.Assign.BowlerList[5].BowlerId + ')');
  Memo1.Lines.Add('Bowler 6 : ' + rLaneInfo.Assign.BowlerList[6].BowlerNm + '(' + rLaneInfo.Assign.BowlerList[6].BowlerId + ')');

  sStr := Global.ReserveList.GetReserveView(nLaneNo);
  Memo1.Lines.Add(sStr);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Global.Com.SendLaneAssignGameTraining(Strtoint(edlaneno.Text), 5);
  Global.Com.SendLaneAssignGameTrainingFin(Strtoint(edlaneno.Text));
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  Global.Com.SendLaneCompetitionBowlerAddTemp(Strtoint(edlaneno.Text), Strtoint(Edit1.Text));
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  Global.Com.SendLaneAssignGameLeague(Strtoint(edlaneno.Text), 'Y');
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  Global.Com.SendLaneAssignGameLeague(Strtoint(edlaneno.Text), 'N');
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  Global.com.SendLaneAssignGameLeagueOpen(StrToInt(edlaneno.Text));
end;

procedure TMainForm.btnHoldCancelClick(Sender: TObject);
var
  rHoldInfo: THoldInfo;
begin
  if Trim(edLaneNo.text) = '' then
    Exit;

  rHoldInfo.HoldUse := 'N';
  rHoldInfo.HoldUser := 'GameServer';
  Global.DM.ChangeLaneHold(edLaneNo.text, rHoldInfo.HoldUse, rHoldInfo.HoldUser);
  Global.Lane.SetLaneHold(edLaneNo.text, rHoldInfo);

  global.Log.LogWrite('홀드강제취소');
end;

end.
