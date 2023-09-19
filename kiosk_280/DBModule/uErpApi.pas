unit uErpApi;

interface

uses
  IdGlobal, FMX.Graphics, IdCoderMIME, InIFiles, IdSSL, IdSSLOpenSSL, Vcl.Dialogs,
  uStruct, System.Variants, System.SysUtils, System.Classes, System.DateUtils,
  Generics.Collections, Uni, IdHTTP, JSON, EncdDecd, IdURI, uConsts;

type
  TErpAip = class
  private
    FAuthorization: AnsiString;
    FUTF8Str: UTF8String;

    function Send_API(MethodType: TMethodType; AUrl, AJsonText: string; NotSaveLog: Boolean = False): AnsiString;

    //타석기AD미사용시 배정예약, AD상관없이 매출저장
    function Send_API_Reservation(MethodType: TMethodType; AUrl, AJsonText: string; NotSaveLog: Boolean = False): AnsiString;

    function GetVersion(AUrl: string): string;
  public
		sslIOHandler: TIdSSLIOHandlerSocketOpenSSL;
    constructor Create;
    destructor Destroy; override;

    function OAuth_Certification: Boolean; // OAuth 인증

    function GetConfig: Boolean; // 환경설정
    function GetStoreInfo: Boolean; // 가맹점 정보 조회
    function GetLaneMaster: TList<TLaneInfo>; // 레인 마스터 정보를 읽어 온다.
    function GetAllMemberInfo(var bMsg: Boolean): TList<TMemberInfo>; // 회원데이터를 가져온다.
    function GetGameProductList(var bMsg: Boolean): TList<TGameProductInfo>; // 요금제 상품을 가져온다.
		function GetMemberShipProductList(var bMsg: Boolean): TList<TMemberShipProductInfo>; // 회원제 상품을 가져온다.
    function GetRentProduct: TGameProductInfo; // 대여상품을 가져온다.
    function GetProductAmt(AProductCd: String): TGameProductInfo; // 현재시간대 요금제 상품의 금액을 가져온다.

    function AddNewMember: Boolean; //신규회원가입

		function GetMemberProductList(AMemberNo: string): TList<TMemberProductInfo>; // 회원의 상품 리스트를 가져온다

    function GetAvailableForSales: String; // 회원의 상품 사용가능 여부
    function GetAvailableForSalesList: String; // 회원의 상품 사용가능 여부(복수개)

    //회원의 상품 이용시간,배정시간을 배정시간 기준으로 불러온다. producttime = false;
    //function GetTeeBoxProductTime(AProductCd: string; out ACode, AMsg: string): TProductInfo;

    // 매출 등록
    function SaveSaleInfo: Boolean;

    // 광고 목록 조회
    procedure SearchAdvertisList;
    function SendAdvertisCnt(ASeq: string): Boolean;

    // 카드사 할인 체크
    function SearchCardDiscount(ACardNo, ACardAmt, ASeatProductDiv: string; out ACode, AMsg: string): Currency;

    property Authorization: AnsiString read FAuthorization write FAuthorization;
    property UTF8Str: UTF8String read FUTF8Str write FUTF8Str;
  end;

implementation

uses
  uGlobal, uSaleModule, fx.Logging, uFunction, uCommon;

{ TASPDatabase }

constructor TErpAip.Create;
begin
  sslIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  sslIOHandler.SSLOptions.Method := sslvSSLv23;
  sslIOHandler.SSLOptions.Mode := sslmClient;
end;

destructor TErpAip.Destroy;
begin
  sslIOHandler.Free;

  inherited;
end;

function TErpAip.OAuth_Certification: Boolean;
var
  Indy: TIdHTTP;
  SendData, RecvData: TStringStream;
  jObj: TJSONObject;
