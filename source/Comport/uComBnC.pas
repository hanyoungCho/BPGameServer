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

    //2020-06-08 ����3ȸ �õ��� ����ó��
    FCtlReTry: Integer;
    FCtlChannel: String;

    FReceived: Boolean;
    FChannel: String;

    FLaneNoStart: Integer; //���� ��ȣ
    FLaneNoEnd: Integer;   //���� ��ȣ
    FLaneNoLast: Integer;  //������ ��û ��ȣ

    FLastIdx: word; //������� ��ɹ�ȣ
    FCurIdx: word;  //ó���� ��ɹ�ȣ

    FLastExeCommand: Integer; //���� ��Ŷ ���� ���

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

    function SendPinSetterOnOff(ALaneNo: Integer; AUseYn: String): Boolean; //��ġ�ѱ�,����
    function SendMoniterOnOff(ALaneNo, AUseYn: String): Boolean;
    function SendPinSettingNo(ALaneNo, ASetType: String): Boolean;
    function SendBowlerPause(ALaneNo, ABowlerSeq: Integer; APauseYn: String): Boolean;
    function SendInitLane(ALaneNo: String): Boolean; // ������ ��� Ȯ���ʿ�
    //function SendLaneTemp(ALaneNo: String): Boolean; // ��ɾ� Ȯ�� �ʿ�??? -> ���� ���� 2024-03-11
    function SendLaneStatus(ALaneNo: Integer): Boolean; // �ʱ�ȭ ��� �� ���� ���� ��û
    function SendGameCancel(ALaneNo: String): Boolean; // ���� ������� (?? �����ʱ�ȭ�� �ٸ� ���? Ȯ���ʿ�) - ���̸� ���� �������???

    function SendLaneAssign(ALaneNo: Integer): Boolean; //����
    function SendLaneAssign_Competition(ALaneNo: Integer; ALeagueYn: String; ATrainMin: Integer): Boolean; //����-��ȸ
    function SendLaneAssignCtl(ALaneNo: Integer): Boolean; //������� -> ���°��� ������� ����.  Ȯ���ʿ�
    function SendLaneCompetitionBowlerAdd(ALaneNo, ABowlerCnt: Integer): Boolean;
    function SendLaneCompetitionBowlerAddTemp(ALaneNo, ABowlerCnt: Integer): Boolean; //�׽�Ʈ�� ���߿� ����

    function SendLaneAssignBowlerAdd(ALaneNo, ABowlerSeq: Integer): Boolean;
    //function SendLaneAssignBowlerFin(ALaneNo: Integer): Boolean; //���̸����� ���/������ ���?  > �������� 2024-03-11
    function SendLaneAssignBowlerDel(ALaneNo, ABowlerSeq: Integer): Boolean; //����� ����? -> �̸� �ʱ�ȭ??

    function SendLaneAssignBowlerGameCnt(ALaneNo, ABowlerSeq, AGameCnt: Integer): Boolean; //���Ӽ� ����
    function SendLaneAssignBowlerGameCntSet(ALaneNo, ABowlerSeq: Integer): Boolean; //���Ӽ� ������ ����
    function SendLaneAssignBowlerGameTime(ALaneNo, ABowlerSeq, AGameTime: Integer): Boolean; //���ӽð� ����
    function SendLaneAssignBowlerPause(ALaneNo, ABowlerSeq, APause: Integer): Boolean; //���̸� �Ͻ�����/����

    function SendLaneAssignGameLeague(ALaneNo: Integer; AUse: String): Boolean; //���װ��� ����
    function SendLaneAssignGameLeagueOpen(ALaneNo: Integer): Boolean; //����-���Ӹ�������
    function SendLaneAssignGameType(ALaneNo: Integer; AGameType: String): Boolean; //8, 9, 369 ����
    function SendLaneAssignGameTypeFin(ALaneNo: Integer): Boolean; //8, 9, 369 ���� �����Ϸ�
    function SendLaneAssignGameBowlerHandy(ALaneNo: Integer): Boolean; //�ڵ�-0:�ʱ�ȭ, 1~255����
    function SendLaneAssignGameHandy(ALaneNo, ABowlerSeq, AHandy: Integer): Boolean; //�ڵ�-0:�ʱ�ȭ, 1~255����
    function SendLaneAssignGameTraining(ALaneNo, ATime: Integer): Boolean; //��������
    function SendLaneAssignGameTrainingFin(ALaneNo: Integer): Boolean; //��������

    function SendLaneGameScoreChange(ALaneNo, ABowlerSeq: Integer; AFrame: String): Boolean;

    function SendLaneGameNext(ALaneNo: Integer; ALeagueYn: String): Boolean;
    function SendLaneGameEnd(ALaneNo, ABowlerSeq: Integer; AType: String): Boolean; // �������� ���� (���װ��� �Ǵ� ���̸Ӱ� �������϶� 10������ �Ϸ� �Ǹ� ����)
    function SendLaneGameRestore(ALaneNo, ABowlerSeq: String): Boolean; // �������Ӻ���

    function SendLaneAssignMove(ALaneNo, ATargetLaneNo: Integer): Boolean;
    function SendLaneAssignMoveBowler(ALaneNo, ABowlerSeq: Integer; ABowlerNm: String): Boolean;
    function SendLaneAssignMoveBowlerDel(ALaneNo, ABowlerSeq: Integer): Boolean; //����� �����̵��� �������� ���ſ�

    function SendLaneGameStatus: Boolean; //���¿�û

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

  //���� 60byte, ����:$31(49)
  FComPort.Read(nBuffArr, Count);
  FComPort.ClearBuffer(True, False); // Input ���� clear - True

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
  <��ü ������ ����>
  1~8 Byte : gamedata (String)
  9��° Byte : ���ι�ȣ
  10, 11��° Byte : ������ ���� (12��° Byte ���� CRC����)
  12��° Byte : ���ι�ȣ
  13��° Byte : 20(�Ϲݰ��ӽ� ����). 20<->28(���װ��ӽý� NEXT GAME ���� �ٲ�???)
  14��° Byte : ���ӻ���(A8=����, 88=����, 08=�ʱ�ȭ����?, E8=��������)
  15��° Byte : 00=�Ϲݰ���, 01=���װ���
  16��° Byte : 00=�Ϲݰ���, 01=369����, 02=8�ɰ���, 03=9�ɰ���,
  17��° Byte : ??       02??
  18��° Byte : ??       ���������ܿ��ð�?
  19��° Byte : ���̸� ��
  20��° Byte : ���� �� ���̸� ��ȣ
  21��° Byte : ?? (0B������� ���� ����)
  22��° Byte : ��ü ���̸� �������� (L Byte)
  23��° Byte : ��ü ���̸� �������� (H Byte)
  24��° Byte :
  25��° Byte :
  26��° Byte : ���� �� ���̸� ������ ���� (���� 4Byte. ���� ������)
  27��° Byte : 0A (����?)

  ������ 2�� ���� ������ ���ÿ� ���´�.
  03�� ���� ��û�� 03��, 04�� ���� ������ ������� ���´�.

  60Byte ���� 83Byte : ���̸� ��������
  2�� �̻��ǰ�� �߰� 83Byte �� ���̸� ��������
  }
  nLength1 := Arr[9];
  nLength2 := Arr[10];
  nRecLength := (nLength1 * 256) + nLength2; //������ ���� (12��° Byte ���� CRC ��������)

  if (nLength + 1) <> (11 + nRecLength) then
  begin
    Global.Log.LogComReadMon('Length fail -> ' + intToStr(nLength + 1) + ' / ' + Inttostr(11 + nRecLength));
    Exit;
  end;

  rGameStatus.LaneNo := Arr[11];
  rGameStatus.b12 := Arr[12]; // 13��° ????
  rGameStatus.Status := IntToHex(Arr[13], 2); //14��° Byte : ���ӻ���(A8=����, 88=����)
  rGameStatus.League := Arr[14];
  rGameStatus.GameType := Arr[15];

  rGameStatus.BowlerCnt := Arr[18]; //19��° Byte : ���̸� ��
  rGameStatus.b19 := Arr[19]; //20��° Byte : ���� �� ���̸� ��ȣ
  rGameStatus.b20 := Arr[20]; //21��° ????
  rGameStatus.b26 := Arr[26]; //27��° ????

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
      <���̸� ��������>
      1~32 Byte : ���̸� ǥ�� �̸� (1���ڿ� 2Byte. 0~9. A~Z ���� ����Ʈ�� ǥ��, �ѱ�ǥ��� �ϼ���.)  30 00 -> '0', 20 00 -> ' ', E8 B1 = B1E8 (�ϼ��� ��)
      33��° Byte ���� 1Byte �� (21Byte) : ���̸� ���� ���� (01~09 ����, 0A=��Ʈ����ũ, 0B=����� Ŭ����, 0C=�����ó�� ���) (���� 4��Ʈ 1000(0x80) �̸� ������ ����). 21��°�� 10������ ������(3��°) ��
      54��° Byte ���� 2Byte �� : ���̸� ������ ���� ����
      74��° Byte : GAME ���� ����(L Byte)
      75��° Byte : GAME ���� ����(H Byte)
      76��° Byte : �ڵ�
      77��° Byte :
      78��° Byte : ���̸� �� Ƚ�� (��Ʈ����ũ�� ��� +2), 10������ ������ ���� ������ ����. �������� �����Ӽ� ���� ����.
      79��° Byte : �Ϸ�� ���Ӽ�.
      80��° Byte : C0.E0=���� ���� ���̸�(Ȧ¦����), 80.A0=���(Ȧ¦����), 02(Ȧ��).22(¦��) = �Ͻ�����(����).���Ӽ� ������ ���� ���̸�(�������� 0�϶�).�ð� ������ ���� �ð� 0�϶�, 00(Ȧ������)20(¦������) �� ���ӿϷ�
      81��° Byte : �ð��� ���� ���� �ð�.(��)
      82���� Byte : ���Ӽ� ������(����) ���� ���Ӽ�.
      83���� Byte : 0x20 = ����(���Ӽ�������), 0x00 = ������(�Ϲݰ��ӽ�). 0xA0=����������(���Ӽ�������) , 0x80=��������(�Ϲݰ��ӽ�)
      }

      //���̸� ���� ��: FDataArr[60]FDataArr[59], �̸�1: FDataArr[62]FDataArr[61], �̸�2: FDataArr[64]FDataArr[63]
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

      rGameStatus.BowlerList[nBowler + 1].TotalScore := bGamerArr[73] + (bGamerArr[74] * 256); //��������
      rGameStatus.BowlerList[nBowler + 1].ToCnt := bGamerArr[77]; //���̸� �� Ƚ��
      rGameStatus.BowlerList[nBowler + 1].EndGameCnt := bGamerArr[78]; //�Ϸ�� ���Ӽ�

      // Ȧ������:C0=���� ���� ���̸�, 80=���, 00=���� / ¦������: E0=���һ�� A0=�����, 20=����  , / 02 = �Ͻ�����(����)
      rGameStatus.BowlerList[nBowler + 1].Status1 := IntToHex(bGamerArr[79], 2);

      // �ܿ��ð�
      rGameStatus.BowlerList[nBowler + 1].ResidualGameTime := bGamerArr[80];
      // �ܿ����Ӽ�
      rGameStatus.BowlerList[nBowler + 1].ResidualGameCnt := bGamerArr[81];

      // ����0x20 = ����,  0xA0 = ���Ұ�������, 0x00 = ������. 0x80 = �ĺҰ�������
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
  //(���� ��û�� Ȧ���� ����(��ġ ID)�� ����) - ������ Ȧ�� ���� ¦�� ���� �����ؼ� ����
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

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 11 00 02 01 FE (1������ �ѱ�)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 11 00 02 01 FE (5������ �ѱ�)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 06 11 00 02 01 FE (6������ �ѱ�)

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 11 00 02 03 FC (1������ ����)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 11 00 02 03 FC (5������ ����)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 06 11 00 02 03 FC (6������ ����)

  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
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
  FCmdSendBufArr[FLastIdx].sType := '�ɼ���';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendMoniterOnOff(ALaneNo, AUseYn: String): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 15 00 02 01 FE (7�� ���� ����� ON)
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 15 00 02 00 FF (7�� ���� ����� OFF)

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
  FCmdSendBufArr[FLastIdx].sType := '�����';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;

