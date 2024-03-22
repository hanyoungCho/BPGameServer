unit uLaneInfo;

interface

uses
  uStruct, uConsts,
  System.Classes, System.SysUtils, System.DateUtils,
  System.Generics.Collections;

  {
  * 카멜케이스 방식
  * 목록 조건 조회 : get + 용어 + SchList (필수/옵션 에 따른 조건조회)
  * 목록 조회 : get + 용어 + List (목록 전체 조회, 가급적 목록 조건조회로 대체)
  * 상세 조회 : get + 용어 (단건 조회)
  * 등록 : reg + 용어
  * 수정 : chg + 용어
  * 삭제 : del + 용어
  * 취소 : cancel + 용어
  * 전송 : send + 용어
  }

type
  TLane = class
  private
    FLaneList: array of TLaneInfo;
    FLaneCnt: Integer;
    //FAssignInfoList: array of TAssignInfo;

    //FLaneStatusUse: Boolean;
    //FLaneReserveUse: Boolean;

    FSendApiList: TStringList;

    //FCompetitionInfo: TCompetitionInfo;
    FCompetitionList: array of TCompetitionInfo;

  public
    constructor Create;
    destructor Destroy; override;

    procedure StartUp;
    procedure LaneClear;

    procedure DBInit; //영업시작전 데이터 초기화

    //procedure LaneAssignChk; //배정
    function RegGameSql(AIdx: Integer): String;
    //procedure LaneStatusChk; //게임상태

    procedure LaneStatusChk_tm; //게임상태
    function LaneStatusChk_tm_start(AIdx: Integer): Boolean; //게임시작
    function LaneStatusChk_tm_end_check(AIdx: Integer): Boolean; //게임종료 확인
    function LaneStatusChk_tm_end_League_check(AIdx: Integer): Boolean; //게임종료-2개레인 사용리그
    function LaneStatusChk_tm_end(AIdx: Integer): Boolean; //게임종료
    function LaneStatusChk_tm_game(AIdx: Integer): Boolean; //게임저장

    procedure LaneStatusChk_tm_Competition; //게임상태-대회
    function LaneStatusChk_tm_Competition_start(AIdx: Integer): Boolean; //게임시작-대회
    function LaneStatusChk_tm_Competition_LaneMove(AIdx: Integer): Boolean; //대회-레인이동

    procedure LaneReserveChk; //다음 배정

    procedure SetLaneGameStatus(AGameStatus: TGameStatus); //응답데이타

    procedure RegAssignEpr(AAssignNo, AApi, AJson: String); // erp 등록용 데이터 생성
    procedure LaneReserveErp;
    procedure LaneGameScoreErp(ALaneIdx, ABowlerIdx: Integer);

    function GetLaneListToApi: Boolean; //레인정보-ERP
    function GetLaneListToDB: Boolean;  //레인정보-DB(긴급배정모드시)
    function SetLaneList: Boolean;      //레인정보-ERP조회시 DB정보확인
    function SetInitLaneAssign: Boolean;    //레인배정정보
    function SetLaneAssign(rAssignInfo: TAssignInfo): Boolean;    //배정요청 레인배정

    //function SetCompetitionCnt: Boolean;    //배정요청 대회
    function SetCompetitionAssignInit(AAssignInfo: TAssignInfo): Boolean;    //배정요청 대회배정 정보
    //function SetCompetitionAssign(rAssignInfo: TAssignInfo): Boolean;    //배정요청 대회배정 정보
    function GetCompetitionIndex(ACompetitionSeq: Integer): Integer;    // 대회 인덱스
    function ChkCompetition(ACompetitionSeq: Integer): boolean;

    function SetLaneAssignReserve(rReserveInfo: TReserveInfo): Boolean;    //예약건 레인배정
    function SetLaneAssignCancel(ALaneNo: Integer; AType: Integer; AAssignNo: String): String;   //레인배정취소
    function SetLaneAssignCheckOut(AAssignNo, AUserId: String): String;   //레인배정종료

    function GetLaneInfo(ALaneNo: Integer): TLaneInfo;
    function GetLaneInfoToIndex(AIdx: Integer): TLaneInfo;
    function GetLaneInfoIndex(ALaneNo: Integer): Integer;
    function GetLaneInfoCtlYn(ALaneNo: Integer): Boolean;
    function GetPossibleReserveDatetime(ALaneNo: Integer): String;
    function GetAssignNoIndex(AAssignNo: String): Integer;
    function GetAssignNoBowlerIndex(AIdx: Integer; ABowlerId: String): Integer;
    function GetAssignNoCompetitionSeq(AAssignNo: String): Integer;
    function GetCompetitionSeqBowlerIndex(ASeq: Integer; ABowlerId: String; var ALaneIdx: Integer): Integer;

    function SetLaneHold(ALaneNo: String; rHoldInfo: THoldInfo): Boolean;
    function GetLaneHold(ALaneNo: String): THoldInfo;
    function SetLaneLock(ALaneNo, AStatus: String): Boolean;

    function GetGameStatus(ALaneNo: Integer): TGameStatus;
    function GetGameBowlerStatus(ALaneNo, ABowlerIdx: Integer): TBowlerStatus;
    function GetAssignInfo(ALaneNo: Integer): TAssignInfo;

    //function SetAssignMove(ALaneNo, ATargetLaneNo: Integer): Boolean;

    function SetAssignBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo; AUserId: String): String;
    function SetAssignNext(ALaneNo: Integer): Boolean;
    function ChgAssignBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo; AUserId: String): String;
    function ChgAssignMove(ALaneNo, ATargetLaneNo: String): String;
    function ChgAssignBowlerMove(AAssignNo, ABowlerId, ATargetLaneNo, AUserId, sTerminalId: String; var ATargetAssignNo, ATargetId: String): String; // 볼러 이동
    function DelAssignBowler(AAssignNo, ABowlerId: String): String;
    function ChgAssignBowlerGameCnt(AAssignNo, ABowlerId, AGameCnt: String): String; //게임수
    function ChgAssignBowlerGameTime(AAssignNo, ABowlerId, AGameTime: String): String; //게임시간
    function ChgAssignBowlerSwitch(AAssignNo, ABowlerId, AOrderSeq: String): String; //게임시간
    function ChgAssignGameLeague(ALaneNo, AUseYn: String): Boolean;
    function ChgAssignGameType(ALaneNo, AAssignNo, AGameType: String): Boolean;
    function ChgAssignGameTypeFin(ALaneNo, AAssignNo, AGameType: String): Boolean;
    function ChgAssignRestore(ALaneNo: String): String;
    function ChgBowlerPayment(AAssignNo, ABowlerId, APaymentType: String): String; //볼러결제완료
    function chgBowlerPause(AAssignNo, ABowlerId, APauseYn: String): String;
    function ChgAssignBowlerHandy(AAssignNo, ABowlerId, AHandy: String): String;

    function ChgBowlerScore(AAssignNo, ABowlerId, AFrame: String): String;

    function ChkBowlerNm(ABowlerNm: String): String;

    procedure SetLaneErrorCnt(ALaneNo: Integer; AError: String; AMaxCnt: Integer);

    //procedure ChgAssignBowlerList();
    procedure ChgGameBowlerList(APLaneIdx, APBIdx, AGLaneIdx, AGBIdx: Integer); // 변경할 lane, 볼러idx , data 가져올 lane, 볼러idx
    procedure SetExpectdEndDate(ALIdx: Integer);

    property LaneCnt: Integer read FLaneCnt write FLaneCnt;
    //property LaneStatusUse: Boolean read FLaneStatusUse write FLaneStatusUse;
    //property LaneReserveUse: Boolean read FLaneReserveUse write FLaneReserveUse;
  end;

implementation

uses
  uGlobal, uFunction, JSON;

{ Tasuk }

constructor TLane.Create;
begin
  FLaneCnt := 0;

  //FLaneStatusUse := False;
  //FLaneReserveUse := False;
end;

destructor TLane.Destroy;
begin
  LaneClear;

  inherited;
end;

procedure TLane.StartUp;
begin
  if Global.Config.Emergency = False then
  begin
    GetLaneListToApi;
    SetLaneList;
  end
  else
    GetLaneListToDB;

  Global.ReserveList.StartUp;

  SetInitLaneAssign;
  FSendApiList := TStringList.Create;
end;

procedure TLane.LaneClear;
var
  i: Integer;
begin
  SetLength(FLaneList, 0);

  for i := 0 to FSendApiList.Count - 1 do
  begin
    FSendApiList.Delete(0);
  end;
  FreeAndNil(FSendApiList);

  for i := 0 to Length(FCompetitionList) - 1 do
  begin
    SetLength(FCompetitionList[i].List, 0);
  end;
  SetLength(FCompetitionList, 0);
end;

procedure TLane.DBInit;
var
  nIdx: Integer;
  sStr: String;
begin

  // 레인에 배정된 데이타 기준으로 초기화
  for nIdx := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[nIdx].Assign.AssignNo = '' then
      Continue;

    if FLaneList[nIdx].Assign.AssignStatus = 5 then //5: 종료(미결제), 6:종료, 7:취소
      Continue;

    if FLaneList[nIdx].Assign.PaymentResult = 0 then //미결제
      Continue;

    //기존 배정 정리필요
    FLaneList[nIdx].Assign.AssignDt := '';
    FLaneList[nIdx].Assign.AssignSeq := 0;
    FLaneList[nIdx].Assign.AssignNo := '';

    FLaneList[nIdx].Assign.CompetitionSeq := 0;
    FLaneList[nIdx].Assign.CompetitionLane := 0;

    // DB/Erp저장: 종료시간
    Global.DM.chgAssignEndDt(FLaneList[nIdx].Assign.AssignNo, '7');
    FLaneList[nIdx].Assign.EndDatetime := '';

    //제어
    Global.Com.SendInitLane(IntToStr(FLaneList[nIdx].LaneNo));
    Global.Com.SendPinSetterOnOff(FLaneList[nIdx].LaneNo, 'N');
    //Global.Com.SendLaneTemp(IntToStr(FLaneList[nIdx].LaneNo));

    sStr := '배정초기화 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].Assign.AssignNo;
    Global.Log.LogReserveWrite(sStr);
  end;

end;

function TLane.GetLaneListToApi: Boolean;
var
  nIndex: Integer;
  jObjArr: TJsonArray;
  jObj, jObjSub: TJSONObject;

  sJsonStr: AnsiString;
  sResult, sResultCd, sResultMsg, sLog: String;
begin
  Result := False;

  try
    sJsonStr := '?store_cd=' + Global.Config.StoreCd;
    sResult := Global.Api.GetErpApi(sJsonStr, 'B501_getLaneList', Global.Config.ApiUrl, Global.Config.Token);
    //Global.Log.LogWrite(sResult);

    if (Copy(sResult, 1, 1) <> '{') or (Copy(sResult, Length(sResult), 1) <> '}') then
    begin
      sLog := 'GetLaneListToApi Fail : ' + sResult;
      Global.Log.LogWrite(sLog);
      Exit;
    end;

    jObj := TJSONObject.ParseJSONValue(sResult) as TJSONObject;
    sResultCd := jObj.GetValue('result_cd').Value;
    sResultMsg := jObj.GetValue('result_msg').Value;

    if sResultCd <> '0000' then
    begin
      sLog := 'B501_getLaneList : ' + sResultCd + ' / ' + sResultMsg;
      Global.Log.LogWrite(sLog);
      Exit;
    end;

    jObjArr := jObj.GetValue('result_data') as TJsonArray;
    FLaneCnt := jObjArr.Size;

    SetLength(FLaneList, FLaneCnt);

    for nIndex := 0 to FLaneCnt - 1 do
    begin
      jObjSub := jObjArr.Get(nIndex) as TJSONObject;

      FLaneList[nIndex].LaneNo := StrToInt(jObjSub.GetValue('lane_no').Value);
      FLaneList[nIndex].LaneNm := jObjSub.GetValue('lane_nm').Value;
      FLaneList[nIndex].PinSetterId := jObjSub.GetValue('pin_setter_id').Value;
      FLaneList[nIndex].CtlYn := odd(FLaneList[nIndex].LaneNo); // 홀수면 true, 짝수면 false
      FLaneList[nIndex].ChgYn := False;
    end;

  finally
    FreeAndNil(jObj);
  end;

  Result := True;
end;

function TLane.GetLaneListToDB: Boolean;
var
  rLaneInfoDBList: TList<TLaneInfo>;
  nIndex: Integer;
begin
  Result := False;

  rLaneInfoDBList := Global.DM.SelectLaneList;

  try
    FLaneCnt := rLaneInfoDBList.Count;
    SetLength(FLaneList, FLaneCnt);

    for nIndex := 0 to FLaneCnt - 1 do
    begin
      FLaneList[nIndex].LaneNo := rLaneInfoDBList[nIndex].LaneNo;
      FLaneList[nIndex].LaneNm := rLaneInfoDBList[nIndex].LaneNm;
      FLaneList[nIndex].PinSetterId := rLaneInfoDBList[nIndex].PinSetterId;
      FLaneList[nIndex].HoldUse := rLaneInfoDBList[nIndex].HoldUse;
      FLaneList[nIndex].HoldUser := rLaneInfoDBList[nIndex].HoldUser;
      FLaneList[nIndex].ChgYn := True;
    end;

  finally
    FreeAndNil(rLaneInfoDBList);
  end;

  Result := True;
end;

function TLane.SetLaneList: Boolean;
var
  rLaneInfoDBList: TList<TLaneInfo>;
  rLaneInfo: TList<TLaneInfo>;
  I, nIndex: Integer;
begin
  rLaneInfoDBList := Global.DM.SelectLaneList;

  for I := 0 to rLaneInfoDBList.Count - 1 do
  begin
    nIndex := GetLaneInfoIndex(rLaneInfoDBList[I].LaneNo);

    if nIndex = -1  then
    Continue;
    if (FLaneList[nIndex].LaneNm <> rLaneInfoDBList[I].LaneNm) or
       (FLaneList[nIndex].PinSetterId <> rLaneInfoDBList[I].PinSetterId) then
    begin
      Global.DM.UpdateLane(FLaneList[nIndex]);
    end;

    FLaneList[nIndex].HoldUse := rLaneInfoDBList[I].HoldUse;
    FLaneList[nIndex].HoldUser := rLaneInfoDBList[I].HoldUser;
    FLaneList[nIndex].ChgYn := True;
  end;
  FreeAndNil(rLaneInfoDBList);

  for I := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[I].ChgYn = False then
      Global.DM.InsertLane(FLaneList[I]);
  end;

end;

function TLane.SetInitLaneAssign: Boolean;
var
  rAssignListDB: TList<TAssignInfo>;
  rReserveListDB: TList<TAssignInfoDB>;
  //rGameInfoListDB: TList<TGameInfoDB>;
  i, j, nIdx, nGameIdx, nBowlerCnt, nPaymentResult: Integer;
  sStr: String;
  rAssignInfo: TAssignInfo;
begin

  // 현재사용중 목록
  rAssignListDB := Global.DM.SelectAssignList; //0: 빈타석, 1:예약건, 2:홀드, 3:진행, 4: 미정, 5: 종료(미결제), 6:종료, 7:취소
  for i := 0 to rAssignListDB.Count - 1 do
  begin
    if rAssignListDB[i].CompetitionSeq > 0 then
      nIdx := GetLaneInfoIndex(rAssignListDB[i].CompetitionLane)
    else
      nIdx := GetLaneInfoIndex(rAssignListDB[i].LaneNo);

    if nIdx = -1 then
      Continue;

    FLaneList[nIdx].Assign.AssignDt := rAssignListDB[i].AssignDt;
    FLaneList[nIdx].Assign.AssignSeq := rAssignListDB[i].AssignSeq;
    FLaneList[nIdx].Assign.AssignNo := FLaneList[nIdx].Assign.AssignDt + StrZeroAdd(IntToStr(FLaneList[nIdx].Assign.AssignSeq), 4);

    FLaneList[nIdx].Assign.CommonCtl := rAssignListDB[i].CommonCtl;

    FLaneList[nIdx].Assign.CompetitionSeq := rAssignListDB[i].CompetitionSeq;
    FLaneList[nIdx].Assign.LaneMoveCnt := rAssignListDB[i].LaneMoveCnt;
    FLaneList[nIdx].Assign.MoveMethod := rAssignListDB[i].MoveMethod;
    FLaneList[nIdx].Assign.TrainMin := rAssignListDB[i].TrainMin;

    //FLaneList[nIdx].Assign.LaneNo := rAssignListDB[i].LaneNo;
    FLaneList[nIdx].Assign.LaneNo := FLaneList[nIdx].LaneNo;
    FLaneList[nIdx].Assign.CompetitionLane := rAssignListDB[i].CompetitionLane;

    FLaneList[nIdx].Assign.GameSeq := rAssignListDB[i].GameSeq;
    FLaneList[nIdx].Assign.GameDiv := rAssignListDB[i].GameDiv;
    FLaneList[nIdx].Assign.GameType := rAssignListDB[i].GameType;
    FLaneList[nIdx].Assign.LeagueYn := rAssignListDB[i].LeagueYn;
    FLaneList[nIdx].Assign.AssignStatus := rAssignListDB[i].AssignStatus;
    FLaneList[nIdx].Assign.AssignRootDiv := rAssignListDB[i].AssignRootDiv;
    FLaneList[nIdx].Assign.StartDatetime := rAssignListDB[i].StartDatetime;
    FLaneList[nIdx].Assign.ReserveDate := rAssignListDB[i].ReserveDate;
    FLaneList[nIdx].Assign.ExpectdEndDate := rAssignListDB[i].ExpectdEndDate;

    nBowlerCnt := 0;
    nPaymentResult := 1;
    for j := 1 to 6 do
    begin
      FLaneList[nIdx].Assign.BowlerList[j].ParticipantsSeq := rAssignListDB[i].BowlerList[j].ParticipantsSeq;
      FLaneList[nIdx].Assign.BowlerList[j].BowlerSeq := j;
      FLaneList[nIdx].Assign.BowlerList[j].BowlerId := rAssignListDB[i].BowlerList[j].BowlerId;
      FLaneList[nIdx].Assign.BowlerList[j].BowlerNm := rAssignListDB[i].BowlerList[j].BowlerNm;
      FLaneList[nIdx].Assign.BowlerList[j].MemberNo := rAssignListDB[i].BowlerList[j].MemberNo;
      FLaneList[nIdx].Assign.BowlerList[j].GameCnt := rAssignListDB[i].BowlerList[j].GameCnt;
      FLaneList[nIdx].Assign.BowlerList[j].GameMin := rAssignListDB[i].BowlerList[j].GameMin;
      FLaneList[nIdx].Assign.BowlerList[j].GameStart := rAssignListDB[i].BowlerList[j].GameStart;
      FLaneList[nIdx].Assign.BowlerList[j].GameFin := rAssignListDB[i].BowlerList[j].GameFin;
      FLaneList[nIdx].Assign.BowlerList[j].MembershipSeq := rAssignListDB[i].BowlerList[j].MembershipSeq;
      FLaneList[nIdx].Assign.BowlerList[j].ProductCd := rAssignListDB[i].BowlerList[j].ProductCd;
      FLaneList[nIdx].Assign.BowlerList[j].ProductNm := rAssignListDB[i].BowlerList[j].ProductNm;
      FLaneList[nIdx].Assign.BowlerList[j].PaymentType := rAssignListDB[i].BowlerList[j].PaymentType;
      FLaneList[nIdx].Assign.BowlerList[j].FeeDiv := rAssignListDB[i].BowlerList[j].FeeDiv;
      FLaneList[nIdx].Assign.BowlerList[j].Handy := rAssignListDB[i].BowlerList[j].Handy;

      FLaneList[nIdx].Game.BowlerList[j].EndGameCnt := rAssignListDB[i].BowlerList[j].GameFin;

      if FLaneList[nIdx].Assign.BowlerList[j].BowlerId <> '' then
      begin
        inc(nBowlerCnt);

        if FLaneList[nIdx].Assign.BowlerList[j].PaymentType = 0 then
          nPaymentResult := 0; //미결제
      end;
    end;

    FLaneList[nIdx].Assign.BowlerCnt := nBowlerCnt;
    FLaneList[nIdx].Assign.PaymentResult := nPaymentResult;

    if FLaneList[nIdx].Assign.CompetitionSeq > 0 then
    begin
      SetCompetitionAssignInit(FLaneList[nIdx].Assign);
    end;

    sStr := '목록 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].Assign.AssignDt + ' / ' + IntToStr(FLaneList[nIdx].Assign.AssignSeq);
    Global.Log.LogReserveWrite(sStr);

  end;
  FreeAndNil(rAssignListDB);

  {
  //현재사용중 게임정보
  rGameInfoListDB := Global.DM.SelectAssignGameList('', 0, 0);
  for i := 0 to rGameInfoListDB.Count - 1 do
  begin
    nIdx := GetLaneInfoIndex(rGameInfoListDB[i].LastLaneNo);
    nGameIdx := rGameInfoListDB[i].BowlerSeq;

    for j := 1 to 21 do
    begin
      FLaneList[nIdx].Assign.BowlerList[nGameIdx].FramePin[j] := rGameInfoListDB[i].FramePin[j];
      FLaneList[nIdx].Assign.BowlerList[nGameIdx].FramePinCom[j] := rGameInfoListDB[i].FramePin[j];
    end;

    for j := 1 to 10 do
    begin
      FLaneList[nIdx].Assign.BowlerList[nGameIdx].FrameScore[j] := rGameInfoListDB[i].FrameScore[j];
      FLaneList[nIdx].Assign.BowlerList[nGameIdx].FrameScoreCom[j] := rGameInfoListDB[i].FrameScore[j];
    end;
    FLaneList[nIdx].Assign.BowlerList[nGameIdx].TotalScore := rGameInfoListDB[i].TotalScore;
  end;
  FreeAndNil(rGameInfoListDB);
  }

  //배정할 예약목록
  rReserveListDB := Global.DM.SelectAssignReserveList;
  for i := 0 to rReserveListDB.Count - 1 do
  begin
    rAssignInfo.AssignDt := rReserveListDB[i].AssignDt;
    rAssignInfo.AssignSeq := rReserveListDB[i].AssignSeq;
    rAssignInfo.AssignNo := rReserveListDB[i].AssignNo;
    rAssignInfo.CommonCtl := rReserveListDB[i].CommonCtl;
    rAssignInfo.LaneNo := rReserveListDB[i].LaneNo;
    rAssignInfo.GameDiv := rReserveListDB[i].GameDiv;
    rAssignInfo.GameType := rReserveListDB[i].GameType;
    rAssignInfo.LeagueYn := rReserveListDB[i].LeagueYn;
    rAssignInfo.AssignStatus := rReserveListDB[i].AssignStatus;
    rAssignInfo.AssignRootDiv := rReserveListDB[i].AssignRootDiv;
    rAssignInfo.StartDatetime := rReserveListDB[i].StartDatetime;
    rAssignInfo.ReserveDate := rReserveListDB[i].ReserveDate;
    rAssignInfo.ExpectdEndDate := rReserveListDB[i].ExpectdEndDate;

    sStr := '예약목록 : ' + IntToStr(rAssignInfo.LaneNo) + ' / ' + rAssignInfo.AssignDt + ' / ' + IntToStr(rAssignInfo.AssignSeq);
    Global.Log.LogReserveWrite(sStr);

    Global.ReserveList.RegReserve(rAssignInfo);
  end;
  FreeAndNil(rReserveListDB);

  Global.TcpServer.UseSeqNo := Global.DM.SelectAssignLastSeq(FormatDateTime('YYYYMMDD', Now));
  Global.TcpServer.UseSeqUser := Global.DM.SelectAssignLastUserSeq(FormatDateTime('YYYYMMDD', Now));
  Global.TcpServer.UseSeqDate := FormatDateTime('YYYYMMDD', Now);

