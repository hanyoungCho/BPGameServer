unit Form.Full.Popup;

interface

uses
  uConsts, uStruct, uVanDeamonModul, Winapi.Windows,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Platform.Win, FMX.ImgList,
  System.ImageList,
  CPort,
  uPaycoNewModul,
  Frame.FullPopup.Member, Frame.FullPopupPayCard,
  Frame.AppCardList, Frame.FullPopup.Phone;


type
  TFullPopup = class(TForm)
    TimerFull: TTimer;
    Layout: TLayout;
    ContentLayout: TLayout;
    txtTime: TText;
    Rectangle1: TRectangle;
    FullPopupPhone1: TFullPopupPhone;
    edtNumber: TEdit;
    FullPopupMember1: TFullPopupMember;
    FullPopupAppCardList1: TFullPopupAppCardList;
    FullPopupPayCard1: TFullPopupPayCard;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);

    procedure TimerFullTimer(Sender: TObject);
    procedure BottomRectangleClick(Sender: TObject);
    procedure edtNumberKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtNumberKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    FPopUpFullLevel: TPopUpFullLevel;
    FCnt: Integer;
    FResultStr: string;
    FReadStr: string;
    FComport: TComport;

    //BarcodeIn: Boolean;
    UseScanner: Boolean;
    Work: Boolean;
    IsPayco: Boolean;

    FKeyIn: Boolean;
    FKeyLength: Integer;

    function BioMini_ErrorMsg(ACode: Integer; AStr: string = ''): string;
    procedure ComPortRxBuf(Sender: TObject; const Buffer; Count: Integer);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);

    function ApprovalAppCard(ABarcode: string): Boolean;
  public
		{ Public declarations }

    procedure ShowFullPopup;

    procedure ApplyCard(ABarcode: string = ''; AppCardDiscountUse: Boolean = False; ACallBinInfo: Boolean = False);
    procedure ApplyAppCard(AIndex: Integer; AText: string);
    procedure ApplyPromotion;
    procedure ApplyPayco;
    procedure InputPhoneNumber;
    procedure ResetTimerCnt;
    procedure StopTimer;

    procedure CloseFormStrMrok(AStr: string);
    procedure CloseFormStrMrCancel;


    procedure SetTimeText(ATime: Integer);

    procedure GetMemberInfo(ACode: string; AMember: TMemberInfo);
    procedure selectMemberProduct;

    procedure selectHalbu(AIdx, AHalbu: Integer);

    property PopUpFullLevel: TPopUpFullLevel read FPopUpFullLevel write FPopUpFullLevel;
    property ResultStr: string read FResultStr write FResultStr;
    property Comport: TComport read FComport write FComport;
  end;

var
  FullPopup: TFullPopup;

implementation

uses
  uGlobal, uFunction, fx.Logging, uCommon, uSaleModule, Form.Select.Box, Form.Sale.Product;

{$R *.fmx}

function StringToHex(const AValue: AnsiString): string;
begin
  SetLength(Result, Length(AValue) * 2);
  BinToHex(PAnsiChar(AValue), PChar(Result), Length(AValue));
end;

procedure TFullPopup.edtNumberKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FKeyIn := True;
  if Key in [vkF1, vkF2, vkF3, vkF4, vkF5, vkF6, vkF7, vkF8, vkF9, vkF10, vkF11, vkF12] then
  begin
    FKeyIn := False;
    Exit;
  end;

  if Key = vkCancel then
    edtNumber.Text := EmptyStr
  else if key = vkBack then
  begin
    if Length(edtNumber.Text) <= 1 then
      edtNumber.Text := EmptyStr
    else
      edtNumber.Text := Copy(edtNumber.Text, 1, Length(edtNumber.Text));
  end;
end;

procedure TFullPopup.edtNumberKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Length(edtNumber.Text) >= FKeyLength then
    edtNumber.Text := Copy(edtNumber.Text, 1, FKeyLength);

  if FKeyIn then
  begin
    FullPopupPhone1.SetPromotionCode(edtNumber.Text);
  end;
end;


