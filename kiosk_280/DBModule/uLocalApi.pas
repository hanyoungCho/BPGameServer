unit uLocalApi;

interface

uses
  Generics.Collections, System.Variants, uConsts, JSON,
  IdTCPClient, IdGlobal, System.SysUtils, Uni, MySQLUniProvider, Data.DB, System.DateUtils,
  uStruct;

type
  TLocalApi = class
    private
      FConnection: TUniConnection;
      FMySQLUniProvider: TMySQLUniProvider;
      FStoreProc: TUniStoredProc;

      function SendApi(AJsonText: string): string;

			function ProcExec(AStoredProc: TUniStoredProc; AProcedureName: string; AParam: array of Variant): TUniStoredProc;
    public
      constructor Create;
      destructor Destroy; override;

      // Ÿ���� AD
      function DBConnection: Boolean;

      // ���� ��Ȳ
      function GetLanePlayingInfo: TList<TLaneInfo>;

      // Ȧ�� ��� �� ���
			function LaneHold(ALaneNo: Integer; AHold: String): Boolean;

      // ���� ���
			function LaneReservation: Boolean;

			//ksj 230908 ȸ�� �ߺ����� �Ұ�(���� ������, ����)
			function MemberAssignCheck(AMemberNo: string): Boolean;

      property Connection: TUniConnection read FConnection write FConnection;
      property MySQLUniProvider: TMySQLUniProvider read FMySQLUniProvider write FMySQLUniProvider;
  end;

implementation

uses
  uGlobal, fx.Logging, uFunction;

{ TLocalApi }

constructor TLocalApi.Create;
begin
  Connection := TUniConnection.Create(nil);
  MySQLUniProvider := TMySQLUniProvider.Create(nil);
	FStoreProc := TUniStoredProc.Create(nil);
end;

destructor TLocalApi.Destroy;
begin
  Connection.Close;
  Connection.Free;

  MySQLUniProvider.Free;

  FStoreProc.Close;
  FStoreProc.Free;

  inherited;
end;

function TLocalApi.DBConnection: Boolean;
begin
  Result := False;
  try
    try
      Log.D('DB����', Global.Config.GS.IP + ':' + IntToStr(Global.Config.GS.DB_PORT));
      Connection.ProviderName := 'MySql';
      Connection.Server := Global.Config.GS.IP;
      Connection.Port := Global.Config.GS.DB_PORT;
      Connection.Username := 'bowling';
      Connection.Password := 'bowling123!';
      Connection.Database := 'bowling';
      Connection.Connect;

      Result := Connection.Connected;
      Log.D('DB����', IfThen(Result, '����', '����'));
    except
      on E: Exception do
        Log.E('DB ���� ����', E.Message);
    end;
  finally

  end;
end;

function TLocalApi.GetLanePlayingInfo: TList<TLaneInfo>;
var
	Index, nMin: Integer;
	rLaneInfo: TLaneInfo;
	AProc: TUniStoredProc;
	tmDate: TDateTime;
	sTemp: String;
begin

	Result := TList<TLaneInfo>.Create;

	try
		try
			AProc := TUniStoredProc.Create(nil);
			AProc := ProcExec(AProc, 'SP_GET_K_GAME_STATUS', [Global.Config.Store.StoreCode]);

			for Index := 0 to AProc.RecordCount - 1 do
			begin
				rLaneInfo.LaneNo := AProc.FieldByName('lane_no').AsInteger;
				rLaneInfo.LaneNm := AProc.FieldByName('lane_nm').AsString;

				rLaneInfo.Status := AProc.FieldByName('lane_status').AsString; //������ Ȧ����¸� ����Ȧ���ߴ��� �˾ƾ���
				rLaneInfo.HoldUser := AProc.FieldByName('hold_user_id').AsString; //���� �� Ȧ��� �������̾ �� ���ι��������ϰ�
				rLaneInfo.GameDiv := AProc.FieldByName('game_div').AsString;
				rLaneInfo.GameType := AProc.FieldByName('game_type').AsString;
				rLaneInfo.LeagueYn := AProc.FieldByName('league_yn').AsString;
				//rLaneInfo.LaneNo := AProc.FieldByName('start_datetime').AsString;

				if AProc.FieldByName('expected_end_datetime').AsString = '' then
				begin
					rLaneInfo.ExpectedEndDatetime := '';
					rLaneInfo.RemainMin := '';
				end
				else
				begin
					tmDate := AProc.FieldByName('expected_end_datetime').AsDateTime;
					rLaneInfo.ExpectedEndDatetime := FormatDateTime('YYYY-MM-DD hh:nn:ss', tmDate);

					nMin := MinutesBetween(Now, tmDate);
					rLaneInfo.RemainMin := IntToStr(nMin);
				end;

				if AProc.FieldByName('game_cnt').AsString = '' then
					rLaneInfo.GameCnt := 0
				else
					rLaneInfo.GameCnt := AProc.FieldByName('game_cnt').AsInteger;

				if AProc.FieldByName('game_fin').AsString = '' then
					rLaneInfo.GameFin := 0
				else
					rLaneInfo.GameFin := AProc.FieldByName('game_fin').AsInteger;

				Result.Add(rLaneInfo);
				AProc.Next;
			end;

		except
			on E: Exception do
			begin
				Log.E('TLocalApi.GetLanePlayingInfo', E.Message);
			end;
    end;
  finally
    AProc.Free;
  end;
