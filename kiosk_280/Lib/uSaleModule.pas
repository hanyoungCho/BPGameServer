unit uSaleModule;

interface

uses
  uConsts, uPrint, CPort, JSON, VCL.Forms, IdHTTP, System.Classes, Math, mmsystem,
  uStruct, System.SysUtils, IdGlobal, IdSSL, IdSSLOpenSSL, System.UITypes, System.DateUtils,
  Generics.Collections, Uni, uVanDeamonModul, uPaycoNewModul, IdComponent, IdTCPConnection, IdTCPClient,
  IdURI;

type
  TPayTyepe = (ptNone, ptCash, ptCard, ptPayco, ptVoid);

  //���� ī������� �Ҹ��� ���
  TSoundThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    SoundList: TList<string>;
    constructor Create;
    destructor Destroy; override;
  end;
  {
  TMasterDownThread = class(TThread)
  private
    FAdvertis: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;
  }
  // ��������
  TPayData = class
  private
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function PayType: TPayTyepe; virtual; abstract;
    function PayAmt: Currency; virtual; abstract;
//    // ���� �� ���� ����Ÿ�� DB�� �����Ѵ�.
  end;

  TPayCard = class(TPayData)
  private
  public
    // ��������
    SendInfo: TCardSendInfoDM;
    // ��������
    RecvInfo: TCardRecvInfoDM;
    // ����ī�� ����
    IsEyCard: Boolean;
    // ��������
    FPayType: TPayTyepe;
    // ī��� ���� �ݾ�
    CardDiscount: Currency;
    constructor Create; override;
    destructor Destroy; override;
    function PayAmt: Currency; override;
    function PayType: TPayTyepe; override;
  end;

  TPayPayco = class(TPayData)
  private
  public
    // ��������
    SendInfo: TPaycoNewSendInfo;
    // ��������
    RecvInfo: TPaycoNewRecvInfo;
    // ��������
    FPayType: TPayTyepe;
    constructor Create; override;
    destructor Destroy; override;
    function PayAmt: Currency; override;
    function PayType: TPayTyepe; override;
  end;

  TSaleModule = class
  private
    // ��׶��� ������ ���� -�ӽ��ּ� ntdll
    //FMasterDownThread: TMasterDownThread;
    // ����
    FSoundThread: TSoundThread;
    // ���α׷� ��� ���� ����
    //FProgramUse: Boolean;
    // ���� DB or ���� ���� ����
    FSaveFailMessage: Boolean;
    // �Ǹ���
    FSaleDate: string;
    // ������ ��ȣ
    FRcpNo: Integer;
    FRcpAspNo: string;

    // ��ü ȸ�� ����
    FMemberList: TList<TMemberInfo>;
    FMemberUpdateList: TList<TMemberInfo>;

    // ��ǰ ����
    FSaleGameProdList: TList<TGameProductInfo>; //����� ��ǰ
    FSaleMemberShipProdList: TList<TMemberShipProductInfo>; //ȸ���� ��ǰ
    FSaleSelectMemberShipProd: TMemberShipProductInfo; //���õ� ȸ���� ��ǰ
    FSaleShoesProd: TGameProductInfo; //��ǰ

    // ������Ȳ ���� ����Ʈ
    //FMainItemList: TList<TTeeBoxInfo>;

    // ȸ��
    FMember: TMemberInfo; // ���� ȸ��
    FMemberProdList: TList<TMemberProductInfo>; // ȸ���� ��밡���� ��ǰ ���
    FSelectProd: TMemberProductInfo; // ȸ���� ���� ��ǰ

    // ȸ�� ���� ���
    FBuyProductList: TList<TSaleData>; //��ǰ����
    FPayProductList: TList<TSaleData>; //����ȭ��

    // ��������
    //FDisCountList: TList<TDiscount>;
    // ��������
    FPayList: TList<TPayData>;
    // ���� �ð�
    FSelectTime: TDateTime;
    // �Һ� ����
    FSelectHalbu: Integer;
    // VIP ZONE ����
    //FVipTeebox: Boolean;                     // ���߼��ý� VIPŸ���� ��� �� �� �ΰ�?
    // ������ ���� ����
    FSaleUpload: Boolean;

    // üũ�� ������� 2021-08-05
    //FCheckInList: TList<TCheckInInfo>;

    // ���� ����Ʈ
    FAdvertListUp: TList<TAdvertisement>;
    //FAdvertListTeeboxUp: TList<TAdvertisement>;
    FAdvertListDown: TList<TAdvertisement>;
    //FAdvertListPopupMember: TList<TAdvertisement>;
    //FAdvertListPopupMemberIdx: Integer;
    //FAdvertListPopupEvent: TList<TAdvertisement>; //xgolf ȸ�� �̺�Ʈ - ����
    //FAdvertListComplex: TList<TAdvertisement>;

    // �˾�
    // Ÿ�� ����
    FPopUpLevel: TPopUpLevel;
    // ��üȭ�� �˾�
    FPopUpFullLevel: TPopUpFullLevel;
    // ȸ�� ���� ���� �Ⱓ/����/����
    FmemberItemType: TMemberItemType;
    FGameItemType: TGameItemType; //���ӿ����, �ð������

    // ȸ���� ������ ���� ����
		FLaneInfo: TLaneInfo;
		FGameInfo: TGameInfo;

		//ksj 230621
		FSaveLaneInfo: TLaneInfo;
		FSaveGameInfo: TGameInfo;

    FNewMemberItemType: TNewMemberItemType;
    FNewMember: TMemberInfo;

    // ī����� ����
    FCardApplyType: TCardApplyType;

    FPrint: TReceiptPrint;
    //Van
    FVanModule: TVanDeamonModul;
    // Payco
    FPaycoModule: TPaycoNewModul;

    //���Ÿ��
    FTotalAmt: Currency;   // �Ǹűݾ� - �⺻��ǰ ����
    FGameAmt: Currency;
    FShoesAmt: Currency;
    FRealAmt: Currency;    // ���Ǹűݾ�
    FVatAmt: Currency;     // �ΰ�����
    FDCAmt: Currency;      // ���αݾ�
    FRealSumAmt: Currency; // �Ǹ���

    //�������
    FPayTotalAmt: Currency;   // �Ǹűݾ�
    FPayGameAmt: Currency;
    FPayShoesAmt: Currency;
    FPayRealAmt: Currency;    // ���Ǹűݾ�
    FPayVatAmt: Currency;     // �ΰ�����
    FPayDCAmt: Currency;      // ���αݾ�

    FPaySelTotalAmt: Currency;  // �����Ǹűݾ�
    FPaySelRealAmt: Currency;   // ���ý��Ǹűݾ�
    FPaySelVatAmt: Currency;    // ���úΰ�����
    FPaySelDcAmt: Currency;  // ���õ� ��ǰ�� ���αݾ�
    FPayResultAmt: Currency;  // �����Ϸ�ݾ�
    FPayRemainAmt: Currency;  // �ܿ��ݾ�


    FIsComplete: Boolean;
    FVipDisCount: Boolean;
    FMiniMapCursor: Boolean;
    FPrepareMin: Integer;

    FTeeboxTimeError: Boolean;

    // ���� ȸ�� ��ȸ
		FCouponMember: Boolean;

		FTimeLane1DcType: string; //T: �̿��, P: ����Ʈ ksj 230726 �ð������� ������ ����Ʈ�� �Ǵ� �̿�Ǹ� ����
		FTimeLane2DcType: string; //ksj 230824 ex)1������ �̿��, 2������ ����Ʈ ��밡���ϵ���
		FTimeBowlerSeq: Integer;

    function GetVanCode: string;
    function GetRcpNo: Integer;
  public

    //FingerStr: string;
    //ConfigJsonText: string;

    MemberInfoDownLoadDateTime: string;  // ȸ�� ���� ���� �ð�
    GameProdDownLoadDateTime: String;    // ����� ���� �ð�
    MemberShipDownLoadDateTime: String;  // ȸ���� ��ǰ ���� �ð�
    ShoesProdDownLoadDateTime: String;   // ��ȭ ���Žð�
    NowHour: string;
    NowTime: string;
    // �̴ϸ� width
    MiniMapWidth: Integer;

    //2020-12-29 ��ī������
    FLockerEndDay: String;

    FStoreCloseOver: Boolean;
    FStoreCloseOverMin: String;
    //FSendPrintError: Boolean;

    FApiErrorMsg: String;

    constructor Create;
    destructor Destroy; override;

    // ���� üũ
    function MasterReception(AMember, AMemberShip, AShoesProd: Boolean): Boolean;
    function SaleCompleteProc: Boolean;
    function SaleCompleteMemberProc: Boolean;
    function SaleCompleteAssign: Boolean;

    function SetReceiptPrintData: string;
    function SetAssignReceiptPrintData: string;
    function SearchMember(ACode: string): TMemberInfo;
    //function SearchRFIDMember(ACode: string): TMemberInfo; //RFID
    function SearchPhoneMember(ACode: string): TMemberInfo; //RFID

    function AddMemberShipProduct: Boolean;
    function MinusProduct(AProduct: TProductInfo): Boolean;
    function DeleteProduct(AIndex: Integer): Boolean;

    function AddSaleData(ASaleData: TSaleData): Boolean;
    function UndoSaleData(AIdx: Integer): Boolean;
    function chgSaleData(AIdx: Integer): Boolean;
    function chgSaleDataSaleQty(AIdx, ACnt: Integer): Boolean;
		function chgSaleDataLane(AIdx: Integer; AUse: String): Boolean;
		procedure reCountBowlerId; //ksj 230905
		function chgSaleDataShoes(AIdx: Integer; AUse: String): Boolean;

    function regPayList: Boolean;
		function chgPayListSelect(AIdx: Integer; AUse: Boolean): Boolean;
		function delBuyList(AIdx: Integer): Boolean; //ksj 230831
		procedure reCountBowlerSeq;  //ksj 230831
		procedure delLaneCheak;  //ksj 230621
		procedure LaneNoCheak;  //ksj 230621
    procedure PayListClear;
    function PayListAllResult: Boolean;
    procedure PayCalc;

    procedure CallEmp;
    procedure SaleDataClear;
    procedure BuyListClear;
    procedure BuyCalc;

    // ������
    function GetMemberList: Boolean;
    function GetConfig: Boolean;
    function GetGameProdList: Boolean;
    function GetMemberShipProdList: Boolean;
    function GetRentProduct: Boolean;

    // �����
    function GetGameProductAmt(ADetailDiv, AFeeDiv: String): Boolean;
    function GetGameProductFee(ADetailDiv, AFeeDiv: String): TGameProductInfo;

    function DeviceInit: Boolean;
    // ī�� ���� ��ȸ
    function CallCardInfo: string;
    // ī�� ����
    function CallCard(ACardBin, ACode, AMsg: string; ADiscountAmt: Currency; IsAppCard: Boolean = False): TCardRecvInfoDM;
    //function CallCard_Old: TCardRecvInfoDM;
    // PAYCO ����
    function CallPayco: TPaycoNewRecvInfo;

    // �������� �հ�
    function GetSumPayAmt(APayType: TPayTyepe): Currency;

    // ����ȣ��
    function CallAdmin(AType: Integer): Boolean;

    // Ÿ���ð� üũ
    function TeeboxTimeCheck: Boolean;

    //property ProgramUse: Boolean read FProgramUse write FProgramUse;
    property SaleDate: string read FSaleDate write FSaleDate;
    property RcpNo: Integer read FRcpNo write FRcpNo;
    property RcpAspNo: string read FRcpAspNo write FRcpAspNo;
    property Member: TMemberInfo read FMember write FMember;
    property MemberList: TList<TMemberInfo> read FMemberList write FMemberList;
    property MemberUpdateList: TList<TMemberInfo> read FMemberUpdateList write FMemberUpdateList;
    property memberItemType: TMemberItemType read FmemberItemType write FmemberItemType;
    property GameItemType: TGameItemType read FGameItemType write FGameItemType;

    property NewMemberItemType: TNewMemberItemType read FNewMemberItemType write FNewMemberItemType;
    property NewMember: TMemberInfo read FNewMember write FNewMember;

		property LaneInfo: TLaneInfo read FLaneInfo write FLaneInfo;
		property GameInfo: TGameInfo read FGameInfo write FGameInfo;

		//ksj 230621
		property SaveLaneInfo: TLaneInfo read FSaveLaneInfo write FSaveLaneInfo;
		property SaveGameInfo: TGameInfo read FSaveGameInfo write FSaveGameInfo;

    property SelectProd: TMemberProductInfo read FSelectProd write FSelectProd;
    property MemberProdList: TList<TMemberProductInfo> read FMemberProdList write FMemberProdList;

    property SaleGameProdList: TList<TGameProductInfo> read FSaleGameProdList write FSaleGameProdList;
    property SaleMemberShipProdList: TList<TMemberShipProductInfo> read FSaleMemberShipProdList write FSaleMemberShipProdList;
    property SaleShoesProd: TGameProductInfo read FSaleShoesProd write FSaleShoesProd;
    property SaleSelectMemberShipProd: TMemberShipProductInfo read FSaleSelectMemberShipProd write FSaleSelectMemberShipProd;

    property BuyProductList: TList<TSaleData> read FBuyProductList write FBuyProductList;
    property PayProductList: TList<TSaleData> read FPayProductList write FPayProductList;

    //property DisCountList: TList<TDiscount> read FDisCountList write FDisCountList;
    property PayList: TList<TPayData> read FPayList write FPayList;
    //property MainItemList: TList<TTeeBoxInfo> read FMainItemList write FMainItemList;

    //property CheckInList: TList<TCheckInInfo> read FCheckInList write FCheckInList;

    property AdvertListUp: TList<TAdvertisement> read FAdvertListUp write FAdvertListUp;
    //property AdvertListTeeboxUp: TList<TAdvertisement> read FAdvertListTeeboxUp write FAdvertListTeeboxUp;
    property AdvertListDown: TList<TAdvertisement> read FAdvertListDown write FAdvertListDown;
    //property AdvertListPopupMember: TList<TAdvertisement> read FAdvertListPopupMember write FAdvertListPopupMember;
    //property AdvertListPopupMemberIdx: Integer read FAdvertListPopupMemberIdx write FAdvertListPopupMemberIdx;
    //property AdvertListPopupEvent: TList<TAdvertisement> read FAdvertListPopupEvent write FAdvertListPopupEvent;
    //property AdvertListComplex: TList<TAdvertisement> read FAdvertListComplex write FAdvertListComplex;

    //property ParkingProductList: TList<TProductInfo> read FParkingProductList write FParkingProductList;

    property PopUpLevel: TPopUpLevel read FPopUpLevel write FPopUpLevel;
    property PopUpFullLevel: TPopUpFullLevel read FPopUpFullLevel write FPopUpFullLevel;

    property Print: TReceiptPrint read FPrint write FPrint;

    property VanModule: TVanDeamonModul read FVanModule write FVanModule;
    property PaycoModule: TPaycoNewModul read FPaycoModule write FPaycoModule;
    //property BioMiniPlus2: TBioMiniPlus2 read FBioMiniPlus2 write FBioMiniPlus2;

    // ��ǰ����
    property TotalAmt: Currency read FTotalAmt write FTotalAmt;
    property GameAmt: Currency read FGameAmt write FGameAmt;
    property ShoesAmt: Currency read FShoesAmt write FShoesAmt;
    property VatAmt: Currency read FVatAmt write FVatAmt;
    property DCAmt: Currency read FDCAmt write FDCAmt;
    property RealAmt: Currency read FRealAmt write FRealAmt;

    // ��ǰ�Ǹ�
    property PayTotalAmt: Currency read FPayTotalAmt write FPayTotalAmt;
    property PayGameAmt: Currency read FPayGameAmt write FPayGameAmt;
    property PayShoesAmt: Currency read FPayShoesAmt write FPayShoesAmt;
    property PayVatAmt: Currency read FPayVatAmt write FPayVatAmt;
    property PayDCAmt: Currency read FPayDCAmt write FPayDCAmt;
    property PayRealAmt: Currency read FPayRealAmt write FPayRealAmt;

    // ��ǰ�Ǹ��� ���õ� ��ǰ
    property PaySelTotalAmt: Currency read FPaySelTotalAmt write FPaySelTotalAmt;
    property PaySelVatAmt: Currency read FPaySelVatAmt write FPaySelVatAmt;
    property PaySelDCAmt: Currency read FPaySelDCAmt write FPaySelDCAmt;
    property PaySelRealAmt: Currency read FPaySelRealAmt write FPaySelRealAmt;
    property PayResultAmt: Currency read FPayResultAmt write FPayResultAmt;
    property PayRemainAmt: Currency read FPayRemainAmt write FPayRemainAmt;

    property SelectTime: TDateTime read FSelectTime write FSelectTime;
    property SelectHalbu: Integer read FSelectHalbu write FSelectHalbu;

    property IsComplete: Boolean read FIsComplete write FIsComplete;
    property VipDisCount: Boolean read FVipDisCount write FVipDisCount;
    property PrepareMin: Integer read FPrepareMin write FPrepareMin;
    //property VipTeeBox: Boolean read FVipTeeBox write FVipTeeBox;
    property SaleUploadFail: Boolean read FSaleUpload write FSaleUpload;

    property MiniMapCursor: Boolean read FMiniMapCursor write FMiniMapCursor;

    //�ӽ��ּ�
    //property MasterDownThread: TMasterDownThread read FMasterDownThread write FMasterDownThread;

    property SoundThread: TSoundThread read FSoundThread write FSoundThread;
    property TeeboxTimeError: Boolean read FTeeboxTimeError write FTeeboxTimeError;
		property CardApplyType: TCardApplyType read FCardApplyType write FCardApplyType;
		property CouponMember: Boolean read FCouponMember write FCouponMember;

		property TimeLane1DcType: string read FTimeLane1DcType write FTimeLane1DcType; //ksj 230726
		property TimeLane2DcType: string read FTimeLane2DcType write FTimeLane2DcType; //ksj 230824
		property TimeBowlerSeq: Integer read FTimeBowlerSeq write FTimeBowlerSeq; //ksj 230824
	end;

