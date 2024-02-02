unit uGlobal;

interface

uses
  IniFiles, System.DateUtils, System.Classes,
  uLaneInfo, uAssignReserve, uLaneThread,
  uConsts, uFunction, uStruct, uErpApi,
  uComBnC,
  uBowlingDM, uXGServer, uLogging,
  { Indy }
  IdIcmpClient;

type
  TGlobal = class

  private
    FStore: TStoreInfo;
    FConfig: TConfig;
    FLog: TLog;

    FLane: TLane;
    FReserveList: TAssignReserve;
    FApi: TApiServer;

    FDM: TBowlingDM;
    FTcpServer: TTcpServer;

    FLaneThread: TLaneThread;

    FCom: TComThread;

    FAppName: string;
    FHomeDir: string;
    FConfigFile: TIniFile;
    FConfigFileName: string;
    FConfigDir: string;
    
    FLaneThreadTime: TDateTime;

    FTeeboxThreadError: String;
    FTeeboxThreadChk: Integer;
    FComThreadTime: TDateTime;

    FTeeboxControlError: String;
    FTeeboxControlChk: Integer;

    FDebugSeatStatus: String;

    FDBWrite: Boolean; //DB 재연결 확인용

    FSendACSTeeboxError: TDateTime;

    procedure CheckConfig;
    procedure ReadConfig;
  public
    constructor Create;
    destructor Destroy; override;

    function StartUp: Boolean;
    function StopDown: Boolean;

    function GetErpOauth2: Boolean;

    procedure SetConfig(const ASection, AItem: string; const ANewValue: Variant);
    function GetStoreInfoToApi: Boolean;
    function GetTerminalToApi: Boolean;

    procedure LaneThreadTimeCheck; //DB, 예약번호 초기화등
    procedure DeleteDBReserve;

    function SetConfigEmergency(AMode, AUserId: String): Boolean;

    procedure WriteConfigStoreInfo;

    procedure ComThreadTimeCheck;

    property AppName: string read FAppName write FAppName;
    property HomeDir: string read FHomeDir write FHomeDir;
    property ConfigDir: string read FConfigDir write FConfigDir;
    property ConfigFile: TIniFile read FConfigFile write FConfigFile;
    property ConfigFileName: string read FConfigFileName write FConfigFileName;

    property Store: TStoreInfo read FStore write FStore;
    property Lane: TLane read FLane write FLane;

    property ReserveList: TAssignReserve read FReserveList write FReserveList;
    property LaneThread: TLaneThread read FLaneThread write FLaneThread;
    property Api: TApiServer read FApi write FApi;
    property Config: TConfig read FConfig write FConfig;
    property TcpServer: TTcpServer read FTcpServer write FTcpServer;
    property Log: TLog read FLog write FLog;
    property DM: TBowlingDM read FDM write FDM;
    property Com: TComThread read FCom write FCom;

    //property LaneThreadTime: TDateTime read FLaneThreadTime write FLaneThreadTime;

    property TeeboxThreadError: String read FTeeboxThreadError write FTeeboxThreadError;
    property ComThreadTime: TDateTime read FComThreadTime write FComThreadTime;
    property TeeboxControlError: String read FTeeboxControlError write FTeeboxControlError;

    //property DBWrite: Boolean read FDBWrite write FDBWrite;

    property SendACSTeeboxError: TDateTime read FSendACSTeeboxError write FSendACSTeeboxError;
  end;

var
  Global: TGlobal;

implementation

uses
  SysUtils, Variants, uXGMainForm, Vcl.Graphics, JSON,
  IdGlobal;

{ TGlobal }

constructor TGlobal.Create;
var
  sStr: string;
  nIndex: Integer;
