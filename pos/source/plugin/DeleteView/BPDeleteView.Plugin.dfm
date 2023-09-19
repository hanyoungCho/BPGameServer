object BPDeleteViewForm: TBPDeleteViewForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 800
  ClientWidth = 1200
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Pretendard Variable'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 18
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 1200
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #49325#51228#54620' '#54032#47588' '#45236#50669' '#51312#54924
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
      Font.Charset = HANGEUL_CHARSET
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
      Left = 1165
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
  object G1: TcxGrid
    AlignWithMargins = True
    Left = 5
    Top = 101
    Width = 1190
    Height = 694
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
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
    object V1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      DataController.Summary.Options = [soSelectedRecords]
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
      OptionsView.GridLines = glVertical
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      OptionsView.FixedBandSeparatorColor = clWhite
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection
      Styles.Indicator = BPDM.StyleHeader1
      Styles.Selection = BPDM.StyleSelection
      Styles.BandHeader = BPDM.StyleHeader1
      Bands = <
        item
          Caption = #44592#48376' '#51221#48372
          FixedKind = fkLeft
        end
        item
          Caption = #51452#47928' '#45236#50669
        end>
      object V1receipt_no: TcxGridDBBandedColumn
        Caption = #50689#49688#51613#48264#54840
        DataBinding.FieldName = 'receipt_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 71
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object V1assign_lane_no: TcxGridDBBandedColumn
        Caption = #47112#51064
        DataBinding.FieldName = 'assign_lane_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 31
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V1assign_no: TcxGridDBBandedColumn
        Caption = #48176#51221#48264#54840
        DataBinding.FieldName = 'assign_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V1bowler_id: TcxGridDBBandedColumn
        Caption = #48380#47084
        DataBinding.FieldName = 'bowler_id'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 34
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
        Width = 44
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V1prod_div: TcxGridDBBandedColumn
        Caption = #49345#54408#44396#48516
        DataBinding.FieldName = 'prod_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 58
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object V1prod_detail_div: TcxGridDBBandedColumn
        Caption = #49345#49464#44396#48516
        DataBinding.FieldName = 'prod_detail_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V1prod_cd: TcxGridDBBandedColumn
        Caption = #49345#54408#53076#46300
        DataBinding.FieldName = 'prod_cd'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V1prod_amt: TcxGridDBBandedColumn
        Caption = #49345#54408#44032#44201
        DataBinding.FieldName = 'prod_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V1order_qty: TcxGridDBBandedColumn
        Caption = #51452#47928#49688#47049
        DataBinding.FieldName = 'order_qty'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V1payment_yn: TcxGridDBBandedColumn
        Caption = #44208#51228#50668#48512
        DataBinding.FieldName = 'payment_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V1dc_amt: TcxGridDBBandedColumn
        Caption = #54624#51064#44552#50529
        DataBinding.FieldName = 'dc_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object V1use_point: TcxGridDBBandedColumn
        Caption = #54252#51064#53944#49324#50857
        DataBinding.FieldName = 'use_point'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object V1service_yn: TcxGridDBBandedColumn
        Caption = #49436#48708#49828
        DataBinding.FieldName = 'service_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 44
        Position.BandIndex = 1
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object V1member_no: TcxGridDBBandedColumn
        Caption = #54924#50896#48264#54840
        DataBinding.FieldName = 'member_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object V1member_nm: TcxGridDBBandedColumn
        Caption = #54924#50896#47749
        DataBinding.FieldName = 'member_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 44
        Position.BandIndex = 1
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object V1keep_amt: TcxGridDBBandedColumn
        Caption = #48372#51613#44552
        DataBinding.FieldName = 'keep_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 44
        Position.BandIndex = 1
        Position.ColIndex = 11
        Position.RowIndex = 0
      end
      object V1locker_no: TcxGridDBBandedColumn
        Caption = #46972#52964#48264#54840
        DataBinding.FieldName = 'locker_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 12
        Position.RowIndex = 0
      end
      object V1locker_nm: TcxGridDBBandedColumn
        Caption = #46972#52964#47749
        DataBinding.FieldName = 'locker_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 44
        Position.BandIndex = 1
        Position.ColIndex = 13
        Position.RowIndex = 0
      end
      object V1purchase_month: TcxGridDBBandedColumn
        Caption = #51060#50857#50900#49688
        DataBinding.FieldName = 'purchase_month'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 14
        Position.RowIndex = 0
      end
      object V1start_dt: TcxGridDBBandedColumn
        Caption = #51060#50857#49884#51089#51068
        DataBinding.FieldName = 'start_dt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 15
        Position.RowIndex = 0
      end
      object V1user_id: TcxGridDBBandedColumn
        Caption = #45812#45817#51088'ID'
        DataBinding.FieldName = 'user_id'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 58
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V1update_dttm: TcxGridDBBandedColumn
        Caption = #52376#47532#49884#44033
        DataBinding.FieldName = 'update_dttm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
    end
    object V2: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = DataSource
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
      OptionsView.GridLines = glVertical
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      OptionsView.FixedBandSeparatorColor = clWhite
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection
      Styles.Indicator = BPDM.StyleHeader1
      Styles.Selection = BPDM.StyleSelection
      Styles.BandHeader = BPDM.StyleHeader1
      Bands = <
        item
          Caption = #44592#48376' '#51221#48372
          FixedKind = fkLeft
        end
        item
          Caption = #49345#49464' '#45236#50669
        end>
      object V2receipt_no: TcxGridDBBandedColumn
        Caption = #50689#49688#51613#48264#54840
        DataBinding.FieldName = 'receipt_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 71
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object V2assign_lane_no: TcxGridDBBandedColumn
        Caption = #47112#51064
        DataBinding.FieldName = 'assign_lane_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 31
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V2pay_method: TcxGridDBBandedColumn
        Caption = #44208#51228#49688#45800
        DataBinding.FieldName = 'pay_method'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object V2approval_yn: TcxGridDBBandedColumn
        Caption = #49849#51064#50668#48512
        DataBinding.FieldName = 'approval_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V2approve_amt: TcxGridDBBandedColumn
        Caption = #49849#51064#44552#50529
        DataBinding.FieldName = 'approve_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V2manual_input_yn: TcxGridDBBandedColumn
        Caption = #51076#51032#46321#47197
        DataBinding.FieldName = 'manual_input_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 58
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V2org_approve_no: TcxGridDBBandedColumn
        Caption = #50896#49849#51064#48264#54840
        DataBinding.FieldName = 'org_approve_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V2van_cd: TcxGridDBBandedColumn
        Caption = 'VAN'
        DataBinding.FieldName = 'van_cd'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 36
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V2tid: TcxGridDBBandedColumn
        Caption = 'TID'
        DataBinding.FieldName = 'tid'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 28
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V2approve_no: TcxGridDBBandedColumn
        Caption = #49849#51064#48264#54840
        DataBinding.FieldName = 'approve_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V2org_approve_dt: TcxGridDBBandedColumn
        Caption = #50896#49849#51064#51068#51088
        DataBinding.FieldName = 'org_approve_dt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object V2vat: TcxGridDBBandedColumn
        Caption = #48512#44032#49464
        DataBinding.FieldName = 'vat'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 44
        Position.BandIndex = 1
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object V2service_amt: TcxGridDBBandedColumn
        Caption = #49436#48708#49828#44552#50529
        DataBinding.FieldName = 'service_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object V2inst_month: TcxGridDBBandedColumn
        Caption = #54624#48512#44060#50900
        DataBinding.FieldName = 'inst_month'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object V2cash_entity_div: TcxGridDBBandedColumn
        Caption = #48156#44553#51452#52404
        DataBinding.FieldName = 'cash_entity_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object V2card_no: TcxGridDBBandedColumn
        Caption = #52852#46300'/'#49885#48324#48264#54840
        DataBinding.FieldName = 'card_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 88
        Position.BandIndex = 1
        Position.ColIndex = 11
        Position.RowIndex = 0
      end
      object V2trade_no: TcxGridDBBandedColumn
        Caption = #44144#47000#48264#54840
        DataBinding.FieldName = 'trade_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 12
        Position.RowIndex = 0
      end
      object V2trade_dt: TcxGridDBBandedColumn
        Caption = #44144#47000#51068#51088
        DataBinding.FieldName = 'trade_dt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 13
        Position.RowIndex = 0
      end
      object V2issuer_cd: TcxGridDBBandedColumn
        Caption = #48156#44553#49324#53076#46300
        DataBinding.FieldName = 'issuer_cd'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 14
        Position.RowIndex = 0
      end
      object V2issuer_nm: TcxGridDBBandedColumn
        Caption = #48156#44553#49324#47749
        DataBinding.FieldName = 'issuer_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 15
        Position.RowIndex = 0
      end
      object V2buyer_div: TcxGridDBBandedColumn
        Caption = #47588#51077#49324#44396#48516
        DataBinding.FieldName = 'buyer_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 16
        Position.RowIndex = 0
      end
      object V2buyer_cd: TcxGridDBBandedColumn
        Caption = #47588#51077#49324#53076#46300
        DataBinding.FieldName = 'buyer_cd'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 17
        Position.RowIndex = 0
      end
      object V2buyer_nm: TcxGridDBBandedColumn
        Caption = #47588#51077#49324#47749
        DataBinding.FieldName = 'buyer_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 18
        Position.RowIndex = 0
      end
      object V2payment_memo: TcxGridDBBandedColumn
        Caption = #44208#51228#47700#47784
        DataBinding.FieldName = 'payment_memo'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 19
        Position.RowIndex = 0
      end
      object V2user_id: TcxGridDBBandedColumn
        Caption = #45812#45817#51088'ID'
        DataBinding.FieldName = 'user_id'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 58
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V2update_dttm: TcxGridDBBandedColumn
        Caption = #52376#47532#49884#44033
        DataBinding.FieldName = 'update_dttm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
    end
    object V3: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = DataSource
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
      OptionsView.GridLines = glVertical
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      OptionsView.FixedBandSeparatorColor = clWhite
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection
      Styles.Indicator = BPDM.StyleHeader1
      Styles.Selection = BPDM.StyleSelection
      Styles.BandHeader = BPDM.StyleHeader1
      Bands = <
        item
          Caption = #44592#48376' '#51221#48372
          FixedKind = fkLeft
        end
        item
          Caption = #49345#49464' '#45236#50669
        end>
      object V3receipt_no: TcxGridDBBandedColumn
        Caption = #50689#49688#51613#48264#54840
        DataBinding.FieldName = 'receipt_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 71
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object V3assign_lane_no: TcxGridDBBandedColumn
        Caption = #47112#51064
        DataBinding.FieldName = 'assign_lane_no'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Options.CellMerging = True
        Width = 31
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V3coupon_seq: TcxGridDBBandedColumn
        Caption = #53216#54256#48264#54840
        DataBinding.FieldName = 'coupon_seq'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V3coupon_nm: TcxGridDBBandedColumn
        Caption = #53216#54256#47749
        DataBinding.FieldName = 'coupon_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 44
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V3user_id: TcxGridDBBandedColumn
        Caption = #45812#45817#51088'ID'
        DataBinding.FieldName = 'user_id'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 58
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V3update_dttm: TcxGridDBBandedColumn
        Caption = #52376#47532#49884#44033
        DataBinding.FieldName = 'update_dttm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V3qr_code: TcxGridDBBandedColumn
        Caption = 'QR'#53076#46300
        DataBinding.FieldName = 'qr_code'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 52
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object V3dc_div: TcxGridDBBandedColumn
        Caption = #54624#51064#44396#48516
        DataBinding.FieldName = 'dc_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V3dc_cnt: TcxGridDBBandedColumn
        Caption = #54624#51064#49688#47049
        DataBinding.FieldName = 'dc_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V3start_dt: TcxGridDBBandedColumn
        Caption = #49884#51089#51068#51088
        DataBinding.FieldName = 'start_dt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V3expire_dt: TcxGridDBBandedColumn
        Caption = #47564#47308#51068#51088
        DataBinding.FieldName = 'expire_dt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V3use_cnt: TcxGridDBBandedColumn
        Caption = #51060#50857#44148#49688
        DataBinding.FieldName = 'use_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V3used_cnt: TcxGridDBBandedColumn
        Caption = #51060#50857#50756#47308
        DataBinding.FieldName = 'used_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object V3dc_cond_div: TcxGridDBBandedColumn
        Caption = #54624#51064#51312#44148
        DataBinding.FieldName = 'dc_cond_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object V3prod_div: TcxGridDBBandedColumn
        Caption = #49345#54408#44396#48516
        DataBinding.FieldName = 'prod_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object V3prod_detail_div: TcxGridDBBandedColumn
        Caption = #49345#54408#49345#49464#44396#48516
        DataBinding.FieldName = 'prod_detail_div'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 83
        Position.BandIndex = 1
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object V3send_dt: TcxGridDBBandedColumn
        Caption = #48156#49569#51068#51088
        DataBinding.FieldName = 'send_dt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object V3use_yn: TcxGridDBBandedColumn
        Caption = #49324#50857#50668#48512
        DataBinding.FieldName = 'use_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 11
        Position.RowIndex = 0
      end
      object V3event_nm: TcxGridDBBandedColumn
        Caption = #51060#48292#53944#47749
        DataBinding.FieldName = 'event_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 12
        Position.RowIndex = 0
      end
      object V3event_url: TcxGridDBBandedColumn
        Caption = #51060#48292#53944' URL'
        DataBinding.FieldName = 'event_url'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 76
        Position.BandIndex = 1
        Position.ColIndex = 13
        Position.RowIndex = 0
      end
      object V3apply_amt: TcxGridDBBandedColumn
        Caption = #51201#50857#44552#50529
        DataBinding.FieldName = 'apply_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 57
        Position.BandIndex = 1
        Position.ColIndex = 14
        Position.RowIndex = 0
      end
      object V3memo: TcxGridDBBandedColumn
        Caption = #47700#47784
        DataBinding.FieldName = 'memo'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 31
        Position.BandIndex = 1
        Position.ColIndex = 15
        Position.RowIndex = 0
      end
    end
    object L1: TcxGridLevel
      GridView = V1
    end
  end
  object panProdAmtType: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 43
    Width = 1190
    Height = 53
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object btnSaleItemBackup: TSpeedButton
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      GroupIndex = 100
      Down = True
      Caption = #51452#47928' '#45236#50669
      Images = BPDM.imlIcon32
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = OnDataButtonClick
      ExplicitHeight = 54
    end
    object btnPaymentBackup: TSpeedButton
      Tag = 1
      AlignWithMargins = True
      Left = 115
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      GroupIndex = 100
      Caption = #44208#51228' '#45236#50669
      Images = BPDM.imlIcon32
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = OnDataButtonClick
      ExplicitHeight = 54
    end
    object shpCategorySeparator: TShape
      Left = 0
      Top = 50
      Width = 1190
      Height = 3
      Align = alBottom
      Brush.Color = clHighlight
      Pen.Color = clHighlight
      ExplicitTop = 52
      ExplicitWidth = 1010
    end
    object btnCouponBackup: TSpeedButton
      Tag = 2
      AlignWithMargins = True
      Left = 230
      Top = 0
      Width = 110
      Height = 50
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      GroupIndex = 100
      Caption = #53216#54256' '#49324#50857' '#45236#50669
      Images = BPDM.imlIcon32
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = OnDataButtonClick
      ExplicitLeft = 345
      ExplicitHeight = 54
    end
  end
  object DataSource: TDataSource
    AutoEdit = False
    DataSet = BackupDataSet
    Left = 193
    Top = 294
  end
  object BackupDataSet: TABSQuery
    CurrentVersion = '7.94 '
    DatabaseName = 'DBLocal'
    InMemory = False
    ReadOnly = True
    SQL.Strings = (
      'SELECT * FROM TBSaleItemBackup ORDER BY receipt_no, seq;')
    Left = 192
    Top = 232
  end
end
