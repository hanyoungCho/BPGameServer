unit Form.Master.Download;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects;

type
  TMasterDownload = class(TForm)
    ImgLayout: TLayout;
    BGImage: TImage;
    DownLoadRectangle: TRectangle;
    DownLoadImage: TImage;
    txtMasterUpdate: TText;
    txtDownLoadTitle: TText;
    txtEndCnt: TText;
    Timer: TTimer;
    txtUpdate: TText;
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ProgramStart: Boolean;
    Member: Boolean;
    Config: Boolean;
    Product: Boolean;
    LaneChk: Boolean;
  end;

var
  MasterDownload: TMasterDownload;

// 회원
// 환경설정
// 상품
// 타석 마스터
// 타석 가동상황


implementation

uses
  uGlobal, fx.Logging;

{$R *.fmx}

procedure TMasterDownload.FormDestroy(Sender: TObject);
begin
  DeleteChildren;
  Exit;
end;

procedure TMasterDownload.FormShow(Sender: TObject);
begin
  if Global.ErpApi.OAuth_Certification = False then
    Exit;

  Timer.Enabled := True;

  if ProgramStart then
  begin
    txtUpdate.Visible := False;
    txtDownLoadTitle.Visible := True;
    txtEndCnt.Visible := True;
    txtMasterUpdate.Visible := True;
  end
  else
  begin
    txtUpdate.Visible := True;
    txtDownLoadTitle.Visible := False;
    txtEndCnt.Visible := False;
    txtMasterUpdate.Visible := False;
  end;

end;

procedure TMasterDownload.TimerTimer(Sender: TObject);
var
  DownLoadCnt: Integer;

  function SetCnt: Boolean;
  begin
    Result := False;
    Application.ProcessMessages;
    Inc(DownLoadCnt);
    DownLoadRectangle.Width := DownLoadCnt * 174;
    txtEndCnt.Text := Format('(%d of %d)', [DownLoadCnt, 5]);
    if DownLoadCnt = 1 then
      txtDownLoadTitle.Text := '회원 정보'
    else if DownLoadCnt = 2 then
      txtDownLoadTitle.Text := '환경설정 정보'
    else if DownLoadCnt = 3 then
      txtDownLoadTitle.Text := '상품 정보'
    else if DownLoadCnt = 4 then
      txtDownLoadTitle.Text := '레인 정보'
    else if DownLoadCnt = 5 then
      txtDownLoadTitle.Text := '레인가동 정보';
    Sleep(1000);
    Result := True;
  end;
begin
  Timer.Enabled := False;
  DownLoadCnt := 0;

  if ProgramStart then
  begin
    Global.ErpApi.GetStoreInfo;
  end;

  SetCnt;
  if Member then
  begin
    if not Global.SaleModule.GetMemberList then
    begin
      Log.E('Global.SaleModule.GetMemberList', '실패');
      ModalResult := mrCancel;
      Exit;
    end;

    Log.D('Global.SaleModule.GetMemberList', IntToStr(Global.SaleModule.MemberList.Count));
  end;

  SetCnt;
  if Config then
  begin
    if not Global.SaleModule.GetConfig then
    begin
      Log.E('Global.SaleModule.GetConfig', '실패');
      ModalResult := mrCancel;
      Exit;
    end;

    // Local에서 타석 가동상황을 가져 온다.
		Global.LocalApi.DBConnection;
  end;

  SetCnt;
  if Product then
  begin
		if not Global.SaleModule.GetGameProdList then  //요금제
    begin
      Log.E('Global.SaleModule.GetGameProdList', '실패');
			ModalResult := mrCancel;
      Exit;
    end;
    Log.D('Global.SaleModule.GetGameProdList', IntToStr(Global.SaleModule.SaleGameProdList.Count));

    if not Global.SaleModule.GetMemberShipProdList then //회원용 상품
    begin
      Log.E('Global.SaleModule.GetMemberShipProdList', '실패');
      ModalResult := mrCancel;
      Exit;
    end;
    Log.D('Global.SaleModule.GetMemberShipProdList', IntToStr(Global.SaleModule.SaleMemberShipProdList.Count));

    if not Global.SaleModule.GetRentProduct then //렌탈-대화
    begin
      Log.E('Global.SaleModule.GetRentProduct', '실패');
      ModalResult := mrCancel;
      Exit;
    end;

  end;

  SetCnt;
  if LaneChk then
  begin
    if not Global.Lane.GetLaneInfoInit then
    begin
      Log.E('Global.Lane.GetLaneInfoInit', '실패');
      ModalResult := mrCancel;
      Exit;
    end;

    Log.D('Global.Lane.GetLaneInfoInit', IntToStr(Global.Lane.LaneCnt));
  end;

  SetCnt;
  if ProgramStart then
  begin

    if not Global.Lane.GetPlayingLaneList then
    begin
      Log.E('Global.Lane.GetPlayingTeeBoxList', '실패');
      ModalResult := mrCancel;
      Exit;
    end;

    Log.D('Global.Lane.GetPlayingTeeBoxList', IntToStr(Global.Lane.LaneCnt));
  end;

  if ProgramStart then
  begin

    //Global.Config.Version.AdvertisVersion := Global.Database.GetAdvertisVersion;
    Global.ErpApi.SearchAdvertisList;

  end;

  ModalResult := mrOk;
end;

end.
