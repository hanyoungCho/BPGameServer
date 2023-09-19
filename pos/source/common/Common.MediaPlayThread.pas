(*******************************************************************************

  Project     : 볼링픽
  Title       : MediaPlay Thread Unit
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-07-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

  [ 참고사항 ]

  TWindowsMediaPlayer.PlayState :

    wmppsUndefined: ; //$00000000;
    wmppsStopped: ; //$00000001;
    wmppsPaused: ; //$00000002;
    wmppsPlaying: ; //$00000003;
    wmppsScanForward: ; //$00000004;
    wmppsScanReverse: ; //$00000005;
    wmppsBuffering: ; //$00000006;
    wmppsWaiting: ; //$00000007;
    wmppsMediaEnded: ; //$00000008;
    wmppsTransitioning: ; //$00000009;
    wmppsReady: ; //$0000000A;
    wmppsReconnecting: ; //$0000000B;
    wmppsLast: ; //$0000000C;

    https://docs.microsoft.com/en-us/windows/desktop/wmp/player-playstate

*******************************************************************************)
{$M+}
unit Common.MediaPlayThread;

interface

uses
  { Native }
  System.SysUtils, System.Classes,
  { VideoGrrabber }
  VidGrab,
  { SolbiLib }
  PicShow;

type
  { 미디어 콘텐츠 정보 }
  PContentInfo = ^TContentInfo;
  TContentInfo = record
    OrderNo: Integer;   //재생순서
    FileUrl: string;    //미디어 파일 다운로드 URL
    FileName: string;   //미디어 파일명
    PlayTime: Integer;  //재생시간(초)
    Stretch: Boolean;   //이미지 스트레칭 처리 여부
    StartDate: string;  //시작일자(yyyy-mm-dd)
    EndDate: string;    //종료일자(yyyy-mm-dd)
    StartTime: string;  //시작시작(hh:nn)
    EndTime: string;    //종료시각(hh:nn)
  end;

  { 미디어 콘텐츠 재생 쓰레드 }
  TMediaPlayThread = class(TThread)
  private
    FActive: Boolean;
    FContents: TList;
    FContentsDir: string;
    FPicShow: TPicShow;
    FVideoPlayer: TVideoGrabber;
    FAudioVolume: Integer;
    FTransitionEffectStyle: Integer;
    FOnChangeActive: TNotifyEvent;
    FOnChangeContent: TNotifyEvent;
    FItemIndex: Integer;
    FInterval: Integer;
    FLastWorked: TDateTime;
    FVideoPlaying: Boolean;

    procedure DoPlay;

    procedure SetActive(const AValue: Boolean);
    procedure SetContents(const AList: TList);
    procedure SetAudioVolume(const AAudioVolume: Integer);
  protected
    procedure Execute; override;
  published
    constructor Create(const ACreateSuspended: Boolean; APicShow: TPicShow; AVideoGrabber: TVideoGrabber; const AContentsDir: string);
    destructor Destroy; override;
  public
    property Active: Boolean read FActive write SetActive default False;
    property Contents: TList read FContents write SetContents;
    property ContentsDir: string read FContentsDir write FContentsDir;
    property ItemIndex: Integer read FItemIndex write FItemIndex default -1;
    property AudioVolume: Integer read FAudioVolume write SetAudioVolume;
    property VideoPlaying: Boolean read FVideoPlaying write FVideoPlaying default False;
    property TransitionEffectStyle: Integer read FTransitionEffectStyle write FTransitionEffectStyle default 0;
    property OnChangeActive: TNotifyEvent read FOnChangeActive write FOnChangeActive;
    property OnChangeContent: TNotifyEvent read FOnChangeContent write FOnChangeContent;
  end;

implementation

uses
  Winapi.Windows, System.Math, System.DateUtils, Vcl.Forms;

{ TMediaPlayThread }

constructor TMediaPlayThread.Create(const ACreateSuspended: Boolean; APicShow: TPicShow; AVideoGrabber: TVideoGrabber; const AContentsDir: string);
begin
  inherited Create(ACreateSuspended);

  FreeOnTerminate := True;
  if Assigned(AVideoGrabber) then
    FVideoPlayer := AVideoGrabber;
  if Assigned(APicShow) then
    FPicShow := APicShow;

  ContentsDir := AContentsDir;
  FItemIndex := -1;
  FInterval := 0;
  FLastWorked := Now;
  FActive := False;
end;

destructor TMediaPlayThread.Destroy;
begin
  inherited;
end;

