unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynHighlighterPython, SynCompletion,
  Forms, Controls, Graphics, Dialogs, Menus, LCLType;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMainMenu: TMainMenu;
    FileMenu: TMenuItem;
    LoadItem: TMenuItem;
    NewItem: TMenuItem;
    OpenFileDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    SepItem: TMenuItem;
    SaveItem: TMenuItem;
    ExitItem: TMenuItem;
    Editor: TSynEdit;
    PythonSyntax: TSynPythonSyn;
    procedure EditorChange(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure LoadItemClick(Sender: TObject);
    procedure NewItemClick(Sender: TObject);
    procedure SaveItemClick(Sender: TObject);
    procedure SaveFile();
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  CurrentFileName: string = 'Untitled';
  Saved: boolean = true;
  Reply: Integer;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.SaveFile();
begin
  if CurrentFileName = 'Untitled' then
    begin
    if SaveFileDialog.Execute then
      begin
        CurrentFileName :=  SaveFileDialog.FileName;
        Editor.Lines.SaveToFile(CurrentFileName);
        Caption := CurrentFileName;
        Saved := true;
      end
    else
      exit
    end
  else
       Editor.Lines.SaveToFile(CurrentFileName);
       Caption := CurrentFileName;
       Saved := true;
end;

procedure TMainForm.SaveItemClick(Sender: TObject);
begin
  SaveFile();
end;

procedure TMainForm.LoadItemClick(Sender: TObject);
begin
  if OpenFileDialog.Execute then
     CurrentFileName :=  OpenFileDialog.FileName;
     Editor.Lines.LoadFromFile(CurrentFileName);
     Caption := CurrentFileName;
     Saved := true;
end;

procedure TMainForm.NewItemClick(Sender: TObject);
begin
  if not Saved then
     Reply := Application.MessageBox('Save file?', 'Warning', MB_ICONQUESTION + MB_YESNOCANCEL);
     if Reply = IDCANCEL then
        exit
     else if Reply = IDYES then
       begin
         SaveFile();
       end;
  Editor.Lines.Clear;
  CurrentFileName := 'Untitled';
  Caption := CurrentFileName;
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin
  if not Saved then
     Reply := Application.MessageBox('Save file?', 'Warning', MB_ICONQUESTION + MB_YESNOCANCEL);
     if Reply = IDCANCEL then
        exit
     else if Reply = IDYES then
        SaveFile();
  Close()
end;

procedure TMainForm.EditorChange(Sender: TObject);
begin
  Caption := CurrentFileName + ' (*)';
  Saved := false;
end;

end.

