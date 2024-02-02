object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'GameServer'
  ClientHeight = 716
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 57
    Align = alTop
    BevelInner = bvLowered
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 1004
    object edApiResult: TEdit
      Left = 400
      Top = 18
      Width = 57
      Height = 21
      TabOrder = 0
    end
    object pnlSeat: TPanel
      Left = 15
      Top = 16
      Width = 74
      Height = 26
      Caption = 'Seat'
      Color = clBlue
      ParentBackground = False
      TabOrder = 1
    end
    object pnlCom: TPanel
      Left = 95
      Top = 16
      Width = 74
      Height = 26
      Caption = 'Com'
      Color = clGreen
      ParentBackground = False
      TabOrder = 2
    end
    object pnlEmergency: TPanel
      Left = 187
      Top = 16
      Width = 150
      Height = 26
      Caption = #44596#44553#48176#51221#47784#46300
      ParentBackground = False
      TabOrder = 3
    end
    object btnDebug: TButton
      Left = 343
      Top = 18
      Width = 51
      Height = 25
      Caption = 'Debug'
      TabOrder = 4
    end
  end
  object pnlSingle: TPanel
    Left = 0
    Top = 57
    Width = 660
    Height = 659
    Align = alClient
    BevelInner = bvLowered
    Color = clWindow
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #45208#45588#44256#46357
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 656
    ExplicitHeight = 658
  end
  object Panel1: TPanel
    Left = 660
    Top = 57
    Width = 348
    Height = 659
    Align = alRight
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    ExplicitLeft = 656
    ExplicitHeight = 658
    object Label3: TLabel
      Left = 20
      Top = 26
      Width = 13
      Height = 13
      Caption = 'No'
    end
    object Memo1: TMemo
      Left = 6
      Top = 46
      Width = 321
      Height = 267
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #45208#45588#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object Button1: TButton
      Left = 82
      Top = 15
      Width = 65
      Height = 25
      Caption = #45936#51060#53552' '#54869#51064
      TabOrder = 1
      OnClick = Button1Click
    end
    object edLaneNo: TEdit
      Left = 42
      Top = 18
      Width = 34
      Height = 21
      TabOrder = 2
    end
    object btnHoldCancel: TButton
      Left = 153
      Top = 15
      Width = 65
      Height = 25
      Caption = #54848#46300#52712#49548
      TabOrder = 3
      OnClick = btnHoldCancelClick
    end
    object Panel3: TPanel
      Left = 6
      Top = 335
      Width = 331
      Height = 146
      BevelInner = bvRaised
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 4
      object laCnt1: TLabel
        Left = 239
        Top = 35
        Width = 43
        Height = 13
        Caption = '60 60/60'
      end
      object laFrame1: TLabel
        Left = 65
        Top = 35
        Width = 126
        Height = 13
        Caption = '000000000000000000000'
      end
      object laName1: TLabel
        Left = 15
        Top = 35
        Width = 33
        Height = 13
        Caption = #54861#44600#46041
      end
      object laScore1: TLabel
        Left = 205
        Top = 35
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laCnt2: TLabel
        Left = 239
        Top = 51
        Width = 43
        Height = 13
        Caption = '60 60/60'
      end
      object laFrame2: TLabel
        Left = 65
        Top = 51
        Width = 126
        Height = 13
        Caption = '000000000000000000000'
      end
      object laName2: TLabel
        Left = 15
        Top = 51
        Width = 33
        Height = 13
        Caption = #54861#44600#46041
      end
      object laScore2: TLabel
        Left = 205
        Top = 51
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laCnt3: TLabel
        Left = 239
        Top = 67
        Width = 43
        Height = 13
        Caption = '60 60/60'
      end
      object laFrame3: TLabel
        Left = 65
        Top = 67
        Width = 126
        Height = 13
        Caption = '000000000000000000000'
      end
      object laName3: TLabel
        Left = 15
        Top = 67
        Width = 33
        Height = 13
        Caption = #54861#44600#46041
      end
      object laScore3: TLabel
        Left = 205
        Top = 67
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laCnt4: TLabel
        Left = 239
        Top = 83
        Width = 43
        Height = 13
        Caption = '60 60/60'
      end
      object laFrame4: TLabel
        Left = 65
        Top = 83
        Width = 126
        Height = 13
        Caption = '000000000000000000000'
      end
      object laName4: TLabel
        Left = 15
        Top = 83
        Width = 33
        Height = 13
        Caption = #54861#44600#46041
      end
      object laScore4: TLabel
        Left = 205
        Top = 83
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laCnt5: TLabel
        Left = 239
        Top = 99
        Width = 43
        Height = 13
        Caption = '60 60/60'
      end
      object laFrame5: TLabel
        Left = 65
        Top = 99
        Width = 126
        Height = 13
        Caption = '000000000000000000000'
      end
      object laName5: TLabel
        Left = 15
        Top = 99
        Width = 33
        Height = 13
        Caption = #54861#44600#46041
      end
      object laScore5: TLabel
        Left = 205
        Top = 99
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laCnt6: TLabel
        Left = 239
        Top = 115
        Width = 43
        Height = 13
        Caption = '60 60/60'
      end
      object laFrame6: TLabel
        Left = 65
        Top = 115
        Width = 126
        Height = 13
        Caption = '000000000000000000000'
      end
      object laName6: TLabel
        Left = 15
        Top = 115
        Width = 33
        Height = 13
        Caption = #54861#44600#46041
      end
      object laScore6: TLabel
        Left = 205
        Top = 115
        Width = 18
        Height = 13
        Caption = '000'
      end
      object Label23: TLabel
        Left = 20
        Top = 11
        Width = 20
        Height = 13
        Caption = 'lane'
      end
      object edlaneMon: TEdit
        Left = 42
        Top = 8
        Width = 34
        Height = 21
        TabOrder = 0
      end
    end
    object Button2: TButton
      Left = 32
      Top = 519
      Width = 65
      Height = 25
      Caption = #50672#49845
      TabOrder = 5
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 102
      Top = 519
      Width = 65
      Height = 25
      Caption = #47532#44536
      TabOrder = 6
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 173
      Top = 519
      Width = 65
      Height = 25
      Caption = #47532#44536#54644#51228
      TabOrder = 7
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 244
      Top = 519
      Width = 65
      Height = 25
      Caption = #50724#54536
      TabOrder = 8
      OnClick = Button6Click
    end
    object Button3: TButton
      Left = 102
      Top = 550
      Width = 65
      Height = 25
      Caption = #48380#47084#49688#48320#44221
      TabOrder = 9
      OnClick = Button3Click
    end
    object Edit1: TEdit
      Left = 62
      Top = 550
      Width = 34
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      Text = '3'
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 368
    Top = 40
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Active = False
    Left = 370
    Top = 97
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 457
    Top = 114
  end
end