begin
  FAppName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  FHomeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));

  FConfigDir := FHomeDir + 'config\';
  FConfigFileName := FConfigDir + 'BowlingPick.config';
  ForceDirectories(FConfigDir);
  FConfigFile := TIniFile.Create(FConfigFileName);
  if not FileExists(FConfigFileName) then
  begin
    WriteFile(FConfigFileName, ';***** BowlingPick Congiguration file *****');
    WriteFile(FConfigFileName, '');
  end;

  CheckConfig;
  ReadConfig; //파트너센터 접속정보

  FLaneThreadTime := Now;

  FDebugSeatStatus := '0';
  FTeeboxThreadChk := 0;
  FTeeboxControlChk := 0;
  FDBWrite := False;

end;

procedure TGlobal.CheckConfig;
begin

  if not FConfigFile.SectionExists('Partners') then
  begin
    FConfigFile.WriteString('Partners', 'StoreCode', '');
    FConfigFile.WriteString('Partners', 'UserId', '');
    FConfigFile.WriteString('Partners', 'UserPw', '');
    FConfigFile.WriteString('Partners', 'Url', '');

    WriteFile(FConfigFileName, '');
  end;

  if not FConfigFile.SectionExists('GSInfo') then
  begin
    FConfigFile.WriteInteger('GSInfo', 'Port', 1);
    FConfigFile.WriteInteger('GSInfo', 'Baudrate', 9600);
    FConfigFile.WriteInteger('GSInfo', 'TcpPort', 3308);
    FConfigFile.WriteInteger('GSInfo', 'DBPort', 3306);

    WriteFile(FConfigFileName, '');
  end;

  if not FConfigFile.SectionExists('Store') then
  begin
    FConfigFile.WriteString('Store', 'StartTime', '');
    FConfigFile.WriteString('Store', 'EndTime', '');
    WriteFile(FConfigFileName, '');
  end;

end;

procedure TGlobal.ReadConfig;
var
  sStr: String;
begin
  //Partners
  FConfig.StoreCd := FConfigFile.ReadString('Partners', 'StoreCode', '');
  FConfig.ApiUrl := FConfigFile.ReadString('Partners', 'Url', '');
  FConfig.TerminalId := FConfigFile.ReadString('Partners', 'TerminalId', '');

  sStr := FConfigFile.ReadString('Partners', 'TerminalPw', '');
  FConfig.TerminalPw := StrDecrypt(Trim(sStr));

  //GSInfo
  FConfig.Port := FConfigFile.ReadInteger('GSInfo', 'Port', 1);
  FConfig.Baudrate := FConfigFile.ReadInteger('GSInfo', 'Baudrate', 9600);
  FConfig.TcpPort := FConfigFile.ReadInteger('GSInfo', 'TcpPort', 3308);
  FConfig.DBPort := FConfigFile.ReadInteger('GSInfo', 'DBPort', 3306);

  FConfig.LaneStart := FConfigFile.ReadInteger('GSInfo', 'LaneStart', 0);
  FConfig.LaneEnd := FConfigFile.ReadInteger('GSInfo', 'LaneEnd', 0);
  FConfig.PrepareMin := FConfigFile.ReadInteger('GSInfo', 'PrepareMin', 2);

  FConfig.Emergency := FConfigFile.ReadString('GSInfo', 'Emergency', 'N') = 'Y';  //긴급배정모드
  if FConfig.Emergency = True then
    MainForm.pnlEmergency.Color := clRed
  else
    MainForm.pnlEmergency.Color := clBtnFace;

  //Store
  FStore.SaleStartTime := FConfigFile.ReadString('Store', 'StartTime', '05:00');
  FStore.SaleEndTime := FConfigFile.ReadString('Store', 'EndTime', '23:00');
  FStore.PerGameMin := FConfigFile.ReadInteger('Store', 'PerGameMin', 20);
end;

function TGlobal.StartUp: Boolean;
var
  sResult: String;
  sToken: AnsiString;
  sStr: String;
