unit App.Global;

interface

uses
  App.Classes,
  App.Configuration,

  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,

  FMX.Forms,

  Api.Database.DataModule,
  Api.Membership.DataModule,
  Api.Pos.DataModule,
  Api.Payment.DataModule,
  Api.Printer.DataModule,
  Api.CardReader.DataModule,
  Api.BarcodeScanner.DataModule;

type
  TGlobal = class
  strict private
    class var FInstance: TGlobal;
    class constructor Create;
    class destructor Destroy;
  public
    class property Instance: TGlobal read FInstance;
  private
    FConfiguration: TConfiguration;
    FPayment: TApiPaymentModule;
    FPos: TApiPosModule;
    FPrinter: TApiPrinterModule;
    FMembership: TApiMembershipModule;
    FUserID: string;
    FUserIndex: Integer;
    FUserName: string;
    FUserCredit: Integer;
    FSaleItemList: TList<TSaleItem>;
    FPurchase: TPurchase;
    FReceipt: TReceipt;
    FUserQRCode: string;
    FCardReader: TApiCardReaderModule;
    FBonusCredit: TBonusCredit;
    FInstallmentList: TList<TInstallment>;
    FUserGrade: string;
    FDatabase: TApiDatabaseModule;
    FBarcodeScanner: TApiBarcodeScannerModule;

    FDocumentDate: TDate;
    FDocumentNumber: Integer;

    function GetRoute: IRoute;

    procedure Test;
    procedure LoadInstallmentList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure InitDocumentNumber;
    function NextDocumentNumber: Integer;

    property Route: IRoute read GetRoute;
    property Configuration: TConfiguration read FConfiguration;

    property Pos: TApiPosModule read FPos;
    property Membership: TApiMembershipModule read FMembership;
    property Printer: TApiPrinterModule read FPrinter;
    property Payment: TApiPaymentModule read FPayment;
    property CardReader: TApiCardReaderModule read FCardReader;
    property Database: TApiDatabaseModule read FDatabase;
    property BarcodeScanner: TApiBarcodeScannerModule read FBarcodeScanner;

    property SaleItemList: TList<TSaleItem> read FSaleItemList;
    property InstallmentList: TList<TInstallment> read FInstallmentList;

    property UserIndex: Integer read FUserIndex write FUserIndex;
    property UserID: string read FUserID write FUserID;
    property UserQRCode: string read FUserQRCode write FUserQRCode;
    property UserName: string read FUserName write FUserName;
    property UserGrade: string read FUserGrade write FUserGrade;
    property UserCredit: Integer read FUserCredit write FUserCredit;

    property Purchase: TPurchase read FPurchase;
    property Receipt: TReceipt read FReceipt;
    property BounsCredit: TBonusCredit read FBonusCredit;
  end;

procedure Async(Proc: TProc);
procedure Sync(Proc: TThreadProcedure);

implementation

procedure Async(Proc: TProc);
begin
  TThread.CreateAnonymousThread(Proc).Start;
end;

procedure Sync(Proc: TThreadProcedure);
begin
  TThread.Synchronize(nil, Proc);
end;

{ TGlobal }

class constructor TGlobal.Create;
begin
  FInstance := TGlobal.Create;
end;

class destructor TGlobal.Destroy;
begin
  FInstance.Free;
end;

constructor TGlobal.Create;
begin
  FDocumentDate := Now;
  FDocumentNumber := 0;

  FConfiguration := TConfiguration.Create;

  FSaleItemList := TObjectList<TSaleItem>.Create;
  FInstallmentList := TObjectList<TInstallment>.Create;

  FPayment := TApiPaymentModule.Create(nil);
  FPos := TApiPosModule.Create(nil);
  FPrinter := TApiPrinterModule.Create(nil);
  FMembership := TApiMembershipModule.Create(nil);
  FCardReader := TApiCardReaderModule.Create(nil);
  FDatabase := TApiDatabaseModule.Create(nil);
  FBarcodeScanner := TApiBarcodeScannerModule.Create(nil);

  FPurchase := TPurchase.Create;
  FReceipt := TReceipt.Create;
  FBonusCredit := TBonusCredit.Create;

  {$IFDEF DEBUG}
//  Test;
  {$ENDIF}

  LoadInstallmentList;
end;

destructor TGlobal.Destroy;
begin
  FBonusCredit.Free;
  FReceipt.Free;
  FPurchase.Free;

  FPayment.Free;
  FPos.Free;
  FPrinter.Free;
  FMembership.Free;
  FCardReader.Free;
  FDatabase.Free;
  FBarcodeScanner.Free;

  FSaleItemList.Free;
  FInstallmentList.Free;

  FConfiguration.Free;
end;

function TGlobal.GetRoute: IRoute;
begin
  Supports(Application.MainForm, IRoute, Result);
end;

procedure TGlobal.InitDocumentNumber;
var
  S: string;
begin
  S := FormatDateTime('yyyyMMdd', FDocumentDate);

  FDocumentNumber := FDatabase.PosSaleSuccess.LastNo(S);
end;

procedure TGlobal.LoadInstallmentList;
var
  I: Integer;
begin
  FInstallmentList.Clear;
  FInstallmentList.Add(TInstallment.Create(0));
  for I := 2 to 12 do
    FInstallmentList.Add(TInstallment.Create(I));
end;

function TGlobal.NextDocumentNumber: Integer;
begin
  if not SameDate(FDocumentDate, Now) then
  begin
    FDocumentDate := Now;
    FDocumentNumber := 0;
  end;
  Inc(FDocumentNumber);

  Result := FDocumentNumber;
end;

procedure TGlobal.Test;
var
  SaleItem: TSaleItem;
begin
  SaleItem := TSaleItem.Create;
  SaleItem.Name := '500R';
  SaleItem.Price := 5000;
  FSaleItemList.Add(SaleItem);

  SaleItem := TSaleItem.Create;
  SaleItem.Name := '1000R';
  SaleItem.Price := 9500;
  FSaleItemList.Add(SaleItem);

  SaleItem := TSaleItem.Create;
  SaleItem.Name := '2000R';
  SaleItem.Price := 14500;
  FSaleItemList.Add(SaleItem);

  SaleItem := TSaleItem.Create;
  SaleItem.Name := '3000R';
  SaleItem.Price := 19500;
  FSaleItemList.Add(SaleItem);

  SaleItem := TSaleItem.Create;
  SaleItem.Name := '5000R';
  SaleItem.Price := 24500;
  FSaleItemList.Add(SaleItem);
end;

end.
