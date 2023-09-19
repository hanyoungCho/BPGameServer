object BPSalePosForm: TBPSalePosForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 1022
  ClientWidth = 1700
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  StyleElements = [seFont, seBorder]
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  OnResize = PluginModuleResize
  OnShow = PluginModuleShow
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 14
  object panBase: TPanel
    Left = 0
    Top = 0
    Width = 1700
    Height = 1022
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object panLeft: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 673
      Height = 957
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alLeft
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object panSaleControl: TPanel
        Left = 0
        Top = 522
        Width = 673
        Height = 435
        Align = alBottom
        BevelOuter = bvNone
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        object panItemMenu: TPanel
          Left = 0
          Top = 0
          Width = 673
          Height = 55
          Align = alTop
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object btnItemClear: TBitBtn
            AlignWithMargins = True
            Left = 226
            Top = 0
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alLeft
            Caption = #49440#53469#54620' '#49345#54408#13#10#49325#51228
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 2
            WordWrap = True
            OnClick = btnItemClearClick
            ExplicitLeft = 113
          end
          object btnItemIncQty: TBitBtn
            AlignWithMargins = True
            Left = 339
            Top = 0
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alLeft
            Caption = #49688#47049' '#51613#44032
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 3
            WordWrap = True
            OnClick = btnItemIncQtyClick
          end
          object btnItemDecQty: TBitBtn
            AlignWithMargins = True
            Left = 452
            Top = 0
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alLeft
            Caption = #49688#47049' '#44048#49548
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 4
            WordWrap = True
            OnClick = btnItemDecQtyClick
          end
          object btnItemChangeQty: TBitBtn
            AlignWithMargins = True
            Left = 565
            Top = 0
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alLeft
            Caption = #49688#47049' '#48320#44221
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 5
            WordWrap = True
            OnClick = btnItemChangeQtyClick
          end
          object btnItemSelectAll: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alLeft
            Caption = #51204#52404' '#49440#53469
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 16744448
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 0
            WordWrap = True
            StyleElements = [seClient, seBorder]
            OnClick = btnItemSelectAllClick
          end
          object btnItemClearSelect: TBitBtn
            AlignWithMargins = True
            Left = 113
            Top = 0
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alLeft
            Caption = #49440#53469' '#52712#49548
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 16744448
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 1
            WordWrap = True
            StyleElements = [seClient, seBorder]
            OnClick = btnItemClearSelectClick
          end
        end
        object panSideMenu: TPanel
          Left = 565
          Top = 55
          Width = 108
          Height = 380
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object btnItemDiscount: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #54408#47785' '#51221#50529' '#54624#51064
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 0
            WordWrap = True
            OnClick = btnItemDiscountClick
          end
          object btnItemSpare1: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 330
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 6
            WordWrap = True
          end
          object btnItemService: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 165
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #49436#48708#49828#13#10#51201#50857'/'#52712#49548
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 3
            WordWrap = True
            OnClick = btnItemServiceClick
          end
          object btnItemDiscountPercent: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 55
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #54408#47785' '#65285' '#54624#51064
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 1
            WordWrap = True
            OnClick = btnItemDiscountPercentClick
          end
          object btnItemSpare2: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 275
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 5
            WordWrap = True
          end
          object btnItemUsePoint: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 220
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #54252#51064#53944#13#10#49324#50857'/'#52712#49548
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 4
            WordWrap = True
            OnClick = btnItemUsePointClick
          end
          object btnItemDiscountCancel: TBitBtn
            AlignWithMargins = True
            Left = 0
            Top = 110
            Width = 108
            Height = 50
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #54408#47785' '#54624#51064#13#10#52712#49548
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 2
            WordWrap = True
            OnClick = btnItemDiscountCancelClick
          end
        end
        object panNumpad: TPanel
          Left = 0
          Top = 55
          Width = 560
          Height = 380
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alLeft
          BevelOuter = bvNone
          Caption = '0'
          Color = 8454143
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
          object panPaymentResult: TPanel
            Left = 0
            Top = 0
            Width = 334
            Height = 380
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
            object edtVATTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 90
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 54
              EditLabel.Height = 36
              EditLabel.Caption = #48512#44032#49464
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              Text = '0'
              StyleElements = [seClient]
            end
            object edtDCTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 48
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 77
              EditLabel.Height = 36
              EditLabel.Caption = #49345#54408' '#54624#51064
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              Text = '0'
              StyleElements = [seClient]
            end
            object edtKeepAmtTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 174
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 54
              EditLabel.Height = 36
              EditLabel.Caption = #48372#51613#44552
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
              Text = '0'
              StyleElements = [seClient]
            end
            object edtReceiveTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 258
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 77
              EditLabel.Height = 36
              EditLabel.Caption = #48155#51008' '#44552#50529
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
              Text = '0'
              StyleElements = [seClient]
            end
            object edtUnpaidTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 300
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 95
              EditLabel.Height = 36
              EditLabel.Caption = #48120#44208#51228' '#44552#50529
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 7
              Text = '0'
              StyleElements = [seClient]
            end
            object edtChangeTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 342
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 77
              EditLabel.Height = 36
              EditLabel.Caption = #44144#49828#47492' '#46024
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 8
              Text = '0'
              StyleElements = [seClient]
            end
            object edtSaleTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 6
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 77
              EditLabel.Height = 36
              EditLabel.Caption = #49345#54408' '#44552#50529
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              Text = '0'
              StyleElements = [seClient, seBorder]
            end
            object edtChargeTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 132
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 77
              EditLabel.Height = 36
              EditLabel.Caption = #52397#44396' '#44552#50529
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              Text = '0'
              StyleElements = [seClient, seBorder]
            end
            object edtUsePointTotal: TLabeledEdit
              AlignWithMargins = True
              Left = 129
              Top = 216
              Width = 192
              Height = 36
              TabStop = False
              Alignment = taRightJustify
              AutoSize = False
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              EditLabel.Width = 95
              EditLabel.Height = 36
              EditLabel.Caption = #54252#51064#53944' '#49324#50857
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -21
              EditLabel.Font.Name = 'Pretendard Variable'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3305471
              Font.Height = -29
              Font.Name = 'Verdana'
              Font.Style = [fsBold]
              LabelPosition = lpLeft
              LabelSpacing = 8
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
              Text = '0'
              StyleElements = [seClient]
            end
          end
          object panSaleNumPad: TPanel
            Left = 334
            Top = 0
            Width = 226
            Height = 380
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            BevelOuter = bvNone
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            object btnNum7: TBitBtn
              Tag = 55
              Left = 5
              Top = 55
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '7'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = btnNumPadClick
            end
            object btnNum8: TBitBtn
              Tag = 56
              Left = 80
              Top = 55
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '8'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              OnClick = btnNumPadClick
            end
            object btnNum9: TBitBtn
              Tag = 57
              Left = 155
              Top = 55
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '9'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              OnClick = btnNumPadClick
            end
            object btnNum4: TBitBtn
              Tag = 52
              Left = 5
              Top = 110
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '4'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
              OnClick = btnNumPadClick
            end
            object btnNum5: TBitBtn
              Tag = 53
              Left = 80
              Top = 110
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '5'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
              OnClick = btnNumPadClick
            end
            object btnNum6: TBitBtn
              Tag = 54
              Left = 155
              Top = 110
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '6'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
              OnClick = btnNumPadClick
            end
            object btnNum1: TBitBtn
              Tag = 49
              Left = 5
              Top = 165
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 6
              OnClick = btnNumPadClick
            end
            object btnNum2: TBitBtn
              Tag = 50
              Left = 80
              Top = 165
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
              OnClick = btnNumPadClick
            end
            object btnNum3: TBitBtn
              Tag = 51
              Left = 155
              Top = 165
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 8
              OnClick = btnNumPadClick
            end
            object btnNum0: TBitBtn
              Tag = 48
              Left = 80
              Top = 220
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 9
              OnClick = btnNumPadClick
            end
            object btnNum0x2: TBitBtn
              Tag = 48
              Left = 5
              Top = 220
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '00'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 10
              OnClick = btnNumPadClick
            end
            object btnNum0x3: TBitBtn
              Tag = 48
              Left = 155
              Top = 220
              Width = 71
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = '000'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 11
              OnClick = btnNumPadClick
            end
            object btnNumBack: TBitBtn
              Left = 5
              Top = 275
              Width = 108
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = 'BS'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 12
              OnClick = btnNumBackClick
            end
            object btnOpenDrawer: TBitBtn
              Left = 5
              Top = 330
              Width = 221
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = #44552#51204#54632' '#50676#44592
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              Images = BPDM.imlIcon32
              ParentFont = False
              TabOrder = 14
              WordWrap = True
              OnClick = btnOpenDrawerClick
            end
            object btnNumClear: TBitBtn
              Left = 118
              Top = 275
              Width = 108
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Caption = 'CL'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -24
              Font.Name = 'Pretendard Variable'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 13
              OnClick = btnNumClearClick
            end
            object panInputValue: TPanel
              Left = 5
              Top = 0
              Width = 221
              Height = 50
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              TabOrder = 15
              object lblInputValue: TLabel
                AlignWithMargins = True
                Left = -1
                Top = 0
                Width = 221
                Height = 50
                Alignment = taCenter
                AutoSize = False
                Caption = '0'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 16744448
                Font.Height = -32
                Font.Name = 'Verdana'
                Font.Style = [fsBold]
                ParentFont = False
                Transparent = True
                Layout = tlCenter
                StyleElements = [seClient, seBorder]
              end
            end
          end
        end
      end
      object panSaleGroup: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 673
        Height = 57
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnGeneralLane: TSpeedButton
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 65
          Height = 54
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = #51068#48152#13#10#54032#47588
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btnGeneralLaneClick
          ExplicitTop = -2
        end
        object btnSelectedLane: TSpeedButton
          AlignWithMargins = True
          Left = 68
          Top = 0
          Width = 65
          Height = 54
          Cursor = crHandPoint
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = #47112#51064#13#10#49440#53469
          ImageIndex = 2
          ImageName = 'RighttArrow_R_16px'
          Images = BPDM.imlIcon16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          Layout = blGlyphRight
          Margin = 3
          ParentFont = False
          OnClick = btnSelectedLaneClick
          ExplicitTop = -2
        end
        object shpLaneGroupSeparator: TShape
          Left = 0
          Top = 54
          Width = 673
          Height = 3
          Align = alBottom
          Brush.Color = clHighlight
          Pen.Color = clHighlight
          ExplicitTop = 55
        end
        object sbxSelectedLaneList: TScrollBox
          AlignWithMargins = True
          Left = 137
          Top = 3
          Width = 447
          Height = 51
          Margins.Left = 4
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          BevelOuter = bvNone
          BorderStyle = bsNone
          TabOrder = 1
        end
        object panReceiptList: TPanel
          Left = 584
          Top = 0
          Width = 89
          Height = 54
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object lblReceiptListTitle: TLabel
            Left = 0
            Top = 0
            Width = 89
            Height = 22
            Margins.Bottom = 0
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = #51452#47928#48264#54840
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 16744448
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            StyleElements = [seClient, seBorder]
            ExplicitLeft = 8
            ExplicitWidth = 36
            ExplicitHeight = 51
          end
          object cbxReceiptNoList: TComboBox
            AlignWithMargins = True
            Left = 3
            Top = 25
            Width = 86
            Height = 26
            Margins.Right = 0
            Align = alBottom
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
      end
      object panSaleMemo: TPanel
        Left = 0
        Top = 422
        Width = 673
        Height = 100
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object mmoSaleMemo: TDBMemoEh
          AlignWithMargins = True
          Left = 63
          Top = 39
          Width = 610
          Height = 56
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 5
          ControlLabel.Width = 56
          ControlLabel.Height = 18
          ControlLabel.Caption = #54032#47588' '#47700#47784
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftTopEh
          Alignment = taLeftJustify
          AutoSize = False
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #47700#47784' '#45236#50857#51008' '#44144#47000' '#50756#47308' '#49884#50640#47564' '#51200#51109#51060' '#46121#45768#45796'.'
          ParentShowHint = False
          TabOrder = 0
          Visible = True
          WantReturns = True
        end
        object edtSaleLockerNo: TDBEditEh
          Left = 516
          Top = 6
          Width = 45
          Height = 27
          Alignment = taCenter
          AutoSize = False
          ControlLabel.Width = 52
          ControlLabel.Height = 18
          ControlLabel.Caption = #46972#52964#48264#54840
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DataField = 'locker_no'
          DataSource = dsrSaleItem
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 3
          Visible = True
          EditMask = ''
        end
        object edtSalePurchaseMonth: TDBNumberEditEh
          Left = 628
          Top = 6
          Width = 45
          Height = 27
          ControlLabel.Width = 52
          ControlLabel.Height = 18
          ControlLabel.Caption = #49324#50857#50900#49688
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          Alignment = taCenter
          AutoSize = False
          DataField = 'purchase_month'
          DataSource = dsrSaleItem
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 4
          Visible = True
        end
        object edtSaleUseStartDate: TDBEditEh
          Left = 269
          Top = 6
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 65
          ControlLabel.Height = 18
          ControlLabel.Caption = #49324#50857#49884#51089#51068
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DataField = 'start_dt'
          DataSource = dsrSaleItem
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 2
          Visible = True
          EditMask = ''
        end
        object edtSaleMemberName: TDBEditEh
          Left = 63
          Top = 6
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 39
          ControlLabel.Height = 18
          ControlLabel.Caption = #54924#50896#47749
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DataField = 'member_nm'
          DataSource = dsrSaleItem
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 1
          Visible = True
          EditMask = ''
        end
      end
      object G1: TcxGrid
        Left = 0
        Top = 57
        Width = 673
        Height = 365
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        LookAndFeel.ScrollbarMode = sbmTouch
        LookAndFeel.ScrollMode = scmSmooth
        object V1: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          OnCustomDrawCell = V1CustomDrawCell
          OnFocusedRecordChanged = V1FocusedRecordChanged
          DataController.DataSource = dsrSaleItem
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #44228
              Kind = skCount
              FieldName = 'RecId'
              Column = V1prod_amt
            end
            item
              Format = ',0;-,0'
              Kind = skSum
              FieldName = 'order_qty'
              Column = V1order_qty
            end
            item
              Format = ',0 ; -,0 '
              Kind = skSum
              FieldName = 'calc_sale_amt'
              Column = V1calc_sale_amt
            end
            item
              Format = ',0 ; -,0 '
              Kind = skSum
              FieldName = 'dc_amt'
              Column = V1dc_amt
            end
            item
              Kind = skSum
              FieldName = 'calc_charge_amt'
              Column = V1calc_charge_amt
            end
            item
              Format = ',0 ; -,0 '
              Kind = skSum
              FieldName = 'calc_vat'
              Column = V1calc_vat
            end
            item
              Format = ',0 ; -,0 '
              Kind = skSum
              FieldName = 'use_point'
              Column = V1use_point
            end>
          DataController.Summary.SummaryGroups = <>
          DataController.Summary.Options = [soSelectedRecords]
          DataController.Summary.OnAfterSummary = V1DataControllerSummaryAfterSummary
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnHidingOnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsCustomize.ColumnVertSizing = False
          OptionsData.Deleting = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsSelection.MultiSelect = True
          OptionsSelection.CheckBoxPosition = cbpIndicator
          OptionsSelection.CheckBoxVisibility = [cbvDataRow, cbvColumnHeader]
          OptionsView.FocusRect = False
          OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
          OptionsView.ScrollBars = ssVertical
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GridLines = glVertical
          OptionsView.GroupByBox = False
          OptionsView.Indicator = True
          Styles.Header = BPDM.StyleHeader1
          Styles.HotTrack = BPDM.StyleInactive
          Styles.Inactive = BPDM.StyleSelection
          Styles.Indicator = BPDM.StyleHeader1
          Styles.Selection = BPDM.StyleSelection
          Styles.BandHeader = BPDM.StyleHeader1
          Bands = <
            item
              Caption = #51452#47928' '#45236#50669
              Options.Moving = False
              OnHeaderClick = V1Bands0HeaderClick
            end>
          object V1lane_no: TcxGridDBBandedColumn
            Caption = #47112#51064
            DataBinding.FieldName = 'calc_current_lane_no'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 55
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V1assign_index_nm: TcxGridDBBandedColumn
            Caption = #49345#53468
            DataBinding.FieldName = 'assign_index_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 70
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V1bowler_id: TcxGridDBBandedColumn
            Caption = #48380#47084
            DataBinding.FieldName = 'bowler_id'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            MinWidth = 0
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V1prod_nm: TcxGridDBBandedColumn
            Caption = #49345#54408#47749
            DataBinding.FieldName = 'prod_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 150
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V1prod_amt: TcxGridDBBandedColumn
            Caption = #45800#44032
            DataBinding.FieldName = 'prod_amt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = ',0 ; -,0 '
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V1order_qty: TcxGridDBBandedColumn
            Caption = #49688#47049
            DataBinding.FieldName = 'order_qty'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.DisplayFormat = ',0; -,0'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 55
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V1calc_sale_amt: TcxGridDBBandedColumn
            Caption = #49345#54408#44552#50529
            DataBinding.FieldName = 'calc_sale_amt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = ',0 ; -,0 '
            FooterAlignmentHorz = taRightJustify
            HeaderAlignmentHorz = taCenter
            Width = 110
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V1dc_amt: TcxGridDBBandedColumn
            Caption = #54624#51064#44552#50529
            DataBinding.FieldName = 'dc_amt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = ',0 ; -,0 '
            FooterAlignmentHorz = taRightJustify
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V1use_point: TcxGridDBBandedColumn
            Caption = #54252#51064#53944
            DataBinding.FieldName = 'use_point'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = ',0 ; -,0 '
            FooterAlignmentHorz = taRightJustify
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object V1service_yn: TcxGridDBBandedColumn
            Caption = 'SVC'
            DataBinding.FieldName = 'service_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.NullStyle = nssUnchecked
            HeaderAlignmentHorz = taCenter
            Width = 50
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object V1calc_charge_amt: TcxGridDBBandedColumn
            Caption = #52397#44396#44552#50529
            DataBinding.FieldName = 'calc_charge_amt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object V1calc_vat: TcxGridDBBandedColumn
            Caption = #48512#44032#49464
            DataBinding.FieldName = 'calc_vat'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 11
            Position.RowIndex = 0
          end
          object V1assign_lane_no: TcxGridDBBandedColumn
            DataBinding.FieldName = 'assign_lane_no'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 12
            Position.RowIndex = 0
          end
          object V1assign_no: TcxGridDBBandedColumn
            DataBinding.FieldName = 'assign_no'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 13
            Position.RowIndex = 0
          end
          object V1prod_div: TcxGridDBBandedColumn
            DataBinding.FieldName = 'prod_div'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 14
            Position.RowIndex = 0
          end
          object V1prod_detail_div: TcxGridDBBandedColumn
            DataBinding.FieldName = 'prod_detail_div'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 15
            Position.RowIndex = 0
          end
          object V1prod_cd: TcxGridDBBandedColumn
            AlternateCaption = '20'
            DataBinding.FieldName = 'prod_cd'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 16
            Position.RowIndex = 0
          end
          object V1keep_amt: TcxGridDBBandedColumn
            DataBinding.FieldName = 'keep_amt'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 17
            Position.RowIndex = 0
          end
          object V1seq: TcxGridDBBandedColumn
            DataBinding.FieldName = 'seq'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 23
            Position.RowIndex = 0
          end
          object V1member_no: TcxGridDBBandedColumn
            DataBinding.FieldName = 'member_no'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 22
            Position.RowIndex = 0
          end
          object V1locker_no: TcxGridDBBandedColumn
            DataBinding.FieldName = 'locker_no'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 18
            Position.RowIndex = 0
          end
          object V1locker_nm: TcxGridDBBandedColumn
            DataBinding.FieldName = 'locker_nm'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 19
            Position.RowIndex = 0
          end
          object V1purchase_month: TcxGridDBBandedColumn
            DataBinding.FieldName = 'purchase_month'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 20
            Position.RowIndex = 0
          end
          object V1start_dt: TcxGridDBBandedColumn
            DataBinding.FieldName = 'start_dt'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 21
            Position.RowIndex = 0
          end
        end
        object L1: TcxGridLevel
          GridView = V1
        end
      end
    end
    object panRight: TPanel
      AlignWithMargins = True
      Left = 684
      Top = 5
      Width = 1011
      Height = 957
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      object panCategory: TPanel
        Left = 0
        Top = 0
        Width = 1011
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object btnPluGroup1: TSpeedButton
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 197
          Height = 54
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          GroupIndex = 3000
          Down = True
          Caption = #44172#51076#49345#54408#13#10#51060#50857#44428
          Images = BPDM.imlIcon32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitHeight = 56
        end
        object btnPluGroup4: TSpeedButton
          AlignWithMargins = True
          Left = 606
          Top = 0
          Width = 197
          Height = 54
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          GroupIndex = 3000
          Caption = #46972#52964#49345#54408#13#10#48372#51613#44552
          Images = BPDM.imlIcon32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitHeight = 56
        end
        object btnPluGroup3: TSpeedButton
          AlignWithMargins = True
          Left = 404
          Top = 0
          Width = 197
          Height = 54
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          GroupIndex = 3000
          Caption = #46972#52964#49345#54408#13#10#50900#51060#50857#47308
          Images = BPDM.imlIcon32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitHeight = 56
        end
        object btnPluGroup2: TSpeedButton
          AlignWithMargins = True
          Left = 202
          Top = 0
          Width = 197
          Height = 54
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          GroupIndex = 3000
          Caption = #44172#51076#49345#54408#13#10#54924#50896#44428
          Images = BPDM.imlIcon32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitHeight = 56
        end
        object shpCategorySeparator: TShape
          Left = 0
          Top = 54
          Width = 1011
          Height = 3
          Align = alBottom
          Brush.Color = clHighlight
          Pen.Color = clHighlight
          ExplicitTop = 52
          ExplicitWidth = 1010
        end
        object panPluGroupPrev: TPanel
          AlignWithMargins = True
          Left = 808
          Top = 0
          Width = 97
          Height = 49
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alLeft
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 0
          TabStop = True
          object lblPluGroupPrev: TLabel
            Left = 1
            Top = 1
            Width = 95
            Height = 47
            Cursor = crHandPoint
            Margins.Top = 0
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = #9664
            Color = 8020573
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = True
            Layout = tlCenter
            StyleElements = [seFont]
            OnClick = lblPluGroupPrevClick
            OnMouseDown = OnLeftRightMouseDown
            OnMouseUp = OnLeftRightMouseUp
            ExplicitLeft = -1
            ExplicitTop = -1
            ExplicitWidth = 93
            ExplicitHeight = 50
          end
        end
        object panPluGroupNext: TPanel
          AlignWithMargins = True
          Left = 909
          Top = 0
          Width = 97
          Height = 49
          Cursor = crHandPoint
          Margins.Left = 4
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alLeft
          Caption = #9654
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 1
          TabStop = True
          object lblPluGroupNext: TLabel
            Left = 1
            Top = 1
            Width = 95
            Height = 47
            Cursor = crHandPoint
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = #9654
            Color = 8020573
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = True
            Layout = tlCenter
            StyleElements = [seFont]
            OnClick = lblPluGroupNextClick
            OnMouseDown = OnLeftRightMouseDown
            OnMouseUp = OnLeftRightMouseUp
            ExplicitLeft = 0
            ExplicitWidth = 96
          end
        end
      end
      object panPluList: TPanel
        Left = 0
        Top = 57
        Width = 1011
        Height = 462
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        Caption = '<'#51060' '#52852#53580#44256#47532#50640' '#46321#47197#46108' '#49345#54408#51060' '#50630#49845#45768#45796'.>'
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 7171437
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        ShowCaption = False
        TabOrder = 1
        StyleElements = [seClient, seBorder]
        object TemplatePluPanel: TPanel
          Left = 0
          Top = 5
          Width = 197
          Height = 86
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
          Visible = False
          object TemplateProdAmtLabel: TLabel
            Left = 1
            Top = 55
            Width = 195
            Height = 30
            Cursor = crHandPoint
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            Caption = '12,000'
            Color = 8020573
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3305471
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            Transparent = True
            Layout = tlCenter
            StyleElements = []
            ExplicitTop = 62
            ExplicitWidth = 196
          end
          object TemplateProdInfoLabel: TLabel
            Left = 1
            Top = 31
            Width = 195
            Height = 24
            Cursor = crHandPoint
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = '(10:00 ~ 17:00)'
            Color = 8020573
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 16744448
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Transparent = True
            Layout = tlCenter
            StyleElements = []
            ExplicitLeft = 0
            ExplicitTop = 37
            ExplicitWidth = 196
            ExplicitHeight = 25
          end
          object TemplateProdNameLabel: TLabel
            Left = 1
            Top = 1
            Width = 195
            Height = 30
            Cursor = crHandPoint
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            Caption = #54924#50896#44428#44172#51076'50'#54924
            Color = 8020573
            EllipsisPosition = epEndEllipsis
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = True
            Layout = tlCenter
            StyleElements = [seFont]
            ExplicitLeft = 0
            ExplicitTop = 3
            ExplicitWidth = 196
          end
        end
        object panPluListPrev: TPanel
          Left = 808
          Top = 369
          Width = 98
          Height = 86
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object lblPluListPrev: TLabel
            Left = 1
            Top = 1
            Width = 96
            Height = 84
            Cursor = crHandPoint
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = #9664
            Color = 8020573
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = True
            Layout = tlCenter
            StyleElements = [seFont]
            OnClick = lblPluListPrevClick
            OnMouseDown = OnLeftRightMouseDown
            OnMouseUp = OnLeftRightMouseUp
            ExplicitLeft = 2
            ExplicitTop = -1
            ExplicitWidth = 94
          end
        end
        object panPluListNext: TPanel
          Left = 911
          Top = 369
          Width = 98
          Height = 86
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object lblPluListNext: TLabel
            Left = 1
            Top = 1
            Width = 96
            Height = 84
            Cursor = crHandPoint
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = #9654
            Color = 8020573
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Pretendard Variable'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = True
            Layout = tlCenter
            StyleElements = [seFont]
            OnClick = lblPluListNextClick
            OnMouseDown = OnLeftRightMouseDown
            OnMouseUp = OnLeftRightMouseUp
            ExplicitTop = -1
          end
        end
      end
      object pgcSaleDetail: TPageControl
        Left = 0
        Top = 687
        Width = 1011
        Height = 270
        ActivePage = tabPayment
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = [fsBold]
        ParentFont = False
        TabHeight = 46
        TabOrder = 2
        TabWidth = 200
        object tabPayment: TTabSheet
          AlignWithMargins = True
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #44208#51228' '#45236#50669
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          object panPaymentSideBar: TPanel
            Left = 886
            Top = 0
            Width = 113
            Height = 210
            Align = alRight
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object btnPaymentCancel: TBitBtn
              AlignWithMargins = True
              Left = 5
              Top = 0
              Width = 108
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Align = alTop
              Caption = #44208#51228' '#52712#49548
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              Images = BPDM.imlIcon32
              ParentFont = False
              TabOrder = 0
              WordWrap = True
              OnClick = btnPaymentCancelClick
            end
          end
          object G2: TcxGrid
            Left = 0
            Top = 0
            Width = 886
            Height = 210
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 0
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            LookAndFeel.Kind = lfUltraFlat
            LookAndFeel.NativeStyle = False
            LookAndFeel.ScrollbarMode = sbmTouch
            LookAndFeel.ScrollMode = scmSmooth
            object V2: TcxGridDBBandedTableView
              Navigator.Buttons.CustomButtons = <>
              ScrollbarAnnotations.CustomAnnotations = <>
              DataController.DataSource = dsrPayment
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <
                item
                  Format = #44228
                  Kind = skCount
                  FieldName = 'seq'
                  Column = V2buyer_nm
                end
                item
                  Format = ',0 ; -,0 '
                  Kind = skSum
                  FieldName = 'approve_amt'
                  Column = V2approve_amt
                end
                item
                  Format = ',0 ; -,0 '
                  Kind = skSum
                  FieldName = 'apply_dc_amt'
                end>
              DataController.Summary.SummaryGroups = <>
              DataController.Summary.OnAfterSummary = V2DataControllerSummaryAfterSummary
              OptionsCustomize.ColumnFiltering = False
              OptionsCustomize.ColumnGrouping = False
              OptionsCustomize.ColumnHidingOnGrouping = False
              OptionsCustomize.ColumnMoving = False
              OptionsCustomize.ColumnVertSizing = False
              OptionsData.Deleting = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsSelection.CellSelect = False
              OptionsView.FocusRect = False
              OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
              OptionsView.ScrollBars = ssVertical
              OptionsView.ColumnAutoWidth = True
              OptionsView.Footer = True
              OptionsView.GridLines = glVertical
              OptionsView.GroupByBox = False
              OptionsView.BandHeaders = False
              Styles.Header = BPDM.StyleHeader1
              Styles.Inactive = BPDM.StyleSelection
              Styles.Indicator = BPDM.StyleHeader1
              Styles.Selection = BPDM.StyleSelection
              Styles.BandHeader = BPDM.StyleHeader1
              Bands = <
                item
                end>
              object V2calc_pay_method: TcxGridDBBandedColumn
                Caption = #44208#51228#49688#45800
                DataBinding.FieldName = 'pay_method_nm'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentHorz = taCenter
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 0
                Position.RowIndex = 0
              end
              object V2card_no: TcxGridDBBandedColumn
                Caption = #52852#46300#48264#54840'/'#49885#48324#48264#54840
                DataBinding.FieldName = 'card_no'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentHorz = taCenter
                Width = 180
                Position.BandIndex = 0
                Position.ColIndex = 1
                Position.RowIndex = 0
              end
              object V2approve_no: TcxGridDBBandedColumn
                Caption = #49849#51064#48264#54840
                DataBinding.FieldName = 'approve_no'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Horz = taCenter
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentHorz = taCenter
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 2
                Position.RowIndex = 0
              end
              object V2issuer_nm: TcxGridDBBandedColumn
                Caption = #48156#44553#49324
                DataBinding.FieldName = 'issuer_nm'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentHorz = taCenter
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 3
                Position.RowIndex = 0
              end
              object V2buyer_nm: TcxGridDBBandedColumn
                Caption = #47588#51077#49324
                DataBinding.FieldName = 'buyer_nm'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Vert = taVCenter
                FooterAlignmentHorz = taCenter
                HeaderAlignmentHorz = taCenter
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 4
                Position.RowIndex = 0
              end
              object V2approve_amt: TcxGridDBBandedColumn
                Caption = #44208#51228#44552#50529
                DataBinding.FieldName = 'approve_amt'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.Alignment.Horz = taRightJustify
                Properties.DisplayFormat = ',0 ; -,0 '
                FooterAlignmentHorz = taRightJustify
                HeaderAlignmentHorz = taCenter
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 5
                Position.RowIndex = 0
              end
              object V2calc_cancel_count: TcxGridDBBandedColumn
                DataBinding.FieldName = 'calc_cancel_count'
                DataBinding.IsNullValueType = True
                MinWidth = 0
                Width = 0
                Position.BandIndex = 0
                Position.ColIndex = 6
                Position.RowIndex = 0
              end
            end
            object L2: TcxGridLevel
              GridView = V2
            end
          end
        end
        object tabCoupon: TTabSheet
          AlignWithMargins = True
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = #53216#54256' '#45236#50669
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ImageIndex = 1
          ParentFont = False
          object panCouponSideBar: TPanel
            Left = 886
            Top = 0
            Width = 113
            Height = 210
            Align = alRight
            BevelOuter = bvNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            object btnCouponNoInput: TBitBtn
              AlignWithMargins = True
              Left = 5
              Top = 110
              Width = 108
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Align = alTop
              Caption = #53216#54256#48264#54840' '#46321#47197
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              Images = BPDM.imlIcon32
              ParentFont = False
              TabOrder = 2
              WordWrap = True
              OnClick = btnCouponNoInputClick
            end
            object btnCouponCancel: TBitBtn
              AlignWithMargins = True
              Left = 5
              Top = 0
              Width = 108
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Align = alTop
              Caption = #53216#54256' '#49324#50857' '#52712#49548
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              Images = BPDM.imlIcon32
              ParentFont = False
              TabOrder = 0
              WordWrap = True
              OnClick = btnCouponCancelClick
            end
            object btnCouponRefresh: TBitBtn
              AlignWithMargins = True
              Left = 5
              Top = 55
              Width = 108
              Height = 50
              Cursor = crHandPoint
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 5
              Align = alTop
              Caption = #53216#54256' '#51116#44228#49328
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Pretendard Variable'
              Font.Style = []
              Images = BPDM.imlIcon32
              ParentFont = False
              TabOrder = 1
              WordWrap = True
              OnClick = btnCouponRefreshClick
            end
          end
          object G3: TcxGrid
            Left = 0
            Top = 0
            Width = 886
            Height = 210
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 0
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            LookAndFeel.Kind = lfUltraFlat
            LookAndFeel.NativeStyle = False
            LookAndFeel.ScrollbarMode = sbmTouch
            LookAndFeel.ScrollMode = scmSmooth
            object V3: TcxGridDBBandedTableView
              Navigator.Buttons.CustomButtons = <>
              ScrollbarAnnotations.CustomAnnotations = <>
              DataController.DataSource = dsrCoupon
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <
                item
                  Format = #53216#54256' '#54633#44228
                  Kind = skCount
                  FieldName = 'seq'
                  Column = V3calc_dc_div
                end
                item
                  Format = ',0 ; -,0 '
                  Kind = skSum
                  FieldName = 'coupon_amt'
                  Column = V3coupon_amt
                end
                item
                  Format = ',0 ; -,0 '
                  Kind = skSum
                  FieldName = 'apply_dc_amt'
                  Column = V3apply_dc_amt
                end>
              DataController.Summary.SummaryGroups = <>
              DataController.Summary.OnAfterSummary = V3DataControllerSummaryAfterSummary
              OptionsCustomize.ColumnFiltering = False
              OptionsCustomize.ColumnGrouping = False
              OptionsCustomize.ColumnHidingOnGrouping = False
              OptionsCustomize.ColumnMoving = False
              OptionsCustomize.ColumnVertSizing = False
              OptionsData.Deleting = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsSelection.CellSelect = False
              OptionsView.FocusRect = False
              OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
              OptionsView.ScrollBars = ssVertical
              OptionsView.ColumnAutoWidth = True
              OptionsView.Footer = True
              OptionsView.GridLines = glVertical
              OptionsView.GroupByBox = False
              OptionsView.BandHeaders = False
              Styles.Header = BPDM.StyleHeader1
              Styles.Inactive = BPDM.StyleSelection
              Styles.Indicator = BPDM.StyleHeader1
              Styles.Selection = BPDM.StyleSelection
              Styles.BandHeader = BPDM.StyleHeader1
              Bands = <
                item
                end>
              object V3coupon_nm: TcxGridDBBandedColumn
                Caption = #53216#54256#47749
                DataBinding.FieldName = 'coupon_nm'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentHorz = taCenter
                Width = 180
                Position.BandIndex = 0
                Position.ColIndex = 0
                Position.RowIndex = 0
              end
              object V3calc_prod_div: TcxGridDBBandedColumn
                Caption = #49345#54408#44396#48516
                DataBinding.FieldName = 'calc_prod_div'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentHorz = taCenter
                Width = 130
                Position.BandIndex = 0
                Position.ColIndex = 1
                Position.RowIndex = 0
              end
              object V3game_prod_div: TcxGridDBBandedColumn
                Caption = #44172#51076#49345#54408#44396#48516
                DataBinding.FieldName = 'game_prod_div'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Horz = taCenter
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentHorz = taCenter
                Width = 130
                Position.BandIndex = 0
                Position.ColIndex = 2
                Position.RowIndex = 0
              end
              object V3calc_dc_div: TcxGridDBBandedColumn
                Caption = #54624#51064#44396#48516
                DataBinding.FieldName = 'calc_dc_div'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Vert = taVCenter
                FooterAlignmentHorz = taCenter
                HeaderAlignmentHorz = taCenter
                Width = 80
                Position.BandIndex = 0
                Position.ColIndex = 3
                Position.RowIndex = 0
              end
              object V3coupon_amt: TcxGridDBBandedColumn
                Caption = #53216#54256#44552#50529
                DataBinding.FieldName = 'coupon_dc_amt'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.Alignment.Horz = taRightJustify
                Properties.DisplayFormat = ',0 ; -,0 '
                FooterAlignmentHorz = taRightJustify
                HeaderAlignmentHorz = taCenter
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 4
                Position.RowIndex = 0
              end
              object V3apply_dc_amt: TcxGridDBBandedColumn
                Caption = #54624#51064#44552#50529
                DataBinding.FieldName = 'apply_dc_amt'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.Alignment.Horz = taRightJustify
                Properties.DisplayFormat = ',0 ; -,0 '
                FooterAlignmentHorz = taRightJustify
                HeaderAlignmentHorz = taCenter
                Width = 100
                Position.BandIndex = 0
                Position.ColIndex = 5
                Position.RowIndex = 0
              end
            end
            object L3: TcxGridLevel
              GridView = V3
            end
          end
        end
      end
      object panMemberInfo: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 523
        Width = 1011
        Height = 159
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 5
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
        object panMemberSidebar: TPanel
          Left = 892
          Top = 6
          Width = 113
          Height = 147
          Align = alRight
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 11
          object btnAddMember: TBitBtn
            AlignWithMargins = True
            Left = 5
            Top = 50
            Width = 108
            Height = 45
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #49888#44508' '#54924#50896' '#46321#47197
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 1
            WordWrap = True
            OnClick = btnAddMemberClick
          end
          object btnSearchMember: TBitBtn
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 108
            Height = 45
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #54924#50896' '#44160#49353
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 0
            WordWrap = True
            OnClick = btnSearchMemberClick
          end
          object btnClearMember: TBitBtn
            AlignWithMargins = True
            Left = 5
            Top = 100
            Width = 108
            Height = 45
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 5
            Align = alTop
            Caption = #54924#50896' '#49440#53469' '#52712#49548
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Pretendard Variable'
            Font.Style = []
            Images = BPDM.imlIcon32
            ParentFont = False
            TabOrder = 2
            WordWrap = True
            OnClick = btnClearMemberClick
          end
        end
        object panMemberPhoto: TPanel
          Left = 6
          Top = 6
          Width = 133
          Height = 147
          Align = alLeft
          TabOrder = 12
          object imgMemberPhoto: TImage
            Left = 1
            Top = 1
            Width = 131
            Height = 145
            Align = alLeft
            Center = True
            Enabled = False
            Stretch = True
            ExplicitLeft = 9
            ExplicitTop = 2
          end
        end
        object mmoMemberMemo: TDBMemoEh
          Left = 617
          Top = 84
          Width = 274
          Height = 63
          ControlLabel.Width = 26
          ControlLabel.Height = 18
          ControlLabel.Caption = #47700#47784
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftTopEh
          AutoSize = False
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 13
          Visible = True
          WantReturns = True
        end
        object edtMemberName: TDBEditEh
          Left = 211
          Top = 12
          Width = 100
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 39
          ControlLabel.Height = 18
          ControlLabel.Caption = #54924#50896#47749
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = 16744448
          ControlLabel.Font.Height = -15
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          ControlLabel.StyleElements = [seClient, seBorder]
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #44160#49353
          ImeMode = imSHanguel
          TabOrder = 0
          Visible = True
          OnKeyDown = edtMemberNameKeyDown
          EditMask = ''
        end
        object edtMemberNo: TDBEditEh
          Left = 211
          Top = 48
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 52
          ControlLabel.Height = 18
          ControlLabel.Caption = #54924#50896#48264#54840
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 4
          Visible = True
          EditMask = ''
        end
        object edtMemberSexDivName: TDBEditEh
          Left = 315
          Top = 12
          Width = 26
          Height = 27
          Alignment = taCenter
          AutoSize = False
          ControlLabel.Caption = #49457#48324
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 1
          Visible = True
        end
        object edtMemberTelNo: TDBEditEh
          Left = 422
          Top = 12
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 52
          ControlLabel.Height = 18
          ControlLabel.Caption = #51204#54868#48264#54840
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = 16744448
          ControlLabel.Font.Height = -15
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          ControlLabel.StyleElements = [seClient, seBorder]
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #44160#49353
          ImeMode = imSAlpha
          TabOrder = 2
          Visible = True
          OnKeyDown = edtMemberTelNoKeyDown
          EditMask = ''
        end
        object edtMemberCarNo: TDBEditEh
          Left = 211
          Top = 84
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 52
          ControlLabel.Height = 18
          ControlLabel.Caption = #52264#47049#48264#54840
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 7
          Visible = True
          EditMask = ''
        end
        object edtMemberSavePoint: TDBNumberEditEh
          Left = 422
          Top = 84
          Width = 130
          Height = 27
          ControlLabel.Width = 39
          ControlLabel.Height = 18
          ControlLabel.Caption = #54252#51064#53944
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          Alignment = taRightJustify
          AutoSize = False
          DecimalPlaces = 0
          DisplayFormat = ',0'
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 8
          Value = 0.000000000000000000
          Visible = True
        end
        object edtMemberDivName: TDBEditEh
          Left = 422
          Top = 48
          Width = 130
          Height = 26
          Alignment = taLeftJustify
          ControlLabel.Width = 52
          ControlLabel.Height = 18
          ControlLabel.Caption = #54924#50896#44396#48516
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 5
          Visible = True
          EditMask = ''
        end
        object edtMemberClubName: TDBEditEh
          Left = 617
          Top = 12
          Width = 274
          Height = 26
          Alignment = taLeftJustify
          ControlLabel.Width = 39
          ControlLabel.Height = 18
          ControlLabel.Caption = #53364#47101#47749
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 3
          Visible = True
          EditMask = ''
        end
        object edtMemberLockerList: TDBEditEh
          Left = 211
          Top = 120
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 26
          ControlLabel.Height = 18
          ControlLabel.Caption = #46972#52964
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          Enabled = False
          ReadOnly = True
          TabOrder = 9
          Visible = True
          EditMask = ''
        end
        object edtMemberLockerExpireDate: TDBEditEh
          Left = 422
          Top = 120
          Width = 130
          Height = 27
          Alignment = taLeftJustify
          AutoSize = False
          ControlLabel.Width = 65
          ControlLabel.Height = 18
          ControlLabel.Caption = #46972#52964#47564#47308#51068
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          Enabled = False
          ReadOnly = True
          TabOrder = 10
          Visible = True
          EditMask = ''
        end
        object edtMemberGroupName: TDBEditEh
          Left = 617
          Top = 48
          Width = 274
          Height = 26
          Alignment = taLeftJustify
          ControlLabel.Width = 26
          ControlLabel.Height = 18
          ControlLabel.Caption = #45800#52404
          ControlLabel.Visible = True
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftCenterEh
          DynProps = <>
          EditButtons = <>
          ReadOnly = True
          TabOrder = 6
          Visible = True
          EditMask = ''
        end
      end
    end
    object panFooter: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 967
      Width = 1690
      Height = 50
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      object btnSaleComplete: TBitBtn
        AlignWithMargins = True
        Left = 1469
        Top = 0
        Width = 221
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Caption = #44144#47000' '#50756#47308
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 0
        WordWrap = True
        OnClick = btnSaleCompleteClick
      end
      object btnPaymentCard: TBitBtn
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #49888#50857#52852#46300
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 1
        WordWrap = True
        OnClick = btnPaymentCardClick
      end
      object btnPaymentCash: TBitBtn
        AlignWithMargins = True
        Left = 113
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #54788#44552
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 2
        WordWrap = True
        OnClick = btnPaymentCashClick
      end
      object btnPaymentPayco: TBitBtn
        AlignWithMargins = True
        Left = 226
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'PAYCO'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 3
        WordWrap = True
        OnClick = btnPaymentPaycoClick
      end
      object btnPaymentVoucher: TBitBtn
        AlignWithMargins = True
        Left = 339
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #49440#48520' '#49345#54408#44428
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 4
        WordWrap = True
        OnClick = btnPaymentVoucherClick
      end
      object btnPaymentAffiliate: TBitBtn
        AlignWithMargins = True
        Left = 452
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #51228#55092#49324' '#54924#50896
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 5
        WordWrap = True
        OnClick = btnPaymentAffiliateClick
      end
      object btnShowLaneList: TBitBtn
        AlignWithMargins = True
        Left = 1130
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #47112#51064' '#44288#47532#13#10'(ESC)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 11
        WordWrap = True
        OnClick = btnShowLaneListClick
      end
      object btnPendingList: TBitBtn
        AlignWithMargins = True
        Left = 791
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #48372#47448' '#54840#52636
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 9
        WordWrap = True
        OnClick = btnPendingListClick
      end
      object btnFacility: TBitBtn
        AlignWithMargins = True
        Left = 565
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #48512#45824#49884#49444#13#10#51060#50857#44428
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 6
        WordWrap = True
        OnClick = btnFacilityClick
      end
      object btnSearchProd: TBitBtn
        AlignWithMargins = True
        Left = 904
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #49345#54408' '#44160#49353
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 7
        WordWrap = True
        OnClick = btnSearchProdClick
      end
      object btnShowLockerList: TBitBtn
        AlignWithMargins = True
        Left = 1243
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #46972#52964' '#44288#47532
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 12
        WordWrap = True
        OnClick = btnShowLockerListClick
      end
      object btnShowReceiptList: TBitBtn
        AlignWithMargins = True
        Left = 1356
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #44144#47000#45236#50669' '#51312#54924
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 13
        WordWrap = True
        OnClick = btnShowReceiptListClick
      end
      object btnSpare: TBitBtn
        AlignWithMargins = True
        Left = 1017
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 10
        WordWrap = True
      end
      object btnAddPending: TBitBtn
        AlignWithMargins = True
        Left = 678
        Top = 0
        Width = 108
        Height = 50
        Cursor = crHandPoint
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = #48372#47448' '#46321#47197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        Images = BPDM.imlIcon32
        ParentFont = False
        TabOrder = 8
        WordWrap = True
        OnClick = btnAddPendingClick
      end
    end
  end
  object tmrRunOnce: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrRunOnceTimer
    Left = 165
    Top = 16
  end
  object dsrSaleItem: TDataSource
    AutoEdit = False
    DataSet = BPDM.QRSaleItem
    Left = 53
    Top = 288
  end
  object dsrPayment: TDataSource
    AutoEdit = False
    DataSet = BPDM.QRPayment
    Left = 805
    Top = 824
  end
  object dsrCoupon: TDataSource
    AutoEdit = False
    Left = 901
    Top = 824
  end
  object dsrReceipt: TDataSource
    AutoEdit = False
    DataSet = BPDM.QRReceipt
    Left = 53
    Top = 224
  end
end