end;

function TLane.SetLaneAssign(rAssignInfo: TAssignInfo): Boolean;
var
  nIdx: Integer;
  sLog: String;
  I, nCnt, nPayResult: Integer;
begin

  nIdx := GetLaneInfoIndex(rAssignInfo.LaneNo);

  if FLaneList[nIdx].Assign.AssignNo <> EmptyStr then
  begin
    //예약건으로 이동
    Global.ReserveList.RegReserve(rAssignInfo);
    Exit;
  end;

  FLaneList[nIdx].Assign := rAssignInfo;
  {
  FLaneList[nIdx].Assign.AssignDt := rAssignInfo.AssignDt;
  FLaneList[nIdx].Assign.AssignSeq := rAssignInfo.AssignSeq;
  FLaneList[nIdx].Assign.AssignNo := rAssignInfo.AssignNo;
  FLaneList[nIdx].Assign.GameSeq := rAssignInfo.GameSeq;
  //FAssignInfoList[nIndex].LaneNo := rAssignInfoListDB[i].LaneNo;
  FLaneList[nIdx].Assign.GameDiv := rAssignInfo.GameDiv;
  FLaneList[nIdx].Assign.GameType := rAssignInfo.GameType;
  FLaneList[nIdx].Assign.LeagueYn := rAssignInfo.LeagueYn;
  FLaneList[nIdx].Assign.AssignStatus := rAssignInfo.AssignStatus;
  FLaneList[nIdx].Assign.StartDatetime := rAssignInfo.StartDatetime;
  //FLaneList[nIdx].Assign.EndDatetime := rAssignInfo.EndDatetime;
  FLaneList[nIdx].Assign.ReserveDate := rAssignInfo.ReserveDate;
  FLaneList[nIdx].Assign.ExpectdEndDate := rAssignInfo.ExpectdEndDate;
  }
  nCnt := 0;
  nPayResult := 1;
  for I := 1 to 6 do
  begin
    {
    FLaneList[nIdx].Assign.BowlerList[I].BowlerSeq := rAssignInfo.BowlerList[I].BowlerSeq;
    FLaneList[nIdx].Assign.BowlerList[I].BowlerId := rAssignInfo.BowlerList[I].BowlerId;
    FLaneList[nIdx].Assign.BowlerList[I].BowlerNm := rAssignInfo.BowlerList[I].BowlerNm;
    FLaneList[nIdx].Assign.BowlerList[I].GameCnt := rAssignInfo.BowlerList[I].GameCnt;
    FLaneList[nIdx].Assign.BowlerList[I].GameMin := rAssignInfo.BowlerList[I].GameMin;
    FLaneList[nIdx].Assign.BowlerList[I].GameFin := 0;
    FLaneList[nIdx].Assign.BowlerList[I].ProductCd := rAssignInfo.BowlerList[I].ProductCd;
    FLaneList[nIdx].Assign.BowlerList[I].ProductNm := rAssignInfo.BowlerList[I].ProductNm;
    FLaneList[nIdx].Assign.BowlerList[I].PaymentType := rAssignInfo.BowlerList[I].PaymentType;
    FLaneList[nIdx].Assign.BowlerList[I].FeeDiv := rAssignInfo.BowlerList[I].FeeDiv;
    FLaneList[nIdx].Assign.BowlerList[I].Handy := rAssignInfo.BowlerList[I].Handy;
    }
    FLaneList[nIdx].Assign.BowlerList[I].BowlerSeq := I;

    if FLaneList[nIdx].Assign.BowlerList[I].BowlerId <> '' then
    begin
      inc(nCnt);

      if FLaneList[nIdx].Assign.BowlerList[I].PaymentType = 0 then
        nPayResult := 0;
    end;
  end;
  FLaneList[nIdx].Assign.BowlerCnt := nCnt;
  FLaneList[nIdx].Assign.PaymentResult := nPayResult;
end;

{
function TLane.SetCompetitionCnt: Boolean;
var
  nCnt: Integer;
begin
  nCnt := Length(FCompetitionList);
  SetLength(FCompetitionList, nCnt + 1);
end;
}

function TLane.SetCompetitionAssignInit(AAssignInfo: TAssignInfo): Boolean;
var
  nIdx, nLIdx: Integer;
  sLog: String;
  I, nCnt, nPayResult: Integer;
begin

  nIdx := -1;
  for i := 0 to Length(FCompetitionList) - 1 do
  begin
    if AAssignInfo.CompetitionSeq = FCompetitionList[i].CompetitionSeq then
    begin
      nIdx := i;
      Break;
    end;
  end;

  if nIdx = -1 then
  begin
    nCnt := Length(FCompetitionList);
    SetLength(FCompetitionList, nCnt + 1);
    nIdx := nCnt;
    FCompetitionList[nIdx].CompetitionSeq := AAssignInfo.CompetitionSeq;
    FCompetitionList[nIdx].LeagueYn := AAssignInfo.LeagueYn;
    FCompetitionList[nIdx].LaneMoveCnt := AAssignInfo.LaneMoveCnt;
    FCompetitionList[nIdx].MoveMethod := AAssignInfo.MoveMethod;
    FCompetitionList[nIdx].TrainMin := AAssignInfo.TrainMin;

    FCompetitionList[nIdx].Cnt := 0;
    FCompetitionList[nIdx].StartLane := 0;
    FCompetitionList[nIdx].EndLane := 0;
  end;

  Inc(FCompetitionList[nIdx].Cnt);
  SetLength(FCompetitionList[nIdx].List, FCompetitionList[nIdx].Cnt);

  nLIdx := FCompetitionList[nIdx].Cnt - 1;
  FCompetitionList[nIdx].List[nLIdx] := AAssignInfo;

  nCnt := 0;
  nPayResult := 1;
  for I := 1 to 6 do
  begin

    if FCompetitionList[nIdx].List[nLIdx].BowlerList[I].BowlerId <> '' then
    begin
      inc(nCnt);

      if FCompetitionList[nIdx].List[nLIdx].BowlerList[I].PaymentType = 0 then
        nPayResult := 0;
    end;

  end;
  FCompetitionList[nIdx].List[nLIdx].BowlerCnt := nCnt;
  FCompetitionList[nIdx].List[nLIdx].PaymentResult := nPayResult;

  if FCompetitionList[nIdx].List[nLIdx].GameSeq > 0 then
    FCompetitionList[nIdx].List[nLIdx].GameSeq := FCompetitionList[nIdx].List[nLIdx].GameSeq - 1;

  if FCompetitionList[nIdx].StartLane = 0 then
  begin
    FCompetitionList[nIdx].StartLane := AAssignInfo.LaneNo;
    FCompetitionList[nIdx].EndLane := AAssignInfo.LaneNo;
  end
  else
  begin
    if FCompetitionList[nIdx].StartLane > AAssignInfo.LaneNo then
      FCompetitionList[nIdx].StartLane := AAssignInfo.LaneNo;

    if FCompetitionList[nIdx].EndLane < AAssignInfo.LaneNo then
      FCompetitionList[nIdx].EndLane := AAssignInfo.LaneNo;
  end;

end;
(*
function TLane.SetCompetitionAssign(rAssignInfo: TAssignInfo): Boolean;
var
  nIdx, nLIdx: Integer;
  sLog: String;
  I, nCnt, nPayResult: Integer;
begin
  nIdx := Length(FCompetitionList) - 1;

  Inc(FCompetitionList[nIdx].Cnt);
  SetLength(FCompetitionList[nIdx].List, FCompetitionList[nIdx].Cnt);

  nLIdx := FCompetitionList[nIdx].Cnt - 1;
  FCompetitionList[nIdx].List[nLIdx] := rAssignInfo;
  {
  FCompetitionInfo.List[nIdx].AssignDt := rAssignInfo.AssignDt;
  FCompetitionInfo.List[nIdx].AssignSeq := rAssignInfo.AssignSeq;
  FCompetitionInfo.List[nIdx].AssignNo := rAssignInfo.AssignNo;
  FCompetitionInfo.List[nIdx].GameSeq := rAssignInfo.GameSeq;
  FCompetitionInfo.List[nIdx].LaneNo := rAssignInfo.LaneNo;
  FCompetitionInfo.List[nIdx].GameDiv := rAssignInfo.GameDiv;
  FCompetitionInfo.List[nIdx].GameType := rAssignInfo.GameType;
  FCompetitionInfo.List[nIdx].LeagueYn := rAssignInfo.LeagueYn;
  FCompetitionInfo.List[nIdx].AssignStatus := rAssignInfo.AssignStatus;
  FCompetitionInfo.List[nIdx].StartDatetime := rAssignInfo.StartDatetime;
  //FLaneList[nIdx].Assign.EndDatetime := rAssignInfo.EndDatetime;
  FCompetitionInfo.List[nIdx].ReserveDate := rAssignInfo.ReserveDate;
  FCompetitionInfo.List[nIdx].ExpectdEndDate := rAssignInfo.ExpectdEndDate;

  FCompetitionInfo.List[nIdx].CompetitionLane := rAssignInfo.LaneNo;
  }
  nCnt := 0;
  nPayResult := 1;
  for I := 1 to 6 do
  begin
    //FCompetitionInfo.List[nIdx].BowlerList[I] := rAssignInfo.BowlerList[I];
    {
    FCompetitionInfo.List[nIdx].BowlerList[I].ParticipantsSeq := rAssignInfo.BowlerList[I].ParticipantsSeq;
    FCompetitionInfo.List[nIdx].BowlerList[I].BowlerSeq := rAssignInfo.BowlerList[I].BowlerSeq;
    FCompetitionInfo.List[nIdx].BowlerList[I].BowlerId := rAssignInfo.BowlerList[I].BowlerId;
    FCompetitionInfo.List[nIdx].BowlerList[I].BowlerNm := rAssignInfo.BowlerList[I].BowlerNm;
    FCompetitionInfo.List[nIdx].BowlerList[I].GameCnt := rAssignInfo.BowlerList[I].GameCnt;
    FCompetitionInfo.List[nIdx].BowlerList[I].GameMin := rAssignInfo.BowlerList[I].GameMin;
    FCompetitionInfo.List[nIdx].BowlerList[I].GameFin := 0;
    FCompetitionInfo.List[nIdx].BowlerList[I].ProductCd := rAssignInfo.BowlerList[I].ProductCd;
    FCompetitionInfo.List[nIdx].BowlerList[I].ProductNm := rAssignInfo.BowlerList[I].ProductNm;
    FCompetitionInfo.List[nIdx].BowlerList[I].PaymentType := rAssignInfo.BowlerList[I].PaymentType;
    FCompetitionInfo.List[nIdx].BowlerList[I].FeeDiv := rAssignInfo.BowlerList[I].FeeDiv;
    FCompetitionInfo.List[nIdx].BowlerList[I].Handy := rAssignInfo.BowlerList[I].Handy;
    }
    if FCompetitionList[nIdx].List[nLIdx].BowlerList[I].BowlerId <> '' then
    begin
      inc(nCnt);

      if FCompetitionList[nIdx].List[nLIdx].BowlerList[I].PaymentType = 0 then
        nPayResult := 0;
    end;

  end;
  FCompetitionList[nIdx].List[nLIdx].BowlerCnt := nCnt;
  FCompetitionList[nIdx].List[nLIdx].PaymentResult := nPayResult;
  FCompetitionList[nIdx].List[nLIdx].CompetitionLane := FCompetitionList[nIdx].List[nLIdx].LaneNo;

  if FCompetitionList[nIdx].StartLane = 0 then
  begin
    FCompetitionList[nIdx].CompetitionSeq := rAssignInfo.CompetitionSeq;
    FCompetitionList[nIdx].LeagueYn := rAssignInfo.LeagueYn;
    FCompetitionList[nIdx].LaneMoveCnt := rAssignInfo.LaneMoveCnt;
    FCompetitionList[nIdx].MoveMethod := rAssignInfo.MoveMethod;

    FCompetitionList[nIdx].StartLane := rAssignInfo.LaneNo;
    FCompetitionList[nIdx].EndLane := rAssignInfo.LaneNo;
  end
  else
  begin
    if FCompetitionList[nIdx].StartLane > rAssignInfo.LaneNo then
      FCompetitionList[nIdx].StartLane := rAssignInfo.LaneNo;

    if FCompetitionList[nIdx].EndLane < rAssignInfo.LaneNo then
      FCompetitionList[nIdx].EndLane := rAssignInfo.LaneNo;
  end;

end;
*)
function TLane.GetCompetitionIndex(ACompetitionSeq: Integer): Integer;
var
  nIdx: Integer;
  I, nCnt: Integer;
begin
  nIdx := -1;

  nCnt := Length(FCompetitionList);

  for I := 0 to nCnt - 1 do
  begin
    if FCompetitionList[i].CompetitionSeq = ACompetitionSeq then
    begin
      nIdx := i;
      Break;
    end;
  end;

  Result := nIdx;
end;

function TLane.ChkCompetition(ACompetitionSeq: Integer): boolean;
var
  I, nCompetitionIdx: Integer;
  bCompetitionEnd, bInit: Boolean;
  sLog: String;
begin
  Result := False;

  begin
    bCompetitionEnd := True;

    for i := 0 to LaneCnt - 1 do
    begin
      if FLaneList[i].Assign.CompetitionSeq = ACompetitionSeq then //대회
      begin
        bCompetitionEnd := False;
        Break;
      end;
    end;

    if bCompetitionEnd = True then
    begin
      nCompetitionIdx := GetCompetitionIndex(ACompetitionSeq);
      if nCompetitionIdx > -1 then
      begin
        FCompetitionList[nCompetitionIdx].CompetitionSeq := 0;
        FCompetitionList[nCompetitionIdx].Cnt := 0;
        FCompetitionList[nCompetitionIdx].StartLane := 0;
        FCompetitionList[nCompetitionIdx].EndLane := 0;
        SetLength(FCompetitionList[nCompetitionIdx].List, 0);

        sLog := '대회정보 초기화- 대회코드: ' + IntToStr(ACompetitionSeq);
        Global.Log.LogReserveWrite(sLog);
      end;

      bInit := True;
      for i := 0 to LaneCnt - 1 do
      begin
        if FCompetitionList[i].CompetitionSeq <> 0 then //대회
        begin
          bInit := False;
          Break;
        end;
      end;

      if bInit = True then
      begin
        SetLength(FCompetitionList, 0);
        sLog := '대회정보 리스트 초기화';
        Global.Log.LogReserveWrite(sLog);
      end;

    end;
  end;

  Result := True;
end;

function TLane.SetLaneAssignReserve(rReserveInfo: TReserveInfo): Boolean;
var
  nIdx, nBIdx: Integer;
  sLog: String;
  I, nCnt, nPayResult: Integer;
  rBowlerInfoList: TList<TBowlerInfo>;
begin

  nIdx := GetLaneInfoIndex(rReserveInfo.LaneNo);

  FLaneList[nIdx].Assign.AssignDt := rReserveInfo.AssignDt;
  FLaneList[nIdx].Assign.AssignSeq := rReserveInfo.AssignSeq;
  FLaneList[nIdx].Assign.AssignNo := rReserveInfo.AssignNo;
  FLaneList[nIdx].Assign.CommonCtl := rReserveInfo.CommonCtl;
  FLaneList[nIdx].Assign.GameSeq := 0;
  FLaneList[nIdx].Assign.GameDiv := rReserveInfo.GameDiv;
  FLaneList[nIdx].Assign.GameType := rReserveInfo.GameType;
  FLaneList[nIdx].Assign.LeagueYn := rReserveInfo.LeagueYn;
  FLaneList[nIdx].Assign.AssignStatus := 1;
  FLaneList[nIdx].Assign.StartDatetime := '';
  FLaneList[nIdx].Assign.EndDatetime := '';

  //배정할 볼러정보
  nPayResult := 1;
  rBowlerInfoList := Global.DM.SelectAssignBowlerList(rReserveInfo.AssignDt, rReserveInfo.AssignSeq);
  for i := 0 to rBowlerInfoList.Count - 1 do
  begin
    nBIdx := rBowlerInfoList[i].BowlerSeq;

    FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq := rBowlerInfoList[i].BowlerSeq;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerId := rBowlerInfoList[I].BowlerId;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerNm := rBowlerInfoList[I].BowlerNm;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt := rBowlerInfoList[I].GameCnt;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin := rBowlerInfoList[I].GameMin;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].MembershipSeq := rBowlerInfoList[I].MembershipSeq;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].ProductCd := rBowlerInfoList[I].ProductCd;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].ProductNm := rBowlerInfoList[I].ProductNm;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].PaymentType := rBowlerInfoList[I].PaymentType;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].FeeDiv := rBowlerInfoList[I].FeeDiv;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].Handy := rBowlerInfoList[I].Handy;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].ShoesYn := rBowlerInfoList[I].ShoesYn;
    FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := 0;

    if FLaneList[nIdx].Assign.BowlerList[nBIdx].PaymentType = 0 then
      nPayResult := 0;
  end;
  FLaneList[nIdx].Assign.BowlerCnt := rBowlerInfoList.Count;
  FLaneList[nIdx].Assign.PaymentResult := nPayResult;

  FreeAndNil(rBowlerInfoList);

  for I := FLaneList[nIdx].Assign.BowlerCnt + 1 to 6 do
  begin
    FLaneList[nIdx].Assign.BowlerList[I].BowlerSeq := I;
    FLaneList[nIdx].Assign.BowlerList[I].BowlerId := '';
    FLaneList[nIdx].Assign.BowlerList[I].BowlerNm := '';
    FLaneList[nIdx].Assign.BowlerList[I].GameCnt := 0;
    //FLaneList[nIdx].Assign.BowlerList[I].ProductCd := '';
    //FLaneList[nIdx].Assign.BowlerList[I].ProductNm := '';
    FLaneList[nIdx].Assign.BowlerList[I].PaymentType := 0;
    FLaneList[nIdx].Assign.BowlerList[I].GameFin := 0;
  end;

end;

function TLane.SetLaneAssignCancel(ALaneNo: Integer; AType: Integer; AAssignNo: String): String;
var
  nIdx, nCompetitionSeq, i: Integer;
  sLog, sResult: String;
  jSendObj: TJSONObject;
  bResult, bCompetitionEnd, bInit: Boolean;
  nCompetitionIdx: Integer;
begin
  result := 'Fail';

  if AType = 0 then // 레인초기화 명령시
  begin
    nIdx := GetLaneInfoIndex(ALaneNo);
    if nIdx = -1 then
    begin
      result := '진행중인 게임이 없습니다.';
      Exit;
    end;
  end
  else
  begin
    nIdx := GetAssignNoIndex(AAssignNo);
    if nIdx = -1 then
    begin
      //예약대기, 배정된 타석이 아님
      bResult := Global.ReserveList.DelAssignReserve(AAssignNo);

      if bResult = False then
      begin
        sResult := Global.DM.chgAssignEndDt(AAssignNo, '7');
        sLog := 'DB 배정취소 - AssignNo: ' + AAssignNo + ' / ' + sResult;
        Global.Log.LogReserveWrite(sLog);

        if sResult <> 'Success' then
        begin
          result := sResult;
          Exit;
        end;

      end;

      Result := 'Success';
      Exit;
    end;
  end;

  // DB/Erp저장: 종료시간
  Global.DM.chgAssignEndDt(FLaneList[nIdx].Assign.AssignNo, '7');
  FLaneList[nIdx].Assign.EndDatetime := formatdatetime('YYYYMMDDhhnnss', Now);

  //기존 배정 정리필요
  FLaneList[nIdx].Assign.AssignDt := '';
  FLaneList[nIdx].Assign.AssignSeq := 0;
  FLaneList[nIdx].Assign.AssignNo := '';

  //제어
  Global.Com.SendInitLane(IntToStr(FLaneList[nIdx].LaneNo));
  Global.Com.SendPinSetterOnOff(FLaneList[nIdx].LaneNo, 'N');
  //Global.Com.SendLaneTemp(IntToStr(FLaneList[nIdx].LaneNo));
  //Global.Com.SendLaneStatus(FLaneList[nIdx].LaneNo);

  jSendObj := TJSONObject.Create;
  jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
  jSendObj.AddPair(TJSONPair.Create('assign_no', AAssignNo));
  jSendObj.AddPair(TJSONPair.Create('lane_no', FLaneList[nIdx].Assign.LaneNo));
  jSendObj.AddPair(TJSONPair.Create('assign_status', '3'));
  jSendObj.AddPair(TJSONPair.Create('status_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', now)));
  jSendObj.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

  RegAssignEpr(AAssignNo, 'E002_chgLaneAssign', jSendObj.ToString);
  FreeAndNil(jSendObj);

  sLog := '배정취소 - No: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + AAssignNo;
  Global.Log.LogReserveWrite(sLog);

  if FLaneList[nIdx].Assign.CompetitionSeq > 0 then //취소되는 게임이 대회이면
  begin
    nCompetitionSeq := FLaneList[nIdx].Assign.CompetitionSeq;
    FLaneList[nIdx].Assign.CompetitionSeq := 0;
    FLaneList[nIdx].Assign.CompetitionLane := 0;
    ChkCompetition(nCompetitionSeq);
  end;

  Result := 'Success';
end;

function TLane.SetLaneAssignCheckOut(AAssignNo, AUserId: String): String;
var
  nIdx, nCompetitionSeq, i: Integer;
  sLog: String;

  jSend, jSendItem: TJSONObject;
  jSendArr: TJsonArray;

  bMember: Boolean;
  nGameCnt, nGameMin: Integer;

  jRecv: TJSONObject;
  sRecvResult, sRecvResultCd, sRecvResultMsg: String;

  jTemp, jTempItem: TJSONObject;
  jTempArr: TJSONArray;
