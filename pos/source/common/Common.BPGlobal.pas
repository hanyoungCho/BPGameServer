unit Common.BPGlobal;

interface

uses
  { Native }
  System.Classes, System.SysUtils, WinApi.Windows, System.IniFiles, Data.DB, Vcl.Controls,
  Vcl.StdCtrls, Vcl.NumberBox,
  { WinSoft }
  ComPort,
  { VAN }
  uVanDaemonModule, uPaycoNewModule,
  { Plugin System }
  uPluginManager, uPluginMessages,
  { Project }
  Common.BPReceiptPrint, Common.BPLaneContainer, uIntegerList;

{$I Common.BPCommon.inc}

type
  { 기본 쓰레드 타이머 }
  {$M+}
  TBaseTimerThread = class(TThread)
  private
    FWorking: Boolean;
    FLastWorked: TDateTime;
    FLastWorkedWeather: TDateTime;
    FInterval: Integer;
    FCheckCount: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property Interval: Integer read FInterval write FInterval default 500;
    property LastWorked: TDateTime read FLastWorked write FLastWorked;
  end;
  {$M-}

  { Enumulation Type }
  TBPDataMode = (bdmView, bdmNew, bdmEdit, bdmList, bdmSelect); //0:상세조회, 1:등록, 2:수정, 3:목록조회, 4:목록선택
  TBPSearchModeMode = (bsmNone, bsmMemberNo, bsmMemberName, bsmTelNo, bsmCarNo); //0:없음, 1:회원번호, 2:회원명, 3:전화번호, 4:차량번호

  { Callback Procedure }
  TMainFormCallbackProc = reference to procedure(const ACommand: string; const AValue: Variant);
  TPluGroupChangeCallBackProc = reference to procedure(const AGroupIndex: Integer);
  TPluItemPageChangeCallBackProc = reference to procedure(const AGroupIndex, AItemPageIndex: Integer);

  { PLU 카테고리 정보 }
  PPluGroup = ^TPluGroup;
  TPluGroup = record
    ProdDiv: string;
    ProdDivName: string;
    ProdDetailDiv: string;
    ProdDetailDivName: string;
    ItemList: TList;
  end;

  { PLU 아이템 정보 }
  PPluItem = ^TPluItem;
  TPluItem = record
    //공통
    ProdDiv: string;
    ProdDetailDiv: string;
    ProdCode: string;
    ProdName: string;
    ProdAmt: Integer;
    TodayYN: Boolean;
    UseYN: Boolean;
    SaleZoneCode: string;
    //게임
    GameDiv: ShortInt;
    ApplyStartTime: string;
    ApplyEndTime: string;
    UseGameCount: Integer;
    UseGameMin: Integer;
    ExpireDay: string;
    //라커
    LockerLayerCode: string;
    LockerLayerName: string;
    SexDiv: Shortint;
    SexDivName: string;
  end;

  { 영수증 클래스 }
  TReceiptInfo = class
  private
    FSaleAmt: Integer;
    FDCAmt: Integer;
    FUsePoint: Integer;
    FCashPayAmt: Integer;
    FCardPayAmt: Integer;
    FChargeAmt: Integer;
    FCouponAmt: Integer;
    FKeepAmt: Integer;
    FPaycoReady: Boolean;
    FPendingReceiptNo: string;
    FSelectedReceiptNo: string;

    function GetReceiveAmt: Integer;
    function GetVAT: Integer;
    function GetChangeAmt: Integer;
    function GetUnPaidAmt: Integer;
  public
    SelectedReceiptNo: string; //판매관리에서 선택한 영수증번호(초기화 금지)
    SignImage: TMemoryStream;
    SaleMemo: string;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    property SaleAmt: Integer read FSaleAmt write FSaleAmt default 0; //판매금액
    property CashPayAmt: Integer read FCashPayAmt write FCashPayAmt default 0; //현금결제금액
    property CardPayAmt: Integer read FCardPayAmt write FCardPayAmt default 0; //카드결제금액
    property DCAmt: Integer read FDCAmt write FDCAmt default 0; //할인금액
    property UsePoint: Integer read FUsePoint write FUsePoint default 0; //포인트사용금액
    property CouponAmt: Integer read FCouponAmt write FCouponAmt default 0; //쿠폰사용금액
    property KeepAmt: Integer read FKeepAmt write FKeepAmt default 0; //보증금
    property PaycoReady: Boolean read FPaycoReady write FPaycoReady default False;
    property ReceiveAmt: Integer read GetReceiveAmt default 0; //받은금액
    property ChargeAmt: Integer read FChargeAmt write FChargeAmt default 0; //청구금액
    property VAT: Integer read GetVAT default 0; //부가세
    property ChangeAmt: Integer read GetChangeAmt default 0; //거스름돈
    property UnpaidAmt: Integer read GetUnpaidAmt default 0; //미결제금액
    property PendingReceiptNo: string read FPendingReceiptNo write FPendingReceiptNo; //보류영수증번호
  end;

  { 영수증 정보 }
  TReceiptItemInfo = record
    ReceiptNo: string;
    SaleAmt: Integer;
    DCAmt: Integer;
    UsePoint: Integer;
    CouponAmt: Integer;
    KeepAmt: Integer;
    VAT: Integer;
    ChargeAmt: Integer;
    ReceiveAmt: Integer;
    ChangeAmt: Integer;
    SaleMemo: string;
  public
    procedure Clear;
  end;

  { 상품 정보 }
  TProdItemRec = record
    Seq: Integer;
    AssignLaneNo: ShortInt;
    AssignNo: string;
    BowlerId: string;
    ProdCode: string;
    ProdDiv: string;
    ProdDetailDiv: string;
    ProdName: string;
    OrderQty: Integer;
    ProdAmt: Integer;
    DCAmt: Integer;
    UsePoint: Integer;
    IsService: Boolean;
    { 회원 정보 }
    MemberNo: string;
    MemberName: string;
    { 게임 상품용 }
    UseGameCount: ShortInt; //이용 횟수
    UseGameMin: Integer; //이용 시간(분)
    { 라커 상품용 }
    LockerNo: Integer;
    LockerName: string;
    KeepAmt: Integer;
    PurchaseMonth: ShortInt;
    UseStartDate: string;
  public
    procedure Clear;
  end;

  { 결제 정보 }
  TPaymentItemRec = record
    Seq: Integer;
    ReceiptNo: string;
    PaySeq: ShortInt;
    PayMethod: ShortInt; //결제 수단 (1:신용카드, 2:현금, 3:PAYCO신용카드...)
    IsApproval: Boolean; //승인 여부
    IsManualInput: Boolean; ///수기입력 여부
    VanCode: string; //VAN사코드
    TID: string; //VAN-TID
    ApproveNo: string; //승인번호
    ApproveAmt: Integer; //승인 금액
    OrgApproveNo: string; //원승인번호
    OrgApproveDate: string; //원거래일자
    VAT: Integer; //부가가치세
    InstallMonth: ShortInt; //할부 개월수
    CashEntity: ShortInt; //현금영수증 발급 주체 (1:개인, 2:사업자)
    CardNo: string; //카드번호
    TradeNo: string; //거래번호
    TradeDate: string; //거래일자
    IssuerCode: string; //발급사 코드
    ISsuerName: string; //발급사 명
    BuyerDiv: string; //매입사 구분
    BuyerCode: string; //매입사 코드
    BuyerName: string; //매입사 명
    PaymentMemo: string;
  public
    procedure Clear;
  end;

  { 수표 정보 }
  TChequeRec = record
    ChequeNo: string;
    ChequeAmt: Integer;
    KindCode: string;
    BankCode: string;
    BranchCode: string;
    AccountCode: string;
    AccountNo: string;
    RegDate: string;
  end;

  { PLU 정보 }
  TPluManager = class
  private
    FGroupItems: TList; //그룹 + 상품 정보
    FGroupPerPage: Integer; //페이지당 그룹 노출 수
    FItemPerPage: Integer; //페이지당 아이템 노출 수
    FActiveGroupPage: Integer; //현재 그룹 페이지 인덱스
    FActiveItemPage: Integer; //현재 상품 페이지 인덱스
    FCurrentGroupIndex: Integer; //선택된 그룹 인덱스
    FCurrentItemIndex: Integer; //선택된 상품 인덱스

    procedure SetGroup(const AGroupIndex: Integer; APointer: PPluGroup);
    function GetGroup(const AGroupIndex: Integer): PPluGroup;
    procedure SetItem(const AGroupIndex, AItemIndex: Integer; APointer: PPluItem);
    function GetItem(const AGroupIndex, AItemIndex: Integer): PPluItem;
    function GetGroupPageCount: Integer;
    function GetItemPageCount(const AGroupIndex: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function GetGroupCount: Integer;
    function GetItemCount(const AGroupIndex: Integer): Integer;
    function IndexOfGroupCode(const AProdDetailDiv: string): Integer;
    function IndexOfProdCode(const AGroupIndex: Integer; const AProdCode: string): Integer;
    function AddGroup(const AProdDetailDiv, AProdDetailDivName: string): Integer; //GroupIndex 반환
    function AddItem(const AGroupIndex: Integer; const AProdDiv, AProdCode: string): Integer; //ItemIndex 반환
    procedure ClearGroup;
    procedure ClearItems(const AGroupIndex: Integer);
    procedure SetGroupPage(const ANewGroupPage: Integer; ACallBackProc: TPluGroupChangeCallBackProc);
    procedure SetItemPage(const AGroupIndex, ANewItemPage: Integer; ACallBackProc: TPluItemPageChangeCallBackProc);

    property Group[const AGroupIndex: Integer]: PPluGroup read GetGroup write SetGroup;
    property Items[const AGroupIndex, AItemIndex: Integer]: PPluItem read GetItem write SetItem;
    property GroupPerPage: Integer read FGroupPerPage write FGroupPerPage default 0;
    property ItemPerPage: Integer read FItemPerPage write FItemPerPage default 0;
    property CurrentGroupIndex: Integer read FCurrentGroupIndex write FCurrentGroupIndex default -1;
    property CurrentItemIndex: Integer read FCurrentItemIndex write FCurrentItemIndex default -1;
    property ActiveGroupPage: Integer read FActiveGroupPage write FActiveGroupPage default -1;
    property ActiveItemPage: Integer read FActiveItemPage write FActiveItemPage default -1;
    property GroupPageCount: Integer read GetGroupPageCount;
    property ItemPageCount[const AGroupIndex: Integer]: Integer read GetItemPageCount;
  end;

  { 장치 설정 정보 }
  TCustomDeviceCallbackProc = reference to procedure(Sender: TObject);
  TCustomDeviceSetting = class
  private
    FEnabled: Boolean;
    FDeviceId: ShortInt;
    FComDevice: TComPort;
    FPort: ShortInt;
    FBaudrate: Integer;
    FOwnerId: ShortInt;
    FCopies: ShortInt; //출력 매수
    FReadData: AnsiString;
    FCallbackProc: TCustomDeviceCallbackProc;

    procedure SetOwnerId(const AValue: ShortInt);
    procedure ComDeviceOnRxChar(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Close;
    procedure Open(AProc: TCustomDeviceCallbackProc=nil);

    property Enabled: Boolean read FEnabled write FEnabled default False;
    property DeviceId: ShortInt read FDeviceId write FDeviceId;
    property ComDevice: TComPort read FComDevice write FComDevice;
    property Port: ShortInt read FPort write FPort default 0;
    property Baudrate: Integer read FBaudrate write FBaudrate default 9600;
    property OwnerId: ShortInt read FOwnerId write SetOwnerId default 0;
    property Copies: ShortInt read FCopies write FCopies default 1;
    property ReadData: AnsiString read FReadData write FReadData;
  end;

  { 프로그램 정보 }
  TAppInfoRec = record
    AppName: string;
    ProductVersion: string;
    FileVersion: string;
    Handle: HWND;
    PluginContainer: TWinControl;
  end;

  { 알리미 정보 }
  TAdminCallRec = record
    Handle: HWND;
    FileName: string;
    AutoRun: Boolean;
  end;

  { 사용자 정보 }
  TUserInfoRec = record
    UserId: string;
    UserName: string;
    TerminalPwd: string;
    SaveId: Boolean;
    Logged: Boolean;
    LastLogged: string;
  end;

  { 경로 설정 정보 }
  TDirInfoRec = record
    HomeDir: string;
    PluginDir: string;
    DataDir: string;
    ConfigDir: string;
    ContentsDir: string;
    DownloadDir: string;
    LogDir: string;
    MediaDir: string;
    WebCacheDir: string;
  end;

  { 시각 정보 }
  TDateTimeInfoRec = record
    { 금일 }
    CurrentDate: string; // yyyymmdd
    FormattedCurrentDate: string; // yyyy-mm-dd
    CurrentTime: string; // hhnnss
    FormattedCurrentTime: string; // hh:nn:ss
    CurrentDateTime: string; // yyyymmddhhnnss
    FormattedCurrentDateTime: string; // yyyy-mm-dd hh:nn:ss
    DayOfWeekKR: string; // 요일
    { 어제 }
    LastDate: string; // yyyymmdd
    FormattedLastDate: string; // yyyy-mm-dd
    { 내일 }
    NextDate: string; // yyyymmdd
    FormattedNextDate: string; // yyyy-mm-dd
  end;

  { 플러그인 정보 }
  TPluginRec = record
    PluginIdList: TIntegerList;
    ActivePluginId: Integer;
    AssignGamePluginId: Integer;
    LaneViewPlugin: string;
    LaneViewPluginId: Integer;
    LockerViewPlugin: string;
    LockerViewPluginId: Integer;
    SalePosPlugin: string;
    SalePosPluginId: Integer;
    ReceiptViewPlugin: string;
    ReceiptViewPluginId: Integer;
    SubMonitorPlugin: string;
    SubMonitorPluginId: Integer;
    WebViewPlugin: string;
    WebViewPluginId: Integer;
  end;

  { 플러그인 파라메터 정보 }
  TPluginParamRec = record
    Name: string;
    Value: Variant;
    Obj: TObject;
  end;

  { 파트너 센터 정보 }
  TPartnerCenterRec = record
    Host: string;
    TerminalId: string;
    SecretKey: string;
    Timeout: Integer;
    UseLocalSetting: Boolean;
    OAuthToken: string;
    Authorized: Boolean;
    ErrorText: string;
  end;

  { 게임서버 정보 }
  TGameServerRec = record
    APIHost: string;
    APIPort: Integer;
    APITimeout: Integer;
    DBHost: string;
    DBName: string;
    DBPort: Integer;
    DBAPIPort: Integer;
    DBUserId: string;
    DBPassword: string;
    DBTimeout: Integer;
  end;

  { 매장 정보 }
  TStoreInfoRec = record
    StoreCode: string;
    StoreName: string;
    BizNo: string;
    BossName: string;
    TelNo: string;
    ZipNo: string;
    Addr: string;
    Addr2: string;
    ClosureStart: string; //휴장 시작 일시(yyyy-mm-dd hh:nn:ss)
    ClosureEnd: string; //휴장 종료 일시(yyyy-mm-dd hh:nn:ss)
    OpenTime: string; //영업 시작 시각(yyyy-mm-dd hh:nn:ss)
    CloseTime: string; //영업 종료 시각(yyyy-mm-dd hh:nn:ss)
    Canceled: Boolean; //계약 해지 여부
    IsHoliday: Boolean; //휴일 여부
    ShoesRentProdDetailDiv: string; //볼링화 대여상품 상세 구분코드
    ShoesRentProdCode: string; //볼링화 대여 상품코드
    ShoesRentProdName: string; //볼링화 대여 상품명
    ShoesRentProdAmt: Integer; //볼링화 대여료
    DefaultGameProdCode: string; //게임제 기본 상품코드
    DefaultTimeProdCode: string; //시간제 기본 상품코드
  end;

  { 터미널 정보 }
  TTerminalInfoRec = record
    TerminalDiv: string;
    TerminalName: string;
    PosNo: Integer;
    PeriodEndDate: string;
    IsFrontPos: Boolean;
    SaleZoneCode: string;
    VanCode: string; // VAN사 구분코드
    VanTID: string; // VAN TID
    PaycoTID: string; // PAYCO TID
  end;

  { 마스터 수신 정보 }
  TMasterUpdatedRec = record
    Downloaded: Boolean;
    Setting: string;
    LaneList: string;
    LockerList: string;
    ClubList: string;
    MemberList: string;
    PluList: string;
    ProdGame: string;
    ProdMembership: string;
    ProdLocker: string;
    ProdRent: string;
    ProdGeneral: string;
  end;

  { 레인 정보 }
  TLaneItemRec = record
    LaneNo: ShortInt;
    LaneName: string;
    LaneStatus: ShortInt;
    AssignLaneNo: ShortInt;
    FrameNo: ShortInt;
    DeviceId: string;
    LaneMemo: string;
    Container: TBPLaneContainer;
  end;

  { 레인 목록 정보 }
  TLaneInfo = record
    Lanes: TArray<TLaneItemRec>;
  private
    FSelectedLaneNo: ShortInt;
    FSelectedLanes: TIntegerList;
    FReadyCount: Integer;
    FReservedCount: Integer;
    FBusyCount: Integer;

    procedure SetSelectedLaneNo(const AValue: ShortInt);
    function GetLaneCount: ShortInt;
    procedure SetLaneCount(const AValue: ShortInt);
    procedure SetReadyCount(const AValue: Integer);
    procedure SetReservedCount(const AValue: Integer);
    procedure SetBusyCount(const AValue: Integer);
  public
    procedure Clear;
    procedure LanesClear;
    function LaneIndex(const ALaneNo: ShortInt = -1): ShortInt;
    function AssignLaneNo(const ALaneNo: ShortInt = -1): ShortInt;
    function SelectedLaneList: string;
    function AssignLaneNoList: string;

    property LaneCount: ShortInt read GetLaneCount write SetLaneCount;
    property SelectedLaneNo: ShortInt read FSelectedLaneNo write SetSelectedLaneNo;
    property SelectedLanes: TIntegerList read FSelectedLanes write FSelectedLanes;
    property ReadyCount: Integer read FReadyCount write SetReadyCount;
    property ReservedCount: Integer read FReadyCount write SetReservedCount;
    property BusyCount: Integer read FBusyCount write SetBusyCount;
  end;

  { 라커 정보 }
  TLockerItemRec = record
    LockerNo: Integer;
    LockerName: string;
    ZoneCode: string;
    ZoneName: string;
    LayerCode: string;
    LayerName: string;
    SexDiv: ShortInt;
    SexDivName: string;
    LockerStatus: ShortInt;
    LockerStatusName: string;
    MemberNo: string;
    MemberName: string;
    TelNo: string;
    KeepAmt: Integer;
    ProdCode: string;
    ProdName: string;
    StartDate: string;
    EndDate: string;
    LockerMemo: string;
  end;

  { 라커 목록 정보 }
  TLockerInfo = record
    Items: TArray<TLockerItemRec>;
  private
    function GetItemCount: Integer;
    procedure SetItemCount(const AValue: Integer);
  public
    procedure Clear;
    function GetItemIndex(const ALockerNo: Integer): Integer;

    property ItemCount: Integer read GetItemCount write SetItemCount;
  end;

  { 회원 정보 }
  TMemberInfoRec = record
    Selected: Boolean;
    MemberNo: string;
    MemberName: string;
    ClubSeq: Integer;
    ClubName: string;
    MemberDiv: string;
    MemberDivName: string;
    MemberGroupCode: string;
    MemberGroupName: string;
    SexDiv: ShortInt;
    SexDivName: string;
    Birthday: string;
    TelNo: string;
    CarNo: string;
    Email: string;
    ZipNo: string;
    Addr: string;
    Addr2: string;
    SavePoint: Integer;
    AdAgree: Boolean;
    MemberMemo: string;
    QRCode: string;
    FPHash: string;
    PhotoStream: TMemoryStream;
    LockerList: string;
    LockerExpiredDate: string;
    SelectLockerNo: SmallInt;
    SelectLockerName: string;
    UseStartDate: string;
    PurchaseMonth: Integer;
  public
    procedure Clear;
  end;

  { 쿠폰 정보 }
  TCouponItemRec = record
    Seq: Integer;
    CouponName: string; //쿠폰명
    QRCode: string; //쿠폰 일련번호
    DCDiv: string; //할인 구분(A:정액할인, R:정률할인)
    DCValue: Integer; //할인 금액(정액) 또는 할인율(정률)
    ApplyDCAmt: Integer; //할인 적용 금액
    MemberNo: string; //회원번호(빈값이면 비회원 사용 가능)
    StartDate: string; //시작일자
    ExpireDate: string; //만기일자
    UseCnt: Integer; //사용 가능 횟수
    UsedCnt: Integer; //사용한 횟수
    EventName: string; //이벤트명
    DCCondDiv: string; //이용 조건(1:중복할인, 2:단독할인)
    ProductDiv: string; //할인적용 가능한 상품구분
    GameProdDiv: string; //게임 상품구분
    UseYN: string; //사용 여부 (Y:사용완료, M:사용중, N:미사용)
    UseStatus: string; //사용 여부 Description
  public
    procedure Clear;
  end;

  { 볼러 배정 정보 }
  TBowlerRec = record
    BowlerId: string; //볼러 ID: 01A
    BowlerName: string; //볼러명
    EntrySeq: Integer; //대회 모드인 경우 참가자 Seq
    Handy: Integer; //대회 모드인 경우 참가자의 핸디
    MemberNo: string; //회원 번호
    MembershipSeq: Integer; //예약에 사용한 회원권 상품번호
    MembershipUseCount: ShortInt; //회원권 게임 이용 횟수
    MembershipUseMin: Integer; //회원권 게임 이용 시간(분)
    FeeDiv: string; //요금제 구분 = 01:일반, 02:회원, 03:학생, 04:클럽
    GameCount: ShortInt; //게임 이용횟수
    GameMin: Integer; //게임 이용 시간(분)
    ShoesRent: Boolean; //볼링화 대여 여부
    ShoesFree: Boolean; //볼링화 무상대여 여부
    PaymentType: ShortInt; //결제방식 구분 = 0:후불, 1:선불
    ProdInfo: TProdItemRec; //구매한 상품 정보
  public
    procedure Clear;
  end;

  { 게임 예약 정보 }
  TGameAssignRec = record
    LaneNo: ShortInt; //레인 번호
    GameDiv: ShortInt; //게임 구분 = 1:게임제, 2:시간제, 3:할인제
    AssignNo: string; //배정번호 = 날짜(8)+일련번호(4)
    RallySeq: Integer; //대회 Seq
    LeagueMode: Boolean; //리그게임 여부
    ShiftMethod: string; //레인 이동 방법
    ShiftCount: ShortInt; //레인 이동 수
    PrepareMin: ShortInt; //준비시간(분)
    Bowlers: TArray<TBowlerRec>; //볼러 배정 정보
  end;

  { 대회 설정 정보 }
  TRallyInfoRec = record
    RallySeq: Integer;
    RallyName: string;
    LeagueMode: Boolean;
    ShiftMethod: string; //G:일반, B:좌우, X:Cross
    ShiftCount: ShortInt;
    RankNoHandy: Boolean;
    RankHighLow: Boolean;
    RankBirth: Boolean;
    TeamMode: Boolean;
  end;

  { 테이블 이동 정보 }
  TTableShiftRec = record
    Code: string;
    Caption: string;
  end;

  { 고객 지원 정보 }
  TSupportInfoRec = record
    ChannelUrl: string;
    RemoteUrl: string;
  end;

  { 로그 설정 정보 }
  TLogRec = record
    LogFileName: string;
    ActionLogFileName: string;
    PayLogFileName: string;
    IsDelete: Boolean;
    Deleting: Boolean;
    Deleted: Boolean;
    DeleteDays: Integer;
    ListBox: TListBox;
  end;

  { 설정 정보 }
  TSettingRec = record
    Launcher: TIniFile; // 런처 설정 파일
    System: TIniFile; // 시스템 설정 파일
    Local: TIniFile; // 로컬 설정 파일
    Table: TIniFile; // 테이블 설정 파일
  end;

  { 알리미 설정 정보 }
  TNotifierRec = record
    AppHandle: HWND; // 알리미 핸들
    IsAutoRun: Boolean; // 알리미 자동 실행 여부
  end;

  { 날씨 정보: OpenWeatherMap API }
  TWeatherInfo = record
    Enabled: Boolean;
    Host: string;
    ApiKey: string;
    Latitude: string; //위도
    Longitude: string; //경도
    Temper: string; //온도
    Precipit: string; //강수확률
    Humidity: string; //습도
    WindSpeed: string; //풍속
    DayTime: Boolean; //낮: True, 밤: False
    Condition: string; //날씨상태
    WeatherId: Integer; //날씨상태Id
    IconIndex: Integer; //아이콘
  end;

  { 고객용 모니터 설정 정보 }
  TSubMonitorRec = record
    Enabled: Boolean;
    BaseLeft: Integer;
    BaseTop: Integer;
    BaseWidth: Integer;
    BaseHeight: Integer;
  end;

  { Data Field 정보 }
  TFieldInfoRec = record
    FieldName: string;
    FieldType: TVarType;
    FieldValue: Variant;
  end;

  { 일반 설정 정보 }
  TConfigRec = record
    BaseLeft: Integer;
    BaseTop: Integer;
    BaseWidth: Integer;
    BaseHeight: Integer;
    DarkMode: Boolean;
    HideTaskBar: Boolean; // 작업표시줄 숨기기 여부
    AutoRebootIgnored: Boolean; // 리부팅 무시 여부
    AutoRebootTime: string; // 자동 리부팅 시각(hh:nn)
    CheckAutoReboot: Boolean; // 리부팅 확인 여부
    LastNoticeDate: string; // 공지사항 최종 확인일자(yyyymmdd)
    SelfCashReceipt: Boolean; //현금영수증 자진발급 여부 기본값
  end;

  { 통합 설정 정보 }
  TGlobal = class
  private
    FBaseTitle: string;
    FTitle: string;
    FMainMenuResizing: Boolean;
    FMainFormCallbackProc: TMainFormCallbackProc;

    procedure DeleteLog;
    procedure ResetLogFile;

    procedure SetTitle(const AValue: string);
  public
    { 공용 변수 }
    AppInfo: TAppInfoRec; // 프로그램 정보
    AdminCall: TAdminCallRec; // 알리미 설정 정보
    UserInfo: TUserInfoRec; // 사용자 정보
    DirInfo: TDirInfoRec; // 디렉터리 정보
    DateTime: TDateTimeInfoRec; // 시스템 시각 정보
    Plugin: TPluginRec; // 플러그인 정보
    Notifier: TNotifierRec; // 알리미 정보
    Setting: TSettingRec; // 환경 설정 정보
    Config: TConfigRec; // 일반 설정 정보
    StoreInfo: TStoreInfoRec; // 매장 정보
    TerminalInfo: TTerminalInfoRec; // 터미널 정보
    ReceiptInfo: TReceiptInfo; //영수증 정보
    LaneInfo: TLaneInfo; // 레인 목록 정보
    LockerInfo: TLockerInfo; // 라커 목록 정보
    ProdInfo: TProdItemRec; // 상품 정보
    MemberInfo: TMemberInfoRec; // 회원 정보
    PartnerCenter: TPartnerCenterRec; // 파트너센터 정보
    GameServer: TGameServerRec; // 게임서버 정보
    SubMonitor: TSubMonitorRec; // 고객측 모니터 설정 정보
    ICCardReader: TCustomDeviceSetting; // 신용카드 결제 단말기 설정 정보
    ReceiptPrinter: TCustomDeviceSetting; // 영수증 프린터 설정 정보
    BarcodeScanner: TCustomDeviceSetting; // 바코드 스캐너 설정 정보
    ReceiptPrint: TReceiptPrint; //영수증 프린터 출력 모듈
    SupportInfo: TSupportInfoRec; //고객 지원 설정 정보
    WeatherInfo: TWeatherInfo; //날씨 정보
    Log: TLogRec; // 로그 정보
    MasterUpdated: TMasterUpdatedRec; //마스터 수신 정보
    GameStatusWorking: Boolean; //게임 상태 수신 작업 여부
    AssignListWorking: Boolean; //예약 목록 수신 작업 여부
    AppOnIdle: Boolean; //프로그램 유휴 상태 여부
    AppOnIdleLast: TDateTime; //최종 유휴 상태 처리 시각
    Closing: Boolean; // 프로그램 종료 여부
    WakeupListFileName: string; //원격시동 맥어드레스 파일먕

    FPluManager: TPluManager;

    { 타이머 스레드 }
    BaseTimer: TBaseTimerThread;

    constructor Create;
    destructor Destroy; override;

    procedure CheckSetting;
    procedure ReadSetting;
    procedure CheckLocalSetting;
    procedure ReadLocalSetting;
    procedure CheckTableSetting;
    procedure ReadTableSetting;

    property BaseTitle: string read FBaseTitle write FBaseTitle;
    property Title: string read FTitle write SetTitle;
    property MainMenuResizing: Boolean read FMainMenuResizing write FMainMenuResizing default False;
    property PluManager: TPluManager read FPluManager write FPluManager;
    property MainFormCallbackProc: TMainFormCallbackProc read FMainFormCallbackProc write FMainFormCallbackProc;
  end;

var
  Global: TGlobal;
  VanModule: TVanDaemonModule;
  PaycoModule: TPaycoNewModule;
  LogCS: TRTLCriticalSection;

const
  { 테이블 이동 방법 목록 }
  CO_TABLE_SHIFT_LIST: array[0..2] of TTableShiftRec = (
      (Code: 'G'; Caption: '일반'),
      (Code: 'B'; Caption: '좌우'),
      (Code: 'X'; Caption: '크로스')
    );

procedure ActionLog(const ALogText: string; const ALineBreak: Boolean=False);
procedure UpdateLog(const ALogText: string; const ALineBreak: Boolean=False); overload;
procedure UpdateLog(const AFileName, ALogText: string; const ALineBreak: Boolean=False); overload;
procedure PayLog(const AReceiptNo: string; const AIsApproval, AManualInput: Boolean; const APayMethod: ShortInt; const ACreditCardNo, AApprovalNo: string; const APayAmt: Integer);
procedure SendToPlugin(const ACommand: string; const ATargetId: Integer); overload;
procedure SendToPlugin(const ACommand: string; const ATargetId: Integer; const AValue: Variant); overload;
procedure SendToPluginLaneStatus(const ATargetId: Integer; const AIndex, AStatus: ShortInt);
procedure SendToMainForm(const ACommand: string); overload;
procedure SendToMainForm(const ACommand: string; const AValue: Variant); overload;
function ShowPluginModal(const APluginName, ACommand: string; AParams: TArray<TPluginParamRec>): TModalResult;
procedure ShowLaneView(const AOwnerId: Integer; AContainer: TWinControl);
function ShowMemberPopup(const AOwnerId: Integer; const AProdDiv: string): TModalResult; overload;
function ShowMemberPopup(const AOwnerId: Integer; const AProdDiv: string; const AGameDiv, ADataMode, ASearchType: ShortInt; const ASearchValue: string=''): TModalResult; overload;
function ShowMemberPopup(const AOwnerId: Integer; const AProdDiv: string; const AGameDiv, ADataMode, ASearchType: ShortInt; const ASearchValue: string; ASearchType2: ShortInt; const ASearchValue2: string): TModalResult; overload;
function ShowMemberPopup(PM: TPluginMessage; var AResMsg: string): TModalResult; overload;
procedure ShowLockerView(const AOwnerId: Integer; AContainer: TWinControl);
procedure ShowSalePos(const AOwnerId: Integer; AContainer: TWinControl);
procedure ShowRallyMode(const AOwnerId: Integer);
procedure ShowReceiptView(const AOwnerId: Integer; AContainer: TWinControl);
procedure ShowWebView(const AOwnerId: Integer; const ATitle: string; const AUrl: string=''); overload;
procedure ShowWebView(const AOwnerId: Integer; AContainer: TWinControl; const ATitle: string; const AUrl: string=''); overload;
procedure ShowPartnerCenter(const AOwnerId: Integer; AContainer: TWinControl; const ATitle: string; const ARedirectUri: string);
procedure ShowPopupWebView(const ATitle, AUrl: string; const AShowNavi: Boolean; const AShowNoMore: Boolean=False);
procedure ShowWeatherInfo;
function ShowProdPopup(PM: TPluginMessage; var AResMsg: string): Boolean; overload;
function ShowProdPopup(const AOwnerId, AIndex, AGameDiv: Integer; const AProdDiv, AProdDetailDiv, AFeeDiv, AMemberNo: string; const AMembershipOnly, ATodaySaleOnly: Boolean; var AResMsg: string): Boolean; overload;
function RunAdminCall(var AResMsg: string): Boolean;
function SendToAdminCall(const ACode: Integer; const AMsg, ASender: string; var AResMsg: string): Boolean;
function GetLockerLayerName(const ALayerCode: string): string;
function GetLockerStatusName(const ALockerStatus: ShortInt): string;
function GetSexDivName(const ASexDiv: ShortInt): string;
function GetBaudrate(const ABaudrate: Integer): TBaudRate;
function CheckEnumComPorts(const AComNumber: Integer; var AErrMsg: string): Boolean;
procedure OpenCashDrawer;
function GetLaneStatusColor(const AStatus: ShortInt): Integer;
function GetLaneStatusName(const AStatus: Shortint): string;
procedure AddFieldInfo(var AFields: TArray<TFieldInfoRec>; const AFieldName: string; const AFieldType: TVarType; const AFieldValue: Variant);
function MakeInsertSQL(const ATableName: string; const AFields: TArray<TFieldInfoRec>; var ASQL: string): Boolean; overload;
function MakeInsertSQL(const AInMemory: Boolean; const ATableName: string; const AFields: TArray<TFieldInfoRec>; var ASQL: string): Boolean; overload;
function StringListSortAsc(AList: TStringList; R1, R2: Integer): Integer;
function StringListSortDesc(AList: TStringList; R1, R2: Integer): Integer;
function ErrorString(const AValue: string): string;

implementation

uses
  { Native }
  Vcl.Forms, System.Variants, WinApi.Messages, Winapi.ShellApi, System.DateUtils, System.Math,
  System.StrUtils,
  { Indy }
  IdGlobal, IdTCPClient,
  { Absolute Database }
  ABSMain,
  { Project }
  Common.BPDM, Common.BPCommonLib;

procedure ActionLog(const ALogText: string; const ALineBreak: Boolean);
begin
  UpdateLog(Global.Log.ActionLogFileName, ALogText, ALineBreak);
end;
procedure UpdateLog(const ALogText: string; const ALineBreak: Boolean);
begin
  UpdateLog(Global.Log.LogFileName, ALogText, ALineBreak);
end;
procedure UpdateLog(const AFileName, ALogText: string; const ALineBreak: Boolean);
var
  LLogText: string;
begin
  try
    EnterCriticalSection(LogCS);
    try
      LLogText := '[' + FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ']' + IfThen(ALineBreak, sLineBreak, ' ') + ALogText;
      if Assigned(Global.Log.ListBox) then
        Global.Log.ListBox.Items.Add(LLogText);
      WriteToFile(AFileName, LLogText);
    except
    end;
  finally
    LeaveCriticalSection(LogCS);
  end;
end;

procedure PayLog(const AReceiptNo: string; const AIsApproval, AManualInput: Boolean; const APayMethod: ShortInt; const ACreditCardNo, AApprovalNo: string; const APayAmt: Integer);
var
  LPayMethod: string;
begin
  case APayMethod of
    CO_PAYMENT_CARD:
      LPayMethod := '신용카드';
    CO_PAYMENT_CASH:
      LPayMethod := '현금';
    CO_PAYMENT_PAYCO_CARD:
      LPayMethod := 'PAYCO(카드)';
    CO_PAYMENT_PAYCO_COUPON:
      LPayMethod := 'PAYCO(쿠폰)';
    CO_PAYMENT_PAYCO_POINT:
      LPayMethod := 'PAYCO(포인트)';
  else
    LPayMethod := APayMethod.ToString;
  end;

  if (APayMethod = CO_PAYMENT_CASH) and (not AApprovalNo.IsEmpty) then
    LPayMethod := LPayMethod + ' (현금영수증)';
  if AManualInput then
    LPayMethod := LPayMethod + ' (임의등록)';

  UpdateLog(Global.Log.PayLogFileName, '----------------------------------------');
  UpdateLog(Global.Log.PayLogFileName, Format('[%s 번호] %s', [IfThen(AIsApproval, '영수증', '원거래'), AReceiptNo]));
  UpdateLog(Global.Log.PayLogFileName, Format('[승 인 여 부] %s', [IfThen(AIsApproval, '승인', '취소')]));
  UpdateLog(Global.Log.PayLogFileName, Format('[결 제 수 단] %s', [LPayMethod]));
  UpdateLog(Global.Log.PayLogFileName, Format('[카 드 번 호] %s', [ACreditCardNo]));
  UpdateLog(Global.Log.PayLogFileName, Format('[승 인 번 호] %s', [AApprovalNo]));
  UpdateLog(Global.Log.PayLogFileName, Format('[결 제 금 액] %d', [APayAmt]));
end;

procedure SendToPlugin(const ACommand: string; const ATargetId: Integer);
begin
  SendToPlugin(ACommand, ATargetId, null);
end;
procedure SendToPlugin(const ACommand: string; const ATargetId: Integer; const AValue: Variant);
begin
  with TPluginMessage.Create(nil) do
    try
      Command := ACommand;
      if not(VarIsNull(AValue) or VarIsEmpty(AValue)) then
        AddParams(CPP_VALUE, VarToStr(AValue));
      PluginMessageToId(ATargetId);
    finally
      Free;
    end;
end;

procedure SendToPluginLaneStatus(const ATargetId: Integer; const AIndex, AStatus: ShortInt);
begin
  if (ATargetId = 0) then
    Exit;
  with TPluginMessage.Create(nil) do
    try
      Command := CPC_LANE_STATUS;
      AddParams(CPP_INDEX, AIndex);
      AddParams(CPP_VALUE, AStatus);
      PluginMessageToId(ATargetId);
    finally
      Free;
    end;
end;

function ShowPluginModal(const APluginName, ACommand: string; AParams: TArray<TPluginParamRec>): TModalResult;
var
  PM: TPluginMessage;
begin
  Result := mrNone;
  PM := TPluginMessage.Create(nil);
  try
    try
      PM.Command := ACommand;
      for var I: ShortInt := 0 to Pred(Length(AParams)) do
        if VarIsNull(Aparams[I].Value) in [] then
          PM.AddParams(AParams[I].Name, VarToStr(AParams[I].Value))
        else
          PM.AddParams(AParams[I].Name, AParams[I].Obj);
      Result := PluginManager.OpenModal(APluginName + CO_DEFAULT_EXT_PLUGIN, PM);
    except
      on E: Exception do
        UpdateLog(Format('ShowWeatherInfo.Exception = %s', [E.Message]));
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure SendToMainForm(const ACommand: string);
begin
  SendToMainForm(ACommand, null);
end;
procedure SendToMainForm(const ACommand: string; const AValue: Variant);
begin
  if Assigned(Global.MainFormCallBackProc) then
    Global.MainFormCallBackProc(ACommand, AValue);
end;

procedure ShowLaneView(const AOwnerId: Integer; AContainer: TWinControl);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    if (Global.Plugin.LaneViewPluginId = 0) then
    begin
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      if Assigned(AContainer) then
        Global.Plugin.LaneViewPluginId := PluginManager.OpenContainer(Global.Plugin.LaneViewPlugin, AContainer, PM).PluginId
      else
        Global.Plugin.LaneViewPluginId := PluginManager.Open(Global.Plugin.LaneViewPlugin, PM).PluginId;
      Global.Plugin.PluginIdList.Add(Global.Plugin.LaneViewPluginId);
    end
    else
    begin
      PM.Command := CPC_ACTIVE;
      PM.PluginMessageToId(Global.Plugin.LaneViewPluginId);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowSalePos(const AOwnerId: Integer; AContainer: TWinControl);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    if (Global.Plugin.SalePosPluginId = 0) then
    begin
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      if Assigned(AContainer) then
        Global.Plugin.SalePosPluginId := PluginManager.OpenContainer(Global.Plugin.SalePosPlugin, AContainer, PM).PluginId
      else
        Global.Plugin.SalePosPluginId := PluginManager.Open(Global.Plugin.SalePosPlugin, PM).PluginId;
      Global.Plugin.PluginIdList.Add(Global.Plugin.SalePosPluginId);
    end
    else
    begin
      PM.Command := CPC_ACTIVE;
      PM.PluginMessageToId(Global.Plugin.SalePosPluginId);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowRallyMode(const AOwnerId: Integer);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  with PM do
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, AOwnerId);
    if (PluginManager.OpenModal('BPRallyMode' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK) then
      SendToMainForm(CPC_GAME_REFRESH_DELAY);
  finally
    FreeAndNil(PM);
  end;
end;

function ShowMemberPopup(const AOwnerId: Integer; const AProdDiv: string): TModalResult;
begin
  Result := ShowMemberPopup(AOwnerId, AProdDiv, 0, CO_DATA_MODE_VIEW, CO_SEARCH_NONE);
end;
function ShowMemberPopup(const AOwnerId: Integer; const AProdDiv: string; const AGameDiv, ADataMode, ASearchType: ShortInt; const ASearchValue: string=''): TModalResult;
begin
  Result := ShowMemberPopup(AOwnerId, AProdDiv, AGameDiv, ADataMode, ASearchType, ASearchValue, CO_SEARCH_NONE, '');
end;
function ShowMemberPopup(const AOwnerId: Integer; const AProdDiv: string; const AGameDiv, ADataMode, ASearchType: ShortInt; const ASearchValue: string; ASearchType2: ShortInt; const ASearchValue2: string): TModalResult;
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, AOwnerId);
    PM.AddParams(CPP_GAME_DIV, AGameDiv);
    PM.AddParams(CPP_PROD_DIV, AProdDiv);
    PM.AddParams(CPP_DATA_MODE, ADataMode);
    PM.AddParams(CPP_SEARCH_TYPE, ASearchType);
    PM.AddParams(CPP_VALUE, ASearchValue);
    PM.AddParams(CPP_SEARCH_TYPE + '2', ASearchType2);
    PM.AddParams(CPP_VALUE + '2', ASearchValue2);
    Result := PluginManager.OpenModal('BPMember' + CO_DEFAULT_EXT_PLUGIN, PM);
  finally
    FreeAndNil(PM);
  end;
end;
function ShowMemberPopup(PM: TPluginMessage; var AResMsg: string): TModalResult;
begin
  AResMsg := '';
  try
    Result := ShowMemberPopup(
      PM.ParamByInteger(CPP_OWNER_ID),
      PM.ParamByString(CPP_PROD_DIV),
      PM.ParamByInteger(CPP_GAME_DIV),
      PM.ParamByInteger(CPP_DATA_MODE),
      PM.ParamByInteger(CPP_SEARCH_TYPE),
      PM.ParamByString(CPP_VALUE),
      PM.ParamByInteger(CPP_SEARCH_TYPE + '2'),
      PM.ParamByString(CPP_VALUE + '2'));
  except
    on E: Exception do
      AResMsg := E.Message;
  end;
end;

procedure ShowLockerView(const AOwnerId: Integer; AContainer: TWinControl);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    if (Global.Plugin.LockerViewPluginId = 0) then
    begin
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      PM.AddParams(CPP_SELECT_LOCKER, False);
      if Assigned(AContainer) then
        Global.Plugin.LockerViewPluginId := PluginManager.OpenContainer(Global.Plugin.LockerViewPlugin, AContainer, PM).PluginId
      else
        Global.Plugin.LockerViewPluginId := PluginManager.Open(Global.Plugin.LockerViewPlugin, PM).PluginId;
      Global.Plugin.PluginIdList.Add(Global.Plugin.LockerViewPluginId);
    end
    else
    begin
      PM.Command := CPC_ACTIVE;
      PM.PluginMessageToId(Global.Plugin.LockerViewPluginId);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowReceiptView(const AOwnerId: Integer; AContainer: TWinControl);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    if (Global.Plugin.ReceiptViewPluginId = 0) then
    begin
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      if Assigned(AContainer) then
        Global.Plugin.ReceiptViewPluginId := PluginManager.OpenContainer(Global.Plugin.ReceiptViewPlugin, AContainer, PM).PluginId
      else
        Global.Plugin.ReceiptViewPluginId := PluginManager.Open(Global.Plugin.ReceiptViewPlugin, PM).PluginId;
      Global.Plugin.PluginIdList.Add(Global.Plugin.ReceiptViewPluginId);
    end
    else
    begin
      PM.Command := CPC_ACTIVE;
      PM.PluginMessageToId(Global.Plugin.ReceiptViewPluginId);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowWebView(const AOwnerId: Integer; const ATitle: string; const AUrl: string);
begin
  ShowWebView(AOwnerId, nil, AUrl);
end;
procedure ShowWebView(const AOwnerId: Integer; AContainer: TWinControl; const ATitle: string; const AUrl: string);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    if (Global.Plugin.WebViewPluginId = 0) then
    begin
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      PM.AddParams(CPP_TITLE, ATitle);
      if Assigned(AContainer) then
        Global.Plugin.WebViewPluginId := PluginManager.OpenContainer(Global.Plugin.WebViewPlugin, AContainer, PM).PluginId
      else
        Global.Plugin.WebViewPluginId := PluginManager.Open(Global.Plugin.WebViewPlugin, PM).PluginId;
      Global.Plugin.PluginIdList.Add(Global.Plugin.WebViewPluginId);
    end;
    PM.ClearParams;
    PM.Command := CPC_NAVIGATE;
    PM.AddParams(CPP_TITLE, ATitle);
    PM.AddParams(CPP_VALUE, AUrl);
    PM.PluginMessageToId(Global.Plugin.WebViewPluginId);
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowPopupWebView(const ATitle, AUrl: string; const AShowNavi: Boolean; const AShowNoMore: Boolean);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Global.AppInfo.Handle);
    PM.AddParams(CPP_TITLE, ATitle);
    PM.AddParams(CPP_URL, AUrl);
    PM.AddParams(CPP_SHOW_NAVBTN, AShowNavi);
    PM.AddParams(CPP_SHOW_NOMORE, AShowNoMore);
    PluginManager.OpenModal('BPWebViewPopup' + CO_DEFAULT_EXT_PLUGIN, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure ShowPartnerCenter(const AOwnerId: Integer; AContainer: TWinControl; const ATitle: string; const ARedirectUri: string);
begin
  ShowWebView(AOwnerId, AContainer, ATitle,
    Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&redirectUrl=/%s', [
      {$WARN SYMBOL_PLATFORM OFF}ExcludeTrailingBackslash(Global.PartnerCenter.Host){$WARN SYMBOL_PLATFORM ON},
      Global.StoreInfo.StoreCode,
      Global.UserInfo.UserId,
      Global.UserInfo.TerminalPwd,
      ARedirectUri
    ]));
