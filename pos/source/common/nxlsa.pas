unit nxlsa;
(*
How do I add the Logon As Service right from my installer?

While there's plenty of information out there how to do it, it seems it's not
easy to find and mostly is in C/C++. Here's short unit that implements

  - AddPrivilege
  - RemovePrivilege

functions doing the job. At the time of writing the following privileges should work fine:

Privilege                         Explanation
================================= ==================================================================
SeNetworkLogonRight               Access this computer from the network
SeInteractiveLogonRight           Log on locally
SeBatchLogonRight                 Log on as a batch job
SeServiceLogonRight               Log on as a service
SeDenyNetworkLogonRight           Deny access this computer from the network
SeDenyInteractiveLogonRight       Deny log on locally
SeDenyBatchLogonRight             Deny log on as a batch job
SeDenyServiceLogonRight           Deny log on as a service
SeCreateGlobalPrivilege           Create global objects
SeDebugPrivilege                  Debug programs
SeDenyRemoteInteractiveLogonRight Deny log on through Terminal Services
SeEnableDelegationPrivilege       Enable computer and user accounts to be trusted for delegation
SeImpersonatePrivilege            Impersonate a client after authentication
SeManageVolumePrivilege           Perform volume maintenance tasks
SeRemoteInteractiveLogonRight     Allow log on through Terminal Services
SeSyncAgentPrivilege              Synchronize directory service data
SeUndockPrivilege                 Remove computer from docking station
*)

interface

uses
  Windows, Messages, SysUtils;

const
  STANDARD_RIGHTS_REQUIRED = $F0000;
  POLICY_CREATE_PRIVILEGE = $40;
  POLICY_CREATE_ACCOUNT = $10;
  POLICY_LOOKUP_NAMES = $800;
  POLICY_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED or POLICY_LOOKUP_NAMES or
    POLICY_CREATE_PRIVILEGE or POLICY_CREATE_ACCOUNT;

type
  PNtStatus = ^TNtStatus;
  NTSTATUS = LongInt;
  TNtStatus = NTSTATUS;

  LSA_OBJECT_ATTRIBUTES = packed record
    Length: integer;
    RootDirectory: integer;
    ObjectName: string;
    Attributes: integer;
    SecurityDescriptor: pointer;
    SecurityQualityOfService: pointer;
  end;

  PLSA_UNICODE_STRING = ^LSA_UNICODE_STRING;
  _LSA_UNICODE_STRING = record
    Length: word;
    MaximumLength: word;
    Buffer: pointer;
  end;
  LSA_UNICODE_STRING = _LSA_UNICODE_STRING;
  TLsaUnicodeString = LSA_UNICODE_STRING;
  PLsaUnicodeString = PLSA_UNICODE_STRING;

  // high level
function OpenPolicy(DesiredAccess: dword; out PolicyHandle: integer): NTSTATUS;
  stdcall;
function GetAccountSid(AccountName: PWideChar; var SID: PSID): boolean; stdcall;
procedure AddPrivilege(const aUserName, aPrivilege: string);
procedure RemovePrivilege(const aUserName, aPrivilege: string);

// low level
function LsaOpenPolicy(SystemName: pointer; ObjectAttributes: pointer;
  DesiredAccess: dword; ptrPolicyHandle: pointer): NTSTATUS; stdcall; external
  'Advapi32.dll' name 'LsaOpenPolicy';
procedure ClosePolicy(PolicyHandle: integer); stdcall; external 'Advapi32.dll'
  name 'LsaClose';
function LsaAddAccountRights(const PolicyHandle: integer; const AccountSid:
  PSID; ptrUserRights: pointer; const CountOfRights: integer): NTSTATUS; stdcall;
  external 'Advapi32.dll' name 'LsaAddAccountRights';
function LsaRemoveAccountRights(const PolicyHandle: integer; const AccountSid:
  PSID; const AllRights: BOOL; ptrUserRights: pointer; const CountOfRights:
  integer): NTSTATUS; stdcall; external 'Advapi32.dll' name
  'LsaRemoveAccountRights';
function SetPrivilegeOnAccount(PolicyHandle: integer; AccountSid: PSID;
  PrivilegeName: string; bEnable: BOOL): NTSTATUS; stdcall;

implementation

