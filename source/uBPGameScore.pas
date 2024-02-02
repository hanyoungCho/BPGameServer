unit uBPGameScore;

interface

uses
  { Native }
  System.SysUtils;

const
  C_MAX_FRAME  = 10;
  C_PIN_0      = '0';
  C_PIN_1      = '1';
  C_PIN_2      = '2';
  C_PIN_3      = '3';
  C_PIN_4      = '4';
  C_PIN_5      = '5';
  C_PIN_6      = '6';
  C_PIN_7      = '7';
  C_PIN_8      = '8';
  C_PIN_9      = '9';
  C_PIN_SPARE  = '/';
  C_PIN_STRIKE = 'X';
  C_PIN_GUTTER = '-';
  //LSC_PIN: array[0..12] of Char = (C_PIN_0, 'C_PIN_1, C_PIN_2, C_PIN_3, C_PIN_4, C_PIN_5, C_PIN_6, C_PIN_7, C_PIN_8, C_PIN_9, C_PIN_SPARE, CPS_STRIKE, C_PIN_GUTTER);
  //                                   0   1   2   3   4   5   6   7   8   9   /   X   -
  //PIN_TABLE: array[0..12] of Byte = (48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 47, 88, 45); //ASCII Order

type
  TFrameRec = record
    First: string;
    Second: string;
    Third: string;
    Score: Word;
  end;

  TBPGameScore = class
  private
    FFrames: TArray<TFrameRec>;

    function ComputeScore(const AFrameNo: ShortInt; var AResMsg: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Refresh; overload;
    procedure RefreshFrame(const AFrameNo: Shortint);

    property Frames: TArray<TFrameRec> read FFrames write FFrames;
  end;

implementation

uses
  { Project }
  uBPGlobal;

{ TBPGameScore }

constructor TBPGameScore.Create;
begin
  inherited Create;

  Clear;
end;

destructor TBPGameScore.Destroy;
begin

  inherited;
end;

procedure TBPGameScore.Clear;
begin
  SetLength(FFrames, C_MAX_FRAME);
  for var I := 0 to Pred(C_MAX_FRAME) do
  begin
     Frames[I].First := EmptyStr;
     Frames[I].Second := EmptyStr;
     Frames[I].Third := EmptyStr;
  end;
end;

procedure TBPGameScore.Refresh;
var
  sResMsg: string;
begin
  try
    for var I := 0 to Pred(C_MAX_FRAME) do
      if not ComputeScore(I, sResMsg) then
        raise Exception.Create(sResMsg);
  except
    on E: Exception do
      UpdateLog(sResMsg);
  end;
end;
procedure TBPGameScore.RefreshFrame(const AFrameNo: Shortint);
var
  sResMsg: string;
begin
  try
    if not ComputeScore(AFrameNo, sResMsg) then
      raise Exception.Create(sResMsg);
  except
    on E: Exception do
      UpdateLog(sResMsg);
  end;
end;

function TBPGameScore.ComputeScore(const AFrameNo: ShortInt; var AResMsg: string): Boolean;
  function EmptyFirstValues(const AEndIndex: Shortint): Boolean;
  begin
    Result := False;
    for var I := 0 to AEndIndex do
      if Frames[I].First.IsEmpty then
      begin
        Result := True;
        Break;
      end;
  end;
var
  nIndex: Shortint;
begin
  Result := False;
  AResMsg := '';
  try
    if not AFrameNo in [1..10] then
      raise Exception.Create('유효하지 않은 프레임 번호');

    nIndex := Pred(AFrameNo);
    Frames[nIndex].Score := 0;
    if EmptyFirstValues(nIndex) then
    begin
      AResMsg := 'Record Error';
      Exit(False);
    end;

    case nIndex of
      0..7: //1번 ~ 8번 프레임
      begin
        if (Frames[nIndex].First = C_PIN_STRIKE) then
        begin
          if (Frames[nIndex + 1].First = C_PIN_STRIKE) and
             (Frames[nIndex + 2].First = C_PIN_STRIKE) then
            Frames[nIndex].Score := 30
          else
          begin
            if (Frames[nIndex + 1].First = C_PIN_STRIKE) then
              Frames[nIndex].Score := 20 + StrToInt(Frames[nIndex + 2].First)
            else
            begin
              if (Frames[nIndex + 1].Second = C_PIN_SPARE) then
                Frames[nIndex].Score := 20
              else
                Frames[nIndex].Score := 10 + StrToInt(Frames[nIndex + 1].First) + StrToInt(Frames[nIndex + 1].Second);
            end;
          end;
        end
        else
        begin
          if (Frames[nIndex].Second = C_PIN_SPARE) and
             (Frames[nIndex + 1].First = C_PIN_STRIKE) then
            Frames[nIndex].Score := 20
          else
          begin
            if (Frames[nIndex].Second = C_PIN_SPARE) then
              Frames[nIndex].Score := 10 + StrToInt(Frames[nIndex + 1].First)
            else
            begin
              if Frames[nIndex].Second.IsEmpty or
                 (StrToInt(Frames[nIndex].First) + StrToInt(Frames[nIndex].Second) > 9) then
              else
                Frames[nIndex].Score := StrToInt(Frames[nIndex].First) + StrToInt(Frames[nIndex].Second);
            end
          end;
        end;

        if (nIndex > 0) then
          Frames[nIndex].Score := Frames[nIndex].Score + Frames[nIndex - 1].Score; //이전 프레임 점수를 더함
      end;

      8: //9번 프레임
      begin
        if (Frames[8].First = C_PIN_STRIKE) then
        begin
          if (Frames[9].First = C_PIN_STRIKE) and
             (Frames[9].Second = C_PIN_STRIKE) then
            Frames[nIndex].Score := 30
          else
          begin
            if (Frames[9].First = C_PIN_STRIKE) then
              Frames[nIndex].Score := 20 + StrToInt(Frames[9].Second)
            else
            begin
              if (Frames[9].Second = C_PIN_SPARE) then
                Frames[nIndex].Score := 20
              else
                Frames[nIndex].Score := 10 + StrToInt(Frames[9].First) + StrToInt(Frames[9].Second);
            end;
          end;
        end
        else
        begin
          if (Frames[8].Second = C_PIN_SPARE) and (Frames[9].First = C_PIN_STRIKE) then
            Frames[nIndex].Score := 20
          else
          begin
            if (Frames[8].Second = C_PIN_SPARE) then
              Frames[nIndex].Score := 10 + StrToInt(Frames[9].First)
            else
            begin
              if Frames[8].Second.IsEmpty or
                 (StrToInt(Frames[8].First) + StrToInt(Frames[8].Second) > 9) then
              else
                Frames[nIndex].Score := StrToInt(Frames[8].First) + StrToInt(Frames[8].Second);
            end
          end;
        end;
        Frames[nIndex].Score := Frames[nIndex].Score + Frames[7].Score; //이전 프레임 점수를 더함
      end;

      9: //10번 프레임
      begin
        if (Frames[9].First = C_PIN_STRIKE) then
        begin
          if (Frames[9].Second = C_PIN_STRIKE) and
             (Frames[9].Third = C_PIN_STRIKE) then
            Frames[nIndex].Score := 30
          else
          begin
            if (Frames[9].Second = C_PIN_STRIKE) then
              Frames[nIndex].Score := 20 + StrToInt(Frames[9].Third)
            else
            begin
              if (Frames[9].Third = C_PIN_SPARE) then
                Frames[nIndex].Score := 20
              else
              begin
                if (StrToInt(Frames[9].Third) > (9 - StrToInt(Frames[9].Second))) then
                else
                  Frames[nIndex].Score := 10 + StrToInt(Frames[9].Second) + StrToInt(Frames[9].Third);
              end;
            end;
          end;
        end
        else
        begin
          if (Frames[9].Second = C_PIN_SPARE) and
             (Frames[9].Third = C_PIN_STRIKE) then
            Frames[nIndex].Score := 20
          else
          begin
            if (Frames[9].Second = C_PIN_SPARE) then
              Frames[nIndex].Score := 10 + StrToInt(Frames[9].Third)
            else
            begin
              if Frames[9].Second.IsEmpty or
                 (StrToInt(Frames[9].First) + StrToInt(Frames[9].Second) > 9) then
              else
                Frames[nIndex].Score := StrToInt(Frames[9].First) + StrToInt(Frames[9].Second);
            end
          end;
        end;
        Frames[nIndex].Score := Frames[nIndex].Score + Frames[8].Score; //이전 프레임 점수를 더함
      end;
    end;
    Result := True;
  except
    on E: Exception do
      AResMsg := Format('ComputeScore(FrameNo=%d).Exception : %s', [AFrameNo, E.Message]);
  end;
end;

end.
