object KisPosAgentForm: TKisPosAgentForm
  Left = 514
  Top = 309
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Kis'
  ClientHeight = 181
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object pnSingTitle: TPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 180
    Align = alTop
    BevelInner = bvLowered
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lbMessage: TLabel
      Left = 24
      Top = 16
      Width = 497
      Height = 105
      Alignment = taCenter
      AutoSize = False
      Caption = #54592#51077#47141' '#45824#44592#51473#51077#45768#45796'. '#51104#49884#47564' '#44592#45796#47140' '#51452#49884#44592' '#48148#46989#45768#45796'.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object btnCancel: TButton
      Left = 200
      Top = 135
      Width = 153
      Height = 36
      Caption = 'Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnCancelClick
    end
  end
  object KisPosAgent: TKisPosAgent
    Left = 24
    Top = 222
    Width = 100
    Height = 50
    TabOrder = 1
    OnApprovalEnd = KisPosAgentApprovalEnd
    ControlData = {00000100560A00002B05000000000000}
  end
end
