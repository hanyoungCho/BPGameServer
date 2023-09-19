unit uGMDatabase;

interface

uses
  uStruct, System.Variants, uStore, System.DateUtils,
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, MemDS, UniProvider,
  MySQLUniProvider, Generics.Collections;

type
  TGMDatabase = class(TStore)
    MySQL: TMySQLUniProvider;//(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Connection: TUniConnection;
    Query1: TUniQuery;
    Query2: TUniQuery;
    Query3: TUniQuery;
    function QueryExec(ASQL: string; AParam: array of Variant): TUniQuery;
    procedure QueryRun(AQuery: TUniQuery);
  public
    { Public declarations }
    constructor Create;//(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetConnection; override;
    // 회원데이터를 가져온다.
    function GetAllMemberInfo: TList<TMemberInfo>; override;
    // 회원 정보를 가져온다. CARD 또는 QR 회원
    //function GetMemberInfoApi(ACardNo: string; out AMsg: string): TMemberInfo; override;
    // 회원의 상품 리스트를 가져온다
    function GetMemberProductList(ACardNo, ACode, ADate: string): TList<TProductInfo>; override;
    // 회원의 정지 유무 확인
    function GetIsStopMemberStatus: Boolean; override;
    // 회원의 휴회 유무 확인
    function GetProductNotStartDateNot: Boolean; override;
    // 입장요일체크
    function GetProductUseDayCheck(AProductCode: string): Boolean; override;
    // 입장시간체크
    function GetProductUseTimeCheck(AProductCode: string): Boolean; override;
    // 타석 정보를 읽어 온다.
    function GetTeeBoxPlayingInfo: TList<TTeeBoxInfo>; override;
    //
    function Connect: Boolean; override;
    //
    function DisConnect: Boolean; override;
    // 타석 상품을 가져온다.
    function GetTeeBoxProductList: TList<TProductInfo>; override;
  end;

var
  GMDatabase: TGMDatabase;

implementation

uses
  fx.Logging, uFunction, uGMSQL, uGlobal;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

constructor TGMDatabase.Create;//(AOwner: TComponent);
begin
  inherited;
  Connection := TUniConnection.Create(nil);
  MySQL := TMySQLUniProvider.Create(nil);
  Query1 := TUniQuery.Create(nil);
  Query2 := TUniQuery.Create(nil);
  Query3 := TUniQuery.Create(nil);
end;

destructor TGMDatabase.Destroy;
begin
  Connection.Free;
  MySQL.Free;
  Query1.Free;
  Query2.Free;
  Query3.Free;
  inherited;
end;

procedure TGMDatabase.DataModuleCreate(Sender: TObject);
begin
  try
//    Connection.Server := '192.168.100.3';
//    Connection.Username := 'cwl';
//    Connection.Password := 'dlekdls';
//    Connection.Connect;
  except
    on E: Exception do
    begin

    end;
  end;
end;

function TGMDatabase.GetIsStopMemberStatus: Boolean;
begin
  Result := False;
  try
    try

      Result := True;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;

function TGMDatabase.DisConnect: Boolean;
begin

end;

function TGMDatabase.Connect: Boolean;
begin
  try
//    Connection.Connect;
    Result := Connection.Connected;
  finally

  end;
end;

function TGMDatabase.GetAllMemberInfo: TList<TMemberInfo>;
var
  Index: Integer;
  AQuery: TUniQuery;
begin
  Result := TList<TMemberInfo>.Create;
  try
    try
      AQuery := QueryExec(SQL_GM_SELECT_CUSTOMER, []);
//      Result := 0 <> 0;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;

{
function TGMDatabase.GetMemberInfoApi(ACardNo: string; out AMsg: string): TMemberInfo;
var
  Index: Integer;
  AQuery: TUniQuery;
begin
//  Result := False;
  try
    try
      AQuery := QueryExec(SQL_GM_SELECT_CUSTOMER, [ACardNo]);
      for Index := 0 to AQuery.RecordCount - 1 do
      begin
        Result.Code := AQuery.FieldByName('CUST_REG_NO').AsString;
        Result.CardNo := AQuery.FieldByName('CUST_CARD_NO').AsString;
        Result.Name := AQuery.FieldByName('CUST_REG_NAME').AsString;
        Result.Sex := AQuery.FieldByName('CUST_SEX').AsString;
        Result.Tel_Home := AQuery.FieldByName('CUST_H_TEL').AsString;
        Result.Tel_Mobile := AQuery.FieldByName('CUST_HP_TEL').AsString;
        Result.CarNo := AQuery.FieldByName('CUST_CAR_NO').AsString;
      end;

//      Result := True;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;
 }

