unit uGMSQL;

interface

const

SQL_GM_MEMBER_SEARCH_PRODUCT =
  'SELECT D.CNT,                                                             ' +
  '       C.REGDAY,                                                          ' +
  '       C.REGTGRP,                                                         ' +
  '       A.CUST_STOP_YN,                                                    ' +
  '       A.CUST_REG_NO,                                                     ' +
  '   	  B.CUST_REG_NAME,                                                   ' +
  '       B.CUST_CARD_NO,                                                    ' +
  '       A.CUST_REG_TYPE,                                                   ' +
  '       A.CUST_COK_QTY,                                                    ' +
  '       A.CUST_COK_BUY,                                                    ' +
  '       A.CUST_CODE,                                                       ' +
  '       C.REGCODE,                                                         ' +
  '       C.REGHOLIDAY,                                                      ' +
  '       C.REGGRPNAME,                                                      ' +
  '       C.REGCODENAME,                                                     ' +
  '       IF(C.REGSEX = ''M'', ''(1)'', ''(2)'') AS SEX,                     ' +
  '       C.REGSEX,                                                          ' +
  '       AES_DECRYPT(UNHEX(B.CUST_HP_NO), ''dlekdls'') as CUST_HP_NO,       ' +
  '       A.CUST_IN_START_DTE,                                               ' +
  '       A.CUST_IN_END_DTE,                                                 ' +
  '       A.CUST_ACT_NO,                                                     ' +
  '       A.ACT_SEQ                                                          ' +
  '  FROM CUSTLIST A                                                         ' +
	'       	LEFT OUTER JOIN                                                  ' +
  '       CUSTOMER B                                                         ' +
  '    ON (A.CUST_REG_NO = B.CUST_REG_NO)                                    ' +
  '         LEFT OUTER JOIN                                                  ' +
  '       REGTABLE C                                                         ' +
  '    ON (A.CUST_REG_TYPE = C.REGCODE)                                      ' +
  '       	LEFT OUTER JOIN (SELECT AA.TA_REG_SEQ,                           ' +
  '                                 SUM(IF(BB.REG_GB = ''C'', 0, 1)) AS CNT  ' +
  '                            FROM TASUKDETAIL AA                           ' +
  '               					    		  LEFT OUTER JOIN                        ' +
  '                                 REGTABLE BB                              ' +
  '                              ON (AA.TA_REG_TYPE = BB.REGCODE)            ' +
  '                     							LEFT OUTER JOIN                        ' +
  '                                 CUSTOMER CC                              ' +
  '                              ON (AA.TA_REG_NO = CC.CUST_REG_NO)          ' +
  '                           WHERE AA.TA_DTE = CURDATE()                    ' +
  '                             AND   CC.CUST_CARD_NO = :CARD_NO             ' +
  '                             AND     TA_CAN_YN = ''0''                    ' +
  '                           GROUP BY  AA.TA_REG_SEQ) D                     ' +
  '    ON (A.CUST_ACT_NO = D.TA_REG_SEQ)                                     ' +
  ' WHERE (B.CUST_CARD_NO = :CARD_NO                                         ' +
  '          OR                                                              ' +
  '        B.CUST_REG_NO = :CODE)                                            ' +
  '   AND A.CUST_YN = ''0''                                                  ' +
  '   AND A.CUST_IN_START_DTE <= :Date                                       ' +
  '   AND A.CUST_IN_END_DTE >= :Date                                         ' +
  '   AND C.REG_GOLF = ''1''                                                 ' +
  '   AND CUST_STOP_YN <> 10                                                 ' +
  '   AND IF(C.REG_GB = ''C'', A.CUST_COK_QTY, 1) > 0                        ' +
  ' ORDER BY REG_GB DESC,                                                    ' +
  '          CUST_SEQ,                                                       ' +
  '          CUST_IN_START_DTE                                               ' +
  'LIMIT 3                                                                   ';

