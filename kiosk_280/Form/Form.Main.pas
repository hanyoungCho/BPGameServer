unit Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, FMX.ListView.Types, FMX.ListView.Appearances, FMX.Graphics,
  FMX.ListView.Adapters.Base, FMX.ListView, Windows, Winapi.ShellAPI,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.WebBrowser;

type
  TMain = class(TForm)
    Layout: TLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    SaleImage: TImage;
    ConfigImage: TImage;
    Text1: TText;
    Text2: TText;
    Rectangle3: TRectangle;
    SystemCloseImage: TImage;
    Text3: TText;
    Image4: TImage;
    Text4: TText;
    Rectangle4: TRectangle;
    CloseImage: TImage;
    Text5: TText;
    ReStartImage: TImage;
    Text6: TText;
    txtVersion: TText;
    Timer: TTimer;
    Text7: TText;
    BGRectangle: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure SaleImageClick(Sender: TObject);
    procedure ConfigImageClick(Sender: TObject);
    procedure CloseImageClick(Sender: TObject);
    procedure BGImageClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

uses
  uGlobal, uCommon, uConsts, uStruct, uConfig, uFunction;

{$R *.fmx}

procedure TMain.BGImageClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TMain.CloseImageClick(Sender: TObject); //�ý��� ����
begin
  TouchSound;
  Close;
end;

procedure TMain.ConfigImageClick(Sender: TObject);
begin
  TouchSound;
  ShowConfig;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  Global.MainHandle := THandle(Self.Handle); //newmember
end;

procedure TMain.FormShow(Sender: TObject);
var
  AHWND: HWND;
begin
  Global.SaleModule.SaleDate := FormatDateTime('yyyymmdd', now);
  {
  if not Global.SaleModule.ProgramUse then
  begin
    Global.SBMessage.ShowMessageModalForm(MSG_MASTERDOWN_FAIL_PROGRAM_RESTART);
    Close;
  end;
  }
  //�ӽ��ּ�
  //Global.SaleModule.MasterDownThread.Resume;

  Global.SaleModule.SoundThread.Resume;
  txtVersion.Text := 'Ver. ' + GetFileVersion;

  // ����� �ڵ����� ��������ȭ�� ȣ��
  Timer.Enabled := True;

end;

procedure TMain.SaleImageClick(Sender: TObject);
begin
  Timer.Enabled := False;
  TouchSound;
  Global.SaleModule.SaleDataClear;

  ShowSelectBox;
end;

procedure TMain.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  SaleImageClick(nil);
end;

end.
