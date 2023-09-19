(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 회원 조회/등록/수정 및 보유상품 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPMember.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Data.DB, Vcl.Mask, Vcl.ComCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBGridEh, DBLookupEh, DBCtrlsEh,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  cxDBData, cxLabel, cxCurrencyEdit, cxCheckBox, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView,
  cxGrid;

{$I ..\..\common\Common.BPCommon.inc}

type
  (*
  TPageControl = class(Vcl.ComCtrls.TPageControl)
  private
    procedure TCMAdjustRect(var AMsg: TMessage); message TCM_ADJUSTRECT;
  end;
  *)

  TBPMemberForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    pgcMember: TPageControl;
    tabMemberInfo: TTabSheet;
    edtMemberName: TDBEditEh;
    edtMemberTelNo: TDBEditEh;
    edtMemberNo: TDBEditEh;
    edtMemberCarNo: TDBEditEh;
    edtMemberSavePoint: TDBNumberEditEh;
    mmoMemberMemo: TDBMemoEh;
    edtMemberBirthday: TDBEditEh;
    edtMemberZipNo: TDBEditEh;
    edtMemberAddr: TDBEditEh;
    edtMemberAddr2: TDBEditEh;
    edtMemberEmail: TDBEditEh;
    ckbMemberAdAgree: TDBCheckBoxEh;
    edtMemberFPHash: TDBEditEh;
    gbxMemberPhoto: TGroupBox;
    btnPhotoFromFile: TBitBtn;
    btnPhotoClear: TBitBtn;
    btnMemberZipNo: TBitBtn;
    btnPhotoFromWebCam: TBitBtn;
    rdgMemberSexDiv: TDBRadioGroupEh;
    btnSendQRCode: TBitBtn;
    btnPrintQRCode: TBitBtn;
    panMemberEditToolbar: TPanel;
    btnFPHash: TBitBtn;
    btnGotoMemberList: TBitBtn;
    btnEditMember: TBitBtn;
    btnSaveMember: TBitBtn;
    tabMemberList: TTabSheet;
    panMemberListHeader: TPanel;
    panMemberListToolbar: TPanel;
    btnRefreshMemberList: TBitBtn;
    btnGotoAddMember: TBitBtn;
    btnGotoEditMember: TBitBtn;
    btnSelectMember: TBitBtn;
    btnSelectMembership: TBitBtn;
    btnSelectLocker: TBitBtn;
    dsrMemberList: TDataSource;
    dsrMembership: TDataSource;
    dsrMemberLocker: TDataSource;
    edtSearchMemberName: TDBEditEh;
    edtSearchMemberTelNo: TDBEditEh;
    btnSearchMember: TBitBtn;
    edtMemberQRCode: TDBEditEh;
    btnSearchClear: TBitBtn;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    L1: TcxGridLevel;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    L2: TcxGridLevel;
    G3: TcxGrid;
    V3: TcxGridDBBandedTableView;
    L3: TcxGridLevel;
    V1member_nm: TcxGridDBBandedColumn;
    V1tel_no: TcxGridDBBandedColumn;
    V1car_no: TcxGridDBBandedColumn;
    V1calc_sex_div: TcxGridDBBandedColumn;
    V1birthday: TcxGridDBBandedColumn;
    V1member_group_nm: TcxGridDBBandedColumn;
    lblSearchTitle: TLabel;
    V2prod_nm: TcxGridDBBandedColumn;
    V2calc_game_div: TcxGridDBBandedColumn;
    V2calc_purchase: TcxGridDBBandedColumn;
    V2calc_remain: TcxGridDBBandedColumn;
    V2start_dt: TcxGridDBBandedColumn;
    V2end_dt: TcxGridDBBandedColumn;
    V2shoes_free_yn: TcxGridDBBandedColumn;
    V2calc_use_status: TcxGridDBBandedColumn;
    V3locker_nm: TcxGridDBBandedColumn;
    V3calc_locker_zone_code: TcxGridDBBandedColumn;
    V3calc_locker_layer_code: TcxGridDBBandedColumn;
    V3start_dt: TcxGridDBBandedColumn;
    V3end_dt: TcxGridDBBandedColumn;
    V3calc_locker_status: TcxGridDBBandedColumn;
    btnAddMember: TBitBtn;
    dsrClubList: TDataSource;
    cbxMemberDiv: TDBComboBoxEh;
    cbxMemberClubSeq: TDBLookupComboboxEh;
    cbxMemberGroupCode: TDBLookupComboboxEh;
    dsrMemberGroupList: TDataSource;
    ckbUseRoadAddr: TDBCheckBoxEh;
    V2use_status: TcxGridDBBandedColumn;
    V3locker_status: TcxGridDBBandedColumn;
    V1club_nm: TcxGridDBBandedColumn;
    V1save_point: TcxGridDBBandedColumn;
    imgMemberPhoto: TImage;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveMemberClick(Sender: TObject);
    procedure btnEditMemberClick(Sender: TObject);
    procedure btnGotoMemberListClick(Sender: TObject);
    procedure btnFPHashClick(Sender: TObject);
    procedure btnPhotoClearClick(Sender: TObject);
    procedure btnGotoAddMemberClick(Sender: TObject);
    procedure btnSearchClearClick(Sender: TObject);
    procedure btnSearchMemberClick(Sender: TObject);
    procedure btnRefreshMemberListClick(Sender: TObject);
    procedure btnGotoEditMemberClick(Sender: TObject);
    procedure btnSelectMemberClick(Sender: TObject);
    procedure btnSelectMembershipClick(Sender: TObject);
    procedure btnSelectLockerClick(Sender: TObject);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure edtSearchMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtSearchMemberTelNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAddMemberClick(Sender: TObject);
    procedure V1DblClick(Sender: TObject);
    procedure V2DblClick(Sender: TObject);
    procedure V3DblClick(Sender: TObject);
    procedure btnMemberZipNoClick(Sender: TObject);
    procedure edtMemberTelNoKeyPress(Sender: TObject; var Key: Char);
    procedure V2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V3CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure PluginModuleShow(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FIndex: ShortInt;
    FWorking: Boolean;
    FProdDiv: string;
    FBaseGameDiv: ShortInt;
    FDataMode: ShortInt;
    FSearchType: ShortInt;
    FSearchValue: string;
    FSearchType2: ShortInt;
    FSearchValue2: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ClearMember;
    procedure LoadMember(const AMemberNo: string);
    procedure SelectedMember(const AMemberNo: string); overload;
    procedure SelectedMember(const AMemberNo, ADCFeeDiv, AProdCode: string; const AMembershipSeq: Integer; const AShoesFree: Boolean); overload;
    procedure RefreshDataSet(const AFullRefresh: Boolean; const ASearchType: ShortInt=CO_SEARCH_NONE; ASearchValue: string=''); overload;
    procedure RefreshDataSet(const AFullRefresh: Boolean; const ASearchType: ShortInt; ASearchValue: string; const ASearchType2: ShortInt; ASearchValue2: string); overload;

    procedure SetDataMode(const AValue: ShortInt);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property DataMode: ShortInt read FDataMode write SetDataMode default CO_DATA_MODE_VIEW;
    property SearchType: ShortInt read FSearchType write FSearchType default CO_SEARCH_NONE;
    property SearchValue: string read FSearchValue write FSearchValue;
    property SearchType2: ShortInt read FSearchType2 write FSearchType2 default CO_SEARCH_NONE;
    property SearchValue2: string read FSearchValue2 write FSearchValue2;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs, System.Variants, System.Math,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox,
  Common.BPZipCode;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPMemberForm }

constructor TBPMemberForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  FIndex := -1;
  FWorking := False;
  FProdDiv := '';
  FDataMode := CO_DATA_MODE_VIEW;
  FSearchType := CO_SEARCH_NONE;
  FSearchValue := '';

  lblPluginVersion.Caption := Format('Plugin v%s', [GetModuleVersion(GetModuleName(HInstance))]);
  with pgcMember do
  begin
    for var I: ShortInt := 0 to Pred(PageCount) do
      Pages[I].TabVisible := False;
    ActivePageIndex := 0;
  end;

  with cbxMemberDiv do
  begin
    Text := '';
    Items.Clear;
    Items.Add('일반');
    Items.Add('회원');
    Items.Add('학생');
    Items.Add('클럽');
    ItemIndex := 0;
  end;

  if not dsrClubList.DataSet.Active then
    dsrClubList.DataSet.Active := True;
  if not dsrMemberGroupList.DataSet.Active then
    dsrMemberGroupList.DataSet.Active := True;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPMemberForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPMemberForm.PluginModuleShow(Sender: TObject);
begin
  if FDataMode in [CO_DATA_MODE_LIST, CO_DATA_MODE_SELECT] then
    edtSearchMemberName.SetFocus;
end;

procedure TBPMemberForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPMemberForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPMemberForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    FIndex := AMsg.ParamByInteger(CPP_INDEX); //레인 배정 화면에서 기본설정 상품과 볼러별 상품을 구분하기 위해 사용
    FProdDiv := AMsg.ParamByString(CPP_PROD_DIV);
    FBaseGameDiv := AMsg.ParamByInteger(CPP_GAME_DIV);
    SearchType := AMsg.ParamByInteger(CPP_SEARCH_TYPE);
    SearchValue := AMsg.ParamByString(CPP_VALUE);
    SearchType2 := AMsg.ParamByInteger(CPP_SEARCH_TYPE + '2');
    SearchValue2 := AMsg.ParamByString(CPP_VALUE + '2');
    edtSearchMemberName.Text := SearchValue;
    edtSearchMemberTelNo.Text := SearchValue2;
    try
      G1.Enabled := False;
      DataMode := AMsg.ParamByInteger(CPP_DATA_MODE);
      btnSelectMembership.Enabled := (DataMode = CO_DATA_MODE_SELECT) and (not FProdDiv.IsEmpty) and (FProdDiv = CO_PROD_GAME);
      btnSelectLocker.Enabled := (DataMode = CO_DATA_MODE_SELECT) and (not FProdDiv.IsEmpty) and (FProdDiv = CO_PROD_LOCKER);
      RefreshDataSet(True, SearchType, SearchValue, SearchType2, SearchValue2);
    finally
      G1.Enabled := True;
    end;
  end;
end;

procedure TBPMemberForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Self.ModalResult := mrCancel;
    VK_RETURN:
      if (pgcMember.ActivePage = tabMemberList) and
         not ((ActiveControl = edtSearchMemberName) or (ActiveControl = edtSearchMemberTelNo)) then
        btnSelectMember.Click;
  end;
end;

procedure TBPMemberForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPMemberForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPMemberForm.btnFPHashClick(Sender: TObject);
begin
//
end;

procedure TBPMemberForm.btnGotoAddMemberClick(Sender: TObject);
begin
  DataMode := CO_DATA_MODE_NEW;
end;

procedure TBPMemberForm.btnGotoEditMemberClick(Sender: TObject);
begin
  with V1.DataController.DataSet do
    if (RecordCount > 0) then
    begin
      DataMode := CO_DATA_MODE_EDIT;
      LoadMember(FieldByName('member_no').AsString);
    end;
end;

procedure TBPMemberForm.edtMemberTelNoKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, [#08, #9, #13, #45, #48..#57]) then
    Key := #0;
end;

procedure TBPMemberForm.edtSearchMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    with TDBEditEh(Sender) do
      if not Text.IsEmpty then
        RefreshDataSet(True, CO_SEARCH_MEMBER_NAME, Text)
end;

procedure TBPMemberForm.edtSearchMemberTelNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    with TDBEditEh(Sender) do
      if not Text.IsEmpty then
        RefreshDataSet(True, CO_SEARCH_TEL_NO, Text)
end;

procedure TBPMemberForm.btnEditMemberClick(Sender: TObject);
begin
  DataMode := CO_DATA_MODE_EDIT;
end;

procedure TBPMemberForm.btnGotoMemberListClick(Sender: TObject);
begin
  DataMode := CO_DATA_MODE_LIST;
end;

procedure TBPMemberForm.btnMemberZipNoClick(Sender: TObject);
begin
  if FWorking then
    Exit;
  FWorking := True;
  with TBPZipCodeForm.Create(nil) do
  try
    UseRoadAddr := ckbUseRoadAddr.Checked;
    SearchValue := Trim(edtMemberAddr.Text);
    if (ShowModal = mrOk) then
    begin
      edtMemberZipNo.Text := ZipCodeValue;
      edtMemberAddr.Text := Addr1Value;
    end;
  finally
    Free;
    FWorking := False;
  end;
end;

procedure TBPMemberForm.btnPhotoClearClick(Sender: TObject);
begin
  imgMemberPhoto.Picture := nil;
end;

procedure TBPMemberForm.btnRefreshMemberListClick(Sender: TObject);
begin
  RefreshDataSet(True, FSearchType, FSearchValue);
end;

procedure TBPMemberForm.btnSearchClearClick(Sender: TObject);
begin
  edtSearchMemberName.Clear;
  edtSearchMemberTelNo.Clear;
  btnSearchMember.Click;
end;

procedure TBPMemberForm.btnSearchMemberClick(Sender: TObject);
begin
  RefreshDataSet(True, CO_SEARCH_MEMBER_NAME, edtSearchMemberName.Text, CO_SEARCH_TEL_NO, edtSearchMemberTelNo.Text)
end;

procedure TBPMemberForm.btnSelectMemberClick(Sender: TObject);
begin
  if FWorking then
    Exit;
  FWorking := True;
  with V1.DataController.DataSet do
  try
    if (RecordCount > 0) then
      case DataMode of
        CO_DATA_MODE_LIST:
          begin
            LoadMember(FieldByName('member_no').AsString);
            DataMode := CO_DATA_MODE_VIEW;
          end;
        CO_DATA_MODE_SELECT:
          SelectedMember(FieldByName('member_no').AsString);
      end;
  finally
    FWorking := False;
  end;
end;

procedure TBPMemberForm.btnSelectMembershipClick(Sender: TObject);
var
  LUseStatus, LGameDiv, LRemain, LMembershipSeq, LRemainCount, LRemainMin: Integer;
  LStartDate, LEndDate, LMemberNo, LProdDetailDiv, LProdCode, LDCFeeDiv: string;
  LShoesFree: Boolean;
begin
  with V2.DataController.DataSet do
  try
    if (RecordCount = 0) then
      Exit;
    LMemberNo := FieldByName('member_no').AsString;
    LProdDetailDiv := FieldByName('prod_detail_div').AsString;
    LProdCode := FieldByName('prod_cd').AsString;
    LUseStatus := FieldByName('use_status').AsInteger;
    LGameDiv := FieldByName('game_div').AsInteger;
    LShoesFree := False;
    //우대회원권
    if (LProdDetailDiv = CO_PROD_DETAIL_MEMBER_VIP) then
    begin
      LDCFeeDiv := FieldByName('discount_fee_div').AsString;
      LShoesFree := FieldByName('shoes_free_yn').AsBoolean;
    end
    else if ((FBaseGameDiv = CO_RATEPLAN_GAME) and (LProdDetailDiv <> CO_PROD_DETAIL_MEMBER_GAME)) or
            ((FBaseGameDiv = CO_RATEPLAN_TIME) and (LProdDetailDiv <> CO_PROD_DETAIL_MEMBER_TIME)) then
      raise Exception.Create('선택한 게임 요금제와 일치하지 않는 상품입니다.');
    LRemain := IfThen(LGameDiv = CO_RATEPLAN_GAME, FieldByName('remain_game_cnt').AsInteger, IfThen(LGameDiv = CO_RATEPLAN_TIME, FieldByName('remain_game_min').AsInteger, 0));
    LStartDate := FieldByName('start_dt').AsString;
    LEndDate := FieldByName('end_dt').AsString;
    LMembershipSeq := FieldByName('membership_seq').Asinteger;
    LRemainCount := FieldByName('remain_game_cnt').Asinteger;
    LRemainMin :=  FieldByName('remain_game_min').Asinteger;
    if (LUseStatus <> CO_STATUS_INUSE) or
       ((LGameDiv in [CO_RATEPLAN_GAME, CO_RATEPLAN_TIME]) and (LRemain = 0)) or
       (LStartDate > Global.DateTime.FormattedCurrentDate) or
       (LEndDate < Global.DateTime.FormattedCurrentDate) then
      raise Exception.Create('이용조건에 맞지 않아 선택할 수 없는 상품입니다.');
    SelectedMember(LMemberNo, LDCFeeDiv, LProdCode, LMembershipSeq, LShoesFree);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TBPMemberForm.btnSelectLockerClick(Sender: TObject);
begin
  with V3.DataController.DataSet do
    if (RecordCount > 0) then
      SelectedMember(FieldByName('member_no').AsString, '', FieldByName('prod_cd').AsString, 0, False);
end;

procedure TBPMemberForm.btnAddMemberClick(Sender: TObject);
begin
  DataMode := CO_DATA_MODE_NEW;
end;

procedure TBPMemberForm.btnSaveMemberClick(Sender: TObject);
var
  MI: TMemberInfoRec;
  LResMsg: string;
begin
  if FWorking then
    Exit;
  FWorking := True;
  try
    try
      MI.Clear;
      MI.MemberNo := edtMemberNo.Text;
      MI.MemberName := Trim(edtMemberName.Text);
      if not VarIsNull(cbxMemberClubSeq.Value) then
        MI.ClubSeq := Integer(cbxMemberClubSeq.Value);
      Mi.MemberDiv := Format('%.2d', [Succ(cbxMemberDiv.ItemIndex)]);
      if not VarIsNull(cbxMemberGroupCode.Value) then
        MI.MemberGroupCode := String(cbxMemberGroupCode.Value);
      MI.TelNo := Trim(StringReplace(edtMemberTelNo.Text, '-', '', [rfReplaceAll]));
      MI.CarNo := edtMemberCarNo.Text;
      MI.SexDiv := rdgMemberSexDiv.ItemIndex;
      MI.Birthday := edtMemberBirthday.Text;
      MI.Email := edtMemberEmail.Text;
      MI.ZipNo := edtMemberZipNo.Text;
      MI.Addr := edtMemberAddr.Text;
      MI.Addr2 := edtMemberAddr2.Text;
      MI.SavePoint := Trunc(edtMemberSavePoint.Value);
      MI.MemberMemo := mmoMemberMemo.Text;
      MI.AdAgree := ckbMemberAdAgree.Checked;
      MI.QRCode := edtMemberQRCode.Text;
      MI.FPHash := edtMemberFPHash.Text;
      if MI.MemberName.IsEmpty or
         MI.TelNo.IsEmpty then
        raise Exception.Create('회원명과 전화번호는 필수 입력 항목입니다.');
      if not BPDM.PostMember(DataMode = CO_DATA_MODE_NEW, MI, LResMsg) then
        raise Exception.Create(LResMsg);
      if not BPDM.GetMemberList(LResMsg) then
        BPMsgBox(Self.Handle, mtWarning, '알림', '회원 목록을 조회할 수 없습니다.' + _BR + ErrorString(LResMsg), ['확인'], 5);

      btnRefreshMemberList.Click;
      DataMode := CO_DATA_MODE_VIEW;
      BPMsgBox(Self.Handle, mtInformation, '알림', '회원 정보가 저장되었습니다.', ['확인'], 5);
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', '회원 정보를 저장할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
    end;
  finally
    FWorking := False;
  end;
end;

procedure TBPMemberForm.SetDataMode(const AValue: ShortInt);
begin
  FDataMode := AValue;
  case FDataMode of
    CO_DATA_MODE_LIST,
    CO_DATA_MODE_SELECT:
      begin
        pgcMember.ActivePage := tabMemberList;
        panHeader.Caption := '회원 검색';
        if (FDataMode = CO_DATA_MODE_SELECT) then
          btnGotoAddMember.Enabled := False;
        if not FSearchValue.IsEmpty then
          RefreshDataSet(True, FSearchType, FSearchValue, FSearchType2, FSearchValue2);
        case FBaseGameDiv of
          CO_RATEPLAN_GAME: btnSelectMembership.Caption := '게임제' + _CRLF + '게임상품 선택';
          CO_RATEPLAN_TIME: btnSelectMembership.Caption := '시간제' + _CRLF + '게임상품 선택';
        end;
      end;
    CO_DATA_MODE_VIEW:
      begin
        pgcMember.ActivePage := tabMemberInfo;
        panHeader.Caption := '회원 정보 상세 조회';
        edtMemberName.ReadOnly := True;
        cbxMemberClubSeq.ReadOnly := True;
        edtMemberTelNo.ReadOnly := True;
        edtMemberCarNo.ReadOnly := True;
        cbxMemberDiv.ReadOnly := True;
        cbxMemberGroupCode.ReadOnly := True;
        rdgMemberSexDiv.Enabled := False;
        rdgMemberSexDiv.ItemIndex := 0;
        edtMemberBirthday.ReadOnly := True;
        edtMemberEmail.ReadOnly := True;
        edtMemberZipNo.ReadOnly := True;
        btnMemberZipNo.Enabled := False;
        edtMemberAddr.ReadOnly := True;
        edtMemberAddr2.ReadOnly := True;
        mmoMemberMemo.ReadOnly := True;
        edtMemberSavePoint.ReadOnly := True;
        ckbMemberAdAgree.ReadOnly := True;
        edtMemberQRCode.ReadOnly := True;
        edtMemberFPHash.ReadOnly := True;
        btnPhotoFromFile.Enabled := False;
        btnPhotoFromWebCam.Enabled := False;
        btnPhotoClear.Enabled := False;
        btnSendQRCode.Enabled := True;
        btnPrintQRCode.Enabled := True;
        btnFPHash.Enabled := False;
        btnAddMember.Enabled := True;
        btnEditMember.Enabled := True;
        btnSaveMember.Enabled := False;
      end;
    CO_DATA_MODE_NEW,
    CO_DATA_MODE_EDIT:
      begin
        pgcMember.ActivePage := tabMemberInfo;
        if (FDataMode = CO_DATA_MODE_EDIT) then
        begin
          panHeader.Caption := '회원 정보 수정';
        end
        else
        begin
          panHeader.Caption := '회원 정보 등록';
          ClearMember;
        end;
        edtMemberName.ReadOnly := False;
        cbxMemberClubSeq.ReadOnly := False;
        edtMemberTelNo.ReadOnly := False;
        edtMemberCarNo.ReadOnly := False;
        cbxMemberDiv.ReadOnly := False;
        cbxMemberGroupCode.ReadOnly := False;
        rdgMemberSexDiv.Enabled := True;
        rdgMemberSexDiv.ItemIndex := 0;
        edtMemberBirthday.ReadOnly := False;
        edtMemberEmail.ReadOnly := False;
        edtMemberZipNo.ReadOnly := False;
        btnMemberZipNo.Enabled := True;
        edtMemberAddr.ReadOnly := False;
        edtMemberAddr2.ReadOnly := False;
        mmoMemberMemo.ReadOnly := False;
        edtMemberSavePoint.ReadOnly := False;
        ckbMemberAdAgree.ReadOnly := False;
        edtMemberQRCode.ReadOnly := False;
        edtMemberFPHash.ReadOnly := False;
        btnPhotoFromFile.Enabled := True;
        btnPhotoFromWebCam.Enabled := True;
        btnPhotoClear.Enabled := True;
        btnSendQRCode.Enabled := False;
        btnPrintQRCode.Enabled := False;
        btnFPHash.Enabled := True;
        btnAddMember.Enabled := False;
        btnEditMember.Enabled := False;
        btnSaveMember.Enabled := True;
      end;
  end;
end;

procedure TBPMemberForm.V1DblClick(Sender: TObject);
begin
  if btnSelectMember.Enabled then
    btnSelectMember.Click;
end;

procedure TBPMemberForm.V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if G1.Enabled then
    RefreshDataSet(False);
end;

procedure TBPMemberForm.V2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('use_status').Index] <> CO_STATUS_INUSE) then
    ACanvas.Font.Color := $00544ED6;
