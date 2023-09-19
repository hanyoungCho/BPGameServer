unit uLaneInfo;

interface

uses
  uStruct, System.Classes, System.SysUtils, System.DateUtils,
  Uni, System.Generics.Collections;

type
  TSampleThread = class(TThread)
  private
    Cnt: Integer;
    FClose: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TLane = class
  private
    FSampleThread: TSampleThread;

    FLaneList: array of TLaneInfo;
    FLaneCnt: Integer;

    //FTeeBoxInfo: TList<TTeeBoxInfo>;
    //FTeeBoxList: TList<TTeeBoxInfo>;

    //FUpdateTeeBoxList: TList<TTeeBoxInfo>;

    //FTeeboxBallBack: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure StartUp;
    function GetLaneListToApi: Boolean;
    function GetLaneInfoInit: Boolean;
    function GetPlayingLaneList: Boolean;

    function GetLaneInfo(AIdx: Integer): TLaneInfo;
    function GetLaneInfoIndex(ALaneNo: Integer): Integer;


    procedure GetLanePlayInfo;

    //function GetTeeBoxStatus(ATeeboxNm: String): String;

    //function GetUpdateTeeBoxListInfo(ATeeboxNo: Integer): TTeeBoxInfo;

    property LaneCnt: Integer read FLaneCnt write FLaneCnt;

    property SampleThread: TSampleThread read FSampleThread write FSampleThread;

    //property TeeBoxInfo: TList<TTeeBoxInfo> read FTeeBoxInfo write FTeeBoxInfo;
    //property TeeBoxList: TList<TTeeBoxInfo> read FTeeBoxList write FTeeBoxList;
    //property UpdateTeeBoxList: TList<TTeeBoxInfo> read FUpdateTeeBoxList write FUpdateTeeBoxList;

  end;

implementation

uses
  uGlobal, uFunction, Form.Select.Box, fx.Logging;

{ Tasuk }

constructor TLane.Create;
begin
  FLaneCnt := 0;

  SampleThread := TSampleThread.Create;
end;

destructor TLane.Destroy;
var
  I: Integer;
begin
  try

    SampleThread.Terminate;
    SampleThread.Free; //º¸·ù

    //SetLength(FLaneList, 0);

  except
    on E: Exception do
      Log.E('TLane.Destroy', E.Message);
  end;

  inherited;
end;

procedure TLane.StartUp;
begin
{
  if Global.Config.Emergency = False then
  begin
    GetLaneListToApi;
    SetLaneList;
  end
  else
    GetLaneListToDB;

  Global.ReserveList.StartUp;

  SetInitLaneAssign;   }
end;

function TLane.GetLaneListToApi: Boolean;
var
  nIndex: Integer;
  //jObjArr: TJsonArray;
  //jObj, jObjSub: TJSONObject;

  sJsonStr: AnsiString;
  sResult, sResultCd, sResultMsg, sLog: String;
begin
  Result := False;
  (*
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
      FLaneList[nIndex].PinSetterId := jObjSub.GetValue('device_id').Value;
      FLaneList[nIndex].CtlYn := odd(FLaneList[nIndex].LaneNo); // È¦¼ö¸é true, Â¦¼ö¸é false
      FLaneList[nIndex].ChgYn := False;
    end;

  finally
    FreeAndNil(jObj);
  end; *)

  Result := True;
end;

function TLane.GetLaneInfoInit: Boolean;
var
  AList: TList<TLaneInfo>;
  nIndex: Integer;
begin
  Result := False;

  AList := Global.ErpApi.GetLaneMaster;
  if AList.Count = 0 then
    Exit;

  FLaneCnt := AList.Count;
  SetLength(FLaneList, FLaneCnt);

  for nIndex := 0 to FLaneCnt - 1 do
  begin
    FLaneList[nIndex].LaneNo := AList[nIndex].LaneNo;
    FLaneList[nIndex].LaneNm := AList[nIndex].LaneNm;
    FLaneList[nIndex].Status := '0';
    FLaneList[nIndex].UseYn := True;
  end;

  FreeAndNil(AList);

  Result := True;
end;

function TLane.GetPlayingLaneList: Boolean;
var
  AList: TList<TLaneInfo>;
  i, nIdx: Integer;
begin
  Result := False;

  AList := Global.LocalApi.GetLanePlayingInfo;
  if AList.Count = 0 then
    Exit;

  for i := 0 to AList.Count - 1 do
  begin
    nIdx := GetLaneInfoIndex(AList[i].LaneNo);

    if nIdx = -1 then
      Continue;

    FLaneList[nIdx] := AList[i];
  end;

  FreeAndNil(AList);
  Result := True;
end;

function TLane.GetLaneInfo(AIdx: Integer): TLaneInfo;
begin
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

procedure TLane.GetLanePlayInfo;
begin
  if Global.SaleModule.LaneInfo.LaneNo < 1 then
  begin
    GetPlayingLaneList;
  end;
end;

{ TSampleThread }

constructor TSampleThread.Create;
begin
  Cnt := 0;
  FreeOnTerminate := False;
  inherited Create(True);
//  Cnt := 0;
end;

destructor TSampleThread.Destroy;
begin
//  Suspend;
  inherited;
end;

procedure TSampleThread.Execute;
begin
  inherited;

  while not Terminated do
  begin
    if FClose = True then
      Exit;

    Synchronize(Global.Lane.GetLanePlayInfo);
    Sleep(Global.Config.TeeBoxRefreshInterval * 1000);
  end;
end;

end.
