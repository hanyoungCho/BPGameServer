unit uCommon;

interface

uses
  uStruct, Vcl.Forms, Form.Message, mmsystem, TlHelp32, Windows,
  System.UITypes, System.SysUtils, DateUtils, FMX.Objects, FMX.Graphics;

type
  TMessageForm = class
  private
    SBMessage: TSBMessageForm;
  public
    PrintError: Boolean;

    function ShowMessage(AType, ATitle, AMsg: string; OneButton: Boolean = True; ACloseCnt: Integer = 30; ASoundPlay: Boolean = True): Boolean;
    function ShowMessageModalForm2(AMsg: string; OneButton: Boolean = True; ACloseCnt: Integer = 30; ASoundPlay: Boolean = True; Print: Boolean = False): Boolean;
  end;

function ShowMain: Boolean;
function ShowSelectBox: Boolean;

function ShowNewMemberInfoTT: Boolean;

function ShowSaleProduct: TModalResult;
function ShowSaleProductTime: TModalResult;
function ShowSaleGameBowler: Boolean;
function ShowSaleMember: TModalResult;
function ShowSaleTimeBowler: Boolean;

function ShowPopup: Boolean;
//function ShowFullPopup(IsFomeShow: Boolean = False; PositionStr: string = ''): TModalResult;
function ShowFullPopup: Boolean;
procedure CloseFullPopup;
function ShowConfig: Boolean;
function ShowMasterDownload(ProgramStart, Member, Config, Product, LaneChk: Boolean): Boolean;

function ShowIntro(ABitMap: TBitmap): Boolean;
function CheckIntro: Boolean;

procedure TouchSound(AError: Boolean = False; AChangImg: Boolean = False);
function StoreClosureCheck: Boolean; //종료시간 초과, 휴장체크
//function StoreCloseTmCheck(AProduct: TProductInfo): Boolean; //매장종료시간 체크후 잔여시간 배정

procedure CloseForm;

function IsRunningProcess(const ProcName: string): Boolean;
function KillProcess(const ProcName: string): Boolean;

implementation

uses
  uGlobal, fx.Logging, uFunction, uConsts, Form.Popup, Form.Full.Popup,
  Form.Select.Box,
  Form.Sale.Product, Form.Sale.Product.Time,
  Form.Sale.Member, Form.Main, Form.Config, Form.Master.Download,
  Form.Intro,
  Form.Sale.Game.Bowler, Form.Sale.Time.Bowler,
  Form.Popup.NewMemberInfoTT;

function ShowMain: Boolean;
begin
  try
    Log.D('Main', 'Begin');
    if not Global.SaleModule.DeviceInit then
    begin
      Log.D('ShowMain', 'DeviceInit Fail');
      Exit;
    end;

    Result := False;
    Main := TMain.Create(nil);
    {$IFDEF DEBUG}
    Main.WindowState := wsNormal;
    Main.Width := DEBUG_WIDTH;
    Main.Height := DEBUG_HEIGHT;
    Main.Layout.Scale.X := DEBUG_SCALE;
    Main.Layout.Scale.Y := DEBUG_SCALE;
    {$ENDIF}
    Result := Main.ShowModal = mrOk;
  finally
    Log.D('Main', 'End');
    FreeAndNil(Main);
  end;
end;

function ShowSelectBox: Boolean;
begin
  try
    Log.D('ShowSelectBox', 'Begin');
    Result := False;
    SelectBox := TSelectBox.Create(nil);
    {$IFDEF DEBUG}
    SelectBox.WindowState := wsNormal;
    SelectBox.Width := DEBUG_WIDTH;
    SelectBox.Height := DEBUG_HEIGHT;
    SelectBox.ImgLayout.Scale.X := DEBUG_SCALE;
    SelectBox.ImgLayout.Scale.Y := DEBUG_SCALE;
    SelectBox.Layout.Scale.X := DEBUG_SCALE;
    SelectBox.Layout.Scale.Y := DEBUG_SCALE;
    {$ENDIF}
    Result := SelectBox.ShowModal = mrOk;
  finally
    Log.D('ShowSelectBox', 'End');
    FreeAndNil(SelectBox);
  end;
end;

