object BPZipCodeForm: TBPZipCodeForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'BPZipCodeForm'
  ClientHeight = 538
  ClientWidth = 517
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 18
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 517
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #50864#54200#48264#54840' '#44160#49353
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
    object panHeaderToolbar: TPanel
      AlignWithMargins = True
      Left = 482
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
        ImageName = 'Close_W_32px'
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        OnClick = btnCloseClick
        ExplicitTop = -3
      end
    end
  end
  object WB: TEdgeBrowser
    Left = 0
    Top = 38
    Width = 517
    Height = 500
    Align = alClient
    TabOrder = 1
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    ExplicitTop = 41
  end
end
