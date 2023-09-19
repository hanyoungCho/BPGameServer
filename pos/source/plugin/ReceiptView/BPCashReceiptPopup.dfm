object BPCashReceiptPopupForm: TBPCashReceiptPopupForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #54788#44552#50689#49688#51613' '#48156#54665
  ClientHeight = 280
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
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
    Caption = #54788#44552#50689#49688#51613' '#48156#54665
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
  object panBody: TPanel
    Left = 0
    Top = 38
    Width = 450
    Height = 242
    Align = alClient
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 53
      Top = 34
      Width = 56
      Height = 18
      Caption = #48156#44553' '#44396#48516
    end
    object btnEntityPerson: TSpeedButton
      Tag = 1
      Left = 53
      Top = 56
      Width = 60
      Height = 43
      GroupIndex = 100
      Down = True
      Caption = #44060#51064
      OnClick = OnCashEntityButtonClick
    end
    object btnEntityBiz: TSpeedButton
      Tag = 2
      Left = 110
      Top = 56
      Width = 60
      Height = 43
      GroupIndex = 100
      Caption = #49324#50629#51088
      OnClick = OnCashEntityButtonClick
    end
    object btnOK: TBitBtn
      Tag = 106
      Left = 126
      Top = 158
      Width = 96
      Height = 50
      Caption = #49849#51064' '#50836#52397
      ModalResult = 1
      ParentDoubleBuffered = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TBitBtn
      Tag = 106
      Left = 228
      Top = 158
      Width = 96
      Height = 50
      Caption = #52712#49548
      ModalResult = 2
      ParentDoubleBuffered = True
      TabOrder = 1
    end
    object ckbSelfCashReceipt: TCheckBox
      AlignWithMargins = True
      Left = 126
      Top = 122
      Width = 185
      Height = 30
      Margins.Left = 15
      Margins.Right = 15
      Caption = #54788#44552#50689#49688#51613' '#51088#51652' '#48156#44553' (F11)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      StyleElements = [seClient, seBorder]
    end
    object edtCashAmount: TDBNumberEditEh
      Left = 198
      Top = 56
      Width = 200
      Height = 43
      ControlLabel.Width = 113
      ControlLabel.Height = 18
      ControlLabel.Caption = #48156#54665' '#45824#49345' '#44552#50529' ('#50896')'
      ControlLabel.Visible = True
      ControlLabelLocation.Position = lpAboveRightEh
      DecimalPlaces = 0
      DisplayFormat = ',0'
      DynProps = <>
      EditButtons = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16744448
      Font.Height = -29
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      StyleElements = [seBorder]
      TabOrder = 3
      Value = 0.000000000000000000
      Visible = True
    end
  end
end
