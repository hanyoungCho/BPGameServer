unit BPMonitor.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Forms,
  Data.DB, Vcl.Graphics, Vcl.Controls, Winapi.CommCtrl, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.VirtualImage,
  { VideoGrabber }
  VidGrab,
  { SolbiLib }
  PicShow,
  { SVGIconImageList }
  SVGIconImageListBase, SVGIconVirtualImageList, SVGIconImage, SVGIconImageCollection,
  { StylecComponents }
  Vcl.StyledButton,
  { Project }
  Common.MediaPlayThread;

const
  LCN_PIN_MAX: ShortInt = 10;

type
  TPageControl = class(Vcl.ComCtrls.TPageControl)
  private
    procedure TCMAdjustRect(var AMsg: TMessage); message TCM_ADJUSTRECT; //uses Winapi.CommCtrl
  end;

  {$M+}
  TBaseTimerThread = class(TThread)
  private
    FActive: Boolean;
    FLastWorked: TDateTime;
    FForceRefresh: Boolean;
    FIsBlink: Boolean;
    FInterval: Integer; //밀리초
  protected
    procedure Execute; override;
  published
    constructor Create;
    destructor Destroy; override;

    property Interval: Integer read FInterval write FInterval;
    property LastWorked: TDateTime read FLastWorked write FLastWorked;
    property ForceRefresh: Boolean read FForceRefresh write FForceRefresh;
  end;
  {$M-}

  TPinInfo = record
    PinImage: TVirtualImage;
    PinNo: TLabel;
  end;

  TBPMonitorForm = class(TForm)
    pgcMain: TPageControl;
    tabReady: TTabSheet;
    tabScoreboard: TTabSheet;
    tabPinResult: TTabSheet;
    tabMediaPlay: TTabSheet;
    VideoGrabber: TVideoGrabber;
    PicShow: TPicShow;
    imcPngRes: TImageCollection;
    dsrGameStatus: TDataSource;
    panScoreFooter: TPanel;
    panScoreBody: TPanel;
    panFrameHeader: TPanel;
    panFrameHeaderLaneNo10: TPanel;
    panFrameHeaderLaneNo9: TPanel;
    panFrameHeaderLaneNo8: TPanel;
    panFrameHeaderLaneNo7: TPanel;
    panFrameHeaderLaneNo6: TPanel;
    panFrameHeaderLaneNo5: TPanel;
    panFrameHeaderLaneNo4: TPanel;
    panFrameHeaderLaneNo3: TPanel;
    panFrameHeaderLaneNo2: TPanel;
    panFrameHeaderLaneNo1: TPanel;
    TemplateGamePanel2: TPanel;
    TemplateBowlerPanel2: TPanel;
    TemplateBowlerNameLabel2: TLabel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel42: TPanel;
    Panel43: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    Panel50: TPanel;
    Panel51: TPanel;
    Panel52: TPanel;
    Panel53: TPanel;
    Panel54: TPanel;
    TemplateTotalPanel2: TPanel;
    TemplateStatusPanel2: TPanel;
    Panel2: TPanel;
    imcSvgRes: TSVGIconImageCollection;
    TemplateRentShoesIcon2: TSVGIconImage;
    imlSvgRes: TSVGIconVirtualImageList;
    TemplateUserIcon2: TSVGIconImage;
    TemplateDirectionIcon2: TSVGIconImage;
    SVGIconImage4: TSVGIconImage;
    panFrameHeaderGameNo: TPanel;
    panFrameHeaderTotal: TPanel;
    TemplateGamePanel1: TPanel;
    TemplateBowlerPanel1: TPanel;
    TemplateBowlerNameLabel1: TLabel;
    TemplateStatusPanel1: TPanel;
    TemplateRentShoesIcon1: TSVGIconImage;
    TemplateUserIcon1: TSVGIconImage;
    TemplateDirectionIcon1: TSVGIconImage;
    Panel58: TPanel;
    Panel59: TPanel;
    Panel60: TPanel;
    Panel61: TPanel;
    Panel62: TPanel;
    Panel63: TPanel;
    Panel64: TPanel;
    Panel65: TPanel;
    Panel66: TPanel;
    Panel67: TPanel;
    Panel68: TPanel;
    Panel69: TPanel;
    Panel70: TPanel;
    Panel71: TPanel;
    Panel72: TPanel;
    Panel73: TPanel;
    Panel74: TPanel;
    Panel75: TPanel;
    Panel76: TPanel;
    Panel77: TPanel;
    Panel78: TPanel;
    Panel79: TPanel;
    Panel80: TPanel;
    Panel81: TPanel;
    Panel82: TPanel;
    Panel83: TPanel;
    Panel84: TPanel;
    Panel85: TPanel;
    Panel86: TPanel;
    Panel87: TPanel;
    Panel88: TPanel;
    Panel89: TPanel;
    Panel90: TPanel;
    Panel91: TPanel;
    Panel93: TPanel;
    Panel94: TPanel;
    Panel95: TPanel;
    SVGIconImage8: TSVGIconImage;
    Panel97: TPanel;
    Panel98: TPanel;
    TemplateTotalPanel1: TPanel;
    tmrRunOnce: TTimer;
    imgPin1: TVirtualImage;
    imgPin2: TVirtualImage;
    imgPin3: TVirtualImage;
    imgPin4: TVirtualImage;
    imgPin5: TVirtualImage;
    imgPin6: TVirtualImage;
    imgPin7: TVirtualImage;
    imgPin8: TVirtualImage;
    imgPin9: TVirtualImage;
    imgPin10: TVirtualImage;
    imgPinBase: TVirtualImage;
    imgPinArrow: TVirtualImage;
    lblPinNo1: TLabel;
    lblPinNo2: TLabel;
    lblPinNo3: TLabel;
    lblPinNo4: TLabel;
    lblPinNo5: TLabel;
    lblPinNo6: TLabel;
    lblPinNo7: TLabel;
    lblPinNo8: TLabel;
    lblPinNo9: TLabel;
    lblPinNo10: TLabel;
    imgLogo: TImage;
    Panel1: TPanel;
    SVGIconImage1: TSVGIconImage;
    SVGIconImage2: TSVGIconImage;
    SVGIconImage3: TSVGIconImage;
    StyledButton1: TStyledButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure OnPinNoClick(Sender: TObject);
    procedure VideoGrabberLog(Sender: TObject; LogType: TLogType; Severity, InfoMsg: string);
    procedure VideoGrabberPlayerStateChanged(Sender: TObject; OldPlayerState,
      NewPlayerState: TPlayerState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrRunOnceTimer(Sender: TObject);
  private
    { Private declarations }
    FBaseTimerThread: TBaseTimerThread;
    FPinList: TArray<TPinInfo>;
  protected
    { Protected declarations }
{$IFDEF RELEASE}
    procedure CreateParams(var AParams: TCreateParams); override;
{$ENDIF}
  public
    { Public declarations }
  end;

var
  MainForm: TBPMonitorForm;
  MediaPlayThread: TMediaPlayThread;

implementation

uses
  { Native }
  System.DateUtils, System.Math,
  { Project }
  Common.BPCommonLib;

{$R *.dfm}

procedure TBPMonitorForm.FormCreate(Sender: TObject);
var
  I: ShortInt;
begin
{$IFDEF RELEASE}
  ShowCursor(False);
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0, nil, 0);
  ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_HIDE);
{$ENDIF}
  SetDoubleBuffered(Self, True);
  Self.Top := 0;
  Self.Left := 0;
  with pgcMain do
  begin
    Color := clBlack;
    for I := 0 to Pred(PageCount) do
    begin
      Pages[I].TabVisible := False;
      Pages[I].Brush.Color := clBlack;
    end;
