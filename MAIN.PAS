unit Main;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls;

type
  TC86 = Array[1..86] of char;
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    SpeedPanel: TPanel;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    CutBtn: TSpeedButton;
    CopyBtn: TSpeedButton;
    PasteBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    StatusBar: TStatusBar;
    Refresh1: TMenuItem;
    N2: TMenuItem;
    file2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Transfer1: TMenuItem;
    UploadHandHeld1: TMenuItem;
    DownloadHandHeld1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Meter1: TMenuItem;
    N8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FileNewItemClick(Sender: TObject);
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure WindowTileItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    procedure FileCloseItemClick(Sender: TObject);
    procedure FileOpenItemClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);
    procedure FileSaveItemClick(Sender: TObject);
    procedure FileSaveAsItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure PasteItemClick(Sender: TObject);
    procedure WindowMinimizeItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpAboutItemClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Transfer1Click(Sender: TObject);
    procedure file2Click(Sender: TObject);
    procedure UploadHandHeld1Click(Sender: TObject);
    procedure CreateBatchUpMove(Datfilename : string);
    procedure CreateBatchDownMove(Datfilename : string);
    procedure DownloadHandHeld1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Meter1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private
    { Private declarations }
    inDir : string;
    outDir : string;
    SaveDir : string;
    dlDir : string;
    ulDir : string;
    apppath : string;

    procedure CreateMDIChild(const Name: string);
    procedure CreateInChild(const Name: string);
    procedure CreateMeterListChild(const Name: string);
    procedure ShowHint(Sender: TObject);
    procedure MoveFile(FromFile,ToFile : String);
    function FormatAddFileBuf(inArray : TC86) : TC86;

    procedure importFromTextFile(DatFileName : string);
    procedure exportToTextFile(DatFileName : string);
    function RunAndWait(const FileName: String): DWORD;
    procedure DeleteFilesInDir(const Folder : String );

  public
    { Public declarations }
    procedure setInDir(InputDirectory : string);
    procedure setOutDir(OutputDirectory : string);
    procedure setSaveDir(SaveDirectory : string);
    procedure setUploadDir(UploadDirectory : string);
    procedure setDownloadDir(DownloadDirectory : string);

  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses ChildWin, About, ChildIn, ChildMeterlist, MeterData, DlgUpToHH,
  ReportReceiveFile, ReportMeterDetail, ReportCommentSummary;

var InChild: TFormChildIn;
    MeterListChild : TFormChildMeterList;

function TMainForm.FormatAddFileBuf;
var r : TC86;
    i : integer;
begin
  for i := 1 to 86 do begin
    if inArray[i] < #30 then
      r[i] := '0'
    else
      r[i] := inArray[i];
  end;
  result := r;
end;


procedure TMainform.importFromTextFile;

var DatFile : textfile;
    ProdFile : textfile;
    RelateFile : textfile;
    Buf : String;
    PBuf : String;
    RBuf : String;

    Linecount : integer;
    i : integer;
    DataOfDay : Array[1..21] of string;
    m_Meter_number : string;
    m_Section : string;
    m_Trip : string;
    d_Last_date : string;
    m_meter_reader_code : string;
    m_previous_read : string;
    e_last_read : string;
    m_average_kwhr : string;
    d_time : string;
    m_previous_date : string;
    m_address : string;
    m_multiple : string;
    e_hand_held_comment : string;
    m_route_code : string;
    m_mainframe_comment : string;
    m_route : string;
    m_sub_route : string;
    d_acception_remark : string;
    m_degit : string;
    m_mea_number : string;

    HandHeldUploadDir : string;
    HandHeldDownloadDir : string;
    Stamp : string;
    warning : boolean;
    warnMeter : string;
    WorkingDay : integer;
    Dayline : integer;
