object PaycoRevForm: TPaycoRevForm
  Left = 92
  Top = 147
  BorderStyle = bsNone
  Caption = 'PaycoRevForm'
  ClientHeight = 552
  ClientWidth = 816
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  Visible = True
  OnShow = FormShow
  TextHeight = 13
  object pnSingTitle: TPanel
    Left = 0
    Top = 0
    Width = 816
    Height = 552
    Align = alClient
    BevelInner = bvLowered
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    Visible = False
    ExplicitWidth = 800
    ExplicitHeight = 500
    object lbMessage: TLabel
      Left = 82
      Top = 112
      Width = 639
      Height = 60
      Alignment = taCenter
      AutoSize = False
      Caption = #52376#47532' '#51473#51077#45768#45796'.  '#51104#49884#47564' '#44592#45796#47140' '#51452#49884#44592' '#48148#46989#45768#45796'.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -27
      Font.Name = #45208#45588#44256#46357' ExtraBold'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      Visible = False
      WordWrap = True
    end
    object Label1: TLabel
      Left = 82
      Top = 182
      Width = 639
      Height = 60
      Alignment = taCenter
      AutoSize = False
      Caption = 'Processing your request, please wait a moment.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -27
      Font.Name = #45208#45588#44256#46357' ExtraBold'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      Visible = False
      WordWrap = True
    end
    object Panel1: TPanel
      Left = 277
      Top = 328
      Width = 268
      Height = 101
      Caption = #52712#49548'(Cancel)'
      Color = 1125440
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -40
      Font.Name = #45208#45588#44256#46357' ExtraBold'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
  end
end
