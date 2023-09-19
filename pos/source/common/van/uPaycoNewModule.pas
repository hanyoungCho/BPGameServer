unit uPaycoNewModule;

interface

uses
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, System.StrUtils, System.IniFiles,
  Vcl.Forms, Vcl.Controls, Vcl.Dialogs, System.Math, uVanFunctions, uVanDaemonModule;

const
  CASH_50000 = 50000;

type
  TVanConfig = record
    TerminalID: string;
    BizNo: string;
    SerialNo: string;
    VanName: string;
    SignPad: Boolean;
  end;

  // Payco 환경설정
  TPaycoNewConfig = record
    RealMode: Boolean;                 // 실모드/테스트모드
    BizNo: AnsiString;                 // 사업자번호
    VanPosID: AnsiString;              // Van Pos ID
    VanSerialID: AnsiString;           // Van Serial ID
    VanCode: AnsiString;               // Van Code
 //   UseMode   : Integer;               // 0: 밴모드 / 1: PG 모드 구분
  end;

  // Payco 전송정보
  TPaycoNewSendInfo = record
    Approval: Boolean;                 // 승인/취소 여부
    PayAmt: Currency;                  // 승인금액
    DutyAmt: Currency;                 // 승인금액 ( 공급가 )
    TaxAmt: Currency;                  // 승인금액 ( 부가세 )
    FreeAmt: Currency;                 // 승인금액 ( 면세금액 )
    TipAmt: Currency;                  // 승인금액 ( 봉사료 )
    ApprovalAmount: Currency;          // 포인트 및 쿠폰 금액을 제외 한 승인 금액
    PointAmt: Currency;                // 포인트금액
    CouponAmt: Currency;               // 쿠폰금액
    PaymentMethodCode: AnsiString;     // 결제수단 코드를 세팅  Example : PAYCO, PAYON : 00 티머니 : 01
    TradeNo: AnsiString;               // 거래번호
    HalbuMonth: AnsiString;            // 할부개월
    OrgAgreeNo: AnsiString;            // 원승인번호(취소시)
    OrgAgreeDate: AnsiString;          // 원승인일자(취소시)
    ApprovalCompanyCode: AnsiString;   // 승인사코드
    ApprovalCompanyName: AnsiString;   // 승인사명
    ServiceType: AnsiString;           // 서비스타입
    FieldCount: Currency;              // 상품 속성 개수

    TerminalID: string;
    BizNo: string;
    SerialNo: string;
    VanName: string;
    SignPad: Boolean;
  end;

  // Payco 응답정보
  TPaycoNewRecvInfo = record
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    AgreeNo: AnsiString;               // 승인번호
    TradeNo: AnsiString;               // 거래번호
    TransDateTime: AnsiString;         // 거래일시(yyyymmddhhnnss)
    PaymentMethodCode: AnsiString;     // 결제수단 코드를 세팅  Example : PAYCO, PAYON : 00 티머니 : 01
    PaymentMethodName: AnsiString;     // 결제수단명
    AgreeAmt: Currency;                // 승인금액
    ApprovalAmount: Currency;          // 포인트 및 쿠폰 금액을 제외 한 승인 금액
    PointAmt: Currency;                // 포인트금액
    CouponAmt: Currency;               // 쿠폰금액
    ServiceType: AnsiString;           // 서비스 타입 값 (“PAYCO” / “PAYON” / “TMONEY”)
    HalbuMonth: AnsiString;            // 할부개월
    ApprovalCompanyName: AnsiString;   // 승인사명
    ApprovalCompanyCode: AnsiString;   // 승인사코드
    MerchantKey: AnsiString;           // 가맹점키
    MerchantName: AnsiString;          // 가맹점명
    CouponName: AnsiString;            // 쿠폰명
    PointName: AnsiString;             // 포인트명
    PayonCardOtc: AnsiString;          // PAYON 서비스 VAN 방식 일때 OTC 값
    RevCardNo: AnsiString;             // 카드번호
    BuyCompanyName: AnsiString;        // VAN 승인시 매입사명
    BuyCompanyCode: AnsiString;        // VAN 승인시 매입사명
    BuyTypeName: AnsiString;          // KCP VAN 승인시 매입방법명
    OneCardType: AnsiString;           // 원카드타입
    OneCardTypeName: AnsiString;       // 원카드타입명
    AcmPoint: Currency;                // 적립포인트
    AcmUsablePoint: Currency;          // 사용가능 적립포인트
    AcmCumulationPoint: Currency;      // 누적 적립포인트
    TradeBeforeAmount: Currency;       // 결제전잔액
    TradeAfterAmount: Currency;        // 결제후잔액
  end;

  TPaycoNewModule = class
  private
