unit Common.BPZipCode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Controls,
  Vcl.Forms, Winapi.WebView2, Winapi.ActiveX, Vcl.Edge, Vcl.Buttons, Vcl.ExtCtrls;

type
  TBPZipCodeForm = class(TForm)
    panHeader: TPanel;
    panHeaderToolbar: TPanel;
    btnClose: TSpeedButton;
    WB: TEdgeBrowser;

    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FZipCodeUrl: string;
    FUseRoadAddr: Boolean;
    FZipCodeValue: string;
    FAddr1Value: string;
  public
    { Public declarations }
    property UseRoadAddr: Boolean read FUseRoadAddr write FUseRoadAddr default True;
    property ZipCodeValue: string read FZipCodeValue write FZipCodeValue;
    property Addr1Value: string read FAddr1Value write FAddr1Value;
  end;

var
  ZipCodeForm: TBPZipCodeForm;

procedure CallForm(AZipCode, AAddr1: OleVariant);

implementation

uses
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

procedure CallForm(AZipCode, AAddr1: OleVariant);
var
  LZipCode, LAddr1: string;
begin
  LZipCode := String(AZipCode);
  LAddr1 := String(AAddr1);
  MessageBox(0, PChar(Format('(%s) %s', [LZipCode, LAddr1])), PChar('¾Ë¸²'), MB_ICONINFORMATION or MB_OK or MB_TOPMOST or MB_APPLMODAL);
end;

procedure TBPZipCodeForm.FormCreate(Sender: TObject);
begin
//  FZipUrl := CO_URL_ZIPCODE;
  FUseRoadAddr := True;
  FZipCodeUrl := 'file://' + ExpandFileName(Global.DirInfo.ContentsDir) + 'zipcode.html';
  FZipCodeValue := '';
  FAddr1Value := '';

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);
end;

procedure TBPZipCodeForm.FormActivate(Sender: TObject);
begin
  WB.Navigate(FZipCodeUrl);
end;

procedure TBPZipCodeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
end;

procedure TBPZipCodeForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TBPZipCodeForm.btnCloseClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

end.