procedure TFullPopup.FormCreate(Sender: TObject);
begin
  try
    Comport := TComPort.Create(nil);

    if not Global.Config.NoDevice then
    begin
      if Global.Config.Scanner.Port <> 0 then
      begin
        Comport.Port := 'COM' + IntToStr(Global.Config.Scanner.Port);

        if Global.Config.Scanner.BaudRate = 9600 then
          Comport.BaudRate := br9600
        else if Global.Config.Scanner.BaudRate = 115200 then
          Comport.BaudRate := br115200
        else
          Comport.BaudRate := br115200;

        Comport.OnRxChar := ComPortRxChar;
      end;

    end;
    //BarcodeIn := False;
    UseScanner := False;
    IsPayco := False;

  except
    on E: Exception do
    begin
      Log.E('TFullPopup.FormCreate', E.Message);
			Global.SBMessage.ShowMessage('11', '알림', E.Message);
    end;
  end;
end;


procedure TFullPopup.FormShow(Sender: TObject);
begin
  try

    Log.D('TFullPopup.FormShow', 'Begin');

    edtNumber.Text := EmptyStr;
    edtNumber.SetFocus;
    FCnt := 0;
    PopUpFullLevel := Global.SaleModule.PopUpFullLevel;
    ShowFullPopup;
    Work := False;
//    TimerFull.Enabled := True;  //ksj 230814 회원권 구매 이외의 화면에서는 일단 시간초제한 해제

    if PopUpFullLevel = pflPayCard then
    begin
      FullPopupPayCard1.DisPlay;
    end;

    //Top1.lblDay.Text := Global.SaleModule.NowHour;
    //Top1.lblTime.Text := Global.SaleModule.NowTime;

    Log.D('TFullPopup.FormShow', 'End');
  except
    on E: Exception do
    begin
      Log.E('TFullPopup.FormShow', E.Message);
    end;
  end;
end;

procedure TFullPopup.FormDestroy(Sender: TObject);
begin
  try

    if Comport <> nil then
    begin
      if Comport.Connected then
        Comport.Close;
      Comport.Free;
    end;

	 FullPopupMember1.CloseFrame;
	 FullPopupMember1.Free;
	 FullPopupPayCard1.CloseFrame; //ksj 230816
	 FullPopupPayCard1.Free;

   DeleteChildren;
  except
    on E: Exception do
    begin
//      Global.SBMessage.ShowMessageModalForm('FormDestroy : ' + E.Message);
    end;
  end;
end;


procedure TFullPopup.ApplyAppCard(AIndex: Integer; AText: string);
begin
  try
//    StopTimer;
//    ResetTimerCnt;

    {$IFDEF RELEASE}
    TouchSound(False, True);
    //BarcodeIn := False;

    if not Global.Config.NoDevice then
    begin
      if Global.Config.Scanner.Port <> 0 then
        ComPort.Open;
    end;
    {$ENDIF}

    if AIndex = 0 then
    begin
      UseScanner := True;
//      IsPayco := True;
      ApplyPayco;
    end
    else
    begin
    {
      FullPopupAppCardList1.Visible := False;

      //AppCardImage.MultiResBitmap.Bitmaps[1] := ImageList.Source[AIndex - 1].MultiResBitmap.Bitmaps[1];
      AppCardImage.Visible := True;
      if AText = '신한 터치결제' then
      begin
        Work := True;
        AppCardImageCancel.Visible := False;
        Global.SaleModule.CardApplyType := catMagnetic;
        ApplyCard('', False, True);
      end
      //else if AText = 'NH터치 결제' then 6:코나카드
      else if (AIndex = 5) or (AIndex = 6) then
      begin
        Work := True;
        AppCardImageCancel.Visible := False;
        Global.SaleModule.CardApplyType := catMagnetic;
        ApplyCard('', False, True);
      end
      else
      begin
        StopTimer;
        UseScanner := True;
        AppCardImageCancel.Visible := True;
      end;
      }
    end;

  finally
  end;

end;