end;

procedure TBPMemberForm.V2DblClick(Sender: TObject);
begin
  if btnSelectMembership.Enabled and
     (DataMode = CO_DATA_MODE_SELECT) then
    btnSelectMembership.Click;
end;

procedure TBPMemberForm.V3CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('locker_status').Index] <> CO_LOCKER_INUSE) then
    ACanvas.Font.Color := $00544ED6;
end;

procedure TBPMemberForm.V3DblClick(Sender: TObject);
begin
  if btnSelectLocker.Enabled and
     (DataMode = CO_DATA_MODE_SELECT) then
    btnSelectLocker.Click;
end;

procedure TBPMemberForm.ClearMember;
begin
  edtMemberName.Text := '';
  edtMemberTelNo.Text := '';
  edtMemberCarNo.Text := '';
  cbxMemberDiv.ItemIndex := 0;
  rdgMemberSexDiv.ItemIndex := 0;
  edtMemberBirthday.Text := '';
  edtMemberEmail.Text := '';
  edtMemberZipNo.Text := '';
  edtMemberAddr.Text := '';
  edtMemberAddr2.Text := '';
  mmoMemberMemo.Clear;
  edtMemberQRCode.Text := '';
  edtMemberFPHash.Text := '';
  edtMemberSavePoint.Value := 0;
  ckbMemberAdAgree.Checked := False;
  imgMemberPhoto.Picture := nil;
