unit Common.ExceptDlg.VCL;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.AppEvnts, Vcl.Buttons,
  { JCL }
  JclSysUtils, JclMapi, JclUnitVersioning, JclUnitVersioningProviders, JclDebug;

const
  UM_CREATEDETAILS = WM_USER + $100;
  
type
  TExceptionDlgCallbackProc = reference to procedure(Sender: TObject);

  TExceptionDlg = class(TForm)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    btnOK: TButton;
    btnMailSend: TButton;
    btnSaveToFile: TButton;
    btnDetail: TButton;
    btnClose: TSpeedButton;
    mmoDetail: TMemo;
    mmoText: TMemo;
    BevelDetails: TBevel;
    btnTerminate: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnMailSendClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnTerminateClick(Sender: TObject);
  private
    FDetailsVisible: Boolean;
    FThreadID: DWORD;
    FLastActiveControl: TWinControl;
    FNonDetailsHeight: Integer;
    FFullHeight: Integer;
    FExeName: string;
    FErrTime: TDateTime;

    procedure SaveToLogFile(const FileName: TFileName);
    function GetReportAsText: string;
    procedure UMCreateDetails(var AMsg: TMessage); message UM_CREATEDETAILS;
    procedure SetDetailsVisible(const AValue: Boolean);
  protected
    procedure AfterCreateDetails; dynamic;
    procedure BeforeCreateDetails; dynamic;
    procedure CreateDetails; dynamic;
    procedure CreateReport;
    function ReportMaxColumns: Integer; virtual;
    function ReportNewBlockDelimiterChar: Char; virtual;
    procedure NextDetailBlock;
    procedure UpdateTextMemoScrollbars;
  public
    procedure CopyReportToClipboard;
    class procedure ExceptionHandler(Sender: TObject; E: Exception);
    class procedure ExceptionThreadHandler(Thread: TJclDebugThread);
    class procedure ShowException(E: TObject; Thread: TJclDebugThread);

    property DetailsVisible: Boolean read FDetailsVisible write SetDetailsVisible;
    property ReportAsText: string read GetReportAsText;
  end;

  TExceptionDlgClass = class of TExceptionDlg;

var
  ExceptionDlgClass: TExceptionDlgClass = TExceptionDlg;
  ExceptionDlgCallbackProc: TExceptionDlgCallbackProc;

implementation

{$R *.dfm}

uses
  { Native }
  Vcl.ClipBrd,
  { JCL }
  JclBase, JclFileUtils, JclHookExcept, JclPeImage, JclStrings, JclSysInfo, JclWin32,
  { Project }
  Common.BPCommonLib, Common.LayeredForm;

resourcestring
  RsAppError = '%s - 응용 프로그램 에러';
  RsExceptionClass = 'Exception class: %s';
  RsExceptionMessage = 'Exception message: %s';
  RsExceptionAddr = 'Exception address: %p';
  RsStackList = 'Stack list, generated %s';
  RsModulesList = 'List of loaded modules:';
  RsOSVersion = 'System   : %s %s, Version: %d.%d, Build: %x, "%s"';
  RsProcessor = 'Processor: %s, %s, %d MHz';
  RsMemory = 'Memory: %d; free %d';
  RsScreenRes = 'Display  : %dx%d pixels, %d bpp';
  RsActiveControl = 'Active Controls hierarchy:';
  RsThread = 'Thread: %s';
  RsMissingVersionInfo = '(no module version info)';
  RsExceptionStack = 'Exception stack';
  RsMainThreadID = 'Main thread ID = %d';
  RsExceptionThreadID = 'Exception thread ID = %d';
  RsMainThreadCallStack = 'Call stack for main thread';
  RsThreadCallStack = 'Call stack for thread %d %s "%s"';
  RsExceptionThreadCallStack = 'Call stack for exception thread %s';