SQL_GM_TASUG_INFO =
  'SELECT COMMUNICATE.COM_MNO,                                               ' +
  '       COMMUNICATE.COM_START_TIME,                                        ' +
  '       COMMUNICATE.COM_END_TIME,                                          ' +
  '       SUBSCRIBER.SUB_START_TIME,                                         ' +
  '       SUBSCRIBER.SUB_END_TIME                                            ' +
  '  FROM  COMMUNICATE                                                       ' +
  '         LEFT OUTER JOIN                                                  ' +
  '        SUBSCRIBER                                                        ' +
  '    ON (COMMUNICATE.COM_HIGH = SUBSCRIBER.SUB_HIGH)                       ' +
  '   AND (COMMUNICATE.COM_TASUG = SUBSCRIBER.SUB_TASUG)                     ' +
  '   AND (COMMUNICATE.COM_MNO = SUBSCRIBER.SUB_MNO)                         ' +
  ' WHERE (COMMUNICATE.COM_HIGH = :COM_HIGH)                                 ' +
  '   AND (COMMUNICATE.COM_TASUG = :COM_TASUG)                               ' +
  ' ORDER BY COMMUNICATE.COM_MNO,                                            ' +
  '         COMMUNICATE.COM_END_TIME DESC,                                   ' +
  '         SUBSCRIBER.SUB_END_TIME DESC                                     ';

SQL_GM_INSERT_ACTUALWARFARE =
  'INSERT INTO ACTUALWARFARE                                                 ' +
  '(ACT_NO,                                                                  ' +
  ' ACT_DT,                                                                  ' +
  ' CUR_DT,                                                                  ' +
  ' ACT_TYPE,                                                                ' +
  ' ACT_REG_TYPE,                                                            ' +
  ' ACT_USER,                                                                ' +
  ' ACT_REG_NO,                                                              ' +
  ' ACT_REG_SEQ,                                                             ' +
  ' ACT_REG_NAME,                                                            ' +
  ' ACT_REG_SEX,                                                             ' +
  ' ACT_CASH_AMT,                                                            ' +
  ' ACT_CARD_AMT,                                                            ' +
  ' ACT_BIGO,                                                                ' +
  ' ACT_BF_NO,                                                               ' +
  ' ACT_IN_TIME,                                                             ' +
  ' BILL_NO,                                                                 ' +
  ' JONGMOK,                                                                 ' +
  ' DCAMT,                                                                   ' +
  ' VAT_GB,                                                                  ' +
  ' ACT_BF_SEQ,                                                              ' +
  ' STORE_ID,                                                                ' +
  ' BILL_SEQ,                                                                ' +
  ' POSNO,                                                                   ' +
  ' ACT_POINT_ADD,                                                           ' +
  ' ACT_POINT_DEL,                                                           ' +
  ' ACTREGSEQ,                                                               ' +
  ' BALANCE,                                                                 ' +
  ' REGTIME,                                                                 ' +
  ' REG_GB,                                                                  ' +
  ' ACT_SALECNT,                                                             ' +
  ' CHARGEAMT,                                                               ' +
  ' ACT_BF_DT)                                                               ' +
  ' VALUES                                                                   ' +
  '(SNNO,                                                                    ' +
  ' SJUBSU_DT,                                                               ' +
  ' DATE,                                                                    ' +
  ' SNTYPECODE,                                                              ' +
  ' SNREGTYPE,                                                               ' +
  ' USERID,                                                                  ' +
  ' SNREGNO,                                                                 ' +
  ' SNREGSEQ,                                                                ' +
  ' SNREGNAME,                                                               ' + // 이거 REPLACE해서 넣는 부분
  ' SNREGSEX,                                                                ' +
  ' SNAMTC,                                                                  ' +
  ' SNAMTD,                                                                  ' +
  ' SNBIGO,                                                                  ' + // 이거 REPLACE해서 넣는 부분
  ' CBILL,                                                                   ' +
  ' SJONGMOK,                                                                ' +
  ' VDCAMT,                                                                  ' +
  ' VVAT_GB,                                                                 ' +
  ' VACT_BF_SEQ,                                                             ' +
  ' STOREID,                                                                 ' +
  ' CBILLSEQ,                                                                ' +
  ' PPOS,                                                                    ' +
  ' VPOINT_ADD,                                                              ' +
  ' VPOINT_DEL,                                                              ' +
  ' GET_REGACTSEQ(SNREGSEQ, SNREGTYPE),                                      ' +
  ' VBALANCE,                                                                ' +
  ' VREGTIME,                                                                ' +
  ' CREG_GB,                                                                 ' +
  ' VACT_SALECNT,                                                            ' +
  ' VCHARGEAMT,                                                              ' +
  ' GET_ACT_BF_DT(SNBF_NO, VACT_BF_SEQ))                                     ';

