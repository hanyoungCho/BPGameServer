unit uTeeboxReserveList;

interface

uses
  uStruct, uConsts,
  System.Classes, System.SysUtils, System.DateUtils,
  Uni, System.Generics.Collections;

type
  TTeeboxReserveList = class
  private
    FList: array of TReserveList;

    FTeeboxLastNo: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure StartUp;


    property TeeboxLastNo: Integer read FTeeboxLastNo write FTeeboxLastNo;
  end;

implementation

uses
  uGlobal, uFunction, JSON;

{ Tasuk }

constructor TTeeboxReserveList.Create;
begin
  TeeboxLastNo := 0;
end;

destructor TTeeboxReserveList.Destroy;
begin

  inherited;
end;

procedure TTeeboxReserveList.StartUp;
var
  nIndex: Integer;
begin

end;



end.
