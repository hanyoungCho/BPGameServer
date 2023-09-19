object BPSettingLocalForm: TBPSettingLocalForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
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
    Caption = #49324#50857#51088' '#54872#44221' '#49444#51221
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
      object btnClose: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 3
        ImageName = 'Close_W_32px'
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
        ImageName = 'Menu_W_32px'
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
  object panBody: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 98
    Width = 790
    Height = 497
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object panPageTitle: TPanel
      Left = 1
      Top = 1
      Width = 788
      Height = 24
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = ' '#8801#44592#48376' '#49444#51221
      Color = 5393480
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      StyleElements = [seBorder]
    end
    object pgcSetting: TPageControl
      Left = 1
      Top = 25
      Width = 788
      Height = 471
      ActivePage = tabTest
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object tabBasic: TTabSheet
        Caption = #44592#48376
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        object rdgThemeStyle: TRadioGroup
          Left = 20
          Top = 20
          Width = 225
          Height = 65
          Caption = #54868#47732' '#49828#53440#51068' '
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          Items.Strings = (
            #46972#51060#53944' '#47784#46300
            #45796#53356' '#47784#46300)
          ParentFont = False
          TabOrder = 0
        end
        object ckbHideTaskBar: TDBCheckBoxEh
          Left = 20
          Top = 106
          Width = 160
          Height = 17
          Caption = #51089#50629#54364#49884#51460' '#51088#46041' '#49704#44608
          DynProps = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object ckbSelfCashReceipt: TDBCheckBoxEh
          Left = 20
          Top = 146
          Width = 160
          Height = 17
          Caption = #54788#44552#50689#49688#51613' '#51088#51652' '#48156#44553
          DynProps = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object ckbAutoRunAdminCall: TDBCheckBoxEh
          Left = 20
          Top = 186
          Width = 160
          Height = 17
          Caption = #50508#47532#48120' '#51088#46041' '#49892#54665
          DynProps = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object edtReceiptCopies: TDBNumberEditEh
          AlignWithMargins = True
          Left = 118
          Top = 224
          Width = 81
          Height = 28
          ControlLabel.Width = 95
          ControlLabel.Height = 18
          ControlLabel.Caption = #50689#49688#51613' '#48156#54665#47588#49688
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          Alignment = taCenter
          AutoSize = False
          DynProps = <>
          EditButtons = <
            item
              Style = ebsMinusEh
            end
            item
              Style = ebsPlusEh
            end>
          MaxValue = 10.000000000000000000
          MinValue = 1.000000000000000000
          ReadOnly = True
          TabOrder = 4
          Value = 1.000000000000000000
          Visible = True
        end
      end
      object tabWakeOnLan: TTabSheet
        Caption = #50896#44201#49884#46041
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImageIndex = 2
        ParentFont = False
        object lblNoticeRemote: TLabel
          Left = 20
          Top = 20
          Width = 343
          Height = 42
          Caption = 
            #8251' '#50896#44201#49884#46041#51012' '#51228#50612#54624' '#45824#49345#51109#52824#51032' MAC '#51452#49548#47484' '#54665' '#45800#50948#47196' '#51077#47141#54616#49901#49884#50724'.'#13'    '#45824#49345#51109#52824#44032' Wake-On-LAN(Ne' +
            'twork Wakeup)'#51012' '#51648#50896#54616#50668#50556' '#54633#45768#45796'.'#13'    (MAC '#51452#49548' '#51077#47141' '#54805#49885' '#9758'  XX-XX-XX-XX-XX-XX' +
            ')'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 14924922
          Font.Height = -12
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          StyleElements = [seClient, seBorder]
        end
        object mmoWakeOnLan: TMemo
          AlignWithMargins = True
          Left = 20
          Top = 73
          Width = 353
          Height = 195
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object tabWeather: TTabSheet
        Caption = #45216#50472#51221#48372
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImageIndex = 3
        ParentFont = False
        object edtWeatherApiKey: TDBEditEh
          Left = 104
          Top = 119
          Width = 657
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 40
          ControlLabel.Height = 18
          ControlLabel.Caption = 'API '#53412
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
          OnDblClick = edtWeatherApiKeyDblClick
          EditMask = ''
        end
        object edtWeatherLatitude: TDBEditEh
          Left = 104
          Top = 53
          Width = 110
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 26
          ControlLabel.Height = 18
          ControlLabel.Caption = #50948#46020
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #50948#46020
          ImeMode = imSAlpha
          TabOrder = 1
          Text = '126.59'
          Visible = True
          EditMask = ''
        end
        object edtWeatherLongitude: TDBEditEh
          Left = 104
          Top = 86
          Width = 110
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 26
          ControlLabel.Height = 18
          ControlLabel.Caption = #44221#46020
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #44221#46020
          ImeMode = imSAlpha
          TabOrder = 2
          Text = '37.33'
          Visible = True
          EditMask = ''
        end
        object edtWeatherApiHost: TDBEditEh
          Left = 104
          Top = 20
          Width = 657
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
          TabOrder = 0
          Text = 'https://api.openweathermap.org/'
          Visible = True
          EditMask = ''
        end
        object btnWeatherSite: TBitBtn
          AlignWithMargins = True
          Left = 103
          Top = 149
          Width = 111
          Height = 37
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = #49324#51060#53944' '#48169#47928
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = btnWeatherSiteClick
        end
        object btnWeatherApiTest: TBitBtn
          AlignWithMargins = True
          Left = 218
          Top = 149
          Width = 111
          Height = 37
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Caption = 'API '#53580#49828#53944
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = btnWeatherApiTestClick
        end
      end
      object tabTest: TTabSheet
        Caption = #53580#49828#53944
        ImageIndex = 3
        object mmoTestLog: TMemo
          AlignWithMargins = True
          Left = 3
          Top = 50
          Width = 774
          Height = 385
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #44404#47548#52404
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 1
        end
        object panTestToolbar: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 774
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object btnHexBin: TBitBtn
            AlignWithMargins = True
            Left = 458
            Top = 0
            Width = 102
            Height = 41
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alRight
            Caption = 'HEX/BIN'#13#10#53580#49828#53944
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = btnHexBinClick
          end
          object btlSaveLog: TBitBtn
            Left = 672
            Top = 0
            Width = 102
            Height = 41
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alRight
            Caption = #47196#44536' '#51200#51109
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            OnClick = btlSaveLogClick
          end
          object btnClearLog: TBitBtn
            AlignWithMargins = True
            Left = 565
            Top = 0
            Width = 102
            Height = 41
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 0
            Align = alRight
            Caption = #47196#44536' '#52488#44592#54868
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = btnClearLogClick
          end
          object edtTestValue: TDBEditEh
            Left = 33
            Top = 7
            Width = 288
            Height = 27
            Alignment = taLeftJustify
            AutoSize = False
            CharCase = ecUpperCase
            ControlLabel.Width = 26
            ControlLabel.Height = 18
            ControlLabel.Caption = #51077#47141
            ControlLabel.Visible = True
            ControlLabelLocation.Spacing = 5
            ControlLabelLocation.Position = lpLeftCenterEh
            DynProps = <>
            EditButtons = <>
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = #44404#47548#52404
            Font.Style = []
            ImeMode = imSAlpha
            ParentFont = False
            TabOrder = 0
            Text = '03F7'
            Visible = True
            EditMask = ''
          end
          object cbxTestValueType: TDBComboBoxEh
            Left = 366
            Top = 8
            Width = 81
            Height = 26
            ControlLabel.Width = 26
            ControlLabel.Height = 18
            ControlLabel.Caption = #54805#49885
            ControlLabel.Visible = True
            ControlLabelLocation.Spacing = 5
            ControlLabelLocation.Position = lpLeftCenterEh
            DynProps = <>
            EditButtons = <>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Items.Strings = (
              'HEX'
              'BIN'
              'STR')
            ParentFont = False
            TabOrder = 1
            Visible = True
          end
        end
      end
    end
  end
  object panToolbar: TPanel
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
    object btnPage2: TSpeedButton
      Tag = 1
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
      GroupIndex = 100
      Caption = #50896#44201' '#49884#46041
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      OnClick = OnPageButtonClick
      ExplicitLeft = 230
    end
    object btnPage0: TSpeedButton
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
      GroupIndex = 100
      Down = True
      Caption = #44592#48376
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      OnClick = OnPageButtonClick
      ExplicitLeft = 115
    end
    object btnPage3: TSpeedButton
      Tag = 2
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
      GroupIndex = 100
      Caption = #45216#50472' '#51221#48372
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      OnClick = OnPageButtonClick
      ExplicitLeft = 435
    end
    object btnPage4: TSpeedButton
      Tag = 3
      AlignWithMargins = True
      Left = 345
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alLeft
      GroupIndex = 100
      Caption = #53580#49828#53944
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      OnClick = OnPageButtonClick
      ExplicitLeft = 446
    end
    object btnSaveSetting: TBitBtn
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
  end
end
