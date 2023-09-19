object BPWebViewPopupForm: TBPWebViewPopupForm
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
    Caption = #50937' '#48652#46972#50864#51200
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    StyleElements = []
    OnMouseMove = panHeaderMouseMove
    object panNavigator: TPanel
      AlignWithMargins = True
      Left = 605
      Top = 3
      Width = 160
      Height = 32
      Margins.Right = 0
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 2
      StyleElements = []
      object btnStop: TSpeedButton
        Left = 96
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 55
        ImageName = 'unchecked_checkbox_W_32px'
        Images = BPDM.imlIcon32
        Enabled = False
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        StyleElements = []
        OnClick = btnStopClick
        ExplicitLeft = 102
        ExplicitTop = -2
      end
      object btnRefresh: TSpeedButton
        Left = 64
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 41
        ImageName = 'Refresh_W_32px'
        Images = BPDM.imlIcon32
        Enabled = False
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        StyleElements = []
        OnClick = btnRefreshClick
        ExplicitLeft = 56
        ExplicitTop = -2
      end
      object btnHome: TSpeedButton
        Left = 128
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 42
        ImageName = 'Home_W_32px'
        Images = BPDM.imlIcon32
        Enabled = False
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        StyleElements = []
        OnClick = btnHomeClick
        ExplicitLeft = 134
        ExplicitTop = -3
      end
      object btnForward: TSpeedButton
        Left = 32
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 40
        ImageName = 'Right_W_32px'
        Images = BPDM.imlIcon32
        Enabled = False
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        StyleElements = []
        OnClick = btnForwardClick
        ExplicitLeft = 8
      end
      object btnBack: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 39
        ImageName = 'Left_W_32px'
        Images = BPDM.imlIcon32
        Enabled = False
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        StyleElements = []
        OnClick = btnBackClick
        ExplicitLeft = 8
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
      TabOrder = 0
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
    object ckbNoMoreToday: TCheckBox
      Left = 38
      Top = 0
      Width = 97
      Height = 38
      Align = alLeft
      Caption = #50724#45720#51008' '#44536#47564' '#48372#44592
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      StyleElements = [seClient, seBorder]
      OnClick = ckbNoMoreTodayClick
    end
    object panClose: TPanel
      AlignWithMargins = True
      Left = 765
      Top = 3
      Width = 32
      Height = 32
      Margins.Left = 0
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 3
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
        ExplicitLeft = 8
        ExplicitTop = -3
      end
    end
  end
  object WB: TEdgeBrowser
    Left = 0
    Top = 38
    Width = 800
    Height = 562
    Align = alClient
    TabOrder = 0
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnCreateWebViewCompleted = WBCreateWebViewCompleted
  end
  object tmrRunOnce: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrRunOnceTimer
    Left = 80
    Top = 136
  end
end