function ShowNewMemberInfoTT: Boolean;
begin
  try
    Log.D('ShowNewMemberInfoTT', 'Begin');
    Result := False;
    frmNewMemberInfoTT := TfrmNewMemberInfoTT.Create(nil);
    {$IFDEF DEBUG}
    frmNewMemberInfoTT.WindowState := wsNormal;
    frmNewMemberInfoTT.Width := DEBUG_WIDTH;
    frmNewMemberInfoTT.Height := DEBUG_HEIGHT;
    frmNewMemberInfoTT.Layout.Scale.X := DEBUG_SCALE;
    frmNewMemberInfoTT.Layout.Scale.Y := DEBUG_SCALE;
    frmNewMemberInfoTT.Left := 0;
    //frmNewMemberInfo.Left := 450;
    {$ENDIF}
    Result := frmNewMemberInfoTT.ShowModal = mrOk;
  finally
    Log.D('frmNewMemberInfoTT', 'End');
    FreeAndNil(frmNewMemberInfoTT);
  end;
end;

function ShowSaleProduct: TModalResult;
begin
  try
    try
      Log.D('ShowSaleProduct', 'Begin');
      SaleProduct := TSaleProduct.Create(nil);
      {$IFDEF DEBUG}
      SaleProduct.WindowState := wsNormal;
      SaleProduct.Width := DEBUG_WIDTH;
      SaleProduct.Height := DEBUG_HEIGHT;
      SaleProduct.Layout.Scale.X := DEBUG_SCALE;
      SaleProduct.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      Result := SaleProduct.ShowModal;
    finally
      Log.D('ShowSaleProduct', 'End');
      FreeAndNil(SaleProduct);
    end;
  except
    on E: Exception do
      Log.E('ShowSaleProduct', E.Message);
  end;
end;

function ShowSaleProductTime: TModalResult;
begin
  try
    try
      Log.D('ShowSaleProductTime', 'Begin');
      SaleProductTime := TSaleProductTime.Create(nil);
      {$IFDEF DEBUG}
      SaleProductTime.WindowState := wsNormal;
      SaleProductTime.Width := DEBUG_WIDTH;
      SaleProductTime.Height := DEBUG_HEIGHT;
      SaleProductTime.Layout.Scale.X := DEBUG_SCALE;
      SaleProductTime.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      Result := SaleProductTime.ShowModal;
    finally
      Log.D('ShowSaleProductTime', 'End');
      FreeAndNil(SaleProductTime);
    end;
  except
    on E: Exception do
      Log.E('ShowSaleProductTime', E.Message);
  end;
end;

function ShowSaleGameBowler: Boolean;
begin
  try
    try
      Log.D('ShowSaleGameBowler', 'Begin');
      SaleGameBowler := TSaleGameBowler.Create(nil);
      {$IFDEF DEBUG}
      SaleGameBowler.WindowState := wsNormal;
      SaleGameBowler.Width := DEBUG_WIDTH;
      SaleGameBowler.Height := DEBUG_HEIGHT;
      SaleGameBowler.Layout.Scale.X := DEBUG_SCALE;
      SaleGameBowler.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      Result := SaleGameBowler.ShowModal = mrOk;
    finally
      Log.D('ShowSaleGameBowler', 'End');
      FreeAndNil(SaleGameBowler);
    end;
  except
    on E: Exception do
      Log.E('ShowSaleGameBowler', E.Message);
  end;
end;

function ShowSaleTimeBowler: Boolean;
begin
  try
    try
      Log.D('ShowSaleTimeBowler', 'Begin');
      SaleTimeBowler := TSaleTimeBowler.Create(nil);
      {$IFDEF DEBUG}
      SaleTimeBowler.WindowState := wsNormal;
      SaleTimeBowler.Width := DEBUG_WIDTH;
      SaleTimeBowler.Height := DEBUG_HEIGHT;
      SaleTimeBowler.Layout.Scale.X := DEBUG_SCALE;
      SaleTimeBowler.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      Result := SaleTimeBowler.ShowModal = mrOk;
    finally
      Log.D('ShowSaleTimeBowler', 'End');
      FreeAndNil(SaleTimeBowler); //ksj 230816 Game -> Time
    end;
  except
    on E: Exception do
      Log.E('ShowSaleTimeBowler', E.Message);
  end;
end;

function ShowSaleMember: TModalResult;
begin
  try
    try
      Log.D('ShowSaleMember', 'Begin');
      SaleMember := TSaleMember.Create(nil);
      {$IFDEF DEBUG}
      SaleMember.WindowState := wsNormal;
      SaleMember.Width := DEBUG_WIDTH;
      SaleMember.Height := DEBUG_HEIGHT;
      SaleMember.Layout.Scale.X := DEBUG_SCALE;
      SaleMember.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      Result := SaleMember.ShowModal;
    finally
      Log.D('ShowSaleMember', 'End');
      FreeAndNil(SaleMember);
    end;
  except
    on E: Exception do
      Log.E('ShowSaleMember', E.Message);
  end;