//    tabPinResult.Brush.Color := clWhite;
    ActivePage := tabScoreboard;
  end;

  SetLength(FPinList, LCN_PIN_MAX);
  for I := 0 to Pred(LCN_PIN_MAX) do
  begin
    FPinList[I].PinImage := TVirtualImage(FindComponent('imgPin' + Succ(I).ToString));
    FPinList[I].PinImage.Tag := I;
    FPinList[I].PinImage.ImageCollection := imcPngRes;
    FPinList[I].PinImage.Width := 156;
    FPinList[I].PinImage.Height := 410;
    FPinList[I].PinImage.ImageIndex := 1;
    FPinList[I].PinImage.OnClick := OnPinNoClick;
    FPinList[I].PinNo := TLabel(FindComponent('lblPinNo' + Succ(I).ToString));
    FPinList[I].PinNo.Tag := I;
    FPinList[I].PinNo.Visible := False;
    FPinList[I].PinNo.OnClick := OnPinNoClick;
  end;

  imgLogo.Picture.Assign(imcPngRes.GetBitmap(0, 806, 132));
  PicShow.Proportional := True; //이미지 출력 시 비례항 사용
  PicShow.BgPicture.Assign(imgLogo.Picture);
  with VideoGrabber do
  begin
    DoubleBuffered := True;
    Display_Embedded := True;
    Display_AspectRatio := ar_Stretch; //ar_PanScan; //ar_Box;
    TextOverlay_String := '';
    TextOverlay_Enabled := True;
    SetLogoFromTImage(imgLogo);
    LogoDisplayed := True;
    LogoLayout := lg_Centered;
  end;

  MakeRoundedControl(TemplateGamePanel1, 30, 30);
  MakeRoundedControl(TemplateGamePanel2, 30, 30);
  panScoreFooter.Color := clBlack;
  panScoreBody.Color := clBlack;
  panScoreBody.Left := (Self.Width div 2) - (panScoreBody.Width div 2);
  panScoreBody.Top := (Self.Height div 2) - (panScoreBody.Height div 2) - 100;

  FBaseTimerThread := TBaseTimerThread.Create;
  FBaseTimerThread.FreeOnTerminate := True;
  tmrRunOnce.Interval := 100;
  tmrRunOnce.Enabled := True;
