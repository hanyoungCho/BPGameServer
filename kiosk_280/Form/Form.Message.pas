unit Form.Message;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, Winapi.Windows, FMX.Platform.Win,
  FMX.Edit;

type
  TSBMessageForm = class(TForm)
    Layout: TLayout;
    recBG: TRectangle;
    recButtonTwo: TRectangle;
    recOk: TRectangle;
    txtTitleLine1: TText;
    txtDesc: TText;
    Timer: TTimer;
    recCancel: TRectangle;
    Text17: TText;
    Edit1: TEdit;
    recBodyBG: TRectangle;
    Text3: TText;
    txtTitleLine2_1: TText;
    txtTitleLine2_2: TText;
    recTop: TRectangle;
    recTime: TRectangle;
    recBottom: TRectangle;
    recButtonOne: TRectangle;
    Rectangle2: TRectangle;
    Text1: TText;
    Text4: TText;
    recClose: TRectangle;
    Image1: TImage;
    procedure recOkClick(Sender: TObject);
    procedure recBGClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure recCancelClick(Sender: TObject);
    procedure recCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FType: String;
    FCnt: Integer;
    FCloseCnt: Integer;
    FSoundPlay: Boolean;
    FOneBtn: Boolean;
  end;

var
  SBMessageForm: TSBMessageForm;

implementation

uses
  uCommon, uGlobal, uSaleModule, uConsts, uFunction, fx.Logging;

{$R *.fmx}

procedure TSBMessageForm.FormDestroy(Sender: TObject);
begin
  DeleteChildren;
  Exit;
end;

procedure TSBMessageForm.FormShow(Sender: TObject);
var
  sStr: String;
begin
  SetWindowPos(WindowHandleToPlatform(Self.Handle).Wnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);

  text4.Visible := False; //시간

  if FType = '11' then
  begin
    recBodyBG.Height := 548;
    recTop.Height := 178;
    txtDesc.Position.Y := 248;

    txtTitleLine2_1.Visible := False;
    txtTitleLine2_2.Visible := False;
  end
  else if FType = '12' then
  begin
    recBodyBG.Height := 608;
    recTop.Height := 178;
    txtDesc.Position.Y := 248;

    txtTitleLine2_1.Visible := False;
    txtTitleLine2_2.Visible := False;
	end
	else if FType = '13' then
	begin //회원삭제시 메세지
		recBodyBG.Height := 668;
		recTop.Height := 178;
		txtDesc.Position.Y := 248;
		txtDesc.Height := 180;

		txtTitleLine2_1.Visible := False;
		txtTitleLine2_2.Visible := False;
	end
  else if FType = '21' then
  begin
    recBodyBG.Height := 654;
		recTop.Height := 274;
		txtDesc.Position.Y := 354;

		txtTitleLine1.Visible := False;
  end
  else if FType = '22' then
  begin
    recBodyBG.Height := 714;
    recTop.Height := 274;
    txtDesc.Position.Y := 354;

    txtTitleLine1.Visible := False;
  end;

  recButtonOne.Visible := FOneBtn;
  recButtonTwo.Visible := not FOneBtn;

  if FSoundPlay then
    TouchSound(True);

  if FType = '21' then
	begin
    txtTitleLine2_1.Text := Global.SaleModule.NewMember.Name + '회원님';
		txtTitleLine2_2.Text := '환영합니다.';

    if Global.SaleModule.NewMemberItemType = nmitStudent then
		begin //ksj 230828 이 경우만 두줄사용(22)
      recBodyBG.Height := 654;
			recTop.Height := 274;
			txtDesc.Position.Y := 354;

			txtTitleLine1.Visible := False;

      sStr := '학생인증은 프론트에서 등록해주세요.';
      sStr := sStr + #13 + '레인예약 화면으로 이동합니다.';
    end
    else
      sStr := sStr + '회원권 구매화면으로 이동합니다.';

    txtDesc.Text := sStr;
  end;

  Edit1.SetFocus;
end;

procedure TSBMessageForm.recOkClick(Sender: TObject);
begin
  //확인
  Log.D('TSBMessageForm', 'mrOk');

  if Global.SBMessage.PrintError then
  begin
    Global.SaleModule.Print.PrintStatus := '';
    Global.SaleModule.Print.SewooStatus;
  end;

  ModalResult := mrOk;
end;

procedure TSBMessageForm.recCancelClick(Sender: TObject);
begin
  //닫기
  Log.D('TSBMessageForm', 'mrCancel');
  ModalResult := mrCancel;
end;

procedure TSBMessageForm.recCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSBMessageForm.recBGClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TSBMessageForm.TimerTimer(Sender: TObject);
begin
  Inc(FCnt);
  if FCnt = FCloseCnt then
  begin
    Timer.Enabled := False;
    if not recButtonTwo.Visible then
    begin
      Log.D('TSBMessageForm Timer', 'mrOk');
      ModalResult := mrOk;
    end
    else
    begin
      Log.D('TSBMessageForm Timer', 'mrCancel');
      ModalResult := mrCancel;
    end;
  end;

  Text4.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - FCnt), 2, ' ')]);
end;

end.
