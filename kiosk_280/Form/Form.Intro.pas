unit Form.Intro;

interface

uses
  FMX.Media,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, Frame.Bottom,
  Frame.Select.Box.Top.Map, Frame.Media, CPort;
type
  TIntro = class(TForm)
    BottomTimer: TTimer;
    Layout: TLayout;
    recBottom: TRectangle;
    recLaneStatus: TRectangle;
    Rectangle4: TRectangle;
    Text1: TText;
    Image2: TImage;
    recMedia: TRectangle;
    BottomImage: TImage;
    CloseRectangle: TRectangle;
    MediaFrame1: TMediaFrame;
    SelectBoxTopMap1: TSelectBoxTopMap;
    Text2: TText;
    Image1: TImage;
    procedure Rectangle4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseRectangleClick(Sender: TObject);
    procedure BottomTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormTouch(Sender: TObject; const Touches: TTouches;
      const Action: TTouchAction);
    procedure MediaFrame1Click(Sender: TObject);
  private
    { Private declarations }
    FInverval: Integer;
    FMediaIndex: Integer;
    FMiniMapInverval: Integer;
		FCnt: Integer;
	public
		{ Public declarations }
	end;

var
	Intro: TIntro;

implementation

uses
	uGlobal, uSaleModule, Form.Select.Box, uFunction, uCommon, uConsts;

{$R *.fmx}

procedure TIntro.FormCreate(Sender: TObject);
begin
//  FMediaThread := TMediaThread.Create;
	FCnt := 0;
end;

procedure TIntro.FormDestroy(Sender: TObject);
begin
//  BottomImage.Free;
  BottomImage := nil;
  MediaFrame1.Free;
  SelectBoxTopMap1.CloseFrame;
  SelectBoxTopMap1.Free;
  DeleteChildren;
//  FMediaThread.Free;
end;

procedure TIntro.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
  SelectBoxTopMap1.DisplayFloor;
  BottomTimer.Enabled := True;
//  BottomTimer.Interval := Global.Config.TeeBoxRefreshInterval * 1000; // 갱신 5초는 밑에서 cnt로 따로 체크
  MediaFrame1.PlayMedia;
end;

procedure TIntro.FormTouch(Sender: TObject; const Touches: TTouches;
  const Action: TTouchAction);
begin
  ModalResult := mrok;
end;

procedure TIntro.MediaFrame1Click(Sender: TObject);
begin
  CloseRectangleClick(nil);
end;

procedure TIntro.BottomTimerTimer(Sender: TObject);
begin
	//interval 1000
	inc(FCnt);

	//이미지 1초마다 점멸
	if Image2.Visible = False then
		Image2.Visible := True
	else
		Image2.Visible := False;

	//Global.Config.TeeBoxRefreshInterval 현재 5
	if FCnt = Global.Config.TeeBoxRefreshInterval then
	begin
		SelectBoxTopMap1.DisplayFloor;
		FCnt := 0;
	end;
end;

procedure TIntro.CloseRectangleClick(Sender: TObject);
begin
//  TouchSound;
  MediaFrame1.Timer.Enabled := False;
  MediaFrame1.MediaPlayer1.Stop;
  ModalResult := mrOk;
//  Close;
end;

procedure TIntro.Rectangle4Click(Sender: TObject);
begin
//
end;

end.
