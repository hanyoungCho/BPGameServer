unit Common.BPCommonLib;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils, System.StrUtils, System.JSON,
  Vcl.Controls, Vcl.Graphics, Vcl.Forms, System.Win.Registry, Vcl.Imaging.Jpeg, Vcl.ExtCtrls,
  Vcl.ComCtrls, Data.DB, System.NetEncoding, Winapi.TlHelp32,
  { Indy }
  IdIPWatch,
  { Project }
  nxlsa, DelphiZXIngQRCode;

const
  CONST_WM_SEND_MOUSE = WM_USER + 5000;
  CONST_BCD: array[0..15] of string = ( '0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111');

  CONST_IF_UNKNOWN  = -1;
  CONST_IF_BITMAP   = 0;
  CONST_IF_JPEG     = 1;
  CONST_IF_PNG      = 2;
  CONST_IF_GIF      = 3;

type
  TArrayOfByte = array of Byte;

  PMSLLHOOKSTRUCT = ^MSLLHOOKSTRUCT;
  MSLLHOOKSTRUCT = packed record
    pt: TPoint;
    mouseData: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;

  { WM_COPYDATA 메시지 구조 }
  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct = record
    dwData: DWORD;
    cbData: DWORD;
    lpData: Pointer;
  end;

  { 한영 IME 모드 }
  TImeMode = (imEnglish, imKorean);

  TSkinItem = record
    FileName: string;
    Width: Integer;
    Height: Integer;
    Stretch: Boolean;
  end;

  TSkinData = record
    GroupCode: string;
    Normal: TSkinItem;
    Pressed: TSkinItem;
    Disabled: TSkinItem;
  end;

  TSkinInfo = record
    Version: string;
    Preview: string;
    Background: string;
    Items: array of TSkinData
  end;

  TCondition<V> = class
  public
    class function &if(const ACondition: Boolean; const ATrueValue, AFalseValue: V): V; static;
  end;

