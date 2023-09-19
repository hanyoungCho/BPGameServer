object BPProdListViewForm: TBPProdListViewForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 600
  ClientWidth = 800
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
    Width = 800
    Height = 38
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = #50836#44552' '#49345#54408' '#51312#54924
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
      Left = 765
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
  object panProdAmtType: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 43
    Width = 790
    Height = 53
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object btnFeeDivBasic: TSpeedButton
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
      Caption = #44592#48376
      Images = BPDM.imlIcon32
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = OnFeeDivButtonClick
      ExplicitHeight = 54
    end
    object btnFeeDivClub: TSpeedButton
      Tag = 4
      AlignWithMargins = True
      Left = 345
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
      Caption = #53364#47101
      Images = BPDM.imlIcon32
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = OnFeeDivButtonClick
      ExplicitHeight = 54
    end
    object btnFeeDivStudent: TSpeedButton
      Tag = 3
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
      Caption = #54617#49373
      Images = BPDM.imlIcon32
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = OnFeeDivButtonClick
      ExplicitHeight = 54
    end
    object btnFeeDivMember: TSpeedButton
      Tag = 2
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
      Caption = #54924#50896
      Images = BPDM.imlIcon32
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = OnFeeDivButtonClick
      ExplicitHeight = 54
    end
    object shpCategorySeparator: TShape
      Left = 0
      Top = 50
      Width = 790
      Height = 3
      Align = alBottom
      Brush.Color = clHighlight
      Pen.Color = clHighlight
      ExplicitTop = 52
      ExplicitWidth = 1010
    end
  end
  object panFooter: TPanel
    Left = 0
    Top = 540
    Width = 800
    Height = 60
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Pretendard Variable'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object btnOK: TBitBtn
      Left = 247
      Top = 3
      Width = 150
      Height = 50
      Caption = #49345#54408' '#49440#53469#13#10'(Enter)'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 59
      ImageName = 'done_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TBitBtn
      Left = 403
      Top = 3
      Width = 150
      Height = 50
      Caption = #52712#49548
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Pretendard Variable'
      Font.Style = []
      ImageIndex = 49
      ImageName = 'cancel_32px'
      Images = BPDM.imlIcon32
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object G1: TcxGrid
    AlignWithMargins = True
    Left = 5
    Top = 101
    Width = 790
    Height = 434
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
    TabOrder = 3
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = False
    LookAndFeel.ScrollbarMode = sbmTouch
    LookAndFeel.ScrollMode = scmSmooth
    object V1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      OnCustomDrawCell = OnGridDBBandedTableViewCustomDrawCell
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
      OptionsView.ScrollBars = ssVertical
      OptionsView.ColumnAutoWidth = True
      OptionsView.GridLines = glVertical
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection
      Styles.Selection = BPDM.StyleSelection
      Bands = <
        item
          Caption = #44592#48376' '#50836#44552#51228
        end>
      object V1today_yn: TcxGridDBBandedColumn
        DataBinding.FieldName = 'today_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyph.SourceDPI = 96
        HeaderGlyph.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000041744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E53657453796D626F6C73333B436F6E646974696F6E616C46
          6F726D617474696E673B9DC5ED720000025449444154785EAD935D6C4B6118C7
          DF2A1BFD38DA4E6DB122D5B5DBAC92CA1CC4B0656CA9CE6ABE3A22662C9DB656
          5F4985359D91655DCC47EDA327CA120417222415DA1925F4424AB6650BDD8A0B
          71C1848CC415B3C7FB9EB4F45CB8907993DFB938CFF3FFE579DEE445003021D8
          CF3F1C1E66322605C3C7FC11D8996C54C768D01EAF06D93A311D1A646D57234B
          7B16DADD96C586153902E10EB7F2AA95A9800D0E8581C81202B6F92BC4D097F1
          281A1D7F813EFF1C409FC6FAD0C71FCFD8B09A164BAA9A95FE5BCF1BA07F8401
          739B9104A7FD16D49E51E1F01037FC9D0D4FCA2DA0E455CDAAF0EDBE2608BF3D
          06CECB4B416F4B77E15A6AF21DF0E3BB4D21A14478CE02816CEBF1798FBB074F
          42E84D3D345D2F84129BFC12AE89493D21E097EFCF5C53E32907936BB69F5E27
          53113B46B4FE50A6FF66A411824307E0ECDD52D0D765448452FE0C124EBEC4A9
          D5A7CBA0F7C33908F47B60674BDE68F1AE9916833DC3D7756F2F04861DC0840C
          603CA878AFA40579E4F25659B123499052B05DEA719C5F043DAF9C303872031A
          2E1AC1D76D879E980BBAC26B61E391B9633945227D7C32DE4A731A47C0C38868
          93A4639F570757222678FAAE13825127F89EE8C17C6A3EE82AA813A4878443AF
          5BD0B26A294780E23B51B891B178B4C03C2A01EFC3D5E0BAB618E8CAE9BDB826
          273D0F626E148C36227A9B842B58827FC425126D99D857D39A0DAD779643716D
          FAB759DAD41564CDFBC36E14787914F9070EA3FC4A8A2BC8DF42111212596EA9
          F04291350DD48582FAC4E80B378B114147D824E60AB8203E868A8F2D62A57F39
          FFE5354E885F4F2C8B1CABF609A90000000049454E44AE426082}
        HeaderGlyphAlignmentHorz = taCenter
        Width = 26
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
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
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V1prod_detail_div_nm: TcxGridDBBandedColumn
        Caption = #49345#54408' '#44396#48516
        DataBinding.FieldName = 'prod_detail_div_nm'
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
        Caption = #49345#54408' '#44552#50529'('#50896')'
        DataBinding.FieldName = 'prod_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.DisplayFormat = ',0.;-,0.'
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V1apply_start_tm: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#51089' '#49884#44033
        DataBinding.FieldName = 'apply_start_tm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V1apply_end_tm: TcxGridDBBandedColumn
        Caption = #51060#50857' '#51333#47308' '#49884#44033
        DataBinding.FieldName = 'apply_end_tm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V1use_game_cnt: TcxGridDBBandedColumn
        Caption = #51060#50857' '#44172#51076' '#49688
        DataBinding.FieldName = 'use_game_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 80
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object V1use_game_min: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#44036
        DataBinding.FieldName = 'use_game_min'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
    end
    object V2: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      OnCustomDrawCell = OnGridDBBandedTableViewCustomDrawCell
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
      OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.ScrollBars = ssVertical
      OptionsView.ColumnAutoWidth = True
      OptionsView.GridLines = glVertical
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Styles.UseOddEvenStyles = bTrue
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection
      Styles.Selection = BPDM.StyleSelection
      Bands = <
        item
          Caption = #54924#50896' '#50836#44552#51228
        end>
      object V2today_yn: TcxGridDBBandedColumn
        DataBinding.FieldName = 'today_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyph.SourceDPI = 96
        HeaderGlyph.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000041744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E53657453796D626F6C73333B436F6E646974696F6E616C46
          6F726D617474696E673B9DC5ED720000025449444154785EAD935D6C4B6118C7
          DF2A1BFD38DA4E6DB122D5B5DBAC92CA1CC4B0656CA9CE6ABE3A22662C9DB656
          5F4985359D91655DCC47EDA327CA120417222415DA1925F4424AB6650BDD8A0B
          71C1848CC415B3C7FB9EB4F45CB8907993DFB938CFF3FFE579DEE445003021D8
          CF3F1C1E66322605C3C7FC11D8996C54C768D01EAF06D93A311D1A646D57234B
          7B16DADD96C586153902E10EB7F2AA95A9800D0E8581C81202B6F92BC4D097F1
          281A1D7F813EFF1C409FC6FAD0C71FCFD8B09A164BAA9A95FE5BCF1BA07F8401
          739B9104A7FD16D49E51E1F01037FC9D0D4FCA2DA0E455CDAAF0EDBE2608BF3D
          06CECB4B416F4B77E15A6AF21DF0E3BB4D21A14478CE02816CEBF1798FBB074F
          42E84D3D345D2F84129BFC12AE89493D21E097EFCF5C53E32907936BB69F5E27
          53113B46B4FE50A6FF66A411824307E0ECDD52D0D765448452FE0C124EBEC4A9
          D5A7CBA0F7C33908F47B60674BDE68F1AE9916833DC3D7756F2F04861DC0840C
          603CA878AFA40579E4F25659B123499052B05DEA719C5F043DAF9C303872031A
          2E1AC1D76D879E980BBAC26B61E391B9633945227D7C32DE4A731A47C0C38868
          93A4639F570757222678FAAE13825127F89EE8C17C6A3EE82AA813A4878443AF
          5BD0B26A294780E23B51B891B178B4C03C2A01EFC3D5E0BAB618E8CAE9BDB826
          273D0F626E148C36227A9B842B58827FC425126D99D857D39A0DAD779643716D
          FAB759DAD41564CDFBC36E14787914F9070EA3FC4A8A2BC8DF42111212596EA9
          F04291350DD48582FAC4E80B378B114147D824E60AB8203E868A8F2D62A57F39
          FFE5354E885F4F2C8B1CABF609A90000000049454E44AE426082}
        HeaderGlyphAlignmentHorz = taCenter
        Width = 26
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object V2prod_nm: TcxGridDBBandedColumn
        Caption = #49345#54408#47749
        DataBinding.FieldName = 'prod_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 150
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V2prod_detail_div_nm: TcxGridDBBandedColumn
        Caption = #49345#54408' '#44396#48516
        DataBinding.FieldName = 'prod_detail_div_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 150
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V2prod_amt: TcxGridDBBandedColumn
        Caption = #49345#54408' '#44552#50529'('#50896')'
        DataBinding.FieldName = 'prod_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.DisplayFormat = ',0.;-,0.'
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V2apply_start_time: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#51089' '#49884#44033
        DataBinding.FieldName = 'apply_start_time'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V2apply_end_time: TcxGridDBBandedColumn
        Caption = #51060#50857' '#51333#47308' '#49884#44033
        DataBinding.FieldName = 'apply_end_time'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V2use_game_cnt: TcxGridDBBandedColumn
        Caption = #51060#50857' '#44172#51076' '#49688
        DataBinding.FieldName = 'use_game_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 80
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object V2use_game_min: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#44036
        DataBinding.FieldName = 'use_game_min'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
    end
    object V3: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      OnCustomDrawCell = OnGridDBBandedTableViewCustomDrawCell
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
      OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.ScrollBars = ssVertical
      OptionsView.ColumnAutoWidth = True
      OptionsView.GridLines = glVertical
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Styles.UseOddEvenStyles = bTrue
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection
      Styles.Selection = BPDM.StyleSelection
      Bands = <
        item
          Caption = #54617#49373' '#50836#44552#51228
        end>
      object V3today_yn: TcxGridDBBandedColumn
        DataBinding.FieldName = 'today_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyph.SourceDPI = 96
        HeaderGlyph.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000041744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E53657453796D626F6C73333B436F6E646974696F6E616C46
          6F726D617474696E673B9DC5ED720000025449444154785EAD935D6C4B6118C7
          DF2A1BFD38DA4E6DB122D5B5DBAC92CA1CC4B0656CA9CE6ABE3A22662C9DB656
          5F4985359D91655DCC47EDA327CA120417222415DA1925F4424AB6650BDD8A0B
          71C1848CC415B3C7FB9EB4F45CB8907993DFB938CFF3FFE579DEE445003021D8
          CF3F1C1E66322605C3C7FC11D8996C54C768D01EAF06D93A311D1A646D57234B
          7B16DADD96C586153902E10EB7F2AA95A9800D0E8581C81202B6F92BC4D097F1
          281A1D7F813EFF1C409FC6FAD0C71FCFD8B09A164BAA9A95FE5BCF1BA07F8401
          739B9104A7FD16D49E51E1F01037FC9D0D4FCA2DA0E455CDAAF0EDBE2608BF3D
          06CECB4B416F4B77E15A6AF21DF0E3BB4D21A14478CE02816CEBF1798FBB074F
          42E84D3D345D2F84129BFC12AE89493D21E097EFCF5C53E32907936BB69F5E27
          53113B46B4FE50A6FF66A411824307E0ECDD52D0D765448452FE0C124EBEC4A9
          D5A7CBA0F7C33908F47B60674BDE68F1AE9916833DC3D7756F2F04861DC0840C
          603CA878AFA40579E4F25659B123499052B05DEA719C5F043DAF9C303872031A
          2E1AC1D76D879E980BBAC26B61E391B9633945227D7C32DE4A731A47C0C38868
          93A4639F570757222678FAAE13825127F89EE8C17C6A3EE82AA813A4878443AF
          5BD0B26A294780E23B51B891B178B4C03C2A01EFC3D5E0BAB618E8CAE9BDB826
          273D0F626E148C36227A9B842B58827FC425126D99D857D39A0DAD779643716D
          FAB759DAD41564CDFBC36E14787914F9070EA3FC4A8A2BC8DF42111212596EA9
          F04291350DD48582FAC4E80B378B114147D824E60AB8203E868A8F2D62A57F39
          FFE5354E885F4F2C8B1CABF609A90000000049454E44AE426082}
        HeaderGlyphAlignmentHorz = taCenter
        Width = 26
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object V3prod_nm: TcxGridDBBandedColumn
        Caption = #49345#54408#47749
        DataBinding.FieldName = 'prod_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 150
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V3prod_detail_div_nm: TcxGridDBBandedColumn
        Caption = #49345#54408' '#44396#48516
        DataBinding.FieldName = 'prod_detail_div_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 150
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V3prod_amt: TcxGridDBBandedColumn
        Caption = #49345#54408' '#44552#50529'('#50896')'
        DataBinding.FieldName = 'prod_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.DisplayFormat = ',0.;-,0.'
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V3apply_start_time: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#51089' '#49884#44033
        DataBinding.FieldName = 'apply_start_time'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V3apply_end_time: TcxGridDBBandedColumn
        Caption = #51060#50857' '#51333#47308' '#49884#44033
        DataBinding.FieldName = 'apply_end_time'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V3use_game_cnt: TcxGridDBBandedColumn
        Caption = #51060#50857' '#44172#51076' '#49688
        DataBinding.FieldName = 'use_game_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 80
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object V3use_game_min: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#44036
        DataBinding.FieldName = 'use_game_min'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
    end
    object V4: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      OnCustomDrawCell = OnGridDBBandedTableViewCustomDrawCell
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
      OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.ScrollBars = ssVertical
      OptionsView.ColumnAutoWidth = True
      OptionsView.GridLines = glVertical
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Styles.UseOddEvenStyles = bTrue
      Styles.Header = BPDM.StyleHeader1
      Styles.Inactive = BPDM.StyleSelection
      Styles.Selection = BPDM.StyleSelection
      Bands = <
        item
          Caption = #53364#47101' '#50836#44552#51228
        end>
      object V4today_yn: TcxGridDBBandedColumn
        DataBinding.FieldName = 'today_yn'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyph.SourceDPI = 96
        HeaderGlyph.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000041744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E53657453796D626F6C73333B436F6E646974696F6E616C46
          6F726D617474696E673B9DC5ED720000025449444154785EAD935D6C4B6118C7
          DF2A1BFD38DA4E6DB122D5B5DBAC92CA1CC4B0656CA9CE6ABE3A22662C9DB656
          5F4985359D91655DCC47EDA327CA120417222415DA1925F4424AB6650BDD8A0B
          71C1848CC415B3C7FB9EB4F45CB8907993DFB938CFF3FFE579DEE445003021D8
          CF3F1C1E66322605C3C7FC11D8996C54C768D01EAF06D93A311D1A646D57234B
          7B16DADD96C586153902E10EB7F2AA95A9800D0E8581C81202B6F92BC4D097F1
          281A1D7F813EFF1C409FC6FAD0C71FCFD8B09A164BAA9A95FE5BCF1BA07F8401
          739B9104A7FD16D49E51E1F01037FC9D0D4FCA2DA0E455CDAAF0EDBE2608BF3D
          06CECB4B416F4B77E15A6AF21DF0E3BB4D21A14478CE02816CEBF1798FBB074F
          42E84D3D345D2F84129BFC12AE89493D21E097EFCF5C53E32907936BB69F5E27
          53113B46B4FE50A6FF66A411824307E0ECDD52D0D765448452FE0C124EBEC4A9
          D5A7CBA0F7C33908F47B60674BDE68F1AE9916833DC3D7756F2F04861DC0840C
          603CA878AFA40579E4F25659B123499052B05DEA719C5F043DAF9C303872031A
          2E1AC1D76D879E980BBAC26B61E391B9633945227D7C32DE4A731A47C0C38868
          93A4639F570757222678FAAE13825127F89EE8C17C6A3EE82AA813A4878443AF
          5BD0B26A294780E23B51B891B178B4C03C2A01EFC3D5E0BAB618E8CAE9BDB826
          273D0F626E148C36227A9B842B58827FC425126D99D857D39A0DAD779643716D
          FAB759DAD41564CDFBC36E14787914F9070EA3FC4A8A2BC8DF42111212596EA9
          F04291350DD48582FAC4E80B378B114147D824E60AB8203E868A8F2D62A57F39
          FFE5354E885F4F2C8B1CABF609A90000000049454E44AE426082}
        HeaderGlyphAlignmentHorz = taCenter
        Width = 26
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
        IsCaptionAssigned = True
      end
      object V4prod_nm: TcxGridDBBandedColumn
        Caption = #49345#54408#47749
        DataBinding.FieldName = 'prod_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 150
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object V4prod_detail_div_nm: TcxGridDBBandedColumn
        Caption = #49345#54408' '#44396#48516
        DataBinding.FieldName = 'prod_detail_div_nm'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 150
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object V4prod_amt: TcxGridDBBandedColumn
        Caption = #49345#54408' '#44552#50529'('#50896')'
        DataBinding.FieldName = 'prod_amt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.DisplayFormat = ',0.;-,0.'
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object V4apply_start_time: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#51089' '#49884#44033
        DataBinding.FieldName = 'apply_start_time'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object V4apply_end_time: TcxGridDBBandedColumn
        Caption = #51060#50857' '#51333#47308' '#49884#44033
        DataBinding.FieldName = 'apply_end_time'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object V4use_game_cnt: TcxGridDBBandedColumn
        Caption = #51060#50857' '#44172#51076' '#49688
        DataBinding.FieldName = 'use_game_cnt'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 80
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object V4use_game_min: TcxGridDBBandedColumn
        Caption = #51060#50857' '#49884#44036
        DataBinding.FieldName = 'use_game_min'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
    end
    object L1: TcxGridLevel
      GridView = V1
    end
  end
  object DataSource: TDataSource
    Left = 153
    Top = 262
  end
end