end;

function TLocalApi.ProcExec(AStoredProc: TUniStoredProc; AProcedureName: string;
	AParam: array of Variant): TUniStoredProc;
var
  Index: Integer;
begin
	try
    with AStoredProc do
		begin
			AStoredProc.Connection := FConnection;
			Close;

      StoredProcName := EmptyStr;
			StoredProcName := AProcedureName;

			Params.CreateParam(ftString, 'P_STORE_CD', ptInput);

			if StoredProcName = 'SP_GET_MEMBER_ASSIGN_STATUS' then
      begin
				Params.CreateParam(ftString, 'P_MEMBER_NO', ptInput);
			end;

      if Params.Count > 0 then
      begin          //�迭�� ���� �� �ε���
        for Index := Low(AParam) to High(AParam) do
        begin
					if VarType(AParam[Index]) and varTypeMask = varCurrency then
          begin
						Params[Index].DataType := ftCurrency;
						Params[Index].AsCurrency := AParam[Index];
					end
          else
						Params[Index].Value := AParam[Index];
        end;
			end;
			ExecProc;
		end;
		Result := AStoredProc;
	except
		on E: Exception do
		begin
			//
		end;
	end;
end;

//������ �Ǵ� �����Ͽ� �ִ� ������ �ߺ������Ұ�
function TLocalApi.MemberAssignCheck(AMemberNo: string): Boolean;
var
	I: Integer;
	AProc: TUniStoredProc;
begin
	Result := False;

	AProc := TUniStoredProc.Create(nil);                                           //0      1 �ΰ�?
	AProc := ProcExec(AProc, 'SP_GET_MEMBER_ASSIGN_STATUS', [Global.Config.Store.StoreCode, AMemberNo]);

	if AProc.RecordCount > 0 then
		Result := True;     //ȸ�������ϴ� �κп��� ���� ���� Ʈ��� �ߺ����� ���ϰ�

end;

function TLocalApi.SendApi(AJsonText: string): string;
var
  Indy: TIdTCPClient;
  Msg: string;
begin
  try
    try
			Result := EmptyStr;
			Indy := TIdTCPClient.Create(nil);
      Indy.Host := Global.Config.GS.IP;
      Indy.Port := Global.Config.GS.SERVER_PORT;
      Indy.ConnectTimeout := 5000;
      Indy.ReadTimeout := 10000;
      Indy.Connect;

      if Indy.Connected then
      begin
        Indy.IOHandler.Writeln(AJsonText, IndyTextEncoding_UTF8);
        Result := Indy.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      end;
    except
      on E: Exception do
      begin
        Log.E('SendApi', E.Message);
        Log.E('SendApi', AJsonText);
      end;
    end;
  finally
    Indy.Disconnect;
    Indy.Free;
  end;
end;

function TLocalApi.LaneHold(ALaneNo: Integer; AHold: String): Boolean;
var
  JsonText: string;
  MainJson, jObj: TJSONObject;
  sResultCd, sResultMsg: String;