procedure TFullPopup.ApplyCard(ABarcode: string; AppCardDiscountUse: Boolean; ACallBinInfo: Boolean);
var
  ACardRecv: TCardRecvInfoDM;
  ACardBin, SendBinNo, ACode, AMsg: string;
  ADiscountAmt: Currency;
begin
  try
    ACardBin := EmptyStr;
    SendBinNo := EmptyStr;
    ACode := EmptyStr;
    AMsg := EmptyStr;
    ADiscountAmt := 0;

//		StopTimer;
//		ResetTimerCnt;

    //imgCreditCard.Visible := True;

    if (ABarcode = EmptyStr) and ACallBinInfo then
    begin
      ACardBin := Global.SaleModule.CallCardInfo;
      SendBinNo := ACardBin;
    end
    else if Length(ABarcode) >= 30 then
    begin
      ACardBin := ABarcode;
      SendBinNo := BCAppCardQrBinData(ACardBin);
    end
    else
    begin
      ACardBin := ABarcode;
      SendBinNo := ABarcode;
    end;
   {
    //2021-06-16 파트너센터 카드사 할인여부 확인... 간편결제
    if Global.Config.AppCard = True then
    begin
      SetWindowPos(WindowHandleToPlatform(FullPopup.Handle).Wnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);

      if (SendBinNo <> EmptyStr) and (Length(SendBinNo) < 30) then
        ADiscountAmt := Global.Database.SearchCardDiscount(SendBinNo, CurrToStr(Global.SaleModule.RealAmt), Global.SaleModule.BuyProductList[0].Products.Product_Div, ACode, AMsg);
    end;
    }
    SetWindowPos(WindowHandleToPlatform(FullPopup.Handle).Wnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);

    ACardRecv := Global.SaleModule.CallCard(ACardBin, ACode, AMsg, ADiscountAmt, AppCardDiscountUse);

    if not ACardRecv.Result then
    begin
      Global.SBMessage.ShowMessage('11', '알림', ACardRecv.Msg);
      CloseFormStrMrCancel;
    end
    else
      CloseFormStrMrok('');
  finally
    Work := False;
  end;
end;

procedure TFullPopup.ApplyPayco;
var
  APayco: TPaycoNewRecvInfo;
begin
  try
    try
      if IsPayco then
        Exit;

      IsPayco := True;
      Log.D('ApplyPayco', 'Begin');

      if Global.SaleModule.BuyProductList.Count = 0 then
      begin
        Global.SBMessage.ShowMessage('11', '알림', MSG_ADD_PRODUCT);
        Exit;
      end;

      if Global.SaleModule.RealAmt = 0 then
      begin
        Global.SBMessage.ShowMessage('11', '알림', MSG_NOT_PAY_AMT);
        Exit;
      end;

      if Global.Config.NoPayModule then
      begin
        Global.SBMessage.ShowMessage('11', '알림', '결제 가능한 장비가 없습니다.');
        Exit;
      end;

      APayco := Global.SaleModule.CallPayco;
      if not APayco.Result then
      begin
        SaleProduct.ErrorMsg := APayco.Msg;
        ModalResult := mrCancel;
      end
      else
      begin
        ModalResult := mrOk;
      end;
    except
      on E: Exception do
        Log.E('ApplyPayco', E.Message);
    end;
  finally
    Log.D('ApplyPayco', 'End');
    IsPayco := False;
  end;
end;

procedure TFullPopup.ApplyPromotion;
begin
  ShowFullPopup;
end;

function TFullPopup.ApprovalAppCard(ABarcode: string): Boolean;
begin
  try
    Result := False;
    Log.D('ApprovalAppCard Barcode', ABarcode);
    ApplyCard(ABarcode, True, False);
  finally
  end;
end;