SQL_GM_INSERT_ACTUALWARFARE_2 =
  'INSERT INTO ACTUALWARFARE                                                 ' +
  '(ACT_NO,                                                                  ' +
  ' ACT_DT,                                                                  ' +
  ' CUR_DT,                                                                  ' +
  ' ACT_TYPE,                                                                ' +
  ' ACT_REG_TYPE,                                                            ' +
  ' ACT_USER,                                                                ' +
  ' ACT_REG_NO,                                                              ' +
  ' ACT_REG_SEQ,                                                             ' +
  ' ACT_REG_NAME,                                                            ' +
  ' ACT_REG_SEX,                                                             ' +
  ' ACT_CASH_AMT,                                                            ' +
  ' ACT_CARD_AMT,                                                            ' +
  ' ACT_BIGO,                                                                ' +
  ' ACT_BF_NO,                                                               ' +
  ' ACT_IN_TIME,                                                             ' +
  ' BILL_NO,                                                                 ' +
  ' JONGMOK,                                                                 ' +
  ' DCAMT,                                                                   ' +
  ' VAT_GB,                                                                  ' +
  ' ACT_BF_SEQ,                                                              ' +
  ' STORE_ID,                                                                ' +
  ' BILL_SEQ,                                                                ' +
  ' POSNO,                                                                   ' +
  ' ACT_POINT_ADD,                                                           ' +
  ' ACT_POINT_DEL,                                                           ' +
  ' ACTREGSEQ,                                                               ' +
  ' BALANCE,                                                                 ' +
  ' REGTIME,                                                                 ' +
  ' REG_GB, CHARGEAMT, ACT_BF_DT)                                            ' +
  'VALUES                                                                    ' +
  '(SNNO,                                                                    ' +
  ' SJUBSU_DT,                                                               ' +
  ' DATE,                                                                    ' +
  ' SNTYPECODE,                                                              ' +
  ' SNREGTYPE,                                                               ' +
  ' USERID,                                                                  ' +
  ' SNREGNO,                                                                 ' +
  ' SNREGSEQ,                                                                ' +
  ' SNREGNAME,                                                               ' + // 이거 REPLACE해서 넣는 부분
  ' SNREGSEX,                                                                ' +
  ' SNAMTC,                                                                  ' +
  ' SNAMTD,                                                                  ' +
  ' SNBIGO,                                                                  ' + // 이거 REPLACE해서 넣는 부분
  ' CBILL,                                                                   ' +
  ' SJONGMOK,                                                                ' +
  ' VDCAMT,                                                                  ' +
  ' VVAT_GB,                                                                 ' +
  ' VACT_BF_SEQ,                                                             ' +
  ' STOREID,                                                                 ' +
  ' CBILLSEQ,                                                                ' +
  ' PPOS,                                                                    ' +
  ' VPOINT_ADD,                                                              ' +
  ' VPOINT_DEL,                                                              ' +
  ' VACTREGSEQ,                                                              ' +
  ' VBALANCE,                                                                ' +
  ' VREGTIME,                                                                ' +
  ' CREG_GB,                                                                 ' +
  ' VCHARGEAMT,                                                              ' +
  ' GET_ACT_BF_DT(SNBF_NO, VACT_BF_SEQ))                                     ';

