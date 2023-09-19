unit Common.BPInputBox;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TBPInputBoxForm = class(TForm)
    lblMessage: TLabel;
    panButtonSet: TPanel;
    panHeader: TPanel;
    btnClose: TSpeedButton;
    edtInputText: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure edtInputTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    FTitle: string;
    FMessageText: string;
    FPasswordMode: Boolean;

    procedure SetTitle(const AValue: string);
    procedure SetMessageText(const AValue: string);
    procedure SetInputText(const AValue: string);
    procedure SetPasswordMode(const AValue: Boolean);
    function GetInputText: string;
    { Private declarations }
  public
    property Title: string read FTitle write SetTitle;
    property MessageText: string read FMessageText write SetMessageText;
    property InputText: string read GetInputText write SetInputText;
    property PasswordMode: Boolean read FPasswordMode write SetPasswordMode;
  end;

var
  BPInputBox: TBPInputBoxForm;

implementation

uses
  Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.DFM}

{ TBPInputBoxForm }

procedure TBPInputBoxForm.FormCreate(Sender: TObject);
begin
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
  LF := TLayeredForm.Create(nil);
  LF.Show;
end;

procedure TBPInputBoxForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TBPInputBoxForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      Self.ModalResult := mrOK;
    VK_ESCAPE:
      Self.ModalResult := mrCancel;
  end;
end;

procedure TBPInputBoxForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPInputBoxForm.edtInputTextKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Char(VK_RETURN)) then
    Self.ModalResult := mrOK;
end;

procedure TBPInputBoxForm.SetTitle(const AValue: string);
begin
  FTitle := AValue;
  panHeader.Caption := FTitle;
end;

procedure TBPInputBoxForm.SetMessageText(const AValue: string);
begin
  FMessageText := AValue;
  lblMessage.Caption := FMessageText;
end;

function TBPInputBoxForm.GetInputText: string;
begin
  Result := edtInputText.Text;
end;

procedure TBPInputBoxForm.SetInputText(const AValue: string);
begin
  edtInputText.Text := AValue;
end;

procedure TBPInputBoxForm.SetPasswordMode(const AValue: Boolean);
begin
  FPasswordMode := AValue;
  if FPasswordMode then
    edtInputText.PasswordChar := #42
  else
    edtInputText.PasswordChar := #0;
end;

procedure TBPInputBoxForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

initialization
  BPInputBox := nil;
end.
