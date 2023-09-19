unit Frame.FullPopup.Period;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TFullPopupPeriod = class(TFrame)
    Layout: TLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Image: TImage;
    Text1: TText;
    Text2: TText;
    txtTasukInfo: TText;
    Text4: TText;
    Timer1: TTimer;
    Rectangle4: TRectangle;
    txtUnionMsg2: TText;
    Rectangle5: TRectangle;
    txtUnionMsg1: TText;
    procedure ImageClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iSec: Integer;
  end;

implementation

uses
  uCommon, uConsts, uFunction;

{$R *.fmx}

{ TFullPopupPeriod }

procedure TFullPopupPeriod.ImageClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TFullPopupPeriod.Timer1Timer(Sender: TObject);
begin
  Inc(iSec);
  Text1.Text := '일치하는 지문이 없어 재시도 합니다.';
  Text2.Text := Format(TimeSecCaptionReTry, [LPadB(IntToStr(iSec), 2, ' ')]);
end;

end.
