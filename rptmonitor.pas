unit rptmonitor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, UCrpe32, StdCtrls;

type
  TForm1 = class(TForm)
    lbStatus: TLabel;
    Crpe1: TCrpe;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Crpe1PrintEnded(Sender: TObject);
  private
    { Private declarations }
    function detectFile(dir : string) : integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

function TForm1.detectFile;
begin
  if fileexists(dir+'\r_rcvfil.dbf') then
    result := 1
  else
  if fileexists(dir+'\r_dtlfil.dbf') and
     fileexists(dir+'\h_dtlfil.dbf') then
    result := 2
  else
  if fileexists(dir+'\r_cmtfil.dbf') and
     fileexists(dir+'\h_cmtfil.dbf') then
    result := 3
  else
    result := -1;
end;

{$R *.DFM}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  case Detectfile('rptdat') of
    1 :
      begin
        Timer1.Enabled := false;
        lbStatus.Caption := 'Printing report #1';
        crpe1.ReportName := 'report\สรุปรับ file.rpt';
        crpe1.Execute;
      end;
    2 :
      begin
        Timer1.Enabled := false;
        lbStatus.Caption := 'Printing report #2';
        crpe1.ReportName := 'report\รายละเอียด Meter.rpt';
        crpe1.execute;
      end;
    3 :
      begin
        Timer1.Enabled := false;
        lbStatus.Caption := 'Printing report #3';
        crpe1.ReportName := 'report\สรุปการจดหน่วย.rpt';
        crpe1.execute;
      end;
    -1 :
       begin
         lbStatus.Caption := 'Waiting for report file';
       end;
  end;
end;

procedure TForm1.Crpe1PrintEnded(Sender: TObject);
var searchrec : TSearchrec;
begin
  case Detectfile('rptdat') of
    1 :
      begin
        deletefile('rptdat\r_rcvfil.dbf');
      end;
    2 :
      begin
        deletefile('rptdat\r_dtlfil.dbf');
        deletefile('rptdat\h_dtlfil.dbf');
      end;
    3 :
      begin
        deletefile('rptdat\r_cmtfil.dbf');
        deletefile('rptdat\h_cmtfil.dbf');
      end;
  end;
  timer1.Enabled := true;
end;

end.
