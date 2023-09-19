//---------------------------------------------------------------------
//
// ComPort serial communication component
//
// Copyright (c) 1998-2022 WINSOFT
//
//---------------------------------------------------------------------

//{$define TRIAL} // trial version, comment this line for registered version

unit ComPort;

{$RANGECHECKS OFF}

{$ifdef VER100} // Delphi 3
  {$define D3}
{$endif VER100}

{$ifdef VER110} // C++ Builder 3
  {$define D3}
  {$ObjExportAll On}
{$endif VER110}

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

  {$if CompilerVersion >= 15}
    {$define D7PLUS} // Delphi 7 or higher
  {$ifend}

  {$if CompilerVersion >= 20}
    {$define D2009PLUS} // Delphi 2009 or higher
    {$WARN SYMBOL_PLATFORM OFF}
  {$ifend}

  {$if CompilerVersion >= 23}
    {$define DXE2PLUS} // Delphi XE2 or higher
  {$ifend}
{$endif}

{$ifdef FPC}
  {$MODE Delphi}
  {$define D6PLUS} // Delphi 6 or higher
{$endif}
  
{$ifdef WIN64}
{$HPPEMIT '#pragma link "ComPortP.a"'}
{$else}
{$HPPEMIT '#pragma link "ComPortP.lib"'}
{$endif WIN64}

interface

uses
  Windows, SysUtils, Classes, Messages;

type
{$ifndef D2009PLUS}
  TBytes = array of Byte;
{$endif D2009PLUS}

  WString = {$ifdef D2009PLUS} string {$else} WideString {$endif D2009PLUS};

  EComError = class(Exception)
  public
    ErrorCode: Integer;
    constructor Create(ErrorCode: Integer; const Msg: string);
  end;

  TCustomComPort = class;

  TComThread = class(TThread)
  private
    FComPort: TCustomComPort;
  public
    constructor Create(ComPort: TCustomComPort);
    procedure Execute; override;
  end;

  TBaudRate = (brDefault, br50, br75, br110, br134_5, br150, br300, br600,
               br1200, br1800, br2000, br2400, br3600, br4800, br7200, br9600,
               br10400, br14400, br15625, br19200, br28800, br38400, br56000,
               br57600, br115200, br128000, br256000, brCustom);
  TBaudRates = set of TBaudRate;               

  TParity = (paDefault, paNone, paOdd, paEven, paMark, paSpace);
  TSettableParity = set of TParity;

  TStopBits = (sbDefault, sb1, sb1_5, sb2);
  TSettableStopBits = set of TStopBits;

  TDataBits = (dbDefault, db4, db5, db6, db7, db8, db9, db16, db16x);
  TSettableDataBits = set of TDataBits;

  TOption = (opCheckParity, opOutputCTSFlow, opOutputDSRFlow,
             opDSRSensitivity, opTXContinueOnXOff,
             opUseErrorChar, opDiscardNullBytes, opAbortOnError);
  TOptions = set of TOption;

  TModemStatusValue = (msCTS, msDSR, msRing, msRLSD);
  TModemStatus = set of TModemStatusValue;

  TLineError = (leBreak, leDeviceNotSelected, leFrame, leIO, leMode, leOutOfPaper,
                leOverrun, leDeviceTimeOut, leRxOverflow, leParity, leTxFull);
  TLineErrors = set of TLineError;

  TDTRControl = (dcDefault, dcDisable, dcEnable, dcHandshake);

  TRTSControl = (rcDefault, rcDisable, rcEnable, rcHandshake, rcToggle);

  TXOnXOffControl = (xcDefault, xcDisable, xcInput, xcOutput, xcInputOutput);

  TPriorityClass = (pcDefault, pcIdle, pcNormal, pcHigh, pcRealTime);

  TSettableParameter = (spParity, spParityCheck, spBaudRate, spDataBits, spStopBits, spHandShaking, spRLSD);
  TSettableParameters = set of TSettableParameter;

  TCapability = (caDtrDsr, caRtsCts, caRLSD, caParityCheck, caXOnXOff, caSettableXChar,
                 caTotalTimeouts, caIntervalTimeouts, caSpecialChars, ca16BitMode);
  TCapabilities = set of TCapability;

  TOpenCloseEvent = procedure (ComPort: TCustomComPort) of object;
  TReadWriteEvent = procedure (Sender: TObject; Buffer: Pointer; Length: Integer; WaitOnCompletion: Boolean) of object;

  TComAction = (caFail, caAbort);
  TComErrorEvent = procedure (ComPort: TCustomComPort; E: EComError; var Action: TComAction) of object;

  TLineErrorEvent = procedure (Sender: TObject; LineErrors: TLineErrors) of object;
  TDeviceArrivalEvent = procedure (Sender: TObject; const DeviceName: string) of object;
  TDeviceRemovedEvent = procedure (Sender: TObject; const DeviceName: string) of object;

  TDeviceInfo = record
    Description: WString;
    Device: WString;
    DeviceName: WString;
    Driver: WString;
    DriverProvider: WString;
    DriverVersion: WString;
    EnumeratorName: WString;
    FriendlyName: WString;
    Instance: WString;
    Location: WString;
    Manufacturer: WString;
    PhysicalName: WString;
    ReportedDescription: WString;
    Service: WString;
  end;

  TDeviceInfos = array of TDeviceInfo;

  TFlowControl = class(TPersistent)
  private
    FComPort: TCustomComPort;
    FDTRControl: TDTRControl;
    FRTSControl: TRTSControl;
    FXOnXOffControl: TXOnXOffControl;
    FXOnLimit: WORD;
    FXOffLimit: WORD;
    procedure SetDTRControl(Value: TDTRControl);
    procedure SetRTSControl(Value: TRTSControl);
    procedure SetXOnXOffControl(Value: TXOnXOffControl);
    procedure SetXOnLimit(Value: WORD);
    procedure SetXOffLimit(Value: WORD);
  public
    constructor Create(ComPort: TCustomComPort);
  published
    property DTR: TDTRControl read FDTRControl write SetDTRControl default dcDefault;
    property RTS: TRTSControl read FRTSControl write SetRTSControl default rcDefault;
    property XOnXOff: TXOnXOffControl read FXOnXOffControl write SetXOnXOffControl default xcDefault;
    property XOnLimit: WORD read FXOnLimit write SetXOnLimit default 0;
    property XOffLimit: WORD read FXOffLimit write SetXOffLimit default 0;
  end;

  TCharacters = class(TPersistent)
  private
    FComPort: TCustomComPort;
    FXOn: Char;
    FXOff: Char;
    FError: Char;
    FEof: Char;
    FEvent: Char;
    procedure SetXOn(Value: Char);
    procedure SetXOff(Value: Char);
    procedure SetError(Value: Char);
    procedure SetEof(Value: Char);
    procedure SetEvent(Value: Char);
  public
    constructor Create(ComPort: TCustomComPort);
  published
    property XOn: Char read FXOn write SetXOn default #17;
    property XOff: Char read FXOff write SetXOff default #19;
    property Error: Char read FError write SetError default #0;
    property Eof: Char read FEof write SetEof default #0;
    property Event: Char read FEvent write SetEvent default #0;
  end;

  TBufferSizes = class(TPersistent)
  private
    FComPort: TCustomComPort;
    FInput: Integer;
    FOutput: Integer;
    procedure SetInput(Value: Integer);
    procedure SetOutput(Value: Integer);
    function GetMaxInput: Integer;
    function GetMaxOutput: Integer;
    function GetCurrentInput: Integer;
    function GetCurrentOutput: Integer;
  public
    constructor Create(ComPort: TCustomComPort);
    property CurrentInput: Integer read GetCurrentInput;
    property CurrentOutput: Integer read GetCurrentOutput;
    property MaxInput: Integer read GetMaxInput;
    property MaxOutput: Integer read GetMaxOutput;
  published
    property Input: Integer read FInput write SetInput default 4096;
    property Output: Integer read FOutput write SetOutput default 2048;
  end;

  TTimeouts = class(TPersistent)
  private
    FComPort: TCustomComPort;
    FReadInterval: Integer;
    FReadMultiplier: Integer;
    FReadConstant: Integer;
    FWriteMultiplier: Integer;
    FWriteConstant: Integer;
    procedure SetReadInterval(Value: Integer);
    procedure SetReadMultiplier(Value: Integer);
    procedure SetReadConstant(Value: Integer);
    procedure SetWriteMultiplier(Value: Integer);
    procedure SetWriteConstant(Value: Integer);
  public
    constructor Create(ComPort: TCustomComPort);
  published
    property ReadInterval: Integer read FReadInterval write SetReadInterval default 0;
    property ReadMultiplier: Integer read FReadMultiplier write SetReadMultiplier default 0;
    property ReadConstant: Integer read FReadConstant write SetReadConstant default 0;
    property WriteMultiplier: Integer read FWriteMultiplier write SetWriteMultiplier default 0;
    property WriteConstant: Integer read FWriteConstant write SetWriteConstant default 0;
  end;

  TCustomComPort = class(TComponent)
  private
    FActive: Boolean;
    FHandle: THandle;
    FReadEventHandle: THandle;
    FWriteEventHandle: THandle;
    FEventOverlapped: TOverlapped;
    FReadOverlapped: TOverlapped;
    FWriteOverlapped: TOverlapped;
    FComThread: TComThread;
    FEventMask: DWord;
    FRequestedReadCount: DWord;
    FRequestedWriteCount: DWord;
    FRequestedReadBuffer: Pointer;
    FRequestedWriteBuffer: Pointer;
    FOriginalPriorityClass: DWord;
    FThreadError: DWord;
    FThreadPriority: TThreadPriority;

    FCustomBaudRate: Integer;
    FBaudRate: TBaudRate;
    FBuffer: array of Byte;
    FBufferSizes: TBufferSizes;
    FCharacters: TCharacters;
    FDataBits: TDataBits;
    FDeviceName: string;
    FFlowControl: TFlowControl;
    FLogFile: string;
{$ifndef FPC}
    FNotificationHandle: HDEVNOTIFY;
{$endif FPC}
    FOptions: TOptions;
    FParity: TParity;
    FPriorityClass: TPriorityClass;
    FStopBits: TStopBits;
    FSynchronizeEvents: Boolean;
    FTimeouts: TTimeouts;

    FAfterClose: TOpenCloseEvent;
    FAfterOpen: TOpenCloseEvent;
    FAfterRead: TReadWriteEvent;
    FAfterWrite: TReadWriteEvent;
    FBeforeClose: TOpenCloseEvent;
    FBeforeOpen: TOpenCloseEvent;
    FBeforeRead: TReadWriteEvent;
    FBeforeWrite: TReadWriteEvent;
    FOnBreak: TNotifyEvent;
    FOnCTSChange: TNotifyEvent;
    FOnDSRChange: TNotifyEvent;
    FOnError: TComErrorEvent;
    FOnEvent1: TNotifyEvent;
    FOnEvent2: TNotifyEvent;
    FOnLineError: TLineErrorEvent;
    FOnPrinterError: TNotifyEvent;
    FOnRing: TNotifyEvent;
    FOnRLSDChange: TNotifyEvent;
    FOnRx80PercFull: TNotifyEvent;
    FOnRxChar: TNotifyEvent;
    FOnRxFlag: TNotifyEvent;
    FOnTxEmpty: TNotifyEvent;
    FOnDeviceArrival: TDeviceArrivalEvent;
    FOnDeviceRemoved: TDeviceRemovedEvent;

    function GetAbout: string;
    function GetActive: Boolean;
    function GetCapabilities: TCapabilities;
    function GetCommProp: TCommProp;
    function GetCustomBaudRate: Integer;
    function GetLineErrors(Errors: DWord): TLineErrors;
    function GetMaxBaudRate: TBaudRate;
    function GetModemStatus: TModemStatus;
    function GetSettableBaudRates: TBaudRates;
    function GetSettableDataBits: TSettableDataBits;
    function GetSettableParameters: TSettableParameters;
    function GetSettableParity: TSettableParity;
    function GetSettableStopBits: TSettableStopBits;
    procedure SetAbout(const Value: string);
    procedure SetActive(const Value: Boolean);
    procedure SetBaudRate(Value: TBaudRate);
    procedure SetBufferSizes(Value: TBufferSizes);
    procedure SetCharacters(Value: TCharacters);
    procedure SetCustomBaudRate(Value: Integer);
    procedure SetDataBits(Value: TDataBits);
    procedure SetDeviceName(const Value: string);
    procedure SetFlowControl(Value: TFlowControl);
    procedure SetOptions(Value: TOptions);
    procedure SetParity(Value: TParity);
    procedure SetPriorityClass(Value: TPriorityClass);
    procedure SetStopBits(Value: TStopBits);
    procedure SetSynchronizeEvents(Value: Boolean);
    procedure SetThreadPriority(Value: TThreadPriority);
    procedure SetTimeouts(Value: TTimeouts);

    procedure SetOnBreak(Value: TNotifyEvent);
    procedure SetOnCTSChange(Value: TNotifyEvent);
    procedure SetOnDSRChange(Value: TNotifyEvent);
    procedure SetOnEvent1(Value: TNotifyEvent);
    procedure SetOnEvent2(Value: TNotifyEvent);
    procedure SetOnLineError(Value: TLineErrorEvent);
    procedure SetOnPrinterError(Value: TNotifyEvent);
    procedure SetOnRing(Value: TNotifyEvent);
    procedure SetOnRLSDChange(Value: TNotifyEvent);
    procedure SetOnRx80PercFull(Value: TNotifyEvent);
    procedure SetOnRxChar(Value: TNotifyEvent);
    procedure SetOnRxFlag(Value: TNotifyEvent);
    procedure SetOnTxEmpty(Value: TNotifyEvent);
{$ifndef FPC}
    procedure SetOnDeviceArrival(Value: TDeviceArrivalEvent);
    procedure SetOnDeviceRemoved(Value: TDeviceRemovedEvent);
{$endif FPC}

    procedure CheckActive;
    procedure CheckInactive;
    procedure CopyDCB(var DCB: TDCB; ToDCB: Boolean);
    procedure SetComDCB;
    procedure SetComEventMask;
    procedure SetComBufferSizes;
    procedure SetComTimeouts;

    function StoreCustomBaudRate: Boolean;
    function ShortDeviceName: string;