function TGMDatabase.GetMemberProductList(ACardNo, ACode, ADate: string): TList<TProductInfo>;
var
  Index: Integer;
  AQuery: TUniQuery;
  AMember: TMemberInfo;
  AProduct: TProductInfo;
begin
  Result := TList<TProductInfo>.Create;
  try
    try
      AQuery := QueryExec(SQL_GM_MEMBER_SEARCH_PRODUCT, [ACardNo, ACode, ADate]);

      for Index := 0 to AQuery.RecordCount - 1 do
      begin
        if Global.SaleModule.Member.Code = EmptyStr then
        begin
          AMember.Code := AQuery.FieldByName('CUST_REG_NO').AsString;
//          AMember.CardNo := AQuery.FieldByName('CUST_CARD_NO').AsString;     jangheejin
          AMember.Sex := AQuery.FieldByName('REGSEX').AsString;
          AMember.Name := AQuery.FieldByName('CUST_REG_NAME').AsString;
          AMember.Tel_Mobile := AQuery.FieldByName('CUST_HP_NO').AsString;

          Global.SaleModule.Member := AMember;
        end;

        AProduct.Code := AQuery.FieldByName('REGCODE').AsString;
        AProduct.ProductType := AQuery.FieldByName('CUST_REG_TYPE').AsString;
        AProduct.StartDate := AQuery.FieldByName('CUST_IN_START_DTE').AsString;
        AProduct.EndDate := AQuery.FieldByName('CUST_IN_END_DTE').AsString;
    //    AProduct.UseWeek := AQuery.FieldByName('').AsString;
        AProduct.ActNo := AQuery.FieldByName('CUST_ACT_NO').AsString;
        AProduct.ActSeq := AQuery.FieldByName('ACT_SEQ').AsInteger;
        AProduct.Use_Qty := AQuery.FieldByName('CUST_COK_QTY').AsInteger;
        AProduct.Buy_Qty := AQuery.FieldByName('CUST_COK_BUY').AsInteger;
        AProduct.TypeName := AQuery.FieldByName('REGGRPNAME').AsString;
        AProduct.Name := AQuery.FieldByName('REGCODENAME').AsString;

        Result.Add(AProduct);
        AQuery.Next;
      end;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;

function TGMDatabase.GetProductNotStartDateNot: Boolean;
begin
  Result := False;
  try
    try

      Result := True;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;

function TGMDatabase.GetProductUseDayCheck(AProductCode: string): Boolean;
begin
  Result := False;
  try
    try

      Result := True;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;

function TGMDatabase.GetProductUseTimeCheck(AProductCode: string): Boolean;
begin
  Result := False;
  try
    try

      Result := True;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;

function TGMDatabase.GetTeeBoxPlayingInfo: TList<TTeeBoxInfo>;
var
  ATeeBoxInfo: TTeeBoxInfo;
  AQuery: TUniQuery;
  Index: Integer;
  ADateTime, EndDateTime: TDateTime;
  EndTime: string;
