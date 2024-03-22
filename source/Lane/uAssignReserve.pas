unit uAssignReserve;

interface

uses
  uStruct, uConsts,
  System.Classes, System.SysUtils, System.DateUtils,
  System.Generics.Collections;

type
  TAssignReserve = class
  private
    FList: array of TReserve;
    FListCnt: Integer;

    function GetListIndex(ALaneNo: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure StartUp;
    function ListClear: Boolean;

    function RegReserve(AAssignInfo: TAssignInfo): Boolean;
    //function RegReserveBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
    //function ChgReserveBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
    //function DelReserveBowler(AAssignNo, ABowlerId: String): Boolean;

    //function ChgReserveBowlerGameCnt(AAssignNo: String; ABowlerId: String; AGameCnt: String): Boolean;
    function ChgReserveBowlerPayment(AAssignNo: String; ABowlerId: String; APayment: String): Boolean;
    function DelAssignReserve(AAssignNo: String): Boolean;
    procedure ReserveListChk(ALaneNo: Integer);

    function GetReserveListCnt(ALaneNo: Integer): Integer;
    function GetReserveView(ALaneNo: Integer): String;
    function GetReserveLastTime(ALaneNo: Integer): String; //예약시간 검증

    function GetReserveAssignNoChk(AAssignNo: String; var RIdx, RIdx2, RLaneNo: Integer): Boolean;

    //property TeeboxLastNo: Integer read FTeeboxLastNo write FTeeboxLastNo;
  end;

implementation

uses
  uGlobal, uFunction, JSON;

{ Tasuk }

constructor TAssignReserve.Create;
begin
  FListCnt := 0;
end;

destructor TAssignReserve.Destroy;
begin
  ListClear;
  inherited;
end;

procedure TAssignReserve.StartUp;
var
  nIdx: Integer;
  rLaneInfo: TLaneInfo;
begin
  FListCnt := global.Lane.LaneCnt;
  SetLength(FList, FListCnt);

  for nIdx := 0 to FListCnt - 1 do
  begin
    rLaneInfo := global.Lane.GetLaneInfoToIndex(nIdx);
    FList[nIdx].LaneNo := rLaneInfo.LaneNo;
    FList[nIdx].ReserveList := TStringList.Create;
  end;
end;

function TAssignReserve.ListClear: Boolean;
var
  nLane, nIdx: Integer;
begin
  for nLane := 0 to FListCnt - 1 do
  begin
    for nIdx := 0 to FList[nLane].ReserveList.Count - 1 do
    begin
      TReserveInfo(FList[nLane].ReserveList.Objects[0]).Free;
      FList[nLane].ReserveList.Objects[0] := nil;
      FList[nLane].ReserveList.Delete(0);
    end;
    FreeAndNil(FList[nLane].ReserveList);
  end;

  SetLength(FList, 0);
end;

function TAssignReserve.GetListIndex(ALaneNo: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to FListCnt - 1 do
  begin
    if FList[i].LaneNo = ALaneNo then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAssignReserve.RegReserve(AAssignInfo: TAssignInfo): Boolean;
var
  nIdx: Integer;
  rReserveInfo: TReserveInfo;
begin
  Result := False;
  nIdx := GetListIndex(AAssignInfo.LaneNo);

  rReserveInfo := TReserveInfo.Create;
  rReserveInfo.AssignDt := AAssignInfo.AssignDt;
  rReserveInfo.AssignSeq := AAssignInfo.AssignSeq;
  rReserveInfo.AssignNo := AAssignInfo.AssignNo;
  rReserveInfo.CommonCtl := AAssignInfo.CommonCtl;
  rReserveInfo.LaneNo := AAssignInfo.LaneNo;
  rReserveInfo.GameDiv := AAssignInfo.GameDiv;
  rReserveInfo.GameType := AAssignInfo.GameType;
  rReserveInfo.LeagueYn := AAssignInfo.LeagueYn;
  rReserveInfo.ReserveDate := AAssignInfo.ReserveDate;
  rReserveInfo.ExpectdEndDate := AAssignInfo.ExpectdEndDate;

  FList[nIdx].ReserveList.AddObject(IntToStr(rReserveInfo.LaneNo), TObject(rReserveInfo));

  Result := True;
end;
{
function TAssignReserve.RegReserveBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
var
  nIdx, nIdx2, nLaneNo: Integer;
  bResult: Boolean;
  nResult: Integer;
begin
  Result := False;

  bResult := GetReserveAssignNoChk(AAssignNo, nIdx, nIdx2, nLaneNo);
  if bResult = False then
    Exit;

  //순번 확인용
  nResult := Global.DM.SelectAssignBowlerCnt(AAssignNo);
  if nResult = 0 then
    Exit;

  //DB저장
  ABowlerInfoTM.BowlerSeq := nResult + 1;
  bResult := Global.DM.InsertAssignBowler(nLaneNo, AAssignNo, ABowlerInfoTM);

  Result := True;
end;
}
{
function TAssignReserve.ChgReserveBowler(AAssignNo: String; ABowlerInfoTM: TBowlerInfo): Boolean;
var
  nIdx, nIdx2, nLaneNo: Integer;
  bResult: Boolean;
begin
  Result := False;

  bResult := GetReserveAssignNoChk(AAssignNo, nIdx, nIdx2, nLaneNo);
  if bResult = False then
    Exit;

  //DB저장
  bResult := Global.DM.UpdateAssignBowler(AAssignNo, ABowlerInfoTM);

  Result := True;
end;
}
{
function TAssignReserve.DelReserveBowler(AAssignNo, ABowlerId: String): Boolean;
var
  nIdx, nIdx2, nLaneNo: Integer;
  sLog: String;
  bResult: Boolean;
begin
  Result := False;

  bResult := GetReserveAssignNoChk(AAssignNo, nIdx, nIdx2, nLaneNo);
  if bResult = False then
    Exit;

  //DB저장
  bResult := Global.DM.UpdateAssignBowlerDel(AAssignNo, ABowlerId, 'Y'); //볼러정보 변경

  sLog := '볼러제거 : ' + AAssignNo + ' / ID:' + ABowlerId;
  Global.Log.LogServerWrite(sLog);

  Result := True;
end;
}
{
function TAssignReserve.ChgReserveBowlerGameCnt(AAssignNo: String; ABowlerId: String; AGameCnt: String): Boolean;
var
  nIdx, nIdx2, nLaneNo: Integer;
  bResult: Boolean;
begin
  Result := False;

  bResult := GetReserveAssignNoChk(AAssignNo, nIdx, nIdx2, nLaneNo);
  if bResult = False then
    Exit;

  //DB저장
  bResult := Global.DM.UpdateAssignBowlerGameCnt(AAssignNo, ABowlerId, StrToInt(AGameCnt)); //볼러정보 변경

  Result := True;
end;
}

function TAssignReserve.ChgReserveBowlerPayment(AAssignNo: String; ABowlerId: String; APayment: String): Boolean;
var
  nIdx, nIdx2, nLaneNo: Integer;
  bResult: Boolean;
begin
  Result := False;

  bResult := GetReserveAssignNoChk(AAssignNo, nIdx, nIdx2, nLaneNo);
  if bResult = False then
    Exit;

  //DB저장
  bResult := Global.DM.UpdateAssignBowlerPaymentType(AAssignNo, ABowlerId, APayment);

  Result := True;
end;

function TAssignReserve.DelAssignReserve(AAssignNo: String): Boolean;
var
  I, nIdx, nIdx2, nLaneNo: Integer;
  bResult: Boolean;
  jSendObj: TJSONObject;
  sLog: String;
begin
  Result := False;

  bResult := GetReserveAssignNoChk(AAssignNo, nIdx, nIdx2, nLaneNo);

  if bResult = False then
    Exit;

  if AAssignNo = TReserveInfo(FList[nIdx].ReserveList.Objects[nIdx2]).AssignNo then
  begin
    TReserveInfo(FList[nIdx].ReserveList.Objects[nIdx2]).Free;
    FList[nIdx].ReserveList.Objects[nIdx2] := nil;
    FList[nIdx].ReserveList.Delete(nIdx2);

    // DB/Erp저장: 종료시간
    Global.DM.chgAssignEndDt(AAssignNo, '7');

    jSendObj := TJSONObject.Create;
    jSendObj.AddPair(TJSONPair.Create('store_cd', Global.Config.StoreCd));
    jSendObj.AddPair(TJSONPair.Create('assign_no', AAssignNo));
    jSendObj.AddPair(TJSONPair.Create('lane_no', FList[nIdx].LaneNo));
    jSendObj.AddPair(TJSONPair.Create('assign_status', '3'));
    jSendObj.AddPair(TJSONPair.Create('status_datetime', FormatDateTime('YYYY-MM-DD hh:nn:ss', now)));
    jSendObj.AddPair(TJSONPair.Create('user_id', Global.Config.TerminalId));

    Global.Lane.RegAssignEpr(AAssignNo, 'E002_chgLaneAssign', jSendObj.ToString);
    FreeAndNil(jSendObj);

    sLog := '예약취소 - No: ' + IntToStr(FList[nIdx].LaneNo) + ' / ' + AAssignNo;
    Global.Log.LogReserveWrite(sLog);

    Result := True;
  end;
end;

procedure TAssignReserve.ReserveListChk(ALaneNo: Integer);
var
  nIdx: Integer;
  sLog: String;
  rReserveInfo: TReserveInfo;
begin

  try
    nIdx := GetListIndex(ALaneNo);

    if FList[nIdx].ReserveList.Count = 0 then
      Exit;

    rReserveInfo := TReserveInfo(FList[nIdx].ReserveList.Objects[0]);

    Global.Lane.SetLaneAssignReserve(rReserveInfo);

    TReserveInfo(FList[nIdx].ReserveList.Objects[0]).Free;
    FList[nIdx].ReserveList.Objects[0] := nil;
    FList[nIdx].ReserveList.Delete(0);

  except
    on e: Exception do
    begin
       sLog := 'ReserveListChk Exception : ' + e.Message;
       Global.Log.LogReserveWrite(sLog);
    end;
  end;

end;

function TAssignReserve.GetReserveListCnt(ALaneNo: Integer): Integer;
var
  nIndex: Integer;
begin
  nIndex := GetListIndex(ALaneNo);
  Result := FList[nIndex].ReserveList.Count;
end;

function TAssignReserve.GetReserveView(ALaneNo: Integer): String;
var
  I, nIndex: integer;
  sStr: String;
begin
  sStr := '';
  nIndex := GetListIndex(ALaneNo);
  {
  for I := 0 to FList[nIndex].ReserveList.Count - 1 do
  begin
    sStr := sStr + IntToStr(I) + ': ';
    sStr := sStr + TReserveInfo(FList[nIndex].ReserveList.Objects[I]).AssignNo + ' / ' +
          TReserveInfo(FList[nIndex].ReserveList.Objects[I]).BowlerNm_1 + ' / ' +
          TReserveInfo(FList[nIndex].ReserveList.Objects[I]).BowlerNm_2 + ' / ' +
          TReserveInfo(FList[nIndex].ReserveList.Objects[I]).BowlerNm_3 + ' / ' +
          TReserveInfo(FList[nIndex].ReserveList.Objects[I]).BowlerNm_4  + ' / ' +
          TReserveInfo(FList[nIndex].ReserveList.Objects[I]).BowlerNm_5  + ' / ' +
          TReserveInfo(FList[nIndex].ReserveList.Objects[I]).BowlerNm_6;

    sStr := sStr + #13#10;
  end;
  }
  Result := sStr;
end;

function TAssignReserve.GetReserveLastTime(ALaneNo: Integer): String; //예약시간 검증
var
  nIdx, nReserveIdx: integer;
  sStr: String;
begin
  sStr := '';
  nIdx := GetListIndex(ALaneNo);

  if FList[nIdx].ReserveList.Count = 0 then
  begin
    Result := sStr;
    Exit;
  end;

  nReserveIdx := FList[nIdx].ReserveList.Count - 1;
  sStr := TReserveInfo(FList[nIdx].ReserveList.Objects[nReserveIdx]).ExpectdEndDate;

  Result := sStr;
end;

function TAssignReserve.GetReserveAssignNoChk(AAssignNo: String; var RIdx, RIdx2, RLaneNo: Integer): Boolean;
var
  i, j: Integer;
  bChk: Boolean;
begin
  bChk := False;

  for i := 0 to FListCnt - 1 do
  begin
    if FList[i].ReserveList.Count = 0 then
      Continue;

    for j := 0 to FList[i].ReserveList.Count - 1 do
    begin
      if TReserveInfo(FList[i].ReserveList.Objects[j]).AssignNo = AAssignNo then
      begin
        RIdx := i;
        RIdx2 := j;
        RLaneNo := FList[i].LaneNo;
        bChk := True;
        Break;
      end;
    end;

    if bChk = True then
      Break;
  end;

  Result := bChk;
end;

end.