function TComThread.SendPinSettingNo(ALaneNo, ASetType: String): Boolean;
var
  nCrc: Byte;
begin
  // �ɼ��� 1 (�ʱ� ���� - �����߸��� �ٽ� ����)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 12 00 04 01 01 12 EB (1������ 1�� �ɼ���)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 12 00 04 01 03 12 EF (2������ 1�� �ɼ���)

  // �ɼ��� 2 (����� ���� - ���ִ� �ɸ� ��� �÷ȴ� ������)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 12 00 04 02 01 12 E7 (1������ 2�� �ɼ���)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 12 00 04 02 03 12 E3 (3������ 2�� �ɼ���)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : 1,2 �ɼ��� (Data)
  18 Byte : ���ι�ȣ
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
  FCmdSendBufArr[FLastIdx].sType := '�ɼ���';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendBowlerPause(ALaneNo, ABowlerSeq: Integer; APauseYn: String): Boolean;
var
  nCrc: Byte;
begin
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 0E 00 03 01 01 FC (3������ 1�� ���̸� �Ͻ����� ON)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 03 00 03 00 00 FF (3������ 1�� ���̸� �Ͻ����� OFF)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 09 03 00 03 01 09 F4

  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : ���̸� ��ȣ (1~6)
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
  FCmdSendBufArr[FLastIdx].sType := '�Ͻ�����';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendInitLane(ALaneNo: String): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 09 00 04 01 01 09 F0 (�������� Ŭ����)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
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
  FCmdSendBufArr[FLastIdx].sType := '�����ʱ�ȭ';

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

