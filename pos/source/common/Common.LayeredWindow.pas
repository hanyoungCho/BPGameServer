unit Common.LayeredWindow;

interface

uses
  { Native }
  Vcl.Forms, Winapi.Windows, System.SysUtils, System.Classes, System.Types, Vcl.Graphics,
  Vcl.Imaging.pngimage;

type
  TLayeredWindow = class(TObject)
  private
   xDC: HDC;
   thr: THandle;
   thrID: DWORD;

   procedure AddStyle(AStyle: Integer);
   procedure RemoveStyle(AStyle: Integer);
  public
   fClickThrough: Boolean;
   fOnTop: Boolean;
   fForm: TForm;
   fBitmap: TBitmap;
   fCurAlpha: Byte;
   fOldAlpha: Byte;
   DAlpha: Byte;
   fadeBusy: Boolean;

   constructor Create(Form: TForm);
   destructor Destroy; override;

   procedure SetClickThrough(const Value: Boolean);
   procedure SetOnTop(Value: Boolean);
   procedure ForceEndThread;
   procedure Update(Alpha: Byte);
   procedure FadeTo(DestAlpha: Byte);
   procedure LoadPNGintoBitmap32(DstBitmap: TBitmap; Filename: string);
   procedure LoadPNGintoBitmap32St(DstBitmap: TBitmap; SrcStream: TStream);
   procedure LoadPNGintoBitmap32Direct(DstBitmap: TBitmap; SrcImg: TPngImage); overload;
  end;

var
  ThroughLayerWindow: TLayeredWindow;

implementation

{ TLayeredWindow }

procedure TLayeredWindow.LoadPNGintoBitmap32(DstBitmap: TBitmap; Filename: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(Filename, fmOpenRead);
  try
    LoadPNGintoBitmap32St(DstBitmap, FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TLayeredWindow.LoadPNGintoBitmap32St(DstBitmap: TBitmap; SrcStream: TStream);
var
  PNG: TPngImage;
begin
  PNG := nil;
  try
    PNG := TPngImage.Create;
    PNG.LoadFromStream(SrcStream);
    DstBitmap.Assign(PNG);
  finally
    if Assigned(PNG) then
      PNG.Free;
  end;
end;

procedure TLayeredWindow.LoadPNGintoBitmap32Direct(DstBitmap: TBitmap; SrcImg: TPngImage);
begin
  DstBitmap.Assign(SrcImg);
end;

procedure TLayeredWindow.AddStyle(AStyle: Integer);
var
  Style: Integer;
begin
  Style := GetWindowLong(fForm.Handle, GWL_EXSTYLE);
  Style := Style or AStyle;
  SetWindowLong(fForm.Handle, GWL_EXSTYLE, Style);
end;

constructor TLayeredWindow.Create(Form: TForm);
begin
  fForm := Form;
  fClickThrough := false;
  fBitmap := TBitmap.Create;
  fadeBusy := False;

  AddStyle(WS_EX_LAYERED);
end;

destructor TLayeredWindow.Destroy;
begin
  fBitmap.Free();
  ReleaseDC(0,xDC);
  CloseHandle(thr);

  inherited;
end;

function FateToT(P : Pointer): LongInt; stdcall;
var
  DC: HDC;
  Blend: TBlendFunction;
  BmpTopLeft: TPoint;
  BMPSize: TSize;
  CurAlpha: real;
  StepSize: real;
begin
  with ThroughLayerWindow do
  begin
    fadeBusy := True;
    BMPSize.cx := fBitmap.Width;
    BMPSize.cy := fBitmap.Height;
    BmpTopLeft := Point(0, 0);
    DC := GetDC(0);
    if not Win32Check(LongBool(DC)) then
      RaiseLastOSError();

    with Blend do
    begin
      BlendOp := AC_SRC_OVER;
      BlendFlags := 0;
      AlphaFormat := AC_SRC_ALPHA;
      SourceConstantAlpha := fCurAlpha;
    end;

    StepSize := (DAlpha - fCurAlpha) / 25;
    if StepSize < 0 then
      StepSize := StepSize * -1;

    CurAlpha := fCurAlpha;
    if (DAlpha > CurAlpha) then
    begin
      while (DAlpha > CurAlpha) do
      begin
        try
          UpdateLayeredWindow(fForm.Handle, DC, nil, @BmpSize, fBitmap.Canvas.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA);
        finally
          CurAlpha := CurAlpha + StepSize;
          Blend.SourceConstantAlpha := byte(round(CurAlpha));
          Sleep(20);
        end;
      end;
    end
    else
    begin
      while (DAlpha < CurAlpha) do
      begin
        try
          UpdateLayeredWindow(fForm.Handle, DC, nil, @BmpSize, fBitmap.Canvas.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA);
        finally
          CurAlpha := CurAlpha - StepSize;
          Blend.SourceConstantAlpha := round(CurAlpha);
          Sleep(20);
        end;
      end;
    end;

    fadeBusy := False;
  end;
  ReleaseDC(0, DC);
end;

procedure TLayeredWindow.FadeTo(DestAlpha: Byte);
begin
  DAlpha := DestAlpha;
  thr := CreateThread(nil, 0, @FateToT, nil, 0, thrID);
end;

procedure TLayeredWindow.ForceEndThread;
begin
  TerminateThread(thr, thrID);
end;

procedure TLayeredWindow.RemoveStyle(AStyle: Integer);
var
  Style: Integer;
begin
  Style := GetWindowLong(fForm.Handle, GWL_EXSTYLE);
  Style := Style and (not AStyle);
  SetWindowLong(fForm.Handle, GWL_EXSTYLE, Style);
end;

procedure TLayeredWindow.SetClickThrough(const Value: Boolean);
begin
  if (fClickThrough <> Value) then
  begin
    if Value then
      AddStyle(WS_EX_TRANSPARENT)
    else
      RemoveStyle(WS_EX_TRANSPARENT);

    fClickThrough := Value;
  end;
end;

procedure TLayeredWindow.SetOnTop(Value: Boolean);
begin
  if (fOnTop <> Value) then
  begin
    if Value then
      fForm.FormStyle := fsStayOnTop
    else
      fForm.FormStyle := fsNormal;

    fOnTop := Value;
  end;
end;

procedure TLayeredWindow.Update(Alpha: Byte);
var
  Blend: TBlendFunction;
  TopLeft, BmpTopLeft: TPoint;
  BMPSize: TSize;
begin
  fOldAlpha := fCurAlpha;
  fCurAlpha := Alpha;

  BMPSize.cx := fBitmap.Width;
  BMPSize.cy := fBitmap.Height;
  TopLeft := fForm.BoundsRect.TopLeft;
  BmpTopLeft := Point(0, 0);
  xDC := GetDC(0);
  if not Win32Check(LongBool(xDC)) then
  RaiseLastOSError();

  with Blend do
  begin
   BlendOp := AC_SRC_OVER;
   BlendFlags := 0;
   SourceConstantAlpha := Alpha;
   AlphaFormat := AC_SRC_ALPHA;
  end;

  try
   UpdateLayeredWindow(fForm.Handle, xDC, @TopLeft, @BmpSize, fBitmap.Canvas.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA);
  except
  end;
end;

end.