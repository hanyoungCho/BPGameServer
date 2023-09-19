(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 판매 관리 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPSalePOS.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Data.DB, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.Buttons, Vcl.ComCtrls, Vcl.Graphics,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh,
  { DevExpress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxLabel, cxCurrencyEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid, cxCheckBox,
  cxGridDBTableView,
  { Absolute Database }
  ABSMain,
  { Project }
  Common.BPGlobal, System.Actions, Vcl.ActnList;

{$I ..\..\common\Common.BPCommon.inc}

const
  LCN_SALE_GROUP_INDEX: Integer = 100;
  LCN_LANE_GROUP_INDEX: Integer = 200;
  LCN_PLU_GROUP_INDEX: Integer  = 300;
  LCN_PLU_GROUP_COUNT: Integer  = 4;
  LCN_PLU_ITEM_COUNT: Integer   = 24;
  LCN_PLU_INTERVAL: Integer     = 5;
  LCN_PLU_HEIGHT: Integer       = 87;
  LCN_PLU_WIDTH: Integer        = 198;
  LCN_PLU_ARROW_WIDTH: Integer  = 97;

type
  TReceiptListItem = class
  private
    FAssignIndex: ShortInt;
    FReceiptNo: string;
  public
    property AssignIndex: ShortInt read FAssignIndex write FAssignIndex;
    property ReceiptNo: string read FReceiptNo write FReceiptNo;
  end;

  TPluContainer = class(TPanel)
    ProdNameLabel: TLabel;
    ProdInfoLabel: TLabel;
    ProdAmtLabel: TLabel;
  private
    FActive: Boolean;
    FProdDiv: string;
    FProdDetailDiv: string;
    FProdCode: string;
    FProdName: string;
    FProdInfo: string;
    FProdAmt: Integer;

    procedure SetActive(const AValue: Boolean);
    procedure SetProdInfo(const AValue: string);
    procedure SetProdName(const AValue: string);
    procedure SetProdAmt(const AValue: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Active: Boolean read FActive write SetActive default False;
    property ProdDiv: string read FProdDiv write FProdDiv;
    property ProdDetailDiv: string read FProdDetailDiv write FProdDetailDiv;
    property ProdCode: string read FProdCode write FProdCode;
    property ProdName: string read FProdName write SetProdName;
    property ProdInfo: string read FProdInfo write SetProdInfo;
    property ProdAmt: Integer read FProdAmt write SetProdAmt;
  end;

  TBPSalePosForm = class(TPluginModule)
    panRight: TPanel;
    panLeft: TPanel;
    tmrRunOnce: TTimer;
    panSaleControl: TPanel;
    panItemMenu: TPanel;
    panSideMenu: TPanel;
    panNumpad: TPanel;
    panFooter: TPanel;
    panCategory: TPanel;
    panPluList: TPanel;
    TemplatePluPanel: TPanel;
    panPaymentResult: TPanel;
    panSaleNumPad: TPanel;
    btnSaleComplete: TBitBtn;
    btnPaymentCard: TBitBtn;
    btnPaymentCash: TBitBtn;
    btnPaymentPayco: TBitBtn;
    btnPaymentVoucher: TBitBtn;
    btnPaymentAffiliate: TBitBtn;
    btnShowLaneList: TBitBtn;
    btnPendingList: TBitBtn;
    btnFacility: TBitBtn;
    btnSearchProd: TBitBtn;
    btnShowLockerList: TBitBtn;
    btnShowReceiptList: TBitBtn;
    btnSpare: TBitBtn;
    btnItemClear: TBitBtn;
    btnItemIncQty: TBitBtn;
    btnItemDecQty: TBitBtn;
    btnItemChangeQty: TBitBtn;
    btnItemDiscount: TBitBtn;
    btnItemSpare1: TBitBtn;
    btnItemService: TBitBtn;
    btnItemDiscountPercent: TBitBtn;
    btnNum7: TBitBtn;
    btnNum8: TBitBtn;
    btnNum9: TBitBtn;
    btnNum4: TBitBtn;
    btnNum5: TBitBtn;
    btnNum6: TBitBtn;
    btnNum1: TBitBtn;
    btnNum2: TBitBtn;
    btnNum3: TBitBtn;
    btnNum0: TBitBtn;
    btnNum0x2: TBitBtn;
    btnNum0x3: TBitBtn;
    btnNumBack: TBitBtn;
    btnOpenDrawer: TBitBtn;
    edtVATTotal: TLabeledEdit;
    edtDCTotal: TLabeledEdit;
    edtKeepAmtTotal: TLabeledEdit;
    edtReceiveTotal: TLabeledEdit;
    edtUnpaidTotal: TLabeledEdit;
    edtChangeTotal: TLabeledEdit;
    btnPluGroup1: TSpeedButton;
    btnPluGroup2: TSpeedButton;
    btnPluGroup3: TSpeedButton;
    btnPluGroup4: TSpeedButton;
    btnNumClear: TBitBtn;
    TemplateProdAmtLabel: TLabel;
    TemplateProdInfoLabel: TLabel;
    TemplateProdNameLabel: TLabel;
    btnAddPending: TBitBtn;
    panPluGroupPrev: TPanel;
    panPluGroupNext: TPanel;
    panPluListPrev: TPanel;
    panPluListNext: TPanel;
    lblPluGroupPrev: TLabel;
    lblPluGroupNext: TLabel;
    lblPluListPrev: TLabel;
    lblPluListNext: TLabel;
    pgcSaleDetail: TPageControl;
    tabPayment: TTabSheet;
    tabCoupon: TTabSheet;
    panCouponSideBar: TPanel;
    btnCouponNoInput: TBitBtn;
    btnCouponCancel: TBitBtn;
    btnCouponRefresh: TBitBtn;
    shpCategorySeparator: TShape;
    panBase: TPanel;
    panPaymentSideBar: TPanel;
    btnPaymentCancel: TBitBtn;
    panMemberInfo: TPanel;
    panMemberSidebar: TPanel;
    btnAddMember: TBitBtn;
    btnSearchMember: TBitBtn;
    panInputValue: TPanel;
    lblInputValue: TLabel;
    panMemberPhoto: TPanel;
    imgMemberPhoto: TImage;
    dsrSaleItem: TDataSource;
    panSaleGroup: TPanel;
    btnGeneralLane: TSpeedButton;
    btnSelectedLane: TSpeedButton;
    shpLaneGroupSeparator: TShape;
    btnItemSpare2: TBitBtn;
    btnItemUsePoint: TBitBtn;
    mmoMemberMemo: TDBMemoEh;
    panSaleMemo: TPanel;
    mmoSaleMemo: TDBMemoEh;
    edtMemberName: TDBEditEh;
    edtMemberNo: TDBEditEh;
    edtMemberSexDivName: TDBEditEh;
    edtMemberTelNo: TDBEditEh;
    edtMemberCarNo: TDBEditEh;
    edtMemberSavePoint: TDBNumberEditEh;
    edtSaleTotal: TLabeledEdit;
    edtChargeTotal: TLabeledEdit;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V1lane_no: TcxGridDBBandedColumn;
    V1prod_nm: TcxGridDBBandedColumn;
    V1prod_amt: TcxGridDBBandedColumn;
    V1order_qty: TcxGridDBBandedColumn;
    V1calc_sale_amt: TcxGridDBBandedColumn;
    V1dc_amt: TcxGridDBBandedColumn;
    V1service_yn: TcxGridDBBandedColumn;
    V1calc_charge_amt: TcxGridDBBandedColumn;
    V1calc_vat: TcxGridDBBandedColumn;
    L1: TcxGridLevel;
    sbxSelectedLaneList: TScrollBox;
    edtMemberDivName: TDBEditEh;
    edtMemberClubName: TDBEditEh;
    V1prod_div: TcxGridDBBandedColumn;
    V1assign_no: TcxGridDBBandedColumn;
    V1prod_cd: TcxGridDBBandedColumn;
    V1prod_detail_div: TcxGridDBBandedColumn;
    V1assign_lane_no: TcxGridDBBandedColumn;
    V1keep_amt: TcxGridDBBandedColumn;
    V1bowler_id: TcxGridDBBandedColumn;
    V1locker_no: TcxGridDBBandedColumn;
    V1locker_nm: TcxGridDBBandedColumn;
    V1purchase_month: TcxGridDBBandedColumn;
    V1start_dt: TcxGridDBBandedColumn;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    L2: TcxGridLevel;
    V2calc_pay_method: TcxGridDBBandedColumn;
    V2card_no: TcxGridDBBandedColumn;
    V2approve_no: TcxGridDBBandedColumn;
    V2issuer_nm: TcxGridDBBandedColumn;
    V2buyer_nm: TcxGridDBBandedColumn;
    V2approve_amt: TcxGridDBBandedColumn;
    V2calc_cancel_count: TcxGridDBBandedColumn;
    G3: TcxGrid;
    V3: TcxGridDBBandedTableView;
    V3coupon_nm: TcxGridDBBandedColumn;
    V3calc_prod_div: TcxGridDBBandedColumn;
    V3game_prod_div: TcxGridDBBandedColumn;
    V3calc_dc_div: TcxGridDBBandedColumn;
    V3coupon_amt: TcxGridDBBandedColumn;
    V3apply_dc_amt: TcxGridDBBandedColumn;
    L3: TcxGridLevel;
    dsrPayment: TDataSource;
    dsrCoupon: TDataSource;
    edtMemberLockerList: TDBEditEh;
    edtMemberLockerExpireDate: TDBEditEh;
    edtMemberGroupName: TDBEditEh;
    V1member_no: TcxGridDBBandedColumn;
    edtSaleLockerNo: TDBEditEh;
    edtSalePurchaseMonth: TDBNumberEditEh;
    edtSaleUseStartDate: TDBEditEh;
    edtSaleMemberName: TDBEditEh;
    V1seq: TcxGridDBBandedColumn;
    btnClearMember: TBitBtn;
    V1assign_index_nm: TcxGridDBBandedColumn;
    dsrReceipt: TDataSource;
    btnItemSelectAll: TBitBtn;
    btnItemDiscountCancel: TBitBtn;
    btnItemClearSelect: TBitBtn;
    panReceiptList: TPanel;
    lblReceiptListTitle: TLabel;
    cbxReceiptNoList: TComboBox;
    V1use_point: TcxGridDBBandedColumn;
    edtUsePointTotal: TLabeledEdit;

    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleResize(Sender: TObject);

    procedure OnPluItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnPluItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnLeftRightMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnLeftRightMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnPluGroupButtonClick(Sender: TObject);
    procedure OnPluItemButtonClick(Sender: TObject);

    procedure tmrRunOnceTimer(Sender: TObject);
    procedure lblPluGroupPrevClick(Sender: TObject);
    procedure lblPluGroupNextClick(Sender: TObject);
    procedure lblPluListPrevClick(Sender: TObject);
    procedure lblPluListNextClick(Sender: TObject);

    procedure btnAddMemberClick(Sender: TObject);
    procedure btnAddPendingClick(Sender: TObject);
    procedure btnClearMemberClick(Sender: TObject);
    procedure btnCouponCancelClick(Sender: TObject);
    procedure btnCouponNoInputClick(Sender: TObject);
    procedure btnCouponRefreshClick(Sender: TObject);
    procedure btnFacilityClick(Sender: TObject);
    procedure btnGeneralLaneClick(Sender: TObject);
    procedure btnItemChangeQtyClick(Sender: TObject);
    procedure btnItemClearClick(Sender: TObject);
    procedure btnItemDecQtyClick(Sender: TObject);
    procedure btnItemDiscountCancelClick(Sender: TObject);
    procedure btnItemDiscountClick(Sender: TObject);
    procedure btnItemDiscountPercentClick(Sender: TObject);
    procedure btnItemIncQtyClick(Sender: TObject);
    procedure btnItemServiceClick(Sender: TObject);
    procedure btnNumBackClick(Sender: TObject);
    procedure btnNumClearClick(Sender: TObject);
    procedure btnNumPadClick(Sender: TObject);
    procedure btnOpenDrawerClick(Sender: TObject);
    procedure btnPaymentAffiliateClick(Sender: TObject);
    procedure btnPaymentCancelClick(Sender: TObject);
    procedure btnPaymentCardClick(Sender: TObject);
    procedure btnPaymentCashClick(Sender: TObject);
    procedure btnPaymentPaycoClick(Sender: TObject);
    procedure btnPaymentVoucherClick(Sender: TObject);
    procedure btnPendingListClick(Sender: TObject);
    procedure btnSaleCompleteClick(Sender: TObject);
    procedure btnSearchMemberClick(Sender: TObject);
    procedure btnSearchProdClick(Sender: TObject);
    procedure btnSelectedLaneClick(Sender: TObject);
    procedure btnShowLaneListClick(Sender: TObject);
    procedure btnShowLockerListClick(Sender: TObject);
    procedure btnShowReceiptListClick(Sender: TObject);
    procedure btnItemSelectAllClick(Sender: TObject);
    procedure btnItemClearSelectClick(Sender: TObject);
    procedure btnItemUsePointClick(Sender: TObject);
    procedure edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtMemberTelNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure V1Bands0HeaderClick(Sender: TObject);
    procedure V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V1DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure V2DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure V3DataControllerSummaryAfterSummary(ASender: TcxDataSummary);

    procedure OnReceiptNoListChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FPluginVersion: string;
    FWorking: Boolean;
    FBaseTitle: string;
    FSelectedLaneButtons: TArray<TSpeedButton>;
    FPluGroup: TArray<TSpeedButton>;
    FPluItems: TArray<TPluContainer>;
    FInputBuffer: string;
    FLaneSelected: Boolean;
    FSelectedAmt: Integer;

    //회원 상품 구매시 사용
    FSelectedMemberNo: string;
    FSelectedMemberName: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DrawPluItems;
    procedure ResizeControl;
    procedure RefreshSelectedLaneGroup;
    procedure RefreshAll(const ADetailOnly: Boolean=False);
    procedure RefreshSaleData(const AReceiptNo: string; const AProdCode: string='');
    procedure RefreshPayment;
    function RefreshReceiptNoList(var AResMsg: string): Boolean;
    procedure RefreshSaleSummary;
    procedure AddSaleItem(const AIndex: ShortInt);
    procedure DeleteSaleItem(const ASeq: Integer; const AProdCode: string);
    procedure AdjustSaleItem(const ASeq: Integer; const AProdCode: string; const AOrderQty, AAdjustQty: Integer);
    procedure DiscountSaleItem(const ASeq: Integer; const AProdCode: string; const AValue: Integer);
    procedure ServiceSaleItem(const ASeq: Integer; const AProdCode: string; const AServiceYN: Boolean);
    procedure UsePointSaleItem;
    function CheckDeleteReceipt(const AReceiptNo: string): Boolean;

    function SelectLocker(var AResMsg: string): Boolean;

    procedure ClearMemberInfo;
    procedure DispMemberInfo;
//    procedure ClearSaleItem;
    procedure DispSaleResult;
    procedure DoSaleComplete;
    procedure DoCancelPayment;
    procedure UpdatePaymentSeq;

    procedure PluGroupChangeCallBack(const AGroupIndex: Integer);
    procedure PluItemPageChangeCallback(const AGroupIndex, AItemPageIndex: Integer);

    procedure OnSelectedLaneGroupButtonClick(Sender: TObject);

    procedure SetPluGroupPrev(const AValue: Boolean);
    procedure SetPluGroupNext(const AValue: Boolean);
    procedure SetPluListPrev(const AValue: Boolean);
    procedure SetPluListNext(const AValue: Boolean);
    procedure SetInputBuffer(const AValue: string);
    procedure SetLaneSelected(const AValue: Boolean);
    procedure SetBaseTitle(const AValue: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property PluGroupPrev: Boolean write SetPluGroupPrev default False;
    property PluGroupNext: Boolean write SetPluGroupNext default False;
    property PluListPrev: Boolean write SetPluListPrev default False;
    property PluListNext: Boolean write SetPluListNext default False;

    property InputBuffer: string read FInputBuffer write SetInputBuffer;
    property LaneSelected: Boolean read FLaneSelected write SetLaneSelected default False;
    property BaseTitle: string read FBaseTitle write SetBaseTitle;
  end;

implementation

uses
  { Native }
  Vcl.Dialogs, System.Variants, System.Math, System.StrUtils,
  { DevExpress }
  dxCore,
  { Project }
  Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, Common.BPComUtils, BPInputStartDate;

var
  FHotKeyId: Integer;

{$R *.dfm}

{ TBPSalePosForm }

constructor TBPSalePosForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  I: Integer;
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  FOwnerID := 0;
  FHotKeyId := 0;
  FPluginVersion := GetModuleVersion(GetModuleName(HInstance));
  FBaseTitle := '판매 관리';
  FInputBuffer := '';
  FLaneSelected := False;
  FSelectedAmt := 0;
  FSelectedMemberNo := '';
  FSelectedMemberName := '';
  FWorking := False;
  Global.ReceiptInfo.SelectedReceiptNo := '';

  Self.Caption := FBaseTitle;
  panBase.Height := Self.Height;
  panBase.Width := Self.Width;
  panPluGroupPrev.Width := LCN_PLU_ARROW_WIDTH;
  panPluGroupNext.Width := LCN_PLU_ARROW_WIDTH;
  panPluListPrev.Width := LCN_PLU_ARROW_WIDTH;
  panPluListNext.Width := LCN_PLU_ARROW_WIDTH;
  panPluListPrev.Height := LCN_PLU_HEIGHT;
  panPluListNext.Height := LCN_PLU_HEIGHT;
  panPluListPrev.Left := (4 * LCN_PLU_WIDTH) + (4 * LCN_PLU_INTERVAL);
  panPluListNext.Left := panPluListPrev.Left + panPluListPrev.Width + panPluGroupNext.Margins.Left;
  panPluListPrev.Top := (4 * LCN_PLU_HEIGHT) + (4 * LCN_PLU_INTERVAL) + LCN_PLU_INTERVAL;
  panPluListNext.Top := panPluListPrev.Top;

  tabCoupon.TabVisible := False; //추후 개발
  pgcSaleDetail.ActivePageIndex := 0;

  cbxReceiptNoList.OnChange := nil;
  btnGeneralLane.GroupIndex := LCN_SALE_GROUP_INDEX;
  btnSelectedLane.GroupIndex := LCN_SALE_GROUP_INDEX;
  sbxSelectedLaneList.Visible := False;
  sbxSelectedLaneList.DoubleBuffered := True;
  SetLength(FSelectedLaneButtons, Global.LaneInfo.LaneCount);
  for I := 0 to Pred(Global.LaneInfo.LaneCount) do
  begin
    FSelectedLaneButtons[I] := TSpeedButton.Create(nil);
    with FSelectedLaneButtons[I] do
    begin
      Align := alLeft;
      AlignWithMargins := True;
      Caption := '';
      Font.Name := 'Pretendard Variable';
      Font.Size := 14;
      Font.Style := [];
      GroupIndex := LCN_LANE_GROUP_INDEX;
      Margins.Bottom := 3;
      Margins.Left := 0;
      Margins.Right := 3;
      Margins.Bottom := 3;
      Parent := sbxSelectedLaneList;
      ParentFont := False;
      Tag := I;
      Visible := False;
      Width := 30;
      OnClick := OnSelectedLaneGroupButtonClick;
    end;
  end;

  with Global.PluManager do
  begin
    GroupPerPage := LCN_PLU_GROUP_COUNT;
    ItemPerPage := LCN_PLU_ITEM_COUNT;
  end;
  SetLength(FPluGroup, LCN_PLU_GROUP_COUNT);
  SetLength(FPluItems, LCN_PLU_ITEM_COUNT);
  for I := 0 to Pred(LCN_PLU_GROUP_COUNT) do
  begin
    FPluGroup[I] := TSpeedButton(FindComponent('btnPluGroup' + IntToStr(I + 1)));
    with FPluGroup[I] do
    begin
      Tag := I;
      GroupIndex := LCN_PLU_GROUP_INDEX;
      Caption := '';
      Width := LCN_PLU_WIDTH;
      OnClick := OnPluGroupButtonClick;
    end;
  end;

  DrawPluItems;
  if Global.Config.DarkMode then
  begin
    shpLaneGroupSeparator.Brush.Color := $007A625D;
    shpLaneGroupSeparator.Pen.Color := $007A625D;
    shpCategorySeparator.Brush.Color := $007A625D;
    shpCategorySeparator.Pen.Color := $007A625D;
    lblPluGroupPrev.Color := $007A625D;
    lblPluGroupNext.Color := $007A625D;
    lblPluListPrev.Color := $007A625D;
    lblPluListNext.Color := $007A625D;
  end
  else
  begin
    shpLaneGroupSeparator.Brush.Color := $00E6DBCF;
    shpLaneGroupSeparator.Pen.Color := $00E6DBCF;
    shpCategorySeparator.Brush.Color := $00E6DBCF;
    shpCategorySeparator.Pen.Color := $00E6DBCF;
    lblPluGroupPrev.Color := $00E6DBCF;
    lblPluGroupNext.Color := $00E6DBCF;
    lblPluListPrev.Color := $00E6DBCF;
    lblPluListNext.Color := $00E6DBCF;
  end;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  UpdateLog(Format('SalePOS.DoubleBuffered = %s', [BoolToStr(Self.DoubleBuffered, True)]));
  tmrRunOnce.Enabled := True;
end;

destructor TBPSalePosForm.Destroy;
begin
  Global.Plugin.SalePosPluginId := 0;

  inherited Destroy;
end;

procedure TBPSalePosForm.PluginModuleShow(Sender: TObject);
begin
  Global.Plugin.ActivePluginId := Self.PluginID;
  cbxReceiptNoList.SetFocus;
end;

procedure TBPSalePosForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
    FSelectedLaneButtons[I].Free;
  Action := caFree;
end;

procedure TBPSalePosForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnShowLaneList.Click;
    VK_F10:
      if (ssCtrl in Shift) then
        btnSearchMember.Click;
  end;
end;

procedure TBPSalePosForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPSalePosForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_SALE_POS);
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
    BaseTitle := FBaseTitle;
  end
  else if (AMsg.Command = CPC_ACTIVE) then
  begin
    if (Global.LaneInfo.SelectedLanes.Count > 0) then
      btnSelectedLane.Click
    else
      btnGeneralLane.Click;

    if (Self.Align = alClient) then
      Self.BringToFront
    else
      SetForegroundWindow(Self.Handle);

    BaseTitle := FBaseTitle;
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_SALE_POS);
  end
  else if (AMsg.Command = CPC_RECEIPT_NO_LIST) then
  begin
    var LResMsg: string;
    if not RefreshReceiptNoList(LResMsg) then
      BPMsgBox(Self.Handle, mtError, '알림', '영수증 번호를 조회할 수 없습니다.' + _BR + ErrorString(LResMsg), ['확인'], 5);
  end
  else if (AMsg.Command = CPC_SELECT_MEMBER) then
  begin
    if BPDM.FindMemberInfo(AMsg.ParamByString(CPP_MEMBER_NO)) then
    begin
      FSelectedMemberNo := Global.MemberInfo.MemberNo;
      FSelectedMemberName := Global.MemberInfo.MemberName;
    end;
    DispMemberInfo;
  end
  else if (AMsg.Command = CPC_CLOSE) then
    Self.Close
  else if (AMsg.Command = CPC_RESIZE) then
    ResizeControl;
end;

procedure TBPSalePosForm.PluginModuleResize(Sender: TObject);
begin
  ResizeControl;
end;

procedure TBPSalePosForm.SetPluGroupPrev(const AValue: Boolean);
begin
  lblPluGroupPrev.Enabled := AValue;
end;

procedure TBPSalePosForm.SetPluGroupNext(const AValue: Boolean);
begin
  lblPluGroupNext.Enabled := AValue;
end;

procedure TBPSalePosForm.SetPluListPrev(const AValue: Boolean);
begin
  lblPluListPrev.Enabled := AValue;
end;

procedure TBPSalePosForm.SetPluListNext(const AValue: Boolean);
begin
  lblPluListNext.Enabled := AValue;
end;

procedure TBPSalePosForm.SetInputBuffer(const AValue: string);
begin
  if (AValue.Length > 9) then
    Exit;
  FInputBuffer := IntToStr(StrToIntDef(AValue, 0));
  lblInputValue.Caption := FormatCurr('#,##0', StrToCurrDef(FInputBuffer, 0));
end;

procedure TBPSalePosForm.SetLaneSelected(const AValue: Boolean);
begin
  FLaneSelected := AValue;
  ClearMemberInfo;
  btnSelectedLane.Enabled := (Global.LaneInfo.SelectedLanes.Count > 0);
  sbxSelectedLaneList.Visible := (Global.LaneInfo.SelectedLanes.Count > 0);
  if FLaneSelected and
     (Global.LaneInfo.SelectedLanes.Count > 0) then
  begin
    btnSelectedLane.Down := True;
    for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
      if FSelectedLaneButtons[I].Down then
      begin
        Global.LaneInfo.SelectedLaneNo := FSelectedLaneButtons[I].Tag;
        BaseTitle := Format('%s [%d 레인]', [Self.Caption, Global.LaneInfo.SelectedLaneNo]);
        Break;
      end;
    RefreshSelectedLaneGroup;
  end
  else
  begin
    btnGeneralLane.Down := True;
    Global.LaneInfo.SelectedLaneNo := 0;
    BaseTitle := Format('%s [일반 판매]', [Self.Caption]);
  end;
  RefreshAll;
end;

procedure TBPSalePosForm.SetBaseTitle(const AValue: string);
begin
  FBaseTitle := AValue;
  Global.Title := FBaseTitle;
end;

procedure TBPSalePosForm.DrawPluItems;
var
  LTop, LLeft, LRow, LCol: Integer;
begin
  LRow := 0;
  LCol := 0;
  for var I: Integer := 0 to Pred(LCN_PLU_ITEM_COUNT) do
  begin
    if (LCol > 4) then
    begin
      LCol := 0;
      Inc(LRow);
    end;

    LTop := (LRow * LCN_PLU_HEIGHT) + (LRow * LCN_PLU_INTERVAL) + LCN_PLU_INTERVAL;
    LLeft := (LCol * LCN_PLU_WIDTH) + (LCol * LCN_PLU_INTERVAL);
    FPluItems[I] := TPluContainer.Create(nil);
    with FPluItems[I] do
    begin
      Parent := panPluList;
      Tag := I;
      Top := LTop;
      Left := LLeft;
      Height := LCN_PLU_HEIGHT;
      Width := LCN_PLU_WIDTH;
      ProdNameLabel.Tag := I;
      ProdNameLabel.OnClick := OnPluItemButtonClick;
      ProdNameLabel.OnMouseDown := OnPluItemMouseDown;
      ProdNameLabel.OnMouseUp := OnPluItemMouseUp;
      ProdInfoLabel.Tag := I;
      ProdInfoLabel.OnClick := OnPluItemButtonClick;
      ProdInfoLabel.OnMouseDown := OnPluItemMouseDown;
      ProdInfoLabel.OnMouseUp := OnPluItemMouseUp;
      ProdAmtLabel.Tag := I;
      ProdAmtLabel.OnClick := OnPluItemButtonClick;
      ProdAmtLabel.OnMouseDown := OnPluItemMouseDown;
      ProdAmtLabel.OnMouseUp := OnPluItemMouseUp;
      Visible := False;
    end;
    Inc(LCol);
  end;
end;

procedure TBPSalePosForm.ResizeControl;
begin
  if not Global.MainMenuResizing then
    panBase.Left := (Self.Width div 2) - (panBase.Width div 2);
end;

procedure TBPSalePosForm.RefreshSaleData(const AReceiptNo, AProdCode: string);
var
  LResMsg: string;
begin
  try
    try
      if not BPDM.RefreshSaleItem(AReceiptNo, LResMsg) then
        raise Exception.Create(LResMsg);
      if not AProdCode.IsEmpty then
        BPDM.QRSaleItem.Locate('receipt_no;prod_cd', VarArrayOf([AReceiptNo, AProdCode]), []);
    finally
      SendToMainForm(CPC_GAME_REFRESH_FORCE, Global.LaneInfo.SelectedLaneNo);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '주문 상품 내역을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.RefreshPayment;
var
  LResMsg: string;
begin
  try
    if not BPDM.RefreshPayment(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '결제 내역을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.RefreshAll(const ADetailOnly: Boolean);
begin
  SendToMainForm(CPC_SALE_REFRESH_ALL, ADetailOnly);
end;

function TBPSalePosForm.RefreshReceiptNoList(var AResMsg: string): Boolean;
var
  RI: TReceiptListItem;
  LIndex: ShortInt;
begin
  Result := False;
  AResMsg := '';
  with cbxReceiptNoList do
  try
    OnChange := nil;
    Items.BeginUpdate;
    try
      for var I := 0 to Pred(Items.Count) do
        if Assigned(Items.Objects[I]) then
          Items.Objects[I].Free;
      Items.Clear;
      Text := '';
      LIndex := 0;
      Global.ReceiptInfo.SelectedReceiptNo := '';
      with TABSQuery.Create(nil) do
      try
        DatabaseName := BPDM.LocalDB.DatabaseName;
        SQL.Add('SELECT A.receipt_no FROM TBReceipt A');
        SQL.Add(Format('WHERE A.assign_lane_no = %d', [Global.LaneInfo.SelectedLaneNo]));
        SQL.Add('ORDER BY A.receipt_no;');
        Open;
        First;
        while not Eof do
        begin
          Inc(LIndex);
          RI := TReceiptListItem.Create;
          RI.AssignIndex := LIndex;
          RI.ReceiptNo := FieldByName('receipt_no').AsString;
          Items.AddObject(Format('%s', [RI.ReceiptNo.Substring(14)]), TObject(RI));
          Next;
        end;
        if (Items.Count > 0) then
        begin
          ItemIndex := 0;
          Global.ReceiptInfo.SelectedReceiptNo := TReceiptListItem(Items.Objects[ItemIndex]).ReceiptNo;
        end;
{$IFDEF DEBUG}
        UpdateLog(Format('RefreshReceiptNoList(LaneNo: %d).RecordCount = %d', [Global.LaneInfo.SelectedLaneNo, RecordCount]));
{$ENDIF}
        Result := True;
      finally
        Close;
        Free;
      end;
    except
      on E: Exception do
      begin
        AResMsg := E.Message;
        UpdateLog(Format('RefreshReceiptNoList(LaneNo: %d).Exception = %s', [Global.LaneInfo.SelectedLaneNo, E.Message]));
      end;
    end;
  finally
    Items.EndUpdate;
    OnChange := OnReceiptNoListChange;
  end;
end;

procedure TBPSalePosForm.RefreshSaleSummary;
begin
  with V1.DataController.Summary do
  begin
    Global.ReceiptInfo.SaleAmt := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1calc_sale_amt)]), 0);
    Global.ReceiptInfo.DCAmt := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1dc_amt)]), 0);
    Global.ReceiptInfo.ChargeAmt := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1calc_charge_amt)]), 0);
    Global.ReceiptInfo.UsePoint := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V1use_point)]), 0);
  end;
