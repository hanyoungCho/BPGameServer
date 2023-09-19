unit uIntegerList;

(*
TIntegerList Class
==================
Copyright (c) 2010 Thomas Abel
www.abel-software.de

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Ordinary use
============
implementation

uses
  IntegerLists;

procedure DoSomething;
var
  List: TIntegerList;
begin
  List:=TIntegerList.Create;
  try
    List.Methods (self-explanatory, I hope so)
    ..
  except
    on E: Exception do
      ShowMessage('Fehler vom Typ: '+E.ClassName+', Meldung: '+E.Message);
  end;
  List.Free;
end;
*)

interface

type
  TIntegerListType = Integer; // Set your Integertype here
  TIntegerList = class(TObject)
    procedure Add(const Value: TIntegerListType);
    procedure Ins(const Index: Integer; const Value: TIntegerListType);
    procedure Del(const Index: Integer);
    procedure Exchange(const Index1, Index2: Integer);
    procedure Clear;
    procedure Sort;
    procedure SortDownwards;
    procedure Mix;
    procedure RemoveDoubles;
    function IndexOf(const Value: TIntegerListType): Integer;
    function IndexOfEx(const Value: TIntegerListType; const Index: Integer): Integer;

    procedure SetQuoteChar(const NewQuoteChar: Char); // Default is "
    procedure UseQuoteChars(const Default: Boolean); // Default is false
    procedure SetGermanCsvStandard;

    function LoadFromFile(const FileName: String): Boolean;
    function SaveToFile(const FileName: String): Boolean;
    function Min: TIntegerListType;
    function Max: TIntegerListType;
    procedure Inc(const Index: Integer); overload;
    procedure Dec(const Index: Integer); overload;
    procedure Inc(const Index: Integer; const N: TIntegerListType); overload;
    procedure Dec(const Index: Integer; const N: TIntegerListType); overload;
    function IndexOfMin: Integer;
    function IndexOfMax: Integer;
    procedure Replicate(AList: TIntegerList);
    procedure FillUp(const ItemsCount: Integer; const FirstValue, N: TIntegerListType);
  private
    FItems: array of TIntegerListType;
    FCount: Integer;
    FSeparator, FQuoteChar: Char;
    FUseQuoteChars: Boolean;
    function Trim(s: String): String;
    function StrToInt(s: String): TIntegerListType;
  protected
    procedure SetCount(const NewCount: Integer);
    procedure SetCapacity;
    function GetItem(Index: Integer): TIntegerListType;
    function GetFirstItem: TIntegerListType;
    function GetLastItem: TIntegerListType;
    procedure SetItem(Index: Integer; const Value: TIntegerListType);
    procedure SetFirstItem(const Value: TIntegerListType);
    procedure SetLastItem(const Value: TIntegerListType);
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read FCount;
    property Item[Index: Integer]: TIntegerListType read GetItem write SetItem;
    property First: TIntegerListType read GetFirstItem write SetFirstItem;
    property Last: TIntegerListType read GetLastItem write SetLastItem;
  end;

implementation

procedure TIntegerList.SetCount(const NewCount: Integer);
begin
  FCount:=NewCount;
end;

procedure TIntegerList.SetCapacity;
begin
  SetLength(FItems,FCount);
end;

function TIntegerList.GetItem(Index: Integer): TIntegerListType;
begin
  Result:=FItems[Index];
end;

procedure TIntegerList.SetItem(Index: Integer; const Value: TIntegerListType);
begin
  FItems[Index]:=Value;
end;

function TIntegerList.GetFirstItem: TIntegerListType;
begin
  Result:=FItems[0];
end;

function TIntegerList.GetLastItem: TIntegerListType;
begin
  Result:=FItems[FCount-1];
end;

procedure TIntegerList.SetFirstItem(const Value: TIntegerListType);
begin
  FItems[0]:=Value;
end;

procedure TIntegerList.SetLastItem(const Value: TIntegerListType);
begin
  FItems[FCount-1]:=Value;
end;

procedure TIntegerList.Add(const Value: TIntegerListType);
begin
  SetCount(FCount+1);
  SetCapacity;
  SetLastItem(Value);
end;

procedure TIntegerList.Ins(const Index: Integer; const Value: TIntegerListType);
var
  i: Integer;
begin
  SetCount(FCount+1);
  SetCapacity;
  for i:=Count-1 downto Index+1 do
    Item[i]:=Item[i-1];
  SetItem(Index,Value);
end;

procedure TIntegerList.Del(const Index: Integer);
var
  i: Integer;
begin
  SetCount(FCount-1);
  for i:=Index to Count-1 do
    Item[i]:=Item[i+1];     
  SetCapacity;
end;

function TIntegerList.IndexOfEx(const Value: TIntegerListType; const Index: Integer): Integer;
var
  i: Integer;
begin
  Result:=-1;
  for i:=Index to Count-1 do
    if Item[i] = Value then
    begin
      Result:=i;
      break;
    end;
end;

function TIntegerList.IndexOf(const Value: TIntegerListType): Integer;
begin
  Result:=IndexOfEx(Value,0);
end;

procedure TIntegerList.Exchange(const Index1, Index2: Integer);
var
  j: TIntegerListType;
begin
  j:=Item[Index1];
  Item[Index1]:=Item[Index2];
  Item[Index2]:=j;
end;

procedure TIntegerList.Sort;
var
  i,j: Integer;
begin
  for i:=0 to Count-2 do
    for j:=i+1 to Count-1 do
      if Item[i] > Item[j] then Exchange(i,j);
end;

procedure TIntegerList.SortDownwards;
var
  i,j: Integer;
begin
  for i:=0 to Count-2 do
    for j:=i+1 to Count-1 do
      if Item[i] < Item[j] then Exchange(i,j);
