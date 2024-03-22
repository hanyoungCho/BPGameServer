unit uXGServer;

interface

uses
  IdTCPServer, IdContext, System.SysUtils, System.Classes, JSON, Generics.Collections, Windows, System.DateUtils,
  uStruct;

type
  TTcpServer = class
  private
    FTcpServer: TIdTCPServer;
    FCommonSeqNo: Integer;
    //FLastUseSeqNo: Integer; //마지막 임시seq
    FUseSeqDate: String;
    FUseSeqNo: Integer;
    FUseSeqUser: Integer;
    FLastReceiveData: AnsiString;

    FCS: TRTLCriticalSection;
  protected

  public
    constructor Create;
    destructor Destroy; override;

    procedure ServerConnect(AContext: TIdContext);
    procedure ServerExecute(AContext: TIdContext);
    procedure ServerReConnect;

    function SendDataCreat(AReceiveData: AnsiString): AnsiString;

    function SendPinSetter(AReceiveData: AnsiString): AnsiString;
    function SendMoniter(AReceiveData: AnsiString): AnsiString;
    function SendPinSetting(AReceiveData: AnsiString): AnsiString;
    function SendBowlerPause(AReceiveData: AnsiString): AnsiString;

    function InitLane(AReceiveData: AnsiString): AnsiString;
    function RegLaneGame(AReceiveData: AnsiString): AnsiString;
    //function RegAssignBowlerSql(AassignDt: String; AassignSeq: Integer; ALaneNo: String; AjObjArr: TJsonArray): String;
    function RegAssignSql(AAssignInfo: TAssignInfo; AAssignRootDiv, AUserId: String): String;

    function DelLaneGame(AReceiveData: AnsiString): AnsiString;
    function ChgScore(AReceiveData: AnsiString): AnsiString;
    function ChgGameNext(AReceiveData: AnsiString): AnsiString;
    function RegBowler(AReceiveData: AnsiString): AnsiString;
    function ChgBowler(AReceiveData: AnsiString): AnsiString;
    function ChgGameRestore(AReceiveData: AnsiString): AnsiString;
    function ChgLaneMove(AReceiveData: AnsiString): AnsiString;
    function ChgLaneBowlerMove(AReceiveData: AnsiString): AnsiString;
    function DelBowler(AReceiveData: AnsiString): AnsiString;
    function ChgGameCnt(AReceiveData: AnsiString): AnsiString;
    function ChgGameLeague(AReceiveData: AnsiString): AnsiString;
    function ChgGameType(AReceiveData: AnsiString): AnsiString;
    function ChgGameOpen(AReceiveData: AnsiString): AnsiString;
    function ChgGameTime(AReceiveData: AnsiString): AnsiString;
    function ChgBowlerSwitch(AReceiveData: AnsiString): AnsiString;
    function ChgBowlerPay(AReceiveData: AnsiString): AnsiString;
    function ChgBowlerHandy(AReceiveData: AnsiString): AnsiString;
    function RegCompetition(AReceiveData: AnsiString): AnsiString;
    function ChgCheckOut(AReceiveData: AnsiString): AnsiString;

    function ChgLaneHold(AReceiveData: AnsiString): AnsiString;
    function ChgLaneLock(AReceiveData: AnsiString): AnsiString;

    function ServerErpUse(AUse: Boolean): Boolean; // erp 전송여부 체크-레인쓰레드에서 사용중인지 체크

    property TcpServer: TIdTCPServer read FTcpServer write FTcpServer;
    property CommonSeqNo: Integer read FCommonSeqNo write FCommonSeqNo;
    //property LastUseSeqNo: Integer read FLastUseSeqNo write FLastUseSeqNo;
    property UseSeqNo: Integer read FUseSeqNo write FUseSeqNo;
    property UseSeqDate: String read FUseSeqDate write FUseSeqDate;
    property UseSeqUser: Integer read FUseSeqUser write FUseSeqUser;
  end;

implementation

uses
  uGlobal, uFunction, IdGlobal;

{ TTcpServer }

constructor TTcpServer.Create;
begin
  InitializeCriticalSection(FCS);

  FTcpServer := TIdTCPServer.create;

  FTcpServer.OnConnect := ServerConnect;
  FTcpServer.OnExecute := ServerExecute;

  FTcpServer.Bindings.Add;
  FTcpServer.Bindings.Items[0].Port := Global.Config.TcpPort;
  FTcpServer.Active := True;
end;

destructor TTcpServer.Destroy;
begin
  FTcpServer.Active := False;
  FTcpServer.Free;

  DeleteCriticalSection(FCS);

  inherited;
end;

procedure TTcpServer.ServerConnect(AContext: TIdContext);
begin
  //tPort := AContext.Connection.Socket.Binding.PeerPort;
  //MainTH_ID := Format('%06d', [tPort]);

  //LogMsg := Format('Handle[%s] Connect ======================== ', [MainTH_ID]);
  //LogView(LogMsg);
end;

