unit uLocalSQL;

interface

const

LOCAL_SALE_H_INSERT =
  'INSERT INTO SL_SALE_H                                                     ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE,                                                                ' +
  ' NO_POS,                                                                  ' +
  ' NO_RCP,                                                                  ' +
  ' TOTAL_AMT,                                                               ' +
  ' SALE_AMT,                                                                ' +
  ' VAT_AMT,                                                                 ' +
  ' DC_AMT)                                                                  ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE,                                                               ' +
  ' :NO_POS,                                                                 ' +
  ' :NO_RCP,                                                                 ' +
  ' :TOTAL_AMT,                                                              ' +
  ' :SALE_AMT,                                                               ' +
  ' :VAT_AMT,                                                                ' +
  ' :DC_AMT)                                                                 ';

LOCAL_SALE_H_MAX_RCP_NO =
  'SELECT NULLIF(MAX(NO_RCP), 0) NO_RCP                                      ' +
  '  FROM SL_SALE_H                                                          ' +
  ' WHERE CD_STORE = :CD_STORE                                               ' +
  '   AND YMD_SALE = :YMD_SALE                                               ' +
  '   AND NO_POS = :NO_POS                                                   ';

LOCAL_SALE_D_INSERT =
  'INSERT INTO SL_SALE_D                                                     ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE,                                                                ' +
  ' NO_POS,                                                                  ' +
  ' NO_RCP,                                                                  ' +
  ' SEQ,                                                                     ' +
  ' QTY,                                                                     ' +
  ' CD_MENU,                                                                 ' +
  ' SALE_PRICE,                                                              ' +
  ' SALE_AMT,                                                                ' +
  ' VAT_AMT,                                                                 ' +
  ' DC_AMT)                                                                  ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE,                                                               ' +
  ' :NO_POS,                                                                 ' +
  ' :NO_RCP,                                                                 ' +
  ' :SEQ,                                                                    ' +
  ' :QTY,                                                                    ' +
  ' :CD_MENU,                                                                ' +
  ' :SALE_PRICE,                                                             ' +
  ' :SALE_AMT,                                                               ' +
  ' :VAT_AMT,                                                                ' +
  ' :DC_AMT)                                                                 ';

LOCAL_PAY_INSERT =
  'INSERT INTO SL_PAY                                                        ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE,                                                                ' +
  ' NO_POS,                                                                  ' +
  ' NO_RCP,                                                                  ' +
  ' SEQ,                                                                     ' +
  ' CD_PAY,                                                                  ' +
  ' SALE_AMT,                                                                ' +
  ' VAT_AMT)                                                                 ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE,                                                               ' +
  ' :NO_POS,                                                                 ' +
  ' :NO_RCP,                                                                 ' +
  ' :SEQ,                                                                    ' +
  ' :CD_PAY,                                                                 ' +
  ' :SALE_AMT,                                                               ' +
  ' :VAT_AMT)                                                                ';

LOCAL_CARD_INSERT =
  'INSERT INTO SL_CARD                                                       ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE,                                                                ' +
  ' NO_POS,                                                                  ' +
  ' NO_RCP,                                                                  ' +
  ' SEQ,                                                                     ' +
  ' APPROVAL,                                                                ' +
  ' SALE_AMT,                                                                ' +
  ' NO_CARD,                                                                 ' +
  ' HALBU,                                                                   ' +
  ' NO_APPROVAL,                                                             ' +
  ' NO_TRADE,                                                                ' +
  ' TRANSDATETIME,                                                           ' +
  ' CD_BAL,                                                                  ' +
  ' NM_BAL,                                                                  ' +
  ' CD_COMP,                                                                 ' +
  ' NM_COMP)                                                                 ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE,                                                               ' +
  ' :NO_POS,                                                                 ' +
  ' :NO_RCP,                                                                 ' +
  ' :SEQ,                                                                    ' +
  ' :APPROVAL,                                                               ' +
  ' :SALE_AMT,                                                               ' +
  ' :NO_CARD,                                                                ' +
  ' :HALBU,                                                                  ' +
  ' :NO_APPROVAL,                                                            ' +
  ' :NO_TRADE,                                                               ' +
  ' :TRANSDATETIME,                                                          ' +
  ' :CD_BAL,                                                                 ' +
  ' :NM_BAL,                                                                 ' +
  ' :CD_COMP,                                                                ' +
  ' :NM_COMP)                                                                ';