{$ifndef FPC}
    function StartNotification: Boolean;
    function StopNotification: Boolean;
  {$ifndef CONSOLE}
    function WindowHook(var Message: TMessage): Boolean;
  {$endif CONSOLE}
{$endif FPC}
  protected
    procedure CreateHandle; virtual;
    procedure FreeHandle;
    procedure Loaded; override;
    procedure Check(Value: Boolean);
    procedure RaiseError(ErrorCode: Integer; const ErrorMsg: string);
    procedure RaiseThreadError;
    procedure ThreadDoEvent;
    procedure ThreadProc(Thread: TComThread);
    procedure CreateThread;
    procedure DestroyThread;
    function Log: Boolean;
    procedure WriteLog(const Message: string; Buf: Pointer = nil; Count: Integer = 0);

    property About: string read GetAbout write SetAbout stored False;
    property Active: Boolean read GetActive write SetActive;
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate default brDefault;
    property BufferSizes: TBufferSizes read FBufferSizes write SetBufferSizes;
    property Characters: TCharacters read FCharacters write SetCharacters;
    property CustomBaudRate: Integer read GetCustomBaudRate write SetCustomBaudRate stored StoreCustomBaudRate;
    property DataBits: TDataBits read FDataBits write SetDataBits default dbDefault;
    property DeviceName: string read FDeviceName write SetDeviceName;
    property FlowControl: TFlowControl read FFlowControl write SetFlowControl;
    property LogFile: string read FLogFile write FLogFile;
    property ModemStatus: TModemStatus read GetModemStatus stored False;
    property Options: TOptions read FOptions write SetOptions;
    property Parity: TParity read FParity write SetParity default paDefault;
    property PriorityClass: TPriorityClass read FPriorityClass write SetPriorityClass default pcDefault;
    property StopBits: TStopBits read FStopBits write SetStopBits default sbDefault;
    property SynchronizeEvents: Boolean read FSynchronizeEvents write SetSynchronizeEvents default True;
    property ThreadPriority: TThreadPriority read FThreadPriority write SetThreadPriority default tpTimeCritical;
    property Timeouts: TTimeouts read FTimeouts write SetTimeouts;

    property AfterClose: TOpenCloseEvent read FAfterClose write FAfterClose;
    property AfterOpen: TOpenCloseEvent read FAfterOpen write FAfterOpen;
    property AfterRead: TReadWriteEvent read FAfterRead write FAfterRead;
    property AfterWrite: TReadWriteEvent read FAfterWrite write FAfterWrite;
    property BeforeClose: TOpenCloseEvent read FBeforeClose write FBeforeClose;
    property BeforeOpen: TOpenCloseEvent read FBeforeOpen write FBeforeOpen;
    property BeforeRead: TReadWriteEvent read FBeforeRead write FBeforeRead;
    property BeforeWrite: TReadWriteEvent read FBeforeWrite write FBeforeWrite;
    property OnBreak: TNotifyEvent read FOnBreak write SetOnBreak;
    property OnCTSChange: TNotifyEvent read FOnCTSChange write SetOnCTSChange;
    property OnDSRChange: TNotifyEvent read FOnDSRChange write SetOnDSRChange;
    property OnError: TComErrorEvent read FOnError write FOnError;
    property OnEvent1: TNotifyEvent read FOnEvent1 write SetOnEvent1;
    property OnEvent2: TNotifyEvent read FOnEvent2 write SetOnEvent2;
    property OnLineError: TLineErrorEvent read FOnLineError write SetOnLineError;
    property OnPrinterError: TNotifyEvent read FOnPrinterError write SetOnPrinterError;
    property OnRing: TNotifyEvent read FOnRing write SetOnRing;
    property OnRLSDChange: TNotifyEvent read FOnRLSDChange write SetOnRLSDChange;
    property OnRx80PercFull: TNotifyEvent read FOnRx80PercFull write SetOnRx80PercFull;
    property OnRxChar: TNotifyEvent read FOnRxChar write SetOnRxChar;
    property OnRxFlag: TNotifyEvent read FOnRxFlag write SetOnRxFlag;
    property OnTxEmpty: TNotifyEvent read FOnTxEmpty write SetOnTxEmpty;
{$ifndef FPC}
    property OnDeviceArrival: TDeviceArrivalEvent read FOnDeviceArrival write SetOnDeviceArrival;
    property OnDeviceRemoved: TDeviceRemovedEvent read FOnDeviceRemoved write SetOnDeviceRemoved;
{$endif FPC}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    procedure Read(Buf: Pointer; Count: Integer; WaitForCompletion: Boolean = False); overload;
    procedure Write(Buf: Pointer; Count: Integer; WaitForCompletion: Boolean = False); overload;

{$ifdef D2009PLUS}
    function Read(Encoding: TEncoding): string; overload;
    function ReadUtf8: string;
{$else}
    function ReadUtf8: WideString;
{$endif D2009PLUS}
    function ReadBytes: TBytes; overload;
    procedure ReadBytes(Value: TBytes; From, Count: Integer); overload;
{$ifdef D2009PLUS}
    procedure Write(const Value: string; Encoding: TEncoding); overload;
    procedure WriteUtf8(const Value: string);
{$else}
    procedure WriteUtf8(const Value: WideString);
{$endif D2009PLUS}
    procedure WriteBytes(const Value: TBytes); overload;
    procedure WriteBytes(const Value: TBytes; From, Count: Integer); overload;
{$ifdef D2009PLUS}
    function ReadLine(Encoding: TEncoding): string; overload;
    function ReadLineUtf8: string;
{$else}
    function ReadLineUtf8: WideString;
{$endif D2009PLUS}
    function ReadLineBytes: TBytes;

{$ifdef D2009PLUS}
    procedure WriteLine(const Value: string; Encoding: TEncoding); overload;
    procedure WriteLineUtf8(const Value: string);
{$else}
    procedure WriteLineUtf8(const Value: WideString);
{$endif D2009PLUS}
    procedure WriteLineBytes(const Value: TBytes);

{$ifdef D2009PLUS}
    function ReadUntil(Terminator: Byte; Encoding: TEncoding): string; overload;
    function ReadUntilUtf8(Terminator: Byte): string;
{$else}
    function ReadUntilUtf8(Terminator: Byte): WideString;
{$endif D2009PLUS}
    function ReadUntilBytes(Terminator: Byte): TBytes; overload;
    function ReadUntilBytes(const Terminator: TBytes): TBytes; overload;
    function ReadAnsiUntil(Terminator: AnsiChar): AnsiString; overload;
    function ReadAnsiUntil(const Terminator: AnsiString): AnsiString; overload;
    function ReadAnsiLine: AnsiString;
    procedure WriteAnsiLine(const Value: AnsiString);
    function ReadAnsiString: AnsiString;
    procedure WriteAnsiString(const Value: AnsiString);
    function ReadAnsiChar: AnsiChar;
    procedure WriteAnsiChar(Value: AnsiChar);
    function ReadUntil(Terminator: Char): string; overload;
    function ReadUntil(const Terminator: string): string; overload;
    function ReadLine: string; overload;
    procedure WriteLine(const Value: string); overload;
    function ReadString: string;
    procedure WriteString(const Value: string);
    function ReadChar: Char;
    procedure WriteChar(Value: Char);
    function ReadByte: Byte;
    procedure WriteByte(Value: Byte);
    function ReadWord: Word;
    procedure WriteWord(Value: Word);
    function ReadDWord: DWord;
    procedure WriteDWord(Value: DWord);
    function InputCount: DWord;
    function OutputCount: DWord;
    function ReadPending: Boolean;
    function WritePending: Boolean;
    procedure WaitForReadCompletion; overload;
    procedure WaitForReadCompletion(var ReadCount: Integer); overload;
    procedure WaitForWriteCompletion; overload;
    procedure WaitForWriteCompletion(var WriteCount: Integer); overload;
    procedure PurgeInput;
    procedure PurgeOutput;
    procedure ClearInput;
    procedure ClearOutput;
    procedure AbortInput;
    procedure AbortOutput;
    procedure Flush;

    procedure ClearLineErrors;
    procedure CheckLineErrors;

    function ConfigDialog: Boolean;
    function DefaultConfigDialog: Boolean;

    procedure EnumDevices(List: TStrings);
    procedure EnumComDevices(List: TStrings);
    procedure EnumComDevicesFromRegistry(List: TStrings);
    procedure EnumComFriendlyNames(List: TStrings);
    function DeviceInfos: TDeviceInfos;
    function DeviceInfo(const DeviceName: string; out DeviceInfo: TDeviceInfo): Boolean;

    procedure ClearBreak;
    procedure ClearDTR;
    procedure ClearRTS;
    procedure ResetDevice;
    procedure SetBreak;
    procedure SetDTR;
    procedure SetRTS;
    procedure SetXOn;
    procedure SetXOff;
    procedure TransmitChar(Value: {$ifdef D2009PLUS} AnsiChar {$else} Char {$endif D2009PLUS});

    property Capabilities: TCapabilities read GetCapabilities;
    property Handle: THandle read FHandle;
    property MaxBaudRate: TBaudRate read GetMaxBaudRate;
    property SettableBaudRates: TBaudRates read GetSettableBaudRates;
    property SettableDataBits: TSettableDataBits read GetSettableDataBits;
    property SettableParameters: TSettableParameters read GetSettableParameters;
    property SettableParity: TSettableParity read GetSettableParity;
    property SettableStopBits: TSettableStopBits read GetSettableStopBits;
  end;

  {$ifdef DXE2PLUS}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$endif DXE2PLUS}
  TComPort = class(TCustomComPort)
  published
    property About;
    property Active;
    property BaudRate;
    property BufferSizes;
    property Characters;
    property CustomBaudRate;
    property DataBits;
    property DeviceName;
    property FlowControl;
    property LogFile;
    property ModemStatus;
    property Options;
    property Parity;
    property PriorityClass;
    property StopBits;
    property SynchronizeEvents;
    property ThreadPriority;
    property Timeouts;

    property AfterClose;
    property AfterOpen;
    property AfterRead;
    property AfterWrite;
    property BeforeClose;
    property BeforeOpen;
    property BeforeRead;
    property BeforeWrite;
    property OnBreak;
    property OnCTSChange;
    property OnDSRChange;
    property OnError;
    property OnEvent1;
    property OnEvent2;
    property OnLineError;
    property OnPrinterError;
    property OnRing;
    property OnRLSDChange;
    property OnRx80PercFull;
    property OnRxChar;
    property OnRxFlag;
    property OnTxEmpty;
{$ifndef FPC}
    property OnDeviceArrival;
    property OnDeviceRemoved;
{$endif FPC}
  end;

const
  SComOpen = 'Can''t perform this operation on an open port';
  SComClosed = 'Can''t perform this operation on a closed port';
  SComCreateThread = 'Can''t create thread';
  SComTimeout = 'Timeout';
  SComParameter = 'Incorrect parameter';

implementation

uses {$ifndef CONSOLE} Vcl.Forms, {$endif CONSOLE} Registry {$ifndef D6PLUS}, Utf8 {$endif D6PLUS};

const
  CR = #13;

  GUID_DEVINTERFACE_USB_DEVICE: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';
  DBT_DEVTYP_PORT = $00000003;
  DBT_DEVTYP_DEVICEINTERFACE = $00000005;
  DBT_DEVICEARRIVAL = $8000;
  DBT_DEVICEREMOVECOMPLETE = $8004;

type
  TCHAR = Char;

  PDEV_BROADCAST_HDR = ^DEV_BROADCAST_HDR;
  DEV_BROADCAST_HDR = record
    dbcc_size: DWORD;
    dbcc_devicetype: DWORD;
    dbcc_reserved: DWORD;
  end;

  PDEV_BROADCAST_DEVICEINTERFACE = ^DEV_BROADCAST_DEVICEINTERFACE;
  DEV_BROADCAST_DEVICEINTERFACE = record
    dbcc_size: DWORD;
    dbcc_devicetype: DWORD;
    dbcc_reserved: DWORD;
    dbcc_classguid: TGUID;
    dbcc_name: array [0..0] of TCHAR;
  end;

  PDEV_BROADCAST_PORT = ^DEV_BROADCAST_PORT;
  DEV_BROADCAST_PORT = record
    dbcc_size: DWORD;
    dbcc_devicetype: DWORD;
    dbcc_reserved: DWORD;
    dbcc_name: array [0..0] of TCHAR;
  end;

//---------------------------------------------------------------------
//
// EComError
//

constructor EComError.Create(ErrorCode: Integer; const Msg: string);
begin
  inherited Create(Msg);
  Self.ErrorCode := ErrorCode;
end;

//---------------------------------------------------------------------
//
// TComThread
//

constructor TComThread.Create(ComPort: TCustomComPort);
begin
  FComPort := ComPort;
  FComPort.FComThread := Self;

  FreeOnTerminate := True;
  inherited Create(False);
  Priority := FComPort.ThreadPriority;
end;

procedure TComThread.Execute;
begin
  while not Terminated do
    FComPort.ThreadProc(Self);
end;

//---------------------------------------------------------------------
//
// TCustomComPort
//

constructor TCustomComPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := INVALID_HANDLE_VALUE;
  FDeviceName := 'COM1';
  FOriginalPriorityClass := $FFFFFFFF;
  FSynchronizeEvents := True;
  FThreadPriority := tpTimeCritical;
  FFlowControl := TFlowControl.Create(Self);
  FCharacters := TCharacters.Create(Self);
  FBufferSizes := TBufferSizes.Create(Self);
  FTimeouts := TTimeouts.Create(Self);
end;

destructor TCustomComPort.Destroy;
begin
{$ifndef FPC}
  StopNotification;
{$endif FPC}
  Close;
  FTimeouts.Free;
  FBufferSizes.Free;
  FCharacters.Free;
  FFlowControl.Free;
  inherited Destroy;