function TComThread.SendGameCancel(ALaneNo: String): Boolean; //Ȯ���ʿ�
var
  nCrc: Byte;
  i: integer;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 03 00 23 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FB
  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
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
  FCmdSendBufArr[FLastIdx].sType := '�������';

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
  //SendLaneAssignCtl(ALaneNo); //�������
  SendLaneAssignGameLeagueOpen(ALaneNo); // ���°���
  SendLaneAssignBowlerAdd(ALaneNo, 0); //���� �߰�
  //SendLaneAssignBowlerFin(ALaneNo); //�߰� �Ϸ�?
  SendPinSetterOnOff(ALaneNo, 'Y'); //�ɼ��� ��Ű
end;

function TComThread.SendLaneAssign_Competition(ALaneNo: Integer; ALeagueYn: String; ATrainMin: Integer): Boolean;
var
  bOdd: Boolean; //Ȧ��
begin

  //��ȸ���
{
��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 87 01 00 04 01 07 01 F4		7����ġ ���װ��� ����
����     87 01 00 04

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 20 00 02 0A F5		7������ �����ð� 10��
����     07 20 00 02

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 01 00 04 02 07 01 E6		7������ �������� ����
����     07 01 00 04

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 03 00 43 00 06 43 00 43 00 43 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 00 44 00 44 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A2	7������ ���̸� ���
����     07 03 00 43

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 07 00 02 01 FE		7������ ���̸� ���� ��� �Ϸ�
����     07 07 00 02

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 20 00 02 0A F5		8������ �����ð� 10��
����     08 20 00 02

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 01 00 04 02 07 01 E6		8������ �������� ����
����     08 01 00 04

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 03 00 43 00 06 43 00 43 00 43 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 00 44 00 44 00 20 00 30 00 38 00 20 00 31 00 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 A2	8������ ���̸� ���
����     08 03 00 43

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 07 00 02 01 FE		8������ ���̸� ���� ��� �Ϸ�
����     08 07 00 02

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 11 00 02 01 FE    (7������ ��ġ�ѱ�)
����     07 11 00 02

��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 08 11 00 02 01 FE    (8������ ��ġ�ѱ�)
����     08 11 00 02

// 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 87 08 00 05 01 07 01 08 E3 ���װ���next
}

  if ALeagueYn = 'Y' then
  begin
    bOdd := odd(ALaneNo); //Ȧ�� ����
    if bOdd = True then
      SendLaneAssignGameLeague(ALaneNo, 'Y'); //���װ���
  end;

  if ATrainMin > 0 then
  begin
    SendLaneAssignGameTraining(ALaneNo, ATrainMin); //��������
    SendLaneAssignGameTrainingFin(ALaneNo);
  end;

  SendLaneAssignBowlerAdd(ALaneNo, 0); //���� �߰�
  //SendLaneAssignBowlerFin(ALaneNo); //�߰� �Ϸ�?
  SendLaneAssignGameBowlerHandy(ALaneNo); //�ڵ�-0:�ʱ�ȭ, 1~255����
  SendPinSetterOnOff(ALaneNo, 'Y'); //�ɼ��� ��Ű
