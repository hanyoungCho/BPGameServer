unit uTeeboxThread;

interface

uses
  System.Classes, System.SysUtils;

type
  TTeeboxThread = class(TThread)
  private
    Cnt: Integer;
    Cnt_1: Integer;
    FCheckTime: String;
    //FCloseSend: String;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property CheckTime: String read FCheckTime write FCheckTime;
  end;

implementation

uses
  uGlobal;

constructor TTeeboxThread.Create;
begin
  Cnt := 0;
  Cnt_1 := 5;
  FCheckTime := '';
  //FCloseSend := 'N';

  Global.Log.LogWrite('TTeeboxThread Create');

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TTeeboxThread.Destroy;
begin

  inherited;
end;

procedure TTeeboxThread.Execute;
var
  sLogMsg: String;
begin
  inherited;

  while not Terminated do
  begin
    try

      Synchronize(Global.TeeboxThreadTimeCheck);

      inc(Cnt_1);
      if Cnt_1 > 4 then
      begin
        //Ÿ���� ��������
        //Synchronize(Global.Teebox.TeeboxReserveChkAD);

        //Ÿ�� ��������
        //Synchronize(Global.Teebox.TeeboxStatusChkAD);

        Cnt_1 := 0;
      end;

      inc(Cnt);
      if Cnt > 15 then
      begin

        if Global.Config.Emergency = False then
        begin
          //Ÿ���� ����Ȯ�ο�-> ERP ����
          //Synchronize(Global.Teebox.SendADStatusToErp);
        end;

        //���� ����Ȯ��
        //Synchronize(Global.Teebox.TeeboxReserveNextChkAD);

        Cnt := 0;
      end;

      Sleep(1000);
    except
      on e: Exception do
      begin
        sLogMsg := 'TTeeboxThread Error : ' + e.Message;
        Global.Log.LogWrite(sLogMsg);
      end;
    end;
  end;

end;

end.
