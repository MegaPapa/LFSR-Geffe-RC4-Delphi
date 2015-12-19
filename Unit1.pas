unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,Math, Vcl.ExtCtrls;

type
  TDynamicByteArray = array of Byte;
  TKeyArray = array of byte;

type
  TForm1 = class(TForm)
    EditLFSR1: TEdit;
    ButtonGenerateLFSR1: TButton;
    MemoLFSR1: TMemo;
    ButtonOpen: TButton;
    OpenDialog: TOpenDialog;
    RadioButtonLFSR: TRadioButton;
    RadioButtonGeffe: TRadioButton;
    RadioButtonRC4: TRadioButton;
    ButtonCiphr: TButton;
    ButtonDeciphr: TButton;
    MemoLFSR2: TMemo;
    MemoLFSR3: TMemo;
    EditLFSR2: TEdit;
    EditLFSR3: TEdit;
    ButtonGenerateLFSR2: TButton;
    ButtonGenerateLFSR3: TButton;
    SaveDialog: TSaveDialog;
    EditRC4: TEdit;
    ButtonAddRC4: TButton;
    ButtonClearKey: TButton;
    MemoCiphrRC4: TMemo;
    Button1: TButton;
    PanelTexts: TPanel;
    MemoBinText: TMemo;
    MemoText: TMemo;
    PanelCiphr: TPanel;
    MemoCiphrText: TMemo;
    PanelKey: TPanel;
    MemoKey: TMemo;
    PanelDeciphr: TPanel;
    MemoDeciphr: TMemo;
    LabelMemoText: TLabel;
    LabelMemoBinText: TLabel;
    LabelCiphrText: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MemoCiphr: TMemo;
    LabelCiphr: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure EditLFSR1KeyPress(Sender: TObject; var Key: Char);
    procedure ButtonGenerateLFSR1Click(Sender: TObject);
    procedure ButtonOpenClick(Sender: TObject);
    procedure ButtonCiphrClick(Sender: TObject);
    procedure ButtonDeciphrClick(Sender: TObject);
    procedure ButtonGenerateLFSR2Click(Sender: TObject);
    procedure ButtonGenerateLFSR3Click(Sender: TObject);
    procedure RadioButtonLFSRClick(Sender: TObject);
    procedure RadioButtonGeffeClick(Sender: TObject);
    procedure RadioButtonRC4Click(Sender: TObject);
    procedure ButtonAddRC4Click(Sender: TObject);
    procedure ButtonClearKeyClick(Sender: TObject);
    procedure EditRC4KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

   function BinToText(LetterInBin : string) : integer;
   procedure Transform(MemoCiphr,MemoCiphrText : TMemo);
  // procedure RC4 (MemoText,MemoCiphrRC4 : TMemo; SaveDialog : TSaveDialog);
//   procedure RC4Deciphr(MemoCiphrRC4,MemoDeciphr : TMemo; SaveDialog : TSaveDialog);
//   procedure ByteRead(MemoBinText : TMemo;OpenDialog : TOpenDialog);
   function RC4(keyArray: TKeyArray; MemoRC4Ciphr : TMemo): string;
   procedure getSourceFileBytes(OpenDialog : TOpenDialog);

const
   LFSR_1_DIMENSION = 26;
   LFSR_2_DIMENSION = 34;
   LFSR_3_DIMENSION = 24;
   ZERO = '0';


var
  Form1: TForm1;
  FirstKey : string;
  count : integer;
  UKey : array of byte;
  FileBytes : array of byte;
  ByteFile_Size : int64;
  FileString : string;
  //---- гыыыы
  arrayKey: TKeyArray;
  LFSREncode: string;
  LFSRFileLength: int64;
  FileExtention: string;
  RC4String: string;
  RC4Key: string;
  keyString: string;
  output: string;
  LFSROutput,mode: string;

implementation

{$R *.dfm}

//многочлен степеней 26,34,24

function BinKey(EditKey : TEdit;Dimension : integer) : string;
var
   i : integer;
   temp : string;
