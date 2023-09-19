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
    MemberDiv: String; //�űԵ���� �л�����
    MobileNo: string;
    //Email: string;
    //CarNo: string;
    //Addr1: string;
    //Addr2: string;
    QRCode: string;
    //FingerStr: AnsiString;
    SavePoint: Integer; //����Ʈ
    Use: Boolean;
    {
    ������ �ڵ�	store_cd
    ȸ�� �̸�	member_nm
    ���� ����	sex_div
    �������	birthday
    �޴��� ��ȣ	mobile_no
    �̸���	email
    �����ȣ	zipno
    �ּ�	addr
    ���ּ�	addr2
    Ŭ�� ����	club_seq
    ȸ�� �� ����	member_customer_code
    ȸ�� ��ü ����	member_group_code
    ���� �ؽ�	fingerprint_hash
    ���� ���ڵ�	photo_encoding
    �޸�	memo
    }
  end;

  TGameProductInfo = record // �����
    ProdCd: String;           //��ǰ �ڵ�
    ProdNm: string;           //��ǰ ��
    ProdDetailDiv: string;    //��ǰ �� ���� 101:�̿��, 102:ȸ����
    ProdDetailDivNm: string;  //��ǰ �� ���и�
    GameDiv: string;           //���� ���� 1:������, 2:�ð���, 3:������
    FeeDiv: string;           //����� ���� 01: �Ϲ�, 02:ȸ��, 03:�л�, 04: Ŭ�� �����ڵ� ����
    UseGameCnt: Integer;      //�̿� ���Ӽ�
		UseGameMin: Integer;      //�̿� ���� �ð�(��)
    ShoesFreeYn: string;      //��ȭ�� ���� ���� ksj 230728 api ������ ���� �߰�
		SaleZoneCode: string;     //�Ǹ�ó ����
    {
    ApplyDowString: string; //���� ���� ���ڿ�
    ApplyStartTime: string; //���� ���� �ð�
    ApplyEndTime: string;   //���� ���� �ð�
    }
    ProdAmt: Integer;        //��ǰ �ݾ�
  end;

  TMemberShipProductInfo = record // ȸ���Ǹ� ��ǰ
    ProdCd: String;           //��ǰ �ڵ�
    ProdNm: string;           //��ǰ ��
    ProdDetailDiv: string;    //��ǰ �� ���� 501: ����ȸ����, 502: �ð�ȸ����, 503 : ���ȸ����
    ProdDetailDivNm: string;  //��ǰ �� ���и�
    DiscountFeeDiv: string;   //���� ����� ���� 01 : ����, 02 : ȸ��, 03 : �л�, 04 : Ŭ��
    ProdAmt: Integer;         //��ǰ �ݾ�
    UseGameCnt: Integer;      //�̿� ���Ӽ�
    UseGameMin: Integer;      //�̿� ���� �ð�(��)

    ExpireDay: Integer;       //��ȿ�Ⱓ
    ProdBenefits: String;     //��ǰ ����
    ShoesFreeYn: String;      //��ȭ�� ���� ����
    SavePointRate: Integer;   //���� ����Ʈ ��(%)

    SaleZoneCode: string;     //�Ǹ�ó ����
    UseYn: String;
    DelYn: String;
  end;

	TMemberProductInfo = record // ȸ������ ��ǰ
    MembershipSeq: Integer;   //ȸ���� ���ż���
    ProdCd: String;           //��ǰ �ڵ�
    ProdNm: string;           //��ǰ ��
		ProdDetailDiv: string;    //��ǰ �� ���� 501: ����ȸ����, 502: �ð�ȸ����, 503 : ���ȸ����
    GameDiv: String;          // ���� ����	"1:������, 2:�ð���, 3:������
    DiscountFeeDiv: string;   //���� ����� ����

    PurchaseGameCnt: Integer;	 //���� �̿� ���Ӽ�
		RemainGameCnt: Integer;	     //�ܿ� �̿� ���Ӽ�
		PurchaseGameMin: Integer;	 //���� ���� �ð�(��)
		RemainGameMin: Integer;		   //�ܿ� ���� �ð�(��)
		//PurchaseDatetime: String;	 //���� �Ͻ�

    StartDate: String;
    EndDate: String;
    ProdBenefits: String;     //��ǰ ����
    ShoesFreeYn: String;      //��ȭ�� ���� ����
    SavePointRate: Integer;   //���� ����Ʈ ��(%)
  end;

  TDiscount = record
    DcType: String; //G: �����, T: �ð���, P: ����Ʈ
    DcValue: Integer; //DcType :G - ���Ӽ�, t�ð�,p����Ʈ
    DcAmt: Integer; //���� ���αݾ�
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

    SaleID: Integer;                  // ����
    GameProduct: TGameProductInfo;    // ����� ��ǰ
    SaleQty: Integer;                 // �Ǹż���
    SalePrice: Currency;              // �Ǹűݾ� - �����
    DcProduct: TMemberProductInfo;    // ȸ����ǰ
    DcAmt: Currency;                  // ���αݾ�
    DiscountList: TList<TDiscount>;

    PaySelect: Boolean; //���� ���� ����
    PayResult: Boolean; //���� �Ϸ� ����
    ReceiptNo: string;   //������ ��ȣ
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
    ExpectedEndDatetime: String; //��������ð�
    RemainMin: String; //��������ð��� ���� �ܿ��ð�

    //ToCnt: Integer;
    GameCnt: Integer;
    GameFin: Integer;
    //CtlYn: Boolean;
    //ChgYn: Boolean;    //DB ����Ÿ ���뿩��
    //Assign: TAssignInfo;
  end;

  TGameInfo = record
    GameDiv: String; //1:������, 2:�ð���
    BowlerCnt: Integer;
    GameCnt: Integer;
    LaneUse: String;
    Lane1: Integer; //���� ǥ�ÿ�
    Lane2: Integer; //���� ǥ�ÿ�
    LeagueUse: Boolean;
    AssignNo: String; //������û���� ������ȣ
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
    ProductAddYn: string; //��õȸ����
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

AdvertiseNm: String; //     ���� ��						S		50
view_div: String; // ���� ��ġ						S		1		1:���, 2:�ϴ�, 3:�˾�
view_start_date: String; // ���� ������						S		10	2022-10-01	yyyy-mm-dd
view_end_date: String; // ���� ������						S		10	2025-12-31	yyyy-mm-dd
view_dow_string: String; // ���� ���� ���ڿ�						S		7	1111111	��ȭ���������
view_start_time: String; // ���� ���� �ð�						S		8	05:10:00	hh:mi:ss
view_end_time: String; // ���� ���� �ð�						S		8	23:10:00	hh:mi:ss
view_sec: Integer; // ���� �ð�(��)						I
//chg_datetime ���� �Ͻ�						S		19
//file_list ���� ���� ����Ʈ						A				1���� ���� �������� ���� ����. �����̵���
			file_type: String; //			S		1	1	1:�̹���, 2:������, �����ڵ� ����
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
