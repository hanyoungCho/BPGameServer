unit Frame.Bottom;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, Generics.Collections;

type
  TThreadImg = class(TThread)
  private
    FIndex: Integer;
//    AImgList: TList<string>;
    FImage: TImage;
    FActiveIndex: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetImage(AImage: TImage);
  end;

  TBottom = class(TFrame)
    Image: TImage;
  private
    { Private declarations }
    FIndex: Integer;
  public
    FThreadImg: TThreadImg;
    { Public declarations }
    procedure Display(IsThread: Boolean = True);
    function ChangeImg: Integer;
  end;

implementation

uses
  uGlobal, fx.Logging;

{$R *.fmx}

{ TThreadImg }

constructor TThreadImg.Create;
begin
  FreeOnTerminate := False;
  inherited Create(True);

  FIndex := 0;
  FActiveIndex := 0;
end;

destructor TThreadImg.Destroy;
begin

  inherited;
end;


procedure TThreadImg.Execute;
begin
  inherited;

  while not Terminated do
  begin
    if FActiveIndex <= FIndex then
    begin
      FActiveIndex := FIndex;
      FImage.Bitmap.LoadFromFile(Global.SaleModule.AdvertListDown[FActiveIndex].FilePath);

      // API Àü¼Û
      //Sleep(StrToIntDef(Global.SaleModule.AdvertListDown[FActiveIndex].Show_Interval, 1) * 1000);

      if FActiveIndex = (Global.SaleModule.AdvertListDown.Count - 1) then
      begin
        FActiveIndex := 0;
        FIndex := 0;
      end;
    end
    else
      Inc(FIndex);
  end;
end;

procedure TThreadImg.SetImage(AImage: TImage);
begin
  FImage := AImage;
end;

{ TBottom }

function TBottom.ChangeImg: Integer;
begin
  try
    Result := 1;
    if Global.SaleModule.AdvertListDown.Count <> 0 then
    begin
      if FIndex <= (Global.SaleModule.AdvertListDown.Count - 1) then
      begin
          //Global.ErpApi.SendAdvertisCnt(IntToStr(Global.SaleModule.AdvertListDown[FIndex].Seq));

        Image.Bitmap := Global.SaleModule.AdvertListDown[FIndex].Image;
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
      Log.E('ChangeImg AdvertisementListDown.Count', IntToStr(Global.SaleModule.AdvertListDown.Count));
    end;
  end;
end;

procedure TBottom.Display(IsThread: Boolean);
begin
  FIndex := 0;
  if IsThread then
  begin
    FThreadImg := TThreadImg.Create;
    FThreadImg.SetImage(Image);
    FThreadImg.Resume;
  end
  else
  begin
    if Global.SaleModule.AdvertListDown.Count <> 0 then
    begin
      Image.Bitmap.LoadFromFile(Global.SaleModule.AdvertListDown[0].FilePath);
      Inc(FIndex);
    end;
  end;
end;

end.
