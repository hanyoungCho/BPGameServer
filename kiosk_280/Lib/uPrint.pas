unit uPrint;

interface

uses
  System.SysUtils, Math, StrUtils, System.DateUtils,
  System.IOUtils, Winapi.Windows,
  fx.Json, Vcl.Forms, Vcl.StdCtrls, System.Classes,
  CPort, Generics.Collections;

const
  // 프린터 특수명령
  rptReceiptCharNormal    = '{N}';   // 일반 글자
  rptReceiptCharBold      = '{B}';   // 굵은 글자
  rptReceiptCharInverse   = '{I}';   // 역상 글자
  rptReceiptCharUnderline = '{U}';   // 밑줄 글자
  rptReceiptAlignLeft     = '{L}';   // 왼쪽 정렬
  rptReceiptAlignCenter   = '{C}';   // 가운데 정렬
  rptReceiptAlignRight    = '{R}';   // 오른쪽 정렬
  rptReceiptSizeNormal    = '{S}';   // 보통 크기
  rptReceiptSizeWidth     = '{X}';   // 가로확대 크기
  rptReceiptSizeHeight    = '{Y}';   // 세로확대 크기
  rptReceiptSizeBoth      = '{Z}';   // 가로세로확대 크기
  rptReceiptSize3Times    = '{3}';   // 가로세로3배확대 크기
  rptReceiptSize4Times    = '{4}';   // 가로세로4배확대 크기
  rptReceiptInit          = '{!}';   // 프린터 초기화
  rptReceiptCut           = '{/}';   // 용지커팅
  rptReceiptImage1        = '{*}';   // 그림 인쇄 1
  rptReceiptImage2        = '{@}';   // 그림 인쇄 2
  rptReceiptCashDrawerOpen= '{O}';   // 금전함 열기
  rptReceiptSpacingNormal = '{=}';   // 줄간격 보통
  rptReceiptSpacingNarrow = '{&}';   // 줄간격 좁음
  rptReceiptSpacingWide   = '{\}';   // 줄간격 넓음
  rptLF                   = '{-}';   // 줄바꿈
  rptLF2                  = #13#10;  // 줄바꿈
  rptBarCodeBegin128      = '{<}';   // 바코드 출력 시작 CODE128
  rptBarCodeBegin39       = '{[}';   // 바코드 출력 시작 CODE39
  rptBarCodeEnd           = '{>}';   // 바코드 출력 끝
  // 프린터 출력명령 (영수증 별도 출력에서 사용함)
  rptReceiptCharSaleDate  = '{D}';   // 판매일자
  rptReceiptCharPosNo     = '{P}';   // 포스번호
  rptReceiptCharPosName   = '{Q}';   // 포스명
  rptReceiptCharBillNo    = '{A}';   // 빌번호
  rptReceiptCharDateTime  = '{E}';   // 출력일시

  RECEIPT_TITLE1          = '메뉴명                      단가 수량       금액';
  RECEIPT_TITLE2          = '메뉴명                단가 수량       금액';
	RECEIPT_TITLE3          = '사용자    게임수   레인   볼링화      금액';
	RECEIPT_TITLE4          = '사용자   게임시간  레인   볼링화      금액'; //배정표에 금액표시 필요한가?
  RECEIPT_LINE1           = '------------------------------------------------';
  RECEIPT_LINE2           = '------------------------------------------';
  RECEIPT_LINE3           = '================================================';
  RECEIPT_LINE4           = '==========================================';