//IfThen() 개선 함수
function IIF(const AIsTest: Boolean; const ATrueValue, AFalseValue: Variant): variant;
//운영체제에 로그인한 사용자명
function GetCurrentUserName: string;
//사이즈가져오기
function GetFileSize(const AFileName: string): Integer;
//MB단위로 파일 사이즈 구하기
function GetFileSizeMB(const AFileName: string): Int64;
//MB단위로 이미지 파일 사이즈 및 Width, Height 구하기
function GetImageFileSizeMB(const AFileName: string; var AWidth: integer; var AHeight: integer): int64;
//지정한 폴더 내의 파일목록 추출
function GetFileList(const APath: string; var AFileList: TStringList): integer; overload;
function GetFileList(const APath: string; AFilters: string; var AFileList: TStringList): integer; overload;
//윈도우 컨트롤을 비트맵 객체로 저장
function WinControlToImage(AWinControl: TWinControl; AImage: TGraphic; const APixelFormat: byte=16): integer;
//스크롤 가능한 윈도우 컨트롤을 비트맵 객체로 저장
function WinScrollControlToImage(AWinControl : TScrollingWinControl; ABitmap: TBitmap; const APixelFormat: byte=16): integer;
//비트맵을 RTF 형식으로 변환
function BitmapToRTF(ABitmap: TBitmap): string;
//윈도우 컨트롤을 프린터로 출력
procedure WinControlToPrint(AParentForm: TForm; AControl: TWinControl; const AIsLandscape: Boolean=False);
//비트맵을 캔버스로 내보내기
procedure BitmapToCanvas(Canvas: TCanvas; DestRect: TRect; BMP: TBitmap);
//비크맵 객체를 프린터로 출력
procedure BitmapToPrint(BMP: TBitmap; const AIsLandscape: Boolean=false);
//비트맵 객체를 이미지 파일로 저장
//AImageFormat = wifBmp, wifJpeg, wifPng
//APixelFormat = 1, 4, 8, 16, 24, 32 (단, jpeg는 8과 24만 가능)
function SaveImageToFile(const AFileName: string; AImage: TGraphic; AImageFormat: TWICImageFormat=wifJpeg; const APixelFormat: byte=16; const AJpegCompressionQuality: integer=70): integer;
//비트맵 객체를 Jpeg형식의 이미지 파일로 저장
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic): integer; overload;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: byte=16): integer; overload;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: byte=16; const AJpegCompressionQuality: integer=70): integer; overload;
//비트맵 자르기
procedure CropBitmap(AInputBitmap, AOutputBitMap: TBitmap; const AStartX, AStartY, AWidth, AHeight: Integer);
//비트맵 객체를 지정한 크기로 변경
//procedure ResizeBitmap(ABitmap: TBitmap; const ANewWidth, ANewHeight: integer);
procedure ResizeBitmap(ABitmap: TBitmap; const AWidth, AHeight: Integer; ABackgroundColor: TColor);
//지정한 날짜에 속하는 달의 마지막 일을 구한다.
function GetLastDayOfMonth(const ADateTime: TDateTime): shortint;
//문자열(WideSring & AnsiString)의 Bytes 단위의 크기를 구한다.
function StrLength(const AText: string): integer;
//지정한 길이만큼 문자열의 왼쪽을 채움
function LeftPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
//지정한 길이만큼 문자열의 오른쪽을 채움
function RightPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
//문자열의 끝에 Slash 강제 삽입
function IncludeTrailingSlash(const AText: string): string;
//문자열의 끝에 Slash 강제 제거
function ExcludeTrailingSlash(AText: string): string;
//문자열에서 숫자형만 반환함
function GetNumStr(const AValue: String): string;
//요일명 반환
function DayOfWeekName(const ADate: TDate): string; overload;
function DayOfWeekName(const ADate: TDate; const AHanja: Boolean): string; overload;
//로컬 시각 변경
function ChangeSystemTime(const ADateTime: TDateTime): Boolean;
//Bitmap을 이용하여 문자열의 Display Width와 Height를 픽셀 단위로 구한다.
procedure GetTextPixelSize(const AText: string; AFont: TFont; var AWidth, AHeight: integer);
//Null 처리 함수:ORACLE의 NVL()과 동일
function NVL(const ATestValue, ANewValue: Variant): Variant;
//인자값이 null인지 확인
function IsNull(const AValue: Variant): Boolean;
// OleVarian를 Stream으로 변환
function OleVariantToStream (AOleValue: OleVariant): TMemoryStream;
// Stream을 OleVarian로 변환
function StreamToVariant(AStream: TStream): OleVariant;
//IME 한글 입력모드 검사
function IsHanState: Boolean;
//IME 입력모드 변경 ※한글:SetIMEMode(imKorean), 영문:SetIMEMode(imEnglish)
procedure SetIMEMode(const AImeMode: TImeMode);
//NumLock, CapsLock, ScrollLock 상태 읽기
function GetKeybdState(const AKeyCode: integer): Boolean;
//NumLock, CapsLock, ScrollLock 상태 변경
procedure SetKeybdState(const AKeyCode: integer; const AIsOn: Boolean);
//가상 키보드 입력 처리
procedure SimulateKeyDown(AVirtualKey: Byte);
procedure SimulateKeyUp(AVirtualKey: Byte);
procedure SimulateKeyWithShift(AVirtualKey: Byte); overload;
procedure SimulateKeyWithShift(AVirtualKey, AShiftKey: Byte); overload;
procedure SimulateKey(AVirtualKey: Byte);
//키보드 후킹
function  KeybdHookHookCallback(ACode: integer; wParam: WPARAM; lParam: LPARAM): NativeInt; stdcall;
procedure KeybdHookStart;
procedure KeybdHookStop;
//마우스 후킹
procedure MouseHookStart(const AHandle: THandle);
procedure MouseHookStop;
function MouseHookHookCallBack(ACode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
//Sleep() 대체 함수
procedure SleepEx(const AMSecs: LongInt);
procedure Delay(const AMSecs: LongInt);
//텍스트 파일 생성 및 기록
procedure WriteToFile(const AFileName, AStr: string; const ANewFile: Boolean=False);
//애플리케이션 버전 정보 추출
function GetAppVersion(const AIndex: Integer): string;
//DLL등의 모듈 파일 버전 정보 추출
function GetModuleVersion(const AFileName: string): string;
//사용 가능한 모든 컨트롤에 DoubleBuffered 적용
procedure SetDoubleBuffered(AControl: TWinControl; const ADoubleBuffered: Boolean);
//Check Existing File(64bit)
function FileExists64(const AFileName: string): Boolean;
//Check 64bit Windows
function IsWin64: Boolean;

//조회용 신용카드번호
function GetHideCreditCardNo(const ACreditCardNo: string): string;
//데이터 추가 후에 CalcField 가 바로 반영되지 않는 버그 패치용
procedure RefreshCalcField(ADataSet: TDataSet);
//yyyymmdd 형식의 날짜를 yyyy-mm-dd 형식으로 반환
function FormattedDateString(const ADateString: string): string;
//hhnnss 형식의 시각을 hh:nn:ss 형식으로 반환
function FormattedTimeString(const ATimeString: string): string;
//유닉스 시각을 문자열로 변환
function UnixTimeToString(const AUnixTime: string; const AFormatStr: string): string;
//특수문자 제거
function RemoveSpecialChar(const ASource: string): string;
//레지스트리에서 시작 프로그램으로 등록하기
procedure RunOnWindownStart(const AppTitle, AppFile: string; const ARunOnce: Boolean=False);
//레지스트리에서 시작 프로그램에서 제거하기
function RemoveFromRunOnWindowStart(const AppTitle: string): Boolean;
//윈도우 시스템 종료
procedure SystemShutdown(const ATimeOut: DWORD; const AForceClose, AReboot: Boolean);
//지정한 Window를 최상위로 표시함
procedure SetWindowOnTop(const AHandle: HWND);
procedure SetWindowOnTop2(const AHandle: HWND);
//관리자 권한으로 프로그램 실행
function RunAsAdmin(const AHandle: HWND; const APath, AParams: string): Boolean;
//시스템 디렉터리 구하기
function GetSysDir: string; overload;
function GetSysDir(const AFloder: Integer): string; overload;
//WM_COPYDATA 문자열 전송
procedure CopyDataString(const AHandle: HWND; const AMsg: Cardinal; const AData: string);

(***
//스킨 관련 함수
function GetSkinInfo(const ASkinFile, APassword, ASkinType: string; var ASkinInfo: TSkinInfo;
  var AFileList: TStringList; var AConfig: TStream; var AErrMsg: string): Boolean;
function GetStreamOfSkin(const ASkinFile, APassword, AFileNameInArchive: string;
  var AStream: TStream; var AErrMsg: string): Boolean;
function GetItemInfoOfSkin(AConfig: TStream; const ASkinType, AGroupID, ANodeName: string;
  var ASkinItem: TSkinItem; var AErrMsg: string): Boolean;

//이미지 관련 함수
function StreamToPicture(AStream: TStream; APicture: TPicture; var AErrMsg: string): Boolean;
function StreamToImageList(AStream: TStream; const AWidth, AHeight: integer;
  AImageList: TcxImageList; var AErrMsg: string): Boolean;
function GetImageFormat(AFileName: string): shortint; overload;
function GetImageFormat(AStream: TStream): shortint; overload;
***)

{ Imported from GlobalFunctions }

//암호화, 복호화
function StrEncrypt(const AStr: AnsiString): AnsiString;
function StrDecrypt(const AStr: AnsiString): AnsiString;
const
  C_SEED_KEY1 = 51637; //53761;
  C_SEED_KEY2 = 38126; //32618;
function StrEncryptEx(const ADecrypt: WideString; AKey: Word): string;
function StrDecryptEx(const AEncrypt: string; AKey: Word): string;
//문자열 처리
function LPadB(const AStr: string; ALength: Integer): string;
function RPadB(const AStr: string; ALength: Integer): string;
function PadChar(ALength: Integer; APadChar: Char = ' '): string;
function SCopy(const AText: string; const AByteStart, AByteCount: Integer): string;
function ByteLen(const AText: string): Integer;

function Base64Encode(const AData: string; const AConvertUTF8: Boolean=False): string;
function Base64EncodeA(const AData: string; const AConvertUTF8: Boolean=False): string;
function Base64Decode(const AData: string): string;
function Base64EncodeStream(const AStream: TStream): string;
function Base64DecodeStream(const AStream: TStream): string;
function Base64EncodeGraphic(AImage: TGraphic): string;
function Base64EncodeFile(const AFileName: string): string;

function BCC(const AValue: AnsiString): string;
function LRC(const AValue: AnsiString; const ACheckLen: Integer=0): Byte;

function BinBytesToString(const AValue: array of Byte): string;
function BinStringToInteger(const AValue: string): Integer;
function IntegerToHexaString(const AValue, ADigits: Integer): string;
function StringToBinString(const AValue: string): string;
function StringToHexaString(const AValue: string): string;
function HexaStringToString(const AValue: string): string;
function HexaStringToBinString(const AValue: string): string;
function BytesToHexaString(const ABytes: TBytes): string;
function StringToBytes(const AValue: WideString): TBytes;
function BytesToString(const AValue: TBytes): WideString;
function StringToArrayOfByte(const AValue: AnsiString): TArrayOfByte;
function ArrayOfByteToString(const AValue: TArrayOfByte): string;

//유휴상태 지속시간(초) 구하기
function GetIdleSeconds: DWORD;
//라운디드 컨트롤
function MakeRoundedControl(AControl: TWinControl; const AEllipseWidth: Integer=10; const AEllipseHeight: Integer=10): Boolean;
//투명 패널
procedure TransparentPanel(var APanel: TPanel);
//QR바코드 생성
function GenerateQRCode(ABitmap: TBitmap; const AText: string; const AScale, AEncodingMethod, AQuietZone: Integer; var AErrMsg: string): Boolean;
//JSON 객체 메모리 해제
procedure FreeAndNilJSONObject(AObject: TJSONAncestor);
//실행파일명으로 프로세스 ID 구하기
function GetProcessId(const AFilePath: string): NativeInt;
//실행파일명으로 프로세스 핸들 구하기
function GetProcessHandle(const AFilePath: string): NativeInt;
//프로세스 강제 종료
function KillProcess(const AProcName: string): Boolean;
function KillProcessByHandle(const AHandle: NativeInt): Boolean;
function KillProcessByPID(const AProcessId: NativeInt): Boolean;
//보색 구하기
function InvertColor(const Color: TColor): TColor;
function InvertColor2(const Color: TColor): TColor;
//현재 사용 중인 메모리 크기 구하기 (FastMM5 유닛을 추가해야 정상적인 값을 반환함.)
function GetMemoryUsed: UInt64;
//이미지 사이즈 구하기
function ReadMWord(FS: TFileStream): Word;
procedure GetJpgSize(const AFileName: string; var AWidth, AHeight: Integer);
procedure GetPngSize(const AFileName: string; var AWidth, AHeight: Integer);
//ListView 순서 바꾸기
procedure ExchangeListItems(AListView: TListView; const AIndex1, AIndex2: Integer);

implementation

uses
  { Native }
  Winapi.Imm, Winapi.ShellAPI, Winapi.ShFolder, Soap.EncdDecd, System.Variants, System.Math,
  System.DateUtils, Vcl.Printers, Vcl.Imaging.PngImage,
  { Indy }
  IdCoderMIME;

var
  SBGlobal_KeybdHook: HHook; //키보드 후킹
  SBGlobal_MouseHook: HHook; //마우스 후킹
  SBGlobal_MouseThisHandle: THandle;

//LString := TCondition<string>.if(조건, '참', '거짓');
//LInteger := TCondition<Integer>.if(조건, 100, 200);
class function TCondition<V>.&if(const ACondition: Boolean; const ATrueValue, AFalseValue: V): V;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

//IfThen() 개선 함수
function IIF(const AIsTest: Boolean; const ATrueValue, AFalseValue: Variant): Variant;
begin
  if AIsTest then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

//운영체제에 로그인한 사용자명
function GetCurrentUserName: string;
var
  pUserName: PChar;
  dwSize: DWORD;
begin
  Result := '';
  dwSize := 250;
  GetMem(pUserName, dwSize);
  try
    GetUserName(pUserName, dwSize);
    Result := StrPas(pUserName);
  finally
    FreeMem(pUserName);
  end;
end;

//GetFileSize
function GetFileSize(const AFileName: string): Integer;
var
  H: THandle;
  WFD: TWin32FindData;
begin
  H := FindFirstFile(pchar(AFileName), WFD); // 파일의 정보를 읽는다
  Result := Round((WFD.nFileSizeHigh * MAXDWORD) + WFD.nFileSizeLow);
  Winapi.Windows.FindClose(H);
end;

//MB단위로 파일 사이즈 구하기
function GetFileSizeMB(const AFileName: string): Int64;
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := FS.Size div 1024000;
  finally
    FreeAndNil(FS);
  end;
end;

//MB단위로 이미지 파일 사이즈 및 Width, Hieght 구하기
function GetImageFileSizeMB(const AFileName: string; var AWidth: integer; var AHeight: integer): int64;
var
  PIC: TPicture;
begin
  PIC := TPicture.Create;
  try
    AWidth := PIC.Width;
    AHeight := PIC.Height;
    Result := GetFileSizeMB(AFileName);
  finally
    FreeAndNil(PIC);
  end;
end;

//지정한 폴더 내의 파일목록 추출
function GetFileList(const APath: string; var AFileList: TStringList): integer;
begin
  Result := GetFileList(APath, '', AFileList);
end;
function GetFileList(const APath: string; AFilters: string; var AFileList: TStringList): integer;
var
  SR: TSearchRec;
  sFileExt: string;
begin
  try
    AFilters := LowerCase(AFilters);
    try
      if (FindFirst(APath + '*.*', faAnyFile - faDirectory, SR) = 0) then
      begin
        repeat
          if (AFilters <> EmptyStr) then
          begin
            sFileExt := LowerCase(StringReplace(ExtractFileExt(SR.Name), '.', '', [rfReplaceAll]));
            if (Pos(sFileExt, AFilters) > 0) then
              AFileList.Add(APath + SR.Name);
          end
          else
            AFileList.Add(APath + SR.Name);
        until FindNext(SR) <> 0;
      end;
      FindClose(SR);
    except
      AFileList.Clear;
      raise;
    end;
  finally
    Result := AFileList.Count;
  end;
end;

//윈도우 컨트롤을 비트맵 객체로 저장)
function WinControlToImage(AWinControl: TWinControl; AImage: TGraphic; const APixelFormat: byte): integer;
var
  BMP: TBitmap;
  CDC: HDC;
begin
  if not AWinControl.HandleAllocated then
  begin
    Result := -2; //캡쳐할 수 없는 개체
    Exit;
  end;

  CDC := GetWindowDC(AWinControl.Handle);
  BMP := TBitmap.Create;
  try
    try
      BMP.SetSize(AWinControl.Width, AWinControl.Height);
      case APixelFormat of
        1: BMP.PixelFormat := pf1bit;
        4: BMP.PixelFormat := pf4bit;
        8: BMP.PixelFormat := pf8bit;
        24: BMP.PixelFormat := pf24bit;
        32: BMP.PixelFormat := pf32bit;
      else
        BMP.PixelFormat := pf16bit; //기본값:16비트
      end;

      BitBlt(BMP.Canvas.Handle, 0, 0, BMP.Width, BMP.Height, CDC, 0, 0, SRCCOPY);
      AImage.Assign(BMP);
      Result := 0; //성공
    except
      on e: Exception do
        Result := GetLastError;
    end;
  finally
    FreeAndNil(BMP);
    ReleaseDC(AWinControl.Handle, CDC);
  end;
end;

//스크롤 가능한 윈도우 컨트롤을 비트맵 객체로 저장
function WinScrollControlToImage(AWinControl : TScrollingWinControl; ABitmap: TBitmap; const APixelFormat: byte): integer;
var
  hScrDC, hMemDC: HDC;
  hBMP, hOldBMP: HBITMAP;
  nWidth, nHeight: integer;
  nOldScrollPosHori, nOldScrollPosVert: integer;
  nPosHori, nPosVert: integer;
  nSrcPosX, nSrcPosY: integer;
  nDestPosX, nDestPosY: integer;
begin
  if ((not AWinControl.HandleAllocated) or //캡쳐할 수 없는 개체
      (AWinControl.Visible = False) or
      (AWinControl.Width = 0) or
      (AWinControl.Height = 0 )) then
  begin
    Result := -2;
    Exit;
  end;

  try
    try
      nOldScrollPosHori := AWinControl.HorzScrollBar.Position;
      nOldScrollPosVert := AWinControl.VertScrollBar.Position;
      hScrDC := GetDC(AWinControl.Handle);
      hMemDC := CreateCompatibleDC(hScrDC);
      hBMP := CreateCompatibleBitmap(hScrDC, AWinControl.HorzScrollBar.Range, AWinControl.VertScrollBar.Range);
      hOldBMP := SelectObject(hMemDC, hBMP);

      nPosVert := 0;
      nSrcPosY := 0;
      nDestPosY := 0;
      nHeight := AWinControl.ClientHeight;
      while (nDestPosY < AWinControl.VertScrollBar.Range) do
      begin
        nPosHori := 0;
        nSrcPosX := 0;
        nDestPosX := 0;
        nWidth := AWinControl.ClientWidth;
        AWinControl.VertScrollBar.Position := nPosVert;

        while (nDestPosX < AWinControl.HorzScrollBar.Range) do
        begin
          AWinControl.HorzScrollBar.Position := nPosHori;
          AWinControl.Repaint;

          BitBlt(hMemDC, nDestPosX, nDestPosY, nWidth, nHeight, hScrDC, nSrcPosX, nSrcPosY, SRCCOPY);

          nDestPosX := (nDestPosX + nWidth);
          if ((AWinControl.HorzScrollBar.Range - nPosHori - AWinControl.ClientWidth) < AWinControl.ClientWidth) then
          begin
            nWidth := (AWinControl.HorzScrollBar.Range  - nPosHori - AWinControl.ClientWidth);
            nSrcPosX := (AWinControl.ClientWidth - nWidth);
            nPosHori := (nPosHori + nWidth);
          end
          else
            nPosHori := (nPosHori + AWinControl.ClientWidth);
        end;

        nDestPosY := (nDestPosY + nHeight);
        if ((AWinControl.VertScrollBar.Range - nPosVert - AWinControl.ClientHeight) < AWinControl.ClientHeight ) then
        begin
          nHeight := (AWinControl.VertScrollBar.Range  - nPosVert - AWinControl.ClientHeight);
          nSrcPosY := (AWinControl.ClientHeight - nHeight);
          nPosVert := (nPosVert + nHeight);
        end
        else
          nPosVert := (nPosVert + AWinControl.ClientHeight);
      end;

      case APixelFormat of
        1: ABitmap.PixelFormat := pf1bit;
        4: ABitmap.PixelFormat := pf4bit;
        8: ABitmap.PixelFormat := pf8bit;
        24: ABitmap.PixelFormat := pf24bit;
        32: ABitmap.PixelFormat := pf32bit;
      else
        ABitmap.PixelFormat := pf16bit; //기본값:16비트
      end;

      ABitmap.Handle := hBMP;
      SelectObject(hMemDC, hOldBMP);

      Result := 0; //성공
    finally
      DeleteDC(hMemDC);
      DeleteDC(hScrDC);
      ReleaseDC(AWinControl.Handle, hScrDC);

      AWinControl.HorzScrollBar.Position := nOldScrollPosHori;
      AWinControl.VertScrollBar.Position := nOldScrollPosVert;
    end;
  except
    on E: Exception do
      Result := GetLastError;
  end;
end;

//비트맵을 RTF 형식으로 변환
function BitmapToRTF(ABitmap: TBitmap): string;
var
  sHeader, sBody: AnsiString;
  nHeaderSize, nBodySize: cardinal;
begin
  GetDIBSizes(ABitmap.Handle, nHeaderSize, nBodySize);
  SetLength(sHeader, nHeaderSize);
  SetLength(sBody, nBodySize);
  GetDIB(ABitmap.Handle, ABitmap.Palette, PAnsiChar(sHeader)^, PAnsiChar(sBody)^);
  for var I: Integer := 1 to nHeaderSize do
    Result := Result + IntToHex(Integer(sHeader[I]), 2);
  for var I := 1 to nBodySize do
    Result := Result + IntToHex(Integer(sBody[I]), 2);
  Result := '\line {\rtf1 {\pict \dibitmap ' + Result + '}}'#13#10;
end;

//윈도우 컨트롤을 프린터로 출력
procedure WinControlToPrint(AParentForm: TForm; AControl: TWinControl; const AIsLandscape: Boolean);
var
  BMP: TBitmap;
  nFromLeft, nFromTop, nPrnWidth, nPrnHeight: integer;
begin
  if AIsLandscape then
    Printer.Orientation := poLandscape
  else
    Printer.Orientation := poPortrait;

  Printer.BeginDoc;
  try
    BMP := TBitmap.Create;
    try
      BMP.Width := AControl.Width;
      BMP.Height := AControl.Height;
      BMP.PixelFormat := pf24bit;
      BMP.Canvas.CopyRect(
        Rect(0, 0, BMP.Width, BMP.Height), AParentForm.Canvas,
          Rect(AControl.Left, AControl.Top, AControl.Left + AControl.Width, AControl.Top + AControl.Height));

      nPrnWidth  := MulDiv(Printer.PageWidth, 94, 100); //94%
      nPrnHeight := MulDiv(nPrnWidth, BMP.Height, BMP.Width);
      nFromLeft  := MulDiv(Printer.PageWidth, 3, 100);  //3%
      nFromTop   := MulDiv(Printer.PageHeight, 3, 100); //3%

      BitmapToCanvas(Printer.Canvas, Rect(nFromLeft, nFromTop, nFromLeft + nPrnWidth, nFromTop  + nPrnHeight), BMP);
    finally
      BMP.Free;
    end;
  finally
    Printer.EndDoc;
  end;
end;

//비트맵을 캔버스로 내보내기
procedure BitmapToCanvas(Canvas: TCanvas; DestRect: TRect; BMP: TBitmap);
var
  pBMPHeader: pBitmapInfo;
  pBMPImage: Pointer;
  dHeaderSize: DWORD;
  dImageSize: DWORD;
begin
  GetDIBSizes(BMP.Handle, dHeaderSize, dImageSize);
  GetMem(pBMPHeader, dHeaderSize);
  GetMem(pBMPImage, dImageSize);
  try
    GetDIB(BMP.Handle, BMP.Palette, pBMPHeader^, pBMPImage^);
    StretchDIBits(Canvas.Handle,
      DestRect.Left, DestRect.Top,    // Destination Origin
      DestRect.Right - DestRect.Left, // Destination Width
      DestRect.Bottom - DestRect.Top, // Destination Height
      0, 0,                           // Source Origin
      BMP.Width, BMP.Height,          // Source Width & Height
      pBMPImage, TBitmapInfo(pBMPHeader^), DIB_RGB_COLORS, SRCCOPY);
  finally
    FreeMem(pBMPHeader);
    FreeMem(pBMPImage);
  end
end;

//비크맵 객체를 프린터로 출력
procedure BitmapToPrint(BMP: TBitmap; const AIsLandscape: Boolean);
var
  nFromLeft, nFromTop, nPrnWidth, nPrnHeight: integer;
begin
  if AIsLandscape then
    Printer.Orientation := poLandscape
  else
    Printer.Orientation := poPortrait;

  Printer.BeginDoc;
  try
    nPrnWidth  := MulDiv(Printer.PageWidth, 94, 100); //94%
    nPrnHeight := MulDiv(nPrnWidth, BMP.Height, BMP.Width);
    nFromLeft  := MulDiv(Printer.PageWidth, 3, 100);  //3%
    nFromTop   := MulDiv(Printer.PageHeight, 3, 100); //3%

    BitmapToCanvas(Printer.Canvas, Rect(nFromLeft, nFromTop, nFromLeft + nPrnWidth, nFromTop  + nPrnHeight), BMP);
  finally
    Printer.EndDoc;
  end;
end;

//비트맵 객체를 이미지 파일로 저장
function SaveImageToFile(const AFileName: string; AImage: TGraphic; AImageFormat: TWICImageFormat; const APixelFormat: byte; const AJpegCompressionQuality: integer): integer;
var
  IMG: TGraphic;
begin
  try
    try
      case AImageFormat of
        wifBmp:
        begin
          IMG := TBitmap.Create;
          case APixelFormat of
            1: TBitmap(IMG).PixelFormat := pf1bit;
            4: TBitmap(IMG).PixelFormat := pf4bit;
            8: TBitmap(IMG).PixelFormat := pf8bit;
            24: TBitmap(IMG).PixelFormat := pf24bit;
            32: TBitmap(IMG).PixelFormat := pf32bit;
          else
            TBitmap(IMG).PixelFormat := pf16bit; //기본값:16비트
          end;
        end;

        wifJpeg:
        begin
          IMG := TJpegImage.Create;
          TJpegImage(IMG).CompressionQuality := AJpegCompressionQuality;
          case APixelFormat of
            8: TJpegImage(IMG).PixelFormat := jf8Bit;
          else
            TJpegImage(IMG).PixelFormat := jf24Bit; //기본값:24비트
          end;
        end;

        wifPng:
        begin
          IMG := TPngImage.Create;
          TPngImage(IMG).Header.BitDepth := APixelFormat;
        end;
      else
        Result := -2; //지원하지 않는 파일 형식
        Exit;
      end;

      IMG.Assign(AImage);
      IMG.SaveToFile(AFileName);
      Result := 0; //성공
    except
      on E: Exception do
        Result := GetLastError;
    end;
  finally
    FreeAndNil(IMG);
  end;
end;

//비트맵 객체를 Jpeg형식의 이미지 파일로 저장
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic): Integer;
begin
  Result := SaveImageToFile(AFileName, AImage, wifJpeg, 16, 70);
