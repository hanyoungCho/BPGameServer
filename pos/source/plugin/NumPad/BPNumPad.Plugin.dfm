object BPNumPadForm: TBPNumPadForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 222
  ClientWidth = 205
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object btnNum7: TBitBtn
    Tag = 55
    Left = 4
    Top = 4
    Width = 46
    Height = 50
    Caption = '7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = OnNumPadButtonClick
  end
  object btnNum8: TBitBtn
    Tag = 56
    Left = 54
    Top = 4
    Width = 46
    Height = 50
    Caption = '8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = OnNumPadButtonClick
  end
  object btnNum9: TBitBtn
    Tag = 57
    Left = 104
    Top = 4
    Width = 46
    Height = 50
    Caption = '9'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = OnNumPadButtonClick
  end
  object btnNumBS: TBitBtn
    Tag = 8
    Left = 154
    Top = 4
    Width = 46
    Height = 50
    Caption = #172
    Font.Charset = SYMBOL_CHARSET
    Font.Color = 6856206
    Font.Height = -21
    Font.Name = 'Symbol'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    StyleElements = [seClient, seBorder]
    OnClick = OnNumPadButtonClick
  end
  object btnNumCL: TBitBtn
    Tag = 239
    Left = 154
    Top = 58
    Width = 46
    Height = 50
    Caption = 'CL'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 6856206
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    StyleElements = [seClient, seBorder]
    OnClick = OnNumPadButtonClick
  end
  object btnNum6: TBitBtn
    Tag = 54
    Left = 104
    Top = 58
    Width = 46
    Height = 50
    Caption = '6'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = OnNumPadButtonClick
  end
  object btnNum5: TBitBtn
    Tag = 53
    Left = 54
    Top = 58
    Width = 46
    Height = 50
    Caption = '5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = OnNumPadButtonClick
  end
  object btnNum4: TBitBtn
    Tag = 52
    Left = 4
    Top = 58
    Width = 46
    Height = 50
    Caption = '4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = OnNumPadButtonClick
  end
  object btnNum1: TBitBtn
    Tag = 49
    Left = 4
    Top = 112
    Width = 46
    Height = 50
    Caption = '1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = OnNumPadButtonClick
  end
  object btnNum2: TBitBtn
    Tag = 50
    Left = 54
    Top = 112
    Width = 46
    Height = 50
    Caption = '2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = OnNumPadButtonClick
  end
  object btnNum3: TBitBtn
    Tag = 51
    Left = 104
    Top = 112
    Width = 46
    Height = 50
    Caption = '3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = OnNumPadButtonClick
  end
  object btnNumCR: TBitBtn
    Tag = 13
    Left = 154
    Top = 112
    Width = 46
    Height = 104
    Caption = #191
    Font.Charset = SYMBOL_CHARSET
    Font.Color = 6856206
    Font.Height = -32
    Font.Name = 'Symbol'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    StyleElements = [seClient, seBorder]
    OnClick = OnNumPadButtonClick
  end
  object btnNum000: TBitBtn
    Tag = 48
    Left = 104
    Top = 166
    Width = 46
    Height = 50
    HelpContext = 3
    Caption = '000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = OnNumPadButtonClick
  end
  object btnNum00: TBitBtn
    Tag = 48
    Left = 54
    Top = 166
    Width = 46
    Height = 50
    HelpContext = 2
    Caption = '00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    OnClick = OnNumPadButtonClick
  end
  object btnNum0: TBitBtn
    Tag = 48
    Left = 4
    Top = 166
    Width = 46
    Height = 50
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    OnClick = OnNumPadButtonClick
  end
end