//    Log: TLog;
    DLLHandle: THandle;
    Config: TPaycoNewConfig;
    TotPayAmt: Currency;
    function ReadINIFirstKey: Boolean;
    procedure WriteINIFirstKey;
    procedure PaycoRevOpen();
    procedure PaycoRevClose();
    function  PaycoRevCheck: Boolean;
    function MakeSendDataPayco(AInfo: TPaycoNewSendInfo) : AnsiString;
    function MakeRecvDataPayco(Amt: Currency; Approval: Boolean): TPaycoNewRecvInfo;
  public
    VanModul: TVanConfig;
    GoodsName: AnsiString;             // 상품명
    GoodsList: AnsiString;             // 상품리스트
    ICHWSerial: AnsiString;            // IC인증용 하드웨어 시리얼
    TestMode: Boolean;                 // TEST / REAL 구분
    UseMode: Integer;                  // 0: 밴모드 / 1: PG 모드 구분
    constructor Create; virtual;
    destructor Destroy; override;
    // 등록작업
    function SetCofig(const Value: TPaycoNewConfig) : Boolean;
    // 개점작업 ( 최초 1회 )
    function SetOpen: Boolean;
    // 종료작업
    function SetClose : Boolean;
    // 망취소작업
    function SetCancel : Boolean;
    // Payco 결제처리
    function ExecPayProc(AInfo: TPaycoNewSendInfo): TPaycoNewRecvInfo;
    // Barcode정보 입력
    procedure SetBarcode(ABarcode: AnsiString);
    // VanCode
    function GetVanCode(ACode: string): string;
  end;

var
  PaycoNewMan: TPaycoNewModule;

implementation

uses
  uPaycoRevForm;

type
//1.초기화
TPAYCO_NfcInit = procedure; stdCall;
//2.코드를 세팅
TPAYCO_SetPaycoData = procedure(Gubun, Code: AnsiString); stdCall;
//3.실행
TPAYCO_NfcASyncRun = procedure(hwnd: THandle); stdCall;
//4.개점작업 ( 최초 1회 )
TPAYCO_NfcDailyRun = procedure; stdCall;
//5.종료
TPAYCO_NfcSendASyncEnd = procedure; stdCall;
//6.결과값을 받습니다.
TPAYCO_GetPaycoData = function(Code: AnsiString): PAnsiChar; stdCall;
//7.결과값을 받습니다.
TPAYCO_GetPaycoListCount = function(Code: AnsiString): PAnsiChar; stdCall;
//8.결과값을 받습니다.
TPAYCO_GetPaycoListData = function(Code: AnsiString): PAnsiChar; stdCall;
//9.망취소 작업을 진행합니다.
TPAYCO_NfcSendNetworkCancel = procedure; stdCall;
//10.서명패드 사인이미지값을 처리합니다.
TPAYCO_NfcSendSignData = function(Code , aLen , aData , aPath , aEtc  : AnsiString): PAnsiChar; stdCall;
// 11. 바코드 정보를 전송합니다.
TPAYCO_NfcSendBarcode = procedure(ABarcode: AnsiString); stdcall;
const
  filPAYCO_DLL = 'PaycoNfc.dll';
  _INI_PAYCO = 'SolbiPayco.ini';

{ TPaycoModul }

constructor TPaycoNewModule.Create;
begin
  DLLHandle := LoadLibrary(filPAYCO_DLL);
//  Log := TLog.Create;
  GoodsName := EmptyStr;             // 상품명
  GoodsList := EmptyStr;             // 상품리스트
  ICHWSerial := EmptyStr;            // IC인증용 하드웨어 시리얼
  TestMode := False;                 // TEST / REAL 구분
  UseMode := 0;                      // 0: 밴모드 / 1: PG 모드 구분
end;

destructor TPaycoNewModule.Destroy;
begin
  FreeLibrary(DLLHandle);
//  Log.Free;
  inherited;
end;

function TPaycoNewModule.ExecPayProc(AInfo: TPaycoNewSendInfo): TPaycoNewRecvInfo;
begin
  try
//    Log.Write(ltInfo, ['TPaycoNewModule', 'ExecPayProc']);
    TotPayAmt := 0;
    //001.개점 작업을 진행합니다. ( 일최초 1회 )
    //if ReadINIFirstKey = False then
    // SetOpen;
    //002.수신용 폼을 연후
    PaycoRevOpen;
    TotPayAmt := AInfo.PayAmt;
    //003.승인작업을 진행합니다.
    MakeSendDataPayco(AInfo);
    //004.응답작업을 진행합니다.
    if PaycoRevCheck then
      Result := MakeRecvDataPayco(AInfo.PayAmt, AInfo.Approval);
  finally
    //005.종료작업을 진행합니다.
    PaycoRevClose;
  end;
end;

function TPaycoNewModule.GetVanCode(ACode: string): string;
begin
  if ACode = VAN_CODE_KFTC then
    Result := '금융결제원'
  else if ACode = VAN_CODE_KICC then
    Result := 'KICC'
  else if ACode = VAN_CODE_KIS then
    Result := 'KIS'
  else if ACode = VAN_CODE_FDIK then
    Result := 'FDIK'
  else if ACode = VAN_CODE_KOCES then
    Result := 'KOCES'
  else if ACode = VAN_CODE_KSNET then
    Result := 'KSNET'
  else if ACode = VAN_CODE_JTNET then
    Result := 'JTNET'
  else if ACode = VAN_CODE_NICE then
    Result := 'NICE'
  else if ACode = VAN_CODE_SMARTRO then
    Result := 'Smartro'
  else if ACode = VAN_CODE_KCP then
    Result := 'KCP'
  else if ACode = VAN_CODE_DAOU then
    Result := '다우데이타'
  else if ACode = VAN_CODE_KOVAN then
    Result := 'KOVAN'
  else if ACode = VAN_CODE_SPC then
    Result := 'SPC네트웍스';
