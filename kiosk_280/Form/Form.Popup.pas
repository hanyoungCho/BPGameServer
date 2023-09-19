unit Form.Popup;

interface

uses
  Frame.KeyBoard, uConsts, DateUtils,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, Frame.Authentication, FMX.Controls.Presentation, FMX.Edit,
  //chy newmember
  Frame.Policy, Frame.GameSetting,
  Frame.DCList, Frame.Popup.Halbu, Frame.Popup.Print;

type
  TPopup = class(TForm)
    Layout: TLayout;
    edtNumber: TEdit;
    Rectangle: TRectangle;
    recFrame: TRectangle;
    Authentication1: TAuthentication;

    Policy1: TPolicy;
    DCList1: TDCList;
    PopupPrint1: TPopupPrint;
    GameSetting1: TGameSetting;

    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtNumberKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtNumberKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure recFrameClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FKeyIn: Boolean;
    FKeyLength: Integer;
    FPopupLevel: TPopUpLevel;

  public
    { Public declarations }
    CloseStr: string;
    iSec: Integer;

    procedure CloseFormStrMrok(AStr: string);
    procedure CloseFormStrMrCancel;

    procedure NewMemberPolicy;
    procedure PrintCancel;
    //procedure FacilityProductAuth;
  end;

var
  Popup: TPopup;

implementation

uses
  uGlobal, uFunction, uStruct, uCommon, fx.Logging;

{$R *.fmx}

procedure TPopup.CloseFormStrMrCancel;
begin
  ModalResult := mrCancel;
end;

procedure TPopup.CloseFormStrMrok(AStr: string);
begin
  CloseStr := AStr;

  ModalResult := mrOk;
end;

procedure TPopup.edtNumberKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FKeyIn := True;
  if Key in [vkF1, vkF2, vkF3, vkF4, vkF5, vkF6, vkF7, vkF8, vkF9, vkF10, vkF11, vkF12] then
  begin
    FKeyIn := False;
    Exit;
  end;

  if Key = vkCancel then
    edtNumber.Text := EmptyStr
  else if key = vkBack then
  begin
    if Length(edtNumber.Text) <= 1 then
      edtNumber.Text := EmptyStr
    else
      edtNumber.Text := Copy(edtNumber.Text, 1, Length(edtNumber.Text));
  end;
end;

procedure TPopup.edtNumberKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Length(edtNumber.Text) >= FKeyLength then
    edtNumber.Text := Copy(edtNumber.Text, 1, FKeyLength);

  if FKeyIn then
  begin
    if FPopupLevel in [plAuthentication] then
      Authentication1.ChangeKey(edtNumber.Text);
  end;
end;

procedure TPopup.FormDestroy(Sender: TObject);
begin
	Authentication1.CloseFrame;
	Authentication1.Free;

  DeleteChildren;
end;

procedure TPopup.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
//
end;

procedure TPopup.FormShow(Sender: TObject);
var
  ADateTime: TDateTime;
begin
  edtNumber.Text := EmptyStr;
  CloseStr := EmptyStr;
  edtNumber.SetFocus;

  FPopupLevel := Global.SaleModule.PopUpLevel;

  if FPopupLevel = plAuthentication then
  begin
    FKeyLength := 4;
    Authentication1.KeyBoard1.DisPlayKeyBoard;
    Authentication1.Visible := True;
  end
  else if FPopupLevel = plNewMemberPolicy then
  begin
    FKeyLength := 0;
    Policy1.Visible := True;
    Policy1.Display;
  end
  else if FPopupLevel = plGameSetting then
  begin
    FKeyLength := 0;
    GameSetting1.Visible := True;
    GameSetting1.Display;
  end
  else if FPopupLevel in [plBuyDcList, plPayDcList] then
  begin
    FKeyLength := 0;
    DCList1.Visible := True;
    DCList1.Display;
  end
  else if FPopupLevel in [plPrint, plAssignPrint] then
  begin
    PopupPrint1.Visible := True;
