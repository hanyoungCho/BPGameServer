unit Common.LayeredForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TLayeredForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    procedure CreateParams(var AParams: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  LayeredForm: TLayeredForm;

implementation

{$R *.dfm}

{ TLayerForm }

procedure TLayeredForm.CreateParams(var AParams: TCreateParams);
begin
  inherited;

  AParams.ExStyle := AParams.ExStyle or WS_EX_LAYERED or WS_EX_TRANSPARENT;
end;

procedure TLayeredForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TLayeredForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  Top := Application.MainForm.Top;
  Left := Application.MainForm.Left;
  Width := Application.MainForm.Width;
  Height := Application.MainForm.Height;
end;

end.
