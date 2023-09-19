(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 거래내역 조회 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPReceiptView.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Data.DB, Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh,
  { DevExppress }
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxLabel, cxCurrencyEdit, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView, cxGrid,
  cxGridDBBandedTableView, cxGridLevel, cxClasses, cxGridCustomView, cxButtonEdit;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPReceiptViewForm = class(TPluginModule)
    panHeader: TPanel;
    panMaster: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    panDetail: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    L1: TcxGridLevel;
    G2: TcxGrid;
    V2: TcxGridDBBandedTableView;
    L2: TcxGridLevel;
    panSearch: TPanel;
    btnRefresh: TBitBtn;
    lblSaleDate: TLabel;
    dsrReceiptList: TDataSource;
    dsrSaleItemList: TDataSource;
    dsrCouponList: TDataSource;
    dsrPaymentList: TDataSource;
    edtSearchReceiptNo: TDBEditEh;
    btnReprintReceipt: TBitBtn;
    V1calc_cancel_yn: TcxGridDBBandedColumn;
    V1receipt_no: TcxGridDBBandedColumn;
    V1calc_sale_root_div: TcxGridDBBandedColumn;
    V1order_nm: TcxGridDBBandedColumn;
    V1sale_amt: TcxGridDBBandedColumn;
    V1calc_dc_amt: TcxGridDBBandedColumn;
    V1charge_amt: TcxGridDBBandedColumn;
    V1sale_tm: TcxGridDBBandedColumn;
    V1pos_no: TcxGridDBBandedColumn;
    V1user_id: TcxGridDBBandedColumn;
    V2calc_assign_lane_no: TcxGridDBBandedColumn;
    V2calc_prod_div: TcxGridDBBandedColumn;
    V2prod_nm: TcxGridDBBandedColumn;
    V2bowler_id: TcxGridDBBandedColumn;
    V2member_nm: TcxGridDBBandedColumn;
    V2prod_amt: TcxGridDBBandedColumn;
    V2order_qty: TcxGridDBBandedColumn;
    V2calc_sale_amt: TcxGridDBBandedColumn;
    V2dc_amt: TcxGridDBBandedColumn;
    V2calc_charge_amt: TcxGridDBBandedColumn;
    splMainGrid: TSplitter;
    splSubGrid: TSplitter;
    G3: TcxGrid;
    V3: TcxGridDBBandedTableView;
    V3Column1: TcxGridDBBandedColumn;
    V3Column2: TcxGridDBBandedColumn;
    V3Column3: TcxGridDBBandedColumn;
    V3Column4: TcxGridDBBandedColumn;
    V3Column5: TcxGridDBBandedColumn;
    V3Column6: TcxGridDBBandedColumn;
    L3: TcxGridLevel;
    panPayment: TPanel;
    G4: TcxGrid;
    V4: TcxGridDBBandedTableView;
    V4calc_approval_yn: TcxGridDBBandedColumn;
    V4calc_pay_method: TcxGridDBBandedColumn;
    V4card_no: TcxGridDBBandedColumn;
    V4inst_month: TcxGridDBBandedColumn;
    V4approve_no: TcxGridDBBandedColumn;
    V4issuer_nm: TcxGridDBBandedColumn;
    V4approve_amt: TcxGridDBBandedColumn;
    V4refund_button: TcxGridDBBandedColumn;
    L4: TcxGridLevel;
    panPaymentMemo: TPanel;
    lblCancelMemo: TLabel;
    mmoPaymentMemo: TDBMemoEh;
    V4calc_cancel_count: TcxGridDBBandedColumn;
    edtSearchDate: TDBDateTimeEditEh;
    V1sale_memo: TcxGridDBBandedColumn;
    V1cancel_cnt: TcxGridDBBandedColumn;
    V4cash_receipt_button: TcxGridDBBandedColumn;
    btnCancelReceipt: TBitBtn;
    V4approval_yn: TcxGridDBBandedColumn;
    V2use_point: TcxGridDBBandedColumn;
    V1use_point: TcxGridDBBandedColumn;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnReprintReceiptClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure V1CustomDrawIndicatorCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
    procedure V4CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V4refund_buttonPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure V4DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
    procedure V4FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V4cash_receipt_buttonPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure btnCancelReceiptClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBaseTitle: string;
    FWorking: Boolean;
    FApproveNo: string;
    FCancelCount: ShortInt;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure RefreshSaleList;
    function RefreshSaleDetailList(const AReceiptNo: string): Boolean;
    procedure DoCancelPayment;
    procedure DoCancelReceipt(const AReceiptNo: string; const AShowMsg: Boolean=False);
    procedure DoReIssueReceipt;
    procedure DoReqCashReceipt;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  System.Variants, Vcl.Dialogs,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.BPMsgBox, BPCashReceiptPopup;

{$R *.dfm}

{ TBPReceiptViewForm }

constructor TBPReceiptViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOwnerId := 0;
  FBaseTitle := panHeader.Caption;
  FWorking := False;
  FApproveNo := '';
  FCancelCount := 0;

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  panHeader.Visible := False;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  Global.Title := FBaseTitle;
  edtSearchDate.Value := Now;
  G3.Enabled := False;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPReceiptViewForm.Destroy;
begin

  inherited Destroy;
end;

procedure TBPReceiptViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Global.Plugin.ReceiptViewPluginId := 0;
  Action := caFree;
end;

procedure TBPReceiptViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPReceiptViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_RECEIPT_VIEW);
    RefreshSaleList;
  end
  else if (AMsg.Command = CPC_ACTIVE) then
  begin
    if (Self.Align = alClient) then
      Self.BringToFront
    else
      SetForegroundWindow(Self.Handle);
    Global.Title := FBaseTitle;
    SendToMainForm(CPC_SELECT_MENU_ITEM, CO_MENU_RECEIPT_VIEW);
    RefreshSaleList;
  end
  else if (AMsg.Command = CPC_CLOSE) then
    Self.Close;