var
  SaleModule: TSaleModule;

implementation

uses
  uGlobal, uCommon, uFunction, fx.Logging;

{ TSaleModule }


constructor TSaleModule.Create;
begin
  //ConfigJsonText := EmptyStr;
  //ProgramUse := True;

  MemberList := TList<TMemberInfo>.Create;
  MemberUpdateList := TList<TMemberInfo>.Create;
  //ProductList := TList<TProductInfo>.Create;
  BuyProductList := TList<TSaleData>.Create;
  PayProductList := TList<TSaleData>.Create;
  SaleGameProdList := TList<TGameProductInfo>.Create;
  SaleMemberShipProdList := TList<TMemberShipProductInfo>.Create;
  MemberProdList := TList<TMemberProductInfo>.Create;

  //DisCountList := TList<TDiscount>.Create;
  PayList := TList<TPayData>.Create;
  //MainItemList := TList<TTeeBoxInfo>.Create;

  //CheckInList := TList<TCheckInInfo>.Create;

  AdvertListUp := TList<TAdvertisement>.Create;
  //AdvertListTeeboxUp := TList<TAdvertisement>.Create;
  AdvertListDown := TList<TAdvertisement>.Create;
  //AdvertListPopupMember := TList<TAdvertisement>.Create;
  //AdvertListPopupEvent := TList<TAdvertisement>.Create;
  //AdvertListComplex := TList<TAdvertisement>.Create;

  //ParkingProductList := TList<TProductInfo>.Create;


//  LastHoldNo := 0;
  //VipTeeBox := False;
  SaleUploadFail := False;


  MiniMapCursor := False;

  //�ӽ��ּ�ó��2021-08-24 ntdll �ǽ�
  //MasterDownThread := TMasterDownThread.Create;

  SoundThread := TSoundThread.Create;
  MemberInfoDownLoadDateTime := EmptyStr;
  GameProdDownLoadDateTime := EmptyStr;
  MemberShipDownLoadDateTime := EmptyStr;
  ShoesProdDownLoadDateTime := EmptyStr;
  NowHour := EmptyStr;
  NowTime := EmptyStr;
  MiniMapWidth := 0;
  //AdvertListPopupMemberIdx := 0;
end;

destructor TSaleModule.Destroy;
begin

	try
    if MemberList <> nil then
      MemberList.Free;

    if MemberUpdateList <> nil then
      MemberUpdateList.Free;

    //if ProductList <> nil then
      //ProductList.Free;

    if BuyProductList <> nil then
      BuyProductList.Free;

    if PayProductList <> nil then
      PayProductList.Free;

    if SaleGameProdList <> nil then
      SaleGameProdList.Free;

    if SaleMemberShipProdList <> nil then
      SaleMemberShipProdList.Free;

    if MemberProdList <> nil then
      MemberProdList.Free;

    //if DisCountList <> nil then
      //DisCountList.Free;

    if PayList <> nil then
      PayList.Free;

    //if (MainItemList <> nil) then // ��������
      //MainItemList.Free;

    //if CheckInList <> nil then
      //CheckInList.Free;

    //����
    if AdvertListUp <> nil then
      AdvertListUp.Free;

    //if AdvertListTeeboxUp <> nil then
      //AdvertListTeeboxUp.Free;

    if AdvertListDown <> nil then
      AdvertListDown.Free;

    //if AdvertListPopupMember <> nil then
      //AdvertListPopupMember.Free;
    {
    if AdvertListPopupEvent <> nil then
      AdvertListPopupEvent.Free;
    }
    //if AdvertListComplex <> nil then
      //AdvertListComplex.Free;

    //if ParkingProductList <> nil then
      //ParkingProductList.Free;


    if not Global.Config.NoPayModule then
    begin
      VanModule.Free;
      PaycoModule.Free;
    end;

    if not Global.Config.NoDevice then
    begin
      Print.Free;
    end;

    {//2021-08-24 �ӽ��ּ�
    if FMasterDownThread <> nil then
    begin
      FMasterDownThread.Terminate;
      //FMasterDownThread.WaitFor; //Ÿ����Ȳ ȭ�� ���� waitfor�� �Ѿ�� ����...
      //FMasterDownThread.Free;
    end;
    }
		if FSoundThread <> nil then
		begin
			FSoundThread.Terminate; //�����û�� �ϴµ� Destroy���� ����
//      SoundThread.WaitFor;
//			FSoundThread.Free; //Free�ϸ� Destroy�Ǵµ� �ϴ°� �´��� ����
		end;

  except
    on E: Exception do
      Log.E('TSaleModule.Destroy', E.Message);
  end;

  inherited;
end;

function TSaleModule.AddMemberShipProduct: Boolean;
begin

  try
    Log.D('AddMemberProduct', SaleSelectMemberShipProd.ProdCd + '-' + SaleSelectMemberShipProd.ProdNm);
    Result := False;

    PaySelTotalAmt := SaleSelectMemberShipProd.ProdAmt;
    PaySelDCAmt := 0;
    PaySelRealAmt := PaySelTotalAmt - PaySelDCAmt;
    PaySelVatAmt := PaySelRealAmt - Trunc(PaySelRealAmt / 1.1);

    Result := True;
  finally

  end;

end;

function TSaleModule.MinusProduct(AProduct: TProductInfo): Boolean;
var
  Index: Integer;
  IsAdd: Boolean;
  ASaleData: TSaleData;
begin
{
  try
    for Index := 0 to BuyProductList.Count - 1 do
    begin
      if BuyProductList[Index].Products.Code = AProduct.Code then
      begin
        ASaleData := BuyProductList[Index];
        ASaleData.SaleQty := ASaleData.SaleQty - 1;
        ASaleData.SalePrice := ASaleData.SaleQty * ASaleData.Products.ProdAmt;
        BuyProductList[Index] := ASaleData;
        if BuyProductList[Index].SaleQty = 0 then
        begin
          DeleteProduct(Index);
          Break;
        end;
      end;
    end;
  finally
    BuyCalc;
  end;
  }
end;

function TSaleModule.DeleteProduct(AIndex: Integer): Boolean;
begin
  BuyProductList.Delete(AIndex);
  BuyCalc;
end;

function TSaleModule.AddSaleData(ASaleData: TSaleData): Boolean;
begin
  try
    //Log.D('AddSaleData', ASaleData.BowlerId + '-' + ASaleData.BowlerNm + '-' + ASaleData.Products.ProdCd);
    Result := False;

    {
    if StoreCloseTmCheck(AProduct) = True then
    begin
      Exit;
    end;
    }

    BuyProductList.Add(ASaleData);

    Result := True;
  finally
    BuyCalc;
  end;
end;

function TSaleModule.UndoSaleData(AIdx: Integer): Boolean;
var
  rSaleData: TSaleData;
	rMemberInfo: TMemberInfo;
  rDcProduct: TMemberProductInfo;
begin
  try
    Result := False;
    //Log.D('UndoSaleData', IntToStr(AIdx) + '-' + ANm);

    rSaleData := BuyProductList[AIdx];
		rSaleData.MemberInfo := rMemberInfo; //ȸ���ʱ�ȭ
		rSaleData.DcProduct := rDcProduct; //ksj 230808 DC��ǰ �ʱ�ȭ

    if GameItemType = gitGameCnt then
      rSaleData.GameProduct := GetGameProductFee('101', Global.Config.Store.GameDefaultProdCd)
		else if GameItemType = gitGameTime then
			rSaleData.GameProduct := GetGameProductFee('102', Global.Config.Store.TimeDefaultProdCd);

    //ksj 230817 ������� ��ȭ�� ������ ���
		if rSaleData.GameProduct.ShoesFreeYn = 'Y' then
			rSaleData.ShoesUse := 'F'
		else
			rSaleData.ShoesUse := 'Y';

		rSaleData.SaleQty := GameInfo.GameCnt;
    rSaleData.SalePrice := rSaleData.GameProduct.ProdAmt * rSaleData.SaleQty;

		rSaleData.DcAmt := 0;
    if rSaleData.DiscountList.Count > 0 then
      rSaleData.DiscountList.Clear;

    BuyProductList[AIdx] := rSaleData;

    Result := True;
  finally
    BuyCalc;
  end;
end;

function TSaleModule.ChgSaleData(AIdx: Integer): Boolean;
var
	rSaleData: TSaleData;
	rDisCount: TDiscount;
	rDcProduct: TMemberProductInfo; //ksj 230718
	I, nLane1, nLane2, RemainProdAmt1, RemainProdAmt2: Integer; //ksj 230727
	nSalePrice1, nSalePrice2, nDcAmt1, nDcAmt2: Currency;
