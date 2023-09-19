unit Common.BPReceiptPrint;

interface

uses
  System.Classes, System.SysUtils, System.Math, System.StrUtils, fx.Json;

{$I Common.BPCommon.inc}

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
  rptBarCodeBegin128      = '{<}';   // 바코드 출력 시작 CODE128
  rptBarCodeBegin39       = '{[}';   // 바코드 출력 시작 CODE39
  rptBarCodeEnd           = '{>}';   // 바코드 출력 끝
  rptQRCodeBegin          = '{^}';   //QR코드 출력 시작
  rptQRCodeEnd            = '{~}';   //QR코드 출력 끝
  // 프린터 출력명령 (영수증 별도 출력에서 사용함)
  rptReceiptCharSaleDate  = '{D}';   // 판매일자
  rptReceiptCharPosNo     = '{P}';   // 포스번호
  rptReceiptCharPosName   = '{Q}';   // 포스명
  rptReceiptCharBillNo    = '{A}';   // 빌번호
  rptReceiptCharDateTime  = '{E}';   // 출력일시

  RECEIPT_TITLE1          = '상품명                      단가 수량       금액';
  RECEIPT_TITLE2          = '상품명                단가 수량       금액';
  RECEIPT_LINE1           = '------------------------------------------------';
  RECEIPT_LINE2           = '------------------------------------------';
  RECEIPT_LINE3           = '================================================';
  RECEIPT_LINE4           = '==========================================';

type
  TDeviceType = (dtNone, dtPos, dtKiosk);
  TReceiptPaymentType = (ptVoid, ptCash, ptCard, ptPayco);

  TReceiptStoreInfo = class(TJson)
    StoreName: string;              // 매장명
    BizNo: string;                  // 사업자번호
    BossName: string;               // 업주명
    Tel: string;                    // 전화번호
    Addr: string;                   // 주소
    CashierName: string;            // 판매자명
  end;

  TReceiptMemberInfo = class(TJson)
    MemberName: string;             // 회원명
    MemberNo: string;               // 회원번호
    TelNo: string;                  // 전화번호
    CarNo: string;                  // 차량번호
    QRCode: string;                 // 회원QR코드
    LockerList: string;             // 이용중인라커내역
    LockerExpiredDate: string;      // 라커만료일
  end;

  TReceiptBaseInfo = class(TJson)
    ReceiptNo: string;              // 영수증번호(바코드)
    SaleDate: string;               // 판매일자
    SaleTime: string;               // 판매일시
    ReturnDate: string;             // 반품일자 (반품시 원판매일자)
    IsReprint: Boolean;             // 재발행 여부
    TotalAmt: Integer;              // 상품판매시 총 판매금액
    DCAmt: Integer;                 // 할인금액
    KeepAmt: Integer;               // 라커보증금
    Top1: string;                   // 상단문구1
    Top2: string;                   // 상단문구2
    Top3: string;                   // 상단문구3
    Top4: string;                   // 상단문구4
    Bottom1: string;                // 하단문구1
    Bottom2: string;                // 하단문구2
    Bottom3: string;                // 하단문구3
    Bottom4: string;                // 하단문구4
  end;

  TReceiptProductInfo = class(TJson)
    ProdName: string;               // 상품명
    ProdCode: string;               // 상품코드
    ProdAmt: Integer;               // 판매금액(단가)
    Vat: Integer;                   // 부가세액(부가세)
    OrderQty: Integer;              // 주문수량
  end;

  TReceiptPaymentInfo = class(TJson)
    &PayCode: TReceiptPaymentType;  // 결제 방식
    IsApproval: Boolean;            // 승인 여부(True:승인, False:취소)
    IsManualInput: Boolean;         // 수기입력 여부
    ApprovalAmt: Integer;           // 승인금액
    ApprovalNo: string;             // 승인번호
    OrgApproveNo: string;           // 원 승인번호
    CardNo: string;                 // 카드번호
    CashReceiptPerson: Integer;     // 소득공제 대상(1:개인, 2:사업자)
    InstallMonth: ShortInt;         // 할부 개월수
    MerchantKey: string;            // 가맹번호
    TransDateTime: string;          // 승인일시
    IssuerName: string;             // 발급사
    BuyerName: string;              // 매입사
    BuyerTypeName: string;          // 매입처
    PaycoApprovalName: string;      // PAYCO 승인기관
  end;

  TReceiptLockerInfo = class(TJson)
    LockerNo: Integer;              // 라커번호
    LockerName: string;             // 라커명
    PurchaseMonth: Integer;         // 이용 개월수
    StartDate: string;              // 이용 시작일