begin
  Result := False;

  Log := TLog.Create;
  FTcpServer := TTcpServer.Create;
  Api := TApiServer.Create;

  if Global.Config.Emergency = False then
  begin
    if GetErpOauth2 = False then
      SetConfigEmergency('Y', Config.TerminalId);

    //환경설정
    if GetTerminalToApi = False then
      Exit;

    ReadConfig; //파트너센터 정보 다시 읽기

    if GetStoreInfoToApi = False then
      Exit;
  end;

  DM := TBowlingDM.Create(Nil);

  Lane := TLane.Create;
  ReserveList := TAssignReserve.Create; // 예약목록
  LaneThread := TLaneThread.Create; // 예약정보관리

  Lane.StartUp;
  LaneThread.Resume;

  Com := TComThread.Create;
  Com.ComPortSetting(Global.Config.LaneStart, Global.Config.LaneEnd, Global.Config.Port, Global.Config.Baudrate);
  Com.Resume;

  Result := True;
end;

function TGlobal.GetErpOauth2: Boolean;
var
  sResult: String;
  sToken: AnsiString;
begin
  Result := False;

  sResult := Api.GetOauth2(sToken, FConfig.ApiUrl, FConfig.TerminalId, FConfig.TerminalPw);
  Log.LogWrite('Token ' + sResult);

  if sResult = 'Success' then
    FConfig.Token := sToken
  else
    Exit;

  Result := True;
end;


function TGlobal.GetTerminalToApi: Boolean;
var
  sResult, sStr: String;
  jObj, jSubObj: TJSONObject;
  sJsonStr: AnsiString;
  sResultCd, sResultMsg, sLog: String;

  MI: TMemIniFile;
  SL, IL: TStringList;
  SS: TStringStream;
  I, J: Integer;
begin
  Result := False;
  Log.LogWrite('Terminal Info Reset!!');

  try

    sJsonStr := '?terminal_id=' + Global.Config.TerminalId;
    sResult := Global.Api.GetErpApi(sJsonStr, 'B101_getTerminal', Global.Config.ApiUrl, Global.Config.Token);
    Log.LogErpApiWrite(sResult);

    if (Copy(sResult, 1, 1) <> '{') or (Copy(sResult, Length(sResult), 1) <> '}') then
    begin
      sLog := 'GetTerminalToApi Fail : ' + sResult;
      Log.LogWrite(sLog);
      Exit;
    end;

    jObj := TJSONObject.ParseJSONValue(sResult) as TJSONObject;
    sResultCd := jObj.GetValue('result_cd').Value;
    sResultMsg := jObj.GetValue('result_msg').Value;

    if sResultCd <> '0000' then
    begin
      sLog := 'B101_getTerminal : ' + sResultCd + ' / ' + sResultMsg;
      Log.LogWrite(sLog);
      Exit;
    end;

    jSubObj := jObj.GetValue('result_data') as TJSONObject;

    SS := TStringStream.Create;
    SS.Clear;
    SS.WriteString(jSubObj.GetValue('config').Value);
    MI := TMemIniFile.Create(SS, TEncoding.UTF8);
    SL := TStringList.Create;
    IL := TStringList.Create;

    MI.ReadSections(SL);
    for I := 0 to Pred(SL.Count) do
    begin
      IL.Clear;
      MI.ReadSection(SL[I], IL);
      for J := 0 to Pred(IL.Count) do
        SetConfig(SL[I], IL[J], MI.ReadString(SL[I], IL[J], ''));
    end;

    Result := True;
  finally
    FreeAndNil(jObj);
    FreeAndNil(IL);
    FreeAndNil(SL);
    FreeAndNil(MI);
    SS.Free;
  end;

end;

function TGlobal.GetStoreInfoToApi: Boolean;
var
  sResult: String;
  jObj, jSubObj: TJSONObject;
  sJsonStr: AnsiString;
  sResultCd, sResultMsg, sLog: String;

  InitTimeTemp: TDateTime;
  sInitTm, sInitTmTemp: String;
  bDBInit: Boolean;