begin
  try
    try
      Result := False;

      Indy := TIdHTTP.Create(nil);
      SendData := TStringStream.Create;
      RecvData := TStringStream.Create;

      SendData.Clear;
      RecvData.Clear;

      Indy.IOHandler := sslIOHandler;

      UTF8Str := UTF8String(Global.Config.OAuth.TerminalId + ':' + Global.Config.OAuth.TerminalPw);
      Authorization := EncdDecd.EncodeBase64(PAnsiChar(UTF8Str), Length(UTF8Str));

      Indy.Request.CustomHeaders.Clear;
      Indy.Request.ContentType := 'application/x-www-form-urlencoded';
      Indy.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + Authorization;

      SendData.WriteString(TIdURI.ParamsEncode('grant_type=client_credentials'));

      Indy.Post(Global.Config.Partners.OAuthURl, SendData, RecvData);

      jObj := TJSONObject.ParseJSONValue( ByteStringToString(RecvData) ) as TJSONObject;
      Global.Config.OAuth.Token := jObj.Get('access_token').JsonValue.Value;

      Result := True;
    except
      on E: Exception do
      begin
        showmessage('인증오류 입니다. 단말기 정보를 확인해 주세요' + #13#10 + e.Message);
      end;
    end;

  finally
    FreeAndNil(jObj);
    Indy.Free;
    SendData.Free;
    RecvData.Free;
  end;
end;

function TErpAip.GetStoreInfo: Boolean;
var
  MainJson, jObj: TJSONObject;
  JsonText: string;
begin
  try
    Result := False;

    JsonText := Send_API(mtGet, 'B001_getStore?store_cd=' + Global.Config.Store.StoreCode, EmptyStr, True);
    //Log.D('가맹점정보', JsonText);

    if JsonText = EmptyStr then
      Exit;

    MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

    if '0000' = MainJson.GetValue('result_cd').Value then
    begin
      jObj := MainJson.GetValue('result_data') as TJSONObject;

      Global.Config.Store.StoreName := jObj.GetValue('store_nm').Value;
      //Global.Config.Store.BossName := jObj.GetValue('owner_nm').Value;
      Global.Config.Store.Tel := jObj.GetValue('tel_no').Value;
      Global.Config.Store.Addr := jObj.GetValue('addr').Value + jObj.GetValue('addr2').Value;
      Global.Config.Store.SaleStartTime := jObj.GetValue('sale_start_time').Value;
      Global.Config.Store.SaleEndTime := jObj.GetValue('sale_end_time').Value;
      Global.Config.Store.ClosureStartDatetime := jObj.GetValue('closure_start_datetime').Value;
      Global.Config.Store.closureEndDatetime := jObj.GetValue('closure_end_datetime').Value;

      Global.Config.Store.UseAgreement := jObj.GetValue('use_agreement').Value; //이용 약관
      Global.Config.Store.PrivacyAgreement := jObj.GetValue('privacy_agreement').Value; //개인정보 약관
      Global.Config.Store.AdvertiseAgreement := jObj.GetValue('advertise_agreement').Value; //광고성 수신동의 약관
			Global.Config.Store.StoreHolidayYn := jObj.GetValue('store_holiday_yn').Value; //가맹점 지정 휴일 여부
			Global.Config.Store.ShoesProdCd := jObj.GetValue('shoes_prod_cd').Value; //대화상품코드
			//ksj 230906 기본 상품코드
			Global.Config.Store.GameDefaultProdCd := jObj.GetValue('game_prod_cd').Value;
			Global.Config.Store.TimeDefaultProdCd := jObj.GetValue('time_prod_cd').Value;
		end;

    Result := True;
  finally
    FreeAndNil(MainJson);
  end;
end;

function TErpAip.GetLaneMaster: TList<TLaneInfo>;
var
  Index, nCnt: Integer;
  rLaneInfo: TLaneInfo;
  MainJson, jObj: TJSONObject;
  jObjArr: TJsonArray;
  JsonText, sResultCd, sResultMsg: string;
begin
  try
    Result := TList<TLaneInfo>.Create;

    JsonText := Send_API(mtGet, 'B501_getLaneList?store_cd=' + Global.Config.Store.StoreCode, EmptyStr);
    //Log.D('타석 마스터', JsonText);

    if JsonText = EmptyStr then
      Exit;

    MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;;
    sResultCd := MainJson.GetValue('result_cd').Value;
    sResultMsg := MainJson.GetValue('result_msg').Value;

    if sResultCd <> '0000' then
    begin
      Log.D('레인 마스터', 'B501_getLaneList : ' + sResultCd + ' / ' + sResultMsg);
      Exit;
    end;

    if MainJson.FindValue('result_data') is TJSONNull then
      Exit;

    jObjArr := MainJson.GetValue('result_data') as TJsonArray;
    nCnt := jObjArr.size;

    for Index := 0 to nCnt - 1 do
    begin
      jObj := jObjArr.Get(Index) as TJSONObject;
      rLaneInfo.LaneNo := StrToIntDef(jObj.GetValue('lane_no').Value, 0);
      rLaneInfo.LaneNm := jObj.GetValue('lane_nm').Value;

      Result.Add(rLaneInfo);
    end;

  finally
    FreeAndNil(MainJson);
  end;
end;

function TErpAip.GetAllMemberInfo(var bMsg: Boolean): TList<TMemberInfo>;
var
  Index, Loop, tmp: Integer;
  AMemberInfo: TMemberInfo;
  MainJson, jObj: TJSONObject;
  jObjArr: TJsonArray;
  JsonText, AVersion, SendDatetime: string;

  nCnt: Integer;
begin

  try
    try
      bMsg := False;
      Result := TList<TMemberInfo>.Create;

      SendDatetime := Global.SaleModule.MemberInfoDownLoadDateTime;

      if Global.SaleModule.MemberInfoDownLoadDateTime = EmptyStr then
        Global.SaleModule.MemberInfoDownLoadDateTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);

      if SendDatetime <> EmptyStr then
      begin
        SendDatetime := StringReplace(SendDatetime, ' ', '%20', [rfReplaceAll]);
        JsonText := Send_API(mtGet, 'B301_getMemberList?search_datetime=' + SendDatetime + '&store_cd=' + Global.Config.Store.StoreCode, EmptyStr);
      end
      else
        JsonText := Send_API(mtGet, 'B301_getMemberList?store_cd=' + Global.Config.Store.StoreCode, EmptyStr);

      if JsonText = EmptyStr then
      begin
        if StrPos(PChar(Global.SaleModule.FApiErrorMsg), PChar('Socket Error')) <> nil then
        begin
          showmessage('회원 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + Global.SaleModule.FApiErrorMsg);
        end;

        Exit;
      end;

      if SendDatetime <> EmptyStr then
        Log.D('회원정보', JsonText);

      MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' = MainJson.GetValue('result_cd').Value then
      begin
        if MainJson.FindValue('result_data') is TJSONNull then
          Exit;

        jObjArr := MainJson.GetValue('result_data') as TJsonArray;
        nCnt := jObjArr.Size;

        Log.D('저장할 회원 수', Inttostr(nCnt));
        for Index := 0 to nCnt - 1 do
        begin
          jObj := jObjArr.Get(Index) as TJSONObject;

          AMemberInfo.Code := jObj.GetValue('member_no').Value;
          AMemberInfo.Name := jObj.GetValue('member_nm').Value;
          AMemberInfo.Sex := IfThen(StrToIntDef(jObj.GetValue('sex_div').Value, 1) = 1, 'M', 'W');
          //AMemberInfo.BirthDay := jObj.GetValue('birthday').Value;
          AMemberInfo.MobileNo := jObj.GetValue('mobile_no').Value;
          //AMemberInfo.Email := jObj.GetValue('email').Value;
          //AMemberInfo.CarNo := jObj.GetValue('car_no').Value;
          //AMemberInfo.Addr1 := jObj.GetValue('zipno').Value;
          //AMemberInfo.Addr1 := jObj.GetValue('addr').Value;
          //AMemberInfo.Addr2 := jObj.GetValue('addr2').Value;
          AMemberInfo.QRCode := jObj.GetValue('qrcd').Value;
          //AMemberInfo.FingerStr := jObj.GetValue('fingerprint_hash').Value;
          AMemberInfo.Use := jObj.GetValue('del_yn').Value = 'N';

          if (Global.SaleModule.MemberList.Count <> 0) then
          begin
            for tmp := 0 to Global.SaleModule.MemberList.Count - 1 do
            begin
              if AMemberInfo.Code = Global.SaleModule.MemberList[tmp].Code then
              begin
                Global.SaleModule.MemberList.Delete(tmp);
                Break;
              end;
            end;
          end;

          if AMemberInfo.Use then
            Result.Add(AMemberInfo);
        end;
      end;

      bMsg := True;

    except
      on E: Exception do
      begin
        showmessage('회원 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + e.Message);
      end;
    end;

    Log.D('저장된 회원 수', inttostr(Result.Count));
  finally
    FreeAndNil(MainJson);
  end;
end;

function TErpAip.GetConfig: Boolean;
var
  MainJson, jObj: TJSONObject;
  AClient_ID: AnsiString;
  JsonText: string;
  MI: TMemIniFile;
  SL, IL: TStringList;
  SS: TStringStream;
  I, J: Integer;

  sStr: String;
begin
  try
    Result := False;

    AClient_ID := Global.Config.OAuth.TerminalId;

    JsonText := Send_API(mtGet, 'B101_getTerminal?&terminal_id=' + AClient_ID, EmptyStr);
    if JsonText = EmptyStr then
      Exit;

    //Log.D('환경설정', JsonText);

    MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

    if MainJson.GetValue('result_cd').Value <> '0000' then
      Exit;

    jObj := MainJson.GetValue('result_data') as TJSONObject;

    Global.Config.SetConfig('STORE', 'PosNo', StrToInt(jObj.GetValue('pos_no').Value));

    SS := TStringStream.Create;
    SS.Clear;
    SS.WriteString(jObj.GetValue('config').Value);
    MI := TMemIniFile.Create(SS, TEncoding.UTF8);
    SL := TStringList.Create;
    IL := TStringList.Create;

    MI.ReadSections(SL);
    for I := 0 to Pred(SL.Count) do
    begin
      IL.Clear;
      MI.ReadSection(SL[I], IL);
      for J := 0 to Pred(IL.Count) do
        Global.Config.SetConfig(SL[I], IL[J], MI.ReadString(SL[I], IL[J], ''));
    end;

    Result := True;

  finally
    FreeAndNil(MainJson);
    FreeAndNil(IL);
    FreeAndNil(SL);
    FreeAndNil(MI);
    SS.Free;
  end;
end;

{
function TASPDatabase.GetMemberInfoApi(ACardNo: string; out AMsg: string): TMemberInfo;
var
  Index: Integer;
  MainJson, jObj, jObjSub: TJSONObject;
  jObjArr, jObjArrSub: TJsonArray;
  AMember: TMemberInfo;
  JsonText: string;
  sLockerEndDay, sLockerEndDayTemp: String;
begin
  try
    Log.D('GetMemberInfo', LogReplace(ACardNo));
    AMember.Code := EmptyStr;

    Result := AMember;

    sLockerEndDay := '';

    JsonText := Send_API(mtGet, 'K301_Member?store_cd=' + Global.Config.Store.StoreCode + '&photo_yn=Y' + '&member_no=' + ACardNo, EmptyStr);

    if JsonText = EmptyStr then
      Exit;

    Log.D('GetMemberInfo JsonText', LogReplace(JsonText));

    MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

    if MainJson.GetValue('result_cd').Value = '0000' then
    begin
      jObjArr := MainJson.GetValue('result_data') as TJsonArray;
      if jObjArr.Count = 0 then
        Exit;

      jObj := jObjArr.Get(0) as TJSONObject;
      Result.Code := jObj.GetValue('member_no').Value;
      Result.CardNo := jObj.GetValue('qr_cd').Value;
      Result.Addr1 := jObj.GetValue('address').Value;
      Result.Addr2 := jObj.GetValue('address_desc').Value;
      Result.Sex := IfThen(jObj.GetValue('sex_div').Value = '1', 'M', 'W');
      Result.BirthDay := jObj.GetValue('birth_ymd').Value;
      Result.Name := jObj.GetValue('member_nm').Value;
      Result.Tel_Mobile := jObj.GetValue('hp_no').Value;

      //2020-12-29 라카만료일
      if not (jObj.FindValue('locker') is TJSONNull) then
      begin
        jObjArrSub := jObj.GetValue('locker') as TJsonArray;
        for Index := 0 to jObjArrSub.Count - 1 do
        begin
          if Index <> 0 then
            sLockerEndDay := sLockerEndDay + ' ';

          jObjSub := jObjArrSub.Get(Index) as TJSONObject;
          sLockerEndDayTemp := jObjSub.GetValue('end_day').Value;
          sLockerEndDayTemp := Copy(sLockerEndDayTemp, 1, 4) + '-' + Copy(sLockerEndDayTemp, 5, 2) + '-' + Copy(sLockerEndDayTemp, 7, 2);
          sLockerEndDay := sLockerEndDay + sLockerEndDayTemp;
        end;
      end;

      Global.SaleModule.FLockerEndDay := sLockerEndDay;

    end;
  finally
    FreeAndNil(MainJson);
  end;
end;
 }

function TErpAip.GetMemberProductList(AMemberNo: string): TList<TMemberProductInfo>;
var
	Index: Integer;
  MainJson, jObj, jObjSub: TJSONObject;
  jObjArr: TJsonArray;
  JsonText, NowDay: string;
  AProduct: TMemberProductInfo;
  AMember: TMemberInfo;
  //sUseStatus, sLockerEndDay, sLockerEndDayTemp: String;
begin
  try
    Result := TList<TMemberProductInfo>.Create;

    NowDay := FormatDateTime('yyyy-mm-dd', now);

		JsonText := Send_API(mtGet, 'C002_getMember?store_cd=' + Global.Config.Store.StoreCode +
																							'&member_no=' + AMemberNo, EmptyStr);

		if JsonText = EmptyStr then
      Exit;

    Log.D('GetMemberProductList JsonText', LogReplace(JsonText));

    MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

    if MainJson.GetValue('result_cd').Value <> '0000' then
      Exit;

    if MainJson.FindValue('result_data') is TJSONNull then
      Exit;

    jObj := MainJson.GetValue('result_data') as TJSONObject;

    AMember := Global.SaleModule.Member;
    AMember.SavePoint := StrToInt(jObj.GetValue('save_point').Value);
    Global.SaleModule.Member := AMember;

    jObjArr := jObj.GetValue('membership_list') as TJsonArray; //회원권 보유 리스트
    for Index := 0 to jObjArr.Count - 1 do
    begin
      jObjSub := jObjArr.Get(Index) as TJSONObject;

      if jObjSub.GetValue('use_status').Value <> '1' then
        Continue;

      if jObjSub.GetValue('start_date').Value > NowDay then
        Continue;

      if jObjSub.GetValue('end_date').Value < NowDay then
        Continue;

      AProduct.MembershipSeq := StrToInt(jObjSub.GetValue('membership_seq').Value);
      AProduct.ProdCd := jObjSub.GetValue('prod_cd').Value;                  // 상품 코드
      AProduct.ProdNm := jObjSub.GetValue('prod_nm').Value;                  // 상품명
      AProduct.ProdDetailDiv := jObjSub.GetValue('prod_detail_div').Value;   // 상품 상세 구분 501: 게임회원권, 502: 시간회원권, 503 : 우대회원권
      AProduct.GameDiv := jObjSub.GetValue('game_div').Value;                // 게임 구분	 	"1:게임제, 2:시간제, 3:할인제
      AProduct.DiscountFeeDiv := jObjSub.GetValue('discount_fee_div').Value; // 할인 요금제 구분	02	"회원권인경우 적용할 요금제 구분에 사용
      AProduct.PurchaseGameCnt := StrToInt(jObjSub.GetValue('purchase_game_cnt').Value);     // 구매 이용 게임수
      AProduct.RemainGameCnt := StrToInt(jObjSub.GetValue('remain_game_cnt').Value);   // 잔여 이용 게임수	사용하고 남은 이용할수 있는 게임수(게임제 회원권인경우)
      AProduct.PurchaseGameMin := StrToInt(jObjSub.GetValue('purchase_game_min').Value);      // 구매 게임 시간(분)
      AProduct.RemainGameMin := StrToInt(jObjSub.GetValue('remain_game_min').Value);   // 잔여 게임 시간(분)	사용하고 남은 이용할수 있는 시간(시간제 회원권인경우)

      AProduct.StartDate := jObjSub.GetValue('start_date').Value;
      AProduct.EndDate := jObjSub.GetValue('end_date').Value;

      AProduct.ProdBenefits := jObjSub.GetValue('prod_benefits').Value;      // 상품 혜택(문구)		 400	이용요금할인 + 대화료무료, 포인트적립 5%	할인제 회원권인 경우만 해당됨
      AProduct.ShoesFreeYn := jObjSub.GetValue('shoes_free_yn').Value;       // 대화료 무료 여부	 Y/N	할인제 회원권인 경우만 해당됨
      AProduct.SavePointRate := StrToInt(jObjSub.GetValue('save_point_rate').Value);   // 적립 포인트(%)		 5	할인제 회원권인 경우만 해당됨

      Result.Add(AProduct);
    end;

  finally
    FreeAndNil(MainJson);;
  end;
end;

function TErpAip.GetGameProductList(var bMsg: Boolean): TList<TGameProductInfo>;
var
  Index, i, WeekUse: Integer;
  nCnt: Integer;
  MainJson, jObj: TJSONObject;
  jObjArr: TJsonArray;

  //nSubCnt: Integer;
  //jObjSubArr: TJsonArray;
  //jObjSub: TJSONObject;

  AProduct: TGameProductInfo;
  JsonText: string;
  SendDatetime: string;
begin

  try
    try
      bMsg := False;
      Result := TList<TGameProductInfo>.Create;

      SendDatetime := Global.SaleModule.GameProdDownLoadDateTime;
      Global.SaleModule.GameProdDownLoadDateTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);

      if SendDatetime <> EmptyStr then
      begin
        SendDatetime := StringReplace(SendDatetime, ' ', '%20', [rfReplaceAll]);
				JsonText := Send_API(mtGet, 'B202_getGameProdList?search_datetime=' + SendDatetime + '&store_cd=' + Global.Config.Store.StoreCode, EmptyStr);
      end
      else
        JsonText := Send_API(mtGet, 'B202_getGameProdList?store_cd=' + Global.Config.Store.StoreCode, EmptyStr);

      if JsonText = EmptyStr then
      begin
        if StrPos(PChar(Global.SaleModule.FApiErrorMsg), PChar('Socket Error')) <> nil then
        begin
          showmessage('요금제 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + Global.SaleModule.FApiErrorMsg);
        end;

        Exit;
      end;

      if SendDatetime <> EmptyStr then
        Log.D('상품 요금제', JsonText);

      MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' = MainJson.GetValue('result_cd').Value then
      begin
        if MainJson.FindValue('result_data') is TJSONNull then
          Exit;

        jObjArr := MainJson.GetValue('result_data') as TJsonArray;
        nCnt := jObjArr.Size;

        for Index := 0 to nCnt - 1 do
        begin
          jObj := jObjArr.Get(Index) as TJSONObject;

          if jObj.GetValue('del_yn').Value = 'Y' then
            Continue;

          if jObj.GetValue('use_yn').Value <> 'Y' then
            Continue;

          AProduct.ProdCd := jObj.GetValue('prod_cd').Value;
          AProduct.ProdNm := jObj.GetValue('prod_nm').Value;
          AProduct.ProdDetailDiv := jObj.GetValue('prod_detail_div').Value;
          AProduct.ProdDetailDivNm := jObj.GetValue('prod_detail_div_nm').Value;
          AProduct.GameDiv := jObj.GetValue('game_div').Value;
          AProduct.FeeDiv := jObj.GetValue('fee_div').Value;
          AProduct.UseGameCnt := StrToInt(jObj.GetValue('use_game_cnt').Value);
					AProduct.UseGameMin := StrToInt(jObj.GetValue('use_game_min').Value);
					AProduct.ShoesFreeYn := jObj.GetValue('shoes_free_yn').Value; //대화료 무료 여부 ksj 230728 api 수정에 맞춰 추가
					AProduct.SaleZoneCode := jObj.GetValue('sale_zone_code').Value;

          // 상품 목록만 받음. 요금제 계산시 B211 통해 해당 시간대 요금 받아옴
          { //상품 세부 요금표 제외
          jObjSubArr := jObj.GetValue('prod_price_list') as TJsonArray;
          nSubCnt := jObjSubArr.Size;
          for i := 0 to nSubCnt - 1 do
          begin
            jObjSub := jObjSubArr.Get(i) as TJSONObject;

            AProduct.ApplyDowString := jObjSub.GetValue('apply_dow_string').Value;
            AProduct.ApplyStartTime := jObjSub.GetValue('apply_start_time').Value;
            AProduct.ApplyEndTime := jObjSub.GetValue('apply_end_time').Value;
            AProduct.ProdAmt := StrToInt(jObjSub.GetValue('prod_amt').Value);
          end;
          }
          Result.Add(AProduct);
        end;
      end;

      bMsg := True;
    except
      on E: Exception do
      begin
        showmessage('요금제 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + e.Message);
      end;
    end;

  finally
    FreeAndNil(MainJson);
  end;

end;

function TErpAip.GetMemberShipProductList(var bMsg: Boolean): TList<TMemberShipProductInfo>;
var
  Index, i, WeekUse: Integer;
  MainJson, jObj, jObjSub: TJSONObject;
  jObjArr, jObjSubArr: TJsonArray;

  AProduct: TMemberShipProductInfo;
  JsonText, AVersion: string;
  nCnt, nSubCnt: Integer;
  SendDatetime: string;
begin
  try
    try
      bMsg := False;
      Result := TList<TMemberShipProductInfo>.Create;

      SendDatetime := Global.SaleModule.MemberShipDownLoadDateTime;
      Global.SaleModule.MemberShipDownLoadDateTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);

      if SendDatetime <> EmptyStr then
      begin
        SendDatetime := StringReplace(SendDatetime, ' ', '%20', [rfReplaceAll]);
        JsonText := Send_API(mtGet, 'B206_getMembershipProdList?search_datetime=' + SendDatetime + '&store_cd=' + Global.Config.Store.StoreCode, EmptyStr);
      end
      else
        JsonText := Send_API(mtGet, 'B206_getMembershipProdList?store_cd=' + Global.Config.Store.StoreCode, EmptyStr);

      if JsonText = EmptyStr then
      begin
        if StrPos(PChar(Global.SaleModule.FApiErrorMsg), PChar('Socket Error')) <> nil then
        begin
          showmessage('회원제 상품 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + Global.SaleModule.FApiErrorMsg);
        end;

        Exit;
      end;

      if SendDatetime <> EmptyStr then
        Log.D('회원용 상품', LogReplace(JsonText));

      MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' <> MainJson.GetValue('result_cd').Value then
        Exit;

      if MainJson.FindValue('result_data') is TJSONNull then
        Exit;

      jObjArr := MainJson.GetValue('result_data') as TJsonArray;
      nCnt := jObjArr.Size;

      for Index := 0 to nCnt - 1 do
      begin
        jObj := jObjArr.Get(Index) as TJSONObject;

        if SendDatetime <> EmptyStr then
        begin
          AProduct.UseYn := jObj.GetValue('use_yn').Value;
          AProduct.DelYn := jObj.GetValue('del_yn').Value;
        end
        else
        begin
          if jObj.GetValue('del_yn').Value = 'Y' then
            Continue;

          if jObj.GetValue('use_yn').Value <> 'Y' then
            Continue;

          AProduct.UseYn := 'Y';
          AProduct.DelYn := 'N';
        end;

        AProduct.ProdCd := jObj.GetValue('prod_cd').Value;
        AProduct.ProdNm := jObj.GetValue('prod_nm').Value;
        AProduct.ProdDetailDiv := jObj.GetValue('prod_detail_div').Value;            //501: 게임회원권, 502: 시간회원권, 503 : 우대회원권
        AProduct.ProdDetailDivNm := jObj.GetValue('prod_detail_div_nm').Value;

        AProduct.DiscountFeeDiv := jObj.GetValue('discount_fee_div').Value;          //할인 요금제 구분 01 : 없음, 02 : 회원, 03 : 학생, 04 : 클럽
        AProduct.ProdAmt := StrToInt(jObj.GetValue('prod_amt').Value);               //상품 금액
        AProduct.UseGameCnt := StrToInt(jObj.GetValue('use_game_cnt').Value);        //이용 게임수
        AProduct.UseGameMin := StrToInt(jObj.GetValue('use_game_min').Value);        //이용 게임 시간(분)

        AProduct.ExpireDay := StrToInt(jObj.GetValue('expire_day').Value);           //유효기간
        AProduct.ProdBenefits := jObj.GetValue('prod_benefits').Value;               //상품 혜택
        AProduct.ShoesFreeYn := jObj.GetValue('shoes_free_yn').Value;                //대화료 무료 여부
        AProduct.SavePointRate := StrToInt(jObj.GetValue('save_point_rate').Value);  //적립 포인트 율(%)

        AProduct.SaleZoneCode := jObj.GetValue('sale_zone_code').Value;              //판매처 구분

        Result.Add(AProduct);
      end;

      bMsg := True;
    except
      on E: Exception do
      begin
        showmessage('회원제 상품 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + e.Message);
      end;
    end;

  finally
    FreeAndNil(MainJson);
  end;

end;

function TErpAip.GetRentProduct: TGameProductInfo;
var
  Index: Integer;
  MainJson, jObj: TJSONObject;
  jObjArr: TJsonArray;

  AProduct: TGameProductInfo;
  JsonText: string;
  nCnt: Integer;
  SendDatetime: string;
begin
  try
    try

      SendDatetime := Global.SaleModule.ShoesProdDownLoadDateTime;
      Global.SaleModule.ShoesProdDownLoadDateTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);

      if SendDatetime <> EmptyStr then
      begin
        SendDatetime := StringReplace(SendDatetime, ' ', '%20', [rfReplaceAll]);
        JsonText := Send_API(mtGet, 'B205_getRentProdList?search_datetime=' + SendDatetime + '&store_cd=' + Global.Config.Store.StoreCode, EmptyStr);
      end
      else
        JsonText := Send_API(mtGet, 'B205_getRentProdList?store_cd=' + Global.Config.Store.StoreCode, EmptyStr);

      if JsonText = EmptyStr then
      begin
        if StrPos(PChar(Global.SaleModule.FApiErrorMsg), PChar('Socket Error')) <> nil then
        begin
          showmessage('대여상품 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + Global.SaleModule.FApiErrorMsg);
        end;

        Exit;
      end;

      //Log.D('상품 마스터', JsonText);

      MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' <> MainJson.GetValue('result_cd').Value then
        Exit;

      if MainJson.FindValue('result_data') is TJSONNull then
        Exit;

      jObjArr := MainJson.GetValue('result_data') as TJsonArray;
      nCnt := jObjArr.Size;

      for Index := 0 to nCnt - 1 do
      begin
        jObj := jObjArr.Get(Index) as TJSONObject;

        if jObj.GetValue('del_yn').Value = 'Y' then
          Continue;

        if jObj.GetValue('use_yn').Value <> 'Y' then
          Continue;

        if jObj.GetValue('shoes_yn').Value <> 'Y' then
          Continue;

        if Global.Config.Store.ShoesProdCd <> jObj.GetValue('prod_cd').Value then
          Continue;

        AProduct.ProdCd := jObj.GetValue('prod_cd').Value;
        AProduct.ProdNm := jObj.GetValue('prod_nm').Value;
        AProduct.ProdDetailDiv := jObj.GetValue('prod_detail_div').Value;
        AProduct.ProdDetailDivNm := jObj.GetValue('prod_detail_div_nm').Value;
        //AProduct.FeeDiv := jObj.GetValue('fee_div').Value;
        //AProduct.UseGameCnt := StrToInt(jObj.GetValue('use_game_cnt').Value);
        //AProduct.UseGameMin := StrToInt(jObj.GetValue('use_game_min').Value);
        AProduct.SaleZoneCode := jObj.GetValue('sale_zone_code').Value;
        AProduct.ProdAmt := StrToInt(jObj.GetValue('prod_amt').Value);

        Result := AProduct;
        Break;
      end;

    except
      on E: Exception do
      begin
        showmessage('대여상품 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + e.Message);
      end;
    end;

  finally
    FreeAndNil(MainJson);
  end;

end;

function TErpAip.GetProductAmt(AProductCd: String): TGameProductInfo;
var
  MainJson, jObj: TJSONObject;
  AProduct: TGameProductInfo;
  JsonText: string;
begin
  try
    try
			JsonText := Send_API(mtGet, 'B211_getGameProd?store_cd=' + Global.Config.Store.StoreCode + '&prod_cd=' + AProductCd, EmptyStr);

      if JsonText = EmptyStr then
      begin
        if StrPos(PChar(Global.SaleModule.FApiErrorMsg), PChar('Socket Error')) <> nil then
        begin
          showmessage('요금제 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + Global.SaleModule.FApiErrorMsg);
        end;

        Exit;
      end;

      MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' <> MainJson.GetValue('result_cd').Value then
        Exit;

      if MainJson.FindValue('result_data') is TJSONNull then
        Exit;

      jObj := MainJson.GetValue('result_data') as TJSONObject;

			AProduct.ProdCd := jObj.GetValue('prod_cd').Value;
			AProduct.ProdNm := jObj.GetValue('prod_nm').Value;
			AProduct.ProdDetailDiv := jObj.GetValue('prod_detail_div').Value;
      AProduct.ProdDetailDivNm := jObj.GetValue('prod_detail_div_nm').Value;
			AProduct.FeeDiv := jObj.GetValue('fee_div').Value;
			AProduct.ProdAmt := StrToInt(jObj.GetValue('prod_amt').Value);
			AProduct.ShoesFreeYn := jObj.GetValue('shoes_free_yn').Value; //대화료 무료 여부 ksj 230728 api 수정에 맞춰 추가

      Result := AProduct;
    except
      on E: Exception do
      begin
        showmessage('요금제 정보 다운로드중 오류가 발생하였습니다.' + #13#10 + e.Message);
      end;
    end;

  finally
    FreeAndNil(MainJson);
  end;

end;


function TErpAip.AddNewMember: Boolean;
var
  MainJson, RecvJson, jObj: TJSONObject;
  JsonText: string;
  AMemberInfo: TMemberInfo;
begin
  try
    try
      Result := False;

      JsonText := EmptyStr;
      MainJson := TJSONObject.Create;

      MainJson.AddPair(TJSONPair.Create('store_cd', Global.Config.Store.StoreCode));
      MainJson.AddPair(TJSONPair.Create('member_nm', Global.SaleModule.NewMember.Name));
      MainJson.AddPair(TJSONPair.Create('sex_div', '1'));
      MainJson.AddPair(TJSONPair.Create('birthday', Global.SaleModule.NewMember.BirthDay));
      MainJson.AddPair(TJSONPair.Create('mobile_no', Global.SaleModule.NewMember.MobileNo));
      MainJson.AddPair(TJSONPair.Create('email', ''));
      MainJson.AddPair(TJSONPair.Create('zipno', ''));
      MainJson.AddPair(TJSONPair.Create('addr', ''));
      MainJson.AddPair(TJSONPair.Create('addr2', ''));
      MainJson.AddPair(TJSONPair.Create('club_seq', 0));
      MainJson.AddPair(TJSONPair.Create('member_customer_code', ''));
      MainJson.AddPair(TJSONPair.Create('member_group_code', ''));
      MainJson.AddPair(TJSONPair.Create('fingerprint_hash', ''));
      MainJson.AddPair(TJSONPair.Create('photo_encoding', ''));
      MainJson.AddPair(TJSONPair.Create('memo', ''));
      MainJson.AddPair(TJSONPair.Create('reg_id', Global.Config.OAuth.TerminalId));

      Log.D('NewMember Add JsonText Begin', '신규 등록');
      JsonText := Send_API(mtPost, 'C003_regMember', MainJson.ToString);
      Log.D('NewMember Add JsonText End', '신규 등록 완료' + JsonText);

      if JsonText = EmptyStr then
        Exit;

      RecvJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' <> RecvJson.GetValue('result_cd').Value then
      begin
        Global.SBMessage.ShowMessage('11', '알림', RecvJson.GetValue('result_msg').Value);
        Exit;
      end;

      if RecvJson.FindValue('result_data') is TJSONNull then
        Exit;

      jObj := RecvJson.GetValue('result_data') as TJSONObject;
      AMemberInfo := Global.SaleModule.Member;
      AMemberInfo.Code := jObj.GetValue('member_no').Value;
      AMemberInfo.MemberDiv := jObj.GetValue('member_div').Value;

      Global.SaleModule.Member := AMemberInfo;

      Result := True;
    except
      on E: Exception do
      begin
        //WriteLog(True, 'ApiLog', 'C003_regMember', 'NewMemberAdd', E.Message);
        Log.D('C003_regMember Exception', E.Message);
      end;
    end;
  finally
    FreeAndNil(MainJson);
    FreeAndNil(RecvJson);
  end;
end;

procedure TErpAip.SearchAdvertisList;
var
  MainJson, jObj: TJSONObject;
  jObjArr: TJsonArray;
  AUrl, FileExtractName, FileExtractExt: string;

  JsonText: AnsiString;
  Loop, nCnt: Integer;

  AIndy: TIdHTTP;
  mStream: TMemoryStream;
  mStream2: TMemoryStream;
  WeekUse: Integer;
  ListUp, ListDown: TList<TAdvertisement>;
  AAdvertise: TAdvertisement;
  //AAdvertisement: TAdvertisement;
  sslIOHandler : TIdSSLIOHandlerSocketOpenSSL;

  function ClearListAdvertisList(AType: Integer): Boolean;
  var
    Index: Integer;
  begin
    try
      Result := False;
      if AType = 0 then
      begin
        for Index := ListUp.Count -1 downto 0 do
          ListUp.Delete(Index);

        for Index := ListDown.Count -1 downto 0 do
          ListDown.Delete(Index);
      end
      else
      begin
        for Index := Global.SaleModule.AdvertListUp.Count -1 downto 0 do
        begin
          Global.SaleModule.AdvertListUp.Delete(Index);
        end;

        for Index := Global.SaleModule.AdvertListDown.Count -1 downto 0 do
        begin
          AAdvertise := Global.SaleModule.AdvertListDown[Index];
          AAdvertise.Image.Free;

          Global.SaleModule.AdvertListDown.Delete(Index);
        end;

        for Index := 0 to ListUp.Count - 1 do
        begin
          Global.SaleModule.AdvertListUp.Add(ListUp[Index]);
        end;

        for Index := 0 to ListDown.Count - 1 do
        begin
          Global.SaleModule.AdvertListDown.Add(ListDown[Index]);
        end;
      end;

      Result := True;
    finally
    end;

  end;

begin
  try
    try

      ListUp := TList<TAdvertisement>.Create;
      ListDown := TList<TAdvertisement>.Create;

      AUrl := '?store_cd=' + Global.Config.Store.StoreCode;

      JsonText := Send_API(mtGet, 'B401_getAdvertiseList' + AUrl, EmptyStr);
      //Log.D('K231_AdvertiseList', JsonText);

      MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if MainJson.GetValue('result_cd').Value = '0000' then
      begin
        if not (MainJson.FindValue('result_data') is TJSONNull) then
        begin
          jObjArr := MainJson.GetValue('result_data') as TJsonArray;
          nCnt := jObjArr.Size;

          for Loop := 0 to nCnt - 1 do
          begin
            jObj := jObjArr.Get(Loop) as TJSONObject;


            AIndy := TIdHTTP.Create(nil);
            AIndy.IOHandler := sslIOHandler;
            mStream := TMemoryStream.Create;
            mStream2 := TMemoryStream.Create;

            AAdvertise.AdvertiseNm := jObj.GetValue('advertise_nm').Value;        // 광고 명
            AAdvertise.view_div := jObj.GetValue('view_div').Value;               //노출 위치		1:상단, 2:하단, 3:팝업
            AAdvertise.view_start_date := jObj.GetValue('view_start_date').Value; //노출 시작일		10	2022-10-01	yyyy-mm-dd
            AAdvertise.view_end_date := jObj.GetValue('view_end_date').Value;   //노출 종료일		10	2025-12-31	yyyy-mm-dd
            AAdvertise.view_dow_string := jObj.GetValue('view_dow_string').Value; //노출 요일 문자열 		7	1111111	월화수목금토일
            AAdvertise.view_start_time := jObj.GetValue('view_start_time').Value; //노출 시작 시간	 		8	05:10:00	hh:mi:ss
            AAdvertise.view_end_time := jObj.GetValue('view_end_time').Value;     //노출 종료 시간	  	8	23:10:00	hh:mi:ss
            AAdvertise.view_sec := StrToInt(jObj.GetValue('view_sec').Value);     //노출 시간(초)						I
            //수정 일시		chg_datetime				S		19
            AAdvertise.file_type := jObj.GetValue('file_type').Value;             // 1:이미지, 2:동영상, 공통코드 참조
            AAdvertise.file_url := jObj.GetValue('file_url').Value;               // https://test.bowlingpick.com/upload/aa.png

            WeekUse := DayOfWeek(Now);

            if WeekUse = 1 then
              WeekUse := 7
            else
              WeekUse := WeekUse - 1;

            if (AAdvertise.view_start_date <= FormatDateTime('yyyy-mm-dd', now)) and (FormatDateTime('yyyy-mm-dd', now) <= AAdvertise.view_end_date) then
            begin
              if (Copy(AAdvertise.view_dow_string, WeekUse, 1) = '1') then
              begin
                FileExtractName := copy(AAdvertise.file_url, Pos('advertise/', AAdvertise.file_url) + 10, length(AAdvertise.file_url));
                FileExtractExt := ExtractFileExt(AAdvertise.file_url);

                AIndy.Get(AAdvertise.file_url, mStream);

                if (FileExtractExt = '.avi') or (FileExtractExt = '.mp4') then
                  AAdvertise.FilePath := ExtractFilePath(ParamStr(0)) + '\Intro\Media\' + FileExtractName
                else
                  AAdvertise.FilePath := ExtractFilePath(ParamStr(0)) + '\Intro\' + FileExtractName;

                if (Global.SaleModule.AdvertListDown.Count = 0) and (Global.SaleModule.AdvertListUp.Count = 0) then
                begin
                  DeleteFile(AAdvertise.FilePath);
                end;

                if not FileExists(AAdvertise.FilePath) then
                  mStream.SaveToFile(AAdvertise.FilePath);

                if AAdvertise.view_div = '1' then //상단
                begin
                  if (FileExtractExt = '.avi') or (FileExtractExt = '.mp4') then
                  begin
                    ListUp.Add(AAdvertise);
                  end;
                end
                else if AAdvertise.view_div = '2' then //하단
                begin
                  AAdvertise.Image := TBitmap.CreateFromFile(AAdvertise.FilePath);
                  ListDown.Add(AAdvertise)
                end;
                
              end;
            end;

            AIndy.Free;
            mStream.Free;
            mStream2.Free;
          end;

        end;

      end;

      ClearListAdvertisList(1);

    except
      on E: Exception do
      begin
        Log.E('SearchAdvertisList', E.Message);
      end;
    end;

  finally
    ClearListAdvertisList(0);

    FreeAndNil(ListUp);
    FreeAndNil(ListDown);

    FreeAndNil(MainJson);
  end;
end;

function TErpAip.SendAdvertisCnt(ASeq: string): Boolean;
var
  MainJson: TJSONObject;
  JsonText: string;
begin
  try
    try
      MainJson := TJSONObject.Create;

      MainJson.AddPair(TJSONPair.Create('store_cd', Global.Config.Store.StoreCode));
      MainJson.AddPair(TJSONPair.Create('ad_seq', ASeq));

      JsonText := Send_API(mtPost, 'K232_AdvertiseView', MainJson.ToString);
    except
      on E: Exception do
        Log.E('SendAdvertisCnt', ASeq + ':' + E.Message);
    end;
  finally
    FreeAndNil(MainJson);
  end;
end;

function TErpAip.Send_API(MethodType: TMethodType; AUrl, AJsonText: string; NotSaveLog: Boolean): AnsiString;
var
  Indy: TIdHTTP;
  SendData, RecvData: TStringStream;
  sUrlTm: String;
begin
  try
    try
      SendData := TStringStream.Create;
      RecvData := TStringStream.Create;

      if not NotSaveLog then
      begin
        sUrlTm := StringReplace(AUrl, '%20', ' ', [rfReplaceAll]);
        Log.D('Send_API', 'Begin - ' + sUrlTm);
      end;

      Indy := TIdHTTP.Create(nil);
      Result := EmptyStr;
      SendData.Clear;
      RecvData.Clear;
      Indy.Request.CustomHeaders.Clear;
      Indy.IOHandler := sslIOHandler;
      Indy.URL.URI := Global.Config.Partners.ApiURL;
      Indy.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.Config.OAuth.Token;

      if AJsonText <> EmptyStr then
      begin
        Indy.Request.ContentType := 'application/json';
        Indy.Request.Accept := '*/*';
        SendData := TStringStream.Create(AJsonText, TEncoding.UTF8);
      end
      else
        Indy.Request.ContentType := 'application/x-www-form-urlencoded';
        //Indy.Request.ContentType := 'none';

      //chy socket test
      Indy.ConnectTimeout := 10000;
      Indy.ReadTimeout := 10000;

      if MethodType = mtGet then
        Indy.Get(Global.Config.Partners.ApiURL + AUrl, RecvData)
      else if MethodType = mtPost then
      begin
        Indy.Post(Global.Config.Partners.ApiURL + AUrl, SendData, RecvData);
      end
      else if MethodType = mtDelete then
        Indy.Delete(Global.Config.Partners.ApiURL + AUrl, RecvData);

      Result := ByteStringToString(RecvData);
      if not NotSaveLog then
        Log.D('Send_API', 'End');
    except
      on E: Exception do
      begin
        Log.E('Send_API', AUrl);
        Log.E('Send_API', E.Message);
        Global.SaleModule.FApiErrorMsg := E.Message;
      end;
    end;
  finally
    Indy.Disconnect;
    Indy.Free;
    SendData.Free;
    RecvData.Free;
  end;
end;

function TErpAip.Send_API_Reservation(MethodType: TMethodType; AUrl, AJsonText: string; NotSaveLog: Boolean): AnsiString;
var
  AIndy: TIdHTTP;
  SendData: TStringStream;
  RecvData: TStringStream;
begin
  AIndy := TIdHTTP.Create(nil);
  SendData := TStringStream.Create;
  RecvData := TStringStream.Create;
  try
    try
      if not NotSaveLog then
        Log.D('Send_API_Reservation', 'Begin - ' + AUrl);
      Result := EmptyStr;
      SendData.Clear;
      RecvData.Clear;
      AIndy.Request.CustomHeaders.Clear;
      AIndy.IOHandler := sslIOHandler;
      AIndy.URL.URI := Global.Config.Partners.ApiURL;
      AIndy.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.Config.OAuth.Token;

      if AJsonText <> EmptyStr then
      begin
        AIndy.Request.ContentType := 'application/json';
        AIndy.Request.Accept := '*/*';
        SendData := TStringStream.Create(AJsonText, TEncoding.UTF8);
      end
      else
        AIndy.Request.ContentType := 'application/x-www-form-urlencoded';

      AIndy.ConnectTimeout := 3000;
      AIndy.ReadTimeout := 3000;

      if MethodType = mtGet then
        AIndy.Get(Global.Config.Partners.ApiURL + AUrl, RecvData)
      else if MethodType = mtPost then
      begin
        AIndy.Post(Global.Config.Partners.ApiURL + AUrl, SendData, RecvData);
      end
      else if MethodType = mtDelete then
        AIndy.Delete(Global.Config.Partners.ApiURL + AUrl, RecvData);

      Result := ByteStringToString(RecvData);
      if not NotSaveLog then
        Log.D('Send_API_Reservation', 'End');
    except
      on E: Exception do
      begin
        //if StrPos(PChar(e.Message), PChar('Socket Error')) <> nil then
          Result := 'Socket Error';

        Log.E('Send_API_Reservation', AUrl);
        Log.E('Send_API_Reservation', E.Message);
      end;
    end;
  finally
    AIndy.Disconnect;
    AIndy.Free;
    SendData.Free;
    RecvData.Free;
  end;
end;

function TErpAip.GetVersion(AUrl: string): string;
var
  MainJson: TJSONObject;
  JsonValue: TJSONValue;
  JsonText: string;
begin
  try
    try
      Result := EmptyStr;
      MainJson := TJSONObject.Create;
      JsonValue := TJSONValue.Create;
      JsonText := Send_API(mtGet, AUrl, EmptyStr);

      if JsonText = EmptyStr then
        Exit;

      JsonValue := MainJson.ParseJSONValue(JsonText);
      if (JsonValue as TJSONObject).Get('result_cd').JsonValue.Value = '0000' then
      begin
        if not ((JsonValue as TJSONObject).Get('result_data').JsonValue is TJSONNull) then
        begin
          Result := ((JsonValue as TJSONObject).Get('result_data').JsonValue as TJSONObject).Get('version_no').JsonValue.Value;
        end;
      end;

    except
      on E: Exception do
      begin
        Log.E('GetVersion', AUrl);
        Log.E('GetVersion', E.Message);
      end;
    end;
  finally
    FreeAndNilJSONObject(JsonValue);
    FreeAndNilJSONObject(MainJson);
  end;
end;

function TErpAip.SaveSaleInfo: Boolean;
var
  Index, Loop, CardDiscountAmt: Integer;
  Json, MainJson, ItemObject, RecJson: TJSONObject;
  PayMentList, DataList: TJSONArray;
  ItemValue: TJSONValue;
	JsonText: string;
  ACard: TPayCard;
  APayco: TPayPayco;
	AUTF8Str: UTF8String;
	ASaleData: TSaleData;
  allianceAmt: Integer;
  //ParkingProduct: TProductInfo;

	nSocketError: Integer;
	//ksj 230803  nPaySelect 시간제에서 결제하려고 선택한 레인갯수
	nSaleQty, nGameSaleQty, nPaySelect, nDcValue: Integer;
	nSelectDcAmt, nTimeDcAmt, nPointDcAmt: Currency;
	sProdCd: string;
begin

  try
    try
      Result := False;
      JsonText := EmptyStr;
      Json := TJSONObject.Create;
      MainJson := TJSONObject.Create;
      PayMentList := TJSONArray.Create;
      DataList := TJSONArray.Create;

      CardDiscountAmt := 0;
      allianceAmt := 0;

			nSocketError := 0;

      MainJson.AddPair(TJSONPair.Create('store_cd', Global.Config.Store.StoreCode));
      MainJson.AddPair(TJSONPair.Create('receipt_no', Global.SaleModule.RcpAspNo));
      MainJson.AddPair(TJSONPair.Create('sale_dt', FormatDateTime('yyyymmdd', now)));
      MainJson.AddPair(TJSONPair.Create('sale_tm', FormatDateTime('hhnnss', now)));  //ksj 230713 초단위 추가
      MainJson.AddPair(TJSONPair.Create('terminal_id', Global.Config.OAuth.TerminalId));
      MainJson.AddPair(TJSONPair.Create('pos_no', IntToStr(Global.Config.Store.PosNo)));

      //MainJson.AddPair(TJSONPair.Create('table_no', Global.Config.OAuth.TerminalId));  //테이블 번호
      MainJson.AddPair(TJSONPair.Create('table_no', '0'));

      MainJson.AddPair(TJSONPair.Create('charge_amt', CurrToStr(Global.SaleModule.PaySelTotalAmt)));   //청구 금액
      MainJson.AddPair(TJSONPair.Create('receive_amt', CurrToStr(Global.SaleModule.PaySelRealAmt)));  //받은 금액
      MainJson.AddPair(TJSONPair.Create('dc_amt', '0'));       //할인 금액(직권)
      MainJson.AddPair(TJSONPair.Create('change_amt', '0'));   //거스름돈
      MainJson.AddPair(TJSONPair.Create('vat', CurrToStr(Global.SaleModule.PaySelVatAmt)));          //부가가치세
      MainJson.AddPair(TJSONPair.Create('member_no', Global.SaleModule.Member.Code));    //회원 번호
      MainJson.AddPair(TJSONPair.Create('sale_root_div', 'K'));                          //판매 경로 구분 ksj 230713 2->K
      MainJson.AddPair(TJSONPair.Create('memo', ''));
      MainJson.AddPair(TJSONPair.Create('reg_id', Global.Config.OAuth.TerminalId));

      MainJson.AddPair(TJSONPair.Create('payment', PayMentList));

      ItemObject := TJSONObject.Create;
      ItemObject.AddPair(TJSONPair.Create('cancel_yn', 'N'));          //취소 거래 여부
      ItemObject.AddPair(TJSONPair.Create('manual_yn', 'N'));          //임의 등록 여부
      ItemObject.AddPair(TJSONPair.Create('van_cd', IntToStr(Global.Config.Store.VanCode)));
      ItemObject.AddPair(TJSONPair.Create('tid', Global.Config.Store.VanTID));
      ItemObject.AddPair(TJSONPair.Create('approve_amt', CurrToStr(Global.SaleModule.PaySelRealAmt))); //승인 금액
      ItemObject.AddPair(TJSONPair.Create('vat', CurrToStr(Global.SaleModule.PaySelVatAmt)));          //부가가치세

      if Global.SaleModule.PayList.Count <> 0 then
      begin
        if TPayData(Global.SaleModule.PayList[0]).PayType = ptCard then
        begin
          ACard := TPayCard(Global.SaleModule.PayList[0]);
          ItemObject.AddPair(TJSONPair.Create('pay_method_div', '1')); //1:신용카드, 2:현금, 3:페이코신용카드
          ItemObject.AddPair(TJSONPair.Create('approve_no', ACard.RecvInfo.AgreeNo)); //승인 번호
          ItemObject.AddPair(TJSONPair.Create('inst_month', IntToStr(ACard.SendInfo.HalbuMonth)));//할부 개월 수
          ItemObject.AddPair(TJSONPair.Create('trade_no', ACard.RecvInfo.TransNo));//거래 번호
          ItemObject.AddPair(TJSONPair.Create('trade_dt', Copy(ACard.RecvInfo.AgreeDateTime, 1, 8)));//거래 일자
          ItemObject.AddPair(TJSONPair.Create('card_no', ACard.RecvInfo.CardNo));//신용카드 번호
          ItemObject.AddPair(TJSONPair.Create('card_issuer_cd', ACard.RecvInfo.BalgupsaCode));//신용카드 발급사 코드
          ItemObject.AddPair(TJSONPair.Create('card_issuer_nm', ACard.RecvInfo.BalgupsaName));//산용카드 발급사 명
          ItemObject.AddPair(TJSONPair.Create('card_acquir_cd', ACard.RecvInfo.CompCode));//신용카드 매입사 코드
          ItemObject.AddPair(TJSONPair.Create('card_acquir_nm', ACard.RecvInfo.CompName));//신용카드 매입사 명
        end
        else
        begin
          APayco := TPayPayco(Global.SaleModule.PayList[0]);
          ItemObject.AddPair(TJSONPair.Create('pay_method', '3'));
          ItemObject.AddPair(TJSONPair.Create('approve_no', APayco.RecvInfo.AgreeNo));
          ItemObject.AddPair(TJSONPair.Create('inst_month', APayco.RecvInfo.HalbuMonth));
          ItemObject.AddPair(TJSONPair.Create('trade_no', APayco.RecvInfo.TradeNo));
          ItemObject.AddPair(TJSONPair.Create('trade_dt', Copy(APayco.RecvInfo.TransDateTime, 1, 8)));
          ItemObject.AddPair(TJSONPair.Create('card_no', APayco.RecvInfo.RevCardNo));
          ItemObject.AddPair(TJSONPair.Create('card_issuer_cd', APayco.RecvInfo.ApprovalCompanyCode));
          ItemObject.AddPair(TJSONPair.Create('card_issuer_nm',APayco.RecvInfo.ApprovalCompanyName));
          ItemObject.AddPair(TJSONPair.Create('card_acquir_cd', APayco.RecvInfo.BuyCompanyCode)); //2021-10-13 매입사코드 추가
          ItemObject.AddPair(TJSONPair.Create('card_acquir_nm', APayco.RecvInfo.BuyCompanyName));
        end;
        PayMentList.Add(ItemObject);
      end;

      MainJson.AddPair(TJSONPair.Create('orders', DataList));

			if Global.SaleModule.memberItemType = mitBuy then
			begin
        ItemObject := TJSONObject.Create;
				ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.SaleSelectMemberShipProd.ProdCd));         //상품 코드
				ItemObject.AddPair(TJSONPair.Create('sale_qty', '1'));        //판매 수량
        ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.SaleSelectMemberShipProd.ProdAmt)));      //상품 단가
				ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));     //품목 할인
				ItemObject.AddPair(TJSONPair.Create('use_point', 0));
        ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
        ItemObject.AddPair(TJSONPair.Create('member_no', Global.SaleModule.Member.Code));       //회원 번호
        DataList.Add(ItemObject);
      end
      else
			begin
        if Global.SaleModule.GameItemType = gitGameTime then
				begin
					nSaleQty := 0;
					nGameSaleQty := 0;
					nSelectDcAmt := 0;
					nTimeDcAmt := 0;
					nPointDcAmt := 0;
					nDcValue := 0;

					if Global.SaleModule.GameInfo.LaneUse = '2' then
						nPaySelect := 2
					else
            nPaySelect := 1;

          for Index := 0 to Global.SaleModule.PayProductList.Count - 1 do
					begin
						if Global.SaleModule.PayProductList[Index].PaySelect = True then
						begin
              if nPaySelect <> 1 then
								nPaySelect := 2;
						end
						else //PaySelect = True 하나라도 False이면 레인 하나만 먼저결제
							nPaySelect := 1;
					end;

          if nPaySelect = 2 then
						nGameSaleQty := 2
					else
						nGameSaleQty := 1;