end;

procedure TBPMemberForm.LoadMember(const AMemberNo: string);
begin
  with BPDM.QRMemberList do
  try
    if (not AMemberNo.IsEmpty) and
       (not Locate('member_no', AMemberNo, [])) then
    begin
      ClearMember;
      raise Exception.Create('회원 목록을 조회할 수 없습니다.');
    end;

    edtMemberName.Text := FieldByName('member_nm').AsString;
    edtMemberNo.Text := FieldByName('member_no').AsString;
    rdgMemberSexDiv.ItemIndex := FieldByName('sex_div').AsInteger;
    cbxMemberClubSeq.Value := FieldByName('club_seq').AsInteger;
    cbxMemberDiv.ItemIndex := Pred(StrToIntDef(FieldByName('member_div').AsString, 0));
    cbxMemberGroupCode.Value := FieldByName('member_group_code').AsString;
    edtMemberCarNo.Text := FieldByName('car_no').AsString;
    edtMemberTelNo.Text := FieldByName('tel_no').AsString;
    edtMemberBirthday.Text := FieldByName('birthday').AsString;
    edtMemberEmail.Text := FieldByName('email').AsString;
    edtMemberZipNo.Text := FieldByName('zipno').AsString;
    edtMemberAddr.Text := FieldByName('addr').AsString;
    edtMemberAddr2.Text := FieldByName('addr2').AsString;
    mmoMemberMemo.Text := FieldByName('member_memo').AsString;
    edtMemberQRCode.Text := FieldByName('qrcd').AsString;
    edtMemberFPHash.Text := FieldByName('fp_hash').AsString;
    edtMemberSavePoint.Value := FieldByName('save_point').AsInteger;
    ckbMemberAdAgree.Checked := FieldByName('ad_agree_yn').AsBoolean;
    imgMemberPhoto.Picture := nil;
    rdgMemberSexDiv.ItemIndex := 0;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TBPMemberForm.SelectedMember(const AMemberNo: string);