SQL_GM_SEARCH_USE_WEEK =
  'SELECT REGTABLE.WEEKVAILD                                                 ' +
  '  FROM CUSTLIST LEFT OUTER JOIN REGTABLE                                  ' +
  '    ON (CUSTLIST.CUST_REG_TYPE = REGTABLE.REGCODE)                        ' +
  ' WHERE CUSTLIST.CUST_REG_NO = :CUST_REG_NO                                ' +
  '   AND CUSTLIST.CUST_ACT_NO = :CUST_ACT_NO                                ';

SQL_GM_GET_ACT_BF_DT =
  'SELECT ACT_DT                                                             ' +
  '  FROM ACTUALWARFARE                                                      ' +
  ' WHERE ACT_NO = :ACT_NO                                                   ' +
  '   AND ACT_SEQ = :ACT_SEQ                                                 ';

SQL_GM_GET_REGACTSEQ =
  'SELECT ACT_SEQ                                                            ' +
  '  FROM CUSTLIST                                                           ' +
  ' WHERE CUST_ACT_NO = :ACTNO                                               ' +
  '   AND CUST_REG_TYPE = :REGCODE                                           ';

SQL_GM_GET_MAXBILLSEQ =
  'SELECT MAX(BILL_SEQ) + 1 AS SEQ                                           ' +
  '  FROM ACTUALWARFARE                                                      ' +
  ' WHERE ACT_DT = :DATE                                                     ' +
  '   AND REG_GB = :REG_GB                                                   ' +
  '   AND STORE_ID = :STOREID                                                ';

SQL_GM_GET_REG_GB =
  'SELECT REGTABLE.REG_GB                                                    ' +
  '  FROM REGTABLE                                                           ' +
  ' WHERE REGTABLE.STORE_ID = :STOREID                                       ' +
  '   AND REGTABLE.REGCODE = :REGCODE                                        ';

SQL_GM_GET_MAXBILLNO =
  'SELECT SUM(IFNULL(A.CNT,0)) + 1 AS SUM                                    ' +
  '  FROM (SELECT 1 AS CNT                                                   ' +
  '          FROM ACTUALWARFARE                                              ' +
  '         WHERE ACT_DT = :DATE                                             ' +
  '         GROUP BY ACT_NO) A                                               ';

SQL_GM_GET_MAXBILL_1 =
  'SELECT BILL_NO                                                            ' +
  ' FROM ACTUALWARFARE                                                       ' +
  'WHERE ACT_NO= :ACTNO                                                      ';

SQL_GM_GET_MAXBILL_2 =
  'SELECT MAX(BILL_NO) + 1 AS MAXBILL_NO                                     ' +
  '  FROM ACTUALWARFARE                                                      ' +
  ' WHERE ACT_DT = :DATE                                                     ';

SQL_GM_HOLIDAY =
  'SELECT BIGO                                                               ' +
  '  FROM CALENDAR                                                           ' +
  ' WHERE (CALDATE = :CALDATE1 AND LUNAR = 1)                                ' +
  '    OR (CALDATE = :CALDATE2 AND LUNAR = 0)                                ';

