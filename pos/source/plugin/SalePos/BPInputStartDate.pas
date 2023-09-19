unit BPInputStartDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, Vcl.Buttons,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, Vcl.WinXCalendars;

{$I ..\..\common\Common.BPCommon.inc}

type
  TBPInputStartDateForm = class(TForm)
    panInput: TPanel;
    panHeader: TPanel;
    CV: TCalendarView;
    lblProdNameTitle: TLabel;
    lblProdName: TLabel;
    btnClose: TSpeedButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnToday: TBitBtn;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure CVChange(Sender: TObject);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FBaseTitle: string;

    procedure SetProdName(const AValue: string);
    function GetSelectedDate: TDateTime;
    procedure SetSelectedDate(const AValue: TDateTime);
  public
    { Public declarations }
    property ProdName: string write SetProdName;
    property SelectedDate: TDateTime read GetSelectedDate write SetSelectedDate;
  end;

var
  BPInputStartDateForm: TBPInputStartDateForm;

implementation

uses
  { Native }
  System.DateUtils,
  { Project}
  Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPInputStartDateForm }

procedure TBPInputStartDateForm.FormCreate(Sender: TObject);
begin
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  LF := TLayeredForm.Create(nil);
  LF.Show;

  FBaseTitle := panHeader.Caption;
end;

procedure TBPInputStartDateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TBPInputStartDateForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      Self.ModalResult := mrOK;
    VK_ESCAPE:
      Self.ModalResult := mrCancel;
  end;
end;

procedure TBPInputStartDateForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPInputStartDateForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPInputStartDateForm.btnTodayClick(Sender: TObject);
begin
  CV.Date := Now;
end;

procedure TBPInputStartDateForm.CVChange(Sender: TObject);
begin
  panHeader.Caption := Format('%s (%s)', [FBaseTitle, FormatDateTime('yyyy³â mm¿ù ddÀÏ', CV.Date)]);
end;

procedure TBPInputStartDateForm.SetProdName(const AValue: string);
begin
  lblProdName.Caption := AValue;
end;

function TBPInputStartDateForm.GetSelectedDate: TDateTime;
begin
  Result := CV.Date;
end;

procedure TBPInputStartDateForm.SetSelectedDate(const AValue: TDateTime);
begin
  CV.Date := AValue;
end;

end.