end;

function TCustomComPort.GetAbout: string;
begin
  Result := 'Version 6.6, Copyright (c) 1998-2022 WINSOFT, https://www.winsoft.sk';
end;

procedure TCustomComPort.SetAbout(const Value: string);
begin
end;

procedure TCustomComPort.RaiseError(ErrorCode: Integer; const ErrorMsg: string);
var Action: TComAction;
begin
  try
    raise EComError.Create(ErrorCode, ErrorMsg);
  except
    on E: EComError do
    begin
      Action := caFail;
      if Assigned(FOnError) then
        FOnError(Self, E, Action);
      if Action = caAbort then
        SysUtils.Abort
      else
        raise;
    end;
  end;
end;

procedure TCustomComPort.Check(Value: Boolean);
var LastError: DWord;
begin
  if not Value then
  begin
    LastError := GetLastError;
    if (LastError <> 0) and (LastError <> ERROR_IO_PENDING) then
    begin
      SetLastError(0);
      RaiseError(LastError, SysErrorMessage(LastError));
    end;
  end;
end;

procedure TCustomComPort.SetBaudRate(Value: TBaudRate);
begin
  if FBaudRate <> Value then
  begin
    FBaudRate := Value;
    SetComDCB;
  end;
end;

procedure TCustomComPort.SetDataBits(Value: TDataBits);
begin
  if FDataBits <> Value then
  begin
    FDataBits := Value;
    SetComDCB;
  end;
end;

procedure TCustomComPort.SetParity(Value: TParity);
begin
  if FParity <> Value then
  begin
    FParity := Value;
    SetComDCB;
  end;
end;

procedure TCustomComPort.SetStopBits(Value: TStopBits);
begin
  if FStopBits <> Value then
  begin
    FStopBits := Value;
    SetComDCB;
  end;
end;

