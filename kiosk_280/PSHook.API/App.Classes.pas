unit App.Classes;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TPaymentCancel = class;

  EMessageBox = class(Exception)
  end;

  TMessageBoxOption = (Refresh, Membership);
  TMessageBoxOptions = set of TMessageBoxOption;

  IRoute = interface
  ['{1E798F39-0648-486C-B1CC-025D6062DF8D}']
    procedure Login;
    procedure Main;
    procedure Membership;
    procedure MembershipLogin;
    procedure MembershipLoginWaiting;
    procedure Sale;
    procedure PaymentWaiting;
    procedure PaymentProgressing;
    procedure PaymentCompleted;
    procedure PaymentCancel;
    procedure PaymentCancelWaiting(PaymentCancel: TPaymentCancel);
    procedure PaymentCancelProgressing(PaymentCancel: TPaymentCancel);
    procedure PaymentCancelCompleted;

    procedure Configuration;

    procedure BeginWait;
    procedure Wait(Message: string);
    procedure EndWait;

    procedure MessageBox(Title: string; Message: string; Options: TMessageBoxOptions);
    procedure Back;
    procedure BackNoRefresh;
    procedure BackToMembership;
  end;

  IPopup = interface
  ['{B41A8456-4017-4AA3-987E-8D5B0FC491DD}']
  end;

  IRefreshable = interface
  ['{63B6EE21-24B1-4016-A9BF-35F0BC2814F4}']
    procedure Refresh;
  end;

  IMessageBox = interface
  ['{B3F1F914-8A7E-4DC3-B4C9-971CB23C9956}']
    procedure Bind(Title: string; Message: string; Options: TMessageBoxOptions);
  end;

  IWait = interface
  ['{1F8F2D47-699D-4BAF-AEE8-CEDD221C1487}']
    procedure Bind(Message: string);
  end;

  IPaymentCancel = interface
  ['{E6825305-6562-4838-8FE9-1B36E343C963}']
    procedure Bind(PaymentCancel: TPaymentCancel);
  end;

  TSaleItem = class
  public
    Sequence: Integer;
    No: string;
    Name: string;
    Amount: Integer; // Price + Tax;
    Price: Integer;
    Tax: Integer;

    function GetCredit: Integer;

    procedure Assign(Source: TSaleItem);
  end;

  TInstallment = class
  private
    FValue: Integer;
    function GetDisplayText: string;
  public
    constructor Create(Value: Integer);

    property Value: Integer read FValue;
    property DisplayText: string read GetDisplayText;
  end;

  TPurchaseItem = class(TSaleItem)
  public
    Quantity: Integer;
  end;

  TPurchase = class
  public
    InstallmentIndex: Integer;
    ItemList: TList<TPurchaseItem>;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    function GetPrice: Integer;
    function GetTaxFreeItemPrice: Integer;
    function GetTaxItemPrice: Integer;
    function GetTax: Integer;
    function GetAmount: Integer;
  end;

  TReceipt = class
    CatId: string;
    ReplyCode: string;
    CardNo: string;
    TranAmt: string;
    AuthNo: string;
    ReplyDate: string;
    AccepterCode: string;
    AccepterName: string;
    IssuerCode: string;
    IssuerName: string;
    MerchantRegNo: string;
    TranNo: string;
    ReplyMsg1: string;
    ReplyMsg2: string;
    TradeReqDate: string;
    TradeReqTime: string;
    WCC: string;
    BarCodeNumber: string;
    Installment: string;
    VatAmt: string;

    function Clone: TReceipt;
  end;

  TBonusCredit = class
  public
    Rate: Integer;
    Amount: Integer;

  end;

  TMembershipPoint = class
  public
    REQ_IDTYPE: string;
    REQ_ID: string;
    REQ_PAY_TYPE: string;
    REQ_PAY_CHARGE: string;
    REQ_PAY_WON: string;
    REQ_PAY_CREDIT: string;
    REQ_PAY_NO: string;
    REQ_PAY_PRDID: string;
    REQ_PAY_NAME: string;
    REQ_PAY_NUM: string;
    PAY_RSTID: string;
    UserID: string;
    CreateDate: TDate;

    procedure Assign(Source: TMembershipPoint);

    function Clone: TMembershipPoint;
  end;

  TRefund = class
    REQ_IDTYPE: string;
    REQ_ID: string;
    REFUND_NO: string;
    REFUND_MEMO: string;
    PAY_RSTID: string;
    PAY_NO: string;
    PAY_PRDID: string;
    PAY_NAME: string;

    ResultID: string;
    CreateDateTime: TDateTime;
  end;

  TPosSaleItem = class
  public
    COCD: string;
    BRCD: string;
    BUUT: string;
    PONO: string;
    DATE: string;
    SLNO: string;
    SEQ: string;
    ITNO: string;
    QTY: string;
    UPRC: string;
    GAMT: string;
    TAX: string;
    AMT: string;
    CUNO: string;

    function Clone: TPosSaleItem;
  end;

  TPosSale = class
  public
    COCD: string;
    BRCD: string;
    BUUT: string;
    PONO: string;
    DATE: string;
    SLNO: string;
    KHCD: string;
    AMT: string;
    APNO: string;
    TID: string;
    CANO: string;
    BACD: string;
    BANM: string;
    MECD: string;
    MENM: string;
    TDDT: string;
    HBCT: string;
    TAX: string;
    APDT: string;
    KMNO: string;
    UDNO: string;
    MCDT: string;
    STUS: string;
    ItemList: TList<TPosSaleItem>;
    CreateDate: TDate;

    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TPosSale);

    function Clone: TPosSale;
  end;

  TUser = class
    ID: string;
    Name: string;
    QRCode: string;
    Grade: string;

    procedure Assign(Source: TUser);
  end;

  TUserCredit = class
  public
    Total: Integer;
    Cash: Integer;
    Reward: Integer;

    procedure Assign(Source: TUserCredit);
  end;

  TPaymentCancel = class
  public
    User: TUser;
    UserCredit: TUserCredit;
    PosSale: TPosSale;
    MembershipPoint: TMembershipPoint;
    Receipt: TReceipt;
    Purchase: TPurchase;

    constructor Create;
    destructor Destroy; override;

    function Clone: TPaymentCancel;

    procedure BuildPurchase;
  end;