end;

procedure ShowWeatherInfo;
var
  PM: TPluginMessage;
begin
  try
    if not Global.WeatherInfo.Enabled then
      raise Exception.Create('날씨 정보를 사용할 수 없습니다.');

    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Global.AppInfo.Handle);
      PluginManager.OpenModal('BPWeather' + CO_DEFAULT_EXT_PLUGIN, PM);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      UpdateLog(Format('ShowWeatherInfo.Exception = %s', [E.Message]));
  end;
end;

function ShowProdPopup(PM: TPluginMessage; var AResMsg: string): Boolean;
begin
  Result := ShowProdPopup(
    PM.ParamByInteger(CPP_OWNER_ID),
    PM.ParamByInteger(CPP_INDEX),
    PM.ParamByInteger(CPP_GAME_DIV),
    PM.ParamByString(CPP_PROD_DIV),
    PM.ParamByString(CPP_PROD_DETAIL_DIV),
    PM.ParamByString(CPP_FEE_DIV),
    PM.ParamByString(CPP_MEMBER_NO),
    PM.ParamByBoolean(CPP_MEMBERSHIP_YN),
    PM.ParamByBoolean(CPP_TODAY_YN),
    AResMsg);
end;
function ShowProdPopup(const AOwnerId, AIndex, AGameDiv: Integer; const AProdDiv, AProdDetailDiv, AFeeDiv, AMemberNo: string; const AMembershipOnly, ATodaySaleOnly: Boolean; var AResMsg: string): Boolean;
var
  PM: TPluginMessage;