function TFullPopup.BioMini_ErrorMsg(ACode: Integer; AStr: string): string;
begin
  if ACode = 0 then
  begin
    if AStr = 'UFS_CaptureSingleImage' then
      Result := '지문을 인식하지 못하였습니다.'
    else if AStr = 'UFM_Verify' then
      Result := '일치하는 지문이 없습니다.'
    else
      Result := '오류!!';
  end
  else
  begin
    if ACode = -1 then
      Result := 'UFS_ClearCaptureImageBuffer'
    else if ACode = -2 then
      Result := 'UFS_CaptureSingleImage'
    else if ACode = -3 then
      Result := 'UFS_Extract'
    else if ACode = -4 then
      Result := 'UFM_Create'
    else
      Result := 'UFM_Verify';

    Result := '지문인식에 실패하였습니다.' + #13#10 + Result;
  end;
end;

procedure TFullPopup.BottomRectangleClick(Sender: TObject);
begin
  TouchSound;
end;

procedure TFullPopup.CloseFormStrMrCancel;
begin
  ModalResult := mrCancel;
end;

procedure TFullPopup.CloseFormStrMrok(AStr: string);
begin
  ResultStr := AStr;
  if AStr = 'SALE' then
    ModalResult := mrTryAgain
  else
    ModalResult := mrOk;
end;

procedure TFullPopup.ComPortRxBuf(Sender: TObject; const Buffer;
  Count: Integer);
begin

end;

procedure TFullPopup.ComPortRxChar(Sender: TObject; Count: Integer);
var
  TempBuff: string;
  AMember: TMemberInfo;
  ADiscount: TDiscount;
begin
  try

    //if BarcodeIn or (not UseScanner) then
    if UseScanner = False then
      Exit;

    Comport.ReadStr(TempBuff, Count);

    FReadStr := FReadStr + TempBuff;
    //Log.D('Scan begin', FReadStr);
    {
    if Global.Config.Print.PrintType = 'EPSON' then //스캐너 구분위해
    begin
      if Copy(FReadStr, Length(FReadStr), 1) <> #$A then
        Exit;

      FReadStr := StringReplace(FReadStr, #$D#$A, '', [rfReplaceAll]);
    end
    else    }
    begin
      if Copy(FReadStr, Length(FReadStr), 1) <> #$D then
        Exit;

      FReadStr := StringReplace(FReadStr, #$D, '', [rfReplaceAll]);
    end;

    FCnt := 0;
    //BarcodeIn := True;
    UseScanner := False;

    Log.D('Scan Data', FReadStr);
    if Global.SaleModule.CardApplyType <> catNone then
    begin
      if IsPayco then
        Global.SaleModule.PaycoModule.SetBarcode(FReadStr)
      else
        ApprovalAppCard(FReadStr);
    end
    else
    begin
      //'M-3a542dd8-a697-4032-99cb-d3cfb8a10f8b' -조한용
      GetMemberInfo(FReadStr, AMember); //QR인증
    end;

    FReadStr := EmptyStr;
    //BarcodeIn := False;

  finally
    FCnt := 0;
  end;
end;


procedure TFullPopup.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  //FReadStr := FReadStr + KeyChar;
  //Global.SBMessage.ShowMessageModalForm(FReadStr);

  if Key = vkReturn then
  begin
    Global.SBMessage.ShowMessage('11', '알림', FReadStr);
    FReadStr := EmptyStr;
  end;
end;

procedure TFullPopup.GetMemberInfo(ACode: string; AMember: TMemberInfo);
var
  Temp, Msg: string;
  //MemberTemp: TMemberInfo;
  rProductInfo: TMemberProductInfo;
  i: Integer;
begin
  try
    try
      Temp := EmptyStr;

      //AMember.Code := '3';
      //AMember.Name := '조한용';

      if ACode = EmptyStr then
        Global.SaleModule.Member := AMember
      else
        Global.SaleModule.Member := Global.SaleModule.SearchMember(ACode);

      if Global.SaleModule.Member.Code = EmptyStr then
      begin
				Global.SBMessage.ShowMessage('11', '알림', MSG_NOT_MEMBER_SEARCH);

        ModalResult := mrCancel;
        Exit;
      end;

//      StopTimer;

      //회원보유상품 조회 없음.
      Global.SaleModule.MemberProdList := Global.ErpApi.GetMemberProductList(Global.SaleModule.Member.Code);

      FullPopupPhone1.Visible := False;
      FullPopupMember1.Visible := True;
      FullPopupMember1.Display;

      UseScanner := False;
		except
      on E: Exception do
        Log.E('TFullPopup.GetMemberInfo', E.Message);
    end;
  finally
  end;

end;

procedure TFullPopup.selectMemberProduct;
begin
  FullPopupMember1.SelectProductView;
end;

procedure TFullPopup.InputPhoneNumber;
begin
//
end;

procedure TFullPopup.ResetTimerCnt;
begin
//  FCnt := 0;
end;

procedure TFullPopup.SetTimeText(ATime: Integer);
begin

end;

procedure TFullPopup.ShowFullPopup;
var
  AMemberTm: TMemberInfo; //쿠폰회원 테스트용-주석처리 필수
begin
  try
    Log.D('TFullPopup.ShowFullPopup', 'Begin');

    //Top1.lblDay.Text := FormatDateTime('yyyy-mm-dd', now);
    //Top1.lblTime.Text := FormatDateTime('hh:nn', now);

    if Global.SaleModule.CardApplyType = catAppCard then
    begin

      if not Global.Config.NoDevice then
      begin
        if Global.Config.Scanner.Port <> 0 then
          Comport.Open;
      end;

      FullPopupAppCardList1.Visible := True;
      FullPopupAppCardList1.Display;

    end
    else if PopUpFullLevel = pflPhone then
    begin

      if not Global.Config.NoDevice then
      begin
        if Global.Config.Scanner.Port <> 0 then
          Comport.Open;
      end;

      FullPopupPhone1.KeyBoard1.DisPlayKeyBoard;
      FullPopupPhone1.Visible := True;
      FullPopupPhone1.txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec), 2, ' ')]);

      UseScanner := True;
      FKeyLength := 11;
    end
    else if PopUpFullLevel = pflPayCard then
    begin
      FullPopupPayCard1.Visible := True;
    end;

    Log.D('TFullPopup.ShowFullPopup', 'End');
  except
    on E: Exception do
    begin
      Log.E('TFullPopup.ShowFullPopup', E.Message);
    end;
  end;
