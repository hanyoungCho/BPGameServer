unit Common.BPDM;

interface

uses
  { Native }
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls, Data.DB,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  { Indy }
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, IdSSLOpenSSL,
  { UniDAC }
  Uni, UniProvider, MySQLUniProvider, DBAccess, MemDS, MemData,
  { Absolute Database }
  ABSMain,
  { DevExpress }
  cxStyles, cxClasses,
  { VAN }
  uVanDaemonModule, uPaycoNewModule,
  { Project }
  Common.BPGlobal;

{$I Common.BPCommon.inc}

type
  TBPDM = class(TDataModule)
    AntiFreeze: TIdAntiFreeze;
    LocalDB: TABSDatabase;
    MariaDB: TUniConnection;
    MySQLUniProvider: TMySQLUniProvider;
    csrGridStyle: TcxStyleRepository;
    StyleBandHeader: TcxStyle;
    StyleContentEven: TcxStyle;
    StyleContentOdd: TcxStyle;
    StyleFooter: TcxStyle;
    StyleGroupByBox: TcxStyle;
    StyleHeader1: TcxStyle;
    StyleHeader2: TcxStyle;
    StyleInactive2: TcxStyle;
    StyleInactive: TcxStyle;
    StyleSelection2: TcxStyle;
    StyleSelection: TcxStyle;
    imcWeather: TImageCollection;
    imcIcons: TImageCollection;
    imlIcon16: TVirtualImageList;
    imlIcon32: TVirtualImageList;
    SPAssignList: TUniStoredProc;
    SPGameStatus: TUniStoredProc;
    QRAssignList: TABSQuery;
    QRGameList: TABSQuery;
    QRClubList: TABSQuery;
    QRCodeList: TABSQuery;
    QRCreditCardList: TABSQuery;
    QRLaneList: TABSQuery;
    QRLockerList: TABSQuery;
    QRMemberGroupList: TABSQuery;
    QRMemberList: TABSQuery;
    QRMemberLocker: TABSQuery;
    QRMembership: TABSQuery;
    QRPayment: TABSQuery;
    QRPaymentList: TABSQuery;
    QRPaymentPend: TABSQuery;
    QRPluList: TABSQuery;
    QRProdGame: TABSQuery;
    QRProdGeneral: TABSQuery;
    QRProdLocker: TABSQuery;
    QRProdRent: TABSQuery;
    QRReceipt: TABSQuery;
    QRReceiptList: TABSQuery;
    QRSaleItem: TABSQuery;
    QRSaleItemList: TABSQuery;
    QRSaleItemPend: TABSQuery;
    QRWeatherToday: TABSQuery;
    QRWeatherWeek: TABSQuery;
    QRReceiptPend: TABSQuery;
    QRProdMembership: TABSQuery;
    QRRallyList: TABSQuery;
    QRRallyEntryList: TABSQuery;
    QRReserveList: TABSQuery;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

    procedure MariaDBBeforeConnect(Sender: TObject);
    procedure MariaDBAfterConnect(Sender: TObject);
    procedure MariaDBAfterDisconnect(Sender: TObject);
    procedure MariaDBConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure MariaDBError(Sender: TObject; E: EDAError; var Fail: Boolean);
    procedure SPGameStatusBeforeOpen(DataSet: TDataSet);
    procedure SPAssignListBeforeOpen(DataSet: TDataSet);
    procedure QRMemberListAfterOpen(DataSet: TDataSet);
    procedure QRMemberListCalcFields(DataSet: TDataSet);
    procedure QRReceiptListAfterOpen(DataSet: TDataSet);
    procedure QRReceiptListCalcFields(DataSet: TDataSet);
    procedure QRPaymentListAfterOpen(DataSet: TDataSet);
    procedure QRSaleItemAfterOpen(DataSet: TDataSet);
    procedure QRSaleItemCalcFields(DataSet: TDataSet);
    procedure QRPaymentListCalcFields(DataSet: TDataSet);
    procedure QRAssignListAfterOpen(DataSet: TDataSet);
    procedure QRAssignListCalcFields(DataSet: TDataSet);
    procedure QRMembershipCalcFields(DataSet: TDataSet);
    procedure QRMembershipAfterOpen(DataSet: TDataSet);
    procedure QRMemberLockerAfterOpen(DataSet: TDataSet);
    procedure QRMemberLockerCalcFields(DataSet: TDataSet);
    procedure QRRallyListCalcFields(DataSet: TDataSet);
    procedure QRRallyListAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function OpenABSDatabase(const ADBFile: string; var AResMsg: string): Boolean;
    function RefreshABSDataSet(const ADataSet: TDataSet; var AResMsg: string): Boolean;
    function ExecuteABSQuery(const ASQL: string; var AResMsg: string; const AInMemory: Boolean=False): Boolean;
    function DeleteABSRecord(const ATableName, AWhereSQL: string; const AUseBackup: Boolean; var AResMsg: string): Boolean;
    function CreateABSMemTable(var AResMsg: string): Boolean;
    function EmptyABSTable(const ATableName: string; const AInMemory: Boolean=False): Boolean;
    function GetABSDataSet(const ASQL: string): TDataSet;
    function GetABSMaxSeq(const ATableName: string): Integer;
    function GetABSRecordCount(const ASQL: string; var AResMsg: string; const AInMemory: Boolean=False): Integer;
    function MakeNewReceipt(const AAssignLaneNo: ShortInt; var AReceiptNo, AResMsg: string): Boolean;
    function GetNewReceiptNo: string;

    function GetICReaderVerify(var AResMsg: string): Boolean;
    function GetCardBinDiscount(const ACardBinNo, AProdDiv: string; const AApproveAmt: Integer; var APromoSeq, ADiscountAmt: Integer; var AResMsg: string): Boolean;
    function CheckCheque(const CR: TChequeRec; var AResMsg: string): Boolean;

    function UpdateReceipt(const AReceiptNo: string; var AResMsg: string): Boolean;
    function UpdateSaleItem(var AReceiptNo: string; const APR: TProdItemRec; var AResMsg: string): Boolean;
    function UpdatePayment(const AAssignLaneNo: ShortInt; const AIsSaleMode, ADeleteExists: Boolean; const APR: TPaymentItemRec; var AResMsg: string): Boolean;
    function UpdateCancelPaymentList(APR: TPaymentItemRec; const ANewApproveNo: string; var AResMsg: string): Boolean;
    function DoPaymentPAYCO(const AIsApproval, AIsSaleMode: Boolean; var AResMsg: string): Boolean;

    function CleanReceipt(var AResMsg: string): Boolean;
    function RefreshReceipt(var AResMsg: string): Boolean;
    function RefreshSaleItem(const AReceiptNo: string; var AResMsg: string): Boolean;
    function RefreshPayment(const AReceiptNo: string; var AResMsg: string): Boolean;

    function RefreshMemberList(var AResMsg: string): Boolean; overload;
    function RefreshMemberList(const AFieldName, ASearchValue: string; var AResMsg: string): Boolean; overload;
    function RefreshMemberList(const AFieldName, ASearchValue, AFieldName2, ASearchValue2: string; var AResMsg: string): Boolean; overload;
    function FindMemberInfo(const AMemberNo: string=''): Boolean;

    function GetWeatherInfo: Boolean; overload;
    function GetWeatherInfo(var AResMsg: string): Boolean; overload;
    function RefreshLaneStatus(var AResMsg: string): Boolean;
    function RefreshAssignList(var AResMsg: string): Boolean;

    function RequestToGameServer(const AApiName, AReqJson: string; var ARespJson, AResMsg: string): Boolean;
    function LaneControlCommand(const AApiName: string; const ALaneNo: ShortInt; const AItemName, AValue: string; var AResMsg: string): Boolean;
    function BowlerControlCommand(const AApiName, AAssignNo, ABowlerId, AItemName, AValue: string; var AResMsg: string): Boolean;

    function InitLane(const ALaneNo: ShortInt; var AResMsg: string): Boolean;
    function SetPinSetter(const ALaneNo: ShortInt; const ASetting: Boolean; var AResMsg: string): Boolean;
    function SetGameMonitor(const ALaneNo: ShortInt; const ASetting: Boolean; var AResMsg: string): Boolean;
    function SetGameNext(const ALaneNo: ShortInt; var AResMsg: string): Boolean;
    function SetLeagueMode(const ALaneNo: ShortInt; const ALeagueMode: Boolean; var AResMsg: string): Boolean;
    function SetHoldLane(const ALaneNo: ShortInt; const AHoldMode: Boolean; var AResMsg: string): Boolean;
    function SetMaintenanceLane(const ALaneNo: ShortInt; const ALockMode: Boolean; var AResMsg: string): Boolean;
    function SetPinSettingType(const ALaneNo, ASettingType: ShortInt; var AResMsg: string): Boolean;
    function CancelGame(const ALaneNo: ShortInt; const AAssignNo: string; var AResMsg: string): Boolean;
    function RestoreGame(const ALaneNo: ShortInt; var AResMsg: string): Boolean;

    function SetBowlerPause(const AAssignNo, ABowlerId: string; const AValue: Boolean; var AResMsg: string): Boolean;
    function SetGameScore(const AAssignNo, ABowlerid: string; const AGameScore: string; var AResMsg: string): Boolean;
    function SetPaymentType(const AAssignNo, ABowlerId: string; const APaymentType: Integer; var AResMsg: string): Boolean;
    function SetBowlerThrowOrder(const AAssignNo, ABowlerId: string; const AOrderSeq: Integer; var AResMsg: string): Boolean;
    function RemoveBowler(const AAssignNo, ABowlerId: string; var AResMsg: string): Boolean;

    function AssignGame(const ARallyMode: Boolean; const AReceiptNo: string; const AAR: TArray<TGameAssignRec>; var AResMsg: string): Boolean;
    function AddBowler(const ALaneNo: ShortInt; const AAssignNo: string; const ABowlerRec: TBowlerRec; var AResMsg: string): Boolean;
    function ChangeBowler(const ALaneNo: ShortInt; const AAssignNo: string; const ANewBowlerRec: TBowlerRec; var AResMsg: string): Boolean;
    function RelocateLane(const ALaneNo, ATargetLaneNo: ShortInt; var AResMsg: string): Boolean;
    function RelocateBowler(const AAssignNo, ABowlerId: string; const ATargetLaneNo: ShortInt; var AResMsg: string): Boolean;

    function RequestToPartnerCenter(const AProcName, AUrl, AMethod, AReqJson: string; var ARespJson, AResMsg: string): Boolean;
    function GetToken(const AHostUrl, ATerminalId, ASecretKey: string; var AToken, AResMsg: string): Boolean;
    function CheckLogin(const AUserId, ATerminalPwd: string; const ASaveId: Boolean; var AResMsg: string): Boolean;
    function GetStoreInfo(const AStoreCode: string; var AResMsg: string): Boolean;
    function GetTerminalInfo(const ATerminalId: string; var AResMsg: string): Boolean;
    function GetCodeList(var AResMsg: string): Boolean; overload;
    function GetCodeList(const AGroupCode: string; var AResMsg: string): Boolean; overload;
    function GetLaneList(var AResMsg: string): Boolean;
    function GetLockerList(var AResMsg: string): Boolean;
    function GetClubList(var AResMsg: string): Boolean;
    function GetMemberList(var AResMsg: string): Boolean;
    function GetMembership(const AMemberNo: string; var AResMsg: string): Boolean; overload;
    function GetMembership(const AMemberNo, AQrCode, AMobileNo: string; var AResMsg: string): Boolean; overload;
    function GetProdGameList(var AResMsg: string): Boolean; overload;
    function GetProdGameList(const AProdCode, AFeeDiv, ABaseDateTime: string; const ATodaySaleOnly: Boolean; var AResMsg: string): Boolean; overload;
    function GetProdMembershipList(var AResMsg: string): Boolean; overload;
    function GetProdLockerList(var AResMsg: string): Boolean;
    function GetProdRentList(var AResMsg: string): Boolean;
    function GetProdGeneralList(var AResMsg: string): Boolean;
    function GetPluList(var AResMsg: string): Boolean;
    function GetSaleList(const AStartDate, AEndDate, AReceiptNo: string; var AResMsg: string): Boolean;
    function GetSaleDetailList(const AReceiptNo: string; var AResMsg: string): Boolean;
    function GetRallyList(const AStartDate, AEndDate, ARallyTitle: string; const AClubSeq: Integer; var AResMsg: string): Boolean;
    function GetRallyEntryList(const ARallySeq: Integer; var AResMsg: string): Boolean;

    function PostProdSale(ARI: TReceiptItemInfo; ASL: TArray<TProdItemRec>; APL: TArray<TPaymentItemRec>; var AResMsg: string): Boolean;
    function PostMember(const ANewMember: Boolean; const AMemberRec: TMemberInfoRec; var AResMsg: string): Boolean;
    function PostLockerClose(const ALockerNo: SmallInt; var AResMsg: string): Boolean;
    function PostSystemSetting(var AResMsg: string): Boolean;

    function PostCancelPayment(APL: TArray<TPaymentItemRec>; const AReceiptNo, AOrgReceiptNo: string; var AResMsg: string): Boolean;
    function PostCancelPaymentPartial(APR: TPaymentItemRec; const ANewApproveNo: string; var AResMsg: string): Boolean;
    function PostUpdateCashPayment(APR: TPaymentItemRec; var AResMsg: string): Boolean;
    function PostRallySetting(const RR: TRallyInfoRec; var AResMsg: string): Boolean;

    function OpenProdDataSet(const AGameDiv: ShortInt; const AProdDiv, ADetailDiv, AFeeDiv: string; const AMembershipOnly, ATodaySaleOnly: Boolean; var AResMsg: string): Boolean;

    function AddPending(const AAssignLaneList: string; var AResMsg: string): Boolean;
    function DeletePending(const AReceiptNo: string; var AResMsg: string): Boolean;
    function LoadPending(const AReceiptNo: string; var AResMsg: string): Boolean;

    function MakeReceiptJson(ARI: TReceiptItemInfo; ASL: TArray<TProdItemRec>; APL: TArray<TPaymentItemRec>; const ASaleDate, ASaleTime: string; var AResMsg: string): string;
    function MakeCancelReceiptJson(ARI: TReceiptItemInfo; APL: TArray<TPaymentItemRec>; var AResMsg: string): string;
  end;

var
  BPDM: TBPDM;
  SSL: TIdSSLIOHandlerSocketOpenSSL;

function ActivateCkDLL(var AResMsg: string): Boolean;

implementation

uses
  { Native }
  System.DateUtils, System.Variants, System.StrUtils, System.Math,
  { Indy }
  IdGlobal, IdTCPClient, IdHTTP, IdURI,
  { Chilkat DLL API }
  Chilkat.Global, Chilkat.JsonObject, Chilkat.JsonArray,
  { Absolute Database }
  ABSTypes, ABSConverts,
  { Project }
  Common.BPCommonLib;

{%CLASSGROUP 'Vcl.Controls.TControl'}

procedure AddAllFields(ADataSet: TDataSet);
var
  LFieldsList: TStringList;
  LFieldName: WideString;
  LField: TField;
  LWasActive: Boolean;
  LFieldDef: TFieldDef;
begin
  LWasActive := ADataSet.Active;
  if LWasActive then
    ADataSet.Active := False;
  try
    LFieldsList := TStringList.Create;
    try
      ADataSet.FieldDefs.Update;
      for var I: ShortInt := 0 to Pred(ADataSet.FieldDefList.Count) do
        with ADataSet.FieldDefList[I] do
          if (FieldClass <> nil) and not (faHiddenCol in Attributes) then
          begin
            LFieldName := ADataSet.FieldDefList.Strings[I];
            LField := ADataSet.FindField(LFieldName);
            if (LField = nil) or (LField.Owner <> ADataSet.Owner) then
              LFieldsList.Add(LFieldName);
          end;
      for var I: ShortInt := 0 to Pred(LFieldsList.Count) do
      begin
        LFieldDef := ADataSet.FieldDefList.FieldByName(LFieldName);
        LField := LFieldDef.CreateField(ADataSet.Owner, nil, LFieldName, False);
        try
           LField.name := LFieldName + IntToStr(random(MaxInt)); // make the name unique
        except
           LField.Free;
           raise ;
        end;
      end;
    finally
      LFieldsList.Free;
    end;
  finally
    if LWasActive then
      ADataSet.Active := True;
  end;
end;

procedure CreateField(ADataSet: TDataSet; const AFieldName: string; const AFieldKind: TFieldKind; const AFieldType: TFieldType; const AFieldSize: Integer);
begin
  case AFieldType of
    ftShortInt,
    ftSmallInt,
    ftInteger,
    ftLargeInt:
      with TIntegerField.Create(ADataSet) do
      begin
        Name := ADataSet.Name + AFieldName;
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        DataSet := ADataSet;
      end;
    ftString:
      with TStringField.Create(ADataSet) do
      begin
        Name := ADataSet.Name + AFieldName;
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        Size := AFieldSize;
        DataSet := ADataSet;
      end;
    ftBoolean:
      with TBooleanField.Create(ADataSet) do
      begin
        Name := ADataSet.Name + AFieldName;
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        DataSet := ADataSet;
      end;
    ftFloat:
      with TFloatField.Create(ADataSet) do
      begin
        Name := ADataSet.Name + AFieldName;
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        DataSet := ADataSet;
      end;
    ftMemo:
      with TMemoField.Create(ADataSet) do
      begin
        Name := ADataSet.Name + AFieldName;
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        Size := 0;
        DataSet := ADataSet;
      end;
  end;
end;

function ActivateCkDLL(var AResMsg: string): Boolean;
var
  CkGlobal: HCkGlobal;
  LStatus: Integer;
begin
  Result := False;
  AResMsg := '';
  CkGlobal := CkGlobal_Create;
  try
    try
      if not CkGlobal_UnlockBundle(CkGlobal, CO_SDK_LIC_CKDLL_KEY) then
        raise Exception.Create(CkGlobal__lastErrorText(CkGlobal));
      LStatus := CkGlobal_getUnlockStatus(CkGlobal);
      if (LStatus <> 2) then
        raise Exception.Create(Format('ErrorStatus: %d', [LStatus]));
      Result := True;
    finally
      CkGlobal_Dispose(CkGlobal);
    end;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('ActivateCkDLL.Exception = %s', [AResMsg]));
    end;
  end;
end;

{$R *.dfm}

procedure TBPDM.DataModuleCreate(Sender: TObject);
begin
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.Method := sslvSSLv23;
  SSL.SSLOptions.Mode := sslmClient;
end;

procedure TBPDM.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(SSL);
end;

procedure TBPDM.MariaDBBeforeConnect(Sender: TObject);
begin
  with TUniConnection(Sender) do
  begin
    ProviderName := 'MySQL';
    LoginPrompt := False;
    Database := Global.GameServer.DBName;
    SpecificOptions.Clear;
    SpecificOptions.Add('MySQL.CharSet=euckr');
    SpecificOptions.Add('MySQL.UseUniCode=False');
    SpecificOptions.Add(Format('MySQL.ConnectionTimeOut=%d', [Global.GameServer.DBTimeout div 1000]));
    Server := Format('%s,%d Allow User Variables=True', [Global.GameServer.DBHost, Global.GameServer.DBPort]);
    Port := Global.GameServer.DBPort;
    UserName := Global.GameServer.DBUserId;
    Password := Global.GameServer.DBPassword;
  end;
end;

procedure TBPDM.MariaDBAfterConnect(Sender: TObject);
begin
  SendToMainForm(CPC_MAIN_STATUS, CMP_GAME_SERVER_ON);
end;

procedure TBPDM.MariaDBAfterDisconnect(Sender: TObject);
begin
  SendToMainForm(CPC_MAIN_STATUS, CMP_GAME_SERVER_OFF);
end;

procedure TBPDM.MariaDBConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
  RetryMode := rmReconnectExecute;
end;

procedure TBPDM.MariaDBError(Sender: TObject; E: EDAError; var Fail: Boolean);
begin
  SendToMainForm(CPC_MAIN_STATUS, CMP_GAME_SERVER_OFF);
end;

procedure TBPDM.SPGameStatusBeforeOpen(DataSet: TDataSet);
begin
  SPGameStatus.Params.ParamValues['p_store_cd'] := Global.StoreInfo.StoreCode;
end;

procedure TBPDM.SPAssignListBeforeOpen(DataSet: TDataSet);
begin
  SPAssignList.Params.ParamValues['p_store_cd'] := Global.StoreInfo.StoreCode;
//  SPAssignList.Params.ParamValues['p_assign_dt'] := Global.DateTime.CurrentDate;
end;

function TBPDM.OpenABSDatabase(const ADBFile: string; var AResMsg: string): Boolean;
begin
  Result := False;
  AResMsg := '';
  try
    LocalDB.DatabaseFileName := ADBFile;
    if LocalDB.Connected then
      LocalDB.Connected := False;
    LocalDB.CompactDatabase;
    LocalDB.RepairDatabase;
    LocalDB.Connected := True;
    if not CleanReceipt(AResMsg) then
      raise Exception.Create(AResMsg);
    SendToMainForm(CPC_MAIN_STATUS, CMP_GAME_SERVER_DB_ON);
    Result := True;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      LocalDB.Connected := False;
      SendToMainForm(CPC_MAIN_STATUS, CMP_GAME_SERVER_DB_OFF);
      UpdateLog(Format('OpenABSDatabase.Exception = %s', [E.Message]));
    end;
  end;
end;

function TBPDM.RefreshABSDataSet(const ADataSet: TDataSet; var AResMsg: string): Boolean;
begin
  Result := False;
  with ADataSet do
  try
    try
      DisableControls;
      Close;
      Open;
      Result := True;
    finally
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('RefreshABSDataSet.Exception = %s', [E.Message]));
    end;
  end;
end;