end;

function TPaycoNewModule.MakeSendDataPayco(AInfo: TPaycoNewSendInfo): AnsiString;
var
  SetPaycoData: TPAYCO_SetPaycoData;
  NfcASyncRun : TPAYCO_NfcASyncRun;
begin
  inherited;
//  Log.Write(ltInfo, ['TPaycoNewModule', 'MakeSendDataPayco']);
  Result := EmptyStr;
  try
//    Log.Write(ltInfo, ['MakeSendDataPayco ' , '리얼구분 :'+ IfThen(TestMode, '테스트', '리얼') + ' 승인구분  : ' + IfThen(AInfo.Approval, '승인', '취소')  ] );

    @SetPaycoData := GetProcAddress(DLLHandle, 'SetPaycoData');
    @NfcASyncRun  := GetProcAddress(DLLHandle, 'NfcASyncRun');

    if not Assigned(@SetPaycoData) and not Assigned(@NfcASyncRun) then
    begin
      ShowMessage(filPAYCO_DLL + ' 로드 실패 ');
//      Log.Write(ltInfo, ['MakeSendDataPayco :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // 초기세팅을 진행한후
    if TestMode = False then
     begin
      // 사업자번호 설정
      Config.BizNo := StringReplace(AInfo.BizNo, '-', '', [rfReplaceAll]);
      // VAN POSID 설정
      Config.VanPosID := AInfo.TerminalID;
      // VAN VanSerialID 설정
      Config.VanSerialID := AInfo.SerialNo;
     end;
    // VAN 코드 설정
    if AInfo.VanName = 'JT-NET' then
      Config.VanCode := 'JTNET'
    else if AInfo.VanName = 'Smartro' then
      Config.VanCode := 'SMTR'
    else if AInfo.VanName = 'StarVAN' then
      Config.VanCode := 'DAU'
    else if AInfo.VanName = 'SPC Networks' then
      Config.VanCode := 'SPC'
    else
      Config.VanCode := AInfo.VanName;

   // Config.UseMode := 0;       // PG 인지 VAN 인지 추후 옵션 설정 JKH 20170117

    // 기초 환경설정 작업 진행
    SetCofig(Config);

    // 승인인지 취소인지 반드시 세팅 승인 : “APPROVAL” / 취소 : “CANCEL”
    if AInfo.Approval then     // 승인일 경우
    begin
      //결제모드 설정
      SetPaycoData('TradeMethod', 'APPROVAL');
    end
    else
    begin
      //결제모드 설정
      SetPaycoData('TradeMethod', 'CANCEL');
      //승인일시
    //  if VanModul.VanName = 'FDIK' then
    //    SetPaycoData('ApprovalDatetime', Copy(AInfo.OrgAgreeDate,3,Length(AInfo.OrgAgreeDate)-2))
    //  else
        SetPaycoData('ApprovalDatetime', AInfo.OrgAgreeDate);
      //승인번호
      SetPaycoData('ApprovalNo', AInfo.OrgAgreeNo);
      //포인트 및 쿠폰금액을 제외한 승인금액
      SetPaycoData('ApprovalAmount', CurrToStr(AInfo.ApprovalAmount));
      //서비스타입
      SetPaycoData('ServiceType', AInfo.ServiceType);
    end;
    //결제금액 설정
    SetPaycoData('TotalAmount', CurrToStr(AInfo.PayAmt));
    // 과세금액(과세상품의 공급가액 합)
    SetPaycoData('TotalTaxableAmount', CurrToStr(AInfo.DutyAmt));
    // 부가세(과세상품의 부가세 합)
    SetPaycoData('TotalVatAmount', CurrToStr(AInfo.TaxAmt));
    // 면세금액(면세상품의 공급가액 합)
    SetPaycoData('TotalTaxfreeAmount', CurrToStr(AInfo.FreeAmt));
    // 봉사료(서비스요금)
    SetPaycoData('TotalServiceAmount', CurrToStr(AInfo.TipAmt));
    // 상품명 설정
    SetPaycoData('ProductName', GoodsName);
    // 상품리스트 설정
    SetPaycoData('ProductList', GoodsList);
    // 상품리스트 속성 개수
    SetPaycoData('ProductListFieldCount', CurrToStr(AInfo.FieldCount));

//    Log.Write(ltInfo, ['MakeSendDataPayco(ProductName)' , GoodsName] );
//    Log.Write(ltInfo, ['MakeSendDataPayco(ProductList)' , GoodsList] );

    //KTC단말인증번호 설정
    SetPaycoData('KtcCertNo', ICHWSerial);
    //SetPaycoData('KtcCertNo', '####KCPOKPOS1001');
    //터치모드
    //SetPaycoData('TouchMode', '');
    //비동기 이벤트 ID
    SetPaycoData('ASyncEndEventID', '1000');
    // 5만원 무서명 (초과 : N, 이하: Y)
    SetPaycoData('NocvmYN', IfThen(AInfo.PayAmt > CASH_50000, 'N', 'Y'));
    //실행