end;

function ShowPopup: Boolean;
begin
  try
    Log.D('ShowPopup', 'Begin');
    Popup := TPopup.Create(nil);
    {$IFDEF DEBUG}
    Popup.WindowState := wsNormal;
    Popup.Width := DEBUG_WIDTH;
    Popup.Height := DEBUG_HEIGHT;
    Popup.Layout.Scale.X := DEBUG_SCALE;
    Popup.Layout.Scale.Y := DEBUG_SCALE;
    {$ENDIF}
    Result := Popup.ShowModal = mrOk;
  finally
    Log.D('ShowPopup', 'End');
    FreeAndNil(Popup);
  end;
end;

function ShowFullPopup: Boolean;
begin
  try
    try
      Log.D('ShowFullPopup', 'Begin');

      FullPopup := TFullPopup.Create(nil);
      {$IFDEF DEBUG}
      FullPopup.WindowState := wsNormal;
      FullPopup.Width := DEBUG_WIDTH;
      FullPopup.Height := DEBUG_HEIGHT;
      FullPopup.Layout.Scale.X := DEBUG_SCALE;
      FullPopup.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      Result := FullPopup.ShowModal = mrOk;
    finally
      Log.D('ShowFullPopup', 'End');
      FreeAndNil(FullPopup);
    end;
  except
    on E: Exception do
    begin
      Log.E('ShowFullPopup', E.Message);
    end;
  end;
end;

procedure CloseFullPopup;
begin
  if FullPopup <> nil then
    FullPopup.Free;
end;

function ShowConfig: Boolean;
begin
  try
    Log.D('Config', 'Begin');
    Config := TConfig.Create(nil);
    {$IFDEF DEBUG}
    Config.WindowState := wsNormal;
    Config.Width := DEBUG_WIDTH;
    Config.Height := DEBUG_HEIGHT;
    Config.Layout.Scale.X := DEBUG_SCALE;
    Config.Layout.Scale.Y := DEBUG_SCALE;
    {$ENDIF}
    Result := Config.ShowModal = mrOk;
  finally
    Log.D('Config', 'End');
    FreeAndNil(Config);
  end;
end;

function ShowMasterDownload(ProgramStart, Member, Config, Product, LaneChk: Boolean): Boolean;
begin
  try
    Log.D('ShowMasterDownload', 'Begin');
    MasterDownload := TMasterDownload.Create(nil);
    MasterDownload.ProgramStart := ProgramStart;
    MasterDownload.Member := Member;
    MasterDownload.Config := Config;
    MasterDownload.Product := Product;
    MasterDownload.LaneChk := LaneChk;
    {$IFDEF DEBUG}
    MasterDownload.WindowState := wsNormal;
    MasterDownload.Width := DEBUG_WIDTH;
    MasterDownload.Height := DEBUG_HEIGHT;
    MasterDownload.ImgLayout.Scale.X := DEBUG_SCALE;
    MasterDownload.ImgLayout.Scale.Y := DEBUG_SCALE;
    {$ENDIF}
    Result := MasterDownload.ShowModal = mrOk;
  finally
    Log.D('ShowMasterDownload', 'End');
    FreeAndNil(MasterDownload);
  end;
end;

procedure TouchSound(AError: Boolean; AChangImg: Boolean);
begin
  try

    if not AError then
    begin
  //    Global.SaleModule.SoundThread.SoundList.Add(ExtractFilePath(Application.ExeName) + 'Touch.wav');
      PlaySound(StringToOLEStr(ExtractFilePath(Application.ExeName) + 'Touch.wav'), 0, SND_ASYNC or SND_ALIAS);
    end
    else
    begin
  //    Global.SaleModule.SoundThread.SoundList.Add(ExtractFilePath(Application.ExeName) + 'Error.wav');
       PlaySound(StringToOLEStr(ExtractFilePath(Application.ExeName) + 'Error.wav'), 0, SND_ASYNC or SND_ALIAS);
  //    PlaySound(StringToOLEStr(ExtractFilePath(Application.ExeName) + 'Error.wav'), 0, SND_ASYNC or SND_ALIAS);
    end;

    if AChangImg then
    begin
    end;

  except
    on E: Exception do
    begin
      Log.D('TouchSound', E.Message);
    end;
  end;