begin
  Result := False;
  AResMsg := '';
  try
    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, AOwnerId);
      PM.AddParams(CPP_INDEX, AIndex);
      PM.AddParams(CPP_GAME_DIV, AGameDiv);
      PM.AddParams(CPP_PROD_DIV, AProdDiv);
      PM.AddParams(CPP_PROD_DETAIL_DIV, AProdDetailDiv);
      PM.AddParams(CPP_FEE_DIV, AFeeDiv);
      PM.AddParams(CPP_MEMBER_NO, AMemberNo);
      PM.AddParams(CPP_MEMBERSHIP_YN, AMembershipOnly);
      PM.AddParams(CPP_TODAY_YN, ATodaySaleOnly);
      Result := (PluginManager.OpenModal('BPProdListView' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      UpdateLog(Format('ShowProdPopup.Exception = %s', [E.Message]));
  end;
end;

function RunAdminCall(var AResMsg: string): Boolean;
begin
  Result := False;
  AResMsg := '';
  try
    Global.AdminCall.Handle := FindWindow(PWideChar('TBPAdminCallForm'), nil);
    if (Global.AdminCall.Handle > 0) then
      Exit(True);

    if not FileExists(Global.DirInfo.HomeDir + Global.AdminCall.FileName) then
      raise Exception.Create(Format('프로그램이 경로에 존재하지 않습니다. (%s)', [Global.DirInfo.HomeDir + Global.AdminCall.FileName]));

    ShellExecute(0, 'open', PWideChar(Global.DirInfo.HomeDir + Global.AdminCall.FileName), nil, nil, SW_SHOW);
    Application.ProcessMessages;
    Global.AdminCall.Handle := FindWindow(PChar('TBPAdminCallForm'), nil);
    Result := True;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('RunAdminCall.Exception = %s', [E.Message]));
    end;
  end;
end;

function SendToAdminCall(const ACode: Integer; const AMsg, ASender: string; var AResMsg: string): Boolean;
var
  Config: TIniFile;
  LBuffer: string;
  LPort: Integer;
begin
  Result := False;
  AResMsg := '';
  try
    Global.AdminCall.Handle := FindWindow(PChar('TBPAdminCallForm'), nil);
    if (Global.AdminCall.Handle = 0) then
      raise Exception.Create('프로그램이 실행 중이지 않습니다.');

    with TIdTCPClient.Create(nil) do
    try
      Config := TIniFile.Create(Global.DirInfo.ConfigDir + ChangeFileExt(Global.AdminCall.FileName, '.config'));
      LPort := Config.ReadInteger('Config', 'ServerPort', 6001);
      LBuffer := Format('{"error_cd": "%s", "error_msg": "%s", "sender_id": "%s"}', [FormatFloat('0000', ACode), AMsg, ASender]);
      Host := '127.0.0.1';
      Port := LPort;
      ConnectTimeout := Global.GameServer.APITimeout;
      ReadTimeout := Global.GameServer.APITimeout;
      Connect;
      IOHandler.WriteLn(LBuffer, IndyTextEncoding_UTF8);
      Result := True;
    finally
      FreeAndNil(Config);
      Disconnect;
      Free;
    end;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('SendToAdminCall.Exception = %s', [E.Message]));
    end;
  end;
