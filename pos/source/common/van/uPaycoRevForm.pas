unit uPaycoRevForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, IniFiles, StrUtils, Math, Vcl.ExtCtrls,
  Vcl.OleCtrls, Vcl.Buttons;//, FMX.Forms;

type
  TPaycoRevForm = class(TForm)
    pnSingTitle: TPanel;
    lbMessage: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RevState : Integer;              // 응답여부 ( 0: 미응답 / 1 : 결제완료 / 2: 서명완료 )
    RevMsg   : AnsiString;           // 응답메세지
    procedure WMCopyData(var Message:TMessage); message WM_CopyData;
  end;

var
  PaycoRevForm: TPaycoRevForm;

implementation

{$R *.dfm}

{ TPaycoRevForm }

procedure TPaycoRevForm.WMCopyData(var Message: TMessage);
var
  Data :^COPYDATASTRUCT;
begin
  try
    Data:= Ptr(Message.lParam);
    RevMsg:= StrPas(PAnsiChar(Data^.lpData));
    if Data^.dwData = 1000 then               // 결제완료 상태일경우
     RevState := 1
    else if Data^.dwData = 1003 then          // 서명요청일 경우
      RevState := 2;
  except
  end;
end;

procedure TPaycoRevForm.FormShow(Sender: TObject);
begin
  RevMsg    := EmptyStr;
  RevState  := 0;
  Self.Width := 1;
  Self.Height := 1;
end;

procedure TPaycoRevForm.btnCancelClick(Sender: TObject);
begin
  RevState := 9;                               // 임시 종료인경우 
end;

end.