type

  TOpenPort = function(PortName: AnsiString; Gubun, Code: Integer): Integer; stdcall;
  TClose = function(): Integer; stdcall;
  TStatus = function(ATimeOut: Integer): Integer; stdcall;

  TPayType = (None, Cash, Card, Payco, Void);

  TPrintThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    ReceiptList: TList<string>;
    AssignReceiptList: TList<string>;
    constructor Create;
    destructor Destroy; override;
  end;

  TStoreInfo = class(TJson)
    StoreName: string;               // 매장명
    BizNo: string;                   // 사업자번호
    BossName: string;                // 업주명
    Tel: string;                     // 전화번호
    Addr: string;                    // 주소
  end;

  TOrderInfo = class(TJson)
    Name: string;          // 사용자명
    GameCnt: string;            // 게임수
    LaneNm: string;               // 레인번호
    ShoesYn: string;                 // 볼링화
    Price: string;            // 금액
  end;

  TReceiptMemberInfo = class(TJson)
    Name: string;                    // 회원명
    Code: string;                    // 회원코드
    Tel: string;                     // 전화번호
    CarNo: string;                   // 차량번호
    CardNo: string;                  // 회원카드번호
    MemberXGOLF: Boolean;            // XGOLF 회원 유무
    XGolfDiscountAmt: Integer;       // XGOLF 할인 금액
  end;

  TProductInfo = class(TJson)
    Name: string;                    // 상품명
    Code: string;                    // 상품코드
    Price: Integer;                  // 판매금액(1EA 단가)
    Vat: Integer;                    // 부가세금액(1EA 부가세)
    Qty: Integer;                    // 총 수량
  end;

  TDiscountInfo = class(TJson)
    Name: string;                    // 할인명
    QRCode: string;                  // QR Code
    Value: string;                   // 할인금액
  end;

  TPayInfo = class(TJson)
    &PayCode: TPayType;              // 결제타입
    Approval: Boolean;               // 승인유무 T: 승인 F: 취소
    Internet: Boolean;               // 인터넷 승인 유무
    ApprovalAmt: Integer;            // 승인금액
    ApprovalNo: string;              // 승인번호
    OrgApprovalNo: string;           // 원 승인번호
    CardNo: string;                  // 카드번호
    CashReceiptPerson: Integer;      // 소득공제 1: 개인, 2: 사업자
    HalbuMonth: string;              // 할부개월

    CompanyName: string;             // PAYCO 승인기관
    MerchantKey: string;             // 가맹번호
    TransDateTime: string;           // 승인일시
    BuyCompanyName: string;          // 매입사
    BuyTypeName: string;             // 매입처
    CardDiscount: Integer;           // 카드사 할인
  end;

  TReceiptEtc = class(TJson)
    RcpNo: Integer;
    SaleDate: string;                // 판매일자 (금일)
    ReturnDate: string;              // 반품일자 (반품시 원판매일자)
    RePrint: Boolean;                // 재발행 여부
    TotalAmt: Integer;               // 상품판매시 총 판매금액
    DCAmt: Integer;                  // 할인금액
    Receipt_No: string;              // 영수증번호(바코드)
    Top1: string;                    // 상단문구1
    Top2: string;                    // 상단문구2
    Top3: string;                    // 상단문구3
    Top4: string;                    // 상단문구4
    Bottom1: string;                 // 하단문구1
    Bottom2: string;                 // 하단문구2
    Bottom3: string;                 // 하단문구3
    Bottom4: string;                 // 하단문구4
    SaleUpload: string;
  end;

  TReceipt = class(TJson)
  private
  public
    StoreInfo: TStoreInfo;
    //OrderList: TArray<TOrderInfo>;
    //ReceiptMemberInfo: TReceiptMemberInfo;
    ProductInfo: TArray<TProductInfo>;
    PayInfo: TArray<TPayInfo>;
    //DiscountInfo: TArray<TDiscountInfo>;
    ReceiptEtc: TReceiptEtc;
    constructor Create;
    destructor Destroy; override;

    procedure Load(AJsonText: string);
  end;

  TAssignReceipt = class(TJson)
  private
  public
    AssignNo: String;
    OrderList: TArray<TOrderInfo>;
    //ReceiptMemberInfo: TReceiptMemberInfo;
    constructor Create;
    destructor Destroy; override;

    procedure Load(AJsonText: string);
  end;

  TReceiptPrint = class
  private
    FPrintThread: TPrintThread;
    FComPort: TComPort;
    Receipt: TReceipt;
    AssignReceipt: TAssignReceipt;
    FIsReturn: Integer;
    FInt_37: Integer;
    FInt_11: Integer;
    FInt_48: Integer;
    FInt_33: Integer;
    FInt_15: Integer;

    FHandel: THandle;

    Exec_Open: TOpenPort;
    Exec_Close: TClose;
    Exec_Status: TStatus;

    FPrintStatus: String;
    FComPortNo: Integer;

    function LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function SCopy(S: AnsiString; F, L: Integer): string;
    function PadChar(ALength: Integer; APadChar: Char = ' '): string;
    function ByteLen(const AText: string): Integer;
    function GetCurrStr(AData: Currency): string;
    function DateTimeStrToString(const ADateTime: string): string;
    function CheckEnumComPorts(APort: Integer): Boolean;
  public
    constructor Create(APort: Integer; ABaudRate: TBaudRate);
    destructor Destroy; override;

    function ReceiptPrint(AJsonText: string): Boolean;
    function AssignReceiptPrint(AJsonText: string): Boolean;
    function SetReceiptPrint: Boolean;
    function SetLaneGamePrint: Boolean;

    function Print(APrintData: string): Boolean;

    function ReceiptHeader: string;
    function ReceiptItemList: string;
    function ReceiptTotalAmt: string;
    function ReceiptPayList: string;
    function ReceiptPayListInfo: string;
    //function ReceiptDiscountInfo: string;
    function ReceiptBottom: string;
    function MakeNewPayCoData(APayInfo: TPayInfo): string;  // NewPayCo정보

    function ConvertPrintData(AData: string): string;
    function ConvertBarCodeCMD(AData: string): string;

    //chy sewoo -> 프린터출력시 응답값 없음
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure SewooStatus;

    property ComPort: TComPort read FComPort write FComPort;
    property IsReturn: Integer read FIsReturn write FIsReturn;
    property Int_37: Integer read FInt_37 write FInt_37;
    property Int_11: Integer read FInt_11 write FInt_11;
    property Int_48: Integer read FInt_48 write FInt_48;
    property Int_33: Integer read FInt_33 write FInt_33;
    property Int_15: Integer read FInt_15 write FInt_15;

    //chy sewoo
    property PrintStatus: String read FPrintStatus write FPrintStatus;

    property PrintThread: TPrintThread read FPrintThread write FPrintThread;
  end;

implementation

uses
  uGlobal, fx.Logging, uConsts;

function StringToHex(const S: string): string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 1 to Length(S) do
    Result := Result + IntToHex( Byte( S[Index] ), 2 );
end;

function HexToBin(const Hexadecimal: string): string;
const
  BCD: array[0..15] of string =
  ('0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111',
    '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111');
var
  I: integer;
begin
  for I := Length(Hexadecimal) downto 1 do
    Result := BCD[StrToInt('$' + Hexadecimal[I])] + Result;
end;

{ TReceiptPrint }

function TReceiptPrint.ConvertBarCodeCMD(AData: string): string;
const
  BAR_HEIGHT = #$50; // 바코드높이
  BAR_CODE39 = #69;
  BAR_ITF = #70;
  BAR_CODABAR = #71;
  BAR_CODE93 = #72;
  BAR_CODE128 = #$49; //#73;
var
  BeginPos128, BeginPos39, BeginPos, EndPos: Integer;
  ChkBarCode39: Boolean;
  ALen: Char;
  BarCodeOrg, BarCodeToStr: string;
