unit uStore;

interface

uses
  uStruct, Uni,
  Generics.Collections;

type
  TStore = class
  private
  public
    procedure SetConnection; virtual; abstract;
    // 회원등록
    function AddMember: Boolean; virtual; abstract;
    // 회원데이터를 가져온다.
    function GetAllMmeberInfoVersion: string; virtual; abstract;
    function GetAllMemberInfo: TList<TMemberInfo>; virtual; abstract;
    // 회원 정보를 가져온다. CARD 또는 QR 회원
    //function GetMemberInfoApi(ACardNo: string; out AMsg: string): TMemberInfo; virtual; abstract;
    // 회원의 상품 리스트를 가져온다
    function GetMemberProductList(ACardNo, ACode, ADate: string): TList<TProductInfo>; virtual; abstract;
    // 회원의 정지 유무 확인
    function GetIsStopMemberStatus: Boolean; virtual; abstract;
    // 회원의 휴회 유무 확인
    function GetProductNotStartDateNot: Boolean; virtual; abstract;
    // 입장요일체크
    function GetProductUseDayCheck(AProductCode: string): Boolean; virtual; abstract;
    // 입장시간체크
    function GetProductUseTimeCheck(AProductCode: string): Boolean; virtual; abstract;
    // 타석 마스터 정보를 읽어 온다.
    function GetTeeBoxMasterVersion: string; virtual; abstract;
    function GetTeeBoxMaster: TList<TTeeBoxInfo>; virtual; abstract;
    // 타석 정보를 읽어 온다.
    function GetTeeBoxPlayingInfo: TList<TTeeBoxInfo>; virtual; abstract;
    //
    function Connect: Boolean; virtual; abstract;
    //
    function DisConnect: Boolean; virtual; abstract;
    // 타석 상품을 가져온다.
    function GetTeeBoxProductListVersion: string; virtual; abstract;
    function GetTeeBoxProductList: TList<TProductInfo>; virtual; abstract;
    // 일일 타석 상품을 가져온다.
    function GetTeeBoxDayProductList: TList<TProductInfo>; virtual; abstract;
    // OAuth 인증
    function OAuth_Certification: Boolean; virtual; abstract;
    // 환경설정
    function GetConfigVersion: string; virtual; abstract;
    function GetConfig: Boolean; virtual; abstract;
    // 가맹점 정보 조회
    function GetStoreInfo: Boolean; virtual; abstract;
    // 타석 홀드
    function TeeBoxHold(AIsHold: Boolean = True): Boolean; virtual; abstract;
    function TeeBoxListReservation: Boolean; virtual; abstract;
    // 타석 예약 등록
    function TeeBoxReservation: Boolean; virtual; abstract;

    //chy move
    function TeeBoxReserveMove: Boolean; virtual; abstract;

    //chy newmember
    function AddNewMember: Boolean; virtual; abstract;
    function AddNewMemberQR: Boolean; virtual; abstract;

    // 타석 예약 조회
    function TeeBoxReservationInfo(ACode: string): Boolean; virtual; abstract;
    // 매출 등록
    function SaveSaleInfo: Boolean; virtual; abstract;
    // 프로모션 확인
    function SearchPromotion(ACoupon: string): Boolean; virtual; abstract;
    // 광고 목록 조회
    function GetAdvertisVersion: string; virtual; abstract;
    procedure SearchAdvertisList; virtual; abstract;
    function SendAdvertisCnt(ASeq: string): Boolean; virtual; abstract;
    //function SendAdvertisList: Boolean; virtual; abstract;
    // XGOLF회원 QR 등록
    function AddMemberXGOLFQR(ACode: string): Boolean; virtual; abstract;
    // 카드사 할인 체크
    function SearchCardDiscount(ACardNo, ACardAmt: string; out ACode, AMsg: string): Currency; virtual; abstract;

  end;

implementation

end.