end;

{$IFDEF RELEASE}
procedure TBPMonitorForm.CreateParams(var AParams: TCreateParams);
begin
  inherited;

  AParams.ExStyle := AParams.ExStyle or WS_EX_TOPMOST;
  AParams.WndParent := 0;
end;
{$ENDIF}

procedure TBPMonitorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PicShow.Stop;
  VideoGrabber.StopPlayer;
  VideoGrabber.ClosePlayer;
end;

procedure TBPMonitorForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FBaseTimerThread) then
    FBaseTimerThread.Terminate;
{$IFDEF RELEASE}
  ShowCursor(True);
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 1, nil, 0);
  ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_SHOW);
{$ENDIF}
end;

procedure TBPMonitorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F1: pgcMain.ActivePageIndex := 0;
    VK_F2: pgcMain.ActivePageIndex := 1;
    VK_F3: pgcMain.ActivePageIndex := 2;
    VK_F4: pgcMain.ActivePageIndex := 3;
  end;
end;

procedure TBPMonitorForm.tmrRunOnceTimer(Sender: TObject);
begin
  with TTimer(Sender) do
  try
    Enabled := False;
    if not FBaseTimerThread.Started then
      FBaseTimerThread.Start;
  finally
    Free;
  end;
end;

procedure TBPMonitorForm.OnPinNoClick(Sender: TObject);
var
  LIndex: ShortInt;
begin
  LIndex := TControl(Sender).Tag;
  with FPinList[LIndex].PinImage do
    if (ImageIndex = -1) then
    begin
      ImageIndex := 1;
      FPinList[LIndex].PinNo.Visible := True;
    end
    else
    begin
      ImageIndex := -1;
      FPinList[LIndex].PinNo.Visible := False;
    end;
end;

procedure TBPMonitorForm.VideoGrabberLog(Sender: TObject; LogType: TLogType; Severity, InfoMsg: string);
begin
  if (LogType in [TLogType.e_failed, TLogType.e_failed_to_open_player]) then
    MediaPlayThread.VideoPlaying := False;
end;

procedure TBPMonitorForm.VideoGrabberPlayerStateChanged(Sender: TObject; OldPlayerState, NewPlayerState: TPlayerState);
begin
  if Assigned(MediaPlayThread) and
     (OldPlayerState = ps_Playing) and ((NewPlayerState = ps_Paused) or (NewPlayerState = ps_Stopped)) then
  begin
    TVideoGrabber(Sender).StopPlayer;
    TVideoGrabber(Sender).ClosePlayer;
    MediaPlayThread.VideoPlaying := False;
  end;
end;

{ TPageControl }

procedure TPageControl.TCMAdjustRect(var AMsg: TMessage);
begin
  inherited;

  if (AMsg.WParam = 0) then
    InflateRect(PRect(AMsg.LParam)^, 4, 4)
  else
    InflateRect(PRect(AMsg.LParam)^, -4, -4);
end;

{ TBaseTimerThread }

constructor TBaseTimerThread.Create;
begin
  inherited Create(True);

  FActive := False;
  FIsBlink := False;
  FLastWorked := (Now - 1);
  FInterval := 500;
  FForceRefresh := False;
end;

destructor TBaseTimerThread.Destroy;
begin

  inherited;
end;

procedure TBaseTimerThread.Execute;
begin
  inherited;

  repeat
    if (ForceRefresh or (MilliSecondsBetween(LastWorked, Now) > Interval)) then
    begin
      Synchronize(
        procedure
        begin
          LastWorked := Now;
          if ForceRefresh then
            ForceRefresh := False;
          FIsBlink := (not FIsBlink);
          MainForm.TemplateDirectionIcon2.ImageIndex := IfThen(FIsBlink, 7, -1);
        end);
    end;
    WaitForSingleObject(Handle, 100);
  until Terminated;
end;

end.
