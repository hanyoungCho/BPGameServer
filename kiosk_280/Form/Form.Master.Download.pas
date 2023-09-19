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

// ȸ��
// ȯ�漳��
// ��ǰ
// Ÿ�� ������
// Ÿ�� ������Ȳ


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
      txtDownLoadTitle.Text := 'ȸ�� ����'
    else if DownLoadCnt = 2 then
      txtDownLoadTitle.Text := 'ȯ�漳�� ����'
    else if DownLoadCnt = 3 then
      txtDownLoadTitle.Text := '��ǰ ����'
    else if DownLoadCnt = 4 then
      txtDownLoadTitle.Text := '���� ����'
    else if DownLoadCnt = 5 then
      txtDownLoadTitle.Text := '���ΰ��� ����';
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
      Log.E('Global.SaleModule.GetMemberList', '����');
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
      Log.E('Global.SaleModule.GetConfig', '����');
      ModalResult := mrCancel;
      Exit;
    end;

    // Local���� Ÿ�� ������Ȳ�� ���� �´�.
		Global.LocalApi.DBConnection;
  end;

  SetCnt;
  if Product then
  begin
		if not Global.SaleModule.GetGameProdList then  //�����
    begin
      Log.E('Global.SaleModule.GetGameProdList', '����');
			ModalResult := mrCancel;
      Exit;
    end;
    Log.D('Global.SaleModule.GetGameProdList', IntToStr(Global.SaleModule.SaleGameProdList.Count));

    if not Global.SaleModule.GetMemberShipProdList then //ȸ���� ��ǰ
    begin
      Log.E('Global.SaleModule.GetMemberShipProdList', '����');
      ModalResult := mrCancel;
      Exit;
    end;
    Log.D('Global.SaleModule.GetMemberShipProdList', IntToStr(Global.SaleModule.SaleMemberShipProdList.Count));

    if not Global.SaleModule.GetRentProduct then //��Ż-��ȭ
    begin
      Log.E('Global.SaleModule.GetRentProduct', '����');
      ModalResult := mrCancel;
      Exit;
    end;

  end;

  SetCnt;
  if LaneChk then
  begin
    if not Global.Lane.GetLaneInfoInit then
    begin
      Log.E('Global.Lane.GetLaneInfoInit', '����');
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
      Log.E('Global.Lane.GetPlayingTeeBoxList', '����');
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
