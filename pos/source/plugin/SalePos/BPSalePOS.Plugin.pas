(*******************************************************************************

  Project     : ������ POS �ý���
  Title       : �Ǹ� ���� �÷�����
  Author      : �̼���
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2023 All rights reserved.

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

    //ȸ�� ��ǰ ���Ž� ���
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
  FBaseTitle := '�Ǹ� ����';
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

  tabCoupon.TabVisible := False; //���� ����
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '������ ��ȣ�� ��ȸ�� �� �����ϴ�.' + _BR + ErrorString(LResMsg), ['Ȯ��'], 5);
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
        BaseTitle := Format('%s [%d ����]', [Self.Caption, Global.LaneInfo.SelectedLaneNo]);
        Break;
      end;
    RefreshSelectedLaneGroup;
  end
  else
  begin
    btnGeneralLane.Down := True;
    Global.LaneInfo.SelectedLaneNo := 0;
    BaseTitle := Format('%s [�Ϲ� �Ǹ�]', [Self.Caption]);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ��ǰ ������ ��ȸ�� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '���� ������ ��ȸ�� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      raise Exception.Create(Format('%d(%d)�� ����� �� ���� ���� ��ȣ�Դϴ�.', [LAssignLaneNo, Global.LaneInfo.SelectedLaneNo]));
    //����ȸ���ǰ� ��Ŀ ��ǰ�� ȸ�� ���� �ʼ�
    if ((FPluItems[AIndex].ProdDiv = CO_PROD_MEMBERSHIP) or (FPluItems[AIndex].ProdDiv = CO_PROD_LOCKER)) and
       FSelectedMemberNo.IsEmpty and
       (ShowMemberPopup(Self.PluginID, '', 0, CO_DATA_MODE_SELECT, CO_SEARCH_MEMBER_NAME, edtMemberName.Text, CO_SEARCH_TEL_NO, edtMemberTelNo.Text) <> mrOK) then
      raise Exception.Create('ȸ�� ���� ��ǰ�Դϴ�.' + _BR + '�Ǹ��� ��� ȸ���� ���� �����Ͽ� �ֽʽÿ�.');

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

    //����ȸ����
    if (PI.ProdDiv = CO_PROD_GAME) then
    begin
      with TBPInputStartDateForm.Create(nil) do
      try
        ProdName := PI.ProdName;
        if (ShowModal <> mrOK) then
          raise Exception.Create('�̿� �������� �ԷµǾ�� �մϴ�.');
        PI.UseStartDate := FormatDateTime('yyyy-mm-dd', SelectedDate);
      finally
        Free;
      end;
    end
    //��Ŀ ��ǰ
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
        PI.OrderQty := PI.PurchaseMonth; //��Ŀ ��ǰ�� �̿� �������� ��ǰ ���ż�����(200230725)
      end
      else if (PI.ProdDetailDiv = CO_PROD_DETAIL_KEEPAMT) then
        PI.KeepAmt := FPluItems[AIndex].ProdAmt;
    end;
    V1.Controller.ClearSelection;
    //��ǰ �ֹ� ������ �߰�
    if not BPDM.UpdateSaleItem(Global.ReceiptInfo.SelectedReceiptNo, PI, LResMsg) then
      raise Exception.Create(LResMsg);
    RefreshSaleData(Global.ReceiptInfo.SelectedReceiptNo, PI.ProdCode);
    if not RefreshReceiptNoList(LResMsg) then
      raise Exception.Create(LResMsg);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ��ǰ ��Ͽ� �����Ͽ����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ��ǰ�� ������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '�ֹ� ������ ������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ǰ ������ ����/������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ǰ ���񽺸� ����/������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
        raise Exception.Create('����Ʈ�� ����� ȸ�� ������ �����Ͽ� �ֽʽÿ�.');
      if (Global.MemberInfo.SavePoint < LInputValue) then
        raise Exception.Create('ȸ���� ������ ����Ʈ�� �����մϴ�.');
      LSeq := FieldByName('seq').AsInteger;
      LProdCode := FieldByName('prod_cd').AsString;
      LChargeAmt := FieldByName('calc_charge_amt').AsInteger;
      if (LInputValue > LChargeAmt) then
      begin
        BPMsgBox(Self.Handle, mtInformation, '�˸�', 'ȸ���� ������ ����Ʈ�� �����Ͽ� ������ ����մϴ�.', ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtWarning, '�˸�', '����Ʈ ��� ������ ������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '������ ������ ������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      PM.AddParams(CPP_VALUE, Format('��Ŀȸ�� �� %s(%s)%s', [Global.MemberInfo.MemberName, Global.MemberInfo.MemberNo, IfThen(Global.MemberInfo.LockerList.IsEmpty, '', ' : ' + Global.MemberInfo.LockerList)]));
      if (PluginManager.OpenModal(Global.Plugin.LockerViewPlugin, PM) <> mrOK) then
        raise Exception.Create('�̿��� ��Ŀ ������ ���õ��� �ʾҽ��ϴ�.');
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
      raise Exception.Create('������ ��ȣ�� �����ϴ�.');
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ǰ ������ ������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
    BaseTitle := Format('%s [%d ����]', [Self.Caption, Global.LaneInfo.SelectedLaneNo]);
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
    BaseTitle := Format('%s [%d ����]', [Self.Caption, Global.LaneInfo.SelectedLaneNo]);
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
            FPluItems[I].ProdInfo := FPluItems[I].ProdInfo + _CRLF + '��� �Ұ�';
        end
        else if (FPluItems[I].ProdDiv = CO_PROD_LOCKER) and
                (FPluItems[I].ProdDetailDiv = CO_PROD_DETAIL_LOCKER) then
          FPluItems[I].ProdInfo := Trim(Format('%s %s', [Items[AGroupIndex, LItem].LockerLayerName, Items[AGroupIndex, LItem].SexDivName]))
        else if (FPluItems[I].ProdDiv = CO_PROD_MEMBERSHIP) then
        begin
          if (FPluItems[I].ProdDetailDiv = CO_PROD_DETAIL_MEMBER_GAME) then
            FPluItems[I].ProdInfo := Format('%d ����', [Items[AGroupIndex, LItem].UseGameCount])
          else if (FPluItems[I].ProdDetailDiv = CO_PROD_DETAIL_MEMBER_TIME) then
          begin
            LHour := (Items[AGroupIndex, LItem].UseGameMin div 60);
            LMin := (Items[AGroupIndex, LItem].UseGameMin mod 60);
            if (LHour > 0) then
              FPluItems[I].ProdInfo := Format('%d �ð�', [LHour]);
            if (LMin > 0) then
              FPluItems[I].ProdInfo := Trim(FPluItems[I].ProdInfo + Format(' %d ��', [LMin]));
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
      //���� ������ �Ұ��� ���ӿ���� ��ǰ�� ��Ŀ ��ǰ�� �۲� ������ �ٸ��� ǥ��
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
  V1.Bands[0].Caption := Format('�ֹ����� �� %s', [V1.DataController.DataSet.FieldByName('receipt_no').AsString]);
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
     (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', Format('����(üũ)�� ��ǰ %d ���� �����Ͻðڽ��ϱ�?', [LCount]), ['��', '�ƴϿ�']) <> mrOk) then
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
      BPMsgBox(Self.Handle, mtInformation, '�˸�', '������ ��ǰ�� �����Ͽ����ϴ�.' + _BR + '����� ������ ������ ��Ͽ� ǥ�õ� �� �ֽ��ϴ�.', ['Ȯ��'], 5);
      SendToMainForm(CPC_SALE_REFRESH_LANE, Global.LaneInfo.SelectedLaneNo);
    finally
      FreeAndNil(SL);
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� ������ ��ǰ�� ������ �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
         (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', '�ֹ� ������ 1���� ��ǰ�� ���ҽ�Ű�� �ֹ� ��Ͽ��� ������ �˴ϴ�.' + _BR + '��� �����Ͻðڽ��ϱ�?', ['��', '�ƴϿ�']) <> mrOk) then
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
      if (LInputValue > 100) then //100% �̻��� �Է� �Ұ�
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
        BPMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
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
        BPMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtWarning, '�˸�', 'ȸ�� ������ ��ȸ�� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtWarning, '�˸�', '������ ������ �������� �ʽ��ϴ�.' + _BR + '�ֹ���ȣ �� ' + ErrorString(Global.ReceiptInfo.SelectedReceiptNo), ['Ȯ��']);
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
        raise Exception.Create('��ǰ �ݾ��� ������ �Ϸ���� �ʾҽ��ϴ�.' + _BR + '�̰����ݾ�: ' + FormatCurr('#,##0', Global.ReceiptInfo.UnPaidAmt));
      if (V1.Controller.SelectedRowCount = 0) then
        raise Exception.Create('������ ��ǰ�� ���õ��� �ʾҽ��ϴ�.');

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

      { ���� ������ ���� �Ϸ� ó�� ��û }
      try
        for var I:ShortInt := 0 to High(SL) do
          if (SL[I].ProdDiv = CO_PROD_GAME) and
             not BPDM.SetPaymentType(SL[I].AssignNo, SL[I].BowlerId, CO_PAYTYPE_PREPAID, LResMsg) then
            raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtError, '�˸�', '���� �Ϸ� ó���� ��ְ� �߻��Ͽ����ϴ�.' + _BR + '���� ���� �� ���� ��Ͽ��� �ٽ� �õ��Ͽ� �ֽʽÿ�.' + _BR + ErrorString(E.Message), ['Ȯ��']);
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
          BPMsgBox(Self.Handle, mtError, '�˸�', '������/����ǥ ��¿� ��ְ� �߻��߽��ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
      end;

      { ���� ���� ���� }
      try
        if (not Global.ReceiptInfo.PendingReceiptNo.IsEmpty) and
           not BPDM.DeletePending(Global.ReceiptInfo.PendingReceiptNo, LResMsg) then
          raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '�˸�', '���� ������ �������� ���Ͽ����ϴ�.' + _BR + '�������� ��ȸ ȭ�鿡�� ���� �����Ͽ� �ֽñ� �ٶ��ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��']);
      end;
      { �ֹ� ���� ���� }
      try
        if not BPDM.DeleteABSRecord('TBSaleItem', Format('receipt_no = %s', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]), False, LResMsg) then
          raise Exception.Create(LResMsg)
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '�˸�', '�ֹ� ������ �������� ���Ͽ����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��']);
      end;
      { ���� ���� ���� }
      try
        if not BPDM.DeleteABSRecord('TBPayment', Format('receipt_no = %s', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]), False, LResMsg) then
          raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '�˸�', '���� ������ �������� ���Ͽ����ϴ�.' + _BR + ErrorString(LResMsg), ['Ȯ��']);
      end;
      { ������ ���� ���� }
      try
        if not BPDM.ExecuteABSQuery(Format('DELETE FROM TBReceipt WHERE receipt_no = %s;', [Global.ReceiptInfo.SelectedReceiptNo.QuotedString]), LResMsg) then
          raise Exception.Create(LResMsg);
        if not BPDM.RefreshReceipt(LResMsg) then
          raise Exception.Create(LResMsg);
      except
        on E: Exception do
          BPMsgBox(Self.Handle, mtWarning, '�˸�', '������ ������ �������� ���Ͽ����ϴ�.' + _BR + ErrorString(LResMsg), ['Ȯ��']);
      end;

      RefreshAll;
      Global.ReceiptInfo.Clear;
      DispSaleResult;
      ClearMemberInfo;
      BPMsgBox(Self.Handle, mtInformation, '�˸�', '�ŷ� ���� ����� �Ϸ�Ǿ����ϴ�.', ['Ȯ��'], 5);
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� �ŷ� ����� �Ϸ��� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      BPMsgBox(Self.Handle, mtWarning, '�˸�', '������ ������ �������� �ʽ��ϴ�.' + _BR + '�ֹ���ȣ �� ' + ErrorString(Global.ReceiptInfo.SelectedReceiptNo), ['Ȯ��']);
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
    if (BPMsgBox(Self.Handle, mtConfirmation, 'Ȯ��', IfThen(LManualApprove, '���� ������� �߰��� ���� ���Դϴ�.' + _BR, '') +
          '���������� ����Ͻðڽ��ϱ�?' + _BR + FieldByName('pay_method_nm').AsString + ' : ' + FormatCurr('#,##0', PI[0].ApproveAmt) + ' ��', ['��', '�ƴϿ�']) = mrOK) then
    try
      case PI[0].PayMethod of
        //����
        CO_PAYMENT_CASH:
          begin
            if PI[0].ApproveNo.IsEmpty then
            begin
              //���ݿ����� �̹��� ���� ���
              Global.ReceiptInfo.CashPayAmt := (Global.ReceiptInfo.CashPayAmt - PI[0].ApproveAmt);
              PayLog(Global.ReceiptInfo.SelectedReceiptNo, False, True, PI[0].PayMethod, '', '', PI[0].ApproveAmt);
            end
            else
            begin
              //���ݿ����� ���� ���� ���
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
        //�ſ�ī��
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
              raise Exception.Create('PAYCO �ŷ� ��Ұ� �Ϸ���� ���Ͽ����ϴ�!' + _CRLF + LResMsg);
            BPMsgBox(Self.Handle, mtInformation, '�˸�', 'PAYCO �ŷ� ��Ұ� ���������� �Ϸ�Ǿ����ϴ�.', ['Ȯ��'], 5);
          end;
      else
        raise Exception.Create(Format('%d�� �ν��� �� ���� ���� ���� �ڵ��Դϴ�.', [PI[0].PayMethod]));
      end;

      { ��Ұŷ� ������ ��� }
      RI.Clear;
      RI.ReceiptNo := Global.ReceiptInfo.SelectedReceiptNo;
      RI.SaleAmt := PI[0].ApproveAmt;
      RI.DCAmt := 0;
      RI.KeepAmt := 0;
      RI.Vat := 0;
      LReceiptJson := BPDM.MakeCancelReceiptJson(RI, PI, LResMsg);
      if not Global.ReceiptPrint.PaymentSlipPrint(PI[0].PayMethod, LReceiptJson, LResMsg) then
        BPMsgBox(0, mtWarning, '�˸�', '�ŷ� ��� �������� ����� �� �����ϴ�!' + _BR + ErrorString(LResMsg), ['Ȯ��'], 5);

      { �ش� ���� ���� �ֹ� ��ǰ�� �̰��� ���·� ���� }
      if not BPDM.ExecuteABSQuery(Format('UPDATE TBSaleItem SET payment_seq = 0, payment_yn = False WHERE payment_seq = %d;', [PI[0].Seq]), LResMsg) then
        BPMsgBox(Self.Handle, mtError, '�˸�', '����� ������ �ֹ���ǰ�� ������ �� �����ϴ�.' + _BR + ErrorString(LResMsg), ['Ȯ��'], 5);
      { ��� �Ϸ�� �������� ���� }
      if not BPDM.DeleteABSRecord('TBPayment', Format('seq = %d', [PI[0].Seq]), True, LResMsg) then
        BPMsgBox(Self.Handle, mtWarning, '�˸�', '����� ���� ������ ��Ͽ��� �������� ���Ͽ����ϴ�.' + _BR + ErrorString(LResMsg), ['Ȯ��']);
      { ���� ��� �� }
      if LManualApprove then
      begin
        PayLog(Global.ReceiptInfo.SelectedReceiptNo, False, True, PI[0].PayMethod, PI[0].CardNo, PI[0].ApproveNo, PI[0].ApproveAmt);
        BPMsgBox(Self.Handle, mtWarning, '����', '���� ��� ���� ���� ��� ó���Ͽ����ϴ�!' + _BR +
          ErrorString('���ŷ� �ܸ��⿡�� �ݵ�� �ŷ��� ����Ͽ� �ֽʽÿ�.'), ['Ȯ��']);
      end;
      { �������� ó�� }
      if (RecordCount = 0) and
         (not Global.ReceiptInfo.PendingReceiptNo.IsEmpty) and
         (not BPDM.DeletePending(Global.ReceiptInfo.PendingReceiptNo, LResMsg)) then
        BPMsgBox(Self.Handle, mtWarning, '�˸�', '���� ���������� �������� ���Ͽ����ϴ�.' + _BR +
           '�������� ��ȸ ȭ�鿡�� ���� �����Ͽ� �ֽñ� �ٶ��ϴ�.' + _BR + ErrorString(LResMsg), ['Ȯ��']);
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� ���� ������ ����� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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

      //��ü ��ǰ�� ������ ��찡 �ƴ϶�� ������ �Ϸ�� ��ǰ ������ ���� ��ȣ(Seq) ������Ʈ
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
      BPMsgBox(Self.Handle, mtError, '�˸�', '��ְ� �߻��Ͽ� �ֹ� ��ǰ�� ������ȣ�� ������Ʈ �� �� �����ϴ�.' + _BR + ErrorString(E.Message), ['Ȯ��'], 5);
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
      ProdAmtLabel.Caption := '����'
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