begin
  {$I-}
  HandHeldUploadDir := ulDir+'\'+DatFileName;
  Mkdir(HandHeldUploadDir);
  IOResult;  // Clear IOResult;
  HandHeldDownloadDir := dlDir+'\'+DatFileName;
  Mkdir(HandHeldDownloadDir);
  IOResult;
  AssignFile(DatFile, InDir+'\'+DatFileName);
  AssignFile(ProdFile,HandHeldUploadDir+'\PRODS000.i');
  AssignFile(RelateFile,HandHeldUploadDir+'\Relat000.i');
  Reset(DatFile);
  Rewrite(ProdFile);
  Rewrite(RelateFile);
  dm.tbMeter.open;
  Linecount := 0;
  DayLine := 1;
  WorkingDay := 1;
  warning := false;
  warnMeter := '';
  while not eof(DatFile) do begin
    readln(DatFile,Buf);
    // first line
    inc(LineCount);
    StatusBar.SimpleText := 'กำลังอ่านข้อมูล :'+DatFilename+' '+
     IntToStr(Linecount);
    if LineCount = 1 then begin
      with dm do begin
        tbDLog.Open;
        tbDlog.Insert;
        for i := 1 to 21  do begin
          DataOfDay[i] := copy(buf,4*(i-1)+1,4);
          tbDlog.StringPut('d'+intToStr(i),DataOfDay[i]);
        end;
        for i := 1 to 21 do begin
          if DataOfDay[i] <> '0000' then begin
            WorkingDay := i;
            break;
          end;
        end;
        DateTimeToString(Stamp,'dd/mm/yyyy hh:nn',now);
        tbDlog.StringPut('stamp',stamp);
        tbDlog.StringPut('infile',DatFileName);
        tbDlog.Post;
        tbDlog.Close;
      end;
      PBuf := '0000'+Buf;
      writeln(ProdFile,PBuf);
    end
    else begin
      m_Meter_number := copy(Buf,1,6);
      m_Section := copy(Buf,7,2);
      m_Trip := copy(Buf,9,3);
      d_Last_date := copy(Buf,12,6);
      m_meter_reader_code := copy(Buf,18,3);
      m_previous_read := copy(Buf,21,6);
      e_last_read := copy(Buf,27,6);
      m_average_kwhr := copy(Buf,33,6);
      d_time := copy(Buf,39,4);
      m_previous_date := copy(Buf,43,6);
      m_address := copy(Buf,49,10);
      m_multiple := copy(Buf,59,5);
      e_hand_held_comment := copy(Buf,64,2);
      m_route_code := copy(Buf,66,1);
      m_mainframe_comment := copy(Buf,67,1);
      m_route := copy(Buf,68,3);
      m_sub_route := copy(Buf,71,2);
      d_acception_remark := copy(Buf,73,1);
      m_degit := copy(Buf,74,1);
      m_mea_number := copy(Buf,75,10);
      (*
      if not tbMeter.Find(m_Meter_number,true,false) then begin
        tbMeter.Insert;
      end
      else begin
        warning := true;
        warnMeter := warnMeter+m_Meter_number+#10+#13;
        tbMeter.Edit;
      end;
      *)
      with dm do begin
        tbMeter.Insert;
        tbMeter.StringPut('m_meter_n',m_Meter_number);
        tbMeter.StringPut('m_section',m_Section);
        tbMeter.StringPut('m_trip',m_Trip);
        tbMeter.StringPut('d_last_dte',d_Last_date);
        tbMeter.StringPut('m_meter_rc',m_meter_reader_code);
        tbMeter.StringPut('m_prev_rd',m_previous_read);
        tbMeter.StringPut('e_last_rd',e_last_read);
        tbMeter.StringPut('m_avg_kwhr',m_average_kwhr);
        tbMeter.StringPut('d_time',d_time);
        tbMeter.StringPut('m_prev_dte',m_previous_date);
        tbMeter.StringPut('m_address',m_address);
        tbMeter.StringPut('m_multiple',m_multiple);
        tbMeter.StringPut('e_hh_cmt',e_hand_held_comment);
        tbMeter.StringPut('m_rte_code',m_route_code);
        tbMeter.StringPut('m_mn_cmt',m_mainframe_comment);
        tbMeter.StringPut('m_rte',m_route);
        tbMeter.StringPut('m_sub_rte',m_sub_route);
        tbMeter.StringPut('d_acp_rem',d_acception_remark);
        tbMeter.StringPut('m_degit',m_degit);
        tbMeter.StringPut('m_mea_num',m_Meter_number);
        tbMeter.StringPut('c_filename',DatFileName);
        tbMeter.StringPut('c_day',IntToStr(WorkingDay));
        tbMeter.post;
      end;
      // Add 4 digit in front
      PBuf := format('%4.4d',[Linecount-1])+Buf;
      writeln(ProdFile,PBuf);
      RBuf := m_Meter_number+m_Section+format('%4.4d',[Linecount-1]);
      writeln(RelateFile,RBuf);
      // ตรวจสอบว่าหมดวันหรือยัง
      if DayLine >= StrToInt(DataOfDay[WorkingDay]) then begin
        DayLine := 1;
        for i := WorkingDay to 21 do begin
          if DataOfDay[i] <> '0000' then begin
            WorkingDay := i;
          end;
        end;
      end
      else begin
        inc(DayLine);
      end;
    end;
  end;
  closeFile(DatFile);
  closeFile(ProdFile);
  closeFile(RelateFile);
  dm.tbMeter.close;
  MoveFile(inDir+'\'+DatFileName,SaveDir+'\'+DatFileName);
  {$I+}
  Screen.Cursor := crDefault;
  Statusbar.SimpleText := 'ข้อมูลเสร็จเรียบร้อย';
  if Warning then begin
    messageDlg('พบเลข Meter ซ้ำในข้อมูล กรุณาตรวจสอบ'+#10+#13+warnMeter,mtWarning,[mbOk],0);
  end;
end;


procedure TMainForm.MoveFile;
var FromF,ToF : File;
    NumRead, NumWritten: Integer;
    Buf: array[1..2048] of Char;
begin
  {$I-}
  AssignFile(FromF, FromFile);
  Reset(FromF, 1);	{ Record size = 1 }
  AssignFile(ToF, ToFile);	{ Open output file }
  Rewrite(ToF, 1);	{ Record size = 1 }
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  CloseFile(FromF);
  CloseFile(ToF);
  DeleteFile(FromFile);
  {$I+}
end;

procedure TMainForm.setInDir;
begin
  inDir := InputDirectory;
end;

procedure TMainForm.setOutDir;
begin
  outDir := OutputDirectory;
end;

procedure TMainForm.setSaveDir;
begin
  SaveDir := SaveDirectory;
end;

procedure TMainForm.setUploadDir;
begin
  ulDir := UploadDirectory;
end;

procedure TMainForm.setDownloadDir;
begin
  dlDir := DownloadDirectory;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.OnHint := ShowHint;
  Screen.OnActiveFormChange := UpdateMenuItems;
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  StatusBar.SimpleText := Application.Hint;
end;

procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
end;

procedure TMainForm.CreateMeterListChild(const Name: string);
begin
  { create a new MDI child window }
  MeterListChild := TFormChildMeterList.Create(Application);
  MeterListChild.Caption := Name;
end;


procedure TMainForm.CreateInChild(const Name: string);
begin
  { create a new MDI child window }
  InChild := TFormChildIn.Create(Application);
  InChild.Caption := Name;
end;


procedure TMainForm.FileNewItemClick(Sender: TObject);
begin
  CreateMDIChild('NONAME' + IntToStr(MDIChildCount + 1));
end;

procedure TMainForm.FileOpenItemClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    CreateMDIChild(OpenDialog.FileName);
end;

procedure TMainForm.FileCloseItemClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
    ActiveMDIChild.Close;
end;

procedure TMainForm.FileSaveItemClick(Sender: TObject);
begin
  { save current file (ActiveMDIChild points to the window) }
end;

procedure TMainForm.FileSaveAsItemClick(Sender: TObject);
begin
  { save current file under new name }
end;

procedure TMainForm.FileExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.CutItemClick(Sender: TObject);
begin
  {cut selection to clipboard}
end;

procedure TMainForm.CopyItemClick(Sender: TObject);
begin
  {copy selection to clipboard}
end;

procedure TMainForm.PasteItemClick(Sender: TObject);
begin
  {paste from clipboard}
end;

procedure TMainForm.WindowCascadeItemClick(Sender: TObject);
begin
  Cascade;
end;

procedure TMainForm.WindowTileItemClick(Sender: TObject);
begin
  Tile;
end;

procedure TMainForm.WindowArrangeItemClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TMainForm.WindowMinimizeItemClick(Sender: TObject);
var
  I: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TMainForm.UpdateMenuItems(Sender: TObject);
begin
  FileCloseItem.Enabled := MDIChildCount > 0;
  FileSaveItem.Enabled := MDIChildCount > 0;
  FileSaveAsItem.Enabled := MDIChildCount > 0;
  CutItem.Enabled := MDIChildCount > 0;
  CopyItem.Enabled := MDIChildCount > 0;
  PasteItem.Enabled := MDIChildCount > 0;
  SaveBtn.Enabled := MDIChildCount > 0;
  CutBtn.Enabled := MDIChildCount > 0;
  CopyBtn.Enabled := MDIChildCount > 0;
  PasteBtn.Enabled := MDIChildCount > 0;
  WindowCascadeItem.Enabled := MDIChildCount > 0;
  WindowTileItem.Enabled := MDIChildCount > 0;
  WindowArrangeItem.Enabled := MDIChildCount > 0;
  WindowMinimizeItem.Enabled := MDIChildCount > 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

procedure TMainForm.HelpAboutItemClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  apppath := ExtractFilepath(Application.Exename);
  SetInDir(apppath+'infile');
  SetOutDir(apppath+'outfile');
  SetSaveDir(apppath+'processedfile');
  setDownloadDir(apppath+'fromHH');
  setUploadDir(apppath+'toHH');
  dm.tbMeter.open;
  dm.tbDlog.open;

  CreateInChild('In file');
  CreateMeterListChild('Meter');
end;

procedure TMainForm.Refresh1Click(Sender: TObject);
begin
  InChild.RefreshDir;
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  if MessageDlg('ยืนยันการล้างข้อมูล',mtConfirmation,mbYesNoCancel,0) =
     mrYes then begin
    with dm do begin
      tbMeter.Close;
      tbMeter.Exclusive := true;
      tbMeter.Open;
      tbMeter.Zap;
      tbMeter.Close;
      tbMeter.Exclusive := false;
      tbMeter.open;
    end;
    DeleteFilesInDir(uldir);
    DeleteFilesInDir(dldir);
    {$I-}
    mkdir(uldir);
    mkdir(dldir);
    {$I+}
  end;
end;

procedure TMainForm.Transfer1Click(Sender: TObject);
begin
  if MessageDlg('ยืนยันการล้างข้อมูล',mtConfirmation,mbYesNoCancel,0) =
     mrYes then begin
    with dm do begin
      tbDlog.Close;
      tbDlog.Exclusive := true;
      tbDlog.Open;
      tbDlog.Zap;
      tbDlog.Close;
      tbDlog.Exclusive := false;
      tbDlog.open;
    end;
  end;
end;

procedure TMainForm.file2Click(Sender: TObject);
var
  SearchRec: TSearchRec;
begin
  FindFirst(inDir+'\*', faAnyFile-faDirectory, SearchRec);
  repeat
    if SearchRec.Name <> '' then begin
      ImportFromTextFile(SearchRec.Name);
    end;
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
end;

function TMainForm.RunAndWait(const FileName: String): DWORD;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  Result := STILL_ACTIVE;
  GetStartupInfo(StartupInfo);
  if not CreateProcess(nil, PChar(FileName), nil, nil, IsConsole,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
    RaiseLastWin32Error;
  try
    if WaitForSingleObject(ProcessInfo.hProcess, INFINITE) = WAIT_OBJECT_0
then
      GetExitCodeProcess(ProcessInfo.hProcess, Result);
  finally
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;
end;


procedure TMainForm.UploadHandHeld1Click(Sender: TObject);
var
  batchname: String;
  datfilename : string;
begin
  with TFormUpToHH.Create(Application) do begin
    datfilename := SelectFile(ulDir);
    free;
  end;
  if datfilename <> '' then begin
    CreateBatchUpMove(datfilename);
  end;
  batchname := apppath+'\uphh.bat';
  RunAndWait(batchname);
end;

procedure TMainform.CreateBatchUpMove;
var bfile : textfile;
begin
  {$I-}
  AssignFile(bfile,apppath+'\upmove.bat');
  rewrite(bfile);
  writeln(bfile,'copy /y '+uldir+'\'+datfilename);
  closeFile(bfile);
  {$I+}
end;

procedure TMainForm.DownloadHandHeld1Click(Sender: TObject);
var
  batchname: String;
  datfilename : string;
begin
  with TFormUpToHH.Create(Application) do begin
    datfilename := SelectFile(dlDir);
    free;
  end;
  if datfilename <> '' then begin
    CreateBatchDownMove(datfilename);
  end;
  batchname := apppath+'\dlhh.bat';
  RunAndWait(batchname);
end;

procedure TMainform.CreateBatchDownMove;
var bfile : textfile;
begin
  {$I-}
  AssignFile(bfile,apppath+'\dlmove.bat');
  rewrite(bfile);
  writeln(bfile,'copy *.i '+dldir+'\'+datfilename);
  closeFile(bfile);
  {$I+}
end;


procedure TMainForm.exportToTextFile;
var DatFile : textfile;
    ProdFile : textfile;
    AddFile : file;
    Buf : String;
    PBuf : String;
    ABuf : TC86;

    Linecount : integer;
    m_Meter_number : string;
    m_Section : string;
    m_Trip : string;
    d_Last_date : string;
    m_meter_reader_code : string;
    m_previous_read : string;
    e_last_read : string;
    m_average_kwhr : string;
    d_time : string;
    m_previous_date : string;
    m_address : string;
    m_multiple : string;
    e_hand_held_comment : string;
    m_route_code : string;
    m_mainframe_comment : string;
    m_route : string;
    m_sub_route : string;
    d_acception_remark : string;
    m_degit : string;
    m_mea_number : string;
    NumRead : integer;
    ReadDir : string;
begin
  AssignFile(DatFile, outDir+'\'+DatFileName);
  ReadDir := dlDir+'\'+DatFileName;
  AssignFile(ProdFile,ReadDir+'\PRODS000.i');
  AssignFile(AddFile,ReadDir+'\Addnew00.i');
  {$I-}
  Reset(ProdFile);
  Reset(AddFile,1);
  Rewrite(DatFile);
  dm.tbMeter.open;
  Linecount := 0;
  while not eof(ProdFile) do begin
    readln(ProdFile,PBuf);
    // first line
    inc(LineCount);
    StatusBar.SimpleText := 'กำลังอ่านข้อมูล : '+ ReadDir+' '+
    IntToStr(Linecount);
    if (LineCount = 1) and
       (copy(PBuf,1,4)<>'0001') then begin
      // checksum 1st 4 digit must be 0001
      messageDlg('Warning Maybe Invalid PRODS000.i',mtWarning,[mbok],0);
      // debug
      // m_Metem_m_Td_Lastm_mm_preve_lastm_averd_tim_prevm_addresssm_mule_mmm_rm_dmm_mea_numb
    end;
    // Remove 4 digit
    Buf := copy(PBuf,5,length(PBuf)-4);
    m_Meter_number := copy(Buf,1,6);
    m_Section := copy(Buf,7,2);
    m_Trip := copy(Buf,9,3);
    d_Last_date := copy(Buf,12,6);
    m_meter_reader_code := copy(Buf,18,3);
    m_previous_read := copy(Buf,21,6);
    e_last_read := copy(Buf,27,6);
    m_average_kwhr := copy(Buf,33,6);
    d_time := copy(Buf,39,4);
    m_previous_date := copy(Buf,43,6);
    m_address := copy(Buf,49,10);
    m_multiple := copy(Buf,59,5);
    e_hand_held_comment := copy(Buf,64,2);
    m_route_code := copy(Buf,66,1);
    m_mainframe_comment := copy(Buf,67,1);
    m_route := copy(Buf,68,3);
    m_sub_route := copy(Buf,71,2);
    d_acception_remark := copy(Buf,73,1);
    m_degit := copy(Buf,74,1);
    m_mea_number := copy(Buf,75,10);
    with dm do begin
      if tbMeter.Find(m_Meter_number,true,false) then begin
        tbMeter.Edit;
      end
      else begin
        tbMeter.Insert;
      end;
      tbMeter.StringPut('m_meter_n',m_Meter_number);
      tbMeter.StringPut('m_section',m_Section);
      tbMeter.StringPut('m_trip',m_Trip);
      tbMeter.StringPut('d_last_dte',d_Last_date);
      tbMeter.StringPut('m_meter_rc',m_meter_reader_code);
      tbMeter.StringPut('m_prev_rd',m_previous_read);
      tbMeter.StringPut('e_last_rd',e_last_read);
      tbMeter.StringPut('m_avg_kwhr',m_average_kwhr);
      tbMeter.StringPut('d_time',d_time);
      tbMeter.StringPut('m_prev_dte',m_previous_date);
      tbMeter.StringPut('m_address',m_address);
      tbMeter.StringPut('m_multiple',m_multiple);
      tbMeter.StringPut('e_hh_cmt',e_hand_held_comment);
      tbMeter.StringPut('m_rte_code',m_route_code);
      tbMeter.StringPut('m_mn_cmt',m_mainframe_comment);
      tbMeter.StringPut('m_rte',m_route);
      tbMeter.StringPut('m_sub_rte',m_sub_route);
      tbMeter.StringPut('d_acp_rem',d_acception_remark);
      tbMeter.StringPut('m_degit',m_degit);
      tbMeter.StringPut('m_mea_num',m_Meter_number);
      tbMeter.StringPut('c_filename',DatFileName);
      tbMeter.post;
    end;

    writeln(DatFile,m_Meter_Number+m_Section+m_Trip+d_Last_Date
    +m_meter_reader_code+m_previous_read+e_last_read+m_average_kwhr
    +d_time+m_previous_date+m_address+m_multiple+e_hand_held_comment
    +m_route_code+m_mainframe_comment+m_route+m_sub_route+d_acception_remark
    +m_degit+m_mea_number);
  end;
  repeat
    blockread(AddFile,Abuf,86,numread);
    // first line
    inc(LineCount);
    StatusBar.SimpleText := 'กำลังอ่านข้อมูล :'+ IntToStr(Linecount);
    Buf := FormatAddFileBuf(ABuf);
    if copy(Buf,1,30) = '000000000000000000000000000000' then
      numread := 0;
    if numread <> 0 then begin
      m_Meter_number := copy(Buf,1,6);
      m_Section := copy(Buf,7,2);
      m_Trip := copy(Buf,9,3);
      d_Last_date := copy(Buf,12,6);
      m_meter_reader_code := copy(Buf,18,3);
      m_previous_read := copy(Buf,21,6);
      e_last_read := copy(Buf,27,6);
      m_average_kwhr := copy(Buf,33,6);
      d_time := copy(Buf,39,4);
      m_previous_date := copy(Buf,43,6);
      m_address := copy(Buf,49,10);
      m_multiple := copy(Buf,59,5);
      e_hand_held_comment := copy(Buf,64,2);
      m_route_code := copy(Buf,66,1);
      m_mainframe_comment := copy(Buf,67,1);
      m_route := copy(Buf,68,3);
      m_sub_route := copy(Buf,71,2);
      d_acception_remark := copy(Buf,73,1);
      m_degit := copy(Buf,74,1);
      m_mea_number := copy(Buf,75,10);


      with dm do begin
        if tbMeter.Find(m_Meter_number,true,false) then begin
          tbMeter.Edit;
        end
        else begin
          tbMeter.Insert;
        end;
        tbMeter.StringPut('m_meter_n',m_Meter_number);
        tbMeter.StringPut('m_section',m_Section);
        tbMeter.StringPut('m_trip',m_Trip);
        tbMeter.StringPut('d_last_dte',d_Last_date);
        tbMeter.StringPut('m_meter_rc',m_meter_reader_code);
        tbMeter.StringPut('m_prev_rd',m_previous_read);
        tbMeter.StringPut('e_last_rd',e_last_read);
        tbMeter.StringPut('m_avg_kwhr',m_average_kwhr);
        tbMeter.StringPut('d_time',d_time);
        tbMeter.StringPut('m_prev_dte',m_previous_date);
        tbMeter.StringPut('m_address',m_address);
        tbMeter.StringPut('m_multiple',m_multiple);
        tbMeter.StringPut('e_hh_cmt',e_hand_held_comment);
        tbMeter.StringPut('m_rte_code',m_route_code);
        tbMeter.StringPut('m_mn_cmt',m_mainframe_comment);
        tbMeter.StringPut('m_rte',m_route);
        tbMeter.StringPut('m_sub_rte',m_sub_route);
        tbMeter.StringPut('d_acp_rem',d_acception_remark);
        tbMeter.StringPut('m_degit',m_degit);
        tbMeter.StringPut('m_mea_num',m_Meter_number);
        tbMeter.StringPut('c_filename',DatFileName);
        tbMeter.post;
      end;

      writeln(DatFile,m_Meter_Number+m_Section+m_Trip+d_Last_Date
      +m_meter_reader_code+m_previous_read+e_last_read+m_average_kwhr
      +d_time+m_previous_date+m_address+m_multiple+e_hand_held_comment
      +m_route_code+m_mainframe_comment+m_route+m_sub_route+d_acception_remark
      +m_degit+m_mea_number);
    end;
  until numread=0;
  closeFile(DatFile);
  closeFile(ProdFile);
  closeFile(AddFile);
  {$I+}
  Screen.Cursor := crDefault;
  Statusbar.SimpleText := 'ข้อมูลเสร็จเรียบร้อย';
end;

procedure TMainForm.N5Click(Sender: TObject);
var SearchRec : TSearchRec;
begin
  FindFirst(DlDir+'\*',faDirectory, SearchRec);
  repeat
    if (SearchRec.Name <> '') and
       (SearchRec.Name <> '.') and
       (SearchRec.Name <> '..') then begin
      exportToTextFile(SearchRec.Name);
    end;
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
end;

Procedure TMainForm.DeleteFilesInDir(const Folder : String );
var
   ErrorCode : Integer;
   SearchRec : TSearchRec;
begin
  try
    ErrorCode := FindFirst(Folder + '\*.*', faAnyFile, SearchRec);
    while ErrorCode = 0 do
      begin
        if ((SearchRec.Name <> '.')
        and (SearchRec.Name <> '..'))
        and (SearchRec.Attr <> faVolumeID) then
	begin
          if  (SearchRec.Attr and faDirectory>0) then
            DeleteFilesInDir (Folder+'\'+SearchRec.Name)
          else begin
            DeleteFile(Folder+'\'+SearchRec.Name)
          end;
        end;
        ErrorCode := FindNext (SearchRec);
     end
  finally
    FindClose(SearchRec);
    rmdir (Folder);
  end;
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  with TFormReceiveFileReport.Create(Application) do begin
    Screen.Cursor := crDefault;
    showmodal;
    free();
 end;
end;

procedure TMainForm.Meter1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  with TFormMeterDetailReport.Create(Application) do begin
    Screen.Cursor := crDefault;
    showmodal;
    free();
 end;
end;

procedure TMainForm.N8Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  with TFormCommentSummaryReport.Create(Application) do begin
    Screen.Cursor := crDefault;
    showmodal;
    free();
 end;
end;

end.
