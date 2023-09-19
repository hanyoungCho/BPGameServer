object BPInputStartDateForm: TBPInputStartDateForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'BPInputStartDateForm'
  ClientHeight = 540
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 18
  object panInput: TPanel
    Left = 0
    Top = 38
    Width = 450
    Height = 502
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lblProdNameTitle: TLabel
      Left = 48
      Top = 30
      Width = 66
      Height = 31
      AutoSize = False
      Caption = #49345#54408#47749' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -21
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlCenter
    end
    object lblProdName: TLabel
      Left = 120
      Top = 30
      Width = 281
      Height = 31
      AutoSize = False
      Caption = '***'
      EllipsisPosition = epEndEllipsis
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4473924
      Font.Height = -21
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlCenter
    end
    object btnOK: TBitBtn
      Tag = 106
      Left = 177
      Top = 421
      Width = 96
      Height = 50
      Caption = #54869#51064
      ModalResult = 1
      ParentDoubleBuffered = True
      TabOrder = 0
    end
    object btnCancel: TBitBtn
      Tag = 106
      Left = 279
      Top = 421
      Width = 96
      Height = 50
      Caption = #52712#49548
      ModalResult = 2
      ParentDoubleBuffered = True
      TabOrder = 1
    end
    object CV: TCalendarView
      Left = 48
      Top = 80
      Width = 353
      Height = 313
      Date = 45087.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      HeaderInfo.DaysOfWeekFont.Charset = DEFAULT_CHARSET
      HeaderInfo.DaysOfWeekFont.Color = clWindowText
      HeaderInfo.DaysOfWeekFont.Height = -13
      HeaderInfo.DaysOfWeekFont.Name = 'Segoe UI'
      HeaderInfo.DaysOfWeekFont.Style = []
      HeaderInfo.Font.Charset = DEFAULT_CHARSET
      HeaderInfo.Font.Color = clWindowText
      HeaderInfo.Font.Height = -20
      HeaderInfo.Font.Name = 'Segoe UI'
      HeaderInfo.Font.Style = []
      OnChange = CVChange
      ParentFont = False
      TabOrder = 3
    end
    object btnToday: TBitBtn
      Tag = 106
      Left = 75
      Top = 421
      Width = 96
      Height = 50
      Caption = #50724#45720
      ParentDoubleBuffered = True
      TabOrder = 2
      OnClick = btnTodayClick
    end
  end
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #51060#50857' '#49884#51089#51068
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
    object btnClose: TSpeedButton
      AlignWithMargins = True
      Left = 415
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
end
