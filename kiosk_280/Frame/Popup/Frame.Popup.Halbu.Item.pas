unit Frame.Popup.Halbu.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TPopupHalbuItem = class(TFrame)
    recBg: TRectangle;
    txtNm: TText;
    procedure recBgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FIdx: Integer;
    FHalbu: Integer;
    FSelect: Boolean;
    procedure DisPlay(AIdx: Integer);
    procedure SelectDisPlay(AUse: Boolean);
  end;

implementation

uses
  uConsts, Form.Full.Popup;

{$R *.fmx}

procedure TPopupHalbuItem.DisPlay(AIdx: Integer);
begin
  FIdx := AIdx;
  FHalbu := HalbuCnt[AIdx];
  txtNm.Text := HalbuNm[AIdx];
end;

procedure TPopupHalbuItem.SelectDisPlay(AUse: Boolean);
begin
  if AUse = True then
  begin
    txtNm.TextSettings.FontColor := TAlphaColorRec.White;
    recBg.Fill.Color := $FF3D55F5;
  end
  else
  begin
    txtNm.TextSettings.FontColor := $FF3D55F5;
    recBg.Fill.Color := TAlphaColorRec.White;
  end;
  FSelect := AUse;
end;

procedure TPopupHalbuItem.recBgClick(Sender: TObject);
begin
  FullPopup.selectHalbu(FIdx, FHalbu);
end;

end.
