(*******************************************************************************

  Project     : 유니온커뮤니티 지문인식기 공용 유닛
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.3.0.0   2020-11-26   Added ValueClear.
    1.2.0.0   2020-09-21   Added MatchingValue.
    1.0.0.0   2020-07-06   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2020 All rights reserved.

*******************************************************************************)
unit uUCBioBSPHelper;

interface

uses
  Classes, SysUtils, ExtCtrls, Windows, DB;

type
  TUCBioBSPHelper = class
  private
    FUCBioBSP: Variant;
    FDevice: Variant;
    FExtraction: Variant;
    FMatching: Variant;

    FActive: Boolean;
    FDataSet: TDataSet; //지문 검색용 데이터셋
    FFingerFieldName: string; //지문 저장 필드명
    FValueFieldName: string; //정상 매칭 후 반환할 필드명
    FFingerWindow: HWND; //지문 이미지 출력용 외부 컨트롤 핸들(0이면 사용 안함)
    FScanQuality: Integer; //지문 스캔 품질 설정
    FEnrollQuality: Integer; //지문 저장 품질 설정
    FIdentifyQuality: Integer; //지문 인식 품질 설정
    FVerifyQuality: Integer; //지문 비교 품질 설정
    FSecurityLevel: Integer; //지문 보안 레벨 설정
    FDefaultTimeout: Integer; //지문 인식 타임아웃 설정
    FAutoDetectFinger: Boolean; //자동 지문 인식
    FTextFIR: string; //지문 인식 인코딩 값
    FMatchValue: string; //정상 매칭 후 반환할 데이터 필드 값
    FSuccess: Boolean; //최종 처리 결과
    FCaptureQuality: Integer; //지문 캡쳐 결과 품질
    FLastError: Integer; //최종 에러 코드
    FErrorMessage: string; //최종 에러 메시지

    function InitOption: Boolean;
    procedure SetFingerWindow(const AValue: HWND);
    procedure ValueClear;
  public
    constructor Create; overload;
    constructor Create(const AScanQuality, AEnrollQuality, AIdentifyQuality, AVerifyQuality,
      ASecurityLevel, ADefaultTimeout: Integer; const AAutoDetectFinger: Boolean=False); overload;
    destructor Destroy; override;

    function Capture: Boolean; overload; //지문 인식
    function Capture(const AFingerWindow: HWND; var AErrMsg: string): Boolean; overload; //지문 인식
    function Matching: Boolean; overload; //지문 매칭 조회
    function Matching(const AFingerWindow: HWND; ADataSet: TDataSet; const AFingerField, AValueField: string;
      var AErrMsg: string): Boolean; overload; //지문 매칭 조회

    property Active: Boolean read FActive write FActive default False;
    property Success: Boolean read FSuccess write FSuccess default False;
    property FingerWindow: HWND read FFingerWindow write SetFingerWindow default 0;
    property CaptureQuality: Integer read FScanQuality write FScanQuality default 0;
    property ScanQuality: Integer read FScanQuality write FScanQuality default 0;
    property EnrollQuality: Integer read FEnrollQuality write FEnrollQuality default 90;
    property IdentifyQuality: Integer read FIdentifyQuality write FIdentifyQuality default 90;
    property VerifyQuality: Integer read FVerifyQuality write FVerifyQuality default 50;
    property SecurityLevel: Integer read FSecurityLevel write FSecurityLevel default 9; // (1 < 9)
    property DefaultTimeout: Integer read FDefaultTimeout write FDefaultTimeout default 10000; // 0 for Unlimited
    property AutoDetectFinger: Boolean read FAutoDetectFinger write FAutoDetectFinger default False;
    property TextFIR: string read FTextFIR write FTextFIR;
    property MatchValue: string read FMatchValue write FMatchValue;
    property LastError: Integer read FLastError write FLastError;
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property FingerFieldName: string read FFingerFieldName write FFingerFieldName;
    property ValueFieldName: string read FValueFieldName write FValueFieldName;
  end;

implementation

uses
  ComObj, Variants, Dialogs, uUCBioAPI_Type;

{ TUCBioBSPHelper }

constructor TUCBioBSPHelper.Create;
begin
  FCaptureQuality := 0;
  FScanQuality := 0;
  FEnrollQuality := 90;
  FIdentifyQuality := 90;
  FVerifyQuality := 50;
  FSecurityLevel := 9;
  FDefaultTimeout := 10000;
  FAutoDetectFinger := False;

  Create(FScanQuality, FEnrollQuality, FIdentifyQuality, FVerifyQuality, FSecurityLevel, FDefaultTimeout);
end;

constructor TUCBioBSPHelper.Create(const AScanQuality, AEnrollQuality, AIdentifyQuality, AVerifyQuality,
  ASecurityLevel, ADefaultTimeout: Integer; const AAutoDetectFinger: Boolean);
begin
  inherited Create;

  FUCBioBSP := CreateOleObject('UCBioBSPCOM.UCBioBSP');
  FDevice := FUCBioBSP.Device;
  FExtraction := FUCBioBSP.Extraction;
  FMatching := FUCBioBSP.Matching;

  ScanQuality := AScanQuality;
  EnrollQuality := AEnrollQuality;
  IdentifyQuality := AIdentifyQuality;
  VerifyQuality := AVerifyQuality;
  SecurityLevel := ASecurityLevel;
  DefaultTimeout := ADefaultTimeout;
  AutoDetectFinger := AAutoDetectFinger;

  try
    FUCBioBSP.SetSkinResource('UCBioBSPSkin_Kor.dll');
    Active := InitOption;
  except
    on E: Exception do
      ErrorMessage := E.Message;
  end;