end;

procedure TBPReceiptViewForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPReceiptViewForm.btnCancelReceiptClick(Sender: TObject);
begin
  if FWorking then
    Exit;
  DoCancelReceipt('', True);
end;

procedure TBPReceiptViewForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPReceiptViewForm.btnRefreshClick(Sender: TObject);
begin
  RefreshSaleList;
end;

procedure TBPReceiptViewForm.btnReprintReceiptClick(Sender: TObject);
begin
//
end;

procedure TBPReceiptViewForm.V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  LRect: TRect;
  LCancelCount: Integer;
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('calc_cancel_yn').Index] = '취소') then
    ACanvas.Font.Color := $00544ED6
  else
  begin
    LCancelCount := AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('cancel_cnt').Index];
    if (LCancelCount > 0) then
    begin
      ACanvas.Font.Color := $00FF8000;
      if not AViewInfo.GridRecord.Focused then
        ACanvas.FillRect(LRect, $0080FFFF); // ACanvas.Brush.Color := clYellow;
    end;
  end;
end;

procedure TBPReceiptViewForm.V1CustomDrawIndicatorCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
begin
//  if TcxGridIndicatorRowItemViewInfo(AViewInfo).GridRecord.Focused then
//    AViewInfo.LookAndFeelPainter.DrawIndicatorItem(ACanvas, AViewInfo.Bounds, ikArrow, $FFFFFFF);
end;

procedure TBPReceiptViewForm.V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  with V1.DataController.DataSet do
  begin
    btnCancelReceipt.Enabled := (not FieldByName('cancel_yn').AsBoolean) and (FieldByName('approval_cnt').AsInteger = FieldByName('cancel_cnt').AsInteger);
    RefreshSaleDetailList(V1.DataController.DataSet.FieldByName('receipt_no').AsString);
  end;
end;

procedure TBPReceiptViewForm.V4cash_receipt_buttonPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  DoReqCashReceipt;
end;

procedure TBPReceiptViewForm.V4CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBBandedTableView(Sender).GetColumnByFieldName('approval_yn').Index] = False) then
    ACanvas.Font.Color := $00544ED6;
end;

procedure TBPReceiptViewForm.V4refund_buttonPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  DoCancelPayment;
end;

