unit uBiominiPlus2;

interface

uses
  Generics.Collections, Uni, Data.DB, MemDS, EncdDecd,
  Winapi.Windows, StrUtils, Math, Classes, SysUtils, FMX.Forms;

type
  TArrayArrayByte = Array of Array[0..384 - 1] of Byte;
  TArrayInteger = Array of Integer;

  THUFScanner = THandle;
  THUFMatcher = THandle;

  TUFS_Init = function(): Integer; stdcall;
  TUFS_UnInit = function(): Integer; stdcall;
  TUFS_Update = function(): Integer; stdcall;
  TUFS_GetScannerHandle = function(nScannerIndex: Integer; out phScanner: THUFScanner): Integer; stdcall;
  TUFS_SetParameter = function(phScanner: THUFScanner; nParam: Integer; pValue: PVariant): Integer; stdcall;
  TUFS_SetTemplateType = function(phScanner: THUFScanner; nTemplateType: Integer): Integer; stdcall;
  TUFS_UFS_ClearCaptureImageBuffer = function(phScanner: THUFScanner): Integer; stdcall;
  TUFS_CaptureSingleImage = function(phScanner: THUFScanner): Integer; stdcall;
  TUFS_Extract = function(hScanner: THUFScanner; var pTemplate: Byte; var pnTemplateSize: Integer; var pnEnrollQuality: Integer): Integer; stdcall;
  TUFM_Create = function (var hMatcher: THUFMatcher): Integer; stdcall;
  TUFM_Identify = function(hMatcher: THUFMatcher; pTemplate1: PByte; nTemplate1Size: Integer;  ppTemplate2: TArrayArrayByte; pnTemplate2Size: TArrayInteger;
                           nTemplate2Num: Integer; nTimeout: Integer; pnMatchTemplate2Index: Integer): Integer; stdcall;
  TUFM_Delete = function (hMatcher: THUFMatcher): Integer; stdcall;

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
    Lc_Template: Array[0..384 - 1] of Byte; // represent the fingerprints as an Array of Bytes
//    FByteArray: Array of Array[0..384 - 1] of Byte;
//    FByteCntList: TList<Integer>;

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
    Exec_TUFS_Update: TUFS_Update;

    function UFS_Init: Boolean; //UFS_Init()
    function UFS_Update: Boolean; // UFS_Update()
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
//    function AddData(AQuery: TUniQuery): Boolean; overLoad;

    property ScannerDLL: THandle read FScannerDLL write FScannerDLL;
    property MatcherDLL: THandle read FMatcherDLL write FMatcherDLL;
  end;

implementation

uses
  uGlobal, fx.Logging, Form.Full.Popup, uStruct;

{ TBioMiniPlus2 }

function TBioMiniPlus2.AddData: Boolean;
begin
  try
    Result := False;

    if not UFS_Update then
      Exit;

    if not UFS_GetScannerHandle then
      Exit;

    if not UFS_SetParameter then
      Exit;

    if not UFS_SetTemplateType then
      Exit;

//    if not UFS_ClearCaptureImageBuffer then
//      Exit;

    if not UFS_CaptureSingleImage then
      Exit;

    if not UFS_Extract then
      Exit;

    Result := True;
  finally
//    UFS_Uninit;
  end;
end;

//function TBioMiniPlus2.AddData(AQuery: TUniQuery): Boolean;
//var
//  Index, Loop: Integer;
//begin
//  if AQuery.RecordCount <> 0 then
//  begin
////    ZeroMemory(@FByteArray, Length(FByteArray));
////    SetLength(FByteArray, AQuery.RecordCount);
////
////    FByteCntList.Clear;
////    FByteCntList.Count := 0;
////
////    for Index := 0 to AQuery.RecordCount - 1 do
////    begin
////      for Loop := 0 to AQuery.FieldByName('TemplateSize').AsInteger - 1 do
////        FByteArray[Index][Loop] := AQuery.FieldByName('Template').AsBytes[Loop];
////
////      FByteCntList.Add(AQuery.FieldByName('TemplateSize').AsInteger);
////      AQuery.Next;
////    end;
//  end;
//end;

constructor TBioMiniPlus2.Create;
begin
  IsAdd := False;
  ScannerDLL := LoadLibrary('UFScanner.dll');
  MatcherDLL := LoadLibrary('UFMatcher.dll');
  if InitDevice then
    if not UFS_Init then
      Exit;
//  FByteCntList := TList<Integer>.Create;
end;

destructor TBioMiniPlus2.Destroy;
begin
//  FreeLibrary(ScannerDLL);
//  Freelibrary(MatcherDLL);
//  FByteCntList.Free;
  inherited;
end;

function TBioMiniPlus2.GetMemberIndex: Integer;
begin
  try
    try
      Result := -100;

//      if not UFS_Init then
//        Exit;

      if not UFS_Update then
      begin
        Log.E('UFS_Update', 'Error');
        Exit;
      end;

      if not UFS_GetScannerHandle then
      begin
        Log.E('UFS_GetScannerHandle', 'Error');
        Exit;
      end;

      if not UFS_SetParameter then
      begin
        Log.E('UFS_SetParameter', 'Error');
        Exit;
      end;

      if not UFS_SetTemplateType then
      begin
        Log.E('UFS_SetTemplateType', 'Error');
        Exit;
      end;


