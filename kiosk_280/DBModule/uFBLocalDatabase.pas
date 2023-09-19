unit uFBLocalDatabase;

interface

uses
  fx.Logging,
  System.Variants, System.SysUtils, System.Classes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Login, FireDAC.FMXUI.Wait, Data.DB;

type
  TFBDataModule = class(TDataModule)
    FDManager: TFDManager;
    FDConnection: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    FDQuery: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure BeginTrans;                              // Begin
    procedure CommitTrans;                             // Commit
    procedure RollbackTrans;                           // RollBack
    procedure QueryRun(AQuery: TFDQuery);
    function QueryExec(ASQL: string; AParam: array of Variant): TFDQuery;
  public
    { Public declarations }
    // 영수증 번호 채번
    function GetRcpNo: Integer;

    // 저장
    function SaveDatabase: Boolean;
    // SL_SALE_H
    function SAVE_SL_SALE_H: Boolean;
    // SL_SALE_D
    function SAVE_SL_SALE_D: Boolean;
    // SL_PAY
    function SAVE_SL_PAY: Boolean;
    // SL_CARD
    function SAVE_SL_CARD(AIndex, ASeq: Integer): Boolean;
    // SL_PAYCO
    function SAVE_SL_PAYCO(AIndex, ASeq: Integer): Boolean;
    // SL_DISCOUNT
    function SAVE_SL_DISCOUNT: Boolean;


    function DBConnection: Boolean;

  end;

var
  FBDataModule: TFBDataModule;

implementation

uses
  uGlobal, uFunction, uLocalSQL, uSaleModule;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TFBDataModule.BeginTrans;
begin
  try
    if FDConnection.InTransaction then
      FDConnection.Rollback;
    FDConnection.StartTransaction;
  except on E: Exception do
    begin
      raise;
    end;
  end;
end;

procedure TFBDataModule.CommitTrans;
begin
  try
    FDConnection.Commit;
  except on E: Exception do
    begin
      raise;
    end;
  end;
end;

procedure TFBDataModule.RollbackTrans;
begin
  try
    FDConnection.Rollback;
  except on E: Exception do
    begin
      raise;
    end;
  end;
end;

procedure TFBDataModule.DataModuleCreate(Sender: TObject);
begin
//  FDConnection.Connected := True;
end;

procedure TFBDataModule.DataModuleDestroy(Sender: TObject);
begin
 //
end;

function TFBDataModule.DBConnection: Boolean;
begin
  FDConnection.Connected := True;
end;

function TFBDataModule.QueryExec(ASQL: string; AParam: array of Variant): TFDQuery;
var
  i: Integer;
begin
  Result := TFDQuery.Create(nil);
  try
    try
      Result.Connection := FDConnection;
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
//        Log.E('TFoodAsp.QueryExec', E.Message);
//        Log.E('TFoodAsp.QueryExec', ASQL);
        raise;
      end;
    end;
  finally
//    qryTemp.Free;
  end;
end;

procedure TFBDataModule.QueryRun(AQuery: TFDQuery);
var
  i: Integer;
  SqlText, LogText1, LogText2: string;
begin
  with AQuery do
  begin
    SqlText := UpperCase(Copy(SQL.Text, 1, 20));
    // 쿼리 실행
    if Pos('SELECT', SqlText) > 0 then
      Open
    else
      ExecSql;
  end;
end;

function TFBDataModule.GetRcpNo: Integer;
begin
  try
    Result := 0;

    FDQuery := QueryExec(LOCAL_SALE_H_MAX_RCP_NO, [Global.Config.Store.StoreCode, Global.SaleModule.SaleDate, Global.Config.Store.PosNo]);

    if FDQuery.RecordCount <> 0 then
      Result := FDQuery.FieldByName('NO_RCP').AsInteger;
  except
    on E: Exception do
    begin

    end;
  end;
end;

