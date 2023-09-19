unit Frame.Policy;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  TPolicy = class(TFrame)
    recBtn: TRectangle;
    recClose: TRectangle;
    Text17: TText;
    recOk: TRectangle;
    txtOk: TText;
    Rectangle1: TRectangle;
    txtTitle: TText;
    PolicyAll: TRectangle;
    Text10: TText;
    Policy2: TRectangle;
    Policy1: TRectangle;
    Policy3: TRectangle;
    Rectangle4: TRectangle;
    txtPolicy1: TText;
    Text8: TText;
    Rectangle2: TRectangle;
    imgPolicy2N: TImage;
    imgPolicy2Y: TImage;
    txtPolicy2: TText;
    Text11: TText;
    Rectangle6: TRectangle;
    imgPolicy3N: TImage;
    imgPolicy3Y: TImage;
    txtPolicy3: TText;
    Text5: TText;
    Rectangle8: TRectangle;
    imgPolicyAllN: TImage;
    imgPolicyAllY: TImage;
    txtPolicyAll: TText;
    Memo1: TMemo;
    imgPolicy1N: TImage;
    imgPolicy1Y: TImage;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure recCloseClick(Sender: TObject);
    procedure recOkClick(Sender: TObject);
    procedure imgPolicyAllYClick(Sender: TObject);
    procedure imgPolicy2NClick(Sender: TObject);
    procedure imgPolicy2YClick(Sender: TObject);
    procedure imgPolicy3NClick(Sender: TObject);
    procedure imgPolicy3YClick(Sender: TObject);
    procedure imgPolicy1NClick(Sender: TObject);
    procedure imgPolicy1YClick(Sender: TObject);
  private
    { Private declarations }
    procedure PolicyChk1(AType: String);
    procedure PolicyChk2(AType: String);
    procedure PolicyChk3(AType: String);

    procedure ChkBtnOk;
  public
    { Public declarations }

    procedure Display;
  end;

implementation

uses
  Form.Popup, uGlobal, uCommon, uConsts;

{$R *.fmx}

procedure TPolicy.Display;
begin
  memo1.Text := Global.Config.Store.UseAgreement;
  memo2.Text := Global.Config.Store.PrivacyAgreement;
  memo3.Text := Global.Config.Store.AdvertiseAgreement;
end;

procedure TPolicy.imgPolicy1NClick(Sender: TObject);
begin
  PolicyChk1('1');
end;

procedure TPolicy.imgPolicy1YClick(Sender: TObject);
begin
  PolicyChk1('0');
end;

procedure TPolicy.imgPolicy2NClick(Sender: TObject);
begin
  PolicyChk2('1');
end;

procedure TPolicy.imgPolicy2YClick(Sender: TObject);
begin
  PolicyChk2('0');
end;

procedure TPolicy.imgPolicy3NClick(Sender: TObject);
begin
  PolicyChk3('1');
end;

procedure TPolicy.imgPolicy3YClick(Sender: TObject);
begin
  PolicyChk3('0');
end;

procedure TPolicy.PolicyChk1(AType: String);
begin
  if AType = '0' then
  begin
    txtPolicy1.Text := '0';
    imgPolicy1Y.Visible := False;
    imgPolicy1N.Visible := True;
  end
  else
  begin
    txtPolicy1.Text := '1';
    imgPolicy1Y.Visible := True;
    imgPolicy1N.Visible := False;
  end;

  ChkBtnOk;
end;

procedure TPolicy.PolicyChk2(AType: String);
begin
  if AType = '0' then
  begin
    txtPolicy2.Text := '0';
    imgPolicy2Y.Visible := False;
    imgPolicy2N.Visible := True;
  end
  else
  begin
    txtPolicy2.Text := '1';
    imgPolicy2Y.Visible := True;
    imgPolicy2N.Visible := False;
  end;

  ChkBtnOk;
end;

procedure TPolicy.PolicyChk3(AType: String);
begin
  if AType = '0' then
  begin
    txtPolicy3.Text := '0';
    imgPolicy3Y.Visible := False;
    imgPolicy3N.Visible := True;
  end
  else
  begin
    txtPolicy3.Text := '1';
    imgPolicy3Y.Visible := True;
    imgPolicy3N.Visible := False;
  end;
end;

procedure TPolicy.ChkBtnOk;
begin
  if (txtPolicy1.Text = '1') and (txtPolicy2.Text = '1') then
  begin
    recOk.Fill.Color := $FF3D55F5;
    txtOk.TextSettings.FontColor := TAlphaColorRec.White;
  end
  else
  begin
    recOk.Fill.Color := $FFD9D9D9;
    txtOk.TextSettings.FontColor := $FF909092;
  end;
end;

procedure TPolicy.imgPolicyAllYClick(Sender: TObject);
begin
  if txtPolicyAll.Text = '0' then
  begin
    txtPolicyAll.Text := '1';
    imgPolicyAllY.Visible := True;
    imgPolicyAllN.Visible := False;
    PolicyChk1('1');
    PolicyChk2('1');
    PolicyChk3('1');
  end
  else
  begin
    txtPolicyAll.Text := '0';
    imgPolicyAllY.Visible := False;
    imgPolicyAllN.Visible := True;
    PolicyChk1('0');
    PolicyChk2('0');
    PolicyChk3('0');
  end;

  ChkBtnOk;
end;

procedure TPolicy.recCloseClick(Sender: TObject);
begin
  Popup.CloseFormStrMrCancel;
end;

procedure TPolicy.recOkClick(Sender: TObject);
begin
  if recOk.Fill.Color = $FFD9D9D9 then
    Exit;

  {
  if txtPolicy1.Text = '0' then
  begin
    Global.SBMessage.ShowMessage('11', '알림', '[이용약관]을 동의해 주세요');
    Exit;
  end;

  if txtPolicy2.Text = '0' then
  begin
    Global.SBMessage.ShowMessage('11', '알림', '[개인정보 보호]을 동의해 주세요');
    Exit;
  end;
  }
  Popup.CloseFormStrMrok('');
end;

end.