end;

function GetLockerLayerName(const ALayerCode: string): string;
begin
  if (ALayerCode = CO_LOCKER_LAYER_UPPER) then
    Result := '상단'
  else if (ALayerCode = CO_LOCKER_LAYER_LOWER) then
    Result := '하단'
  else
    Result := ALayerCode;
end;

function GetLockerStatusName(const ALockerStatus: ShortInt): string;
begin
  case ALockerStatus of
    CO_LOCKER_EMPTY: Result := '이용가능';
    CO_LOCKER_INUSE: Result := '이용중';
    CO_LOCKER_EXPIRED: Result := '만기';
    CO_LOCKER_DISABLED: Result := '이용불가';
  else
    Result := ALockerStatus.ToString;
  end;
end;

function GetSexDivName(const ASexDiv: ShortInt): string;
begin
  case ASexDiv of
    CO_SEX_ALL: Result := '공용';
    CO_SEX_MALE: Result := '남';
    CO_SEX_FEMALE: Result:= '여';
  else
    Result := ASexDiv.ToString;
  end;
end;

function GetBaudrate(const ABaudrate: Integer): TBaudRate;
begin
  case ABaudrate of
    9600:   Result := br9600;
    14400:  Result := br14400;
    19200:  Result := br19200;
    38400:  Result := br38400;
    57600:  Result := br57600;
    115200: Result := br115200;
    128000: Result := br128000;
    256000: Result := br256000;
  else
    Result := br9600;
  end;
end;

function CheckEnumComPorts(const AComNumber: Integer; var AErrMsg: string): Boolean;
var
  LKeyHandle: HKEY;
  LErrCode, LIndex: Integer;
  LValueName, LData: string;
  LValueLen, LDataLen, LValueType: DWORD;
  SL: TStringList;
begin
  Result := False;
  AErrMsg := '';
  LErrCode := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'HARDWARE\DEVICEMAP\SERIALCOMM', 0, KEY_READ, LKeyHandle);
  try
    if (LErrCode <> ERROR_SUCCESS) then
      raise Exception.Create(Format('COM%d은 등록되지 않은 통신포트입니다.', [AComNumber]));
    SL := TStringList.Create;
    try
      LIndex := 0;
      repeat
        LValueLen := 256;
        LDataLen := 256;
        SetLength(LValueName, LValueLen);
        SetLength(LData, LDataLen);
        LErrCode := RegEnumValue(
          LKeyHandle,
          LIndex,
          PChar(LValueName),
          Cardinal(LValueLen),
          nil,
          @LValueType,
          PByte(PChar(LData)),
          @LDataLen);

        if (LErrCode = ERROR_SUCCESS) then
        begin
          SetLength(LData, LDataLen - 1);
          SL.Add(LData);
          Inc(LIndex);
        end
        else if (LErrCode <> ERROR_NO_MORE_ITEMS) then
          Break;
      until (LErrCode <> ERROR_SUCCESS);

      SL.Sort;
      for LIndex := 0 to Pred(SL.Count) do
      begin
        Result := (StrToInt(StringReplace(UpperCase(SL[LIndex]), 'COM', '', [rfReplaceAll])) = AComNumber);
        if Result then
          Break;
      end;
    finally
      RegCloseKey(LKeyHandle);
      FreeAndNil(SL);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Format('CheckEnumComPorts.Exception = %s', [E.Message]));
    end;
  end;
end;

procedure OpenCashDrawer;
var
  LBuffer: string;
