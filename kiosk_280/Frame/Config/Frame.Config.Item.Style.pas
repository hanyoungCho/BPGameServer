unit Frame.Config.Item.Style;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Objects;

type
  TConfigItemStyle = class(TFrame)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    txtName: TText;
    cbPort: TComboBox;
    cbBaudRate: TComboBox;
    txtValueType: TText;
    txtValue: TText;
    procedure Rectangle1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Display(ASection, ATitle, AValue: string);
  end;

implementation

uses
  uCommon;

{$R *.fmx}

{ TConfigItemStyle }

procedure TConfigItemStyle.Display(ASection, ATitle, AValue: string);
begin
  txtName.Text := ASection;
  txtValueType.Text := ATitle;
  txtValue.Text := AValue;
end;

procedure TConfigItemStyle.Rectangle1Click(Sender: TObject);
begin
  TouchSound;
end;

end.
