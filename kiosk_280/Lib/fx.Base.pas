unit fx.Base;

interface

uses
  System.Rtti,
  System.TypInfo;

type
  TType = class
  private
    class var FContext: TRttiContext;
  public
    class constructor Create;
    class destructor Destroy;
    class function Kind<T>: TTypeKind; static; inline;
    class function GetType<T>: TRttiType; overload;
    class function GetType(TypeInfo: PTypeInfo): TRttiType; overload;
    class function GetType(AClass: TClass): TRttiType; overload;
    class function GetGUID<T>: TGUID;
    class function GetArrayElementType(ATypeInfo: PTypeInfo): TRttiType;
    class function GetEnumName<T>(Value: T): string;

    class property Context: TRttiContext read FContext;
  end;

implementation


{ TType }

class constructor TType.Create;
begin
  FContext := TRttiContext.Create;
end;

class destructor TType.Destroy;
begin
  FContext.Free;
end;

class function TType.GetGUID<T>: TGUID;
var
  RttiType: TRttiType;
begin
  RttiType := GetType<T>;

  if RttiType.TypeKind = tkInterface then
    Result := TRttiInterfaceType(RttiType).GUID
  else
    Result := TGUID.Empty;
end;

class function TType.GetType(TypeInfo: PTypeInfo): TRttiType;
begin
  Result := FContext.GetType(TypeInfo);
end;

class function TType.GetType(AClass: TClass): TRttiType;
begin
  Result := FContext.GetType(AClass);
end;

class function TType.GetType<T>: TRttiType;
begin
  Result := FContext.GetType(TypeInfo(T));
end;

class function TType.Kind<T>: TTypeKind;
begin
  Result := GetTypeKind(T);
end;

function GetDynArrayElType(ATypeInfo: PTypeInfo): PTypeInfo;
var
  ref: PPTypeInfo;
begin
  // Get real element type of dynamic array, even if it's array of array of etc.
  ref := GetTypeData(ATypeInfo).DynArrElType;
  if ref = nil then
    Exit(nil);
  Result := ref^;
end;

function GetArrayElType(ATypeInfo: PTypeInfo): PTypeInfo;
var
  ref: PPTypeInfo;
begin
  if ATypeInfo^.Kind = tkArray then
  begin
    ref := GetTypeData(ATypeInfo)^.ArrayData.ElType;
    if ref = nil then
      Result := nil
    else
      Result := ref^;
  end
  else if ATypeInfo^.Kind = tkDynArray then
    Exit(GetDynArrayElType(ATypeInfo))
  else
    Exit(nil);
end;

class function TType.GetArrayElementType(ATypeInfo: PTypeInfo): TRttiType;
begin
  Result := TType.GetType(GetArrayElType(ATypeInfo));
end;


class function TType.GetEnumName<T>(Value: T): string;
begin
  Result := TRttiEnumerationType.GetName<T>(Value)
end;

end.