begin
  result := '';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    Result := '현재 진행중인 배정이 없습니다';
    Exit;
  end;

  bMember := False;
  for i := 1 to FLaneList[nIdx].Assign.BowlerCnt do
  begin
    if (FLaneList[nIdx].Assign.BowlerList[i].MemberNo <> '') and (FLaneList[nIdx].Assign.BowlerList[i].MembershipSeq > 0) then
    begin
      bMember := True;
      Break;
    end;
  end;

  //Erp 전송-가능여부 체크
  if bMember = True then
  begin
    try

      jSend := TJSONObject.Create;
      jSend.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
      jSend.AddPair(TJSONPair.Create('assign_no', FLaneList[nIdx].Assign.AssignNo));
      jSend.AddPair(TJSONPair.Create('user_id', AUserId));

      jSendArr := TJSONArray.Create;
      jSend.AddPair(TJSONPair.Create('bowlerList', jSendArr));

      for i := 1 to FLaneList[nIdx].Assign.BowlerCnt do
      begin
        if FLaneList[nIdx].Assign.BowlerList[i].MemberNo = '' then
          Continue;

        if FLaneList[nIdx].Assign.BowlerList[i].MembershipSeq = 0 then
          Continue;

        jSendItem := TJSONObject.Create;
        jSendItem.AddPair( TJSONPair.Create( 'bowler_seq', FLaneList[nIdx].Assign.BowlerList[i].BowlerSeq) );

        if FLaneList[nIdx].Assign.GameDiv = 1 then
        begin
          jSendItem.AddPair( TJSONPair.Create( 'frame', FLaneList[nIdx].Game.BowlerList[i].FrameTo) );
          jSendItem.AddPair( TJSONPair.Create( 'membership_seq', FLaneList[nIdx].Assign.BowlerList[i].MembershipSeq) );
          jSendItem.AddPair( TJSONPair.Create( 'membership_use_cnt', FLaneList[nIdx].Assign.BowlerList[i].GameFin) );
          jSendItem.AddPair( TJSONPair.Create( 'membership_use_min', 0) );
        end
        else
        begin
          jSendItem.AddPair( TJSONPair.Create( 'frame', 0) );
          jSendItem.AddPair( TJSONPair.Create( 'membership_seq', FLaneList[nIdx].Assign.BowlerList[i].MembershipSeq) );
          jSendItem.AddPair( TJSONPair.Create( 'membership_use_cnt', 0) );

          nGameMin := FLaneList[nIdx].Assign.BowlerList[i].GameMin - FLaneList[nIdx].Game.BowlerList[i].ResidualGameTime;
          jSendItem.AddPair( TJSONPair.Create( 'membership_use_min', nGameMin) );
        end;

        jSendArr.Add(jSendItem);
      end;

      sLog := 'E106_checkoutBowlerLangAssign : ' + jSend.ToString;
      Global.Log.LogErpApiWrite(sLog);

      //Erp 전문전송- 레인베정정보 등록
      sRecvResult := Global.Api.SetErpApiNoData(jSend.ToString, 'E106_checkoutBowlerLangAssign', Global.Config.ApiUrl, Global.Config.Token);

      sLog := 'E106_checkoutBowlerLangAssign : ' + sRecvResult;
      Global.Log.LogErpApiWrite(sLog);

      if sRecvResult <> 'Success' then
      begin
        sLog := jSend.ToString;
        Global.Log.LogErpApiWrite(sLog);

        Result := sRecvResult;
        Exit;
      end;

    finally
      FreeAndNil(jSend);
    end;
  end;

  sLog := '체크아웃 - No: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo;
  Global.Log.LogReserveWrite(sLog);

  // DB/Erp저장: 종료시간
  if FLaneList[nIdx].Assign.PaymentResult = 1 then
  begin
    FLaneList[nIdx].Assign.AssignStatus := 6; //결제완료
    Global.DM.chgAssignEndDt(FLaneList[nIdx].Assign.AssignNo, '6');
    FLaneList[nIdx].Assign.EndDatetime := formatdatetime('YYYYMMDDhhnnss', Now);

    FLaneList[nIdx].Assign.AssignDt := '';
    FLaneList[nIdx].Assign.AssignSeq := 0;
    FLaneList[nIdx].Assign.AssignNo := '';
  end
  else
  begin
    FLaneList[nIdx].Assign.AssignStatus := 5;
    Global.DM.chgAssignEndDt(FLaneList[nIdx].Assign.AssignNo, '5');
  end;

  //제어
  Global.Com.SendInitLane(IntToStr(FLaneList[nIdx].LaneNo));
  Global.Com.SendPinSetterOnOff(FLaneList[nIdx].LaneNo, 'N');
  //Global.Com.SendLaneTemp(IntToStr(FLaneList[nIdx].LaneNo));

  //ERP 전송용
  try
    jTemp := TJSONObject.Create;
    jTemp.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
    jTemp.AddPair(TJSONPair.Create('assign_no', FLaneList[nIdx].Assign.AssignNo));
    jTemp.AddPair(TJSONPair.Create('lane_no', FLaneList[nIdx].Assign.LaneNo));
    jTemp.AddPair(TJSONPair.Create('assign_status', '2'));
    jTemp.AddPair(TJSONPair.Create('status_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', now)));
    jTemp.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

    RegAssignEpr(FLaneList[nIdx].Assign.AssignNo, 'E002_chgLaneAssign', jTemp.ToString);
  finally
    FreeAndNil(jTemp);
  end;

  if FLaneList[nIdx].Assign.CompetitionSeq > 0 then //취소되는 게임이 대회이면
  begin
    nCompetitionSeq := FLaneList[nIdx].Assign.CompetitionSeq;
    FLaneList[nIdx].Assign.CompetitionSeq := 0;
    FLaneList[nIdx].Assign.CompetitionLane := 0;
    ChkCompetition(nCompetitionSeq);
  end;

  //응답 전문
  try
    jTempArr := TJSONArray.Create;
    jTemp := TJSONObject.Create;
    jTemp.AddPair(TJSONPair.Create('result_cd', '0000'));
    jTemp.AddPair(TJSONPair.Create('result_msg', 'Success'));
    jTemp.AddPair(TJSONPair.Create('result_data', jTempArr));

    for i := 1 to FLaneList[nIdx].Assign.BowlerCnt do
    begin
      jTempItem := TJSONObject.Create;
      jTempItem.AddPair( TJSONPair.Create( 'assign_no', FLaneList[nIdx].Assign.AssignNo) );
      jTempItem.AddPair( TJSONPair.Create( 'bowler_seq', FLaneList[nIdx].Assign.BowlerList[i].BowlerSeq) );
      jTempItem.AddPair( TJSONPair.Create( 'bowler_id', FLaneList[nIdx].Assign.BowlerList[i].BowlerId) );
      jTempItem.AddPair( TJSONPair.Create( 'payment_type', FLaneList[nIdx].Assign.BowlerList[i].PaymentType) );

      if FLaneList[nIdx].Assign.BowlerList[i].PaymentType = 1 then  //0:후불, 1:선불
      begin
        jTempItem.AddPair( TJSONPair.Create( 'game_cnt', 0) );
        jTempItem.AddPair( TJSONPair.Create( 'game_min', 0) );
      end
      else
      begin
        if FLaneList[nIdx].Assign.GameDiv = 1 then
        begin
          nGameCnt := FLaneList[nIdx].Assign.BowlerList[i].GameFin;

          //차감인정프레임 이상이면 완료수 증가
          if FLaneList[nIdx].Game.BowlerList[i].FrameTo >= Global.Store.MinusFrame then
          begin
            nGameCnt := nGameCnt + 1;
            FLaneList[nIdx].Assign.BowlerList[i].GameFin := nGameCnt;

            Global.DM.UpdateAssignBowlerEndCnt(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq,
                                              FLaneList[nIdx].Assign.BowlerList[i].BowlerSeq, FLaneList[nIdx].Assign.BowlerList[i].GameFin);
          end;

          jTempItem.AddPair( TJSONPair.Create( 'game_cnt', nGameCnt) );
          jTempItem.AddPair( TJSONPair.Create( 'game_min', 0) );
        end
        else
        begin
          nGameMin := FLaneList[nIdx].Assign.BowlerList[i].GameMin - FLaneList[nIdx].Game.BowlerList[i].ResidualGameTime;
          jTempItem.AddPair( TJSONPair.Create( 'game_cnt', 0) );
          jTempItem.AddPair( TJSONPair.Create( 'game_min', nGameMin) );
        end;
      end;

      jTempArr.Add(jTempItem);
    end;

    Result := jTemp.ToString;
  finally
    FreeAndNil(jTemp);
  end;

end;


function TLane.GetLaneInfo(ALaneNo: Integer): TLaneInfo;
var
  i: Integer;
begin
  for i := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[i].LaneNo = ALaneNo then
    begin
      Result := FLaneList[i];
      Break;
    end;
  end;
end;


function TLane.GetLaneInfoToIndex(AIdx: Integer): TLaneInfo;
begin
  //메인화면용, 예약관리
  Result := FLaneList[AIdx];
end;