end;

{ TMessageForm }

function TMessageForm.ShowMessage(AType, ATitle, AMsg: string; OneButton: Boolean; ACloseCnt: Integer; ASoundPlay: Boolean): Boolean;
begin
  try
    try
      Log.D('ShowMessage', 'Begin : ' + AMsg);

      if Trim(AMsg) = EmptyStr then
      begin
        Log.D('ShowMessage', 'AMsg EmptyStr End');
        Exit;
      end;

      SBMessageForm := TSBMessageForm.Create(nil);
      {$IFDEF DEBUG}
      SBMessageForm.WindowState := wsNormal;
      SBMessageForm.Width := DEBUG_WIDTH;
      SBMessageForm.Height := DEBUG_HEIGHT;
      SBMessageForm.Layout.Scale.X := DEBUG_SCALE;
      SBMessageForm.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      SBMessageForm.FType := AType;
      SBMessageForm.txtTitleLine1.Text := ATitle;
      SBMessageForm.txtDesc.Text := AMsg;
      SBMessageForm.FCnt := 0;
      SBMessageForm.FCloseCnt := ACloseCnt;
      SBMessageForm.FSoundPlay := ASoundPlay;
      SBMessageForm.FOneBtn := OneButton;
      SBMessageForm.Timer.Enabled := True;

      Result := SBMessageForm.ShowModal = mrOk;
    finally
      Log.D('ShowMessage', 'End');
      FreeAndNil(SBMessageForm);
    end;
  except
    on E: Exception do
    begin
      Log.D('ShowMessage', E.Message);
    end;
  end;
end;

//chy sewoo
function TMessageForm.ShowMessageModalForm2(AMsg: string; OneButton: Boolean; ACloseCnt: Integer; ASoundPlay: Boolean; Print: Boolean): Boolean;
begin
  try
    try
      Log.D('ShowMessageModalForm2', 'Begin');
      Log.D('ShowMessageModalForm2', AMsg);

      if Trim(AMsg) = EmptyStr then
      begin
        Log.D('ShowMessageModalForm2', 'End');
        Exit;
      end;

      SBMessageForm := TSBMessageForm.Create(nil);
      {$IFDEF DEBUG}
      SBMessageForm.WindowState := wsNormal;
      SBMessageForm.Width := DEBUG_WIDTH;
      SBMessageForm.Height := DEBUG_HEIGHT;
      SBMessageForm.Layout.Scale.X := DEBUG_SCALE;
      SBMessageForm.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}

      SBMessageForm.txtDesc.Text := AMsg;
      SBMessageForm.FCnt := 0;
      SBMessageForm.FSoundPlay := ASoundPlay;
      SBMessageForm.FOneBtn := OneButton;
      SBMessageForm.FCloseCnt := ACloseCnt;
      SBMessageForm.Timer.Enabled := False;
      PrintError := True;

      Result := SBMessageForm.ShowModal = mrOk;
    finally
      PrintError := False;
      Log.D('ShowMessageModalForm2', 'End');
      FreeAndNil(SBMessageForm);
    end;
  except
    on E: Exception do
    begin
      Log.D('ShowMessageModalForm2', E.Message);
    end;
  end;
end;

function ShowIntro(ABitMap: TBitmap): Boolean;
begin
  try
    try
      Log.D('ShowIntro', 'Begin');
      Intro := TIntro.Create(nil);
      {$IFDEF DEBUG}
      Intro.WindowState := wsNormal;
      Intro.Width := DEBUG_WIDTH;
      Intro.Height := DEBUG_HEIGHT;
      Intro.Layout.Scale.X := DEBUG_SCALE;
      Intro.Layout.Scale.Y := DEBUG_SCALE;
      {$ENDIF}
      Intro.MediaFrame1.MediaPlayer1.Stop;
      if Global.SaleModule.AdvertListUp.Count <> 0 then
        Intro.MediaFrame1.MediaPlayer1.FileName := Global.SaleModule.AdvertListUp[0].FilePath;

      Intro.BottomImage.Bitmap := ABitMap;
      Result := Intro.ShowModal = mrOk;
    finally
      FreeAndNil(Intro);
      Log.D('ShowIntro', 'End');
    end;
  except
    on E: Exception do
    begin
      Log.D('ShowIntro', E.Message);
    end;
  end;
end;

function CheckIntro: Boolean;
begin
  Result := (Intro = nil);
end;