function TBPDM.ExecuteABSQuery(const ASQL: string; var AResMsg: string; const AInMemory: Boolean): Boolean;
begin
  Result := False;
  AResMsg := '';
  with TABSQuery.Create(nil) do
  try
    try
      if AInMemory then
        InMemory := True
      else
        DatabaseName := LocalDB.DatabaseName;
      SQL.Text := ASQL;
{$IFDEF DEBUG}
      SQL.SaveToFile(Global.DirInfo.LogDir + 'ExecuteABSQuery.sql');
{$ENDIF}
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('ExecuteABSQuery.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;

function TBPDM.DeleteABSRecord(const ATableName, AWhereSQL: string; const AUseBackup: Boolean; var AResMsg: string): Boolean;
begin
  Result := False;
  AResMsg := '';
  with TABSQuery.Create(nil) do
  try
    DatabaseName := LocalDB.DatabaseName;
    try
      if AUseBackup then
      begin
        SQL.Add(Format('INSERT INTO %s (SELECT * FROM %s WHERE %s);', [ATableName + 'Backup', ATableName, AWhereSQL]));
        SQL.Add(Format('UPDATE %s SET user_id = %s, update_dttm = %s WHERE %s;',
                  [ATableName + 'Backup', Global.UserInfo.UserId.QuotedString, Global.DateTime.FormattedCurrentDateTime.QuotedString, AWhereSQL]));
      end;
      SQL.Add(Format('DELETE FROM %s WHERE %s;', [ATableName, AWhereSQL]));
{$IFDEF DEBUG}
      SQL.SaveToFile(Global.DirInfo.LogDir + 'DeleteABSRecord.sql');
{$ENDIF}
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('DeleteABSRecord.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;

function TBPDM.CreateABSMemTable(var AResMsg: string): Boolean;
var
  LTable: TABSTable;
  LTableName, LFieldDef: string;
begin
  Result := False;
  LTable := TABSTable.Create(nil);
  LTable.DatabaseName := LocalDB.DatabaseName;
  with TABSQuery.Create(nil) do
  try
    InMemory := True;
    try
      LTableName := 'MTGameList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', lane_no SHORTINT DEFAULT 0'); //레인 번호
      SQL.Add(', lane_status SHORTINT DEFAULT 0'); //레인 상태 (0:대기<빈 레인>, 1:예약, 2:홀드, 3:진행)
      SQL.Add(', assign_lane_no SHORTINT DEFAULT 0'); //최초 예약(배정) 등록한 레인 번호
      SQL.Add(', assign_no VARCHAR(12)'); //배정 번호 (배정일자(8) + 배정SEQ(4))
      SQL.Add(', game_div SHORTINT DEFAULT 0'); //게임 방식 (1:게임제, 2:시간제, 3:할인제)
      SQL.Add(', rally_seq INTEGER DEFAULT 0'); //대회 순번
      SQL.Add(', league_yn LOGICAL DEFAULT False'); //리그게임 여부
      SQL.Add(', lane_shift_method VARCHAR(1)'); //레인 이동 방식 (G:일반, B:좌우, X:크로스)
      SQL.Add(', lane_shift_cnt SHORTINT DEFAULT 0'); //레인 이동 수
      SQL.Add(', assign_root_div VARCHAR(1)'); //예약 위치
      SQL.Add(', start_datetime DATETIME'); //배정 시작 시각
      SQL.Add(', expected_end_datetime DATETIME'); //예상 종료 시각
      SQL.Add(', bowler_seq SHORTINT DEFAULT 0'); //볼러SEQ
      SQL.Add(', entry_seq INTEGER DEFAULT 0'); //대회 참가자 순번
      SQL.Add(', handy SMALLINT DEFAULT 0'); //핸디
      SQL.Add(', shoes_rent_yn LOGICAL DEFAULT False'); //볼링화 대여 여부
      SQL.Add(', bowler_id VARCHAR(3)'); //01A, 01B...
      SQL.Add(', bowler_nm VARCHAR(50)'); //볼러명
      SQL.Add(', member_no VARCHAR(8)'); //회원 번호
      SQL.Add(', membership_seq INTEGER DEFAULT 0'); //회원권 구매 순번(0보다 큰 값이면 회원권을 사용하여 배정한 것으로 판단)
      SQL.Add(', membership_use_cnt SHORTINT DEFAULT 0'); //게임제 회원권인 경우 이용 게임 수
      SQL.Add(', membership_use_min SMALLINT DEFAULT 0'); //시간제 회원권인 경우 이용 게임 시간(분)
      SQL.Add(', prod_cd VARCHAR(10)'); //게임 상품코드
      SQL.Add(', payment_type SHORTINT DEFAULT 0'); //결제 방법 (0:후불, 1:선불)
      SQL.Add(', fee_div VARCHAR(2)'); //요금제 구분 (01:일반, 02:회원, 03:학생, 04:클럽)
      SQL.Add(', game_cnt SHORTINT DEFAULT 0'); //배정한 게임 수
      SQL.Add(', game_min SMALLINT DEFAULT 0'); //배정한 게임 수
      SQL.Add(', game_fin SHORTINT DEFAULT 0'); //완료한 게임 수
      SQL.Add(', direction SHORTINT DEFAULT 0'); //레인 사용 상태 (0:대기, 1: 왼쪽투구, 2:오른쪽 투구)
      SQL.Add(', frame_no SHORTINT DEFAULT 0'); //현재 게임 중인 프레임 번호
      SQL.Add(', pin_fall_result VARCHAR(21)'); //전체 프레임별 점수 (112233445566778899000) Ex.: 9/9000000000000000000
      SQL.Add(', total_score SMALLINT DEFAULT 0');
      SQL.Add(', frame1_score SHORTINT DEFAULT 0'); //프레임별 점수
      SQL.Add(', frame2_score SHORTINT DEFAULT 0');
      SQL.Add(', frame3_score SHORTINT DEFAULT 0');
      SQL.Add(', frame4_score SHORTINT DEFAULT 0');
      SQL.Add(', frame5_score SHORTINT DEFAULT 0');
      SQL.Add(', frame6_score SHORTINT DEFAULT 0');
      SQL.Add(', frame7_score SHORTINT DEFAULT 0');
      SQL.Add(', frame8_score SHORTINT DEFAULT 0');
      SQL.Add(', frame9_score SHORTINT DEFAULT 0');
      SQL.Add(', frame10_score SHORTINT DEFAULT 0');
      SQL.Add(', frame1_pin VARCHAR(2)'); //프레임별 핀 상태(16진수)
      SQL.Add(', frame2_pin VARCHAR(2)');
      SQL.Add(', frame3_pin VARCHAR(2)');
      SQL.Add(', frame4_pin VARCHAR(2)');
      SQL.Add(', frame5_pin VARCHAR(2)');
      SQL.Add(', frame6_pin VARCHAR(2)');
      SQL.Add(', frame7_pin VARCHAR(2)');
      SQL.Add(', frame8_pin VARCHAR(2)');
      SQL.Add(', frame9_pin VARCHAR(2)');
      SQL.Add(', frame10_pin VARCHAR(2)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTable.Close;
      LTableName := 'MTAssignList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', receipt_no VARCHAR(20)');
      SQL.Add(', assign_seq INTEGER DEFAULT 0');
      SQL.Add(', assign_bowler_seq INTEGER DEFAULT 0');
      SQL.Add(', assign_no VARCHAR(12)');
      SQL.Add(', assign_lane_no SHORTINT DEFAULT 0');
      SQL.Add(', lane_no SHORTINT DEFAULT 0');
      SQL.Add(', game_div SHORTINT DEFAULT 0');
      SQL.Add(', rally_seq INTEGER DEFAULT 0'); //대회 순번
      SQL.Add(', league_yn LOGICAL DEFAULT False');
      SQL.Add(', lane_shift_method VARCHAR(1)'); //레인 이동 방식 (G:일반, B:좌우, X:크로스)
      SQL.Add(', lane_shift_cnt SHORTINT DEFAULT 0'); //레인 이동 수
      SQL.Add(', assign_status SHORTINT DEFAULT 0');
      SQL.Add(', assign_index SHORTINT DEFAULT 0');
      SQL.Add(', assign_index_nm VARCHAR(10)');
      SQL.Add(', assign_root_div VARCHAR(1)');
      SQL.Add(', reserve_datetime DATETIME');
      SQL.Add(', expected_end_datetime DATETIME');
      SQL.Add(', bowler_seq SHORTINT DEFAULT 0');
      SQL.Add(', entry_seq INTEGER DEFAULT 0'); //대회 참가자 순번
      SQL.Add(', handy SMALLINT DEFAULT 0');
      SQL.Add(', shoes_rent_yn LOGICAL DEFAULT False');
      SQL.Add(', bowler_id VARCHAR(3)');
      SQL.Add(', bowler_nm VARCHAR(50)');
      SQL.Add(', member_no VARCHAR(8)');
      SQL.Add(', membership_seq INTEGER DEFAULT 0'); //회원권 구매 순번(0보다 큰 값이면 회원권을 사용하여 배정한 것으로 판단)
      SQL.Add(', membership_use_cnt SHORTINT DEFAULT 0'); //게임제 회원권인 경우 이용 게임 수
      SQL.Add(', membership_use_min SMALLINT DEFAULT 0'); //시간제 회원권인 경우 이용 게임 시간(분)
      SQL.Add(', game_start SHORTINT DEFAULT 0');
      SQL.Add(', game_cnt SHORTINT DEFAULT 0');
      SQL.Add(', game_min INTEGER DEFAULT 0');
      SQL.Add(', game_fin SHORTINT DEFAULT 0');
      SQL.Add(', frame_no SHORTINT DEFAULT 0');
      SQL.Add(', direction SHORTINT DEFAULT 0');
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', payment_type SHORTINT DEFAULT 0'); //결제 방법 (0:후불, 1:선불)
      SQL.Add(', fee_div VARCHAR(2)'); //요금제 구분 (01:일반, 02:회원, 03:학생, 04:클럽)
      SQL.Add(', use_status SHORTINT DEFAULT 0');
      SQL.Add(', user_id VARCHAR(10)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTable.Close;
      LTableName := 'MTRallyList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', rally_seq INTEGER DEFAULT 0'); //competition_seq
      SQL.Add(', rally_nm VARCHAR(100)'); //competition_nm
      SQL.Add(', club_nm VARCHAR(100)');
      SQL.Add(', entry_cnt INTEGER DEFAULT 0'); //participants_cnt
      SQL.Add(', lane_nm VARCHAR(50)');
      SQL.Add(', game_cnt INTEGER DEFAULT 0');
      SQL.Add(', rally_datetime VARCHAR(19)'); //competition_datetime
      SQL.Add(', team_yn LOGICAL DEFAULT False');
      SQL.Add(', league_yn LOGICAL DEFAULT False');
      SQL.Add(', lane_move_cnt INTEGER DEFAULT 0');
      SQL.Add(', move_method VARCHAR(1) DEFAULT ''G'''); //G:일반이동, B:좌우이동, X:Cross이동
      SQL.Add(', rank_nohandy_yn LOGICAL DEFAULT False');
      SQL.Add(', rank_highlow_yn LOGICAL DEFAULT False');
      SQL.Add(', rank_birth_yn LOGICAL DEFAULT False');
      SQL.Add(', reg_datetime VARCHAR(19)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTable.Close;
      LTableName := 'MTRallyEntryList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', rally_seq INTEGER DEFAULT 0'); //competition_seq
      SQL.Add(', entry_seq INTEGER DEFAULT 0'); //participants_seq
      SQL.Add(', member_div VARCHAR(20)');
      SQL.Add(', club_seq INTEGER DEFAULT 0');
      SQL.Add(', club_nm VARCHAR(100)');
      SQL.Add(', member_no VARCHAR(8)');
      SQL.Add(', bowler_nm VARCHAR(20)');
      SQL.Add(', mobile_no VARCHAR(20)');
      SQL.Add(', birthday VARCHAR(8)');
      SQL.Add(', lane_no SHORTINT DEFAULT 0');
      SQL.Add(', game_cnt SHORTINT DEFAULT 0');
      SQL.Add(', handy SMALLINT DEFAULT 0');
      SQL.Add(', reg_datetime VARCHAR(19)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTable.Close;
      LTable.TableName := 'TBReceipt';
      LTable.Open;
      LTableName := 'MTReceiptList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (', [LTableName]));
      for var I: ShortInt := 0 to Pred(LTable.AdvFieldDefs.Count) do
      begin
        LFieldDef := LTable.AdvFieldDefs[I].Name;
        if (LTable.AdvFieldDefs[i].DataType = aftString) then
          LFieldDef := LFieldDef + ' VARCHAR'
        else
          LFieldDef := LFieldDef + ' ' + AftToStr(LTable.AdvFieldDefs[I].DataType);
        if IsSizebleFieldType(LTable.AdvFieldDefs[I].DataType) then
          LFieldDef := LFieldDef + Format('(%d)', [LTable.AdvFieldDefs[I].Size]);
        SQL.Add(Format('%s%s', [IfThen(I = 0, '', ', '), LFieldDef]));
      end;
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTable.Close;
      LTable.TableName := 'TBSaleItem';
      LTable.Open;
      LTableName := 'MTSaleItemList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (', [LTableName]));
      for var I: ShortInt := 0 to Pred(LTable.AdvFieldDefs.Count) do
      begin
        LFieldDef := LTable.AdvFieldDefs[I].Name;
        if (LTable.AdvFieldDefs[i].DataType = aftString) then
          LFieldDef := LFieldDef + ' VARCHAR'
        else
          LFieldDef := LFieldDef + ' ' + AftToStr(LTable.AdvFieldDefs[I].DataType);
        if IsSizebleFieldType(LTable.AdvFieldDefs[I].DataType) then
          LFieldDef := LFieldDef + Format('(%d)', [LTable.AdvFieldDefs[I].Size]);
        SQL.Add(Format('%s%s', [IfThen(I = 0, '', ', '), LFieldDef]));
      end;
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTable.Close;
      LTable.TableName := 'TBPayment';
      LTable.Open;
      LTableName := 'MTPaymentList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (', [LTableName]));
      for var I: ShortInt := 0 to Pred(LTable.AdvFieldDefs.Count) do
      begin
        LFieldDef := LTable.AdvFieldDefs[I].Name;
        if (LTable.AdvFieldDefs[i].DataType = aftString) then
          LFieldDef := LFieldDef + ' VARCHAR'
        else
          LFieldDef := LFieldDef + ' ' + AftToStr(LTable.AdvFieldDefs[I].DataType);
        if IsSizebleFieldType(LTable.AdvFieldDefs[I].DataType) then
          LFieldDef := LFieldDef + Format('(%d)', [LTable.AdvFieldDefs[I].Size]);
        SQL.Add(Format('%s%s', [IfThen(I = 0, '', ', '), LFieldDef]));
      end;
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTCodeList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', group_cd VARCHAR(50)');
      SQL.Add(', code VARCHAR(5)');
      SQL.Add(', code_nm VARCHAR(50)');
      SQL.Add(', sort_ord SMALLINT DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTLaneList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', lane_no SHORTINT DEFAULT 0');
      SQL.Add(', lane_nm VARCHAR(20)');
      SQL.Add(', device_id VARCHAR(20)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTLockerList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', locker_no SMALLINT DEFAULT 0');
      SQL.Add(', locker_nm VARCHAR(20)');
      SQL.Add(', locker_zone_code VARCHAR(2)');
      SQL.Add(', locker_zone_name VARCHAR(20)');
      SQL.Add(', locker_layer_code VARCHAR(2)');
      SQL.Add(', locker_layer_name VARCHAR(20)');
      SQL.Add(', sex_div SHORTINT DEFAULT 0');
      SQL.Add(', locker_status SHORTINT DEFAULT 0');
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', member_no VARCHAR(8)');
      SQL.Add(', member_nm VARCHAR(50)');
      SQL.Add(', tel_no VARCHAR(20)');
      SQL.Add(', keep_amt INTEGER DEFAULT 0');
      SQL.Add(', start_dt VARCHAR(10)');
      SQL.Add(', end_dt VARCHAR(10)');
      SQL.Add(', locker_memo MEMO');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTClubList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', club_seq INTEGER DEFAULT 0');
      SQL.Add(', club_nm VARCHAR(100)');
      SQL.Add(', boss_nm VARCHAR(20)');
      SQL.Add(', tel_no VARCHAR(20)');
      SQL.Add(', dc_rate INTEGER DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTMemberList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', member_no VARCHAR(8)');
      SQL.Add(', member_nm VARCHAR(50)');
      SQL.Add(', club_seq INTEGER DEFAULT 0');
      SQL.Add(', club_nm VARCHAR(100)');
      SQL.Add(', member_div VARCHAR(2)');
      SQL.Add(', member_group_code VARCHAR(5)');
      SQL.Add(', sex_div SHORTINT DEFAULT 0');
      SQL.Add(', birthday VARCHAR(8)');
      SQL.Add(', tel_no VARCHAR(20)');
      SQL.Add(', email VARCHAR(50)');
      SQL.Add(', car_no VARCHAR(20)');
      SQL.Add(', zipno VARCHAR(5)');
      SQL.Add(', addr VARCHAR(100)');
      SQL.Add(', addr2 VARCHAR(100)');
      SQL.Add(', member_memo MEMO');
      SQL.Add(', save_point INTEGER DEFAULT 0');
      SQL.Add(', ad_agree_yn LOGICAL DEFAULT False');
      SQL.Add(', qrcd VARCHAR(50)');
      SQL.Add(', fp_hash VARCHAR(500)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTMembership';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', member_no VARCHAR(8)');
      SQL.Add(', membership_seq INTEGER 0');
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', prod_detail_div VARCHAR(5)');
      SQL.Add(', game_div SHORTINT DEFAULT 0');
      SQL.Add(', discount_fee_div VARCHAR(2)');
      SQL.Add(', purchase_game_cnt SMALLINT DEFAULT 0');
      SQL.Add(', remain_game_cnt SMALLINT DEFAULT 0');
      SQL.Add(', purchase_game_min SMALLINT DEFAULT 0');
      SQL.Add(', remain_game_min SMALLINT DEFAULT 0');
      SQL.Add(', purchase_datetime VARCHAR(19)');
      SQL.Add(', use_status SHORTINT DEFAULT 0');
      SQL.Add(', start_dt VARCHAR(10)');
      SQL.Add(', end_dt VARCHAR(10)');
      SQL.Add(', shoes_free_yn LOGICAL DEFAULT False');
      SQL.Add(', save_point_rate SMALLINT DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTMemberLocker';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', member_no VARCHAR(8)');
      SQL.Add(', locker_no SMALLINT DEFAULT 0');
      SQL.Add(', locker_nm VARCHAR(20)');
      SQL.Add(', locker_zone_code VARCHAR(5)');
      SQL.Add(', locker_layer_code VARCHAR(5)');
      SQL.Add(', locker_status SHORTINT DEFAULT 0');
      SQL.Add(', start_dt VARCHAR(10)');
      SQL.Add(', end_dt VARCHAR(10)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTProdGame';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', membership_yn LOGICAL DEFAULT False');
      SQL.Add(', prod_detail_div VARCHAR(5)');
      SQL.Add(', prod_detail_div_nm VARCHAR(50)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', apply_dow_string VARCHAR(8)');
      SQL.Add(', apply_start_tm VARCHAR(5)');
      SQL.Add(', apply_end_tm VARCHAR(5)');
      SQL.Add(', prod_amt INTEGER DEFAULT 0');
      SQL.Add(', game_div SHORTINT DEFAULT 0');
      SQL.Add(', fee_div VARCHAR(2)');
      SQL.Add(', discount_fee_div VARCHAR(2)');
      SQL.Add(', use_game_cnt SMALLINT DEFAULT 0');
      SQL.Add(', use_game_min SMALLINT DEFAULT 0');
      SQL.Add(', sale_zone_code VARCHAR(2)');
      SQL.Add(', today_yn LOGICAL DEFAULT False');
      SQL.Add(', use_yn LOGICAL DEFAULT False');
      SQL.Add(', expire_day SMALLINT DEFAULT 0'); //회원권 상품 전용
      SQL.Add(', shoes_free_yn LOGICAL DEFAULT False'); //회원권 상품 전용
      SQL.Add(', save_point_rate SMALLINT DEFAULT 0'); //회원권 상품 전용
      SQL.Add(', prod_benefits VARCHAR(500)'); //회원권 상품 전용
      SQL.Add(', sort_ord SMALLINT DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTProdLocker';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', prod_detail_div VARCHAR(5)');
      SQL.Add(', prod_detail_div_nm VARCHAR(50)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', prod_amt INTEGER DEFAULT 0');
      SQL.Add(', sale_zone_code VARCHAR(2)');
      SQL.Add(', locker_layer_code VARCHAR(2)');
      SQL.Add(', sex_div SHORTINT DEFAULT 0');
      SQL.Add(', use_yn LOGICAL DEFAULT False');
      SQL.Add(', sort_ord SMALLINT DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTProdRent';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', prod_detail_div VARCHAR(5)');
      SQL.Add(', prod_detail_div_nm VARCHAR(50)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', prod_amt INTEGER DEFAULT 0');
      SQL.Add(', sale_zone_code VARCHAR(2)');
      SQL.Add(', use_yn LOGICAL DEFAULT False');
      SQL.Add(', sort_ord SMALLINT DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTProdGeneral';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', prod_detail_div VARCHAR(5)');
      SQL.Add(', prod_detail_div_nm VARCHAR(50)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', prod_amt INTEGER DEFAULT 0');
      SQL.Add(', sale_zone_code VARCHAR(2)');
      SQL.Add(', use_yn LOGICAL DEFAULT False');
      SQL.Add(', sort_ord SMALLINT DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTPluList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', prod_div VARCHAR(2)');
      SQL.Add(', prod_div_nm VARCHAR(50)');
      SQL.Add(', prod_detail_div VARCHAR(3)');
      SQL.Add(', prod_detail_div_nm VARCHAR(50)');
      SQL.Add(', prod_cd VARCHAR(10)');
      SQL.Add(', prod_nm VARCHAR(50)');
      SQL.Add(', sale_zone_code VARCHAR(2)');
      SQL.Add(', sort_ord SMALLINT DEFAULT 0');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTCreditCardList';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', code VARCHAR(4)');
      SQL.Add(', issuer VARCHAR(12)');
      SQL.Add(', acquirer VARCHAR(12)');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0602'), QuotedStr('광주카드'), QuotedStr('비씨카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0200'), QuotedStr('국민카드'), QuotedStr('국민카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0201'), QuotedStr('농협카드'), QuotedStr('농협카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0902'), QuotedStr('롯데카드'), QuotedStr('롯데카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0900'), QuotedStr('롯데아멕스'), QuotedStr('롯데카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0100'), QuotedStr('비씨카드'), QuotedStr('비씨카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0400'), QuotedStr('삼성카드'), QuotedStr('삼성카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0202'), QuotedStr('수협카드'), QuotedStr('비씨카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0500'), QuotedStr('신한카드'), QuotedStr('신한카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0206'), QuotedStr('씨티카드'), QuotedStr('비씨카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0603'), QuotedStr('전북카드'), QuotedStr('비씨카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0301'), QuotedStr('제주카드'), QuotedStr('비씨카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0300'), QuotedStr('하나카드'), QuotedStr('하나카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0207'), QuotedStr('한미카드'), QuotedStr('비씨카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0800'), QuotedStr('현대카드'), QuotedStr('현대카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0801'), QuotedStr('해외다이너스'), QuotedStr('현대카드')]));
      SQL.Add(Format('INSERT INTO %s (code, issuer, acquirer) VALUES (%s, %s, %s);', [LTableName, QuotedStr('0901'), QuotedStr('해외아멕스'), QuotedStr('해외아멕스')]));
      ExecSQL;

      LTableName := 'MTWeatherToday';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', datetime DATETIME');
      SQL.Add(', weather_id INTEGER DEFAULT 0');
      SQL.Add(', icon_idx SHORTINT DEFAULT 0');
      SQL.Add(', temper VARCHAR(20)');
      SQL.Add(', precipit VARCHAR(10)');
      SQL.Add(', humidity VARCHAR(10)');
      SQL.Add(', wind_speed VARCHAR(10)');
      SQL.Add(', condition VARCHAR(30)');
      SQL.Add(', icon BLOB');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      LTableName := 'MTWeatherWeek';
      SQL.Clear;
      SQL.Add(Format('DROP TABLE %s;', [LTableName]));
      SQL.Add(Format('CREATE TABLE %s (seq AUTOINC', [LTableName]));
      SQL.Add(', datetime DATETIME');
      SQL.Add(', weather_id INTEGER DEFAULT 0');
      SQL.Add(', icon_idx SHORTINT DEFAULT 0');
      SQL.Add(', temper VARCHAR(20)');
      SQL.Add(', precipit VARCHAR(10)');
      SQL.Add(', humidity VARCHAR(10)');
      SQL.Add(', wind_speed VARCHAR(10)');
      SQL.Add(', condition VARCHAR(30)');
      SQL.Add(', icon BLOB');
      SQL.Add(Format(', PRIMARY KEY %s_PK (seq)', [LTableName]));
      SQL.Add(');');
      ExecSQL;

      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('CreateABSMemTable(%s).Exception = %s', [LTableName, E.Message]));
      end;
    end;
  finally
    LTable.Close;
    LTable.Free;
    Close;
    Free;
  end;
end;

function TBPDM.EmptyABSTable(const ATableName: string; const AInMemory: Boolean): Boolean;
var
  LResMsg: string;
begin
  Result := False;
  try
    if not ExecuteABSQuery(Format('TRUNCATE TABLE %s;', [IfThen(AInMemory, 'MEMORY ', '') + ATableName]), LResMsg, AInMemory) then
      raise Exception.Create(LResMsg);
    Result := True;
  except
    on E: Exception do
      UpdateLog(Format('EmptyABSTable.Exception = %s', [E.Message]));
  end;
end;

function TBPDM.GetABSDataSet(const ASQL: string): TDataSet;
begin
  Result := TABSQuery.Create(nil);
  with TABSQuery(Result) do
  begin
    DatabaseName := LocalDB.DatabaseName;
    SQL.Text := ASQL;
    Open;
  end;
end;

function TBPDM.GetABSMaxSeq(const ATableName: string): Integer;
begin
  with TABSQuery.Create(nil) do
  try
    DatabaseName := LocalDB.DatabaseName;
    try
      SQL.Text := Format('SELECT COALESCE(MAX(seq), 0) AS max_seq FROM %s;', [ATableName]);
    except
      SQL.Text := Format('SELECT COALESCE(MAX(seq), 0) AS max_seq FROM %s;', [ATableName]);
    end;
    Open;
    Result := FieldByName('max_seq').AsInteger;
  finally
    Close;
    Free;
  end;
end;

function TBPDM.GetABSRecordCount(const ASQL: string; var AResMsg: string; const AInMemory: Boolean): Integer;
begin
  Result := 0;
  AResMsg := '';
  with TABSQuery.Create(nil) do
  try
    try
      if AInMemory then
        InMemory := True
      else
        DatabaseName := LocalDB.DatabaseName;
      SQL.Text := ASQL;
{$IFDEF DEBUG}
      SQL.SaveToFile(Global.DirInfo.LogDir + 'GetABSRecordCount.sql');
{$ENDIF}
      Open;
      Result := RecordCount;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
{$IFDEF DEBUG}
        UpdateLog(Format('GetABSRecordCount.SQL = %s', [ASQL]));
{$ENDIF}
        UpdateLog(Format('GetABSRecordCount.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;

function TBPDM.MakeNewReceipt(const AAssignLaneNo: ShortInt; var AReceiptNo, AResMsg: string): Boolean;
var
  LSQL: string;
begin
  Result := False;
  AReceiptNo := GetNewReceiptNo;
  try
    LSQL := Format('INSERT INTO TBReceipt (receipt_no, assign_lane_no, pos_no, sale_dt, sale_tm, user_id) VALUES (%s, %d, %d, %s, %s, %s);', [
        AReceiptNo.QuotedString,
        AAssignLaneNo,
        Global.TerminalInfo.PosNo,
        Global.DateTime.FormattedCurrentDate.QuotedString,
        Global.DateTime.FormattedCurrentTime.QuotedString,
        Global.UserInfo.UserId.QuotedString
      ]);
    if not ExecuteABSQuery(LSQL, AResMsg) then
      raise Exception.Create(AResMsg);
    if not RefreshReceipt(AResMsg) then
      raise Exception.Create(AResMsg);
    Result := True;
  except
    on E: Exception do
    begin
      AResMsg := '영수증 데이터를 생성할 수 없습니다.' + _CRLF + E.Message;
      UpdateLog(Format('MakeNewReceipt(%s).Exception = %s', [AReceiptNo, E.Message]));
    end;
  end;
end;

function TBPDM.GetNewReceiptNo: string;
begin
  Result := Global.StoreInfo.StoreCode +
    LeftPad(Copy(Global.PartnerCenter.TerminalId, 8, 3), '0', 3) +
    Copy(Global.DateTime.CurrentDate, 3, 6) + //yymmdd
    Global.DateTime.CurrentTime; // hhmiss
end;

function TBPDM.GetICReaderVerify(var AResMsg: string): Boolean;
var
  LResMsg: AnsiString;
begin
  Result := False;
  AResMsg := '';
  try
    if (not VanModule.CallICReaderVerify(Global.TerminalInfo.VanTID, LResMsg)) then
      raise Exception.Create(LResMsg);
    Result := True;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('GetICReaderVerify.Exception = %s', [E.Message]));
    end;
  end;
end;

function TBPDM.GetCardBinDiscount(const ACardBinNo, AProdDiv: string; const AApproveAmt: Integer; var APromoSeq, ADiscountAmt: Integer; var AResMsg: string): Boolean;
const
  CS_API = 'K608_PromotionCardBin'; //확인 필요
var
  JO: HCkJsonObject;
  LUri, LRespJson, LResCode: string;
  bUsePos, bUseKiosk: Boolean;
begin
  Result := False;
  APromoSeq := 0;
  ADiscountAmt := 0;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?store_cd=%s&bin_no=%s&apply_amt=%d&product_div=%s', [CS_API, Global.StoreInfo.StoreCode, ACardBinNo, AApproveAmt, AProdDiv]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      bUsePos := (CkJsonObject__stringOf(JO, 'result_data.pos_use_yn') = CO_RESULT_YES);
      bUseKiosk := (CkJsonObject__stringOf(JO, 'result_data.kiosk_use_yn') = CO_RESULT_YES);
      if (not bUsePos) then
        raise Exception.Create('프런트에서 즉시할인 적용이 불가한 카드입니다.' + IfThen(bUseKiosk, _CRLF + '(키오스크에서만 할인 적용 가능)', ''));

      APromoSeq := StrToIntDef(CkJsonObject__stringOf(JO, 'pc_seq'), 0);
      ADiscountAmt := StrToIntDef(CkJsonObject__stringOf(JO, 'dc_amt'), 0);
      if (APromoSeq = 0) then
        raise Exception.Create('즉시할인을 적용할 수 없습니다.');
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.CheckCheque(const CR: TChequeRec; var AResMsg: string): Boolean;
var
  SI: TCardSendInfoDM;
  RI: TCardRecvInfoDM;
begin
  try
    SI.CheckNo    := CR.ChequeNo; //61958825
    SI.KindCode   := CR.KindCode; //13
    SI.SaleAmt    := CR.ChequeAmt; //100000
    SI.BankCode   := CR.BankCode; //84
    SI.BranchCode := CR.BranchCode; //2394
    SI.AccountNo  := CR.AccountCode + CR.AccountNo;
    SI.RegDate    := CR.RegDate;
    RI := VanModule.CallCheck(SI);
    Result := RI.Result;
    if not Result then
      raise Exception.Create(RI.Msg);
  except
    on E: Exception do
      AResMsg := E.Message;
  end;
end;

function TBPDM.UpdateReceipt(const AReceiptNo: string; var AResMsg: string): Boolean;
var
  LSaleAmt, LDCAmt, LUsePoint, LKeepAmt, LChargeAmt, LReceiveAmt, LChangeAmt: Integer;
begin
  Result := False;
  AResMsg := '';
  LSaleAmt := 0;
  LDCAmt := 0;
  LChargeAmt := 0;
  LKeepAmt := 0;
  LReceiveAmt := 0;
  LChangeAmt := 0;

  with TABSQuery.Create(nil) do
  try
    DatabaseName := LocalDB.DatabaseName;
    try
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  SUM(prod_amt * order_qty) AS sale_amt');
      SQL.Add('  , SUM(dc_amt) AS dc_amt');
      SQL.Add('  , SUM(use_point) AS use_point');
      SQL.Add('  , SUM(keep_amt) AS keep_amt');
      SQL.Add('FROM TBSaleItem');
      SQL.Add(Format('WHERE receipt_no = %s', [AReceiptNo.QuotedString]));
      SQL.Add('GROUP BY receipt_no;');
      Open;
      if (RecordCount > 0) then
      begin
        LSaleAmt := FieldByName('sale_amt').AsInteger;
        LDCAmt := FieldByName('dc_amt').AsInteger;
        LUsePoint := FieldByName('use_point').AsInteger;
        LChargeAmt := (LSaleAmt - (LDCAmt + LUsePoint));
        LChangeAmt := IfThen(LReceiveAmt = 0, 0, (LReceiveAmt - LChargeAmt));
        LKeepAmt := FieldByName('keep_amt').AsInteger;
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  SUM(approve_amt) AS receive_amt');
      SQL.Add('FROM TBPayment');
      SQL.Add(Format('WHERE receipt_no = %s', [AReceiptNo.QuotedString]));
      SQL.Add('AND approval_yn = True');
      SQL.Add('GROUP BY receipt_no;');
      Open;
      if (RecordCount > 0) then
        LReceiveAmt := FieldByName('receive_amt').AsInteger;

      Close;
      SQL.Clear;
      SQL.Add('UPDATE TBReceipt');
      SQL.Add(Format('SET sale_amt = %d', [LSaleAmt]));
      SQL.Add(Format('  , receive_amt = %d', [LReceiveAmt]));
      SQL.Add(Format('  , charge_amt = charge_amt', [LChargeAmt]));
      SQL.Add(Format('  , dc_amt = %d', [LDCAmt]));
      SQL.Add(Format('  , use_point = %d', [LUsePoint]));
      SQL.Add(Format('  , vat = %d', [(LChargeAmt - Floor(LChargeAmt / 1.1))]));
      SQL.Add(Format('  , change_amt = %d', [LChangeAmt]));
      SQL.Add(Format('  , keep_amt = %d', [LKeepAmt]));
      SQL.Add(Format('WHERE receipt_no = %s;', [AReceiptNo.QuotedString]));
      ExecSQL;

      if not RefreshReceipt(AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    finally
      Close;
      Free;
    end;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('UpdateReceipt(%s).Exception = %s', [AReceiptNo, E.Message]));
    end;
  end;
end;

function TBPDM.UpdateSaleItem(var AReceiptNo: string; const APR: TProdItemRec; var AResMsg: string): Boolean;
var
  LFields: TArray<TFieldInfoRec>;
  LTableName, LSQL, LAssignNo, LBowlerId, LProdDiv, LProdDetailDiv, LProdCode, LProdName, LMemberNo, LMemberName, LLockerName, LStartDate, LUpdateTime: string;
  LAssignLaneNo, LPurchaseMonth: ShortInt;
  LOrderQty, LProdAmt, LDCAmt, LMembershipSeq, LKeepAmt, LLockerNo: Integer;
  LExist: Boolean;
begin
  Result := False;
  AResMsg := '';
  LTableName := 'TBSaleItem';
  LUpdateTime := Global.DateTime.FormattedCurrentDateTime;
  LExist := False;
  try
    with APR do
    begin
      LAssignLaneNo := AssignLaneNo;
      LAssignNo := AssignNo;
      LBowlerId := BowlerId;
      LProdDiv := ProdDiv;
      LProdDetailDiv := ProdDetailDiv;
      LProdCode := ProdCode;
      LProdName := ProdName;
      LOrderQty := OrderQty;
      LProdAmt := ProdAmt;
      LDCAmt := DCAmt;
      LKeepAmt := KeepAmt;
      LMemberNo := MemberNo;
      LMemberName := MemberName;
      LLockerNo := LockerNo;
      LLockerName := LockerName;
      LPurchaseMonth := PurchaseMonth;
      LStartDate := FormattedDateString(UseStartDate);
    end;

    with QRSaleItem do
    try
      if AReceiptNo.IsEmpty or
         (GetABSRecordCount(Format('SELECT receipt_no FROM TBReceipt WHERE receipt_no = %s;', [AReceiptNo.QuotedString]), AResMsg) = 0) then
        if not MakeNewReceipt(LAssignLaneNo, AReceiptNo, AResMsg) then
          raise Exception.Create(AResMsg);
      if not Active then
        if not RefreshSaleItem(AReceiptNo, AResMsg) then
          raise Exception.Create(AResMsg);

      DisableControls;
      //볼러별 게임 상품과 대여 상품은 볼러별 개별 저장
      if (LProdDiv = CO_PROD_GAME) or
         (LProdDiv = CO_PROD_RENT) then
      begin
        LSQL := Format('SELECT prod_cd FROM %s WHERE receipt_no = %s AND assign_lane_no = %d AND bowler_id = %s AND prod_cd = %s;',
                  [LTableName, AReceiptNo.QuotedString, LAssignLaneNo, LBowlerId.QuotedString, LProdCode.QuotedString]);
        LExist := (GetABSRecordCount(LSQL, AResMsg, False) > 0);
        if LExist then
          LSQL := Format('UPDATE %s SET order_qty = %d, user_id = %s, update_dttm = %s WHERE receipt_no = %s AND assign_lane_no = %d AND bowler_id = %s AND prod_cd = %s;',
                    [LTableName, LOrderQty, Global.UserInfo.UserId.QuotedString, LUpdateTime.QuotedString, AReceiptNo.QuotedString, LAssignLaneNo, LBowlerId.QuotedString, LProdCode.QuotedString]);
      end
      else
      begin
        //라커 상품을 제외한 그 외 상품은 합산 저장
        if (LProdDiv <> CO_PROD_DETAIL_LOCKER) then
        begin
          LSQL := Format('SELECT prod_cd FROM %s WHERE receipt_no = %s AND assign_lane_no = %d AND prod_cd = %s;',
                    [LTableName, AReceiptNo.QuotedString, LAssignLaneNo, LProdCode.QuotedString]);
          LExist := (GetABSRecordCount(LSQL, AResMsg, False) > 0);
          if LExist then
            LSQL := Format('UPDATE %s SET order_qty = (order_qty + %d), user_id = %s, update_dttm = %s WHERE receipt_no = %s AND assign_lane_no = %d AND prod_cd = %s;',
                      [LTableName, LOrderQty, Global.UserInfo.UserId.QuotedString, LUpdateTime.QuotedString, AReceiptNo.QuotedString, LAssignLaneNo, LProdCode.QuotedString]);
        end;
      end;
      if not LExist then
      begin
        SetLength(LFields, 0);
        AddFieldInfo(LFields, 'receipt_no', varString, AReceiptNo);
        AddFieldInfo(LFields, 'assign_lane_no', varInteger, LAssignLaneNo);
        AddFieldInfo(LFields, 'assign_no', varString, LAssignNo);
        AddFieldInfo(LFields, 'bowler_id', varString, LBowlerId);
        AddFieldInfo(LFields, 'prod_div', varString, LProdDiv);
        AddFieldInfo(LFields, 'prod_detail_div', varString, LProdDetailDiv);
        AddFieldInfo(LFields, 'prod_cd', varString, LProdCode);
        AddFieldInfo(LFields, 'prod_nm', varString, LProdName);
        AddFieldInfo(LFields, 'prod_amt', varInteger, LProdAmt);
        AddFieldInfo(LFields, 'order_qty', varInteger, LOrderQty);
        AddFieldInfo(LFields, 'dc_amt', varInteger, LDCAmt);
        AddFieldInfo(LFields, 'service_yn', varBoolean, False);
        AddFieldInfo(LFields, 'keep_amt', varInteger, LKeepAmt);
        AddFieldInfo(LFields, 'member_no', varString, LMemberNo);
        AddFieldInfo(LFields, 'member_nm', varString, LMemberName);
        AddFieldInfo(LFields, 'locker_no', varInteger, LLockerNo);
        AddFieldInfo(LFields, 'locker_nm', varString, LLockerName);
        AddFieldInfo(LFields, 'purchase_month', varInteger, LPurchaseMonth);
        AddFieldInfo(LFields, 'start_dt', varString, LStartDate);
        AddFieldInfo(LFields, 'user_id', varString, Global.UserInfo.UserId);
        AddFieldInfo(LFields, 'update_dttm', varString, Global.DateTime.FormattedCurrentDateTime);
        if not MakeInsertSQL(LTableName, LFields, LSQL) then
          raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
      end;
      if not ExecuteABSQuery(LSQL, AResMsg) then
        raise Exception.Create(AResMsg);
      if not UpdateReceipt(AReceiptNo, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    finally
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('UpdateSaleItem(%s).Exception = %s', [AReceiptNo, E.Message]));
    end;
  end;
end;

function TBPDM.UpdatePayment(const AAssignLaneNo: ShortInt; const AIsSaleMode, ADeleteExists: Boolean; const APR: TPaymentItemRec; var AResMsg: string): Boolean;
var
  LTableName, LSQL, LReceiptNo: string;
  LFields: TArray<TFieldInfoRec>;
begin
  Result := False;
  AResMsg := '';
  try
    if AIsSaleMode then
    begin
      LReceiptNo := QRReceipt.FieldByName('receipt_no').AsString;
      LTableName := 'TBPayment';
    end
    else
    begin
      LReceiptNo := QRReceiptList.FieldByName('receipt_no').AsString;
      LTableName := 'MTPaymentList';
    end;

    SetLength(LFields, 0);
    AddFieldInfo(LFields, 'receipt_no', varString, LReceiptNo);
    AddFieldInfo(LFields, 'assign_lane_no', varInteger, AAssignLaneNo);
    AddFieldInfo(LFields, 'pay_method', varInteger, APR.PayMethod);
    AddFieldInfo(LFields, 'approval_yn', varBoolean, APR.IsApproval);
    AddFieldInfo(LFields, 'manual_input_yn', varBoolean, APR.IsManualInput);
    AddFieldInfo(LFields, 'van_cd', varString, APR.VanCode);
    AddFieldInfo(LFields, 'tid', varString, APR.TID);
    AddFieldInfo(LFields, 'approve_no', varString, APR.ApproveNo);
    AddFieldInfo(LFields, 'org_approve_no', varString, APR.OrgApproveNo);
    AddFieldInfo(LFields, 'org_approve_dt', varString, APR.OrgApproveDate);
    AddFieldInfo(LFields, 'approve_amt', varInteger, APR.ApproveAmt);
    AddFieldInfo(LFields, 'vat', varInteger, APR.VAT);
    AddFieldInfo(LFields, 'inst_month', varInteger, APR.InstallMonth);
    AddFieldInfo(LFields, 'cash_entity_div', varInteger, APR.CashEntity);
    AddFieldInfo(LFields, 'card_no', varString, APR.CardNo);
    AddFieldInfo(LFields, 'trade_no', varString, APR.TradeNo);
    AddFieldInfo(LFields, 'trade_dt', varString, APR.TradeDate);
    AddFieldInfo(LFields, 'issuer_cd', varString, APR.IssuerCode);
    AddFieldInfo(LFields, 'issuer_nm', varString, APR.ISsuerName);
    AddFieldInfo(LFields, 'buyer_div', varString, APR.BuyerDiv);
    AddFieldInfo(LFields, 'buyer_cd', varString, APR.BuyerCode);
    AddFieldInfo(LFields, 'buyer_nm', varString, APR.BuyerName);
    AddFieldInfo(LFields, 'payment_memo', varString, APR.PaymentMemo);
    AddFieldInfo(LFields, 'user_id', varString, Global.UserInfo.UserId);
    AddFieldInfo(LFields, 'update_dttm', varString, Global.DateTime.FormattedCurrentDateTime);
    LSQL := '';
    if not MakeInsertSQL(LTableName, LFields, LSQL) then
      raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
    if not ExecuteABSQuery(LSQL, AResMsg) then
      raise Exception.Create(AResMsg);
    if AIsSaleMode and
       not UpdateReceipt(LReceiptNo, AResMsg) then
      raise Exception.Create(AResMsg);
    Result := True;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('UpdatePayment.Exception = %s', [E.Message]));
    end;
  end;
end;

function TBPDM.UpdateCancelPaymentList(APR: TPaymentItemRec; const ANewApproveNo: string; var AResMsg: string): Boolean;
var
  LSQL: string;
begin
  Result := False;
  LSQL := Format('UPDATE MTPaymentList SET approval_yn = False, org_approve_no = approve_no, approve_no = %s, org_approve_dt = %s',
            [ANewApproveNo.QuotedString, Global.DateTime.CurrentDate.QuotedString]) + _CRLF +
          Format('WHERE receipt_no = %s AND pay_method = %d AND card_no = %s AND approve_no = %s;',
            [APR.ReceiptNo.QuotedString, APR.PayMethod, APR.CardNo.QuotedString, APR.OrgApproveNo.QuotedString]);
  try
    if not ExecuteABSQuery(LSQL, AResMsg, True) then
      raise Exception.Create(AResMsg);
    Result := True;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('UpdateCancelPaymentList.Exception = %s', [E.Message]));
    end;
  end;
end;

function TBPDM.DoPaymentPAYCO(const AIsApproval, AIsSaleMode: Boolean; var AResMsg: string): Boolean;
var
  SDS, PDS: TDataSet;
  PR: TPaymentItemRec;
  SI: TPaycoNewSendInfo;
  RI: TPaycoNewRecvInfo;
  LReceiptNo, LGoodsName, LGoodsList: string;
  LIndex, LPaycoAmt, LVat: Integer;
begin
  AResMsg := '';
  Result := False;
  if AIsSaleMode then
  begin
    LReceiptNo := QRReceipt.FieldByName('receipt_no').AsString;
    SDS := QRSaleItem;
    PDS := QRPayment;
  end else
  begin
    LReceiptNo := QRReceiptlist.FieldByName('receipt_no').AsString;
    SDS := QRSaleItemList;
    PDS := QRPaymentList;
  end;

  Global.ReceiptInfo.PaycoReady := True;
  try
    try
      if AIsApproval then
      begin
        LPaycoAmt := Global.ReceiptInfo.UnPaidAmt;
        SI.TerminalID :=  Global.TerminalInfo.VanTID;
      end
      else
      begin
        LPaycoAmt := PDS.FieldByName('approve_amt').AsInteger;
        SI.OrgAgreeNo := PDS.FieldByName('approve_no').AsString;
        SI.OrgAgreeDate := PDS.FieldByName('trade_date').AsString;
        SI.TerminalID := PDS.FieldByName('tid').AsString;
      end;

      LVat := (LPaycoAmt - Trunc(LPaycoAmt / 1.1));
      SI.BizNo := Global.StoreInfo.BizNo;
      SI.SerialNo := Global.TerminalInfo.VanTID;
      SI.VanName := Global.TerminalInfo.VanCode;
      SI.Approval := AIsApproval;
      SI.PayAmt := LPaycoAmt;
      SI.TaxAmt := LVat;
      SI.DutyAmt := (SI.PayAmt - LVat);
      SI.FreeAmt := 0;
      SI.TipAmt := 0;
      SI.PointAmt := 0;
      SI.CouponAmt := 0;
      SI.ServiceType := '';
      SI.ApprovalAmount := (SI.PayAmt - SI.PointAmt - SI.CouponAmt);

      LGoodsName := '';
      LGoodsList := '';
      LIndex := 0;
      with SDS do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          if (LIndex = 0) then
            LGoodsName := '상품' + IntToStr(Succ(LIndex))
          else
            LGoodsList := LGoodsList + _SOH;
          LGoodsList := LGoodsList + '001' + _SOH + '상품' + IntToStr(Succ(LIndex)) + _SOH +
            IntToStr(FieldByName('calc_charge_amt').AsInteger) + _SOH + IntToStr(FieldByName('order_qty').AsInteger);
          LGoodsList := LGoodsList + _SOH + CO_RESULT_YES;

          Inc(LIndex);
          Next;
        end;
      finally
        EnableControls;
      end;
      PaycoModule.GoodsName := LGoodsName;
      PaycoModule.GoodsList := LGoodsList;

      RI := PaycoModule.ExecPayProc(SI);
      if not RI.Result then
        raise Exception.Create(RI.Msg);

      if AIsSaleMode then
      begin
        if AIsApproval then
        begin
          PayLog(LReceiptNo, AIsApproval, False, CO_PAYMENT_PAYCO_CARD, RI.RevCardNo, RI.AgreeNo, LPaycoAmt);
          Global.ReceiptInfo.CardPayAmt := (Global.ReceiptInfo.CardPayAmt + LPaycoAmt);
        end
        else
          Global.ReceiptInfo.CardPayAmt := (Global.ReceiptInfo.CardPayAmt - LPaycoAmt);

        PR.Clear;
        PR.IsApproval := AIsApproval;
        PR.IsManualInput := False;
        PR.PayMethod := CO_PAYMENT_PAYCO_CARD;
        PR.VanCode := Global.TerminalInfo.VanCode;
        PR.TID := Global.TerminalInfo.PaycoTID;
        PR.ApproveNo := RI.AgreeNo;
        PR.ApproveAmt := Trunc(SI.PayAmt);
        PR.VAT := LVat;
        PR.CashEntity := 0;
        PR.CardNo := RI.RevCardNo;
        PR.TradeNo := RI.TradeNo;
        PR.TradeDate := Global.DateTime.CurrentDate;
        PR.IssuerCode := RI.ApprovalCompanyCode;
        PR.ISsuerName := RI.ApprovalCompanyName;
        PR.BuyerDiv := '';
        PR.BuyerCode := RI.BuyCompanyCode;
        PR.BuyerName := RI.BuyCompanyName;
        if not UpdatePayment(Global.LaneInfo.SelectedLaneNo, AIsSaleMode, False, PR, AResMsg) then
          raise Exception.Create(AResMsg);
      end;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('DoPaymentPAYCO(%s).Exception = %s', [BoolToStr(AIsApproval, True), E.Message]));
      end;
    end;
  finally
    Global.ReceiptInfo.PaycoReady := False;
  end;
end;

function TBPDM.CleanReceipt(var AResMsg: string): Boolean;
var
  LReceiptNo: string;
  LSCount, LPCount: Integer;
begin
  Result := False;
  with TABSQuery.Create(nil) do
  try
    DatabaseName := LocalDB.DatabaseName;
    try
      SQL.Text := 'SELECT * FROM TBReceipt;';
      Open;
      while not Eof do
      begin
        LReceiptNo := FieldByName('receipt_no').AsString;
        LSCount := GetABSRecordCount(Format('SELECT receipt_no FROM TBSaleItem WHERE receipt_no = %s;', [LReceiptNo.QuotedString]), AResMsg);
        if not AResMsg.IsEmpty then
          raise Exception.Create(AResMsg);
        LPCount := GetABSRecordCount(Format('SELECT receipt_no FROM TBPayment WHERE receipt_no = %s;', [LReceiptNo.QuotedString]), AResMsg);
        if not AResMsg.IsEmpty then
          raise Exception.Create(AResMsg);
        if (LSCount = 0) and
           (LPCount = 0) and
           not ExecuteABSQuery(Format('DELETE FROM TBReceipt WHERE receipt_no = %s;', [LReceiptNo.QuotedString]), AResMsg) then
          raise Exception.Create(AResMsg);
        Next;
      end;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('CleanReceipt.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;

function TBPDM.RefreshReceipt(var AResMsg: string): Boolean;
var
  BM: TBookmark;
begin
  Result := False;
  with QRReceipt do
  try
    BM := GetBookmark;
    DisableControls;
    Close;
    try
      SQL.Clear;
      SQL.Add('SELECT A.*');
      SQL.Add('  , B.assign_index');
      SQL.Add('  , B.assign_index_nm');
      SQL.Add('FROM TBReceipt A');
      SQL.Add(Format('LEFT OUTER JOIN (SELECT receipt_no, assign_index, assign_index_nm FROM MEMORY MTAssignList WHERE assign_lane_no = %d GROUP BY receipt_no, assign_index, assign_index_nm) B',
        [Global.LaneInfo.SelectedLaneNo]));
      SQL.Add('ON (');
      SQL.Add('  A.receipt_no = B.receipt_no');
      SQL.Add(')');
      SQL.Add(Format('WHERE A.assign_lane_no = %d', [Global.LaneInfo.SelectedLaneNo]));
      SQL.Add('ORDER BY A.receipt_no;');
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
{$IFDEF DEBUG}
      UpdateLog(Format('RefreshReceipt.RecordCount = %d', [RecordCount]));
{$ENDIF}
      Result := True;
    finally
      EnableControls;
      if Assigned(BM) then
        FreeBookmark(BM);
{$IFDEF DEBUG}
      SQL.SaveToFile(Global.DirInfo.LogDir + 'RefreshReceipt.sql');
{$ENDIF}
    end;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('RefreshReceipt(%d).Exception = %s', [Global.LaneInfo.SelectedLaneNo, E.Message]));
    end;
  end;
end;

function TBPDM.RefreshSaleItem(const AReceiptNo: string; var AResMsg: string): Boolean;
var
  BM: TBookmark;
begin
  Result := False;
  with QRSaleItem do
  try
    BM := GetBookmark;
    DisableControls;
    Close;
    try
      SQL.Clear;
      SQL.Add('SELECT A.*');
      SQL.ADD('  , B.lane_no');
      SQL.Add('  , C.assign_seq');
      SQL.Add('  , C.assign_index');
      SQL.Add('  , C.assign_index_nm');
      SQL.ADD('  , (COALESCE(B.lane_no, A.assign_lane_no)) AS current_lane_no');
      SQL.ADD('  , (CASE WHEN COALESCE(B.lane_no, A.assign_lane_no) = 0 THEN ''일반'' ELSE COALESCE(B.lane_no, A.assign_lane_no) END) AS calc_current_lane_no');
      SQL.Add('FROM TBSaleItem A');
      SQL.Add('LEFT OUTER JOIN (SELECT assign_lane_no, lane_no FROM MEMORY MTGameList GROUP BY assign_lane_no, lane_no) B');
      SQL.Add('ON (');
      SQL.Add('  A.assign_lane_no = B.assign_lane_no');
      SQL.Add(')');
      SQL.Add('LEFT OUTER JOIN MEMORY MTAssignList C');
      SQL.Add('ON (');
      SQL.Add('  A.assign_no = C.assign_no');
      SQL.Add('  AND A.bowler_id = C.bowler_id');
      SQL.Add(')');
      SQL.Add(Format('WHERE A.receipt_no = %s', [AReceiptNo.QuotedString]));
      SQL.Add('AND A.payment_yn = False'); //결제 처리가 완료된 주문은 표시하지 않음
      SQL.Add('ORDER BY B.lane_no, C.assign_index, A.assign_lane_no, A.prod_div, A.prod_nm;');
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
{$IFDEF DEBUG}
      UpdateLog(Format('RefreshSaleItem.RecordCount = %d', [RecordCount]));
{$ENDIF}
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('RefreshSaleItem(ReceiptNo: %s).Exception = %s', [AReceiptNo, E.Message]));
      end;
    end;
  finally
    EnableControls;
    if Assigned(BM) then
      FreeBookmark(BM);
{$IFDEF DEBUG}
    SQL.SaveToFile(Global.DirInfo.LogDir + 'RefreshSaleItem.sql');
{$ENDIF}
  end;