function TLane.GetLaneInfoIndex(ALaneNo: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;

  for i := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[i].LaneNo = ALaneNo then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TLane.GetLaneInfoCtlYn(ALaneNo: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[i].LaneNo = ALaneNo then
    begin
      Result := FLaneList[i].CtlYn;
      Break;
    end;
  end;
end;

function TLane.GetAssignNoIndex(AAssignNo: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[I].Assign.AssignNo = AAssignNo then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TLane.GetAssignNoBowlerIndex(AIdx: Integer; ABowlerId: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 1 to FLaneList[AIdx].Assign.BowlerCnt do
  begin
    if FLaneList[AIdx].Assign.BowlerList[I].BowlerId = ABowlerId then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TLane.GetAssignNoCompetitionSeq(AAssignNo: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[I].Assign.AssignNo = AAssignNo then
    begin
      Result := FLaneList[I].Assign.CompetitionSeq;
      Break;
    end;
  end;
end;

function TLane.GetCompetitionSeqBowlerIndex(ASeq: Integer; ABowlerId: String; var ALaneIdx: Integer): Integer;
var
  I, J: Integer;
  bIdx: Boolean;
begin
  Result := -1;
  for I := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[I].Assign.CompetitionSeq <> ASeq then
      Continue;

    bIdx := False;
    for J := 1 to FLaneList[I].Assign.BowlerCnt do
    begin
      if FLaneList[I].Assign.BowlerList[J].BowlerId = ABowlerId then
      begin
        ALaneIdx := I;
        Result := J;
        bIdx := True;
        Break;
      end;
    end;

    if bIdx = True then
      Break;
  end;
end;

function TLane.GetPossibleReserveDatetime(ALaneNo: Integer): String;
var
  nIdx: Integer;
  sNowDt, sEndDt, sReserveEndDt, sResult: String;
begin
  nIdx := GetLaneInfoIndex(ALaneNo);
  if FLaneList[nIdx].Assign.AssignNo = '' then
    sEndDt := ''
  else
    sEndDt := FLaneList[nIdx].Assign.ExpectdEndDate;
  sReserveEndDt := Global.ReserveList.GetReserveLastTime(ALaneNo);
  sNowDt := FormatDateTime('YYYYMMDDhhnn00', Now);

  if sReserveEndDt = EmptyStr then
  begin
    if (sEndDt = EmptyStr) or (sEndDt < sNowDt) then
      sResult := sNowDt
    else
      sResult := sEndDt;
  end
  else
    sResult := sReserveEndDt;

  Result := sResult;
end;

function TLane.SetLaneHold(ALaneNo: String; rHoldInfo: THoldInfo): Boolean;
var
  nIdx, nLaneNo: Integer;
begin
  Result := False;

  nLaneNo := StrToInt(ALaneNo);
  nIdx := GetLaneInfoIndex(nLaneNo);
  FLaneList[nIdx].HoldUse := rHoldInfo.HoldUse;
  FLaneList[nIdx].HoldUser := rHoldInfo.HoldUser;

  Result := True;
end;

function TLane.GetLaneHold(ALaneNo: String): THoldInfo;
var
  nLaneNo, nIdx: Integer;
  rHoldInfo: THoldInfo;
begin
  nLaneNo := StrToInt(ALaneNo);
  nIdx := GetLaneInfoIndex(nLaneNo);

  rHoldInfo.HoldUse := FLaneList[nIdx].HoldUse;
  rHoldInfo.HoldUser := FLaneList[nIdx].HoldUser;

  Result := rHoldInfo;
end;

function TLane.SetLaneLock(ALaneNo, AStatus: String): Boolean;
var
  nLaneNo, nIdx: Integer;
begin
  Result := False;

  nLaneNo := StrToInt(ALaneNo);
  nIdx := GetLaneInfoIndex(nLaneNo);

  FLaneList[nIdx].UseStatus := AStatus;

  Result := True;
end;

procedure TLane.LaneReserveChk;
var
  nIdx, nTeeboxNo: Integer;
  sLog: String;
  dtEnd: TDateTime;
  nMin: Integer;
begin
  try

    for nIdx := 0 to LaneCnt - 1 do
    begin

      if FLaneList[nIdx].Assign.AssignNo <> '' then
      begin
        {
        if FLaneList[nIdx].Assign.AssignStatus = 1 then // 대기중
          Continue;

        if FLaneList[nIdx].Assign.AssignStatus = 3 then // 진행중
          Continue;

        if FLaneList[nIdx].Assign.AssignStatus = 5 then // 미결제
          Continue;
        }
        Continue;
      end;

      if FLaneList[nIdx].Assign.EndDatetime <> '' then //종료
      begin
        //배정 간격조절
        dtEnd := DateStrToDateTime(FLaneList[nIdx].Assign.EndDatetime);
        nMin := MinutesBetween(dtEnd, Now);

        if nMin >= Global.Config.PrepareMin then
        begin
          FLaneList[nIdx].Assign.EndDatetime := '';
        end;

        Continue;
      end;

      Global.ReserveList.ReserveListChk(FLaneList[nIdx].LaneNo);

    end;

  except
    on e: Exception do
    begin
       sLog := 'LaneReserveChk Exception : ' + e.Message;
       Global.Log.LogReserveWrite(sLog);
    end;
  end;
end;

procedure TLane.LaneStatusChk_tm;
var
  nIdx, nBIdx, nAIdx: Integer;
  bResult: Boolean;
  sStr: String;
  I: Integer;
  sSql: String;
  bGameEnd: Boolean;
  bGameCntChg: Boolean;
  sGamendStatus3: String;
  bOdd: Boolean; //홀수
  //bLeague: Boolean; //리그- 2레인모두사용
begin

  for nIdx := 0 to LaneCnt - 1 do
  begin
    if FLaneList[nIdx].UseStatus = '9' then
      Continue;

    if FLaneList[nIdx].Assign.CompetitionSeq > 0 then //대회
      Continue;

    if FLaneList[nIdx].Assign.AssignNo = '' then
    begin
      { 보류 2024-02-20 게임취소시 데이타 처리 시간으로 인해 상태 갱신 요청을 할수가 없음. 이로인해 무한 명령 발생.
      if (FLaneList[nIdx].GameCom.Status = 'A8') or (FLaneList[nIdx].GameCom.Status = 'A0') then //버전이 다른경우 있음
      begin
        //제어
        Global.Com.SendInitLane(IntToStr(FLaneList[nIdx].LaneNo));
        Global.Com.SendPinSetterOnOff(FLaneList[nIdx].LaneNo, 'N');
        Global.Com.SendLaneTemp(IntToStr(FLaneList[nIdx].LaneNo));
        //Global.Com.SendLaneStatus(FLaneList[nIdx].LaneNo);

        sStr := '미배정 게임 종료 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm;
        Global.Log.LogReserveWrite(sStr);
      end;
      }
      Continue;
    end;

    if FLaneList[nIdx].Assign.AssignStatus = 5 then
      Continue;

    bOdd := odd(FLaneList[nIdx].LaneNo); //홀수 여부

    if FLaneList[nIdx].GameCom.Status = 'E8' then //연습모드
    begin

    end

    else if FLaneList[nIdx].GameCom.Status = '08' then //장비 초기화 상태??
    begin
      Global.Com.SendMoniterOnOff(IntToStr(FLaneList[nIdx].LaneNo), 'Y'); //모니터 제어
    end

    else if (FLaneList[nIdx].GameCom.Status = '88') or (FLaneList[nIdx].GameCom.Status = '80') or (FLaneList[nIdx].GameCom.Status = 'C8') then //종료-게임 전체볼러 모두 종료, 버전이 다른경우 있음
    begin
      if FLaneList[nIdx].GameCom.BowlerCnt = 0 then
      begin

        if FLaneList[nIdx].Assign.StartDatetime = '' then
        begin
          LaneStatusChk_tm_start(nIdx);
        end
        else
        begin
          //핀세터가 초기화? 등으로 데이터가 없을경우 -> 이동처럼 데이터 등록 필요
          {
          if FLaneList[nIdx].Game.BowlerList[1].ToCnt > 0 then
          begin
            Global.Com.SendLaneAssignMove(FLaneList[nIdx].LaneNo, FLaneList[nIdx].LaneNo);
            Global.Com.SendPinSetterOnOff(FLaneList[nIdx].LaneNo, 'Y'); //레인 장비 켜기
          end;
          }
        end;

        Continue;
      end
      else // 볼러 있으면
      begin

        bGameCntChg := False;
        for nBIdx := 1 to FLaneList[nIdx].Assign.BowlerCnt do
        begin
          // 볼러 게임완료수 저장
          if FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt < FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt then
          begin
            if FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt + 1 < FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt then
            begin
              sStr := 'GameCnt error 88 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                      IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt) + ' -> ' + IntToStr(FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt);
              Global.Log.LogReserveWrite(sStr);
              Continue;
            end;

            sStr := 'GameCnt : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                    IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt) + ' -> ' + IntToStr(FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt);
            Global.Log.LogReserveWrite(sStr);

            FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt := FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt;
            //FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt;
            FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin + 1;

            sStr := 'GameFin : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                  IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin);
            Global.Log.LogReserveWrite(sStr);

            Global.DM.UpdateAssignBowlerEndCnt(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq,
                                              FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin);

            bGameCntChg := True;
          end;
        end;

        // 홀수:'02', 짝수:'22' - // 볼러의 투가 끝난경우
        if FLaneList[nIdx].Assign.LeagueYn = 'Y' then
        begin

          if (bOdd = True) then
          begin
            if (FLaneList[nIdx + 1].Assign.AssignNo = '') then
            begin
              if bGameCntChg = True then
              begin
                if LaneStatusChk_tm_end_check(nIdx) = True then
                  Continue;
              end;

              sStr := 'League Next: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' - 짝수레인: 빈레인';
              Global.Log.LogReserveWrite(sStr);
              Global.Com.SendLaneGameNext(FLaneList[nIdx].LaneNo, FLaneList[nIdx].Assign.LeagueYn);
            end;
          end
          else
          begin
            if (FLaneList[nIdx - 1].Assign.AssignNo = '') then
            begin
              if bGameCntChg = True then
              begin
                if LaneStatusChk_tm_end_check(nIdx) = True then
                  Continue;
              end;

              sStr := 'League Next: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' - 홀수레인: 빈레인';
              Global.Log.LogReserveWrite(sStr);
              Global.Com.SendLaneGameNext(FLaneList[nIdx - 1].LaneNo, FLaneList[nIdx].Assign.LeagueYn);
            end
            else
            begin
              if bGameCntChg = True then
              begin
                if LaneStatusChk_tm_end_League_check(nIdx) = True then
                  Continue;
              end;

              if (FLaneList[nIdx - 1].GameCom.Status = '88') then
              begin
                sStr := 'League Next: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' - 홀수레인: 종료';
                Global.Log.LogReserveWrite(sStr);
                Global.Com.SendLaneGameNext(FLaneList[nIdx - 1].LaneNo, FLaneList[nIdx].Assign.LeagueYn);
              end;
            end;
          end;

        end
        else //if FLaneList[nIdx].Assign.LeagueYn = 'N' then
        begin
          if (bGameCntChg = True) or (FLaneList[nIdx].Assign.GameDiv = 2) then
          begin
            if LaneStatusChk_tm_end_check(nIdx) = True then
              Continue;
          end;
          { 상태변경 제외처리 2024-03-11
          //종료가 아니면
          // Status1 상태값 - 홀수레인:C0=지금 투할 게이머, 80=대기, 00=종료, 02 = 일시정지(강제) / 짝수레인: E0=투할사람 A0=대기사람, 20=종료, 22 = 일시정지(강제)
          // Status3 상태값 - 게임볼러 완료 - 후불: $00 -> $80 / 선불: $20 -> $A0 -> 변경처리
          bGameEnd := True;
          for I := 1 to FLaneList[nIdx].Assign.BowlerCnt do
          begin
            if (FLaneList[nIdx].Assign.GameDiv = 1) and (FLaneList[nIdx].Assign.BowlerList[I].GameCnt > 0) then
              sGamendStatus3 := 'A0' //게임제(게임수지정)
            else
              sGamendStatus3 := '80'; //게임제(무제한), 시간제

            if FLaneList[nIdx].GameCom.BowlerList[I].Status3 <> sGamendStatus3 then
            begin
              //사용자 수만큼 보냄 3명이면 3번-> 01-1번사용자, 02-2번사용자
              if sGamendStatus3 = 'A0' then
                Global.Com.SendLaneGameEnd(FLaneList[nIdx].LaneNo, I, '1')
              else
                Global.Com.SendLaneGameEnd(FLaneList[nIdx].LaneNo, I, '0');
              bGameEnd := False;
            end;
          end;

          if bGameEnd = False then //모든 볼러 종료가 완료된 상태가 아니면
            Continue;

          //모든 사용자 A0 전송(선불), 80 일반 ->  상태 요청해서 모두 A0 확인 후  next
          }
          Global.Com.SendLaneGameNext(FLaneList[nIdx].LaneNo, FLaneList[nIdx].Assign.LeagueYn);
          sStr := '88 Next - No: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' -> ' + IntToStr(FLaneList[nIdx].Assign.GameSeq);
          Global.Log.LogReserveWrite(sStr);
        end;

      end;

    end
    else if (FLaneList[nIdx].GameCom.Status = 'A8') or (FLaneList[nIdx].GameCom.Status = 'A0') then //버전이 다른경우 있음
    begin

      if FLaneList[nIdx].Assign.StartDatetime = '' then
      begin
        // 이런경우???

      end;

      if (FLaneList[nIdx].NextYn = True) then //게임중 Next 요청시
      begin
        Global.Com.SendLaneGameNext(FLaneList[nIdx].LaneNo, FLaneList[nIdx].Assign.LeagueYn);
        FLaneList[nIdx].NextYn := False;
        sStr := 'A8 Next - No: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' -> ' + IntToStr(FLaneList[nIdx].Assign.GameSeq);
        Global.Log.LogReserveWrite(sStr);
        Continue;
      end;

      bGameCntChg := False;
      for nBIdx := 1 to FLaneList[nIdx].Assign.BowlerCnt do
      begin
        // 볼러 게임완료수 저장
        if FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt < FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt then
        begin
          if FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt + 1 < FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt then
          begin
            sStr := 'GameCnt error A8 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                    IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt) + ' -> ' + IntToStr(FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt);
            Global.Log.LogReserveWrite(sStr);
            Continue;
          end;

          sStr := 'GameCnt A8 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                  IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt) + ' -> ' + IntToStr(FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt);
          Global.Log.LogReserveWrite(sStr);

          FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt := FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt;
          //FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt;
          FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin + 1;

          sStr := 'GameFin A8 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                  IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin);
          Global.Log.LogReserveWrite(sStr);

          Global.DM.UpdateAssignBowlerEndCnt(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq,
                                            FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin);

          bGameCntChg := True;
        end
        else //게임수는 미변경, 투 가 0으로 변경 -> next로 판단
        begin
          if (FLaneList[nIdx].Game.BowlerList[nBIdx].ToCnt > 0) and (FLaneList[nIdx].GameCom.BowlerList[nBIdx].ToCnt = 0) and (FLaneList[nIdx].GameCom.BowlerList[nBIdx].FrameTo >= Global.Store.MinusFrame) then
          begin
            FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin + 1;

            sStr := 'GameFin A8 ToCnt : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                    IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin);
            Global.Log.LogReserveWrite(sStr);

            Global.DM.UpdateAssignBowlerEndCnt(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq,
                                              FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin);

            bGameCntChg := True;
          end;
        end;
      end;

      if (FLaneList[nIdx].Assign.GameSeq = 0) or (bGameCntChg = True) then //이전상태가 종료인 경우, 게임수 변경시
      begin

        FLaneList[nIdx].Assign.GameSeq := FLaneList[nIdx].Assign.GameSeq + 1;
        //DB 저장 - 배정정보
        bResult := Global.DM.UpdateAssignCnt(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq, FLaneList[nIdx].Assign.GameSeq);

        //DB 저장 - 볼러정보
        if FLaneList[nIdx].Assign.GameSeq = 1 then
        begin
          for I := 1 to FLaneList[nIdx].Assign.BowlerCnt do
          begin
            if FLaneList[nIdx].Assign.BowlerList[I].BowlerId <> '' then
            begin
              Global.DM.UpdateAssignBowlerStart(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq,
                                                FLaneList[nIdx].Assign.BowlerList[I].BowlerSeq, FLaneList[nIdx].Assign.GameSeq);
            end;
          end;
        end;

        // DB 저장 - 게임
        sSql := RegGameSql(nIdx);
        bResult := Global.DM.InsertGame(sSql);

        if FLaneList[nIdx].Assign.GameSeq = 1 then
          sStr := 'game start - No: '
        else
          sStr := 'Fin Next - No: ';
        sStr := sStr + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' -> Seq: ' + IntToStr(FLaneList[nIdx].Assign.GameSeq);
        Global.Log.LogReserveWrite(sStr);
      end;
    end;

    //게임 데이터 확인 및 저장
    LaneStatusChk_tm_game(nIdx);
  end;

  Sleep(10);
end;

function TLane.LaneStatusChk_tm_start(AIdx: Integer): Boolean;
var
  I: Integer;
  sStr: String;
  jSendObj: TJSONObject;
  nIdx: Integer;
begin
  Result := False;

  //동시제어
  if FLaneList[AIdx].Assign.CommonCtl > 0 then
  begin
    if odd(FLaneList[AIdx].LaneNo) = True then // 홀수면 true, 짝수면 false
      nIdx := GetLaneInfoIndex(FLaneList[AIdx].LaneNo + 1)
    else
      nIdx := GetLaneInfoIndex(FLaneList[AIdx].LaneNo - 1);

    if FLaneList[AIdx].Assign.CommonCtl <> FLaneList[nIdx].Assign.CommonCtl then
      Exit;
  end;

  FLaneList[AIdx].Assign.StartDatetime := formatdatetime('YYYYMMDDhhnn00', Now);
  sStr := '배정구동 : ' + IntToStr(FLaneList[AIdx].LaneNo) + ' / ' + FLaneList[AIdx].LaneNm + ' / ' + FLaneList[AIdx].Assign.AssignNo;
  Global.Log.LogReserveWrite(sStr);

  // DB 저장 - 배정시작시간
  FLaneList[AIdx].Assign.AssignStatus := 3;
  Global.DM.chgAssignStartDt(FLaneList[AIdx].Assign.AssignNo, FLaneList[AIdx].Assign.StartDatetime, Global.Config.TerminalId);

  //배정위해 제어배열에 등록
  Global.Com.SendLaneAssign(FLaneList[AIdx].LaneNo);

  // 제어 - 게임수/시간 지정
  for I := 1 to FLaneList[AIdx].Assign.BowlerCnt do
  begin
    if FLaneList[AIdx].Assign.BowlerList[I].BowlerId = '' then
      Continue;

    if FLaneList[AIdx].Assign.GameDiv = 1 then
    begin
      if (FLaneList[AIdx].Assign.BowlerList[I].GameCnt > 0) then
      begin
        Global.Com.SendLaneAssignBowlerGameCnt(FLaneList[AIdx].LaneNo, I, FLaneList[AIdx].Assign.BowlerList[I].GameCnt);
        Global.Com.SendLaneAssignBowlerGameCntSet(FLaneList[AIdx].LaneNo, I);
      end;
    end
    else if FLaneList[AIdx].Assign.GameDiv = 2 then
    begin
      if (FLaneList[AIdx].Assign.BowlerList[I].GameMin > 0) then
      begin
        Global.Com.SendLaneAssignBowlerGameTime(FLaneList[AIdx].LaneNo, I, FLaneList[AIdx].Assign.BowlerList[I].GameMin);
      end;
    end;
  end;

  // 제어 - 리그
  if (FLaneList[AIdx].Assign.AssignRootDiv = 'K') and (FLaneList[AIdx].Assign.LeagueYn = 'Y') then
  begin
    if odd(FLaneList[AIdx].LaneNo) = False then // 홀수면 true, 짝수면 false
      Global.Com.SendLaneAssignGameLeague(FLaneList[AIdx].LaneNo - 1, 'Y');
  end;

  // Erp 전송용 생성
  jSendObj := TJSONObject.Create;
  jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
  jSendObj.AddPair(TJSONPair.Create('assign_no', FLaneList[AIdx].Assign.AssignNo));
  jSendObj.AddPair(TJSONPair.Create('lane_no', FLaneList[AIdx].Assign.LaneNo));
  jSendObj.AddPair(TJSONPair.Create('assign_status', '1'));
  jSendObj.AddPair(TJSONPair.Create('status_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', now)));
  jSendObj.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

  RegAssignEpr(FLaneList[AIdx].Assign.AssignNo, 'E002_chgLaneAssign', jSendObj.ToString);
  FreeAndNil(jSendObj);

  Result := True;
end;


function TLane.LaneStatusChk_tm_end_check(AIdx: Integer): Boolean;
var
  i: Integer;
  bGameEnd: Boolean;
begin

  bGameEnd := True;

  if (FLaneList[AIdx].Assign.GameDiv = 1) then //게임제
  begin
    for i := 1 to FLaneList[AIdx].Assign.BowlerCnt do
    begin
      if FLaneList[AIdx].Assign.BowlerList[i].GameCnt = 0 then //오픈게임
      begin
        bGameEnd := False;
        Break;
      end;

      if (FLaneList[AIdx].Assign.BowlerList[i].GameCnt > FLaneList[AIdx].GameCom.BowlerList[i].EndGameCnt) and
         (FLaneList[AIdx].GameCom.BowlerList[i].ResidualGameCnt > 0) then //남은 게임수
      begin
        bGameEnd := False;
        Break;
      end;
    end;
  end
  else if (FLaneList[AIdx].Assign.GameDiv = 2) then //시간제
  begin
    for i := 1 to FLaneList[AIdx].Assign.BowlerCnt do
    begin
      if (FLaneList[AIdx].GameCom.BowlerList[i].ResidualGameTime > 0) then //남은 시간
      begin
        bGameEnd := False;
        Break;
      end;
    end;
  end;

  if bGameEnd = False then
  begin
    Result := False;
    Exit;
  end;

  LaneStatusChk_tm_end(AIdx);

  Result := True;
end;

function TLane.LaneStatusChk_tm_end_League_check(AIdx: Integer): Boolean;
var
  i, nIdx1, nIdx2: Integer;
  bGameEnd: Boolean;
begin
  nIdx1 := AIdx - 1;
  nIdx2 := AIdx;

  bGameEnd := True;

  if (FLaneList[nIdx1].Assign.GameDiv = 1) then //게임제
  begin
    for i := 1 to FLaneList[nIdx1].Assign.BowlerCnt do
    begin
      if FLaneList[nIdx1].Assign.BowlerList[i].GameCnt = 0 then //오픈게임
      begin
        bGameEnd := False;
        Break;
      end;

      if (FLaneList[nIdx1].Assign.BowlerList[i].GameCnt > FLaneList[nIdx1].GameCom.BowlerList[i].EndGameCnt) and
         (FLaneList[nIdx1].GameCom.BowlerList[i].ResidualGameCnt > 0) then //남은 게임수
      begin
        bGameEnd := False;
        Break;
      end;
    end;
  end
  else if (FLaneList[nIdx1].Assign.GameDiv = 2) then //시간제
  begin
    for i := 1 to FLaneList[nIdx1].Assign.BowlerCnt do
    begin
      if (FLaneList[nIdx1].GameCom.BowlerList[i].ResidualGameTime > 0) then //남은 시간
      begin
        bGameEnd := False;
        Break;
      end;
    end;
  end;

  if bGameEnd = False then
  begin
    Result := False;
    Exit;
  end;

  if (FLaneList[nIdx2].Assign.GameDiv = 1) then //게임제
  begin
    for i := 1 to FLaneList[nIdx2].Assign.BowlerCnt do
    begin
      if FLaneList[nIdx2].Assign.BowlerList[i].GameCnt = 0 then //오픈게임
      begin
        bGameEnd := False;
        Break;
      end;

      if (FLaneList[nIdx2].Assign.BowlerList[i].GameCnt > FLaneList[nIdx2].GameCom.BowlerList[i].EndGameCnt) and
         (FLaneList[nIdx2].GameCom.BowlerList[i].ResidualGameCnt > 0) then //남은 게임수
      begin
        bGameEnd := False;
        Break;
      end;
    end;
  end
  else if (FLaneList[nIdx2].Assign.GameDiv = 2) then //시간제
  begin
    for i := 1 to FLaneList[nIdx2].Assign.BowlerCnt do
    begin
      if (FLaneList[nIdx2].GameCom.BowlerList[i].ResidualGameTime > 0) then //남은 시간
      begin
        bGameEnd := False;
        Break;
      end;
    end;
  end;

  if bGameEnd = False then
  begin
    Result := False;
    Exit;
  end;

  LaneStatusChk_tm_end(nIdx1);
  LaneStatusChk_tm_end(nIdx2);

  Result := True;
end;

function TLane.LaneStatusChk_tm_end(AIdx: Integer): Boolean;
var
  sStr, sAssignNo: String;
  jSendObj: TJSONObject;
begin
  Result := False;

  {
  상태정보 확인후 "완료된 게임수" == "지정게임수" 또는 "남은 게임수" == 0 이면 게임 종료절차
   0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 09 00 04 01 03 09 F4 (게임정보 클리어)
   0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 11 00 02 03 FC (장치 끄기)
   0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 0B 00 02 05 FA (명령어 분석 필요)
  }
  sStr := '배정종료 - No: ' + IntToStr(FLaneList[AIdx].LaneNo) + ' / Nm: ' + FLaneList[AIdx].LaneNm + ' / ' + FLaneList[AIdx].Assign.AssignNo;
  Global.Log.LogReserveWrite(sStr);

  sAssignNo := FLaneList[AIdx].Assign.AssignNo;

  // DB/Erp저장: 종료시간
  if FLaneList[AIdx].Assign.PaymentResult = 1 then
  begin
    FLaneList[AIdx].Assign.AssignStatus := 6; //결제완료
    Global.DM.chgAssignEndDt(FLaneList[AIdx].Assign.AssignNo, '6');
    FLaneList[AIdx].Assign.EndDatetime := formatdatetime('YYYYMMDDhhnnss', Now);

    FLaneList[AIdx].Assign.AssignDt := '';
    FLaneList[AIdx].Assign.AssignSeq := 0;
    FLaneList[AIdx].Assign.AssignNo := '';
  end
  else
  begin
    FLaneList[AIdx].Assign.AssignStatus := 5;
    Global.DM.chgAssignEndDt(FLaneList[AIdx].Assign.AssignNo, '5');
  end;

  //제어
  Global.Com.SendInitLane(IntToStr(FLaneList[AIdx].LaneNo));
  Global.Com.SendPinSetterOnOff(FLaneList[AIdx].LaneNo, 'N');
  //Global.Com.SendLaneTemp(IntToStr(FLaneList[AIdx].LaneNo));

  jSendObj := TJSONObject.Create;
  jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
  jSendObj.AddPair(TJSONPair.Create('assign_no', sAssignNo));
  jSendObj.AddPair(TJSONPair.Create('lane_no', FLaneList[AIdx].Assign.LaneNo));
  jSendObj.AddPair(TJSONPair.Create('assign_status', '2'));
  jSendObj.AddPair(TJSONPair.Create('status_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', now)));
  jSendObj.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

  RegAssignEpr(FLaneList[AIdx].Assign.AssignNo, 'E002_chgLaneAssign', jSendObj.ToString);
  FreeAndNil(jSendObj);

  Result := True;
end;

function TLane.LaneStatusChk_tm_game(AIdx: Integer): Boolean;
var
  nBIdx, nAIdx: Integer;
  bChg: Boolean;
  I: Integer;
begin

  if FLaneList[AIdx].GameCom.Receive = False then //데이터 미응답
    Exit;

  if (FLaneList[AIdx].Assign.BowlerCnt <> FLaneList[AIdx].GameCom.BowlerCnt) then
  begin
    //global.Log.LogReserveWrite(FLaneList[AIdx].LaneNm + ': ' + IntToStr(FLaneList[AIdx].Assign.BowlerCnt) + ' <> ' + IntToStr(FLaneList[AIdx].GameCom.BowlerCnt));
    Exit;
  end;

  FLaneList[AIdx].Game.Status := FLaneList[AIdx].GameCom.Status;
  FLaneList[AIdx].Game.BowlerCnt := FLaneList[AIdx].GameCom.BowlerCnt;

  FLaneList[AIdx].Game.b12 := FLaneList[AIdx].GameCom.b12;
  FLaneList[AIdx].Game.League := FLaneList[AIdx].GameCom.League;
  FLaneList[AIdx].Game.GameType := FLaneList[AIdx].GameCom.GameType;
  FLaneList[AIdx].Game.b19 := FLaneList[AIdx].GameCom.b19;
  FLaneList[AIdx].Game.b20 := FLaneList[AIdx].GameCom.b20;
  FLaneList[AIdx].Game.b26 := FLaneList[AIdx].GameCom.b26;

  //프레임, 점수 변경된 사항 저장이므로 새로운 게임일 경우 먼저 등록해야 함.
  for nBIdx := 1 to FLaneList[AIdx].Game.BowlerCnt do
  begin
    if FLaneList[AIdx].Assign.BowlerList[nBIdx].BowlerId = '' then
      Continue;

    if FLaneList[AIdx].Assign.BowlerList[nBIdx].BowlerNm <> FLaneList[AIdx].Game.BowlerList[nBIdx].BowlerNm then
      FLaneList[AIdx].Game.BowlerList[nBIdx].BowlerNm := FLaneList[AIdx].Assign.BowlerList[nBIdx].BowlerNm;

    FLaneList[AIdx].Game.BowlerList[nBIdx].BowlerSeq := FLaneList[AIdx].GameCom.BowlerList[nBIdx].BowlerSeq;

    bChg := False;
    for nAIdx := 1 to 21 do
    begin
      if FLaneList[AIdx].game.BowlerList[nBIdx].FramePin[nAIdx] <> FLaneList[AIdx].GameCom.BowlerList[nBIdx].FramePin[nAIdx] then
      begin
        bChg := True;
        FLaneList[AIdx].game.BowlerList[nBIdx].FramePin[nAIdx] := FLaneList[AIdx].GameCom.BowlerList[nBIdx].FramePin[nAIdx];
      end;
    end;

    for nAIdx := 1 to 10 do
    begin
      if FLaneList[AIdx].game.BowlerList[nBIdx].FrameScore[nAIdx] <> FLaneList[AIdx].GameCom.BowlerList[nBIdx].FrameScore[nAIdx] then
      begin
        bChg := True;
        FLaneList[AIdx].game.BowlerList[nBIdx].FrameScore[nAIdx] := FLaneList[AIdx].GameCom.BowlerList[nBIdx].FrameScore[nAIdx];
      end;
    end;

    FLaneList[AIdx].Game.BowlerList[nBIdx].TotalScore := FLaneList[AIdx].GameCom.BowlerList[nBIdx].TotalScore;
    FLaneList[AIdx].Game.BowlerList[nBIdx].ToCnt := FLaneList[AIdx].GameCom.BowlerList[nBIdx].ToCnt;
    FLaneList[AIdx].Game.BowlerList[nBIdx].FrameTo := FLaneList[AIdx].GameCom.BowlerList[nBIdx].FrameTo;
    FLaneList[AIdx].Game.BowlerList[nBIdx].EndGameCnt := FLaneList[AIdx].GameCom.BowlerList[nBIdx].EndGameCnt;

    if FLaneList[AIdx].Game.BowlerList[nBIdx].Status1 <> FLaneList[AIdx].GameCom.BowlerList[nBIdx].Status1 then
      bChg := True;

    FLaneList[AIdx].Game.BowlerList[nBIdx].Status1 := FLaneList[AIdx].GameCom.BowlerList[nBIdx].Status1;

    FLaneList[AIdx].Game.BowlerList[nBIdx].ResidualGameTime := FLaneList[AIdx].GameCom.BowlerList[nBIdx].ResidualGameTime;
    FLaneList[AIdx].Game.BowlerList[nBIdx].ResidualGameCnt := FLaneList[AIdx].GameCom.BowlerList[nBIdx].ResidualGameCnt;
    FLaneList[AIdx].Game.BowlerList[nBIdx].Status3 := FLaneList[AIdx].GameCom.BowlerList[nBIdx].Status3;

    // DB저장
    if bChg = True then
    begin
      Global.DM.chgGameBowlerStatus(FLaneList[AIdx].LaneNo, FLaneList[AIdx].Assign.AssignNo, IntToStr(FLaneList[AIdx].Assign.GameSeq),
                                    FLaneList[AIdx].Assign.BowlerList[nBIdx].BowlerId, FLaneList[AIdx].Assign.BowlerList[nBIdx].BowlerNm, FLaneList[AIdx].game.BowlerList[nBIdx]);

      //if FLaneList[AIdx].game.BowlerList[nBIdx].FrameScore[10] > 0 then
        LaneGameScoreErp(AIdx, nBIdx);
    end;

  end;

  //global.Log.LogReserveWrite(FLaneList[AIdx].LaneNm + ': game change');

  FLaneList[AIdx].GameCom.Receive := False; //데이터 미응답 - 대기상태
end;

procedure TLane.LaneStatusChk_tm_Competition;
var
  nIdx, nBIdx, nAIdx: Integer;
  bResult: Boolean;
  sStr: String;
  I, j: Integer;
  sSql: String;
  sGameEnd: String;
  bGameCntChg: Boolean;
  sGamendStatus3: String;
  bOdd: Boolean; //홀수
  //bLeague: Boolean; //리그- 2레인모두사용
  nCompetitionLane, nCompetitionIdx, nCompetitionBCnt: Integer;
  nSec: Integer;
begin

  for nIdx := 0 to LaneCnt - 1 do
  begin
    if FLaneList[nIdx].Assign.CompetitionSeq = 0 then //대회
      Continue;

    bOdd := odd(FLaneList[nIdx].LaneNo); //홀수 여부

    if FLaneList[nIdx].GameCom.Status = '08' then //장비 초기화 상태??
    begin
      Global.Com.SendMoniterOnOff(IntToStr(FLaneList[nIdx].LaneNo), 'Y'); //모니터 제어
      Continue;
    end;

    if FLaneList[nIdx].GameCom.Status = 'E8' then //연습모드
      Continue;

    if (FLaneList[nIdx].GameCom.Status = '88') or (FLaneList[nIdx].GameCom.Status = 'C8') then //종료-게임 전체볼러 모두 종료
    begin
      if FLaneList[nIdx].GameCom.BowlerCnt = 0 then
      begin

        if FLaneList[nIdx].Assign.StartDatetime = '' then
        begin
          LaneStatusChk_tm_Competition_start(nIdx);
        end
        else
        begin
          //핀세터가 초기화? 등으로 데이터가 없을경우 -> 이동처럼 데이터 등록 필요
          {
          if FLaneList[nIdx].Game.BowlerList[1].ToCnt > 0 then
          begin
            Global.Com.SendLaneAssignMove(FLaneList[nIdx].LaneNo, FLaneList[nIdx].LaneNo);
            Global.Com.SendPinSetterOnOff(FLaneList[nIdx].LaneNo, 'Y'); //레인 장비 켜기
          end;
          }
        end;

        Continue;
      end;

    end
    else if (FLaneList[nIdx].GameCom.Status = 'A8') then
    begin
      {
      if (FLaneList[nIdx].NextYn = True) then //게임중 Next 요청시
      begin
        Global.Com.SendLaneGameNext(FLaneList[nIdx].LaneNo, FLaneList[nIdx].Assign.LeagueYn);
        FLaneList[nIdx].NextYn := False;
        sStr := 'A8 Next - No: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' -> ' + IntToStr(FLaneList[nIdx].Assign.GameSeq);
        Global.Log.LogReserveWrite(sStr);
        Continue;
      end;
      }
      bGameCntChg := False;
      for nBIdx := 1 to FLaneList[nIdx].Assign.BowlerCnt do
      begin
        // 볼러 게임완료수 저장
        if FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt < FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt then
        begin
          if FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt + 1 < FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt then
          begin
            sStr := 'Competition GameCnt error A8 : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                    IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt) + ' -> ' + IntToStr(FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt);
            Global.Log.LogReserveWrite(sStr);
            Continue;
          end;

          sStr := 'Competition GameCnt : ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' / ' +
                  IntToStr(FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq) + ' / ' + IntToStr(FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt) + ' -> ' + IntToStr(FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt);
          Global.Log.LogReserveWrite(sStr);

          FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt := FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt;
          FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := FLaneList[nIdx].GameCom.BowlerList[nBIdx].EndGameCnt;

          Global.DM.UpdateAssignBowlerEndCnt(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq,
                                            FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin);

          bGameCntChg := True;
        end;
      end;

      if (FLaneList[nIdx].Assign.GameSeq = 0) or (bGameCntChg = True) then //이전상태가 종료인 경우, 게임수 변경시
      begin

        FLaneList[nIdx].Assign.GameSeq := FLaneList[nIdx].Assign.GameSeq + 1;
        //DB 저장 - 배정정보
        bResult := Global.DM.UpdateAssignCnt(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq, FLaneList[nIdx].Assign.GameSeq);

        //DB 저장 - 볼러정보
        if FLaneList[nIdx].Assign.GameSeq = 1 then
        begin
          for I := 1 to FLaneList[nIdx].Assign.BowlerCnt do
          begin
            if FLaneList[nIdx].Assign.BowlerList[I].BowlerId <> '' then
            begin
              Global.DM.UpdateAssignBowlerStart(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq,
                                                FLaneList[nIdx].Assign.BowlerList[I].BowlerSeq, FLaneList[nIdx].Assign.GameSeq);
            end;
          end;
        end
        else
        begin
          //nCompetitionLane := FLaneList[nIdx].Assign.LaneNo;
          nCompetitionLane := FLaneList[nIdx].LaneNo;
          nCompetitionIdx := GetCompetitionIndex(FLaneList[nIdx].Assign.CompetitionSeq);

          if nCompetitionIdx > -1 then
          begin
            for i := 0 to FCompetitionList[nCompetitionIdx].Cnt - 1 do
            begin
              if FCompetitionList[nCompetitionIdx].List[i].CompetitionLane = nCompetitionLane then
              begin
                sStr := 'Competition lane change - No: ' + inttostr(nCompetitionLane) + ' - ' + FLaneList[nIdx].Assign.AssignNo + '->' + FCompetitionList[nCompetitionIdx].List[i].AssignNo;

                FLaneList[nIdx].Assign.AssignSeq := FCompetitionList[nCompetitionIdx].List[i].AssignSeq;
                FLaneList[nIdx].Assign.AssignNo := FCompetitionList[nCompetitionIdx].List[i].AssignNo;

                nCompetitionBCnt := FLaneList[nIdx].Assign.BowlerCnt;
                for j := 1 to 6 do
                begin
                  if j <= FCompetitionList[nCompetitionIdx].List[i].BowlerCnt then
                  begin
                    FLaneList[nIdx].Assign.BowlerList[j].BowlerId := FCompetitionList[nCompetitionIdx].List[i].BowlerList[j].BowlerId;
                    FLaneList[nIdx].Assign.BowlerList[j].BowlerNm := FCompetitionList[nCompetitionIdx].List[i].BowlerList[j].BowlerNm;
                    FLaneList[nIdx].Assign.BowlerList[j].Handy := FCompetitionList[nCompetitionIdx].List[i].BowlerList[j].Handy;
                    FLaneList[nIdx].Assign.BowlerList[j].ParticipantsSeq := FCompetitionList[nCompetitionIdx].List[i].BowlerList[j].ParticipantsSeq;
                  end
                  else
                  begin
                    FLaneList[nIdx].Assign.BowlerList[j].BowlerId := '';
                    FLaneList[nIdx].Assign.BowlerList[j].BowlerNm := '';
                    FLaneList[nIdx].Assign.BowlerList[j].Handy := 0;
                    FLaneList[nIdx].Assign.BowlerList[j].ParticipantsSeq := 0;
                  end;
                end;
                FLaneList[nIdx].Assign.BowlerCnt := FCompetitionList[nCompetitionIdx].List[i].BowlerCnt;

                bResult := Global.DM.UpdateAssignLane(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq, FLaneList[nIdx].Assign.LaneNo);
                Global.Log.LogReserveWrite(sStr);

                //chy test - 볼러정보 변경 이동방식으로 적용 - 보류
                //Global.Com.SendLaneAssignMove(FLaneList[nIdx].LaneNo, FLaneList[nIdx].LaneNo);
                if nCompetitionBCnt < FLaneList[nIdx].Assign.BowlerCnt then
                  Global.Com.SendLaneCompetitionBowlerAdd(FLaneList[nIdx].LaneNo, FLaneList[nIdx].Assign.BowlerCnt)
                else
                  Global.Com.SendLaneCompetitionBowlerAdd(FLaneList[nIdx].LaneNo, nCompetitionBCnt); //볼러 추가

                //Global.Com.SendLaneAssignBowlerFin(FLaneList[nIdx].LaneNo); //추가 완료?

                for j := 1 to FLaneList[nIdx].Assign.BowlerCnt do
                begin
                  Global.Com.SendLaneAssignGameHandy(FLaneList[nIdx].LaneNo, j, FLaneList[nIdx].Assign.BowlerList[j].Handy);
                end;

                Break;
              end;
            end;
          end;

        end;

        // DB 저장 - 게임
        sSql := RegGameSql(nIdx);
        bResult := Global.DM.InsertGame(sSql);

        if FLaneList[nIdx].Assign.GameSeq = 1 then
          sStr := 'Competition game start - No: '
        else
          sStr := 'Competition Fin Next - No: ';
        sStr := sStr + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo + ' -> Seq: ' + IntToStr(FLaneList[nIdx].Assign.GameSeq);
        Global.Log.LogReserveWrite(sStr);

      end;
    end;

    //게임 데이터 확인 및 저장
    LaneStatusChk_tm_game(nIdx);
  end;

  for i := 0 to Length(FCompetitionList) - 1 do
  begin
    if FCompetitionList[i].CompetitionSeq = 0 then //대회
      Continue;

    sGameEnd := '0';
    for j := 0 to LaneCnt - 1 do
    begin
      if FLaneList[j].Assign.CompetitionSeq = 0 then //대회
        Continue;

      if FLaneList[j].Assign.CompetitionSeq <> FCompetitionList[i].CompetitionSeq then //대회
        Continue;

      if FLaneList[j].Assign.StartDatetime = '' then
      begin
        sGameEnd := '1';
        Break;
      end;

      if FLaneList[j].GameCom.Status <> '88' then //종료-게임 전체볼러 모두 종료
      begin
        sGameEnd := '1';
        Break;
      end;
    end;

    if sGameEnd = '0' then //사용자가 등록되어 있고 모두 종료시
    begin

      nIdx := GetLaneInfoIndex(FCompetitionList[i].StartLane);
      if (FCompetitionList[i].List[0].GameSeq + 1) <> FLaneList[nIdx].Assign.GameSeq then
        Exit;

      // 대회 종료
      if FLaneList[nIdx].Assign.GameSeq = FLaneList[nIdx].Assign.BowlerList[1].GameCnt then
      begin
        if FCompetitionList[i].CompetitionEnd = False then
        begin
          FCompetitionList[i].CompetitionEnd := True;
          FCompetitionList[i].CompetitionEndDate := Now;

          sStr := '대회종료 - No: ' + IntToStr(FCompetitionList[i].CompetitionSeq);
          Global.Log.LogReserveWrite(sStr);
        end;
      end
      else
      begin
        LaneStatusChk_tm_Competition_LaneMove(i);

        for j := 0 to LaneCnt - 1 do
        begin
          if FLaneList[j].Assign.CompetitionSeq = 0 then //대회
            Continue;

          if FLaneList[j].Assign.CompetitionSeq <> FCompetitionList[i].CompetitionSeq then //대회
            Continue;

          if FLaneList[j].Assign.LeagueYn = 'N' then
          begin
            Global.Com.SendLaneGameNext(FLaneList[j].LaneNo, 'N');
          end
          else
          begin
            bOdd := odd(FLaneList[j].LaneNo); //홀수 여부
            if (bOdd = False) then
            begin
              Global.Com.SendLaneGameNext(FLaneList[j - 1].LaneNo, FLaneList[j - 1].Assign.LeagueYn);
              Global.Log.LogReserveWrite('Competition next / League : ' + inttostr(FLaneList[j - 1].LaneNo));
            end
            else
            Global.Log.LogReserveWrite('Competition next pass / League : ' + inttostr(FLaneList[j].LaneNo));
          end;

        end;
      end;

    end;

    if FCompetitionList[i].CompetitionEnd = True then
    begin

      nSec := SecondsBetween(FCompetitionList[i].CompetitionEndDate, Now);
      if nSec > 30 then
      begin
        for j := 0 to LaneCnt - 1 do
        begin
          if FLaneList[j].Assign.CompetitionSeq = 0 then //대회
            Continue;

          if FLaneList[j].Assign.CompetitionSeq <> FCompetitionList[i].CompetitionSeq then //대회
            Continue;

          if FLaneList[j].Assign.AssignStatus = 5 then
            Continue;

          LaneStatusChk_tm_end(j);
        end;
      end;
    end;

  end;

  Sleep(10);
end;


function TLane.LaneStatusChk_tm_Competition_start(AIdx: Integer): Boolean;
var
  I: Integer;
  sStr: String;
  jSendObj: TJSONObject;
begin
  Result := False;

  FLaneList[AIdx].Assign.StartDatetime := formatdatetime('YYYYMMDDhhnn00', Now);
  sStr := '배정구동 : ' + IntToStr(FLaneList[AIdx].LaneNo) + ' / ' + FLaneList[AIdx].LaneNm + ' / ' + FLaneList[AIdx].Assign.AssignNo;
  Global.Log.LogReserveWrite(sStr);

  // DB 저장 - 배정시작시간
  FLaneList[AIdx].Assign.AssignStatus := 3;
  Global.DM.chgAssignStartDt(FLaneList[AIdx].Assign.AssignNo, FLaneList[AIdx].Assign.StartDatetime, Global.Config.TerminalId);

  //배정위해 제어배열에 등록
  Global.Com.SendLaneAssign_Competition(FLaneList[AIdx].LaneNo, FLaneList[AIdx].Assign.LeagueYn, FLaneList[AIdx].Assign.TrainMin);

  // Erp 전송용 생성
  jSendObj := TJSONObject.Create;
  jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
  jSendObj.AddPair(TJSONPair.Create('assign_no', FLaneList[AIdx].Assign.AssignNo));
  jSendObj.AddPair(TJSONPair.Create('lane_no', FLaneList[AIdx].Assign.LaneNo));
  jSendObj.AddPair(TJSONPair.Create('assign_status', '1'));
  jSendObj.AddPair(TJSONPair.Create('status_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', now)));
  jSendObj.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

  RegAssignEpr(FLaneList[AIdx].Assign.AssignNo, 'E002_chgLaneAssign', jSendObj.ToString);
  FreeAndNil(jSendObj);

  Result := True;
end;

function TLane.LaneStatusChk_tm_Competition_LaneMove(AIdx: Integer): Boolean;
var
  I, j, nCompetitionLane: Integer;
  bOdd: Boolean;
  sStr: String;
begin
  Result := False;

  sStr := 'Competition_LaneMove - CompetitionSeq : ' + IntToStr(FCompetitionList[AIdx].CompetitionSeq);
  Global.Log.LogReserveWrite(sStr);

  for I := 0 to FCompetitionList[AIdx].Cnt - 1 do
  begin
    //G:일반이동, B:크로스이동좌우, 크로스이동X : X
    nCompetitionLane := FCompetitionList[AIdx].List[I].CompetitionLane;

    if FCompetitionList[AIdx].MoveMethod = 'G' then
    begin
    sStr := 'G';
    Global.Log.LogReserveWrite(sStr);

      for j := 0 to FCompetitionList[AIdx].LaneMoveCnt - 1 do
      begin
        inc(nCompetitionLane);

        if FCompetitionList[AIdx].EndLane < nCompetitionLane then
          nCompetitionLane := FCompetitionList[AIdx].StartLane;
      end;
    end
    else if FCompetitionList[AIdx].MoveMethod = 'B' then
    begin
      sStr := 'B';
    Global.Log.LogReserveWrite(sStr);

    bOdd := odd(nCompetitionLane); //홀수 여부
      for j := 0 to FCompetitionList[AIdx].LaneMoveCnt - 1 do
      begin

        if bOdd = True then
        begin
          dec(nCompetitionLane);

          if FCompetitionList[AIdx].StartLane > nCompetitionLane then
            nCompetitionLane := FCompetitionList[AIdx].EndLane;

          sStr := 'dec : ' + inttostr(nCompetitionLane);
          Global.Log.LogReserveWrite(sStr);
        end
        else
        begin
          inc(nCompetitionLane);

          if FCompetitionList[AIdx].EndLane < nCompetitionLane then
            nCompetitionLane := FCompetitionList[AIdx].StartLane;

          sStr := 'inc : '  + inttostr(nCompetitionLane);
          Global.Log.LogReserveWrite(sStr);
        end;
      end;
    end
    else if FCompetitionList[AIdx].MoveMethod = 'X' then
    begin
      sStr := 'X';
      Global.Log.LogReserveWrite(sStr);
      bOdd := odd(nCompetitionLane); //홀수 여부
      for j := 0 to FCompetitionList[AIdx].LaneMoveCnt - 1 do
      begin

        if bOdd = True then
        begin
          inc(nCompetitionLane);

          if FCompetitionList[AIdx].EndLane < nCompetitionLane then
            nCompetitionLane := FCompetitionList[AIdx].StartLane;
        end
        else
        begin
          dec(nCompetitionLane);

          if FCompetitionList[AIdx].StartLane > nCompetitionLane then
            nCompetitionLane := FCompetitionList[AIdx].EndLane;
        end;
      end;
    end;

    FCompetitionList[AIdx].List[I].CompetitionLane := nCompetitionLane;
    FCompetitionList[AIdx].List[I].GameSeq := FCompetitionList[AIdx].List[I].GameSeq + 1;

    sStr := FCompetitionList[AIdx].List[I].AssignNo + ' / ' +  IntToStr(FCompetitionList[AIdx].List[I].CompetitionLane) + ' / ' +
    IntToStr(FCompetitionList[AIdx].List[I].GameSeq);
    Global.Log.LogReserveWrite(sStr);
  end;

  Result := True;
end;

function TLane.RegGameSql(AIdx: Integer): String;
var
  sSql: String;
  i: Integer;
begin
  Result := '';

  sSql := '';
  for i := 1 to 6 do
  begin
    sSql := sSql +
            ' insert into tb_game ' +
            ' ( ' +
            ' store_cd, assign_dt, assign_seq, ' +
            //' game_seq, game_status, last_lane_no, bowler_seq, bowler_id, bowler_nm ' +
            ' game_seq, game_status, last_lane_no, bowler_seq ' +
            ' ) ' +
            ' values ' +
            ' ( ' +
            QuotedStr(Global.Config.StoreCd) + ', ' + QuotedStr(FLaneList[AIdx].Assign.AssignDt) + ' ,' + IntToStr(FLaneList[AIdx].Assign.AssignSeq) + ' ,' +
            IntToStr(FLaneList[AIdx].Assign.GameSeq) + ', ' + QuotedStr('0') + ' ,' + IntToStr(FLaneList[AIdx].Assign.LaneNo) + ' ,' +
            //IntToStr(FLaneList[AIdx].Assign.BowlerList[i].BowlerSeq) + ', ' + QuotedStr(FLaneList[AIdx].Assign.BowlerList[i].BowlerId) + ' ,' + QuotedStr(FLaneList[AIdx].Assign.BowlerList[i].BowlerNm) +
            IntToStr(FLaneList[AIdx].Assign.BowlerList[i].BowlerSeq) +
            ' ); ';
  end;

  Result := sSql;
end;

procedure TLane.LaneGameScoreErp(ALaneIdx, ABowlerIdx: Integer);
var
  jSendObj: TJSONObject;
  sFrame: String;
  i: Integer;
begin

  sFrame := '';
  for i := 1 to 21 do
  begin
    sFrame := sFrame + FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FramePin[i];
  end;

  jSendObj := TJSONObject.Create;
  jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
  jSendObj.AddPair(TJSONPair.Create('assign_no', FLaneList[ALaneIdx].Assign.AssignNo));
  jSendObj.AddPair(TJSONPair.Create('bowler_seq', FLaneList[ALaneIdx].Assign.BowlerList[ABowlerIdx].BowlerSeq));
  jSendObj.AddPair(TJSONPair.Create('bowler_id', FLaneList[ALaneIdx].Assign.BowlerList[ABowlerIdx].BowlerId));
  jSendObj.AddPair(TJSONPair.Create('bowler_nm', FLaneList[ALaneIdx].Assign.BowlerList[ABowlerIdx].BowlerNm));
  jSendObj.AddPair(TJSONPair.Create('member_no', FLaneList[ALaneIdx].Assign.BowlerList[ABowlerIdx].MemberNo));
  jSendObj.AddPair(TJSONPair.Create('game_seq', FLaneList[ALaneIdx].Assign.GameSeq));
  jSendObj.AddPair(TJSONPair.Create('participants_seq', FLaneList[ALaneIdx].Assign.BowlerList[ABowlerIdx].ParticipantsSeq));
  jSendObj.AddPair(TJSONPair.Create('score_data', sFrame));
  jSendObj.AddPair(TJSONPair.Create('frame1_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[1]));
  jSendObj.AddPair(TJSONPair.Create('frame2_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[2]));
  jSendObj.AddPair(TJSONPair.Create('frame3_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[3]));
  jSendObj.AddPair(TJSONPair.Create('frame4_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[4]));
  jSendObj.AddPair(TJSONPair.Create('frame5_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[5]));
  jSendObj.AddPair(TJSONPair.Create('frame6_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[6]));
  jSendObj.AddPair(TJSONPair.Create('frame7_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[7]));
  jSendObj.AddPair(TJSONPair.Create('frame8_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[8]));
  jSendObj.AddPair(TJSONPair.Create('frame9_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[9]));
  jSendObj.AddPair(TJSONPair.Create('frame10_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].FrameScore[10]));
  jSendObj.AddPair(TJSONPair.Create('total_score', FLaneList[ALaneIdx].Game.BowlerList[ABowlerIdx].TotalScore));

  jSendObj.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

  RegAssignEpr(FLaneList[ALaneIdx].Assign.AssignNo, 'E201_regGame', jSendObj.ToString);
  FreeAndNil(jSendObj);
end;

procedure TLane.SetLaneGameStatus(AGameStatus: TGameStatus); //통신데이타
var
  nIdx, i, j: Integer;
  nDiv: Integer;
  sLog: String;
begin
  try
    nIdx := GetLaneInfoIndex(AGameStatus.LaneNo);

    if nIdx = -1 then
      Exit;

    FLaneList[nIdx].GameCom.Receive := True; //데이터 응답받음

    FLaneList[nIdx].GameCom.Status := AGameStatus.Status;
    FLaneList[nIdx].GameCom.BowlerCnt := AGameStatus.BowlerCnt;

    FLaneList[nIdx].GameCom.b12 := AGameStatus.b12;
    FLaneList[nIdx].GameCom.League := AGameStatus.League;
    FLaneList[nIdx].GameCom.GameType := AGameStatus.GameType;
    FLaneList[nIdx].GameCom.b19 := AGameStatus.b19;
    FLaneList[nIdx].GameCom.b20 := AGameStatus.b20;
    FLaneList[nIdx].GameCom.b26 := AGameStatus.b26;

    if AGameStatus.BowlerCnt = 0 then
    begin
      for i := 1 to 6 do
      begin
        FLaneList[nIdx].GameCom.BowlerList[i].BowlerSeq := i;

        //게이머 정보 성: FDataArr[60]FDataArr[59], 이름1: FDataArr[62]FDataArr[61], 이름2: FDataArr[64]FDataArr[63]
        //sGameInfo := char(FGamerArr[6]) + char(FGamerArr[8]) + char(FGamerArr[10]);
        //ABowlerInfo.BowlerNm := sGameInfo;

        for j := 1 to 21 do
        begin
          FLaneList[nIdx].GameCom.BowlerList[i].FramePin[j] := '0';
        end;

        for j := 1 to 10 do
        begin
          FLaneList[nIdx].GameCom.BowlerList[i].FrameScore[j] := 0;
        end;

        FLaneList[nIdx].GameCom.BowlerList[i].TotalScore := 0;
        FLaneList[nIdx].GameCom.BowlerList[i].ToCnt := 0;
        FLaneList[nIdx].GameCom.BowlerList[i].FrameTo := 0;

        FLaneList[nIdx].GameCom.BowlerList[i].EndGameCnt := 0;
        //FLaneList[nIdx].GameCom.BowlerList[i].Status1 := AGameStatus.BowlerList[i].Status1;
        //FLaneList[nIdx].GameCom.BowlerList[i].ResidualGameTime := AGameStatus.BowlerList[i].ResidualGameTime;
        //FLaneList[nIdx].GameCom.BowlerList[i].ResidualGameCnt := AGameStatus.BowlerList[i].ResidualGameCnt;
        //FLaneList[nIdx].GameCom.BowlerList[i].Status3 := AGameStatus.BowlerList[i].Status3;
      end;

      Exit;
    end;

    for i := 1 to AGameStatus.BowlerCnt do
    begin
      FLaneList[nIdx].GameCom.BowlerList[i].BowlerSeq := i;

      //게이머 정보 성: FDataArr[60]FDataArr[59], 이름1: FDataArr[62]FDataArr[61], 이름2: FDataArr[64]FDataArr[63]
      //sGameInfo := char(FGamerArr[6]) + char(FGamerArr[8]) + char(FGamerArr[10]);
      //ABowlerInfo.BowlerNm := sGameInfo;

      for j := 1 to 21 do
      begin
        FLaneList[nIdx].GameCom.BowlerList[i].FramePin[j] := AGameStatus.BowlerList[i].FramePin[j];
      end;

      for j := 1 to 10 do
      begin
        FLaneList[nIdx].GameCom.BowlerList[i].FrameScore[j] := AGameStatus.BowlerList[i].FrameScore[j];
      end;

      FLaneList[nIdx].GameCom.BowlerList[i].TotalScore := AGameStatus.BowlerList[i].TotalScore;
      FLaneList[nIdx].GameCom.BowlerList[i].ToCnt := AGameStatus.BowlerList[i].ToCnt;

      nDiv := FLaneList[nIdx].GameCom.BowlerList[i].ToCnt div 2;
      if odd(FLaneList[nIdx].GameCom.BowlerList[i].ToCnt) = True then
      begin
        nDiv := nDiv + 1;
        if nDiv > 10 then
          nDiv := 10;
      end;

      FLaneList[nIdx].GameCom.BowlerList[i].FrameTo := nDiv;

      FLaneList[nIdx].GameCom.BowlerList[i].EndGameCnt := AGameStatus.BowlerList[i].EndGameCnt;
      FLaneList[nIdx].GameCom.BowlerList[i].Status1 := AGameStatus.BowlerList[i].Status1;
      FLaneList[nIdx].GameCom.BowlerList[i].ResidualGameTime := AGameStatus.BowlerList[i].ResidualGameTime;
      FLaneList[nIdx].GameCom.BowlerList[i].ResidualGameCnt := AGameStatus.BowlerList[i].ResidualGameCnt;
      FLaneList[nIdx].GameCom.BowlerList[i].Status3 := AGameStatus.BowlerList[i].Status3;
    end;
  except
    on e: Exception do
    begin
       sLog := 'SetLaneGameStatus Exception : ' + e.Message;
       Global.Log.LogComReadMon(sLog);
    end;
  end;
end;

function TLane.GetGameStatus(ALaneNo: Integer): TGameStatus;
var
  nIdx: Integer;
begin
  nIdx := GetLaneInfoIndex(ALaneNo);
  Result := FLaneList[nIdx].Game;
end;

function TLane.GetAssignInfo(ALaneNo: Integer): TAssignInfo;
var
  nIdx: Integer;
begin
  nIdx := GetLaneInfoIndex(ALaneNo);
  Result := FLaneList[nIdx].Assign;
end;

function TLane.GetGameBowlerStatus(ALaneNo, ABowlerIdx: Integer): TBowlerStatus;
var
  nIdx: Integer;
begin
  nIdx := GetLaneInfoIndex(ALaneNo);
  Result := FLaneList[nIdx].Game.BowlerList[ABowlerIdx];
end;

function TLane.SetAssignBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo; AUserId: String): String;
var
  nIdx, nBIdx: Integer;
  bResult: Boolean;
  sSql: string;

  jSend, jErpRvObj: TJSONObject;
  sResult, sLog, sErpRvResultCd, sErpRvResultMsg: String;

  nIdx1, nIdx2, nLaneNo: Integer;
  nResult: Integer;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    //예약목록 확인
    bResult := Global.ReserveList.GetReserveAssignNoChk(AAssignNo, nIdx1, nIdx2, nLaneNo);
    if bResult = False then
    begin
      Result := '해당 배정내역이 없습니다';
      Exit;
    end;

    //순번 확인용
    nResult := Global.DM.SelectAssignBowlerCnt(AAssignNo);
    begin
      if nResult = 0 then
      begin
        Result := '해당 배정에 등록된 볼러정보가 없습니다';
        Exit;
      end;
    end;

    ABowlerInfoTM.BowlerSeq := nResult + 1;
  end;

  {
  if FLaneList[nIdx].Assign.GameDiv = 1 then
  begin
    if ABowlerInfoTM.GameCnt = 0 then
    begin
      Result := '게임수를 확인해주세요.(게임수:0)';
      Exit;
    end;
  end
  else
  begin
    if ABowlerInfoTM.GameMin = 0 then
    begin
      Result := '게임시간을 확인해주세요.(게임시간:0)';
      Exit;
    end;
  end;
  }

  if ABowlerInfoTM.BowlerNm = '' then
    ABowlerInfoTM.BowlerNm := ChkBowlerNm(copy(AAssignNo, 11, 2));

  //Erp 전송-가능여부 체크
  try

    jSend := TJSONObject.Create;
    jSend.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
    jSend.AddPair(TJSONPair.Create('assign_no', AAssignNo));
    if nIdx = -1 then
      jSend.AddPair(TJSONPair.Create('bowler_seq', ABowlerInfoTM.BowlerSeq))
    else
      jSend.AddPair(TJSONPair.Create('bowler_seq', FLaneList[nIdx].Assign.BowlerCnt + 1));
    jSend.AddPair(TJSONPair.Create('bowler_id', ABowlerInfoTM.BowlerId));
    jSend.AddPair(TJSONPair.Create('bowler_nm', ABowlerInfoTM.BowlerNm));
    jSend.AddPair(TJSONPair.Create('member_no', ABowlerInfoTM.MemberNo));
    jSend.AddPair(TJSONPair.Create('game_cnt', ABowlerInfoTM.GameCnt));
    jSend.AddPair(TJSONPair.Create('game_min', ABowlerInfoTM.GameMin));
    jSend.AddPair(TJSONPair.Create('prod_cd', ABowlerInfoTM.ProductCd));
    jSend.AddPair(TJSONPair.Create('membership_seq', ABowlerInfoTM.MembershipSeq));
    jSend.AddPair(TJSONPair.Create('membership_use_cnt', ABowlerInfoTM.MembershipUseCnt));
    jSend.AddPair(TJSONPair.Create('membership_use_min', ABowlerInfoTM.MembershipUseMin));
    jSend.AddPair(TJSONPair.Create('user_id', AUserId));

    sLog := 'E101_regBowler : ' + jSend.ToString;
    Global.Log.LogErpApiWrite(sLog);

    //Erp 전문전송- 레인베정정보 등록
    sResult := Global.Api.SetErpApiNoData(jSend.ToString, 'E101_regBowler', Global.Config.ApiUrl, Global.Config.Token);

    sLog := 'E101_regBowler : ' + sResult;
    Global.Log.LogErpApiWrite(sLog);

    if sResult <> 'Success' then
    begin
      sLog := jSend.ToString;
      Global.Log.LogErpApiWrite(sLog);

      Result := sResult;
      Exit;
    end;

  finally
    FreeAndNil(jSend);
  end;

  if nIdx = -1 then
  begin
    //예약목록 확인
    bResult := Global.DM.InsertAssignBowler(nLaneNo, AAssignNo, ABowlerInfoTM);
    Result := 'Success';
    Exit;
  end;

  FLaneList[nIdx].Assign.BowlerCnt := FLaneList[nIdx].Assign.BowlerCnt + 1;
  nBIdx := FLaneList[nIdx].Assign.BowlerCnt;
  ABowlerInfoTM.BowlerSeq := nBIdx;
  ABowlerInfoTM.GameStart := FLaneList[nIdx].Assign.GameSeq;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerSeq := ABowlerInfoTM.BowlerSeq;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerId := ABowlerInfoTM.BowlerId;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerNm := ABowlerInfoTM.BowlerNm;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].MemberNo := ABowlerInfoTM.MemberNo;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameStart := ABowlerInfoTM.GameStart;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt := ABowlerInfoTM.GameCnt;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin := ABowlerInfoTM.GameMin;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameFin := ABowlerInfoTM.GameFin;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].FeeDiv := ABowlerInfoTM.FeeDiv;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].MembershipSeq := ABowlerInfoTM.MembershipSeq;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].ProductCd := ABowlerInfoTM.ProductCd;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].ProductNm := ABowlerInfoTM.ProductNm;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].PaymentType := ABowlerInfoTM.PaymentType;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].ShoesYn := ABowlerInfoTM.ShoesYn;

  //DB저장
  bResult := Global.DM.InsertAssignBowler(FLaneList[nIdx].LaneNo, AAssignNo, ABowlerInfoTM);

  SetExpectdEndDate(nIdx); //예상종료시간 계산

  //제어
  Global.Com.SendLaneAssignBowlerAdd(FLaneList[nIdx].LaneNo, ABowlerInfoTM.BowlerSeq);

  //게임수/시간 지정시 제어
  if FLaneList[nIdx].Assign.GameDiv = 1 then
  begin
    if (FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt > 0) then
    begin
      Global.Com.SendLaneAssignBowlerGameCnt(FLaneList[nIdx].LaneNo, nBIdx, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt);
      Global.Com.SendLaneAssignBowlerGameCntSet(FLaneList[nIdx].LaneNo, nBIdx);
    end;
  end
  else if FLaneList[nIdx].Assign.GameDiv = 2 then
  begin
    //if (FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin > 0) then
    begin
      //Global.Com.SendLaneAssignBowlerGameTime(FLaneList[nIdx].LaneNo, nBIdx, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin);
      Global.Com.SendLaneAssignBowlerGameTime(FLaneList[nIdx].LaneNo, nBIdx, FLaneList[nIdx].GameCom.BowlerList[1].ResidualGameTime);
    end;
  end;

  Result := 'Success';
end;

function TLane.SetAssignNext(ALaneNo: Integer): Boolean;
var
  nIdx: Integer;
begin
  Result := False;

  nIdx := GetLaneInfoIndex(ALaneNo);
  FLaneList[nIdx].NextYn := True;

  Result := True;
end;

function TLane.ChgAssignBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo; AUserId: String): String;
var
  nIdx, nBIdx: Integer;
  bResult: Boolean;
  I: Integer;

  jSend, jErpRvObj: TJSONObject;
  sResult, sLog, sErpRvResultCd, sErpRvResultMsg: String;

  nIdx1, nIdx2, nLaneNo: Integer;
  rBowlerInfoTM: TBowlerInfo;

  bErp: Boolean;

  bBowlerNm, bGameCnt, bGameMin: Boolean;
begin
  Result := 'Fail';

  bErp := True;
  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    //예약목록 확인
    bResult := Global.ReserveList.GetReserveAssignNoChk(AAssignNo, nIdx1, nIdx2, nLaneNo);
    if bResult = False then
    begin
      Result := '해당 배정내역이 없습니다';
      Exit;
    end;

    rBowlerInfoTM := Global.DM.SelectAssignBowler(AAssignNo, ABowlerInfoTM.BowlerId);
    nBIdx := rBowlerInfoTM.ParticipantsSeq;
    bErp := False;

    //변경여부 확인
    if (rBowlerInfoTM.BowlerNm <> ABowlerInfoTM.BowlerNm) or
       (rBowlerInfoTM.MemberNo <> ABowlerInfoTM.MemberNo) or
       (rBowlerInfoTM.GameCnt <> ABowlerInfoTM.GameCnt) or
       (rBowlerInfoTM.GameMin <> ABowlerInfoTM.GameMin) or
       (rBowlerInfoTM.MembershipSeq <> ABowlerInfoTM.MembershipSeq) or
       (rBowlerInfoTM.MembershipUseCnt <> ABowlerInfoTM.MembershipUseCnt) or
       (rBowlerInfoTM.MembershipUseMin <> ABowlerInfoTM.MembershipUseMin) or
       (rBowlerInfoTM.ProductCd <> ABowlerInfoTM.ProductCd) then
      bErp := True;

  end
  else
  begin
    nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerInfoTM.BowlerId);
    if nBIdx = -1 then
    begin
      Result := '해당 볼러정보가 없습니다.';
      Exit;
    end;
  end;

  //Erp 전송-가능여부 체크
  if bErp = True then
  begin
    try

      jSend := TJSONObject.Create;
      jSend.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
      jSend.AddPair(TJSONPair.Create('assign_no', AAssignNo));
      jSend.AddPair(TJSONPair.Create('bowler_seq', nBIdx));
      jSend.AddPair(TJSONPair.Create('bowler_id', ABowlerInfoTM.BowlerId));
      jSend.AddPair(TJSONPair.Create('bowler_nm', ABowlerInfoTM.BowlerNm));
      jSend.AddPair(TJSONPair.Create('member_no', ABowlerInfoTM.MemberNo));
      jSend.AddPair(TJSONPair.Create('game_cnt', ABowlerInfoTM.GameCnt));
      jSend.AddPair(TJSONPair.Create('game_min', ABowlerInfoTM.GameMin));
      jSend.AddPair(TJSONPair.Create('prod_cd', ABowlerInfoTM.ProductCd));
      jSend.AddPair(TJSONPair.Create('membership_seq', ABowlerInfoTM.MembershipSeq));
      jSend.AddPair(TJSONPair.Create('membership_use_cnt', ABowlerInfoTM.MembershipUseCnt));
      jSend.AddPair(TJSONPair.Create('membership_use_min', ABowlerInfoTM.MembershipUseMin));
      jSend.AddPair(TJSONPair.Create('user_id', AUserId));

      //Erp 전문전송- 레인베정정보 등록
      sLog := 'E102_chgBowler : ' + jSend.ToString;
      Global.Log.LogErpApiWrite(sLog);

      sResult := Global.Api.SetErpApiNoData(jSend.ToString, 'E102_chgBowler', Global.Config.ApiUrl, Global.Config.Token);

      sLog := 'E102_chgBowler : ' + sResult;
      Global.Log.LogErpApiWrite(sLog);

      if sResult <> 'Success' then
      begin
        sLog := jSend.ToString;
        Global.Log.LogErpApiWrite(sLog);

        Result := sResult;
        Exit;
      end;

    finally
      FreeAndNil(jSend);
    end;
  end;

  if nIdx = -1 then
  begin
    //예약목록 확인
    bResult := Global.DM.UpdateAssignBowler(AAssignNo, ABowlerInfoTM);

    Result := 'Success';
    Exit;
  end;

  bBowlerNm := False;
  bGameCnt := False;
  bGameMin := False;

  if FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerNm <> ABowlerInfoTM.BowlerNm then
    bBowlerNm := True;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].BowlerNm := ABowlerInfoTM.BowlerNm;

  FLaneList[nIdx].Assign.BowlerList[nBIdx].MemberNo := ABowlerInfoTM.MemberNo;

  if FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt <> ABowlerInfoTM.GameCnt then
    bGameCnt := True;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt := ABowlerInfoTM.GameCnt;

  if FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin <> ABowlerInfoTM.GameMin then
    bGameMin := True;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin := ABowlerInfoTM.GameMin;

  FLaneList[nIdx].Assign.BowlerList[nBIdx].FeeDiv := ABowlerInfoTM.FeeDiv;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].MembershipSeq := ABowlerInfoTM.MembershipSeq;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].MembershipUseCnt := ABowlerInfoTM.MembershipUseCnt;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].MembershipUseMin := ABowlerInfoTM.MembershipUseMin;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].ProductCd := ABowlerInfoTM.ProductCd;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].ProductNm := ABowlerInfoTM.ProductNm;

  if FLaneList[nIdx].Assign.BowlerList[nBIdx].ShoesYn <> ABowlerInfoTM.ShoesYn then
    bBowlerNm := True;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].ShoesYn := ABowlerInfoTM.ShoesYn;

  //DB저장
  bResult := Global.DM.UpdateAssignBowler(AAssignNo, ABowlerInfoTM);

  SetExpectdEndDate(nIdx); //예상종료시간 계산

  //제어
  if bBowlerNm = True then
  begin
    Global.Com.SendLaneAssignBowlerAdd(FLaneList[nIdx].LaneNo, nBIdx);
  end;

  if bGameCnt = True then
  begin
    Global.Com.SendLaneAssignBowlerGameCnt(FLaneList[nIdx].LaneNo, nBIdx, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt);
    Global.Com.SendLaneAssignBowlerGameCntSet(FLaneList[nIdx].LaneNo, nBIdx);
  end;

  if bGameMin = True then
  begin
    Global.Com.SendLaneAssignBowlerGameTime(FLaneList[nIdx].LaneNo, nBIdx, FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin);
  end;

  Result := 'Success';
end;

function TLane.ChgAssignMove(ALaneNo, ATargetLaneNo: String): String;
var
  nIdx, nTIdx: Integer;
  rAssign: TAssignInfo;
  sLog: String;

  // erp 요청
  jSend, jSendItem: TJSONObject;
  jSendArr: TJsonArray;
  sRecvResult: String;
begin
  Result := 'Fail';

  nIdx := GetLaneInfoIndex(StrToInt(ALaneNo));

  if (FLaneList[nIdx].Assign.AssignNo = '') or (FLaneList[nIdx].Assign.AssignStatus <> 3) then
  begin
    Result := '게임중인 배정이 없습니다.';
    Exit;
  end;

  nTIdx := GetLaneInfoIndex(StrToInt(ATargetLaneNo));

  if FLaneList[nTIdx].Assign.AssignNo <> '' then
  begin
    Result := '빈레인만 이동이 가능합니다.';
    Exit;
  end;

  try
    jSend := TJSONObject.Create;
    jSend.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
    jSend.AddPair(TJSONPair.Create('assign_no', FLaneList[nIdx].Assign.AssignNo));
    jSend.AddPair(TJSONPair.Create('lane_no', ALaneNo));
    jSend.AddPair(TJSONPair.Create('move_lane_no', ATargetLaneNo));
    jSend.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

    //Erp 전문전송
    sRecvResult := Global.Api.SetErpApiNoData(jSend.ToString, 'E004_moveLaneAssign', Global.Config.ApiUrl, Global.Config.Token);

    sLog := 'E004_moveLaneAssign: ' + sRecvResult;
    Global.Log.LogErpApiWrite(sLog);

    if sRecvResult <> 'Success' then
    begin
      sLog := jSend.ToString;
      Global.Log.LogErpApiWrite(sLog);

      Result := sRecvResult;
      Exit;
    end;

  finally
    FreeAndNil(jSend);
  end;

  FLaneList[nTIdx].Assign := FLaneList[nIdx].Assign;

  Global.DM.UpdateAssign(FLaneList[nTIdx].Assign.AssignDt, FLaneList[nTIdx].Assign.AssignSeq, StrToInt(ATargetLaneNo));
  Global.DM.UpdateGameLane(FLaneList[nTIdx].Assign.AssignDt, FLaneList[nTIdx].Assign.AssignSeq, FLaneList[nTIdx].Assign.GameSeq, StrToInt(ATargetLaneNo));

  //기존 배정 정리필요
  FLaneList[nIdx].Assign.AssignDt := '';
  FLaneList[nIdx].Assign.AssignSeq := 0;
  FLaneList[nIdx].Assign.AssignNo := '';

  Global.Com.SendLaneAssignMove(StrToInt(ALaneNo), StrToInt(ATargetLaneNo));

  Global.Com.SendInitLane(ALaneNo); //레인 초기화
  Global.Com.SendPinSetterOnOff(StrToInt(ATargetLaneNo), 'Y'); //레인 장비 켜기
  Global.Com.SendPinSetterOnOff(StrToInt(ALaneNo), 'N'); //레인 장비 끄기
  //Global.Com.SendLaneTemp(ALaneNo); // 레인 장비 끄기 ????

  Result := 'Success';
end;

function TLane.ChgAssignBowlerMove(AAssignNo, ABowlerId, ATargetLaneNo, AUserId, sTerminalId: String; var ATargetAssignNo, ATargetId: String): String;
var
  nIdx, nBIdx, nBIdxLast: Integer;
  nTIdx, nTBIdx, i: Integer;
  bResult: Boolean;
  sSql: String;
  dtPossibleReserveEndDt: TDateTime;

  //rBowlerInfoTM: TBowlerInfo;
  rHoldInfo: THoldInfo;
  nByte: Byte;
  sBowlerId, sNm: String;

  sLog: String;

  jSendObj, jSendItem: TJSONObject;
  jSendArr: TJSONArray;
  nUseSeqNoTemp: Integer;
  sAssignNoTemp: String;

  jRecvObj: TJSONObject;
  sRecvResult, sRecvResultCd, sRecvResultMsg: String;
begin

  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    Result := '게임진행중인 배정이 없습니다.';
    Exit;
  end;

  nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
  if nBIdx = -1 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  nTIdx := GetLaneInfoIndex(StrToInt(ATargetLaneNo));

  if FLaneList[nTIdx].Assign.AssignNo = '' then
  begin
    nUseSeqNoTemp := global.TcpServer.UseSeqNo + 1;
    sAssignNoTemp := global.TcpServer.UseSeqDate + StrZeroAdd(IntToStr(nUseSeqNoTemp), 4);

    try
      jSendObj := TJSONObject.Create;
      jSendArr := TJSONArray.Create;
      jSendObj.AddPair(TJSONPair.Create('laneAssignList', jSendArr));

      jSendItem := TJSONObject.Create;
      jSendItem.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
      jSendItem.AddPair(TJSONPair.Create('assign_no', sAssignNoTemp));
      jSendItem.AddPair(TJSONPair.Create('lane_no', FLaneList[nTIdx].LaneNo)); // 새로등록할 레인번호
      jSendItem.AddPair(TJSONPair.Create('game_div', FLaneList[nIdx].Assign.GameDiv));
      jSendItem.AddPair(TJSONPair.Create('game_type', FLaneList[nIdx].Assign.GameType));
      jSendItem.AddPair(TJSONPair.Create('reserve_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', now)));
      jSendItem.AddPair(TJSONPair.Create('user_id', AUserId));
      jSendItem.AddPair(TJSONPair.Create('terminal_id', sTerminalId));
      jSendArr.Add(jSendItem);

      //Erp 전문전송- 레인베정정보 등록
      sRecvResult := Global.Api.SetErpApiNoData(jSendObj.ToString, 'E001_regLaneAssign', Global.Config.ApiUrl, Global.Config.Token);

      sLog := 'E001_regLaneAssign (볼러이동): ' + sRecvResult;
      Global.Log.LogErpApiWrite(sLog);

      if sRecvResult <> 'Success' then
      begin
        sLog := jSendObj.ToString;
        Global.Log.LogErpApiWrite(sLog);

        Result := sRecvResult;
        Exit;
      end;

    finally
      FreeAndNil(jSendObj);
    end;
  end
  else
  begin
    sAssignNoTemp := FLaneList[nTIdx].Assign.AssignNo;
  end;

  if FLaneList[nTIdx].Assign.AssignNo = '' then
    nTBIdx := 1
  else
    nTBIdx := FLaneList[nTIdx].Assign.BowlerCnt + 1;

  try
    jSendObj := TJSONObject.Create;
    jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
    jSendObj.AddPair(TJSONPair.Create('assign_no', AAssignNo));
    jSendObj.AddPair(TJSONPair.Create('bowler_seq', IntToStr(nBIdx)));
    jSendObj.AddPair(TJSONPair.Create('chg_bowler_seq', nTBIdx));
    jSendObj.AddPair(TJSONPair.Create('move_assign_no', sAssignNoTemp));
    jSendObj.AddPair(TJSONPair.Create('user_id', AUserId));

    //Erp 전문전송- 볼러이동
    sRecvResult := Global.Api.SetErpApiNoData(jSendObj.ToString, 'E105_moveBowlerLangAssign', Global.Config.ApiUrl, Global.Config.Token);

    sLog := 'E105_moveBowlerLangAssign : ' + sRecvResult;
    Global.Log.LogErpApiWrite(sLog);

    if sRecvResult <> 'Success' then
    begin
      sLog := jSendObj.ToString;
      Global.Log.LogErpApiWrite(sLog);

      Result := sRecvResult;
      Exit;
    end;

  finally
    FreeAndNil(jSendObj);
  end;

  // erp 등록이 정상처리 되면
  if FLaneList[nTIdx].Assign.AssignNo = '' then
  begin

    //기존배정정보와 동일하게 처리
    FLaneList[nTIdx].Assign := FLaneList[nIdx].Assign;
    FLaneList[nTIdx].Assign.BowlerList[1] := FLaneList[nIdx].Assign.BowlerList[nBIdx];
    FLaneList[nTIdx].Assign.BowlerList[1].BowlerSeq := 1;
    //FLaneList[nTIdx].Assign.BowlerList[1].BowlerId := StrZeroAdd(IntToStr(FLaneList[nTIdx].LaneNo), 2) + 'A';
    FLaneList[nTIdx].Game.BowlerList[1] := FLaneList[nIdx].Game.BowlerList[nBIdx];

    for i := 2 to 6 do
    begin
      FLaneList[nTIdx].Assign.BowlerList[i].BowlerId := '';
      FLaneList[nTIdx].Assign.BowlerList[i].BowlerNm := '';
    end;

    global.TcpServer.UseSeqNo := global.TcpServer.UseSeqNo + 1;
    FLaneList[nTIdx].Assign.AssignDt := global.TcpServer.UseSeqDate;
    FLaneList[nTIdx].Assign.AssignSeq := global.TcpServer.UseSeqNo;
    FLaneList[nTIdx].Assign.AssignNo := global.TcpServer.UseSeqDate + StrZeroAdd(IntToStr(global.TcpServer.UseSeqNo), 4);
    //FLaneList[nTIdx].Assign.GameSeq := 1;
    FLaneList[nTIdx].Assign.LaneNo := FLaneList[nTIdx].LaneNo;
    FLaneList[nTIdx].Assign.AssignStatus := 3; // 진행상태
    FLaneList[nTIdx].Assign.StartDatetime := formatdatetime('YYYYMMDDhhnn00', Now);
    FLaneList[nTIdx].Assign.BowlerCnt := 1;

    //FLaneList[nTIdx].Assign.TotalGameCnt := FLaneList[nTIdx].Assign.BowlerList[1].GameCnt;

    //예상 예약시간, 예상 종료시간
    FLaneList[nTIdx].Assign.ReserveDate := FormatDateTime('YYYYMMDDhhnnss', now);
    FLaneList[nTIdx].Assign.ExpectdEndDate := '';

    {
    if (FLaneList[nTIdx].Assign.GameDiv = 1) and (FLaneList[nTIdx].Assign.TotalGameCnt > 0) then //게임제
    begin
      dtPossibleReserveEndDt := IncMinute(now, (Global.Store.PerGameMin * FLaneList[nTIdx].Assign.TotalGameCnt));
      FLaneList[nTIdx].Assign.ReserveDate := FormatDateTime('YYYYMMDDhhnnss', now);
      FLaneList[nTIdx].Assign.ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveEndDt);
    end
    else if FLaneList[nTIdx].Assign.GameDiv = 2 then //시간제
    begin
      dtPossibleReserveEndDt := IncMinute(now, FLaneList[nTIdx].Assign.TotalGameCnt);
      FLaneList[nTIdx].Assign.ReserveDate := FormatDateTime('YYYYMMDDhhnnss', now);
      FLaneList[nTIdx].Assign.ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveEndDt);
    end;
    }

    //DB저장 - 배정
    bResult := Global.DM.InsertAssignMove(FLaneList[nTIdx].Assign, AUserId);
    if bResult = False then
    begin
      Result := '{"result_cd":"GS04","result_msg":"DB 저장에 실패하였습니다"}';
      FLaneList[nTIdx].Assign.AssignNo := ''; //배정번호 초기화
      Exit;
    end;

    // DB 저장 - 게임
    sSql := RegGameSql(nTIdx);
    bResult := Global.DM.InsertGame(sSql);

  end
  else
  begin
    FLaneList[nTIdx].Assign.BowlerCnt := nTBIdx;

    //데이터 설정
    FLaneList[nTIdx].Assign.BowlerList[nTBIdx] := FLaneList[nIdx].Assign.BowlerList[nBIdx];
    FLaneList[nTIdx].Assign.BowlerList[nTBIdx].BowlerSeq := nTBIdx;
    {
    sBowlerId := copy(FLaneList[nTIdx].Assign.BowlerList[nTBIdx - 1].BowlerId, 3, 1);
    nByte := Ord(sBowlerId[1]) + 1;
    FLaneList[nTIdx].Assign.BowlerList[nTBIdx].BowlerId := StrZeroAdd(IntToStr(FLaneList[nTIdx].LaneNo), 2) + Char(nbyte);
    }
    global.Log.LogReserveWrite(
    'nBIdx : ' + inttostr(nBIdx) + ' / ' +
    FLaneList[nIdx].Game.BowlerList[nBIdx].BowlerId+ ' / ' +
    FLaneList[nIdx].Game.BowlerList[nBIdx].BowlerNm+ ' / ' +
    inttostr(FLaneList[nIdx].Game.BowlerList[nBIdx].EndGameCnt)+ ' / ' +
    inttostr(FLaneList[nIdx].Game.BowlerList[nBIdx].ResidualGameCnt)+ ' / ' +
    FLaneList[nIdx].Game.BowlerList[nBIdx].FramePin[3]+ ' / ' +
    FLaneList[nIdx].Game.BowlerList[nBIdx].FramePin[4]
    );

    FLaneList[nTIdx].Game.BowlerList[nTBIdx] := FLaneList[nIdx].Game.BowlerList[nBIdx];
  end;

  //DB저장
  //기존 볼러 삭제 - 배정볼러정보 유지 위해
  bResult := Global.DM.UpdateAssignBowlerDel(FLaneList[nIdx].Assign.AssignNo, ABowlerId, 'Y'); //볼러정보 변경

  //이동 볼러 추가
  bResult := Global.DM.InsertAssignBowler(FLaneList[nTIdx].LaneNo, FLaneList[nTIdx].Assign.AssignNo, FLaneList[nTIdx].Assign.BowlerList[nTBIdx]);
  ATargetAssignNo := FLaneList[nTIdx].Assign.AssignNo;
  ATargetId := FLaneList[nTIdx].Assign.BowlerList[nTBIdx].BowlerId;

  SetExpectdEndDate(nTIdx); //예상종료시간 계산

  //기존 배정 볼러 정리필요
  nBIdxLast := FLaneList[nIdx].Assign.BowlerCnt;
  if nBIdx < nBIdxLast then
  begin
    for I := nBIdx to nBIdxLast - 1 do
    begin
      FLaneList[nIdx].Assign.BowlerList[I] := FLaneList[nIdx].Assign.BowlerList[I + 1];
      FLaneList[nIdx].Assign.BowlerList[I].BowlerSeq := I;

      FLaneList[nIdx].Game.BowlerList[I] := FLaneList[nIdx].Game.BowlerList[I + 1];
      //ChgGameBowlerList(nIdx, I, nIdx, I + 1);

      global.Log.LogReserveWrite(
      'I : ' + inttostr(I) + ' / ' +
      FLaneList[nIdx].Game.BowlerList[I].BowlerId+ ' / ' +
      FLaneList[nIdx].Game.BowlerList[I].BowlerNm+ ' / ' +
      inttostr(FLaneList[nIdx].Game.BowlerList[I].EndGameCnt)+ ' / ' +
      inttostr(FLaneList[nIdx].Game.BowlerList[I].ResidualGameCnt)
      );

      //DB저장 - 인덱스 변경
      bResult := Global.DM.UpdateAssignBowlerSeq(FLaneList[nIdx].Assign.AssignNo, FLaneList[nIdx].Assign.BowlerList[I].BowlerId, I);
    end;
  end;
  FLaneList[nIdx].Assign.BowlerList[nBIdxLast].BowlerId := '';
  FLaneList[nIdx].Assign.BowlerList[nBIdxLast].BowlerNm := '';
  FLaneList[nIdx].Assign.BowlerCnt := FLaneList[nIdx].Assign.BowlerCnt - 1;

  SetExpectdEndDate(nIdx); //예상종료시간 계산

  //제어
  sNm := FLaneList[nTIdx].Assign.BowlerList[nTBIdx].BowlerNm;
  if FLaneList[nTIdx].Assign.BowlerList[nTBIdx].ShoesYn = 'Y' then
    //sNm := sNm + ' 11'
    sNm := sNm + ' 1'
  else
    //sNm := sNm + ' 01';
    sNm := sNm + ' 0';
  sNm := sNm + Copy(FLaneList[nTIdx].Assign.BowlerList[nTBIdx].FeeDiv, 2, 1);
  Global.Com.SendLaneAssignMoveBowler(StrToInt(ATargetLaneNo), nTBIdx, sNm);

  Global.Com.SendLaneAssignMoveBowlerDel(FLaneList[nIdx].LaneNo, nBIdx); // 사용자 빼기
  //Global.Com.SendLaneAssignBowlerFin(FLaneList[nIdx].LaneNo); //명령완료

  //Global.Com.SendLaneAssignBowlerFin(StrToInt(ATargetLaneNo)); //명령완료
  Global.Com.SendPinSetterOnOff(StrToInt(ATargetLaneNo), 'Y'); //장치켜기

  //볼러 모두 제거된 경우 종료처리
  if FLaneList[nIdx].Assign.BowlerCnt = 0 then
    SetLaneAssignCancel(0, 1, FLaneList[nIdx].Assign.AssignNo);

  //홀드 해제
  bResult := Global.DM.ChangeLaneHold(ATargetLaneNo, 'N', AUserId);
  if bResult = True then
  begin
    rHoldInfo.HoldUse := 'N';
    rHoldInfo.HoldUser := AUserId;
    Global.Lane.SetLaneHold(ATargetLaneNo, rHoldInfo);
  end;

  Result := 'Success';
end;

procedure TLane.ChgGameBowlerList(APLaneIdx, APBIdx, AGLaneIdx, AGBIdx: Integer); // 변경할 lane, 볼러idx , data 가져올 lane, 볼러idx
var
  i: Integer;
  nTemp: Integer;
begin
  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].BowlerSeq :=        FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].BowlerSeq;
  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].BowlerId :=         FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].BowlerId;
  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].BowlerNm :=         FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].BowlerNm;

  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].FrameTo :=          FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].FrameTo;

  for I := 1 to 21 do
    FLaneList[APLaneIdx].Game.BowlerList[APBIdx].FramePin[I] :=    FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].FramePin[I];

  for I := 1 to 10 do
    FLaneList[APLaneIdx].Game.BowlerList[APBIdx].FrameScore[I] :=  FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].FrameScore[I];

  for I := 1 to 10 do
    FLaneList[APLaneIdx].Game.BowlerList[APBIdx].FrameLane[I] :=   FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].FrameLane[I];

  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].TotalScore :=       FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].TotalScore;
  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].ToCnt :=            FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].ToCnt;
  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].EndGameCnt :=       FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].EndGameCnt;

  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].Status1 :=          FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].Status1;
  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].ResidualGameTime := FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].ResidualGameTime;
  //FLaneList[APLaneIdx].Game.BowlerList[APBIdx].ResidualGameCnt :=  FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].ResidualGameCnt;
  nTemp :=  FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].ResidualGameCnt;
  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].ResidualGameCnt := nTemp;

  FLaneList[APLaneIdx].Game.BowlerList[APBIdx].Status3 :=          FLaneList[AGLaneIdx].Game.BowlerList[AGBIdx].Status3;