SQL_GM_SUBSCRIBER =
  'INSERT INTO SUBSCRIBER                                                    ' +
  '(SUB_DTE,                                                                 ' +
  ' SUB_HIGH,                                                                ' +
  ' SUB_TASUG,                                                               ' +
  ' SUB_MNO,                                                                 ' +
  ' SUB_START_TIME,                                                          ' +
  ' SUB_END_TIME,                                                            ' +
  ' SUB_REG_NO,                                                              ' +
  ' SUB_PRONUM,                                                              ' +
  ' SUB_REG_SEQ,                                                             ' +
  ' SUB_REG_TYPE,                                                            ' +
  ' SUB_REG_NAME,                                                            ' +
  ' SUB_REG_SEX,                                                             ' +
  ' SUB_CARD_NO,                                                             ' +
  ' SUB_COK_QTY,                                                             ' +
  ' SUB_TIME,                                                                ' +
  ' SUB_BALL_QTY,                                                            ' +
  ' SUB_RL,                                                                  ' +
  ' SUB_USER,                                                                ' +
  ' SUB_BIGO,                                                                ' +
  ' SUB_ACNT_NO,                                                             ' +
  ' TA_ACTSEQ,                                                               ' +
  ' ACT_SEQ)                                                                 ' +
  'VALUES                                                                    ' +
  '(DATE,                                                                    ' +
  ' VSUB_HIGH,                                                               ' +
  ' VSUB_TASUG,                                                              ' +
  ' VSUB_MNO,                                                                ' +
  ' VSUB_START_TIME,                                                         ' +
  ' VSUB_END_TIME,                                                           ' +
  ' VSUB_REG_NO,                                                             ' +
  ' PRONUM,                                                                  ' +
  ' VSUB_REG_SEQ,                                                            ' +
  ' VSUB_REG_TYPE,                                                           ' +
  ' VSUB_REG_NAME,                                                           ' + // 이거 REPLACE해서 넣는 부분
  ' VSUB_REG_SEX,                                                            ' +
  ' VSUB_CARD_NO,                                                            ' +
  ' VSUB_COK_QTY,                                                            ' +
  ' VSUB_TIME,                                                               ' +
  ' VSUB_BALL_QTY,                                                           ' +
  ' COMRL,                                                                   ' +
  ' USERID,                                                                  ' +
  ' VSUB_BIGO,                                                               ' + // 이거 REPLACE해서 넣는 부분
  ' VSUB_ACNT_NO,                                                            ' +
  ' VTA_ACTSEQ,                                                              ' +
  ' VACTSEQ)                                                                 ';

// 상품을 선택 후 체크 해야 될 듯.  유효한 회원정보 체크
SQL_GM_MEMBER_CHECK_DATE =
  'SELECT CUST_REG_NO                                                        ' +
  '  FROM CUSTLIST                                                           ' +
  ' WHERE (CUST_REG_NO = :CUST_REG_NO)                                       ' +
  '   AND (CUST_ACT_NO = :CUST_ACT_NO)                                       ' +
  '   AND (ACT_SEQ = :ACT_SEQ)                                               ' +
  '   AND ((CUST_IN_START_DTE <= :CUST_IN_START_DTE)                         ' +
  '         AND (CUST_IN_END_DTE >= :CUST_IN_END_DTE))                       ' +
  '   AND (CUST_YN = ''0'')                                                  ';

// 입장 시간 체크
SQL_GM_MEMBER_CHECK_TIME =
  'SELECT B.CLASSGB,                                                         ' +
  '       C.STARTTM,                                                         ' +
  '       C.ENDTM,                                                           ' +
  '       B.REGCODE,                                                         ' +
  '  FROM CUSTLIST A                                                         ' +
  '         LEFT OUTER JOIN                                                  ' +
  '       REGTABLE B                                                         ' +
  '    ON A.CUST_REG_TYPE = B.REGCODE                                        ' +
  '         LEFT OUER JOIN                                                   ' +
  '       REGCLASS_MASTER C                                                  ' +
  '    ON A.CLASSID = C.CLASSID                                              ' +
  ' WHERE A.CUST_ACT_NO = :CUST_ACT_NO                                       ';

// 휴회 체크
SQL_GM_MEMBER_CHECK_HH =
  'SELECT CUST_START_DTE,                                                    ' +
  '       CUST_END_DTE,                                                      ' +
  '       CUST_REG_NO                                                        ' +
  '  FROM CUSTDETAIL                                                         ' +
  ' WHERE CUST_REG_NO = :CUST_REG_NO                                         ' +
  '   AND CUST_ACT_NO = :CUST_ACT_NO                                         ' +
  '   AND ACT_SEQ = :ACT_SEQ                                                 ' +
  '   AND CUST_START_DTE <= :CUST_START_DTE                                  ' +
  '   AND CUST_END_DTE >= :CUST_END_DTE                                      ' +
  '   AND CUST_WK_GB = ''2''                                                 ';