end;

function TBPDM.RefreshPayment(const AReceiptNo: string; var AResMsg: string): Boolean;
var
  BM: TBookmark;
begin
  Result := False;
  with QRPayment do
  try
    BM := GetBookmark;
    DisableControls;
    Close;
    try
      (*
      //결제 내역은 assign_lane_no를 사용하여 조회
      if (Global.LaneInfo.SelectedLaneNo = 0) or
         (Global.LaneInfo.SelectedLanes.Count = 0) then
        LLaneList := '0'
      else
        LLaneList := Global.LaneInfo.AssignLaneNoList; //Delimited Text
      *)
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  A.*');
      SQL.Add('  , (CASE A.pay_method WHEN 1 THEN ''신용카드'' WHEN 2 THEN ''현금'' WHEN 3 THEN ''PAYCO(카드)'' ELSE CAST(A.pay_method AS char(1)) END) AS pay_method_nm');
      SQL.Add('FROM TBPayment A');
      SQL.Add(Format('WHERE A.receipt_no = %s', [AReceiptNo.QuotedString]));
      SQL.Add('ORDER BY A.pay_method, A.seq;');
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
{$IFDEF DEBUG}
      UpdateLog(Format('RefreshPayment.RecordCount = %d', [RecordCount]));
{$ENDIF}
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('RefreshPayment(ReceiptNo: %s).Exception = %s', [AReceiptNo, E.Message]));
      end;
    end;
  finally
    EnableControls;
    if Assigned(BM) then
      FreeBookmark(BM);
{$IFDEF DEBUG}
    SQL.SaveToFile(Global.DirInfo.LogDir + 'RefreshPayment.sql');
{$ENDIF}
  end;
end;

function TBPDM.RefreshMemberList(var AResMsg: string): Boolean;
begin
  Result := RefreshMemberList('', '', '', '', AResMsg);
end;
function TBPDM.RefreshMemberList(const AFieldName, ASearchValue: string; var AResMsg: string): Boolean;
begin
  Result := RefreshMemberList(AFieldName, ASearchValue, '', '', AResMsg);
end;
function TBPDM.RefreshMemberList(const AFieldName, ASearchValue, AFieldName2, ASearchValue2: string; var AResMsg: string): Boolean;
var
  LWhere: string;