end;

function TLane.DelAssignBowler(AAssignNo, ABowlerId: String): String;
var
  nLIdx, nBIdx: Integer;
  nBIdxLast, i, j: Integer;
  bResult: Boolean;
  sLog: String;

  nIdx1, nIdx2, nLaneNo: Integer;
  nCompetitionIdx: Integer;


  rBowlerInfo: TBowlerInfo;

  // erp 요청
  jSend, jSendItem: TJSONObject;
  jSendArr: TJsonArray;
  sRecvResult: String;

begin
  Result := 'Fail';

  rBowlerInfo := Global.DM.SelectAssignBowler(AAssignNo, ABowlerId);
  if rBowlerInfo.BowlerSeq = 0 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  try
    jSend := TJSONObject.Create;
    jSend.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
    jSend.AddPair(TJSONPair.Create('assign_no', AAssignNo));
    jSend.AddPair(TJSONPair.Create('bowler_seq', rBowlerInfo.BowlerSeq));
    jSend.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

    //Erp 전문전송
    sRecvResult := Global.Api.SetErpApiNoData(jSend.ToString, 'E103_delBowler', Global.Config.ApiUrl, Global.Config.Token);

    sLog := 'E103_delBowler: ' + sRecvResult;
    Global.Log.LogErpApiWrite(sLog);

    if sRecvResult <> 'Success' then
    begin
      sLog := jSend.ToString;
      Global.Log.LogErpApiWrite(sLog);

      Result := sRecvResult;
      Exit;
    end;

  finally
    FreeAndNil(jSend);
  end;

  nLIdx := GetAssignNoIndex(AAssignNo);
  if nLIdx = -1 then // 예약건 확인
  begin
    nBIdx := rBowlerInfo.BowlerSeq;
    nBIdxLast := Global.DM.SelectAssignBowlerCnt(AAssignNo);
  end
  else
  begin
    nBIdx := GetAssignNoBowlerIndex(nLIdx, ABowlerId);
    nBIdxLast := FLaneList[nLIdx].Assign.BowlerCnt;
  end;
  {
  // 보류 - 2024-03-11
  if nBIdx < nBIdxLast then
  begin
    try
      jSend := TJSONObject.Create;
      jSend.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
      jSend.AddPair(TJSONPair.Create('assign_no', AAssignNo));
      jSend.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

      jSendArr := TJSONArray.Create;
      jSend.AddPair(TJSONPair.Create('bowlerList', jSendArr));

      for I := nBIdx to nBIdxLast - 1 do
      begin
        jSendItem := TJSONObject.Create;
        jSendItem.AddPair( TJSONPair.Create( 'bowler_seq', I + 1) );
        jSendItem.AddPair( TJSONPair.Create( 'chg_bowler_seq', I) );
        jSendArr.Add(jSendItem);
      end;

      //Erp 전문전송
      sRecvResult := Global.Api.SetErpApiNoData(jSend.ToString, 'E104_chgBowlerSeq', Global.Config.ApiUrl, Global.Config.Token);

      sLog := 'E104_chgBowlerSeq: ' + sRecvResult;
      Global.Log.LogErpApiWrite(sLog);

      if sRecvResult <> 'Success' then
      begin
        sLog := jSend.ToString;
        Global.Log.LogErpApiWrite(sLog);

        Result := sRecvResult;
        Exit;
      end;

    finally
      FreeAndNil(jSend);
    end;
  end;
  }
  sLog := '볼러제거 - AssignNo: ' + AAssignNo + ' / ID:' + ABowlerId;
  Global.Log.LogServerWrite(sLog);

  //DB저장
  bResult := Global.DM.UpdateAssignBowlerDel(AAssignNo, ABowlerId, 'Y'); //볼러정보 변경

  if nLIdx = -1 then // 예약건 확인
  begin
    Result := 'Success';
    Exit;
  end;

  //기존 배정 볼러 정리필요
  if nBIdx < nBIdxLast then
  begin
    for I := nBIdx to nBIdxLast - 1 do
    begin
      FLaneList[nLIdx].Assign.BowlerList[I] := FLaneList[nLIdx].Assign.BowlerList[I + 1];
      //FLaneList[nIdx].Assign.BowlerList[I].BowlerSeq := I;

      //DB저장 - 인덱스 변경
      bResult := Global.DM.UpdateAssignBowlerSeq(FLaneList[nLIdx].Assign.AssignNo, FLaneList[nLIdx].Assign.BowlerList[I].BowlerId, I);
    end;
  end;
  FLaneList[nLIdx].Assign.BowlerList[nBIdxLast].BowlerId := '';
  FLaneList[nLIdx].Assign.BowlerList[nBIdxLast].BowlerNm := '';
  FLaneList[nLIdx].Assign.BowlerCnt := FLaneList[nLIdx].Assign.BowlerCnt - 1;

  SetExpectdEndDate(nLIdx); //예상종료시간 계산

  if FLaneList[nLIdx].Assign.CompetitionSeq > 0 then //게임이 대회이면
  begin
    nCompetitionIdx := GetCompetitionIndex(FLaneList[nLIdx].Assign.CompetitionSeq);
    if nCompetitionIdx > -1 then
    begin
      for i := 0 to Length(FCompetitionList[nCompetitionIdx].List) - 1 do
      begin
        if FCompetitionList[nCompetitionIdx].List[i].AssignNo = FLaneList[nLIdx].Assign.AssignNo then //대회
        begin
          for j := 1 to 6 do
          begin
            FCompetitionList[nCompetitionIdx].List[i].BowlerList[j] := FLaneList[nLIdx].Assign.BowlerList[j];
          end;

          sLog := '대회정보 변경 - 볼러삭제';
          Global.Log.LogServerWrite(sLog);

          Break;
        end;
      end;
    end;
  end;

  bResult := Global.DM.UpdateGame(FLaneList[nLIdx].Assign.AssignNo, FLaneList[nLIdx].Assign.GameSeq, FLaneList[nLIdx].Assign.BowlerCnt); //게임정보 변경

  //제어
  //Global.Com.SendLaneAssignBowlerDel(FLaneList[nIdx].LaneNo, nBIdx);
  Global.Com.SendLaneAssignMoveBowlerDel(FLaneList[nLIdx].LaneNo, nBIdx); // 사용자 빼기

  //볼러 모두 제거된 경우 종료처리
  if FLaneList[nLIdx].Assign.BowlerCnt = 0 then
    SetLaneAssignCancel(0, 1, FLaneList[nLIdx].Assign.AssignNo);

  Result := 'Success';
