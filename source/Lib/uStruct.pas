unit uStruct;

interface

uses
  System.Generics.Collections, Classes;

const
  BUFFER_SIZE = 255;

type
  //��������
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

    Emergency: Boolean; //��޹������
  end;

  //��������
  TStoreInfo = record
    StoreCd: String;
    StoreNm: String;
    SaleStartTime: String;
    SaleEndTime: String;
    PerGameMin: Integer;
    MinusFrame: Integer;

    DBInitTime: String; //����Ÿ �ʱ�ȭ
  end;

  TBowlerStatus = record //���䵥��Ÿ
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String; //���̸� ���� ��,�̸�1, �̸�2

    FrameTo: Integer; //������ ����
    FramePin: array[1..21] of String;
    FrameScore: array[1..10] of Integer;
    FrameLane: array[1..10] of Integer;

    TotalScore: Integer; //��������
    ToCnt: Integer;    //���̸� �� Ƚ��
    EndGameCnt: Integer; //�Ϸ�� ���Ӽ�

    Status1: String; // C0=���� ���� ���̸�, 80=���, 02 = �Ͻ�����(����), 20=�Ͻ�����(����), E0=?
    ResidualGameTime: Integer; // �ܿ��ð�
    ResidualGameCnt: Integer; // �ܿ����Ӽ�
    Status3: String; // ����0x20 = ����, 0x00 = ������. 0xA0 = , 0x80=��������
  end;

  TGameStatus = record //���䵥��Ÿ
    {
    1~8 Byte : gamedata (String)
    9��° Byte : ���ι�ȣ
    10, 11��° Byte : ������ ���� (12��° Byte ���� CRC����)
    12��° Byte : ���ι�ȣ
    13��° Byte : 20(�Ϲݰ��ӽ� ����). 20<->28(���װ��ӽý� NEXT GAME ���� �ٲ�???)
    14��° Byte : ���ӻ���(A8=����, 88=����)
    15��° Byte : 00=�Ϲݰ���, 01=���װ���
    16��° Byte : 01=369����, 02=8�ɰ���, 03=9�ɰ���, 00=�Ϲݰ���
    17��° Byte : ??
    18��° Byte : ??
    19��° Byte : ���̸� ��
    20��° Byte : ���� �� ���̸� ��ȣ
    21��° Byte : ?? (0B������� ���� ����)
    22��° Byte : ��ü ���̸� �������� (L Byte)
    23��° Byte : ��ü ���̸� �������� (H Byte)
    24��° Byte :
    25��° Byte :
    26��° Byte : ���� �� ���̸� ������ ���� (���� 4Byte. ���� ������)
    27��° Byte : 0A (����?)
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
    ParticipantsSeq: Integer; //��ȸ ������ ����
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String; //���̸� ���� ��,�̸�1, �̸�2
    MemberNo: String; //�����
    GameCnt: Integer;   //���� ��������
    GameMin: Integer;   //���ӽð� ����

    GameStart: Integer;
    GameFin: Integer;

    MembershipSeq: Integer;     //ȸ���� ���� ����
    MembershipUseCnt: Integer;  //ȸ���� ��� ����
    MembershipUseMin: Integer;  //ȸ���� ��� �ð�(��)

    ProductCd: String; //�����
    ProductNm: String; //�����
    PaymentType: Integer; //0:�ĺ�, 1:����
    FeeDiv: String;     //���������
    Handy: Integer; //�ڵ�
    ShoesYn: String;
    //ReceiptNo: String; //������ ��ȣ
  end;

  TAssignInfo = record
    AssignDt: String;
    AssignSeq: Integer;
    AssignNo: String;
    AssignRootDiv: String; //���� ���
    CommonCtl: Integer; //��������

    CompetitionSeq: Integer;
    //CompetitionLeagueYn: String;    //N:���°��� Y:���װ���
    LaneMoveCnt: Integer;
    MoveMethod: String;    //G:�Ϲ��̵�, B:ũ�ν��̵��¿�, ũ�ν��̵�X : X
    TrainMin: Integer;    //�����ð�
    CompetitionLane: Integer;

    LaneNo: Integer;
    GameSeq: Integer; //��������� �ʱⰪ0
    GameDiv: Integer;  //1:������, 2:�ð���
    GameType: Integer; //0:10, 1:369, 2:8, 3:9
    LeagueYn: String;
    BowlerCnt: Integer;
    BowlerList: array[1..6] of TBowlerInfo;

    StartDatetime: String;
    EndDatetime: String;

    //TotalGameCnt: Integer;
    //TotalGameMin: Integer;
    ReserveDate: String; //����ð�
    ExpectdEndDate: String; //��������ð�

    AssignStatus: Integer; //�������� - 0: ��Ÿ��, 1:�����, 2:Ȧ��, 3:����, 4: ����, 5: ����(�̰���), 6: ����, 7:���
    PaymentResult: Integer; //�����ϷῩ��
  end;

  //��������
  TLaneInfo = record
    LaneNo: Integer;
    LaneNm: String;
    PinSetterId: String;
    HoldUse: String;
    HoldUser: String;
    UseStatus: String;
    UseYn: Boolean;
    CtlYn: Boolean;
    ChgYn: Boolean;    //DB ����Ÿ ���뿩��
    NextYn: Boolean;
    //NextCtl: Boolean;
    Assign: TAssignInfo;
    Game: TGameStatus;
    GameCom: TGameStatus;

    ErrorCnt: Integer;
    ErrorYn: String;
  end;

  //���� ���̺�
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
    ReserveDate: String; //����ð�
    ExpectdEndDate: String; //��������ð�
  end;

  //���� ���̺�
  TGameInfoDB = record
    AssignDt: String;
    AssignSeq: Integer;
    GameSeq: Integer; //���� �������� ����
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
    LeagueYn: String;    //N:���°��� Y:���װ���
    LaneMoveCnt: Integer;
    MoveMethod: String;    //G:�Ϲ��̵�, B:ũ�ν��̵��¿�, ũ�ν��̵�X : X
    TrainMin: Integer;

    Cnt: Integer;
    StartLane: Integer;
    EndLane: Integer;

    CompetitionEnd: Boolean; //��ȸ����
    CompetitionEndDate: TDateTime; //��ȸ����ð�-> 30���� ������������.

    List: array of TAssignInfo;
  end;

  THoldInfo = record
    HoldUse: String;
    HoldUser: String;
  end;


  //������ ������
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

    FReserveDate: String; //����ð�
    FExpectdEndDate: String; //��������ð�
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

  //���� ����Ÿ
  TComPacket = array[0..599] of byte;

  TCmdCData = record
    nDataArr: TComPacket;
    nCnt: Integer;
    sType: String;
  end;

  TCheckOutBowler = record
    ParticipantsSeq: Integer; //��ȸ ������ ����
    BowlerSeq: Integer;
    BowlerId: String;
    BowlerNm: String; //���̸� ���� ��,�̸�1, �̸�2
    MemberNo: String; //�����
    GameCnt: Integer;   //���� ��������
    GameMin: Integer;   //���ӽð� ����

    GameStart: Integer;
    GameFin: Integer;

    MembershipSeq: Integer;     //ȸ���� ���� ����
    MembershipUseCnt: Integer;  //ȸ���� ��� ����
    MembershipUseMin: Integer;  //ȸ���� ��� �ð�(��)

    ProductCd: String; //�����
    ProductNm: String; //�����
    PaymentType: Integer; //0:�ĺ�, 1:����
    FeeDiv: String;     //���������
    Handy: Integer; //�ڵ�
    ShoesYn: String;
    //ReceiptNo: String; //������ ��ȣ
  end;

  TCheckOut = record
    AssignDt: String;
    AssignSeq: Integer;
    AssignNo: String;
    AssignRootDiv: String; //���� ���
    CommonCtl: Integer; //��������

    CompetitionSeq: Integer;
    //CompetitionLeagueYn: String;    //N:���°��� Y:���װ���
    LaneMoveCnt: Integer;
    MoveMethod: String;    //G:�Ϲ��̵�, B:ũ�ν��̵��¿�, ũ�ν��̵�X : X
    TrainMin: Integer;    //�����ð�
    CompetitionLane: Integer;

    LaneNo: Integer;
    GameSeq: Integer; //��������� �ʱⰪ0
    GameDiv: Integer;  //1:������, 2:�ð���
    GameType: Integer; //0:10, 1:369, 2:8, 3:9
    LeagueYn: String;
    BowlerCnt: Integer;
    BowlerList: array[1..6] of TCheckOutBowler;

    StartDatetime: String;
    EndDatetime: String;

    TotalGameCnt: Integer;
    TotalGameMin: Integer;
    ReserveDate: String; //����ð�
    ExpectdEndDate: String; //��������ð�

    AssignStatus: Integer; //�������� - 0: ��Ÿ��, 1:�����, 2:Ȧ��, 3:����, 4: ����, 5: ����(�̰���), 6: ����, 7:���
    PaymentResult: Integer; //�����ϷῩ��
  end;

implementation

end.