end;

procedure TIntegerList.Mix;
var
  MixList: TIntegerList;
  i: Integer;
begin
  Randomize;
  MixList:=TIntegerList.Create;
  while Count > 0 do
  begin
    i:=Random(Count);
    MixList.Add(Item[i]);
    Del(i);
  end;
  MixList.Replicate(Self);
  MixList.Free;
end;

function TIntegerList.Min: TIntegerListType;
var
  i: Integer;
begin
  Result:=First;
  for i:=1 to Count-1 do
    if Item[i] < Result then Result:=Item[i];
end;

function TIntegerList.Max: TIntegerListType;
var
  i: Integer;
begin
  Result:=First;
  for i:=1 to Count-1 do
    if Item[i] > Result then Result:=Item[i];
end;

function TIntegerList.IndexOfMin: Integer;
var
  i: Integer;
  j: TIntegerListType;
begin
  Result:=-1;
  j:=First;
  for i:=1 to Count-1 do
    if Item[i] < j then
    begin
      j:=Item[i];
      Result:=i;
    end;
end;

function TIntegerList.IndexOfMax: Integer;
var
  i: Integer;
  j: TIntegerListType;
begin
  Result:=-1;
  j:=First;
  for i:=1 to Count-1 do
    if Item[i] > j then
    begin
      j:=Item[i];
      Result:=i;
    end;
end;

procedure TIntegerList.RemoveDoubles;
var
  Doubles: TIntegerList;
  i,j: Integer;
begin
  Doubles:=TIntegerList.Create;
  Doubles.FillUp(Count,0,0);
  for i:=0 to Count-2 do
    for j:=i+1 to Count-1 do
      if Item[i] = Item[j] then Doubles.Item[i]:=1;
  i:=-1;
  while i < Count-1 do
  begin
    i:=i+1;
    if Doubles.Item[i] = 1 then
    begin
      Del(i);
      Doubles.Del(i);
      i:=i-1;
    end;
  end;
  Doubles.Free;
end;

function TIntegerList.Trim(s: String): String;
begin
  while Length(s) > 0 do
  begin
    if ((s[1] <= ' ') or (s[1] = FQuoteChar)) then
      delete(s,1,1)
    else
      break;
  end;
  while Length(s) > 0 do
  begin
    if ((s[Length(s)] <= ' ') or (s[Length(s)] = FQuoteChar)) then
      delete(s,Length(s),1)
    else
      break;
  end;
  Result:=s;
end;

function TIntegerList.StrToInt(s: String): TIntegerListType;
var
  Io: Integer;
begin
  s:=Trim(s);
  if s = '' then s:='0';
  Val(s,Result,Io);
  if Io <> 0 then Result:=0;
end;

procedure TIntegerList.SetGermanCsvStandard;
begin
  FSeparator:=';';
end;

procedure TIntegerList.SetQuoteChar(const NewQuoteChar: Char);
begin
  FQuoteChar:=NewQuoteChar;
end;

procedure TIntegerList.UseQuoteChars(const Default: Boolean);
begin
  FUseQuoteChars:=Default;
end;

function TIntegerList.LoadFromFile(const FileName: String): Boolean;
var
  f: TextFile;
  c: Char;
  s: String;
begin
  Result:=false;
  AssignFile(f,FileName);
  {$I-} Reset(f); {$I+}
  if IoResult = 0 then
  begin
    clear;
    s:='';
    while not eof(f) do
    begin
      Read(f,c);
      if c <> FSeparator then
        s:=s+c
      else
      begin
        Add(StrToInt(s));
        s:='';
      end;
    end;
    Closefile(f);
    Result:=true;
  end;
end;

function TIntegerList.SaveToFile(const FileName: String): Boolean;
var
  f: TextFile;
  i,j: Integer;
begin
  Result:=false;
  AssignFile(f,FileName);
  {$I-} Rewrite(f); {$I+}
  if IoResult = 0 then
  begin
    j:=0;
    for i:=0 to Count-1 do
    begin
      j:=j+1;
      if FUseQuoteChars then
        Write(f,FQuoteChar,item[i],FQuoteChar,FSeparator)
      else
        Write(f,item[i],FSeparator);
      if j = 10 then
        if i <> Count-1 then
        begin
          Writeln(f);
          j:=0;
        end;
    end;
    closeFile(f);
    Result:=true;
  end;
end;

procedure TIntegerList.Inc(const Index: Integer; const N: TIntegerListType);
begin
  Item[Index]:=Item[Index]+N;
end;

procedure TIntegerList.Inc(const Index: Integer);
begin
  Inc(Index,1);
end;

procedure TIntegerList.Dec(const Index: Integer; const N: TIntegerListType);
begin
  Item[Index]:=Item[Index]-N;
end;

procedure TIntegerList.Dec(const Index: Integer);
begin
  Dec(Index,1);
end;

procedure TIntegerList.Replicate(AList: TIntegerList);
var
  i: Integer;
begin
  AList.Clear;
  for i:=0 to Count-1 do
    AList.Add(Item[i]);
end;

procedure TIntegerList.FillUp(const ItemsCount: Integer; const FirstValue, N: TIntegerListType);
var
  i: Integer;
  j: TIntegerListType;
begin
  Clear;
  j:=FirstValue;
  for i:=1 to ItemsCount do
  begin
    Add(j);
    j:=j+N;
  end;
end;

procedure TIntegerList.Clear;
begin
  SetCount(0);
  SetCapacity;
end;

constructor TIntegerList.Create;
begin
  inherited Create;
  Clear;
  FQuoteChar:= '"';
  FUseQuoteChars:=false;
  FSeparator:=',';
end;

destructor TIntegerList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

end.



