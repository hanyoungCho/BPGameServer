(*******************************************************************************

  Project     : 볼링픽 POS 시스템
  Title       : 점수 조회/수정 플러그인
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2023-01-04   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2023 All rights reserved.

*******************************************************************************)
unit BPLaneScoreView.Plugin;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, Data.DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { EhLib }
  DBCtrlsEh;

{$I ..\..\common\Common.BPCommon.inc}

const
  LCN_SCORE_PANEL_HEIGHT = 100;

type
  TFrameClass = class
    FrameGroupBox: TGroupBox;
    ThrowInput1: TEdit;
    ThrowInput2: TEdit;
    ThrowInput3: TEdit;
    ScoreLabel: TLabel;
  private
    FItemIndex: Shortint;
    FThrowString1: string;
    FThrowString2: string;
    FThrowString3: string;
    FOldThrowString1: string;
    FOldThrowString2: string;
    FOldThrowString3: string;
    FScoreValue: Integer;
    FScoreString: string;
    FScoreError: Boolean;

    procedure SetThrowString1(const AValue: string);
    procedure SetThrowString2(const AValue: string);
    procedure SetThrowString3(const AValue: string);
    procedure SetScoreError(const AValue: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    property ItemIndex: ShortInt read FItemIndex write FItemIndex default 0;
    property ThrowString1: string read FThrowString1 write SetThrowString1;
    property ThrowString2: string read FThrowString2 write SetThrowString2;
    property ThrowString3: string read FThrowString3 write SetThrowString3;
    property OldThrowString1: string read FOldThrowString1 write FOldThrowString1;
    property OldThrowString2: string read FOldThrowString2 write FOldThrowString2;
    property OldThrowString3: string read FOldThrowString3 write FOldThrowString3;
    property ScoreValue: Integer read FScoreValue write FScoreValue default 0;
    property ScoreString: string read FScoreString write FScoreString;
    property ScoreError: Boolean read FScoreError write SetScoreError default False;
  end;

  TBowlerPanel = class(TPanel)
    BowlerInfoGroupBox: TGroupBox;
    BowlerNameLabel: TLabel;
    GameScoreGroupBox: TGroupBox;
    GameScoreLabel: TLabel;
  private
    FLaneNo: ShortInt;
    FAssignNo: string;
    FBowlerId: string;
    FBowlerName: string;
    FGameDiv: ShortInt;
    FGameCount: ShortInt;
    FGameMin: Integer;
    FPaymentType: ShortInt;
    FFrameNo: ShortInt;
    FGameScore: Word;
    FScoreModified: Boolean;
    FPinFallResult: string;

    procedure SetFrameNo(const AValue: ShortInt);
    procedure SetPinFallResult(const AValue: string);
    procedure SetBowlerName(const aValue: string);
    function GetGameScoreTable: string;
    function GetScoreModified: Boolean;
  public
    Frames: TArray<TFrameClass>;

    constructor Create(AOwner: TComponent; const AItemIndex: ShortInt; AParent: TWinControl); reintroduce;
    destructor Destroy; override;

    function ComputeScore(const AIndex: ShortInt): Boolean;
    procedure RefreshScore;

    procedure OnEditFrameScoreKeyPress(Sender: TObject; var Key: Char);
    procedure OnEditFrameScoreEnter(Sender: TObject);
    procedure OnEditFrameScoreChangeThrow1(Sender: TObject);
    procedure OnEditFrameScoreChangeThrow2(Sender: TObject);
    procedure OnEditFrameScoreChangeThrow3(Sender: TObject);

    procedure SetGameScore(const AValue: Word);

    property LaneNo: ShortInt read FLaneNo write FLaneNo default 0;
    property AssignNo: string read FAssignNo write FAssignNo;
    property BowlerId: string read FBowlerId write FBowlerId;
    property BowlerName: string read FBowlerName write SetBowlerName;
    property GameDiv: ShortInt read FGameDiv write FGameDiv default 0;
    property GameCount: ShortInt read FGameCount write FGameCount default 0;
    property GameMin: Integer read FGameMin write FGameMin default 0;
    property PaymentType: ShortInt read FPaymentType write FPaymentType default 0;
    property FrameNo: ShortInt read FFrameNo write SetFrameNo default 0;
    property GameScore: Word read FGameScore write SetGameScore;
    property GameScoreTable: string read GetGameScoreTable;
    property ScoreModified: Boolean read GetScoreModified write FScoreModified default False;
    property PinFallResult: string read FPinFallResult write SetPinFallResult;
  end;

  TBPLaneScoreViewForm = class(TPluginModule)
    panHeader: TPanel;
    panHeaderMenuBar: TPanel;
    panHeaderToolbar: TPanel;
    panFooter: TPanel;
    lblPluginVersion: TLabel;
    sbxScoreList: TScrollBox;
    TemplateScorePanel: TPanel;
    TemplateLaneGroupBox1: TGroupBox;
    TemplateFrameScoreLabel1: TLabel;
    TemplateFrameScoreEdit11: TEdit;
    TemplateFrameScoreEdit12: TEdit;
    TemplateLaneGroupBox2: TGroupBox;
    TemplateFrameScoreLabel2: TLabel;
    TemplateFrameScoreEdit21: TEdit;
    TemplateFrameScoreEdit22: TEdit;
    TemplateLaneGroupBox10: TGroupBox;
    TemplateFrameScoreLabel10: TLabel;
    TemplateFrameScoreEdit102: TEdit;
    TemplateFrameScoreEdit103: TEdit;
    TemplateFrameScoreEdit101: TEdit;
    TemplateLaneGroupBox4: TGroupBox;
    TemplateFrameScoreLabel4: TLabel;
    TemplateFrameScoreEdit41: TEdit;
    TemplateFrameScoreEdit42: TEdit;
    TemplateLaneGroupBox5: TGroupBox;
    TemplateFrameScoreLabel5: TLabel;
    TemplateFrameScoreEdit51: TEdit;
    TemplateFrameScoreEdit52: TEdit;
    TemplateLaneGroupBox6: TGroupBox;
    TemplateFrameScoreLabel6: TLabel;
    TemplateFrameScoreEdit61: TEdit;
    TemplateFrameScoreEdit62: TEdit;
    TemplateLaneGroupBox7: TGroupBox;
    TemplateFrameScoreLabel7: TLabel;
    TemplateFrameScoreEdit71: TEdit;
    TemplateFrameScoreEdit72: TEdit;
    TemplateLaneGroupBox8: TGroupBox;
    TemplateFrameScoreLabel8: TLabel;
    TemplateFrameScoreEdit81: TEdit;
    TemplateFrameScoreEdit82: TEdit;
    TemplateLaneGroupBox9: TGroupBox;
    TemplateFrameScoreLabel9: TLabel;
    TemplateFrameScoreEdit91: TEdit;
    TemplateFrameScoreEdit92: TEdit;
    TemplateLaneGroupBox3: TGroupBox;
    TemplateFrameScoreLabel3: TLabel;
    TemplateFrameScoreEdit31: TEdit;
    TemplateFrameScoreEdit32: TEdit;
    TemplateLaneScoreGroupBox: TGroupBox;
    TemplateGameScoreLabel: TLabel;
    TemplateBowlerInfoGroupBox: TGroupBox;
    TemplateBowlerNameLabel: TLabel;
    btnClose: TSpeedButton;
    btnMainMenu: TSpeedButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnGameRestore: TBitBtn;
    panInputGuide: TPanel;
    edtLegendScoree: TDBEditEh;
    edtLegendSpare: TDBEditEh;
    edtLegendStrike: TDBEditEh;

    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure sbxScoreListMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnGameRestoreClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerID: Integer;
    FLaneNo: ShortInt;
    FBowlerCount: ShortInt;
    FDataSet: TDataSet;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure ReadDataSet;

    procedure SetBowlerCount(const AValue: ShortInt);
  public
    { Public declarations }
    BowlerPanels: TArray<TBowlerPanel>;

    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property BowlerCount: ShortInt read FBowlerCount write SetBowlerCount default 0;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, Vcl.Dialogs, System.Variants, System.Math,
  { Project }
  Common.BPGlobal, Common.BPDM, Common.BPCommonLib, Common.LayeredForm, Common.BPMsgBox;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TBPLaneScoreViewForm }