function OpenPolicy(DesiredAccess: dword; out PolicyHandle: integer): NTSTATUS;
  stdcall;
var
  ObjectAttributes: LSA_OBJECT_ATTRIBUTES;
begin
  ZeroMemory(@ObjectAttributes, sizeof(ObjectAttributes));
  PolicyHandle := 0;
  Result := LsaOpenPolicy(nil, @ObjectAttributes, DesiredAccess, @PolicyHandle);
end;

function GetAccountSid(AccountName: PWideChar; var SID: PSID): boolean; stdcall;
var
  ReferencedDomain: pointer;
  cbSid: dword;
  cchReferencedDomain: dword;
  peUse: SID_NAME_USE;
  bSuccess: BOOL;
begin
  Result := False;
  SID := nil;
  ReferencedDomain := nil;
  cbSid := 128;
  cchReferencedDomain := 16;
  try
    SID := HeapAlloc(GetProcessHeap(), 0, cbSid);
    if SID = nil then
      Exit;
    ReferencedDomain := HeapAlloc(GetProcessHeap(), 0, cchReferencedDomain * 2);
    if ReferencedDomain = nil then
      Exit;
    while not LookupAccountNameW(nil, AccountName, Sid, cbSid, ReferencedDomain,
      cchReferencedDomain, peUse) do
    begin
      if GetLastError() = ERROR_INSUFFICIENT_BUFFER then
      begin
        Sid := HeapReAlloc(GetProcessHeap(), 0, Sid, cbSid);
        if SID = nil then
          Exit;
        ReferencedDomain := HeapReAlloc(GetProcessHeap(), 0, ReferencedDomain,
          cchReferencedDomain * 2);
        if ReferencedDomain = nil then
          Exit;
      end
      else
        Exit;
    end;
    bSuccess := True;
  finally
    HeapFree(GetProcessHeap(), 0, ReferencedDomain);
  end;
  if not bSuccess and (SID <> nil) then
  begin
    HeapFree(GetProcessHeap(), 0, Sid);
    SID := nil;
  end;
  Result := bSuccess;
end;

function SetPrivilegeOnAccount(PolicyHandle: integer; AccountSid: PSID;
  PrivilegeName: string; bEnable: BOOL): NTSTATUS; stdcall;
var
  Privilege: TLsaUnicodeString;
  I: integer;
begin
  with Privilege do
  begin
    Length := System.Length(PrivilegeName) * 2;
    MaximumLength := Length;
    GetMem(Buffer, Length);
    for I := 1 to System.Length(PrivilegeName) do
      WideChar(Pointer(Integer(Buffer) + (I - 1) * 2)^) := PrivilegeName[I];
  end;

  try
    if bEnable then
      Result := LsaAddAccountRights(PolicyHandle, AccountSid, @Privilege, 1)
    else
      Result := LsaRemoveAccountRights(PolicyHandle, AccountSid, false,
        @Privilege, 1);
  finally
    with Privilege do
      FreeMem(Buffer, Length);
  end;
end;

procedure AddPrivilege(const aUserName, aPrivilege: string);
var
  PolicyHandle: integer;
  SID: PSID;
begin
  if not GetAccountSid(PWideChar(aUserName), SID) then
    raise Exception.Create('could not username account');

  if OpenPolicy(POLICY_ALL_ACCESS, PolicyHandle) <> 0 then
    raise Exception.Create('could not open policy');

  try
    if SetPrivilegeOnAccount(PolicyHandle, SID, aprivilege, true) <> 0 then
      raise Exception.Create('could not set privilege ' + aprivilege);
  finally
    ClosePolicy(PolicyHandle);
  end;
end;

procedure RemovePrivilege(const aUserName, aPrivilege: string);
var
  PolicyHandle: integer;
  SID: PSID;
begin
  if not GetAccountSid(PWideChar(aUserName), SID) then
    raise Exception.Create('could not username account');

  if OpenPolicy(POLICY_ALL_ACCESS, PolicyHandle) <> 0 then
    raise Exception.Create('could not open policy');

  try
    if SetPrivilegeOnAccount(PolicyHandle, SID, aprivilege, false) <> 0 then
      raise Exception.Create('could not remove privilege ' + aprivilege);
  finally
    ClosePolicy(PolicyHandle);
  end;
end;

end.
