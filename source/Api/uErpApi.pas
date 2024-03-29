unit uErpApi;

interface

uses
  System.SysUtils, System.Classes, JSON, IdHTTP, IdSSL, IdGlobal, IdSSLOpenSSL, IdSSLOpenSSLHeaders;

type
  TApiServer = class
  private
    FSSL: TIdSSLIOHandlerSocketOpenSSL;
    FToken: String;
    FSocketError: Boolean;
    FJsonLog: String;

    FjObj: TJSONObject;
  public
    constructor Create;
    destructor Destroy; override;

    function GetOauth2(var AToken: AnsiString; AApiUrl, AUserId, AUserPw: String): String;
    function GetTokenChk(AApiUrl, AUserId, AUserPw, AADToken: String): String;

    function SetErpApiJsonData(AJsonStr: AnsiString; AErpApi: String; AApiUrl: String; AADToken: String): String;
    function SetErpApiNoData(AJsonStr: AnsiString; AErpApi, AApiUrl, AADToken: String): String;
    function GetErpApi(AJsonStr: AnsiString; AErpApi: String; AApiUrl: String; AGSToken: String): String;

    property SocketError: Boolean read FSocketError write FSocketError;
  end;

implementation

uses
  EncdDecd, IdURI,
  uFunction, uStruct;

{ TApiServer }

constructor TApiServer.Create;
begin
  FSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  FSSL.SSLOptions.Method := sslvSSLv23;
  FSSL.SSLOptions.Mode := sslmClient;

  FSocketError := False;
end;

destructor TApiServer.Destroy;
begin
  FSSL.Free;

  inherited;
end;

function TApiServer.GetOauth2(var AToken: AnsiString; AApiUrl, AUserId, AUserPw: String): String;
var
  ssData: TStringStream;
  ssTemp: TStringStream;
  jObj: TJSONObject;
  jValue: TJSONValue;
  sAuthorization: AnsiString;
  sOauthUtf8: UTF8String;
begin
  Result := 'Fail';

  with TIdHTTP.Create(nil) do
  try
    try
      IOHandler := FSSL;

      ssData := TStringStream.Create('');
      ssTemp := TStringStream.Create('');

      sOauthUtf8 := UTF8String(AUserId + ':' + AUserPw);
      sAuthorization := EncdDecd.EncodeBase64(PAnsiChar(sOauthUtf8), Length(sOauthUtf8));

      Request.ContentType := 'application/x-www-form-urlencoded';
      Request.CustomHeaders.Values['Authorization'] := 'Basic ' + sAuthorization;

      ConnectTimeout := 2000;
      ReadTimeout := 2000;

      ssData.WriteString(TIdURI.ParamsEncode('grant_type=client_credentials'));
      Post(AApiUrl + '/oauth/token', ssData, ssTemp);

      jObj := TJSONObject.ParseJSONValue( ssTemp.DataString ) as TJSONObject;
      jValue := jObj.GetValue('access_token');
      AToken := jValue.Value;

      FreeAndNil(jObj);
      Result := 'Success';
    except
      //401 Unauthorized, 403 Forbidden, 404 Not Found,  505 HTTP Version Not
      on e: Exception do
      begin
        Result := 'GetOauth2 Exception : ' + e.Message;
      end;
    end
  finally
    FreeAndNil(ssData);
    FreeAndNil(ssTemp);
    Disconnect;
    Free;
  end;

end;

function TApiServer.GetTokenChk(AApiUrl, AUserId, AUserPw, AADToken: String): String;
var
  ssData: TStringStream;
  ssTemp: TStringStream;
  jObj: TJSONObject;
  jValue: TJSONValue;
  sAuthorization: AnsiString;
  sOauthUtf8: UTF8String;
  sStr: AnsiString;
begin
  Result := 'Fail';

  with TIdHTTP.Create(nil) do
  try
    try
      IOHandler := FSSL;
      ssData := TStringStream.Create('');
      ssTemp := TStringStream.Create('');

      sOauthUtf8 := UTF8String(AUserId + ':' + AUserPw);
      sAuthorization := EncdDecd.EncodeBase64(PAnsiChar(sOauthUtf8), Length(sOauthUtf8));

      Request.ContentType := 'application/x-www-form-urlencoded';
      Request.CustomHeaders.Values['Authorization'] := 'Basic ' + sAuthorization;

      ConnectTimeout := 2000;
      ReadTimeout := 2000;

      ssData.WriteString(TIdURI.ParamsEncode('token=' + AADToken));
      Post(AApiUrl + '/oauth/check_token', ssData, ssTemp);

      jObj := TJSONObject.ParseJSONValue( ssTemp.DataString ) as TJSONObject;
      jValue := jObj.GetValue('client_id');
      Result := 'Success';
    except
      on e: Exception do
      begin
        Result := 'GetTokenChk Exception : ' + e.Message;
      end;
    end
  finally
    FreeAndNil(ssData);
    FreeAndNil(ssTemp);
    FreeAndNil(jObj);
    Disconnect;
    Free;
  end;

