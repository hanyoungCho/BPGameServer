unit Frame.FullPopup.QRSend;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TFullPopupQRSend = class(TFrame)
    Rectangle1: TRectangle;
    txtTasukInfo: TText;
    Rectangle11: TRectangle;
    Image1: TImage;
    Text17: TText;
    Rectangle12: TRectangle;
    Image2: TImage;
    Text18: TText;
    BiominiRectangle: TRectangle;
    Image: TImage;
    ImageWellbeing: TImage;
    ImageTeeboxMove: TImage;
    Rectangle2: TRectangle;
    Text1: TText;
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uGlobal, uCommon, Form.Full.Popup, uConsts;

{$R *.fmx}

procedure TFullPopupQRSend.Image1Click(Sender: TObject);
begin
  TouchSound;
  FullPopup.CloseFormStrMrCancel;
end;

procedure TFullPopupQRSend.Image2Click(Sender: TObject);
label ReQRTry;
begin
  TouchSound;

  ReQRTry :

  if not Global.Database.AddNewMemberQR then
  begin
    if Global.SBMessage.ShowMessageModalForm('QR전송에 실패하였습니다.', False, 30, True, True) then
      goto ReQRTry
    else
      FullPopup.CloseFormStrMrCancel;
  end;

  FullPopup.CloseFormStrMrok('');

end;

end.