function StoreClosureCheck: Boolean; //휴장체크
var
  AMsg: string;
  ADateTime, AEndTime, AStartTime: TDateTime;
begin
  try
    try
      Result := False;

      AMsg := EmptyStr;

      AStartTime := DateStrToDateTime(FormatDateTime('yyyymmdd', now) + StringReplace(Global.Config.Store.SaleStartTime, ':', '', [rfReplaceAll]) + '00');
      AEndTime := DateStrToDateTime(FormatDateTime('yyyymmdd', now) + StringReplace(Global.Config.Store.SaleEndTime, ':', '', [rfReplaceAll]) + '00');
      {
      if Global.SaleModule.TeeBoxInfo.End_Time <> EMptyStr then
        ADateTime := DateStrToDateTime(FormatDateTime('yyyymmdd', now) + StringReplace(Global.SaleModule.TeeBoxInfo.End_Time, ':', '', [rfReplaceAll]) + '00')
      else}
        ADateTime := DateStrToDateTime(FormatDateTime('yyyymmddhhnn', now) + '00');

      ADateTime := IncMinute(ADateTime, StrToIntDef(Global.Config.PrePareMin, 5));

      //chy 2021-05-03 유명
      //if (Global.Config.Store.StoreCode = 'A4001') and //유명
      if (Global.Config.Store.SaleStartTime > Global.Config.Store.SaleEndTime) then //익일 종료
      begin
        if (AStartTime > now) and (ADateTime >= AEndTime) then
        begin
          AMsg := AMsg + '선택하신 타석은 예약이 마감되었습니다.' + #13#10 +
            '(영업시간 : ' + Global.Config.Store.SaleStartTime + '~'  + Global.Config.Store.SaleEndTime + ')';
          Result := True;
        end;

      end
      else
      begin
        if (AStartTime > now) or (ADateTime >= AEndTime) then
        begin
          AMsg := AMsg + '선택하신 타석은 예약이 마감되었습니다.' + #13#10 +
            '(영업시간 : ' + Global.Config.Store.SaleStartTime + '~'  + Global.Config.Store.SaleEndTime + ')';
          Result := True;
        end;
      end;

      if (Global.Config.Store.ClosureStartDatetime <> EmptyStr) and (Global.Config.Store.closureEndDatetime <> EmptyStr) then
      begin
        if (Global.Config.Store.ClosureStartDatetime <= FormatDateTime('yyyy-mm-dd hh:nn', ADateTime)) and
           (Global.Config.Store.closureEndDatetime >= FormatDateTime('yyyy-mm-dd hh:nn', ADateTime)) then
        begin
          AMsg := '휴장시간입니다.' + #13#10 + Global.Config.Store.ClosureStartDatetime + ' - ' +
            Global.Config.Store.closureEndDatetime + #13#10 +  AMsg;
          Result := True;
        end;
      end;

      if AMsg <> EmptyStr then
      begin
        Global.SBMessage.ShowMessage('11', '알림', AMsg);
      end;
    except
      on E: Exception do
        Log.E('StoreClosureCheck', E.Message);
    end;
  finally

  end;
end;
  (*
function StoreCloseTmCheck(AProduct: TProductInfo): Boolean; //매장종료시간 체크, 이용시간제한상품 체크
var
  AMsg: string;
  nMin: Integer;
  ADateTime, AStoreEndTime, AProductEndTime: TDateTime;
begin
  try
    try
      Result := False;

      AMsg := EmptyStr;
      {
      if Global.SaleModule.TeeBoxInfo.End_Time <> EMptyStr then
      begin
        //종료시간과 다음 배정시간 사이 1분 텀이 있음. AD에서 1분 텀으로 계산
        ADateTime := DateStrToDateTime(FormatDateTime('yyyymmdd', now) + StringReplace(Global.SaleModule.TeeBoxInfo.End_Time, ':', '', [rfReplaceAll]) + '00');
        ADateTime := IncMinute(ADateTime, 1);
      end
      else}
        ADateTime := DateStrToDateTime(FormatDateTime('yyyymmddhhnn', now) + '00');

      ADateTime := IncMinute(ADateTime, StrToIntDef(Global.Config.PrePareMin, 5));

      AStoreEndTime := DateStrToDateTime(FormatDateTime('yyyymmdd', now) + StringReplace(Global.Config.Store.SaleEndTime, ':', '', [rfReplaceAll]) + '00');

      

      //if (Global.Config.Store.EndTimeIgnoreYn = 'N') then
      begin
        if (ADateTime < AStoreEndTime) then
        begin
          nMin :=  MinutesBetween(AStoreEndTime, ADateTime);
          if nMin <= StrToInt(AProduct.One_Use_Time) then
          begin
            Log.D('시간확인', IntToStr(nMin) + ' < ' + AProduct.One_Use_Time + ' / ' + FormatDateTime('yyyymmddhhnn', ADateTime));
            AMsg := AMsg + '영업종료 시간은' + FormatDateTime('hh:nn', AStoreEndTime) + '입니다.' + #13#10 +
                           '남은 시간 예약을 진행하시겠습니까?';
          end;
        end;
      end;

      if AMsg <> EmptyStr then
      begin
        if Global.SBMessage.ShowMessage('11', '알림', AMsg, False) then
        begin
          Global.SaleModule.FStoreCloseOver := True;
          Global.SaleModule.FStoreCloseOverMin := IntToStr(nMin);
        end
        else //남은시간으로 예약진행 않함
        begin
          Result := True;
        end;
      end;

    except
      on E: Exception do
        Log.E('StoreCloseCheck', E.Message);
    end;
  finally

  end;
end;
 *)
