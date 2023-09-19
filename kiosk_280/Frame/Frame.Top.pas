unit Frame.Top;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects;

type
  TTop = class(TFrame)
    Layout: TLayout;
    recBody: TRectangle;
    Timer: TTimer;
    lblDay: TText;
    lblTime: TText;
    Rectangle3: TRectangle;
    txtNewMember: TText;
    Image3: TImage;
    txtStoreNm: TText;
    recBG: TRectangle;
    Image1: TImage;
    procedure TimerTimer(Sender: TObject);
    procedure recBodyClick(Sender: TObject);
    procedure txtNewMemberClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uGlobal, uCommon, uFunction, Form.Select.Box;

{$R *.fmx}

procedure TTop.recBodyClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TTop.TimerTimer(Sender: TObject);
begin
  Global.SaleModule.NowHour := format('%s(%s)', [FormatDateTime('MM¿ù DDÀÏ', now), GetWeekDay(now)]);
  Global.SaleModule.NowTime := FormatDateTime('hh:nn', now);
  lblDay.Text := Global.SaleModule.NowHour;
  lblTime.Text := Global.SaleModule.NowTime;
  txtStoreNm.Text := Global.Config.Store.StoreName;
end;

procedure TTop.txtNewMemberClick(Sender: TObject);
begin
  SelectBox.NewMember;
end;

end.
