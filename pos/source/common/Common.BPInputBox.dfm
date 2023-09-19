object BPInputBoxForm: TBPInputBoxForm
  Left = 192
  Top = 108
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 300
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object lblMessage: TLabel
    Left = 38
    Top = 73
    Width = 524
    Height = 83
    Alignment = taCenter
    AutoSize = False
    Caption = #47700#49884#51648' '#52636#47141' '#50689#50669
    Color = clWhite
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    WordWrap = True
  end
  object panButtonSet: TPanel
    Left = 184
    Top = 220
    Width = 232
    Height = 56
    AutoSize = True
    BevelOuter = bvNone
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentBackground = False
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 1
    object btnOK: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 50
      Caption = #54869#51064
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TBitBtn
      AlignWithMargins = True
      Left = 119
      Top = 3
      Width = 110
      Height = 50
      Caption = #52712#49548
      ModalResult = 2
      TabOrder = 1
    end
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
    Caption = #51077#47141
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
      ExplicitLeft = 568
      ExplicitTop = 6
    end
  end
  object edtInputText: TEdit
    Left = 150
    Top = 168
    Width = 300
    Height = 36
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ImeMode = imSAlpha
    ParentFont = False
    TabOrder = 0
    OnKeyPress = edtInputTextKeyPress
  end
end
