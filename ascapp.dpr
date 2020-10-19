program ascapp;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  Childwin in 'CHILDWIN.PAS' {MDIChild},
  About in 'about.pas' {AboutBox},
  ChildIn in 'ChildIn.pas' {FormChildIn},
  ChildMeter in 'ChildMeter.pas' {FormChildMeter},
  ChildMeterlist in 'ChildMeterlist.pas' {FormChildMeterList},
  MeterData in 'MeterData.pas' {dm: TDataModule},
  DlgUpToHH in 'DlgUpToHH.pas' {FormUpToHH},
  ReportReceiveFile in 'ReportReceiveFile.pas' {FormReceiveFileReport},
  ReportMeterDetail in 'ReportMeterDetail.pas' {FormMeterDetailReport},
  ReportCommentSummary in 'ReportCommentSummary.pas' {FormCommentSummaryReport};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.Title := 'Meter Record System';
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
