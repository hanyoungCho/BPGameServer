unit Unit7;

interface

uses
  uBiominiPlus2,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, MemDS, DBAccess,
  Uni, UniProvider, MySQLUniProvider;

type
  TForm7 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Connection: TUniConnection;
    MySQL: TMySQLUniProvider;
    Query: TUniQuery;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    Mini: TBioMiniPlus2;
  public
    { Public declarations }
    function QueryExec(ASQL: string; AParam: array of Variant): TUniQuery;
    procedure QueryRun(AQuery: TUniQuery);
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
  Mini.IsAdd := False;
  Mini.GetMemberIndex;
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
  Mini.IsAdd := True;
  Mini.AddData;
end;

procedure TForm7.Button3Click(Sender: TObject);
const
  SQL = 'SELECT * FROM FINGERPRINTS';
var
  Index, Loop: Integer;
  AQuery: TUniQuery;
  AData: TBlobData;
  AByteArray: Array of Array[0..384 - 1] of Byte;
  a: Array[0..384 - 1] of Byte;
begin
  if not Connection.Connected then
    Connection.Connect;

  AQuery := QueryExec(SQL, []);

  Mini.AddData(AQuery);
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  Mini := TBioMiniPlus2.Create;
end;

function TForm7.QueryExec(ASQL: string; AParam: array of Variant): TUniQuery;
var
  i: Integer;
begin
  Result := TUniQuery.Create(nil);
  try
    try
      Result.Connection := Connection;
      Result.SQL.Text := ASQL;
      if Result.Params.Count > 0 then
      begin
        for i := Low(AParam) to High(AParam) do
        begin
          if Result.Params[i].Name = 'Template' then
          begin
            Result.Params[i].DataType := ftBlob;
            Result.Params[i].Value := AParam[i];
          end
          else if VarType(AParam[i]) and varTypeMask = varCurrency then
            Result.Params[i].AsCurrency := AParam[i]
          else
            Result.Params[i].Value := AParam[i];
        end;
      end;
      QueryRun(Result);
      Result := Result;
    except on E: Exception do
      begin
//        Log.E('TFoodAsp.QueryExec', E.Message);
//        Log.E('TFoodAsp.QueryExec', ASQL);
        raise;
      end;
    end;
  finally
  end;
end;

procedure TForm7.QueryRun(AQuery: TUniQuery);
var
  Index: Integer;
  SqlText, LogText1, LogText2: string;
begin
  with AQuery do
  begin
    SqlText := UpperCase(Copy(SQL.Text, 1, 20));
    if Pos('SELECT', SqlText) > 0 then
      Open
    else
      ExecSql;
  end;
end;

end.
