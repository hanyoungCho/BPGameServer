unit Frame.Intro.Top;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, Generics.Collections,
  FMX.Media;

type
  TIntroTop = class(TFrame)
    Timer: TTimer;
    MediaPlayer: TMediaPlayer;
    MediaPlayerControl: TMediaPlayerControl;
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MediaList: TList<string>;
    procedure Display;
  end;

implementation

{$R *.fmx}

{ TIntroTop }

procedure TIntroTop.Display;
var
  b: TOpenDialog;
  a: string;
begin
  MediaList := TList<string>.Create;
//  MediaList.Add(ExtractFilePath(ParamStr(0)) + '\Intro\Media\Media1.mp4');
//  MediaList.Add(ExtractFilePath(ParamStr(0)) + '\Intro\Media\Media2.mp4');
//  MediaPlayer.CurrentTime := 0;
  b := TOpenDialog.Create(nil);
  b.Execute;
  a := b.FileName;

  MediaList.Add(a);
  MediaPlayer.FileName := a;
  Timer.Enabled := True;
end;

procedure TIntroTop.TimerTimer(Sender: TObject);
var
  Index: Integer;
begin
  MediaPlayer.Play;
  Timer.Enabled := False;
//  if MediaPlayer.Duration = MediaPlayer.CurrentTime then
//  begin
//    MediaPlayer.Stop;
//    for Index := 0 to MediaList.Count - 1 do
//    begin
//      if MediaPlayer.FileName = MediaList[Index] then
//      begin
//        if (Index + 1) = MediaList.Count then
//          MediaPlayer.FileName := MediaList[0]
//        else
//          MediaPlayer.FileName := MediaList[Index + 1];
//      end;
//      MediaPlayer.CurrentTime := 0;
//      MediaPlayer.Play;
//    end;
//  end;
end;

end.