LOCAL_PAYCO_INSERT =
  'INSERT INTO SL_PAYCO                                                      ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE,                                                                ' +
  ' NO_POS,                                                                  ' +
  ' NO_RCP,                                                                  ' +
  ' SEQ,                                                                     ' +
  ' APPROVAL,                                                                ' +
  ' SALE_AMT,                                                                ' +
  ' NO_CARD,                                                                 ' +
  ' HALBU,                                                                   ' +
  ' NO_APPROVAL,                                                             ' +
  ' NO_TRADE,                                                                ' +
  ' TRANSDATETIME,                                                           ' +
  ' CD_BAL,                                                                  ' +
  ' NM_BAL,                                                                  ' +
  ' CD_COMP,                                                                 ' +
  ' NM_COMP,                                                                 ' +
  ' POINT_AMT,                                                               ' +
  ' NM_POINT,                                                                ' +
  ' COUPON_AMT,                                                              ' +
  ' NM_COUPON)                                                               ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE,                                                               ' +
  ' :NO_POS,                                                                 ' +
  ' :NO_RCP,                                                                 ' +
  ' :SEQ,                                                                    ' +
  ' :APPROVAL,                                                               ' +
  ' :SALE_AMT,                                                               ' +
  ' :NO_CARD,                                                                ' +
  ' :HALBU,                                                                  ' +
  ' :NO_APPROVAL,                                                            ' +
  ' :NO_TRADE,                                                               ' +
  ' :TRANSDATETIME,                                                          ' +
  ' :CD_BAL,                                                                 ' +
  ' :NM_BAL,                                                                 ' +
  ' :CD_COMP,                                                                ' +
  ' :NM_COMP,                                                                ' +
  ' :POINT_AMT,                                                              ' +
  ' :NM_POINT,                                                               ' +
  ' :COUPON_AMT,                                                             ' +
  ' :NM_COUPON)                                                              ';

LOCAL_DISCOUNT_INSERT =
  'INSERT INTO SL_DISCOUNT                                                   ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE,                                                                ' +
  ' NO_POS,                                                                  ' +
  ' NO_RCP,                                                                  ' +
  ' SEQ,                                                                     ' +
  ' QR_CODE,                                                                 ' +
  ' DC_AMT,                                                                  ' +
  ' NM_DISCOUNT)                                                             ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE,                                                               ' +
  ' :NO_POS,                                                                 ' +
  ' :NO_RCP,                                                                 ' +
  ' :SEQ,                                                                    ' +
  ' :QR_CODE,                                                                ' +
  ' :DC_AMT,                                                                 ' +
  ' :NM_DISCOUNT)                                                            ';

SQL_MS_ADVERTIS_D_SELECT_SEQ =
  'SELECT *                                                                  ' +
  '  FROM MS_ADVERTIS_D                                                      ' +
  ' WHERE CD_STORE = :CD_STORE                                               ' +
  '   AND YMD_SALE = :YMD_SALE                                               ' +
  '   AND SEQ = :SEQ                                                         ';

SQL_MS_ADVERTIS_D_INSERT_SEQ =
  'INSERT INTO MS_ADVERTIS_D                                                 ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE,                                                                ' +
  ' SEQ)                                                                     ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE,                                                               ' +
  ' :SEQ)                                                                    ';

SQL_MS_ADVERTIS_D_UPDATE_SEQ =
  'UPDATE MS_ADVERTIS_D                                                      ' +
  '   SET @TIME@ = @TIME@ + 1                                                ' +
  ' WHERE CD_STORE = :CD_STORE                                               ' +
  '   AND YMD_SALE = :YMD_SALE                                               ' +
  '   AND SEQ = :SEQ                                                         ';

SQL_MS_ADVERTIS_H_SELECT =
  'SELECT *                                                                  ' +
  '  FROM MS_ADVERTIS_H                                                      ' +
  ' WHERE CD_STORE = :CD_STORE                                               ' +
  '   AND YMD_SALE = :YMD_SALE                                               ';

SQL_MS_ADVERTIS_H_UPDATE =
  'UPDATE MS_ADVERTIS_H                                                      ' +
  '   SET :SET_TIME = 1                                                      ' +
  ' WHERE CD_STORE = :CD_STORE                                               ' +
  '   AND YMD_SALE = :YMD_SALE                                               ';

SQL_MS_ADVERTIS_H_INSERT =
  'INSERT INTO MS_ADVERTIS_H                                                 ' +
  '(CD_STORE,                                                                ' +
  ' YMD_SALE)                                                                ' +
  'VALUES                                                                    ' +
  '(:CD_STORE,                                                               ' +
  ' :YMD_SALE)                                                               ';

// AD
SQL_LOCAL_AD_SELECT_PRODUCT_USE_INFO =
  'SELECT USE_STATUS                                                         ' +
  '  FROM SEAT_USE                                                           ' +
  ' WHERE STORE_CD = :STORE_CD                                               ' +
  '   AND USE_SEQ_DATE = :USE_SEQ_DATE                                       ' +
  '   AND PURCHASE_SEQ = :PURCHASE_SEQ                                       ' +
  '   AND PRODUCT_SEQ = :PRODUCT_SEQ                                         ' +
  '   AND ERP_YN <> ''U''                                                    ';

SQL_PARKING_INSERT =
  'INSERT INTO FIX_CAR                                                       ' +
  '(NO,                                                                      ' +
  ' CAR_NUM,                                                                 ' +
  ' NAME,                                                                    ' +
  ' START_DAY,                                                               ' +
  ' END_DAY,                                                                 ' +
  ' GATE_SEL,                                                                ' +
  ' WEEK,                                                                    ' +
  ' NOUSE)                                                                   ' +
  'VALUES                                                                    ' +
  '(:NO,                                                                     ' +
  ' :CAR_NUM,                                                                ' +
  ' :NAME,                                                                   ' +
  ' :START_DAY,                                                              ' +
  ' :END_DAY,                                                                ' +
  ' :GATE_SEL,                                                               ' +
  ' :WEEK,                                                                   ' +
  ' :NOUSE)                                                                  ';

implementation

end.