begin
  while Pos(rptBarCodeEnd, AData) > 0 do
  begin
    BeginPos128 := Pos(rptBarCodeBegin128, AData);
    BeginPos39 := Pos(rptBarCodeBegin39, AData);
    BeginPos := Min(BeginPos128, BeginPos39);
    if BeginPos128 = 0 then
      BeginPos := BeginPos39;
    if BeginPos39 = 0 then
      BeginPos := BeginPos128;
    ChkBarCode39 := BeginPos = BeginPos39;
    EndPos := Pos(rptBarCodeEnd, AData);

    if BeginPos <= 0 then
      Break;
    if EndPos <= 0 then
      Break;
    if BeginPos >= EndPos then
      Break;

    BarCodeOrg := Copy(AData, BeginPos + 3, EndPos - BeginPos - 3);

    // CODE39 이면
    if ChkBarCode39 then
    begin
      ALen := Char(Length(BarCodeOrg));
      BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE39 + ALen + BarCodeOrg;
    end
    else
    // CODE128 이면
    begin
      ALen := Char(Length(BarCodeOrg) + 2); // 2 를 더해야 함
      BarCodeToStr := #$1D#$68 + BAR_HEIGHT + #$1D#$77#$02#$1B#$61#$01#$1D#$48#$02#$1D#$6B + BAR_CODE128 + ALen + #$7B#$42 + BarCodeOrg;
                    //#$1D#$68 +  #$30      + #$1D#$77#$01#$1B#$61#$01 + #$1D#$48#$02 + #$1D#$6B + BAR_CODE128 + #$10 + #$7B#$42 + BarCodeOrg;
    end;
    if ChkBarCode39 then
      AData := ReplaceStr(AData, rptBarCodeBegin39 + BarCodeOrg + rptBarCodeEnd, BarCodeToStr)
    else
      AData := ReplaceStr(AData, rptBarCodeBegin128 + BarCodeOrg + rptBarCodeEnd, BarCodeToStr);
  end;
  Result := AData;
end;