constructor TBPLaneScoreViewForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  FOwnerID := 0;
  FLaneNo := 0;
  FBowlerCount := 0;
  SetLength(BowlerPanels, 0);

  SetDoubleBuffered(Self, True);
  MakeRoundedControl(Self);
  LF := TLayeredForm.Create(nil);
  LF.Show;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TBPLaneScoreViewForm.Destroy;
begin
  LF.Release;

  inherited Destroy;
end;

procedure TBPLaneScoreViewForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBPLaneScoreViewForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TBPLaneScoreViewForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerID := AMsg.ParamByInteger(CPP_OWNER_ID);
    FLaneNo := AMsg.ParamByInteger(CPP_LANE_NO);
    FDataSet := TDataSet(AMsg.ParamByObject(CPP_DATASET));
    BowlerCount := FDataSet.RecordCount;
    ReadDataSet;
  end
  else if (AMsg.Command = CPC_CLOSE) then
    Self.Close;
end;

procedure TBPLaneScoreViewForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Self.Close;
  end;
end;

procedure TBPLaneScoreViewForm.panHeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TBPLaneScoreViewForm.sbxScoreListMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  SendMessage(TScrollBox(Sender).Handle, WM_VSCROLL, IfThen(WheelDelta >= 0, SB_LINELEFT, SB_LINERIGHT), 0);
  Handled := True;
end;

procedure TBPLaneScoreViewForm.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TBPLaneScoreViewForm.btnGameRestoreClick(Sender: TObject);
var
  LJobName, LResMsg: string;
