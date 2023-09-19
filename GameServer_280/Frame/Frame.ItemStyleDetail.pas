unit Frame.ItemStyleDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uStruct, Vcl.ExtCtrls;

type
  TFrame2 = class(TFrame)
    Panel1: TPanel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Panel2: TPanel;
    Edit1: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Panel3: TPanel;
    Edit47: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit50: TEdit;
    Edit51: TEdit;
    Edit52: TEdit;
    Edit53: TEdit;
    Edit54: TEdit;
    Edit55: TEdit;
    Edit56: TEdit;
    Edit57: TEdit;
    Edit58: TEdit;
    Edit59: TEdit;
    Edit60: TEdit;
    Edit61: TEdit;
    Edit62: TEdit;
    Edit63: TEdit;
    Edit64: TEdit;
    Edit65: TEdit;
    Edit66: TEdit;
    Edit67: TEdit;
    Edit68: TEdit;
    Edit69: TEdit;
    Panel4: TPanel;
    Edit70: TEdit;
    Edit71: TEdit;
    Edit72: TEdit;
    Edit73: TEdit;
    Edit74: TEdit;
    Edit75: TEdit;
    Edit76: TEdit;
    Edit77: TEdit;
    Edit78: TEdit;
    Edit79: TEdit;
    Edit80: TEdit;
    Edit81: TEdit;
    Edit82: TEdit;
    Edit83: TEdit;
    Edit84: TEdit;
    Edit85: TEdit;
    Edit86: TEdit;
    Edit87: TEdit;
    Edit88: TEdit;
    Edit89: TEdit;
    Edit90: TEdit;
    Edit91: TEdit;
    Edit92: TEdit;
    Panel5: TPanel;
    Edit93: TEdit;
    Edit94: TEdit;
    Edit95: TEdit;
    Edit96: TEdit;
    Edit97: TEdit;
    Edit98: TEdit;
    Edit99: TEdit;
    Edit100: TEdit;
    Edit101: TEdit;
    Edit102: TEdit;
    Edit103: TEdit;
    Edit104: TEdit;
    Edit105: TEdit;
    Edit106: TEdit;
    Edit107: TEdit;
    Edit108: TEdit;
    Edit109: TEdit;
    Edit110: TEdit;
    Edit111: TEdit;
    Edit112: TEdit;
    Edit113: TEdit;
    Edit114: TEdit;
    Edit115: TEdit;
    Panel6: TPanel;
    Edit116: TEdit;
    Edit117: TEdit;
    Edit118: TEdit;
    Edit119: TEdit;
    Edit120: TEdit;
    Edit121: TEdit;
    Edit122: TEdit;
    Edit123: TEdit;
    Edit124: TEdit;
    Edit125: TEdit;
    Edit126: TEdit;
    Edit127: TEdit;
    Edit128: TEdit;
    Edit129: TEdit;
    Edit130: TEdit;
    Edit131: TEdit;
    Edit132: TEdit;
    Edit133: TEdit;
    Edit134: TEdit;
    Edit135: TEdit;
    Edit136: TEdit;
    Edit137: TEdit;
    Edit138: TEdit;
    Edit139: TEdit;
  private
    { Private declarations }
    //FSeatInfo: TSeatInfo;
    FHeatStatus: String;
    FReserveCnt: String;
  public
    { Public declarations }
    procedure DisPlaySeatInfo;

    //property SeatInfo: TSeatInfo read FSeatInfo write FSeatInfo;
    property HeatStatus: String read FHeatStatus write FHeatStatus;
    property ReserveCnt: String read FReserveCnt write FReserveCnt;
  end;

implementation

{$R *.dfm}

uses
  uGlobal;

{ TFrame1 }

procedure TFrame2.DisPlaySeatInfo;
begin
{
  Label1.Caption := SeatInfo.SeatNm;
  Label2.Caption := '[' + IntToStr(SeatInfo.SeatNo) + ']';
  Edit1.Text := IntToStr(SeatInfo.RemainMinute);
  Edit2.Text := IntToStr(SeatInfo.RemainBall);
  Edit4.Text := FReserveCnt;

  if SeatInfo.UseYn = 'Y' then
  begin
    if SeatInfo.UseStatus = '9' then
      Self.Color := clRed
    else if (SeatInfo.UseStatus = '7') or (SeatInfo.UseApiStatus = '8') then
      Self.Color := clSkyBlue
    else if (SeatInfo.UseStatus = '6') then
      Self.Color := clGreen
    else if (SeatInfo.UseStatus = '0') and (SeatInfo.UseLStatus = '1') and (Global.ADConfig.ProtocolType = 'JMS') then
        Self.Color := clTeal
    else if (SeatInfo.UseStatus = '0') and (SeatInfo.UseLStatus = '1') and (Global.ADConfig.StoreCode = 'A5001') then
        Self.Color := clTeal
    else if SeatInfo.HoldUse = True then
      Self.Color := clGray
    else
      Self.Color := clWhite;
  end
  else
  begin
    Self.Color := clBtnFace;
  end;

  if SeatInfo.ErrorYn = 'Y' then
    Edit1.Color := clRed
  else
    Edit1.Color := clWindow;

  if HeatStatus = '1' then
  begin
    Edit3.Text := 'H';
    Edit3.Color := clRed;
  end
  else
  begin
    Edit3.Text := '';
    Edit3.Color := clWindow;
  end;
  }
end;

end.
