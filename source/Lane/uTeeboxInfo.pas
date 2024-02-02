unit uTeeboxInfo;

interface

uses
  uStruct, uConsts,
  System.Classes, System.SysUtils, System.DateUtils,
  Uni, System.Generics.Collections;

type
  TTeebox = class
  private
    FTeeboxVersion: String;
    FTeeboxDevicNoList: array of String;

    FTeeboxDevicNoCnt: Integer;
    FTeeboxInfoList: array of TTeeboxInfo;

    FTeeboxLastNo: Integer;
    FBallBackEnd: Boolean; //볼회수종료
    FBallBackEndCtl: Boolean; //볼회수종료 재배정명령여부

    FBallBackUse: Boolean; //볼회수여부, 볼회수시 키오스크에서 홀드, 배정 막기위해
    FTeeboxStatusUse: Boolean;
    FTeeboxReserveUse: Boolean;

    FSendApiErrorList: TStringList;

  public
    constructor Create;
    destructor Destroy; override;

    procedure StartUp;

    function GetTeeboxListToApi: Boolean;
    function GetTeeboxListToDB: Boolean; //긴급배정용
    function SetTeeboxStartUseStatus: Boolean; //최초실행시

    //Teebox Thread
    procedure TeeboxReserveNextChk;

    //AD 시간계산 - 배정관리후 상태확인
    procedure TeeboxStatusChkTeebox; //타석기시간 기준-제이제이만 사용
    procedure TeeboxReserveChkTeebox;
    procedure TeeboxReserveChkAD;
    procedure TeeboxStatusChkAD;
    procedure SetTeeboxInfoAD(ATeeboxInfo: TTeeboxInfo);
    procedure SetTeeboxErrorCntAD(AIndex, ATeeboxNo: Integer; AError: String; AMaxCnt: Integer);
    procedure TeeboxReserveNextChkAD;
    procedure SetTeeboxCtrlAD(ATeeboxNo: Integer; AType: String; ATime: Integer; ABall: Integer);

    //Teebox Thread
    procedure SetTeeboxDelay(ATeeboxNo: Integer; AType: Integer);

    procedure SetStoreClose;
    //procedure SetTeeboxCtrl(ATeeboxNo: Integer; AType: String; ATime: Integer; ABall: Integer);
    procedure SetTeeboxCtrlRemainMin(ATeeboxNo: Integer; ATime: Integer); // MODENYJ 조광, 타석점검제어 용
    procedure SetTeeboxCtrlRemainMinFree(ATeeboxNo: Integer); // MODENYJ 조광, 타석점검제어 해제 용
    //procedure SetTeeboxBallBackReply; //볼회수 종료후 한번더 배정위해

    procedure SetTeeboxErrorCntModen(AIndex: Integer; ATeeboxNo: Integer; AError: String);

    function TeeboxDeviceCheck(ATeeboxNo: Integer; AType: String): Boolean;
    function TeeboxBallRecallStart: Boolean;
    function TeeboxBallRecallEnd: Boolean;

    function GetDevicToTeeboxNo(ADev: String): Integer;
    function GetDevicToFloorTeeboxNo(AFloor, ADev: String): Integer;

    function GetDevicToTeeboxNm(ADev: String): String;
    function GetTeeboxNoToDevic(ATeeboxNo: Integer): String;
    function GetTeeboxDevicdNoToDevic(AIndex: Integer): String; //장치ID 배열(좌우겸용으로 인해 별도 관리)

    function GetTeeboxInfo(ATeeboxNo: Integer): TTeeboxInfo;
    function GetNmToTeeboxInfo(ATeeboxNm: String): TTeeboxInfo;
    function GetTeeboxInfoA(AChannelCd: String): TTeeboxInfo;
    function GetDeviceToFloorTeeboxInfo(AFloor, AChannelCd: String): TTeeboxInfo;

    function GetTeeboxInfoUseYn(ATeeboxNo: Integer): String;
    function GetTeeboxStatusList: AnsiString;
    function GetTeeboxStatus(ATeebox: String): AnsiString;
    function GetTeeboxStatusError(ATeebox, ATeebox1: String): AnsiString;
    function GetTeeboxFloorNm(ATeeboxNo: Integer): String;
    function GetTeeboxErrorCode(ATeeboxNo: Integer): String;

    function SetTeeboxHold(ATeeboxNo, AUserId: String; AUse: Boolean): Boolean;
    function GetTeeboxHold(ATeeboxNo, AUserId, AType: String): Boolean;

    //function CheckSeatReserve(ATeeboxInfo: TTeeboxInfo): Boolean;
    function SetTeeboxReserveInfo(ASeatReserveInfo: TSeatUseReserve): String;
    function SetTeeboxReserveChange(ASeatUseInfo: TSeatUseInfo): Boolean;
    function SetTeeboxReserveCancle(ATeeboxNo: Integer; AReserveNo: String): Boolean;
    function SetTeeboxReserveClose(ATeeboxNo: Integer; AReserveNo: String): Boolean;
    function SetTeeboxReserveStartNow(ATeeboxNo: Integer; AReserveNo: String): String; //즉시배정
    function SetTeeboxReserveCheckIn(ATeeboxNo: Integer; AReserveNo: String): Boolean; //체크인

    function ResetTeeboxRemainMinAdd(ATeeboxNo, ADelayTm: Integer; ATeeboxNm: String): Boolean;

    //2020-08-26 v26 기기고장 시간보상
    function ResetTeeboxRemainMinAddJMS(ATeeboxNo, ADelayTm: Integer): Boolean;

    //예약시간 확인
    function GetTeeboxNowReserveLastTime(ATeeboxNo: String): String; //2021-04-19 현시간 배정 예약시간 검증

    //메인 데이터 확인용
    //function SetTeeboxReservePrepare(ATeeboxNo: Integer): String;

    procedure SendADStatusToErp;
    procedure SendApiErrorRetry;
    function SetSendApiErrorAdd(AReserveNo, AApi, AStr: String): Boolean;

    function TeeboxClear: Boolean;

    property TeeboxLastNo: Integer read FTeeboxLastNo write FTeeboxLastNo;
    property TeeboxDevicNoCnt: Integer read FTeeboxDevicNoCnt write FTeeboxDevicNoCnt;

    property BallBackEnd: Boolean read FBallBackEnd write FBallBackEnd;
    property BallBackEndCtl: Boolean read FBallBackEndCtl write FBallBackEndCtl;
    property BallBackUse: Boolean read FBallBackUse write FBallBackUse;

    property TeeboxStatusUse: Boolean read FTeeboxStatusUse write FTeeboxStatusUse;
    property TeeboxReserveUse: Boolean read FTeeboxReserveUse write FTeeboxReserveUse;
  end;

implementation

uses
  uGlobal, uFunction, JSON;

{ Tasuk }

constructor TTeebox.Create;
begin
  TeeboxLastNo := 0;
  FTeeboxDevicNoCnt := 0;

  FBallBackUse := False;
  FBallBackEnd := False;
  FBallBackEndCtl := False;

  FTeeboxStatusUse := False;
  FTeeboxReserveUse := False;
end;

destructor TTeebox.Destroy;
begin
  TeeboxClear;

  inherited;
end;

procedure TTeebox.StartUp;
begin
  if Global.ADConfig.Emergency = False then
    GetTeeboxListToApi
  else
    GetTeeboxListToDB;

  Global.ReserveList.StartUp;

  SetTeeboxStartUseStatus;
  FSendApiErrorList := TStringList.Create;
end;

function TTeebox.GetTeeboxListToApi: Boolean;
var
  nIndex, nTeeboxNo, nTeeboxCnt: Integer;
  jObjArr: TJsonArray;
  jObj, jObjSub: TJSONObject;

  sJsonStr: AnsiString;
  sResult, sResultCd, sResultMsg, sLog: String;
begin
  Result := False;

  try

    sJsonStr := '?store_cd=' + Global.ADConfig.StoreCode +
                '&client_id=' + Global.ADConfig.UserId;
    sResult := Global.Api.GetErpApiNoneData(sJsonStr, 'K204_TeeBoxlist', Global.ADConfig.ApiUrl, Global.ADConfig.ADToken);
    //Global.Log.LogWrite(sResult);

    if (Copy(sResult, 1, 1) <> '{') or (Copy(sResult, Length(sResult), 1) <> '}') then
    begin
      sLog := 'GetSeatListToApi Fail : ' + sResult;
      Global.Log.LogWrite(sLog);
      Exit;
    end;

    jObj := TJSONObject.ParseJSONValue(sResult) as TJSONObject;
    sResultCd := jObj.GetValue('result_cd').Value;
    sResultMsg := jObj.GetValue('result_msg').Value;

    if sResultCd <> '0000' then
    begin
      sLog := 'K204_TeeBoxlist : ' + sResultCd + ' / ' + sResultMsg;
      Global.Log.LogWrite(sLog);
      Exit;
    end;

    jObjArr := jObj.GetValue('result_data') as TJsonArray;

    nTeeboxCnt := jObjArr.Size;
    SetLength(FTeeboxInfoList, nTeeboxCnt + 1);
    SetLength(FTeeboxDevicNoList, 0);

    for nIndex := 0 to nTeeboxCnt - 1 do
    begin
      jObjSub := jObjArr.Get(nIndex) as TJSONObject;
      nTeeboxNo := StrToInt(jObjSub.GetValue('teebox_no').Value);
      if FTeeboxLastNo < nTeeboxNo then
        FTeeboxLastNo := nTeeboxNo;

      FTeeboxInfoList[nTeeboxNo].TeeboxNo := StrToInt(jObjSub.GetValue('teebox_no').Value);
      FTeeboxInfoList[nTeeboxNo].TeeboxNm := jObjSub.GetValue('teebox_nm').Value;
      FTeeboxInfoList[nTeeboxNo].FloorZoneCode := jObjSub.GetValue('floor_cd').Value;
      FTeeboxInfoList[nTeeboxNo].FloorNm := jObjSub.GetValue('floor_nm').Value;
      FTeeboxInfoList[nTeeboxNo].TeeboxZoneCode := jObjSub.GetValue('zone_div').Value;
      FTeeboxInfoList[nTeeboxNo].ControlYn := jObjSub.GetValue('control_yn').Value;
      FTeeboxInfoList[nTeeboxNo].DeviceId := jObjSub.GetValue('device_id').Value;
      FTeeboxInfoList[nTeeboxNo].UseYn := jObjSub.GetValue('use_yn').Value;
      FTeeboxInfoList[nTeeboxNo].DelYn := jObjSub.GetValue('del_yn').Value;

      if FTeeboxInfoList[nTeeboxNo].DelYn = 'Y' then
        Continue;

      if FTeeboxInfoList[nTeeboxNo].UseYn = 'Y' then
      begin

        SetLength(FTeeboxDevicNoList, FTeeboxDevicNoCnt + 1);
        if (FTeeboxInfoList[nTeeboxNo].TeeboxZoneCode = 'L') and (Global.ADConfig.StoreCode <> 'AB001') then
        begin
          if (Global.ADConfig.ProtocolType = 'ZOOM') or (Global.ADConfig.ProtocolType = 'ZOOM1') then
          begin
            FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 1, 3);
            inc(FTeeboxDevicNoCnt);

            if Length(FTeeboxInfoList[nTeeboxNo].DeviceId) = 6 then
            begin
              SetLength(FTeeboxDevicNoList, FTeeboxDevicNoCnt + 1);
              FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 4, 3);
              inc(FTeeboxDevicNoCnt);
            end;
          end
          else if (Global.ADConfig.ProtocolType = 'JEHU435') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
          begin
            FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 1, 2);
            inc(FTeeboxDevicNoCnt);

            if Length(FTeeboxInfoList[nTeeboxNo].DeviceId) = 4 then
            begin
              SetLength(FTeeboxDevicNoList, FTeeboxDevicNoCnt + 1);
              FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 3, 2);
              inc(FTeeboxDevicNoCnt);
            end;
          end
          else
          begin
            FTeeboxDevicNoList[FTeeboxDevicNoCnt] := FTeeboxInfoList[nTeeboxNo].DeviceId;
            inc(FTeeboxDevicNoCnt);
          end;
        end
        else
        begin
          FTeeboxDevicNoList[FTeeboxDevicNoCnt] := FTeeboxInfoList[nTeeboxNo].DeviceId;
          inc(FTeeboxDevicNoCnt);
        end;

      end;

      FTeeboxInfoList[nTeeboxNo].UseStatus := '0';

      FTeeboxInfoList[nTeeboxNo].UseRStatus := '0';
      FTeeboxInfoList[nTeeboxNo].UseLStatus := '0';

      FTeeboxInfoList[nTeeboxNo].ComReceive := 'N'; //최초 1회 체크
      FTeeboxInfoList[nTeeboxNo].ErrorYn := 'N'; //최초 1회 체크
    end;

  finally
    FreeAndNil(jObj);
  end;

  Result := True;
end;

function TTeebox.GetTeeboxListToDB: Boolean;
var
  rTeeboxInfoList: TList<TTeeboxInfo>;
  nIndex, nTeeboxNo, nTeeboxCnt: Integer;
  sLog: String;
begin
  Result := False;

  rTeeboxInfoList := Global.XGolfDM.SeatSelect;

  try

    nTeeboxCnt := rTeeboxInfoList.Count;
    SetLength(FTeeboxInfoList, nTeeboxCnt + 1);
    SetLength(FTeeboxDevicNoList, 0);

    for nIndex := 0 to nTeeboxCnt - 1 do
    begin

      nTeeboxNo := rTeeboxInfoList[nIndex].TeeboxNo;
      if FTeeboxLastNo < nTeeboxNo then
        FTeeboxLastNo := nTeeboxNo;

      FTeeboxInfoList[nTeeboxNo].TeeboxNo := rTeeboxInfoList[nIndex].TeeboxNo;
      FTeeboxInfoList[nTeeboxNo].TeeboxNm := rTeeboxInfoList[nIndex].TeeboxNm;
      FTeeboxInfoList[nTeeboxNo].FloorZoneCode := rTeeboxInfoList[nIndex].FloorZoneCode;
      FTeeboxInfoList[nTeeboxNo].FloorNm := rTeeboxInfoList[nIndex].FloorNm;
      FTeeboxInfoList[nTeeboxNo].TeeboxZoneCode := rTeeboxInfoList[nIndex].TeeboxZoneCode;

      //빅토리아 반자동 29,28,2,1,58,57,31,30
      if Global.ADConfig.StoreCode = 'A7001' then
      begin
        if (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '29') or (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '28') or
           (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '2') or (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '1') or
           (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '58') or (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '57') or
           (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '31') or (FTeeboxInfoList[nTeeboxNo].TeeboxNm = '30') then
        begin
          FTeeboxInfoList[nTeeboxNo].ControlYn := 'N';
        end
        else
        begin
          FTeeboxInfoList[nTeeboxNo].ControlYn := 'Y';
        end;
      end
      else
      begin
        FTeeboxInfoList[nTeeboxNo].ControlYn := 'Y';
      end;

      FTeeboxInfoList[nTeeboxNo].DeviceId := rTeeboxInfoList[nIndex].DeviceId;
      FTeeboxInfoList[nTeeboxNo].UseYn := rTeeboxInfoList[nIndex].UseYn;
      FTeeboxInfoList[nTeeboxNo].DelYn := rTeeboxInfoList[nIndex].DelYn;

      if FTeeboxInfoList[nTeeboxNo].UseYn = 'Y' then
      begin

        SetLength(FTeeboxDevicNoList, FTeeboxDevicNoCnt + 1);
        if (FTeeboxInfoList[nTeeboxNo].TeeboxZoneCode = 'L') and (Global.ADConfig.StoreCode <> 'AB001') then
        begin
          if (Global.ADConfig.ProtocolType = 'ZOOM') or (Global.ADConfig.ProtocolType = 'ZOOM1') then
          begin
            FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 1, 3);
            inc(FTeeboxDevicNoCnt);

            if Length(FTeeboxInfoList[nTeeboxNo].DeviceId) = 6 then
            begin
              SetLength(FTeeboxDevicNoList, FTeeboxDevicNoCnt + 1);
              FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 4, 3);
              inc(FTeeboxDevicNoCnt);
            end;
          end
          else if (Global.ADConfig.ProtocolType = 'JEHU435') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
          begin
            FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 1, 2);
            inc(FTeeboxDevicNoCnt);

            if Length(FTeeboxInfoList[nTeeboxNo].DeviceId) = 4 then
            begin
              SetLength(FTeeboxDevicNoList, FTeeboxDevicNoCnt + 1);
              FTeeboxDevicNoList[FTeeboxDevicNoCnt] := Copy(FTeeboxInfoList[nTeeboxNo].DeviceId, 3, 2);
              inc(FTeeboxDevicNoCnt);
            end;
          end
          else
          begin
            FTeeboxDevicNoList[FTeeboxDevicNoCnt] := FTeeboxInfoList[nTeeboxNo].DeviceId;
            inc(FTeeboxDevicNoCnt);
          end;
        end
        else
        begin
          FTeeboxDevicNoList[FTeeboxDevicNoCnt] := FTeeboxInfoList[nTeeboxNo].DeviceId;
          inc(FTeeboxDevicNoCnt);
        end;

      end;

      FTeeboxInfoList[nTeeboxNo].UseStatus := '0';

      FTeeboxInfoList[nTeeboxNo].UseRStatus := '0';
      FTeeboxInfoList[nTeeboxNo].UseLStatus := '0';

      FTeeboxInfoList[nTeeboxNo].ComReceive := 'N'; //최초 1회 체크
    end;

  finally
    FreeAndNil(rTeeboxInfoList);
  end;

  Result := True;
end;

function TTeebox.SetTeeboxStartUseStatus: Boolean;
var
  rTeeboxInfoList: TList<TTeeboxInfo>;
  rSeatUseReserveList: TList<TSeatUseReserve>;

  nDBMax: Integer;
  I, nTeeboxNo, nIndex: Integer;
  sStausChk, sBallBackStart: String;
  sStr, sPreDate: String;

  NextReserve: TNextReserve;
  nErpReserveNo: Integer;

  sErrorReserveNo, sErrorStart, sErrorReward: String;
