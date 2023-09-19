object BPReceiptViewForm: TBPReceiptViewForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 1022
  ClientWidth = 1700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object splMainGrid: TSplitter
    Left = 0
    Top = 534
    Width = 1700
    Height = 5
    Cursor = crVSplit
    Align = alTop
    MinSize = 100
    ExplicitTop = 589
  end
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 1700
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #44144#47000' '#45236#50669' '#51312#54924
    Color = 5393480
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Pretendard Variable'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    StyleElements = []
    OnMouseMove = panHeaderMouseMove
    object lblPluginVersion: TLabel
      AlignWithMargins = True
      Left = 43
      Top = 5
      Width = 95
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'PLUGIN Ver.1.0.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      ExplicitHeight = 13
    end
    object panHeaderToolbar: TPanel
      AlignWithMargins = True
      Left = 1665
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
      end
    end
    object panHeaderMenuBar: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 32
      Height = 32
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 1
      StyleElements = []
      object btnMainMenu: TSpeedButton
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Align = alLeft
        ImageIndex = 1
        ImageName = 'Menu_W_32px'
        Images = BPDM.imlIcon32
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        ExplicitTop = 2
      end
    end
  end
  object panMaster: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 84
    Width = 1690
    Height = 450
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object G1: TcxGrid
      Left = 0
      Top = 0
      Width = 1690
      Height = 450
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      LookAndFeel.ScrollbarMode = sbmTouch
      LookAndFeel.ScrollMode = scmSmooth
      object V1: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCustomDrawCell = V1CustomDrawCell
        OnFocusedRecordChanged = V1FocusedRecordChanged
        DataController.DataSource = dsrReceiptList
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'sale_amt'
            Column = V1sale_amt
          end
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'calc_dc_amt'
            Column = V1calc_dc_amt
          end
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'use_point'
            Column = V1use_point
          end
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'charge_amt'
            Column = V1charge_amt
          end>
        DataController.Summary.SummaryGroups = <>
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
        Styles.Header = BPDM.StyleHeader1
        Styles.Inactive = BPDM.StyleSelection
        Styles.Indicator = BPDM.StyleHeader1
        Styles.Selection = BPDM.StyleSelection
        Styles.BandHeader = BPDM.StyleHeader1
        OnCustomDrawIndicatorCell = V1CustomDrawIndicatorCell
        Bands = <
          item
            Caption = #44144#47000' '#45236#50669
          end>
        object V1calc_cancel_yn: TcxGridDBBandedColumn
          Caption = #44396#48516
          DataBinding.FieldName = 'calc_cancel_yn'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 80
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object V1receipt_no: TcxGridDBBandedColumn
          Caption = #50689#49688#51613' '#48264#54840
          DataBinding.FieldName = 'receipt_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 220
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object V1calc_sale_root_div: TcxGridDBBandedColumn
          Caption = #44144#47000' '#50948#52824
          DataBinding.FieldName = 'calc_sale_root_div'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 169
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object V1sale_tm: TcxGridDBBandedColumn
          Caption = #44144#47000' '#49884#44033
          DataBinding.FieldName = 'sale_tm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 126
          Position.BandIndex = 0
          Position.ColIndex = 4
          Position.RowIndex = 0
        end
        object V1pos_no: TcxGridDBBandedColumn
          Caption = 'POS '#48264#54840
          DataBinding.FieldName = 'pos_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 86
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object V1order_nm: TcxGridDBBandedColumn
          Caption = #51452#47928' '#45236#50669
          DataBinding.FieldName = 'order_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 297
          Position.BandIndex = 0
          Position.ColIndex = 5
          Position.RowIndex = 0
        end
        object V1sale_amt: TcxGridDBBandedColumn
          Caption = #49345#54408' '#44552#50529
          DataBinding.FieldName = 'sale_amt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          Width = 140
          Position.BandIndex = 0
          Position.ColIndex = 6
          Position.RowIndex = 0
        end
        object V1calc_dc_amt: TcxGridDBBandedColumn
          Caption = #54624#51064' '#44552#50529
          DataBinding.FieldName = 'calc_dc_amt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          Width = 140
          Position.BandIndex = 0
          Position.ColIndex = 7
          Position.RowIndex = 0
        end
        object V1use_point: TcxGridDBBandedColumn
          Caption = #54252#51064#53944' '#49324#50857
          DataBinding.FieldName = 'use_point'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          Width = 140
          Position.BandIndex = 0
          Position.ColIndex = 8
          Position.RowIndex = 0
        end
        object V1charge_amt: TcxGridDBBandedColumn
          Caption = #52397#44396' '#44552#50529
          DataBinding.FieldName = 'charge_amt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          Width = 140
          Position.BandIndex = 0
          Position.ColIndex = 9
          Position.RowIndex = 0
        end
        object V1sale_memo: TcxGridDBBandedColumn
          Caption = #47700#47784
          DataBinding.FieldName = 'sale_memo'
          DataBinding.IsNullValueType = True
          HeaderAlignmentHorz = taCenter
          Width = 300
          Position.BandIndex = 0
          Position.ColIndex = 10
          Position.RowIndex = 0
        end
        object V1user_id: TcxGridDBBandedColumn
          Caption = #54032#47588#51088' ID'
          DataBinding.FieldName = 'user_id'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 120
          Position.BandIndex = 0
          Position.ColIndex = 11
          Position.RowIndex = 0
        end
        object V1cancel_cnt: TcxGridDBBandedColumn
          Caption = #49849#51064#50668#48512
          DataBinding.FieldName = 'cancel_cnt'
          DataBinding.IsNullValueType = True
          MinWidth = 0
          Width = 0
          Position.BandIndex = 0
          Position.ColIndex = 12
          Position.RowIndex = 0
        end
      end
      object L1: TcxGridLevel
        GridView = V1
      end
    end
  end
  object panDetail: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 539
    Width = 1690
    Height = 483
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object splSubGrid: TSplitter
      Left = 0
      Top = 228
      Width = 1690
      Height = 5
      Cursor = crVSplit
      Align = alTop
      MinSize = 100
      ExplicitLeft = 2
      ExplicitTop = 183
      ExplicitWidth = 950
    end
    object G2: TcxGrid
      Left = 0
      Top = 0
      Width = 1690
      Height = 228
      Align = alTop
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      LookAndFeel.ScrollbarMode = sbmTouch
      LookAndFeel.ScrollMode = scmSmooth
      object V2: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.DataSource = dsrSaleItemList
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'calc_sale_amt'
            Column = V2calc_sale_amt
          end
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'dc_amt'
            Column = V2dc_amt
          end
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'use_point'
            Column = V2use_point
          end
          item
            Format = ',0 '
            Kind = skSum
            FieldName = 'calc_charge_amt'
            Column = V2calc_charge_amt
          end>
        DataController.Summary.SummaryGroups = <>
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
        Styles.Header = BPDM.StyleHeader1
        Styles.Inactive = BPDM.StyleSelection
        Styles.Indicator = BPDM.StyleHeader1
        Styles.Selection = BPDM.StyleSelection
        Styles.BandHeader = BPDM.StyleHeader1
        Bands = <
          item
            Caption = #49345#49464' '#51452#47928' '#45236#50669
          end>
        object V2calc_assign_lane_no: TcxGridDBBandedColumn
          Caption = #47112#51064
          DataBinding.FieldName = 'calc_assign_lane_no'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 50
          Width = 85
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object V2calc_prod_div: TcxGridDBBandedColumn
          Caption = #49345#54408' '#44396#48516
          DataBinding.FieldName = 'calc_prod_div'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 100
          Width = 130
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object V2prod_nm: TcxGridDBBandedColumn
          Caption = #49345#54408#47749
          DataBinding.FieldName = 'prod_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 240
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object V2bowler_id: TcxGridDBBandedColumn
          Caption = #48380#47084' ID'
          DataBinding.FieldName = 'bowler_id'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 60
          Width = 128
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object V2member_nm: TcxGridDBBandedColumn
          Caption = #54924#50896#47749
          DataBinding.FieldName = 'member_nm'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 89
          Width = 189
          Position.BandIndex = 0
          Position.ColIndex = 4
          Position.RowIndex = 0
        end
        object V2prod_amt: TcxGridDBBandedColumn
          Caption = #49345#54408' '#45800#44032
          DataBinding.FieldName = 'prod_amt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          HeaderAlignmentHorz = taCenter
          MinWidth = 90
          Width = 195
          Position.BandIndex = 0
          Position.ColIndex = 5
          Position.RowIndex = 0
        end
        object V2order_qty: TcxGridDBBandedColumn
          Caption = #51452#47928' '#49688#47049
          DataBinding.FieldName = 'order_qty'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          HeaderAlignmentHorz = taCenter
          MinWidth = 70
          Width = 149
          Position.BandIndex = 0
          Position.ColIndex = 6
          Position.RowIndex = 0
        end
        object V2calc_sale_amt: TcxGridDBBandedColumn
          Caption = #49345#54408' '#44552#50529
          DataBinding.FieldName = 'calc_sale_amt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          MinWidth = 90
          Width = 193
          Position.BandIndex = 0
          Position.ColIndex = 7
          Position.RowIndex = 0
        end
        object V2dc_amt: TcxGridDBBandedColumn
          Caption = #54624#51064' '#44552#50529
          DataBinding.FieldName = 'dc_amt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          MinWidth = 90
          Width = 191
          Position.BandIndex = 0
          Position.ColIndex = 8
          Position.RowIndex = 0
        end
        object V2use_point: TcxGridDBBandedColumn
          Caption = #54252#51064#53944' '#49324#50857
          DataBinding.FieldName = 'use_point'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          Width = 193
          Position.BandIndex = 0
          Position.ColIndex = 9
          Position.RowIndex = 0
        end
        object V2calc_charge_amt: TcxGridDBBandedColumn
          Caption = #52397#44396' '#44552#50529
          DataBinding.FieldName = 'calc_charge_amt'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.DisplayFormat = ',0 ;-,0 '
          FooterAlignmentHorz = taRightJustify
          HeaderAlignmentHorz = taCenter
          MinWidth = 90
          Width = 193
          Position.BandIndex = 0
          Position.ColIndex = 10
          Position.RowIndex = 0
        end
      end
      object L2: TcxGridLevel
        GridView = V2
      end
    end
    object G3: TcxGrid
      AlignWithMargins = True
      Left = 0
      Top = 233
      Width = 623
      Height = 250
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alLeft
      BevelInner = bvNone
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
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
        DataController.DataSource = dsrCouponList
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
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
        OptionsView.GridLines = glVertical
        OptionsView.GroupByBox = False
        Styles.Header = BPDM.StyleHeader1
        Styles.Inactive = BPDM.StyleSelection
        Styles.Indicator = BPDM.StyleHeader1
        Styles.Selection = BPDM.StyleSelection
        Styles.BandHeader = BPDM.StyleHeader1
        Bands = <
          item
            Caption = #53216#54256' '#49324#50857' '#45236#50669
          end>
        object V3Column1: TcxGridDBBandedColumn
          Caption = #44396#48516
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 86
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object V3Column2: TcxGridDBBandedColumn
          Caption = #53216#54256#47749
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 173
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object V3Column3: TcxGridDBBandedColumn
          Caption = #51201#50857' '#44552#50529
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 125
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object V3Column4: TcxGridDBBandedColumn
          Caption = #47564#47308' '#51068#51088
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 102
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object V3Column5: TcxGridDBBandedColumn
          Caption = #47588#49688
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 59
          Position.BandIndex = 0
          Position.ColIndex = 4
          Position.RowIndex = 0
        end
        object V3Column6: TcxGridDBBandedColumn
          Caption = #49324#50857' '#50668#48512
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 76
          Position.BandIndex = 0
          Position.ColIndex = 5
          Position.RowIndex = 0
        end
      end
      object L3: TcxGridLevel
        GridView = V3
      end
    end
    object panPayment: TPanel
      Left = 628
      Top = 233
      Width = 1062
      Height = 250
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object G4: TcxGrid
        Left = 0
        Top = 0
        Width = 1062
        Height = 214
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        LookAndFeel.ScrollbarMode = sbmTouch
        LookAndFeel.ScrollMode = scmSmooth
        object V4: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          OnCustomDrawCell = V4CustomDrawCell
          OnFocusedRecordChanged = V4FocusedRecordChanged
          DataController.DataSource = dsrPaymentList
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0 '
              Kind = skSum
              FieldName = 'approve_amt'
              Column = V4approve_amt
            end
            item
              Format = ',0 '
              Kind = skSum
              FieldName = 'calc_cancel_count'
              Column = V4refund_button
            end>
          DataController.Summary.SummaryGroups = <>
          DataController.Summary.OnAfterSummary = V4DataControllerSummaryAfterSummary
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnHidingOnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsCustomize.ColumnVertSizing = False
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.FocusRect = False
          OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'>'
          OptionsView.ScrollBars = ssVertical
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GridLines = glVertical
          OptionsView.GroupByBox = False
          Styles.Header = BPDM.StyleHeader1
          Styles.Inactive = BPDM.StyleSelection
          Styles.Indicator = BPDM.StyleHeader1
          Styles.Selection = BPDM.StyleSelection
          Styles.BandHeader = BPDM.StyleHeader1
          Bands = <
            item
              Caption = #44208#51228' '#45236#50669
            end>
          object V4calc_approval_yn: TcxGridDBBandedColumn
            Caption = #49345#53468
            DataBinding.FieldName = 'calc_approval_yn'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 88
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V4calc_pay_method: TcxGridDBBandedColumn
            Caption = #44208#51228' '#49688#45800
            DataBinding.FieldName = 'calc_pay_method'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 141
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V4card_no: TcxGridDBBandedColumn
            Caption = #52852#46300' '#48264#54840' / '#54788#44552#50689#49688#51613' '#49885#48324' '#48264#54840
            DataBinding.FieldName = 'card_no'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 235
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V4inst_month: TcxGridDBBandedColumn
            Caption = #54624#48512' '#44060#50900
            DataBinding.FieldName = 'inst_month'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 77
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V4approve_no: TcxGridDBBandedColumn
            Caption = #49849#51064' '#48264#54840
            DataBinding.FieldName = 'approve_no'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 158
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V4issuer_nm: TcxGridDBBandedColumn
            Caption = #44208#51228#49688#45800' '#48156#44553' '#51452#52404
            DataBinding.FieldName = 'issuer_nm'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 152
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V4approve_amt: TcxGridDBBandedColumn
            Caption = #44208#51228' '#44552#50529
            DataBinding.FieldName = 'approve_amt'
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = ',0 ;- ,0 '
            Properties.ReadOnly = True
            FooterAlignmentHorz = taRightJustify
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 138
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V4refund_button: TcxGridDBBandedColumn
            Caption = #54872#48520' '#46321#47197
            DataBinding.ValueType = 'String'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Caption = #54872#48520
                Default = True
                ImageIndex = 6
                Hint = #54872#48520'('#44060#48324' '#52712#49548') '#46321#47197
                Kind = bkText
              end>
            Properties.Images = BPDM.imlIcon16
            Properties.ReadOnly = True
            Properties.ViewStyle = vsButtonsOnly
            Properties.OnButtonClick = V4refund_buttonPropertiesButtonClick
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            Options.ShowEditButtons = isebAlways
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V4cash_receipt_button: TcxGridDBBandedColumn
            Caption = #54788#44552#50689#49688#51613
            DataBinding.IsNullValueType = True
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Buttons = <
              item
                Caption = #48156#54665
                Default = True
                ImageIndex = 6
                Hint = #54788#44552#50689#49688#51613' '#48156#54665
                Kind = bkText
              end>
            Properties.Images = BPDM.imlIcon16
            Properties.ReadOnly = True
            Properties.ViewStyle = vsButtonsOnly
            Properties.OnButtonClick = V4cash_receipt_buttonPropertiesButtonClick
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            Options.ShowEditButtons = isebAlways
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object V4calc_cancel_count: TcxGridDBBandedColumn
            Caption = #54872#48520' '#44148#49688
            DataBinding.FieldName = 'calc_cancel_count'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object V4approval_yn: TcxGridDBBandedColumn
            Caption = #44396#48516
            DataBinding.FieldName = 'approval_yn'
            DataBinding.IsNullValueType = True
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
        end
        object L4: TcxGridLevel
          GridView = V4
        end
      end
      object panPaymentMemo: TPanel
        Left = 0
        Top = 214
        Width = 1062
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Pretendard Variable'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object lblCancelMemo: TLabel
          Left = 359
          Top = 0
          Width = 65
          Height = 36
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alRight
          Alignment = taCenter
          AutoSize = False
          Caption = #54872#48520' '#49324#50976
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Pretendard Variable'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 0
          ExplicitHeight = 46
        end
        object mmoPaymentMemo: TDBMemoEh
          AlignWithMargins = True
          Left = 424
          Top = 5
          Width = 638
          Height = 31
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 0
          ControlLabel.Font.Charset = DEFAULT_CHARSET
          ControlLabel.Font.Color = clWindowText
          ControlLabel.Font.Height = -12
          ControlLabel.Font.Name = 'Pretendard Variable'
          ControlLabel.Font.Style = []
          ControlLabel.ParentFont = False
          ControlLabelLocation.Spacing = 5
          ControlLabelLocation.Position = lpLeftTopEh
          Align = alRight
          Alignment = taLeftJustify
          AutoSize = False
          DataField = 'payment_memo'
          DataSource = dsrPaymentList
          DynProps = <>
          EditButtons = <>
          EmptyDataInfo.Text = #51077#47141#54620' '#45236#50857#51008' '#44033' '#44208#51228' '#44148#51032' '#54872#48520' '#46321#47197' '#49884' '#51200#51109#51060' '#46121#45768#45796'.'
          ParentShowHint = False
          TabOrder = 0
          Visible = True
          WantReturns = True
        end
      end
    end
  end
  object panSearch: TPanel
    Left = 0
    Top = 38
    Width = 1700
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblSaleDate: TLabel
      Left = 0
      Top = 0
      Width = 65
      Height = 46
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 1
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = #44144#47000#51068#51088
      Layout = tlCenter
      ExplicitLeft = 5
      ExplicitTop = 5
      ExplicitHeight = 30
    end
    object btnRefresh: TBitBtn
      AlignWithMargins = True
      Left = 191
      Top = 5
      Width = 100
      Height = 36
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = #49352#47196' '#44256#52840
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 11
      ImageName = 'refresh_16px'
      Images = BPDM.imlIcon16
      ParentFont = False
      TabOrder = 1
      WordWrap = True
      OnClick = btnRefreshClick
    end
    object edtSearchReceiptNo: TDBEditEh
      AlignWithMargins = True
      Left = 296
      Top = 9
      Width = 230
      Height = 28
      Margins.Left = 0
      Margins.Top = 9
      Margins.Right = 5
      Margins.Bottom = 9
      Align = alLeft
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clWindowText
      ControlLabel.Font.Height = -12
      ControlLabel.Font.Name = 'Pretendard Variable'
      ControlLabel.Font.Style = []
      ControlLabel.ParentFont = False
      DynProps = <>
      EditButtons = <
        item
          Images.NormalImages = BPDM.imlIcon16
          Images.NormalIndex = 10
          Style = ebsGlyphEh
          Width = 30
        end>
      EmptyDataInfo.Text = #50689#49688#51613' '#48264#54840' '#51312#54924
      TabOrder = 3
      Visible = True
      ExplicitHeight = 26
    end
    object btnReprintReceipt: TBitBtn
      AlignWithMargins = True
      Left = 1450
      Top = 5
      Width = 120
      Height = 36
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = #50689#49688#51613' '#51116#48156#54665
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      WordWrap = True
      OnClick = btnReprintReceiptClick
    end
    object edtSearchDate: TDBDateTimeEditEh
      AlignWithMargins = True
      Left = 65
      Top = 9
      Width = 121
      Height = 28
      Margins.Left = 0
      Margins.Top = 9
      Margins.Right = 5
      Margins.Bottom = 9
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clWindowText
      ControlLabel.Font.Height = -12
      ControlLabel.Font.Name = 'Pretendard Variable'
      ControlLabel.Font.Style = []
      ControlLabel.ParentFont = False
      Align = alLeft
      Alignment = taCenter
      DynProps = <>
      EditButtons = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      Kind = dtkDateEh
      ParentFont = False
      TabOrder = 0
      Visible = True
      ExplicitHeight = 26
    end
    object btnCancelReceipt: TBitBtn
      AlignWithMargins = True
      Left = 1575
      Top = 5
      Width = 120
      Height = 36
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = #44144#47000' '#52712#49548' '#46321#47197
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      WordWrap = True
      OnClick = btnCancelReceiptClick
    end
  end
  object dsrReceiptList: TDataSource
    DataSet = BPDM.QRReceiptList
    Left = 53
    Top = 150
  end
  object dsrSaleItemList: TDataSource
    DataSet = BPDM.QRSaleItemList
    Left = 37
    Top = 614
  end
  object dsrCouponList: TDataSource
    Left = 37
    Top = 846
  end
  object dsrPaymentList: TDataSource
    DataSet = BPDM.QRPaymentList
    Left = 661
    Top = 846
  end
end