end;

procedure TBPSalePosForm.AddSaleItem(const AIndex: ShortInt);
var
  PI: TProdItemRec;
  LAssignLaneNo: ShortInt;
  LAssignNo, LResMsg: string;
begin
  try
    LAssignLaneNo := Global.LaneInfo.AssignLaneNo(Global.LaneInfo.SelectedLaneNo);
    LAssignNo := Global.LaneInfo.Lanes[Global.LaneInfo.LaneIndex(Global.LaneInfo.SelectedLaneNo)].Container.AssignNo;
    if (LAssignLaneNo < 0) then
      raise Exception.Create(Format('%d(%d)는 사용할 수 없는 레인 번호입니다.', [LAssignLaneNo, Global.LaneInfo.SelectedLaneNo]));
    //게임회원권과 라커 상품은 회원 선택 필수
    if ((FPluItems[AIndex].ProdDiv = CO_PROD_MEMBERSHIP) or (FPluItems[AIndex].ProdDiv = CO_PROD_LOCKER)) and
       FSelectedMemberNo.IsEmpty and
       (ShowMemberPopup(Self.PluginID, '', 0, CO_DATA_MODE_SELECT, CO_SEARCH_MEMBER_NAME, edtMemberName.Text, CO_SEARCH_TEL_NO, edtMemberTelNo.Text) <> mrOK) then
      raise Exception.Create('회원 전용 상품입니다.' + _BR + '판매할 대상 회원을 먼저 선택하여 주십시오.');

    PI.Clear;
    PI.AssignLaneNo := LAssignLaneNo;
    PI.AssignNo := LAssignNo;
    PI.ProdDiv := FPluItems[AIndex].ProdDiv;
    PI.ProdDetailDiv := FPluItems[AIndex].ProdDetailDiv;
    PI.ProdCode := FPluItems[AIndex].ProdCode;
    PI.ProdName := FPluItems[AIndex].ProdName;
    PI.ProdAmt := FPluItems[AIndex].ProdAmt;
    PI.OrderQty := 1;
    PI.MemberNo := FSelectedMemberNo;
    PI.MemberName := FSelectedMemberName;

    //게임회원권
    if (PI.ProdDiv = CO_PROD_GAME) then
    begin
      with TBPInputStartDateForm.Create(nil) do
      try
        ProdName := PI.ProdName;
        if (ShowModal <> mrOK) then
          raise Exception.Create('이용 시작일이 입력되어야 합니다.');
        PI.UseStartDate := FormatDateTime('yyyy-mm-dd', SelectedDate);
      finally
        Free;
      end;
    end
    //라커 상품
    else if (PI.ProdDiv = CO_PROD_LOCKER) then
    begin
      PI.LockerNo := 0;
      PI.LockerName := '';
      PI.PurchaseMonth := 0;
      PI.UseStartDate := '';
      PI.KeepAmt := 0;
      if (PI.ProdDetailDiv = CO_PROD_DETAIL_LOCKER) then
      begin
        if not SelectLocker(LResMsg) then
          raise Exception.Create(LResMsg);
        PI.LockerNo := Global.MemberInfo.SelectLockerNo;
        PI.LockerName := Global.MemberInfo.SelectLockerName;
        PI.PurchaseMonth := Global.MemberInfo.PurchaseMonth;
        PI.UseStartDate := Global.MemberInfo.UseStartDate;
        PI.OrderQty := PI.PurchaseMonth; //라커 상품은 이용 개월수가 상품 구매수량임(200230725)
      end
      else if (PI.ProdDetailDiv = CO_PROD_DETAIL_KEEPAMT) then
        PI.KeepAmt := FPluItems[AIndex].ProdAmt;
    end;
    V1.Controller.ClearSelection;
    //상품 주문 내역에 추가
    if not BPDM.UpdateSaleItem(Global.ReceiptInfo.SelectedReceiptNo, PI, LResMsg) then
      raise Exception.Create(LResMsg);
    RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo, PI.ProdCode);
    if not RefreshReceiptNoList(LResMsg) then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '주문 상품 등록에 실패하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.DeleteSaleItem(const ASeq: Integer; const AProdCode: string);