procedure TBPReceiptViewForm.V4DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
begin
  with V4.DataController.Summary do
    FCancelCount := StrToIntDef(VarToStr(FooterSummaryValues[FooterSummaryItems.IndexOfItemLink(V4refund_button)]), 0);
end;

procedure TBPReceiptViewForm.V4FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  with V4.DataController.DataSet do
    mmoPaymentMemo.ReadOnly := (not FieldByName('approval_yn').AsBoolean);
end;

procedure TBPReceiptViewForm.RefreshSaleList;
var
  LSaleDate, LResMsg: string;
begin
  if FWorking then
    Exit;
  FWorking := True;
  Screen.Cursor := crSQLWait;
  try
    LSaleDate := FormatDateTime('yyyymmdd', edtSearchDate.Value);
    try
      if not BPDM.GetSaleList(LSaleDate, LSaleDate, '', LResMsg) then
        raise Exception.Create(LResMsg);
      with V1.DataController.DataSet do
        if (RecordCount > 0) then
        begin
          btnCancelReceipt.Enabled := (not FieldByName('cancel_yn').AsBoolean) and (FieldByName('approval_cnt').AsInteger = FieldByName('cancel_cnt').AsInteger);
          if not RefreshSaleDetailList(V1.DataController.DataSet.FieldByName('receipt_no').AsString) then
            Exit;
        end;
    finally
      Screen.Cursor := crDefault;
      FWorking := False;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '거래 내역을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

function TBPReceiptViewForm.RefreshSaleDetailList(const AReceiptNo: string): Boolean;
var
  LResMsg: string;
begin
  Screen.Cursor := crSQLWait;
  Result := False;
  try
    try
      if not BPDM.GetSaleDetailList(AReceiptNo, LResMsg) then
        raise Exception.Create(LResMsg);
      with V4.DataController.DataSet do
        if (RecordCount > 0) then
          mmoPaymentMemo.ReadOnly := (not FieldByName('approval_yn').AsBoolean);
      Result := True;
    finally
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림', '거래 상세 내역을 조회할 수 없습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPReceiptViewForm.DoCancelPayment;
var
  PM: TPluginMessage;
  RI: TReceiptItemInfo;
  PL: TArray<TPaymentItemRec>;
  LReceiptNo, LResMsg, LReceiptJson: string;
  LPaymentCount: Integer;
