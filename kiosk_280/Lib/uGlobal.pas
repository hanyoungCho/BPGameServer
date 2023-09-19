unit uGlobal;

interface

uses
  uCommon, uErpApi, uConsts, uLocalApi,
  uLaneInfo, uSaleModule, uStruct, System.Classes, uConfig;

type
  TGlobal = class
  private
    FErpApi: TErpAip;
    FLane: TLane;
    FSaleModule: TSaleModule;
    //FQueryError: Boolean;
    FConfig: TConfig;
    FSBMessage: TMessageForm;
    FLocalApi: TLocalApi;
  public

    SelectboxHandle: THandle; //newmember วฺต้
    MainHandle: THandle;

    constructor Create;
    destructor Destroy; override;

    property Config: TConfig read FConfig write FConfig;
    //property QueryError: Boolean read FQueryError write FQueryError;
    property ErpApi: TErpAip read FErpApi write FErpApi;
    property Lane: TLane read FLane write FLane;
    property SaleModule: TSaleModule read FSaleModule write FSaleModule;
    property SBMessage: TMessageForm read FSBMessage write FSBMessage;
    property LocalApi: TLocalApi read FLocalApi write FLocalApi;
  end;

var
  Global: TGlobal;

implementation

{ TGlobal }

constructor TGlobal.Create;
begin
  Config := TConfig.Create;
  ErpApi := TErpAip.Create;

  Lane := TLane.Create;
  SaleModule := TSaleModule.Create;
  SBMessage := TMessageForm.Create;
  LocalApi := TLocalApi.Create;
end;

destructor TGlobal.Destroy;
begin
  Lane.Free;

  ErpApi.Free;

  SaleModule.Free;
  SBMessage.Free;
  LocalApi.Free;

  Config.Free;
  inherited;
end;

end.