procedure CloseForm;
begin
  try
    if Popup <> nil then
    begin
      Log.D('CloseForm', 'POUP Close nil 아님');
      {$IFDEF DEBUG}
      Global.SBMessage.ShowMessage('11', '알림','POUP Close nil 아님');
      {$ENDIF}
      FreeAndNil(Popup);
    end;

    if FullPopup <> nil then
    begin
      Log.D('CloseForm', 'FullPopup Close nil 아님');
      {$IFDEF DEBUG}
      Global.SBMessage.ShowMessage('11', '알림','FullPopup Close nil 아님');
      {$ENDIF}
      FreeAndNil(FullPopup);
    end;

    if SaleProduct <> nil then
    begin
      Log.D('CloseForm', 'SaleProduct Close nil 아님');
      {$IFDEF DEBUG}
      Global.SBMessage.ShowMessage('11', '알림','SaleProduct Close nil 아님');
      {$ENDIF}
      FreeAndNil(SaleProduct);
    end;

    if SBMessageForm <> nil then
    begin
      Log.D('CloseForm', 'SBMessageForm Close nil 아님');
      {$IFDEF DEBUG}
      Global.SBMessage.ShowMessage('11', '알림','SBMessageForm Close nil 아님');
      {$ENDIF}
      FreeAndNil(SBMessageForm);
    end;

  finally

  end;
end;

function IsRunningProcess(const ProcName: string): Boolean;
var
  Process32: TProcessEntry32;
  SHandle: THandle;
  Next: Boolean;

begin
  Result := False;

  Process32.dwSize := SizeOf(TProcessEntry32);
  SHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  // 프로세스 리스트를 돌면서 매개변수로 받은 이름과 같은 프로세스가 있을 경우 True를 반환하고 루프종료
  if Process32First(SHandle, Process32) then
  begin
    repeat
      Next := Process32Next(SHandle, Process32);
      if AnsiCompareText(Process32.szExeFile, Trim(ProcName)) = 0 then
      begin
        Result := True;
        break;
      end;
    until not Next;
  end;
  CloseHandle(SHandle);
end;

function KillProcess(const ProcName: string): Boolean;
var
  Process32: TProcessEntry32;
  SHandle: THandle;
  Next: Boolean;
  hProcess: THandle;
  i: Integer;
begin
  Result := True;

  Process32.dwSize        := SizeOf(TProcessEntry32);
  Process32.th32ProcessID := 0;
  SHandle                 := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  // 종료하고자 하는 프로세스가 실행중인지 확인하는 의미와 함께...
  if Process32First(SHandle, Process32) then
  begin
    repeat
      Next := Process32Next(SHandle, Process32);
      if AnsiCompareText(Process32.szExeFile, Trim(ProcName)) = 0 then
        break;
    until not Next;
  end;
  CloseHandle(SHandle);

  // 프로세스가 실행중이라면 Open & Terminate
  if Process32.th32ProcessID <> 0 then
  begin
    hProcess := OpenProcess(PROCESS_TERMINATE, True, Process32.th32ProcessID);
    if hProcess <> 0 then
    begin
      if not TerminateProcess(hProcess, 0) then
        Result := False;
    end
    // 프로세스 열기 실패
    else
    Result := False;

    CloseHandle(hProcess);
  end // if Process32.th32ProcessID<>0
  else
    Result := False;
end;

end.