end;

procedure TFullPopup.StopTimer;
begin
//  TimerFull.Enabled := not TimerFull.Enabled;
end;
//ksj 230814 타이머 이벤트 해제해둠
procedure TFullPopup.TimerFullTimer(Sender: TObject);
label ReNitgen, ReNitgenAdd, ReUnion, ReUnionAdd;
var
  iRv: Integer;
  AMsg: string;
  panel: TPanel;
  MemberTemp: TMemberInfo;
begin
//  try
//    if Work then
//    begin
//      Log.D('TFullPopup.TimerFullTimer Work', 'Exit');
//			Exit;
//    end;
//
//    Inc(FCnt);
//    txtTime.Text := Format(TimeSecCaption, [LPadB(IntToStr(Time30Sec - Trunc(FCnt)), 2, ' ')]);
//    if (Time30Sec - FCnt) = 0 then
//		begin
//			TimerFull.Enabled := False;
//      CloseFormStrMrCancel;
//		end;
//
//    if Global.SaleModule.CardApplyType = catNone then
//    begin
//      if FCnt = 1 then
//      begin
//        {
//        if PopUpFullLevel = pflMobile then
//        begin
//          GetMemberInfo(EmptyStr, Global.SaleModule.Member);
//        end;
//         }
//      end;
//    end;
//
//  except
//    on E: Exception do
//    begin
//      Log.E('TFullPopup.TimerFullTimer', 'Exception');
//      Log.E('TFullPopup.TimerFullTimer FCnt', CurrToStr(FCnt));
//      Log.E('TFullPopup.TimerFullTimer PopUpFullLevel', IntToStr(Ord(PopUpFullLevel)));
//      Log.E('TFullPopup.TimerFullTimer txtTime.Text', txtTime.Text);
//    end;
//  end;
end;

procedure TFullPopup.selectHalbu(AIdx, AHalbu: Integer);
begin
  Global.SaleModule.SelectHalbu := AHalbu;
  FullPopupPayCard1.selectHalbu(AIdx);
end;

end.