begin
	try
		Result := False;

		Log.D('ChgSaleData', IntToStr(AIdx) + '-' + Member.Code + '-' + Member.Name + '-' + SelectProd.ProdCd);
		Result := False;

		rSaleData := BuyProductList[AIdx];

		rSaleData.MemberInfo := Member;
		//rSaleData.MemberYN := True;
		rSaleData.DcProduct := SelectProd;
		//ksj 230814
		if rSaleData.DcAmt > 0 then
			rSaleData.DcAmt := 0;
		if rSaleData.DisCountList.Count > 0 then
			rSaleData.DiscountList.Clear;

		BuyProductList[AIdx] := rSaleData;

    if rSaleData.DcProduct.ProdCd <> EmptyStr then //������, ������ǰ�� ������ ���
    begin

			if rSaleData.DcProduct.ProdCd = 'P' then //����Ʈ ���
			begin
				rDisCount.DcType := 'P';
				//ksj 230727 ���� ����Ʈ ����� ����� (�ش緹�� ���ӱݾ� -)���� ����Ʈ��ŭ �� ����
				if GameItemType = gitGameTime then
				begin
					nSalePrice1 := 0;
					nSalePrice2 := 0;
					nDcAmt1 := 0;
					nDcAmt2 := 0;
					RemainProdAmt1 := 0;
					RemainProdAmt2 := 0;
          nLane1 := 0;
					nLane2 := 0;
					for I := 0 to Global.SaleModule.BuyProductList.Count - 1 do
					begin
						if Global.SaleModule.GameInfo.LaneUse = '2' then
						begin //ksj 230731 TotalAmt�� DCAmt ���κ��� ����
              if odd(Global.SaleModule.BuyProductList[I].LaneNo) then
							begin
								if nLane1 = 0 then
									nLane1 := Global.SaleModule.BuyProductList[I].LaneNo;

								if nSalePrice1 = 0 then
									nSalePrice1 := nSalePrice1 + Global.SaleModule.BuyProductList[I].SalePrice;

								if Global.SaleModule.BuyProductList[I].DcAmt = 0 then
									Continue
								else if Global.SaleModule.BuyProductList[I].DcAmt > 0 then
									nDcAmt1 := nDcAmt1 + Global.SaleModule.BuyProductList[I].DcAmt;

								Continue;
							end
							else
							begin
                if nLane2 = 0 then
									nLane2 := Global.SaleModule.BuyProductList[I].LaneNo;

								if nSalePrice2 = 0 then
									nSalePrice2 := nSalePrice2 + Global.SaleModule.BuyProductList[I].SalePrice;

								if Global.SaleModule.BuyProductList[I].DcAmt = 0 then
									Continue
								else if Global.SaleModule.BuyProductList[I].DcAmt > 0 then
									nDcAmt2 := nDcAmt2 + Global.SaleModule.BuyProductList[I].DcAmt;

								Continue;
							end;
						end
						else
						begin
							if nLane1 = 0 then
								nLane1 := Global.SaleModule.BuyProductList[I].LaneNo;

							if nSalePrice1 = 0 then
								nSalePrice1 := nSalePrice1 + Global.SaleModule.BuyProductList[I].SalePrice;

							if Global.SaleModule.BuyProductList[I].DcAmt = 0 then
								Continue
							else if Global.SaleModule.BuyProductList[I].DcAmt > 0 then
								nDcAmt1 := nDcAmt1 + Global.SaleModule.BuyProductList[I].DcAmt;
						end;
					end;

          if Global.SaleModule.GameInfo.LaneUse = '2' then
					begin //ksj 230731 TotalAmt�� DCAmt ���κ��� ����
						if rSaleData.LaneNo = nLane1 then
						begin
              if (nDcAmt1 >= 0) and (nDcAmt1 < nSalePrice1) then
							begin
								RemainProdAmt1 := StrToInt(CurrToStr(nSalePrice1 - nDcAmt1));
								if Member.SavePoint >= RemainProdAmt1 then
									rDisCount.DcValue := RemainProdAmt1
								else
									rDisCount.DcValue := Member.SavePoint;

								rDisCount.DcAmt := rDisCount.DcValue;
								rSaleData.DisCountList.Add(rDisCount);
								rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;

								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end
							else
							begin
								rSaleData.DcProduct := rDcProduct;
								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end;
						end;

						if rSaleData.LaneNo = nLane2 then
						begin
							if (nDcAmt2 >= 0) and (nDcAmt2 < nSalePrice2) then
							begin
								RemainProdAmt2 := StrToInt(CurrToStr(nSalePrice2 - nDcAmt2));
								if Member.SavePoint >= RemainProdAmt2 then
									rDisCount.DcValue := RemainProdAmt2
								else
									rDisCount.DcValue := Member.SavePoint;

								rDisCount.DcAmt := rDisCount.DcValue;
								rSaleData.DisCountList.Add(rDisCount);
								rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;

								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end
							else
							begin
								rSaleData.DcProduct := rDcProduct;
								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end;
						end;
					end
					else 
					begin //ksj 230814 Global.SaleModule.BuyProductList[I] -> nDcAmt1�� ����(�ش� ������ dc�ݾ��� �ƴ� ������ dc�ݾ����� ��)
						if (nDcAmt1 >= 0) and (nDcAmt1 < nSalePrice1) then
						begin
							RemainProdAmt1 := StrToInt(CurrToStr(nSalePrice1 - nDcAmt1));
							if Member.SavePoint >= RemainProdAmt1 then
								rDisCount.DcValue := RemainProdAmt1
							else
								rDisCount.DcValue := Member.SavePoint;

							rDisCount.DcAmt := rDisCount.DcValue;
							rSaleData.DisCountList.Add(rDisCount);
							rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;

							BuyProductList[AIdx] := rSaleData;
							Result := True;
							BuyCalc;
							Exit;
						end
						else
						begin
							rSaleData.DcProduct := rDcProduct;
							BuyProductList[AIdx] := rSaleData;
							Result := True;
							BuyCalc;
							Exit;
						end;
					end;
				end
				else //ksj 230814 ������
				begin
					if Member.SavePoint >= (rSaleData.SaleQty * rSaleData.GameProduct.ProdAmt) then
						rDisCount.DcValue := Trunc(rSaleData.SaleQty * rSaleData.GameProduct.ProdAmt)
					else
						rDisCount.DcValue := Member.SavePoint;

					rDisCount.DcAmt := rDisCount.DcValue;

					//ksj 230720 ����Ʈ ��� �Ŀ� ��ǰ���� �ٲ�
					if rSaleData.DisCountList.Count > 0 then
					begin
						rSaleData.DcAmt := 0;
						rSaleData.DisCountList.Delete(0);
					end;

					rSaleData.DisCountList.Add(rDisCount);

					rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;
				end;
      end
      else
      begin
        if (rSaleData.DcProduct.GameDiv = '1') then //���ӿ����
        begin
          if (rSaleData.DcProduct.RemainGameCnt > 0) then // ������
          begin
            rDisCount.DcType := 'C';

            if rSaleData.DcProduct.RemainGameCnt >= rSaleData.SaleQty then
              rDisCount.DcValue := rSaleData.SaleQty
            else
              rDisCount.DcValue := rSaleData.DcProduct.RemainGameCnt;

						rDisCount.DcAmt := rDisCount.DcValue * rSaleData.GameProduct.ProdAmt;

						//ksj 230720 �̿�� ��� �Ŀ� ��ǰ���� �ٲ�
						if rSaleData.DisCountList.Count > 0 then
						begin
							rSaleData.DcAmt := 0;
							rSaleData.DisCountList.Delete(0);
						end;

            rSaleData.DisCountList.Add(rDisCount);

            rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;
          end;
        end
        else if (rSaleData.DcProduct.GameDiv = '2') then
				begin
					rDisCount.DcType := 'T';
					//ksj 230727 ���� �̿�Ǽ����� ����� (�ش緹�� ���ӽð� -)�����ð���ŭ �� ����
					nSalePrice1 := 0;
					nSalePrice2 := 0;
					nDcAmt1 := 0;
					nDcAmt2 := 0;
					RemainProdAmt1 := 0;
					RemainProdAmt2 := 0;
					nLane1 := 0;
					nLane2 := 0;
					for I := 0 to Global.SaleModule.BuyProductList.Count - 1 do
					begin
						if Global.SaleModule.GameInfo.LaneUse = '2' then
						begin //ksj 230728 TotalAmt�� DCAmt ���κ��� ����
							if odd(Global.SaleModule.BuyProductList[I].LaneNo) then
							begin
								if nLane1 = 0 then
									nLane1 := Global.SaleModule.BuyProductList[I].LaneNo;

								if nSalePrice1 = 0 then
								nSalePrice1 := nSalePrice1 + Global.SaleModule.BuyProductList[I].SalePrice;

								if Global.SaleModule.BuyProductList[I].DcAmt = 0 then
									Continue
								else if Global.SaleModule.BuyProductList[I].DcAmt > 0 then
									nDcAmt1 := nDcAmt1 + Global.SaleModule.BuyProductList[I].DcAmt;

								Continue;
							end
							else
							begin
								if nLane2 = 0 then
									nLane2 := Global.SaleModule.BuyProductList[I].LaneNo;

								if nSalePrice2 = 0 then
								nSalePrice2 := nSalePrice2 + Global.SaleModule.BuyProductList[I].SalePrice;

								if Global.SaleModule.BuyProductList[I].DcAmt = 0 then
									Continue
								else if Global.SaleModule.BuyProductList[I].DcAmt > 0 then
									nDcAmt2 := nDcAmt2 + Global.SaleModule.BuyProductList[I].DcAmt;

								Continue;
              end;
						end
						else
						begin
							if nSalePrice1 = 0 then
								nSalePrice1 := nSalePrice1 + Global.SaleModule.BuyProductList[I].SalePrice;

							if Global.SaleModule.BuyProductList[I].DcAmt = 0 then
								Continue
							else if Global.SaleModule.BuyProductList[I].DcAmt > 0 then
								nDcAmt1 := nDcAmt1 + Global.SaleModule.BuyProductList[I].DcAmt;
						end;
					end;

					if Global.SaleModule.GameInfo.LaneUse = '2' then
					begin //ksj 230731 TotalAmt�� DCAmt ���κ��� ����
						if rSaleData.LaneNo = nLane1 then
						begin
							if (nDcAmt1 >= 0) and (nDcAmt1 < nSalePrice1) then
							begin
								RemainProdAmt1 := StrToInt(CurrToStr(nSalePrice1 - nDcAmt1));
								if rSaleData.DcProduct.RemainGameMin >= (rSaleData.SaleQty * rSaleData.GameProduct.UseGameMin) then
									rDisCount.DcValue := RemainProdAmt1 div rSaleData.GameProduct.ProdAmt
								else
									rDisCount.DcValue := rSaleData.DcProduct.RemainGameMin div rSaleData.GameProduct.UseGameMin;

								rDisCount.DcAmt := rDisCount.DcValue * rSaleData.GameProduct.ProdAmt;
								rSaleData.DisCountList.Add(rDisCount);
								rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;

								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end
							else
							begin
								rSaleData.DcProduct := rDcProduct;
								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end;
						end;

						if rSaleData.LaneNo = nLane2 then
						begin
							if (nDcAmt2 >= 0) and (nDcAmt2 < nSalePrice2) then
							begin
								RemainProdAmt2 := StrToInt(CurrToStr(nSalePrice2 - nDcAmt2));
								if rSaleData.DcProduct.RemainGameMin >= (rSaleData.SaleQty * rSaleData.GameProduct.UseGameMin) then
									rDisCount.DcValue := RemainProdAmt2 div rSaleData.GameProduct.ProdAmt
								else
									rDisCount.DcValue := rSaleData.DcProduct.RemainGameMin div rSaleData.GameProduct.UseGameMin;

								rDisCount.DcAmt := rDisCount.DcValue * rSaleData.GameProduct.ProdAmt;
								rSaleData.DisCountList.Add(rDisCount);
								rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;

								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end
							else
							begin
								rSaleData.DcProduct := rDcProduct;
								BuyProductList[AIdx] := rSaleData;
								Result := True;
								BuyCalc;
								Exit;
							end;
						end;
					end
					else
					begin //�ð��̿�� ���������� ���� ������ ��ǰ�ݾ� ��������(��ȭ������)
						if (nDcAmt1 >= 0) and (nDcAmt1 < nSalePrice1) then
						begin
							RemainProdAmt1 := StrToInt(CurrToStr(nSalePrice1 - nDcAmt1));

							if rSaleData.DcProduct.RemainGameMin >= (rSaleData.SaleQty * rSaleData.GameProduct.UseGameMin) then
								rDisCount.DcValue := RemainProdAmt1 div rSaleData.GameProduct.ProdAmt
							else
								rDisCount.DcValue := rSaleData.DcProduct.RemainGameMin div rSaleData.GameProduct.UseGameMin;

							rDisCount.DcAmt := rDisCount.DcValue * rSaleData.GameProduct.ProdAmt;							
							rSaleData.DisCountList.Add(rDisCount);
							rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;

							BuyProductList[AIdx] := rSaleData;
							Result := True;
							BuyCalc;
							Exit;
						end
						else
						begin
							rSaleData.DcProduct := rDcProduct;
							BuyProductList[AIdx] := rSaleData;
							Result := True;
							BuyCalc;
							Exit;
						end;
					end;

					if rSaleData.DcProduct.RemainGameMin >= (rSaleData.SaleQty * rSaleData.GameProduct.UseGameMin) then
						rDisCount.DcValue := rSaleData.SaleQty
					else                              //ksj 230720 RemainGameCnt->RemainGameMin ����
						rDisCount.DcValue := rSaleData.DcProduct.RemainGameMin div rSaleData.GameProduct.UseGameMin;

					rDisCount.DcAmt := rDisCount.DcValue * rSaleData.GameProduct.ProdAmt;
					rSaleData.DisCountList.Add(rDisCount);

					rSaleData.DcAmt := rSaleData.DcAmt + rDisCount.DcAmt;
				end
        else if (rSaleData.DcProduct.GameDiv = '3') then
        begin
           //����� �ݾ� ��û
          if GameItemType = gitGameCnt then
          begin
            GetGameProductAmt('101', rSaleData.DcProduct.DiscountFeeDiv);
						rSaleData.GameProduct := GetGameProductFee('101', rSaleData.DcProduct.DiscountFeeDiv);
          end
          else if GameItemType = gitGameTime then
          begin
            GetGameProductAmt('102', Global.Config.Store.TimeDefaultProdCd); //ksj 230714 �ð�������� ȸ�������� �Ϲݸ� ����
            rSaleData.GameProduct := GetGameProductFee('102', Global.Config.Store.TimeDefaultProdCd); //rSaleData.DcProduct.DiscountFeeDiv

						//ksj 230718 �ð������� ���� ����ȵǵ���
						rSaleData.DcProduct := rDcProduct;
          end;

          rSaleData.SalePrice := rSaleData.GameProduct.ProdAmt * rSaleData.SaleQty;
        end;
      end;

    end
    else //ksj 230717 ���� ���� ȸ�� ������ǰ �̼��ý� ����� �ݾ� ��û
    begin
      if GameItemType = gitGameCnt then
      begin
				GetGameProductAmt('101', Global.Config.Store.GameDefaultProdCd); //����� �Ϲ� ������� �����صл���
        rSaleData.GameProduct := GetGameProductFee('101', Global.Config.Store.GameDefaultProdCd);
      end
      else if GameItemType = gitGameTime then
      begin
				GetGameProductAmt('102', Global.Config.Store.TimeDefaultProdCd);
				rSaleData.GameProduct := GetGameProductFee('102', Global.Config.Store.TimeDefaultProdCd);
      end;

      rSaleData.SalePrice := rSaleData.GameProduct.ProdAmt * rSaleData.SaleQty;
    end;

		//ksj 230728 �����/ȸ���ǿ� ���� ��ȭ�� ���Ῡ��
		if rSaleData.DcProduct.ShoesFreeYn = 'Y' then
			rSaleData.ShoesUse := 'F'
		else
		begin
			if rSaleData.GameProduct.ShoesFreeYn = 'Y' then
				rSaleData.ShoesUse := 'F'
		end;

    BuyProductList[AIdx] := rSaleData;

    Result := True;
  finally
    BuyCalc;
  end;
end;

function TSaleModule.chgSaleDataSaleQty(AIdx, ACnt: Integer): Boolean;
var
  rSaleData: TSaleData;
  I, nIdx: Integer;
  rDisCount: TDiscount;
begin
  try
    Result := False;

    Log.D('chgSaleDataSaleQty', IntToStr(AIdx) + '-' + IntToStr(ACnt));
    Result := False;

    rSaleData := BuyProductList[AIdx];

		rSaleData.SaleQty := ACnt;
    rSaleData.SalePrice := rSaleData.GameProduct.ProdAmt * rSaleData.SaleQty;

		BuyProductList[AIdx] := rSaleData;

		Result := True;
	finally
		BuyCalc;
	end;
end;

function TSaleModule.chgSaleDataLane(AIdx: Integer; AUse: String): Boolean;
var
	rSaleData: TSaleData;
begin
	try
		Result := False;

		Log.D('chgSaleDataLane', IntToStr(AIdx) + '-' + AUse);
		Result := False;

		rSaleData := BuyProductList[AIdx];

		rSaleData.LaneNo := StrToInt(AUse);

		BuyProductList[AIdx] := rSaleData;

		Result := True;
	finally
		BuyCalc;
	end;
end;

//ksj 230905 �����̵��� ����ID �缳��
procedure TSaleModule.reCountBowlerId;
var
	I, Lane1Seq, Lane2Seq: Integer;
	rSaleData: TSaleData;
	sLaneNo: string;
begin
	Lane1Seq := 0;
	Lane2Seq := 0;

	for I := 0 to BuyProductList.Count - 1 do
	begin
		rSaleData := BuyProductList[I];
		sLaneNo := IntToStr(rSaleData.LaneNo);

		if odd(rSaleData.LaneNo) then    
		begin  //BolwerNmTm: array[0..5] of string = ('A', 'B', 'C', 'D', 'E', 'F');
			rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Lane1Seq];
			Lane1Seq := Lane1Seq + 1;
		end
		else
		begin
			rSaleData.BowlerId := StrZeroAdd(sLaneNo, 2) + BolwerNmTm[Lane2Seq];
			Lane2Seq := Lane2Seq + 1;
		end;

    //ȸ�������� ������ ������ �ٲ��ȵ�
		if rSaleData.MemberInfo.Code = '' then
			rSaleData.BowlerNm := rSaleData.BowlerId;

		BuyProductList[I] := rSaleData;
	end;

end;

function TSaleModule.chgSaleDataShoes(AIdx: Integer; AUse: String): Boolean;
var
  rSaleData: TSaleData;
begin
  try
    Result := False;
    Log.D('chgSaleDataShoes', IntToStr(AIdx) + '-' + AUse);

    rSaleData := BuyProductList[AIdx];
    rSaleData.ShoesUse := AUse;
    BuyProductList[AIdx] := rSaleData;

    Result := True;
  finally
    BuyCalc;
  end;
end;

function TSaleModule.regPayList: Boolean;
var
  i: Integer;
begin
  try
    PayListClear;

    for i := 0 to BuyProductList.Count - 1 do
    begin
      PayProductList.Add(BuyProductList[i]);
    end;

    Result := True;
  finally
    PayCalc;
  end;
end;

function TSaleModule.chgPayListSelect(AIdx: Integer; AUse: Boolean): Boolean;
var
  i: Integer;
  rSaleData: TSaleData;
begin
  try
    if GameItemType = gitGameCnt then
    begin     
      for i := 0 to PayProductList.Count - 1 do
      begin
        if PayProductList[i].BowlerSeq = AIdx then
        begin
          rSaleData := PayProductList[i];
          rSaleData.PaySelect := AUse;
          PayProductList[i] := rSaleData;
          Break;
        end;
      end;
    end
    else
    begin
      for i := 0 to PayProductList.Count - 1 do
      begin
        if PayProductList[i].LaneNo = AIdx then
        begin
          rSaleData := PayProductList[i];
          rSaleData.PaySelect := AUse;
          PayProductList[i] := rSaleData;
        end;
      end;
    end;

    Result := True;
  finally
    PayCalc;
  end;

end;

//function TSaleModule.delPayList(AIdx: Integer): Boolean;
//var
//	i: Integer;
//begin
//	try
//		for i := 0 to PayProductList.Count - 1 do
//		begin
//			if PayProductList[i].BowlerSeq = AIdx then
//			begin
//				PayProductList.Delete(i); //�������� ȭ���� �ٲ�� BuyProductList�� �׸���
//				Break;                    //�ֹ�ȭ���� �����͸� ���Ӽ��ÿ�?
//			end;                        //���Ӽ��� �����Ͱ����� ���� �ٲٴ������ΰ��� ��������ֳ�?
//		end;
//
//		Result := True;
//	finally
//		PayCalc;
//
//		//ksj 230621
//		delLaneCheak;
//	end;
//end;

function TSaleModule.delBuyList(AIdx: Integer): Boolean;
var
	i: Integer;
begin
	try
		for i := 0 to BuyProductList.Count - 1 do
		begin
			if BuyProductList[i].BowlerSeq = AIdx then
			begin
				BuyProductList.Delete(i);
				Break;
			end;
		end;

		Result := True;
	finally
		BuyCalc;

		//ksj 230621
		delLaneCheak;
	end;
end;

//ksj 230831 ���� �� ���������� �缼��(�����̵�,��ȭ �� ������������ ���)
procedure TSaleModule.reCountBowlerSeq;
var
	I: Integer;
	rSaleData: TSaleData;
begin
	for I := 0 to BuyProductList.Count - 1 do
	begin
		rSaleData := BuyProductList[I];
		rSaleData.BowlerSeq := I + 1;
		BuyProductList[I] := rSaleData;
	end;
end;

//ksj 230621 2�� ���� ������ ���������� ��������
procedure TSaleModule.delLaneCheak;
var
  i: Integer;
	rGameInfo: TGameInfo;
	bLane1, bLane2: Boolean;