//		if Global.SaleModule.Print.PrintThread = nil then
//			Global.SaleModule.Print.PrintThread.Create()

    if FPopupLevel = plAssignPrint then
    begin
      PopupPrint1.txtTitle.Text := '배정표 출력';
      PopupPrint1.Text.Text := '기기 하단의 프린터로 배정표가 출력되었습니다.';

      if Global.SaleModule.Print.PrintThread <> nil then
      begin
        Global.SaleModule.Print.PrintThread.AssignReceiptList.Add(Global.SaleModule.SetAssignReceiptPrintData);
        Global.SaleModule.Print.PrintThread.Resume;
      end;
    end
    else
    begin
      PopupPrint1.txtTitle.Text := '영수증 출력';
      PopupPrint1.Text.Text := '기기 하단의 프린터로 카드 영수증이 출력되었습니다.';

      if Global.SaleModule.Print.PrintThread <> nil then
      begin
        Global.SaleModule.Print.PrintThread.ReceiptList.Add(Global.SaleModule.SetReceiptPrintData);
        Global.SaleModule.Print.PrintThread.Resume;
      end;
    end;
  end;

  //Log.D('ShowPopup', 'showing - ' + FormatDateTime('yyymmdd hh:nn.ss', now));
end;

procedure TPopup.recFrameClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TPopup.NewMemberPolicy;
begin

  Global.SaleModule.PopUpLevel := plNewMemberPolicy;
  FormShow(Self);
end;
{
procedure TPopup.FacilityProductAuth;
begin
  frmNewMemberItemType1.Visible := False;
  frmNewMemberItemType1.iSec := 0;
  frmNewMemberItemType1.Timer.Enabled := False;

  Global.SaleModule.PopUpLevel := plPhone;
  FormShow(Self);
end;
}

procedure TPopup.PrintCancel;
begin
  try
    {
    TimerFull.Enabled := False;
    if Global.SaleModule.GetSumPayAmt(ptCard) <> 0 then
    begin
      Global.SaleModule.SoundThread.SoundList.Add(ExtractFilePath(Application.GetNamePath) + 'CardOut.wav');
      Global.SaleModule.SoundThread.SoundList.Add(ExtractFilePath(Application.GetNamePath) + 'CardOut.wav');
      Global.SaleModule.SoundThread.Resume;
      Global.SBMessage.ShowMessage('11', '알림', MSG_COMPLETE_CARD, True, 10, False);
    end;
    }
    CloseFormStrMrCancel;
  except
    on E: Exception do
      Log.E('PrintCancel', E.Message);
  end;
end;

(*

procedure TFullPopup.TimerFullTimer(Sender: TObject);
label ReNitgen, ReNitgenAdd, ReUnion, ReUnionAdd;
var
  iRv: Integer;
  AMsg: string;
  panel: TPanel;
  MemberTemp: TMemberInfo;
begin
  try
    if Work then
    begin
      Log.D('TFullPopup.TimerFullTimer Work', 'Exit');
      Exit;
    end;

    Inc(FCnt);
    if PopUpFullLevel in [pflPrint, pflTeeBoxPrint] then
    begin
      txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(11 - Trunc(FCnt)), 2, ' ')]);
      if (10 - FCnt) = 0 then
      //if (2 - FCnt) = 0 then //2021-05-13 이종섭과장 요청
      begin
        PrintCancel;
      end;
    end
    else
    begin
      txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - Trunc(FCnt)), 2, ' ')]);
      if (Time30Sec - FCnt) = 0 then
      begin
        TimerFull.Enabled := False;
        CloseFormStrMrCancel;
      end;
    end;

    if Global.SaleModule.CardApplyType = catNone then
    begin
      if FCnt = 1 then
      begin
        {
        if PopUpFullLevel = pflMobile then
        begin
          GetMemberInfo(EmptyStr, Global.SaleModule.Member);
        end;
         }
      end;
    end;

  except
    on E: Exception do
    begin
      Log.E('TFullPopup.TimerFullTimer', 'Exception');
      Log.E('TFullPopup.TimerFullTimer FCnt', CurrToStr(FCnt));
      Log.E('TFullPopup.TimerFullTimer PopUpFullLevel', IntToStr(Ord(PopUpFullLevel)));
      Log.E('TFullPopup.TimerFullTimer txtTime.Text', txtTime.Text);
    end;
  end;

end;
*)

end.
