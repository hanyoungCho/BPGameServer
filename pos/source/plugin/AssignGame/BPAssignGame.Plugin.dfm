object BPAssignGameForm: TBPAssignGameForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #47676#51200' '#48176#51221#54624' '#47112#51064#51012' '#49440#53469#54616#49901#49884#50724'.'
  ClientHeight = 675
  ClientWidth = 1260
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnCloseQuery = PluginModuleCloseQuery
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
    Width = 1260
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #48176#51221' '#46321#47197
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
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
      Left = 1225
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
  object panMinimap: TPanel
    Left = 0
    Top = 38
    Width = 1260
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    Padding.Left = 5
    Padding.Right = 5
    Padding.Bottom = 5
    ParentFont = False
    TabOrder = 0
    object btnClearAssignList: TBitBtn
      AlignWithMargins = True
      Left = 1215
      Top = 5
      Width = 40
      Height = 40
      Cursor = crHandPoint
      Hint = #48176#51221' '#47785#47197' '#52488#44592#54868
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 49
      ImageName = 'cancel_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnClearAssignListClick
    end
  end
  object panMain: TPanel
    Left = 0
    Top = 88
    Width = 1260
    Height = 587
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    BevelOuter = bvNone
    Caption = #48176#51221#54624' '#47112#51064#51012' '#47676#51200' '#49440#53469#54616#49901#49884#50724'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object panAssignInfo: TPanel
      AlignWithMargins = True
      Left = 1039
      Top = 0
      Width = 216
      Height = 582
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lblBowlerCount: TLabel
        Left = 11
        Top = 16
        Width = 193
        Height = 19
        Alignment = taCenter
        AutoSize = False
        Caption = #51060#50857#51088' '#49688
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
      end
      object lblBaseGameCount: TLabel
        Left = 11
        Top = 181
        Width = 193
        Height = 19
        Alignment = taCenter
        AutoSize = False
        Caption = #51060#50857' '#44172#51076' '#49688
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
      end
      object lblBaseGameMin: TLabel
        Left = 11
        Top = 245
        Width = 193
        Height = 19
        Alignment = taCenter
        AutoSize = False
        Caption = #54924#50896#44428' '#44172#51076' '#51060#50857' '#49884#44036'('#48516')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
      end
      object rdgBaseGameDiv: TRadioGroup
        Left = 51
        Top = 80
        Width = 112
        Height = 87
        Caption = #50836#44552#51228' '#49440#53469
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          #44172#51076' '#50836#44552#51228
          #49884#44036' '#50836#44552#51228)
        ParentFont = False
        TabOrder = 3
        OnClick = rdgBaseGameDivClick
      end
      object btnBaseGameCountInc: TBitBtn
        Left = 129
        Top = 202
        Width = 34
        Height = 29
        Caption = #65291
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = btnBaseGameCountIncClick
      end
      object btnBaseGameCountDec: TBitBtn
        Left = 51
        Top = 202
        Width = 34
        Height = 29
        Caption = #65293
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = btnBaseGameCountDecClick
      end
      object btnBowlerCountDec: TBitBtn
        Left = 51
        Top = 37
        Width = 34
        Height = 29
        Caption = #65293
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnBowlerCountDecClick
      end
      object btnBowlerCountInc: TBitBtn
        Left = 129
        Top = 37
        Width = 34
        Height = 29
        Caption = #65291
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnBowlerCountIncClick
      end
      object btnBaseProdPopup: TBitBtn
        Left = 100
        Top = 372
        Width = 50
        Height = 50
        Caption = #51204#52404#13#10#51201#50857
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        OnClick = btnBaseProdPopupClick
      end
      object edtBaseProdName: TDBEditEh
        Left = 11
        Top = 339
        Width = 193
        Height = 27
        TabStop = False
        AutoSize = False
        ControlLabel.Width = 99
        ControlLabel.Height = 18
        ControlLabel.Caption = #50836#44552#51228' '#51068#44292' '#51201#50857
        ControlLabel.Visible = True
        DynProps = <>
        EditButtons = <>
        EmptyDataInfo.Text = #44592#48376' '#49345#54408
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
        Visible = True
        OnClick = edtBaseProdNameClick
      end
      object edtBowlerCount: TNumberBox
        Left = 87
        Top = 38
        Width = 40
        Height = 26
        TabStop = False
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        MinValue = 1.000000000000000000
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Value = 1.000000000000000000
      end
      object edtBaseGameCount: TNumberBox
        Left = 87
        Top = 203
        Width = 40
        Height = 26
        TabStop = False
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        LargeStep = 1.000000000000000000
        MinValue = 1.000000000000000000
        MaxValue = 10.000000000000000000
        MaxLength = 2
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
        Value = 1.000000000000000000
      end
      object edtBaseProdAmt: TDBNumberEditEh
        Left = 11
        Top = 394
        Width = 83
        Height = 27
        TabStop = False
        ControlLabel.Width = 26
        ControlLabel.Height = 18
        ControlLabel.Caption = #50836#44552
        ControlLabel.Visible = True
        AutoSize = False
        DecimalPlaces = 0
        DisplayFormat = ',0 '#50896
        DynProps = <>
        EditButtons = <>
        ReadOnly = True
        TabOrder = 11
        Value = 0.000000000000000000
        Visible = True
      end
      object btnBaseProdClear: TBitBtn
        Left = 155
        Top = 372
        Width = 50
        Height = 50
        Caption = #51201#50857#13#10#52712#49548
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
        OnClick = btnBaseProdClearClick
      end
      object btnDoAssign: TBitBtn
        AlignWithMargins = True
        Left = 11
        Top = 498
        Width = 194
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Caption = #48176#51221' '#46321#47197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImageIndex = 36
        ImageName = 'BowlingPins_32px'
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 15
        OnClick = btnDoAssignClick
      end
      object btnDoReserve: TBitBtn
        AlignWithMargins = True
        Left = 11
        Top = 438
        Width = 194
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Caption = #50696#50557' '#46321#47197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ImageIndex = 27
        ImageName = 'Task_32px'
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 14
        TabStop = False
        OnClick = btnDoReserveClick
      end
      object btnBaseGameMinDec: TBitBtn
        Left = 51
        Top = 266
        Width = 34
        Height = 29
        Caption = #65293
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnClick = btnbaseGameMinDecClick
      end
      object edtBaseGameMin: TNumberBox
        Left = 87
        Top = 267
        Width = 40
        Height = 26
        TabStop = False
        Alignment = taCenter
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        LargeStep = 1.000000000000000000
        MaxValue = 600.000000000000000000
        MaxLength = 3
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
      object btnBaseGameMinInc: TBitBtn
        Left = 129
        Top = 266
        Width = 34
        Height = 29
        Caption = #65291
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
        OnClick = btnBaseGameMinIncClick
      end
    end
    object panAssignList: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 0
      Width = 1029
      Height = 582
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 1
      object panAssignListHeader: TPanel
        Left = 1
        Top = 1
        Width = 1027
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object lblBowerNameTitle: TLabel
          AlignWithMargins = True
          Left = 100
          Top = 5
          Width = 264
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #48380#47084'/'#54924#50896#44428' '#51221#48372
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
        end
        object lblGameCountTitle: TLabel
          AlignWithMargins = True
          Left = 546
          Top = 5
          Width = 105
          Height = 25
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #51060#50857' '#44172#51076' '#49688
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitLeft = 453
        end
        object lblShoesRentTitle: TLabel
          AlignWithMargins = True
          Left = 762
          Top = 5
          Width = 107
          Height = 25
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #48380#47553#54868
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
        end
        object lblChargeAmtTitle: TLabel
          AlignWithMargins = True
          Left = 870
          Top = 5
          Width = 108
          Height = 25
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #51060#50857' '#50836#44552
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitLeft = 780
        end
        object lblProdNameTitle: TLabel
          AlignWithMargins = True
          Left = 365
          Top = 5
          Width = 180
          Height = 25
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #44172#51076' '#50836#44552' '#49345#54408' '#51221#48372
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitLeft = 272
        end
        object lblGameMinTitle: TLabel
          AlignWithMargins = True
          Left = 693
          Top = 5
          Width = 68
          Height = 25
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #51060#50857' '#49884#44036
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitLeft = 600
        end
        object lblRemoveBowlerTitle: TLabel
          AlignWithMargins = True
          Left = 983
          Top = 5
          Width = 32
          Height = 25
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #49325#51228
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
        end
        object lblBowlerIdTitle: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 89
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alLeft
          AutoSize = False
          Caption = '    '#8593#8595'      '#49692
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
        end
        object lblGameProgressTitle: TLabel
          AlignWithMargins = True
          Left = 652
          Top = 5
          Width = 40
          Height = 25
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = #51652#54665
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitLeft = 562
        end
      end
      object sbxAssignList: TScrollBox
        Left = 1
        Top = 31
        Width = 1027
        Height = 502
        Margins.Left = 5
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentBackground = True
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnMouseWheel = sbxAssignListMouseWheel
        object TemplateAssignPanel: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 1017
          Height = 50
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alTop
          DragMode = dmAutomatic
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Visible = False
          object _LabelBowlerId: TLabel
            Left = 48
            Top = 11
            Width = 38
            Height = 27
            Alignment = taCenter
            AutoSize = False
            Caption = '99D'
            Layout = tlCenter
          end
          object _DragReorderImage: TImage
            Tag = 999
            Left = 12
            Top = 8
            Width = 32
            Height = 32
            Cursor = crHandPoint
            Hint = #45132#50612' '#45817#44200#49436' '#49692#49436' '#48320#44221
            Center = True
            ParentShowHint = False
            ShowHint = True
            Transparent = True
          end
          object _LabelGameProgress: TLabel
            Left = 650
            Top = 11
            Width = 38
            Height = 27
            Alignment = taCenter
            AutoSize = False
            Caption = '0'
            Layout = tlCenter
          end
          object _EditBowlerName: TDBEditEh
            Left = 90
            Top = 11
            Width = 90
            Height = 27
            AutoSize = False
            ControlLabel.Font.Charset = DEFAULT_CHARSET
            ControlLabel.Font.Color = clWindowText
            ControlLabel.Font.Height = -12
            ControlLabel.Font.Name = 'Pretendard Variable'
            ControlLabel.Font.Style = []
            ControlLabel.ParentFont = False
            DynProps = <>
            EditButtons = <>
            EmptyDataInfo.Text = '01A'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ImeMode = imSHanguel
            MaxLength = 30
            ParentFont = False
            TabOrder = 0
            Visible = True
          end
          object _CheckboxShoesRent: TCheckBox
            Left = 765
            Top = 16
            Width = 45
            Height = 17
            Caption = #45824#50668
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 11
          end
          object _EditChargeAmt: TDBNumberEditEh
            Left = 870
            Top = 11
            Width = 100
            Height = 27
            TabStop = False
            ControlLabel.Font.Charset = DEFAULT_CHARSET
            ControlLabel.Font.Color = clWindowText
            ControlLabel.Font.Height = -12
            ControlLabel.Font.Name = 'Pretendard Variable'
            ControlLabel.Font.Style = []
            ControlLabel.ParentFont = False
            AutoSize = False
            DecimalPlaces = 0
            DisplayFormat = ',0 '#50896
            DynProps = <>
            EditButtons = <>
            ReadOnly = True
            TabOrder = 13
            Value = 0.000000000000000000
            Visible = True
          end
          object _ButtonMemberPopup: TBitBtn
            Left = 295
            Top = 10
            Width = 30
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ImageIndex = 3
            ImageName = 'find_user_male_16px'
            Images = BPDM.imlIcon16
            ParentFont = False
            TabOrder = 2
          end
          object _ButtonGameCountDec: TButton
            Left = 544
            Top = 10
            Width = 30
            Height = 29
            Caption = #65293
            DoubleBuffered = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentDoubleBuffered = False
            ParentFont = False
            TabOrder = 7
          end
          object _ButtonGameCountInc: TButton
            Left = 616
            Top = 10
            Width = 30
            Height = 29
            Caption = #65291
            DoubleBuffered = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentDoubleBuffered = False
            ParentFont = False
            TabOrder = 9
          end
          object _EditProdName: TDBEditEh
            Left = 364
            Top = 11
            Width = 110
            Height = 27
            TabStop = False
            AutoSize = False
            ControlLabel.Caption = 'TemplateProdGame'
            ControlLabel.Font.Charset = DEFAULT_CHARSET
            ControlLabel.Font.Color = clWindowText
            ControlLabel.Font.Height = -12
            ControlLabel.Font.Name = 'Pretendard Variable'
            ControlLabel.Font.Style = []
            ControlLabel.ParentFont = False
            DynProps = <>
            EditButtons = <>
            EmptyDataInfo.Text = #50836#44552#51228' '#49440#53469
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ImeMode = imSHanguel
            MaxLength = 50
            ParentFont = False
            ReadOnly = True
            TabOrder = 4
            Visible = True
          end
          object _ButtonProdPopup: TBitBtn
            Left = 476
            Top = 10
            Width = 30
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ImageIndex = 4
            ImageName = 'bowling_16px'
            Images = BPDM.imlIcon16
            ParentFont = False
            TabOrder = 5
          end
          object _EditGameCount: TNumberBox
            Left = 575
            Top = 11
            Width = 40
            Height = 27
            TabStop = False
            Alignment = taCenter
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 8
            Value = 1.000000000000000000
          end
          object _ButtonProdClear: TBitBtn
            Left = 507
            Top = 10
            Width = 30
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ImageIndex = 5
            ImageName = 'close_16px'
            Images = BPDM.imlIcon16
            ParentFont = False
            TabOrder = 6
          end
          object _ButtonMemberClear: TBitBtn
            Left = 326
            Top = 10
            Width = 30
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ImageIndex = 5
            ImageName = 'close_16px'
            Images = BPDM.imlIcon16
            ParentFont = False
            TabOrder = 3
          end
          object _ButtonRemoveBolwer: TButton
            Left = 978
            Top = 10
            Width = 30
            Height = 29
            DoubleBuffered = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ImageAlignment = iaCenter
            ImageIndex = 5
            ImageName = 'close_16px'
            Images = BPDM.imlIcon16
            ParentDoubleBuffered = False
            ParentFont = False
            TabOrder = 14
          end
          object TemplateAssignedPanel: TPanel
            Left = 1
            Top = 1
            Width = 5
            Height = 48
            Align = alLeft
            BevelOuter = bvNone
            Color = 16245041
            ParentBackground = False
            TabOrder = 15
            StyleElements = []
          end
          object _CheckboxShoesFree: TCheckBox
            Left = 815
            Top = 16
            Width = 45
            Height = 17
            Caption = #47924#47308
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 12
          end
          object _EditGameMin: TDBNumberEditEh
            Left = 694
            Top = 11
            Width = 60
            Height = 27
            TabStop = False
            ControlLabel.Font.Charset = DEFAULT_CHARSET
            ControlLabel.Font.Color = clWindowText
            ControlLabel.Font.Height = -12
            ControlLabel.Font.Name = 'Pretendard Variable'
            ControlLabel.Font.Style = []
            ControlLabel.ParentFont = False
            Alignment = taCenter
            AutoSize = False
            DecimalPlaces = 0
            DisplayFormat = ',0 '#48516
            DynProps = <>
            EditButtons = <>
            MaxValue = 600.000000000000000000
            ReadOnly = True
            TabOrder = 10
            Value = 0.000000000000000000
            Visible = True
          end
          object _EditMembershipName: TDBEditEh
            Left = 183
            Top = 11
            Width = 110
            Height = 27
            TabStop = False
            AutoSize = False
            ControlLabel.Font.Charset = DEFAULT_CHARSET
            ControlLabel.Font.Color = clWindowText
            ControlLabel.Font.Height = -12
            ControlLabel.Font.Name = 'Pretendard Variable'
            ControlLabel.Font.Style = []
            ControlLabel.ParentFont = False
            DynProps = <>
            EditButtons = <>
            EmptyDataInfo.Text = #54924#50896#44428' '#49440#53469
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ImeMode = imSHanguel
            MaxLength = 30
            ParentFont = False
            TabOrder = 1
            Visible = True
          end
        end
      end
      object panAssignListFooter: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 536
        Width = 1017
        Height = 40
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alBottom
        Alignment = taLeftJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object edtChargeAmtTotal: TDBNumberEditEh
          Left = 870
          Top = 6
          Width = 100
          Height = 27
          TabStop = False
          ControlLabel.Width = 69
          ControlLabel.Height = 18
          ControlLabel.Caption = #44208#51228#54624' '#44552#50529
          ControlLabel.Visible = True
          ControlLabelLocation.Position = lpLeftCenterEh
          AutoSize = False
          DecimalPlaces = 0
          DisplayFormat = ',0 '#50896
          DynProps = <>
          Enabled = False
          EditButtons = <>
          ReadOnly = True
          TabOrder = 2
          Value = 0.000000000000000000
          Visible = True
        end
        object edtUseGameMinTotal: TDBNumberEditEh
          Left = 694
          Top = 6
          Width = 60
          Height = 27
          TabStop = False
          ControlLabel.Width = 56
          ControlLabel.Height = 18
          ControlLabel.Caption = #51060#50857' '#49884#44036
          ControlLabel.Visible = True
          ControlLabelLocation.Position = lpLeftCenterEh
          Alignment = taCenter
          AutoSize = False
          DecimalPlaces = 0
          DisplayFormat = ',0 '#48516
          DynProps = <>
          Enabled = False
          EditButtons = <>
          ReadOnly = True
          TabOrder = 1
          Value = 0.000000000000000000
          Visible = True
        end
        object edtUseGameCountTotal: TDBNumberEditEh
          Left = 575
          Top = 6
          Width = 40
          Height = 27
          TabStop = False
          ControlLabel.Width = 124
          ControlLabel.Height = 18
          ControlLabel.Caption = #54633#44228' '#9654'  '#51060#50857' '#44172#51076' '#49688
          ControlLabel.Visible = True
          ControlLabelLocation.Position = lpLeftCenterEh
          Alignment = taCenter
          AutoSize = False
          DecimalPlaces = 0
          DisplayFormat = ',0'
          DynProps = <>
          Enabled = False
          EditButtons = <>
          ReadOnly = True
          TabOrder = 0
          Value = 0.000000000000000000
          Visible = True
        end
      end
    end
  end
end
