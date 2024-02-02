unit uCom;

interface

uses
  CPort, Vcl.ExtCtrls, System.SysUtils,System.Classes, IdTCPClient,
  uConsts, uStruct;

type

  TComThread = class(TThread)
  private
    FComPort: TComPort;
    FCmdSendBufArr: array[0..BUFFER_SIZE] of AnsiString;
    FRecvData: AnsiString;
    FSendData: AnsiString;

    FReTry: Integer;

    //2020-06-08 제어3회 시도후 에러처리
    FCtlReTry: Integer;
    FCtlChannel: String;

    FReceived: Boolean;
    FChannel: String;

    FIndex: Integer;
    FFloorCd: String; //층

    FTeeboxNoStart: Integer; //시작 타석번호
    FTeeboxNoEnd: Integer; //종료 타석번호
    FTeeboxNoLast: Integer; //마지막 요청 타석번호

    FLastIdx: word; //대기중인 명령번호
    FCurIdx: word;  //처리한 명령번호
    FLastCtlSeatNo: Integer; //최종 제어타석기
    //FLastMonSeatNo: Integer; //최종 모니터링 타석기
    FMonDeviceNoLast: Integer;
    FLastExeCommand: Integer; //최종 패킷 수행 펑션

    FWriteTm: TDateTime;

    //FTeeboxInfo: TTeeboxInfo;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ComPortSetting(AFloorCd: String; AIndex, ATeeboxNoStart, ATeeboxNoEnd, APort, ABaudRate: Integer);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure SetCmdSendBuffer(ASendData: AnsiString);
    function SetNextMonNo: Boolean;

    function SendPinSetterOnOff(ALaneNo, AUseYn: String): Boolean;
    function SendMoniterOnOff(ALaneNo, AUseYn: String): Boolean;
    function SendPinSettingNo(ALaneNo, ASetType: String): Boolean;
    function SendInitLane(ALaneNo: String): Boolean;

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
  //FLastMonSeatNo := 1;
  FMonDeviceNoLast := 0;
  FRecvData := '';

  Global.Log.LogWrite('TComThreadZoom Create');

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TComThread.Destroy;
begin
  FComPort.Close;
  FComPort.Free;
  inherited;
end;

procedure TComThread.ComPortSetting(AFloorCd: String; AIndex, ATeeboxNoStart, ATeeboxNoEnd, APort, ABaudRate: Integer);
begin
  FTeeboxNoStart := ATeeboxNoStart;
  FTeeboxNoEnd := ATeeboxNoEnd;
  FTeeboxNoLast := ATeeboxNoStart;
  FIndex := AIndex;
  FFloorCd := AFloorCd;

  FComPort := TComport.Create(nil);

  FComPort.OnRxChar := ComPortRxChar;
  FComPort.Port := 'COM' + IntToStr(APort);
  FComPort.BaudRate := GetBaudrate(ABaudRate);
  FComPort.Parity.Bits := prOdd;
  FComPort.Open;

  Global.Log.LogWrite('TComThreadZoom ComPortSetting : ' + IntToStr(AIndex));
end;


procedure TComThread.ComPortRxChar(Sender: TObject; Count: Integer);
var
  nFuncCode: Integer;
  DevNo, State, Time, Ball, BCC: string;
  sLogMsg: string;

  Index: Integer;
  sRecvData, sStatus: AnsiString;
  //rTeeboxInfo: TTeeboxInfo;

  nStx, nEtx: Integer;
begin


  FRecvData := '';
  FReceived := True;
end;

procedure TComThread.SetCmdSendBuffer(ASendData: AnsiString);
begin
  FCmdSendBufArr[FLastIdx] := ASendData;

  inc(FLastIdx);
  if FLastIdx > BUFFER_SIZE then
    FLastIdx := 0;
end;

function TComThread.SetNextMonNo: Boolean;
var
  sSendData, sBcc: AnsiString;
  sSeatTime, sSeatBall: AnsiString;
