unit uGlobal;

interface

uses
  uDBModule;

type
  TGlobal = class
  private
    FDBModule: TDBModule;
  public
    constructor Create;
    destructor Destroy; override;

    property DBModule: TDBModule read FDBModule write FDBModule;
  end;


implementation

{ TGlobal }

constructor TGlobal.Create;
begin
  DBModule := TDBModule.Create(nil);
end;

destructor TGlobal.Destroy;
begin
  DBModule.Free;
  inherited;
end;

end.
