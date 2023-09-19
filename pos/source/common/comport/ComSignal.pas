//---------------------------------------------------------------------
//
// ComSignal component
//
// Copyright (c) 2002-2022 WINSOFT
//
//---------------------------------------------------------------------

unit ComSignal;

{$RANGECHECKS OFF}

{$ifdef VER110} // C++ Builder 3
  {$ObjExportAll On}
{$endif VER110}

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 23}
    {$define DXE2PLUS} // Delphi XE2 or higher
  {$ifend}
{$endif}

{$ifdef FPC}
  {$MODE Delphi}
{$endif FPC}

interface

uses
  SysUtils, Classes, Vcl.Graphics, Vcl.Controls, ComPort, Vcl.ExtCtrls;

type
  TSignal = (siNone, siBreak, siRxChar, siTxChar, siCTS, siDSR,
             siEvent1, siEvent2, siLineError, siPrinterError, siRing,
             siRLSD, siRx80PercFull, siRxFlag, siTxEmpty);

  {$ifdef DXE2PLUS}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$endif DXE2PLUS}
  TComSignal = class(TComponent)
  private
    FColorOff: TColor;
    FColorOn: TColor;
    FComPort: TComPort;
    FControl: TControl;
    FDelay: Integer;
    FSignal: TSignal;
    FSignalValue: Boolean;
    FTimer: TTimer;
    FWriting: Boolean;

    FAfterClose: TOpenCloseEvent;
    FAfterOpen: TOpenCloseEvent;
    FAfterWrite: TReadWriteEvent;
    FBeforeWrite: TReadWriteEvent;
    FOnNotifySignal: TNotifyEvent;
    FOnLineError: TLineErrorEvent;
    FOnModemSignal: TNotifyEvent;

    FOnSignal: TNotifyEvent;

    function GetAbout: string;
    procedure SetAbout(const Value: string);
    procedure SetColorOff(Value: TColor);
    procedure SetComPort(Value: TComPort);
    procedure SetControl(Value: TControl);
    procedure SetDelay(Value: Integer);
    procedure SetSignalValue(Value: Boolean);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateColor;
    procedure UpdateSignalValue;
    procedure RetrieveEvents;
    procedure RestoreEvents;
    procedure StartTimer;

    procedure AfterClose(ComPort: TCustomComPort);
    procedure AfterOpen(ComPort: TCustomComPort);
    procedure AfterWrite(Sender: TObject; Buffer: Pointer; Length: Integer; WaitOnCompletion: Boolean);
    procedure BeforeWrite(Sender: TObject; Buffer: Pointer; Length: Integer; WaitOnCompletion: Boolean);

    procedure OnNotifySignal(Sender: TObject);
    procedure OnLineError(Sender: TObject; LineErrors: TLineErrors);
    procedure OnModemSignal(Sender: TObject);
    procedure OnTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property About: string read GetAbout write SetAbout stored False;
    property ColorOff: TColor read FColorOff write SetColorOff default clGreen;
    property ColorOn: TColor read FColorOn write FColorOn default clLime;
    property ComPort: TComPort read FComPort write SetComPort;
    property Control: TControl read FControl write SetControl;
    property Delay: Integer read FDelay write SetDelay {default 100};
    property Signal: TSignal read FSignal write FSignal;
    property SignalValue: Boolean read FSignalValue {write SetSignalValue} stored False;

    property OnSignal: TNotifyEvent read FOnSignal write FOnSignal;
  end;

implementation

constructor TComSignal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorOff := clGreen;
  FColorOn := clLime;
  FDelay := 100;
  FTimer := TTimer.Create(Self);
  FTimer.Interval := FDelay;
  FTimer.OnTimer := OnTimer;
end;

destructor TComSignal.Destroy;
begin
  FTimer.Free;
  RestoreEvents;
  inherited Destroy;
end;

function TComSignal.GetAbout: string;
begin
  Result := 'Version 6.6, Copyright (c) 1998-2022 WINSOFT, https://www.winsoft.sk';