// 중지일 체크
SQL_GM_MEMBER_CHECK_STOP =
  'SELECT CUST_STOP_DTE                                                      ' +
  '  FROM CUSTLIST                                                           ' +
  ' WHERE CUST_ACT_NO = :CUST_ACT_NO                                         ' +
  '   AND ACT_SEQ = :ACT_SEQ                                                 ' +
  '   AND CUST_YN = ''0''                                                    ' +
  '   AND CUST_STOP_YN = ''10''                                              ';

// Reg_Ta_Count
SQL_GM_REG_TA_COUNT =
  'SELECT COUNT(*) CNT                                                       ' +
  '  FROM TASUKDETAIL                                                        ' +
  ' WHERE TA_REG_NO = :TA_REG_NO                                             ' +
  '   AND TA_REG_SEQ = :TA_REG_SEQ                                           ' +
  '   AND ACT_SEQ = :ACT_SEQ                                                 ' +
  '   AND TA_COK_QTY = 0                                                     ' +
  '   AND TA_CAN_YN = 0                                                      ' +
  '   AND JONGMOK = :JONGMOK                                                 ' +
  '   AND TA_DTE = :TA_DTE                                                   ';

//SQL_GM_MAIN_TASUK_INFO_1 =
//  'SELECT A.COM_MNO,                                                         ' +
//  '       A.COM_TASUG,                                                       ' +
//  '       A.COM_STOP,                                                        ' +
//  '       A.COM_SUB_CLS,                                                     ' +
//  '       A.COM_ERR,                                                         ' +
//  '       A.COM_HIGH,                                                        ' +
//  '       A.COM_TASUG,                                                       ' +
//  '       A.COM_END_TIME,                                                    ' +
//  '       A.COM_MA_TIME,                                                     ' +
//  '       IFNULL(B.END_TIME, '''') AS ENDT                                   ' +
//  '  FROM COMMUNICATE A                                                      ' +
//  '         LEFT JOIN (SELECT SUB_HIGH,                                      ' +
//  '                           SUB_TASUG,                                     ' +
//  '                           MAX(SUB_END_TIME) AS END_TIME                  ' +
//  '                      FROM SUBSCRIBER                                     ' +
//  '                     GROUP BY SUB_HIGH,                                   ' +
//  '                              SUB_TASUG) B                                ' +
//  '    ON A.COM_HIGH = B.SUB_HIGH                                            ' +
//  '   AND A.COM_TASUG = B.SUB_TASUG                                          ' +
//  ' ORDER BY A.COM_HIGH,                                                     ' +
//  '          A.COM_TASUG                                                     ';

SQL_GM_MAIN_TEEBOX_INFO_1 =
  'select * from ( ' +
  'SELECT A.COM_MNO,                                                         ' +