begin
  try
    LJobName := TBitBtn(Sender).Caption;
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', Format('<B>%d</B> 레인에 <B>', [FLaneNo]) +
          ErrorString(LJobName) + '</B> 명령을 전송하시겠습니까?', ['예', '아니오']) <> mrOk) then
      Exit;
    if not BPDM.SetHoldLane(FLaneNo, True, LResMsg) then
      raise Exception.Create(LResMsg);
    if not BPDM.RestoreGame(FLaneNo, LResMsg) then
      raise Exception.Create(LResMsg);
    BPMsgBox(Self.Handle, mtInformation, '알림', Format('%s 명령 전송을 완료하였습니다.', [LJobName]), ['확인'], 5);
  except
    on E: Exception do
      BPMsgBox(Self.Handle, mtWarning, '알림',
        Format('%s 명령 전송에 실패하였습니다.', [LJobName]) + _BR + ErrorString(E.Message), ['확인'], 5);
  end;
end;

procedure TBPLaneScoreViewForm.btnOKClick(Sender: TObject);
var
  LScoreModified: Boolean;
  LResMsg: string;
  I: ShortInt;
begin
  LScoreModified := False;
  for I := 0 to High(BowlerPanels) do
    if BowlerPanels[I].ScoreModified then
    begin
      LScoreModified := True;
      Break;
    end;

  if LScoreModified then
  begin
    if (BPMsgBox(Self.Handle, mtConfirmation, '확인', '변경된 내용으로 수정하시겠습니까?', ['예', '아니오']) = mrOK) then
    try
     Screen.Cursor := crSQLWait;
     try
        for I := 0 to High(BowlerPanels) do
        begin
          if BowlerPanels[I].ScoreModified and
             not BPDM.SetGameScore(BowlerPanels[I].AssignNo, BowlerPanels[I].Bowlerid, BowlerPanels[I].GameScoreTable, LResMsg) then
            raise Exception.Create(LResMsg);
          UpdateLog(Format('ScoreEdit(%d).New = assign_no: %s, bowler_id: %s, game_score: %s', [I, BowlerPanels[I].AssignNo, BowlerPanels[I].BowlerId, BowlerPanels[I].GameScoreTable]));
        end;
      finally
        Screen.Cursor := crDefault;
      end;
      BPMsgBox(Self.Handle, mtInformation, '알림', '점수 수정이 완료되었습니다.', ['확인'], 5);
      Self.ModalResult := mrOK;
    except
      on E: Exception do
        BPMsgBox(Self.Handle, mtWarning, '알림', '점수 수정에 실패하였습니다.' + _BR + ErrorString(E.Message), ['확인'], 5);
    end;
  end
  else
    BPMsgBox(Self.Handle, mtInformation, '알림', '변경된 내역이 없습니다.', ['확인'], 5)
end;

procedure TBPLaneScoreViewForm.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TBPLaneScoreViewForm.SetBowlerCount(const AValue: ShortInt);
begin
  if (FBowlerCount <> AValue) then
  begin
    for var I: ShortInt := 0 to High(BowlerPanels) do
      if Assigned(BowlerPanels[I]) then
        BowlerPanels[I].Free;

    FBowlerCount := AValue;
    SetLength(BowlerPanels, FBowlerCount);
    for var J: ShortInt := 0 to Pred(FBowlerCount) do
      BowlerPanels[J] := TBowlerPanel.Create(Self, J, sbxScoreList);
  end;
end;

procedure TBPLaneScoreViewForm.ReadDataSet;
var
  I, LLaneNo: ShortInt;
begin
  with FDataSet do
  try
    DisableControls;
    First;
    I := 0;
    while not Eof do
    begin
      if (I >= BowlerCount) then
        Break;
      LLaneNo := FieldByName('lane_no').AsInteger;
      BowlerPanels[I].Tag := LLaneNo;
      BowlerPanels[I].LaneNo := LLaneNo;
      BowlerPanels[I].AssignNo := FieldByName('assign_no').AsString;
      BowlerPanels[I].BowlerId := FieldByName('bowler_id').AsString;
      BowlerPanels[I].BowlerName := FieldByName('bowler_nm').AsString;
      BowlerPanels[I].GameDiv := FieldByName('game_div').AsInteger;
      BowlerPanels[I].GameCount := FieldByName('game_cnt').AsInteger;
      BowlerPanels[I].GameMin := FieldByName('game_min').AsInteger;
      BowlerPanels[I].PaymentType := FieldByName('payment_type').AsInteger;
      BowlerPanels[I].FrameNo := FieldByName('frame_no').AsInteger; //반드시 PinFallResult 보다 먼저 대입되어야 함
      BowlerPanels[I].PinFallResult := FieldByName('pin_fall_result').AsString;
      BowlerPanels[I].BowlerInfoGroupBox.Caption := Format('%s', [BowlerPanels[I].BowlerId]);
      UpdateLog(Format('ScoreEdit(%d).Old = assign_no: %s, bowler_id: %s, game_score: %s', [I, BowlerPanels[I].AssignNo, BowlerPanels[I].BowlerId, BowlerPanels[I].GameScoreTable]));
      Inc(I);
      Next;
    end;
  finally
    EnableControls;
  end;
end;

{ TFrameClass }

constructor TFrameClass.Create;
begin
  FItemIndex := 0;
  FThrowString1 := '';
  FThrowString2 := '';
  FThrowString3 := '';
  FOldThrowString1 := '';
  FOldThrowString2 := '';
  FOldThrowString3 := '';
  FScoreValue := 0;
  FScoreString := '';
  FScoreError := False;