//  RsErrorMessage = 'There was an error during the execution of this program.' + NativeLineBreak +
//    'The application might become unstable and even useless.' + NativeLineBreak +
//    'It''s recommended that you save your work and close this application.' + NativeLineBreak + NativeLineBreak;
//  RsDetailsIntro = 'Exception log with detailed tech info. Generated on %s.' + NativeLineBreak +
//    'You may send it to the application vendor, helping him to understand what had happened.' + NativeLineBreak +
//    ' Application title: %s' + NativeLineBreak +
//    ' Application file: %s';
  RsErrorMessage = '프로그램을 실행하는 동안 예기치 않은 오류가 발생했습니다.' + NativeLineBreak +
    '이 오류로 인해 프로그램이 불안정해지고 의도치 않게 동작할 수도 있습니다.' + NativeLineBreak +
    '작업을 저장하고 이 응용 프로그램을 닫는 것이 좋습니다.' + NativeLineBreak + NativeLineBreak;
  RsDetailsIntro = '문제를 해결하기 위해 오류 내용을 메일로 전송하거나 파일로 저장하여 운영자에게 피드백을 보낼 수 있습니다.' + NativeLineBreak +
    ' [발생시각] %s.' + NativeLineBreak +
    ' [프로그램] %s' + NativeLineBreak +
    ' [파일위치] %s';
  RsUnitVersioningIntro = 'Unit versioning information:';

var
  ExceptionDlg: TExceptionDlg;

function SortModulesListByAddressCompare(List: TStringList; Index1, Index2: Integer): Integer;
var
  Addr1, Addr2: TJclAddr;
begin
  Addr1 := TJclAddr(List.Objects[Index1]);
  Addr2 := TJclAddr(List.Objects[Index2]);
  if Addr1 > Addr2 then
    Result := 1
  else if Addr1 < Addr2 then
    Result := -1
  else
    Result := 0;
end;

procedure HookShowException(ExceptObject: TObject; ExceptAddr: Pointer);
begin
  if JclValidateModuleAddress(ExceptAddr) and (ExceptObject.InstanceSize >= Exception.InstanceSize) then
    TExceptionDlg.ExceptionHandler(nil, Exception(ExceptObject))
  else
    System.SysUtils.ShowException(ExceptObject, ExceptAddr);
end;

function HookTApplicationHandleException: Boolean;
const
  CallOffset = $86; // Until D2007
  CallOffsetDebug = $94; // Until D2007
  CallOffsetWin32 = $7A; // D2009 and newer
  CallOffsetWin64 = $95; // DXE2 for Win64
type
  PCALLInstruction = ^TCALLInstruction;

  TCALLInstruction = packed record
    Call: Byte;
    Address: Integer;
  end;
var
  TApplicationHandleExceptionAddr, SysUtilsShowExceptionAddr: Pointer;
  CALLInstruction: TCALLInstruction;
  CallAddress: Pointer;
  WrittenBytes: Cardinal;

  function CheckAddressForOffset(Offset: Cardinal): Boolean;
  begin
    try
      CallAddress := Pointer(TJclAddr(TApplicationHandleExceptionAddr) + Offset);
      CALLInstruction.Call := $E8;
      Result := PCALLInstruction(CallAddress)^.Call = CALLInstruction.Call;
      if Result then
      begin
        if IsCompiledWithPackages then
          Result := PeMapImgResolvePackageThunk(Pointer(SizeInt(CallAddress) + Integer(PCALLInstruction(CallAddress)^.Address) + SizeOf(CALLInstruction))) = SysUtilsShowExceptionAddr
        else
          Result := PCALLInstruction(CallAddress)^.Address = SizeInt(SysUtilsShowExceptionAddr) - SizeInt(CallAddress) - SizeOf(CALLInstruction);
      end;
    except
      Result := False;
    end;
  end;