function TFBDataModule.SaveDatabase: Boolean;
begin
  try
    try
      Result := False;
      BeginTrans;

      if not SAVE_SL_SALE_H then
        Exit;

      if not SAVE_SL_SALE_D then
        Exit;

      if not SAVE_SL_PAY then
        Exit;

      if not SAVE_SL_DISCOUNT then
        Exit;

      CommitTrans;
      Result := True;
    except
      on E: Exception do
      begin
      end;
    end;
  finally

  end;
end;

function TFBDataModule.SAVE_SL_SALE_H: Boolean;
begin
  try
    try
      Result := False;
      Global.SaleModule.RcpNo := GetRcpNo + 1;
      Global.SaleModule.RcpAspNo := Global.Config.Store.StoreCode +
                                    Global.SaleModule.SaleDate +
                                    FormatFloat('00', StrToInt(Global.Config.Store.PosNo)) +
                                    FormatFloat('0000', Global.SaleModule.RcpNo);
      if Global.SaleModule.RcpNo = 0 then
      begin
        // 0이면 안된다.
        Exit;
      end;
      QueryExec(LOCAL_SALE_H_INSERT,
               [Global.Config.Store.StoreCode,
                Global.SaleModule.SaleDate,
                Global.Config.Store.PosNo,
                Global.SaleModule.RcpNo,
                Global.SaleModule.TotalAmt,
                Global.SaleModule.RealAmt,
                Global.SaleModule.VatAmt,
                Global.SaleModule.DCAmt]);
      Result := True;
    except
      on E: Exception do
      begin
        Log.E('SAVE_SL_SALE_H', E.Message);
        RollbackTrans;
      end;
    end;
  finally

  end;
end;

function TFBDataModule.SAVE_SL_SALE_D: Boolean;
var
  Index: Integer;
  SaleAmt: Currency;
begin
  try
    try
      Result := False;
      SaleAmt := 0;
      for Index := 0 to Global.SaleModule.BuyProductList.Count - 1 do
      begin
        with Global.SaleModule.BuyProductList[Index] do
        begin
          SaleAmt := (ABS(SaleQty) * Products.Price) - ABS(DcAmt);
          QueryExec(LOCAL_SALE_D_INSERT,
                   [Global.Config.Store.StoreCode,
                    Global.SaleModule.SaleDate,
                    Global.Config.Store.PosNo,
                    Global.SaleModule.RcpNo,
                    (Index + 1),
                    SaleQty,
                    Products.Code,
                    Products.Price,
                    SaleAmt,
                    SaleAmt - Trunc(SaleAmt / 1.1),
                    DcAmt
                   ]);
        end;
      end;
      Result := True;
    except
      on E: Exception do
      begin
        Log.E('SAVE_SL_SALE_D', E.Message);
        RollbackTrans;
      end;
    end;
  finally

  end;
end;

function TFBDataModule.SAVE_SL_PAY: Boolean;
var
  Index: Integer;
begin
  try
    try
      Result := False;
      for Index := 0 to Global.SaleModule.PayList.Count - 1 do
      begin
        QueryExec(LOCAL_PAY_INSERT,
                 [Global.Config.Store.StoreCode,
                  Global.SaleModule.SaleDate,
                  Global.Config.Store.PosNo,
                  Global.SaleModule.RcpNo,
                  (Index + 1),
                  Ord(TPayData(Global.SaleModule.PayList[Index]).PayType),
                  TPayData(Global.SaleModule.PayList[Index]).PayAmt,
                  TPayData(Global.SaleModule.PayList[Index]).PayAmt -
                    Trunc(TPayData(Global.SaleModule.PayList[Index]).PayAmt / 1.1)]);

         if TPayData(Global.SaleModule.PayList[Index]).PayType = ptCard then
         begin
           if not SAVE_SL_CARD(Index, Index + 1) then
             Exit;
         end
         else
         begin
           if not SAVE_SL_PAYCO(Index, Index + 1) then
             Exit;
         end;
      end;
      Result := True;
    except
      on E: Exception do
      begin
        Log.E('SAVE_SL_PAY', E.Message);
        RollbackTrans;
      end;
    end;
  finally

  end;
