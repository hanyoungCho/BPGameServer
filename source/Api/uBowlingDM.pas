unit uBowlingDM;

interface

uses
  System.Variants, System.SysUtils, System.Classes, Data.DB,
  uStruct, Generics.Collections, Windows, DBAccess, MemDS, Uni,
  UniProvider, MySQLUniProvider;

type
  TBowlingDM = class(TDataModule)
    ConnectionDB: TUniConnection;
    MySQL: TMySQLUniProvider;
    UniConnection1: TUniConnection;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }

    procedure DBConnection;
    procedure DBDisconnect;
  public
    { Public declarations }
    function ReConnection: Boolean;

    function ProcExec(AStoredProc: TUniStoredProc; AProcedureName: string; AParam: array of Variant): TUniStoredProc;
    function SqlExec(ASql: String): Boolean;

    function SelectLaneList: TList<TLaneInfo>;
    function UpdateLane(ALaneInfo: TLaneInfo): Boolean;
    function InsertLane(ALaneInfo: TLaneInfo): Boolean;

    function SelectAssignList: TList<TAssignInfo>;
    function SelectAssignReserveList: TList<TAssignInfoDB>;
    function SelectAssignBowlerList(AAssignDt: String; AAssignSeq: Integer): TList<TBowlerInfo>;
    function SelectAssignBowler(AAssignNo: String; ABowlerId: String): TBowlerInfo;

    //function InsertAssign(AAssignInfo: TAssignInfo; AAssignRootDiv, AUserId: String): Boolean;
    function InsertAssignMove(AAssign: TAssignInfo; AUserId: String): Boolean;
    function UpdateAssign(AUseSeqDate: String; AUseSeqNo, ATargetLaneNo: Integer): Boolean;
    function UpdateAssignCnt(AUseSeqDate: String; AUseSeqNo, AGameCnt: Integer): Boolean;
    function UpdateAssignGameLeague(AUseSeqDate: String; AUseSeqNo: Integer; ALeagueYn: String): Boolean; // 리그
    function UpdateAssignGameType(AUseSeqDate: String; AUseSeqNo: Integer; AGameType: String): Boolean;
    function UpdateAssignLane(AUseSeqDate: String; AUseSeqNo: Integer; ALane: Integer): Boolean;
    function UpdateExpectdEndDate(AAssignNo, AExpectdEndDate: String): Boolean; //예상종료시간

    function SelectAssignBowlerCnt(AAssignNo: String): Integer;
    function InsertAssignBowler(ALaneNo: Integer; AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
    function UpdateAssignBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
    function UpdateAssignBowlerMove(AAssignNo: String; ABowlerIdx: Integer; ATargetLaneNo: Integer; ATargetAssignNo: String; ATargetBowlerIdx: Integer): Boolean;
    function UpdateAssignBowlerSeq(AAssignNo: String; ABowlerId: String; ABowlerIdx: Integer): Boolean;
    function UpdateAssignBowlerDel(AAssignNo: String; ABowlerId: String; ADel: String): Boolean;
    function UpdateAssignBowlerGameCnt(AAssignNo: String; ABowlerId: String; AGameCnt: Integer): Boolean; // 게임수
    function UpdateAssignBowlerGameMin(AAssignNo: String; ABowlerId: String; AGameMin: Integer): Boolean; // 게임시간
    //function UpdateAssignBowlerAll(ALaneNo: Integer): Boolean;
    function UpdateAssignBowlerStart(AUseSeqDate: String; AUseSeqNo, ABowlerSeq, AStart: Integer): Boolean;
    function UpdateAssignBowlerEndCnt(AUseSeqDate: String; AUseSeqNo, ABowlerSeq, AFinCnt: Integer): Boolean;
    function UpdateAssignBowlerPaymentType(AAssignNo: String; ABowlerId: String; APaymentType: String): Boolean;
    function UpdateAssignBowlerHandy(AAssignNo: String; ABowlerId: String; AHandy: String): Boolean;

    function SelectAssignGameList(AAssignDt: String; AAssignSeq, AGameSeq: Integer): TList<TGameInfoDB>;
    function SelectAssignLastSeq(ADate: String):Integer; //마지막 배정순번
    function SelectAssignLastUserSeq(ADate: String):Integer; //마지막 볼러순번

    function ChangeLaneHold(ALaneNo, AUse, AUserId: String): Boolean;
    function ChangeLaneStatus(ALaneNo, AStatus: String): Boolean;

    function chgAssignStartDt(AAssignNo, AStartDt, AUserId: String): Boolean;
    function chgAssignEndDt(AAssignNo, AStatus: String): String;
    function chgGameBowlerStatus(ALaneNo: Integer; AAssignNo, AGameSeq, ABowlerId, ABowlerNm: String; ABowlerStatus: TBowlerStatus): Boolean;

    function InsertGame(ASql: String): Boolean;
    function UpdateGame(AAssignNo: String; AGameSeq, ACnt: Integer): Boolean;
    function UpdateGameEnd(AAssignNo: String; AGameSeq: Integer): Boolean;
    function UpdateGameLane(AAssignDt: String; AAssignSeq, AGameSeq, ALaneNo: Integer): Boolean;

    //DB 배정내역 삭제
    function DeleteReserve(AStorecd, ADate: String): Boolean;
  end;

var
  BowlingDM: TBowlingDM;

implementation

uses
  uGlobal, uFunction;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TBowlingDM.DataModuleCreate(Sender: TObject);
begin
  DBConnection;
end;

procedure TBowlingDM.DataModuleDestroy(Sender: TObject);
begin
  DBDisconnect;
end;

procedure TBowlingDM.DBConnection;
begin
  //bowling / bowling123!;
  ConnectionDB.Port := Global.Config.DBPort;
  ConnectionDB.Connect;
end;

procedure TBowlingDM.DBDisconnect;
begin
  ConnectionDB.Disconnect;
end;


function TBowlingDM.ProcExec(AStoredProc: TUniStoredProc; AProcedureName: string; AParam: array of Variant): TUniStoredProc;
var
  Index: Integer;
begin
  try

    with AStoredProc do
    begin
      Connection := ConnectionDB;
      Close;

      StoredProcName := EmptyStr;
      StoredProcName := AProcedureName;

      Params.CreateParam(ftString, 'P_STORE_CD', ptInput);

      if AProcedureName = 'SP_GET_GS_ASSIGN_LIST' then
        Params.CreateParam(ftString, 'P_STATUS', ptInput);

      if Params.Count > 0 then
      begin
        for Index := Low(AParam) to High(AParam) do
        begin
          if VarType(AParam[Index]) and varTypeMask = varCurrency then
          begin
            Params[Index].DataType := ftCurrency;
            Params[Index].AsCurrency := AParam[Index];
          end
          else
            Params[Index].Value := AParam[Index];
        end;
      end;

      ExecProc;
    end;
    Result := AStoredProc;
  except
    on E: Exception do
    begin
      //
    end;
  end;
end;


function TBowlingDM.SqlExec(ASql: String): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  sSql := ASql;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.SelectLaneList: TList<TLaneInfo>;
var
  sSql: String;
  nIndex: Integer;
  rLaneInfo: TLaneInfo;
begin

  with TUniQuery.Create(nil) do
  begin

    try
      Connection := ConnectionDB;

      sSql := ' SELECT * FROM tb_lane WHERE STORE_CD = ' + QuotedStr(Global.Config.StoreCd);

      Close;
      SQL.Text := sSql;
      Prepared := True;
      ExecSQL;

      Result := TList<TLaneInfo>.Create;
      for nIndex := 0 to RecordCount - 1 do
      begin
        rLaneInfo.LaneNo := FieldByName('LANE_NO').AsInteger;
        rLaneInfo.LaneNm := FieldByName('LANE_NM').AsString;
        rLaneInfo.PinSetterId := FieldByName('PIN_SETTER_ID').AsString;
        rLaneInfo.HoldUse := FieldByName('hold_yn').AsString;
        rLaneInfo.HoldUser := FieldByName('hold_user_id').AsString;

        Result.Add(rLaneInfo);
        Next;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;


function TBowlingDM.UpdateLane(ALaneInfo: TLaneInfo): Boolean;
var
  sSql, sLog: String;
  I: Integer;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' UPDATE tb_lane SET ' +
                '     lane_nm = ' + QuotedStr(ALaneInfo.LaneNm) + ',' +
                '     pin_setter_id = ' + QuotedStr(ALaneInfo.PinSetterId) +
                ' WHERE store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' AND lane_no = ' + IntToStr(ALaneInfo.LaneNo);

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.UpdateLane Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.InsertLane(ALaneInfo: TLaneInfo): Boolean;
var
  sSql, sLog: String;
  I: Integer;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' INSERT INTO tb_lane ' +
                '( store_cd, lane_no, lane_nm, pin_setter_id ) ' +
                ' VALUES ' +
                '( ' + QuotedStr(global.Config.StoreCd) + ', '
                     + IntToStr(ALaneInfo.LaneNo) + ', '
                     + QuotedStr(ALaneInfo.LaneNm) +', '
                     + QuotedStr(ALaneInfo.PinSetterId) + ')';

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.InsertLane Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.ChangeLaneHold(ALaneNo, AUse, AUserId: String): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      Connection := ConnectionDB;

      sSql := ' UPDATE tb_lane SET ' +
              '     hold_yn = ' + QuotedStr(AUse) + ',' +
              '     hold_user_id = ' + QuotedStr(AUserId) +
              ' WHERE STORE_CD = ' + QuotedStr(Global.Config.StoreCd) +
              ' AND lane_no = ' + ALaneNo;

      Close;
      SQL.Text := sSql;
      Prepared := True;
      ExecSQL;

      Result := True;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.ChangeLaneStatus(ALaneNo, AStatus: String): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      Connection := ConnectionDB;

      sSql := ' UPDATE tb_lane SET ' +
              '     use_status = ' + AStatus +
              ' WHERE STORE_CD = ' + QuotedStr(Global.Config.StoreCd) +
              ' AND lane_no = ' + ALaneNo;

      Close;
      SQL.Text := sSql;
      Prepared := True;
      ExecSQL;

      Result := True;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.chgAssignStartDt(AAssignNo, AStartDt, AUserId: String): Boolean;
var
  sSql, sUseSeqDate, sUseSeqNo: String;
  nNo: Integer;
  sLog: String;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  sUseSeqNo := Copy(AAssignNo, 9, 4);
  nNo := StrToInt(sUseSeqNo);
  sUseSeqNo := IntToStr(nNo);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        assign_status = ''3'' ' +
                '        , start_datetime = date_format(' + QuotedStr(AStartDt) + ', ''%Y%m%d%H%i%S'') ' +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + sUseSeqNo;

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;

      end;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.chgAssignEndDt(AAssignNo, AStatus: String): String;
var
  sSql, sUseSeqDate, sUseSeqNo: String;
  nNo: Integer;
  sLog: String;
begin
  Result := 'Success';

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  sUseSeqNo := Copy(AAssignNo, 9, 4);
  nNo := StrToInt(sUseSeqNo);
  sUseSeqNo := IntToStr(nNo);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        assign_status = ' + AStatus +
                '        , end_datetime = now() ' +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + sUseSeqNo;

        Close;
        SQL.Text := sSql;
        ExecSQL;

      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
          Result := E.Message;
        end;

      end;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.chgGameBowlerStatus(ALaneNo: Integer; AAssignNo, AGameSeq, ABowlerId, ABowlerNm: String; ABowlerStatus: TBowlerStatus): Boolean;
var
  sSql, sUseSeqDate, sUseSeqNo, sFrame, sScore: String;
  nNo, j, nStatus1: Integer;
  sLog: String;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  sUseSeqNo := Copy(AAssignNo, 9, 4);
  nNo := StrToInt(sUseSeqNo);
  sUseSeqNo := IntToStr(nNo);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        if ABowlerStatus.Status1 = 'C0' then //홀수레인 투
          nStatus1 := 1
        else if ABowlerStatus.Status1 = 'E0' then //짝수레인 투
          nStatus1 := 2
        else if (ABowlerStatus.Status1 = '02') or (ABowlerStatus.Status1 = '22') then //일시정지
          nStatus1 := 3
        else
          nStatus1 := 0;

        sSql := ' update tb_game set ' +
                '        game_status = ' + IntToStr(nStatus1) +
                '        , last_lane_no = ' + IntToStr(ALaneNo) +
                '        , bowler_id = ' + QuotedStr(ABowlerId) +
                '        , bowler_nm = ' + QuotedStr(ABowlerNm) +
                '        , to_cnt = ' + IntToStr(ABowlerStatus.ToCnt) +
                '        , frame_to = ' + IntToStr(ABowlerStatus.FrameTo);

        sFrame := '';
        for j := 1 to 21 do
        begin
          sFrame := sFrame + ABowlerStatus.FramePin[j];
        end;

        sSql := sSql +
                '        , pin_fall_result = ' + QuotedStr(sFrame);


        for j := 1 to 10 do
        begin
          sScore := IntToStr(ABowlerStatus.FrameScore[j]);
          sSql := sSql +
                '        , frame' + IntToStr(j) + '_score = ' + sScore;
        end;

        sSql := sSql +
              '        , total_score = ' + IntToStr(ABowlerStatus.TotalScore);

        sSql := sSql +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + sUseSeqNo +
                ' and game_seq = ' + AGameSeq +
                ' and bowler_seq = ' + IntToStr(ABowlerStatus.BowlerSeq);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;

      end;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.SelectAssignList: TList<TAssignInfo>;
var
  rAssignInfo: TAssignInfo;
  i, j: Integer;
  sLog: String;
  tmDatetime: TDateTime;
  AProc: TUniStoredProc;
begin

  try
    try

      AProc := TUniStoredProc.Create(nil);
      AProc := ProcExec(AProc, 'SP_GET_GS_ASSIGN_LIST', [global.Config.StoreCd]);

      Result := TList<TAssignInfo>.Create;
      for i := 0 to AProc.RecordCount - 1 do
      begin
        rAssignInfo.AssignDt := AProc.FieldByName('assign_dt').AsString;
        rAssignInfo.AssignSeq := AProc.FieldByName('assign_seq').AsInteger;
        rAssignInfo.AssignNo := rAssignInfo.AssignDt + StrZeroAdd(IntToStr(rAssignInfo.AssignSeq), 4);
        rAssignInfo.CommonCtl := AProc.FieldByName('common_seq').AsInteger;
        rAssignInfo.GameSeq := AProc.FieldByName('game_seq').AsInteger;
        rAssignInfo.LaneNo := AProc.FieldByName('assign_lane_no').AsInteger;
        rAssignInfo.CompetitionLane := AProc.FieldByName('lane_no').AsInteger;
        rAssignInfo.GameDiv := AProc.FieldByName('game_div').AsInteger;
        rAssignInfo.GameType := AProc.FieldByName('game_type').AsInteger;
        rAssignInfo.LeagueYn := AProc.FieldByName('league_yn').AsString;
        rAssignInfo.AssignStatus := AProc.FieldByName('assign_status').AsInteger;
        rAssignInfo.AssignRootDiv := AProc.FieldByName('assign_root_div').AsString;

        rAssignInfo.CompetitionSeq := AProc.FieldByName('competition_seq').AsInteger;
        rAssignInfo.LaneMoveCnt := AProc.FieldByName('lane_move_cnt').AsInteger;
        rAssignInfo.MoveMethod := AProc.FieldByName('move_method').AsString;
        rAssignInfo.TrainMin := AProc.FieldByName('train_min').AsInteger;

        tmDatetime := AProc.FieldByName('start_datetime').AsDateTime;
        rAssignInfo.StartDatetime := FormatDateTime('YYYYMMDDhhnnss', tmDatetime);
        tmDatetime := AProc.FieldByName('reserve_datetime').AsDateTime;
        rAssignInfo.ReserveDate := FormatDateTime('YYYYMMDDhhnnss', tmDatetime);
        tmDatetime := AProc.FieldByName('expected_end_datetime').AsDateTime;
        rAssignInfo.ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', tmDatetime);

        for j := 1 to 6 do
        begin
          rAssignInfo.BowlerList[j].ParticipantsSeq := AProc.FieldByName('participants_seq_' + IntToStr(j)).AsInteger;
          rAssignInfo.BowlerList[j].BowlerId := AProc.FieldByName('bowler_id_' + IntToStr(j)).AsString;
          rAssignInfo.BowlerList[j].BowlerNm := AProc.FieldByName('bowler_nm_' + IntToStr(j)).AsString;
          rAssignInfo.BowlerList[j].MemberNo := AProc.FieldByName('member_no_' + IntToStr(j)).AsString;
          rAssignInfo.BowlerList[j].GameStart := AProc.FieldByName('game_start_' + IntToStr(j)).AsInteger;
          rAssignInfo.BowlerList[j].GameFin := AProc.FieldByName('game_fin_' + IntToStr(j)).AsInteger;
          rAssignInfo.BowlerList[j].GameCnt := AProc.FieldByName('game_cnt_' + IntToStr(j)).AsInteger;
          rAssignInfo.BowlerList[j].GameMin := AProc.FieldByName('game_min_' + IntToStr(j)).AsInteger;
          rAssignInfo.BowlerList[j].MembershipSeq := AProc.FieldByName('membership_seq_' + IntToStr(j)).AsInteger;
          rAssignInfo.BowlerList[j].ProductCd := AProc.FieldByName('product_cd_' + IntToStr(j)).AsString;
          rAssignInfo.BowlerList[j].ProductNm := AProc.FieldByName('product_nm_' + IntToStr(j)).AsString;
          rAssignInfo.BowlerList[j].PaymentType := AProc.FieldByName('payment_type_' + IntToStr(j)).AsInteger;
          rAssignInfo.BowlerList[j].FeeDiv := AProc.FieldByName('fee_div_' + IntToStr(j)).AsString;
          rAssignInfo.BowlerList[j].Handy := AProc.FieldByName('handy_' + IntToStr(j)).AsInteger;
        end;

        Result.Add(rAssignInfo);
        AProc.Next;
      end;

    except
      on E: Exception do
      begin
        sLog := 'TBowlingDM.SelectAssignList.Exception: ' +  E.Message;
        Global.Log.LogErpApiWrite(sLog);
      end;
    end;
  finally
    AProc.Free;
  end;

end;

function TBowlingDM.SelectAssignReserveList: TList<TAssignInfoDB>;
var
  rAssignInfo: TAssignInfoDB;
  i, j: Integer;
  sSql, sLog: String;
  tmDatetime: TDateTime;
begin

  with TUniQuery.Create(nil) do
  try

    Connection := ConnectionDB;

    sSql := ' SELECT * FROM tb_assign ' +
            ' WHERE store_cd = ' + QuotedStr(global.Config.StoreCd) +
            '   AND assign_status = 1' +
            ' order by use_seq ';

    Close;
    SQL.Text := sSql;
    Prepared := True;
    Open;

    Result := TList<TAssignInfoDB>.Create;
    for i := 0 to RecordCount - 1 do
    begin
      rAssignInfo.AssignDt := FieldByName('assign_dt').AsString;
      rAssignInfo.AssignSeq := FieldByName('assign_seq').AsInteger;
      rAssignInfo.AssignNo := rAssignInfo.AssignDt + StrZeroAdd(IntToStr(rAssignInfo.AssignSeq), 4);
      rAssignInfo.CommonCtl := FieldByName('common_seq').AsInteger;
      rAssignInfo.GameSeq := FieldByName('game_seq').AsInteger;
      rAssignInfo.LaneNo := FieldByName('lane_no').AsInteger;
      rAssignInfo.GameDiv := FieldByName('game_div').AsInteger;
      rAssignInfo.GameType := FieldByName('game_type').AsInteger;
      rAssignInfo.LeagueYn := FieldByName('league_yn').AsString;
      rAssignInfo.AssignStatus := FieldByName('assign_status').AsInteger;
      rAssignInfo.AssignRootDiv := FieldByName('assign_root_div').AsString;

      tmDatetime := FieldByName('start_datetime').AsDateTime;
      rAssignInfo.StartDatetime := FormatDateTime('YYYYMMDDhhnnss', tmDatetime);
      tmDatetime := FieldByName('reserve_datetime').AsDateTime;
      rAssignInfo.ReserveDate := FormatDateTime('YYYYMMDDhhnnss', tmDatetime);
      tmDatetime := FieldByName('expected_end_datetime').AsDateTime;
      rAssignInfo.ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', tmDatetime);

      Result.Add(rAssignInfo);
      Next;
    end;

  finally
    Close;
    Free;
  end;

end;

function TBowlingDM.SelectAssignBowlerList(AAssignDt: String; AAssignSeq: Integer): TList<TBowlerInfo>;
var
  rBowlerInfo: TBowlerInfo;
  i: Integer;
  sSql: String;
begin

  with TUniQuery.Create(nil) do
  try

    Connection := ConnectionDB;

    sSql := ' SELECT * FROM tb_assign_bowler ' +
            ' WHERE store_cd = ' + QuotedStr(global.Config.StoreCd) +
            '   AND assign_dt = ' + QuotedStr(AAssignDt) +
            '   AND assign_seq = ' + IntToStr(AAssignSeq) +
            ' order by bowler_seq asc ';

    Close;
    SQL.Text := sSql;
    Prepared := True;
    Open;

    Result := TList<TBowlerInfo>.Create;
    for i := 0 to RecordCount - 1 do
    begin
      rBowlerInfo.BowlerSeq := FieldByName('bowler_seq').AsInteger;
      rBowlerInfo.BowlerId := FieldByName('bowler_id').AsString;
      rBowlerInfo.BowlerNm := FieldByName('bowler_nm').AsString;
      rBowlerInfo.GameCnt := FieldByName('game_cnt').AsInteger;
      rBowlerInfo.GameMin := FieldByName('game_min').AsInteger;
      rBowlerInfo.MembershipSeq := FieldByName('membership_seq').AsInteger;
      rBowlerInfo.ProductCd := FieldByName('product_cd').AsString;
      rBowlerInfo.ProductNm := FieldByName('product_nm').AsString;
      rBowlerInfo.PaymentType := FieldByName('payment_type').AsInteger;
      rBowlerInfo.FeeDiv := FieldByName('fee_div').AsString;
      rBowlerInfo.Handy := FieldByName('handy').AsInteger;
      rBowlerInfo.ShoesYn := FieldByName('shoes_yn').AsString;

      Result.Add(rBowlerInfo);
      Next;
    end;

  finally
    Close;
    Free;
  end;

end;

function TBowlingDM.SelectAssignBowler(AAssignNo: String; ABowlerId: String): TBowlerInfo;
var
  rBowlerInfo: TBowlerInfo;
  i: Integer;
  sSql: String;
  sAssignDate, sAssignSeq: String;
  nAssignSeq: Integer;
begin

  sAssignDate := Copy(AAssignNo, 1, 8);
  sAssignSeq := Copy(AAssignNo, 9, 4);
  nAssignSeq := StrToInt(sAssignSeq);
  sAssignSeq := IntToStr(nAssignSeq);

  with TUniQuery.Create(nil) do
  try

    Connection := ConnectionDB;

    sSql := ' SELECT * FROM tb_assign_bowler ' +
            ' WHERE store_cd = ' + QuotedStr(global.Config.StoreCd) +
            '   AND assign_dt = ' + QuotedStr(sAssignDate) +
            '   AND assign_seq = ' + sAssignSeq +
            '   AND bowler_id = ' + QuotedStr(ABowlerId);

    Close;
    SQL.Text := sSql;
    Prepared := True;
    Open;

    if RecordCount > 0 then
    begin
      rBowlerInfo.BowlerSeq := FieldByName('bowler_seq').AsInteger;
      rBowlerInfo.BowlerId := FieldByName('bowler_id').AsString;
      rBowlerInfo.BowlerNm := FieldByName('bowler_nm').AsString;
      rBowlerInfo.GameCnt := FieldByName('game_cnt').AsInteger;
      rBowlerInfo.GameMin := FieldByName('game_min').AsInteger;
      rBowlerInfo.MembershipSeq := FieldByName('membership_seq').AsInteger;
      rBowlerInfo.ProductCd := FieldByName('product_cd').AsString;
      rBowlerInfo.ProductNm := FieldByName('product_nm').AsString;
      rBowlerInfo.PaymentType := FieldByName('payment_type').AsInteger;
      rBowlerInfo.FeeDiv := FieldByName('fee_div').AsString;
      rBowlerInfo.Handy := FieldByName('handy').AsInteger;
      rBowlerInfo.ShoesYn := FieldByName('shoes_yn').AsString;
    end
    else
    begin
      rBowlerInfo.BowlerSeq := 0;
      rBowlerInfo.BowlerId := '';
    end;

    Result := rBowlerInfo;

  finally
    Close;
    Free;
  end;

end;


{
function TBowlingDM.InsertAssign(AAssignInfo: TAssignInfo; AAssignRootDiv, AUserId: String): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' INSERT INTO tb_assign ' +
                '( store_cd, assign_dt, assign_seq, game_seq, lane_no, game_div, game_type, payment_type, assign_status, assign_root_div,';

        if AAssignInfo.ReserveDate <> '' then
          sSql := sSql + ' reserve_datetime, expected_end_datetime, ';

        sSql := sSql
              + ' user_id ) ' +
                ' VALUES ' +
                '( ' + QuotedStr(global.Config.StoreCd) + ', '
                     + QuotedStr(AAssignInfo.AssignDt) + ', '
                     + IntToStr(AAssignInfo.AssignSeq) + ', '
                     + ' ''0'', '
                     + IntToStr(AAssignInfo.LaneNo) +', '
                     + QuotedStr(AAssignInfo.GameDiv) + ', '
                     + QuotedStr(AAssignInfo.GameType) + ', '
                     + QuotedStr(AAssignInfo.PaymentType) + ', '
                     + ' ''0'', '
                     + QuotedStr(AAssignRootDiv) + ', ';

        if AAssignInfo.ReserveDate <> '' then
        begin
          sSql := sSql
                     + 'date_format(' + QuotedStr(AAssignInfo.ReserveDate) + ', ''%Y%m%d%H%i%S''), '
                     + 'date_format(' + QuotedStr(AAssignInfo.ExpectdEndDate) + ', ''%Y%m%d%H%i%S''), ';
        end;

        sSql := sSql + QuotedStr(AUserId) + ')';

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.InsertAssign Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;
}

function TBowlingDM.InsertAssignMove(AAssign: TAssignInfo; AUserId: String): Boolean;
var
  Assign: TAssignInfo;
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' INSERT INTO tb_assign ' +
                '( store_cd, assign_dt, assign_seq, game_seq, assign_lane_no, lane_no, game_div, game_type, assign_status, assign_root_div,' +
                 ' reserve_datetime, ' +
                 //' expected_end_datetime, ';
                 ' start_datetime, user_id ) ' +
                 ' VALUES ' +
                 '( ' + QuotedStr(global.Config.StoreCd) + ', '
                      + QuotedStr(AAssign.AssignDt) + ', '
                      + IntToStr(AAssign.AssignSeq) + ', '
                      + IntToStr(AAssign.GameSeq) + ', '
                      + IntToStr(AAssign.LaneNo) +', '
                      + IntToStr(AAssign.LaneNo) +', '
                      + IntToStr(AAssign.GameDiv) + ', '
                      + IntToStr(AAssign.GameType) + ', '
                      + IntToStr(AAssign.AssignStatus) + ', ' // 1 - 예약
                      + QuotedStr('P') + ', '
                     + 'date_format(' + QuotedStr(AAssign.ReserveDate) + ', ''%Y%m%d%H%i%S''), '
                     //+ 'date_format(' + QuotedStr(AAssign.ExpectdEndDate) + ', ''%Y%m%d%H%i%S''), ';
                     + ' now(), '
                     + QuotedStr(AUserId) + ');';

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.InsertAssignMove Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssign(AUseSeqDate: String; AUseSeqNo, ATargetLaneNo: Integer): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        assign_lane_no = ' + IntToStr(ATargetLaneNo) +
                '        , lane_no = ' + IntToStr(ATargetLaneNo) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(AUseSeqDate) +
                ' and assign_seq = ' + IntToStr(AUseSeqNo);

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.UpdateAssign Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignCnt(AUseSeqDate: String; AUseSeqNo, AGameCnt: Integer): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        game_seq = ' + IntToStr(AGameCnt) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(AUseSeqDate) +
                ' and assign_seq = ' + IntToStr(AUseSeqNo);

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.UpdateAssign Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignGameLeague(AUseSeqDate: String; AUseSeqNo: Integer; ALeagueYn: String): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        league_yn = ' + QuotedStr(ALeagueYn) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(AUseSeqDate) +
                ' and assign_seq = ' + IntToStr(AUseSeqNo);

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.UpdateAssignGameDiv Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;


function TBowlingDM.UpdateAssignGameType(AUseSeqDate: String; AUseSeqNo: Integer; AGameType: String): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        game_type = ' + QuotedStr(AGameType) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(AUseSeqDate) +
                ' and assign_seq = ' + IntToStr(AUseSeqNo);

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.UpdateAssignGameDiv Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignLane(AUseSeqDate: String; AUseSeqNo: Integer; ALane: Integer): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        lane_no = ' + IntToStr(ALane) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(AUseSeqDate) +
                ' and assign_seq = ' + IntToStr(AUseSeqNo);

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.UpdateAssignGameDiv Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateExpectdEndDate(AAssignNo, AExpectdEndDate: String): Boolean;
var
  sSql, sLog: String;
  sAssignDate, sAssignSeq: String;
  nAssignSeq: Integer;
begin
  Result := False;

  sAssignDate := Copy(AAssignNo, 1, 8);
  sAssignSeq := Copy(AAssignNo, 9, 4);
  nAssignSeq := StrToInt(sAssignSeq);
  sAssignSeq := IntToStr(nAssignSeq);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign set ' +
                '        expected_end_datetime = ' + 'date_format(' + QuotedStr(AExpectdEndDate) + ', ''%Y%m%d%H%i%S'')' +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sAssignDate) +
                ' and assign_seq = ' + sAssignSeq;

        Close;
        SQL.Text := sSql;
        Prepared := True;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := 'TBowlingDM.UpdateExpectdEndDate Exception: ' + E.Message;
          Global.Log.LogWrite(sLog);
        end;
      end;

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.SelectAssignBowlerCnt(AAssignNo: String): Integer;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin
  //Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' select count(*) as count from tb_assign_bowler ' +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and del_yn = ''N'' ';

        Close;
        SQL.Text := sSql;
        Open;

        Result := FieldByName('count').AsInteger;

      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogServerWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.InsertAssignBowler(ALaneNo: Integer; AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' INSERT INTO tb_assign_bowler ' +
                '( store_cd, assign_dt, assign_seq, lane_no, bowler_seq, bowler_id, bowler_nm, member_no, game_start, game_cnt, game_min, game_fin,' +
                '  membership_seq, membership_use_cnt, membership_use_min,' +
                '  product_cd, product_nm, payment_type, fee_div, handy, shoes_yn, del_yn ) ' +
                ' VALUES ' +
                '( ' + QuotedStr(global.Config.StoreCd) + ', '
                     + QuotedStr(sUseSeqDate) + ', '
                     + IntToStr(nUseSeqNo) +', '
                     + IntToStr(ALaneNo) +', '
                     + IntToStr(ABowlerInfoTM.BowlerSeq) +', '
                     + QuotedStr(ABowlerInfoTM.BowlerId) +', '
                     + QuotedStr(ABowlerInfoTM.BowlerNm) +', '
                     + QuotedStr(ABowlerInfoTM.MemberNo) +', '
                     + IntToStr(ABowlerInfoTM.GameStart) +', '
                     + IntToStr(ABowlerInfoTM.GameCnt) +', '
                     + IntToStr(ABowlerInfoTM.GameMin) +', '
                     + IntToStr(ABowlerInfoTM.GameFin) +', '
                     + IntToStr(ABowlerInfoTM.MembershipSeq) +', '
                     + IntToStr(ABowlerInfoTM.MembershipUseCnt) +', '
                     + IntToStr(ABowlerInfoTM.MembershipUseMin) +', '
                     + QuotedStr(ABowlerInfoTM.ProductCd) +', '
                     + QuotedStr(ABowlerInfoTM.ProductNm) +', '
                     + IntToStr(ABowlerInfoTM.PaymentType) +', '
                     + QuotedStr(ABowlerInfoTM.FeeDiv) +', '
                     + IntToStr(ABowlerInfoTM.Handy) +', '
                     + QuotedStr(ABowlerInfoTM.ShoesYn) +', '
                     + ' ''N'' )';

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '  bowler_nm = ' + QuotedStr(ABowlerInfoTM.BowlerNm) +
                '  , member_no = ' + QuotedStr(ABowlerInfoTM.MemberNo) +
                '  , game_cnt = ' + IntToStr(ABowlerInfoTM.GameCnt) +
                '  , game_min = ' + IntToStr(ABowlerInfoTM.GameMin) +
                '  , fee_div = ' + QuotedStr(ABowlerInfoTM.FeeDiv) +
                '  , membership_seq = ' + IntToStr(ABowlerInfoTM.MembershipSeq) +
                '  , membership_use_cnt = ' + IntToStr(ABowlerInfoTM.MembershipUseCnt) +
                '  , membership_use_min = ' + IntToStr(ABowlerInfoTM.MembershipUseMin) +
                '  , product_cd = ' + QuotedStr(ABowlerInfoTM.ProductCd) +
                '  , product_nm = ' + QuotedStr(ABowlerInfoTM.ProductNm) +
                '  , shoes_yn = ' + QuotedStr(ABowlerInfoTM.ShoesYn) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_id = ' + QuotedStr(ABowlerInfoTM.BowlerId) +
                ' and del_yn = ''N'' ';

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogServerWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowlerMove(AAssignNo: String; ABowlerIdx: Integer; ATargetLaneNo: Integer; ATargetAssignNo: String; ATargetBowlerIdx: Integer): Boolean;
var
  sSql, sLog, sUseSeqDate, sTargetUseSeqDate: String;
  nUseSeqNo, nTargetUseSeqNo: Integer;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  sTargetUseSeqDate := Copy(ATargetAssignNo, 1, 8);
  nTargetUseSeqNo := StrToInt(Copy(ATargetAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    assign_dt = ' + QuotedStr(sTargetUseSeqDate) +
                '  , assign_seq = ' + IntToStr(nTargetUseSeqNo) +
                '  , lane_no = ' + IntToStr(ATargetLaneNo) +
                '  , bowler_seq = ' + IntToStr(ATargetBowlerIdx) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_seq = ' + IntToStr(ABowlerIdx) +
                ' and del_yn = ''N'' ';

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowlerSeq(AAssignNo: String; ABowlerId: String; ABowlerIdx: Integer): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    bowler_seq = ' + IntToStr(ABowlerIdx) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_id = ' + QuotedStr(ABowlerId) +
                ' and del_yn = ''N'' ';

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowlerDel(AAssignNo: String; ABowlerId: String; ADel: String): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    del_yn = ' + QuotedStr(ADel) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_id = ' + QuotedStr(ABowlerId);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;


function TBowlingDM.UpdateAssignBowlerGameCnt(AAssignNo: String; ABowlerId: String; AGameCnt: Integer): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    game_cnt = ' + IntToStr(AGameCnt) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_id = ' + QuotedStr(ABowlerId) +
                ' and del_yn = ''N'' ';

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogServerWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowlerGameMin(AAssignNo: String; ABowlerId: String; AGameMin: Integer): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    game_min = ' + IntToStr(AGameMin) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_id = ' + QuotedStr(ABowlerId) +
                ' and del_yn = ''N'' ';

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogServerWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;
{
function TBowlingDM.UpdateAssignBowlerAll(ALaneNo: Integer): Boolean;
var
  sSql, sLog, sUseSeqDate, sIdx: String;
  nUseSeqNo, i: Integer;
  rAssign: TAssignInfo;
begin
  Result := False;

  rAssign := Global.Lane.GetAssignInfo(ALaneNo);
  sUseSeqDate := rAssign.AssignDt;
  nUseSeqNo := rAssign.AssignSeq;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ';

        for i := 1 to 6 do
        begin
          sIdx := IntToStr(i);

          if i = 1 then
          begin
          sSql := sSql +
                '    bowler_'+ sIdx +'_id = ' + QuotedStr(rAssign.BowlerList[i].BowlerId);
          end
          else
          begin
          sSql := sSql +
                '  , bowler_'+ sIdx +'_id = ' + QuotedStr(rAssign.BowlerList[i].BowlerId);
          end;

          sSql := sSql +
                '  , bowler_'+ sIdx +'_nm = ' + QuotedStr(rAssign.BowlerList[i].BowlerNm) +
                //'  , bowler_1_start = ' + QuotedStr(rBowlerInfo.BowlerId) +
                //'  , bowler_1_now = ' + QuotedStr(rBowlerInfo.BowlerId) +
                '  , bowler_'+ sIdx +'_cnt = ' + IntToStr(rAssign.BowlerList[i].GameCnt) +
                '  , bowler_'+ sIdx +'_product_cd = ' + QuotedStr(rAssign.BowlerList[i].ProductCd) +
                '  , bowler_'+ sIdx +'_product_nm = ' + QuotedStr(rAssign.BowlerList[i].ProductNm);
        end;

        sSql := sSql +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;
}
function TBowlingDM.UpdateAssignBowlerStart(AUseSeqDate: String; AUseSeqNo, ABowlerSeq, AStart: Integer): Boolean;
var
  sSql, sLog, sSeq: String;
begin
  Result := False;

  sSeq := IntToStr(ABowlerSeq);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    game_start = ' + IntToStr(AStart) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(AUseSeqDate) +
                ' and assign_seq = ' + IntToStr(AUseSeqNo) +
                ' and bowler_seq = ' + sSeq;

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowlerEndCnt(AUseSeqDate: String; AUseSeqNo, ABowlerSeq, AFinCnt: Integer): Boolean;
var
  sSql, sLog, sSeq: String;
begin
  Result := False;

  sSeq := IntToStr(ABowlerSeq);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    game_fin = ' + IntToStr(AFinCnt) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(AUseSeqDate) +
                ' and assign_seq = ' + IntToStr(AUseSeqNo) +
                ' and bowler_seq = ' + sSeq;

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowlerPaymentType(AAssignNo: String; ABowlerId: String; APaymentType: String): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin

  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    payment_type = ' + APaymentType +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_Id = ' + QuotedStr(ABowlerId);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateAssignBowlerHandy(AAssignNo: String; ABowlerId: String; AHandy: String): Boolean;
var
  sSql, sLog, sUseSeqDate: String;
  nUseSeqNo: Integer;
begin

  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  nUseSeqNo := StrToInt(Copy(AAssignNo, 9, 4));

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_assign_bowler set ' +
                '    handy = ' + AHandy +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and bowler_Id = ' + QuotedStr(ABowlerId);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.SelectAssignGameList(AAssignDt: String; AAssignSeq, AGameSeq: Integer): TList<TGameInfoDB>;
var
  sSql: String;
  rGameInfoDB: TGameInfoDB;
  i, j: Integer;
  sLog, sFrame: String;
begin
  try

    with TUniQuery.Create(nil) do
    try

      Connection := ConnectionDB;

      sSql := ' SELECT * FROM tb_game ' +
              ' WHERE store_cd = ' + QuotedStr(global.Config.StoreCd);

      if AAssignDt = '' then
      begin
      sSql := sSql +
              '   AND game_status in (''C0'', ''80'', ''02'') ' +
              //'   AND game_status <> ''00'' ' +
              ' order by bowler_seq ';
      end
      else
      begin
        sSql := sSql +
              //'   AND game_status = ''1'' ' +
              '   AND assign_dt = ' + QuotedStr(AAssignDt) +
              '   AND assign_seq = ' + IntToStr(AAssignSeq) +
              '   AND game_seq = ' + IntToStr(AGameSeq) +
              ' order by bowler_seq ';
      end;

      Close;
      SQL.Text := sSql;
      Prepared := True;
      Open;

      Result := TList<TGameInfoDB>.Create;
      for i := 0 to RecordCount - 1 do
      begin
        rGameInfoDB.AssignDt := FieldByName('assign_dt').AsString;
        rGameInfoDB.AssignSeq := FieldByName('assign_seq').AsInteger;
        rGameInfoDB.GameSeq := FieldByName('game_seq').AsInteger;
        rGameInfoDB.GameStatus := FieldByName('game_status').AsString;
        rGameInfoDB.LastLaneNo := FieldByName('last_lane_no').AsInteger;
        rGameInfoDB.BowlerSeq := FieldByName('bowler_seq').AsInteger;
        rGameInfoDB.BowlerId := FieldByName('bowler_id').AsString;
        rGameInfoDB.BowlerNm := FieldByName('bowler_nm').AsString;

        sFrame := FieldByName('pin_fall_result').AsString;
        for j := 1 to 21 do
        begin
          rGameInfoDB.FramePin[j] := copy(sFrame, j, 1);
        end;

        for j := 1 to 10 do
        begin
          rGameInfoDB.FrameScore[j] := FieldByName('frame' + IntToStr(j) + '_score').AsInteger;
          //rGameInfoDB.FrameLane[j] := FieldByName('frame' + IntToStr(j) + '_lane').AsInteger;
        end;

        rGameInfoDB.TotalScore := FieldByName('total_score').AsInteger;

        Result.Add(rGameInfoDB);
        Next;
      end;

    finally
      Close;
      Free;
    end;

  except
    on E: Exception do
    begin
      sLog := 'TBowlingDM.SelectAssignGameList.Exception: ' +  E.Message;
      Global.Log.LogErpApiWrite(sLog);
    end;
  end;

end;
 {
function TBowlingDM.SeatUseAllReserveSelectNext(AStoreCode: String): TList<TSeatUseReserve>;
var
  sSql, sUseSeqDate, sUseSeqNo: String;
  rSeatUseReserve: TSeatUseReserve;
  tmDateTime: TDateTime;
  nIndex: Integer;
  sLog: String;
begin
  try

    with TUniQuery.Create(nil) do
    try
      //EnterCriticalSection(FCS);

      Connection := ConnectionAuto;
      sSql := ' select ' +
              '        use_seq as use_seq, ' +
              '        use_seq_date as use_seq_date, ' +
              '        use_seq_no as use_seq_no, ' +
              '        store_cd as store_cd, ' +
              '        seat_no as teebox_no, ' +
              '        seat_nm as teebox_nm, ' +
              '        use_status as use_status, ' +
              '        use_minute as assign_min, ' +
              '        delay_minute as prepare_min, ' +
              '        use_balls as assign_balls, ' +
              '        assign_yn as assign_yn, ' +
              '        reserve_date as reserve_datetime, ' +
              '        start_date as start_datetime, ' +
              '        end_date as end_datetime ' +
              '  from seat_use ' +
              ' where store_cd = ' + QuotedStr(AStoreCode) +
              '   and use_status = ''4'' ' + //-- ( 4:예약, 1:이용중 )
              '   and use_seq_date = ' + FormatDateTime('YYYYMMDD', Now) +
              //'   and now() <= reserve_date ' ; //2020-06-29 수정
              ' order by seat_no, reserve_date'; //2021-08-02

      Close;
      SQL.Text := sSql;
      Prepared := True;
      Open;

      Result := TList<TSeatUseReserve>.Create;
      for nIndex := 0 to RecordCount - 1 do
      begin
        rSeatUseReserve.SeatNo := FieldByName('teebox_no').AsInteger;
        rSeatUseReserve.SeatNm := FieldByName('teebox_nm').AsString;

        sUseSeqDate := FieldByName('use_seq_date').AsString;
        sUseSeqNo := StrZeroAdd(FieldByName('use_seq_no').AsString, 4);
        rSeatUseReserve.ReserveNo := sUseSeqDate + sUseSeqNo;

        rSeatUseReserve.UseStatus := FieldByName('use_status').AsString;
        rSeatUseReserve.UseMinute := FieldByName('assign_min').AsInteger;
        rSeatUseReserve.UseBalls := FieldByName('assign_balls').AsInteger;
        rSeatUseReserve.DelayMinute := FieldByName('prepare_min').AsInteger;
        rSeatUseReserve.AssignYn := FieldByName('assign_yn').AsString;
        rSeatUseReserve.ReserveDateTm := FieldByName('reserve_datetime').AsDateTime;
        rSeatUseReserve.ReserveDate := FormatDateTime('YYYYMMDDhhnnss', rSeatUseReserve.ReserveDateTm);

        Result.Add(rSeatUseReserve);
        Next;
      end;

    finally
      //LeaveCriticalSection(FCS);

      Close;
      Free;
    end;

  except
    on E: Exception do
    begin
      sLog := 'SeatUseAllReserveSelectNext.Exception: ' +  E.Message;
      Global.Log.LogErpApiWrite(sLog);
    end;
  end;

end;
}

function TBowlingDM.ReConnection: Boolean;
begin
  Global.Log.LogWrite('DB ReConnection!!');
  DBDisconnect;
  DBConnection;
end;

function TBowlingDM.SelectAssignLastSeq(ADate: String):Integer;
var
  sSql: String;
  nSeq: Integer;
begin
  Result := 1;

  with TUniQuery.Create(nil) do
  try
    Connection := ConnectionDB;
    sSql := ' select Max(assign_seq) as max_assign_seq from tb_assign ' +
            '  where store_cd = ' + QuotedStr(global.Config.StoreCd) +
            '    and assign_dt = ' + QuotedStr(ADate);

    Close;
    SQL.Text := sSql;
    Prepared := True;
    Open;

    if not IsEmpty then
    begin
      nSeq := FieldByName('max_assign_seq').AsInteger;
      Result := nSeq;
    end;

  finally
    Close;
    Free;
  end;

end;

function TBowlingDM.SelectAssignLastUserSeq(ADate: String):Integer;
var
  sSql, sSeq: String;
  nSeq: Integer;
begin
  Result := 1;

  with TUniQuery.Create(nil) do
  try
    Connection := ConnectionDB;
    sSql := ' select Max(bowler_id) as max_user_seq from tb_assign_bowler ' +
            '  where store_cd = ' + QuotedStr(global.Config.StoreCd) +
            '    and assign_dt = ' + QuotedStr(ADate);

    Close;
    SQL.Text := sSql;
    Prepared := True;
    Open;

    if not IsEmpty then
    begin
      sSeq := FieldByName('max_user_seq').AsString;
      if sSeq = '' then
        nSeq := 0
      else
        nSeq := StrToInt(copy(sSeq, 3, 4));
      Result := nSeq;
    end;

  finally
    Close;
    Free;
  end;

end;

function TBowlingDM.InsertGame(ASql: String): Boolean;
var
  sSql, sLog: String;
begin
  Result := False;

  sSql := ASql;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;
      end

    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateGame(AAssignNo: String; AGameSeq, ACnt: Integer): Boolean;
var
  sSql, sUseSeqDate, sUseSeqNo: String;
  nUseSeqNo: Integer;
  sLog: String;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  sUseSeqNo := Copy(AAssignNo, 9, 4);
  nUseSeqNo := StrToInt(sUseSeqNo);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_game set ' +
                '        game_status = ''0'' ' +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and game_seq = ' + IntToStr(AGameSeq) +
                ' and bowler_seq = ' + IntToStr(ACnt + 1);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;

      end;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateGameEnd(AAssignNo: String; AGameSeq: Integer): Boolean;
var
  sSql, sUseSeqDate, sUseSeqNo: String;
  nUseSeqNo: Integer;
  sLog: String;
begin
  Result := False;

  sUseSeqDate := Copy(AAssignNo, 1, 8);
  sUseSeqNo := Copy(AAssignNo, 9, 4);
  nUseSeqNo := StrToInt(sUseSeqNo);

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_game set ' +
                '        game_status = ''3'' ' +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and assign_dt = ' + QuotedStr(sUseSeqDate) +
                ' and assign_seq = ' + IntToStr(nUseSeqNo) +
                ' and game_seq = ' + IntToStr(AGameSeq);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;

      end;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.UpdateGameLane(AAssignDt: String; AAssignSeq, AGameSeq, ALaneNo: Integer): Boolean;
var
  sSql: String;
  sLog: String;
begin
  Result := False;

  with TUniQuery.Create(nil) do
  begin

    try
      try
        Connection := ConnectionDB;

        sSql := ' update tb_game set ' +
                '        last_lane_no = ' + IntToStr(ALaneNo) +
                ' where store_cd = ' + QuotedStr(global.Config.StoreCd) +
                ' and game_status <> ''0'' ' +
                ' and assign_dt = ' + QuotedStr(AAssignDt) +
                ' and assign_seq = ' + IntToStr(AAssignSeq) +
                ' and game_seq = ' + IntToStr(AGameSeq);

        Close;
        SQL.Text := sSql;
        ExecSQL;

        Result := True;
      except
        on E: Exception do
        begin
          sLog := E.Message + ' / ' + sSql;
          Global.Log.LogErpApiWrite(sLog);
        end;

      end;
    finally
      Close;
      Free;
    end;
  end;

end;

function TBowlingDM.DeleteReserve(AStorecd, ADate: String): Boolean;
var
  sSql, sLog: String;
begin

  Result := False;

  with TUniQuery.Create(nil) do
  try
    try
      Connection := ConnectionDB;
      sSql :=  ' delete from tb_assign ' +
               ' where store_cd = ' + QuotedStr(AStorecd) +
               ' and assign_dt < ' + QuotedStr(ADate);
      Close;
      SQL.Text := sSql;
      ExecSQL;

      sSql :=  ' delete from tb_assign_bowler ' +
               ' where store_cd = ' + QuotedStr(AStorecd) +
               ' and assign_dt < ' + QuotedStr(ADate);
      Close;
      SQL.Text := sSql;
      ExecSQL;

      sSql :=  ' delete from tb_game ' +
               ' where store_cd = ' + QuotedStr(AStorecd) +
               ' and assign_dt < ' + QuotedStr(ADate);
      Close;
      SQL.Text := sSql;
      ExecSQL;

      Result := True;
    except
      on E: Exception do
      begin
        sLog := 'DeleteReserve Exception: ' + E.Message;
        Global.Log.LogErpApiWrite(sLog);
      end;
    end;
  finally
    Close;
    Free;
  end;

end;

end.

