//---------------------------------------------------------------------
//
// ComPort serial communication component
//
// Copyright (c) 1998-2022 WINSOFT
//
//---------------------------------------------------------------------

unit ComPortE;

{$RANGECHECKS OFF}

{$ifdef VER110} // C++ Builder 3
  {$ObjExportAll On}
{$endif VER110}

{$ifdef VER140} // Delphi 6
  {$define D6}
{$endif VER140}

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 15}
    {$define D7PLUS} // Delphi 7 or higher
  {$ifend}
{$endif}

interface

procedure Register;

implementation

{$ifdef FPC}
uses Classes, PropEdits, ComponentEditors, lresources, Dialogs, ComPort;
{$else}
  {$ifdef D6}
  uses Windows, Forms, Classes, DesignIntf, DesignEditors, Dialogs, ComPort;
  {$else}
    {$ifdef D7PLUS}
      uses Windows, Vcl.Forms, Classes, DesignIntf, DesignEditors, Vcl.Dialogs, ComPort;
    {$else}
      uses Windows, Forms, Classes, DsgnIntf, Dialogs, ComPort;
    {$endif D7PLUS}
  {$endif D6}
{$endif FPC}

//---------------------------------------------------------------------
//
// TBaudRateProperty
//

type
  TBaudRateProperty = class(TEnumProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

function TBaudRateProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes - [paSortList];
end;

//---------------------------------------------------------------------
//
// TDeviceNameProperty
//

type
  TDeviceNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

function TDeviceNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TDeviceNameProperty.GetValues(Proc: TGetStrProc);
begin
  Proc('COM1');
  Proc('COM2');
  Proc('COM3');
  Proc('COM4');
  Proc('COM5');
  Proc('COM6');
  Proc('COM7');
  Proc('COM8');
  Proc('COM9');
  Proc('\\.\COM10');
  Proc('\\.\COM11');
  Proc('\\.\COM12');
  Proc('\\.\COM13');
  Proc('\\.\COM14');
  Proc('\\.\COM15');
  Proc('\\.\COM16');
  Proc('\\.\COM17');
  Proc('\\.\COM18');
  Proc('\\.\COM19');
  Proc('\\.\COM20');
end;

//---------------------------------------------------------------------
//
// TLogFile property
//

type
  TLogFileProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

procedure TLogFileProperty.Edit;
var ComPort: TComPort;
begin
  ComPort := GetComponent(0) as TComPort;
  with TOpenDialog.Create(nil) do
  try
    FileName := ComPort.LogFile;
    Filter := 'Log files (*.log)|*.log|All files (*.*)|*.*';
    if Execute then
    begin
      ComPort.LogFile := FileName;
      Modified;
    end
  finally
    Free;
  end
end;

function TLogFileProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

//---------------------------------------------------------------------
//
// TComPortEditor
//

type
  TComPortEditor = class(TComponentEditor)
  private
    procedure Config;
    procedure DefaultConfig;
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TComPortEditor.Config;
begin
  try
    if (Component as TComPort).ConfigDialog then
      Designer.Modified;
  except
    // ignore exceptions
  end;
end;

procedure TComPortEditor.DefaultConfig;
begin
  try
    if (Component as TComPort).DefaultConfigDialog then
      Designer.Modified;
  except
    // ignore exceptions
  end;
end;

procedure TComPortEditor.Edit;
begin
  Config;
end;

function TComPortEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

function TComPortEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Properties...';
    1: Result := '&Default Properties...';
    else Result := '';
  end;
end;

procedure TComPortEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Config;
    1: DefaultConfig;
  end;
end;

procedure Register;
begin
  RegisterComponents('System', [TComPort]);
  RegisterPropertyEditor(TypeInfo(TBaudRate), TComPort, 'BaudRate', TBaudRateProperty);
  RegisterPropertyEditor(TypeInfo(string), TComPort, 'DeviceName', TDeviceNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TComPort, 'LogFile', TLogFileProperty);
  RegisterComponentEditor(TComPort, TComPortEditor);
end;

{$ifdef FPC}
initialization
  {$i comportp.lrs}
{$endif FPC}
end.