begin
  rTeeboxInfoList := Global.XGolfDM.SeatSelect;

  sStausChk := '';
  nDBMax := 0;
  for I := 0 to rTeeboxInfoList.Count - 1 do
  begin
    nTeeboxNo := rTeeboxInfoList[I].TeeboxNo;

    if (FTeeboxInfoList[nTeeboxNo].TeeboxNm <> rTeeboxInfoList[I].TeeboxNm) or
       (FTeeboxInfoList[nTeeboxNo].FloorZoneCode <> rTeeboxInfoList[I].FloorZoneCode) or
       (FTeeboxInfoList[nTeeboxNo].FloorNm <> rTeeboxInfoList[I].FloorNm) or //2021-06-25 층명 추가(이선우이사님)
       (FTeeboxInfoList[nTeeboxNo].TeeboxZoneCode <> rTeeboxInfoList[I].TeeboxZoneCode) or
       (FTeeboxInfoList[nTeeboxNo].DeviceId <> rTeeboxInfoList[I].DeviceId) or
       (FTeeboxInfoList[nTeeboxNo].UseYn <> rTeeboxInfoList[I].UseYn) or
       (FTeeboxInfoList[nTeeboxNo].DelYn <> rTeeboxInfoList[I].DelYn) then
    begin
      if Global.ADConfig.Emergency = False then
        Global.XGolfDM.SeatUpdate(Global.ADConfig.StoreCode, FTeeboxInfoList[nTeeboxNo]);
    end;

    FTeeboxInfoList[nTeeboxNo].UseStatusPre := rTeeboxInfoList[I].UseStatus;
    FTeeboxInfoList[nTeeboxNo].UseStatus := rTeeboxInfoList[I].UseStatus;

    if FTeeboxInfoList[nTeeboxNo].UseStatus = '8' then
      TeeboxDeviceCheck(nTeeboxNo, '8');

    if FTeeboxInfoList[nTeeboxNo].UseStatus = '7' then
    begin
      sStausChk := '7';
      FTeeboxInfoList[nTeeboxNo].RemainMinPre := rTeeboxInfoList[I].RemainMinute;
      FTeeboxInfoList[nTeeboxNo].RemainMinute := rTeeboxInfoList[I].RemainMinute;

      if FTeeboxInfoList[nTeeboxNo].RemainMinute > 0 then
        FTeeboxInfoList[nTeeboxNo].UseStatusPre := '1'
      else
        FTeeboxInfoList[nTeeboxNo].UseStatusPre := '0';
    end;

    if FTeeboxInfoList[nTeeboxNo].UseStatus = '9' then
    begin
      FTeeboxInfoList[nTeeboxNo].RemainMinPre := rTeeboxInfoList[I].RemainMinute;
      FTeeboxInfoList[nTeeboxNo].RemainMinute := rTeeboxInfoList[I].RemainMinute;
      FTeeboxInfoList[nTeeboxNo].DeviceUseStatus := '9'; // 재시작시 장비상태 확인전 배정상태 확인
    end;

    FTeeboxInfoList[nTeeboxNo].RemainBall := rTeeboxInfoList[I].RemainBall;

    FTeeboxInfoList[nTeeboxNo].HoldUse := False;
    FTeeboxInfoList[nTeeboxNo].HoldUse := rTeeboxInfoList[I].HoldUse;
    FTeeboxInfoList[nTeeboxNo].HoldUser := rTeeboxInfoList[I].HoldUser;

    if FTeeboxInfoList[nTeeboxNo].HoldUse = True then
    begin
      sStr := 'HoldUse : ' + IntToStr(nTeeboxNo) + ' / ' +
              FTeeboxInfoList[nIndex].TeeboxNm;
      Global.Log.LogWrite(sStr);
    end;

    if nTeeboxNo > nDBMax then
      nDBMax := nTeeboxNo;
  end;
  FreeAndNil(rTeeboxInfoList);

  if FTeeboxLastNo > nDBMax then
  begin
    for I := nDBMax + 1 to FTeeboxLastNo do
    begin
      Global.XGolfDM.SeatInsert(Global.ADConfig.StoreCode, FTeeboxInfoList[I]);
    end;
  end;

  //2020-06-09 전날 배정 정리
  if FormatDateTime('hh', now) <= Copy(Global.Store.StartTime, 1, 2) then
  begin
    sPreDate := FormatDateTime('YYYYMMDD', now - 1);
    Global.XGolfDM.SeatUseStoreClose(Global.ADConfig.StoreCode, Global.ADConfig.UserId, sPreDate);
  end;

  //타석 현재사용중 또는 바로 배정할 대기목록
  rSeatUseReserveList := Global.XGolfDM.SeatUseAllReserveSelect(Global.ADConfig.StoreCode, '');
  for nIndex := 0 to rSeatUseReserveList.Count - 1 do
  begin
    nTeeboxNo := rSeatUseReserveList[nIndex].SeatNo;

    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo := rSeatUseReserveList[nIndex].ReserveNo;
    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin := rSeatUseReserveList[nIndex].UseMinute;
    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignBalls := rSeatUseReserveList[nIndex].UseBalls;
    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareMin := rSeatUseReserveList[nIndex].DelayMinute;
    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate := rSeatUseReserveList[nIndex].ReserveDate;
    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareEndTime := DateStrToDateTime3(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate) +
                                                        (((1/24)/60) * FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareMin);

    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'N';
    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := rSeatUseReserveList[nIndex].StartTime;
    if rSeatUseReserveList[nIndex].UseStatus = '1' then
    begin
      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
      Global.Log.LogReserveWrite('UseStatus = 1 '  + rSeatUseReserveList[nIndex].ReserveNo);

      if (Global.ADConfig.StoreCode = 'B7001') and (Global.ComInfornetPLC <> nil) then
      begin
        if FTeeboxInfoList[nTeeboxNo].TeeboxNo > 52 then
        begin
          Global.ComInfornetPLC.SetTeeboxUse(FTeeboxInfoList[nTeeboxNo].TeeboxNm, '1');
        end;
      end;
    end;

    if Global.ADConfig.StoreCode = 'A5001' then //송도
    begin
      if FTeeboxInfoList[nTeeboxNo].UseStatus = '0' then
        FTeeboxInfoList[nTeeboxNo].UseLStatus := '1';
    end;

    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignYn := rSeatUseReserveList[nIndex].AssignYn;

    // 기기고장일경우
    if FTeeboxInfoList[nTeeboxNo].UseStatus = '9' then
    begin
      Global.ReadConfigError(nTeeboxNo, sErrorReserveNo, sErrorStart, sErrorReward);
      if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo = sErrorReserveNo then
      begin
        if sErrorStart = EmptyStr then
          FTeeboxInfoList[nTeeboxNo].PauseTime := Now
        else
          FTeeboxInfoList[nTeeboxNo].PauseTime := DateStrToDateTime2(sErrorStart);

        if sErrorReward = 'Y' then
          FTeeboxInfoList[nTeeboxNo].ErrorReward := True
        else
          FTeeboxInfoList[nTeeboxNo].ErrorReward := False;
      end
      else
      begin
        FTeeboxInfoList[nTeeboxNo].DeviceUseStatus := ''; // 에러시 배정과 다른경우
      end;
    end;

    sStr := '목록 : ' + IntToStr(nTeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin);
    Global.Log.LogReserveWrite(sStr);

  end;
  FreeAndNil(rSeatUseReserveList);

  //타석 현재 사용중,대기중이 종료후 배정할 예약목록
  rSeatUseReserveList := Global.XGolfDM.SeatUseAllReserveSelectNext(Global.ADConfig.StoreCode);

  for nIndex := 0 to rSeatUseReserveList.Count - 1 do
  begin
    if rSeatUseReserveList[nIndex].SeatNo = 0 then
      Continue;

    nTeeboxNo := rSeatUseReserveList[nIndex].SeatNo;

    if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo = rSeatUseReserveList[nIndex].ReserveNo then
      Continue;

    Global.ReserveList.SetTeeboxReserveNext(rSeatUseReserveList[nIndex]);

    sStr := '예약목록 : ' + IntToStr(nTeeboxNo) + ' / ' + rSeatUseReserveList[nIndex].ReserveNo;
    Global.Log.LogReserveWrite(sStr);
  end;

  FreeAndNil(rSeatUseReserveList);

  //if (Global.ADConfig.StoreCode = 'A4001') and //유명
  if (Global.Store.StartTime > Global.Store.EndTime) then
  begin

    if FormatDateTime('HH:NN', Now) < Global.Store.EndTime then
    begin
      Global.TcpServer.UseSeqNo := Global.XGolfDM.ReserveDateNo(Global.ADConfig.StoreCode, FormatDateTime('YYYYMMDD', Now - 1));
      Global.TcpServer.LastUseSeqNo := Global.TcpServer.UseSeqNo;
      Global.TcpServer.UseSeqDate := FormatDateTime('YYYYMMDD', Now - 1);
    end
    else
    begin
      Global.TcpServer.UseSeqNo := Global.XGolfDM.ReserveDateNo(Global.ADConfig.StoreCode, FormatDateTime('YYYYMMDD', Now));
      Global.TcpServer.LastUseSeqNo := Global.TcpServer.UseSeqNo;
      Global.TcpServer.UseSeqDate := FormatDateTime('YYYYMMDD', Now);
    end;

  end
  else
  begin
    Global.TcpServer.UseSeqNo := Global.XGolfDM.ReserveDateNo(Global.ADConfig.StoreCode, FormatDateTime('YYYYMMDD', Now));
    Global.TcpServer.LastUseSeqNo := Global.TcpServer.UseSeqNo;
    Global.TcpServer.UseSeqDate := FormatDateTime('YYYYMMDD', Now);
  end;

  //시작시 볼회수 상태이면
  if sStausChk = '7' then
  begin
    sBallBackStart := Global.ReadConfigBallBackStartTime;
    if sBallBackStart = '' then
      FTeeboxInfoList[0].PauseTime := Now
    else
      FTeeboxInfoList[0].PauseTime := DateStrToDateTime2(sBallBackStart);

    //2022-01-12 그린필드
    if (Global.Store.UseRewardYn = 'N') and (Global.ADConfig.StoreCode <> 'B9001' ) then //파스텔 제외
    begin
      sStr := FormatDateTime('hhnn', FTeeboxInfoList[0].PauseTime);
      if (sStr < global.Store.BallRecallStartTime) or (sStr > global.Store.BallRecallEndTime) then
      begin
        Global.SetStoreUseRewardException('Y');
        Global.Log.LogReserveWrite('UseRewardYn = N / UseRewardException = Y');
      end;
    end;

    //chy 2020-10-30 볼회수 체크
    FBallBackUse := True;
  end;
end;
{
//재시작시 예약내용과 타석기배정상태를 비교
function TTeebox.CheckSeatReserve(ATeeboxInfo: TTeeboxInfo): Boolean;
var
  nTeeboxNo, nUseTime: Integer;
  tmSeatEndExceptChkTime: TDateTime;
  sStr: String;
  bPrepare: Boolean;
begin
  nTeeboxNo := ATeeboxInfo.TeeboxNo;

  if (ATeeboxInfo.RemainMinute = 0) and (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo = '' ) then
  begin
    FTeeboxInfoList[nTeeboxNo].RemainMinPre := ATeeboxInfo.RemainMinute;
    FTeeboxInfoList[nTeeboxNo].RemainMinute := ATeeboxInfo.RemainMinute;
    Exit;
  end;

  FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'N';
  //Global.Log.LogReserveWrite('6');

  //오류로 재시작시 타석기의 배정이 끝난 경우
  if (ATeeboxInfo.RemainMinute = 0) and (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate <> '' ) then
  begin
    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';

    tmSeatEndExceptChkTime := DateStrToDateTime3(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate) +
                               (((1/24)/60) * FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin);
    //배정종료시간을 넘은경우
    if tmSeatEndExceptChkTime < Now then
    begin
      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

      sStr := '배정종료 예외처리 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
              IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareMin) + ' / ' +
              IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate + ' / ' +
              formatdatetime('YYYY-MM-DD hh:nn:ss', Now);
      Global.Log.LogReserveWrite(sStr);

      Global.TcpServer.SetApiTeeBoxEnd(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                       FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate, '2');
    end
    else //볼회수중 AD종료, 볼회수 종료후 AD 구동인경우
    begin
      if (Global.ADConfig.ProtocolType = 'JMS') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
      begin
        ATeeboxInfo.RemainMinute := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin;
      end
      else
      begin
        //배정위해 제어배열에 등록
        SetTeeboxCtrl(nTeeboxNo, 'S1' , FTeeboxInfoList[nTeeboxNo].RemainMinute, FTeeboxInfoList[nTeeboxNo].RemainBall);

        sStr := '재기동 복귀명령 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute) + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].RemainBall) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].UseStatus;
        Global.Log.LogReserveWrite(sStr);
      end;
    end;
  end;

  //if (Global.ADConfig.ProtocolType <> 'JMS') and (Global.ADConfig.ProtocolType <> 'MODENYJ') then
  begin

  if (ATeeboxInfo.UseStatus = '1') and (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> '' ) then
  begin
    if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate = '') then
    begin
      nUseTime := (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin - ATeeboxInfo.RemainMinute);
      //FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := FormatDateTime('YYYYMMDDhhnnss', Now - (((1/24)/60) * nUseTime) );
      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := FormatDateTime('YYYYMMDDhhnn00', Now - (((1/24)/60) * nUseTime) ); //2021-06-11

      sStr := 'StartDate reset - Config: ' + FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate;
      Global.Log.LogReserveWrite(sStr);

      Global.XGolfDM.SeatUseStartDateUpdate(Global.ADConfig.StoreCode, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                          FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate, Global.ADConfig.UserId);
    end;

    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
  end;

  end;

  FTeeboxInfoList[nTeeboxNo].RemainMinPre := ATeeboxInfo.RemainMinute;
  FTeeboxInfoList[nTeeboxNo].RemainMinute := ATeeboxInfo.RemainMinute;

end;
}
function TTeebox.TeeboxDeviceCheck(ATeeboxNo: Integer; AType: String): Boolean;
begin
  //FTeeboxInfoList[ATeeboxNo].UseApiStatus := AType;

  if AType = '8' then
    FTeeboxInfoList[ATeeboxNo].UseStatus := AType
  else
  begin
    //2021-10-12 점검해제시 상태값 재확인
    if FTeeboxInfoList[ATeeboxNo].RemainMinute = 0 then
      FTeeboxInfoList[ATeeboxNo].UseStatus := '0'
    else
      FTeeboxInfoList[ATeeboxNo].UseStatus := '1';
  end;

  if (Global.ADConfig.ProtocolType = 'MODENYJ') and (AType = '0') then //점검 해제시
    SetTeeboxCtrlRemainMinFree(ATeeboxNo);
end;

function TTeebox.TeeboxBallRecallStart: Boolean;
var
  nIndex: Integer;
  sStr: String;
begin
  Result := False;

  //볼회수 일경우 현재 남은시간 저장
  Global.WriteConfigBall(0);
  //보상시간 체크시작
  SetTeeboxDelay(0, 0);

  if (Global.Store.UseRewardYn = 'N') and (Global.ADConfig.StoreCode <> 'B9001' ) then //파스텔 제외
  begin
    sStr := FormatDateTime('hhnn', Now);
    if (sStr < global.Store.BallRecallStartTime) or (sStr > global.Store.BallRecallEndTime) then
    begin
      Global.SetStoreUseRewardException('Y');
      Global.Log.LogReserveWrite('UseRewardYn = N / UseRewardException = Y');
    end
    else
    begin
      Global.SetStoreUseRewardException('N');
      Global.Log.LogReserveWrite('UseRewardYn = N / UseRewardException = N');
    end;
  end;

  for nIndex := 1 to TeeboxLastNo do
  begin
    if FTeeboxInfoList[nIndex].UseStatus = '9' then //타석기 고장
      Continue;

    if FTeeboxInfoList[nIndex].UseStatus = '8' then //점검상태
      Continue;

    if FTeeboxInfoList[nIndex].UseStatus = '7' then //정지상태
      Continue;

    if (global.ADConfig.StoreCode = 'B7001') and (nIndex > 52) then //프라자 3층은 전원만 제어 볼회수 제외
      Continue;

    FTeeboxInfoList[nIndex].UseStatusPre := FTeeboxInfoList[nIndex].UseStatus;

    FTeeboxInfoList[nIndex].UseStatus := '7';
    FTeeboxInfoList[nIndex].DeviceCtrlCnt := 0; //제어횟수 초기화

    if FTeeboxInfoList[nIndex].RemainMinute > 0 then
    begin
      SetTeeboxCtrlAD(nIndex, 'S1' , 0, FTeeboxInfoList[nIndex].RemainBall);

      sStr := '정지명령 : ' + IntToStr(FTeeboxInfoList[nIndex].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nIndex].TeeboxNm + ' / ' +
              FTeeboxInfoList[nIndex].TeeboxReserve.ReserveNo + ' / ' +
              IntToStr(FTeeboxInfoList[nIndex].RemainMinute) + ' / ' +
              IntToStr(FTeeboxInfoList[nIndex].RemainBall) + ' / ' +
              '7' + ' / ' + FTeeboxInfoList[nIndex].DeviceId;
      Global.Log.LogReserveWrite(sStr);
    end;

    Global.XGolfDM.TeeboxInfoUpdate(nIndex, FTeeboxInfoList[nIndex].RemainMinute, FTeeboxInfoList[nIndex].RemainBall, FTeeboxInfoList[nIndex].UseStatus, '');
  end;

  FBallBackEnd := False;
  BallBackEndCtl := False;

  FBallBackUse := True;

  Result := True;
end;

function TTeebox.TeeboxBallRecallEnd: Boolean;
var
  nIndex, nSeatRemainMin: Integer;
  sStr: String;
  nNum: Integer;
  sResult: String;
