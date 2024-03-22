unit uComBnC;

interface

uses
  { Native }
  Vcl.ExtCtrls, System.SysUtils,System.Classes, IdTCPClient,
  { libs }
  CPort,
  { Common }
  uConsts, uStruct;

type

  TComThread = class(TThread)
  private
    FComPort: TComPort;

    FCmdRecvBufArr: array[0..1023] of byte;
    FRecvLen: Integer;
    FRecvS: Integer;
    FCmdSendBufArr: array[0..BUFFER_SIZE] of TCmdCData;

    FReTry: Integer;

    //2020-06-08 제어3회 시도후 에러처리
    FCtlReTry: Integer;
    FCtlChannel: String;

    FReceived: Boolean;
    FChannel: String;

    FLaneNoStart: Integer; //시작 번호
    FLaneNoEnd: Integer;   //종료 번호
    FLaneNoLast: Integer;  //마지막 요청 번호

    FLastIdx: word; //대기중인 명령번호
    FCurIdx: word;  //처리한 명령번호

    FLastExeCommand: Integer; //최종 패킷 수행 펑션

    FWriteTm: TDateTime;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ComPortSetting(AStart, AEnd, APort, ABaudRate: Integer);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);

    procedure SetMonRecvBuffer(ASidx, AEidx: Integer);
    function SetNextMonNo: Boolean;

    function SendPinSetterOnOff(ALaneNo: Integer; AUseYn: String): Boolean; //장치켜기,끄기
    function SendMoniterOnOff(ALaneNo, AUseYn: String): Boolean;
    function SendPinSettingNo(ALaneNo, ASetType: String): Boolean;
    function SendBowlerPause(ALaneNo, ABowlerSeq: Integer; APauseYn: String): Boolean;
    function SendInitLane(ALaneNo: String): Boolean; // 마지막 명령 확인필요
    //function SendLaneTemp(ALaneNo: String): Boolean; // 명령어 확인 필요??? -> 제어 제외 2024-03-11
    function SendLaneStatus(ALaneNo: Integer): Boolean; // 초기화 명령 후 레인 상태 요청
    function SendGameCancel(ALaneNo: String): Boolean; // 레인 게임취소 (?? 레인초기화와 다른 명령? 확인필요) - 게이머 빼기 언제사용???

    function SendLaneAssign(ALaneNo: Integer): Boolean; //배정
    function SendLaneAssign_Competition(ALaneNo: Integer; ALeagueYn: String; ATrainMin: Integer): Boolean; //배정-대회
    function SendLaneAssignCtl(ALaneNo: Integer): Boolean; //배정명령 -> 오픈게임 명령으로 보임.  확인필요
    function SendLaneCompetitionBowlerAdd(ALaneNo, ABowlerCnt: Integer): Boolean;
    function SendLaneCompetitionBowlerAddTemp(ALaneNo, ABowlerCnt: Integer): Boolean; //테스트용 나중에 삭제

    function SendLaneAssignBowlerAdd(ALaneNo, ABowlerSeq: Integer): Boolean;
    //function SendLaneAssignBowlerFin(ALaneNo: Integer): Boolean; //게이머정보 등록/수정후 명령?  > 제어제외 2024-03-11
    function SendLaneAssignBowlerDel(ALaneNo, ABowlerSeq: Integer): Boolean; //사용자 제거? -> 이름 초기화??

    function SendLaneAssignBowlerGameCnt(ALaneNo, ABowlerSeq, AGameCnt: Integer): Boolean; //게임수 지정
    function SendLaneAssignBowlerGameCntSet(ALaneNo, ABowlerSeq: Integer): Boolean; //게임수 지정후 적용
    function SendLaneAssignBowlerGameTime(ALaneNo, ABowlerSeq, AGameTime: Integer): Boolean; //게임시간 지정
    function SendLaneAssignBowlerPause(ALaneNo, ABowlerSeq, APause: Integer): Boolean; //게이머 일시정지/해제

    function SendLaneAssignGameLeague(ALaneNo: Integer; AUse: String): Boolean; //리그게임 설정
    function SendLaneAssignGameLeagueOpen(ALaneNo: Integer): Boolean; //오픈-게임리그해제
    function SendLaneAssignGameType(ALaneNo: Integer; AGameType: String): Boolean; //8, 9, 369 게임
    function SendLaneAssignGameTypeFin(ALaneNo: Integer): Boolean; //8, 9, 369 게임 설정완료
    function SendLaneAssignGameBowlerHandy(ALaneNo: Integer): Boolean; //핸디-0:초기화, 1~255까지
    function SendLaneAssignGameHandy(ALaneNo, ABowlerSeq, AHandy: Integer): Boolean; //핸디-0:초기화, 1~255까지
    function SendLaneAssignGameTraining(ALaneNo, ATime: Integer): Boolean; //연습게임
    function SendLaneAssignGameTrainingFin(ALaneNo: Integer): Boolean; //연습게임

    function SendLaneGameScoreChange(ALaneNo, ABowlerSeq: Integer; AFrame: String): Boolean;

    function SendLaneGameNext(ALaneNo: Integer; ALeagueYn: String): Boolean;
    function SendLaneGameEnd(ALaneNo, ABowlerSeq: Integer; AType: String): Boolean; // 게임종료 지정 (리그게임 또는 게이머가 여러명일때 10프레임 완료 되면 정송)
    function SendLaneGameRestore(ALaneNo, ABowlerSeq: String): Boolean; // 이전게임복구

    function SendLaneAssignMove(ALaneNo, ATargetLaneNo: Integer): Boolean;
    function SendLaneAssignMoveBowler(ALaneNo, ABowlerSeq: Integer; ABowlerNm: String): Boolean;
    function SendLaneAssignMoveBowlerDel(ALaneNo, ABowlerSeq: Integer): Boolean; //사용자 레인이동시 기존레인 제거용

    function SendLaneGameStatus: Boolean; //상태요청

    function GetCRC(AIdx, AStart, AEnd: Integer): Integer;

    property ComPort: TComPort read FComPort write FComPort;
  end;

implementation

uses
  uGlobal, uXGMainForm, uFunction;

{ TComThreadZoom }

constructor TComThread.Create;
begin
  FReTry := 0;
  FCtlReTry := 0;

  FReceived := True;
  FLastIdx := 0;
  FCurIdx := 0;
  FRecvLen := 0;
  FRecvS := 0;

  Global.Log.LogWrite('TComThread Create');

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TComThread.Destroy;
begin
  FComPort.Close;
  FComPort.Free;
  inherited;
end;

procedure TComThread.ComPortSetting(AStart, AEnd, APort, ABaudRate: Integer);
begin
  FLaneNoStart := AStart;
  FLaneNoEnd := AEnd;
  FLaneNoLast := AStart;

  FComPort := TComport.Create(nil);

  //Global.Log.LogWrite('TComThread ComPortSetting : Port-' + IntToStr(APort));

  FComPort.OnRxChar := ComPortRxChar;
  FComPort.Port := 'COM' + IntToStr(APort);
  FComPort.BaudRate := GetBaudrate(ABaudRate);
  //FComPort.Parity.Bits := prOdd;
  FComPort.Open;

  Global.Log.LogWrite('TComThread ComPortSetting : Port-' + IntToStr(APort));
end;

procedure TComThread.ComPortRxChar(Sender: TObject; Count: Integer);
var
  sLogMsg: string;
  sRecvData: AnsiString;
  nBuffArr: array[0..1023] of byte;
  nRecLength, nLength1, nLength2, i: Integer;
begin

  //빈레인 60byte, 길이:$31(49)
  FComPort.Read(nBuffArr, Count);
  FComPort.ClearBuffer(True, False); // Input 버퍼 clear - True

  if FLastExeCommand = COM_CTL then
  begin
    sRecvData := '';
    for i := 0 to Count - 1 do
    begin
      if i > 0 then
        sRecvData := sRecvData + ' ';

      sRecvData := sRecvData + IntToHex(nBuffArr[i]);
    end;

    sLogMsg := 'COM_CTL RecvData : ' + sRecvData;
    Global.Log.LogComReadCtl(sLogMsg);

    FReceived := True;
  end
  else
  begin
    {
    sRecvData := '';
    for i := 0 to Count - 1 do
    begin
      if i > 0 then
        sRecvData := sRecvData + ' ';

      sRecvData := sRecvData + IntToHex(nBuffArr[i]);
    end;
    Global.Log.LogComReadMon(sRecvData);
    }
    for i := 0 to Count - 1 do
      FCmdRecvBufArr[FRecvLen + i] := nBuffArr[i];
    FRecvLen := FRecvLen + Count;
    //Global.Log.LogComReadMon('FRecvLen : ' + inttostr(FRecvLen));

    if FCmdRecvBufArr[0] <> $47 then
    begin
      Global.Log.LogComReadMon('FCmdRecvBufArr[0] <> $47 Exit');
      Exit;
    end;

    //Global.Log.LogComReadMon('FRecvS : ' + inttostr(FRecvS));
    if FRecvS = 0 then
    begin
      if FRecvLen < 11 then
      begin
        //Global.Log.LogComReadMon('FRecvLen < 11');
        Exit;
      end;

      nLength1 := FCmdRecvBufArr[9];
      nLength2 := FCmdRecvBufArr[10];
      nRecLength := (nLength1 * 256) + nLength2;
      //Global.Log.LogComReadMon('nRecLength : ' + inttostr(nRecLength));
      if FRecvLen < (11 + nRecLength) then
      begin
        //Global.Log.LogComReadMon('FRecvLen < ' + inttostr(11 + nRecLength));
        Exit;
      end;

      FRecvS := 11 + nRecLength;

      if FRecvLen < (FRecvS + 11) then
      begin
        //Global.Log.LogComReadMon('FRecvLen 22 < ' + inttostr(FRecvS + 11));
        Exit;
      end;

      nLength1 := FCmdRecvBufArr[FRecvS + 9];
      nLength2 := FCmdRecvBufArr[FRecvS + 10];
      nRecLength := (nLength1 * 256) + nLength2;

      if FRecvLen < (FRecvS + 11 + nRecLength) then
        Exit;

      SetMonRecvBuffer(0, FRecvS -1);
      SetMonRecvBuffer(FRecvS, FRecvLen -1);

      Global.Lane.SetLaneErrorCnt(FLaneNoLast, 'N', 6);
      SetNextMonNo;
      FReceived := True;
    end
    else
    begin
      if FRecvLen < (FRecvS + 11) then
      begin
        //Global.Log.LogComReadMon('FRecvLen 22 < ' + inttostr(FRecvS + 11));
        Exit;
      end;

      nLength1 := FCmdRecvBufArr[FRecvS + 9];
      nLength2 := FCmdRecvBufArr[FRecvS + 10];
      nRecLength := (nLength1 * 256) + nLength2;

      if FRecvLen < (FRecvS + 11 + nRecLength) then
        Exit;

      SetMonRecvBuffer(0, FRecvS -1);
      SetMonRecvBuffer(FRecvS, FRecvLen -1);

      Global.Lane.SetLaneErrorCnt(FLaneNoLast, 'N', 6);
      SetNextMonNo;
      FReceived := True;
    end;

  end;