end;

destructor TFrameClass.Destroy;
begin

  inherited;
end;

procedure TFrameClass.SetThrowString1(const AValue: string);
begin
  if (FThrowString1 <> AValue) then
  begin
    FThrowString1 := AValue.Substring(AValue.Length - 1, 1);
    ThrowInput1.Text := Trim(FThrowString1);
  end;
end;

procedure TFrameClass.SetThrowString2(const AValue: string);
begin
  if (FThrowString2 <> AValue) then
  begin
    FThrowString2 := AValue.Substring(AValue.Length - 1, 1);
    ThrowInput2.Text := Trim(FThrowString2);
  end;
end;

procedure TFrameClass.SetThrowString3(const AValue: string);
begin
  if (FThrowString3 <> AValue) then
  begin
    FThrowString3 := AValue.Substring(AValue.Length - 1, 1);
    ThrowInput3.Text := Trim(FThrowString3);
  end;
end;

procedure TFrameClass.SetScoreError(const AValue: Boolean);
begin
  if (FScoreError <> AValue) then
  begin
    FScoreError := AValue;
    if FScoreError then
    begin
      ThrowInput1.Font.Color := clRed;
      ThrowInput2.Font.Color := clRed;
      if (ItemIndex = 9) then
        ThrowInput3.Font.Color := clRed;
    end
    else
    begin
      ThrowInput1.Font.Color := $00FF8000;
      ThrowInput2.Font.Color := $00FF8000;
      if (ItemIndex = 9) then
        ThrowInput3.Font.Color := $00FF8000;
    end;
  end;
end;

{ TBowlerPanel }

constructor TBowlerPanel.Create(AOwner: TComponent; const AItemIndex: ShortInt; AParent: TWinControl);
var
  I: ShortInt;