end;

function TComThread.SendLaneAssignCtl(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
  nNo: Integer;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 01 00 04 00 01 01 FC  (1�� ��ġ ���̸� ���� ���) 1,2�� ���� ���̸� ��Ͻ�
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 85 01 00 04 00 05 01 F4  (5�� ��ġ ���̸� ���� ���) 5,6�� ���� ���̸� ��Ͻ�
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 01 00 04 00 03 01 F8  (3�� ��ġ ���̸� ���� ���) 3,4�� ���� ���̸� ��Ͻ�

  {
  2~11 Byte : PosCommand (String)
  12 Byte : STX (Command Start)
  13 Byte : (0x80 + ���ι�ȣ)
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : ??
  18 Byte : ���ι�ȣ
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

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + nNo;  // ��ġ����

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $01; //14 Byte : Command 1

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;
  FCmdSendBufArr[FLastIdx].nDataArr[17] := ALaneNo;
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $01;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '�������';

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

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 03 00 23 02 00 30 00 31 00 41 00 20 00 30 00 30 00 20 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E0 (1������ ���̸� ���� ����) | ���̸� 1 ���� |CRC
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 03 00 43 06 00 30 00 35 00 41 00 20 00 31 00 31 00 20 00 31 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 35 00 42 00 20 00 31 00 31 00 20 00 31 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 EB (5������ ���̸� ���� ����) | ���̸� 1 ���� | ���̸� 2 ���� |CRC
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 04 03 00 43 00 06 30 00 34 00 41 00 20 00 31 00 31 00 20 00 31 00 31 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 34 00 42 00 20 00 31 00 31 00 20 00 31 00 31 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E1 (4������ ���̸� ���� ����) | ���̸� 1 ���� | ���̸� 2 ���� |CRC
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 03 00 63 0E 00 30 00 33 00 41 00 20 00 31 00 31 00 20 00 31 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 33 00 42 00 20 00 31 00 31 00 20 00 31 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //                                                      30 00 33 00 43 00 20 00 31 00 31 00 20 00 31 00 37 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 99 (3������ ���̸� ���� ����) | ���̸� 1 ���� | ���̸� 2 ���� | ���̸� 3 ���� |CRC

  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : Ȧ���� ���� ���̸� INDEX
             1�� ���̸�. 2�� Bit (0000 0010)
             2�� ���̸�. 3�� Bit (0000 0100)
             3�� ���̸�. 4�� Bit (0000 1000)
  �űԷ� 3�� ����ϸ� 0000 1110 (0x0E)
  18 Byte : ¦���� ���� ���̸� INDEX
             1�� ���̸�. 2�� Bit (0000 0010)
             2�� ���̸�. 3�� Bit (0000 0100)
             3�� ���̸�. 4�� Bit (0000 1000)
  �űԷ� 3�� ����ϸ� 0000 1110 (0x0E)

  19~ 50 Byte : ���̸��̸� (2�� �̻��϶� 19~ 50 Byte �ݺ�)
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

  //32 ���������
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
  FCmdSendBufArr[FLastIdx].sType := '���������';

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

  //32 ���������
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
  FCmdSendBufArr[FLastIdx].sType := '���������';

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

  //32 ���������
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
  FCmdSendBufArr[FLastIdx].sType := '���������';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;
{
function TComThread.SendLaneAssignBowlerFin(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 07 00 02 01 FE (���̸� ���� ��� �Ǵ� ������ ������ ��� ??)
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
  FCmdSendBufArr[FLastIdx].sType := '�������';

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

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 03 00 23 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F7 (1�� ���� 2�� ���̸� ����)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 02 03 00 23 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FB (2�� ���� 2�� ���̸� ����)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : Ȧ������ ���̸Ӽ���
             1�� ���̸�. 2�� Bit (0000 0010)
             2�� ���̸�. 3�� Bit (0000 0100)
             3�� ���̸�. 4�� Bit (0000 1000)
  18 Byte : ¦������ ���̸Ӽ���
             1�� ���̸�. 2�� Bit (0000 0010)
             2�� ���̸�. 3�� Bit (0000 0100)
             3�� ���̸�. 4�� Bit (0000 1000)
  19~50Byte : ���̸� �̸����� Ŭ����.
  51 Byte : CRC
  �� ���� �߿� ���̸� ���� ����.
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
  FCmdSendBufArr[FLastIdx].sType := '���������';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignBowlerGameCnt(ALaneNo, ABowlerSeq, AGameCnt: Integer): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 1E 00 03 02 02 F9 (1�� ���� 2�� ����� 2����)
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 1E 00 07 01 01 02 01 03 04 D9  [1�����̸� 1����, 2�����̸� 1����, 3�����̸� 4����] -> �ѹ��� �����°� ���� �ʿ�
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : ���̸� ��ȣ
  //  18 Byte : ���Ӽ�
  // ���̸Ӽ���(17).���Ӽ�(18) ���̸� �� ��ŭ �ݺ�
  // -> ����     01 1E 00 07

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
  FCmdSendBufArr[FLastIdx].sType := '���Ӽ�';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignBowlerGameCntSet(ALaneNo, ABowlerSeq: Integer): Boolean; //���Ӽ� ������ ��ġ�� ����
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 21 00 03 01 20 DD  [1�����̸� ����(���Ӽ�����] ���� ���º���] -> ����     01 21 00 03
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 21 00 03 02 20 DB  [2�����̸� ����(���Ӽ�����] ���� ���º���] -> ����     01 21 00 03
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 21 00 03 03 20 D9  [3�����̸� ����(���Ӽ�����] ���� ���º���] -> ����     01 21 00 03

  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : ���̸� ��ȣ
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
  FCmdSendBufArr[FLastIdx].sType := '���Ӽ�����';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignBowlerGameTime(ALaneNo, ABowlerSeq, AGameTime: Integer): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 1F 00 05 01 05 02 0A D1	[�ð�����] - 1�� 5(05)��, 2�� 10(0A)�� -> ����     07 1F 00 05
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : ���̸� ��ȣ
  //  18 Byte : �ð�
  // ���̸Ӽ���(17).���Ӽ�(18) ���̸� �� ��ŭ �ݺ�

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
  FCmdSendBufArr[FLastIdx].sType := '���ӽð�';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignBowlerPause(ALaneNo, ABowlerSeq, APause: Integer): Boolean;
var
  nCrc: Byte;
begin
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 0E 00 03 01 01 FC (3������ 1�� ���̸� �Ͻ����� ON)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 03 00 03 00 00 FF (3������ 1�� ���̸� �Ͻ����� OFF)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : ���̸� ��ȣ (1~6)
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
  if APause = 1 then //�Ͻ�����
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
  FCmdSendBufArr[FLastIdx].sType := '�Ͻ�����';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameLeague(ALaneNo: Integer; AUse: String): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 01 00 04 01 01 01 F8		[���װ��� ����]
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 01 00 04 00 01 01 FC		[���װ��� ���� ����]
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 01 00 04 00 03 01 F8		[���°��� ���� ���] - ���� ���� Ư�� ���� ����. ����     83 01 00 04
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : ����
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

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // ��ġ����

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
  FCmdSendBufArr[FLastIdx].sType := '���׼���';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameLeagueOpen(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 01 00 04 00 03 01 F8		[���°��� ���� ���] - ���� ���� Ư�� ���� ����. ����     83 01 00 04
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
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

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // ��ġ����

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $01; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $04;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $00;

  FCmdSendBufArr[FLastIdx].nDataArr[17] := ALaneNo;
  FCmdSendBufArr[FLastIdx].nDataArr[18] := $01;

  nCrc := GetCRC(FLastIdx, 16, 18);
  FCmdSendBufArr[FLastIdx].nDataArr[19] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 20;
  FCmdSendBufArr[FLastIdx].sType := '���°��Ӽ���';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;


function TComThread.SendLaneAssignGameType(ALaneNo: Integer; AGameType: String): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 02 FD		[8�ɰ��� ����] ����     81 02 00 02
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 03 FC		[9�ɰ��� ����] ����     81 02 00 02
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 01 FE		[369���� ����] ����     81 02 00 02
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 81 02 00 02 00 FF		[8, 9, 369 ���� ���� ����] ����     81 02 00 02

  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
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

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // ��ġ����

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
  FCmdSendBufArr[FLastIdx].sType := '��Ÿ���Ӽ���';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameTypeFin(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 01 07 00 02 01 FE		[���� �Ϸ�]

  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
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

  FCmdSendBufArr[FLastIdx].nDataArr[12] := $80 + ALaneNo;  // ��ġ����

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $07; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $02;


    FCmdSendBufArr[FLastIdx].nDataArr[16] := $01;

  nCrc := GetCRC(FLastIdx, 16, 16);
  FCmdSendBufArr[FLastIdx].nDataArr[17] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 18;
  FCmdSendBufArr[FLastIdx].sType := '��Ÿ���Ӽ�������';

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
  // 13 Byte : ���ι�ȣ
  // 14 Byte : Command 1 (�ڵ���)
  // 15~16 Byte : Data Length
  // 17 Byte : Command 2 (����)
  // 18 Byte : �ڵ�����
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

  FCmdSendBufArr[FLastIdx].nDataArr[12] := ALaneNo;  // ��ġ����

  FCmdSendBufArr[FLastIdx].nDataArr[13] := $05; //

  FCmdSendBufArr[FLastIdx].nDataArr[14] := $00; // Data Length
  FCmdSendBufArr[FLastIdx].nDataArr[15] := $03;

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq;

  FCmdSendBufArr[FLastIdx].nDataArr[17] := AHandy;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '�ڵ���';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameTraining(ALaneNo, ATime: Integer): Boolean;
var
  nCrc: Byte;
begin
  // ��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 20 00 02 0A F5		7������ �����ð� 10��
  // ����     07 20 00 02

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
  FCmdSendBufArr[FLastIdx].sType := '��������';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneAssignGameTrainingFin(ALaneNo: Integer): Boolean;
var
  nCrc: Byte;
begin
  //��û     0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 01 00 04 02 07 01 E6		7������ �������� ����
  //����     07 01 00 04

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
  FCmdSendBufArr[FLastIdx].sType := '������������';

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
  // ����� ��������
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 0C 00 18 01 FF 89 8B 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 84
  //  2~11 Byte : PosCommand (String)
  //  13 Byte : ���ι�ȣ
  //  14 Byte : Command 1
  //  15~16 Byte : Data Length
  //  17 Byte : ���̸� ��ȣ (��� �Ǵ� ���� �϶��� ���̸� ��ȣ �ο� ��� �ٸ�)
  //  18 Byte : ???
  //  19~20 Byte : 1������. 1�� �� 9�� ������. 2���� �����ó��
  //  21~22 Byte : 2������.
  //  23~24 Byte : 3������.
  //  25~26 Byte : 4������.
  //  27~28 Byte : 5������.
  //  29~30 Byte : 6������.
  //  31~32 Byte : 7������.
  //  33~34 Byte : 8������.
  //  35~36 Byte : 9������.
  //  37~38 Byte : 10������.
  //  39 Byte : ??
  //  40 Byte : CRC

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 0C 00 18 01 FF 8A 00 8A 00 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AF
  // 17 Byte : 1�� �����
  // 19~20 Byte : 1������. 1�� �� ��Ʈ����ũ
  // 21~22 Byte : 2������. 1�� �� ��Ʈ����ũ
  // 23~24 Byte : 3������. 1�� �� 9�� ������. 2�� �� �� ���о� ó��
  // 25~26 Byte : 4������. 1�� �� ��Ʈ����ũ

  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 0C 00 18 02 FF 87 8C 88 8C 89 8C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 68
  // 17 Byte : 2�� �����
  // 19~20 Byte : 1������. 1�� �� 7�� ������. 2�� �� �� ���о� ó��
  // 21~22 Byte : 2������. 1�� �� 8�� ������. 2�� �� �� ���о� ó��
  // 23~24 Byte : 3������. 1�� �� 9�� ������. 2�� �� �� ���о� ó��

  // B:�����, A:��Ʈ����ũ, C:�뽺���

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

  FCmdSendBufArr[FLastIdx].nDataArr[16] := ABowlerSeq; // ����� ��ȣ

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
  FCmdSendBufArr[FLastIdx].sType := '��������';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameNext(ALaneNo: Integer; ALeagueYn: String): Boolean;
var
  nCrc: Byte;
begin
  // ���� NEXT (�� ����) (3������ ���ϴ� �̰���, 4������ �̻��� ����. ���Ҹ��� ���� ����. �����ʹ� ���� ������ �ʾƵ� ��.)
 	// 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 08 00 05 01 07 00 08 E3
  // 2~11 Byte : PosCommand (String)
  // 13 Byte : (0x80 + ���ι�ȣ)
  // 14 Byte : Command 1
  // 15~16 Byte : Data Length
  // 17 Byte : Command 2
  // 18 Byte : ���ι�ȣ
  // 19 Byte : �Ϲݰ��ӽ�(00). ���װ��ӽ�(01)
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
  FCmdSendBufArr[FLastIdx].sType := '����NEXT';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameEnd(ALaneNo, ABowlerSeq: Integer; AType: String): Boolean;
var
  nCrc: Byte;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 05 21 00 03 01 80 7D - �Ϲ�
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 21 00 03 01 A0 5D (��ɾ� �м� �ʿ�) - ������
  {
  2~11 Byte : PosCommand (String)
  13 Byte : (0x80 + ���ι�ȣ)
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : ���̸� ��ȣ.
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

  if AType = '0' then  // 0:����, 1:���Ӽ�
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $80
  else
    FCmdSendBufArr[FLastIdx].nDataArr[17] := $A0;

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '������������';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameRestore(ALaneNo, ABowlerSeq: String): Boolean; //�������Ӻ���
var
  nCrc: Byte;
begin
  //���̸� 1��
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 17 00 84 07 20 A8 00 00 02 00 01 01 05 43 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //30 00 37 00 41 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8A 00 8A 00 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1D 00 30 00 39 00 43 00 00 00 00 00 00 00 00 00 00 00 00 00 43 00 00 00 08 00 C0 00 00 80 D7

  //���̸� 2��
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 07 17 00 D7 07 20 A8 00 00 02 00 02 01 05 65 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //30 00 37 00 41 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8A 00 8A 00 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1D 00 30 00 39 00 43 00 00 00 00 00 00 00 00 00 00 00 00 00 43 00 00 00 08 00 C0 00 00 80
  //30 00 37 00 42 00 20 00 30 00 30 00 20 00 31 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 87 8C 88 8C 89 8C 8A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 00 0F 00 18 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00 22 00 00 00 08 00 80 00 00 80 E7

  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
  14 Byte : Command 1
  15~16 Byte : Data Length
  17~19 Byte : ���ι�ȣ
  24 Byte : ���̸Ӽ�
  25 Byte :
  27 Byte : ��ü ���̸� TOT ����
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

  FCmdSendBufArr[FLastIdx].nDataArr[16] := $07; //17~19 Byte : ���ι�ȣ -> ??????
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

  //���̸� ���� - �̵��� ����Ÿ�� ���

  nCrc := GetCRC(FLastIdx, 16, 17);
  FCmdSendBufArr[FLastIdx].nDataArr[18] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := 19;
  FCmdSendBufArr[FLastIdx].sType := '�������Ӻ���';

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
  //13 Byte : ���ι�ȣ
  //14 Byte : Command 1
  //15~16 Byte : Data Length
  //17~64 Byte : ������ ��������
  //65~ Byte : ���̸� ��������

  //����� ���� 83 byte
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

  //17~64 Byte : ������ ��������->????
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
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].ToCnt; //���̸� �� Ƚ��
    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].EndGameCnt; //�Ϸ�� ���Ӽ�

    // C0=���� ���� ���̸�, 80=���, 02 = �Ͻ�����(����), 20=�Ͻ�����(����), E0=?
    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := StrToInt('$' + rGame.BowlerList[nBowler + 1].Status1);

    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].ResidualGameTime;

    nBowlerIdx := nBowlerIdx + 1;
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rGame.BowlerList[nBowler + 1].ResidualGameCnt; //�ܿ����Ӽ�

    nBowlerIdx := nBowlerIdx + 1;
    // ����(00=, 80=����.�����̸� ���ӿϷ��)
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := StrToInt('$' + rGame.BowlerList[nBowler + 1].Status3);
  end;

  nCrc := GetCRC(FLastIdx, 16, nBowlerIdx);
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx + 1] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := nBowlerIdx + 2;
  FCmdSendBufArr[FLastIdx].sType := '�̵�';

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
  //13 Byte : ���ι�ȣ
  //14 Byte : Command 1
  //15~16 Byte : Data Length
  //17~ Byte : ���̸� ��������. ���� �������̾ ���̸� ��� ����(����) �̵�

  //����� ���� 83 byte
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

  //17~ Byte : ���̸� ��������
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
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rBowlerStatus.ToCnt; //���̸� �� Ƚ��
  nBowlerIdx := nBowlerIdx + 1;
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rBowlerStatus.EndGameCnt; //�Ϸ�� ���Ӽ�

  // C0=���� ���� ���̸�, 80=���, 02 = �Ͻ�����(����), 20=�Ͻ�����(����), E0=?
  nBowlerIdx := nBowlerIdx + 1;
  if rBowlerStatus.Status1 = '2' then // 0:���,1:�غ�,2:����,3:����
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

  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := rBowlerStatus.ResidualGameCnt; //�ܿ����Ӽ�

  nBowlerIdx := nBowlerIdx + 1;
  // ����(00=, 80=����.�����̸� ���ӿϷ��)
  if rBowlerStatus.Status3 = '3' then
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $80
  else
    FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx] := $00;

  nCrc := GetCRC(FLastIdx, 16, nBowlerIdx);
  FCmdSendBufArr[FLastIdx].nDataArr[nBowlerIdx + 1] := nCrc;

  FCmdSendBufArr[FLastIdx].nCnt := nBowlerIdx + 2;
  FCmdSendBufArr[FLastIdx].sType := '�����̵�';

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

  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 03 2A 00 02 04 FB (3������ 2�� ���̸� ����)
  //0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 09 2A 00 02 02 FD (9������ 1�� ���̸� ����)
  {
  2~11 Byte : PosCommand (String)
  13 Byte : ���ι�ȣ
  14 Byte : Command 1
  15~16 Byte : Data Length
  17 Byte : ���̸Ӽ���
             1�� ���̸�. 2�� Bit (0000 0010)
             2�� ���̸�. 3�� Bit (0000 0100)
             3�� ���̸�. 4�� Bit (0000 1000)
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
  FCmdSendBufArr[FLastIdx].sType := '���������(�̵�)';

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;

end;

function TComThread.SendLaneGameStatus: Boolean; //���¿�û
var
  Temp, cSum: Byte;
  nDataArr: array[0..18] of byte;
  I: Integer;
  sSendData, sLogMsg: AnsiString;
begin
  // 0D 50 6F 73 43 6F 6D 6D 61 6E 64 0D 83 16 00 03 03 16 EF (3�� ���� ���¿�û)
  // 2~11 Byte : PosCommand (String)
  // 13 Byte : ���ι�ȣ (0x80 | 0x03) 0x03=���ι�ȣ
  // 14 Byte : Command
  // 15~16 Byte : Data Length
  // 17 Byte : ���ι�ȣ (���� ��û�� Ȧ���� ����(��ġ ID)�� ����) - ������ Ȧ�� ���� ¦�� ���� �����ؼ� ����
  // 18 Byte : Command

  // ���¿�û�� Ȧ�� ���� ��ȣ�� �Ѵ�. (01, 03, 05, 07, 09, 0B ...)

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
          inc(FCurIdx); //���� ���� ����Ÿ�� �̵�
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
      begin //������� �������� ������
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
            inc(FCurIdx); //���� ���� ����Ÿ�� �̵�
            if FCurIdx > BUFFER_SIZE then
              FCurIdx := 0;
          end;
        end;

        FWriteTm := now + (((1/24)/60)/60) * 1;
      end;

      //��ġ�� �����Ͱ��� ��û�ϴ� �κ�
      if bControlMode = False then
      begin
        FLastExeCommand := COM_MON;
        SendLaneGameStatus;
        FWriteTm := now + (((1/24)/60)/60) * 1;
      end;

      FReceived := False;
      Sleep(500);  //50 �����ΰ�� retry �߻�

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
