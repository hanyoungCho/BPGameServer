unit Frame.Media;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Media, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TMediaFrame = class(TFrame)
    MediaPlayer1: TMediaPlayer;
    MediaPlayerControl1: TMediaPlayerControl;
    Timer: TTimer;
    Layout: TLayout;
    Rectangle1: TRectangle;
    procedure TimerTimer(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure MediaPlayerControl1Tap(Sender: TObject; const Point: TPointF);
    procedure MediaPlayerControl1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    { Private declarations }
    FMediaIndex: Integer;
    procedure MediaMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
  public
    { Public declarations }
    procedure PlayMedia;
    procedure CloseFrame;
  end;

implementation

uses
  uGlobal, Form.Intro, fx.Logging;

{$R *.fmx}

procedure TMediaFrame.CloseFrame;
var
  Index: Integer;
begin
  try
    if MediaPlayer1.ChildrenCount <> 0 then
    begin
      for Index := MediaPlayer1.ChildrenCount - 1 downto 0 do
        MediaPlayer1.Children[Index].Free;
    end;
  finally

  end;
end;

procedure TMediaFrame.MediaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  Intro.CloseRectangleClick(nil);
end;

procedure TMediaFrame.MediaPlayerControl1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  Intro.CloseRectangleClick(nil);
end;

procedure TMediaFrame.MediaPlayerControl1Tap(Sender: TObject;
  const Point: TPointF);
begin
  Intro.CloseRectangleClick(nil);
end;

procedure TMediaFrame.PlayMedia;
begin
  MediaPlayerControl1.MediaPlayer := MediaPlayer1;
  MediaPlayer1.Volume := 0;
  MediaPlayer1.Play;
  Timer.Enabled := True;
  MediaPlayerControl1.Parent := Rectangle1;
end;

procedure TMediaFrame.Rectangle1Click(Sender: TObject);
begin
  Intro.CloseRectangleClick(nil);
end;

procedure TMediaFrame.TimerTimer(Sender: TObject);
var
  Index: Integer;
begin
  try
    if (MediaPlayer1.State = TMediaState.Playing) and (MediaPlayer1.Duration = MediaPlayer1.CurrentTime) then
    begin
      MediaPlayer1.Stop;

      for Index := MediaPlayer1.ChildrenCount - 1 downto 0 do
        MediaPlayer1.Children[Index].Free;

      MediaPlayer1.DeleteChildren;

      Inc(FMediaIndex);
      if FMediaIndex < Global.SaleModule.AdvertListUp.Count then
      begin
        MediaPlayer1.FileName := Global.SaleModule.AdvertListUp[FMediaIndex].FilePath;
      end
      else
      begin
        FMediaIndex := 0;
        MediaPlayer1.FileName := Global.SaleModule.AdvertListUp[FMediaIndex].FilePath;
      end;

      MediaPlayer1.Volume := 0;
      MediaPlayerControl1.Visible := True;
      MediaPlayer1.Play;
    end
    else
    begin
      if MediaPlayer1.State = TMediaState.Stopped then
      begin
        if Global.SaleModule.AdvertListUp.Count <> 0 then
        begin
          for Index := MediaPlayer1.ChildrenCount - 1 downto 0 do
            MediaPlayer1.Children[Index].Free;

          MediaPlayer1.DeleteChildren;

          MediaPlayer1.FileName := Global.SaleModule.AdvertListUp[0].FilePath;
          MediaPlayer1.Volume := 0;
          MediaPlayer1.Play;
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      Log.E('TMediaFrame.TimerTimer', E.Message);
    end;
  end;
end;

end.