begin
  inherited Create(AOwner);

  FLaneNo := 0;
  FAssignNo := '';
  FBowlerId := '';
  FBowlerName := '';
  FGameDiv := 0;
  FGameCount := 0;
  FGameMin := 0;
  FPaymentType := 0;
  FFrameNo := 0;
  FGameScore := 0;
  FPinFallResult := '';
  FScoreModified := False;
  SetLength(Frames, 10);

  Self.Align := alTop;
  Self.AlignWithMargins := True;
  Self.AutoSize := False;
  Self.Caption := '';
  Self.Font.Name := 'Pretendard Variable';
  Self.Font.Size := 11;
  Self.Height := LCN_SCORE_PANEL_HEIGHT;
  Self.Margins.Bottom := 0;
  Self.Margins.Left := 5;
  Self.Margins.Right := 5;
  Self.Margins.Top := 5;
  Self.Padding.Bottom := 5;
  Self.Padding.Left := 5;
  Self.Padding.Right := 5;
  Self.Padding.Top := 5;
  Self.Parent := AParent;
  Self.ParentColor := False;
  Self.ParentFont := False;
  Self.TabOrder := AItemIndex;
  Self.Top := (LCN_SCORE_PANEL_HEIGHT * AItemIndex) + 36;
  Self.Width := 978;

  BowlerInfoGroupBox := TGroupBox.Create(Self);
  with BowlerInfoGroupBox do
  begin
    Align := alLeft;
    Caption := '';
    Font.Name := 'Pretendard Variable';
    Font.Size := 11;
    Font.Style := [fsBold];
    Height := 78;
    Left := 6;
    Parent := Self;
    ParentColor := False;
    ParentFont := False;
    TabOrder := 0;
    Top := 6;
    Width := 120;
  end;

  BowlerNameLabel := TLabel.Create(Self);
  with BowlerNameLabel do
  begin
    Align := alClient;
    Alignment := taRightJustify;
    AlignWithMargins := True;
    Caption := '';
    EllipsisPosition := epEndEllipsis;
    Font.Name := 'Pretendard Variable';
    Font.Size := 11;
    Font.Style := [];
    Height := 19;
    Parent := BowlerInfoGroupBox;
    ParentColor := False;
    ParentFont := False;
    StyleElements := [seFont, seClient, seBorder];
  end;

  for I := 0 to High(Frames) do
  begin
    Frames[I] := TFrameClass.Create;
    with Frames[I] do
    begin
      FItemIndex := I;
      FThrowString1 := '';
      FThrowString2 := '';
      FThrowString3 := '';
      FScoreString := '';
      ScoreError := False;
    end;

    Frames[I].FrameGroupBox := TGroupBox.Create(Self);
    with Frames[I].FrameGroupBox do
    begin
      Align := alLeft;
      AlignWithMargins := True;
      Caption := Format('%d 프레임', [Succ(I)]);
      Font.Name := 'Pretendard Variable';
      Font.Size := 11;
      Font.Style := [];
      Height := 78;
      Left := BowlerInfoGroupBox.Width + (I * 100);
      Margins.Bottom := 0;
      Margins.Left := 3;
      Margins.Right := 0;
      Margins.Top := 0;
      Padding.Bottom := 0;
      Padding.Left := 5;
      Padding.Right := 5;
      Padding.Top := 0;
      Parent := Self;
      ParentColor := False;
      ParentFont := False;
      StyleElements := [seClient, seBorder];
      TabOrder := I + 1;
      Top := 6;
      Width := IfThen(I = High(Frames), 97, 70);
    end;

    Frames[I].ThrowInput1 := TEdit.Create(Self);
    with Frames[I].ThrowInput1 do
    begin
      Align := alLeft;
      Alignment := taCenter;
      BevelInner := bvNone;
      BevelOuter := bvNone;
      CharCase := ecUpperCase;
      Font.Color := $00FF8000;
      Font.Name := 'Pretendard Variable';
      Font.Size := 13;
      Font.Style := [];
      Height := 27;
      ImeMode := imSAlpha;
      Left := 7;
      MaxLength := 1;
      Parent := Frames[I].FrameGroupBox;
      ParentColor := False;
      ParentFont := False;
      StyleElements := [seClient, seBorder];
      TabOrder := 0;
      Tag := I;
      Text := '';
      Top := 21;
      Width := 28;
      OnKeyPress := OnEditFrameScoreKeyPress;
      OnChange := OnEditFrameScoreChangeThrow1;
      OnEnter := OnEditFrameScoreEnter;
    end;

    Frames[I].ThrowInput2 := TEdit.Create(Self);
    with Frames[I].ThrowInput2 do
    begin
      if (I = High(Frames)) then
        Align := alLeft
      else
        Align := alClient;
      Alignment := taCenter;
      BevelInner := bvNone;
      BevelOuter := bvNone;
      CharCase := ecUpperCase;
      Font.Color := $00FF8000;
      Font.Name := 'Pretendard Variable';
      Font.Size := 13;
      Font.Style := [];
      Height := 27;
      ImeMode := imSAlpha;
      Left := 7;
      MaxLength := 1;
      Parent := Frames[I].FrameGroupBox;
      ParentColor := False;
      ParentFont := False;
      StyleElements := [seClient, seBorder];
      TabOrder := 1;
      Tag := I;
      Text := '';
      Top := 21;
      Width := 28;
      OnKeyPress := OnEditFrameScoreKeyPress;
      OnChange := OnEditFrameScoreChangeThrow2;
      OnEnter := OnEditFrameScoreEnter;
    end;

    if (I = High(Frames)) then
    begin
      Frames[I].ThrowInput3 := TEdit.Create(Self);
      with Frames[I].ThrowInput3 do
      begin
        Align := alClient;
        Alignment := taCenter;
        BevelInner := bvNone;
        BevelOuter := bvNone;
        CharCase := ecUpperCase;
        Font.Color := $00FF8000;
        Font.Name := 'Pretendard Variable';
        Font.Size := 13;
        Font.Style := [];
        Height := 27;
        ImeMode := imSAlpha;
        Left := 7;
        MaxLength := 1;
        Parent := Frames[I].FrameGroupBox;
        ParentColor := False;
        ParentFont := False;
        StyleElements := [seClient, seBorder];
        TabOrder := 2;
        Tag := I;
        Text := '';
        Top := 21;
        Width := 28;
        OnKeyPress := OnEditFrameScoreKeyPress;
        OnChange := OnEditFrameScoreChangeThrow3;
        OnEnter := OnEditFrameScoreEnter;
      end;
    end;

    Frames[I].ScoreLabel := TLabel.Create(Self);
    with Frames[I].ScoreLabel do
    begin
      Align := alBottom;
      Alignment := taCenter;
      AutoSize := False;
      Caption := '';
      Font.Name := 'Pretendard Variable';
      Font.Size := 13;
      Font.Style := [fsBold];
      Height := 38;
      Layout := tlCenter;
      Left := 7;
      Parent := Frames[I].FrameGroupBox;
      ParentColor := False;
      ParentFont := False;
      StyleElements := [];
      Tag := I;
      Top := 48;
      Width := 56;
    end;
  end;

  GameScoreGroupBox := TGroupBox.Create(Self);
  with GameScoreGroupBox do
  begin
    Align := alClient;
    AlignWithMargins := True;
    Caption := '게임 점수';
    Font.Name := 'Pretendard Variable';
    Font.Size := 11;
    Font.Style := [];
    Height := 78;
    Left := 0;
    Margins.Bottom := 0;
    Margins.Left := 3;
    Margins.Right := 0;
    Margins.Top := 0;
    Padding.Bottom := 5;
    Padding.Left := 5;
    Padding.Right := 5;
    Padding.Top := 5;
    Parent := Self;
    ParentColor := False;
    ParentFont := False;
    TabOrder := 11;
    Top := 6;
    Width := 90;
  end;

  GameScoreLabel := TLabel.Create(Self);
  with GameScoreLabel do
  begin
    Align := alClient;
    Alignment := taCenter;
    AutoSize := False;
    Caption := '0';
    Font.Color := $00FF8000;
    Font.Name := 'Pretendard Variable';
    Font.Size := 20;
    Font.Style := [fsBold];
    Height := 45;
    Layout := tlCenter;
    Left := 7;
    Parent := GameScoreGroupBox;
    ParentColor := False;
    ParentFont := False;
    StyleElements := [];
    Top := 26;
    Width := 76;
  end;
