object BPMsgBoxForm: TBPMsgBoxForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'BPMsgBoxForm'
  ClientHeight = 300
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 18
  object lblTimeOut: TLabel
    Left = 164
    Top = 198
    Width = 272
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = '(0'#52488' '#54980' '#51060' '#47700#49884#51648' '#52285#51012' '#45803#51020')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 33023
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Visible = False
    StyleElements = []
  end
  object lblHtmlText: TDzHTMLText
    Left = 20
    Top = 58
    Width = 560
    Height = 125
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    Lines.Strings = (
      '<FC:$000000FF><B>Message</B></FC> Text'
      'HELLO!')
    OverallVertAlign = vaCenter
    OverallHorzAlign = haCenter
  end
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #50508#47548
    Color = 9857565
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
    object btnClose: TSpeedButton
      AlignWithMargins = True
      Left = 565
      Top = 3
      Width = 32
      Height = 32
      Hint = #45803#44592
      Align = alRight
      ImageIndex = 3
      Images = BPDM.imlIcon32
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      StyleElements = []
      OnClick = btnCloseClick
      ExplicitLeft = 8
      ExplicitTop = 0
      ExplicitHeight = 38
    end
  end
  object panButtonSet: TPanel
    Left = 45
    Top = 220
    Width = 510
    Height = 56
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object btnAll: TBitBtn
      AlignWithMargins = True
      Left = 411
      Top = 3
      Width = 96
      Height = 50
      Align = alLeft
      Caption = '&All'
      NumGlyphs = 2
      TabOrder = 4
      OnClick = btnAllClick
    end
    object btnNo: TBitBtn
      AlignWithMargins = True
      Left = 309
      Top = 3
      Width = 96
      Height = 50
      Align = alLeft
      Cancel = True
      Caption = '&No'
      NumGlyphs = 2
      TabOrder = 3
      OnClick = btnNoClick
    end
    object btnYes: TBitBtn
      AlignWithMargins = True
      Left = 207
      Top = 3
      Width = 96
      Height = 50
      Align = alLeft
      Caption = '&Yes'
      NumGlyphs = 2
      TabOrder = 2
      OnClick = btnYesClick
    end
    object btnCancel: TBitBtn
      AlignWithMargins = True
      Left = 105
      Top = 3
      Width = 96
      Height = 50
      Align = alLeft
      Cancel = True
      Caption = 'Cancel'
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOK: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 96
      Height = 50
      Align = alLeft
      Caption = 'OK'
      Default = True
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object tmrAutoCloser: TTimer
    Enabled = False
    OnTimer = tmrAutoCloserTimer
    Left = 72
    Top = 80
  end
end