begin
   temp := '';
   insert(EditKey.Text,temp,1);
   for I := 0 to (Dimension - Length(EditKey.Text)) - 1 do
      Insert(ZERO,temp,1);
   EditKey.Text := temp;
   result := temp;
end;

function Shift_Key(length : integer; Key : string) : string;
var
   i : integer;
begin
   for I := 1 to (length - 1) do
      Key[i] := Key[i+1];
   result := Key;
end;

function LFSR_KeyGeneration(index_1,index_2,index_3,dimension : integer; EditLFSR : TEdit;
                            MemoBinText,MemoLFSR : TMemo) : string;
var
   Previously_Key,Key : string;
   i,count,new_bit : integer;
begin
   new_bit := 1;
   Previously_Key := BinKey(EditLFSR,dimension);
   Key := Previously_Key;
   count := length(MemoBinText.Text) - dimension; // <---- округлить результат
   for I := 0 to (count) do
   begin
      new_bit := (((strtoint(Previously_Key[1]) xor strtoint(Previously_Key[dimension-index_3 + 1])) xor strtoint(Previously_Key[dimension-index_2 + 1])) xor strtoint(Previously_Key[dimension-index_1 + 1]));
      Previously_Key := Shift_Key(dimension,Previously_Key);
      if new_bit = 1 then
         Previously_Key[dimension] := '1'
      else
         Previously_Key[dimension] := '0';
      Key := Key + IntToStr(new_bit);
   end;
   MemoLFSR.Text := Key;
end;

procedure LFSRCiphr(MemoBinText,MemoLFSR1,MemoCiphr : TMemo);
var
   i : integer;
begin
   for I := 1 to length(MemoBinText.Text) do
      MemoCiphr.Text := MemoCiphr.Text + inttostr(strtoint(MemoBinText.Text[i]) xor strtoint(MemoLFSR1.Text[i]));
end;

procedure LFSRDeciphr(MemoDeciphr,MemoLFSR1,MemoCiphr : TMemo);
var
   i : integer;
begin
   for I := 1 to length(MemoCiphr.Text) do
      MemoDeciphr.Text := MemoDeciphr.Text + inttostr(strtoint(MemoCiphr.Text[i]) xor strtoint(MemoLFSR1.Text[i]));
end;

procedure GeffeCiphr(MemoLFSR1,MemoLFSR2,MemoLFSR3,MemoBinText,MemoCiphr : TMemo);
var
   i : integer;
   GeffeKey : byte;
begin
   GeffeKey := 0;
   for I := 1 to length(MemoBinText.Text) do
   begin
      GeffeKey := (strtoint(MemoLFSR1.Text[i]) and strtoint(MemoLFSR2.Text[i])) or
                  ((not strtoint(MemoLFSR1.Text[i])) and strtoint(MemoLFSR3.Text[i]));
      MemoCiphr.Text := MemoCiphr.Text + inttostr(strtoint(MemoBinText.Text[i]) xor GeffeKey);
   end;
end;

procedure TForm1.ButtonClearKeyClick(Sender: TObject);
var
  I: Integer;
begin
   for I := 0 to high(arrayKey) do
      arrayKey[i] := 0;
   count := 0;
   MemoKey.Text := '';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//   if OpenDialog.Execute then
 //     ByteRead(MemoBinText,OpenDialog);
  // showmessage(chr(200));
  if SaveDialog.Execute then
     MemoCiphrRC4.lines.SaveToFile(SaveDialog.FileName);
end;

procedure TForm1.ButtonAddRC4Click(Sender: TObject);
begin
   if (strtoint(EditRC4.Text) <= 255) and (strtoint(EditRC4.Text) >= 0) then
   begin
      inc(count);
      setlength(arrayKey,count);
      arrayKey[count - 1] := strtoint(EditRC4.Text);
      EditRC4.Text := '';
      MemoKey.Text := MemoKey.Text + inttostr(arrayKey[count - 1]) + ' ';
   end;
end;