//    NfcASyncRun(PaycoRevForm.Handle);
    NfcASyncRun(PaycoRevForm.Handle);
//    Sleep(500);
//    SetBarcode('20193813272949769592');
  finally
  end;
end;

function TPaycoNewModule.MakeRecvDataPayco(
  Amt: Currency; Approval: Boolean): TPaycoNewRecvInfo;
var
  Index : integer;
  resCd , resMsg ,  aServiceType , aTradeMethod ,
  aTradeNo , aPaymentMethodCode ,
  aApprovalNo , aTradeDatetime , aApprovalAmount , aQuota ,
  aPointAmt , aCouponAmt , aApprovalCompanyCode ,
  aPaymentMethodName , aApprovalCompanyName , aMerchantKey , aMerchantName ,
  aPayonCardOtc , aCouponName , aPointName , aCardNo ,
  aCardMerchantNo ,  aBuyCompanyName,  aBuyCompanyCode, aBuyTypeName,  aOneCardType ,
  aOneCardTypeName , aAcmPoint , aAcmUsablePoint , aAcmCumulationPoint ,
  aTradeBeforeAmount , aTradeAfterAmount ,
  aNocvmYN : PAnsiChar;

  // 응답과정에 필요한거
  GetPaycoData     : TPAYCO_GetPaycoData;
  GetPaycoListCount: TPAYCO_GetPaycoListCount;
  GetPaycoListData : TPAYCO_GetPaycoListData;
begin
  Result.Result := False;
  try
    @GetPaycoData      := GetProcAddress(DLLHandle, 'GetPaycoData');
    @GetPaycoListCount := GetProcAddress(DLLHandle, 'GetPaycoListCount');
    @GetPaycoListData  := GetProcAddress(DLLHandle, 'GetPaycoListData');

    if not Assigned(@GetPaycoData) then
    begin
      ShowMessage(filPAYCO_DLL + ' 로드 실패 ');
//      Log.Write(ltInfo, ['MakeRecvDataCard :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD]);
      Exit;
    end;

    GetMem(resCd, 1 + 1);
    GetMem(resMsg, 100 + 1);
    GetMem(aTradeMethod, 3 + 1);
    GetMem(aServiceType, 6 + 1);
    GetMem(aTradeNo, 20 + 1);
    GetMem(aPaymentMethodCode, 2 + 1);
    GetMem(aTradeDatetime, 14 + 1);
    GetMem(aApprovalAmount, 8 + 1);
    GetMem(aQuota, 2 + 1);
    GetMem(aPointAmt, 8 + 1);
    GetMem(aCouponAmt, 8 + 1);
    GetMem(aApprovalCompanyCode, 6 + 1);
    GetMem(aPaymentMethodName, 60 + 1);
    GetMem(aApprovalCompanyName, 60 + 1);
    GetMem(aMerchantKey, 6 + 1);
    GetMem(aMerchantName, 60 + 1);
    GetMem(aPayonCardOtc, 6 + 1);
    GetMem(aCouponName, 60 + 1);
    GetMem(aPointName, 60 + 1);
    GetMem(aCardNo, 30 + 1);
    GetMem(aCardMerchantNo, 100 + 1);
    GetMem(aBuyCompanyName, 100 + 1);
    GetMem(aBuyCompanyCode, 100 + 1);
    GetMem(aBuyTypeName, 100 + 1);
    GetMem(aOneCardType, 100 + 1);
    GetMem(aOneCardTypeName, 100 + 1);
    GetMem(aAcmPoint, 100 + 1);
    GetMem(aAcmUsablePoint, 100 + 1);
    GetMem(aAcmCumulationPoint, 100 + 1);
    GetMem(aNocvmYN, 100 + 1);
    GetMem(aTradeBeforeAmount, 100 + 1);
    GetMem(aTradeAfterAmount, 100 + 1);

    Zeromemory(resCd, 1 + 1);
    Zeromemory(resMsg, 100 + 1);
    Zeromemory(aTradeMethod, 3 + 1);
    Zeromemory(aServiceType, 6 + 1);
    Zeromemory(aTradeNo, 20 + 1);
    Zeromemory(aPaymentMethodCode, 2 + 1);
    Zeromemory(aTradeDatetime, 14 + 1);
    Zeromemory(aApprovalAmount, 8 + 1);
    Zeromemory(aQuota, 2 + 1);
    Zeromemory(aPointAmt, 8 + 1);
    Zeromemory(aCouponAmt, 8 + 1);
    Zeromemory(aApprovalCompanyCode, 6 + 1);
    Zeromemory(aPaymentMethodName, 60 + 1);
    Zeromemory(aApprovalCompanyName, 60 + 1);
    Zeromemory(aMerchantKey, 6 + 1);
    Zeromemory(aMerchantName, 60 + 1);
    Zeromemory(aPayonCardOtc, 6 + 1);
    Zeromemory(aCouponName, 60 + 1);
    Zeromemory(aPointName, 60 + 1);
    Zeromemory(aCardNo, 30 + 1);
    Zeromemory(aCardMerchantNo, 100 + 1);
    Zeromemory(aBuyCompanyName, 100 + 1);
    Zeromemory(aBuyCompanyCode, 100 + 1);
    Zeromemory(aBuyTypeName, 100 + 1);
    Zeromemory(aOneCardType, 100 + 1);
    Zeromemory(aOneCardTypeName, 100 + 1);
    Zeromemory(aAcmPoint, 100 + 1);
    Zeromemory(aAcmUsablePoint, 100 + 1);
    Zeromemory(aAcmCumulationPoint, 100 + 1);
    Zeromemory(aNocvmYN, 100 + 1);
    Zeromemory(aTradeBeforeAmount, 100 + 1);
    Zeromemory(aTradeAfterAmount, 100 + 1);

    aPointAmt := 0;
    aCouponAmt := 0;

    // 승인 및 취소 결과 값을 받는다  “0” : 정상
    resCd   := GetPaycoData('ResCd');//거래결과코드
    resMsg  := GetPaycoData('ResMsg');//거래결과메세지

