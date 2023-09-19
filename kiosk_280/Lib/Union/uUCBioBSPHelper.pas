(*******************************************************************************

  Project     : 유니온커뮤니티 지문인식기 공용 유닛
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2020-07-06   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
unit uUCBioBSPHelper;

interface

uses
  Classes, SysUtils, ExtCtrls, Windows, DB;

type
  TUCBioBSPOnCaptureEvent = procedure(ASender: TObject; AQuality: Integer) of Object;

  TUCBioBSPHelper = class
  private
    FUCBioBSP: Variant;
    FDevice: Variant;
    FExtraction: Variant;
    FMatching: Variant;
    FOnCaptureEvent: TUCBioBSPOnCaptureEvent;

    FActive: Boolean;
    FDataSet: TDataSet; //지문 검색용 데이터셋
    FFingerFieldName: string; //지문 저장 필드명
    FValueFieldName: string; //정상 매칭 후 반환할 필드명
    FFingerWindow: HWND; //지문 이미지 출력용 외부 컨트롤 핸들(0이면 사용 안함)
    FEnrollQuality: Integer; //지문 저장 품질 설정
    FVerifyQuality: Integer; //지문 비교 품질 설정
    FSecurityLevel: Integer; //지문 보안 레벨
    FDefaultTimeout: Integer; //지문 인식 타임아웃
    FFIR: string; //지문 인식 인코딩 값
    FTextFIR: string; //지문 인식 인코딩 값
    FMatchValue: string; //정상 매칭 후 반환할 데이터 필드 값
    FSuccess: Boolean; //최종 처리 결과
    FLastError: Integer; //최종 에러 코드
    FErrorMessage: string; //최종 에러 메시지

    function InitOption: Boolean; //지문 인식 환경 초기화
  public
    constructor Create;
    destructor Destroy; override;

    function Capture: Boolean; overload; //지문 인식
    function Capture(const AFingerWindow: HWND; var AErrMsg: string): Boolean; overload; //지문 인식
    function Matching: Boolean; overload; //지문 매칭 조회
    function Matching(const AFingerWindow: HWND; ADataSet: TDataSet; const AFingerField, AValueField: string; var AErrMsg: string): Boolean; overload; //지문 매칭 조회

    //chy
    function SearchMemberFinger: Boolean;

    property Active: Boolean read FActive default False;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property FingerFieldName: string read FFingerFieldName write FFingerFieldName;
    property ValueFieldName: string read FValueFieldName write FValueFieldName;
    property FingerWindow: HWND read FFingerWindow write FFingerWindow default 0;
    property EnrollQuality: Integer read FEnrollQuality write FEnrollQuality default 90; // (30 < 100)
    property VerifyQuality: Integer read FVerifyQuality write FVerifyQuality default 90; // (0 < 100)
    property SecurityLevel: Integer read FSecurityLevel write FSecurityLevel default 7; // (1 < 9)
    property DefaultTimeout: Integer read FDefaultTimeout write FDefaultTimeout default 10000; // 0 for Unlimited
    property FIR: string read FFIR write FFIR;
    property TextFIR: string read FTextFIR write FTextFIR;
    property MatchValue: string read FMatchValue write FMatchValue;
    property Success: Boolean read FSuccess write FSuccess default False;
    property LastError: Integer read FLastError write FLastError;
    property ErrorMessage: string read FErrorMessage write FErrorMessage;

    property OnCaptureEvent: TUCBioBSPOnCaptureEvent read FOnCaptureEvent write FOnCaptureEvent;
  end;

implementation

uses
  ComObj, Variants, Dialogs, uUCBioAPI_Type,
  uGlobal, uSaleModule, fx.Logging;

{ TSBUCBioBSPHelper }

constructor TUCBioBSPHelper.Create;
begin
  FUCBioBSP := CreateOleObject('UCBioBSPCOM.UCBioBSP');
  FDevice := FUCBioBSP.Device;
  FExtraction := FUCBioBSP.Extraction;
  FMatching := FUCBioBSP.Matching;
  FSuccess := False;

  try
    FUCBioBSP.SetSkinResource('UCBioBSPSkin_Kor.dll');
    FActive := InitOption;
  except
    on E: Exception do
      FErrorMessage := E.Message;
  end;
end;

destructor TUCBioBSPHelper.Destroy;
begin
  FDevice := 0;
  FExtraction := 0;
  FMatching := 0;
  FUCBioBSP := 0;

  inherited;
end;

function TUCBioBSPHelper.Capture: Boolean;
var
  sErrMsg: string;
begin
  Result := Capture(FingerWindow, sErrMsg);
end;
function TUCBioBSPHelper.Capture(const AFingerWindow: HWND; var AErrMsg: string): Boolean;
var
  ABuffer: array of Byte;
  nSize: Integer;
begin
  Result := False;
  FFingerWindow := AFingerWindow;
  if not InitOption then
    Exit;

  ABuffer := nil;
  try
    FDevice.Open(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    try
      FLastError := FDevice.ErrorCode;
      if (FLastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문 인식장치를 사용할 수 없습니다.' + #13#10 + FDevice.ErrorDescription);

      FExtraction.Capture(UCBioAPI_FIR_PURPOSE_VERIFY);
      FLastError := FExtraction.ErrorCode;
      if (FLastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문을 인식하지 못했습니다.' + #13#10 + FExtraction.ErrorDescription);

      nSize := FExtraction.FIRLength;
      SetLength(ABuffer, nSize);
      ABuffer := FExtraction.FIR;
      SetString(FFIR, PAnsiChar(@ABuffer[0]), nSize);
      FTextFIR := FExtraction.TextFIR;
      FSuccess := True;
      Result := True;
    finally
      SetLength(ABuffer, 0);
      FDevice.Close(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    end;
  except
    on E: Exception do
    begin
      FErrorMessage := E.Message;
      AErrMsg := FErrorMessage;
    end;
  end;
end;

function TUCBioBSPHelper.Matching: Boolean;
var
  sErrMsg: string;
begin
  Result := Matching(FingerWindow, DataSet, FingerFieldName, ValueFieldName, sErrMsg);
end;
function TUCBioBSPHelper.Matching(const AFingerWindow: HWND; ADataSet: TDataSet; const AFingerField, AValueField: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  FFingerWindow := AFingerWindow;
  if not InitOption then
    Exit;

  try
    FDevice.Open(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    try
      FLastError := FDevice.ErrorCode;
      if (FLastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문 인식장치를 사용할 수 없습니다.');

      if not ADataSet.Active then
        raise Exception.Create('지문 데이터를 사용할 수 없습니다.');
      if (ADataSet.FieldDefs.IndexOf(AFingerField) < 0) then
        raise Exception.Create('지문 데이터에서 사용할 수 없는 필드명이 지정되었습니다.');
      if (ADataSet.RecordCount = 0) then
        raise Exception.Create('검색 가능한 지문 데이터가 없습니다.');

      FExtraction.Capture(UCBioAPI_FIR_PURPOSE_VERIFY);
      FLastError := FExtraction.ErrorCode;
      if (FLastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문을 인식하지 못했습니다.' + #13#10 + FExtraction.ErrorDescription);

      FTextFIR := FExtraction.TextFIR;
      with ADataSet do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          if (FieldByName(AFingerField).AsString <> '') then
          begin
            FMatching.VerifyMatch(FTextFIR, FieldByName(AFingerField).AsString);
            if (VarToStr(FMatching.MatchingResult) = IntToStr(UCBioAPI_TRUE)) then
            begin
              if (ADataSet.FieldDefs.IndexOf(AValueField) >= 0) then
                FMatchValue := FieldByName(AValueField).AsString;
              FSuccess := True;
              Break;
            end;
          end;

          Next;
        end;

        Result := True;
        if not FSuccess then
          FErrorMessage := '일치하는 지문을 찾을 수 없습니다.';
      finally
        EnableControls;
      end;
    finally
      FDevice.Close(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    end;
  except
    on E: Exception do
    begin
      FErrorMessage := E.Message;
      AErrMsg := FErrorMessage;
    end;
  end;
end;

function TUCBioBSPHelper.InitOption: Boolean;
begin
  Result := False;
  FSuccess := False;
  FLastError := UCBioAPIERROR_NONE;
  FErrorMessage := '';
  FTextFIR := '';
  FMatchValue := '';

  {
  FCaptureQuality := 0;
  FScanQuality := 0;

  FEnrollQuality := 90;
  FIdentifyQuality := 90;
  FVerifyQuality := 50;
  FSecurityLevel := 9;
  FDefaultTimeout := 10000;

  ScanQuality = FEnrollQuality 동일, 포스환경설정에서 동일처리
  FEnrollQuality := 90; - 유명기준
  FIdentifyQuality := 90; - 유명기준
  FVerifyQuality := 55; - 유명기준
  FSecurityLevel := 9; - 유명기준

  nScanQuality : 입력된 지문의 순수한 이미지에 대한 품질의 최소 설정값
  nEnrollQuality : 추출된 특징점 품질값에 대한 등록시 적용하는 최소 설정값
  nVerifyQuality : 추출된 특징점 품질값에 대한 1:1매칭시 적용하는 최소 설정값
  nIdentifyQuality : 추출된 특징점 품질값에 대한 1:N 매칭시 적용하는 최소 설정값

  }

  //FingerWindow := Self.owner.handle;

  try
    if (FingerWindow = 0) then
    begin
      FUCBioBSP.WindowStyle := UCBioAPI_WINDOW_STYLE_POPUP;
      //FUCBioBSP.WindowOption[UCBioAPI_WINDOW_STYLE_NO_FPIMG] := UCBioAPI_TRUE;
      FUCBioBSP.WindowOption[UCBioAPI_WINDOW_STYLE_NO_FPIMG] := UCBioAPI_FALSE;
      FUCBioBSP.WindowOption[UCBioAPI_WINDOW_STYLE_NO_WELCOME] := UCBioAPI_TRUE;
    end else
    begin
      FUCBioBSP.WindowStyle := UCBioAPI_WINDOW_STYLE_INVISIBLE;
      FUCBioBSP.FingerWnd := FingerWindow;
    end;
    {
    FUCBioBSP.SecurityLevelForEnroll := EnrollQuality;
    FUCBioBSP.SecurityLevelForVerify := VerifyQuality;
    FUCBioBSP.SecurityLevelForIdentify := SecurityLevel;
    FUCBioBSP.DefaultTimeout := DefaultTimeout;
    }
    FUCBioBSP.SecurityLevelForEnroll := SecurityLevel;
    FUCBioBSP.SecurityLevelForVerify := SecurityLevel;
    FUCBioBSP.SecurityLevelForIdentify := SecurityLevel;
    //FUCBioBSP.SetCaptureQuality(ScanQuality, EnrollQuality, VerifyQuality, IdentifyQuality);
    //FUCBioBSP.SetCaptureQuality(90, 90, VerifyQuality, 90);
    //FUCBioBSP.SetCaptureQuality(90, 90, 55, 90);
    FUCBioBSP.SetCaptureQuality(EnrollQuality, EnrollQuality, VerifyQuality, EnrollQuality);
    //FUCBioBSP.DefaultTimeout := 10000;
    FUCBioBSP.DefaultTimeout := DefaultTimeout;
    FDevice.SetAutoDetect(UCBioAPI_TRUE);

    FLastError := FUCBioBSP.ErrorCode;
    if (FLastError <> UCBioAPIERROR_NONE) then
      raise Exception.Create('지문 인식장치 초기화에 실패하였습니다.' +#13#10 + FUCBioBSP.ErrorDescription);
    Result := True;
  except
    on E: Exception do
    begin
      FErrorMessage := E.Message;
      ShowMessage(Format('Error #%d - %s', [FLastError, FErrorMessage]));
    end;
  end;

end;

//chy
function TUCBioBSPHelper.SearchMemberFinger: Boolean;
var
  Index: Integer;
  sFingerData: string;
begin

  Result := False;
  FFingerWindow := FingerWindow;
  if not InitOption then
    Exit;

  try
    FDevice.Open(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    try
      FLastError := FDevice.ErrorCode;
      if (FLastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문 인식장치를 사용할 수 없습니다.');

      FExtraction.Capture(UCBioAPI_FIR_PURPOSE_VERIFY);
      FLastError := FExtraction.ErrorCode;
      if (FLastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문을 인식하지 못했습니다.' + #13#10 + FExtraction.ErrorDescription);

      FTextFIR := FExtraction.TextFIR;

      for Index := 0 to Global.SaleModule.MemberUpdateList.Count - 1 do
      begin
        if not Global.SaleModule.MemberUpdateList[Index].Use then
          Continue;

        if Global.SaleModule.MemberUpdateList[Index].FingerStr = EmptyStr then
          Continue;

        FMatching.VerifyMatch(FTextFIR, Global.SaleModule.MemberUpdateList[Index].FingerStr);

        if (VarToStr(FMatching.MatchingResult) = IntToStr(UCBioAPI_TRUE)) then
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

          FMatching.VerifyMatch(FTextFIR, Global.SaleModule.MemberList[Index].FingerStr);

          if (VarToStr(FMatching.MatchingResult) = IntToStr(UCBioAPI_TRUE)) then
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
      FDevice.Close(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    end;
  except
    on E: Exception do
    begin
      FErrorMessage := E.Message;
      //AErrMsg := FErrorMessage;
    end
  end;

end;

end.