begin
  with Global.ReceiptPrinter do
    if Enabled and
       Assigned(ComDevice) then
    try
      if not ComDevice.Active then
      begin
        if (Port >= 10) then
          ComDevice.DeviceName := '\\.\COM' + IntToStr(Port)
        else
          ComDevice.DeviceName := 'COM' + IntToStr(Port);
        ComDevice.BaudRate := GetBaudrate(Baudrate);
        ComDevice.Parity := TParity.paNone;
        ComDevice.DataBits := TDataBits.db8;
        ComDevice.StopBits := TStopBits.sb1;
        ComDevice.Open;
      end;

      LBuffer := #27#112#0#25#250;
      ComDevice.Write(PAnsiChar(LBuffer), Length(LBuffer), False);
    except
      on E: Exception do
        UpdateLog(Format('OpenCashDrawer.Exception = %s', [E.Message]));
    end;
end;

function GetLaneStatusColor(const AStatus: ShortInt): Integer;
begin
  case AStatus of
    CO_LANE_READY:
      Result := CO_COLOR_LANE_READY;
    CO_LANE_RESERVED:
      Result := CO_COLOR_LANE_RESERVED;
    CO_LANE_HOLD:
      Result := CO_COLOR_LANE_HOLD;
    CO_LANE_BUSY,
    CO_LANE_END_UNPAID,
    CO_LANE_END:
      Result := CO_COLOR_LANE_BUSY;
    CO_LANE_MAINTENANCE:
      Result := CO_COLOR_LANE_MAINTENANCE;
  else
    Result := CO_COLOR_LANE_READY;
  end;
end;

function GetLaneStatusName(const AStatus: Shortint): string;
begin
  case AStatus of
    CO_LANE_RESERVED:
      Result := '예약중';
    CO_LANE_HOLD:
      Result := '임시예약';
    CO_LANE_BUSY:
      Result := '이용중';
    CO_LANE_END_UNPAID:
      Result := '종료(미결제)';
    CO_LANE_END:
      Result := '종료';
    CO_LANE_MAINTENANCE:
      Result := '점검중';
  else
    Result := '대기';
  end;
end;

procedure AddFieldInfo(var AFields: TArray<TFieldInfoRec>; const AFieldName: string; const AFieldType: TVarType; const AFieldValue: Variant);
var
  LCount: ShortInt;
begin
  LCount := Length(AFields);
  SetLength(AFields, Succ(LCount));
  AFields[LCount].FieldName := AFieldName;
  AFields[LCount].FieldType := AFieldType;
  AFields[LCount].FieldValue := AFieldValue;
end;

function MakeInsertSQL(const ATableName: string; const AFields: TArray<TFieldInfoRec>; var ASQL: string): Boolean;
begin
  Result := MakeInsertSQL(False, ATableName, AFields, ASQL);
end;
function MakeInsertSQL(const AInMemory: Boolean; const ATableName: string; const AFields: TArray<TFieldInfoRec>; var ASQL: string): Boolean;
var
  LCount: ShortInt;
begin
  ASQL := '';
  Result := False;
  try
    LCount := Length(AFields);
    if (LCount = 0) then
      raise Exception.Create('MakeInsertSQL.Exception = SQL 구문을 생성할 데이터 필드 정보가 없습니다.');
    ASQL := Format('INSERT INTO %s %s (', [IfThen(AInMemory, 'MEMORY', ''), ATableName]);
    for var I := 0 to High(AFields) do
    begin
      if (I = 0) then
        ASQL := ASQL + _CRLF + '  '
      else
        ASQL := ASQL + _CRLF + '  , ';
      ASQL := ASQL + AFields[I].FieldName
    end;
    ASQL := ASQL + _CRLF + ') VALUES (';
    for var I := 0 to High(AFields) do
    begin
      if (I = 0) then
        ASQL := ASQL + _CRLF + '  '
      else
        ASQL := ASQL + _CRLF + '  , ';
      case AFields[I].FieldType of
        varSmallInt, varInteger, varShortInt, varWord, varUInt32, varInt64, varUInt64:
          ASQL := ASQL + Format('%d', [Integer(AFields[I].FieldValue)]);
        varString:
          ASQL := ASQL + Format('%s', [QuotedStr(AFields[I].FieldValue)]);
        varBoolean:
          ASQL := ASQL + Format('%s', [BoolToStr(AFields[I].FieldValue, True)]);
        else
          raise Exception.Create(Format('MakeInsertSQL.Exception = %s 필드는 알 수 없는 데이터 형식입니다.', [AFields[I].FieldName]));
      end;
    end;
    ASQL := ASQL + _CRLF + ');';
{$IFDEF DEBUG}
    WriteToFile(Global.DirInfo.LogDir + Format('MakeInsertSQL(%s).sql', [ATableName]), ASQL, True);
{$ENDIF}
    Result := True;
  except
  end;
end;

function StringListSortAsc(AList: TStringList; R1, R2: Integer): Integer;
begin
  if (AList.Strings[R1].PadLeft(3) > AList.Strings[R2].PadLeft(3)) then
    Result := 1
  else if (AList.Strings[R1].PadLeft(3) < AList.Strings[R2].PadLeft(3)) then
    Result := -1
  else
    Result := 0;
end;

function StringListSortDesc(AList: TStringList; R1, R2: Integer): Integer;
begin
  if (AList.Strings[R1].PadLeft(3) > AList.Strings[R2].PadLeft(3)) then
    Result := -1
  else if (AList.Strings[R1].PadLeft(3) < AList.Strings[R2].PadLeft(3)) then
    Result := 1
  else
    Result := 0;
end;

function ErrorString(const AValue: string): string;
begin
  Result := '<FC:$000000FF>' + AValue + '</FC>';
end;

{ TGlobal }

constructor TGlobal.Create;
var
  FS: TFormatSettings;
begin
  inherited;

  FS := TFormatSettings.Create;
  FS.DateSeparator := '-';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.ShortTimeFormat := 'hh:nn:ss';

  with DateTime do
  begin
    CurrentDate := FormatDateTime('yyyymmdd', System.DateUtils.Today);
    FormattedCurrentDate := FormattedDateString(CurrentDate);
    CurrentTime := FormatDateTime('hhnnss', System.DateUtils.Today);
    FormattedCurrentTime := FormattedTimeString(CurrentTime);
    CurrentDateTime := CurrentDate + CurrentTime;
    FormattedCurrentDateTime := FormattedCurrentDate + ' ' + FormattedCurrentTime;
    LastDate := FormatDateTime('yyyymmdd', System.DateUtils.Yesterday);
    FormattedLastDate := FormattedDateString(LastDate);
    NextDate := FormatDateTime('yyyymmdd', System.DateUtils.Tomorrow);
    FormattedNextDate := FormattedDateString(NextDate);
    DayOfWeekKR := DayOfWeekName(Now);
  end;

  AppInfo.AppName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  DirInfo.HomeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  DirInfo.ConfigDir := DirInfo.HomeDir + 'config\';
  DirInfo.PluginDir := DirInfo.HomeDir + 'plugin\';
  DirInfo.DataDir := DirInfo.HomeDir + 'data\';
  DirInfo.ContentsDir := DirInfo.HomeDir + 'contents\';
  DirInfo.DownloadDir := DirInfo.HomeDir + 'download\';
  DirInfo.MediaDir := DirInfo.HomeDir + 'media\';
  DirInfo.WebCacheDir := DirInfo.HomeDir + 'cache\';
  DirInfo.LogDir := DirInfo.HomeDir + 'log\';
  ResetLogFile;

  ForceDirectories(DirInfo.ConfigDir);
  ForceDirectories(DirInfo.PluginDir);
  ForceDirectories(DirInfo.DataDir);
  ForceDirectories(DirInfo.ContentsDir);
  ForceDirectories(DirInfo.DownloadDir);
  ForceDirectories(DirInfo.MediaDir);
  ForceDirectories(DirInfo.WebCacheDir);
  ForceDirectories(DirInfo.LogDir);

  Plugin.ActivePluginId := 0;
  Plugin.LaneViewPluginId := 0;
  Plugin.SalePosPluginId := 0;
  Plugin.AssignGamePluginId := 0;
  Plugin.LockerViewPluginId := 0;
  Plugin.SubMonitorPluginId := 0;
  Plugin.WebViewPluginId := 0;

  Setting.Launcher := TIniFile.Create(DirInfo.ConfigDir + CO_DEFAULT_LAUNCHER_NAME + '.config');
  Setting.System := TIniFile.Create(DirInfo.ConfigDir + AppInfo.AppName + '.config');
  Setting.Local := TIniFile.Create(DirInfo.ConfigDir + AppInfo.AppName + 'Local.config');
  Setting.Table := TIniFile.Create(DirInfo.ConfigDir + AppInfo.AppName + 'Table.config');
  WakeupListFileName := DirInfo.ConfigDir + AppInfo.AppName + 'Wakeup.lst';

  ReceiptInfo := TReceiptInfo.Create;
  PluManager := TPluManager.Create;
  Plugin.PluginIdList := TIntegerList.Create;

  ICCardReader := TCustomDeviceSetting.Create;
  ReceiptPrinter := TCustomDeviceSetting.Create;
  BarcodeScanner := TCustomDeviceSetting.Create;

  VanModule := TVanDaemonModule.Create;
  PaycoModule := TPaycoNewModule.Create;
{$IFDEF RELEASE}
  PaycoModule.SetOpen;
{$ENDIF}

  CheckSetting;
  ReadSetting;
  CheckLocalSetting;
  ReadLocalSetting;
  CheckTableSetting;
  ReadTableSetting;

  GameStatusWorking := False;
  AssignListWorking := False;
  AppOnIdle := False;
  AppOnIdleLast := (Now - 1);

  BaseTimer := TBaseTimerThread.Create;
  BaseTimer.Start;

  LaneInfo.SelectedLaneNo := 0;
  LaneInfo.SelectedLanes := TIntegerList.Create;
  LaneInfo.Clear;

  MemberInfo.Clear;
end;

destructor TGlobal.Destroy;
begin
  LaneInfo.SelectedLanes.Free;
  Plugin.PluginIdList.Free;
  VanModule.Free;
  PaycoModule.Free;
  if Assigned(ReceiptPrint) then
    ReceiptPrint.Free;
  if Assigned(ReceiptInfo) then
    ReceiptInfo.Free;
  if Assigned(PluManager) then
    PluManager.Free;
  if Assigned(ICCardReader) then
    ICCardReader.Free;
  if Assigned(ReceiptPrinter) then
    ReceiptPrinter.Free;
  if Assigned(BarcodeScanner) then
    BarcodeScanner.Free;
  if Assigned(BaseTimer) then
    BaseTimer.Terminate;

  inherited;
end;

procedure TGlobal.CheckSetting;
var
  LLeft, LTop, LWidth, LHeight: Integer;
begin
  with Setting.Launcher do
  begin
    { 프로그램 업데이트 설정 }