begin
  Result := False;
  Log.LogWrite('Store Info Reset!!');

  try

    sJsonStr := '?store_cd=' + Global.Config.StoreCd;
    sResult := Global.Api.GetErpApi(sJsonStr, 'B001_getStore', Global.Config.ApiUrl, Global.Config.Token);
    Log.LogErpApiWrite(sResult);

    if (Copy(sResult, 1, 1) <> '{') or (Copy(sResult, Length(sResult), 1) <> '}') then
    begin
      sLog := 'GetStoreInfoToApi Fail : ' + sResult;
      Log.LogWrite(sLog);
      Exit;
    end;

    jObj := TJSONObject.ParseJSONValue(sResult) as TJSONObject;
    sResultCd := jObj.GetValue('result_cd').Value;
    sResultMsg := jObj.GetValue('result_msg').Value;

    if sResultCd <> '0000' then
    begin
      sLog := 'B001_getStore : ' + sResultCd + ' / ' + sResultMsg;
      Log.LogWrite(sLog);
      Exit;
    end;

    jSubObj := jObj.GetValue('result_data') as TJSONObject;

    FStore.StoreNm := jSubObj.GetValue('store_nm').Value;
    FStore.SaleStartTime := jSubObj.GetValue('sale_start_time').Value; //09:00:00
    FStore.SaleEndTime := jSubObj.GetValue('sale_end_time').Value;
    FStore.PerGameMin := StrToInt(jSubObj.GetValue('per_game_min').Value);  //게임당 소요시간(분)
    FStore.MinusFrame := StrToInt(jSubObj.GetValue('minus_frame').Value);  //차감 인정 프레임

    bDBInit := False;
    FStore.DBInitTime := '';

    sInitTm := formatdatetime('YYYY-MM-DD', Now) + ' ' + FStore.SaleStartTime;
    InitTimeTemp := IncMinute(DateStrToDateTime2(sInitTm), -10);
    sInitTmTemp := formatdatetime('hh:nn:ss', InitTimeTemp);

    if FStore.SaleStartTime < FStore.SaleEndTime then //금일영업
    begin
      bDBInit := True;
    end
    else //익일영업
    begin
      if FStore.SaleEndTime < sInitTmTemp then
        bDBInit := True;
    end;

    if bDBInit = True then
      FStore.DBInitTime := sInitTmTemp;

    WriteConfigStoreInfo;

    Result := True;
  finally
    FreeAndNil(jObj);
  end;

end;

function TGlobal.StopDown: Boolean;
begin
  Result := False;

  if LaneThread <> nil then
  begin
    LaneThread.Terminate;
    LaneThread.WaitFor;
    LaneThread.Free;
  end;

  if Com <> nil then
  begin
    Com.Terminate;
    Com.WaitFor;
    Com.Free;
  end;

  Result := True;
end;

destructor TGlobal.Destroy;
begin
  StopDown;

  DM.Free;
  FTcpServer.Free;
  Api.Free;
  Lane.Free;
  ReserveList.Free;

  //ini 파일
  FConfigFile.Free;

  Log.Free;

  inherited;
end;

procedure TGlobal.WriteConfigStoreInfo;
begin
  FConfigFile.WriteString('Store', 'StoreNm', FStore.StoreNm);
  FConfigFile.WriteString('Store', 'SaleStartTime', FStore.SaleStartTime);
  FConfigFile.WriteString('Store', 'SaleEndTime', FStore.SaleEndTime);
  FConfigFile.WriteInteger('Store', 'PerGameMin', FStore.PerGameMin);
end;

function TGlobal.SetConfigEmergency(AMode, AUserId: String): Boolean;
begin
  Result := False;

  if AMode = 'Y' then
  begin
    FConfig.Emergency := True;
    MainForm.pnlEmergency.Color := clRed;
  end
  else
  begin
    if GetErpOauth2 = False then
      Exit;

    FConfig.Emergency := False;
    MainForm.pnlEmergency.Color := clBtnFace;
  end;

  FConfigFile.WriteString('ADInfo', 'Emergency', AMode);

  Result := True;