implementation

{ TPurchase }

procedure TPurchase.Clear;
begin
  InstallmentIndex := 0;
  ItemList.Clear;
end;

constructor TPurchase.Create;
begin
  InstallmentIndex := 0;
  ItemList := TObjectList<TPurchaseItem>.Create;
end;

destructor TPurchase.Destroy;
begin
  ItemList.Free;

  inherited;
end;

function TPurchase.GetAmount: Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to ItemList.Count - 1 do
    Result := Result + ItemList.Items[I].Amount * ItemList.Items[I].Quantity;
end;

function TPurchase.GetPrice: Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to ItemList.Count - 1 do
    Result := Result + ItemList.Items[I].Price * ItemList.Items[I].Quantity;
end;

function TPurchase.GetTax: Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to ItemList.Count - 1 do
    Result := Result + ItemList.Items[I].Tax * ItemList.Items[I].Quantity;
end;

function TPurchase.GetTaxFreeItemPrice: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ItemList.Count - 1 do
  begin
    if ItemList.Items[I].Tax = 0 then
      Result := Result + ItemList.Items[I].Amount * ItemList.Items[I].Quantity;
  end;
end;

function TPurchase.GetTaxItemPrice: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ItemList.Count - 1 do
  begin
    if ItemList.Items[I].Tax > 0 then
      Result := Result + ItemList.Items[I].Amount * ItemList.Items[I].Quantity;
  end;
end;

{ TSaleItem }

procedure TSaleItem.Assign(Source: TSaleItem);
begin
  Sequence := Source.Sequence;
  No := Source.No;
  Name := Source.Name;
  Price := Source.Price;
  Amount := Source.Amount;
  Tax := Source.Tax;
end;

function TSaleItem.GetCredit: Integer;
begin
  Result := StrToIntDef(Name.Replace('R', '').Replace(' ', '').Replace(',', ''), 0);
end;

{ TInstallment }

constructor TInstallment.Create(Value: Integer);
begin
  FValue := Value;
end;

