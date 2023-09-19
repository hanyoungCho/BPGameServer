unit uBiominiPlus2;

interface

uses
  Generics.Collections, Uni, Data.DB, MemDS,
  Winapi.Windows, StrUtils, Math, Classes, SysUtils;

type
  THUFScanner = THandle;
  THUFMatcher = THandle;

  TUFS_Init = function(): Integer; stdcall;
  TUFS_GetScannerHandle = function(nScannerIndex: Integer; out phScanner: THUFScanner): Integer; stdcall;
  TUFS_SetParameter = function(phScanner: THUFScanner; nParam: Integer; pValue: PInteger): Integer; stdcall;
  TUFS_SetTemplateType = function(phScanner: THUFScanner; nTemplateType: Integer): Integer; stdcall;
  TUFS_UFS_ClearCaptureImageBuffer = function(phScanner: THUFScanner): Integer; stdcall;
  TUFS_CaptureSingleImage = function(phScanner: THUFScanner): Integer; stdcall;
  TUFS_Extract = function(hScanner: THUFScanner; var pTemplate: Byte; var pnTemplateSize: Integer; var pnEnrollQuality: Integer): Integer; stdcall;
  TUFM_Create = function (var hMatcher: THUFMatcher): Integer; stdcall;
  TUFM_Identify = function(hScanner: THUFScanner; pTemplate1: PByte; nTemplate1Size: Integer;  ppTemplate2: TList<Byte>; pnTemplate2Size: Integer;
                           nTemplate2Num: Integer; nTimeout: Integer; pnMatchTemplate2Index: Integer): Integer; stdcall;
  TUFM_Delete = function (hMatcher: THUFMatcher): Integer; stdcall;
  TUFS_UnInit = function(): Integer; stdcall;

  TUFS_GetParameter = function(hScanner: THUFScanner; nParam: Integer; pValue: PVariant): Integer; stdcall;
  TUFM_Verify = function(hMatcher: THUFMatcher; var pTemplate1: Byte; nTemplate1Size: Integer; var pTemplate2: Byte; nTemplate2Size: Integer; var bVerifySucceed: Integer): Integer; stdcall;

  TBioMiniPlus2 = class
  private
    FScannerDLL: THandle;
    FMatcherDLL: THandle;
    FDeviceHandle: THUFScanner;
    FDeviceMatch:  THUFMatcher;

    Lc_pTemplateBuffer: PByte;

    pnEnrollQuality: Integer;
    Lc_TemplateSize: Integer;
    TemplateByteArray: Array[0..384 - 1] of Byte; // represent the fingerprints as an Array of Bytes
    FByteArray: Array of Array[0..384 - 1] of Byte;
    FByteCntList: TList<Integer>;

    Exec_TUFS_Init: TUFS_Init;
    Exec_TUFS_GetScannerHandle: TUFS_GetScannerHandle;
    Exec_TUFS_SetParameter: TUFS_SetParameter;
    Exec_TUFS_SetTemplateType: TUFS_SetTemplateType;
    Exec_TUFS_UFS_ClearCaptureImageBuffer: TUFS_UFS_ClearCaptureImageBuffer;
    Exec_TUFS_CaptureSingleImage: TUFS_CaptureSingleImage;
    Exec_TUFS_Extract: TUFS_Extract;
    Exec_TUFM_Create: TUFM_Create;
    Exec_TUFM_Identify: TUFM_Identify;
    Exec_TUFM_Delete: TUFM_Delete;
    Exec_TUFS_UnInit: TUFS_UnInit;
    Exec_TUFS_GetParameter: TUFS_GetParameter;
    Exec_TUFM_Verify: TUFM_Verify;

    function UFS_Init: Boolean; //UFS_Init()
    function UFS_GetScannerHandle: Boolean;//UFS_GetScannerHandle()
    function UFS_SetParameter: Boolean;//UFS_Setparameter()
    function UFS_SetTemplateType: Boolean;//UFS_SetTemplateType()
    function UFS_ClearCaptureImageBuffer: Boolean; //UFS_GetCaptureImageBuffer();
    function UFS_CaptureSingleImage: Boolean; //UFS_CaptureSingleImage()
    function UFS_Extract: Boolean;//UFS_Extract()
    function UFM_Create: Boolean;//UFM_Create()
    function UFM_Identify: Boolean;//UFM_Identify()
    function UFM_Delete: Boolean;//UFM_Delete()
    function UFS_Uninit: Boolean;//UFS_Uninit()
    function UFS_GetParameter: Boolean; //TUFS_GetParameter();
    function UFM_Verify(out AMatchIndex: Integer): Boolean; //TUFM_Verify

    function ExecGetProcAddress: Boolean;

    function InitDevice: Boolean;
  public
    IsAdd: Boolean;
    constructor Create;
    destructor Destroy; override;

    // 지문조회시 사용
    function GetMemberIndex: Integer;
    // 메모리에만 저장 TEST용
    function AddData: Boolean; overLoad;
    // DB 데이터
    function AddData(AQuery: TUniQuery): Boolean; overLoad;

    property ScannerDLL: THandle read FScannerDLL write FScannerDLL;
    property MatcherDLL: THandle read FMatcherDLL write FMatcherDLL;
  end;

