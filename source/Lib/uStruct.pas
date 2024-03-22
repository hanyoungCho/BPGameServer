unit uStruct;

interface

uses
  System.Generics.Collections, Classes;

const
  BUFFER_SIZE = 255;

type
  //설정정보
  TConfig = record
    StoreCd: String;
    Token: AnsiString;
    TerminalId: String;
    TerminalPw: String;

    Port: integer;
    Baudrate: integer;

    ApiUrl: string;
    TcpPort: Integer;
    DBPort: Integer;
    LaneStart: Integer;
    LaneEnd: Integer;
    PrepareMin: Integer;

    Emergency: Boolean; //긴급배정모드
  end;

  //매장정보
  TStoreInfo = record
    StoreCd: String;
    StoreNm: String;
    SaleStartTime: String;
    SaleEndTime: String;
    PerGameMin: Integer;
    MinusFrame: Integer;

    DBInitTime: String; //데이타 초기화
  end;

  TBowlerStatus = record //응답데이타
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String; //게이머 정보 성,이름1, 이름2

    FrameTo: Integer; //프레임 차례
    FramePin: array[1..21] of String;
    FrameScore: array[1..10] of Integer;
    FrameLane: array[1..10] of Integer;

    TotalScore: Integer; //누적점수
    ToCnt: Integer;    //게이머 투 횟수
    EndGameCnt: Integer; //완료된 게임수

    Status1: String; // C0=지금 투할 게이머, 80=대기, 02 = 일시정지(강제), 20=일시정지(리그), E0=?
    ResidualGameTime: Integer; // 잔여시간
    ResidualGameCnt: Integer; // 잔여게임수
    Status3: String; // 상태0x20 = 선불, 0x00 = 무제한. 0xA0 = , 0x80=게임종료
  end;

  TGameStatus = record //응답데이타
    {
    1~8 Byte : gamedata (String)
    9번째 Byte : 레인번호
    10, 11번째 Byte : 데이터 길이 (12번째 Byte 부터 CRC까지)
    12번째 Byte : 레인번호
    13번째 Byte : 20(일반게임시 고정). 20<->28(리그게임시시 NEXT GAME 마다 바뀜???)
    14번째 Byte : 게임상태(A8=진행, 88=종료)
    15번째 Byte : 00=일반게임, 01=리그게임
    16번째 Byte : 01=369게임, 02=8핀게임, 03=9핀게임, 00=일반게임
    17번째 Byte : ??
    18번째 Byte : ??
    19번째 Byte : 게이머 수
    20번째 Byte : 직전 투 게이머 번호
    21번째 Byte : ?? (0B명령으로 상태 설정)
    22번째 Byte : 전체 게이머 누적점수 (L Byte)
    23번째 Byte : 전체 게이머 누적점수 (H Byte)
    24번째 Byte :
    25번째 Byte :
    26번째 Byte : 직전 투 게이머 프레임 점수 (상위 4Byte. 순수 핀점수)
    27번째 Byte : 0A (고정?)
    }
    Receive: Boolean;
    LaneNo: Integer;
    b12: Integer;
    Status: String;
    League: Integer;
    GameType: Integer;
    BowlerCnt: Integer;
    b19: Integer;
    b20: Integer;
    b26: Integer;
    //BowlerToSeq: Integer;
    BowlerList: array[1..6] of TBowlerStatus;
  end;

  TBowlerInfo = record
    ParticipantsSeq: Integer; //대회 참가자 순번
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String; //게이머 정보 성,이름1, 이름2
    MemberNo: String; //저장용
    GameCnt: Integer;   //게임 설정수량
    GameMin: Integer;   //게임시간 설정

    GameStart: Integer;
    GameFin: Integer;

    MembershipSeq: Integer;     //회원권 구매 순번
    MembershipUseCnt: Integer;  //회원권 사용 갯수
    MembershipUseMin: Integer;  //회원권 사용 시간(분)

    ProductCd: String; //저장용
    ProductNm: String; //저장용
    PaymentType: Integer; //0:후불, 1:선불
    FeeDiv: String;     //요금제구분
    Handy: Integer; //핸디
    ShoesYn: String;
    //ReceiptNo: String; //영수증 번호
  end;

  TAssignInfo = record
    AssignDt: String;
    AssignSeq: Integer;
    AssignNo: String;
    AssignRootDiv: String; //배정 경로
    CommonCtl: Integer; //동시제어

    CompetitionSeq: Integer;
    //CompetitionLeagueYn: String;    //N:오픈게임 Y:리그게임
    LaneMoveCnt: Integer;
    MoveMethod: String;    //G:일반이동, B:크로스이동좌우, 크로스이동X : X
    TrainMin: Integer;    //연습시간
    CompetitionLane: Integer;

    LaneNo: Integer;
    GameSeq: Integer; //게임진행수 초기값0
    GameDiv: Integer;  //1:게임제, 2:시간제
    GameType: Integer; //0:10, 1:369, 2:8, 3:9
    LeagueYn: String;
    BowlerCnt: Integer;
    BowlerList: array[1..6] of TBowlerInfo;

    StartDatetime: String;
    EndDatetime: String;

    //TotalGameCnt: Integer;
    //TotalGameMin: Integer;
    ReserveDate: String; //예약시간
    ExpectdEndDate: String; //예상종료시간

    AssignStatus: Integer; //배정상태 - 0: 빈타석, 1:예약건, 2:홀드, 3:진행, 4: 미정, 5: 종료(미결제), 6: 종료, 7:취소
    PaymentResult: Integer; //결제완료여부
  end;

  //레인정보
  TLaneInfo = record
    LaneNo: Integer;
    LaneNm: String;
    PinSetterId: String;
    HoldUse: String;
    HoldUser: String;
    UseStatus: String;
    UseYn: Boolean;
    CtlYn: Boolean;
    ChgYn: Boolean;    //DB 데이타 적용여부
    NextYn: Boolean;
    //NextCtl: Boolean;
    Assign: TAssignInfo;
    Game: TGameStatus;
    GameCom: TGameStatus;

    ErrorCnt: Integer;
    ErrorYn: String;
  end;

  //배정 테이블
  TAssignInfoDB = record
    AssignDt: String;
    AssignSeq: Integer;
    AssignNo: String;
    CommonCtl: Integer;
    GameSeq: Integer;
    LaneNo: Integer;
    GameDiv: Integer;
    GameType: Integer;
    LeagueYn: String;
    AssignStatus: Integer;
    AssignRootDiv: String;
    StartDatetime: String;
    ReserveDate: String; //예약시간
    ExpectdEndDate: String; //예상종료시간
  end;

  //게임 테이블
  TGameInfoDB = record
    AssignDt: String;
    AssignSeq: Integer;
    GameSeq: Integer; //현재 진행중인 게임
    GameStatus: String;
    LastLaneNo: Integer;
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String;

    FramePin: array[1..21] of String;
    FrameScore: array[1..10] of Integer;
    //FrameLane: array[1..10] of Integer;
    
    TotalScore: Integer;
  end;

  TCompetitionInfo = record
    CompetitionSeq: Integer;
    LeagueYn: String;    //N:오픈게임 Y:리그게임
    LaneMoveCnt: Integer;
    MoveMethod: String;    //G:일반이동, B:크로스이동좌우, 크로스이동X : X
    TrainMin: Integer;

    Cnt: Integer;
    StartLane: Integer;
    EndLane: Integer;

    CompetitionEnd: Boolean; //대회종료
    CompetitionEndDate: TDateTime; //대회종료시간-> 30초후 배정종료위함.

    List: array of TAssignInfo;
  end;

  THoldInfo = record
    HoldUse: String;
    HoldUser: String;
  end;


  //예약목록 관리용
  TReserve = record
    LaneNo: Integer;
    ReserveList: TStringList; //TReserveInfo
  end;

  TReserveInfo = class
  private
    FAssignDt: String;
    FAssignSeq: Integer;
    FAssignNo: String;
    FCommonCtl: Integer;
    FLaneNo: Integer;
    FGameDiv: Integer;
    FGameType: Integer;
    FLeagueYn: String;

    FReserveDate: String; //예약시간
    FExpectdEndDate: String; //예상종료시간
    {
    FBowler_1: TReserveBowler;
    FBowler_2: TReserveBowler;
    FBowler_3: TReserveBowler;
    FBowler_4: TReserveBowler;
    FBowler_5: TReserveBowler;
    FBowler_6: TReserveBowler;
    }
  published
    property AssignDt: string read FAssignDt write FAssignDt;
    property AssignSeq: Integer read FAssignSeq write FAssignSeq;
    property AssignNo: string read FAssignNo write FAssignNo;
    property CommonCtl: Integer read FCommonCtl write FCommonCtl;
    property LaneNo: Integer read FLaneNo write FLaneNo;
    property GameDiv: Integer read FGameDiv write FGameDiv;
    property GameType: Integer read FGameType write FGameType;
    property LeagueYn: string read FLeagueYn write FLeagueYn;

    property ReserveDate: string read FReserveDate write FReserveDate;
    property ExpectdEndDate: string read FExpectdEndDate write FExpectdEndDate;
    {
    property Bowler_1: TReserveBowler read FBowler_1 write FBowler_1;
    property Bowler_2: TReserveBowler read FBowler_2 write FBowler_2;
    property Bowler_3: TReserveBowler read FBowler_3 write FBowler_3;
    property Bowler_4: TReserveBowler read FBowler_4 write FBowler_4;
    property Bowler_5: TReserveBowler read FBowler_5 write FBowler_5;
    property Bowler_6: TReserveBowler read FBowler_6 write FBowler_6;
    }
  end;

  TSendApiData = class
  private
    FApi: String;
    FJson: String;
  published
    property Api: string read FApi write FApi;
    property Json: string read FJson write FJson;
  end;

  //제어 데이타
  TComPacket = array[0..599] of byte;

  TCmdCData = record
    nDataArr: TComPacket;
    nCnt: Integer;
    sType: String;
  end;

  TCheckOutBowler = record
    ParticipantsSeq: Integer; //대회 참가자 순번
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String; //게이머 정보 성,이름1, 이름2
    MemberNo: String; //저장용
    GameCnt: Integer;   //게임 설정수량
    GameMin: Integer;   //게임시간 설정

    GameStart: Integer;
    GameFin: Integer;

    MembershipSeq: Integer;     //회원권 구매 순번
    MembershipUseCnt: Integer;  //회원권 사용 갯수
    MembershipUseMin: Integer;  //회원권 사용 시간(분)

    ProductCd: String; //저장용
    ProductNm: String; //저장용
    PaymentType: Integer; //0:후불, 1:선불
    FeeDiv: String;     //요금제구분
    Handy: Integer; //핸디
    ShoesYn: String;
    //ReceiptNo: String; //영수증 번호
  end;

  TCheckOut = record
    AssignDt: String;
    AssignSeq: Integer;
    AssignNo: String;
    AssignRootDiv: String; //배정 경로
    CommonCtl: Integer; //동시제어

    CompetitionSeq: Integer;
    //CompetitionLeagueYn: String;    //N:오픈게임 Y:리그게임
    LaneMoveCnt: Integer;
    MoveMethod: String;    //G:일반이동, B:크로스이동좌우, 크로스이동X : X
    TrainMin: Integer;    //연습시간
    CompetitionLane: Integer;

    LaneNo: Integer;
    GameSeq: Integer; //게임진행수 초기값0
    GameDiv: Integer;  //1:게임제, 2:시간제
    GameType: Integer; //0:10, 1:369, 2:8, 3:9
    LeagueYn: String;
    BowlerCnt: Integer;
    BowlerList: array[1..6] of TCheckOutBowler;

    StartDatetime: String;
    EndDatetime: String;

    TotalGameCnt: Integer;
    TotalGameMin: Integer;
    ReserveDate: String; //예약시간
    ExpectdEndDate: String; //예상종료시간

    AssignStatus: Integer; //배정상태 - 0: 빈타석, 1:예약건, 2:홀드, 3:진행, 4: 미정, 5: 종료(미결제), 6: 종료, 7:취소
    PaymentResult: Integer; //결제완료여부
  end;

implementation

end.