begin
  SelectedMember(AMemberNo, '', '', 0, False);
end;
procedure TBPMemberForm.SelectedMember(const AMemberNo, ADCFeeDiv, AProdCode: string; const AMembershipSeq: Integer; const AShoesFree: Boolean);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_SELECT_MEMBER;
    PM.AddParams(CPP_MEMBER_NO, AMemberNo);
    PM.AddParams(CPP_DC_FEE_DIV, ADCFeeDiv);
    PM.AddParams(CPP_PROD_CD, AProdCode);
    PM.AddParams(CPP_MEMBERSHIP_SEQ, AMembershipSeq);
    PM.AddParams(CPP_SHOES_FREE_YN, AShoesFree);
    PM.PluginMessageToID(FOwnerId);
    Self.ModalResult := mrOK;
  finally
    FreeAndNil(PM);
  end;
end;

procedure TBPMemberForm.RefreshDataSet(const AFullRefresh: Boolean; const ASearchType: ShortInt; ASearchValue: string);
begin
  RefreshDataSet(AFullRefresh, ASearchType, ASearchValue, CO_SEARCH_NONE, '');
end;
procedure TBPMemberForm.RefreshDataSet(const AFullRefresh: Boolean; const ASearchType: ShortInt; ASearchValue: string; const ASearchType2: ShortInt; ASearchValue2: string);
var
  LMemberNo, LFieldName, LFieldName2, LResMsg: string;