//    Log.Write(ltInfo, ['MakeRecvDataPayco 응답 :'+ IntToStr(Index) , ' 응답메세지  : ' + resMsg]);
    // 승인 및 취소 결과 값  '0' : 정상 일경우
    if resCd = '0' then
    begin
        Result.Result := True;                  // 성공여부
        Result.Code   := resCd;                 // 응답코드

        //거래 방식 값 ->  ('VAN' / 'PG')
        aTradeMethod  := GetPaycoData('TradeMethod');
        //서비스 타입 값을 받는 함수 (“PAYCO” / “PAYON” / “TMONEY”)
        aServiceType  := GetPaycoData('ServiceType');

        //거래번호를 받는 함수 취소시 사용
        aTradeNo                    :=  GetPaycoData('TradeNo');
        //거래 일시를 받는 함수 취소시 사용
        if Approval = True then
          aTradeDatetime              := GetPaycoData('ApprovalDatetime')
        else
          aTradeDatetime              := GetPaycoData('CancelDatetime');

        //결제 수단 코드를 받는 함수 취소시 사용
        aPaymentMethodCode          :=  GetPaycoData('PaymentMethodCode');
        //결제 수단명을 받는 함수
        aPaymentMethodName          :=  GetPaycoData('PaymentMethodName');
        //승인 번호를 받는 함수 취소시 사용
        aApprovalNo                 :=  GetPaycoData('ApprovalNo');
        //승인 금액을 받는 함수  취소시 사용
        aApprovalAmount             :=  GetPaycoData('ApprovalAmount');
        //할부 기간을 받는 함수 취소시 사용
        aQuota                      := GetPaycoData('InstallmentPeriod');
        //승인사명을 받는 함수 취소시 사용
        aApprovalCompanyName        :=  GetPaycoData('ApprovalCompanyName');
        //승인사 코드를 받는 함수  취소시 사용
        aApprovalCompanyCode        := GetPaycoData('ApprovalCompanyCode');
        //가맹점 키
        aMerchantKey                :=  GetPaycoData('MerchantKey');
        //가맹점명
        aMerchantName               :=  GetPaycoData('MerchantName');
        //카드번호
        aCardNo                     :=  GetPaycoData('CardNo');

        //  거래 방식 'VAN' 타입인 경우
        if aTradeMethod = 'VAN' then
        begin
           // 카드 가맹점번호
           aCardMerchantNo      := GetPaycoData('CardMerchantNo');
           // 매입사명
           aBuyCompanyName      := GetPaycoData('BuyCompanyName');
           // 매입사코드
           aBuyCompanyCode      := GetPaycoData('BuyCompanyCode');
           // 매입방법명
           aBuyTypeName         := GetPaycoData('BuyTypeName');
           // 원카드타입
           aOneCardType         := GetPaycoData('OneCardType');
           // 원카드타입명
           aOneCardTypeName     := GetPaycoData('OneCardTypeName');
           // 적립포인트
           aAcmPoint            := GetPaycoData('AcmPoint');
           // 사용가능 적립포인트
           aAcmUsablePoint      := GetPaycoData('AcmUsablePoint');
           // 누적 적립포인트
           aAcmCumulationPoint  := GetPaycoData('AcmCumulationPoint');
           // NoCVM 거래 여부
           aNocvmYN             := GetPaycoData('NocvmYN');
        end;

        if aServiceType = 'PAYCO' then       // 25. PAYCO 결제시
        begin
          if Approval  then     // 승인일 경우
          begin
            //사용 쿠폰 금액
            aCouponAmt          := GetPaycoData('CouponAmt');
            //사용 포인트 금액
            aPointAmt           := GetPaycoData('PointAmt');
            //사용 쿠폰명
            aCouponName         := GetPaycoData('CouponName');
            //사용 포인트명
            aPointName          := GetPaycoData('PointName');
          end
          else
          begin
            //가맹점명
            aMerchantName       := GetPaycoData('MerchantName');
          end;
        end
        else if aServiceType = 'TMONEY' then     // 26. TMONEY 결제시
        begin
          //결제전잔액
          aTradeBeforeAmount      := GetPaycoData('TradeBeforeAmount');
          //결제후잔액
          aTradeAfterAmount       := GetPaycoData('TradeAfterAmount');
        end;

        // Payco 응답정보
        Result.Msg                   := resMsg;                              // 응답메세지
        Result.AgreeNo               := aApprovalNo;                         // 승인번호
        Result.TradeNo               := aTradeNo;                            // 거래번호

        if Copy(aTradeDatetime, 1, 2) <> '20' then
          Result.TransDateTime         := '20' + aTradeDatetime            // 거래일시(yyyymmddhhnnss)
        else
          Result.TransDateTime       := aTradeDatetime;                      // 거래일시(yyyymmddhhnnss)

        Result.PaymentMethodCode     := aPaymentMethodCode;                  // 결제수단 코드를 세팅  Example : PAYCO, PAYON : 00 티머니 : 01
        Result.AgreeAmt              := Amt;                                 // 승인금액

        if Trim(aApprovalAmount) <> '' then
          Result.ApprovalAmount      := StrToInt(aApprovalAmount)            // 포인트 및 쿠폰 금액을 제외 한 승인 금액
        else
          Result.ApprovalAmount      := 0;

        if Trim(aPointAmt) <> '' then
          Result.PointAmt            := StrToInt(aPointAmt)                  // 포인트금액
        else
          Result.PointAmt            := 0;

        if Trim(aCouponAmt) <> '' then
          Result.CouponAmt           := StrToInt(aCouponAmt)                 // 쿠폰금액
        else
          Result.CouponAmt           := 0;

        Result.ServiceType           := aServiceType;                        // 서비스 타입 값 (“PAYCO” / “PAYON” / “TMONEY”)
        Result.HalbuMonth            := aQuota;                              // 할부개월
        Result.ApprovalCompanyName   := aApprovalCompanyName;                // 승인사명
        Result.ApprovalCompanyCode   := aApprovalCompanyCode;                // 승인사코드
        Result.MerchantKey           := aCardMerchantNo; //  aMerchantKey;   // 가맹점키
        Result.MerchantName          := aMerchantName;                       // 가맹점명
        Result.CouponName            := aCouponName;                         // 쿠폰명
        Result.PointName             := aPointName;                          // 포인트명
        Result.PayonCardOtc          := aPayonCardOtc;                       // PAYON 서비스 VAN 방식일 때 OTC 값
        Result.RevCardNo             := aCardNo;                             // 카드번호
        Result.BuyCompanyName        := aBuyCompanyName;                     // 매입사명
        Result.BuyCompanyCode        := aBuyCompanyCode;                     // 매입사코드
        Result.BuyTypeName           := aBuyTypeName;                        // 매입방법명
        Result.OneCardType           := aOneCardType;                        // 원카드타입
        Result.OneCardTypeName       := aOneCardTypeName;                    // 원카드타입명

        if Trim(aAcmPoint) <> '' then
          Result.AcmPoint              := StrToInt(aAcmPoint)                // 적립포인트
        else
          Result.AcmPoint              := 0;                                 // 적립포인트

        if Trim(aAcmUsablePoint) <> '' then
           Result.AcmUsablePoint        := StrToInt(aAcmUsablePoint)         // 사용가능 적립포인트
        else
           Result.AcmUsablePoint        := 0;                                // 사용가능 적립포인트

        if Trim(aAcmCumulationPoint) <> '' then
           Result.AcmCumulationPoint    := StrToInt(aAcmCumulationPoint)     // 누적 적립포인트
        else
           Result.AcmCumulationPoint    := 0;                                // 누적 적립포인트

        if Trim(aTradeBeforeAmount) <> '' then
           Result.TradeBeforeAmount    := StrToInt(aTradeBeforeAmount)       // 결제전잔액
        else
           Result.TradeBeforeAmount    := 0;                                 // 결제전잔액

        if Trim(aTradeAfterAmount) <> '' then
           Result.TradeAfterAmount    := StrToInt(aTradeAfterAmount)         // 결제후잔액
        else
           Result.TradeAfterAmount    := 0;                                  // 결제후잔액