var
  LResMsg: string;
begin
  try
    if not BPDM.DeleteABSRecord('TBSaleItem', Format('seq = %d', [ASeq]), True, LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.UpdateReceipt(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
      raise Exception.Create(LResMsg);
    if CheckDeleteReceipt(Global.ReceiptInfo.SelectedReceiptNo) then
      RefreshAll
    else
      RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo, AProdCode);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '주문 상품을 삭제할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.AdjustSaleItem(const ASeq: Integer; const AProdCode: string; const AOrderQty, AAdjustQty: Integer);
var
  LSQL, LResMsg, LProdCode: string;
begin
  try
    LProdCode := '';
    if (AAdjustQty < 1) and
       (AOrderQty = 1) then
    begin
      if not BPDM.DeleteABSRecord('TBSaleItem', Format('seq = %d', [ASeq]), True, LResMsg) then
        raise Exception.Create(LResMsg);
    end
    else
    begin
      LProdCode := AProdCode;
      LSQL := 'UPDATE TBSaleItem SET order_qty = ';
      if (AOrderQty <= 0) then
        LSQL := LSQL + Format('%d WHERE seq = %d;', [AAdjustQty, ASeq])
      else
        LSQL := LSQL + Format('(order_qty %s %d) WHERE seq = %d;', [IfThen(AAdjustQty < 1, '-', '+'), Abs(AAdjustQty), ASeq]);

      if not BPDM.ExecuteABSQuery(LSQL, LResMsg) then
        raise Exception.Create(LResMsg);
    end;
    if not BPDM.UpdateReceipt(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
      raise Exception.Create(LResMsg);
    if CheckDeleteReceipt(Global.ReceiptInfo.SelectedReceiptNo) then
      RefreshAll
    else
      RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo, LProdCode);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '주문 수량을 변경할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.DiscountSaleItem(const ASeq: Integer; const AProdCode: string; const AValue: Integer);
var
  LSQL, LResMsg: string;
begin
  try
    LSQL := Format('UPDATE TBSaleItem SET dc_amt = %d, service_yn = False WHERE seq = %d;', [AValue, Aseq]);
    if not BPDM.ExecuteABSQuery(LSQL, LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.UpdateReceipt(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
      raise Exception.Create(LResMsg);
    RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo, AProdCode);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '상품 할인을 적용/해제할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.ServiceSaleItem(const ASeq: Integer; const AProdCode: string; const AServiceYN: Boolean);
var
  LSQL, LResMsg: string;
  LServiceYN: Boolean;
begin
  try
    LServiceYN := (not AServiceYN);
    if LServiceYN then
      LSQL := Format('UPDATE TBSaleItem SET dc_amt = (prod_amt * order_qty), service_yn = True WHERE seq = %d;', [ASeq])
    else
      LSQL := Format('UPDATE TBSaleItem SET dc_amt = 0, service_yn = False WHERE seq = %d;', [ASeq]);
    if not BPDM.ExecuteABSQuery(LSQL, LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.UpdateReceipt(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
      raise Exception.Create(LResMsg);
    RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo, AProdCode);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '상품 서비스를 적용/해제할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.UsePointSaleItem;
var
  LInputValue, LSeq, LChargeAmt: Integer;
  LProdCode, LSQL, LResMsg: string;
begin
  with V1.DataController.DataSource.DataSet do
  try
    LInputValue := StrToIntDef(InputBuffer, 0);
    if (RecordCount > 0) then
    begin
      if (LInputValue = 0) and
         (FieldByName('use_point').AsInteger = 0) then
        Exit;
      if (LInputValue > 0) and
         Global.MemberInfo.MemberNo.IsEmpty then
        raise Exception.Create('포인트를 사용할 회원 정보를 선택하여 주십시오.');
      if (Global.MemberInfo.SavePoint < LInputValue) then
        raise Exception.Create('회원이 보유한 포인트가 부족합니다.');
      LSeq := FieldByName('seq').AsInteger;
      LProdCode := FieldByName('prod_cd').AsString;
      LChargeAmt := FieldByName('calc_charge_amt').AsInteger;
      if (LInputValue > LChargeAmt) then
      begin
        BPMsgBox(Self.Handle, mtInformation, '알림', '회원이 보유한 포인트가 부족하여 전액을 사용합니다.', ['확인'], 5);
        LInputValue := Global.MemberInfo.SavePoint;
      end;
      LSQL := Format('UPDATE TBSaleItem SET member_no = %s, use_point = %d WHERE seq = %d;', [Global.MemberInfo.MemberNo.QuotedString, LInputValue, LSeq]);
      if not BPDM.ExecuteABSQuery(LSQL, LResMsg) then
        raise Exception.Create(LResMsg);
      if not BPDM.UpdateReceipt(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
        raise Exception.Create(LResMsg);
      RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo, LProdCode);
      InputBuffer := '';
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '포인트 사용 내역을 변경할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

function TBPSalePosForm.CheckDeleteReceipt(const AReceiptNo: string): Boolean;
var
  LSQL, LResMsg: string;
  LSCount, LPCount: Integer;
begin
  Result := False;
  try
    LSCount := BPDM.GetABSRecordCount(Format('SELECT receipt_no FROM TBSaleItem WHERE receipt_no = %s;', [AReceiptNo.QuotedString]), LResMsg);
    if not LResMsg.IsEmpty then
      raise Exception.Create(LResMsg);
    LPCount := BPDM.GetABSRecordCount(Format('SELECT receipt_no FROM TBPayment WHERE receipt_no = %s;', [AReceiptNo.QuotedString]), LResMsg);
    if not LResMsg.IsEmpty then
      raise Exception.Create(LResMsg);
    if (LSCount = 0) and
       (LPCount = 0) then
    begin
      LSQL := Format('DELETE FROM TBReceipt WHERE receipt_no = %s;', [AReceiptNo.QuotedString]);
      if not BPDM.ExecuteABSQuery(LSQL, LResMsg) then
        raise Exception.Create(LResMsg);
      Result := True;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '영수증 정보를 삭제할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

function TBPSalePosForm.SelectLocker(var AResMsg: string): Boolean;
var
  PM: TPluginMessage;
begin
  Result := False;
  AResMsg := '';
  try
    if (Global.Plugin.LockerViewPluginId > 0) then
    begin
      SendToPlugin(CPC_CLOSE, Global.Plugin.LockerViewPluginId);
      Application.ProcessMessages;
    end;

    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_SELECT_LOCKER, True);
      PM.AddParams(CPP_MEMBER_NO, Global.MemberInfo.MemberNo);
      PM.AddParams(CPP_VALUE, Format('라커회원 ☞ %s(%s)%s', [Global.MemberInfo.MemberName, Global.MemberInfo.MemberNo, IfThen(Global.MemberInfo.LockerList.IsEmpty, '', ' : ' + Global.MemberInfo.LockerList)]));
      if (PluginManager.OpenModal(Global.Plugin.LockerViewPlugin, PM) <> mrOK) then
        raise Exception.Create('이용할 라커 정보가 선택되지 않았습니다.');
      Result := True;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      AResMsg := E.Message;
  end;
end;

(*
procedure TBPSalePosForm.ClearSaleItem;
var
  LResMsg: string;
begin
  try
    if Global.ReceiptInfo.SelectedReceiptNo.IsEmpty then
      raise Exception.Create('영수증 번호가 없습니다.');
    if not BPDM.DeleteABSRecord('TBSaleItem', Format('receipt_no = %s', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]), True, LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.UpdateReceipt(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
      raise Exception.Create(LResMsg);
    if CheckDeleteReceipt(Global.ReceiptInfo.SelectedReceiptNo) then
      RefreshAll
    else
      RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '상품 내역을 삭제할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;
*)

procedure TBPSalePosForm.DispSaleResult;
begin
  with Global.ReceiptInfo do
  begin
    edtSaleTotal.Text     := FormatCurr('#,##0', SaleAmt);
    edtDCTotal.Text       := FormatCurr('#,##0', DCAmt);
    edtVatTotal.Text      := FormatCurr('#,##0', VAT);
    edtChargeTotal.Text   := FormatCurr('#,##0', ChargeAmt);
    edtKeepAmtTotal.Text  := FormatCurr('#,##0', KeepAmt);
    edtUsePointTotal.Text := FormatCurr('#,##0', UsePoint);
    edtReceiveTotal.Text  := FormatCurr('#,##0', ReceiveAmt);
    edtUnPaidTotal.Text   := FormatCurr('#,##0', UnpaidAmt);
    edtChangeTotal.Text   := FormatCurr('#,##0', ChangeAmt);
  end;
end;

procedure TBPSalePosForm.RefreshSelectedLaneGroup;
var
  LDown: Boolean;
begin
  LDown := False;
  for var I: ShortInt := 0 to Pred(Global.LaneInfo.LaneCount) do
    if (Global.LaneInfo.SelectedLanes.Count > I) then
    begin
      FSelectedLaneButtons[I].Tag := Global.LaneInfo.SelectedLanes.Item[I]; //LaneNo
      FSelectedLaneButtons[I].Caption := Global.LaneInfo.SelectedLanes.Item[I].ToString;
      FSelectedLaneButtons[I].Left := (I * FSelectedLaneButtons[I].Width);
      FSelectedLaneButtons[I].Visible := True;
      if (FSelectedLaneButtons[I].Tag = Global.LaneInfo.SelectedLaneNo) then
      begin
        LDown := True;
        FSelectedLaneButtons[I].Down := True;
      end
      else
        FSelectedLaneButtons[I].Down := False;
    end
    else
    begin
      FSelectedLaneButtons[I].Tag := 0;
      FSelectedLaneButtons[I].Caption := '';
      FSelectedLaneButtons[I].Visible := False;
    end;

  if (not LDown) or
     ((Global.LaneInfo.SelectedLanes.Count > 0) and
      (Global.LaneInfo.SelectedLaneNo = 0) and
      (Global.LaneInfo.SelectedLanes.IndexOf(Global.LaneInfo.SelectedLaneNo) = -1)) then
  begin
    FSelectedLaneButtons[0].Down := True;
    Global.LaneInfo.SelectedLaneNo := FSelectedLaneButtons[0].Tag;
    BaseTitle := Format('%s [%d 레인]', [Self.Caption, Global.LaneInfo.SelectedLaneNo]);
  end;
end;

procedure TBPSalePosForm.OnSelectedLaneGroupButtonClick(Sender: TObject);
var
  LLaneNo: ShortInt;
begin
  LLaneNo := TSpeedButton(Sender).Tag;
  if (Global.LaneInfo.SelectedLaneNo <> LLaneNo) then
  begin
    btnSelectedLane.Down := True;
    Global.LaneInfo.SelectedLaneNo := LLaneNo;
    BaseTitle := Format('%s [%d 레인]', [Self.Caption, Global.LaneInfo.SelectedLaneNo]);
    ClearMemberInfo;
    RefreshAll;
  end;
end;

procedure TBPSalePosForm.PluGroupChangeCallBack(const AGroupIndex: Integer);
var
  LGroup: ShortInt;
begin
  with Global.PluManager do
  begin
    for var I: ShortInt := 0 to Pred(GroupPerPage) do
    begin
      LGroup := (ActiveGroupPage * GroupPerPage) + I;
      if (LGroup < GetGroupCount) then
      begin
        FPluGroup[I].Caption := Group[LGroup].ProdDetailDivName;
        FPluGroup[I].Enabled := True;
        FPluGroup[I].Tag := LGroup;
      end
      else
      begin
        FPluGroup[I].Caption := '';
        FPluGroup[I].Enabled := False;
        FPluGroup[I].Tag := -1;
      end;
    end;

    PluGroupPrev := (ActiveGroupPage > 0);
    PluGroupNext := (ActiveGroupPage < Pred(GroupPageCount));
    OnPluGroupButtonClick(FPluGroup[0]);
    FPluGroup[0].Down := True;
  end;
end;

procedure TBPSalePosForm.PluItemPageChangeCallback(const AGroupIndex, AItemPageIndex: Integer);
var
  LItem, LCount, LHour, LMin: Integer;
begin
  LCount := 0;
  with Global.PluManager do
  begin
    for var I: ShortInt := 0 to Pred(ItemPerPage) do
    begin
      LItem := (ActiveItemPage * ItemPerPage) + I;
      FPluItems[I].ProdInfo := '';
      if (LItem <= Pred(GetItemCount(AGroupIndex))) then
      begin
        Inc(LCount);
        FPluItems[I].Visible := True;
        FPluItems[I].Tag := LItem;
        FPluItems[I].ProdDiv := Items[AGroupIndex, LItem].ProdDiv;
        FPluItems[I].ProdDetailDiv := Items[AGroupIndex, LItem].ProdDetailDiv;
        FPluItems[I].ProdCode := Items[AGroupIndex, LItem].ProdCode;
        FPluItems[I].ProdName := Items[AGroupIndex, LItem].ProdName;
        FPluItems[I].ProdAmt := Items[AGroupIndex, LItem].ProdAmt;
        if (FPluItems[I].ProdDiv = CO_PROD_GAME) and
           ((not Items[AGroupIndex, LItem].ApplyStartTime.IsEmpty) or
            (not Items[AGroupIndex, LItem].ApplyEndTime.IsEmpty)) then
        begin
          FPluItems[I].ProdInfo := Format('%s ~ %s', [Items[AGroupIndex, LItem].ApplyStartTime, Items[AGroupIndex, LItem].ApplyEndTime]);
          if (not Items[AGroupIndex, LItem].TodayYN) or
             (not Items[AGroupIndex, LItem].UseYN) then
            FPluItems[I].ProdInfo := FPluItems[I].ProdInfo + _CRLF + '사용 불가';
        end
        else if (FPluItems[I].ProdDiv = CO_PROD_LOCKER) and
                (FPluItems[I].ProdDetailDiv = CO_PROD_DETAIL_LOCKER) then
          FPluItems[I].ProdInfo := Trim(Format('%s %s', [Items[AGroupIndex, LItem].LockerLayerName, Items[AGroupIndex, LItem].SexDivName]))
        else if (FPluItems[I].ProdDiv = CO_PROD_MEMBERSHIP) then
        begin
          if (FPluItems[I].ProdDetailDiv = CO_PROD_DETAIL_MEMBER_GAME) then
            FPluItems[I].ProdInfo := Format('%d 게임', [Items[AGroupIndex, LItem].UseGameCount])
          else if (FPluItems[I].ProdDetailDiv = CO_PROD_DETAIL_MEMBER_TIME) then
          begin
            LHour := (Items[AGroupIndex, LItem].UseGameMin div 60);
            LMin := (Items[AGroupIndex, LItem].UseGameMin mod 60);
            if (LHour > 0) then
              FPluItems[I].ProdInfo := Format('%d 시간', [LHour]);
            if (LMin > 0) then
              FPluItems[I].ProdInfo := Trim(FPluItems[I].ProdInfo + Format(' %d 분', [LMin]));
          end;
        end;
      end
      else
      begin
        FPluItems[I].Visible := False;
        FPluItems[I].Tag := 0;
        FPluItems[I].ProdDiv := '';
        FPluItems[I].ProdDetailDiv := '';
        FPluItems[I].ProdCode := '';
        FPluItems[I].ProdName := '';
        FPluItems[I].ProdAmt := 0;
        FPluItems[I].ProdInfo := '';
      end;
    end;

    PluListPrev := (ActiveItemPage > 0);
    PluListNext := (ActiveItemPage < Pred(ItemPageCount[CurrentGroupIndex]));
    panPluList.ShowCaption := (LCount = 0);
  end;
end;

procedure TBPSalePosForm.OnPluGroupButtonClick(Sender: TObject);
var
  LGroup: ShortInt;
begin
  LGroup := TSpeedButton(Sender).Tag;
  if (LGroup < 0) then
    Exit;

  with Global.PluManager do
  begin
    CurrentGroupIndex := LGroup;
    SetItemPage(CurrentGroupIndex, 0, PluItemPageChangeCallback);
  end;
end;

procedure TBPSalePosForm.OnPluItemButtonClick(Sender: TObject);
begin
  AddSaleItem(TPluContainer(Sender).Tag);
end;

procedure TBPSalePosForm.OnPluItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex: ShortInt;
begin
  LIndex := TLabel(Sender).Tag;
  FPluItems[LIndex].ProdNameLabel.Transparent := False;
  FPluItems[LIndex].ProdInfoLabel.Transparent := False;
  FPluItems[LIndex].ProdAmtLabel.Transparent := False;
end;

procedure TBPSalePosForm.OnPluItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LIndex: ShortInt;
begin
  LIndex := TLabel(Sender).Tag;
  FPluItems[LIndex].ProdNameLabel.Transparent := True;
  FPluItems[LIndex].ProdInfoLabel.Transparent := True;
  FPluItems[LIndex].ProdAmtLabel.Transparent := True;
end;

procedure TBPSalePosForm.btnGeneralLaneClick(Sender: TObject);
begin
  LaneSelected := False;
end;

procedure TBPSalePosForm.btnSelectedLaneClick(Sender: TObject);
begin
  LaneSelected := True;
end;

procedure TBPSalePosForm.OnLeftRightMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TLabel(Sender).Transparent := False;
end;

procedure TBPSalePosForm.OnLeftRightMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TLabel(Sender).Transparent := True;
end;

procedure TBPSalePosForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    if (Global.LaneInfo.SelectedLanes.Count > 0) then
      btnSelectedLane.Click
    else
      btnGeneralLane.Click;
    Global.PluManager.SetGroupPage(0, PluGroupChangeCallBack);
  finally
    Free;
  end;
end;

procedure TBPSalePosForm.V1Bands0HeaderClick(Sender: TObject);
begin
  for var I: ShortInt := 0 to Pred(V1.ColumnCount) do
    V1.Columns[I].SortOrder := TdxSortOrder.soNone;
end;

procedure TBPSalePosForm.V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  LDetailDiv: string;
begin
  try
    if (AViewInfo.RecordViewInfo.Index = V1.Controller.FocusedRowIndex) then
    begin
      //ACanvas.Brush.Color := $00E3BC7B;
      ACanvas.Font.Color := $00326FFF; //$00FF7900;
      ACanvas.Font.Style := [fsBold];
    end
    else
    begin
      LDetailDiv := NVL(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('prod_detail_div').Index], '');
      //수량 변경이 불가한 게임요금제 상품과 라커 상품은 글꼴 색상을 다르게 표시
      if (LDetailDiv = CO_PROD_DETAIL_GAME_COUNT) or
         (LDetailDiv = CO_PROD_DETAIL_GAME_MIN) then
        ACanvas.Font.Color := $00966A1D
      else if (LDetailDiv = CO_PROD_DETAIL_LOCKER) then
        ACanvas.Font.Color := $004876B5;
    end;
  except
  end;
end;

procedure TBPSalePosForm.V1DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  RefreshSaleSummary;
  DispSaleResult;
end;

procedure TBPSalePosForm.V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  V1.Bands[0].Caption := Format('주문내역 ▶ %s', [V1.DataController.DataSet.FieldByName('receipt_no').AsString]);
end;

procedure TBPSalePosForm.V2DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with V2.DataController.Summary do
  begin

  end;
  DispSaleResult;
end;

procedure TBPSalePosForm.V3DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with V3.DataController.Summary do
  begin

  end;
  DispSaleResult;
end;

procedure TBPSalePosForm.OnReceiptNoListChange(Sender: TObject);
begin
  Global.ReceiptInfo.SelectedReceiptNo := '';
  with TComboBox(Sender) do
    if (Items.Count > 0) then
    begin
      if (ItemIndex < 0) then
        ItemIndex := 0;
      Global.ReceiptInfo.SelectedReceiptNo := TReceiptListItem(Items.Objects[ItemIndex]).ReceiptNo;
      RefreshAll(True);
      V1.Controller.ClearSelection;
    end;
end;

procedure TBPSalePosForm.edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and
     not TDBEditEh(Sender).Text.IsEmpty then
    btnSearchMember.Click;
end;

procedure TBPSalePosForm.edtMemberTelNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and
     not TDBEditEh(Sender).Text.IsEmpty then
    btnSearchMember.Click;
end;

procedure TBPSalePosForm.lblPluGroupPrevClick(Sender: TObject);
var
  LNewPage: ShortInt;
begin
  with Global.PluManager do
  begin
    LNewPage := Pred(ActiveGroupPage);
    if (LNewPage < 0) then
      LNewPage := Pred(GroupPageCount);
    SetGroupPage(LNewPage, PluGroupChangeCallback);
  end;
end;

procedure TBPSalePosForm.lblPluGroupNextClick(Sender: TObject);
var
  LNewPage: ShortInt;
begin
  with Global.PluManager do
  begin
    LNewPage := Succ(ActiveGroupPage);
    if (LNewPage > Pred(GroupPageCount)) then
      LNewPage := 0;
    SetGroupPage(LNewPage, PluGroupChangeCallback);
  end;
end;

procedure TBPSalePosForm.lblPluListPrevClick(Sender: TObject);
var
  LNewPage: ShortInt;
begin
  with Global.PluManager do
  begin
    LNewPage := Pred(ActiveItemPage);
    if (LNewPage < 0) then
      LNewPage := Pred(ItemPageCount[CurrentGroupIndex]);
    SetItemPage(CurrentGroupIndex, LNewPage, PluItemPageChangeCallback);
  end;
end;

procedure TBPSalePosForm.lblPluListNextClick(Sender: TObject);
var
  LNewPage: ShortInt;
begin
  with Global.PluManager do
  begin
    LNewPage := Succ(ActiveItemPage);
    if (LNewPage > Pred(ItemPageCount[CurrentGroupIndex])) then
      LNewPage := 0;
    SetItemPage(CurrentGroupIndex, LNewPage, PluItemPageChangeCallback);
  end;
end;

procedure TBPSalePosForm.btnNumPadClick(Sender: TObject);
begin
  with TBitBtn(Sender) do
  begin
    case Tag of
      48..57: //0..9
        begin
          if (Tag = 48) and
             (InputBuffer.Substring(0, 1) = '0') then
            Exit;
          InputBuffer := InputBuffer + StringOfChar(Chr(Tag), Length(Caption));
        end;
    end;
  end;
end;

procedure TBPSalePosForm.btnNumBackClick(Sender: TObject);
begin
  if not InputBuffer.IsEmpty then
    InputBuffer := Trim(Copy(InputBuffer, 1, Pred(Length(InputBuffer))));
end;

procedure TBPSalePosForm.btnNumClearClick(Sender: TObject);
begin
  InputBuffer := '';
end;

procedure TBPSalePosForm.btnItemClearClick(Sender: TObject);
var
  LResMsg: string;
  LCount, LSaleSeq: Integer;
  SL: TStringList;
begin
  LCount := V1.Controller.SelectedRowCount;
  if (LCount = 0) or
     (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('선택(체크)한 상품 %d 건을 삭제하시겠습니까?', [LCount]), ['예', '아니오']) <> mrOk) then
    Exit;

  try
    SL := TStringList.Create;
    SL.Delimiter := ',';
    try
      for var I: ShortInt := 0 to Pred(V1.ViewData.RecordCount) do
        if V1.ViewData.Rows[I].Selected then
        begin
          LSaleSeq := V1.ViewData.Rows[I].Values[V1.GetColumnByFieldName('seq').Index];
          SL.Add(LSaleSeq.ToString);
        end;

      if not BPDM.DeleteABSRecord('TBSaleItem', Format('seq IN (%s)', [SL.DelimitedText]), True, LResMsg) then
        raise Exception.Create(LResMsg);
      V1.Controller.ClearSelection;
      if CheckDeleteReceipt(Global.ReceiptInfo.SelectedReceiptNo) then
        RefreshAll
      else
        RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo);
      BPMsgBox(Self.Handle, mtInformation, '알림', '선택한 상품을 삭제하였습니다.' + _BR + '예약된 내역이 있으면 목록에 표시될 수 있습니다.', ['확인'], 5);
      SendToMainForm(CPC_SALE_REFRESH_LANE, Global.LaneInfo.SelectedLaneNo);
    finally
      FreeAndNil(SL);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '장애가 발생하여 선택한 상품을 삭제할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.btnItemIncQtyClick(Sender: TObject);
