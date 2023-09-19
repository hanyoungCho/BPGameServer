unit uStruct;

interface

uses
  FMX.Graphics, Classes, Generics.Collections;

type
  TMemberInfo = record
    Name: string;
    Code: string;
    Sex: string;
    BirthDay: string;
    MemberDiv: String; //신규등록후 학생여부
    MobileNo: string;
    //Email: string;
    //CarNo: string;
    //Addr1: string;
    //Addr2: string;
    QRCode: string;
    //FingerStr: AnsiString;
    SavePoint: Integer; //포인트
    Use: Boolean;
    {
    가맹점 코드	store_cd
    회원 이름	member_nm
    성별 구분	sex_div
    생년월일	birthday
    휴대폰 번호	mobile_no
    이메일	email
    우편번호	zipno
    주소	addr
    상세주소	addr2
    클럽 순번	club_seq
    회원 고객 구분	member_customer_code
    회원 단체 구분	member_group_code
    지문 해쉬	fingerprint_hash
    사진 인코딩	photo_encoding
    메모	memo
    }
  end;

  TGameProductInfo = record // 요금제
    ProdCd: String;           //상품 코드
    ProdNm: string;           //상품 명
    ProdDetailDiv: string;    //상품 상세 구분 101:이용권, 102:회원권
    ProdDetailDivNm: string;  //상품 상세 구분명
    GameDiv: string;           //게임 구분 1:게임제, 2:시간제, 3:할인제
    FeeDiv: string;           //요금제 구분 01: 일반, 02:회원, 03:학생, 04: 클럽 공통코드 참조
    UseGameCnt: Integer;      //이용 게임수
		UseGameMin: Integer;      //이용 게임 시간(분)
    ShoesFreeYn: string;      //대화료 무료 여부 ksj 230728 api 수정에 맞춰 추가
		SaleZoneCode: string;     //판매처 구분
    {
    ApplyDowString: string; //적용 요일 문자열
    ApplyStartTime: string; //적용 시작 시각
    ApplyEndTime: string;   //적용 종료 시각
    }
    ProdAmt: Integer;        //상품 금액
  end;

  TMemberShipProductInfo = record // 회원판매 상품
    ProdCd: String;           //상품 코드
    ProdNm: string;           //상품 명
    ProdDetailDiv: string;    //상품 상세 구분 501: 게임회원권, 502: 시간회원권, 503 : 우대회원권
    ProdDetailDivNm: string;  //상품 상세 구분명
    DiscountFeeDiv: string;   //할인 요금제 구분 01 : 없음, 02 : 회원, 03 : 학생, 04 : 클럽
    ProdAmt: Integer;         //상품 금액
    UseGameCnt: Integer;      //이용 게임수
    UseGameMin: Integer;      //이용 게임 시간(분)

    ExpireDay: Integer;       //유효기간
    ProdBenefits: String;     //상품 햬택
    ShoesFreeYn: String;      //대화료 무료 여부
    SavePointRate: Integer;   //적립 포인트 율(%)

    SaleZoneCode: string;     //판매처 구분
    UseYn: String;
    DelYn: String;
  end;

	TMemberProductInfo = record // 회원보유 상품
    MembershipSeq: Integer;   //회원권 구매순번
    ProdCd: String;           //상품 코드
    ProdNm: string;           //상품 명
		ProdDetailDiv: string;    //상품 상세 구분 501: 게임회원권, 502: 시간회원권, 503 : 우대회원권
    GameDiv: String;          // 게임 구분	"1:게임제, 2:시간제, 3:할인제
    DiscountFeeDiv: string;   //할인 요금제 구분

    PurchaseGameCnt: Integer;	 //구매 이용 게임수
		RemainGameCnt: Integer;	     //잔여 이용 게임수
		PurchaseGameMin: Integer;	 //구매 게임 시간(분)
		RemainGameMin: Integer;		   //잔여 게임 시간(분)
		//PurchaseDatetime: String;	 //구매 일시

    StartDate: String;
    EndDate: String;
    ProdBenefits: String;     //상품 햬택
    ShoesFreeYn: String;      //대화료 무료 여부
    SavePointRate: Integer;   //적립 포인트 율(%)
  end;

  TDiscount = record
    DcType: String; //G: 요금제, T: 시간제, P: 포인트
    DcValue: Integer; //DcType :G - 게임수, t시간,p포인트
    DcAmt: Integer; //최종 할인금액
    //ProductCode: string;
  end;

  TSaleData = record
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String;
    MemberInfo: TMemberInfo;
    //MemberYN: Boolean;
    //GameCnt: String;
    LaneNo: Integer;
    ShoesUse: String;

    SaleID: Integer;                  // 순서
    GameProduct: TGameProductInfo;    // 요금제 상품
    SaleQty: Integer;                 // 판매수량
    SalePrice: Currency;              // 판매금액 - 슈즈별도
    DcProduct: TMemberProductInfo;    // 회원상품
    DcAmt: Currency;                  // 할인금액
    DiscountList: TList<TDiscount>;

    PaySelect: Boolean; //결제 선택 여부
    PayResult: Boolean; //결제 완료 여부
    ReceiptNo: string;   //영수증 번호
  end;

  TLaneInfo = record
    LaneNo: Integer;
    LaneNm: String;
    //PinSetterId: String;
    //HoldUse: Boolean;
    HoldUser: String; //ksj 230911
    UseYn: Boolean;
    Status: String;

    GameDiv: String;
    GameType: String;
    LeagueYn: String;
    //StartDateTIme: String;
    ExpectedEndDatetime: String; //예상종료시간
    RemainMin: String; //예상종료시간에 따른 잔여시간

    //ToCnt: Integer;
    GameCnt: Integer;
    GameFin: Integer;
    //CtlYn: Boolean;
    //ChgYn: Boolean;    //DB 데이타 적용여부
    //Assign: TAssignInfo;
  end;

  TGameInfo = record
    GameDiv: String; //1:게임제, 2:시간제
    BowlerCnt: Integer;
    GameCnt: Integer;
    LaneUse: String;
    Lane1: Integer; //레인 표시용
    Lane2: Integer; //레인 표시용
    LeagueUse: Boolean;
    AssignNo: String; //배정요청이후 배정번호
  end;
  {
  TBowlerInfo = record
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String;
    GameCnt: String;
    LaneNo: String;
    ShoesUse: String;
    GamePrice: Integer;
    TotalPrice: Integer;
  end;
  }

  TPrintConfig = record
    Port: Integer;
    BaudRate: Integer;
    Version: string;
    Top1: string;
    Top2: string;
    Top3: string;
    Top4: string;
    Bottom1: string;
    Bottom2: string;
    Bottom3: string;
    Bottom4: string;
  end;

  TAdvertisement = record
    {
    Seq: Integer;
    Name: string;
    FileUrl: string;
    FileUrl2: string;
    FilePath: string;
    FilePath2: string;
    Position: string;
    ProductAddYn: string; //추천회원권
    ProductAddList: Array of String;
    StartDate: string;
    EndDate: string;
    Show_Week: string;
    Show_Start_Time: string;
    Show_End_Time: string;
    Show_Interval: string;
    Show_YN: Boolean;
    ShowCnt: Integer;
    Image: TBitmap;
    }

AdvertiseNm: String; //     광고 명						S		50
view_div: String; // 노출 위치						S		1		1:상단, 2:하단, 3:팝업
view_start_date: String; // 노출 시작일						S		10	2022-10-01	yyyy-mm-dd
view_end_date: String; // 노출 종료일						S		10	2025-12-31	yyyy-mm-dd
view_dow_string: String; // 노출 요일 문자열						S		7	1111111	월화수목금토일
view_start_time: String; // 노출 시작 시간						S		8	05:10:00	hh:mi:ss
view_end_time: String; // 노출 종료 시간						S		8	23:10:00	hh:mi:ss
view_sec: Integer; // 노출 시간(초)						I
//chg_datetime 수정 일시						S		19
//file_list 광고 파일 리스트						A				1개의 광고에 여러개의 파일 있음. 슬라이딩용
			file_type: String; //			S		1	1	1:이미지, 2:동영상, 공통코드 참조
			file_url: String; //			S			https://test.bowlingpick.com/upload/aa.png

      FilePath: string;
      Image: TBitmap;
  end;

  TAgreement = record
    OrdrNo: Integer;
    AgreementDiv: string;
    FileUrl: string;
    FilePath: string;
    Image: TBitmap;
  end;

implementation

end.
