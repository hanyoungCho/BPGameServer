unit uConfig;

interface

uses
  System.SysUtils,
  System.IOUtils, CPort,
  fx.Logging, uConsts,
  uStruct, fx.Json, IniFiles, Variants;

type
  TPartners = class(TJson)
    OAuthUrl: string;
    ApiUrl: string;
    FileUrl: string;
  end;

  TOAuth = class(TJson)
    Token: string;
    TerminalId: string;
    TerminalPw: string;
  end;

  TGSInfo = class(TJson)
    IP: string;
    DB_PORT: Integer;
    SERVER_PORT: Integer;
  end;

  TPosInfo = class(TJson)
    IP: string;
    port: Integer;
  end;

  TMiniMapInfo = class(TJson)
    MiniViewCnt: Integer;
    Mini_1_Start: Integer;
    Mini_1_End: Integer;
    Mini_1_View: String;
    Mini_2_Start: Integer;
    Mini_2_End: Integer;
    Mini_2_View: String;
    Mini_3_Start: Integer;
    Mini_3_End: Integer;
    Mini_3_View: String;
  end;

	TStoreInfo = class(TJson)
    LaneMiniCnt: Integer; //ksj 230831 레인별 최소인원 현재는 컨피그파일에서 받아오고 추후 파트너센터에서 데이터받기
    StoreName: string;
    StoreCode: string;
    //UserID: string;
    //DeviceNo: string;
    //BossName: string;
    PosNo: Integer;
    Tel: string;
    Addr: string;
    BizNo: string;
    VanTID: string;
    VanCode: Integer;

    SaleStartTime: string; //영업 시작 시각 05:00:00
    SaleEndTime: string;  //영업 종료 시각  23:59:00
    ClosureStartDatetime: string;  //휴장 시작 일시 2022-10-10 05:00:00
    closureEndDatetime: string; //휴장 종료 일시  2022-10-10 23:00:00

    UseAgreement: String;
    PrivacyAgreement: String;
    AdvertiseAgreement: String;
    StoreHolidayYn: String;
		ShoesProdCd: String;
		GameDefaultProdCd: String; //ksj 230906 게임제,시간제 기본상품코드 기존에 01로 불러오던거 변경
		TimeDefaultProdCd: String;
    Age: Integer;
    //cancel_yn: string;   //해지 여부

    //ACS: Boolean; //ACS사용여부-파트너센터 매장정보
    Emergency: String;
    DNSFail: String;
  end;

  TPrintInfo = class(TJson)
    Port: Integer;
    BaudRate: Integer;
  end;

  TScannerInfo = class(TJson)
    Port: Integer;
    BaudRate: Integer;
  end;

  TReceiptAddInfo = class(TJson)
    Top1: string;
    Top2: string;
    Top3: string;
    Top4: string;
    Bottom1: string;
    Bottom2: string;
    Bottom3: string;
    Bottom4: string;
  end;

  TConfig = class(TJson)
  private
    function GetFileName: string;
  public
    AdminID: string;
    AdminPassword: string;

    NoPayModule: Boolean;
    NoDevice: Boolean;
    TeeBoxRefreshInterval: Integer;

    PrePareMin: string;
    PrepareUse: Boolean;

    ProductTime: Boolean; //타석상품 선택시간, false:타석종료시간(배정시간), true:타석선택시간(현재/주문시간)

    AppCard: Boolean; //간편결제-할인체크여부

    SystemShutdown: Boolean; //윈도우 종료 2022-09-01

    Partners: TPartners;
    OAuth: TOAuth;
    Store: TStoreInfo;

    Print: TPrintInfo;
    Scanner: TScannerInfo;

    Receipt: TReceiptAddInfo;

    GS: TGSInfo;
    Pos: TPosInfo;
    MiniMap : TMiniMapInfo;
    ConfigIni: TIniFile;

    constructor Create;
    destructor Destroy; override;

    procedure LoadConfig;

    procedure SetConfig(const ASection, AItem: string; const ANewValue: Variant);
  end;

implementation

uses
  uFunction;

{ TConfig }

constructor TConfig.Create;
begin
  Partners := TPartners.Create;
  OAuth := TOAuth.Create;
  Store := TStoreInfo.Create;

  Print := TPrintInfo.Create;
  Scanner := TScannerInfo.Create;

  Receipt := TReceiptAddInfo.Create;

  GS := TGSInfo.Create;
  Pos := TPosInfo.Create;
  MiniMap := TMiniMapInfo.Create;

  ConfigIni := TIniFile.Create(GetFileName);
  LoadConfig;

end;

destructor TConfig.Destroy;
begin
  Partners.Free;
  OAuth.Free;
  Store.Free;

  Print.Free;
  Scanner.Free;

  Receipt.Free;

  GS.Free;
  Pos.Free;
  MiniMap.Free;

  ConfigIni.Free;

  inherited;
end;

function TConfig.GetFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'Config.json';
end;

procedure TConfig.LoadConfig;
var
  sStr: String;
