unit Frame.FullPopup.Time.ItemStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TFullPopupTimeItemStyle = class(TFrame)
    Image: TImage;
    Text: TText;
    Rectangle: TRectangle;
    procedure FrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Bind(ATime: Integer);
  end;

implementation

uses
  Form.Full.Popup;

{$R *.fmx}

procedure TFullPopupTimeItemStyle.Bind(ATime: Integer);
begin
  Tag := ATime;
  Text.Text := Format('%s½Ã', [FormatFloat('00', Tag)]);
end;

procedure TFullPopupTimeItemStyle.FrameClick(Sender: TObject);
begin
  FullPopup.SetTimeText(Self.Tag);
end;

end.