begin
	if GameInfo.LaneUse = '2' then
	begin
		bLane1 := False;
		bLane2 := False;

		if PayProductList.Count = 0 then
		begin //ksj 230831
			for i := 0 to BuyProductList.Count - 1 do
			begin
				if GameInfo.Lane1 = BuyProductList[i].LaneNo  then
					bLane1 := true
				else
					bLane2 := true;
			end;
		end
		else
		begin
			for i := 0 to PayProductList.Count - 1 do
			begin
				if GameInfo.Lane1 = PayProductList[i].LaneNo  then
					bLane1 := true
				else
					bLane2 := true;
			end;
		end;
    //����2�� ����ϸ� ���ν��� ����
		if (blane1 = true) and (blane2 = true) then
			Exit;

		rGameInfo := GameInfo;
		rGameInfo.BowlerCnt := 0;
		for i := 0 to PayProductList.Count - 1 do
			rGameInfo.BowlerCnt := rGameInfo.BowlerCnt + 1;

		rGameInfo.LaneUse := '1';
		rGameInfo.LeagueUse := False;
		GameInfo := rGameInfo;

		LaneNoCheak;
	end;
end;

//ksj 230621 ���� ���� �� ����� ���� 1���϶� ���γѹ� üũ
procedure TSaleModule.LaneNoCheak;
var
	rLaneInfo: TLaneInfo;
begin //���Ӽ��ö� ����1����� Lane1,Lane2 ���� ���ϱ� ���Ⱑ �ǹ̰� ����?
	rLaneInfo := LaneInfo;

  if PayProductList.Count = 0 then
	begin //ksj 230831
		if BuyProductList[0].LaneNo = GameInfo.Lane1 then
		begin
			rLaneInfo.LaneNo := GameInfo.Lane1;
			rLaneInfo.LaneNm := IntToStr(GameInfo.Lane1);
		end
		else
		begin
			rLaneInfo.LaneNo := GameInfo.Lane2;
			rLaneInfo.LaneNm := IntToStr(GameInfo.Lane2);
		end;
	end
	else
	begin
		if PayProductList[0].LaneNo = GameInfo.Lane1 then
		begin
			rLaneInfo.LaneNo := GameInfo.Lane1;
			rLaneInfo.LaneNm := IntToStr(GameInfo.Lane1);
		end
		else
		begin
			rLaneInfo.LaneNo := GameInfo.Lane2;
			rLaneInfo.LaneNm := IntToStr(GameInfo.Lane2);
		end;
	end;
	LaneInfo := rLaneInfo;
end;

procedure TSaleModule.PayListClear;
var
  i: Integer;
begin

  try
    for i := PayProductList.Count - 1 downto 0 do
      PayProductList.Delete(i);

    PayProductList.Clear;

  except
    on E: Exception do
      Log.E('PayListClear', E.Message);
  end;

end;

function TSaleModule.PayListAllResult: Boolean;
var
  i: Integer;
  bPay: Boolean;
begin

  try
    bPay := True;
    for i := 0 to PayProductList.Count - 1 do
    begin
      if PayProductList[i].PayResult = False then
      begin
        bPay := False;
        Break;
      end;
    end;

    Result := bPay;
  except
    on E: Exception do
      Log.E('PayListAllResult', E.Message);
  end;

end;

procedure TSaleModule.BuyListClear;
var
  Index: Integer;
begin
	try
		//ksj 230825 �л��Ű���ʰ� �����ϴ� �Լ��� ����
		for Index := 0 to BuyProductList.Count - 1 do
			BuyProductList[Index].DiscountList.Free;

		for Index := BuyProductList.Count - 1 downto 0 do
      BuyProductList.Delete(Index);

    BuyProductList.Clear;
  except
    on E: Exception do
      Log.E('BuyListClear', E.Message);
  end;
end;

procedure TSaleModule.BuyCalc;
var
  Index: Integer;
  ASaleData: TSaleData;
begin
  TotalAmt := 0;
  GameAmt := 0;
  ShoesAmt := 0;
  VatAmt := 0;
  DCAmt := 0;
  RealAmt := 0;

  if BuyProductList.Count = 0 then
    Exit;

  for Index := 0 to BuyProductList.Count - 1 do
  begin
    GameAmt := GameAmt + BuyProductList[Index].SalePrice;

    if BuyProductList[Index].ShoesUse = 'Y' then
      ShoesAmt := ShoesAmt + SaleShoesProd.ProdAmt;

    DCAmt := DCAmt + BuyProductList[Index].DcAmt;
  end;

  TotalAmt := GameAmt + ShoesAmt;
  RealAmt := TotalAmt - DCAmt;
  VatAmt := RealAmt - Trunc(RealAmt / 1.1);
end;

procedure TSaleModule.PayCalc;
var
  AIndex, Index: Integer;
	nRemainTotal, nRemainDc, nResultTotal, nResultDc: Currency;
	rSaleData: TSaleData;
begin
  PayTotalAmt := 0;
  PayGameAmt := 0;
  PayShoesAmt := 0;
  PayVatAmt := 0;
  PayDCAmt := 0;
  PayRealAmt := 0;

  PaySelTotalAmt := 0;
  PaySelVatAmt := 0;
  PaySelDCAmt := 0;
  PaySelRealAmt := 0;

  PayResultAmt := 0;
  PayRemainAmt := 0;

  //nRemainTotal := 0;
  //nRemainDc := 0;
  nResultTotal := 0;
  nResultDc := 0;

  if PayProductList.Count = 0 then
    Exit;
	//ksj 230802 �ð�������� ���δ�
	if Global.SaleModule.GameItemType = gitGameTime then
	begin   //PayTotalAmt�� üũ�ȵȰŵ� ����  PaySelRealAmt�� ���� üũǥ�� �Ǿ��ִ� ���ϵ�����
		for Index := 0 to PayProductList.Count - 1 do
		begin
			if Global.SaleModule.GameInfo.LaneUse = '2' then
			begin
				if PayGameAmt = 0 then
					PayGameAmt := PayProductList[0].SalePrice * 2;

				if BuyProductList[Index].ShoesUse = 'Y' then
					PayShoesAmt := PayShoesAmt + SaleShoesProd.ProdAmt;
			end
			else
			begin
				if PayGameAmt = 0 then
				  PayGameAmt := PayProductList[0].SalePrice;

				if BuyProductList[Index].ShoesUse = 'Y' then
					PayShoesAmt := PayShoesAmt + SaleShoesProd.ProdAmt;
			end;

			PayDCAmt := PayDCAmt + PayProductList[Index].DcAmt;         //��������� ��Ż

			if PayProductList[Index].PayResult = True then //�����Ϸ�
			begin
				rSaleData := PayProductList[Index]; //�����Ϸ�ȰŴ� PaySelect�������Ѿ� �ֹ�����Ʈ �ø��� ����
				rSaleData.PaySelect := False;
				PayProductList[Index] := rSaleData;
				nResultTotal := nResultTotal + PayProductList[Index].SalePrice;
				if (BuyProductList[Index].ShoesUse = 'Y') and (BuyProductList[Index].ShoesUse <> 'F') then
					nResultTotal := nResultTotal + SaleShoesProd.ProdAmt;
				nResultDc := nResultDc + PayProductList[Index].DcAmt;
			end
			else
			begin
				if PayProductList[Index].PaySelect = True then  //���õȰ͸� �̴ϱ� ��ȭ��� dc�� �� �������Ͱ�����
				begin
					if PaySelTotalAmt = 0 then
						PaySelTotalAmt := PayProductList[0].SalePrice
					else
            PaySelTotalAmt := PaySelTotalAmt;
					if PayProductList[Index].LaneNo <> PayProductList[0].LaneNo then
						PaySelTotalAmt := PaySelTotalAmt + PayProductList[0].SalePrice;

					if (BuyProductList[Index].ShoesUse = 'Y') and (BuyProductList[Index].ShoesUse <> 'F') then
						PaySelTotalAmt := PaySelTotalAmt + SaleShoesProd.ProdAmt;

					PaySelDCAmt := PaySelDCAmt + PayProductList[Index].DcAmt;
				end;
			end;
		end;
	end
	else
	begin
		for Index := 0 to PayProductList.Count - 1 do
		begin
			PayGameAmt := PayGameAmt + PayProductList[Index].SalePrice; // ���� * ����
			PayDCAmt := PayDCAmt + PayProductList[Index].DcAmt;

			if BuyProductList[Index].ShoesUse = 'Y' then
				PayShoesAmt := PayShoesAmt + SaleShoesProd.ProdAmt;

			if PayProductList[Index].PayResult = True then //�����Ϸ�
			begin
        rSaleData := PayProductList[Index]; //�����Ϸ�ȰŴ� PaySelect�������Ѿ� �ֹ�����Ʈ �ø��� ����
				rSaleData.PaySelect := False;
				PayProductList[Index] := rSaleData;
				nResultTotal := nResultTotal + PayProductList[Index].SalePrice;  //�����Ϸ�ݾ� ������ ��ȭ�� �����̾ȵ�
				if (BuyProductList[Index].ShoesUse = 'Y') and (BuyProductList[Index].ShoesUse <> 'F') then
					nResultTotal := nResultTotal + SaleShoesProd.ProdAmt;
				nResultDc := nResultDc + PayProductList[Index].DcAmt;
			end
			else
			begin
				if PayProductList[Index].PaySelect = True then
				begin
					PaySelTotalAmt := PaySelTotalAmt + PayProductList[Index].SalePrice;
					if (BuyProductList[Index].ShoesUse = 'Y') and (BuyProductList[Index].ShoesUse <> 'F') then
						PaySelTotalAmt := PaySelTotalAmt + SaleShoesProd.ProdAmt;

					PaySelDCAmt := PaySelDCAmt + PayProductList[Index].DcAmt;
				end;
			end;
		end;
	end;

	PayTotalAmt := PayGameAmt + PayShoesAmt;
  PayRealAmt := PayTotalAmt - PayDCAmt;
  PayVatAmt := PayRealAmt - Trunc(PayRealAmt / 1.1);

  PaySelRealAmt := PaySelTotalAmt - PaySelDCAmt;
  PaySelVatAmt := PaySelRealAmt - Trunc(PaySelRealAmt / 1.1);

  PayResultAmt := nResultTotal - nResultDc; //�����Ϸ�ݾ�
  PayRemainAmt := PayRealAmt - PayResultAmt - PaySelRealAmt; //�ܿ��ݾ�

end;
{
procedure TSaleModule.PayCalc;
var
  AIndex, Index: Integer;
  nRemainTotal, nRemainDc, nResultTotal, nResultDc: Currency;
begin
  PayTotalAmt := 0;
  PayGameAmt := 0;
  PayShoesAmt := 0;
  PayVatAmt := 0;
  PayDCAmt := 0;
  PayRealAmt := 0;

  PaySelTotalAmt := 0;
  PaySelVatAmt := 0;
  PaySelDCAmt := 0;
  PaySelRealAmt := 0;

  PayResultAmt := 0;
  PayRemainAmt := 0;

  //nRemainTotal := 0;
  //nRemainDc := 0;
  nResultTotal := 0;
  nResultDc := 0;

  if PayProductList.Count = 0 then
    Exit;

  for Index := 0 to PayProductList.Count - 1 do
  begin
    PayGameAmt := PayGameAmt + PayProductList[Index].SalePrice; // ���� * ����
    PayDCAmt := PayDCAmt + PayProductList[Index].DcAmt;

    if BuyProductList[Index].ShoesUse = 'Y' then
      PayShoesAmt := PayShoesAmt + SaleShoesProd.ProdAmt;

    if PayProductList[Index].PayResult = True then //�����Ϸ�
    begin
      nResultTotal := nResultTotal + PayProductList[Index].SalePrice;
      nResultDc := nResultDc + PayProductList[Index].DcAmt;
    end
    else
    begin
      if PayProductList[Index].PaySelect = True then
      begin
        PaySelTotalAmt := PaySelTotalAmt + PayProductList[Index].SalePrice;
        if BuyProductList[Index].ShoesUse = 'Y' then
          PaySelTotalAmt := PaySelTotalAmt + SaleShoesProd.ProdAmt;

        PaySelDCAmt := PaySelDCAmt + PayProductList[Index].DcAmt;
      end;
    end;

  end;

  PayTotalAmt := PayGameAmt + PayShoesAmt;
  PayRealAmt := PayTotalAmt - PayDCAmt;
  PayVatAmt := PayRealAmt - Trunc(PayRealAmt / 1.1);

  PaySelRealAmt := PaySelTotalAmt - PaySelDCAmt;
  PaySelVatAmt := PaySelRealAmt - Trunc(PaySelRealAmt / 1.1);

  PayResultAmt := nResultTotal - nResultDc; //�����Ϸ�ݾ�
  PayRemainAmt := PayRealAmt - PayResultAmt - PaySelRealAmt; //�ܿ��ݾ�

end;
}
{
function TSaleModule.AddCheckPromotionType(ACode: string): Boolean;
var
  Index: Integer;
begin
  try
    Result := False;

    if ACode = '1' then
    begin
      if DisCountList.Count <> 0 then
      begin
        for Index := 0 to DisCountList.Count - 1 do
          if DisCountList[Index].dc_cond_div = '2' then
            Result := True;
      end;
    end
    else if ACode = '2' then
      Result := DisCountList.Count <> 0;

    if Result then
      Global.SBMessage.ShowMessageModalForm(MSG_PROMOTION + MSG_PROMOTION_OPTION_4);

  finally

  end;
end;
 }
{
function TSaleModule.AddCheckDiscount(AProductDiv, AProductDivDetail: string; AGubun: Integer): Boolean;
var
  Index: Integer;
begin
  try
    try
      Result := False;
      for Index := 0 to BuyProductList.Count - 1 do
      begin
        if (AProductDiv = 'A') or (AProductDivDetail = 'A') then
        begin

        end
        else if AProductDivDetail <> BuyProductList[Index].Products.Product_Div then
          Continue;

        if AGubun = 1 then
        begin
          if (BuyProductList[Index].Discount_Percent + 1) <= BuyProductList[Index].SaleQty then
            Result := True;
        end
        else
        begin
          if (BuyProductList[Index].Discount_Not_Percent + 1) <= BuyProductList[Index].SaleQty then
            Result := True;
        end;
      end;
    except
      on E: Exception do
        Log.E('AddCheckDiscount', E.Message);
    end;
  finally
  end;
end;
}
 {
function TSaleModule.AddChectDiscountAmt(AValue: Integer): Boolean;
var
  Index, ASumDCAmt: Integer;
begin
  try
    try
      Result := False;
      ASumDCAmt := 0;
      for Index := 0 to BuyProductList.Count - 1 do
        ASumDCAmt := ASumDCAmt + Trunc(BuyProductList[Index].DcAmt);

      if TotalAmt >= (ASumDCAmt + AValue) then
        Result := True;
    except
      on E: Exception do
        Log.E('AddChectDiscountAmt', E.Message);
    end;
  finally

  end;
end;
 }
 {
function TSaleModule.AddCheckDiscountQR(AQRCode: string): Boolean;
var
  Index: Integer;
begin
  try
    Result := False;
    for Index := 0 to DisCountList.Count - 1 do
    begin
      if DisCountList[Index].QRCode = AQRCode then
        Result := True;
    end;
  finally

  end;
end;
  }