procedure TForm1.ButtonCiphrClick(Sender: TObject);
begin
   if (MemoText.Text <> '') then
   begin
      MemoCiphr.Text := '';
      MemoCiphrText.Text := '';
      MemoCiphrRC4.Text := '';
      if RadioButtonLFSR.Checked then
      begin
         LFSRCiphr(MemoBinText,MemoLFSR1,MemoCiphr);
         if SaveDialog.Execute() then
            MemoCiphr.Lines.SaveToFile(SaveDialog.FileName);
         Transform(MemoCiphr,MemoCiphrText);
      end;
      if RadioButtonGeffe.Checked then
      begin
         GeffeCiphr(MemoLFSR1,MemoLFSR2,MemoLFSR3,MemoBinText,MemoCiphr);
         if SaveDialog.Execute() then
            MemoCiphr.Lines.SaveToFile(SaveDialog.FileName);
         Transform(MemoCiphr,MemoCiphrText);
      end;
      if RadioButtonRC4.Checked then
      begin
         //if OpenDialog.Execute() then
         begin
            RC4(arrayKey,MemoCiphrRC4);
         end;
           // RC4(MemoText,MemoCiphrRC4,SaveDialog);
      end;
   end;
end;

procedure GeffeDeciphr(MemoLFSR1,MemoLFSR2,MemoLFSR3,MemoCiphr,MemoDeciphr : TMemo);
var
   i : integer;
   GeffeKey : byte;
begin
   GeffeKey := 0;
   for I := 1 to length(MemoCiphr.Text) do
   begin
      GeffeKey := (strtoint(MemoLFSR1.Text[i]) and strtoint(MemoLFSR2.Text[i])) or
                  ((not strtoint(MemoLFSR1.Text[i])) and strtoint(MemoLFSR3.Text[i]));
      MemoDeciphr.Text := MemoDeciphr.Text + inttostr(strtoint(MemoCiphr.Text[i]) xor GeffeKey);
   end;
end;

procedure TForm1.ButtonDeciphrClick(Sender: TObject);
begin
   MemoCiphr.Text := '';
   if OpenDialog.Execute then
      MemoCiphr.Lines.LoadFromFile(OpenDialog.FileName);
   if RadioButtonLFSR.Checked then
      LFSRDeciphr(MemoDeciphr,MemoLFSR1,MemoCiphr);
   if RadioButtonGeffe.Checked then
      GeffeDeciphr(MemoLFSR1,MemoLFSR2,MemoLFSR3,MemoCiphr,MemoDeciphr);
   if RadioButtonRC4.Checked then
      RC4(arrayKey,MemoCiphrRC4);
      //RC4Deciphr(MemoCiphrRC4,MemoDeciphr,SaveDialog);
end;

procedure TForm1.ButtonGenerateLFSR1Click(Sender: TObject);
begin
   LFSR_KeyGeneration(1,7,8,LFSR_1_DIMENSION,EditLFSR1,MemoBinText,MemoLFSR1);
end;

procedure TForm1.ButtonGenerateLFSR2Click(Sender: TObject);
begin
   LFSR_KeyGeneration(1,14,15,LFSR_2_DIMENSION,EditLFSR2,MemoBinText,MemoLFSR2);
end;

procedure TForm1.ButtonGenerateLFSR3Click(Sender: TObject);
begin
   LFSR_KeyGeneration(1,3,4,LFSR_3_DIMENSION,EditLFSR3,MemoBinText,MemoLFSR3);
end;

function Bin(x: Integer): string;
const
   t:array[0..1] of char = ('0','1');
   AllBits = 8;
var
   d:0..1;
  I: Integer;
begin
   result:='';
   while (x<>0) do
   begin
      d:=x mod 2 ;
      result:=t[d]+result;
      x:=x div 2 ;
   end;
   for I := 1 to (AllBits - length(result)) do
      insert(ZERO,result,1);
   Bin:=result;
end;

procedure TextToBin(MemoText,MemoBinText : TMemo);
var
  I: Integer;
begin
   for I := 1 to length(MemoText.Text) do
   begin
      MemoBinText.Text := MemoBinText.Text + bin(ord(MemoText.Text[i]));
   end;
end;