end;

destructor TBowlerPanel.Destroy;
begin
  BowlerNameLabel.Free;
  BowlerInfoGroupBox.Free;
  GameScoreLabel.Free;
  GameScoreGroupBox.Free;
  for var I: ShortInt := 0 to High(Frames) do
  begin
    Frames[I].ScoreLabel.Free;
    Frames[I].ThrowInput1.Free;
    Frames[I].ThrowInput2.Free;
    if Assigned(Frames[I].ThrowInput3) then
      Frames[I].ThrowInput3.Free;
    Frames[I].FrameGroupBox.Free;
    Frames[I].Free;
  end;

  inherited;
end;

function TBowlerPanel.GetGameScoreTable: string;
begin
  Result := '';
  for var I: ShortInt := 0 to High(Frames) do
  begin
    Result := Result + String(Frames[I].ThrowString1).PadRight(1);
    Result := Result + String(Frames[I].ThrowString2).PadRight(1);
    if Assigned(Frames[I].ThrowInput3) then
      Result := Result + String(Frames[I].ThrowString3).PadRight(1);
  end;
end;

function TBowlerPanel.GetScoreModified: Boolean;
begin
  Result := False;
  for var I: ShortInt := 0 to High(Frames) do
    if (Frames[I].ThrowString1 <> Frames[I].OldThrowString1) or
       (Frames[I].ThrowString2 <> Frames[I].OldThrowString2) or
       (Frames[I].ThrowString3 <> Frames[I].OldThrowString3) then
    begin
      Result := True;
      Break;
    end;
end;

procedure TBowlerPanel.OnEditFrameScoreKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, [Chr(VK_BACK), Chr(VK_TAB), CO_PIN_GUTTER, CO_PIN_SPARE..CO_PIN_9, CO_PIN_STRIKE, CO_PIN_STRIKE_2]) then
    Key := #0;
end;

procedure TBowlerPanel.OnEditFrameScoreEnter(Sender: TObject);
begin
  with TEdit(Sender) do
    if (Text = ' ') then
      Text := '';
end;

procedure TBowlerPanel.OnEditFrameScoreChangeThrow1(Sender: TObject);
var
  sThrow1: string;
begin
  with TEdit(Sender) do
  try
    sThrow1 := Text;
    if sThrow1.IsEmpty or
       (sThrow1 = CO_PIN_SPARE) then
      Text := '';
    if (Tag < 9) then
    begin
      if (sThrow1 = CO_PIN_STRIKE) then
      begin
        Frames[Tag].ThrowString2 := '';
        Frames[Tag].ThrowInput2.Enabled := False;
      end
      else
        Frames[Tag].ThrowInput2.Enabled := True;
    end;
  finally
    Frames[Tag].ThrowString1 := Trim(Text);
    RefreshScore;
  end;
end;

procedure TBowlerPanel.OnEditFrameScoreChangeThrow2(Sender: TObject);
var
  nThrow1, nThrow2: ShortInt;
  sThrow1: string;
begin
  with TEdit(Sender) do
  try
    sThrow1 := Frames[Tag].ThrowString1;
    if sThrow1.IsEmpty or
       ((Tag < 9) and ((sThrow1 = CO_PIN_STRIKE) or (Text = CO_PIN_STRIKE))) or
       ((Tag = 9) and ((sThrow1 = CO_PIN_STRIKE) and (Text = CO_PIN_SPARE))) or
       ((Tag = 9) and ((sThrow1 <> CO_PIN_STRIKE) and (Text = CO_PIN_STRIKE))) then
      Text := '';
    if (Text <> CO_PIN_SPARE) then
    begin
      nThrow1 := StrToIntDef(sThrow1, 0);
      nThrow2 := StrToIntDef(Text, 0);
      if ((nThrow1 + nThrow2) = 10) then
      begin
        Text := CO_PIN_SPARE;
//        SelStart := Length(Text);
      end
      else if (nThrow1 + nThrow2) > 10 then
        Text := '';
    end;
    if (Tag = 9) then
    begin
      if (sThrow1 = CO_PIN_STRIKE) or
         (Text = CO_PIN_STRIKE) or
         (Text = CO_PIN_SPARE) then
        Frames[Tag].ThrowInput3.Enabled := True
      else
      begin
        Frames[Tag].ThrowString3 := '';
        Frames[Tag].ThrowInput3.Enabled := False;
      end
    end;
  finally
    Frames[Tag].ThrowString2 := Trim(Text);
    RefreshScore;
  end;
end;

procedure TBowlerPanel.OnEditFrameScoreChangeThrow3(Sender: TObject);
var
  nThrow2, nThrow3: ShortInt;
  sThrow2: string;
begin
  with TEdit(Sender) do
  try
    sThrow2 := Frames[Tag].ThrowString2;
    if (sThrow2 <> CO_PIN_STRIKE) and
       (Text = CO_PIN_STRIKE) then
      Text := '';
    nThrow2 := StrToIntDef(sThrow2, 0);
    nThrow3 := StrToIntDef(Text, 0);
    if ((nThrow2 + nThrow3) = 10) then
    begin
      Text := CO_PIN_SPARE;