begin
  Result := False;
  //보상시간 체크종료
  SetTeeboxDelay(0, 1);

  //볼회수 딜레이 저장
  Global.WriteConfigBallBackDelay(FTeeboxInfoList[0].DelayMin);

  for nIndex := 1 to TeeboxLastNo do
  begin
    if FTeeboxInfoList[nIndex].UseStatus <> '7' then //정지상태
      Continue;

    if FTeeboxInfoList[nIndex].RemainMinute > 0 then
    begin
      if (Global.Store.UseRewardYn = 'Y') or // AD_JEU435, SM
         ((Global.Store.UseRewardYn = 'N') and (Global.Store.UseRewardException = 'Y')) then
      begin
        FTeeboxInfoList[nIndex].TeeboxReserve.AssignMin := FTeeboxInfoList[nIndex].TeeboxReserve.AssignMin + FTeeboxInfoList[0].DelayMin;

        sStr := '복귀명령 : ' + IntToStr(FTeeboxInfoList[nIndex].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nIndex].TeeboxNm + ' / ' +
                FTeeboxInfoList[nIndex].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nIndex].TeeboxReserve.AssignMin) + ' / ' +
                IntToStr(FTeeboxInfoList[0].DelayMin) + ' / Min : ' + IntToStr(FTeeboxInfoList[nIndex].RemainMinute) + ' / UseStatusPre : ' + FTeeboxInfoList[nIndex].UseStatusPre;
      end
      else  //시간보상이 아니면
      begin
        sStr := '복귀명령 : ' + IntToStr(FTeeboxInfoList[nIndex].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nIndex].TeeboxNm + ' / ' +
                FTeeboxInfoList[nIndex].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nIndex].RemainMinute) + ' / ' +
                IntToStr(FTeeboxInfoList[nIndex].RemainBall) + ' / ' +
                FTeeboxInfoList[nIndex].UseStatus;
      end;
      Global.Log.LogReserveWrite(sStr);

      if Global.ADConfig.ProtocolType = 'NANO' then
      begin
        SetTeeboxCtrlAD(nIndex, 'S0' , FTeeboxInfoList[nIndex].RemainMinute, FTeeboxInfoList[nIndex].RemainBall);

        if Global.ADConfig.StoreCode <> 'BD001' then //	BD001	그랜드골프클럽
          SetTeeboxCtrlAD(nIndex, 'S1' , FTeeboxInfoList[nIndex].RemainMinute, FTeeboxInfoList[nIndex].RemainBall);
      end
      else
        SetTeeboxCtrlAD(nIndex, 'S1' , FTeeboxInfoList[nIndex].RemainMinute, FTeeboxInfoList[nIndex].RemainBall);
    end;

    FTeeboxInfoList[nIndex].UseStatus := FTeeboxInfoList[nIndex].UseStatusPre;
  end;

  if (Global.Store.UseRewardYn = 'Y') or // 'AD_JEU435' 'SM'
     ((Global.Store.UseRewardYn = 'N') and (Global.Store.UseRewardException = 'Y')) then
  begin
    ResetTeeboxRemainMinAdd(0, FTeeboxInfoList[0].DelayMin, 'ALL'); //상태:1,4 모두 시간추가
  end;

  FBallBackUse := False;

  Result := True;
end;

function TTeebox.GetTeeboxInfo(ATeeboxNo: Integer): TTeeboxInfo;
begin
  Result := FTeeboxInfoList[ATeeboxNo];
end;

function TTeebox.GetNmToTeeboxInfo(ATeeboxNm: String): TTeeboxInfo;
var
  i: Integer;
begin
  for i := 1 to FTeeboxLastNo do
  begin
    if FTeeboxInfoList[i].TeeboxNm = ATeeboxNm then
    begin
      Result := FTeeboxInfoList[i];
      Break;
    end;
  end;
end;

procedure TTeebox.SetTeeboxDelay(ATeeboxNo: Integer; AType: Integer);
var
  nTemp: Integer;
  sStr: String;
begin
  if AType = 0 then //지연시작
  begin
    FTeeboxInfoList[ATeeboxNo].PauseTime := Now;
  end
  else if AType = 1 then //지연종료
  begin
    FTeeboxInfoList[ATeeboxNo].RePlayTime := Now;

    //2020-06-29 딜레이체크
    if formatdatetime('YYYYMMDD', FTeeboxInfoList[ATeeboxNo].PauseTime) <> formatdatetime('YYYYMMDD',now) then
    begin
      FTeeboxInfoList[ATeeboxNo].DelayMin := 0;
    end
    else
    begin
      //1분 추가 적용-20200507
      nTemp := Trunc((FTeeboxInfoList[ATeeboxNo].RePlayTime - FTeeboxInfoList[ATeeboxNo].PauseTime) *24 * 60 * 60); //초로 변환
      if (nTemp mod 60) > 0 then
        FTeeboxInfoList[ATeeboxNo].DelayMin := (nTemp div 60) + 1
      else
        FTeeboxInfoList[ATeeboxNo].DelayMin := (nTemp div 60);
    end;

    sStr := 'PauseTime: ' + formatdatetime('YYYY-MM-DD hh:nn:ss', FTeeboxInfoList[ATeeboxNo].PauseTime) +
            ' / RePlayTime: ' + formatdatetime('YYYY-MM-DD hh:nn:ss', FTeeboxInfoList[ATeeboxNo].RePlayTime) + ' / ' +
            IntToStr(FTeeboxInfoList[ATeeboxNo].DelayMin);
    Global.Log.LogReserveWrite(sStr);
  end
  else if AType = 2 then //지연중
  begin
    nTemp := Trunc((Now - FTeeboxInfoList[ATeeboxNo].PauseTime) *24 * 60 * 60); //초로 변환
    if (nTemp mod 60) > 0 then
      FTeeboxInfoList[ATeeboxNo].DelayMin := FTeeboxInfoList[ATeeboxNo].DelayMin + (nTemp div 60) + 1
    else
      FTeeboxInfoList[ATeeboxNo].DelayMin := FTeeboxInfoList[ATeeboxNo].DelayMin + (nTemp div 60);
  end;

end;

function TTeebox.SetTeeboxReserveInfo(ASeatReserveInfo: TSeatUseReserve): String;
var
  nSeatNo: Integer;
  sStr: String;
begin

  nSeatNo := ASeatReserveInfo.SeatNo;

  if nSeatNo > FTeeboxLastNo then
  begin
    sStr := 'SeatNo error : ' + IntToStr(nSeatNo);
    Global.Log.LogReserveWrite(sStr);
    Exit;
  end;

  if FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo = ASeatReserveInfo.ReserveNo then
  begin
    sStr := '동일예약건 : ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
          FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
          FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
          ASeatReserveInfo.ReserveNo;
    Global.Log.LogReserveWrite(sStr);
    Exit;
  end;

  //현재 배정중이면
  if (FTeeboxInfoList[nSeatNo].UseStatus = '1') and
     (FTeeboxInfoList[nSeatNo].RemainMinute > 0) then
  begin
    //if ASeatReserveInfo.ReserveDate > FormatDateTime('YYYYMMDDhhnnss', Now) then
    begin
      global.ReserveList.SetTeeboxReserveNext(ASeatReserveInfo);
      sStr := '신규배정대기 : ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
            FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
            FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
            FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate + ' / ' +
            FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveEndDate + ' -> ' +
            ASeatReserveInfo.ReserveNo;
      Global.Log.LogReserveWrite(sStr);
      Exit;
    end;
  end;

  FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo := ASeatReserveInfo.ReserveNo;
  FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin := ASeatReserveInfo.UseMinute;
  FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls := ASeatReserveInfo.UseBalls;
  if Global.ADConfig.ProtocolType = 'JEHU435' then
  begin
    if FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls > 999 then
      FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls := 999;
  end
  else
  begin
    if FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls > 9999 then
      FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls := 9999;
  end;

  FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin := ASeatReserveInfo.DelayMinute;
  if FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin < 0 then
    FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin := 0;

  FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveDate := ASeatReserveInfo.ReserveDate;
  FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate := '';
  FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate := '';
  FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn := 'N';
  FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignYn:= ASeatReserveInfo.AssignYn;

  if ASeatReserveInfo.ReserveDate <= formatdatetime('YYYYMMDDhhnnss', Now) then
  begin
    //if (Global.ADConfig.ProtocolType = 'JEHU435') then
    if (Global.ADConfig.StoreCode = 'A1001') then
    begin
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime := Now;
    end
    else
    begin
      //FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate := formatdatetime('YYYYMMDDhhnn00', Now); //2021-06-11 초00 표시-이선우이사님
      //FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime := Now + (((1/24)/60) * FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin);
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime := DateStrToDateTime3(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate) +
                                                               (((1/24)/60) * FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin);
    end;
  end
  else
  begin
    //if (Global.ADConfig.ProtocolType = 'JEHU435') then
    if (Global.ADConfig.StoreCode = 'A1001') then
    begin
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate := ASeatReserveInfo.ReserveDate;
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime := DateStrToDateTime3(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate);
    end
    else
    begin
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate := ASeatReserveInfo.ReserveDate;
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime := DateStrToDateTime3(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate) +
                                                           (((1/24)/60) * FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin);
    end;
  end;
  {
  Global.SetADConfigBallPrepare(nSeatNo,
                                FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo,
                                FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate);
  }
  FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveEndDate := '';
  FTeeboxInfoList[nSeatNo].TeeboxReserve.ChangeMin := 0;
  FTeeboxInfoList[nSeatNo].DelayMin := 0;
  FTeeboxInfoList[nSeatNo].UseCancel := 'N';
  FTeeboxInfoList[nSeatNo].UseClose := 'N';
  FTeeboxInfoList[nSeatNo].PrepareChk := 0;

  if Global.ADConfig.StoreCode = 'A5001' then //송도-제우테크 예약대기중 확인용
    FTeeboxInfoList[nSeatNo].UseLStatus := '1';
end;

function TTeebox.SetTeeboxReserveChange(ASeatUseInfo: TSeatUseInfo): Boolean;
var
  nSeatNo, nCtlMin: Integer;
  sStr: String;

  //2020-08-27 v26 이용타석 시간추가시 예약타석 시간증가
  nDelayMin: Integer;
begin
  Result:= False;

  nSeatNo := ASeatUseInfo.SeatNo;
  if FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo <> ASeatUseInfo.ReserveNo then
  begin
    Global.ReserveList.SetTeeboxReserveNextChange(nSeatNo, ASeatUseInfo);
    Exit;
  end;

  //대기시간/배정시간 변경 체크
  if (FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin = ASeatUseInfo.PrepareMin) and
     (FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin = ASeatUseInfo.AssignMin) then
  begin
    //변경된 내용 없음
    Exit;
  end;

  if FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn = 'N' then
  begin
    sStr := '예약배정시간변경 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
            FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
            FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
            '대기시간' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin) + ' -> ' +
            IntToStr(ASeatUseInfo.PrepareMin) + ' / ' +
            '배정시간' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin) + ' -> ' +
            IntToStr(ASeatUseInfo.AssignMin);

    //2020-05-29 예약대기상태
    if FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin <> ASeatUseInfo.AssignMin then
    begin
      FTeeboxInfoList[nSeatNo].TeeboxReserve.ChangeMin := ASeatUseInfo.AssignMin;
      if (Global.ADConfig.ProtocolType = 'JMS') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
      begin
        //2020-08-27 v26 시간추가시 예약타석시간추가
        nDelayMin := 0;
        if FTeeboxInfoList[nSeatNo].RemainMinute < ASeatUseInfo.AssignMin then
        begin
          nDelayMin := ASeatUseInfo.AssignMin - FTeeboxInfoList[nSeatNo].RemainMinute;
        end;

        FTeeboxInfoList[nSeatNo].RemainMinute := ASeatUseInfo.AssignMin;
      end;
    end;

    if FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin <> ASeatUseInfo.PrepareMin then
    begin
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime := DateStrToDateTime3(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate) +
                                                          (((1/24)/60) * ASeatUseInfo.PrepareMin);
      FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin := ASeatUseInfo.PrepareMin;
    end;
  end
  else
  begin
    //배정된후 배정시간 변경만 체크
    if FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin <> ASeatUseInfo.AssignMin then
    begin
      if ASeatUseInfo.AssignMin < 2 then
        ASeatUseInfo.AssignMin := 2; // 0 으로 변경시 대기시간 상태 적용됨

      if Global.ADConfig.ProtocolType = 'JEHU435' then
      begin
        if (Global.ADConfig.StoreCode = 'A1001') or (Global.ADConfig.StoreCode = 'A9001') then //스타,루이힐스
        begin

          FTeeboxInfoList[nSeatNo].UseReset := 'Y';
          //SetTeeboxCtrl(nSeatNo, 'S1' , 0, 0000);
          SetTeeboxCtrlAD(nSeatNo, 'S1' , 0, 0000);
          sStr := '배정시간변경 : 초기화';
          Global.Log.LogReserveWrite(sStr);
        end;
      end;

      //배정시간변경 위해 제어배열에 등록
      nCtlMin := ASeatUseInfo.RemainMin + (ASeatUseInfo.AssignMin - FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin);

      if (Global.ADConfig.ProtocolType = 'JMS') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
      begin
        //2020-08-27 v26 시간추가시 예약타석시간추가
        nDelayMin := 0;
        if ASeatUseInfo.RemainMin < ASeatUseInfo.AssignMin then
        begin
          nDelayMin := ASeatUseInfo.AssignMin - ASeatUseInfo.RemainMin;
        end;

        FTeeboxInfoList[nSeatNo].RemainMinute := nCtlMin;
      end
      else if (Global.ADConfig.ProtocolType = 'NANO') or (Global.ADConfig.ProtocolType = 'NANO2') then
        SetTeeboxCtrlAD(nSeatNo, 'S2' , nCtlMin, FTeeboxInfoList[nSeatNo].RemainBall)
      else
        SetTeeboxCtrlAD(nSeatNo, 'S1' , nCtlMin, FTeeboxInfoList[nSeatNo].RemainBall);

      FTeeboxInfoList[nSeatNo].TeeboxReserve.ChangeMin := nCtlMin;

      sStr := '배정시간변경 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
              '배정시간' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin) + ' -> ' +
              IntToStr(ASeatUseInfo.AssignMin) + ' / ' +
              IntToStr(FTeeboxInfoList[nSeatNo].RemainMinute) + ' -> ' +
              IntToStr(nCtlMin);
    end;

  end;

  Global.Log.LogReserveWrite(sStr);
  FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin := ASeatUseInfo.AssignMin;

  if (Global.ADConfig.ProtocolType = 'JMS') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
    Global.ReserveList.ResetTeeboxReserveMinAddJMS(nSeatNo, nDelayMin);

  Result:= True;
end;

function TTeebox.SetTeeboxReserveCancle(ATeeboxNo: Integer; AReserveNo: String): Boolean;
var
  sStr: String;
begin
  Result := False;

  if FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo <> AReserveNo then
  begin
    //예약대기, 배정된 타석이 아님
    Global.ReserveList.SetTeeboxReserveNextCancel(ATeeboxNo, AReserveNo);
    Exit;
  end;

  //취소위해 제어배열에 등록
  FTeeboxInfoList[ATeeboxNo].UseCancel := 'Y';

  if (Global.ADConfig.ProtocolType = 'JMS') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
    FTeeboxInfoList[ATeeboxNo].RemainMinute := 0
  //2020-12-17 빅토리아 추가
  else if FTeeboxInfoList[ATeeboxNo].ControlYn = 'N' then
    FTeeboxInfoList[ATeeboxNo].RemainMinute := 0
  else
    //SetTeeboxCtrl(ATeeboxNo, 'S1', 0, 9999);
    SetTeeboxCtrlAD(ATeeboxNo, 'S1', 0, 9999);

  sStr := 'Cancel no: ' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxNo) + ' / ' +
          FTeeboxInfoList[ATeeboxNo].TeeboxNm + ' / ' +
          FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo;
  Global.Log.LogReserveWrite(sStr);

  Result := True;
end;

function TTeebox.SetTeeboxReserveClose(ATeeboxNo: Integer; AReserveNo: String): Boolean;
var
  sStr: String;
begin
  Result := False;

  if FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo <> AReserveNo then
  begin
    Exit;
  end;

  FTeeboxInfoList[ATeeboxNo].UseClose := 'Y';

  if (Global.ADConfig.ProtocolType = 'JMS') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
    FTeeboxInfoList[ATeeboxNo].RemainMinute := 0
  //2020-12-17 빅토리아 추가
  else if FTeeboxInfoList[ATeeboxNo].ControlYn = 'N' then
    FTeeboxInfoList[ATeeboxNo].RemainMinute := 0
  else
    //SetTeeboxCtrl(ATeeboxNo, 'S1', 0, 9999);
    SetTeeboxCtrlAD(ATeeboxNo, 'S1', 0, 9999);

  sStr := 'Close no: ' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxNo) + ' / ' +
          FTeeboxInfoList[ATeeboxNo].TeeboxNm + ' / ' +
          FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo;
  Global.Log.LogReserveWrite(sStr);
  Result := True;
end;

//chy 2020-10-27 즉시배정
function TTeebox.SetTeeboxReserveStartNow(ATeeboxNo: Integer; AReserveNo: String): String;
var
  sStr, sResult: String;
begin
  Result := '';

  if FTeeboxInfoList[ATeeboxNo].UseStatus <> '0' then
  begin
    Result := '사용중인 타석입니다. 상태: ' + FTeeboxInfoList[ATeeboxNo].UseStatus;
    Exit;
  end;

  if FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo = AReserveNo then
  begin
    FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveDate := formatdatetime('YYYYMMDDHHNNSS', now);

    //if Global.ADConfig.ReserveMode = True then
    if (Global.ADConfig.ProtocolType = 'NANO') and (Global.ADConfig.StoreCode = 'B8001') then //'B8001' 제이제이골프클럽
      FTeeboxInfoList[ATeeboxNo].TeeboxReserve.PrepareEndTime := IncMinute(Now, FTeeboxInfoList[ATeeboxNo].TeeboxReserve.PrepareMin)
    else
      FTeeboxInfoList[ATeeboxNo].TeeboxReserve.PrepareEndTime := Now;

    sStr := 'Start Now 대기 no: ' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxNo) + ' / ' +
            FTeeboxInfoList[ATeeboxNo].TeeboxNm + ' / ' +
            FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo;
    Global.Log.LogReserveWrite(sStr);
  end
  else
  begin
    sResult := Global.ReserveList.SetTeeboxReserveNextStartNow(ATeeboxNo, AReserveNo);
    if sResult <> 'Success' then
    begin
      Result := sResult;
      Exit;
    end;

  end;

  Result := 'Success';