procedure TTcpServer.ServerReConnect;
begin
  FTcpServer.Active := False;
  FTcpServer.Active := True;

  Global.Log.LogServerWrite('ServerReConnect' + #13);
end;

procedure TTcpServer.ServerExecute(AContext: TIdContext);
Var
  sRcvData: AnsiString;
  sSendData: AnsiString;
  LogMsg: String;

RecvBytes, Buffer : TIdBytes;
begin

  try
    sRcvData := '';
    sSendData := '';

    Try
      if Not AContext.Connection.Connected then
        Exit;

      //AContext.Connection.IOHandler.ReadTimeout := 100;
      sRcvData := AContext.Connection.IOHandler.ReadLn(IndyTextEncoding_UTF8);

      Sleep(10);
    Except
      on E: exception do
      begin
        if Not AContext.Connection.Connected then
          AContext.Connection.Disconnect;

        AContext.Connection.Socket.Close;
        Exit;
      end;
    End;

    Try
      EnterCriticalSection(FCS);
      try
        sSendData := SendDataCreat(sRcvData);
      finally
        LeaveCriticalSection(FCS);
      end;
      Sleep(0);
    Except
      on E: exception do
      begin
      end;
    End;

    if sSendData <> '' then
    begin
      try
        AContext.Connection.IOHandler.WriteLn(sSendData, IndyTextEncoding_UTF8);

        Sleep(10);
        AContext.Connection.Disconnect;
      Except
        on E: exception do
        begin
          Exit;
        end;
      end;
    end;

  except
    on E: exception do
    begin
      Exit;
    end;
  end;
end;

function TTcpServer.SendDataCreat(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sStoreCd, sApi, sLogMsg, sUserId: String;
  sResult: AnsiString;
begin
  Result := '';
  sResult := '';
  Global.Log.LogServerWrite(AReceiveData + #13);

  if (Copy(AReceiveData, 1, 1) <> '{') or (Copy(AReceiveData, Length(AReceiveData), 1) <> '}') then
  begin
    sResult := '{"result_cd":"0001","result_msg":"Json Fail"}';
    Global.Log.LogServerWrite(sResult + #13);
    Result := sResult;
    Exit;
  end;

  try
    try
      jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;

      sStoreCd := jObj.GetValue('store_cd').Value;
      if sStoreCd <> Global.Config.StoreCd then
      begin
        sResult := '{"result_cd":"GS01","result_msg":"Store Fail"}';
        Global.Log.LogServerWrite(sResult + #13);
        Result := sResult;
        Exit;
      end;

      sApi := jObj.GetValue('api').Value;
      sUserId := jObj.GetValue('user_id').Value;

      if sApi = 'Z001_sendPinSetter' then           //핀세터 On/Off
        sResult := SendPinSetter(AReceiveData)
      else if sApi = 'Z002_sendMoniter' then        //정보모니터 On/Off
        sResult := SendMoniter(AReceiveData)
      else if sApi = 'Z003_sendPinSetting' then     //핀세팅1,2
        sResult := SendPinSetting(AReceiveData)
      else if sApi = 'Z004_sendBowlerPause' then    //레인 볼러 일시정지/해제
        sResult := SendBowlerPause(AReceiveData)

      else if sApi = 'Z101_initLane' then           //레인 초기화
        sResult := InitLane(AReceiveData)
      else if sApi = 'Z102_regLaneGame' then        //레인 배정
        sResult := RegLaneGame(AReceiveData)
      else if sApi = 'Z103_delLaneGame' then        //레인 게임취소
        sResult := DelLaneGame(AReceiveData)
      else if sApi = 'Z104_chgScore' then           //사용자 점수수정
        sResult := ChgScore(AReceiveData)
      else if sApi = 'Z105_chgGameNext' then        //강제 NEXT
        sResult := ChgGameNext(AReceiveData)
      else if sApi = 'Z106_regBowler' then          //볼러 추가
        sResult := RegBowler(AReceiveData)
      else if sApi = 'Z107_chgBowler' then          //볼러 변경
        sResult := ChgBowler(AReceiveData)
      //else if sApi = 'Z108_chgGameRestore' then   //이전게임 복구
        //sResult := ChgGameRestore(AReceiveData)
      else if sApi = 'Z109_chgLaneMove' then        //레인 전체이동
        sResult := ChgLaneMove(AReceiveData)
      else if sApi = 'Z110_chgLaneBowlerMove' then  //레인 볼러이동
        sResult := ChgLaneBowlerMove(AReceiveData)
      else if sApi = 'Z111_delBowler' then          //볼러제거
        sResult := DelBowler(AReceiveData)

      //else if sApi = 'Z112_chgGameCnt' then         //게임수 지정
        //sResult := ChgGameCnt(AReceiveData)

      else if sApi = 'Z113_chgGameLeague' then      //리그 게임 설정
        sResult := ChgGameLeague(AReceiveData)
      //else if sApi = 'Z114_chgGameOpen' then      //오픈 게임 설정- 리그게임해제
        //sResult := ChgGameOpen(AReceiveData)
      else if sApi = 'Z115_chgGameType' then        //게임타입 8,9,369
        sResult := ChgGameType(AReceiveData)

      //else if sApi = 'Z116_chgGameTime' then        //게임시간 지정
        //sResult := ChgGameTime(AReceiveData)

      else if sApi = 'Z117_chgBowlerPay' then       //볼러결제완료
        sResult := ChgBowlerPay(AReceiveData)
      else if sApi = 'Z118_chgBowlerSwitch' then    //볼러순서 변경
        sResult := ChgBowlerSwitch(AReceiveData)
      //else if sApi = 'Z119_chgBowlerHandy' then     //볼러 핸디
        //sResult := ChgBowlerHandy(AReceiveData)
      //else if sApi = 'Z119_regCompetition' then     //대회 정보
        //sResult := RegCompetition(AReceiveData)

      else if sApi = 'Z119_chgCheckOut' then     //게임종료
        sResult := ChgCheckOut(AReceiveData)

      else if sApi = 'Z201_chgLaneHold' then      //홀드
        sResult := ChgLaneHold(AReceiveData)
      else if sApi = 'Z202_chgLaneLock' then      //점검
        sResult := ChgLaneLock(AReceiveData)

      else
        sResult := '{"result_cd":"GS02","result_msg":"Api Fail"}';

      Global.Log.LogServerWrite(sResult + #13);
      Result := sResult;

    except
      on E: exception do
      begin
        sResult := '{"result_cd":"GS99","result_msg":"' + e.Message + '"}';
        Result := sResult;
        //sLogMsg := 'SendDataCreat Except : ' + e.Message;
        Global.Log.LogServerWrite(sResult + #13);
      end;
    end;

  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.SendPinSetter(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sUseYn: String;
begin
  //Z001_sendPinSetter
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sUseYn := jObj.GetValue('use_yn').Value;

    Global.Com.SendPinSetterOnOff(StrToInt(sLaneNo), sUseYn); //제어등록

    Result := '{"result_cd":"0000", "result_msg":"Success"}';
  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.SendMoniter(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sUseYn: String;
begin
  //Z002_sendMoniter
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sUseYn := jObj.GetValue('use_yn').Value;

    Global.Com.SendMoniterOnOff(sLaneNo, sUseYn); //제어등록

    Result := '{"result_cd":"0000", "result_msg":"Success"}';
  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.SendPinSetting(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sSetType: String;
begin
  //Z003_sendPingSetting
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sSetType := jObj.GetValue('setting_type').Value;

    Global.Com.SendPinSettingNo(sLaneNo, sSetType); //제어등록

    Result := '{"result_cd":"0000", "result_msg":"Success"}';
  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.SendBowlerPause(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sAssignNo, sBowlerId, sPauseYn: String;
  sResult: String;
begin

  //Z004_sendBowlerPause
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    //sLaneNo := jObj.GetValue('lane_no').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sPauseYn := jObj.GetValue('pause_yn').Value;

    sResult := Global.Lane.chgBowlerPause(sAssignNo, sBowlerId, sPauseYn);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';

  finally
    FreeAndNil(jObj);
  end;
end;


function TTcpServer.InitLane(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sResult: String;
begin
  //Z101_initLane
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;

    sResult := Global.Lane.SetLaneAssignCancel(StrToInt(sLaneNo), 0, '');

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';

  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.RegLaneGame(AReceiveData: AnsiString): AnsiString;
var
  jObj, jObjData, jObjBowler: TJSONObject;
  jObjArrData, jObjArrBowler: TJsonArray;
  sApi, sUserId, sTerminalId, sLaneNo, sGameDiv, sGameType, sAssignRootDiv, sLeagueYn: string;
  sSql: String;
  i, nIdx: Integer;
  nArrDataCnt, nArrBowlerCnt: Integer;
  bResult: Boolean;
  rHoldInfo: THoldInfo;
  //rAssignInfo: TAssignInfo;
  rAssignInfoArr: Array of TAssignInfo;
  dtPossibleReserveDt, dtPossibleReserveEndDt: TDateTime;
  nTotalGameCnt, nTotalGameMin: Integer;

  //erp 전송용
  jSendArr: TJSONArray;
  jSend, jSendItem: TJSONObject;
  jSendSubArr: TJSONArray;
  jSendSubItem: TJSONObject;

  nCompetitionSeq, nLaneMoveCnt, nTrainMin, nCompetitionTotalGameCnt: Integer;
  sCompetitionLeagueYn, sMoveMethod: String;

  sLog: String;

  jRecv: TJSONObject;
  sRecvResult, sRecvResultCd, sRecvResultMsg: String;

  nCommonCtl: Integer;

  //응답
  jTempArr: TJSONArray;
  jTemp, jTempItem: TJSONObject;

begin

  ServerErpUse(True);

  //Z102_regLaneGame
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sTerminalId := jObj.GetValue('terminal_id').Value;
    sAssignRootDiv := jObj.GetValue('assign_root_div').Value;

    //대회 복수개 가능??
    //nCompetitionSeq

    jObjArrData := jObj.GetValue('data') as TJsonArray;
    nArrDataCnt := jObjArrData.Size;
    SetLength(rAssignInfoArr, nArrDataCnt);

    nCommonCtl := 0;
    if (sAssignRootDiv = 'K') and (nArrDataCnt = 2) then
    begin
      inc(FCommonSeqNo);
      nCommonCtl := FCommonSeqNo;
    end;

    nCompetitionTotalGameCnt := 0;
    for i := 0 to nArrDataCnt - 1 do
    begin
      jObjData := jObjArrData.Get(i) as TJSONObject;

      sLaneNo := jObjData.GetValue('lane_no').Value;
      sGameDiv := jObjData.GetValue('game_div').Value;
      sLeagueYn := jObjData.GetValue('league_yn').Value;

      nCompetitionSeq := StrToInt(jObjData.GetValue('competition_seq').Value);
      //sCompetitionLeagueYn := jObj.GetValue('league_yn').Value;
      nLaneMoveCnt := StrToInt(jObjData.GetValue('lane_move_cnt').Value);
      sMoveMethod := jObjData.GetValue('move_method').Value;
      nTrainMin := StrToInt(jObjData.GetValue('train_min').Value);

      //sGameType := jObjData.GetValue('game_type').Value;
      sGameType := '0';

      // 홀드여부 확인
      rHoldInfo := Global.Lane.GetLaneHold(sLaneNo);
      if (rHoldInfo.HoldUse = 'N') or (rHoldInfo.HoldUser <> sUserId) then
      begin
        Result := '{"result_cd":"GS04","result_msg":"타석홀드 진행이 안되었습니다. 다시 예약 프로세스를 진행해주세요."}';
        Exit;
      end;

      inc(FUseSeqNo);
      rAssignInfoArr[i].AssignDt := UseSeqDate;
      rAssignInfoArr[i].AssignSeq := UseSeqNo;
      rAssignInfoArr[i].AssignNo := UseSeqDate + StrZeroAdd(IntToStr(UseSeqNo), 4);
      rAssignInfoArr[i].AssignRootDiv := sAssignRootDiv;
      rAssignInfoArr[i].CommonCtl := nCommonCtl;

      rAssignInfoArr[i].CompetitionSeq := nCompetitionSeq;
      //rAssignInfoArr[i].CompetitionLeagueYn := sCompetitionLeagueYn;
      rAssignInfoArr[i].LaneMoveCnt := nLaneMoveCnt;
      rAssignInfoArr[i].MoveMethod := sMoveMethod;
      rAssignInfoArr[i].TrainMin := nTrainMin;
      if nCompetitionSeq > 0 then
        rAssignInfoArr[i].CompetitionLane := StrToInt(sLaneNo);

      rAssignInfoArr[i].GameSeq := 0;
      rAssignInfoArr[i].LaneNo := StrToInt(sLaneNo);
      rAssignInfoArr[i].GameDiv := StrToInt(sGameDiv);
      rAssignInfoArr[i].GameType := StrToInt(sGameType);
      rAssignInfoArr[i].LeagueYn := sLeagueYn; //N

      rAssignInfoArr[i].AssignStatus := 1;  //예약
      //rAssignInfo.StartDatetime := rAssignInfoListDB[i].StartDatetime;

      jObjArrBowler := jObjData.GetValue('bowler') as TJsonArray;
      nArrBowlerCnt := jObjArrBowler.Size;

      nTotalGameCnt := 0;
      nTotalGameMin := 0;
      for nIdx := 0 to nArrBowlerCnt - 1 do
      begin
        jObjBowler := jObjArrBowler.Get(nIdx) as TJSONObject;

        rAssignInfoArr[i].BowlerList[nIdx + 1].ParticipantsSeq := StrToInt(jObjBowler.GetValue('participants_seq').Value);

        rAssignInfoArr[i].BowlerList[nIdx + 1].BowlerSeq := nIdx + 1;

        //rAssignInfoArr[i].BowlerList[nIdx + 1].BowlerId := jObjBowler.GetValue('bowler_id').Value;
        inc(FUseSeqUser);
        rAssignInfoArr[i].BowlerList[nIdx + 1].BowlerId := Copy(UseSeqDate, 7, 2) + StrZeroAdd(IntToStr(FUseSeqUser), 4);

        if (jObjBowler.GetValue('bowler_id').Value = jObjBowler.GetValue('bowler_nm').Value) then // ID 와 볼러명이 동일한 경우 임의등록자로 판단
          rAssignInfoArr[i].BowlerList[nIdx + 1].BowlerNm := StrZeroAdd(IntToStr(UseSeqNo), 2) + Char(64 + (nIdx + 1))
        else
          rAssignInfoArr[i].BowlerList[nIdx + 1].BowlerNm := jObjBowler.GetValue('bowler_nm').Value;

        rAssignInfoArr[i].BowlerList[nIdx + 1].MemberNo := jObjBowler.GetValue('member_no').Value;
        //rAssignInfo.BowlerList[nIdx].GameStartSeq := 1;
        //rAssignInfo.BowlerList[nIdx].GamePlayCnt := 0;
        rAssignInfoArr[i].BowlerList[nIdx + 1].GameCnt := StrToInt(jObjBowler.GetValue('game_cnt').Value);
        rAssignInfoArr[i].BowlerList[nIdx + 1].GameMin := StrToInt(jObjBowler.GetValue('game_min').Value);
        rAssignInfoArr[i].BowlerList[nIdx + 1].PaymentType := StrToInt(jObjBowler.GetValue('payment_type').Value);
        rAssignInfoArr[i].BowlerList[nIdx + 1].FeeDiv := jObjBowler.GetValue('fee_div').Value;
        rAssignInfoArr[i].BowlerList[nIdx + 1].MembershipSeq := StrToInt(jObjBowler.GetValue('membership_seq').Value);
        rAssignInfoArr[i].BowlerList[nIdx + 1].MembershipUseCnt := StrToInt(jObjBowler.GetValue('membership_use_cnt').Value);
        rAssignInfoArr[i].BowlerList[nIdx + 1].MembershipUseMin := StrToInt(jObjBowler.GetValue('membership_use_min').Value);
        rAssignInfoArr[i].BowlerList[nIdx + 1].ProductCd := jObjBowler.GetValue('product_cd').Value;
        rAssignInfoArr[i].BowlerList[nIdx + 1].ProductNm := jObjBowler.GetValue('product_nm').Value;
        rAssignInfoArr[i].BowlerList[nIdx + 1].Handy := StrToInt(jObjBowler.GetValue('handy').Value);
        rAssignInfoArr[i].BowlerList[nIdx + 1].ShoesYn := jObjBowler.GetValue('shoes_yn').Value;

        if rAssignInfoArr[i].GameDiv = 1 then //게임제-게임수 총합
        begin
          nTotalGameCnt := nTotalGameCnt + rAssignInfoArr[i].BowlerList[nIdx + 1].GameCnt;
        end
        else if rAssignInfoArr[i].GameDiv = 2 then //시간제-가장 큰값
        begin
          if nTotalGameMin < rAssignInfoArr[i].BowlerList[nIdx + 1].GameMin then
            nTotalGameMin := rAssignInfoArr[i].BowlerList[nIdx + 1].GameMin;
        end;
      end;

      if nCompetitionSeq > 0 then // 대회 예상종료시간
      begin
        if nCompetitionTotalGameCnt < nTotalGameCnt then
          nCompetitionTotalGameCnt := nTotalGameCnt;
      end;

      //rAssignInfoArr[i].TotalGameCnt := nTotalGameCnt;
      //rAssignInfoArr[i].TotalGameMin := nTotalGameMin;
      rAssignInfoArr[i].BowlerCnt := nArrBowlerCnt;

      //예상 예약시간, 예상 종료시간
      rAssignInfoArr[i].ReserveDate := '';
      rAssignInfoArr[i].ExpectdEndDate := '';

      dtPossibleReserveDt := DateStrToDateTime(Global.Lane.GetPossibleReserveDatetime(rAssignInfoArr[i].LaneNo));
      rAssignInfoArr[i].ReserveDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveDt);

      if nCompetitionSeq = 0 then
      begin
        if (rAssignInfoArr[i].GameDiv = 1) and (nTotalGameCnt > 0) then //게임제
        begin
          dtPossibleReserveEndDt := IncMinute(dtPossibleReserveDt, (Global.Store.PerGameMin * nTotalGameCnt));
          rAssignInfoArr[i].ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveEndDt);
        end
        else if rAssignInfoArr[i].GameDiv = 2 then //시간제
        begin
          dtPossibleReserveEndDt := IncMinute(dtPossibleReserveDt, nTotalGameMin);
          rAssignInfoArr[i].ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveEndDt);
        end;
      end;

    end;

    if nCompetitionSeq > 0 then // 대회 예상종료시간
    begin
      for i := 0 to nArrDataCnt - 1 do
      begin
        rAssignInfoArr[i].ReserveDate := FormatDateTime('YYYYMMDDhhnnss', Now);

        //if (rAssignInfoArr[i].GameDiv = 1) and (nTotalGameCnt > 0) then //게임제
        dtPossibleReserveEndDt := IncMinute(Now, (Global.Store.PerGameMin * nCompetitionTotalGameCnt));
        rAssignInfoArr[i].ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveEndDt);
      end;
    end;

    //Erp 전송-가능여부 체크
    try

      jSend := TJSONObject.Create;
      jSendArr := TJSONArray.Create;
      jSend.AddPair(TJSONPair.Create('laneAssignList', jSendArr));

      for i := 0 to nArrDataCnt - 1 do
      begin
        jSendItem := TJSONObject.Create;
        jSendItem.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
        jSendItem.AddPair(TJSONPair.Create('assign_no', rAssignInfoArr[i].AssignNo));
        jSendItem.AddPair(TJSONPair.Create('lane_no', rAssignInfoArr[i].LaneNo));
        jSendItem.AddPair(TJSONPair.Create('game_div', rAssignInfoArr[i].GameDiv));
        jSendItem.AddPair(TJSONPair.Create('game_type', rAssignInfoArr[i].GameType));
        jSendItem.AddPair(TJSONPair.Create('reserve_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', dtPossibleReserveDt)));
        jSendItem.AddPair(TJSONPair.Create('user_id', sUserId));
        jSendItem.AddPair(TJSONPair.Create('terminal_id', sTerminalId));

        jSendSubArr := TJSONArray.Create;
        jSendItem.AddPair(TJSONPair.Create('bowlerList', jSendSubArr));
        for nIdx := 1 to rAssignInfoArr[i].BowlerCnt do
        begin
          jSendSubItem := TJSONObject.Create;
          jSendSubItem.AddPair( TJSONPair.Create( 'bowler_seq', rAssignInfoArr[i].BowlerList[nIdx].BowlerSeq) );
          jSendSubItem.AddPair( TJSONPair.Create( 'bowler_id', rAssignInfoArr[i].BowlerList[nIdx].BowlerId) );
          jSendSubItem.AddPair( TJSONPair.Create( 'bowler_nm', rAssignInfoArr[i].BowlerList[nIdx].BowlerNm) );
          jSendSubItem.AddPair( TJSONPair.Create( 'member_no', rAssignInfoArr[i].BowlerList[nIdx].MemberNo) );
          jSendSubItem.AddPair( TJSONPair.Create( 'game_cnt', rAssignInfoArr[i].BowlerList[nIdx].GameCnt) );
          jSendSubItem.AddPair( TJSONPair.Create( 'game_min', rAssignInfoArr[i].BowlerList[nIdx].GameMin) );
          jSendSubItem.AddPair( TJSONPair.Create( 'prod_cd', rAssignInfoArr[i].BowlerList[nIdx].ProductCd) );
          jSendSubItem.AddPair( TJSONPair.Create( 'membership_seq', rAssignInfoArr[i].BowlerList[nIdx].MembershipSeq) );
          jSendSubItem.AddPair( TJSONPair.Create( 'membership_use_cnt', rAssignInfoArr[i].BowlerList[nIdx].MembershipUseCnt) );
          jSendSubItem.AddPair( TJSONPair.Create( 'membership_use_min', rAssignInfoArr[i].BowlerList[nIdx].MembershipUseMin) );
          jSendSubArr.Add(jSendSubItem);
        end;

        jSendArr.Add(jSendItem);
      end;

      //Erp 전문전송- 레인베정정보 등록
      sRecvResult := Global.Api.SetErpApiJsonData(jSend.ToString, 'E001_regLaneAssign', Global.Config.ApiUrl, Global.Config.Token);

      sLog := 'E001_regLaneAssign : ' + sRecvResult;
      Global.Log.LogErpApiWrite(sLog);

      if (Copy(sRecvResult, 1, 1) <> '{') or (Copy(sRecvResult, Length(sRecvResult), 1) <> '}') then
      begin
        sLog := jSend.ToString;
        Global.Log.LogErpApiWrite(sLog);

        Result := '{"result_cd":"GS02","result_msg":"' + sRecvResult + '"}';
        Exit;
      end;

      jRecv := TJSONObject.ParseJSONValue(sRecvResult) as TJSONObject;
      sRecvResultCd := jRecv.GetValue('result_cd').Value;
      sRecvResultMsg := jRecv.GetValue('result_msg').Value;

      if sRecvResultCd <> '0000' then
      begin
        Result := '{"result_cd":"' + sRecvResultCd + '", result_msg":"' + sRecvResultMsg + '"}';
        FreeAndNil(jRecv);
        Exit;
      end;

      FreeAndNil(jRecv);
    finally
      FreeAndNil(jSend);
    end;

    for i := 0 to nArrDataCnt - 1 do
    begin

      //DB저장 - 배정
      sSql := RegAssignSql(rAssignInfoArr[i], sAssignRootDiv, sUserId);
      bResult := Global.DM.SqlExec(sSql);
      if bResult = False then
      begin
        Result := '{"result_cd":"GS04","result_msg":"DB 저장에 실패하였습니다"}';
        Exit;
      end;

      Global.Lane.SetLaneAssign(rAssignInfoArr[i]);

      if nCompetitionSeq > 0 then //대회
        Global.Lane.SetCompetitionAssignInit(rAssignInfoArr[i]);

      bResult := Global.DM.ChangeLaneHold(IntToStr(rAssignInfoArr[i].LaneNo), 'N', sUserId);
      if bResult = True then
      begin
        rHoldInfo.HoldUse := 'N';
        rHoldInfo.HoldUser := sUserId;
        Global.Lane.SetLaneHold(IntToStr(rAssignInfoArr[i].LaneNo), rHoldInfo);
      end;

    end;

    //응답 전문
    try
      jTempArr := TJSONArray.Create;
      jTemp := TJSONObject.Create;
      jTemp.AddPair(TJSONPair.Create('result_cd', '0000'));
      jTemp.AddPair(TJSONPair.Create('result_msg', 'Success'));
      jTemp.AddPair(TJSONPair.Create('result_data', jTempArr));

      for i := 0 to nArrDataCnt - 1 do
      begin
        jTempItem := TJSONObject.Create;
        jTempItem.AddPair( TJSONPair.Create( 'lane_no', rAssignInfoArr[i].LaneNo) );
        jTempItem.AddPair( TJSONPair.Create( 'assign_no', rAssignInfoArr[i].AssignNo) );
        jTempItem.AddPair( TJSONPair.Create( 'bowler_id_1', rAssignInfoArr[i].BowlerList[1].BowlerId) );
        jTempItem.AddPair( TJSONPair.Create( 'bowler_id_2', rAssignInfoArr[i].BowlerList[2].BowlerId) );
        jTempItem.AddPair( TJSONPair.Create( 'bowler_id_3', rAssignInfoArr[i].BowlerList[3].BowlerId) );
        jTempItem.AddPair( TJSONPair.Create( 'bowler_id_4', rAssignInfoArr[i].BowlerList[4].BowlerId) );
        jTempItem.AddPair( TJSONPair.Create( 'bowler_id_5', rAssignInfoArr[i].BowlerList[5].BowlerId) );
        jTempItem.AddPair( TJSONPair.Create( 'bowler_id_6', rAssignInfoArr[i].BowlerList[6].BowlerId) );
        jTempArr.Add(jTempItem);
      end;

      Result := jTemp.ToString;
    finally
      FreeAndNil(jTemp);
    end;

  finally
    FreeAndNil(jObj);
    ServerErpUse(False);
  end;

end;

function TTcpServer.RegAssignSql(AAssignInfo: TAssignInfo; AAssignRootDiv, AUserId: String): String;
var
  sSql: String;
  i: Integer;
begin
  Result := '';

  sSql := ' INSERT INTO tb_assign ' +
          '( store_cd, assign_dt, assign_seq, common_seq, game_seq, assign_lane_no, lane_no, game_div, game_type, league_yn, assign_status, assign_root_div, ' +
          '  competition_seq, lane_move_cnt, move_method, train_min, ';

  if AAssignInfo.ReserveDate <> '' then
    sSql := sSql + ' reserve_datetime, expected_end_datetime, ';

    sSql := sSql
         + ' user_id ) ' +
           ' VALUES ' +
           '( ' + QuotedStr(global.Config.StoreCd) + ', '
                + QuotedStr(AAssignInfo.AssignDt) + ', '
                + IntToStr(AAssignInfo.AssignSeq) + ', '
                + IntToStr(AAssignInfo.CommonCtl) + ', '
                + ' ''0'', '
                + IntToStr(AAssignInfo.LaneNo) +', '
                + IntToStr(AAssignInfo.LaneNo) +', '
                + IntToStr(AAssignInfo.GameDiv) + ', '
                + IntToStr(AAssignInfo.GameType) + ', '
                + QuotedStr(AAssignInfo.LeagueYn) + ', '
                + IntToStr(AAssignInfo.AssignStatus) + ', ' // 1 - 예약
                + QuotedStr(AAssignRootDiv) + ', '
                + IntToStr(AAssignInfo.CompetitionSeq) + ', '
                + IntToStr(AAssignInfo.LaneMoveCnt) + ', '
                + QuotedStr(AAssignInfo.MoveMethod) + ', '
                + IntToStr(AAssignInfo.TrainMin) + ', ';

  if AAssignInfo.ReserveDate <> '' then
  begin
    sSql := sSql
               + 'date_format(' + QuotedStr(AAssignInfo.ReserveDate) + ', ''%Y%m%d%H%i%S''), '
               + 'date_format(' + QuotedStr(AAssignInfo.ExpectdEndDate) + ', ''%Y%m%d%H%i%S''), ';
  end;

  sSql := sSql + QuotedStr(AUserId) + ');';

  for i := 1 to AAssignInfo.BowlerCnt do
  begin
    sSql := sSql +
           ' insert into tb_assign_bowler ' +
           ' ( ' +
           ' store_cd, assign_dt, assign_seq, lane_no,' +
           ' participants_seq, bowler_seq, bowler_id, bowler_nm, member_no, game_start, game_cnt, game_min, game_fin,' +
           ' membership_seq, membership_use_cnt, membership_use_min,' +
           ' product_cd, product_nm, payment_type, fee_div, handy, shoes_yn ' +
           ' ) ' +
           ' values ' +
           ' ( ' + QuotedStr(Global.Config.StoreCd) + ', ' + QuotedStr(AAssignInfo.AssignDt) + ' ,' + IntToStr(AAssignInfo.AssignSeq) + ' ,' + IntToStr(AAssignInfo.LaneNo) +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].ParticipantsSeq) +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].BowlerSeq) +
           ' ,' + QuotedStr(AAssignInfo.BowlerList[i].BowlerId) +
           ' ,' + QuotedStr(AAssignInfo.BowlerList[i].BowlerNm) +
           ' ,' + QuotedStr(AAssignInfo.BowlerList[i].MemberNo) +
           ' , 0' +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].GameCnt) +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].GameMin) +
           ' , 0' +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].MembershipSeq) +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].MembershipUseCnt) +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].MembershipUseMin) +
           ' ,' + QuotedStr(AAssignInfo.BowlerList[i].ProductCd) +
           ' ,' + QuotedStr(AAssignInfo.BowlerList[i].ProductNm) +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].PaymentType) +
           ' ,' + QuotedStr(AAssignInfo.BowlerList[i].FeeDiv) +
           ' ,' + IntToStr(AAssignInfo.BowlerList[i].Handy) +
           ' ,' + QuotedStr(AAssignInfo.BowlerList[i].ShoesYn) +
           ' ); ';
  end;

  Result := sSql;
