(*******************************************************************************
  밴 독립모듈(Daemon or vCAT or Agent)방식의 신용카드 승인 모듈

  TVanDaemonModule 메인 클래스: 외부 POS 프로그램과 연동되는 메인클래스로 이 클래스를 생성하여 사용한다.
  TVanDaemon 밴사별 승인 클래스: 추상 상위 클래스로 구현 로직 없이 인터페이스만 있음. 각밴사 별로 이 클래스를 상속 받아 구현한다.

             명칭       다중사업자  직전서명  화면서명  현금IC  핀패드(별도호출)
  KFTC     KFTCOneCAP        O                                        X
  Kicc     EasyCardK         O         #         O         #
  Kis      KIS-AGENT         O                                        O
  FDIK     Win4POS           #                   O                    X
  Koces    KocesICPos        O         X         O         #          X
  KSNET    KSCAT             O         O         O                    X
  JTNET    JTtPayDaemon      O         O         O                    O
  Nice     NiceVirtualCAT    O                   O                    X
  Smartro  V-CAT             O         X         O         X          X
  KCP      NHNKCPSecurePOS   O                   O                    X
  DAOU     DaouVP            O         X         O         O          X
  KOVAN    VPOS              O         O                   #          X
  SPC      SpcnVirtualPos    O         O         O         O          X

  *** 핀패드 별도 호출은 신용승인 및 현금승인시 핀패드를 사용하는것이 아닌
      거래와 상관없이 별도로 핀패드 입력 기능만 호출 하는 경우를 말함.
      O:구현완료  X:기능없음  #:모듈에서는 기능 지원하나 미개발

  << 각밴사별 개발 담당자 연락처 >>

           담당자             부서                   전화번호          이메일
  KFTC     정원석 계장        e사업본부 상품개발팀   T) 02-531-3475    enaseok@kftc.or.kr
                                                     H) 010-8649-9089
  Kicc     임소연 주임        기술연구소             T) 02-368-0844    soyeon0201@kicc.co.kr
  Kis      김민태 대리        연구개발1실            T) 02-2101-1657   mtkim@kisvan.co.kr
                                                     H) 010-2323-5486
  FDIK     최병현 대리        IT운영팀               T) 02-2287-3075   Dottore.choi@firstdata.com
           이진규             IT 개발팀              T) 02-2287-3105   bill.lee@firstdatacorp.co.kr
                                                     H) 010-8897-5467
  Koces    강성길 대리        정보개발팀             T) 02-3415-3715   ksk3197@koces.com
  KSNET    이준호 주임        개발4팀                T) 02-3420-6876   ultrajunho@ksnet.co.kr
  JTNET    박승민 대리        VAN 개발팀             T) 02-801-7886    seungmin@jtnet.co.kr
  Nice     김선호 과장        채널사업본부           T) 02-2187-2843   sun@nicevan.co.kr
                                                     H) 010-2287-0565
  Smartro  심규성 과장        솔루션개발실           T) 02-2109-9046   ksshim@smartro.co.kr
                              POS개발팀              H) 010-3014-1809
           김세영 대리        POS개발팀              T) 02-2109-9881   seyoungkim@smartro.co.kr
                                                     H) 010-4125-6894
  KCP      정주필 과장        솔루션 개발팀          T) 070-7595-1221  jpjung@kcp.co.kr
           최소은 사원        솔루션 개발팀          T) 070-7595-1225  sechoi@kcp.co.kr
           김민태 사원        인프라본부 VAN팀       T) 070-7595-1219  mtkim@kcp.co.kr
                                                     H) 010-2323-5486
  DAOU     권오환 대리        온라인개발팀           T) 02-3410-5172   ohkwon@daoudata.co.kr
  KOVAN    박기남 책임연구원  ClientSystem 개발팀    T) 070-4000-9148  kinam@kovan.com
  SPC      하지훈 과장        연구개발팀             T) 02-2276-6757   haji2101@spc.co.kr
                                                     H) 010-2970-8105
           서지은 사원        연구개발팀             T) 02-2276-6763   impact@spc.co.kr
                                                     H) 010-4880-5822
*******************************************************************************)
unit uVanDaemonModule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, StrUtils, Math, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdGlobal, IdSync, IdURI, IdTCPClient, IdHTTP,
  {$IF RTLVersion < 19.00}
  ScktComp,
  {$IFEND}
  ShellApi, uVanFunctions, KisPosAgentLib_TLB, SmtSndRcvVCATLib_TLB;

const
  // 밴사 코드
  VAN_CODE_KFTC    = 'KFTC';
  VAN_CODE_KICC    = 'KICC';
  VAN_CODE_KIS     = 'KIS';
  VAN_CODE_FDIK    = 'FDIK';
  VAN_CODE_KOCES   = 'KOCES';
  VAN_CODE_KSNET   = 'KSNET';
  VAN_CODE_JTNET   = 'JTNET';
  VAN_CODE_NICE    = 'NICE';
  VAN_CODE_SMARTRO = 'SMARTRO';
  VAN_CODE_KCP     = 'KCP';
  VAN_CODE_DAOU    = 'DAOU';
  VAN_CODE_KOVAN   = 'KOVAN';
  VAN_CODE_SPC     = 'SPC';

type
  // 승인 전송정보 (데몬방식)
  TCardSendInfoDM = record
    // 공통 승인 정보
    Approval: Boolean;                 // 승인/취소 여부
    SaleAmt: Currency;                 // 결제(승인)금액 (수표금액)
    SvcAmt: Currency;                  // 봉사료
    VatAmt: Currency;                  // 부가세
    FreeAmt: Currency;                 // 면세금액
    CardNo: AnsiString;                // 카드번호(Key-in거래시 -> 카드번호=유효기간)
    KeyInput: Boolean;                 // 키인여부
    TrsType: AnsiString;               // 거래형태('':일반신용, 'A':앱카드)
    OrgAgreeNo: AnsiString;            // 원승인번호(취소시)
    OrgAgreeDate: AnsiString;          // 원승인일자(취소시)
    // 신용카드 관련
    HalbuMonth: Integer;               // 할부개월
    EyCard: Boolean;                   // 은련카드 거래

    // 현금영수증 관련
    Person: Integer;                   // 거래(개인/사업자)구분 (1:소득공제, 2:지출증빙, 3:자진발급)
    CancelReason: Integer;             // 취소사유코드 (1:거래취소, 2:오류발급, 3:기타)
    // 수표조회 관련
    CheckNo: AnsiString;               // 수표번호
    BankCode: AnsiString;              // 발행은행코드
    BranchCode: AnsiString;            // 발행은행 영업점코드
    KindCode: AnsiString;              // 권종코드 (13:10만원, 14:30만원, 15:50만원, 16:100만원, 19:기타)
    RegDate: AnsiString;               // 수표발행일
    AccountNo: AnsiString;             // 계좌일련번호(단위농협/수협일 경우)
    // 설정 정보 : 밴사별로 처리 방법이 다름 (아래 주석 내용 참조)
    TerminalID: AnsiString;            // 승인 TID
    BizNo: AnsiString;                 // 사업자번호
    SignOption: AnsiString;            // 서명거래 옵션 (Y:서명사용, N:무서명, R:재사용, T:화면서명)
    Reserved1: AnsiString;             // 예비항목1
    Reserved2: AnsiString;             // 예비항목2
    Reserved3: AnsiString;             // 예비항목3
    OTCNo: AnsiString;                 // 앱카드 OTC번호
    CardBinNo: AnsiString;             // 카드 Bin번호
  end;