end;
{
procedure TTeebox.SetTeeboxReserveNo(ATeeboxNo: Integer; AReserveNo: String);
begin
  FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo := AReserveNo;
end;
}
function TTeebox.GetDevicToTeeboxNo(ADev: String): Integer;
var
  i: Integer;
  sDeviceIdR, sDeviceIdL: String;
begin
  Result := 0;
  for i := 1 to FTeeboxLastNo do
  begin
    if (FTeeboxInfoList[i].TeeboxZoneCode = 'L') and (Global.ADConfig.StoreCode <> 'AB001') then //좌우겸용
    begin
      if (Global.ADConfig.ProtocolType = 'JEHU435') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
      begin
        sDeviceIdR := Copy(FTeeboxInfoList[i].DeviceId, 1, 2);
        sDeviceIdL := Copy(FTeeboxInfoList[i].DeviceId, 3, 2);
      end
      else
      begin
        sDeviceIdR := Copy(FTeeboxInfoList[i].DeviceId, 1, 3);
        sDeviceIdL := Copy(FTeeboxInfoList[i].DeviceId, 4, 3);
      end;

      if (sDeviceIdR = ADev) or (sDeviceIdL = ADev) then
      begin
        Result := i;
        Break;
      end;
    end
    else
    begin
      if FTeeboxInfoList[i].DeviceId = ADev then
      begin
        Result := i;
        Break;
      end;
    end;
  end;

end;

function TTeebox.GetDevicToFloorTeeboxNo(AFloor, ADev: String): Integer;
var
  i: Integer;
  sDeviceIdR, sDeviceIdL: String;
begin
  Result := 0;
  for i := 1 to FTeeboxLastNo do
  begin
    //송도: 'A5001' jeu60A, 1 port 사용
    if AFloor <> '0' then // 0: 단일포트
    begin
      if FTeeboxInfoList[i].FloorZoneCode <> AFloor then
        Continue;
    end;

    if FTeeboxInfoList[i].DelYn = 'Y' then
      Continue;

    {
    if (FTeeboxInfoList[i].TeeboxZoneCode = 'L') and //좌우겸용
       (Global.ADConfig.StoreCode <> 'AB001') and   //대성
       (Global.ADConfig.StoreCode <> 'B7001') then //프라자
    begin
      sDeviceIdR := Copy(FTeeboxInfoList[i].DeviceId, 1, 2);
      sDeviceIdL := Copy(FTeeboxInfoList[i].DeviceId, 3, 2);

      if (sDeviceIdR = ADev) or (sDeviceIdL = ADev) then
      begin
        Result := i;
        Break;
      end;
    end
    else   }
    begin
      if FTeeboxInfoList[i].DeviceId = ADev then
      begin
        Result := i;
        Break;
      end;
    end;
  end;

end;
{
function TTeebox.GetDevicToFloorTeeboxNoModen(AFloor, ADev: String): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to FTeeboxLastNo do
  begin
    if FTeeboxInfoList[i].FloorZoneCode <> AFloor then
      Continue;

    if FTeeboxInfoList[i].DeviceId = ADev then
    begin
      Result := i;
      Break;
    end;
  end;

end;
}
function TTeebox.GetDevicToTeeboxNm(ADev: String): String;
var
  i: Integer;
  sDeviceIdR, sDeviceIdL: String;
begin
  Result := '';
  for i := 1 to FTeeboxLastNo do
  begin
    if (FTeeboxInfoList[i].TeeboxZoneCode = 'L') and (Global.ADConfig.StoreCode <> 'AB001') then //좌우겸용
    begin
      sDeviceIdR := Copy(FTeeboxInfoList[i].DeviceId, 1, 3);
      sDeviceIdL := Copy(FTeeboxInfoList[i].DeviceId, 4, 3);

      if (sDeviceIdR = ADev) or (sDeviceIdL = ADev) then
      begin
        Result := FTeeboxInfoList[i].TeeboxNm;
        Break;
      end;
    end
    else
    begin
      if FTeeboxInfoList[i].DeviceId = ADev then
      begin
        Result := FTeeboxInfoList[i].TeeboxNm;
        Break;
      end;
    end;
  end;

end;

function TTeebox.GetTeeboxNoToDevic(ATeeboxNo: Integer): String;
begin
  Result := FTeeboxInfoList[ATeeboxNo].DeviceId;
end;

function TTeebox.GetTeeboxDevicdNoToDevic(AIndex: Integer): String;
begin
  Result := FTeeboxDevicNoList[AIndex];
end;

function TTeebox.GetTeeboxInfoA(AChannelCd: String): TTeeboxInfo;
var
  nIndex: Integer;
  sDeviceIdR, sDeviceIdL: String;
begin
  for nIndex := 1 to FTeeboxLastNo do
  begin
    if (FTeeboxInfoList[nIndex].TeeboxZoneCode = 'L') and (Global.ADConfig.StoreCode <> 'AB001') then //좌우겸용
    begin

      if Global.ADConfig.ProtocolType = 'MODENYJ' then
      begin
        sDeviceIdR := Copy(FTeeboxInfoList[nIndex].DeviceId, 1, 2);
        sDeviceIdL := Copy(FTeeboxInfoList[nIndex].DeviceId, 3, 2);
      end
      else
      begin
        sDeviceIdR := Copy(FTeeboxInfoList[nIndex].DeviceId, 1, 3);
        sDeviceIdL := Copy(FTeeboxInfoList[nIndex].DeviceId, 4, 3);
      end;

      if (sDeviceIdR = AChannelCd) or (sDeviceIdL = AChannelCd) then
      begin
        Result := FTeeboxInfoList[nIndex];
        Break;
      end;
    end
    else
    begin
      if FTeeboxInfoList[nIndex].DeviceId = AChannelCd then
      begin
        Result := FTeeboxInfoList[nIndex];
        Break;
      end;
    end;
  end;
end;

function TTeebox.GetDeviceToFloorTeeboxInfo(AFloor, AChannelCd: String): TTeeboxInfo;
var
  nIndex: Integer;
  sDeviceIdR, sDeviceIdL: String;
begin
  for nIndex := 1 to FTeeboxLastNo do
  begin

    if AFloor <> '0' then // 0: 단일포트
    begin
      if FTeeboxInfoList[nIndex].FloorZoneCode <> AFloor then
        Continue;
    end;

    if (FTeeboxInfoList[nIndex].TeeboxZoneCode = 'L') and (Global.ADConfig.StoreCode <> 'AB001')
    and (Global.ADConfig.StoreCode <> 'B7001') then //좌우겸용
    begin

      if Global.ADConfig.ProtocolType = 'MODENYJ' then
      begin
        sDeviceIdR := Copy(FTeeboxInfoList[nIndex].DeviceId, 1, 2);
        sDeviceIdL := Copy(FTeeboxInfoList[nIndex].DeviceId, 3, 2);
      end
      else
      begin
        sDeviceIdR := Copy(FTeeboxInfoList[nIndex].DeviceId, 1, 3);
        sDeviceIdL := Copy(FTeeboxInfoList[nIndex].DeviceId, 4, 3);
      end;

      if (sDeviceIdR = AChannelCd) or (sDeviceIdL = AChannelCd) then
      begin
        Result := FTeeboxInfoList[nIndex];
        Break;
      end;
    end
    else
    begin
      if FTeeboxInfoList[nIndex].DeviceId = AChannelCd then
      begin
        Result := FTeeboxInfoList[nIndex];
        Break;
      end;
    end;
  end;
end;

function TTeebox.GetTeeboxInfoUseYn(ATeeboxNo: Integer): String;
begin
  Result := FTeeboxInfoList[ATeeboxNo].UseYn;
end;

function TTeebox.GetTeeboxFloorNm(ATeeboxNo: Integer): String;
begin
  Result := FTeeboxInfoList[ATeeboxNo].FloorNm;
end;
function TTeebox.GetTeeboxErrorCode(ATeeboxNo: Integer): String;
begin
  Result := FTeeboxInfoList[ATeeboxNo].ErrorCd2;
end;

function TTeebox.GetTeeboxStatusList: AnsiString;
var
  nIndex: Integer;
  sJsonStr: AnsiString;
  jObj, jItemObj: TJSONObject; //Erp 전송전문
  jObjArr: TJSONArray;
begin
  try
    jObjArr := TJSONArray.Create;
    jObj := TJSONObject.Create;
    jObj.AddPair(TJSONPair.Create('store_cd', Global.ADConfig.StoreCode));
    jObj.AddPair(TJSONPair.Create('user_id', Global.ADConfig.UserId));
    jObj.AddPair(TJSONPair.Create('data', jObjArr));

    for nIndex := 1 to TeeboxLastNo do
    begin
      jItemObj := TJSONObject.Create;
      jItemObj.AddPair( TJSONPair.Create( 'teebox_no', IntToStr(FTeeboxInfoList[nIndex].TeeboxNo) ) );
      jItemObj.AddPair( TJSONPair.Create( 'use_status', FTeeboxInfoList[nIndex].UseStatus ) );
      jObjArr.Add(jItemObj);
    end;

    sJsonStr := jObj.ToString;
  finally
    jObj.Free;
  end;

  Result := sJsonStr;
end;

function TTeebox.GetTeeboxStatus(ATeebox: String): AnsiString;
var
  nIndex: Integer;
  sJsonStr: AnsiString;
  jObj, jItemObj: TJSONObject; //Erp 전송전문
  jObjArr: TJSONArray;
begin
  try
    jObjArr := TJSONArray.Create;
    jObj := TJSONObject.Create;
    jObj.AddPair(TJSONPair.Create('store_cd', Global.ADConfig.StoreCode));
    jObj.AddPair(TJSONPair.Create('user_id', Global.ADConfig.UserId));
    jObj.AddPair(TJSONPair.Create('data', jObjArr));

    nIndex := StrToInt(ATeebox);
    jItemObj := TJSONObject.Create;
    jItemObj.AddPair( TJSONPair.Create( 'teebox_no', IntToStr(FTeeboxInfoList[nIndex].TeeboxNo) ) );
    jItemObj.AddPair( TJSONPair.Create( 'use_status', FTeeboxInfoList[nIndex].UseStatus ) );
    jObjArr.Add(jItemObj);

    sJsonStr := jObj.ToString;
  finally
    jObj.Free;
  end;

  Result := sJsonStr;
end;

function TTeebox.GetTeeboxStatusError(ATeebox, ATeebox1: String): AnsiString;
var
  nIndex: Integer;
  sJsonStr: AnsiString;
  jObj, jItemObj: TJSONObject; //Erp 전송전문
  jObjArr: TJSONArray;

  slErrorS, slErrorE: TStringList;
  I: Integer;
  sErrorCode: string;
begin
  try
    slErrorS := TStringList.Create;
    slErrorE := TStringList.Create;

    jObjArr := TJSONArray.Create;
    jObj := TJSONObject.Create;
    jObj.AddPair(TJSONPair.Create('store_cd', Global.ADConfig.StoreCode));
    jObj.AddPair(TJSONPair.Create('user_id', Global.ADConfig.UserId));
    jObj.AddPair(TJSONPair.Create('data', jObjArr));

    if ATeebox <> EmptyStr then
    begin
      ExtractStrings(['/'], [], PChar(ATeebox), slErrorS);
      for I := 0 to slErrorS.Count - 1 do
      begin
        jItemObj := TJSONObject.Create;
        jItemObj.AddPair( TJSONPair.Create( 'teebox_no', slErrorS[I] ) );
        jItemObj.AddPair( TJSONPair.Create( 'use_status', '9' ) );

        sErrorCode := GetTeeboxErrorCode(StrToInt(slErrorS[I]));
        jItemObj.AddPair( TJSONPair.Create( 'error_code', sErrorCode ) );

        jObjArr.Add(jItemObj);
      end;
    end;

    if ATeebox1 <> EmptyStr then
    begin
      ExtractStrings(['/'], [], PChar(ATeebox1), slErrorE);
      for I := 0 to slErrorE.Count - 1 do
      begin
        nIndex := StrToInt(slErrorE[I]);
        jItemObj := TJSONObject.Create;
        jItemObj.AddPair( TJSONPair.Create( 'teebox_no', IntToStr(FTeeboxInfoList[nIndex].TeeboxNo) ) );
        jItemObj.AddPair( TJSONPair.Create( 'use_status', FTeeboxInfoList[nIndex].UseStatus ) );
        jItemObj.AddPair( TJSONPair.Create( 'error_code', '' ) );
        jObjArr.Add(jItemObj);
      end;
    end;

    sJsonStr := jObj.ToString;
  finally
    jObj.Free;
    slErrorS.Free;
    slErrorE.Free;
  end;

  Result := sJsonStr;
end;

procedure TTeebox.SetStoreClose;
var
  nIndex: Integer;
  sSendData, sBcc: AnsiString;
  sStr: String;
begin
  for nIndex := 1 to TeeboxLastNo do
  begin
    if FTeeboxInfoList[nIndex].UseYn = 'N' then
      Continue;

    if FTeeboxInfoList[nIndex].RemainMinute <= 0 then
      Continue;

    //시간초기화 제어배열 등록
    FTeeboxInfoList[nIndex].UseClose := 'Y';

    //2020-08-26 v26 JMS 영업종료시 타석정리 추가
    if (Global.ADConfig.ProtocolType = 'JMS') or (Global.ADConfig.ProtocolType = 'MODENYJ') then
      FTeeboxInfoList[nIndex].RemainMinute := 0
    else
      //SetTeeboxCtrl(nIndex, 'S1' , 0, 9999);
      SetTeeboxCtrlAD(nIndex, 'S1' , 0, 9999);

    sStr := 'Close : ' + IntToStr(FTeeboxInfoList[nIndex].TeeboxNo) + ' / ' +
            FTeeboxInfoList[nIndex].TeeboxNm + ' / ' +
            IntToStr(FTeeboxInfoList[nIndex].RemainMinute) + ' / ' +
            FTeeboxInfoList[nIndex].TeeboxReserve.ReserveNo;
    Global.Log.LogReserveWrite(sStr);
  end;
end;

//2021-06-02 조광, MODENYJ / 타석점검제어
procedure TTeebox.SetTeeboxCtrlRemainMin(ATeeboxNo: Integer; ATime: Integer);
begin
  FTeeboxInfoList[ATeeboxNo].RemainMinute := ATime;
  FTeeboxInfoList[ATeeboxNo].CheckCtrl := True;
end;

//2021-06-02 조광, MODENYJ / 타석점검제어
procedure TTeebox.SetTeeboxCtrlRemainMinFree(ATeeboxNo: Integer);
begin
  if FTeeboxInfoList[ATeeboxNo].CheckCtrl = False then
    Exit;

  FTeeboxInfoList[ATeeboxNo].RemainMinute := 0;
  FTeeboxInfoList[ATeeboxNo].CheckCtrl := False;
end;

procedure TTeebox.SetTeeboxErrorCntModen(AIndex: Integer; ATeeboxNo: Integer; AError: String);
var
  sLogMsg: String;
begin
  if FTeeboxInfoList[ATeeboxNo].UseStatus = '8' then
  begin
    sLogMsg := 'UseStatus = 8 : ' + IntToStr(ATeeboxNo) + ' / ' + FTeeboxInfoList[ATeeboxNo].TeeboxNm;
    Global.Log.LogReadMulti(AIndex, sLogMsg);
    Exit;
  end;

  if AError = 'Y' then
  begin
    FTeeboxInfoList[ATeeboxNo].ErrorCnt := FTeeboxInfoList[ATeeboxNo].ErrorCnt + 1;
    if FTeeboxInfoList[ATeeboxNo].ErrorCnt > 2 then
    begin
      if FTeeboxInfoList[ATeeboxNo].ErrorYn = 'N' then
      begin
        sLogMsg := 'ErrorCnt 3 / ' + IntToStr(ATeeboxNo) + ' / ' + FTeeboxInfoList[ATeeboxNo].TeeboxNm;
        Global.Log.LogReadMulti(AIndex, sLogMsg);
      end;

      FTeeboxInfoList[ATeeboxNo].ErrorYn := 'Y';
      FTeeboxInfoList[ATeeboxNo].UseStatus := '9';
      FTeeboxInfoList[ATeeboxNo].ErrorCd := 8; //통신이상
      FTeeboxInfoList[ATeeboxNo].ErrorCd2 := '8';
    end;
  end
  else
  begin
    FTeeboxInfoList[ATeeboxNo].ErrorCnt := 0;
    FTeeboxInfoList[ATeeboxNo].ErrorYn := 'N';
  end;
end;

function TTeebox.ResetTeeboxRemainMinAdd(ATeeboxNo, ADelayTm: Integer; ATeeboxNm: String): Boolean;
var
  sResult: String;
  sDate, sStr: String;
  sDateTime: String; //볼회수시작시간
begin

  //2020-06-29 딜레이체크
  if ADelayTm = 0 then
    Exit;

  if (Global.Store.UseRewardYn = 'N') and (Global.Store.UseRewardException = 'Y') then
  begin
    if ADelayTm > 60 then
    begin
      sStr := 'ADelayTm > 60 : ' + IntToStr(ATeeboxNo) + ' / ' + ATeeboxNm + ' / ' + IntToStr(ADelayTm);
      Global.Log.LogReserveWrite('ResetTeeboxReserveDateAdd : ' + sStr);
      Exit;
    end;
  end
  else
  begin
    if ADelayTm > 10 then
    begin
      sStr := 'ADelayTm > 10 : ' + IntToStr(ATeeboxNo) + ' / ' + ATeeboxNm + ' / ' + IntToStr(ADelayTm);
      Global.Log.LogReserveWrite('ResetTeeboxReserveDateAdd : ' + sStr);
      Exit;
    end;
  end;

  sDate := formatdatetime('YYYYMMDD', Now);

  // MODENYJ 처럼 AD 자체 시간 계산일 경우  배정시간추가 내용 DB도 저장, 사용중use_status = 1
  sResult := Global.XGolfDM.SetSeatReserveUseMinAdd(Global.ADConfig.StoreCode, IntToStr(ATeeboxNo), sDate, IntToStr(ADelayTm));
  sStr := sResult + ' : ' + IntToStr(ATeeboxNo) + ' / ' + ATeeboxNm + ' / ' + sDate + ' / ' + IntToStr(ADelayTm);
  Global.Log.LogReserveWrite('ResetTeeboxUseMinAdd : ' + sStr);

  //2021-06-24 한강, 볼회수중에 배정요청한 경우 DB 예약시간 미변경 조치, 예약건 use_status = 4
  sDateTime := formatdatetime('YYYYMMDDHHNNSS', FTeeboxInfoList[0].PauseTime);
  sResult := Global.XGolfDM.SetSeatReserveTmChange(Global.ADConfig.StoreCode, IntToStr(ATeeboxNo), sDate, IntToStr(ADelayTm), sDateTime);
  sStr := sResult + ' : ' + IntToStr(ATeeboxNo) + ' / ' + ATeeboxNm + ' / ' + sDate + ' / ' + IntToStr(ADelayTm) + ' / ' + sDateTime;

  Global.Log.LogReserveWrite('ResetTeeboxReserveDateAdd : ' + sStr);