end;

procedure TComSignal.SetAbout(const Value: string);
begin
end;

procedure TComSignal.RetrieveEvents;
begin
  if not (csLoading in ComponentState) and not (csDesigning in ComponentState) then
    if FComPort <> nil then
    begin
      FAfterOpen := FComPort.AfterOpen;
      FComPort.AfterOpen := AfterOpen;

      FAfterClose := FComPort.AfterClose;
      FComPort.AfterClose := AfterClose;

      case FSignal of
        siBreak:  begin
                    FOnNotifySignal := FComPort.OnBreak;
                    FComPort.OnBreak := OnNotifySignal;
                  end;

        siEvent1: begin
                    FOnNotifySignal := FComPort.OnEvent1;
                    FComPort.OnEvent1 := OnNotifySignal;
                  end;

        siEvent2: begin
                    FOnNotifySignal := FComPort.OnEvent2;
                    FComPort.OnEvent2 := OnNotifySignal;
                  end;

        siLineError:
                  begin
                    FOnLineError := FComPort.OnLineError;
                    FComPort.OnLineError := OnLineError;
                  end;

        siPrinterError:
                  begin
                    FOnNotifySignal := FComPort.OnPrinterError;
                    FComPort.OnPrinterError := OnNotifySignal;
                  end;

        siRxChar: begin
                    FOnNotifySignal := FComPort.OnRxChar;
                    FComPort.OnRxChar := OnNotifySignal;
                  end;

        siTxChar: begin
                    FBeforeWrite := FComPort.BeforeWrite;
                    FAfterWrite := FComPort.AfterWrite;
                    FComPort.BeforeWrite := BeforeWrite;
                    FComPort.AfterWrite := AfterWrite;
                  end;

        siRx80PercFull:
                  begin
                    FOnNotifySignal := FComPort.OnRx80PercFull;
                    FComPort.OnRx80PercFull := OnNotifySignal;
                  end;

        siRxFlag:
                  begin
                    FOnNotifySignal := FComPort.OnRxFlag;
                    FComPort.OnRxFlag := OnNotifySignal;
                  end;

        siTxEmpty:
                  begin
                    FOnNotifySignal := FComPort.OnTxEmpty;
                    FComPort.OnTxEmpty := OnNotifySignal;
                  end;

        siCTS:    begin
                    FOnModemSignal := FComPort.OnCTSChange;
                    FComPort.OnCTSChange := OnModemSignal;
                  end;

        siDSR:    begin
                    FOnModemSignal := FComPort.OnDSRChange;
                    FComPort.OnDSRChange := OnModemSignal;
                  end;

        siRing:    begin
                    FOnModemSignal := FComPort.OnRing;
                    FComPort.OnRing := OnModemSignal;
                  end;

        siRLSD:    begin
                    FOnModemSignal := FComPort.OnRLSDChange;
                    FComPort.OnRLSDChange := OnModemSignal;
                  end;

      end;
    end;
end;

function IsEqual(const Left, Right: TMethod): Boolean;
begin
  Result := (Left.Data = Right.Data) and (Left.Code = Right.Code);
end;

procedure TComSignal.RestoreEvents;
var
  AfterOpenEvent: TOpenCloseEvent;
  AfterCloseEvent: TOpenCloseEvent;
  NotifySignalEvent: TNotifyEvent;
  LineErrorEvent: TLineErrorEvent;
  ModemSignalEvent: TNotifyEvent;
  AfterWriteEvent: TReadWriteEvent;
  BeforeWriteEvent: TReadWriteEvent;