begin
  try
    try
      Result := TList<TTeeBoxInfo>.Create;
      AQuery := QueryExec(SQL_GM_MAIN_TEEBOX_INFO_1, []);

      ADateTime := now();

      for Index := 0 to AQuery.RecordCount - 1 do
      begin
        ATeeBoxInfo.Mno := AQuery.FieldByName('COM_MNO').AsString;
        ATeeBoxInfo.Tasuk := AQuery.FieldByName('COM_TASUG').AsString;
        ATeeBoxInfo.Stop := AQuery.FieldByName('COM_STOP').AsString;
        ATeeBoxInfo.Sub_Cls := AQuery.FieldByName('COM_SUB_CLS').AsString;
        ATeeBoxInfo.ERR := AQuery.FieldByName('COM_ERR').AsInteger;
        ATeeBoxInfo.High := AQuery.FieldByName('COM_HIGH').AsInteger;
        ATeeBoxInfo.TasukNo := AQuery.FieldByName('COM_TASUG').AsInteger;
        ATeeBoxInfo.End_Time := AQuery.FieldByName('COM_END_TIME').AsString;
        ATeeBoxInfo.Ma_Time := AQuery.FieldByName('COM_MA_TIME').AsString;
        ATeeBoxInfo.End_DT := AQuery.FieldByName('ENDT').AsString;
        ATeeBoxInfo.SearchTime := ADateTime;
        ATeeBoxInfo.Hold := False;
        ATeeBoxInfo.Add_OK := False;
        ATeeBoxInfo.Use := True;

        if (Trim(ATeeBoxInfo.End_DT) <> EmptyStr) or (Trim(ATeeBoxInfo.End_Time) <> EmptyStr) then
        begin
          if Trim(ATeeBoxInfo.End_DT) <> EmptyStr then
            EndTime := ATeeBoxInfo.End_DT
          else
            EndTime := ATeeBoxInfo.End_Time;

          EndDateTime := DateStrToDateTime(FormatDateTime('YYYYMMDD', now) +
                                                 StringReplace( EndTime, ':', '', [rfReplaceAll]) + '00');

          if FormatDateTime('YYYYMMDDhhnn', now) > (FormatDateTime('YYYYMMDD', now) + StringReplace(EndTime, ':', '', [rfReplaceAll])) then
            ATeeBoxInfo.BtweenTime := 0
          else
            ATeeBoxInfo.BtweenTime := MinutesBetween(ADateTime, EndDateTime);
        end;

        Result.Add(ATeeBoxInfo);
        AQuery.Next;
      end;
    except
      on E: Exception do
        Log.E(ClassName, E.Message);
    end;
  finally

  end;
end;

function TGMDatabase.GetTeeBoxProductList: TList<TProductInfo>;
var
  Index: Integer;
  AQuery: TUniQuery;
  AProduct: TProductInfo;
begin
  try
    Result := TList<TProductInfo>.Create;

    AQuery := QueryExec(SQL_GM_TEEBOX_PRODUCT, []);

    for Index := 0 to AQuery.RecordCount - 1 do
    begin
      AProduct.Code := AQuery.FieldByName('REGCODE').AsString;
      AProduct.TypeName := AQuery.FieldByName('REGCODENAME').AsString;
      AProduct.Name := AQuery.FieldByName('REGGRPNAME').AsString;
      AProduct.Price := AQuery.FieldByName('REGAMT').AsInteger;
      AProduct.Sex := IfThen(AQuery.FieldByName('REGSEX').AsString = 'M', 0, 1);

      Result.Add(AProduct);
      AQuery.Next;
    end;
  finally

  end;
end;

function TGMDatabase.QueryExec(ASQL: string; AParam: array of Variant): TUniQuery;
var
  i: Integer;
begin
  Result := TUniQuery.Create(nil);
  try
    try
      Result.Connection := Connection;
      Result.SQL.Text := ASQL;
      if Result.Params.Count > 0 then
      begin
        for i := Low(AParam) to High(AParam) do
        begin
          if Result.Params[i].Name = 'SIGNATURE' then
          begin
            Result.Params[i].DataType := ftBlob;
            Result.Params[i].Value := AParam[i];
          end
          else if VarType(AParam[i]) and varTypeMask = varCurrency then
            Result.Params[i].AsCurrency := AParam[i]
          else
            Result.Params[i].Value := AParam[i];
        end;
      end;
      QueryRun(Result);
      Result := Result;
    except on E: Exception do
      begin
        Global.QueryError := True;
        Log.E('TDBModule.QueryExec', E.Message);
        Log.E('TDBModule.QueryExec', ASQL);
        raise;
      end;
    end;
  finally
  end;
end;

procedure TGMDatabase.QueryRun(AQuery: TUniQuery);
var
  Index: Integer;
  SqlText, LogText1, LogText2: string;
begin
  with AQuery do
  begin
    SqlText := UpperCase(Copy(SQL.Text, 1, 20));
    if Pos('SELECT', SqlText) > 0 then
      Open
    else
      ExecSql;
  end;
end;

procedure TGMDatabase.SetConnection;
begin
  try
    Connection.ProviderName := 'MySql';
    Connection.Port := 3306;
    Connection.Database := 'gmsoftgolf';
    Connection.SpecificOptions.Clear;
    Connection.SpecificOptions.Values['ConnectionTimeout']:= '30';

//    if True then
    if False then
    begin
      Connection.Server := '192.168.100.3';
      Connection.Username := 'cwl';
      Connection.Password := 'dlekdls';
    end
    else
    begin
      Connection.Server := '192.168.0.75';
      Connection.Username := 'test1';
      Connection.Password := 'xxxxx';
    end;

    Connect;
  except
    on E: Exception do
    begin

    end;
  end;
end;

end.
