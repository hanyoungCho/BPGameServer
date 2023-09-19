unit App.Configuration;

interface

uses
  System.IniFiles,
  System.SysUtils;

type
  TConfiguration = class
  private type
    TBase = class
      CompanyCode: string;
      BrandCode: string;
      StoreCode: string;
      StoreName:string;
      Address: string;
      Owner: string;
      Password: string;
      Phone: string;
      BusinessNo: string;
      PosNo: string;
    end;

    TDevice = class
      TerminalID: string;
      TerminalPort: Integer;
      TerminalBaudrate: Integer;
      ScannerPort: Integer;
      ScannerBaudrate: Integer;
      PrinterPort: Integer;
      PrinterBaudrate: Integer;
    end;

    TTime = class
      ItemRefresh: string;
      PaymentProgress: Integer;
      PaymentWait: Integer;
      StorageDays: Integer;
    end;

    TAPI = class
      GetItemList: string;
      PutSale: string;
      GetMembershipLogin: string;
      GetMembershipQRCode: string;
      GetMembershipPoint: string;
      PutMembershipPoint: string;
      Administrators: string;
    end;

    TDatabase = class
      Server: string;
      Username: string;
      Password: string;
      Database: string;
    end;

    TMessage = class
      Default: string;
      Extra: string;
      Gratitude: string;
    end;
  private
    FAPI: TAPI;
    FMessage: TMessage;
    FDevice: TDevice;
    FTime: TTime;
    FBase: TBase;
    FDatabase: TDatabase;

    function GetFileName: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load;
    procedure Save;

    property Base: TBase read FBase;
    property Device: TDevice read FDevice;
    property Time: TTime read FTime;
    property API: TAPI read FAPI;
    property Message: TMessage read FMessage;
    property Database: TDatabase read FDatabase;
  end;

implementation

{ TConfiguration }

constructor TConfiguration.Create;
begin
  FAPI := TAPI.Create;
  FMessage := TMessage.Create;
  FDevice := TDevice.Create;
  FTime := TTime.Create;
  FBase := TBase.Create;
  FDatabase := TDatabase.Create;

  Load;
end;

destructor TConfiguration.Destroy;
begin
  FAPI.Free;
  FMessage.Free;
  FDevice.Free;
  FTime.Free;
  FBase.Free;
  FDatabase.Free;

  inherited;
end;

function TConfiguration.GetFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.config');
end;

procedure TConfiguration.Load;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetFileName);
  try


    FBase.CompanyCode := IniFile.ReadString('base', 'company_code', '');
    FBase.BrandCode := IniFile.ReadString('base', 'brand_code', '');
    FBase.StoreCode := IniFile.ReadString('base', 'store_code', '');
    FBase.StoreName := IniFile.ReadString('base', 'store_name', '');
    FBase.Password := IniFile.ReadString('base', 'password', '');
    FBase.Owner := IniFile.ReadString('base', 'owner', '');
    FBase.Address := IniFile.ReadString('base', 'address', '');
    FBase.Phone := IniFile.ReadString('base', 'phone', '');
    FBase.BusinessNo := IniFile.ReadString('base', 'business_no', '');
    FBase.PosNo := IniFile.ReadString('base', 'pos_no', '');

    FDevice.TerminalID := IniFile.ReadString('device', 'terminal_id', '');
    FDevice.TerminalPort := IniFile.ReadInteger('device', 'terminal_port', 0);
    FDevice.TerminalBaudrate := IniFile.ReadInteger('device', 'terminal_baudrate', 0);
    FDevice.ScannerPort := IniFile.ReadInteger('device', 'scanner_port', 0);
    FDevice.ScannerBaudrate := IniFile.ReadInteger('device', 'scanner_baudrate', 0);
    FDevice.PrinterPort := IniFile.ReadInteger('device', 'printer_port', 0);
    FDevice.PrinterBaudrate := IniFile.ReadInteger('device', 'printer_baudrate', 0);

    FTime.ItemRefresh := IniFile.ReadString('time', 'item_refresh', '0000');
    FTime.PaymentProgress := IniFile.ReadInteger('time', 'payment_progress', 0);
    FTime.PaymentWait := IniFile.ReadInteger('time', 'payment_wait', 0);
    FTime.StorageDays := IniFile.ReadInteger('time', 'storage_days', 0);

    FAPI.GetItemList := IniFile.ReadString('api', 'get_item_list', '');
    FAPI.PutSale := IniFile.ReadString('api', 'put_sale', '');
    FAPI.GetMembershipLogin := IniFile.ReadString('api', 'get_membership_login', '');
    FAPI.GetMembershipQRCode := IniFile.ReadString('api', 'get_membership_qrcode', '');
    FAPI.GetMembershipPoint := IniFile.ReadString('api', 'get_membership_point', '');
    FAPI.PutMembershipPoint := IniFile.ReadString('api', 'put_membership_point', '');
    FAPI.Administrators := IniFile.ReadString('api', 'administrators', '');

    FMessage.Default := IniFile.ReadString('message', 'default', '');
    FMessage.Extra := IniFile.ReadString('message', 'extra', '');
    FMessage.Gratitude := IniFile.ReadString('message', 'gratitude', '');

    FDatabase.Server := IniFile.ReadString('database', 'server', '127.0.0.1');
    FDatabase.Username := IniFile.ReadString('database', 'username', 'sa');
    FDatabase.Password := IniFile.ReadString('database', 'password', '');
    FDatabase.Database := IniFile.ReadString('database', 'database', 'kiosk');
  finally
    IniFile.Free;
  end;