//        Log.Write(ltInfo, ['MakeRecvDataPayco 응답코드 :'+ IntToStr(Index) , ' 응답메세지  : ' + resMsg +
//                         ' 승인번호 : ' + aApprovalNo + ' 거래번호 : ' + aTradeNo + ' 카드번호 : ' + aCardNo]);
    end
    else
      Result.Msg := resMsg;
  finally
  end;
end;

function TPaycoNewModule.SetCofig(const Value: TPaycoNewConfig): Boolean;
var
  // 환경설정
  NfcInit     : TPAYCO_NfcInit;
  SetPaycoData: TPAYCO_SetPaycoData;
begin
  try
    Result := False;
    @NfcInit      := GetProcAddress(DLLHandle, 'NfcInit');
    @SetPaycoData := GetProcAddress(DLLHandle, 'SetPaycoData');

    if not Assigned(@NfcInit) and not Assigned(@SetPaycoData) then
    begin
      ShowMessage(filPAYCO_DLL + ' 로드 실패 ');
//      Log.Write(ltInfo, ['SetCofig :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD]);
      Exit;
    end;

    // 초기화후
    NfcInit;
    if UseMode = 0 then                                       // VAN MODE
    begin
      // VAN 코드 설정
      SetPaycoData('VanCode', Value.VanCode);
      // 자동등록여부
      if TestMode = False then
      begin
        // 사업자번호 설정
        SetPaycoData('RegistrationNumber', Value.BizNo);
        // VAN POSID 설정
        SetPaycoData('VanPosId', Value.VanPosID);
      end;
      if Value.VanCode = 'SMTR' then
      begin
        // VAN MerchantCode 설정
        SetPaycoData('MerchantCode', 'SPOS');
        // VAN PosEntryMode 설정
        SetPaycoData('PosEntryMode', '00');
      end
      else if Value.VanCode = 'FDIK' then
      begin
        // VAN MerchantPosNo 설정
        SetPaycoData('MerchantPosNo', Value.VanSerialID);
      end;
      // 자동등록여부
      // PAYCO 요청으로 SetAutoPosRegisterYN > AutoPosRegisterYN으로 변경
      if TestMode = True then
        SetPaycoData('AutoPosRegisterYN', 'N')
      else
        SetPaycoData('AutoPosRegisterYN', 'Y');

      // 페이코 결제창을 최상단으로
      // SetPaycoData('WindowTopMostYN', 'Y');
      // 동글이가 사인패드가 장착여부 판단