procedure TCustomComPort.SetOptions(Value: TOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    SetComDCB;
  end;
end;

procedure TCustomComPort.CopyDCB(var DCB: TDCB; ToDCB: Boolean);
type
  TFlags = {$ifdef FPC} DWORD {$else} Longint {$endif FPC};
const
  flagBinary           = $00000001;
  flagParity           = $00000002;
  flagOutCTSFlow       = $00000004;
  flagOutDSRFlow       = $00000008;
  flagDTRControl       = $00000030;
  flagDSRSensitivity   = $00000040;
  flagTxContinueOnXoff = $00000080;
  flagOutX             = $00000100;
  flagInX              = $00000200;
  flagErrorChar        = $00000400;
  flagNull             = $00000800;
  flagRTSControl       = $00003000;
  flagAbortOnError     = $00004000;
  // flagDummy         = $FFFF8000;

  ComParity: array [TParity] of Integer =
    (0, NOPARITY, ODDPARITY, EVENPARITY, MARKPARITY, SPACEPARITY);
  ComStopBits: array [TStopBits] of Integer =
    (0, ONESTOPBIT, ONE5STOPBITS, TWOSTOPBITS);
  ComDataBits: array [TDataBits] of Integer =
    (0, 4, 5, 6, 7, 8, 9, 16, 16);
  ComDTRControl: array [TDTRControl] of TFlags =
    (0, DTR_CONTROL_DISABLE shl 4, DTR_CONTROL_ENABLE shl 4, DTR_CONTROL_HANDSHAKE shl 4);
  ComRTSControl: array [TRTSControl] of TFlags =
    (0, RTS_CONTROL_DISABLE shl 12, RTS_CONTROL_ENABLE shl 12,
     RTS_CONTROL_HANDSHAKE shl 12, RTS_CONTROL_TOGGLE shl 12);
  ComXOnXOffControl: array [TXOnXOffControl] of TFlags =
    (0, 0, flagInX, flagOutX, flagInX or flagOutX);
  ComOptions: array [TOption] of TFlags =
    (flagParity, flagOutCTSFlow, flagOutDSRFlow, flagDSRSensitivity,
     flagTxContinueOnXoff, flagErrorChar, flagNull, flagAbortOnError);
var
  Option: TOption;
  ADataBits: TDataBits;
  AParity: TParity;
  AStopBits: TStopBits;
  ADTRControl: TDTRControl;
  ARTSControl: TRTSControl;
  AXOnXOffControl: TXOnXOffControl;
  AnOption: TOption;
begin
  with DCB do
    if ToDCB then
    begin
      if FBaudRate <> brDefault then BaudRate := CustomBaudRate;
      if FDataBits <> dbDefault then ByteSize := ComDataBits[FDataBits];
      if FParity <> paDefault   then Parity   := ComParity[FParity];
      if FStopBits <> sbDefault then StopBits := ComStopBits[FStopBits];

      with FCharacters do
      begin
{$ifdef D2009PLUS}
        XOnChar := AnsiChar(XOn);
        XOffChar := AnsiChar(XOff);
        ErrorChar := AnsiChar(Error);
        EofChar := AnsiChar(Eof);
        EvtChar := AnsiChar(Event);
{$else}
        XOnChar := XOn;
        XOffChar := XOff;
        ErrorChar := Error;
        EofChar := Eof;
        EvtChar := Event;
{$endif D2009PLUS}
      end;

      with FFlowControl do
      begin
        if DTR <> dcDefault then
          Flags := (Flags and not flagDTRControl) or ComDTRControl[DTR];
        if RTS <> rcDefault then
          Flags := (Flags and not flagRTSControl) or ComRTSControl[RTS];
        if XOnXOff <> xcDefault then
          Flags := (Flags and not (flagInX or flagOutX)) or ComXOnXOffControl[XOnXOff];

        XonLim := XOnLimit;
        XoffLim := XOffLimit;
      end;

      for Option := Low(Option) to High(Option) do
        if Option in FOptions then
          Flags := Flags or ComOptions[Option]
        else
          Flags := Flags and not ComOptions[Option];

      Flags := Flags or flagBinary; // binary flag should be always set
    end
    else
    begin
      CustomBaudRate := BaudRate;

      for ADataBits := Low(ComDataBits) to High(ComDataBits) do
        if ComDataBits[ADataBits] = ByteSize then
        begin
          FDataBits := ADataBits;
          break;
        end;

      for AParity := Low(ComParity) to High(ComParity) do
        if ComParity[AParity] = Parity then
        begin
          FParity := AParity;
          break;
        end;

      for AStopBits := Low(ComStopBits) to High(ComStopBits) do
        if ComStopBits[AStopBits] = StopBits then
        begin
          FStopBits := AStopBits;
          break;
        end;

      with FCharacters do
      begin
{$ifdef D2009PLUS}
        XOn := Char(XOnChar);
        XOff := Char(XOffChar);
        Error := Char(ErrorChar);
        Eof := Char(EofChar);
        Event := Char(EvtChar);
{$else}
        XOn := XOnChar;
        XOff := XOffChar;
        Error := ErrorChar;
        Eof := EofChar;
        Event := EvtChar;
{$endif D2009PLUS}
      end;

      with FFlowControl do
      begin
        for ADTRControl := Low(ComDTRControl) to High(ComDTRControl) do
          if (Flags and flagDTRControl) = ComDTRControl[ADTRControl] then
          begin
            FDTRControl := ADTRControl;
            break;
          end;

        for ARTSControl := Low(ComRTSControl) to High(ComRTSControl) do
          if (Flags and flagRTSControl) = ComRTSControl[ARTSControl] then
          begin
            FRTSControl := ARTSControl;
            break;
          end;

        for AXOnXOffControl := Low(ComXOnXOffControl) to High(ComXOnXOffControl) do
          if (Flags and (flagInX or flagOutX)) = ComXOnXOffControl[AXOnXOffControl] then
          begin
            FXOnXOffControl := AXOnXOffControl;
            break;
          end;

        XOnLimit := XonLim;
        XOffLimit := XoffLim;
      end;

      for AnOption := Low(ComOptions) to High(ComOptions) do
        if (Flags and ComOptions[AnOption]) <> 0 then
          FOptions := FOptions + [AnOption]
        else
          FOptions := FOptions - [AnOption];
    end
end;

procedure TCustomComPort.SetComDCB;
var DCB: TDCB;
begin
  if Active and not (csDesigning in ComponentState) then
  begin
    ZeroMemory(@DCB, SizeOf(DCB));
    DCB.DCBLength := SizeOf(DCB);
    Check(GetCommState(FHandle, DCB));
    CopyDCB(DCB, True);
    Check(SetCommState(FHandle, DCB));
  end;
end;

procedure TCustomComPort.SetOnBreak(Value: TNotifyEvent);
begin
  if @FOnBreak <> @Value then
  begin
    FOnBreak := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnCTSChange(Value: TNotifyEvent);
begin
  if @FOnCTSChange <> @Value then
  begin
    FOnCTSChange := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnDSRChange(Value: TNotifyEvent);
begin
  if @FOnDSRChange <> @Value then
  begin
    FOnDSRChange := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnLineError(Value: TLineErrorEvent);
begin
  if @FOnLineError <> @Value then
  begin
    FOnLineError := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnPrinterError(Value: TNotifyEvent);
begin
  if @FOnPrinterError <> @Value then
  begin
    FOnPrinterError := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnEvent1(Value: TNotifyEvent);
begin
  if @FOnEvent1 <> @Value then
  begin
    FOnEvent1 := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnEvent2(Value: TNotifyEvent);
begin
  if @FOnEvent2 <> @Value then
  begin
    FOnEvent2 := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnRing(Value: TNotifyEvent);
begin
  if @FOnRing <> @Value then
  begin
    FOnRing := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnRLSDChange(Value: TNotifyEvent);
begin
  if @FOnRLSDChange <> @Value then
  begin
    FOnRLSDChange := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnRx80PercFull(Value: TNotifyEvent);
begin
  if @FOnRx80PercFull <> @Value then
  begin
    FOnRx80PercFull := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnRxChar(Value: TNotifyEvent);
begin
  if @FOnRxChar <> @Value then
  begin
    FOnRxChar := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnRxFlag(Value: TNotifyEvent);
begin
  if @FOnRxFlag <> @Value then
  begin
    FOnRxFlag := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetOnTxEmpty(Value: TNotifyEvent);
begin
  if @FOnTxEmpty <> @Value then
  begin
    FOnTxEmpty := Value;
    SetComEventMask;
  end;
end;

procedure TCustomComPort.SetComEventMask;
var EventMask: DWord;
begin
  if Active and not (csDesigning in ComponentState) then
  begin
    EventMask := 0;
    if Assigned(FOnBreak)        then EventMask := EventMask or EV_BREAK;
    if Assigned(FOnCTSChange)    then EventMask := EventMask or EV_CTS;
    if Assigned(FOnDSRChange)    then EventMask := EventMask or EV_DSR;
    if Assigned(FOnLineError)    then EventMask := EventMask or EV_ERR;
    if Assigned(FOnEvent1)       then EventMask := EventMask or EV_EVENT1;
    if Assigned(FOnEvent2)       then EventMask := EventMask or EV_EVENT2;
    if Assigned(FOnPrinterError) then EventMask := EventMask or EV_PERR;
    if Assigned(FOnRing)         then EventMask := EventMask or EV_RING;
    if Assigned(FOnRLSDChange)   then EventMask := EventMask or EV_RLSD;
    if Assigned(FOnRx80PercFull) then EventMask := EventMask or EV_RX80FULL;
    if Assigned(FOnRxChar)       then EventMask := EventMask or EV_RXCHAR;
    if Assigned(FOnRxFlag)       then EventMask := EventMask or EV_RXFLAG;
    if Assigned(FOnTxEmpty)      then EventMask := EventMask or EV_TXEMPTY;

    if EventMask = 0 then
      DestroyThread;

    Check(SetCommMask(FHandle, EventMask));

    if EventMask <> 0 then
      CreateThread;
  end;
end;

procedure TCustomComPort.Loaded;
begin
  inherited Loaded;
  SetActive(FActive);
end;

function TCustomComPort.GetActive: Boolean;
begin
  if not (csDesigning in ComponentState) then
    Result := FHandle <> INVALID_HANDLE_VALUE
  else
    Result := FActive;
end;

procedure TCustomComPort.SetActive(const Value: Boolean);
begin
  if Active <> Value then
    if not (csDesigning in ComponentState) then
      if not (csLoading in ComponentState) then
        if Value then Open else Close;
  FActive := Value;
end;

procedure TCustomComPort.CheckActive;
begin
  if not Active then
    RaiseError(0, SComClosed);
end;

procedure TCustomComPort.CheckInactive;
begin
  if not (csDesigning in ComponentState) then
    if Active then
      RaiseError(0, SComOpen);
end;

procedure TCustomComPort.SetDeviceName(const Value: string);
begin
  if FDeviceName <> Value then
  begin
    CheckInactive;
    FDeviceName := Value;
  end;
end;

procedure TCustomComPort.SetSynchronizeEvents(Value: Boolean);
begin
  if FSynchronizeEvents <> Value then
  begin
    CheckInactive;
    FSynchronizeEvents := Value;
  end;
end;

procedure TCustomComPort.SetPriorityClass(Value: TPriorityClass);
begin
  if FPriorityClass <> Value then
  begin
    CheckInactive;
    FPriorityClass := Value;
  end;  
end;

procedure TCustomComPort.SetThreadPriority(Value: TThreadPriority);
begin
  if FThreadPriority <> Value then
  begin
    FThreadPriority := Value;
    if FComThread <> nil then
      FComThread.Priority := FThreadPriority;
  end;
end;

{$ifdef TRIAL}
var WasTrial: Boolean;

procedure ShowTrial;
begin
  if not WasTrial then
  begin
    MessageBox({$ifdef FPC} 0 {$else} Application.Handle {$endif FPC},
      'A trial version of ComPort started.' + #13#13 +
      'Please note that trial version is supposed to be used for evaluation only. ' +
      'If you wish to distribute components as part of your application,' +
      'you must register from website at https://www.winsoft.sk.' + #13#13 +
      'Thank you for trialing ComPort.',
      'ComPort, Copyright (c) 1998-2022 WINSOFT', MB_OK or MB_ICONINFORMATION);
    WasTrial := True;
  end;
end;
{$endif TRIAL}

procedure TCustomComPort.Open;
begin
  {$ifdef TRIAL}
  ShowTrial;
  {$endif TRIAL}

  if not Active then
  begin
    if Assigned(FBeforeOpen) then
      FBeforeOpen(Self);

    CreateHandle;
    if Log then
      WriteLog('Open ' + DeviceName);

    if Active then
      if Assigned(FAfterOpen) then
        FAfterOpen(Self);
  end;
end;

procedure TCustomComPort.Close;
begin
  // check whether this method was called from the communication thread
  if (FComThread <> nil) and (GetCurrentThreadId = FComThread.ThreadId) then
    FComThread.Synchronize(Close)
  else
  begin
    if Active then
    begin
      if Assigned(FBeforeClose) then
        FBeforeClose(Self);

      FreeHandle;
      if Log then
        WriteLog('Close ' + DeviceName);

      if not Active then
        if Assigned(FAfterClose) then
          FAfterClose(Self);
    end;
  end;
end;

procedure TCustomComPort.RaiseThreadError;
begin
  RaiseError(FThreadError, SysErrorMessage(FThreadError));
end;

procedure TCustomComPort.ThreadProc(Thread: TComThread);
begin
  if WaitCommEvent(FHandle, FEventMask, @FEventOverlapped) then
  begin
    // communication event occured
    if not Thread.Terminated then
      if not FSynchronizeEvents then
        ThreadDoEvent
      else
        Thread.Synchronize(ThreadDoEvent)
  end
  else
  begin
    // some error or overlapping signalization
    if not Thread.Terminated then
    begin
      FThreadError := GetLastError;

      case FThreadError of
        ERROR_IO_PENDING: // overlapping occurs
          begin
            if WaitForSingleObject(FEventOverlapped.hEvent, INFINITE) = WAIT_OBJECT_0 then
              if not Thread.Terminated then
                if not FSynchronizeEvents then
                  ThreadDoEvent
                else
                  Thread.Synchronize(ThreadDoEvent);
          end

        else // raise exception
          begin
            SetLastError(0);
            try
              Thread.Synchronize(RaiseThreadError);
            finally
              if FThreadError = ERROR_ACCESS_DENIED then
                Close;
            end
          end
      end
    end
  end
end;

procedure TCustomComPort.ThreadDoEvent;
begin
  if Active then
  try
    if FEventMask and EV_BREAK <> 0 then
    begin
      WriteLog('Break event');
      if Assigned(FOnBreak) then FOnBreak(Self);
    end;

    if FEventMask and EV_CTS <> 0 then
    begin
      WriteLog('CTSChange event');
      if Assigned(FOnCTSChange) then FOnCTSChange(Self);
    end;

    if FEventMask and EV_DSR <> 0 then
    begin
      WriteLog('DSRChange event');
      if Assigned(FOnDSRChange) then FOnDSRChange(Self);
    end;

    if FEventMask and EV_ERR <> 0 then
    begin
      WriteLog('LineError event');
      if Assigned(FOnLineError) then CheckLineErrors;
    end;

    if FEventMask and EV_EVENT1 <> 0 then
    begin
      WriteLog('Event1 event');
      if Assigned(FOnEvent1) then FOnEvent1(Self);
    end;

    if FEventMask and EV_EVENT2 <> 0 then
    begin
      WriteLog('Event2 event');
      if Assigned(FOnEvent2) then FOnEvent2(Self);
    end;

    if FEventMask and EV_PERR <> 0 then
    begin
      WriteLog('PrinterError event');
      if Assigned(FOnPrinterError) then FOnPrinterError(Self);
    end;

    if FEventMask and EV_RING <> 0 then
    begin
      WriteLog('Ring event');
      if Assigned(FOnRing) then FOnRing(Self);
    end;

    if FEventMask and EV_RLSD <> 0 then
    begin
      WriteLog('RLSDChange event');
      if Assigned(FOnRLSDChange) then FOnRLSDChange(Self);
    end;

    if FEventMask and EV_RX80FULL <> 0 then
    begin
      WriteLog('Rx80PercFull event');
      if Assigned(FOnRx80PercFull) then FOnRx80PercFull(Self);
    end;

    if FEventMask and EV_RXCHAR <> 0 then
    begin
      WriteLog('RxChar event');
      if Assigned(FOnRxChar) then FOnRxChar(Self);
    end;

    if FEventMask and EV_RXFLAG <> 0 then
    begin
      WriteLog('RxFlag event');
      if Assigned(FOnRxFlag) then FOnRxFlag(Self);
    end;

    if FEventMask and EV_TXEMPTY <> 0 then
    begin
      WriteLog('TxEmpty event');
      if Assigned(FOnTxEmpty) then FOnTxEmpty(Self);
    end;
  except
    on E: Exception do {$ifndef CONSOLE} Application.HandleException(E); {$endif CONSOLE}
  end;
end;

procedure TCustomComPort.PurgeInput;
begin
  if Active then
    Check(PurgeComm(FHandle, PURGE_RXABORT or PURGE_RXCLEAR));
end;

procedure TCustomComPort.PurgeOutput;
begin
  if Active then
    Check(PurgeComm(FHandle, PURGE_TXABORT or PURGE_TXCLEAR));
end;

procedure TCustomComPort.ClearInput;
begin
  if Active then
    Check(PurgeComm(FHandle, PURGE_RXCLEAR));
end;

procedure TCustomComPort.ClearOutput;
begin
  if Active then
    Check(PurgeComm(FHandle, PURGE_TXCLEAR));
end;

procedure TCustomComPort.AbortInput;
begin
  if Active then
    Check(PurgeComm(FHandle, PURGE_RXABORT));
end;

procedure TCustomComPort.AbortOutput;
begin
  if Active then
    Check(PurgeComm(FHandle, PURGE_TXABORT));
end;

procedure TCustomComPort.Flush;
begin
  if Active then
    Check(FlushFileBuffers(FHandle));
end;

procedure TCustomComPort.SetComBufferSizes;
begin
  if Active and not (csDesigning in ComponentState) then
    if (FBufferSizes.Input <> -1) and (FBufferSizes.Output <> -1) then
      Check(SetupComm(FHandle, FBufferSizes.Input, FBufferSizes.Output));
end;

procedure TCustomComPort.SetComTimeouts;
var CommTimeouts: TCommTimeouts;
begin
  if Active and not (csDesigning in ComponentState) then
    with FTimeouts, CommTimeouts do
    begin
      Check(GetCommTimeouts(FHandle, CommTimeouts));
      ReadIntervalTimeout := ReadInterval;
      ReadTotalTimeoutMultiplier := ReadMultiplier;
      ReadTotalTimeoutConstant := ReadConstant;
      WriteTotalTimeoutMultiplier := WriteMultiplier;
      WriteTotalTimeoutConstant := WriteConstant;
      Check(SetCommTimeouts(FHandle, CommTimeOuts));
    end;
end;

procedure TCustomComPort.CreateThread;
begin
  if FComThread = nil then
  begin
    FComThread := TComThread.Create(Self);
    if FComThread = nil then
      RaiseError(0, SComCreateThread);
  end;
end;

procedure TCustomComPort.DestroyThread;
begin
  if FComThread <> nil then
  begin
    FComThread.Terminate;
    if FHandle <> INVALID_HANDLE_VALUE then
      SetCommMask(FHandle, 0);
    FComThread := nil;
  end;
end;

procedure TCustomComPort.CreateHandle;
const
  WinPriorityClass: array [TPriorityClass] of DWord =
  ( 0, IDLE_PRIORITY_CLASS, NORMAL_PRIORITY_CLASS,
    HIGH_PRIORITY_CLASS, REALTIME_PRIORITY_CLASS);
begin
  FreeHandle;
  SetLastError(0);
  try
    if PriorityClass <> pcDefault then
    begin
      FOriginalPriorityClass := GetPriorityClass(GetCurrentProcess);
      Windows.SetPriorityClass(GetCurrentProcess, WinPriorityClass[PriorityClass]);
    end;

    // thread event
    FillChar(FEventOverlapped, SizeOf(FEventOverlapped), 0);
    FEventOverlapped.hEvent := CreateEvent(nil, False, False, nil);
    Check(FEventOverlapped.hEvent <> 0);

    // read event object
    FReadEventHandle := CreateEvent(nil, True, True, nil);
    Check(FReadEventHandle <> 0);

    // write event object
    FWriteEventHandle := CreateEvent(nil, True, True, nil);
    Check(FWriteEventHandle <> 0);

    // open comm port
    FHandle := CreateFile(PChar(FDeviceName), GENERIC_READ or GENERIC_WRITE,
                          0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
    Check(FHandle <> INVALID_HANDLE_VALUE);

    PurgeInput;
    PurgeOutput;

    SetComBufferSizes;
    SetComDCB;
    SetComTimeouts;
    SetComEventMask;
  except
    FreeHandle;
    raise;
  end;
end;

procedure TCustomComPort.FreeHandle;
begin
  DestroyThread;

  if FHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  end;

  if FWriteEventHandle <> 0 then
  begin
    CloseHandle(FWriteEventHandle);
    FWriteEventHandle := 0;
  end;

  if FReadEventHandle <> 0 then
  begin
    CloseHandle(FReadEventHandle);
    FReadEventHandle := 0;
  end;

  if FEventOverlapped.hEvent <> 0 then
  begin
    CloseHandle(FEventOverlapped.hEvent);
    FEventOverlapped.hEvent := 0;
  end;

  if FOriginalPriorityClass <> $FFFFFFFF then
  begin
    Windows.SetPriorityClass(GetCurrentProcess, FOriginalPriorityClass);
    FOriginalPriorityClass := $FFFFFFFF;
  end;
end;

procedure TCustomComPort.WaitForReadCompletion;
var ReadCount: DWord;
begin
  if ReadPending then
  begin
    Check(GetOverlappedResult(FHandle, FReadOverlapped, ReadCount, True));
    if FRequestedReadCount <> ReadCount then
      RaiseError(0, SComTimeout);
  end;
  CheckLineErrors;

  if Log then
    if FRequestedReadCount > 0 then
      WriteLog('Read complete ', FRequestedReadBuffer, FRequestedReadCount);
  FRequestedReadCount := 0;
end;

procedure TCustomComPort.WaitForReadCompletion(var ReadCount: Integer);
var ReadCountValue: DWord;
begin
  if ReadPending then
  begin
    Check(GetOverlappedResult(FHandle, FReadOverlapped, ReadCountValue, True));
    ReadCount := ReadCountValue;
  end
  else
    ReadCount := FRequestedReadCount;
  CheckLineErrors;

  if Log then
    if ReadCount > 0 then
    begin
      if ReadCount < Integer(FRequestedReadCount) then
        FRequestedReadCount := ReadCount;
      WriteLog('Read complete ', FRequestedReadBuffer, FRequestedReadCount);
    end;
  FRequestedReadCount := 0;
end;

procedure TCustomComPort.WaitForWriteCompletion;
var WriteCount: DWord;
begin
  if WritePending then
  begin
    Check(GetOverlappedResult(FHandle, FWriteOverlapped, WriteCount, True));
    if FRequestedWriteCount <> WriteCount then
      RaiseError(0, SComTimeout);
  end;
  CheckLineErrors;

  if Log then
    if FRequestedWriteCount > 0 then
      WriteLog('Write complete ', FRequestedWriteBuffer, FRequestedWriteCount);
  FRequestedWriteCount := 0;
end;

procedure TCustomComPort.WaitForWriteCompletion(var WriteCount: Integer);
var WriteCountValue: DWord;
begin
  if WritePending then
  begin
    Check(GetOverlappedResult(FHandle, FWriteOverlapped, WriteCountValue, True));
    WriteCount := WriteCountValue;
  end
  else
    WriteCount := FRequestedWriteCount;
  CheckLineErrors;

  if Log then
    if WriteCount > 0 then
    begin
      if WriteCount < Integer(FRequestedWriteCount) then
        FRequestedWriteCount := WriteCount;
      WriteLog('Write complete ', FRequestedWriteBuffer, FRequestedWriteCount);
    end;
  FRequestedWriteCount := 0;
end;

function TCustomComPort.InputCount: DWord;
var
  Errors: DWord;
  ComStat: TComStat;
begin
  Check(ClearCommError(FHandle, Errors, @ComStat));

  // check line errors
  if Errors <> 0 then
    if Assigned(FOnLineError) then
      FOnLineError(Self, GetLineErrors(Errors));

  Result := ComStat.cbInQue;
end;

function TCustomComPort.OutputCount: DWord;
var
  Errors: DWord;
  ComStat: TComStat;
begin
  Check(ClearCommError(FHandle, Errors, @ComStat));

  // check line errors
  if Errors <> 0 then
    if Assigned(FOnLineError) then
      FOnLineError(Self, GetLineErrors(Errors));

  Result := ComStat.cbOutQue;
end;

function TCustomComPort.GetLineErrors(Errors: DWord): TLineErrors;
const
  ComError: array [TLineError] of Integer =
  (CE_BREAK, CE_DNS, CE_FRAME, CE_IOE, CE_MODE, CE_OOP,
   CE_OVERRUN, CE_PTO, CE_RXOVER, CE_RXPARITY, CE_TXFULL);
var
  LineError: TLineError;
begin
  Result := [];
  for LineError := Low(TLineError) to High(TLineError) do
    if Errors and ComError[LineError] <> 0 then
      Result := Result + [LineError];
end;

procedure TCustomComPort.CheckLineErrors;
var Errors: DWord;
begin
  CheckActive;
  Check(ClearCommError(FHandle, Errors, nil));

  if Errors <> 0 then
    if Assigned(FOnLineError) then
      FOnLineError(Self, GetLineErrors(Errors));
end;

procedure TCustomComPort.ClearLineErrors;
var Errors: DWord;
begin
  CheckActive;
  Check(ClearCommError(FHandle, Errors, nil));
end;

function TCustomComPort.ReadPending: Boolean;
begin
  if FReadEventHandle <> 0 then
    Result := WaitForSingleObject(FReadEventHandle, 0) <> WAIT_OBJECT_0
  else
    Result := False;
end;

function TCustomComPort.WritePending: Boolean;
begin
  if FWriteEventHandle <> 0 then
    Result := WaitForSingleObject(FWriteEventHandle, 0) <> WAIT_OBJECT_0
  else
    Result := False;
end;

procedure TCustomComPort.Read(Buf: Pointer; Count: Integer; WaitForCompletion: Boolean);
var ReadCount: DWord;
begin
  CheckActive;

  if Assigned(FBeforeRead) then
    FBeforeRead(Self, Buf, Count, WaitForCompletion);

  WaitForReadCompletion;

  FRequestedReadCount := Count;
  FRequestedReadBuffer := Buf;
  if FRequestedReadCount > 0 then
  begin
    FillChar(FReadOverlapped, SizeOf(FReadOverlapped), 0);
    FReadOverlapped.hEvent := FReadEventHandle;
    Check(ResetEvent(FReadEventHandle));

    if Log then
      WriteLog('Read request ' + IntToStr(Count) + ' byte(s)');

    Check(ReadFile(FHandle, Buf^, Count, ReadCount, @FReadOverlapped));
    if WaitForCompletion then
      WaitForReadCompletion;
  end;

  if Assigned(FAfterRead) then
    FAfterRead(Self, Buf, Count, WaitForCompletion);
end;

procedure TCustomComPort.Write(Buf: Pointer; Count: Integer; WaitForCompletion: Boolean);
var WriteCount: DWord;
begin
  CheckActive;

  if Assigned(FBeforeWrite) then
    FBeforeWrite(Self, Buf, Count, WaitForCompletion);

  WaitForWriteCompletion;

  FRequestedWriteCount := Count;
  FRequestedWriteBuffer := Buf;
  if FRequestedWriteCount > 0 then
  begin
    FillChar(FWriteOverlapped, SizeOf(FWriteOverlapped), 0);
    FWriteOverlapped.hEvent := FWriteEventHandle;
    Check(ResetEvent(FWriteEventHandle));

    if Log then
      WriteLog('Write request ', Buf, Count);

    if WaitForCompletion then
    begin
      Check(WriteFile(FHandle, Buf^, Count, WriteCount, @FWriteOverlapped));
      WaitForWriteCompletion;
    end
    else
    begin
      // use temporary buffer to ensure that written data remain valid
      // for the duration of the overlapped write operation
      SetLength(FBuffer, Count);
      if Count > 0 then
        Move(Buf^, FBuffer[0], Count);
      FRequestedWriteBuffer := FBuffer;
      Check(WriteFile(FHandle, FBuffer[0], Count, WriteCount, @FWriteOverlapped));
    end;
  end;

  if Assigned(FAfterWrite) then
    FAfterWrite(Self, Buf, Count, WaitForCompletion);
end;

function TCustomComPort.ReadAnsiUntil(Terminator: AnsiChar): AnsiString;
var Data: AnsiChar;
begin
  with TMemoryStream.Create do
  try
    repeat
      Data := ReadAnsiChar;
      Write(Data, SizeOf(Data));
    until Data = Terminator;
    SetLength(Result, Size);
    if Length(Result) > 0 then
      Move(Memory^, Result[1], Size);
  finally
    Free;
  end;
end;

function TCustomComPort.ReadAnsiUntil(const Terminator: AnsiString): AnsiString;
var
  Data: AnsiChar;
  TerminatorSize: Integer;
begin
  if Terminator = '' then
    Result := ''
  else
  begin
    TerminatorSize := Length(Terminator);
    with TMemoryStream.Create do
    try
      repeat
        Data := ReadAnsiChar;
        Write(Data, SizeOf(Data));
      until (Size >= TerminatorSize)
        and CompareMem(PAnsiChar(Memory) + Size - TerminatorSize, @Terminator[1], TerminatorSize);
      SetLength(Result, Size);
      Move(Memory^, Result[1], Size);
    finally
      Free;
    end;
  end;
end;

function TCustomComPort.ReadUntil(Terminator: Char): string;
var Data: Char;
begin
  with TMemoryStream.Create do
  try
    repeat
      Data := ReadChar;
      Write(Data, SizeOf(Data));
    until Data = Terminator;
    SetLength(Result, Size div SizeOf(Char));
    if Length(Result) > 0 then
      Move(Memory^, Result[1], Size);
  finally
    Free;
  end;
end;

function TCustomComPort.ReadUntil(const Terminator: string): string;
var
  Data: Char;
  TerminatorSize: Integer;
begin
  if Terminator = '' then
    Result := ''
  else
  begin
    TerminatorSize := SizeOf(Char) * Length(Terminator);
    with TMemoryStream.Create do
    try
      repeat
        Data := ReadChar;
        Write(Data, SizeOf(Data));
      until (Size >= TerminatorSize)
        and CompareMem(PAnsiChar(Memory) + Size - TerminatorSize, @Terminator[1], TerminatorSize);
      SetLength(Result, Size div SizeOf(Char));
      Move(Memory^, Result[1], Size);
    finally
      Free;
    end;
  end;
end;

function TCustomComPort.ReadAnsiLine: AnsiString;
begin
  Result := ReadAnsiUntil(CR);
end;

procedure TCustomComPort.WriteAnsiLine(const Value: AnsiString);
begin
  WriteAnsiString(Value);
  WriteAnsiChar(CR);
end;

function TCustomComPort.ReadLine: string;
begin
  Result := ReadUntil(CR);
end;

procedure TCustomComPort.WriteLine(const Value: string);
begin
  WriteString(Value);
  WriteChar(CR);
end;

function TCustomComPort.ReadAnsiString: AnsiString;
begin
  WaitForReadCompletion;
  SetLength(Result, InputCount);
  if Length(Result) = 0 then
    Read(nil, 0, True)
  else
    Read(@Result[1], Length(Result), True);
end;

function TCustomComPort.ReadString: string;
begin
  WaitForReadCompletion;
  SetLength(Result, InputCount div SizeOf(Char));
  if Length(Result) = 0 then
    Read(nil, 0, True)
  else
    Read(@Result[1], SizeOf(Char) * Length(Result), True);
end;

procedure TCustomComPort.WriteAnsiString(const Value: AnsiString);
begin
  Write(@Value[1], Length(Value), False);
end;

procedure TCustomComPort.WriteString(const Value: string);
begin
  Write(@Value[1], SizeOf(Char) * Length(Value), False);
end;

function TCustomComPort.ReadAnsiChar: AnsiChar;
begin
  Read(@Result, 1, True);
end;

function TCustomComPort.ReadChar: Char;
begin
  Read(@Result, SizeOf(Char), True);
end;

procedure TCustomComPort.WriteAnsiChar(Value: AnsiChar);
begin
  Write(@Value, 1, False);
end;

procedure TCustomComPort.WriteChar(Value: Char);
begin
  Write(@Value, SizeOf(Char), False);
end;

function TCustomComPort.ReadByte: Byte;
begin
  Read(@Result, 1, True);
end;

procedure TCustomComPort.WriteByte(Value: Byte);
begin
  Write(@Value, 1, False);
end;

function TCustomComPort.ReadWord: Word;
begin
  Read(@Result, 2, True);
end;

procedure TCustomComPort.WriteWord(Value: Word);
begin
  Write(@Value, 2, False);
end;

function TCustomComPort.ReadDWord: DWord;
begin
  Read(@Result, 4, True);
end;

procedure TCustomComPort.WriteDWord(Value: DWord);
begin
  Write(@Value, 4, False);
end;

{$ifdef D2009PLUS}
function TCustomComPort.Read(Encoding: TEncoding): string;
begin
  Result := Encoding.GetString(ReadBytes);
end;

function TCustomComPort.ReadUtf8: string;
begin
  Result := Read(TEncoding.UTF8);
end;

{$else}

function TCustomComPort.ReadUtf8: WideString;
begin
{$ifndef D6PLUS}
  Result := ToWideString(ReadAnsiString);
{$else}
  Result := UTF8Decode(ReadAnsiString);
{$endif D6PLUS}
end;
{$endif D2009PLUS}

function TCustomComPort.ReadBytes: TBytes;
begin
  SetLength(Result, InputCount);
  Read(Result, Length(Result), True);
end;

procedure TCustomComPort.ReadBytes(Value: TBytes; From, Count: Integer);
begin
  if (From < 0) or (Count < 0) or (From + Count > Length(Value)) then
    RaiseError(0, SComParameter);

  Read(@Value[From], Count, True);
end;

{$ifdef D2009PLUS}
procedure TCustomComPort.Write(const Value: string; Encoding: TEncoding);
begin
  WriteBytes(Encoding.GetBytes(Value));
end;

procedure TCustomComPort.WriteUtf8(const Value: string);
begin
  Write(Value, TEncoding.UTF8);
end;

{$else}

procedure TCustomComPort.WriteUtf8(const Value: WideString);
begin
{$ifndef D6PLUS}
  WriteAnsiString(ToUtf8Wide(Value));
{$else}
  WriteAnsiString(UTF8Encode(Value));
{$endif D6PLUS}
end;
{$endif D2009PLUS}

procedure TCustomComPort.WriteBytes(const Value: TBytes);
begin
  Write(Value, Length(Value));
end;

procedure TCustomComPort.WriteBytes(const Value: TBytes; From, Count: Integer);
begin
  if (From < 0) or (Count < 0) or (From + Count > Length(Value)) then
    RaiseError(0, SComParameter);

  Write(@Value[From], Count);
end;

{$ifdef D2009PLUS}
function TCustomComPort.ReadLine(Encoding: TEncoding): string;
begin
  Result := Encoding.GetString(ReadLineBytes);
end;

function TCustomComPort.ReadLineUtf8: string;
begin
  Result := ReadLine(TEncoding.UTF8);
end;

{$else}

function TCustomComPort.ReadLineUtf8: WideString;
begin
  Result := ReadUntilUtf8(Ord(CR));
end;
{$endif D2009PLUS}

function TCustomComPort.ReadLineBytes: TBytes;
begin
  Result := ReadUntilBytes(Ord(CR));
end;

{$ifdef D2009PLUS}
procedure TCustomComPort.WriteLine(const Value: string; Encoding: TEncoding);
begin
  Write(Value, Encoding);
  WriteAnsiChar(CR);
end;

procedure TCustomComPort.WriteLineUtf8(const Value: string);
begin
  WriteLine(Value, TEncoding.UTF8);
end;

{$else}

procedure TCustomComPort.WriteLineUtf8(const Value: WideString);
begin
  WriteUtf8(Value);
  WriteAnsiChar(CR);
end;
{$endif D2009PLUS}

procedure TCustomComPort.WriteLineBytes(const Value: TBytes);
begin
  WriteBytes(Value);
  WriteAnsiChar(CR);
end;

{$ifdef D2009PLUS}
function TCustomComPort.ReadUntil(Terminator: Byte; Encoding: TEncoding): string;
begin
  Result := Encoding.GetString(ReadUntilBytes(Terminator));
end;

function TCustomComPort.ReadUntilUtf8(Terminator: Byte): string;
begin
  Result := ReadUntil(Terminator, TEncoding.UTF8);
end;

{$else}

function TCustomComPort.ReadUntilUtf8(Terminator: Byte): WideString;
begin
{$ifndef D6PLUS}
  Result := ToWideString(ReadAnsiUntil(AnsiChar(Terminator)));
{$else}
  Result := UTF8Decode(ReadAnsiUntil(AnsiChar(Terminator)));
{$endif D6PLUS}
end;
{$endif D2009PLUS}

function TCustomComPort.ReadUntilBytes(Terminator: Byte): TBytes;
var Data: Byte;
begin
{$ifdef D2009PLUS}
  with TBytesStream.Create do
  try
    repeat
      Data := ReadByte;
      Write(Data, SizeOf(Data));
    until Data = Terminator;
    Result := Bytes;
    SetLength(Result, Size);
  finally
    Free;
  end;
{$else}
  with TMemoryStream.Create do
  try
    repeat
      Data := ReadByte;
      Write(Data, SizeOf(Data));
    until Data = Terminator;
    SetLength(Result, Size);
    if Length(Result) > 0 then
      Move(Memory^, Result[0], Size);
  finally
    Free;
  end;
{$endif D2009PLUS}
end;

function TCustomComPort.ReadUntilBytes(const Terminator: TBytes): TBytes;
var
  Data: Byte;
  TerminatorSize: Integer;
begin
  if Terminator = nil then
    Result := nil
  else
  begin
    TerminatorSize := Length(Terminator);
  {$ifdef D2009PLUS}
    with TBytesStream.Create do
    try
      repeat
        Data := ReadByte;
        Write(Data, SizeOf(Data));
      until (Size >= TerminatorSize)
        and CompareMem(@Bytes[Size - TerminatorSize], @Terminator[0], TerminatorSize);
      Result := Bytes;
      SetLength(Result, Size);
    finally
      Free;
    end;
  {$else}
    with TMemoryStream.Create do
    try
      repeat
        Data := ReadByte;
        Write(Data, SizeOf(Data));
      until (Size >= TerminatorSize)
        and CompareMem(PAnsiChar(Memory) + Size - TerminatorSize, @Terminator[0], TerminatorSize);
      SetLength(Result, Size);
      if Length(Result) > 0 then
        Move(Memory^, Result[0], Size);
    finally
      Free;
    end;
  {$endif D2009PLUS}
  end;
end;

function TCustomComPort.ShortDeviceName: string;
begin
  if Pos('\\.\', DeviceName) = 1 then
    Result := Copy(DeviceName, 5, Length(DeviceName))
  else
    Result := DeviceName
end;

function TCustomComPort.ConfigDialog: Boolean;
var
  Device: string;
  CommConfig: TCommConfig;
  Size: DWord;
begin
  Device := ShortDeviceName;
  Size := SizeOf(CommConfig);
  ZeroMemory(@CommConfig, Size);
  CommConfig.dwSize := Size;
  Check(GetDefaultCommConfig(PChar(Device), CommConfig, Size));
  CopyDCB(CommConfig.dcb, True);
  Result := CommConfigDialog(PChar(Device), 0, CommConfig);
  if Result then
  begin
    CopyDCB(CommConfig.dcb, False);
    SetComDCB;
  end;
end;

function TCustomComPort.DefaultConfigDialog: Boolean;
var
  Device: string;
  CommConfig: TCommConfig;
  Size: DWord;
begin
  Device := ShortDeviceName;
  Size := SizeOf(CommConfig);
  ZeroMemory(@CommConfig, Size);
  CommConfig.dwSize := Size;
  Check(GetDefaultCommConfig(PChar(Device), CommConfig, Size));
  Result := CommConfigDialog(PChar(Device), 0, CommConfig);
  if Result then
    Check(SetDefaultCommConfig(PChar(Device), @CommConfig, Size));
end;

procedure TCustomComPort.TransmitChar(Value: {$ifdef D2009PLUS} AnsiChar {$else} Char {$endif D2009PLUS});
begin
  CheckActive;
  Check(TransmitCommChar(FHandle, Value));
end;

procedure TCustomComPort.SetBreak;
begin
  CheckActive;
  Check(SetCommBreak(FHandle));
end;

procedure TCustomComPort.ClearBreak;
begin
  CheckActive;
  Check(ClearCommBreak(FHandle));
end;

procedure TCustomComPort.SetDTR;
begin
  CheckActive;
  Check(EscapeCommFunction(FHandle, Windows.SETDTR));
end;

procedure TCustomComPort.ClearDTR;
begin
  CheckActive;
  Check(EscapeCommFunction(FHandle, CLRDTR));
end;

procedure TCustomComPort.SetRTS;
begin
  CheckActive;
  Check(EscapeCommFunction(FHandle, Windows.SETRTS));
end;

procedure TCustomComPort.ClearRTS;
begin
  CheckActive;
  Check(EscapeCommFunction(FHandle, CLRRTS));
end;

procedure TCustomComPort.SetXOn;
begin
  CheckActive;
  Check(EscapeCommFunction(FHandle, Windows.SETXON));
end;

procedure TCustomComPort.SetXOff;
begin
  CheckActive;
  Check(EscapeCommFunction(FHandle, Windows.SETXOFF));
end;

procedure TCustomComPort.ResetDevice;
{$ifdef FPC}
const
  RESETDEV = 7; // Reset device if possible
{$endif FPC}
begin
  CheckActive;
{$ifdef FPC}
  Check(EscapeCommFunction(FHandle, RESETDEV));
{$else}
  Check(EscapeCommFunction(FHandle, Windows.RESETDEV));
{$endif FPC}
end;

function TCustomComPort.GetModemStatus: TModemStatus;
var ModemStat: DWord;
begin
  Result := [];
  if not (csDesigning in ComponentState) then
  begin
    CheckActive;
    Check(GetCommModemStatus(FHandle, ModemStat));
    if ModemStat and MS_CTS_ON  <> 0 then Result := Result + [msCTS];
    if ModemStat and MS_DSR_ON  <> 0 then Result := Result + [msDSR];
    if ModemStat and MS_RING_ON <> 0 then Result := Result + [msRing];
    if ModemStat and MS_RLSD_ON <> 0 then Result := Result + [msRLSD];
  end;
end;

procedure TCustomComPort.SetFlowControl(Value: TFlowControl);
begin
  FFlowControl.Assign(Value);
end;

procedure TCustomComPort.SetCharacters(Value: TCharacters);
begin
  FCharacters.Assign(Value);
end;

procedure TCustomComPort.SetBufferSizes(Value: TBufferSizes);
begin
  FBufferSizes.Assign(Value);
end;

procedure TCustomComPort.SetTimeouts(Value: TTimeouts);
begin
  FTimeouts.Assign(Value);
end;

function TCustomComPort.StoreCustomBaudRate: Boolean;
begin
  Result := FBaudRate = brCustom;
end;

function TCustomComPort.GetCustomBaudRate: Integer;
const
  ComBaudRate: array [TBaudRate] of Integer =
  (0, 50, 75, CBR_110, 134, 150, CBR_300, CBR_600, CBR_1200, 1800,
   2000, CBR_2400, 3600, CBR_4800, 7200, CBR_9600, 10400, CBR_14400, 15625,
   CBR_19200, 28800, CBR_38400, CBR_56000, CBR_57600, CBR_115200, CBR_128000, CBR_256000,
   0);
begin
  if FBaudRate = brCustom then
    Result := FCustomBaudRate
  else
    Result := ComBaudRate[FBaudRate];
end;

procedure TCustomComPort.SetCustomBaudRate(Value: Integer);
begin
  if FCustomBaudRate <> Value then
  begin
    FCustomBaudRate := Value;
    FBaudRate := brCustom;
    SetComDCB;
  end;
end;

procedure TCustomComPort.EnumDevices(List: TStrings);
var
  Count, Start, i: Integer;
  Buffer: array [0..$FFFE] of Char;
  DeviceName: string;
begin
  Count := QueryDosDevice(nil, Buffer, SizeOf(Buffer));

  Start := 0;
  for i := 0 to Count - 1 do
    if Buffer[i] = #0 then
    begin
      DeviceName := StrPas(PChar(@Buffer[Start]));
      if DeviceName <> '' then
        List.Add(DeviceName);
      Start := i + 1;
    end;
end;

procedure TCustomComPort.EnumComDevices(List: TStrings);
var
  Count, Start, i: Integer;
  Buffer: array [0..$FFFE] of Char;
  DeviceName: string;
begin
  Count := QueryDosDevice(nil, Buffer, SizeOf(Buffer));

  Start := 0;
  for i := 0 to Count - 1 do
    if Buffer[i] = #0 then
    begin
      DeviceName := StrPas(PChar(@Buffer[Start]));
      if (Pos('COM', DeviceName) = 1) or (Pos('\\.\COM', DeviceName) = 1) then
        List.Add(DeviceName);
      Start := i + 1;
    end;
end;

procedure TCustomComPort.EnumComDevicesFromRegistry(List: TStrings);
var
  Names: TStringList;
  i: Integer;
begin
{$ifdef D4}
  with TRegistry.Create do
{$else}
  with TRegistry.Create(KEY_READ) do
{$endif D4}
  try
    RootKey := HKEY_LOCAL_MACHINE;
{$ifdef D3}
      if OpenKey('\HARDWARE\DEVICEMAP\SERIALCOMM', False) then
{$else}
      if OpenKeyReadOnly('\HARDWARE\DEVICEMAP\SERIALCOMM') then
{$endif D3}
      begin
        Names := TStringList.Create;
        try
          GetValueNames(Names);
          for i := 0 to Names.Count - 1 do
            if GetDataType(Names[i]) = rdString then
              List.Add(ReadString(Names[i]));
        finally
          Names.Free;
        end
      end;
  finally
    Free;
  end;
end;

procedure TCustomComPort.EnumComFriendlyNames(List: TStrings);
const
  Key = '\SYSTEM\CurrentControlSet\Enum';
var
  KeyNames, SubKeyNames, SubSubKeyNames: TStringList;
  i, j, k: Integer;
begin
{$ifdef D4}
  with TRegistry.Create do
{$else}
  with TRegistry.Create(KEY_READ) do
{$endif D4}
  try
    RootKey := HKEY_LOCAL_MACHINE;
{$ifdef D3}
      if OpenKey(Key, False) then
{$else}
      if OpenKeyReadOnly(Key) then
{$endif D3}
      begin
        KeyNames := TStringList.Create;
        SubKeyNames := TStringList.Create;
        SubSubKeyNames := TStringList.Create;
        try
          GetKeyNames(KeyNames);

          for i := 0 to KeyNames.Count - 1 do
            if OpenKeyReadOnly(Key + '\' + KeyNames[i]) then
            begin
              SubKeyNames.Clear;
              GetKeyNames(SubKeyNames);

              for j := 0 to SubKeyNames.Count - 1 do
                if OpenKeyReadOnly(Key + '\' + KeyNames[i] + '\' + SubKeyNames[j]) then
                begin
                  SubSubKeyNames.Clear;
                  GetKeyNames(SubSubKeyNames);

                  for k := 0 to SubSubKeyNames.Count - 1 do
                    if OpenKeyReadOnly(Key + '\' + KeyNames[i] + '\' + SubKeyNames[j] + '\' + SubSubKeyNames[k]) then
                      if LowerCase(ReadString('ClassGUID')) = '{4d36e978-e325-11ce-bfc1-08002be10318}' then
                        if GetDataType('FriendlyName') = rdString then
                          List.Add(ReadString('FriendlyName'));
                end
            end
        finally
          SubSubKeyNames.Free;
          SubKeyNames.Free;
          KeyNames.Free;
        end
      end;
  finally
    Free;
  end;
end;

const
  GUID_DEVINTERFACE_SERENUM_BUS_ENUMERATOR: TGUID = '{4D36E978-E325-11CE-BFC1-08002BE10318}';

const
  SetupApiModuleName = 'SetupApi.dll';

//
// Flags controlling what is included in the device information set built
// by SetupDiGetClassDevs
//

const
  DIGCF_DEFAULT         = $00000001; // only valid with DIGCF_DEVICEINTERFACE
  DIGCF_PRESENT         = $00000002;
  DIGCF_ALLCLASSES      = $00000004;
  DIGCF_PROFILE         = $00000008;
  DIGCF_DEVICEINTERFACE = $00000010;
(*
//
// Values indicating a change in a device's state
//

const
  DICS_ENABLE     = $00000001;
  DICS_DISABLE    = $00000002;
  DICS_PROPCHANGE = $00000003;
  DICS_START      = $00000004;
  DICS_STOP       = $00000005;
*)

//
// Values specifying the scope of a device property change
//

const
  DICS_FLAG_GLOBAL         = $00000001; // make change in all hardware profiles
  DICS_FLAG_CONFIGSPECIFIC = $00000002; // make change in specified profile only
  DICS_FLAG_CONFIGGENERAL  = $00000004; // 1 or more hardware profile-specific
                                        // changes to follow.
                                        
//
// KeyType values for SetupDiCreateDevRegKey, SetupDiOpenDevRegKey, and
// SetupDiDeleteDevRegKey.
//

const
  DIREG_DEV  = $00000001; // Open/Create/Delete device key
  DIREG_DRV  = $00000002; // Open/Create/Delete driver key
  DIREG_BOTH = $00000004; // Delete both driver and Device key

//
// Device registry property codes
// (Codes marked as read-only (R) may only be used for
// SetupDiGetDeviceRegistryProperty)
//
// These values should cover the same set of registry properties
// as defined by the CM_DRP codes in cfgmgr32.h.
//
// Note that SPDRP codes are zero based while CM_DRP codes are one based!
//

const
  SPDRP_DEVICEDESC                  = $00000000; // DeviceDesc (R/W)
  SPDRP_HARDWAREID                  = $00000001; // HardwareID (R/W)
  SPDRP_COMPATIBLEIDS               = $00000002; // CompatibleIDs (R/W)
  SPDRP_UNUSED0                     = $00000003; // unused
  SPDRP_SERVICE                     = $00000004; // Service (R/W)
  SPDRP_UNUSED1                     = $00000005; // unused
  SPDRP_UNUSED2                     = $00000006; // unused
  SPDRP_CLASS                       = $00000007; // Class (R--tied to ClassGUID)
  SPDRP_CLASSGUID                   = $00000008; // ClassGUID (R/W)
  SPDRP_DRIVER                      = $00000009; // Driver (R/W)
  SPDRP_CONFIGFLAGS                 = $0000000A; // ConfigFlags (R/W)
  SPDRP_MFG                         = $0000000B; // Mfg (R/W)
  SPDRP_FRIENDLYNAME                = $0000000C; // FriendlyName (R/W)
  SPDRP_LOCATION_INFORMATION        = $0000000D; // LocationInformation (R/W)
  SPDRP_PHYSICAL_DEVICE_OBJECT_NAME = $0000000E; // PhysicalDeviceObjectName (R)
  SPDRP_CAPABILITIES                = $0000000F; // Capabilities (R)
  SPDRP_UI_NUMBER                   = $00000010; // UiNumber (R)
  SPDRP_UPPERFILTERS                = $00000011; // UpperFilters (R/W)
  SPDRP_LOWERFILTERS                = $00000012; // LowerFilters (R/W)
  SPDRP_BUSTYPEGUID                 = $00000013; // BusTypeGUID (R)
  SPDRP_LEGACYBUSTYPE               = $00000014; // LegacyBusType (R)
  SPDRP_BUSNUMBER                   = $00000015; // BusNumber (R)
  SPDRP_ENUMERATOR_NAME             = $00000016; // Enumerator Name (R)
  SPDRP_SECURITY                    = $00000017; // Security (R/W, binary form)
  SPDRP_SECURITY_SDS                = $00000018; // Security (W, SDS form)
  SPDRP_DEVTYPE                     = $00000019; // Device Type (R/W)
  SPDRP_EXCLUSIVE                   = $0000001A; // Device is exclusive-access (R/W)
  SPDRP_CHARACTERISTICS             = $0000001B; // Device Characteristics (R/W)
  SPDRP_ADDRESS                     = $0000001C; // Device Address (R)
  SPDRP_UI_NUMBER_DESC_FORMAT       = $0000001D; // UiNumberDescFormat (R/W)
  SPDRP_DEVICE_POWER_DATA           = $0000001E; // Device Power Data (R)
  SPDRP_REMOVAL_POLICY              = $0000001F; // Removal Policy (R)
  SPDRP_REMOVAL_POLICY_HW_DEFAULT   = $00000020; // Hardware Removal Policy (R)
  SPDRP_REMOVAL_POLICY_OVERRIDE     = $00000021; // Removal Policy Override (RW)
  SPDRP_INSTALL_STATE               = $00000022; // Device Install State (R)
  SPDRP_LOCATION_PATHS              = $00000023; // Device Location Paths (R)
  SPDRP_BASE_CONTAINERID            = $00000024; // Base ContainerID (R)

  SPDRP_MAXIMUM_PROPERTY            = $00000025; // Upper bound on ordinals

type
  HDEVINFO = Pointer;
  HINF = Pointer;

  PCWSTR = PWideChar;
  LPGUID = ^PGUID;
  ULONG_PTR = ^ULONG;

  SP_DEVINFO_DATA = record
    cbSize: Cardinal;
    ClassGuid: TGUID;
    DevInst: Cardinal;
    Reserved: ULONG_PTR;
  end;
  PSP_DEVINFO_DATA = ^SP_DEVINFO_DATA;

  DEVPROPGUID = TGUID;
  PDEVPROPGUID = ^DEVPROPGUID;

  DEVPROPID = ULONG;
  PDEVPROPID = ^DEVPROPID;

  DEVPROPKEY = record
    fmtid: DEVPROPGUID;
    pid: DEVPROPID;
  end;
  PDEVPROPKEY = ^DEVPROPKEY;

  DEVPROPTYPE = ULONG;
  PDEVPROPTYPE = ^DEVPROPTYPE;

const
  DEVPROP_TYPE_STRING = $00000012; // null-terminated string

  DEVPKEY_Device_InstanceId:            DEVPROPKEY = (fmtid: '{78c34fc8-104a-4aca-9ea4-524d52996e57}'; pid: 256);
  DEVPKEY_Device_BusReportedDeviceDesc: DEVPROPKEY = (fmtid: '{540b947e-8b40-45bc-a8a2-6a0b894cbda2}'; pid: 4);
  DEVPKEY_Device_DriverVersion:         DEVPROPKEY = (fmtid: '{a8b865dd-2e3d-4094-ad97-e593a70c75d6}'; pid: 3);
  DEVPKEY_Device_MatchingDeviceId:      DEVPROPKEY = (fmtid: '{a8b865dd-2e3d-4094-ad97-e593a70c75d6}'; pid: 8);
  DEVPKEY_Device_DriverProvider:        DEVPROPKEY = (fmtid: '{a8b865dd-2e3d-4094-ad97-e593a70c75d6}'; pid: 9);

function SetupDiClassGuidsFromNameW(
  {_In_} ClassName: PCWSTR;
  {_Out_writes_to_(ClassGuidListSize, *RequiredSize)} ClassGuidList: LPGUID;
  {_In_} ClassGuidListSize: DWORD;
  {_Out_} out RequiredSize: DWORD
  ): BOOL; stdcall; external SetupApiModuleName name 'SetupDiClassGuidsFromNameW';

function SetupDiGetClassDevsW(
  {_In_opt_} ClassGuid: PGUID;
  {_In_opt_} Enumerator: PCWSTR;
  {_In_opt_} hwndParent: HWND;
  {_In_} Flags: DWORD
  ): HDEVINFO; stdcall; external SetupApiModuleName name 'SetupDiGetClassDevsW';

function SetupDiEnumDeviceInfo(
  {_In_} DeviceInfoSet: HDEVINFO;
  {_In_} MemberIndex: DWORD;
  {_Out_} DeviceInfoData: PSP_DEVINFO_DATA
  ): BOOL; stdcall; external SetupApiModuleName name 'SetupDiEnumDeviceInfo';

function SetupDiDestroyDeviceInfoList(
  {_In_} DeviceInfoSet: HDEVINFO
  ): BOOL; stdcall; external SetupApiModuleName name 'SetupDiDestroyDeviceInfoList';

function SetupDiGetDeviceRegistryPropertyW(
  {_In_} DeviceInfoSet: HDEVINFO;
  {_In_} DeviceInfoData: PSP_DEVINFO_DATA;
  {_In_} Property_: DWORD;
  {_Out_opt_} PropertyRegDataType: PDWORD;
  {_Out_writes_bytes_to_opt_(PropertyBufferSize, *RequiredSize)} PropertyBuffer: PBYTE;
  {_In_} PropertyBufferSize: DWORD;
  {_Out_opt_} RequiredSize: PDWORD
  ): BOOL; stdcall; external SetupApiModuleName name 'SetupDiGetDeviceRegistryPropertyW';

function SetupDiOpenDevRegKey(
  {_In_} DeviceInfoSet: HDEVINFO;
  {_In_} DeviceInfoData: PSP_DEVINFO_DATA;
  {_In_} Scope: DWORD;
  {_In_} HwProfile: DWORD;
  {_In_} KeyType: DWORD;
  {_In_} samDesired: REGSAM
  ): HKEY; stdcall; external SetupApiModuleName name 'SetupDiOpenDevRegKey';

{$ifdef D7PLUS}
function SetupDiGetDevicePropertyW(
  {_In_} DeviceInfoSet: HDEVINFO;
  {_In_} DeviceInfoData: PSP_DEVINFO_DATA;
  {_In_} const PropertyKey: PDEVPROPKEY;
  {_Out_} PropertyType: PDEVPROPTYPE;
  {_Out_writes_bytes_to_opt_(PropertyBufferSize, *RequiredSize)} PropertyBuffer: PBYTE;
  {_In_} PropertyBufferSize: DWORD;
  {_Out_opt_} RequiredSize: PDWORD;
  {_In_} Flags: DWORD
  ): BOOL; stdcall; external SetupApiModuleName name 'SetupDiGetDevicePropertyW';
{$endif D7PLUS}

function GetRegistryString(DeviceInfoSet: HDEVINFO; DeviceInfoData: PSP_DEVINFO_DATA; Property_: DWORD): WString;
var
  RequiredSize, PropertyDataType: DWORD;
  Buffer: TBytes;
begin
  Result := '';
  if not SetupDiGetDeviceRegistryPropertyW(DeviceInfoSet, DeviceInfoData, Property_, @PropertyDataType, nil, 0, @RequiredSize) then
    if (GetLastError = ERROR_INSUFFICIENT_BUFFER) and (PropertyDataType = REG_SZ) and (RequiredSize > 0) then
    begin
      SetLength(Buffer, RequiredSize);
      if SetupDiGetDeviceRegistryPropertyW(DeviceInfoSet, DeviceInfoData, Property_, nil, @Buffer[0], RequiredSize, nil) then
        Result := PWideChar(Buffer);
    end;
end;


function GetPropertyString(DeviceInfoSet: HDEVINFO; DeviceInfoData: PSP_DEVINFO_DATA; const PropertyKey: DEVPROPKEY): WideString;
{$ifdef D7PLUS}
var
  RequiredSize: DWORD;
  PropertyType: DEVPROPTYPE;
  Buffer: TBytes;
{$endif D7PLUS}
begin
  Result := '';
{$ifdef D7PLUS}
  if not SetupDiGetDevicePropertyW(DeviceInfoSet, DeviceInfoData, @PropertyKey, @PropertyType, nil, 0, @RequiredSize, 0) then
    if (GetLastError = ERROR_INSUFFICIENT_BUFFER) and (PropertyType = DEVPROP_TYPE_STRING) and (RequiredSize > 0) then
    begin
      SetLength(Buffer, RequiredSize);
      if SetupDiGetDevicePropertyW(DeviceInfoSet, DeviceInfoData, @PropertyKey, @PropertyType, @Buffer[0], RequiredSize, nil, 0) then
        Result := PWideChar(Buffer);
    end;
{$endif D7PLUS}
end;

function TCustomComPort.DeviceInfos: TDeviceInfos;
var
  DeviceInfoSet: HDEVINFO;
  DeviceInfoData: SP_DEVINFO_DATA;
  MemberIndex: DWORD;

  Key: HKEY;
  ValueType, ValueSize: DWORD;
  Buffer: TBytes;
begin
  Result := nil;
  
  DeviceInfoSet := SetupDiGetClassDevsW(@GUID_DEVINTERFACE_SERENUM_BUS_ENUMERATOR, nil, 0, DIGCF_PRESENT);
  if DeviceInfoSet <> HDEVINFO(INVALID_HANDLE_VALUE) then
  try
    MemberIndex := 0;
    DeviceInfoData.cbSize := SizeOf(DeviceInfoData);

    while SetupDiEnumDeviceInfo(DeviceInfoSet, MemberIndex, @DeviceInfoData) do
    begin
      SetLength(Result, MemberIndex + 1);
      with Result[MemberIndex] do
      begin
        Description := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_DEVICEDESC);
        Driver := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_DRIVER);
        EnumeratorName := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_ENUMERATOR_NAME);
        FriendlyName := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_FRIENDLYNAME);
        Location := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_LOCATION_INFORMATION);
        Manufacturer := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_MFG);
        PhysicalName := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_PHYSICAL_DEVICE_OBJECT_NAME);
        Service := GetRegistryString(DeviceInfoSet, @DeviceInfoData, SPDRP_SERVICE);

        Device := GetPropertyString(DeviceInfoSet, @DeviceInfoData, DEVPKEY_Device_MatchingDeviceId);
        DriverProvider := GetPropertyString(DeviceInfoSet, @DeviceInfoData, DEVPKEY_Device_DriverProvider);
        DriverVersion := GetPropertyString(DeviceInfoSet, @DeviceInfoData, DEVPKEY_Device_DriverVersion);
        Instance := GetPropertyString(DeviceInfoSet, @DeviceInfoData, DEVPKEY_Device_InstanceId);
        ReportedDescription := GetPropertyString(DeviceInfoSet, @DeviceInfoData, DEVPKEY_Device_BusReportedDeviceDesc);

        // retrieve port name
        Key := SetupDiOpenDevRegKey(DeviceInfoSet, @DeviceInfoData, DICS_FLAG_GLOBAL, 0, DIREG_DEV, KEY_READ);
        if Key <> INVALID_HANDLE_VALUE then
        try
          if RegQueryValueExW(Key, 'PortName', nil, @ValueType, nil, @ValueSize) = ERROR_SUCCESS then
            if (ValueType = REG_SZ) and (ValueSize > 0) then
            begin
              SetLength(Buffer, ValueSize);
              if RegQueryValueExW(Key, 'PortName', nil, nil, @Buffer[0], @ValueSize) = ERROR_SUCCESS then
                DeviceName := PWideChar(Buffer);
            end;
        finally
          RegCloseKey(Key);
        end;
      end;

      Inc(MemberIndex);
    end;
  finally
    SetupDiDestroyDeviceInfoList(DeviceInfoSet);
  end;
