unit uConsts;

interface

uses
  System.UITypes;

const
  PRODUCT_TYPE_R = 'R';
  PRODUCT_TYPE_C = 'C';
  PRODUCT_TYPE_D = 'D';

  //chy 2020-09-29
  TimeSecCaptionReTry = '��õ� ������ : %s��';

  TimeSecCaption = '�����ð� %s��';
  TimeHH = '%s�ð�';
  TimeNN = '%s��';
  TimeHHNN = '%s�ð� %s��';
  Time30Sec = 30;
  CardHalbu = '�Һΰ��� : %s';

  XGOLF_REPLACE_STR = 'XGOLFUser_key:';
  XGOLF_REPLACE_STR2 = 'XGOLF User_key : ';
  XGOLF_REPLACE_STR3 = 'X-';
  //                               1    2    3    4    5    6    7    8    9     Cancel    0    back
  Key3BoardName: Array[0..11] of string = ('1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', '�����');
  Key3BoardArray: Array[0..11] of Integer = (vk1, vk2, vk3, vk4, vk5, vk6, vk7, vk8, vk9, vkCancel, vk0, vkBack);
  SelectTime: Array[0..15] of Integer = (7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22);
  WeekDay: Array[0..7] of string = ('','��', '��', 'ȭ', '��', '��', '��', '��');

  DEBUG_SCALE = 0.5;
  DEBUG_WIDTH = 540;
  DEBUG_HEIGHT = 960;

  BolwerNmTm: array[0..5] of string = ('A', 'B', 'C', 'D', 'E', 'F');
  HalbuNm: array[0..7] of string = ('�Ͻú�', '2����', '3����', '4����', '5����', '6����', '9����', '12����');
  HalbuCnt: array[0..7] of Integer = (1, 2, 3, 4, 5, 6, 9, 12);
  FeeDivStr: array[1..4] of string = ('�Ϲ�', 'ȸ��', '�л�ȸ��', 'Ŭ��ȸ��');


//  DEBUG_SCALE = 0.4;
//  DEBUG_WIDTH = 432;
//  DEBUG_HEIGHT = 768;

//  DEBUG_SCALE = 0.45;
//  DEBUG_WIDTH = 486;
//  DEBUG_HEIGHT = 864;
//  DEBUG_SCALE = 1;
//  DEBUG_WIDTH = 1080;
//  DEBUG_HEIGHT = 1920;
//
//  DEBUG_SCALE1 = 0.45;
//  DEBUG_WIDTH1 = 486;
//  DEBUG_HEIGHT1 = 864;

  // ������ Ư�����
  rptReceiptCharNormal    = '{N}';   // �Ϲ� ����
  rptReceiptCharBold      = '{B}';   // ���� ����
  rptReceiptCharInverse   = '{I}';   // ���� ����
  rptReceiptCharUnderline = '{U}';   // ���� ����
  rptReceiptAlignLeft     = '{L}';   // ���� ����
  rptReceiptAlignCenter   = '{C}';   // ��� ����
  rptReceiptAlignRight    = '{R}';   // ������ ����
  rptReceiptSizeNormal    = '{S}';   // ���� ũ��
  rptReceiptSizeWidth     = '{X}';   // ����Ȯ�� ũ��
  rptReceiptSizeHeight    = '{Y}';   // ����Ȯ�� ũ��
  rptReceiptSizeBoth      = '{Z}';   // ���μ���Ȯ�� ũ��
  rptReceiptSize3Times    = '{3}';   // ���μ���3��Ȯ�� ũ��
  rptReceiptSize4Times    = '{4}';   // ���μ���4��Ȯ�� ũ��
  rptReceiptInit          = '{!}';   // ������ �ʱ�ȭ
  rptReceiptCut           = '{/}';   // ����Ŀ��
  rptReceiptImage1        = '{*}';   // �׸� �μ� 1
  rptReceiptImage2        = '{@}';   // �׸� �μ� 2
  rptReceiptCashDrawerOpen= '{O}';   // ������ ����
  rptReceiptSpacingNormal = '{=}';   // �ٰ��� ����
  rptReceiptSpacingNarrow = '{&}';   // �ٰ��� ����
  rptReceiptSpacingWide   = '{\}';   // �ٰ��� ����
  rptLF                   = '{-}';   // �ٹٲ�
  rptLF2                  = #13#10;  // �ٹٲ�
  rptBarCodeBegin128      = '{<}';   // ���ڵ� ��� ���� CODE128
  rptBarCodeBegin39       = '{[}';   // ���ڵ� ��� ���� CODE39
  rptBarCodeEnd           = '{>}';   // ���ڵ� ��� ��
  // ������ ��¸�� (������ ���� ��¿��� �����)
  rptReceiptCharSaleDate  = '{D}';   // �Ǹ�����
  rptReceiptCharPosNo     = '{P}';   // ������ȣ
  rptReceiptCharPosName   = '{Q}';   // ������
  rptReceiptCharBillNo    = '{A}';   // ����ȣ
  rptReceiptCharDateTime  = '{E}';   // ����Ͻ�

/////////////////////         MSG//////////////////////////////////

  MSG_LOCAL_DATABASE_NOT_CONNECT = 'Local Database ���ῡ ���� �Ͽ����ϴ�.';
  MSG_ADMIN_CALL = '�����ڸ� ȣ�� �Ͽ����ϴ�.';
  MSG_ADMIN_CALL_FAIL = 'POS���� ������ ��Ȱ���� �ʽ��ϴ�.' + #13#10 + '����� POS�� �����Ͽ� �ֽñ�ٶ��ϴ�.';
  MSG_ADMIN_NOT_PASSWORD = '��й�ȣ�� �ٸ��ϴ�.';
  MSG_MASTERDOWN_FAIL = '������ ������ �����ϴ�.' + #13#10 + '�����ڸ� ȣ���Ͽ� �ֽñ� �ٶ��ϴ�.';
  MSG_MASTERDOWN_FAIL_PROGRAM_RESTART = '������ ���� ���� ����.' + #13#10 + '���α׷��� ������Ͽ� �ֽñ� �ٶ��ϴ�.';
  //MSG_ERROR_TEEBOX = '�������� Ÿ���Դϴ�.';
  MSG_HOLD_LANE_ERROR = '�ٸ� ����ڰ� ���� �����' + #13#10 + '�Ǵ� �������� �����Դϴ�.';
  MSG_HOLD_TEEBOX = '�ٸ� ����ڰ� �������Դϴ�.';
  MSG_ADD_PRODUCT = '��ǰ�� �����Ͽ� �ֽñ� �ٶ��ϴ�.';
  MSG_NOT_PAY_AMT = '������ �ݾ��� �����ϴ�.';
  MSG_NOT_MEMBER_SEARCH = 'ȸ�� ������ ã�� ���Ͽ����ϴ�.';
  MSG_MEMBER_USE_NOT_PRODUCT = '��� ������ ��ǰ�� �����ϴ�.';
  MSG_IS_PRODUCT_BUY = '��ǰ�� ���� �Ͻðڽ��ϱ�?';
  MSG_DAY_PRODUCT_ONE = '����Ÿ�� ���Ŵ� 1���� ���� �մϴ�.';
  MSG_PROMOTION = '��� �� �� ���� QR�ڵ� �Դϴ�.';
  MSG_PROMOTION_OK = '���θ�� ���� ���� �Ǿ����ϴ�.';
  MSG_PROMOTION_OPTION_1 = #13#10 + '(����ʰ� �Ǵ� ���Ϸ�)';
  MSG_PROMOTION_OPTION_2 = #13#10 + '(���� ������ �ߺ� ��� �Ұ��մϴ�.)';
  MSG_PROMOTION_OPTION_3 = #13#10 + '(���αݾ� �ʰ�)';
  MSG_PROMOTION_OPTION_4 = #13#10 + '(QR�ڵ� �ߺ� ��� �Ұ��մϴ�.)';
  MSG_PROMOTION_OPTION_5 = #13#10 + '(���� ������ ��ǰ�� �����ϴ�.)';
  MSG_PROMOTION_OPTION_6 = #13#10 + '(�Բ� ����� �Ұ��� ���������� �ֽ��ϴ�.)';
  MSG_PROMOTION_OPTION_7 = #13#10 + '(�ش� ��ǰ�� �����Ҽ� ���� �����Դϴ�.)';
  MSG_PROMOTION_PRODUCT_ONLY_DAY = '����Ÿ���� ��� �����մϴ�.';
  MSG_SALE_PRODUCT_NOT_CNT = '���� ������ ��ǰ�� �����ϴ�.';
  MSG_SALE_PRODUCT_RESERVE = '�����Ͻ� ��ǰ���� �����Ͻðڽ��ϱ�?';
  MSG_SALE_PRODUCT_RESERVE_SEARCH = 'ȸ������ ȸ���� ������ ��ȸ�Ͻðڽ��ϱ�?';
  //MSG_VIP_ONLY_DAY_PRODUCT = 'VIPŸ���� ���ϰ��� ����� �����մϴ�';
  MSG_TEAM_ONLY_DAY_PRODUCT = 'TEAMŸ���� ���ϰ��� ����� �����մϴ�';
  MSG_COMPLETE_CARD = '�����Ͻ� ī��� ì��̳���?' + #13#10 + '�ٽ� �ѹ� Ȯ���� �ּ���.';



  MSG_TEEBOX_TIME_ERROR = 'Ÿ�� ���� �����ð��� ����Ǿ����ϴ�!' + #13#10 +
                          '����� �ð����� ���� �����ðڽ��ϱ�?' +
                          #13#10 + #13#10 + '[������ ����ð�] %s' + #13#10 + '[����� ����ð�] %s';

  MSG_TEEBOX_TIME_ERROR_STATUS = '������ �Ǵ� ��ȸ������ Ÿ���Դϴ�.';

  MSG_TEEBOX_RESERVATION_AD_FAIL = 'Ÿ�� ������ ���� �Ͽ����ϴ�.' + #13#10 + '�����ڸ� ȣ���Ͽ� �ֽñ� �ٶ��ϴ�.';

  MSG_UPDATE_INFO_FAIL = '���� ���ſ� ���� �Ͽ����ϴ�.' + #13#10 + '�ٽýõ��Ͽ� �ֽñ� �ٶ��ϴ�.';

  //MSG_NEW_MEMBER = '�ʼ��׸� �������ּ���.';
  //MSG_NEW_MEMBER = '���������� ����� �������ּ���.';
  MSG_TEEBOX_RESERVEMOVE_AD_FAIL = 'Ÿ�� �̵��� ���� �Ͽ����ϴ�.' + #13#10 + '�����ڸ� ȣ���Ͽ� �ֽñ� �ٶ��ϴ�.';
  MSG_TEEBOX_MOVE_FAIL = '���� ��Ÿ���� �̵��Ҽ� �ֽ��ϴ�.';
  MSG_TEEBOX_NULL = 'Ÿ���� �������� �ʽ��ϴ�.' + #13#10 + '�ٸ� Ÿ���� �������ּ���.';
  MSG_TEEBOX_MOVE_BARCODE_NOT = '��� �� �� ���� Ÿ������ǥ �Դϴ�.';
  MSG_TEEBOX_MOVE_BARCODE_NOT_2 = '����� �Ϸ�� Ÿ������ǥ �Դϴ�.';
  MSG_TEEBOX_MOVE_BARCODE_NOT_3 = '���������� Ÿ���� ���� ����ڰ� �ֽ��ϴ�. ' + #13#10 + 'Ÿ���̵��� �Ҽ� �����ϴ�.';

  MSG_NEWMEMBER_NULL = '�̸�, �������, �޴�����ȣ�� �ʼ� �Է� �׸� �Դϴ�.';
  MSG_NEWMEMBER_BIRTHDAY_FAIL = '��������� ���ڷθ� �Է��� �ּ���.';
  MSG_NEWMEMBER_PHONE_FAIL = '�޴�����ȣ�� ���ڷθ� �Է��� �ּ���.';
  MSG_NEWMEMBER_USE = '������ ȸ���� �����մϴ�.';
  MSG_NEWMEMBER_FAIL = 'ȸ�������� ������ �� �����ϴ�!';
  MSG_NEWMEMBER_SUCCESS = 'ȸ������ �� ��ǰ���Ű� �Ϸ�Ǿ����ϴ�. ' + #13#10 + 'Ÿ���� ������ �̿����ּ���.';

  MSG_PRINT_ADMIN_CALL = '������ ������ �����մϴ�.' + #13#10 + '�����ڸ� ȣ���Ͽ� �ֽñ� �ٶ��ϴ�.';

type
  TMethodType = (mtGet, mtPost, mtDelete);
  TCardApplyType = (catNone, catAppCard, catMagnetic, catPayco);


  TPopUpLevel = (plNone, plAuthentication, plNewMemberPolicy, plGameSetting, plBuyDcList, plPayDcList, plPrint, plAssignPrint);

  TPopUpFullLevel = (pflNone, pflPhone, pflPayCard, pflQR);


  TMemberItemType = (mitNone, mitChange, mitBuy, mitNew); //ȸ��Ȯ��, ȸ����ǰ����, ȸ�����
  TNewMemberItemType = (nmitNone, nmitMember, nmitStudent); //ȸ��, �л�
  TGameItemType = (gitNone, gitGameCnt, gitGameTime); // ���ӿ����, �ð������


implementation

end.