end;

procedure TComThread.SetMonRecvBuffer(ASidx, AEidx: Integer);
var
  sLogMsg: string;
  sRecvData: AnsiString;
  rGameStatus: TGameStatus;
  nRecLength, nLength1, nLength2: Integer;
  i, j: Integer;
  nBowler, nBoelerIdx, nIndex: Integer;
  bGamerArr: array[0..82] of byte;
  sFrame: String;
  bByteTm: Byte;

  Arr: array of byte;
  nLength: Integer;
  nidx: integer;

  Temp, cSum: Byte;
begin

  nLength  := AEidx - ASidx;

  if nLength = -1 then
  begin
    Global.Log.LogComReadMon('nLength = -1 Exit');
    Exit;
  end;

  Setlength(Arr, nLength + 1);

  nidx := 0;
  for i := ASidx to AEidx do
  begin
    Arr[nidx] := FCmdRecvBufArr[i];
    inc(nidx);
  end;

  sRecvData := '';
  for i := 0 to nLength do
  begin
    if i > 0 then
      sRecvData := sRecvData + ' ';

    sRecvData := sRecvData + IntToHex(Arr[i]);
  end;

  sLogMsg := 'RecvData : ' + sRecvData;
  Global.Log.LogComReadMon(sLogMsg);

  if Arr[0] <> $47 then
  begin
    Global.Log.LogComReadMon('FCmdRecvBufArr[0] <> $47 Exit');
    Exit;
  end;

  cSum := $FF;
  for I := 11 to nLength - 1 do
  begin
    Temp := cSum;
    cSum := cSum + cSum;

    if Temp >= $80 then
      cSum := cSum + $01;

    cSum := Arr[I] xor cSum;
  end;

  if Arr[nLength] <> cSum then
  begin
    Global.Log.LogComReadMon('CRC error : ' + IntToHex(Arr[nLength]) + ' <> ' + IntToHex(cSum));
    Exit;
  end;

  {
  <전체 데이터 기준>
  1~8 Byte : gamedata (String)
  9번째 Byte : 레인번호
  10, 11번째 Byte : 데이터 길이 (12번째 Byte 부터 CRC까지)
  12번째 Byte : 레인번호
  13번째 Byte : 20(일반게임시 고정). 20<->28(리그게임시시 NEXT GAME 마다 바뀜???)
  14번째 Byte : 게임상태(A8=진행, 88=종료, 08=초기화상태?, E8=연습게임)
  15번째 Byte : 00=일반게임, 01=리그게임
  16번째 Byte : 00=일반게임, 01=369게임, 02=8핀게임, 03=9핀게임,
  17번째 Byte : ??       02??
  18번째 Byte : ??       연습게임잔여시간?
  19번째 Byte : 게이머 수
  20번째 Byte : 직전 투 게이머 번호
  21번째 Byte : ?? (0B명령으로 상태 설정)
  22번째 Byte : 전체 게이머 누적점수 (L Byte)
  23번째 Byte : 전체 게이머 누적점수 (H Byte)
  24번째 Byte :
  25번째 Byte :
  26번째 Byte : 직전 투 게이머 프레임 점수 (상위 4Byte. 순수 핀점수)
  27번째 Byte : 0A (고정?)

  응답은 2개 레인 정보가 동시에 들어온다.
  03번 레인 요청시 03번, 04번 레인 정보가 순서대로 들어온다.

  60Byte 부터 83Byte : 게이머 게임정보
  2인 이상의경우 추가 83Byte 씩 게이머 게임정보
  }
  nLength1 := Arr[9];
  nLength2 := Arr[10];
  nRecLength := (nLength1 * 256) + nLength2; //데이터 길이 (12번째 Byte 부터 CRC 이전까지)

  if (nLength + 1) <> (11 + nRecLength) then
  begin
    Global.Log.LogComReadMon('Length fail -> ' + intToStr(nLength + 1) + ' / ' + Inttostr(11 + nRecLength));
    Exit;
  end;

  rGameStatus.LaneNo := Arr[11];
  rGameStatus.b12 := Arr[12]; // 13번째 ????
  rGameStatus.Status := IntToHex(Arr[13], 2); //14번째 Byte : 게임상태(A8=진행, 88=종료)
  rGameStatus.League := Arr[14];
  rGameStatus.GameType := Arr[15];

  rGameStatus.BowlerCnt := Arr[18]; //19번째 Byte : 게이머 수
  rGameStatus.b19 := Arr[19]; //20번째 Byte : 직전 투 게이머 번호
  rGameStatus.b20 := Arr[20]; //21번째 ????
  rGameStatus.b26 := Arr[26]; //27번째 ????

  if (nRecLength > 49) and (rGameStatus.BowlerCnt > 0) then
  begin

    for nBowler := 0 to rGameStatus.BowlerCnt - 1 do
    begin
      nBoelerIdx := 59 + (nBowler * 83);

      for I := 0 to 82 do
      begin
        bGamerArr[I] := Arr[I + nBoelerIdx];
      end;

      sRecvData := '';
      for i := 0 to 82 do
      begin
        if i > 0 then
          sRecvData := sRecvData + ' ';

        sRecvData := sRecvData + IntToHex(bGamerArr[i]);
      end;
      sLogMsg := 'Bowler : ' + sRecvData;
      Global.Log.LogComReadMon(sLogMsg);

      if (bGamerArr[0] = $00) and (bGamerArr[1] = $00) then
      begin
        sLogMsg := 'Bowler nm error';
        Global.Log.LogComReadMon(sLogMsg);
        Exit;
      end;

      {
      <게이머 정보기준>
      1~32 Byte : 게이머 표기 이름 (1문자에 2Byte. 0~9. A~Z 상위 바이트에 표기, 한글표기는 완성형.)  30 00 -> '0', 20 00 -> ' ', E8 B1 = B1E8 (완성형 김)
      33번째 Byte 부터 1Byte 씩 (21Byte) : 게이머 투별 점수 (01~09 점수, 0A=스트라이크, 0B=스페어 클리어, 0C=스페어처리 허당) (상위 4비트 1000(0x80) 이면 정정된 점수). 21번째는 10프레임 마지막(3번째) 투
      54번째 Byte 부터 2Byte 씩 : 게이머 프레임 누적 점수
      74번째 Byte : GAME 누적 점수(L Byte)
      75번째 Byte : GAME 누적 점수(H Byte)
      76번째 Byte : 핸디
      77번째 Byte :
      78번째 Byte : 게이머 투 횟수 (스트라이크의 경우 +2), 10프레임 마지막 투는 더하지 않음. 진행중이 프레임수 유추 가능.
      79번째 Byte : 완료된 게임수.
      80번째 Byte : C0.E0=지금 투할 게이머(홀짝레인), 80.A0=대기(홀짝레인), 02(홀수).22(짝수) = 일시정지(강제).게임수 지정시 종료 게이머(남은게임 0일때).시간 지정시 남은 시간 0일때, 00(홀수레인)20(짝수레인) 당 게임완료
      81번째 Byte : 시간제 게임 남은 시간.(분)
      82번재 Byte : 게임수 지정시(선불) 남은 게임수.
      83번재 Byte : 0x20 = 선불(게임수지정시), 0x00 = 무제한(일반게임시). 0xA0=게임임종료(게임수지정시) , 0x80=게임종료(일반게임시)
      }

      //게이머 정보 성: FDataArr[60]FDataArr[59], 이름1: FDataArr[62]FDataArr[61], 이름2: FDataArr[64]FDataArr[63]
      //sGameInfo := char(FGamerArr[6]) + char(FGamerArr[8]) + char(FGamerArr[10]);
      //ABowlerInfo.BowlerNm := sGameInfo;

      for I := 0 to 20 do
      begin
        bByteTm := bGamerArr[I + 32];
        //if bByteTm >= $80 then
          //bByteTm := bByteTm - $80;
        bByteTm := bByteTm and $0F;

        // 11:X 12:/ 13:-
        if bByteTm = $0A then
          sFrame := 'X'
        else if bByteTm = $0B then
          sFrame := '/'
        else if bByteTm = $0C then
          sFrame := '-'
        else if bByteTm = $00 then
          sFrame := '0'
        else
          sFrame := IntToStr(bByteTm);

        rGameStatus.BowlerList[nBowler + 1].FramePin[I + 1] := sFrame;
      end;

      for I := 0 to 9 do
      begin
        nIndex := (I * 2) + 53;
        rGameStatus.BowlerList[nBowler + 1].FrameScore[I + 1] := bGamerArr[nIndex] + (bGamerArr[nIndex + 1] * 256);
      end;

      rGameStatus.BowlerList[nBowler + 1].TotalScore := bGamerArr[73] + (bGamerArr[74] * 256); //누적점수
      rGameStatus.BowlerList[nBowler + 1].ToCnt := bGamerArr[77]; //게이머 투 횟수
      rGameStatus.BowlerList[nBowler + 1].EndGameCnt := bGamerArr[78]; //완료된 게임수

      // 홀수레인:C0=지금 투할 게이머, 80=대기, 00=종료 / 짝수레인: E0=투할사람 A0=대기사람, 20=종료  , / 02 = 일시정지(강제)
      rGameStatus.BowlerList[nBowler + 1].Status1 := IntToHex(bGamerArr[79], 2);

      // 잔여시간
      rGameStatus.BowlerList[nBowler + 1].ResidualGameTime := bGamerArr[80];
      // 잔여게임수
      rGameStatus.BowlerList[nBowler + 1].ResidualGameCnt := bGamerArr[81];

      // 상태0x20 = 선불,  0xA0 = 선불게임종료, 0x00 = 무제한. 0x80 = 후불게임종료
      rGameStatus.BowlerList[nBowler + 1].Status3 := IntToHex(bGamerArr[82], 2);
    end;

  end;

  Global.Lane.SetLaneGameStatus(rGameStatus);
  Global.Log.LogComReadMon('rGameStatus');
  Setlength(Arr, 0);