begin
  if not (csDesigning in ComponentState) then
    if FComPort <> nil then
    begin
      AfterOpenEvent := AfterOpen;
      if IsEqual(TMethod(FComPort.AfterOpen), TMethod(AfterOpenEvent)) then
        FComPort.AfterOpen := FAfterOpen;

      AfterCloseEvent := AfterClose;
      if IsEqual(TMethod(FComPort.AfterClose), TMethod(AfterCloseEvent)) then
        FComPort.AfterClose := FAfterClose;

      case FSignal of
        siBreak:        begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnBreak), TMethod(NotifySignalEvent)) then
                            FComPort.OnBreak := FOnNotifySignal;
                        end;

        siEvent1:       begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnEvent1), TMethod(NotifySignalEvent)) then
                            FComPort.OnEvent1 := FOnNotifySignal;
                        end;

        siEvent2:       begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnEvent2), TMethod(NotifySignalEvent)) then
                            FComPort.OnEvent2 := FOnNotifySignal;
                        end;

        siLineError:    begin
                          LineErrorEvent := OnLineError;
                          if IsEqual(TMethod(FComPort.OnLineError), TMethod(LineErrorEvent)) then
                            FComPort.OnLineError := FOnLineError;
                        end;

        siPrinterError: begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnPrinterError), TMethod(NotifySignalEvent)) then
                            FComPort.OnPrinterError := FOnNotifySignal;
                        end;

        siRxChar:       begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnRxChar), TMethod(NotifySignalEvent)) then
                            FComPort.OnRxChar := FOnNotifySignal;
                        end;

        siTxChar:       begin
                          BeforeWriteEvent := BeforeWrite;
                          if IsEqual(TMethod(FComPort.BeforeWrite), TMethod(BeforeWriteEvent)) then
                            FComPort.BeforeWrite := FBeforeWrite;

                          AfterWriteEvent := AfterWrite;
                          if IsEqual(TMethod(FComPort.AfterWrite), TMethod(AfterWriteEvent)) then
                            FComPort.AfterWrite := FAfterWrite;
                        end;

        siRx80PercFull: begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnRx80PercFull), TMethod(NotifySignalEvent)) then
                            FComPort.OnRx80PercFull := FOnNotifySignal;
                        end;
                      
        siRxFlag:       begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnRxFlag), TMethod(NotifySignalEvent)) then
                            FComPort.OnRxFlag := FOnNotifySignal;
                        end;

        siTxEmpty:      begin
                          NotifySignalEvent := OnNotifySignal;
                          if IsEqual(TMethod(FComPort.OnTxEmpty), TMethod(NotifySignalEvent)) then
                            FComPort.OnTxEmpty := FOnNotifySignal;
                        end;

        siCTS:          begin
                          ModemSignalEvent := OnModemSignal;
                          if IsEqual(TMethod(FComPort.OnCTSChange), TMethod(ModemSignalEvent)) then
                            FComPort.OnCTSChange := FOnModemSignal;
                        end;    

        siDSR:          begin
                          ModemSignalEvent := OnModemSignal;
                          if IsEqual(TMethod(FComPort.OnDSRChange), TMethod(ModemSignalEvent)) then
                            FComPort.OnDSRChange := FOnModemSignal;
                        end;

        siRing:         begin
                          ModemSignalEvent := OnModemSignal;
                          if IsEqual(TMethod(FComPort.OnRing), TMethod(ModemSignalEvent)) then
                            FComPort.OnRing := FOnModemSignal;
                        end;

        siRLSD:         begin
                          ModemSignalEvent := OnModemSignal;
                          if IsEqual(TMethod(FComPort.OnRLSDChange), TMethod(ModemSignalEvent)) then
                            FComPort.OnRLSDChange := FOnModemSignal;
                        end;
      end;
    end;

  FAfterClose := nil;
  FAfterOpen := nil;
  FAfterWrite := nil;
  FBeforeWrite := nil;
  FOnNotifySignal := nil;
  FOnLineError := nil;
  FOnModemSignal := nil;
end;

procedure TComSignal.StartTimer;
begin
  FTimer.Enabled := False;
  FTimer.Enabled := True;
end;

procedure TComSignal.Loaded;
begin
  inherited Loaded;
  RetrieveEvents;
  UpdateSignalValue;
  UpdateColor;
end;