begin

  sStr := ConfigIni.ReadString('PARTNERS', 'Url', '');
  Partners.OAuthUrl := sStr + '/oauth/token';
  Partners.ApiUrl := sStr + '/pick/api/';
  Partners.FileUrl := sStr + '/upload/';

  OAuth.TerminalId := ConfigIni.ReadString('PARTNERS', 'TerminalId', '');
  sStr := ConfigIni.ReadString('PARTNERS', 'TerminalPw', '');
  OAuth.TerminalPw := StrDecrypt(Trim(sStr));

  Store.StoreCode := ConfigIni.ReadString('PARTNERS', 'StoreCode', '');

  Pos.IP := ConfigIni.ReadString('MainPos', 'IP', '');
  Pos.Port := ConfigIni.ReadInteger('MainPos', 'Port', 6001);

  MiniMap.MiniViewCnt := ConfigIni.ReadInteger('MiniMap', 'MiniViewCnt', 1);
  MiniMap.Mini_1_Start := ConfigIni.ReadInteger('MiniMap', 'Mini_1_Start', 0);
  MiniMap.Mini_1_End := ConfigIni.ReadInteger('MiniMap', 'Mini_1_End', 0);
  MiniMap.Mini_1_View := ConfigIni.ReadString('MiniMap', 'Mini_1_View', '');
  MiniMap.Mini_2_Start := ConfigIni.ReadInteger('MiniMap', 'Mini_2_Start', 0);
  MiniMap.Mini_2_End := ConfigIni.ReadInteger('MiniMap', 'Mini_2_End', 0);
  MiniMap.Mini_2_View := ConfigIni.ReadString('MiniMap', 'Mini_2_View', '');
  MiniMap.Mini_3_Start := ConfigIni.ReadInteger('MiniMap', 'Mini_3_Start', 0);
  MiniMap.Mini_3_End := ConfigIni.ReadInteger('MiniMap', 'Mini_3_End', 0);
  MiniMap.Mini_3_View := ConfigIni.ReadString('MiniMap', 'Mini_3_View', '');

  //GS.SERVER_PORT := ConfigIni.ReadInteger('GSInfo', 'SERVER_PORT', 3308);
  GS.DB_PORT := ConfigIni.ReadInteger('GSInfo', 'DB_PORT', 3306);

  {$IFDEF RELEASE}
  GS.IP := ConfigIni.ReadString('GSInfo', 'IP', '');
  GS.SERVER_PORT := ConfigIni.ReadInteger('GSInfo', 'SERVER_PORT', 3308);

  Print.Port := ConfigIni.ReadInteger('Print', 'Port', 0);
  Print.BaudRate := ConfigIni.ReadInteger('Print', 'BaudRate', 0);

  Scanner.Port := ConfigIni.ReadInteger('SCANNER', 'Port', 0);
  Scanner.BaudRate := ConfigIni.ReadInteger('SCANNER', 'BaudRate', 0);

  {$ENDIF}
	{$IFDEF DEBUG}
	GS.IP := '192.168.0.81'; //  127.0.0.1  192.168.99.134
	GS.SERVER_PORT := 3308; //로컬로 사용할때는 3308   로컬아닐때 3309

  Print.Port := 0;
	Print.BaudRate := 115200;

  Scanner.Port := 0;
  Scanner.BaudRate := 115200;

  {$ENDIF}
	Store.LaneMiniCnt := ConfigIni.ReadInteger('STORE', 'LaneMiniCnt', 2); //게임제 2개레인 사용시 최소인원

	Store.PosNo := ConfigIni.ReadInteger('STORE', 'PosNo', 0);
  //Store.BizNo := ConfigIni.ReadString('STORE', 'BizNo', '');
  Store.VanTID := ConfigIni.ReadString('Van', 'VanTID', '');
  Store.VanCode := ConfigIni.ReadInteger('Van', 'VanCode', 0);

  Store.Age := ConfigIni.ReadInteger('STORE', 'Age', 0);

  //Store.UserID := ConfigIni.ReadString('STORE', 'UserID', '');
  //Store.DeviceNo := ConfigIni.ReadString('STORE', 'DeviceNo', '');
  AdminID := ConfigIni.ReadString('STORE', 'AdminID', '');  //ksj 230713 추가
  AdminPassword := ConfigIni.ReadString('STORE', 'AdminPassword', '');

  //NoPayModule := True; //chy test 임시
  PrePareMin := ConfigIni.ReadString('STORE', 'PrePareMin', '');
  PrepareUse := ConfigIni.ReadString('STORE', 'PrepareUse', 'N') = 'Y';


  ProductTime := ConfigIni.ReadString('STORE', 'ProductTime', 'N') = 'Y';

  TeeBoxRefreshInterval := ConfigIni.ReadInteger('STORE', 'TeeBoxRefreshInterval', 5);

  //간편결제-할인체크여부 2022-02-23
  AppCard := ConfigIni.ReadString('STORE', 'AppCard', 'N') = 'Y';

  SystemShutdown := ConfigIni.ReadString('STORE', 'SystemShutdown', 'N') = 'Y';


  Receipt.Top1 := ConfigIni.ReadString('RECEIPT', 'TOP1', '');
  Receipt.Top2 := ConfigIni.ReadString('RECEIPT', 'TOP2', '');
  Receipt.Top3 := ConfigIni.ReadString('RECEIPT', 'TOP3', '');
  Receipt.Top4 := ConfigIni.ReadString('RECEIPT', 'TOP4', '');
  Receipt.Bottom1 := ConfigIni.ReadString('RECEIPT', 'BOTTOM1', '');
  Receipt.Bottom2 := ConfigIni.ReadString('RECEIPT', 'BOTTOM2', '');
  Receipt.Bottom3 := ConfigIni.ReadString('RECEIPT', 'BOTTOM3', '');
  Receipt.Bottom4 := ConfigIni.ReadString('RECEIPT', 'BOTTOM4', '');
end;

procedure TConfig.SetConfig(const ASection, AItem: string; const ANewValue: Variant);
begin
  case VarType(ANewValue) of
    varInteger:
      ConfigIni.WriteInteger(ASection, AItem, ANewValue);
    varBoolean:
      ConfigIni.WriteBool(ASection, AItem, ANewValue);
  else
    ConfigIni.WriteString(ASection, AItem, ANewValue);
  end;
end;

end.