(*
//function TSaleModule.AddCheckDiscountProductDiv(ACode: string): Boolean;
function TSaleModule.AddCheckDiscountProductDiv(AProductDiv, AProductDivDetail, AProductDivCd: string): Boolean;
begin
  {
  try
    Result := False;
    for Index := 0 to BuyProductList.Count - 1 do
    begin
      if (BuyProductList[Index].DcAmt = 0) and (BuyProductList[Index].Products.Product_Div = ACode) then
        Result := True;
    end;
  finally

  end;
  }
  Result := False;

  if (AProductDiv <> 'A') and (AProductDiv <> 'S') then
    Exit;

  if (AProductDivDetail = 'A') then
  begin
    Result := True;
    Exit;
  end;

  if BuyProductList[0].Products.Product_Div <> AProductDivDetail then
    Exit;

  if AProductDivCd <> '' then
  begin
    if BuyProductList[0].Products.Code <> AProductDivCd then
      Exit;
  end;

  Result := True;
end;
*)
  {
function TSaleModule.SetDiscount: Boolean;
var
  Index, ADCAmt: Integer;
  ADiscount: TDiscount;
  ASaleData: TSaleData;
begin
  try
    ADCAmt := 0;
    for Index := 0 to DisCountList.Count - 1 do
    begin
      ADiscount := DisCountList[Index];
      if ADiscount.Gubun = 1 then
        ADiscount.ApplyAmt := Trunc((TotalAmt * ADiscount.Value) * 0.01)
      else
        ADiscount.ApplyAmt := ADiscount.Value;
        
      DisCountList[Index] := ADiscount;

      ADCAmt := ADCAmt + DisCountList[Index].ApplyAmt;
    end;     

    // ���αݾ� 0���� �ʱ�ȭ
    for Index := 0 to BuyProductList.Count - 1 do
    begin
      ASaleData := BuyProductList[Index];
      ASaleData.DcAmt := 0;
      BuyProductList[Index] := ASaleData;    
    end;

    // ���� ����
    for Index := 0 to BuyProductList.Count - 1 do
    begin
      if ADCAmt = 0 then
        Continue;
      
      ASaleData := BuyProductList[Index];

      if (ASaleData.SalePrice - ADCAmt) < 0 then
      begin
        ASaleData.DcAmt := Trunc(ASaleData.SalePrice);
        ADCAmt :=  ADCAmt - Trunc(ASaleData.SalePrice);
      end
      else
      begin      
        ASaleData.DcAmt := ADCAmt;
        ADCAmt := 0;      
      end;     

      BuyProductList[Index] := ASaleData;
    end;
  finally

  end;
end;
}
 {
function TSaleModule.SetDiscount_Item: Boolean;
var
  Index, AIndex, Loop, MaxSalePrice, MaxSalePriceIndex: Integer;
  DiscountAmt, SaleDcAmt, AddDcAmt: Currency;
  ASaleData: TSaleData;
  ADiscount: TDiscount;
  function SortDiscountType: TList<TDiscount>;
  var
    SortIndex, ASortIndex, AValue: Integer;
    AValueList: TList<Integer>;
    ASortDiscount: TDiscount;
  begin
    try
      Result := TList<TDiscount>.Create;
      AValueList := TList<Integer>.Create;

      for SortIndex := 0 to DisCountList.Count - 1 do
      begin
        if DisCountList[SortIndex].Gubun = 1 then
          AValueList.Add(DisCountList[SortIndex].Value);
      end;

      AValueList.Sort;

      for SortIndex := AValueList.Count - 1 downto 0 do
      begin
        for ASortIndex := 0 to DisCountList.Count - 1 do
        begin
          if (DisCountList[ASortIndex].Gubun = 1) and (not DisCountList[ASortIndex].Sort) then
          begin
            AValue := AValueList[SortIndex];
            if DisCountList[ASortIndex].Value = AValueList[SortIndex] then
            begin
              ASortDiscount := DisCountList[ASortIndex];
              ASortDiscount.Sort := True;
              DisCountList[ASortIndex] := ASortDiscount;
              Result.Add(DisCountList[ASortIndex]);
            end;
          end;
        end;
      end;

      for SortIndex := 0 to DisCountList.Count - 1 do
      begin
        if not DisCountList[SortIndex].Sort then
          Result.Add(DisCountList[SortIndex]);
      end;
    finally
//      TListClear(AValueList);
      AValueList.Free;
    end;
  end;
begin
  try
    Result := False;
    // ���� ������ ����
    DisCountList := SortDiscountType;

    for AIndex := 0 to 2 - 1 do
    begin
      if AIndex = 0 then
      begin
        for Index := 0 to DisCountList.Count - 1 do
        begin
          ADiscount := DisCountList[Index];
          if ADiscount.Gubun = 1 then
          begin
            if not ADiscount.Add then
            begin
              MaxSalePrice := -1;
              MaxSalePriceIndex := -1;
              for Loop := 0 to BuyProductList.Count - 1 do
              begin
                if BuyProductList[Loop].SaleQty >= (BuyProductList[Loop].Discount_Percent + 1) then
                begin
                  if (ADiscount.Product_Div_Detail = BuyProductList[Loop].Products.Product_Div) or
                    (ADiscount.Product_Div = 'A') or (ADiscount.Product_Div = 'S') then
                  begin
                    if MaxSalePrice < (BuyProductList[Loop].SalePrice / BuyProductList[Loop].SaleQty) then
                    begin
                      MaxSalePrice := Trunc(BuyProductList[Loop].SalePrice / BuyProductList[Loop].SaleQty);
                      MaxSalePriceIndex := Loop;
                    end;
                  end;
                end;
              end;

              if MaxSalePriceIndex <> -1 then
              begin
                ASaleData := BuyProductList[MaxSalePriceIndex];
                if ASaleData.SaleQty >= (ASaleData.Discount_Percent + 1) then
                begin
                    ASaleData.DcAmt := ASaleData.DcAmt + ((ASaleData.SalePrice / ASaleData.SaleQty) * ADiscount.Value) * 0.01;

  //                BuyProductList[MaxSalePriceIndex] := ASaleData;

                    ADiscount.ApplyAmt := Trunc(((ASaleData.SalePrice / ASaleData.SaleQty) * ADiscount.Value) * 0.01);
                  ADiscount.Add := True;
                  ASaleData.Discount_Percent := ASaleData.Discount_Percent + 1;
                  if ADiscount.ApplyAmt <> 0 then
                    ASaleData.DiscountList.Add(ADiscount);
  //                AddTotalDCAmt := AddTotalDCAmt + Trunc(((ASaleData.SalePrice / ASaleData.SaleQty) * ADiscount.Value) * 0.01);
                  BuyProductList[MaxSalePriceIndex] := ASaleData;
                  DisCountList[Index] := ADiscount;
                end
                else
                begin
                  MaxSalePrice := -1;
                  MaxSalePriceIndex := -1;
                end;
              end;
            end;
          end;
        end;
      end
      else if ADiscount.Gubun <> 999 then
      begin
//        for Index := 0 to DisCountList.Count - 1 do
//        begin
//          ADiscount := DisCountList[Index];
//          if (ADiscount.Gubun <> 1) and (not ADiscount.Add) then
//          begin
//            if not ADiscount.Add then
//            begin
//              // 1. �ݾ� ���ؼ� �־��ش�.
//              for Loop := 0 to BuyProductList.Count - 1 do
//              begin
//                if ADiscount.Add then
//                  Continue;
//
//                ASaleData := BuyProductList[Loop];
//                if ASaleData.SaleQty >= (ASaleData.Discount_Not_Percent + 1) then
//                begin
//                  if ASaleData.Products.Product_Div = ADiscount.Product_Div_Detail then
//                  begin
//                    if ASaleData.SalePrice >= ASaleData.DcAmt + ADiscount.Value then
//                    begin
//                      ASaleData.DcAmt := ASaleData.DcAmt + ADiscount.Value;
//                      ASaleData.Discount_Not_Percent := ASaleData.Discount_Not_Percent + 1;
//                      ADiscount.Add := True;
//  //                    AddTotalDCAmt := AddTotalDCAmt + ADiscount.Value;
//                      BuyProductList[Loop] := ASaleData;
//                      DisCountList[Index] := ADiscount;
//                    end;
//                  end;
//                end;
//              end;
//
//              // 2. 1������ �߰��� �ȵǾ�����
//              if not ADiscount.Add then
//              begin
//                MaxSalePrice := -1;
//                MaxSalePriceIndex := -1;
//                for Loop := 0 to BuyProductList.Count - 1 do
//                begin
//                  ASaleData := BuyProductList[Loop];
//                  if ASaleData.SaleQty >= (ASaleData.Discount_Not_Percent + 1) then
//                  begin
//                    if ASaleData.Products.Product_Div = ADiscount.Product_Div_Detail then
//                    begin
//                      if MaxSalePrice < ADiscount.Value - (ASaleData.SalePrice - ASaleData.DcAmt) then
//                      begin
//                        MaxSalePrice := ADiscount.Value - Trunc(ASaleData.SalePrice - ASaleData.DcAmt);
//                        MaxSalePriceIndex := Loop;
//                      end;
//                    end;
//                  end;
//                end;
//
//                if MaxSalePriceIndex <> -1 then
//                begin
//                  ASaleData := BuyProductList[MaxSalePriceIndex];
//                  if ASaleData.SaleQty >= (ASaleData.Discount_Not_Percent + 1) then
//                  begin
//                    if ASaleData.Products.Product_Div = ADiscount.Product_Div_Detail then
//                    begin
//                      ASaleData.DcAmt := ASaleData.DcAmt + MaxSalePrice;
//  //                    AddTotalDCAmt := AddTotalDCAmt + MaxSalePrice;
//                      ASaleData.Discount_Not_Percent := ASaleData.Discount_Not_Percent + 1;
//                      ADiscount.Add := True;
//                      BuyProductList[MaxSalePriceIndex] := ASaleData;
//                      DisCountList[Index] := ADiscount;
//                    end;
//                  end;
//                end;
//              end;
//            end;
//          end;
//        end;

        for Index := 0 to DisCountList.Count - 1 do
        begin
          ADiscount := DisCountList[Index];
          if (ADiscount.Gubun <> 1) and (not ADiscount.Add) then
          begin
            DiscountAmt := ADiscount.Value;
            for Loop := 0 to BuyProductList.Count - 1 do
            begin
              if DiscountAmt = 0 then
                Continue;

              AddDcAmt := 0;
              if (BuyProductList[Loop].Products.Product_Div = ADiscount.Product_Div_Detail) or
                (ADiscount.Product_Div = 'A') or (ADiscount.Product_Div = 'S') then
              begin
                ASaleData := BuyProductList[Loop];
                SaleDcAmt := BuyProductList[Loop].SalePrice - BuyProductList[Loop].DCAmt;

                if SaleDcAmt = 0 then
                  Continue;

                // ApplyAmt Ȯ�� �ʿ�
                if DiscountAmt <= SaleDcAmt then
                begin
                  ASaleData.DcAmt := ASaleData.DcAmt + DiscountAmt;
                  AddDcAmt := DiscountAmt;
                  ADiscount.ApplyAmt := Trunc(DiscountAmt);
                  DiscountAmt := 0;
//                  ADiscount.ApplyAmt := Trunc(DiscountAmt);
                end
                else
                begin
                  ASaleData.DcAmt := ASaleData.DcAmt + SaleDcAmt;
                  DiscountAmt := DiscountAmt - SaleDcAmt;
//                  ADiscount.ApplyAmt := Trunc(DiscountAmt - SaleDcAmt);
                  ADiscount.ApplyAmt := Trunc(SaleDcAmt);
//                  AddDcAmt := SaleDcAmt;
                end;
                if ADiscount.ApplyAmt <> 0 then
                  ASaleData.DiscountList.Add(ADiscount);
                BuyProductList[Loop] := ASaleData;
              end;
            end;
          end;
          if ADiscount.Value <> DiscountAmt then
          begin
            ADiscount.Add := True;
            DisCountList[Index] := ADiscount;
          end;
        end;

      end;
    end;
    Result := True;
  except
    on E: Exception do
    begin

    end;
  end;
end;
 }
 {
function TSaleModule.SetDiscount_Item_ver2: Boolean;
var
  Index, AIndex, Loop, DiscountIndex, MaxSalePrice, MaxSalePriceIndex: Integer;
  DiscountAmt, SaleDcAmt, AddDcAmt: Currency;
  ASaleData: TSaleData;
  ADiscount: TDiscount;
  function SortDiscountType: TList<TDiscount>;
  var
    SortIndex, ASortIndex, AValue: Integer;
    AValueList: TList<Integer>;
    ASortDiscount: TDiscount;
  begin
    try
      Result := TList<TDiscount>.Create;
      AValueList := TList<Integer>.Create;

      for SortIndex := 0 to DisCountList.Count - 1 do
      begin
        if DisCountList[SortIndex].Gubun = 1 then
          AValueList.Add(DisCountList[SortIndex].Value);
      end;

      AValueList.Sort;

      for SortIndex := AValueList.Count - 1 downto 0 do
      begin
        for ASortIndex := 0 to DisCountList.Count - 1 do
        begin
          if (DisCountList[ASortIndex].Gubun = 1) and (not DisCountList[ASortIndex].Sort) then
          begin
            AValue := AValueList[SortIndex];
            if DisCountList[ASortIndex].Value = AValueList[SortIndex] then
            begin
              ASortDiscount := DisCountList[ASortIndex];
              ASortDiscount.Sort := True;
              DisCountList[ASortIndex] := ASortDiscount;
              Result.Add(DisCountList[ASortIndex]);
            end;
          end;
        end;
      end;

      for SortIndex := 0 to DisCountList.Count - 1 do
      begin
        if not DisCountList[SortIndex].Sort then
          Result.Add(DisCountList[SortIndex]);
      end;
    finally
//      TListClear(AValueList);
      AValueList.Free;
    end;
  end;
begin
  try
    Result := False;
    DiscountIndex := -1;
    // ���� ������ ����
    DisCountList := SortDiscountType;

    for AIndex := 0 to 2 - 1 do
    begin
      if AIndex = 0 then
      begin // fmx�ͽ�������
        for Index := 0 to DisCountList.Count - 1 do
        begin
          ADiscount := DisCountList[Index];
          if ADiscount.Gubun = 1 then
          begin
            AddDcAmt := 0;
            if not ADiscount.Add then
            begin
              MaxSalePrice := -1;
              MaxSalePriceIndex := -1;
              if DiscountIndex = -1 then
              begin
                for Loop := 0 to BuyProductList.Count - 1 do
                begin
                  //if ((ADiscount.Product_Div = 'A') or (ADiscount.Product_Div = 'S')) and
                    // ((ADiscount.Product_Div_Detail = 'A') or (ADiscount.Product_Div_Detail = BuyProductList[Loop].Products.Product_Div)) then
                  begin
                    if MaxSalePrice < (BuyProductList[Loop].SalePrice / BuyProductList[Loop].SaleQty) then
                    begin
                      MaxSalePrice := Trunc(BuyProductList[Loop].SalePrice / BuyProductList[Loop].SaleQty);
                      MaxSalePriceIndex := Loop;
                      DiscountIndex := Loop;
                    end;
                  end;
                end;
              end
              else
                MaxSalePriceIndex := DiscountIndex;

              if MaxSalePriceIndex <> -1 then
              begin
                ASaleData := BuyProductList[MaxSalePriceIndex];

                begin
                  if ((ASaleData.SalePrice / ASaleData.SaleQty) - ASaleData.DcAmt) = 0 then
                    Continue;
                end;

                begin     
                  AddDcAmt := ((ASaleData.SalePrice / ASaleData.SaleQty) * ADiscount.Value) * 0.01;
                  if (ASaleData.SalePrice / ASaleData.SaleQty) - (ASaleData.DcAmt + AddDcAmt) < 0 then
                    ADiscount.ApplyAmt := Trunc((ASaleData.SalePrice / ASaleData.SaleQty) - ASaleData.DcAmt)
                  else
                    ADiscount.ApplyAmt := Trunc(AddDcAmt);

                  ASaleData.DcAmt := ASaleData.DcAmt + AddDcAmt;
//                  ASaleData.DcAmt := ASaleData.DcAmt + ((ASaleData.SalePrice / ASaleData.SaleQty) * ADiscount.Value) * 0.01;
                end;

//                if Global.SaleModule.Member.XGolfMember and ASaleData.Products.xgolf_dc_yn then
//                  ADiscount.ApplyAmt := Trunc((((ASaleData.SalePrice / ASaleData.SaleQty) - ASaleData.Products.xgolf_dc_amt) * ADiscount.Value) * 0.01)
//                else
//                  ADiscount.ApplyAmt := Trunc(((ASaleData.SalePrice / ASaleData.SaleQty) * ADiscount.Value) * 0.01);
                ADiscount.Add := True;
//                ASaleData.Discount_Percent := ASaleData.Discount_Percent + 1;

                if (ADiscount.ApplyAmt <> 0) and (ADiscount.ApplyAmt > 0) then
                  ASaleData.DiscountList.Add(ADiscount);
//                AddTotalDCAmt := AddTotalDCAmt + Trunc(((ASaleData.SalePrice / ASaleData.SaleQty) * ADiscount.Value) * 0.01);
                BuyProductList[MaxSalePriceIndex] := ASaleData;
                DisCountList[Index] := ADiscount;
              end;
            end;
          end;
        end;
      end
      else
      begin // 999: XGOLF, 998: ī���
        if (ADiscount.Gubun = 999) or (ADiscount.Gubun = 998) then
          Continue;

        for Index := 0 to DisCountList.Count - 1 do
        begin
          ADiscount := DisCountList[Index];
          if (ADiscount.Gubun <> 1) and (not ADiscount.Add) then
          begin
            DiscountAmt := ADiscount.Value;
            for Loop := 0 to BuyProductList.Count - 1 do
            begin
              if DiscountAmt = 0 then
                Continue;

              AddDcAmt := 0;

              //if ((ADiscount.Product_Div = 'A') or (ADiscount.Product_Div = 'S')) and
                // ((ADiscount.Product_Div_Detail = 'A') or (ADiscount.Product_Div_Detail = BuyProductList[Loop].Products.Product_Div)) then
              begin
                ASaleData := BuyProductList[Loop];
                SaleDcAmt := BuyProductList[Loop].SalePrice - BuyProductList[Loop].DCAmt;

                if SaleDcAmt = 0 then
                  Continue;

                // ApplyAmt Ȯ�� �ʿ�
                if DiscountAmt <= SaleDcAmt then
                begin
                  ASaleData.DcAmt := ASaleData.DcAmt + DiscountAmt;
                  AddDcAmt := DiscountAmt;
                  ADiscount.ApplyAmt := Trunc(DiscountAmt);
                  DiscountAmt := 0;
                end
                else
                begin
                  ASaleData.DcAmt := ASaleData.DcAmt + SaleDcAmt;
                  DiscountAmt := DiscountAmt - SaleDcAmt;
                  ADiscount.ApplyAmt := Trunc(SaleDcAmt);
                end;
                if ADiscount.ApplyAmt <> 0 then
                  ASaleData.DiscountList.Add(ADiscount);
                BuyProductList[Loop] := ASaleData;
              end;
            end;
          end;
          if ADiscount.Value <> DiscountAmt then
          begin
            ADiscount.Add := True;
            DisCountList[Index] := ADiscount;
          end;
        end;
      end;
    end;
    Result := True;
  except
    on E: Exception do
    begin

    end;
  end;
end;
   }