end;

function TFBDataModule.SAVE_SL_CARD(AIndex, ASeq: Integer): Boolean;
var
  ACard: TPayCard;
begin
  try
    try
      Result := False;
      ACard := TPayCard(Global.SaleModule.PayList[AIndex]);

      QueryExec(LOCAL_CARD_INSERT,
               [Global.Config.Store.StoreCode,
                Global.SaleModule.SaleDate,
                Global.Config.Store.PosNo,
                Global.SaleModule.RcpNo,
                ASeq,
                IfThen(ACard.RecvInfo.Result, 1, 0),
                ACard.SendInfo.SaleAmt,
                ACard.RecvInfo.CardNo,
                ACard.SendInfo.HalbuMonth,
                ACard.RecvInfo.AgreeNo,
                ACard.RecvInfo.TransNo,
                ACard.RecvInfo.AgreeDateTime,
                ACard.RecvInfo.BalgupsaCode,
                ACard.RecvInfo.BalgupsaName,
                ACard.RecvInfo.CompCode,
                ACard.RecvInfo.CompName]);
      Result := True;
    except
      on E: Exception do
      begin
        Log.E('SAVE_SL_CARD', E.Message);
        RollbackTrans;
      end;
    end;
  finally

  end;
end;

function TFBDataModule.SAVE_SL_PAYCO(AIndex, ASeq: Integer): Boolean;
var
  APayco: TPayPayco;
begin
  try
    try
      Result := False;
      APayco := TPayPayco(Global.SaleModule.PayList[AIndex]);

      QueryExec(LOCAL_PAYCO_INSERT,
               [Global.Config.Store.StoreCode,
                Global.SaleModule.SaleDate,
                Global.Config.Store.PosNo,
                Global.SaleModule.RcpNo,
                ASeq,
                IfThen(APayco.RecvInfo.Result, 1, 0),
                APayco.SendInfo.PayAmt,
                APayco.RecvInfo.RevCardNo,
                StrToIntDef(APayco.RecvInfo.HalbuMonth, 1),
                APayco.RecvInfo.AgreeNo,
                APayco.RecvInfo.TradeNo,
                APayco.RecvInfo.TransDateTime,
                APayco.RecvInfo.BuyTypeName,
                APayco.RecvInfo.BuyCompanyName,
                APayco.RecvInfo.ApprovalCompanyCode,
                APayco.RecvInfo.ApprovalCompanyName,
                APayco.RecvInfo.PointAmt,
                APayco.RecvInfo.PointName,
                APayco.RecvInfo.CouponAmt,
                APayco.RecvInfo.CouponName]);
      Result := True;
    except
      on E: Exception do
      begin
        Log.E('SAVE_SL_PAYCO', E.Message);
        RollbackTrans;
      end;
    end;
  finally

  end;
end;

function TFBDataModule.SAVE_SL_DISCOUNT: Boolean;
var
  Index: Integer;
begin
  try
    try
      Result := False;
      for Index := 0 to Global.SaleModule.DisCountList.Count - 1 do
      begin
        with Global.SaleModule.DisCountList[Index] do
        begin
          QueryExec(LOCAL_DISCOUNT_INSERT,
                   [Global.Config.Store.StoreCode,
                    Global.SaleModule.SaleDate,
                    Global.Config.Store.PosNo,
                    Global.SaleModule.RcpNo,
                    (Index + 1),
                    QRCode,
                    ApplyAmt,
                    Name]);
        end;
      end;
      Result := True;
    except
      on E: Exception do
      begin
        Log.E('SAVE_SL_DISCOUNT', E.Message);
        RollbackTrans;
      end;
    end;
  finally

  end;
end;

end.
