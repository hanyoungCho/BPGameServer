unit Common.BPSplash;

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

interface

uses
  { Native }
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngImage,
  { Project }
  Common.LayeredWindow;

type
  TInitSplash = class(TForm)
    tmrSplash: TTimer;
    imgSplash: TImage;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure tmrSplashTimer(Sender: TObject);
  private
    FLayer: TLayeredWindow;
  public
    procedure LoadSplash(const ASetOnTop, AClickThrough: Boolean; const AFadeValue: Byte);
  end;

var
  InitSplash: TInitSplash;

implementation

{$R *.dfm}

procedure TInitSplash.LoadSplash(const ASetOnTop, AClickThrough: Boolean; const AFadeValue: Byte);
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    Left := (Screen.Width div 2 - imgSplash.Width div 2);
    Top  := (Screen.Height div 2 - imgSplash.Height div 2);
    ClientWidth  := imgSplash.Width;
    ClientHeight := imgSplash.Height;
    imgSplash.Picture.SaveToStream(MS);
    MS.Seek(0, soBeginning);
    FLayer := TLayeredWindow.Create(Self);
    ThroughLayerWindow := FLayer;
    with FLayer do
    begin
      LoadPNGintoBitmap32St(FBitmap, MS);
      SetClickThrough(AClickThrough);
      SetOnTop(ASetOnTop);
      Update(0);
      FadeTo(AFadeValue);
    end;
  finally
    MS.Free;
  end;
end;

procedure TInitSplash.tmrSplashTimer(Sender: TObject);
begin
  if FLayer.FadeBusy then
  begin
    tmrSplash.Interval := 100;
    Exit;
  end;
  Free;
end;

procedure TInitSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TInitSplash.FormDestroy(Sender: TObject);
begin
  FLayer.Free;
end;

end.