procedure TForm1.ButtonOpenClick(Sender: TObject);
begin
   if RadioButtonRC4.Checked then
      if OpenDialog.Execute then
      begin
         getsourceFileBytes(OpenDialog);
         Memotext.Text := RC4String;
         //ByteRead(MemoBinText,OpenDialog);
      end;
   if RadioButtonGeffe.Checked or RadioButtonLFSR.Checked then
   begin
      if OpenDialog.Execute then
         MemoText.Lines.LoadFromFile(OpenDialog.FileName);
      MemoBinText.Text := '';
      TextToBin(MemoText,MemoBinText);
   end;
end;

procedure TForm1.EditLFSR1KeyPress(Sender: TObject; var Key: Char);
begin
   if not ((key in ['0'..'1']) or (key = #8)) then
      key := #0;
end;


procedure TForm1.EditRC4KeyPress(Sender: TObject; var Key: Char);
begin
   if not ((key in ['0'..'9']) or (key = #8)) then
      key := #0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   MemoText.Text := '';
   MemoLFSR1.Text := '';
   MemoBinText.Text := '';
   MemoCiphr.Text := '';
   MemoDeciphr.Text := '';
   MemoLFSR2.Text := '';
   MemoLFSR3.Text := '';
   MemoCiphrText.Text := '';
   MemoKey.Text := '';
   MemoCiphrRC4.Text := '';
   count := 0;
end;


procedure TForm1.RadioButtonGeffeClick(Sender: TObject);
begin
   MemoBinText.Text := '';
   MemoText.Text := '';
   MemoCiphr.Text := '';
   MemoDeciphr.Text := '';
   MemoLFSR1.Text := '';
   MemoLFSR2.Text := '';
   MemoLFSR3.Text := '';
   MemoCiphrText.Text := '';
   MemoCiphrRC4.Text := '';
   ButtonGenerateLFSR1.Enabled := true;
   ButtonGenerateLFSR2.Enabled := true;
   ButtonGenerateLFSR3.Enabled := true;
   EditRC4.Enabled := false;
   ButtonAddRC4.Enabled := false;
   ButtonClearKey.Enabled := false;
end;

function BinToText(LetterInBin : string) : integer;
var
   pow : byte;
   i : integer;
   Letter : integer;
begin
   Letter := 0;
   for I := 1 to 8 do
   begin
      pow := strtoint(LetterInBin[9-i]);
      if strtoint(LetterInBin[9-i]) = 1 then
         Letter := Letter + trunc(Power(2,i));
   end;
   result := trunc(Letter/2);
end;

procedure Transform(MemoCiphr,MemoCiphrText : TMemo);
var
   i,j : integer;
   Letter : string;
begin
   i := 1;
   Letter := '';
   while (i <> length(MemoCiphr.Text) + 1) do
   begin
      for j := 0 to 7 do
         Letter := Letter + MemoCiphr.Text[i+j];
      MemoCiphrText.Text := MemoCiphrText.Text + chr(BinToText(Letter));
      Letter := '';
      inc(i,8);
   end;
end;

procedure TForm1.RadioButtonLFSRClick(Sender: TObject);
begin
   MemoBinText.Text := '';
   MemoText.Text := '';
   MemoCiphr.Text := '';
   MemoDeciphr.Text := '';
   MemoLFSR1.Text := '';
   MemoLFSR2.Text := '';
   MemoLFSR3.Text := '';
   MemoCiphrText.Text := '';
   MemoCiphrRC4.Text := '';
   ButtonGenerateLFSR1.Enabled := true;
   ButtonGenerateLFSR2.Enabled := false;
   ButtonGenerateLFSR3.Enabled := false;
   EditRC4.Enabled := false;
   ButtonAddRC4.Enabled := false;
   ButtonClearKey.Enabled := false;
end;

procedure TForm1.RadioButtonRC4Click(Sender: TObject);
begin
   MemoBinText.Text := '';
   MemoText.Text := '';
   MemoCiphr.Text := '';
   MemoDeciphr.Text := '';
   MemoLFSR1.Text := '';
   MemoLFSR2.Text := '';
   MemoLFSR3.Text := '';
   ButtonGenerateLFSR1.Enabled := false;
   ButtonGenerateLFSR2.Enabled := false;
   ButtonGenerateLFSR3.Enabled := false;
   EditRC4.Enabled := true;
   ButtonAddRC4.Enabled := true;
   MemoCiphrText.Text := '';
   MemoCiphrRC4.Text := '';
   ButtonClearKey.Enabled := true;
end;

procedure swap(var a,b : byte);
var
   temp : byte;
begin
   temp := a;
   a := b;
   b := temp;
end;

//---------------------------------- Я ТУТ РС4 ДЕЛАЮ))) -----------------------------------

procedure init(var byteArray: TDynamicByteArray);
var
  i: Integer;
begin
  SetLength(byteArray, 256);
  for i:= 0 to 255 do
    byteArray[i]:= i;
end;

procedure swaps(var arr: TDynamicByteArray; i, j: Integer);
var
  temp: Integer;
begin
  temp:= arr[i];
  arr[i]:= arr[j];
  arr[j]:= temp;
end;

procedure mixing(var byteArray: TDynamicByteArray; keyArray: TKeyArray);
var
  i, j: integer;
begin
  j:= 0;
  for i:= 0 to 255 do
    begin
      j:= (j + byteArray[i] + keyArray[i mod Length(keyArray)]) mod 256;
      swaps(byteArray, i, j);
    end;
end;

function randomGenerator(var byteArray: TDynamicByteArray; var x: Integer; var y: Integer): Byte;
begin
  x:= (x + 1) mod 256;
  y:= (y + byteArray[x]) mod 256;

  swaps(byteArray, x, y);

  result:= byteArray[(byteArray[x] + byteArray[y]) mod 256];

  keyString:= keyString + inttoStr(Result) + ' ';
  //frmRC4.mmoKey.text:= frmRC4.mmoKey.text + IntToStr(Result) + ' ';
end;

function RC4(keyArray: TKeyArray;MemoRC4Ciphr : TMemo;mode : string): string;
var
  byteArray: TDynamicByteArray;
  x,y, i: Integer;
begin
  result := '';
  x:= 0;
  y:= 0;

  init(byteArray);
  mixing(byteArray, keyArray);

  if (mode = 'ciphr') then
  begin
     for i:= 1 to Length(RC4String) do
       begin
         result:= Result + chr((Ord(RC4String[i]) xor randomGenerator(byteArray, x, y)));
       end;
     output:= Result;
     MemoRC4Ciphr.Text := result;
  end
  else
  begin
     for i:= 1 to Length(RC4String) do                 //<----------доделай!!!
       begin
         result:= Result + chr((Ord(RC4String[i]) xor randomGenerator(byteArray, x, y)));
       end;
     output:= Result;
     MemoRC4Ciphr.Text := result;
  end;
 // MemoCiphrRC4.Text:= Result;
  //frmRC4.mmoKey.Text:= keyString;
end;

procedure getSourceFileBytes(OpenDialog : TOpenDialog);
var
  sourceFile: file;
  i: Byte;
  sourceFileSize: Int64;
  dataString: string;
begin
  AssignFile(sourceFile, OpenDialog.FileName);
  Reset(sourceFile, 1);
  sourceFileSize:= fileSize(sourceFile);
  SetLength(dataString, sourceFileSize);
  BlockRead(sourceFile, Pointer(dataString)^, sourceFileSize);
  CloseFile(sourceFile);
  RC4String:= dataString;

end;

{procedure RC4 (MemoText,MemoCiphrRC4 : TMemo;SaveDialog : TSaveDialog);
var
   i,j,k : integer;
   key,Ciphr : byte;
   s : array [0..255] of byte;
   Output : File of char;
   KeyFile : File of byte;
   OutputString : String;
begin
   AssignFile(Output,SaveDialog.FileName);
   Rewrite(Output);
   AssignFile(KeyFile,'Key.txt');
   Rewrite(KeyFile);
   key := 0;
   for I := 0 to 255 do
      s[i] := i;

   j := 0;
   for I := 0 to 255 do
   begin
      j := (j+s[i]+UKey[i mod sizeof(UKey)]) mod 256;
      swap(s[i],s[j]);
   end;

   i := 0;
   j := 0;
   OutputString := '';
  // showmessage(FileString);
   for k := 0 to (length(FileString) - 1) do
   begin
      i := (i+1) mod 256;
      j := (j + s[i]) mod 256;
      swap(s[i],s[j]);
      key := s[(s[i]+s[j]) mod 256];
  //    blockwrite(KeyFile,(key),1);
   //   write(KeyFile,' ');
    //  MemoCiphrRC4.Text := MemoCiphrRC4.Text + inttostr(key) + ' ';
      Ciphr := ord(key xor ord(FileString[k]));
      OutputString := OutputString + chr(Ciphr);
     // BlockWrite(Output,Ciphr,1);//ord(MemoText.Text[k]);
   end;
   CloseFile(KeyFile);
  // MemoCiphrRC4.Lines.LoadFromFile('Key.txt');
   CloseFile(Output);
   showmessage(OutputString);
   MemoCiphrRC4.Text := OutputString;
   MemoCiphrRC4.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure ByteRead(MemoBinText : TMemo;OpenDialog : TOpenDialog);
var
   ReadingFile : File;
begin
  { FileString := '';
   AssignFile(ReadingFile,OpenDialog.FileName);
   Reset(ReadingFile,1);
   ByteFile_Size := fileSize(ReadingFile);
   showmessage(inttostr(ByteFile_Size));
   SetLength(FileBytes,fileSize(ReadingFile));
   for I := 0 to fileSize(ReadingFile) - 1 do
   begin
      BlockRead(ReadingFile,FileBytes[i],1);
     // FileString := FileString + inttostr(FileBytes[i]);
     // showmessage(inttostr(FileBytes[i]));
   end;
   //MemoBinText.Text := Filestring;
   CloseFile(ReadingFile);
   //----------- второй способ чтения-----------------
   FileString := '';
   Setlength(FileString,0);
   AssignFile(ReadingFile, OpenDialog.FileName);
   Reset(ReadingFile, 1);
   ByteFile_Size := fileSize(ReadingFile);
   SetLength(FileString, ByteFile_Size);
   BlockRead(ReadingFile, Pointer(FileString)^, ByteFile_Size);
   CloseFile(ReadingFile);
end;

procedure RC4Deciphr(MemoCiphrRC4,MemoDeciphr : TMemo; SaveDialog : TSaveDialog);
var
   i,j,k : integer;
   Deciphr,key : byte;
   s : array [0..255] of byte;
   OutputFile : File;
   OutputString : string;
begin
   key := 0;
   for I := 0 to 255 do
      s[i] := i;

   j := 0;
   for I := 0 to 255 do
   begin
      j := (j+s[i]+UKey[i mod sizeof(UKey)]) mod 256;
      swap(s[i],s[j]);
   end;

   i := 0;
   j := 0;
   OutputString := '';
   //showmessage(FileString);
   if SaveDialog.Execute then
   begin
      AssignFile(OutputFile,SaveDialog.FileName);
      Rewrite(OutputFile);
      for k := 0 to (length(FileString) - 1) do
      begin
         i := (i+1) mod 256;
         j := (j + s[i]) mod 256;
         swap(s[i],s[j]);
         key := s[(s[i]+s[j]) mod 256];
         Deciphr := ord(key xor ord(FileString[k]));
         OutputString := OutputString + chr(Deciphr);
         //MemoDeciphr.Text := MemoDeciphr.Text + chr(deciphr);
        // BlockWrite(OutputFile,Deciphr,1);//ord(MemoCiphrRC4.Text[k]);
         //MemoDeciphr.Text := MemoDeciphr.Text + chr(Deciphr);
      end;
   end;
   CloseFile(OutputFile);
   MemoDeciphr.Text := OutputString;
   MemoDeciphr.Lines.SaveToFile(SaveDialog.FileName);
end;      }

end.
