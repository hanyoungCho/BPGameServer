object BPMonitorForm: TBPMonitorForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'BPMonitor'
  ClientHeight = 1080
  ClientWidth = 1920
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 18
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 1920
    Height = 1080
    ActivePage = tabScoreboard
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    Style = tsFlatButtons
    TabOrder = 0
    object tabReady: TTabSheet
      Caption = #45824#44592#54868#47732
      object imgLogo: TImage
        Left = 0
        Top = 0
        Width = 1912
        Height = 1044
        Align = alClient
        Center = True
        Proportional = True
      end
    end
    object tabScoreboard: TTabSheet
      Caption = #49828#53076#50612#48372#46300
      ImageIndex = 1
      object panScoreFooter: TPanel
        Left = 0
        Top = 867
        Width = 1912
        Height = 177
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object StyledButton1: TStyledButton
          Left = 21
          Top = 24
          Width = 125
          Height = 57
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          Caption = #53580#49828#53944
          StyleRadius = 20
          StyleDrawType = btRounded
          StyleFamily = 'Bootstrap'
          StyleAppearance = 'Outline'
          ButtonStyleNormal.DrawType = btRounded
          ButtonStyleNormal.BorderWidth = 1
          ButtonStyleNormal.ButtonDrawStyle = btnClear
          ButtonStyleNormal.BorderColor = 16693126
          ButtonStyleNormal.FontColor = 16608781
          ButtonStyleNormal.FontStyle = [fsBold]
          ButtonStyleNormal.ButtonColor = 4535772
          ButtonStyleNormal.Radius = 6
          ButtonStylePressed.DrawType = btRounded
          ButtonStylePressed.BorderWidth = 1
          ButtonStylePressed.BorderColor = 16693126
          ButtonStylePressed.FontColor = clWhite
          ButtonStylePressed.FontStyle = [fsBold]
          ButtonStylePressed.ButtonColor = 16608781
          ButtonStylePressed.Radius = 6
          ButtonStyleSelected.DrawType = btRounded
          ButtonStyleSelected.BorderWidth = 1
          ButtonStyleSelected.ButtonDrawStyle = btnClear
          ButtonStyleSelected.BorderColor = 16693126
          ButtonStyleSelected.FontColor = 16608781
          ButtonStyleSelected.FontStyle = [fsBold]
          ButtonStyleSelected.ButtonColor = 4535772
          ButtonStyleSelected.Radius = 6
          ButtonStyleHot.DrawType = btRounded
          ButtonStyleHot.BorderWidth = 1
          ButtonStyleHot.BorderDrawStyle = brdClear
          ButtonStyleHot.BorderColor = 16693126
          ButtonStyleHot.FontColor = clWhite
          ButtonStyleHot.FontStyle = [fsBold]
          ButtonStyleHot.ButtonColor = 16608781
          ButtonStyleHot.Radius = 6
          TabOrder = 0
        end
      end
      object panScoreBody: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 181
        Width = 1896
        Height = 430
        AutoSize = True
        BevelOuter = bvNone
        Color = clBlack
        ParentBackground = False
        TabOrder = 1
        object panFrameHeader: TPanel
          Left = 0
          Top = 0
          Width = 1896
          Height = 60
          Align = alTop
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentBackground = False
          ParentColor = True
          ParentFont = False
          TabOrder = 0
          object panFrameHeaderLaneNo10: TPanel
            AlignWithMargins = True
            Left = 1547
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '10'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 0
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo9: TPanel
            AlignWithMargins = True
            Left = 1406
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '9'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 1
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo8: TPanel
            AlignWithMargins = True
            Left = 1265
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 2
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo7: TPanel
            AlignWithMargins = True
            Left = 1124
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '7'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 3
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo6: TPanel
            AlignWithMargins = True
            Left = 983
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '6'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 4
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo5: TPanel
            AlignWithMargins = True
            Left = 842
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '5'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 5
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo4: TPanel
            AlignWithMargins = True
            Left = 701
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 6
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo3: TPanel
            AlignWithMargins = True
            Left = 560
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '3'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 7
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo2: TPanel
            AlignWithMargins = True
            Left = 419
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 8
            StyleElements = [seBorder]
          end
          object panFrameHeaderLaneNo1: TPanel
            AlignWithMargins = True
            Left = 278
            Top = 0
            Width = 140
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = '1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 9
          end
          object panFrameHeaderGameNo: TPanel
            AlignWithMargins = True
            Left = 1
            Top = 0
            Width = 276
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Caption = 'GAME 1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 10
            StyleElements = [seBorder]
          end
          object panFrameHeaderTotal: TPanel
            AlignWithMargins = True
            Left = 1688
            Top = 0
            Width = 208
            Height = 60
            Margins.Left = 1
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelOuter = bvNone
            Caption = 'TOTAL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -43
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 11
            StyleElements = [seBorder]
          end
        end
        object TemplateGamePanel2: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 221
          Width = 1896
          Height = 204
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alTop
          BevelOuter = bvNone
          Color = clBlack
          ParentBackground = False
          TabOrder = 1
          object TemplateBowlerPanel2: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 276
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -32
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            StyleElements = [seBorder]
            object TemplateBowlerNameLabel2: TLabel
              AlignWithMargins = True
              Left = 10
              Top = 104
              Width = 256
              Height = 95
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 10
              Margins.Bottom = 5
              Align = alClient
              AutoSize = False
              Caption = #50508#47113#49328#46300#46972#44032
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -59
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              Transparent = False
              Layout = tlCenter
              ExplicitLeft = 0
              ExplicitTop = 75
              ExplicitWidth = 280
              ExplicitHeight = 65
            end
            object TemplateStatusPanel2: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 5
              Width = 256
              Height = 94
              Margins.Left = 10
              Margins.Top = 5
              Margins.Right = 10
              Margins.Bottom = 5
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object TemplateRentShoesIcon2: TSVGIconImage
                AlignWithMargins = True
                Left = 105
                Top = 0
                Width = 56
                Height = 94
                Margins.Left = 0
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 1
                ImageName = 'Shoes-rental'
                Align = alRight
              end
              object TemplateUserIcon2: TSVGIconImage
                AlignWithMargins = True
                Left = 166
                Top = 0
                Width = 90
                Height = 94
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 2
                ImageName = 'Subtract'
                Align = alRight
              end
              object TemplateDirectionIcon2: TSVGIconImage
                AlignWithMargins = True
                Left = 0
                Top = 0
                Width = 72
                Height = 94
                Margins.Left = 0
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 7
                ImageName = 'Left_1'
                Align = alLeft
              end
            end
          end
          object Panel16: TPanel
            AlignWithMargins = True
            Left = 1546
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 1
            StyleElements = [seBorder]
            object Panel17: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel18: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel19: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel20: TPanel
            AlignWithMargins = True
            Left = 1405
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 2
            StyleElements = [seBorder]
            object Panel21: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel22: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel23: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel24: TPanel
            AlignWithMargins = True
            Left = 1264
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 3
            StyleElements = [seBorder]
            object Panel25: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel26: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel27: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel28: TPanel
            AlignWithMargins = True
            Left = 1123
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 4
            StyleElements = [seBorder]
            object Panel29: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel30: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel31: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel32: TPanel
            AlignWithMargins = True
            Left = 982
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 5
            StyleElements = [seBorder]
            object Panel33: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel34: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel35: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel36: TPanel
            AlignWithMargins = True
            Left = 841
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 6
            StyleElements = [seBorder]
            object Panel37: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel38: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel39: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel40: TPanel
            AlignWithMargins = True
            Left = 700
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 7
            StyleElements = [seBorder]
            object Panel41: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel42: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel43: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel44: TPanel
            AlignWithMargins = True
            Left = 559
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 8
            StyleElements = [seBorder]
            object Panel45: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Caption = '8'
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
              object SVGIconImage3: TSVGIconImage
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 60
                Height = 93
                Margins.Left = 5
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 5
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 14
                ImageName = 'Split'
                Align = alClient
              end
            end
            object Panel46: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel47: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel48: TPanel
            AlignWithMargins = True
            Left = 418
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 9
            StyleElements = [seBorder]
            object Panel49: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Caption = '7'
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel50: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
              object SVGIconImage2: TSVGIconImage
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 59
                Height = 93
                Margins.Left = 5
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 5
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 13
                ImageName = 'Spare'
                Align = alClient
              end
            end
            object Panel51: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Caption = '38'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel52: TPanel
            AlignWithMargins = True
            Left = 277
            Top = 0
            Width = 140
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 10500861
            ParentBackground = False
            TabOrder = 10
            object Panel53: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
              object SVGIconImage4: TSVGIconImage
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 60
                Height = 93
                Margins.Left = 5
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 5
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 11
                ImageName = 'Strike'
                Align = alClient
              end
            end
            object Panel54: TPanel
              Left = 0
              Top = 104
              Width = 140
              Height = 100
              Align = alBottom
              BevelOuter = bvNone
              Caption = '20'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel2: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 103
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16442367
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object TemplateTotalPanel2: TPanel
            Left = 1687
            Top = 0
            Width = 209
            Height = 204
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelOuter = bvNone
            Caption = '38'
            Color = 10500861
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -59
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 11
            StyleElements = [seBorder]
          end
        end
        object TemplateGamePanel1: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 70
          Width = 1896
          Height = 136
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alTop
          BevelOuter = bvNone
          Color = clBlack
          ParentBackground = False
          TabOrder = 2
          object TemplateBowlerPanel1: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 276
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -32
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            StyleElements = [seBorder]
            object TemplateBowlerNameLabel1: TLabel
              AlignWithMargins = True
              Left = 10
              Top = 70
              Width = 256
              Height = 61
              Margins.Left = 10
              Margins.Top = 5
              Margins.Right = 10
              Margins.Bottom = 5
              Align = alClient
              AutoSize = False
              Caption = '04A'
              EllipsisPosition = epEndEllipsis
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -59
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              Transparent = False
              Layout = tlCenter
              ExplicitTop = 76
              ExplicitHeight = 65
            end
            object TemplateStatusPanel1: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 5
              Width = 256
              Height = 60
              Margins.Left = 10
              Margins.Top = 5
              Margins.Right = 10
              Margins.Bottom = 0
              Align = alTop
              BevelOuter = bvNone
              ParentBackground = False
              ParentColor = True
              TabOrder = 0
              object TemplateRentShoesIcon1: TSVGIconImage
                AlignWithMargins = True
                Left = 139
                Top = 0
                Width = 56
                Height = 60
                Margins.Left = 0
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 1
                ImageName = 'Shoes-rental'
                Align = alRight
              end
              object TemplateUserIcon1: TSVGIconImage
                AlignWithMargins = True
                Left = 200
                Top = 0
                Width = 56
                Height = 60
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 0
                ImageName = 'Default'
                Align = alRight
              end
              object TemplateDirectionIcon1: TSVGIconImage
                AlignWithMargins = True
                Left = 0
                Top = 0
                Width = 72
                Height = 60
                Margins.Left = 0
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                AutoSize = False
                ImageList = imlSvgRes
                Align = alLeft
              end
            end
          end
          object Panel58: TPanel
            AlignWithMargins = True
            Left = 1546
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 1
            StyleElements = [seBorder]
            object Panel59: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel60: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel61: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel62: TPanel
            AlignWithMargins = True
            Left = 1405
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 2
            StyleElements = [seBorder]
            object Panel63: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel64: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel65: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel66: TPanel
            AlignWithMargins = True
            Left = 1264
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 3
            StyleElements = [seBorder]
            object Panel67: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel68: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel69: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel70: TPanel
            AlignWithMargins = True
            Left = 1123
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 4
            StyleElements = [seBorder]
            object Panel71: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel72: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel73: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel74: TPanel
            AlignWithMargins = True
            Left = 982
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 5
            StyleElements = [seBorder]
            object Panel75: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel76: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel77: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel78: TPanel
            AlignWithMargins = True
            Left = 841
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 6
            StyleElements = [seBorder]
            object Panel79: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel80: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel81: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel82: TPanel
            AlignWithMargins = True
            Left = 700
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 7
            StyleElements = [seBorder]
            object Panel83: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel84: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel85: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel86: TPanel
            AlignWithMargins = True
            Left = 559
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 8
            StyleElements = [seBorder]
            object Panel87: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Caption = '5'
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel88: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Caption = '3'
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel89: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Caption = '38'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object Panel90: TPanel
            AlignWithMargins = True
            Left = 418
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 9
            StyleElements = [seBorder]
            object Panel91: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Caption = '8'
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
            end
            object Panel93: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Caption = '35'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel1: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
              object SVGIconImage1: TSVGIconImage
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 59
                Height = 60
                Margins.Left = 5
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 5
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 13
                ImageName = 'Spare'
                Align = alClient
              end
            end
          end
          object Panel94: TPanel
            AlignWithMargins = True
            Left = 277
            Top = 0
            Width = 140
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = 16078141
            ParentBackground = False
            TabOrder = 10
            object Panel95: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 70
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 1
              Margins.Bottom = 1
              Align = alLeft
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              StyleElements = [seBorder]
              object SVGIconImage8: TSVGIconImage
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 60
                Height = 60
                Margins.Left = 5
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 5
                AutoSize = False
                ImageList = imlSvgRes
                ImageIndex = 11
                ImageName = 'Strike'
                Align = alClient
              end
            end
            object Panel97: TPanel
              Left = 0
              Top = 71
              Width = 140
              Height = 65
              Align = alBottom
              BevelOuter = bvNone
              Caption = '20'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -53
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentBackground = False
              ParentColor = True
              ParentFont = False
              TabOrder = 1
              StyleElements = [seBorder]
            end
            object Panel98: TPanel
              AlignWithMargins = True
              Left = 71
              Top = 0
              Width = 69
              Height = 70
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alClient
              BevelOuter = bvNone
              Color = 16767958
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -43
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 2
              StyleElements = [seBorder]
            end
          end
          object TemplateTotalPanel1: TPanel
            Left = 1687
            Top = 0
            Width = 209
            Height = 136
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelOuter = bvNone
            Caption = '38'
            Color = 16078141
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -59
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 11
            StyleElements = [seBorder]
          end
        end
      end
    end
    object tabPinResult: TTabSheet
      Margins.Left = 5
      Caption = #54592#49345#53468
      ImageIndex = 2
      object imgPinBase: TVirtualImage
        Left = 0
        Top = 0
        Width = 1920
        Height = 1080
        ImageCollection = imcSvgRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 17
        ImageName = 'Pin-base'
        Proportional = False
      end
      object imgPin7: TVirtualImage
        Left = 327
        Top = 14
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin8: TVirtualImage
        Left = 696
        Top = 14
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin9: TVirtualImage
        Left = 1066
        Top = 14
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin10: TVirtualImage
        Left = 1437
        Top = 14
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin4: TVirtualImage
        Left = 513
        Top = 190
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin5: TVirtualImage
        Left = 882
        Top = 190
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin6: TVirtualImage
        Left = 1251
        Top = 190
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin2: TVirtualImage
        Left = 696
        Top = 373
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin3: TVirtualImage
        Left = 1066
        Top = 373
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPin1: TVirtualImage
        Left = 882
        Top = 558
        Width = 156
        Height = 410
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 1
        ImageName = 'img_pin'
        Proportional = False
      end
      object imgPinArrow: TVirtualImage
        Left = 476
        Top = 764
        Width = 230
        Height = 252
        ImageCollection = imcPngRes
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 2
        ImageName = 'Img-arrow'
        Proportional = False
      end
      object lblPinNo1: TLabel
        Left = 900
        Top = 790
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo2: TLabel
        Left = 714
        Top = 606
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo3: TLabel
        Left = 1084
        Top = 606
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo4: TLabel
        Left = 531
        Top = 422
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo5: TLabel
        Left = 900
        Top = 422
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo6: TLabel
        Left = 1269
        Top = 422
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo7: TLabel
        Left = 345
        Top = 246
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo8: TLabel
        Left = 714
        Top = 246
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo9: TLabel
        Left = 1084
        Top = 246
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '9'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lblPinNo10: TLabel
        Left = 1455
        Top = 246
        Width = 120
        Height = 120
        Alignment = taCenter
        AutoSize = False
        Caption = '10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -96
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
    end
    object tabMediaPlay: TTabSheet
      Caption = #48120#46356#50612#54540#47112#51060
      ImageIndex = 3
      object VideoGrabber: TVideoGrabber
        Left = 0
        Top = 0
        Width = 1912
        Height = 1044
        Align = alClient
        Color = clBlack
        AspectRatioToUse = -1.000000000000000000
        AudioCompressor = 0
        AutoFileNameDateTimeFormat = 'yymmdd_hhmmss_zzz'
        AutoFilePrefix = 'vg'
        BorderStyle = bsNone
        Cropping_Zoom = 1.000000000000000000
        ImageOverlayEnabled = False
        ImageOverlay_AlphaBlend = False
        ImageOverlay_AlphaBlendValue = 180
        ImageOverlay_ChromaKey = False
        ImageOverlay_ChromaKeyLeewayPercent = 25
        ImageOverlay_ChromaKeyRGBColor = 0
        ImageOverlay_Height = -1
        ImageOverlay_LeftLocation = 10
        ImageOverlay_VideoAlignment = oa_LeftTop
        ImageOverlay_StretchToVideoSize = False
        ImageOverlay_TopLocation = 10
        ImageOverlay_Transparent = False
        ImageOverlay_TransparentColorValue = 0
        ImageOverlay_UseTransparentColor = False
        ImageOverlay_Width = -1
        ImageOverlay_TargetDisplay = -1
        LicenseString = 'N/A'
        LogoLayout = lg_Centered
        MotionDetector_Grid = 
          '5555555555 5555555555 5555555555 5555555555 5555555555 555555555' +
          '5 5555555555 5555555555 5555555555 5555555555'
        NDIName = 'DATASTEAD_UNNAMED_SOURCE'
        PlayerSpeedRatio = 1.000000000000000000
        TextOverlay_Enabled = False
        TextOverlay_Font.Charset = DEFAULT_CHARSET
        TextOverlay_Font.Color = clAqua
        TextOverlay_Font.Height = -16
        TextOverlay_Font.Name = 'Arial'
        TextOverlay_Font.Style = []
        TextOverlay_FontColor = clAqua
        TextOverlay_FontSize = 12
        TextOverlay_HighResFont = True
        TextOverlay_Left = 0
        TextOverlay_Top = 0
        TextOverlay_Right = -1
        TextOverlay_Orientation = to_Horizontal
        TextOverlay_Scrolling = False
        TextOverlay_ScrollingSpeed = 1
        TextOverlay_Shadow = True
        TextOverlay_ShadowColor = clBlack
        TextOverlay_ShadowDirection = cd_SouthEast
        TextOverlay_BkColor = clWhite
        TextOverlay_Align = tf_Left
        TextOverlay_AlphaBlend = False
        TextOverlay_AlphaBlendValue = 180
        TextOverlay_GradientMode = gm_Disabled
        TextOverlay_GradientColor = clNavy
        TextOverlay_VideoAlignment = oa_LeftTop
        TextOverlay_String = 
          'Note: the date/time formats '#13#10'can be easily modified.'#13#10#13#10'system ' +
          'date/time: %sys_time[dd/mm/yy hh:nn:ss]%'#13#10'frame number: %frame_c' +
          'ount%'#13#10'time (full): %time_full%'#13#10'time (sec): %time_sec%'#13#10'time (n' +
          's): %time_100ns%'#13#10'ntp time (ns): %ntptime_100ns%'
        TextOverlay_TargetDisplay = -1
        TextOverlay_Transparent = True
        VideoCompression_Quality = 1.000000000000000000
        VideoCompressor = 0
        VideoDelay = 0
        VideoFromImages_TemporaryFile = 'SetOfBitmaps01.dat'
        VideoProcessing_RotationCustomAngle = 45.500000000000000000
        StreamInterface_IsRealTime = True
        OnLog = VideoGrabberLog
        OnPlayerStateChanged = VideoGrabberPlayerStateChanged
      end
      object PicShow: TPicShow
        Left = 0
        Top = 0
        Width = 1912
        Height = 1044
        Align = alClient
        AutoSize = True
        BevelInner = bvNone
        BevelOuter = bvNone
        BgMode = bmCentered
        Center = True
        Color = clBlack
        ParentColor = False
        TabOrder = 1
      end
    end
  end
  object imcPngRes: TImageCollection
    Images = <
      item
        Name = 'White_LOGO_Horizontal'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000326000000840806000000650B3F
              4A0000000970485973000016250000162501495224F0000000017352474200AE
              CE1CE90000000467414D410000B18F0BFC6105000026E1494441547801EDDDED
              8EDC569E1EF087ACEACEF86556EDEC7A81C43B11954C823110C012827C493EB8
              3AB0ECF84346AA2B70E90A245D81ABAF40D215A87405DDF22C301B4B814AC0EE
              607776376A079E78BCC958F40A335ECCCEAC5B638F5FD455E49E7FF194542D75
              55F19087E421F9FC00BA0DA9D45DCD220FCF735E3D34581CC781FA725A1D27D5
              714A1D27D411E8030B5F171D1C737CAA8EFBFA6BE879DE3E8888888888C81A0F
              0DA143480F4910791D49E8D84271F6F53156C7070C2B4444444444D9D53698A8
              2022A1E33C9210225F8B0C2169844882CA9E3AEEAAA01282888888888852A955
              30D161E41D2441A407B78DD53102430A11111111D15AB508262A90F4D4978B48
              C248D53D2359482FCA0D1550F6404444444444CF703698E8DE110923D23B721A
              CD10AA6308F6A210111111111DE15C305908249750CFDE913464A52FE93DD961
              402122222222722898B424901C67040614222222226A392782890A2512488668
              57205914AA63A4C2C90E88888888885AA8D260A227B55F4173E690E415AA63A8
              02CA0D1011111111B5888F0AC8B02D754820B903869245813A46EADC5CD71B46
              1211111111B542E93D26BA97E43A924A382D1782BD2744444444D412A5F5983C
              D54B1280D609F0A4F7A4AD736F88888888A8254AE931D1C39276C1615B5985EA
              D8E6CA5D44444444D45485F798E8A15BF7C0509247A08E7BEA5C5E0211111111
              5103151A4C5445FA5D2443B73814293F398757F43925222222226A94C28672E9
              F9246CE12FC655CFF32E8388888888A8210A092632615B7D19808AB48F64DEC9
              0188888888886ACE6A30D1AB47C924F71EA80C0C2744444444D408D682890E25
              DC30B17C0C2744444444547B3627BFCB9C128692F2C939BFC3BD4E88888888A8
              CEAC0413CE29A99C84935D1011111111D554EE60A297AF1D80AAD6539FC53B20
              22222222AAA15CC144879221C815031011111111D550E6C9EF7A47F73B20A778
              0A88882C5365FE407D797DC95F3F44B2BF5208BB3F53E6CE5D5447B0E26585FC
              6C22AA8EAE63AE1B053256F7FD0DD011EADC0548CE5DB0E425CD3B6FF24BABE3
              7E4CCEF9E8FEEC82A412C531CF39359BBAC6EFA4287EEEDBBE17E2F4CF99CF63
              DE87448DA0EEE5419C1E37F25EA0CEC7695D1EAE731D8ECAD4BA2E0F0BAC6EC1
              A28AB4ADC7244E5A54CF2369C9954500027554B542992CD91C2259C279AC8EBB
              6CC5A5BA8B939E92B40F316989DB8605B179AFFC35F5B3594921AA3975EFDF43
              FA555E0FD47DFF1268C6B07E3E70B1E7A40B437132AF2400B9688C96889F0CF1
              908A882B4B25CBFB38AD8F81FC817A9F23F5E586BAF9C720AA2793453564118E
              C052200F60E60488A8094C9EE95B16CB9C5A93DE1298959B7D7538174C8C26BF
              EB16AC21C85523B480BA0E259048ABC010EE8492650648F699D9E55013AAA900
              4444E43AD3FA90938D39A97B4C740BB5B363D2DAEE8B2FB1F707DF6DFE24B0B8
              BE7BE6C870B3F3EAFD0F55CBCE0E88888896D00D593D243DF02751FE30E5037D
              88501D9F2219A6BCCFDE092A92C9502EE786707DF54D8CC921F0F00BE07012AB
              23F9B345CF7FC7C386FA2D9F7FCE4377F635F9B326797488FDFF751B17D07086
              E34E5D35D4DDAD1754E17E002222221C19A23C80C33D95EA7D4A40B90ACEA3A4
              02A40A263AB9573AA9F0775FC4F8CDE7311E7E19E377BF4B02880491F56641E5
              208A63E94D98A57D4C370ECEFF77E0370708E208AFBDFC2F7106C9E4E900F5B3
              BFB981ED7EBFD9955C750D5E41FD43C99CF49EC8CA76DB0C274444EDE6E89CC9
              55E4593C92FFD1F328771850C896B43D26A5EF5722C1E31F7E1DE3B37F8C67A1
              245D08394A4592B13A76FA6737C64B5E126261C2B85E7DA64E93FB256835BE72
              AB175C68DA6A3B52B0DF613821226A2F3D7757862807A8A7811C150F53E633B4
              41D64E7ED795F50025F8ADEA11F9F89308B7FF7C3A3B3EFCBB68F66759424984
              F8F2F9B31BDB2B42C933D44D35DA1BE3CCD75F47D7E0BEB6849200CD0B257312
              4EDE05111D670C336310D5885EC8451A7E03D49F0C53BE6F699197D0E4B56CDC
              6B9634AB72155A7192D0F1C9DF47F88BBF9DCE0E09264FCF133124C3B6CEF4CF
              6E5E4506FD6DEFE0F9E73B97BEFA26727982722B428936443DBAB6B3BAA40AF2
              F320A223F4D090B4E5307780A65AD1230132D5531C162019099077D8B5CC990D
              53BC4EEA407D50A3AC9C05AE6F9C210AF0D537C0835F45B35092A54764995928
              7973731F167CF9657CE9851770056E694D28D12D2FF7D17CF2599E62AB0FB928
              C386BAA76C8E37D7E540B0E225B2C19A95329FA80C19360FAD1B79966DE7BD2F
              F5795A659FCFCD27325C57D636C4B569E91C13FD3018C03209241FFF628A079F
              E5EA1539561461A7FFD6A6B507D48B2F7A573FFAFF93837F77B2737DC3782BCA
              42B4A9A744F4D00ED22324C3D58620A22374C80941D400BA6ED5F4AD17E49926
              3D2767F234527063E2765A35946BB672102C914072EF6732776452482841EC85
              FDB73686B0ECD5EF77472A949C51BD3A558781B6851261B2E374DD5DD42BB310
              1151730DD18E4D4BE579B60B2243AB82C9455820C3B464DEC8DDBF2C2890CCF9
              C5B5364B77E4AF3F3F94EEAE10D5686328113DB4C7BCD78488881A48F796B4A9
              C1EDB4ACD6052203C70E50B2B51297ACA825BD24D25B52B083736F740B9DF8F8
              277FBCB92F4BBBA2FC15345A194A72ACEC11229950F801CAF51A9220956722FB
              EB2022A2A61AA27DDE95BD4EB8CF09A5B56CE644AE95B8E6BD2432B1BD0C7152
              792F9CDC5865869347870865F3C4964EEE0A90CD764505E0581DD774A0CA7A7D
              F464381727F3111135525B1B9F644E8D7393ACC94DCF04133DAB3F404625F692
              3C1647D15D94641E4E1E3DC29DCDCDE2C28984924F7E89ED574FB1926AE0A0EA
              56190BE1557A5C462022A2C6D04BE80630277500191152D5CA73019240D54376
              D2E8D6E364764AE3B81E930132925E12399A4E2A9F1F7D146FFFE007B3895D79
              D7EB7EC642280941269C08713A9CC83AEC599683B47E3D111151E50298934072
              C9855E743D1A6088EC736464DEF218446B1C99FCAE57053A074332746BBE3962
              5BBCFAAA17EE8DB1FDDB83D86A2B06434933E896A131CC9D001111358D69A353
              08474289900637750C906C6898E53D9DE7CA9394C6D3AB72C93012A30B47866C
              C98A5B3284AB329E57C9C52EBBC4FFD14BFE996FBE81AD89F7B339250C258D91
              65027E0022226A9A00666EBA38DF50BDA73D649F2F3200D11A4F0FE532EA2D79
              F805F093BF9D58DDB93D8B8EE7BD860A3DF79C37F8EAABE9C173CFF97996580E
              51DDC46D2A4655638253D32D58010C1B24322A74876E3DD440965C5E568E8DD5
              B153E43DA6CFA7940383252F09D571C181F7704D57306A61C5DCC730EBB875FD
              3DA5314EC6CF97DDB875A08F104939218D184EEE62FD541911A0388FCF099F83
              33CE3E3FA41C57D7C565F5BF5760A68764D5CC54F4B577DC4A97729DEC177D9D
              E867CAFC28D3FC3E70BE0EB18A3E7FBD352F93DF75BC58F67517BEC1B20BE058
              0F3E8BF0E1C751E5A144A8BE9AD3BB77E22DE9C140459E7FBE73499D43F9F959
              56340BC150422558B8CFE79319039448FD7CF932465211BB6AEB9A4FB91ADA00
              C970823345DC6BFADCDE5BF31EE4EFEECB0209054E0495F3707ACD7B90C9A803
              F51E0A5D663DAF855DB27B2B5E13AA2F974D8296FA3752A1BA04C7A8F735565F
              46557F2E7AA2B604FC1E2AD84F4A3F4BC7EA90CFF46E439E8D27D120EA33B9AA
              3E276900090CFE59EA55C9D4F796BAD470CD6BE4197219962C3C1FE7D77EA543
              CF74D93674BD9C7E5A9A72FB29322FB73F0F628F87721D1C4C7B29BFC12C94DC
              FB991BA144DBC2B7DF0E5031755287EACB8EC9BF9139253F0F194A1ACA99F1B4
              52E0EA82FE3E92026380EA868DF590B4E84B05FD7A8E3D6B160D91EEF791CFE4
              3A8A711EE9CF69AE25D997D17B509D4EF9F2D42D97159290D55BF39A401DA9AF
              237D1F38174AB49E3A46EA3DCABDF1AEA57B2335E94552879C7309D84354B7C9
              EDBC823882DD7282EC32AD306FA59967A2CBB121D6BB646303C7639E8FC6D31A
              0A1220290F0A795E1441376AA429B71705F26FE6D7C6E360B2F99D4EAADE9279
              28718DDFED5E945E13544CC2C957DF44A9C20927BA375EDA0A62A174AB9614B8
              43381496B401928A47DE82D7643867519F8BC96A35BD340FE80C4C7EB72D972B
              7B864BD7CBB91CAC7BD1C2CA42AE0B90BC4F795817BE53B8AE98492F926985A2
              2C0375DCAB5305AD25B2346E04295E6372CDE719423F2F67E641DCB5E7E3DC50
              BF4FA7E9B22AEB56098FCBF0C7C1A4DB59DFC596EC51E2E8CA5BEA81D3994C9C
              28B45E78AE33FCFDEFB1AE7B91A1A4F9B26CA615C2125DD99042421E1EAE16B8
              7352F0DECB515136F9FD5C391745BC0FD3EF19C05D01CCA4192A3344BD04485A
              4CEF141522178641BADA8B3427D7F6B0C8734166F4BC801066D2349E04482F73
              038B0EBAA56C986D81D3A15C9FCB11F23DD79EF4987C743F0E3637567F3032D1
              FDA71F4CE1B25815AC7F7A7B5278EB521A2FBEE85DFDF92FA617960C770BD5C1
              50D260FA260D602ECB4A5EC7FDFC00492B500FF531EB022EA8278148D4759C7F
              0FC9BD61B5B76F219438D1BB9B520FC9B908402E30DDE0DA89F23DCD1C16C7F4
              5C7C362E34800E919F8CEC4882C92B2FAFAEBCC892C07FFD41F5AB6FA5318DE3
              912BE1E4D5EF77471B5D9C51E76D71527E084E746F34DD9D394436FBB04336FF
              0C503F0192F74E444705488633D97CBED5B99C6023861B4298A9FC33D3C39B87
              A81FA7AE77CB0DA0E17C92FF2C987CF785E5AD2512467EF237935938A90B0927
              BB7FF68D13DDD2B2CAC0AF3F3F9435BF4338124AE462D2DDE1E2733DB698725A
              18A73D424636566AD2EFA14E2DA04FEBD998D048D450231BE3CD758B719DCB89
              00C52D64410D55A37966C739802316E6E604C82FC4C2DE38F3E582974E1CFDF0
              E369AD42C99CDFE95CF9D1ADC313FFE3EC86D12A5945F8933FDE9435BF6727DD
              855082A3632A2581CBCA16B0B9EC5E45241854F5A00A903CE4F3B468DC444EBA
              B0707DAC781AEFAADF65AFEEEBB813156437CFB2D735AF9C2D92E5BF7B052EBD
              4DCD3384FB732E8F13BAB2CF91EE71CAB2F0C171F690ECED75741F13D52BD2DB
              E83EFBEA8F3F89F0E0B3187515A90B508513B8104E5C18BA15AFDEEB61A08EDA
              0713D47B67591BA1AA492D88D2F393758761A22693B24E86619D413643348794
              79A740B4866EB87362A87F06D750313D74D2E672EB3B7A9B8D23FC9F7EF8E8F4
              71A1447A492498D49D0E27AD5F62305EBF019DD34B87B680B486E4EA31D16BBF
              07688E9EEDC9BE440D723ACB90475DCED7B572769C20AEC152AAE484BAD605A5
              7E60AB872213CBABF749EFC885E34289F0FFFD2B7E70DC5FC8BC92A6687B3849
              114AE67AA0AA0C915F932A1B73E74144CB5CCC30017C88E6E1FE26B492AE07F5
              503F63543C726061D3441B0D852192B9D6A3652FE86E6D7582A7FF507A4ACA9C
              57127B71285FBDD80B501097867595C9209408AE70528DF17C358AAC74E5A487
              6C0EF411A218F2DEB2166879563823B24586518C616FF2E9FC9E90BD8E7AC86E
              36471066F74896FD95E642142B4036B3A5545D19834F4ECAD3C815A2F86BFFB8
              9F79A3EAF9530B2B98D9A81FCA9CD1FEBAA90D32882B58FC83D28670C5EA8DF9
              D1D5E88B8D1BFDFE93C264F7FD47035F5A3F3C2F80656D0B2786A14498EC9E4D
              F6C85084F3EA66DD4376592AFE72DF4985EB6A190F743DD4CC747F1739370197
              D7A60A9D29681186D9FDBE30113D6B8F67EAA54F75CB670073524E0C8B2E2774
              038B5420B3EC0325812BF70222D458E760AE94EBDE557A854F5BF349AEA9F398
              EA7BC972C147369C2A6308571461E7DC9BDD53E7DED8BCB6184A44FFCDCDD1B9
              37374FA9105148789070F2DEED49E39718CC104AC44BA02A044856D9C9331C21
              4B3091EED4D20A5DDD75DB87B91E88AA312A7A653809DDEA182019AE11C2DC96
              C11C8B00E62E4B85A28C72427E468E728213E0AB61DAA019A21AA6CFC85159D7
              BD6B16364DB4154A2EA70D254282C9E3EE9907BF2A7E085714C717FA6F6D0CD7
              BDAE7F76631879C5AC42202DB74D0E271943893809AAD23047380960E666154B
              F1EA9F69DA331480A81AB986589AD04336249C64A908A51DA6625A39AB64D26D
              C672823DFED530BDA63E47C9744F9CE950A4560DFB9FB3BC69A29465DBA66588
              FFE8D193877ED143B8A4A7447A4452FF834E7788823694998793DD3BCDDA3936
              4728118D3A173595359C987E766354C774B8050333B5821EB27801E6D20E5309
              60A6CA254A392CCB71BAA72E80994F51BE0066F6DB387C588694C3EEA68967B2
              CC91F1373793FF297AC2BB74CFA6E92959D4DFF60E224485158C124EFCC9E44E
              53C249CE5042EE1896B0FC6595DDD3AD1CAF4B94869E6B36869920C3EA5C69D4
              A99C084065BB62F87A54B469AEE9BDD1C6E15BD2202A7B23D92847A4A739F306
              B032942B904022C3B88A343DEC64EB16EB6E16DD8D7CBA09E1C452280940AED8
              2DA8A2E1020613A2D5B23C2FF3ACB6E52296130ED3AB35990EE31A839CA33E4B
              99DA30841D3B32672ECFDC1C0926F8ED3F95D05BF276B6E424BD264896182BD2
              3C9C04A821F69434928492C62FD24044CFD2C31F4298E1E225540A55E79015E4
              B2341ADF053945AFBC35407E2B374D34310B2645CF2D897DE3496C474451F401
              8A77DA9F4E6B174E184A1AED3C7734266A2DD34A5C00A282E98AEC08D98C402E
              E9C1CECA5B2192A15B2358E097B21297D7A9474A5695FC3A8513869256E08EC6
              44ED1482C8017AF9D88BEAB88FEC15D9564E286F813172CC27394EF79307310A
              B6AF8763D5C39370B2ADDE77084731942C15C21D01F2EB71834122A2D6795D95
              FDA8D009247BC3C832CC329724EF9CC7D2979DA6C2EDA9BA49963D8756EA3EFC
              A2D80B3F8AA2DC4BC3799E7F0265723C9C30942C256BEE3BB5C9961E8A3540F6
              5D9DA1FFFD104444D41603D819FBEF02793697B6271095A690BD5EFCD88B4314
              A8E375726FA6E3791554C01D1DD6557028E12A2896C92456BDABB3EC4D90F5FC
              A6DDA3808888C83543501315B2C7980FC7EDDEF93A80F992747638164EF4F2B1
              B2CE748062309814444F0ACBDAE579BAC14B07131151738DD85BD258577563B9
              55BEEA32095120D523932F541C767AA8928493C9E4DEEEFB8FAA09478FDFC6AC
              622A3D2545BE8F105418BD0468D60D439BB647011111355BA88ECB2057C9561C
              21B20BD4714FD54FADD64BFD282EBC953C400EBEEFC4AA445BBEE7DDA92A9C94
              144AA81C4364E3D4DC192222A21542756CE7D9688F0A279FCD36F2859359FDD4
              6638F163C4B927A7AFB1B57BEBB0870C541018A82E97006EA8249C94194A1E1D
              B2C7A468BA90CEB2612887721111511D8448424908729AFE8C9C0A273EBC2844
              C13A19F66290B9258EF4962C927072EF4F6F4FF2ACB0945AD93D259B1B283AA4
              5222CB86A1854C32A3C6315DC190AD9944649334BC3194D4886BE1C447EC17FE
              608A819E69AF4967D2BDEE506FC911D3381E151D4E2A1ABE750F44F564548E15
              31610FE6C35603D867DAB3C6604244B65C5395DC330C25F563399C9C470E3EA6
              D3314AA07A1AAEA759DD4ABD66EBBDDB87BB1266E0300927BB7FF6CD2514A0C2
              3925EC31A1BA32AD601731342E809900F631981051D9C6487A490AA91351392C
              86935D558FCDDC78EFF7DF7E2E4419F4D2BB3757F43448AF8A3F3DBC17C7C895
              B6CAE2773A577E74EBD0EA70B32A27BAEF8D39C7A42459360C7D085AC534545B
              BDBF32765F17718F1B7D4F4E4C25A21CC64802C9B65E75926ACE523811A3ACE1
              A4ABBFCA98C0E22BC2C9F089D17BB70E07B117EF4553FF5378D156D7F34E4A0F
              C9AC9724F650271130FC8BBF3EC47FFDCF1BB977C0AC78F5ADFDFE362B2925C9
              F2F9F2B359CDF4FCD8BEC7B27CBFD760912A3F7A3093651106226A3729376EAA
              634F5562598634908413F53C91709277336F092730DDC766164CA228FAC0F7FD
              D22AC33A80F47C5FFD1F3CA9DCD7DAC32F317CF0CB29BEF74A277338D163DE65
              F3C42A4289E030AE12E8CA630073219AC374B8D14B295E63FA803CA70E9BC30E
              CEC15C4F1A232CF65A98961D0CBB44EE0A514DB97F802765C343FDFFA1FE3A66
              2F6B3B54194E921E133F96877A292B4D35D1E104F8F927D1F093BF8F06A7BEE7
              19AF46A12BABD751DC8EEE698C4165B88E6C42D855C41C8BB40298F93CC56B4C
              834920F79D8DE107BA5121EBF0D3813AAEC20ED332FC6ECAD7995644A4272804
              354195E544DBEDA8F26904B2C1B40C0B40B6C349A0BE5FAAC67B7FF6DF49BC07
              CAE5AB6F805F7C3A0DD4D7FBEA03B8FED1FF5BBF0A99548CD4211F78DE0F3DB7
              DFFC66C22ED982A9CF5AE62305C8204505DAB4E0CDD2C26F8BE9CF5E3BBF460F
              29303D07B61A63F27C9F8BB040376E98F6988C53BE2E84199B3D5164579DCA09
              225B8C834986A1B18DB430E7246F1D71A8EB406BCD82899E00CFEEB99C249CFC
              E46F26F275F083EF7765C9340929B23A817C2017F5D7AB1246D421ADC012487A
              A8DEC1CB2F6F8C517F4E1626325C47AE0364DFF57D9CE23521CC48282EBD0229
              F701CCAFF930E5EBC63033C8BBE6BAEE2D1922BBC0D2E760DA137760D05B643A
              CCB3926B8B520961A69767751D2217E8CAB5691DF78A9EF7DB7A658793F9E477
              996772D3F7FD26154007712C1595F9784875817908BC82E7704838B9FB9713FC
              97FFD4C189EF7A019216F2ACC33CCA92764847994264735D0220DC983313A8E3
              75249F7F9E026E94E235590A0C297865D8CDB5A22731EA0ABC942F43984BFBDE
              6442A6E9BD260D0767B28C9B5E58AC222FF91CF6B30E2BCBD81367D24B1EC25C
              69D71619C9F2598C7480BFC1CF926A2C8459FD4F5E7B4FD7276EB67D6E8DFCFE
              0BC3BAF2D4A3877ACEC9D2615DDD859F3A4603E699C4AAD5541D3BFDB3C7F700
              ECFEF8EB001BDD4B7E149F53BF738002C89C93BB7F35C57FFC0F3EFEEDBFF151
              03BB708C1EDB28058169853E40BA8A7C5D84482ADCEBCC8732999EAF01929E03
              38CAA4655F2ADB5760760E02240F1FA3B9613A68D91C8229BDA897D57BB89AF6
              1FE86024A1244BEF844930999F5753033C7B6DC9753A52BFE73550E9E45ECA58
              AECA3576497F962188EA471A604D2BD401747DA28267E4ACAC44D220E044282A
              2B9C3CA9356F6C983CA89C1445D8397F76637B592811326CADFFC6C6A5683ADD
              8EE2D8680933531FFE5D848F3FA9C59A632EF69808B6CEA55C0545BFA689E72B
              75B9A4CF41960A6FA08EFB32376CDDD02E3D2F4CC2C03DD89F1776450FF33CBF
              E63D6CE92171F21EB28492509DAB3461774607365BD7969C5F19CE9A25E8901D
              A93FFB2582120F225BEA56C79D9595481ACE0238423F670B1DD6F53898C81E16
              5E8D57669250D27F6B6398F6F5B380F2E6E640C58654AB046425C1E4A71F4C67
              43BC5C7478887DD355C44A94F7015A7721CCAECF42AFE58A98361E48419EB575
              6980E421705F0784EB0BC7EEC2BCB0218A5BADA887647859ACDFC3EE53EF43C2
              88BC0FF93D0364338439DBF7E225971EB62D330251CBE89EF731EA2740D2A35E
              D433C7D84238C91BF68E0D2747C6194D31AD65455096D43309258B54EFCAB0E8
              70F20FFF18CF26C53FFCC2BDE1328F1E4585F61AE53442BB5D33098D352E7897
              094DE75DE4E8355914200908838523EF3CA12C7AFAE70E168E3CDDE72234DDEC
              4ACB13F896E9814AD7C0728228ADBA36DE05706CB54379D6AAA30FF3C6C3A73D
              134E8E4E80E8FE8B116A687AD8C975B1CDC2898742C73CCF26C5FFD5D4B9A15D
              2FBCE03BDBBDA92B992E07A722ED9BCC3758D0A45E933EB291F316828EB38D0C
              F4BD7819D4144DEC5D255AA9E6A1DCCAD2F2B6A9733A80E570722498D4713897
              AC26D67FDBC250A44E778812964C966072FBCFDDE83DF9F670367F2184DB8668
              DF52D6213256CA75C1DB844AC74ED6158074255ACE9F0BD7CD08EE54E877F2DC
              EF7AB3B7DACF45A4C7E5041720A036BA807AD629B65C1DFE6A3B9C3CB364D4B4
              6E959A381EC302096511A2520AEA79EFC9BD9F553BF764F2C8FDA152BA22D5A6
              D6BDD9D8CD9C15C821EA5D81DCD7BF43663AD4541D08422461407A70C6A8D64E
              DE73AAC9433D04D59EBA1E6468C8185416D325EC3F0759A79FAD597BE369098B
              E1E4D233C144AF68559F34D9E9D85B8968128D50A2079FC5B33D4FA417459618
              2E59F8E28B5EDE8BA814BA62D786215DB943C902A940DABB37CA23EF39D370A3
              A7E916FE0BA84688A39FA53C08ABFA3C6C8592C5498F21A809AABC2EDBC6B45E
              F5105408DD6358D5B321AB03D747B8E87092B781FFDCB19B6C94D573E01A59A9
              2BF6E21025924022C14402CA835F9517503EFD653446BD48EB5E931FA0A13ACE
              78963630D313D3CEA05EC33564B27FA6CD0E97D1E144CE4388F284782A602E54
              E8C728D7655BA1646E6117E03AF6CA995E5B559639853710D6B49CA82BA34D4D
              BD8C1BAEB694F1BD52D1B3218F34D74FE59D0ABA2736CF2897E0F8DDFFBA9BB9
              566091CA7D59157CBFE39D804D51353BDBCA90AE7BFF370928450FF192F073F2
              15BF56C3A31AFE0095DFE94C11AD21BA90707DF84D88A4225FC8AA233AEC4945
              BA8C5E3779781CFB59EA6B58DE4719F7DE58BF8F2C0B28AC25BF9F5E9125CFB5
              15AEF97BD3B2789CE235262B4F863643720623983D8747C8A826E544AD194EBC
              1EA2DD4293D766BD4F4B7E36E421BF5F9AE74608B332234401746358D6E75C78
              6C30C93ADF228A712DFAB2FBD2F937364FC9114D26A7A238BE80B8B890123D9A
              9C8245711C55DA7D2A81448678C904790928B2D4B06D1BDDD9CECB216A483F40
              65EE4088FA1B4357C88BAC0049CB903AE43E71ADE2210F05F93CCF14DD3AA82B
              D20314D76B3146F259F6D77D96BAD096CFA38887A19CD38104205BBD6FABE856
              C779D80A0DFEE9DEBACF5CBFFF95AF591022C546B1FAFDA639EF212C0D29CC4A
              5F47691FEE3B79CB7487CB892649736E77322EE9DD242695DA21725878361455
              26E725E5C08534F7B7E14AA626E58BB11CE1E4B2B7EC6F76EFC45BFE64721F29
              D7EE9742ED876F74978ED9DBBD75385429E85D5826AB88FDF0EC86B507C8DEFB
              87BB9E37DB3BC019CF7F07F8C3973C7CEF5FFBF8A3973C5870AAAEC1644EAF4E
              3154C73994BFBF445E63240F9F312A20BB9723D91FE33524FB629475FEE6BBD3
              4B0572EC553854415F3F128AE4FA09908DFC3ED2437223EBEFB2701DBF9EF37D
              C8C368CFAB78F847CA6B4BCED98534615C6F2A26BD3EEFAC78D918291FDC0BDF
              77A0DFDF713DEE728DDEF0AAED2D796CE15A3DEEBD4A435A219FFB539F650FEE
              1BEB1E49A7ADB8E7C7EA18319424D479926BEF0A96978BB38AB5ED5E61FDF9F4
              F0E4D9701AD5983F2F8DCA36A17E872156D7B7E7DFB7F0C62BFD5EA4FC0ED6BC
              74B624FDAC8164D5AB766F7DABC2849F2E4C74BCF3E7FE5B776537F9EE8FBF0E
              FC4EE78E4A31012C8ABADD53AA97278405EFDD3ABC133B5C08ABDE8E5948F957
              2F7B38F15D0F7FF05DE3A02205DF053484AEB84801567521B28CDC6C219E54C8
              F75CA9F0CCE97358783871350CEB07D1697D9CC493023458785988E4B3FC541D
              D26073D776A1AEDEC7693CD9DC51DEC7D6C2B1F83EE4900AE9AC47C1E5468663
              AEAD832CD7FFAA6BB4EE8D2C75A1EF9300E591FBE18AC1EB6B114C162D2CFF7A
              E0DA73C115CB96C82DF3BEAF6899DEDCD7840BE76E6EDD393C322773D50B4D7A
              4DA2383ED37F7373ED83BA8870B2AEB726ADDD3BEABD4DBAF75123F3A0222145
              0EE95D79EE396FF6E74F936162EAEF6BDF5BB24E5915ED7558612222CA46F7D8
              DC31F827B50B2644F4ACEEAABF94B926AAD7E45AAA5E93E946AA64272B5FA970
              B26D339C48B7FCEEADC31B7AA9E3EC0E3B3D581929551E99C82EF3509E9E8B22
              C1E4F9EF78E86E24FFBFA1BEFEE196B773F2954E8886D3AD0C6C7D22222222AA
              117FED2B6485AE3493D73B873DA424E1249A4EA565C35AE5D1F7BCEBAA872740
              46B3DE12DFFE1C98AA486079F8658CDF7E9E849607BF44F8BFFF8F3F02111111
              119183D60693D90A5DE9E624188DED9F85139B731DE238F0A7D33B59C3893FE9
              EE22F60234958F61FF6D0E2D222222222237ADEF3141B21BBC17AFDEDC45F558
              BC0343FD37BA7B9ECDA53B259C4C26F76EDE9EA47E2F328F4626BCC3BD49D3D6
              C4EA1C9F7BA3CB953E8888A82E2A9F274844E54B154CC4746336B97CD5D0AB2D
              9340F0F8FB4E26B65788DA520165A4DECBFD55EF4702C98F6E1DBEEB4F27F75D
              5E85CB828378D2B57D8E8988888A14C04CA57B9011911D4653BD776F4FCEFB71
              BCBBFCBB79A16A993F054385EE1DE2E140F5F6EC23F6C2693CFDB4E3754EC28B
              83868791C722C497FB6737AF828888A826E23896910C3D837F724D6FC04B4435
              96BAC744C8D0ABC8C3F21DE1E338D8FD9FDF0E61285EF53DF38AB1252124F6E2
              81EFFBEFCAD7B6841215F6F6184A8888A84E5428B908F3E7740822AA3DA36032
              D3E90E57ADD22595FFDDF71F994D844F96F9E5F2AE36490FD161F7328888881C
              27FB4FC9DE25EA904D15B334A859DDF09488AA9169D78ED92689DDEE3D2C9B9C
              E67961D4E96C9BECC67EF3D6A17CBFC64E402F5BDA0D2F89888896D11BD64A50
              38077727A4CB2ED92F81886ACFBCC7047AA9DF385EDE1A9F61E95E8F3D26D644
              1176184A8888C80269349485645C5E256B0F44D4089982895015DF5104EC2C7D
              41CE7D45289B28C6B5FE5B1B43101111E5A07A4B06305F1DAB0A5C0E9FA82132
              0713D13FBB31543D27CB0B041D4ED62D232CBBAEB765427AA162ECF7DFDCE0AA
              24444464430FEE1B7B9E3706113542AE602254CFC960E526892A9CC8BE22EFDD
              9E5C5FD67BD29976AF80F289BD30FA7D771B444444EDC17DBA881AA40B0BA6DD
              6EDF9F4C56EE9E2E5DC2EA3583F76E1D8EA751745726C8FB3E4EA80AF5208E39
              E93D170925D3CE76BFEF719E0E1111B5C58EEA2D0941448D916955AEE3C84EEA
              EBC20915601E4ADE66E14C4444F6A806C5119289EF2EDA53A1A40F226A94DC43
              B9E6FADBDE41D49D0D25E26A506561282122A2F69155B838848BA881AC051331
              0F275ECCA5FB0A17639FA18488885AE69AF494A8834397891AC86A3011124E7E
              F8E6463FF2700D54881818CB4477861222222A904B2320C6EAD85681842B4F12
              3598B53926C7D9BD753854C9E75D9035B37D4AB824301111154CEFFA2E1B2C06
              A8CE18C924F73188A8F10A0D2662F7FD4703DFF364396097778DAD8508F1E5FE
              D9CDAB2022222A411CCF96F99767F879942344D2533356C74DAEBA45D42E8507
              13B1FBE3AF03BFD3B903CF0B40E66492BB175FE89FDD18838888A864BAF7A4D0
              06468610222A259808594E18D3C9D08F7111949ACC278927DD0B9C4F42444444
              444D565A30999B0DED927927EC3D59E72042BCC3A15B44444444D406A5071321
              43BBD0E90C7DCF7375E3A64AB1978488888888DAA6926032C7DE93671CA87371
              E9DC1BDD1B20222222226A914A83C9DCEEAD479766734FDA1B500E22E01ABEEC
              5EEDF7B9691411111111B58F13C144B4757897E779A3E9616787C3B688888888
              A8CD9C0926738F030AF07A937B50184888888888889E702E98CCE980D26BD81C
              140ED922222222223A86B3C164D1EEEDC9792F8ADFF1BCD2769EB56AB6CA56E4
              5DC3579D31030911111111D1B36A114CE6E6BD289EE7BDA3DE780F0E9B8511E0
              2E7B478888888888D6AB553059F438A4C03BE7213EEDC070AF8338C6D8F3E371
              F4C5C60D861122222222A2F46A1B4C9EB6FBFEA3D3EA8B1CD2A3F29A97FC7F61
              622F0E11F92A8844FB5184BBFD3737F7414444444444993426981C6716567C3F
              F0119D54E1E194EA5D39A97EE32D7871207FEFC55E70DCBF9B858EE47F42C450
              3D1FDE810E200FD59FEEE3F71B217B448888888888ECF9676000D2AD6181BDCF
              0000000049454E44AE426082}
          end>
      end
      item
        Name = 'img_pin'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D494844520000009C0000019A0806000000FA962A
              E4000000097048597300000B1300000B1301009A9C18000000017352474200AE
              CE1CE90000000467414D410000B18F0BFC61050000868E494441547801EDBD09
              9C244775261E99557DCD7D6834D2E81ADD4802834096F1092CE7DADEBFBDC69C
              C63697B131AC8FB517767FC630066384592C2C6CD680D7C6C2C820FE16E63097
              311242025D4627BAEF7334A3B9EFEEAECA7D2F32BFEAAFDF4464665577755709
              DE4C76E511191919F1C5F78E88CC4CDC0FC53DF2C8234BA6A7A79FBF6CD9B2D3
              1B8DC629B24B97754992AC93ED3159D6C8BA4F8BDF2CCB5CBBDD3ED06AB50EA4
              69FAB0ECDF21FBB6C9F65DFBF6EDDB2ABFDF3B70E0C02DA79E7AEA56F743E948
              E27EC0E47BDFFBDEBAA54B97FEE89A356BCE1D1B1B7B9A80E599B21C274B8341
              A580EA56EC790262FDB96D7272F22E59BF6CE7CE9DD7379BCDAB4E3CF1C483EE
              07547E200077D75D773D77E5CA952F1E1D1D7D91B0D533A5D19D00CC8303205B
              2811F03961BF6BF7EEDD7BEDAE5DBB2E39EBACB3FEDDFD00C9931670B7DE7AEB
              D1AB56AD7AE5C8C8C8FF14463B52015647161280A292DD9E3D7B0EECDFBFFF9F
              84FDFEEA19CF78C6F5EE492E4F2AC0DD77DF7DE3C25EBF22007B8DB0D97385CD
              0E4B5317500BCD7C5353530ABE3BC4FE3B7FFBF6ED5F3EF7DC731F724F427952
              00EEFAEBAF5F75D45147FDEE92254BFE9B30DA5A3E16024E1D302D34E0D8F613
              6723DBBD7BF7C55BB76EDD74CE39E7DCEE9E4432D48053A01D79E491BF3B3131
              F17BE200ACD27DDD00AC0A540B09BA909322769E1355FB0961BCF708E3DDEB9E
              04329480BBE5965B2482B1EC7757AC58F187001A4B3700EB0654FD02609947AC
              C70E1D3AE476ECD871E1FDF7DFFFAEE73DEF79F7BB2196A103DC4D37DDF433EB
              D7AFFF07B1D33662DF5C596DB1EDBA2AC041C4AB759B376FFE43712E3EE88654
              860670859DF63EB1D37E4B3D4EDBF873015DB7409A4FE055C5FBEC7109A9B827
              9E78E2FE2D5BB6FC86A8D96FB82193A100DC1D77DCF1FCB56BD75E28EA7303EF
              9F0BE8EA9E5FE7BCB9483780E3758DE709DB5D70EFBDF7FEF1CFFEECCFEE7643
              22030FB8071F7CF0DD62AFFDB1066B55AA40521774BD3A12DDA62B933AA31936
              0D6F6B1C4FD8EE320907BD6E586CBB81059C38066B6474E022710C5EACDBDCC0
              BD806CD0403757B0615BCB206194271E7AE8A1FF2EB6DD27DD80CB40024E7AEC
              46710ABE2BC1DBA3ECA039A49FA01B04C0858EC700A8BFAA62451BFC8E80EEC3
              6E80A5DE78CF028A0C493D5354E8350A36DDE64A65096DCF4723C6F6C5F2EB65
              90BF4EBEDD8AD4973BF1C4132F90D0C97BDC00CB40014E421E6F3AE288232E15
              7B6D5DE878B720AB0B88B980AE9BEB70FA7E887AEF6BD6AC79C73DF7DCF37772
              8D81D45E0303B86BAFBDF65512F6F83F02B615BA1DF3CE7A61B16E8EF75BEA5C
              7F2EAA5ACF5DB76EDDEB1E79E491FFED06D0641A8802DD7EFBED3FB97AF5EACB
              046C4DADB09883D08DE3305FDE6CD9FE5ED275A3AEABF65973C3FECAB0D8DF1D
              7FFCF16F7003248BCE70DFFFFEF77F7AD5AA5557341A8D26F6C51AA58CE9E6BA
              1DDB57B63F94AEEEA841553EF39146BCFCD78B03F62E3740B2A880BBEDB6DB36
              8ACDF68FA169449032A0F402AA2A992BE89036B4CC457A3D5F40B74902E76F71
              03228B06B86F7CE31B6B2726262E1543F778DE1FF24AE70B74737122165BBAB5
              EB700FEA48884DF757E2FDFF9C1B005934C0896DF137322EBAB1AE0AEA0648F3
              A102E7EAB9CEB7CCE5DA0A56191AFCABABAFBE7AAD5B645914C0DD78E38DEF92
              11845FAE3282CBD643DB31E987EAED97CC6759382F89D36DDCB061C33FBA4596
              0507DC77BFFBDD8DE2246C8A1DAF03BA3A80EC95F56C59F8BCF91CB49F6FA913
              0E92D19B97488C6E935B445970C0494FFBEAC8C8C861FBB971EBD871F6DC3AC7
              E61B90F32DF3E1B054E52FA3386FBBF9E69B4F768B240B0AB8ABAEBAEA3DEBD7
              AF3FBD4E63F7C27476E956CACE99EB1CBA5EA5CA96ECD65C9088C0846898FFEB
              1649160C709FFBDCE73404F2D61868CA00D60D33CDB581CA0441E9D88482B948
              55B9E753C6C7C79F235EEB0BDC22C882014EBCD277892AED3C7F10ABE018A0EA
              DA6EF69C58FABAC75818700B39093396B65B5382EB5758EE2F7516B55B605910
              C07DE52B5FD928B6C36B2DA0622A30960EEB365D5D994BDAB261B55ECA12BB4E
              D5FE3A79D5614B19453C53DAE4F7DC02CB82004E54E9DB75C66E99CD857D7CBC
              6C5F88D5AACEB71203B5CD8385D56988E9BA015EB7609B6F708E8D8DFD8E983A
              0BCA727D079CD0F64689B9FD824E878E3546B7A0CB02765F2FE7DB74BD4A5661
              1EC4587DBEAF192B43AC4C1231587DCA29A7FCAE5B40E93BE06468E597E5E768
              DE57D61058E7B4F6B8DDDFEDBE32E91608F3ADD2EBB0586CBD2CCF58A790E1C5
              5FC91670EE5CDF01272AE72D60379550CF2F3BC6FB63EB594DD62B6BA82A165C
              08A903B6AA73BBE95805E04EBDF2CA2B9FEB1648FA0AB86BAEB9E639C2701B63
              60A8038E1810EA325B284D68BD6ABBACA384CEED97D461B7AAFD360F19D33ECF
              2D90F41570E228FC12D88D6DB83246AA62389B96F7F1317E53A53DCFEE0F6DC7
              8E5581BBACC3D4CD2F96B64ACAF288D5B7B6CBCA952BCFBDE4924B166460BFAF
              80931B7A718C25EC761508799BF2AF7D5EA47CC1E3B1325AC7C79627966F5919
              43D7B7F984B6EB00BEAA7CB81F9DC2242340BFEE16409AAE4FA283F4F2737A15
              A820A1D79C56EDC3BAFDEDE57C2E136FC79832B45E2575D3968164AE62C1A6BF
              FAFA0819D87FB65B00E91BE064CCEE797A2378B5292F212070E3C68053063696
              AAF343B1337BED10D062120370B73217A6EB86F1429D5F46817EDA2D80F44DA5
              1E3870E01521F5A33D2A64CFCD75C135EAFC7279CAD284D2C6AE6DF3A803549B
              7F9DFD3160858EC5EE89B7B52D54C4DE3EEAF2CB2F9F15BEEA87F40D70CA7065
              8D6441A752B6DD2DB82031B0310B9501D24AAC1C21A92A77374073AE37B55E55
              974C02E2ADFE98EBB3F405709FFFFCE7CF91061DAD021B83CEAECF950543231B
              75011C6ACC1040AAC06EA52A5D5D0056952156AE18F8B04F461E9EE9FA2CFDB2
              E1CE56FB0D368D5DD8C65260E07D6FD817B2CBEA4AC85EC3356CFED639E06B5A
              060C31628C257B7DE0A5CEFEBA80B7E75601B3583FDEF559FA023801DBB398C5
              D0E0FA1B0213F687BCC390848E97390F7C2C04169BA7057F9984CA6281DB6DE7
              A903C0185B865832C6EC96E5A4DD7ECAF559FAA252A5E0A72BC385ECB4327569
              8FD551AB2A65FBEC7A287D1DA6A83A56072455520516E7C2650AA5B37568D344
              F23DEE031FF8C052D747E90BC34D4F4FAFD7CFFEE8942480082CA7828AD0DECF
              5F8489B14996CDED8B3165EABA4CAD72FABA2C69F7C7CA1EBB5E28BFD076086C
              B8762C401DEB60541EB5BBF5AD55F7B83E49BF0077AC024E3F7601FB4C7F95F5
              F4297BAB42B9D12D00B9C16C8356019525D6B8B62354A9C7D0B1B2734279841A
              3C766E687F0C6C7C2CC6665693E8AFB61534D2B265CB9EE68609706F7AD39B46
              A4F0CBF506B0007000077F86880D7AF44E15DEC7C06247841D01952AC7C33A10
              9665AA98A91B668B49AF8C66F76535D42AEF634D0370615D17804ED2F67542E6
              BC034E86489AB811BD096534069C8A5680EEB78D6A811733ECB1709ABA6C57C6
              9A3130C4805CC759A8E37494ED8F812E04CE1093C5980D4003C3A936D2EDF1F1
              71D74FE9DBD01600A7769C65385416980EAC6601C5006256B4E08AB151ACB143
              7659559AD0B542C7F9FAFC5BE79A31B569D3587B8DF75BB0595643BB60BF024D
              17305CE899E1F9947907DC8E1D3BD6EB0DE83B6715247A235A3150ADFEA202C2
              82BE7D1A0B266B5385180FC76C0C0F52D6B0F6780C1449891313CAC3960F6978
              BB4C4DC6B6793F972FE6818682E80C3A15000F0B8E49BBF5F55BAEF30EB87DFB
              F63D6E7B131C068007AA161252952A00943D8E632AB1181E8336F6E94A1C0B31
              4F15FBF1B562CC15026E5927280363C82E2B039B6538EB24408D4295E2F8DAB5
              6B37BB3E4A5F542A285A41A56CC6002B630156BBD8C740B51FD5B580E1F31888
              EC89F2B5118C0E7DACB76CDBAEC78E57A9503EBF6C5F48D58640570536100003
              CDAAE2E22BD67D937907DCEAD5ABA77133BA2034C2AA55856F52C188C657819A
              B58D180258C8B9B0C2E9CA3CE432A682D83431F6B2E9AA4017BAAE55A1BCCFD6
              A155A11678CC6AAC42EDF9A252F7B83ECABC8F347CEC631F9B929BD9C9B641F1
              D9ED5937CCBD8F2B4005FB4283FCECD2DBCAB5FBF85C95B2EDBA0BCE8354B111
              9F17129B67ACDC2160D9F287467142B61A83CDD6A7B4CF4ED747E9974ADD2A85
              5F053B0E6A15AC0435A9C7C16E2AE8C950ADA894983AC5FE10CBB14A653642C3
              B0FA85D4B5B9621EA9159B57595A3E16027415B3E1BEF8FE39DC116234DB5975
              FDE1871F9E747D94BE00EEE0C183BB94D5144CBA588F951D87508340D52156C7
              0D10B2F16C5019A085B03A651B2FE44C843CD5D06FD5797C3F56CA001AFAC57A
              19E02036908BC582CCAEEBA2DF657DC73BDED1D74F9FF72B0E7797DCCC39DABB
              C060BA0EA0F90BD3AB1FC074EC81A21260CFC582BC6C9FF1F9BC8FE37D0CBC10
              E8EA789BCC98902CA05A43B6651900EBFC86542FEE8D0166192D647E58969336
              DAEBFA2C7D01DCFEFDFB9F10E761566F5340A1A7A1B135C888B0898A55A9CC76
              D68365950A612030DB611F032F063A564B388FC536B82D4F1D468BA5E90668D6
              4EE3385B0C500C4476DEB04FCAFFA0EBB3F40570070E1CB8CBC6DFACE789E0AF
              DE287F9A921B32043C061D339A653B0E79303B5ABBCFAE03F01640164CA1108C
              3D1E528DBC5DE67DDA7D56182855B6198331C48AC84F6D6FD767E917E0B6E2C6
              98DD54AD82D554340D1C0AFD45E373A333502176988C67A44060DBA95860200F
              EC43FE38CE00B2F9C62404B632D6C33916542126B3E92D782CB8AC1AB5518176
              203EA78BD8DE7DF55055FA02B8DDBB775F2385EF30993A0D2A0A3C059DEE6315
              0BFB0D950B67C1CEEA80B02AC374271BC70370B0ADC23618A64A59B6B120E3E3
              FC1B13BE2E4B99AAAD624215D45599D16F81C7CC1653BBD857380D77B93E4B5F
              0077C92597DC7BF2C9274F8E8A40B5A2A741952A0895ED2C73016448171BB4B7
              0CC74CC7400B0186D359070379F2B5D9CEB38E8395BA4C1763353E17D78E01CB
              828C4119721E900EC2DB9A4E8625FBEAA1AAF473B6C8B76479218FA7DA4607DB
              5935A2C71056B10CC7B616DB60969D981D719EFD8D0D77855430ABDE328979AE
              DCD03126E3F25A8055812DB48486AE702EAB5998387BF6ECB9C5F559FA063801
              CCF50A38C4DE1057E3B151A858D8750C30A455611653810A0E79B576D09EC32D
              3C63C53A1CC883CB87E356BD5AE10E1152FFA1757B3E2FBC2F743C0434CB745A
              9FA1742ACCECD8A731B8471E79E461D767E9DB83D062C37D8F87AC7451D64285
              6000592B05BF6C63601FDB1EE8B1213BA4AC97A3F25550D1A1219ED0386F9695
              BFF9A96D8C77DE6F8150069A10A854EAB059A84E42E7721E96E1F6EEDDABC392
              C369C3A9C80D5C0D55AA2CC3611215B0088C77301D980AE7C096B3F12EA838CB
              542A9665705DB6C3C09868280E30737E96BD580D5B07C2A62D130667EC37047A
              0BE410D86C3AD47948CDD218F60D52F6F242CF83F48DE13EFDE94FDF2F80D90C
              7BC1BAE676CE9C0AB39AAE83E9988DB8D22CFB85D8ADEC986580B2E87CE85A55
              0D1D5BEA1C8FB1B52DA7AD173016EA08756B998F87BF745B08E20EB700D23786
              53911BBE4C6EEA95085D00446032F43C1578AD7016F438188E4723C0462A1C14
              66FB8F992F24D62E0B8DBBDA6072280F6655ECE3DF489D1CB66ED5741940EDB8
              6848B5221FAC874C07CEA720842BDD02485F0127157FADDCE82BF91955158083
              E37050A1FCABC2611580831B0763B5AC321944D6262ACA350B980C62165691EC
              50A8C4E274BCAF6C7F950A8DB15E48BDB22DA6C2F668880D5943209D78A8D7BA
              0590BE024E1C87BB972F5FEED7393482CA0193012CA8183022C4824399102115
              549E051B1A92ED32E4CD0CC7A19550A884CBC0E063260CA5B1E796ADDB4E1152
              B92190F17E4403002815663156BD388645EA32130FF576B700D257C0897AFC0E
              B307038B6F9E4720D869601509415AFE55E1B49A2F83911FBE56098193432B2A
              56ADC6F60164F6171252C7DDB01B77160B44662A745C0B28AC335859A5AA483D
              5EFB894F7CA2EFC35A2A7D7DC7AFB8D94FC8CD3C647B161C0815B09D35C2ED3E
              05978ADA785A51D8E6B087ADE498715FA69E6C63C79C8E90A3601BB4CC59899D
              1B53A1B13258078A81887AE03C42C095E5CB6E81A4AF0CE72FD06C7E576EF038
              BE4938047806D2F6520CE4238D824C46C93A0E05D8106A1A23139A160DC13389
              718DD8C88265B890438006E4715EDE1F62B79054B19B4A88D5AA00CA00E33A2D
              0326AE2375F92DB740D277C0895C278DF372D8190005549E2F04C5DA30C280F8
              1CD26A249C6796409DA2E238D6C7130320167C2A7674A24A8DAAA09C1698AC52
              CBA40EE0AC3AB5200AA95DCB6056BDDA6B91AA6F3DFEF8E357B90592BE034E80
              7293BE3E80430CE861D681604F540546BCB21740068F94276F729018F9635DF3
              C37C3B1566337618703DBB94315E0C9C21612086C0C569AC6A2DB3EDECD3705C
              BF18AF0E5D07752FEBD76DDAB4A9AF0F3FB3F41D7072D3D74A65EC911B5CCE15
              CA5E217A2E06F2C158A19E6DBD55F466A85E4C7D02033218E140B033C16A15E5
              297314AC27CB6C198BC359B085F695A946B6CD54D0D10026D8B056E5F2B5383F
              539605098740FAFEADADF3CF3F7FBBFCDC0226E1602F1BF9603AECE7758E8159
              571FE3B33AFF0EE7A9FAB5C72904506A17850C7EBBCF1AFEA1C62E7332AACEB1
              A3035C6F7836849D26AE8F80CAECD45DA82C22D7B9059485B0E1B402BF270CF3
              E36C0729E340D581D132722AAC6D66ED378EC5714C8E6D3E0539D2F19B00D038
              6040CB6C2155A9C2D3D699E9982143765C6CDBB21A03D286348A7AEC385CA173
              6D6804406556B776AD2CDF730B280B023811F554DFC29E233B09A820D867D648
              E7D107A84A80166A148DC5AA554581A7E9753F1A034043C3C2D3B5B69D55ABDC
              1942BF756CB898EDC620017898E920009B65FD10102DF0701EAE29FB0EBEE10D
              6FB8D92DA02C08E0B66FDF7EEDFAF5EB1D3C5536E2C1482A00970A372440C136
              0C830F15CAECC7FB54F06CAC8657D0A8BA0DC663156B432556D8CE8AD976DCB0
              7C1EB338DB590C3474048088199FD98E87F4780A564CA5621D65907B5F50FB4D
              65413E417EE18517DE2915B28D1B8AED277E810A573A0774AD3AB0BD174634EC
              1BC4EC60B781D5700C2081DD87592976203F64F7C4EC337EF8D8BE5AC1CE0DE4
              D933D8CF7616D705AB57EE80CC80CCB6BCCE80B5E68AE4B360E110C882004E45
              6EF25FB9E7B13A5301E3A8A022D100DC936D4C893D363002BC5655A7384F41A6
              8E850ADE06A0DBEC9DEABA9EA3FBD9B930F71135FC639E22EFE377A6F0880BB6
              5538480B90F1DB0B388D3D8FCB09C0DA72A34E7548CB2DB02C18E044AEE2B96D
              A850AE14061A0064198CD5075430D2A24239ADEE57104175EB39001E54AFA6D5
              7D6854DDCF1D21C6500CA490778B740C5E7B4FEC20E0BEB983715A568DB84FCE
              C72E6071D620CC727BF7EEEDFB0C5F2B0B0638B9B92FB2F1CADE181BC26818A8
              436E149ED581CA4703718FE699133C2281700980B67FFFFE4EBEBA0FD754F01D
              3870E030A0B03DC73352207C3FEC5D7259183418175601DBF188093A40885159
              B5B2EDC9D7B55A84ED4529CB836F7BDBDB6E700B2C0B06B8BFFDDBBF7D586EF8
              3154181A5385598F171C5361A3D93A13CC12001B422160350CAB413DE9B63A10
              C8076A14E7E8316E289419C098A6576031A3B17AE6342A3C11150001E878484F
              B7D151A6CD1B0CF06B3B28D707CA8C6BA8B0EA2EEA7541265C5A594895AA37FB
              256BD7402D5A5B84BD2E6B44732FE75ECCA04323A27161B781351052C1BBEB10
              1744232B1BF2CBFB98E5D8EE43B9E09C4035FBCAA5500B542BCE03503144C7E1
              1EEB89DA973A72F823E44014753DAB7E54D8EC1076BFC22D822C28E0E486BFCA
              C6B40A1A4A05BDBF483B0B741C26808069AC1A4565A3E155003C309E024AD3C0
              5ED3F3152C50BBF06A7916892E9A273C5D36FA0162A8666644E4074683EAC4BD
              B3C3C263BB6CBF017CACC6AD99C1F69D0D9EAB30233FF2C8230BAE4E55162AF0
              EB65DBB66D5F5BBD7AF57EB9E125009E9DF1811EC9062F4F4FB71E2B02BADC50
              6820C4D8F8816B34AAAA4C150519C000F0E1BA3CFD8963732D1A2AB20D0DE021
              A80DE606D8C16860760013931010CEC1B5DB81704CC8818019A1C221166CB333
              23F6E9B60B2EB8E03B6E11644119EE939FFCE43EB9E16B5855B2FDC1EA166A80
              558AF5F4AC2AB10E056C22009601A4C0E39726E23A603915A8D824993DB51C82
              73316486F97DAC5AD1913814033042C502602D1A5561568B85865418FC603276
              34D85E462792322C783804B2A00CA72237FC0DA998E77265A077732C0ECC80F7
              8F7063A8B03D85BC7852264623D0B02ACA6AB00F751DE9A18E751F0FBFE13C96
              8486E3F80D00B0CD704DDC03F2808DC8F70C3B52EF11EB38973B140FEDC1C6B3
              2111EEB436B6875F8AEB7DDE2D922C38E0E486AF6030B12A60B5C8063C4F5502
              5360888AC75579A80B0D07750A5663B586F43A5F0FD7E6B200943CC6CA8B0A6F
              B36DA8A2E733EB59B6C335D0891880FCBC06C087BA61758ECE56D4ED2C6F1EF6
              1AC708F59C5DBB767DD52D922C38E0E486F5C19A9D5281ABC05A3C530495CCC7
              004E5418039003BA45FEB358CEDA7130DC35DDD8D858671BD700CBA131431318
              5975F1A79D74BFE6C97137C4FD10FB032031659E67BAA00CFC8C2EB336AB5608
              3A241C240618CA0DE65391EBDD7DDE79E7DDEF164916D48653D1D7EA4B255D67
              7BA11D3F4D680C914104BBC7179EC212503376501BB68B0A077FC126D856A040
              E5AA9DA54161FD45D934FDC4C4845F941175013855F43C0D16EB79687C3D8E3C
              31CC86D9CFFCBA32A8741566749E8E1FEA583C02C323183646C7314E49BB28E1
              10C882034E451AE52BECDEC3BE40A573D8040DA0C28DC08632B659A55AAF0E0D
              0BF6E2F007B6192C0A40B0151A0D00E5F81DF20720710E1C048EF1695A78C52A
              6030768C6CD883E3930C2CB027C72ED976E33827DBBAFBF6EDFBA45B44597095
              AA228DF675F44E7E0EC17A9430E0A11A79FC52C57AA43C5509ECC14F72412D83
              D1C024002C54AC6E630480C322ECB1AAB067AD026F150B5432CA0635A9A0D36B
              018018D5E06737F8C1226BAF714CCE1E632F9FCD80A22C0FFFE99FFEE937DD22
              CAA230DC673EF3197DF1DD55A1CA031061BB71E0971D036E7815AE740E864265
              F38C60381C18D40750B4C1552D42952A40C074702010D8658F946D3F56C9CC6E
              5A6EDD8760338FEB227C0296663B13EA16CCCBD38DF85E598DB2A78ABA2B3ACF
              37DC22CBA2309C8A54ECBF48253C9BED31EEA5CC4C3C28CD8CC75E2A1C0F7E69
              353B1EB07D30FD9C0D7CD8580018AB70B6AFB8AC6C0230AB35681A3B40C28C07
              4F59D3293001607EE3A71D5D60D301BFCC6CD6E6E5B009B39E5C63C11E788EC9
              A2014E6C898FAD5CB9F23CD821081170D41C210556B51078746C54831539028F
              B46016302403136C05958B1006543E00C263A33C028032824DA19A015C78A600
              2300AFF7ABA0C335EC1BA462C276293339EE9983DE3CCCF5E8A38F5EE616591A
              6E91E4E69B6F3E78F6D9673F572A7623BC4D151E42E28A55E1B89C1D6A52E1F4
              085500901C44E5110AA84A1ED3D5E30A1AC409012EC4EEF0CB0D8A0E037B0CF9
              01E8508BCCDEBA8E4EC6268365EFD02803EE81BD51D4017706E42DF95E26F6DB
              47DC22CBA2D87010A98C6FD86026B3980AAB17A8489E51C1BD1CC25E2C7B753C
              880D86812D87BC618B697AB5E7700C79F1803E980400447A00090002D014C460
              74800A63BB3C5A62ED50761E7832811D4BE57BE76345F917DD7E53596CC07D1E
              CC01A0611BA00253700C4A05EB1684CC04DC0868488ECF2940003E788DBA4F17
              3011580B2C693D528EC9F193629A875E1F71378CAFA21C509F6C9322D4010981
              8717DBA9F8DE703EEA61F7EEDDFFEE064012B7C8F29BBFF99B0F4A251D87683C
              EC260467110EE1C99268583BCCA4C2713918E1603215844B74D1B8191A088DA5
              00E1910F66525C930D793B860AF509D6C32C143806B0F16063B173C4361D0780
              F9351750D349327BC2033C7AB625F12B796E79FBDBDFBEDE0D802C9AD300914A
              F9A234C06F73AF454016BD13EC66E372B0E1B8B7B3DDC68E84F56031B404C000
              1850812AD8CFDE274F2EE005A065A744C13B3535F3B96F9E8B07DB4DD7C1AEA1
              389C9DAA04B071288483BBCC6E28A784632E7303228BAA5255A4C23FCB95C886
              B80D8DE0570506333FADC5DE1AF7781E02421E30FEC14E687C36F461CF010CE2
              597786BCF889304DA7E0E291063D0E4F1AB61BEC35CD139EAA65336B9B85C21F
              CCB66C6658DB15E76CD9B2E5E36E4064D101B777EFDE1BA4F23B6F5F4465F2D4
              701E3F846A516106E0B1C5CC0C0F3120C1901C0CC6203AD85445F729B8001CE4
              03A31D79EB7978B4102A5301A8E00350013C9E2582F007AB6805264F476296E6
              4E87BAE032B1A78E7A2CD86DE7FAF5EB1775748165D1C22290DB6FBFFDE05967
              9D759A34C0D950612A6878FC027C2A1C970BA954AB9A01406E18062A98060CCB
              AA9C5529543AC0835F0ED300CCB01D3926C6B35F705DC41BD12978E09ED530EA
              20D69954382402FB6ECF9E3DFFFEEE77BFFB536E4064D1194E453CBACFB047C9
              71391E7047AF874A64E7828D6BA8529C8F5E0F7604CBB10D0815095B0FAC029B
              0E03F7CA64788C10EC877CC06C0012CF4401BB01883CF2C1CF71A0AC280B877C
              B823F1D831C4DA6F5A2629E73FBB01928100DC134F3C718D54FA4E0E767245B3
              67C67617573080C3CCA7621D0BB010180CEA52A5D198FD3A0856E588D1A9AD86
              F15566358CC3C24E5BB26449A763408D42656ABE987889BC438E107BDC56A5F2
              701F0395ED3B2D8FD86F8BF238604C060270975D76D94E69A8AB0028F6FEA0D6
              38E8198AB531A8D809E14F64F2396C038135D969418C0D230E7C1CCE079E5FE5
              581CC650B5B1793631000CD04DD12BC754788A799BC68FED58B10A03CC8E3440
              8AA0F2EDFA5E173740321080531135F5D5D02803B317D426B6F92B84FC6BD98E
              5983C1C5063B871978288A9F4D651B092A13B34BE03000789AAF1EE77153000D
              71413BCC658D7F3BA26087B738FE08466FD3909694EB523760323080D35741F0
              00341A000D8CA9DC3C3D89D52262596840E483346C4873D0961B9E8D77B6B174
              D1FC554D62C6EFD2A54B3B0C8872620A12D84BD32244A2C7751B2A584107A644
              C701C042E3C46CB3A1A3D8508955AB5BB76EBDD80D980C0CE0FEF55FFFF55E69
              80C7AC5BCF337859AD319B716C0A02E780ED1E78B9F07CD178FC4C01B31CBC4C
              DD87B1520594FE6A4C8E1F0304200178BC3A024006236A3A15301D3C5830203A
              104F2B670F1DC28C8C4E04D17DE29D2AC0BFEB064C0606702AD2805F849AE05E
              0B80A8C09EE29001EC1B3412DB460C3606B00AAB579C0F80C01100A890074F57
              622F16AA15C3630013462D94DD5430EF0E362498994747F01B0AE20278CC6CE8
              6CB88F763E267CF1873FFCE1436EC064A0002795F435B6DB20AC6658A5A8F010
              18CF2C81B3C02CC7EA962732AA6084007616984FF7B35D0601AB6174814718F0
              2C839E07C602DB6194811F1F048B7167C31253B1EC8573D804DBC2709F750328
              0305385153DF16D0F951077E2F08541D7A37F77A0601D4AB1D7C8F19E7ECA1C2
              8B44F8021E276679F0DB95C06A700A608BE939AA567946888A020FDE2BAE89D9
              22E8283C50CFACCD337D99D5D88C60FBCDB39BA8FDCD9B37FF9B1B4059F49106
              96BBEFBE7BFF33972D3B7B6462E2A94D31CAD1381CDAE0F000077CD148103416
              00688D6D8C1470A80133456057A9606401E5402804313B3B0E0C95085B0DF9F0
              5424360BC074388F471BD8FEE4FBB20E42675DCB70F73DEED0BF7DF3D20F7FFD
              6B1F73032803053895534747574CDC75F72F24EA8DAE5DEB121A565261358985
              A7F970E017FBF91C808D590E69001A1556932A00A10D36C3AE0388E0854255F2
              5B36311A81403002C3CCDCCC687CBFE8301CEC4599B5CBB4B76E75535FF8929B
              BEF2BBEED09E031FBE74F7F6057F7F6F1D59F4E94956F638F7C5B55A918F3CE2
              A6F6EF73E969A7B9E9638E7129CD53B30D6307B743A30E6C80AB8019712E3C45
              9E568E17CF406DF3C03D80052602F8E0D9625A126C478C6040F50290CCCEF6D9
              5456B56CBF41BC0D2AEA33BBE5FBAE75C30DCEEDD8E91A726A6B69E3DB6E4065
              D1276086E44DC71D7FF3D8C4B857ABCD65CBDCC88A15AE79FCF1AE71E491AE59
              787F0C16F63CD9C60138381DC084D77541E5E2188F4AF0003D030FEB0C0E800C
              2C8BF2F1CC14D86E6CC721BE887BE2D73BF0BDC0C1E9C41275B6F25D77B9E9DB
              6E73D3BBF7B8F6DE7DAE25BFD3FBF73FFAFB0FDD7F8C1B50193886F392B96F26
              EDECA94ED545ABAD1E84CB1E7ED84D6FDBE6DCB1C7BAE6EAD51DE6E2098BB08F
              6C109555141A1FEA14F6188F6BC223651663E664831E0BEC36000FC0E117F620
              0E07E743D7F12034C7DFEC5096AF1238083ADDE98107DDF4DD77BB4CD8AD3D35
              ED5923D10E970983BBF46A37C03290809B4CDD97C65AADDF715AC9528953D3D2
              006D018F348856767BCB1637226C97AD59E3DA850DC6CE0340C64153763AC086
              FC6E0F15B01E0780E1C5E2D73A212AF0409127F201F0B00FB37D31C55CAF8359
              C1CC98ACF63B611FF58A1F78C04D89A921F12397EAF9DA1935BDF7BE655DB6D3
              76F62F6E80652001B7334DAF5DDA6A4DB55BAD91116529A9FFE9B6004A996A54
              5490F4EAC9471F75133B76B86CD52A9709F85CA19610F405D83828CA01559EA1
              C1C3662AEC8972E881A772436583DDA0F6344FBC3F843D53301E9E4BC5203E58
              19C0C435C0CAD3BB77BBF6E38FBBC9C736BB6C5AE2834567687B361380E93D4A
              676C4A31759972D94D6E8065E0BC5495DB77EE3CF8E32B57FF7C6364E418A7A1
              88D111A52697AA2DA52CD328266A2A7B1D9471CAAD5B5C53C1A20D5FB08B0A07
              4F196CEC5C60201D0C89D0071888BD521556D3ECD90298508FD80F96C46400FB
              60108F72C0639D3E24A31B623E4CDE779F9B7EE821D7DE278E817438BDDFB63A
              0EAAFE95CD9499951D755BDFDA3939F9C46F3D70CF1FB80196C1B4E14464C0E7
              BB49969DAB065D5B2A57A355AA68BC0A548F12C15DF9D7544678E209D71055DB
              5263FD88235CB66E9D465C7D03B1AA4D88091904AC063146CBEF11C1B9F8E5C5
              39C7434A1DD0B267AADB3A2AC1B347F8A1E7968266EF5E77506DD527B6795322
              2B1C97298479B45C6EA623798B2DBFB8E4A16CEE2E77032E030BB803697AFBD2
              760EB4B6B6A9DA7052C1CA70F227F7349B23DE8E4954E72A90942984F1B2FBEF
              7723F7DEEBB2952B9D3B7A836BAD59DD613EEBD562362E86B3C07A3C566A6D2B
              761A002C8008F13AB6DD60E36138ACF3AA7E1DE6DABEDD779403C26689BE4447
              EEA9312EEA36D53C9B5E758E6859A605B4B24F8C590F34E73B9AF331B85696DB
              72A30BFCEDD35E646001373D3EFED586824980E663F10A2A6D745D9ACA32A96F
              8C66437FA5F21588BAB4676CAEA67AB562FB8CA8DA12F0B58E3ACA25C71EE3DA
              3A6DA8B0B178D605B3DC14BDF0D9069A6D180620834A64E7035E28807668CF1E
              D714DBF3D0830F3A277668B667AF9B1293A1393EE1A614C0230232397754994F
              6E794441D76AFBFB6BA76DDFA9D224EF60CAEEBE23B6F37A996EA477B8019781
              05DCDFDC7EFBFD7F7CEA695B9A5976A40794EC6B28D340B5351B793F97F53165
              0A69CC3135D0E59F67822202AFD2D0B89518DEE30F3FE2B22BBFE33235E66514
              A3A5CEC62927B9E6860D1EAC3C660B5B8C9D067E97870A8F30603FC65E3BC0D3
              F7C149ACCCDD79B74B85C9A644F51F52169531D769718052019A826A5A6E665C
              D5ACE49BEAEC18E960237AFDFCE2B2A41E544DED684579146C0D3539BCE3D076
              BBC69A77BB019781059C8AF0DB7552B33FABD1F3A2E6F39E4E8E802BD697A8D7
              27F69136DA21894F8DA679C38CA8ED93E5EA5821984A8335F4E196FB44ED0A08
              9A977EDB654B26DCF48A65AEB16E8D4BD6AC9500F33AD752469425D1D8DA48E1
              B47820E4CE8A36F0947F8F9CB08BB2A1AACC8307DCA80C31B51FDFE226373FEE
              0E6DD9EE4664B4442B59594C97D18971AF36B54C63F27BC8B37392339994CF83
              AC60EB0CB1446F2EB47DD9358D67F92CB769F5FAB0F76EFD21E0E6269369FA68
              53C306CA3AB9469D359CA58D364A3343C654452AD3A9DDA4A10769500D1978F5
              54380D4293627C6B7E696EF749BEA9A8B53189D22712E3D2F04B4B1B55F62B68
              1335CCD53B96F39419130146AAE1092D879431534FB1604135EE7502DA682A41
              E0443D53F13885895BFA30B4AA612DB31C5733A0D1CC55E784B21A462EF45EFC
              158BE72FF4BEB5E3683CAE50A1EA24281073B3B6009FDCA3B0E6231FFB8FFFD8
              EF065C061A7053A9BBA199A3CC8F3828E81AB05F64F78836A67A80028224A349
              8C0A2E0DEAAAE1AE40117DD548D51653833BF77005599E2995311B89B095002D
              C9F206D56B348475DA8517AC067B26B84A8A0F8620D4E2D31579280B8D7B15EC
              B37693595E2E056D4B0A3E55A41F937DCA6A2392BFB2D2B4EF344DAF4A155CAD
              34F14CDAF6AA3D771A1488EDCEC33F391073CACF01E77CB8C72DF8A7287B9181
              06DCCE254B1E59BBFF8067135FB10593F95040310A3C5A18FEAA6EBC07AB69F5
              D7874EC06C1AC393E12969D55175323CAD0940BCDA6A7BC6189534CD54F34F04
              042D0FE4A40054832646E6D72E9EA12D18467FA78BF28D08AB695ECA6E128475
              93AA269D8E5408DBE9044F394F810980B515646A2AE8F176C168925543B6DB59
              6E0208E23DEF7907A5A80B7514D439F5F6A46CEF1F1979C80D810C34E0762F59
              72756BFF410FA2B4A8D8CEB4F32429E24FC538A91E478C4C1B3CCD41A30E4422
              606B695CD887178AE75A53556FC5F4246D54019BB29C0E1129C014987E8CD2C7
              BB8A389B2C602A3DD62854610371311D8D10B04C7AE038CFA45A965692EFD7ED
              56013A0598AEA71AC4D6F04E964F126DF94071C35FB3D1C8ED456F372AE34EB5
              3DE0F558EE28B4F2FB9665DFD2A5F7BA2190819AF16BE5926F7FFBB1C934D99B
              1643393A56A876539ACCD8390DA8B734EDEC73491EAF6B14EB5EFD369AB90DA4
              E3A2BED133AF364794359C822DF700D5D355237E52A727C98907D539502FD7E5
              A4AAE73631D6A90054BB4D171DE0F7AA52F210C068C51ECADADE661B49F3D0CA
              21AF1E530F245F2665D8E25E479AB9FAD48EE0BC4A2F3A8F3F9A77AE14A19082
              5953B2E1A692EC7A370432D00CA722C474ABB0D2B9EA38C02BF3CCE330F290B3
              8537ACD3868F59358AE0B0075B927B801AA56FA4EAD5B63C08BC113F9DAF7B3B
              CEDB6B022EEFF4E52CA601D7869B99C3E5C15180406383693233BB2B0FC08A0A
              95EBABDDA6201B57DBCC03DAE5E02E6CB5B418EE5215ABC1EBB602D0E93E594F
              8BD10B0563BB18466B159F25F7EA34BF5AD69E79465681FEF8860D8FBB219081
              663815B1716EF353A7A773F5819EDD99F59AD0E881DA4B45E03445237A6F0FCC
              E13C60D46B5556D3F531651F1DE2CA7255352AEB4B04C008A72883A91A55169B
              2CD8AE5530DA410DF6EA807D61BF695ECB75382C4DFC3EB5E1341FAF4A75603D
              CB3D662D88E6ADACE6CBE6EDCFC4972F8FE9E101A1DC43D5F26947CA192F8FBF
              A9EA87C3B04FF2D93536F643A7613E4454DF8D1A7AC0141C54B4AF7A6FDE1403
              F42EB7D17226938692D0851F8598CE03B49900561BD54FEB966323DECE13B024
              D33E4637E6D573C152EDE221686522B09CDA5BDAE0590ED4348117EB3A218A29
              55A15E55367DFEDE0B4DF2A0F5B874845611CAF1B6641127F4E3BCCEE59E6867
              8C34F38E8E824CF7B70E4D7A3F25C3FC40AF469D3FAECE516B7464C785175EB8
              CD0D810C3CE076351AB7AC983A947BAA3AFE98156A356B77D41D6C1D6D7CF5EA
              B262484A5592864E3C60D5389F9675019802A29D788E13464B7DB84409D47B89
              0290F146CE7A18F6524074A63915B694B7E7C86E1C2DC0D2CA72F07BD5DA544F
              B870143061D4C7E2240FB529D39CE93C3B67C5D7145D1EC2F1D7D1E3D36DCF74
              ADA9B6BF414C60C88A308E826F2A498782DD54061E7093ADD675DE526EB5123F
              AB42E7C5B9DC8E8321EDBD561F34755EC52A9365452CAD359D871FFC007C92DB
              52AD628649CE80B98DA54A6CB4911BF17E882A9BEE381869110E49C172093DA2
              8772B673B742994DAF3126A0566F74BA70681A45D0B7C3C4DE244873FB322B66
              8364B92900869B9E6E79D0691CB063472ACB6BE72BEC383FE2313AFA841B1219
              781BEEA29B6FDE21BDFD015718CC6AD3B47C45170F9AB40B27C1E537933F7790
              F80603D3C1D6F363B12EE9D849930560478B017A0D67B4DAF984CF09D9375E78
              C13EBAEFA06EDB7E7A54AB009C0F14BBDC09192B40EFD9B260A8A69FDA9E158E
              43F1949973C5A8822BC21FF940BD8FBD15F7A32CEEEDD082C53CB315F7ED637F
              EDE2A170F93DD070D7B8219181079C8AF4E5FB3CE08AF89BB7E192BCB7E75387
              5C8779BC17E9A7ED141E9EA62586E93CDBE032EF456A626FF8BBCCDB71638D3C
              1CA106FE0102968FCDC9F1F1C2091829408EA0EFB48FC1E56CA6796888252BC6
              6F75664A3305C3E52A533B808FC179562D02BEC4D49D185C3B2FBF7684DC292E
              9E43F54BE6D971DB9225B7BB21918157A92A52ED0F2BD894DDA674044159AAB0
              79126F03E506BCF7F6649420EB8445F2B857D2CA1B6CA47022126F4B35DDA4D8
              868D62CC3493F4531AD12F1AD6C7D38AEB2734B280B04852B04E5AD871793913
              7F9D2CC9F3687AD59EAB48DDA72A5CED36CF6685E7EA47101ACD590E8467E422
              FC93E5B1A05C85B6DA9DE1B79667B896CE1B74BB56ADFA0F37243214803B9836
              6E1DD7F08082CA7BA73EF6EFFFA78587DA09FC7A67211FDE4AB33C16A7077C64
              5FBDD346EE3D2A08C69A3A04A646FDB46F7065B85C7DB6FD20BE074131B4D509
              3663E0BCB0E33AC35B4519468A017FBDEE749683A79928A3E50CE7CB95E43135
              0FBA22989816761D546D3E72E13A1303FC688BCB432BAD56F1E1949667B93BFE
              EF3FFEE3C0CF12810C854A3D9036AF510FD5152CE78A86F6D37260DF68C28289
              52EF797AEF2167A0463E54D42C461B9461749C5501D12AD4D998575B323AD0CE
              471D74DF9242757ADB30A3779538D719E447E84481AC576FB5F3612C4DA38CDA
              2866A4B4935C95AAC0B6F4F1C2347F4EA3F374599BBEE6ECC78893CE98AA57A5
              0AB4C28ED3FB17C6181AB0A90C05E00EAE5872AFF67EC4A01474EDE2C19576B1
              80E93CC0D2A4601257A8560C6DE50CA33698DA6C2385A1AF0926933CCCA1CEC2
              58619F696077B208ECFAEB17D780B1DF2AF64F17C1E0C4079A1B79B824CDC74C
              B3225F57C4F85C9A74C6673DC09262BA515ABCAC264D8A72E6ACDA2A40E719AD
              18D6F21DA09D3FB1D56867033FAD9C652800B7F1252F79B0B57CF91E8D3D653A
              4D07B18842DDE4CCD2EE0CA0E74C97786653498B6940CA705E9DB9DC33D5B3A7
              0A6F72A218D73C548C2CA8621C2FC037C241DF62498B694958E0444C7AF01576
              60E1C84C677868BB7848AEF05E7D6CAEF0A25D11CAC978B8AC9828A043701A6A
              498A7225B8EFE5CBDC819FFCB1036E88642800B769D3A676F6A217DE953DE3E9
              7E32A3024FA3ECF9934AD98C5A6DD36BAC8AF96C69F1CC839F3BE7B2223E97E6
              B33E94ED8A59C3878A46D440AD0E51697E93C5C03C58CEB35A31363A5D0C6B4D
              7586BB72108E357286D3124D27B953D02CD8350758F10C6B82376FB673F5EF9C
              0FD524D98C93E2C338EDFCB90D6FAFE6E32B7EAE5FFA13CF76C9EB5FE7DCD967
              DFE7864886C26950999898F87E7AE289CF4C376E74D9830FB96CFBB67C7262F1
              EC42EEA5E2377F9C2929461D9A7EF0BE553C689347F7FDE0FDD4B4671FB5C3C6
              FD13EE0A30714EF401E3C2536D146AD415B69B0A463710FFE3C17D0595F796BD
              7D974FA8CC470DF259BE7E3671311324F74CF378A10FEFE8D2C81D1DBF5D3CD9
              953F1E98E501E1934F76C95967F969EFEAB96F7BE0812D6E8864680027B2ADF3
              CA85A79CEED21D3B5CF2E8639EEDB2622E1CC0E607C65545B58AED76F1A89D3E
              7BE08AAFD0E81B29D33CD29FC930D76471EE980783F360D618D7746133A92485
              5ACDF2206011F1C7D05AD2991FE767E526F9E38D7E2A7B2307959F5859C403FD
              398D7C74C1C7060BB58A58620BCFA24AA7F08EC3CA95AE79CE39CEAD5BE7CBDE
              2E1ED2DEBA75EB2E37443234801B191979140F2FAB34A4E29B471DE5D2EDDBFD
              1359CE4FC1CE8AC1F3E23980A2C194D9A65BD37ED8C91583E623C5F4241FD977
              49F1D04DDB032F29D872A460B1CECC1447D3A2929987A03B5EB22B46185C1113
              C4142957BCE4BA9116C1E7A607615B87B6469A795EC580BE2B6CC9CE1B318F58
              EBD20D1B5C7AC4115E8DF367D38BB7050C95973A3480938ADE8AB71AC14EF300
              38F248372E0DA24FDEB71F7D340F8A2AD85C3EC88F19231D862B40E49F25280C
              799D4932E9F221ADD1242D4277F933A0FE9D6C9EF2665E13A1D7982E543986BE
              FCCC621D8D48F2E9E5D37EA4A37806C3836B2634D22EA649E96802C65A3397CC
              02B5D8106EC9D39EE61261B6CEBB88E9ED01C5638B07FFFCCFFF7C8F1B22191A
              C0EDD8B163FFF2E5CB1DBF6019E2A7920BF046840514786EEB132E39B03F7F32
              6AB2EDE361D312F46D78504CFB70851FF7D43755AA4A4B9C77147464C2335496
              836F4645CE788E60380C41A59D81FC7CBA54AB63FF353A21997CE8AA91033D71
              9D77A4B430E9D287457255AA6FFD6C48076AAC5EEDECAB55F9453A85793154EC
              A6323480DBBD7BF74E3CF9AEC2EFF450F1712A35CCF5E97A5DF6EC71EDCD9B5D
              4300A8769E3E6CA38E8377228A18D948315D48A9C8DB700E8F063AFF7497AA3F
              845B704D00AE4D2119559F8D34FF4D93FC216665311F2FD3FC8B206F565CAF5D
              4C26C0A380CDA5CB5CBAF10437A20F6417DF56E577C3A193F19B300B30EE7043
              264303B883070F6EC51B87EC7B7E55F0DB7971A0B0A1B284BEEEAA29C03BF8D0
              436EF4E0A1CE9CB37CFC348F91350A2F5503CBD3AD7C88DD8F2414C1D7946CB5
              CE935B2E0FFE623D430C5019CEE5A111574C77F25E67A3F0908BA1B2B63E5C7D
              F4516EC929A7F80ED2A0CFA4E3FEF8C58AFCF675BADFA1999604191AC049456F
              C52B14F002197EC92058088DE25F2CA3B37F0578D34B96B8C6A9A7BA035BB7BA
              E6962D6EF4B1CD6EEA9147DD882B5EA7A0365C52380A05C3E5A196B60F457818
              00E485978A315497E6CFA4361C46371A9D1109E76654B21F8758B1C28D9C7186
              8436F2D74B2405C89841EDBB8AE124CC52EB33F7FA801B32191AC07DEA539F7A
              5802C007C745F835AAF66D97CC04F0F4F0F2417D6B665BECBCFD4F798A1BD3D0
              838455266FBDD58D3FF8881BDDB15322BDD33E20EC7C186566A480BD51305E47
              A5166A161AB0D5CE9F0653AF3359B5D265276E74C919A7BBB1A79EE5D2356BF2
              47FE0AE1EF30402CD8B03D4BAD279D97210EC583332CC31487D306B8F3D0A143
              3F625F7B8A4F23B107C7DFD542C3F17752757460F4C48D2E3DED543F9AE0DFEB
              B66B971B797C8B57C189D87ED37B76BB6CDF7E97EEDFAF3ADD35D576F28F6C89
              5A5FB6CC39714CDCB2E52E59BD4AD4F71A97AE5AED9235AB9D06A793E38F13C0
              ADEA0C5DF1CBA7F9C5D5FC1A3015760ED071ACB380FB96DFED6EC864A80027A3
              0DF74845FF0800C41F5FE38F8230EBF18B9AC182FC5D8729BC905054AF936552
              545DAB789557D33F81957602BE49F1D10EB5B732BD5EF14A898E279B249D5107
              F66E196CF86510D9E358E7EF4DF01BD3715CCA3854A30C2A430538A9E4DDFC4E
              5DFE66830D95601FDEF9CBAF496500821D91069FA3CC2741B6FD844F6C370134
              05AEB24C63F6477359FDB2A05C218031C331A062C7718DE27E866A9441652806
              EF2152E187F04240FBF5975843E25342B093A05AB10F46395E93AA2F0DE4683E
              7FF60836238E41B55BC000FC00466782013936CC6028337E19B47C9CBF17A1CB
              DEBD7BDDB0C9B0016E920CE60E20C04A1610F653489DF792D0771AC07007FDBB
              DEDAB35E44C82F9666C39E01C4EB2190A12C6C7BB119C0A00B818F7F55F82326
              328E3AE5864C860A70D238FB53E3E5A1F1A01E113251E1EF6F3128A03EF12E5E
              FF6E39FAA8076C260EC1846C28661BECE372B12AEDBC40D1CD306067966F961D
              062E0B50FB31393D2E9D64DA0D990C1BC31D60264303C0A6E386C1403F3EFEC1
              69B08FBFD3856F9C02ACFCBD7B309C5589A1D8980A7F46890162ED311EA6B3F6
              1BE7C360E46BE3BB12C32443E53448656F633601C0E01C40ED611F7F0F01DE2A
              6C27FE6C247FD00D5FFA63E701D7EB3CD310603A1656A5C897F3C03AEF433E00
              B67546384402F693723FE6864C860A7022D300990A83078D66BF2CC81E297BA9
              F06E01364DCFDF4B85843C4856974920D46119CB7AA92C761F9F6B9D20AB6687
              51860A70028403569DF1368300B655E7EB2E05C3F1A72A31080E6F17AA13761B
              ABB0623AD0611F0AC1F5209681211CB609012F240C62CB84C572D00D990C950D
              C7CC136A70DB20CC7E9D8FA415361FC0C39F39C231A84DFEAC1102CD6C0B9679
              95AC1651DE5880D7822F661F72E7D2BC76EFDE3D74801B2A8613806CB7DE1A2F
              965D78CC95471C54385C02EF9119AF414F7CA9B01DC6A31A21B0F131DB19388D
              55D321DBD0329CBDEEB0C9B0D970BB3966C54157DBB810301D7F5795C31438AE
              82A13215FB194CEC67C0B38480C5C2EA34740EB643DE6A0CC432D437901FE72B
              93A152A92A21A059D56619108E04331CBC3EAC035C7C0D8EBFC1E16009B11BC7
              09431263C2D87A6841B984B5D7B92193A1021C8300EB2A0013D240581D32E854
              A03A398401A0F2E7280146EB2840CA545B959A8D01AD2C7FDC5311335CED864C
              868EE160D80358086DC4C20B000A8743AC7D07B5CAF61DDB4F3163BFAA9CDDEE
              8BD9836C936A591090D62955C3264305B8D1466355B330E8E161328842AA4785
              1B0B0CC7A0E3CF29610C1552160281941DB36978BB8CE94260C3C7E3A68B771E
              3765A8CF0D990C95D3D0BCE69A556EE74E979C7DB64B689A394FC0E4714C0E96
              623FCF2DE3110766370618ABD6905481AD4A05835D630E03971BAA3EDBB2C5B9
              8B2E761B766D1BBAE9494305B8553A59F2965B5DFBB1CD2EFDB1735D72C209B3
              54AB0A1801ACD5EA7CA32A99158F437AAC432D5B159A98D084659E90D4613C96
              D0142B9CCF2CACAF7E687DFB4AD7FAFABFB964C76E77E2F8D05944C30538E1A2
              71FF1A2BFDFCE4B5D7BA297D12EBDC735D73E9D259537C78288BBF25CFE110A4
              0128340D3F688D185D1D805549CC3653B121113BAE8A7DADAD5BDDA1CF7FD13F
              ECEDDFDA3936EAC6DCF472376432545D246D8E9EE86DAD34FF905BB663879BBC
              F24A377DFFFD2E2B40E5D3A5F8B0466316C0C018FC800D077F61BF718C0E5265
              73554915EB01583CA7CFEF3F78D04D5E7FBD9BFCE2175DB26FAF9FDE3E3636EE
              3FD539353E7E861B3219AEB1D42439D51BF1FE0BCAC5D7A1C5809EBEFB6EDFF3
              5BA262478F3D367F628A00C2CF37C09940E3B25DC7F13B66B898511F5B0FFD5A
              297322BC7DA940BBF34E3779DBEDAE2D40F3E51E1FF35FB76E4EF97757C8BEF4
              4C3764325C4E43ABB52A7F1351F1AE9046F1453E65049DB7F6C003EE903E77AA
              B6DD514775DE958BA12D9E6ACEB61C8F3EE018D8926DAA90511F926EC0C636A2
              8ABE156952EE63EA9E7B5C7BCF5EFF9A88A47870A7A1EF92D3D92DCDFC69FE24
              6B1FEB864C860A70A3697244E77D1E69FEA5E686CE834BF2B7966B33EAE7C0A7
              A5B1A61F79C48DEAAB13D6AED5A9BFB30006AF901D05663E8ED5B17AB3231A75
              A52ABDBFE6FEFD6EFAF1C7A5DCC2D4125FD3F79EE8BBE21AC57BE0FC2B56755D
              9FB7D0578CA96D9A653FE6864C866B0266D63ECE37BA6FC0C2834C8B3720F917
              FB15B69DBEA0461F86B9FB1E970AF8DCCA95CE1D779C4B57ACC85FEE47CF1CF0
              C804C7E35462DE2984BD587BECB0B2D334A78EE8942771065A8F3DE6DABB77E7
              65C2CC62655E1DDBD5B77CEAAB623DD85AFAB2127D938E3FBEE4D0A1A11BDAEA
              CDED5A04F9EB97BD6CD971070EED49974C38B76489D3DF449F4350CF528C6865
              038DCD75DE66AE60D206D417FA295B4C4D0AF056B9E4980DAEB57AB54B240FB6
              D5D823C5B61D93B5435C768184CE51E94C7BD217ED089BB5366F766DFD705BF1
              8E389FA69DBF9DDC7FCE46A7904F4FF94F9FFBCF9F1F38E8DCBE7DCEED15552B
              EA764AD6BF393EBAE2ED5FF8C2D0BCB26B6818EED843874E1D6DCEBCB46FA641
              1B9DEF33F8FD6961A7E9CB725BF917045DF189C8B6D877A9A8DAA6BE4569D952
              D7D6D7621D7F9C6BE92B18DC8CBDA7C220B10043DAD0644BA4EDA86265357D63
              A5B2D8A3B26C79DCB50538998435B4B3E8E2302C97E66F5EF79FA1F05FDBCC72
              1B4ECB9B4EE7AF8950B5EFBF72DDF01F4839ABD5523BEE363724323CEFF84DD3
              A7EB9B235B1A5F2BDEA5D669F0063D669714EFCD6DB5F3EFD9EB7155A153B92A
              F5EF336AB7FC6BBC9A0F3FEC92CBAF70D9F2652E13EFD66D38DA65EBD7BB64FD
              91397B0268693A4B15584673C4665E6D0A1BB5B76D73EEA1875DA6AF857DF491
              9CDD2684893D2B8FE5AF6ED553B3FC539C0A2430B3BED0D04B969B08FE9832B8
              BE8DA931A3521580471FCA9EE67E08B87E48FA9C46A3F8C887379A47722034C1
              6C33E0F092806DD2E2031C33D17C6F01160DED8965DB76FFBEE0745254D88143
              79C31F29E6D1B225BE711365A3E5CB5DA2EF113969A3CB96084077EE10D526EA
              EDE00197887A6BEFDB2FA01646D5770F8B3DA6618B6C42D4FFB8806C62CCBFD1
              52EDB1E2F332336FBAF45FADC9D77D98279B7935BF7FB25FD9BA01D035F3904F
              E134E88BA547DB877E544EBDD80D890C0DE01A99FB517D8BA4FF3490B21C1A21
              CD3D54075BA97028F49077023CFBCCA837BC8CD7377696CD8E7C039002BCE4FE
              079DCB5F49E8551BF8AC33220015AA6C9434F58AFAE17A01D8A8CB245EA61D41
              BFE9EAF563BBF80A601B9F6C2A0095BF1EBD13BEF15DA1F81E43863405C3F90F
              87348A70480136AF8EA75A3FEE86488662A4E1BDAF79CDD1C24F67B9E28BCE0A
              3AFF910F05A0BECAB43103B65CB5913DE5F2F7BEA9926A2633EFE42D9AD7B7BD
              4FE3664088FD8ED2599901607E7E52B054CE9E2E07570758FA1AD71C6CFEE371
              19CECF66CE415EB0E50A764EC0DE8DDC6E4B75728100BBA18BBE82A2913EF393
              BFF44B47BB2191A100DCB1FB0FFE57E9CB9D8AF79F7D6CE6E18B4601C246B1A4
              B0B76067158CA7204C0BCF159FC054F0291893827492E2E31B2A8AD9148028F2
              098D22CC00C5F92F1C269DEF6015E0D230473B57E169F185C01C80855ACF66AE
              31CB3149739B6D066C690EB4D1111F9BD330895F4F928953B2E4F56E48642800
              B77A7AFA17F1966F57A8C8DC334D7D8F4F0AD6EB842CD2B4F3D5BF2449675E99
              8AE07096DB121A4C4DF28FD67886EBD05AE60804F9AE9C15998D6C38C4800C60
              F2C06A773ED7E48FF9E4335F799E95F72C8F7806701E60CA6EC5D268E6230EAA
              66C75AD90BDD90C8C003EE652F7B5963ACDD7E41FEC983990FB7E5E3A539C09A
              8D5CB526C597F972A66B74D82E577760AE629FCB3F55547C20CDB38F06585297
              7F6761968A0CC4DCF0597267D3BA1C64336C977FEB34D16FD417604B0AA077D8
              AD585CA793E01EF38EE481E699BDD951A9B9A7DAF4A01B9F6EFDC4F9BFF77BAB
              DC10C8C003EE2553D9F3574C4E2539980A0720991965000BE0EBCA699A87173A
              2F844E0B8BAD00095A3781AA2D1AD9AB5055B7FA6D07E73A5F9856559CABDE99
              A509064D665E3A9D176B86E1F24FA6B78BED195B0E00F4A0CE66ECB959C04680
              B9B0D972DB6DC4032DED78AAF9A2A05BD26E8D1CBF73E72FBA21908107DCAAD6
              A15FC86818CBCF874B13623B6AF834FF4E2A8321294092E40EE08CDDE592C3D4
              645AD061EA72DB0E004B4D9CCD39372B7F36FEA18EA15EF3DF1C7833ACE7086C
              0CC699AF4CE78C56380A1E703983FB785C3A0338AF5625FD91FB0FFDB21B0219
              78C0ADDE77F067924632E3AD753CB724578FC57E4720F373CA3ADBB94AF59F22
              7249E7C5D049810C806F06863302F3CC8E3000B49014487339901C6C38B05D36
              F341DD0EB0BC0331033257940B36281680AF634610D8BC5A6DE66192957BF73D
              F7FD6F7BDBC04FC81C68C07DF4A52F7DCAD8F4F453C166AE60B98EE3007B8E41
              4076505A380C50A52900E88A636E26BC01F0F52AB3C21CED196F152A3501D369
              B222F8DB6134E74835D3B01D582C9DE96449118B731DB59A0371E5FE434B8FDB
              B6EDF96EC065A00177CAE66D3FA536555A8C91A601669B51B529A9398C7116EC
              C56AD5CD7885FEB730FED38CD82E9961B732E95CCF914A7633CCD50195F158BD
              639251CCCE39F2AA67628DF0547D703B6DD0101718AEE9D94D7FF5268EDFBEFB
              D7DC80CB40036E7472F2759D58143E2B9E16BD3A9D0D34B6B192C4C4C81C012C
              60BBCDB2E3DC4C5C2DE9381761E16309C09690F7D93680F36CE7C871A0589F23
              E0E1E2A9B9CF42AD02746931CC95146A75F5CE5DFFF5536F7EF3496E80656001
              F7A5673FFB8C5171F73B5E28AB550257C88E8B81A963A9154C971896E984355C
              591EE451F23A833CFF8CCD6CB5EA41D8EE8CE1A659A00324C9EC4070F13B03BE
              06818E546B335F56C838F0518F6DFD5537C032B0805B7D70EA6D3E323FAB8737
              82CE0302BD699276D410C21EB3C193758096DB4DAEF3E5C04EECCC1178ACA380
              6D371B1033FBB38E2A4EB342B5B6677E3DC88AF15B7618667786D9D774149383
              BDC6435D49A156FD5C40D9BFFAC0FEB7BA01968105DCE8A1C917FBF087FFE4A4
              CB2B3B9989BD398AC9A5EC44806D9C9BA54E590AED3733A2601752A929818DC3
              2FC873066C067814F6F020EB843D66032D4519311AC1335A92D9DE39DB721DF0
              15BFAE60B9B53B761CF1D957BEF2B96E40652001F7EDFFF4C25749031DEDC833
              9B51AD338151B05BCE02E19100380EA9519BCE19A3DD61FC146AAE58E054B8D9
              DEE44C50D982349BC917E3A71C77EB0CE61B1BCFE734532E467D82FB4B09608D
              999088771E60CB4916278D2F79A31B501948C0ADF88B0FFCDAC89B7FD3A5FAAD
              AA74B6EA844A71C661E8348E9BAD0267B15636C36E08B87A29C214AEE33166B3
              D4EA2C20B337EC0C03BA7CF03F0739B11A810D83F6AE701C1CCF7F33435DB83F
              17AA830602C105083526B766B573FFEDAD6EF51FFFD17FF9DCE73E3790435D03
              371FEEFAEBAFDFD81C197949FAE217BA91739EE9A63FFF05973DF470A14EF2C6
              845DD331A60D1BB8599E2501917775B6B3D9202C12249CB8F89BB9D9EAD9DA75
              74B919E7C11500737900382B82BF1E64989099CD80BFF3900DF2D6FBD4E0719A
              76163F83B9005A5678AAEDB39FEE929FFB5997AE5CE946B26CC531C71CF366C9
              E57D6EC064E0184E2AF99D69A13A1BEBD6B9F137BEC18DBEFA952ED5075F9274
              46AD9073307B8645D251491DD6B1361D0F9C77546AC17006AF330C99CC62B359
              C35CCECDD88E09B129319B6BD34883FF7E3D58ADDD015BD2712866ABD559F1C6
              C6CC0C67B5E792754738F7B25F76E9AFBEC625BE8EF2F21D79E4916FBFF4D24B
              078EE5068AE1AEBEFAEAD36458EA75F629AA9133CF7423A79DE626BFFB5DFFB0
              F34CEF4F0EB37566A9563D998DFAE23ACC52DAC0999B9996E43A6992D93BB0DF
              301A7B95D89F0310CC99754224FAEB9FCA6A17EA146F75423ACE13A8EFB8BD05
              C325B92DE7A7989F79864B9EF18CFCC19A6C76599BCDE6CA356BD6FCB6ACFE99
              1B201928C04D4C4CFC2F7EA1CCAC1081EC1F7FCE735C7BD72E377DEBADAEA5CF
              0E50230070996138BF5AE43FF38BC6C97FD399D559C63BC4067F196C96E58A4B
              E752002D2B6C3657CC1E71ED19B0F92F4C67D9EC4B82F1003CA352F5619FC649
              27B964D9B2D2B701AC58B1E237DC0F011716A1FF8DD22B5F1B32D4217E884A1C
              89E64FFC849BDEBEDDB5EEBBCFB5F58B7A86E166CE81019FF30EED2D7E8BED8C
              B7B09E1D766D1C09B1DA6C413CAE78AADF83CD156AB555D8720891B8026C6059
              A6D91976F36A78C50A97E803DDCB97CF589BC9EC4F5CB248E7DD78EFBDF7BEEC
              A4934EFAAC1B101918C0AD5EBDFACD75BE810069AE5DEB9A62B34C6FDEEC5A8F
              3CE29FFD0C1AF0D866E0415B75588DD4E7E1ED3663173A777827382C2DF666C6
              39C0330E2E7F78C783CE15CF50CC380C81CB3BA78F161E7FBCB7631D85623AE7
              94806E6C6C4C03C13F041CCBD7BEF6B5E3C6C7C77FED3063DCA8D5C3441FA6D9
              B0C1358F3EDAB594F104786ECF9EC341306B3D23A041BD4285E53B3373664C85
              3ADA3F2B1DB1553E1993C0570CEABB620422737028DC2C6FD54356DF7BA7CFC9
              EAD7AAD3B07FC7608B80EE67EEBBEFBE5F3FF1C413FFC10D800C84977AC20927
              FC5701DA5131751A526DB34455AD30DEC8539FEA1A4F798AFF9478C778F7090A
              F5E5669C07CC1449B264567CCE75CE9B1D4A2963352E5BAE7267329BC9DB8CAD
              C22BEEA8D6F64C995575CA7D344E3DD525FA5E9400DBDB3A39CCE6A5656464E4
              2FC46419087259F442DC76DB6D1BA552FE3C06B2D02F7A33F7686F3C2B436A68
              40ECBCB63815D9430FB9449FAE3F78906262ED59B65B8258C8AC205BAE126742
              62746D2A7B0884D897767682DD5C07745927543263DB65FAAE13519B4EDF6F27
              CE808B307BA8F3D9B7AC5BA613CF7FCDC9279FFC3637000EC4A2034E98ED1DB2
              8CF14B5FD28A1ECDC7625E9A824EDF9A940953E8DB8992BBEF768D7BEE9D3DDA
              403653020EECE43BFBFAA18F82CCE0F3F0904BEEC0148C45CF3420F6E6DF9224
              F7D93EE514E74E3FCD25A23AADDA0CB2B9D96F3B5D0C74621FFF0F09AA7FE4EC
              B3CFDEE9165112B788A2EC26BDEFFB02B025F625325560CB2832CFEBFC5E5CBB
              241252490574E9BDF7BAC6DDF2ABDB8726F3D73B1CD23715C9BA3E6DAF8070ED
              C3CACB604A236A3EE99459C335EA0435F397D64C8CF917D864EB8F74EEAC3305
              68273B77EA29B97D16005619B35909BD34D1D68B2ED3D3D3EF3CF6D863DFE316
              5116157077DF7DF7DFCBCF6BED1B87AC7AC53E165BC99D5761156FB8E44F15F1
              F12233FDE4B34B65C8AC71D75DAE79F36DAEF1E0431E902ED3AF7A17AF64702E
              6A90A7116F75A6A3E82B1A46C5FD5E2BA3E91B5DF68CA7B94C6C4C77CC867CB4
              C0854154775F4832333C1600DD9E5DBB76FDF4E9A79F7EA35B245934C089E7B4
              5140719FAEB33AAD03360883AE8CD9703C263E7F7D4FDCCE9D02C2475C7A9F30
              E0EDB7BB443C5FB77FBF4BF6EFF36FD6743CCE496575FA8E0FF128B3254B9D53
              D5A88ECBE9A73BB7F184DC81215599446CB3D0BE2AA085543DEA25D4D98A0E79
              F9860D1B9EE31649160D701290FCB654C04F7503B690DDC680B2E0B22C5726D6
              B373F8F5E39E2D972AE024C89C3CBE459C9003FE755E6EC33162E02FF56F494A
              F0D673022397D9B972B0C5D2C68E5B89A955FC32080F1E3CF85F2432F025B708
              B228807BE081075ED36AB53E191CC28A78A72C31C0613BA462AD4ACCCCD86592
              249565E1F5325B73A1C1C6123235785D97C9C9C947C59C39EB79CF7BDE823B10
              8B1287939BFE935EC156B6BF2C6D485D5936AD9357AC9C75C056966F59DA5EEE
              37542E2C32E4B5E1F8E38FFF4DB708B2E0807BE8A187FE87FC9CC415107BA5A9
              FD8D354C3064D10598EAB05B15E3D9B4A1E3B16B97A52DEB74B1FB2C031D7E65
              64E7BC9B6EBAE9596E81654155AAD86D2748F8E34EB9E1D16E1A9025E69D96D9
              2DB33C5423BD822DC41CAEE21EAA0015AA8FB2F456EC3DD6B0E5AE14A6FB29B7
              80B2A00C274CF6F518D8CA1A8DA52E6B71FA18287A61B150DE765FD57ADDE365
              E9EB1C8FDD0BB685E57EF2C61B6FFC5DB780B26080BBE38E3BDE25803BADECB5
              F3554B4CEA1CE7585F8C55EA74825099BAED04F69CF9EC68B18E1B2BFBDAB56B
              377DF9CB5F5EB02FDA2C08E08AB96EFFA34E835581C7A6EF46BA01319FC3BF75
              D256EDEF9605E70BD0A17CC4815875EAA9A72ED8B30F0B02B8F5EBD7BF7F6464
              64698C2D78BB5B296BCCB273AA401763BC6EAE51B6BFD7FBED46EA309DCACA95
              2B5F73D55557BDC92D80F41D70B7DC72CB6B972E5DFAF25805D7555BFD12AB66
              EBB254DDE3DD74805ECE9DCBF5F9BA471F7DF4790BF168615F01F7F5AF7F7DC3
              B265CB3685D822B4DE6DA3969D5F37BF2AD5D30BD0EAB0DB7C48484BC4D2D95F
              7B8F131313ABCF3CF3CCBE0FECF71570279E78A24E3D3AA14C7D56311CF67523
              BDA40FA99CB2B4DDB2622C6D1DD6EFE678B7ACC8E957AC58F1D66F7DEB5BAF70
              7D94BE014E07E7C55178738C45ACD461242B55E3A365D7AB53863AE028CBAB6A
              5F9D34BD48A82E432C67D3EB14B1934F3EF9CFFBA95AFB02B87FFEE77F3E41C6
              302FB55FE38BB1489D4AEEA571622C5AE7FCAA73ABCEABDA57F7DC5EF3EA353F
              F15A8F3FFBECB3FFC8F549FA02B8D34E3BED9DE2956E0CA9A7B9B0864D1F1BD2
              8AED0B81BFEEB57A559B75CE2B4B379F5287E5542420FC8732ECD597294CF30E
              B82F7EF18BBF2C5EE9EB63AC8675FE2D933A2C04B133406CDA5E1BB50E80E692
              C742802D26A13652FB74DDBA75E7B93EC8BC02EEA31FFDE8F1E2289CAF9FF60E
              01CCAED7913A765A3712EA0873C9CBAE777BAFF3AD22ABCE89DDB7DD1673E8D9
              8F3EFAE8F96E9E655E012711EBBF9020E2B131BB8D2566EBCC67EFEF86D5FAD9
              F0F3C19055F9CF058C31D52A4EDF6F6EDEBCF944378F326F80BBF8E28BFFFBC6
              8D1B5FAAEB31BBAD8C55E6AB21428C68C1CFFB62C7637985A41F20AA738D5E6C
              D1D076894C887AFD3B378F322F803BFFFCF3370ABBBD03AF6A80D4B1DB6CA5F5
              A242CB801C4A1B2B63ACCCDD962356A65E1BBE9B74DDB29DED74765DDAE3B95B
              B76EFD0D374F322F807BFAD39FFE8E356BF4F58BB9C418CE4A2F4C57E7D984BA
              5256CE2A46990B181742AAAED70D8825C4F55EB1E74E70F3207306DC45175DF4
              7219877B83AED7618F2A996F27212675C156D529CA986C3E40365F402DCB27C4
              6CE69C75E2085EE8E641E60438F14A579E7EFAE9EF9FD06FBBBB7A3715DB5E4C
              E915786579F5FBFE1632FF82E57E4654EBCFB939CA9C00272190B7AF5EBD7A23
              0AD50FE9E631BF5EA417B0CD070B2F86A351B7D3C7184F40F7F7326439A761AF
              9E01F7D77FFDD7C76DD8B0A1A7E9C983C46EF6453075D7E7EBBA31B18DDD6FA9
              62E662FF3A09EA7FC0CD417A069C8CB7BD5D54E992F9AC98B93047E839D35EA4
              17E02D4607EA77C826769EB0DC1B1F7FFCF19F703D4A4F80FBF6B7BFFDAC152B
              56FCF65C4218BD481DF5DAAB771C1A97AD92B9DCCB62B17C9DCE52E6F8A9485D
              BDD7F5283D016EEDDAB57F303AAA0F5FF5B7D2EADA6FA17320DD802E74BE4DBB
              504059286FBD4C4AEAE8B98F3DF6D8F35C0FD235E06EBEF9E63324FAFCAA5E2B
              BEEAE52BFD90AA1E1B922AE095ED1B6499AF7A160CF4C4725D034E2AF85D0BE5
              FAB3C480DA8D84D4C96200A64E50B69B4E51560FDD980ADD78E3AD56EBC7B76C
              D9F2EBAE4BE90A70FA592241F62BB8427A191908BD8C269626F634799DB42CB6
              BC8360F8F75BFAED584C4D4DFDC5EDB7DFBEBC9B73BA025CA3D1D8349F1EE97C
              79A5905E196B2E01DEF94EDB6F9967D3658D84497EBF9B136A03EE8A2BAE384B
              00F7EBDD344E1D26AB3AAF9BB40071AF60580CE760AE3257B3621EAEFF56596A
              675A1B70CB962DFB43ACA3D0DDD80E75653E403A9FE19AC5025EB7F7B0585EAD
              90D0BA5B6FBDB5F643D4B500F7E52F7F799D64FCD292C1DD5952F5169F98C440
              D32F768CC95C83A583C08E0B0540BD8E0C00D41E71AA053819C2FA79A9C459C6
              615DB0858EC796AAFCEA3E1658F66AAE6190BA1DB4EAFCB95EDFAEC74462B267
              DC72CB2DAF7235A416E06438E37FE92F3758DD9B9A4BF0762E6AB2EA9D7075A4
              CABEEBB5D3F54BCAEEB9EA3CFE2D5B0F89BED6569C8737BB1A5209B8CB2FBFFC
              DC91919153DD3C489DCAE825B65427BF90F412C8ED8525EB8476865D245CF6D3
              975C7249E5CB0D2B012774B9099E5F95FD56C7768BA950DE57D640A1F5AAE066
              3F1A78AEEA793159B06C7B2EF294A73CE597AAD29402EEE31FFFF8B1C26EFF39
              746C3EBCA810F8EA82AD5B99EF061E56969A6F3380CF13967BDDA64D9B4A3FA7
              550AB8D34E3BEDC5F82451D5C562C7EAB05B2CBFBA40ACCAA7CE39DD482CE8FC
              64963ACEE0F8F8F8AAE73FFFF92F284B570A3831067DECAD2CEE56675F15BBC5
              546C9DFCB21E461CE602D67E83B99F52A54D6C9AAA7AB7E9F457E2B5A5AFE38F
              02EE820B2E38533C8FA7B82EA46E01BBC9A71B66EB261D9727669BD6C96321A4
              9BBA2BCB23B6DD4D072C03ADAE8F8D8DFD62D9DB97A2803BFDF4D39F5BA64E63
              85A80248995AADEA8165375FD52031D6CB7A089FCC971D54277D5583CFA7CC87
              8D2C8073471E79E4AFC5D245012795FAEBF35100ACD751ABB1F475556EB7C089
              E557378F6ED4F67CB354AF1AA3EEB13A0C18BA478DC92D5FBE3CFA74571070EF
              7DEF7BD70B52CFC92AECAB504357B15DD5CDCF95D562D7A8331DA94E23822907
              6D06485D50C4F6858E5591402C3FC1CEB9B14F9E070127DEE94BC5E3486D4142
              368F4D13DA57A65663A00EE5C740ABDBBBE723506B8F9595BB6EB9E64BEA82A2
              6C5FD9FE50BAAA6B487864D5FAF5EB830FDA0401B776EDDA9FB3DF170D357656
              4355DA7D55529755EB4AAFE9BB658D41926E3BB0DDAE0254D5F98A1DE9E8CF0F
              9D93063249C45938A7AC20DDA8D9329568F75531645585D595BAAC37D76B0F3A
              302155E5AC73DCA6913A7E4E28ED6180BBF0C20B9FDD6C368FE4CC6CE6A1ED50
              AFA8523D552C52D6D3EA5C23766E99940DD9F503400B05CABAED58B65DA7AE21
              A2567F3434FDFC30C0AD59B3E65CFE92724CAA283B06C0AA3CB31E55B1CD8765
              3EA62C75A36EBA514355E9E743CAC05405B45E4530B444F27AA6DD7F18E024D8
              FB63F6E23136B10029034BD9B9B1F3AA546C48EA00A357F0C53A4EBF013317E9
              A5ACA176AF4A1B3A5758EE30C7E130C049A5FF482C83B28BD66DE06E8057768D
              3AD24F20D4A9975EF29B4FA99B67D9BD840883B76D3A16C1D2CBECBE5980FBCE
              77BEA3AFD83CCBD52C588C4DCA58AB1BA962BA6EF3EAA794759485921818ECF1
              D8B6CDA3EA3A65F9A8885A3DF39E7BEE59C9FB66016E7A7AFA5C0E87C480133A
              5696CE16AE4C85665D309D5D8F5D2FB4DE6F59C8EB86EA219426B45D87DDBA2D
              0344B03436353535CB8E4B4D82D3AA22F075C0123B56966F373714037737F956
              3550DD32956D979D37D7FAE073BA4D5305CA581B56A50D8968CC59B3805373F0
              45B113AB98C7A689B15D9D3C62D78C013A746E9DFC43E5EB46EA3C2ED98BD4ED
              50BDDE6FAFC742ED51755EABD59AE538CC1AEF1286DB50679C1017B5E18650F8
              A19746E9154465436E289B9D7E149A8E5E3528DF4D28652E79D565A63AE7DAFD
              B18EDB87CEA363F2FAA62D9F7187E1BEF5AD6F9D21077E14DB5501D03A345BD6
              0B2D1BC6962E6FCE95A92BFE9D6FA9CA77AED7AD7B7E559DF36F9DBCE69A4E8E
              1D71DB6DB79D82ED940E3C4596913A9995A9BA10287B014FA4F05DE565D937B4
              BF9B3C7A49DF2F80DB6B54D54B55C78FA50DB57315706D7A711C3AD3CE3B8013
              0FF56C7B2156AF65800A15ACAAC03190C6D2852AA5970AEE25FD7C33C25CCFE9
              F67CDB1EB173EB1EEB56646CFE4CACB3D3F0E336619D46E561B02AD0D5055BEC
              5A21F09595B12AAF589AB9822026DD96B32C6D55DB84D284D6AB405755E63A65
              3F78F060E7C9BF0EE00438A78712C754115F3004BA1830AA18AF0C9CF6BAB1FC
              59EA544CAC93F42A658D58F71C7BACAA9384D2DB7DA174B1F53A755B47F41C61
              B8932FB8E08231DDF680938D7502ACE3BA9DABCFFB1574081A8700153AB797C5
              5EB74E45D8E3BD3ED1D58DD4A9B33A79CC47FA10F8EAA6AB7B5D9B9ED7F573A6
              A79E7AEAD1BAEE0177E491479E339737FF84D82E049218807A91582FC47AEC9C
              D8F15E7BEF7C4AAF7553D5A9EDBE50BAD8F1D876B7E55BB264C94FEABA079C04
              E74EB3435A752E106AE432A0C50AD36D4F0A9D1F2A47EC9CB2FDDD5CBBD7F3E7
              0BA8DD000DFBF937B63ED73609E5373131E103C03EF0BB6CD9B2F59C483F410D
              89BDA7231440E55F3EBFAAF075D2D86B951DAB93C6AE97DD4F37F9C7AE355F52
              554FBDB07BD5F13A2C57C592E3E3E347E8BA4796B0DB194075086065AC51C62C
              B6A754EDAB62B03A3DB09BFDA17BB3E9EB7684B2EB848E95D569ECDCAABCABEE
              3174ACEADCD07A5539394F6C4F4E4EFA417C0F38F1225695353A6754569818E8
              42338843000A2DA172740BBC3A8D5996AE5BD0D53DB70A74556DC269CAF20F6D
              97D5611D80961D0FED1722F35AD4AB54B1E18E676054DD606CD8CBAA555695D8
              AE1AABAD6ADC903AC439F6982D6B687FEC7EEA4AB7E787EEAFDB51105BB7A1E3
              65FBCA005E373F3E66F30E91829869CB2FBEF8E2A394E11201DC491CD288B152
              D985B0CFFEDA8B237C92D5E8BD55D70DDD6C59596C3EB1FCBB955ECEE9F51ADD
              B24CAC8EEAE65376BCACEE436DBB7AF5EA75E9A64D9BD6E9B7EA9140C0D749C8
              B1B5D045CA6EA00CF9B15E103A1693D8CDC6D294A58B9D57C6147C2CE658F176
              D97D55EDAF6AFC501E75DAAAEEB1BAC763D704D11C3870E059E9D8D8D809A1F1
              D2B2060D6D5BB51002131F2F8BD7856EA2AAA1CA6EB86CBBEEFEAAC6AEB3AFCE
              B5B29A1DCE9E63F785D2D96375415475ED3260F3FA8A152B469B6BD7AEF58DAF
              6F4A0A01010C676D2FDBC32DE86205B4DB219BAEEC26CBA64DC56CB8508788D9
              9BDD843BAAD2DB3A9A6FE90668B1F53A00ECE6BCAC84E546455209C82D659069
              C5F0768889CA101DBA5056C162219B2ECBAA554C48CA7A6BAC8C65FBEBE45D75
              2C96BEEA5EAACEB5FB42E9AAD67BB946190043E0234238A2A9F61B27D4C647E0
              977BB23971D6719BB64EAF8F55502C801C92D86C5D5BAE50DA58D9CA3CF0B234
              758EC5CA5155677C7EB7FBEB00B32C7D59792CF0AAB645D62AB25633CBF06FC8
              73B599D5ED6D756FA08A51CB8EE138FF965D2B76ACCEFED8FD57DD7B59FEB14E
              D8CD7E1CE35FBBBF2A5D59F9CA80156B0FDA37968A57BA82D98D1385D46B5958
              A30C08DD08038FF7D5A980587EDD80ACAA2142C7BB055D15F0BA296F28DF3A65
              B0E942C089A52B035A0C7882A791A6AC2CB1196A6844D52AAB57ACE31799625D
              A5AEF1DFCD4328007EE87C1CB3D7E7EB76FB100BE7D98D2311CABB97EB57E557
              E758B7DBB17DF658AFEC4604B252196E96D3A06063BB4DC58E4020037BAC6E0F
              B3E9434B2CBDCDBBECBC3A79C4F28CE551B62F76BC6E63C68ED7055BACEECAD2
              97E511AAD7D83E7B2CD42ED3D3D3EB94E196851AA378A9DC2C070220B3AC6719
              053D1779B0F41A42B14CC6EBF69C2A8701D7B7E5886D87CACBFB62EBB1F4A163
              FC5B47EA00BDDB73CACEAF03B2B2B4C5FD8F2AC34D84188C41C327C7D2B2B311
              2A705941633D227683764ABB73E53D395611B174A17CBB0145E83AF325B186B7
              69BA3D2796AEAA7D42F5136BE3C9C9C923D383070F4E308B59D080A5781DC35F
              EC40D4BD68DD862BCB2B946F590576D300751B2694B60ACC7301620C0C6569B0
              AFCE76AC6EABCA14FAB579F0F1A60C6D6D0770F05D06560FD62960E701A30448
              C3DB5642AA2F764355EA0EEB65151253B5365F7B3C74ADD0B9A17CCAF687AE57
              56A650DAD8BE3A69CAF22E23821061D4491FBA86C47CB73505647BF92003090B
              F603909C06E7F1BABDA0B5F320DDD83465369CCDBB1B3BB10A40366DA823E09A
              B1F3B85CB1E375D9A4CEFE6E401A024F19C8EAA45109399372FF53E9C8C8C83E
              0B165B31D639B09986ECBAD84DD99BAE7353B6C2623DC89E1F2A4B5579AAD6CB
              F20CDD572CFFBA52557775D386B6EBDE6F2CBF505DC740A9A2A658530CB949FB
              89233DA002D5A9C73926C717E5E94B56C5625F08C4BDAA923246E232A11CB198
              5A8C7962D7E0FB8949AC4C21462CBB76ACC1CB80500768BCAFAA33D725029B36
              B44DFB0EA4F267DA16886F3C4495B6909621CB1C89B2FDA142862AA7ECC64279
              DAFD564265B2C7AACE294B1FBB6EE81EBA055BD53D85D2959D5375EFDDB4895D
              14174D61819DCA60DCB3F4D7068039AE867D21E7006943C7ACD46137E467D763
              D7B5E9CBAE1BCAAF8CC962C76C3E65E942650995BDEC9C6EF79775BA6E00D44B
              3AB3AFDD941BDCC54E00DB6B0C3095982DC7C75061A17974EC84841AB44AFDD9
              E3769FAD64AB9EB8B3F0361FE7F36D9AB2EB864056D641EC7542755A754ED5FE
              18B042FB2A8072D8B1D073CCF65C5E8AE1D2870EFB9E16D421626D1C738B154E
              85C757DBEDF00B6E62858B554AD5F1AA4A8DFDD69D7F17DB1FBB7EACCCA16BD5
              0156E8BAB1F2CC17D8BA4D17BABFD8C358B23D95EEDDBB77D64E569D701EEC0C
              115B281B00B685E559269C3634FB2424551560D384CEAD535921DBB3AA1CA1B2
              C4F6B99AF712CAA71BA0C5EEB1ECBAB14E115B62E7978DBBCB58EACEE6B66DDB
              F4C97BFF6155D872602BCB5A2AF05CB1CEC260C5C5588D5AA9B2B5381DD2D451
              65B1FD7C9EBD6E4CFDF2769DFCCBEEADCC2EB4EB659265F53A66088CB1E3A18E
              56D661BA01AA8A804DB1B1BFB967CF9E2D32BCE5778E8F8FCFB2E5789D9F7960
              BB0C8DC80055B1F61FDB87368FAAC0B0054A685FAC61AB1ADCE667CB51652F96
              01BECC01A8B2ED6265ACDA1F024E284DD9397500143BC669AC0613D03DD1DCB7
              6FDF13FBF7EFEFB095321D578875146CB804E7E92F7BB62103DFDE08841D0C48
              ACA12DBB95392156CA401903695959AAF28E81B1AC2C55E58EEDAF03346CC740
              53B55D964625641E619F6263D7AE5D7BD3BFF99BBF5186DBAE94373535E51746
              263264BB4B4FB63381ED8DD84A4023C109092D319B2EF41BAAE03AE9CBD2C6F2
              0A5DCB0234962E76FDD0F1D8123B27762FB13475C016FB0D81285456262AE007
              78117910AFEBBA5A594E061D3CE0F45701A809B12093D0C59129D426173636F3
              C4A6B1054721CB9C95BA60B38D50D53065EBB6A37178C05E3776ED32F0954908
              206540AA93A62EC8F83CDBD942E4C3C774514CEDDEBDFB61FFC89664B0457F15
              6C88A5E93ADB58319B8C856D3E9CC70566278463737C3EDB775CF09083C21514
              53BB559555964F5525C75467595E9C079F532621805675C0AA3431B0C54059B6
              A85862812653E23A74E890EEDBFDD6B7BEF54E0F3871081E40E528D0F4D141DD
              D6C42A6CA715E93B15CEE3AC9A1EE3B23C3E8B4AB7B61A3710832A0434EB6840
              EAD8731600F65C9B3604B63250757B6EA86C75A40EB878BD0C8065608BADF376
              68BF0D8D291E74D1FB1E1D1DFD9EEE6B1607B64D4C4C7412423DA2B15169089B
              E0211B66245B089E0010AAB810702CFB71855449ACA1EB380721D086F687A44E
              9E7C7FB6AC75A42ED0B01DAAB310C862C742A08AED0BD9736038105641603EE0
              EB0127AC76230383471B541468FC921B7D4930A7656002AC002C178E5534EFB3
              6942C0E3CAA91AA7AD0BB610A0CAD639FFD8BEBAD78B9DC7E943EBB17DDDB01A
              1F2B03951D5DB2400B819847A6404ABA08E81ED4E350A9372A1A1589568521DC
              0131A80DDE2C7B2A2AF615AE00251FAB5BA9D6CE8B498C9DEA304ED5FEBAE7C4
              AEAD12025F48EA305A2C9F3AAC16025B55FAD0A2621D466E2321B51DFAEB5B7B
              D3A64D3B05044F004C361378AAF05CA19B756126B43D000280706885D37573E3
              9C26E43587F2E0FDB1F5AA060B1D0BA58B35542CEF3A0D59768F65D7ACAA9B58
              FED6D30C2DDCBED8E6F398DD54042BD7F9FD54CEEFE1623623FBCB805327830B
              0900B26A2C2ED84907F0613B147FE39B8AC5FC42DB650DC7F7D5EDBA6D809094
              A5899D532559566D6FD96355F71DCBA34E7E582C8184AEC55A64FBF6ED5BF5B7
              F3F94A01C96DF2F3224626CF98E58CE1992A88D873E58769708C4325C8CB3A1C
              D0F77C3348C7BD8E7B0CD2D963F646ABC4AA56CE97F3A83AC6151D4A6FCFE945
              E60AF618A062692C70432C68EDBC5079350677E38D372ABE660027157307D809
              0D0D97168B1EC3982AD428C00580E06D4CB6C0CC6AB017B1DF363A0311C0B779
              724332F0CA6CC23AF654CCF8B7608B812C947FE8FA75C5022476DCFEF2F1D0B1
              18B06200E425A455425107C5886A401DAF3FFFFCF3B7EBFE2615E01A5BA9DA78
              CC3CD80FC0E0C2BACEC35D009E652914846F8803A80C4A9CABC240AF12664BEB
              2D3378AB58B00C3CBD9E1B6A982AC96A305A285D37C7B32C6ED3B159836396DD
              42D781ADAF415FF9BD0AE93A80131DFBC8AA55ABF6E8DBA6D9636536E3802F83
              0B1746F844052A35332A12E7F37156B13136E3A031ABF9AA381F2AC6AA5FE415
              CB87016B2B35243110C6BCD95E25C652364D15E385C0A56201C66D8DBAB40EA1
              BDA66240D5A882AD08935C8FF49D5AFEC0073EB059123DC463A3DC5860362E18
              5F00FB7870DF16CE523083C91AA0DC836CAF621516A27BEBF9DA6BDB747C3FF6
              7C6B10DB7C6CC3C5D6E70368B16B87D2603B74BC2A3DD709B7A15D87703B418D
              022BFA2BA30CD720ADFDE6FD376539D33F3F58A84C3B8C854CC14AAC5E5598E5
              C01CFACB435DACF6424FF6C79C03AEA898F0F31836FEC7E775E358F039A132F1
              76599EA17B895D270496D03A6FC78016537D3100C61C82181BAA207486194788
              6268BBEFDCB9F33AA44B4DC1BE590CB41E96392A810B81A94CD0D70023CEE30B
              73DCCED2AFCD9BF3B0EC876B97B127A78931518CA5CAD2943146D9F12C8B3364
              48EA9491D3565D2B949699BBAA2E42794158ABF10C238868CD5D6F7EF39BB760
              7B16C3EDDBB7EFD265CB9665922801A381E5B877329B611BCC06E6B3933161F8
              03F5D8CFC798DD5895B3B16F4320603256AFA1C6636701FBCBECAE1818380FBE
              4655BA5EAE63CF0B81AE0C88CC447CAD2AD0D68975621F0006E08154C856BE8D
              AF358BE13EF4A10FED949FFF002DAAE1A7820C396354A6B5DF900E05E302D939
              765CB8188D23EFD0033D650C06B14E8EBD46E81CDB109CA6AC116C5E59D61B93
              959D17CADB96D3B297B575CB6C639B2E66C3723B33BB011394E6722EFF612E9E
              14EE3AB08E66A2CF3BD81E6259826674CE021EF702069F829941CC5E28808975
              5C03DB90BA9586B49601638D150350EC9805430CC455E0AB923A40AE2A37F65B
              0056A56790717BEA121A69623B5AE46B5CC6A6BD3129CC6592F0B7D898C705C4
              DB38ACE06C9CDB82623A13E5DD29108745582DB2BAE4EBE0A6623345D81109A9
              2A66655B9E90849C029B36D409913E947F1DC7222616BCA163B15FEEA8D81F03
              581D4DC0A0530945298AA7B40EBCFEF5AFFF265FFB30C0891DF7EF4B962C99A5
              C6D0C88A669D9AC415C780E042C373E5E0B18AB5CF6C65846272F08491376C3A
              B62F717D0BD6BA5399B0CEF761F7C5EC3FB63559CAF2E5FD65520634EC2B035C
              089CAC55F897F75B00B243C74C67F7EB02D693B6F9AA2DEF61ADF1C10F7EF009
              F9B9970BCAC86575884A63BAC53E56A905DA0FB3F142FB903654A996DE5136A4
              613B93CB1ECA23966FE8982D476C3D744ED9F1D8F5CBCAC579C6D8A8ACECB6DE
              427657ECFA1CEE62D26086636751D63FEB8C1CC6704586DF116638091782FA63
              8701C7D8E3C4311B73C3AF7D3602E741C582C5786403C7E10107CA3A4B9D72E5
              864617F83CCB4C3166E36D3ED79E1392188B559D57750EDF2BEF8B75883AE783
              E5189C9611396F0629426438AEED2121B6EFD87B08EA1BC9E8B2E2374F540005
              83F91C4D6674E362A19E678D76E3C9CCBA597BCC3E3566D7ED3697C136469583
              C16943C7430DCAE7D9F51843752B363FD620B1B2F279A1B284F274EEF0C70011
              E0E7EB86D4AA69F7DBDEF8C6373E60EF2308B8071E78E012C9A80D6609798B8C
              720D16F3CDF0F1D00D318DE397D9540560C635AC1AB6E5085538A78530F0636A
              A80C845867E05AB0C7C056F71AB16BF162ED689BCE9E13DBB6E784DA8E350413
              81059FB171AF0B612B08B88B2EBA48A7035FC38D850B81E5780A137E39C2CC8D
              0E5081C5B08D5F0B6C3662B1CDB6A3AEE306CBEC49DEB6C040196D99F9780C40
              F61E6DC3C7D2864056766E551E75CA15BB879086B0E786408AF64E02234FDC19
              64F9BC0B48D485136FF50A648046E551047E8490A79D7303B2DD865E11B2B598
              E16C4FB3EE37D6712DDBF362DB5C26DB8B2D13DA46A90324AC87F65581AC2C8F
              10406CD962797247E3FB44BD70FDE3B8F552B9EEB94DD8B9B3A053D9BE7DFB4D
              2E200D179133CE38A3353131F1EB98DB168A4371688281C5C7710EC7C8188876
              CA931DB2C23900B66EE3DC50AF465A161BCE60672116EAE0F34279C58ED74D53
              26A1FBB2BFA1E3210072A7E33A65D0C64C8B98BDC6C7AC7DAD8B0C163CF696B7
              BCE58F42F71665B83BEFBCF35A19DADAC91E881DDB64B681AAC5B63D8FE7C971
              4558A783D521AB61E48F1BE7B97AB12116AE386E046636066A1D26EB86B9428D
              58B594D9A5F67A2166B1D7B41D38E4E471BB6659DC4EB565B3363DCE936B7CC3
              45240AB82BAFBC728F3803FFBF0E6DA111AD9EE70B83A178C80AC7754C964116
              6BD850A55B750000DA9EC565C371948355806DB8D0B562C7BB055D1DF0C4C066
              AF6DF3B7F5C2650A951BFB38BC617FD9AEE6B8A82D1BDBD6CCE0A86731C73EE7
              22521A86974C2FE246C3B86ADB7826DC33EC94741BD0E5F3F06B4163A3DF7A8C
              55363B190C406E185CCFF64206A35DB862710E372203C336720818F658D562CF
              B1F940421D83EBD1828CEF3FD44119840C300E83D9FB0E814FD30BB96CB9EBAE
              BBBEE42212B5E1548E38E288C756AE5CF9DB7251FF1E08FBBD067E189AED210B
              42AE306639084FC6E44835AE899E171B4E8233C3D762D6651300C76C996D8386
              C0D3AD746BBF71B9B1CDC75036E4CDF7C3668365B210586DBE0C28D61EA18E88
              630C343C32BA67CF9E4FBDFFFDEFFF7CE416CB0177F7DD77B7CE39E71C05D60B
              7101FBE81F37B6ED6D0C3C6EF058EFE57421C39B2709D8D7457003F0FC381666
              3B3E17C7F83A65E7D79518684379DBF3B86C5C3FF6B70C58210F9DF731EB5BD6
              0BD9C19C5E85A31330BB76EDDAF5FACB2EBBECF1D8BD557E4C617474F46392D1
              6E54927D71215494A5565404AB3DBE011498555C8CEAAD8D8175A46999F1533B
              1ECBE5F4374D60B5A31AB6535816E17C43E962E7DB7D9C077E2D8BD87319A816
              2C0C8A501979E17BB5EA994D93987D8B36463EC470776CDAB429180E8154024E
              27654AA69723F00AD061780B53D2D1D0969DF866202830CEC13683C2562683D4
              5664283618B3B3F81A5C9E50A3F0BD303B841AB16C89D97BB66199A52D10389F
              909A63A6E77AE77BE4360AD9B00C62EEE4ACA279E1E14DDD164DF8E7AE42AA3F
              179337E0DFA2D0766401EB981D1CAA4C15CB72D8C6C03D2AC30E95F1B90C3A0E
              91A860C200F2423ADB09B887236F961858B82142C67388A96C47B34CC4C0425D
              59F0D9BC2CD384BC7E5B0E8CCC709889DB83C34A7C3E879F6C87D5F6E6FAD063
              3B77EEFC3757210D57432408FCB8A8D6DF92D5F15003D99ECF0DC9015B760042
              E75ACF158DC0463F573040866BF24888AE63260B16B6CD4276549A1EFECE3BFB
              E4975DEC7D5BA96BF7F1F931A7013633DFAF0528A70F019A81C37555A63E412A
              36BE6A3CFE7F7BDBDBDEF6D7AE426A31DC273EF1899D72D18FD95816178A8D47
              DD460F60BB8983C34CD3B61761013B29E3F1E367CC74B682F9182A15D7E3213A
              7B0EC7EAF8819B10C35896E2BA0881C42ED66EB4F9B01DC6D765B516EADCCC68
              D69E6380F13D5B1685B07A8539D5A2C0BA3D47DAE853AE86D4025C51E02FB31A
              E382B2AA440FE0C2AAF09C3A7FE1F4F0971832BB852A1A15C1F65E4805715950
              213C63986374D66B63E0C5EC45943B642F8540C669EC629989CB6C3B11F6596F
              9B6D620E69E03C76E2420E9C653ED46BC86E0F753CF9BD5F86413FED6A482D95
              AA72DD75D73D70F6D967BF54D4D47A7F22BDCB37A4A658ED857A24D2B3FA4823
              EF21E1CA4665726826A4CE7812285FCF0AF2B1E943C2F7667F4320B1E602971D
              BF5C3E7BEF6CFF86F2E1CE8FE3A10E1AB20743E978E1E78CED8C6DFB0CB200F3
              83BFFFFBBF7FA9AB21B5194E452E749E3534A13AF9A6B827841E9666705AB5C8
              EB4817721298A598F6714D7EF313CE437A80CBB2198EC16664407303E37A2136
              B36A0EBF6C60633F1FB3E7D9100E3337EA94C18DBCF57C66349C6B01CAB3AFB9
              4D99E198D542E603CABA7DFBF62FB89A529BE1548E39E6987B962D5BA64F742D
              F12717B34498D942ACC58DC92A06156A6F82D98FF3662781F362E70065601058
              E31E761A1688654A06202F1CEC66360C95D9DE1B1FB74CC7E560260B018759CA
              3256484D0360FCA41CFF72788A3D7BEB89DA0E268473DD3BDFF9CE3F7535A52B
              C0DD79E79D53CF78C633C665F5795A187E25977D4D7E285ACF3787866326E25E
              A9C2EC661B31F434189F679E8D3C8CAD2CF0AD5AB2958B6331B56CF30889BD8F
              D0F9B61C2180F135ACB9C0369CD50E38CEF5024663D0B146B060632DA3EB32BE
              FEBFBEF9CD6FDEE86A4A572A55E5D1471FFD3F82EA7D08FA5A350A61F5D20E78
              4B45618395C0E7855C7FEE790C24809C67048361E1BC70C358AF8BCB6E5CFE8E
              9AB65FE9B18DC28DCF6C8FFB425A7678427692ED14B63E712D0618421CFC1B33
              0BA09A597D86406ED52996A22E1EBFE38E3BFED575215D319C8A8CAFEEFF911F
              F991E384D1CEC18D2ABBF1F3A1D8876D3020B30D57061AC332181A8B3D5A1C67
              678555AA8DB5713EB816A761D506095DCF1EE3E3360DB3758C1942863CEFC3B5
              F8B89D846A3BB865322E1B33183A90250B802F64B731C0A176F7EFDFFF177FF9
              977FF965D785740D3895D34E3BED410904BF466E708C2B160DCC15CF1325F9AD
              993CD39759C156268396818C75340ED43BF2E46BB1CA67BB4E1FEAE6981C5736
              DB6B7A2E5ED088CE659D0BBE576E741BF2E1FA61F0E0FEACBD8B6D3D8ED11C9E
              486967D85880225C0280D93826DBBBD86789811D2B8A873E2CB6DBFFE7BA949E
              0077EBADB76E79FAD39FBE526EE8A750396834548E9DE6CD00C08D58D6B32AD2
              B9C3A3E96CC7F81B202059BB913D4D6CDBD107760C629F6B4265E33AF8B52A27
              C408A80BEE500C6A0B781E2D411DB1460088709E051BD711BE97C6B1D010C098
              BD98F9F91807F60BC0BDF7B2CB2EBBD275295DDB701029CC5FC8B2CFDA31B073
              F8C15815F430AE247608B852D886E29EC9AAC9AA44E4EB6FCA80340D3CC8C3FB
              386F803214136440B158E0A13CACF6D95E64D5CF6A8CEB0AE75B80F2583103CC
              868BC0861C33431D7107B1CE18DBA6284BF19EDE0ED8E4D8FD221F733D484F0C
              A772D34D37ED3BEBACB38E11E6FA51DD8ED95B9D0B11B3F04B6E5061AADE98F5
              78EC14206136649BC7DA6AF67ACC6CCC76FC0927060D8E875427AB50BB9F1776
              0CB85CC897BDC3984AC5F9218F9BED65ECB70159CBCABC8D72F1080503D1CE73
              E37D7BF7EE3DFF231FF9C8D75C0FD2747310311A3F28B6DC1BD49643C5001CDA
              13D0C80091AA55B6DDA01EB4E1A12698FDD8F1E0876858DDE9B9F80222AB2756
              91A86806A16D5CAB4A900F7720EE041066716CDB74D887FD601FBEB6756818A8
              D604E03A628F34A4EE19A8B6BCCC8ABC8FC7AC59D3142AFA7E59CE773D4ACF0C
              A772DB6DB7ED78DAD39E7692DCF0D9BA6DBD48ACDB5ECAC060B0598AE7066336
              0BB106AB1D54947516FC0D93478D0A475EE8109641F93EB08E6D66323E0EC785
              ED59B0043B239C1758D3D613AB6AA85B157CDF36A472B9FCAC1DD83ECE8C8303
              36B37314D91490DFDF7DDFFBDE77ADEB51E604389533CE38E37B5271AF4D8AE7
              1E58B8520100155683CC64DCD3596541B802B9422D1090D6DA4B6CEBD8511200
              86C1027032CB31D0D98CC082F3202D1363E4E3CCA4ACF2B18DC6E6BC583DE21E
              2100AD8DC7B1DAB4F6264224568DB22D4D7573FFBBDFFDEED7BB39C89C0177CB
              2DB7EC96D1072DCC0B2CEBA80000CC346CE4F37BE4000A06227B6A0003330103
              920D716C33ABE01CCB02EC10B011CF0CC660668059FBD1AA3308D427AB735B66
              B6F9A0C6702E830D1A816D54B673B9AED86EE36DF63C716DCB66D6891053E0F7
              AEB8E28ADAA30A219933E0540470DF971F45FE52CB4CAC96D8F3D31BC04BA639
              9DEE834DC63D9D599059CBB225038BC11932D0191C6C4FA17C9609182881DE3F
              8B6971BF96E5E175E318039CD526EA4785553F80C5600B0DD6B3E9C18CC7E5C0
              75B1A86DC9E0E634F27BDF9FFDD99FCD89DD54E6057037DC70C341197DD06F29
              FD826E7383ABB02D82CA4245C189E0CAE1B7A7FB4292A3C1A042DEEC8458FB8F
              81876D0039E428742AC60CDA735E580FFD26E4B1E2BED81EE232339BE05C6C83
              F9514728A375442CDBF13D229D8A0511838DC342F87A8C2DB75CF7B5975F7EF9
              1D6E8E322F8053B9F1C61BAF17D0BD44568FD5ED90FDC56CA7826F74615D7B18
              3315DB7548AB4E86753C004C061D3B0C6C97B181CE6A9181C70C8A5106D873D6
              B6C3367BA15057DCA8C88BC31F601E940B2A14212278F028173A9EEED773188C
              CC6AB867156662E46F19CE3A3FCC7AC5FD7CE2BDEF7D6FE5033275644E61112B
              52D8B7C88F7EE6A6C176850A533C2A09AA53056114CB646C8B40BD222F0E2970
              633363F18B78D0406860345C288686283DD2AB846C36CB2AEC15EA79C81F0D09
              1342F345E7819A450741D8042C877BC53A3A1FF26553440575C463A728A79D7E
              6E8186F3E9F87E59FEC4CD93CC1BC3A94830F8310993AC94D51FC73E564BD6BE
              C271A81056B1216FD03A25D6635561F5143A8FCFE7500DDB82CC582175AC0226
              81B02D08D6B2DE31EE8B41C86C8B7CB16DC1C69DCF023C300B779633827D6048
              FCE29A28A305A4EC7BDFFBDFFFFE7F71F324F3CA703EC366F33D72236A5CAEB2
              20638F143D148D0986C3AF0AD26A8FD757F68391D0D81C1846E5DB315BE4C34E
              01F778CD1769D0383C50CFAA37141E61B38101C9A06010E318838FF7F1D86951
              9F1D8060DD7AA6FC0C09DB7AA159C95A970C741AAE3A6CD130C8F8F8F807DD3C
              CABC329C8A3A1032B03F29057EB16516EBA1AA30F00028547EE89BAB6C385BB1
              ACC6B618AECFDB761F830AE50CA94C3E975538AB25061A400596810A0480702C
              34320210F13AC0A662E7B16101C3D931685B666BC381E58A8EF7A6F7BCE73DD7
              BB799479079C8AA8D6ABC48178A1AC1E1F62030B00301637004620741F588F0D
              677640D88EE37C2136C06B9D05565D1CCA40D9D1606C0FD99008E7CD8E850AAB
              54DC1BAB5A301D6F73C888D5AB8A7A92AC4643E54A4DC097CFE78997560D5339
              FFE1BCF3CEFB3337CF32EF2A152237F03A29BC06093B2310A84C6BE0C3138397
              AAA2EBBAFFC081036E6C6CACE360B0EA854300606A43685A15D8837C5D7616D8
              CE62EF4F85BD5094879911BF3CA260BD70B0051F63958A7428037BB3B8279805
              6045768698B9621D2294CE0676791F79D68FCBB2C9F541FAC2702A37DF7CF376
              7120B465FE53555A0622B31DC220B0ABD8530D8D50B041CDF139663215664236
              F4ED4885B505B99120CCE056A5B20361D954853D4FF6CAF989B43295C8B618F2
              E478227F070BD7E07C78180BF915C0FF9F1FFAD0872A5FDBD08BF40D702A279E
              78E2F5C238AF92D555BACD0C00B13615D62DC8584DD8FD0C08B018F2B6D7B3AC
              83F3D896626643E3F2B75FD168961918D0CCE41C605581BAC6F311488B34CCF2
              A833DB09D839801DCC69F8183B053C9465C15CA4B9EFFCF3CF7F8DEB93F41570
              77DC71C7E459679D75A354C64B65732C33E1101566023418F6C1AEE2683A6FE3
              383B1276DC14C2F65ECC016055C7EC87F35835A22CF638D639788A466595CACE
              00980C260503C6AEB323C3B62BEE9BED351EDDC07E3B768AFC0AF0ED90DFE75C
              7DF5D5DB5D9FA4AF805391C1FDFB9FFAD4A736A5329EA7DB9671202140A0D772
              A093550F02A7001DEC31349C0DBFB02A6495CBFB420DCBC71B341D9D4738D8B9
              00AB84F2659604438381703FDCA1707FDC0100324C4FE2A9E40C36E481772C33
              E854186CC5B13FBAE0820BBA7A0AAB5BE93BE0548E3DF6D8AB27262694E5D659
              86B3B13ADE4623A833C033829985C078AC4A19A076C227CEE3EBA8B097AB8273
              919E6D1CEC63960063E13A3C56AB82B46CD3717C4DC50211EBB836CE6146E35F
              56F5B826DB6788B9B1FD476C779F80EDD5AECFD2F3330DDDC857BEF29543FBF6
              EDD39B39643D2ABE696E443414BC5530867DCD017AB97AB3BCCF0E78B3FAB0EA
              9341C72C683D49C4CE38108C10084FDEE430484C7DB2ED661D1A801AC0C23180
              0D7501E6E2C02F3B0F0C3C7E1506336D01423DE9C57ACBAECFB2200CA772FBED
              B76F167BEE8054D88B787FC861506156C2775A3198CD361B1A48470CB401783C
              12CF2C403D5B80F17571AD908DC7EC8B060D95DB86260052664A808047189016
              1D8343236CD331D8424C876B230DAEC7AA963B3581F08F3FFCE10FCFDBF05599
              246E81E5D5AF7EF5BF4945BD8083C0A86C5EE7F81742203C5D09C7105F835D85
              3CC1707A8C418AB4366481FC712E5F1F6201CB43567C3FB836831C60641644A7
              8209109AFDC1F3051928E880CCE2703C20FC964AB62D1984B2EFFA8F7CE423CF
              740B240BA2525944B5BE5E6E7E277BA456CDB65AB33FFCC11303D95E610319AA
              85C308B0EFACE3C020E0D742E07A7C7D7660ECA03EAF43F8FA78BCCE864B100E
              0148C1346033FBC824CAC976A01D806F51E058F7E1258E6C66F052A43F2879FC
              925B405930950A9150C96E19F6DA2A15D399ACC962B7D128D6FDB7210B80828F
              83E138180AE0324BAA84D42DAB55B6ED6C59D92E649030E3AA308B01FCB041A1
              FE507E66401BDA00E81454F0D0A19AD9C66556B42191229F3FF9E8473F5AFB55
              5BF3210B0E38151985B85E4621D488F9190B30151B4763AF95432010B6AFD496
              D3868071CFB34F18A4F67A0C2E080F5D59FB8C19987F556CD91888EC24B02DCA
              5E2E185B85E36BC80FFB6DB0173341785E1CDB6AAC1164DFC51FFFF8C77FC72D
              B02C0AE05404749762867008042ACC20CC74D68603D830D6CAACC61E2E6C3936
              CC55D0181C5AC175510E0EA558AFD432AD0A331D54AF0DAD0048DC61C06A6C16
              B007CF8E870D85B077CC2A98AF5B00EEC1FDFBF7BF42DA60B75B60E9DBE07D1D
              1100BC5C7AE555D2181BAC7AE246444F8641CDC6353B0EDAC3C7C7C7FD6BC0F4
              170D0BA743994F1910AA07F95BF5160A57B0130040B44DE0986D4315663A1E1F
              E50036D23103B24A8CC5DB3878CBA0B2F141DE46BAC71E7BECB7BFF0852F3CEC
              1641168DE1546EB8E186DD679F7DF677A512DEA0DB65EA4E85D516988E6D3B30
              1C580D21090014EB00288403B60C285CDFAA785CDF7ADAD6DB46DE0C3480CD86
              42B0CD6A1BA0823384FB47F807361F4C071EDB4519B10D00EEDDBBF77F5F7CF1
              C595AFB7EF972C2AE0546EBCF1C68775C2A654F0F36380C32F2A1D6A8D4107B0
              211E07F5A90DA7FB50F1BA0E3B864320681006980AAB736CF331948D3B05872A
              F85CF62A710E8F13B7CCA80580C42602CF00C13510006615CBDE3BD873CF9E3D
              DFFAC637BEF11B02BA29B748B2E88053B9E9A69BAE90F1D623A4F2CEADB2E7D8
              D6E1B152FDC53018339D4AAB188F55C1382B3F7462559BDDA7626D3BEB60F028
              852D2BCA807DACFE6C7E9C07030A5EA90ACAA8625F2C6807E789F51ED8B56BD7
              CF5F7BEDB5DBDC22CA82C7E1622215F7075271F7D8864463841A896352681005
              9936104087F08418C99DB1593D0E16D406A597ECCDF26861D771A0D4DA692160
              62B18E03DB53D661413978D809D7D732D959BE6C87725017D7B3B6DBE38F3FFE
              1B975C72C9A2D86D2C03C1702AB7DE7A6B4B584E3FECFA8B52F9AB2CD3311059
              E5A9C09E61B031AB6943E84C60B01046170048008F1B0AD7E1518790830061DB
              0BC799E9A0266D07820084EC88B01AE53C585DEAC20FC630D381DDC4897AD767
              3FFBD9BF7703200303381571D3779C79E6995F9306FE55A9E0313EC68D13B29D
              D0FBD96180EA61F64303E1B9506622C4EED806C3F52CE0912F978903D0CC3438
              CE1E2FD2338878848183BDE81CA807D89F2A36E6C6ECA8DB72AFEFBBF0C20BDF
              E90644060A702ADFFFFEF79F10A65363E5C5652C07B13132565F6CABA9B30095
              A36C87E11F3D8E4710A7E8AD9DECC5827958FDA9D809010C327640D81CB00CA5
              C2B138BE06331CCE45992DB3B1FA44FE72FCE65B6EB9E555120669BB01918103
              9C8A30DD553212B15C2AFD27624E04B3071A87ED285EE7876F743FD42E8086C6
              D6D81DCE814DA482F3F06BBD58FBCB463D3B13F8E571541E41E0316100D37AA3
              3CEDCA8EA322D85B749EDBE4F7255FFBDAD776BA019281049C8A80EEEB3212F1
              34593D3314076301606CE0548503C2683CD873BA5FD711180663A8AAC52C130E
              BAB27D670101A0B01AE7F2B2CD8570071BFF283BBC6C663F7E70082F9BE1EB83
              9D09783A92F0FC4F7FFAD30FB9019381059CCAC68D1BBF2280F82FB27A6488E9
              D83087F0D010A69B235C82E9483A12A1FBF8A53150AD601208CE5161E083A5C0
              7C48CB43706C8B8119F5DACCC6BAADA0C731383C003A3A108EABB05D57D8693C
              A172976C3FFF339FF9CCDD6E0065C1E7C3752BBFF22BBFA263ADD7C87234C7B5
              2060065673F02EE18122408CE350A5BA3D3131E1CF6710E21CE48D4687A3C1F3
              E6D8BB85FA0658D80E54D16BE8B539D0CC1346196C1C4FD434009B0A874F4885
              EAEF94A4FB7901DBD7DD80CAC0034EE5D5AF7EF549D248DF9286F0AF026355C5
              81528EECF33A8F26A86A45F49E8107358A06C4710044052ACB321A06F36D1884
              2771B25300B16110801E4C07D0F18C100E77C06E03E06479ED3FFDD33FFD831B
              60190AC0A908D3A92D77852CAB433130087B905867B6832D84B089029003AABA
              CD4FECE33CE40396B3D7E0A12C381BB00FC158180D81E3823CD93901E8785A12
              C00A7071AC0DEA54D2FCE1273FF9C9797DF14C3F646800A7224CA753D3555DCC
              2A7716186AB28CC763AE488B9923701430970EA054F0C1AE63231E0D0EF041CD
              F24C1315308F9EBB64C9928E7DA8A05ABA74A9DFAF2320BA8EF1501ED202A810
              D0E6300966BF1476DCA68B2EBAE84FDC10C850014EE5E52F7FF9CF48037C491A
              64B93D66ED3B95C40CC68780A74CC4436550A31CCE00BB811D913780C6F135A4
              457A381900328738B0AE65D027CFF8B1479EFDCBCF9EF222C786066C2A430738
              1501DD0B04745F91069865955BA6B3ACC736958A36200001D589068797CB6113
              9EB386F3793E9E02951FCA01C38105354F0515D2625D8FEDDBB7AF33970F8C86
              EBF0678C10B02E3AC77F1735DAF3473A1643063A2C1213198DB85702C32D69C0
              E7DB21A7D8982B7B92D856611B094C026F13B69DEEB32F5BE6A12FE4A36051E0
              40FD81E1747DEFDEBD3E1DA64FE14D4F7A0E873D10CA41F9D823C537CC8A32FF
              D1A73EF5A90FB82193A16438C8AFFEEAAFFE27A9FC7F92D523EBA40FD97A2A21
              0F9787C954108FE3E9E23CA4C66CC7C160D87908BD604483A7BD639C972753F2
              C331EC994A9E0765F96DF146076230BE5B196AC0A9BCEA55AF3A4B1A51DF8771
              82EB522CDBA9302386C06483CD0C4EACC37EB3B13C843A6027B21D0746E41109
              A8701A1ED397CCBC426CB66FB82195A1079CCACB5EF6B2A3443DBD4D1AE5F7DD
              3C496C182D4992CAFD4960701FDBBC8E6360330E83581340EEED1239F65B9FFD
              EC67B7BA21962705E020AF7CE52BCF91C6FB5B69A4A7BB45901818ABCE09312D
              1DFF9EECFF6361B5AE3EF53DA8F2A4025C21890489DF288CF047D2585DABD901
              129DE5F12189D3FDE5BFFCCBBF0CD48C8FB9C89311705E9EF5AC678D9C7EFAE9
              AF94D5B7CA72AE1B1EB94196BF17A05DF864021AE4490B3896C2B1F803597DB9
              2C4BDDE0894E38FDA62CE789EABCDC3D89E50702709017BDE8454BD7AC59F39F
              C560D727FE5FE07AF06CE751D4E3FCAA38025F16CFF55F9F8C6C16921F28C059
              79C52B5E719A3819EA60BC400CF3D30488CF92DFE56EFE659F2CB74BDEFA918D
              EBC4BEBCF4D39FFEF45DC2BA7D7F01E0A0C90F34E0AC4878659D84579E22F1AF
              93050CA708008F15906C90430AC263649FBE187B99ACEB5C748D71E868BA8E3B
              29A00EE8AFA4B95FD2E8DBA1360B7BDD2579DC2701DFEF5F72C9259BDD02BC61
              72D0E5FF012E39B847592D27440000000049454E44AE426082}
          end>
      end
      item
        Name = 'Img-arrow'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000E6000000FC08060000006327D8
              46000000097048597300000B1300000B1301009A9C18000000017352474200AE
              CE1CE90000000467414D410000B18F0BFC61050000623F494441547801EDBD09
              A02C4955267C4ED676EFBB6FE986A69B564690C10DD79119477FFDB515155954
              BAE9D72B8B8A808EF28F28F82B8B3EA50111546CA01B10045141BB1BC405459D
              91457F7F9D11B1111A110464EBA6E9EDF57BEF56D5ADCA3C137B9E888CC8CCAA
              BBD5AD57A7BBDEADCA8C8CCC8C882FBE734E9C884058C9819497BCF5D4F99DB5
              DE65877AF0ED5DC4AF43802F408481F87B0F017C0211FF766B6BFC96A73EE2F0
              BBC47782951C284158C9819213AFA7353AB2F5D31B037ACA461F1ED0EB2074C4
              F1AEF8A7DB05D89A0250A1D31604C594E02F81E8E93FF2DD6B1F81951C185901
              F300C933DF34FE9AB51EDD2000F965EB3D8041571FCF0455AE89DF7DF1FBCCA8
              4C2F69528013B672B877B455FCE4B3BE6FFD75B09203212B601E10F97F7E7BF3
              B28D3EBE427CEE371020EC651290FA9C04E09A0065571CD89C90AAD42C2B2B97
              4482D114B6C61378C6CF3E76ED3A58C9C2CB0A9807407EF40DA347AF75E8A643
              03589300EC7775B515027145A1595182B52398732C80D913E725A34EC53971C8
              01783C85E9745A3CE9671E7BE84DB09285961530175C7EE40D9B97092C5E27C0
              785FA9AA668629E547024FB020E4069CF258579C3FBA0E0298A86A57B2A53043
              A163187452E05D93029EFAB3DF37780BAC64616505CC05961F79FDF0A22CC33F
              EE001D468D33053409BE9E60C4490E707244309A6875160D300F8B73C70EA1FA
              2ED3F73B9A652D380B698A6E4D2F7DDE2587DF012B594859017341E529BF397A
              442FA337880ABABF02A4F84C05CAE45F313C02B9F87E4A387AEE1E9302289901
              919E00E121C196E76F08D6EC6A344B9695AAEDBA605CA9E64A66150C7BDB34A7
              CB9EFDD8F5BF86952C9CAC80B980F2E4D7DEFBCDDDACFB76C196C724E0241C25
              F8A6B90699545BEF1580BC6728D458C196604729C55F94AC28C0B93100B8E030
              0A20EA537DA1CF6E08701EEACBA11554C32B6258E5E4249F5EB162CEC5931530
              174C9EFCDAE1B70A95F377C5D70748A4C921493936291C374E4E6D116C0A504E
              B6440AC69660D45D09CE4C0072E310C0B96B5AA5ED0820AE89CF61F1FB504F33
              6BA6BC42F429C83B8F7DCEE3FAFF082B591859017381E429AF197D29758BF788
              4AB940824D32A3B41F4F8B8FF2BE820429C19600E4746C4059443292EAAB005E
              470070ED90664B6B7B0ACFAE604E548C2A875CA4DD29F07F47069D47ACC0B938
              B202E682C8535E73E6BF145DBC4980E48B2428A5DABA2958F28C6047E97D951F
              09C25C1CCB05300BC9A0862995BA6BBE2B2791A9D54C00B1BB26C067D4D98100
              EB91018A8F00695F072548E6941F211F13997FEF89CB8EDC022BD97759017301
              E4AAEBEE79F0A0D77FA700D41749969C48401A504ADBB2306176F253E4DAAEB4
              1E5A05C820125601D30034EB6BE654152DD8B12F7E1F11A03C470CA91C128E20
              C9A0D26BDB51C33074ABB8E1779FB8E2C8076025FB2A2B60EEB3FCE0EB860F2E
              727AB7A88807C8F1C82D39962118712854D6E944835082518D494A704ED3800C
              25EB98BF3DC3A4C6F6EC8ADFE7085BF3D840AAB6A8BCB532BC4F3A8400E9D348
              F86D272E5DFF18AC64DF6405CC7D941FB8FEEE0715D9E01DA212BE6C6A40795A
              827242CA862C8C6DA9BCADA8BF93F9DD56949716B5A7D6DA9E129C3D01CAA303
              0DCE8DBE8E1492E0544E21C44F8CC65B8F7CD15547FF0556B22FB202E63EC9D5
              BFB1F9806E81EF16287B70094A82A171EC28A6349E5834113C51474F0BB1E094
              AAAC62CD4CABB83248E19860CE237D0D4E399422A38BA46A2BD2FFDBA4BFF66D
              2FF85EFC0CAC64CF6505CC7D90AB5E317C60B75708F5151F389161751294625C
              7264405918F55501D1D88AF382D28A032768F6949F8E61CEC39239FBFAAF644E
              E914EA6A707EBA9BE145CFBB78EDDF60257B2A2B60EEB15CF91BA72FE851E79D
              622CE42BA6723824D74C3966A0CC8DB34755CE4ED6908902525F4D2082740CF5
              8C97F6E89A644ECD9EFD8E1BEBFCC0199C3CFCA5971CB91D56B267B202E61ECA
              0F5C3F7C1065F88705155F2399528272D38272AB1C0611CE20951E33742CB763
              C2C0A9BE77B573487A6BD705408FF5F5708A0C8257CCA9545FBA1971FD31BFF0
              38FC34AC644F6405CC3D9227BF96EE339D0EFF4E0C877CC9C430E52919E72A18
              723AD2362559504A5C2AD513DDD0C78E8AF1D05A46560EA1BEF6D64A55F69C75
              146AAD8EB55D376A6D07F01FB3DEE0E1272EC67B6025BB2E2B60EE815C7DEDE6
              03B08F3712D1374AA61C0A00CA09CD5B23CD928A297303CA4283468367978069
              8501543227CA211301D0B5BE760A498FED5A174D7CAD1AE7FCFFF3113DEE854F
              D8B81556B2AB92C14A7655AEBEF6CEA3D0A31B0A03CA330C94A5FAAA17E701EB
              E0E1C321BBD9751A4FAF0AFF9BEA8F7C26E984BA674470722C995D788A273AF2
              A820FCA6CE7AE7B5276EB8FD30AC64576505CC5D942B5F76FA82AC77E82D025D
              DF241BB60CB11B0A9B726B688644D4B008E96191D8F8E45EE8330C9C4A959EE8
              671B8F3538EF1DE971D5CDB10167418F2AF0E85B5FF856BA2FAC64D76405CC5D
              92A79EA043D9007FA700FA4E15CD33D18E9EC9D8805232A568F0342D81E109EE
              AD9DE1C09997CC299D52774B705AE6DCB2CC49DF35CCC7AF3AF14E5A8395EC8A
              AC6CCC5D90ABAEA373331CBE4EB4F38B27069423AEBE1AA6043365CBAE3EE062
              5CD550066A5B738F85470A49A75057D8990363739EB3E6DB9C9D0EFEC14677F0
              A4FFF7FBF114AC644765C5983B2C8FBC96065936FC4D81C78B2D534A5550AA86
              93407DB5C1E9CEB6643343F6ABCB5481F285664E399EAAD45A6373DE33D231BC
              D6E6CC73BAF8D478F4CA57FF03F560253B2A2BC6DC4179C21B69A338B3F94A02
              7C9204E526674A193CB0654029571D606074638B363AC74E62DECFDAC1923DD5
              F4B1BE1EEB9413AF8FAD9BA194BE0E4210495ED73D73DB8F9FF8C12F1EC14A76
              44568CB94372D109EA0A0FC91B2D28CFA8B8D71294790C94465C1CAB9BAEB58B
              A06C312BC5A6B313B1AD43484ED0BE6BA4973491CC292771AB6969083F34D9B8
              FF2B8EDF401D58C98EC80A983B20179D7867F70B2E18FECA148A8B2D2855A3B5
              A01C0B406E69507A4B8118C1FD60C6960075F340A7FA7DB6C4FB9C14EF7372A4
              877D9443680A727394277F390D7FE9C4095AB5A91D90952ABB4D910DF123E70F
              7F4BB0C6E32BA01C69CF6B1E5906C473F464415041AA69EF746DB1B5821AC5A8
              DB3210A12327570FB45AABE36B758490506B8B8CF0DACE87063F75E2046E33EC
              FEEC962EAC646E51A0BC60F822D102AF96DE5715F76A43EC0C28A55DE9263717
              5089E4F17E87513EFCBB65B879C1390B0813D7ABB9A1D332AB7BCC0375245F92
              C8B82F70DBA19FA0AFDC3C4944BFB0DA656C7E59D904F30A113EE043C35F16ED
              F1590294A86C4A638B4D8DE755DA9564273B1BFEB0F1A99C29395B028B61F564
              BBDE5AACC96B863CC9FE63029526CA1C46B5DABBB48DD52B64F82DEFBCA5C0F7
              DC78CDBB612573C9CA1E984B08AFBE7EF379427D7D06575F25534EE55AAFD29E
              1C1B50CA6541B852E73979A0028E5DB52DECFDC290BF36F6265BBBD605214887
              D0480721C8F03D6B734EA6D0252A4E3CF786D1B3602573C90A9873C855D78F7E
              8E107F4180B26399D2DA941294DA03EBAF642705D974AB109C9E273685CE9D42
              2D36FC4E5D43E5474DE49EEA71D9B178EFBB86DA21C4BDB50474CDF36E18FD24
              AC646659017346B9EA559BFF5D34B8E7B82111ABBE8ECAE11032DED71800DC2A
              0259791ECD9865ED4C929DB0D69AECD4A67B20C3A601A70D42D8B2B1B59239A7
              6635861CFA05D0AF3CF7A6E153602533C90A9833C8E35F3D7CB668902FDBCAA1
              C74139191A9B72CCD67C0D1A3F767C4FAC3A66C62FDDF75DD5631BC4DEBB019C
              C8D251A0D68E44E774E7A660CEA106E7D03227E1CB9E7BD3E8C76025AD653F9B
              C28192275C3F7C8A687FD74E0A5A734322E3527D2DB6CAB57A3C21E6DC314074
              513ED98C6CB913B5651913AB4EDFD6AC4CE06FCB603A1B152124636BC510CA7D
              E4508A5CBB567885E4CA086A9B0631A4F48BC7D77F1756D2282BC66C21575DBF
              F98C29D06B2C289D4DA9A66F911A1AB1939DBDC61D345E0802D52138562B3B69
              5FC600388BAA1C20DA05214C4A9BF3CE1163CE2DCD9CE2EBF5CFFBBDE1136125
              8DB20266835C79FD99A7E544D74C6236A565CA6964BD57BB6501536179FCA975
              F83482723746020370D21CF70883202C38F309F3D60A87D0296673E6051C2932
              FCCD67AFC0D9282B60D6C895D70D1F2F9AE0F505E1A14D3B2412515FC9326518
              6A97457EBBB858F41C4051E12AEC4E3A7FA8FCC91D52B34A781D9959299639A5
              43487A6B4FDB59296A3E277530A35FFFB91BCF7C3FAC24292B6026E48AEBCFFC
              9068B4AF94C103A727E921912828232AACB3C552513EA184A0DC8E2ACBBDB1DC
              C953CCC7964E82FC486EAC4BE5FE2A13E31092E094DEDA129C784E4E9D1B9EF3
              FBE3C7C14AA2B272FE44E4EAEB372F26C09B844D999D9968354C36B209634A15
              FF1AAAAFAC343D1516748C6919F1D3922D3953624D1A68C8A7EE7A28997D5E90
              DA1860321958155D2EEE65B763900EA1F30EE955DFD74D6C6D27A33B3BD8BBFC
              178FF7FE27ACC49315630672C575A3478BE6F5BAB100A59C4F297BF82D034C1B
              D1A3D4D7C4BE94EA4F3854C28644AC17B61528837C2B69DA4A43C0C276B56437
              36AB968C077F2885AD21A49873CB44084975B7C0FBE694DFF49CDF1F7E2BACC4
              93156332B9EAFAD38F20C8FE645A40576EEE3312AA97A7BE8E039B924B8A2DD1
              ECBAD5962D7752859D41ECFE28F30A31FB95CC4BA8D797EF6B567C9743296B72
              284530E751B9D3985B541AEF252C1EF982E387FE1656A264C59846AEBCFED477
              0850FE8EB029BB6A8D9E29551C3D14F3BE4AE1A08C397C6C1AFE89C94E3B7B66
              10DAE6FDB8ED8C2644C8CEA8216373CAF58E86A23CEFB1DEDA8971A815741409
              6F7CCE9BB7FE33AC44C98A31855CF9EACD6F8102FF4C3490C376E12C1B3CA0C6
              29C76648C406A473260B418909B6949F0E7AE3972987D14116CFDE64EF9431E6
              ECAD69E6BCAF59F15D6E3D3F503627DC31283ADFF97357F46F86B35CCE7AC6BC
              F2559BDF2440F976094AB9427A08CA82ABAF768947EE85ADB105B330DC8E0332
              FC841ED3FD96399FC1B337595E45416EAB7A398C3234B3524E1B9B73AC6C4E38
              6F2BCBDFF1BC9BE82BE12C97B31A98575DB7F5302CE0EDB950A536CD6A7676DD
              57CB9479004ABB896CC87A6866B6BA739C19A1FC4B21DB86AA6D935DB91DD046
              C65A93322F73230367168033276F5169B988F45D9B42AD353B68AB49E604F7A7
              62F88E13BF37FA52388BE5AC05E6E5AF3CF35F0827EF10983B77D330E556C094
              DCA624B6B37308260F944632EEA1AD8CF731E60D65075459ACF3C2EE85AACCEE
              133227B73965F0BF03A719E71CEB71CE076C21FDF9891B460F81B354CE4A605E
              7EFDA9AF1236CF1F1584E7D92526275BC6D133D6CB82E46CDD576B374541C9D5
              5548A773D136D6F6AA612EAC730E45F26C75ED1E8BE70C620FA582100ADDE9D9
              F0BDE1D884EF19E6DCD2CB973C6842C5DF3CE76DF41FE02C94B30E98C75F76EF
              9765D47D8B3079EE2FC7D2D4063F5BFE1293641C3D64A2632A2A67A88A724148
              2EA6450535AA92B5A0DC29D96E5E2DAF4F4539C9725000CDF55ABBD27C3823C1
              B9696D4E31EE29814B78016C8DFEF4A77EF7EE07C259260BD2BFEE8D3CEED74F
              7EC9A0DFFFCB9CE881567D1DDBF9945B7A9949B54E4F605372BB49756531BB12
              C0D9967CD76627DEEA05C8BEFBCF882C7F0ABDB6616D458E2146AEE5E901EA87
              6BDAD8B7B3B41AAEB29BB03D2B769B41395D2C333B5B6F98714E1B2134E8AAE9
              621FEF76D7BEF1C42578D6EC6A7DD630E615D7DFFDA07EBF7B9304E5D0ECBA35
              76E39476ED5770CB4CF2F14A0F9446622AAC4AC2403AF7D820B74F01D28089AA
              CAD098AFFDEEE5DF044A7BFDAC5D794CD3B0B72DA8DC02903984E438A7624E19
              75A59813BE783A1DFED1B37F9B2E84B344CE0A605EF16BC30721ACBD5DD8945F
              A34039613B398FD94C9130209DABA5F62F770071B169676493CAA102DCD21D34
              0F4381CF5015F17D31E5B15DD49D3CFB5BB124B339CD304A616C4E196975CA04
              BECB697652ADD5E0C4FF8A83D10D3FF1FABBCF81B340961E98C75F49F7CFD640
              80921EEA7672DE2A57499FDAF857034A176E8711A624FF37A6182894598FCFBA
              54B251A1A392526963114C3B69C706E2A9F531E664E09C5A9B73A4D7EA1D1A70
              8A64DF727863ED4F9EF9C653E7C392CB5203F3F8F59B5FD8CB36FF44A8AF0F1D
              59A664A054FB5332A6ACAC94AEBE98BF16AC91A1112FDA875FB317D2861D6321
              847576E62E01143D53201C4621F551E03475744AB0A69ACFE983F39B076BDD37
              3CF5D59F39044B2C4B0B4C094AE13F9043220FDBCA352839531626283D374B4C
              F2C0F44A7CABFD5907B8BD04E32CF76DF35CB134BB05CE40ADE5F7734B94E425
              739E5636A7DCCE508373ACC1F9C80BCEB9CFDB7EF6ADF72EEDAED64B09CCE3AF
              BEEB9870E8BD45D4F1D78F73A3BE4ECAFD29EDD60551A68C8132B02B43B6AC1C
              0B85D2DF9381066D05CDA36EA7D3086DD9DDB43931C29CE1504A513A8414738E
              F5FA41431BF49EAB3D7FBFAB33E9BDF1F8F1E5DC616CBFFAF95D93E3BF7AF23E
              BD43BD3F922ACF785A56E66458EEBCE596980CBDAF75A0E48D2902CCAC5B3DE6
              A5F5AEC7EA30C736BAC8DA21924595A0435263BCE6B806AF0E7A97E5DA154329
              7DA1B81E1D209CB36E36319213B0E5446CA43F9CC2FA935E7C199E842592A562
              CCE3BF4AEBFDF5DE5B44857FB35C3C6B68571FB0A0645BE155C62913A08416A0
              6C25BC114610B45D501D28504AC1845A6B3B19C39CC49629B97764567BDFF2D6
              ACFDFE1E0D5FB36CDBFF2DCD6E5F179DF8F85A6F7DF30F0BC08BD42AE9E372ED
              57C5900694B9DD3836163C10821202B5AB495D8D9C27CBB82D06F7293514D320
              070E945678B980D62478A745620053D4A77EBFB13E761209D47C4FF9D76C62D4
              EDE065D3AF181522E155B0243B8C2D452FF3B05753EF0BCE3FFFADA2AABE4B6D
              87372EF7A854C103D2D133D1368B37D50ADA83B2495A8123A6BA45F239B0409B
              43BCB15F043FE85D8AD929CDAEF63E315B31F08D732753B5ABF515CFBD71F41B
              B02472E081297773FEF262F346427CE4D4EC512987462C53DA15EDDC3A3DA921
              91184BB5F5C842247C2E758EDD3F05CEDD1CB25844A9330F6CD07B61D70F32B1
              B5775B709AAD18A44348247BF2736F1ABD1696400E36308581F185E7FFD73789
              DAFC7E094AB5A2DD54579E8DE8C9F9E259BCB173A74C189AC6CFB77E16331B25
              31AE98026E1D739E55E00C375962A2D45BB6E5BC05A7644E395D6C6C97C5CCD5
              84EC273FEFA6F18BE080CB81F5CA7EDF8B3F7FE4C8D1C3AF12D57595B429DD44
              E75139D1B9A85BFB550AEF96827361781D3630AA976D377D3EC5D26163F4D21F
              D85A9A5D7887E4755ACA91AD3DB5CA5B2B17F1EAEB6531E596F3C7D6D8E25E72
              0913C0573CFFB2B5A7C3019503CB98478E1EBAB6042595732AADB36752BF4A7A
              1D2895B4014382D1D4504CE2BCC7A835EAAF97FE6C536BDDD870108000A5A756
              6E7528EB594E6E3F299728191B2FFC542D512208967EFCD9370CAF81032A07AE
              2F7ECC093A74EC82D1CB44153D4556C0E9895665E446362E80C07860BD8D63B9
              8ACADF3AD1E85B31A67741E45007AAA17D617EFC7962CE0FE0E7E0AC911473DA
              3160B51468B82CA660CE239239BB8239FB6A712FC8085E7CCDE5EB3F03074C0E
              1C639E73C1F0C5204149D2F037A01CDB303BD993EA784B6FE7AD1941A94E51FD
              EFEA059143660A59EC7C9439096A1D426795B796332753F3ED704AB837E7D838
              844E8FCB5DAD65C74D08CF7ACE8DE39F3E68E39C07661CF391D7D2E0BCFEF097
              44BBFD710BCA61B8FA800D2008B658573203285342E1104B2501BB973D5494BF
              11FCF3DE182795CF28C119B539A94C7636D89D766177157D95A153671D934269
              36A88D73C5DF7B800CAB9242A560CEAC9B152F9A7CC548B6F517C2019103D38B
              9CD3199E10EDF527A616945B6550BA565BF552151E4BC53CAF525A8E39A6C614
              1BC71A03BBD03E575140C566F4F20AD4378ADE1C16D7EE6465D6E65357C656AA
              B378581082C9A3600B4ACBC9D572FD20396D4C2EDABDA5993313D79E78EE0DA3
              1F15D71E882E6DE119F3A213D4BDF082F12F6550FC94644A1994AEB62E98D8A9
              5B9A29893B7B82CA74326B63B68B1743909FB1F778838AB268C8A06612B4DD4D
              DA6356CE9EF61AC31031BBB391BD77411A3BA359F38BE5DDE27D247B4A706A90
              8ADF85A9AA2D7D7E53656322844CB0F3A0073D61735E2B8652649B7F392CB82C
              3C635E70BF33CFEC40F193B2E0AD07D6A9AF133353C46CB1CED5C68AEC14C328
              FDA96466D779D7F5FEA17D59C4592F6977D2FEDA9D9CE1929F1DBB1924F34E79
              6C551236CE29CD1A197470CFC80EA381624E31C6D91565F9ABCFBD71F3125870
              59585A97C6FA47CE3FFDF3C2F5F63CD9E78D7213D5630697A7A31294792C80C0
              CA1E345C258C49DD218CA461DFF9EED25EB2D0931B7182546EBF935D2CB162DB
              ABF26B29DE9681DC3637E7E4478E2377FA7A9C536EC1709F7584437DF191B354
              7A6A71AFADAC80A73CFF8AF537C282CAC232E687EF3FFE3134A0DCCACB0D6826
              26AA47DA94055BFB15625BADEF65A30A99B4883068C88479BC43A93027B33B93
              E39DA98E6916A1083B2E98D42DBCADBDDAFE446BB917CD3DE372EB3FC59C04FD
              2283D73CF74DA7BF071654168F3185717EE52B87CFC83278B130D3BB3228FD94
              614AB54A3AF3BEDA8D7E945D6985DB69B3C8764AA2EE7E8615EB2287306273AA
              E3A1ADDC823975840CD4BF4F0CDFF3D88844DB036FDDB86D9B6BCDDFD8447735
              C629E76B0AD6EC89CF3131C6798E18E35CEF49F614CCD955553322C44B5F78D9
              DADB61C164E18079D52BCF3C5934BC578BFAEE4C0ADDE3490F6CA9BE968B32BB
              D8D45917AFE2D2D080E7BA96AAE952CB5DCE0DCEC864EB58BEAD9EAFA5D402B1
              4D9E2D82346605AA654EB7AF0C9B579B9989D63208A12F54DA2366A2B50CDD93
              3B5ACB1DC684BB7628AEBBF49ACBD7FE141648160A9857BD72284049AF125FBB
              027B2ECCCA46F4E8503BD28E9E60FB8299A4CE831A7E9F35BF3A2F70066C37AC
              EA350E9C613E00D148A15AE6DC41A9043D84EF352F6BA6CACDFC6E0D52AE9170
              9B13C1AD82A0C02918F3D8A08CAB95CCD993E7113705B2BFFF9ACBD7FF072C88
              2C0C30AFBA7EF30AD126DF28CAB5274129BD699B8C299D07766A404973DA55E1
              1B53F0D77E8D01B54E830C1C35DE8C95302DDF4713AAD7659DE018A499735BEA
              608378806CD17151EA1C46BFC6D34412B4E98052CE2F1BBAA79628914014003D
              5738838E0AE65CEF18702AB516CF88E674B1506BFF121640160298575FB77995
              28FBDF14053390639567EC9E22237F5884B8B30702DBB28DC4D88CD89FEDA8C4
              367FAE61D68034B50C263F1F7A6CF70A9C5140C630BA93CEA1BA72B3E7B1C1B6
              4E9C569E5A599E069C8381593F486EA02B9873437A7033C59C6784BAFEA8175C
              BEFE1ED867D977605E75DDF03B3B19FDB160C035195D259952AEC0BD65D5571B
              40302D83D279D488B710555D4309C1412DAF4B486370012658945F97457AFA90
              395BDA9C3ABFF9AB331AA31B944D921123C76B03201A1E33A97D98EF2980C686
              9EDC35A6AC6DD0FB4080F11C19F43E306AAD1C46E9286BE3B4288AEF7BE1E5EB
              EF847D947D05E615D78D1EDDCB8A1B44A51E92A176C35C83D206A53B9B72CA56
              B5AB01519441439624D6C0626DB1CE7E8A9D0B6C3FEB29F41E21B5D017D4ABB5
              B33A84F435B357691343AA9F8972F157BA833470D93B554EC500687E7B2CDAE2
              3DEBE6AF2AD6CCCAB99C6B03ADD6CA0D8CD6BAC221D4D77339855A7B8A8AE2BB
              5F70C5A1BF837D927D03E6A52F1F5EB4DEA33F160F7058DA946AFB822DBD71E9
              C485DA991858BE2D5E8D54801961C994B3A83276B71DDB3583F82E5E365D8439
              A30C0B8C35DB827306B5B6E2658D745675914CA908A699BDD9C8CA20761E02C0
              39E70E36A7E5C7EDD055A70C405837CC290311D60D38E5743191EC5E9CE2E5D7
              5CB5F60ED807D917601A50BE49DCFC42C99423C394A3B11DA72C8745E4CABE7C
              0A57323A2D1C36094059394F81AD1436B03A0747789B08DB3906F57A79FF1CCF
              30094EB6AD5F2D38634C24634A8B963D4CA8B6D601D26A1E89296D7309EF5832
              483AC630F89DEA889AC0693DB512A0EB9239071A9C8E3935386FED763A8F39F1
              B8FE3FC21ECB9E03F3F8B59BDFB0D6A7BF40C06336285DEE4DC157B5B3B345EC
              B008D48111A0CA849C91C2731471F450708E1F6B2398066865C2758A396B1A64
              CC11A48ED7A8B4AD25A2213481D2D34C1ACC018F5143D5D47E8D30A8FAC33BAB
              587A763CBA88761D384DE89E526BC5E79000E67DE4304A5F0721C8714ECD9C74
              0F101EDFEBA1943D05E6E35E7AEF971FDAE8FE856080FF2017CF1A179A2987DE
              8ECE91295C4D951F8BFC8900D063CD801D53804C1D6F74F898DFEA4F5B708651
              42FC9ADD00E7ACAA6B684E24C04C6D4D024FFD365F3171BE53EDFC42F5366677
              26C169ED4DA3D64AF63CD237010832AEB6AB1D441D8DF7CF7421FBEE13970D6E
              813D923D03E6D52F1F7F75D6CBFF4A94DD7912945B26D46E6C1765966CA918D2
              30A50DB56B60CB242843968CD890CE0914E4E95DE78DA74045756AEB916D05CE
              3A350EA07908454A53F4730360A26510B264707DB42EB860701D56F3E0693162
              0638B5354B9401FB84AA6D2D73B2000419BA27B75F38774D8373AD0B257322DD
              4980975E737CFD5DB007B22741EC575F3B7E68B757BC4D82529A3CD2AE3C63B6
              557336A50A00D7A08486C0815940E90211D8EAEBB189BAFA43661DD3F2A3AEB3
              CF643E6E1273707D79535FCD567F82778A3AA128B836763E5116611EC9EB6BCE
              B70265707DA52E029054EE1B7B86203DDFF52B0CE8A79C4DF163EA35CF37B4AB
              2951A6B66DD8A1B8A919AA3B6922CEA499253FB9BA16EF2BDAEF6F9F78CB99AF
              873D905D67CC27BE62F4A5D02DDE257AAD0B654148F5F5F456196A377536A566
              4B372BC3567442D58AF5E05C85A24843E00C6981986CAC543D941C93C3D2C6C1
              1A554BFDA9AC3C0EBA7BE48C5CE3FC688C0A82C875E67D5252A7BEBA15FF2279
              B806CF578CA06A7A57EE0986B47F4355B5519388302886CC99AA0F964F666D4E
              E30CEA71B5D6D89B32E85D3A843A19DE01585C7CE292437F03BB28BB0ACCCBAF
              1DFDC7B541F167E2EB97C80ADC924CB9A58745B6AC4D39AD82121A80E9F5CE9C
              6542760A41EABE93CF601C84350DD8DE33A9BE66EDC0E9C5CC5AA0F2461D9B91
              62BEA7D6AC6D39425291D68E9E2650DA678A682D75F7AEEB543C153506505E9E
              611C724AB54DD45FD6814AE89E9C91726CA0A383D48C948E1EE714797C8A269D
              EF7DFE15FD9B619764D78079C5F5C307AD75E85DE2EB03A59AAAF614C9F5663F
              760502352462EC4A6B4FD679FD62A0E48DC37D0F00697B6C3B9F91522C0950DF
              AB278EF386D20A9CA68179E732FFFE95903D2C8F276DA6196B936B10D51371B6
              A4B0F3733787342829B8D71CCC196E155FB1432D68F98AEE1C9C5903382D735A
              70AEE9D9273274EFE8407B6A374C00821A4A41BCBD20FC8EE75F3AF820EC82EC
              0A302FB976F301624CE8AF85D1FC200B4AB910EFBD0694A5F7D57860ADFD0689
              652721014A0EC2C0868C02B269950307562C0F84BD73A2C4B833073B3A51149C
              0C602E7DC80CF678841D5ACD4069298DC103110F7665F2002BAA8AE612EB009B
              34129B670AA811D53574A471F57616707A010852AD556CA9995385EE75F54AEF
              52ADD50E21F80452F6C813970EFE057658761C9897BC9A2E3C44C377F73AF025
              1C94A74D548F73F630A6F41C3111D529C6A21461490E48E7B8097BF0B0911820
              524D83292B902A3D79A5779692958D20156010EDD9B9AD09905C30BAD5160C2D
              24EA3802A84EA763E90AD689D68132D9115225CB0AC82B8C697F0760F358340C
              C4E00C0A7E1957BCEA419D2AE6349E5A1B1D746CE04707C9E962C65B7B5B9E4F
              2FBAE6B2A31F861D941D05E6637E75F30BCFDDC0777790FEA3AC24392C22A37A
              4E59508E4B478F1E12F16DBDA8EA641B4983EAEA813B64C804233AB58C28380F
              7E8F1D73BFAB2F140767D0437BF6240084EA6C8A353D60B2676AB5C27B83A4D8
              B2D19460E59FB2F1555ADEC1520288E1B360F03A29A0068107FE86447ED9D8F1
              4AF5335237F61AEFB696390370CA3D52364C008262CE8E0E7C172FF051D1D62F
              7AC165873E033B243B06CC2B5F4AE7750E0FFF4A74285F2D73953B2F6DDA05B4
              268C29A78C2D3928794F9C02255757638024026FFB76F7C160009CA0A22EC71A
              6AA2D7B640450ECC1A707A0D85A70D1A9412C69A4960EE803A9B04660D5BB671
              BCB9BC43D38267C759D5A938109461C06AC0EE0B21C8C08F4F36E5CCCB949725
              72E60CF363F744C69CBD818E0A3AC642F70E199BD3C4D67E764A6B175D73297E
              0476407604988F79F5BDE79D5B74DED3E9E057286C50C99423ABBE9A755FF518
              14A9B141EE81E5E355318F1F71B5948274A4D9B7A23E15E80F8B00D403B14E42
              00740CE0EC06C6ACD7F55556F47AE446D66C014C75BB6D7867E7B62D236C59A9
              270E4A808ABD5F0163AA1EB84660F18325855A16F5555448332882E71C8AAAB6
              0815D3C3450799E962874CD0BBC79C5D1D2124DAD94736C79347BFE4EA63DB06
              E7B681F9D85FA3738EAD0FFFBCD3856F50EA6BAEC72A4F8D75A89D5D21DB2E9C
              55E401280BA80C1657068F0BA8A8ADFA37F9D7070C69195467947881A0E160D0
              202AE22A1C590547C0C92B9EB166A3132818D374E396ECDEF63A8C3C6313309B
              82178AC4EE685EBDD87B04ECEA8134604B6762046CEC31682801833971E0C28A
              23C80134838A4DEF00CAD55B9657A911B1FBB2B85A17BA37D0C3281BA1CDA999
              FE53A2BABFFD7917AFFD1B6C43B605CCABAFA5A3DDB5E15F092A7F98C2406182
              D2277A58643A61EAEB149C4DC9D92F0A4A00A8A8AB85FFDB56B2E7F9930CE9AE
              A5788F1C003E5930018020C25C9EF735B0373D1BA8D3429D4D0033156CD06A3A
              5844E6016634BA8775AC2E4D0294F6BCD36A62F502896389F771E596D500D482
              8EB1243F56C79E611D39701AE63CDCD72B20C8103E198020995382B3ABCBE6C3
              C5181E75E2EAF58FC19C323730AFFC8DD317F4297B9D00E5A3E56F07CA2D1DD6
              A440396601040578CE1E67AFD806C16D4C003784C21933C992857E151D2A0795
              5E396E07397D971505FA2A933D0C50B11DDDE91A70BA8A0F864FA2EA6C00587B
              3E09CC3955D93A607AAC18822AA2C67AC00CAE0B874D5479E71150F2DFA433B7
              CFE879C3ED7D6365E431A5ADC3E038B73199B651016807A2AA2D5F9E442DEC25
              E36A0726AEB6A7636B07DD129CE27D3F5940E711F30EA5CC054CB947E539F71F
              BE5DE8D617C91C64A5C8B857C99472586432B1BB6F815BB6DE036585FD4CC64D
              2CC9BDB88C211D3B866A12B7378980BC16C0BF872D3F02520620974C4AA59725
              A7D23A75A9EB03D303214245ADE292B233770D986D86ABE43D0AA8465B71F624
              960DD77002560DC1A8AF271FBC46CB040CCBD1EF087D3BB36451CEA09E869245
              CE8129F3AC0A4EBB02825A3BC804BD1F31ABEE49E694F6A704675F87EEC977FE
              F099F1F851BF74F5393333E7CCC07CF47574EE7DB3E16BBA5DB854FE56A17653
              BD0397B42BB72676A574AD165540C99832743450684B5AA62C581082EBA9B1B4
              2179A57ACE21CE8A0C88442E340F941A545682FFC50254D78EF5FE554ACF53A7
              AAC00CEDCC466062F9B83B0D4C80083839B33501D3E61FDA97AC7E4215D603A6
              3DA7DA00B27E935CBEE1FD9DB0F2768778B9B332F5545753F69E8ACB40E9C63F
              3BE0051978C35DE663E36A1538073A74EFA8B139256B6EA8654ADCB298F2353E
              2DDAEAF7FCDC8C1142330153EE5179FEDAF0F784FAFA58445DC853C9940C943C
              289D0F8B3866CC21EDE0E1EA2B03A44BABCEA157D13A03CEACBC2B0EC168FF72
              2F86052646406A2AC6D426B745CA34E6ABF5BE7260F246D2D90160B2FBED2B30
              5DFDB034CC36E50E1FF537EA0FD07559D9F621F16CD1961A948B76C8517518CA
              02D274AE513BD38215C03987D4DF4E029C7CBDDABE09DD33EBD5CA5DAD253015
              7376943670EB88F0E1D75C32F810B494D6C0FC9A97D0C6D71E1D5E2F6EF8045B
              3993A91E16B96764989287DA85A09CE87C78257B1E577BCCA6CFC9634F37F411
              78F64A30F3C465EB2061BC9247C7B6C5B3225018D55D255A30BAAE53D7AA634D
              0BCC102CAEE27DF5AAAC78F400B91D60DA1EDD7F8FF25C93248119AA9A2C6D2D
              3079476B8ADEA9B0C6B6F498D4D467C1A2B3AA0F09E0B62DB47DA8B97FC516E7
              E200875E27E9ABB4585163630CAAC0D72BC1E9D59FB139D5508A61CE639639E5
              58A7516BBB169C00B78D8BEC7B9E7F49BBC0F756C0947B547EE1F9C3D70FFAF0
              78C79479A9BEDAB14ABE9F48C1C2EDF8463BC02A9ABCDED3A6D1B55AF6C06830
              4555DC394096A8AEB0A2B909D91BB917E7DDAA394865C9ABFF54C95B605AA096
              15C83283D2AE210FB8BE4D13D83D0051B7FEC203D30226F4C896C5EDCE57260E
              D8BC25308D97D63B0EE00392AC67A0A44EB4DA0C07AB7D36FB979739EF2C6300
              754E3AA83885A4CAAAB4135BF61DAC82D330A75CAFF688F1D62AB55606229819
              2999B85741747B3ECE1E7EE28AC107A0411AABF1214FFFC8E01BBEFCC217AD0D
              B267C807911527412957B5B32B104C3930590CAC9DF4CC3DAE5EA040CCDBCA55
              A2026B54569B41612ABD60C76C55EAC414B80C91D395302C901783FB2A8E8B9A
              C2ACEC4AD12028CA9A1C980CB86170FB8E009335A650DA0053954D049C330193
              012A644B0B4C1B48E2D2582958DDDA7C7206467363F24C12620F00ECBB2D5028
              EB11A1E2A80B874E80B125721F408A41CD7089B33DB1EC202D38A5CD29B7F973
              EBD5729BD37402A21C6E3D39846F7BC9D56BB54108B5D528F7A8FCD7F347AF1C
              F4E969E2E15091960C20503345E42A04A4D4579F2D0D28A7352C59708046ECC8
              D0B1E30049A5CA6AD8910ADF302D99D100D20EB0727D28CB582FCB0D465D6B68
              6AB004A63D9EB996EF55701D30F9F95981697BEE109873061770690B4C9BB635
              30198B26D558DBE9E654DE5B75E29C1DF90D4AFF80BAB9AD0FC79C215841D79F
              3208FD3AB0F5E4D9A258022E3E7CA27F6756B5CDCAE3EA9A4E79AE6B98F3685F
              DB9A1B3D1DC2A78752F4330BDBFA569AD0B73FEFB2B564E07B7AABF7E3D4F9D7
              F3367F71AD8F3FA232339521F7AA3C2577E012AC984FD8AA763995DBE24DAB2C
              E903AF0990E4815957ACF9227A0652A034284760F665513A7F0A82EAA09CA9B4
              42B77A52259E1B75551EC9750DC962617923960C8CA46BDA38744B716D085D7A
              7BB88297E8C10590799E2924B444924AFAC849DFDC60A0747E024BAB39E8FA03
              D7ABA141981BE61069499ECBA57D97952C97E9B6A7EAD65A2799E948245819E0
              54E72A6F691602CB0B4D4C3202084D1D925093B140F7B85373FC249179AAB2A1
              C8EF5D6D825C081DFA9F27DE3CFC961357AE7F022292A80AC2AB5F357CB140F9
              B3E443DBB557E46C11C994A7F90E5C76A9C909784CE9D9815C6D3576211935D7
              F69E5695F56DC8922155E5B8A5F328A8C8D2B604F20149AC1B478FE6AC306A53
              152255DB2E68D555D792B23559B7AB1D43016B02941EBC984DC319B36C4FFBC6
              98AAFC22004945FEA4E6C27A3E37802863561CE55475FC683F8475DB43E02B28
              6F56D6B961C4F2ED4D79F00A41ADF570279EF9EEA9BAA123887D47E3D4F36D53
              CD8E4AB535F6A75667511F3733520626E85DAAB59239A5CD69972841FDFAFF36
              DE2CFEEF173E61E356082452958457BE62F433427D7DA1DCF8535694B429E543
              9D12EC78527860275B65008102258B852DBDAAE08F477286F48E835769A5CA6A
              00971B401A6453E9A60DD891F7B6B6870DBB670B1C53FA14B66C51711D09CC9E
              7E61D2AAAC0262C681D96906A6A9F046601A35CAB4A38A5329162B1B0BC79B15
              945262EA6C6B60B2E2E6115CB5C074F80AEC4B60C0944C27B522F530526D2DDC
              B39159158D9CBE6D8340424F585918680A5875B8961EADC9C258D4090364C516
              55DFD1B12C9A4820B53EADFCDED3E0948C6A6DCE8199687DD4EE9132304B9498
              BC73CAFE713A9C3E260467A53A2F7DF9999FDF18E0896E57978B74EEC86794C3
              22770D75A89DDB5744387F64C81DB959232520DDE84441C0D787F5FC334CD52D
              7B49633F1A95B504A4A5DFBC045DC1BB61D0A0E5462D94D13EE8B5E4B2477595
              EB2A305325ACC048990171C69C4035C0744E0172153A0B63561C3A29607661DB
              6CA94A2702CC9403682E6032C75D69B2B061AF183005F80AD9C81C8AC1D4A16E
              4414FA0C1C4BB242400E4C5DC0E55874C7FC2D2BD0312A06F5E2E3D8AB736E5B
              4A70722FAE5EFD00D5308ADBC068A019D3C6D60ECC743199D724A7B7F6EFB77E
              F9896F473723D9B3311FF7F293FF5D78921428C98052969FDCA9E0EEA1664A35
              D9794B6F5F5018FBD256260531B1DE90471EC4B146D455074866A0969E551699
              E03161951D4B1083AB40754C551013AB12ABF1CB8E3BA48065AEB536A6FEDBB2
              F563CB634DD90420F5FEA6D271B18D2C541C789E1439D6426297CE24147C279E
              33B0CE583722D5497B7E83825D5B05A4CD874CCF48CA44C9543B52961F6A4D48
              029590F59E8546A46A02686EC76DD1028CB2252C57F548A848DD7972A7E07612
              203556AB492BCFE57298DA875248D3CDCC48E9AA3E1E2F3973EBE8F922879F0D
              4A01E0E2578C7E72A35BFC4ADF407538D11F89EC3B37CD0E5C5B06946362CB83
              005B359D1C405D64071FAB62F82106325958448C469DCA5A7A5F81FC4A898391
              DFC082BB643AEF95395B2AC096DD9EB33351573A2A63C2D89A31C6B4D9DA9E94
              A9B2E8A943B33166DBA1922830B3C8B1A27A28B4333D76AC614C57C4302B63B2
              76012C2FD5EF5AF3652AD26F89C353D32E80B1A4FE10BF695912E0170ABA7B20
              327DD4DA9D76A8CC8094FFD5DF753E9E573760523466851B7261C7255B760EA1
              B237B3BE8EAD3DBA8E70EE216D73DA1DAD65B6D302CF4C26F4E85F7BE2FABBE5
              232B187EF3F3CEFC485E142FB005BA39D1B344A4C924997234625BAD6F919BF4
              4C6C8EA50527F06002AB8AB832F507FEB5BA9ABB741A5ED69953040C6999B354
              55B96387DFC88254578B7C20AE531A15882C9362A4619357D7F29E8869077654
              6A18AE92264C4F2DAF99358D2C8602EA2FC5C4ED19202BCF68EF3727FBFAB728
              D94BDB9CBC01019436A6056851931B9A6F68DA9371DC81F1D80AE0ABA133D13E
              C8A8BB84E89C7E656C9EED75D1A9B56419D4F85F9487D738FDECD08B9ACC2149
              6C5D470715C2D6BCD7B6CE75AD00C89510241916441B0246D70B12FA4AD16950
              F7614FBDEB98C8F925F70E694D2E9A253D46D22D2C3F92CE37373508A7F20646
              8DB5DBAD7B5BE4E5008103AD04A3AA34CB7ED6BBCA8DF8C0EB163064683B1247
              BB574906C08551838D8186CE81C09913C00D484544DE038D8AE402A5774AB691
              1737A9D4D759D5E63AE0B37EABB673D80991F728EA1EC0B47CD9E0D429DD916B
              E1A0B43653900F99BFA8874BF461D4C3591C59B9331A1D2849997A59C0A65DCD
              B285A5CC0848195841805461DEDAD48A7F0C1914D2A14A6A6FCEE980604DA491
              EE0901D4AF78DAEB873F2612BDA2DB39D2FD76A1FF1EC671E991CB8D9EAC329C
              96F6A462CA2D064AA6CA96D8B1402A0BD08D4591B517ECD6D08549C655D0523D
              2D3DAFD6DEF481E880CB400FAC5B577894056E2A0581E70D10D7F7C0CB631609
              17166E770DB497A05F49A6693A4FFEFD432710960A056835D0F4694D808EE4DF
              3AADFB8EEEB76550A9D2968EBE6AC7EC3CB81CE9CC33E78655EC1834D74BED77
              C3A6CAF3AB928BEF2AAAC6D8A330117F3B3A8D71126A906725482D8366BA100B
              45CAA4D2A9DB5BFF8BB03525F14DC53B1DCBA5C796A0D7D52F3D257CC613DE78
              DBEBBB9351F6ECAE75D7DB00F42D2AE752DA889EAD72B31F601E586D477070B0
              C2B263909EED98B3E10D5B2BA60784C050711551806F3BB27CA960EA30CB13B1
              AC40A56164464DB2F566EDC5544B0E5A6FACC5B7C52EB26C9AD2917F4D249BFA
              EBDB3E4F1378C2435883CBC439ED642168ADE29A1E011D7832AD6A2A42646D84
              390B4B3F84756CB09B18F582ECF8A56150F79D0C9B1AA351B21B624981989BE7
              C0CCFD75B668AE0D493D9CD651D78289362246F8DA7CD0249609BBB230EAADC2
              D444C05D005706ED1C156A6E4794D5B480078FC6E77E5757BCCF571563D29D8D
              782875115F667262D4D529B0E1904283A530EA85052290F99FEBB485F1B28660
              04003E160950FE451B82555608F00AB16AAB1AEF4AE46D22772C7A887BF1D491
              C8980395E99B5B514212C99BB6606FC59C19CC75EF683A82DD154CDF57759989
              67F0FB2669AC15863559E7EC3AE8C2B503D706D0FEB5340F3A9D6346CDC27CB8
              447521A43B020AF553C7A6DA90745E5ED0CE40221B436D1C82D031E3DE06E822
              BF42005C923E75C55B487B520C99486C49AC4DB7503DFE446049DA9B721DE6E1
              78FA43DD62047DF9AA999A9665ED481DC963A379C0795C0B03C4BCF4A4B2A071
              6554DBC6EDD988E4176A54B87D09E083B1FC941E5A0E4A5DF865D5DA2C03C0BB
              DAD7A0448F091BBA758C1CC7EA5F6CD1E231F9831D46A878642BB76FD37FA440
              C88E7BEAAC552163D785C77C1419D0955D1BD53C0F5A8DC61EF312A0D1700AC7
              5264EBB8D2394F3DD092DB0A0CBD4244E75FD01FADAAF38A33F496D988220652
              6B409A5040F7C0C63E25136DA0D55C33666A875D944925ECD3BCAB864950C1C7
              8EEDEB19366466500D7BBA44B6CEC0FFD59D0CE12E01E4FBC97CD4AB8DC9B1A5
              02646EC716A7CC693375AAAB0F4CEB80D1DFDD314F05ADD404939019EDF500DC
              435B46FF3050DA81A7982067D2B0B78C5EA02BC7D5DB8CACD924736687339EE4
              CB63E862253F7D4D1F12B33DC3FBC5B4D4361D41343BEB34B1690D0BC99913CA
              A6232C87535CC457CE4069B438E2B626B26692011FAB42B4E72D50752720636B
              DD70895551283371D525EBAAC3368D6A53D6D38B8E55D13A94640459D1177F05
              40A7E2FB144B333037EABBFCCF38FE8519796E17A9788F40F2E3F233E05E4202
              53012097809CE88F04A30984E50550DA851429F9D209E482906D2DB81A08BF31
              20AA8721FF3E1E20CD774CB3B0CBD3B432B4611AEEAEC6856EF3AB3C5B4B14CD
              0A368C5C133250EC1A6877BCA23AA3EE6E6601A777B96D9329C6E4BF234C1A3E
              8B4B07F1B428C362149BB8583800FBFCCA94E2EAAB71FC15DC19A83DAB6EBC1A
              0B0742AD6D99EF2CB8000DD39205ABBB965796EDB033C3FA7A4845E527B1ED42
              83401F2333FE2D1C38984B9BB42780D9852CEF0908658A3D95B355F874B2351D
              4924EEFF89EE94B2EBE1E4F4129A90EB0A943A20EDBC7CA2077A89A9AF50C6D7
              51110CF27AACA84BBC042E4069F7555BA4D62CF4719F7539F081D51C95EA8B51
              8D2A00B5C32F663C0CBDCD256DEF89D563AEA74448E99DB5248A89BFDB100CEC
              CBBAFB271D5A21106A6FC8FE52E4FAB6A0AEEB7C92E97422EDF92C1D2E24033D
              A6931294FCC354DCD243CF544FAECA227306194071205A15B46CBAF67AFE7C32
              9AC87865A10437210BAE379546850C64E8E873856C83D25924009A0F8403A82F
              B45461870E490521C84FF728FC4677F33377FF6D6F30FC7BC8BADFA873D1AC46
              D6D325D912AC2E9F83EF1103F0751EAAFC5BD1875CF8945F111849AA738900B3
              C2CED68B177B1EFB9185A7C3B290DB1EC13361D07120FA9E5BE40F1ED65570AC
              351E31915722DFE8F575BFF92964ACC9190AFDF26F8BBBD8053E96B567B652BF
              A859DD4500D96750AA9F1DE22A9CDDE666FB08704AC2F0DA010599BBE3530748
              42A6CA92055A06C0184E294C0690045520BA87B45270B0DB0E00CCF3026B63BA
              5351DE5B33AE22B942B26631198866D9D34CDAE9CA49141FBCEF270EBF545DF9
              45FFE96D0F858D2F7C2FAA5D0141B3A502A6F1FED81E48E9E15016862B4DF26A
              A374F6A40553431009A90423D8673046372FDCB2672737A4821DA1E367035D00
              F21A3905C07AD058254915CACD2E013E59DAFC560E02AC84E39533158877CCFA
              7407BDBAF3C2F4785AF6FC3CE044E711FCE680E59D41D65CA6952D23627D2841
              B9C9133B9F9A30CD094BA52DF835E4F7A7CE911ECC32B1F993EDDA35B88AE958
              34E4917AA0420C1914D2EEB20F87C4D458635E29D32BD7EDD73E7FC892AE007D
              5504DDBFE67CA6CD1C5F0BC9FC2B10BC7C31DAAE3B10AA3D2A5657B4493DEC22
              03D471B34747FFF347DEF3051F72395CF8F56FBD24EB1E7E0BCAD821F532B9F1
              704DC10F7D2B1FDF17CE6221289B1A4B1348CB9A23D309206BD9E8B572768971
              0848BB32EBAC89F75F076D634A409A1924C60DEE669064266ED6CD46C8A09C8F
              69039F0120024C0DAEF6C064DE7ABFCE102A5BBAABDF2C4D149808D036D05E01
              C20A03112FBF700A98F5BF7155965B2F4D31B39E83BD30C024F200CD0355CA67
              DD823C1F8AFCA5592580393D23BE8F75590399D03DEB002C044635A168622958
              67CD7BC55439B195111CE8C04FCF82E631AC485E80EEA5CA656988FDAB73B5B6
              B3D44CE1AACFFEAFEF7EB33CEE02406FFDC7F7BFED82AF7DF09F88C6FB980CFB
              E6723E99AEA5943A4C4B699DB0AC2CB4F68019D025ACF446EE61084CA1D8293F
              1D034E5349C4D092F988437B1C238FCC81C1FFC6BE6309A436431C516CB528A6
              D6B35F6C7ED4949F297293D68B00A2204DC373A910479E16CB5226FE20999FBF
              522A0559C87E4991F574AA3A55312C0F659049D97378CB97923D5640E9616D6A
              CB589A932A04AF3C5E11AB9D28BB91A0EA842C5F96D8FBD867D4C136663CB228
              7EEBB6F73FFEF76C2A16997DA2C8B3373FAD938F3E99C3B0A37B99192A7ACFA4
              DAC2EB9E123B1BE066B4CA784739BD1C4275A3EC495D0556D4126C818D193A30
              AE7E62FA5CF47C4DDAB984032FB0032B4991BD65086E9B9E827318BF5FA9B7B3
              EBEC3DCCC328404BCB4CEE83273AD8A98E7A51AADF64F439A5B6FAC2756B0602
              6A2A8039A4485C577BB322720C3F272EFA698E6C8F66EE78DF959F15AFF0DF74
              5A758705FCB0C065EE2D4E7C1C4BCAA95CC2E5857620D8EBBAED5A314C7D7114
              E7FE01AF1179E51AFCDD65C1C8FDDAD8967E1ECDE9677E9D04909564CD69E3E7
              D0F83B64485B0F3ADD0D53975DA5CE52117EB6CAE13DBE8C469B3635EB87B541
              EF537B5D5544D7F3A39F7BFF136FE7C72AFA5FA73BFC1D512E7F034B22A86605
              483B71CDD88EA06C120C8D3A28274B7BAE718C7CAF305AAC4542CD4345BEEF36
              2BC28CF9B37EAA7536BCA89289AADFBD4008F3174DE768FCF526C0452E843510
              6E00E1A3943E826CC6A9780B28E2955E75FBCD8FFF83F0780598B7BEF7699B53
              C21F16578C600944569EB451B26C5D39821C28557D6BDBD36345F31D318B8037
              CC1C92C73096A64D23C796C7F8F13D62EACA7DEDF736CF9C28174CBD4356FD21
              27504BE75C3638AAB49FD494BD832202949F11CAEBCFC7CE45C3A2EF78FF133E
              2C2E78262C8160E79018FA3A47BBBD410F5AEBF939E5100B72A70F9FB3C95A11
              F707546F126960562BC6F85CCE8A1388E2F946BFEF94C4D8ABA20D40733629A0
              7ACA0626404CE579804AF9795E77C99C79019D5E1FBAFD734595F6E0000B6588
              4F0B55582BC9F90AA27DBE4114CA2D70C0A5D3BB8F186A108E036173B809B24A
              1C7240030F195B86AD03C06F6510F99E30F81397CD22BB81C9BD9468A765FFC6
              BEDB435999810B2C3793E03B8343E086F60EA0081FC76B6FFBA727BC3D753E09
              4C81E43390E315E4B6033A9892F58E288780F69419B664F48018B2A53EEE0F93
              A0490B3B8E921843D5B114A6D868AE7B375C17E997D4F3D95643505B1E983850
              D1726B54756E4DD831BF422E70AC82800EC101957FA7E9E99FAC4B90D59DFCDC
              3F3FFE9F33CA5E06075894A74E8D58DB5593D0B52E3BCB042323F79C35393E2B
              D2F65878BC2D9676A133984566BE75CD3B2244D455250975D67CD7C3D0A67304
              1D89A363D4FB70E084682C3C1D8FFFFC2D3F76BA2E592D30A50C8F9E7A91C8AD
              7177A24514BD46CB14DC9AA259B91709860105568DADD3AD00EA1B5B8211165A
              220C1C3DDF940763D436E9A2C730F15C655FAAA2A83239F3249C2F715024C35F
              FDFCCD4FFAFF1A93352538F937FFED6EE13279E6012D0550F1B03A38D8F4BA66
              1F0B376EC966923895350B1A49166F50F66BEA5C8A4D6BF25A4854EFE43325CA
              069BCA2CF33F7AF65E63F35D281108FAE818F25F8616606AF566B7DFFCC43F17
              C5F072386822C730E5F64B6A066AC77CFC1AF62644BBEB123F528D2675FB1D68
              D1B8FD2CF646C2CE25041A269287EA6C9B40090354D5D91E1011BE9ABB8B6CFA
              C3F7FCD30FDED3267DEB2E279BD04BC59F8FC1011215E50362201A3AC147ABAF
              A1DA5A2E95CFED4B74299A6FD8F07B01A54DE7316FEC6E6DF2B62A32FF6E959A
              0CF5D6040708984874DD1DEFFBA177B74DDF1A98B7DEF2A44F0AD43F13CAF594
              DB7FF64974089E9D29C299310304365D23FA8C81CE59DB385BBC64CA7E9AE5BA
              DD90599E2B769C22A7EA8AADC18E8CA6097EA35567EDEE4A767EE53C119E7B23
              1F2CA6677E69960B6652D26FBFF9E37F280AE326B5645FE62F271FFDF06E2EFC
              6CA730DB16A89A77D9311568E65D866A16B22FD6BE4CE617FC4C84E8F979373D
              638BEF0B2618010BA47F06E7B02601356660379D55D9747A26DC3233D3EEB2CA
              67AEF6B99340273A9565BD1F68F2C2863263B0E1896242BFF58C1E74BF553CFF
              05B5652CA576400E6A8492875DF0791D382D5ECC7C4B054CB76658EEA589AFA8
              E06592CCBF8DC4A67BCD84399AF582059010B49438174963E7425258C1A8416D
              879DF50A917C095257A1FE65B5BD44E2E43C6D539E611B2EBBAC28BBE6D6F75D
              F90F30A3CCECD6BAF3E6277D46D86ECF15981E575C65D10FCEF1495C87F15EB1
              F2710BF3F6CC7500E04D8AAE8A3FF712A1FCD725885D547F3E25070D6811C1ED
              BC6FACCF6B60612576223A68E654DA10961FEB85AF7E76B29DA6AFA9B643FC6B
              BCE3CC2B600E992B3CFFD67FBAE275177EFD8D8F146C73493AD53C0A3CF9D3B1
              66B82E263AD0D9800CF53F44B15662400FF3F4A0DB481BBB7C8F414B91B98315
              92C339CDB120A33693AACBB4FE8A7E5ECCB1ADB28E054A99BF96F9DA5EEB9414
              59C3381484DB3A93E9D33F73EBD336610E9977DE0C618ED708F2F936F104F7AD
              4906B38A2EDC59AF8BA797CB89B8D6E158B3A85E86C1DFF2692029B15E7F5E99
              ABD52FA0702086E89E27AF8A90ED430D792134AB326DA5FDC3FA7E88E4752FF9
              CC07AFBC19E6949955592B9FBDF9D2F709F67931A4177585F6EA419DBAD046E5
              88A79553BD7CA1067B275EA1ADC087DE9F9D6B2F0745B6AB55B8CE916ACADB3F
              917576723EE68EB6D53F1BF70FBF16B621730353CADA3DA75E4E90FF05ECA9B4
              2F34A1CA46DC7C7376E3C9C6422DD3B5CB92E6783CA26D50D30EB275DB574F2E
              015A4D1848F8B0DB6ABEBB2474C7B83B79DA5D7FFFA87B611BB2AD37FBC4277E
              70D41D654F17E53586459498CDB1DFA13498F81E4A13606886B46D65BBF9A44C
              746C97AEED3DCA7E68E1020C46A20C7FF6AEFF7DE5A7609BB2ED2EE7D31FBAF4
              2305D02F407A6BDF7D136F8AB21A679AA5E5E1FCA77712FBD4F2DC0E32DF9E98
              BC339807A9F4DA13BB1822DC961F178FF8BDB7FED3F16DA9B056764417F8DC3F
              7DF0C584F80658347115C79A5AD33270DEF53837C8665D1C2B2521482801C679
              D459EF9A79D0B817CA47780FAFFAF67FCD1FF1785B84F452A0EE777CF67D97FE
              0FD821D9A1373B51DC36BEE1472FECE36D02A0CF100FBB0E8B20D11E751F5CA0
              FBAC3D2785663CBE9312F3DAC68ED9E3B1C3FB6762CAA794EAEA9B0AEABCFAB6
              F75DFC09D861D9B92EE796CBB66E0578CEF95FF507BF89DDE27244BA4294E757
              C33E0A066BC2B46795E6619285111619446637E6859014C866C902CD160A18C9
              546D12B5EBEF2ADDF87236C8BF8B5B7F5C0C127E4A9847EFA76CF2BEC19DC35B
              A48F05764976F5CD2EF89A379E8F838D07C2A4D8807D9063173EE2F505E40FB2
              2B74DB6D04CB111E34F1B36655BCAC634AC4CC3E31F330DDEA23E612F527B257
              893EAEBFCBC16F3E208ECC61ECB64EC8A06247F1BD6F6C7A1BABCDC5C31F638E
              B68DD5DBBF440A1FDE0DD565320B86DBDF264DB85D02D863368FC24FEF46AB08
              DCB6093ACCD2BF97DA82DD5E979BB14B19E923EBCD06B0ABA54510EEFCC09F7D
              2B15D9883A9D5167B2B55564BD71A728E47AED5BBD8DE974B3383CED9CFA7831
              3876BF7CEDF3878B8F1EFB540147BE94E05D17B1A743F6668B218BAA64ED887C
              D9A3EEFD7841C583EC76F3FE02C0520E00308101938F3204D779E71AC0E9ED5B
              62A50698DE66423B0D4C28AF990B986B1B1BB7BE06E78AAE596459C481A01D91
              071CFFD47A51D0A11284B4FB7DE2BCDD5CC37533C74115E47FC8FF3DF30DF69B
              4B2C609DCE0E4E653F72EAD4815D91AB4E9616986B9F1CF510431BDAD5F06CB2
              DF7A4564202AE59D8DCA0CAF1CDDA374CF8119DC30D42C98F4A9BB188EC61D96
              A505E6E89CB104A5F6FE78BB4001ABF7BD6971AD719D781CCF069BF1DAC6FBCD
              D957ED99C8C2E3D687538DB50634A56C05CC8324033AAF8B766FF7CAE2ADB023
              8D71BB0E509A85E99A986C5680B501E536CA68D79DC3E6D93A1B2B601E28E952
              A75B148561CCE0E4223344428A36CF1C385C6AD3CD626AB661EC9682AD0F56EF
              19EBC83AD97405CC83245BBD6ECF2CF803C918F6ED34B4191861A6DB508249B9
              E79227A7781E8D9FC4BD2B8716A413A3C44317A3E2082CA12C2F63E29AD9601D
              CAD61505D362D1671D10A8C906F50EC24CA09C0B800B507402B0476109656981
              391DDE739EFD5EB69F54AB6C3CB07FC21F25C19ADBBEC52ED999B5822D8F353C
              47B602E6C112A4FC880FC8DD07DB5CFE8E19ECDFBA21923090A7F5ED1BD4DAFD
              EAA2DA3A8F28CB56C03C4882196ADB632F8DA4793D91367A86FD4E3DB60B8D4B
              E433CBEB3682D23A93DA5EB70F42884B69631EFCBDB21382BDEE61AF8511ED7F
              A0809490F522CFA41E1513E9C477B945A4D98737797D45E61822AA9B61BB67E0
              6C786EC4952A7BA0448C94CCD1932E1015D449017E7C691B99311D85DAFFC216
              CD0A98074A3A9DCC0173E1E1661F10FDDF750104340F385B3E8717B4BEA86295
              2082C3B084B2BC3626761636B8991A06CDD5F1160BB5EC28385B3C532A7DADA0
              F767C785205B832594A5052651EECF0145EDB6A445E5CF847796A83E1D15D02E
              96D69E4F7DCCBDA4FD5A71F8EC4291E13CCBB6449E038956B34B0E92880A1BA4
              CF36B5B45DEADF6300AA1B1EE1731B217D8DA77636800F9A9EAF0194AD3B81DD
              10E508F2EB463CCF5286E42DAD575648434F1A7369CE09C8A6CB688634DC0B49
              1A9C72F274ADA716D48EF6E524EDB69E5ADA67A0CD22B67309BDB4084BC998CB
              0BCC0C0665059635B9235C88D57C6792080BA16D7031709AF3157086D95A86CD
              AA209E6B71D1045B46F3DA6360B3D1AFA5B431971798051E8AEFDEA0B778DBF7
              214DCE789C09F8B222F6F18B126C1E38436F2EB0F4B003CFD7E6DC4E1764F86E
              8DB2B2310F9408F0ADB11F0B27C947E26C84FEF1B636E7DC52638F52CA19B59F
              A25705EC1F3F4E0767CFF796B2C421791DE61498BD35D9FD35766AC26FC5964B
              395522E7F8F1A44A4AB03DAF6CDB22DA85F5F6B753C4A2DC7AEF3BBD7C9ADFF2
              3226527BDBA36DCB98B105CDC42EA12386ABA991385A22D891E95EAD1E2D655B
              D60544CC2233ADBDE2DF44AEEBD43F0C3D5832595A606679385C42E6DF6DB652
              809D595499E22A69149CEAA6EC7BB177AAA5779FEDDC6BD6695EB167895D2418
              B3BFB17C8CB9B4CE9F428E6FCD11B83D93CCD2B028923E714C1D666BB57A6BDA
              7287903946C11049EB2953B3944D8A2DCD337B7FF75088B08B674E2F1D632EAF
              57D6A9B24DADA5452BDE69CF23F3C24687403838797AFE2C01B3123B1F026E16
              828FDABA6D3DB4BB20E196EFD5FB527F34C8568C79504454E83A811F80475E4B
              0BB5F8B0E5B7BD51FC70EB7D44D850889F8101AD9DDE15823364AC1A1051C3B3
              A6AE4B4A8C2D774B62CFEC97451761BCB2310F8A901A7826484F4E8C1CC29AF3
              0D97C71EA0728812E779307A784D115CC33FFC79C24FEA99529F79845D47755E
              E640709E3E104B4F7970FF6C3AED2EDD58E6F20E97005B6F94ECB160141FF9F1
              68263B2B54F35BF62139C4016D9C3DC4AF6B025413486795587EA98E66076F59
              97BF057F6FB0B674AB182C27308FDF20079CFBADC34870CE737592F09AB6992D
              127D5C79CC302B59C78F39D6CA8CDEEE27F63CDB144C692EF1C449A1C9D6D24D
              965E4A605E70F2CBD6CA0801F94FD98A0493B23AE6B51DD4FC6E2D254EEDC0D9
              E8310DE762A6E257B7A3B686B66B229FD6B1B318F99D546B297A2E562E192CDF
              825C4B09CCECCEC9BAEFF108F5AF580BA97E8F42D3AABFDBC16D0C20E1B1A205
              4053CEA030CFDDF8B05BEC99246E469DE9D2017329BDB2D9916333CF38E01ED4
              B63EA0A4C4B01F26B1762FD65C6B4040F659D09C0AFB91BA3CC0301ADFDC7656
              3451CDE15D08D15362DD01C1B1587989BA5B01F320C8A0671C3F3C6E2D65B7E1
              76D0D73225256E43EC5CCAA91201299A906DE4EC6D1B2D95F627F1C65DC4B3DF
              35D9CE4D0250A2EB911292654BE7FC59CE714CDAA83266AC078E26DAC1C728C8
              EDEE5C379732BA83030764255F2827459BDD95BDDDA9E535B961CA9D7DA55632
              5344519B7A9141132651D46154141BB064B29CC0EC76D7FC60022E6D5A2AA693
              D7790743F0597B0C13E7C14FDBC69C0CD558094819F78299FF1C2A4CCF0EC1F0
              FC839B60CA3EDD8E50E27B8DD8B9A6A9E3D10820AB0C212EDDF2224B09CC8E9C
              F2E5D959A9D63143AB6C1AF30CC5DC5F6DAD9E81B361C91C6FCC85123FADB3D2
              460471A644EF4F796D6C58857516EE77CC869D5502E7D0F6A45A58B1CE2D5BC2
              05B996129805D1C64CEEE679566C73D7B648639D2F4CD5DC96796BF2707F19DB
              5A86A154FAF03746F209800EFC6793530B764F64A7185DCFA85831E681102CC6
              4720E39D68C4903187AAF1AC98066A13C11224476614732278CB36D21C5A36DA
              EBA8FCCED6BF71E768AA6D4CA5CAE6E5718F8022C552799FF4CFE0A160364978
              5D5D9951FC9A18630A357E05CC03216437146A973C196C3E0FA3C5C069F35220
              F255DBCAB54D12A8750A74F247C73F5E993FC9189622CFEAB121C5EF97943968
              D2616F3B5A83BD3D152B55F6208820A7C3FE22307536E6AC67EA1D26754323EE
              9AA2F432B6124FB53456AE548F737D4C2D5D49FE3380614B1EA4106AAFFCA075
              0C5502CC672FBA9944BE0D21C5D93375FF8A032B5B31E64110BE6F49A97F867A
              59E0DE347F31E64199B111BAE18CCA899AFCDAA8945295938D580EC1D8A190BC
              BCA72705784E1F6F5B862029862C5CDE2EFDEE0955B3314DD3354DC9639D22AE
              9C3F074228CF0EA37BB316AD23D502435B66066F8D02678A59DB34D83A12290C
              38252879E080B52111FC25410A2AA374A25EB1B233C2F0FE31BBB4E699B723C9
              21939AAC8DCABE02E681905EF7885F93E647E85C50C08950E32CBD3841AD5AEB
              B20B3CB2B5F9417D7ED6EB539B0F6FCD3C615E4DA758188D5A690F077672D4EC
              DC2175B616792DCEE3122EFABC9CAA2C64478A685322AF3121575DDDC139C059
              279C79764A08B6B74D1EB2CE82A0B4330D40F571F46CDB0A939AEFADD934F618
              098604FE6C29F16DEA55E4CF4190828AB566830703C62C213AD3F8620D63CE25
              2D9C1D51C119CEC5D4D404485D6004A49D5A14BB5D226DE3F35500992860EF9A
              AC6603A98329CBA9CA22AD7BAB5349B1316AFC58E56F53BE89E3F3829301A172
              3C75634A9C6AA265FEAA313595158DC78ECAD9E4ABB95E9AC87357400F4D9A6A
              E999ADB0681373EADC578C7910040B58F3776B8BD56E4C659D93FA42BC37A5A3
              D8F1F262AAB533FD9358A19BB838DEE39D48AC5FA2C8EBE4BE9A9BB4452B0FDB
              8EEC938FCDAA2DA6F6B2C08A41D0F31E7859CA89D20582BF3D424CAB0DD458E7
              CE4C91682C8FF077EA181BB6707F49795D6438995C1BD5050514D2834AEC53F8
              1FB01BCB9A0FE5D534DEC7E4A3F335F72AF4BD6541B9BCC2E737CF437CD8C5DE
              D3E4AB92B505DF0E88AE2E0A7E2BC9CEFBBE3B966ACBF7E5644CC2B526F6D271
              972D1812EB4E845D38D4A8A686B32ABD3EA599B49247CB73183F47AC9322673F
              A253214B7A02BF830A59D4746C9245B90DAACECFA97478C589E53D3CBDB892B0
              94FB0C368EDE01700A964496D4C644ED3E775E88B2014279C2BF047649A80AC8
              46306E9782A85D9AEA300996FF2A2CB08C2C40E5256CAD5B6783B2D933B82B85
              19E934B814D3A59A2CBD9C8C29177B666B77A88647811B021960F501FF708DB8
              C65767D6A400D9B0957AFAA691EF4D0068F28C5AE60B1ABD9DFF28DF419707B3
              4D11DC046CB78D43C1D813FD779E09A47132AC7A9038811AE9F6E8182C912C1F
              30E55E89674EF679EF5FD6356B5D00AC72B7D1C55BC05B80DADF1460A0A038B8
              A27956BF531B7537F21AB1F88994AAEBDDCF3A7B8001940398A0B2896EC89EFC
              B91B019A72F4D8E3A1361B3E76462BC65C6479C8E98F8A77BAA0EBD7B2FC52D6
              2C561C3FD0DC722AB66170599DCADA04489E86E3379A962A97AAE7F07E602AB9
              FFBA61438F80D4D9A5990528F9D681797677CBA2BC269CE25657C45A9DA6BA04
              B5D2E9F4976A41AEA503E6C9E1B877EE3A55F7B29086915B04074BC787FEA5FF
              D6F4C82989EE77D30690010356A669B983F670AAD1DAB358B9AE143EA8127420
              163B99771A42478C9D4F5AE665DE312B6F8995C7376B1E3170AA1C62E59B2A73
              C6A4EE774C33806205CC45960DD8E88A8EBD131A3ABA7E33A666456BB75EA83E
              4D6B407276F4D25A9005A8AD6392E8798CA4B0E8F0CFA11C3E916562A690554C
              EFE05DB48AAB13AAB405F9EC09CCF6C412D0765132F69AF51202B241842ABB54
              53BF960E987DE87745CDF75C9DAA0E3B13755CF8CD95DB9775E3974CEA76F06A
              B4216706644D6695064BE59FF0F13091D6FD322AAA41179FA19202A89DECADD9
              931B87E088140360C9F156CE9E7349DDBBE5CB15FDB374C0DC825EB78F5957B7
              30E3D7971E43F5BD0822672241EC334A2BA74E644E64393B8458229689B18B89
              581A2FEF10CCE0A99F18F634560D45764C7DD548D4B7316ABE65519B1707297B
              5C373734B43D01FCF572197BB60567D40104907409901D225B12593A6076FA1D
              C196D8ADD4A4A3138A1A9315868809F9ACD98A25F90640B5CC48CCDEB428363B
              7C727036F6023C2BF69E76B60845DE3D332F8EF6E95AB02895E561D953156D56
              B26752B54D2DAD12B06CF47C2CAD52B1976BDD9FE51B2EC1EE00958DE95C14E6
              B80566E6B3C6ACA3E196296220E4DFF9BE2364B7D0A56AC2008CE42E0C409BBA
              57AD9420D13FB1C438737E516E9C61CA6EB45A864DABBD3B1516B5ABFEB9CEC7
              00B460639F1954555B84CAB8A793545584808D74A0E2F956C05C64C98B53873B
              700CEC304959A7FA9BBF4789FE8EA147B249DAB024079C3D6813C49891AF0312
              555D39D3F29BA57A8892DE300CAEA8A4B38F91B90EAC64D1C2A4CE5422C7A239
              F8ABBF8379EFCC5C6F7E47C109E5FB972BD5B7EE6DCA29B319B26D22966B7991
              E573FE14C51157FFC650F1A62CA9E3910B67214E8A1FE3DBE2C50149EE1CD9E3
              1E204D328F5D9B7A8174A3B6434265C7645F32AB90A9FE91CB15E7D47919E8AE
              FECBEC5E0C79991765BA4C0B8CB3A707CE0873F23728D8B3D7D541C890129499
              7D4FF54E2B1B7391659AE1911E02DB6087193B9E9844DB01A4B3B380B1A00522
              079E99E9E1AD9005E0B127C418B32855CFBA874A9C2764173B6631BAA4BBBA04
              2C926DE9B9517B517B530DC015480D153A809A192B0A243686963986143CDD18
              688439D17F95B65232A5B9EF92ED5FB274C01436920ECDD24E58DD91572ABCF4
              C66279A89D7066B4BF3D745AB4EA935414E6BC59751921C28A1AB0C455D85217
              861453368A561BF477432F655CACDF2969BF900129758C179B942AAB993153EF
              A236FECD6CCF5702140ACDC2CE2CB05A8349EB9C4210302701B381212DA12D8A
              0C94EAEFCAC65C68C1AC53CECB33E084540F1DFB9D128B37B6D60E856004ABAA
              1AA0919DC068544E87EA926A3DAFAB0324B19BA61E6646F11609C200B458FE54
              434B64402A19B163EE972BC78E62C242A381DBA1AACF89B0A71B22A1C0C064B7
              F7C0398B64A51A2D8A7505CC85161A4482992368C4AC3C5CD728184634DE2260
              54E7B9BACAC107FA981A4365B6641132628C15C934BA6DEE0E8BC6EBCAC1E8EE
              01EC1D8D2346958D069C76FE645A6D5567433BD432A81E669140D6C7C103A7A5
              38C59CCCBAC07900095065CC7CE5FC5968C14EE6CF64B7ACA94E06691B8059D1
              4EC930873E5B1EE3EC689850A730E9A9283DB0B540E4ACCA1F629B423650A15A
              00C86CCC327D0E36D84039720438E5300A0500D5CEA042AEE3AB802F6D504D8C
              5AB5F5C0693DBAE4DB9C601F6B9ED7C452752E56CE9FC51651F91BE68B1657E1
              E4A5F224B073A8B0BD3C63B840E5D45A675E820D0B46407A2566C7AE055761B9
              D8A1080A00E87FDF01682AA9F43F648209BC443C1A2A338F6854D8CC74185657
              35DE59ADCA4A47514731A2FCA877CF330544349D232119FBB2B4395DD11B166D
              C5A0A15982D2C45C397F165A0826EB887DFF5882759C3AA52F0CC0EC6852FDB5
              6E7DF2427962C31C0694056748E685050A8058654ED7641BD9B2E93CA6535B4F
              6BD8CAA9DCBB597BCF0CF814D02C8B026351EB2C9232356B187520CB3AC61EED
              94E06400D5366A004E0268636B52D8C72A2D1D0770423CD909DCA6DEBF18B274
              C014CD684DAB3866076207222EB6D11B9B8AB5CD588FAD3CAB4E5565F9393072
              1B12220CC9CEF1EBDD2FDE098469D8B156406DD1B2CDEA040098002BCF3277AC
              8A165D85B131DD9048A1ED52E52C922C39957B944A479C614FABDA62394DAC60
              E0C4EAABD5BDAAF3B4F3FA42EA3DE4773EDAFB28C0189640968F31335A13ED41
              D89AE476BC6A661670351D6B10A5ADC87F5B7BB22819B03000AB00B20A38DD5F
              C4C05AB2B47F3CFCBE0DF1E265D101D295814DE7B12A6AD5DDB128E97C7234CE
              2239DE59306FAEEED0149BCA3905323FBB3A9F1DAA91CE329DDCA9B36A3BC186
              BE453D4D6E91691F157B27FFD3B11E7C7405CCC514827594959B69B3AFF01A79
              E965303E44281D354C45650E1DEE8C21BBF71D1FE6A0901DC378570B6480EA96
              5CBEBAEC1D831A1886639B61428CFCC0AA371619F33B90D602D538742C8BA2F6
              CAEA3240DF9BAB54FA8E29C7A90164C73989D4B8A8CA543B8E08B5BA2B93AABA
              EB946C1A2D82F235ECE3763726F7EB7E1E9643967031AEEE0078BB32CE8BB2C1
              B39AA630B85CFCCA0DCB51E11C3AEDBCAB094052A0FEAAAFBECDC9CF11B73D29
              BCCE472041C29CB20DD6812D10B7E424D30591033560547B8D751639809AF2E3
              762857918D475781CF00584713655A2D96D7657ABD5BBDCE6EA71AB7CC573EE6
              3E00027F6896B07B144FFBCE85032C4B084CDAB0EDAD0888C59C67DF4A955313
              1719754DD7B80B2C570C41DAB6A24055758C57E6ED03321286173E1631E6E471
              B4D577835924E9CFE5AB189001B075E4589D92C5CD39C78C1DD1AF0034B4434D
              5AA5AA1A70A2494FB2C9E5A613CB0C18F5FD1440A52D2A0FE7C683CB17026341
              F3CA216E575D90594EA83FD908F62B3EC0B284E3989D8EEB5973608CC825601E
              E3ACD1F6606EC8CA0E7914813387C08FE0B139327079DF753A0AC00B2CE4AEFA
              8C547D4E1FC930BB5455590B42AF73316A2D323625163F876ECA881EA024A6FE
              6AA70CEBEC1410951B16D418A86450E5893511452A689E348366998B1052D3D0
              64F6666B0632CE3CED6F2D01AAC03B15C7054F663DD196CFDCB362CC85950CB7
              A4E387B60CE03C3B8A7F316021E6A0716CC5D4D98283AB04A7C901822925E65C
              E19F277BADF72090565363C08B1C6B7092F89745AE776172E89F47BEA2013F25
              C155C6D096D3C9345288AFE825814A2570EDFA403A7ED69A098671B11C8EB273
              3AD5B94EF9821284D06141F192906594E0C455418693ACBA08DB01952574FE14
              4315D3997360326633C73428732841668643ACC327B7202C208C71A51A665479
              393BB4000A8758BC8E2201467FBCA2729A22C7EA045308B693C7C381413E7E04
              FC2B99F040EDF42137B99A1CD39AE509C0CE4E4113CCAA577E308EA25C072C28
              FB525DDBD1BC6D86A5507AEF24B3E61D0346FB5804650084BEA753690B394EB2
              140E5925CB18F9F3794A0C9350601FEA26AE6B561D2D4AE674A0249BCE808F22
              407440E1ECC8D99AA08A22AE4E82070E4A0DEA510A8901B06ACE7A62D90F1878
              31725FF59DB12B5AF5D71C974072FE227DDC4DA8969E59D4CE1F5B2E681D4956
              1BC96465D971500956F9BBA7319E77B4C7B603C174322DC59494EA2B64DA593F
              3C842591E51BC744F89C9A4E98331B503520E3D821AE9616DA955F6B43B2DFC4
              58D4396C4CDE16B8F686E110887560B8470A58CF011EC03F517943682881C4F1
              086B16B93BA7090F0DF63072B5710C590FAACD5361AC60C73293CC3A8748A9A5
              64BDB00AA0EAE6262D6A06B56AB20CE95381F0139B1DC89562C04CCA56F753E0
              063D1A53E8D710F5319C0E47A7614964F980994FFFB528BA66709B5C7B2C8A29
              38EFAAF5B4D6DA9004DE721F643DB546DD0DC62E39E8DC6FABFEB9E00388B05E
              0D181B6D488AE310631753320BA874121866560217B963887C2655690AB08B79
              A932CBBA8A45B513C800D47A743D1B947C1B5481117479298751B75C61AFD038
              CD8CBD598C246967773C0CCE3DFD31580E59BE55F246D9DF4D3B9349914F7A9E
              A75001710A65E0B95551391302786391C41D417628C59E0B18518ABE59C98645
              221D97882AEBD2369063729D1C76B8D5568321884B272C806FDC82B51D4DE68E
              5D1D58C9CFA49CF25532A6A6BDCC85F1E9EBACEDDA515E5A3D06AA3FCAEE9436
              AA186A41E514020D4EFBFE43F5F75F6EBC09735812593A600E27777D2ACBB33B
              457DDF1FD4245F3DD19720376A2B039BC78E65889DA7C216B99FD67A57B1049B
              0348C1D55106C8A8DD16B0943BDD8659ADA4C63BED256C65BBA830800103710A
              F0E1790354A70A6719CB193DC095E681045DC7388CECD08BF5E83ACB5110AFB4
              350BC39E5DE68C934DB6A3C1698B7D4BDE8AFE372C912C1D303FF1AE2F1E7DF1
              451F7EAFD0751EAD469E75E0AC6803530D32E7798D30A377ACB443DD31E48025
              88DB84168C54320E41DAA103011023DBFA511375A6A461E773E742B18F50F840
              2D13DA74D6436A8C3DABC5720D01589626440FDDE25F99069B5A6E25736B0995
              2A7206369248D7494703D28E7FE6B64CB99D6B1E1DF23F802592A5DC1FB3980E
              5F079DDEA351A9AD1A981A8C36ACCEA8A41C908E4919D3858074913FEA2EFA8F
              6B1F5CF564600C3CB87121D6CE660561D2C86C7125452E8B387E18089CFD8866
              8D9F0A2373EF2E95CB9120B2757E7499E8505C74AC6B43F4AC9AAB7936D3EC29
              EBAAD3D3AF9B6B3BD6DE5BFCFA877FFBF3F36E862592A504E6BF5FF8AF7FF480
              CF7CC1E9ACB37118C3C54FEDD00859903256445F15F56DC5600844A9B090663E
              1E64C0CF970F52FBB3926F4A62186C8D6D3E4EE919965E12AAA4378E1D40EE5F
              032FB0D5CE4CB1639704C0A3846C1AB7329FBCB304A4C8578D63AA4F01A5CE5A
              28C62498809DDC69B3999EF9F83B012E9A53AD584C59CEADDE6FBC2C9F7EEDEF
              FC7D77FD3F3C1C3BF2159D9F1DC0859459B041C9888EE1D85F4F5D2BA3853C80
              4279BE2244BEBA8700CDC821E6486A4E1AB50967584C07D9BF15A45324B55527
              5DB196B6A17F5DE6B3A1555D9DAB1C14239640D5ABF029CD04CD8AD2D2AB6BC6
              4A09B6CA7C0CD0279B9F2CC6A7FFFDF761C964398109B2AD8EFF6432FCE4C33B
              FDFBA9F980E5AC42006F8D4529767502157502E03C8A1684646DCB308AC77C77
              18B5ACEBB2000AA77A799736B0E87684DAE7C5FB0D2D35A0E68027006F060B85
              979AA113ABAE329096CC599456810BA4D76AB25267C578A69DE3A96F504EDE2C
              B6EE80E9F0D68FDFF1A1A7BE0FE069B04CB2B4C0C4ADEC6D456FFCFC7C7CEBE1
              AC7B04EC722364F7E7C0AC6C8C8615C9A8A79641BCA001677B5A10C71A3E950C
              C6EDCD543BAF688FE465B5E7E2D9B9A987F69F91A89E614B53C2785E55599B69
              21957E4982926F066EC2FE827B484695A02CF233F2FC1F429397EB004A7B7DE7
              00CAF95FFDDABF1030FC2EF5434DD2ED0B3C9A3867D76B03F83D7ED828999A56
              A5961A21EFCFF690965093B72D8CEDE6BAB64D32F4FFD64A27B8D41B67128014
              FE817C28FE8EF411A1C260563CE473EF7FCAC761C9646919538AD0507FBD83A0
              81A9020C44A592ACD44CF5CCE8B1662AD43B322C3097D4316DD395BB4708B89B
              7D3366DBE03234DD51A1002917FA0A578010D9BF6B19412965A91953CA055FF5
              BA0F89B7FC7258C9D289C0E9A5B77FF0C96F8125940C965D8AE2C7607F2CB695
              ECA2082DE23DB77FF087DE0A4B2A4B0FCCCFC1B1BF117FDE0B2B591A11BDEC24
              CFE159CBE8F4B1B2FC8C79CB655B62C8E2C9B23261254B22D96BEEBCE587FF17
              2CB12C3F3085DCFE81A7BC5FF4B34F87951C7811C3331FB9BDBFF50C5872392B
              8029E5F67FFEE1D70827D09B612507594E8931CC47C17B9FB6F4DACF520F9704
              42F79D1EF9813B3AA7CF11B6C9236125074CE824101EFFFC2D3FF851380B64E9
              874B4239F761371CEB4DC66F16C3962B701E18A13358C0A36FFBE727BE1BCE12
              39EB80A9E586CEFDBF2E7FB970083D15C37093952C98D03F4CA6D913EFFCC015
              1F82B348CE52606AB9F06B6F7A84B0B25F282AFFEB61258B267293F8978D4F16
              BF78F7C72E3B0967999CD5C094F2D087DED0BFBBDF7D9268074F26C48721D0D9
              64772F9C10D0E780B23FC50EFDF2ADEFBDF45FE02C95B31E98561EF2903F1DDC
              7BF8CCC332A4478862F93AA0E2C180F84508D9115895D36E899CCEF37951CE9F
              169DE2FBB302FF610BC77F70C7FBAEFC2C9CE5F27F003D96E73195A1EA4F0000
              000049454E44AE426082}
          end>
      end
      item
        Name = 'bowling_pin_300x99'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000630000012C0806000000D7420D
              98000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
              00097048597300000EC300000EC301C76FA864000065EB49444154785EEDBD57
              8C25499625E6EEEFBDD03223B55625B3AA4B7777A91653AD66BB77642F6797BB
              B3BBC47E2CC13F823FCBFD234180E00F017E10203F48805C0E0812E4EE021C0E
              879C1ED55DD55D5DAA4B576566A59691A1F5D3CE73EEB56B6EEEF1223232335E
              5437C1EBEFFA95666E76AFBB999B3F1547BF4170B014C5BB07A364B919C5C3BD
              51D26C4571338A626C51B91DA5A572942ED7A3F66012A5ABA0176A51EA8AFE46
              C0AF75328EF64471398D92BEBEA8D42E459524897AE334EA43ABFBA276D40BDA
              13C75189BE693B6A21F28D248EAAA055F8ADA569546BA451A3558D5A17901CA9
              F4D7187E2D93F130CEF5D260548E7BA29E248D06D3381A43B07721F0BB619E00
              8E0147807DC00A90808B245A032E0167D1B16924630A6548175A49B4DAAE47F5
              73CBBFBE49F9B54AC60487A19EA85CEE8DFAD132067D3FF028F0781CC787DBAD
              E840524A267AFB0646864686FA0787467A7BFBFA9224294569DA6EAF2E2FD517
              1716D6961616E65BADE634AEA49B699A5E4279E26564613269458BADB5A8F679
              E3D72F29BF16C9D8872B61A23F4AA29E68006732937004F8A8C3530343A3878F
              1C3FB5FBE13367468E1C3FD9B76BF7DE322029577AE25209194C12E42A4642D2
              76ABD94867EEDC695EBD7471EDD30FDE9BFFE2F34F6ED5ABAB9751FB6798413E
              417DE73084DD6836A395EBCB517319231C74BF16F0A527635712C57B47A21E0C
              FCA3680DAF8233511C3F8561E9CCE1E3274F3CFFD2ABBB4F3F7666706C7C5719
              5700E298C6957225EAEDEF8FFAFAFAA352B90CF7386AB55A51A38E71A85E8BDA
              E0A14B91242466B2F9B39FFCF9FC2FFEE62FAF371BD5CF91B0F7708CB771AC0B
              709BBEBE14D59731F94B63BE64F85293B1BF2F4A7661488A4BD13E84E331A8BE
              86203E7BF0C8C987BFF9FDDF3EF0F099AF0C944A659EF5712F02BF7BEFDE686C
              624F34303814F18A406005E5E4D657D46EB7A3EADA6AB4B2B4182D2DCC47B55A
              5512B3383FDFFCD3FFED7F9E7DE7F5BFF9A2D56ABC0DD79FA3C0FB4914DDA8CF
              47D5B3280ADD970A5F5A321EED413C87A20184E0185AF12C1AF2D2C8D8C4732F
              7EEB3B279FFEDA8BC38343C37225F40F0C46878E9D8846C6C63099D85C0D6022
              9421AB603AA1D8DA69B4B2BC14CDCF4E476BABABEC6CFB83777FB9F627FFCD7F
              7D696D6DF15D78FE2DFC7F813BB6EBCDC568F5D3F6979B10B92DDC6978B882D1
              65301A46204E60847905AAEF1E3C72E2A5DFFF87FFF4F499679E1BC6AC8C0BA2
              12637E884E3CFC6884C44498A5B530C0855C21484408B2F800F4F4F646C3A363
              51A5D213D5EAB5F8C0A1233DCFBFF2EAF8B94F3E1AC395D30FAF2A32B0889B86
              D5D16AD49C91525F0EEC78324EE38AA80C462371C23BD8E89B08DBF7BFF2FC8B
              5FFDFBFFECDF3F3C3EB1BB17418F070687A3479F7C2A9AD8B35792A0439101F8
              0EB9C058E41880B1A6034182A3A1E191A8D16844B8032BBDF0D23786AF5EBA34
              3673E7561F2AA9C36BB167205A896B516B399FD71D831D4DC669AC9AFB07A321
              DCD93C8C007C13B741DF79E1956F3DFB77FEE08FF622401C96A2A191D1087305
              E685C1421200360C79487DDC05107C95B1D797A32AB0FE81A1A1A8CDA53BB2FC
              C2CBDF183AFBC9C7C3335393B80B8856DA713433528A56A770DBFB65E463C792
              710AE1E8E11C11638E88A2579988AF7FE3B5E77EF0FB7F6F4F4F4F0F1291605E
              188F1E7AEC499EB95AC80342A3AFF5604137F0B2329A084B12592CDF0706A216
              1202489E7BE995E1F7DF7AB37F79719ED54FB793686E0FEE01A65A9D0FD74DD8
              9164ECC1EDEBD870D41B97A3C310BF8E90FCE0A9175E7CFE473FFE77F7E1AEA8
              C433B60FB7AA8F3CF1948CF106721DE0C540768E0C2D12711F6C1534F8B94478
              AA7ADE9D351BF5A85C2A27679E7E7EE89D377ED653ABAE56E1318B35FD42A319
              353099EC6842762419C787A272BBCC9C44CF42FCCEC987CFBC88C9FA40C55D11
              BC4B3AF1F06332514BC000F7160517740B3801BC25807AE3C5951B6426BE56AD
              4623A3A3E591F1F1A1B7DFF819DD16E07567A01C2DCD60FE60919D82AE27E370
              12257D03D12058AEA6BFDD3F30FCEA8FFFF13F3B39B66BA212C70987EE68EF81
              83D1FE435C746F0330E801663A4D025F8EE3BC213ECD66233A76F274CFE71F7D
              D03333759B93F914D63E777635A3DACC0E5E1DDD4FC60886A7383A88CEBF5AAE
              F4FCD60F7EEFEF3DF1D0E34F0C200992883E64EAF8438F60B8D0A6843D97B811
              2CA80590804AA0374642424A9982D3291FC955D96A3579B31063A53FF0FA5FFC
              399253E7C3C69BA5245AA836A226B3B313D0D5643C8AF544DC1B8DA3CF5F41CF
              5F3BF9C899E75FFBE1EF4E94CA1C9D4A72DBBAFFF09168746C970F5227505366
              2727812E96713A4984F3373F4B8CA7B257487022F0EA181D1B4FD0B6BE0FDF79
              AB0AB75B304D8E267277B5235747B692EA02603DD18B4E1F40CF9FC04AFACCF7
              7FF70FF7962B951286272422C642AC12EDDEBB4F02E31F6D186ED07F09A20BA8
              820B3E5124D5D187C9F6B6A24CDEC95C10F27917AED5F83B3FFAFDD1BD078E3C
              824A9E403507E39EA87757C955DB65E85A328EA06FB84D1C027B129179F28967
              BF7A74F7BEFD3D1A140604B7B2E3BB2224479320C1D77584A421DB696E1C04AC
              041C2F65B989AC3A199AA82B24A4A30CECC1ED34AF56DC4424DFFFBD3F3C18A5
              F119143F051CD9F79B9E8CE101DC20A6D11EB00FE3CA3FF5F56F7E7B0C01C2C9
              C960F0CA48A2F15D139208D9E48A80B74B4C18F430120CA051C7A9CE824B44DD
              C80668260B826792A40D82CE0EC49D1D862BB4AB548ABFFF7B3F1EC1ADEF7154
              FE30DAB13BE9F76F607515BA928C87F8D650140D60C775C5235F79EE85C3BBF7
              EEAFA0D710B5F3BC22FA0771E168EC05F50A09A0207AD02C005817F3A0755210
              1E1B836EFA0CD15D472529EEA4E095CAAB828FE32963F58F84FC3B87E1F8100E
              72046EFD47514C8FD93DE84A32CABC31C0E58D581E2F577A4F2219E30834FA9F
              05A6A7B74FEE64FC95E1222F5458A711BB028A2995B8B01EEAF23C03CD331E3B
              0D76881278A2F30B907ACE619CCC69FDCEEFFCDE58B9D47702959F441346B168
              EFFA9D67579281051EAE82681C1139B67BEF817D878E9DC0ED2DBB98617FFF80
              845B87274D8025C2E87A60E0155085ED72F51ACA95C1A0E7D0059F14B2248528
              0989FD95417AE8C8F1CA89871E39003D1FF1EF422A7AE4C05D846D4FC643E857
              19F321C2C40F0F1C7AE299E776F5F4F4E20E4A3BCDCE82910953872526A49008
              D172675206A8C571E4DD4E90F51B6AB0E578EE98764528AACCA4A85DCB2558E9
              F1CAA00D09895FFCF66BE3EDB60CB5FB309DF41E42111EB25BB0EDC9601C520C
              BB60F763B43AF0F853CF0CA729DFB30982888EFB21CAA14F045FCC80ECD6836A
              3578D8090D37EA74BE70417641D7046549B044F82B833227F0C08F4F75CBE5F2
              411CF0207A30DCDBDBDDA16AFB93D12FB1E02DEDBE893D7B264677EDE2C44D20
              F1C8CE32E01A734B8864C151E1F200058A0A12946475D2901B9E24211A604902
              03CDB39FB20BBA47B1415FE250A593F9A1A3C72B7BF61FE21DE101543702D56F
              56327AD18FA82DCFA2260E1E393A8A4B5F266E82058CC0AB20776588C6E7C124
              150CB468060CBC50C7131158F2126C431770490CCEFE30011C9AC4C6E1A98CC6
              C35EA20C5B6F7F7F82F96E04F5322123BD09EF4DBA07DB9E8C3A6FA6B8D84BA3
              F183478F0DA1231A2F0B9CE3F9C1019F0410BB3264135E4CA213864440222F01
              27B5A0EAD5102642AF3E4309702764F06578823FEA130ABDB41778E2A1C70740
              F9F1A1D116A6BABDDA80AEC0B626E30006249C3A65048EC3D4C8E8F8AE1E8D9B
              B63F751D24B69A4D8DB1BCA71626443C651390A2AC848465411078198E4CC62E
              4C803FF3DD70253A999875721694042AE5A6C31AFD35A1C2637BE8B147FA5AAD
              7414471FC318D5B3971F2AED126C6B32AA2DDCD6EAA53C1827A5A1C1A161AE5C
              5DE3D9B50C1A8D3A82CFE7D3D85C42089610F1960259B958AE920C549FD93541
              D048621C5AF089BC025C424CCFA0B3023B9E24C12181F346B3190F831D41DF7A
              96BBF868645B93C16738498A39238EFA908CBEC1A1A1FC18EB3A48900F9B21B8
              D950A5D78278C84E930283F309202783A7BF430655E2EBCE744D10020F2C0589
              9080DBD5406455A044D52134F01BDD35C1E9A41FD6419C3B3DBBF4E94257605B
              9351C275D0623252AE33E20A9FF3AC6BB9D3F0D37F29E60D820FAD2484C1D778
              ABE44064D53B713D381F1E41D0826B578121372642BC0CC0A372D5683926928F
              46FAFBFB3838312195563357685B615B93D183BEF07C02CBDB597EDA232E068D
              3D61909808260433B90441AE0C06B34301AA520B81932DF0E26F48304A603248
              64AFC755C6EDF832A3158442AF0C751B18188CFB06862B711AF7A273955AE103
              29DB09DB9A8C1A50FA104725D05238BCB073D9A4CBFEC4D1EACA324280C44022
              2A47C15D1362508F6CBE70D1909D82B8B94D3825402D63C3213F832B5723D452
              DCE93D8A16A82F8112D61DE54A2F3FCAC3A70AA5B8B5BD310B615B2BC67CE181
              9D933B2680262038149301E4676265750E5F069B65102D47C340697DAA57DE29
              A53AD9E3D211113BF5CDD7D34212783B2D89E1E6ECEA236E0EB2324C0E86358C
              68D2780C6CDD4B04615B2BAFA036C6045B0B9D41DF5BB89B0D12419E6336287B
              D66EE98794D971DE50311E0C805287A6770A091E180D62804EA757810BB44B40
              DAC66D9EE898789714D193BA321850E5C8AC8BD5F1DAE04BE6195978AF1B72B7
              1BB63519728EA36FE80C17112D0072E3828FE8CB30E57CA5A738FACAF2328281
              925ADA05CC82C2EE6B90190ADD38ECA8C9DF8DF9403B3B03EC02CEA189C8AF0C
              18A265AAA39D65EDD84C90AB43F652771A95B132A78A6DA7AD5BB0ADC9E00500
              6C23CE4D04A751AF55DB883F805DD0335EAE0E9714EE5BCD46545B5D13170DAC
              06D8903283AD1920B5A0BB0DBC065FED7255981E7C0BFA16AE404B8A26867A4D
              969461125C22A41A6C3C06913E8D46038E2882A3D75D37BA01DB9A8C9BABEC88
              7CF0AB86A1A1BEB4B888C420EC821A7CB9D68990A557B0ADACAE444DCC2F3A9E
              53AFC1F4144A46436227025104F5717E4C88061641076A804111704B1893E36D
              E247CA24107970865C1343C41D5FDA6CD4D9A7269ADC2AFFA624234D7029E3A4
              03BB8660AFAD2C2DB1039A043AB8A4A89089EC3CBFDC82DEBB00A2BF44444782
              22C1861E9B04CD51FA4AE01CCA9580858E0E51BC22DCD5204147B2895828A84C
              A42FEBE231B3248427053F02DA6CD61B106B50377A7F5392318ADA30B036D15C
              7EEB74757969114B24991925EA2E0700A708BAC5C0ADAEAC68F005990FE5111D
              A50C18A8064F83C6E146FD342198104019640DB0BF22383471B87289226A1977
              953089AE5ED9C496F24901AE8C5A038A2AD4CD844FDEBA04DB9A8C2F7451CD39
              030356B43C3F338321D600A794E420D3583EB47738ED1A357FBB1B065C7856EC
              820E460348A4DDD934D0440458AE0AFA708E08AF0645A94F92C372EE18527F96
              7C22AED8F6CACA4A156DE5D5DE58E562AA4BB0ADC920F42698BC7155805D9A99
              9A5C6397F44A707B2F01340B4EAF99E19759AA6B6B28C5E0644387A2063D4B8C
              F11A584B22136213B44EDE05141B93020A7F3D96D6EFEB6642B0CDCFCD3297FC
              823FBF87D66877F12BCBDB9E8C6A3D6A23AC1CA6D08FD9554C8094B30C182580
              A728578C6506BDE662910991DB500B8C51398B492DA8082086184ED461B045F6
              578205DCA1950B745A973B8EE8D01EBCA66EDF6A969214E367B40C7583CFD2BB
              05DB9E8CA18ACCAF928C5A756579657909A102B8587B4AF03A044008A9068441
              E43755EB7564D7861506B0184441065C87299F249F140DAEF2CE16F0A9F8E931
              BDCEC96CE0E4CDC97AB9122FE3AC5981A63985A158DADC05D8F664DC58446393
              885F3A99C31DE1C2CC9D3B8DF062E0A5A0BD09F704C799821401E11851AFD5E4
              FD0F39CB8380328850E895C139C2071334E767B2264CD1F1D0FB49DC25814971
              89496FDFBC56C35196D0ECE504D3DAB5B0C9DB0CDB9E8CDDDA1F4E73F3A55234
              7FEDF2A55A9C044FAD84A393F27A062A3895E8881C8ECC91677AABD1C4AD6643
              8631BD65852C09D244E859AEA8431AE92628896052782C9718413D3E8F73E3CA
              05CC17ED050CA52B4D5D43750DB63D191FA31FB8B9E57DF9026E9C66AE5FBEB4
              8A0E67110FC13DED9184B8A00B9A9C633539C1592B090A1360C194C03AB9889A
              6427BB724C0C146253A43E8DAAB56A7BFACEE4329A3987C3AF80FE662583807E
              3019F3E8D8E48DAB9716EAB535B903B1A0F22532B5AA14C29D8821E514E48248
              25CBE810A3C9910033A0E2E378274B802561282B435960076A0210781CA5E5CA
              6A7254BFBAB4D4BE75EDCA024ACFE0CA585D5DEBDE9D14A12BC968622441FF96
              C1DE59595E9C9B999E627204E4EE4938ECDD95611A42B6C025D5E06B7234F89A
              1C0D9633AA2D4890C90CB05C01DC8C277A5F571713E3CA4959D1A5D1CD6B57EA
              5881CFA121B3A8620DD1FACD4BC6028674F487775453988067D0A91A3A89E86A
              678D0A47AA160D0482C08D67ABDA3460EA643A7A68D0C20410FDD0837260546F
              67BBA1D4A93ABB12FC152188B2719A9EFFF463AE2F38442D2431EE23BA782745
              E84A3278FB81539C8F0FA6E338BE73FED38F96F91EB476C5DF4E798AEE6BD044
              C68E546475D0209B0F51030706560BAC227516544D965D099AA42CE8E05D3D9A
              1CFA932ACF767EFEF1C7CB494986A8F9462B6A4CC2551AD425E84A3216D19F18
              0B247602D1B973F1DC398CBBE8A20C4BAE3F20EC9BF64F04A0783954270D4CC6
              8B2CD4820C5E02AAA85789059A487F0BB2A1F9395FA9C7D9DCB6B6B29CDEBC76
              895FB49C41B3977B12F9A5B7AE42579241E01D28AE0176E6CEC2ECDCECFCF434
              1F20A2C344ED305F1EA911235EEAA454F41A40A19600675F8F2EA041190976E0
              E3E70A434E05C2EBCD0193383F3BD39C9B9E5D807D067785ABD56A77EFA4085D
              4B065ADEC619B502763229A5D317CF9FAD61C8D2681324CE14190CDD7404733A
              171C3DEBCDD7D9B957A3F3531A0E499234B1393B6DF4319DF8A84E7D501F6430
              7C45D7AF5CA95757173879CFA02F55DE8881EF2A742D197398311003AEC4316F
              445397CE9F636204D05DB791D71D03200111119B2AD487D421751640A1167852
              B12B1574BA9C6CE874E22F09B7C42021D85FBD78BEDA6CB56621CC25EDA8D6DE
              81AF1F772D19B3E8176EEDF97DF61974FAF6950BE7165A7C848A0EF3F6564082
              6141512AA84627BBB3D5CBEAEB512DEA2389209BF9AE1B923CAADE0F79A06094
              A285673FFE600917F234AA9E473F1A976192667511BA960C42B52E6F55F2B738
              6E4E4DDE9C9E9DBEC3C7EBD279891F793A920A43A5A2DA1C4FB4A06D84DC84E7
              996E88F22CD7E18AA0CDAE265FDE6D8D7A2DFDE4FD7739444DE2AA5E68D5BB3F
              5F10BA9A0C00AF7C2EFE6EB79ACDA96B172F70D8828A8126B8903B8DBB0874C7
              40823A4BB6515740EC0AB45026DCE48A00621347AF23D53AAE5DBED8585D5966
              32F89BB82B6BEDFF0F246305E36C92465574682A49E2DBE73FFF6C999F71D518
              30F2D277010B0E032263B7F0B42B55B3289C2E4039FBC93B7F570F15393F87D8
              653697742F83BB74FE73AE91F80B79FC6DDCEA4ECC1784AE26630A275C03EB0D
              0CC1B3E8E7CDCB5F9C9DADAEAEE12CD3BE49605CE0C83AADBE2430C200DD99EB
              36D58133E426BC9B5F5C7274822F2074D4EB644DAA757BB9D58ACE7EF4C94AA9
              1CDF416366D25654BB099334ADCBD0ED612A6AACC90714B0DE486FCD4E4DCFCC
              CD4E73DE60BF059472275AC7910723C113B514F0A81E5A86BCE920DA842C4230
              FCF8CD6487D86532CAD6EBF5F6A52FCE2E623E9942E58BD566F7177B06DD4F46
              4B1E33F13DF1C976BB7EE7CA850B6B763785EEEB5E890F8ED964B34039A45DF9
              FC196D7A291926813C363005A42B770EC0A3362EF65AB76F5CE57C7107AAA5BE
              6467E60B42D79371157DC409C7379B70A6A5B73EFBE0DD05BFF8E3CBC54303E9
              A843A771A824300B72F12CBE4EE193106CAA071157F2DE92C910F811BBEB972F
              62B1B7C2F5C514A6B7D5E51539C28E40D793416835E4FD0DB955FCE2F34FE631
              04B0FF0009072342C1530D96CAC66741537F4FB939D9782D0A1E67813EE97076
              F1C96C3A87A88CBDF0E73FFD6815E70A27EF59AC2F6AD35A644760479251E3AD
              A1DEE24EAEADAECDDEB975931F8CF69D647F75B3C0084343C6ABD56FC28B0FA9
              9AB3A0922A886FE690F17A4941CC8634CA673FF9981F3E98E6FA286E458D65A9
              6067604792B18C299C0FDBC0DED1472367F95E4710040A121A61FD3C408DE329
              3A9532D4B94DFC489D9FD210A92AC8BC6278E588BFE2D2E2427BE6CE2D3EDCE4
              FA6209AA1D9BBC093B928C595C170DF76804F7ED5317CE9E5DC1D9C798280883
              9D53F8099EB2A0631C2551D6F1A293FD3AEAAC2AAB73E6136C3C0178C52ECC2D
              F089019FA7AD2EEEF07F6CEC48320809D71BB8F41188C9AB97BE5868361AFEED
              0D090779A10E55725B10407174BCE99D4E14D4AB415089D3A955A9E814C5884B
              E5C6952BB556AB360789EBA26A7F173F57DB09762C1948056F1197D0C9DB7353
              776667A7A7B0DE9028C88B40C983984285BA093A868194EFFA395E511D64232F
              2594663EA653A0C4EF17E3E662ADD56ECFE0CA64326A8BABBEF08EC08E256385
              EF1F63BD818E4EB5DACD996B172FF28F2DA4B7D263172009966C0AB9001A5A29
              7D011D43103BA9E33D0D5020AF4B718777F1DCB965DCCECE40B38861B579874B
              941D841D4BC6552CFE302CD53021CCE0D671EACAC5F34C8C0B8E05DFF55D54A6
              CB43163F71924D5FD8A48CA339DE959112E49DCECB51B4B6B6D6BE71F5C2226C
              BCAD5DE657DA417714766E980254F5C36DF3C03BB8A3E2FB1B8C8546843BA306
              2E8A0C9EF16A270622C1282060C19B133060F39046D393B75AD5B52A276F0E53
              2BF51D5CEC19EC6832CAB1BC2FCEF5C6D4C2DCCCD2DACA72D66189954529E308
              BC822C8692004FB10B32C2522A0A676AD57BEA243A1A62B8BC72E17C3D49D245
              B8CD4355C358C5223B0A3B9A0CF7B53DAE31E6D656AB0BB333D30D8987F5DBC5
              86C89D0B9BB3D250A06EEFEBC06BDDB7BC4494013107541BA282F4CEED5B75E4
              84C9582A45517DD5376AE7604793B1C80F7BEB0F29CCA5696BFEE6B56B35AC80
              5D1CB1D349C4A1111A89605D4C7D9C1CF1765A8475143BE5159D721D72BB79ED
              6A358E6349461A47CD1A953B0C3B9A8C3B8D28ADB8F506EE49E76F5DBF5AE54F
              0EF920B3FBC51004B20434000D233697446F15C64924AE9CB717A0D968A68BF3
              B355D4CF64ACB65B3B3F79137634198435FD24F732E2B770FBFAF5B5EC938685
              21A61040529733B1AD4FCCDD801E2E7905A9D9A8A75393937C4B98DFC3A83676
              E86DD622EC78322A25FE9405E78D74110BBFB5564B3EA320608CC41951115902
              EFA89383F1CA21177F4A5561C4F10433099A5E0F52AD56D395A5252683771435
              7E4E41ED3B0B3B9E8C95257494FF4C9C464BB353B7F99D3F745C5FE1B5A1F182
              2BE245D49D26C4A5C5E784A01A7DE025730437CF77003980FAADADAEB45BAD06
              93B186A4368677F83188C18E27A32FC6E22F968786CBAD76BACAEFFC2188AEF3
              1A200F60BD46224B260035685C85925127CD932BA00EEB41D568C40A7F5B8337
              167C17B2D9920FA2EE3CEC7832F89328B8A5E224BE8AA4AC2D2DCC73ADE17E42
              81109CEE0486658360763EE7C3F28E07515FC30C78600C51FC622DFFCABDDA4A
              A2D66D5E235F02EC7832CEF26D267DD4805BC9B43E3FC30F4423DA0CB8BCF386
              DC90EF8072E6F33D08F781B4CC16F0A277B2F12813CB7B179DB18A610AF9E2A7
              581AA5346AF7402B8DDD61289C86DD875E9C8AA7C6A3310C4CAFA0CBFFE4B95D
              07BF77BC3234CC5F7DE74F7D56D022FEFEAAF04EE6AFDC93CF7CE28C77989383
              325B39DBFE62A067F95F9EFBE027A524FDEFE276F406FF0EF6F2973089EF7832
              FA71CCD323D148BB14BD08F11F3FD933F6C3BD93F323FC773E0694687C911A6F
              18EA36A25B49C69F1DD9BFF41F2D4DFE3FA518C948A35F0CCD470B6F7E0957C7
              8E0F53BCA78D137494DF89E59AA384816113E0D952C4ADC056FD08B2A8D037FB
              E4D71C30B07D29B0E3C920E0A04C00B18DD573C764DC4BE043B8D7723C788973
              0B8AA19C14BD9FE36E077C29C940007813231B6F6342B8D7601ADC6F39425FB5
              1AE3A4E08F23F33779633EE3FF32E04B49066F6E40F8B309A5843F5EE860A793
              60D05BADF2273AF9EBD4E5348992D52F252A5F42323881636CE62AAF8C5DA99C
              E8AF42DF6F22B60376F70D94FBCA3DFCF7B44A338E9246C781B3FBB0E3C9E0A0
              C4B30F8194BBD0B456DB521BC2C06F35795BF5198D4B494F9CF027B6FB4AEDA8
              94CA7F1BEC3CEC78328E73644EF9A65FD4C7CE3757361F1418158B4CC8DF0DB6
              EA47E869D4E3A4DDEAC7053100ACECEEE2DF326C063B9E8C128E882BA32C1D4F
              A3FEA19EBE8EFFD6722F810FE17ECA955756E3012403E5F82FFE3D6B5C8B7F09
              B0E3C9586DE1165217D0834848FF605CF6C9B040DE4F24EEB71C61204E92537D
              8383283F8C1578DF40EFCEC785B0E3071D1947CCDA9A8CBEDEBEFED612DF67BA
              7F78902418949ACD68AC56EF03CB7F87EF6F60DE50CBCEC28E27236DE298B1FC
              1BF2D050B9B71F0DF8D2EFA6F8B0F064FF10E78C6148FDFC1F2C35EC2CEC7832
              EA6D39661F3A3E5469B5FBCABDBD517970302A05980434874383516C1418090E
              45A9E0A0C3A1A8EDB0B545A4EFFE28E971C9184C7065F0165C1ABC83B0E3077C
              6214734512BD10A5F13FFACE8FFEE047DFFAD677F6269845F8A3F5F6FF1AC2A3
              69C2E32658A8C9406EBC37A68C9793B9D70E899E9BEB9D5A1C887F11E2E8D2A5
              2FAAFFE23FF9977F9994D2FF11777B7F3DBB14CDDCE257E07610D6B7AB8BB017
              F7EF7B06705B1F47AFE2A2FCE33FFA67FFC1775F78F91BA35C854B00F9F708A4
              0E1960465417E9D4D14E56A9045919E15946C0DB1C159D5227296402DF036FFD
              F31FFFDD5F24E5F44F20FFD9EA4274F3F20E7F30614787A9518D612F8683F138
              298FEDDDBF9F7FC0ABF1CA88063540797A22BC7310C8742CA965A856DE90B2A0
              9802597452522C0343C3C9AE3DBBC7109089388D068747767E08DFD103B6B1F2
              C675CFBB96B1DEBEBE9191F15DF2476B16120B90B0B2538BB3BABDBA99ABD844
              505ED52ABB0F54E575009345C763002B954A7CF8F829DC4DC51328365CE71F79
              ED30EC68327097C291877FC2BB6B686478687864B4A40181C6C5CA118BAFB7F9
              B31A829471264FAD80A37A652855C67499EC2B00F0E9F1438F3D3194A6F104D4
              A3E524AAF0AFEE9C794760470F76664C12710647FDE3E3474EFEEE3FFEA7FFFC
              0886049DBC312FC87FE9918793E844D6208AECF5E4F33A76C464F127E5663D2C
              F4342FF2233E69FAC1B94F57FFD3FFF6BFFA2B2C84FE1527F1763D9AFD6C75E7
              26F14213BB078388DE91916804D7FEF31806FEBD53C9E00FF6CF57273ABD5D6A
              7C4E8F96AEF7C582C5C9451BB1E373964DE0DAD040F30F2AD537D79AF53F4132
              FF74AD1EDDBAB0B27393384FA01D813DB80270E9F311DC38CEBAF1E1563CC09F
              CCC6F8101569476C76C22616914DA171408BFC56F1F06AB57C302E8D23EF7B70
              C2F0F1C88ECE1B3B968C81A1286EB76598DA3BD0DBBFBB546BF024CE815DA6F7
              72B9D2F77ECA7582A45E8F9E8F4AE3600F60701AC71C57D1496D6760C79281B1
              9BA3C608706F4F2B1D8F1B2D7FEC30A0F702DD88D2995A7308B7DE7BC1EE4622
              7A0FED5884762819E3FAEE3287F8310470DF403B1EC68C2973EBFD26A11B8920
              3CD98AFB93A4B40707D88BA16AA0BF67E74ED81D39504BEF477A71E7B4BB9546
              FB8693F270CC79600B1006FD5E9270BFC93AD44CCBC7931EFE33FE41D4319294
              EEF93EE0BE614792815B261E6780675BA9944CF4D65ABCD9D914C2C087FCDDE0
              5E7C3BC140A3119FE91D1CC3C5BC1F158DF3AF5D9DA9EBB023C9E8ADC85D09E7
              8B7D439CBCD7EA1B76F07E83F92009C801AED8175BE970A39DEE87C42BA4EFD0
              0E4DE25D4FC67ECE1709FF9D3A9A807870A096EE6AE336B213DC6F12ACDC7644
              8C757C7DB936502A97F6813D08C5F058CFCEDCE2763D1923E528E63FCDA393FB
              4A4969FF4033E5DD4A0EC280DE0B6C47F03BC1BEA5E5E4744F1FEFA80ECB43CD
              BE9D19AABA9E0CBE6B860E0D813D887BF77DBD8D948911789024742B1106DF6C
              2613189D0E83DD83FB8FDE033B3054757FCEC0C209BDD805EEC860A9B227AE35
              E592DF6ACFC2C087FCDD60AB7E1BC1379AF1501A2707C11E8E4BD1E058A5FBB1
              EAEA01F657A238A9C823F33D511A1D188ECA63FCE72FBFC010C42E407BAA9A7F
              C29AE737C362B9FBC587AAF59EC37D039C378EA0EDA3A51D18AA70E4EEC1894A
              541E1C8A0E6098FA4E1C277FFC9DE7BEF1525FBD859B2B5D8E97D1E9DC975B40
              31C5789DF062539E65429BC9BE1EF201953708E167FBE25CB51930A1FFD9F4B5
              5B7FF6C5A7FF27CAFDAB248DDEBFBE1C2DCDE937AFBA02DAD22EC1A3C3515FB9
              1C3D82D6FFEEBE8347FFE85FFCE7FFE5C3038343881DDFF2C3A1137ECE333B9B
              F9B62BCF4A2F13B981AA5E83A48CF2DCD4062A90F119950F80043E0A4539047E
              65EDADBFFDCB95FFE23FFE0F7F16C5E9FF08D5DFAE2E479397F477B3BA025D1B
              A6CE2026B88BE210B5179D3EF2C8134FEFEAEBEB4F242A4480FE70571EF553D1
              0E83EFE1C569DBFB93F223EC316656F3235297884D914F26150339B46F820CCC
              E34F3DDB373034CCF5C611E058B9472EB8AE41D79211F7A2BF71C4DBD843CD46
              74E8C9679F1D4EF889737755E4901F44287C1841F5C6BBB3D8F439C4D555282B
              C777BCB785C708F94D70747C57E98967BFBE07FC71D4BAB75CC15D15AA960374
              01BA968C36E60B905D68F9F1D1F1B1838F3EF94C9FEB653E101D8392E9E4A33A
              2E780CAC06D7302C9325214C00187F0CBE73488446ED5BC06F7DFFB7C770411D
              C54975B48405E0C840F762D6958A1FED45FFCB3244EDC3457FF4C9E7BEBABBAF
              BF1FD343102862C86F80D8E5E52090B9BA0219BB5C0220393D4DB4A9EC91BE45
              74B6E75F7EB5BFAF7F90B7B8C79110798F837DEC06742519B82FE7F03D84BE73
              D174F8CC33CF8E7042CC05A02332084417348759D0C3AB034E3C96F9410746E8
              BA04B8E04B394B84F00E2917D1D90606879367BEF6D25E288FE170FBD1B7DE09
              DEFA7501BA928C5222670F177AC74746771F78F2D917FA1148F4B1D0592F9337
              D905D80583016444337B96049F14A79724888C579800DA598FD85C5D854D3ECC
              E030DC70C710BDF6C3DFC1FA283D0AE11854C37BCADD7956B5EDC978143D8831
              44E1CAD88F4E1F7DFA6B2FEE1E1C1AE6CCAD41016A403A218388405900EF82D8
              69C2C22480161360C1F7C1767E214A6187795B123DFDC28BFDA3E37B307747C7
              D0AF09DC2576E5AE6ADB93D1EE93BBA86174EB489AC647BEF1DD1F8C7299C48E
              C959EE68D859A530E5F45970F2FE4091B3E1485ED09B1F7662A72D0CBE3852EB
              8FB9351C1E1B4BBEF9FD1FEEC5F14EA08203714FD4DF8D6755DB9E8C526F5441
              EC77A3A9278E1C3F79E8E88953BD081EFA6F676980121887C58033D8D0490201
              A6C72EE0F1B2BB2D6F639248B50C9D2CF8569F9497725B43FE51D6EFFCD13F1C
              6DA725CE1B27A27634B67B60FB87AA6D4DC6BE72949453F904C8415C0D275E7E
              ED7BBB4B652CB82538454450243012C340EF6C8E2778BD05929B042AF3CB92B0
              3E016287BF24CFF9C8263CED1BA0DB7805EE3F7CA4F2D0E38FF3AEEA04AEFC3D
              AD38EAD943976D846D4DC604929126F28EDED152B9F7F0635F796A081D26A073
              8A121C6E1218179C42508D2788BFA19403321181BF5D099A847C02BC1F369B5B
              D4463E903BA11D177C4FA527FED18FFFC11EDC149E405587E34A34D0BFCD1FFF
              DCDE61AA2C1FE8E38AF5D4635F79E6F091E3A77AD811F426EB20DB1FCA1638C1
              8047450C2A0427B31C459545CF8D8E42B321C8FB891E1804F59E91B53BFEABAF
              7E7B60646CF7515CF52781E303BDDB3B916F5B328EF6E3C4EB91AFEE1E42B5C7
              5E78F91BBB1020F622EB18309473BC05CEB09008D3993E3724B92B8091133F4B
              AAD5412FB167A87E5B40570771CFFE03E5AF3CFF22EE12E39310F76301D8BB1F
              2EECFF76C0B62503976C99131BD8E3236313471EFBCAD383E0D1EEB07376768A
              C5F1226467B516CAECDC38DEDB90435FF153D90F49E48BC38EAB4B9218EAEF01
              B1F33C27F2EFFEE84713B84DE12DEE510CC9433DB87B94466F036C4B45FC5033
              CF12B4974F384F9F7CF891037BF61D28871D914D78F4CF05478621D1AB4CC80D
              4DC4C2B80FE2CA2882757A324E2F2EA0EE380656263CDBEF86BE0C906D7BFEE5
              6FF61F3A76820BC0D3F0D83D52D9BEC723DB928C4398B811013EA1E5DAE2F84B
              DFFEEE383A8CF6671DC18E2F2F8BCE0551584A6122BCCD950D64B91A5C92E46A
              7041976A489DACA29373758375C8AB6C23F47EE4812CDF3F3098BCF8CDD7F80E
              E029F4F7605A8AFAF7AAEB03C3B624A3C2892C968FE29CC44AF5F099A79FED07
              8FF6BBCE0788DD3ADD3AE4E6E701277B3B83CA97CA6A97A3754C82D98912608F
              F465F7CDBA1ECDC797117D14FD9D1FFF83D1342D1F8374023836B24D6B8E074E
              06CF8AB4CC1FCB890EA1C1A79F7FE995FD038343D9E30FDF2978984E30E86488
              DC364C047512A6DC99EEA91C22B041CE12A081579EE87CEF8A45BF243A74F458
              E5E9AFBE7804C243B83AF697CB512F3F82280D780078E0648C0CCA59310A3CD6
              6EC7479F7FF99511B6DA1A8E1D5F5479645008A14E9213040BBB9C9C21FC7805
              AC2B0F5C97846202DCB19D2DD46F8C5A47560F46824A25FEC1EFFF78378E7212
              8623982F0747B6E1C75F1E281903681BCE0A7EA9881F833C75ECD4E9430F3DF6
              04BFC1CAA66B17D87A87590731263370815D2914B82A44E6E6F466F3B21654BD
              B056A69804670BEBF2579DDAEE86E2C732AE9CD5FDB56F7C7B606070986FC79E
              C24270D7C0367C26F78192B1971FC5D12F4C1EC6C47DF26BAFFED69E9EDE3EC4
              437AEA1A5FECB49E9104A14E9F0B0E37E31D72A20643375F46905789D393B222
              12E1A9274A8255279BD37BDD0698B3BB72A2437D137BF6965EFDEEDFE193DCD3
              C043FCD4E4713A3D003C5032708FCDDF8DE2377D4E8C8E4F1C7DE6EB2FF19383
              4167947AD9756853DCC0073BE9A90F7EA813B9A00FD1D549E75096B35CF49DD1
              D7D9A13CDF2CFBCE8F7E6FBC54AA1C47138E63453ED2DFF76013F97D276318ED
              ACE8F71BF7A181274F3CF4E8BE03878F54B2C66B9F74E73AE1D064DAD437C4BC
              2F914A9692392157D6F1EE784AF34827E1C5E6AE2E3FE438DB86E8EC72655146
              A783633CF7E2CB7D874F3C7218D6D310F7C4BDF238E8BEE1BE9331CE4F7F24F2
              C327C75AEDF4E4B7BEFFDBBBF5D31FDA70EC7CA325084E26988FD2BC6C483D75
              A227BB69229CCE824CABBC288709209B955114F306A83EE01C0FCE27268EF844
              FAB77FEFF7F7B6D3F83457E4701CDCFF001F03BDEF82FD3DF2C13E595BEC9AD8
              7BF8F1A79FEB9306071DB5462B9BE98B889D9403A3282F67E7C1E8238406E769
              434888B4880B65D83B262093335D67CCFB64E542FB6FFFE1DF1FC249C889FC24
              0E3736F6001F03BDAF643C8A56E088FCF4C70134EAE42BAF7D7F5F7FFF403071
              0BC9355A2959E7834D45E5554D6A32F7EA6F7AE145C54488D1E9850B28F5995D
              5C4491974DB71166BEC4BC4E798C1013BBCB2FBFF67DAEB17857750093682F56
              83E271AF705FC9688F62A24A646D71A2DD2EF109ED285BC936684301D2E8B003
              796473B3E75024F933DD297332F620F944E4D1AE06F1040DFD5856F58A2ADF0D
              337FD3E5CBB10FBFF3477FBC2B8ACA27E1720291194EEEF3B355F75C684C63C1
              6F22716D71F291279E3C74E4E469595B88C5373A8F04E16D139DF2A40220A277
              650C45A6596475CC6C22A98FB7510C7C68172CEAEF0EEBFDB52E1555F7CCD75E
              EC3F74ECE461F89C445C262AF7F9D9AA7B4EC650594E3EACF7A2437CD7EB6BAF
              7E73771913196DD24CB7D3C6671D1199542640B2D489CAF140D739EEC55F04D5
              9A0FAD9E97177794CD27A3E2C0BDC88A4579AB582CC7BA8D1F181C8A5FFDCEF7
              F6B5DB1157E487B00AEE3FC887A7F708F75C60B812954A98A8C09E1819DB75F4
              B9175FE1274182A0E41B6B401E0B425CD625D53B1FF30B516D205C53908A9CF7
              A508CE0F4BE6D3D19792E3450E30D41711BB8E7E617DE044FEE11FFEFDD1C1A1
              11AE394EE02E73B4F73EBE07784FC918E7F12BF2E35DB2B678F8F1A70F8CEFDE
              2BEF5B10B56D9D1BCDBF781EE4EF01F293E0D485C172E50CBDDE95A783E94496
              17365E6562134F4F65AF42564605414A824EDE08B1F7E8F5C266751A3DF1C8A3
              9587CE3C7D10F2292C00F7F6F34708EE11EE2919FB7BF8C94DF97EDEE156333A
              FEF26FBD368E83B369BE8144D7FC5C8387464623FEC7949AE927446CBA8177BE
              A4EAA35AF33327F15F970893F32850D079145307FD46E8FCB173D566362420FE
              C37FF44FF6B4DB313FB07008B79B83C7EF71CD714FCEEDBEA8D276EF5BECDAB3
              E7E893CFBEC0B9C337CE8062D8D052B9128D8C8E2319FC0B70768AFE0E9D2F76
              8A04F1119353D1C6972B2B4A70CE26E5C915281DE4789449A9727A8F9B41E047
              CF5C3D66733CF1E5DFFAEEC0AEDD7BF9D92ADEE68EF37191386C11B69C8C510C
              F5982BB8B6E05BAB275FFCD677F6F60D0CC8BD95364E77D248689452954463BB
              2624111CA2D447FDA5132C2DBACE08A3F256A7E8B5BCD9842B503A787FD39B7C
              8F68F511BD8EB4A0EFC35AEBB51FFE2E3F33C605E0814A12F5EEE3DB6E5B842D
              27632F5716B13EFE48D3E4D8579E7F6134921F63C937D23716405AC14C363C3A
              1AADAE2CAB4DDAE6508AAAC6832B6B3E5297B26213517C9C4DD40105920A063A
              B38BEC413CEE82D8BB72BEACF1A6572DD71CF1777FE70FC6D3A874421E8F24D1
              506FB2F5186FD9B1DC17F5C079378E7EEAE88953871F39F3157EF9C535080EAE
              6160845A6327F6EC8BDAAD56B4B6B6EA7DCDCECD29029DD995AA0BF5AA1385E7
              9D8F51F113C15325F4571E9297A9BA3B62E78E29A5215B5DC22BE3758F3FF54C
              EF234F3C75043227F23DC33D5B5F736C291927B0A2C41D297F9EFA50DA8E8E3F
              FFF2B776577A7A7953E93C8CE661707028EAEF1F88AA6BFCDB2B940E01457C67
              0CA4432172AF9BD948B4DFE49D8F538A87A3223B5430D989007ADE6D133F1045
              CAA6534A8370A440C4257EF9B5EFED6BB563AEC80FA695A8FF08FF9C620BB0A5
              64F44651294EA351D478AC7F60E0E853CFBF302C7F6E08B00E2ACDE3C8387F01
              2F8DAAD535D5499B9C9D3C28D19791FA14D5CC9D2AD5C7E9585AA8F968597170
              D4ECE6EB4D5E66392A4837421229219B94773A1AB37AD42A3C4EBAEFFDDDDF1F
              C549C8A7B8F23E47DF167F5BFDAEC9C0DA3A4E7AA29E943F861545A70F1D3B71
              F0D8E9877A39314B23B415DA10D740C2E0D070D4D73720FF3459E395E17CB5F1
              8E86207286DE4F783A103C23A03EF41021934905B2B2F4B23A65E77D3D9B43F1
              2B28599E9BD420C478E7A34274ECF4C315DC69F25B5B7C9F635F6F29EA2DEBFA
              7553B86B32F84F30A8909F0E3C14A5F1F1175EFAE6AE52297BFC1152033E3C1B
              1EE5223D8A1A8D46D4E2AF228857A14344CAA2236F683E4E41C958E11555A25E
              BD09A6573FC7911141A9882AB9FD7AD44DA51C232FB705463B066909FDFFC11F
              FCBD3D50F0FB1C87D252347010EB107A6F06774D465FBF5C62F2E98F724FDFA1
              175EF90613238DB1831B35EC45A1DEFE7E19A2D65657D6CF170457CEF3CA2806
              EACC8D3B773C83CC28D46CDA0EF1763A119C4E3C9CE0FC3AA0383A4137D3AB4E
              AAE0469D83B06D2F7DEBBB0349A9FF10587EBE6A74483F45B3296C9A8CA3BDF2
              B14D2EEBF7C64972E2CCD3CFED9FD8BBDF2F64ECD8B90001C627F85D19D54932
              DC636FF1739456A139DE6CC250EB514407F4A1C2CA1AEF6DA4B4A8D15E8ECF64
              AF3394B28AD9662AD33B993B7961CB947A7CE0E8F8AEE41BDFFB3E1F8FF03677
              5F4F39EAD11F1BDF18364D06BFB58A699A57C2C156333DFCE2B75EE30F3EA27E
              3DA03A59FD6C143FFE38802B836BC3286A359A5193BF192B92DAB949195FCE80
              32F58E14904A29AF82B989D1EBBC0D94BCD83259F94CF63A43A9234353E8663A
              279B822FEA288B9742B95289BFFFBB7F388E7B1F4EE40731E70E8CDEE549EEA6
              C69172546A23C9608F0E0D0F1D7AF8CC1303EEA80AD21836C41A134543236318
              9C086954C3AADBC002B50E82F2791FF286055067450FCAA32667CB3479DE1D4B
              24DD6F84BA99683A277B5EF622294BAABAE75E7C656068788443D5D11686AA81
              BB3CC9DD3019FCE52BCC437C42CB37918E7FE5F917F7EDDEB34F3EB6690754CE
              80F7D83DD1C0202E2414E23451AFF3CFE7613127505F8ED4F12150239BF82A8A
              D6F9534195A849C5C1F953EB8C24C6F812FA52DE719EED84022CAD35D86E3D8F
              BDBCB0991ECCD8AEDDC92BAFFD808F8F64A8C268DDC727DFF4E8041B27A31CC5
              B82A6488C2A576E489679E1F4B535C6C00EE340656AF1E7C7844DE7D85ACD746
              B351A7C5DB85A7DDCA19753E46541F620622B93AF4582A2A43D4235210374A7C
              19EF64D551B3F1C697A080D38A2EB02B273A55391F02CEC817BFFDDDF1763B91
              A10AD11E3CB2C917FA374C465A96FFD2E3FDE991D1F189833244012400FE684E
              06E07637EAC78ADB6E9CF8235FBCADDDF8D00A1210A952BAA15BA18CFA889360
              DEAC92B6C36CF4CBA8D73922C7307913303F3DB6538A46887226081825A8ED85
              975FED1F9B90EF901F456C461B9B7CF5AC633270BF14F7F4CAFBDCBBD190A387
              8F1DDFB367FF417D1329000D80D23EDCCA562A7C0C831B5A146422E48D24F3E3
              0BD464E3C520C68C254811C71B78D195A746FCACA03828159DA96CCF728E1720
              4B1F575F8866336039AF17498872018593F074A562D79EBDA5279F797E2F16C9
              4721E2AE34EA6524692D42C764F0A113677FB0FBDBADF4F0532F7C6D0C0D21F8
              039127181D1AE1975C33B0F9425BC8BD3BBEF30F21AFA290A11C3370085DBDDA
              B9CB318AD4F8F0204EB6AD13782BCBE58A9A2C9CF0A633591910D1C5D1B77FFB
              87E3AD567A08E27EC4B61F91721E79E8988C5EE861905FDCE4EFBB3EF3D51765
              88CA205F17276E2EF46C88E2D5D1A8DB7CC14639FF5C4060151421DB20876E1E
              CC00D4FAD489656C4F285232DE4A12CA064E9FC300C43FD07B593901A526933A
              0BC84BDFFEEE40A994F0E7010FE1241FC15CDCF922703407037DF2D897EFE81D
              3D7EFAB17DE142CF472A080A9F4329AF43143F142CF385BA293846F62C2B5201
              BC738E15A018AAB27A1D72E7A8DA540E8F44DECB24829EC923F5641DF8B24E97
              F1E01C3559A8F004DC554D4C24CFBDF44D7E6E809F3C9C286144EF930AF2B02E
              19FC2A6DBB243FC4B217E6834F3CFBC2183F43CB235A793DB802D9BEFE014980
              421AB55B6DCC17EE573AE9A12F2D2DF51838AD37124CE02115A522879A7405AD
              C9D547B3A36E87BD5292B05CE6A33AE342540027C7752240EA74B2AFDFE94432
              8ABD6C10CAE54AFCD2B7BF37DE4E63AE39F6F1E702F9E1DC22AC4B06FF6416A1
              E72DED819E9EBE030F3DFAF8109F31D981F2C077F230D30309969056BB89BBA9
              0E47CB41569975CAE215C6CD20AF324763CD9A852763725AEF4F22E8993CE673
              E0140ED6D767A4A0F7621C3DFFD2CB4349A9976B8E836D4C016B1DBE3EB02E19
              18FECB883DBF0A7678647CD79EE30F3DCC675341B58EBAC60DE076D61B09C841
              AB8964908145CE6E7A48EF9C27755EA53AEBA0B98450544939D1BA52222B35C1
              EA3322209567654CDE1061D76339107F078E95DA8457AA6A3B3AA972474F9EAE
              9C38759A5F813CC4F7867AF4C7FA73904BC6203C71555410C65D88E581130F3D
              3C363C321614E2D11C02F8FB8132445170570593D0C47C618DD812D055DC8D41
              690904F8003571C48C1094CD8EE8399090F724DB6D01E0A72F056903E54C69C7
              F07BA7174A1138343C123FFBE2CBE388D201E8766159D63352788F23978C11AC
              0E31DBF34DC2090C397B9FFEEAD787F88E9ED4C960A89BA7FC088EAC2D70044D
              88A8A3465327EF107CD9A01ED17A21D36E062E160AC23B85F1813D9F0827653B
              0F948A980768C2763B26EC8902FDCC9CB771CDF5DC8BAF0C61F8DE8738EDC6B9
              DBC7AFE139B3402E19BCA58555D617959EDE3DA71E799C8F5F71CC7CC50406B5
              B71779E34DB0CB820E4D7C0CA22B6F3DB31D05185558CF77388C588A6A0D423E
              B8E6E3B94C213B476C27404E8E29EDCCA310F10A807A653263819A98B9B00CEB
              8BA3A75EF87ADFF0E8189FF5F18F520693C253DC9C50E15345DC0783DD77E0F0
              F15DA363E3EB96EE6C24770C3C1F9733FE7A55682278172593B78A9B8334583B
              28F506F4AE70173FAD55B98C64853231D3E5017A7DE5C12B94B1E30815963BD5
              65546162F79EE4C4C367F8DB8DFB119E914A929F3772C9E05F68828CE16CDF7F
              F0E8B1517ED2412D0E8248F1DBA73D58E859D4658F5D1B8968736873AE3E28B9
              68439B55B5310465F4AA325989D4A34477A62F5025A6745C58DF86003B8FED24
              85A20C282A58CCB1C238212995E3C79E7A7EB4542AED836A1CA9C87D1ED72783
              5F9B953F358C309EB5D3BD271F7A64901FCA52EB7AA8F032C210A549D084301B
              FC8CD4DDC0C7D85AE98FA20C03EF8734A30EAC8CECCD454960CB342121081BC8
              5B8262424C7074FD7109E0039136DEFA3FFDFCB3438D662A7F3D876AFB4E04AB
              71CF6055986099DE8F32BB5BCD78E2D4238FF46541466585A0D8BB79F4B1AB82
              B4D5B2BFF0C1E13708680EC4C49DF96CEC9B5513FA6CEC4F506BE023ECE6653A
              028A64A5B2F07782509BF74BA3479F7CBA274D633EDD90497C38F865059F0C74
              943C177B13432383A3070E1FE323F4CE4703F0BB167ED52D5479FE7B70FE0CD9
              08B6E2B355405D56DD4614A06CA070408D208260FC7A28684D2C3A6FA407B0FE
              C3C74F9631778CE14813F0195C093EFEE919F78F614388E96E1418C5622EF74B
              0719A8CC878321482A909475C3942B2A2457CF7A289A29AE2BE1152EE5EB1C32
              D8B86C065A07F67670C7777075CE1B40CEA682DF9371767EDEECE9AF7D6D14E3
              C96E2CFE86FB83B76225197CF709830BEF9C7827B5EBF4A3670679867704548A
              094850AE07BB3A822B6333F00D0CC8D62070DEA45C16C63C0DF7062215CF0083
              8E090975C6DB3E4F3702AEDB9E7CEEAB8308DBB83CC1C5F43BE6DEDF9064207C
              316EA378AAF3C30763FB0E1ECACD1721B014177BF28942E723B3065F40F9D87F
              0E5CE336EAF416207F657686BB05A123DCADDE0769B3A3EB218E4E3DF218FF04
              8CB7B87C2795CB66719764F460598E2CF14E6A176EBFC6F71E38D0936E100186
              5F87A842221C6F9FC1BD17E091B6DE6FE728648314983234161C3B96EB00EBFC
              3AD559A4778143478F63D530388698F12F2DFAF6F05F6F01920C7EE50584D91A
              EFEF1F1ED935B1473FBF59000B181F81144627506684C930C5D6E0BECEE8FB82
              C271B69AFDAD9F251D0065F5A53CF720BBF71D280D0C8F8D801D87BABFEE2671
              DD61128181EF618CF5F5F70F0C8F8E8BBE13B04A7EF840AE0317F8906E960C6D
              4E17A1EB075078D0C3F40F0C24478F1FE70F308F215CFDC3EEBB7FB2C3C0C2FF
              BBE8877164DFC1A3033DBDFC5ECC46203F6082A0ABE413E1787EEA7CC7618792
              B05DC093F9C0B153FCAD95115C29FD6B2DBDA3D2A0F3DFBAF980308D86F61ED8
              AFBF76B001F013E64409BFBF0A94DFECAA206C6E7D00E85AC55D02C4E9A1471F
              EE6FB7645DD7CF8FD1529D6039CED03319FDAD763478F0C8915E3E5FDA089808
              19E7197FD13009C274B893FAFFA113F0D91D7F9ABCD58E0711BE01ACAECB4711
              D6648D71D5078430C48323A3BB2A9BDD11D92F12200590B24450BE9F3B29AD67
              9B60D3AA0AC6BB5CC59BC176B47862F7EE0A467BBE4D3AD8C41A9A9746726004
              625B939194D281A191615DCD7500B69F57860550FBC32480E1EB3E3B28C5B75C
              D4390AB9BFE3DD13DC679F1450565FCA73EFAA1B9BD88DE55A2FDF3B1AC44ABC
              3C3A80F3BC5AC7899EC8EA7BB05CAEF40F0E23199B4C1AFCA6A51C406A2543AD
              5C17A25B9F10273F50A736868EB59A3234161CB7DA9A757E9DEA2CD2BB00838B
              3827E5720F9FB60EE0FCAE54DB48C60A76A88357465F5242AAF84C8A2536000E
              530C3C81F1158E3B41D56F06EA7177BF107CE20D3A14F76DF2C6BC5387225076
              D466700F2750F1F89B95A4ADB7AF3F1E1A19E1429BDF222E575B086D19D701EE
              6B39816355D857EEE9C93E76234130EAC01E836401B2C38BDA41E66FAC90A01E
              818278FFD0B922D586B6BC9F48C53619B08F8ECD20D419BF417980B77470E9E9
              ED8D27F64C70ED5DE130C547E9C9002E141C975743CFE8D848A554E6FA6F63D0
              C9DB0118ED0B776C5C78D490EF04EBED9D72B5CECB2BDCD16487269BBE582094
              8B36005576D219CA89A8E63C84CA8E0E00D17770F42A65F84EE9C090CCCF15FE
              F56C1B635392E8873FF86FF6E5DEDEBE927D937553B046B362E195E84E44A54E
              367D47101377BE94A30A6163B26AF23EEB6580538516E53BF802A835EC0C7749
              50D1D8C1390C034EEA1873B48C48E863D2CB3983CB6FF4589525CECE9DC1029B
              51EEF87249E13E3CDABDC026C58A260B89ECB39D4066335D9102840DE42D01FC
              734572ADF09281B7E94BF8A20F47189CF8FC00086F9E4A58E345491368C9C09D
              1226047DAFB623404F93DADD019415BD80634CF68DF00E645D3D66F3A0B2DAE9
              E0D043D15F21E71282E985AA90B166BC1BC04F5F196C50747D7F360124232921
              DE982F9081522BC595C1B7827099301925AC21E477DDC57943D0436AB0028D8B
              88ECB1DBB0922072F461596A4CDD31B050EA09E0400A289369C199206C260867
              222093036547805D5F0158CD660B1C849A3EE39D00708CEB0BE604AE21384997
              B0F0E3AD11400BE0AE35B8AB7501C80501E0CF58F26EE3CBED1C88D6972D5283
              4C34BB90BB82ABDD9522647CA81570A292B084DBC9413B20F43451CA40758ECD
              811D77FD3E0F851830DEFE8E4893A12A640323167305088BB002411132193BA7
              277565641780934DEDEB917DD1793D14BD789C1C6C2483DA914CA9654DA79CA0
              67147D5F72102A03ABB1C50281AFC5C7802CE3D06A617022EBD2C161891CA7F1
              36E60C57C49175C04AD5C6BD70EB99DCFEAE60C57211A1E88E15A01E5BED992B
              BB9AF1BA576A24670BF810A8315C0F3CB6D93C436D8E9ACDB4C2A8B00EF81CAF
              DD6CB25ACE146D469EB7B652043969C3418A6A83491D13002B0983A40DD1C6FA
              038B5E18F115491C1C50178821A87E03A303FAE811746F3B2D25460FA655E23C
              487427F2C6003BFCB44D04CAC6657CA6737B6F720601D643832243DD6A35B9B0
              6006522EA5F55E969FC844861AF55A1B406F2D4453D61251DB477124C856B1F8
              387F478DE420AC8B9E10A51EDBAC68A12CC582AA002C2DC4FB398DD365BC7970
              2FC7D1DD7AA45E5F0E3241EA0B79C7656AD3A93DEC0F59621BD968341B1C91F8
              A9BF1666F194CFFD6863841BF57AADD5F13D09D46641E3477134F80AC6E574C2
              078D70B420020A0681F55E529143AB5BD5D439C97601657B050ABCEE54160EBB
              75E83D084E215C27DE6ACF6C428D3786153BE0495D5D5D4130A306D4AD16F290
              347459A1C9A8D59ABC327C19C76455A012248B0E86F4B1023AF5E7C16C39CA32
              22111C47E27C4C475F2B47C8B8C0955AE1ADCEA06E3139A9C02B6B8C57380874
              3C90334979C70B783D77C5E39362339F8C116CD46AE9FCEC5C1D9A1AEE619B4D
              6420A9AD22231010C97AAD5AC58CC22B839568A5163C03993378F5885D3CC42C
              2EB81BB0836AF98C778C52071405C3CD7479575832D0FA9C46084B2A9F51E19C
              C241A827900D913B6D50A0539072A1EC1A98D31BCB9DE90208D518A2D2F9B979
              7E59BE8A09BBB956431E686CC7B832F8EB752B6BF566A3E9FCF3B54970899852
              0469E7CB0726F00F5813C45F98901AAF240F6AB7E38ABFA10311E94795A81D1F
              52EEE1981D3F93BDCEA02012C44B0FE44164E53C5595F969DDA6CBB59F1AD0B5
              D5D5B4CD1F574132E2346A0E96918C3E8E55107065541BCD7ABDBAB6128C535A
              3004BE7F4BD4BAF5804A9D1F796C7C895188A3B25759CC2AC9DE2BC4D7E90A10
              5AB44E95ACB650122A8C4A24661120EB741B6EAC2057C4E9BC44E2A8C9DC9B4B
              C6082712FD81CB8B0B9836EA35E8D620367B998C323F8FC6642043CD66BDB6B2
              BCACE73D942CA8E5952725F2DBAC6A5354BBB87A601D424D2FAEA6053883D529
              681B4C8639E860F02C294D8E57356B536AC48EE381EC46E8404B40E175AE06A9
              4B444F95C7260AF0640C03989D9AC6A9DFE44710D6DA49D45C5A4232E616E1C6
              39238A5671DBBBB6BCB4C8195E4AE68B67C0EF606441549D2BB26EDED05A9C2F
              79EA7C21474310157719DAB108A66559AB9F24ABDB787989CEDB55E36CD9D609
              72765FD46944168BE8BD8F70C2282F8E6A52B3EAF89463F2D675C67C05B88C05
              5F032B8E28E1AF7BC930856420926BCB8B4BE4B52257D8A318DC17281D2F7E60
              D4DF29D713854097AB5335EE6514484AC6811E4331500354D2B244E3E525961C
              6F82B1ACAF80A1DD18CF06BC70A66339728E0A485D0E1D301997CE7F5E4B9274
              19E25A0BF1BF8CE2C917D8F132A112C6D5D9E949CC1F76931A544A4085DC9AB9
              2B23406CFA992AE5A9135E88D66534046A723ED4082B16D504E5D4843D30AB57
              8803DAF872D4F3F41795CA1E3B817939CF6C67442DE43D05F1943A575655A223
              727970F3FAED6A92C4CB08172E02791CA50F0AD3A6AC33908C78F9D6F59B55A6
              420B0AE32B51058729FD46ABE984DA212D914E24C043A92B2FF5ACE31D1A313B
              2073CDB7C33CECF86292C2A2752F0AC69BDEC94E479FF59BDA424658CF8371BC
              BEB0994D19AAB1A3516583266E6B6F5FBF88893B5DC09DD46A5917DD9A8C5E7D
              BF6F15C6A5F9B9E9AA3E1221E42B21F040BAF0D3C51F7D48F5983A1E8ACCB24E
              A7A0D45914A59CCA066A570F16D5F2861988DE95F7B295A1AF884AC92A6376A2
              EE55B131FA0DA2DB61D3A2B29397B30B154629502595AD8DAB2BCBE9D4E4F432
              E405047EAD560D928159A285F3B94AE3EC9DDBAB4D3E4D74853B217632541154
              1646781BA644B6C6898D24F3CD81D8D54776421D6F2A61CDCFE965E78D4EEF8E
              E536B3AB4EBC9CCE138F8450169D302A05AC32F2D2BA8553C6D9D45FA84333DD
              BA7615F7AD4B9C2FE6E154ED715F1A9664F4E32407E1EF9E2EAC2CAFACAC2C2D
              CA18A6A09584C08A3989EB4154964353602E9C9F81B7731FFA9217D9CAE85EFC
              6CA31FA8E89C59CA5008CB3AA3F93B919C39D0287A8ABEA428542965044D472F
              E76936EEBC1E9BD3E971C9526BAE815E402DB7AE5F6BAC2CCDCF439843BC6A77
              B0FAA65592B1C2755C14D510C7C5EADAF2F2DCEC342F0DA948EAF23C044731EE
              799D47A953E70CD3E9611444743AF577A006D5053E86CE9C291CA89F2BA78A4C
              0F8D52E1945727A524190B0CB74C9F6350408F250A294FBD1D47EC8E3AA340D6
              1E555F38FB6915E202948B98201AB88112674906A700601D9A85B4DD5A9CBE7D
              9BF7AEE2209528E32A55B02B436AA78FF03A7FE71B6736A70350E6263AA7579D
              70BA773EDE8F9CB1C2AB9F8033A849F566977A9C2B3D446FC8125E5651D17419
              5A7B08AA22EFEA734AE1489D4ECA084F2A1AF9AC3292C13BA859E002E2D59846
              28699564F06915167E4CC0024EECB96B972FAE51EF2BF39566BA16B227BF1322
              07329FB64CE0A11FF53C94C8724CA212AFA18FE8B48C8AE2E048A0F33C38E71F
              F2EA96E9149CCDCAD9263A28A9176A284E6A779B9473667550BB635443EA74BE
              6E0F2A733EFEF8DDF79084781ACAA55A4D961502928CDB75E4027EF05F823877
              F5E2F955BE1F6E1586951ACF4B497EE4CBDDE2667ED90A9C400E16D5894F5087
              D3093A7016EFC74D94E445677661D4C7F1349A2CBA905707278BC903341D37B1
              395FAD43315727792199CEDB04CC5F5CA39BD72EB76667A6E6A3389D81892B70
              3F3F4B3208882B7FDA6019E7F5ECCD6BD717DBFA66B903AD296C0081F3861E8C
              2A67E7C7A8A9359954144E2792D94CE7A8E81C0DFC6CA34D75209405A9A64E79
              1AD59C5125818F2B6B3AAAD7A3F91B863A11BC2C3AA737BB52DACCA4FA2F3EFB
              A48EAB630EE2340691D5C69A33007C32B0F0E33DD52A2C33CB4B8B0B335393C1
              24DE19396FB4439D5424D589EC698157E2742C607AE7E3A93240D353274A553B
              9EA0FECAD3289CD389DED94CF6BE02E48BA8B0CE9F94B2E38D2A0929CB14F976
              F4C9071FAD567AE2698833106B573A5D198D3A9471C4B9621663CFFCCDAB97F9
              AC9D35F90A5923799181C8B02C00E12F66DE0908E8B491F3E5E675C29BCD7462
              E45EA872F451BBF7130C6DCACBDEDBD520BC1A849ADE30F4DF0805484DE7EAF1
              F680F73ADFB6906FF3E44DCF7EF4DE52DA6ADD817A9EBF50CEEA0D7C32AE0161
              6402664BE578E6E2F92FD66C354D900309E778A2CD1B30D81542CA859FF984FE
              41057C793D37D56568B216325E455DFDABE0FDC58FB63CA5A358299337D9D9EE
              86DEBF20935792A7E0C4A472C0E3B5383FD7BEFCC5D939B09314113E3F79137C
              32380F43E0EDED3CCEF63B572F9C5BC6DD12EA710DD05A953A20A7B7B87A7588
              0947D03B2AF5CB9595C63914BBF264CD47D0CA85E5E9CB468A33F561420A7E8E
              F73A8722BB3ABD1CA29456BB217699CDC95E47DEF4CA057A5212C763BB7CE17C
              7D76FAF61414B781CB357D26E8C12783D06A45AD24C542248AEEDCBC7E65616D
              75D58F670AA8D81D4C0E08E48F43DA3145AF8E998F83AC8CF2D8F195D9B80975
              7635785955E60381AF4242422A7B15848675124D47ADC70D74D8293A597439DE
              9513148B52CACEC6D1E2BD377FB60291C998826A6D99F7AF01E492B1C62940DF
              F0985A5A989BBD7DFD6A233B8862FEC018969A2DF9D80924AFCB86B74C273229
              3679393EB389B7F8889FD78BD6D52524BB42286E9010292B7C67F4407E331497
              7CB97C1DE4D753F171C707E11B72E9AF7EF9D642528A6F439C45B3EBD3683A4B
              18E492814C61652EEFC97282B973E9FC39AE14519F56AAA8BE060C062772CE1F
              62E783150761B99CEC1BA93C1827673EB45919F242CD8FD4AD6FB40C8EED6443
              F5951AB813C86C19BF152CFA2BE47DA8CE28876DD55BFB6E5EBDD2BC72E1FC34
              743730FACC6188CACD17845C32667082630AE0CFFBCF24493C79EED38F97B0F8
              43F9F0A0D9810451AE815B31B3910A38BBB44644270BAADA64256A974D2874BC
              4EAD2C286F0E2089BF52EA5958243A06B6C0470443BA65FAADA282D691E94855
              2FB2E8191FD1285587E88377DE5AABAE2E4D427713F15D4E70EF23860072C920
              60EA6D60DD368FCA6EDDB876798E4F70A56280352244ECE48E4A3F31E2F4E2BD
              DE3FD3F1FA0C7452C2C9F2E2CE69CD27488C78A8B17085289FBF4AA494E749C5
              39879D20B387755979E30DA9E0A6AF4CAF1845EFFCFC670BF57AED16023C89EE
              AF45EE496D08EB9251C33A0E84CFDA6F2ECD2FDCB9FCC5393E61449D5959E1FD
              818008540B730738C8766688A3D89D94F99B1E2F5DA7E82D31155E2FF504BEB4
              722874F5A8AF68BD0F372A3D15429AF199BFB878FD7ACCECD817CA653C7799EC
              102783E9596E6579A9FDDE9B3F9D8AE3F41A3453ED7A54BF404301D62563168B
              3FBE150876B29D36EF7CF6C1FB484CE160E155E0307C4E05062740B6D6089120
              9432DB232CF5B42BAF76A777B2FA407409E934644919DDB9322EA1B92BE5FE51
              6A179E2CA95EE1FA72D4FB65EDFAD55B6F54E7676626A1B889802FC4B86BA5B5
              08EB92B1801A5AA92CFE66D08BDBE73EFB68815FEAD04628128406BA166F7119
              28F01A2826431C9D4F96402B2FE81A2C0133BE60C3CEEBA42CAF26008F63F542
              ABBC051E9BBC3CAFE888E8B1DF12FA32FE8C77C7149172C6931122140CEE2CDF
              FFE52F97416E41790B4D5F99E2A3A70EB02E19845A5D667ABE1375F3D6F5CBD3
              53B76F75BEC5750724F2430AF248DD3594EB3EB3195A033DBAE441ED287414CC
              2F4890D81C12242194C97B9B58D4C774F41051796D5F70C56C01B1D37252DED5
              17F2ACCBF5DB783951D01ACEB9EFFDF2F5D93889AE437107AAEA14ABEA009D93
              5193A19C8FD36F63113E855B32BE258BE3D8C114B1133499F3063FCB209D7540
              17DD49051E4DA64D69367FA8D9F9B23EC7AB2D8FA27375E50312D889BE0EA93A
              D3DD6D93F28532AE1EB5D93183360B0B8AFE5CBB7CA971FDD2A53BD0DFC06031
              9736D6DFD21A744C4633916F323101774AA578F2A3F7DE59B6B3781D5A0380F2
              481D5412C28ACC2740DF60E1E9429EA74A41D60A44A68976E5336AFEA6A34664
              E79B4339C3D52E58F0D1C28AA15EB6C0474E0E918B49C8AE062A69E3E2F7C377
              DE5C6D34AA7CFC711373F17275ADF31045E8988C498C363826DF00E422E5FAA5
              F36767E5639F0EB4110EA593CAEB50A58D149D3CA2A20D24482624CF6F8C5942
              A44E49B0DA68905A0A2788E9752E118FCC267CE0EF9263E8F5F40DF53EF844C6
              D178B0C2179210B489EDFEC99FFEDB19DE45C1CA95F7EA25A8E9DA093A268390
              D665C6E7BC717D6961EECECD6B57EA38108EA10732CC1AA7A81F8AD60612A075
              360A999FA1F89016F48A5942440E0243839AA8D7FEA98F1BEA205B527249C821
              F59BA33FB6A01E4375EBAF04B5391FE08DAB971A581AF02EEA2A7036E1827A13
              D83019D56AD48ADBBADEC0E473EB93F7DFC31D813D73D203660DD08393E787A2
              C37943ECCE96477656CF9EBBFB89474E2F8B4C3B0B6975BC78521724859825C6
              34994CD57ACCFB2BEFDA4C1E5A08D971C5AEB2F1EFBCF1FA0AEE326FC093C958
              C494DAF196D660C3645C419525BED9944658C2A7573F7EEFAD197BA46E435127
              D48F7EA241320C383D9B2E3C487876FB4E063A4FC99ADE021DFA89E478723483
              5A704454997AF3E13E4C8C22CB1431B36BF0B9B1BC54BCFE38E4C54F659EB83F
              FFEBBF9CC510855046377062AF2EB84F816C041B2683D06844FC27AB39B0D716
              E7E7A7266FDEE062C2B5471B400CE709F22DDCE2CA0A3AF4E3E678FA793ED07B
              1D5057E04179D1053C8FE9125BBC4AC0740C96D7996C489F220676EC04A57C87
              7AC556E0AF5DBED8F8ECA3F76E83E7553183855EFD261F526C029B2603EB0D1C
              596E716FB49AF59B1FBDF7F60A6BB3031B12EC6C22D807A3A1E8D8D0225F3C13
              89D869900B3AD9C83BAA7A9154DE2029E267BA22C2877AC3B04C885ADCC9AE8C
              B7396A27E1DB6FFC74796D65D10F51B5958D276E834D9371A111B51B4DB9ABC2
              9D407AEDE3F7DE9DC304CD964095352443ED04DFDFE099AB67B2AE1FC4CE1039
              9DC81B74DA10BBCE3A39365B98E9FDF0E775764C3D16767ABC0EC7949A0A3221
              D409A22C18E59DDD643B7168A8D7AAE9EB7FF9E77349125DC10DE5CD248D56CF
              C1456BDD18364D062189710790463360AF5DBBF4C5D4F4E42457E3046D54115D
              8775352E4DCE1A4C1B3709887626C3F541226297C9087898D86CD8CACAEAE14C
              0F843F18E5B535C25367686D2EA2B71B0665C507344C82C8D0DFBE79BD71F1DC
              E7B7A1BB0CF50C9679B90F1E6C04774D468ACB0BEB8525547C03D3F3ED739F7E
              94FBB46111D92AD270CDB10E9D0F5EBE53442B5B44EC94C7262F96018A5ECA90
              25E549E0EA0BAE14064C8216960B518EDC019D1D3B416BABD4C54DF4EA67C725
              BCF3F39FADAC2C2D7188BA06FB22E6DE4DEFA20CEE9A8CB3E8873CC58DA39B10
              AFFEEA976FCC37EA75B6441B58406D94765A3A0E28FA106174BC3808CFB2109C
              BE80AEB3DC2C00991E28E5E4682A7BBBFA4B19B7D9D99CABA313063EEB12E092
              9D25C1E456FAE7FFF6DF4C27497A19CA9BE5285A5BBDCBC46D70D76410DA58AC
              60ECE36743AF5CBD78716A7E7686BFA48083E71B9C47D8E06343097682D649EA
              45262F01337E937A69933A9DDDCE7E207678D9F128AA4C6A01137F971C2BB765
              7465C9FBFA503F2B131D656C189EEAD72E9EBB051D93315DAF45F5AB850F1E6C
              045B4AC6AA7EB3861F61BFDA6A356E7EFAE1AFF82D2702DAC28659E3326480D9
              68EC9CDCC1879D09E41C2F9DCCCA103CEF283779B9636536F0525ECBD029ACAB
              535B36C3BC7F78F5668B4911803FFFABBF584AD3061F7F707DB1B8CC3BD22DC2
              D692A16DE01B4ED731A15F79E7E76FF0E3EC68836B943B63F288B354D61B1D6C
              61E7B08181AFCAE449B300B01E455F8648997A0659EAC06B83A4B00D613BE82C
              B62DA2FA1BBA04B83AA820E571F90990377FFAD7FC28CE45E00DACB857AF2104
              E0B7045B4A069FBFA7D5A88E897C1A87BE72E7D68DA9F999692EC761D0C6647C
              01911030EBF50E2578D8208057241FFAE4839147EC364C8AD44D343FD7CE6272
              14C52540D57B5FDF069700576F96FC28FAE4FD77AB572F5EE0DCCA216AB6D4DA
              F8717927D85232082BB823E00715C05E69D4576FBCFFF69B2B6804C135461B55
              44098AEB80355C30E0452F5134396F27B2B77999EE6130541F2645AB84049FEC
              D8DA16A2CA0EC32DE80B76EA2BE555EFEB92138766396EFAD6CF5E5F8CD22617
              7957E1BA38BFBAB5BB28832D27E30AFA53D2A1EA061A70E5E35FBD33CBAF0DE4
              CE30DF61C5ACD1DA11ECBC2DD32B5F4C085E6A07D2A6752966329C00BE3C9005
              A50CFDC45FEB93AA25C9EA1BA2F8901ABAFAD6FB285A02B8E931DAF25B203FFF
              ABFF7B121A0E51B7B0345EC35A401BB845D87232084D3EABC2A815C7D1E56B97
              2EDE999ABCDDD08EE3A882594754CE30EB50DE869DE7A5E3399D763A9315A1F0
              BCD54B08651E078CF2D4B36DB64106F168410E3167B77AB8595D94ED18F0BF78
              EE6C7566EA16D716973182CC2252F7344411EE2D19F5A885020B68DFD576BB79
              E3F38F3FF29F38B484A065DAD08EB8DEC6E08109744C48768683883E932DE086
              5AAE9814AF7308852F2F36779C5C920A9BB7BB325A3E5F178FC127B47FF567FF
              660E372C1CA2AE41BD8CE5001CEF0DEE2919E7F8A906DC2180BD1147E9E50FDE
              7A63A651ABA1C54183816869AEB1A14D0258D0F9A0853AFA7183DE2676B175AA
              4F50E5302984A25ECA032178345D11D7F990028B7D9A9B9D6EBDF5FA1BB7E178
              0187BC1537A3DA175B5C5B84704FC920B8A18ADFBCB97CFDEA250C55EE932368
              20AF8EF5C1CF30B369678B760B424EC73E79992CA8F3CB1F8BBCCAD41B9A9D90
              F9E67DB68261D910516BF4F6EB3F5D5E5D5EB80E816B8BF9A50E9FA3DD0ADC73
              32A6F53B055C005E4144AE7FF8EE5BFCD905C4A1D8E07C704C9FF1A01B7512FA
              5C20B8397FBD4234B06448C3FAE9C70085F27A9F2C395B81B05C88DABE347DFB
              F5BF9D8B6359715F4F9BD16AA3C34737B702F79C8C298E854DF9BA1927AB8BEF
              BFF5CBA956AB8526E1F86C1C1B690D9600E48340CC02035A089221769EF7FEEC
              A3D7F370A0B099CEFC941AD296E9F33E996E33D43AF2E5ADCE9BD72E377FF5D6
              EB585BA41730714FA6ADA8464182758F70CFC920A4750C55A93CABBABC383F37
              79FDF245FF581DADD546BB0E602734EC545E0625EFCA853E214A9D440B72E06B
              49F1E8FC436AC1639C9437FDDDD07CCD3FE359D77BBF7863A951D7C71F382DE6
              57EFF23EF766705FC9B88DBBAA5224DF70BAD26AD5AFBEF7CB5F80CF3A8E9D50
              434448681618C57581723AC36280736841B5895D8B2B0F7F0AC5C4D03FE3550E
              118504F37AF5D57279797565B9FDD6EB3F9D2995E24BF2541B6B8B2BB57BBF8B
              32B8AF64CCA23DF5B67CC88D57E4C5F39F7E78A7BAB6963D1E61C38132649102
              A1083AE5FC02BBEA5D103B207642F3FED0F9A458FD94DD10463BF454589B8A75
              F87A02FD863EA401DEBE71A37EFED38F6FC07611CDB8D3A86EFE519CBBC17D25
              8380033762BE8B85A16A76FACECD1B57AFD43084A08DF986DB70453D149E179F
              1C5AA783E0391BF562038AADA8A7EC922276A75B9718B3B97A0C4D176268F73E
              A440D6C70F13BFFDFADF2CB65A3579FC81C32FB5B6F826D24670DFC9A861CD11
              F3F3B871742D49E26B9FBCFFEE221AA457836BB4756CEB0951BDBD652B6537F0
              CB0727F3F3EB930E89B1E4104D56DD7A0CEDEA9395A1BD8EF5D52FFEE6277750
              DB2584E366AB15552FF2D00F00F79D8CEB3830DAC59B38BE9172E1D30F7E35B9
              B28C3B6C06230C207906CBC90C9AF8387EC3608B8F0B28D1F98ABF2B23B6A0BC
              D5E529EB081243B4F65819F55F8FA15D1065C0F83A3EFBE0BDEAEDEBD7B8B6E0
              1035CD91422373FF70DFC920D4D9003E87E15DD5DCCC8DEB972FF177F700F920
              5B073A25C4E4CD707DF0021B75818FE9422AC836394409D868BF07C466E5E324
              4EDF7AFDF5F9346E7388BA5E4AA395FA3DBC6FB1113C5032AE2215692C5F55BE
              16C5E9D5F7DE7C9D8FD81103ED6C3EF8E02528994E0348545D67341FE72F6532
              BB055D103C18EF93B305B8917E33B432A48B0B73ED8FDEFBE51D28B8D0BBCDB5
              C5359819930781074A460DED8C6BF2FE383FDC7BF1D2F9B3B75796965A3E607C
              A72FE88405D312E2030CBA59806853BB22765A4F50C678AF0335BFB08ED0EF5E
              D0CAB04E2C7457EFDCBAC1452FE78BD9E5B5071FA2080F940CC2923E2AE61571
              B9BAB672FDDC271FAD22D804E9C0BA40936707C1FBA44827F39D0F31ABCB82E8
              3E93E5CA9ACF46D48E199631F9AE68BE4028A246A3D1FEF0ED5F2C24497A0D27
              E10D347B651E6609C603C20327034315EFAAE4FD7134FECA87EFBD3BCB5EC8AF
              26F84EB9C0163A98D301A114DFAC5C86E2CB72EB64AD4BD0E93B5141F045F9AE
              68BE40969D9EBCD5FCE8BDB739125C82EA0E3F713907B304E301E1819341586D
              63A88AF97DB5F4C2F54BE76F2DCCCFC9E391FC07D9B473B9AB8172012D08EBF4
              2E1899AC68BC50E1B5EEA2BFE1667AC34E76228D3FFFEB9F60E1BDA8EF73C7D1
              5CE33EDE44DA08B62519956534A8AD4F72ABD5B56BD72E5DF01F90B68E684741
              29071D8751E450473F3806B2D653944DA7D4A1F1A060047D920AE542347D279B
              D9D1B7F48DBFFA8B39542A1FF3C7F5B0BA761FEF5B6C04DB928CCFD15E246315
              63E84D3E4AFEF4C35FCD2200EC95D8F39D5CDF69083E498266E3DC50F02D9635
              DEF4999DD4AE4C2029104296204357570E433B10CAE8F28573CDF9D9697E14E7
              0AAE8AA9B81ED52761964E6E036C4B3208F5B6FC91139FE45EBC7CEEEC8DC585
              F9BA048208431624064379FD0550A77728B2F3D7C0D855E2FC4497AF2FD44BE0
              733AF353CC25C8F9DAB173E8EB52C4FA22FDF8BD7757DB6DF926D265A460AE1A
              FCF2E676C0B62563694D9ECB2CF2F1C8EAEACAF5AB172FACA213E8979E551620
              0B1294D2E9DCF0445FDA9DDE6C5286360B0CE5D056E049432CEAAC8E7B415672
              E9FCE71C8AB9EABEC5CF1FDFC161C16F1B6C5B326E6144899388BF33723B49A2
              EB1FBFF7CE6C1CEB2FF2B8CE740C8A043EA7831FA99379F588CE95BD5B52425D
              D1D65926BF1166FEFCC79D1B57AEF0C1289331DD6C44F545B848E7B709B62D19
              843A27723E614F534EE2779616E61B362C48005C10BC1C04431F350481028520
              9409D93029A05A26AB33A445BE937C57C4153E79EB7A032B6FCE17379081457E
              01553ABD8DB0ADC998E35BB2A97E43B6565BB9FDC5E79FE49E55112D2144AF03
              8F9D0FACA0B34BD01DB539262C2FC974762B9F3B9EF333BE93BC19D28FBF8372
              E9DC597ED85B7FD2AE1DAD2D6124609FB713B635194BFC37CC54DE74E22F02DC
              38FBC9478BE80062C38E6581090317A2FA8037BF2020F407237C9894AC9C1E03
              8E5ABFD315EBE9246F86E2D76AA597BEB8B05C2ECBEFD1CE95E2A88EF1EAD73B
              1955DE7337E559D50CF0DA8D2B97A7F89799D22926443A97EF68A72059408B57
              82206428452F76E8AC7C88722C0C915A97DE228709BA17ACD7AAED2B5F7C26BF
              6A8AC5ED425D3FAEB4EDB0ADC9202CAF46FCDDEE45E08DB5959529FE652682C0
              4D3AC6A4087581D52069A0ADF36AD7B33CD4A9DE95078211EA13421AD415D629
              892095C46892F2C893C0306F9BBE731BF3C502BF82CDDF6E5C59C334A8BDDD5E
              D8F664608CE2EFE3F267BC6FF39715708BCB39244D5B5970248021F2395651E7
              50CFE6A22E087801A9CB5D31816FB16C5E476A98B3A7776E610AAC2EF36A9FC1
              2D6DB50CB3F6767B61DB9331897EB574A89AE29AE3EC271FCC349BB8A942FBB5
              E3AEF3E403596C22770A5416ACD06601B772A450E815E39E8BE57C8136F4996C
              751451DA01247CF1D927CB60A720CD805667B675A997C1B6278390566535BE80
              1E5D9FBC756372766AAA2EC39304D3252248420EDD556249A04EBEE4EFE47C52
              10F04E7500C597D4D0EA056E54A613F20FD43FFBF0FD393E084532161AADA829
              7F2BD905E84A32AAE807087F59E17ABBD9B8F1D947EFF3AE0AB9808181F4C164
              70C2E4105DD0C5E67C5CF08A49C10E3EC115403F43574EEB7665C80361CCA1E9
              3B60CAFF479A9A9CE4628F77888B18A6B67D7D61D095645C42CC38B682E56FB8
              7EF1C1DB6FDDC41D89FC0A0C3B69C1930EBB24B431A7F8A0066881111E016542
              ECD1BCE9AC0EF10B6C3624F9A109487FE3EF86ACEFC377DE5E4992361F99DF40
              9F969AF7F86DA47B8192A3DB0E23499496CB48451A8DE0523F582EF71C3C78E4
              681FAEEF98DF67C84351064085B8750406B408998EBF3BAE545E4C568E578A9D
              F21B20616D6DB5F5A7FFEB9F5C5F5D59FA05C47790865B676B0FF641B5CDA06B
              C94870FE0C56A2765C8ACA1077DDBE71FDD0234F3E35DED3D3CBAB311F7D4838
              EB3C2F71253A2F9103B0C296802C110A994C1A2487288457D3E688F325FDE8DD
              B756DE7EE36F3F05FF53B4EFE3662B9A9FB98F2FC16C15BA960C7E4C7D2F7F2B
              AC2C7FC858C664BB677A7272E2F4638F0F25096E7A0DDC5562E10B0131C90C70
              13398440C10076A2040B70A623DD14D385F9B9E6BFFE9FFE87ABD5B5E55F40F5
              D32489AE4EAD45D5E2FF266C27742D19843E0CBB7DFD5893735D1E47BD58378D
              23AA63478E9FEC4360EC04EF0034312819581C436D1870EF00307D9880A2AE13
              1A60BE68FFEC2FFE7CEAFCA71FBC07FDDF40F561BB112D5CE9C2C3C110BA9A0C
              2EC3FB3117F65630CEC6F2A78CA55BD7AE0E96CB95D103478EF622028CBA4F4A
              160E70B8623874853A8B1738D90B6FBA209881D2912CD8C617113BD698AEADAE
              B47EF27FFC9B9937FFF627BFC24DC1DFA0716FA295D71796A21A6F0FBB095D4D
              06610177564395A88903AD22BEFC1A41F5DAE50BC9ED1B377A9090BEDEBEBE92
              04C392E2862D82D33B0878C76AF84C645085F1E57C79D24E7C06704DD3739F7C
              B4F6BFFFABFFFEFAF94F3F7C0FAABF448B5E476B2ED697A3D5CB5D5A5B84D0F5
              6410E6EB51DADF1B357A12597BCCA2838B0B73336B9F7D88ABBF5EAB0C8E8C54
              FAFAFB13F496B34C960D071A54AA5D3C402C3216F02C314E266F36D022EFE494
              3F66367367B2FE7FFDEBFF65FAF59FFCF9D9A5A5F95FE2487F0DDBCF412FD757
              A3E5F3FA4BA65D87751DEF269CA844A5DEFEA82F29716E8F4E43F504F02B7152
              7AF8E0E1E387CE3CF3ECAEE3A71FEEEFEB4362D214D37CC2FB608F042F73A38E
              2FB165764F95F5BAC08799685FBF72B1FEAB37DF9C3BF7C9FB376AB5357E53F5
              7DE087C8E7799C12B7ABD568EDA2BE9DBC2360ADDC317808F14DFAA372A9120D
              E1966A373A7D02EA8711AF4770519C2A577A0F9D38F5D0C4E9C79F18D977E060
              EFD0C868A9542EDBDD17E26849B0A4B01394C5A81289580452EA932449F98C6C
              6E66BA71E5C2F9950FDF7D6BF6D6F5EBB74AA5E802127F16EE9F23435FE04093
              B57AB414AF448D737699ED10F816EF341CEE8D92C1BEA8524AA2413462175407
              804CCC71E0518C2287CA959EDDE3BB26C6F6EC3F3C74E4F8F1FEF18989CAC0E0
              70A96FA03FA9F4F424A5520971D63CF94460DF96272FAD363F8AB9B4B0D09CBE
              3359BB7EF9D2CAAD6B5716F97F90B85DE52FF6F313E4FCACEC4514BAD64EA3E9
              522B5A6CAE45F5CFBBB896D80CBEB464181CAD44C9407F54EA29E14E388E8691
              845D68D55E9C930761DE8F06EE43A4F7B4DBD1581263615FAA0C952B95BEC1A1
              A19EC1E1E1322E9B70DEE399DCAAD7AA0DDC15D5569657561BF5EA52AB952EE0
              0AE0F325FE40BCBC0B09E4CF614FA3F07CDAC2B2A81AD53FBE87DF86EA067CE9
              C908E1E46054AA94A37225897AB0521CC0C83E84068E004711B851B810878183
              C07E602F902B7C5E1E4C04F229FF35C8E762FCFC2FDF4BE11DDC02F4FC990DFE
              E5F31212BE8CBB856AB319355A2B516BA787A38DE0D72A1906BB4B513C80B9A5
              D41395FA901C0C650C780F22D68316637D029A4615CC37655C2DFC6B7319AB20
              6399E91699495447C0EB987D6BA428DB402518B9A2F64C2D6A4F6EF087225F26
              FC5A26A308CF602AB88596EE198AE2152C1FFBFBA3A4944671B315C56D248D51
              65479098A88C7424E5A8BD568D520C417C5899CE2F45FCB3A35F8BB37F6388A2
              FF178780774C58EDF5F80000000049454E44AE426082}
          end>
      end>
    Left = 720
    Top = 40
  end
  object dsrGameStatus: TDataSource
    Left = 560
    Top = 40
  end
  object imcSvgRes: TSVGIconImageCollection
    SVGIconItems = <
      item
        IconName = 'Default'
        SVGText = 
          '<svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<path d="M30.3917 2.0026C14.6451' +
          ' 1.78993 1.78992 14.6445 2.0026 30.3903C2.21259 45.4914 14.5091 ' +
          '57.7873 29.6109 57.9973C45.3602 58.2127 58.2127 45.3581 57.9973 ' +
          '29.6123C57.79 14.5085 45.4935 2.21258 30.3917 2.0026ZM47.409 46.' +
          '0513C47.3553 46.1093 47.2896 46.1548 47.2165 46.1845C47.1433 46.' +
          '2143 47.0645 46.2276 46.9856 46.2235C46.9068 46.2194 46.8298 46.' +
          '198 46.7601 46.1608C46.6904 46.1236 46.6298 46.0715 46.5825 46.0' +
          '083C45.3785 44.4331 43.904 43.0845 42.2279 42.0254C38.8007 39.82' +
          '6 34.4582 38.6145 30.0013 38.6145C25.5444 38.6145 21.2019 39.826' +
          ' 17.7748 42.0254C16.0987 43.084 14.6242 44.4321 13.4202 46.0069C' +
          '13.3729 46.0702 13.3122 46.1222 13.2425 46.1594C13.1729 46.1966 ' +
          '13.0959 46.218 13.017 46.2221C12.9381 46.2262 12.8593 46.2129 12' +
          '.7862 46.1832C12.713 46.1535 12.6473 46.108 12.5937 46.05C8.6437' +
          '8 41.7863 6.40633 36.215 6.31009 30.4038C6.09068 17.3056 16.8392' +
          ' 6.34219 29.9434 6.30989C43.0476 6.27758 53.6925 16.9179 53.6925' +
          ' 30C53.697 35.9513 51.4527 41.6846 47.409 46.0513Z" fill="white"' +
          '/>'#10'<path d="M29.9999 16.875C27.689 16.875 25.5995 17.741 24.1147' +
          ' 19.3148C22.63 20.8887 21.8882 23.0648 22.0558 25.4004C22.3956 3' +
          '0 25.9593 33.75 29.9999 33.75C34.0405 33.75 37.5972 30 37.944 25' +
          '.4016C38.1175 23.0883 37.3815 20.932 35.8722 19.3289C34.3815 17.' +
          '7469 32.2956 16.875 29.9999 16.875Z" fill="white"/>'#10'</svg>'#10
      end
      item
        IconName = 'Shoes-rental'
        SVGText = 
          '<svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<path fill-rule="evenodd" clip-r' +
          'ule="evenodd" d="M30 58C45.464 58 58 45.464 58 30C58 14.536 45.4' +
          '64 2 30 2C14.536 2 2 14.536 2 30C2 45.464 14.536 58 30 58ZM42.38' +
          '54 34.5272C41.9206 34.9881 41.9206 35.7396 42.3854 36.2005C42.84' +
          '57 36.657 43.5882 36.656 44.0472 36.1982L51.9849 28.283C52.4364 ' +
          '27.8328 52.4412 27.1029 51.9956 26.6467C51.5444 26.1847 50.8031 ' +
          '26.1789 50.3446 26.6336L42.3854 34.5272ZM9.59999 42.4C9.59999 43' +
          '.5046 10.4954 44.4 11.6 44.4H27.946C28.4709 44.4 28.9748 44.1937' +
          ' 29.3489 43.8255L47.9536 25.5146C48.7476 24.7332 48.75 23.4536 4' +
          '7.959 22.6691L37.3736 12.1709C36.6042 11.4079 35.3671 11.3964 34' +
          '.5836 12.1449L25.9898 20.3555L23.0574 25.289L25.9898 28.1453C26.' +
          '0945 28.353 26.1556 28.5694 26.1731 28.7945C26.1905 29.0195 26.1' +
          '12 29.2186 25.9374 29.3917C25.7629 29.5648 25.5534 29.66 25.3091' +
          ' 29.6773C25.0647 29.6946 24.8727 29.5821 24.7331 29.3397L22.3767' +
          ' 26.8989C22.2022 27.3144 22.0014 27.6866 21.7745 28.0155C21.5476' +
          ' 28.3444 21.312 28.6473 21.0676 28.9243L23.1622 31.0535C23.3018 ' +
          '31.2266 23.3716 31.4343 23.3716 31.6767C23.3716 31.919 23.3018 3' +
          '2.1095 23.1622 32.2479C22.9876 32.4557 22.7694 32.5595 22.5076 3' +
          '2.5595C22.2458 32.5595 22.0625 32.473 21.9578 32.2999L20.0727 30' +
          '.4303C19.7934 30.7419 19.5229 31.0362 19.2611 31.3132C18.9993 31' +
          '.5901 18.7113 31.8325 18.3971 32.0402L20.3345 33.9617C20.4393 34' +
          '.1348 20.5004 34.3425 20.5178 34.5849C20.5353 34.8272 20.4567 35' +
          '.035 20.2822 35.2081C20.1076 35.3812 19.8895 35.4677 19.6276 35.' +
          '4677C19.3658 35.4677 19.1825 35.3812 19.0778 35.2081L17.0356 33.' +
          '1827C16.1978 33.8405 15.3338 34.4204 14.4436 34.9224C13.5534 35.' +
          '4244 12.6196 35.8659 11.6422 36.2467C11.0138 36.489 10.5164 36.8' +
          '785 10.1498 37.4152C9.78327 37.9518 9.59999 38.5317 9.59999 39.1' +
          '549V42.4Z" fill="white"/>'#10'</svg>'#10
      end
      item
        IconName = 'Handy'
        SVGText = 
          '<svg width="90" height="60" viewBox="0 0 90 60" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<path fill-rule="evenodd" clip-r' +
          'ule="evenodd" d="M28 2C12.536 2 0 14.536 0 30C0 45.464 12.536 58' +
          ' 28 58H62C77.464 58 90 45.464 90 30C90 14.536 77.464 2 62 2H28ZM' +
          '42.625 36.9062V15.4688H38.8438V24.375H36.625V15.9688H32.9062V36.' +
          '375H36.625V27.6562H38.8438V36.9062H42.625ZM18.0312 18.4062V21.56' +
          '25H32V18.4062H27.0312V15.6875H23.0625V18.4062H18.0312ZM25.0625 2' +
          '2.5312C21.5 22.5 18.8906 24.6719 18.9062 27.8438C18.8906 31 21.5' +
          ' 33.2031 25.0625 33.2188C28.625 33.2031 31.2656 31 31.2812 27.84' +
          '38C31.2656 24.6719 28.625 22.5 25.0625 22.5312ZM25.0625 30.1875C' +
          '23.5 30.2031 22.4531 29.2969 22.4688 27.8438C22.4531 26.3281 23.' +
          '5 25.4844 25.0625 25.4688C26.6094 25.4844 27.6719 26.3281 27.687' +
          '5 27.8438C27.6719 29.2969 26.6094 30.2031 25.0625 30.1875ZM23.34' +
          '38 34.9375V43.375H43.3438V40.1875H27.3438V34.9375H23.3438ZM69.65' +
          '62 43.9375V15.4375H65.625V43.9375H69.6562ZM47.5625 17.9375V37.15' +
          '62H50.0312C56.1875 37.1562 59.8125 37.0312 63.75 36.2812L63.375 ' +
          '33C59.7969 33.6406 56.6562 33.7812 51.5625 33.7812V21.1875H61.40' +
          '62V17.9375H47.5625Z" fill="white"/>'#10'</svg>'#10
      end
      item
        IconName = 'Act_left'
        SVGText = 
          '<svg width="120" height="130" viewBox="0 0 120 130" fill="none" ' +
          'xmlns="http://www.w3.org/2000/svg">'#10'<g filter="url(#filter0_i_5_' +
          '2956)">'#10'<path fill-rule="evenodd" clip-rule="evenodd" d="M2.4252' +
          '1 58.763C-0.80834 61.9048 -0.808332 67.0966 2.42521 70.2384L61.7' +
          '325 127.862C64.2685 130.326 68.5199 128.529 68.5199 124.993L68.5' +
          '199 95.457L113.996 95.457C117.31 95.457 119.996 92.7707 119.996 ' +
          '89.457L119.996 39.457C119.996 36.1433 117.31 33.457 113.996 33.4' +
          '57L68.5199 33.457L68.5199 4.00797C68.5199 0.47205 64.2685 -1.324' +
          '9 61.7325 1.13913L2.42521 58.763Z" fill="#FD3AA0"/>'#10'</g>'#10'<defs>'#10 +
          '<filter id="filter0_i_5_2956" x="0" y="0" width="119.996" height' +
          '="133.001" filterUnits="userSpaceOnUse" color-interpolation-filt' +
          'ers="sRGB">'#10'<feFlood flood-opacity="0" result="BackgroundImageFi' +
          'x"/>'#10'<feBlend mode="normal" in="SourceGraphic" in2="BackgroundIm' +
          'ageFix" result="shape"/>'#10'<feColorMatrix in="SourceAlpha" type="m' +
          'atrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result' +
          '="hardAlpha"/>'#10'<feOffset dy="6"/>'#10'<feGaussianBlur stdDeviation="' +
          '2"/>'#10'<feComposite in2="hardAlpha" operator="arithmetic" k2="-1" ' +
          'k3="1"/>'#10'<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 ' +
          '1 0 0 0 0 1 0 0 0 0.5 0"/>'#10'<feBlend mode="normal" in2="shape" re' +
          'sult="effect1_innerShadow_5_2956"/>'#10'</filter>'#10'</defs>'#10'</svg>'#10
      end
      item
        IconName = 'Act_Right'
        SVGText = 
          '<svg width="120" height="130" viewBox="0 0 120 130" fill="none" ' +
          'xmlns="http://www.w3.org/2000/svg">'#10'<g filter="url(#filter0_i_5_' +
          '2959)">'#10'<path fill-rule="evenodd" clip-rule="evenodd" d="M117.57' +
          '1 58.763C120.805 61.9048 120.805 67.0966 117.571 70.2384L58.2639' +
          ' 127.862C55.7278 130.326 51.4764 128.529 51.4764 124.993L51.4764' +
          ' 95.457L6 95.457C2.68629 95.457 3.16739e-06 92.7707 3.45708e-06 ' +
          '89.457L7.82822e-06 39.457C8.11791e-06 36.1433 2.6863 33.457 6.00' +
          '001 33.457L51.4764 33.457L51.4764 4.00797C51.4764 0.47205 55.727' +
          '9 -1.3249 58.2639 1.13913L117.571 58.763Z" fill="#FD3AA0"/>'#10'</g>' +
          #10'<defs>'#10'<filter id="filter0_i_5_2959" x="0" y="0" width="119.996' +
          '" height="133.001" filterUnits="userSpaceOnUse" color-interpolat' +
          'ion-filters="sRGB">'#10'<feFlood flood-opacity="0" result="Backgroun' +
          'dImageFix"/>'#10'<feBlend mode="normal" in="SourceGraphic" in2="Back' +
          'groundImageFix" result="shape"/>'#10'<feColorMatrix in="SourceAlpha"' +
          ' type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0' +
          '" result="hardAlpha"/>'#10'<feOffset dy="6"/>'#10'<feGaussianBlur stdDev' +
          'iation="2"/>'#10'<feComposite in2="hardAlpha" operator="arithmetic" ' +
          'k2="-1" k3="1"/>'#10'<feColorMatrix type="matrix" values="0 0 0 0 1 ' +
          '0 0 0 0 1 0 0 0 0 1 0 0 0 0.5 0"/>'#10'<feBlend mode="normal" in2="s' +
          'hape" result="effect1_innerShadow_5_2959"/>'#10'</filter>'#10'</defs>'#10'</' +
          'svg>'#10
      end
      item
        IconName = 'Dis_left'
        SVGText = 
          '<svg width="120" height="130" viewBox="0 0 120 130" fill="none" ' +
          'xmlns="http://www.w3.org/2000/svg">'#10'<path fill-rule="evenodd" cl' +
          'ip-rule="evenodd" d="M2.42521 58.7644C-0.80834 61.9062 -0.808332' +
          ' 67.098 2.42521 70.2398L61.7325 127.864C64.2685 130.328 68.5199 ' +
          '128.531 68.5199 124.995L68.5199 95.4584L113.996 95.4584C117.31 9' +
          '5.4584 119.996 92.7721 119.996 89.4584L119.996 39.4584C119.996 3' +
          '6.1447 117.31 33.4584 113.996 33.4584L68.5199 33.4584L68.5199 4.' +
          '00937C68.5199 0.473454 64.2685 -1.3235 61.7325 1.14053L2.42521 5' +
          '8.7644Z" fill="#30323E"/>'#10'</svg>'#10
      end
      item
        IconName = 'Dis_Right'
        SVGText = 
          '<svg width="120" height="130" viewBox="0 0 120 130" fill="none" ' +
          'xmlns="http://www.w3.org/2000/svg">'#10'<path fill-rule="evenodd" cl' +
          'ip-rule="evenodd" d="M117.571 58.7644C120.805 61.9062 120.805 67' +
          '.098 117.571 70.2398L58.2639 127.864C55.7278 130.328 51.4764 128' +
          '.531 51.4764 124.995L51.4764 95.4584L6 95.4584C2.68629 95.4584 3' +
          '.16739e-06 92.7721 3.45708e-06 89.4584L7.82822e-06 39.4584C8.117' +
          '91e-06 36.1447 2.6863 33.4584 6.00001 33.4584L51.4764 33.4584L51' +
          '.4764 4.00937C51.4764 0.473454 55.7279 -1.3235 58.2639 1.14053L1' +
          '17.571 58.7644Z" fill="#30323E"/>'#10'</svg>'#10
      end
      item
        IconName = 'Left_1'
        SVGText = 
          '<svg width="72" height="64" viewBox="0 0 72 64" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<rect x="26" y="18" width="46" h' +
          'eight="28" fill="#FFDD2B"/>'#10'<path d="M-1.3332e-06 32L30 4.28718L' +
          '30 59.7128L-1.3332e-06 32Z" fill="#FFDD2B"/>'#10'</svg>'#10
      end
      item
        IconName = 'Right_1'
        SVGText = 
          '<svg width="72" height="64" viewBox="0 0 72 64" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<rect width="46" height="28" tra' +
          'nsform="matrix(-1 0 0 1 46 18)" fill="#FFDD2B"/>'#10'<path d="M72 32' +
          'L42 4.28718L42 59.7128L72 32Z" fill="#FFDD2B"/>'#10'</svg>'#10
      end
      item
        IconName = 'Left'
        SVGText = 
          '<svg width="72" height="64" viewBox="0 0 72 64" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<rect x="26" y="18" width="46" h' +
          'eight="28" fill="white"/>'#10'<path d="M-1.3332e-06 32L30 4.28718L30' +
          ' 59.7128L-1.3332e-06 32Z" fill="white"/>'#10'</svg>'#10
      end
      item
        IconName = 'Right'
        SVGText = 
          '<svg width="72" height="64" viewBox="0 0 72 64" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<rect width="46" height="28" tra' +
          'nsform="matrix(-1 0 0 1 46 18)" fill="white"/>'#10'<path d="M72 32L4' +
          '2 4.28718L42 59.7128L72 32Z" fill="white"/>'#10'</svg>'#10
      end
      item
        IconName = 'Strike'
        SVGText = 
          '<svg width="54" height="54" viewBox="0 0 54 54" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<path fill-rule="evenodd" clip-r' +
          'ule="evenodd" d="M27 27.8381L53 49V5L27 26.1619L1 5L1 49L27 27.8' +
          '381Z" fill="black"/>'#10'</svg>'#10
      end
      item
        IconName = 'Foul'
        SVGText = 
          '<svg width="54" height="54" viewBox="0 0 54 54" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<path d="M14 47V7H40V14.6796H23.' +
          '002V21.8468H38.3055V30.8122H23.002V47H14Z" fill="black"/>'#10'</svg>' +
          #10
      end
      item
        IconName = 'Spare'
        SVGText = 
          '<svg width="54" height="54" viewBox="0 0 54 54" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<path d="M6 53V38.5556L48 1V15.4' +
          '444L6 53Z" fill="black"/>'#10'</svg>'#10
      end
      item
        IconName = 'Split'
        SVGText = 
          '<svg width="42" height="74" viewBox="0 0 42 74" fill="none" xmln' +
          's="http://www.w3.org/2000/svg">'#10'<rect x="1" y="1" width="40" hei' +
          'ght="72" rx="7" stroke="#30323E" stroke-width="2"/>'#10'</svg>'#10
      end
      item
        IconName = 'bg-info_menual'
        SVGText = 
          '<svg width="689" height="162" viewBox="0 0 689 162" fill="none" ' +
          'xmlns="http://www.w3.org/2000/svg">'#10'<path d="M0 20C0 8.9543 8.95' +
          '431 0 20 0H669C680.046 0 689 8.95431 689 20V142C689 153.046 680.' +
          '046 162 669 162H20C8.95431 162 0 153.046 0 142V20Z" fill="#30323' +
          'E"/>'#10'<rect x="456" y="20" width="2" height="122" fill="black"/>'#10 +
          '<rect x="231" y="20" width="2" height="122" fill="black"/>'#10'</svg' +
          '>'#10
      end
      item
        IconName = 'Total-boards'
        SVGText = 
          '<svg width="580" height="162" viewBox="0 0 580 162" fill="none" ' +
          'xmlns="http://www.w3.org/2000/svg">'#10'<path d="M0 45C0 33.9543 8.9' +
          '5431 25 20 25H560C571.046 25 580 33.9543 580 45V142C580 153.046 ' +
          '571.046 162 560 162H20C8.95432 162 0 153.046 0 142V45Z" fill="#3' +
          '0323E"/>'#10'<rect x="289" y="55" width="2" height="89" fill="black"' +
          '/>'#10'<rect x="30" y="2" width="230" height="55" rx="27.5" fill="#1' +
          'A1C22"/>'#10'<rect x="30" width="230" height="49" rx="24.5" fill="#3' +
          '0323E"/>'#10'<rect x="30" width="230" height="49" rx="24.5" fill="ur' +
          'l(#paint0_linear_158_1300)"/>'#10'<rect x="321.5" y="2" width="230" ' +
          'height="55" rx="27.5" fill="#1A1C22"/>'#10'<rect x="321.5" width="23' +
          '0" height="49" rx="24.5" fill="#30323E"/>'#10'<rect x="321.5" width=' +
          '"230" height="49" rx="24.5" fill="url(#paint1_linear_158_1300)"/' +
          '>'#10'<defs>'#10'<linearGradient id="paint0_linear_158_1300" x1="145" y1' +
          '="0" x2="145" y2="25.9412" gradientUnits="userSpaceOnUse">'#10'<stop' +
          ' stop-color="#D9D9D9" stop-opacity="0.2"/>'#10'<stop offset="1" stop' +
          '-color="#D9D9D9" stop-opacity="0"/>'#10'</linearGradient>'#10'<linearGra' +
          'dient id="paint1_linear_158_1300" x1="436.5" y1="0" x2="436.5" y' +
          '2="25.9412" gradientUnits="userSpaceOnUse">'#10'<stop stop-color="#D' +
          '9D9D9" stop-opacity="0.2"/>'#10'<stop offset="1" stop-color="#D9D9D9' +
          '" stop-opacity="0"/>'#10'</linearGradient>'#10'</defs>'#10'</svg>'#10
      end
      item
        IconName = 'Pin-base'
        SVGText = 
          '<svg width="1920" height="1080" viewBox="0 0 1920 1080" fill="no' +
          'ne" xmlns="http://www.w3.org/2000/svg">'#10'<rect width="1920" heigh' +
          't="1080" fill="black"/>'#10'<circle cx="1144" cy="721" r="78" fill="' +
          '#30323E"/>'#10'<circle cx="960" cy="906" r="78" fill="#30323E"/>'#10'<ci' +
          'rcle cx="776" cy="721" r="78" fill="#30323E"/>'#10'<circle cx="1145"' +
          ' cy="362" r="78" fill="#30323E"/>'#10'<circle cx="775" cy="362" r="7' +
          '8" fill="#30323E"/>'#10'<circle cx="405" cy="362" r="78" fill="#3032' +
          '3E"/>'#10'<circle cx="1329" cy="537" r="78" fill="#30323E"/>'#10'<circle' +
          ' cx="960" cy="537" r="78" fill="#30323E"/>'#10'<circle cx="591" cy="' +
          '537" r="78" fill="#30323E"/>'#10'<circle cx="1515" cy="362" r="78" f' +
          'ill="#30323E"/>'#10'</svg>'#10
      end>
    Left = 640
    Top = 40
  end
  object imlSvgRes: TSVGIconVirtualImageList
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'Default'
        Name = 'Default'
      end
      item
        CollectionIndex = 1
        CollectionName = 'Shoes-rental'
        Name = 'Shoes-rental'
      end
      item
        CollectionIndex = 2
        CollectionName = 'Handy'
        Name = 'Handy'
      end
      item
        CollectionIndex = 3
        CollectionName = 'Act_left'
        Name = 'Act_left'
      end
      item
        CollectionIndex = 4
        CollectionName = 'Act_Right'
        Name = 'Act_Right'
      end
      item
        CollectionIndex = 5
        CollectionName = 'Dis_left'
        Name = 'Dis_left'
      end
      item
        CollectionIndex = 6
        CollectionName = 'Dis_Right'
        Name = 'Dis_Right'
      end
      item
        CollectionIndex = 7
        CollectionName = 'Left_1'
        Name = 'Left_1'
      end
      item
        CollectionIndex = 8
        CollectionName = 'Right_1'
        Name = 'Right_1'
      end
      item
        CollectionIndex = 9
        CollectionName = 'Left'
        Name = 'Left'
      end
      item
        CollectionIndex = 10
        CollectionName = 'Right'
        Name = 'Right'
      end
      item
        CollectionIndex = 11
        CollectionName = 'Strike'
        Name = 'Strike'
      end
      item
        CollectionIndex = 12
        CollectionName = 'Foul'
        Name = 'Foul'
      end
      item
        CollectionIndex = 13
        CollectionName = 'Spare'
        Name = 'Spare'
      end
      item
        CollectionIndex = 14
        CollectionName = 'Split'
        Name = 'Split'
      end
      item
        CollectionIndex = 15
        CollectionName = 'bg-info_menual'
        Name = 'bg-info_menual'
      end
      item
        CollectionIndex = 16
        CollectionName = 'Total-boards'
        Name = 'Total-boards'
      end
      item
        CollectionIndex = 17
        CollectionName = 'Pin-base'
        Name = 'Pin-base'
      end>
    ImageCollection = imcSvgRes
    Left = 640
    Top = 96
  end
  object tmrRunOnce: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrRunOnceTimer
    Left = 480
    Top = 40
  end
end
