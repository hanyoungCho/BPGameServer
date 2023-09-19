unit Form.PolicyView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts,
  Generics.Collections;

type
  TfrmPolicyView = class(TForm)
    Image: TImage;
    Rectangle3: TRectangle;
    recOK: TRectangle;
    Image4: TImage;
    Text18: TText;
    txtTitle: TText;
    Layout: TLayout;
    Rectangle: TRectangle;
    Rectangle1: TRectangle;
    ImagePrev: TImage;
    ImageNext: TImage;
    PageRectangle: TRectangle;
    procedure recOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImageNextClick(Sender: TObject);
    procedure ImagePrevClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FMaxPage: Integer;
    FActivePage: Integer;

  public
    { Public declarations }
    FPolicyType: Integer;
  end;

var
  frmPolicyView: TfrmPolicyView;

implementation

uses
  uGlobal, uConsts, uStruct;

{$R *.fmx}

procedure TfrmPolicyView.FormCreate(Sender: TObject);
begin
  FMaxPage := 0;
  FActivePage := 1;
end;

procedure TfrmPolicyView.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TfrmPolicyView.FormShow(Sender: TObject);
var
  sLoadFile: String;
  nIdx: Integer;
begin

    FMaxPage := 1;

  ImagePrev.Visible := FMaxPage > 1;
  ImageNext.Visible := FMaxPage > 1;
  PageRectangle.Visible := FMaxPage > 1;
  ImagePrev.Visible := FActivePage <> 1;
  ImageNext.Visible := FActivePage <> FMaxPage;


  if FPolicyType = 1 then  //1.서비스이용약관동의
  begin
    sLoadFile := 'D:\Works\BowlingPick\bin_kiosk\Image\서비스약관.jpg';
    Image.Bitmap.LoadFromFile(sLoadFile)
  end
  else if FPolicyType = 2 then  //2.개인정보수집이용동의
  begin
    sLoadFile := 'D:\Works\BowlingPick\bin_kiosk\Image\개인정보동의서.jpg';
    Image.Bitmap.LoadFromFile(sLoadFile)
  end
  else if FPolicyType = 3 then  //3.바이오정보수집이용제공동의
  begin
    sLoadFile := 'D:\Works\BowlingPick\bin_kiosk\Image\바이오동의서.jpg';
    Image.Bitmap.LoadFromFile(sLoadFile)
  end;

end;

procedure TfrmPolicyView.ImageNextClick(Sender: TObject);
var
  sLoadFile: String;
begin
//
end;

procedure TfrmPolicyView.ImagePrevClick(Sender: TObject);
var
  sLoadFile: String;
  nPage: Integer;
begin
//
end;

procedure TfrmPolicyView.recOKClick(Sender: TObject);
begin
  //1654*2339
  ModalResult := mrOk;
end;

end.