begin
  TApplicationHandleExceptionAddr := PeMapImgResolvePackageThunk(@TApplication.HandleException);
  SysUtilsShowExceptionAddr := PeMapImgResolvePackageThunk(@System.SysUtils.ShowException);
  if Assigned(TApplicationHandleExceptionAddr) and Assigned(SysUtilsShowExceptionAddr) then
  begin
    Result := CheckAddressForOffset(CallOffset) or CheckAddressForOffset(CallOffsetDebug) or CheckAddressForOffset(CallOffsetWin32) or CheckAddressForOffset(CallOffsetWin64);

    if Result then
    begin
      CALLInstruction.Address := SizeInt(@HookShowException) - SizeInt(CallAddress) - SizeOf(CALLInstruction);
      Result := WriteProtectedMemory(CallAddress, @CALLInstruction, SizeOf(CALLInstruction), WrittenBytes);
    end;
  end
  else
    Result := False;
end;

{ TSBExceptionDialogMail }

var
  ExceptionShowing: Boolean;
  LF: TLayeredForm;

procedure TExceptionDlg.FormCreate(Sender: TObject);
begin
  LF := TLayeredForm.Create(nil);
  LF.Show;

  FFullHeight := ClientHeight;
  FExeName := ExtractFileName(ParamStr(0));
  FErrTime := Now;
  DetailsVisible := False;
  Caption := Format(RsAppError, [Application.Title]);
end;

procedure TExceptionDlg.FormDestroy(Sender: TObject);
begin
  LF.Release;
end;

procedure TExceptionDlg.FormPaint(Sender: TObject);
begin
  DrawIcon(Canvas.Handle, mmoText.Left - GetSystemMetrics(SM_CXICON) - 15, mmoText.Top, LoadIcon(0, IDI_ERROR));
end;

procedure TExceptionDlg.FormResize(Sender: TObject);
begin
  UpdateTextMemoScrollbars;
end;

procedure TExceptionDlg.FormShow(Sender: TObject);
begin
  BeforeCreateDetails;
  MessageBeep(MB_ICONERROR);
  if (GetCurrentThreadId = MainThreadID) and (GetWindowThreadProcessId(Handle, nil) = MainThreadID) then
    PostMessage(Handle, UM_CREATEDETAILS, 0, 0)
  else
    CreateReport;
end;

procedure TExceptionDlg.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (ssCtrl in Shift) then
  begin
    CopyReportToClipboard;
    MessageBeep(MB_OK);
  end
  else if (Key = VK_ESCAPE) then
    ModalResult := mrCancel;
end;

procedure TExceptionDlg.AfterCreateDetails;
begin
  btnMailSend.Enabled := True;
  btnSaveToFile.Enabled := True;
end;

procedure TExceptionDlg.BeforeCreateDetails;
begin
  btnMailSend.Enabled := False;
  btnSaveToFile.Enabled := False;
end;

function TExceptionDlg.ReportMaxColumns: Integer;
begin
  Result := 98; //78
end;

procedure TExceptionDlg.CopyReportToClipboard;
begin
  ClipBoard.AsText := ReportAsText;
end;

procedure TExceptionDlg.CreateDetails;
begin
  mmoDetail.Lines.BeginUpdate;
  try
    CreateReport;
    mmoDetail.SelStart := 0;
    SendMessage(mmoDetail.Handle, EM_SCROLLCARET, 0, 0);
    AfterCreateDetails;
  finally
    mmoDetail.Lines.EndUpdate;
    btnOK.Enabled := True;
    btnDetail.Enabled := True;
    btnOK.SetFocus;
  end;
end;

procedure TExceptionDlg.CreateReport;
var
  SL: TStringList;
  I: Integer;
  ModuleName: TFileName;
  NtHeaders32: PImageNtHeaders32;
  NtHeaders64: PImageNtHeaders64;
  ModuleBase: TJclAddr;
  ImageBaseStr: string;
  C: TWinControl;
  CpuInfo: TCpuInfo;
  ProcessorDetails: string;
  StackList: TJclStackInfoList;
  ThreadList: TJclDebugThreadList;
  AThreadID: DWORD;
  PETarget: TJclPeTarget;
  UnitVersioning: TUnitVersioning;
  UnitVersioningModule: TUnitVersioningModule;
  UnitVersion: TUnitVersion;
  ModuleIndex, UnitIndex: Integer;