end;

function TComThread.GetCRC(AIdx, AStart, AEnd: Integer): Integer;
var
  I: Integer;
  Temp, cSum: Byte;
begin

  cSum := $FF;
  for I := AStart to AEnd do
  begin
    Temp := cSum;
    cSum := cSum + cSum;

    if Temp >= $80 then
      cSum := cSum + $01;

    cSum := FCmdSendBufArr[AIdx].nDataArr[I] xor cSum;
  end;

  Result := cSum;
end;

function TComThread.SetNextMonNo: Boolean;
var
  bResult: Boolean;
begin
  //(상태 요청은 홀수번 레인(장치 ID)에 대해) - 응답은 홀수 레인 짝수 레인 연속해서 들어옴
  while True do
  begin
    inc(FLaneNoLast);
    if FLaneNoLast > FLaneNoEnd then
      FLaneNoLast := FLaneNoStart;

    bResult := Global.Lane.GetLaneInfoCtlYn(FLaneNoLast);
    if bResult = True then
      Break;
  end;
end;

function TComThread.SendPinSetterOnOff(ALaneNo: Integer; AUseYn: String): Boolean;
var
  nCrc: Byte;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 11 00 02 01 FE (1번레인 켜기)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 11 00 02 01 FE (5번레인 켜기)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 06 11 00 02 01 FE (6번레인 켜기)

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 11 00 02 03 FC (1번레인 끄기)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 11 00 02 03 FC (5번레인 끄기)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 06 11 00 02 03 FC (6번레인 끄기)

  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : Command 2
  18 Byte : CRC
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $11;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  if AUseYn = 'Y' then
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $01
  else
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $03;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '핀세터';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendMoniterOnOff(ALaneNo, AUseYn: String): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 15 00 02 01 FE (7번 레인 모니터 ON)
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 15 00 02 00 FF (7번 레인 모니터 OFF)

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := StrToInt(ALaneNo);

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $15;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  if AUseYn = 'Y' then
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $01
  else
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '모니터';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;

function TComThread.SendPinSettingNo(ALaneNo, ASetType: String): Boolean;
var
  nCrc: Byte;
begin
  // 핀세팅 1 (초구 세팅 - 쓰러뜨리고 다시 세팅)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 12 00 04 01 01 12 EB (1번레인 1번 핀세팅)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 12 00 04 01 03 12 EF (2번레인 1번 핀세팅)

  // 핀세팅 2 (스페어 세팅 - 서있는 핀만 잡고 올렸다 내리기)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 12 00 04 02 01 12 E7 (1번레인 2번 핀세팅)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 12 00 04 02 03 12 E3 (3번레인 2번 핀세팅)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 1,2 핀세팅 (Data)
  18 Byte : 레인번호
  19 Byte : Command 2
  20 Byte : CRC
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := StrToInt(ALaneNo);

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $12;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := StrToInt(ASetType);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := StrToInt(ALaneNo);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $12;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '핀세팅';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendBowlerPause(ALaneNo, ABowlerSeq: Integer; APauseYn: String): Boolean;
var
  nCrc: Byte;
begin
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 0E 00 03 01 01 FC (3번레인 1번 게이머 일시정지 ON)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 03 00 03 00 00 FF (3번레인 1번 게이머 일시정지 OFF)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 09 03 00 03 01 09 F4

  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 게이머 번호 (1~6)
  18 Byte : Command 2
  19 Byte : CRC
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;
  FCmdSendBufArr[FLastIdx].nDataArr[13] := $0E;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;
  if APauseYn = 'Y' then
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $01
  else
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $00;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '일시정지';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendInitLane(ALaneNo: String): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 09 00 04 01 01 09 F0 (게임정보 클리어)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17~19 Byte : Command 2
  20 Byte : CRC
  }
  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := StrToInt(ALaneNo);

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $09;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $01;
  //FCmdSendBufArr[FLastIdx].nDataArr[17] := $01;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := StrToInt(ALaneNo);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $09;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '레인초기화';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

