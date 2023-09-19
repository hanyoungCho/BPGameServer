object ExceptionDlg: TExceptionDlg
  Left = 310
  Top = 255
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'ExceptionDlg'
  ClientHeight = 480
  ClientWidth = 640
  Color = clBtnFace
  Constraints.MinWidth = 200
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    640
    480)
  TextHeight = 14
  object BevelDetails: TBevel
    Left = 8
    Top = 186
    Width = 624
    Height = 4
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object btnMailSend: TButton
    Left = 532
    Top = 73
    Width = 100
    Height = 23
    Hint = #44592#48376' '#47700#51068' '#53364#46972#51060#50616#53944#47196' '#48260#44536' '#47532#54252#53944#47484' '#47700#51068#47196' '#51204#49569#54616#44592
    Anchors = [akTop, akRight]
    Caption = #47700#51068' '#51204#49569
    TabOrder = 6
    OnClick = btnMailSendClick
  end
  object btnSaveToFile: TButton
    Left = 532
    Top = 100
    Width = 100
    Height = 23
    Hint = #48260#44536' '#47532#54252#53944#47484' '#54028#51068#47196' '#51200#51109#54616#44592
    Anchors = [akTop, akRight]
    Caption = #54028#51068' '#51200#51109
    TabOrder = 1
    OnClick = btnSaveToFileClick
  end
  object btnOK: TButton
    Left = 532
    Top = 46
    Width = 100
    Height = 23
    Anchors = [akTop, akRight]
    Caption = #54869#51064
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnDetail: TButton
    Left = 532
    Top = 127
    Width = 100
    Height = 23
    Hint = #49345#49464' '#51221#48372' '#48372#51060#44592'/'#44048#52628#44592
    Anchors = [akTop, akRight]
    Caption = #49345#49464' '#48372#44592
    Enabled = False
    TabOrder = 3
    OnClick = btnDetailClick
  end
  object mmoDetail: TMemo
    Left = 8
    Top = 196
    Width = 624
    Height = 278
    Hint = 'Ctrl+C '#47484' '#51060#50857#54616#50668' '#53364#47549#48372#46300#47196' '#48373#49324
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 5
    WantReturns = False
    WordWrap = False
  end
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #49884#49828#53596' '#51109#50528' '#44288#47532
    Color = 3305471
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 7
    StyleElements = []
    OnMouseMove = panHeaderMouseMove
    object panHeaderToolbar: TPanel
      AlignWithMargins = True
      Left = 605
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
        Images = BPDM.imlIcon32
        Flat = True
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
        StyleElements = []
        ExplicitTop = 2
      end
    end
  end
  object mmoText: TMemo
    Left = 62
    Top = 46
    Width = 464
    Height = 131
    Hint = 'Ctrl+C '#47484' '#51060#50857#54616#50668' '#53364#47549#48372#46300#47196' '#48373#49324#13#10
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnTerminate: TButton
    Left = 532
    Top = 154
    Width = 100
    Height = 23
    Hint = #49345#49464' '#51221#48372' '#48372#51060#44592'/'#44048#52628#44592
    Anchors = [akTop, akRight]
    Caption = #44053#51228' '#51333#47308
    TabOrder = 4
    OnClick = btnTerminateClick
  end
end
