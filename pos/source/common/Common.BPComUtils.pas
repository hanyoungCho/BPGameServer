unit Common.BPComUtils;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils,
  { WinSoft }
  ComPort;

function GetBaudrate(const ABaudrate: Integer): TBaudRate;
function CheckEnumComPorts(const AComNumber: Integer; var AErrMsg: string): Boolean;
procedure OpenCashDrawer;

implementation

uses
  Common.BPGlobal;

function GetBaudrate(const ABaudrate: Integer): TBaudRate;
begin
  case ABaudrate of
    9600:   Result := br9600;
    14400:  Result := br14400;
    19200:  Result := br19200;
    38400:  Result := br38400;
    57600:  Result := br57600;
    115200: Result := br115200;
    128000: Result := br128000;
    256000: Result := br256000;
  else
    Result := br9600;
  end;
end;

function CheckEnumComPorts(const AComNumber: Integer; var AErrMsg: string): Boolean;
var
  hKeyHandle: HKEY;
  nErrCode, nIndex: Integer;
  sValueName, sData: string;
  wValueLen, wDataLen, wValueType: DWORD;
  SL: TStringList;
begin
  Result := False;
  AErrMsg := '';
  nErrCode := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'HARDWARE\DEVICEMAP\SERIALCOMM', 0, KEY_READ, hKeyHandle);

  try
    if (nErrCode <> ERROR_SUCCESS) then
      raise Exception.Create(Format('COM%d은 등록되지 않은 통신포트입니다.', [AComNumber]));

    SL := TStringList.Create;
    try
      nIndex := 0;
      repeat
        wValueLen := 256;
        wDataLen := 256;
        SetLength(sValueName, wValueLen);
        SetLength(sData, wDataLen);
        nErrCode := RegEnumValue(
          hKeyHandle,
          nIndex,
          PChar(sValueName),
          Cardinal(wValueLen),
          nil,
          @wValueType,
          PByte(PChar(sData)),
          @wDataLen);

        if (nErrCode = ERROR_SUCCESS) then
        begin
          SetLength(sData, wDataLen - 1);
          SL.Add(sData);
          Inc(nIndex);
        end
        else if (nErrCode <> ERROR_NO_MORE_ITEMS) then
          Break;
      until (nErrCode <> ERROR_SUCCESS);

      SL.Sort;
      for nIndex := 0 to Pred(SL.Count) do
      begin
        Result := (StrToInt(StringReplace(UpperCase(SL[nIndex]), 'COM', '', [rfReplaceAll])) = AComNumber);
        if Result then
          Break;
      end;
    finally
      RegCloseKey(hKeyHandle);
      FreeAndNil(SL);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Format('CheckEnumComPorts.Exception = %s', [E.Message]));
    end;
  end;
end;

procedure OpenCashDrawer;
var
  sBuffer: string;
begin
  with Global.ReceiptPrinter do
    if Enabled and
       Assigned(ComDevice) then
    try
      if not ComDevice.Active then
      begin
        if (Port >= 10) then
          ComDevice.DeviceName := '\\.\COM' + IntToStr(Port)
        else
          ComDevice.DeviceName := 'COM' + IntToStr(Port);
        ComDevice.BaudRate := GetBaudrate(Baudrate);
        ComDevice.Parity := TParity.paNone;
        ComDevice.DataBits := TDataBits.db8;
        ComDevice.StopBits := TStopBits.sb1;
        ComDevice.Open;
      end;

      sBuffer := #27#112#0#25#250;
      ComDevice.Write(PAnsiChar(sBuffer), Length(sBuffer), False);
    except
      on E: Exception do
        UpdateLog(Format('OpenCashDrawer.Exception = %s', [E.Message]));
    end;
end;

end.
