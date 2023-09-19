unit fx.Json;

interface

uses
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  System.Rtti,
  System.JSON,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Readers,
  System.Generics.Collections,

  fx.Base,
  fx.Logging;

type
  { T = TJson }
  TJson = class
  public
    constructor Create; virtual;
    procedure Clear<T: class>(var Items: TArray<T>);

    function ToJson: string;
  end;
  TJsonClass = class of TJson;

  TJsonReadWriter = class
  private
    class var DateFormat: string;
    class var TimeFormat: string;
    class var DateTimeFormat: string;

    class constructor Create;

    class function StrToDate(Value: string): TDate;
    class function StrToTime(Value: string): TTime;
    class function StrToDateTime(Value: string): TDateTime;

    class procedure DoWrite(RttiType: TRttiType; Value: TValue; Writer: TJsonTextWriter); overload;
    class procedure DoWriteField(RttiField: TRttiField; Value: TValue; Writer: TJsonTextWriter); overload;
    class procedure DoWriteObject(RttiType: TRttiType; Instance: TObject; Writer: TJsonTextWriter); overload;

    class function DoRead(RttiType: TRttiType; Value: TValue): TValue;
    class function DoReadArray(RttiType: TRttiType; Reader: TJsonTextReader): TArray<TValue>;
    class procedure DoReadField(Instance: TValue; Reader: TJsonTextReader);
    class procedure DoReadObject(Instance: TValue; Reader: TJsonTextReader);
  public
    class function ObjectToJson<T: TJson>(Instance: T): string; overload;
    class function ObjectToJson(Instance: TObject): string; overload;
    class function ObjectToJson(RttiType: TRttiType; Instance: TObject): string; overload;
    class function JsonToObject<T: TJson>(Json: string): T; overload;
    class function JsonToObjectList<T: TJson>(Json: string): TArray<T>;
    class procedure JsonToObject<T: TJson>(Json: string; Instance: TJson); overload;

    class var NumberAsString: Boolean;
    class var PropertyNameLowerCase: Boolean;
    class var Indented: Boolean;
  end;

implementation

{ TJsonReaderWriter }

class procedure TJsonReadWriter.DoWriteField(RttiField: TRttiField; Value: TValue;
  Writer: TJsonTextWriter);
begin
  if PropertyNameLowerCase then
    Writer.WritePropertyName(LowerCase(RttiField.Name))
  else
    Writer.WritePropertyName(RttiField.Name);

  DoWrite(RttiField.FieldType, Value, Writer);
end;

class procedure TJsonReadWriter.DoWriteObject(RttiType: TRttiType; Instance: TObject;
  Writer: TJsonTextWriter);
var
  F: TRttiField;
begin
  Writer.WriteStartObject;

  for F in RttiType.AsInstance.GetDeclaredFields do
  begin
    if F.Visibility in [TMemberVisibility.mvPrivate, TMemberVisibility.mvProtected] then
      Continue;

    DoWriteField(F, F.GetValue(Pointer(Instance)), Writer);
  end;

  Writer.WriteEndObject;
end;

class procedure TJsonReadWriter.JsonToObject<T>(Json: string;
  Instance: TJson);
var
  StringReader: TStringReader;
  JsonTextReader: TJsonTextReader;
begin
  StringReader := TStringReader.Create(Json);
  try
    JsonTextReader := TJsonTextReader.Create(StringReader);
    try
      DoReadObject(Instance, JsonTextReader);
    finally
      JsonTextReader.Free;
    end;
  finally
    StringReader.Free;
  end;
end;

class function TJsonReadWriter.JsonToObjectList<T>(Json: string): TArray<T>;
var
  StringReader: TStringReader;
  JsonTextReader: TJsonTextReader;
  Values: TArray<TValue>;
  Value: TValue;
begin
  StringReader := TStringReader.Create(Json);
  try
    JsonTextReader := TJsonTextReader.Create(StringReader);
    try
      Values := DoReadArray(TType.GetType<TArray<T>>, JsonTextReader);

      Result := [];
      for Value in Values do
        Result := Result + [Value.AsType<T>]
    finally
      JsonTextReader.Free;
    end;
  finally
    StringReader.Free;
  end;
end;

class constructor TJsonReadWriter.Create;
begin
  NumberAsString := False;
  DateFormat := 'yyyymmdd';
  TimeFormat := 'hhnnss';
  DateTimeFormat := 'yyyymmddhhnnss';
  Indented := True;
end;