end;

function TTeebox.ResetTeeboxRemainMinAddJMS(ATeeboxNo, ADelayTm: Integer): Boolean;
var
  sResult: String;
  sDate, sStr: String;
  I: integer;
  tmReserve: TDateTime;
begin
  if ADelayTm = 0 then
    Exit;
  { 보류
  if ADelayTm > 30 then
  begin
    ADelayTm := 30;
    Global.Log.LogReserveWrite('AssignMin Add : 30 OVer');
  end;
  }
  FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin := FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin + ADelayTm;
  sStr := IntToStr(ATeeboxNo) + ' / ' + FTeeboxInfoList[ATeeboxNo].TeeboxNm + ' / ' +
          IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin) + ' / ' + IntToStr(ADelayTm);
  Global.Log.LogReserveWrite('AssignMin Add : ' + sStr);

  Global.ReserveList.ResetTeeboxReserveMinAddJMS(ATeeboxNo, ADelayTm);
end;

procedure TTeebox.TeeboxReserveNextChk;
var
  nIndex, nTeeboxNo, nIdx: Integer;
  sLog, sCancel: String;
  I: Integer;
  SeatUseReserve: TSeatUseReserve;
begin

  try

    for nTeeboxNo := 1 to TeeboxLastNo do
    begin

      //2020-12-17 반자동
      if FTeeboxInfoList[nTeeboxNo].ControlYn <> 'N' then
      begin
        if FTeeboxInfoList[nTeeboxNo].ComReceive <> 'Y' then
          Continue;
      end;

      if (FTeeboxInfoList[nTeeboxNo].RemainMinPre > 0) or (FTeeboxInfoList[nTeeboxNo].UseStatus <> '0') then
        Continue;

      //타석기 배정상태 확인
      //if FSeatInfoList[nTeeboxNo].SeatReserve.ReserveNo = '' then
      //  Continue;

      if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate > formatdatetime('YYYYMMDDhhnnss', Now) then
        Continue;

      //2020-05-29 조건추가, 2021-07-21 조건수정
      if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate <> '') and (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate = '') then
        Continue;

      Global.ReserveList.ReserveListNextChk(nTeeboxNo);
    end;

  except
    on e: Exception do
    begin
       sLog := 'SeatReserveNextChk Exception : ' + e.Message;
       Global.Log.LogReserveWrite(sLog);
    end;
  end;

end;

function TTeebox.SetTeeboxHold(ATeeboxNo, AUserId: String; AUse: Boolean): Boolean;
var
  nTeeboxNo: Integer;
begin
  Result := False;

  if ATeeboxNo = '-1' then
    Exit;

  nTeeboxNo := StrToInt(ATeeboxNo);
  FTeeboxInfoList[nTeeboxNo].HoldUse := AUse;
  FTeeboxInfoList[nTeeboxNo].HoldUser := AUserId;

  Result := True;
end;

function TTeebox.GetTeeboxHold(ATeeboxNo, AUserId, AType: String): Boolean;
var
  nTeeboxNo: Integer;
begin
  nTeeboxNo := StrToInt(ATeeboxNo);

  //2020-05-27 적용: Insert
  if AType = 'Insert' then
  begin
    if FTeeboxInfoList[nTeeboxNo].HoldUser = AUserId then
      Result := False //홀드등록자가 동일하면
    else
      Result := FTeeboxInfoList[nTeeboxNo].HoldUse;
  end
  else if AType = 'Delete' then
  begin
    if FTeeboxInfoList[nTeeboxNo].HoldUser = AUserId then
      Result := True //홀드등록자가 동일하면
    else
      Result := False;
  end
  else
  begin
    Result := FTeeboxInfoList[nTeeboxNo].HoldUse;
  end;

end;

function TTeebox.GetTeeboxNowReserveLastTime(ATeeboxNo: String): String; //2021-04-19 현시간 예약시간 검증
var
  nIdx, nTeeboxNo: integer;
  ReserveTm: TDateTime;
  sStartDate, sStr, sLog: String;
  DelayMin, UseMin, nCnt: Integer;
begin
  sStr := '0';

  nTeeboxNo := StrToInt(ATeeboxNo);
  nCnt := Global.ReserveList.GetTeeboxReserveNextListCnt(nTeeboxNo);
  if nCnt = 0 then
  begin
    sStartDate := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate;
    //DelayMin := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin;
    UseMin := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareMin;

    ReserveTm := DateStrToDateTime3(sStartDate) + ( ((1/24)/60) * UseMin );

    //sStr := FormatDateTime('YYYYMMDDhhnnss', ReserveTm);
    sStr := FormatDateTime('YYYYMMDDhhnn00', ReserveTm); //2021-06-11
  end
  else
  begin
    sStr := Global.ReserveList.GetTeeboxReserveLastTime(ATeeboxNo);
    sLog := 'GetTeeboxReserveLastTime : ' + ATeeboxNo;
    Global.Log.LogErpApiWrite(sLog);
  end;

  Result := sStr;
end;

//타석기 구동확인용-> ERP 전송
procedure TTeebox.SendADStatusToErp;
var
  sJsonStr: AnsiString;
  sResult, sResultCd, sResultMsg, sLog: String;

  jObj, jObjSub: TJSONObject;
  sChgDate: String;
begin

  //if FNoErpMode = True then
    //Exit;

  try

    while True do
    begin
      if FTeeboxReserveUse = False then
        Break;

      sLog := 'SeatReserveUse SendADStatusToErp!';
      Global.Log.LogReserveDelayWrite(sLog);

      sleep(50);
    end;

    FTeeboxStatusUse := True;

    sJsonStr := '?store_cd=' + Global.ADConfig.StoreCode;

    //2021-06-10 응답대기로 배정지연발생->배정표미출력됨. Timeout 설정. 타석기AD상태용이라 우선 적용함.
    //sResult := Global.Api.SetErpApiNoneData(sJsonStr, 'K710_TeeboxTime', Global.ADConfig.ApiUrl, Global.ADConfig.ADToken);
    sResult := Global.Api.SetErpApiK710TeeboxTime(sJsonStr, 'K710_TeeboxTime', Global.ADConfig.ApiUrl, Global.ADConfig.ADToken);

    {
    if StrPos(PChar(sResult), PChar('Exception')) <> nil then
      Global.ErpApiLogWrite(sResult);
    }

    //'{"result_cd":"0000","result_msg":"처리가 되었습니다.","result_data":{"chg_date":"2021-02-01 17:52:53"},"result_date":null}'

    if (Copy(sResult, 1, 1) <> '{') or (Copy(sResult, Length(sResult), 1) <> '}') then
    begin
      sLog := 'SendADStatusToErp Fail : ' + sResult;
      Global.Log.LogWrite(sLog);
      Exit;
    end;

    jObj := TJSONObject.ParseJSONValue(sResult) as TJSONObject;
    sResultCd := jObj.GetValue('result_cd').Value;
    sResultMsg := jObj.GetValue('result_msg').Value;

    if sResultCd <> '0000' then
    begin
      sLog := 'K710_TeeboxTime : ' + sResultCd + ' / ' + sResultMsg;
      Global.Log.LogWrite(sLog);
    end
    else
    begin

      jObjSub := jObj.GetValue('result_data') as TJSONObject;
      sChgDate := jObjSub.GetValue('chg_date').Value;

      if sChgDate > Global.Store.StoreLastTM then
      begin
        sLog := 'K710_TeeboxTime : ' + sResult;
        Global.Log.LogWrite(sLog);

        Global.GetStoreInfoToApi;
      end;

    end;

    Sleep(50);
    FTeeboxStatusUse := False;
  finally
    FTeeboxStatusUse := False;
    FreeAndNil(jObj);
  end;
end;

function TTeebox.TeeboxClear: Boolean;
var
  nIdx: Integer;
begin
  SetLength(FTeeboxInfoList, 0);

  for nIdx := 0 to FSendApiErrorList.Count - 1 do
  begin
    FSendApiErrorList.Delete(0);
  end;
  FreeAndNil(FSendApiErrorList);
end;

function TTeebox.SetTeeboxReserveCheckIn(ATeeboxNo: Integer; AReserveNo: String): Boolean;
var
  sStr: String;
  tmTemp: TDateTime;
  nNN: integer;
  sJsonStr: AnsiString;
begin
  Result := False;

  if FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo <> AReserveNo then
  begin
    //예약대기, 배정된 타석이 아님
    Global.ReserveList.SetTeeboxReserveNextCheckIn(ATeeboxNo, AReserveNo);

    //체크인 DB 저장
    Global.XGolfDM.SeatUseCheckInNextUpdate(Global.ADConfig.StoreCode, AReserveNo);

    Exit;
  end;

  //체크인한 시점으로 대기시간, 배정시간 변경
  if FTeeboxInfoList[ATeeboxNo].TeeboxReserve.PrepareEndTime < Now then //대기시간을 초과했으면
  begin
    nNN := MinutesBetween(now, FTeeboxInfoList[ATeeboxNo].TeeboxReserve.PrepareEndTime);
    FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin := FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin - nNN;
  end;

  FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignYn := 'Y';

  //체크인 DB 저장
  Global.XGolfDM.SeatUseCheckInUpdate(Global.ADConfig.StoreCode, AReserveNo, FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin);

  //체크인으로 인한 배정시간 변경 erp 전송위해 재전송 항목으로 등록
  sJsonStr := '?store_cd=' + Global.ADConfig.StoreCode +
              '&teebox_no=' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxNo) +
              '&reserve_no=' + AReserveNo +
              '&assign_min=' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin) +
              '&prepare_min=' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxReserve.PrepareMin) +
              '&assign_balls=9999' +
              '&user_id=' + Global.ADConfig.UserId +
              '&memo=';
  SetSendApiErrorAdd(AReserveNo, 'K703_TeeboxChg', sJsonStr);

  sStr := 'checkIn no: ' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxNo) + ' / ' +
          FTeeboxInfoList[ATeeboxNo].TeeboxNm + ' / ' +
          FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
          FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
          intToStr(FTeeboxInfoList[ATeeboxNo].TeeboxReserve.PrepareMin) + ' / ' +
          IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxReserve.AssignMin);
  Global.Log.LogReserveWrite(sStr);

  Result := True;
end;


procedure TTeebox.TeeboxStatusChkAD;
var
  nTeeboxNo: Integer;
  sStr, sEndTy, sChange, sResult, sLog: String;
  I, nNN, nTmTemp, nTemp: Integer;
  tmTempS: TDateTime;

  //기기고장 발생여부
  bTeeboxError: Boolean;
  sErrorS, sErrorE: String;
