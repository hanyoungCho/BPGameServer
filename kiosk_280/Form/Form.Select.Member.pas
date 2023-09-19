unit Form.Select.Member;

interface

uses
  uStruct, Uni,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.TMSBaseControl,
  FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData, FMX.TMSCustomGrid,
  FMX.TMSGrid;

type
  TSelectMember = class(TForm)
    Layout: TLayout;
    Edit1: TEdit;
    Text1: TText;
    Text2: TText;
    Edit2: TEdit;
    Rectangle1: TRectangle;
    Text3: TText;
    Grid: TTMSFMXGrid;
    procedure Text3Click(Sender: TObject);
    procedure GridGetCellLayout(Sender: TObject; ACol, ARow: Integer;
      ALayout: TTMSFMXGridCellLayout; ACellState: TCellState);
  private
    { Private declarations }
    FCardNo: string;
  public
    { Public declarations }

    property CardNo: string read FCardNo write FCardNo;
  end;

var
  SelectMember: TSelectMember;

implementation

uses
  uGlobal;

{$R *.fmx}

procedure TSelectMember.GridGetCellLayout(Sender: TObject; ACol, ARow: Integer;
  ALayout: TTMSFMXGridCellLayout; ACellState: TCellState);
begin
  ALayout.Font.Size := 22;
  ALayout.TextAlign := TTextAlign.Center;
end;

procedure TSelectMember.Text3Click(Sender: TObject);
var
  Index: Integer;
  AQuery: TUniQuery;
begin//
  try
      AQuery := TUniQuery.Create(nil);

      AQuery := Global.Database.GetMemberProductList(Edit1.Text, Edit2.Text, FormatDateTime('yyyy-mm-dd', now));
      Grid.RowCount := AQuery.RecordCount + 1;
      Grid.BeginUpdate;
      Grid.Cells[0, 0] := '상품명';
      Grid.Cells[1, 0] := '시작일';
      Grid.Cells[2, 0] := '종료일';
      Grid.Cells[3, 0] := '쿠폰사용수';
      Grid.Cells[4, 0] := '최대사용수';
      if AQuery.RecordCount <> 0 then
      begin
          for Index := 0 to AQuery.RecordCount - 1 do
          begin
            Grid.Cells[0, Index + 1] := AQuery.FieldByName('REGGRPNAME').AsString;
            Grid.Cells[1, Index + 1] := AQuery.FieldByName('CUST_IN_START_DTE').AsString;
            Grid.Cells[2, Index + 1] := AQuery.FieldByName('CUST_IN_END_DTE').AsString;
            Grid.Cells[3, Index + 1] := AQuery.FieldByName('CUST_COK_QTY').AsString;
            Grid.Cells[4, Index + 1] := AQuery.FieldByName('CUST_COK_BUY').AsString;

            AQuery.Next;
          end;
      end;
      Grid.EndUpdate;
  finally
    AQuery.Free;
  end;
end;

end.