//    To-Do : for Multi Launcher
//    if not SectionExists(AppInfo.AppName) then
    if not SectionExists('Config') then
    begin
      WriteString(AppInfo.AppName, 'DeployUrl', 'http://nhncdn.bowlingpick.co.kr/POS/R1/');
      WriteString(AppInfo.AppName, 'RunApp', AppInfo.AppName + '.exe');
      WriteString(AppInfo.AppName, 'Params', '');
      WriteInteger(AppInfo.AppName, 'Delay', 0);
      WriteInteger(AppInfo.AppName, 'WatchInterval', 0);
      WriteString(AppInfo.AppName, 'Params', '');
      WriteBool(AppInfo.AppName, 'RebootWhenUpdated', False);
      WriteToFile(FileName, '');
    end;
  end;

  with Setting.System do
  begin
    if not SectionExists('Config') then
    begin
      WriteInteger('Config', 'BaseLeft', Screen.Monitors[0].Left);
      WriteInteger('Config', 'BaseTop', Screen.Monitors[0].Top);
      WriteInteger('Config', 'BaseWidth', Screen.Monitors[0].Width);
      WriteInteger('Config', 'BaseHeight', Screen.Monitors[0].Height);
      WriteString('Config', 'AutoRebootTime', CO_DEFAULT_AUTO_REBOOT_TIME);
      WriteString('Config', 'LastUpdated', '');
      WriteToFile(FileName, '');
    end;

    { 파트너센터 설정 }
    if not SectionExists('PartnerCenter') then
    begin
      WriteString('PartnerCenter', 'Host', CO_URL_API_SERVER);
      WriteString('PartnerCenter', 'TerminalId', '');
      WriteString('PartnerCenter', 'SecretKey', '');
      WriteInteger('PartnerCenter', 'Timeout', 10000); //밀리초
      WriteBool('PartnerCenter', 'UseLocalSetting', False);
      WriteToFile(FileName, '');
    end;

    { 터미널 설정 }
    if not SectionExists('TerminalInfo') then
    begin
      WriteString('TerminalInfo', 'VanCode', 'KCP');
      WriteString('TerminalInfo', 'VanTID', '');
      WriteString('TerminalInfo', 'PaycoTID', '');
      WriteToFile(FileName, '');
    end;

    { 게임 서버 설정 }
    if not SectionExists('GameServer') then
    begin
      WriteString('GameServer', 'APIHost', CO_DEFAULT_GAMESERVER_HOST);
      WriteInteger('GameServer', 'APIPort', CO_DEFAULT_GAMESERVER_API_PORT);
      WriteInteger('GameServer', 'APITimeout', 5000); //밀리초
      WriteString('GameServer', 'DBHost', CO_DEFAULT_GAMESERVER_HOST);
      WriteString('GameServer', 'DBName', CO_DEFAULT_GAMESERVER_DB);
      WriteString('GameServer', 'DBUserId', CO_DEFAULT_GAMESERVER_USER);
      WriteString('GameServer', 'DBPassword', StrEncrypt(CO_DEFAULT_GAMESERVER_PWD));
      WriteInteger('GameServer', 'DBPort', 3306);
      WriteInteger('GameServer', 'DBTimeout', 10000); //밀리초
      WriteToFile(FileName, '');
    end;

    { 플러그인 설정 }
    if not SectionExists('Plugin') then
    begin
      WriteString('Plugin', 'SalePos', 'BPSalePos' + CO_DEFAULT_EXT_PLUGIN);
      WriteString('Plugin', 'LaneView', 'BPLaneView' + CO_DEFAULT_EXT_PLUGIN);
      WriteString('Plugin', 'LockerView', 'BPLockerView' + CO_DEFAULT_EXT_PLUGIN);
      WriteString('Plugin', 'SubMonitor', 'BPSubMonitor' + CO_DEFAULT_EXT_PLUGIN);
      WriteString('Plugin', 'WebView', 'BPWebView' + CO_DEFAULT_EXT_PLUGIN);
      WriteToFile(FileName, '');
    end;

    { 고객측 모니터 설정 }
    if not SectionExists('SubMonitor') then
    begin
      LLeft := Screen.Monitors[0].Left;
      LTop := Screen.Monitors[0].Top;
      LWidth := Screen.Monitors[0].Width;
      LHeight := Screen.Monitors[0].Height;
      if (Screen.MonitorCount > 1) then
      begin
        LLeft := Screen.Monitors[1].Left;
        LTop := Screen.Monitors[1].Top;
        LWidth := Screen.Monitors[1].Width;
        LHeight := Screen.Monitors[1].Height;
      end;

      WriteBool('SubMonitor', 'Enabled', False);
      WriteInteger('SubMonitor', 'BaseLeft', LLeft);
      WriteInteger('SubMonitor', 'BaseTop', LTop);
      WriteInteger('SubMonitor', 'BaseWidth', LWidth);
      WriteInteger('SubMonitor', 'BaseHeight', LHeight);
      WriteToFile(FileName, '');
    end;

    { 신용카드 결제 단말기 설정 }
    if not SectionExists('ICCardReader') then
    begin
      WriteBool('ICCardReader', 'Enabled', True);
      WriteInteger('ICCardReader', 'Port', 0);
      WriteInteger('ICCardReader', 'Baudrate', 0);
      WriteInteger('ICCardReader', 'DeviceId', 0);
      WriteToFile(FileName, '');
    end;

    { 영수증 프린터 설정 }
    if not SectionExists('ReceiptPrinter') then
    begin
      WriteBool('ReceiptPrinter', 'Enabled', False);
      WriteInteger('ReceiptPrinter', 'Port', 0);
      WriteInteger('ReceiptPrinter', 'Baudrate', 0);
      WriteInteger('ReceiptPrinter', 'DeviceId', 0);
      WriteToFile(FileName, '');
    end;

    { 바코드 스캐너 설정 }
    if not SectionExists('BarcodeScanner') then
    begin
      WriteBool('BarcodeScanner', 'Enabled', False);
      WriteInteger('BarcodeScanner', 'Port', 0);
      WriteInteger('BarcodeScanner', 'Baudrate', 0);
      WriteInteger('BarcodeScanner', 'DeviceId', 0);
      WriteToFile(FileName, '');
    end;

    { 고객 지원 }
    if not SectionExists('Support') then
    begin
      WriteString('Support', 'ChannelUrl', '');
      WriteString('Support', 'RemoteUrl', CO_URL_REMOTE_CS);
    end;
  end;
end;

procedure TGlobal.ReadSetting;
var
  LLeft, LTop, LWidth, LHeight: Integer;
begin
  with Setting.System do
  begin
    { 일반 설정 }
    Config.BaseLeft := ReadInteger('Config', 'BaseLeft', Screen.Monitors[0].Left);
    Config.BaseTop := ReadInteger('Config', 'BaseTop', Screen.Monitors[0].Top);
    Config.BaseWidth := ReadInteger('Config', 'BaseWidth', Screen.Monitors[0].Width);
    Config.BaseHeight := ReadInteger('Config', 'BaseHeight', Screen.Monitors[0].Height);
    Config.AutoRebootTime := ReadString('Config', 'AutoRebootTime', '');
    MasterUpdated.Setting := ReadString('Config', 'LastUpdated', '');

    { 파트너 센터 설정 }
    PartnerCenter.Host := ExcludeTrailingPathDelimiter(ReadString('PartnerCenter', 'Host', CO_URL_API_SERVER));
    PartnerCenter.TerminalId := ReadString('PartnerCenter', 'TerminalId', '');
    PartnerCenter.SecretKey := StrDecrypt(ReadString('PartnerCenter', 'SecretKey', ''));
    PartnerCenter.Timeout := ReadInteger('PartnerCenter', 'Timeout', 10000); //밀리초
    PartnerCenter.UseLocalSetting := ReadBool('PartnerCenter', 'UseLocalSetting', False);

    { 사업장 설정 }
    StoreInfo.StoreCode := PartnerCenter.TerminalId.Substring(0, 5);

    { 터미널 정보 }
    TerminalInfo.VanCode := ReadString('TerminalInfo', 'VanCode', '');
    TerminalInfo.VanTID := ReadString('TerminalInfo', 'VanTID', '');
    TerminalInfo.PaycoTID := ReadString('TerminalInfo', 'PaycoTID', '');

    { 게임서버 설정 }
    GameServer.APIHost := ReadString('GameServer', 'APIHost', CO_DEFAULT_GAMESERVER_HOST);
    GameServer.APIPort := ReadInteger('GameServer', 'APIPort', CO_DEFAULT_GAMESERVER_API_PORT);
    GameServer.APITimeout := ReadInteger('GameServer', 'APITimeout', 5000); //밀리초
    GameServer.DBHost := ReadString('GameServer', 'DBHost', CO_DEFAULT_GAMESERVER_HOST);
    GameServer.DBName := ReadString('GameServer', 'DBName', CO_DEFAULT_GAMESERVER_DB);
    GameServer.DBUserId := ReadString('GameServer', 'DBUserId', '');
    GameServer.DBPassword := StrDecrypt(ReadString('GameServer', 'DBPassword', ''));
    GameServer.DBPort := ReadInteger('GameServer', 'DBPort', CO_DEFAULT_GAMESERVER_DB_PORT);
    GameServer.DBTimeout := ReadInteger('GameServer', 'DBTimeout', 10000); //밀리초

    { 플러그인 설정 }
    Plugin.SalePosPlugin := ReadString('Plugin', 'SalePos', 'BPSalePOS.bpl');
    Plugin.LaneViewPlugin := ReadString('Plugin', 'LaneView', 'BPLaneView.bpl');
    Plugin.LockerViewPlugin := ReadString('Plugin', 'LockerView', 'BPLockerView.bpl');
    Plugin.ReceiptViewPlugin := ReadString('Plugin', 'ReceiptView', 'BPReceiptView.bpl');
    Plugin.WebViewPlugin := ReadString('Plugin', 'WebView', 'BPWebView.bpl');
    Plugin.SubMonitorPlugin := ReadString('Plugin', 'SubMonitor', '');

    { 고객측 모니터 설정 }
    LLeft := Screen.Monitors[0].Left;
    LTop := Screen.Monitors[0].Top;
    LWidth := Screen.Monitors[0].Width;
    LHeight := Screen.Monitors[0].Height;
    if (Screen.MonitorCount > 1) then
    begin
      LLeft := Screen.Monitors[1].Left;
      LTop := Screen.Monitors[1].Top;
      LWidth := Screen.Monitors[1].Width;
      LHeight := Screen.Monitors[1].Height;
    end;
    SubMonitor.Enabled := ReadBool('SubMonitor', 'Enabled', False);
    SubMonitor.BaseLeft := ReadInteger('SubMonitor', 'BaseLeft', LLeft);
    SubMonitor.BaseTop := ReadInteger('SubMonitor', 'BaseTop', LTop);
    SubMonitor.BaseWidth := ReadInteger('SubMonitor', 'BaseWidth', LWidth);
    SubMonitor.BaseHeight := ReadInteger('SubMonitor', 'BaseHeight', LHeight);

    { 신용카드 결제 단말기 설정 }
    ICCardReader.Enabled := ReadBool('ICCardReader', 'Enabled', False);
    ICCardReader.Port := ReadInteger('ICCardReader', 'Port', 0);
    ICCardReader.Baudrate := ReadInteger('ICCardReader', 'Baudrate', 0);
    ICCardReader.DeviceId := ReadInteger('ICCardReader', 'DeviceId', 0);
    if ICCardReader.Enabled then
    begin
      ICCardReader.ComDevice := TComPort.Create(nil);
      ICCardReader.ComDevice.DeviceName := 'COM' + ICCardReader.Port.ToString;
      ICCardReader.ComDevice.Baudrate := GetBaudRate(ICCardReader.Baudrate);
    end;

    { 영수증 프린터 설정 }
    ReceiptPrinter.Enabled := ReadBool('ReceiptPrinter', 'Enabled', False);
    ReceiptPrinter.Port := ReadInteger('ReceiptPrinter', 'Port', 0);
    ReceiptPrinter.Baudrate := ReadInteger('ReceiptPrinter', 'Baudrate', 0);
    ReceiptPrinter.DeviceId := ReadInteger('ReceiptPrinter', 'DeviceId', 0);
    if ReceiptPrinter.Enabled then
    begin
      ReceiptPrinter.ComDevice := TComPort.Create(nil);
      ReceiptPrinter.ComDevice.DeviceName := 'COM' + ReceiptPrinter.Port.ToString;
      ReceiptPrinter.ComDevice.Baudrate := GetBaudRate(ReceiptPrinter.Baudrate);
    end;

    { 바코드 스캐너 설정 }
    BarcodeScanner.Enabled := ReadBool('BarcodeScanner', 'Enabled', False);
    BarcodeScanner.Port := ReadInteger('BarcodeScanner', 'Port', 0);
    BarcodeScanner.Baudrate := ReadInteger('BarcodeScanner', 'Baudrate', 0);
    BarcodeScanner.DeviceId := ReadInteger('BarcodeScanner', 'DeviceId', 0);
    if BarcodeScanner.Enabled then
    begin
      BarcodeScanner.ComDevice := TComPort.Create(nil);
      BarcodeScanner.ComDevice.DeviceName := 'COM' + BarcodeScanner.Port.ToString;
      BarcodeScanner.ComDevice.Baudrate := GetBaudRate(BarcodeScanner.Baudrate);
    end;

    { 고객 지원 }
    SupportInfo.ChannelUrl := ReadString('Support', 'ChannelUrl', '');
    SupportInfo.RemoteUrl := ReadString('Support', 'RemoteUrl', '');
  end;
end;

procedure TGlobal.CheckLocalSetting;
begin
  with Setting.Local do
  begin
    { 일반 설정 }
    if not SectionExists('Config') then
    begin
      WriteBool('Config', 'DarkMode', False);
      WriteBool('Config', 'HideTaskBar', False);
      WriteBool('Config', 'SelfCashReceipt', True);
      WriteInteger('Config', 'ReceiptCopies', 1);
      WriteString('Config', 'LastNoticeDate', '');
      WriteBool('Config', 'LogDelete', True);
      WriteInteger('Config', 'LogDeleteDays', 30);
      WriteToFile(FileName, '');
    end;

    { 사용자 정보 }
    if not SectionExists('UserInfo') then
    begin
      WriteString('UserInfo', 'UserId', '');
      WriteBool('UserInfo', 'SaveId', False);
      WriteString('UserInfo', 'LastLogged', '');
      WriteToFile(FileName, '');
    end;

    { 알리미 }
    if not SectionExists('AdminCall') then
    begin
      WriteString('AdminCall', 'FileName', CO_DEFAULT_ADMINCALL_NAME + '.exe');
      WriteBool('AdminCall', 'AutoRun', False);
      WriteToFile(FileName, '');
    end;

    { 날씨 정보 설정 }
    if not SectionExists('Weather') then
    begin
      //37.33,  126.59  : 서울의 지리적 중심점
      //37.568, 126.978 : OpenWeatherMap.org의 Seoul City 검색 위치
      WriteString('Weather', 'Host', CO_URL_API_WEATHER);
      WriteString('Weather', 'Latitude', '37.568');
      WriteString('Weather', 'Longitude', '126.978');
      WriteString('Weather', 'ApiKey', '');
      WriteToFile(FileName, '');
    end;
  end;
end;

procedure TGlobal.ReadLocalSetting;
begin
  with Setting.Local do
  begin
    Config.DarkMode := ReadBool('Config', 'DarkMode', False);
    Config.HideTaskBar := ReadBool('Config', 'HideTaskBar', False);
    Config.SelfCashReceipt :=  ReadBool('Config', 'SelfCashReceipt', False);
    ReceiptPrinter.Copies := ReadInteger('Config', 'Copies', 1);
    Config.LastNoticeDate := ReadString('Config', 'LastNoticeDate', '');
    Log.IsDelete := ReadBool('Config', 'LogDelete', False);
    Log.DeleteDays := ReadInteger('Config', 'LogDeleteDays', 30);

    { 사용자 정보 }
    UserInfo.UserId := ReadString('UserInfo', 'UserId', '');
    UserInfo.LastLogged := ReadString('UserInfo', 'LastLogged', '');
    UserInfo.SaveId := ReadBool('UserInfo', 'SaveId', False);

    { 알리미 }
    AdminCall.FileName := ReadString('AdminCall', 'FileName', CO_DEFAULT_ADMINCALL_NAME + '.exe');
    AdminCall.AutoRun := ReadBool('AdminCall', 'AutoRun', False);

    { 날씨 정보 설정 }
    WeatherInfo.Host := ReadString('Weather', 'Host', '');
    WeatherInfo.Latitude := ReadString('Weather', 'Latitude', '');
    WeatherInfo.Longitude := ReadString('Weather', 'Longitude', '');
    WeatherInfo.ApiKey := StrDecrypt(ReadString('Weather', 'ApiKey', ''));
    WeatherInfo.Enabled := not (WeatherInfo.Host.IsEmpty or WeatherInfo.Latitude.IsEmpty or WeatherInfo.Longitude.IsEmpty or WeatherInfo.ApiKey.IsEmpty);
  end;