end;

function TLane.ChgAssignBowlerGameCnt(AAssignNo, ABowlerId, AGameCnt: String): String;
var
  nIdx, nBIdx: Integer;
  bResult: Boolean;
  sLog: String;

  nIdx1, nIdx2, nLaneNo: Integer;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    //예약목록 확인
    bResult := Global.ReserveList.GetReserveAssignNoChk(AAssignNo, nIdx1, nIdx2, nLaneNo);
    if bResult = False then
    begin
      Result := '해당 배정내역이 없습니다';
      Exit;
    end;

    //DB저장
    bResult := Global.DM.UpdateAssignBowlerGameCnt(AAssignNo, ABowlerId, StrToInt(AGameCnt)); //볼러정보 변경
    sLog := '볼러 게임수 변경 : ' + AAssignNo + ' / ID:' + ABowlerId;
    Global.Log.LogServerWrite(sLog);

    Result := 'Success';
    Exit;
  end;

  nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
  if nBIdx = -1 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameCnt := StrToInt(AGameCnt);

  //DB저장
  bResult := Global.DM.UpdateAssignBowlerGameCnt(FLaneList[nIdx].Assign.AssignNo, ABowlerId, StrToInt(AGameCnt)); //볼러정보 변경

  //제어
  Global.Com.SendLaneAssignBowlerGameCnt(FLaneList[nIdx].LaneNo, nBIdx, StrToInt(AGameCnt));
  Global.Com.SendLaneAssignBowlerGameCntSet(FLaneList[nIdx].LaneNo, nBIdx);

  Result := 'Success';