{
function TComThread.SendLaneTemp(ALaneNo: String): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 0B 00 02 05 FA (???)
  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := StrToInt(ALaneNo);

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $0B;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $05;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '???';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;
}
function TComThread.SendLaneStatus(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 0B 00 02 05 FA (???)
  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $16;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ALaneNo;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := $16;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := 'Status';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;

function TComThread.SendGameCancel(ALaneNo: String): Boolean; //확인필요
var
  nCrc: Byte;
  i: integer;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 03 00 23 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FB
  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17~50 Byte : ???
  51 Byte : CRC
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := StrToInt(ALaneNo);

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $23;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $02;

  for i := 17 to 49 do
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[i] := $00;
  end;

  nCrc := GetCRC(FLastIdx, 16, 49);
  FCmdSendBufArr[FLastIdx].nDataArr[50] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 51;
  FCmdSendBufArr[FLastIdx].sType := '게임취소';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;


  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 0B 00 02 05 FA (???)
  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := StrToInt(ALaneNo);

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $0B;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $05;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '???';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;

function TComThread.SendLaneAssign(ALaneNo: Integer): Boolean;
begin
  //SendLaneAssignCtl(ALaneNo); //배정명령
  SendLaneAssignGameLeagueOpen(ALaneNo); // 오픈게임
  SendLaneAssignBowlerAdd(ALaneNo, 0); //볼러 추가
  //SendLaneAssignBowlerFin(ALaneNo); //추가 완료?
  SendPinSetterOnOff(ALaneNo, 'Y'); //핀세터 겨키
end;

function TComThread.SendLaneAssign_Competition(ALaneNo: Integer; ALeagueYn: String; ATrainMin: Integer): Boolean;
var
  bOdd: Boolean; //홀수
begin

  //대회모드
{
요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 87 01 00 04 01 07 01 F4		7번장치 리그게임 설정
응답     87 01 00 04

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 20 00 02 0A F5		7번레인 연습시간 10분
응답     07 20 00 02

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 01 00 04 02 07 01 E6		7번레인 연습게임 지정
응답     07 01 00 04

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 03 00 43 00 06 43 00 43 00 43 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 00 44 00 44 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A2	7번레인 게이머 등록
응답     07 03 00 43

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 07 00 02 01 FE		7번레인 게이머 정보 등록 완료
응답     07 07 00 02

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 20 00 02 0A F5		8번레인 연습시간 10분
응답     08 20 00 02

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 01 00 04 02 07 01 E6		8번레인 연습게임 지정
응답     08 01 00 04

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 03 00 43 00 06 43 00 43 00 43 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 00 44 00 44 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A2	8번레인 게이머 등록
응답     08 03 00 43

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 07 00 02 01 FE		8번레인 게이머 정보 등록 완료
응답     08 07 00 02

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 11 00 02 01 FE    (7번레인 장치켜기)
응답     07 11 00 02

요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 11 00 02 01 FE    (8번레인 장치켜기)
응답     08 11 00 02

// 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 87 08 00 05 01 07 01 08 E3 리그게임next
}

  if ALeagueYn = 'Y' then
  begin
    bOdd := odd(ALaneNo); //홀수 여부
    if bOdd = True then
      SendLaneAssignGameLeague(ALaneNo, 'Y'); //리그게임
  end;

  if ATrainMin > 0 then
  begin
    SendLaneAssignGameTraining(ALaneNo, ATrainMin); //연습게임
    SendLaneAssignGameTrainingFin(ALaneNo);
  end;

  SendLaneAssignBowlerAdd(ALaneNo, 0); //볼러 추가
  //SendLaneAssignBowlerFin(ALaneNo); //추가 완료?
  SendLaneAssignGameBowlerHandy(ALaneNo); //핸디-0:초기화, 1~255까지
  SendPinSetterOnOff(ALaneNo, 'Y'); //핀세터 겨키
end;

function TComThread.SendLaneAssignCtl(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
  nNo: Integer;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 01 00 04 00 01 01 FC  (1번 장치 게이머 배정 명령) 1,2번 레인 게이머 등록시
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 85 01 00 04 00 05 01 F4  (5번 장치 게이머 배정 명령) 5,6번 레인 게이머 등록시
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 01 00 04 00 03 01 F8  (3번 장치 게이머 배정 명령) 3,4번 레인 게이머 등록시

  {
  2~11 Byte : PosCommand (String)
  12 Byte : STX (Command Start)
  13 Byte : (0x80 + 레인번호)
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : ??
  18 Byte : 레인번호
  19 Byte : Command 2
  20 Byte : CRC
  }
  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  if ( ALaneNo mod 2) = 1 then
    nNo := ALaneNo
  else
    nNo := ALaneNo - 1;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + nNo;  // 장치기준

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $01; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := ALaneNo;
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $01;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '배정명령';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;

function TComThread.SendLaneAssignBowlerAdd(ALaneNo, ABowlerSeq: Integer): Boolean;
var
  nCrc, nTemp: Byte;
  Assign: TAssignInfo;
  nBowlerCnt, nBowlerSeq: Integer;
  i, j, nIdx, nBIdx: Integer;
  sTemp: AnsiString;
  sNm: String;
  nNmCnt: Integer;
begin
  Assign := Global.Lane.GetAssignInfo(ALaneNo);

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 03 00 23 02 00 30 00 31 00 41 00 20 00 30 00 30 00 20 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E0 (1번레인 게이머 정보 전송) | 게이머 1 정보 |CRC
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 03 00 43 06 00 30 00 35 00 41 00 20 00 31 00 31 00 20 00 31 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 35 00 42 00 20 00 31 00 31 00 20 00 31 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 EB (5번레인 게이머 정보 전송) | 게이머 1 정보 | 게이머 2 정보 |CRC
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 04 03 00 43 00 06 30 00 34 00 41 00 20 00 31 00 31 00 20 00 31 00 31 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 34 00 42 00 20 00 31 00 31 00 20 00 31 00 31 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E1 (4번레인 게이머 정보 전송) | 게이머 1 정보 | 게이머 2 정보 |CRC
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 03 00 63 0E 00 30 00 33 00 41 00 20 00 31 00 31 00 20 00 31 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 33 00 42 00 20 00 31 00 31 00 20 00 31 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 33 00 43 00 20 00 31 00 31 00 20 00 31 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 99 (3번레인 게이머 정보 전송) | 게이머 1 정보 | 게이머 2 정보 | 게이머 3 정보 |CRC

  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 홀수번 레인 게이머 INDEX
             1번 게이머. 2번 Bit (0000 0010)
             2번 게이머. 3번 Bit (0000 0100)
             3번 게이머. 4번 Bit (0000 1000)
  신규로 3명 등록하면 0000 1110 (0x0E)
  18 Byte : 짝수번 레인 게이머 INDEX
             1번 게이머. 2번 Bit (0000 0010)
             2번 게이머. 3번 Bit (0000 0100)
             3번 게이머. 4번 Bit (0000 1000)
  신규로 3명 등록하면 0000 1110 (0x0E)

  19~ 50 Byte : 게이머이름 (2명 이상일때 19~ 50 Byte 반복)
  END Byte : CRC
  }

  nBowlerCnt := 0;
  if ABowlerSeq = 0 then
  begin
    nBowlerCnt := Assign.BowlerCnt;
    nBowlerSeq := nBowlerCnt;

    sTemp := '0';
    for i := 1 to nBowlerCnt do
    begin
      sTemp := '1' + sTemp;
    end;
    sTemp := StrZeroAdd(sTemp, 8);
    nTemp := Bin2Dec(sTemp);
  end
  else
  begin
    nBowlerCnt := 1;
    nBowlerSeq := ABowlerSeq;

    sTemp := '0';
    for i := 1 to 7 do
    begin
      if i = nBowlerSeq then
        sTemp := '1' + sTemp
      else
        sTemp := '0' + sTemp;
    end;
    //sTemp := StrZeroAdd(sTemp, 8);
    nTemp := Bin2Dec(sTemp);
  end;
  {
  for i := 1 to 6 do
  begin
    if Assign.GameInfo[i].BowlerId = '' then
      Break;

    inc(nBowlerCnt);
  end;
  }
  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $03; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := (32 * nBowlerCnt) +3;

  if ( ALaneNo mod 2) = 1 then
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := nTemp;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $00;
  end
  else
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := nTemp;
  end;

  //32 사용자정보
  nIdx := 17;
  for i := 1 to nBowlerCnt do
  begin
    if ABowlerSeq = 0 then
      nBIdx := i
    else
      nBIdx := ABowlerSeq;

    sNm := Assign.BowlerList[nBIdx].BowlerNm;
    {
    if Assign.BowlerList[nBIdx].ShoesYn = 'Y' then
      sNm := sNm + ' 11'
    else
      sNm := sNm + ' 01';
    }

    if Assign.BowlerList[nBIdx].ShoesYn = 'Y' then
      sNm := sNm + ' 1'
    else
      sNm := sNm + ' 0';

    sNm := sNm + Copy(Assign.BowlerList[nBIdx].FeeDiv, 2, 1);

    nNmCnt := Length(sNm);

    for j := 1 to nNmCnt do
    begin
      sTemp := ansistring(Copy(sNm, j, 1));
      if Length(sTemp) > 1 then
      begin
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[2]);
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[1]);
      end
      else
      begin
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[1]);
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := 0;
      end;
    end;

    nNmCnt := 32 - (nNmCnt * 2);
    for j := 1 to nNmCnt do
    begin
      inc(nidx);
      FCmdSendBufArr[FLastIdx].nDataArr[nidx + 1] := $00;
    end;

  end;

  nCrc := GetCRC(FLastIdx, 16, nIdx);
  FCmdSendBufArr[FLastIdx].nDataArr[nIdx + 1] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := nIdx + 2;
  FCmdSendBufArr[FLastIdx].sType := '사용자정보';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneCompetitionBowlerAdd(ALaneNo, ABowlerCnt: Integer): Boolean;
var
  nCrc, nTemp: Byte;
  Assign: TAssignInfo;
  nBowlerCnt, nBowlerSeq: Integer;
  i, j, nIdx, nBIdx: Integer;
  sTemp: AnsiString;
  sNm: String;
  nNmCnt: Integer;
begin
  Assign := Global.Lane.GetAssignInfo(ALaneNo);

  if ABowlerCnt > Assign.BowlerCnt then
    nBowlerCnt := ABowlerCnt
  else
    nBowlerCnt := Assign.BowlerCnt;

  sTemp := '0';
  for i := 1 to nBowlerCnt do
  begin
    sTemp := '1' + sTemp;
  end;
  sTemp := StrZeroAdd(sTemp, 8);
  nTemp := Bin2Dec(sTemp);

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $03; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := (32 * nBowlerCnt) +3;

  if ( ALaneNo mod 2) = 1 then
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := nTemp;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $00;
  end
  else
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := nTemp;
  end;

  //32 사용자정보
  nIdx := 17;
  for i := 1 to nBowlerCnt do
  begin
    nBIdx := i;

    sNm := Assign.BowlerList[nBIdx].BowlerNm;

    if sNm <> '' then
    begin
    {
    if Assign.BowlerList[nBIdx].ShoesYn = 'Y' then
      sNm := sNm + ' 11'
    else
      sNm := sNm + ' 01';
    }
    if Assign.BowlerList[nBIdx].ShoesYn = 'Y' then
      sNm := sNm + ' 1'
    else
      sNm := sNm + ' 0';

    sNm := sNm + Copy(Assign.BowlerList[nBIdx].FeeDiv, 2, 1);
    end;

    nNmCnt := Length(sNm);

    for j := 1 to nNmCnt do
    begin
      sTemp := ansistring(Copy(sNm, j, 1));
      if Length(sTemp) > 1 then
      begin
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[2]);
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[1]);
      end
      else
      begin
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[1]);
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := 0;
      end;
    end;

    nNmCnt := 32 - (nNmCnt * 2);
    for j := 1 to nNmCnt do
    begin
      inc(nidx);
      FCmdSendBufArr[FLastIdx].nDataArr[nidx + 1] := $00;
    end;

  end;

  nCrc := GetCRC(FLastIdx, 16, nIdx);
  FCmdSendBufArr[FLastIdx].nDataArr[nIdx + 1] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := nIdx + 2;
  FCmdSendBufArr[FLastIdx].sType := '사용자정보';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneCompetitionBowlerAddTemp(ALaneNo, ABowlerCnt: Integer): Boolean;
var
  nCrc, nTemp: Byte;
  nBowlerCnt: Integer;
  i, j, nIdx, nBIdx: Integer;
  sTemp: AnsiString;
  sNm: String;
  nNmCnt: Integer;