begin
  Result := False;
  AResMsg := '';
  with QRMemberList do
  try
    try
      DisableControls;
      Close;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  A.member_no');
      SQL.Add('  , A.member_nm');
      SQL.Add('  , A.club_seq');
      SQL.Add('  , A.club_nm');
      SQL.Add('  , A.member_div');
      SQL.Add('  , (CASE A.member_div WHEN ''01'' THEN ''일반'' WHEN ''02'' THEN ''회원'' WHEN ''03'' THEN ''학생'' WHEN ''04'' THEN ''클럽'' ELSE A.member_div END) AS member_div_nm');
      SQL.Add('  , A.member_group_code');
      SQL.Add('  , C.code_nm AS member_group_nm');
      SQL.Add('  , A.sex_div');
      SQL.Add('  , (CASE A.sex_div WHEN 1 THEN ''남'' WHEN 2 THEN ''여'' ELSE '''' END) AS sex_div_nm');
      SQL.Add('  , A.birthday');
      SQL.Add('  , A.tel_no');
      SQL.Add('  , A.email');
      SQL.Add('  , A.car_no');
      SQL.Add('  , A.zipno');
      SQL.Add('  , A.addr');
      SQL.Add('  , A.addr2');
      SQL.Add('  , A.member_memo');
      SQL.Add('  , A.save_point');
      SQL.Add('  , A.ad_agree_yn');
      SQL.Add('  , A.qrcd');
      SQL.Add('  , A.fp_hash');
      SQL.Add('FROM MEMORY MTMemberList A');
      SQL.Add('LEFT OUTER JOIN MEMORY MTCodeList C');
      SQL.Add('ON (');
      SQL.Add(Format('  C.group_cd = %s', [QuotedStr('member_group_code')]));
      SQL.Add('  AND A.member_group_code = C.code');
      SQL.Add(')');
      LWhere := '';
      if not ASearchValue.IsEmpty then
        LWhere := Format('WHERE A.%s LIKE %s', [AFieldName, QuotedStr('%' + ASearchValue + '%')]);
      if not ASearchValue2.IsEmpty then
        if not LWhere.IsEmpty then
          LWhere := LWhere + Format('OR A.%s LIKE %s', [AFieldName2, QuotedStr('%' + ASearchValue2 + '%')])
        else
          LWhere := Format('WHERE A.%s LIKE %s', [AFieldName2, QuotedStr('%' + ASearchValue2 + '%')]);
      if not LWhere.IsEmpty then
        SQL.Add(LWhere);
      SQL.Add('ORDER BY A.member_nm;');
      Prepared := True;
      Open;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('RefreshMemberList(%s, %s).Exception = %s', [AFieldName, ASearchValue, E.Message]));
      end;
    end;
  finally
    EnableControls;
  end;
end;

function TBPDM.FindMemberInfo(const AMemberNo: string): Boolean;
begin
  Result := False;
  Global.MemberInfo.Clear;
  if (not AMemberNo.IsEmpty) and
     (not QRMemberList.Locate('member_no', AMemberNo, [])) then
    Exit;

  with Global.MemberInfo, QRMemberList do
  begin
    MemberNo := AMemberNo;
    MemberName := FieldByName('member_nm').AsString;
    ClubSeq := FieldByName('club_seq').AsInteger;
    ClubName := FieldByName('club_nm').AsString;
    MemberDiv := FieldByName('member_div').AsString;
    MemberDivName := FieldByName('member_div_nm').AsString;
    MemberGroupCode := FieldByName('member_group_code').AsString;
    MemberGroupName := FieldByName('member_group_nm').AsString;
    SexDiv := FieldByName('sex_div').AsInteger;
    SexDivName := FieldByName('sex_div_nm').AsString;
    Birthday := FieldByName('birthday').AsString;
    TelNo := FieldByName('tel_no').AsString;
    CarNo := FieldByName('car_no').AsString;
    Email := FieldByName('email').AsString;
    ZipNo := FieldByName('zipno').AsString;
    Addr := FieldByName('addr').AsString;
    Addr2 := FieldByName('addr2').AsString;
    SavePoint := FieldByName('save_point').AsInteger;
    AdAgree := FieldByName('ad_agree_yn').AsBoolean;
    MemberMemo := FieldByName('member_memo').AsString;
    QRCode := FieldByName('qrcd').AsString;
    FPHash := FieldByName('fp_hash').AsString;
    Selected := not MemberNo.IsEmpty;
  end;
  Result := True;
end;

function TBPDM.GetWeatherInfo: Boolean;
var
  LResMsg: string;
begin
  Result := GetWeatherInfo(LResMsg);
end;
function TBPDM.GetWeatherInfo(var AResMsg: string): Boolean;
  function GetWeatherIconIndex(const AWeatherId: Integer; const ADaytime: Boolean; var ACondition: string): Integer;
  begin
    Result := 0;
    ACondition := '확인불가';
    case AWeatherId of
      200..232:
      begin
        Result := 7; //11d
        ACondition := '뇌우';
      end;
      300..321:
      begin
        Result := 5; //9d
        ACondition := '약한 비';
      end;
      500..504:
      begin
        Result := 6; //10d
        ACondition := '비';
      end;
      511:
      begin
        Result := 5; //9d
        ACondition := '진눈깨비';
      end;
      520..531:
      begin
        Result := 5; //9d
        ACondition := '소나기';
      end;
      600..622:
      begin
        Result := 8; //13d
        ACondition := '눈';
      end;
      701..721, 741:
      begin
        Result := 9; //50d
        ACondition := '안개';
      end;
      731, 751, 761:
      begin
        Result := 9; //50d
        ACondition := '안개';
      end;
      762:
      begin
        Result := 9; //50d
        ACondition := '화산재';
      end;
      771:
      begin
        Result := 10; //51d
        ACondition := '돌풍';
      end;
      781:
      begin
        Result := 10; //51d
        ACondition := '폭풍';
      end;
      800:
      begin
        Result := 1; //01d
        ACondition := '맑음';
      end;
      801:
      begin
        Result := 2; //02d
        ACondition := '대체로 맑음';
      end;
      802:
      begin
        Result := 3; //03d
        ACondition := '대체로 흐림';
      end;
      803..804:
      begin
        Result := 4; //04d
        ACondition := '흐림';
      end;
    end;
    Result := (Result * 2) + IfThen(ADaytime, 0, 1);
  end;
var
  HC: TIdHTTP;
  JO, RO: HCkJsonObject;
  JA, RA: HCkJsonArray;
  RS: TStringStream;
  RBS: RawByteString;
  LUrl, LResCode, LResMsg, LCondition, LTemper, LPrecipit, LHumidity, LWindSpeed: string;
  LTableName: string;
  LCount, LWeatherId, LIconIdx: Integer;
  LDateTime: TDateTime;
  LUnixTime: Int64;
  LIsDayTime: Boolean;
begin
  Result := False;
  AResMsg := '';
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  RA := nil;
  try
    if not Global.WeatherInfo.Enabled then
      raise Exception.Create('날씨 정보를 사용하기 위한 설정이 올바르지 않습니다.');

    try
      HC.Request.CustomHeaders.Clear;
      HC.IOHandler := SSL;
      HC.HandleRedirects:=False;
      HC.ConnectTimeout := Global.PartnerCenter.Timeout;
      HC.ReadTimeout := Global.PartnerCenter.Timeout;
      HC.Request.UserAgent := 'Mozilla/5.0';
      HC.Request.Method := 'GET';
      (*
      https://api.openweathermap.org/data/2.5/onecall?lat=37.48&lon=126.89&exclude=minutely,hourly&lang=kr&units=metric&appid=2e89859998241a328872d857ec55221e
      Temper: string; //온도
      Precipit: string; //강수확률
      Humidity: string; //습도
      WindSpeed: string; //풍속
      WeatherId: Integer; //아이콘
      *)
      LUrl := Format('%s/data/2.5/onecall?lat=%s&lon=%s&exclude=minutely&lang=kr&units=metric&appid=%s',
                [ExcludeTrailingPathDelimiter(Global.WeatherInfo.Host), Global.WeatherInfo.Latitude, Global.WeatherInfo.Longitude, Global.WeatherInfo.ApiKey]);
      HC.Get(LUrl, RS);
      RS.SaveToFile(Global.DirInfo.LogDir + 'GetWeatherInfo.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      if not CkJsonObject_Load(JO, PWideChar(String(RBS))) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));
      LResCode := CkJsonObject__stringOf(JO, 'cod');
      LResMsg := CkJsonObject__stringOf(JO, 'message');
      if (not LResCode.IsEmpty) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [LResCode, LResMsg]));

      Global.WeatherInfo.WeatherId := -1; //현재(초기화)
      Global.WeatherInfo.Temper := '';
      Global.WeatherInfo.Humidity := '';
      Global.WeatherInfo.WindSpeed := '';
      Global.WeatherInfo.Precipit := '';
      (*
      //현재날씨
      RO := JO.GetValue('current') as TJSONObject;
      Global.WeatherInfo.Temper := IntToStr(Round(StrToFloatDef(RO.GetValue('temp').Value, 0))); //(현재)기온
      Global.WeatherInfo.Humidity := RO.GetValue('humidity').Value; //(현재)습도
      Global.WeatherInfo.WindSpeed := IntToStr(Round(StrToFloatDef(RO.GetValue('wind_speed').Value, 0))); //(현재)풍속
      Global.WeatherInfo.Precipit := ''; //(현재)강수확률

      JV := RO.Get('weather').JsonValue;
      LCount := (JV as TJSONArray).Count;
      for var I: ShortInt := 0 to Pred(nCount) do
      begin
        Global.WeatherInfo.WeatherId := StrToIntDef((JV as TJSONArray).Items[I].P['id'].Value, 0); //날씨상태
        Global.WeatherInfo.DayTime := (Pos('d', (JV as TJSONArray).Items[I].P['icon'].Value) <> 0); //낮 시간 여부
        Global.WeatherInfo.IconIndex := GetWeatherIconIndex(Global.WeatherInfo.WeatherId, Global.WeatherInfo.DayTime, sCondition);
        Global.WeatherInfo.Condition := sCondition;
        Break;
      end;
      *)

      //금일예보
      LTableName := 'MTWeatherToday';
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSTable.Create(nil) do
      try
        InMemory := True;
        TableName := LTableName;
        Open;

        JA := CkJsonObject_ArrayOf(JO, 'hourly');
        LCount := CkJsonArray_getSize(JA);
        for var I: ShortInt := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          LUnixTime := StrToIntDef(CkJsonObject__stringOf(RO, 'dt'), 0);
          LDateTime := UnixToDateTime(LUnixTime);
          if (LDateTime < Now) then
            Continue;

          LTemper := IntToStr(Round(StrToFloatDef(CkJsonObject__stringOf(RO, 'temp'), 0)));
          LHumidity := CkJsonObject__stringOf(RO, 'humidity');
          LWindSpeed := IntToStr(Round(StrToFloatDef(CkJsonObject__stringOf(RO, 'wind_speed'), 0)));
          LPrecipit := IntToStr(Round(StrToFloatDef(CkJsonObject__stringOf(RO, 'pop'), 0) * 100));
          RA := CkJsonObject_ArrayOf(RO, 'weather');
          if (CkJsonArray_getSize(RA) > 0) then
          begin
            RO := CkJsonArray_ObjectAt(RA, 0);
            LWeatherId := StrToIntDef(CkJsonObject__stringOf(RO, 'id'), 0);
            LIsDayTime := (Pos('d', CkJsonObject__stringOf(RO, 'icon')) <> 0);
            LIconIdx := GetWeatherIconIndex(LWeatherId, LIsDayTime, LCondition);
            //현재날씨
            if (Global.WeatherInfo.WeatherId = -1) then
            begin
              Global.WeatherInfo.WeatherId := LWeatherId; //날씨상태
              Global.WeatherInfo.DayTime := LIsDayTime; //낮시간 여부
              Global.WeatherInfo.IconIndex := GetWeatherIconIndex(LWeatherId, True, LCondition); //날씨 아이콘 인덱스
              Global.WeatherInfo.Condition := LCondition; //상태
              Global.WeatherInfo.Temper := LTemper; //기온
              Global.WeatherInfo.Humidity := LHumidity; //습도
              Global.WeatherInfo.WindSpeed := LWindSpeed; //풍속
              Global.WeatherInfo.Precipit := LPrecipit; //강수확률
              UpdateLog(Format('GetWeatherInfo.Current = WeatherId: %d, IconIndex: %d, Condition: %s', [LWeatherId, Global.WeatherInfo.IconIndex, LCondition]));
            end;

            Append;
            FieldValues['datetime'] := LDateTime;
            FieldValues['weather_id'] := LWeatherId;
            FieldValues['icon_idx'] := LIconIdx;
            FieldValues['temper'] := LTemper;
            FieldValues['precipit'] := LPrecipit;
            FieldValues['humidity'] := LHumidity;
            FieldValues['wind_speed'] := LWindSpeed;
            FieldValues['condition'] := LCondition;
            TBlobField(FieldByName('icon')).Assign(imcWeather.GetBitmap(LIconIdx, 44, 44));
            Post;
          end;
        end;
      finally
        Close;
        Free;
      end;

      //주간예보
      LTableName := 'MTWeatherWeek';
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSTable.Create(nil) do
      try
        InMemory := True;
        TableName := LTableName;
        Open;

        JA := CkJsonObject_ArrayOf(JO, 'daily');
        LCount := CkJsonArray_getSize(JA);
        for var I: ShortInt := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          LUnixTime := StrToIntDef(CkJsonObject__stringOf(RO, 'dt'), 0);
          LDateTime := UnixToDateTime(LUnixTime);
          if (LDateTime < Now) then
            Continue;

          LHumidity := CkJsonObject__stringOf(RO, 'humidity');
          LWindSpeed := IntToStr(Round(StrToFloatDef(CkJsonObject__stringOf(RO, 'wind_speed'), 0)));
          LPrecipit := IntToStr(Round(StrToFloatDef(CkJsonObject__stringOf(RO, 'pop'), 0) * 100));
          RA := CkJsonObject_ArrayOf(RO, 'weather');
          if (CkJsonArray_getSize(RA) > 0) then
          begin
            RO := CkJsonArray_ObjectAt(RA, 0);
            LWeatherId := StrToIntDef(CkJsonObject__stringOf(RO, 'id'), 0);
            LIconIdx := GetWeatherIconIndex(LWeatherId, True, LCondition);
            LTemper := IntToStr(Round(StrToFloatDef(CkJsonObject__stringOf(RO, 'temp.min'), 0))) + ' / ' + IntToStr(Round(StrToFloatDef(CkJsonObject__stringOf(RO, 'temp.max'), 0)));
            Append;
            FieldValues['datetime'] := LDateTime;
            FieldValues['weather_id'] := LWeatherId;
            FieldValues['icon_idx'] := LIconIdx;
            FieldValues['temper'] := LTemper;
            FieldValues['precipit'] := LPrecipit;
            FieldValues['humidity'] := LHumidity;
            FieldValues['wind_speed'] := LWindSpeed;
            FieldValues['condition'] := LCondition;
            TBlobField(FieldByName('icon')).Assign(imcWeather.GetBitmap(LIconIdx, 44, 44));
            Post;
          end;
        end;
      finally
        First;
        EnableControls;
      end;

      Result := True;
      SendToMainForm(CPC_WEATHER);
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('GetWeatherInfo.Exception = %s', [AResMsg]));
      end;
    end;
  finally
    if Assigned(RA) then
      CkJsonArray_Dispose(RA);
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
    FreeAndNil(RS);
    HC.Disconnect;
    FreeAndNil(HC);
  end;
end;

function TBPDM.RefreshLaneStatus(var AResMsg: string): Boolean;
var
  LFields: TArray<TFieldInfoRec>;
  LTableName, LSQL: string;
  LTempLaneNo, LAssignLaneNo, LLaneNo, LIndex, LLaneStatus, LFrameNo: ShortInt;
  LUsedCount, LReservedCount, LBusyCount: Integer;
begin
  if Global.GameStatusWorking then
    Exit(True);
  Global.GameStatusWorking := True;
  Result := False;
  AResMsg := '';
  LTableName := 'MTGameList';
  try
    SPGameStatus.DisableControls;
    try
      SPGameStatus.Close;
      SPGameStatus.Prepared := True;
      SPGameStatus.Open;
      LTempLaneNo := 0;
      LUsedCount := 0;
      LReservedCount := 0;
      LBusyCount := 0;

      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        while not SPGameStatus.Eof do
        begin
          LLaneNo := SPGameStatus.FieldByName('lane_no').AsInteger;
          LAssignLaneNo := SPGameStatus.FieldByName('assign_lane_no').AsInteger;
          if (LLaneNo > 0) and
             (LAssignLaneNo = 0) then
            LAssignLaneNo := LLaneNo;
          LLaneStatus := SPGameStatus.FieldByName('lane_status').AsInteger;
          LFrameNo := SPGameStatus.FieldByName('frame_to').AsInteger;
          LIndex := Global.LaneInfo.LaneIndex(LLaneNo);
          if (LIndex > -1) then
          begin
            Global.LaneInfo.Lanes[LIndex].AssignLaneNo := LAssignLaneNo;
            Global.LaneInfo.Lanes[LIndex].LaneStatus := LLaneStatus;
            if Assigned(Global.LaneInfo.Lanes[LIndex].Container) then
              Global.LaneInfo.Lanes[LIndex].Container.LaneStatus := LLaneStatus;
          end;
          if (LLaneStatus in [CO_LANE_READY]) then
          begin
            SPGameStatus.Next;
            Continue;
          end;
          if (LLaneNo <> LTempLaneNo) then
          begin
            LTempLaneNo := LLaneNo;
            if LLaneStatus in [CO_LANE_HOLD, CO_LANE_BUSY] then
              Inc(LUsedCount);
          end;
          case LLaneStatus of
            CO_LANE_RESERVED:
              Inc(LReservedCount);
            CO_LANE_HOLD,
            CO_LANE_BUSY:
              Inc(LBusyCount);
          end;

          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'lane_no', varInteger, LLaneNo);
          AddFieldInfo(LFields, 'lane_status', varInteger, LLaneStatus);
          AddFieldInfo(LFields, 'assign_lane_no', varInteger, LAssignLaneNo);
          if (LLaneStatus > CO_LANE_READY) then
          begin
            AddFieldInfo(LFields, 'assign_no', varString, SPGameStatus.FieldByName('assign_no').AsString);
            AddFieldInfo(LFields, 'assign_root_div', varString, SPGameStatus.FieldByName('assign_root_div').AsString);
            AddFieldInfo(LFields, 'rally_seq', varInteger, SPGameStatus.FieldByName('competition_seq').AsInteger);
            AddFieldInfo(LFields, 'league_yn', varBoolean, (SPGameStatus.FieldByName('league_yn').AsString = CO_RESULT_YES));
            AddFieldInfo(LFields, 'lane_shift_method', varString, SPGameStatus.FieldByName('move_method').AsString);
            AddFieldInfo(LFields, 'lane_shift_cnt', varInteger, SPGameStatus.FieldByName('lane_move_cnt').AsInteger);
            AddFieldInfo(LFields, 'start_datetime', varString, SPGameStatus.FieldByName('start_datetime').AsString);
            AddFieldInfo(LFields, 'expected_end_datetime', varString, SPGameStatus.FieldByName('expected_end_datetime').AsString);
            AddFieldInfo(LFields, 'bowler_seq', varInteger, SPGameStatus.FieldByName('bowler_seq').AsInteger);
            AddFieldInfo(LFields, 'entry_seq', varInteger, SPGameStatus.FieldByName('participants_seq').AsInteger);
            AddFieldInfo(LFields, 'handy', varInteger, SPGameStatus.FieldByName('handy').AsInteger);
            AddFieldInfo(LFields, 'shoes_rent_yn', varBoolean, (SPGameStatus.FieldByName('shoes_yn').AsString = CO_RESULT_YES));
            AddFieldInfo(LFields, 'bowler_id', varString, SPGameStatus.FieldByName('bowler_id').AsString);
            AddFieldInfo(LFields, 'bowler_nm', varString, SPGameStatus.FieldByName('bowler_nm').AsString);
            AddFieldInfo(LFields, 'member_no', varString, SPGameStatus.FieldByName('member_no').AsString);
            AddFieldInfo(LFields, 'membership_seq', varInteger, SPGameStatus.FieldByName('membership_seq').AsInteger);
            AddFieldInfo(LFields, 'membership_use_cnt', varInteger, SPGameStatus.FieldByName('membership_use_cnt').AsInteger);
            AddFieldInfo(LFields, 'membership_use_min', varInteger, SPGameStatus.FieldByName('membership_use_min').AsInteger);
            AddFieldInfo(LFields, 'prod_cd', varString, SPGameStatus.FieldByName('product_cd').AsString);
            AddFieldInfo(LFields, 'payment_type', varInteger, StrToIntDef(SPGameStatus.FieldByName('payment_type').AsString, CO_PAYTYPE_DEFERRED)); //0:후불
            AddFieldInfo(LFields, 'fee_div', varString, SPGameStatus.FieldByName('fee_div').AsString);
            AddFieldInfo(LFields, 'game_div', varInteger, SPGameStatus.FieldByName('game_div').AsInteger);
            AddFieldInfo(LFields, 'game_cnt', varInteger, SPGameStatus.FieldByName('game_cnt').AsInteger);
            AddFieldInfo(LFields, 'game_min', varInteger, SPGameStatus.FieldByName('game_min').AsInteger);
            AddFieldInfo(LFields, 'game_fin', varInteger, SPGameStatus.FieldByName('game_fin').AsInteger);
            AddFieldInfo(LFields, 'direction', varInteger, StrToIntDef(SPGameStatus.FieldByName('game_status').AsString, CO_LANE_DIR_NOT_USED)); //0:대기
            AddFieldInfo(LFields, 'frame_no', varInteger, LFrameNo);
            AddFieldInfo(LFields, 'pin_fall_result', varString, SPGameStatus.FieldByName('pin_fall_result').AsString);
            AddFieldInfo(LFields, 'total_score', varInteger, SPGameStatus.FieldByName('total_score').AsInteger);
            for var I: ShortInt := 1 to 10 do
            begin
              AddFieldInfo(LFields, Format('frame%d_score', [I]), varInteger, SPGameStatus.FieldByName(Format('frame%d_score', [I])).AsInteger);
              AddFieldInfo(LFields, Format('frame%d_pin', [I]), varString, SPGameStatus.FieldByName(Format('frame%d_pin', [I])).AsString);
            end;
          end;
          if not MakeInsertSQL(True, LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
          SPGameStatus.Next;
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      Global.LaneInfo.ReadyCount := (Global.LaneInfo.LaneCount - LUsedCount);
      Global.LaneInfo.ReservedCount := LReservedCount;
      Global.LaneInfo.BusyCount := LBusyCount;
      if not RefreshABSDataSet(QRGameList, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
        AResMsg := E.Message;
    end;
  finally
    SPGameStatus.EnableControls;
    Global.GameStatusWorking := False;
  end;
end;

function TBPDM.RefreshAssignList(var AResMsg: string): Boolean;
var
  LFields: TArray<TFieldInfoRec>;
  LTableName, LSQL, LAssignNo, LOldAssignNo, LReceiptNo: string;
  LAssignLaneNo, LOldAssignLaneNo, LAssignStatus, LAssignIndex: ShortInt;
begin
  if Global.AssignListWorking then
    Exit(True);
  Global.AssignListWorking := True;
  Result := False;
  AResMsg := '';
  LTableName := 'MTAssignList';
  try
    QRAssignList.DisableControls;
    try
      SPAssignList.Close;
      SPAssignList.Prepared := True;
      SPAssignList.Open;
      LAssignIndex := 0;
      LOldAssignLaneNo := 0;
      LOldAssignNo := '';
      LReceiptNo := '';

      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        while not SPAssignList.Eof do //order by assign_lane_no
        begin
          LAssignLaneNo := SPAssignList.FieldByName('assign_lane_no').AsInteger;
          LAssignNo := SPAssignList.FieldByName('assign_no').AsString;
          LAssignStatus := SPAssignList.FieldByName('assign_status').AsInteger;
          if (LAssignLaneNo <> LOldAssignLaneNo) then
          begin
            LOldAssignLaneNo := LAssignLaneNo;
            LAssignIndex := 0;
          end;
          if (LAssignNo <> LOldAssignNo) then
          begin
            LReceiptNo := '';
            with GetABSDataSet(Format('SELECT receipt_no FROM TBSaleItem WHERE assign_lane_no = %d AND assign_no = %s;', [LAssignLaneNo, LAssignNo.QuotedString])) do
            try
              if (RecordCount > 0) then
                LReceiptNo := FieldByName('receipt_no').AsString;
            finally
              Close;
              Free;
            end;
            LOldAssignNo := LAssignNo;
            if (LAssignStatus = CO_LANE_RESERVED) then
              Inc(LAssignIndex);
          end;

          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'receipt_no', varString, LReceiptNo);
          AddFieldInfo(LFields, 'assign_seq', varInteger, SPAssignList.FieldByName('assign_seq').AsInteger);
          AddFieldInfo(LFields, 'assign_bowler_seq', varInteger, SPAssignList.FieldByName('assign_bowler_seq').AsInteger);
          AddFieldInfo(LFields, 'assign_no', varString, LAssignNo);
          AddFieldInfo(LFields, 'assign_lane_no', varInteger, LAssignLaneNo);
          AddFieldInfo(LFields, 'lane_no', varInteger, SPAssignList.FieldByName('lane_no').AsInteger);
          AddFieldInfo(LFields, 'game_div', varInteger, SPAssignList.FieldByName('game_div').AsInteger);
          AddFieldInfo(LFields, 'rally_seq', varInteger, SPAssignList.FieldByName('competition_seq').AsInteger);
          AddFieldInfo(LFields, 'league_yn', varBoolean, (SPAssignList.FieldByName('league_yn').AsString = CO_RESULT_YES));
          AddFieldInfo(LFields, 'lane_shift_method', varString, SPAssignList.FieldByName('move_method').AsString);
          AddFieldInfo(LFields, 'lane_shift_cnt', varInteger, SPAssignList.FieldByName('lane_move_cnt').AsInteger);
          AddFieldInfo(LFields, 'assign_status', varInteger, LAssignStatus);
          AddFieldInfo(LFields, 'assign_index', varInteger, LAssignIndex);
          AddFieldInfo(LFields, 'assign_index_nm', varString, IfThen(LassignIndex = 0, '진행', '예약 ' + LAssignIndex.ToString));
          AddFieldInfo(LFields, 'assign_root_div', varString, SPAssignList.FieldByName('assign_root_div').AsString);
          AddFieldInfo(LFields, 'reserve_datetime', varString, SPAssignList.FieldByName('reserve_datetime').AsString); //AsDateTime
          AddFieldInfo(LFields, 'expected_end_datetime', varString, SPAssignList.FieldByName('expected_end_datetime').AsString); //AsDateTime
          AddFieldInfo(LFields, 'bowler_seq', varInteger, SPAssignList.FieldByName('bowler_seq').AsInteger);
          AddFieldInfo(LFields, 'entry_seq', varInteger, SPAssignList.FieldByName('participants_seq').AsInteger);
          AddFieldInfo(LFields, 'handy', varInteger, SPAssignList.FieldByName('handy').AsInteger);
          AddFieldInfo(LFields, 'shoes_rent_yn', varBoolean, (SPAssignList.FieldByName('shoes_yn').AsString = CO_RESULT_YES));
          AddFieldInfo(LFields, 'bowler_id', varString, SPAssignList.FieldByName('bowler_id').AsString);
          AddFieldInfo(LFields, 'bowler_nm', varString, SPAssignList.FieldByName('bowler_nm').AsString);
          AddFieldInfo(LFields, 'member_no', varString, SPAssignList.FieldByName('member_no').AsString);
          AddFieldInfo(LFields, 'membership_seq', varInteger, SPAssignList.FieldByName('membership_seq').AsInteger);
          AddFieldInfo(LFields, 'membership_use_cnt', varInteger, SPAssignList.FieldByName('membership_use_cnt').AsInteger);
          AddFieldInfo(LFields, 'membership_use_min', varInteger, SPAssignList.FieldByName('membership_use_min').AsInteger);
          AddFieldInfo(LFields, 'game_start', varInteger, SPAssignList.FieldByName('game_start').AsInteger);
          AddFieldInfo(LFields, 'game_cnt', varInteger, SPAssignList.FieldByName('game_cnt').AsInteger);
          AddFieldInfo(LFields, 'game_min', varInteger, SPAssignList.FieldByName('game_min').AsInteger);
          AddFieldInfo(LFields, 'game_fin', varInteger, SPAssignList.FieldByName('game_fin').AsInteger);
          AddFieldInfo(LFields, 'frame_no', varInteger, SPAssignList.FieldByName('frame_no').AsInteger);
          AddFieldInfo(LFields, 'direction', varInteger, SPAssignList.FieldByName('direction').AsInteger);
          AddFieldInfo(LFields, 'prod_cd', varString, SPAssignList.FieldByName('product_cd').AsString);
          AddFieldInfo(LFields, 'prod_nm', varString, SPAssignList.FieldByName('product_nm').AsString);
          AddFieldInfo(LFields, 'payment_type', varInteger, SPAssignList.FieldByName('payment_type').AsInteger);
          AddFieldInfo(LFields, 'fee_div', varString, SPAssignList.FieldByName('fee_div').AsString);
          AddFieldInfo(LFields, 'use_status', varInteger, SPAssignList.FieldByName('use_status').AsInteger);
          AddFieldInfo(LFields, 'user_id', varString, SPAssignList.FieldByName('user_id').AsString);
          if not MakeInsertSQL(True, LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
          SPAssignList.Next;
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRAssignList, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('RefreshAssignList.Exception = %s', [E.Message]));
      end;
    end;
  finally
    QRAssignList.EnableControls;
    Global.AssignListWorking := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function TBPDM.RequestToGameServer(const AApiName, AReqJson: string; var ARespJson, AResMsg: string): Boolean;
var
  TC: TIdTCPClient;
  SS: TStringStream;
begin
  Result := False;
  ARespJson := '';
  AResMsg := '';
  TC := TIdTCPClient.Create(nil);
  SS := TStringStream.Create(AReqJson);
  try
    try
      SS.SaveToFile(Global.DirInfo.LogDir + Format('%s.Request.json', [AApiName]));
      TC.Host := Global.GameServer.APIHost;
      TC.Port := Global.GameServer.APIPort;
      TC.ConnectTimeout := Global.GameServer.APITimeout;
      TC.ReadTimeout := Global.GameServer.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(AReqJson, IndyTextEncoding_UTF8);
      ARespJson := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      SS.Clear;
      SS.WriteString(ARespJson);
      SS.SaveToFile(Global.DirInfo.LogDir + Format('%s.Response.json', [AApiName]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('RequestToGameServer.Exception = %s', [E.Message]));
      end;
    end;
  finally
    FreeAndNil(SS);
    TC.Disconnect;
    FreeAndNil(TC);
  end;
end;

function TBPDM.LaneControlCommand(const AApiName: string; const ALaneNo: ShortInt; const AItemName, AValue: string; var AResMsg: string): Boolean;
var
  JO: HCkJsonObject;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
    CkJsonObject_UpdateString(JO, 'api', PWideChar(AApiName));
    CkJsonObject_UpdateInt(JO, 'lane_no', ALaneNo);
    if not AItemName.IsEmpty then
      CkJsonObject_UpdateString(JO, PWideChar(AItemName), PWideChar(AValue));
    CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
    LReqJson := CkJsonObject__emit(JO);
    LRespJson := '';
    try
      if not RequestToGameServer(AApiName, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('게임서버 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [AApiName, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.BowlerControlCommand(const AApiName, AAssignNo, ABowlerId, AItemName, AValue: string; var AResMsg: string): Boolean;
var
  JO: HCkJsonObject;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
    CkJsonObject_UpdateString(JO, 'api', PWideChar(AApiName));
    CkJsonObject_UpdateString(JO, 'assign_no', PWideChar(AAssignNo));
    CkJsonObject_UpdateString(JO, 'bowler_id', PWideChar(ABowlerId));
    if not AItemName.IsEmpty then
      CkJsonObject_UpdateString(JO, PWideChar(AItemName), PWideChar(AValue));
    CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
    LReqJson := CkJsonObject__emit(JO);
    LRespJson := '';
    try
      if not RequestToGameServer(AApiName, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('게임서버 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [AApiName, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.InitLane(const ALaneNo: ShortInt; var AResMsg: string): Boolean;
const
  CS_API = 'Z101_initLane';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, '', '', AResMsg);
end;

function TBPDM.SetPinSetter(const ALaneNo: ShortInt; const ASetting: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'Z001_sendPinSetter';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'use_yn', IfThen(ASetting, CO_RESULT_YES, CO_RESULT_NO), AResMsg);
end;

function TBPDM.SetGameMonitor(const ALaneNo: ShortInt; const ASetting: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'Z002_sendMoniter';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'use_yn', IfThen(ASetting, CO_RESULT_YES, CO_RESULT_NO), AResMsg);
end;

function TBPDM.SetGameNext(const ALaneNo: ShortInt; var AResMsg: string): Boolean;
const
  CS_API = 'Z105_chgGameNext';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'use_yn', CO_RESULT_YES, AResMsg);
end;

function TBPDM.SetLeagueMode(const ALaneNo: ShortInt; const ALeagueMode: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'Z113_chgGameLeague';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'use_yn', IfThen(ALeagueMode, CO_RESULT_YES, CO_RESULT_NO), AResMsg);
end;

function TBPDM.SetHoldLane(const ALaneNo: ShortInt; const AHoldMode: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'Z201_chgLaneHold';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'hold_yn', IfThen(AHoldMode, CO_RESULT_YES, CO_RESULT_NO), AResMsg);
end;

function TBPDM.SetMaintenanceLane(const ALaneNo: ShortInt; const ALockMode: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'Z202_chgLaneLock';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'lock_yn', IfThen(ALockMode, CO_RESULT_YES, CO_RESULT_NO), AResMsg);
end;

function TBPDM.SetPinSettingType(const ALaneNo, ASettingType: ShortInt; var AResMsg: string): Boolean;
const
  CS_API = 'Z003_sendPinSetting';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'setting_type', ASettingType.ToString, AResMsg);
end;

function TBPDM.CancelGame(const ALaneNo: ShortInt; const AAssignNo: string; var AResMsg: string): Boolean;
const
  CS_API = 'Z103_delLaneGame';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, 'assign_no', AAssignNo, AResMsg);
end;

function TBPDM.RestoreGame(const ALaneNo: ShortInt; var AResMsg: string): Boolean;
const
  CS_API = 'Z108_chgGameRestore';
begin
  Result := LaneControlCommand(CS_API, ALaneNo, '', '', AResMsg);
end;

function TBPDM.SetBowlerPause(const AAssignNo, ABowlerId: string; const AValue: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'Z004_sendBowlerPause';
begin
  Result := BowlerControlCommand(CS_API, AAssignNo, ABowlerId, 'pause_yn', IfThen(AValue, CO_RESULT_YES, CO_RESULT_NO), AResMsg);
end;

function TBPDM.SetGameScore(const AAssignNo, ABowlerid: string; const AGameScore: string; var AResMsg: string): Boolean;
const
  CS_API = 'Z104_chgScore';
begin
  Result := BowlerControlCommand(CS_API, AAssignNo, ABowlerId, 'game_score', AGameScore, AResMsg);
end;

function TBPDM.SetPaymentType(const AAssignNo, ABowlerId: string; const APaymentType: Integer; var AResMsg: string): Boolean;
const
  CS_API = 'Z117_chgBowlerPay';
begin
  Result := BowlerControlCommand(CS_API, AAssignNo, ABowlerId, 'payment_type', APaymentType.ToString, AResMsg);
end;

function TBPDM.SetBowlerThrowOrder(const AAssignNo, ABowlerId: string; const AOrderSeq: Integer; var AResMsg: string): Boolean;
const
  CS_API = 'Z118_chgBowlerSwitch';
begin
  Result := BowlerControlCommand(CS_API, AAssignNo, ABowlerId, 'order_seq', AOrderSeq.ToString, AResMsg);
end;

function TBPDM.RemoveBowler(const AAssignNo, ABowlerId: string; var AResMsg: string): Boolean;
const
  CS_API = 'Z111_delBowler';
begin
  Result := BowlerControlCommand(CS_API, AAssignNo, ABowlerId, '', '', AResMsg);
end;

function TBPDM.AssignGame(const ARallyMode: Boolean; const AReceiptNo: string; const AAR: TArray<TGameAssignRec>; var AResMsg: string): Boolean;
const
  CS_API = 'Z102_regLaneGame';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  PI: TProdItemRec;
  LReceiptNo, LReqJson, LRespJson, LResCode, LAssignNo: string;
  LCount, LLaneNo: Integer;
  I, J: ShortInt;
begin
  Result := False;
  AResMsg := '';
  LReceiptNo := AReceiptNo;
  JO := CkJsonObject_Create;
  JA := nil;
  try
    CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
    CkJsonObject_UpdateString(JO, 'api', PWideChar(CS_API));
    CkJsonObject_UpdateString(JO, 'assign_root_div', PWideChar(Global.TerminalInfo.TerminalDiv));
    CkJsonObject_UpdateString(JO, 'terminal_id', PWideChar(Global.PartnerCenter.TerminalId));
    CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
    for I := 0 to High(AAR) do
    begin
      CkJsonObject_putI(JO, I);
      CkJsonObject_UpdateInt(JO, 'data[i].lane_no', AAR[I].LaneNo);
      CkJsonObject_UpdateInt(JO, 'data[i].game_div', AAR[I].GameDiv);
      CkJsonObject_UpdateInt(JO, 'data[i].competition_seq', AAR[I].RallySeq);
      CkJsonObject_UpdateString(JO, 'data[i].league_yn', PWideChar(IfThen(AAR[I].LeagueMode, CO_RESULT_YES, CO_RESULT_NO)));
      CkJsonObject_UpdateString(JO, 'data[i].move_method', PWideChar(AAR[I].ShiftMethod));
      CkJsonObject_UpdateInt(JO, 'data[i].lane_move_cnt', AAR[I].ShiftCount);
      CkJsonObject_UpdateInt(JO, 'data[i].train_min', AAR[I].PrepareMin);
      for J := 0 to Pred(Length(AAR[I].Bowlers)) do
      begin
        CkJsonObject_putJ(JO, J);
        CkJsonObject_UpdateString(JO, 'data[i].bowler[j].bowler_id', PWideChar(AAR[I].Bowlers[J].BowlerId));
        CkJsonObject_UpdateString(JO, 'data[i].bowler[j].bowler_nm', PWideChar(AAR[I].Bowlers[J].BowlerName));
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].participants_seq', AAR[I].Bowlers[J].EntrySeq);
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].handy', AAR[I].Bowlers[J].Handy);
        CkJsonObject_UpdateString(JO, 'data[i].bowler[j].member_no', PWideChar(AAR[I].Bowlers[J].MemberNo));
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].membership_seq', AAR[I].Bowlers[J].MembershipSeq);
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].membership_use_cnt', AAR[I].Bowlers[J].MembershipUseCount);
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].membership_use_min', AAR[I].Bowlers[J].MembershipUseMin);
        CkJsonObject_UpdateString(JO, 'data[i].bowler[j].product_cd', PWideChar(AAR[I].Bowlers[J].ProdInfo.ProdCode));
        CkJsonObject_UpdateString(JO, 'data[i].bowler[j].product_nm', PWideChar(AAR[I].Bowlers[J].ProdInfo.ProdName));
        CkJsonObject_UpdateString(JO, 'data[i].bowler[j].fee_div', PWideChar(AAR[I].Bowlers[J].FeeDiv));
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].game_cnt', AAR[I].Bowlers[J].GameCount);
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].game_min', AAR[I].Bowlers[J].GameMin);
        CkJsonObject_UpdateInt(JO, 'data[i].bowler[j].payment_type', AAR[I].Bowlers[J].PaymentType);
        CkJsonObject_UpdateString(JO, 'data[i].bowler[j].shoes_yn', PWideChar(IfThen(AAR[I].Bowlers[J].ShoesRent, CO_RESULT_YES, CO_RESULT_NO)));
      end;
    end;
    LReqJson := CkJsonObject__emit(JO);
    LRespJson := '';

    try
      if not RequestToGameServer(CS_API, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('게임서버 Error #%s, %s', [LResCode, AResMsg]));

      //대회 모드가 아닌 경우에만 매출 내역 갱신
      if not ARallyMode then
      begin
        JA := CkJsonObject_ArrayOf(JO, 'result_data');
        LCount := CkJsonArray_getSize(JA);
        for I := 0 to High(AAR) do
          if (I < LCount) then
          begin
            RO := CkJsonArray_ObjectAt(JA, I);
            for J := 0 to Pred(Length(AAR[I].Bowlers)) do
            begin
              LLaneNo := CkJsonObject_IntOf(RO, 'lane_no');
              LAssignNo := CkJsonObject__stringOf(RO, 'assign_no');
              if (LLaneNo = AAR[I].LaneNo) then
              begin
                if not AAR[I].Bowlers[J].ProdInfo.ProdCode.IsEmpty then
                begin
                  PI.Clear;
                  PI.AssignLaneNo := LLaneNo;
                  PI.AssignNo := LAssignNo;
                  PI.BowlerId := AAR[I].Bowlers[J].BowlerId;
                  PI.ProdDiv := AAR[I].Bowlers[J].ProdInfo.ProdDiv;
                  PI.ProdDetailDiv := AAR[I].Bowlers[J].ProdInfo.ProdDetailDiv;
                  PI.ProdCode := AAR[I].Bowlers[J].ProdInfo.ProdCode;
                  PI.ProdName := AAR[I].Bowlers[J].ProdInfo.ProdName;
                  PI.ProdAmt := AAR[I].Bowlers[J].ProdInfo.ProdAmt;
                  PI.OrderQty := AAR[I].Bowlers[J].ProdInfo.OrderQty;
                  if (not AReceiptNo.IsEmpty) and
                     (not UpdateSaleItem(LReceiptNo, PI, AResMsg)) then
                    raise Exception.Create(AResMsg);
                end;
                //볼링화 대여료
                if AAR[I].Bowlers[J].ShoesRent and
                   (not AAR[I].Bowlers[J].ShoesFree) then
                begin
                  PI.Clear;
                  PI.AssignLaneNo := LLaneNo;
                  PI.AssignNo := LAssignNo;
                  PI.BowlerId := AAR[I].Bowlers[J].BowlerId;
                  PI.ProdDiv := CO_PROD_RENT;
                  PI.ProdDetailDiv := Global.StoreInfo.ShoesRentProdDetailDiv;
                  PI.ProdCode := Global.StoreInfo.ShoesRentProdCode;
                  PI.ProdName := Global.StoreInfo.ShoesRentProdName;
                  PI.ProdAmt := Global.StoreInfo.ShoesRentProdAmt;
                  PI.OrderQty := 1;
                  if (not AReceiptNo.IsEmpty) and
                     (not UpdateSaleItem(LReceiptNo, PI, AResMsg)) then
                    raise Exception.Create(AResMsg);
                end;
              end;
            end;
          end;
        { 영수증 데이터 업데이트 }
        if (not AReceiptNo.IsEmpty) and
           (not UpdateReceipt(AReceiptNo, AResMsg)) then
          raise Exception.Create(AResMsg);
      end;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.AddBowler(const ALaneNo: ShortInt; const AAssignNo: string; const ABowlerRec: TBowlerRec; var AResMsg: string): Boolean;
const
  CS_API = 'Z106_regBowler';
var
  JO: HCkJsonObject;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
    CkJsonObject_UpdateString(JO, 'api', PWideChar(CS_API));
    CkJsonObject_UpdateInt(JO, 'lane_no', ALaneNo);
    CkJsonObject_UpdateString(JO, 'assign_no', PWideChar(AAssignNo));
    CkJsonObject_UpdateString(JO, 'bowler_id', PWideChar(ABowlerRec.BowlerId));
    CkJsonObject_UpdateString(JO, 'bowler_nm', PWideChar(ABowlerRec.BowlerName));
    CkJsonObject_UpdateString(JO, 'member_no', PWideChar(ABowlerRec.MemberNo));
    CkJsonObject_UpdateInt(JO, 'game_cnt', ABowlerRec.GameCount);
    CkJsonObject_UpdateInt(JO, 'game_min', ABowlerRec.GameMin);
    CkJsonObject_UpdateString(JO, 'fee_div', PWideChar(ABowlerRec.FeeDiv));
    CkJsonObject_UpdateInt(JO, 'membership_seq', ABowlerRec.MembershipSeq);
    CkJsonObject_UpdateInt(JO, 'membership_use_cnt', ABowlerRec.MembershipUseCount);
    CkJsonObject_UpdateInt(JO, 'membership_use_min', ABowlerRec.MembershipUseMin);
    CkJsonObject_UpdateString(JO, 'product_cd', PWideChar(ABowlerRec.ProdInfo.ProdCode));
    CkJsonObject_UpdateString(JO, 'product_nm', PWideChar(ABowlerRec.ProdInfo.ProdName));
    CkJsonObject_UpdateInt(JO, 'payment_type', ABowlerRec.PaymentType);
    CkJsonObject_UpdateString(JO, 'shoes_yn', PWideChar(IfThen(ABowlerRec.ShoesRent, CO_RESULT_YES, CO_RESULT_NO)));
    CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
    LReqJson := CkJsonObject__emit(JO);
    LRespJson := '';
    try
      if not RequestToGameServer(CS_API, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('게임서버 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.ChangeBowler(const ALaneNo: ShortInt; const AAssignNo: string; const ANewBowlerRec: TBowlerRec; var AResMsg: string): Boolean;
const
  CS_API = 'Z107_chgBowler';
var
  JO: HCkJsonObject;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
    CkJsonObject_UpdateString(JO, 'api', PWideChar(CS_API));
    CkJsonObject_UpdateInt(JO, 'lane_no', ALaneNo);
    CkJsonObject_UpdateString(JO, 'assign_no', PWideChar(AAssignNo));
    CkJsonObject_UpdateString(JO, 'bowler_id', PWideChar(ANewBowlerRec.BowlerId));
    CkJsonObject_UpdateString(JO, 'bowler_nm', PWideChar(ANewBowlerRec.BowlerName));
    CkJsonObject_UpdateString(JO, 'member_no', PWideChar(ANewBowlerRec.MemberNo));
    CkJsonObject_UpdateString(JO, 'fee_div', PWideChar(ANewBowlerRec.FeeDiv));
    CkJsonObject_UpdateInt(JO, 'game_cnt', ANewBowlerRec.GameCount);
    CkJsonObject_UpdateInt(JO, 'game_min', ANewBowlerRec.GameMin);
    CkJsonObject_UpdateInt(JO, 'membership_seq', ANewBowlerRec.MembershipSeq);
    CkJsonObject_UpdateInt(JO, 'membership_use_cnt', ANewBowlerRec.MembershipUseCount);
    CkJsonObject_UpdateInt(JO, 'membership_use_min', ANewBowlerRec.MembershipUseMin);
    CkJsonObject_UpdateString(JO, 'product_cd', PWideChar(ANewBowlerRec.ProdInfo.ProdCode));
    CkJsonObject_UpdateString(JO, 'product_nm', PWideChar(ANewBowlerRec.ProdInfo.ProdName));
    CkJsonObject_UpdateString(JO, 'shoes_yn', PWideChar(IfThen(ANewBowlerRec.ShoesRent, CO_RESULT_YES, CO_RESULT_NO)));
    CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
    LReqJson := CkJsonObject__emit(JO);
    LRespJson := '';
    try
      if not RequestToGameServer(CS_API, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('게임서버 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.RelocateLane(const ALaneNo, ATargetLaneNo: ShortInt; var AResMsg: string): Boolean;
const
  CS_API = 'Z109_chgLaneMove';
var
  JO: HCkJsonObject;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
    CkJsonObject_UpdateString(JO, 'api', PWideChar(CS_API));
    CkJsonObject_UpdateInt(JO, 'lane_no', ALaneNo);
    CkJsonObject_UpdateInt(JO, 'target_lane_no', ATargetLaneNo);
    CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
    LReqJson := CkJsonObject__emit(JO);
    LRespJson := '';
    try
      if not RequestToGameServer(CS_API, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('게임서버 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.RelocateBowler(const AAssignNo, ABowlerId: string; const ATargetLaneNo: ShortInt; var AResMsg: string): Boolean;
const
  CS_API = 'Z110_chgLaneBowlerMove';
var
  JO: HCkJsonObject;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
    CkJsonObject_UpdateString(JO, 'api', PWideChar(CS_API));
    CkJsonObject_UpdateString(JO, 'assign_no', PWideChar(AAssignNo));
    CkJsonObject_UpdateString(JO, 'bowler_id', PWideChar(ABowlerId));
    CkJsonObject_UpdateInt(JO, 'target_lane_no', ATargetLaneNo);
    CkJsonObject_UpdateString(JO, 'terminal_id', PWideChar(Global.PartnerCenter.TerminalId));
    CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
    LReqJson := CkJsonObject__emit(JO);
    LRespJson := '';
    try
      if not RequestToGameServer(CS_API, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('게임서버 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function TBPDM.RequestToPartnerCenter(const AProcName, AUrl, AMethod, AReqJson: string; var ARespJson, AResMsg: string): Boolean;
var
  HC: TIdHTTP;
  RS, SS: TStringStream;
  RBS: RawByteString;
  LUrl: string;
begin
  Result := False;
  ARespJson := '';
  AResMsg := '';
  if (AMethod <> Id_HTTPMethodGet) then
    SS := TStringStream.Create(AReqJson, TEncoding.UTF8);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    try
      LUrl := Format('%s/pick/api/%s', [Global.PartnerCenter.Host, AUrl]);
      UpdateLog(Format('RequestToPartnerCenter.%s = %s', [AMethod, LUrl]));
      if Assigned(SS) then
        SS.SaveToFile(Global.DirInfo.LogDir + Format('%s.Request.json', [AProcName]))
      else
        WriteToFile(Global.DirInfo.LogDir + Format('%s.Request.url', [AProcName]), LUrl, True);

      if (LowerCase(Global.PartnerCenter.Host.Substring(0, 5)) = 'https') then
        HC.IOHandler := SSL;
      HC.Request.Method := AMethod;
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.PartnerCenter.OAuthToken;
      HC.URL.URI := Global.PartnerCenter.Host;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.PartnerCenter.Timeout;
      HC.ReadTimeout := Global.PartnerCenter.Timeout;
      if (AMethod = Id_HTTPMethodGet) then
        HC.Get(LUrl, RS)
      else if (AMethod = Id_HTTPMethodPost) then
      begin
        HC.Request.ContentType := 'application/json';
        HC.Post(LUrl, SS, RS);
      end
      else if (AMethod = Id_HTTPMethodPut) then
      begin
        HC.Request.ContentType := 'application/json';
        HC.Put(LUrl, SS, RS);
      end
      else if (AMethod = Id_HTTPMethodDelete) then
      begin
        HC.Request.ContentType := 'application/json';
        HC.Delete(LUrl, RS);
      end
      else
        raise Exception.Create(Format('%s is unsupported http method', [AMethod.QuotedString]));

      RS.SaveToFile(Global.DirInfo.LogDir + Format('%s.Response.json', [AProcName]));
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      ARespJson := String(RBS);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('RequestToPartnerCenter.Exception = %s', [E.Message]));
      end;
    end;
  finally
    if Assigned(SS) then
      FreeAndNil(SS);
    FreeAndNil(RS);
    HC.Disconnect;
    FreeAndNil(HC);
  end;
end;

function TBPDM.GetToken(const AHostUrl, ATerminalId, ASecretKey: string; var AToken, AResMsg: string): Boolean;
const
  CS_API = 'token';
var
  HC: TIdHTTP;
  JO: HCkJsonObject;
  SS, RS: TStringStream;
  LUrl: string;
  //LUtf8: UTF8String;
  LAuth: AnsiString;
begin
  Result := False;
  AResMsg := '';
  AToken := '';
  JO := CkJsonObject_Create;
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    try
      LUrl := Format('%s/oauth/%s', [AHostUrl, CS_API]);
      //LUtf8 := UTF8String(ATerminalId + ':' + ASecretKey);
      //LAuth := Soap.EncdDecd.EncodeBase64(PAnsiChar(LUtf8), Length(LUtf8));
      LAuth := Base64Encode(ATerminalId + ':' + ASecretKey, True);
      UpdateLog(Format('%s.Request = TerminalId: %s, Url: %s', [CS_API, ATerminalId, LUrl]));
      if (LowerCase(Global.PartnerCenter.Host.Substring(0, 5)) = 'https') then
        HC.IOHandler := SSL;
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + LAuth;
      HC.Request.Method := Id_HTTPMethodPost;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.PartnerCenter.Timeout;
      HC.ReadTimeout := Global.PartnerCenter.Timeout;
      SS.WriteString(TIdURI.ParamsEncode('grant_type=client_credentials'));
      HC.Post(LUrl, SS, RS);
      if not CkJsonObject_Load(JO, PWideChar(RS.DataString)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));
      AToken := CkJsonObject__stringOf(JO, 'access_token');
      if AToken.IsEmpty then
      begin
        AResMsg := CkJsonObject__stringOf(JO, 'message');
        raise Exception.Create(Format('message: %s, result_msg: %s', [AResMsg]));
      end;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
    FreeAndNil(RS);
    FreeAndNil(SS);
    HC.Disconnect;
    FreeAndNil(HC);
  end;
end;

function TBPDM.GetStoreInfo(const AStoreCode: string; var AResMsg: string): Boolean;
const
  CS_API = 'B001_getStore';
var
  JO: HCkJsonObject;
  LUri, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      Global.StoreInfo.StoreName := CkJsonObject__stringOf(JO, 'result_data.store_nm');
      Global.StoreInfo.BizNo := CkJsonObject__stringOf(JO, 'result_data.biz_no');
      Global.StoreInfo.BossName := CkJsonObject__stringOf(JO, 'result_data.boss_nm');
      Global.StoreInfo.TelNo := CkJsonObject__stringOf(JO, 'result_data.tel_no');
      Global.StoreInfo.ZipNo := CkJsonObject__stringOf(JO, 'result_data.zipno');
      Global.StoreInfo.Addr := CkJsonObject__stringOf(JO, 'result_data.addr');
      Global.StoreInfo.Addr2 := CkJsonObject__stringOf(JO, 'result_data.addr2');
      Global.StoreInfo.ClosureStart := CkJsonObject__stringOf(JO, 'result_data.closure_start_datetime'); //yyyy-mm-dd hh:nn:ss
      Global.StoreInfo.ClosureEnd := CkJsonObject__stringOf(JO, 'result_data.closure_end_datetime'); //yyyy-mm-dd hh:nn:ss
      Global.StoreInfo.OpenTime := CkJsonObject__stringOf(JO, 'result_data.sale_start_time'); //hh:nn:ss
      Global.StoreInfo.CloseTime := CkJsonObject__stringOf(JO, 'result_data.sale_end_time'); //hh:nn:ss
      if (Global.StoreInfo.OpenTime >= Global.StoreInfo.CloseTime) then
        Global.StoreInfo.CloseTime := Format('%s %s', [Global.DateTime.FormattedNextDate, Global.StoreInfo.CloseTime]) //yyyy-mm-dd hh:nn:ss
      else
        Global.StoreInfo.CloseTime := Format('%s %s', [Global.DateTime.FormattedCurrentDate, Global.StoreInfo.CloseTime]); //yyyy-mm-dd hh:nn:ss
      Global.StoreInfo.OpenTime := Format('%s %s', [Global.DateTime.FormattedCurrentDate, Global.StoreInfo.OpenTime]); //yyyy-mm-dd hh:nn:ss
      Global.StoreInfo.Canceled := (CkJsonObject__stringOf(JO, 'result_data.cancel_yn') = CO_RESULT_YES);
      Global.StoreInfo.IsHoliday := (CkJsonObject__stringOf(JO, 'result_data.store_holiday_yn') = CO_RESULT_YES);
      Global.StoreInfo.ShoesRentProdCode := CkJsonObject__stringOf(JO, 'result_data.shoes_prod_cd');
      if Global.StoreInfo.Canceled then
        raise Exception.Create('계약이 해지된 가맹점 입니다.');
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetTerminalInfo(const ATerminalId: string; var AResMsg: string): Boolean;
const
  CS_API = 'B101_getTerminal';
var
  JO: HCkJsonObject;
  LUri, LRespJson, LResCode, LIniData: string;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?terminal_id=%s', [CS_API, ATerminalId]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      with Global.TerminalInfo do
      begin
        TerminalDiv := CkJsonObject__stringOf(JO, 'result_data.terminal_div');
        TerminalName := CkJsonObject__stringOf(JO, 'result_data.terminal_nm');
        PosNo := CkJsonObject_IntOf(JO, 'result_data.pos_no');
        PeriodEndDate := CkJsonObject__stringOf(JO, 'result_data.period_end_date');
        IsFrontPos := (StrPas(CkJsonObject__stringOf(JO, 'result_data.front_pos_yn')) = CO_RESULT_YES);
        SaleZoneCode := CkJsonObject__stringOf(JO, 'result_data.sale_zone_code');
      end;
      LIniData := CkJsonObject__stringOf(JO, 'result_data.config');
      if not LIniData.IsEmpty then
      begin
        RenameFile(Global.Setting.System.FileName, Format('%s.%s', [Global.Setting.System.FileName, Global.DateTime.CurrentDate]));
        WriteToFile(Global.Setting.System.FileName, LIniData, True);
        Global.ReadSetting;
      end;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%S.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.CheckLogin(const AUserId, ATerminalPwd: string; const ASaveId: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'A002_login';
var
  JO: HCkJsonObject;
  LUri, LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  LReqJson := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := CS_API;
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateString(JO, 'account_id', PWideChar(AUserId));
      CkJsonObject_UpdateString(JO, 'terminal_pwd', PWideChar(ATerminalPwd));
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      Global.UserInfo.UserId := AUserId;
      Global.UserInfo.UserName := CkJsonObject__stringOf(JO, 'result_data.account_nm');
      Global.UserInfo.TerminalPwd := ATerminalPwd;
      Global.Setting.Local.WriteString('UserInfo', 'UserId', IfThen(ASaveId, AUserId, ''));
      Global.Setting.Local.WriteBool('UserInfo', 'SaveId', ASaveId);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetCodeList(var AResMsg: string): Boolean;
begin
  Result := GetCodeList('', AResMsg);
end;

function TBPDM.GetCodeList(const AGroupCode: string; var AResMsg: string): Boolean;
const
  CS_API = 'B002_getStoreCodeList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LSValue: string;
  LCount, LIValue: Integer;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTCodeList';
  try
    try
      LUri := Format('%s?store_cd=%s&group_cd=%s', [CS_API, Global.StoreInfo.StoreCode, AGroupCode]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          if (CkJsonObject__stringOf(RO, 'use_yn') <> CO_RESULT_YES) or
             (CkJsonObject__stringOf(RO, 'del_yn') = CO_RESULT_YES) then
            Continue;

          SetLength(LFields, 0);
          LSValue := CkJsonObject__stringOf(RO, 'group_cd');
          AddFieldInfo(LFields, 'group_cd', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'code');
          AddFieldInfo(LFields, 'code', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'code_nm');
          AddFieldInfo(LFields, 'code_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'sort_ord');
          AddFieldInfo(LFields, 'sort_ord', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRCodeList, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetLaneList(var AResMsg: string): Boolean;
const
  CS_API = 'B501_getLaneList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL: string;
  LCount: Integer;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTLaneList';
  try
    try
      LUri := Format('%s?store_cd=%s&search_datetime=%s', [CS_API, Global.StoreInfo.StoreCode, '']);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        Global.LaneInfo.LaneCount := LCount;
        Global.LaneInfo.LanesClear;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          with Global.LaneInfo.Lanes[I] do
          begin
            LaneNo := CkJsonObject_IntOf(RO, 'lane_no');
            AssignLaneNo := Global.LaneInfo.Lanes[I].LaneNo;
            LaneName := CkJsonObject__stringOf(RO, 'lane_nm');
            DeviceId := CkJsonObject__stringOf(RO, 'device_id');

            SetLength(LFields, 0);
            AddFieldInfo(LFields, 'lane_no', varInteger, LaneNo);
            AddFieldInfo(LFields, 'lane_nm', varString, LaneName);
            AddFieldInfo(LFields, 'device_id', varString, DeviceId);
          end;
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRLaneList, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.LaneList := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetLockerList(var AResMsg: string): Boolean;
const
  CS_API = 'F001_getLockerList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL: string;
  LCount: Integer;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTLockerList';
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        Global.LockerInfo.ItemCount := LCount;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          with Global.LockerInfo.Items[I] do
          begin
            LockerNo := CkJsonObject_IntOf(RO, 'locker_no');
            LockerName := CkJsonObject__stringOf(RO, 'locker_nm');
            ZoneCode := CkJsonObject__stringOf(RO, 'locker_zone_code');
            ZoneName := CkJsonObject__stringOf(RO, 'locker_zone_name');
            LayerCode := CkJsonObject__stringOf(RO, 'locker_layer_code');
            LayerName :=  CkJsonObject__stringOf(RO, 'locker_layer_name');
            SexDiv := CkJsonObject_IntOf(RO, 'sex_div');
            SexDivName := GetSexDivName(Global.LockerInfo.Items[I].SexDiv);
            LockerStatus := CkJsonObject_IntOf(RO, 'locker_status');
            LockerStatusName := GetLockerStatusName(Global.LockerInfo.Items[I].LockerStatus);
            MemberNo := CkJsonObject__stringOf(RO, 'member_no');
            MemberName := CkJsonObject__stringOf(RO, 'member_nm');
            TelNo := CkJsonObject__stringOf(RO, 'mobile_no');
            KeepAmt := CkJsonObject_IntOf(RO, 'keep_amt');
            StartDate := CkJsonObject__stringOf(RO, 'start_date');
            EndDate := CkJsonObject__stringOf(RO, 'end_date');
            LockerMemo := CkJsonObject__stringOf(RO, 'memo');

            SetLength(LFields, 0);
            AddFieldInfo(LFields, 'locker_no', varInteger, LockerNo);
            AddFieldInfo(LFields, 'locker_nm', varString, LockerName);
            AddFieldInfo(LFields, 'locker_zone_code', varString, ZoneCode);
            AddFieldInfo(LFields, 'locker_zone_name', varString, ZoneName);
            AddFieldInfo(LFields, 'locker_layer_code', varString, LayerCode);
            AddFieldInfo(LFields, 'locker_layer_name', varString, LayerName);
            AddFieldInfo(LFields, 'sex_div', varInteger, SexDiv);
            AddFieldInfo(LFields, 'locker_status', varInteger, LockerStatus);
            AddFieldInfo(LFields, 'member_no', varString, MemberNo);
            AddFieldInfo(LFields, 'member_nm', varString, MemberName);
            AddFieldInfo(LFields, 'tel_no', varString, TelNo);
            AddFieldInfo(LFields, 'keep_amt', varInteger, KeepAmt);
            AddFieldInfo(LFields, 'start_dt', varString, StartDate);
            AddFieldInfo(LFields, 'end_dt', varString, EndDate);
            AddFieldInfo(LFields, 'locker_memo', varString, LockerMemo);
          end;
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRLockerList, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.LockerList := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetClubList(var AResMsg: string): Boolean;
const
  CS_API = 'B302_getClubList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LSValue: string;
  LCount, LIValue: Integer;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTClubList';
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        { 빈값 추가 }
        SetLength(LFields, 0);
        AddFieldInfo(LFields, 'club_seq', varInteger, 0);
        AddFieldInfo(LFields, 'club_nm', varString, '<없음>');
        if not MakeInsertSQL(LTableName, LFields, LSQL) then
          raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
        SQL.Add(LSQL);
        { 클럽 정보 추가 }
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          LIValue := CkJsonObject_IntOf(RO, 'club_seq');
          AddFieldInfo(LFields, 'club_seq', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'club_nm');
          AddFieldInfo(LFields, 'club_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'boss_nm');
          AddFieldInfo(LFields, 'boss_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'mobile_no');
          AddFieldInfo(LFields, 'tel_no', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'dc_rate');
          AddFieldInfo(LFields, 'dc_rate', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRClubList, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.ClubList := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetMemberList(var AResMsg: string): Boolean;
const
  CS_API = 'B301_getMemberList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LMemberNo, LSValue: string;
  LCount, LIValue: Integer;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTMemberList';
  try
    try
      LUri := Format('%s?store_cd=%s&search_datetime=%s', [CS_API, Global.StoreInfo.StoreCode, TIdURI.ParamsEncode(Global.MasterUpdated.MemberList)]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          LMemberNo := CkJsonObject__stringOf(RO, 'member_no');
          if not ExecuteABSQuery(Format('DELETE FROM %s WHERE member_no = %s;', [LTableName, LMemberNo.QuotedString]), AResMsg, True) then
            raise Exception.Create(AResMsg);
          if (CkJsonObject__stringOf(RO, 'del_yn') = CO_RESULT_YES) then
            Continue;
          //LCalcTelNo := StringReplace(StringReplace(LTelNo, '-', '', [rfReplaceAll]), ')', '', [rfReplaceAll]);
          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'member_no', varString, LMemberNo);
          LSValue := CkJsonObject__stringOf(RO, 'member_nm');
          AddFieldInfo(LFields, 'member_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'club_seq');
          AddFieldInfo(LFields, 'club_seq', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'club_nm');
          AddFieldInfo(LFields, 'club_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'member_div');
          AddFieldInfo(LFields, 'member_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'member_group_code');
          AddFieldInfo(LFields, 'member_group_code', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'sex_div');
          AddFieldInfo(LFields, 'sex_div', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'birthday');
          AddFieldInfo(LFields, 'birthday', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'mobile_no');
          AddFieldInfo(LFields, 'tel_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'car_no');
          AddFieldInfo(LFields, 'car_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'email');
          AddFieldInfo(LFields, 'email', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'zipno');
          AddFieldInfo(LFields, 'zipno', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'addr');
          AddFieldInfo(LFields, 'addr', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'addr2');
          AddFieldInfo(LFields, 'addr2', varString, LSValue);
          AddFieldInfo(LFields, 'member_memo', varString, ''); //API에 항목 추가 필요
          LIValue := CkJsonObject_IntOf(RO, 'save_point');
          AddFieldInfo(LFields, 'save_point', varInteger, LIValue);
          LBValue := (CkJsonObject__stringOf(RO, 'advertise_agreement_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'ad_agree_yn', varBoolean, LBValue);
          LSValue := CkJsonObject__stringOf(RO, 'qrcd');
          AddFieldInfo(LFields, 'qrcd', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'fingerprint_hash');
          AddFieldInfo(LFields, 'fp_hash', varString, LSValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshMemberList(AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.MemberList := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetMembership(const AMemberNo: string; var AResMsg: string): Boolean;
begin
  Result := GetMembership(AMemberNo, '', '', AResMsg);
end;
function TBPDM.GetMembership(const AMemberNo, AQrCode, AMobileNo: string; var AResMsg: string): Boolean;
const
  CS_API = 'C002_getMember';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LMemberNo, LSValue: string;
  I, LCount, LIValue: Integer;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  JA := nil;
  try
    try
      LUri := Format('%s?store_cd=%s&member_no=%s&qrcd=%s&mobile_no=%s', [CS_API, Global.StoreInfo.StoreCode, AMemberNo, TIdURI.ParamsEncode(AQrCode), TIdURI.ParamsEncode(AMobileNo)]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      LMemberNo := CkJsonObject__stringOf(JO, 'result_data.member_no');
      with TABSQuery.Create(nil) do
      try
        { 회원 보유 회원권 상품 }
        InMemory := True;
        SQL.Clear;
        LTableName := 'MTMembership';
        if not EmptyABSTable(LTableName, True) then
          raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
        JA := CkJsonObject_ArrayOf(JO, 'result_data.membership_list');
        LCount := CkJsonArray_getSize(JA);
        for I := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'member_no', varString, LMemberNo);
          LIValue := CkJsonObject_IntOf(RO, 'membership_seq');
          AddFieldInfo(LFields, 'membership_seq', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_cd');
          AddFieldInfo(LFields, 'prod_cd', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_nm');
          AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div');
          AddFieldInfo(LFields, 'prod_detail_div', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'game_div');
          AddFieldInfo(LFields, 'game_div', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'discount_fee_div');
          AddFieldInfo(LFields, 'discount_fee_div', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'purchase_game_cnt');
          AddFieldInfo(LFields, 'purchase_game_cnt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'remain_game_cnt');
          AddFieldInfo(LFields, 'remain_game_cnt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'purchase_game_min');
          AddFieldInfo(LFields, 'purchase_game_min', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'remain_game_min');
          AddFieldInfo(LFields, 'remain_game_min', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'purchase_datetime');
          AddFieldInfo(LFields, 'purchase_datetime', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'use_status');
          AddFieldInfo(LFields, 'use_status', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'start_date');
          AddFieldInfo(LFields, 'start_dt', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'end_date');
          AddFieldInfo(LFields, 'end_dt', varString, LSValue);
          LBValue := (CkJsonObject__stringOf(RO, 'shoes_free_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'shoes_free_yn', varBoolean, LBValue);
          LIValue := CkJsonObject_IntOf(RO, 'save_point_rate');
          AddFieldInfo(LFields, 'save_point_rate', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;

        { 회원 보유 라커 상품 }
        InMemory := True;
        SQL.Clear;
        LTableName := 'MTMemberLocker';
        if not EmptyABSTable(LTableName, True) then
          raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
        JA := CkJsonObject_ArrayOf(JO, 'result_data.locker_list');
        LCount := CkJsonArray_getSize(JA);
        for I := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          LSValue := CkJsonObject__stringOf(RO, 'member_no');
          AddFieldInfo(LFields, 'member_no', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'locker_no');
          AddFieldInfo(LFields, 'locker_no', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'locker_nm');
          AddFieldInfo(LFields, 'locker_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'locker_zone_code');
          AddFieldInfo(LFields, 'locker_zone_code', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'locker_layer_code');
          AddFieldInfo(LFields, 'locker_layer_code', varString, LSValue);
          LIValue := StrToIntDef(CkJsonObject__stringOf(RO, 'locker_status'), 0);
          AddFieldInfo(LFields, 'locker_status', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'start_date');
          AddFieldInfo(LFields, 'start_dt', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'end_date');
          AddFieldInfo(LFields, 'end_dt', varString, LSValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;
      if not RefreshABSDataSet(QRMembership, AResMsg) then
        raise Exception.Create(AResMsg);
      if not RefreshABSDataSet(QRMemberLocker, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetProdGameList(var AResMsg: string): Boolean;
begin
  Result := GetProdGameList('', '', '', False, AResMsg);
end;
function TBPDM.GetProdGameList(const AProdCode, AFeeDiv, ABaseDateTime: string; const ATodaySaleOnly: Boolean; var AResMsg: string): Boolean;
const
  CS_API = 'B202_getGameProdList';
var
  JO, RO: HCkJsonObject;
  JA, RA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LSValue, LApplyDoW, LApplyStartTime, LApplyEndTime, LProdCode: string;
  I, J, LDoW, LCount, LCount2, LProdAmt, LIValue: Integer;
  LBValue, LTodayYN, LAllowTime: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  RA := nil;
  LDoW := DayOfTheWeek(Now); //DayOfWeek와 다름(월:1, 일: 7)
  LTableName := 'MTProdGame';
  try
    try
      LUri := Format('%s?store_cd=%s&terminal_id=%s&prod_cd=%s&fee_div=%s&today_sale_yn=%s&now_datetime=%s&search_datetime=%s',
          [CS_API, Global.StoreInfo.StoreCode, Global.PartnerCenter.TerminalId, AProdCode, AFeeDiv, IfThen(ATodaySaleOnly, CO_RESULT_YES, CO_RESULT_NO), TIdURI.ParamsEncode(ABaseDateTime), '']);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        SQL.Clear;
        SQL.Add(Format('DELETE FROM %s WHERE membership_yn = False;', [LTableName]));
        for I := 0 to Pred(LCount) do
        begin
          JO := CkJsonArray_ObjectAt(JA, I);
          LProdCode := CkJsonObject__stringOf(JO, 'prod_cd');
          if (CkJsonObject__stringOf(JO, 'del_yn') = CO_RESULT_YES) then
          begin
            if not ExecuteABSQuery(Format('DELETE FROM %s WHERE prod_cd = %s;', [LTableName, LProdCode.QuotedString]), AResMsg, True) then
              raise Exception.Create(AResMsg);
            Continue;
          end;

          RA := CkJsonObject_ArrayOf(JO, 'prod_price_list');
          LCount2 := CkJsonArray_getSize(RA);
          LTodayYN := False;
          LAllowTime := False;
          LApplyStartTime := '';
          LApplyEndTime := '';
          LProdAmt := 0;
          for J := 0 to Pred(LCount2) do
          begin
            RO := CkJsonArray_ObjectAt(RA, J);
            LApplyDoW := CkJsonObject__stringOf(RO, 'apply_dow_string'); //월:1~일:7,휴일:8
            LTodayYN := (Global.StoreInfo.IsHoliday and (LApplyDow.Substring(7, 1) = '1')) or
                        (LApplyDoW.Substring(Pred(LDoW), 1) = '1');
            if LTodayYN then
            begin
              LApplyStartTime := CkJsonObject__stringOf(RO, 'apply_start_time');
              LApplyEndTime := CkJsonObject__stringOf(RO, 'apply_end_time');
              LProdAmt := CkJsonObject_IntOf(RO, 'prod_amt');
              if (LApplyStartTime <= Global.DateTime.FormattedCurrentTime.Substring(0, 5)) and
                 (LApplyEndTime >= Global.DateTime.FormattedCurrentTime.Substring(0, 5)) then
              begin
                LAllowTime := True;
                Break;
              end;
            end;
          end;

          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'prod_cd', varString, LProdCode);
          AddFieldInfo(LFields, 'membership_yn', varBoolean, False);
          LSValue := CkJsonObject__stringOf(JO, 'prod_detail_div');
          AddFieldInfo(LFields, 'prod_detail_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(JO, 'prod_detail_div_nm');
          AddFieldInfo(LFields, 'prod_detail_div_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(JO, 'prod_nm');
          AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
          AddFieldInfo(LFields, 'prod_amt', varInteger, LProdAmt);
          LIValue := CkJsonObject_IntOf(JO, 'game_div');
          AddFieldInfo(LFields, 'game_div', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(JO, 'fee_div');
          AddFieldInfo(LFields, 'fee_div', varString, LSValue);
          LIValue := CkJsonObject_IntOf(JO, 'use_game_cnt');
          AddFieldInfo(LFields, 'use_game_cnt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(JO, 'use_game_min');
          AddFieldInfo(LFields, 'use_game_min', varInteger, LIValue);
          AddFieldInfo(LFields, 'expire_day', varInteger, 0);
          LSValue := CkJsonObject__stringOf(JO, 'sale_zone_code');
          AddFieldInfo(LFields, 'sale_zone_code', varString, LSValue);
          AddFieldInfo(LFields, 'today_yn', varBoolean, LTodayYN and LAllowTime);
          LBValue := (CkJsonObject__stringOf(JO, 'use_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'use_yn', varBoolean, LBValue);
          AddFieldInfo(LFields, 'shoes_free_yn', varBoolean, False);
          AddFieldInfo(LFields, 'save_point_rate', varInteger, 0);
          AddFieldInfo(LFields, 'apply_start_tm', varString, LApplyStartTime);
          AddFieldInfo(LFields, 'apply_end_tm', varString, LApplyEndTime);
          LIValue := CkJsonObject_IntOf(JO, 'sort_ord');
          AddFieldInfo(LFields, 'sort_ord', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRProdGame, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.ProdGame := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(RA) then
      CkJsonArray_Dispose(RA);
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetProdMembershipList(var AResMsg: string): Boolean;
const
  CS_API = 'B206_getMembershipProdList';
var
  JO, RO: HCkJsonObject;
  JA, RA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LProdCode, LSValue: string;
  LCount, LIValue: Integer;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  RA := nil;
  LTableName := 'MTProdGame';
  try
    try
      LUri := Format('%s?store_cd=%s&terminal_id=%s&search_datetime=%s', [CS_API, Global.StoreInfo.StoreCode, Global.PartnerCenter.TerminalId, TIdURI.ParamsEncode(Global.MasterUpdated.ProdMembership)]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        SQL.Clear;
        SQL.Add(Format('DELETE FROM %s WHERE membership_yn = True;', [LTableName]));
        for var I: Integer := 0 to Pred(LCount) do
        begin
          JO := CkJsonArray_ObjectAt(JA, I);
          LProdCode := CkJsonObject__stringOf(JO, 'prod_cd');
          if (CkJsonObject__stringOf(JO, 'del_yn') = CO_RESULT_YES) then
          begin
            if not ExecuteABSQuery(Format('DELETE FROM %s WHERE prod_cd = %s;', [LTableName, LProdCode.QuotedString]), AResMsg, True) then
              raise Exception.Create(AResMsg);
            Continue;
          end;
          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'prod_cd', varString, LProdCode);
          AddFieldInfo(LFields, 'membership_yn', varBoolean, True);
          LSValue := CkJsonObject__stringOf(JO, 'prod_detail_div');
          AddFieldInfo(LFields, 'prod_detail_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(JO, 'prod_detail_div_nm');
          AddFieldInfo(LFields, 'prod_detail_div_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(JO, 'prod_nm');
          AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(JO, 'prod_amt');
          AddFieldInfo(LFields, 'prod_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(JO, 'game_div');
          AddFieldInfo(LFields, 'game_div', varInteger, LIValue);
          AddFieldInfo(LFields, 'fee_div', varString, CO_GAMEFEE_MEMBER);
          LIValue := CkJsonObject_IntOf(JO, 'use_game_cnt');
          AddFieldInfo(LFields, 'use_game_cnt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(JO, 'use_game_min');
          AddFieldInfo(LFields, 'use_game_min', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(JO, 'expire_day');
          AddFieldInfo(LFields, 'expire_day', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(JO, 'sale_zone_code');
          AddFieldInfo(LFields, 'sale_zone_code', varString, LSValue);
          AddFieldInfo(LFields, 'today_yn', varBoolean, True);
          LBValue := (CkJsonObject__stringOf(JO, 'use_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'use_yn', varBoolean, LBValue);
          LBValue := (CkJsonObject__stringOf(JO, 'shoes_free_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'shoes_free_yn', varBoolean, LBValue);
          LIValue := CkJsonObject_IntOf(JO, 'save_point_rate');
          AddFieldInfo(LFields, 'save_point_rate', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(JO, 'discount_fee_div');
          AddFieldInfo(LFields, 'discount_fee_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(JO, 'prod_benefits');
          AddFieldInfo(LFields, 'prod_benefits', varString, LSValue);
          LIValue := CkJsonObject_IntOf(JO, 'sort_ord');
          AddFieldInfo(LFields, 'sort_ord', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRProdGame, AResMsg) then
        raise Exception.Create(AResMsg);
      if not RefreshABSDataSet(QRProdMembership, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.ProdMembership := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(RA) then
      CkJsonArray_Dispose(RA);
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetProdLockerList(var AResMsg: string): Boolean;
const
  CS_API = 'B203_getLockerProdList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LProdCode, LSValue: string;
  LCount, LIValue: Integer;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTProdLocker';
  try
    try
      LUri := Format('%s?store_cd=%s&search_datetime=%s', [CS_API, Global.StoreInfo.StoreCode, TIdURI.ParamsEncode(Global.MasterUpdated.ProdLocker)]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          LProdCode := CkJsonObject__stringOf(RO, 'prod_cd');
          if not ExecuteABSQuery(Format('DELETE FROM %s WHERE prod_cd = %s;', [LTableName, LProdCode.QuotedString]), AResMsg, True) then
            raise Exception.Create(AResMsg);
          if (CkJsonObject__stringOf(RO, 'del_yn') = CO_RESULT_YES) then
            Continue;

          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'prod_cd', varString, LProdCode);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div');
          AddFieldInfo(LFields, 'prod_detail_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div_nm');
          AddFieldInfo(LFields, 'prod_detail_div_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_nm');
          AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'prod_amt');
          AddFieldInfo(LFields, 'prod_amt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'sale_zone_code');
          AddFieldInfo(LFields, 'sale_zone_code', varString, LSValue);
          LBValue := (CkJsonObject__stringOf(RO, 'use_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'use_yn', varBoolean, LBValue);
          LIValue := CkJsonObject_IntOf(RO, 'sort_ord');
          AddFieldInfo(LFields, 'sort_ord', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRProdLocker, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.ProdLocker := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetProdRentList(var AResMsg: string): Boolean;
const
  CS_API = 'B205_getRentProdList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LProdCode, LSValue: string;
  LCount, LIValue: Integer;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTProdRent';
  try
    try
      LUri := Format('%s?store_cd=%s&search_datetime=%s', [CS_API, Global.StoreInfo.StoreCode, TIdURI.ParamsEncode(Global.MasterUpdated.ProdRent)]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          LProdCode := CkJsonObject__stringOf(RO, 'prod_cd');
          if not ExecuteABSQuery(Format('DELETE FROM %s WHERE prod_cd = %s;', [LTableName, LProdCode.QuotedString]), AResMsg, True) then
            raise Exception.Create(AResMsg);
          if (CkJsonObject__stringOf(RO, 'del_yn') = CO_RESULT_YES) then
            Continue;

          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'prod_cd', varString, LProdCode);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div');
          AddFieldInfo(LFields, 'prod_detail_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div_nm');
          AddFieldInfo(LFields, 'prod_detail_div_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_nm');
          AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'prod_amt');
          AddFieldInfo(LFields, 'prod_amt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'sale_zone_code');
          AddFieldInfo(LFields, 'sale_zone_code', varString, LSValue);
          LBValue := (CkJsonObject__stringOf(RO, 'use_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'use_yn', varBoolean, LBValue);
          LIValue := CkJsonObject_IntOf(RO, 'sort_ord');
          AddFieldInfo(LFields, 'sort_ord', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRProdRent, AResMsg) then
        raise Exception.Create(AResMsg);
      //볼링화 대여료 기본값
      if QRProdRent.Locate('prod_cd', Global.StoreInfo.ShoesRentProdCode, []) then
      begin
        Global.StoreInfo.ShoesRentProdDetailDiv := QRProdRent.FieldByName('prod_detail_div').AsString;
        Global.StoreInfo.ShoesRentProdName := QRProdRent.FieldByName('prod_nm').AsString;
        Global.StoreInfo.ShoesRentProdAmt := QRProdRent.FieldByName('prod_amt').AsInteger;
      end;
      Global.MasterUpdated.ProdRent := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetProdGeneralList(var AResMsg: string): Boolean;
const
  CS_API = 'B204_getGeneralProdList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LProdCode, LSValue: string;
  LCount, LIValue: Integer;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTProdGeneral';
  try
    try
      LUri := Format('%s?store_cd=%s&search_datetime=%s', [CS_API, Global.StoreInfo.StoreCode, TIdURI.ParamsEncode(Global.MasterUpdated.ProdGeneral)]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          LProdCode := CkJsonObject__stringOf(RO, 'prod_cd');
          if not ExecuteABSQuery(Format('DELETE FROM %s WHERE prod_cd = %s;', [LTableName, LProdCode.QuotedString]), AResMsg, True) then
            raise Exception.Create(AResMsg);
          if (CkJsonObject__stringOf(RO, 'del_yn') = CO_RESULT_YES) then
            Continue;

          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'prod_cd', varString, LProdCode);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div');
          AddFieldInfo(LFields, 'prod_detail_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div_nm');
          AddFieldInfo(LFields, 'prod_detail_div_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_nm');
          AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'prod_amt');
          AddFieldInfo(LFields, 'prod_amt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'sale_zone_code');
          AddFieldInfo(LFields, 'sale_zone_code', varString, LSValue);
          LBValue := (CkJsonObject__stringOf(RO, 'use_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'use_yn', varBoolean, LBValue);
          LIValue := CkJsonObject_IntOf(RO, 'sort_ord');
          AddFieldInfo(LFields, 'sort_ord', varInteger, LIValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRProdGeneral, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.ProdGeneral := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetPluList(var AResMsg: string): Boolean;
const
  CS_API = 'B201_getPluList';
var
  JO, O1, O2: HCkJsonObject;
  JA, A1, A2: HCkJsonArray;
  LUri, LRespJson, LResCode, LTableName, LSQL, LProdDiv, LProdDivName, LSaleZoneCode, LDetailDiv, LDetailDivName, LProdCode, LSValue: string;
  I, J, K, LCount1, LCount2, LCount3, LGroup, LIValue: Integer;
  LFields: TArray<TFieldInfoRec>;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  JA := nil;
  O1 := nil;
  O2 := nil;
  A1 := nil;
  A2 := nil;
  LTableName := 'MTPluList';
  try
    try
      LUri := Format('%s?store_cd=%s&terminal_id=%s&search_datetime=', [CS_API, Global.StoreInfo.StoreCode, Global.PartnerCenter.TerminalId]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount1 := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      Global.PluManager.ClearGroup;
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for I := 0 to Pred(LCount1) do
        begin
          JO := CkJsonArray_ObjectAt(JA, I);
          A1 := CkJsonObject_ArrayOf(JO, 'prod_detail_list');
          LCount2 := CkJsonArray_getSize(A1);
          for J := 0 to Pred(LCount2) do
          begin
            LProdDiv := CkJsonObject__stringOf(JO, 'prod_div');
            LProdDivName := CkJsonObject__stringOf(JO, 'prod_div_nm');
            O1 := CkJsonArray_ObjectAt(A1, J);
            A2 := CkJsonObject_ArrayOf(O1, 'prod_list');
            LCount3 := CkJsonArray_getSize(A2);
            for K := 0 to Pred(LCount3) do
            begin
              LSaleZoneCode := CkJsonObject__stringOf(O1, 'sale_zone_code');
              if (LSaleZoneCode <> Global.TerminalInfo.SaleZoneCode) then
                Continue;
              O2 := CkJsonArray_ObjectAt(A2, K);
              LProdCode := CkJsonObject__stringOf(O2, 'prod_cd');
              LDetailDiv := CkJsonObject__stringOf(O1, 'prod_detail_div');
              LDetailDivName := CkJsonObject__stringOf(O1, 'prod_detail_div_nm');
              if not ExecuteABSQuery(Format('DELETE FROM %s WHERE prod_div = %s AND prod_detail_div = %s AND prod_cd = %s;',
                        [LTableName, LProdDiv.QuotedString, LDetailDiv.QuotedString, LProdCode.QuotedString]), AResMsg, True) then
                raise Exception.Create(AResMsg);
              if (CkJsonObject__stringOf(O2, 'del_yn') = CO_RESULT_YES) then
                Continue;
              SetLength(LFields, 0);
              AddFieldInfo(LFields, 'prod_div', varString, LProdDiv);
              AddFieldInfo(LFields, 'prod_div_nm', varString, LProdDivName);
              AddFieldInfo(LFields, 'prod_detail_div', varString, LDetailDiv);
              AddFieldInfo(LFields, 'prod_detail_div_nm', varString, LDetailDivName);
              AddFieldInfo(LFields, 'prod_cd', varString, LProdCode);
              LSValue := CkJsonObject__stringOf(O2, 'prod_nm');
              AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
              AddFieldInfo(LFields, 'sale_zone_code', varString, LSaleZoneCode);
              LIValue := CkJsonObject_IntOf(O2, 'sort_ord');
              AddFieldInfo(LFields, 'sort_ord', varInteger, LIValue);
              if not MakeInsertSQL(LTableName, LFields, LSQL) then
                raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
              LGroup := Global.PluManager.AddGroup(LDetailDiv, LProdDivName + _CRLF + LDetailDivName);
              Global.PluManager.AddItem(LGroup, LProdDiv, LProdCode);
            end;
          end;
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRPluList, AResMsg) then
        raise Exception.Create(AResMsg);
      Global.MasterUpdated.PluList := Global.DateTime.FormattedCurrentDateTime;
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(A2) then
      CkJsonArray_Dispose(A2);
    if Assigned(O2) then
      CkJsonObject_Dispose(O2);
    if Assigned(A1) then
      CkJsonArray_Dispose(A1);
    if Assigned(O1) then
      CkJsonObject_Dispose(O1);
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetSaleList(const AStartDate, AEndDate, AReceiptNo: string; var AResMsg: string): Boolean;
const
  CS_API = 'G003_getSalesList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LCount, LIValue: Integer;
  LUri, LRespJson, LResCode, LTableName, LSQL, LSValue: string;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTReceiptList';
  try
    try
      LUri := Format('%s?store_cd=%s&terminal_id=%s&sale_dt_start=%s&sale_dt_end=%s&receipt_no=%s',
        [CS_API, Global.StoreInfo.StoreCode, Global.PartnerCenter.TerminalId, AStartDate, AEndDate, AReceiptNo]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          LSValue := CkJsonObject__stringOf(RO, 'receipt_no');
          AddFieldInfo(LFields, 'receipt_no', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'pos_no');
          AddFieldInfo(LFields, 'pos_no', varInteger, LIValue);
          LSValue := FormattedDateString(CkJsonObject__stringOf(RO, 'sale_dt'));
          AddFieldInfo(LFields, 'sale_dt', varString, LSValue);
          LSValue := FormattedTimeString(CkJsonObject__stringOf(RO, 'sale_tm'));
          AddFieldInfo(LFields, 'sale_tm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'orders_prod_nm');
          AddFieldInfo(LFields, 'order_nm', varString, LSValue);
          LBValue := (CkJsonObject__stringOf(RO, 'refund_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'cancel_yn', varBoolean, LBValue);
          LIValue := CkJsonObject_IntOf(RO, 'receive_amt');
          AddFieldInfo(LFields, 'receive_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'charge_amt');
          AddFieldInfo(LFields, 'charge_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'sale_amt');
          AddFieldInfo(LFields, 'sale_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'vat');
          AddFieldInfo(LFields, 'vat', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'coupon_dc_amt');
          AddFieldInfo(LFields, 'coupon_dc_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'dc_amt');
          AddFieldInfo(LFields, 'dc_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'use_point');
          AddFieldInfo(LFields, 'use_point', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'change_amt');
          AddFieldInfo(LFields, 'change_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'keep_amt');
          AddFieldInfo(LFields, 'keep_amt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'sale_root_div');
          AddFieldInfo(LFields, 'sale_root_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'org_receipt_no');
          AddFieldInfo(LFields, 'org_receipt_no', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'approval_cnt');
          AddFieldInfo(LFields, 'approval_cnt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'approval_cancel_cnt');
          AddFieldInfo(LFields, 'cancel_cnt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'memo');
          AddFieldInfo(LFields, 'sale_memo', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'reg_id');
          AddFieldInfo(LFields, 'user_id', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'chg_datetime');
          AddFieldInfo(LFields, 'update_dttm', varString, LSValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRReceiptList, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetSaleDetailList(const AReceiptNo: string; var AResMsg: string): Boolean;
const
  CS_API = 'G004_getSales';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LUri, LRespJson, LResCode, LTableName, LSQL, LApproveNo, LSValue: string;
  I, LCount, LPayMethod, LCashEntity, LIValue: Integer;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  try
    try
      LUri := Format('%s?store_cd=%s&receipt_no=%s',
        [CS_API, Global.StoreInfo.StoreCode, AReceiptNo]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JO := CkJsonObject_ObjectOf(JO, 'result_data');
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        LTableName := 'MTPaymentList';
        if not EmptyABSTable(LTableName, True) then
          raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
        JA := CkJsonObject_ArrayOf(JO, 'payment');
        LCount := CkJsonArray_getSize(JA);
        SQL.Clear;
        for I := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'receipt_no', varString, AReceiptNo);
          LIValue := CkJsonObject_IntOf(RO, 'pay_seq');
          AddFieldInfo(LFields, 'pay_seq', varInteger, LIValue);
          LPayMethod := CkJsonObject_IntOf(RO, 'pay_method_div');
          AddFieldInfo(LFields, 'pay_method', varInteger, LPayMethod);
          LBValue := (CkJsonObject__stringOf(RO, 'cancel_yn') <> CO_RESULT_YES);
          AddFieldInfo(LFields, 'approval_yn', varBoolean, LBValue);
          LBValue := (CkJsonObject__stringOf(RO, 'manual_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'manual_input_yn', varBoolean, LBValue);
          LSValue := CkJsonObject__stringOf(RO, 'van_cd');
          AddFieldInfo(LFields, 'van_cd', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'tid');
          AddFieldInfo(LFields, 'tid', varString, LSValue);
          LApproveNo := CkJsonObject__stringOf(RO, 'approve_no');
          AddFieldInfo(LFields, 'approve_no', varString, LApproveNo);
          LIValue := CkJsonObject_IntOf(RO, 'approve_amt');
          AddFieldInfo(LFields, 'approve_amt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'org_approve_no');
          AddFieldInfo(LFields, 'org_approve_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'org_approve_dt');
          AddFieldInfo(LFields, 'org_approve_dt', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'vat');
          AddFieldInfo(LFields, 'vat', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'inst_month');
          AddFieldInfo(LFields, 'inst_month', varInteger, LIValue);
          LCashEntity := CkJsonObject_IntOf(RO, 'cash_entity_div');
          AddFieldInfo(LFields, 'cash_entity_div', varInteger, LCashEntity);
          LSValue := CkJsonObject__stringOf(RO, 'card_no');
          AddFieldInfo(LFields, 'card_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'trade_no');
          AddFieldInfo(LFields, 'trade_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'trade_dt');
          AddFieldInfo(LFields, 'trade_dt', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'card_issuer_cd');
          AddFieldInfo(LFields, 'issuer_cd', varString, LSValue);
          if (LPayMethod = CO_PAYMENT_CASH) and
             not LApproveNo.IsEmpty then
          begin
            case LCashEntity of
              CO_CASH_RECEIPT_PERSON:
                AddFieldInfo(LFields, 'issuer_nm', varString, '현금영수증(개인)');
              CO_CASH_RECEIPT_BIZ:
                AddFieldInfo(LFields, 'issuer_nm', varString, '현금영수증(사업자)');
            end;
          end
          else
          begin
            LSValue := CkJsonObject__stringOf(RO, 'card_issuer_nm');
            AddFieldInfo(LFields, 'issuer_nm', varString, LSValue);
          end;
          LSValue := CkJsonObject__stringOf(RO, 'card_acquir_div');
          AddFieldInfo(LFields, 'buyer_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'card_acquir_cd');
          AddFieldInfo(LFields, 'buyer_cd', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'card_acquir_nm');
          AddFieldInfo(LFields, 'buyer_nm', varString, LSValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;

        LTableName := 'MTSaleItemList';
        if not EmptyABSTable(LTableName, True) then
          raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
        JA := CkJsonObject_ArrayOf(JO, 'orders');
        LCount := CkJsonArray_getSize(JA);
        SQL.Clear;
        for I := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'receipt_no', varString, AReceiptNo);
          LIValue := CkJsonObject_IntOf(RO, 'assign_lane_no');
          AddFieldInfo(LFields, 'assign_lane_no', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'bowler_id');
          AddFieldInfo(LFields, 'bowler_id', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'member_no');
          AddFieldInfo(LFields, 'member_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'member_nm');
          AddFieldInfo(LFields, 'member_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'assign_no');
          AddFieldInfo(LFields, 'assign_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_div');
          AddFieldInfo(LFields, 'prod_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_detail_div');
          AddFieldInfo(LFields, 'prod_detail_div', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_cd');
          AddFieldInfo(LFields, 'prod_cd', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'prod_nm');
          AddFieldInfo(LFields, 'prod_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'sale_qty');
          AddFieldInfo(LFields, 'order_qty', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'unit_price');
          AddFieldInfo(LFields, 'prod_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'item_dc_amt');
          AddFieldInfo(LFields, 'dc_amt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'use_point');
          AddFieldInfo(LFields, 'use_point', varInteger, LIValue);
          LBValue := (CkJsonObject__stringOf(RO, 'service_yn') = CO_RESULT_YES);;
          AddFieldInfo(LFields, 'service_yn', varBoolean, LBValue);
          AddFieldInfo(LFields, 'payment_yn', varBoolean, True);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRSaleItemList, AResMsg) then
        raise Exception.Create(AResMsg);
      if not RefreshABSDataSet(QRPaymentList, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetRallyList(const AStartDate, AEndDate, ARallyTitle: string; const AClubSeq: Integer; var AResMsg: string): Boolean;
const
  CS_API = 'E301_getCompetitionList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LCount, LIValue: Integer;
  LUri, LRespJson, LResCode, LTableName, LSQL, LSValue: string;
  LBValue: Boolean;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTRallyList';
  try
    try
      LUri := Format('%s?store_cd=%s&reg_date_start=%s&reg_date_end=%s&club_seq=%d&competition_nm=%s&order_method=%d',
        [CS_API, Global.StoreInfo.StoreCode, AStartDate, AEndDate, AClubSeq, TIdURI.ParamsEncode(ARallyTitle), 1]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          LIValue := CkJsonObject_IntOf(RO, 'competition_seq');
          AddFieldInfo(LFields, 'rally_seq', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'competition_nm');
          AddFieldInfo(LFields, 'rally_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'club_nm');
          AddFieldInfo(LFields, 'club_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'participants_cnt');
          AddFieldInfo(LFields, 'entry_cnt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'lane_nm');
          AddFieldInfo(LFields, 'lane_nm', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'game_cnt');
          AddFieldInfo(LFields, 'game_cnt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'competition_datetime');
          AddFieldInfo(LFields, 'rally_datetime', varString, LSValue.Substring(0, 16)); //초 단위 생략
          LBValue := (CkJsonObject__stringOf(RO, 'league_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'league_yn', varBoolean, LBValue);
          LIValue := CkJsonObject_IntOf(RO, 'lane_move_cnt');
          AddFieldInfo(LFields, 'lane_move_cnt', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'move_method');
          AddFieldInfo(LFields, 'move_method', varString, LSValue);
          LBValue := (CkJsonObject__stringOf(RO, 'rank_nohandy_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'rank_nohandy_yn', varBoolean, LBValue);
          LBValue := (CkJsonObject__stringOf(RO, 'rank_highlow_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'rank_highlow_yn', varBoolean, LBValue);
          LBValue := (CkJsonObject__stringOf(RO, 'rank_birth_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'rank_birth_yn', varBoolean, LBValue);
          LBValue := (CkJsonObject__stringOf(RO, 'team_yn') = CO_RESULT_YES);
          AddFieldInfo(LFields, 'team_yn', varBoolean, LBValue);
          LSValue := CkJsonObject__stringOf(RO, 'reg_datetime');
          AddFieldInfo(LFields, 'reg_datetime', varString, LSValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRRallyList, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.GetRallyEntryList(const ARallySeq: Integer; var AResMsg: string): Boolean;
const
  CS_API = 'E302_getParticipantsList';
var
  JO, RO: HCkJsonObject;
  JA: HCkJsonArray;
  LFields: TArray<TFieldInfoRec>;
  LCount, LIValue: Integer;
  LUri, LRespJson, LResCode, LTableName, LSQL, LSValue: string;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  RO := nil;
  JA := nil;
  LTableName := 'MTRallyEntryList';
  try
    try
      LUri := Format('%s?store_cd=%s&competition_seq=%d', [CS_API, Global.StoreInfo.StoreCode, ARallySeq]);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodGet, '', LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));

      JA := CkJsonObject_ArrayOf(JO, 'result_data');
      LCount := CkJsonArray_getSize(JA);
      if not EmptyABSTable(LTableName, True) then
        raise Exception.Create(Format('EmptyABSTable.Exception = %s', [LTableName]));
      with TABSQuery.Create(nil) do
      try
        InMemory := True;
        for var I: Integer := 0 to Pred(LCount) do
        begin
          RO := CkJsonArray_ObjectAt(JA, I);
          SetLength(LFields, 0);
          AddFieldInfo(LFields, 'rally_seq', varInteger, ARallySeq);
          LIValue := CkJsonObject_IntOf(RO, 'participants_seq');
          AddFieldInfo(LFields, 'entry_seq', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'member_div');
          AddFieldInfo(LFields, 'member_div', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'club_seq');
          AddFieldInfo(LFields, 'club_seq', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'club_nm');
          AddFieldInfo(LFields, 'club_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'member_no');
          AddFieldInfo(LFields, 'member_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'bowler_nm');
          AddFieldInfo(LFields, 'bowler_nm', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'mobile_no');
          AddFieldInfo(LFields, 'mobile_no', varString, LSValue);
          LSValue := CkJsonObject__stringOf(RO, 'birthday');
          AddFieldInfo(LFields, 'birthday', varString, LSValue);
          LIValue := CkJsonObject_IntOf(RO, 'lane_no');
          AddFieldInfo(LFields, 'lane_no', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'game_cnt');
          AddFieldInfo(LFields, 'game_cnt', varInteger, LIValue);
          LIValue := CkJsonObject_IntOf(RO, 'handy');
          AddFieldInfo(LFields, 'handy', varInteger, LIValue);
          LSValue := CkJsonObject__stringOf(RO, 'reg_datetime');
          AddFieldInfo(LFields, 'reg_datetime', varString, LSValue);
          if not MakeInsertSQL(LTableName, LFields, LSQL) then
            raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
          SQL.Add(LSQL);
        end;
        if not SQL.Text.IsEmpty then
          ExecSQL;
      finally
        Close;
        Free;
      end;

      if not RefreshABSDataSet(QRRallyEntryList, AResMsg) then
        raise Exception.Create(AResMsg);
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    if Assigned(RO) then
      CkJsonObject_Dispose(RO);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostProdSale(ARI: TReceiptItemInfo; ASL: TArray<TProdItemRec>; APL: TArray<TPaymentItemRec>; var AResMsg: string): Boolean;
const
  CS_API = 'G001_regSales';
var
  JO: HCkJsonObject;
  LUri, LReqJson, LRespJson, LResCode: string;
  I: ShortInt;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateString(JO, 'receipt_no', PWideChar(ARI.ReceiptNo));
      CkJsonObject_UpdateString(JO, 'sale_dt', PWideChar(Global.DateTime.CurrentDate));
      CkJsonObject_UpdateString(JO, 'sale_tm', PWideChar(Global.DateTime.CurrentTime));
      CkJsonObject_UpdateString(JO, 'terminal_id', PWideChar(Global.PartnerCenter.TerminalId));
      CkJsonObject_UpdateInt(JO, 'pos_no', Global.TerminalInfo.PosNo);
      CkJsonObject_UpdateInt(JO, 'charge_amt', ARI.ChargeAmt);
      CkJsonObject_UpdateInt(JO, 'receive_amt', ARI.ReceiveAmt);
      CkJsonObject_UpdateInt(JO, 'dc_amt', ARI.DCAmt);
      CkJsonObject_UpdateInt(JO, 'use_point', ARI.UsePoint);
      CkJsonObject_UpdateInt(JO, 'change_amt', ARI.ChangeAmt);
      CkJsonObject_UpdateInt(JO, 'vat', ARI.VAT);
      CkJsonObject_UpdateString(JO, 'sale_root_div', PWideChar(CO_CLIENT_POS));
      CkJsonObject_UpdateString(JO, 'memo', PWideChar(ARI.SaleMemo));
      CkJsonObject_UpdateString(JO, 'reg_id', PWideChar(Global.UserInfo.UserId));
      CkJsonObject_UpdateNewArray(JO, 'orders');
      CkJsonObject_UpdateNewArray(JO, 'payment');
      CkJsonObject_UpdateNewArray(JO, 'coupon');

      for I := 0 to High(ASL) do
      begin
        CkJsonObject_putI(JO, I);
        CkJsonObject_UpdateInt(JO, 'orders[i].assign_lane_no', ASL[I].AssignLaneNo);
        CkJsonObject_UpdateString(JO, 'orders[i].bowler_id', PWideChar(ASL[I].BowlerId));
        CkJsonObject_UpdateString(JO, 'orders[i].member_no', PWideChar(ASL[I].MemberNo));
        CkJsonObject_UpdateString(JO, 'orders[i].assign_no', PWideChar(ASL[I].AssignNo));
        CkJsonObject_UpdateString(JO, 'orders[i].prod_cd', PWideChar(ASL[I].ProdCode));
        CkJsonObject_UpdateInt(JO, 'orders[i].sale_qty', ASL[I].OrderQty);
        CkJsonObject_UpdateInt(JO, 'orders[i].unit_price', ASL[I].ProdAmt);
        CkJsonObject_UpdateInt(JO, 'orders[i].item_dc_amt', ASL[I].DCAmt);
        CkJsonObject_UpdateInt(JO, 'orders[i].use_point', ASL[I].UsePoint);
        CkJsonObject_UpdateString(JO, 'orders[i].service_yn', PWideChar(IfThen(ASL[I].IsService, CO_RESULT_YES, CO_RESULT_NO)));
        CkJsonObject_UpdateInt(JO, 'orders[i].locker_no', ASL[I].LockerNo);
        CkJsonObject_UpdateInt(JO, 'orders[i].months', ASL[I].PurchaseMonth);
        CkJsonObject_UpdateString(JO, 'orders[i].start_date', PWideChar(ASL[I].UseStartDate)); //yyyy-mm-dd
        CkJsonObject_UpdateInt(JO, 'orders[i].keep_amt', ASL[I].KeepAmt);
      end;

      for I := 0 to High(APL) do
      begin
        CkJsonObject_putI(JO, I);
        CkJsonObject_UpdateInt(JO, 'payment[i].pay_method_div', APL[I].PayMethod);
        CkJsonObject_UpdateString(JO, 'payment[i].cancel_yn', PWideChar(IfThen(APL[I].IsApproval, CO_RESULT_NO, CO_RESULT_YES)));
        CkJsonObject_UpdateString(JO, 'payment[i].manual_yn', PWideChar(IfThen(APL[I].IsManualInput, CO_RESULT_YES, CO_RESULT_NO)));
        CkJsonObject_UpdateString(JO, 'payment[i].van_cd', PWideChar(APL[I].VanCode));
        CkJsonObject_UpdateString(JO, 'payment[i].tid', PWideChar(APL[I].TID));
        CkJsonObject_UpdateString(JO, 'payment[i].approve_no', PWideChar(APL[I].ApproveNo));
        CkJsonObject_UpdateInt(JO, 'payment[i].approve_amt', APL[I].ApproveAmt);
        CkJsonObject_UpdateInt(JO, 'payment[i].vat', APL[I].VAT);
        CkJsonObject_UpdateInt(JO, 'payment[i].inst_mon', APL[I].InstallMonth);
        CkJsonObject_UpdateInt(JO, 'payment[i].cash_entity_div', APL[I].CashEntity);
        CkJsonObject_UpdateString(JO, 'payment[i].card_no', PWideChar(APL[I].CardNo));
        CkJsonObject_UpdateString(JO, 'payment[i].trade_no', PWideChar(APL[I].TradeNo));
        CkJsonObject_UpdateString(JO, 'payment[i].trade_dt', PWideChar(APL[I].TradeDate));
        CkJsonObject_UpdateString(JO, 'payment[i].card_issuer_cd', PWideChar(APL[I].IssuerCode));
        CkJsonObject_UpdateString(JO, 'payment[i].card_issuer_nm', PWideChar(APL[I].ISsuerName));
        CkJsonObject_UpdateString(JO, 'payment[i].card_acquir_div', PWideChar(APL[I].BuyerDiv));
        CkJsonObject_UpdateString(JO, 'payment[i].card_acquir_cd', PWideChar(APL[I].BuyerCode));
        CkJsonObject_UpdateString(JO, 'payment[i].card_acquir_nm', PWideChar(APL[I].BuyerName));
      end;

      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostMember(const ANewMember: Boolean; const AMemberRec: TMemberInfoRec; var AResMsg: string): Boolean;
var
  JO: HCkJsonObject;
  JA: HCkJsonArray;
  LApi, LReqJson, LRespJson, LEncPhoto, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  JA := nil;
  try
    try
      if Assigned(AMemberRec.PhotoStream) then
      begin
        AMemberRec.PhotoStream.Position := 0;
        LEncPhoto := Base64EncodeStream(AMemberRec.PhotoStream);
      end;
      if ANewMember then
      begin
        LApi := 'C003_regMember';
        CkJsonObject_UpdateString(JO, 'join_root', PWideChar('POS'));
      end
      else
      begin
        LApi := 'C004_chgMember';
        CkJsonObject_UpdateString(JO, 'member_no', PWideChar(AMemberRec.MemberNo));
      end;
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateString(JO, 'member_nm', PWideChar(AMemberRec.MemberName));
      CkJsonObject_UpdateInt(JO, 'club_seq', AMemberRec.ClubSeq);
      CkJsonObject_UpdateString(JO, 'member_div', PWideChar(AMemberRec.MemberDiv));
      CkJsonObject_UpdateString(JO, 'member_group_code', PWideChar(AMemberRec.MemberGroupCode));
      CkJsonObject_UpdateInt(JO, 'sex_div', AMemberRec.SexDiv);
      CkJsonObject_UpdateString(JO, 'birthday', PWideChar(AMemberRec.Birthday));
      CkJsonObject_UpdateString(JO, 'mobile_no', PWideChar(AMemberRec.TelNo));
      CkJsonObject_UpdateString(JO, 'car_no', PWideChar(AMemberRec.CarNo));
      CkJsonObject_UpdateString(JO, 'email', PWideChar(AMemberRec.Email));
      CkJsonObject_UpdateString(JO, 'zipno', PWideChar(AMemberRec.ZipNo));
      CkJsonObject_UpdateString(JO, 'addr', PWideChar(AMemberRec.Addr));
      CkJsonObject_UpdateString(JO, 'addr2', PWideChar(AMemberRec.Addr2));
      CkJsonObject_UpdateInt(JO, 'save_point', AMemberRec.SavePoint);
      CkJsonObject_UpdateString(JO, 'advertise_agreement_yn', PWideChar(IfThen(AMemberRec.AdAgree, CO_RESULT_YES, CO_RESULT_NO)));
      CkJsonObject_UpdateString(JO, 'fingerprint_hash', PWideChar(AMemberRec.FPHash));
      CkJsonObject_UpdateString(JO, 'photo_encoding', PWideChar(LEncPhoto));
      CkJsonObject_UpdateString(JO, 'memo', PWideChar(AMemberRec.MemberMemo));
      CkJsonObject_UpdateString(JO, 'reg_id', PWideChar(Global.UserInfo.UserId));
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(LApi, LApi, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [LApi, E.Message]));
      end;
    end;
  finally
    if Assigned(JA) then
      CkJsonArray_Dispose(JA);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostLockerClose(const ALockerNo: SmallInt; var AResMsg: string): Boolean;
const
  CS_API = 'F002_closeLocker';
var
  JO: HCkJsonObject;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  try
    try
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateInt(JO, 'locker_no', ALockerNo);
      CkJsonObject_UpdateString(JO, 'chg_id', PWideChar(Global.UserInfo.UserId));
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, CS_API, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostSystemSetting(var AResMsg: string): Boolean;
const
  CS_API = 'B102_chgTerminalConfig';
var
  JO: HCkJsonObject;
  SL: TStringList;
  LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  LRespJson := '';
  JO := CkJsonObject_Create;
  SL := TStringList.Create;
  try
    try
      SL.LoadFromFile(Global.Setting.System.FileName);
      CkJsonObject_UpdateString(JO, 'terminal_id', PWideChar(Global.PartnerCenter.TerminalId));
      CkJsonObject_UpdateString(JO, 'config', PWideChar(SL.Text));
      CkJsonObject_UpdateString(JO, 'macro', PWideChar(''));
      CkJsonObject_UpdateString(JO, 'chg_id', PWideChar(Global.UserInfo.UserId));
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, CS_API, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    FreeAndNil(SL);
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostCancelPayment(APL: TArray<TPaymentItemRec>; const AReceiptNo, AOrgReceiptNo: string; var AResMsg: string): Boolean;
const
  CS_API = 'G002_refundSales';
var
  JO: HCkJsonObject;
  LUri, LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateInt(JO, 'pos_no', Global.TerminalInfo.PosNo);
      CkJsonObject_UpdateString(JO, 'receipt_no', PWideChar(AReceiptNo));
      CkJsonObject_UpdateString(JO, 'org_receipt_no', PWideChar(AOrgReceiptNo));
      CkJsonObject_UpdateString(JO, 'reg_id', PWideChar(Global.UserInfo.UserId));
      CkJsonObject_UpdateNewArray(JO, 'payment');
      for var I: ShortInt := 0 to High(APL) do
      begin
        CkJsonObject_putI(JO, I);
        CkJsonObject_UpdateInt(JO, 'payment[i].pay_method_div', APL[I].PayMethod);
        CkJsonObject_UpdateString(JO, 'payment[i].cancel_yn', PWideChar(CO_RESULT_YES));
        CkJsonObject_UpdateString(JO, 'payment[i].manual_yn', PWideChar(IfThen(APL[I].IsManualInput, CO_RESULT_YES, CO_RESULT_NO)));
        CkJsonObject_UpdateString(JO, 'payment[i].van_cd', PWideChar(APL[I].VanCode));
        CkJsonObject_UpdateString(JO, 'payment[i].tid', PWideChar(APL[I].TID));
        CkJsonObject_UpdateString(JO, 'payment[i].approve_no', PWideChar(APL[I].ApproveNo));
        CkJsonObject_UpdateString(JO, 'payment[i].org_approve_no', PWideChar(APL[I].OrgApproveNo));
        CkJsonObject_UpdateInt(JO, 'payment[i].approve_amt', APL[I].ApproveAmt);
        CkJsonObject_UpdateInt(JO, 'payment[i].vat', APL[I].VAT);
        CkJsonObject_UpdateInt(JO, 'payment[i].inst_month', APL[I].InstallMonth);
        CkJsonObject_UpdateString(JO, 'payment[i].trade_no', PWideChar(APL[I].TradeNo));
        CkJsonObject_UpdateString(JO, 'payment[i].trade_dt', PWideChar(APL[I].TradeDate));
        CkJsonObject_UpdateString(JO, 'payment[i].card_no', PWideChar(APL[I].CardNo));
        CkJsonObject_UpdateString(JO, 'payment[i].card_issuer_cd', PWideChar(APL[I].IssuerCode));
        CkJsonObject_UpdateString(JO, 'payment[i].card_issuer_nm', PWideChar(APL[I].IssuerName));
        CkJsonObject_UpdateString(JO, 'payment[i].card_acquir_div', PWideChar(APL[I].BuyerDiv));
        CkJsonObject_UpdateString(JO, 'payment[i].card_acquir_cd', PWideChar(APL[I].BuyerCode));
        CkJsonObject_UpdateString(JO, 'payment[i].card_acquir_nm', PWideChar(APL[I].BuyerName));
      end;
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostCancelPaymentPartial(APR: TPaymentItemRec; const ANewApproveNo: string; var AResMsg: string): Boolean;
const
  CS_API = 'G007_cancelPayment';
var
  JO: HCkJsonObject;
  LUri, LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateString(JO, 'receipt_no', PWideChar(APR.ReceiptNo));
      CkJsonObject_UpdateInt(JO, 'pay_seq', APR.PaySeq);
      CkJsonObject_UpdateInt(JO, 'pay_method_div', APR.PayMethod);
      CkJsonObject_UpdateString(JO, 'card_no', PWideChar(APR.CardNo));
      CkJsonObject_UpdateString(JO, 'approve_no', PWideChar(ANewApproveNo));
      CkJsonObject_UpdateString(JO, 'org_approve_no', PWideChar(APR.ApproveNo));
      CkJsonObject_UpdateString(JO, 'memo', PWideChar(APR.PaymentMemo));
      CkJsonObject_UpdateString(JO, 'reg_id', PWideChar(Global.UserInfo.UserId));
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostUpdateCashPayment(APR: TPaymentItemRec; var AResMsg: string): Boolean;
const
  CS_API = 'G008_updateCashPayment';
var
  JO: HCkJsonObject;
  LUri, LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateString(JO, 'receipt_no', PWideChar(APR.ReceiptNo));
      CkJsonObject_UpdateInt(JO, 'pay_seq', APR.PaySeq);
      CkJsonObject_UpdateString(JO, 'manual_yn', PWideChar(IfThen(APR.IsManualInput, CO_RESULT_YES, CO_RESULT_NO)));
      CkJsonObject_UpdateString(JO, 'card_no', PWideChar(APR.CardNo));
      CkJsonObject_UpdateString(JO, 'approve_no', PWideChar(APR.ApproveNo));
      CkJsonObject_UpdateInt(JO, 'cash_entity_div', APR.CashEntity);
      CkJsonObject_UpdateString(JO, 'reg_id', PWideChar(Global.UserInfo.UserId));
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

function TBPDM.PostRallySetting(const RR: TRallyInfoRec; var AResMsg: string): Boolean;
const
  CS_API = 'E303_chgCompetition';
var
  JO: HCkJsonObject;
  LUri, LReqJson, LRespJson, LResCode: string;
begin
  Result := False;
  AResMsg := '';
  JO := CkJsonObject_Create;
  try
    try
      LUri := Format('%s?store_cd=%s', [CS_API, Global.StoreInfo.StoreCode]);
      CkJsonObject_UpdateString(JO, 'store_cd', PWideChar(Global.StoreInfo.StoreCode));
      CkJsonObject_UpdateInt(JO, 'competition_seq', RR.RallySeq);
      CkJsonObject_UpdateString(JO, 'competition_nm', PWideChar(RR.RallyName));
      CkJsonObject_UpdateString(JO, 'league_yn', PWideChar(IfThen(RR.LeagueMode, CO_RESULT_YES, CO_RESULT_NO)));
      CkJsonObject_UpdateString(JO, 'move_method', PWideChar(RR.ShiftMethod));
      CkJsonObject_UpdateInt(JO, 'lane_move_cnt', RR.ShiftCount);
      CkJsonObject_UpdateString(JO, 'rank_nohandy_yn', PWideChar(IfThen(RR.RankNoHandy, CO_RESULT_YES, CO_RESULT_NO)));
      CkJsonObject_UpdateString(JO, 'rank_highlow_yn', PWideChar(IfThen(RR.RankHighLow, CO_RESULT_YES, CO_RESULT_NO)));
      CkJsonObject_UpdateString(JO, 'rank_birth_yn', PWideChar(IfThen(RR.RankBirth, CO_RESULT_YES, CO_RESULT_NO)));
      CkJsonObject_UpdateString(JO, 'user_id', PWideChar(Global.UserInfo.UserId));
      CkJsonObject_UpdateString(JO, 'team_yn', PWideChar(IfThen(RR.TeamMode, CO_RESULT_YES, CO_RESULT_NO)));
      LReqJson := CkJsonObject__emit(JO);
      if not RequestToPartnerCenter(CS_API, LUri, Id_HTTPMethodPost, LReqJson, LRespJson, AResMsg) then
        raise Exception.Create(AResMsg);
      if not CkJsonObject_Load(JO, PWideChar(LRespJson)) then
        raise Exception.Create(CkJsonObject__lastErrorText(JO));

      LResCode := CkJsonObject__stringOf(JO, 'result_cd');
      AResMsg := CkJsonObject__stringOf(JO, 'result_msg');
      if (LResCode <> CO_RESULT_SUCCESS) then
        raise Exception.Create(Format('파트너센터 Error #%s, %s', [LResCode, AResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('%s.Exception = %s', [CS_API, E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
  end;
end;

procedure TBPDM.QRAssignListAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_rally_yn', fkCalculated, ftBoolean, 0);
    CreateField(DataSet, 'calc_lane_no', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_bowler_nm', fkCalculated, ftString, 50);
    CreateField(DataSet, 'calc_game_div', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_assign_status', fkCalculated, ftString, 20);
    CreateField(DataSet, 'calc_receipt_no', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_assign_root_div', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_payment_type', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_fee_div', fkCalculated, ftString, 10);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRAssignListCalcFields(DataSet: TDataSet);
var
  LGameDiv, LAssignIndex, LAssignStatus, LPaymentType: ShortInt;
  LAssighRootDiv, LFeeDiv, LValue: string;
begin
  with DataSet do
  begin
    if (RecordCount = 0) then
      Exit;

    FieldValues['calc_rally_yn'] := (FieldByName('rally_seq').AsInteger > 0);
    FieldValues['calc_lane_no'] := Format('%d (%d)', [FieldByName('lane_no').AsInteger, FieldByName('assign_lane_no').AsInteger]);
    FieldValues['calc_bowler_nm'] := Format('[%s] %s', [FieldByName('bowler_id').AsString, FieldByName('bowler_nm').AsString]);

    LGameDiv := FieldByName('game_div').AsInteger;
    case LGameDiv of
      CO_RATEPLAN_GAME: LValue := '게임제';
      CO_RATEPLAN_TIME: LValue := '시간제';
    else
      LValue := LGameDiv.ToString;
    end;
    FieldValues['calc_game_div'] := LValue;

    LAssignStatus := FieldByName('assign_status').AsInteger;
    LAssignIndex := FieldByName('assign_index').AsInteger;
    case LAssignStatus of
      CO_LANE_READY: LValue := '대기';
      CO_LANE_RESERVED: LValue := Format('예약 %d', [LAssignindex]);
      CO_LANE_HOLD: LValue := '홀드';
      CO_LANE_BUSY: LValue := Format('진행(F-%d)', [FieldByName('frame_no').AsInteger]);
      CO_LANE_END_UNPAID: LValue := '미결제';
      CO_LANE_END: LValue := '종료';
      CO_LANE_CANCEL: LValue := '예약취소';
      CO_LANE_MAINTENANCE: LValue := '점검중';
    else
      LValue := LAssignStatus.ToString;
    end;
    FieldValues['calc_assign_status'] := LValue;
    LValue := FieldByName('receipt_no').AsString.SubString(14);
    FieldValues['calc_receipt_no'] := Format('%d%s', [Succ(LAssignIndex), IfThen(LValue.IsEmpty, '', ':' + LValue)]);

    LPaymentType := FieldByName('payment_type').AsInteger;
    case LPaymentType of
      CO_PAYTYPE_DEFERRED: LValue := '후불';
      CO_PAYTYPE_PREPAID: LValue := '선불';
    else
      LValue := LPaymentType.ToString;
    end;
    FieldValues['calc_payment_type'] := LValue;

    LFeeDiv := FieldByName('fee_div').AsString;
    if (LFeeDiv = CO_GAMEFEE_BASIC) then
      LValue := '일반'
    else if (LFeeDiv = CO_GAMEFEE_MEMBER) then
      LValue := '회원'
    else if (LFeeDiv = CO_GAMEFEE_STUDENT) then
      LValue := '학생'
    else if (LFeeDiv = CO_GAMEFEE_CLUB) then
      LValue := '클럽'
    else
      LValue := LFeeDiv;
    FieldValues['calc_fee_div'] := LValue;

    LAssighRootDiv := FieldByName('assign_root_div').AsString;
    if (LAssighRootDiv = CO_CLIENT_KIOSK) then
      LValue := '키오스크'
    else if (LAssighRootDiv = CO_CLIENT_POS) then
      LValue := '프런트POS'
    else if (LAssighRootDiv = CO_CLIENT_MOBILE) then
      LValue := '모바일'
    else
      LValue := LAssighRootDiv;
    FieldValues['calc_assign_root_div'] := LValue;
  end;
end;

procedure TBPDM.QRMemberListAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_tel_no', fkCalculated, ftString, 20);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRMemberListCalcFields(DataSet: TDataSet);
var
  LValue: string;
begin
  LValue := DataSet.FieldByName('tel_no').AsString;
  if not LValue.IsEmpty then
  begin
    LValue := StringReplace(LValue, '-', '', [rfReplaceAll]);
    DataSet.FieldValues['calc_tel_no'] := LValue.Substring(0, 3) + '-' + LValue.Substring(3, 4) + '-' + LValue.Substring(7, 4);
  end;
end;

procedure TBPDM.QRMemberLockerAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_locker_zone_code', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_locker_layer_code', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_locker_status', fkCalculated, ftString, 10);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRMemberLockerCalcFields(DataSet: TDataSet);
var
  LSValue: string;
  LIValue: Integer;
begin
  with DataSet do
  begin
    LSValue := FieldByName('locker_zone_code').AsString;
    if (LSValue = CO_LOCKER_ZONE_PASSAGE) then
      FieldValues['calc_locker_zone_code'] := '복도'
    else
      FieldValues['calc_locker_zone_code'] := LSValue;

    LSValue := FieldByName('locker_layer_code').AsString;
    if (LSValue = CO_LOCKER_LAYER_UPPER) then
      FieldValues['calc_locker_layer_code'] := '상단'
    else if (LSValue = CO_LOCKER_LAYER_LOWER) then
      FieldValues['calc_locker_layer_code'] := '하단'
    else
      FieldValues['calc_locker_layer_code'] := LSValue;

    LIValue := FieldByName('locker_status').AsInteger;
    case LIValue of
      CO_LOCKER_EMPTY:
        FieldValues['calc_locker_status'] := '비어있음';
      CO_LOCKER_INUSE:
        FieldValues['calc_locker_status'] := '이용중';
      CO_LOCKER_EXPIRED:
        FieldValues['calc_locker_status'] := '만기';
      CO_LOCKER_DISABLED:
        FieldValues['calc_locker_status'] := '이용불가';
      else
        FieldValues['calc_locker_status'] := LIValue.ToString;
    end;
  end;
end;

procedure TBPDM.QRMembershipAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_game_div', fkCalculated, ftString, 20);
    CreateField(DataSet, 'calc_purchase', fkCalculated, ftString, 20);
    CreateField(DataSet, 'calc_remain', fkCalculated, ftString, 20);
    CreateField(DataSet, 'calc_use_status', fkCalculated, ftString, 20);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRMembershipCalcFields(DataSet: TDataSet);
var
  LIValue: Integer;
begin
  with DataSet do
  begin
    LIValue := FieldByName('game_div').AsInteger;
    case LIValue of
      CO_RATEPLAN_GAME:
        begin
          FieldValues['calc_game_div'] := '게임제';
          FieldValues['calc_purchase'] := Format('%d 게임', [FieldByName('purchase_game_cnt').AsInteger]);
          FieldValues['calc_remain'] := Format('%d 게임', [FieldByName('remain_game_cnt').AsInteger]);
        end;
      CO_RATEPLAN_TIME:
        begin
          FieldValues['calc_game_div'] := '시간제';
          FieldValues['calc_purchase'] := Format('%d 분', [FieldByName('purchase_game_min').AsInteger]);
          FieldValues['calc_remain'] := Format('%d 분', [FieldByName('remain_game_min').AsInteger]);
        end;
      CO_RATEPLAN_VIP:
        begin
          FieldValues['calc_game_div'] := '우대권';
          FieldValues['calc_purchase'] := Format('%s', [IfThen(FieldByName('shoes_free_yn').AsBoolean, '대화료 무료', '')]);
          FieldValues['calc_remain'] := Format('%d％ 적립', [FieldByName('save_point_rate').AsInteger]);
        end;
      else
        FieldValues['calc_game_div'] := LIvalue.ToString;
    end;

    LIValue := FieldByName('use_status').AsInteger;
    case LIValue of
      CO_STATUS_INUSE:
        FieldValues['calc_use_status'] := '이용중';
      CO_STATUS_CLOSE:
        FieldValues['calc_use_status'] := '만료';
      CO_STATUS_RECESS:
        FieldValues['calc_use_status'] := '휴회';
      CO_STATUS_BEFORE:
        FieldValues['calc_use_status'] := '이용전';
      else
        FieldValues['calc_use_status'] := LIvalue.ToString;
    end;
  end;
end;

procedure TBPDM.QRRallyListAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_reg_date', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_move_method', fkCalculated, ftString, 10);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRRallyListCalcFields(DataSet: TDataSet);
var
  LSValue: string;
begin
  with DataSet do
  begin
    LSValue := FieldByName('move_method').AsString;
    FieldValues['calc_move_method'] := LSValue;
    for var I: Shortint := 0 to High(CO_TABLE_SHIFT_LIST) do
      if (LSValue = CO_TABLE_SHIFT_LIST[I].Code) then
      begin
        FieldValues['calc_move_method'] := CO_TABLE_SHIFT_LIST[I].Caption;
        Break;
      end;
    FieldValues['calc_reg_date'] := FieldByName('reg_datetime').AsString.Substring(0, 10);
  end;
end;

procedure TBPDM.QRReceiptListAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_cancel_yn', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_sale_root_div', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_dc_amt', fkCalculated, ftInteger, 0);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRReceiptListCalcFields(DataSet: TDataSet);
var
  LSValue: string;
  LBValue: Boolean;
begin
  with DataSet do
  begin
    LBValue := FieldByName('cancel_yn').AsBoolean;
    FieldValues['calc_cancel_yn']:= IfThen(LBValue, '취소', '승인');
    if LBValue then
      FieldValues['calc_dc_amt'] := 0
    else
      FieldValues['calc_dc_amt'] := (FieldByName('dc_amt').AsInteger + FieldByName('coupon_dc_amt').AsInteger);

    LSValue := FieldByName('sale_root_div').AsString;
    if (LSValue = CO_CLIENT_POS) then
    begin
      if (Global.TerminalInfo.SaleZoneCode = CO_SALEZONE_POS_FRONT) then
        FieldValues['calc_sale_root_div'] := '프런트'
      else
        FieldValues['calc_sale_root_div'] := '일반'
    end
    else if (LSValue = CO_CLIENT_KIOSK) then
      FieldValues['calc_sale_root_div'] := '키오스크'
    else if (LSValue = CO_CLIENT_MOBILE) then
      FieldValues['calc_sale_root_div'] := '모바일'
    else
      FieldValues['calc_sale_root_div'] := LSValue;
  end;
end;

procedure TBPDM.QRSaleItemAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_assign_lane_no', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_prod_div', fkCalculated, ftString, 20);
    CreateField(DataSet, 'calc_sale_amt', fkCalculated, ftInteger, 0);
    CreateField(DataSet, 'calc_charge_amt', fkCalculated, ftInteger, 0);
    CreateField(DataSet, 'calc_vat', fkCalculated, ftInteger, 0);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRSaleItemCalcFields(DataSet: TDataSet);
var
  LProdDiv, LDetailDiv, LProdDivName: string;
  LAssignLaneNo, LSaleAmt, LChargeAmt: Integer;
begin
  with DataSet do
  begin
    if (RecordCount = 0) then
      Exit;
    LAssignLaneNo := FieldByName('assign_lane_no').AsInteger;
    FieldValues['calc_assign_lane_no'] := IfThen(LAssignLaneNo = 0, '일반', LAssignLaneNo.ToString);
    LProdDiv := FieldByName('prod_div').AsString;
    LDetailDiv := FieldByName('prod_detail_div').AsString;
    if (LProdDiv = CO_PROD_GAME) then
    begin
      if (LDetailDiv = CO_PROD_DETAIL_GAME_COUNT) then
        LProdDivName := '게임요금제'
      else if (LDetailDiv = CO_PROD_DETAIL_GAME_MIN) then
        LProdDivName := '시간요금제'
      else
        LProdDivName := Format('%s-%s', [LProdDiv, LDetailDiv]);
    end
    else if (LProdDiv = CO_PROD_LOCKER) then
    begin
      if (LDetailDiv = CO_PROD_DETAIL_LOCKER) then
        LProdDivName := '라커이용료'
      else if (LDetailDiv = CO_PROD_DETAIL_KEEPAMT) then
        LProdDivName := '라커보증금'
      else
        LProdDivName := Format('%s-%s', [LProdDiv, LDetailDiv]);
    end
    else if (LProdDiv = CO_PROD_RENT) then
      LProdDivName := '대여'
    else if (LProdDiv = CO_PROD_GENERAL) then
      LProdDivName := '일반'
    else if (LProdDiv = CO_PROD_MEMBERSHIP) then
    begin
      if (LDetailDiv = CO_PROD_DETAIL_MEMBER_GAME) then
        LProdDivName := '게임제회원권'
      else if (LDetailDiv = CO_PROD_DETAIL_MEMBER_TIME) then
        LProdDivName := '시간제회원권'
      else if (LDetailDiv = CO_PROD_DETAIL_MEMBER_VIP) then
        LProdDivName := '우대회원권'
      else
        LProdDivName := Format('%s-%s', [LProdDiv, LDetailDiv]);
    end
    else
      LProdDivName := Format('%s-%s', [LProdDiv, LDetailDiv]);

    FieldValues['calc_prod_div'] := LProdDivName;
    LSaleAmt   := (FieldByName('prod_amt').AsInteger * FieldByName('order_qty').AsInteger);
    LChargeAmt := (LSaleAmt - (FieldByName('dc_amt').AsInteger + FieldByName('use_point').AsInteger));
    FieldValues['calc_sale_amt']   := LSaleAmt;
    FieldValues['calc_charge_amt'] := LChargeAmt;
    FieldValues['calc_vat']        := (LChargeAmt - Trunc(LChargeAmt / 1.1));
  end;
end;

procedure TBPDM.QRPaymentListAfterOpen(DataSet: TDataSet);
begin
  DataSet.Close;
  try
    for var I: ShortInt := 0 to Pred(DataSet.FieldDefs.Count) do
      DataSet.FieldDefs[I].CreateField(DataSet);
    CreateField(DataSet, 'calc_approval_yn', fkCalculated, ftString, 10);
    CreateField(DataSet, 'calc_cancel_count', fkCalculated, ftInteger, 0);
    CreateField(DataSet, 'calc_pay_method', fkCalculated, ftString, 20);
  finally
    DataSet.AfterOpen := nil;
    DataSet.Open;
  end;
end;

procedure TBPDM.QRPaymentListCalcFields(DataSet: TDataSet);
var
  LIValue: Integer;
begin
  with DataSet do
  begin
    if FieldByName('approval_yn').AsBoolean then
    begin
      FieldValues['calc_approval_yn'] := '결제';
      FieldValues['calc_cancel_count'] := 0;
    end else
    begin
      FieldValues['calc_approval_yn'] := '환불';
      FieldValues['calc_cancel_count'] := 1;
    end;

    LIValue := FieldByName('pay_method').AsInteger;
    case LIValue of
      CO_PAYMENT_CARD:
        FieldValues['calc_pay_method'] := '카드';
      CO_PAYMENT_CASH:
        if FieldByName('card_no').AsString.IsEmpty then
          FieldValues['calc_pay_method'] := '현금'
        else
          FieldValues['calc_pay_method'] := '현금영수증';
      CO_PAYMENT_PAYCO_CARD:
        FieldValues['calc_pay_method'] := 'PAYCO(카드)';
      CO_PAYMENT_PAYCO_COUPON:
        FieldValues['calc_pay_method'] := 'PAYCO(쿠폰)';
      CO_PAYMENT_PAYCO_POINT:
        FieldValues['calc_pay_method'] := 'PAYCO(포인트)';
    else
      FieldValues['calc_pay_method'] := LIValue.ToString;
    end;
  end;
end;

function TBPDM.OpenProdDataSet(const AGameDiv: ShortInt; const AProdDiv, ADetailDiv, AFeeDiv: string; const AMembershipOnly, ATodaySaleOnly: Boolean; var AResMsg: string): Boolean;
var
  LTableName: string;
begin
  Result := True;
  AResMsg := '';
  try
    if (AProdDiv = CO_PROD_GAME) or
       (AProdDiv = CO_PROD_MEMBERSHIP) then
    begin
      with QRProdGame do
      try
        LTableName := 'MTProdGame';
        DisableControls;
        Close;
        SQL.Clear;
        SQL.Add(Format('SELECT A.* FROM MEMORY %s A', [LTableName]));
        SQL.Add(Format('WHERE A.membership_yn = %s', [BoolToStr(AMembershipOnly, True)]));
        if not ADetailDiv.IsEmpty then
          SQL.Add(Format('AND A.prod_detail_div = %s', [ADetailDiv.QuotedString]));
        if not AFeeDiv.IsEmpty then
          SQL.Add(Format('AND A.fee_div = %s', [AFeeDiv.QuotedString]));
        if not AMembershipOnly then
          SQL.Add(Format('AND A.game_div = %d', [AGameDiv]));
        SQL.Add(Format('AND A.today_yn = %s', [BoolToStr(ATodaySaleOnly, True)]));
        SQL.Add('ORDER BY A.sort_ord;');
{$IFDEF DEBUG}
        SQL.SaveToFile(Global.DirInfo.LogDir + Format('%s.sql', [LTableName]));
{$ENDIF}
        Prepared := True;
        Open;
        UpdateLog(Format('OpenProdDataSet(%s).RecordCount = %d', [LTableName, RecordCount]));
      finally
        EnableControls;
      end;
    end
    else if (AProdDiv = CO_PROD_LOCKER) then
    begin
      with QRProdLocker do
      try
        LTableName := 'MTProdLocker';
        DisableControls;
        Close;
        SQL.Clear;
        Prepared := True;
        Open;
      finally
        EnableControls;
      end;
    end
    else if (AProdDiv = CO_PROD_GENERAL) then
    begin
      with QRProdGeneral do
      try
        LTableName := 'MTProdGeneral';
        DisableControls;
        Close;
        SQL.Clear;
        Prepared := True;
        Open;
      finally
        EnableControls;
      end;
    end
    else if (AProdDiv = CO_PROD_RENT) then
    begin
      with QRProdRent do
      try
        LTableName := 'MTProdRent';
        DisableControls;
        Close;
        SQL.Clear;
        Prepared := True;
        Open;
      finally
        EnableControls;
      end;
    end
    else
      raise Exception.Create(Format('%s은(는) 알 수 없는 상품 구분코드입니다.', [AProdDiv.QuotedString]));
  except
    on E: Exception do
    begin
      Result := False;
      AResMsg := E.Message;
      UpdateLog(Format('OpenProdDataSet(%s).Exeception = %s', [LTableName, AResMsg]));
    end;
  end;
end;

function TBPDM.AddPending(const AAssignLaneList: string; var AResMsg: string): Boolean;
var
  LFields: TArray<TFieldInfoRec>;
  LTableName, LReceiptNo, LSQL, LUpdateTime: string;
begin
  Result := False;
  AResMsg := '';
  LReceiptNo := GetNewReceiptNo;
  LUpdateTime := Global.DateTime.FormattedCurrentDateTime;
  with TABSQuery.Create(nil) do
  try
    DatabaseName := LocalDB.DatabaseName;
    try
//      LTableName := 'TBReceipt';
//      SetLength(LFields, 0);
//      AddFieldInfo(LFields, 'receipt_no', varString, LReceiptNo);
//      AddFieldInfo(LFields, 'pos_no', varInteger, Global.TerminalInfo.PosNo);
//      AddFieldInfo(LFields, 'sale_root_div', varString, CO_CLIENT_POS);
//      AddFieldInfo(LFields, 'sale_dt', varString, Global.DateTime.FormattedCurrentDate);
//      AddFieldInfo(LFields, 'sale_tm', varString, Global.DateTime.FormattedCurrentTime);
//      AddFieldInfo(LFields, 'cancel_yn', varBoolean, False);
//      AddFieldInfo(LFields, 'sale_amt', varInteger, Global.ReceiptInfo.SaleAmt);
//      AddFieldInfo(LFields, 'charge_amt', varInteger, Global.ReceiptInfo.ChargeAmt);
//      AddFieldInfo(LFields, 'coupon_dc_amt', varInteger, Global.ReceiptInfo.CouponAmt);
//      AddFieldInfo(LFields, 'dc_amt', varInteger, Global.ReceiptInfo.DCAmt);
//      AddFieldInfo(LFields, 'change_amt', varInteger, Global.ReceiptInfo.ChangeAmt);
//      AddFieldInfo(LFields, 'keep_amt', varInteger, Global.ReceiptInfo.KeepAmt);
//      AddFieldInfo(LFields, 'user_id', varString, Global.UserInfo.UserId);
//      AddFieldInfo(LFields, 'sale_memo', varString, Global.ReceiptInfo.SaleMemo);
//      AddFieldInfo(LFields, 'update_dttm', varString, LUpdateTime);
//      if not MakeInsertSQL(LTableName, LFields, LSQL) then
//        raise Exception.Create(Format('MakeInsertSQL(%s).ErrorCode: %d', [LTableName, GetLastError]));
//      SQL.Text := LSQL;
//      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add(Format('UPDATE TBSaleItem SET receipt_no = %s, user_id = %s, update_dttm = %s WHERE assign_lane_no IN (%s);',
                [LReceiptNo.QuotedString, Global.UserInfo.UserId.QuotedString, LUpdateTime.QuotedString, AAssignLaneList]));
      SQL.Add(Format('UPDATE TBPayment SET receipt_no = %s, user_id = %s, update_dttm = %s WHERE assign_lane_no IN (%s);',
                [LReceiptNo.QuotedString, Global.UserInfo.UserId.QuotedString, LUpdateTime.QuotedString, AAssignLaneList]));
      SQL.Add(Format('UPDATE TBCoupon SET receipt_no = %s, user_id = %s, update_dttm = %s  WHERE assign_lane_no IN (%s);',
                [LReceiptNo.QuotedString, Global.UserInfo.UserId.QuotedString, LUpdateTime.QuotedString, AAssignLaneList]));
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add(Format('INSERT INTO TBReceiptPend (SELECT * FROM TBReceipt WHERE receipt_no = %s);', [LReceiptNo.QuotedString]));
      SQL.Add(Format('INSERT INTO TBSaleItemPend (SELECT * FROM TBSaleItem WHERE receipt_no = %s);', [LReceiptNo.QuotedString]));
      SQL.Add(Format('INSERT INTO TBPaymentPend (SELECT * FROM TBPayment WHERE receipt_no = %s);', [LReceiptNo.QuotedString]));
      SQL.Add(Format('INSERT INTO TBCouponPend (SELECT * FROM TBCoupon WHERE receipt_no = %s);', [LReceiptNo.QuotedString]));
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add(Format('DELETE FROM TBReceipt WHERE receipt_no = %s;', [LReceiptNo.QuotedString]));
      SQL.Add(Format('DELETE FROM TBSaleItem WHERE receipt_no = %s;', [LReceiptNo.QuotedString]));
      SQL.Add(Format('DELETE FROM TBPayment WHERE receipt_no = %s;', [LReceiptNo.QuotedString]));
      SQL.Add(Format('DELETE FROM TBCoupon WHERE receipt_no = %s;', [LReceiptNo.QuotedString]));
      ExecSQL;

      Result := True;
      UpdateLog(Format('AddPending(%s).Success = 보류 등록', [LReceiptNo]));
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('AddPending(%s).Exception = %s', [LReceiptNo, AResMsg]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;

function TBPDM.DeletePending(const AReceiptNo: string; var AResMsg: string): Boolean;
var
  SL: TStringList;
begin
  Result := False;
  AResMsg := '';
  SL := TStringList.Create;
  with TABSQuery.Create(nil) do
  try
    DatabaseName := LocalDB.DatabaseName;
    try
      Close;
      SQL.Clear;
      SQL.Text := Format('SELECT * FROM TBPaymentPend WHERE receipt_no = %s;', [AReceiptNo.QuotedString]);
      Open;
      while not Eof do
      begin
        SL.Add(Format('DeletePending.TBPaymentPend(%s) = approval_yn: %s, pay_method: %d, trade_dt: %s, manual_input_yn: %s, card_no: %s, issuer_nm: %s, approve_no: %s, org_approve_no: %s, approve_amt: %d, update_dttm: %s)',
          [ FieldByName('receipt_no').AsString,
            BoolToStr(FieldByName('approval_yn').AsBoolean, True),
            FieldByName('pay_method').AsInteger,
            FieldByName('trade_dt').AsString,
            BoolToStr(FieldByName('manual_input_yn').AsBoolean, True),
            FieldByName('card_no').AsString,
            FieldByName('issuer_nm').AsString,
            FieldByName('approve_no').AsString,
            FieldByName('org_approve_no').AsString,
            FieldByName('approve_amt').AsInteger,
            FormatDateTime('yyyy-mm-dd hh:nn:ss', FieldByName('update_dttm').AsDateTime)]));
        Next;
      end;
      for var I: ShortInt := 0 to Pred(SL.Count) do
        UpdateLog(SL[I]);

      Close;
      SQL.Clear;
      SQL.Add(Format('DELETE FROM TBCouponPend WHERE receipt_no = %s;', [AReceiptNo.QuotedString]));
      SQL.Add(Format('DELETE FROM TBPaymentPend WHERE receipt_no = %s;', [AReceiptNo.QuotedString]));
      SQL.Add(Format('DELETE FROM TBSaleItemPend WHERE receipt_no = %s;', [AReceiptNo.QuotedString]));
      SQL.Add(Format('DELETE FROM TBReceiptPend WHERE receipt_no = %s;', [AReceiptNo.QuotedString]));
      ExecSQL;
      UpdateLog(Format('DeletePending(%s).Success = 보류내역 삭제', [AReceiptNo]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('DeletePending(%s).Exception = %s', [AReceiptNo, AResMsg]));
      end;
    end;
  finally
    FreeAndNil(SL);
    Close;
    Free;
  end;
end;

function TBPDM.LoadPending(const AReceiptNo: string; var AResMsg: string): Boolean;
begin
  Result := False;
  AResMsg := '';
  with TABSQuery.Create(nil) do
  try
    try
      DatabaseName := LocalDB.DatabaseName;
      SQL.Add(Format('INSERT INTO TBReceipt (SELECT * FROM TBReceiptPend WHERE receipt_no = %s);', [AReceiptNo.QuotedString]));
      SQL.Add(Format('INSERT INTO TBSaleItem (SELECT * FROM TBSaleItemPend WHERE receipt_no = %s);', [AReceiptNo.QuotedString]));
      SQL.Add(Format('INSERT INTO TBPayment (SELECT * FROM TBPaymentPend WHERE receipt_no = %s);', [AReceiptNo.QuotedString]));
      SQL.Add(Format('INSERT INTO TBCoupon (SELECT * FROM TBCouponPend WHERE receipt_no = %s);', [AReceiptNo.QuotedString]));
      ExecSQL;
      UpdateLog(Format('DeletePending(%s).Success = 보류내역 호출', [AReceiptNo]));
      Result := True;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('LoadPending(%s).Exception = %s', [AReceiptNo, E.Message]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;

function TBPDM.MakeReceiptJson(ARI: TReceiptItemInfo; ASL: TArray<TProdItemRec>; APL: TArray<TPaymentItemRec>; const ASaleDate, ASaleTime: string; var AResMsg: string): string;
var
  JO: HCkJsonObject;
  LProdAmt, LVat: Integer;
  LPayMethod, I, J: ShortInt;
  SS: TStringStream;
begin
  Result  := '';
  AResMsg := '';
  JO := CkJsonObject_Create;
  SS := TStringStream.Create;
  try
    //매장 정보
    CkJsonObject_UpdateString(JO, 'StoreInfo.StoreName', PWideChar(Global.StoreInfo.StoreName));
    CkJsonObject_UpdateString(JO, 'StoreInfo.BizNo', PWideChar(Global.StoreInfo.BizNo));
    CkJsonObject_UpdateString(JO, 'StoreInfo.BossName', PWideChar(Global.StoreInfo.BossName));
    CkJsonObject_UpdateString(JO, 'StoreInfo.Tel', PWideChar(Global.StoreInfo.TelNo));
    CkJsonObject_UpdateString(JO, 'StoreInfo.Addr', PWideChar(Global.StoreInfo.Addr + ' ' + Global.StoreInfo.Addr2));
    CkJsonObject_UpdateString(JO, 'StoreInfo.CashierName', PWideChar(Global.UserInfo.UserName));
    CkJsonObject_UpdateNewObject(JO, 'BaseInfo');
    CkJsonObject_UpdateNewObject(JO, 'MemberInfo');
    CkJsonObject_UpdateNewArray(JO, 'ProductItems');
    CkJsonObject_UpdateNewArray(JO, 'PaymentItems');
    CkJsonObject_UpdateNewArray(JO, 'LockerItems');
    CkJsonObject_UpdateNewArray(JO, 'CouponItems');

    //영수증 출력 정보
    if (Length(APL) > 0) then
    begin
      CkJsonObject_UpdateString(JO, 'BaseInfo.SaleDate', PWideChar(ASaleDate)); //거래일자(yyyy-mm-dd)
      CkJsonObject_UpdateString(JO, 'BaseInfo.SaleTime', PWideChar(ASaleTime)); //거래시각(hh:nn)
      CkJsonObject_UpdateString(JO, 'BaseInfo.ReturnDate', ''); //반품일자
      CkJsonObject_UpdateBool(JO, 'BaseInfo.Reprint', False); //재출력 여부
      CkJsonObject_UpdateInt(JO, 'BaseInfo.TotalAmt', ARI.SaleAmt);
      CkJsonObject_UpdateInt(JO, 'BaseInfo.DCAmt', ARI.DCAmt);
      CkJsonObject_UpdateInt(JO, 'BaseInfo.KeepAmt', ARI.KeepAmt);
      CkJsonObject_UpdateString(JO, 'BaseInfo.ReceiptNo', PWideChar(ARI.ReceiptNo));
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top1', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top2', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top3', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top4', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom1', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom2', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom3', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom4', '');
    end;

    //회원 정보
    with Global.MemberInfo do
      if (not MemberNo.IsEmpty) then
      begin
        CkJsonObject_UpdateString(JO, 'MemberInfo.MemberName', PWideChar(MemberName));
        CkJsonObject_UpdateString(JO, 'MemberInfo.MemberNo', PWideChar(MemberNo));
        CkJsonObject_UpdateString(JO, 'MemberInfo.TelNo', PWideChar(TelNo));
        CkJsonObject_UpdateString(JO, 'MemberInfo.CarNo', PWideChar(CarNo));
        CkJsonObject_UpdateString(JO, 'MemberInfo.QRCode', PWideChar(QRCode));
        CkJsonObject_UpdateString(JO, 'MemberInfo.LockerList', PWideChar(LockerList));
        CkJsonObject_UpdateString(JO, 'MemberInfo.LockerExpiredDate', PWideChar(FormattedDateString(LockerExpiredDate)));
      end;

    try
      //주문 상품 내역
      J := 0;
      for I := 0 to Pred(Length(ASL)) do
      begin
        with ASL[I] do
        begin
          LProdAmt := ProdAmt;
          LVat := (LProdAmt - Trunc((LProdAmt / 1.1)));
          CkJsonObject_putI(JO, I);
          CkJsonObject_UpdateString(JO, 'ProductItems[i].ProdCode', PWideChar(ProdCode));
          CkJsonObject_UpdateString(JO, 'ProductItems[i].ProdName', PWideChar(ProdName));
          CkJsonObject_UpdateInt(JO, 'ProductItems[i].ProdAmt', LProdAmt);
          CkJsonObject_UpdateInt(JO, 'ProductItems[i].Vat', LVat);
          CkJsonObject_UpdateInt(JO, 'ProductItems[i].OrderQty', OrderQty);

          if (ProdDiv = CO_PROD_LOCKER) then
          begin
            Inc(J);
            CkJsonObject_putJ(JO, Pred(J));
            CkJsonObject_UpdateInt(JO, 'LockerItems[j].LockerNo', LockerNo);
            CkJsonObject_UpdateString(JO, 'LockerItems[j].LockerName', PWideChar(LockerName));
            CkJsonObject_UpdateInt(JO, 'LockerItems[j].PurchaseMonth', PurchaseMonth);
            CkJsonObject_UpdateString(JO, 'LockerItems[j].StartDate', PWideChar(FormattedDateString(UseStartDate)));
            CkJsonObject_UpdateString(JO, 'LockerItems[j].EndDate', PWideChar('')); //FormattedDateString(EndDate)));
          end;
        end;
      end;

      //결제 내역
      for I := 0 to Pred(Length(APL)) do
        with APL[I] do
        begin
          CkJsonObject_putI(JO, I);
          LPayMethod := PayMethod;
          case LPayMethod of
            CO_PAYMENT_CARD:
              CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptCard'));
            CO_PAYMENT_CASH:
              CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptCash'));
            CO_PAYMENT_PAYCO_CARD:
              CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptPayco'));
          else
            CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptVoid'));
          end;

          CkJsonObject_UpdateString(JO, 'PaymentItems[i].IsApproval', PWideChar(BoolToStr(IsApproval, True)));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].IsManualInput', PWideChar(BoolToStr(IsManualInput, True)));
          CkJsonObject_UpdateInt(JO, 'PaymentItems[i].ApprovalAmt', ApproveAmt);
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].ApprovalNo', PWideChar(ApproveNo));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].OrgApproveNo', PWideChar(OrgApproveNo));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].CardNo', PWideChar(CardNo));
          CkJsonObject_UpdateInt(JO, 'PaymentItems[i].InstallMonth', InstallMonth);
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].MerchantKey', PWideChar(''));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].TransDateTime', PWideChar(TradeDate));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].IssuerName', PWideChar(IssuerName));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].BuyerName', PWideChar(BuyerName));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].BuyerTypeName',  PWideChar(BuyerCode));
        end;

      Result := CkJsonObject__emit(JO);
      SS.WriteString(Result);
      SS.SaveToFile(Global.DirInfo.LogDir + 'MakeReceiptJson.json');
    finally
      CkJsonObject_Dispose(JO);
      FreeAndNil(SS);
    end;
  except
    on E: Exception do
    begin
      AResMsg := E.Message;
      UpdateLog(Format('MakeReceiptJson.Exception = %s', [E.Message]));
    end;
  end;
end;

function TBPDM.MakeCancelReceiptJson(ARI: TReceiptItemInfo; APL: TArray<TPaymentItemRec>; var AResMsg: string): string;
var
  JO: HCkJsonObject;
  SS: TStringStream;
begin
  Result  := '';
  AResMsg := '';
  JO := CkJsonObject_Create;
  SS := TStringStream.Create;
  try
    try
      //매장 정보
      CkJsonObject_UpdateString(JO, 'StoreInfo.StoreName', PWideChar(Global.StoreInfo.StoreName));
      CkJsonObject_UpdateString(JO, 'StoreInfo.BizNo', PWideChar(Global.StoreInfo.BizNo));
      CkJsonObject_UpdateString(JO, 'StoreInfo.BossName', PWideChar(Global.StoreInfo.BossName));
      CkJsonObject_UpdateString(JO, 'StoreInfo.Tel', PWideChar(Global.StoreInfo.TelNo));
      CkJsonObject_UpdateString(JO, 'StoreInfo.Addr', PWideChar(Global.StoreInfo.Addr + ' ' + Global.StoreInfo.Addr2));
      CkJsonObject_UpdateString(JO, 'StoreInfo.CashierName', PWideChar(Global.UserInfo.UserName));
      CkJsonObject_UpdateNewObject(JO, 'BaseInfo');
      CkJsonObject_UpdateNewObject(JO, 'MemberInfo');
      CkJsonObject_UpdateNewArray(JO, 'LockerItems');
      CkJsonObject_UpdateNewArray(JO, 'ProductItems');
      CkJsonObject_UpdateNewArray(JO, 'PaymentItems');
      CkJsonObject_UpdateNewArray(JO, 'CouponItems');

      //영수증 출력 정보
      CkJsonObject_UpdateString(JO, 'BaseInfo.SaleDate', PWideChar(Global.DateTime.CurrentDate)); //거래일자(yyyy-mm-dd)
      CkJsonObject_UpdateString(JO, 'BaseInfo.SaleTime', PWideChar(Global.DateTime.CurrentTime)); //거래시각(hh:nn)
      CkJsonObject_UpdateString(JO, 'BaseInfo.ReturnDate', PWideChar(Global.DateTime.CurrentDate)); //반품일자
      CkJsonObject_UpdateBool(JO, 'BaseInfo.Reprint', False); //재출력 여부
      CkJsonObject_UpdateInt(JO, 'BaseInfo.TotalAmt', ARI.SaleAmt);
      CkJsonObject_UpdateInt(JO, 'BaseInfo.DCAmt', ARI.DCAmt);
      CkJsonObject_UpdateInt(JO, 'BaseInfo.KeepAmt', ARI.KeepAmt);
      CkJsonObject_UpdateString(JO, 'BaseInfo.ReceiptNo', PWideChar(ARI.ReceiptNo));
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top1', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top2', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top3', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Top4', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom1', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom2', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom3', '');
      CkJsonObject_UpdateString(JO, 'BaseInfo.Bottom4', '');

      //회원 정보
      with Global.MemberInfo do
        if (not MemberNo.IsEmpty) then
        begin
          CkJsonObject_UpdateString(JO, 'MemberInfo.MemberName', PWideChar(MemberName));
          CkJsonObject_UpdateString(JO, 'MemberInfo.MemberNo', PWideChar(MemberNo));
          CkJsonObject_UpdateString(JO, 'MemberInfo.TelNo', PWideChar(TelNo));
          CkJsonObject_UpdateString(JO, 'MemberInfo.CarNo', PWideChar(CarNo));
          CkJsonObject_UpdateString(JO, 'MemberInfo.QRCode', PWideChar(QRCode));
          CkJsonObject_UpdateString(JO, 'MemberInfo.LockerList', PWideChar(LockerList));
          CkJsonObject_UpdateString(JO, 'MemberInfo.LockerExpiredDate', PWideChar(FormattedDateString(LockerExpiredDate)));
        end;

      //결제 내역
      for var I: ShortInt := 0 to High(APL) do
        with APL[I] do
        begin
          CkJsonObject_putI(JO, I);
          case PayMethod of
            CO_PAYMENT_CARD:
              CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptCard'));
            CO_PAYMENT_CASH:
              CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptCash'));
            CO_PAYMENT_PAYCO_CARD,
            CO_PAYMENT_PAYCO_COUPON,
            CO_PAYMENT_PAYCO_POINT:
              CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptPayco'));
          else
            CkJsonObject_UpdateString(JO, 'PaymentItems[i].PayCode', PWideChar('ptVoid'));
          end;

          CkJsonObject_UpdateString(JO, 'PaymentItems[i].IsApproval', PWideChar(BoolToStr(IsApproval, True)));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].IsManualInput', PWideChar(BoolToStr(IsManualInput, True)));
          CkJsonObject_UpdateInt(JO, 'PaymentItems[i].ApprovalAmt', ApproveAmt);
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].ApprovalNo', PWideChar(ApproveNo));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].OrgApproveNo', PWideChar(OrgApproveNo));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].CardNo', PWideChar(CardNo));
          CkJsonObject_UpdateInt(JO, 'PaymentItems[i].InstallMonth', InstallMonth);
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].MerchantKey', PWideChar(''));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].TransDateTime', PWideChar(TradeDate));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].IssuerName', PWideChar(IssuerName));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].BuyerName', PWideChar(BuyerName));
          CkJsonObject_UpdateString(JO, 'PaymentItems[i].BuyerTypeName',  PWideChar(BuyerCode));
        end;

      Result := CkJsonObject__emit(JO);
      SS.WriteString(Result);
      SS.SaveToFile(Global.DirInfo.LogDir + 'MakeCancelReceiptJson.json');
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('MakeCancelReceiptJson.Exception = %s', [E.Message]));
      end;
    end;
  finally
    CkJsonObject_Dispose(JO);
    FreeAndNil(SS);
  end;
end;

end.