//      SelStart := Length(Text);
    end
    else if (nThrow2 + nThrow3) > 10 then
      Text := '';
  finally
    Frames[Tag].ThrowString3 := Trim(Text);
    RefreshScore;
  end;
end;

function TBowlerPanel.ComputeScore(const AIndex: ShortInt): Boolean;
  function CheckThrowString1(const AEndIndex: Shortint): Boolean;
  begin
    Result := True;
    for var I: ShortInt := 0 to AEndIndex do
      if Frames[I].ThrowString1.IsEmpty then
      begin
        Result := False;
        Break;
      end;
  end;
var
  LIndex: ShortInt;
begin
  if (not AIndex in [0..High(Frames)]) or
     (not CheckThrowString1(AIndex)) then
    Exit(True);

  Result := False;
  try
    try
      case AIndex of
        0..7: //1번 ~ 8번 프레임
        begin
          if (Frames[AIndex].ThrowString1 = CO_PIN_STRIKE) then
          begin
            if (Frames[AIndex + 1].ThrowString1 = CO_PIN_STRIKE) and
               (Frames[AIndex + 2].ThrowString1 = CO_PIN_STRIKE) then
              Frames[AIndex].ScoreString := '30'
            else
            begin
              if (Frames[AIndex + 1].ThrowString1 = CO_PIN_STRIKE) then
                Frames[AIndex].ScoreString := IntToStr(20 + StrToInt(Frames[AIndex + 2].ThrowString1))
              else
              begin
                if (Frames[AIndex + 1].ThrowString2 = CO_PIN_SPARE) then
                  Frames[AIndex].ScoreString := '20'
                else
                  Frames[AIndex].ScoreString := IntToStr(10 + StrToInt(Frames[AIndex + 1].ThrowString1) + StrToInt(Frames[AIndex + 1].ThrowString2));
              end;
            end;
          end
          else
          begin
            if (Frames[AIndex].ThrowString2 = CO_PIN_SPARE) and
               (Frames[AIndex + 1].ThrowString1 = CO_PIN_STRIKE) then
              Frames[AIndex].ScoreString := '20'
            else
            begin
              if (Frames[AIndex].ThrowString2 = CO_PIN_SPARE) then
                Frames[AIndex].ScoreString := IntToStr(10 + StrToInt(Frames[AIndex + 1].ThrowString1))
              else
              begin
                if Frames[AIndex].ThrowString2.IsEmpty or
                   (StrToInt(Frames[AIndex].ThrowString1) + StrToInt(Frames[AIndex].ThrowString2) > 9) then
                begin
                  for LIndex := AIndex to 9 do
                    Frames[LIndex].ScoreString := '';
                end
                else
                  Frames[AIndex].ScoreString := IntToStr(StrToInt(Frames[AIndex].ThrowString1) + StrToInt(Frames[AIndex].ThrowString2));
              end
            end;
          end;
        end;

        8: //9번 프레임
        begin
          if (Frames[AIndex].ThrowString1 = CO_PIN_STRIKE) then
          begin
            if (Frames[AIndex + 1].ThrowString1 = CO_PIN_STRIKE) and
               (Frames[AIndex + 1].ThrowString2 = CO_PIN_STRIKE) then
              Frames[AIndex].ScoreString := '30'
            else
            begin
              if (Frames[AIndex + 1].ThrowString1 = CO_PIN_STRIKE) then
                Frames[AIndex].ScoreString := IntToStr(20 + StrToInt(Frames[AIndex + 1].ThrowString2))
              else
              begin
                if (Frames[AIndex + 1].ThrowString2 = CO_PIN_SPARE) then
                  Frames[AIndex].ScoreString := '20'
                else
                  Frames[AIndex].ScoreString := IntToStr(10 + StrToInt(Frames[AIndex + 1].ThrowString1) + StrToInt(Frames[AIndex + 1].ThrowString2));
              end;
            end;
          end
          else
          begin
            if (Frames[AIndex].ThrowString2 = CO_PIN_SPARE) and (Frames[AIndex + 1].ThrowString1 = CO_PIN_STRIKE) then
              Frames[AIndex].ScoreString := '20'
            else
            begin
              if (Frames[AIndex].ThrowString2 = CO_PIN_SPARE) then
                Frames[AIndex].ScoreString := IntToStr(10 + StrToInt(Frames[AIndex + 1].ThrowString1))
              else
              begin
                if Frames[AIndex].ThrowString2.IsEmpty or
                   (StrToInt(Frames[AIndex].ThrowString1) + StrToInt(Frames[AIndex].ThrowString2) > 9) then
                begin
                  for LIndex := AIndex to 9 do
                    Frames[LIndex].ScoreString := '';
                end
                else
                  Frames[AIndex].ScoreString := IntToStr(StrToInt(Frames[AIndex].ThrowString1) + StrToInt(Frames[AIndex].ThrowString2));
              end
            end;
          end;
        end;

        9: //10번 프레임
        begin
          if (Frames[AIndex].ThrowString1 = CO_PIN_STRIKE) then
          begin
            if (Frames[AIndex].ThrowString2 = CO_PIN_STRIKE) and
               (Frames[AIndex].ThrowString3 = CO_PIN_STRIKE) then
              Frames[AIndex].ScoreString := '30'
            else
            begin
              if (Frames[AIndex].ThrowString2 = CO_PIN_STRIKE) then
                Frames[AIndex].ScoreString := IntToStr(20 + StrToInt(Frames[AIndex].ThrowString3))
              else
              begin
                if (Frames[AIndex].ThrowString3 = CO_PIN_SPARE) then
                  Frames[AIndex].ScoreString := '20'
                else
                begin
                  if (StrToInt(Frames[AIndex].ThrowString3) > (9 - StrToInt(Frames[AIndex].ThrowString2))) then
                    Frames[AIndex].ScoreString := ''
                  else
                    Frames[AIndex].ScoreString := IntToStr(10 + StrToInt(Frames[AIndex].ThrowString2) + StrToInt(Frames[AIndex].ThrowString3));
                end;
              end;
            end;
          end
          else
          begin
            if (Frames[AIndex].ThrowString2 = CO_PIN_SPARE) and
               (Frames[AIndex].ThrowString3 = CO_PIN_STRIKE) then
              Frames[AIndex].ScoreString := '20'
            else
            begin
              if (Frames[AIndex].ThrowString2 = CO_PIN_SPARE) then
                Frames[AIndex].ScoreString := IntToStr(10 + StrToInt(Frames[AIndex].ThrowString3))
              else
              begin
                if Frames[AIndex].ThrowString2.IsEmpty or
                   (StrToInt(Frames[AIndex].ThrowString1) + StrToInt(Frames[AIndex].ThrowString2) > 9) then
                  Frames[AIndex].ScoreString := ''
                else
                  Frames[AIndex].ScoreString := IntToStr(StrToInt(Frames[AIndex].ThrowString1) + StrToInt(Frames[AIndex].ThrowString2));
              end
            end;
          end;
        end;
      end;

      //이전 프레임 점수를 더함
      if (AIndex > 0) then //1번 프레임 제외
        Frames[AIndex].ScoreString := IntToStr(StrToInt(Frames[AIndex].ScoreString) + StrToInt(Frames[AIndex - 1].ScoreString));
      Frames[AIndex].ScoreError := False;
      Result := True;
    except
      on E: Exception do
      begin
        Frames[AIndex].ScoreString := '';
        Frames[AIndex].ScoreError := True;
      end;
    end;
  finally
    Frames[AIndex].ScoreLabel.Caption := Frames[AIndex].ScoreString;
  end;