procedure TMediaPlayThread.SetActive(const AValue: Boolean);
begin
  if (Active <> AValue) then
  begin
    FActive := AValue;
    if not FActive then
    begin
      FPicShow.Stop;
      FVideoPlayer.StopPlayer;
    end;

    if Assigned(FOnChangeActive) then
      FOnChangeActive(Self);
  end;
end;

procedure TMediaPlayThread.SetAudioVolume(const AAudioVolume: Integer);
begin
  if (FAudioVolume <> AAudioVolume) then
  begin
    FAudioVolume := AAudioVolume;
    FVideoPlayer.AudioVolume := Trunc(FAudioVolume * (MaxWord / 100));
  end;
end;

procedure TMediaPlayThread.SetContents(const AList: TList);
begin
  try
    Suspend;
    FContents := AList;
    FItemIndex := -1;
  finally
    Resume;
  end;
end;

procedure TMediaPlayThread.Execute;
begin
  inherited;

  repeat
    if Active and
       Assigned(FContents) and
       (Contents.Count > 0) and
       (not VideoPlaying) and
       (SecondsBetween(FLastWorked, Now) > FInterval) then
      Synchronize(DoPlay);

    WaitForSingleObject(Handle, 500);
    //Sleep(100);
  until Terminated;
end;

procedure TMediaPlayThread.DoPlay;
var
  sFileName, sFileExt, sCurrDate, sCurrTime, sStartDate, sEndDate, sStartTime, sEndTime: string;
  bStretch, bChanged: Boolean;
  nStyle: Integer;
begin
  FLastWorked := Now;
  try
    Inc(FItemIndex);
    if (FItemIndex >= Contents.Count) then
    begin
      FItemIndex := -1;
      Exit;
    end;

    sFileName := ContentsDir + PContentInfo(Contents[FItemIndex])^.FileName;
    if (not FileExists(sFileName)) then
      Exit;

    sCurrDate := FormatDateTime('yyyy-mm-dd', Now);
    sCurrTime := FormatDateTime('hh:nn', Now);
    sStartDate := PContentInfo(Contents[FItemIndex])^.StartDate;
    sEndDate := PContentInfo(Contents[FItemIndex])^.EndDate;
    sStartTime := PContentInfo(Contents[FItemIndex])^.StartTime;
    sEndTime := PContentInfo(Contents[FItemIndex])^.EndTime;
    if ((not sStartDate.IsEmpty) and (sStartDate > sCurrDate)) or
       ((not sEndDate.IsEmpty) and (sEndDate < sCurrDate)) or
       ((not sStartTime.IsEmpty) and (sStartTime > sCurrTime)) or
       ((not sEndDate.IsEmpty) and (sEndTime < sCurrTime)) then
    begin
      FPicShow.Stop;
      FPicShow.BringToFront;
      Exit;
    end;

    bChanged := False;
    bStretch := PContentInfo(Contents[FItemIndex])^.Stretch;
    FInterval := PContentInfo(Contents[FItemIndex])^.PlayTime;
    if (FInterval = 0) then
    	FInterval := 1;
    sFileExt := LowerCase(ExtractFileExt(sFileName));
    if (sFileExt = '.jpg') then
    begin
      fPicShow.Picture.LoadFromFile(sFileName);
      nStyle := TransitionEffectStyle;
      if (nStyle = 0) then
      begin
        Randomize;
        nStyle := RandomRange(1, 176);
      end;

      FVideoPlayer.StopPlayer;
      FVideoPlayer.ClosePlayer;
      FVideoPlayer.SendToBack;

      FPicShow.Stop;
      FPicShow.BringToFront;
      FPicShow.Stretch := bStretch;
      FPicShow.Picture.LoadFromFile(sFileName);
      FPicShow.Style := TShowStyle(nStyle);
      FPicShow.Execute;
      bChanged := True;
    end
    else if (sFileExt = '.mp4') then
    begin
      FPicShow.Stop;
      FPicShow.SendToBack;

      FVideoPlayer.StopPlayer;
      FVideoPlayer.ClosePlayer;
      FVideoPlayer.BringToFront;
      FVideoPlayer.AudioDeviceRendering := False;
      FVideoPlayer.AudioVolume := Trunc(AudioVolume * (MaxWord / 100));
      FVideoPlayer.AudioDeviceRendering := (FVideoPlayer.AudioVolume > 0);
      FVideoPlayer.PlayerFileName := sFileName;
      FVideoPlayer.OpenPlayer;
      FVideoPlayer.RunPlayer;
      VideoPlaying := True;
      bChanged := True;
    end;

    if bChanged and
       Assigned(FOnChangeContent) then
      FOnChangeContent(Self);
  except
    on E: Exception do;
  end;
end;

end.