begin
  Result := False;
  try
    try
      MainJson := TJSONObject.Create;
      MainJson.AddPair(TJSONPair.Create('api', 'Z201_chgLaneHold'));
      MainJson.AddPair(TJSONPair.Create('store_cd', Global.Config.Store.StoreCode));
      MainJson.AddPair(TJSONPair.Create('user_id', Global.Config.AdminID));  //ksj 230713 OAuth.TerminalId->AdminID
      MainJson.AddPair(TJSONPair.Create('lane_no', IntToStr(ALaneNo)));
			MainJson.AddPair(TJSONPair.Create('hold_yn', AHold));

      JsonText := SendApi(MainJson.ToJSON);

      if JsonText <> EmptyStr then
      begin
        jObj := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;
        sResultCd := jObj.GetValue('result_cd').Value;
        sResultMsg := jObj.GetValue('result_msg').Value;

				if sResultCd = '0000' then
				begin
					Result := True;
//					Log.D('LaneHold', AHold); �α׿� Ȧ���� ����� ������ ������? �ʿ��ϸ� �� ������ �³�
				end;
      end;

    except
      on E: Exception do
      begin

      end;
    end;
  finally
    MainJson.Free;
    FreeAndNil(jObj);
  end;
end;

function TLocalApi.LaneReservation: Boolean;
var
	Index, Cnt: Integer;
  MainJson, ItemData, ItemBowler: TJSONObject;
  JsonData, JSonBowler, JSonBowler2: TJSONArray;

  RvObj, RvObjSub: TJSONObject;
  RvObjArr: TJSONArray;
  nRvObjArrCnt: Integer;
  JsonText, sAssignNo: string;
  //AProductInfo: TProductInfo;
  I: Integer;
  rGameInfo: TGameInfo;