begin
  with V1.DataController.DataSource.DataSet do
    if (RecordCount > 0) and
       (not ((FieldByName('prod_div').AsString = CO_PROD_GAME) or
             (FieldByName('prod_div').AsString = CO_PROD_LOCKER))) then
    begin
      AdjustSaleItem(FieldByName('seq').AsInteger, FieldByName('prod_cd').AsString, FieldByName('order_qty').AsInteger, 1);
      SendToMainForm(CPC_SALE_REFRESH_LANE, Global.LaneInfo.SelectedLaneNo);
    end;
end;

procedure TBPSalePosForm.btnItemDecQtyClick(Sender: TObject);
var
  LOrderQty: Integer;
begin
  with V1.DataController.DataSource.DataSet do
    if (RecordCount > 0) and
       (not ((FieldByName('prod_div').AsString = CO_PROD_GAME) or
             (FieldByName('prod_div').AsString = CO_PROD_LOCKER))) then
    begin
      LOrderQty := FieldByName('order_qty').AsInteger;
      if (LOrderQty = 1) and
         (BPMsgBox(Self.Handle, mtConfirmation, '확인', '주문 수량이 1개인 상품을 감소시키면 주문 목록에서 삭제가 됩니다.' + _BR + '계속 진행하시겠습니까?', ['예', '아니오']) <> mrOk) then
        Exit;
      AdjustSaleItem(FieldByName('seq').AsInteger, FieldByName('prod_cd').AsString, LOrderQty, -1);
      SendToMainForm(CPC_SALE_REFRESH_LANE, Global.LaneInfo.SelectedLaneNo);
    end;
