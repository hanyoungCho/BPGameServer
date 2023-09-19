(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 삭제한 판매/결제 내역 조회
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPDeleteView.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, dxDateRanges, dxScrollbarAnnotations, Data.DB, cxDBData, cxCheckBox, cxLabel,
  cxCurrencyEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid, ABSMain;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPDeleteViewForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    panHeaderMenuBar: TPanel;
    btnMainMenu: TSpeedButton;
    lblPluginVersion: TLabel;
    G1: TcxGrid;
    V1: TcxGridDBBandedTableView;
    V2: TcxGridDBBandedTableView;
    V3: TcxGridDBBandedTableView;
    L1: TcxGridLevel;
    panProdAmtType: TPanel;
    btnSaleItemBackup: TSpeedButton;
    btnPaymentBackup: TSpeedButton;
    shpCategorySeparator: TShape;
    btnCouponBackup: TSpeedButton;
    DataSource: TDataSource;
    BackupDataSet: TABSQuery;
    V1receipt_no: TcxGridDBBandedColumn;
    V1assign_lane_no: TcxGridDBBandedColumn;
    V1assign_no: TcxGridDBBandedColumn;
    V1bowler_id: TcxGridDBBandedColumn;
    V1prod_div: TcxGridDBBandedColumn;
    V1prod_detail_div: TcxGridDBBandedColumn;
    V1prod_cd: TcxGridDBBandedColumn;
    V1prod_nm: TcxGridDBBandedColumn;
    V1prod_amt: TcxGridDBBandedColumn;
    V1order_qty: TcxGridDBBandedColumn;
    V1payment_yn: TcxGridDBBandedColumn;
    V1dc_amt: TcxGridDBBandedColumn;
    V1use_point: TcxGridDBBandedColumn;
    V1service_yn: TcxGridDBBandedColumn;
    V1member_no: TcxGridDBBandedColumn;
    V1member_nm: TcxGridDBBandedColumn;
    V1keep_amt: TcxGridDBBandedColumn;
    V1locker_no: TcxGridDBBandedColumn;
    V1locker_nm: TcxGridDBBandedColumn;
    V1purchase_month: TcxGridDBBandedColumn;
    V1start_dt: TcxGridDBBandedColumn;
    V1user_id: TcxGridDBBandedColumn;
    V1update_dttm: TcxGridDBBandedColumn;
    V2receipt_no: TcxGridDBBandedColumn;
    V2assign_lane_no: TcxGridDBBandedColumn;
    V2pay_method: TcxGridDBBandedColumn;
    V2approval_yn: TcxGridDBBandedColumn;
    V2manual_input_yn: TcxGridDBBandedColumn;
    V2van_cd: TcxGridDBBandedColumn;
    V2tid: TcxGridDBBandedColumn;
    V2approve_no: TcxGridDBBandedColumn;
    V2approve_amt: TcxGridDBBandedColumn;
    V2org_approve_no: TcxGridDBBandedColumn;
    V2org_approve_dt: TcxGridDBBandedColumn;
    V2vat: TcxGridDBBandedColumn;
    V2service_amt: TcxGridDBBandedColumn;
    V2inst_month: TcxGridDBBandedColumn;
    V2cash_entity_div: TcxGridDBBandedColumn;
    V2card_no: TcxGridDBBandedColumn;
    V2trade_no: TcxGridDBBandedColumn;
    V2trade_dt: TcxGridDBBandedColumn;
    V2issuer_cd: TcxGridDBBandedColumn;
    V2issuer_nm: TcxGridDBBandedColumn;
    V2buyer_div: TcxGridDBBandedColumn;
    V2buyer_cd: TcxGridDBBandedColumn;
    V2buyer_nm: TcxGridDBBandedColumn;
    V2payment_memo: TcxGridDBBandedColumn;
    V2user_id: TcxGridDBBandedColumn;
    V2update_dttm: TcxGridDBBandedColumn;
    V3receipt_no: TcxGridDBBandedColumn;
    V3assign_lane_no: TcxGridDBBandedColumn;
    V3coupon_seq: TcxGridDBBandedColumn;
    V3qr_code: TcxGridDBBandedColumn;
    V3coupon_nm: TcxGridDBBandedColumn;
    V3dc_div: TcxGridDBBandedColumn;
    V3dc_cnt: TcxGridDBBandedColumn;
    V3start_dt: TcxGridDBBandedColumn;
    V3expire_dt: TcxGridDBBandedColumn;
    V3use_cnt: TcxGridDBBandedColumn;
    V3used_cnt: TcxGridDBBandedColumn;
    V3dc_cond_div: TcxGridDBBandedColumn;
    V3prod_div: TcxGridDBBandedColumn;
    V3prod_detail_div: TcxGridDBBandedColumn;
    V3send_dt: TcxGridDBBandedColumn;
    V3use_yn: TcxGridDBBandedColumn;
    V3event_nm: TcxGridDBBandedColumn;
    V3event_url: TcxGridDBBandedColumn;
    V3apply_amt: TcxGridDBBandedColumn;
    V3memo: TcxGridDBBandedColumn;
    V3user_id: TcxGridDBBandedColumn;
    V3update_dttm: TcxGridDBBandedColumn;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure OnDataButtonClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FBaseTitle: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure RefreshDataSet(const ATableIndex: ShortInt);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPTemplateForm }

constructor TBPDeleteViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);

  FOwnerId := 0;
  FBaseTitle := panHeader.Caption;
  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPDeleteViewForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPDeleteViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPDeleteViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPDeleteViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    RefreshDataSet(0);
  end;
end;

procedure TBPDeleteViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    Self.Close;
end;

procedure TBPDeleteViewForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPDeleteViewForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPDeleteViewForm.OnDataButtonClick(Sender: TObject);
begin
  RefreshDataSet(TSpeedButton(Sender).Tag);
end;

procedure TBPDeleteViewForm.RefreshDataSet(const ATableIndex: ShortInt);
var
  LGridView: TcxGridDBBandedTableView;
begin
  LGridView := TcxGridDBBandedTableView(L1.GridView);
  with BackupDataSet do
  try
    DisableControls;
    Close;
    case ATableIndex of
      0: //주문 내역
        begin
          panHeader.Caption := Format('%s ▶ %s', [FBaseTitle, btnSaleItemBackup.Caption]);
          SQL.Text := 'SELECT * FROM TBSaleItemBackup ORDER BY receipt_no, seq';
          LGridView := V1;
        end;
      1: //결제 내역
        begin
          panHeader.Caption := Format('%s ▶ %s', [FBaseTitle, btnPaymentBackup.Caption]);
          SQL.Text := 'SELECT * FROM TBPaymentBackup ORDER BY receipt_no, seq';
          LGridView := V2;
        end;
      2: //쿠폰 사용 내역
        begin
          panHeader.Caption := Format('%s ▶ %s', [FBaseTitle, btnCouponBackup.Caption]);
          SQL.Text := 'SELECT * FROM TBCouponBackup ORDER BY receipt_no, seq';
          LGridView := V3;
        end;
    end;
    Open;
  finally
    EnableControls;
    L1.GridView := LGridView;
    LGridView.ApplyBestFit;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPDeleteViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.