//---------------------------------------------------------------------
//
// ComSignal component
//
// Copyright (c) 2002-2022 WINSOFT
//
//---------------------------------------------------------------------

unit ComSignalE;

{$RANGECHECKS OFF}

{$ifdef VER110} // C++ Builder 3
  {$ObjExportAll On}
{$endif VER110}

interface

procedure Register;

implementation

uses Classes, ComSignal;

procedure Register;
begin
  RegisterComponents('System', [TComSignal]);
end;

end.