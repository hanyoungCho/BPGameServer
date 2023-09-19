object BPCalendarForm: TBPCalendarForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 500
  ClientWidth = 400
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
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 38
    Cursor = crHandPoint
    Align = alTop
    BevelOuter = bvNone
    Caption = #45216#51676' '#49440#53469
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
    object btnClose: TSpeedButton
      AlignWithMargins = True
      Left = 365
      Top = 3
      Width = 32
      Height = 32
      Hint = #45803#44592
      Align = alRight
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
      ParentShowHint = False
      ShowHint = True
      StyleElements = []
      OnClick = btnCloseClick
      ExplicitLeft = 8
      ExplicitTop = 0
      ExplicitHeight = 38
    end
  end
  object panBody: TPanel
    Left = 0
    Top = 38
    Width = 400
    Height = 462
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object CalendarView: TCalendarView
      Left = 23
      Top = 38
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
      OnChange = CalendarViewChange
      OnDblClick = CalendarViewDblClick
      ParentFont = False
      TabOrder = 3
    end
    object btnToday: TBitBtn
      Tag = 106
      Left = 50
      Top = 373
      Width = 96
      Height = 50
      Caption = #50724#45720
      ParentDoubleBuffered = True
      TabOrder = 2
      OnClick = btnTodayClick
    end
    object btnOK: TBitBtn
      Tag = 106
      Left = 152
      Top = 373
      Width = 96
      Height = 50
      Caption = #54869#51064
      Default = True
      ModalResult = 1
      ParentDoubleBuffered = True
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Tag = 106
      Left = 254
      Top = 373
      Width = 96
      Height = 50
      Caption = #52712#49548
      ModalResult = 2
      ParentDoubleBuffered = True
      TabOrder = 1
    end
  end
end