begin
  try
    try
      {
      if not Global.SaleModule.TeeboxTimeError then
      begin
        Global.Lane.GetGMTeeBoxList;
        if not Global.SaleModule.TeeboxTimeCheck then
          Exit;
      end;
      }
      Result := False;
      MainJson := TJSONObject.Create;
      JsonData := TJSONArray.Create;

      MainJson.AddPair(TJSONPair.Create('store_cd', Global.Config.Store.StoreCode));
			MainJson.AddPair(TJSONPair.Create('api', 'Z102_regLaneGame'));
			MainJson.AddPair(TJSONPair.Create('user_id', Global.Config.AdminID));  //ksj 230713 OAuth.TerminalId->AdminID
      MainJson.AddPair(TJSONPair.Create('terminal_id', Global.Config.OAuth.TerminalId));
			MainJson.AddPair(TJSONPair.Create('assign_root_div', 'K'));

			MainJson.AddPair(TJSONPair.Create('data', JsonData));

			ItemData := TJSONObject.Create;
			ItemData.AddPair(TJSONPair.Create('lane_no', Global.SaleModule.LaneInfo.LaneNo));
			ItemData.AddPair(TJSONPair.Create('game_div', Global.SaleModule.GameInfo.GameDiv));
			//MainJson.AddPair(TJSONPair.Create('game_type', Global.SaleModule.GameInfo.StoreCode));

			if Global.SaleModule.GameInfo.LeagueUse = True then
				ItemData.AddPair(TJSONPair.Create('league_yn', 'Y' ))
			else
				ItemData.AddPair(TJSONPair.Create('league_yn', 'N' ));

			//ksj 230724 ��ȸ��� api ����
			ItemData.AddPair(TJSONPair.Create('competition_seq', 0));
			ItemData.AddPair(TJSONPair.Create('lane_move_cnt', 0));
			ItemData.AddPair(TJSONPair.Create('move_method', ''));
      ItemData.AddPair(TJSONPair.Create('train_min', 0)); //ksj 230825 �������߰�

      JSonBowler := TJSONArray.Create;
      ItemData.AddPair(TJSONPair.Create('bowler', JSonBowler));
      for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
      begin
        if Global.SaleModule.LaneInfo.LaneNo <> Global.SaleModule.PayProductList[I].LaneNo then
          Continue;

        if Global.SaleModule.PayProductList[I].PayResult = True then
        begin
					ItemBowler := TJSONObject.Create;
					ItemBowler.AddPair(TJSONPair.Create('participants_seq', 0)); //ksj 230720 ��ȸ��� api �߰�
					ItemBowler.AddPair(TJSONPair.Create('bowler_id', Global.SaleModule.PayProductList[I].BowlerId));

          if Global.SaleModule.PayProductList[I].MemberInfo.Code <> '' then
            ItemBowler.AddPair(TJSONPair.Create('bowler_nm', Global.SaleModule.PayProductList[I].MemberInfo.Name))
          else
            ItemBowler.AddPair(TJSONPair.Create('bowler_nm', Global.SaleModule.PayProductList[I].BowlerNm));

          ItemBowler.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[I].MemberInfo.Code));

					if Global.SaleModule.GameInfo.GameDiv = '1' then //GameDiv = '1'(������)
					begin
						ItemBowler.AddPair(TJSONPair.Create('game_cnt', Global.SaleModule.PayProductList[I].SaleQty));
						ItemBowler.AddPair(TJSONPair.Create('game_min', '0'));
					end  //������or�ð����϶� cnt, min �Ѵ� �׸��� �� ������������ ���� �� ��������
					else
					begin
						ItemBowler.AddPair(TJSONPair.Create('game_cnt', '0'));
						ItemBowler.AddPair(TJSONPair.Create('game_min', Global.SaleModule.PayProductList[I].SaleQty * Global.SaleModule.PayProductList[I].GameProduct.UseGameMin) );
					end;

					ItemBowler.AddPair(TJSONPair.Create('payment_type', '1'));
					ItemBowler.AddPair(TJSONPair.Create('fee_div', Global.SaleModule.PayProductList[I].GameProduct.FeeDiv));
					//ksj 230725 ȸ���� ����
					if (Global.SaleModule.PayProductList[I].DcProduct.ProdCd <> '') and (Global.SaleModule.PayProductList[I].DcProduct.ProdCd <> 'P') then
					begin
						ItemBowler.AddPair(TJSONPair.Create('membership_seq', Global.SaleModule.PayProductList[I].DcProduct.MembershipSeq)); //ȸ���� ���� ����
						//ksj 230818 ��ȸ���� ����
						if Global.SaleModule.PayProductList[I].DcProduct.GameDiv = '3' then
						begin
							ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', 0));
							ItemBowler.AddPair(TJSONPair.Create('membership_use_min', 0));
						end
						else
						begin //ksj 230802 ȸ���� ��밹��(��)
							if Global.SaleModule.GameInfo.GameDiv = '1' then
							begin
								ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', Global.SaleModule.PayProductList[I].DiscountList[0].DcValue));
								ItemBowler.AddPair(TJSONPair.Create('membership_use_min', 0));
							end
							else
							begin
								ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', 0));
								ItemBowler.AddPair(TJSONPair.Create('membership_use_min', Global.SaleModule.PayProductList[I].DiscountList[0].DcValue * Global.SaleModule.PayProductList[I].GameProduct.UseGameMin));
							end;
						end;
					end
					else //ȸ���� ��� ���Ҷ�
					begin
						ItemBowler.AddPair(TJSONPair.Create('membership_seq', '0')); //ȸ���� ���� ����
						ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', 0));
						ItemBowler.AddPair(TJSONPair.Create('membership_use_min', 0));
					end;

					ItemBowler.AddPair(TJSONPair.Create('product_cd', Global.SaleModule.PayProductList[I].GameProduct.ProdCd));
					ItemBowler.AddPair(TJSONPair.Create('product_nm', Global.SaleModule.PayProductList[I].GameProduct.ProdNm));
					//ItemJson.AddPair(TJSONPair.Create('receipt_no', Global.SaleModule.PayProductList[I].ReceiptNo));
					ItemBowler.AddPair(TJSONPair.Create('handy', 0)); //ksj 230720 ��ȸ��� api �߰�
					//ksj 230821 ��ȭ����
					if (Global.SaleModule.PayProductList[I].ShoesUse = 'Y') or (Global.SaleModule.PayProductList[I].ShoesUse = 'F') then
						ItemBowler.AddPair(TJSONPair.Create('shoes_yn', 'Y'))
					else
						ItemBowler.AddPair(TJSONPair.Create('shoes_yn', 'N'));

					JSonBowler.Add(ItemBowler);
				end;
			end;
			JsonData.Add(ItemData);

			if Global.SaleModule.GameInfo.LaneUse = '2' then
			begin
				ItemData := TJSONObject.Create;

				if Global.SaleModule.LaneInfo.LaneNo = Global.SaleModule.GameInfo.Lane1 then
          ItemData.AddPair(TJSONPair.Create('lane_no', Global.SaleModule.GameInfo.Lane2))
        else
          ItemData.AddPair(TJSONPair.Create('lane_no', Global.SaleModule.GameInfo.Lane1));
				ItemData.AddPair(TJSONPair.Create('game_div', Global.SaleModule.GameInfo.GameDiv));

        if Global.SaleModule.GameInfo.LeagueUse = True then
					ItemData.AddPair(TJSONPair.Create('league_yn', 'Y' ))
				else
					ItemData.AddPair(TJSONPair.Create('league_yn', 'N' ));
        //MainJson.AddPair(TJSONPair.Create('game_type', Global.SaleModule.GameInfo.StoreCode));
				//ItemData.AddPair(TJSONPair.Create('payment_type', '1'));

        //ksj 230724 ��ȸ��� api ����
				ItemData.AddPair(TJSONPair.Create('competition_seq', 0));
				ItemData.AddPair(TJSONPair.Create('lane_move_cnt', 0));
				ItemData.AddPair(TJSONPair.Create('move_method', ''));
				ItemData.AddPair(TJSONPair.Create('train_min', 0)); //ksj 230825 �������߰�

        JSonBowler := TJSONArray.Create;
        ItemData.AddPair(TJSONPair.Create('bowler', JSonBowler));
        for I := 0 to Global.SaleModule.PayProductList.Count - 1 do
        begin
          if Global.SaleModule.LaneInfo.LaneNo = Global.SaleModule.PayProductList[I].LaneNo then
            Continue;

          if Global.SaleModule.PayProductList[I].PayResult = True then
          begin
						ItemBowler := TJSONObject.Create;
						ItemBowler.AddPair(TJSONPair.Create('participants_seq', 0)); //ksj 230720 ��ȸ��� api �߰�
            ItemBowler.AddPair(TJSONPair.Create('bowler_id', Global.SaleModule.PayProductList[I].BowlerId));

            if Global.SaleModule.PayProductList[I].MemberInfo.Code <> '' then
              ItemBowler.AddPair(TJSONPair.Create('bowler_nm', Global.SaleModule.PayProductList[I].MemberInfo.Name))
            else
              ItemBowler.AddPair(TJSONPair.Create('bowler_nm', Global.SaleModule.PayProductList[I].BowlerNm));

            ItemBowler.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[I].MemberInfo.Code));

            if Global.SaleModule.GameInfo.GameDiv = '1' then //GameDiv = '1'(������)
						begin
							ItemBowler.AddPair(TJSONPair.Create('game_cnt', Global.SaleModule.PayProductList[I].SaleQty));
							ItemBowler.AddPair(TJSONPair.Create('game_min', '0'));
						end  //������or�ð����϶� cnt, min �Ѵ� �׸��� �� ������������ ���� �� ��������
						else
						begin
							ItemBowler.AddPair(TJSONPair.Create('game_cnt', '0') );
							ItemBowler.AddPair(TJSONPair.Create('game_min', Global.SaleModule.PayProductList[I].SaleQty * Global.SaleModule.PayProductList[I].GameProduct.UseGameMin) );
						end;

						ItemBowler.AddPair(TJSONPair.Create('payment_type', '1'));
						ItemBowler.AddPair(TJSONPair.Create('fee_div', Global.SaleModule.PayProductList[I].GameProduct.FeeDiv));
						//ksj 230725 ȸ���� ����
						if (Global.SaleModule.PayProductList[I].DcProduct.ProdCd <> '') and (Global.SaleModule.PayProductList[I].DcProduct.ProdCd <> 'P') then
						begin
							ItemBowler.AddPair(TJSONPair.Create('membership_seq', Global.SaleModule.PayProductList[I].DcProduct.MembershipSeq)); //ȸ���� ���� ����
              //ksj 230818 ��ȸ���� ����
							if Global.SaleModule.PayProductList[I].DcProduct.GameDiv = '3' then
							begin
								ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', 0));
								ItemBowler.AddPair(TJSONPair.Create('membership_use_min', 0));
							end
							else //ksj 230802 ȸ���� ��밹��(��)
							begin
								if Global.SaleModule.GameInfo.GameDiv = '1' then
								begin
									ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', Global.SaleModule.PayProductList[I].DiscountList[0].DcValue));
									ItemBowler.AddPair(TJSONPair.Create('membership_use_min', 0));
								end
								else
								begin
									ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', 0));
									ItemBowler.AddPair(TJSONPair.Create('membership_use_min', Global.SaleModule.PayProductList[I].DiscountList[0].DcValue * Global.SaleModule.PayProductList[I].GameProduct.UseGameMin));
								end;
							end;
						end
						else
						begin
							ItemBowler.AddPair(TJSONPair.Create('membership_seq', '0')); //ȸ���� ���� ����
							ItemBowler.AddPair(TJSONPair.Create('membership_use_cnt', 0));
						  ItemBowler.AddPair(TJSONPair.Create('membership_use_min', 0));
						end;

						ItemBowler.AddPair(TJSONPair.Create('product_cd', Global.SaleModule.PayProductList[I].GameProduct.ProdCd));
						ItemBowler.AddPair(TJSONPair.Create('product_nm', Global.SaleModule.PayProductList[I].GameProduct.ProdNm));
						//ItemJson.AddPair(TJSONPair.Create('receipt_no', Global.SaleModule.PayProductList[I].ReceiptNo));
						ItemBowler.AddPair(TJSONPair.Create('handy', 0)); //��ȸ��� api �߰�
            //ksj 230821 ��ȭ����
						if (Global.SaleModule.PayProductList[I].ShoesUse = 'Y') or (Global.SaleModule.PayProductList[I].ShoesUse = 'F') then
							ItemBowler.AddPair(TJSONPair.Create('shoes_yn', 'Y'))
						else
							ItemBowler.AddPair(TJSONPair.Create('shoes_yn', 'N'));

            JSonBowler.Add(ItemBowler);
          end;
        end;
        JsonData.Add(ItemData);
			end;

      Log.D('Local LaneReservation', LogReplace(MainJson.ToString));
      JsonText := SendApi(MainJson.ToString);
      Log.D('Local LaneReservation', LogReplace(JsonText));

      if JsonText = EmptyStr then
      begin
        Global.SBMessage.ShowMessage('12', '�˸�', MSG_TEEBOX_RESERVATION_AD_FAIL);
        Exit;
      end;

      RvObj := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if RvObj.GetValue('result_cd').Value <> '0000' then
			begin
				//ksj 230828 �����޼��� ���̿� ���� ����,���� ǥ��
				if Length(RvObj.GetValue('result_msg').Value) > 18 then
					Global.SBMessage.ShowMessage('12', '�˸�', RvObj.GetValue('result_msg').Value)
				else
					Global.SBMessage.ShowMessage('11', '�˸�', RvObj.GetValue('result_msg').Value);

				FreeAndNil(RvObj);
        Exit;
      end;

      RvObjArr := RvObj.GetValue('result_data') as TJsonArray;
      nRvObjArrCnt := RvObjArr.Size;
      sAssignNo := '';
      for i := 0 to nRvObjArrCnt - 1 do
      begin
        RvObjSub := RvObjArr.Get(i) as TJSONObject;

        //RvObjSub.GetValue('lane_no').Value;
        if sAssignNo <> EmptyStr then
          sAssignNo := sAssignNo + ', ';

        sAssignNo := sAssignNo + RvObjSub.GetValue('assign_no').Value;
      end;

      rGameInfo := Global.SaleModule.GameInfo;
      rGameInfo.AssignNo := sAssignNo;
      Global.SaleModule.GameInfo := rGameInfo;
      FreeAndNil(RvObj);

      Result := True;

    except
      on E: Exception do
      begin
        //WriteLog(True, 'ApiLog', Global.SaleModule.SaleDate, 'TeeBoxReservation2', LogReplace(JsonText));
        Log.E('LaneReservation', E.Message);
      end;
    end;
  finally
    FreeAndNil(MainJson);
  end;
end;

end.