end;

procedure TBPSalePosForm.btnItemChangeQtyClick(Sender: TObject);
var
  LInputValue: Integer;
begin
  LInputValue := StrToIntDef(InputBuffer, 0);
  with V1.DataController.DataSource.DataSet do
    if (RecordCount > 0) and
       (LInputValue > 0) and
       (not ((FieldByName('prod_div').AsString = CO_PROD_GAME) or
             (FieldByName('prod_div').AsString = CO_PROD_LOCKER))) then
    begin
      AdjustSaleItem(FieldByName('seq').AsInteger, FieldByName('prod_cd').AsString, 0, LInputValue);
      SendToMainForm(CPC_SALE_REFRESH_LANE, Global.LaneInfo.SelectedLaneNo);
      InputBuffer := '';
    end;
end;

procedure TBPSalePosForm.btnItemDiscountCancelClick(Sender: TObject);
begin
  with V1.DataController.DataSource.DataSet do
    if (RecordCount > 0) and
       (not FieldByName('service_yn').AsBoolean) then
    begin
      DiscountSaleItem(FieldByName('seq').AsInteger, FieldByName('prod_cd').AsString, 0);
      InputBuffer := '';
    end;
end;

procedure TBPSalePosForm.btnItemDiscountClick(Sender: TObject);
var
  LChargeAmt, LInputValue: Integer;