//      if not UFS_ClearCaptureImageBuffer then
//      begin
//        Result := -1;
//        Exit;
//      end;

      if not UFS_CaptureSingleImage then
      begin
        Log.E('UFS_CaptureSingleImage', 'Error');
        Result := -2;
        Exit;
      end;

//      Application.ProcessMessages;
//      FullPopup.FormMessage;

      if not UFS_Extract then
      begin
        Log.E('UFS_Extract', 'Error');
        Result := -3;
        Exit;
      end;

      if not UFM_Create then
      begin
        Log.E('UFM_Create', 'Error');
        Result := -4;
        Exit;
      end;

      if not UFM_Verify(Result) then
      begin
        Log.E('UFM_Verify', 'Error');
        Result := -5;
        UFM_Delete;
        Exit;
      end;

      if not UFM_Delete then
        Exit;

  //    Result := 1;
    finally
//      UFS_Uninit;
//      FullPopup.FormMessage(False);
    end;
  except
    on E: Exception do
    begin
//      Global.SBMessage.ShowMessageModalForm('asdasd - ' + E.Message);
    end;
  end;
end;

function TBioMiniPlus2.InitDevice: Boolean;
begin
  Result := False;
  if not ExecGetProcAddress then
    Exit;

//  if not UFS_Init then
//    Exit;
//
//  if not UFS_GetScannerHandle then
//    Exit;
//
//  if not UFS_SetParameter then
//    Exit;
//
//  if not UFS_SetTemplateType then
//    Exit;

  Result := True;
end;

function TBioMiniPlus2.UFS_Init: Boolean;
begin
  Result := Exec_TUFS_Init = 0;
end;

function TBioMiniPlus2.UFS_Update: Boolean;
begin
  Result := Exec_TUFS_Update = 0;
end;

function TBioMiniPlus2.UFS_GetScannerHandle: Boolean;
begin
  Result := Exec_TUFS_GetScannerHandle(0, FDeviceHandle) = 0;
end;

function TBioMiniPlus2.UFS_SetParameter: Boolean;
var
  AValue: Integer;
  ABool: Boolean;
begin
  Result := False;
  AValue := 5000;
  if Exec_TUFS_SetParameter(FDeviceHandle, 201, @AValue) = 0 then // 201 UFS_PARAM_TIMEOUT
  begin
    AValue := 1024;
    if Exec_TUFS_SetParameter(FDeviceHandle, 302, @AValue) = 0 then  // 302 UFS_PARAM_TEMPLATE_SIZE
    begin
      ABool := False; // True > False
      Result := Exec_TUFS_SetParameter(FDeviceHandle, 301, @ABool) = 0;

      if (Global.Config.Sensitivity >= 0) and (Global.Config.Sensitivity <= 7) then
      begin
//        AValue := Global.Config.Sensitivity;  // 203 UFS_PARAM_SENSITIVITY Sensitivity (0 ~ 7); Higher value means more sensitive Default 4
//        Result := Exec_TUFS_SetParameter(FDeviceHandle, 203, @AValue) = 0;
      end;
    end;
  end;
end;

function TBioMiniPlus2.UFS_SetTemplateType: Boolean;
begin
  Result := Exec_TUFS_SetTemplateType(FDeviceHandle, 2001) = 0;
end;

function TBioMiniPlus2.UFS_ClearCaptureImageBuffer: Boolean;
var
  a: Integer;
begin
  a := Exec_TUFS_UFS_ClearCaptureImageBuffer(FDeviceHandle);
  Result := a = 0;
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

   ZeroMemory(@Lc_Template, 384);
   Exec_TUFS_Extract(FDeviceHandle, Lc_Template[0], Lc_TemplateSize, Quality);
   Global.SaleModule.FingerStr := EncdDecd.EncodeBase64(@Lc_Template[0], Lc_TemplateSize);
//   Log.D('지문', Global.SaleModule.FingerStr);
   if True then
   begin
//     Global.SaleModule.FingerStr := StringReplace(Global.SaleModule.FingerStr, '''#$D#$A''', '(테스트문자)', [rfReplaceAll]);
//     FingerStr :=
//     SetLength(FByteArray, Length(FByteArray) + 1);
//     for Index := 0 to Lc_TemplateSize - 1 do
//       FByteArray[FByteCntList.Count][Index] := TemplateByteArray[Index];
//
//     FByteCntList.Add(Lc_TemplateSize);
   end;
   Result := True;
end;

function TBioMiniPlus2.UFM_Create: Boolean;
begin
  Result := Exec_TUFM_Create(FDeviceMatch) = 0;
end;

function TBioMiniPlus2.UFM_Identify: Boolean;
var
  ACheck: Integer;  //jangheejin 2020.01.15
  Aa: TArrayArrayByte;
  aaa: TArrayInteger;
