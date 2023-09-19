program BPick_280;

uses
	FastMM4 in '..\..\FastMM4-master\FastMM4.pas',
  FastMM4Messages in '..\..\FastMM4-master\FastMM4Messages.pas',
  Forms,
  windows,
  FMX.Forms,
  frmContainer in 'frmContainer.pas' {Container},
  fx.Json in 'Lib\fx.Json.pas',
  fx.Logging in 'Lib\fx.Logging.pas',
  uFunction in 'Lib\uFunction.pas',
  uConsts in 'Lib\uConsts.pas',
  uStruct in 'Lib\uStruct.pas',
  uGlobal in 'Lib\uGlobal.pas',
  Frame.Select.Box.Top.Map.List.Item.Style in 'Frame\Select.Box\Frame.Select.Box.Top.Map.List.Item.Style.pas' {SelectBoxTopMapItemStyle: TFrame},
  uCommon in 'Lib\uCommon.pas',
  Frame.Select.Box.Top.Map.List.Style in 'Frame\Select.Box\Frame.Select.Box.Top.Map.List.Style.pas' {SelectBoxTopMapListStyle: TFrame},
  Frame.Select.Box.Top.Map in 'Frame\Select.Box\Frame.Select.Box.Top.Map.pas' {SelectBoxTopMap: TFrame},
  Frame.Select.Box.Lane in 'Frame\Select.Box\Frame.Select.Box.Lane.pas' {SelectBoxLane: TFrame},
  Frame.Select.Box.Lane.Item.Style in 'Frame\Select.Box\Frame.Select.Box.Lane.Item.Style.pas' {SelectBoxLaneItemStyle: TFrame},
  uSaleModule in 'Lib\uSaleModule.pas',
  uLaneInfo in 'Lib\uLaneInfo.pas',
  Form.Sale.Member in 'Form\Form.Sale.Member.pas' {SaleMember},
  Frame.Top in 'Frame\Frame.Top.pas' {Top: TFrame},
  Form.Popup in 'Form\Form.Popup.pas' {Popup},
  Frame.KeyBoard.Item.Style in 'Frame\KeyBoard\Frame.KeyBoard.Item.Style.pas' {KeyBoardItemStyle: TFrame},
  Frame.KeyBoard in 'Frame\KeyBoard\Frame.KeyBoard.pas' {KeyBoard: TFrame},
  Frame.Authentication in 'Frame\Popup\Frame.Authentication.pas' {Authentication: TFrame},
  Frame.Bottom in 'Frame\Frame.Bottom.pas' {Bottom: TFrame},
  Frame.Popup.Halbu in 'Frame\Popup\Frame.Popup.Halbu.pas' {PopupHalbu: TFrame},
  Frame.FullPopup.Member in 'Frame\FullPopup\Frame.FullPopup.Member.pas' {FullPopupMember: TFrame},
  Frame.FullPopup.Member.Item in 'Frame\FullPopup\Frame.FullPopup.Member.Item.pas' {FullPopupMemberItem: TFrame},
  Frame.Popup.Print in 'Frame\Popup\Frame.Popup.Print.pas' {PopupPrint: TFrame},
  Frame.FullPopupPayCard in 'Frame\FullPopup\Frame.FullPopupPayCard.pas' {FullPopupPayCard: TFrame},
  Form.Message in 'Form\Form.Message.pas' {SBMessageForm},
  uConfig in 'Lib\uConfig.pas',
  fx.Base in 'Lib\fx.Base.pas',
  Form.Full.Popup in 'Form\Form.Full.Popup.pas' {FullPopup},
  uPrint in 'Lib\uPrint.pas',
  uErpApi in 'DBModule\uErpApi.pas',
  Form.Main in 'Form\Form.Main.pas' {Main},
  Form.Config in 'Form\Form.Config.pas' {Config},
  Frame.Config.Item.Style in 'Frame\Config\Frame.Config.Item.Style.pas' {ConfigItemStyle: TFrame},
  uPaycoNewModul in 'Lib\Pay\uPaycoNewModul.pas',
  uPaycoRevForm in 'Lib\Pay\uPaycoRevForm.pas' {PaycoRevForm},
  Form.Master.Download in 'Form\Form.Master.Download.pas' {MasterDownload},
  Frame.Select.Box.Sale.Item.Style in 'Frame\Select.Box\Frame.Select.Box.Sale.Item.Style.pas' {SelectBoxSaleItemStyle: TFrame},
  Form.Intro in 'Form\Form.Intro.pas' {Intro},
  Frame.Media in 'Frame\Frame.Media.pas' {MediaFrame: TFrame},
  Frame.AppCardList in 'Frame\FullPopup\Frame.AppCardList.pas' {FullPopupAppCardList: TFrame},
  Frame.AppCardListI.Item in 'Frame\FullPopup\Frame.AppCardListI.Item.pas' {FullPopupAppCardListItem: TFrame},
  Form.Select.Box in 'Form\Form.Select.Box.pas' {SelectBox},
  uLocalApi in 'DBModule\uLocalApi.pas',
  Frame.Policy in 'Frame\Popup\Frame.Policy.pas' {Policy: TFrame},
  Frame.GameSetting in 'Frame\Popup\Frame.GameSetting.pas' {GameSetting: TFrame},
  Form.Popup.NewMemberInfoTT in 'Form\Form.Popup.NewMemberInfoTT.pas' {frmNewMemberInfoTT},
  uTabTipHelper in 'Lib\uTabTipHelper.pas',
  Frame.Select.Box.Sale in 'Frame\Select.Box\Frame.Select.Box.Sale.pas' {SelectBoxSale: TFrame},
  Form.Sale.Game.Bowler in 'Form\Form.Sale.Game.Bowler.pas' {SaleGameBowler},
  Form.Sale.Product in 'Form\Form.Sale.Product.pas' {SaleProduct},
  Frame.Sale.Game.List.Item.Style in 'Frame\OrderFrame\Frame.Sale.Game.List.Item.Style.pas' {SaleGameItemStyle: TFrame},
  Frame.Sale.Payment.List.Item.Style in 'Frame\OrderFrame\Frame.Sale.Payment.List.Item.Style.pas' {SalePaymentItemStyle: TFrame},
  Form.Sale.Time.Bowler in 'Form\Form.Sale.Time.Bowler.pas' {SaleTimeBowler},
  Frame.Sale.Time.List.Item.Style in 'Frame\OrderFrame\Frame.Sale.Time.List.Item.Style.pas' {SaleTimeItemStyle: TFrame},
  Frame.Sale.Game.DC.Item.Style in 'Frame\OrderFrame\Frame.Sale.Game.DC.Item.Style.pas' {SaleGameDCItemStyle: TFrame},
  Form.Sale.Product.Time in 'Form\Form.Sale.Product.Time.pas' {SaleProductTime},
  Frame.DCList in 'Frame\Popup\Frame.DCList.pas' {DCList: TFrame},
  Frame.FullPopup.Phone in 'Frame\FullPopup\Frame.FullPopup.Phone.pas' {FullPopupPhone: TFrame},
  Frame.Popup.Halbu.Item in 'Frame\Popup\Frame.Popup.Halbu.Item.pas' {PopupHalbuItem: TFrame};

const
  UniqueName = 'XGOLF KIOSK';

var
  Mutex : THandle;

{$R *.res}

begin

  Mutex := OpenMutex(MUTEX_ALL_ACCESS, False, UniqueName);

  if (Mutex <> 0 ) and (GetLastError = 0) then
  begin
    CloseHandle(Mutex);
    MessageBox(0, '프로그램이 실행중입니다.', '', MB_ICONWARNING or MB_OK);
    Exit;
  end;

  Mutex := CreateMutex(nil, False, UniqueName);

  try
    Application.Initialize;
    Application.CreateForm(TContainer, Container);
  Application.Run;
  finally
    ReleaseMutex(Mutex);
  end;
end.