end;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: Byte): Integer;
begin
  Result := SaveImageToFile(AFileName, AImage, wifJpeg, APixelFormat, 70);
end;
function SaveImageToJpegFile(const AFileName: string; AImage: TGraphic; const APixelFormat: Byte; const AJpegCompressionQuality: Integer): Integer;
begin
  Result := SaveImageToFile(AFileName, AImage, wifJpeg, APixelFormat, AJpegCompressionQuality);
end;

//비트맵 자르기
procedure CropBitmap(AInputBitmap, AOutputBitMap: TBitmap; const AStartX, AStartY, AWidth, AHeight: Integer);
begin
  AOutputBitMap.PixelFormat := AInputBitmap.PixelFormat;
  AOutputBitMap.Width := AWidth;
  AOutputBitMap.Height := AHeight;
  BitBlt(AOutputBitMap.Canvas.Handle, 0, 0, AWidth, AHeight, AInputBitmap.Canvas.Handle, AStartX, AStartY, SRCCOPY);
end;

//비트맵 객체를 지정한 크기로 변경
(*
procedure ResizeBitmap(ABitmap: TBitmap; const ANewWidth, ANewHeight: Integer);
begin
  ABitmap.Canvas.StretchDraw(Rect(0, 0, ANewWidth, ANewHeight), ABitmap);
  ABitmap.SetSize(ANewWidth, ANewHeight);
end;
*)
procedure ResizeBitmap(ABitmap: TBitmap; const AWidth, AHeight: Integer; ABackgroundColor: TColor);
var
  R: TRect;
  B: TBitmap;
  X, Y: Integer;