class function TJsonReadWriter.DoRead(RttiType: TRttiType; Value: TValue): TValue;
begin
  case RttiType.TypeKind of
    tkInteger:
      Result := Value;
    tkInt64:
      Result := Value;

    tkFloat:
    begin
      if RttiType.Handle = TypeInfo(TDate) then
        Result := StrToDate(Value.AsString)
      else if RttiType.Handle = TypeInfo(TTime) then
        Result := StrToTime(Value.AsString)
      else if RttiType.Handle = TypeInfo(TDateTime) then
        Result := StrToDateTime(Value.AsString)
      else
        Result := StrToFloat(Value.AsString)
    end;

    tkString,
    tkLString,
    tkWString,
    tkUString:
      Result := Value;

    tkEnumeration:
    begin
      if Value.IsType<Boolean> then
        Result := Value.AsBoolean
      else
        Result := TValue.FromOrdinal(RttiType.Handle, GetEnumValue(RttiType.Handle, Value.AsString));
    end;
  else
      Result := Value;
  end;
end;

class function TJsonReadWriter.DoReadArray(RttiType: TRttiType; Reader: TJsonTextReader): TArray<TValue>;
var
  ElementType: TRttiType;
  Json: TJson;
begin
  Result := [];

  if RttiType.TypeKind = tkArray then
    ElementType := TRttiArrayType(RttiType).ElementType
  else if RttiType.TypeKind = tkDynArray then
    ElementType := TRttiDynamicArrayType(RttiType).ElementType
  else if RttiType.TypeKind = tkSet then
    ElementType := TType.GetType<string>
  else
    ElementType := nil;

  if ElementType <> nil then
  begin
    while Reader.Read and (Reader.TokenType <> TJsonToken.EndArray) do
    begin
      if (ElementType <> nil) and (ElementType.TypeKind = tkClass) then
      begin
        Json := TJsonClass(ElementType.AsInstance.MetaclassType).Create;
        DoReadObject(Json, Reader);
        Result := Result + [Json];
      end
      else
        Result := Result + [DoRead(ElementType, Reader.Value)];
    end;
  end;
end;

class procedure TJsonReadWriter.DoReadField(Instance: TValue;
  Reader: TJsonTextReader);
var
  RttiField: TRttiField;
  Arr: TArray<TValue>;
  S: string;
  I: Integer;
  SetValue: Integer;
  Value: TValue;
begin
  RttiField := TType.GetType(Instance.TypeInfo).GetField(Reader.Value.AsString);

  if RttiField = nil then
  begin
    Log.D(ClassName, 'Not found %s field.', [Reader.Value.AsString]);
    Exit;
  end;

  if Reader.Read then
  begin
    case Reader.TokenType of
      TJsonToken.StartObject:
        DoReadObject(RttiField.GetValue(Pointer(Instance.AsObject)), Reader);

      TJsonToken.StartArray:
      begin
        Arr := DoReadArray(RttiField.FieldType, Reader);

        if RttiField.FieldType.TypeKind in [tkArray, tkDynArray] then
          RttiField.SetValue(Pointer(Instance.AsObject), TValue.FromArray(RttiField.FieldType.Handle, Arr))
        else // set
        begin
          S := '';
          for I := Low(Arr) to High(Arr) do
          begin
            if S = '' then
              S := Arr[I].AsString
            else
              S := S + ',' + Arr[I].AsString;
          end;

          SetValue := StringToSet(RttiField.FieldType.Handle, S);
          TValue.Make(@SetValue, RttiField.FieldType.Handle, Value);

          RttiField.SetValue(Pointer(Instance.AsObject), Value);
        end;
      end
    else
      RttiField.SetValue(Pointer(Instance.AsObject), DoRead(RttiField.FieldType, Reader.Value));
    end;
  end;
end;

class procedure TJsonReadWriter.DoReadObject(Instance: TValue;
  Reader: TJsonTextReader);
begin
  while Reader.Read do
  begin
    case Reader.TokenType of
      TJsonToken.PropertyName: DoReadField(Instance, Reader);
      TJsonToken.EndObject: Break;
    end;
  end;
end;

class procedure TJsonReadWriter.DoWrite(RttiType: TRttiType; Value: TValue;
  Writer: TJsonTextWriter);
var
  ElementType: TRttiType;
  I: Integer;
  RttiSetType: TRttiSetType;
  Arr: TArray<string>;