end;

procedure TGlobal.CheckTableSetting;
begin

end;

procedure TGlobal.ReadTableSetting;
begin

end;

procedure TGlobal.DeleteLog;
var
  SR: TSearchRec;
  LFound: Boolean;
  LBaseDate, LLogDate: string;
  LPos, LYear: Integer;
begin
  if Log.Deleting then
    Exit;

  try
    Log.Deleting := True;
    LBaseDate := FormatDateTime('yyyymmdd', IncDay(Now, -Log.DeleteDays));
    LPos := Length(AppInfo.AppName) + 2; // BPPOS_yyyymmdd.log
    { 프로그램 로그 삭제 }
    LFound := (FindFirst(DirInfo.LogDir + AppInfo.AppName + '_*.log', faAnyFile - faDirectory, SR) = 0);
    while LFound do
    begin
      LLogDate := Copy(SR.Name, LPos, 8);
      if (LLogDate >= '20000101') and (LLogDate <= LBaseDate) then
        System.SysUtils.DeleteFile(DirInfo.LogDir + SR.Name);
      LFound := (FindNext(SR) = 0);
    end;
    { 액션 로그 삭제 }
    LFound := (FindFirst(DirInfo.LogDir + AppInfo.AppName + '_action_*.log', faAnyFile - faDirectory, SR) = 0);
    while LFound do
    begin
      LLogDate := Copy(SR.Name, LPos, 8);
      if (LLogDate >= '20000101') and (LLogDate <= LBaseDate) then
        System.SysUtils.DeleteFile(DirInfo.LogDir + SR.Name);
      LFound := (FindNext(SR) = 0);
    end;

    { 결제 로그 삭제 (nYear년 이전 것만, 1년치 보관) }
    LYear := 1;
    LBaseDate := FormatDateTime('yyyymmdd', IncYear(Now, -LYear));
    LPos := 9;
    LFound := (FindFirst(DirInfo.LogDir + AppInfo.AppName + '_payment_*.log', faAnyFile - faDirectory, SR) = 0);
    while LFound do
    begin
      LLogDate := Copy(SR.Name, LPos, 8);
      if (LLogDate >= '20000101') and (LLogDate <= LBaseDate) then
        System.SysUtils.DeleteFile(DirInfo.LogDir + SR.Name);
      LFound := (FindNext(SR) = 0);
    end;
  finally
    System.SysUtils.FindClose(SR);
    Log.Deleted := True;
    Log.Deleting := False;
  end;
end;

procedure TGlobal.ResetLogFile;
begin
  Log.LogFileName := DirInfo.LogDir + Format('%s_%s.log', [AppInfo.AppName, DateTime.CurrentDate]);
  Log.ActionLogFileName := DirInfo.LogDir + Format('%s_action_%s.log', [AppInfo.AppName, DateTime.CurrentDate]);
  Log.PayLogFileName := DirInfo.LogDir + Format('%s_payment_%s.log', [AppInfo.AppName, DateTime.CurrentDate]);
end;

procedure TGlobal.SetTitle(const AValue: string);
begin
  if (FTitle <> AValue) then
  begin
    FTitle := AValue;
    SendToMainForm(CPC_TITLE, AValue);
  end;
end;

{ TBaseTimerThread }

constructor TBaseTimerThread.Create;
begin
  inherited Create(True);

  FreeOnTerminate := True;
  FWorking := False;
  FInterval := 1000;
  FCheckCount := 0;
  FLastWorked := (Now - 1);
  FLastWorkedWeather := FLastWorked;
end;

destructor TBaseTimerThread.Destroy;
begin

  inherited;
end;

procedure TBaseTimerThread.Execute;
begin
  inherited;

  repeat
    if (not FWorking) and
       (MilliSecondsBetween(FLastWorked, Now) > FInterval)
    then
    begin
      FWorking := True;
      FLastWorked := Now;
      try
        Synchronize(
          procedure
          var
            sDateTime, sCurrDate, sCurrTime: string;
          begin
            sDateTime := FormatDateTime('yyyymmddhhnnss', Now);
            sCurrDate := Copy(sDateTime, 1, 8);
            sCurrTime := Copy(sDateTime, 9, 6);

            if (Global.DateTime.CurrentDate <> sCurrDate) then
            begin
              Global.Log.Deleted := False;
              Global.DateTime.CurrentDate := sCurrDate;
              Global.DateTime.FormattedCurrentDate := FormattedDateString(sCurrDate);
              Global.DateTime.CurrentDateTime := Global.DateTime.CurrentDate + Global.DateTime.CurrentTime;
              Global.DateTime.FormattedCurrentDateTime := Global.DateTime.FormattedCurrentDate + ' ' + Global.DateTime.FormattedCurrentTime;
              Global.DateTime.LastDate := FormatDateTime('yyyymmdd', Yesterday);
              Global.DateTime.FormattedLastDate := FormattedDateString(Global.DateTime.LastDate);
              Global.DateTime.NextDate := FormatDateTime('yyyymmdd', Tomorrow);
              Global.DateTime.FormattedNextDate := FormattedDateString(Global.DateTime.NextDate);
              Global.DateTime.DayOfWeekKR := DayOfWeekName(Now);
              Global.ResetLogFile;
            end;

            if (Global.DateTime.CurrentTime <> sCurrTime) then
            begin
              Global.DateTime.CurrentTime := sCurrTime;
              Global.DateTime.FormattedCurrentTime := FormattedTimeString(sCurrTime);
              Global.DateTime.CurrentDateTime := Global.DateTime.CurrentDate + Global.DateTime.CurrentTime;
              Global.DateTime.FormattedCurrentDateTime := Global.DateTime.FormattedCurrentDate + ' ' + Global.DateTime.FormattedCurrentTime;
              SendToMainForm(CPC_MAIN_STATUS, CMP_REFRESH_CLOCK);
              if Global.Log.IsDelete and (not Global.Log.Deleted) then
                Global.DeleteLog;
            end;

            Inc(FCheckCount);
            if (FCheckCount >= 30) then
            try
              if Global.UserInfo.Logged and
                 not BPDM.MariaDB.Connected then
                SendToMainForm(CPC_MAIN_STATUS, CMP_GAME_SERVER_DB_LOST);
            finally
              FCheckCount := 0;
            end;

            if (not Global.Config.CheckAutoReboot) and
               (not Global.Config.AutoRebootIgnored) and
               (Copy(Global.DateTime.FormattedCurrentTime, 1, 5) = Global.Config.AutoRebootTime) then
            begin
              Global.Config.CheckAutoReboot := True;
              SendToMainForm(CPC_REBOOT);
            end;

            if Global.WeatherInfo.Enabled and
               Global.MasterUpdated.Downloaded and
               (MinutesBetween(FLastWorkedWeather, Now) >= 30) then
            begin
              FLastWorkedWeather := Now;
              BPDM.GetWeatherInfo;
            end;
          end);
      finally
        FWorking := False;
      end;
    end;

    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

{ TReceiptInfo }

constructor TReceiptInfo.Create;
begin
  SignImage := TMemoryStream.Create;
  Clear;
end;

destructor TReceiptInfo.Destroy;
begin
  SignImage.Free;

  inherited;
end;

procedure TReceiptInfo.Clear;
begin
  SaleAmt := 0;
  DCAmt := 0;
  KeepAmt := 0;
  CashPayAmt := 0;
  CardPayAmt := 0;
  FChargeAmt := 0;
  CouponAmt := 0;
  PaycoReady := False;
  SaleMemo := '';
  PendingReceiptNo := '';
  if Assigned(SignImage) then
    SignImage.Clear;
end;

function TReceiptInfo.GetReceiveAmt: Integer;
begin
  // 받은금액 = (현금결제금액 + 카드결제금액)
  Result := (CashPayAmt + CardPayAmt);
end;

function TReceiptInfo.GetVAT: Integer;
begin
  //부가가치세
  Result := (ChargeAmt - Floor(ChargeAmt / 1.1));
  if (Result < 0) then
    Result := 0;
end;

function TReceiptInfo.GetChangeAmt: Integer;
begin
  // 지급할 거스름돈 = (받은금액 - 청구금액)
  Result := (ReceiveAmt - ChargeAmt);
  if (Result < 0) then
    Result := 0;
end;

function TReceiptInfo.GetUnPaidAmt: Integer;
begin
  // 미결제금액 = (청구금액 - (받은금액))
  Result := (ChargeAmt - ReceiveAmt);
  if (Result < 0) then
    Result := 0;
end;

{ TReceiptItemInfo }

procedure TReceiptItemInfo.Clear;
begin
  ReceiptNo := '';
  SaleAmt := 0;
  DCAmt := 0;
  UsePoint := 0;
  CouponAmt := 0;
  KeepAmt := 0;
  VAT := 0;
  ChargeAmt := 0;
  ReceiveAmt := 0;
  ChangeAmt := 0;
  SaleMemo := '';
end;

{ TPaymentItemRec }

procedure TPaymentItemRec.Clear;
begin
  Seq := 0;
  ReceiptNo := '';
  PaySeq := 0;
  PayMethod := 0;
  IsApproval := False;
  IsManualInput := False;
  VanCode := '';
  TID := '';
  ApproveNo := '';
  ApproveAmt := 0;
  OrgApproveNo := '';
  OrgApproveDate := '';
  VAT := 0;
  InstallMonth := 0;
  CashEntity := 0;
  CardNo := '';
  TradeNo := '';
  TradeDate := '';
  IssuerCode := '';
  ISsuerName := '';
  BuyerDiv := '';
  BuyerCode := '';
  BuyerName := '';
  PaymentMemo := '';
end;

{ TCustomDeviceSetting }

constructor TCustomDeviceSetting.Create;
begin
  inherited;

  FReadData := '';
end;

destructor TCustomDeviceSetting.Destroy;
begin
  if Assigned(ComDevice) then
  begin
    ComDevice.Close;
    ComDevice.Free;
  end;

  inherited;
end;

procedure TCustomDeviceSetting.ComDeviceOnRxChar(Sender: TObject);
begin
  if Assigned(FCallbackProc) then
    FCallbackProc(Sender)
  else
  begin

  end;
end;

procedure TCustomDeviceSetting.Close;
begin
  if Enabled and
     Assigned(ComDevice) then
  try
    FCallbackProc := nil;
    ComDevice.OnRxChar := nil;
    ComDevice.Close;
  except
  end;
end;

procedure TCustomDeviceSetting.Open(AProc: TCustomDeviceCallbackProc);
begin
  if Enabled and
     Assigned(ComDevice) then
  try
    FCallbackProc := AProc;
    ReadData := '';
    ComDevice.Close;
    if (Port >= 10) then
      ComDevice.DeviceName := '\\.\COM' + IntToStr(Port)
    else
      ComDevice.DeviceName := 'COM' + IntToStr(Port);
    ComDevice.BaudRate := GetBaudRate(Baudrate);
    ComDevice.Parity := TParity.paNone;
    ComDevice.DataBits := TDataBits.db8;
    ComDevice.StopBits := TStopBits.sb1;
    ComDevice.OnRxChar := ComDeviceOnRxChar;
    ComDevice.Open;
  except
  end;
end;

procedure TCustomDeviceSetting.SetOwnerId(const AValue: ShortInt);
begin
  FOwnerId := AValue;
end;

{ TLaneInfo }

procedure TLaneInfo.Clear;
begin
  LaneCount := 0;
  FSelectedLaneNo := 0;
  FReadyCount := 0;
  FReservedCount := 0;
  FBusyCount := 0;
  FSelectedLanes.Clear;
end;

procedure TLaneInfo.LanesClear;
begin
  for var I: ShortInt := 0 to Pred(LaneCount) do
  begin
    Lanes[I].LaneNo := 0;
    Lanes[I].LaneName := '';
    Lanes[I].LaneStatus := 0;
    Lanes[I].AssignLaneNo := 0;
//    Lanes[I].AssignIndex := 0;
    Lanes[I].FrameNo := 0;
    Lanes[I].DeviceId := '';
    Lanes[I].LaneMemo := '';
  end;
end;

function TLaneInfo.SelectedLaneList: string;
begin
  Result := '';
  SelectedLanes.Sort;
  for var I := 0 to Pred(SelectedLanes.Count) do
    Result := Result + Format('%s%d', [IfThen(Result.IsEmpty, '', ','), SelectedLanes.Item[I]]);
end;

function TLaneInfo.AssignLaneNoList: string;
var
  LIndex: Shortint;
begin
  Result := '';
  SelectedLanes.Sort;
  for var I := 0 to Pred(SelectedLanes.Count) do
  begin
    LIndex := LaneIndex(SelectedLanes.Item[I]);
    if (LIndex < 0) then
      Continue;
    if (Result <> '') then
      Result := Result + ', ';
    Result := Result + Format('%d', [Lanes[LIndex].AssignLaneNo]);
  end;
end;

function TLaneInfo.LaneIndex(const ALaneNo: ShortInt): ShortInt;
var
  LLaneNo: ShortInt;
begin
  Result := -1;
  LLaneNo := ALaneNo;
  if (ALaneNo = -1) then
    LLaneNo := SelectedLaneNo;
  for var I: Integer := 0 to Pred(LaneCount) do
    if (Lanes[I].LaneNo = LLaneNo) then
    begin
      Result := I;
      Break;
    end;
  if (Result = -1) then
    Result := 0;
end;

function TLaneInfo.AssignLaneNo(const ALaneNo: ShortInt): ShortInt;
var
  LLaneNo: ShortInt;
