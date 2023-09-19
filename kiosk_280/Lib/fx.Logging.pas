unit fx.Logging;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

type
  TLogWriteEvent = reference to procedure (S: string);

  Log = class
  private
    class var FOnWrite: TLogWriteEvent;
    class var FDebug: Boolean;
    class var FMessageQueue: TThreadedQueue<string>;
    class var FMessageQueueThread: TThread;
    class constructor Create;
    class destructor Destroy;
    class procedure Write(MessageType: string; Tag: string; Fmt: string; Args: array of const);
  public
    // debug
    class procedure D(Tag: string; Fmt: string; Args: array of const); overload;
    class procedure D(Tag: string; S: string); overload;
    class procedure D(Tag: string; S: string; Value: string); overload;
    class procedure D(Tag: string; S: string; Value: Integer); overload;
    class procedure D(Tag: string; S: string; Value: Int64); overload;
    class procedure D(Tag: string; S: string; Value: Double); overload;
    class procedure D(Tag: string; S: string; Value: TDateTime); overload;
    class procedure D(Tag: string; S: string; Value: TDate); overload;
    class procedure D(Tag: string; S: string; Value: TTime); overload;
    class procedure D(Tag: string; S: string; Value: Extended); overload;
    class procedure D(Tag: string; S: string; Value: Boolean); overload;
    // warning
    class procedure W(Tag: string; Fmt: string; Args: array of const); overload;
    class procedure W(Tag: string; S: string); overload;
    // information
    class procedure I(Tag: string; Fmt: string; Args: array of const); overload;
    class procedure I(Tag: string; S: string); overload;
    // error
    class procedure E(Tag: string; Fmt: string; Args: array of const); overload;
    class procedure E(Tag: string; S: string); overload;

    class property Debug: Boolean read FDebug write FDebug;
    class property OnWrite: TLogWriteEvent read FOnWrite write FOnWrite;
  end;

  TMessageQueueThread = class(TThread)
  private
    FQueue: TThreadedQueue<string>;
  protected
    procedure Execute; override;
  public
    constructor Create(Queue: TThreadedQueue<string>);
  end;

implementation

{ Log }

class constructor Log.Create;
begin
  FDebug := True;

  FMessageQueue := TThreadedQueue<string>.Create;
  FMessageQueueThread := TMessageQueueThread.Create(FMessageQueue);
  FMessageQueueThread.Start;

  ForceDirectories(ExtractFilePath(ParamStr(0)) + 'logs\');
end;

class procedure Log.D(Tag, Fmt: string; Args: array of const);
begin
  if FDebug then Write('D', Tag, Fmt, Args);
end;

class procedure Log.E(Tag, Fmt: string; Args: array of const);
begin
  Write('E', Tag, Fmt, Args);
end;

class procedure Log.I(Tag, Fmt: string; Args: array of const);
begin
  Write('I', Tag, Fmt, Args);
end;

class procedure Log.W(Tag, Fmt: string; Args: array of const);
begin
  Write('W', Tag, Fmt, Args);
end;

class procedure Log.Write(MessageType: string; Tag: string; Fmt: string; Args: array of const);
var
  S: string;
begin
  S := Format('%s'#9'%d'#9'%s'#9'%s'#9'%s', [
    FormatDateTime('yyyy-MM-dd hh:nn:ss:zzz', Now), TThread.Current.ThreadID,
    MessageType, Tag, Format(Fmt, Args)]);

  FMessageQueue.PushItem(S);
end;

class procedure Log.D(Tag, S: string);
begin
  D(Tag, S, []);
end;

class procedure Log.D(Tag, S, Value: string);
begin
  D(Tag, Format('%s'#9'%s', [S, Value]));
end;

class procedure Log.D(Tag, S: string; Value: Integer);
begin
  D(Tag, Format('%s'#9'%d', [S, Value]));
end;

class procedure Log.D(Tag, S: string; Value: Int64);
begin
  D(Tag, Format('%s'#9'%d', [S, Value]));
end;

class procedure Log.E(Tag, S: string);
begin
  E(Tag, S, []);
end;

class procedure Log.I(Tag, S: string);
begin
  I(Tag, S, []);
end;

class procedure Log.W(Tag, S: string);
begin
  W(Tag, S, []);
end;

class procedure Log.D(Tag, S: string; Value: TDateTime);
begin
  D(Tag, Format('%s'#9'%s', [S, FormatDateTime('yyyy-MM-dd hh:nn:ss:zzz', Value)]));
end;

class procedure Log.D(Tag, S: string; Value: Double);
begin
  D(Tag, Format('%s'#9'%f', [S, Value]));
end;

class procedure Log.D(Tag, S: string; Value: Extended);
begin
  D(Tag, Format('%s'#9'%f', [S, Value]));
end;

class procedure Log.D(Tag, S: string; Value: TDate);
begin
  D(Tag, Format('%s'#9'%s', [S, FormatDateTime('yyyy-MM-dd', Value)]));
end;

class procedure Log.D(Tag, S: string; Value: TTime);
begin
  D(Tag, Format('%s'#9'%s', [S, FormatDateTime('hh:nn:ss:zzz', Value)]));
end;

class destructor Log.Destroy;
begin
  FMessageQueueThread.Terminate;
  FMessageQueueThread.WaitFor;
  FMessageQueueThread.Free;
  FMessageQueueThread := nil;

  FMessageQueue.Free;
end;

class procedure Log.D(Tag, S: string; Value: Boolean);
begin
  D(Tag, Format('%s'#9'%s', [S, BoolToStr(Value, True)]));
end;

{ TMessageQueueThread }

constructor TMessageQueueThread.Create(Queue: TThreadedQueue<string>);
begin
  inherited Create(True);

  FQueue := Queue;
  FreeOnTerminate := False;
end;

procedure TMessageQueueThread.Execute;

  procedure AsyncEvent(S: string);
  begin
    TThread.Queue(nil,
    procedure
    begin
      if Assigned(Log.OnWrite) then
        Log.OnWrite(S);
    end);
  end;

var
  FileName: string;
  Text: TextFile;
  S: string;
begin
  while not Terminated do
  begin
    if FQueue.QueueSize > 0 then
    begin
      S := '';
      repeat
        S := S + FQueue.PopItem + sLineBreak;
      until FQueue.QueueSize = 0;
      S := Trim(S);

      FileName := ExtractFilePath(ParamStr(0)) + 'logs\' + FormatDateTime('yyyy-MM-dd', Now) + '.txt';

      AssignFile(Text, FileName);
      try
        if FileExists(FileName) then
          Append(Text)
        else
          Rewrite(Text);

        Writeln(Text, S);
      finally
        CloseFile(Text);
      end;

      AsyncEvent(S);
    end;

    Sleep(50);
  end
end;

end.