implementation

uses
  Unit7;

{ TBioMiniPlus2 }

function TBioMiniPlus2.AddData: Boolean;
begin
  try
    Result := False;

    if not UFS_ClearCaptureImageBuffer then
      Exit;

    if not UFS_CaptureSingleImage then
      Exit;

    if not UFS_Extract then
      Exit;

    Result := True;
    Form7.Memo1.Lines.Add( '등록완료' );
  finally

  end;
end;

function TBioMiniPlus2.AddData(AQuery: TUniQuery): Boolean;
var
  Index, Loop: Integer;
begin
  if AQuery.RecordCount <> 0 then
  begin
    ZeroMemory(@FByteArray, Length(FByteArray));
    SetLength(FByteArray, AQuery.RecordCount);

    FByteCntList.Clear;
    FByteCntList.Count := 0;

    for Index := 0 to AQuery.RecordCount - 1 do
    begin
      for Loop := 0 to AQuery.FieldByName('TemplateSize').AsInteger - 1 do
        FByteArray[Index][Loop] := AQuery.FieldByName('Template').AsBytes[Loop];

      FByteCntList.Add(AQuery.FieldByName('TemplateSize').AsInteger);
      AQuery.Next;
    end;
  end;

  Form7.Memo1.Lines.Add( '로드완료:' + IntToStr(Index) );
  Form7.Memo1.Lines.Add('FByteArray : ' + IntToStr(Length(FByteArray)));
  Form7.Memo1.Lines.Add('FByteCntList : ' + IntToStr(FByteCntList.Count));
end;

constructor TBioMiniPlus2.Create;
begin
  IsAdd := False;
  ScannerDLL := LoadLibrary('UFScanner.dll');
  MatcherDLL := LoadLibrary('UFMatcher.dll');

  FByteCntList := TList<Integer>.Create;
  InitDevice;
end;

destructor TBioMiniPlus2.Destroy;
begin
  FreeLibrary(FScannerDLL);
  Freelibrary(MatcherDLL);
  FByteCntList.Free;
  inherited;
end;

function TBioMiniPlus2.GetMemberIndex: Integer;
begin
  try
    Result := 0;

    if not UFS_ClearCaptureImageBuffer then
      Exit;

    if not UFS_CaptureSingleImage then
      Exit;

    if not UFS_Extract then
      Exit;

    if not UFM_Create then
      Exit;

    if not UFM_Verify(Result) then
      Exit;

    if not UFM_Delete then
      Exit;
  finally

  end;
end;

function TBioMiniPlus2.InitDevice: Boolean;
begin
  if not ExecGetProcAddress then
    Exit;
  if not UFS_Init then
    Exit;

  if not UFS_GetScannerHandle then
    Exit;

  if not UFS_SetParameter then
    Exit;

  if not UFS_SetTemplateType then
    Exit;
end;

function TBioMiniPlus2.UFS_Init: Boolean;
begin
  Result := Exec_TUFS_Init = 0;
end;

function TBioMiniPlus2.UFS_GetScannerHandle: Boolean;
begin
  Result := Exec_TUFS_GetScannerHandle(0, FDeviceHandle) = 0;
end;

function TBioMiniPlus2.UFS_SetParameter: Boolean;
var
  Index: PInteger;
begin
  Result := Exec_TUFS_SetParameter(FDeviceHandle, 201, @Index) = 0;
end;

function TBioMiniPlus2.UFS_SetTemplateType: Boolean;
begin
  Result := Exec_TUFS_SetTemplateType(FDeviceHandle, 2001) = 0;
end;

function TBioMiniPlus2.UFS_ClearCaptureImageBuffer: Boolean;
begin
  Result := Exec_TUFS_UFS_ClearCaptureImageBuffer(FDeviceHandle) = 0;
end;

function TBioMiniPlus2.UFS_CaptureSingleImage: Boolean;
begin
  Result := Exec_TUFS_CaptureSingleImage(FDeviceHandle) = 0;
end;

function TBioMiniPlus2.UFS_Extract: Boolean;
var
  Index, Quality: Integer;
begin
  if not UFS_GetParameter then
    Exit;

   ZeroMemory(@TemplateByteArray, 384);
   Exec_TUFS_Extract(FDeviceHandle, TemplateByteArray[0], Lc_TemplateSize, Quality);
   if IsAdd then
   begin

     SetLength(FByteArray, Length(FByteArray) + 1);
     for Index := 0 to Lc_TemplateSize - 1 do
       FByteArray[FByteCntList.Count][Index] := TemplateByteArray[Index];

     FByteCntList.Add(Lc_TemplateSize);
     Form7.Memo1.Lines.Add('FByteArray : ' + IntToStr(Length(FByteArray)));
     Form7.Memo1.Lines.Add('FByteCntList : ' + IntToStr(FByteCntList.Count));
   end;