begin

  nBowlerCnt := 3;

  sTemp := '0';
  for i := 1 to nBowlerCnt do
  begin
    sTemp := '1' + sTemp;
  end;
  sTemp := StrZeroAdd(sTemp, 8);
  nTemp := Bin2Dec(sTemp);

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $03; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := (32 * nBowlerCnt) +3;

  if ( ALaneNo mod 2) = 1 then
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := nTemp;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $00;
  end
  else
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := nTemp;
  end;

  //32 사용자정보
  nIdx := 17;
  for i := 1 to nBowlerCnt do
  begin
    nBIdx := i;

    if i = 1 then
      sNm := 'AAA'
    else if i = 2 then
      sNm := 'BBB'
    else
    begin
      if ABowlerCnt = 3 then
        sNm := 'CCC'
      else
        sNm := '';
    end;

    nNmCnt := Length(sNm);

    for j := 1 to nNmCnt do
    begin
      sTemp := ansistring(Copy(sNm, j, 1));
      if Length(sTemp) > 1 then
      begin
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[2]);
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[1]);
      end
      else
      begin
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := ord(sTemp[1]);
        inc(nidx);
        FCmdSendBufArr[FLastIdx].nDataArr[nidx] := 0;
      end;
    end;

    nNmCnt := 32 - (nNmCnt * 2);
    for j := 1 to nNmCnt do
    begin
      inc(nidx);
      FCmdSendBufArr[FLastIdx].nDataArr[nidx + 1] := $00;
    end;

  end;

  nCrc := GetCRC(FLastIdx, 16, nIdx);
  FCmdSendBufArr[FLastIdx].nDataArr[nIdx + 1] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := nIdx + 2;
  FCmdSendBufArr[FLastIdx].sType := '사용자정보';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;
{
function TComThread.SendLaneAssignBowlerFin(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 07 00 02 01 FE (게이머 정보 등록 또는 수정후 보내는 명령 ??)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 07 00 02 01 FE
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 04 07 00 02 01 FE

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $07; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $01;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '정보등록';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;
}
function TComThread.SendLaneAssignBowlerDel(ALaneNo, ABowlerSeq: Integer): Boolean;
var
  nCrc, nTemp: Byte;
  i: Integer;
  sTemp: AnsiString;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 03 00 23 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F7 (1번 레인 2번 게이머 빼기)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 02 03 00 23 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FB (2번 레인 2번 게이머 빼기)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 홀수레인 게이머순번
             1번 게이머. 2번 Bit (0000 0010)
             2번 게이머. 3번 Bit (0000 0100)
             3번 게이머. 4번 Bit (0000 1000)
  18 Byte : 짝수레인 게이머순번
             1번 게이머. 2번 Bit (0000 0010)
             2번 게이머. 3번 Bit (0000 0100)
             3번 게이머. 4번 Bit (0000 1000)
  19~50Byte : 게이머 이름정보 클리어.
  51 Byte : CRC
  ※ 게임 중에 게이머 빼도 동일.
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $03; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $23;

  sTemp := '0';
  for i := 1 to 7 do
  begin
    if i = ABowlerSeq then
      sTemp := '1' + sTemp
    else
      sTemp := '0' + sTemp;
  end;
  //sTemp := StrZeroAdd(sTemp, 8);
  nTemp := Bin2Dec(sTemp);

  if ( ALaneNo mod 2) = 1 then
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := nTemp;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $00;
  end
  else
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;
    FCmdSendBufArr[FLastIdx].nDataArr[17] := nTemp;
  end;

  for i := 18 to 49 do
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[i] := $00;
  end;

  nCrc := GetCRC(FLastIdx, 16, 49);
  FCmdSendBufArr[FLastIdx].nDataArr[50] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 51;
  FCmdSendBufArr[FLastIdx].sType := '사용자제거';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignBowlerGameCnt(ALaneNo, ABowlerSeq, AGameCnt: Integer): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 1E 00 03 02 02 F9 (1번 레인 2번 사용자 2게임)
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 1E 00 07 01 01 02 01 03 04 D9  [1번게이머 1게임, 2번게이머 1게임, 3번게이머 4게임] -> 한번에 보낸는것 검토 필요
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : 게이머 번호
  //  18 Byte : 게임수
  // 게이머순번(17).게임수(18) 게이머 수 만큼 반복
  // -> 응답     01 1E 00 07

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $1E; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := AGameCnt;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '게임수';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignBowlerGameCntSet(ALaneNo, ABowlerSeq: Integer): Boolean; //게임수 지정후 장치에 적용
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 21 00 03 01 20 DD  [1번게이머 선불(게임수지정] 으로 상태변경] -> 응답     01 21 00 03
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 21 00 03 02 20 DB  [2번게이머 선불(게임수지정] 으로 상태변경] -> 응답     01 21 00 03
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 21 00 03 03 20 D9  [3번게이머 선불(게임수지정] 으로 상태변경] -> 응답     01 21 00 03

  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : 게이머 번호
  //  18 Byte : Command 2

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $21; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := $20;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '게임수적용';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignBowlerGameTime(ALaneNo, ABowlerSeq, AGameTime: Integer): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 1F 00 05 01 05 02 0A D1	[시간배정] - 1번 5(05)분, 2번 10(0A)분 -> 응답     07 1F 00 05
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : 게이머 번호
  //  18 Byte : 시간
  // 게이머순번(17).게임수(18) 게이머 수 만큼 반복

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $1F; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := AGameTime;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '게임시간';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignBowlerPause(ALaneNo, ABowlerSeq, APause: Integer): Boolean;
var
  nCrc: Byte;
begin
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 0E 00 03 01 01 FC (3번레인 1번 게이머 일시정지 ON)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 03 00 03 00 00 FF (3번레인 1번 게이머 일시정지 OFF)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 게이머 번호 (1~6)
  18 Byte : Command 2
  19 Byte : CRC
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  //14 Byte : Command 1
  if APause = 1 then //일시정지
    FCmdSendBufArr[FLastIdx].nDataArr[13] := $0E
  else
    FCmdSendBufArr[FLastIdx].nDataArr[13] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := APause;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '일시정지';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameLeague(ALaneNo: Integer; AUse: String): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 01 00 04 01 01 01 F8		[리그게임 설정]
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 01 00 04 00 01 01 FC		[리그게임 설정 해제]
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 01 00 04 00 03 01 F8		[오픈게임 설정 명령] - 레인 상태 특이 사항 없음. 응답     83 01 00 04
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : 설정
  //  18 Byte : Command 2
  //  18 Byte : Command 3

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // 장치기준

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $01; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  if AUse = 'Y' then
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $01
  else
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;

  FCmdSendBufArr[FLastIdx].nDataArr[17] := $01;
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $01;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '리그설정';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameLeagueOpen(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 01 00 04 00 03 01 F8		[오픈게임 설정 명령] - 레인 상태 특이 사항 없음. 응답     83 01 00 04
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : ?
  //  18 Byte : ?
  //  19 Byte : ?

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // 장치기준

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $01; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;

  FCmdSendBufArr[FLastIdx].nDataArr[17] := ALaneNo;
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $01;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '오픈게임설정';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignGameType(ALaneNo: Integer; AGameType: String): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 02 FD		[8핀게임 설정] 응답     81 02 00 02
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 03 FC		[9핀게임 설정] 응답     81 02 00 02
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 01 FE		[369게임 설정] 응답     81 02 00 02
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 00 FF		[8, 9, 369 게임 설정 해제] 응답     81 02 00 02

  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : Command 2

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // 장치기준

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $02; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  if AGameType = '10' then
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $00
  else if AGameType = '8' then
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $02
  else if AGameType = '9' then
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $03
  else if AGameType = '369' then
    FCmdSendBufArr[FLastIdx].nDataArr[16] := $01;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '기타게임설정';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameTypeFin(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 07 00 02 01 FE		[설정 완료]

  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : Command 2

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // 장치기준

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $07; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;


    FCmdSendBufArr[FLastIdx].nDataArr[16] := $01;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '기타게임설정해제';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignGameBowlerHandy(ALaneNo: Integer): Boolean;

var
  Assign: TAssignInfo;
  i: Integer;
begin
  Assign := Global.Lane.GetAssignInfo(ALaneNo);

  for i := 1 to Assign.BowlerCnt do
  begin
    if Assign.BowlerList[i].Handy > 0 then
      SendLaneAssignGameHandy(ALaneNo, i, Assign.BowlerList[i].Handy);
  end;
end;


function TComThread.SendLaneAssignGameHandy(ALaneNo, ABowlerSeq, AHandy: Integer): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 09 05 00 03 01 0F F2
  // 2~11 Byte : PosCommand (String)
  // 13 Byte : 레인번호
  // 14 Byte : Command 1 (핸디명령)
  // 15~16 Byte : Data Length
  // 17 Byte : Command 2 (순번)
  // 18 Byte : 핸디점수
  // 19 Byte : CRC


  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;  // 장치기준

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $05; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;

  FCmdSendBufArr[FLastIdx].nDataArr[17] := AHandy;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '핸디설정';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameTraining(ALaneNo, ATime: Integer): Boolean;
var
  nCrc: Byte;
begin
  // 요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 20 00 02 0A F5		7번레인 연습시간 10분
  // 응답     07 20 00 02

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $20; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ATime;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '연습게임';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameTrainingFin(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin
  //요청     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 01 00 04 02 07 01 E6		7번레인 연습게임 지정
  //응답     07 01 00 04

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $01; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $02;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[18] := $01;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '연습게임지정';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameScoreChange(ALaneNo, ABowlerSeq: Integer; AFrame: String): Boolean;
var
  nCrc, nDataIdx: Byte;
  //rBowlerStatus: TBowlerStatus;
  I: Integer;
  sFrameTm, sFrame: String;
begin
  // 사용자 점수수정
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 0C 00 18 01 FF 89 8B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 84
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : 레인번호
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : 게이머 번호 (등록 또는 삭제 일때랑 게이머 번호 부여 방식 다름)
  //  18 Byte : ???
  //  19~20 Byte : 1프레임. 1번 투 9핀 쓰러짐. 2번투 스페어처리
  //  21~22 Byte : 2프레임.
  //  23~24 Byte : 3프레임.
  //  25~26 Byte : 4프레임.
  //  27~28 Byte : 5프레임.
  //  29~30 Byte : 6프레임.
  //  31~32 Byte : 7프레임.
  //  33~34 Byte : 8프레임.
  //  35~36 Byte : 9프레임.
  //  37~38 Byte : 10프레임.
  //  39 Byte : ??
  //  40 Byte : CRC

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 0C 00 18 01 FF 8A 00 8A 00 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AF
  // 17 Byte : 1번 사용자
  // 19~20 Byte : 1프레임. 1번 투 스트라이크
  // 21~22 Byte : 2프레임. 1번 투 스트라이크
  // 23~24 Byte : 3프레임. 1번 투 9핀 쓰러짐. 2번 투 노 스패어 처리
  // 25~26 Byte : 4프레임. 1번 투 스트라이크

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 0C 00 18 02 FF 87 8C 88 8C 89 8C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 68
  // 17 Byte : 2번 사용자
  // 19~20 Byte : 1프레임. 1번 투 7핀 쓰러짐. 2번 투 노 스패어 처리
  // 21~22 Byte : 2프레임. 1번 투 8핀 쓰러짐. 2번 투 노 스패어 처리
  // 23~24 Byte : 3프레임. 1번 투 9핀 쓰러짐. 2번 투 노 스패어 처리

  // B:스페어, A:스트라이크, C:노스페어

  //rBowlerStatus := Global.Lane.GetGameBowlerStatus(StrToInt(ALaneNo), StrToInt(ABowlerSeq));

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $0C;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $18;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq; // 사용자 번호

  FCmdSendBufArr[FLastIdx].nDataArr[17] := $FF; // ????

  for I := 1 to 21 do
  begin
    sFrameTm := Copy(AFrame, I, 1);
    // 11:X 12:/ 13:-
    if sFrameTm = 'X' then
      sFrame := 'A'
    else if sFrameTm = '/' then
      sFrame := 'B'
    else if sFrameTm = '-' then
      sFrame := 'C'
    else if sFrameTm = ' ' then
      sFrame := '0'
    else
      sFrame := sFrameTm;

    FCmdSendBufArr[FLastIdx].nDataArr[I + 17] := StrToInt('$8' + sFrame);
  end;

  nCrc := GetCRC(FLastIdx, 16, 38);
  FCmdSendBufArr[FLastIdx].nDataArr[39] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 40;
  FCmdSendBufArr[FLastIdx].sType := '점수수정';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameNext(ALaneNo: Integer; ALeagueYn: String): Boolean;
var
  nCrc: Byte;
begin
  // 강제 NEXT (새 게임) (3프레임 이하는 미과금, 4프레임 이상은 과금. 업소마다 차이 있음. 데이터는 굳이 남기지 않아도 됨.)
 	// 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 08 00 05 01 07 00 08 E3
  // 2~11 Byte : PosCommand (String)
  // 13 Byte : (0x80 + 레인번호)
  // 14 Byte : Command 1
  // 15~16 Byte : Data Length
  // 17 Byte : Command 2
  // 18 Byte : 레인번호
  // 19 Byte : 일반게임시(00). 리그게임시(01)
  // 20 Byte : Command 3
  // 21 Byte : CRC

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  if ALeagueYn = 'Y' then
    FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo
  else
    FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $08;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $05;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $01;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := ALaneNo;

  if ALeagueYn = 'Y' then
    FCmdSendBufArr[FLastIdx].nDataArr[18] := $01
  else
    FCmdSendBufArr[FLastIdx].nDataArr[18] := $00;

  FCmdSendBufArr[FLastIdx].nDataArr[19] := $08;

  nCrc := GetCRC(FLastIdx, 16, 19);
  FCmdSendBufArr[FLastIdx].nDataArr[20] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 21;
  FCmdSendBufArr[FLastIdx].sType := '강제NEXT';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameEnd(ALaneNo, ABowlerSeq: Integer; AType: String): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 21 00 03 01 80 7D - 일반
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 21 00 03 01 A0 5D (명령어 분석 필요) - 선불제
  {
  2~11 Byte : PosCommand (String)
  13 Byte : (0x80 + 레인번호)
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 게이머 번호.
  18 Byte : Command 2
  19 Byte : CRC
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $21;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;

  if AType = '0' then  // 0:오픈, 1:게임수
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $80
  else
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $A0;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '게임종료지정';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameRestore(ALaneNo, ABowlerSeq: String): Boolean; //이전게임복구
var
  nCrc: Byte;
begin
  //게이머 1명
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 17 00 84 07 20 A8 00 00 02 00 01 01 05 43 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //30 00 37 00 41 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8A 00 8A 00 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1D 00 30 00 39 00 43 00 00 00 00 00 00 00 00 00 00 00 00 00 43 00 00 00 08 00 C0 00 00 80 D7

  //게이머 2명
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 17 00 D7 07 20 A8 00 00 02 00 02 01 05 65 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //30 00 37 00 41 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8A 00 8A 00 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1D 00 30 00 39 00 43 00 00 00 00 00 00 00 00 00 00 00 00 00 43 00 00 00 08 00 C0 00 00 80
  //30 00 37 00 42 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 87 8C 88 8C 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 00 0F 00 18 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00 22 00 00 00 08 00 80 00 00 80 E7

  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17~19 Byte : 레인번호
  24 Byte : 게이머수
  25 Byte :
  27 Byte : 전체 게이머 TOT 점수
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := StrToInt(ALaneNo);

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $17;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $84;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $07; //17~19 Byte : 레인번호 -> ??????
  FCmdSendBufArr[FLastIdx].nDataArr[17] := $20;
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $A8;

  FCmdSendBufArr[FLastIdx].nDataArr[19] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[20] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[21] := $02;
  FCmdSendBufArr[FLastIdx].nDataArr[22] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[23] := $01;
  FCmdSendBufArr[FLastIdx].nDataArr[24] := $01;
  FCmdSendBufArr[FLastIdx].nDataArr[25] := $05;
  FCmdSendBufArr[FLastIdx].nDataArr[26] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[27] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[28] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[29] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[30] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[31] := $0A;
  FCmdSendBufArr[FLastIdx].nDataArr[32] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[33] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[34] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[35] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[36] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[37] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[38] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[39] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[40] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[41] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[42] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[43] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[44] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[45] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[46] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[47] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[48] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[49] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[50] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[51] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[52] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[53] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[54] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[55] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[56] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[57] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[58] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[59] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[60] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[61] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[62] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[63] := $00;

  //게이머 정보 - 이동시 데이타와 비슷

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '이전게임복구';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignMove(ALaneNo, ATargetLaneNo: Integer): Boolean;
var
  sSendData, sBcc: AnsiString;
  sSeatTime, sSeatBall: AnsiString;
  rGame: TGameStatus;
  nLength, nScore, nDiv, nMod, i: Integer;
  nBowler, nBowlerIdx: Integer;
  nByteTm: Byte;
  nCrc: Byte;

  sTemp: AnsiString;
  sNm: String;
  nNmCnt: Integer;

  Assign: TAssignInfo;
begin
  rGame := Global.Lane.GetGameStatus(ALaneNo);

  Assign := Global.Lane.GetAssignInfo(ALaneNo);

  //2~11 Byte : PosCommand (String)
  //13 Byte : 레인번호
  //14 Byte : Command 1
  //15~16 Byte : Data Length
  //17~64 Byte : 레인의 게임정보
  //65~ Byte : 게이머 게임정보

  //사용자 정보 83 byte
  // (64 - 16) + 83 * n + 1 = 215(D7)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 09 17 00 D7 07 20 A8 00 00 02 00 02 01 05 65 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //30 00 37 00 41 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //8A 00 8A 00 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1D 00 30 00 39 00 43 00 00 00 00 00 00 00 00 00 00 00 00 00 43 00 00 00 08 00 C0 00 00 80
  //30 00 37 00 42 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //87 8C 88 8C 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 00 0F 00 18 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00 22 00 00 00 08 00 80 00 00 80 E7

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ATargetLaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $17;

  nLength := 48 + (83 * rGame.BowlerCnt) + 1;
  if nLength > 256 then
  begin
    nDiv := nLength div 256;
    nMod := nLength mod 256;
    FCmdSendBufArr[FLastIdx].nDataArr[14] := nDiv; // Data Length
    FCmdSendBufArr[FLastIdx].nDataArr[15] := nMod;
  end
  else
  begin
    FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
    FCmdSendBufArr[FLastIdx].nDataArr[15] := nLength;
  end;

  //17~64 Byte : 레인의 게임정보->????
  FCmdSendBufArr[FLastIdx].nDataArr[16] := ATargetLaneNo;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := rGame.b12;
  FCmdSendBufArr[FLastIdx].nDataArr[18] := StrToInt('$' + rGame.Status);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := rGame.League;
  FCmdSendBufArr[FLastIdx].nDataArr[20] := rGame.GameType;
  FCmdSendBufArr[FLastIdx].nDataArr[21] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[22] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[23] := rGame.BowlerCnt;
  FCmdSendBufArr[FLastIdx].nDataArr[24] := rGame.b19;
  FCmdSendBufArr[FLastIdx].nDataArr[25] := rGame.b20;
  FCmdSendBufArr[FLastIdx].nDataArr[26] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[27] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[28] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[29] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[30] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[31] := rGame.b26;
  FCmdSendBufArr[FLastIdx].nDataArr[32] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[33] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[34] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[35] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[36] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[37] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[38] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[39] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[40] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[41] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[42] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[43] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[44] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[45] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[46] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[47] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[48] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[49] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[50] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[51] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[52] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[53] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[54] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[55] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[56] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[57] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[58] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[59] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[60] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[61] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[62] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[63] := $00;

  for nBowler := 0 to rGame.BowlerCnt - 1 do
  begin
    nBowlerIdx := 63 + (nBowler * 83);

    sNm := rGame.BowlerList[nBowler + 1].BowlerNm;

    if Assign.BowlerList[nBowler + 1].ShoesYn = 'Y' then
      sNm := sNm + ' 1' //sNm := sNm + ' 11'
    else
      sNm := sNm + ' 0'; //sNm := sNm + ' 01';

    sNm := sNm + Copy(Assign.BowlerList[nBowler + 1].FeeDiv, 2, 1);

    nNmCnt := Length(sNm);

    for I := 1 to nNmCnt do
    begin
      sTemp := ansistring(Copy(sNm, I, 1));
      if Length(sTemp) > 1 then
      begin
        inc(nBowlerIdx);
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := ord(sTemp[2]);
        inc(nBowlerIdx);
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := ord(sTemp[1]);
      end
      else
      begin
        inc(nBowlerIdx);
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := ord(sTemp[1]);
        inc(nBowlerIdx);
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
      end;
    end;

    nNmCnt := 32 - (nNmCnt * 2);
    for I := 1 to nNmCnt do
    begin
      inc(nBowlerIdx);
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;
    end;

    for I := 1 to 21 do
    begin
      // 11:X 12:/ 13:-
      if rGame.BowlerList[nBowler + 1].FramePin[I] = 'X' then
        nByteTm := $0A
      else if rGame.BowlerList[nBowler + 1].FramePin[I] = '/' then
        nByteTm := $0B
      else if rGame.BowlerList[nBowler + 1].FramePin[I] = '-' then
        nByteTm := $0C
      else if rGame.BowlerList[nBowler + 1].FramePin[I] = '' then
        nByteTm := $00
      else
        nByteTm := StrToInt(rGame.BowlerList[nBowler + 1].FramePin[I]);

      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx + I] := nByteTm;
    end;

    nBowlerIdx := nBowlerIdx + 21;
    for I := 1 to 10 do
    begin
      nScore := rGame.BowlerList[nBowler + 1].FrameScore[I];
      if nScore > 256 then
      begin
        nDiv := nScore div 256;
        nMod := nScore mod 256;

        nBowlerIdx := nBowlerIdx + 1;
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nMod;
        nBowlerIdx := nBowlerIdx + 1;
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nDiv;
      end
      else
      begin
        nBowlerIdx := nBowlerIdx + 1;
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nScore;
        nBowlerIdx := nBowlerIdx + 1;
        FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
      end;
    end;

    nScore := rGame.BowlerList[nBowler + 1].TotalScore;
    if nScore > 256 then
    begin
      nDiv := nScore div 256;
      nMod := nScore mod 256;

      nBowlerIdx := nBowlerIdx + 1;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nMod;
      nBowlerIdx := nBowlerIdx + 1;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nDiv;
    end
    else
    begin
      nBowlerIdx := nBowlerIdx + 1;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nScore;
      nBowlerIdx := nBowlerIdx + 1;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
    end;
    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;
    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;

    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].ToCnt; //게이머 투 횟수
    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].EndGameCnt; //완료된 게임수

    // C0=지금 투할 게이머, 80=대기, 02 = 일시정지(강제), 20=일시정지(리그), E0=?
    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := StrToInt('$' + rGame.BowlerList[nBowler + 1].Status1);

    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].ResidualGameTime;

    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].ResidualGameCnt; //잔여게임수

    nBowlerIdx := nBowlerIdx + 1;
    // 상태(00=, 80=종료.모든게이머 게임완료시)
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := StrToInt('$' + rGame.BowlerList[nBowler + 1].Status3);
  end;

  nCrc := GetCRC(FLastIdx, 16, nBowlerIdx);
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx + 1] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := nBowlerIdx + 2;
  FCmdSendBufArr[FLastIdx].sType := '이동';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;