begin
  mmoDetail.Lines.Add(Format(LoadResString(PResStringRec(@RsMainThreadID)), [MainThreadID]));
  mmoDetail.Lines.Add(Format(LoadResString(PResStringRec(@RsExceptionThreadID)), [MainThreadID]));
  NextDetailBlock;
  SL := TStringList.Create;
  try
    // Except stack list
    StackList := JclGetExceptStackList(FThreadID);
    if Assigned(StackList) then
    begin
      mmoDetail.Lines.Add(RsExceptionStack);
      mmoDetail.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
      StackList.AddToStrings(mmoDetail.Lines, True, True, True, True);
      NextDetailBlock;
    end;

    // Main thread
    StackList := JclCreateThreadStackTraceFromID(True, MainThreadID);
    if Assigned(StackList) then
    begin
      mmoDetail.Lines.Add(LoadResString(PResStringRec(@RsMainThreadCallStack)));
      mmoDetail.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
      StackList.AddToStrings(mmoDetail.Lines, True, True, True, True);
      NextDetailBlock;
    end;

    // All threads
    ThreadList := JclDebugThreadList;
    ThreadList.Lock.Enter; // avoid modifications
    try
      for I := 0 to ThreadList.ThreadIDCount - 1 do
      begin
        AThreadID := ThreadList.ThreadIDs[I];
        if (AThreadID <> FThreadID) then
        begin
          StackList := JclCreateThreadStackTrace(True, ThreadList.ThreadHandles[I]);
          if Assigned(StackList) then
          begin
            mmoDetail.Lines.Add(Format(RsThreadCallStack, [AThreadID, ThreadList.ThreadInfos[AThreadID], ThreadList.ThreadNames[AThreadID]]));
            mmoDetail.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
            StackList.AddToStrings(mmoDetail.Lines, True, True, True, True);
            NextDetailBlock;
          end;
        end;
      end;
    finally
      ThreadList.Lock.Leave;
    end;

    // System and OS information
    mmoDetail.Lines.Add(Format(RsOSVersion, [GetWindowsVersionString, NtProductTypeString, Win32MajorVersion, Win32MinorVersion, Win32BuildNumber, Win32CSDVersion]));
    GetCpuInfo(CpuInfo);
    ProcessorDetails := Format(RsProcessor, [CpuInfo.Manufacturer, CpuInfo.CpuName, RoundFrequency(CpuInfo.FrequencyInfo.NormFreq)]);

    if not CpuInfo.IsFDIVOK then
      ProcessorDetails := ProcessorDetails + ' [FDIV Bug]';
    if CpuInfo.ExMMX then
      ProcessorDetails := ProcessorDetails + ' MMXex';
    if CpuInfo.MMX then
      ProcessorDetails := ProcessorDetails + ' MMX';
    if sse in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSE';
    if sse2 in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSE2';
    if sse3 in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSE3';
    if ssse3 in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSSE3';
    if sse41 in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSE41';
    if sse42 in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSE42';
    if sse4A in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSE4A';
    if sse5 in CpuInfo.sse then
      ProcessorDetails := ProcessorDetails + ' SSE5';
    if CpuInfo.Ex3DNow then
      ProcessorDetails := ProcessorDetails + ' 3DNow!ex';
    if CpuInfo._3DNow then
      ProcessorDetails := ProcessorDetails + ' 3DNow!';
    if CpuInfo.Is64Bits then
      ProcessorDetails := ProcessorDetails + ' 64 bits';
    if CpuInfo.DEPCapable then
      ProcessorDetails := ProcessorDetails + ' DEP';

    mmoDetail.Lines.Add(ProcessorDetails);
    mmoDetail.Lines.Add(Format(RsMemory, [GetTotalPhysicalMemory div 1024 div 1024, GetFreePhysicalMemory div 1024 div 1024]));
    mmoDetail.Lines.Add(Format(RsScreenRes, [Screen.Width, Screen.Height, GetBPP]));
    NextDetailBlock;

    // Modules list
    if LoadedModulesList(SL, GetCurrentProcessId) then
    begin
      UnitVersioning := GetUnitVersioning;
      UnitVersioning.RegisterProvider(TJclDefaultUnitVersioningProvider);
      mmoDetail.Lines.Add(RsModulesList);
      SL.CustomSort(SortModulesListByAddressCompare);

      for I := 0 to SL.Count - 1 do
      begin
        ModuleName := SL[I];
        ModuleBase := TJclAddr(SL.Objects[I]);
        mmoDetail.Lines.Add(Format('[' + HexDigitFmt + '] %s', [ModuleBase, ModuleName]));
        PETarget := PeMapImgTarget(Pointer(ModuleBase));
        NtHeaders32 := nil;
        NtHeaders64 := nil;

        if PETarget = taWin32 then
          NtHeaders32 := PeMapImgNtHeaders32(Pointer(ModuleBase))
        else if PETarget = taWin64 then
          NtHeaders64 := PeMapImgNtHeaders64(Pointer(ModuleBase));
        if (NtHeaders32 <> nil) and (NtHeaders32^.OptionalHeader.ImageBase <> ModuleBase) then
          ImageBaseStr := Format('<' + HexDigitFmt32 + '> ', [NtHeaders32^.OptionalHeader.ImageBase])
        else if (NtHeaders64 <> nil) and (NtHeaders64^.OptionalHeader.ImageBase <> ModuleBase) then
          ImageBaseStr := Format('<' + HexDigitFmt64 + '> ', [NtHeaders64^.OptionalHeader.ImageBase])
        else
          ImageBaseStr := StrRepeat(' ', 11);

        if VersionResourceAvailable(ModuleName) then
          with TJclFileVersionInfo.Create(ModuleName) do
            try
              mmoDetail.Lines.Add(ImageBaseStr + BinFileVersion + ' - ' + FileVersion);
              if FileDescription <> '' then
                mmoDetail.Lines.Add(StrRepeat(' ', 11) + FileDescription);
            finally
              Free;
            end
        else
          mmoDetail.Lines.Add(ImageBaseStr + RsMissingVersionInfo);

        for ModuleIndex := 0 to UnitVersioning.ModuleCount - 1 do
        begin
          UnitVersioningModule := UnitVersioning.Modules[ModuleIndex];
          if UnitVersioningModule.Instance = ModuleBase then
          begin
            if UnitVersioningModule.Count > 0 then
              mmoDetail.Lines.Add(StrRepeat(' ', 11) + LoadResString(PResStringRec(@RsUnitVersioningIntro)));
            for UnitIndex := 0 to UnitVersioningModule.Count - 1 do
            begin
              UnitVersion := UnitVersioningModule.Items[UnitIndex];
              mmoDetail.Lines.Add(Format('%s%s %s %s %s', [StrRepeat(' ', 13), UnitVersion.LogPath, UnitVersion.RCSfile, UnitVersion.Revision, UnitVersion.Date]));
            end;
          end;
        end;
      end;
      NextDetailBlock;
    end;
    // Active controls
    if (FLastActiveControl <> nil) then
    begin
      mmoDetail.Lines.Add(RsActiveControl);
      C := FLastActiveControl;
      while C <> nil do
      begin
        mmoDetail.Lines.Add(Format('%s "%s"', [C.ClassName, C.Name]));
        C := C.Parent;
      end;
      NextDetailBlock;
    end;
  finally
    SL.Free;
  end;