begin
  if not Assigned(ABitmap) then
    Exit;

  B := TBitmap.Create;
  try
    if (ABitmap.Width > ABitmap.Height) then
    begin
      R.Right := AWidth;
      R.Bottom := ((AWidth * ABitmap.Height) div ABitmap.Width);
      X := 0;
      Y := (AHeight div 2) - (R.Bottom div 2);
    end else begin
      R.Right := ((AHeight * ABitmap.Width) div ABitmap.Height);
      R.Bottom := AHeight;
      X := (AWidth div 2) - (R.Right div 2);
      Y := 0;
    end;

    R.Left := 0;
    R.Top := 0;
    B.PixelFormat := ABitmap.PixelFormat;
    B.Width := AWidth;
    B.Height := AHeight;
    B.Canvas.Brush.Color := ABackgroundColor;
    B.Canvas.FillRect(B.Canvas.ClipRect);
    B.Canvas.StretchDraw(R, ABitmap);
    ABitmap.Width := AWidth;
    ABitmap.Height := AHeight;
    ABitmap.Canvas.Brush.Color := ABackgroundColor;
    ABitmap.Canvas.FillRect(ABitmap.Canvas.ClipRect);
    ABitmap.Canvas.Draw(X, Y, B);
  finally
    B.Free;
  end;
end;

//지정한 날짜에 속하는 달의 마지막 일을 구한다.
function GetLastDayOfMonth(const ADateTime: TDateTime): shortint;
begin
  Result := -1;
  try
    Result := DayOf(EndOfTheMonth(ADateTime));
  except
    on E: Exception do {}
  end;
end;

//문자열(WideSring & AnsiString)의 Bytes 단위의 크기를 구한다.
function StrLength(const AText: string): integer;
const
  CONST_SINGLE_CHARS: string = Chr(32) + '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`~!@#$%^&*()-_=+\|[]{},<.>;:''"/?';
var
  S: string;
begin
  Result := 0;
  for var I: Integer := 1 to Length(AText) do
  begin
    S := AText[I];
    if (Pos(S, CONST_SINGLE_CHARS) > 0) then
      Result := Result + 1
    else
      Result := Result + 2;
  end;
end;

//지정한 길이만큼 문자열의 왼쪽을 채움
function LeftPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
var
  nRestLen: integer;
begin
  Result := AText;
  nRestLen := ALength - StrLength(AText);
  if (nRestLen < 1) then
    Exit;
  Result := StringOfChar(AFillChar, nRestLen) + AText;
end;

//지정한 길이만큼 문자열의 오른쪽을 채움
function RightPad(const AText: string; const AFillChar: Char; const ALength: integer): string;
var
  nRestLen: integer;
begin
  Result := Trim(AText);
  nRestLen := ALength - StrLength(AText);
  if (nRestLen < 1) then
    Exit;
  Result := AText + StringOfChar(AFillChar, nRestLen);
end;

//문자열의 끝에 Slash 강제 삽입
function IncludeTrailingSlash(const AText: string): string;
begin
  Result := Trim(AText);
  if (not AText.IsEmpty) and (RightBStr(AText, 1) <> '/') then
    Result := AText + '/';
end;

//문자열의 끝에 Slash 강제 제거
function ExcludeTrailingSlash(AText: string): string;
begin
  Result := AText;
  if (RightBStr(AText, 1) = '/') then
    Result := Copy(AText, 1, Length(AText) - 1);
end;

//문자열에서 숫자형만 반환함
function GetNumStr(const AValue: string): string;
begin
  Result := '';
  for var I: Integer := 1 to Length(AValue) do
    if System.SysUtils.CharInSet(AValue[I], ['0'..'9']) then
      Result := (Result + AValue[I]);
end;

//요일명 반환
function DayOfWeekName(const ADate: TDate): string;
begin
  Result := DayOfWeekName(ADate, false);
end;
function DayOfWeekName(const ADate: TDate; const AHanja: Boolean): string;
//const
//  LA_DAY_OF_WEEKNAME: array[0..6] of string = ('월', '화', '수', '목', '금', '토', '일');
var
  Days: array[0..7] of string;
begin
  Days[0] := '  ';
  if AHanja then
  begin
    Days[1] := '日';
    Days[2] := '月';
    Days[3] := '火';
    Days[4] := '水';
    Days[5] := '木';
    Days[6] := '金';
    Days[7] := '土';
  end
  else
  begin
    Days[1] := '일';
    Days[2] := '월';
    Days[3] := '화';
    Days[4] := '수';
    Days[5] := '목';
    Days[6] := '금';
    Days[7] := '토';
  end;
  Result := Days[DayOfWeek(ADate)];
end;

//로컬 시각 변경 (Administrator 권한 필요)
function ChangeSystemTime(const ADateTime: TDateTime): Boolean;
var
  dSysTime: TSystemTime;
  sUserName: string;
begin
  Result := False;
  DateTimeToSystemTime(ADateTime, dSysTime);
  sUserName := GetCurrentUserName;
  try
    try
      AddPrivilege(sUserName, 'SeSystemtimePrivilege');
      SetLocalTime(dSysTime);
      Result := True;
    finally
      RemovePrivilege(sUserName, 'SeSystemtimePrivilege');
    end;
  except
  end;
end;

//Bitmap을 이용하여 문자열의 Display Width와 Height를 픽셀 단위로 구한다.
procedure GetTextPixelSize(const AText: string; AFont: TFont; var AWidth, AHeight: integer);
var
  BMP: TBitmap;
begin
  BMP := TBitmap.Create;
  try
    BMP.Canvas.Font := AFont;
    AWidth := BMP.Canvas.TextWidth(AText);
    AHeight := BMP.Canvas.TextHeight(AText);
  finally
    FreeAndNil(BMP);
  end;
end;

//Null 처리 함수:ORACLE의 NVL()과 동일
function NVL(const ATestValue, ANewValue: Variant): Variant;
begin
  Result := ATestValue;
  if VarIsNull(ATestValue) or
     VarIsEmpty(ATestValue) or
     (ATestValue = 'null') then
    Result := ANewValue;
end;

//인자값이 null인지 확인
function IsNull(const AValue: Variant): Boolean;
begin
  Result := VarIsNull(AValue) or
            VarIsEmpty(AValue) or
            ((VarType(AValue) = varString) and (Trim(AValue) = EmptyStr));
end;

// OleVarian를 Stream으로 변환
function OleVariantToStream(AOleValue: OleVariant): TMemoryStream;
var
  PData: PByteArray;
  nSize: integer;
begin
  Result := TMemoryStream.Create;
  try
    nSize := VarArrayHighBound (AOleValue, 1) - VarArrayLowBound (AOleValue, 1) + 1;
    if (nSize = 0) then
    begin
      if (Result <> nil) then
        Result.Free;
      Result := nil;
      Exit;
    end;

    PData := VarArrayLock(AOleValue);
    try
      Result.Position := 0;
      Result.WriteBuffer(PData^, nSize);
    finally
      VarArrayUnlock(AOleValue);
    end;
  except
    VarArrayUnlock(AOleValue);
    Result.Free;
    Result := nil;
  end;
end;

// Stream을 OleVarian로 변환
function StreamToVariant(AStream: TStream): OleVariant;
var
  p: Pointer;
begin
  Result := VarArrayCreate ([0, AStream.Size - 1], varByte);
  p := VarArrayLock (Result);
  try
    AStream.Position := 0;
    AStream.Read(p^, AStream.Size);
  finally
    VarArrayUnlock(Result);
  end;
end;

//IME 한글 입력모드 검사
function IsHanState: Boolean;
var
   dwConversion, dwSentence: DWORD;
   hIMC: THandle;
begin
   HIMC := Imm32GetContext(Application.Handle);
   Imm32GetConversionStatus(hIMC, dwConversion, dwSentence);
   Imm32ReleaseContext(Application.Handle, hIMC);
   Result := (dwConversion = IME_CMODE_HANGEUL);
end;

//IME 입력모드 변경 ※한글:SetIMEMode(imKorean), 영문:SetIMEMode(imEnglish)
procedure SetIMEMode(const AImeMode: TImeMode);
var
   dwConversion, dwSentence: DWORD;
   hIMC: THandle;
begin
   hIMC:= Imm32GetContext(Application.Handle);
   Imm32GetConversionStatus(hIMC, dwConversion, dwSentence);
   Case AImeMode Of
      imEnglish: Imm32SetConversionStatus(hIMC, IME_CMODE_ALPHANUMERIC, dwSentence);
      imKorean : Imm32SetConversionStatus(hIMC, IME_CMODE_NATIVE, dwSentence);
   end; {Case Value Of}
   Imm32ReleaseContext(Application.Handle, hIMC);
end;

//NumLock, CapsLock, ScrollLock 상태 읽기
function GetKeybdState(const AKeyCode: integer): Boolean;
var
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  Result := (KeyState[AKeyCode] = 1);
end;