begin
  if FWorking then
    Exit;
  FWorking := True;
  LResMsg := '';
  try
    try
      with BPDM.QRPaymentList do
      begin
        if (RecordCount = 0) or
           not FieldByName('approval_yn').AsBoolean then
          Exit;
        LReceiptNo := FieldByName('receipt_no').AsString;
        LPaymentCount := RecordCount;
        SetLength(PL, 1);
        PL[0].Clear;
        PL[0].Seq := FieldByName('seq').AsInteger;
        PL[0].ReceiptNo := LReceiptNo;
        PL[0].PaySeq := FieldByName('pay_seq').AsInteger;
        PL[0].PayMethod := FieldByName('pay_method').AsInteger;
        PL[0].IsApproval := FieldByName('approval_yn').AsBoolean;
        PL[0].IsManualInput := FieldByName('manual_input_yn').AsBoolean;
        PL[0].VanCode := FieldByName('van_cd').AsString;
        PL[0].TID := FieldByName('tid').AsString;
        PL[0].ApproveNo := FieldByName('approve_no').AsString;
        PL[0].ApproveAmt := FieldByName('approve_amt').AsInteger;
        PL[0].OrgApproveNo := FieldByName('approve_no').AsString;
        PL[0].OrgApproveDate := FieldByName('trade_dt').AsString;
        PL[0].VAT := FieldByName('vat').AsInteger;
        PL[0].InstallMonth := FieldByName('inst_month').AsInteger;
        PL[0].CashEntity := FieldByName('cash_entity_div').AsInteger;
        PL[0].CardNo := FieldByName('card_no').AsString;
        PL[0].TradeNo := FieldByName('trade_no').AsString;
        PL[0].TradeDate := FieldByName('trade_dt').AsString;
        PL[0].IssuerCode := FieldByName('issuer_cd').AsString;
        PL[0].ISsuerName := FieldByName('issuer_nm').AsString;
        PL[0].BuyerDiv := FieldByName('buyer_div').AsString;
        PL[0].BuyerCode := FieldByName('buyer_cd').AsString;
        PL[0].BuyerName := FieldByName('buyer_nm').AsString;
        PL[0].PaymentMemo := mmoPaymentMemo.Text;
      end;

      case PL[0].PayMethod of
        CO_PAYMENT_CARD: //신용카드
          if not PL[0].IsManualInput then
          begin
            PM := TPluginMessage.Create(nil);
            try
              PM.Command := CPC_INIT;
              PM.AddParams(CPP_OWNER_ID, Self.PluginID);
              PM.AddParams(CPP_APPROVAL_YN, False);
              PM.AddParams(CPP_SALEMODE_YN, False);
              PM.AddParams(CPP_RECEIPT_NO, LReceiptNo);
              PM.AddParams(CPP_APPROVAL_NO, PL[0].ApproveNo);
              PM.AddParams(CPP_APPROVAL_DATE, PL[0].TradeDate);
              PM.AddParams(CPP_APPROVAL_AMT, PL[0].ApproveAmt);
              if (PluginManager.OpenModal('BPPaymentCard' + CO_DEFAULT_EXT_PLUGIN, PM) <> mrOK) then
                Exit;
            finally
              FreeAndNil(PM);
            end;
          end;
        CO_PAYMENT_CASH: //현금
          if PL[0].OrgApproveNo.IsEmpty then
          begin
            if (BPMsgBox(Self.Handle, mtConfirmation, '확인', '선택한 현금 거래 내역을 취소하시겠습니까?', ['예', '아니오']) <> mrOK) then
              Exit;
            FApproveNo := '';
          end
          else
          begin
            if not PL[0].IsManualInput then
            begin
              // 현금영수증 발행 결제 취소
              PM := TPluginMessage.Create(nil);
              try
                PM.Command := CPC_INIT;
                PM.AddParams(CPP_OWNER_ID, Self.PluginID);
                PM.AddParams(CPP_APPROVAL_YN, False);
                PM.AddParams(CPP_SALEMODE_YN, False);
                PM.AddParams(CPP_RECEIPT_NO, LReceiptNo);
                PM.AddParams(CPP_APPROVAL_NO, PL[0].ApproveNo);
                PM.AddParams(CPP_APPROVAL_DATE, PL[0].TradeDate);
                PM.AddParams(CPP_APPROVAL_AMT, PL[0].ApproveAmt);
                PM.AddParams(CPP_CASH_ENTITY_DIV, PL[0].CashEntity);
                if (PluginManager.OpenModal('BPPaymentCash' + CO_DEFAULT_EXT_PLUGIN, PM) <> mrOK) then
                  Exit;
              finally
                FreeAndNil(PM);
              end;
            end;
          end;
        CO_PAYMENT_PAYCO_CARD: //PAYCO(카드)
          begin
            if not BPDM.DoPaymentPAYCO(False, False, LResMsg) then
              raise Exception.Create('PAYCO 환불이 완료되지 못하였습니다.' + _BR + ErrorString(LResMsg));
            BPMsgBox(0, mtInformation, '알림', 'PAYCO 환불이 완료되었습니다.', ['확인'], 5);
          end;
      else
        BPMsgBox(0, mtWarning, '알림', '환불할 수 없는 결제 내역입니다.', ['확인'], 5);
        Exit;
      end;

      { 거래수단별 취소 처리 }
      if not BPDM.PostCancelPaymentPartial(PL[0], FApproveNo, LResMsg) then
        raise Exception.Create('환불 작업이 완료되지 못하였습니다.' + _BR + ErrorString(LResMsg));

      if PL[0].IsManualInput then
      begin
        PayLog(LReceiptNo, False, PL[0].IsManualInput, PL[0].PayMethod, PL[0].CardNo, PL[0].ApproveNo, PL[0].ApproveAmt);
        BPMsgBox(0, mtWarning, '주의', '임의 등록 결제 건을 환불 처리하였습니다.' + _BR +
          ErrorString('원거래 단말기에서도 반드시 취소를 진행하여 주십시오.'), ['확인']);
      end;

      if not BPDM.UpdateCancelPaymentList(PL[0], FApproveNo, LResMsg) then
        BPMsgBox(0, mtConfirmation, '주의', '환불 처리는 완료하였으나 로컬 데이터베이스에 업데이트 하지 못하였습니다.' + _BR +
          '거래 내역을 다시 조회하여 주십시오.' + _BR + ErrorString(LResMsg), ['확인'], 5);

      RefreshSaleDetailList(LReceiptNo);
      if (LPaymentCount = FCancelCount) then
      begin
        FWorking := False;
        RefreshSaleList;
        DoCancelReceipt(LReceiptNo);
      end
      else
      begin
        LReceiptJson := BPDM.MakeCancelReceiptJson(RI, PL, LResMsg);
        if not Global.ReceiptPrint.PaymentSlipPrint(PL[0].PayMethod, LReceiptJson, LResMsg) then
          BPMsgBox(0, mtWarning, '알림', '환불 영수증을 출력할 수 없습니다.' + _BR + ErrorString(LResMsg), ['확인'], 5);
        if (LPaymentCount > 1) then
          BPMsgBox(Self.Handle, mtWarning, '주의', '모든 복합 결제 건을 취소하지 않으면 영수증이 취소 처리되지 않습니다.', ['확인']);
        RefreshSaleDetailList(LReceiptNo);
        BPMsgBox(Self.Handle, mtInformation, '알림', '환불 처리가 완료되었습니다.', ['확인'], 5);
      end;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    FWorking := False;
  end;