end;

procedure TConfiguration.Save;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetFileName);
  try
    IniFile.WriteString('base', 'company_code', FBase.CompanyCode);
    IniFile.WriteString('base', 'brand_code', FBase.BrandCode);
    IniFile.WriteString('base', 'store_code', FBase.StoreCode);
    IniFile.WriteString('base', 'store_name', FBase.StoreName);
    IniFile.WriteString('base', 'password', FBase.Password);
    IniFile.WriteString('base', 'address', FBase.Address);
    IniFile.WriteString('base', 'owner', FBase.Owner);
    IniFile.WriteString('base', 'phone', FBase.Phone);
    IniFile.WriteString('base', 'business_no', FBase.BusinessNo);
    IniFile.WriteString('base', 'pos_no', FBase.PosNo);

    IniFile.WriteString('device', 'terminal_id', FDevice.TerminalID);
    IniFile.WriteInteger('device', 'terminal_port', FDevice.TerminalPort);
    IniFile.WriteInteger('device', 'terminal_baudrate', FDevice.TerminalBaudrate);
    IniFile.WriteInteger('device', 'scanner_port', FDevice.ScannerPort);
    IniFile.WriteInteger('device', 'scanner_baudrate', FDevice.ScannerBaudrate);
    IniFile.WriteInteger('device', 'printer_port', FDevice.PrinterPort);
    IniFile.WriteInteger('device', 'printer_baudrate', FDevice.PrinterBaudrate);

    IniFile.WriteString('time', 'item_refresh', FTime.ItemRefresh);
    IniFile.WriteInteger('time', 'payment_progress', FTime.PaymentProgress);
    IniFile.WriteInteger('time', 'payment_wait', FTime.PaymentWait);
    IniFile.WriteInteger('time', 'storage_days', FTime.StorageDays);

    IniFile.WriteString('api', 'get_item_list', FAPI.GetItemList);
    IniFile.WriteString('api', 'put_sale', FAPI.PutSale);
    IniFile.WriteString('api', 'get_membership_login', FAPI.GetMembershipLogin);
    IniFile.WriteString('api', 'get_membership_qrcode', FAPI.GetMembershipQRCode);
    IniFile.WriteString('api', 'get_membership_point', FAPI.GetMembershipPoint);
    IniFile.WriteString('api', 'put_membership_point', FAPI.PutMembershipPoint);
    IniFile.WriteString('api', 'administrators', FAPI.Administrators);

    IniFile.WriteString('message', 'default', FMessage.Default);
    IniFile.WriteString('message', 'extra', FMessage.Extra);
    IniFile.WriteString('message', 'gratitude', FMessage.Gratitude);

    IniFile.WriteString('database', 'server', FDatabase.Server);
    IniFile.WriteString('database', 'username', FDatabase.Username);
    IniFile.WriteString('database', 'password', FDatabase.Password);
    IniFile.WriteString('database', 'database', FDatabase.Database);
  finally
    IniFile.Free;
  end;
end;

end.