end;

class procedure TExceptionDlg.ExceptionHandler(Sender: TObject; E: Exception);
begin
  if Assigned(E) then
    if ExceptionShowing then
      Application.ShowException(E)
    else
    begin
      ExceptionShowing := True;
      try
        if IsIgnoredException(E.ClassType) then
          Application.ShowException(E)
        else
          ShowException(E, nil);
      finally
        ExceptionShowing := False;
      end;
    end;
end;

class procedure TExceptionDlg.ExceptionThreadHandler(Thread: TJclDebugThread);
var
  E: Exception;
begin
  E := Exception(Thread.SyncException);
  if Assigned(E) then
    if ExceptionShowing then
      Application.ShowException(E)
    else
    begin
      ExceptionShowing := True;
      try
        if IsIgnoredException(E.ClassType) then
          Application.ShowException(E)
        else
          ShowException(E, Thread);
      finally
        ExceptionShowing := False;
      end;
    end;
end;

function TExceptionDlg.GetReportAsText: string;
begin
  Result := StrEnsureSuffix(NativeCrLf, mmoText.Text) + NativeCrLf + mmoDetail.Text;
end;

procedure TExceptionDlg.NextDetailBlock;
begin
  mmoDetail.Lines.Add(StrRepeat(ReportNewBlockDelimiterChar, ReportMaxColumns));