end;

procedure TBPReceiptViewForm.DoCancelReceipt(const AReceiptNo: string; const AShowMsg: Boolean);
var
  PL: TArray<TPaymentItemRec>;
  LNewReceiptNo, LOrgReceiptNo, LResMsg: string;
  LIndex: ShortInt;
begin
  LResMsg := '';
  try
    with BPDM.QRReceiptList do
    begin
      if (not AReceiptNo.IsEmpty) and
         not Locate('receipt_no', AReceiptNo, []) then
        raise Exception.Create(Format('영수증번호 [%s]의 내역이 존재하지 않습니다.', [AReceiptNo]));
      if (FieldByName('sale_root_div').AsString = CO_CLIENT_MOBILE) then
        raise Exception.Create('모바일에서 결제한 내역은 취소 처리가 불가합니다.');
      if FieldByName('cancel_yn').AsBoolean then
        raise Exception.Create('이미 취소된 거래입니다.');
      if (FieldByName('approval_cnt').AsInteger <> FieldByName('cancel_cnt').AsInteger) then
        raise Exception.Create('거래 내역에 대한 환불 처리가 완료되지 않았습니다.');
      LOrgReceiptNo := FieldByName('receipt_no').AsString;
    end;

    if AShowMsg and
       (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('영수증번호 [%s]의 거래 내역을 취소하시겠습니까?', [LOrgReceiptNo]), ['예', '아니오']) <> mrOK) then
      Exit;
    with BPDM.QRPaymentList do
    try
      LIndex := 0;
      SetLength(PL, RecordCount);
      DisableControls;
      First;
      while not Eof do
      begin
        PL[LIndex].Clear;
        PL[LIndex].Seq := FieldByName('seq').AsInteger;
        PL[LIndex].ReceiptNo := FieldByName('receipt_no').AsString;
        PL[LIndex].PaySeq := FieldByName('pay_seq').AsInteger;
        PL[LIndex].PayMethod := FieldByName('pay_method').AsInteger;
        PL[LIndex].IsApproval := FieldByName('approval_yn').AsBoolean;
        PL[LIndex].IsManualInput := FieldByName('manual_input_yn').AsBoolean;
        PL[LIndex].VanCode := FieldByName('van_cd').AsString;
        PL[LIndex].TID := FieldByName('tid').AsString;
        PL[LIndex].ApproveNo := FieldByName('approve_no').AsString;
        PL[LIndex].ApproveAmt := FieldByName('approve_amt').AsInteger;
        PL[LIndex].OrgApproveNo := FieldByName('approve_no').AsString;
        PL[LIndex].OrgApproveDate := FieldByName('trade_dt').AsString;
        PL[LIndex].VAT := FieldByName('vat').AsInteger;
        PL[LIndex].InstallMonth := FieldByName('inst_month').AsInteger;
        PL[LIndex].CashEntity := FieldByName('cash_entity_div').AsInteger;
        PL[LIndex].CardNo := FieldByName('card_no').AsString;
        PL[LIndex].TradeNo := FieldByName('trade_no').AsString;
        PL[LIndex].TradeDate := FieldByName('trade_dt').AsString;
        PL[LIndex].IssuerCode := FieldByName('issuer_cd').AsString;
        PL[LIndex].ISsuerName := FieldByName('issuer_nm').AsString;
        PL[LIndex].BuyerDiv := FieldByName('buyer_div').AsString;
        PL[LIndex].BuyerCode := FieldByName('buyer_cd').AsString;
        PL[LIndex].BuyerName := FieldByName('buyer_nm').AsString;
        Inc(LIndex);
        Next;
      end;

      LNewReceiptNo := BPDM.GetNewReceiptNo;
      if not BPDM.PostCancelPayment(PL, LNewReceiptNo, LOrgReceiptNo, LResMsg) then
        raise Exception.Create('거래 내역 취소 작업이 완료되지 못하였습니다.' + _BR + ErrorString(LResMsg));
      V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('receipt_no').Index];
      V1.Controller.IncSearchingText := LNewReceiptNo;
      DoReIssueReceipt;
    finally
      EnableControls;
    end;
    RefreshSaleList;
    BPMsgBox(Self.Handle, mtInformation, '알림', '거래 내역 취소 작업이 완료되었습니다.', ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TBPReceiptViewForm.DoReIssueReceipt;
var
  RI: TReceiptItemInfo;
  SL: TArray<TProdItemRec>;
  PL: TArray<TPaymentItemRec>;
  LIsCancel: Boolean;
  LSaleDate, LSaleTime, LReceiptJson, LResMsg: string;
  LIndex: ShortInt;
begin
  try
    try
      with BPDM.QRReceiptList do
      begin
        DisableControls;
        LIsCancel := FieldByName('cancel_yn').AsBoolean;
        LSaleDate := FieldByName('sale_dt').AsString;
        LSaleTime := FieldByName('sale_tm').AsString;
        with RI do
        begin
          Clear;
          ReceiptNo := FieldByName('receipt_no').AsString;
          SaleAmt := FieldByName('sale_amt').AsInteger;
          DCAmt := FieldByName('dc_amt').AsInteger;
          CouponAmt := FieldByName('coupon_dc_amt').AsInteger;
          VAT := FieldByName('vat').AsInteger;
          KeepAmt := FieldByName('keep_amt').AsInteger;
          SaleMemo := FieldByName('sale_memo').AsString;
        end;
      end;

      with BPDM.QRSaleItemList do
      begin
        LIndex := 0;
        SetLength(SL, RecordCount);
        DisableControls;
        First;
        while not Eof do
        begin
          with SL[LIndex] do
          begin
            Clear;
            Seq := FieldByName('seq').AsInteger;
            AssignLaneNo := FieldByName('assign_lane_no').AsInteger;
            AssignNo := FieldByName('assign_no').AsString;
            BowlerId := FieldByName('bowler_id').AsString;
            ProdDiv := FieldByName('prod_div').AsString;
            ProdDetailDiv := FieldByName('prod_detail_div').AsString;
            ProdCode := FieldByName('prod_cd').AsString;
            ProdName := FieldByName('prod_nm').AsString;
            ProdAmt := FieldByName('prod_amt').AsInteger;
            OrderQty := FieldByName('order_qty').AsInteger;
            DCAmt := FieldByName('dc_amt').AsInteger;
            KeepAmt := FieldByName('keep_amt').AsInteger;
            IsService := FieldByName('service_yn').AsBoolean;
            MemberNo := FieldByName('member_no').AsString;
            LockerNo := FieldByName('locker_no').AsInteger;
            LockerName := FieldByName('locker_nm').AsString;
            PurchaseMonth := FieldByName('purchase_month').AsInteger;
            UseStartDate := FieldByName('start_dt').AsString;
          end;
          Inc(LIndex);
          Next;
        end;
      end;

      with BPDM.QRPaymentList do
      begin
        LIndex := 0;
        SetLength(PL, RecordCount);
        DisableControls;
        First;
        while not Eof do
        begin
          with PL[LIndex] do
          begin
            Clear;
            Seq := FieldByName('seq').AsInteger;
            ReceiptNo := FieldByName('receipt_no').AsString;
            PayMethod := FieldByName('pay_method').AsInteger;
            IsApproval := FieldByName('approval_yn').AsBoolean;
            IsManualInput := FieldByName('manual_input_yn').AsBoolean;
            VanCode := FieldByName('van_cd').AsString;
            TID := FieldByName('tid').AsString;
            ApproveNo := FieldByName('approve_no').AsString;
            ApproveAmt := FieldByName('approve_amt').AsInteger;
            OrgApproveNo := FieldByName('approve_no').AsString;
            OrgApproveDate := FieldByName('trade_dt').AsString;
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
          end;
          Inc(LIndex);
          Next;
        end;
      end;

      LReceiptJson := BPDM.MakeReceiptJson(RI, SL, PL, LSaleDate, LSaleTime, LResMsg);
      if not LResMsg.IsEmpty then
        raise Exception.Create(LResMsg);
      Global.ReceiptPrint.IsRefund := LIsCancel;
      if not Global.ReceiptPrint.ReceiptPrint(LReceiptJson, True, LResMsg) then
        raise Exception.Create(LResMsg);
    finally
      BPDM.QRReceiptList.EnableControls;
      BPDM.QRSaleItemList.EnableControls;
      BPDM.QRPaymentList.EnableControls;
    end;
  except
    on E: Exception do
     BPMsgBox(Self.Handle, mtError, '알림', '영수증 출력에 장애가 발생했습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPReceiptViewForm.DoReqCashReceipt;
var
  PR: TPaymentItemRec;
  LReceiptNo, LResMsg: string;
  LPaySeq: ShortInt;
  LIsManualInput: Boolean;
begin
  with BPDM.QRReceiptList do
  begin
    if (RecordCount = 0) then
      Exit;
    LReceiptNo := BPDM.QRReceiptList.FieldByName('receipt_no').AsString;
  end;

  with BPDM.QRPaymentList do
  begin
    if (RecordCount = 0) then
      Exit;
    if (FieldByName('pay_method').AsInteger <> CO_PAYMENT_CASH) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림', '현금 결제가 아니거나 이미 현금영수증을 발행한 거래입니다.', ['확인'], 5);
      Exit;
    end;

    if (not FieldByName('card_no').AsString.IsEmpty) then
    begin
      BPMsgBox(Self.Handle, mtWarning, '알림', '현금 결제가 아니거나 이미 현금영수증을 발행한 거래입니다.', ['확인'], 5);
      Exit;
    end;
    LPaySeq := FieldByName('pay_seq').AsInteger;
    LIsManualInput := FieldByName('manual_input_yn').AsBoolean;
  end;

  if (BPMsgBox(Self.Handle, mtConfirmation, '확인', '선택한 결제 건의 현금영수증을 발행하시겠습니까?', ['예', '아니오']) <> mrOK) then
    Exit;

  try
    with TBPCashReceiptPopupForm.Create(nil) do
    try
      CashAmount := BPDM.QRPaymentList.FieldByName('approve_amt').AsInteger;
      if (ShowModal = mrOK) then
      begin
        PR.Clear;
        PR.ReceiptNo := LReceiptNo;
        PR.PaySeq := LPaySeq;
        PR.IsManualInput := LIsManualInput;
        PR.ApproveNo := ApproveNo;
        PR.CashEntity := CashEntity;
        PR.CardNo := IdentifyNo;
        if (not BPDM.PostUpdateCashPayment(PR, LResMsg)) then
          raise Exception.Create('장애가 발생하여 현금영수증 발행을 완료할 수 없습니다.');
        V1.OptionsBehavior.IncSearchItem := V1.Items[V1.GetColumnByFieldName('receipt_no').Index];
        V1.Controller.IncSearchingText := LReceiptNo;
        DoReIssueReceipt;
        RefreshSaleDetailList(LReceiptNo);
      end;
    finally
      Free;
    end;
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPReceiptViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.