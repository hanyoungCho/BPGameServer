unit uNitgen;

interface

uses
  System.Win.ComObj, uStruct, System.SysUtils, NBioAPI_Type,
  System.Variants, BSPinter;

type

  TNitgen = class
    private
      objNBioBSP    : variant;
      objDevice     : variant;
      objExtraction : variant;
      objIndexSearch: variant;
      objResult     : variant;
      objMatching   : variant;
      FHomeDir: string;
      FDataFile: string;
    public
      constructor Create;
      destructor Destroy; override;

      function DeviceOpen: Boolean;

      function SearchMemberFinger: Boolean;

      //chy newmember
      function CaptureMemberFinger: Boolean;
  end;

implementation

uses
  uGlobal, uSaleModule, fx.Logging;

{ TNitgen }

constructor TNitgen.Create;
begin

end;

destructor TNitgen.Destroy;
begin

  inherited;
end;

function TNitgen.DeviceOpen: Boolean;
begin
  try
    try
      Result := False;

      objNBioBSP := CreateOleObject('NBioBSPCOM.NBioBSP');

      objDevice      := objNBioBSP.Device;

      objExtraction  := objNBioBSP.Extraction;

      objExtraction.VerifyImageQuality := Global.Config.VerifyImageQuality;
      objExtraction.SecurityLevel := Global.Config.SecurityLevel;
      objIndexSearch := objNBioBSP.IndexSearch;

      if objIndexSearch.ErrorCode = 0 then
        Result := True
      else
      begin
        // Error Log
      end;
    finally

    end;
  except
    on E: Exception do
      Log.E('DeviceOpen', E.Message);
  end;
end;

function TNitgen.SearchMemberFinger: Boolean;
var
  Index: Integer;
  sFingerData: string;
begin
  Result := False;
  try
    if not DeviceOpen then
    begin
      Log.E('DeviceOpen', 'Oepn Fali');
    end;

    objDevice.Open(NBioAPI_DEVICE_ID_AUTO_DETECT);
    if objDevice.ErrorCode <> 0 then
    begin
      Log.E('DeviceOpen', 'Oepn Error');
      Exit;
    end;

    objExtraction.Capture(NBioAPI_FIR_PURPOSE_VERIFY);
    sFingerData := objExtraction.TextEncodeFIR;

    objMatching := objNBioBSP.Matching;

    for Index := 0 to Global.SaleModule.MemberUpdateList.Count - 1 do
    begin
      if not Global.SaleModule.MemberUpdateList[Index].Use then
        Continue;

      if Global.SaleModule.MemberUpdateList[Index].FingerStr = EmptyStr then
        Continue;

//      if Global.SaleModule.MemberUpdateList[Index].FingerStr_2 = EmptyStr then
//        Continue;

      objMatching.VerifyMatch(sFingerData, Global.SaleModule.MemberUpdateList[Index].FingerStr);

      if VarToStr(objMatching.MatchingResult) = IntToStr(NBioAPI_TRUE) then
      begin
        Result := True;
        Log.D('MemberUpdateList 회원명', Global.SaleModule.MemberUpdateList[Index].Name);
        //Log.D('MemberUpdateList 회원지문', Global.SaleModule.MemberUpdateList[Index].FingerStr);
        Global.SaleModule.Member := Global.SaleModule.MemberUpdateList[Index];
        Break;
      end;
    end;

    if not Result then
    begin
      for Index := 0 to Global.SaleModule.MemberList.Count - 1 do
      begin
        if not Global.SaleModule.MemberList[Index].Use then
          Continue;

        if Global.SaleModule.MemberList[Index].FingerStr = EmptyStr then
          Continue;

//        if Global.SaleModule.MemberList[Index].FingerStr_2 = EmptyStr then
//          Continue;

        objMatching.VerifyMatch(sFingerData, Global.SaleModule.MemberList[Index].FingerStr);
        if VarToStr(objMatching.MatchingResult) = IntToStr(NBioAPI_TRUE) then
        begin
          Log.D('MemberList 회원명', Global.SaleModule.MemberList[Index].Name);
          //Log.D('MemberList 회원지문', Global.SaleModule.MemberList[Index].FingerStr);
          Result := True;
          Global.SaleModule.Member := Global.SaleModule.MemberList[Index];
          Break;
        end;
      end;
    end;
  finally
    objDevice.Close(NBioAPI_DEVICE_ID_AUTO_DETECT);
  end;
end;


//chy newmember
function TNitgen.CaptureMemberFinger: Boolean;
var
  Index: Integer;
  sFingerData: string;
  nLastError: Integer; //최종 에러 코드
  NewMember: TMemberInfo;
begin
  Result := False;
  try
    if not DeviceOpen then
    begin
      Log.E('DeviceOpen', 'Oepn Fali');
    end;

    objDevice.Open(NBioAPI_DEVICE_ID_AUTO_DETECT);
    if objDevice.ErrorCode <> 0 then
    begin
      Log.E('DeviceOpen', 'Oepn Error');
      Exit;
    end;

    objExtraction.Capture(NBioAPI_FIR_PURPOSE_VERIFY);
    nLastError := objExtraction.ErrorCode;
    if (nLastError <> NBioAPIERROR_NONE) then
    begin
      Log.E('Capture', 'Capture Error');
      Exit;
    end;

    sFingerData := objExtraction.TextEncodeFIR;

    NewMember.Name := Global.SaleModule.NewMember.Name;
    NewMember.Tel_Mobile := Global.SaleModule.NewMember.Tel_Mobile;
    NewMember.FingerStr := sFingerData;
    Global.SaleModule.NewMember := NewMember;

    Result := True;
  finally
    objDevice.Close(NBioAPI_DEVICE_ID_AUTO_DETECT);
  end;
end;

end.