end;

function TLane.ChgAssignBowlerGameTime(AAssignNo, ABowlerId, AGameTime: String): String;
var
  nIdx, nBIdx: Integer;
  bResult: Boolean;
  sLog: String;

  nIdx1, nIdx2, nLaneNo: Integer;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    //예약목록 확인
    bResult := Global.ReserveList.GetReserveAssignNoChk(AAssignNo, nIdx1, nIdx2, nLaneNo);
    if bResult = False then
    begin
      Result := '해당 배정내역이 없습니다';
      Exit;
    end;

    //DB저장
    bResult := Global.DM.UpdateAssignBowlerGameMin(AAssignNo, ABowlerId, StrToInt(AGameTime)); //볼러정보 변경
    sLog := '볼러 게임시간 변경 : ' + AAssignNo + ' / ID:' + ABowlerId;
    Global.Log.LogServerWrite(sLog);

    Result := 'Success';
    Exit;
  end;

  nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
  if nBIdx = -1 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  FLaneList[nIdx].Assign.GameDiv := 2;
  FLaneList[nIdx].Assign.BowlerList[nBIdx].GameMin := StrToInt(AGameTime);

  //DB저장
  bResult := Global.DM.UpdateAssignBowlerGameMin(FLaneList[nIdx].Assign.AssignNo, ABowlerId, StrToInt(AGameTime)); //볼러정보 변경

  //제어
  Global.Com.SendLaneAssignBowlerGameTime(FLaneList[nIdx].LaneNo, nBIdx, StrToInt(AGameTime));

  Result := 'Success';
end;

function TLane.ChgAssignBowlerSwitch(AAssignNo, ABowlerId, AOrderSeq: String): String;
var
  nIdx, nBIdx, nTarget, I: Integer;
  nStart, nEnd: Integer;
  bResult: Boolean;
  sLog: String;
  rSelectBowler, rTargetBowler: TBowlerInfo;

  jSendObj, jSendItem: TJSONObject;
  jSendObjArr: TJsonArray;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    Result := '게임진행중인 배정이 없습니다.';
    Exit;
  end;

  nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
  if nBIdx = -1 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  nTarget := StrToInt(AOrderSeq);
  if nBIdx = nTarget then
    Exit;

  rSelectBowler := FLaneList[nIdx].Assign.BowlerList[nBIdx];

  if nBIdx < nTarget then
  begin
    nStart := nBIdx + 1;
    nEnd := nTarget;

    for I := nStart to nEnd do
    begin
      rTargetBowler := FLaneList[nIdx].Assign.BowlerList[I];
      FLaneList[nIdx].Assign.BowlerList[I - 1] := rTargetBowler;
      FLaneList[nIdx].Assign.BowlerList[I - 1].BowlerSeq := I - 1;
    end;
  end
  else
  begin
    nStart := nTarget;
    nEnd := nBIdx - 1;

    for I := nStart to nEnd do
    begin
      rTargetBowler := FLaneList[nIdx].Assign.BowlerList[I];
      FLaneList[nIdx].Assign.BowlerList[I + 1] := rTargetBowler;
      FLaneList[nIdx].Assign.BowlerList[I + 1].BowlerSeq := I + 1;
    end;
  end;

  FLaneList[nIdx].Assign.BowlerList[nTarget] := rSelectBowler;
  FLaneList[nIdx].Assign.BowlerList[nTarget].BowlerSeq := nTarget;

  if nBIdx < nTarget then
  begin
    nStart := nBIdx;
    nEnd := nTarget;
  end
  else
  begin
    nStart := nTarget;
    nEnd := nBIdx;
  end;

  for I := nStart to nEnd do
  begin
    //DB저장 - 인덱스 변경
    bResult := Global.DM.UpdateAssignBowlerSeq(FLaneList[nIdx].Assign.AssignNo, FLaneList[nIdx].Assign.BowlerList[I].BowlerId, I);
  end;

  //제어
  for I := FLaneList[nIdx].Assign.BowlerCnt downto nStart do
  begin
    //Global.Com.SendLaneAssignBowlerDel(FLaneList[nIdx].LaneNo, I); //볼러제거
    Global.Com.SendLaneAssignMoveBowlerDel(FLaneList[nIdx].LaneNo, I); // 사용자 빼기
  end;

  for I := nStart to FLaneList[nIdx].Assign.BowlerCnt do
  begin
    Global.Com.SendLaneAssignMoveBowler(FLaneList[nIdx].LaneNo, I, FLaneList[nIdx].Assign.BowlerList[I].BowlerNm); //볼러등록
  end;

  jSendObj := TJSONObject.Create;
  jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
  jSendObj.AddPair(TJSONPair.Create('assign_no', AAssignNo));
  jSendObj.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

  jSendObjArr := TJSONArray.Create;
  jSendObj.AddPair(TJSONPair.Create('bowlerList', jSendObjArr));

  jSendItem := TJSONObject.Create;
  jSendItem.AddPair( TJSONPair.Create( 'bowler_seq', nBIdx ) );
  jSendItem.AddPair( TJSONPair.Create( 'chg_bowler_seq', nTarget) );
  jSendObjArr.Add(jSendItem);

  RegAssignEpr(AAssignNo, 'E107_exChgBowlerSeq', jSendObj.ToString);
  FreeAndNil(jSendObj);

  Result := 'Success';
