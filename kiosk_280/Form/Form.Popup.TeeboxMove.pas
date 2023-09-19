unit Form.Popup.TeeboxMove;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Frame.KeyBoard,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit;

type
  TfrmTeeboxMove = class(TForm)
    Image: TImage;
    Rectangle1: TRectangle;
    Rectangle5: TRectangle;
    Image5: TImage;
    txtUserNm: TText;
    Rectangle6: TRectangle;
    Image8: TImage;
    Text9: TText;
    Rectangle4: TRectangle;
    Image6: TImage;
    txtReserveDate: TText;
    Rectangle7: TRectangle;
    Image7: TImage;
    Text2: TText;
    Rectangle8: TRectangle;
    Image9: TImage;
    Text1: TText;
    Rectangle9: TRectangle;
    Image10: TImage;
    Text3: TText;
    Rectangle10: TRectangle;
    Image1: TImage;
    Text4: TText;
    Rectangle13: TRectangle;
    Image2: TImage;
    Text5: TText;
    Image11: TImage;
    txtTeeboxNm: TText;
    Image12: TImage;
    txtTeeboxRemin: TText;
    Image13: TImage;
    Text11: TText;
    Image14: TImage;
    Text12: TText;
    Rectangle3: TRectangle;
    Rectangle11: TRectangle;
    Image3: TImage;
    Text17: TText;
    Rectangle12: TRectangle;
    Image4: TImage;
    Text18: TText;
    Rectangle2: TRectangle;
    KeyBoard1: TKeyBoard;
    txtTime: TText;
    Timer: TTimer;
    Layout: TLayout;
    edtNumber: TEdit;
    Image15: TImage;
    Text6: TText;
    procedure Rectangle11Click(Sender: TObject);
    procedure Rectangle12Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNumberKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtNumberKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    FKeyIn: Boolean;
    FKeyLength: Integer;

    function TeeboxCheck(AKey: string): Boolean;
    function TeeboxHoldClear: Boolean;
  public
    { Public declarations }
    iSec: Integer;

    procedure ChangeKey(AKey: string);
  end;

var
  frmTeeboxMove: TfrmTeeboxMove;

implementation

uses
  uGlobal, uCommon, uConsts, uFunction, uStruct;

{$R *.fmx}

procedure TfrmTeeboxMove.ChangeKey(AKey: string);
var
  ATeeBoxInfo: TTeeBoxInfo;
begin
  if Length(AKey) = 0 then
  begin
    Text11.Text := '';

    //기존 홀드제거
    TeeboxHoldClear;
  end
  else
  begin
    //if Global.teebox.GetTeeBoxNo(AKey) > 0 then
      Text11.Text := AKey;

    //TeeboxCheck(AKey);
  end;
end;

procedure TfrmTeeboxMove.edtNumberKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
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
    //if Length(edtNumber.Text) <= 1 then
      //edtNumber.Text := EmptyStr
    //else
      edtNumber.Text := Copy(edtNumber.Text, 1, Length(edtNumber.Text));
  end;
end;

procedure TfrmTeeboxMove.edtNumberKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Length(edtNumber.Text) >= FKeyLength then
    edtNumber.Text := Copy(edtNumber.Text, 1, FKeyLength);

  if FKeyIn then
  begin
    ChangeKey(edtNumber.Text)
  end;
end;

procedure TfrmTeeboxMove.FormShow(Sender: TObject);
begin
  edtNumber.Text := EmptyStr;
  edtNumber.SetFocus;

  FKeyLength := 3;

  //txtUserNm.Text := Global.SaleModule.TeeBoxMoveInfo.MemberNm;
  txtUserNm.Text := Global.SaleModule.Member.Name;
  txtReserveDate.Text := FormatDateTime('hh:nn', now);
  txtTeeboxNm.Text := Global.SaleModule.TeeBoxMoveInfo.Mno;
  txtTeeboxRemin.Text := Global.SaleModule.TeeBoxMoveInfo.Ma_Time;
  Text11.Text := '';
  Text12.Text := Global.SaleModule.TeeBoxMoveInfo.Ma_Time;

  KeyBoard1.DisPlayKeyBoard;
  Visible := True;
  iSec := 0;
  txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec), 2, ' ')]);
  Timer.Enabled := True;
end;

procedure TfrmTeeboxMove.Rectangle11Click(Sender: TObject);
begin
  Timer.Enabled := False;
  //Popup.CloseFormStrMrCancel;

  //기존 홀드제거
  TeeboxHoldClear;

  ModalResult := mrCancel;
end;

procedure TfrmTeeboxMove.Rectangle12Click(Sender: TObject);
var
  AMove: Integer;
  ATeeBoxInfo: TTeeBoxInfo;
begin

  if not Global.SBMessage.ShowMessageModalForm1(Text11.Text + '번 타석으로 이동합니다.', False, 30, True, True) then
    Exit;

  AMove := StrToIntDef(Text11.Text, 0);

  if TeeboxCheck(IntToStr(AMove)) = False then
    Exit;

  Timer.Enabled := False;
  //Popup.CloseFormStrMrok(IntToStr(AMove));

  ModalResult := mrOk;
end;

function TfrmTeeboxMove.TeeboxCheck(AKey: string): Boolean;
var
  ATeeBoxInfo: TTeeBoxInfo;
  nMove: Integer;
begin
  Result := False;

  //기존 홀드제거
  //TeeboxHoldClear;

  //타석존재여부 확인
  nMove := Global.Teebox.GetTeeBoxNo(AKey);
  if nMove = -1 then
  begin
    Global.SBMessage.ShowMessageModalForm(MSG_TEEBOX_NULL);
    Exit;
  end;

  ATeeBoxInfo := Global.Teebox.GetTeeBoxRecordInfo(AKey);

  //Global.SaleModule.SelectMove := ATeeBoxInfo.TasukNo;
  //ATeeBoxInfo.TasukNo := Global.SaleModule.SelectMove;

  //Global.SaleModule.TeeBoxInfo := ATeeBoxInfo;
  //Global.SaleModule.VipTeeBox := ATeeBoxInfo.Vip;
  {
  if Global.TeeBox.GetTeeBoxStatus(AKey) = 'N' then
  begin
    Global.SBMessage.ShowMessageModalForm(MSG_TEEBOX_MOVE_FAIL);
    Exit;
  end;
  }
  // 타석 홀드
  {
  if not Global.Database.TeeBoxHold then
  begin
    Global.SBMessage.ShowMessageModalForm(MSG_HOLD_TEEBOX_ERROR);
    Exit;
  end;
  }
  Result := True;
end;

function TfrmTeeboxMove.TeeboxHoldClear: Boolean;
var
  ATeeBoxInfo: TTeeBoxInfo;
begin
  Result := False;

  //기존 홀드제거
  if Global.SaleModule.TeeBoxInfo.TasukNo <> -1 then
  begin
    Global.Database.TeeBoxHold(False);
    ATeeBoxInfo.TasukNo := -1;
    Global.SaleModule.TeeBoxInfo := ATeeBoxInfo;
  end;

  Result := True;
end;

procedure TfrmTeeboxMove.TimerTimer(Sender: TObject);
begin
  Inc(iSec);
  txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - iSec), 2, ' ')]);
  if (Time30Sec - iSec) = 0 then
    Rectangle11Click(nil);
end;

end.
