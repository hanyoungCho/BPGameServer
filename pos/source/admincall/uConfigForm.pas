unit uConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  Menus, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxButtons,
  cxEdit, cxCheckBox, cxTextEdit, cxMaskEdit, cxSpinEdit;

type
  TConfigForm = class(TForm)
    lbxLogView: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    edtServerPort: TcxSpinEdit;
    ckbNotifyWithSound: TcxCheckBox;
    btnSaveLog: TcxButton;
    btnApply: TcxButton;
    ckbNotifyWithPopup: TcxCheckBox;
    Label2: TLabel;
    edtNotifyDuration: TcxSpinEdit;
    Label3: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnApplyClick(Sender: TObject);
    procedure btnSaveLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigForm: TConfigForm;

implementation

uses
  Dialogs;

{$R *.dfm}

procedure TConfigForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TConfigForm.btnApplyClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TConfigForm.btnSaveLogClick(Sender: TObject);
var
  sLogDir, sLogFile: string;
begin
  sLogDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'log\';
  sLogFile := Format(sLogDir + 'XGAdminCall_%s.log', [FormatDateTime('yyyymmddhhnnss', Now)]);
  ForceDirectories(sLogDir);
  lbxLogView.Items.SaveToFile(sLogFile);
  ShowMessage('파일 저장 완료!'#13#10 + sLogFile);
end;

end.