//      if VanModul.SignPad then
//        SetPaycoData('SignpadYN', 'Y')
//      else
        SetPaycoData('SignpadYN', 'N');

      // 동글이가 사인패드 이벤트 POS 에서 처리할지 아님 PAYCO에서 처리할지 설정
      SetPaycoData('SignEventUseYN', 'Y');
      // 망취소 요청기능 사용여부
      SetPaycoData('SendNetworkCancelYN', 'Y');
      // TopMost 여부
      SetPaycoData('WindowTopMostYN', 'Y');
     end
    else                                                      // PG MODE
    begin
      // VAN 코드 설정
      SetPaycoData('VanCode', 'KCP');
      // 동글이가 사인패드 이벤트 POS 에서 처리할지 아님 PAYCO에서 처리할지 설정
      SetPaycoData('SignEventUseYN', 'Y');
      // 망취소 요청기능 사용여부
      SetPaycoData('SendNetworkCancelYN', 'Y');
    end;
    Result := True;
  finally
  end;
end;

function TPaycoNewModule.ReadINIFirstKey: Boolean;
var
  AppPath: string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  with TIniFile.Create(AppPath + _INI_PAYCO) do
  begin
    try
      Result := ReadBool('KEY', FormatDateTime('yyyymmdd', Now), False);
    finally
      Free;
    end;
  end;
end;

procedure TPaycoNewModule.WriteINIFirstKey;
var
  AppPath: string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  with TIniFile.Create(AppPath + _INI_PAYCO) do
  begin
    try
      WriteBool('KEY', FormatDateTime('yyyymmdd', Now), True);
    finally
      Free;
    end;
  end;
end;

function TPaycoNewModule.SetClose: Boolean;
var
  // 종료과정에 필요한거
  NfcSendASyncEnd: TPAYCO_NfcSendASyncEnd;
begin
//  Log.Write(ltInfo, ['TPaycoNewModule.SetClose 실행'] );
  try
    @NfcSendASyncEnd := GetProcAddress(DLLHandle, 'NfcSendASyncEnd');
    if not Assigned(@NfcSendASyncEnd) then
    begin
      ShowMessage(filPAYCO_DLL + ' 로드 실패 ');
//      Log.Write(ltInfo, ['SetClose :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // 종료과정진행
    NfcSendASyncEnd;
  finally
  end;
end;

procedure TPaycoNewModule.PaycoRevClose;
begin
  if PaycoRevForm <> nil then
  begin
    PaycoRevForm.Close;
    FreeAndNil(PaycoRevForm);
  end;
end;

procedure TPaycoNewModule.PaycoRevOpen;
begin
//  Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevOpen']);
  if PaycoRevForm  = nil then
  begin
//    Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevForm = nil']);
//    PaycoRevForm := TPaycoRevForm.Create(Application);
    PaycoRevForm := TPaycoRevForm.Create(nil);
    PaycoRevForm.Show;
    PaycoRevForm.Update;
  end;
end;

function TPaycoNewModule.PaycoRevCheck: Boolean;
var
  GetTime: Cardinal;
  aSignData, aSignEtcData, AppPath, aRevMsg: AnsiString;
  // 서명패드 사인이미지값을 처리합니다
  NfcSendSignData: TPAYCO_NfcSendSignData;