end;

function TBioMiniPlus2.UFM_Create: Boolean;
begin
  Result := Exec_TUFM_Create(FDeviceMatch) = 0;
end;

function TBioMiniPlus2.UFM_Identify: Boolean;
var
  ACheck: Integer;
begin
  Result := Exec_TUFM_Verify(FDeviceMatch, Lc_pTemplateBuffer^, Lc_TemplateSize, Lc_pTemplateBuffer^, Lc_TemplateSize, ACheck) = 0;
end;

function TBioMiniPlus2.UFM_Delete: Boolean;
begin
  Result := Exec_TUFM_Delete(FDeviceMatch) = 0;
end;

function TBioMiniPlus2.UFS_Uninit: Boolean;
begin
  Result := Exec_TUFS_UnInit = 0;
end;

function TBioMiniPlus2.UFS_GetParameter: Boolean;
begin
  Result := Exec_TUFS_GetParameter(FDeviceHandle, 302, @Lc_TemplateSize) = 0;
end;

function TBioMiniPlus2.UFM_Verify(out AMatchIndex: Integer): Boolean;
var
  IResult, ACheck, Index, Loop: Integer;
  TemplateByte: Array[0..384 - 1] of Byte;
begin
  Result := False;
  for Index := 0 to Length(FByteArray) - 1 do
  begin
    ZeroMemory(@TemplateByte, Length(TemplateByte));
    for Loop := 0 to FByteCntList[Index] - 1 do
      TemplateByte[Loop] := FByteArray[Index][Loop];
    IResult := Exec_TUFM_Verify(FDeviceMatch, TemplateByteArray[0], Lc_TemplateSize, TemplateByte[0], FByteCntList[Index], ACheck);
    if ACheck = 1 then
    begin
      AMatchIndex := Index;
      Result := True;
      Form7.Memo1.Lines.Add('지문 확인 : ' + IntToStr(Index + 1));
      Break;
    end;
  end;

  if Result then
    Form7.Memo1.Lines.Add('성공')
  else
    Form7.Memo1.Lines.Add('실패');
end;

function TBioMiniPlus2.ExecGetProcAddress: Boolean;
begin
  @Exec_TUFS_Init := GetProcAddress(ScannerDLL, 'UFS_Init');
  if not Assigned(@Exec_TUFS_Init) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFS_GetScannerHandle := GetProcAddress(ScannerDLL, 'UFS_GetScannerHandle');
  if not Assigned(@Exec_TUFS_GetScannerHandle) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFS_SetParameter := GetProcAddress(ScannerDLL, 'UFS_SetParameter');
  if not Assigned(@Exec_TUFS_SetParameter) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFS_SetTemplateType := GetProcAddress(ScannerDLL, 'UFS_SetTemplateType');
  if not Assigned(@Exec_TUFS_SetTemplateType) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFS_UFS_ClearCaptureImageBuffer := GetProcAddress(ScannerDLL, 'UFS_ClearCaptureImageBuffer');
  if not Assigned(@Exec_TUFS_UFS_ClearCaptureImageBuffer) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFS_CaptureSingleImage := GetProcAddress(ScannerDLL, 'UFS_CaptureSingleImage');
  if not Assigned(@Exec_TUFS_CaptureSingleImage) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFS_Extract := GetProcAddress(ScannerDLL, 'UFS_Extract');
  if not Assigned(@Exec_TUFS_Extract) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFM_Create := GetProcAddress(MatcherDLL, 'UFM_Create');
  if not Assigned(@Exec_TUFM_Create) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFM_Identify := GetProcAddress(MatcherDLL, 'UFM_Identify');
  if not Assigned(@Exec_TUFM_Identify) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFM_Delete := GetProcAddress(MatcherDLL, 'UFM_Delete');
  if not Assigned(@Exec_TUFM_Delete) then
  begin
    // Log
    Exit;
  end;

//  @Exec_TUFS_UnInit := GetProcAddress(ScannerDLL, 'UFS_UnInit');
//  if not Assigned(@Exec_TUFS_UnInit) then
//  begin
//    // Log
//    Exit;
//  end;

  @Exec_TUFS_GetParameter := GetProcAddress(ScannerDLL, 'UFS_GetParameter');
  if not Assigned(@Exec_TUFS_GetParameter) then
  begin
    // Log
    Exit;
  end;

  @Exec_TUFM_Verify := GetProcAddress(MatcherDLL, 'UFM_Verify');
  if not Assigned(@Exec_TUFM_Verify) then
  begin
    // Log
    Exit;
  end;

  Result := True;
end;

end.