function TSaleModule.CallAdmin(AType: Integer): Boolean;
var
  Indy: TIdTCPClient;
  Msg, sBuffer: string;
  JO: TJSONObject;
begin
  Result := False;
  JO := TJSONObject.Create;
  with TIdTCPClient.Create(nil) do
  try
    try
      JO.AddPair(TJSONPair.Create('error_cd', '6001'));
      JO.AddPair(TJSONPair.Create('sender_id', Global.Config.OAuth.TerminalId));

      if AType = 0 then
        JO.AddPair(TJSONPair.Create('error_msg', 'KIOSK ������ �������� ������ �����մϴ�!'))
      else
        JO.AddPair(TJSONPair.Create('error_msg', 'KIOSK �˸��� ȣ�� �׽�Ʈ �Դϴ�!'));

      sBuffer := JO.ToString;

      Host := Global.Config.Pos.IP;
      Port := Global.Config.Pos.Port;
      ConnectTimeout := 2000;
      ReadTimeout := 2000;
      Connect;
      IOHandler.Writeln(sBuffer, IndyTextEncoding_UTF8);

      if AType = 0 then
        Global.SBMessage.ShowMessageModalForm2(MSG_PRINT_ADMIN_CALL, True, 30, True, True)
      else
        Global.SBMessage.ShowMessageModalForm2('KIOSK �˸��� ȣ�� �׽�Ʈ �Դϴ�!', True, 30, True, True);

      Result := Connected;
    except
      on e: Exception do
      begin
        Global.SBMessage.ShowMessage('11', '�˸�', MSG_ADMIN_CALL_FAIL);
        Log.E('CallAdmin', E.Message);
      end;
    end

  finally
    Disconnect;
    Free;
    FreeAndNilJSONObject(JO);
  end;

end;

function TSaleModule.CallCardInfo: string;
var
  ARecvInfo: TCardRecvInfoDM;
  ASendInfo: TCardSendInfoDM;
begin
  Result := EmptyStr;

  ARecvInfo := VanModule.CallCardInfo(ASendInfo);

  if ARecvInfo.Result then
    Result := ARecvInfo.CardBinNo;
end;

function TSaleModule.CallCard(ACardBin, ACode, AMsg: string; ADiscountAmt: Currency; IsAppCard: Boolean): TCardRecvInfoDM;
var
  ACard: TPayCard;
  ARecvInfo: TCardRecvInfoDM;
  ADiscountInfo: TDiscount;
begin
  try
    ACard := TPayCard.Create;

    if CardApplyType = catMagnetic then
      ACard.SendInfo.OTCNo := EmptyStr
    else
      ACard.SendInfo.OTCNo := ACardBin;
    {
    if ACardBin <> EmptyStr then
    begin
      ACard.SendInfo.CardBinNo := Copy(ACardBin, 1, 6);

      ADiscountInfo.Gubun := 998;

      if ADiscountAmt <> 0 then
      begin
        Log.D('ī������ - ��������', ARecvInfo.CardBinNo + FormatFloat('#,##0.##', ADiscountAmt));
        ADiscountInfo.QRCode := ACode;
        ADiscountInfo.Value := Trunc(ADiscountAmt);
        //Global.SaleModule.DisCountList.Add(ADiscountInfo);
        BuyCalc;
        ACard.CardDiscount := Trunc(ADiscountAmt);
      end
      else  // ���� ��� �ƴ�
      begin
        Log.D('ī������ ���� ��� �ƴ� - ���αݾ� 0', ACardBin);
        Log.D('ī������ ���� ��� �ƴ�', ACode);
        Log.D('ī������ ���� ��� �ƴ�', AMsg);
      end;
    end
    else
    begin
      Log.D('ī������ ���� ��� �ƴ�', ARecvInfo.CardBinNo);
      Log.D('ī������ ���� ��� �ƴ�', ACode);
      Log.D('ī������ ���� ��� �ƴ�', AMsg);
    end;
    }
    Log.D('ī����� Bin, OTC', ACard.SendInfo.CardBinNo + ':' + ACard.SendInfo.OTCNo);

    ACard.SendInfo.Approval := True;
    ACard.SendInfo.SaleAmt := RealAmt;
    ACard.SendInfo.VatAmt := VatAmt;
    ACard.SendInfo.FreeAmt := 0;
    ACard.SendInfo.SvcAmt := 0;
    ACard.SendInfo.EyCard := False;
    ACard.SendInfo.HalbuMonth := IfThen(Global.SaleModule.SelectHalbu = 1, 0, Global.SaleModule.SelectHalbu);
    ACard.SendInfo.BizNo := StringReplace(Global.Config.Store.BizNo, '-', '', [rfReplaceAll]);
    ACard.SendInfo.TerminalID := Global.Config.Store.VanTID;
    ACard.SendInfo.SignOption := 'T';

    //PG ����� ���
    //ACard.SendInfo.Reserved1 := 'PG';

    Sleep(50);
    (*
    {$IFDEF RELEASE}
    ACard.RecvInfo := VanModule.CallCard(ACard.SendInfo);
    {$ENDIF}
    {$IFDEF DEBUG}
    ACard.RecvInfo.Result := True;
    ACard.RecvInfo.AgreeNo := '0001';
    {
    ACard.RecvInfo.CardNo := '55992400********';
    ACard.RecvInfo.BalgupsaCode := '0800';
    ACard.RecvInfo.BalgupsaName := '����ī��';
    ACard.RecvInfo.CompCode := '0800';
    ACard.RecvInfo.CompName := '����';
    }
    {$ENDIF}
    *)

    ACard.RecvInfo.Result := True;
    ACard.RecvInfo.AgreeNo := '0001';

    Result := ACard.RecvInfo;
    if Result.Result then
    begin
      PayList.Add(ACard);
    end
    else
    begin
      //CardDiscountDelete;
    end;
  except
    on E: Exception do
    begin
      Log.E('TSaleModule.CallCard', E.Message);
    end;
  end;
end;

function TSaleModule.CallPayco: TPaycoNewRecvInfo;
const
  STX = #2;
  ETX = #3;
  FS  = #1;
var
  Index, ASaleQty: Integer;
  APayco: TPayPayco;
  GoodsNm, GoodsList: string;
begin
  try
    APayco := TPayPayco.Create;
    APayco.SendInfo.BizNo := StringReplace(Global.Config.Store.BizNo, '-', '', [rfReplaceAll]);
    APayco.SendInfo.TerminalID := Global.Config.Store.VanTID;
    APayco.SendInfo.SerialNo := Global.Config.Store.VanTID;
    APayco.SendInfo.VanName := GetVanCode;
    APayco.SendInfo.Approval := True;
    APayco.SendInfo.PayAmt := TotalAmt - DCAmt;
    APayco.SendInfo.TaxAmt := VatAmt;
    APayco.SendInfo.DutyAmt := (TotalAmt - DCAmt) - VatAmt;
    APayco.SendInfo.TaxAmt := VatAmt;
    APayco.SendInfo.FreeAmt := 0;
    APayco.SendInfo.TipAmt := 0;
    APayco.SendInfo.PointAmt := 0;
    APayco.SendInfo.CouponAmt := 0;
    APayco.SendInfo.ApprovalAmount := APayCo.SendInfo.PayAmt - APayCo.SendInfo.PointAmt - APayCo.SendInfo.CouponAmt;
    {
    for Index := 0 to BuyProductList.Count - 1 do
    begin
      if Index = 0 then
        GoodsNm := BuyProductList[Index].Products.Name;

      ASaleQty := ASaleQty + Trunc(BuyProductList[Index].SaleQty);
      if Index <> 0 then
        GoodsList := GoodsList + FS;
      GoodsList := GoodsList + BuyProductList[Index].Products.Code + FS +
        BuyProductList[Index].Products.Name + FS + CurrToStr(BuyProductList[Index].Products.ProdAmt) + FS + CurrToStr(BuyProductList[Index].SaleQty);
      GoodsList := GoodsList + FS + 'Y';
    end;
      }
    if BuyProductList.Count > 1 then
      GoodsNm := GoodsNm + '�� ' + IntToStr(BuyProductList.Count - 1);

    PaycoModule.GoodsName := GoodsNm;
    PaycoModule.GoodsList := GoodsList;

    APayco.RecvInfo := PaycoModule.ExecPayProc(APayco.SendInfo);

    Result := APayco.RecvInfo;

    if Result.Result then
      PayList.Add(APayCo);
  except
    on E: Exception do
    begin

    end;
  end;
end;

function TSaleModule.GetSumPayAmt(APayType: TPayTyepe): Currency;
var
  Index: Integer;
begin
  Result := 0;
  for Index := 0 to PayList.Count - 1 do
  begin
    if PayList[Index].PayType = ptCard then
      Result := Result + TPayCard(PayList[Index]).PayAmt;
  end;
end;

procedure TSaleModule.CallEmp;
begin
//
end;

function TSaleModule.GetMemberList: Boolean;
var
  rMemberInfoList: TList<TMemberInfo>;
  nIndex: integer;
  bMsg: Boolean;
begin

  try
    Result := False;

    if MemberList.Count = 0 then
    begin
      rMemberInfoList := Global.ErpApi.GetAllMemberInfo(bMsg);

      if bMsg = False then
      begin
        FreeAndNil(rMemberInfoList);
        Exit;
      end;

      for nIndex := 0 to rMemberInfoList.Count - 1 do
      begin
        MemberList.Add(rMemberInfoList[nIndex]);
      end;
      FreeAndNil(rMemberInfoList);
    end
    else
      MemberUpdateList := Global.ErpApi.GetAllMemberInfo(bMsg);

    Result := True;
  finally

  end;
end;

function TSaleModule.GetConfig: Boolean;
begin
  Result := False;
  Sleep(1000);

  if Global.ErpApi.GetConfig then
    Global.Config.LoadConfig;

  Result := True;
end;

function TSaleModule.GetGameProdList: Boolean;
var
  AList: TList<TGameProductInfo>;
  i, j, nIndex: Integer;
  bMsg: Boolean;
begin

  try
    Result := False;

    AList := Global.ErpApi.GetGameProductList(bMsg);

    if bMsg = False then
      Exit;

    if SaleGameProdList.Count = 0 then
    begin
      for i := 0 to AList.Count - 1 do
        SaleGameProdList.Add(AList[i]);
    end;
    {
    else
    begin
      if AList.Count > 0 then
      begin
        for i := 0 to AList.Count - 1 do
        begin
          nIndex := -1;

          for j := 0 to SaleGameProdList.Count - 1 do
          begin
            if AList[i].ProdDetailDiv <> SaleGameProdList[j].ProdDetailDiv then
              Continue;

            if AList[i].FeeDiv <> SaleGameProdList[j].FeeDiv then
              Continue;

            nIndex := j;
            SaleGameProdList[j] := AList[i];
            Break;
          end;

          if nIndex = -1 then
          begin
            SaleGameProdList.Add(AList[i]);
          end;

        end;
      end;
    end;
    }
    Result := True;
  finally
    FreeAndNil(AList);
  end;
end;


function TSaleModule.GetMemberShipProdList: Boolean;
var
  AList: TList<TMemberShipProductInfo>;
  i, j, nIndex: Integer;
  bMsg: Boolean;
begin

  try

    Result := False;
    AList := Global.ErpApi.GetMemberShipProductList(bMsg);

    if bMsg = False then
      Exit;

    if SaleMemberShipProdList.Count = 0 then
    begin
      for nIndex := 0 to AList.Count - 1 do
        SaleMemberShipProdList.Add(AList[nIndex]);
    end
    else
    begin
      if AList.Count > 0 then
      begin
        for i := 0 to AList.Count - 1 do
        begin
          nIndex := -1;

          for j := 0 to SaleMemberShipProdList.Count - 1 do
          begin
            if AList[i].ProdCd <> SaleMemberShipProdList[j].ProdCd then
              Continue;

            nIndex := j;
            SaleMemberShipProdList[j] := AList[i];
            Break;
          end;

          if nIndex = -1 then
          begin
            SaleMemberShipProdList.Add(AList[i]);
          end;

        end;
      end;

    end;

    Result := True;

  finally
    FreeAndNil(AList);
  end;

end;

function TSaleModule.GetRentProduct: Boolean;
var
  rGameProductInfo: TGameProductInfo;
begin
  Result := False;
  rGameProductInfo := Global.ErpApi.GetRentProduct;

  if rGameProductInfo.ProdCd <> '' then
    SaleShoesProd := rGameProductInfo;

  Result := True;
end;

function TSaleModule.GetGameProductAmt(ADetailDiv, AFeeDiv: String): Boolean;
var
	rProductInfo, rProductInfoTm: TGameProductInfo;
	i, nIdx: Integer;
begin
	Result := False;

  for i := 0 to SaleGameProdList.Count - 1 do
	begin
		if AFeeDiv = Global.Config.Store.GameDefaultProdCd then
		begin //ksj 230906 �⺻��ǰ�ڵ�� �ݾ��� �ҷ��ö��� FeeDiv(����� ����) ���� ProdCd(��ǰ�ڵ�)�� ���ؼ� ������
			if SaleGameProdList[i].ProdCd = AFeeDiv then
			begin
				nIdx := i;
				Break;
			end;
		end
		else if AFeeDiv = Global.Config.Store.TimeDefaultProdCd then
		begin
			if SaleGameProdList[i].ProdCd = AFeeDiv then
			begin
				nIdx := i;
				Break;
			end;
		end
		else
		begin
			if SaleGameProdList[i].ProdDetailDiv <> ADetailDiv then
				Continue;

			if SaleGameProdList[i].FeeDiv = AFeeDiv then
			begin
				nIdx := i;
				Break;
			end;
		end;
  end;

  rProductInfo := Global.ErpApi.GetProductAmt(SaleGameProdList[nIdx].ProdCd);
  if rProductInfo.ProdAmt = 0 then
    Exit;

  rProductInfoTm := SaleGameProdList[nIdx];
  rProductInfoTm.ProdAmt := rProductInfo.ProdAmt;
  SaleGameProdList[nIdx] := rProductInfoTm;

  Result := True;
end;

function TSaleModule.GetGameProductFee(ADetailDiv, AFeeDiv: String): TGameProductInfo;
var
   i: Integer;
begin

  for i := 0 to SaleGameProdList.Count - 1 do
	begin
    if AFeeDiv = Global.Config.Store.GameDefaultProdCd then
		begin //ksj 230906 �⺻��ǰ�ڵ�� �ݾ��� �ҷ��ö��� FeeDiv(����� ����) ���� ProdCd(��ǰ�ڵ�)�� ���ؼ� ������
			if SaleGameProdList[i].ProdCd = AFeeDiv then
			begin
				Result := SaleGameProdList[i];
				Break;
			end;
		end
		else if AFeeDiv = Global.Config.Store.TimeDefaultProdCd then
		begin
      if SaleGameProdList[i].ProdCd = AFeeDiv then
			begin
				Result := SaleGameProdList[i];
				Break;
			end;
		end
		else
		begin
			if SaleGameProdList[i].ProdDetailDiv <> ADetailDiv then
				Continue;

			if SaleGameProdList[i].FeeDiv = AFeeDiv then
			begin
				Result := SaleGameProdList[i];
				Break;
			end;
		end;
  end;