begin
  LInputValue := StrToIntDef(InputBuffer, 0);
  with V1.DataController.DataSource.DataSet do
    if (RecordCount > 0) and
       (LInputValue > 0) then
    begin
      LChargeAmt := (FieldByName('prod_amt').AsInteger * FieldByName('order_qty').AsInteger);
      if (LChargeAmt < LInputValue) then
        LInputValue := LChargeAmt;
      DiscountSaleItem(FieldByName('seq').AsInteger, FieldByName('prod_cd').AsString, LInputValue);
      InputBuffer := '';
    end;
end;

procedure TBPSalePosForm.btnItemDiscountPercentClick(Sender: TObject);
var
  LChargeAmt, LInputValue: Integer;
begin
  LInputValue := StrToIntDef(InputBuffer, 0);
  with V1.DataController.DataSource.DataSet do
    if (RecordCount > 0) and
       (LInputValue > 0) then
    begin
      if (LInputValue > 100) then //100% 이상은 입력 불가
        LInputValue := 100;
      LChargeAmt := (FieldByName('prod_amt').AsInteger * FieldByName('order_qty').AsInteger);
      LInputValue := Trunc(((LChargeAmt / 100) * LInputValue) / 10) * 10;
      DiscountSaleItem(FieldByName('seq').AsInteger, FieldByName('prod_cd').AsString, LInputValue);
      InputBuffer := '';
    end;
end;

procedure TBPSalePosForm.btnItemSelectAllClick(Sender: TObject);
begin
  V1.Controller.SelectAll;
end;

procedure TBPSalePosForm.btnItemClearSelectClick(Sender: TObject);
begin
  V1.Controller.ClearSelection;
end;

procedure TBPSalePosForm.btnItemServiceClick(Sender: TObject);
begin
  with V1.DataController.DataSource.DataSet do
    if (RecordCount > 0) then
    begin
      ServiceSaleItem(FieldByName('seq').AsInteger, FieldByName('prod_cd').AsString, FieldByName('service_yn').AsBoolean);
      InputBuffer := '';
    end;
end;

procedure TBPSalePosForm.btnItemUsePointClick(Sender: TObject);
begin
  UsePointSaleItem;
end;

procedure TBPSalePosForm.btnOpenDrawerClick(Sender: TObject);
begin
  OpenCashDrawer;
end;

procedure TBPSalePosForm.btnPaymentCardClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if (BPDM.QRSaleItem.RecordCount = 0) or
     (Global.ReceiptInfo.UnpaidAmt = 0) then
    Exit;
  PM := TPluginMessage.Create(nil);
  try
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_APPROVAL_YN, True);
      PM.AddParams(CPP_SALEMODE_YN, True);
      PM.AddParams(CPP_RECEIPT_NO, '');
      PM.AddParams(CPP_APPROVAL_NO, '');
      PM.AddParams(CPP_APPROVAL_DATE, '');
      PM.AddParams(CPP_APPROVAL_AMT, Global.ReceiptInfo.UnpaidAmt);
      if (PluginManager.OpenModal('BPPaymentCard' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK) then
      try
        UpdatePaymentSeq;
        RefreshPayment;
        if (V1.Controller.SelectedRowCount > 0) and
           (V1.ViewData.RecordCount = V1.Controller.SelectedRowCount) then
          DoSaleComplete;
      finally
        Global.ReceiptInfo.CardPayAmt := 0;
        V1.Controller.ClearSelection;
        DispSaleResult;
        pgcSaleDetail.ActivePage := tabPayment;
      end;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure TBPSalePosForm.btnPaymentCancelClick(Sender: TObject);
begin
  try
    TBitBtn(Sender).Enabled := False;
    DoCancelPayment;
  finally
    TBitBtn(Sender).Enabled := True;
  end;
end;

procedure TBPSalePosForm.btnPaymentCashClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  if (BPDM.QRSaleItem.RecordCount = 0) or
     (Global.ReceiptInfo.UnpaidAmt = 0) then
    Exit;
  PM := TPluginMessage.Create(nil);
  try
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_APPROVAL_YN, True);
      PM.AddParams(CPP_SALEMODE_YN, True);
      PM.AddParams(CPP_RECEIPT_NO, '');
      PM.AddParams(CPP_APPROVAL_NO, '');
      PM.AddParams(CPP_APPROVAL_DATE, '');
      PM.AddParams(CPP_APPROVAL_AMT, Global.ReceiptInfo.UnpaidAmt);
      PM.AddParams(CPP_CASH_ENTITY_DIV, CO_CASH_RECEIPT_PERSON);
      if (PluginManager.OpenModal('BPPaymentCash' + CO_DEFAULT_EXT_PLUGIN, PM) = mrOK) then
      try
        UpdatePaymentSeq;
        RefreshPayment;
        if (V1.Controller.SelectedRowCount > 0) and
           (V1.ViewData.RecordCount = V1.Controller.SelectedRowCount) then
          DoSaleComplete;
      finally
        Global.ReceiptInfo.CashPayAmt := 0;
        V1.Controller.ClearSelection;
        DispSaleResult;
        pgcSaleDetail.ActivePage := tabPayment;
      end;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    FreeAndNil(PM);
  end;
end;

procedure TBPSalePosForm.btnPaymentPaycoClick(Sender: TObject);
begin
  if (BPDM.QRSaleItem.RecordCount = 0) or
     (Global.ReceiptInfo.UnpaidAmt = 0) then
    Exit;
end;

procedure TBPSalePosForm.btnPaymentVoucherClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnPaymentAffiliateClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnFacilityClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnAddPendingClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnPendingListClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnSearchProdClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnShowLaneListClick(Sender: TObject);
begin
  ShowLaneView(Self.PluginID, Global.AppInfo.PluginContainer);
end;

procedure TBPSalePosForm.btnShowLockerListClick(Sender: TObject);
begin
  ShowLockerView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

procedure TBPSalePosForm.btnShowReceiptListClick(Sender: TObject);
begin
  ShowReceiptView(Global.AppInfo.Handle, Global.AppInfo.PluginContainer);
end;

procedure TBPSalePosForm.btnSearchMemberClick(Sender: TObject);
begin
  try
    if (ShowMemberPopup(Self.PluginID, '', 0, CO_DATA_MODE_SELECT, CO_SEARCH_MEMBER_NAME, edtMemberName.Text, CO_SEARCH_TEL_NO, edtMemberTelNo.Text) <> mrOK) then
    begin
      Global.MemberInfo.Clear;
      ClearMemberInfo;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '회원 정보를 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosForm.btnAddMemberClick(Sender: TObject);
begin
  ShowMemberPopup(Self.PluginID, '', 0, CO_DATA_MODE_NEW, CO_SEARCH_NONE);
end;

procedure TBPSalePosForm.btnClearMemberClick(Sender: TObject);
begin
  Global.MemberInfo.Clear;
  ClearMemberInfo;
end;

procedure TBPSalePosForm.btnCouponCancelClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnCouponRefreshClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnCouponNoInputClick(Sender: TObject);
begin
//
end;

procedure TBPSalePosForm.btnSaleCompleteClick(Sender: TObject);
begin
  try
    TBitBtn(Sender).Enabled := False;
    DoSaleComplete;
  finally
    TBitBtn(Sender).Enabled := True;
  end;
end;

procedure TBPSalePosForm.ClearMemberInfo;
begin
  FSelectedMemberNo := '';
  FSelectedMemberName := '';
  edtMemberNo.Text := '';
  edtMemberName.Text := '';
  edtMemberSexDivName.Text := '';
  edtMemberClubName.Text := '';
  edtMemberDivName.Text := '';
  edtMemberGroupName.Text := '';
  edtMemberCarNo.Text := '';
  edtMemberTelNo.Text := '';
  edtMemberSavePoint.Value := 0;
  mmoMemberMemo.Clear;
  imgMemberPhoto.Picture := nil;
end;

procedure TBPSalePosForm.DispMemberInfo;
begin
  with Global.MemberInfo do
  begin
    edtMemberNo.Text := MemberNo;
    edtMemberName.Text := MemberName;
    edtMemberSexDivName.Text := GetSexDivName(SexDiv);
    edtMemberClubName.Text := ClubName;
    edtMemberDivName.Text := MemberDivName;
    edtMemberGroupName.Text := MemberGroupName;
    edtMemberCarNo.Text := CarNo;
    edtMemberTelNo.Text := TelNo;
    edtMemberSavePoint.Value := SavePoint;
    mmoMemberMemo.Text := MemberMemo;
    if Assigned(PhotoStream) then
      imgMemberPhoto.Picture.LoadFromStream(PhotoStream);
  end;
