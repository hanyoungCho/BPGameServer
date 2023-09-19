// UTF-8 library 1.1
// Copyright (c) 2013-2016 WINSOFT
// https://www.winsoft.sk/utf8.htm

unit Utf8;

{$ifdef VER120} // Delphi 4
  {$define D4}
{$endif VER120}

{$ifdef VER125} // C++ Builder 4
  {$define D4}
{$endif VER125}

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 14}
    {$define D6PLUS} // Delphi 6 or higher
  {$ifend}
{$endif}

interface

{$ifndef D6PLUS}

type
  UTF8String = type string;

{$endif D6PLUS}

// encode strings to UTF-8

{$ifdef D6PLUS}
function ToUtf8(const Data: AnsiString): Utf8String; overload;
function ToUtf8(const Data: WideString): Utf8String; overload;
{$else}
function ToUtf8Ansi(const Data: AnsiString): Utf8String;
function ToUtf8Wide(const Data: WideString): Utf8String;
{$endif D6PLUS}

// decode UTF-8 strings
function ToAnsiString(const Utf8: Utf8String): AnsiString;
function ToWideString(const Utf8: Utf8String): WideString;

implementation

uses Windows, SysUtils;

{$ifndef D6PLUS}

const
  sLineBreak = #13#10;

resourcestring
  SOSError = 'System Error.  Code: %d.' + sLineBreak + '%s';
  SUnkOSError = 'A call to an OS function failed';

type
  EOSError = class(Exception)
  public
    ErrorCode: DWORD;
  end;

procedure RaiseLastOSError;
var
  LastError: Integer;
  Error: EOSError;
begin
  LastError := GetLastError;
  if LastError <> 0 then
{$ifdef D4}
    Error := EOSError.CreateFmt(LoadResString(@SOSError), [LastError, SysErrorMessage(LastError)])
{$else}
    Error := EOSError.CreateResFmt(@SOSError, [LastError, SysErrorMessage(LastError)])
{$endif D4}
  else
{$ifdef D4}
    Error := EOSError.Create(LoadResString(@SUnkOSError));
{$else}
    Error := EOSError.CreateRes(@SUnkOSError);
{$endif D4}
  Error.ErrorCode := LastError;
  raise Error;
end;

{$endif D6PLUS}

const
  WC_ERR_INVALID_CHARS = $80;
  MB_ERR_INVALID_CHARS = 8;

{$ifdef D6PLUS}
function ToUtf8(const Data: AnsiString): Utf8String;
begin
  Result := ToUtf8(WideString(Data));
end;
{$else}
function ToUtf8Ansi(const Data: AnsiString): Utf8String;
begin
  Result := ToUtf8Wide(WideString(Data));
end;
{$endif D6PLUS}

{$ifdef D6PLUS}
function ToUtf8(const Data: WideString): Utf8String;
{$else}
function ToUtf8Wide(const Data: WideString): Utf8String;
{$endif D6PLUS}
var Count: Integer;
begin
  if Data = '' then
    Result := ''
  else
  begin
    SetLength(Result, 3 * Length(Data));
    Count := WideCharToMultiByte(CP_UTF8, 0 {WC_ERR_INVALID_CHARS}, @Data[1], Length(Data), @Result[1], Length(Result), nil, nil);
    if Count <> 0 then
      SetLength(Result, Count)
    else
      RaiseLastOSError;
  end;
end;

function ToAnsiString(const Utf8: Utf8String): AnsiString;
begin
  Result := AnsiString(ToWideString(Utf8));
end;

function ToWideString(const Utf8: Utf8String): WideString;
var Count: Integer;
begin
  if Utf8 = '' then
    Result := ''
  else
  begin
    SetLength(Result, Length(Utf8));
    Count := MultiByteToWideChar(CP_UTF8, 0 {MB_ERR_INVALID_CHARS}, @Utf8[1], Length(Utf8), @Result[1], Length(Result));
    if Count <> 0 then
      SetLength(Result, Count)
    else
      RaiseLastOSError;
  end;
end;

end.