end;

function TTcpServer.DelLaneGame(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sAssignNo, sResult: String;
begin
  //Z103_delLaneGame
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    //sLaneNo := jObj.GetValue('lane_no').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;

    sResult := Global.Lane.SetLaneAssignCancel(0, 1, sAssignNo);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';

  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgScore(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sResult: String;
  sBowlerId, sFrame: String;
begin
  //Z104_chgScore
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    //sLaneNo := jObj.GetValue('lane_no').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sFrame := jObj.GetValue('game_score').Value;

    sResult := Global.Lane.ChgBowlerScore(sAssignNo, sBowlerId, sFrame);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS05", "result_msg":"' + sResult + '"}';

  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgGameNext(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo: String;
begin
  //Z105_chgGameNext
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;

    Global.Lane.SetAssignNext(StrToInt(sLaneNo));

    Result := '{"result_cd":"0000", "result_msg":"Success"}';
  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.RegBowler(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo: String;
  rBowlerInfoTM: TBowlerInfo;
  sResult: String;
begin
  ServerErpUse(True);

  //Z106_regBowler
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;

    //rBowlerInfoTM.BowlerId := jObj.GetValue('bowler_id').Value;
    inc(FUseSeqUser);
    rBowlerInfoTM.BowlerId := Copy(UseSeqDate, 7, 2) + StrZeroAdd(IntToStr(FUseSeqUser), 4);;

    if (jObj.GetValue('bowler_id').Value = jObj.GetValue('bowler_nm').Value) then // ID 와 볼러명이 동일한 경우 임의등록자로 판단
      rBowlerInfoTM.BowlerNm := ''
    else
      rBowlerInfoTM.BowlerNm := jObj.GetValue('bowler_nm').Value;
    rBowlerInfoTM.MemberNo := jObj.GetValue('member_no').Value;
    rBowlerInfoTM.GameStart := 0;
    rBowlerInfoTM.GameCnt := StrToInt(jObj.GetValue('game_cnt').Value);
    rBowlerInfoTM.GameMin := StrToInt(jObj.GetValue('game_min').Value);
    rBowlerInfoTM.GameFin := 0;
    rBowlerInfoTM.FeeDiv := jObj.GetValue('fee_div').Value;
    rBowlerInfoTM.MembershipSeq := StrToInt(jObj.GetValue('membership_seq').Value);
    rBowlerInfoTM.MembershipUseCnt := StrToInt(jObj.GetValue('membership_use_cnt').Value);
    rBowlerInfoTM.MembershipUseMin := StrToInt(jObj.GetValue('membership_use_min').Value);
    rBowlerInfoTM.ProductCd := jObj.GetValue('product_cd').Value;
    rBowlerInfoTM.ProductNm := jObj.GetValue('product_nm').Value;
    rBowlerInfoTM.PaymentType := StrToInt(jObj.GetValue('payment_type').Value);
    rBowlerInfoTM.ShoesYn := jObj.GetValue('shoes_yn').Value;

    // 레인베정정보에 볼러 등록
    sResult := Global.Lane.SetAssignBowler(sAssignNo, rBowlerInfoTM, sUserId);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success", "assign_no":"' + sAssignNo + '", "bowler_id":"' + rBowlerInfoTM.BowlerId + '"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
    ServerErpUse(False);
  end;

end;

function TTcpServer.ChgBowler(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sAssignoNo: String;
  rBowlerInfoTM: TBowlerInfo;
  sResult: String;
begin
  ServerErpUse(True);

  //Z107_chgBowler
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sAssignoNo := jObj.GetValue('assign_no').Value;

    rBowlerInfoTM.BowlerId:= jObj.GetValue('bowler_id').Value;
    rBowlerInfoTM.BowlerNm:= jObj.GetValue('bowler_nm').Value;
    rBowlerInfoTM.MemberNo:= jObj.GetValue('member_no').Value;

    rBowlerInfoTM.GameCnt:= StrToInt(jObj.GetValue('game_cnt').Value);
    rBowlerInfoTM.GameMin:= StrToInt(jObj.GetValue('game_min').Value);
    rBowlerInfoTM.FeeDiv:= jObj.GetValue('fee_div').Value;

    rBowlerInfoTM.MembershipSeq:= StrToInt(jObj.GetValue('membership_seq').Value);
    rBowlerInfoTM.MembershipUseCnt:= StrToInt(jObj.GetValue('membership_use_cnt').Value);
    rBowlerInfoTM.MembershipUseMin:= StrToInt(jObj.GetValue('membership_use_min').Value);
    rBowlerInfoTM.ProductCd:= jObj.GetValue('product_cd').Value;
    rBowlerInfoTM.ProductNm:= jObj.GetValue('product_nm').Value;
    rBowlerInfoTM.ShoesYn:= jObj.GetValue('shoes_yn').Value;

    // 레인베정정보에 볼러 변경
    sResult := Global.Lane.ChgAssignBowler(sAssignoNo, rBowlerInfoTM, sUserId);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
    ServerErpUse(False);
  end;

end;

function TTcpServer.ChgGameRestore(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sResult: String;
  rHoldInfo: THoldInfo;
begin
  //Z108_chgGameRestore
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;

    // 홀드여부 확인
    rHoldInfo := Global.Lane.GetLaneHold(sLaneNo);
    if (rHoldInfo.HoldUse = 'N') or (rHoldInfo.HoldUser <> sUserId) then
    begin
      Result := '{"result_cd":"GS04",' +
                 '"result_msg":"타석홀드 진행이 안되었습니다. 다시 예약 프로세스를 진행해주세요."}';
      Exit;
    end;

    // 레인베정정보에 볼러 변경
    sResult := Global.Lane.ChgAssignRestore(sLaneNo);
    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS04","result_msg":"' + sResult + '"}';

  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.ChgLaneMove(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sTargetLaneNo: String;
  sResult: String;
  bResult: Boolean;
  rHoldInfo: THoldInfo;
begin
  // 프로세서 -- 일단 7번 사용자 정보를 9번에 등록 >> 7번레인 초기화 >> 9번레인 장비 켜기 >> 7번레인 장비 끄기 >> ???
  ServerErpUse(True);

  //Z109_chgLaneMove
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sTargetLaneNo := jObj.GetValue('target_lane_no').Value;

    // 홀드여부 확인
    rHoldInfo := Global.Lane.GetLaneHold(sTargetLaneNo);
    if (rHoldInfo.HoldUse = 'N') or (rHoldInfo.HoldUser <> sUserId) then
    begin
      Result := '{"result_cd":"GS04",' +
                 '"result_msg":"타석홀드 진행이 안되었습니다. 다시 예약 프로세스를 진행해주세요."}';
      Exit;
    end;

    sResult := Global.Lane.ChgAssignMove(sLaneNo, sTargetLaneNo);

    if sResult = 'Success' then
    begin
      Result := '{"result_cd":"0000", "result_msg":"Success"}';

      bResult := Global.DM.ChangeLaneHold(sTargetLaneNo, 'N', sUserId);
      if bResult = True then
      begin
        rHoldInfo.HoldUse := 'N';
        rHoldInfo.HoldUser := sUserId;
        Global.Lane.SetLaneHold(sTargetLaneNo, rHoldInfo);
      end;
    end
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
    ServerErpUse(False);
  end;

end;

function TTcpServer.ChgLaneBowlerMove(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sBowlerId, sTerminalId, sTargetLaneNo: String;
  sResult, sTargetAssignNo, sTargetId: String;
begin

  ServerErpUse(True);

  //Z110_chgLaneBowlerMove
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sTerminalId := jObj.GetValue('terminal_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sTargetLaneNo := jObj.GetValue('target_lane_no').Value;

    sResult := Global.Lane.ChgAssignBowlerMove(sAssignNo, sBowlerId, sTargetLaneNo, sUserId, sTerminalId, sTargetAssignNo, sTargetId);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success", "assign_no":"' + sTargetAssignNo + '", "bowler_id":"' + sTargetId + '"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
    ServerErpUse(False);
  end;
end;

function TTcpServer.DelBowler(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sBowlerId: String;
  sResult: String;
begin
  ServerErpUse(True);

  //Z111_delBowler
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;

    sResult := Global.Lane.DelAssignBowler(sAssignNo, sBowlerId);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
    ServerErpUse(False);
  end;
end;

function TTcpServer.ChgGameCnt(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sBowlerId, sGameCnt: String;
  sResult: String;
begin

  //Z112_chgGameCnt
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sGameCnt := jObj.GetValue('game_cnt').Value;

    sResult := Global.Lane.ChgAssignBowlerGameCnt(sAssignNo, sBowlerId, sGameCnt);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.ChgGameLeague(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sUseYn: String;
  bResult: Boolean;
begin

  //Z113_chgGameLeague
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sUseYn := jObj.GetValue('use_yn').Value;

    bResult := Global.Lane.ChgAssignGameLeague(sLaneNo, sUseYn);

    if bResult = True then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"Fail"}';
  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgGameType(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sAssignNo, sGameType: String;
  bResult: Boolean;
begin

  //Z115_chgGameType
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sGameType := jObj.GetValue('game_type').Value;

    bResult := Global.Lane.ChgAssignGameType(sLaneNo, sAssignNo, sGameType);
    bResult := Global.Lane.ChgAssignGameTypeFin(sLaneNo, sAssignNo, sGameType);

    if bResult = True then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"Fail"}';
  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgGameOpen(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sAssignNo, sGameType: String;
  bResult: Boolean;
begin

  //Z114_chgGameOpen
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    //sAssignNo := jObj.GetValue('assign_no').Value;
    //sGameType := jObj.GetValue('game_type').Value;

    bResult := Global.com.SendLaneAssignGameLeagueOpen(StrToInt(sLaneNo));

    if bResult = True then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"Fail"}';
  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgGameTime(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sBowlerId, sGameTime: String;
  sResult: String;
begin

  //Z116_chgGameTime
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sGameTime := jObj.GetValue('game_time').Value;

    sResult := Global.Lane.ChgAssignBowlerGameTime(sAssignNo, sBowlerId, sGameTime);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.ChgBowlerPay(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sBowlerId, sPaymentType: String;
  sResult: String;
begin

  //Z117_chgBowlerPay
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sPaymentType := jObj.GetValue('payment_type').Value;

    sResult := Global.Lane.ChgBowlerPayment(sAssignNo, sBowlerId, sPaymentType);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgBowlerSwitch(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sBowlerId, sOrderSeq: String;
  sResult: String;
begin

  //Z118_chgBowlerSwitch
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sOrderSeq := jObj.GetValue('order_seq').Value;

    sResult := Global.Lane.ChgAssignBowlerSwitch(sAssignNo, sBowlerId, sOrderSeq);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgBowlerHandy(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sBowlerId, sHandy: String;
  sResult: String;
begin

  //Z119_chgBowlerHandy
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;
    sBowlerId := jObj.GetValue('bowler_id').Value;
    sHandy := jObj.GetValue('handy_score').Value;

    sResult := Global.Lane.ChgAssignBowlerHandy(sAssignNo, sBowlerId, sHandy);
    
    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.RegCompetition(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sCompetitionSeq, sGameMethod, sLaneMoveCnt, sMoveMethod: String;
  sResult: String;
begin

  //Z119_regCompetition
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sCompetitionSeq := jObj.GetValue('competition_seq').Value;
    sGameMethod := jObj.GetValue('game_method').Value;
    sLaneMoveCnt := jObj.GetValue('lane_move_cnt').Value;
    sMoveMethod := jObj.GetValue('move_method').Value;

    //sResult := Global.Lane.RegCompetitionInfo(sCompetitionSeq, sGameMethod, sLaneMoveCnt, sMoveMethod);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';
  finally
    FreeAndNil(jObj);
  end;
end;

function TTcpServer.ChgCheckOut(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sAssignNo, sResult: String;
begin

  ServerErpUse(True);

  //Z119_chgCheckOut
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sAssignNo := jObj.GetValue('assign_no').Value;

    sResult := Global.Lane.SetLaneAssignCheckOut(sAssignNo, sUserId);

    if sResult = 'Success' then
      Result := '{"result_cd":"0000", "result_msg":"Success"}'
    else
      Result := '{"result_cd":"GS99", "result_msg":"' + sResult + '"}';

  finally
    FreeAndNil(jObj);
    ServerErpUse(False);
  end;
end;


function TTcpServer.ChgLaneHold(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sHoldUse, sLog: String;
  nIdx: Integer;
  bResult: Boolean;
  rHoldInfo: THoldInfo;
begin
  //Z201_chgLaneHold
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    sHoldUse := jObj.GetValue('hold_yn').Value;

    nIdx := Global.Lane.GetLaneInfoIndex(StrToInt(sLaneNo));
    if nIdx = -1 then
    begin
      Result := '{"result_cd":"CS03",' + '"result_msg":"해당레인이 없습니다. lane_no=' + sLaneNo + '"}';
      Exit;
    end;

    rHoldInfo := Global.Lane.GetLaneHold(sLaneNo);

    if rHoldInfo.HoldUse = sHoldUse then
    begin
      if sHoldUse = 'Y' then
      begin
        if rHoldInfo.HoldUser <> sUserId then
        begin
          Result := '{"result_cd":"CS03",' + '"result_msg":"예약이 진행중입니다. 다른 레인을 선택해주세요"}';
          Exit;
        end;
      end;

      //홀드요청시 동일사용자, 홀드취소
      Result := '{"result_cd":"0000",' + '"result_msg":"Success"}';
      Exit;
    end
    else
    begin
      if sHoldUse = 'N' then
      begin

        if (rHoldInfo.HoldUser <> sUserId) and (StrPos(PChar(sUserId), PChar('kiosk')) <> nil) then
        begin
          Result := '{"result_cd":"CS03",' + '"result_msg":"예약이 진행중입니다. 임시예약을 취소할수 없습니다"}';
          Exit;
        end;
      end;
    end;

    try
      bResult := Global.DM.ChangeLaneHold(sLaneNo, sHoldUse, sUserId);
      if bResult = True then
      begin
        rHoldInfo.HoldUse := sHoldUse;
        rHoldInfo.HoldUser := sUserId;
        Global.Lane.SetLaneHold(sLaneNo, rHoldInfo);

        Result := '{"result_cd":"0000",' + '"result_msg":"Success"}';
      end
      else
      begin
        Result := '{"result_cd":"",' + '"result_msg":"임시예약에 실패하였습니다. 다시 시도해주세요"}';
      end;

    except
      on e: Exception do
      begin
        sLog := 'ChgLaneHold Exception : ' + sLaneNo + ' / ' + e.Message;
        Global.Log.LogServerWrite(sLog);

        Result := '{"result_cd":"CS03", "result_msg":"임시예약중 장애가 발생하였습니다"}';
        Exit;
      end;
    end;

  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.ChgLaneLock(AReceiveData: AnsiString): AnsiString;
var
  jObj: TJSONObject;
  sApi, sUserId, sLaneNo, sLockUse, sLog: String;
  bResult: Boolean;
begin
  //Z202_chgLaneLock
  Result := '';

  try
    jObj := TJSONObject.ParseJSONValue( AReceiveData ) as TJSONObject;
    sApi := jObj.GetValue('api').Value;
    sUserId := jObj.GetValue('user_id').Value;
    sLaneNo := jObj.GetValue('lane_no').Value;
    if jObj.GetValue('lock_yn').Value = 'Y' then
      sLockUse := '8'
    else
      sLockUse := '0';

    try
      bResult := Global.DM.ChangeLaneStatus(sLaneNo, sLockUse);
      if bResult = True then
      begin
        Global.Lane.SetLaneLock(sLaneNo, sLockUse);

        Result := '{"result_cd":"0000", "result_msg":"Success"}';
      end
      else
      begin
        Result := '{"result_cd":"", "result_msg":"점검설정에 실패하였습니다. 다시 시도해주세요"}';
      end;

    except
      on e: Exception do
      begin
        sLog := 'ChgLaneLock Exception : ' + sLaneNo + ' / ' + e.Message;
        Global.Log.LogServerWrite(sLog);

        Result := '{"result_cd":"CS03", "result_msg":"점검설정중 장애가 발생하였습니다"}';
        Exit;
      end;
    end;

  finally
    FreeAndNil(jObj);
  end;

end;

function TTcpServer.ServerErpUse(AUse: Boolean): Boolean;
begin
  if AUse = False then
  begin
    Global.ServerErp := False;
  end
  else
  begin
    while True do
    begin
      if Global.LaneErp = False then
        Break;

      Global.Log.LogErpApiDelayWrite('LaneErp !!!!!!');
      sleep(50);
    end;

    Global.ServerErp := True;
  end;
end;

end.