function TInstallment.GetDisplayText: string;
begin
  if FValue = 0 then
    Result := '일시불'
  else
    Result := Format('%d개월', [FValue]);
end;

{ TPosSale }

procedure TPosSale.Assign(Source: TPosSale);
var
  I: Integer;
begin
  COCD := Source.COCD;
  BRCD := Source.BRCD;
  BUUT := Source.BUUT;
  PONO := Source.PONO;
  DATE := Source.DATE;
  SLNO := Source.SLNO;
  KHCD := Source.KHCD;
  AMT := Source.AMT;
  APNO := Source.APNO;
  TID := Source.TID;
  CANO := Source.CANO;
  BACD := Source.BACD;
  BANM := Source.BANM;
  MECD := Source.MECD;
  MENM := Source.MENM;
  TDDT := Source.TDDT;
  HBCT := Source.HBCT;
  TAX := Source.TAX;
  APDT := Source.APDT;
  KMNO := Source.KMNO;
  UDNO := Source.UDNO;
  MCDT := Source.MCDT;
  STUS := Source.STUS;
  CreateDate := Source.CreateDate;

  ItemList.Clear;
  for I := 0 to Source.ItemList.Count - 1 do
    ItemList.Add(Source.ItemList.Items[I].Clone);
end;

function TPosSale.Clone: TPosSale;
var
  I: Integer;
begin
  Result := TPosSale.Create;
  Result.COCD := COCD;
  Result.BRCD := BRCD;
  Result.BUUT := BUUT;
  Result.PONO := PONO;
  Result.DATE := DATE;
  Result.SLNO := SLNO;
  Result.KHCD := KHCD;
  Result.AMT := AMT;
  Result.APNO := APNO;
  Result.TID := TID;
  Result.CANO := CANO;
  Result.BACD := BACD;
  Result.BANM := BANM;
  Result.MECD := MECD;
  Result.MENM := MENM;
  Result.TDDT := TDDT;
  Result.HBCT := HBCT;
  Result.TAX := TAX;
  Result.APDT := APDT;
  Result.KMNO := KMNO;
  Result.UDNO := UDNO;
  Result.MCDT := MCDT;
  Result.STUS := STUS;

  for I := 0 to ItemList.Count - 1 do
    Result.ItemList.Add(ItemList.Items[I].Clone);
end;

constructor TPosSale.Create;
begin
  ItemList := TObjectList<TPosSaleItem>.Create;
end;

destructor TPosSale.Destroy;
begin
  ItemList.Free;

  inherited;
end;

{ TPosSaleItem }

function TPosSaleItem.Clone: TPosSaleItem;
begin
  Result := TPosSaleItem.Create;
  Result.COCD := COCD;
  Result.BRCD := BRCD;
  Result.BUUT := BUUT;
  Result.PONO := PONO;
  Result.SLNO := SLNO;
  Result.SEQ := SEQ;
  Result.ITNO := ITNO;
  Result.QTY := QTY;
  Result.UPRC := UPRC;
  Result.GAMT := GAMT;
  Result.TAX := TAX;
  Result.AMT := AMT;
  Result.CUNO := CUNO;
end;

{ TPaymentCancel }

procedure TPaymentCancel.BuildPurchase;
var
  I: Integer;
  Item: TPurchaseItem;
begin
  Purchase.ItemList.Clear;

  for I := 0 to PosSale.ItemList.Count - 1 do
  begin
    Item := TPurchaseItem.Create;
    Item.Quantity := StrToIntDef(PosSale.ItemList.Items[I].QTY, 0);
    Item.Sequence := 0;
    Item.No := PosSale.ItemList.Items[I].ITNO;
    Item.Name := MembershipPoint.REQ_PAY_NAME;
    Item.Amount := StrToIntDef(PosSale.ItemList.Items[I].AMT, 0);
    Item.Price := StrToIntDef(PosSale.ItemList.Items[I].UPRC, 0);
    Item.Tax := StrToIntDef(PosSale.ItemList.Items[I].TAX, 0);

    Purchase.ItemList.Add(Item);
  end;
end;

