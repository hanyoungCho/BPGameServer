unit uKisPosAgentForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, OleCtrls, ExtCtrls, KisPosAgentLib_TLB;

type
  TKisPosAgentForm = class(TForm)
    pnSingTitle: TPanel;
    lbMessage: TLabel;
    KisPosAgent: TKisPosAgent;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure KisPosAgentApprovalEnd(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RecvData: AnsiString;
  end;

var
  KisPosAgentForm: TKisPosAgentForm;

implementation

{$R *.dfm}

procedure TKisPosAgentForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TKisPosAgentForm.FormShow(Sender: TObject);
begin
  KisPosAgent.Init;
  KisPosAgent.inAgentIP   := '127.0.0.1'; // KIS-AGENT IP
  KisPosAgent.inAgentPort := 1515;        // KIS-AGENT PORT
  KisPosAgent.inTranCode  := 'CN';        // 전문구분코드
  KisPosAgent.KIS_Approval_Unit;
end;

procedure TKisPosAgentForm.KisPosAgentApprovalEnd(Sender: TObject);
begin
  RecvData := KisPosAgent.outAgentData;
  if (KisPosAgent.outRtn = 0) and (KisPosAgent.outAgentCode = '0000') then // 성공여부
    ModalResult := mrOk
  else
    ModalResult := mrCancel;
end;

end.
