const
  { ������ ���� }
  (*
    html: #FF7BBCE3
    delphi: $00FACE87
  *)

	{ Special Char }
  _SOH  = Chr($01);
  _STX  = Chr($02); //Start String
  _ETX  = Chr($03); //End String
  _BS   = Chr($08); //Back Space
  _TAB  = Chr($09); //Tab
  _LF   = Chr($0A); //Line Feed
  _CR   = Chr($0d); //Carrige Return
  _FS   = Chr($1C); //File Separator
  _GS   = Chr($1D); //Group Separator
  _RS   = Chr($1E); //Record Separator
  _US   = Chr($1F); //Unit Separator
  _CRLF = _CR + _LF;
  _LFCR = _LF + _CR;
  _BR   = _LF; //'<BR>'

  { Window Messages }
  WM_USER  = $0400; //1024
  CO_WM_USER = WM_USER + $0400;

  { SDK ���̼��� ���� }
  CO_SDK_LIC_CKDLL_KEY = 'SLBPSK.CB1112022_ncysW5kq8RmQ'; //CkDLL API Library
  CO_SDK_LIC_VIDEOGRABBER_KEY = '1791553139800639204523-73SOLBIPOS'; //DataStead VideoGrabber SDK

  { Bowling Score Chars }
  CO_PIN_GUTTER: Char   = #45; // '-'
  CO_PIN_SPARE: Char    = #47; // '/'
  CO_PIN_0: Char        = #48; // '0'
  CO_PIN_1: Char        = #49; // '1'
  CO_PIN_2: Char        = #50; // '2'
  CO_PIN_3: Char        = #51; // '3'
  CO_PIN_4: Char        = #52; // '4'
  CO_PIN_5: Char        = #53; // '5'
  CO_PIN_6: Char        = #54; // '6'
  CO_PIN_7: Char        = #55; // '7'
  CO_PIN_8: Char        = #56; // '8'
  CO_PIN_9: Char        = #57; // '9'
  CO_PIN_STRIKE: Char   = #88; // 'X'
  CO_PIN_STRIKE_2: Char = #120; //'x'

	{ Lane Color Define }
  CO_COLOR_BASE_NORMAL      = $00524C48;
  CO_COLOR_BASE_SELECT      = $00FFB95D;
  CO_COLOR_BASE_GROUP       = $00708EAD;
  CO_COLOR_LANE_NO_NORMAL   = $00966A1D;
  CO_COLOR_LANE_NO_SELECT   = $00FFB95D;
  CO_COLOR_LANE_NO_GROUP    = $00747E8B;
  CO_COLOR_LANE_READY       = $00E5E4D6;
  CO_COLOR_LANE_RESERVED    = $0000E7FC;
  CO_COLOR_LANE_HOLD        = $001A9DF4;
  CO_COLOR_LANE_BUSY        = $00F7E131;
  CO_COLOR_LANE_MAINTENANCE = $00CABCAA; //$00826D52;

  { ����Ʈ URL }
  CO_URL_HOME         = 'https://www.bowlingpick.com'; //Ȩ������
  CO_URL_API_SERVER   = 'https://partners.bowlingpick.com'; //API ����
  CO_URL_TEST_SERVER  = 'https://test.bowlingpick.com'; //�׽�Ʈ�� API ����
  CO_URL_UPDATE_CDN   = 'http://nhncdn.bowlingpick.com'; //������Ʈ CDN
  CO_URL_NHNKCP       = 'https://www.kcp.co.kr'; //NHN�ѱ����̹�����
  CO_URL_SOLBIPOS     = 'http://www.solbipos.com'; //�ֺ�����
  CO_URL_REMOTE_CS    = 'http://www.367.co.kr';
  CO_URL_API_WEATHER  = 'https://api.openweathermap.org/data/3.0/';
  CO_URL_WEATHER      = 'https://www.openweathermap.org'; //����
  CO_URL_ZIPCODE      = 'https://www.xpartners.co.kr/zipcode.html';

  { �⺻��(Default Value) }
  CO_DEFAULT_APP_TITLE            = 'BowlingPick POS System';
  CO_DEFAULT_EXT_PLUGIN           = '.bpl';
  CO_DEFAULT_AUTO_REBOOT_TIME     = '04:00';
  CO_DEFAULT_LAUNCHER_NAME        = 'BPLauncher';
  CO_DEFAULT_ADMINCALL_NAME       = 'BPAdminCall';
  CO_DEFAULT_ADMINCALL_PORT       = 6001;
  CO_DEFAULT_GAMESERVER_HOST      = '127.0.0.1';
  CO_DEFAULT_GAMESERVER_API_PORT  = 3308;
  CO_DEFAULT_GAMESERVER_DB_PORT   = 3306;
  CO_DEFAULT_GAMESERVER_DB        = 'bowling';
  CO_DEFAULT_GAMESERVER_USER      = 'bowling';
  CO_DEFAULT_GAMESERVER_PWD       = 'bowling123!';
  CO_DEFAULT_LANELIST_DELIMITER   = ',';
  //'F85BBD42458F94AF5D733FD977FDCC60A0213F233CDD69F1CC32F5216427388A69F49F65F33E6A216B8827FC9A';

  { ��� ���� }
  CO_RESULT_SUCCESS = '0000';
  CO_RESULT_FAIL    = '9999';
  CO_RESULT_YES     = 'Y';
  CO_RESULT_NO      = 'N';

  { �Ǹ�ó ���� �ڵ�(Sale Zone Code) }
  CO_SALEZONE_POS_FRONT    = '00'; //������ ����Ʈ
  CO_SALEZONE_POS_PREPAY   = '01'; //����POS(ī�� ��)
  CO_SALEZONE_POS_DEFERRED = '02'; //�ĺ�POS(���̺� ������ ��ϴ� ��ľ���)

  { Ŭ���̾�Ʈ ����(Client Type) }
  CO_CLIENT_POS    = 'P'; //����ƮPOS
  CO_CLIENT_KIOSK  = 'K'; //Ű����ũ
  CO_CLIENT_MOBILE = 'M'; //�����

  { ���� ����(Payment Method) }
  CO_PAYMENT_CARD         = 1; //�ſ�ī��
  CO_PAYMENT_CASH         = 2; //����
  CO_PAYMENT_PAYCO_CARD   = 3; //PAYCO(ī��)
  CO_PAYMENT_PAYCO_COUPON = 4; //PAYCO(����)
  CO_PAYMENT_PAYCO_POINT  = 5; //PAYCO(����Ʈ)

  { ���ݿ����� �߱� ��ü(Cash-Receipt Entity Div) }
  CO_CASH_RECEIPT_PERSON = 1; //����
  CO_CASH_RECEIPT_BIZ    = 2; //�����

  { �ŷ� ���� ���� }
  CO_TRADE_CANCEL   = 0;  //��� �ŷ�
  CO_TRADE_APPROVAL = 1;  //���� �ŷ�
  CO_TRADE_CANCELED = 2;  //��ҵ� ������ �ŷ�

  { ���� ����(Discount Div) }
  CO_DISCOUNT_COUPON         = 'C';  //���� ����
  CO_DISCOUNT_CARD_IMMEDIATE = 'P';  //ī��� �������

  { ��ǰ ����(Product Div) }
  CO_PROD_GAME       = '10'; //����
  CO_PROD_LOCKER     = '20'; //��Ŀ
  CO_PROD_GENERAL    = '30'; //�Ϲ�
  CO_PROD_RENT       = '40'; //�뿩
  CO_PROD_MEMBERSHIP = '50'; //ȸ��

  { ��ǰ �� ����(Product Detail Div) }
  CO_PROD_DETAIL_GAME_COUNT  = '101'; //���ӿ���� ���ӻ�ǰ
  CO_PROD_DETAIL_GAME_MIN    = '102'; //�ð������ ���ӻ�ǰ
  CO_PROD_DETAIL_LOCKER      = '201'; //��Ŀ ���̿��
  CO_PROD_DETAIL_KEEPAMT     = '202'; //��Ŀ ������
  CO_PROD_DETAIL_RENT_ALL    = '401'; //�뿩��ǰ ��ü
  CO_PROD_DETAIL_MEMBER_GAME = '501'; //������ ȸ����
  CO_PROD_DETAIL_MEMBER_TIME = '502'; //�ð��� ȸ����
  CO_PROD_DETAIL_MEMBER_VIP  = '503'; //��� ȸ����

  { ���ӿ���� ����(Rate-Plan Game Div) }
  CO_RATEPLAN_GAME = 1; //������
  CO_RATEPLAN_TIME = 2; //�ð���
  CO_RATEPLAN_VIP  = 3; //����

  { ���ӻ�ǰ ����� ����(Game Fee Div) }
  CO_GAMEFEE_BASIC   = '01'; //�Ϲ�
  CO_GAMEFEE_MEMBER  = '02'; //ȸ��
  CO_GAMEFEE_STUDENT = '03'; //�л�
  CO_GAMEFEE_CLUB    = '04'; //Ŭ��

  { ���Ӹ�� ����(Game Mode) }
  CO_GAMEMODE_OPEN   = 1; //���� ����
  CO_GAMEMODE_LEAGUE = 2; //���� ����

  { ���ӿ�� ���� ���(Fee Payment Type) }
  CO_PAYTYPE_DEFERRED = 0; //�ĺ�
  CO_PAYTYPE_PREPAID  = 1; //����

  { ���� ���� (Lane Status Div) }
  CO_LANE_READY       = 0; //�̿밡��
  CO_LANE_RESERVED    = 1; //�����
  CO_LANE_HOLD        = 2; //�ӽÿ���
  CO_LANE_BUSY        = 3; //�̿���
  CO_LANE_END_UNPAID  = 5; //����(�̰���)
  CO_LANE_END         = 6; //����(�����Ϸ�)
  CO_LANE_CANCEL      = 7; //�������
  CO_LANE_MAINTENANCE = 8; //������

  { ���� ��� ���� (Direction Div) }
  CO_LANE_DIR_NOT_USED  = 0; //�̻��
  CO_LANE_DIR_USE_LEFT  = 1; //���� ���� ���
  CO_LANE_DIR_USE_RIGHT = 2; //������ ���� ���
  CO_LANE_DIR_PAUESD    = 3; //�Ͻ�����

  { ���̺� �̵� ��� (Table Shift Div) }
  CO_TABLE_SHIFT_GENERAL    = 'G'; //�Ϲ� �̵�
  CO_TABLE_SHIFT_LEFT_RIGHT = 'B'; //�¿�� �̵�
  CO_TABLE_SHIFT_CROSS      = 'X'; //CROSS �̵�

  { �̿� ���� ����(Use Status }
  CO_STATUS_INUSE  = 1; //�̿���
  CO_STATUS_CLOSE  = 2; //����
  CO_STATUS_RECESS = 3; //��ȸ
  CO_STATUS_BEFORE = 4; //�̿���

  { ��Ŀ ���� ����(Locker ZoneCode) }
  CO_LOCKER_ZONE_PASSAGE = '00'; //����

  { ��Ŀ �� ����(Layer Div Locker) }
  CO_LOCKER_LAYER_UPPER = '01'; //���
  CO_LOCKER_LAYER_LOWER = '02'; //�ϴ�

  { ��Ŀ ���� ����(Status Div Locker) }
  CO_LOCKER_EMPTY    = 1; //�̿밡��
  CO_LOCKER_INUSE    = 2; //�̿���
  CO_LOCKER_EXPIRED  = 3; //����
  CO_LOCKER_DISABLED = 9; //�̿�Ұ�

  { ���� ����(Gender Div) }
  CO_SEX_ALL     = 0;  //����
  CO_SEX_MALE    = 1;  //��
  CO_SEX_FEMALE  = 2;  //��

  { ������ ���(Data Mode) }
  CO_DATA_MODE_VIEW   = 0; //�� ��ȸ
  CO_DATA_MODE_NEW    = 1; //���
  CO_DATA_MODE_EDIT   = 2; //����
  CO_DATA_MODE_LIST   = 3; //��� ��ȸ
  CO_DATA_MODE_SELECT = 4; //��� ����

  { �˻� ���(Search Type) }
  CO_SEARCH_NONE        = 0; //����
  CO_SEARCH_MEMBER_NO   = 1; //ȸ����ȣ
  CO_SEARCH_MEMBER_NAME = 2; //ȸ����
  CO_SEARCH_TEL_NO      = 3; //��ȭ��ȣ
  CO_SEARCH_CAR_NO      = 4; //������ȣ

  { ���� �޴� }
  CO_MENU_LANE_VIEW     = 0;
  CO_MENU_SALE_POS      = 1;
  CO_MENU_RECEIPT_VIEW  = 2;
  CO_MENU_LOCKER_VIEW   = 3;
  CO_MENU_RALLY_MODE    = 4;

	{ �÷����� Ŀ�ǵ�(Plugin Command) }
  CPC_INIT              = 'CPC_INIT';
  CPC_ACTIVE            = 'CPC_ACTIVE';
  CPC_CLOSE             = 'CPC_CLOSE';
  CPC_TITLE             = 'CPC_TITLE';
  CPC_NAVIGATE          = 'CPC_NAVIGATE';
  CPC_REBOOT            = 'CPC_REBOOT';
  CPC_RESIZE            = 'CPC_RESIZE';
  CPC_REFRESH           = 'CPC_REFRESH';
  CPC_WEATHER           = 'CPC_WEATHER';
  CPC_LANE_NO           = 'CPC_LANE_NO';
  CPC_MAIN_STATUS       = 'CPC_MAIN_STATUS';
  CPC_LANE_STATUS       = 'CPC_LANE_STATUS';
  CPC_GAME_REFRESH_FORCE= 'CPC_GAME_REFRESH_FORCE';
  CPC_GAME_REFRESH_DELAY= 'CPC_GAME_REFRESH_DELAY';
  CPC_SALE_REFRESH_ALL  = 'CPC_SALE_REFRESH_ALL';
  CPC_SALE_REFRESH_LANE = 'CPC_SALE_REFRESH_LANE';
  CPC_READY_COUNT       = 'CPC_READY_COUNT';
  CPC_RESERVED_COUNT    = 'CPC_RESERVED_COUNT';
  CPC_BUSY_COUNT        = 'CPC_BUSY_COUNT';
  CPC_SEND_DATA         = 'CPC_SEND_DATA';
  CPC_CARD_CANCEL       = 'CPC_CARD_CANCEL';
  CPC_CASH_CANCEL       = 'CPC_CASH_CANCEL';
  CPC_PAYCO_CANCEL      = 'CPC_PAYCO_CANCEL';
  CPC_CHEQUE_APPPLY     = 'CPC_CHEQUE_APPPLY';
  CPC_SEL_PROD_GAME     = 'CPC_SEL_PROD_GAME';
  CPC_SEL_PROD_LOCKER   = 'CPC_SEL_PROD_LOCKER';
  CPC_GAME_ASSIGN       = 'CPC_GAME_ASSIGN';
  CPC_SELECT_MEMBER     = 'CPC_SELECT_MEMBER';
  CPC_SELECT_MENU_ITEM  = 'CPC_SELECT_MENU_ITEM';
  CPC_RECEIPT_NO_LIST   = 'CPC_RECEIPT_NO_LIST';

	{ �÷����� �Ķ���� }
  CPP_OWNER_ID        = 'CPP_OWNER_ID';
  CPP_INDEX           = 'CPP_INDEX';
  CPP_VALUE           = 'CPP_VALUE';
  CPP_TITLE           = 'CPP_TITLE';
  CPP_DATA_MODE       = 'CPP_DATA_MODE';
  CPP_SEARCH_TYPE     = 'CPP_SEARCH_TYPE';
  CPP_URL             = 'CPP_URL';
  CPP_SHOW_NOMORE     = 'CPP_SHOW_NOMORE';
  CPP_SHOW_NAVBTN     = 'CPP_SHOW_NAVBTN';
  CPP_USE_DOTKEY      = 'CPP_USE_DOTKEY';
  CPP_BARCODE         = 'CPP_BARCODE';
  CPP_APPROVAL_YN     = 'CPP_APPROVAL_YN';
  CPP_SALEMODE_YN     = 'CPP_SALEMODE_YN';
  CPP_RECEIPT_NO      = 'CPP_RECEIPT_NO';
  CPP_APPROVAL_NO     = 'CPP_APPROVAL_NO';
  CPP_APPROVAL_DATE   = 'CPP_APPROVAL_DATE';
  CPP_APPROVAL_AMT    = 'CPP_APPROVAL_AMT';
  CPP_CASH_ENTITY_DIV = 'CPP_CASH_ENTITY_DIV';
  CPP_CHEQUE_NO       = 'CPP_CHEQUE_NO';
  CPP_PROD_DIV        = 'CPP_PROD_DIV';
  CPP_PROD_DETAIL_DIV = 'CPP_PROD_DETAIL_DIV';
  CPP_PROD_CD         = 'CPP_PROD_CD';
  CPP_PROD_NM         = 'CPP_PROD_NM';
  CPP_LANE_NO         = 'CPP_LANE_NO';
  CPP_GAME_DIV        = 'CPP_GAME_DIV';
  CPP_MEMBERSHIP_YN   = 'CPP_MEMBERSHIP_YN';
  CPP_TODAY_YN        = 'CPP_TODAY_YN';
  CPP_FEE_DIV         = 'CPP_FEE_DIV';
  CPP_DC_FEE_DIV      = 'CPP_DC_FEE_DIV';
  CPP_GAME_MIN        = 'CPP_GAME_MIN';
  CPP_DATASET         = 'CPP_DATASET';
  CPP_MEMBER_NO       = 'CPP_MEMBER_NO';
  CPP_MEMBERSHIP_SEQ  = 'CPP_MEMBERSHIP_SEQ';
  CPP_SELECT_LOCKER   = 'CPP_SELECT_LOCKER';
  CPP_SHOES_FREE_YN   = 'CPP_SHOES_FREE_YN';
  CPP_ASSIGN_NO       = 'CPP_ASSIGN_NO';

  { MainForm �޽��� �Ķ���� }
  CMP_REFRESH_CLOCK       = 0;
  CMP_PARTNER_CENTER_OFF  = 10;
  CMP_PARTNER_CENTER_ON   = 11;
  CMP_GAME_SERVER_OFF     = 20;
  CMP_GAME_SERVER_ON      = 21;
  CMP_GAME_SERVER_DB_OFF  = 30;
  CMP_GAME_SERVER_DB_ON   = 31;
  CMP_GAME_SERVER_DB_LOST = 32;
  CMP_LOCAL_DB_OFF        = 40;
  CMP_LOCAL_DB_ON         = 41;
  CMP_USER_LOG_OFF        = 50;
  CMP_USER_LOG_ON         = 51;
  CMP_THREAD_LANE_ON      = 60;
  CMP_THREAD_LANE_OFF     = 61;
  CMP_THREAD_LANE_ERROR   = 62;
  CMP_THREAD_ASSIGN_OFF   = 70;
  CMP_THREAD_ASSIGN_ON    = 71;
  CMP_THREAD_ASSIGN_ERROR = 72;
  CMP_THREAD_SALE_ON      = 80;
  CMP_THREAD_SALE_OFF     = 81;
  CMP_THREAD_SALE_ERROR   = 82;

{ EOF }