end;

function TExceptionDlg.ReportNewBlockDelimiterChar: Char;
begin
  Result := '-';
end;

procedure TExceptionDlg.SaveToLogFile(const FileName: TFileName);
var
  SimpleLog: TJclSimpleLog;
begin
  SimpleLog := TJclSimpleLog.Create(FileName);
  try
    SimpleLog.WriteStamp(ReportMaxColumns);
    SimpleLog.Write(ReportAsText);
    SimpleLog.CloseLog;
  finally
    SimpleLog.Free;
  end;
end;

procedure TExceptionDlg.SetDetailsVisible(const AValue: Boolean);
const
  DirectionChars: array [0 .. 1] of Char = ('<', '>');
var
  DetailsCaption: string;
begin
  FDetailsVisible := AValue;
  DetailsCaption := Trim(StrRemoveChars(btnDetail.Caption, DirectionChars));
  if AValue then
  begin
    Constraints.MinHeight := FNonDetailsHeight + 100;
    Constraints.MaxHeight := Screen.Height;
    DetailsCaption := '<< ' + DetailsCaption;
    ClientHeight := FFullHeight;
    mmoDetail.Height := FFullHeight - mmoDetail.Top - 10;
  end
  else
  begin
    FFullHeight := ClientHeight;
    DetailsCaption := DetailsCaption + ' >>';
    if (FNonDetailsHeight = 0) then
    begin
      ClientHeight := BevelDetails.Top;
      FNonDetailsHeight := Height;
    end
    else
      Height := FNonDetailsHeight;
    Constraints.MinHeight := FNonDetailsHeight;
    Constraints.MaxHeight := FNonDetailsHeight
  end;
  btnDetail.Caption := DetailsCaption;
  mmoDetail.Enabled := AValue;
  MakeRoundedControl(Self);
end;

class procedure TExceptionDlg.ShowException(E: TObject; Thread: TJclDebugThread);
begin
  if (ExceptionDlg = nil) then
    ExceptionDlg := ExceptionDlgClass.Create(Application);

  with ExceptionDlg do
  try
    if Assigned(Thread) then
      FThreadID := Thread.ThreadID
    else
      FThreadID := MainThreadID;

    FLastActiveControl := Screen.ActiveControl;
    if E is Exception then
      mmoText.Text := RsErrorMessage + AdjustLineBreaks(StrEnsureSuffix('.', Exception(E).Message))
    else
      mmoText.Text := RsErrorMessage + AdjustLineBreaks(StrEnsureSuffix('.', E.ClassName));

    UpdateTextMemoScrollbars;
    NextDetailBlock;
    mmoDetail.Lines.Add(Format(RsDetailsIntro, [Application.Title, DateTimeToStr(FErrTime), Application.ExeName]));
    NextDetailBlock;
    mmoDetail.Lines.Add(Format(RsExceptionClass, [E.ClassName]));

    if E is Exception then
      mmoDetail.Lines.Add(Format(RsExceptionMessage, [StrEnsureSuffix('.', Exception(E).Message)]));

    if Thread = nil then
      mmoDetail.Lines.Add(Format(RsExceptionAddr, [ExceptAddr]))
    else
      mmoDetail.Lines.Add(Format(RsThread, [Thread.ThreadInfo]));

    NextDetailBlock;
    ShowModal;
    if Assigned(ExceptionDlgCallbackProc) then
      ExceptionDlgCallbackProc(ExceptionDlg);
  finally
    FreeAndNil(ExceptionDlg);
  end;