end;

function TApiServer.SetErpApiJsonData(AJsonStr: AnsiString; AErpApi: String; AApiUrl: String; AADToken: String): String;
var
  ssData, ssTemp: TStringStream;
  sUrl: String;
  sRecvData: AnsiString;
begin
  with TIdHTTP.Create(nil) do
  try
    try
      Result := 'Fail';

      IOHandler := FSSL;

      //ssData := TStringStream.Create('');
      ssTemp := TStringStream.Create('');

      //ssData.WriteString(AJsonStr);
      ssData := TStringStream.Create(AJsonStr, TEncoding.UTF8);

      Request.ContentType := 'application/json';
      Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + AADToken;

      ConnectTimeout := 2000;
      ReadTimeout := 2000;

      sUrl := AApiUrl + '/pick/api/' + AErpApi;
      Post(sUrl, ssData, ssTemp);

      sRecvData := TEncoding.UTF8.GetString(ssTemp.Bytes, 0, ssTemp.Size);

      Result := sRecvData;
    except
      on e: Exception do
      begin
        if StrPos(PChar(e.Message), PChar('Socket Error')) <> nil then
          FSocketError := True;

        Result := 'Exception : ' + AErpApi + ' / ' + e.Message;
      end;
    end

  finally
    FreeAndNil(ssData);
    FreeAndNil(ssTemp);
    Disconnect;
    Free;
  end;
end;

function TApiServer.SetErpApiNoData(AJsonStr: AnsiString; AErpApi, AApiUrl, AADToken: String): String;
var
  ssData, ssTemp: TStringStream;
  sUrl: String;
  sRecvData: AnsiString;
  jRecv: TJSONObject;
  sRecvResultCd, sRecvResultMsg: String;
begin
  with TIdHTTP.Create(nil) do
  try
    try
      Result := 'Fail';

      IOHandler := FSSL;
      ssTemp := TStringStream.Create('');
      ssData := TStringStream.Create(AJsonStr, TEncoding.UTF8);

      Request.ContentType := 'application/json';
      Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + AADToken;

      ConnectTimeout := 2000;
      ReadTimeout := 2000;

      sUrl := AApiUrl + '/pick/api/' + AErpApi;
      Post(sUrl, ssData, ssTemp);

      sRecvData := TEncoding.UTF8.GetString(ssTemp.Bytes, 0, ssTemp.Size);

      if (Copy(sRecvData, 1, 1) <> '{') or (Copy(sRecvData, Length(sRecvData), 1) <> '}') then
      begin
        Result := sRecvData;
        Exit;
      end;

      jRecv := TJSONObject.ParseJSONValue(sRecvData) as TJSONObject;
      sRecvResultCd := jRecv.GetValue('result_cd').Value;
      sRecvResultMsg := jRecv.GetValue('result_msg').Value;

      if sRecvResultCd <> '0000' then
      begin
        Result := '[' + sRecvResultCd + ']' + sRecvResultMsg;
        FreeAndNil(jRecv);
        Exit;
      end;

      FreeAndNil(jRecv);

      Result := 'Success';
    except
      on e: Exception do
      begin
        if StrPos(PChar(e.Message), PChar('Socket Error')) <> nil then
          FSocketError := True;

        Result := 'Exception : ' + AErpApi + ' / ' + e.Message;
      end;
    end

  finally
    FreeAndNil(ssData);
    FreeAndNil(ssTemp);
    Disconnect;
    Free;
  end;
end;

function TApiServer.GetErpApi(AJsonStr: AnsiString; AErpApi: String; AApiUrl: String; AGSToken: String): String;
var
  ssTemp: TStringStream;
  sUrl: String;
  sRecvData: AnsiString;
begin
  with TIdHTTP.Create(nil) do
  try
    try
      Result := 'Fail';
      IOHandler := FSSL;

      ssTemp := TStringStream.Create('');

      Request.ContentType := 'application/x-www-form-urlencoded';
      Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + AGSToken;

      ConnectTimeout := 2000;
      ReadTimeout := 2000;

      sUrl := AApiUrl + '/pick/api/' + AErpApi + AJsonStr;
      Get(sUrl, ssTemp);

      sRecvData := TEncoding.UTF8.GetString(ssTemp.Bytes, 0, ssTemp.Size);

      Result := sRecvData;
    except
      on e: Exception do
      begin
        if StrPos(PChar(e.Message), PChar('Socket Error')) <> nil then
          FSocketError := True;

        Result := 'Exception : ' + AErpApi + ' / ' + e.Message;
      end;
    end

  finally
    FreeAndNil(ssTemp);
    Disconnect;
    Free;
  end;
end;

end.