begin

  sSendData := sSeatTime + sSeatBall;
  sBcc := GetBccCtl(ZOOM_CTL_STX, sSendData, ZOOM_REQ_ETX);
  sSendData := ZOOM_CTL_STX + sSendData + ZOOM_REQ_ETX + sBcc;

  SetCmdSendBuffer(sSendData);
end;

function TComThread.SendPinSetterOnOff(ALaneNo, AUseYn: String): Boolean;
var
  sSendData, sBcc: AnsiString;
  sSeatTime, sSeatBall: AnsiString;
begin

  sSendData := sSeatTime + sSeatBall;
  sBcc := GetBccCtl(ZOOM_CTL_STX, sSendData, ZOOM_REQ_ETX);
  sSendData := ZOOM_CTL_STX + sSendData + ZOOM_REQ_ETX + sBcc;

  SetCmdSendBuffer(sSendData);
end;

function TComThread.SendMoniterOnOff(ALaneNo, AUseYn: String): Boolean;
var
  sSendData, sBcc: AnsiString;
  sSeatTime, sSeatBall: AnsiString;
begin

  sSendData := sSeatTime + sSeatBall;
  sBcc := GetBccCtl(ZOOM_CTL_STX, sSendData, ZOOM_REQ_ETX);
  sSendData := ZOOM_CTL_STX + sSendData + ZOOM_REQ_ETX + sBcc;

  SetCmdSendBuffer(sSendData);
end;

function TComThread.SendPinSettingNo(ALaneNo, ASetType: String): Boolean;
var
  sSendData, sBcc: AnsiString;
  sSeatTime, sSeatBall: AnsiString;
begin

  sSendData := sSeatTime + sSeatBall;
  sBcc := GetBccCtl(ZOOM_CTL_STX, sSendData, ZOOM_REQ_ETX);
  sSendData := ZOOM_CTL_STX + sSendData + ZOOM_REQ_ETX + sBcc;

  SetCmdSendBuffer(sSendData);

end;

function TComThread.SendInitLane(ALaneNo: String): Boolean;
var
  sSendData, sBcc: AnsiString;
  sSeatTime, sSeatBall: AnsiString;
begin

  sSendData := sSeatTime + sSeatBall;
  sBcc := GetBccCtl(ZOOM_CTL_STX, sSendData, ZOOM_REQ_ETX);
  sSendData := ZOOM_CTL_STX + sSendData + ZOOM_REQ_ETX + sBcc;

  SetCmdSendBuffer(sSendData);
end;

procedure TComThread.Execute;
var
  bControlMode: Boolean;
  sBcc: AnsiString;
  sLogMsg, sChannelR, sChannelL: String;
