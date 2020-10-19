unit DlgUpToHH;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormUpToHH = class(TForm)
    Button1: TButton;
    listOfFile: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
    function SelectFile(uploaddir : string) : string;
  end;

var
  FormUpToHH: TFormUpToHH;

implementation

{$R *.DFM}

function TFormUpToHH.SelectFile;
var SearchRec: TSearchRec;
begin
  listofFile.Clear;
  FindFirst(UploadDir+'\*',faDirectory, SearchRec);
  repeat
    if (SearchRec.Name <> '') and
       (SearchRec.Name <> '.') and
       (SearchRec.Name <> '..') then begin
      listofFile.Items.Add(SearchRec.Name);
    end;
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
  if showmodal = mrOk then begin
    result := listofFile.Items.Strings[listofFile.itemindex];
  end
  else begin
    result := '';
  end;
end;

end.