end;

procedure TBPSalePosForm.DoSaleComplete;
var
  RI: TReceiptItemInfo;
  SL: TArray<TProdItemRec>;
  PL: TArray<TPaymentItemRec>;
  LSeq, LIndex, LSaleAmt, LDCAmt, LUsePoint, LKeepAmt, LReceiveAmt: Integer;
  LProdDiv, LReceiptJson, LSaleMemo, LResMsg: string;
begin
  if FWorking then
    Exit;
  FWorking := True;
  with BPDM.QRReceipt do
  begin
    if not Locate('receipt_no', Global.ReceiptInfo.SelectedReceiptNo, []) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림', '영수증 내역이 존재하지 않습니다.' + _BR + '주문번호 ☞ ' + ErrorString(Global.ReceiptInfo.SelectedReceiptNo), ['확인']);
      Exit;
    end;
    LSaleAmt := FieldByName('sale_amt').AsInteger;
    LDCAmt := FieldByName('dc_amt').AsInteger;
    LUsePoint := FieldByName('use_point').AsInteger;
    LKeepAmt := FieldByName('keep_amt').AsInteger;
    LReceiveAmt := FieldByName('receive_amt').AsInteger;
    LSaleMemo := mmoSaleMemo.Text;
  end;

  with TABSQuery.Create(nil) do
  try
    DatabaseName := BPDM.LocalDB.DatabaseName;
    btnSaleComplete.Enabled := False;
    try
      if (Global.ReceiptInfo.UnPaidAmt > 0) then
        raise Exception.Create('상품 금액의 결제가 완료되지 않았습니다.' + _BR + '미결제금액: ' + FormatCurr('#,##0', Global.ReceiptInfo.UnPaidAmt));
      if (V1.Controller.SelectedRowCount = 0) then
        raise Exception.Create('결제할 상품이 선택되지 않았습니다.');

      G1.Enabled := False;
      LIndex := 0;
      Close;
      SQL.Text := Format('SELECT * FROM TBSaleItem WHERE receipt_no = %s;', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]);
      Open;
      while not Eof do
      begin
        SetLength(SL, Succ(LIndex));
        LProdDiv := FieldByName('prod_div').AsString;
        LSeq := FieldByName('seq').AsInteger;
        with SL[LIndex] do
        begin
          Clear;
          Seq := LSeq;
          AssignLaneNo := FieldByName('assign_lane_no').AsInteger;
          AssignNo := FieldByName('assign_no').AsString;
          BowlerId := FieldByName('bowler_id').AsString;
          MemberNo := FieldByName('member_no').AsString;
          ProdDiv := LProdDiv;
          ProdDetailDiv := FieldByName('prod_detail_div').AsString;
          ProdCode := FieldByName('prod_cd').AsString;
          ProdName := FieldByName('prod_nm').AsString;
          OrderQty := FieldByName('order_qty').AsInteger;
          ProdAmt := FieldByName('prod_amt').AsInteger;
          DCAmt := FieldByName('dc_amt').AsInteger;
          UsePoint := FieldByName('use_point').AsInteger;
          KeepAmt := FieldByName('keep_amt').AsInteger;
          IsService := FieldByName('service_yn').AsBoolean;
          if (LProdDiv = CO_PROD_LOCKER) then
          begin
            LockerNo :=  FieldByName('locker_no').AsInteger;
            LockerName := FieldByName('locker_nm').AsString;
            PurchaseMonth := FieldByName('purchase_month').AsInteger;
            UseStartDate := FieldByName('start_dt').AsString;
          end;
        end;
        Inc(LIndex);
        Next;
      end;

      LIndex := 0;
      Close;
      SQL.Text := Format('SELECT * FROM TBPayment WHERE receipt_no = %s;', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]);
      Open;
      while not Eof do
      begin
        SetLength(PL, Succ(LIndex));
        LSeq := FieldByName('seq').AsInteger;
        with PL[LIndex] do
        begin
          Clear;
          Seq := LSeq;
          PayMethod := FieldByName('pay_method').AsInteger;
          IsApproval := True;
          IsManualInput := FieldByName('manual_input_yn').AsBoolean;
          VanCode := FieldByName('van_cd').AsString;
          TID := FieldByName('tid').AsString;
          ApproveNo := FieldByName('approve_no').AsString;
          ApproveAmt := FieldByName('approve_amt').AsInteger;
          OrgApproveNo := '';
          OrgApproveDate := '';
          VAT := FieldByName('vat').AsInteger;
          InstallMonth := FieldByName('inst_month').AsInteger;
          CashEntity := FieldByName('cash_entity_div').AsInteger;
          CardNo := FieldByName('card_no').AsString;
          TradeNo := FieldByName('trade_no').AsString;
          TradeDate := FieldByName('trade_dt').AsString;
          IssuerCode := FieldByName('issuer_cd').AsString;
          ISsuerName := FieldByName('issuer_nm').AsString;
          BuyerDiv := FieldByName('buyer_div').AsString;
          BuyerCode := FieldByName('buyer_cd').AsString;
          BuyerName := FieldByName('buyer_nm').AsString;

          case PayMethod of
            CO_PAYMENT_CASH:
              Global.ReceiptInfo.CashPayAmt := Global.ReceiptInfo.CashPayAmt + ApproveAmt;
            else
              Global.ReceiptInfo.CardPayAmt := Global.ReceiptInfo.CardPayAmt + ApproveAmt;
          end;
        end;
        Inc(LIndex);
        Next;
      end;

      RI.Clear;
      RI.ReceiptNo := Global.ReceiptInfo.SelectedReceiptNo;
      RI.SaleAmt := LSaleAmt;
      RI.DCAmt := LDCAmt;
      RI.KeepAmt := LKeepAmt;
      RI.ChargeAmt := (LSaleAmt - (LDCAmt + LUsePoint));
      RI.ReceiveAmt := LReceiveAmt;
      RI.ChangeAmt := IfThen(LReceiveAmt = 0, 0, LReceiveAmt - RI.ChargeAmt);
      RI.VAT := (RI.ChargeAmt - Floor(RI.ChargeAmt / 1.1));
      RI.SaleMemo := mmoSaleMemo.Text;
      if not BPDM.PostProdSale(RI, SL, PL, LResMsg) then
        raise Exception.Create(LResMsg);

      { 게임 서버에 결제 완료 처리 요청 }
      try
        for var I:ShortInt := 0 to High(SL) do
          if (SL[I].ProdDiv = CO_PROD_GAME) and
             not BPDM.SetPaymentType(SL[I].AssignNo, SL[I].BowlerId, CO_PAYTYPE_PREPAID, LResMsg) then
            raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtError, '알림', '결제 완료 처리에 장애가 발생하였습니다.' + _BR + '레인 관리 → 예약 목록에서 다시 시도하여 주십시오.' + _BR + ErrorString(E.Message), ['확인']);
      end;

      try
        LReceiptJson := BPDM.MakeReceiptJson(RI, SL, PL, Global.DateTime.FormattedCurrentDate, Global.DateTime.FormattedCurrentTime.Substring(0, 5), LResMsg);
        if not LResMsg.IsEmpty then
          raise Exception.Create(LResMsg);
        Global.ReceiptPrint.IsRefund := False;
        if Global.ReceiptPrinter.Enabled then
          if not Global.ReceiptPrint.ReceiptPrint(LReceiptJson, False, LResMsg) then
            raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtError, '알림', '영수증/배정표 출력에 장애가 발생했습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
      end;

      { 보류 내역 삭제 }
      try
        if (not Global.ReceiptInfo.PendingReceiptNo.IsEmpty) and
           not BPDM.DeletePending(Global.ReceiptInfo.PendingReceiptNo, LResMsg) then
          raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '알림', '보류 내역을 삭제하지 못하였습니다.' + _BR + '보류내역 조회 화면에서 직접 삭제하여 주시기 바랍니다.' + _BR + ErrorString(E.Message), ['확인']);
      end;
      { 주문 내역 삭제 }
      try
        if not BPDM.DeleteABSRecord('TBSaleItem', Format('receipt_no = %s', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]), False, LResMsg) then
          raise Exception.Create(LResMsg)
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '알림', '주문 내역을 삭제하지 못하였습니다.' + _BR + ErrorString(E.Message), ['확인']);
      end;
      { 결제 내역 삭제 }
      try
        if not BPDM.DeleteABSRecord('TBPayment', Format('receipt_no = %s', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]), False, LResMsg) then
          raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '알림', '결제 내역을 삭제하지 못하였습니다.' + _BR + ErrorString(LResMsg), ['확인']);
      end;
      { 영수증 내역 삭제 }
      try
        if not BPDM.ExecuteABSQuery(Format('DELETE FROM TBReceipt WHERE receipt_no = %s;', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]), LResMsg) then
          raise Exception.Create(LResMsg);
        if not BPDM.RefreshReceipt(LResMsg) then
          raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '알림', '영수증 내역을 삭제하지 못하였습니다.' + _BR + ErrorString(LResMsg), ['확인']);
      end;

      RefreshAll;
      Global.ReceiptInfo.Clear;
      DispSaleResult;
      ClearMemberInfo;
      BPMsgBox(Self.Handle, mtInformation, '알림', '거래 내역 등록이 완료되었습니다.', ['확인'], 5);
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', '장애가 발생하여 거래 등록을 완료할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
    end;
  finally
    DispSaleResult;
    G1.Enabled := True;
    btnSaleComplete.Enabled := True;
    FWorking := False;
  end;
end;

procedure TBPSalePosForm.DoCancelPayment;
var
  PM: TPluginMessage;
  RI: TReceiptItemInfo;
  PI: TArray<TPaymentItemRec>;
  LReceiptJson, LResMsg: string;
  LManualApprove: Boolean;