end;

procedure TBowlerPanel.RefreshScore;
var
  nScore: Word;
begin
  nScore := 0;
  for var I: ShortInt := 0 to High(Frames) do
  begin
    ComputeScore(I);
    if (StrToIntDef(Frames[I].ScoreString, 0) > nScore) then
      nScore := StrToIntDef(Frames[I].ScoreString, 0);
  end;
  GameScore := nScore;
end;

procedure TBowlerPanel.SetBowlerName(const AValue: string);
begin
  FBowlerName := AValue;
  BowlerNameLabel.Caption := FBowlerName + _CRLF + AssignNo;
end;

procedure TBowlerPanel.SetFrameNo(const AValue: ShortInt);
begin
  if (FFrameNo <> AValue) then
  begin
    FFrameNo := AValue;
    if (FFrameNo > 0) then
      Frames[Pred(FFrameNo)].FrameGroupBox.Font.Color := $00326FFF;
  end;
end;

procedure TBowlerPanel.SetGameScore(const AValue: Word);
begin
  if (FGameScore <> AValue) then
  begin
    FGameScore := AValue;
    GameScoreLabel.Caption := FGameScore.ToString;
  end;
end;

procedure TBowlerPanel.SetPinFallResult(const AValue: string);
var
  LValue: string;
  LIndex, LFrame: ShortInt;
begin
  LValue := AValue.Substring(0, FrameNo * 2).PadRight(21, #32);
  if (FPinFallResult <> LValue) then
  begin
    FPinFallResult := LValue;
    LFrame := 0;
    LIndex := 1;
    repeat
      Frames[LFrame].ThrowInput1.Text := FPinFallResult[LIndex];
      Frames[LFrame].ThrowInput2.Text := FPinFallResult[LIndex + 1];
      Frames[LFrame].OldThrowString1 := Frames[LFrame].ThrowInput1.Text;
      Frames[LFrame].OldThrowString2 := Frames[LFrame].ThrowInput2.Text;
      if Assigned(Frames[LFrame].ThrowInput3) then
      begin
        Frames[LFrame].ThrowInput3.Text := FPinFallResult[LIndex + 2];
        Frames[LFrame].OldThrowString3 := Frames[LFrame].ThrowInput3.Text;
      end;
      Inc(LFrame);
      Inc(LIndex, 2);
    until LIndex > 20;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TBPLaneScoreViewForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.