end;

destructor TUCBioBSPHelper.Destroy;
begin
  FreeAndNil(FExtraction);
  FreeAndNil(FMatching);
  FreeAndNil(FDevice);
  FreeAndNil(FUCBioBSP);

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
  ValueClear;
  if not Active then
    Exit;

  FingerWindow := AFingerWindow;
  ABuffer := nil;
  try
    FDevice.Open(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    try
      LastError := FDevice.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문 인식장치를 사용할 수 없습니다.' + #13#10 + FDevice.ErrorDescription);

      FExtraction.Capture(UCBioAPI_FIR_PURPOSE_VERIFY);
      LastError := FExtraction.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문을 인식하지 못했습니다.' + #13#10 + FExtraction.ErrorDescription);
    finally
      FDevice.Close(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    end;

    nSize := FExtraction.FIRLength;
    SetLength(ABuffer, nSize);
    ABuffer := FExtraction.FIR;
    SetString(FTextFIR, PAnsiChar(@ABuffer[0]), nSize);
    TextFIR := FExtraction.TextFIR;
    SetLength(ABuffer, 0);
    Success := True;
    Result := True;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
      AErrMsg := ErrorMessage;
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
  ValueClear;
  if not Active then
    Exit;

  FingerWindow := AFingerWindow;
  try
    if not ADataSet.Active then
      raise Exception.Create('지문 데이터를 사용할 수 없습니다.');
    if (ADataSet.FieldDefs.IndexOf(AFingerField) < 0) then
      raise Exception.Create('지문 데이터에서 사용할 수 없는 필드명이 지정되었습니다.');
    if (ADataSet.RecordCount = 0) then
      raise Exception.Create('검색 가능한 지문 데이터가 없습니다.');

    FDevice.Open(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    try
      LastError := FDevice.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문 인식장치를 사용할 수 없습니다.');

      FExtraction.Capture(UCBioAPI_FIR_PURPOSE_VERIFY);
      LastError := FExtraction.ErrorCode;
      if (LastError <> UCBioAPIERROR_NONE) then
        raise Exception.Create('지문을 인식하지 못했습니다.' + #13#10 + FExtraction.ErrorDescription);
    finally
      FDevice.Close(UCBioAPI_DEVICE_ID_AUTO_DETECT);
    end;

    TextFIR := FExtraction.TextFIR;
    with ADataSet do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        if (FieldByName(AFingerField).AsString <> '') then
        begin
          FMatching.VerifyMatch(TextFIR, FieldByName(AFingerField).AsString);
          if (VarToStr(FMatching.MatchingResult) = IntToStr(UCBioAPI_TRUE)) then
          begin
            if (ADataSet.FieldDefs.IndexOf(AValueField) >= 0) then
              MatchValue := FieldByName(AValueField).AsString;
            Success := True;
            Break;
          end;
        end;

        Next;
      end;

      Result := True;
      if not Success then
        ErrorMessage := '일치하는 지문을 찾을 수 없습니다.';
    finally
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
      AErrMsg := ErrorMessage;
    end;
  end;
end;

function TUCBioBSPHelper.InitOption: Boolean;
begin
  Result := False;
  ValueClear;

  try
    FUCBioBSP.SecurityLevelForEnroll := SecurityLevel;
    FUCBioBSP.SecurityLevelForVerify := SecurityLevel;
    FUCBioBSP.SecurityLevelForIdentify := SecurityLevel;
    FUCBioBSP.SetCaptureQuality(ScanQuality, EnrollQuality, VerifyQuality, IdentifyQuality);
    FUCBioBSP.DefaultTimeout := DefaultTimeout;
    if AutoDetectFinger then
      FDevice.SetAutoDetect(UCBioAPI_TRUE)
    else
      FDevice.SetAutoDetect(UCBioAPI_FALSE);

    LastError := FUCBioBSP.ErrorCode;
    if (LastError <> UCBioAPIERROR_NONE) then
      raise Exception.Create('지문 인식장치 초기화에 실패하였습니다.' + #13#10 + FUCBioBSP.ErrorDescription);
    Result := True;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
      ShowMessage(Format('Error #%d - %s', [LastError, ErrorMessage]));
    end;
  end;
end;

procedure TUCBioBSPHelper.SetFingerWindow(const AValue: HWND);
begin
  FFingerWindow := AValue;
  if (FFingerWindow = 0) then
  begin
    FUCBioBSP.WindowStyle := UCBioAPI_WINDOW_STYLE_POPUP;
    FUCBioBSP.WindowOption[UCBioAPI_WINDOW_STYLE_NO_FPIMG] := UCBioAPI_FALSE;
    FUCBioBSP.WindowOption[UCBioAPI_WINDOW_STYLE_NO_WELCOME] := UCBioAPI_TRUE;
  end else
  begin
    FUCBioBSP.WindowStyle := UCBioAPI_WINDOW_STYLE_INVISIBLE;
    FUCBioBSP.FingerWnd := FFingerWindow;
  end;
end;

procedure TUCBioBSPHelper.ValueClear;
begin
  Success := False;
  TextFIR := '';
  MatchValue := '';
  ErrorMessage := '';
  LastError := UCBioAPIERROR_NONE;
end;

end.
