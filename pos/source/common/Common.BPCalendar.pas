unit Common.BPCalendar;

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Forms,
  Vcl.Controls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCalendars;

type
  TBPCalendarForm = class(TForm)
    panHeader: TPanel;
    btnClose: TSpeedButton;
    panBody: TPanel;
    CalendarView: TCalendarView;
    btnToday: TBitBtn;
    btnOK: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CalendarViewChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure CalendarViewDblClick(Sender: TObject);
  private
    { Private declarations }
    FBaseTitle: string;

    procedure SetSelectedDate(const ADate: TDateTime);
    function GetSelectedDate: TDateTime;
  public
    { Public declarations }
    property SelectedDate: TDateTime read GetSelectedDate write SetSelectedDate;
  end;

var
  BPCalendarForm: TBPCalendarForm;

implementation

uses
  { Native }
  System.DateUtils,
  { Project }
  Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure TBPCalendarForm.FormCreate(Sender: TObject);
begin
  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  LF := TLayeredForm.Create(nil);
  LF.Show;

  FBaseTitle := Self.Caption;
  CalendarView.Date := Now;
end;

procedure TBPCalendarForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TBPCalendarForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      Self.ModalResult := mrOK;
    VK_ESCAPE:
      Self.Close;
  end;
end;

procedure TBPCalendarForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPCalendarForm.btnTodayClick(Sender: TObject);
begin
  CalendarView.Date := Now;
end;

procedure TBPCalendarForm.CalendarViewChange(Sender: TObject);
begin
  panHeader.Caption := Format('%s (%s)', [FBaseTitle, FormatDateTime('yyyy³â mm¿ù ddÀÏ', CalendarView.Date)]);
end;

procedure TBPCalendarForm.CalendarViewDblClick(Sender: TObject);
begin
  Self.ModalResult := mrOK;
end;

function TBPCalendarForm.GetSelectedDate: TDateTime;
begin
  Result := CalendarView.Date;
end;

procedure TBPCalendarForm.SetSelectedDate(const ADate: TDateTime);
begin
  CalendarView.Date := ADate;
end;

end.