begin

  while True do
  begin
    if FTeeboxReserveUse = False then
      Break;

    sLog := 'SeatReserveUse TeeboxStatusChkAD!';
    Global.Log.LogReserveDelayWrite(sLog);

    sleep(50);
  end;
  FTeeboxStatusUse := True;

  //기기고장 발생,해제시 상태 파트너센터 상태 업데이트
  bTeeboxError := False;
  sErrorS := EmptyStr;
  sErrorE := EmptyStr;

  for nTeeboxNo := 1 to FTeeboxLastNo do
  begin
    if FTeeboxInfoList[nTeeboxNo].UseYn <> 'Y' then
      Continue;

    if (Global.ADConfig.StoreCode = 'B2001') then //그린필드
    begin
      if FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = 'M' then
      begin
        if FTeeboxInfoList[nTeeboxNo].UseStatus <> '8' then
        begin
          Global.XGolfDM.TeeboxErrorUpdate('AD', IntToStr(nTeeboxNo), '8');
          Global.Teebox.TeeboxDeviceCheck(nTeeboxNo, '8');
        end;

        sStr := '타석기 수동 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute);
        Global.Log.LogReserveWrite(sStr);
      end;
    end;

    if (FTeeboxInfoList[nTeeboxNo].UseStatus <> '7') and //볼회수
       (FTeeboxInfoList[nTeeboxNo].UseStatus <> '8') then //점검
    begin
      if FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = '9' then // 타석기 고장상태, 기기고장/통신이상
      begin
        if FTeeboxInfoList[nTeeboxNo].UseStatus <> '9' then //상태가 고장이 아니면
        begin
          FTeeboxInfoList[nTeeboxNo].UseStatusPre := FTeeboxInfoList[nTeeboxNo].UseStatus;
          FTeeboxInfoList[nTeeboxNo].UseStatus := '9';
          FTeeboxInfoList[nTeeboxNo].ErrorCd := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd;
          FTeeboxInfoList[nTeeboxNo].ErrorCd2 := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd2;

          Global.XGolfDM.TeeboxErrorStatusUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].UseStatus, IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) );

          sStr := 'Error No: ' + IntToStr(nTeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  'ErrorCd : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].UseStatusPre + ' -> 9';
          Global.Log.LogWrite(sStr);

          bTeeboxError := True;
          if sErrorS = EmptyStr then
            sErrorS := IntToStr(nTeeboxNo)
          else
            sErrorS := sErrorS + '/' + IntToStr(nTeeboxNo);

          //사용중일경우 기기고장 보상위해 저장
          //if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> EmptyStr) and (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0) and (FTeeboxInfoList[nTeeboxNo].ErrorCd <> 8) then
          if FTeeboxInfoList[nTeeboxNo].ErrorCd <> 8 then
          begin
            FTeeboxInfoList[nTeeboxNo].PauseTime := Now;
            FTeeboxInfoList[nTeeboxNo].ErrorReward := False;
            FTeeboxInfoList[nTeeboxNo].SendSMS := 'N';
            FTeeboxInfoList[nTeeboxNo].SendACS := 'N';
            Global.WriteConfigError(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].RemainMinute, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo);
          end;
        end;

        if (global.ADConfig.ErrorTimeReward = True) then //기기고장 시간보상
        begin
          //사용중일경우 기기고장 보상 최대 10분 체크, 에러보상전이면
          if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> EmptyStr) and (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0) and
             (FTeeboxInfoList[nTeeboxNo].ErrorReward = False) and (FTeeboxInfoList[nTeeboxNo].ErrorCd <> 8) then
          begin
            nTemp := MinutesBetween(FTeeboxInfoList[nTeeboxNo].PauseTime, Now);
            if nTemp >= 10 then
            begin
              FTeeboxInfoList[nTeeboxNo].RePlayTime := Now;
              FTeeboxInfoList[nTeeboxNo].ErrorReward := True;
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin + 10;

              ResetTeeboxRemainMinAdd(nTeeboxNo, 10, FTeeboxInfoList[nTeeboxNo].TeeboxNm);
              Global.WriteConfigErrorReward(nTeeboxNo);
            end;
          end;
        end;

        //2020-11-05 기기고장 1분 이상유지시 문자발송
        if (global.Store.ErrorSms = 'Y') or ((global.Store.ACS = 'Y') and (global.Store.ACS_1_Yn = 'Y')) then
        begin
          nTemp := SecondsBetween(FTeeboxInfoList[nTeeboxNo].PauseTime, now);

          if nTemp > 30 then //30초이상 기기고장 유지면
          begin
            if (global.Store.ErrorSms = 'Y') then
            begin
              if FTeeboxInfoList[nTeeboxNo].SendSMS <> 'Y' then
              begin
                Global.SendSMSToErp('1', FTeeboxInfoList[nTeeboxNo].TeeboxNm);
                FTeeboxInfoList[nTeeboxNo].SendSMS := 'Y';
                sStr := 'SendSMSToErp No: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm;
                Global.Log.LogErpApiWrite(sStr);
              end;
            end;
          end;

          if nTemp > global.Store.ACS_1 then //30초이상 기기고장 유지면
          begin
            if (global.Store.ACS = 'Y') and (global.Store.ACS_1_Yn = 'Y') then
            begin
              if FTeeboxInfoList[nTeeboxNo].SendACS <> 'Y' then
              begin
                Global.SendACSToErp('1', FTeeboxInfoList[nTeeboxNo].TeeboxNm);
                FTeeboxInfoList[nTeeboxNo].SendACS := 'Y';
                sStr := 'SendACSToErp No: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm;
                Global.Log.LogErpApiWrite(sStr);
              end;
            end;
          end;
        end;

      end
      else
      begin
        if FTeeboxInfoList[nTeeboxNo].UseStatus = '9' then //상태가 고장이면
        begin

          if (global.ADConfig.ErrorTimeReward = True) then //기기고장 시간보상
          begin

            //사용중일경우 기기고장 보상
            if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> EmptyStr) and (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0) and
               (FTeeboxInfoList[nTeeboxNo].ErrorReward = False) and (FTeeboxInfoList[nTeeboxNo].ErrorCd <> 8) then
            begin
              FTeeboxInfoList[nTeeboxNo].RePlayTime := Now;
              FTeeboxInfoList[nTeeboxNo].ErrorReward := True;
              nTemp := MinutesBetween(FTeeboxInfoList[nTeeboxNo].PauseTime, FTeeboxInfoList[nTeeboxNo].RePlayTime);
              if nTemp > 0 then
              begin
                if nTemp > 10 then
                begin
                  sStr := 'PauseTime Fail DelayTm > 10 : ' + IntToStr(nTeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' + IntToStr(nTemp);
                  Global.Log.LogReserveWrite(sStr);

                  nTemp := 10;
                end;

                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin + nTemp;

                ResetTeeboxRemainMinAdd(nTeeboxNo, nTemp, FTeeboxInfoList[nTeeboxNo].TeeboxNm);
                Global.WriteConfigErrorReward(nTeeboxNo);
              end;
            end;
          end;

          //FTeeboxInfoList[nTeeboxNo].UseStatus := FTeeboxInfoList[nTeeboxNo].UseStatusPre;
          if FTeeboxInfoList[nTeeboxNo].RemainMinute = 0 then
            FTeeboxInfoList[nTeeboxNo].UseStatus := '0'
          else
            FTeeboxInfoList[nTeeboxNo].UseStatus := '1';
          FTeeboxInfoList[nTeeboxNo].ErrorCd := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd;
          FTeeboxInfoList[nTeeboxNo].ErrorCd2 := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd2;

          Global.XGolfDM.TeeboxErrorStatusUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].UseStatus, IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) );

          sStr := 'Error No: ' + IntToStr(nTeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  'ErrorCd : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) + ' / ' +
                  '9 -> ' + FTeeboxInfoList[nTeeboxNo].UseStatus;
          Global.Log.LogWrite(sStr);

          bTeeboxError := True;
          if sErrorE = EmptyStr then
            sErrorE := IntToStr(nTeeboxNo)
          else
            sErrorE := sErrorE + '/' + IntToStr(nTeeboxNo);

        end;
      end;

      if FTeeboxInfoList[nTeeboxNo].UseStatus <> '9' then
      begin
        if (Global.ADConfig.ReserveMode = True) then //예약모드
        begin
          if FTeeboxInfoList[nTeeboxNo].RemainMinute = 0 then
            FTeeboxInfoList[nTeeboxNo].UseStatus := '0'
          else
          begin
            if FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = 'D' then
              FTeeboxInfoList[nTeeboxNo].UseStatus := '0'
            else
              FTeeboxInfoList[nTeeboxNo].UseStatus := '1';

            //타석에서 시작한 경우
            if (FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = '1') and
               (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate = '') and
               (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate < formatdatetime('YYYYMMDDhhnnss', Now)) then
            begin
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnn00', Now); //2021-06-11

              sStr := '배정시작 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                      FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                      IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
                      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
                      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate;
              Global.Log.LogReserveWrite(sStr);

              // DB/Erp저장: 시작시간
              Global.TcpServer.SetApiTeeBoxReg(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                               FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate);

              if (Global.ADConfig.StoreCode = 'B8001') then // 제이제이골프클럽
              begin
                if (FTeeboxInfoList[nTeeboxNo].TeeboxNo = 23) then // 24	120612
                  //Global.CtrlSendBuffer(nTeeboxNo, '120612', IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute), '0', 'S1');
                  Global.CtrlSendBuffer(nTeeboxNo, '122', IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute), '0', 'S1');

                if (FTeeboxInfoList[nTeeboxNo].TeeboxNo = 47) then // 48	240612
                  //Global.CtrlSendBuffer(nTeeboxNo, '240612', IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute), '0', 'S1');
                  Global.CtrlSendBuffer(nTeeboxNo, '242', IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute), '0', 'S1');
              end;
            end;
          end;
        end
        else
        begin
          if Global.ADConfig.StoreCode = 'BD001' then //BD001	그랜드골프클럽 -> 강제시작이 없음
          begin
            if FTeeboxInfoList[nTeeboxNo].RemainMinute = 0 then
              FTeeboxInfoList[nTeeboxNo].UseStatus := '0'
            else
            begin
              if FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = 'D' then
                FTeeboxInfoList[nTeeboxNo].UseStatus := '0'
              else
              begin
                //타석에서 시작한 경우
                if (FTeeboxInfoList[nTeeboxNo].UseStatus = '0') and (FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = '1') then
                begin
                  sStr := '타석시작 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                          FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                          FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                          IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                          FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
                          FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate;
                  Global.Log.LogReserveWrite(sStr);
                end;

                FTeeboxInfoList[nTeeboxNo].UseStatus := '1';
              end;

            end;
          end
          else
          begin
            if FTeeboxInfoList[nTeeboxNo].RemainMinute = 0 then
              FTeeboxInfoList[nTeeboxNo].UseStatus := '0'
            else
              FTeeboxInfoList[nTeeboxNo].UseStatus := '1';
          end;
        end;

      end;

    end;

    if (FTeeboxInfoList[nTeeboxNo].UseStatus = '7') then
    begin
      if (FTeeboxInfoList[nTeeboxNo].DeviceRemainMin > 1) then
      begin
        inc(FTeeboxInfoList[nTeeboxNo].DeviceCtrlCnt);

        if FTeeboxInfoList[nTeeboxNo].DeviceCtrlCnt < 3 then
        begin
          sStr := '볼회수 종료제어 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' + IntToStr(FTeeboxInfoList[nTeeboxNo].DeviceRemainMin);
          Global.Log.LogReserveWrite(sStr);

          SetTeeboxCtrlAD(nTeeboxNo, 'S1', 0, 9999);
        end;
      end;
    end
    else
    begin
      if (FTeeboxInfoList[nTeeboxNo].RemainMinute = 0) and (FTeeboxInfoList[nTeeboxNo].DeviceRemainMin > 1) and (FTeeboxInfoList[nTeeboxNo].UseStatus = '0') then
      begin
        sStr := '종료제어 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' + IntToStr(FTeeboxInfoList[nTeeboxNo].DeviceRemainMin);
        Global.Log.LogReserveWrite(sStr);

        if (Global.ADConfig.StoreCode = 'B8001') then //'B8001' 제이제이골프클럽
        SetTeeboxCtrlAD(nTeeboxNo, 'S3' , 0, 9999)
        else
        SetTeeboxCtrlAD(nTeeboxNo, 'S1', 0, 9999);
      end;
    end;

    if (Global.ADConfig.ReserveMode = True) then //예약모드
    begin
      if (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0) and
         (FTeeboxInfoList[nTeeboxNo].DeviceRemainMin = 0) and
         (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate = '') and
         (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate < formatdatetime('YYYYMMDDhhnnss', Now)) then
      begin
        sStr := '배정예약 재요청 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate;
        Global.Log.LogReserveWrite(sStr);

        SetTeeboxCtrlAD(nTeeboxNo, 'S0' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
      end;
    end;

    // DB저장: 타석기상태(시간,상태,볼수)
    if FTeeboxInfoList[nTeeboxNo].RemainMinPre <> FTeeboxInfoList[nTeeboxNo].RemainMinute then
    begin
      Global.XGolfDM.TeeboxInfoUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].RemainMinute, FTeeboxInfoList[nTeeboxNo].RemainBall, FTeeboxInfoList[nTeeboxNo].UseStatus, IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) );

      //배정시간과 타석기잔여시간 오차 제어
      if (FTeeboxInfoList[nTeeboxNo].RemainMinute <> FTeeboxInfoList[nTeeboxNo].DeviceRemainMin) and
         (FTeeboxInfoList[nTeeboxNo].RemainMinPre > 0) and (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0) and
         (FTeeboxInfoList[nTeeboxNo].UseStatus = '1') then
      begin
        //if Abs(FTeeboxInfoList[nTeeboxNo].RemainMinute - FTeeboxInfoList[nTeeboxNo].DeviceRemainMin) > 3 then
        if Abs(FTeeboxInfoList[nTeeboxNo].RemainMinute - FTeeboxInfoList[nTeeboxNo].DeviceRemainMin) > 2 then //2022-06-08
        begin
          sStr := '오차제어 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                  IntToStr(FTeeboxInfoList[nTeeboxNo].DeviceRemainMin) + ' -> ' +
                  IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute);
          Global.Log.LogReserveWrite(sStr);

          if (Global.ADConfig.ProtocolType = 'NANO') then
          begin
            if FTeeboxInfoList[nTeeboxNo].DeviceRemainMin = 0 then
            begin
              SetTeeboxCtrlAD(nTeeboxNo, 'S0' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);

              if Global.ADConfig.StoreCode <> 'BD001' then //BD001	그랜드골프클럽 -> 강제시작이 없음
                SetTeeboxCtrlAD(nTeeboxNo, 'S1' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
            end
            else
              SetTeeboxCtrlAD(nTeeboxNo, 'S2' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
          end
          else if (Global.ADConfig.ProtocolType = 'NANO2') then
          begin
            if (Global.ADConfig.StoreCode = 'B8001') then //'B8001' 제이제이골프클럽
            begin
              if FTeeboxInfoList[nTeeboxNo].DeviceRemainMin = 0 then
              begin
                SetTeeboxCtrlAD(nTeeboxNo, 'S0' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
                SetTeeboxCtrlAD(nTeeboxNo, 'S1' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
              end
              else
                SetTeeboxCtrlAD(nTeeboxNo, 'S2' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
            end
            else
              SetTeeboxCtrlAD(nTeeboxNo, 'S2' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
          end
          else
            SetTeeboxCtrlAD(nTeeboxNo, 'S1' , FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999);
        end;
      end;

      if (FTeeboxInfoList[nTeeboxNo].RemainMinPre = 0) and (FTeeboxInfoList[nTeeboxNo].RemainMinute = 1) then
      begin
        sStr := '시간오류1 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo;
        //Global.Log.LogReserveWrite(sStr);

        //시간오류 발생시 시간 초기화
        if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> '') and
           (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate <> '') then
        begin
          FTeeboxInfoList[nTeeboxNo].RemainMinute := 0;

          sStr := '시간오류1  보정: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo;
        end;

        Global.Log.LogReserveWrite(sStr);
      end;

    end;

    FTeeboxInfoList[nTeeboxNo].RemainMinPre := FTeeboxInfoList[nTeeboxNo].RemainMinute;
  end;

  if bTeeboxError = True then
    Global.TcpServer.SetApiTeeBoxStatus('error', sErrorS, sErrorE);

  Sleep(10);
  FTeeboxStatusUse := False;
end;

procedure TTeebox.TeeboxStatusChkTeebox;
var
  nTeeboxNo: Integer;
  sStr, sEndTy, sChange, sResult, sLog: String;
  I, nNN: Integer;
  sNN: String;

  tmNowEnd, tmNowEndTemp: TDateTime;
  nTemp: Integer;

  //기기고장 발생여부
  bTeeboxError: Boolean;
  sErrorS, sErrorE: String;
begin

  //2020-08-13
  while True do
  begin
    if FTeeboxReserveUse = False then
      Break;

    sLog := 'SeatReserveUse SeatStatusChk!';
    Global.Log.LogReserveDelayWrite(sLog);

    sleep(50);
  end;

  FTeeboxStatusUse := True;

  //기기고장 발생,해제시 상태 파트너센터 상태 업데이트
  bTeeboxError := False;
  sErrorS := EmptyStr;
  sErrorE := EmptyStr;

  for nTeeboxNo := 1 to FTeeboxLastNo do
  begin

    if FTeeboxInfoList[nTeeboxNo].ComReceive = 'N' then
      continue;

    if FTeeboxInfoList[nTeeboxNo].ControlYn <> 'Y' then
      continue;

    FTeeboxInfoList[nTeeboxNo].RemainMinute := FTeeboxInfoList[nTeeboxNo].DeviceRemainMin;

    if (FTeeboxInfoList[nTeeboxNo].UseStatus <> '7') and //볼회수
       (FTeeboxInfoList[nTeeboxNo].UseStatus <> '8') then //점검
    begin
      if FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = '9' then // 타석기 고장상태, 기기고장/통신이상
      begin
        if FTeeboxInfoList[nTeeboxNo].UseStatus <> '9' then //상태가 고장이 아니면
        begin
          FTeeboxInfoList[nTeeboxNo].UseStatusPre := FTeeboxInfoList[nTeeboxNo].UseStatus;
          FTeeboxInfoList[nTeeboxNo].UseStatus := '9';
          FTeeboxInfoList[nTeeboxNo].ErrorCd := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd;
          FTeeboxInfoList[nTeeboxNo].ErrorCd2 := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd2;

          Global.XGolfDM.TeeboxErrorStatusUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].UseStatus, IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) );

          sStr := 'Error No: ' + IntToStr(nTeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  'ErrorCd : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].UseStatusPre + ' -> 9';
          Global.Log.LogWrite(sStr);

          bTeeboxError := True;
          if sErrorS = EmptyStr then
            sErrorS := IntToStr(nTeeboxNo)
          else
            sErrorS := sErrorS + '/' + IntToStr(nTeeboxNo);

          if FTeeboxInfoList[nTeeboxNo].ErrorCd <> 8 then
          begin
            //2020-11-05 기기고장 30초 이상유지시 문자발송
            if (global.Store.ErrorSms = 'Y') or ((global.Store.ACS = 'Y') and (global.Store.ACS_1_Yn = 'Y')) then
            begin
              FTeeboxInfoList[nTeeboxNo].PauseTime := Now;
              //FTeeboxInfoList[nTeeboxNo].ErrorReward := False;
              FTeeboxInfoList[nTeeboxNo].SendSMS := 'N';
              FTeeboxInfoList[nTeeboxNo].SendACS := 'N';
              Global.WriteConfigError(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].RemainMinute, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo);
            end;
          end;

        end;

        //2020-11-05 기기고장 1분 이상유지시 문자발송
        if (global.Store.ErrorSms = 'Y') or ((global.Store.ACS = 'Y') and (global.Store.ACS_1_Yn = 'Y')) then
        begin
          nTemp := SecondsBetween(FTeeboxInfoList[nTeeboxNo].PauseTime, now);

          if nTemp > 30 then //30초이상 기기고장 유지면
          begin
            if (global.Store.ErrorSms = 'Y') then
            begin
              if FTeeboxInfoList[nTeeboxNo].SendSMS <> 'Y' then
              begin
                Global.SendSMSToErp('1', FTeeboxInfoList[nTeeboxNo].TeeboxNm);
                FTeeboxInfoList[nTeeboxNo].SendSMS := 'Y';
                sStr := 'SendSMSToErp No: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm;
                Global.Log.LogErpApiWrite(sStr);
              end;
            end;
          end;

          if nTemp > global.Store.ACS_1 then //30초이상 기기고장 유지면
          begin
            if (global.Store.ACS = 'Y') and (global.Store.ACS_1_Yn = 'Y') then
            begin
              if FTeeboxInfoList[nTeeboxNo].SendACS <> 'Y' then
              begin
                Global.SendACSToErp('1', FTeeboxInfoList[nTeeboxNo].TeeboxNm);
                FTeeboxInfoList[nTeeboxNo].SendACS := 'Y';
                sStr := 'SendACSToErp No: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm;
                Global.Log.LogErpApiWrite(sStr);
              end;
            end;
          end;

        end;

      end
      else
      begin
        if FTeeboxInfoList[nTeeboxNo].UseStatus = '9' then //상태가 고장이면
        begin
          if (Global.ADConfig.ProtocolType = 'NANO') then
          begin
            //'3':빈타석,'4':대기, '5':시작, '6':종료(End표시)
            if (FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = '5') then
              FTeeboxInfoList[nTeeboxNo].UseStatus := '1'
            else
              FTeeboxInfoList[nTeeboxNo].UseStatus := '0';
          end
          else
            FTeeboxInfoList[nTeeboxNo].UseStatus := FTeeboxInfoList[nTeeboxNo].DeviceUseStatus;

          FTeeboxInfoList[nTeeboxNo].ErrorCd := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd;
          FTeeboxInfoList[nTeeboxNo].ErrorCd2 := FTeeboxInfoList[nTeeboxNo].DeviceErrorCd2;

          Global.XGolfDM.TeeboxErrorStatusUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].UseStatus, IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) );

          sStr := 'Error 해제 No: ' + IntToStr(nTeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  'ErrorCd : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) + ' / ' +
                  '9 -> ' + FTeeboxInfoList[nTeeboxNo].UseStatus;
          Global.Log.LogWrite(sStr);

          bTeeboxError := True;
          if sErrorE = EmptyStr then
            sErrorE := IntToStr(nTeeboxNo)
          else
            sErrorE := sErrorE + '/' + IntToStr(nTeeboxNo);

        end
        else
        begin
          if (Global.ADConfig.ProtocolType = 'NANO') then
          begin
            //'3':빈타석,'4':대기, '5':시작, '6':종료(End표시)
            if (FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = '5') then
              FTeeboxInfoList[nTeeboxNo].UseStatus := '1'
            else
              FTeeboxInfoList[nTeeboxNo].UseStatus := '0';
          end
          else
            FTeeboxInfoList[nTeeboxNo].UseStatus := FTeeboxInfoList[nTeeboxNo].DeviceUseStatus;
        end;

        if (Global.ADConfig.ProtocolType = 'NANO') then
        begin
          if (FTeeboxInfoList[nTeeboxNo].DeviceUseStatus = '6') then
          begin
            sStr := 'LED 초기화 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm;
            Global.Log.LogReserveWrite(sStr);

            SetTeeboxCtrlAD(nTeeboxNo, 'S3' , 0, 9999);
          end;
        end;
      end;

    end;

    if FTeeboxInfoList[nTeeboxNo].RemainMinPre = FTeeboxInfoList[nTeeboxNo].RemainMinute then
    begin
      if (FTeeboxInfoList[nTeeboxNo].RemainMinute = FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) and
         (FTeeboxInfoList[nTeeboxNo].UseStatus = '1') then
      begin

      end
      else
        Continue;
    end
    else
    begin
      //Log
      sStr := IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' [ ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' ] ' +
              FTeeboxInfoList[nTeeboxNo].DeviceId + ' / ' +
              IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinPre) + ' <> ' + IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute);
      Global.Log.LogMonWrite(sStr);
    end;

    if (FTeeboxInfoList[nTeeboxNo].RemainMinPre = 0) and (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0) then
    begin

      if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo = '') or
         (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate <> '') then
      begin

        if FTeeboxInfoList[nTeeboxNo].UseStatus = '8' then
        begin
          sStr := '수동초기화(점검) : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm;
          Global.Log.LogReserveWrite(sStr);
        end
        else
        begin

          //2020-05-27 적용: 수동초기화
          sStr := '수동초기화 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
                FormatDateTime('YYYYMMDDhhnnss', FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareEndTime);
          Global.Log.LogReserveWrite(sStr);

          SetTeeboxCtrlAD(nTeeboxNo, 'S1', 0, 9999);
        end;

        Continue;
      end
      else
      begin

        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := '';
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'N';

        sStr := '배정시작 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].UseStatus + ' / ' + inttostr(FTeeboxInfoList[nTeeboxNo].RemainMinute);
        Global.Log.LogReserveWrite(sStr);

      end;
    end;

    if (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0) and
       (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn = 'N') and
       (FTeeboxInfoList[nTeeboxNo].UseStatus = '1') then
    begin

      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
      if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> '' then
      begin
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnn00', Now); //2021-06-11

        sStr := '배정구동 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate;
        Global.Log.LogReserveWrite(sStr);

        if (FTeeboxInfoList[nTeeboxNo].UseCancel = 'Y') then
        begin
          //2021-04-13 11:46:35.417# SendData : FCurCmdDataIdx 2 / 174 / 0371009999077
          //2021-04-13 11:46:35.729# Cancel no: 51 / 37 / 202104130082
          //2021-04-13 11:46:35.745# SendData : FCurCmdDataIdx 2 / 175 / 0370000000949
          // 배정후 바로 취소하는 경우 배정된 응답값 온후 취소응답값이 들어옴.

          sStr := '배정구동 DB저장 취소';
          Global.Log.LogReserveWrite(sStr);
        end
        else
        begin

          // 2021-11-02 타석테이블의 정보 갱신이 늦어 0으로 표시되는 경우 있음.
          Global.XGolfDM.TeeboxInfoUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].RemainMinute, FTeeboxInfoList[nTeeboxNo].RemainBall, FTeeboxInfoList[nTeeboxNo].UseStatus, '');

          // DB/Erp저장: 시작시간
          sResult := Global.TcpServer.SetApiTeeBoxReg(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                         FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate);

          if (Global.ADConfig.StoreCode = 'B8001') then // 제이제이골프클럽
          begin
            if (FTeeboxInfoList[nTeeboxNo].TeeboxNo = 23) then // 24	120612
              Global.CtrlSendBuffer(nTeeboxNo, '120612', IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute), '0', 'S1');

            if (FTeeboxInfoList[nTeeboxNo].TeeboxNo = 47) then // 48	240612
              Global.CtrlSendBuffer(nTeeboxNo, '240612', IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute), '0', 'S1');
          end;

        end;

      end;

    end;

    if (FTeeboxInfoList[nTeeboxNo].RemainMinPre > 0) and (FTeeboxInfoList[nTeeboxNo].RemainMinute = 0) then
    begin
      //2022-03-14 제이제이 타석기에서 종료시키는 경우가 있음. 예외처리함
      if (FTeeboxInfoList[nTeeboxNo].UseCancel = 'Y') or
         (FTeeboxInfoList[nTeeboxNo].UseClose = 'Y') or
         (FTeeboxInfoList[nTeeboxNo].RemainMinPre < 3) or
         (Global.ADConfig.StoreCode = 'B8001') then //제이제이
      begin
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

        sStr := '배정종료 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate;
        Global.Log.LogReserveWrite(sStr);

        sEndTy := '2';
        if (FTeeboxInfoList[nTeeboxNo].UseCancel = 'Y') then //취소인경우 K410_TeeBoxReserved 통해 ERP 전송
          sEndTy := '5'
        else
        begin
          // DB/Erp저장: 종료시간
          sResult := Global.TcpServer.SetApiTeeBoxEnd(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                         FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate, sEndTy);
        end;

        if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn = 'N') then  //예약대기상태
          FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo := '';

      end
      else
      begin
        if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> '' then
        begin
          //타석기에서 시간이 초기화 된 경우(타석기 고장으로 인한 초기화, 점검/볼회수로 인해 초기화)
          sStr := '타석기 대기 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                  IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].UseCancel + ' / ' +
                  IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinPre) + ' / ' +
                  IntToStr(FTeeboxInfoList[nTeeboxNo].RemainMinute)  + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate;
          Global.Log.LogReserveWrite(sStr);
          //타석기 대기 : 32 / 41 / T00012908 / 70 / N / 8 / 0 / 2019-12-13 21:58:18 /
        end;

        //타석기 대기 재배정
        if FTeeboxInfoList[nTeeboxNo].UseStatus = '9' then
        begin
          sStr := '타석기 대기 제어 취소(고장): ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm;
          Global.Log.LogReserveWrite(sStr);

          Continue;
        end
        //2021-06-16 송도, 점검시 제어취소
        else if FTeeboxInfoList[nTeeboxNo].UseStatus = '8' then
        begin
          sStr := '타석기 대기 제어 취소(점검): ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm;
          Global.Log.LogReserveWrite(sStr);

          Continue;
        end
        else
        begin
          if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo <> '' then
            SetTeeboxCtrlAD(nTeeboxNo, 'S1' , FTeeboxInfoList[nTeeboxNo].RemainMinPre, 9999);

          Continue;
        end;

      end;

    end;

    // DB저장: 타석기상태(시간,상태,볼수)
    if FTeeboxInfoList[nTeeboxNo].RemainMinPre <> FTeeboxInfoList[nTeeboxNo].RemainMinute then
      Global.XGolfDM.TeeboxInfoUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].RemainMinute, FTeeboxInfoList[nTeeboxNo].RemainBall, FTeeboxInfoList[nTeeboxNo].UseStatus, IntToStr(FTeeboxInfoList[nTeeboxNo].ErrorCd) );

    FTeeboxInfoList[nTeeboxNo].RemainMinPre := FTeeboxInfoList[nTeeboxNo].RemainMinute;
  end;

  //2020-11-05 기기고장 발생,해제 파트너센터 상태업데이트
  if bTeeboxError = True then
    Global.TcpServer.SetApiTeeBoxStatus('error', sErrorS, sErrorE);

  Sleep(10);
  FTeeboxStatusUse := False;
