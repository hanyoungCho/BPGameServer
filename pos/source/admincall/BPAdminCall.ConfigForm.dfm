object ConfigForm: TConfigForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = ' BowlingPick '#50508#47532#48120
  ClientHeight = 461
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #44404#47548
  Font.Style = []
  Position = poDesigned
  OnClose = FormClose
  TextHeight = 15
  object lbxLogView: TListBox
    Left = 0
    Top = 40
    Width = 784
    Height = 421
    Align = alClient
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 40
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 65
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = #49436#48260#54252#53944
      Layout = tlCenter
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 155
      Top = 6
      Width = 70
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = #54045#50629' '#45432#52636
      Layout = tlCenter
    end
    object Label3: TLabel
      AlignWithMargins = True
      Left = 309
      Top = 6
      Width = 40
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      AutoSize = False
      Caption = '('#52488')'
      Layout = tlCenter
      ExplicitLeft = 304
    end
    object edtServerPort: TcxSpinEdit
      AlignWithMargins = True
      Left = 76
      Top = 6
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      Properties.Alignment.Horz = taCenter
      Properties.UseLeftAlignmentOnEditing = False
      TabOrder = 0
      Width = 74
    end
    object ckbNotifyWithSound: TcxCheckBox
      AlignWithMargins = True
      Left = 442
      Top = 6
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      Caption = #50508#47548#51020' '#51116#49373
      Style.TransparentBorder = False
      TabOrder = 3
    end
    object btnSaveLog: TcxButton
      AlignWithMargins = True
      Left = 593
      Top = 6
      Width = 90
      Height = 28
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = #47196#44536' '#51200#51109
      TabOrder = 4
      OnClick = btnSaveLogClick
    end
    object btnApply: TcxButton
      AlignWithMargins = True
      Left = 688
      Top = 6
      Width = 90
      Height = 28
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = #49444#51221' '#51201#50857
      TabOrder = 5
      OnClick = btnApplyClick
    end
    object ckbNotifyWithPopup: TcxCheckBox
      AlignWithMargins = True
      Left = 354
      Top = 6
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      Caption = #54045#50629' '#50508#47548
      Style.TransparentBorder = False
      TabOrder = 2
    end
    object edtNotifyDuration: TcxSpinEdit
      AlignWithMargins = True
      Left = 230
      Top = 6
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alLeft
      ParentShowHint = False
      Properties.Alignment.Horz = taCenter
      Properties.UseLeftAlignmentOnEditing = False
      ShowHint = True
      TabOrder = 1
      Width = 74
    end
  end
end