//NumLock, CapsLock, ScrollLock 상태 변경
procedure SetKeybdState(const AKeyCode: integer; const AIsOn: Boolean);
var
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  if (Byte(Ord(AIsOn)) <> KeyState[AKeyCode]) then
  begin
    Keybd_event(AKeyCode, $3A, KEYEVENTF_EXTENDEDKEY, 0);
    Keybd_event(AKeyCode, $3A, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
    KeyState[AKeyCode] := Ord(AIsOn);
    SetKeyboardState(KeyState);
  end;
end;

//가상 키보드 입력 처리
procedure SimulateKeyDown(AVirtualKey: Byte);
begin
  keybd_event(AVirtualKey, MapVirtualkey(AVirtualKey, 0), 0, 0);
end;

procedure SimulateKeyUp(AVirtualKey: Byte);
begin
  keybd_event(AVirtualKey, MapVirtualkey(AVirtualKey, 0), KEYEVENTF_KEYUP, 0);
end;

procedure SimulateKeyWithShift(AVirtualKey: Byte);
begin
  SimulateKeyWithShift(AVirtualKey, VK_SHIFT);
end;

procedure SimulateKeyWithShift(AVirtualKey, AShiftKey: Byte);
begin
  SimulateKeyDown(AShiftKey);
  SimulateKey(AVirtualKey);
  SimulateKeyUp(AShiftKey);
end;

procedure SimulateKey(AVirtualKey: Byte);
begin
  SimulateKeyDown(AVirtualKey);
  SimulateKeyUp(AVirtualKey);
end;

function KeybdHookHookCallback(ACode: integer; wParam: WPARAM; lParam: LPARAM): NativeInt; stdcall;
begin
  if (ACode >= 0) then
    if ((wParam = 229) and (lParam = -2147483647)) or
       ((wParam = 229) and (lParam = -2147483648.0)) then //NT는 (lParam = -2147483648)
    begin
      Result := Integer(True);
      Exit;
    end;

  Result := CallNextHookEx(SBGlobal_KeybdHook, ACode, wParam, lParam);
end;

procedure KeybdHookStart;
begin
  SBGlobal_KeybdHook := SetWindowsHookEx(WH_KEYBOARD, KeybdHookHookCallback, HInstance, GetCurrentThreadID);
end;

procedure KeybdHookStop;
begin
  UnHookWindowsHookEx(SBGlobal_KeybdHook);
end;

function MouseHookHookCallBack(ACode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  LP: Cardinal;
  WindowRect: TRect;
  MousePoint: TPoint;
begin
  if (ACode = HC_ACTION) then
    case wParam of
      WM_LBUTTONUP, WM_RBUTTONUP,
      WM_LBUTTONDOWN, WM_RBUTTONDOWN:
      begin
        GetWindowRect(SBGlobal_MouseThisHandle, WindowRect);
        MousePoint.X := PMSLLHOOKSTRUCT(lParam).pt.x;
        MousePoint.Y := PMSLLHOOKSTRUCT(lParam).pt.y;

        if PtInRect(WindowRect, MousePoint) then
        begin
          PMSLLHOOKSTRUCT(lParam).flags := 0;
          LP := (MousePoint.x shl 16) + MousePoint.y;
          PostMessage(SBGlobal_MouseThisHandle, CONST_WM_SEND_MOUSE, wParam, LP);
          Result := 1;
          Exit;
        end;
      end;
    end;
  Result := CallNextHookEx(SBGlobal_MouseHook, ACode, wParam, lParam);
end;

//마우스 후킹
procedure MouseHookStart(const AHandle: THandle);
begin
  SBGlobal_MouseThisHandle := AHandle;
  SBGlobal_MouseHook := SetWindowsHookEx(WH_MOUSE_LL, @MouseHookHookCallBack, HInstance, GetCurrentThreadID);
end;

procedure MouseHookStop;
begin
  UnhookWindowsHookEx(SBGlobal_MouseHook);
end;

//Sleep() 대체 함수
procedure SleepEx(const AMSecs: LongInt);
const
  _SECOND = -10000;
var
  hTimer: HWND;
  nBusy: LongInt;
  iDueTime: LARGE_INTEGER;
begin
  hTimer := CreateWaitableTimer(nil, True, 'WaitableTimer');
  try
    if (hTimer = 0) then
      Exit;

    iDueTime.QuadPart := _SECOND * AMSecs;
    SetWaitableTimer(hTimer, TLargeInteger(iDueTime), 0, nil, nil, False);
    repeat
      nBusy := MsgWaitForMultipleObjects(1, hTimer, False, INFINITE, QS_ALLINPUT);
      Application.ProcessMessages;
    until (nBusy = WAIT_OBJECT_0);
  finally
    CloseHandle(hTimer);
  end;
end;

procedure Delay(const AMSecs: LongInt);
var
  nTargetTime: LongInt;
  AMsg: TMsg;
begin
  nTargetTime := (GetTickCount + AMSecs);
  while (nTargetTime > GetTickCount) do
  if PeekMessage(AMsg, 0, 0, 0, PM_REMOVE) then
  begin
    if (AMsg.Message = WM_QUIT) then
    begin
      PostQuitMessage(AMsg.wParam);
      Break;
    end;
    TranslateMessage(AMsg);
    DispatchMessage(AMsg);
  end;
end;

//텍스트 파일 생성 및 기록
procedure WriteToFile(const AFileName, AStr: string; const ANewFile: Boolean);
var
  hFile: TextFile;
begin
  if ANewFile then
    DeleteFile(AFileName);

  AssignFile(hFile, AFileName);
  try
    try
      if FileExists(AFileName) then
        Append(hFile)
      else
        Rewrite(hFile);

      WriteLn(hFile, AStr);
    except
    end;
  finally
    CloseFile(hFile);
  end;
end;

//애플리케이션 버전 정보 추출
function GetAppVersion(const AIndex: Integer): string;
const
  VERSION_INFO: array[0..9] of string = (
    'CompanyName',
    'FileDescription',
    'FileVersion',
    'InternalName',
    'LegalCopyright',
    'LegalTradeMarks',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments');
var
  s, Locale: string;
  n, Len: DWORD;
  P: Pointer;
  Buf: PChar;
  Value: PChar;
begin
  Result := '?';
  s := Application.ExeName;
  n := GetFileVersionInfoSize(PChar(s), n);
  if (n > 0) then
  begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(s), 0, n, Buf);
      VerQueryValue(Buf, 'VarFileInfo\Translation', P, Len);
      Locale := IntToHex(MakeLong(HiWord(Longint(P^)), LoWord(Longint(P^))), 8);
      if VerQueryValue(Buf, PChar('StringFileInfo\' + Locale + '\' + VERSION_INFO[AIndex]), Pointer(Value), Len) then
        Result := Trim(Value);
    finally
      FreeMem(Buf, n);
    end;
  end;
end;

//DLL등의 모듈 파일 버전 정보 추출
function GetModuleVersion(const AFileName: string): string;
var
  wInfoSize: DWORD;
  PVerBuff: pointer;
  nVerSize, nWnd: UINT;
  PFFI: PVSFixedFileInfo;
begin
  Result := '';
  wInfoSize := GetFileVersioninfoSize(PChar(AFileName), nWnd);
  if (wInfoSize <> 0) then
  begin
    GetMem(PVerBuff, wInfoSize);
    try
      if GetFileVersionInfo(PChar(AFileName), nWnd, wInfoSize, PVerBuff) then
      begin
        VerQueryValue(PVerBuff, '\', Pointer(PFFI), nVerSize);
        Result := IntToStr(PFFI.dwFileVersionMS div $10000) + '.' +
                  IntToStr(PFFI.dwFileVersionMS and $0FFFF) + '.' +
                  IntToStr(PFFI.dwFileVersionLS div $10000) + '.' +
                  IntToStr(PFFI.dwFileVersionLS and $0FFFF);
      end;
    finally
      FreeMem(PVerBuff);
    end;
  end;
end;

//사용 가능한 모든 컨트롤에 DoubleBuffered 적용
procedure SetDoubleBuffered(AControl: TWinControl; const ADoubleBuffered: Boolean);
begin
  AControl.DoubleBuffered := ADoubleBuffered;
  if AControl is TPanel then
    TPanel(AControl).FullRepaint := (not ADoubleBuffered);

  for var I: Integer := 0 to Pred(AControl.ControlCount) do
    if (AControl.Controls[I] is TWinControl) then
      SetDoubleBuffered(TWinControl(AControl.Controls[I]), ADoubleBuffered);
end;
//procedure SetDoubleBuffered(AControl: TWinControl; ADoubleBuffered: Boolean);
//var
//  I: Integer;
//begin
//  AControl.DoubleBuffered := ADoubleBuffered;
//  if ADoubleBuffered then
//  begin
//    AControl.ControlStyle := AControl.ControlStyle + [csOpaque];
//    if AControl is TPanel then
//      TPanel(AControl).FullRepaint := False;
//
//    for var I: IInteger := 0 to Pred(AControl.ControlCount) do
//      if (AControl.Controls[I] is TWinControl) then
//      begin
//        SetDoubleBuffered(TWinControl(AControl.Controls[I]), ADoubleBuffered);
//        TWinControl(AControl.Controls[I]).ControlStyle := TWinControl(AControl.Controls[I]).ControlStyle + [csOpaque];
//      end
//      else if (AControl.Controls[i] is TGraphicControl) or
//         (AControl.Controls[I] is TControl) then
//      begin
//        AControl.Controls[I].ControlStyle := AControl.Controls[I].ControlStyle + [csOpaque];
//      end;
//  end;
//end;

//Check Existing File(64bit)
function FileExists64(const AFileName: string): Boolean;
type
  TWow64DisableWow64FsRedirection = function(var Wow64FsEnableRedirection: LongBool): LongBool; stdcall;
  TWow64EnableWow64FsRedirection  = function(Wow64FsEnableRedirection: LongBool): LongBool; stdcall;
var
  hHandle: THandle;
  Wow64DisableWow64FsRedirection: TWow64DisableWow64FsRedirection;
  Wow64EnableWow64FsRedirection: TWow64EnableWow64FsRedirection;
  Wow64FsEnableRedirection: LongBool;
begin
  hHandle := GetModuleHandle('kernel32.dll');
  @Wow64EnableWow64FsRedirection  := GetProcAddress(hHandle, 'Wow64EnableWow64FsRedirection');
  @Wow64DisableWow64FsRedirection := GetProcAddress(hHandle, 'Wow64DisableWow64FsRedirection');
  if (hHandle <> 0) and
     (@Wow64EnableWow64FsRedirection <> nil) and
     (@Wow64DisableWow64FsRedirection <> nil) then
  begin
    Wow64DisableWow64FsRedirection(Wow64FsEnableRedirection);
    Result := FileExists(AFileName);
    Wow64EnableWow64FsRedirection(Wow64FsEnableRedirection);
  end
  else
    Result:=False;
end;

//Check 64bit Windows
function IsWin64: Boolean;
var
  Kernel32Handle: THandle;
  IsWow64Process: function(AHandle: Winapi.Windows.THandle; var ARes: Winapi.Windows.BOOL): Winapi.Windows.BOOL; stdcall;
  GetNativeSystemInfo: procedure(var lpSystemInfo: TSystemInfo); stdcall;
  isWoW64: Bool;
  SystemInfo: TSystemInfo;
const
  PROCESSOR_ARCHITECTURE_AMD64 = 9;
  PROCESSOR_ARCHITECTURE_IA64  = 6;
begin
  Kernel32Handle := GetModuleHandle('kernel32.dll');
  if (Kernel32Handle = 0) then
    Kernel32Handle := LoadLibrary('kernel32.dll');
  if (Kernel32Handle <> 0) then
  begin
    IsWOW64Process := GetProcAddress(Kernel32Handle, 'IsWow64Process');
    GetNativeSystemInfo := GetProcAddress(Kernel32Handle, 'GetNativeSystemInfo');
    if Assigned(IsWow64Process) then
    begin
      IsWow64Process(GetCurrentProcess,isWoW64);
      Result := isWoW64 and Assigned(GetNativeSystemInfo);
      if Result then
      begin
        GetNativeSystemInfo(SystemInfo);
        Result := (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) or
                  (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64);
      end;
    end
    else
      Result := False;
  end
  else
    Result := False;
end;

//조회용 신용카드번호
function GetHideCreditCardNo(const ACreditCardNo: string): string;
begin
  Result := ACreditCardNo;
  if (ACreditCardNo <> EmptyStr) then
    Result := Format('%s-%s-****-%s', [Copy(ACreditCardNo, 1, 4), Copy(ACreditCardNo, 5, 4), Copy(ACreditCardNo, 13, 4)]);
end;

//데이터 추가 후에 CalcField 가 바로 반영되지 않는 버그 패치용
procedure RefreshCalcField(ADataSet: TDataSet);
var
  BM: TBookmark;
begin
  BM := ADataSet.GetBookmark;
  with ADataset do
  try
    if ADataSet.BookmarkValid(BM) then
      ADataSet.GotoBookmark(BM);
  finally
    ADataSet.FreeBookmark(BM);
  end;
end;

//yyyymmdd 형식의 날짜를 yyyy-mm-dd 형식으로 반환
function FormattedDateString(const ADateString: string): string;
begin
  Result := ADateString;
  if (Pos('-', ADateString) > 0) then
    Exit;
  if (ADateString <> EmptyStr) and (Length(ADateString) = 8) then
    Result := Copy(ADateString, 1, 4) + '-' + Copy(ADateString, 5, 2) + '-' + Copy(ADateString, 7, 2);
end;

//hhnnss 형식의 시각을 hh:nn:ss 형식으로 반환
function FormattedTimeString(const ATimeString: string): string;
begin
  Result := ATimeString;
  if (Pos(':', ATimeString) > 0) then
    Exit;
  if (ATimeString <> EmptyStr) then
    if (Length(ATimeString) = 4) then
      Result := Copy(ATimeString, 1, 2) + ':' + Copy(ATimeString, 3, 2)
    else if (Length(ATimeString) = 6) then
      Result := Copy(ATimeString, 1, 2) + ':' + Copy(ATimeString, 3, 2) + ':' + Copy(ATimeString, 5, 2);
end;

//유닉스 시각 문자열을 문자열로 변환
function UnixTimeToString(const AUnixTime: string; const AFormatStr: string): string;
var
  nUnixTime: Int64;
  dDateTime: TDateTime;
begin
  Result := '';
  nUnixTime := StrToInt64Def(AUnixTime, 0) div 1000; //밀리초 제외
  try
    if (nUnixTime > 0) then
    begin
      dDateTime := UnixToDateTime(nUnixTime, False); //not UTC(협정세계시: Coordinated Universal Time)
      Result := FormatDateTime(AFormatStr, dDateTime, FormatSettings);
    end;
  except
  end;
end;

//특수문자 제거
function RemoveSpecialChar(const ASource: string): string;
begin
  for var I: Integer := 1 to Length(ASource) do
    if System.SysUtils.CharInSet(ASource[I], ['A'..'Z', 'a'..'z', '0'..'9']) then
      Result := Result + ASource[I];
end;

//레지스트리에 시작 프로그램으로 등록하기
procedure RunOnWindownStart(const AppTitle, AppFile: string; const ARunOnce: Boolean=False);
var
  Reg: TRegistry;
  TheKey: string;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  TheKey := 'Software\Microsoft\Windows\CurrentVersion\Run';
  if ARunOnce then
    TheKey := TheKey + 'Once';
  Reg.OpenKey(TheKey, True);
  Reg.WriteString(AppTitle, AppFile);
  Reg.CloseKey;
  Reg.Free;
end;

//레지스트리의 시작 프로그램에서 제거하기
function RemoveFromRunOnWindowStart(const AppTitle: string): Boolean;
var
  Reg: TRegistry;
  TheKey: string;
begin
  Result := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  TheKey := 'Software\Microsoft\Windows\CurrentVersion\Run';
  if Reg.OpenKey(TheKey, False) then
    Result := Reg.DeleteValue(AppTitle);
  Reg.CloseKey;
  Reg.Free;
end;

//윈도우 시스템 종료
procedure SystemShutdown(const ATimeOut: DWORD; const AForceClose, AReboot: Boolean);
var
  PreviosPrivileges: ^TTokenPrivileges;
  TokenPrivileges: TTokenPrivileges;
  hToken: THandle;
  tmpReturnLength: DWORD;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
    begin
      LookupPrivilegeValue(nil, 'SeShutdownPrivilege', TokenPrivileges.Privileges[0].Luid);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tmpReturnLength := 0;
      PreviosPrivileges := nil;
      AdjustTokenPrivileges(hToken, False, TokenPrivileges, 0, PreviosPrivileges^, tmpReturnLength);
      if InitiateSystemShutdown(nil, nil, ATimeOut, AForceClose, AReboot) then
      begin
        TokenPrivileges.Privileges[0].Attributes := 0;
        AdjustTokenPrivileges(hToken, False, TokenPrivileges, 0, PreviosPrivileges^, tmpReturnLength);
      end;
    end ;
  end
  else
    ExitWindowsEx(EWX_FORCE or EWX_SHUTDOWN or EWX_POWEROFF, 0);
end;

//지정한 Window를 최상위로 표시함
procedure SetWindowOnTop(const AHandle: HWND);
var
  Inp: TInput;
begin
  ZeroMemory(@Inp, SizeOf(Inp));
  SendInput(1, Inp, SizeOf(Inp));
  SetForegroundWindow(AHandle);
end;
procedure SetWindowOnTop2(const AHandle: HWND);
var
  lpRect: TRect;
begin
  if GetWindowRect(AHandle, lpRect) then
    SetWindowPos(AHandle, HWND_TOPMOST, lpRect.left, lpRect.top, lpRect.Right-lpRect.left, lpRect.Bottom-lpRect.Top, SWP_SHOWWINDOW);
end;

//관리자 권한으로 프로그램 실행
//Example: RunAsAdmin(Handle, 'c:\Windows\system32\cmd.exe', '');
function RunAsAdmin(const AHandle: HWND; const APath, AParams: string): Boolean;
var
  SI: TShellExecuteInfoA;
begin
  FillChar(SI, SizeOf(SI), 0);
  SI.cbSize := SizeOf(SI);
  SI.Wnd := AHandle;
  SI.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  SI.lpVerb := 'runas';
  SI.lpFile := PAnsiChar(APath);
  SI.lpParameters := PAnsiChar(AParams);
  SI.nShow := SW_SHOWNORMAL;
  Result := ShellExecuteExA(@SI);
end;

function GetSysDir: string;
var
  ABuffer: array[0..MAX_PATH] of Char;
begin
  GetSystemDirectory(ABuffer, MAX_PATH - 1);
  SetLength(Result, StrLen(ABuffer));
  Result := ABuffer;
end;

function GetSysDir(const AFloder: Integer): string;
var
  PPath: PChar;
begin
  Result := '';
  GetMem(PPath, MAX_PATH);
  try
    SHGetFolderPath(0, AFloder, 0, 0, PPath);
    Result := Copy(PPath, 0, Length(PPath));
  finally
    FreeMem(PPath);
  end;
end;

//암호화
function StrEncrypt(const AStr: AnsiString): AnsiString;
const
  HexData: array[0..9] of Integer = (186, 165, 20, 188, 61, 85, 171, 61, 244, 164);
var
  nTmp, nKey, nRndCnt: Integer;
  sRet, sTemp: AnsiString;
  PWord: ^AnsiChar;
begin
  Randomize;
  nKey := Random(254);
  nRndCnt := Random(9) + 5;
  sRet := sRet + Format('%.2X', [((nRndCnt xor nKey) xor HexData[5])]);
	nKey := nKey xor HexData[9];
  for var I: Integer := 1 to nRndCnt do
    sRet := sRet + Format('%.2X', [Random(254) xor nKey]);

	nKey := nKey xor HexData[5];
  nTmp := 0;
  while (nTmp < Length(AStr)) do
  begin
    PWord := Pointer(PAnsiChar(AStr) + nTmp);
    sTemp := Format('%.2X', [(Ord(PWord^) xor nKey) xor HexData[nTmp mod 10]]);
    sRet := sRet + sTemp;
    Inc(nTmp);
  end;

  sTemp := Format('%.2X', [nKey]);
  Result := sTemp + sRet;
end;

//복호화
function StrDecrypt(const AStr: AnsiString): AnsiString;
const
  HexData: array[0..9] of Integer = (186, 165, 20, 188, 61, 85, 171, 61, 244, 164);
var
  I, nLen, nPos, nKey, nBaseKey, nRndCnt, nTemp: Integer;
  sRet, sTemp: AnsiString;
begin
  Result := '';
  nLen := Length(AStr);
  if (nLen < 6) then
    Exit;

  nBaseKey := StrToInt('$' + Copy(AStr, 1, 2));
	nKey := nBaseKey xor HexData[5];
	nKey := nKey xor HexData[9];
  nRndCnt := ((StrToInt('$' + Copy(AStr, 3, 2)) xor HexData[5]) xor nKey);
	nPos := 4 + nRndCnt * 2 + 1;
	if (nLen <= nPos) then
    Exit;

	nKey := nBaseKey;
  I := 0;
  while (nPos < nLen) do
  begin
    sTemp := '$' + Copy(AStr, nPos, 2);
    nTemp := ((StrToInt(sTemp) xor HexData[i mod 10]) xor nKey);
    sRet := sRet + Chr(nTemp);
    Inc(I);
    nPos := nPos + 2;
  end;
  Result := sRet;
end;

function StrEncryptEx(const ADecrypt: WideString; AKey: Word): string;
var
  RStr: RawByteString;
  RStrB: TBytes absolute RStr;
begin
  Result := '';
  RStr := UTF8Encode(ADecrypt);
  for var I: Integer := 0 to Length(RStr) - 1 do
  begin
    RStrB[I] := RStrB[I] xor (AKey shr 8);
    AKey := (RStrB[I] + AKey) * C_SEED_KEY1 + C_SEED_KEY2;
  end;
  for var I: Integer := 0 to Length(RStr) - 1 do
    Result := Result + IntToHex(RStrB[I], 2);
end;

function StrDecryptEx(const AEncrypt: string; AKey: Word): string;
var
  nTmpKey: Integer;
  RStr: RawByteString;
  RStrB: TBytes absolute RStr;
  sTmpStr: string;
begin
  sTmpStr := UpperCase(AEncrypt);
  SetLength(RStr, Length(sTmpStr) div 2);
  nTmpKey := 1;
  try
    while (nTmpKey < Length(sTmpStr)) do
    begin
      RStrB[nTmpKey div 2] := StrToInt('$' + sTmpStr[nTmpKey] + sTmpStr[nTmpKey + 1]);
      Inc(nTmpKey, 2);
    end;
  except
    Result:= '';
    Exit;
  end;

  for var I: Integer := 0 to Length(RStr) - 1 do
  begin
    nTmpKey := RStrB[I];
    RStrB[I] := RStrB[I] xor (AKey shr 8);
    AKey := (nTmpKey + AKey) * C_SEED_KEY1 + C_SEED_KEY2;
  end;
  Result := UTF8Decode(RStr);
end;

function LPadB(const AStr: string; ALength: Integer): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := PadChar(ALength - ByteLen(Result), ' ') + Result;
end;

function RPadB(const AStr: string; ALength: Integer): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := Result + PadChar(ALength - ByteLen(Result), ' ');
end;

function PadChar(ALength: Integer; APadChar: Char = ' '): string;
begin
  Result := '';
  for var I: Integer := 1 to ALength do
    Result := Result + APadChar;
end;

function SCopy(const AText: string; const AByteStart, AByteCount: Integer): string;
var
  Start, Cnt: Integer;
begin
  Result := '';
  Start := 1;
  Cnt := 0;
  // 시작위치를 알아낸다.
  for var I: Integer := 1 to Length(AText) do
  begin
    Start := I;
    // ASCII 코드값 #$00FF 보다 크면 2Byte 문자로 계산한다.
    Cnt := Cnt + IfThen(AText[I] <= #$00FF, 1, 2);
    if Cnt >= AByteStart then Break;
  end;
  if AByteStart > Cnt then Exit;
  Cnt := 0;
  // 길이만큼 자른다.
  for var I: Integer := Start to Length(AText) do
  begin
    Cnt := Cnt + IfThen(AText[I] <= #$00FF, 1, 2);
    if Cnt <= AByteCount then
      Result := Result + AText[I]
    else
      Break;
  end;
end;

function ByteLen(const AText: string): Integer;
begin
  Result := 0;
  for var I: Integer := 1 to Length(AText) do
    Result := Result + IfThen(AText[I] <= #$00FF, 1, 2);
end;

function Base64Encode(const AData: string; const AConvertUTF8: Boolean): string;
var
  UTF8: UTF8String;
begin
  if AConvertUTF8 then
  begin
    UTF8 := UTF8String(AData);
    Result := Soap.EncdDecd.EncodeBase64(PChar(UTF8), Length(UTF8));
  end
  else
    Result := Soap.EncdDecd.EncodeBase64(PChar(AData), Length(AData));
end;

function Base64EncodeA(const AData: string; const AConvertUTF8: Boolean): string;
var
  UTF8: UTF8String;
begin
  if AConvertUTF8 then
  begin
    UTF8 := UTF8String(AData);
    Result := Soap.EncdDecd.EncodeBase64(PAnsiChar(UTF8), Length(UTF8));
  end
  else
    Result := Soap.EncdDecd.EncodeBase64(PAnsiChar(AData), Length(AData));
end;

function Base64Decode(const AData: string): string;
var
  Bytes: TBytes;
  UTF8: UTF8String;
begin
  Bytes := Soap.EncdDecd.DecodeBase64(AData);
  SetLength(UTF8, Length(Bytes));
  Move(Pointer(Bytes)^, Pointer(UTF8)^, Length(Bytes));
  Result := String(UTF8);
end;

function Base64DecodeStream(const AStream: TStream): string;
var
  MS: TMemoryStream;
  sValue: string;
begin
  Result := '';
  MS := TMemoryStream.Create;
  with TIdEncoderMIME.Create(nil) do
  try
    AStream.Position := 0;
    DecodeStream(AStream, MS);
    SetLength(sValue, MS.Size);
    MS.ReadBuffer(Pointer(sValue)^, MS.Size);
    Result := sValue;
  finally
    MS.Free;
    Free;
  end;
end;

function Base64EncodeStream(const AStream: TStream): string;
begin
  Result := '';
  with TIdEncoderMIME.Create(nil) do
  try
    AStream.Position := 0;
    Result := EncodeStream(AStream);
  finally
    Free;
  end;
end;

function Base64EncodeGraphic(AImage: TGraphic): string;
var
  MS: TMemoryStream;
begin
  Result := '';
  MS := TMemoryStream.Create;
  with TIdEncoderMIME.Create(nil) do
  try
    AImage.SaveToStream(MS);
    MS.Position := 0;
    Result := EncodeStream(MS);
  finally
    MS.Free;
    Free;
  end;
end;

function Base64EncodeFile(const AFileName: string): string;
var
  FS: TFileStream;
begin
  Result := '';
  FS := TFileStream.Create(AFileName, fmOpenRead);
  with TIdEncoderMIME.Create(nil) do
  try
    FS.Position := 0;
    Result := EncodeStream(FS);
  finally
    FS.Free;
    Free;
  end;
end;

function BCC(const AValue: AnsiString): string;
var
  nBCC: Integer;
begin
  nBCC := 0;
  for var I: Integer := 1 to Length(AValue) do
    nBCC := nBCC xor Ord(AValue[I]);
  nBCC := nBCC or $20;
  Result := Char(nBcc);
end;

function LRC(const AValue: AnsiString; const ACheckLen: Integer): Byte;
var
  LLen: Integer;
begin
  LLen := ACheckLen;
  if (ACheckLen = 0) then
    LLen := Length(AValue);
  Result := 0;
  for var I: Integer := 1 to LLen do
    Inc(Result, Ord(AValue[I]));
  Result := (Result xor $FF) + 1; //Result := (not Result) + 1;
end;

function BinBytesToString(const AValue: array of Byte): string;
const
  CONST_HEX_SYMBOLS: string = '0123456789ABCDEF';
begin
  SetLength(Result, Length(AValue) * 2);
  for var I: Integer := 0 to Pred(Length(AValue)) do
  begin
    Result[1 + 2 * I + 0] := CONST_HEX_SYMBOLS[1 + AValue[I] shr 4];
    Result[1 + 2 * I + 1] := CONST_HEX_SYMBOLS[1 + AValue[I] and $0F];
  end;
end;

function BinStringToInteger(const AValue: string): Integer;
var
  LLen: Integer;
begin
  Result := 0;
  LLen := Length(AValue);
  for var I: Integer := LLen downto 1 do
    if AValue[I] = '1' then
      Result := Result + (1 shl (LLen - I));
end;

function IntegerToHexaString(const AValue, ADigits: Integer): string;
begin
  Result := AnsiString(IntToHex(AValue, ADigits));
end;

function StringToBinString(const AValue: string): string;
var
  LLoBits, LHiBits: Byte;
begin
  Result := '';
  for var I: Integer := 1 to Length(AValue) do
  begin
    LHiBits := (Byte(AValue[I]) and $F0) shr 4;
    LLoBits := Byte(AValue[I]) and $0F;
    Result := Result + CONST_BCD[LHiBits];
    Result := Result + CONST_BCD[LLoBits];
  end;
end;

function StringToHexaString(const AValue: string): string;
var
  LLength: Integer;
begin
  Result := '';
  for var I: Integer := 1 to Length(AValue) do
    Result := Result + IntToHex(Ord(AValue[I]), 2);
  LLength := Length(Result);
  if (LLength mod 2 <> 0) then
    Result := Result.PadLeft(LLength + 1, #48);
end;

function HexaStringToString(const AValue: string): string;
var
  LDigit: ShortInt;
  LTemp: string;
begin
  Result := '';
  LDigit := Length(AValue);
  for var I: Integer := 0 to Pred(Length(AValue) div LDigit) do
  begin
    LTemp := '';
    for var J: Integer := 1 to LDigit do
      LTemp := LTemp + AValue[I * LDigit + J];
    Result := Result + Char(StrToInt('$' + LTemp));
  end;
end;

function HexaStringToBinString(const AValue: string): string;
begin
  Result := '';
  for var I: Integer := Length(AValue) downto 1 do
    Result := CONST_BCD[StrToInt('$' + AValue[I])] + Result;
end;

function BytesToHexaString(const ABytes: TBytes): string;
begin
  Result := '';
  for var I: Integer := Low(ABytes) to High(ABytes) do
    Result := Result + IntToHex(ABytes[I]) + ' ';
end;

function StringToBytes(const AValue: WideString): TBytes;
begin
  SetLength(Result, Length(AValue) * SizeOf(WideChar));
  if (Length(Result) > 0) then
    Move(AValue[1], Result[0], Length(Result));
end;

function BytesToString(const AValue: TBytes): WideString;
begin
  SetLength(Result, Length(AValue) div SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(AValue[0], Result[1], Length(AValue));
end;

function StringToArrayOfByte(const AValue: AnsiString): TArrayOfByte;
begin
  SetLength(Result, Length(AValue));
  for var I: Integer := 0 to Pred(Length(AValue)) do
    Result[I] := ord(AValue[I + 1]) - 48;
end;

function ArrayOfByteToString(const AValue: TArrayOfByte): string;
var
  C: Char;
  S: string;
begin
  S := '';
  for var I: Integer := Pred(Length(AValue)) downto 0 do
  begin
    C := Chr(AValue[I] + 48);
    S := C + S;
  end;
  Result := S;
end;

function GetIdleSeconds: DWORD;
var
  LI: TLastInputInfo;
begin
  LI.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LI);
  Result := (GetTickCount - LI.dwTime) div 1000;
end;

function MakeRoundedControl(AControl: TWinControl; const AEllipseWidth: Integer; const AEllipseHeight: Integer): Boolean;
var
  R: TRect;
  Rgn: HRGN;
begin
  (*
  //TForm
  Form1.BorderStyle := bsNone;
  MakeRoundedControl(Form1);
  //TMemo:
  Memo1.BorderStyle := bsNone;
  MakeRoundedControl(Memo1);
  //TEdit:
  Edit2.BorderStyle := bsNone;
  MakeRoundedControl(Edit2);
  //TPanel:
  MakeRoundedControl(Panel1);
  //TStaticText:
  MakeRoundedControl(StaticText1);
  *)
  Result := False;
  with AControl do
  begin
    R := ClientRect;
    Rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, AEllipseWidth, AEllipseHeight);
    if not VarIsNull(Rgn) then
    begin
      Perform(EM_GETRECT, 0, lParam(@R));
      InflateRect(R, -5, -5);
      Perform(EM_SETRECTNP, 0, lParam(@R));
      SetWindowRgn(Handle, Rgn, True);
      Invalidate;
      Result := True;
    end;
  end;
end;

procedure TransparentPanel(var APanel: TPanel);
var
  X, Y : Integer;
  FullRgn, ClientRgn, ControlRgn : THandle;
  Margin, MarginX, MarginY : Integer;
begin
  Margin := (APanel.Width - APanel.ClientWidth) div 2;
  MarginX := Margin;
  MarginY := APanel.Height - APanel.ClientHeight - Margin;
  FullRgn := CreateRectRgn(0, 0, APanel.Width, APanel.Height);
  ClientRgn := CreateRectRgn(MarginX, MarginY, MarginX + APanel.ClientWidth, MarginY + APanel.ClientHeight);
  CombineRgn(FullRgn, FullRgn, ClientRgn, RGN_DIFF);
  for var I: Integer := 0 to Pred(APanel.ControlCount) do
  begin
    X := MarginX + APanel.Controls[I].Left;
    Y := MarginY + APanel.Controls[I].Top;
    ControlRgn := CreateRectRgn(X, Y, X + APanel.Controls[I].Width, Y + APanel.Controls[I].Height);
    CombineRgn(FullRgn, FullRgn, ControlRgn, RGN_OR);
  end;
  SetWindowRgn(APanel.Handle, FullRgn, True);
end;

(*
  AScale = 0 ~
  AEncodingMethod = 0 ~ 5
    0: Auto
    1: Numeric
    2: Alphanumeric
    3: ISO-8859-1
    4: UTF-8 without BOM
    5: UTF-8 without BOM
  AQuietZone = QR코드 테두리 여백(pixels))
*)
function GenerateQRCode(ABitmap: TBitmap; const AText: string; const AScale, AEncodingMethod, AQuietZone: Integer; var AErrMsg: string): Boolean;
var
  QRCode: TDelphiZXingQRCode;
  nRow, nCol: Integer;
begin
  Result := False;
  AErrMsg := '';
  QRCode := TDelphiZXingQRCode.Create;
  try
    try
      QRCode.Data := AText;
      QRCode.Encoding := TQRCodeEncoding(AEncodingMethod);
      QRCode.QuietZone := AQuietZone;
      ABitmap.SetSize(QRCode.Rows, QRCode.Columns);
      for nRow := 0 to Pred(QRCode.Rows) do
        for nCol := 0 to Pred(QRCode.Columns) do
          if (QRCode.IsBlack[nRow, nCol]) then
            ABitmap.Canvas.Pixels[nCol, nRow] := clBlack
          else
            ABitmap.Canvas.Pixels[nCol, nRow] := clWhite;
      ResizeBitmap(ABitmap, QRCode.Columns * AScale, QRCode.Rows * AScale, clWhite);
      Result := True;
    finally
      QRCode.Free;
    end;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

procedure FreeAndNilJSONObject(AObject: TJSONAncestor);
begin
  try
    if Assigned(AObject) then
    begin
      AObject.Owned := False;
      AObject.Free;
    end;
  except
  end;
end;

function GetProcessId(const AFilePath: string): NativeInt;
const
  PROCESS_TERMINATE = $0001;
var
  bContinue: BOOL;
  hSnapshot: THandle;
  PE32: TProcessEntry32;
begin
  Result := 0;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  PE32.dwSize := Sizeof(PE32);
  bContinue := Process32First(hSnapshot, PE32);
  while (Integer(bContinue) <> 0) do
  begin
    if ((UpperCase(ExtractFileName(PE32.szExeFile)) = UpperCase(AFilePath)) or
        (UpperCase(PE32.szExeFile) = UpperCase(AFilePath))) then
    begin
      Result := PE32.th32ProcessID;
      Exit;
    end
    else
      Result:=0;

    bContinue := Process32Next(hSnapshot, PE32);
  end;
  CloseHandle(hSnapshot);
end;

function GetProcessHandle(const AFilePath: string): NativeInt;
var
  PE32: TProcessEntry32;
  hSnapshot: THandle;
  sFileName: string;
begin
  Result := 0;
  sFileName := ExtractFileName(AFilePath);
  PE32.dwSize := SizeOf(TProcessEntry32);
  hSnapshot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Process32First(hSnapshot, PE32) then
  try
    repeat
      if CompareText(PE32.szExeFile, sFileName) = 0 then
      begin
        Result := hSnapshot;
        Break;
      end;
    until not Process32Next(hSnapshot, PE32);
  finally
    CloseHandle(hSnapshot);
  end;
end;

function KillProcess(const AProcName: string): Boolean;
var
  PE32: TProcessEntry32;
  hHandle, hProcess: THandle;
  bIsNext: Boolean;
begin
  Result := False;
  PE32.dwSize := SizeOf(TProcessEntry32);
  PE32.th32ProcessID := 0;
  hHandle :=CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    if Process32First(hHandle, PE32) then
      repeat
        bIsNext := Process32Next(hHandle, PE32);
        if (AnsiCompareText(PE32.szExeFile, Trim(AProcName)) = 0) then
          Break;
      until not bIsNext;
  finally
    CloseHandle(hHandle);
  end;

  if (PE32.th32ProcessID <> 0) then
  begin
    hProcess := OpenProcess(PROCESS_TERMINATE, True, PE32.th32ProcessID);
    try
      if (hProcess <> 0) then
        if not TerminateProcess(hProcess, 0) then
          Exit;

      Result := True;
    finally
      CloseHandle(hProcess);
    end;
  end;
end;

function KillProcessByHandle(const AHandle: NativeInt): Boolean;
var
  hPID: Integer;
  PH: HWND;
  DWResult: DWORD;
begin
  Result := False;
  {$WARN SYMBOL_PLATFORM OFF}SendMessageTimeout(AHandle, WM_CLOSE, 0, 0, SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult){$WARN SYMBOL_PLATFORM ON};
  if IsWindow(AHandle) then
  begin
    GetWindowThreadProcessId(AHandle, @hPID);
    if (hPID <> 0) then
    begin
      PH := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION, False, hPID);
      if (PH <> 0) then
      begin
        TerminateProcess(PH, 0);
        CloseHandle(PH);
        Result := True;
      end;
    end;
  end;
end;

function KillProcessByPID(const AProcessId: NativeInt): Boolean;
var
  hKiller: THandle;
begin
  hKiller := OpenProcess(PROCESS_TERMINATE, False, AProcessID);
  Result := TerminateProcess(hKiller, 0);
end;

function InvertColor(const Color: TColor): TColor;
begin
  Result := TColor(RGB(255 - GetRValue(Color), 255 - GetGValue(Color), 255 - GetBValue(Color)));
end;

function InvertColor2(const Color: TColor): TColor;
begin
  if ((GetRValue(Color) + GetGValue(Color) + GetBValue(Color)) > 384) then
    Result := clBlack
  else
    Result := clWhite;
end;

function GetMemoryUsed: UInt64;
var
  ST: TMemoryManagerState;
  SB: TSmallBlockTypeState;
begin
  {$WARN SYMBOL_PLATFORM OFF}GetMemoryManagerState(ST){$WARN SYMBOL_PLATFORM ON};
  Result := ST.TotalAllocatedMediumBlockSize + ST.TotalAllocatedLargeBlockSize;
  for SB in ST.SmallBlockTypeStates do
    Result := Result + SB.UseableBlockSize * SB.AllocatedBlockCount;
end;

function ReadMWord(FS: TFileStream): Word;
type
  TMotorolaWord = record
  case byte of
    0: (Value: Word);
    1: (Byte1, Byte2: Byte);
end;
var
  MW: TMotorolaWord;
begin
  FS.Read(MW.Byte2, SizeOf(Byte));
  FS.Read(MW.Byte1, SizeOf(Byte));
  Result := MW.Value;
end;

procedure GetJpgSize(const AFileName: string; var AWidth, AHeight: Integer);
const
  ValidSig : array[0..1] of Byte = ($FF, $D8);
  Parameterless = [$01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7];
var
  Sig: array[0..1] of byte;
  FS: TFileStream;
  Seg: Byte;
  Dummy: array[0..15] of Byte;
  Len: Word;
  ReadLen: LongInt;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  FS := TFileStream.Create(AFileName, fmOpenRead);
  try
    ReadLen := FS.Read(Sig[0], SizeOf(Sig));
    for var I: Integer := Low(Sig) to High(Sig) do
      if (Sig[I] <> ValidSig[I]) then
        ReadLen := 0;

    if (ReadLen > 0) then
    begin
      ReadLen := FS.Read(Seg, 1);
      while (Seg = $FF) and (ReadLen > 0) do
      begin
        ReadLen := FS.Read(Seg, 1);
        if (Seg <> $FF) then
        begin
          if (Seg = $C0) or (Seg = $C1) then
          begin
            ReadLen := FS.Read(Dummy[0], 3);
            AHeight := ReadMWord(FS);
            AWidth := ReadMWord(FS);
          end
          else
          begin
            if not (Seg in Parameterless) then
            begin
              Len := ReadMWord(FS);
              FS.Seek(Len - 2, 1);
              FS.Read(Seg, 1);
            end
            else
              Seg := $FF;
          end;
        end;
      end;
    end;
  finally
    FS.Free;
  end;
end;

procedure GetPngSize(const AFileName: string; var AWidth, AHeight: Integer);
type
  TPNGSig = array[0..7] of Byte;
const
  ValidSig: TPNGSig = (137, 80, 78, 71, 13, 10, 26, 10);
var
  Sig: TPNGSig;
  FS: TFileStream;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  FS := TFileStream.Create(AFileName, fmOpenRead);
  try
    FS.Read(Sig[0], SizeOf(Sig));
    for var I: Integer := Low(Sig) to High(Sig) do
      if (Sig[I] <> ValidSig[I]) then
        Exit;

      FS.Seek(18, 0);
      AWidth := ReadMWord(FS);
      FS.Seek(22, 0);
      AHeight := ReadMWord(FS);
  finally
    FS.Free;
  end;
end;

//ListView 순서 바꾸기
procedure ExchangeListItems(AListView: TListView; const AIndex1, AIndex2: Integer);
var
  LI: TListItem;
begin
  AListView.Items.BeginUpdate;
  try
    LI := TListItem.Create(AListView.Items);
    LI.Assign(AListView.Items.Item[AIndex1]);
    AListView.Items.Item[AIndex1].Assign(AListView.Items.Item[AIndex2]);
    AListView.Items.Item[AIndex2].Assign(LI);
    AListView.Selected := AListView.Items[AIndex2];
    LI.Free;
  finally
    AListView.Items.EndUpdate;
  end;
end;

procedure CopyDataString(const AHandle: HWND; const AMsg: Cardinal; const AData: string);
var
  CDS: TCopyDataStruct;
begin
  with CDS do
  begin
    cbData := Length(AData) + 1;
    lpData := pChar(AData + #0);
  end;
  SendMessage(AHandle, AMsg, 0, LongInt(@CDS));
end;

(***************************************************************************************************

function GetMyIP: string;

var
  IdIPWatch: TIdIPWatch;
begin
  IdIPWatch := TIdIPWatch.Create(nil);
  try
    Result := IdIPWatch.LocalIP;
  finally
    FreeAndNil(IdIPWatch);
  end;
end;


function MessageDlgEx(const AMsg: string; ADlgType: TMsgDlgType; AButtons: TMsgDlgButtons; AHelpContext: Integer): Integer;

begin
  Screen.MessageFont.Size := 12;
  Screen.MessageFont.Color := clRed;
  with CreateMessageDialog(AMsg, ADlgType, AButtons) do
  try
    Caption := 'XPartners';
    Color := clWhite;
    Font.Size := 10;
    Font.Color := clBlue;
    Font.Name := 'Noto Sans CJK KR Regular';
//    TButton(FindComponent('Message')).Font.Color := clLime;
//    TButton(FindComponent('Message')).Font.Size := 10;
//    TLabel(FindComponent('Message')).Font.Name := 'Noto Sans CJK KR Regular';
//    TLabel(FindComponent('Message')).Font.Size := 10;
//    TLabel(FindComponent('Message')).Font.Style := [fsBold];
    Result := ShowModal;
  finally
    Free;
  end;
end;

***************************************************************************************************)

end.