//					for Index := 0 to Global.SaleModule.PayProductList.Count - 1 do
//					begin //ksj 230803 시간제에서 dc상품에 따라 보내는 데이터값을 다르게
//						if Global.SaleModule.PayProductList[Index].PaySelect = True then
//						begin
//							if Global.SaleModule.PayProductList[Index].DcProduct.ProdCd = '' then
//								sProdCd := ''
//							else if Global.SaleModule.PayProductList[Index].DcProduct.ProdDetailDiv = '502' then
//								sProdCd := 'T'
//							else if Global.SaleModule.PayProductList[Index].DcProduct.ProdCd = 'P' then
//								sProdCd := 'P';
//
//							if sProdCd <> '' then
//								Break;
//						end
//					end;

					for Index := 0 to Global.SaleModule.PayProductList.Count - 1 do
					begin
						if Global.SaleModule.PayProductList[Index].PaySelect = True then
						begin //ksj 230828 json만들기전에 이용권 총 개수/ 사용할 포인트 총합 계산
							if Global.SaleModule.PayProductList[Index].DcProduct.ProdDetailDiv = '502' then
							begin
								nTimeDcAmt := nTimeDcAmt + Global.SaleModule.PayProductList[Index].DcAmt;
								nDcValue := nDcValue + Global.SaleModule.PayProductList[Index].DiscountList[0].DcValue;
							end
							else if Global.SaleModule.PayProductList[Index].DcProduct.ProdCd = 'P' then
								nPointDcAmt := nPointDcAmt + Global.SaleModule.PayProductList[Index].DcAmt;
						end
					end;

					if (nTimeDcAmt > 0) and (nPointDcAmt = 0) then
					begin //시간권만 사용, 게임요금 다 차감한경우 매출등록안함
						if (Global.SaleModule.PayProductList[0].SaleQty * nGameSaleQty) * Global.SaleModule.PayProductList[0].GameProduct.ProdAmt = nTimeDcAmt then
						begin
							for Index := 0 to Global.SaleModule.PayProductList.Count - 1 do
							begin
								if Global.SaleModule.PayProductList[Index].PaySelect = True then
								begin
									if Global.SaleModule.PayProductList[Index].ShoesUse = 'Y' then
									begin
										if Global.SaleModule.PayProductList[Index].ShoesUse <> 'F' then  //품목 할인
											nSaleQty := nSaleQty + 1;
									end;
								end;
							end;
							if nSaleQty > 0 then
							begin
								ItemObject := TJSONObject.Create;
								ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.SaleShoesProd.ProdCd));         //상품 코드
								ItemObject.AddPair(TJSONPair.Create('sale_qty', IntToStr(nSaleQty) ));        //판매 수량
								ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.SaleShoesProd.ProdAmt)));      //상품 단가
								ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));
								ItemObject.AddPair(TJSONPair.Create('use_point', 0));
								ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
								ItemObject.AddPair(TJSONPair.Create('member_no', ''));       //회원 번호

								DataList.Add(ItemObject);
							end;

              Log.D('Sale Save JsonText Begin', '매출 저장');
							Log.D('Sale Save JsonText Begin', LogReplace(MainJson.ToString));
							//WriteLog(False, 'ApiLog', Global.SaleModule.SaleDate, 'SaleSave', LogReplace(MainJson.ToString));
							JsonText := Send_API_Reservation(mtPost, 'G001_regSales', MainJson.ToString);
							//WriteLog(False, 'ApiLog', Global.SaleModule.SaleDate, 'SaleSave', LogReplace(JsonText));
							Log.D('Sale Save JsonText End', LogReplace(JsonText));

							if JsonText = EmptyStr then
								Exit;

							RecJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;
							if '0000' <> RecJson.GetValue('result_cd').Value then
							begin
								Global.SBMessage.ShowMessage('11', '알림', RecJson.GetValue('result_msg').Value);
								Global.SaleModule.SaleUploadFail := True;
								Exit;
							end;

							Result := True;

              FreeAndNil(MainJson);
							FreeAndNil(RecJson);
              Exit;
						end;
					end;
          //ksj 230828 시간제 매출등록
					ItemObject := TJSONObject.Create;
					ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.PayProductList[0].GameProduct.ProdCd));

					if nTimeDcAmt > 0 then
					begin
            if (Global.SaleModule.GameInfo.LaneUse = '2') and (nPaySelect = 2) then
							ItemObject.AddPair(TJSONPair.Create('sale_qty', Global.SaleModule.PayProductList[0].SaleQty * 2 - nDcValue))
						else
							ItemObject.AddPair(TJSONPair.Create('sale_qty', Global.SaleModule.PayProductList[0].SaleQty - nDcValue));
					end
					else
					begin
						if (Global.SaleModule.GameInfo.LaneUse = '2') and (nPaySelect = 2) then
							ItemObject.AddPair(TJSONPair.Create('sale_qty', Global.SaleModule.PayProductList[0].SaleQty * 2))
						else
							ItemObject.AddPair(TJSONPair.Create('sale_qty', Global.SaleModule.PayProductList[0].SaleQty));
					end;

					ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.PayProductList[0].GameProduct.ProdAmt)));      //상품 단가
					ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));     //품목 할인

					if (Global.SaleModule.PayProductList[0].PaySelect = True) and (Global.SaleModule.PayProductList[0].DcProduct.ProdCd = 'P') then
						ItemObject.AddPair(TJSONPair.Create('use_point', Global.SaleModule.PayProductList[0].DcAmt))
					else
						ItemObject.AddPair(TJSONPair.Create('use_point', 0));

					ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부

          if (Global.SaleModule.PayProductList[0].PaySelect = True) and (Global.SaleModule.PayProductList[0].DcProduct.ProdCd = 'P') then
						ItemObject.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[0].MemberInfo.Code))       //회원 번호
					else
						ItemObject.AddPair(TJSONPair.Create('member_no', ''));

					DataList.Add(ItemObject);

          for Index := 1 to Global.SaleModule.PayProductList.Count - 1 do
					begin
						if Global.SaleModule.PayProductList.Count > 1 then
						begin
							if Global.SaleModule.PayProductList[Index].DcProduct.ProdCd = 'P' then
							begin //여러명이 포인트 사용했을때
								if Global.SaleModule.PayProductList[Index].PaySelect = True then
								begin
									ItemObject := TJSONObject.Create;
									ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.PayProductList[0].GameProduct.ProdCd));
									ItemObject.AddPair(TJSONPair.Create('sale_qty', 0));
									ItemObject.AddPair(TJSONPair.Create('unit_price', '0'));      //상품 단가
									ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));     //품목 할인
									ItemObject.AddPair(TJSONPair.Create('use_point', Global.SaleModule.PayProductList[Index].DcAmt)); //사용하는 포인트를 넣어야함
									ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
									ItemObject.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[Index].MemberInfo.Code));

									DataList.Add(ItemObject);
								end;
							end;
						end;
					end;

					for Index := 0 to Global.SaleModule.PayProductList.Count - 1 do
					begin
						if Global.SaleModule.PayProductList[Index].PaySelect = True then
						begin
							if Global.SaleModule.PayProductList[Index].ShoesUse = 'Y' then
							begin
								if Global.SaleModule.PayProductList[Index].ShoesUse <> 'F' then  //품목 할인
									nSaleQty := nSaleQty + 1;
							end;
						end;
					end;
					if nSaleQty > 0 then
					begin
						ItemObject := TJSONObject.Create;
						ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.SaleShoesProd.ProdCd));         //상품 코드
						ItemObject.AddPair(TJSONPair.Create('sale_qty', IntToStr(nSaleQty) ));        //판매 수량
						ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.SaleShoesProd.ProdAmt)));      //상품 단가
						ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));
						ItemObject.AddPair(TJSONPair.Create('use_point', 0));
						ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
						ItemObject.AddPair(TJSONPair.Create('member_no', ''));       //회원 번호

						DataList.Add(ItemObject);
					end;
				end
				else
				begin //게임제에서도 포인트로 게임요금 차감한 경우는 주문리스트가 있어야함
					for Index := 0 to Global.SaleModule.PayProductList.Count - 1 do
					begin
						if Global.SaleModule.PayProductList[Index].PaySelect = True then
						begin
							if Global.SaleModule.PayProductList[Index].DcAmt > 0 then
							begin
								if Global.SaleModule.PayProductList[Index].DcProduct.ProdCd = 'P' then
								begin
									ItemObject := TJSONObject.Create;
									ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.PayProductList[Index].GameProduct.ProdCd));         //상품 코드
									ItemObject.AddPair(TJSONPair.Create('sale_qty', Global.SaleModule.PayProductList[Index].SaleQty));
									ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.PayProductList[Index].GameProduct.ProdAmt)));      //상품 단가
									ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));     //품목 할인
									ItemObject.AddPair(TJSONPair.Create('use_point', Global.SaleModule.PayProductList[Index].DcAmt));
									ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
									ItemObject.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[Index].MemberInfo.Code));       //회원 번호

									DataList.Add(ItemObject);
								end
								else if Global.SaleModule.PayProductList[Index].SaleQty * Global.SaleModule.PayProductList[Index].GameProduct.ProdAmt <> Global.SaleModule.PayProductList[Index].DiscountList[0].DcAmt then
								begin
									ItemObject := TJSONObject.Create;
									ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.PayProductList[Index].GameProduct.ProdCd));         //상품 코드
									//3게임치는 사람이 2게임차감후 1게임 결제할때 판매수량변경.포인트일때는 판매수량은 그대로
									ItemObject.AddPair(TJSONPair.Create('sale_qty', Global.SaleModule.PayProductList[Index].SaleQty - Global.SaleModule.PayProductList[Index].DiscountList[0].DcValue));
									ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.PayProductList[Index].GameProduct.ProdAmt)));      //상품 단가
									ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));     //품목 할인
									ItemObject.AddPair(TJSONPair.Create('use_point', 0));
									ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
									ItemObject.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[Index].MemberInfo.Code));       //회원 번호

									DataList.Add(ItemObject);
								end;
							end
							else
							begin
								if Global.SaleModule.PayProductList[Index].PaySelect = True then
								begin
									ItemObject := TJSONObject.Create;
									ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.PayProductList[Index].GameProduct.ProdCd));         //상품 코드
									ItemObject.AddPair(TJSONPair.Create('sale_qty', Global.SaleModule.PayProductList[Index].SaleQty));        //판매 수량
									ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.PayProductList[Index].GameProduct.ProdAmt)));      //상품 단가
									ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));     //품목 할인
									ItemObject.AddPair(TJSONPair.Create('use_point', 0));
									ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
									ItemObject.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[Index].MemberInfo.Code));       //회원 번호

									DataList.Add(ItemObject);
								end;
							end;
						end;

						if Global.SaleModule.PayProductList[Index].PaySelect = True then
						begin
							if Global.SaleModule.PayProductList[Index].ShoesUse = 'Y' then
							begin
								if Global.SaleModule.PayProductList[Index].ShoesUse <> 'F' then  //품목 할인
								begin
									ItemObject := TJSONObject.Create;
									ItemObject.AddPair(TJSONPair.Create('prod_cd', Global.SaleModule.SaleShoesProd.ProdCd));         //상품 코드
									ItemObject.AddPair(TJSONPair.Create('sale_qty', '1'));        //판매 수량
									ItemObject.AddPair(TJSONPair.Create('unit_price', CurrToStr(Global.SaleModule.SaleShoesProd.ProdAmt)));      //상품 단가
									ItemObject.AddPair(TJSONPair.Create('item_dc_amt', '0'));
                  ItemObject.AddPair(TJSONPair.Create('use_point', 0));
									ItemObject.AddPair(TJSONPair.Create('service_yn', 'N'));     //서비스 여부
									ItemObject.AddPair(TJSONPair.Create('member_no', Global.SaleModule.PayProductList[Index].MemberInfo.Code));       //회원 번호

									DataList.Add(ItemObject);
								end;
							end;
						end;
					end;
				end;
			end;

			Log.D('Sale Save JsonText Begin', '매출 저장');
			Log.D('Sale Save JsonText Begin', LogReplace(MainJson.ToString));
			//WriteLog(False, 'ApiLog', Global.SaleModule.SaleDate, 'SaleSave', LogReplace(MainJson.ToString));
			JsonText := Send_API_Reservation(mtPost, 'G001_regSales', MainJson.ToString);
			//WriteLog(False, 'ApiLog', Global.SaleModule.SaleDate, 'SaleSave', LogReplace(JsonText));
			Log.D('Sale Save JsonText End', LogReplace(JsonText));

			if JsonText = EmptyStr then
				Exit;

			RecJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;
			if '0000' <> RecJson.GetValue('result_cd').Value then
			begin
				Global.SBMessage.ShowMessage('11', '알림', RecJson.GetValue('result_msg').Value);
        Global.SaleModule.SaleUploadFail := True;
        Exit;
      end;

      Result := True;
    except
      on E: Exception do
      begin
        //Socket Error # 10060 Connection timed out.

        Global.SaleModule.SaleUploadFail := True;
        //WriteLog(True, 'ApiLog', Global.SaleModule.SaleDate, 'SaleSave', E.Message);
        Log.D('Sale Save JsonText Begin', LogReplace(MainJson.ToString));
        Log.E('SaveSaleInfo', JsonText);
        Global.SBMessage.ShowMessage('12', '알림', '업로드에 실패하였습니다.' + #13#10 + '하단의 영수증 지참 후 반드시' + #13#10 + '프론트에 문의하여 주시기 바랍니다.' + #13#10 + '감사합니다.');
      end;
    end;
  finally
    FreeAndNil(MainJson);
		FreeAndNil(RecJson);
  end;

end;


function TErpAip.SearchCardDiscount(ACardNo, ACardAmt, ASeatProductDiv: string; out ACode, AMsg: string): Currency;
var
  MainJson: TJSONObject;
  ItemValue: TJSONValue;
  JsonText, AUrl: string;
begin
  try
    try
      Log.D('SearchCardDiscount CardNo', ACardNo);
      Result := 0;
      ACode := EmptyStr;
      AMsg := EmptyStr;
      MainJson := TJSONObject.Create;

      ACardNo := Copy(ACardNo, 1, 6);

      AUrl := 'K608_PromotionCardBin?store_cd=' + Global.Config.Store.StoreCode +
              '&bin_no=' + ACardNo + '&apply_amt=' + ACardAmt + '&seat_product_div=' + ASeatProductDiv;

      JsonText := Send_API(mtGet, AUrl, EmptyStr);

      if JsonText = EmptyStr then
        Exit;

      Log.D('SearchCardDiscount JsonText', JsonText);

      if (MainJson.ParseJSONValue(JsonText) as TJSONObject).Get('result_cd').JsonValue.Value = '0000' then
      begin
        if MainJson.ParseJSONValue(JsonText).FindValue('result_data') is TJSONNull then
          Exit;

        ItemValue := (MainJson.ParseJSONValue(JsonText) as TJSONObject).Get('result_data').JsonValue;

        if (ItemValue as TJSONObject).Get('kiosk_use_yn').JsonValue.Value = 'Y' then
        begin
          ACode := (ItemValue as TJSONObject).Get('pc_seq').JsonValue.Value;
          Result := StrToIntDef((ItemValue as TJSONObject).Get('dc_amt').JsonValue.Value, 0);
        end;
      end;
    except
      on E: Exception do
      begin
        Log.E('SearchCardDiscount', AUrl);
        Log.E('SearchCardDiscount', E.Message);
      end;
    end;
  finally
    FreeAndNil(MainJson);
  end;
end;

(*
function TErpAip.GetTeeBoxProductTime(AProductCd: string; out ACode, AMsg: string): TProductInfo;
var
  MainJson, jObj: TJSONObject;
  AProductInfo: TProductInfo;
  JsonText: string;

  sUrl: String;
  sEndTime, CheckTime: String;
begin
  try
    Log.D('GetTeeBoxProductTime', LogReplace(AProductCd));

    if global.Config.ProductTime = False then //배정시간 기준
    begin
      {
      if Global.SaleModule.TeeBoxInfo.BtweenTime <> 0 then //타석 전체 잔여시간
      begin
        sEndTime := StringReplace(Global.SaleModule.TeeBoxInfo.End_Time, ':', '', [rfReplaceAll]);
        if FormatDateTime('hhnn', now) > sEndTime then //익일
          CheckTime := FormatDateTime('yyyymmdd', now + 1) + sEndTime + '00'
        else
          CheckTime := FormatDateTime('yyyymmdd', now) + sEndTime + '00'
      end
      else}
      begin
        CheckTime := FormatDateTime('yyyymmddhhnn', now) + '00';
      end;
    end
    else
    begin
      CheckTime := FormatDateTime('yyyymmddhhnn', now) + '00';
    end;

    //sUrl := 'K222_TeeBoxProductTime?store_cd=' + Global.Config.Store.StoreCode + '&product_cd=' + AProductCd + '&reserve_datetime=' + CheckTime + '&teebox_no=' + IntToStr(Global.SaleModule.TeeBoxInfo.TasukNo);
    JsonText := Send_API(mtGet, sUrl, EmptyStr);

    if JsonText = EmptyStr then
      Exit;

    Log.D('GetTeeBoxProductTime JsonText', LogReplace(JsonText));

    MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;
    ACode := MainJson.GetValue('result_cd').Value;
    AMsg := MainJson.GetValue('result_msg').Value;

    if ACode <> '0000' then
      Exit;

    jObj := MainJson.GetValue('result_data') as TJSONObject;

    AProductInfo.UseWeek := jObj.GetValue('use_div').Value;
    AProductInfo.One_Use_Time := jObj.GetValue('one_use_time').Value;
    AProductInfo.Start_Time := jObj.GetValue('start_time').Value;
    AProductInfo.End_Time := jObj.GetValue('end_time').Value;

    Result := AProductInfo;

  finally
    FreeAndNil(MainJson);
  end;

end;
*)

function TErpAip.GetAvailableForSales: String; // 회원의 상품 사용가능 여부
var
  MainJson: TJSONObject;
  JsonText, sStr: string;
  i: Integer;
  sMembershipSeq, sUsePoint, sSaleQty: String;
  rSaleData: TSaleData;
begin
  try
    Result := 'fail';

    for i := 0 to Global.SaleModule.PayProductList.Count - 1 do
    begin
      rSaleData := Global.SaleModule.PayProductList[i];

      if rSaleData.PayResult = True then
        Continue;

      if rSaleData.PaySelect = False then
        Continue;

      if rSaleData.MemberInfo.Code = '' then
        Continue;


      if rSaleData.DiscountList.Count = 0 then
        Continue;

      sUsePoint := '0';
      sSaleQty := '0';
      if rSaleData.DiscountList[0].DcType = 'P' then
      begin
        sMembershipSeq := '0';
        sUsePoint := IntToStr(rSaleData.DiscountList[0].DcValue);
      end
      else if rSaleData.DiscountList[0].DcType = 'C' then
      begin
        sMembershipSeq := IntToStr(rSaleData.DcProduct.MembershipSeq);
        sSaleQty := IntToStr(rSaleData.DiscountList[0].DcValue);
      end
      else if rSaleData.DiscountList[0].DcType = 'T' then
      begin
        sMembershipSeq := IntToStr(rSaleData.DcProduct.MembershipSeq);
        //sSaleQty := IntToStr(rSaleData.DiscountList[0].DcValue);
      end;

      sStr := 'G005_getAvailableForSales?store_cd=' + Global.Config.Store.StoreCode +
                                       '&member_no=' + rSaleData.MemberInfo.Code +
                                       '&membership_seq=' + sMembershipSeq +
                                       '&use_point=' + sUsePoint +
                                       '&prod_cd=' + rSaleData.GameProduct.ProdCd +
                                       '&sale_qty=' + sSaleQty;

			JsonText := Send_API(mtGet, sStr, EmptyStr, True);
      Log.D('회원상품 사용가능여부', JsonText);

      if JsonText = EmptyStr then
        Exit;

      MainJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' <> MainJson.GetValue('result_cd').Value then
      begin
        Result := rSaleData.MemberInfo.Name + ' : ' + MainJson.GetValue('result_msg').Value;
        FreeAndNil(MainJson);
        Exit;
      end;
      FreeAndNil(MainJson);

    end;

    Result := 'success';
  finally

  end;
end;

function TErpAip.GetAvailableForSalesList: String; // 회원의 상품 사용가능 여부
var
  MainJson, JsonItem, RecJson, RecJsonItem: TJSONObject;
  DataList: TJSONArray;
  JsonText: string;
  i: Integer;
  sMembershipSeq, sUsePoint, sSaleQty: String;
  rSaleData: TSaleData;
  bSend: Boolean;
begin

  try
    try

      Result := 'fail';
      bSend := False;

      MainJson := TJSONObject.Create;
      DataList := TJSONArray.Create;
      MainJson.AddPair(TJSONPair.Create('salesList', DataList));

      for i := 0 to Global.SaleModule.PayProductList.Count - 1 do
      begin
        rSaleData := Global.SaleModule.PayProductList[i];

        if rSaleData.PayResult = True then
          Continue;

        if rSaleData.PaySelect = False then
          Continue;

        if rSaleData.MemberInfo.Code = '' then
          Continue;

        if rSaleData.DiscountList.Count = 0 then
          Continue;

        sMembershipSeq := '0';
        sUsePoint := '0';
        sSaleQty := '0';
        if rSaleData.DiscountList[0].DcType = 'P' then
        begin
          sUsePoint := IntToStr(rSaleData.DiscountList[0].DcValue);
        end
        else // 'C' 'T'
        begin
          sMembershipSeq := IntToStr(rSaleData.DcProduct.MembershipSeq);
          sSaleQty := IntToStr(rSaleData.DiscountList[0].DcValue);
        end;

        JsonItem := TJSONObject.Create;
        JsonItem.AddPair(TJSONPair.Create('store_cd', Global.Config.Store.StoreCode));
        JsonItem.AddPair(TJSONPair.Create('member_no', rSaleData.MemberInfo.Code));
        JsonItem.AddPair(TJSONPair.Create('membership_seq', sMembershipSeq));
        JsonItem.AddPair(TJSONPair.Create('use_point', sUsePoint));
        JsonItem.AddPair(TJSONPair.Create('prod_cd', rSaleData.GameProduct.ProdCd));
        JsonItem.AddPair(TJSONPair.Create('sale_qty', sSaleQty));
        DataList.Add(JsonItem);

        bSend := True;
      end;

      if bSend = False then
      begin
        Result := 'success';
        Exit;
      end;

      Log.D('G006_getAvailableForSalesList Begin', LogReplace(MainJson.ToString));
      JsonText := Send_API_Reservation(mtPost, 'G006_getAvailableForSalesList', MainJson.ToString);
      Log.D('G006_getAvailableForSalesList End', LogReplace(JsonText));

      if JsonText = EmptyStr then
        Exit;

      RecJson := TJSONObject.ParseJSONValue(JsonText) as TJSONObject;

      if '0000' <> RecJson.GetValue('result_cd').Value then
      begin
        RecJsonItem := RecJson.GetValue('result_data')  as TJSONObject;
        Result := RecJsonItem.GetValue('unavailable_reason').Value;
        FreeAndNil(RecJson);
        Exit;
      end;

      Result := 'success';

    except
      on E: Exception do
      begin
        Log.E('G006_getAvailableForSalesList', E.Message);
      end;
    end;

  finally
    FreeAndNil(MainJson);
  end;

end;

end.