procedure TComSignal.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = FComPort then
      ComPort := nil
    else if AComponent = FControl then
      Control := nil
end;

procedure TComSignal.SetColorOff(Value: TColor);
begin
  if FColorOff <> Value then
  begin
    FColorOff := Value;
    UpdateColor;
  end;
end;

procedure TComSignal.SetComPort(Value: TComPort);
begin
  if Value <> FComPort then
  begin
    FTimer.Enabled := False;
    RestoreEvents;
    FComPort := Value;
    RetrieveEvents;
    UpdateSignalValue;
  end;
end;

procedure TComSignal.SetControl(Value: TControl);
begin
  if FControl <> Value then
  begin
    FControl := Value;
    UpdateColor;
  end;
end;

procedure TComSignal.SetDelay(Value: Integer);
begin
  if Value <> FDelay then
  begin
    FDelay := Value;
    FTimer.Interval := Value;
  end;  
end;

type
  TControlWithColor = class(TControl)
  public
    property Color;
  end;

procedure TComSignal.UpdateColor;
begin
  if FControl <> nil then
    if FSignalValue then
      TControlWithColor(FControl).Color := ColorOn
    else
      TControlWithColor(FControl).Color := ColorOff;
end;

procedure TComSignal.SetSignalValue(Value: Boolean);
begin
  if Value <> FSignalValue then
  begin
    FSignalValue := Value;
    UpdateColor;

    if Assigned(FOnSignal) then
      FOnSignal(Self);
  end;
end;

procedure TComSignal.OnNotifySignal(Sender: TObject);
begin
  SetSignalValue(True);
  StartTimer;

  if Assigned(FOnNotifySignal) then
    FOnNotifySignal(ComPort);
end;

procedure TComSignal.OnLineError(Sender: TObject; LineErrors: TLineErrors);
begin
  SetSignalValue(True);
  StartTimer;

  if Assigned(FOnLineError) then
    FOnLineError(ComPort, LineErrors);
end;

procedure TComSignal.OnTimer(Sender: TObject);
begin
  if (FSignal = siTxChar) and FWriting then // transmitting waits for AfterWrite event
    Exit;

  FTimer.Enabled := False; // stop timer
  SetSignalValue(False);
end;

procedure TComSignal.BeforeWrite(Sender: TObject; Buffer: Pointer; Length: Integer; WaitOnCompletion: Boolean);
begin
  SetSignalValue(True);
  FWriting := True;
  StartTimer;

  if Assigned(FBeforeWrite) then
    FBeforeWrite(Sender, Buffer, Length, WaitOnCompletion);
end;

procedure TComSignal.AfterWrite(Sender: TObject; Buffer: Pointer; Length: Integer; WaitOnCompletion: Boolean);
begin
  FWriting := False;
  if Assigned(FAfterWrite) then
    FAfterWrite(Sender, Buffer, Length, WaitOnCompletion);
end;

procedure TComSignal.OnModemSignal(Sender: TObject);
begin
  UpdateSignalValue;
  if Assigned(FOnModemSignal) then
    FOnModemSignal(ComPort);
end;

procedure TComSignal.UpdateSignalValue;
var Value: Boolean;
begin
  Value := False;
  if (FComPort <> nil) and (FComPort.Active) then
    case FSignal of
      siCTS:  Value := msCTS in FComPort.ModemStatus;
      siDSR:  Value := msDSR in FComPort.ModemStatus;
      siRing: Value := msRing in FComPort.ModemStatus;
      siRLSD: Value := msRLSD in FComPort.ModemStatus;
    end;
  SetSignalValue(Value);
end;

procedure TComSignal.AfterClose(ComPort: TCustomComPort);
begin
  UpdateSignalValue;
  if Assigned(FAfterClose) then
    FAfterClose(ComPort);
end;

procedure TComSignal.AfterOpen(ComPort: TCustomComPort);
begin
  UpdateSignalValue;
  if Assigned(FAfterOpen) then
    FAfterOpen(ComPort);
end;

end.