begin
  with BPDM.QRPayment do
  try
    if not Locate('receipt_no', Global.ReceiptInfo.SelectedReceiptNo, []) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림', '영수증 내역이 존재하지 않습니다.' + _BR + '주문번호 ☞ ' + ErrorString(Global.ReceiptInfo.SelectedReceiptNo), ['확인']);
      Exit;
    end;

    SetLength(PI, 1);
    PI[0].Seq := FieldByName('seq').AsInteger;
    PI[0].PayMethod := FieldByName('pay_method').AsInteger;
    PI[0].IsApproval := False;
    PI[0].IsManualInput := FieldByName('manual_input_yn').AsBoolean;
    PI[0].VanCode := FieldByName('van_cd').AsString;
    PI[0].TID := FieldByName('tid').AsString;
    PI[0].ApproveNo := FieldByName('approve_no').AsString;
    PI[0].ApproveAmt := FieldByName('approve_amt').AsInteger;
    PI[0].OrgApproveNo := FieldByName('approve_no').AsString;
    PI[0].OrgApproveDate := FieldByName('trade_dt').AsString;
    PI[0].VAT := FieldByName('vat').AsInteger;
    PI[0].InstallMonth := FieldByName('inst_month').AsInteger;
    PI[0].CashEntity := FieldByName('cash_entity_div').AsInteger;
    PI[0].CardNo := FieldByName('card_no').AsString;
    PI[0].TradeNo := FieldByName('trade_no').AsString;
    PI[0].TradeDate := FieldByName('trade_dt').AsString;
    PI[0].IssuerCode := FieldByName('issuer_cd').AsString;
    PI[0].ISsuerName := FieldByName('issuer_nm').AsString;
    PI[0].BuyerDiv := FieldByName('buyer_div').AsString;
    PI[0].BuyerCode := FieldByName('buyer_cd').AsString;
    PI[0].BuyerName := FieldByName('buyer_nm').AsString;
    LManualApprove := PI[0].IsManualInput and (not PI[0].ApproveNo.IsEmpty);
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', IfThen(LManualApprove, '임의 등록으로 추가한 결제 건입니다.' + _BR, '') +
          '결제내역을 취소하시겠습니까?' + _BR + FieldByName('pay_method_nm').AsString + ' : ' + FormatCurr('#,##0', PI[0].ApproveAmt) + ' 원', ['예', '아니오']) = mrOK) then
    try
      case PI[0].PayMethod of
        //현금
        CO_PAYMENT_CASH:
          begin
            if PI[0].ApproveNo.IsEmpty then
            begin
              //현금영수증 미발행 결제 취소
              Global.ReceiptInfo.CashPayAmt := (Global.ReceiptInfo.CashPayAmt - PI[0].ApproveAmt);
              PayLog(Global.ReceiptInfo.SelectedReceiptNo, False, True, PI[0].PayMethod, '', '', PI[0].ApproveAmt);
            end
            else
            begin
              //현금영수증 발행 결제 취소
              if LManualApprove then
                Global.ReceiptInfo.CashPayAmt := (Global.ReceiptInfo.CashPayAmt - PI[0].ApproveAmt)
              else
              begin
                PM := TPluginMessage.Create(nil);
                try
                  PM.Command := CPC_INIT;
                  PM.AddParams(CPP_OWNER_ID, Self.PluginID);
                  PM.AddParams(CPP_APPROVAL_YN, False);
                  PM.AddParams(CPP_SALEMODE_YN, True);
                  PM.AddParams(CPP_RECEIPT_NO, Global.ReceiptInfo.SelectedReceiptNo);
                  PM.AddParams(CPP_APPROVAL_NO, PI[0].ApproveNo);
                  PM.AddParams(CPP_APPROVAL_DATE, PI[0].TradeDate);
                  PM.AddParams(CPP_APPROVAL_AMT, PI[0].ApproveAmt);
                  if (PluginManager.OpenModal('BPPaymentCash' + CO_DEFAULT_EXT_PLUGIN, PM) <> mrOK) then
                    Exit;
                finally
                  FreeAndNil(PM);
                end;
              end;
            end;
          end;
        //신용카드
        CO_PAYMENT_CARD:
          if LManualApprove then
            Global.ReceiptInfo.CardPayAmt := (Global.ReceiptInfo.CardPayAmt - PI[0].ApproveAmt)
          else
          begin
            PM := TPluginMessage.Create(nil);
            try
              PM.Command := CPC_INIT;
              PM.AddParams(CPP_OWNER_ID, Self.PluginID);
              PM.AddParams(CPP_APPROVAL_YN, False);
              PM.AddParams(CPP_SALEMODE_YN, True);
              PM.AddParams(CPP_RECEIPT_NO, Global.ReceiptInfo.SelectedReceiptNo);
              PM.AddParams(CPP_APPROVAL_NO, PI[0].ApproveNo);
              PM.AddParams(CPP_APPROVAL_DATE, PI[0].TradeDate);
              PM.AddParams(CPP_APPROVAL_AMT, PI[0].ApproveAmt);
              if (PluginManager.OpenModal('BPPaymentCard' + CO_DEFAULT_EXT_PLUGIN, PM) <> mrOK) then
                Exit;
            finally
              FreeAndNil(PM);
            end;
          end;
        //PAYCO
        CO_PAYMENT_PAYCO_CARD,
        CO_PAYMENT_PAYCO_COUPON,
        CO_PAYMENT_PAYCO_POINT:
          begin
            if not BPDM.DoPaymentPAYCO(False, True, LResMsg) then
              raise Exception.Create('PAYCO 거래 취소가 완료되지 못하였습니다!' + _CRLF + LResMsg);
            BPMsgBox(Self.Handle, mtInformation, '알림', 'PAYCO 거래 취소가 정상적으로 완료되었습니다.', ['확인'], 5);
          end;
      else
        raise Exception.Create(Format('%d는 인식할 수 없는 결제 수단 코드입니다.', [PI[0].PayMethod]));
      end;

      { 취소거래 영수증 출력 }
      RI.Clear;
      RI.ReceiptNo := Global.ReceiptInfo.SelectedReceiptNo;
      RI.SaleAmt := PI[0].ApproveAmt;
      RI.DCAmt := 0;
      RI.KeepAmt := 0;
      RI.Vat := 0;
      LReceiptJson := BPDM.MakeCancelReceiptJson(RI, PI, LResMsg);
      if not Global.ReceiptPrint.PaymentSlipPrint(PI[0].PayMethod, LReceiptJson, LResMsg) then
        BPMsgBox(0, mtWarning, '알림', '거래 취소 영수증을 출력할 수 없습니다!' + _BR + ErrorString(LResMsg), ['확인'], 5);

      { 해당 결제 건의 주문 상품을 미결제 상태로 복구 }
      if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET payment_seq = 0, payment_yn = False WHERE payment_seq = %d;', [PI[0].Seq]), LResMsg) then
        BPMsgBox(Self.Handle, mtError, '알림', '취소한 결제의 주문상품을 복구할 수 없습니다.' + _BR + ErrorString(LResMsg), ['확인'], 5);
      { 취소 완료된 결제내역 삭제 }
      if not BPDM.DeleteABSRecord('TBPayment', Format('seq = %d', [PI[0].Seq]), True, LResMsg) then
        BPMsgBox(Self.Handle, mtWarning, '알림', '취소한 결제 내역을 목록에서 삭제하지 못하였습니다.' + _BR + ErrorString(LResMsg), ['확인']);
      { 임의 등록 건 }
      if LManualApprove then
      begin
        PayLog(Global.ReceiptInfo.SelectedReceiptNo, False, True, PI[0].PayMethod, PI[0].CardNo, PI[0].ApproveNo, PI[0].ApproveAmt);
        BPMsgBox(Self.Handle, mtWarning, '주의', '임의 등록 결제 건을 취소 처리하였습니다!' + _BR +
          ErrorString('원거래 단말기에서 반드시 거래를 취소하여 주십시오.'), ['확인']);
      end;
      { 보류내역 처리 }
      if (RecordCount = 0) and
         (not Global.ReceiptInfo.PendingReceiptNo.IsEmpty) and
         (not BPDM.DeletePending(Global.ReceiptInfo.PendingReceiptNo, LResMsg)) then
        BPMsgBox(Self.Handle, mtWarning, '알림', '이전 보류내역을 삭제하지 못하였습니다.' + _BR +
           '보류내역 조회 화면에서 직접 삭제하여 주시기 바랍니다.' + _BR + ErrorString(LResMsg), ['확인']);
      Global.ReceiptInfo.CardPayAmt := 0;
      Global.ReceiptInfo.CashPayAmt := 0;
      if CheckDeleteReceipt(Global.ReceiptInfo.SelectedReceiptNo) then
        RefreshAll
      else
      begin
        RefreshPayment;
        if not BPDM.RefreshSaleItem(Global.ReceiptInfo.SelectedReceiptNo, LResMsg) then
          raise Exception.Create(LResMsg);
      end;
    finally
      V1.Controller.ClearSelection;
      DispSaleResult;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '장애가 발생하여 결제 내역을 취소할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPSalePosform.UpdatePaymentSeq;
var
  LPaymentSeq, LSaleSeq: Integer;
  LResMsg: string;
  SL: TStringList;
begin
  try
    SL := TStringList.Create;
    SL.Delimiter := ',';
    try
      LPaymentSeq := BPDM.GetABSMaxSeq('TBPayment');
      for var I: ShortInt := 0 to Pred(V1.ViewData.RecordCount) do
        if V1.ViewData.Rows[I].Selected then
        begin
          LSaleSeq := V1.ViewData.Rows[I].Values[V1.GetColumnByFieldName('seq').Index];
          SL.Add(LSaleSeq.ToString);
        end;

      //전체 상품을 결제한 경우가 아니라면 결제가 완료된 상품 내역에 결제 번호(Seq) 업데이트
      if (SL.Count > 0) and
         (V1.ViewData.RecordCount <> SL.Count) then
      begin
        if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET payment_seq = %d, payment_yn = True WHERE seq IN (%s);', [LPaymentSeq, SL.DelimitedText]), LResMsg) then
          raise Exception.Create(LResMsg);
        RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo);
      end;
    finally
      FreeAndnil(SL);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', '장애가 발생하여 주문 상품의 결제번호를 업데이트 할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

{ TPluContainer }

constructor TPluContainer.Create(AOwner: TComponent);
begin
  inherited;

  Self.AutoSize := False;
  Self.Caption := '';
  Self.Color := clWhite;
  Self.DoubleBuffered := True;
  Self.Font.Name := 'Pretendard Variable';
  Self.Font.Color := clWindowText;
  Self.Font.Size := 11;
  Self.Font.Style := [];
  Self.ParentColor := False;
  Self.ParentFont := False;
  Self.StyleElements := [seFont, seClient, seBorder];

  ProdNameLabel := TLabel.Create(Self);
  with ProdNameLabel do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Caption := '';
    if Global.Config.DarkMode then
      Color := $007A625D
    else
      Color := $00E6DBCF;
    Cursor := crHandPoint;
    EllipsisPosition := epEndEllipsis;
    Font.Color := clBlack;
    Font.Size := 11;
    Font.Style := [fsBold];
    Height := 30;
    Layout := tlCenter;
    ParentColor := False;
    ParentFont := False;
    ShowHint := True;
    StyleElements := [seFont];
    Transparent := True;
  end;

  ProdInfoLabel := TLabel.Create(Self);
  with ProdInfoLabel do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    Caption := '';
    if Global.Config.DarkMode then
      Color := $007A625D
    else
      Color := $00E6DBCF;
    Cursor := crHandPoint;
    Font.Color := clBlack;
    Font.Size := 11;
    Font.Style := [];
    Height := 25;
    Layout := tlCenter;
    ParentColor := False;
    ParentFont := False;
    ShowHint := True;
    StyleElements := [seFont];
    Transparent := True;
  end;

  ProdAmtLabel := TLabel.Create(Self);
  with ProdAmtLabel do
  begin
    Parent := Self;
    Align := alClient;
    Alignment := taCenter;
    AlignWithMargins := False;
    AutoSize := False;
    if Global.Config.DarkMode then
      Color := $007A625D
    else
      Color := $00E6DBCF;
    Cursor := crHandPoint;
    Font.Color := CO_COLOR_BASE_SELECT;
    Font.Size := 12;
    Font.Style := [fsBold];
    Height := 30;
    Layout := tlCenter;
    ParentColor := False;
    ParentFont := False;
    ShowHint := True;
    StyleElements := [];
    Transparent := True;
  end;
end;

destructor TPluContainer.Destroy;
begin

  inherited;
end;

procedure TPluContainer.SetActive(const AValue: Boolean);
begin
  if (FActive <> AValue) then
  begin
    FActive := AValue;
    Self.Visible := FActive;
    if not FActive then
    begin
      ProdNameLabel.Caption := '';
      ProdInfoLabel.Caption := '';
      ProdAmtLabel.Caption := '';
    end;
  end;
end;

procedure TPluContainer.SetProdName(const AValue: string);
begin
  if (FProdName <> AValue) then
  begin
    FProdName := AValue;
    ProdNameLabel.Caption := FProdName;
  end;
end;

procedure TPluContainer.SetProdInfo(const AValue: string);
begin
  if (FProdInfo <> AValue) then
  begin
    FProdInfo := AValue;
    ProdInfoLabel.Caption := FProdInfo;
  end;
end;

procedure TPluContainer.SetProdAmt(const AValue: Integer);
begin
  if (FProdAmt <> AValue) then
  begin
    FProdAmt := AValue;
    if (FProdAmt = 0) then
      ProdAmtLabel.Caption := '무료'
    else
      ProdAmtLabel.Caption := FormatCurr('#,##0', FProdAmt);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPSalePosForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