begin
  Exit;
  SetLength(aa, 100);

  aa[0][0] := Global.SaleModule.MemberUpdateList[0].Finger[0];
  aa[1][0] := Global.SaleModule.MemberUpdateList[0].Finger[0];
  aa[2][0] := Global.SaleModule.MemberUpdateList[0].Finger[0];
  aa[3][0] := Global.SaleModule.MemberUpdateList[0].Finger[0];
  aa[4][0] := Global.SaleModule.MemberUpdateList[0].Finger[0];

  Result := Exec_TUFM_Identify(FDeviceMatch, Lc_pTemplateBuffer, Lc_TemplateSize, Aa, aaa, 13, 5000, ACheck) = 0;
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
  ABytes: TBytes;
  AMember: TMemberInfo;
begin
  try
    Result := False;
  //  for Index := 0 to Length(FByteArray) - 1 do
  //  begin
  //    ZeroMemory(@TemplateByte, Length(TemplateByte));
  //    for Loop := 0 to FByteCntList[Index] - 1 do
  //      TemplateByte[Loop] := FByteArray[Index][Loop];
  //    IResult := Exec_TUFM_Verify(FDeviceMatch, TemplateByteArray[0], Lc_TemplateSize, TemplateByte[0], FByteCntList[Index], ACheck);
  //    if ACheck = 1 then
  //    begin
  //      AMatchIndex := Index;
  //      Result := True;
  //      Break;
  //    end;
  //  end;
    if not Result then
    begin
      for Index := 0 to Global.SaleModule.MemberUpdateList.Count - 1 do
      begin
        if not Global.SaleModule.MemberUpdateList[Index].Use then
          Continue;

        if (Global.SaleModule.MemberUpdateList[Index].FingerStr = EmptyStr) then
          Continue;

//        ZeroMemory(@TemplateByte, Length(TemplateByte));
//        for Loop := 0 to Length(Global.SaleModule.MemberUpdateList[Index].Finger) - 1 do
//          TemplateByte[Loop] := Global.SaleModule.MemberUpdateList[Index].Finger[Loop];
//
//        IResult := Exec_TUFM_Verify(FDeviceMatch, Lc_Template[0], Lc_TemplateSize,
//                                                TemplateByte[0], Length(TemplateByte),
//                                                ACheck);

        AMember := Global.SaleModule.MemberUpdateList[Index];
        IResult := Exec_TUFM_Verify(FDeviceMatch, Lc_Template[0], Lc_TemplateSize,
                                                  AMember.Finger[0], Length(AMember.Finger),
                                                  ACheck);
        if ACheck = 1 then
        begin
          AMatchIndex := Index;
          Global.SaleModule.Member := Global.SaleModule.MemberUpdateList[Index];
          Log.D('Member Search BioMini2 MemberUpdateList Count : ', IntToStr(Global.SaleModule.MemberUpdateList.Count));
          Log.D('BioMini2', 'MemberUpdateList', Global.SaleModule.Member.Name + ':' + Global.SaleModule.Member.Code);
          Result := True;
          Break;
        end;
      end;
    end;

    if not Result then
    begin
      for Index := 0 to Global.SaleModule.MemberList.Count - 1 do
      begin
        if not Global.SaleModule.MemberList[Index].Use then
          Continue;

        if (Global.SaleModule.MemberList[Index].FingerStr = EmptyStr) then
          Continue;

//        ZeroMemory(@TemplateByte, Length(TemplateByte));
//        for Loop := 0 to Length(Global.SaleModule.MemberList[Index].Finger) - 1 do
//          TemplateByte[Loop] := Global.SaleModule.MemberList[Index].Finger[Loop];
//        IResult := Exec_TUFM_Verify(FDeviceMatch, Lc_Template[0], Lc_TemplateSize,
//                                                TemplateByte[0], Length(TemplateByte),
//                                                ACheck);

        AMember := Global.SaleModule.MemberList[Index];
        IResult := Exec_TUFM_Verify(FDeviceMatch, Lc_Template[0], Lc_TemplateSize,
                                                  AMember.Finger[0], Length(AMember.Finger),
                                                  ACheck);
        if ACheck = 1 then
        begin
          AMatchIndex := Index;
          Global.SaleModule.Member := Global.SaleModule.MemberList[Index];
          Log.D('Member Search BioMini2 MemberList Count : ', IntToStr(Global.SaleModule.MemberList.Count));
          Log.D('BioMini2', 'MemberList', Global.SaleModule.Member.Name + ':' + Global.SaleModule.Member.Code);
          Result := True;
          Break;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Log.E('UFM_Verify Exception', E.Message);
    end;
  end;
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

//  @Exec_TUFS_UnInit := GetProcAddress(ScannerDLL, 'UFS_UnInit');
//  if not Assigned(@Exec_TUFS_UnInit) then
//  begin
//    // Log
//    Exit;
//  end;

  @Exec_TUFS_Update := GetProcAddress(ScannerDLL, 'UFS_Update');
  if not Assigned(@Exec_TUFS_Update) then
  begin
    // Log
    Exit;
  end;

  Result := True;
end;

end.