begin
  inherited;

  while not Terminated do
  begin
    try
      Synchronize(Global.TeeboxControlTimeCheck);

      while True do
      begin
        if FReceived = False then
        begin

          if now > FWriteTm then
          begin

            if FLastExeCommand = COM_CTL then
            begin
              //sLogMsg := 'Retry COM_CTL Received Fail : ' + IntToStr(FTeeboxInfo.TeeboxNo) + ' / ' + FTeeboxInfo.TeeboxNm + ' / ' + FSendData;
              Global.Log.LogWriteMulti(FIndex, sLogMsg);

              //sLogMsg := StrZeroAdd(FTeeboxInfo.TeeboxNm, 2) + ' : ' + FSendData + ' / Fail';
              //Global.DebugLogFromViewMulti(FIndex, sLogMsg);

              FRecvData := '';

              inc(FCtlReTry);
              if FCtlReTry > 2 then
              begin
                FCtlReTry := 0;
                FComPort.Close;
                FComPort.Open;
                Global.Log.LogWriteMulti(FIndex, 'ReOpen');
              end;

              if FLastIdx <> FCurIdx then
              begin
                inc(FCurIdx); //다음 제어 데이타로 이동
                if FCurIdx > BUFFER_SIZE then
                FCurIdx := 0;
              end;

              Break;
            end
            else
            begin
              //sLogMsg := 'Retry COM_MON Received Fail : ' + IntToStr(FTeeboxInfo.TeeboxNo) + ' / ' + FTeeboxInfo.TeeboxNm + ' / ' + FSendData + ' / ' + FRecvData;
              Global.Log.LogWriteMulti(FIndex, sLogMsg);

              //sLogMsg := StrZeroAdd(FTeeboxInfo.TeeboxNm, 2) + ' : ' + FSendData + ' / Fail';
              //Global.DebugLogFromViewMulti(FIndex, sLogMsg);

              //Global.Teebox.SetTeeboxErrorCntAD(FIndex, FTeeboxInfo.TeeboxNo, 'Y', 10);
              SetNextMonNo;

              inc(FReTry);
              if FReTry > 10 then
              begin
                FReTry := 0;
                FComPort.Close;
                FComPort.Open;
                Global.Log.LogWriteMulti(FIndex, 'ReOpen');
              end;

              Break;
            end;

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

      if not FComPort.Connected then
      begin
        FComPort.Open;
      end;

      FSendData := '';
      bControlMode := False;
      if (FLastIdx <> FCurIdx) then
      begin //대기중인 제어명령이 있으면
        bControlMode := True;
        FLastExeCommand := COM_CTL;
        FChannel := Copy(FCmdSendBufArr[FCurIdx], 2, 3);

        FSendData := FCmdSendBufArr[FCurIdx];
        FComPort.Write(FSendData[1], Length(FSendData));

        //FTeeboxInfo := Global.Teebox.GetDeviceToFloorTeeboxInfo(FFloorCd, FChannel);
        //sLogMsg := 'SendData : FCurCmdDataIdx ' + IntToStr(FCurCmdDataIdx) + ' No: ' + IntToStr(FTeeboxInfo.TeeboxNo) + ' / Nm: ' + FTeeboxInfo.TeeboxNm + ' / ' + FSendData;
        Global.Log.LogWriteMulti(FIndex, sLogMsg);

        Sleep(100);

        //제어후 리턴값이 없음
        sBcc := GetBCC(ZOOM_MON_STX, FChannel, ZOOM_REQ_ETX);
        FSendData := ZOOM_MON_STX + FChannel + ZOOM_REQ_ETX + sBcc;
        FComPort.Write(FSendData[1], Length(FSendData));
        Global.Log.LogWriteMulti(FIndex, 'SendData : FCurCmdDataIdx ' + IntToStr(FCurIdx) + ' / ' + FSendData);


        FWriteTm := now + (((1/24)/60)/60) * 1;
      end;

      //장치에 데이터값을 요청하는 부분
      if bControlMode = False then
      begin
        //1	2	3	4	5	6
        //	0	1	1		6
        //01	30	31	31	04	36
        FLastExeCommand := COM_MON;
        //FTeeboxInfo := Global.Teebox.GetTeeboxInfo(FTeeboxNoLast);
        //FChannel := FTeeboxInfo.DeviceId;

        sBcc := GetBCC(ZOOM_MON_STX, FChannel, ZOOM_REQ_ETX);
        FSendData := ZOOM_MON_STX + FChannel + ZOOM_REQ_ETX + sBcc;
        FComPort.Write(FSendData[1], Length(FSendData));

        FWriteTm := now + (((1/24)/60)/60) * 1;
      end;

      FReceived := False;
      Sleep(100);  //50 이하인경우 retry 발생

    except
      on e: Exception do
      begin
        sLogMsg := 'TComThreadZoom Error : ' + e.Message + ' / ' + FSendData;
        Global.Log.LogWrite(sLogMsg);
      end;
    end;
  end;

end;

end.
