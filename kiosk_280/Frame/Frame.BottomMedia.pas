unit Frame.BottomMedia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Media, FMX.Layouts;

type
  TBottomMedia = class(TFrame)
    Layout: TLayout;
    recMediaBottom: TRectangle;
    MediaPlayerBottom: TMediaPlayer;
    Image: TImage;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FMediaIndex: Integer;
    FIndex: Integer;
    MediaPlayerControlTm: TMediaPlayerControl;
  public
    { Public declarations }
    procedure PlayMedia;
    procedure StopMedia;
    procedure CloseFrame;

    procedure Display;
    function ChangeImg: Integer;
  end;

implementation

uses
  uGlobal, Form.Intro, fx.Logging;

{$R *.fmx}

{ TFrame1 }

procedure TBottomMedia.CloseFrame;
var
  Index: Integer;
begin
  try
    if MediaPlayerBottom.ChildrenCount <> 0 then
    begin
      for Index := MediaPlayerBottom.ChildrenCount - 1 downto 0 do
        MediaPlayerBottom.Children[Index].Free;
    end;
  finally

  end;
end;

procedure TBottomMedia.PlayMedia;
var
  sLog: String;
  MyRect: TRect;
begin

  if MediaPlayerControlTm = nil then
    MediaPlayerControlTm := TMediaPlayerControl.Create(nil);

  MediaPlayerControlTm.MediaPlayer := MediaPlayerBottom;
  MediaPlayerBottom.Volume := 0;

  if Global.SaleModule.AdvertisementListComplex.Count <> 0 then
  begin
    MediaPlayerBottom.FileName := Global.SaleModule.AdvertisementListComplex[0].FilePath;
  end;

  MediaPlayerBottom.Play;

  Timer.Enabled := True;
  MediaPlayerControlTm.Parent := recMediaBottom;
  MediaPlayerControlTm.Align := TAlignLayout.Client;

end;

procedure TBottomMedia.StopMedia;
begin
  Timer.Enabled := False;
  if MediaPlayerControlTm <> nil then
  begin
    MediaPlayerBottom.Stop;
    MediaPlayerControlTm.Free;
    MediaPlayerControlTm := nil;
  end;
end;

procedure TBottomMedia.TimerTimer(Sender: TObject);
var
  Index: Integer;
begin

  try
    if (MediaPlayerBottom.State = TMediaState.Playing) and (MediaPlayerBottom.Duration = MediaPlayerBottom.CurrentTime) then
    begin
      MediaPlayerBottom.Stop;

      for Index := MediaPlayerBottom.ChildrenCount - 1 downto 0 do
        MediaPlayerBottom.Children[Index].Free;

      MediaPlayerBottom.DeleteChildren;

      Inc(FMediaIndex);
      if FMediaIndex < Global.SaleModule.AdvertisementListComplex.Count then
      begin
        MediaPlayerBottom.FileName := Global.SaleModule.AdvertisementListComplex[FMediaIndex].FilePath;
        //MediaPlayerBottom.FileName := 'D:\Works\XGolf\bin_kiosk\Intro\Media\640360.mp4';
      end
      else
      begin
        FMediaIndex := 0;
        MediaPlayerBottom.FileName := Global.SaleModule.AdvertisementListComplex[FMediaIndex].FilePath;
        //MediaPlayerBottom.FileName := 'D:\Works\XGolf\bin_kiosk\Intro\Media\640360.mp4';
      end;

      MediaPlayerBottom.Volume := 0;
      MediaPlayerControlTm.Visible := True;
      MediaPlayerBottom.Play;
    end
    else
    begin
      if MediaPlayerBottom.State = TMediaState.Stopped then
      begin
        if Global.SaleModule.AdvertisementListComplex.Count <> 0 then
        begin
          for Index := MediaPlayerBottom.ChildrenCount - 1 downto 0 do
            MediaPlayerBottom.Children[Index].Free;

          MediaPlayerBottom.DeleteChildren;

          MediaPlayerBottom.FileName := Global.SaleModule.AdvertisementListComplex[0].FilePath;
          //MediaPlayerBottom.FileName := 'D:\Works\XGolf\bin_kiosk\Intro\Media\640360.mp4';
          MediaPlayerBottom.Volume := 0;
          MediaPlayerBottom.Play;
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      Log.E('TBottomMedia.TimerTimer', E.Message);
//      Global.SBMessage.ShowMessageModalForm(E.Message);
    end;
  end;

end;

function TBottomMedia.ChangeImg: Integer;
begin
  try
    Result := 1;
    if Global.SaleModule.AdvertisementListComplex.Count <> 0 then
    begin
      if FIndex <= (Global.SaleModule.AdvertisementListComplex.Count - 1) then
      begin
        //2021-08-24 임시주석 ntdll
        //Global.Database.SendAdvertisCnt(IntToStr(Global.SaleModule.AdvertisementListComplex[FIndex].Seq));
        Image.Bitmap := Global.SaleModule.AdvertisementListComplex[FIndex].Image;
        Inc(FIndex);
      end
      else
      begin
        FIndex := 0;
        ChangeImg;
      end;
    end;
  except
    on E: Exception do
    begin
      Log.E('ChangeImg', E.Message);
      Log.E('ChangeImg FIndex', IntToStr(FIndex));
      Log.E('ChangeImg AdvertisementListComplex.Count', IntToStr(Global.SaleModule.AdvertisementListComplex.Count));
      //Log.E('ChangeImg', E.Message);
    end;
  end;
end;

procedure TBottomMedia.Display;
begin
  FIndex := 0;

  if Global.SaleModule.AdvertisementListDown.Count <> 0 then
  begin
    //2021-08-24 임시주석
    //Global.Database.SendAdvertisCnt(IntToStr(Global.SaleModule.AdvertisementListComplex[0].Seq));
    Image.Bitmap.LoadFromFile(Global.SaleModule.AdvertisementListComplex[0].FilePath2);
    Inc(FIndex);
  end;

end;

end.