end;

function TSaleModule.GetRcpNo: Integer;
begin
  try
    Result := 0;

  except
    on E: Exception do
      Log.E('GetRcpNo', E.Message);
  end;
end;

function TSaleModule.DeviceInit: Boolean;
begin
  try
    Result := False;

    if not Global.Config.NoPayModule then
    begin
      VanModule := TVanDeamonModul.Create;
      VanModule.VanCode := GetVanCode;
      VanModule.ApplyConfigAll;

      PaycoModule := TPaycoNewModul.Create;
      PaycoModule.SetOpen;
    end;

    if not Global.Config.NoDevice then
    begin
      Print := TReceiptPrint.Create(Global.Config.Print.Port, br115200);
    end;

    Result := True;
  except
    on E: Exception do
    begin
      Log.D('ShowMain', 'DeviceInit Fail : ' + E.Message);
    end;
  end;
end;

function TSaleModule.GetVanCode: string;
begin
  if Global.Config.Store.VanCode = 1 then
    Result := VAN_CODE_KFTC
  else if Global.Config.Store.VanCode = 2 then
    Result := VAN_CODE_KICC
  else if Global.Config.Store.VanCode = 3 then
    Result := VAN_CODE_KIS
  else if Global.Config.Store.VanCode = 4 then
    Result := VAN_CODE_FDIK
  else if Global.Config.Store.VanCode = 5 then
    Result := VAN_CODE_KOCES
  else if Global.Config.Store.VanCode = 6 then
    Result := VAN_CODE_KSNET
  else if Global.Config.Store.VanCode = 7 then
    Result := VAN_CODE_JTNET
  else if Global.Config.Store.VanCode = 8 then
    Result := VAN_CODE_NICE
  else if Global.Config.Store.VanCode = 9 then
    Result := VAN_CODE_SMARTRO
  else if Global.Config.Store.VanCode = 10 then
    Result := VAN_CODE_KCP
  else if Global.Config.Store.VanCode = 11 then
    Result := VAN_CODE_DAOU
  else if Global.Config.Store.VanCode = 12 then
    Result := VAN_CODE_KOVAN
  else
    Result := VAN_CODE_SPC;
end;

function TSaleModule.MasterReception(AMember, AMemberShip, AShoesProd: Boolean): Boolean; //ȸ��, ȸ�����ǰ, ��ȭ
begin
  try
    Result := False;

    if AMember = True then //ȸ��, �����, ȸ�����ǰ, ��ȭ
    begin
      Global.SaleModule.GetMemberList;
    end;
 
    if AMemberShip = True then
    begin
      Global.SaleModule.GetMemberShipProdList; //ȸ���� ��ǰ
    end;

    if AShoesProd = True then
    begin
      Global.SaleModule.GetRentProduct; //��Ż-��ȭ
    end;

    Result := True;

  except
    on E: Exception do
    begin

    end;
  end;
end;

function TSaleModule.SaleCompleteProc: Boolean;
var
  AProduct: TProductInfo;
  I: Integer;
  bPay: Boolean;
  rSaleData: TSaleData;
begin
  try
    try
      Result := False;

      //������ ��ȣ ����
      Global.SaleModule.RcpAspNo := Global.Config.Store.StoreCode +             // 5
                                    Copy(Global.Config.OAuth.TerminalId, 8, 3) +  // 3
                                    FormatDateTime('YYMMDDHHNNSS', now);        // 12

      bPay := False;
      for I := 0 to PayProductList.Count - 1 do
      begin
        if (PayProductList[I].PaySelect = True) and (PayProductList[I].PayResult = False) then
        begin
          rSaleData := PayProductList[I];
          rSaleData.PayResult := True;
          rSaleData.ReceiptNo := Global.SaleModule.RcpAspNo;
          PayProductList[I] := rSaleData;

          bPay := True;
        end;
      end;

      if bPay = False then
      begin
        Log.D('SaleCompleteProc', 'No Select PayProductList');
        Exit;
      end;

      //  ��������
      if not Global.ErpApi.SaveSaleInfo then
      begin
        Log.E('SaleCompleteProc', 'False');
      end;

      if SaleUploadFail = False then
      begin
        {  //������ ��� ȭ�� ��ǥ��
        Global.SaleModule.PopUpFullLevel := pflPrint;
        ShowFullPopup;
        Exit;                                          
				}
				if Global.SaleModule.Print.PrintThread <> nil then
				begin
					Global.SaleModule.Print.PrintThread.ReceiptList.Add(Global.SaleModule.SetReceiptPrintData);
					Global.SaleModule.Print.PrintThread.Resume;
				end;
			end;
      Result := True;
    except
      on E: Exception do
        Log.E('SaleCompleteProc', E.Message);
    end;
  finally
    PayCalc;
  end;
end;

function TSaleModule.SaleCompleteMemberProc: Boolean;
var
  AProduct: TProductInfo;
  I: Integer;
  bPay: Boolean;
  rSaleData: TSaleData;
begin
  try
    try
      Result := False;

      //������ ��ȣ ����
      Global.SaleModule.RcpAspNo := Global.Config.Store.StoreCode +             // 5
                                    Copy(Global.Config.OAuth.TerminalId, 8, 3) +  // 3
                                    FormatDateTime('YYMMDDHHNNSS', now);        // 12

      //  �������� ���� �ʿ�
			if not Global.ErpApi.SaveSaleInfo then
      begin
        Log.E('SaleCompleteProc', 'False');
      end;

      //����ó�� Ȯ�� �ʿ� �ӽ÷� ������ ��� ���
      if SaleUploadFail then
      begin
        Global.SaleModule.PopUpLevel := plPrint;
        ShowPopup;

        PayCalc;

        Exit;
      end;

      Result := True;
    except
      on E: Exception do
        Log.E('SaleCompleteProc', E.Message);
    end;
  finally
  end;
end;

function TSaleModule.SaleCompleteAssign: Boolean;
var
  AProduct: TProductInfo;
  I: Integer;
  bPay: Boolean;
  rSaleData: TSaleData;
begin
  try
    try
      Result := False;

			if not Global.LocalApi.LaneReservation then
      begin
        Log.E('LaneReservation', '������� ����');
        Exit;
      end;

      Global.SaleModule.PopUpLevel := plAssignPrint;
      ShowPopup;

      Result := True;
    except
      on E: Exception do
        Log.E('SaleCompleteProc', E.Message);
    end;
  finally
  end;
end;

function TSaleModule.SetReceiptPrintData: string;
var
  Index, VatAmt: Integer;
  Main, Store, Order, MemberObJect, Receipt, JsonItem: TJSONObject;
  ProductList, Discount, PayList, OrderList: TJSONArray;
  ACard: TPayCard;
  APayco: TPayPayco;

  j, nGameAmt, nShoesAmt, nPoint, nCoupon, nTime: Integer;
begin
  Main := TJSONObject.Create;
  Store := TJSONObject.Create;
  //MemberObJect := TJSONObject.Create;
  Receipt := TJSONObject.Create;

  //OrderList := TJSONArray.Create;
  ProductList := TJSONArray.Create;
  //Discount := TJSONArray.Create;
  PayList := TJSONArray.Create;
  try
    try
//      Log.D('������ JSON Begin', Result);

      Main.AddPair(TJSONPair.Create('StoreInfo', Store));
      //Main.AddPair(TJSONPair.Create('OrderList', OrderList));
      //Main.AddPair(TJSONPair.Create('ReceiptMemberInfo', MemberObJect));
      Main.AddPair(TJSONPair.Create('ProductInfo', ProductList));
      Main.AddPair(TJSONPair.Create('PayInfo', PayList));
      //Main.AddPair(TJSONPair.Create('DiscountInfo', Discount));
      Main.AddPair(TJSONPair.Create('ReceiptEtc', Receipt));

      Store.AddPair(TJSONPair.Create('StoreName', Global.Config.Store.StoreName));
      Store.AddPair(TJSONPair.Create('BizNo', Global.Config.Store.BizNo));
      //Store.AddPair(TJSONPair.Create('BossName', Global.Config.Store.BossName));
      Store.AddPair(TJSONPair.Create('Tel', Global.Config.Store.Tel));
      Store.AddPair(TJSONPair.Create('Addr', Global.Config.Store.Addr));
     {
      // Ű����ũ�� 1�� POS�� �ݺ��� ���
      JsonItem := TJSONObject.Create;
      JsonItem.AddPair(TJSONPair.Create('ProductDiv', SelectProduct.Product_Div));
      JsonItem.AddPair(TJSONPair.Create('UseTime', SelectProduct.Start_Time));
      JsonItem.AddPair(TJSONPair.Create('One_Use_Time', SelectProduct.One_Use_Time));
      JsonItem.AddPair(TJSONPair.Create('Reserve_No', SelectProduct.Reserve_No));

      // �Ʒ� 5���� ������ ���õ� ����
      JsonItem.AddPair(TJSONPair.Create('UseProductName', SelectProduct.Name));
      JsonItem.AddPair(TJSONPair.Create('Coupon', TJSONBool.Create(IfThen(SelectProduct.Product_Div = PRODUCT_TYPE_C, True, False)).ToString)); // ���� ��� ����
      JsonItem.AddPair(TJSONPair.Create('CouponQty', TJSONNumber.Create(SelectProduct.UseCnt)));  // �ܿ� ���� ��
      JsonItem.AddPair(TJSONPair.Create('CouponUseDate', SelectProduct.Reserve_List));
      JsonItem.AddPair(TJSONPair.Create('ExpireDate', DateTimeSetString(SelectProduct.EndDate)));
      OrderList.Add(JsonItem);
       }

      nGameAmt := 0;
      nShoesAmt := 0;
      nPoint := 0;
      nCoupon := 0;
      nTime := 0;
      for Index := 0 to PayProductList.Count - 1 do
      begin
        if PayProductList[Index].PaySelect = False then
          Continue;

        if PayProductList[Index].PayResult = False then
          Continue;

				//ksj 230907 �ð����� ���δ� ���
				if GameItemType = gitGameCnt then
				begin
					nGameAmt := nGameAmt + Trunc(PayProductList[Index].SalePrice); // ���� * ����
				end
				else
				begin  //�ѱݾ��̳� �����ݾ��� erp������ �����ʹ�� �ؾߵɰŰ�����
					if Global.SaleModule.GameInfo.LaneUse = '2' then
					begin
						nGameAmt := Trunc(PayProductList[0].SalePrice) * 2; //���δٸ� �����Ͱ� ����Ʈ�� ����2�� ����ε�
					end
					else                       
					begin                 
						nGameAmt := Trunc(PayProductList[0].SalePrice);
					end;
				end;    

        if PayProductList[Index].ShoesUse = 'Y' then
          nShoesAmt := nShoesAmt + SaleShoesProd.ProdAmt;

        for j := 0 to PayProductList[Index].DiscountList.Count - 1 do
        begin
          if PayProductList[Index].DiscountList[j].DcType = 'P' then //����Ʈ ���
            nPoint := nPoint + PayProductList[Index].DiscountList[j].DcAmt
          else if PayProductList[Index].DiscountList[j].DcType = 'C' then //���� ���
            nCoupon := nCoupon + PayProductList[Index].DiscountList[j].DcValue
          else if PayProductList[Index].DiscountList[j].DcType = 'T' then
            nTime := nTime + PayProductList[Index].DiscountList[j].DcValue;
        end;
      end;
      //����� ������. �ؿ������ʹ� ����ǥ
      JsonItem := TJSONObject.Create;
      JsonItem.AddPair(TJSONPair.Create('Name', '���� �ݾ�(����)'));
      JsonItem.AddPair(TJSONPair.Create('Code', FormatFloat('#,##0.##', nGameAmt) + '��'));
      ProductList.Add(JsonItem);

      JsonItem := TJSONObject.Create;
      JsonItem.AddPair(TJSONPair.Create('Name', '���� �ݾ�(����ȭ)'));
      JsonItem.AddPair(TJSONPair.Create('Code', FormatFloat('#,##0.##', nShoesAmt) + '��'));
      ProductList.Add(JsonItem);

      JsonItem := TJSONObject.Create;
      JsonItem.AddPair(TJSONPair.Create('Name', '����Ʈ ���'));
      JsonItem.AddPair(TJSONPair.Create('Code', FormatFloat('#,##0.##', nPoint) + 'P'));
      ProductList.Add(JsonItem);

      JsonItem := TJSONObject.Create;
      JsonItem.AddPair(TJSONPair.Create('Name', '���� ���'));
      JsonItem.AddPair(TJSONPair.Create('Code', IntToStr(nCoupon)+ 'ȸ'));
      ProductList.Add(JsonItem);

      for Index := 0 to Global.SaleModule.PayList.Count - 1 do
      begin
        JsonItem := TJSONObject.Create;

        if TPayData(Global.SaleModule.PayList[Index]).PayType = ptCard then
        begin
          ACard := TPayCard(Global.SaleModule.PayList[Index]);
          JsonItem.AddPair(TJSONPair.Create('PayCode', 'Card'));
          JsonItem.AddPair(TJSONPair.Create('Approval', TJSONBool.Create(ACard.SendInfo.Approval).ToString));
          JsonItem.AddPair(TJSONPair.Create('Internet', TJSONBool.Create(True)));
{�� �����ݾ��̶� ���ƾ���}          JsonItem.AddPair(TJSONPair.Create('ApprovalAmt', TJSONNumber.Create(ACard.PayAmt)));
          JsonItem.AddPair(TJSONPair.Create('ApprovalNo', ACard.RecvInfo.AgreeNo));
          JsonItem.AddPair(TJSONPair.Create('OrgApprovalNo', ACard.SendInfo.OrgAgreeNo));
          JsonItem.AddPair(TJSONPair.Create('CardNo', ACard.RecvInfo.CardNo));
          JsonItem.AddPair(TJSONPair.Create('HalbuMonth', IntToStr(ACard.SendInfo.HalbuMonth)));
          JsonItem.AddPair(TJSONPair.Create('CompanyName', ACard.RecvInfo.CompName));
          JsonItem.AddPair(TJSONPair.Create('MerchantKey', ''));
          JsonItem.AddPair(TJSONPair.Create('TransDateTime', ACard.RecvInfo.AgreeDateTime));
          JsonItem.AddPair(TJSONPair.Create('BuyCompanyName', ACard.RecvInfo.BalgupsaName));
          JsonItem.AddPair(TJSONPair.Create('BuyTypeName', ACard.RecvInfo.BalgupsaCode));
        end
        else
        begin
          APayco := TPayPayco(Global.SaleModule.PayList[Index]);
          JsonItem.AddPair(TJSONPair.Create('PayCode', 'Payco'));
          JsonItem.AddPair(TJSONPair.Create('Approval', TJSONBool.Create(APayco.SendInfo.Approval).ToString));
					JsonItem.AddPair(TJSONPair.Create('Internet', TJSONBool.Create(True).ToString));
{�� �����ݾ��̶� ���ƾ���}          JsonItem.AddPair(TJSONPair.Create('ApprovalAmt', TJSONNumber.Create(APayco.PayAmt)));
					JsonItem.AddPair(TJSONPair.Create('ApprovalNo', APayco.RecvInfo.AgreeNo));
					JsonItem.AddPair(TJSONPair.Create('OrgApprovalNo', APayco.SendInfo.OrgAgreeNo));
					JsonItem.AddPair(TJSONPair.Create('CardNo', APayco.RecvInfo.RevCardNo));
					JsonItem.AddPair(TJSONPair.Create('HalbuMonth', APayco.RecvInfo.HalbuMonth));
					JsonItem.AddPair(TJSONPair.Create('CompanyName', APayco.RecvInfo.ApprovalCompanyName));
					JsonItem.AddPair(TJSONPair.Create('MerchantKey', APayco.RecvInfo.MerchantName));
					JsonItem.AddPair(TJSONPair.Create('TransDateTime', APayco.RecvInfo.TransDateTime));
					JsonItem.AddPair(TJSONPair.Create('BuyCompanyName', APayco.RecvInfo.BuyCompanyName));
					JsonItem.AddPair(TJSONPair.Create('BuyTypeName', APayco.RecvInfo.BuyTypeName));
				end;
				PayList.Add(JsonItem);
			end;

			Receipt.AddPair(TJSONPair.Create('RcpNo', TJSONNumber.Create(RcpNo)));
			Receipt.AddPair(TJSONPair.Create('SaleDate', FormatDateTime('yyyy-mm-dd', now)));
			Receipt.AddPair(TJSONPair.Create('ReturnDate', EmptyStr));
			Receipt.AddPair(TJSONPair.Create('RePrint', TJSONBool.Create(False).ToString));  // ����� ����
{�� �����ݾ��̶� ���ƾ���}			Receipt.AddPair(TJSONPair.Create('TotalAmt', TJSONNumber.Create(Trunc(TotalAmt))));
			Receipt.AddPair(TJSONPair.Create('DCAmt', TJSONNumber.Create(Trunc(DCAmt))));
			Receipt.AddPair(TJSONPair.Create('Receipt_No', RcpAspNo));
      Receipt.AddPair(TJSONPair.Create('Top1', Global.Config.Receipt.Top1));
      Receipt.AddPair(TJSONPair.Create('Top2', Global.Config.Receipt.Top2));
      Receipt.AddPair(TJSONPair.Create('Top3', Global.Config.Receipt.Top3));
      Receipt.AddPair(TJSONPair.Create('Top4', Global.Config.Receipt.Top4));
      Receipt.AddPair(TJSONPair.Create('Bottom1', Global.Config.Receipt.Bottom1));
      Receipt.AddPair(TJSONPair.Create('Bottom2', Global.Config.Receipt.Bottom2));
      Receipt.AddPair(TJSONPair.Create('Bottom3', Global.Config.Receipt.Bottom3));
      Receipt.AddPair(TJSONPair.Create('Bottom4', Global.Config.Receipt.Bottom4));

      Result := Main.ToString;

      Log.D('������ JSON', Result);
    finally
      Main.Free;
    end;
  except
    on E: Exception do
    begin
      Log.E('������ JSON', E.Message);
    end;
  end;