end;

procedure TTeebox.TeeboxReserveChkTeebox;
var
  nSeatNo: Integer;
  sSendData: AnsiString;
  sSeatTime, sSeatBall, sBcc: AnsiString;
  nCnt, nIndex: Integer;
  sCheckTime, sTime, sStr, sSeatStr: string;

  AEndTime: TDateTime;
  nNNTemp, nTmTemp: Integer;
  bReAssignMin: Boolean;

  tmCheckIn: TDateTime;
begin
  //Global.LogWrite('SeatReserveChk!!!');

  sCheckTime := FormatDateTime('YYYYMMDD hh:nn:ss', Now);
  sTime := Copy(sCheckTime, 10, 5);
  {
  if Global.ADConfig.StoreCode = 'A4001' then //유명
  begin

  end
  else
  begin

    if sTime < Global.Store.StartTime then
      Exit;

    if sTime > Global.Store.EndTime then
    begin
      if Global.Store.Close = 'N' then
      begin
        //SetStoreClose;
        Global.SetStoreInfoClose('Y');
        Global.Log.LogWrite('Store Close !!!');
      end;

      if (Global.Store.Close = 'Y') and (Global.Store.EndDBTime <> '') then
      begin
        if sTime > Global.Store.EndDBTime then
        begin
          Global.XGolfDM.SeatUseStoreClose( Global.ADConfig.StoreCode, Global.ADConfig.UserId, Copy(sCheckTime, 1, 8) );
          Global.SetStoreEndDBTime('');
        end;
      end;

      Exit;
    end;

    if Global.Store.Close = 'Y' then
    begin
      Global.SetStoreInfoClose('N');
      Global.Log.LogWrite('Store Open !!!');
    end;

  end;
  }
  //Global.LogWrite('SeatReserveChk !!!');

  for nSeatNo := 1 to TeeboxLastNo do
  begin
    if FTeeboxInfoList[nSeatNo].ComReceive <> 'Y' then
      Continue;

    //2020-12-17 빅토리아 추가
    if FTeeboxInfoList[nSeatNo].ControlYn <> 'Y' then
      continue;

    //타석기 배정상태 확인
    if FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo = '' then
      Continue;

    //모바일,기간권 미 체크인
    if FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignYn = 'N' then
    begin
      //시간 지난거에 대한 종료 처리 필요
      tmCheckIn := DateStrToDateTime3(FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveDate) +
                   (((1/24)/60) * (FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin + FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin));

      if tmCheckIn < now then
      begin
        FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn := 'Y';
        FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
        FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

        // DB/Erp저장: 종료시간
        Global.TcpServer.SetApiTeeBoxEnd(nSeatNo, FTeeboxInfoList[nSeatNo].TeeboxNm, FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo,
                                         FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveEndDate, '2');

        sStr := '미체크인 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveDate + ' / ' +
              IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin) + ' / ' +
              IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin) + ' / ' +
              formatdatetime('YYYY-MM-DD hh:nn:ss', Now);
        Global.Log.LogReserveWrite(sStr);

        FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo := '';
      end;

      Continue;
    end;

    if (FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn = 'Y') and
       (FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate <> '') then //배정상태
    begin
      Continue;
    end;

    if FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveDate > formatdatetime('YYYYMMDDhhnnss', Now) then
      Continue;

    if FTeeboxInfoList[nSeatNo].UseStatus <> '0' then //가동상태(빈타석:0) 4@
    begin
      if (FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime > Now) and
         (FTeeboxInfoList[nSeatNo].UseStatus = '1') then
      begin
        //if (Global.ADConfig.ProtocolType = 'ZOOM') or (Global.ADConfig.StoreCode = 'B2001') then
        if (Global.ADConfig.ProtocolType = 'ZOOM') then
        begin
          sStr := 'PrepareEndTime > Now / UseStatus = 1';
          Global.Log.LogReserveWrite(sStr);
        end
        else
        begin
          Continue;
        end;
      end
      else
      begin
        Continue;
      end;
    end;

    if FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime < Now then
    begin
      FTeeboxInfoList[nSeatNo].PrepareChk := 0;

      //2020-07-13 v15 배정등록직전 예약취소시 타이밍문제 발생
      if FTeeboxInfoList[nSeatNo].UseCancel = 'Y' then
      begin
        SetTeeboxCtrlAD(nSeatNo, 'S1', 0, 9999);

        if (FTeeboxInfoList[nSeatNo].RemainMinute = 0) and
           (FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn = 'N') and
           (FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate = '') then
        begin
          FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn := 'Y';
          FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
          FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

          sStr := '배정정리 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo;
          Global.Log.LogReserveWrite(sStr);
        end;

        sStr := '등록전취소 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo;
        Global.Log.LogReserveWrite(sStr);

        Continue;
      end;

      if FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin = 0 then //배정시간이 0인 경우
      begin
        FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn := 'Y';
        FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
        FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

        sStr := '배정에러 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
              IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate + ' / ' +
              formatdatetime('YYYY-MM-DD hh:nn:ss', Now);
        Global.Log.LogReserveWrite(sStr);
      end
      else
      begin
        sStr := '배정등록 : no' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin) + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveDate + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate + ' / ';

        SetTeeboxCtrlAD(nSeatNo, 'S1' , FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin, FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls);

        sStr := sStr + formatdatetime('YYYY-MM-DD hh:nn:ss', Now);
        Global.Log.LogReserveWrite(sStr);
      end;
    end
    else
    begin

      inc(FTeeboxInfoList[nSeatNo].PrepareChk);

      //if FTeeboxInfoList[nSeatNo].RemainMinute = 0 then
      //begin

        //2021-04-07 배정등록직전 예약취소시 타이밍문제 발생-유명
        if (FTeeboxInfoList[nSeatNo].UseCancel = 'Y') then
        begin

          if (FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn = 'N') and
             (FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate = '') then
          begin
            FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveYn := 'Y';
            FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
            FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

            sStr := '배정정리 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo;
            Global.Log.LogReserveWrite(sStr);
          end;

          sStr := '등록전취소 no: ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo;
          Global.Log.LogReserveWrite(sStr);

          Continue;
        end;

      if FTeeboxInfoList[nSeatNo].RemainMinute = 0 then
      begin

        //배정전 타석기 예약
        SetTeeboxCtrlAD(nSeatNo, 'S0' , FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin, FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls);

        sStr := '배정예약 : no ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin) + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveDate + ' / ' +
                FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate;
        Global.Log.LogReserveWrite(sStr);
      end;

      //2020-08-04 적용: 예약유지기능이 없음. 배정시간변경 확인
      FTeeboxInfoList[nSeatNo].PrepareChk := 0;

      if (FTeeboxInfoList[nSeatNo].RemainMinute > 0) and
         (FTeeboxInfoList[nSeatNo].RemainMinute <> FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin) then
      begin
        SetTeeboxCtrlAD(nSeatNo, 'S0' , FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignMin, FTeeboxInfoList[nSeatNo].TeeboxReserve.AssignBalls);

        sStr := '배정예약변경 no : ' + IntToStr(FTeeboxInfoList[nSeatNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveNo + ' / ' +
              IntToStr(FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareMin) + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.ReserveDate + ' / ' +
              FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareStartDate + ' / ' +
              formatdatetime('YYYY-MM-DD hh:nn:ss', FTeeboxInfoList[nSeatNo].TeeboxReserve.PrepareEndTime);
        Global.Log.LogReserveWrite(sStr);
      end;

    end;
  end;

end;

procedure TTeebox.TeeboxReserveChkAD;
var
  nTeeboxNo: Integer;
  sCheckTime, sTime, sStr, sLog: string;
  I, nNN, nTmTemp, nTemp: Integer;
  tmTempS: TDateTime;
  tmCheckIn: TDateTime;
begin
  while True do
  begin
    if FTeeboxReserveUse = False then
      Break;

    sLog := 'SeatReserveUse TeeboxReserveChkAD!';
    Global.Log.LogReserveDelayWrite(sLog);

    sleep(50);
  end;
  FTeeboxStatusUse := True;

  sCheckTime := FormatDateTime('YYYYMMDD hh:nn:ss', Now);
  sTime := Copy(sCheckTime, 10, 5);

  //chy test 임시주석 - 영업종료시간 초과시 AD 시간 계산인 경우 예상종료시간이 계산이 되지 않음.
  {
  if (sTime < Global.Store.StartTime) or (sTime >= Global.Store.EndTime) then
  begin
    if Global.Store.Close = 'N' then
    begin
      Global.SetStoreInfoClose('Y');
      Global.Log.LogWrite('Store Close !!!');
    end;

    Exit;
  end;

  if Global.Store.Close = 'Y' then
  begin
    Global.SetStoreInfoClose('N');
    Global.Log.LogWrite('Store Open !!!');
  end;
  }

  for nTeeboxNo := 1 to TeeboxLastNo do
  begin

    if (global.Store.UseRewardYn = 'Y') or //볼회수, 기기고장시 타석잔여시간 정지
       ((Global.Store.UseRewardYn = 'N') and (Global.Store.UseRewardException = 'Y')) then
    begin
      if FTeeboxInfoList[nTeeboxNo].UseStatus = '7' then
        continue;

      if (FTeeboxInfoList[nTeeboxNo].UseStatus = '9') and (FTeeboxInfoList[nTeeboxNo].ErrorReward = False) and (FTeeboxInfoList[nTeeboxNo].ErrorCd <> 8) then
        continue;
    end;

    //타석기 배정상태 확인
    if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo = '' then
      Continue;

    if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate > formatdatetime('YYYYMMDDhhnnss', Now) then
      Continue;

    if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin = 0 then //배정시간이 0인 경우
    begin
      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

      sStr := '배정에러 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' + FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / AssignMin = 0';
      Global.Log.LogReserveWrite(sStr);

      // DB/Erp저장: 종료시간
      Global.TcpServer.SetApiTeeBoxEnd(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                       FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate, '2');

      Continue;
    end;

    //취소, 종료 API 요청시 종료 제어함
    if (FTeeboxInfoList[nTeeboxNo].UseCancel = 'Y') or (FTeeboxInfoList[nTeeboxNo].UseClose = 'Y') then //취소인경우 K410_TeeBoxReserved 통해 ERP 전송
    begin

      if FTeeboxInfoList[nTeeboxNo].UseCancel = 'Y' then
      begin
        if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn = 'N') and
           (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate = '') then
        begin
          {
          if Global.ADConfig.ProtocolType = 'NANO' then
          begin
            FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
            FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);

            sStr := '등록전취소 no: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                  FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo;
            Global.Log.LogReserveWrite(sStr);
          end
          else
          begin
            if (FTeeboxInfoList[nTeeboxNo].RemainMinute = 0) then
            begin
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);

              sStr := '등록전취소 no: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                    FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                    FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo;
              Global.Log.LogReserveWrite(sStr);
            end;
          end;
          }

          FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
          FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);

          sStr := '등록전취소 no: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo;
          Global.Log.LogReserveWrite(sStr);

        end;
      end;

      if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate = '' then
      begin
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

        sStr := '배정종료 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate;
        Global.Log.LogReserveWrite(sStr);

        if (FTeeboxInfoList[nTeeboxNo].UseClose = 'Y') then
        begin
          // DB/Erp저장: 종료시간
          Global.TcpServer.SetApiTeeBoxEnd(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                         FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate, '2');
        end;

        //FTeeboxInfoList[nTeeboxNo].UseStatus := '0';
        FTeeboxInfoList[nTeeboxNo].RemainMinute := 0;

        if Global.ADConfig.StoreCode = 'B7001' then //인포네트, 프라자, 3층은 전원제어
        begin
          if nTeeboxNo > 52 then
            FTeeboxInfoList[nTeeboxNo].DeviceRemainMin := 0;
        end;

      end;
    end;

    //모바일,기간권 미 체크인
    if FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignYn = 'N' then
    begin
      //시간 지난거에 대한 종료 처리 필요
      tmCheckIn := DateStrToDateTime3(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate) +
                   (((1/24)/60) * (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareMin + FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin));

      if tmCheckIn < now then
      begin
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnnss', Now);
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

        // DB/Erp저장: 종료시간
        Global.TcpServer.SetApiTeeBoxEnd(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                         FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate, '2');

        sStr := '미체크인 no: ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
              IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareMin) + ' / ' +
              IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
              formatdatetime('YYYY-MM-DD hh:nn:ss', Now);
        Global.Log.LogReserveWrite(sStr);

        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo := '';
      end;

      Continue;
    end;

    //줌테크(ZOOM, ZOOM1) - 예약기능, 그린필드: 예약기능미사용
    if Global.ADConfig.ReserveMode = True then
    begin
      if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate = '') and
         (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate = '') and
         (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate < formatdatetime('YYYYMMDDhhnnss', Now)) and
         (FTeeboxInfoList[nTeeboxNo].RemainMinute = 0) then
      begin
        FTeeboxInfoList[nTeeboxNo].RemainMinute := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin;

        sStr := '배정예약 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate;
        Global.Log.LogReserveWrite(sStr);

        //배정위해 제어배열에 등록
        SetTeeboxCtrlAD(nTeeboxNo, 'S0' , FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignBalls);
      end;
    end;

    //배정시작전이고 대기시간을 지났으면
    if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate = '') and
       (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareEndTime < Now) then
    begin
      FTeeboxInfoList[nTeeboxNo].PrepareChk := 0;

      FTeeboxInfoList[nTeeboxNo].RemainMinute := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin;
      //FTeeboxInfoList[nTeeboxNo].UseStatus := '1';

      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn := 'Y';
      FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate := formatdatetime('YYYYMMDDhhnn00', Now); //2021-06-11

      sStr := '배정구동 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
              IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
              FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate;
      Global.Log.LogReserveWrite(sStr);

      // DB저장, 0분 표시되는 경우 있음.
      if (FTeeboxInfoList[nTeeboxNo].UseStatus <> '8') and  //점검
         (FTeeboxInfoList[nTeeboxNo].UseStatus <> '9') then
        Global.XGolfDM.TeeboxInfoUpdate(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].RemainMinute, 9999, '1', '');

      // DB/Erp저장: 시작시간
      Global.TcpServer.SetApiTeeBoxReg(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                       FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate);

      //배정위해 제어배열에 등록
      if Global.ADConfig.StoreCode = 'BD001' then //BD001	그랜드골프클럽 -> 강제시작이 없음
        SetTeeboxCtrlAD(nTeeboxNo, 'S0' , FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignBalls)
      else
        SetTeeboxCtrlAD(nTeeboxNo, 'S1' , FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignBalls);

    end;

    //시간계산
    if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate <> '') and
       (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate = '') and
       (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveYn = 'Y') then
    begin

      tmTempS := DateStrToDateTime3(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate);
      nNN := MinutesBetween(now, tmTempS);

      nTmTemp := FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin - nNN;
      if nTmTemp < 0 then
        nTmTemp := 0;

      if (FTeeboxInfoList[nTeeboxNo].RemainMinute = 0) and (nTmTemp = 1) then
      begin
        sStr := '시간오류 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo;
        Global.Log.LogReserveWrite(sStr);
      end;

      FTeeboxInfoList[nTeeboxNo].RemainMinute := nTmTemp;

      if Global.ADConfig.StoreCode = 'B7001' then //인포네트, 프라자, 3층은 전원제어
      begin
        if nTeeboxNo > 52 then
          FTeeboxInfoList[nTeeboxNo].DeviceRemainMin := nTmTemp;
      end;

      if FTeeboxInfoList[nTeeboxNo].RemainMinute = 0 then
      begin
        FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate := formatdatetime('YYYYMMDDhhnnss', Now);

        sStr := '배정종료 : ' + IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxNo) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxNm + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
                IntToStr(FTeeboxInfoList[nTeeboxNo].TeeboxReserve.AssignMin) + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.PrepareStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveStartDate + ' / ' +
                FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate;
        Global.Log.LogReserveWrite(sStr);

        // DB/Erp저장: 종료시간
        Global.TcpServer.SetApiTeeBoxEnd(nTeeboxNo, FTeeboxInfoList[nTeeboxNo].TeeboxNm, FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveNo,
                                       FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate, '2');

        //FTeeboxInfoList[nTeeboxNo].UseStatus := '0';

        if Global.ADConfig.ProtocolType = 'NANO2' then
          SetTeeboxCtrlAD(nTeeboxNo, 'S2', 0, 9999)
        else
          SetTeeboxCtrlAD(nTeeboxNo, 'S1', 0, 9999);
      end;

    end;

  end;

  Sleep(10);
  FTeeboxStatusUse := False;