function TComThread.SendLaneAssignMoveBowler(ALaneNo, ABowlerSeq: Integer; ABowlerNm: String): Boolean;
var
  sSendData, sBcc: AnsiString;
  sSeatTime, sSeatBall: AnsiString;
  rBowlerStatus: TBowlerStatus;
  nLength, nScore, nDiv, nMod, i: Integer;
  nBowler, nBowlerIdx: Integer;
  nByteTm: Byte;
  nCrc: Byte;

  sTemp: AnsiString;
  sNm: String;
  nNmCnt: Integer;
begin

  rBowlerStatus := Global.Lane.GetGameBowlerStatus(ALaneNo, ABowlerSeq);

  //2~11 Byte : PosCommand (String)
  //13 Byte : 레인번호
  //14 Byte : Command 1
  //15~16 Byte : Data Length
  //17~ Byte : 게이머 게임정보. 게임 시작전이어도 게이머 모든 정보(점수) 이동

  //사용자 정보 83 byte
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 04 31 00 54
  //30 00 33 00 42 00 20 00 31 00 31 00 20 00 31 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 00 A8

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $31;

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $54;

  //17~ Byte : 게이머 게임정보
  nBowlerIdx := 15;

  sNm := ABowlerNm;
  nNmCnt := Length(sNm);

  for I := 1 to nNmCnt do
  begin
    sTemp := ansistring(Copy(sNm, I, 1));
    if Length(sTemp) > 1 then
    begin
      inc(nBowlerIdx);
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := ord(sTemp[2]);
      inc(nBowlerIdx);
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := ord(sTemp[1]);
    end
    else
    begin
      inc(nBowlerIdx);
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := ord(sTemp[1]);
      inc(nBowlerIdx);
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
    end;
  end;

  nNmCnt := 32 - (nNmCnt * 2);
  for I := 1 to nNmCnt do
  begin
    inc(nBowlerIdx);
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;
  end;

  for I := 1 to 21 do
  begin
    // 11:X 12:/ 13:-
    if rBowlerStatus.FramePin[I] = 'X' then
      nByteTm := $8A
      //nByteTm := $0A
    else if rBowlerStatus.FramePin[I] = '/' then
      nByteTm := $8B
      //nByteTm := $0B
    else if rBowlerStatus.FramePin[I] = '-' then
      nByteTm := $8C
      //nByteTm := $0C
    else if rBowlerStatus.FramePin[I] = '' then
      nByteTm := $00
    else
      nByteTm := StrToInt('$8' + rBowlerStatus.FramePin[I]);
      //nByteTm := StrToInt(rBowlerStatus.FramePin[I]);

    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx + I] := nByteTm;
  end;

  nBowlerIdx := nBowlerIdx + 21;
  for I := 1 to 10 do
  begin
    nScore := rBowlerStatus.FrameScore[I];
    if nScore > 256 then
    begin
      nDiv := nScore div 256;
      nMod := nScore mod 256;

      nBowlerIdx := nBowlerIdx + 1;
      //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nDiv;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nMod;
      nBowlerIdx := nBowlerIdx + 1;
      //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nMod;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nDiv;
    end
    else
    begin
      nBowlerIdx := nBowlerIdx + 1;
      //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nScore;
      nBowlerIdx := nBowlerIdx + 1;
      //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nScore;
      FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
    end;
  end;

  nScore := rBowlerStatus.TotalScore;
  if nScore > 256 then
  begin
    nDiv := nScore div 256;
    nMod := nScore mod 256;

    nBowlerIdx := nBowlerIdx + 1;
    //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nDiv;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nMod;
    nBowlerIdx := nBowlerIdx + 1;
    //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nMod;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nDiv;
  end
  else
  begin
    nBowlerIdx := nBowlerIdx + 1;
    //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nScore;
    nBowlerIdx := nBowlerIdx + 1;
    //FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := nScore;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := 0;
  end;
  nBowlerIdx := nBowlerIdx + 1;
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;
  nBowlerIdx := nBowlerIdx + 1;
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;

  nBowlerIdx := nBowlerIdx + 1;
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rBowlerStatus.ToCnt; //게이머 투 횟수
  nBowlerIdx := nBowlerIdx + 1;
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rBowlerStatus.EndGameCnt; //완료된 게임수

  // C0=지금 투할 게이머, 80=대기, 02 = 일시정지(강제), 20=일시정지(리그), E0=?
  nBowlerIdx := nBowlerIdx + 1;
  if rBowlerStatus.Status1 = '2' then // 0:대기,1:준비,2:진행,3:종료
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $C0
  else if rBowlerStatus.Status1 = '1' then
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $80
  else if rBowlerStatus.Status1 = '3' then
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $20
  else
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;

  nBowlerIdx := nBowlerIdx + 1;
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;

  nBowlerIdx := nBowlerIdx + 1;

  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rBowlerStatus.ResidualGameCnt; //잔여게임수

  nBowlerIdx := nBowlerIdx + 1;
  // 상태(00=, 80=종료.모든게이머 게임완료시)
  if rBowlerStatus.Status3 = '3' then
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $80
  else
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;

  nCrc := GetCRC(FLastIdx, 16, nBowlerIdx);
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx + 1] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := nBowlerIdx + 2;
  FCmdSendBufArr[FLastIdx].sType := '볼러이동';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;