end;

procedure TExceptionDlg.UMCreateDetails(var AMsg: TMessage);
begin
  Update;
  CreateDetails;
end;

procedure TExceptionDlg.UpdateTextMemoScrollbars;
begin
  Canvas.Font := mmoText.Font;
  if mmoText.Lines.Count * Canvas.TextHeight('Wg') > mmoText.ClientHeight then
    mmoText.ScrollBars := ssVertical
  else
    mmoText.ScrollBars := ssNone;
end;

procedure TExceptionDlg.btnMailSendClick(Sender: TObject);
begin
  with TJclEmail.Create do
    try
      ParentWnd := Application.Handle;
      Recipients.Add(AnsiString(''));
      Subject := AnsiString(Format('버그 리포트: %s (%s)', [Application.Title, FormatDateTime('yyyy-mm-dd hh:nn:ss', FErrTime)]));
      Body := AnsiString(ReportAsText);
      SaveTaskWindows;
      try
        Send(True);
      finally
        RestoreTaskWindows;
      end;
    finally
      Free;
    end;
end;

procedure TExceptionDlg.btnSaveToFileClick(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
    try
      DefaultExt := '.log';
      FileName := ChangeFileExt(FExeName, '') + '_' + FormatDateTime('yyyymmdd', FErrTime) + DefaultExt;
      Filter := '로그 파일 (*.log)|*.log|모든 파일 (*.*)|*.*';
      Title := '로그 파일 저장...';
      Options := [ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing, ofDontAddToRecent];
      if Execute then
        SaveToLogFile(FileName);
    finally
      Free;
    end;
end;

procedure TExceptionDlg.btnDetailClick(Sender: TObject);
begin
  DetailsVisible := not DetailsVisible;
end;

procedure TExceptionDlg.btnTerminateClick(Sender: TObject);
begin
  MessageBeep(MB_ICONINFORMATION);
  if (MessageDlg('프로그램을 강제로 종료하시겠습니까?', mtWarning, [mbOK, mbCancel], 0) = mrOK) then
    Application.Terminate;
end;

procedure TExceptionDlg.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TExceptionDlg.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

var
  AppEvents: TApplicationEvents = nil;

procedure InitializeHandler;
begin
  if (AppEvents = nil) then
  begin
    AppEvents := TApplicationEvents.Create(nil);
    AppEvents.OnException := TExceptionDlg.ExceptionHandler;
    JclStackTrackingOptions := JclStackTrackingOptions + [stRawMode];
    JclStackTrackingOptions := JclStackTrackingOptions + [stStaticModuleList];
    JclStackTrackingOptions := JclStackTrackingOptions + [stDelayedTrace];
    JclDebugThreadList.OnSyncException := TExceptionDlg.ExceptionThreadHandler;
    JclHookThreads;
    JclStartExceptionTracking;
    if HookTApplicationHandleException then
      JclTrackExceptionsFromLibraries;
  end;
end;

procedure UnInitializeHandler;
begin
  if (AppEvents <> nil) then
  begin
    FreeAndNil(AppEvents);
    JclDebugThreadList.OnSyncException := nil;
    JclUnhookExceptions;
    JclStopExceptionTracking;
    JclUnhookThreads;
  end;
end;

initialization
  InitializeHandler;
finalization
  UnInitializeHandler;
end.