end;

procedure TGlobal.LaneThreadTimeCheck;
var
  sPtime, sNtime, sPInittime, sNInittime, sTimeChk, sLogMsg: String;
  sResult: String;
  sToken: AnsiString;
begin
  sPtime := FormatDateTime('YYYYMMDDHH', FLaneThreadTime);
  sNtime := FormatDateTime('YYYYMMDDHH', Now);

  if FStore.DBInitTime <> EmptyStr then
  begin
    sPInittime := FormatDateTime('HH:NN', FLaneThreadTime);
    sNInittime := FormatDateTime('HH:NN', Now);

    if sPInittime <> sNInittime then
    begin
      if sNInittime = Copy(Store.DBInitTime, 1, 5) then
      begin
        Global.Lane.DBInit;
        sLogMsg := 'DBInit : ' + Store.DBInitTime;
        Log.LogWrite(sLogMsg);
      end;
    end;
  end;

  if sPtime <> sNtime then
  begin
    sLogMsg := 'TLaneThread TimeCheck !!';
    Log.LogWrite(sLogMsg);

    sTimeChk := Copy(sNtime, 9, 2);
    if sTimeChk = '00' then //배정번호 초기화
    begin
      TcpServer.UseSeqNo := 0;
      TcpServer.CommonSeqNo := 0;
      //TcpServer.LastUseSeqNo := TcpServer.UseSeqNo;
      TcpServer.UseSeqDate := FormatDateTime('YYYYMMDD', Now);
    end;

    if sTimeChk = '05' then
    begin
      DeleteDBReserve;

      //인증확인용
      sResult := Api.GetOauth2(sToken, FConfig.ApiUrl, FConfig.TerminalId, FConfig.TerminalPw);
      Log.LogWrite('Token : '  + sResult);
      if sResult = 'Success' then
      begin
        if FConfig.Token <> sToken then
          FConfig.Token := sToken;
      end;

      GetStoreInfoToApi;

      //DB재연결
      DM.ReConnection;
      FDBWrite := False;
    end;

    //오전중 DB 연결이 없을겨우 재연결
    if sTimeChk = '12' then
    begin
      if FDBWrite = False then
        DM.ReConnection;
    end;

  end;

  FLaneThreadTime := Now;
end;

procedure TGlobal.DeleteDBReserve;
var
  sDateStr: string;
  bResult: Boolean;
begin
  sDateStr := FormatDateTime('YYYYMMDD', Now - 2);
  bResult := DM.DeleteReserve(FConfig.StoreCd, sDateStr);

  if bResult = True then
    Log.LogWrite('배정데이터 삭제 완료: ' + sDateStr)
  else
    Log.LogWrite('배정데이터 삭제 실패: ' + sDateStr)

end;

procedure TGlobal.ComThreadTimeCheck;
var
  sPtime, sNtime, sLogMsg: String;
begin
  sPtime := FormatDateTime('YYYYMMDDHH', ComThreadTime);
  sNtime := FormatDateTime('YYYYMMDDHH', Now);

  if sPtime <> sNtime then
  begin
    sLogMsg := 'TComThread TimeCheck !!';
    Log.LogWrite(sLogMsg);
  end;

  ComThreadTime := Now;
end;

procedure TGlobal.SetConfig(const ASection, AItem: string; const ANewValue: Variant);
begin
  case VarType(ANewValue) of
    varInteger:
      FConfigFile.WriteInteger(ASection, AItem, ANewValue);
    varBoolean:
      FConfigFile.WriteBool(ASection, AItem, ANewValue);
  else
    FConfigFile.WriteString(ASection, AItem, ANewValue);
  end;
end;

end.