begin
  if (ALaneNo = 0) then
    Result := ALaneNo
  else
  begin
    Result := -1;
    LLaneNo := ALaneNo;
    for var I: ShortInt := 0 to Pred(LaneCount) do
      if (Lanes[I].LaneNo = LLaneNo) then
      begin
        Result := Lanes[I].AssignLaneNo;
        Break;
      end;
    if (Result = -1) then
      Result := ALaneNo;
  end;
end;

procedure TLaneInfo.SetSelectedLaneNo(const AValue: ShortInt);
begin
  if (FSelectedLaneNo <> AValue) then
  begin
    FSelectedLaneNo := AValue;
//    BPDM.RefreshSelectedReceiptList(AssignLaneNo(FSelectedLaneNo), LResMsg);
  end;
end;

function TLaneInfo.GetLaneCount: ShortInt;
begin
  Result := Length(Lanes);
end;

procedure TLaneInfo.SetLaneCount(const AValue: ShortInt);
begin
  if (LaneCount <> AValue) then
    SetLength(Lanes, AValue);
end;

procedure TLaneInfo.SetReadyCount(const AValue: Integer);
begin
  if (FReadyCount <> AValue) then
  begin
    FReadyCount := AValue;
    SendToMainForm(CPC_READY_COUNT, FReadyCount);
  end;
end;

procedure TLaneInfo.SetReservedCount(const AValue: Integer);
begin
  if (FReservedCount <> AValue) then
  begin
    FReservedCount := AValue;
    SendToMainForm(CPC_RESERVED_COUNT, FReservedCount);
  end;
end;

procedure TLaneInfo.SetBusyCount(const AValue: Integer);
begin
  if (FBusyCount <> AValue) then
  begin
    FBusyCount := AValue;
    SendToMainForm(CPC_BUSY_COUNT, FBusyCount);
  end;
end;

{ TProdItemRec }

procedure TProdItemRec.Clear;
begin
  Seq := 0;
  AssignLaneNo := 0;
  AssignNo := '';
  BowlerId := '';
  ProdCode := '';
  ProdDiv := '';
  ProdDetailDiv := '';
  ProdName := '';
  OrderQty := 0;
  ProdAmt := 0;
  DCAmt := 0;
  UsePoint := 0;
  IsService := False;
  MemberNo := '';
  MemberName := '';
  UseGameCount := 0;
  UseGameMin := 0;
  LockerNo := 0;
  LockerName := '';
  KeepAmt := 0;
  PurchaseMonth := 0;
  UseStartDate := '';
end;

{ TLockerInfo }

procedure TLockerInfo.Clear;
begin
  ItemCount := 0;
end;

function TLockerInfo.GetItemIndex(const ALockerNo: Integer): Integer;
begin
  Result := -1;
  for var I: Integer := 0 to Pred(GetItemCount) do
    if (Items[I].LockerNo = ALockerNo) then
    begin
      Result := I;
      Break;
    end;
end;

function TLockerInfo.GetItemCount: Integer;
begin
  Result := Length(Items);
end;

procedure TLockerInfo.SetItemCount(const AValue: Integer);
begin
  if (ItemCount <> AValue) then
    SetLength(Items, AValue);
end;

{ TMemberInfoRec }

procedure TMemberInfoRec.Clear;
begin
  Selected := False;
  MemberNo := '';
  MemberName := '';
  ClubSeq := 0;
  ClubName := '';
  MemberDiv := '';
  MemberDivName := '';
  MemberGroupCode := '';
  MemberGroupName := '';
  SexDiv := CO_SEX_ALL;
  SexDivName := '';
  Birthday := '';
  TelNo := '';
  CarNo := '';
  Email := '';
  ZipNo := '';
  Addr := '';
  Addr2 := '';
  SavePoint := 0;
  AdAgree := False;
  MemberMemo := '';
  QRCode := '';
  FPHash := '';
  LockerList := '';
  LockerExpiredDate := '';
  SelectLockerNo := 0;
  SelectLockerName := '';
  UseStartDate := '';
  PurchaseMonth := 0;
  if Assigned(PhotoStream) then
    PhotoStream.Clear;
end;

{ TPluManager }

constructor TPluManager.Create;
begin
  FGroupItems := TList.Create;
end;

destructor TPluManager.Destroy;
begin
  for var I: Integer := 0 to Pred(GetGroupCount) do
    ClearItems(I);
  ClearGroup;

  inherited;
end;

function TPluManager.AddGroup(const AProdDetailDiv, AProdDetailDivName: string): Integer;
var
  PG: PPluGroup;
begin
  Result := IndexOfGroupCode(AProdDetailDiv);
  if (Result < 0) then
  begin
    New(PG);
    with PG^ do
    try
      ProdDetailDiv := AProdDetailDiv;
      ProdDetailDivName := AProdDetailDivName;
      ItemList := TList.Create;
      FGroupItems.Add(PG);
      Result := Pred(FGroupItems.Count);
    except
      Dispose(PG);
    end;
  end;
end;

function TPluManager.AddItem(const AGroupIndex: Integer; const AProdDiv, AProdCode: string): Integer;
var
  PI: PPluItem;
  LDataSet: TDataSet;
  LDetailDiv, LProdName, LSaleZoneCode, LStartTime, LEndTime, LLayerCode, LLayerName, LSexDivName: string;
  LProdAmt, LUseGameCount, LUseGameMin: Integer;
  LGameDiv, LSexDiv: ShortInt;
  LTodayYN, LUseYN: Boolean;
begin
  Result := -1;
  if (AProdDiv = CO_PROD_GAME) then
    LDataSet := BPDM.QRProdGame
  else if (AProdDiv = CO_PROD_LOCKER) then
    LDataSet := BPDM.QRProdLocker
  else if (AProdDiv = CO_PROD_RENT) then
    LDataSet := BPDM.QRProdRent
  else if (AProdDiv = CO_PROD_MEMBERSHIP) then
    LDataSet := BPDM.QRProdMembership
  else
    LDataSet := BPDM.QRProdGeneral;

  with LDataSet do
  begin
    if not Locate('prod_cd', AProdCode, []) then
      Exit;
    LDetailDiv := FieldByName('prod_detail_div').AsString;
    LProdName := FieldByName('prod_nm').AsString;
    LProdAmt  := FieldByName('prod_amt').AsInteger;
    LSaleZoneCode := FieldByName('sale_zone_code').AsString;
    LUseYN := FieldByName('use_yn').AsBoolean;
    LUseGameCount := 0;
    LUseGameMin := 0;
    LSexDiv := CO_SEX_ALL;
    LTodayYN := True; //Default

    if (AProdDiv = CO_PROD_GAME) then
    begin
      LGameDiv := FieldByName('game_div').AsInteger;
      LStartTime := FieldByName('apply_start_tm').AsString;
      LEndTime := FieldByName('apply_end_tm').AsString;
      LTodayYN := FieldByName('today_yn').AsBoolean;
    end
    else if (AProdDiv = CO_PROD_MEMBERSHIP) then
    begin
      LGameDiv := FieldByName('game_div').AsInteger;
      LTodayYN := FieldByName('today_yn').AsBoolean;
      LUseGameCount := FieldByName('use_game_cnt').AsInteger;
      LUseGameMin := FieldByName('use_game_min').AsInteger;
    end
    else if (AProdDiv = CO_PROD_LOCKER) and
            (LDetailDiv = CO_PROD_DETAIL_LOCKER) then
    begin
      LLayerCode := FieldByName('locker_layer_code').AsString;
      LLayerName := GetLockerLayerName(LLayerCode);
      LSexDiv := FieldByName('sex_div').AsInteger;
      LSexDivName := GetSexDivName(LSexDiv);
    end;
  end;

  Result := IndexOfProdCode(AGroupIndex, AProdCode);
  if (Result < 0) then
  begin
    New(PI);
    with PI^ do
    try
      PI^.ProdDiv := AProdDiv;
      PI^.ProdDetailDiv := LDetailDiv;
      PI^.ProdCode := AProdCode;
      PI^.ProdName := LProdName;
      PI^.ProdAmt := LProdAmt;
      PI^.SaleZoneCode := LSaleZoneCode;
      PI^.GameDiv := LGameDiv;
      PI^.ApplyStartTime := LStartTime;
      PI^.ApplyEndTime := LEndTime;
      PI^.UseGameCount := LUseGameCount;
      PI^.UseGameMin := LUseGameMin;
      PI^.ExpireDay := '';
      PI^.LockerLayerCode := LLayerCode;
      PI^.LockerLayerName := LLayerName;
      PI^.SexDiv := LSexDiv;
      PI^.SexDivName := LSexDivName;
      PI^.TodayYN := LTodayYN;
      PI^.UseYN := LUseYN;
      GetGroup(AGroupIndex).ItemList.Add(PI);
      Result := Pred(GetGroup(AGroupIndex).ItemList.Count);
    except
      Dispose(PI);
    end;
  end;
end;

procedure TPluManager.ClearGroup;
var
  PG: PPluGroup;
  PI: PPluItem;
  I, J: Integer;
begin
  for I := 0 to Pred(FGroupItems.Count) do
  begin
    PG := GetGroup(I);
    if (PG <> nil) then
    begin
      for J := 0 to Pred(PG.ItemList.Count) do
      begin
        PI := GetItem(I, J);
        if (PI <> nil) then
          Dispose(PI);
      end;

      PG.ItemList.Clear;
      Dispose(PG);
    end;
  end;
  FGroupItems.Clear;
end;

procedure TPluManager.ClearItems(const AGroupIndex: Integer);
var
  PI: PPluItem;
begin
  for var I: Integer := 0 to Pred(GetGroup(AGroupIndex).ItemList.Count) do
  begin
    PI := GetItem(AGroupIndex, I);
    if (PI <> nil) then
      Dispose(PI);
  end;
  GetGroup(AGroupIndex).ItemList.Clear;
end;

function TPluManager.GetGroup(const AGroupIndex: Integer): PPluGroup;
begin
  Result := FGroupItems.Items[AGroupIndex];
end;

function TPluManager.GetGroupCount: Integer;
begin
  Result := FGroupItems.Count;
end;

function TPluManager.GetGroupPageCount: Integer;
begin
  Result := Ceil(FGroupItems.Count / FGroupPerPage);
end;

function TPluManager.GetItem(const AGroupIndex, AItemIndex: Integer): PPluItem;
begin
  Result := PPluGroup(FGroupItems.Items[AGroupIndex]).ItemList.Items[AItemIndex];
end;

function TPluManager.GetItemCount(const AGroupIndex: Integer): Integer;
begin
  Result := PPluGroup(FGroupItems.Items[AGroupIndex]).ItemList.Count;
end;

function TPluManager.GetItemPageCount(const AGroupIndex: Integer): Integer;
begin
  Result := Ceil(PPluGroup(FGroupItems.Items[AGroupIndex]).ItemList.Count / FItemPerPage);
end;

function TPluManager.IndexOfGroupCode(const AProdDetailDiv: string): Integer;
begin
  Result := -1;
  for var I: Integer := 0 to Pred(FGroupItems.Count) do
    if (GetGroup(I).ProdDetailDiv = AProdDetailDiv) then
    begin
      Result := I;
      Break;
    end;
end;

function TPluManager.IndexOfProdCode(const AGroupIndex: Integer; const AProdCode: string): Integer;
begin
  Result := -1;
  for var I: Integer := 0 to Pred(GetGroup(AGroupIndex).ItemList.Count) do
    if (CompareText(GetItem(AGroupIndex, I).ProdCode, AProdCode) = 0) then
    begin
      Result := I;
      Break;
    end;
end;

procedure TPluManager.SetGroup(const AGroupIndex: Integer; APointer: PPluGroup);
var
  PG: PPluGroup;
begin
  PG := GetGroup(AGroupIndex);
  if (PG <> APointer) then
  begin
    if (PG <> nil) then
      Dispose(PG);

    FGroupItems.Items[AGroupIndex] := APointer;
  end;
end;

procedure TPluManager.SetGroupPage(const ANewGroupPage: Integer; ACallBackProc: TPluGroupChangeCallBackProc);
begin
  FActiveGroupPage := ANewGroupPage;
  if Assigned(ACallBackProc) then
    ACallBackProc(FActiveGroupPage);
end;

procedure TPluManager.SetItem(const AGroupIndex, AItemIndex: Integer; APointer: PPluItem);
var
  PI: PPluItem;
begin
  PI := GetItem(AGroupIndex, AItemIndex);
  if (PI <> APointer) then
  begin
    if (PI <> nil) then
      Dispose(PI);

    PPluGroup(FGroupItems.Items[AGroupIndex]).ItemList.Items[AItemIndex] := APointer;
  end;
end;

procedure TPluManager.SetItemPage(const AGroupIndex, ANewItemPage: Integer; ACallBackProc: TPluItemPageChangeCallBackProc);
begin
  FActiveItemPage := ANewItemPage;
  if Assigned(ACallBackProc) then
    ACallBackProc(AGroupIndex, FActiveItemPage);
end;

{ TCouponItemRec }

procedure TCouponItemRec.Clear;
begin
  CouponName := '';
  QRCode := '';
  DCDiv := '';
  DCValue := 0;
  ApplyDCAmt := 0;
  MemberNo := '';
  StartDate := '';
  ExpireDate := '';
  UseCnt := 0;
  UsedCnt := 0;
  EventName := '';
  DCCondDiv := '';
  ProductDiv := '';
  GameProdDiv := '';
  UseYN := '';
  UseStatus := '';
end;

{ TBowlerRec }

procedure TBowlerRec.Clear;
begin
  BowlerId := '';
  BowlerName := '';
  EntrySeq := 0;
  Handy := 0;
  MemberNo := '';
  MembershipSeq := 0;
  MembershipUseCount := 0;
  MembershipUseMin := 0;
  FeeDiv := '';
  GameCount := 0;
  GameMin := 0;
  ShoesRent := False;
  ShoesFree := False;
  PaymentType := 0;
  ProdInfo.Clear;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

initialization
  InitializeCriticalSection(LogCS);
finalization
  DeleteCriticalSection(LogCS);
end.