end;

function TLane.ChgAssignBowlerHandy(AAssignNo, ABowlerId, AHandy: String): String;
var
  nIdx, nBIdx: Integer;
  I: Integer;
  bResult: Boolean;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    Result := '게임진행중인 배정이 없습니다.';
    Exit;
  end;

  nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
  if nBIdx = -1 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  FLaneList[nIdx].Assign.BowlerList[nBIdx].Handy := StrToInt(AHandy);

  //DB저장
  bResult := Global.DM.UpdateAssignBowlerHandy(FLaneList[nIdx].Assign.AssignNo, ABowlerId, AHandy);

  //제어
  Global.Com.SendLaneAssignGameHandy(FLaneList[nIdx].LaneNo, nBIdx, StrToInt(AHandy));

  Result := 'Success';
end;

function TLane.ChgAssignGameLeague(ALaneNo, AUseYn: String): Boolean;
var
  nIdx1, nIdx2: Integer;
  bResult: Boolean;
  nLaneNo, nLaneNoTm1, nLaneNoTm2: Integer;
begin
  Result := False;

  nLaneNo := StrToInt(ALaneNo);
  if odd(nLaneNo) = True then
  begin
    nLaneNoTm1 := nLaneNo;
    nLaneNoTm2 := nLaneNo + 1;
  end
  else
  begin
    nLaneNoTm1 := nLaneNo - 1;
    nLaneNoTm2 := nLaneNo;
  end;

  //리그 설정시 두레인 모두 배정이 있는지. 배정이 서로 다를경우 등 상황 설정 필요
  nIdx1 := GetLaneInfoIndex(nLaneNoTm1);

  if AUseYn = FLaneList[nIdx1].Assign.LeagueYn then
  begin
    Result := True;
    Exit;
  end;

  nIdx2 := GetLaneInfoIndex(nLaneNoTm2); //장치별, 2개레인모두 표시
  FLaneList[nIdx1].Assign.LeagueYn := AUseYn;
  FLaneList[nIdx2].Assign.LeagueYn := AUseYn;

  //DB저장
  bResult := Global.DM.UpdateAssignGameLeague(FLaneList[nIdx1].Assign.AssignDt, FLaneList[nIdx1].Assign.AssignSeq, AUseYn);
  bResult := Global.DM.UpdateAssignGameLeague(FLaneList[nIdx2].Assign.AssignDt, FLaneList[nIdx2].Assign.AssignSeq, AUseYn);

  //제어-장치기준
  Global.Com.SendLaneAssignGameLeague(nLaneNoTm1, AUseYn);

  Result := True;
end;


function TLane.ChgAssignGameType(ALaneNo, AAssignNo, AGameType: String): Boolean;
var
  nIdx: Integer;
  bResult: Boolean;
  sLog: String;
  nLaneNo, nGameType: Integer;
begin
  Result := False;

  //리그 설정시 두레인 모두 배정이 있는지. 배정이 서로 다를경우 등 상황 설정 필요
  nIdx := GetLaneInfoIndex(StrToInt(ALaneNo));
  if FLaneList[nIdx].Assign.AssignNo <> AAssignNo then
  begin
    //Global.ReserveList.ChgAssignReserveBowlerGameCnt(StrToInt(ALaneNo), AAssignNo, nBIdx, AGameCnt);
    Exit;
  end;

  if FLaneList[nIdx].Assign.GameType = StrToInt(AGameType) then
    Exit;

  FLaneList[nIdx].Assign.GameType := StrToInt(AGameType);

  //DB저장
  bResult := Global.DM.UpdateAssignGameType(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq, AGameType);

  //제어-장치기준
  if odd(FLaneList[nIdx].LaneNo) = True then
    nLaneNo := FLaneList[nIdx].LaneNo
  else
    nLaneNo := FLaneList[nIdx].LaneNo - 1;
  Global.Com.SendLaneAssignGameType(nLaneNo, AGameType);

  Result := True;
end;

function TLane.ChgAssignGameTypeFin(ALaneNo, AAssignNo, AGameType: String): Boolean;
var
  nIdx: Integer;
  bResult: Boolean;
  sLog: String;
  nLaneNo1, nLaneNo2: Integer;
begin
  Result := False;

  //리그 설정시 두레인 모두 배정이 있는지. 배정이 서로 다를경우 등 상황 설정 필요
  nIdx := GetLaneInfoIndex(StrToInt(ALaneNo));
  {if FLaneList[nIdx].Assign.AssignNo <> AAssignNo then
  begin
    //Global.ReserveList.ChgAssignReserveBowlerGameCnt(StrToInt(ALaneNo), AAssignNo, nBIdx, AGameCnt);
    Exit;
  end;

  if FLaneList[nIdx].Assign.GameType = AGameType then
    Exit;

  FLaneList[nIdx].Assign.GameType := AGameType;

  //DB저장
  bResult := Global.DM.UpdateAssignGameType(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq, AGameType);
     }
  //제어-장치기준
  if odd(FLaneList[nIdx].LaneNo) = True then
  begin
    nLaneNo1 := FLaneList[nIdx].LaneNo;
    nLaneNo2 := FLaneList[nIdx].LaneNo - 1;

  end
  else
  begin
    nLaneNo1 := FLaneList[nIdx].LaneNo - 1;
    nLaneNo2 := FLaneList[nIdx].LaneNo;

  end;

  Global.Com.SendLaneAssignGameTypeFin(nLaneNo1);
  Global.Com.SendLaneAssignGameTypeFin(nLaneNo2);

  Result := True;
end;


function TLane.ChgAssignRestore(ALaneNo: String): String;
var
  nIdx, nBIdx, i, j: Integer;
  rGameInfoListDB: TList<TGameInfoDB>;
begin
  Result := 'Fail';

  nIdx := GetLaneInfoIndex(StrToInt(ALaneNo));

  // 현재 진행중인 배정의 이전게임복구
  if FLaneList[nIdx].Assign.GameSeq = 0 then
  begin
    Result := '이전게임 정보가 없습니다';
    Exit;
  end;

  //DB 불러옴
  rGameInfoListDB := Global.DM.SelectAssignGameList(FLaneList[nIdx].Assign.AssignDt, FLaneList[nIdx].Assign.AssignSeq, FLaneList[nIdx].Assign.GameSeq - 1);
  for i := 0 to rGameInfoListDB.Count - 1 do
  begin
    nBIdx := rGameInfoListDB[i].BowlerSeq;

    for j := 1 to 21 do
    begin
      FLaneList[nIdx].Game.BowlerList[nBIdx].FramePin[j] := rGameInfoListDB[i].FramePin[j];
    end;

    for j := 1 to 10 do
    begin
      FLaneList[nIdx].Game.BowlerList[nBIdx].FrameScore[j] := rGameInfoListDB[i].FrameScore[j];
    end;
    {
    for j := 1 to 10 do
    begin
      FLaneList[nIdx].Assign.BowlerList[nBIdx].FrameLane[j] := rGameInfoListDB[i].FrameLane[j];
    end;
    }
    FLaneList[nIdx].Game.BowlerList[nBIdx].TotalScore := rGameInfoListDB[i].TotalScore;
  end;
  FreeAndNil(rGameInfoListDB);

  //이전게임정보로 제어
  //Global.Com.SendLaneAssignMove(StrToInt(ALaneNo));

  Result := 'Success';
end;

function TLane.ChgBowlerPayment(AAssignNo, ABowlerId, APaymentType: String): String;
var
  nIdx, nBIdx, nSeq, nIdxTM: Integer;
  bResult: Boolean;
  I: Integer;
  nPayment: Integer;
  sStr: String;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    bResult := Global.ReserveList.ChgReserveBowlerPayment(AAssignNo, ABowlerId, APaymentType);
    if bResult = True then
      Result := 'Success';
    Exit;
  end;

  //대회여부
  nSeq := GetAssignNoCompetitionSeq(AAssignNo);
  if nSeq > 0 then
  begin
    nBIdx := GetCompetitionSeqBowlerIndex(nSeq, ABowlerId, nIdxTM);
    if nBIdx = -1 then
    begin
      Result := '해당 볼러정보가 없습니다.';
      Exit;
    end;
    nIdx := nIdxTM;
  end
  else
  begin
    nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
    if nBIdx = -1 then
    begin
      Result := '해당 볼러정보가 없습니다.';
      Exit;
    end;
  end;

  if FLaneList[nIdx].Assign.BowlerList[nBIdx].PaymentType = StrToInt(APaymentType) then
  begin
    Result := 'Success';
    Exit;
  end;

  if FLaneList[nIdx].Assign.GameDiv = 2 then
  begin
    for I := 1 to FLaneList[nIdx].Assign.BowlerCnt do
    begin
      FLaneList[nIdx].Assign.BowlerList[I].PaymentType := StrToInt(APaymentType);
      bResult := Global.DM.UpdateAssignBowlerPaymentType(FLaneList[nIdx].Assign.AssignNo, FLaneList[nIdx].Assign.BowlerList[I].BowlerId, APaymentType);
    end;
  end
  else
  begin
    FLaneList[nIdx].Assign.BowlerList[nBIdx].PaymentType := StrToInt(APaymentType);

    //DB저장
    bResult := Global.DM.UpdateAssignBowlerPaymentType(FLaneList[nIdx].Assign.AssignNo, ABowlerId, APaymentType);
  end;

  //배정 결제완료여부 확인
  nPayment := 1;
  for I := 1 to FLaneList[nIdx].Assign.BowlerCnt do
  begin
    if FLaneList[nIdx].Assign.BowlerList[I].PaymentType = 0 then
    begin
      nPayment := 0;
      Break;
    end;
  end;
  FLaneList[nIdx].Assign.PaymentResult := nPayment;

  if FLaneList[nIdx].Assign.PaymentResult = 1 then
  begin
    if FLaneList[nIdx].Assign.AssignStatus = 5 then //미결제 상태
    begin
      FLaneList[nIdx].Assign.AssignStatus := 6; //결제완료
      Global.DM.chgAssignEndDt(FLaneList[nIdx].Assign.AssignNo, '6');
      FLaneList[nIdx].Assign.EndDatetime := formatdatetime('YYYYMMDDhhnnss', Now);

      FLaneList[nIdx].Assign.AssignDt := '';
      FLaneList[nIdx].Assign.AssignSeq := 0;
      FLaneList[nIdx].Assign.AssignNo := '';

      sStr := '결제완료 - No: ' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm: ' + FLaneList[nIdx].LaneNm + ' / ' + FLaneList[nIdx].Assign.AssignNo;
      Global.Log.LogServerWrite(sStr);
    end;
  end;

  Result := 'Success';
end;

function TLane.chgBowlerPause(AAssignNo, ABowlerId, APauseYn: String): String;
var
  nIdx, nBIdx: Integer;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    Result := '게임진행중인 배정이 없습니다.';
    Exit;
  end;

  nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
  if nBIdx = -1 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  //제어
  Global.Com.SendBowlerPause(FLaneList[nIdx].LaneNo, nBIdx, APauseYn);

  Result := 'Success';
end;

procedure TLane.RegAssignEpr(AAssignNo, AApi, AJson: String);
var
  Data: TSendApiData;
begin
  Data := TSendApiData.Create;
  Data.Api := AApi;
  Data.Json := AJson;

  FSendApiList.AddObject(AAssignNo, TObject(Data));
end;

procedure TLane.LaneReserveErp;
var
  sResult, sApi, sJson, sLog: String;
begin

  if FSendApiList.Count = 0 then
    Exit;

  while True do
  begin
    if Global.ServerErp = False then
      Break;

    sLog := 'LaneReserveErp!';
    Global.Log.LogReserveDelayWrite(sLog);

    sleep(50);
  end;
  Global.LaneErp := True;

  try
    sApi := TSendApiData(FSendApiList.Objects[0]).Api;
    sJson := TSendApiData(FSendApiList.Objects[0]).Json;

    TSendApiData(FSendApiList.Objects[0]).Free;
    FSendApiList.Objects[0] := nil;
    FSendApiList.Delete(0);

    try
      sLog := sApi + ' : ' + sJson;
      Global.Log.LogErpApiWrite(sLog);

      sResult := Global.Api.SetErpApiJsonData(sJson, sApi, Global.Config.ApiUrl, Global.Config.Token);

      sLog := sApi + ' : ' + sResult;
      Global.Log.LogErpApiWrite(sLog);
    except
      on e: Exception do
      begin
        sLog := 'LaneReserveErp Exception : ' + e.Message;
        Global.Log.LogErpApiWrite(sLog);
      end;
    end;

  finally
    Global.LaneErp := False;
  end;
end;

function TLane.ChgBowlerScore(AAssignNo, ABowlerId, AFrame: String): String;
var
  nIdx, nBIdx: Integer;
  I: Integer;
begin
  Result := 'Fail';

  nIdx := GetAssignNoIndex(AAssignNo);
  if nIdx = -1 then
  begin
    Result := '게임진행중인 배정이 없습니다.';
    Exit;
  end;

  nBIdx := GetAssignNoBowlerIndex(nIdx, ABowlerId);
  if nBIdx = -1 then
  begin
    Result := '해당 볼러정보가 없습니다.';
    Exit;
  end;

  Global.Com.SendLaneGameScoreChange(FLaneList[nIdx].LaneNo, nBIdx, AFrame);

  Result := 'Success';
end;

function TLane.ChkBowlerNm(ABowlerNm: String): String;
var
  I, J: Integer;
  sStr, sTemp: String;
  nByte: Byte;
begin

  Result := '';
  sStr := '';
  for I := 0 to FLaneCnt - 1 do
  begin
    if FLaneList[I].Assign.AssignNo = '' then
      Continue;

    for J := 1 to FLaneList[I].Assign.BowlerCnt do
    begin
      if Copy(FLaneList[I].Assign.BowlerList[J].BowlerNm, 1, 2) = ABowlerNm then
      begin
        if sStr < FLaneList[I].Assign.BowlerList[J].BowlerNm then
          sStr := FLaneList[I].Assign.BowlerList[J].BowlerNm;
      end;
    end;
  end;

  if sStr = '' then
    sStr := ABowlerNm + 'A'
  else
  begin
    sTemp := copy(sStr, 3, 1);
    nByte := Ord(sTemp[1]) + 1;
    sStr := ABowlerNm + Char(nByte);
  end;

  Result := sStr;
end;

procedure TLane.SetLaneErrorCnt(ALaneNo: Integer; AError: String; AMaxCnt: Integer);
var
  sLogMsg: String;
  nIdx, nIdx2: Integer;
begin
  nIdx := GetLaneInfoIndex(ALaneNo);

  if nIdx = -1  then
    Exit;

  if (FLaneList[nIdx].UseStatus = '8') then
    Exit;

  if AError = 'Y' then
  begin
    FLaneList[nIdx].ErrorCnt := FLaneList[nIdx].ErrorCnt + 1;
    if FLaneList[nIdx].ErrorCnt >= AMaxCnt then
    begin
      if FLaneList[nIdx].ErrorYn = 'N' then
      begin
        Global.DM.ChangeLaneStatus(IntToStr(FLaneList[nIdx].LaneNo), '9');

        sLogMsg := 'ErrorCnt : ' + IntToStr(AMaxCnt) + ' / No:' + IntToStr(FLaneList[nIdx].LaneNo) + ' / Nm:' + FLaneList[nIdx].LaneNm;
        Global.Log.LogComWrite(sLogMsg);
      end;

      FLaneList[nIdx].ErrorYn := 'Y';
      FLaneList[nIdx].UseStatus := '9';

      nIdx2 := GetLaneInfoIndex(ALaneNo + 1);

      if nIdx2 = -1  then
        Exit;

      FLaneList[nIdx2].ErrorYn := 'Y';
      FLaneList[nIdx2].UseStatus := '9';
      FLaneList[nIdx2].ErrorCnt := FLaneList[nIdx].ErrorCnt;
    end;
  end
  else
  begin
    if FLaneList[nIdx].ErrorYn = 'Y' then
    begin
      Global.DM.ChangeLaneStatus(IntToStr(FLaneList[nIdx].LaneNo), '0');
    end;

    FLaneList[nIdx].ErrorCnt := 0;
    FLaneList[nIdx].ErrorYn := 'N';
    FLaneList[nIdx].UseStatus := '';

    nIdx2 := GetLaneInfoIndex(ALaneNo + 1);

    if nIdx2 = -1  then
      Exit;

    FLaneList[nIdx2].ErrorCnt := 0;
    FLaneList[nIdx2].ErrorYn := 'N';
    FLaneList[nIdx2].UseStatus := '';
  end;
end;

procedure TLane.SetExpectdEndDate(ALIdx: Integer);
var
  nReserveCnt, nTotalGameCnt, i: Integer;
  sLog: String;
  dtTemp, dtPossibleReserveEndDt: TDateTime;
  bResult: Boolean;
begin
  nReserveCnt := 0;
  nTotalGameCnt := 0;

  nReserveCnt := Global.ReserveList.GetReserveListCnt(FLaneList[ALIdx].Assign.LaneNo);

  if nReserveCnt > 0 then
  begin
    sLog := 'SetExpectdEndDate- No:' + IntTostr(FLaneList[ALIdx].Assign.LaneNo) + ' / ' +FLaneList[ALIdx].Assign.AssignNo + ' / ReserveCnt = ' + IntToStr(nReserveCnt);
    global.Log.LogReserveWrite(sLog);
    Exit;
  end;

  dtTemp := DateStrToDateTime(FLaneList[ALIdx].Assign.ReserveDate);

  for i := 1 to FLaneList[ALIdx].Assign.BowlerCnt do
  begin
    nTotalGameCnt := nTotalGameCnt + FLaneList[ALIdx].Assign.BowlerList[i].GameCnt;
  end;

  if nTotalGameCnt = 0 then
  begin
    sLog := 'SetExpectdEndDate- No:' + IntTostr(FLaneList[ALIdx].Assign.LaneNo) + ' / ' +FLaneList[ALIdx].Assign.AssignNo + ' / nTotalGameCnt = 0';
    global.Log.LogReserveWrite(sLog);
    Exit;
  end;

  if (FLaneList[ALIdx].Assign.GameDiv = 1) then //게임제
  begin
    dtPossibleReserveEndDt := IncMinute(dtTemp, (Global.Store.PerGameMin * nTotalGameCnt));
    FLaneList[ALIdx].Assign.ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveEndDt);
  end;
  { // 시간제 보류
  else if FLaneList[nTIdx].Assign.GameDiv = 2 then //시간제
  begin
    dtPossibleReserveEndDt := IncMinute(dtTemp, FLaneList[nTIdx].Assign.TotalGameCnt);
    FLaneList[nTIdx].Assign.ExpectdEndDate := FormatDateTime('YYYYMMDDhhnnss', dtPossibleReserveEndDt);
  end;
  }

  //DB저장
  bResult := Global.DM.UpdateExpectdEndDate(FLaneList[ALIdx].Assign.AssignNo, FLaneList[ALIdx].Assign.ExpectdEndDate);
  if bResult = False then
  begin
    sLog := 'SetExpectdEndDate- No:' + IntTostr(FLaneList[ALIdx].Assign.LaneNo) + ' / ' +FLaneList[ALIdx].Assign.AssignNo + ' / DB 저장 실패';
    global.Log.LogReserveWrite(sLog);
    Exit;
  end;
end;

{
const
  TEST_BIN: string = '0000001111110111';
  TEST_HEX: string = '03F7';
var
  sBinStr: string;
  sHexStr, sAscii: string;
begin
  sBinStr := System.StrUtils.RightStr(HexStrToBinStr(TEST_HEX), 10);
  sHexStr := IntToHexStr(BinStrToInt(sBinStr), 4);
  ShowMessage('2진수 값을 16진수로 변환' + _CRLF + Format('Binary: %s -> Hexadecimal: %s ', [sBinStr, sHexStr]));

  sHexStr := IntToHexStr(BinStrToInt(TEST_BIN), 4);
  sBinStr := System.StrUtils.RightStr(HexStrToBinStr(sHexStr), 10);
  ShowMessage('16진수 값을 2진수로 변환' + _CRLF + Format('Hexadecimal: %s -> Binary: %s', [sHexStr, sBinStr]));

  sAscii := HexStrToString(TEST_HEX);
  sHexStr := StringToHexStr(sAscii);
  ShowMessage('ASCII 값을 16진수로 변환' + _CRLF + Format('Ascii: %s -> Hexadecimal: %s', [sAscii, sHexStr]));
  }
  {
  function IntToHexStr(const AValue, ADigits: Integer): AnsiString;
begin
  Result := AnsiString(IntToHex(AValue, ADigits));
end;
}
{
function BinStrToInt(const AValue: AnsiString): Integer;
var
  nLen: Integer;
begin
  Result := 0;
  nLen := Length(AValue);
  for var I: Integer := nLen downto 1 do
    if AValue[I] = '1' then
      Result := Result + (1 shl (nLen - I));
end;
}

{
function HexStrToBinStr(const AValue: string): AnsiString;
begin
  Result := '';
  for var I: Integer := AValue.Length downto 1 do
    Result := CONST_BCD[StrToInt('$' + AValue[I])] + Result;
end;
}

{
 function HexStrToString(const AValue: string): string;
var
  I, J, nDigit: ShortInt;
  sTemp: string;
begin
  Result := '';
  nDigit := AValue.Length;
  for I := 0 to Pred(AValue.Length div nDigit) do
  begin
    sTemp := '';
    for J := 1 to nDigit do
      sTemp := sTemp + AValue[I * nDigit + J];
    Result := Result + Char(StrToInt('$' + sTemp));
  end;
end;
}

{
function StringToHexStr(const AValue: string): string;
begin
  Result := '';
  for var I: Integer := 1 to AValue.Length do
    Result := Result + System.SysUtils.IntToHex(Ord(AValue[I]), 2);
end;
}

end.
