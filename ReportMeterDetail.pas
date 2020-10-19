unit ReportMeterDetail;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Halcn6DB, UCrpe32, StdCtrls, Mask, ToolEdit, Buttons, ExtCtrls,
  DBTables, ComCtrls;

type
  TFormMeterDetailReport = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    bbPreview: TBitBtn;
    bbPrint: TBitBtn;
    bbClose: TBitBtn;
    edDate: TDateEdit;
    Crpe1: TCrpe;
    tbDetailFileReport: THalcyonDataSet;
    Label2: TLabel;
    edCDay: TComboBox;
    Label3: TLabel;
    edFileName: TComboBox;
    qFileName: TQuery;
    ProgressBar1: TProgressBar;
    tbReportHeader: THalcyonDataSet;
    procedure FormActivate(Sender: TObject);
    procedure bbPreviewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CreateReportFile;
  end;

var
  FormMeterDetailReport: TFormMeterDetailReport;

implementation

uses MeterData;

{$R *.DFM}

procedure TFormMeterDetailReport.FormActivate(Sender: TObject);
begin
  tbDetailFileReport.Exclusive := true;
  tbDetailFileReport.open;
  tbDetailFileReport.Zap;
  tbReportHeader.Exclusive := true;
  tbReportHeader.open;
  tbReportHeader.Zap;
  qFileName.close;
  qFileName.open;
  edFileName.Clear;
  while not qFileName.eof do begin
    edFileName.Items.Add(qFileName.FieldByname('filename').AsString);
    qFileName.Next;
  end;
  qFileName.close;
  dm.tbMeter.open;
end;

procedure TFormMeterDetailReport.CreateReportFile;
var totalrec : longInt;
begin
  tbReportHeader.Insert;
  tbReportHeader.StringPut('head1',
  'วันที่รับข้อมูล '+edDate.Text+' Day '+edCDay.text+' Filename : '+edFileName.Text);
  tbReportHeader.Post;
  with dm.tbMeter do begin
    First;
    totalrec := RecordCount;
    ProgressBar1.Max := totalrec;
    ProgressBar1.step := 1;
    DisableControls;
    while not eof do begin
      if ((StringGet('c_day')=edcday.Text) or
          (StringGet('c_day')='')) and
         (StringGet('c_filename')=edFileName.Text) then begin
        tbDetailFileReport.Insert;
        tbDetailFileReport.StringPut('m_meter_n',StringGet('m_meter_n'));
        tbDetailFileReport.StringPut('m_section',StringGet('m_section'));
        tbDetailFileReport.StringPut('m_trip',StringGet('m_trip'));
        tbDetailFileReport.StringPut('d_last_dte',StringGet('d_last_dte'));
        tbDetailFileReport.StringPut('m_meter_rc',StringGet('m_meter_rc'));
        tbDetailFileReport.StringPut('m_prev_rd',StringGet('m_prev_rd'));
        tbDetailFileReport.StringPut('e_last_rd',StringGet('e_last_rd'));
        tbDetailFileReport.StringPut('m_avg_kwhr',StringGet('m_avg_kwhr'));
        tbDetailFileReport.StringPut('d_time',StringGet('d_time'));
        tbDetailFileReport.StringPut('m_prev_dte',StringGet('m_prev_dte'));
        tbDetailFileReport.StringPut('m_address',StringGet('m_address'));
        tbDetailFileReport.StringPut('m_multiple',StringGet('m_multiple'));
        tbDetailFileReport.StringPut('e_hh_cmt',StringGet('e_hh_cmt'));
        tbDetailFileReport.StringPut('m_rte_code',StringGet('m_rte_code'));
        tbDetailFileReport.StringPut('m_mn_cmt',StringGet('m_mn_cmt'));
        tbDetailFileReport.StringPut('m_rte',StringGet('m_rte'));
        tbDetailFileReport.StringPut('m_sub_rte',StringGet('m_sub_rte'));
        tbDetailFileReport.StringPut('d_acp_rem',StringGet('d_acp_rem'));
        tbDetailFileReport.StringPut('m_degit',StringGet('m_degit'));
        tbDetailFileReport.StringPut('m_mea_num',StringGet('m_mea_num'));
        tbDetailFileReport.StringPut('c_filename',StringGet('c_filename'));
        tbDetailFileReport.StringPut('c_day',StringGet('c_day'));
        tbDetailFileReport.post;
      end;
      Next;
      ProgressBar1.StepIt;
    end;
    EnableControls;
  end;
end;


procedure TFormMeterDetailReport.bbPreviewClick(Sender: TObject);
begin
  createReportFile;
  tbDetailFileReport.close;
  tbReportHeader.close;
  crpe1.Execute;
end;

end.