begin
//  Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevCheck Start']);
  Result       := False;
  aSignData    := EmptyStr;
  aSignEtcData := EmptyStr;
  aRevMsg      := EmptyStr;
  AppPath      := ExtractFilePath(Application.ExeName);

  // 응답 처리
  GetTime := GetTickCount;
  // 응답 대기시간이 5분도 상관없지만 이후 처리가 필요하다.
  while GetTime + (600 * 1000) > GetTickCount do
  begin
    Application.ProcessMessages;
   // if PaycoRevForm.RevState <> 0 then
   // Log.Write(ltInfo, ['PaycoRevCheck :' , 'PaycoRevForm.RevState : ' + IntToStr(PaycoRevForm.RevState) ] );
    if PaycoRevForm.RevState = 1 then            // 결제완료일경우
    begin
      Result := True;
      SetClose;
      PaycoRevForm.RevState := 0;
      Exit;
    end
    else if PaycoRevForm.RevState = 9 then       // 강제종료일경우
    begin
      SetClose;
      Exit;
    end
    else if PaycoRevForm.RevState = 2 then       // 서명요청일경우
    begin
      try
//        Log.Write(ltInfo, ['PaycoRevCheck : ', PaycoRevForm.RevMsg]);
        aRevMsg :=  PaycoRevForm.RevMsg;    // 현재까지는 FDIK에서만 사용합니다.

        @NfcSendSignData := GetProcAddress(DLLHandle, 'NfcSendSignData');
        if not Assigned(@NfcSendSignData) then
        begin
          ShowMessage(filPAYCO_DLL + ' 로드 실패 ');
//          Log.Write(ltInfo, ['PaycoRevCheck :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ]);
          Exit;
        end;

        // 승인금액 | 할부기간 | 예비1 | 예비2 | 예비3
        {if VanModul.CallSignPad(FloatToStr(TotPayAmt), '00', '', '', aRevMsg, aSignData, aSignEtcData, aGubun)then
        begin
          if aGubun = CODE_ONE then
            aResultMsg := 'SUCCESS'
          else if aGubun = CODE_TWO then
            aResultMsg := 'EXCEPTION';
          NfcSendSignData(aResultMsg, IntToStr(Length(aSignData)), aSignData,AppPath + VanModul.SignImageName, aSignEtcData);
          PaycoRevForm.RevState := 0;
        end
        else
        begin
          if aGubun = CODE_TWO then
            aResultMsg := 'EXCEPTION'
          else if aGubun = CODE_THREE then
            aResultMsg := 'SIGN_CANCEL';
          NfcSendSignData(aResultMsg, IntToStr(Length(aSignData)), aSignData,AppPath + VanModul.SignImageName, aSignEtcData);
          PaycoRevForm.RevState := 0;
        end; }
      finally
      end;
    end
  end;
//  Log.Write(ltInfo, ['TPaycoNewModule', 'PaycoRevCheck End']);
end;

function TPaycoNewModule.SetOpen: Boolean;
var
  // 개점과정에 필요한거  ( 포스 실행할때마다 최초 1회 )
  NfcDailyRun: TPAYCO_NfcDailyRun;
begin
  try
    Result := False;
//    ini 파일을 읽지 않고 포스 실행시 무조건 호출
//    if ReadINIFirstKey = True then Exit;

    @NfcDailyRun := GetProcAddress(DLLHandle, 'NfcDailyRun');
    if not Assigned(@NfcDailyRun) then
    begin
      ShowMessage(filPAYCO_DLL + ' 로드 실패 ');
//      Log.Write(ltInfo, ['SetOpen :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // 개점과정진행
    NfcDailyRun;
//    ini 파일을 읽지 않고 포스 실행시 무조건 호출
//    WriteINIFirstKey;
    Result := True;
  finally
  end;
end;

procedure TPaycoNewModule.SetBarcode(ABarcode: AnsiString);
var
  NfcSendBarcode: TPAYCO_NfcSendBarcode;
begin
  try
    @NfcSendBarcode := GetProcAddress(DLLHandle, 'NfcSendBarcode');

    if not Assigned(@NfcSendBarcode) then
    begin
      ShowMessage('SendBarcode 없다');
    end;
    Delay(1500);
    NfcSendBarcode(ABarcode);
  finally

  end;
end;

function TPaycoNewModule.SetCancel: Boolean;
var
  // 망취소작업
  NfcSendNetworkCancel: TPAYCO_NfcSendNetworkCancel;
begin
  try
    Result := False;
    @NfcSendNetworkCancel := GetProcAddress(DLLHandle, 'NfcSendNetworkCancel');

    if not Assigned(@NfcSendNetworkCancel) then
    begin
      ShowMessage(filPAYCO_DLL + ' 로드 실패 ');
//      Log.Write(ltInfo, ['SetCancel :'+ filPAYCO_DLL + MSG_ERR_DLL_LOAD ] );
      Exit;
    end;
    // 망취소 요청기능 사용
    NfcSendNetworkCancel;
    Result := True;
  finally
  end;
end;

end.