end;

function TCustomComPort.DeviceInfo(const DeviceName: string; out DeviceInfo: TDeviceInfo): Boolean;
var
  DeviceInfos: TDeviceInfos;
  I: Integer;
begin
  DeviceInfos := Self.DeviceInfos;
  for I := 0 to Length(DeviceInfos) - 1 do
    if (DeviceName = DeviceInfos[I].DeviceName)
      or (DeviceName = '\\.\' + DeviceInfos[I].DeviceName) then
    begin
      DeviceInfo := DeviceInfos[I];
      Result := True;
      Exit;
    end;
  Result := False;
end;

function TCustomComPort.Log: Boolean;
begin
  Result := LogFile <> '';
end;

procedure TCustomComPort.WriteLog(const Message: string; Buf: Pointer; Count: Integer);
type
  ByteArray = array [0..0] of Byte;
var
  TxtFile: TextFile;
  i: Integer;
begin
  if Log then
  begin
    AssignFile(TxtFile, LogFile);
    try
      if FileExists(LogFile) then
        Append(TxtFile)
      else
        Rewrite(TxtFile);
      System.Write(TxtFile, DateTimeToStr(Now));
      System.Write(TxtFile, ' ');
      System.Write(TxtFile, Message);
      if Buf <> nil then
        for i := 0 to Count - 1 do
        begin
          if i > 0 then
            System.Write(TxtFile, ', ');
          System.Write(TxtFile, '$');
          System.Write(TxtFile, IntToHex(ByteArray(Buf^)[i], 2));
        end;
      System.WriteLn(TxtFile);
    finally
      CloseFile(TxtFile);
    end
  end
end;

{$ifndef FPC}
function TCustomComPort.StartNotification: Boolean;
{$ifndef CONSOLE}
var ClassBroadcast: DEV_BROADCAST_DEVICEINTERFACE;
{$endif CONSOLE}
begin
  Result := FNotificationHandle <> nil;
{$ifndef CONSOLE}
  if not Result then
  begin
    Application.HookMainWindow(WindowHook);
    begin
      ZeroMemory(@ClassBroadcast, SizeOf(ClassBroadcast));
      ClassBroadcast.dbcc_size := SizeOf(ClassBroadcast);
      ClassBroadcast.dbcc_devicetype := DBT_DEVTYP_DEVICEINTERFACE;
      ClassBroadcast.dbcc_classguid := GUID_DEVINTERFACE_USB_DEVICE;

      FNotificationHandle := RegisterDeviceNotification(Application.Handle, @ClassBroadcast, DEVICE_NOTIFY_WINDOW_HANDLE);
      Result := FNotificationHandle <> nil;
    end;
  end;

  if not Result then
    Application.UnhookMainWindow(WindowHook);
{$endif CONSOLE}
end;

function TCustomComPort.StopNotification: Boolean;
begin
  Result := True;
{$ifndef CONSOLE}
  if FNotificationHandle <> nil then
  begin
    Result := UnregisterDeviceNotification(FNotificationHandle);
    FNotificationHandle := nil;
    Application.UnhookMainWindow(WindowHook);
  end;
{$endif CONSOLE}
end;

function GetClassDeviceName(ClassDeviceBroadcast: PDEV_BROADCAST_DEVICEINTERFACE): string;
begin
  Result := StrPas(PChar(@ClassDeviceBroadcast.dbcc_name[0]));
end;

function GetPortName(PortBroadcast: PDEV_BROADCAST_PORT): string;
begin
  Result := StrPas(PChar(@PortBroadcast.dbcc_name[0]));
end;

{$ifndef CONSOLE}
function TCustomComPort.WindowHook(var Message: TMessage): Boolean;
var Broadcast: PDEV_BROADCAST_HDR;
begin
  if Message.Msg = WM_DEVICECHANGE then
      case Message.wParam of
        DBT_DEVICEARRIVAL:
        begin
          Broadcast := PDEV_BROADCAST_HDR(Message.lParam);
          case Broadcast.dbcc_devicetype of
            DBT_DEVTYP_DEVICEINTERFACE:
              if Assigned(FOnDeviceArrival) then
                FOnDeviceArrival(Self, GetClassDeviceName(PDEV_BROADCAST_DEVICEINTERFACE(Broadcast)));

            DBT_DEVTYP_PORT:
              if Assigned(FOnDeviceArrival) then
                FOnDeviceArrival(Self, GetPortName(PDEV_BROADCAST_PORT(Broadcast)));
          end;
        end;

        DBT_DEVICEREMOVECOMPLETE:
        begin
          Broadcast := PDEV_BROADCAST_HDR(Message.lParam);
          case Broadcast.dbcc_devicetype of
            DBT_DEVTYP_DEVICEINTERFACE:
              if Assigned(FOnDeviceRemoved) then
                FOnDeviceRemoved(Self, GetClassDeviceName(PDEV_BROADCAST_DEVICEINTERFACE(Broadcast)));

            DBT_DEVTYP_PORT:
              if Assigned(FOnDeviceRemoved) then
                FOnDeviceRemoved(Self, GetPortName(PDEV_BROADCAST_PORT(Broadcast)));
          end;
        end;
      end;
  Result := False;
end;
{$endif CONSOLE}

procedure TCustomComPort.SetOnDeviceArrival(Value: TDeviceArrivalEvent);
begin
  if @FOnDeviceArrival <> @Value then
  begin
    FOnDeviceArrival := Value;
    if not (csDesigning in ComponentState) then
      if Assigned(FOnDeviceArrival) or Assigned(FOnDeviceRemoved) then
        StartNotification
      else
        StopNotification
  end
end;

procedure TCustomComPort.SetOnDeviceRemoved(Value: TDeviceRemovedEvent);
begin
  if @FOnDeviceRemoved <> @Value then
  begin
    FOnDeviceRemoved := Value;
    if not (csDesigning in ComponentState) then
      if Assigned(FOnDeviceArrival) or Assigned(FOnDeviceRemoved) then
        StartNotification
      else
        StopNotification
  end
end;
{$endif FPC}

function TCustomComPort.GetCommProp: TCommProp;
begin
  CheckActive;
  ZeroMemory(@Result, SizeOf(Result));
  Check(GetCommProperties(FHandle, Result));
end;

function TCustomComPort.GetMaxBaudRate: TBaudRate;
begin
  case GetCommProp.dwMaxBaud of
    BAUD_075: Result := br75;
    BAUD_110: Result := br110;
    BAUD_134_5: Result := br134_5;
    BAUD_150: Result := br150;
    BAUD_300: Result := br300;
    BAUD_600: Result := br600;
    BAUD_1200: Result := br1200;
    BAUD_1800: Result := br1800;
    BAUD_2400: Result := br2400;
    BAUD_4800: Result := br4800;
    BAUD_7200: Result := br7200;
    BAUD_9600: Result := br9600;
    BAUD_14400: Result := br14400;
    BAUD_19200: Result := br19200;
    BAUD_38400: Result := br38400;
    BAUD_56K: Result := br56000;
    BAUD_57600: Result := br57600;
    BAUD_115200: Result := br115200;
    BAUD_128K: Result := br128000;
    BAUD_USER: Result := brCustom;
    else Result := brDefault;
  end;
end;

function TCustomComPort.GetSettableParameters: TSettableParameters;
var SettableParameters: DWORD;
begin
  Result := [];
  SettableParameters := GetCommProp.dwSettableParams;
  if (SettableParameters and SP_PARITY) <> 0 then
    Result := Result + [spParity];
  if (SettableParameters and SP_BAUD) <> 0 then
    Result := Result + [spBaudRate];
  if (SettableParameters and SP_DATABITS) <> 0 then
    Result := Result + [spDataBits];
  if (SettableParameters and SP_STOPBITS) <> 0 then
    Result := Result + [spStopBits];
  if (SettableParameters and SP_HANDSHAKING) <> 0 then
    Result := Result + [spHandShaking];
  if (SettableParameters and SP_PARITY_CHECK) <> 0 then
    Result := Result + [spParityCheck];
  if (SettableParameters and SP_RLSD) <> 0 then
    Result := Result + [spRLSD];
end;

function TCustomComPort.GetSettableBaudRates: TBaudRates;
var SettableBaudRates: DWORD;
begin
  Result := [];
  SettableBaudRates := GetCommProp.dwSettableBaud;
  if (SettableBaudRates and BAUD_075) <> 0 then
    Result := Result + [br75];
  if (SettableBaudRates and BAUD_110) <> 0 then
    Result := Result + [br110];
  if (SettableBaudRates and BAUD_134_5) <> 0 then
    Result := Result + [br134_5];
  if (SettableBaudRates and BAUD_150) <> 0 then
    Result := Result + [br150];
  if (SettableBaudRates and BAUD_300) <> 0 then
    Result := Result + [br300];
  if (SettableBaudRates and BAUD_600) <> 0 then
    Result := Result + [br600];
  if (SettableBaudRates and BAUD_1200) <> 0 then
    Result := Result + [br1200];
  if (SettableBaudRates and BAUD_1800) <> 0 then
    Result := Result + [br1800];
  if (SettableBaudRates and BAUD_2400) <> 0 then
    Result := Result + [br2400];
  if (SettableBaudRates and BAUD_4800) <> 0 then
    Result := Result + [br4800];
  if (SettableBaudRates and BAUD_7200) <> 0 then
    Result := Result + [br7200];
  if (SettableBaudRates and BAUD_9600) <> 0 then
    Result := Result + [br9600];
  if (SettableBaudRates and BAUD_14400) <> 0 then
    Result := Result + [br14400];
  if (SettableBaudRates and BAUD_19200) <> 0 then
    Result := Result + [br19200];
  if (SettableBaudRates and BAUD_38400) <> 0 then
    Result := Result + [br38400];
  if (SettableBaudRates and BAUD_56K) <> 0 then
    Result := Result + [br56000];
  if (SettableBaudRates and BAUD_57600) <> 0 then
    Result := Result + [br57600];
  if (SettableBaudRates and BAUD_115200) <> 0 then
    Result := Result + [br115200];
  if (SettableBaudRates and BAUD_128K) <> 0 then
    Result := Result + [br128000];
  if (SettableBaudRates and BAUD_USER) <> 0 then
    Result := Result + [brCustom];
end;

function TCustomComPort.GetSettableStopBits: TSettableStopBits;
var SettableStopBits: Word;
begin
  Result := [];
  SettableStopBits := GetCommProp.wSettableStopParity;
  if (SettableStopBits and STOPBITS_10) <> 0 then
    Result := Result + [sb1];
  if (SettableStopBits and STOPBITS_15) <> 0 then
    Result := Result + [sb1_5];
  if (SettableStopBits and STOPBITS_20) <> 0 then
    Result := Result + [sb2];
end;

function TCustomComPort.GetSettableParity: TSettableParity;
var SettableParity: Word;
begin
  Result := [];
  SettableParity := GetCommProp.wSettableStopParity;
  if (SettableParity and PARITY_NONE) <> 0 then
    Result := Result + [paNone];
  if (SettableParity and PARITY_ODD) <> 0 then
    Result := Result + [paOdd];
  if (SettableParity and PARITY_EVEN) <> 0 then
    Result := Result + [paEven];
  if (SettableParity and PARITY_MARK) <> 0 then
    Result := Result + [paMark];
  if (SettableParity and PARITY_SPACE) <> 0 then
    Result := Result + [paSpace];
end;

function TCustomComPort.GetSettableDataBits: TSettableDataBits;
var SettableDataBits: Word;
begin
  Result := [];
  SettableDataBits := GetCommProp.wSettableData;
  if (SettableDataBits and DATABITS_5) <> 0 then
    Result := Result + [db5];
  if (SettableDataBits and DATABITS_6) <> 0 then
    Result := Result + [db6];
  if (SettableDataBits and DATABITS_7) <> 0 then
    Result := Result + [db7];
  if (SettableDataBits and DATABITS_8) <> 0 then
    Result := Result + [db8];
  if (SettableDataBits and DATABITS_16) <> 0 then
    Result := Result + [db16];
  if (SettableDataBits and DATABITS_16X) <> 0 then
    Result := Result + [db16x];
end;

function TCustomComPort.GetCapabilities: TCapabilities;
var Capabilities: DWORD;
begin
  Result := [];
  Capabilities := GetCommProp.dwProvCapabilities;
  if (Capabilities and PCF_DTRDSR) <> 0 then
    Result := Result + [caDtrDsr];
  if (Capabilities and PCF_RTSCTS) <> 0 then
    Result := Result + [caRtsCts];
  if (Capabilities and PCF_RLSD) <> 0 then
    Result := Result + [caRLSD];
  if (Capabilities and PCF_PARITY_CHECK) <> 0 then
    Result := Result + [caParityCheck];
  if (Capabilities and PCF_XONXOFF) <> 0 then
    Result := Result + [caXOnXOff];
  if (Capabilities and PCF_SETXCHAR) <> 0 then
    Result := Result + [caSettableXChar];
  if (Capabilities and PCF_TOTALTIMEOUTS) <> 0 then
    Result := Result + [caTotalTimeouts];
  if (Capabilities and PCF_INTTIMEOUTS) <> 0 then
    Result := Result + [caIntervalTimeouts];
  if (Capabilities and PCF_SPECIALCHARS) <> 0 then
    Result := Result + [caSpecialChars];
  if (Capabilities and PCF_16BITMODE) <> 0 then
    Result := Result + [ca16BitMode];
end;

//---------------------------------------------------------------------
//
// TFlowControl
//

constructor TFlowControl.Create(ComPort: TCustomComPort);
begin
  inherited Create;
  FComPort := ComPort;
end;

procedure TFlowControl.SetDTRControl(Value: TDTRControl);
begin
  if FDTRControl <> Value then
  begin
    FDTRControl := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TFlowControl.SetRTSControl(Value: TRTSControl);
begin
  if FRTSControl <> Value then
  begin
    FRTSControl := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TFlowControl.SetXOnXOffControl(Value: TXOnXOffControl);
begin
  if FXOnXOffControl <> Value then
  begin
    FXOnXOffControl := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TFlowControl.SetXOnLimit(Value: WORD);
begin
  if FXOnLimit <> Value then
  begin
    FXOnLimit := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TFlowControl.SetXOffLimit(Value: WORD);
begin
  if FXOffLimit <> Value then
  begin
    FXOffLimit := Value;
    FComPort.SetComDCB;
  end;
end;

//---------------------------------------------------------------------
//
// TCharacters
//

constructor TCharacters.Create(ComPort: TCustomComPort);
begin
  inherited Create;
  FComPort := ComPort;
  FXon := #17;
  FXoff := #19;
end;

procedure TCharacters.SetXOn(Value: Char);
begin
  if FXOn <> Value then
  begin
    FXOn := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TCharacters.SetXOff(Value: Char);
begin
  if FXOff <> Value then
  begin
    FXOff := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TCharacters.SetError(Value: Char);
begin
  if FError <> Value then
  begin
    FError := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TCharacters.SetEof(Value: Char);
begin
  if FEof <> Value then
  begin
    FEof := Value;
    FComPort.SetComDCB;
  end;
end;

procedure TCharacters.SetEvent(Value: Char);
begin
  if FEvent <> Value then
  begin
    FEvent := Value;
    FComPort.SetComDCB;
  end;
end;

//---------------------------------------------------------------------
//
// TBufferSize
//

constructor TBufferSizes.Create(ComPort: TCustomComPort);
begin
  inherited Create;
  FComPort := ComPort;
  FInput := 4096;
  FOutput := 2048;
end;

procedure TBufferSizes.SetInput(Value: Integer);
begin
  if FInput <> Value then
  begin
    FInput := Value;
    FComPort.SetComBufferSizes;
  end;
end;

procedure TBufferSizes.SetOutput(Value: Integer);
begin
  if FOutput <> Value then
  begin
    FOutput := Value;
    FComPort.SetComBufferSizes;
  end;
end;

function TBufferSizes.GetMaxInput: Integer;
begin
  Result := FComPort.GetCommProp.dwMaxRxQueue;
end;

function TBufferSizes.GetMaxOutput: Integer;
begin
  Result := FComPort.GetCommProp.dwMaxTxQueue;
end;

function TBufferSizes.GetCurrentInput: Integer;
begin
  Result := FComPort.GetCommProp.dwCurrentRxQueue;
end;

function TBufferSizes.GetCurrentOutput: Integer;
begin
  Result := FComPort.GetCommProp.dwCurrentTxQueue;
end;

//---------------------------------------------------------------------
//
// TTimeouts
//

constructor TTimeouts.Create(ComPort: TCustomComPort);
begin
  inherited Create;
  FComPort := ComPort;
end;

procedure TTimeouts.SetReadInterval(Value: Integer);
begin
  if FReadInterval <> Value then
  begin
    FReadInterval := Value;
    FComPort.SetComTimeouts;
  end;
end;

procedure TTimeouts.SetReadMultiplier(Value: Integer);
begin
  if FReadMultiplier <> Value then
  begin
    FReadMultiplier := Value;
    FComPort.SetComTimeouts;
  end;
end;

procedure TTimeouts.SetReadConstant(Value: Integer);
begin
  if FReadConstant <> Value then
  begin
    FReadConstant := Value;
    FComPort.SetComTimeouts;
  end;
end;

procedure TTimeouts.SetWriteMultiplier(Value: Integer);
begin
  if FWriteMultiplier <> Value then
  begin
    FWriteMultiplier := Value;
    FComPort.SetComTimeouts;
  end;
end;

procedure TTimeouts.SetWriteConstant(Value: Integer);
begin
  if FWriteConstant <> Value then
  begin
    FWriteConstant := Value;
    FComPort.SetComTimeouts;
  end;
end;

end.