begin
  case RttiType.TypeKind of
    tkInteger:
      if NumberAsString then
        Writer.WriteValue(IntToStr(Value.AsInteger))
      else
        Writer.WriteValue(Value.AsInteger);
    tkInt64:
      if NumberAsString then
        Writer.WriteValue(IntToStr(Value.AsInt64))
      else
        Writer.WriteValue(Value.AsInt64);

    tkFloat:
    begin
      if RttiType.Handle = TypeInfo(TDate) then
      begin
        if Value.AsType<TDate> = 0 then
          Writer.WriteValue('')
        else
          Writer.WriteValue(FormatDateTime(DateFormat, Value.AsType<TDate>))
      end
      else if RttiType.Handle = TypeInfo(TTime) then
      begin
        if Value.AsType<TDate> = 0 then
          Writer.WriteValue('')
        else
          Writer.WriteValue(FormatDateTime(TimeFormat, Value.AsType<TTime>))
      end
      else if RttiType.Handle = TypeInfo(TDateTime) then
      begin
        if Value.AsType<TDate> = 0 then
          Writer.WriteValue('')
        else
          Writer.WriteValue(FormatDateTime(DateTimeFormat, Value.AsType<TDateTime>))
      end
      else if RttiType.Handle = Typeinfo(Currency) then
        Writer.WriteValue(Format('%d', [Trunc(Value.AsExtended)]))
      else
        Writer.WriteValue(Format('%f', [Value.AsExtended]));
    end;

    tkString,
    tkLString,
    tkWString,
    tkUString:
      Writer.WriteValue(Value.AsString);

    tkClass:
      DoWriteObject(TType.GetType(Value.TypeInfo), Value.AsObject, Writer);

    tkArray,
    tkDynArray:
    begin
      ElementType := TType.GetArrayElementType(Value.TypeInfo);

      Writer.WriteStartArray;
      if ElementType.TypeKind = tkClass then
      begin
        for I := 0 to Value.GetArrayLength - 1 do
          DoWriteObject(ElementType, Value.GetArrayElement(I).AsObject, Writer);
      end
      else
      begin
        for I := 0 to Value.GetArrayLength - 1 do
          DoWrite(ElementType, Value.GetArrayElement(I), Writer);
      end;
      Writer.WriteEndArray;
    end;

    tkEnumeration:
    begin
      if Value.IsType<Boolean> then
        Writer.WriteValue(Value.AsBoolean)
      else
        Writer.WriteValue(GetEnumName(Value.TypeInfo, Value.AsOrdinal));
    end;

    tkSet:
    begin
      Arr := SetToString(Value.TypeInfo, Value.GetReferenceToRawData).Split([',']);

      Writer.WriteStartArray;
      for I := Low(Arr) to High(Arr) do
        Writer.WriteValue(Arr[I]);
      Writer.WriteEndArray;
    end
  else
    Writer.WriteValue(Value.ToString);
  end;
end;

class function TJsonReadWriter.JsonToObject<T>(Json: string): T;
begin
  Result := T(TJsonClass(T).Create);

  JsonToObject<T>(Json, Result);
end;

class function TJsonReadWriter.ObjectToJson(Instance: TObject): string;
begin
  Result := ObjectToJson(TType.GetType(Instance.ClassType), Instance);
end;

class function TJsonReadWriter.ObjectToJson(RttiType: TRttiType;
  Instance: TObject): string;
var
  StringWriter: TStringWriter;
  JsonTextWriter: TJsonTextWriter;
begin
  StringWriter := TStringWriter.Create;
  try
    JsonTextWriter := TJsonTextWriter.Create(StringWriter);
    try
      if Indented then
        JsonTextWriter.Formatting := TJsonFormatting.Indented
      else
        JsonTextWriter.Formatting := TJsonFormatting.None;

      JsonTextWriter.EmptyValueHandling := TJsonEmptyValueHandling.Empty;

      DoWriteObject(RttiType, Instance, JsonTextWriter);
    finally
      JsonTextWriter.Free;
    end;

    Result := StringWriter.ToString;
  finally
    StringWriter.Free;
  end;
end;

class function TJsonReadWriter.ObjectToJson<T>(Instance: T): string;
begin
  Result := ObjectToJson(TType.GetType<T>, Instance);
end;

class function TJsonReadWriter.StrToDate(Value: string): TDate;
begin
  case Value.Length of
    8: Result := EncodeDate(
      Value.Substring(0, 4).ToInteger,
      Value.Substring(4, 2).ToInteger,
      Value.Substring(6, 2).ToInteger);
  end;
end;

class function TJsonReadWriter.StrToDateTime(Value: string): TDateTime;
begin
  case Value.Length of
    14: Result := StrToDate(Value.Substring(0, 8)) + StrToTime(Value.Substring(8, 6));
  end;
end;

class function TJsonReadWriter.StrToTime(Value: string): TTime;
begin
  case Value.Length of
    6: Result := EncodeTime(
      Value.Substring(0, 2).ToInteger,
      Value.Substring(2, 2).ToInteger,
      Value.Substring(4, 2).ToInteger, 0);
  end;
end;

{ TJson }

procedure TJson.Clear<T>(var Items: TArray<T>);
var
  Item: T;
begin
  for Item in Items do
    Item.Free;

  Items := [];
end;

constructor TJson.Create;
begin
end;

function TJson.ToJson: string;
begin
  Result := TJsonReadWriter.ObjectToJson(Self);
end;

end.