begin
  try
    if AFullRefresh then
    begin
      case ASearchType of
        CO_SEARCH_MEMBER_NO:
          LFieldName := 'member_no';
        CO_SEARCH_MEMBER_NAME:
          LFieldName := 'member_nm';
        CO_SEARCH_TEL_NO:
          LFieldName := 'tel_no';
        CO_SEARCH_CAR_NO:
          LFieldName := 'car_no';
        else
          LFieldName := '';
      end;
      case ASearchType2 of
        CO_SEARCH_MEMBER_NO:
          LFieldName2 := 'member_no';
        CO_SEARCH_MEMBER_NAME:
          LFieldName2 := 'member_nm';
        CO_SEARCH_TEL_NO:
          LFieldName2 := 'tel_no';
        CO_SEARCH_CAR_NO:
          LFieldName := 'car_no';
        else
          LFieldName2 := '';
      end;

      if not BPDM.RefreshMemberList(LFieldName, ASearchValue, LFieldName2, ASearchValue2, LResMsg) then
        raise Exception.Create(LResMsg);
    end;

    LMemberNo := '';
    if (V1.DataController.RecordCount > 0) then
      LMemberNo := V1.DataController.DataSet.FieldByName('member_no').AsString;
    if not BPDM.GetMembership(LMemberNo, '', '', LResMsg) then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '회원 목록을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPMemberForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