//    EndDate: string;                // 이용 종료일
  end;

  TReceipt = class(TJson)
  private
  public
    StoreInfo: TReceiptStoreInfo;
    BaseInfo: TReceiptBaseInfo;
    MemberInfo: TReceiptMemberInfo;
    ProductItems: TArray<TReceiptProductInfo>;
    PaymentItems: TArray<TReceiptPaymentInfo>;
    LockerItems: TArray<TReceiptLockerInfo>;

    constructor Create;
    destructor Destroy; override;

    procedure Load(AJsonText: string);
  end;

  TReceiptPrint = class
  private
    FDeviceType: TDeviceType;
    FReceipt: TReceipt;
    FIsRefund: Boolean;
    FInt_37: Integer;
    FInt_11: Integer;
    FInt_48: Integer;
    FInt_33: Integer;
    FInt_15: Integer;

    function LPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function RPadB(const AStr: string; ALength: Integer; APadChar: Char): string;
    function SCopy(S: AnsiString; F, L: Integer): string;
    function PadChar(ALength: Integer; APadChar: Char=' '): string;
    function ByteLen(const AText: string): Integer;
    function GetCurrStr(AData: Currency): string;
    function DateTimeStrToString(const ADateTime: string): string;
  public
    constructor Create(ADeviceType: TDeviceType);
    destructor Destroy; override;

    function ReceiptPrint(AJsonText: string; const AIsReprint: Boolean; var AErrMsg: string): Boolean;
    function PaymentSlipPrint(const APayMethod: ShortInt; const AJsonText: string; var AErrMsg: string): Boolean;
    function PaymentSlipForm(const APayMethod: ShortInt; const APaymentInfo: TReceiptPaymentInfo): string;

    function KitchenOrderPrint(const AJsonText, AReceiptNo, AMemberInfo: string; var AErrMsg: string): Boolean;
    function KitchenOrderForm(const AReceiptNo, AMemberInfo: string): string;

    function QRCodePrint(const AQRCode, ATitle, AStoreName, AMemberName: string; var AErrMsg: string): Boolean;
    function QRCodePrintForm(const AQRCode, ATitle, AStoreName, AMemberName: string): string;

    function SetReceiptPrint: Boolean;
    function Print(APrintData: string): Boolean;

    function ReceiptHeader: string;
    function ReceiptItemList: string;
    function ReceiptTotalAmt: string;
    function ReceiptPayList: string;
    function ReceiptPayListInfo: string;
    function ReceiptBottom: string;
    function MakeNewPayCoData(APaymentInfo: TReceiptPaymentInfo): string;  // NewPayCo정보

    function ConvertPrintData(AData: string): string;
    function ConvertBarCodeCMD(AData: string): string;
    function MakeQRCodeCMD(AQRCode: string): string;

    property IsRefund: Boolean read FIsRefund write FIsRefund default False;
    property Int_11: Integer read FInt_11 write FInt_11;
    property Int_15: Integer read FInt_15 write FInt_15;
    property Int_33: Integer read FInt_33 write FInt_33;
    property Int_37: Integer read FInt_37 write FInt_37;
    property Int_48: Integer read FInt_48 write FInt_48;
  end;

implementation

uses
  { Native }
  Vcl.Controls, Vcl.Graphics,
  { Project }
  Common.BPGlobal;

{ TReceiptPrint }

function TReceiptPrint.MakeQRCodeCMD(AQRCode: string): string;
begin
  Result := Result + #29#40#107#3#0#49#65#50#0; //QR코드 포맷
  Result := Result + #29#40#107#3#0#49#67#8; //사이즈
  Result := Result + #29#40#107 + Chr(length(AQRCode) + 3) + #0 + #49#80#48 + AQRCode; //QR데이터
  Result := Result + #29#40#107#3#0#49#81#48; //인코딩
