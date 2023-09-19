
unit Form.Sale.Member;

interface

uses
  Windows,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, FMX.StdCtrls,
  uStruct,
  uPaycoNewModul,
  CPort;

type
  TSaleMember = class(TForm)
    ImgLayout: TLayout;
    Layout: TLayout;
    TopLayout: TLayout;
    Text1: TText;
    ProductRectangle: TRectangle;
    Timer: TTimer;
    BGRectangle: TRectangle;
    Text3: TText;
    txtMemberNm: TText;
    Rectangle1: TRectangle;
    txtProductNm: TText;
    txtOption1: TText;
    txtOption2: TText;
    txtOption3: TText;
    txtDate: TText;
    recBtn: TRectangle;
    CardRectangle: TRectangle;
    Text9: TText;
    Text11: TText;
    EasyRectangle: TRectangle;
    Text15: TText;
    Text16: TText;
    recClose: TRectangle;
    Image14: TImage;
    txtAmt: TText;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure TimerTimer(Sender: TObject);
    procedure CardRectangleClick(Sender: TObject);
    procedure ProcessRectangleClick(Sender: TObject);
    procedure BottomRectangleClick(Sender: TObject);
    procedure rrCancelClick(Sender: TObject);
    procedure recCloseClick(Sender: TObject);
    procedure EasyRectangleClick(Sender: TObject);

  private
    { Private declarations }
    FSec: Integer;
    FProduct: TMemberShipProductInfo;
  public
    { Public declarations }
  end;

var
  SaleMember: TSaleMember;

implementation

uses
  uGlobal, uConsts, uFunction, fx.Logging, uCommon, Form.Select.Box, Form.Full.Popup;

{$R *.fmx}


procedure TSaleMember.FormCreate(Sender: TObject);
begin
  FSec := 0;
end;

procedure TSaleMember.FormDestroy(Sender: TObject);
begin
  DeleteChildren;
end;

procedure TSaleMember.FormShow(Sender: TObject);
begin
  FProduct := Global.SaleModule.SaleSelectMemberShipProd;

  txtMemberNm.Text := Global.SaleModule.Member.Name + ' 회원님';

  txtProductNm.Text := FProduct.ProdNm;
  txtDate.Text := '';
  if FProduct.ExpireDay > 0 then
  begin
    txtDate.Text := FormatDateTime('YYYY.MM.DD', Now) + '~' + FormatDateTime('YYYY.MM.DD', Now + FProduct.ExpireDay);
  end;

  txtOption1.Text := '';
  txtOption2.Text := '';
  txtOption3.Text := '';

  if FProduct.ShoesFreeYn = 'Y' then
    txtOption3.Text := '대화료 무료';

  if FProduct.SavePointRate > 0 then
  begin
    if txtOption3.Text = EmptyStr then
      txtOption3.Text := Format('포인트 %s적립', [IntToStr(FProduct.SavePointRate) + '%'])
    else
      txtOption2.Text := Format('포인트 %s적립', [IntToStr(FProduct.SavePointRate) + '%']);
  end;

  if FProduct.ProdBenefits <> EmptyStr then
  begin
    if txtOption3.Text = EmptyStr then
      txtOption3.Text := FProduct.ProdBenefits
    else if txtOption2.Text = EmptyStr then
      txtOption2.Text := FProduct.ProdBenefits
    else
      txtOption1.Text := FProduct.ProdBenefits;
  end;

  txtAmt.Text := Format('%s원', [FormatFloat('#,##0.##', FProduct.ProdAmt)]);

  ImgLayout.Scale.X := Layout.Scale.X;
  ImgLayout.Scale.Y := Layout.Scale.Y;

  Timer.Enabled := True;

end;

procedure TSaleMember.BottomRectangleClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TSaleMember.CardRectangleClick(Sender: TObject);
begin
  try
    Log.D('CardRectangleClick', 'Begin');

    Global.SaleModule.AddMemberShipProduct; //판매상품 등록

    FSec := 0;
    EasyRectangle.Enabled := False;
    CardRectangle.Enabled := False;

    Timer.Enabled := False;
    Global.SaleModule.CardApplyType := catMagnetic;

    if FProduct.ProdAmt = 0 then
    begin
      Global.SBMessage.ShowMessage('11', '알림', MSG_NOT_PAY_AMT);
      Timer.Enabled := True;
      Exit;
    end;

    if Global.Config.NoPayModule then
    begin
      Global.SBMessage.ShowMessage('11', '알림', '결제 가능한 장비가 없습니다.');
      Timer.Enabled := True;
      Exit;
    end;

    TouchSound(False, True);

    Global.SaleModule.PopUpFullLevel := pflPayCard;
    if not ShowFullPopup then
    begin
      Timer.Enabled := True;
      Global.SaleModule.PopUpFullLevel := pflNone;
      Global.SaleModule.CardApplyType := catNone;
    end
    else
      ModalResult := mrOk;

    Log.D('CardRectangleClick', 'End');
  finally
    EasyRectangle.Enabled := True;
    CardRectangle.Enabled := True;

    Global.SaleModule.CardApplyType := catNone;
  end;
end;

procedure TSaleMember.EasyRectangleClick(Sender: TObject);
begin
  try
    Log.D('AppCardRectangleClick', 'Begin');
    //Cnt := 0;
    EasyRectangle.Enabled := False;
    CardRectangle.Enabled := False;

    Timer.Enabled := False;
    Global.SaleModule.CardApplyType := catAppCard;
    {
    if not CheckEndTime then
    begin
      Log.D('AppCardRectangleClick CheckEndTime', 'Out');
      //BackImageClick(nil);
      Exit;
    end;
    }
    if not ShowFullPopup then
    begin
      Timer.Enabled := True;
      Global.SaleModule.PopUpFullLevel := pflNone;
      Global.SaleModule.PopUpLevel := plNone;
      Global.SaleModule.CardApplyType := catNone;

      //Global.SBMessage.ShowMessage('11', '알림', ErrorMsg);
      //ErrorMsg := EmptyStr;
    end;
    //else
      //ModalResult := mrOk;

    Log.D('AppCardRectangleClick', 'End');
  finally
    EasyRectangle.Enabled := True;
    CardRectangle.Enabled := True;

    Global.SaleModule.CardApplyType := catNone;
  end;
end;

procedure TSaleMember.ProcessRectangleClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TSaleMember.recCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSaleMember.rrCancelClick(Sender: TObject);
begin
  TouchSound(False, False);
  ModalResult := mrCancel;
end;

procedure TSaleMember.TimerTimer(Sender: TObject);
begin
  try
    Inc(FSec);
    //txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - FSec), 2, ' ')]);

    text9.Visible := not text9.Visible;
    text16.Visible := not text16.Visible;

    if (Time30Sec - FSec) = 0 then
    begin
      Timer.Enabled := False;
      ModalResult := mrCancel;
    end;

  except
    on E: Exception do
      Log.E(ClassName, E.Message);
  end;
end;

end.
