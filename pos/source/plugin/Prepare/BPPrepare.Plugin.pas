(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 마스터 수신 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPPrepare.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages, Vcl.ComCtrls;

{$I ..\..\common\Common.BPCommon.inc}

const
  LCN_PROGRESS_MAX = 13;

type
  TPrepareStatus = record
    IsStoreInfo: Boolean;
    IsTerminalInfo: Boolean;
    IsCodeList: Boolean;
    IsLaneList: Boolean;
    IsLockerList: Boolean;
    IsClubList: Boolean;
    IsMemberList: Boolean;
    IsPluList: Boolean;
    IsProdGameList: Boolean;
    IsProdMembershipList: Boolean;
    IsProdLockerList: Boolean;
    IsProdRentList: Boolean;
    IsProdGeneralList: Boolean;
  end;

  TBPPrepareForm = class(TPluginModule)
    btnCancel: TBitBtn;
    pgbProgress: TProgressBar;
    lblProgress: TLabel;
    tmrRunOnce: TTimer;
    panHeader: TPanel;
    lblPluginVersion: TLabel;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure tmrRunOnceTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FPrepareStatus: TPrepareStatus;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoPrepare;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPPrepareForm }

constructor TBPPrepareForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerID := 0;
  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  tmrRunOnce.Enabled := True;
end;

destructor TBPPrepareForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPPrepareForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPPrepareForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPPrepareForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
  end;
end;

procedure TBPPrepareForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPPrepareForm.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TBPPrepareForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    DoPrepare;
  finally
    Free;
  end;
end;

procedure TBPPrepareForm.DoPrepare;
var
  LProgress: ShortInt;
  LJobTitle, LResMsg: string;

  procedure ShowProgress(const AMsg: string);
  begin
    pgbProgress.Position := Trunc((LProgress / LCN_PROGRESS_MAX) * 100);
    lblProgress.Caption  := Format('[%d/%d] %s', [LProgress, LCN_PROGRESS_MAX, AMsg]);
    Application.ProcessMessages;
  end;
begin
  while True do
  begin
    try
      Screen.Cursor := crSQLWait;
      Global.PartnerCenter.ErrorText := '';
      LProgress := 1;
      LJobTitle := '시스템 준비';
      ShowProgress(LJobTitle);

      try
        LJobTitle := '사업장 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsStoreInfo) then
        begin
          FPrepareStatus.IsStoreInfo := BPDM.GetStoreInfo(Global.StoreInfo.StoreCode, LResMsg);
          if not FPrepareStatus.IsStoreInfo then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '터미널 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsTerminalInfo) then
        begin
          FPrepareStatus.IsTerminalInfo := BPDM.GetTerminalInfo(Global.PartnerCenter.TerminalId, LResMsg);
          if not FPrepareStatus.IsTerminalInfo then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '공통 코드 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsCodeList) then
        begin
          FPrepareStatus.IsCodeList := BPDM.GetCodeList(LResMsg);
          if not FPrepareStatus.IsCodeList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '레인 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsLaneList) then
        begin
          FPrepareStatus.IsLaneList := BPDM.GetLaneList(LResMsg);
          if not FPrepareStatus.IsLaneList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '라커 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsLockerList) then
        begin
          FPrepareStatus.IsLockerList := BPDM.GetLockerList(LResMsg);
          if not FPrepareStatus.IsLockerList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '클럽 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsClubList) then
        begin
          FPrepareStatus.IsClubList := BPDM.GetClubList(LResMsg);
          if not FPrepareStatus.IsClubList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '회원 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsMemberList) then
        begin
          FPrepareStatus.IsMemberList := BPDM.GetMemberList(LResMsg);
          if not FPrepareStatus.IsMemberList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '게임 요금제 상품 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsProdGameList) then
        begin
          FPrepareStatus.IsProdGameList := BPDM.GetProdGameList(LResMsg);
          if not FPrepareStatus.IsProdGameList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '회원 상품 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsProdMembershipList) then
        begin
          FPrepareStatus.IsProdMembershipList := BPDM.GetProdMembershipList(LResMsg);
          if not FPrepareStatus.IsProdMembershipList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '라커 상품 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsProdLockerList) then
        begin
          FPrepareStatus.IsProdLockerList := BPDM.GetProdLockerList(LResMsg);
          if not FPrepareStatus.IsProdLockerList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '대여 상품 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsProdRentList) then
        begin
          FPrepareStatus.IsProdRentList := BPDM.GetProdRentList(LResMsg);
          if not FPrepareStatus.IsProdRentList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '일반 상품 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsProdGeneralList) then
        begin
          FPrepareStatus.IsProdGeneralList := BPDM.GetProdGeneralList(LResMsg);
          if not FPrepareStatus.IsProdGeneralList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := 'PLU 정보 수신';
        ShowProgress(LJobTitle);
        if (not FPrepareStatus.IsPluList) then
        begin
          FPrepareStatus.IsPluList := BPDM.GetPluList(LResMsg);
          if not FPrepareStatus.IsPluList then
            raise Exception.Create(LResMsg);
          Inc(LProgress);
        end;

        LJobTitle := '시스템 준비 작업 완료';
        ShowProgress(LJobTitle);
        ModalResult := mrOK;
        Exit;
      finally
        Screen.Cursor := crDefault;
      end;
    except
      on E: Exception do
        if (BPMsgBox(Self.Handle, mtError, '확인',
              LJobTitle + '작업 중 장애가 발생하였습니다.' + _BR + ErrorString(E.Message), ['재시도', '취소']) <> mrOK) then
        begin
          Global.PartnerCenter.ErrorText := E.Message;
          ModalResult := mrCancel;
          Exit;
        end;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPPrepareForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.