end;

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
  Result := ReplaceStr(Result, rptReceiptInit,          #27#64);
  Result := ReplaceStr(Result, rptReceiptCut,           #27#105);
  Result := ReplaceStr(Result, rptReceiptImage1,        #13#28#112#1#0);
  Result := ReplaceStr(Result, rptReceiptImage2,        #13#28#112#2#0);
  Result := ReplaceStr(Result, rptReceiptCashDrawerOpen,#27'p'#0#25#250#13#10);
  Result := ReplaceStr(Result, rptReceiptSpacingNormal, #27#51#60);
  Result := ReplaceStr(Result, rptReceiptSpacingNarrow, #27#51#50);
  Result := ReplaceStr(Result, rptReceiptSpacingWide,   #27#51#120);
  Result := ReplaceStr(Result, rptLF,                   #13#10);
  if FDeviceType = dtKiosk then
  begin
    Result := ReplaceStr(Result, rptReceiptSize3Times,  #29#33#17);
    Result := ReplaceStr(Result, rptReceiptSize4Times,  #29#33#34);
    Result := ReplaceStr(Result, rptReceiptSizeNormal,  #29#33#0);
    Result := ReplaceStr(Result, rptReceiptSizeWidth,   #29#33#1);
    Result := ReplaceStr(Result, rptReceiptSizeHeight,  #29#33#16);
  end
  else
  begin
    Result := ReplaceStr(Result, rptReceiptSize3Times,  #29#33#34);
    Result := ReplaceStr(Result, rptReceiptSize4Times,  #29#33#51);
    Result := ReplaceStr(Result, rptReceiptSizeNormal,  #27#33#0);
    Result := ReplaceStr(Result, rptReceiptSizeWidth,   #27#33#32);
    Result := ReplaceStr(Result, rptReceiptSizeHeight,  #27#33#16);
  end;
  Result := ReplaceStr(Result, rptReceiptSizeBoth,      #27#33#48);
  Result := ReplaceStr(Result, rptReceiptCharNormal,    #27#71#0#29#66#0#27#45#0);
  Result := ConvertBarCodeCMD(Result);
end;

constructor TReceiptPrint.Create(ADeviceType: TDeviceType);
begin
  FDeviceType := ADeviceType;
  if Global.ReceiptPrinter.Enabled and
     (not Global.ReceiptPrinter.ComDevice.Active) then
  begin
    Global.ReceiptPrinter.ComDevice.Open;
    Global.ReceiptPrinter.ComDevice.ClearInput;
    Global.ReceiptPrinter.ComDevice.ClearOutput;
  end;

  if (FDeviceType = dtPos) then
  begin
    Int_11 := 9;
    Int_15 := 13;
    Int_33 := 29;
    Int_37 := 33;
    Int_48 := 42;
  end
  else
  begin
    Int_11 := 11;
    Int_15 := 15;
    Int_33 := 33;
    Int_37 := 37;
    Int_48 := 48;
  end;
end;

destructor TReceiptPrint.Destroy;
begin
  inherited;
end;

function TReceiptPrint.MakeNewPayCoData(APaymentInfo: TReceiptPaymentInfo): string;
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
  ASaleSign: Integer;
begin
  Result := '';
  if APaymentInfo.IsApproval then
    ASaleSign := 1
  else
    ASaleSign := -1;

  Result := Result + rptReceiptAlignCenter + IfThen(APaymentInfo.IsApproval, STR20, STR21) + rptLF;
  Result := Result + RPadB(STR_CARD, Int_33, ' ') + LPadB(GetCurrStr(ASaleSign * APaymentInfo.ApprovalAmt), Int_15, ' ') + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptAlignLeft + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + IfThen(APaymentInfo.IsApproval, STR1, STR22) + rptLF;
  Result := Result + rptReceiptAlignLeft + RPadB(STR2, Int_15, ' ') + LPadB(APaymentInfo.PaycoApprovalName, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR3, Int_15, ' ') + LPadB(APaymentInfo.CardNo, Int_33, ' ') + rptLF;

  if (APaymentInfo.InstallMonth > 1) then
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(APaymentInfo.InstallMonth.ToString + STR15, Int_33, ' ') + rptLF
  else
    Result := Result + RPadB(STR4, Int_15, ' ') + LPadB(STR14, Int_33, ' ') + rptLF;

  Result := Result + RPadB(STR5, Int_15, ' ') + LPadB(APaymentInfo.ApprovalNo, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR6, Int_15, ' ') + LPadB(DateTimeStrToString(APaymentInfo.TransDateTime), Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR7, Int_15, ' ') + LPadB(APaymentInfo.MerchantKey, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR8, Int_15, ' ') + LPadB(APaymentInfo.BuyerName, Int_33, ' ') + rptLF;
  Result := Result + RPadB(STR9, Int_15, ' ') + LPadB(APaymentInfo.BuyerTypeName, Int_33, ' ') + rptLF;
end;

function TReceiptPrint.ReceiptBottom: string;
begin
  Result := '';
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptBarCodeBegin128;
  Result := Result + FReceipt.BaseInfo.ReceiptNo;
  Result := Result+ rptBarCodeEnd + rptLF;

  if not FReceipt.BaseInfo.Bottom1.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom1 + rptLF;
  if not FReceipt.BaseInfo.Bottom2.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom2 + rptLF;
  if not FReceipt.BaseInfo.Bottom3.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom3 + rptLF;
  if not FReceipt.BaseInfo.Bottom4.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Bottom4 + rptLF;

  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
  if FReceipt.BaseInfo.IsReprint then
  begin
    Result := Result + rptReceiptAlignCenter + '※재발행 된 영수증 입니다※' + rptLF;
    Result := Result + rptReceiptAlignLeft;
    if (FDeviceType = dtKiosk) then
      Result := Result + RECEIPT_LINE3 + rptLF;
  end;
  Result := Result + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.PaymentSlipPrint(const APayMethod: ShortInt; const AJsonText: string; var AErrMsg: string): Boolean;
var
  PI: TReceiptPaymentInfo;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      for var I: ShortInt := 0 to Pred(Length(FReceipt.PaymentItems)) do
      begin
        PI := FReceipt.PaymentItems[I];
        Result := Print(PaymentSlipForm(APayMethod, PI));
      end;
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.PaymentSlipForm(const APayMethod: ShortInt; const APaymentInfo: TReceiptPaymentInfo): string;
var
  LPayMethod, LApprovalType: string;
begin
  Result := '';
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + rptReceiptSizeWidth;

  if APaymentInfo.IsApproval then
    LApprovalType := '승인'
  else
    LApprovalType := '취소';

  LPayMethod := '거래';
  case APayMethod of
    CO_PAYMENT_CARD:
      LPayMethod := '신용카드';
    CO_PAYMENT_CASH:
      LPayMethod := '현금결제';
    CO_PAYMENT_PAYCO_CARD:
      LPayMethod := 'PAYCO 신용카드';
    CO_PAYMENT_PAYCO_COUPON:
      LPayMethod := 'PAYCO 할인쿠폰';
    CO_PAYMENT_PAYCO_POINT:
      LPayMethod := 'PAYCO 포인트';
  end;

  Result := Result + Format('%s %s 전표', [LPayMethod, LApprovalType]) + rptLF + rptLF;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + '매 장 명: ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '대표자명: ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '전화번호: ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '매장주소: ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '사업자번호: ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '판매자명: ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '출력시각: ' + Global.DateTime.FormattedCurrentDateTime + rptLF;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + rptReceiptAlignCenter + '[ 고 객 용 ]' + rptLF;
  Result := Result + rptReceiptAlignLeft + RECEIPT_LINE2 + rptLF;
  Result := Result + '[결 제 금 액] ' + FormatFloat('#,##0.##', APaymentInfo.ApprovalAmt) + rptLF;
  Result := Result + '[부 가 세 액] ' + FormatFloat('#,##0', APaymentInfo.ApprovalAmt / 11) + rptLF;
  Result := Result + '[승 인 번 호] ' + APaymentInfo.ApprovalNo + rptLF;

  if (APayMethod in [CO_PAYMENT_CARD, CO_PAYMENT_PAYCO_CARD]) then
  begin
    Result := Result + rptReceiptAlignLeft + '[카 드 번 호] ' + APaymentInfo.CardNo + rptLF;
    if (APaymentInfo.InstallMonth > 1) then
      Result := Result + '[할 부 개 월] ' + APaymentInfo.InstallMonth.ToString + rptLF
    else
      Result := Result + '[할 부 개 월] ' + '일시불' + rptLF;
    Result := Result + '[카 드 사 명] ' + APaymentInfo.IssuerName + rptLF;
    Result := Result + '[매 입 사 명] ' + APaymentInfo.BuyerName + rptLF;
    Result := Result + '[가 맹 번 호] ' + APaymentInfo.MerchantKey + rptLF;
  end;

  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.KitchenOrderPrint(const AJsonText, AReceiptNo, AMemberInfo: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      if (Length(FReceipt.ProductItems) > 0) then
        Result := Print(KitchenOrderForm(AReceiptNo, AMemberInfo));
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.KitchenOrderForm(const AReceiptNo, AMemberInfo: string): string;
var
  PI: TReceiptProductInfo;
begin
  Result := '';
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter;
  Result := Result + rptReceiptSizeWidth;
  Result := Result + '주방주문서' + rptLF + rptLF;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + RECEIPT_LINE2 + rptLF;
  for var I: ShortInt := 0 to Pred(Length(FReceipt.ProductItems)) do
  begin
    PI := FReceipt.ProductItems[I];
    Result := Result + Format('%s%10s%5s%11s', [
                       RPadB(PI.ProdName, IfThen(FDeviceType = dtKiosk, 22, 16), ' '),
                       FormatFloat('#,##0.##', PI.ProdAmt),
                       FormatFloat('#,##0.##', PI.OrderQty),
                       FormatFloat('#,##0.##', (PI.ProdAmt * PI.OrderQty))
                       ]) + rptLF;
  end;
  Result := Result + RECEIPT_LINE2 + rptLF;
  Result := Result + '주 문 고 객: ' + AMemberInfo + rptLF;
  Result := Result + '영수증 번호: ' + AReceiptNo + rptLF;
  Result := Result + '발 행 일 시: ' + Global.DateTime.FormattedCurrentDateTime + rptLF;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.QRCodePrint(const AQRCode, ATitle, AStoreName, AMemberName: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    Result := Print(QRCodePrintForm(AQRCode, ATitle, AStoreName, AMemberName));
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;

function TReceiptPrint.QRCodePrintForm(const AQRCode, ATitle, AStoreName, AMemberName: string): string;
begin
  Result := '';
  Result := Result + rptLF + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeWidth + ATitle + rptReceiptSizeNormal + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF + rptLF + rptLF;
  Result := Result + MakeQRCodeCMD(AQRCode) + rptLF;
  Result := Result + AMemberName + rptLF;
  Result := Result + AStoreName + rptLF;
  Result := Result + rptReceiptAlignLeft;
  Result := Result + rptLF + rptLF + rptLF + rptLF + rptLF + rptLF + rptReceiptCut;
end;

function TReceiptPrint.ReceiptHeader: string;
begin
  Result := '';
  Result := Result + rptReceiptInit;
  Result := Result + rptReceiptAlignCenter + rptReceiptSizeBoth + rptReceiptCharBold;
  Result := Result + '영 수 증' + rptLF + rptLF;
  Result := Result + rptReceiptCharNormal + rptReceiptSizeNormal + rptReceiptAlignLeft;
  Result := Result + '매 장 명 : ' + FReceipt.StoreInfo.StoreName + rptLF;
  Result := Result + '대표자명 : ' + FReceipt.StoreInfo.BossName + rptLF;
  Result := Result + '전화번호 : ' + FReceipt.StoreInfo.Tel + rptLF;
  Result := Result + '매장주소 : ' + FReceipt.StoreInfo.Addr + rptLF;
  Result := Result + '사업자번호 : ' + FReceipt.StoreInfo.BizNo + rptLF;
  Result := Result + '판매자명 : ' + FReceipt.StoreInfo.CashierName + rptLF;
  Result := Result + '거래일시 : ' + FReceipt.BaseInfo.SaleDate + ' ' + FReceipt.BaseInfo.SaleTime + rptLF;
  Result := Result + '출력일시 : ' + Copy(Global.DateTime.FormattedCurrentDateTime, 1, 16) {yyyy-mm-dd hh:nn} + rptLF;

  if not FReceipt.BaseInfo.Top1.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top1 + rptLF;
  if not FReceipt.BaseInfo.Top2.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top2 + rptLF;
  if not FReceipt.BaseInfo.Top3.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top3 + rptLF;
  if not FReceipt.BaseInfo.Top4.IsEmpty then
    Result := Result + FReceipt.BaseInfo.Top4 + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_TITLE1, RECEIPT_TITLE2) + rptLF;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
end;

function TReceiptPrint.ReceiptItemList: string;
var
  PI: TReceiptProductInfo;
begin
  Result := '';
  for var I: ShortInt := 0 to Pred(Length(FReceipt.ProductItems)) do
  begin
    PI := FReceipt.ProductItems[I];
    Result := Result + Format('%s%10s%5s%11s', [
                         RPadB(PI.ProdName, IfThen(FDeviceType = dtKiosk, 22, 16), ' '),
                         FormatFloat('#,##0.##', PI.ProdAmt),
                         FormatFloat('#,##0.##', PI.OrderQty),
                         FormatFloat('#,##0.##', (PI.ProdAmt * PI.OrderQty))
                        ]) + rptLF;
  end;
end;

function TReceiptPrint.ReceiptPayList: string;
var
  CashStr: string;
  PI: TReceiptPaymentInfo;
begin
  Result := '';
  for var I: ShortInt := 0 to Pred(Length(FReceipt.PaymentItems)) do
  begin
    PI := FReceipt.PaymentItems[I];
    if (PI.PayCode = ptCash) then
    begin
      if (not PI.IsManualInput) and
         (not PI.ApprovalNo.IsEmpty) then
      begin
        if Trim(PI.OrgApproveNo).IsEmpty then
          Result := Result + LPadB('현금영수증(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('현금영수증(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', (-1 * PI.ApprovalAmt)), Int_15, ' ') + rptLF;
      end
      else
      begin
        CashStr := IfThen(PI.IsApproval, '승인', '취소');
        Result := Result + LPadB('현금(' + CashStr + ')', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', IfThen(PI.IsApproval, 1, -1) * PI.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;

    if (PI.PayCode = ptCard) then
    begin
      if (not PI.IsManualInput) then
      begin
        if PI.IsApproval then
          Result := Result + LPadB('신용카드(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF
        else
          Result := Result + LPadB('신용카드(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', -1 * PI.ApprovalAmt), Int_15, ' ') + rptLF;
      end
      else
      begin
        Result := Result + LPadB('카드(수기등록)', Int_33, ' ') +
          LPadB(FormatFloat('#,##0.##', IfThen(PI.IsApproval, 1, -1) * PI.ApprovalAmt), Int_15, ' ') + rptLF;
      end;
    end;

    if (PI.PayCode = ptPayco) then
    begin
      if PI.IsApproval then
        Result := Result + LPadB('PAYCO(승인)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF
      else
        Result := Result + LPadB('PAYCO(취소)', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF;
    end;
  end;
  Result := Result + rptReceiptSizeNormal;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
end;

function TReceiptPrint.ReceiptPayListInfo: string;
var
  CashMsg: string;
  PI: TReceiptPaymentInfo;
begin
  Result := '';
  with FReceipt do
  begin
    for var I: ShortInt := 0 to Pred(Length(PaymentItems)) do
    begin
      PI := PaymentItems[I];
      if (PI.PayCode = ptCash) then
      begin
        if not Trim(PI.ApprovalNo).IsEmpty then
        begin
          CashMsg := IfThen(PI.CashReceiptPerson = 1, '(소득공제)', '(지출증빙)');
          Result := Result + rptReceiptAlignCenter + '';
          Result := Result + IfThen(PI.IsApproval, '<현금영수증' + CashMsg + ' 승인내역>', '<현금영수증' + CashMsg + ' 취소내역>') + rptLF;
          Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
          Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
          Result := Result + RPadB('승인금액', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF;
          Result := Result + RPadB('승인번호', Int_33, ' ') + LPadB(PI.ApprovalNo, Int_15, ' ') + rptLF;
          Result := Result + RPadB('카드번호', Int_33, ' ') + LPadB(PI.CardNo, Int_15, ' ') + rptLF;
        end;
      end;

      if (PI.PayCode = ptCard) then
      begin
        Result := Result + rptReceiptAlignCenter;
        Result := Result + IfThen(PI.IsApproval, '<신용카드 승인내역>', '<신용카드 취소내역>') + rptLF;
        Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE3, RECEIPT_LINE4) + rptLF;
        Result := Result + rptReceiptAlignLeft + rptReceiptCharNormal;
        Result := Result + RPadB('승인금액', Int_33, ' ') + LPadB(FormatFloat('#,##0.##', PI.ApprovalAmt), Int_15, ' ') + rptLF;

        if (PI.InstallMonth > 1) then
          Result := Result + RPadB('할부개월', Int_33, ' ') + LPadB(PI.InstallMonth.ToString  + '개월', Int_15, ' ') + rptLF
        else
          Result := Result + RPadB('할부개월', Int_33, ' ') + LPadB('일시불', Int_15, ' ') + rptLF;
        Result := Result + RPadB('발 급 사', Int_33, ' ') + LPadB(PI.IssuerName, Int_15, ' ') + rptLF;
        Result := Result + RPadB('승인번호', Int_33, ' ') + LPadB(PI.ApprovalNo, Int_15, ' ') + rptLF;
        Result := Result + RPadB('카드번호', Int_33, ' ') + LPadB(PI.CardNo, Int_15, ' ') + rptLF;
      end;

      if (PI.PayCode = ptPayco) then
        Result := Result + MakeNewPayCoData(PI);
    end;

    if not Result.IsEmpty then
      Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  end;
end;

function TReceiptPrint.ReceiptPrint(AJsonText: string; const AIsReprint: Boolean; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  FReceipt := TReceipt.Create;
  try
    try
      FReceipt.Load(AJsonText);
      if (Length(FReceipt.ProductItems) > 0) then
        SetReceiptPrint;
      Result := True;
    except
      on E: Exception do
        AErrMsg := E.Message;
    end;
  finally
    FReceipt.Free;
  end;
end;

function TReceiptPrint.ReceiptTotalAmt: string;
var
  AVat: Integer;
begin
  AVat := (FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt) - Trunc((FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt) / 1.1);
  Result := '';
  Result := Result + rptReceiptSizeNormal;
  Result := Result + IfThen(FDeviceType = dtKiosk, RECEIPT_LINE1, RECEIPT_LINE2) + rptLF;
  Result := Result + rptReceiptSizeWidth;                        // 16
  Result := Result + Format(IfThen(FDeviceType = dtKiosk, '판매금액%40s', '판매금액%13s'), [FormatFloat('#,##0.##', FReceipt.BaseInfo.TotalAmt)]) + rptLF;
  Result := Result + rptReceiptSizeNormal;
  if (FReceipt.BaseInfo.DCAmt <> 0) then
    Result := Result + LPadB('할인금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.BaseInfo.DCAmt), Int_11, ' ') + rptLF;
  Result := Result + LPadB('과세상품금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', ((FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt) - AVat)), Int_11, ' ') + rptLF;
  Result := Result + LPadB('부가세(VAT)금액', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', AVat), Int_11, ' ') + rptLF;
  Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  if (FReceipt.BaseInfo.KeepAmt <> 0) then
  begin
    Result := Result + LPadB('라커보증금', Int_37, ' ') + LPadB(FormatFloat('#,##0.##', FReceipt.BaseInfo.KeepAmt), Int_11, ' ') + rptLF;
    for var I: ShortInt := 0 to Pred(Length(FReceipt.LockerItems)) do
      if (FReceipt.LockerItems[I].LockerNo > 0) then
//        Result := Result + LPadB(Format('%s (%d개월) %s~%s', [FReceipt.LockerItems[I].LockerName, FReceipt.LockerItems[I].PurchaseMonth, FReceipt.LockerItems[I].StartDate, FReceipt.LockerItems[I].EndDate]), Int_48, ' ') + rptLF;
        Result := Result + LPadB(Format('%s (%d개월) %s~', [FReceipt.LockerItems[I].LockerName, FReceipt.LockerItems[I].PurchaseMonth, FReceipt.LockerItems[I].StartDate]), Int_48, ' ') + rptLF;
    Result := Result + LPadB('---------------------------', Int_48, ' ') + rptLF;
  end;

  Result := Result + rptReceiptSizeWidth;
  if FIsRefund then
    Result := Result + Format(IfThen(FDeviceType = dtKiosk, '취소금액%40s', '취소금액%13s'), [FormatFloat('#,##0.##', -1 * (FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt))]) + rptLF
  else
    Result := Result + Format(IfThen(FDeviceType = dtKiosk, '결제금액%40s', '결제금액%13s'), [FormatFloat('#,##0.##', (FReceipt.BaseInfo.TotalAmt - FReceipt.BaseInfo.DCAmt))]) + rptLF;

  Result := Result + rptReceiptSizeNormal;
end;

function TReceiptPrint.SetReceiptPrint: Boolean;
var
  PrintData: string;
  I: Integer;
begin
  Result := False;
  PrintData := '';
  PrintData := PrintData + rptReceiptInit;
  PrintData := PrintData + ReceiptHeader;
  PrintData := PrintData + ReceiptItemList;
  PrintData := PrintData + ReceiptTotalAmt;
  PrintData := PrintData + ReceiptPayList;
  PrintData := PrintData + ReceiptPayListInfo;
  PrintData := PrintData + ReceiptBottom;

  for I := 1 to Global.ReceiptPrinter.Copies do
    Result := Print(PrintData);
end;

function TReceiptPrint.Print(APrintData: string): Boolean;
var
  SendData: AnsiString;
begin
  Result := False;
  try
    SendData := ConvertPrintData(APrintData);
    Global.ReceiptPrinter.ComDevice.Write(PAnsiChar(SendData), Length(SendData), False);
    Result := True;
  except
    on E: Exception do
    begin
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
  ST := 0;
  ED := 0;
  if (F = 1) then
    ST := 1
  else
  begin
    case ByteType(S, F) of
      mbSingleByte : ST := F;
      mbLeadByte   : ST := F;
      mbTrailByte  : ST := (F - 1);
    end;
  end;

  case ByteType(S, ST + L - 1) of
    mbSingleByte : ED := L;
    mbLeadByte   : ED := (L - 1);
    mbTrailByte  : ED := L;
  end;

  Result := Copy(S, ST, ED);
end;

function TReceiptPrint.PadChar(ALength: Integer; APadChar: Char = ' '): string;
begin
  Result := '';
  for var I: ShortInt := 1 to ALength do
    Result := Result + APadChar;
end;

function TReceiptPrint.ByteLen(const AText: string): Integer;
begin
  Result := 0;
  for var I: ShortInt := 1 to Length(AText) do
    Result := Result + IfThen(AText[I] <= #$00FF, 1, 2);
end;

function TReceiptPrint.GetCurrStr(AData: Currency): string;
begin
  Result := FormatFloat('#,##0.###', AData);
end;

function TReceiptPrint.DateTimeStrToString(const ADateTime: string): string;
begin
  if (Length(ADateTime) = 14) then
    Result := Copy(ADateTime, 1, 4) + FormatSettings.DateSeparator + Copy(ADateTime, 5, 2) + FormatSettings.DateSeparator + Copy(ADateTime, 7, 2) + ' ' +
              Copy(ADateTime, 9, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 11, 2) + FormatSettings.TimeSeparator + Copy(ADateTime, 13, 2);
end;

{ TReceipt }

constructor TReceipt.Create;
begin
  StoreInfo := TReceiptStoreInfo.Create;
  BaseInfo := TReceiptBaseInfo.Create;
  MemberInfo := TReceiptMemberInfo.Create;
  ProductItems := [];
  PaymentItems := [];
  LockerItems := [];
end;

destructor TReceipt.Destroy;
begin
  StoreInfo.Free;
  BaseInfo.Free;
  MemberInfo.Free;
  ProductItems := [];
  PaymentItems := [];
  LockerItems := [];

  inherited;
end;

procedure TReceipt.Load(AJsonText: string);
begin
  try
    TJsonReadWriter.JsonToObject<TReceipt>(AJsonText, Self);
  finally

  end;
end;

end.