end;

procedure TTeebox.TeeboxReserveNextChkAD;
var
  nTeeboxNo: Integer;
  sLog: String;
begin

  try

    for nTeeboxNo := 1 to TeeboxLastNo do
    begin

      if (FTeeboxInfoList[nTeeboxNo].RemainMinute > 0)  then
        Continue;

      //예약이 있고 아직 종료전이면
      if (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveDate <> '') and (FTeeboxInfoList[nTeeboxNo].TeeboxReserve.ReserveEndDate = '') then
        Continue;

      Global.ReserveList.ReserveListNextChk(nTeeboxNo);
    end;

  except
    on e: Exception do
    begin
       sLog := 'SeatReserveNextChk Exception : ' + e.Message;
       Global.Log.LogReserveWrite(sLog);
    end;
  end;

end;

procedure TTeebox.SetTeeboxInfoAD(ATeeboxInfo: TTeeboxInfo);
var
  nTeeboxNo: Integer;
begin
  nTeeboxNo := ATeeboxInfo.TeeboxNo;

  if (Global.ADConfig.TimeCheckMode = '1') and (Global.ADConfig.ProtocolType = 'NANO') then
  begin
    //점검, 볼회수 상태
    if (FTeeboxInfoList[nTeeboxNo].UseStatus = '7') and (BallBackEndCtl = False) then
      Exit;

    if FBallBackUse = True then
      Exit;
  end;

  FTeeboxInfoList[nTeeboxNo].RemainBall := ATeeboxInfo.RemainBall;
  FTeeboxInfoList[nTeeboxNo].DeviceRemainMin := ATeeboxInfo.RemainMinute;
  FTeeboxInfoList[nTeeboxNo].DeviceUseStatus := ATeeboxInfo.UseStatus;
  //FTeeboxInfoList[nTeeboxNo].ErrorCd := ATeeboxInfo.ErrorCd;
  FTeeboxInfoList[nTeeboxNo].DeviceErrorCd := ATeeboxInfo.ErrorCd;
  FTeeboxInfoList[nTeeboxNo].DeviceErrorCd2 := ATeeboxInfo.ErrorCd2;
  FTeeboxInfoList[nTeeboxNo].ComReceive := 'Y';
end;

procedure TTeebox.SetTeeboxErrorCntAD(AIndex, ATeeboxNo: Integer; AError: String; AMaxCnt: Integer);
var
  sLogMsg: String;
begin
  if (FTeeboxInfoList[ATeeboxNo].UseStatus = '7') or (FTeeboxInfoList[ATeeboxNo].UseStatus = '8') then
  begin
    //sLogMsg := 'UseStatus = ' + FTeeboxInfoList[ATeeboxNo].UseStatus + ' : ' + IntToStr(ATeeboxNo) + ' / ' + FTeeboxInfoList[ATeeboxNo].TeeboxNm;
    //Global.Log.LogRetryWrite(sLogMsg);
    Exit;
  end;

  if AError = 'Y' then
  begin
    FTeeboxInfoList[ATeeboxNo].ErrorCnt := FTeeboxInfoList[ATeeboxNo].ErrorCnt + 1;
    //if FTeeboxInfoList[ATeeboxNo].ErrorCnt > 10 then
    if FTeeboxInfoList[ATeeboxNo].ErrorCnt >= AMaxCnt then
    begin
      if FTeeboxInfoList[ATeeboxNo].ErrorYn = 'N' then
      begin
        sLogMsg := 'ErrorCnt : ' + IntToStr(AMaxCnt) + ' / ' + IntToStr(ATeeboxNo) + ' / ' + FTeeboxInfoList[ATeeboxNo].TeeboxNm;
        Global.Log.LogReadMulti(AIndex, sLogMsg);
      end;

      FTeeboxInfoList[ATeeboxNo].ErrorYn := 'Y';
      FTeeboxInfoList[ATeeboxNo].DeviceUseStatus := '9';
      //FTeeboxInfoList[ATeeboxNo].ErrorCd := 8; //통신이상
      FTeeboxInfoList[ATeeboxNo].DeviceErrorCd := 8; //통신이상
      FTeeboxInfoList[ATeeboxNo].DeviceErrorCd2 := '8'; //통신이상
    end;
  end
  else
  begin
    FTeeboxInfoList[ATeeboxNo].ErrorCnt := 0;
    FTeeboxInfoList[ATeeboxNo].ErrorYn := 'N';
  end;
end;

procedure TTeebox.SetTeeboxCtrlAD(ATeeboxNo: Integer; AType: String; ATime: Integer; ABall: Integer);
var
  sSendData: AnsiString;
  sSeatTime, sSeatBall, sDeviceIdR, sDeviceIdL: AnsiString;
  sStr: String;
  bCtrlExcept: Boolean;
begin

  //if (FTeeboxInfoList[ATeeboxNo].UseStatus = '7') or   //볼회수
  if (FTeeboxInfoList[ATeeboxNo].UseStatus = '8') or   //점검
     (FTeeboxInfoList[ATeeboxNo].UseStatus = '9') then //고장
  begin
    bCtrlExcept := True;

    if (Global.ADConfig.StoreCode = 'B8001') and (FTeeboxInfoList[ATeeboxNo].UseStatus = '9') and (FTeeboxInfoList[ATeeboxNo].ErrorCd <> 8) then //제이제이
      bCtrlExcept := False;

    if bCtrlExcept = True then
    begin
      sStr := '제어제외 : no ' + IntToStr(FTeeboxInfoList[ATeeboxNo].TeeboxNo) + ' / ' +
            FTeeboxInfoList[ATeeboxNo].TeeboxNm + ' / ' +
            FTeeboxInfoList[ATeeboxNo].TeeboxReserve.ReserveNo + ' / ' +
            FTeeboxInfoList[ATeeboxNo].UseStatus;
      Global.Log.LogReserveWrite(sStr);

      Exit;
    end;
  end;

  sSeatTime := IntToStr(ATime);
  sSeatBall := IntToStr(ABall);

  //global.LogWrite('SetTeeboxCtrl : ' + IntToStr(ASeatNo));
  {
  //	2	4	2	S	1	0	0	0	0	9	9	9	9		J
  // 대성 AB001: 장치ID 한자리, 좌우겸용 표시만
  if (FTeeboxInfoList[ATeeboxNo].TeeboxZoneCode = 'L') and (Global.ADConfig.StoreCode <> 'AB001') //대성골프클럽
  and (Global.ADConfig.StoreCode <> 'B7001') then //좌우겸용 프라자골프연습장
  begin
    if Global.ADConfig.ProtocolType = 'JEHU435' then  //스타 A1001 표시만 좌우겸용
    begin
      sDeviceIdR := Copy(FTeeboxInfoList[ATeeboxNo].DeviceId, 1, 2);
      Global.CtrlSendBuffer(ATeeboxNo, sDeviceIdR, sSeatTime, sSeatBall, AType);

      // chy 2021-04-07 스타 볼회수 에러로 length, trim 추가 2,56번타석
      if Length(FTeeboxInfoList[ATeeboxNo].DeviceId) = 4 then
      begin
        sDeviceIdL := Copy(FTeeboxInfoList[ATeeboxNo].DeviceId, 3, 2);

        if Trim(sDeviceIdL) <> '' then
        begin
          Global.CtrlSendBuffer(ATeeboxNo, sDeviceIdL, sSeatTime, sSeatBall, AType);
        end
        else
        begin
          sStr := '좌우겸용 sDeviceIdL Empty : ' + IntToStr(ATeeboxNo) + ' / ' + FTeeboxInfoList[ATeeboxNo].DeviceId;
          Global.Log.LogReserveWrite(sStr);
        end;
      end;
    end
    else
    begin

      sDeviceIdR := Copy(FTeeboxInfoList[ATeeboxNo].DeviceId, 1, 3);
      Global.CtrlSendBuffer(ATeeboxNo, sDeviceIdR, sSeatTime, sSeatBall, AType);

      if Length(FTeeboxInfoList[ATeeboxNo].DeviceId) = 6 then
      begin
        sDeviceIdL := Copy(FTeeboxInfoList[ATeeboxNo].DeviceId, 4, 3);

        if Trim(sDeviceIdL) <> '' then
        begin
          Global.CtrlSendBuffer(ATeeboxNo, sDeviceIdL, sSeatTime, sSeatBall, AType);
        end
        else
        begin
          sStr := '좌우겸용 sDeviceIdL Empty : ' + IntToStr(ATeeboxNo) + ' / ' + FTeeboxInfoList[ATeeboxNo].DeviceId;
          Global.Log.LogReserveWrite(sStr);
        end;
      end;
    end;

  end
  else   }
  begin
    Global.CtrlSendBuffer(ATeeboxNo, FTeeboxInfoList[ATeeboxNo].DeviceId, sSeatTime, sSeatBall, AType);

    //181	V8	3
    if (Global.ADConfig.StoreCode = 'A8001') then //쇼골프
    begin //8번룸 vip, 좌우겸용
      if (FTeeboxInfoList[ATeeboxNo].TeeboxNo = 179) then //vvip10
        Global.CtrlSendBuffer(ATeeboxNo, '61', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNo = 181) then // V8 -> vvip11
        Global.CtrlSendBuffer(ATeeboxNo, '64', sSeatTime, sSeatBall, AType);
    end;

    if (Global.ADConfig.StoreCode = 'B7001') then // 프라자
    begin
      {
      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '25') then // 25	204011	우,	204012	좌
        Global.CtrlSendBuffer(ATeeboxNo, '204012', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '26') then // 26	204013	우,	204014	좌
        Global.CtrlSendBuffer(ATeeboxNo, '204014', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '50') then // 50	205012	우,	205003	좌
        Global.CtrlSendBuffer(ATeeboxNo, '205003', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '51') then // 51	205005	우,	205002	좌
        Global.CtrlSendBuffer(ATeeboxNo, '205002', sSeatTime, sSeatBall, AType);
      }
      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '26') then // 26	204013	우,	204014	좌
        Global.CtrlSendBuffer(ATeeboxNo, '142', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '50') then // 50	205012	우,	205003	좌
        Global.CtrlSendBuffer(ATeeboxNo, '272', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '51') then // 51	205005	우,	205002	좌
        Global.CtrlSendBuffer(ATeeboxNo, '282', sSeatTime, sSeatBall, AType);
    end;

    if (Global.ADConfig.StoreCode = 'B8001') then // 제이제이골프클럽
    begin
      if (FTeeboxInfoList[ATeeboxNo].TeeboxNo = 23) then // 24번기준(120612) -> 23번 제어(120613)
        //Global.CtrlSendBuffer(ATeeboxNo, '120613', sSeatTime, sSeatBall, AType);
        Global.CtrlSendBuffer(ATeeboxNo, '123', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNo = 47) then // 48번기준(240612) -> 47번 제어(240613)
        //Global.CtrlSendBuffer(ATeeboxNo, '240613', sSeatTime, sSeatBall, AType);
        Global.CtrlSendBuffer(ATeeboxNo, '243', sSeatTime, sSeatBall, AType);
    end;

    if (Global.ADConfig.StoreCode = 'BB001') then //돔골프
    begin
      if (FTeeboxInfoList[ATeeboxNo].TeeboxNo = 1) then
        Global.CtrlSendBuffer(ATeeboxNo, 'R', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNo = 21) then
        Global.CtrlSendBuffer(ATeeboxNo, 'T', sSeatTime, sSeatBall, AType);

      if (FTeeboxInfoList[ATeeboxNo].TeeboxNo = 41) then
        Global.CtrlSendBuffer(ATeeboxNo, 'T', sSeatTime, sSeatBall, AType);
    end;

    if (Global.ADConfig.StoreCode = 'A8003') then //쇼골프-가양점
    begin
      if (FTeeboxInfoList[ATeeboxNo].TeeboxNm = '44') then
        Global.CtrlSendBuffer(ATeeboxNo, '242', sSeatTime, sSeatBall, AType);
    end;

  end;

end;

function TTeebox.SetSendApiErrorAdd(AReserveNo, AApi, AStr: String): Boolean;
var
  Data: TSendApiErrorData;
begin
  Data := TSendApiErrorData.Create;
  Data.Api := AApi;
  Data.Json := AStr;

  FSendApiErrorList.AddObject(AReserveNo, TObject(Data));
end;

procedure TTeebox.SendApiErrorRetry;
var
  sResult, sApi, sJson, sLog: String;
begin
  // 변경, 시작,종료, 이동 erp 등록시 에러 발생으로 인해 재시도, 시작된 배정의 체크인 추가
  if FSendApiErrorList.Count = 0 then
    Exit;

  while True do
  begin
    if FTeeboxReserveUse = False then
      Break;

    sLog := 'SeatReserveUse SendApiErrorRetry!';
    Global.Log.LogReserveDelayWrite(sLog);

    sleep(50);
  end;
  FTeeboxStatusUse := True;

  sApi := TSendApiErrorData(FSendApiErrorList.Objects[0]).Api;
  sJson := TSendApiErrorData(FSendApiErrorList.Objects[0]).Json;

  TSendApiErrorData(FSendApiErrorList.Objects[0]).Free;
  FSendApiErrorList.Objects[0] := nil;
  FSendApiErrorList.Delete(0);

  try
    sLog := 'SendApiErrorRetry : ' + sApi + ' / ' + sJson;
    Global.Log.LogErpApiWrite(sLog);

    sResult := Global.Api.SetErpApiNoneData(sJson, sApi, Global.ADConfig.ApiUrl, Global.ADConfig.ADToken);

    sLog := 'SendApiErrorRetry Result : ' + sResult;
    Global.Log.LogErpApiWrite(sLog);
    FTeeboxStatusUse := False;
  except
    on e: Exception do
    begin
      sLog := 'SendApiErrorRetry Exception : ' + sJson + ' / ' + e.Message;
      Global.Log.LogErpApiWrite(sLog);
      FTeeboxStatusUse := False;
    end;
  end

end;

end.