end;

function TSaleModule.SetAssignReceiptPrintData: string;
var
  Index, VatAmt: Integer;
  Main, JsonItem: TJSONObject;
  OrderList: TJSONArray;
  ACard: TPayCard;
  APayco: TPayPayco;

  j, nGameAmt, nShoesAmt, nPoint, nCoupon, nTime: Integer;
begin
  Main := TJSONObject.Create;
  //MemberObJect := TJSONObject.Create;
  OrderList := TJSONArray.Create;

  try
    try
			Main.AddPair(TJSONPair.Create('AssignNo', GameInfo.AssignNo));
      Main.AddPair(TJSONPair.Create('OrderList', OrderList));
      //Main.AddPair(TJSONPair.Create('ReceiptMemberInfo', MemberObJect));

      for Index := 0 to PayProductList.Count - 1 do
      begin

        if PayProductList[Index].PayResult = False then
          Continue;

        JsonItem := TJSONObject.Create;
                                   
        if PayProductList[Index].MemberInfo.Code <> '' then
          JsonItem.AddPair(TJSONPair.Create('Name', PayProductList[Index].MemberInfo.Name))
        else
					JsonItem.AddPair(TJSONPair.Create('Name', PayProductList[Index].BowlerNm));
                                       
				if GameItemType = gitGameCnt then
					JsonItem.AddPair(TJSONPair.Create('GameCnt', IntToStr(PayProductList[Index].SaleQty)))
				else                            //�ð����� (��)�����ǵ� ����Ʈ�ʿ����� ���ǹ����� ���̽������� �ٸ��� �����Ѱ�
					JsonItem.AddPair(TJSONPair.Create('GameCnt', IntToStr(PayProductList[Index].SaleQty * PayProductList[Index].GameProduct.UseGameMin)));
																	 
				JsonItem.AddPair(TJSONPair.Create('LaneNm', IntToStr(PayProductList[Index].LaneNo)));
				JsonItem.AddPair(TJSONPair.Create('ShoesYn', PayProductList[Index].ShoesUse));

				if GameItemType = gitGameCnt then
					JsonItem.AddPair(TJSONPair.Create('Price', FormatFloat('#,##0.##', PayProductList[Index].SalePrice) + '��'))
				else
				begin
					if Global.SaleModule.GameInfo.LaneUse = '2' then
					begin
						if odd(PayProductList[Index].LaneNo) then
						begin
							if Copy(PayProductList[Index].BowlerId, 3) = 'A' then
								JsonItem.AddPair(TJSONPair.Create('Price', FormatFloat('#,##0.##', PayProductList[Index].SalePrice) + '��'))
							else
								JsonItem.AddPair(TJSONPair.Create('Price', '0��'));
						end
						else
						begin
							if Copy(PayProductList[Index].BowlerId, 3) = 'A' then
								JsonItem.AddPair(TJSONPair.Create('Price', FormatFloat('#,##0.##', PayProductList[Index].SalePrice) + '��'))
							else
								JsonItem.AddPair(TJSONPair.Create('Price', '0��'));
						end;						
					end
					else
					begin
						if Copy(PayProductList[Index].BowlerId, 3) = 'A' then
							JsonItem.AddPair(TJSONPair.Create('Price', FormatFloat('#,##0.##', PayProductList[Index].SalePrice) + '��'))
						else
						  JsonItem.AddPair(TJSONPair.Create('Price', '0��'));	
					end;
				end;
				
				OrderList.Add(JsonItem);                   
      end;                                          

      Result := Main.ToString;

      Log.D('������ JSON', Result);
    finally
      Main.Free;
    end;
  except
    on E: Exception do
    begin
      Log.E('������ JSON', E.Message);
    end;
  end;
end;

function TSaleModule.TeeboxTimeCheck: Boolean;
var
  Index: Integer;
  ASelectTime, RealTime, Msg: string;
  //rTeeBoxInfo: TTeeBoxInfo;
begin
  try
    Result := False;

    Msg := EmptyStr;
    {
    rTeeBoxInfo := Global.Lane.GetUpdateTeeBoxListInfo(TeeBoxInfo.TasukNo);

    if (rTeeBoxInfo.ERR = 0) or True then
    begin
      ASelectTime := StringReplace(TeeBoxInfo.End_Time, ':', '', [rfReplaceAll]);
      RealTime := StringReplace(rTeeBoxInfo.End_Time, ':', '', [rfReplaceAll]);

      if ASelectTime = EmptyStr then
        ASelectTime := FormatDateTime('hhnn', Now);

      if RealTime = EmptyStr then
        RealTime := FormatDateTime('hhnn', Now);

      if (ABS(Trunc(StrToIntDef(RealTime, 0) - StrToIntDef(ASelectTime, 0)))) > 0 then
      begin
        if ABS(Trunc(StrToIntDef(RealTime, 0) - StrToIntDef(ASelectTime, 0))) > 10 then
        begin
          TeeboxTimeError := True;
          Log.D('CheckEndTime', '10�� �̻�');
          Log.D('CheckEndTime - Begin', TeeBoxInfo.End_Time);
          Log.D('CheckEndTime - End', RealTime);

          Msg := Format(MSG_TEEBOX_TIME_ERROR, [Copy(ASelectTime, 1, 2) + ':' + Copy(ASelectTime, 3, 2),
																								Copy(RealTime, 1, 2) + ':' + Copy(RealTime, 3, 2)]);

          if not Global.SBMessage.ShowMessageModalForm(Msg, False) then
          begin
            Log.D('TeeboxTimeCheck', '����� ���� ���');
            Exit;
          end;

          TeeBoxInfo := rTeeBoxInfo; //����� Ÿ�������� ����
          if StoreCloseTmCheck(BuyProductList[0].Products) = True then
          begin
            Exit;
          end;

        end
        else
        begin
          Log.D('CheckEndTime', '10�� ����');
          Log.D('CheckEndTime - Begin', TeeBoxInfo.End_Time);
          Log.D('CheckEndTime - End', RealTime);
        end;
      end
      else
      begin
        TeeboxTimeError := True;
        Log.D('CheckEndTime ����', '�ð� ���� ����');
      end;
    end
    else
    begin
      Msg := MSG_TEEBOX_TIME_ERROR_STATUS;
      Global.SBMessage.ShowMessageModalForm(Msg, False);
      Log.D('CheckEndTime ����', '������ �Ǵ� ��ȸ��');
      Exit;
    end;
     }
    Result := True;
  finally

  end;
end;

procedure TSaleModule.SaleDataClear;
var
  Index: Integer;
  ALaneInfo: TLaneInfo;
  AMemberInfo: TMemberInfo;
  AMemberProduct: TMemberProductInfo;
  AMemberShipProduct: TMemberShipProductInfo;
  APayData: TPayData;
begin
  try
    RcpNo := 0;
    SaleUploadFail := False;
    RcpAspNo := EmptyStr;
    IsComplete := False;
    VipDisCount := False;
    //VipTeeBox := False;

    ALaneInfo.LaneNo := -1;
    LaneInfo := ALaneInfo;

    AMemberInfo.Code := EmptyStr;

    Member := AMemberInfo;

    memberItemType := mitNone;
    GameItemType := gitNone;

    SelectProd := AMemberProduct; //ȸ������ ���û�ǰ
    SaleSelectMemberShipProd := AMemberShipProduct; //ȸ������ǰ ���û�ǰ

    //chy newmember
    NewMember := AMemberInfo;
    NewMemberItemType := nmitNone;

    if MemberProdList.Count <> 0 then
    begin
      for Index := MemberProdList.Count - 1 downto 0 do
        MemberProdList.Delete(Index);

      MemberProdList.Clear;
      MemberProdList.Count := 0;
    end;

		BuyListClear;
		PayListClear;
     {
    if DisCountList.Count <> 0 then
    begin
      for Index := ProductList.Count - 1 downto 0 do
        ProductList.Delete(Index);

      DisCountList.Clear;
      DisCountList.Count := 0;
    end;
       }
    if PayList.Count <> 0 then
    begin
      for Index := PayList.Count - 1 downto 0 do
      begin
        APayData := PayList[Index];
        APayData.Free;

        PayList.Delete(Index);
      end;

      PayList.Clear;
      PayList.Count := 0;
    end;

    PopUpLevel := plNone;
    PopUpFullLevel := pflNone;

    TotalAmt := 0;
    GameAmt := 0;
    ShoesAmt := 0;
    VatAmt := 0;
    DCAmt := 0;
    RealAmt := 0;

    PayTotalAmt := 0;
    PayGameAmt := 0;
    PayShoesAmt := 0;
    PayVatAmt := 0;
    PayDCAmt := 0;
    PayRealAmt := 0;

    PaySelTotalAmt := 0;
    PaySelVatAmt := 0;
    PaySelDCAmt := 0;
    PaySelRealAmt := 0;
    PayResultAmt := 0;
    PayRemainAmt := 0;

    MiniMapCursor := False;

    PrepareMin := StrToIntDef(Global.Config.PrePareMin, 5);

    SelectHalbu := 1;
    if Global.SaleModule.SaleDate <> FormatDateTime('yyyymmdd', now) then
      Global.SaleModule.SaleDate := FormatDateTime('yyyymmdd', now);

    TeeboxTimeError := False;

    CardApplyType := catNone;


    CouponMember := False;

    //2020-12-29 ��ī������
    FLockerEndDay := EmptyStr;

    FStoreCloseOver := False;
    FStoreCloseOverMin := EmptyStr;
    //FSendPrintError := False;

  except
    on E: Exception do
    begin
      Log.E('SaleDataClear', E.Message);
    end;
  end;
end;

function TSaleModule.SearchMember(ACode: string): TMemberInfo;
var
  Index: Integer;
  Msg, ADate: string;
  AMember: TMemberInfo;
  AddMember: Boolean;
begin
  // ASP Version�ΰ�� QR Code�� �˻�
  Result := AMember;
  AddMember := False;

  for Index := 0 to MemberUpdateList.Count - 1 do
  begin
    if MemberUpdateList[Index].QRCode = ACode then
    begin
      Result := MemberUpdateList[Index];
      AddMember := True;
      Log.D('Member Search QR MemberUpdateList Count : ', IntToStr(MemberUpdateList.Count));
    end;
  end;

  if not AddMember then
  begin
    for Index := 0 to MemberList.Count - 1 do
    begin
      if MemberList[Index].QRCode = ACode then
      begin
        Result := MemberList[Index];
        Log.D('Member Search QR MemberList Count : ', IntToStr(MemberList.Count));
      end;
    end;
  end;

  if Result.Code <> EmptyStr then
  begin
    Global.SaleModule.CouponMember := True;
  end;

end;

function TSaleModule.SearchPhoneMember(ACode: string): TMemberInfo;
var
  Index: Integer;
  Msg, ADate: string;
  AMember: TMemberInfo;
  AddMember: Boolean;
begin
  Result := AMember;
  AddMember := False;

  for Index := 0 to MemberUpdateList.Count - 1 do
  begin
    if MemberUpdateList[Index].MobileNo = ACode then
    begin
      Result := MemberUpdateList[Index];
      AddMember := True;
      Log.D('Member Search Phone MemberUpdateList Count : ', IntToStr(MemberUpdateList.Count));
    end;
  end;

  if not AddMember then
  begin
    for Index := 0 to MemberList.Count - 1 do
    begin
      if MemberList[Index].MobileNo = ACode then
      begin
        Result := MemberList[Index];
        Log.D('Member Search Phone MemberList Count : ', IntToStr(MemberList.Count));
			end;
		end;
    if Result.MobileNo = '' then//ksj 230728 ȸ������� �ش� ��ȭ��ȣ ������
		begin
			Global.SBMessage.ShowMessage('12', '�˸�', '��ġ�ϴ� ��ȭ��ȣ�� �����ϴ�.');
			Exit;
		end;
	end;
end;

{ TPayData }

constructor TPayData.Create;
begin

end;

destructor TPayData.Destroy;
begin

	inherited;
end;

{ TPayCard }

constructor TPayCard.Create;
begin
  inherited;
  FPayType := ptCard;
  CardDiscount := 0;
end;

destructor TPayCard.Destroy;
begin

  inherited;
end;

function TPayCard.PayAmt: Currency;
begin
  Result := SendInfo.SaleAmt;
end;

function TPayCard.PayType: TPayTyepe;
begin
  Result := FPayType;
end;

{ TPayPayco }

constructor TPayPayco.Create;
begin
  inherited;
  FPayType := ptPayco;
end;

destructor TPayPayco.Destroy;
begin

  inherited;
end;

function TPayPayco.PayAmt: Currency;
begin
  Result := SendInfo.PayAmt;
end;

function TPayPayco.PayType: TPayTyepe;
begin
  Result := FPayType;
end;

{ TMasterDownThread }
{
constructor TMasterDownThread.Create;
begin
  FreeOnTerminate := False;
  inherited Create(True);
  FAdvertis := 0;
end;

destructor TMasterDownThread.Destroy;
begin
//  Terminate;
//  Waitfor;
  inherited;
end;

procedure TMasterDownThread.Execute;
var
  AVersion: string;
begin
  inherited;

  while not Terminated do
  begin
    if Global.SaleModule.TeeBoxInfo.TasukNo = -1 then
    begin
      // CheckIntro : ��Ʈ�ΰ� �ƴҰ�� Ȯ��. ChangBottomImg �� �浹. ��Ʈ�� �ΰ�� ��� Ȯ���ؾ� �ϴ°� �ƴ���... MasterDownThread �ּ�ó��
      if (FAdvertis >= 2) and CheckIntro then
      begin
        AVersion := Global.Database.GetAdvertisVersion;
        if Global.Config.Version.AdvertisVersion <> AVersion then
        begin
          Global.Config.Version.AdvertisVersion := AVersion;
          Synchronize(Global.Database.SearchAdvertisList);
        end;
        FAdvertis := 0;
      end;
      Sleep(1200000); // 20�� ������ �ִ� 40�� ���� ����
      Inc(FAdvertis);
    end;
  end;
end;
}
{ TSoundThread }

constructor TSoundThread.Create;
begin
	FreeOnTerminate := False;
  inherited Create(True);
  SoundList := TList<string>.Create;
end;

destructor TSoundThread.Destroy;
begin
  SoundList.Free;
  inherited;
end;

procedure TSoundThread.Execute;
begin
  inherited;
	while not Terminated do
  begin

    try

      if SoundList.Count <> 0 then
      begin
        PlaySound(StringToOLEStr(SoundList[0]), 0, SND_SYNC);
        SoundList.Delete(0);
      end
      else
        Suspend;
      Sleep(300);

    except
      on e: Exception do
      begin
        Log.E('TSoundThread.Execute', E.Message);
      end;
    end;

  end;
end;

end.