function TPaymentCancel.Clone: TPaymentCancel;
begin
  Result := TPaymentCancel.Create;
  Result.User.Assign(User);
  Result.UserCredit.Assign(UserCredit);
  Result.PosSale.Assign(PosSale);
  Result.MembershipPoint.Assign(MembershipPoint);
end;

constructor TPaymentCancel.Create;
begin
  User := TUser.Create;
  UserCredit := TUserCredit.Create;
  PosSale := TPosSale.Create;
  MembershipPoint := TMembershipPoint.Create;
  Receipt := TReceipt.Create;
  Purchase := TPurchase.Create;
end;

destructor TPaymentCancel.Destroy;
begin
  User.Free;
  UserCredit.Free;
  PosSale.Free;
  MembershipPoint.Free;
  Receipt.Free;
  Purchase.Free;

  inherited;
end;

{ TUser }

procedure TUser.Assign(Source: TUser);
begin
  ID := Source.ID;
  Name := Source.Name;
  QRCode := Source.QRCode;
  Grade := Source.Grade;
end;

{ TUserCredit }

procedure TUserCredit.Assign(Source: TUserCredit);
begin
  Total := Source.Total;
  Cash := Source.Cash;
  Reward := Source.Reward;
end;

{ TMembershipPoint }

procedure TMembershipPoint.Assign(Source: TMembershipPoint);
begin
  REQ_IDTYPE := Source.REQ_IDTYPE;
  REQ_ID := Source.REQ_ID;
  REQ_PAY_TYPE := Source.REQ_PAY_TYPE;
  REQ_PAY_CHARGE := Source.REQ_PAY_CHARGE;
  REQ_PAY_WON := Source.REQ_PAY_WON;
  REQ_PAY_CREDIT := Source.REQ_PAY_CREDIT;
  REQ_PAY_NO := Source.REQ_PAY_NO;
  REQ_PAY_PRDID := Source.REQ_PAY_PRDID;
  REQ_PAY_NAME := Source.REQ_PAY_NAME;
  REQ_PAY_NUM := Source.REQ_PAY_NUM;
  PAY_RSTID := Source.PAY_RSTID;
  UserID := Source.UserID;
  CreateDate := Source.CreateDate;
end;

function TMembershipPoint.Clone: TMembershipPoint;
begin
  Result := TMembershipPoint.Create;
  Result.REQ_IDTYPE := REQ_IDTYPE;
  Result.REQ_ID := REQ_ID;
  Result.REQ_PAY_TYPE := REQ_PAY_TYPE;
  Result.REQ_PAY_CHARGE := REQ_PAY_CHARGE;
  Result.REQ_PAY_WON := REQ_PAY_WON;
  Result.REQ_PAY_CREDIT := REQ_PAY_CREDIT;
  Result.REQ_PAY_NO := REQ_PAY_NO;
  Result.REQ_PAY_PRDID := REQ_PAY_PRDID;
  Result.REQ_PAY_NAME := REQ_PAY_NAME;
  Result.REQ_PAY_NUM := REQ_PAY_NUM;
  Result.PAY_RSTID := PAY_RSTID;
  Result.UserID := UserID;
  Result.CreateDate := CreateDate;
end;

{ TReceipt }

function TReceipt.Clone: TReceipt;
begin
  Result := TReceipt.Create;
  Result.CatId := CatId;
  Result.ReplyCode := ReplyCode;
  Result.CardNo := CardNo;
  Result.TranAmt := TranAmt;
  Result.AuthNo := AuthNo;
  Result.ReplyDate := ReplyDate;
  Result.AccepterCode := AccepterCode;
  Result.AccepterName := AccepterName;
  Result.IssuerCode := IssuerCode;
  Result.IssuerName := IssuerName;
  Result.MerchantRegNo := MerchantRegNo;
  Result.TranNo := TranNo;
  Result.ReplyMsg1 := ReplyMsg1;
  Result.ReplyMsg2 := ReplyMsg2;
  Result.TradeReqDate := TradeReqDate;
  Result.TradeReqTime := TradeReqTime;
  Result.WCC := WCC;
  Result.BarCodeNumber := BarCodeNumber;
  Result.Installment := Installment;
  Result.VatAmt := VatAmt;
end;

end.