function TComThread.SendLaneAssignMoveBowlerDel(ALaneNo, ABowlerSeq: Integer): Boolean;
var
  nCrc, nTemp: Byte;
  i: Integer;
  sTemp: AnsiString;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 2A 00 02 04 FB (3번레인 2번 게이머 빼기)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 09 2A 00 02 02 FD (9번레인 1번 게이머 빼기)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : 레인번호
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 게이머순번
             1번 게이머. 2번 Bit (0000 0010)
             2번 게이머. 3번 Bit (0000 0100)
             3번 게이머. 4번 Bit (0000 1000)
  18 Byte : CRC
  }

  FillChar(FCmdSendBufArr[FLastIdx], SizeOf(FCmdSendBufArr[FLastIdx]), 0);

  FCmdSendBufArr[FLastIdx].nDataArr[0] := $0D;
  FCmdSendBufArr[FLastIdx].nDataArr[1] := $50; // PosCommand (String)
  FCmdSendBufArr[FLastIdx].nDataArr[2] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[3] := $73;
  FCmdSendBufArr[FLastIdx].nDataArr[4] := $43;
  FCmdSendBufArr[FLastIdx].nDataArr[5] := $6F;
  FCmdSendBufArr[FLastIdx].nDataArr[6] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[7] := $6D;
  FCmdSendBufArr[FLastIdx].nDataArr[8] := $61;
  FCmdSendBufArr[FLastIdx].nDataArr[9] := $6E;
  FCmdSendBufArr[FLastIdx].nDataArr[10] := $64;
  FCmdSendBufArr[FLastIdx].nDataArr[11] := $0D;

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $2A; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;

  sTemp := '0';
  for i := 1 to 7 do
  begin
    if i = ABowlerSeq then
      sTemp := '1' + sTemp
    else
      sTemp := '0' + sTemp;
  end;
  //sTemp := StrZeroAdd(sTemp, 8);
  nTemp := Bin2Dec(sTemp);

  FCmdSendBufArr[FLastIdx].nDataArr[16] := nTemp;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '사용자제거(이동)';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameStatus: Boolean; //상태요청