(*
  << TerminalID : 승인TID >>

  KFTC    : 다중 사업자 결제시에만 사용 (데몬에 설정 있음, 미입력시 데몬 설정값 사용)
  Kicc    : 다중 사업자 결제시에만 사용 (데몬에 설정 있음)
  Kis     : 다중 사업자 결제시에만 사용 (데몬에 설정 있음, 미입력시 데몬 설정값 사용)
  FDIK    : 필수 입력 (단말기 번호 대신 제품 일련 번호를 입력함)
  Koces   : 다중 사업자 결제시에만 사용 (데몬에 설정 있음, 환경설정 비밀번호: 3415)
  KSNET   : 필수 입력 (데몬에 설정 없음)
  JTNET   : 필수 입력 (데몬에 설정 없음)
  Nice    : 다중 사업자 결제시에만 사용 (데몬에 설정 있음, 미입력시 데몬 설정값 사용)
  Smartro : 다중 사업자 결제시에만 사용 (데몬에 설정 있음, 환경설정 비밀번호: 7279 기타설정->기타설정탭에서 VCAT UI로 표시, 활성화 기능 사용안함에 체크할것.)
  KCP     : 데몬 환경설정에 다중 단말기 사용에 체크된 경우에만 사용됨
  DAOU    : 필수 입력 (데몬에 설정 있음)
  KOVAN   : (환경설정 ID:0000 PW:1234)
  SPC     : 필수 입력 (데몬에 설정 없음), 가맹점다운로드를 포스에서 해야함 데몬에 없음

  << BizNo : 사업자번호 >>

  KFTC    : 사용안함
  Kicc    : 사용안함
  Kis     : 사용안함
  FDIK    : 승인 거래시 필수 입력
  Koces   : 다중 사업자 결제시에만 사용
  KSNET   : 사용안함
  JTNET   : 사용안함
  Nice    : 사용안함
  Smartro : 사용안함
  KCP     : 사용안함
  DAOU    : 사용안함
  KOVAN   : 다중 사업자 결제시에만 사용
  SPC     : 가맹점 다운로드시 사업자번호 필수입력

  << SignOption : 서명 거래 옵션 >>
    Y : 장착된 서명패드를 사용함.(장치 포트 및 속도가 세팅되어 있어야 함)
    N : 서명 안함. (서명패드가 장착되어 있으나 서명 없이 승인 처리 하고자 할때 사용)
    R : 직전서명 재사용(다중 사업자 매장일때 한 전표에서 동일 카드로 두번의 승인을 할때 이전 거래한 서명을 재사용 하고자 할때 사용)
    T : 화면서명 처리 (키오스크와 같이 부착된 서명패드 없이 화면 터치방식으로 처리함)

  KFTC    : 사용가능 옵션 -> Y, N  나머지 기능은 미구현
  Kicc    : 사용 안함. 데몬 환경설정에서 모두 설정함.
  Kis     : 사용가능 옵션 -> Y, N, R 화면서명은 데몬설정에서 서명패드 Port를 -1으로 설정한다.
  FDIK    : 사용가능 옵션 -> Y, N 화면서명은 환경설정 INI 파일에서 설정한다. CFG/Win4POS.ini -> VirtualSignpadUseYN=Y
  Koces   : 사용 안함. 데몬 환경설정에서 모두 설정함.
  KSNET   : 사용가능 옵션 -> Y, N, R, T
  JTNET   : 사용가능 옵션 -> Y, N, R 화면서명은 데몬설정에서 서명패드 Port를 0으로 설정한다.
  Nice    : 사용 안함. 데몬 환경설정에서 모두 설정함.
  Smartro : 사용가능 옵션 -> Y, N 화면서명은 데몬에서 설정함.
  KCP     : 사용 안함. 데몬 환경설정에서 모두 설정함.
  DAOU    : 사용가능 옵션 -> T 데몬 설정에서 키오스크 모드로 설정할것. (INI파일 IS_KIOSK=Y)
  KOVAN   : 사용가능 옵션 -> Y, R
  SPC     : 사용가능 옵션 -> Y, N, R 화면서명은 데몬설정에서 서명패드 Port를 설정한다.

  << Reserved1~3 : 예비항목 >>

  KFTC    : 사용안함
  Kicc    : 사용안함
  Kis     : 사용안함
  FDIK    : 사용안함
  Koces   : 다중 사업자 결제시 Reserved1에 시리얼번호를 입력한다.
  KSNET   : 사용안함
  JTNET   : 사용안함
  Nice    : 사용안함
  Smartro : 사용안함
  KCP     : 테슬라 매장용일때 Reserved1에 R/N번호를 넣는다. (OFFPG거래)
  DAOU    : Reserved1에 부사업자 단말기번호를 넣는다. (다중사업자 결제시 부사업자로 승인 받는 경우만 사용)
            주사업자 결제시에는 빈칸으로 넣는다. (ini 파일에 다중사업자 관련 세팅을 해야함.)
  KOVAN   :
  SPC     : Reserved1에 다중사업자 결제시 'Y'를 넣는다.
*)

  // 승인 응답정보 (데몬방식)
  TCardRecvInfoDM = record
    // 공통 응답
    Result: Boolean;                   // 성공여부
    Code: AnsiString;                  // 응답코드
    Msg: AnsiString;                   // 응답메세지
    AgreeNo: AnsiString;               // 승인번호
    AgreeDateTime: AnsiString;         // 승인일시(yyyymmddhhnnss)
    CardNo: AnsiString;                // 마스킹 카드번호
    // 신용카드 응답일때만 아래 정보가 세팅됨.
    TransNo: AnsiString;               // 거래번호
    BalgupsaCode: AnsiString;          // 발급사코드
    BalgupsaName: AnsiString;          // 발급사명
    CompCode: AnsiString;              // 매입사코드
    CompName: AnsiString;              // 매입사명
    KamaengNo: AnsiString;             // 가맹점번호
    AgreeAmt: Integer;                 // 승인금액
    DCAmt: Integer;                    // 할인금액
    // 신용승인 서명관련 (밴사에 따라 사용안함. 필수 항목이 아니므로 참고만 할것.)
    IsSignOK: Boolean;                 // 정상 서명 여부 (응답전문에 해당 값이 없는 경우 True 리턴함)
    CardBinNo: AnsiString;             // 카드 Bin번호
  end;

  // 밴 데몬방식 상위 모듈
  TVanDaemon = class
  private
  public
    Log: TLog;
    constructor Create; virtual;
    destructor Destroy; override;
    // 개시거래 (가맹점 다운로드)
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; virtual; abstract;
    // 신용카드 승인
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // 현금영수증 승인
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // 현금IC 승인
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // 수표조회
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // 핀패드 입력
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; virtual; abstract;
    // 카드정보 조회
    function CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM; virtual; abstract;
    // 무결성 체크
    function CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean; virtual; abstract;
    // 카드 삽입여부 체크
    function CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean; virtual; abstract;
  end;

  // 밴 데몬 모듈
  TVanDaemonModule = class
  private
    FLog: TLog;
    FVanCode: string;
    procedure SetVanCode(const Value: string);
  public
    // 기본밴
    MainVan: TVanDaemon;

    constructor Create; virtual;
    destructor Destroy; override;
    // 개시거래 (가맹점 다운로드)
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
    // 신용카드 승인
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // 현금영수증 승인
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // 현금IC 승인
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // 수표조회
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // 핀패드 입력
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
    // 카드정보 조회
    function CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // 무결성체크
    function CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean;
    // 카드 삽입여부 체크
    function CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean;

    // 전체 환경 설정 적용 처리
    function ApplyConfigAll: Boolean;
    // VAN사
    property VanCode: string read FVanCode write SetVanCode;
  end;

  // KFTC
  TVanKFTCDaemon = class(TVanDaemon)
  private
    function GetStringSearch(AFID, AStr: string): string;
    function ExecTcpSendData(ASendData: string; out ARecvData: string): Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Kicc
  TVanKiccDaemon = class(TVanDaemon)
  private
    FIndy: TIdHTTP;
    function GetSeqNoKICC: AnsiString;
    function ExecHttpSendRecv(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function MakeSendData(ATranCode, ASignData: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvData(ARecvData: AnsiString): TCardRecvInfoDM;
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Kis
  TVanKisDaemon = class(TVanDaemon)
  private
    KisPosAgent: TKisPosAgent;
    function ExecOcx(ATranCode: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // FDIK
  TVanFDIKDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    FDaemonRunCheck: Boolean;
    // 데몬 프로그램 정상 실행 여부를 체크하여 실행 시켜 준다.
    function CheckDaemonRun(out AErrorMsg: AnsiString): Boolean;
    function DoCallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    function DoCallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    function DoCallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Koces
  TVanKocesDaemon = class(TVanDaemon)
  private
    FDllHandle: THandle;
    // 가맹점 정보 확인 (다중 사업자 매장에서 사용)
    function ExecDownLoadRequest(ATerminalID, ASerial, ABizNo: AnsiString): TCardRecvInfoDM;
    // 승인 호출
    function ExecICRequest(ATrdType, AKeyYN: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
    // 앱카드
    function ExecAppCardRequest(ATrdType: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // KSNET
  TVanKsnetDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataCard(ATransGubun: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // JTNET
  TVanJtnetDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExecAblity(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function DLLExecAuth(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Nice
  TVanNiceDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExecVCat(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // Smartro
  TVanSmartroDaemon = class(TVanDaemon)
  private
    SmtSndRcvVCAT: TSmtSndRcvVCAT;
    function SetSendData(const AIndex: Integer; const AValue: AnsiString; out ARetMsg: AnsiString): Boolean;
    function GetRecvData(const AIndex: Integer): AnsiString;
    function GetErrorMsg(ACode: Integer): AnsiString;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // KCP
  TVanKcpDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function MakeSendDataHeader(AApproval: Boolean; AProcCode, ATerminalID: AnsiString; ADetailSendData: AnsiString): AnsiString;
    function MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
    function MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
    function MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
    function MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
    function DLLExecTrans(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function DLLExecFunction(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    // 가맹점 다운로드 (멀티 TID 사용매장에서 사용함)
    function DoPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
    function CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean; override;
    function CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean; override;
  end;

  // DAOU
  TVanDaouDaemon = class(TVanDaemon)
  private
    FReceiveBuff: string;
    function ExecTcpSendData(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    {$IF RTLVersion < 19.00}
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    function SocketSendReceiveData(AClientSocket: TClientSocket; ASendData: string; out ARecvData: string): Boolean;
    {$IFEND}
    function GetErrorMsg(ACode: AnsiString): AnsiString;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // KOVAN
  TVanKovanDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function DLLExec(ATCode, ATID, AHalbu, ATAmt, AOriDate, AOriAuthNo, ATranSerial, AIdNo, AAmtFlag, ATaxAmt, ASfeeAmt, AFreeAmt, AFiller: AnsiString;
                     out ARecvTranType, ARecvErrCode, ARecvCardno, ARecvHalbu, ARecvTamt, ARecvTranDate, ARecvTranTime, ARecvAuthNo, ARecvMerNo, ARecvTranSerial,
                     ARecvIssueCard, ARecvPurchaseCard, ARecvSignPath, ARecvMsg1, ARecvMsg2, ARecvMsg3, ARecvMsg4, ARecvFiller: AnsiString): Boolean;
    function DoCallExec(ATCode, AHalbu: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

  // SPC
  TVanSpcDaemon = class(TVanDaemon)
  private
    FDLLHandle: THandle;
    function DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
    function GetErrorMsg(ACode: Integer): AnsiString;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM; override;
    function CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM; override;
    function CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean; override;
  end;

implementation

uses
  IniFiles, uKisPosAgentForm, uLkJSON;

type
  // KOCESS
  // 공통 header 부분
  TPGFComHead = record
    ApprVer: array[0..1] of AnsiChar;      // 전문버전 "A1"
    SvcType: array[0..1] of AnsiChar;      // 서비스종류 서비스전문표 참조
    TrdType: array[0..1] of AnsiChar;      // 업무 구분, 업무구분표 참조
    SndType: AnsiChar;                     // 전송구분, 'S': PG->VAN, 'R': VAN->PG
    TermId : array[0..9] of AnsiChar;      // 단말기번호 터미널아이디
    TrdDate: array[0..13] of AnsiChar;     // 거래일시 YYMMDDhhmmss
    TrdNo  : array [0..9] of AnsiChar;     // 거래일련번호 (응답시 반환)
    MchData: array [0..19] of AnsiChar;    // 가맹점 데이타 (응답시 반환)
    AnsCode: array[0..3] of AnsiChar;      // 응답코드 (요청시는 스페이스)
  end;
  // 신용승인 응답
  TPosICResAppr = record
    Header    : TPGFComHead;               // 공통 헤더 부분
    TradeNo   : array[0..11] of AnsiChar;  // Van 서 부여하는 거래 고유번호
    AuNo      : array[0..11] of AnsiChar;  // 승인번호
    TradeDate : array[0..13] of AnsiChar;  // 승인시간 'YYMMDDhhmmss'
    Message   : array[0..31] of AnsiChar;  // 응답 메시지(거절 시 응답 Message)
    CardNo    : array[0..39] of AnsiChar;  // 카드 Bin
    CardKind  : array[0..11] of AnsiChar;  // 카드종류명
    OrdCd     : array[0..3] of AnsiChar;   // 발급사 코드
    OrdNm     : array[0..11] of AnsiChar;  // 발급사 명
    InpCd     : array[0..3] of AnsiChar;   // 매입사 코드
    InpNm     : array[0..7] of AnsiChar;   // 매입사 명
    MchNo     : array[0..15] of AnsiChar;  // 가맹점번호
    PtCardCd  : array[0..1] of AnsiChar;   // 포인트카드 코드
    PtCardNm  : array[0..7] of AnsiChar;   // 포인트카드사 명
    JukPoint  : array[0..8] of AnsiChar;   // 적립포인트
    GayPoint  : array[0..8] of AnsiChar;   // 가용포인트
    NujPoint  : array[0..8] of AnsiChar;   // 누적포인트
    SaleRate  : array[0..8] of AnsiChar;   // 할인율
    PtAuNo    : array[0..19] of AnsiChar;  // 적립승인번호
    PtMchNo   : array[0..14] of AnsiChar;  // 적립가맹점번호
    PtAnswerCd: array[0..3] of AnsiChar;   // 적립응답코드
    PtMessage : array[0..47] of AnsiChar;  // 적립응답메세지
    DDCYN     : AnsiChar;                  // DDC 여부
    EDIYN     : AnsiChar;                  // EDI 여부
    CardType  : AnsiChar;                  // 카드구분  (1:신용, 2:체크, 3:기프트, 4:선불)
    TrdKey    : array[0..11] of AnsiChar;  // 거래 고유키
    KeyRenewal: array[0..1] of AnsiChar;   // 키 갱신일자
    Filler    : array [0..49] of AnsiChar; // 여유필드
  end;
  // 수표조회 응답
  TPGFICBillAppr = record
    Header : TPGFComHead;                  // 공통 헤더 부분
    Message: array[0..39] of AnsiChar;     // 응답메세지
    Filler : array[0..19] of AnsiChar;     // Filler
  end;
  // 가맹점 확인
  TDownResAppr = record
    Header : TPGFComHead;                  // 공통 헤더 부분
    Serial : array[0..19] of AnsiChar;     // 제조일련번호
    Message: array[0..39] of AnsiChar;     // 응답메세지
    SftVer : array[0..4] of AnsiChar;      // 단말기 SW 버전
    ShpNm  : array[0..39] of AnsiChar;     // 가맹점명칭
    BsnNo  : array[0..9] of AnsiChar;      // 가맹점사업자번호
    PreNm  : array[0..19] of AnsiChar;     // 대표자명
    ShpAdr : array[0..49] of AnsiChar;     // 가맹점주소
    ShpTel : array[0..14] of AnsiChar;     // 가맹점전화번호
  end;

  // FDIK
  TFDIK_Daemon_Status    = function(): Integer; stdcall;
  TFDIK_Daemon_MKTranId  = function(Buffer: PAnsiChar; BufferLen: Integer): Integer; stdcall;
  TFDIK_Daemon_Init      = function(TranId, MsgCmd, MsgCert: PAnsiChar): Integer; stdcall;
  TFDIK_Daemon_Input     = function(Key, Value: PAnsiChar): Integer; stdcall;
  TFDIK_Daemon_Execute   = function(): Integer; stdcall;
  TFDIK_Daemon_Create    = function(Server, Port: PAnsiChar): Integer; stdcall;
  TFDIK_Daemon_Output    = function(Key, Buffer: pAnsiChar; Len: Integer): Integer; stdcall;
  TFDIK_Daemon_Destroy   = function(): Integer;
  TFDIK_Daemon_Term      = Function(): Integer;

const
  MSG_ERR_DLL_LOAD        = ' 파일을 불러올 수 없습니다.';
  MSG_ERR_SET_CONFIG_FAIL = '해당 설정은 현재 설정된 밴사에서는 사용할 수 없습니다.' + #13#10 +
                            '(밴사에서 제공하는 프로그램에서 직접 설정하거나 사용되지 않음)';

  STX              = #2;   // Start of Text
  ETX              = #3;   // End of Text
  EOT              = #4;   // End of Transmission
  ENQ              = #5;   // ENQuiry
  ACK              = #6;   // ACKnowledge
  NAK              = #$15; // Negative Acknowledge (#21)
  FS               = #$1C; // Field Separator (#28)
  CR               = #13;  // Carriage Return
  SI               = #15;

  CASH_RCP_AUTO_NUMBER = '0100001234'; // 현금영수증 자진 발급 처리 번호

  // KSNET
  KSNET_DAEMON_DLL  = 'ksnetcomm.dll';
  KSNET_SOLBIPOS    = 'SOLB'; // 업체정보

  // JTNET
  JTNET_DAEMON_DLL  = 'JTPosSeqDmDll.dll';

  // NICE
  NICE_DAEMON_DLL   = 'NVCAT.dll';

  // KCP
  LIBKCP_SECURE_DLL = 'libKCPSecure.dll';
  KCP_VER_INFO      = 'PSOB'; // 솔비포스 운영ID

  // FDIK
  WIN4POS_DLL       = 'Win4POSDll.dll';

  // Koces
  filKOCESIC_DLL      = 'KocesICLib.dll';
  filKOCESIC_DLL_Path = 'C:\Koces\KocesICPos\';
  MSG_SOLBIPOS        = 'Solbipos POS System';

  // DAOU
  TERMINAL_GUBUN1   = '4             ';  // 단말기정보(일반)
  TERMINAL_GUBUN2   = 'Y             ';  // 단말기정보(다중사업자)

  // KOVAN
  KOVAN_DAEMON_DLL  = 'VPos_Client.dll';

  // SPC
  SPC_DAEMON_DLL    = 'SpcnVirtualDll.dll';

{ TVanDaemon }

constructor TVanDaemon.Create;
begin
  Log := TLog.Create;
end;

destructor TVanDaemon.Destroy;
begin
  Log.Free;
  inherited;
end;

{ TVanDaemonModule }

constructor TVanDaemonModule.Create;
begin
  FLog := TLog.Create;
  FLog.Write(ltInfo, ['VanDaemonModul', '2019.01.23.1']);
end;

destructor TVanDaemonModule.Destroy;
begin
  FLog.Write(ltInfo, ['VanDaemonModul', 'Destroy']);
  FLog.Free;
  if MainVan <> nil then
    MainVan.Free;
  inherited;
end;

function TVanDaemonModule.ApplyConfigAll: Boolean;
begin
  FLog.Write(ltInfo, ['VanDaemonModul전체설정적용', FVanCode]);
  if MainVan <> nil then
    FreeAndNil(MainVan);

  if FVanCode = VAN_CODE_KFTC then
    MainVan := TVanKftcDaemon.Create
  else if FVanCode = VAN_CODE_KICC then
    MainVan := TVanKiccDaemon.Create
  else if FVanCode = VAN_CODE_KIS then
    MainVan := TVanKisDaemon.Create
  else if FVanCode = VAN_CODE_FDIK then
    MainVan := TVanFdikDaemon.Create
  else if FVanCode = VAN_CODE_KOCES then
    MainVan := TVanKocesDaemon.Create
  else if FVanCode = VAN_CODE_KSNET then
    MainVan := TVanKsnetDaemon.Create
  else if FVanCode = VAN_CODE_JTNET then
    MainVan := TVanJtnetDaemon.Create
  else if FVanCode = VAN_CODE_NICE then
    MainVan := TVanNiceDaemon.Create
  else if FVanCode = VAN_CODE_SMARTRO then
    MainVan := TVanSmartroDaemon.Create
  else if FVanCode = VAN_CODE_KCP then
    MainVan := TVanKcpDaemon.Create
  else if FVanCode = VAN_CODE_DAOU then
    MainVan := TVanDaouDaemon.Create
  else if FVanCode = VAN_CODE_KOVAN then
    MainVan := TVanKovanDaemon.Create
  else if FVanCode = VAN_CODE_SPC then
    MainVan := TVanSpcDaemon.Create;

  if MainVan <> nil then
    MainVan.Log.DebugLog := True;

  Result := MainVan <> nil;
end;

function TVanDaemonModule.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['개시거래DM', FVanCode, '단말기번호', ATerminalID, '사업자번호', ABizNo]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  try
    Result := MainVan.CallPosDownload(ATerminalID, ABizNo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['개시거래DM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['개시거래DM', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
end;

function TVanDaemonModule.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['신용승인DM', FVanCode, '승인/취소', AInfo.Approval, 'KeyIn', AInfo.KeyInput, '카드번호', AInfo.CardNo,
                       '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt,
                       '거래형태', AInfo.TrsType, '원승인번호', AInfo.OrgAgreeNo, '원승인일자', AInfo.OrgAgreeDate,
                       'TID', AInfo.TerminalID, '사업자', AInfo.BizNo, '서명옵션', AInfo.SignOption,
                       '예비1', AInfo.Reserved1, '예비2', AInfo.Reserved2, '예비3', AInfo.Reserved3]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);
  try
    // 밴 승인 모듈 호출
    Result := MainVan.CallCard(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['신용승인DM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['신용결과DM', Result.Result, '코드', Result.Code, '메세지', Result.Msg, '승인금액', Result.AgreeAmt, '승인번호', Result.AgreeNo, '승인일시', Result.AgreeDateTime, '카드번호', Result.CardNo]);
end;

function TVanDaemonModule.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['현금승인DM', FVanCode, '승인/취소', AInfo.Approval, 'KeyIn', AInfo.KeyInput, '구분', AInfo.Person, '식별번호', AInfo.CardNo,
                       '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt,
                       '원승인번호', AInfo.OrgAgreeNo, '원승인일자', AInfo.OrgAgreeDate,
                       'TID', AInfo.TerminalID, '사업자', AInfo.BizNo, '서명옵션', AInfo.SignOption, '예비1', AInfo.Reserved1, '예비2', AInfo.Reserved2, '예비3', AInfo.Reserved3]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);

  // 자진 발급 일때
  if (AInfo.Person = 3) and (AInfo.CardNo = '') then
    AInfo.CardNo := CASH_RCP_AUTO_NUMBER;
  if AInfo.CardNo = CASH_RCP_AUTO_NUMBER then
    AInfo.Person := 3;

  try
    Result := MainVan.CallCash(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['현금승인DM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['현금결과DM', Result.Result, '코드', Result.Code, '메세지', Result.Msg, '승인금액', Result.AgreeAmt, '승인번호', Result.AgreeNo, '승인일시', Result.AgreeDateTime, '카드번호', Result.CardNo]);
end;

function TVanDaemonModule.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['현금ICDM', FVanCode, '승인/취소', AInfo.Approval, 'KeyIn', AInfo.KeyInput, '카드번호', AInfo.CardNo,
                       '거래금액', AInfo.SaleAmt, '봉사료', AInfo.SvcAmt, '부가세', AInfo.VatAmt, '면세금액', AInfo.FreeAmt,
                       '원승인번호', AInfo.OrgAgreeNo, '원승인일자', AInfo.OrgAgreeDate,
                       'TID', AInfo.TerminalID, '사업자', AInfo.BizNo, '서명옵션', AInfo.SignOption, '예비1', AInfo.Reserved1, '예비2', AInfo.Reserved2, '예비3', AInfo.Reserved3]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  // 부호 양수로
  AInfo.SaleAmt := ABS(AInfo.SaleAmt);
  AInfo.SvcAmt := ABS(AInfo.SvcAmt);
  AInfo.VatAmt := ABS(AInfo.VatAmt);
  AInfo.FreeAmt := ABS(AInfo.FreeAmt);
  try
    // 밴 승인 모듈 호출
    Result := MainVan.CallCashIC(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['현금ICDM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['현금IC결과DM', Result.Result, '코드', Result.Code, '메세지', Result.Msg, '승인금액', IntToStr(Result.AgreeAmt), '승인번호', Result.AgreeNo, '승인일시', Result.AgreeDateTime, '카드번호', Result.CardNo]);
end;

function TVanDaemonModule.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  FLog.Write(ltBegin, ['수표조회DM', FVanCode, '금액', AInfo.SaleAmt]);
  if MainVan = nil then
  begin
    Result.Result := False;
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  try
    Result := MainVan.CallCheck(AInfo);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['수표조회DM', E.Message]);
      Result.Result := False;
      Result.Msg := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['수표조회DM', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
end;

function TVanDaemonModule.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['핀패드DM', FVanCode]);
  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  try
    Result := MainVan.CallPinPad(ASendAmt, ARecvData);
  except on E: Exception do
    begin
      FLog.Write(ltError, ['핀패드DM', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltEnd, ['핀패드DM', ARecvData]);
end;

function TVanDaemonModule.CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  FLog.Write(ltBegin, ['카드정보 조회', FVanCode]);
  if MainVan = nil then
  begin
    Result.Msg := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;

  Result := MainVan.CallCardInfo(AInfo);
end;

function TVanDaemonModule.CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  FLog.Write(ltBegin, ['무결성체크', FVanCode]);
  if MainVan = nil then
  begin
    Result := False;
    ARecvData := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  Try
    Result := MainVan.CallICReaderVerify(ATerminalID, ARecvData);
  except
    on E: Exception do
    begin
      FLog.Write(ltError, ['무결성체크', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltError, ['무결성체크', ARecvData]);
end;

function TVanDaemonModule.CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARespCode := '';
  ARecvData := '';
  FLog.Write(ltBegin, ['IC카드삽입여부체크', FVanCode]);
  if MainVan = nil then
  begin
    Result := False;
    ARespCode := '????';
    ARecvData := 'VAN사가 설정되어 있지 않습니다.';
    Exit;
  end;
  try
    Result := MainVan.CallICCardInsertionCheck(ATerminalID, ASamsungPay, ARespCode, ARecvData);
  except
    on E: Exception do
    begin
      FLog.Write(ltError, ['IC카드삽입여부체크', E.Message]);
      ARecvData := E.Message;
    end;
  end;
  FLog.Write(ltError, ['IC카드삽입여부체크', ARecvData]);
end;

procedure TVanDaemonModule.SetVanCode(const Value: string);
begin
  FVanCode := Value;
end;

{ TVanKFTCDaemon }

constructor TVanKFTCDaemon.Create;
begin
  inherited;

end;

destructor TVanKFTCDaemon.Destroy;
begin

  inherited;
end;

function TVanKFTCDaemon.ExecTcpSendData(ASendData: string; out ARecvData: string): Boolean;
var
  IdTCPClient: TIdTCPClient;
  ALrc: AnsiChar;
begin
  Result := False;
  IdTCPClient := TIdTCPClient.Create(nil);

  ALrc := GetLRC(ASendData + ETX);
  ASendData := STX + ASendData + ETX + ALrc;
  try
    {$IF RTLVersion > 19.00}
    try
      IdTCPClient.Host := '127.0.0.1';
      IdTCPClient.Port := 8002;
      IdTCPClient.ConnectTimeout := 3000;
      IdTCPClient.Connect;
      if IdTCPClient.Connected then
      begin
        Log.Write(ltDebug, ['전송전문', ASendData]);
        IdTCPClient.IOHandler.WriteLn(ASendData, IndyTextEncoding_OSDefault);
        ARecvData := IdTCPClient.IOHandler.ReadLn(ETX, IndyTextEncoding_OSDefault);
        Log.Write(ltDebug, ['응답전문', ARecvData]);
        Result := True;
      end
      else
        ARecvData := '모듈과 연결 실패!!!';
    except on E: Exception do
      ARecvData := '모듈과의 통신중 에러 발생 ' + E.Message;
    end;
    {$ELSE}
    try
      IdTCPClient.Host := '127.0.0.1';
      IdTCPClient.Port := 8002;
      IdTCPClient.Connect(3000);
      if IdTCPClient.Connected then
      begin
        Log.Write(ltDebug, ['전송전문', ASendData]);
        IdTCPClient.WriteLn(ASendData);
        ARecvData := IdTCPClient.ReadLn(ETX);
        Log.Write(ltDebug, ['응답전문', ARecvData]);
        Result := True;
      end
      else
        ARecvData := '모듈과 연결 실패!!!';
    except on E: Exception do
      ARecvData := '모듈과의 통신중 에러 발생 ' + E.Message;
    end;
    {$IFEND}
  finally
    IdTCPClient.Free;
  end;
end;

function TVanKFTCDaemon.GetStringSearch(AFID: string; AStr: string): string;
var
  Index: Integer;
begin
  Result := '';
  // 맨 뒤에 FS가 없기 때문에 추가한다.
  AStr := AStr + FS;
  Index := Pos(FS, AStr);
  while Index > 0 do
  begin
    if AFID = Copy(AStr, 1, 1) then
    begin
      Result := Copy(AStr, 2, Index - 2);
      Exit;
    end;
    AStr := Copy(AStr, Index + 1, MAXWORD);
    Index := Pos(FS, AStr);
  end;
end;

function TVanKFTCDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKFTCDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: string;
  Gubun, CardNo, TempStr, SignData: string;
begin
  Result.Result := False;

  // 전송 데이타를 만든다.
  if AInfo.EyCard then
    Gubun := IfThen(AInfo.Approval, 'C1', 'C2')
  else
  begin
    if AInfo.SignOption = 'Y' then
      Gubun := IfThen(AInfo.Approval, 'A1', 'A5')
    else
      Gubun := IfThen(AInfo.Approval, 'A0', 'A4');
  end;
  if AInfo.CardNo <> '' then
    CardNo := IfThen(AInfo.KeyInput, 'M', ';') + AInfo.CardNo
  else
    CardNo := '';

  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Approval then
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS + 'R' + FS +
                'S' + CurrToStr(AInfo.VatAmt) + FS + // 부가세
                'T' + CurrToStr(AInfo.SvcAmt) + FS + // 봉사료
                'b' + FS + 'h' + FS +
                'j' + FormatFloat('00', AInfo.HalbuMonth) + FS + // 할부개월
                'k' + FS +
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x' + AInfo.TerminalID // 단말기번호
  else
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS +
                'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS + // 원승인일자
                'R' + FS + 'Y' + FS +
                'a' + AInfo.OrgAgreeNo + FS + // 원승인번호
                'b' + FS + 'h' + FS +
                'j' + FormatFloat('00', AInfo.HalbuMonth) + FS + // 할부개월
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x' + AInfo.TerminalID; // 단말기번호

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // 응답 데이타를 만든다.
  TempStr := StringSearch(RecvData, FS, 0);
  // 응답코드
  Result.Code := Copy(TempStr, 16, 3);
  // 거래일시
  Result.AgreeDateTime := '20' + Copy(TempStr, 4, 12);
  // 응답메세지
  Result.Msg := GetStringSearch('g', RecvData) + GetStringSearch('w', RecvData);
  // 승인번호
  Result.AgreeNo := GetStringSearch('a', RecvData);
  // 거래번호
  Result.TransNo := GetStringSearch('h', RecvData);
  // 발급사코드
  Result.BalgupsaCode := GetStringSearch('u', RecvData);
  // 발급사명
  Result.BalgupsaName := GetStringSearch('p', RecvData);
  // 매입사코드
  Result.CompCode := GetStringSearch('t', RecvData);
  // 매입사명
  Result.CompName := GetStringSearch('v', RecvData);
  // 카드번호
  Result.CardNo := GetStringSearch('q', RecvData);
  //Result.CardNo := Copy(Result.CardNo, 1, 6); //카드 앞 Bin 부분만 리턴한다.
  // 가맹점번호
  Result.KamaengNo := GetStringSearch('d', RecvData);
  // 승인금액
  Result.AgreeAmt := StrToIntDef(GetStringSearch('B', RecvData), 0);
  // 할인금액 (응답전문에 없음)
  Result.DCAmt := 0;
  // 서명 데이타
  SignData := GetStringSearch('z', RecvData);
  Result.IsSignOK := Length(SignData) > 0;
  // 성공여부
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: string;
  Gubun, CardNo, TempStr: string;
begin
  Result.Result := False;

  // 전송 데이타를 만든다.
  if AInfo.Person = 2 then
    Gubun := IfThen(AInfo.Approval, 'B7', 'B9')  // 지출증빙
  else
    Gubun := IfThen(AInfo.Approval, 'B6', 'B8'); // 소득공제

  if AInfo.CardNo <> '' then
    CardNo := IfThen(AInfo.KeyInput, 'M', ';') + AInfo.CardNo
  else
    CardNo := '';

  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Approval then
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS + 'R' + FS +
                'S' + CurrToStr(AInfo.VatAmt) + FS + // 부가세
                'T' + CurrToStr(AInfo.SvcAmt) + FS + // 봉사료
                'b' + FS + 'h' + FS + 'j' + FS + 'k' + FS +
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x' + AInfo.TerminalID // 단말기 번호
  else
    SendData := Gubun + FS + // 전문구분
                'B' + CurrToStr(AInfo.SaleAmt) + FS + // 거래금액
                'D' + FS + 'P' + FS +
                'Q' + Copy(AInfo.OrgAgreeDate, 5, 4) + FS + // 원승인일자
                'R' + FS +
                'Y' + IntToStr(AInfo.CancelReason) + FS + // 현금영수증 취소사유
                'a' + AInfo.OrgAgreeNo + FS + // 원승인번호
                'b' + FS + 'h' + FS + 'j' + FS +
                'q' + CardNo + FS + // 신용카드 또는 현금영수증 번호
                'x' + AInfo.TerminalID; // 단말기 번호

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // 응답 데이타를 만든다.
  TempStr := StringSearch(RecvData, FS, 0);
  // 응답코드
  Result.Code := Copy(TempStr, 16, 3);
  // 거래일시
  Result.AgreeDateTime := '20' + Copy(TempStr, 4, 12);
  // 응답메세지
  Result.Msg := GetStringSearch('g', RecvData) + GetStringSearch('w', RecvData);
  // 승인번호
  Result.AgreeNo := GetStringSearch('a', RecvData);
  // 카드번호
  Result.CardNo := GetStringSearch('q', RecvData);
  //Result.CardNo := Copy(Result.CardNo, 1, 6); //카드 앞 Bin 부분만 리턴한다.
  // 성공여부
  Result.Result := Result.Code = '000';
end;

function TVanKFTCDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음';
end;

function TVanKFTCDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData, TempStr: string;
begin
  Result.Result := False;
  // 전송 데이타를 만든다.
  SendData := 'I0' + FS + // 전문구분
              'B' + CurrToStr(AInfo.SaleAmt) + FS + // 수표금액
              'L' + '4' + FS + // 수표종류 (4:자기앞수표 5: 가계수표)
              // 수표번호(8)+은행코드(2)+지점코드(4)+권종코드(2)+발행일자(6)+계좌일련번호(6)
              'N' + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + AInfo.KindCode + AInfo.RegDate + AInfo.AccountNo + FS +
              'h' + '' ; // 일련번호

  if not ExecTcpSendData(SendData, RecvData) then
  begin
    Result.Msg := RecvData;
    Exit;
  end;

  // 응답 데이타를 만든다.
  TempStr := StringSearch(RecvData, FS, 0);
  // 응답코드
  Result.Code := Copy(TempStr, 16, 3);
  // 응답메세지
  Result.Msg := GetStringSearch('g', RecvData);
  // 성공여부
  Result.Result := Result.Code = '000';
end;

//{function TVanKFTCDaemon.CallICReaderVerify(out ARecvData: AnsiString): Boolean;
//var
//  RecvData, TempStr: string;
//begin
//  Result := False;
//  case AWorkGubun of
//    IC_READER_WORK_STATUS :
//      begin
//        if not ExecTcpSendData('R1', RecvData) then
//        begin
//          ARecvData := RecvData;
//          Exit;
//        end;
//        // 응답 데이타를 만든다.
//        TempStr := StringSearch(RecvData, FS, 0);
//        // 성공여부
//        Result := Copy(TempStr, 16, 3) = 'S00';
//        // 응답메세지
//        ARecvData := GetStringSearch('g', RecvData);
//      end;
//  end;
//end;}

function TVanKFTCDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음';
end;

{ TVanKiccDaemon }

constructor TVanKiccDaemon.Create;
begin
  inherited;
  FIndy := TIdHTTP.Create(nil);
end;

destructor TVanKiccDaemon.Destroy;
begin
  FreeAndNil(FIndy);
  inherited;
end;

function TVanKiccDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode, SendData, RecvData: AnsiString;
begin
  if AInfo.Approval then
    TranCode := IfThen(AInfo.EyCard, 'U1', 'D1')
  else
    TranCode := IfThen(AInfo.EyCard, 'U4', 'D4');

  SendData := MakeSendData(TranCode, '', AInfo);

  if ExecHttpSendRecv(SendData, RecvData) then
    Result := MakeRecvData(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKiccDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode, SendData, RecvData: AnsiString;
begin
  if AInfo.Approval then
  begin
    if AInfo.Person = 3 then
      TranCode := 'B3'
    else
      TranCode := 'B1';
  end
  else
  begin
    if AInfo.Person = 3 then
      TranCode := 'B4'
    else
      TranCode := 'B2';
  end;

  SendData := MakeSendData(TranCode, '', AInfo);

  if ExecHttpSendRecv(SendData, RecvData) then
    Result := MakeRecvData(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKiccDaemon.CallCashIC(
  AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKiccDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := MakeSendData('C1', '', AInfo);

  if ExecHttpSendRecv(SendData, RecvData) then
    Result := MakeRecvData(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKiccDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

function TVanKiccDaemon.CallPosDownload(ATerminalID,
  ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKiccDaemon.MakeRecvData(ARecvData: AnsiString): TCardRecvInfoDM;
var
  MainJson: TlkJSONobject;
  Pos1, Pos2: Integer;
  JSonText: string;
begin
  Result.Result := False;
  JSonText := ARecvData;
  // JSON 문자열 앞뒤로 붙은 불필요한 문자열 삭제 jsonp12345678983543344({'SUC':'01','MSG':'not Found VAN Info '}) euc-kr
  Pos1 := Pos('({', JSonText);
  Pos2 := Pos('})', JSonText);
  JSonText := Copy(JSonText, Pos1+1, Pos2-Pos1);
  JSonText := StringReplace(JSonText, '''', '"', [rfReplaceAll]); // 따옴표 변경
  try
    try
      MainJson := TlkJSON.ParseText(JSonText) as TlkJSONobject;
      if MainJson = nil then
      begin
        Result.Msg := 'JSON 파싱 Error';
        Exit;
      end;
      Result.Code := MainJson.Field['SUC'].Value;
      Result.Result := Result.Code = '00';
      if Result.Result then
      begin
        Result.Result        := (MainJson.Field['RS04'].Value = '0000');       // 성공여부
        Result.Code          := VarToStr(MainJson.Field['RS04'].Value);        // 응답코드
        Result.CompCode      := VarToStr(MainJson.Field['RS05'].Value);        // 매입사코드
        Result.AgreeDateTime := '20' + VarToStr(MainJson.Field['RS07'].Value); // 승인일시(yyyymmddhhnnss)
        Result.TransNo       := VarToStr(MainJson.Field['RS08'].Value);        // 거래번호
        Result.AgreeNo       := VarToStr(MainJson.Field['RS09'].Value);        // 승인번호
        Result.BalgupsaCode  := VarToStr(MainJson.Field['RS11'].Value);        // 발급사코드
        Result.BalgupsaName  := VarToStr(MainJson.Field['RS12'].Value);        // 발급사명
        Result.KamaengNo     := VarToStr(MainJson.Field['RS13'].Value);        // 가맹점번호
        Result.CompName      := VarToStr(MainJson.Field['RS14'].Value);        // 매입사명
        Result.Msg           := Trim(VarToStr(MainJson.Field['RS16'].Value) +
                                VarToStr(MainJson.Field['RS17'].Value));       // 응답메세지
        Result.IsSignOK      := VarToStr(MainJson.Field['RS18'].Value) = 'Y';  // 전자서명여부
        Result.CardNo        := VarToStr(MainJson.Field['RQ04'].Value);        // 마스킹된 카드번호
        Result.AgreeAmt      := MainJson.Field['RQ07'].Value;                  // 승인금액
        Result.DCAmt         := 0;                                             // 할인금액
      end
      else
        Result.Msg := VarToStr(MainJson.Field['MSG'].Value);
    except on E: Exception do
      Result.Msg := E.Message;
    end;
  finally
    MainJson.Free;
  end;
end;

function TVanKiccDaemon.MakeSendData(ATranCode, ASignData: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
var
  TransNo: AnsiString;
begin
  TransNo := GetSeqNoKICC;
  // 1. 전문구분
  //    D1 : 승인 D4 : 당일취소/전일취소(반품환불)
  //    B1 : 현금승인(공제) B2 : 현금취소(공제)
  //    B3 : 자진발급 B4 : 자진발급취소
  //    U1 : 은련승인 U4 : 은련당일취소/전일취소(반품환불)
  //    C1 : 수표조회
  Result := ATranCode + '^';
  // 2. 현금영수증 거래용도 [ 현금영수증 : ‘00’: 개인현금 ‘01’: 사업자현금 ]
  if (ATranCode = 'B1') or (ATranCode = 'B2') or (ATranCode = 'B4') or (ATranCode = 'B3') then
    Result := Result + IfThen(AInfo.Person = 2, '01', '00') + '^'
  else
    Result := Result + '^';
  // 3. 금액
  Result := Result + CurrToStr(AInfo.SaleAmt) + '^';
  // 4. 할부
  //    00: 일시불 N : 할부N개월 예) 할부 3개월 : 03
  //    수표조회 : 권종 (10만원: 13, 30만원 : 14, 50만원 : 15, 100만원 : 16, 자기앞수표기타금액 : 19, 당좌수표 : 31, 가계수표 : 42)
  //    현금영수증 취소 시 : 1: 고객취소 2: 오류발급 3: 기타
  if (ATranCode = 'B2') then
    Result := Result + IntToStr(AInfo.CancelReason) + '^'
  else if (ATranCode = 'C1') then
    Result := Result + AInfo.KindCode + '^'
  else if (ATranCode = 'D1') or (ATranCode = 'D4') then
    Result := Result + IntToStr(AInfo.HalbuMonth) + '^'
  else
    Result := Result + '^';
  // 5. 취소 원승인일자  [ YYMMDD ]
  if (ATranCode = 'B2') or (ATranCode = 'B4') or (ATranCode = 'D4') or (ATranCode = 'U4') then
  begin
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    Result := Result + Copy(AInfo.OrgAgreeDate, 3, 6) + '^'
  end
  else if (ATranCode = 'C1') then
    Result := Result + Copy(FormatDateTime('yyyymmdd', Now), 3, 6) + '^'
  else
    Result := Result + '^';
  // 6. 취소 원승인번호  [ 응답전문의 RS09필드 ]
  Result := Result + AInfo.OrgAgreeNo + '^';
  // 7. 상품코드
  Result := Result + '^';
  // 8. 임시판매번호  [ 가맹점에서 사용하는 거래고유번호 ]
  Result := Result + TransNo + '^';
  // 9. 웹전송메세지
  Result := Result + '^';
  // 10. 이지카드 옵션
  //   1.KeyIn 옵션 Y : 사용함 N : 사용안함
  //   2.0원 거래 옵션 Y : 사용함 N : 사용안함
  //   3.Transaction DB 저장 옵션 Y : 사용함 N : 사용안함
  //   4.무서명 버튼 사용 유무 옵션 Y : 사용함 N : 사용안함
  //   5.취소 거래 시 무서명 옵션 Y : 사용함 N : 사용안함
  //   6.승인 거래 시 무서명 옵션 Y : 사용함 N : 사용안함
  //   고정길이 필드이므로 각 필드 값을 다 넣어야함.
  //   ex) Transaction DB 옵션까지 사용 한다면 “NNY” 로 대입
  Result := Result + '^';
  // 11. 단말기번호(TID)
  //    EasyCard 프로그램에서 멀티TID 옵션을 사용 으로 했을 시 : 승인 단말기번호(TID)
  //    EasyCard 프로그램에서 멀티TID 옵션을 사용안함 으로 했을 시: 기본적으로는 넣지 않음
  if (ATranCode = 'C1') then
    Result := Result + '^'
  else
    Result := Result + AInfo.TerminalID + '^';
  // 12. 타임아웃 [ Response Timeout second, 값이 없을 시 Default : 0초   (무인Kiosk버전에서만 사용가능)  ]
  Result :=  Result + '60^';
  // 13. 부가세 [ 문의 필요 ]
  //    A : 자동계산
  //    M + 부가세금액 : 수동입력 ? ex ) M91 부가세 91원
  //    F : 면세
  //    값이 없으면 10% 자동계산
  Result := Result + 'M' + CurrToStr(AInfo.VatAmt) + '^';
  // 14. 추가필드      [ 사용 가맹점만 대입 + DCC 요청 ]
  Result := Result + '^';
  // 15. 수신 핸들값   [ 이지카드 실시간 상태값 수신시 수신 핸들값 대입 ]
  Result := Result + '^';
  // 16. 단말기 구분   [ 사용 가맹점만 대입 ]
  Result := Result + '^';
  // 17. 할인/적립 구분   [ 이하 유인버전에서만 사용가능 ]
  Result := Result + '^';
  // 18. 비밀번호         [ 사용 가맹점만 대입 ]
  Result := Result + '^';
  // 19. 거래확장옵션     [ 사용 가맹점만 대입 ]
  Result := Result + '^';
  // 20. 취소 거래고유번호  [ DSC용 거래고유번호 (RS08) | 수표조회 시 : 수표번호 + 일련번호 ]
  if (ATranCode = 'C1') then
    Result := Result + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + '^'
  else
    Result := Result + '^';
  // 21. 동글 FLAG  [ SSGPAY : BS | 알리페이 : BA | 위쳇페이 : BW ]
  Result := Result + '^';
  // 22. EzGW 바코드번호  [ EzGW 프로그램에서만 사용 B + 바코드번호 ]
  Result := Result + '^';
  // 23. 봉사료  [ 사용 가맹점만 대입   ]
  //     (3번 필드 전체금액에 미포함으로 대입 됨 Ex. 금액:10,000원 봉사료: 1,000원 이면 승인 금액은 11,000원)
  Result := Result + '^';
  // 24. 문자셋  [ EUC-KR / UTF-8 값이 없으면 EasyCard의 설정 값으로 정해짐.    ]
  Result := Result + '^';
  // 25. BMP String
  Result := Result + ASignData + '^';
  // 26. VAN  [ 멀티밴 취소시에만 대입 KICC,SMATRO,KIS,KSNET,KOCES ]
  Result := Result + '^';
  // 27. 카드번호
  //     EzGW : 키인 승인 거래 요청
  //    일반 신용 승인 : @ + 카드번호
  //    하이패스 신용 승인 : @TOKNSKP + 토큰번호
  //    알리페이, 위쳇페이 : B + 알리페이, 위쳇페이 바코드
  Result := Result + '^';
  // 28. 유효기간   [ EzGW : 키인 승인 거래 요청 ]
  Result := Result + '^';
  // 29. 승인방법 구분  [ EzGW : E:이지카드 G:이지게이트 ]
  Result := Result + '^';
  // 30. 화면표시  [  EasyCardK 1.0.0.24 이상부터 지원 ]
  //     화면표시를 하지 않으려면 N 대입 (없으면 기본 값 : Y 로 세팅)
  Result := Result + '^';
  // 31. 보너스 승인번호 [ - EasyCardK 1.0.0.33 이상부터 지원 ]
  //     선불충전-신용 취소 거래시 RS34(보너스 승인번호) 값 대입
  Result := Result + '^';
end;

function TVanKiccDaemon.ExecHttpSendRecv(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
const
  KICC_HOST_URL = 'http://127.0.0.1:8090/?';
var
  Parameters: TStringStream;
  RecvStream: TMemoryStream;
  {$IF RTLVersion > 19.00}
  RbStr: RawByteString;
  {$ELSE}
  RbStr: AnsiString;
  {$IFEND}
begin
  Result := False;
  ASendData := 'callback=jsonp12345678983543344' + '&REQ=' + ASendData;
  Log.Write(ltInfo, ['전송정보', ASendData]);
  Parameters := TStringStream.Create(ASendData);
  RecvStream := TMemoryStream.Create;
  try
    try
      FIndy.Request.Clear;
      FIndy.HandleRedirects     := True;
      FIndy.Request.ContentType := 'application/x-www-form-urlencoded';
      FIndy.Post(KICC_HOST_URL, Parameters, RecvStream);
      RbStr := PAnsiChar(RecvStream.Memory);
      {$IF RTLVersion > 19.00}
//      SetCodePage(RbStr, 65001, False);
      {$ELSE}
      {$IFEND}
      ARecvData := RbStr;
      Result := True;
      Log.Write(ltInfo, ['응답정보', ARecvData]);
    except
      on E: Exception do
      begin
        ARecvData := E.Message;
        Log.Write(ltError, ['처리실패', E.Message]);
      end;
    end;
  finally
    Parameters.Free;
    RecvStream.Free;
  end;
end;

function TVanKiccDaemon.GetSeqNoKICC: AnsiString;
var
  AppPath: string;
  SeqNo: Integer;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  // 일련번호 (10자리, 무조건 전문 보낼 때마다 증가해야 함)
  with TIniFile.Create(AppPath + 'KiccDaemonSeq.ini') do
    try
      SeqNo := ReadInteger('SEQ', FormatDateTime('mmdd', Now), 0) + 1;
      if SeqNo > 999999 then
        SeqNo := 0;
      WriteInteger('SEQ', FormatDateTime('mmdd', Now), SeqNo);
    finally
      Free;
    end;
  Result := FormatDateTime('mmdd', Now) + FormatFloat('000000', SeqNo);
end;

{ TVanKisDaemon }

constructor TVanKisDaemon.Create;
begin
  inherited;
  KisPosAgent := TKisPosAgent.Create(nil);
end;

destructor TVanKisDaemon.Destroy;
begin
  KisPosAgent.Free;
  inherited;
end;

function TVanKisDaemon.ExecOcx(ATranCode: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  KisPosAgent.Init;
  KisPosAgent.inAgentIP        := '127.0.0.1';              // KIS-AGENT IP
  KisPosAgent.inAgentPort      := 1515;                     // KIS-AGENT PORT
  KisPosAgent.inTranCode       := ATranCode;                // 전문구분코드
  if (ATranCode = 'D1') or (ATranCode = 'D2') or (ATranCode = 'CU') or (ATranCode = 'CD') then
    KisPosAgent.inTranGubun    := IfThen(AInfo.KeyInput, 'K', '')  // 전문구분코드 (신용승인)
  else if (ATranCode = 'CC') or (ATranCode = 'CR') then
    KisPosAgent.inTranGubun    := IfThen(AInfo.KeyInput, '', 'C'); // 전문구분코드 (현금영수증)
  KisPosAgent.inReaderType     := 'R';                      // 리더기Type
  if (ATranCode = 'CC') or (ATranCode = 'CR') then
    KisPosAgent.inCashAuthId   := AInfo.CardNo;             // 현금영수증 발급 ID
  if (ATranCode = 'D1') or (ATranCode = 'D2') or (ATranCode = 'CU') or (ATranCode = 'CD') then
    KisPosAgent.inInstallment  := IntToStr(AInfo.HalbuMonth) // 할부개월
  else if (ATranCode = 'CC') or (ATranCode = 'CR') then
    KisPosAgent.inInstallment  := IfThen(AInfo.Person = 2, '01', '00'); // 개인/사업자 구분
  KisPosAgent.inTranAmt      := CurrToStr(AInfo.SaleAmt);   // 결제금액 (수표금액)
  KisPosAgent.inVatAmt         := CurrToStr(AInfo.VatAmt);  // 부가세액
  KisPosAgent.inSvcAmt         := CurrToStr(AInfo.SvcAmt);  // 봉사료
  if not AInfo.Approval then
  begin
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    KisPosAgent.inOrgAuthDate  := Copy(AInfo.OrgAgreeDate, 3, 6); // 원거래일자
    KisPosAgent.inOrgAuthNo    := AInfo.OrgAgreeNo;               // 원승인번호
  end;
  if AInfo.SignOption = 'Y' then                            // 서명처리 여부 ('Y': 서명거래 'N': 서명처리안함 '': 무서명거래)
    KisPosAgent.inSignYN       := 'Y'
  else if AInfo.SignOption = 'N' then
    KisPosAgent.inSignYN       := ''
  else if AInfo.SignOption = 'R' then
    KisPosAgent.inSignYN       := 'N';
  KisPosAgent.inSignFileName   := 'sign.bmp';               // 서명파일명
  KisPosAgent.inCatID          := AInfo.TerminalID;         // 단말기번호
  KisPosAgent.inCheckNumber    := Format('%-14.14s', [AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode]); // 수표번호
  if Length(AInfo.RegDate) = 6 then                         // 수표발행일자
    KisPosAgent.inCheckIssueDate := Copy(AInfo.RegDate, 1, 6)
  else
    KisPosAgent.inCheckIssueDate := Copy(AInfo.RegDate, 3, 6);
  KisPosAgent.inCheckType      := AInfo.KindCode;           // 수표권종코드
  KisPosAgent.inCheckAccountNo := AInfo.AccountNo;          // 수표 계좌일련번호
  KisPosAgent.inOilInfo        := '';                       // 유종정보
  KisPosAgent.inOilYN          := 'N';                      // 유종정보사용여부
  KisPosAgent.inVanKeyYN       := 'N';                      // VanKey사용여부
  KisPosAgent.inVanKey         := '';                       // VanKey
  KisPosAgent.inTicketNumer    := '';                       // 현대M포인트 사용시 Ticket매수
  KisPosAgent.inBarCodeNumber  := '';                       // 앱카드 바코드번호
  KisPosAgent.inSKTGoodsCode   := '';                       // SKT 상품코드

  KisPosAgent.KIS_Approval;
  Log.Write(ltDebug, ['OCX응답', KisPosAgent.outRtn, '응답코드', KisPosAgent.outReplyCode, '메세지', KisPosAgent.outReplyMsg1 + KisPosAgent.outReplyMsg2]);

  Result.Result        := (KisPosAgent.outRtn = 0) and (KisPosAgent.outReplyCode = '0000'); // 성공여부
  Result.Code          := KisPosAgent.outReplyCode;         // 응답코드
  Result.Msg           := KisPosAgent.outReplyMsg1 + KisPosAgent.outReplyMsg2; // 응답메세지
  Result.AgreeNo       := KisPosAgent.outAuthNo;            // 승인번호
  Result.AgreeDateTime := KisPosAgent.outReplyDate + KisPosAgent.outTradeReqTime; // 승인일시(yyyymmddhhnnss)
  Result.TransNo       := KisPosAgent.outTradeNum;          // 거래번호
  Result.BalgupsaCode  := KisPosAgent.outIssuerCode;        // 발급사코드
  Result.BalgupsaName  := KisPosAgent.outIssuerName;        // 발급사명
  Result.CompCode      := KisPosAgent.outAccepterCode;      // 매입사코드
  Result.CompName      := KisPosAgent.outAccepterName;      // 매입사명
  Result.KamaengNo     := KisPosAgent.outMerchantRegNo;     // 가맹점번호
  Result.AgreeAmt      := Trunc(AInfo.SaleAmt);             // 승인금액
  Result.DCAmt         := 0;                                // 할인금액
  Result.CardNo        := KisPosAgent.outCardNo;            // 마스킹된 카드번호
  Result.IsSignOK      := Trim(KisPosAgent.outTranNo) = 'SN';     // 전자서명여부
end;

function TVanKisDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKisDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode: AnsiString;
begin
  if AInfo.Approval then
    TranCode := IfThen(AInfo.EyCard, 'CU', 'D1')
  else
    TranCode := IfThen(AInfo.EyCard, 'CD', 'D2');
  Result := ExecOcx(TranCode, AInfo);
end;

function TVanKisDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TranCode: AnsiString;
begin
  if AInfo.Approval then
    TranCode := 'CC'
  else
    TranCode := 'CR';
  Result := ExecOcx(TranCode, AInfo);
end;

function TVanKisDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKisDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result := ExecOcx('C1', AInfo);
end;

function TVanKisDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  KisPosAgentForm := TKisPosAgentForm.Create(Application);
  try
    if KisPosAgentForm.ShowModal = mrOK then
    begin
      ARecvData := KisPosAgentForm.RecvData;
      Log.Write(ltInfo, ['핀패드응답', ARecvData]);
      Result := True;
    end;
  finally
    KisPosAgentForm.Free;
  end;
end;

{ TVanFDIKDaemon }

constructor TVanFDIKDaemon.Create;
begin
  inherited;
  FDaemonRunCheck := False;
end;

destructor TVanFDIKDaemon.Destroy;
var
  FDIK_Daemon_Destroy: TFDIK_Daemon_Destroy;
begin
  Log.Write(ltInfo, ['Daemon Destroy!!! DLLHandle', FDLLHandle]);
  if FDLLHandle <> 0 then
  begin
    @FDIK_Daemon_Destroy := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Destroy');
    if Assigned(@FDIK_Daemon_Destroy) then
    begin
      if FDIK_Daemon_Destroy() = 0 then
        Log.Write(ltInfo, ['WIN4POS 구동 종료함']);
    end
    else
      Log.Write(ltError, ['FDK_WIN4POS_Destroy 함수 없음']);

    FreeLibrary(FDLLHandle);
  end;
  inherited;
end;

function TVanFDIKDaemon.CheckDaemonRun(out AErrorMsg: AnsiString): Boolean;
var
  FDIK_Daemon_Create: TFDIK_Daemon_Create;
  FDIK_Daemon_Status: TFDIK_Daemon_Status;
  Ret: Integer;
begin
  Result := False;
  Log.Write(ltInfo, ['WIN4POS 실행 Check', FDaemonRunCheck]);
  if not FDaemonRunCheck then
  begin
    FDllHandle := LoadLibrary(WIN4POS_DLL);
    @FDIK_Daemon_Create := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Create');
    if not Assigned(@FDIK_Daemon_Create) then
    begin
      AErrorMsg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
      Log.Write(ltError, ['WIN4POS Create 호출 실패', AErrorMsg]);
      Exit;
    end;

    Ret := FDIK_Daemon_Create('127.0.0.1', '2003');
    if Ret <> 0 then
    begin
      AErrorMsg := 'WIN4POS 프로그램을 실행하지 못했습니다.';
      Log.Write(ltError, ['WIN4POS Create 응답값', Ret, '메세지', AErrorMsg]);
      Exit;
    end;
  end;

  @FDIK_Daemon_Status := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Status');
  if not Assigned(@FDIK_Daemon_Status) then
  begin
    AErrorMsg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Log.Write(ltError, ['WIN4POS Status 호출 실패', AErrorMsg]);
    Exit;
  end;

  Ret := FDIK_Daemon_Status();
  case Ret of
     0 :
       begin
         AErrorMsg := 'WIN4POS 정상 구동함';
         FDaemonRunCheck := True;
         Result := True;
       end;
    -1 : AErrorMsg := 'Create 실행 되지 않거나 커넥션 되지 않음';
    -2 : AErrorMsg := 'INIT 또는 EXECUTE 상태';
  else
    AErrorMsg := '기타 오류';
  end;
  Log.Write(ltInfo, ['WIN4POS Status 응답값', Ret, '메세지', AErrorMsg]);
end;

function TVanFDIKDaemon.DoCallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Input: TFDIK_Daemon_Input;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
  @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
  @FDIK_Daemon_Input := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Input');
  @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
  @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
  @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
  if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
     or not Assigned(@FDIK_Daemon_Input) or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term)
     or not Assigned(@FDIK_Daemon_Execute) then
  begin
    Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  try
    if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
    if FDIK_Daemon_Init(Buff, 'PAY', 'FDK') <> 0 then Exit;
    if FDIK_Daemon_Input('거래구분', PAnsiChar(StrToAnsiStr(IfThen(AInfo.EyCard, 'JCB', 'CRD')))) <> 0 then Exit;
    if FDIK_Daemon_Input('사업자번호', PAnsiChar(StrToAnsiStr(Format('%-10.10s', [AInfo.BizNo])))) <> 0 then Exit;
    if FDIK_Daemon_Input('제품일련번호', PAnsiChar(StrToAnsiStr(Trim(Format('%-10.10s', [Ainfo.TerminalID]))))) <> 0 then Exit;
    if FDIK_Daemon_Input('요청금액', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SaleAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('봉사료', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SvcAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('세금', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.VatAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('과세대상금액', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', (AInfo.SaleAmt - AInfo.FreeAmt))))) <> 0 then Exit;
    if FDIK_Daemon_Input('비과세대상금액', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', AInfo.FreeAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('할부', PAnsiChar(StrToAnsiStr(FormatFloat('00', AInfo.HalbuMonth)))) <> 0 then Exit;
    if AInfo.Approval then
    begin
      if FDIK_Daemon_Input('취소구분', ' ') <> 0 then Exit;
    end
    else
    begin
      if FDIK_Daemon_Input('취소구분', 'Y') <> 0 then Exit;
      if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
      if FDIK_Daemon_Input('원거래일자', PAnsiChar(StrToAnsiStr(Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])))) <> 0 then Exit;
      if FDIK_Daemon_Input('원승인번호', PAnsiChar(StrToAnsiStr(Format('%-12.12s', [AInfo.OrgAgreeNo])))) <> 0 then Exit;
    end;
    if AInfo.SignOption = 'N' then
    begin
      if FDIK_Daemon_Input('서명사용유무', PAnsiChar(StrToAnsiStr('N'))) <> 0 then Exit;
    end;
    // 승인 호출
    if FDIK_Daemon_Execute() <> 0 then
    begin
      FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
      Result.MSG := Buff;
      Exit;
    end;
    FDIK_Daemon_Output('응답코드', Buff, 1024);
    Result.Code := Buff;
    if Result.Code = '0000' then
      Result.Result := True;
    FDIK_Daemon_Output('승인번호', Buff, 1024);
    Result.AgreeNo := Buff;
//    FDIK_Daemon_Output('승인일자', Buff, 1024);
//    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('거래시간', Buff, 1024);
    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('가맹점번호', Buff, 1024);
    Result.KamaengNo := Buff;
    FDIK_Daemon_Output('응답메시지1', Buff, 1024);
    Result.Msg := Buff;
    FDIK_Daemon_Output('응답메시지2', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
    FDIK_Daemon_Output('카드명', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
    FDIK_Daemon_Output('발급사코드', Buff, 1024);
    Result.BalgupsaCode := Buff;
    FDIK_Daemon_Output('발급사명', Buff, 1024);
    Result.BalgupsaName := Buff;
    FDIK_Daemon_Output('매입사코드', Buff, 1024);
    Result.CompCode := Buff;
    FDIK_Daemon_Output('매입사명', Buff, 1024);
    Result.CompName := Buff;
    FDIK_Daemon_Output('마스킹카드번호', Buff, 1024);
    Result.CardNo := Buff;
    FDIK_Daemon_Output('서명경로', Buff, 1024);
    Result.IsSignOK := Buff <> '';
    FDIK_Daemon_Output('거래금액', Buff, 1024);
    Result.AgreeAmt := StrToIntDef(Buff, Trunc(AInfo.SaleAmt));
    Result.DCAmt := 0;
  finally
    FDIK_Daemon_Term();
  end;
end;

function TVanFDIKDaemon.DoCallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Input: TFDIK_Daemon_Input;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
  @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
  @FDIK_Daemon_Input := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Input');
  @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
  @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
  @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
  if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
     or not Assigned(@FDIK_Daemon_Input) or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term)
     or not Assigned(@FDIK_Daemon_Execute) then
  begin
    Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  try
    if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
    if FDIK_Daemon_Init(Buff, 'PAY', 'FDK') <> 0 then Exit;
    if FDIK_Daemon_Input('거래구분', 'CSH') <> 0 then Exit;
    if FDIK_Daemon_Input('사업자번호', PAnsiChar(StrToAnsiStr(Format('%-10.10s',[AInfo.BizNo])))) <> 0 then Exit;
    if FDIK_Daemon_Input('제품일련번호', PAnsiChar(StrToAnsiStr(Trim(Format('%-10.10s',[AInfo.TerminalID]))))) <> 0 then Exit;
    if FDIK_Daemon_Input('요청금액', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SaleAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('봉사료', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.SvcAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('세금', PAnsiChar(StrToAnsiStr(FormatFloat('0000000000', AInfo.VatAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('과세대상금액', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', (AInfo.SaleAmt - AInfo.FreeAmt))))) <> 0 then Exit;
    if FDIK_Daemon_Input('비과세대상금액', PAnsiChar(StrToAnsiStr(FormatFloat('00000000', AInfo.FreeAmt)))) <> 0 then Exit;
    if FDIK_Daemon_Input('사용구분', PAnsiChar(StrToAnsiStr(IfThen(AInfo.Person = 2, '01', '00')))) <> 0 then Exit;
    if FDIK_Daemon_Input('식별번호', PAnsiChar(StrToAnsiStr(Format('%-13.13s', [AInfo.CardNo])))) <> 0 then Exit;
    if AInfo.Approval then
    begin
      if FDIK_Daemon_Input('취소구분', ' ') <> 0 then Exit;
    end
    else
    begin
      if FDIK_Daemon_Input('취소구분', 'Y') <> 0 then Exit;
      if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
      if FDIK_Daemon_Input('원거래일자', PAnsiChar(StrToAnsiStr(Format('%-6.6s',[Copy(AInfo.OrgAgreeDate, 3, 6)])))) <> 0 then Exit;
      if FDIK_Daemon_Input('원승인번호', PAnsiChar(StrToAnsiStr(Format('%-12.12s', [AInfo.OrgAgreeNo])))) <> 0 then Exit;
    end;
    if FDIK_Daemon_Execute() <> 0 then
    begin
      FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
      Result.MSG := Buff;
      Exit;
    end;
    FDIK_Daemon_Output('응답코드', Buff, 1024);
    Result.Code := Buff;
    if Result.Code = '0000' then
      Result.Result := True;
    FDIK_Daemon_Output('승인번호', Buff, 1024);
    Result.AgreeNo:= Buff;
//    FDIK_Daemon_Output('승인일자', Buff, 1024);
//    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('거래시간', Buff, 1024);
    Result.AgreeDateTime := '20' + Buff;
    FDIK_Daemon_Output('응답메시지1', Buff, 1024);
    Result.Msg := Buff;
    FDIK_Daemon_Output('응답메시지2', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
    FDIK_Daemon_Output('마스킹카드번호', Buff, 1024);
    Result.CardNo := Buff;
  finally
    FDIK_Daemon_Term();
  end;
end;

function TVanFDIKDaemon.DoCallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
  @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
  @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
  @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
  @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
  if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
     or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term) or not Assigned(@FDIK_Daemon_Execute) then
  begin
    Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  try
    if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
    if FDIK_Daemon_Init(Buff, 'CHK', 'FDK') <> 0 then Exit;
    if FDIK_Daemon_Execute() <> 0 then
    begin
      FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
      Result.MSG := Buff;
      Exit;
    end;
    if (FDIK_Daemon_Output('응답코드', Buff, 1024) = 0) then
      Result.Code := Buff;
    if Result.Code = '0000' then
      Result.Result := True;
    FDIK_Daemon_Output('응답일시', Buff, 1024);
    Result.AgreeDateTime := Buff;
    FDIK_Daemon_Output('응답메시지1', Buff, 1024);
    Result.Msg := Buff;
    FDIK_Daemon_Output('응답메시지2', Buff, 1024);
    Result.Msg := Result.Msg + Buff;
  finally
    FDIK_Daemon_Term();
  end;
end;

function TVanFDIKDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  FDIK_Daemon_MKTranId: TFDIK_Daemon_MKTranId;
  FDIK_Daemon_Init: TFDIK_Daemon_Init;
  FDIK_Daemon_Input: TFDIK_Daemon_Input;
  FDIK_Daemon_Execute: TFDIK_Daemon_Execute;
  FDIK_Daemon_Output: TFDIK_Daemon_Output;
  FDIK_Daemon_Term: TFDIK_Daemon_Term;
  Buff: array[0..1023] of AnsiChar;
begin
  Result.Result := False;
  if CheckDaemonRun(Result.Msg) then
  begin
    @FDIK_Daemon_MKTranId := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_MkTranId');
    @FDIK_Daemon_Init := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Init');
    @FDIK_Daemon_Input := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Input');
    @FDIK_Daemon_Output := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Output');
    @FDIK_Daemon_Term := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Term');
    @FDIK_Daemon_Execute := GetProcAddress(FDLLHandle, 'FDK_WIN4POS_Execute');
    if not Assigned(@FDIK_Daemon_MKTranId) or not Assigned(@FDIK_Daemon_Init)
       or not Assigned(@FDIK_Daemon_Input) or not Assigned(@FDIK_Daemon_Output) or not Assigned(@FDIK_Daemon_Term)
       or not Assigned(@FDIK_Daemon_Execute) then
    begin
      Result.Msg := WIN4POS_DLL + MSG_ERR_DLL_LOAD;
      Exit;
    end;
    try
      if FDIK_Daemon_MKTranId(Buff, 1024) <> 0 then Exit;
      if FDIK_Daemon_Init(Buff, 'MAIN', 'FDK') <> 0 then Exit;

      if FDIK_Daemon_Input('화면구분', 'PDN') <> 0 then Exit;
      if FDIK_Daemon_Input('사업자번호', PAnsiChar(StrToAnsiStr(Format('%-10.10s',[ABizNo])))) <> 0 then Exit;
      if FDIK_Daemon_Input('제품일련번호', PAnsiChar(StrToAnsiStr(Trim(Format('%-10.10s',[ATerminalID]))))) <> 0 then Exit;
      if FDIK_Daemon_Execute() <> 0 then
      begin
        FDIK_Daemon_Output('MSG_RET_STR', Buff, 1024);
        Result.MSG := Buff;
        Exit;
      end;
      if (FDIK_Daemon_Output('응답코드', Buff, 1024) = 0) then
        Result.Code := Buff;
      if Result.Code = '0000' then
        Result.Result := True;
      FDIK_Daemon_Output('응답일시', Buff, 1024);
      Result.AgreeDateTime := Buff;
      FDIK_Daemon_Output('응답메시지1', Buff, 1024);
      Result.Msg := Buff;
      FDIK_Daemon_Output('응답메시지2', Buff, 1024);
      Result.Msg := Result.Msg + Buff;
    finally
      FDIK_Daemon_Term();
    end;
  end;
end;

function TVanFDIKDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  if CheckDaemonRun(Result.Msg) then
    Result := DoCallCard(AInfo)
  else
    Result.Result := False;
end;

function TVanFDIKDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  if CheckDaemonRun(Result.Msg) then
    Result := DoCallCash(AInfo)
  else
    Result.Result := False;
end;

function TVanFDIKDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음';
end;

function TVanFDIKDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  if CheckDaemonRun(Result.Msg) then
    Result := DoCallCheck(AInfo)
  else
    Result.Result := False;
end;

function TVanFDIKDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음';
end;

{ TVanKocesDaemon }

constructor TVanKocesDaemon.Create;
begin
  inherited;
  if FileExists(filKOCESIC_DLL_Path + filKOCESIC_DLL) then
    FDLLHandle := LoadLibrary(filKOCESIC_DLL_Path + filKOCESIC_DLL)
  else
    FDLLHandle := LoadLibrary(filKOCESIC_DLL);
end;

destructor TVanKocesDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKocesDaemon.ExecDownLoadRequest(ATerminalID, ASerial, ABizNo: AnsiString): TCardRecvInfoDM;
type
  TDownLoadRequest = function(out pResAppr: TDownResAppr; pTermID, pMchData, pSftVer, pSerial, pBsnNo: AnsiString): Integer; stdcall;
var
  Exec: TDownLoadRequest;
  RecvData: TDownResAppr;
  Index: Integer;
begin
  Result.Result := False;
  @Exec := GetProcAddress(FDLLHandle, 'DownLoadRequest');
  if not Assigned(@Exec) then
  begin
    Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  // 승인 호출
  Index := Exec(RecvData,                           // 응답전문
                Format('%-10.10s', [ATerminalID]),  // 단말기번호
                Format('%-20.20s', [MSG_SOLBIPOS]), // 가맹점사용 영역
                Format('%-5.5s', [LeftStr(ATerminalID, 2) + '201']), // 단말기 SW 버전
                Format('%-20.20s', [ASerial]),      // 시리얼 번호
                Format('%-10.10s', [ABizNo]));      // 사업자 번호
  case Index of
    0 :
      begin
        // 에러코드
        Result.Code := RecvData.Header.AnsCode;
        // 성공여부
        Result.Result := Result.Code = '0000';
        // 응답메세지
        Result.Msg := RecvData.Message;
      end;
   -1 : Result.Msg := '승인요구 에러';
   -2 : Result.Msg := '승인요구 Timeout';
   -3 : Result.Msg := 'KocesICPos 미실행';
  else
    Result.Msg := '알 수 없는 에러입니다.';
  end;
  Log.Write(ltInfo, ['가맹점다운로드', Result.Result, '코드', Result.Code, '메세지', Result.Msg, '단말기번호', ATerminalID, '시리얼', ASerial, '사업자번호', ABizNo]);
end;

function TVanKocesDaemon.ExecICRequest(ATrdType, AKeyYN: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
type
  TKOCES_ICRequest = function(out pAuthResAppr: TPosICResAppr;
                              pTrdType, pAuData, pMonth, pTrdAmt, pSvcAmt, pTaxAmt, pTaxFreeAmt, pAuNo, pAuDate, pKeyYn, pInsYn,
                              pCashNum, pCancelReason, pPtSvrCd, pPtInsYn, pPtCardCd: AnsiString): Integer; stdcall;
var
  Exec: TKOCES_ICRequest;
  OrgAgreeNoData, OrgSaleDateData: AnsiString;
  RecvData: TPosICResAppr;
  Index: Integer;
begin
  Result.Result := False;
  @Exec := GetProcAddress(FDLLHandle, 'KocesICRequest');
  if not Assigned(@Exec) then
  begin
    Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  if AInfo.Approval then
  begin
    OrgAgreeNoData  := '            ';
    OrgSaleDateData := '        ';
  end
  else
  begin
    OrgAgreeNoData := Format('%-12.12s', [AInfo.OrgAgreeNo]);
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    OrgSaleDateData := IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yyyymmdd', Now), AInfo.OrgAgreeDate);
  end;
  // 승인 호출
  Index := Exec(RecvData,                            // 응답전문
                ATrdType,                            // 업무구분(2자리, 신용승인:F1 신용취소:F2 은련승인:C5 은련취소:C6 현금승인:H3 현금취소:H4)
                Format('%-20.20s', [MSG_SOLBIPOS]),  // 가맹점사용 영역(20자리)
                FormatFloat('00', AInfo.HalbuMonth), // 할부기간(2자리)
                FormatFloat('000000000000', IfThen(AInfo.Approval, AInfo.SaleAmt - AInfo.SvcAmt - AInfo.VatAmt, AInfo.SaleAmt)), // 판매금액 (12자리) (승인 시에는 봉사료, 세금, 면세 제외 취소 시에는 포함)
                FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.SvcAmt, 0)),  // 봉사료 (9자리) (취소시에는 0원)
                FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.VatAmt, 0)),  // 부가세 (9자리) (취소시에는 0원)
                FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.FreeAmt, 0)), // 비과세 (9자리) (취소시에는 0원)
                OrgAgreeNoData,                      // 원승인번호 (12자리)
                OrgSaleDateData,                     // 원승인일자 (8자리)  YYYYMMDD
                AKeyYN,                              // Swipe구분 (I:신용승인 S:현금영수증시 카드, K:휴대폰번호)
                FormatFloat('0', AInfo.Person),      // 현금영수증 구분 (1:개인 2:법인 3:자진발급 4:원천징수)
                Format('%-13.13s', [AInfo.CardNo]),  // 고객 식별번호 (13자리)
                IfThen(AInfo.Approval, ' ', FormatFloat('0', AInfo.CancelReason)), // 취소사유 (1:거래취소 2:오류발급, 3:기타)
                '  ',                                // 서비스구분 (01:적립 02:적립취소 03:사용 04:사용취소 05:조회 11:포인트 할인요청 12:포인트 할인요청 취소))
                '  ',                                // 결제구분 (01:현금, 02:신용) (단 01.현금거래중에서 포인트 단독일 경우에만 해당
                '  ');                               // 포인트코드 (01:캐쉬백 07:앰플러스 16:코엑스)
  case Index of
    0 :
      begin
        // 응답코드
        Result.Code := RecvData.Header.AnsCode;
        // 응답메세지
        Result.Msg := RecvData.Message;
        // 성공여부
        Result.Result := Result.Code = '0000';
        if Result.Result then
        begin
          // 승인번호
          Result.AgreeNo := RecvData.AuNo;
          // 승인일시
          Result.AgreeDateTime := RecvData.TradeDate;
          // 거래번호
          Result.TransNo := RecvData.TradeNo;
          // 발급사이름
          Result.BalgupsaCode := RecvData.OrdCd;
          Result.BalgupsaName := RecvData.OrdNm;
          // 매입사이름
          Result.CompCode := RecvData.InpCd;
          Result.CompName := RecvData.InpNm;
          // 가맹점번호
          Result.KamaengNo := RecvData.MchNo;
          // 승인금액
          Result.AgreeAmt := Trunc(AInfo.SaleAmt);
          // 할인금액
          Result.DCAmt := 0;
          // 카드번호
          Result.CardNo := RecvData.CardNo;
          // 정상 서명 여부
          Result.IsSignOK := True;
        end;
      end;
    -1 : Result.Msg := '승인요구 에러';
    -2 : Result.Msg := '승인요구 Timeout';
    -3 : Result.Msg := 'KocesICPos 미실행';
  else
    Result.Msg := '알 수 없는 에러입니다.';
  end;
  Log.Write(ltInfo, ['승인거래', Result.Result, '코드', Result.Code, '승인번호', Result.AgreeNo, '카드번호', Result.CardNo, '메세지', Result.Msg]);
end;

function TVanKocesDaemon.ExecAppCardRequest(ATrdType: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
type
  TKOCES_AppCardRequest = function(out pAuthResAppr: TPosICResAppr; pTrdType, pAuData,
                                   pMonth, pTrdAmt, pSvcAmt, pTaxAmt, pTaxFreeAmt,
                                   pAuNo, pAuDate, pPtCardCd: AnsiString): Integer; stdcall;
var
  Exec: TKOCES_AppCardRequest;
  RecvData: TPosICResAppr;
  OrgAgreeNoData, OrgSaleDateData: AnsiString;
  Index: Integer;
begin
  try
    Result.Result := False;
    @Exec := GetProcAddress(FDLLHandle, 'AppCardRequest');
    if not Assigned(@Exec) then
    begin
      Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
      Exit;
    end;
    if AInfo.Approval then
    begin
      OrgAgreeNoData  := '            ';
      OrgSaleDateData := '        ';
    end
    else
    begin
      OrgAgreeNoData := Format('%-12.12s', [AInfo.OrgAgreeNo]);
      if Length(AInfo.OrgAgreeDate) = 6 then
        AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;

      OrgSaleDateData := IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yyyymmdd', Now), AInfo.OrgAgreeDate);
    end;
    // 승인 호출
    Index := Exec(RecvData,                            // 응답전문
                  ATrdType,                            // 업무구분(승인: A1, 취소: A2)
                  Format('%-20.20s', [MSG_SOLBIPOS]),  // 가맹점사용 영역(20자리)
                  FormatFloat('00', AInfo.HalbuMonth), // 할부기간(2자리)
                  // 판매금액 (12자리) (승인 시에는 봉사료, 세금, 면세 제외 취소 시에는 포함)
                  FormatFloat('000000000000', IfThen(AInfo.Approval,
                                                     AInfo.SaleAmt - AInfo.SvcAmt - AInfo.VatAmt,
                                                     AInfo.SaleAmt)),
                  FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.SvcAmt, 0)),  // 봉사료 (9자리) (취소시에는 0원)
                  FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.VatAmt, 0)),  // 부가세 (9자리) (취소시에는 0원)
                  FormatFloat('000000000', IfThen(AInfo.Approval, AInfo.FreeAmt, 0)), // 비과세 (9자리) (취소시에는 0원)
                  OrgAgreeNoData,                      // 원승인번호 (12자리)
                  OrgSaleDateData,                     // 원승인일자 (8자리)  YYYYMMDD
                  Format('%-30.30s', [AInfo.CardNo])); // 앱카드 바코드 번호
    case Index of
      0 :
        begin
          // 응답코드
          Result.Code := RecvData.Header.AnsCode;
          // 응답메세지
          Result.Msg := RecvData.Message;
          // 성공여부
          Result.Result := Result.Code = '0000';
          if Result.Result then
          begin
            // 승인번호
            Result.AgreeNo := RecvData.AuNo;
            // 승인일시
            Result.AgreeDateTime := RecvData.TradeDate;
            // 거래번호
            Result.TransNo := RecvData.TradeNo;
            // 발급사이름
            Result.BalgupsaCode := RecvData.OrdCd;
            Result.BalgupsaName := RecvData.OrdNm;
            // 매입사이름
            Result.CompCode := RecvData.InpCd;
            Result.CompName := RecvData.InpNm;
            // 가맹점번호
            Result.KamaengNo := RecvData.MchNo;
            // 승인금액
            Result.AgreeAmt := Trunc(AInfo.SaleAmt);
            // 할인금액
            Result.DCAmt := 0;
            // 카드번호
            Result.CardNo := RecvData.CardNo;
            // 정상 서명 여부
            Result.IsSignOK := True;
          end;
        end;
      -1 : Result.Msg := '승인요구 에러';
      -2 : Result.Msg := '승인요구 Timeout';
      -3 : Result.Msg := 'KocesICPos 미실행';
    else
      Result.Msg := '알 수 없는 에러입니다.';
  end;
    Log.Write(ltInfo, ['승인거래', Result.Result, '코드', Result.Code, '승인번호', Result.AgreeNo, '카드번호', Result.CardNo, '메세지', Result.Msg]);
  finally

  end;
end;

function TVanKocesDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKocesDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TrdType: AnsiString;
begin
  // 다중사업자 결제인 경우
  if AInfo.Reserved1 <> '' then
  begin
    Result := ExecDownLoadRequest(AInfo.TerminalID, AInfo.Reserved1, AInfo.BizNo);
    if not Result.Result then
      Exit;
  end;

  if AInfo.TrsType = 'A' then
  begin
    TrdType := IfThen(AInfo.Approval, 'A1', 'A2');
    Result := ExecAppCardRequest(TrdType, AInfo);
  end
  else
  begin
    if AInfo.Approval then
      TrdType := IfThen(AInfo.EyCard, 'C5', 'F1')
    else
      TrdType := IfThen(AInfo.EyCard, 'C6', 'F2');
    Result := ExecICRequest(TrdType, 'I', AInfo);
  end;
end;

function TVanKocesDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TrdType: AnsiString;
begin
  // 다중사업자 결제인 경우
  if AInfo.Reserved1 <> '' then
  begin
    Result := ExecDownLoadRequest(AInfo.TerminalID, AInfo.Reserved1, AInfo.BizNo);
    if not Result.Result then
      Exit;
  end;

  TrdType := IfThen(AInfo.Approval, 'H3', 'H4');
  Result := ExecICRequest(TrdType, IfThen(AInfo.KeyInput, 'K', 'S'), AInfo);
end;

function TVanKocesDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKocesDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
type
  TKOCES_ICBillRequest = function(out pBillAppr: TPGFICBillAppr;
                                  pMchData, pBillType, pBillNo, pBankCd, pBillCd, pBillAmt, pDraftDate, pAccountNo: AnsiString): Integer; stdcall;
var
  Exec: TKOCES_ICBillRequest;
  RecvData: TPGFICBillAppr;
  Index: Integer;
begin
  Result.Result := False;
  @Exec := GetProcAddress(FDLLHandle, 'BillRequest');
  if not Assigned(@Exec) then
  begin
    Result.Msg := filKOCESIC_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;
  // 승인 호출
  Index := Exec(RecvData,
                Format('%-20.20s', [MSG_SOLBIPOS]),                    // 가맹점사용 영역 (20자리)
                '4',                                                   // 수표구분 (4-자기앞, 5-가계수표)
                LeftStr(AInfo.CheckNo, 8),                             // 수표번호 (8자리)
                Format('%-6.6s', [AInfo.BankCode + AInfo.BranchCode]), // 발행은행 (6자리)
                AInfo.KindCode,                                        // 권종
                FormatFloat('00000000', AInfo.SaleAmt),                // 수표금액 (8자리)
                Format('%-6.6s', [AInfo.RegDate]),                     // 발행일자
                Format('%-14.14s', [AInfo.AccountNo]));                // 계좌일련번호
  case Index of
    0 :
      begin
        // 에러코드
        Result.Code := RecvData.Header.AnsCode;
        // 성공여부
        Result.Result := Result.Code = '0000';
        // 응답메세지
        Result.Msg := RecvData.Message;
      end;
   -1 : Result.Msg := '승인요구 에러';
   -2 : Result.Msg := '승인요구 Timeout';
   -3 : Result.Msg := 'KocesICPos 미실행';
  else
    Result.Msg := '알 수 없는 에러입니다.';
  end;
  Log.Write(ltInfo, ['수표조회', Result.Result, '코드', Result.Code, '메세지', Result.Msg]);
end;

function TVanKocesDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

{ TVanKsnetDaemon }

constructor TVanKsnetDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(KSNET_DAEMON_DLL);
end;

destructor TVanKsnetDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKsnetDaemon.DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TKSCATApproval = function(AResponseTelegram: PAnsiChar; AIP: PAnsiChar; APort: Integer; ARequestTelegram: PAnsiChar; ARequestTelegramLength: Integer; AOption: Integer): Integer; stdcall;
var
  Exec: TKSCATApproval;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'KSCATApproval');
  if not Assigned(@Exec) then
  begin
    ARecvData := KSNET_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Result := Exec(@ARecvData[1], '127.0.0.1', 27015, PAnsiChar(ASendData), Length(ASendData), 0) > 0;
  Log.Write(ltDebug, ['DaemonDLL호출', Result, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanKsnetDaemon.MakeSendDataCard(ATransGubun: AnsiString; AInfo: TCardSendInfoDM): AnsiString;
var
  Gubun, Track2, Sign: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if ATransGubun = 'IC' then  // 신용승인
    Gubun := FormatFloat('00', AInfo.HalbuMonth)
  else if ATransGubun = 'HK' then // 현금승인
    Gubun := IfThen(AInfo.Approval, '0', FormatFloat('0', AInfo.CancelReason)) + IfThen(AInfo.Person = 2, '1', '0')
  else
    Gubun := Space(2);

  if ATransGubun = 'CH' then // 수표조회
  begin
    // 트랙2 발행일자(6) + 수표번호(8) + 판매은행(2) + 판매지점(4) + 계좌일련번호(6) + 권종코드(2)
    if Length(AInfo.RegDate) = 6 then AInfo.RegDate := '20' + AInfo.RegDate;
    Track2 := Copy(AInfo.RegDate, 3, 6) + Format('%-8.8s', [AInfo.CheckNo]) + Format('%-2.2s', [AInfo.BankCode]) +
                 Format('%-4.4s', [AInfo.BranchCode]) + Format('%-6.6s', [AInfo.AccountNo]) + Format('%-2.2s', [AInfo.KindCode]);
    Track2 := Format('%-37.37s', [Track2]);
  end
  else
    Track2 := Space(37);

  // 서명유무
  if AInfo.SignOption = 'N' then
    Sign := 'X'
  else if AInfo.SignOption = 'R' then
    Sign := 'P'
  else if AInfo.SignOption = 'T' then
    Sign := 'T'
  else
    Sign := 'F';

  Result := STX +                                         // STX
            Format('%-2.2s', [ATransGubun]) +             // 거래구분
            '01' +                                        // 업무구분
            IfThen(AInfo.Approval, '0200', '0420') +      // 전문구분
            'N' +                                         // 거래형태
            Format('%-10.10s', [AInfo.TerminalID]) +      // 단말기번호
            KSNET_SOLBIPOS +                              // 업체정보
            FormatFloat('000000000000', GetSeqNo) +       // 거래일련번호
            IfThen(AInfo.KeyInput, 'K', ' ') +            // POS Entry Mode
            Space(20) +                                   // 거래고유번호(KSNET TR)
            Space(20) +                                   // 암호화 하지 않은 카드번호
            ' ' +                                         // 암호화 여부 (9: 암호화하지 않음)
            '################' +                          // SW 모델 번호
            '################' +                          // Reader 모델번호
            Space(40) +                                   // 암호화 정보
            Track2 +                                      // Track II
            FS +                                          // FS (0x1c)
            Gubun +                                       // 할부개월수 or 거래자구분
            FormatFloat('000000000000', AInfo.SaleAmt) +  // 총금액
            FormatFloat('000000000000', AInfo.SvcAmt) +   // 봉사료
            FormatFloat('000000000000', AInfo.VatAmt) +   // 세금(부가세)
            FormatFloat('000000000000', AInfo.SaleAmt - AInfo.VatAmt - AInfo.FreeAmt) + // 공급금액
            FormatFloat('000000000000', AInfo.FreeAmt) +  // 면세금액
            'AA' +                                        // 비밀번호에 대한 Working Key Index
            '0000000000000000' +                          // 비밀번호
            IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])) +            // 원거래승인번호
            IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])) + // 원거래승인일자
            Space(13) +                                   // 사용자정보
            Space(2) +                                    // 가맹점ID
            Space(30) +                                   // 가맹점사용필드
            Space(4) +                                    // Reserved
            Space(20) +                                   // KSNET_Reserved
            'N' +                                         // 동글구분
            Space(3) +                                    // 매체구분,이통사구분,신용카드종류
            Space(30) +                                   // Filler
            Space(60) +                                   // DCC 환율 조회 Data
            Sign +                                        // 서명유무
            ETX + CR;                                     // ETX + CR
  Result := FormatFloat('0000', Length(Result)) + Result;
end;

function TVanKsnetDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // 성공여부
  if Trim(Copy(ARecvData, 41, 1)) = 'O' then
    Result.Result := True
  else
    Result.Result := False;
  // 에러코드
  Result.Code := Trim(Copy(ARecvData, 42, 4));
  // 응답메세지
  Result.Msg := Trim(Copy(ARecvData, 63, 32));
  // 승인번호
  Result.AgreeNo := Trim(Copy(ARecvData, 95, 12));
  // 승인일시 (yyyymmddhhnn)
  Result.AgreeDateTime := '20' + Copy(ARecvData, 50, 12);
  // 거래번호
  Result.TransNo := Trim(Copy(ARecvData, 107, 20));
  // 발급사코드
  Result.BalgupsaCode := Trim(Copy(ARecvData, 142, 2));
  // 발급사명
  Result.BalgupsaName := Trim(Copy(ARecvData, 144, 16));
  // 매입사코드
  Result.CompCode := Trim(Copy(ARecvData, 160, 2));
  // 매입사명
  Result.CompName := Trim(Copy(ARecvData, 162, 16));
  // 가맹점번호
  Result.KamaengNo := Trim(Copy(ARecvData, 127, 15));
  // 할인금액
  Result.DCAmt := 0;
  // 마스킹된 카드번호
  Result.CardNo := Trim(Copy(ARecvData, 337, 30));
  // 정상 서명 여부
  Result.IsSignOK := True;
end;

function TVanKsnetDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // 성공여부
  if Trim(Copy(ARecvData, 41, 1)) = 'O' then
    Result.Result := True
  else
    Result.Result := False;
  // 에러코드
  Result.Code := Trim(Copy(ARecvData, 42, 4));
  // 응답메세지
  Result.Msg := Trim(Copy(ARecvData, 63, 32));
  // 승인번호
  Result.AgreeNo := Trim(Copy(ARecvData, 95, 12));
  // 승인일시 (yyyymmddhhnn)
  Result.AgreeDateTime := '20' + Copy(ARecvData, 50, 12);
  // 마스킹된 카드번호
  Result.CardNo := '';
end;

function TVanKsnetDaemon.MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // 성공여부
  if Trim(Copy(ARecvData, 41, 1)) = 'O' then
    Result.Result := True
  else
    Result.Result := False;
  // 에러코드
  Result.Code := Trim(Copy(ARecvData, 42, 4));
  // 응답메세지
  Result.Msg := Trim(Copy(ARecvData, 63, 32));
end;

function TVanKsnetDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKsnetDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataCard('IC', AInfo);
  // DLL 호출한다.
  if DLLExec(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCard(RecvData);
    // 승인금액
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKsnetDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataCard('HK', AInfo);
  // DLL 호출한다.
  if DLLExec(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCash(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKsnetDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKsnetDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  AInfo.Approval := True;
  SendData := MakeSendDataCard('CH', AInfo);
  // DLL 호출한다.
  if DLLExec(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCheck(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanKsnetDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

{ TVanJtnetDaemon }

constructor TVanJtnetDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(JTNET_DAEMON_DLL);
end;

destructor TVanJtnetDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanJtnetDaemon.DLLExecAblity(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TFN_JTDMABLITY = function(pReqBuf: PAnsiChar; lReqBufLen: Integer; pResBuf: PAnsiChar; lMinTimeOut: Integer): Integer; stdcall;
var
  Exec: TFN_JTDMABLITY;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'FN_JTDMABLITY');
  if not Assigned(@Exec) then
  begin
    ARecvData := JTNET_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Log.Write(ltDebug, ['DLL호출', ASendData]);
  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1], 1) = 1;
  Log.Write(ltDebug, ['DLL응답', Result, 'RecvData', ARecvData]);
  // 맨앞의 길이 4Byte를 제거하고 리턴한다.
  ARecvData := Copy(ARecvData, 5, MAXWORD);
end;

function TVanJtnetDaemon.DLLExecAuth(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TFN_JTDMAUTHREQ = function(pReqBuf: PAnsiChar; lReqBufLen: Integer; pResBuf: PAnsiChar; lMinTimeOut: Integer): Integer; stdcall;
var
  Exec: TFN_JTDMAUTHREQ;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'FN_JTDMAUTHREQ');
  if not Assigned(@Exec) then
  begin
    ARecvData := JTNET_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Log.Write(ltDebug, ['DLL호출', ASendData]);
  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1], 1) = 1;
  Log.Write(ltDebug, ['DLL응답', Result, 'RecvData', ARecvData]);
  // 맨앞의 길이 4Byte를 제거하고 리턴한다.
  ARecvData := Copy(ARecvData, 5, MAXWORD);
end;

function TVanJtnetDaemon.MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
var
  TransCode, OrgAgreeDate: AnsiString;
begin
  // 전문종류 (1010: 신용승인, 1012: 은련승인, 1050: 신용취소, 1052: 은련취소, 5010: 현금승인, 5050: 현금취소, 6080: 수표조회)
  if AInfo.EyCard then
    TransCode := IfThen(AInfo.Approval, '1012', '1052')
  else
    TransCode := IfThen(AInfo.Approval, '1010', '1050');
  Result := Format('%-4.4s', [TransCode]);
  // TID
  Result := Result + Format('%-10.10s', [AInfo.TerminalID]);
  // 전문관리번호
  Result := Result + FormatDateTime('yymmdd', Now) + FormatFloat('000000', GetSeqNo);
  // 전문 전송 일자
  Result := Result + FormatDateTime('yymmddhhnnss', Now);
  // WCC 키인여부
  Result := Result + IfThen(AInfo.KeyInput, 'K', ' ');
  // 트랙2 (길이2Byte + 카드번호=유효기간)
  if Pos('=', AInfo.CardNo) <= 0 then
    AInfo.CardNo := AInfo.CardNo + '=';
  AInfo.CardNo := FormatFloat('00', Length(AInfo.CardNo)) + AInfo.CardNo;
  if AInfo.KeyInput then
    Result := Result + Format('%-100.100s', [AInfo.CardNo])
  else
    Result := Result + Format('%-100.100s', ['']);
  // 할부기간
  Result := Result + FormatFloat('00', AInfo.HalbuMonth);
  // 판매금액
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt);
  // 부가세
  Result := Result + FormatFloat('000000000', AInfo.VatAmt);
  // 봉사료
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt);
  // 통화코드 KRW
  Result := Result + 'KRW';
  // 승인취소시 원승인일자(6) + 원승인번호(12)
  if AInfo.Approval then
    Result := Result + Format('%-6.6s', ['']) + Format('%-12.12s', [''])
  else
  begin
    OrgAgreeDate := AInfo.OrgAgreeDate;
    if Length(OrgAgreeDate) = 6 then OrgAgreeDate := '20' + OrgAgreeDate;
    Result := Result + Copy(IfThen(OrgAgreeDate = EmptyStr, FormatDateTime('yyyymmdd', Now), OrgAgreeDate), 3, 6) +
              Format('%-12.12s', [AInfo.OrgAgreeNo]);
  end;
  // 원거래고유번호
  Result := Result + Format('%-12.12s', ['']);
  // 폴백정보
  Result := Result + Format('%-3.3s', ['Y  ']);
  // 결제코드
  Result := Result + '  ';
  // 서비스코드
  Result := Result + '        ';
  // 비과세금액
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt);
  // 비밀번호
  Result := Result + Format('%-18.18s', ['']);
  // 주유정보
  Result := Result + Format('%-24.24s', ['']);
  // 하위사업자번호
  Result := Result + Format('%-10.10s', ['']);
  // POS시리얼번호
  Result := Result + Format('%-16.16s', ['JPOS150800011EE3']); // JPTP150800015CB5 -> JPOS150800011EE3
  // 부가정보1,2
  Result := Result + Format('%-32.32s', ['']) + Format('%-128.128s', ['']);
  // Reserved
  Result := Result + Format('%-64.64s', ['']);
  // 서명처리 (Y:서명사용, N:서명미사용, R:서명재사용)
  Result := Result + Format('%-1.1s', [AInfo.SignOption]);
  // CR
  Result := Result + CR;
end;

function TVanJtnetDaemon.MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
begin
  // 전문종류 (1010: 신용승인, 1012: 은련승인, 1050: 신용취소, 1052: 은련취소, 5010: 현금승인, 5050: 현금취소, 6080: 수표조회)
  if AInfo.Approval then
    Result := Format('%-4.4s', ['5010'])
  else
    Result := Format('%-4.4s', ['5050']);
  // TID
  Result := Result + Format('%-10.10s', [AInfo.TerminalID]);
  // 전문관리번호
  Result := Result + FormatDateTime('yymmdd', Now) + FormatFloat('000000', GetSeqNo);
  // 전문 전송 일자
  Result := Result + FormatDateTime('yymmddhhnnss', Now);
  // WCC
  Result := Result + IfThen(AInfo.KeyInput, 'K', ' ');
  // 트랙2 (길이2Byte + 카드번호=유효기간)
  if Pos('=', AInfo.CardNo) <= 0 then
    AInfo.CardNo := AInfo.CardNo + '=';
  AInfo.CardNo := FormatFloat('00', Length(AInfo.CardNo)) + AInfo.CardNo;
  if AInfo.KeyInput then
    Result := Result + Format('%-100.100s', [AInfo.CardNo])
  else
    Result := Result + Format('%-100.100s', ['']);
  // 판매금액
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.VatAmt - AInfo.SvcAmt);
  // 부가세
  Result := Result + FormatFloat('000000000', AInfo.VatAmt);
  // 봉사료
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt);
  // 거래자구분 (0:소비자소득공제, 1:사업자지출증빙)
  Result := Result + IfThen(AInfo.Person = 2, '1', '0');
  // 현금영수증취소일때 원거래일자(yymmdd,6) + 원승인번호(12) + 취소사유(1)
  if Length(AInfo.OrgAgreeDate) = 6 then
    AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Approval then
    Result := Result + Format('%-19.19s', [''])
  else
    Result := Result + Copy(AInfo.OrgAgreeDate, 3, 6) + Format('%-12.12s', [AInfo.OrgAgreeNo]) + Format('%-1.1s', [IntToStr(AInfo.CancelReason)]);
  // 비과세금액
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt);
  // 하위사업자번호
  Result := Result + Format('%-10.10s', ['']);
  // 부가정보1,2,3
  Result := Result + Format('%-176.176s', ['']);
  // CR
  Result := Result + CR;
end;

function TVanJtnetDaemon.MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
begin
  // 전문종류 (1010: 신용승인, 1012: 은련승인, 1050: 신용취소, 1052: 은련취소, 5010: 현금승인, 5050: 현금취소, 6080: 수표조회)
  Result := Format('%-4.4s', ['6080']);
  // TID
  Result := Result + Format('%-10.10s', [AInfo.TerminalID]);
  // 전문관리번호
  Result := Result + FormatDateTime('yymmdd', Now) + FormatFloat('000000', GetSeqNo);
  // 전문 전송 일자
  Result := Result + FormatDateTime('yymmddhhnnss', Now);
  // 수표번호(8) + 은행코드(2) + 지점코드(4) + 권종코드(2)
  Result := Result + Format('%-16.16s', [Copy(AInfo.CheckNo, 1, 8) + Copy(AInfo.BankCode, 1, 2) + Copy(AInfo.BranchCode, 1, 4) + Copy(AInfo.KindCode, 1, 2)]);
  // 수표금액
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt);
  // 수표발행일자
  if Length(AInfo.RegDate) = 6 then
    Result := Result + Format('%-6.6s', [Copy(AInfo.RegDate, 1, 6)])
  else
    Result := Result + Format('%-6.6s', [Copy(AInfo.RegDate, 3, 6)]);
  // 단위농협코드
  Result := Result + Format('%-6.6s', [Copy(AInfo.AccountNo, 1, 6)]);
  // 부가정보1
  Result := Result + Format('%-16.16s', ['']);
  // CR
  Result := Result + CR;
end;

function TVanJtnetDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
var
  GiftCardAmt: AnsiString;
begin
  Result.Result := Copy(ARecvData, 96, 1) = 'S';
  if not Result.Result then
  begin
    Result.Msg := Copy(ARecvData, 97, 36);
    Exit;
  end;
  // 응답코드
  Result.Code := Trim(Copy(ARecvData, 97, 4));
  // 성공여부
  Result.Result := Result.Code = '0000';
  if Result.Result then
  begin
    // 승인번호
    Result.AgreeNo := Trim(Copy(ARecvData, 97+4, 12));
    // 거래일시
    Result.AgreeDateTime := '20' + Copy(ARecvData, 97+16, 12);
    // 거래번호
    Result.TransNo := Trim(Copy(ARecvData, 97+28, 12));
  end;
  // 가맹점번호
  Result.KamaengNo := Trim(Copy(ARecvData, 97+40, 15));
  // 발급사코드
  Result.BalgupsaCode := Trim(Copy(ARecvData, 97+55, 4));
  // 발급사명
  Result.BalgupsaName := Trim(Copy(ARecvData, 97+59, 20));
  // 매입사코드
  Result.CompCode := Trim(Copy(ARecvData, 97+79, 4));
  // 매입사명
  Result.CompName := Trim(Copy(ARecvData, 97+83, 20));
  // 승인금액
  //Result.AgreeAmt  := //전문에 승인금액 없음.
  // 할인금액
  Result.DCAmt := StrToIntDef(Copy(ARecvData, 97+108, 9), 0);
  // IC카드번호
  Result.CardNo := Trim(Copy(ARecvData, 97+430, 20));
  // 정상 서명 여부
  Result.IsSignOK := True;
  // 응답메세지
  if Result.Result then
  begin
    GiftCardAmt := Trim(Copy(ARecvData, 97+144, 9)); // 선불카드 잔액
    if GiftCardAmt <> '' then
      GiftCardAmt := IntToStr(StrToIntDef(GiftCardAmt, 0));
    Result.Msg := IfThen(GiftCardAmt <> '', '잔액: ' + GiftCardAmt + ' ', '') + Trim(Copy(ARecvData, 97+450, 168));
  end
  else
    Result.Msg :=  Trim(Copy(ARecvData, 97+4, 36));
end;

function TVanJtnetDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := Copy(ARecvData, 96, 1) = 'S';
  if not Result.Result then
  begin
    Result.Msg := Copy(ARecvData, 97, 36);
    Exit;
  end;
  // 응답코드
  Result.Code := Trim(Copy(ARecvData, 97, 4));
  Result.Result := Result.Code = '0000';
  if Result.Result then
  begin
    // 승인번호
    Result.AgreeNo := Trim(Copy(ARecvData, 97+4, 12));
    // 승인일시(yymmddhhmmss)
    Result.AgreeDateTime := '20' + Copy(ARecvData, 97+16, 12);
    // 화면표시메세지
    Result.Msg := Trim(Copy(ARecvData, 97+375, 168));
  end
  else
    // 화면표시메세지
    Result.Msg := Trim(Copy(ARecvData, 97+4, 36));
  // 카드번호
  Result.CardNo := Trim(Copy(ARecvData, 97+355, 20));
end;

function TVanJtnetDaemon.MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := Copy(ARecvData, 96, 1) = 'S';
  if not Result.Result then
  begin
    Result.Msg := Copy(ARecvData, 97, 36);
    Exit;
  end;
  // 에러코드
  Result. Code := Trim(Copy(ARecvData, 97, 4));
  // 결과
  Result.Result := Result.Code = '0000';
  // 참고사항(에러 내용)
  if Result.Result then
    Result.Msg := '정상수표'
  else
    Result.Msg := Trim(Copy(ARecvData, 97+4, 36));
end;

function TVanJtnetDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanJtnetDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataCard(AInfo);
  // DLL 호출한다.
  if DLLExecAuth(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCard(RecvData);
    // 승인금액
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Copy(RecvData, 1, 4);
    Result.Msg := Copy(RecvData, 5, MAXWORD);
  end;
end;

function TVanJtnetDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataCash(AInfo);
  // DLL 호출한다.
  if DLLExecAuth(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCash(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Copy(RecvData, 1, 4);
    Result.Msg := Copy(RecvData, 5, MAXWORD);
  end;
end;

function TVanJtnetDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanJtnetDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  AInfo.Approval := True;
  SendData := MakeSendDataCheck(AInfo);
  // DLL 호출한다.
  if DLLExecAuth(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCheck(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Copy(RecvData, 1, 4);
    Result.Msg := Copy(RecvData, 5, MAXWORD);
  end;
end;

function TVanJtnetDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := 'PC' + FormatFloat('000000000', ASendAmt) + RPadB('식별번호 입력', 16) + CR;
  // DLL 호출한다.
  if DLLExecAblity(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := True;
    ARecvData := Trim(Copy(RecvData, 3, 49));
  end
  else
  begin
    Result := False;
    ARecvData := Copy(RecvData, 5, MAXWORD);
  end;
end;

{ TVanNiceDaemon }

constructor TVanNiceDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(NICE_DAEMON_DLL);
end;

destructor TVanNiceDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanNiceDaemon.DLLExecVCat(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TNICEVCAT = function(ASendData: PAnsiChar; ARecvData: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TNICEVCAT;
begin
  Result := False;
  SetLenAndFill(ARecvData, 4096);

  @Exec := GetProcAddress(FDLLHandle, 'NICEVCAT');
  if not Assigned(@Exec) then
  begin
    ARecvData := NICE_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Ret := Exec(PAnsiChar(ASendData), @ARecvData[1]);
  Result := Ret = 1;
  if not Result then
  begin
    case Ret of
       -1 : ARecvData := 'NVCAT 실행이 실행중이 아님';
       -2 : ARecvData := '거래금액이 존재하지 않음';
       -3 : ARecvData := '환경정보 읽기 실패';
       -4 : ARecvData := 'NVCAT 연동오류 실패';
       -5 : ARecvData := '기타 응답데이터 오류';
       -6 : ARecvData := '카드리딩 타임아웃';
       -7 : ARecvData := '사용자 및 리더기 취소';
       -8 : ARecvData := 'FALLBACK 거래요청';
       -9 : ARecvData := '기타오류';
      -10 : ARecvData := 'IC 우선거래요청(IC카드 MS리딩시)';
      -11 : ARecvData := 'FALLBACK 거래 아님';
      -12 : ARecvData := '거래불가카드';
      -13 : ARecvData := '서명요청오류';
      -14 : ARecvData := '요청 전문 데이터 오류';
      -15 : ARecvData := '카드리더 Port오픈 에러';
      -16 : ARecvData := '직전거래 망취소불가(전문관리번호 없음)';
      -17 : ARecvData := '중복요청 불가';
      -18 : ARecvData := '지원되지 않는 카드';
      -19 : ARecvData := '현금IC카드 복수계좌 미지원';
      -20 : ARecvData := 'TIT 카드리더 오류';
    else
      ARecvData := '알수 없는 오류';
    end;
  end;
  Log.Write(ltDebug, ['DaemonDLL호출', Result, '함수리턴값', Ret, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanNiceDaemon.MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
begin
  // 거래구분 (4자리, 승인:0200 취소:0420)
  if AInfo.Approval then
    Result := '0200' + FS
  else
    Result := '0420' + FS;
  // 거래유형 (신용:10 현금영수증:21 은련카드:UP)
  if AInfo.EyCard then
    Result := Result + 'UP' + FS
  else
    Result := Result + '10' + FS;
  // WCC (카드:C KeyIn:K FALLBACK: F)
  Result := Result + 'C' + FS;
  // 거래금액
  Result := Result + CurrToStr(AInfo.SaleAmt) + FS;
  // 부가세
  Result := Result + CurrToStr(AInfo.VatAmt) + FS;
  // 봉사료
  Result := Result + CurrToStr(AInfo.SvcAmt) + FS;
  // 할부기간
  Result := Result + FormatFloat('00', AInfo.HalbuMonth) + FS;
  // 원 승인번호
  Result := Result + IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo) + FS;
  // 원 승인일자
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '', Copy(AInfo.OrgAgreeDate, 3, 6)) + FS;
  // 승인CATID
  Result := Result + AInfo.TerminalID + FS;
  Result := Result + FS + FS;
  // 거래일련번호 (사용안함)
  Result := Result + FS;
  // 면세금액
  Result := Result + CurrToStr(AInfo.FreeAmt) + FS;
  // 납세자번호 구분자
  Result := Result + FS;
  // 납세자번호 Data
  Result := Result + FS;
  // 전문관리번호
  Result := Result + FS;
  // Filler
  Result := Result + FS;
  // 서명패드 표시 금액
  Result := Result + FS;
end;

function TVanNiceDaemon.MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
begin
  // 거래구분 (4자리, 승인:0200 취소:0420)
  if AInfo.Approval then
    Result := '0200' + FS
  else
    Result := '0420' + FS;
  // 거래유형 (신용:10 현금영수증:21 은련카드:UP)
  Result := Result + '21' + FS;
  // WCC (카드:C KeyIn:K FALLBACK: F)
  if AInfo.KeyInput then
    Result := Result + 'K' + FS
  else
    Result := Result + 'C' + FS;
  // 거래금액
  Result := Result + CurrToStr(AInfo.SaleAmt) + FS;
  // 부가세
  Result := Result + CurrToStr(AInfo.VatAmt) + FS;
  // 봉사료
  Result := Result + CurrToStr(AInfo.SvcAmt) + FS;
  // 구분 (01:소득공제, 02:지출증빙, 03:자진발급)
  Result := Result + FormatFloat('00', AInfo.Person) + FS;
  // 원 승인번호
  Result := Result + IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo) + FS;
  // 원 승인일자
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  Result := Result + IfThen(AInfo.Approval, '', Copy(AInfo.OrgAgreeDate, 3, 6)) + FS;
  // 승인CATID
  Result := Result + FS;
  Result := Result + FS + FS;
  // 거래일련번호 (사용안함)
  Result := Result + FS;
  // 면세금액
  Result := Result + CurrToStr(AInfo.FreeAmt) + FS;
  // 납세자번호 구분자
  Result := Result + FS;
  // 납세자번호 Data
  Result := Result + FS;
  // 전문관리번호
  Result := Result + FS;
  // Filler
  Result := Result + FS;
  // 서명패드 표시 금액
  Result := Result + FS;
end;

function TVanNiceDaemon.MakeSendDataCheck(AInfo: TCardSendInfoDM): AnsiString;
begin
  // 거래구분
  Result := '0200' + FS;
  // 거래유형 (수표조회:20)
  Result := Result + '20' + FS;
  // WCC (KeyIn:K)
  Result := Result + 'K' + FS;
  // 수표종류 (자기앞수표:00 가계수표:01 당좌수표:02)
  Result := Result + '00' + FS;
  // 수표권종
  Result := Result + Format('%-2.2s', [AInfo.KindCode]) + FS;
  // 수표번호
  Result := Result + Format('%-14.14s', [LeftStr(AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode, 14)]) + FS;
  // 발행일
  Result := Result + Format('%-6.6s', [AInfo.RegDate]) + FS;
  // 주민등록번호
  Result := Result + '             ' + FS;
  // 수표금액
  Result := Result + CurrToStr(AInfo.SaleAmt) + FS;
  // 계좌일련번호
  Result := Result + Format('%-6.6s', [AInfo.AccountNo]) + FS;
end;

function TVanNiceDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // 응답코드
  Result.Code := StringSearch(ARecvData, FS, 2);
  // 응답메세지
  Result.Msg := StringSearch(ARecvData, FS, 16);
  // 승인번호
  Result.AgreeNo := StringSearch(ARecvData, FS, 7);
  // 승인일시(yyyymmddhhnnss)
  Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 8);
  // 거래번호
  Result.TransNo := StringSearch(ARecvData, FS, 19);
  // 발급사코드
  Result.BalgupsaCode := StringSearch(ARecvData, FS, 9);
  // 발급사명
  Result.BalgupsaName := StringSearch(ARecvData, FS, 10);
  // 매입사코드
  Result.CompCode := StringSearch(ARecvData, FS, 11);
  // 매입사명
  Result.CompName := StringSearch(ARecvData, FS, 12);
  // 가맹점번호
  Result.KamaengNo := StringSearch(ARecvData, FS, 13);
  // 승인금액
  Result.AgreeAmt := StrToIntDef(StringSearch(ARecvData, FS, 3), 0);
  // 할인금액
  Result.DCAmt := 0;
  // 마스킹된 카드번호
  Result.CardNo := StringSearch(ARecvData, FS, 17);
  // 정상 서명 여부
  Result.IsSignOK := True;
  // 성공여부
  Result.Result := Result.Code = '0000';
end;

function TVanNiceDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // 응답코드
  Result.Code := StringSearch(ARecvData, FS, 2);
  // 응답메세지
  Result.Msg := StringSearch(ARecvData, FS, 16);
  // 승인번호
  Result.AgreeNo := StringSearch(ARecvData, FS, 7);
  // 승인일시(yyyymmddhhnnss)
  Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 8);
  // 마스킹된 카드번호
  Result.CardNo := StringSearch(ARecvData, FS, 17);
  // 성공여부
  Result.Result := Result.Code = '0000';
end;

function TVanNiceDaemon.MakeRecvDataCheck(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // 응답코드
  Result.Code := StringSearch(ARecvData, FS, 2);
  // 응답메세지
  Result.Msg := StringSearch(ARecvData, FS, 4);
  // 성공여부
  Result.Result := Result.Code = '0000';
end;

function TVanNiceDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanNiceDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataCard(AInfo);
  // DLL 호출한다.
  if DLLExecVCat(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCard(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanNiceDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataCash(AInfo);
  // DLL 호출한다.
  if DLLExecVCat(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCash(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanNiceDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '기능 미구현';
end;

function TVanNiceDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  SendData := MakeSendDataCheck(AInfo);
  // DLL 호출한다.
  if DLLExecVCat(SendData, RecvData) then
  begin
    // 응답을 처리한다.
    Result := MakeRecvDataCheck(RecvData);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanNiceDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

{ TVanSmartroDaemon }

constructor TVanSmartroDaemon.Create;
begin
  inherited;
  SmtSndRcvVCAT := TSmtSndRcvVCAT.Create(nil);
end;

destructor TVanSmartroDaemon.Destroy;
begin
  SmtSndRcvVCAT.Free;
  inherited;
end;

function TVanSmartroDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Ret: Integer;
  TempStr: AnsiString;
begin
  Result.Result := False;
  // 초기화
  SmtSndRcvVCAT.InitData;
  // 서비스 유형 (0101:거래승인 2101:거래취소)
  if not SetSendData(1, IfThen(AInfo.Approval, '0101', '2101'), Result.Msg) then Exit;
  // 거래 구분 코드 (01:신용 02:현금 03:은련)
  if not SetSendData(2, IfThen(AInfo.EyCard, '03', '01'), Result.Msg) then Exit;
  // 판매금액
  if not SetSendData(3, FormatFloat('0000000000', (AInfo.SaleAmt)), Result.Msg) then Exit;
  // 부가세
  if not SetSendData(4, FormatFloat('00000000', AInfo.VatAmt), Result.Msg) then Exit;
  // 봉사료
  if not SetSendData(5, FormatFloat('00000000', AInfo.SvcAmt), Result.Msg) then Exit;
  // 할부개월
  if not SetSendData(6, FormatFloat('00', AInfo.HalbuMonth), Result.Msg) then Exit;
  if not AInfo.Approval then
  begin
    // 승인번호
    if not SetSendData(12, AInfo.OrgAgreeNo, Result.Msg) then Exit;
    // 승인일시
    if (Length(AInfo.OrgAgreeDate) = 6) then
       AInfo.OrgAgreeDate := '20' +  AInfo.OrgAgreeDate;
    if not SetSendData(13, AInfo.OrgAgreeDate, Result.Msg) then Exit;
  end;
  // 서명여부 (1:비서명 2:서명 3:단말기셋팅)
  if AInfo.SignOption = 'Y' then
    TempStr := '2'
  else if AInfo.SignOption = 'N' then
    TempStr := '1'
  else
    TempStr := '3';
  if not SetSendData(9, TempStr, Result.Msg) then Exit;
  // 예비필드1 (멀티사업자 단말기ID)
  if AInfo.TerminalID <> '' then
  begin
    // TAG(2 Byte) + LENGTH(3 Byte) + DATA
    TempStr := '49' + '010' + Format('%-10.10s', [AInfo.TerminalID]);
    if not SetSendData(10, TempStr, Result.Msg) then Exit;
  end;

  // 승인 호출
  Ret := SmtSndRcvVCAT.PosToVCATSndRcv('127.0.0.1', 13855, 60);
  if Ret = 1 then
  begin
    Result.Code := GetRecvData(17);                           // 응답코드
    Result.Result := Result.Code = '00';                      // 응답결과
    Result.Msg := GetRecvData(18);                            // 응답 메세지
    Result.CardNo := GetRecvData(3);                          // 카드번호
    Result.AgreeAmt := StrToIntDef(GetRecvData(4), 0);        // 승인금액
    Result.AgreeNo := GetRecvData(8);                         // 승인번호
    Result.AgreeDateTime := GetRecvData(9) + GetRecvData(10); // 거래일시
    Result.TransNo := GetRecvData(11);                        // 거래고유번호
    Result.KamaengNo := GetRecvData(12);                      // 가맹점번호
    Result.BalgupsaCode := Copy(GetRecvData(14), 1, 4);       // 발급사코드
    Result.BalgupsaName := Copy(GetRecvData(14), 5, MAXBYTE); // 발급사명
    Result.CompCode := Copy(GetRecvData(15), 1, 4);           // 매입사코드
    Result.CompName := Copy(GetRecvData(15), 5, MAXBYTE);     // 매입사명
    Result.IsSignOK := GetRecvData(24) <> '';                 // 서명
    Result.DCAmt := 0;
  end
  else
    Result.Msg := GetErrorMsg(Ret);
end;

function TVanSmartroDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Ret: Integer;
  TempStr: AnsiString;
begin
  Result.Result := False;
  // 초기화
  SmtSndRcvVCAT.InitData;
  // 서비스 유형 (0101:거래승인 2101:거래취소)
  if not SetSendData(1, IfThen(AInfo.Approval, '0101', '2101'), Result.Msg) then Exit;
  // 거래 구분 코드 (01:신용 02:현금 03:은련)
  if not SetSendData(2, '02', Result.Msg) then Exit;
  // 판매금액
  if not SetSendData(3, FormatFloat('0000000000', (AInfo.SaleAmt)), Result.Msg) then Exit;
  // 부가세
  if not SetSendData(4, FormatFloat('00000000', AInfo.VatAmt), Result.Msg) then Exit;
  // 봉사료
  if not SetSendData(5, FormatFloat('00000000', AInfo.SvcAmt), Result.Msg) then Exit;
  // 거래자구분 (0:개인 1:사업자) + 확인자구분 (0:신용카드 1:주민번호 2:사업자 3:핸드폰 4:보너스카드)
  if AInfo.Person = 1 then
    TempStr := '0' + IfThen(AInfo.KeyInput, '3', '0')
  else
    TempStr := '1' + IfThen(AInfo.KeyInput, '2', '0');
  if not SetSendData(6, TempStr, Result.Msg) then Exit;
  if not AInfo.Approval then
  begin
    // 승인번호
    if not SetSendData(12, AInfo.OrgAgreeNo, Result.Msg) then Exit;
    // 승인일시
    if (Length(AInfo.OrgAgreeDate) = 6) then
       AInfo.OrgAgreeDate := '20' +  AInfo.OrgAgreeDate;
    if not SetSendData(13, AInfo.OrgAgreeDate, Result.Msg) then Exit;
    // 현금취소사유
    if not SetSendData(14, FormatFloat('0', AInfo.CancelReason), Result.Msg) then Exit;
  end;
  // 서명여부 (0:단말기셋팅, 1:현금영수증카드, 2:핀패드)
  if not SetSendData(9, IfThen(AInfo.KeyInput, '2', '1'), Result.Msg) then Exit;
  // 예비필드1 (멀티사업자 단말기ID)
  if AInfo.TerminalID <> '' then
  begin
    // TAG(2 Byte) + LENGTH(3 Byte) + DATA
    TempStr := '49' + '010' + Format('%-10.10s', [AInfo.TerminalID]);
    if not SetSendData(10, TempStr, Result.Msg) then Exit;
  end;

  // 승인 호출
  Ret := SmtSndRcvVCAT.PosToVCATSndRcv('127.0.0.1', 13855, 60);
  if Ret = 1 then
  begin
    Result.Code := GetRecvData(17);                           // 응답코드
    Result.Result := Result.Code = '00';                      // 응답결과
    Result.Msg := GetRecvData(18);                            // 응답 메세지
    Result.CardNo := GetRecvData(3);                          // 카드번호
    Result.AgreeNo := GetRecvData(8);                         // 승인번호
    Result.AgreeDateTime := GetRecvData(9) + GetRecvData(10); // 승인일시
  end
  else
    Result.Msg := GetErrorMsg(Ret);
end;

function TVanSmartroDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanSmartroDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Ret: Integer;
  CheckInfo: AnsiString;
begin
  Result.Result := False;
  // 초기화
  SmtSndRcvVCAT.InitData;
  // 서비스 유형 (0401:수표조회)
  if not SetSendData(1, '0401', Result.Msg) then Exit;
  // 구분 (00:자기앞수표)
  if not SetSendData(56, '00', Result.Msg) then Exit;
  // 수표정보  수표번호(8) + 은행코드(2) + 지점코드(4) + 계좌번호(6)
  CheckInfo := Format('%-8.8s', [AInfo.CheckNo]) + Format('%-2.2s', [AInfo.BankCode]) +
               Format('%-4.4s', [AInfo.BranchCode]) + Format('%-6.6s', [AInfo.AccountNo]);
  if not SetSendData(57, CheckInfo, Result.Msg) then Exit;
  // 수표발행일자
  if not SetSendData(58, Copy(AInfo.RegDate, 3, 6), Result.Msg) then Exit;
  // 권종코드
  if not SetSendData(59, AInfo.KindCode, Result.Msg) then Exit;
  // 수표금액
  if not SetSendData(60, FormatFloat('000000000000', AInfo.SaleAmt), Result.Msg) then Exit;
  // 승인 호출
  Ret := SmtSndRcvVCAT.PosToVCATSndRcv('127.0.0.1', 13855, 60);
  if Ret = 1 then
  begin
    Result.Code := GetRecvData(17);                           // 응답코드
    Result.Result := Result.Code = '00';                      // 응답결과
    Result.Msg := GetRecvData(18);                            // 응답 메세지
  end
  else
    Result.Msg := GetErrorMsg(Ret);
end;

function TVanSmartroDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

function TVanSmartroDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanSmartroDaemon.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
      1 : Result := '정상승인';
     -1 : Result := '승인오류';
     -3 : Result := '송신 DATA 전문구성실패';
    -40 : Result := 'IP입력값 실패';
    -30 : Result := '서버 연결 실패';
    -31 : Result := 'DATA전송 실패';
    -10 : Result := 'NAK수신';
    -11 : Result := 'FF수신';
    -12 : Result := 'ETX Check Fail';
    -13 : Result := 'STX Check Fail';
     -9 : Result := 'TimerOut';
    -99 : Result := '정의되지 않은 오류';
    -98 : Result := '서버응답값 오류';
    -97 : Result := '전문수신 INDEX 오류';
    -96 : Result := '메모리 호출 오류';
    -95 : Result := '단말기 COM, TCP 선택오류';
    -94 : Result := '전문데이터 입력 오류';
  else
    Result := '기타 에러';
  end;
  if ACode <> 0 then
    Result := Result + ' [' + IntToStr(ACode) + ']';
end;

function TVanSmartroDaemon.SetSendData(const AIndex: Integer; const AValue: AnsiString; out ARetMsg: AnsiString): Boolean;
begin
  Result := False;
  if SmtSndRcvVCAT.SetTRData(AIndex, AValue) = 1 then
  begin
    ARetMsg := '정상';
    Result := True;
  end
  else
  begin
    case AIndex of
      1  : ARetMsg := '서비스 유형별 코드 입력오류';
      2  : ARetMsg := '거래구분코드 입력오류';
      3  : ARetMsg := '승인요청금액 입력오류';
      4  : ARetMsg := '세금 입력오류';
      5  : ARetMsg := '봉사료 입력오류';
      6  : ARetMsg := '현금승인유형 입력오류';
      7  : ARetMsg := '비밀번호 입력오류';
      8  : ARetMsg := '전표에 인쇄할 품목명 입력오류';
      9  : ARetMsg := '서명여부 입력오류';
      10 : ARetMsg := '예비필드1 입력오류';
      11 : ARetMsg := '예비필드2 입력오류';
      12 : ARetMsg := '승인번호 입력오류';
      13 : ARetMsg := '원거래일자 입력오류';
      14 : ARetMsg := '현금취소구분 입력오류';
      15 : ARetMsg := '보너스구분자 입력오류';
      16 : ARetMsg := '보너스 사용구분 입력오류';
      17 : ARetMsg := '보너스 승인번호 입력오류';
      18 : ARetMsg := 'MasterKey Index 입력오류';
      19 : ARetMsg := 'WorkingKey 입력오류';
    else
      ARetMsg := '정의 되지 않은 입력오류';
    end;
  end;
end;

function TVanSmartroDaemon.GetRecvData(const AIndex: Integer): AnsiString;
begin
  Result := SmtSndRcvVCAT.GetResDataCount(1, AIndex);
end;

{ TVanKcpDaemon }

constructor TVanKcpDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(LIBKCP_SECURE_DLL);
end;

destructor TVanKcpDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKcpDaemon.MakeSendDataHeader(AApproval: Boolean; AProcCode, ATerminalID: AnsiString; ADetailSendData: AnsiString): AnsiString;
begin
  if AProcCode = 'C06000' then
    Result := '4100'
  else
    // 요청구분
    Result := IfThen(AApproval, '0100', '0420');

  // 업무구분
  Result := Result + AProcCode;
  // 단말기ID (데몬에서 다중사업자로 세팅된 경우 사용함.)
  Result := Result + Format('%-10.10s', [ATerminalID]);
  // 업체코드
  Result := Result + Format('%-4.4s', [KCP_VER_INFO]);
  // 포스 시리얼번호
  Result := Result + Format('%-16.16s', ['']);
  // 포스 제품명
  Result := Result + Format('%-12.12s', ['']);
  // 포스 S/W버전
  Result := Result + Format('%-4.4s', ['']);
  // 전문추적번호
  Result := Result + FormatFloat('000000', GetSeqNo) + FS;
  Result := Result + ADetailSendData;
  Result := STX + FormatFloat('0000', Length(Result)) + Result;
end;

function TVanKcpDaemon.MakeSendDataCard(AInfo: TCardSendInfoDM): AnsiString;
begin
  // 거래유형 (보안리더기처리: '99')
  if AInfo.OTCNo = EmptyStr then
    Result := '99' + FS
  else
  begin
    if Length(AInfo.OTCNo) < 30 then
      Result := '80' + FS
    else
      Result := '90' + FS;
  end;
  // 할부개월수
  Result := Result + FormatFloat('00', AInfo.HalbuMonth) + FS;
  // 총거래금액
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt) + FS;
  // 과세금액
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.FreeAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS;
  // 면세금액
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt) + FS;
  // 봉사료
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt) + FS;
  // 세금
  Result := Result + FormatFloat('000000000', AInfo.VatAmt) + FS;
  if AInfo.Approval then
  begin
    // 요청일자
    Result := Result + FormatDateTime('yymmdd', Now) + FS;
    // 원승인번호
    Result := Result + FS;
  end
  else
  begin
    // 원거래일자
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    Result := Result + Copy(IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yymmdd', Now), AInfo.OrgAgreeDate), 3, 6) + FS;
    // 원승인번호
    Result := Result + AInfo.OrgAgreeNo + FS;
  end;
  // 면세유정보
  Result := Result + FS;
  // 서명데이터요청
  Result := Result + FS;
  // 서명데이터
  Result := Result + FS;
  // 멤버십, 포인트 구분
  Result := Result + FS;
  // 포인트 현금적립 구분
  Result := Result + FS;
  // PG 결제 여부
  if AInfo.Reserved1 <> '' then
    Result := Result + 'Y' + FS
  else
    Result := Result + FS;
  // 사용자 DATA
  if AInfo.Reserved1 <> '' then
    Result := Result + '0002' + SI + SI + SI + SI + SI + '000000000' + SI + '000000000' + FS
  else
    Result := Result + FS;
  // 서비스타입
  Result := Result + FS;
  // 대표상품명
  Result := Result + FS;
  // 상품 DATA
  Result := Result + FS;
  // 키오스크 여부
  Result := Result + FS;
  // 예비
//  if AInfo.Reserved1 <> '' then
//    Result := Result + 'PG' + SI + SI + AInfo.Reserved1 + SI + SI + SI + SI + SI + SI + SI + SI + ETX
//  else
//    Result := Result + ETX;
  if AInfo.Reserved1 <> '' then
    Result := Result + 'PG' + SI + SI + AInfo.Reserved1 + SI + SI + SI + SI + SI + SI + SI + SI + FS
  else
    Result := Result + FS;
  // OTC 번호(앱카드)
  Result := Result + AInfo.OTCNo + FS;
  // 거래번호(거래번호로 취소시 필요)
  Result := Result + EmptyStr + FS;
  // 카드번호 Bin
  Result := Result + Ifthen(AInfo.CardBinNo = EmptyStr, '', Copy(AInfo.CardBinNo, 1, 6));

  Result := Result + ETX;
end;

function TVanKcpDaemon.MakeRecvDataCard(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // ETX까지 자른다.
  ARecvData := StringSearch(ARecvData, ETX, 0);
  // 응답코드
  Result.Code := StringSearch(ARecvData, FS, 1);
  Result.Result := Result.Code = '0000';
  // 응답메세지
  Result.Msg := StringSearch(ARecvData, FS, 2) + StringSearch(ARecvData, FS, 3) + StringSearch(ARecvData, FS, 4) + StringSearch(ARecvData, FS, 5);
  if Result.Result then
  begin
    // 카드BIN
    Result.CardNo := StringSearch(ARecvData, FS, 6);
    // 매입사코드
    Result.CompCode := StringSearch(ARecvData, FS, 7);
    // 매입사명
    Result.CompName := StringSearch(ARecvData, FS, 8);
    // 발급사코드
    Result.BalgupsaCode := StringSearch(ARecvData, FS, 9);
    // 발급사명
    Result.BalgupsaName := StringSearch(ARecvData, FS, 10);
    // 가맹점번호
    Result.KamaengNo := StringSearch(ARecvData, FS, 11);
    // 거래승인일시
    Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 12);
    // 거래고유번호
    Result.TransNo := StringSearch(ARecvData, FS, 13);
    // 총거래금액
    Result.AgreeAmt := StrToIntDef(StringSearch(ARecvData, FS, 15), 0);
    Result.DCAmt := 0;
    // 승인번호
    Result.AgreeNo := StringSearch(ARecvData, FS, 21);
    // 정상 서명 여부
    Result.IsSignOK := True;
  end;
end;

function TVanKcpDaemon.MakeRecvDataCash(ARecvData: AnsiString): TCardRecvInfoDM;
begin
  // ETX까지 자른다.
  ARecvData := StringSearch(ARecvData, ETX, 0);
  // 응답코드
  Result.Code := StringSearch(ARecvData, FS, 1);
  Result.Result := Result.Code = '0000';
  // 응답메세지
  Result.Msg := StringSearch(ARecvData, FS, 2) + StringSearch(ARecvData, FS, 3) + StringSearch(ARecvData, FS, 4) + StringSearch(ARecvData, FS, 5);
  if Result.Result then
  begin
    // 카드BIN
    Result.CardNo := StringSearch(ARecvData, FS, 6);
    // 거래승인일시
    Result.AgreeDateTime := '20' + StringSearch(ARecvData, FS, 12);
    // 승인번호
    Result.AgreeNo := StringSearch(ARecvData, FS, 21);
  end;
end;

function TVanKcpDaemon.MakeSendDataCash(AInfo: TCardSendInfoDM): AnsiString;
begin
  // 거래유형 (보안리더기처리:'99', Key-In:'10')
  Result := IfThen(AInfo.KeyInput, '10', '99') + FS;
  // 신분정보
  Result := Result + AInfo.CardNo + FS;
  // 거래자구분
  Result := Result + IfThen(AInfo.Person = 2, '1', '0') + FS;
  // 총거래금액
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt) + FS;
  // 과세금액
  Result := Result + FormatFloat('000000000', AInfo.SaleAmt - AInfo.FreeAmt - AInfo.VatAmt - AInfo.SvcAmt) + FS;
  // 면세금액
  Result := Result + FormatFloat('000000000', AInfo.FreeAmt) + FS;
  // 봉사료
  Result := Result + FormatFloat('000000000', AInfo.SvcAmt) + FS;
  // 세금
  Result := Result + FormatFloat('000000000', AInfo.VatAmt) + FS;
  if AInfo.Approval then
  begin
    // 요청일자
    Result := Result + FormatDateTime('yymmdd', Now) + FS;
    // 원승인번호
    Result := Result + FS;
  end
  else
  begin
    // 원거래일자
    if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
    Result := Result + Copy(IfThen(AInfo.OrgAgreeDate = EmptyStr, FormatDateTime('yymmdd', Now), AInfo.OrgAgreeDate), 3, 6) + FS;
    // 원승인번호
    Result := Result + AInfo.OrgAgreeNo + FS;
  end;
  // 취소사유코드
  Result := Result + IfThen(AInfo.Approval, '0', IntToStr(AInfo.CancelReason));
  // PG 결제 여부
  if AInfo.Reserved1 <> '' then
    Result := Result + 'Y' + FS
  else
    Result := Result + FS;
  // 사용자 DATA
  if AInfo.Reserved1 <> '' then
    Result := Result + '0002' + SI + SI + SI + SI + SI + '000000000' + SI + '000000000' + FS
  else
    Result := Result + FS;
  // 키오스크 여부
  Result := Result + FS;
  // 예비
  if AInfo.Reserved1 <> '' then
    Result := Result + 'PG' + SI + SI + AInfo.Reserved1 + SI + SI + SI + SI + SI + SI + SI + SI + ETX
  else
    Result := Result + ETX;
end;

function TVanKcpDaemon.DLLExecTrans(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TKCPDaemonTrans = function(sReqData: PAnsiChar; sReqLen: Integer; sResData: PAnsiChar): Integer; stdcall;
var
  Exec: TKCPDaemonTrans;
begin
  Result := False;
  SetLenAndFill(ARecvData, 4096);

  @Exec := GetProcAddress(FDLLHandle, 'KCPDaemonTrans');
  if not Assigned(@Exec) then
  begin
    ARecvData := LIBKCP_SECURE_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1]) > 0;
  Log.Write(ltDebug, ['KcpDaemon전문통신', Result, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanKcpDaemon.DLLExecFunction(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TKCPDaemonFunction = function(sReqData: PAnsiChar; sReqLen: Integer; sResData: PAnsiChar): Integer; stdcall;
var
  Exec: TKCPDaemonFunction;
begin
  Result := False;
  SetLenAndFill(ARecvData, 4096);

  @Exec := GetProcAddress(FDLLHandle, 'KCPDaemonFunction');
  if not Assigned(@Exec) then
  begin
    ARecvData := LIBKCP_SECURE_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Result := Exec(PAnsiChar(ASendData), Length(ASendData), @ARecvData[1]) > 0;
  Log.Write(ltDebug, ['KcpDaemon부가기능', Result, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanKcpDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := MakeSendDataCard(AInfo);
  if AInfo.EyCard then
    SendData := MakeSendDataHeader(AInfo.Approval, 'A02000', AInfo.TerminalID, SendData)
  else
    SendData := MakeSendDataHeader(AInfo.Approval, 'A01000', AInfo.TerminalID, SendData);

  if DLLExecTrans(SendData, RecvData) then
    Result := MakeRecvDataCard(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallCardInfo(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 요청구분
  SendData := '0100';
  // 업무구분
  SendData := SendData + 'R04000';
  // 단말기ID (데몬에서 다중사업자로 세팅된 경우 사용함.)
  SendData := SendData + Format('%-10.10s', [AInfo.TerminalID]);
  // 업체코드
  SendData := SendData + Format('%-4.4s', [KCP_VER_INFO]);
  // 포스 시리얼번호
  SendData := SendData + Format('%-16.16s', ['']);
  // 포스 제품명
  SendData := SendData + Format('%-12.12s', ['']);
  // 포스 S/W버전
  SendData := SendData + Format('%-4.4s', ['']);
  // 전문추적번호
  SendData := SendData + FormatFloat('000000', GetSeqNo) + FS;
  SendData := SendData + ETX;
  SendData := STX + FormatFloat('0000', Length(SendData)) + SendData;

  if DLLExecTrans(SendData, RecvData) then
  begin
    RecvData := StringSearch(RecvData, ETX, 0);
    // 응답코드
    Result.Result := StringSearch(RecvData, FS, 1) = '0000';
    Result.CardBinNo := StringSearch(RecvData, FS, 6);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallICCardInsertionCheck(const ATerminalID: string; const ASamsungPay: Boolean; out ARespCode, ARecvData: AnsiString): Boolean;
var
  SendData: AnsiString;
begin
  Result := False;
  Log.Write(ltInfo, ['IC카드 삽입여부 조회 요청', '']);
  ARespCode := '';
  ARecvData := '';
  SendData := IfThen(ASamsungPay, 'Y', 'N') + ETX;
  SendData := MakeSendDataHeader(True, 'R02000', ATerminalID, SendData);
  if DLLExecTrans(SendData, ARecvData) then
  begin
    // ETX까지 자른다.
    ARecvData := StringSearch(ARecvData, ETX, 0);
    // 카드 삽입상태 결과
    ARespCode := StringSearch(ARecvData, FS, 1);
    if (ARespCode = '0000') then
      Result := (StringSearch(ARecvData, FS, 5) = 'Y');
  end;
  ARecvData := Trim(ARecvData);
  Log.Write(ltInfo, ['응답', Result]);
end;

function TVanKcpDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := MakeSendDataCash(AInfo);
  SendData := MakeSendDataHeader(AInfo.Approval, 'C01000', AInfo.TerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
    Result := MakeRecvDataCash(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := '0' + FS +
              AInfo.KindCode + AInfo.CheckNo + AInfo.BankCode + AInfo.BranchCode + FS +
              CurrToStr(AInfo.SaleAmt) + FS +
              Copy(AInfo.RegDate, 3, 6) + FS +
              AInfo.AccountNo + FS +
              '' + ETX;
  SendData := MakeSendDataHeader(True, 'C06000', AInfo.TerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
    Result := MakeRecvDataCard(RecvData)
  else
  begin
    Result.Result := False;
    Result.Msg := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKcpDaemon.CallICReaderVerify(ATerminalID: string; out ARecvData: AnsiString): Boolean;
var
  SendData, RecvData: AnsiString;
begin
  Log.Write(ltInfo, ['무결성 점검 요청', '']);
  SendData := ETX;
  SendData := MakeSendDataHeader(True, 'F01000', ATerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
  begin
    // ETX까지 자른다.
    RecvData := StringSearch(RecvData, ETX, 0);
    // 응답코드
    Result := StringSearch(RecvData, FS, 1) = '0000';
    // 응답메세지
    ARecvData := StringSearch(RecvData, FS, 2) + StringSearch(RecvData, FS, 3) + StringSearch(RecvData, FS, 4) + StringSearch(RecvData, FS, 5);
    // 무결성점검 결과
    if Result then
      Result := StringSearch(RecvData, FS, 6) = '00';
  end
  else
  begin
    Result := False;
    ARecvData := Trim(RecvData);
  end;
  Log.Write(ltInfo, ['응답', Result]);
end;

function TVanKcpDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

function TVanKcpDaemon.DoPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  SendData := ABizNo + ETX; // 사업자번호
  SendData := MakeSendDataHeader(True, 'D01000', ATerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
  begin
    // ETX까지 자른다.
    RecvData := StringSearch(RecvData, ETX, 0);
    Result.Code := StringSearch(RecvData, FS, 1); // 응답코드
    Result.Result := Result.Code = '0000';
    Result.Msg := StringSearch(RecvData, FS, 2) + StringSearch(RecvData, FS, 3) + // 응답메세지
                  StringSearch(RecvData, FS, 4) + StringSearch(RecvData, FS, 5);
  end
  else
  begin
    Result.Result := False;
    Result.Code := Trim(RecvData);
  end;
end;

function TVanKcpDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 상호인증 (Key다운로드)
  SendData := ABizNo + ETX; // 사업자번호
  SendData := MakeSendDataHeader(True, 'F01001', ATerminalID, SendData);
  if DLLExecTrans(SendData, RecvData) then
  begin
    // ETX까지 자른다.
    RecvData := StringSearch(RecvData, ETX, 0);
    Result.Code := StringSearch(RecvData, FS, 1); // 응답코드
    Result.Result := Result.Code = '0000';
    Result.Msg := StringSearch(RecvData, FS, 2) + StringSearch(RecvData, FS, 3) + // 응답메세지
                  StringSearch(RecvData, FS, 4) + StringSearch(RecvData, FS, 5);
    // 상호인증 결과
    if Result.Result then
      Result.Result := StringSearch(RecvData, FS, 6) = '00';
  end
  else
  begin
    Result.Result := False;
    Result.Code := Trim(RecvData);
  end;
end;

{ TVanDaouDaemon }

constructor TVanDaouDaemon.Create;
begin
  inherited;
end;

destructor TVanDaouDaemon.Destroy;
begin
  inherited;
end;

function TVanDaouDaemon.ExecTcpSendData(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
var
  {$IF RTLVersion > 19.00}
  IdTCPClient: TIdTCPClient;
  ABuff: TIdBytes;
  {$ELSE}
  ClientSocket: TClientSocket;
  ABuff: array[1..2048] of AnsiChar;
  {$IFEND}
begin
  Result := False;
  IdTCPClient := nil;
  Log.Write(ltDebug, ['전송전문', ASendData]);
  try
    try
      {$IF RTLVersion > 19.00}
      IdTCPClient := TIdTCPClient.Create(nil);
      IdTCPClient.Host := '127.0.0.1';
      IdTCPClient.Port := 23738;
      IdTCPClient.ConnectTimeout := 3000;
      IdTCPClient.Connect;

      SetLength(ABuff, 0);
      if IdTCPClient.Connected then
      begin
        if Trim(ASendData) <> '' then
          IdTCPClient.IOHandler.Write(ASendData, IndyTextEncoding_OSDefault);
        IdTCPClient.IOHandler.ReadBytes(ABuff, -1, False);
        ARecvData := BytesToString(ABuff, IndyTextEncoding_OSDefault);
        Result := True;
      end
      else
        ARecvData := '모듈과 연결 실패!!!';
      {$ELSE}
      ClientSocket := TClientSocket.Create(nil);
      ClientSocket.Host := '127.0.0.1';
      ClientSocket.Port := 23738;
      ClientSocket.OnRead := ClientSocketRead;
      ClientSocket.Active := True;
      FReceiveBuff := '';
      Result := SocketSendReceiveData(ClientSocket, ASendData, ARecvData);
      {$IFEND}
    except on E: Exception do
      ARecvData := '모듈과의 통신중 에러 발생 ' + E.Message;
    end;
    Log.Write(ltDebug, ['통신결과', Result, '응답전문', ARecvData]);
  finally
    {$IF RTLVersion > 19.00}
    if Assigned(IdTCPClient) then
      IdTCPClient.Free;
    {$ELSE}
    ClientSocket.Free;
    {$IFEND}
  end;
end;

{$IF RTLVersion < 19.00}
procedure TVanDaouDaemon.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  FReceiveBuff := FReceiveBuff + Socket.ReceiveText;
end;

function TVanDaouDaemon.SocketSendReceiveData(AClientSocket: TClientSocket; ASendData: string; out ARecvData: string): Boolean;
const
  RECV_TIME_OUT = 60; // 60초
var
  GetTime: Cardinal;
begin
  Result := False;
  try
    GetTime := GetTickCount;
    // Connect 대기 (3초)
    while GetTime + (3 * 1000) > GetTickCount do
    begin
      Application.ProcessMessages;
      if AClientSocket.Socket.Connected then
        Break;
    end;
    if not AClientSocket.Socket.Connected then
    begin
      ARecvData := '모듈과 연결 실패!!!';
      Exit;
    end;

    if Trim(ASendData) <> '' then
      AClientSocket.Socket.SendText(ASendData);
    GetTime := GetTickCount;
    // 타임아웃 시간 동안 응답대기
    while GetTime + (RECV_TIME_OUT * 1000) > GetTickCount do
    begin
      Application.ProcessMessages;
      if FReceiveBuff <> '' then
      begin
        ARecvData := FReceiveBuff;
        Result := True;
        FReceiveBuff := '';
        Exit;
      end;
    end;
  except on E: Exception do
    begin
      Log.Write(ltError, ['SocketSendReceiveData', E.Message]);
      ARecvData := E.Message;
    end;
  end;
end;
{$IFEND}

function TVanDaouDaemon.GetErrorMsg(ACode: AnsiString): AnsiString;
begin
  if Copy(ACode, 1, 1) = '0' then
  begin
    case StrToIntDef(ACode, 0) of
       1: Result := 'POS 요청 전문 오류 (POS REQ Msg type error)';
       2: Result := 'VAN 응답 전문 오류 (VAN REP Msg type error)';
       3: Result := '비밀번호 입력 요망 (비밀번호가 필요한 거래임)';
       4: Result := '전자서명 입력 취소';
       9: Result := '통신 오류 (EOT recv error (미완료거래 처리))';
      10: Result := 'EOT 미수신 에러 (EOT 미수신후 R_tran 처리 완료)';
      11: Result := 'EOT 미수신 에러 (EOT 미수신후 R_tran 처리 오류)';
      12: Result := 'EOT 미수신 에러 (EOT 미수신후 R_tran 불필요 거래)';
      15: Result := '통신 오류 (ENQ recv error)';
      16: Result := '통신 오류 (ACK recv error)';
      17: Result := '데이터 수신 오류 (DATA recv error)';
      20: Result := '거래 중지 (거래 도중 중지 발생)';
      21: Result := '데이터 송신 오류 (send error)';
      22: Result := '통신 오류 (Socket select error)';
      23: Result := 'VAN Timeout (Socket select Timeout)';
      24: Result := '통신 오류 (Socket Recv error(Sock Close))';
      25: Result := '통신 오류 (Socket Recv timeout error)';
      26: Result := '소켓 생성 오류 (socket error ! (Connect_socket))';
      27: Result := '소켓 연결 오류 (connect error ! (Connect_socket))';
      28: Result := '소켓 연결 오류 (Create Socket Class error !)';
      31: Result := '내부 암호화 오류 (RSA_padding error)';
      32: Result := '내부 암호화 오류 (RSA error)';
      33: Result := '단말기 개시거래후 거래 요망 (StatPosCfg.ini 파일 존재하지 않음)';
      34: Result := '단말기 개시거래후 거래 요망 (SvkPosCfg.ini 파일생성오류)';
      35: Result := '단말기 개시거래후 거래 요망 (SvkPosCfg.ini 암호화키 오류)';
      36: Result := '단말기 개시거래후 거래 요망 (SvkPosCfg.ini 파일 내용 상이)';
      37: Result := '단말기 개시거래후 거래 요망 (SvkPosCfg.ini 파일 생성시 오류)';
      39: Result := '기타 오류';
      41: Result := 'ComPort Open error (전문에 표시된 ComPort로 연결 오류)';
      42: Result := 'Serial 연결 오류 (Serial 에 연결 오류)';
      43: Result := 'Serial Send 오류 (Serial 로 전문 전송 오류)';
      44: Result := 'Serial recv 오류 (Serial 로 전문 수신 오류)';
      45: Result := 'Serial recv data 오류 (Serial 로 전문 수신 DATA 에러)';
      46: Result := 'Serial Recv Timeout (Serial 응답 시간 초과)';
      47: Result := 'SignPad NAK 수신 (Serial 확인 요망)';
      48: Result := '단말기 개시거래후 거래 요망 (SignPad의 Sign Key가 없음 암호화키 갱신 필요)';
      49: Result := 'SignPad 확인 요망 (전자서명 길이 오류)';
      51: Result := 'SignPad 확인 요망 (PIN-PAD 기능이 없는 SignPad로 PIN 거래 불가 (V.2.0P 이상 버전 PIN 거래 가능))';
      52: Result := '단말기 개시거래후 거래 요망 (SignPad의 PIN-PAD Key가 없음 암호화키 갱신 필요)';
      53: Result := 'SignPAD 비밀번호 입력 취소';
      54: Result := 'SignPad 확인 요망 (데이터 입력 기능이 없는 SignPad로 데이터 입력 불가 (V.2.0P 이상 버전 데이터 입력 가능))';
      55: Result := 'Serial 확인 요망 (시리얼 연결 오류)';
      56: Result := 'Serial 확인 요망 (Did not create a serial-class)';
      64: Result := '카드리더기 포트 확인 요망 (ini파일의 리더기 포트번호 확인)';
      65: Result := '카드리더기 번호 오류 (단말기 개시거래후 거래 요망)';
      70: Result := 'IC카드거래유도 (IC카드인데 MS우선거래한경우)';
      98: Result := 'Serial 확인 요망 (시리얼 사용중)';
    else
      Result := ACode;
    end;
  end
  else
  begin
    if ACode = 'K001' then Result := '리더기 에러'
    else if ACode = 'K002' then Result := 'IC 카드 거래 불가'
    else if ACode = 'K003' then Result := 'M/S 카드 거래 불가'
    else if ACode = 'K004' then Result := 'Fall-Back 거래'
    else if ACode = 'K005' then Result := 'IC카드 삽입되어 있음'
    else if ACode = 'K006' then Result := '2nd Generate AC 에러'
    else if ACode = 'K007' then Result := '2nd Generate 과정에서 카드제거'
    else if ACode = 'K008' then Result := 'IC카드 리딩 과정에서 카드제거'
    else if ACode = 'K011' then Result := '리더기 KEY 다운로드 요망'
    else if ACode = 'K012' then Result := '리더기 Tamper 오류'
    else if ACode = 'K013' then Result := '상호인증 오류'
    else if ACode = 'K014' then Result := '암/복호화 오류'
    else if ACode = 'K015' then Result := '무결성 검사 실패'
    else if ACode = 'K101' then Result := '커맨드 전달 실패'
    else if ACode = 'K102' then Result := '키트로닉스 모듈 Time Out'
    else if ACode = 'K901' then Result := '카드사 파라미터 데이터 오류'
    else if ACode = 'K902' then Result := '카드사 파라미터 반영 불가'
    else if ACode = 'K990' then Result := '사용자 취소'
    else if ACode = 'K997' then Result := '리더기 데이터 이상'
    else if ACode = 'K998' then Result := '카드입력대기시간 초과'
    else if ACode = 'K999' then Result := '전문 오류'
    else if ACode = 'K081' then Result := '카드입력요청'
    else if ACode = 'K082' then Result := '처리 불가 상태'
    else if ACode = 'S000' then Result := '외부 서명 데이터 입력'
    else if ACode = 'S100' then Result := '외부 서명 데이터 입력 성공'
    else if ACode = 'S001' then Result := '외부 서명 데이터 입력 실패'
    else if ACode = 'S111' then Result := '외부 서명 데이터 입력'
    else if ACode = 'S002' then Result := '서명 데이터 입력 취소'
    else if ACode = 'S052' then Result := '신용 카드 거래 취소'
    else if ACode = 'S053' then Result := '현금 영수증 거래 취소'
    else if ACode = 'S054' then Result := '현금 IC 거래 취소'
    else if ACode = 'C001' then Result := 'DaouVP 상태 체크 진행 중'
    else Result := ACode;
  end;
end;

function TVanDaouDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanDaouDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 화면 서명 기능을 사용하는 경우
  if AInfo.SignOption = 'T' then
  begin
    SendData := 'K100' +                               // 전문번호
                Format('%-8.8s', [AInfo.TerminalID]) + // 단말기번호
                CurrToStrRPad(AInfo.SaleAmt, 12) +     // 거래금액
                '1';                                   // 입력요청구분
    if ExecTcpSendData(SendData, RecvData) then
    begin
      // 폴백 상태이면 카드 스와이핑 응답 대기
      if RecvData = 'K004' then
      begin
        if not ExecTcpSendData('', RecvData) then
        begin
          Result.Result := False;
          Result.Msg := RecvData;
          Exit;
        end;
      end;
    end
    else
    begin
      Result.Result := False;
      Result.Msg := RecvData;
      Exit;
    end;
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000') or (Result.Code = 'K110') or (Result.Code = 'S000');
    if not Result.Result then
    begin
      Result.Msg := GetErrorMsg(Result.Code);
      Exit;
    end;
  end;

  // 전문을 만든다.
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.OrgAgreeDate = '' then
    AInfo.OrgAgreeDate := FormatDateTime('yyyymmdd', Now);

  SendData := IfThen(AInfo.Approval, '0100', '0400') +                             // 전문번호
              IfThen(AInfo.EyCard, '17', '10') +                                   // 업무코드
              Format('%-8.8s', [AInfo.TerminalID]) +                               // 단말기번호
              '0000' +                                                             // 전표번호
              IfThen(Trim(AInfo.Reserved1) = '', TERMINAL_GUBUN1, TERMINAL_GUBUN2) + // 단말기정보
              FormatFloat('00', AInfo.HalbuMonth) +                                // 할부개월
              CurrToStrRPad(AInfo.SaleAmt, 12) +                                   // 거래금액
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.SvcAmt, 0), 12) +         // 봉사료
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.VatAmt, 0), 12) +         // 세금
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.FreeAmt, 0), 12) +        // 비과세
              Format('%-8.8s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeDate)]) + // 원승인일자
              Format('%-12.12s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo)]) + // 원승인번호
              Space(42) +                                                          // 가맹점데이타
              IfThen(Trim(AInfo.Reserved1) = '', '', Trim(AInfo.Reserved1));       // 부사업자 TID
  // 전문 전송
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // 응답코드
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // 응답메세지
      Result.Msg := Trim(Copy(RecvData, 171, 67)) + Trim(Copy(RecvData, 270, 1024));
      // 승인번호
      Result.AgreeNo := Trim(Copy(RecvData, 69, 12));
      // 승인일시 (yyyymmddhhnnss)
      Result.AgreeDateTime := Copy(RecvData, 43, 14);
      // 거래번호
      Result.TransNo := Copy(RecvData, 57, 12);
      // 발급사코드
      Result.BalgupsaCode := '';
      // 발급사명
      Result.BalgupsaName := Trim(Copy(RecvData, 81, 19));
      // 매입사코드
      Result.CompCode := Trim(Copy(RecvData, 101, 3));
      // 매입사명
      Result.CompName := Trim(Copy(RecvData, 104, 16));
      // 가맹점번호
      Result.KamaengNo := Trim(Copy(RecvData, 120, 15));
      // 승인금액
      Result.AgreeAmt := StrToIntDef(Trim(Copy(RecvData, 159, 12)), 0);
      // 할인금액
      Result.DCAmt := 0;
      // 마스킹된 카드번호
      Result.CardNo := Trim(Copy(RecvData, 136, 23));
      // 정상 서명 여부
      Result.IsSignOK := True;
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData, Gubun: AnsiString;
begin
  // 원거래일자
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.OrgAgreeDate = '' then
    AInfo.OrgAgreeDate := FormatDateTime('yyyymmdd', Now);
  // 거래구분
  if AInfo.Person = 3 then
    Gubun := IfThen(AInfo.Approval, '3 ', 'E ')
  else if AInfo.Person = 2 then
    Gubun := IfThen(AInfo.Approval, '2 ', 'B ')
  else
    Gubun := IfThen(AInfo.Approval, '1 ', 'A ');

  // 전문을 만든다.
  SendData := IfThen(AInfo.Approval, '0200', '0420') +                             // 전문번호
              '40' +                                                               // 업무코드
              Format('%-8.8s', [AInfo.TerminalID]) +                               // 단말기번호
              '0000' +                                                             // 전표번호
              IfThen(Trim(AInfo.Reserved1) = '', TERMINAL_GUBUN1, TERMINAL_GUBUN2) + // 단말기정보
              Gubun +                                                              // 거래구분
              CurrToStrRPad(AInfo.SaleAmt, 12) +                                   // 거래금액
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.SvcAmt, 0), 12) +         // 봉사료
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.VatAmt, 0), 12) +         // 세금
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.FreeAmt, 0), 12) +        // 비과세
              Format('%-8.8s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeDate)]) + // 원승인일자
              Format('%-12.12s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo)]) + // 원승인번호
              Format('%-1.1s', [IntToStr(AInfo.CancelReason)]) +                   // 취소사유코드
              IfThen(AInfo.KeyInput, '1', '0') +                                   // KeyIn코드 (0:카드, 1:서명패드, 2:별도입력)
              Format('%-30.30s', [AInfo.CardNo]) +                                 // 사용자정보
              Space(42) +                                                          // 가맹점데이타
              IfThen(Trim(AInfo.Reserved1) = '', '', Trim(AInfo.Reserved1));       // 부사업자 TID
  // 전문 전송
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // 응답코드
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // 응답메세지
      Result.Msg := Trim(Copy(RecvData, 188, 67)) + Trim(Copy(RecvData, 287, 1024));
      // 승인번호
      Result.AgreeNo := Trim(Copy(RecvData, 69, 12));
      // 승인일시 (yyyymmddhhnnss)
      Result.AgreeDateTime := Copy(RecvData, 43, 14);
      // 거래번호
      Result.TransNo := Copy(RecvData, 57, 12);
      // 승인금액
      Result.AgreeAmt := StrToIntDef(Trim(Copy(RecvData, 104, 12)), 0);
      // 할인금액
      Result.DCAmt := 0;
      // 마스킹된 카드번호
      Result.CardNo := Trim(Copy(RecvData, 81, 23));
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 전문을 만든다.
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.OrgAgreeDate = '' then
    AInfo.OrgAgreeDate := FormatDateTime('yyyymmdd', Now);

  SendData := IfThen(AInfo.Approval, '0100', '0400') +                             // 전문번호
              '50' +                                                               // 업무코드
              Format('%-8.8s', [AInfo.TerminalID]) +                               // 단말기번호
              '0000' +                                                             // 전표번호
              IfThen(Trim(AInfo.Reserved1) = '', TERMINAL_GUBUN1, TERMINAL_GUBUN2) + // 단말기정보
              CurrToStrRPad(AInfo.SaleAmt, 12) +                                   // 거래금액
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.SvcAmt, 0), 12) +         // 봉사료
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.VatAmt, 0), 12) +         // 세금
              CurrToStrRPad(IfThen(AInfo.Approval, AInfo.FreeAmt, 0), 12) +        // 비과세
              Format('%-8.8s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeDate)]) + // 원승인일자
              Format('%-12.12s', [IfThen(AInfo.Approval, '', AInfo.OrgAgreeNo)]) + // 원승인번호
              IfThen(AInfo.Approval, '1', '2') +                                   // 조회구분
              ' ' +                                                                // 취소구분
              Space(42) +                                                          // 가맹점데이타
              IfThen(Trim(AInfo.Reserved1) = '', '', Trim(AInfo.Reserved1));       // 부사업자 TID
  // 전문 전송
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // 응답코드
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // 응답메세지
      Result.Msg := Trim(Copy(RecvData, 182, 67)) + Trim(Copy(RecvData, 281, 1024));
      // 승인번호
      Result.AgreeNo := Trim(Copy(RecvData, 69, 12));
      // 승인일시 (yyyymmddhhnnss)
      Result.AgreeDateTime := Copy(RecvData, 43, 14);
      // 거래번호
      Result.TransNo := Copy(RecvData, 57, 12);
      // 발급사코드
      Result.BalgupsaCode := '';
      // 발급사명
      Result.BalgupsaName := Trim(Copy(RecvData, 81, 19));
      // 매입사코드
      Result.CompCode := Trim(Copy(RecvData, 101, 3));
      // 매입사명
      Result.CompName := Trim(Copy(RecvData, 104, 16));
      // 가맹점번호
      Result.KamaengNo := Trim(Copy(RecvData, 120, 15));
      // 승인금액
      Result.AgreeAmt := StrToIntDef(Trim(Copy(RecvData, 158, 12)), 0);
      // 할인금액
      Result.DCAmt := 0;
      // 마스킹된 카드번호
      Result.CardNo := Trim(Copy(RecvData, 135, 23));
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  if Length(AInfo.RegDate) = 6 then
    AInfo.RegDate := '20' + AInfo.RegDate;

  // 전문을 만든다.
  SendData := '0200' +                                            // 전문번호
              '15' +                                              // 업무코드
              Format('%-8.8s', [AInfo.TerminalID]) +              // 단말기번호
              '0000' +                                            // 전표번호
              TERMINAL_GUBUN1 +                                   // 단말기정보
              'K' +                                               // WCC (K:키인)
              Format('%-8.8s', [LeftStr(AInfo.CheckNo, 8)]) +     // 수표번호
              Format('%-2.2s', [LeftStr(AInfo.BankCode, 2)]) +    // 은행코드
              Format('%-4.4s', [LeftStr(AInfo.BranchCode, 4)]) +  // 발행점코드
              Format('%-2.2s', [LeftStr(AInfo.KindCode, 2)]) +    // 권종코드
              CurrToStrRPad(AInfo.SaleAmt, 12) +                  // 수표금액
              Format('%-8.8s', [LeftStr(AInfo.RegDate, 8)]) +     // 발행일자
              Format('%-12.12s', [LeftStr(AInfo.AccountNo, 12)]); // 계좌일련번호
  // 전문 전송
  if ExecTcpSendData(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 1, 4));
    Result.Result := (Result.Code = '1000') or (Result.Code = '2000');
    if Result.Result then
    begin
      // 응답코드
      Result.Code := Trim(Copy(RecvData, 23, 4));
      Result.Result := Result.Code = '0000';
      // 응답메세지
      Result.Msg := Trim(Copy(RecvData, 116, 67));
    end
    else
      Result.Msg := GetErrorMsg(Result.Code);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanDaouDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

{ TVanKovanDaemon }

constructor TVanKovanDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary('C:\KOVAN\' + KOVAN_DAEMON_DLL);
end;

destructor TVanKovanDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanKovanDaemon.DLLExec(ATCode, ATID, AHalbu, ATAmt, AOriDate, AOriAuthNo, ATranSerial, AIdNo, AAmtFlag, ATaxAmt, ASfeeAmt, AFreeAmt, AFiller: AnsiString;
                                 out ARecvTranType, ARecvErrCode, ARecvCardno, ARecvHalbu, ARecvTamt, ARecvTranDate, ARecvTranTime, ARecvAuthNo, ARecvMerNo, ARecvTranSerial,
                                 ARecvIssueCard, ARecvPurchaseCard, ARecvSignPath, ARecvMsg1, ARecvMsg2, ARecvMsg3, ARecvMsg4, ARecvFiller: AnsiString): Boolean;
type
  TKovan_Auth = function(tcode, tid, halbu, tamt, ori_date, ori_authno, tran_serial, idno, amt_flag, tax_amt, sfee_amt, free_amt, filler,
                         rTranType, rErrCode, rCardno, rHalbu, rTamt, rTranDate, rTranTime, rAuthNo, rMerNo, rTranSerial,
                         rIssueCard, rPurchaseCard, rSignPath, rMsg1, rMsg2, rMsg3, rMsg4, rFiller: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TKovan_Auth;
begin
  Result := False;

  @Exec := GetProcAddress(FDLLHandle, 'Kovan_Auth');
  if not Assigned(@Exec) then
  begin
    ARecvMsg1 := KOVAN_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  SetLenAndFill(ARecvTranType, 4);
  SetLenAndFill(ARecvErrCode, 4);
  SetLenAndFill(ARecvCardno, 18);
  SetLenAndFill(ARecvHalbu, 2);
  SetLenAndFill(ARecvTamt, 9);
  SetLenAndFill(ARecvTranDate, 6);
  SetLenAndFill(ARecvTranTime, 6);
  SetLenAndFill(ARecvAuthNo, 12);
  SetLenAndFill(ARecvMerNo, 15);
  SetLenAndFill(ARecvTranSerial, 12);
  SetLenAndFill(ARecvIssueCard, 30);
  SetLenAndFill(ARecvPurchaseCard, 30);
  SetLenAndFill(ARecvSignPath, 50);
  SetLenAndFill(ARecvMsg1, 100);
  SetLenAndFill(ARecvMsg2, 100);
  SetLenAndFill(ARecvMsg3, 100);
  SetLenAndFill(ARecvMsg4, 100);
  SetLenAndFill(ARecvFiller, 102);

  Ret := Exec(PAnsiChar(ATCode), PAnsiChar(ATID), PAnsiChar(AHalbu), PAnsiChar(ATAmt), PAnsiChar(AOriDate), PAnsiChar(AOriAuthNo), PAnsiChar(ATranSerial),
              PAnsiChar(AIdNo), PAnsiChar(AAmtFlag), PAnsiChar(ATaxAmt), PAnsiChar(ASfeeAmt), PAnsiChar(AFreeAmt), PAnsiChar(AFiller),
              @ARecvTranType[1], @ARecvErrCode[1], @ARecvCardno[1], @ARecvHalbu[1], @ARecvTamt[1], @ARecvTranDate[1], @ARecvTranTime[1], @ARecvAuthNo[1],
              @ARecvMerNo[1], @ARecvTranSerial[1], @ARecvIssueCard[1], @ARecvPurchaseCard[1], @ARecvSignPath[1], @ARecvMsg1[1], @ARecvMsg2[1],
              @ARecvMsg3[1], @ARecvMsg4[1], @ARecvFiller[1]);
  Result := Ret = 0;
  if not Result then
  begin
    case Ret of
       -2: ARecvMsg1 := '프로그램 통신 접속 실패';
       -3: ARecvMsg1 := '프로그램 통신 전송 실패';
       -4: ARecvMsg1 := '프로그램 수신 준비 실패';
       -5: ARecvMsg1 := '프로그램 통신 수신 실패';
       -6: ARecvMsg1 := '거래구분오류';
       -7: ARecvMsg1 := '할부개월오류';
       -8: ARecvMsg1 := '취소시 원거래일오류';
       -9: ARecvMsg1 := '취소시 원승인번호 오류';
      -10: ARecvMsg1 := '거래일련번호 오류';
      -11: ARecvMsg1 := '수표조회정보 오류';
    else
      ARecvMsg1 := '기타 오류';
    end;
  end;
  Log.Write(ltDebug, ['DaemonDLL호출', Result, '리턴값', Ret, '리턴메세지', ARecvMsg1]);
end;

function TVanKovanDaemon.DoCallExec(ATCode, AHalbu: AnsiString; AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  IdNo: AnsiString;
  RecvTranType, RecvHalbu, RecvTamt, RecvTranDate, RecvTranTime, RecvSignPath,
  RecvMsg1, RecvMsg2, RecvMsg3, RecvMsg4, RecvFiller: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  // 수표조회시
  if ATCode = '40' then
    IdNo := Format('%-8.8s', [AInfo.CheckNo]) + Format('%-2.2s', [AInfo.BankCode]) +
            Format('%-4.4s', [AInfo.BranchCode]) + Format('%-6.6s', [AInfo.AccountNo]) + '00' + Space(11)
  else
    IdNo := '';

  if DLLExec(ATCode,                                       // 거래 구분
             Format('%-10.10s', [AInfo.TerminalID]),       // 단말기번호
             AHalbu,                                       // 할부기간
             FormatFloat('000000000', AInfo.SaleAmt),      // 승인금액
             IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])),  // 원거래일자
             IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])),             // 원거래승인번호
             FormatFloat('000000', GetSeqNo) + Space(6),   // 거래일련번호
             Format('%-33.33s', [IdNo]),                   // 식별번호
             Space(3),                                     // 미사용
             FormatFloat('000000000', AInfo.VatAmt),       // 세금(부가세)
             FormatFloat('000000000', AInfo.SvcAmt),       // 봉사료
             FormatFloat('000000000', AInfo.FreeAmt),      // 비과세
             Space(21) + IfThen(AInfo.SignOption = 'R', 'ZZ', '  ') + Format('%-10.10s', [AInfo.BizNo]) + Space(67), // filler(서명재사용, 다중사업자번호)
             RecvTranType,                                 // 전문구분
             Result.Code,                                  // 응답코드
             Result.CardNo,                                // 카드번호
             RecvHalbu,                                    // 할부개월
             RecvTamt,                                     // 승인금액
             RecvTranDate,                                 // 승인일자
             RecvTranTime,                                 // 승인시간
             Result.AgreeNo,                               // 승인번호
             Result.KamaengNo,                             // 가맹점번호
             Result.TransNo,                               // 거래일련번호
             Result.BalgupsaName,                          // 발급사명
             Result.CompName,                              // 매입사명
             RecvSignPath,                                 // 사인경로
             RecvMsg1,                                     // 메시지1
             RecvMsg2,                                     // 메시지2
             RecvMsg3,                                     // 메시지3
             RecvMsg4,                                     // 메시지4
             RecvFiller) then                              // Filler
  begin
    // 리턴값
    Result.Result := Result.Code = '0000';
    // 응답메세지
    Result.Msg := RecvMsg1 + RecvMsg2 + RecvMsg3 + RecvMsg4;
    // 승인일시 (yyyymmddhhnn)
    Result.AgreeDateTime := '20' + RecvTranDate + RecvTranTime;
    // 발급사코드
    Result.BalgupsaCode := Trim(Copy(RecvFiller, 1, 2));
    // 매입사코드
    Result.CompCode := Trim(Copy(RecvFiller, 3, 2));
    // 승인금액
    Result.AgreeAmt := StrToIntDef(RecvTamt, 0);
    // 할인금액
    Result.DCAmt := 0;
    // 정상 서명 여부
    Result.IsSignOK := RecvSignPath <> '';
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvMsg1;
  end;
end;

function TVanKovanDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKovanDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  TCode: AnsiString;
begin
  if AInfo.EyCard then
    TCode := IfThen(AInfo.Approval, 'E0', 'E1')
  else
    TCode := IfThen(AInfo.Approval, 'S0', 'S1');

  Result := DoCallExec(TCode, FormatFloat('00', AInfo.HalbuMonth), AInfo);
end;

function TVanKovanDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  Halbu: AnsiString;
begin
  if AInfo.Approval then
    Halbu := IfThen(AInfo.Person = 1, '00', '01')
  else
    Halbu := FormatFloat('0', AInfo.CancelReason) + IfThen(AInfo.Person = 1, '00', '01');

  Result := DoCallExec(IfThen(AInfo.Approval, '41', '42'), Halbu, AInfo);
end;

function TVanKovanDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result.Result := False;
  Result.Msg := '해당 기능 제공하지 않음.';
end;

function TVanKovanDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
begin
  Result := DoCallExec('40', AInfo.KindCode, AInfo);
end;

function TVanKovanDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 제공하지 않음.';
end;

{ TVanSpcDaemon }

constructor TVanSpcDaemon.Create;
begin
  inherited;
  FDLLHandle := LoadLibrary(SPC_DAEMON_DLL);
end;

destructor TVanSpcDaemon.Destroy;
begin
  FreeLibrary(FDLLHandle);
  inherited;
end;

function TVanSpcDaemon.DLLExec(ASendData: AnsiString; out ARecvData: AnsiString): Boolean;
type
  TSpcnVirtualPosS = function(AServerIP: PAnsiChar; AServerPort: Integer; AInputData: PAnsiChar; AOutputData: PAnsiChar): Integer; stdcall;
var
  Ret: Integer;
  Exec: TSpcnVirtualPosS;
begin
  Result := False;
  SetLenAndFill(ARecvData, 2048);

  @Exec := GetProcAddress(FDLLHandle, 'SpcnVirtualPosS');
  if not Assigned(@Exec) then
  begin
    ARecvData := SPC_DAEMON_DLL + MSG_ERR_DLL_LOAD;
    Exit;
  end;

  Ret := Exec('127.0.0.1', 19011, PAnsiChar(ASendData), @ARecvData[1]);
  Result := Ret > 0;
  if not Result then
    ARecvData := GetErrorMsg(Ret);
  Log.Write(ltDebug, ['DaemonDLL호출', Result, '리턴값', Ret, 'SendData', ASendData, 'RecvData', ARecvData]);
end;

function TVanSpcDaemon.GetErrorMsg(ACode: Integer): AnsiString;
begin
  case ACode of
    -11 : Result := '요청전문 오류 (STX)';
    -12 : Result := '요청전문 오류 (ETX)';
    -13 : Result := '요청전문 오류 (미지원 전문)';
    -14 : Result := '서버 요청전문생성 오류';
    -15 : Result := 'IC리더기 요청전문생성 오류';
    -16 : Result := '거래금액 오류';
    -17 : Result := '등록제 정보 수신 오류 (IC리더기)';
    -18 : Result := '키인정보 수신 오류';
    -19 : Result := '카드 삽입상태 오류 (IC리더기)';
    -20 : Result := '카드 정보 응답 오류 (IC리더기)';
    -21 : Result := '카드 정보 수신 오류 (IC리더기)';
    -22 : Result := '전자서명 수신 오류 (서명패드)';
    -23 : Result := '비밀번호 수신 오류 (서명패드)';
    -24 : Result := '서버 요청전문생성 오류';
    -25 : Result := '서버 요청전문생성 오류';
    -26 : Result := '서버 요청전문생성 오류';
    -27 : Result := '카드번호 암호화 거절';
    -28 : Result := '카드번호 암호화 오류';
    -29 : Result := 'Pos Entry Mode 오류';
    -30 : Result := '거래매체 유형 오류';
    -31 : Result := '거래유형코드 오류';
    -32 : Result := '키인정보 수신 오류';
    -33 : Result := '키인정보 입력 오류';
    -35 : Result := 'VAN 서버 통신 오류';
    -36 : Result := '발급사 인증 오류 - 망취소 처리됨';
    -37 : Result := '발급사 인증 오류 - 망취소 처리됨';
    -39 : Result := '암호화 데이터 복호화 오류';
    -40 : Result := '개시거래 요망';
    -41 : Result := '리더기 식별번호 오류 (IC리더기)';
    -42 : Result := '리더기 식별번호 오류 (RF후불카드)';
    -44 : Result := '바코드리더기 데이터 수신 오류';
    -50 : Result := '바코드리더기 수신 오류';
    -51 : Result := '신용요청 미지원 코드 수신 오류';
    -52 : Result := '카드 정보 수신 오류 (RF후불카드)';
    -53 : Result := '등록제 정보 수신 오류 (RF후불카드)';
    -54 : Result := 'RF후불카드 사용여부 오류 (환경설정 오류)';
    -55 : Result := 'RF후불카드 사용여부 오류 (무결성 오류)';
    -56 : Result := 'RF리더기 요청전문생성 오류';
    -57 : Result := 'RF리더기 설정 오류';
    -61 : Result := '망취소 전문 없음';
    -62 : Result := '망취소 대상 아님 (요청전문 없음)';
    -63 : Result := '망취소 대상 아님 (정상승인건 아님)';
    -64 : Result := '망취소 인증정보 누락 오류';
    -65 : Result := '망취소 응답오류 (카드사 확인 요망)';
    -66 : Result := '망취소 요청 검증 오류';
    -67 : Result := '망취소 오류';
    -1001 : Result := 'Socket Connect Error (connect)';
    -1002 : Result := 'Socket Connect Error (ioctlsocket)';
    -1003 : Result := 'Socket Connect Error (select)';
    -1004 : Result := 'Socket Connect Error (select)';
    -1005 : Result := 'Socket Recv Error (select)';
    -1006 : Result := 'Socket Recv Error (select)';
    -1007 : Result := 'Socket Recv Error (recv)';
    -1008 : Result := 'Socket Recv Error (recv len)';
    -1009 : Result := 'Socket Recv Error (send)';
    -1010 : Result := '가상단말기 연결 실패';
    -1011 : Result := '가상단말기 연결 메시지 미수신(ENQ 미수신)';
    -1012 : Result := '가상단말기 연결 메시지 오류(ENQ 미수신)';
    -1013 : Result := '가상단말기 요청전문 송신 오류';
    -1014 : Result := '가상단말기 응답전문 길이 수신 오류';
    -1015 : Result := '가상단말기 응답전문 길이 데이터 오류';
    -1016 : Result := '가상단말기 응답전문 길이 데이터 변환 오류';
    -1017 : Result := '가상단말기 응답전문 데이터 수신 오류';
    -1018 : Result := '가상단말기 오류 메시지 수신';
    -1019 : Result := '가상단말기 EOT 송신 오류';
    -1020 : Result := '가상단말기 ACK 수신 실패';
    -1021 : Result := '가상단말기 ACK 데이터 오류';
    -1030 : Result := '가상단말기 요청전문 생성 오류';
    -1031 : Result := '가상단말기 포트설정 통신 오류';
    -1032 : Result := '가상단말기 포트설정 응답 오류';
    -1040 : Result := '가상단말기 전자서명 데이터 수신 오류';
    -1042 : Result := '(*) IC리더기 초기화 오류';
    -1043 : Result := '(*) IC리더기 키다운로드 오류';
    -1044 : Result := '(*) IC리더기 미지원 오류';
    -1045 : Result := '(*) IC리더기 시간설정 오류';
    -1046 : Result := '(*) IC리더기 상태읽기 오류';
    -1047 : Result := '(*) IC리더기 무결성 오류';
    -1048 : Result := '(*) IC리더기 카드BIN정보 수신 오류';
    -1052 : Result := '(*) RF리더기 초기화 오류';
    -1053 : Result := '(*) RF리더기 키다운로드 오류';
    -1054 : Result := '(*) RF리더기 미지원 오류';
    -1055 : Result := '(*) RF리더기 시간설정 오류';
    -1056 : Result := '(*) RF리더기 상태읽기 오류';
    -1057 : Result := '(*) RF리더기 무결성 오류';
    -1058 : Result := '(*) RF리더기 SAM등록 오류';
  else
    Result := '기타 오류';
  end;
end;

function TVanSpcDaemon.CallPosDownload(ATerminalID, ABizNo: AnsiString): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  // 1. 가맹점 다운로드(개시거래)를 한다.
  SendData := 'DN' +
              Format('%-10.10s', [ATerminalID]) + // 단말기번호
              Format('%-10.10s', [ABizNo]);       // 사업자번호
  if DLLExec(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
    Exit;
  end;

  // 2. 상호인증을 한다.
  SendData := 'I1' +
              Format('%-10.10s', [ATerminalID]) + // 단말기번호
              Space(64);
  if DLLExec(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCard(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
  Sign: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  // 서명 옵션
  if AInfo.SignOption = 'N' then
    Sign := 'C'
  else if AInfo.SignOption = 'R' then
    Sign := 'M'
  else
    Sign := ' ';
  // 전문을 만든다.
  SendData := IfThen(AInfo.Approval, 'S0', 'S1') +          // 승인/취소 구분
              Format('%-10.10s', [AInfo.TerminalID]) +      // 단말기번호
              FormatFloat('00', AInfo.HalbuMonth) +         // 할부기간
              FormatFloat('000000000', AInfo.SaleAmt) +     // 승인금액
              FormatFloat('000000000', AInfo.SvcAmt) +      // 봉사료
              FormatFloat('000000000', AInfo.VatAmt) +      // 세금(부가세)
              IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])) +            // 원거래승인번호
              IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])) + // 원거래승인일자
              IfThen(Trim(AInfo.Reserved1) = '', Space(6), 'MUL#  ') + // 다중 사업자 구분
              Sign +                                        // 서명 옵션 (M: 직전 서명 사용, C: 서명 미사용, ' ': 기본설정)
              IfThen(AInfo.EyCard, 'Y', ' ') +              // 특수카드 여부
              Space(12) +                                   // 추가정보
              Space(8) +                                    // 업체정보
              Space(6) +                                    // 전문번호
              Space(6) +                                    // 상품코드
              Space(1) +                                    // 전자상거래 보안등급
              Space(13) +                                   // 사용자정보
              Space(40);                                    // 도메인
  // DLL 호출한다.
  if DLLExec(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
    // 응답메세지
    Result.Msg := Trim(Copy(RecvData, 114, 128));
    // 승인번호
    Result.AgreeNo := Trim(Copy(RecvData, 49, 12));
    // 승인일시 (yyyymmddhhnn)
    Result.AgreeDateTime := '20' + Copy(RecvData, 39, 10);
    // 거래번호
    Result.TransNo := '';
    // 발급사코드
    Result.BalgupsaCode := Trim(Copy(RecvData, 77, 2));
    // 발급사명
    Result.BalgupsaName := Trim(Copy(RecvData, 61, 16));
    // 매입사코드
    Result.CompCode := Trim(Copy(RecvData, 95, 2));
    // 매입사명
    Result.CompName := Trim(Copy(RecvData, 79, 16));
    // 가맹점번호
    Result.KamaengNo := Trim(Copy(RecvData, 97, 15));
    // 승인금액
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    // 할인금액
    Result.DCAmt := 0;
    // 마스킹된 카드번호
    Result.CardNo := Trim(Copy(RecvData, 19, 20));
    // 정상 서명 여부
    Result.IsSignOK := True;
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCash(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
  Gubun: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  if AInfo.Person = 3 then
    Gubun := '02'
  else if AInfo.Person = 2 then
    Gubun := '01'
  else
    Gubun := '00';
  // 전문을 만든다.
  SendData := IfThen(AInfo.Approval, 'C0', 'C1') +          // 승인/취소 구분
              Format('%-10.10s', [AInfo.TerminalID]) +      // 단말기번호
              Gubun +                                       // 현금거래구분(소득공제,지출증빙,자진발급)
              FormatFloat('000000000', AInfo.SaleAmt) +     // 승인금액
              FormatFloat('000000000', AInfo.SvcAmt) +      // 봉사료
              FormatFloat('000000000', AInfo.VatAmt) +      // 세금(부가세)
              IfThen(AInfo.Approval, Space(12), Format('%-12.12s', [AInfo.OrgAgreeNo])) +            // 원거래승인번호
              IfThen(AInfo.Approval, Space(6), Format('%-6.6s', [Copy(AInfo.OrgAgreeDate, 3, 6)])) + // 원거래승인일자
              FormatFloat('0', AInfo.CancelReason) +        // 취소사유코드
              IfThen(Trim(AInfo.Reserved1) = '', Space(67), 'MUL#' + Space(63)) + // 다중 사업자 구분
              'A' +                                         // KeyIn 여부 (A:모든 거래 수단으로 가상 단말기가 처리함, Y:키인거래, I:POS입력, 그외:MS우선거래)
              Space(12) +                                   // 추가정보
              Space(8) +                                    // 업체정보
              Space(6) +                                    // 전문번호
              Space(6) +                                    // 상품코드
              Space(2) +                                    // 가맹점사용ID
              Space(30) +                                   // 가맹점사용필드
              Space(18);                                    // KeyIn정보
  // DLL 호출한다.
  if DLLExec(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
    // 응답메세지
    Result.Msg := Trim(Copy(RecvData, 61, 128));
    // 승인번호
    Result.AgreeNo := Trim(Copy(RecvData, 49, 12));
    // 승인일시 (yyyymmddhhnn)
    Result.AgreeDateTime := '20' + Copy(RecvData, 39, 10);
    // 승인금액
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    // 마스킹된 카드번호
    Result.CardNo := Trim(Copy(RecvData, 19, 20));
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCashIC(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  if Length(AInfo.OrgAgreeDate) = 6 then AInfo.OrgAgreeDate := '20' + AInfo.OrgAgreeDate;
  // 전문을 만든다.
  SendData := IfThen(AInfo.Approval, 'H0', 'H1') +          // 승인/취소 구분
              Format('%-10.10s', [AInfo.TerminalID]) +      // 단말기번호
              FormatFloat('000000000', AInfo.SaleAmt) +     // 승인금액
              FormatFloat('000000000', AInfo.SvcAmt) +      // 봉사료
              FormatFloat('000000000', AInfo.VatAmt) +      // 세금(부가세)
              IfThen(AInfo.Approval, Space(13), Format('%-13.13s', [AInfo.OrgAgreeNo])) + // 원거래승인번호
              IfThen(AInfo.Approval, Space(8), Format('%-8.8s', [AInfo.OrgAgreeDate])) + // 원거래승인일자
              'N';                                          // 간소화 거래여부(Y:간소화 비밀번호X, N:일반거래)
  // DLL 호출한다.
  if DLLExec(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 13, 1));
    Result.Result := Result.Code = 'O';
    // 응답메세지
    Result.Msg := Trim(Copy(RecvData, 120, 64));
    // 승인번호
    Result.AgreeNo := Trim(Copy(RecvData, 61, 13));
    // 승인일시 (yyyymmddhhnn)
    Result.AgreeDateTime := Copy(RecvData, 49, 12);
    // 거래번호
    Result.TransNo := '';
    // 발급사코드
    Result.BalgupsaCode := Trim(Copy(RecvData, 90, 7));
    // 발급사명
    Result.BalgupsaName := Trim(Copy(RecvData, 74, 16));
    // 매입사코드
    Result.CompCode := Trim(Copy(RecvData, 113, 7));
    // 매입사명
    Result.CompName := Trim(Copy(RecvData, 97, 16));
    // 가맹점번호
    Result.KamaengNo := Trim(Copy(RecvData, 14, 15));
    // 승인금액
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
    // 할인금액
    Result.DCAmt := 0;
    // 마스킹된 카드번호
    Result.CardNo := Trim(Copy(RecvData, 29, 20));
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallCheck(AInfo: TCardSendInfoDM): TCardRecvInfoDM;
var
  SendData, RecvData: AnsiString;
begin
  if Length(AInfo.RegDate) = 6 then AInfo.RegDate := '20' + AInfo.RegDate;
  // 전문을 만든다.
  SendData := 'DK' +                                          // 수표조회
              Format('%-10.10s', [AInfo.TerminalID]) +        // 단말기번호
              Format('%-8.8s', [AInfo.CheckNo]) +             // 수표번호
              Format('%-2.2s', [AInfo.BankCode]) +            // 발행은행코드
              Format('%-4.4s', [AInfo.BranchCode]) +          // 발행영업점코드
              Format('%-2.2s', [AInfo.KindCode]) +            // 권종코드
              FormatFloat('0000000000', AInfo.SaleAmt) +      // 수표금액
              Format('%-6.6s', [Copy(AInfo.RegDate, 3, 6)]) + // 발행일
              Format('%-6.6s', [AInfo.AccountNo]);            // 계좌일련번호
  // DLL 호출한다.
  if DLLExec(SendData, RecvData) then
  begin
    // 에러코드
    Result.Code := Trim(Copy(RecvData, 13, 4));
    Result.Result := Result.Code = '0000';
    // 응답메세지
    Result.Msg := Trim(Copy(RecvData, 27, 64));
    // 승인금액
    Result.AgreeAmt := Trunc(AInfo.SaleAmt);
  end
  else
  begin
    Result.Result := False;
    Result.Msg := RecvData;
  end;
end;

function TVanSpcDaemon.CallPinPad(ASendAmt: Integer; out ARecvData: AnsiString): Boolean;
begin
  Result := False;
  ARecvData := '해당 기능 사용 불가.';
end;

end.