function TReceiptPrint.ConvertPrintData(AData: string): string;
begin
  Result := AData;
  Result := ReplaceStr(Result, rptReceiptCharBold,      #27#71#1);
  Result := ReplaceStr(Result, rptReceiptCharInverse,   #29#66#1);
  Result := ReplaceStr(Result, rptReceiptCharUnderline, #27#45#1);
  Result := ReplaceStr(Result, rptReceiptAlignLeft,     #27#97#0);
  Result := ReplaceStr(Result, rptReceiptAlignCenter,   #27#97#1);
  Result := ReplaceStr(Result, rptReceiptAlignRight,    #27#97#2);
//  if Global.Config.OAuth.DeviceID = 'T000100001' then
    Result := ReplaceStr(Result, rptReceiptCut,           #27#109);   // 반컷 109
//  else
//    Result := ReplaceStr(Result, rptReceiptCut,           #27#105);
  Result := ReplaceStr(Result, rptReceiptInit,          #27#64);
//  Result := ReplaceStr(Result, rptReceiptCut,           #27#109);   // 반컷 109
//  Result := ReplaceStr(Result, rptReceiptCut,           #29#86#1); // #29#86#1 반컷팅 #29#86#0 풀컷팅
  Result := ReplaceStr(Result, rptReceiptImage1,        #13#28#112#1#0);
  Result := ReplaceStr(Result, rptReceiptImage2,        #13#28#112#2#0);
  Result := ReplaceStr(Result, rptReceiptCashDrawerOpen,#27'p'#0#25#250#13#10);
  Result := ReplaceStr(Result, rptReceiptSpacingNormal, #27#51#60);
  Result := ReplaceStr(Result, rptReceiptSpacingNarrow, #27#51#50);
  Result := ReplaceStr(Result, rptReceiptSpacingWide,   #27#51#120);
  Result := ReplaceStr(Result, rptLF,                   #13#10);

  Result := ReplaceStr(Result, rptReceiptSize3Times,    #29#33#34);
  Result := ReplaceStr(Result, rptReceiptSize4Times,    #29#33#51);
  Result := ReplaceStr(Result, rptReceiptSizeNormal,    #27#33#0);
  Result := ReplaceStr(Result, rptReceiptSizeWidth,     #27#33#32);
  Result := ReplaceStr(Result, rptReceiptSizeHeight,    #27#33#16);
  Result := ReplaceStr(Result, rptReceiptSizeBoth,      #27#33#48);

  Result := ReplaceStr(Result, rptReceiptCharNormal,    EmptyStr);
  Result := ConvertBarCodeCMD(Result);
end;

constructor TReceiptPrint.Create(APort: Integer; ABaudRate: TBaudRate);
begin
  ComPort := TComPort.Create(nil);
  ComPort.Port := 'COM' + IntToStr(APort);
  ComPort.BaudRate := ABaudRate;
  ComPort.OnRxChar := ComPortRxChar;
  FComPortNo := APort;

  if CheckEnumComPorts(APort) then
    ComPort.Open
  else
    Exit;

  Int_37 := 33;
  Int_11 := 9;
  Int_48 := 42;
  Int_33 := 29;
  Int_15 := 13;

  PrintThread := TPrintThread.Create;
end;

function TReceiptPrint.CheckEnumComPorts(APort: Integer): Boolean;
var
  KeyHandle: HKEY;
  ErrCode, Index: Integer;
  ValueName, Data: string;
  ValueLen, DataLen, ValueType: DWORD;
  TmpPorts: TStringList;
begin
  Result := False;
  ErrCode := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'HARDWARE\DEVICEMAP\SERIALCOMM', 0, KEY_READ, KeyHandle);

  if ErrCode <> ERROR_SUCCESS then
  begin
    //raise EComPort.Create(CError_RegError, ErrCode);
    Exit;
  end;

  TmpPorts := TStringList.Create;
  try
    Index := 0;
    repeat
      ValueLen := 256;
      DataLen := 256;
      SetLength(ValueName, ValueLen);
      SetLength(Data, DataLen);
      ErrCode := RegEnumValue(
        KeyHandle,
        Index,
        PChar(ValueName),
        {$IFDEF DELPHI_4_OR_HIGHER}
        Cardinal(ValueLen),
        {$ELSE}
        ValueLen,
          {$ENDIF}
        nil,
        @ValueType,
        PByte(PChar(Data)),
        @DataLen);

      if ErrCode = ERROR_SUCCESS then
      begin
        SetLength(Data, DataLen - 1);
        TmpPorts.Add(Data);
        Inc(Index);
      end
      else
        if ErrCode <> ERROR_NO_MORE_ITEMS then break;
          //raise EComPort.Create(CError_RegError, ErrCode);

    until (ErrCode <> ERROR_SUCCESS) ;

    TmpPorts.Sort;

    for Index := 0 to TmpPorts.Count - 1 do
    begin
      if StrToInt(StringReplace(UpperCase(TmpPorts[Index]), 'COM', '', [rfReplaceAll])) = APort then
        Result := True;
    end;

  finally
    RegCloseKey(KeyHandle);
    TmpPorts.Free;
  end;
end;

destructor TReceiptPrint.Destroy;
begin
  ComPort.Free;
  if PrintThread <> Nil then
    PrintThread.Terminate;
  inherited;
end;

function TReceiptPrint.MakeNewPayCoData(APayInfo: TPayInfo): string;
resourcestring
  STR_POINT = '페이코포인트';
  STR_COUPON = '페이코쿠폰';
  STR_CARD = '신용카드';
  STR1 = '***승인정보(고객용)***';
  STR2 = '승인기관     :';
  STR3 = '신용카드번호 :';
  STR4 = '할부개월     :';
  STR5 = '승인번호     :';
  STR6 = '승인일시     :';
  STR7 = '가맹번호     :';
  STR8 = '매입사       :';
  STR9 = '매입처       :';
  STR10 = '***OK 캐쉬백 포인트 내역***';
  STR11 = '적립포인트          :';
  STR12 = '사용가능 적립포인트 :';
  STR13 = '누적 적립포인트     :';
  STR14 = '일시불';
  STR15 = ' 개월';
  STR16 = '티머니카드번호 :';
  STR17 = '결제전잔액   :';
  STR18 = '결제금액     :';
  STR19 = '결제후잔액   :';
  STR20 = '- PAYCO 승인정보 -';
  STR21 = '- PAYCO 취소정보 -';
  STR22 = '***승인취소정보(고객용)***';
  STR23 = '쿠폰이름     :';
var
  Index, ASaleSign: Integer;
begin//
  Result := EmptyStr;

  if APayInfo.Approval then
    ASaleSign := 1
  else
    ASaleSign := -1;

//  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF2;
  Result := Result + rptReceiptAlignCenter + IfThen(APayInfo.Approval, STR20, STR21) + rptLF2;

  Result := Result + RPadB(STR_CARD, Int_33, ' ') + LPadB(GetCurrStr(ASaleSign * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2;
  Result := Result + rptReceiptCharNormal;

  Result := Result + rptReceiptAlignCenter;//rptReceiptAlignLeft;
  Result := Result + RECEIPT_LINE2 + rptLF2;
  Result := Result + rptReceiptAlignCenter + IfThen(APayInfo.Approval, STR1, STR22) + rptLF2;
  Result := Result + rptReceiptAlignCenter;//rptReceiptAlignLeft;
  Result := Result + RPadB(STR2, Int_15, ' ') + LPadB(APayInfo.CompanyName, Int_33, ' ') + rptLF2;
  Result := Result + RPadB(STR3, Int_15, ' ') + LPadB(APayInfo.CardNo, Int_33, ' ') + rptLF2;
  if StrToIntDef(APayInfo.HalbuMonth, 0) = 0 then
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(STR14, Int_33, ' ') + rptLF2
  else
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(APayInfo.HalbuMonth + STR15, Int_33, ' ') + rptLF2;

  Result := Result + RPadB(STR5, Int_15, ' ') + LPadB(APayInfo.ApprovalNo, Int_33, ' ') + rptLF2;
  Result := Result + RPadB(STR6, Int_15, ' ') + LPadB(DateTimeStrToString(APayInfo.TransDateTime), Int_33, ' ') + rptLF2;

  Result := Result + RPadB(STR7, Int_15, ' ') + LPadB(APayInfo.MerchantKey, Int_33, ' ') + rptLF2;
  Result := Result + RPadB(STR8, Int_15, ' ') + LPadB(APayInfo.BuyCompanyName, Int_33, ' ') + rptLF2;
  Result := Result + RPadB(STR9, Int_15, ' ') + LPadB(APayInfo.BuyTypeName, Int_33, ' ') + rptLF2;
end;






function TReceiptPrint.ReceiptPrint(AJsonText: string): Boolean;
begin
  Log.D('TReceiptPrint.ReceiptPrint', 'Begin');
  try
    try
      Receipt := TReceipt.Create;
      Receipt.Load(AJsonText);

      IsReturn := IfThen(Trim(Receipt.ReceiptEtc.ReturnDate) = EmptyStr, 1, -1);
      SetReceiptPrint;
    except
      on E: Exception do
      begin
        Log.E('TReceiptPrint.ReceiptPrint', E.Message);
      end;
    end;
  finally
    Receipt.Free;
    Log.D('TReceiptPrint.ReceiptPrint', 'End');
  end;
end;

function TReceiptPrint.AssignReceiptPrint(AJsonText: string): Boolean;
begin
  Log.D('TReceiptPrint.AssignReceiptPrint', 'Begin');
  try
		try
			AssignReceipt := TAssignReceipt.Create;
			AssignReceipt.Load(AJsonText);
			//IsReturn := IfThen(Trim(Receipt.ReceiptEtc.ReturnDate) = EmptyStr, 1, -1);
			SetLaneGamePrint;
    except
      on E: Exception do
      begin
        Log.E('TReceiptPrint.AssignReceiptPrint', E.Message);
      end;
    end;
  finally
    Receipt.Free;
    Log.D('TReceiptPrint.AssignReceiptPrint', 'End');
  end;
end;

function TReceiptPrint.SetReceiptPrint: Boolean;
var
  PrintData: string;
begin
  PrintData := EmptyStr;

  PrintData := PrintData + rptReceiptInit;
  PrintData := PrintData + ReceiptHeader;
  PrintData := PrintData + ReceiptItemList;
  PrintData := PrintData + ReceiptTotalAmt;
  PrintData := PrintData + ReceiptPayList;
  PrintData := PrintData + ReceiptPayListInfo;
  //PrintData := PrintData + ReceiptDiscountInfo;
  PrintData := PrintData + ReceiptBottom;

  Result := Print(PrintData);
end;


function TReceiptPrint.ReceiptHeader: string;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + rptReceiptSizeWidth;
  Result := Result + '영 수 증' + rptLF2 + rptLF2;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignCenter;
  {
  Result := Result + RPadB('매 장 명 : ' + Receipt.StoreInfo.StoreName, Int_48, ' ') + rptLF2;
  Result := Result + RPadB('대표자명 : ' + Receipt.StoreInfo.BossName, Int_48, ' ') + rptLF2;
  Result := Result + RPadB('전화번호 : ' + Receipt.StoreInfo.Tel, Int_48, ' ') + rptLF2;
  Result := Result + RPadB('매장주소 : ' + SCopy(Receipt.StoreInfo.Addr, 1, 36), Int_48, ' ') + rptLF2;
  Result := Result + RPadB('           ' + SCopy(Receipt.StoreInfo.Addr, 37, Length(Receipt.StoreInfo.Addr)), Int_48, ' ') + rptLF2;
  Result := Result + RPadB('사업자번호 : ' + Receipt.StoreInfo.BizNo, Int_48, ' ') + rptLF2;
  }
  Result := Result + RPadB('출력시각 : ' + FormatDateTime('yyyy-mm-dd hh:nn', now), Int_48, ' ') + rptLF2;

  if Receipt.ReceiptEtc.Top1 <> EmptyStr then
    Result := Result + RPadB(Receipt.ReceiptEtc.Top1, Int_48, ' ') + rptLF2;
  if Receipt.ReceiptEtc.Top2 <> EmptyStr then
    Result := Result + RPadB(Receipt.ReceiptEtc.Top2, Int_48, ' ') + rptLF2;
  if Receipt.ReceiptEtc.Top3 <> EmptyStr then
    Result := Result + RPadB(Receipt.ReceiptEtc.Top3, Int_48, ' ') + rptLF2;
  if Receipt.ReceiptEtc.Top4 <> EmptyStr then
    Result := Result + RPadB(Receipt.ReceiptEtc.Top4, Int_48, ' ') + rptLF2;

end;

function TReceiptPrint.ReceiptItemList: string;
var
  Index: Integer;
  AProductInfo: TProductInfo;
begin
  Result := Result + RECEIPT_LINE4 + rptLF2;
  //Result := Result + RECEIPT_TITLE2 + rptLF2;
  //Result := Result + RECEIPT_LINE4 + rptLF2;

  for Index := 0 to Length(Receipt.ProductInfo) - 1 do
  begin
    AProductInfo := Receipt.ProductInfo[Index];
    Result := Result + RPadB(AProductInfo.Name, Int_33, ' ') + LPadB(AProductInfo.Code, Int_15, ' ') + rptLF2;
  end;
end;


function TReceiptPrint.ReceiptTotalAmt: string;
var
  AVat: Integer;
begin

  //AVat := (Receipt.ReceiptEtc.TotalAmt - Receipt.ReceiptEtc.DCAmt) - Trunc((Receipt.ReceiptEtc.TotalAmt - Receipt.ReceiptEtc.DCAmt) / 1.1);
  Result := EmptyStr;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + RECEIPT_LINE2 + rptLF2 + rptLF2;
  {
  Result := Result + rptReceiptSizeWidth;                        // 16
  Result := Result + Format('판매금액%13s', [FormatFloat('#,##0.##', (IsReturn * Receipt.ReceiptEtc.TotalAmt))]) + rptLF2;
  Result := Result + rptReceiptSizeNormal;
  if Receipt.ReceiptEtc.DCAmt <> 0 then
    Result := Result + LPadB('할인금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', (IsReturn * Receipt.ReceiptEtc.DCAmt)), Int_11, ' ') + rptLF2;
  Result := Result + LPadB('과세상품금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', (IsReturn * ((Receipt.ReceiptEtc.TotalAmt - Receipt.ReceiptEtc.DCAmt) - AVat))), Int_11, ' ') + rptLF2;
  Result := Result + LPadB('부가세(VAT)금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', (IsReturn * AVat)), Int_11, ' ') + rptLF2;
  Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF2;
  }
  Result := Result + rptReceiptSizeWidth;
  Result := Result + Format('총 결제금액%8s원', [FormatFloat('#,##0.##', (IsReturn * (Receipt.ReceiptEtc.TotalAmt - Receipt.ReceiptEtc.DCAmt)))]) + rptLF2 + rptLF2;
  Result := Result + rptReceiptSizeNormal;
end;


function TReceiptPrint.ReceiptPayList: string;
var
  Index: Integer;
  CashStr: string;
  APayInfo: TPayInfo;
begin
  Result := EmptyStr;
  for Index := 0 to Length(Receipt.PayInfo) - 1 do
  begin
    APayInfo := Receipt.PayInfo[Index];
    if APayInfo.PayCode = Cash then
    begin
      if APayInfo.Internet and (APayInfo.ApprovalNo <> EmptyStr) then
      begin
        if Trim(APayInfo.OrgApprovalNo) = EmptyStr then
          Result := Result + LPadB('현금영수증(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2
        else
          Result := Result + LPadB('현금영수증(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', (-1 * APayInfo.ApprovalAmt)), Int_15, ' ') + rptLF2;
      end
      else
      begin
//        CashStr := IfThen(APayInfo.Approval, '승인', '취소');
        CashStr := '수기등록';
        Result := Result + LPadB('현금(' + CashStr + ')', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', IfThen(APayInfo.Approval, 1, -1) * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2;
      end;
    end;

    if APayInfo.PayCode = Card then
    begin
      if APayInfo.Internet then
      begin
        if APayInfo.Approval then
          Result := Result + LPadB('신용카드(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2
        else
          Result := Result + LPadB('신용카드(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', -1 * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2;
      end
      else
      begin
        Result := Result + LPadB('카드(수기등록)', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', IfThen(APayInfo.Approval, 1, -1) * APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2;
      end;
    end;

    if APayInfo.PayCode = Payco then
    begin
      if APayInfo.Approval then
        Result := Result + LPadB('PAYCO(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', (IsReturn * APayInfo.ApprovalAmt)), Int_15, ' ') + rptLF2
      else
        Result := Result + LPadB('PAYCO(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', (IsReturn * APayInfo.ApprovalAmt)), Int_15, ' ') + rptLF2;
    end;
  end;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + RECEIPT_LINE2 + rptLF2;
end;


function TReceiptPrint.ReceiptPayListInfo: string;
var
  Index: Integer;
  CashMsg: string;
  APayInfo: TPayInfo;
begin
  Result := EmptyStr;

  with Receipt do
  begin
    for Index := 0 to Length(PayInfo) - 1 do
    begin
      APayInfo := PayInfo[Index];
      if APayInfo.PayCode = Cash then
      begin
        if Trim(APayInfo.ApprovalNo) <> EmptyStr then
        begin
          CashMsg := IfThen(APayInfo.CashReceiptPerson = 1, '(소득공제)', '(지출증빙)');
          Result := Result + rptReceiptAlignCenter + '';
          Result := Result + IfThen(APayInfo.Approval, '<현금영수증' + CashMsg + ' 승인내역>', '<현금영수증' + CashMsg + ' 취소내역>') + rptLF2;
          Result := Result + RECEIPT_LINE4 + rptLF2;
          Result := Result + rptReceiptAlignCenter{rptReceiptAlignLeft} + rptReceiptCharNormal;
          Result := Result + RPadB('승인금액', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2;
          Result := Result + RPadB('승인번호', Int_33, ' ') + LPadB(APayInfo.ApprovalNo, Int_15, ' ') + rptLF2;
          Result := Result + RPadB('카드번호', Int_33, ' ') + LPadB(APayInfo.CardNo, Int_15, ' ') + rptLF2;
        end;
      end;

      if APayInfo.PayCode = Card then
      begin
        Result := Result + rptReceiptAlignCenter;
        Result := Result + IfThen(APayInfo.Approval, '<카드 승인내역>', '<카드 취소내역>') + rptLF2;
        Result := Result + RECEIPT_LINE4 + rptLF2;
        Result := Result + rptReceiptAlignCenter{rptReceiptAlignLeft} + rptReceiptCharNormal;
        Result := Result + RPadB('승인금액', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.ApprovalAmt), Int_15, ' ') + rptLF2;

        if APayInfo.HalbuMonth = '0' then
          Result := Result + RPadB('할부개월', Int_33, ' ') + LPadB('일시불', Int_15, ' ') + rptLF2
        else
          Result := Result + RPadB('할부개월', Int_33, ' ') + LPadB(APayInfo.HalbuMonth  + '개월', Int_15, ' ') + rptLF2;
        Result := Result + RPadB('발 급 사', Int_33, ' ') + LPadB(APayInfo.BuyCompanyName, Int_15, ' ') + rptLF2;
        Result := Result + RPadB('승인번호', Int_33, ' ') + LPadB(APayInfo.ApprovalNo, Int_15, ' ') + rptLF2;
        Result := Result + RPadB('카드번호', Int_33, ' ') + LPadB(APayInfo.CardNo, Int_15, ' ') + rptLF2;
//        if APayInfo.CardDiscount <> 0 then
//        begin
//          Result := Result + RPadB('할인내역', Int_33, ' ') + LPadB(APayInfo.BuyCompanyName + ' 제휴할인', Int_15, ' ') + rptLF2;
//          Result := Result + RPadB('할인금액', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', APayInfo.CardDiscount), Int_15, ' ') + rptLF2;
//        end;
      end;

      if APayInfo.PayCode = Payco then
        Result := Result + MakeNewPayCoData(APayInfo);
    end;
    Result := Result + RECEIPT_LINE2 + rptLF2;
  end;
end;

{
function TReceiptPrint.ReceiptDiscountInfo: string;
var
  Index: Integer;
begin
  try
    Result := EmptyStr;

    if (Length(Receipt.DiscountInfo) <> 0) or (Receipt.ReceiptMemberInfo.XGolfDiscountAmt <> 0) then
    begin
      Result := Result + rptReceiptAlignCenter + '<할인내역>' + rptLF;
      Result := Result + rptReceiptAlignCenter;//rptReceiptAlignLeft;
      Result := Result + RECEIPT_LINE4 + rptLf2;
      if Receipt.ReceiptMemberInfo.MemberXGOLF and (Receipt.ReceiptMemberInfo.XGolfDiscountAmt <> 0) then
      begin
        Result := Result + RPadB('할인종류', Int_33 - 10, ' ') + LPadB('XGOLF 회원 할인', Int_15 + 10, ' ') + rptLF2;
        Result := Result + RPadB('승인금액', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', Receipt.ReceiptMemberInfo.XGolfDiscountAmt), Int_15, ' ') + rptLF2;
      end;

      // 웰빙클럽 회원

      for Index := 0 to Length(Receipt.DiscountInfo) - 1 do
      begin
        if Receipt.DiscountInfo[Index].Name = '웰빙클럽 회원' then
        begin
//          Result := Result + rptReceiptAlignCenter + Format('---- %s ----', [Receipt.DiscountInfo[Index].Name]) + rptLF;
          Result := Result + rptReceiptAlignLeft;
          Result := Result + RPadB('웰빙클럽 회원할인', Int_33 - 9, ' ') + LPadB(FormatFloat('#,##0.##', Receipt.ReceiptEtc.TotalAmt - Receipt.ReceiptEtc.DCAmt), Int_15 + 9, ' ') + rptLF2;
//          Result := Result + RPadB('회원코드', Int_33 - 9, ' ') + LPadB(Receipt.DiscountInfo[Index].QRCode, Int_15 + 9, ' ') + rptLF2;
//          Result := Result + RPadB('회원번호', Int_33 - 9, ' ') + LPadB(Receipt.DiscountInfo[Index].Value, Int_15 + 9, ' ') + rptLF2;
        end
        else
        begin
          if StrToIntDef(Receipt.DiscountInfo[Index].Value, 0) = 0 then
            Continue;

          Result := Result + RPadB('할인종류', Int_33 - 10, ' ') + LPadB(Receipt.DiscountInfo[Index].Name, Int_15 + 10, ' ') + rptLF2;
          Result := Result + RPadB('승인금액', Int_33, ' ') +
            LPadB(FormatFloat('#,##0.##', StrToInt(Receipt.DiscountInfo[Index].Value)), Int_15, ' ') + rptLF2;
        end;
      end;

      if Length(Receipt.PayInfo) <> 0 then
      begin
        if Receipt.PayInfo[0].PayCode = Card then
        begin
          if Receipt.PayInfo[0].CardDiscount <> 0 then
          begin
            Result := Result + RPadB('할인종류', Int_33 - 10, ' ') + LPadB(Receipt.PayInfo[0].BuyCompanyName, Int_15 + 10, ' ') + rptLF2;
            Result := Result + RPadB('승인금액', Int_33, ' ') +
              LPadB(FormatFloat('#,##0.##', Receipt.PayInfo[0].CardDiscount), Int_15, ' ') + rptLF2;
          end;
        end;
      end;

      Result := Result + RECEIPT_LINE2 + rptLF2;
    end;
  finally

  end;
end;
}

function TReceiptPrint.ReceiptBottom: string;
begin
  Result := EmptyStr;
  Result := Result + rptReceiptSizeNormal;

  Result := Result + rptBarCodeBegin128;
  Result := Result + Receipt.ReceiptEtc.Receipt_No;
  Result := Result+ rptBarCodeEnd + rptLF;

  if Receipt.ReceiptEtc.Bottom1 <> EmptyStr then
    Result := Result + Receipt.ReceiptEtc.Bottom1 + rptLF2;
  if Receipt.ReceiptEtc.Bottom2 <> EmptyStr then
    Result := Result + Receipt.ReceiptEtc.Bottom2 + rptLF2;
  if Receipt.ReceiptEtc.Bottom3 <> EmptyStr then
    Result := Result + Receipt.ReceiptEtc.Bottom3 + rptLF2;
  if Receipt.ReceiptEtc.Bottom4 <> EmptyStr then
    Result := Result + Receipt.ReceiptEtc.Bottom4 + rptLF2;

  if Receipt.ReceiptEtc.SaleUpload = 'Y' then
  begin
    Result := Result + '매출업로드에 실패하였습니다.' + #13#10 + rptLF2;
    Result := Result + '관리자에게 문의 바랍니다..' + #13#10 + rptLF2;
  end
  else
  begin
    Result := Result + rptReceiptAlignCenter;
    Result := Result + '취소 문의는 프론트로 방문해 주세요.' + rptLF;
    Result := Result + '이용해 주셔서 감사합니다.' + rptLF;
  end;
  Result := Result + RECEIPT_LINE4 + rptLf2;

  if Receipt.ReceiptEtc.RePrint then
  begin
    Result := Result + rptReceiptAlignCenter + '재발행된 영수증 입니다.' + rptLF2;
    Result := Result + rptReceiptAlignCenter;//rptReceiptAlignLeft;
    Result := Result + RECEIPT_LINE4 + rptLf2;
  end;

  Result := Result + rptLF + rptLF + rptLF + rptReceiptCut;
end;


function TReceiptPrint.SetLaneGamePrint: Boolean;
var
	Index: Integer;
	PrintData, sUseTime, sTime: string;
begin
	PrintData := EmptyStr;

	with AssignReceipt do
	begin
		PrintData := rptReceiptInit;
		PrintData := PrintData + rptReceiptAlignCenter;
		PrintData := PrintData + rptReceiptSizeWidth + '레인 배정표' + rptLF2 + rptLF2;
		PrintData := PrintData + rptReceiptSizeNormal;
		PrintData := PrintData + rptReceiptAlignCenter;
		PrintData := PrintData + RPadB('출력시각 : ' + FormatDateTime('yyyy-mm-dd hh:nn', now), Int_48, ' ') + rptLF2;

		PrintData := PrintData + RPadB('배정번호 : ' + AssignNo, Int_48, ' ') + rptLF2;
		//ksj 230818 예약사용 배정표 출력시 이용일자(시간)
		if Global.SaleModule.LaneInfo.ExpectedEndDatetime = '' then
			PrintData := PrintData + RPadB('이용일자 : ' + FormatDateTime('yyyy-mm-dd hh:nn', now), Int_48, ' ') + rptLF2
		else
		begin
			sTime := Copy(Global.SaleModule.LaneInfo.ExpectedEndDatetime, 1, 16);
			PrintData := PrintData + RPadB('이용일자 : ' + sTime, Int_48, ' ') + rptLF2;
		end;

		PrintData := PrintData + RECEIPT_LINE2 + rptLF;
		if Global.SaleModule.GameItemType = gitGameCnt then
			PrintData := PrintData + RECEIPT_TITLE3 + rptLF2
		else
			PrintData := PrintData + RECEIPT_TITLE4 + rptLF2; //게임시간

		PrintData := PrintData + RECEIPT_LINE2 + rptLF2;


    for Index := 0 to Length(OrderList) - 1 do
    begin                                                           //요금제(볼링화제외)
      //RECEIPT_TITLE3          = '사용자    게임수   레인   볼링화      금액';
      PrintData := PrintData + Format('%s%4s%7s%8s%12s', [
                       RPadB(OrderList[Index].Name, 10, ' '),
                       OrderList[Index].GameCnt,
                       OrderList[Index].LaneNm,
                       OrderList[Index].ShoesYn,
                       OrderList[Index].Price
                       ]) + rptLF2;
    end;
    PrintData := PrintData + RECEIPT_LINE2 + rptLF;
    PrintData := PrintData + FormatDateTime('yyyy년mm월dd일 hh시nn분', now) + rptLF + rptLF + rptLF;

    PrintData := PrintData + rptReceiptAlignCenter;//rptReceiptAlignLeft;
    PrintData := PrintData + rptLF + rptLF + rptLF + rptReceiptCut;

    Result := Print(PrintData);
  end;
end;

function TReceiptPrint.Print(APrintData: string): Boolean;
var
  SendData: AnsiString;
begin
  try
    Result := False;

    SendData := ConvertPrintData(APrintData);
    ComPort.Write(SendData[1], Length(SendData));

    Result := True;
  except
    on E: Exception do
    begin
      log.E('TReceiptPrint.Print', E.Message);
    end;
  end;
end;

function TReceiptPrint.LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := PadChar(ALength - ByteLen(Result), APadChar) + Result;
end;

function TReceiptPrint.RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
begin
  Result := SCopy(AStr, 1, ALength);
  Result := Result + PadChar(ALength - ByteLen(Result), APadChar);
end;

function TReceiptPrint.SCopy(S: AnsiString; F, L: Integer): string;
var
  ST, ED: Integer;
begin
  if F = 1 then ST := 1
  else
  begin
    case ByteType(S, F) of
      mbSingleByte : ST := F;
      mbLeadByte   : ST := F;
      mbTrailByte  : ST := F - 1;
    end;
  end;

  case ByteType(S, ST+L-1) of
    mbSingleByte : ED := L;
    mbLeadByte   : ED := L - 1;
    mbTrailByte  : ED := L;
  end;

  Result := Copy(S, ST, ED);
end;

function TReceiptPrint.PadChar(ALength: Integer; APadChar: Char = ' '): string;
var
  Index: Integer;
begin
  Result := '';
  for Index := 1 to ALength do
    Result := Result + APadChar;
end;

function TReceiptPrint.ByteLen(const AText: string): Integer;
var
  Index: Integer;
begin
  Result := 0;
  for Index := 1 to Length(AText) do
    Result := Result + IfThen(AText[Index] <= #$00FF, 1, 2);
end;

function TReceiptPrint.GetCurrStr(AData: Currency): string;
begin
  Result := FormatFloat('#,##0.###', AData);
end;

function TReceiptPrint.DateTimeStrToString(const ADateTime: string): string;
begin
  if Length(ADateTime) = 14 then
    Result := Copy(ADateTime, 1, 4) + FormatSettings.DateSeparator + Copy(ADateTime, 5, 2) + FormatSettings.DateSeparator + Copy(ADateTime, 7, 2) + ' ' +
              Copy(ADateTime, 9, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 11, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 13, 2);
end;

//chy sewoo
procedure TReceiptPrint.SewooStatus;
var
  SendData: AnsiString;
begin
  SendData := #16#4#2;
  {$IFDEF RELEASE}
  if not Global.Config.NoDevice then
  begin
    if Global.Config.Print.Port <> 0 then
      ComPort.Write(SendData[1], Length(SendData));
  end;
  {$ENDIF}
  {
  n=1 : Transmit printer status  프린터 상태 전송
  n=2 : Transmit off-line status  오프라인 상태 전송
  n=3 : Transmit error status     오류 상태 전송
  n=4 : Transmit paper roll sensor status  용지 롤 센서 상태 전송
  }
end;

//chy sewoo
procedure TReceiptPrint.ComPortRxChar(Sender: TObject; Count: Integer);
var
  sRecvData, sStr, sStrHex, sStrBin, sPrintStatus: AnsiString;
begin
  SetLength(sRecvData, Count);

  ComPort.Read(sRecvData[1], Count);
  sStr := sRecvData;

  //00100000
  sStrHex := StringToHex(sRecvData);
  sStrBin := HexToBin(sStrHex);

  PrintStatus := Copy(sStrBin, 3, 1);
  if PrintStatus = '1' then
  begin
    Global.SaleModule.CallAdmin(0);
    Log.D('SewooStatus', 'CallAdmin');
  end;
end;

{ TReceipt }

constructor TReceipt.Create;
begin
  StoreInfo := TStoreInfo.Create;
  //OrderList := [];
  //ReceiptMemberInfo := TReceiptMemberInfo.Create;
  //DiscountInfo := [];
  ReceiptEtc := TReceiptEtc.Create;
  ProductInfo := [];
  PayInfo := [];
end;

destructor TReceipt.Destroy;
begin
  StoreInfo.Free;
  //OrderList := [];
  //ReceiptMemberInfo.Free;
  //DiscountInfo := [];
  ReceiptEtc.Free;
  ProductInfo := [];
  PayInfo := [];
  inherited;
end;

procedure TReceipt.Load(AJsonText: string);
begin
  try
    TJsonReadWriter.JsonToObject<TReceipt>(AJsonText, Self);
  finally

  end;
end;

{ TAssignReceipt }

constructor TAssignReceipt.Create;
begin
  OrderList := [];
  //ReceiptMemberInfo := TReceiptMemberInfo.Create;
end;

destructor TAssignReceipt.Destroy;
begin
  OrderList := [];
  //ReceiptMemberInfo.Free;
  inherited;
end;

procedure TAssignReceipt.Load(AJsonText: string);
begin
  try
    TJsonReadWriter.JsonToObject<TReceipt>(AJsonText, Self);
  finally

  end;
end;

{ TPrintThread }

constructor TPrintThread.Create;
begin
  FreeOnTerminate := False;
  inherited Create(True);
  ReceiptList := TList<string>.Create;
  AssignReceiptList := TList<string>.Create;
end;

destructor TPrintThread.Destroy;
begin
  ReceiptList.Free;
  AssignReceiptList.Free;
  inherited;
end;

procedure TPrintThread.Execute;
begin
  inherited;
  while not Terminated do
  begin
    if (ReceiptList.Count <> 0) or (AssignReceiptList.Count <> 0) then
    begin
      Log.D('TPrintThread.Execute', 'Print');

      if ReceiptList.Count <> 0 then
      begin
        Global.SaleModule.Print.ReceiptPrint(ReceiptList[0]);
        ReceiptList.Delete(0);
      end;

      if AssignReceiptList.Count <> 0 then
      begin
        Global.SaleModule.Print.AssignReceiptPrint(AssignReceiptList[0]);
        AssignReceiptList.Delete(0);
      end;
    end
    else
      Suspend;
    Sleep(10);
  end;
end;

end.