var
  Temp, cSum: Byte;
  nDataArr: array[0..18] of byte;
  I: Integer;
  sSendData, sLogMsg: AnsiString;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 16 00 03 03 16 EF (3번 레인 상태요청)
  // 2~11 Byte : PosCommand (String)
  // 13 Byte : 레인번호 (0x80 | 0x03) 0x03=레인번호
  // 14 Byte : Command
  // 15~16 Byte : Data Length
  // 17 Byte : 레인번호 (상태 요청은 홀수번 레인(장치 ID)에 대해) - 응답은 홀수 레인 짝수 레인 연속해서 들어옴
  // 18 Byte : Command

  // 상태요청은 홀수 레인 번호로 한다. (01, 03, 05, 07, 09, 0B ...)

  FillChar(nDataArr, SizeOf(nDataArr), 0);

  nDataArr[0] := $0D;
  nDataArr[1] := $50; // PosCommand (String)
  nDataArr[2] := $6F;
  nDataArr[3] := $73;
  nDataArr[4] := $43;
  nDataArr[5] := $6F;
  nDataArr[6] := $6D;
  nDataArr[7] := $6D;
  nDataArr[8] := $61;
  nDataArr[9] := $6E;
  nDataArr[10] := $64;
  nDataArr[11] := $0D;

  nDataArr[12] := $80 + FLaneNoLast;

  nDataArr[13] := $16;

  nDataArr[14] := $00; // Data Length
  nDataArr[15] := $03;

  nDataArr[16] := FLaneNoLast;
  nDataArr[17] := $16;

  //nCrc := GetCRC(FLastIdx, 16, 17);
  //nDataArr[18] := nCrc;

  cSum := $FF;
  for I := 16 to 17 do
  begin
    Temp := cSum;
    cSum := cSum + cSum;

    if Temp >= $80 then
      cSum := cSum + $01;

    cSum := nDataArr[I] xor cSum;
  end;

  nDataArr[18] := cSum;

  FComPort.Write(nDataArr, 19);

  FillChar(FCmdRecvBufArr, SizeOf(FCmdRecvBufArr), 0);
  FRecvLen := 0;
  FRecvS := 0 ;
  {
  sSendData := '';
  for i := 0 to 18 do
  begin
    if i > 0 then
      sSendData := sSendData + ' ';

    sSendData := sSendData + IntToHex(nDataArr[i]);
  end;
  sLogMsg := 'SendData : ' + sSendData;
  Global.Log.LogComWrite(sLogMsg);  }
end;

procedure TComThread.Execute;
var
  bControlMode: Boolean;
  sBcc, sSendData: AnsiString;
  sLogMsg, sChannelR, sChannelL: String;
  i: Integer;
begin
  inherited;

  while not Terminated do
  begin
    try
      //Synchronize(Global.ComThreadTimeCheck);

      while True do
      begin
        if FReceived = False then
        begin

          if now > FWriteTm then
          begin

            if FLastExeCommand = COM_CTL then
            begin
              sLogMsg := 'COM_CTL Received Fail : FCurIdx ' + IntToStr(FCurIdx) + ' / ' + FCmdSendBufArr[FCurIdx].sType;
              Global.Log.LogComWrite(sLogMsg);

              //FRecvData := '';

              inc(FCtlReTry);
              if FCtlReTry > 2 then
              begin
                FCtlReTry := 0;
                FComPort.Close;
                FComPort.Open;
                Global.Log.LogComWrite('COM_CTL ReOpen');
              end;
            end
            else
            begin
              sLogMsg := 'COM_MON Received Fail : Lane ' + IntToStr(FLaneNoLast);
              Global.Log.LogComWrite(sLogMsg);

              Global.Lane.SetLaneErrorCnt(FLaneNoLast, 'Y', 6);
              SetNextMonNo;

              inc(FReTry);
              if FReTry > 10 then
              begin
                FReTry := 0;
                FComPort.Close;
                FComPort.Open;
                Global.Log.LogComWrite('COM_MON ReOpen');
              end;
            end;

            Break;
          end;

        end
        else
        begin
          if FLastExeCommand = COM_CTL then
            FCtlReTry := 0;

          FReTry := 0;

          Break;
        end;
      end;

      if FLastExeCommand = COM_CTL then
      begin
        if FLastIdx <> FCurIdx then
        begin
          inc(FCurIdx); //다음 제어 데이타로 이동
          if FCurIdx > BUFFER_SIZE then
            FCurIdx := 0;
        end;
      end;

      if not FComPort.Connected then
      begin
        FComPort.Open;
      end;

      bControlMode := False;
      if (FLastIdx <> FCurIdx) then
      begin //대기중인 제어명령이 있으면
        bControlMode := True;
        FLastExeCommand := COM_CTL;

        FComPort.Write(FCmdSendBufArr[FCurIdx].nDataArr, FCmdSendBufArr[FCurIdx].nCnt);

        if FCmdSendBufArr[FCurIdx].sType = 'Status' then
        begin
          FLastExeCommand := COM_MON;
          FillChar(FCmdRecvBufArr, SizeOf(FCmdRecvBufArr), 0);
          FRecvLen := 0;
          FRecvS := 0 ;
        end;

        sSendData := '';
        for i := 0 to FCmdSendBufArr[FCurIdx].nCnt - 1 do
        begin
          if i > 0 then
            sSendData := sSendData + ' ';

          sSendData := sSendData + IntToHex(FCmdSendBufArr[FCurIdx].nDataArr[i]);
        end;
        sLogMsg := 'SendData : FCurIdx ' + IntToStr(FCurIdx) + ' / ' + FCmdSendBufArr[FCurIdx].sType + ' / ' + sSendData;
        Global.Log.LogComWrite(sLogMsg);

        if FCmdSendBufArr[FCurIdx].sType = 'Status' then
        begin
          if FLastIdx <> FCurIdx then
          begin
            inc(FCurIdx); //다음 제어 데이타로 이동
            if FCurIdx > BUFFER_SIZE then
              FCurIdx := 0;
          end;
        end;

        FWriteTm := now + (((1/24)/60)/60) * 1;
      end;

      //장치에 데이터값을 요청하는 부분
      if bControlMode = False then
      begin
        FLastExeCommand := COM_MON;
        SendLaneGameStatus;
        FWriteTm := now + (((1/24)/60)/60) * 1;
      end;

      FReceived := False;
      Sleep(500);  //50 이하인경우 retry 발생

    except
      on e: Exception do
      begin
        sLogMsg := 'TComThread Error : ' + e.Message;
        Global.Log.LogWrite(sLogMsg);
      end;
    end;
  end;

end;

end.
