object BPSettingForm: TBPSettingForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'BPDM.imlIcon32'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #49884#49828#53596' '#54872#44221' '#49444#51221
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    StyleElements = []
    OnMouseMove = panHeaderMouseMove
    object lblPluginVersion: TLabel
      AlignWithMargins = True
      Left = 43
      Top = 5
      Width = 95
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'PLUGIN Ver.1.0.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      ExplicitHeight = 13
    end
    object panHeaderToolbar: TPanel
      AlignWithMargins = True
      Left = 765
      Top = 3
      Width = 32
      Height = 32
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 0
      StyleElements = []
      ExplicitLeft = 733
      object btnClose: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 3
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        OnClick = btnCloseClick
      end
    end
    object panHeaderMenuBar: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 32
      Height = 32
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 1
      StyleElements = []
      object btnMainMenu: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 1
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        ExplicitTop = 2
      end
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 43
    Width = 790
    Height = 50
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object btnSettingFile: TSpeedButton
      Tag = 1
      AlignWithMargins = True
      Left = 230
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alLeft
      Caption = #49444#51221' '#54028#51068
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      OnClick = OnSettingPageButtonClick
    end
    object btnBaseSetting: TSpeedButton
      AlignWithMargins = True
      Left = 115
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alLeft
      Caption = #44592#48376' '#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      OnClick = OnSettingPageButtonClick
    end
    object btnSaveSetting: TBitBtn
      AlignWithMargins = True
      Left = 680
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = #51201#50857
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 59
      ImageName = 'done_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 0
      WordWrap = True
      OnClick = btnSaveSettingClick
    end
    object ckbApplyToPartnerCenter: TCheckBox
      Left = 528
      Top = 0
      Width = 147
      Height = 50
      Align = alRight
      Caption = #54028#53944#45320#49468#53552#50640#46020' '#51200#51109
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = ckbApplyToPartnerCenterClick
    end
    object btnRefresh: TBitBtn
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alLeft
      Caption = #49352#47196' '#44256#52840
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnRefreshClick
    end
  end
  object pgcSetting: TPageControl
    AlignWithMargins = True
    Left = 5
    Top = 98
    Width = 790
    Height = 497
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = tabSetting
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TabStop = False
    object tabSetting: TTabSheet
      Caption = #44592#48376' '#49444#51221
      object panStoreInfo: TPanel
        Left = 0
        Top = 0
        Width = 294
        Height = 464
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 463
        object mmoStoreInfo: TMemo
          AlignWithMargins = True
          Left = 6
          Top = 30
          Width = 282
          Height = 428
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ExplicitHeight = 427
        end
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 292
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = ' '#8801#49324#50629#51109' '#51221#48372
          Color = 5393480
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
          StyleElements = [seBorder]
        end
      end
      object panBaseInfo: TPanel
        Left = 294
        Top = 0
        Width = 488
        Height = 464
        Align = alClient
        ParentBackground = False
        TabOrder = 1
        ExplicitHeight = 463
        object lblOAuthResult: TLabel
          Left = 213
          Top = 184
          Width = 82
          Height = 18
          Caption = #54869#51064#46104#51648' '#50506#51020
        end
        object Panel5: TPanel
          Left = 1
          Top = 1
          Width = 486
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = ' '#8801#44592#48376' '#51221#48372
          Color = 5393480
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 9
          StyleElements = [seBorder]
        end
        object edtTerminalId: TDBEditEh
          Left = 99
          Top = 43
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          CharCase = ecUpperCase
          ControlLabel.Width = 57
          ControlLabel.Height = 18
          ControlLabel.Caption = #53552#48120#45328' ID'
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #53552#48120#45328' ID'
          ImeMode = imSAlpha
          TabOrder = 0
          Visible = True
          EditMask = ''
        end
        object edtApiHostUrl: TDBEditEh
          Left = 99
          Top = 76
          Width = 374
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 81
          ControlLabel.Height = 18
          ControlLabel.Caption = 'API'#49436#48260' URL'
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = 'API'#49436#48260' URL'
          ImeMode = imSAlpha
          TabOrder = 2
          Visible = True
          EditMask = ''
        end
        object edtSecretKey: TDBEditEh
          Left = 99
          Top = 109
          Width = 374
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 56
          ControlLabel.Height = 18
          ControlLabel.Caption = #49884#53356#47551' '#53412
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #49884#53356#47551' '#53412
          ImeMode = imSAlpha
          PasswordChar = '*'
          TabOrder = 3
          Text = '1234'
          Visible = True
          OnDblClick = edtSecretKeyDblClick
          EditMask = ''
        end
        object edtDeployHostUrl: TDBEditEh
          Left = 99
          Top = 229
          Width = 374
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 84
          ControlLabel.Height = 18
          ControlLabel.Caption = #48176#54252#49436#48260' URL'
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #48176#54252#49436#48260' URL'
          ImeMode = imSAlpha
          TabOrder = 6
          Visible = True
          EditMask = ''
        end
        object edtVanTID: TDBEditEh
          Left = 99
          Top = 411
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          CharCase = ecUpperCase
          ControlLabel.Width = 57
          ControlLabel.Height = 18
          ControlLabel.Caption = 'VAN TID'
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = 'VAN TID'
          ImeMode = imSAlpha
          TabOrder = 7
          Visible = True
          EditMask = ''
        end
        object edtPaycoTID: TDBEditEh
          Left = 342
          Top = 411
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          CharCase = ecUpperCase
          ControlLabel.Width = 74
          ControlLabel.Height = 18
          ControlLabel.Caption = 'PAYCO TID'
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = 'PAYCO TID'
          ImeMode = imSAlpha
          TabOrder = 8
          Visible = True
          EditMask = ''
        end
        object ckbUseLocalSetting: TCheckBox
          Left = 360
          Top = 48
          Width = 112
          Height = 17
          Caption = #47196#52972' '#49444#51221' '#49324#50857
          TabOrder = 1
        end
        object btnCheckOAuth: TBitBtn
          AlignWithMargins = True
          Left = 99
          Top = 175
          Width = 110
          Height = 37
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = #51064#51613' '#53580#49828#53944
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = btnCheckOAuthClick
        end
        object edtTimeout: TDBNumberEditEh
          Left = 99
          Top = 142
          Width = 70
          Height = 26
          ControlLabel.Width = 87
          ControlLabel.Height = 18
          ControlLabel.Caption = #53440#51076#50500#50883'('#13223')'
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          Alignment = taCenter
          DynProps = <>
          EmptyDataInfo.Text = #48128#47532#52488
          EditButtons = <>
          MaxValue = 60000.000000000000000000
          MinValue = 1000.000000000000000000
          TabOrder = 4
          Value = 1000.000000000000000000
          Visible = True
        end
      end
    end
    object tabIniFile: TTabSheet
      Caption = #49444#51221' '#54028#51068
      ImageIndex = 1
      object mmoSettingFile: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 64
        Width = 776
        Height = 397
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
        ExplicitHeight = 396
      end
      object panSettingFile: TPanel
        Left = 0
        Top = 0
        Width = 782
        Height = 24
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = ' '#8801#54872#44221#49444#51221' '#54028#51068' '#45236#50669
        Color = 5393480
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        StyleElements = [seBorder]
        OnDblClick = panSettingFileDblClick
      end
      object panEncToDec: TPanel
        Left = 0
        Top = 24
        Width = 782
        Height = 37
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object edtEncryptString: TDBEditEh
          Left = 106
          Top = 5
          Width = 496
          Height = 28
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 99
          ControlLabel.Height = 18
          ControlLabel.Caption = #50516#54840#54868' '#54624' '#47928#51088#50676
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = clWindowText
          ControlLabel.Font.Height = -15
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #50516#54840#54868' '#54624' '#47928#51088#50676
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImeMode = imSAlpha
          ParentFont = False
          TabOrder = 0
          Visible = True
          EditMask = ''
        end
        object btnDecryptString: TBitBtn
          AlignWithMargins = True
          Left = 605
          Top = 3
          Width = 174
          Height = 31
          Cursor = crHandPoint
          Align = alRight
          Caption = #48373#54840#54868' '#54980' '#53364#47549#48372#46300#47196' '#48373#49324
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnDecryptStringClick
        end
      end
    end
  end
end