//  '       A.COM_TASUG,                                                       ' +
  '       A.COM_STOP,                                                        ' +
  '       A.COM_SUB_CLS,                                                     ' +
  '       A.COM_ERR,                                                         ' +
  '       A.COM_HIGH,                                                        ' +
  '       A.COM_TASUG,                                                       ' +
  '       A.COM_END_TIME,                                                    ' +
  '       A.COM_MA_TIME,                                                     ' +
  '       IFNULL(B.END_TIME, '''') AS ENDT                                   ' +
  '  FROM COMMUNICATE A                                                      ' +
  '         LEFT JOIN (SELECT SUB_HIGH,                                      ' +
  '                           SUB_TASUG,                                     ' +
  '                           MAX(SUB_END_TIME) AS END_TIME                  ' +
  '                      FROM SUBSCRIBER                                     ' +
  '                     GROUP BY SUB_HIGH,                                   ' +
  '                              SUB_TASUG) B                                ' +
  '    ON A.COM_HIGH = B.SUB_HIGH                                            ' +
  '   AND A.COM_TASUG = B.SUB_TASUG                                          ' +
  ' ORDER BY A.COM_HIGH,                                                     ' +
  '          A.COM_TASUG                                                     ' +
  ' ) T1                         ' +
  'order by COM_TASUG, ENDT, COM_MA_TIME ';

SQL_GM_MAIN_TEEBOX_INFO_2 =
  'SELECT A.COM_LINE_STOP,                                                   ' +
  '       A.TOUCHNO,                                                         ' +
  '       A.COM_MNO,                                                         ' +
  '       A.COM_STOP,                                                        ' +
  '       A.COM_SUB_CLS,                                                     ' +
  '       A.COM_ERR,                                                         ' +
  '       A.COM_HIGH,                                                        ' +
  '       A.COM_TASUG,                                                       ' +
  '       A.COM_END_TIME,                                                    ' +
  '       A. COM_MA_TIME,                                                    ' +
  '       IFNULL(B.END_TIME, '''') AS ENDT,                                  ' +
  '       (SELECT C.PRO_COLOR                                                ' +
  '          FROM CUSTLIST A                                                 ' +
  '                 LEFT OUTER JOIN REGCLASS_MASTER B                        ' +
  '            ON (A.CLASSID = B.CLASSID)                                    ' +
  '                 LEFT OUTER JOIN INTUSER C                                ' +
  '            ON (B.PTID = C.USER_ID)                                       ' +
  '         WHERE B.REGGUBUN = ''T''                                         ' +
  '           AND A.CUST_REG_NO = A.COM_REG_NO                               ' +
  '         ORDER BY A.CUST_ACT_NO DESC,                                     ' +
  '                  A.ACT_SEQ DESC LIMIT 1) AS PRO_COLOR                    ' +
  '  FROM COMMUNICATE A                                                      ' +
  '         LEFT JOIN (SELECT SUB_HIGH,                                      ' +
  '                           SUB_TASUG,                                     ' +
  '                           MAX(SUB_END_TIME) AS END_TIME                  ' +
  '                      FROM SUBSCRIBER                                     ' +
  '                     GROUP BY SUB_HIGH,                                   ' +
  '                              SUB_TASUG) B                                ' +
  '           ON A.COM_HIGH = B.SUB_HIGH                                     ' +
  '          AND A.COM_TASUG = B.SUB_TASUG                                   ' +
  ' ORDER BY A.COM_HIGH,                                                     ' +
  '          A.COM_TASUG                                                     ';

SQL_GM_SELECT_CUSTOMER =
  'SELECT CUST_REG_NO,                                                       ' +
  '       CUST_CARD_NO,                                                      ' +
  '       CUST_REG_NAME,                                                     ' +
  '       CUST_SEX,                                                          ' +
  '       AES_DECRYPT(UNHEX(CUST_H_TEL), ''dlekdls'') as CUST_H_TEL,         ' +
  '       AES_DECRYPT(UNHEX(CUST_HP_TEL), ''dlekdls'') as CUST_HP_TEL,       ' +
  '       CUST_CAR_NO,                                                       ' +
  '  FROM CUSTOMER                                                           ' +
  ' WHERE CUST_CARD_NO = :CUST_CARD_NO                                       ';

SQL_GM_TEEBOX_PRODUCT =
  'select     ' +
  'REGCODE,      ' +
  'REGGRPNAME,      ' +
  'REGCODENAME,        ' +
  'REGAMT,                ' +
  'REGSEX                    ' +
  'from                      ' +
  'regtable                 ' +
  'where ((REGGRPNAME = ''정회원'') or (REGGRPNAME = ''쿠폰회원'') or (REGGRPNAME = ''일일입장''))';

implementation

end.
