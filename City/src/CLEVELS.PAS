Unit CLevels;      {by Michael Rimer for "The Merican City"}

Interface

Uses Dos, Sounds2, Crt;

type
  LevelMatrix = Array[1..64,1..24] of char;     {max level dimensions}
   MonsterPtr = ^MonsterType;
  MonsterType = record
            Prev, Next : MonsterPtr;
     ox, oy, MX, MY, Pwr : integer;
                end;
        Coord = record
                  x, y : integer;
                end;

var
            LevelMat : LevelMatrix;
          HeadMS, MS : MonsterPtr;
         Tun1, Tun2,
          Tun3, Tun4 : Coord;
          FileChoice : PathStr;
                  D1 : DirStr;
                  N1 : NameStr;
                  E1 : ExtStr;
              f1, f2 : text;
       DrawMonsters,
    YesNec, YesSpec,
       GotLifeStaff,
     LifeStaff, Trap : boolean;
        Power, Score : longint;
             Access,
       Nec, Special,
       XCord, YCord,
         OldX, OldY,
   OldSpot, NewSpot,
       XTrap, YTrap,
    Moves, NumItems,
 Bombs, Magic, Keys,
Rail, Walls, Walls2,
 Twx, Twy, Lwx, Lwy,                   {to hold window dimensions}
   Lamp, SuperBombs, Wings,
  LevelNum, MaxLevel : integer;
             P1, P2,                              {for save games}
     SMagic, SBombs,
   SKeys, SLevelNum,
          SMaxLevel,
   SNumItems, SLamp,
SSuperBombs, SWings, SStaff,
     SXCord, SYCord,
        Ch, Ch1, Ch2 : char;
              SScore : longint;

Procedure Encode(var FileName : PathStr; Scramble : boolean);
Procedure ReadLevel(FileChoice : PathStr; XMax, YMax : integer);
Procedure DrawLevel(TopX, TopY, LowerX, LowerY : integer);
Procedure LevelName(Name : String);
Procedure PrintMan;
Procedure BlankLine;
Procedure SaveStats;
Procedure LoadGateway;
Procedure LoadCity;
Procedure LoadTower1;
Procedure LoadTower2;
Procedure LoadTower3;
Procedure LoadTower4;
Procedure LoadCatacombs;
Procedure LoadTunnels;
Procedure LoadPits;
Procedure LoadStair1;
Procedure LoadStair2;
Procedure LoadStair3;
Procedure LoadStair4;
Procedure LoadCave;
Procedure LoadRiver;
Procedure LoadFalls;
Procedure LoadLagoon;
Procedure LoadStorm;
Procedure LoadTemple;
Procedure LoadLabyrinth;
Procedure LoadSanctum;
Procedure Sanctum1;
Procedure LoadSciLab;
Procedure LoadTheDark;
Procedure LoadTrapHall;

Implementation

Procedure NewMonster(Nx, Ny, Str : integer);
begin
  New(MS);
  MS^.Next := HeadMS^.Next;
  MS^.Prev := HeadMS;
  if MS^.Next <> nil
    then HeadMS^.Next^.Prev := MS;
  HeadMS^.Next := MS;
  with MS^ do begin
    MX := Nx;
    MY := Ny;
    Pwr := Str
  end
end;

Procedure Cipher(var C1, C2 : char; Code : boolean);
var w : word;                               {for holding 2-byte pairs}
begin
{$R-}  w := (256 * Ord(C1)) + Ord(C2); {$R+}
  if Code then w := w xor $7F35                         {hide pattern}
    else w := w xor $357F;
  C1 := Chr(Lo(w));                                    {reverse bytes}
  C2 := Chr(Hi(w))
end;

Procedure Encode;
var Ch1, Ch2 : char;
begin
  Assign(f1, FileName);
  {$I-} Reset(f1); {$I+}
  z := IOResult;
  if z <> 0 then
    begin
      GotoXY(1,1);
      Writeln('File "',FileName,'" not found - program aborted');
      CursorOn;
      Halt(1)
    end;
  FSplit(FileName, D1, N1, E1);
  case Scramble of
    TRUE : if E1 = '.txt' then           {only '.txt' files to encode}
      begin
        E1 := '.dat';
        Writeln('Encoding file...');
        end
      else begin
        Write('Not a text file.');
        Close(f1);
        Halt(1)
      end;
    FALSE : if E1 = '.dat' then E1 := '.txt'
      else begin
        Write('Not a data file.');       {only '.dat' files to decode}
        Close(f1);
        Halt(1)
      end;
    end;          {of case}
  FileName := N1 + E1;
  Assign(f2, FileName);
  Rewrite(f2);
  while (not Eof(f1)) do
    begin
      Read(f1, Ch1);
      if Eof(f1) then Write(f2, Ch1)
        else begin
          Read(f1, Ch2);
          Cipher(Ch1, Ch2, Scramble);          {scrambles 2-byte pair}
          Write(f2, Ch1, Ch2)
        end;
    end;
  Close(f1);                                       {close BOTH files!}
  Close(f2)
end;

Procedure ReadLevel;
var EolCheck : char;
begin
  Encode(FileChoice, FALSE);           {"non-Scrambles" the data file}
  Assign(f1,FileChoice);
  {$I-} Reset(f1); {$I+}                {Opens file w/ error checking}
  z := IOResult;
  if z <> 0 then
    begin
      if z = 2 then
        begin
          GotoXY(1,1);
          Writeln('File "',FileChoice,'" not found - program aborted');
          CursorOn;
          Halt(1);
        end
      else
        begin
          GotoXY(1,1);
          Write('#',z,' ---> ');
          Writeln('File error in "',FileChoice,'" - program aborted');
          CursorOn;
          Halt(1);
        end
    end;
  j := 1;
  while (not Eof(f1)) do
    begin
      for i := 1 to XMax do begin
          Read(f1,LevelMat[i,j]);                   {reads one row in}
          if LevelMat[i,j] in ['0'..'3'] then
            NewMonster(i,j,Ord(LevelMat[i,j]) - 48)
        end;
      Read(f1,EolCheck);
      if EolCheck <> #241 then                         {'Ò' character}
        begin
          GotoXY(1,1);
          Writeln(EolCheck);
          Writeln(' --- Row length error ---');
          Writeln('Program aborted');
          CursorOn;
          Halt(1);
        end;
      Readln(f1);                      {eliminates return & line-feed}
      Inc(j);
      if (j > YMax) then
        if (not Eof(f1)) then
          begin
            GotoXY(1,1);
            Writeln('ERROR : Input file too large for array set');
            Writeln('Program aborted');
            CursorOn;
            Halt(1)
          end;
    end;
  Close(f1);
  {$I-} Erase(f1); {$I+}                {erases unscrambled data file}
  z := IOResult;
  if z <> 0 then
    begin
      GotoXY(1,1);
      Writeln('ERROR : File "',FileChoice,'" not erased properly!');
      Writeln('Program aborted');
      CursorOn;
      Halt(1)
    end;
  if not (j > YMax) then
    begin
      GotoXY(1,1);
      Writeln('File "',FileChoice,'" too small for array');
      Writeln('Program aborted');
      CursorOn;
      Halt(1)
    end;
end;

Procedure DrawLevel;
var RanCol, RanCol2 : integer;        {determines color of objects}
               Spot : char;
begin
  while TopX < 1 do Inc(TopX);                {draw only in screen}
  while (LowerX + Twx) > 65 do Dec(LowerX);
  while TopY < 1 do Inc(TopY);
  while (LowerY + Twy) > 25 do Dec(LowerY);
  RanCol := Succ(Random(15));
  RanCol2 := Succ(Random(15));
  for j := TopY to LowerY do
    begin
      GotoXY(TopX,j);
      for i := TopX to LowerX do
        begin
          Spot := LevelMat[i,j];
          case Spot of                  {scan array for screen output}
            '-','‰','˘','¯',#20,'H','q','s','a'..'e','w'..'z',':',';',
            'b','f','l','y',' ' : begin
              TextAttr := 0;
              Write(' ')
              end;
            'ˆ' : if Trap then begin
                TextAttr := LightRed;
                Write('˙')
              end
              else begin
                TextAttr := 0;
                Write(' ')
              end;
            '€',#39,'"' : begin                            {landscape}
              TextAttr := Walls;
              Write('€')
              end;
            '‹'..'ﬂ' : begin
              TextAttr := Walls;
              Write(Spot)
              end;
            '≤' : begin
              TextAttr := Walls2;
              Write('≤')
              end;
            '±' : begin
              TextAttr := Walls2;
              Write('±')
              end;
            '∞','|','`' : begin
              TextAttr := Walls2;
              Write('∞')
              end;
            #22 : begin
              TextAttr := Brown;
              Write('€')
              end;
            'U' : begin
              TextAttr := LightGreen + Brown * 16;
              Write('∞')
              end;
            '\' : begin
              TextAttr := Green + Brown * 16;
              Write('±')
              end;
            'È' : begin
              TextAttr := White + Magenta * 16;
              Write('È')
              end;
            '=','W' : begin
              TextAttr := LightBlue + Blue * 16 + Blink;
              Write('±')
              end;
            'L' : begin
              TextAttr := LightRed + Red * 16 + Blink;
              Write('±')
              end;
            'Z' : begin
              TextAttr := Yellow + LightGray * 16 + Blink;
              Write('±')
              end;
            'R' : begin
              TextAttr := Brown;
              Write(#127)
              end;
            'T' : begin
              TextAttr := Green;
              Write(#6)
              end;
            '#' : begin
              TextAttr := DarkGray;
              Write('±')
              end;
            'm'..'p' : begin
              TextAttr := White;
              Write('Ô')
              end;
            '@' : begin
              TextAttr := LightBlue + Blue * 16 + Blink;
              Write('@')
              end;
            'F' : begin
              TextAttr := White + Blue * 16 + Blink;
              Write('∞')
              end;
            #15 : begin
              TextAttr := Yellow + Blue * 16;
              Write(#15)
              end;
            '1' : begin                                {monsters}
              TextAttr := LightRed;
                case Random(3) of
                  0 : Write('é');
                  1 : Write('í');
                  2 : Write('A');
                end {case}
              end;
            '2' : begin
              TextAttr := LightGreen;
                case Random(3) of
                  0 : Write('ô');
                  1 : Write('o');
                  2 : Write('O');
                end {case}
              end;
            '3' : begin
              TextAttr := LightMagenta;
              if Random(2) > 0 then Write('Í') else Write('Ô')
              end;
            '0' : begin
                TextAttr := Brown + Magenta * 16;
                Write('∞')
              end;
            '$' : case LevelNum of                     {special items}
              1 : begin
                TextAttr := LightMagenta;
                Write('ë')
                end;
              2 : begin
                TextAttr := Red;
                Write('å')
                end;
              6 : begin
                TextAttr := LightBlue;
                Write('Â')
                end;
              9 : begin
                TextAttr := Cyan;
                Write(#9)
                end;
             14 : begin
                TextAttr := LightRed;
                Write('Â')
                end;
             15,16 : begin
                TextAttr := Blue + Red * 16;
                Write(#2)
                end;
             18 : begin
                TextAttr := LightGreen;
                Write('Â')
                end;
             21 : begin
                TextAttr := Yellow + Magenta * 16;
                Write(#2)
                end;
             22 : begin
                TextAttr := White;
                Write('%')
                end;
              end;              {of Special case}
            '4' : case LevelNum of                      {unique items}
              1 : begin
                TextAttr := White + Green * 16;
                Write('È')
                end;
              2,8,9,17,20,22..24 : begin
                TextAttr := LightBlue + Blink;
                Write('')
                end;
              3..6,10,15,18 : begin
                TextAttr := LightRed + Blink;
                Write('')
                end;
              7 : begin
                TextAttr := White;
                Write('Í')
                end;
              12,14 : begin
                TextAttr := 0;
                Write(' ')
                end;
              16 : begin
                TextAttr := White + Blue * 16 + Blink;
                Write('∞')
                end;
              21 : begin
                TextAttr := Yellow + Red * 16;
                Write('$')
                end;
              end;         {#4 case}
            '5' : case LevelNum of
              1 : begin
                TextAttr := LightMagenta + Red * 16;
                Write('„')
                end;
              2 : begin
                TextAttr := LightMagenta + Blue * 16;
                Write('˛')
                end;
              3, 4, 21: begin
                TextAttr := LightBlue + Blink;
                Write('')
                end;
              5,6,8,10..13 : begin
                TextAttr := 0;
                Write(' ')
                end;
              7,22 : begin
                TextAttr := LightRed + Blink;
                Write('')
                end;
             15,16 : begin
                TextAttr := LightMagenta + Blue * 16;
                Write(#4)
                end;
             20 : begin
                TextAttr := Succ(Random(15));
                Write('Î')
                end;
             23 : begin
                TextAttr := LightCyan;
                Write('ù')
                end;
              end;         {#5 case}
            '6' : case LevelNum of
              1 : begin
                TextAttr := White + Magenta * 16;
                Write('Í')
                end;
              2 : begin
                TextAttr := White + Magenta * 16;
                Write('Ï')
                end;
              5,7,8,10..13 : begin
                TextAttr := 0;
                Write(' ')
                end;
             15 : begin
                TextAttr := LightRed;
                Write(#9)
                end;
             16 : begin
                TextAttr := White;
                Write('Ô')
                end;
             20 : begin
                TextAttr := LightRed + Blink;
                Write('')
                end;
             21 : begin
                TextAttr := LightBlue + Blink;
                Write('')
                end;
             22,24 : begin
                TextAttr := LightGray;
                Write(#26)
                end;
             23 : begin
                TextAttr := Yellow + Green * 16;
                Write(#2)
                end;
              end;         {#6 case}
            '7' : case LevelNum of
              1 : begin
                TextAttr := White + Blue * 16;
                Write('È')
                end;
              2 : begin
                TextAttr := White + LightGray * 16;
                Write('')
                end;
              5 : begin
                TextAttr := LightBlue + Blink;
                Write('')
                end;
              7, 8, 21 : begin
                TextAttr := 0;
                Write(' ')
                end;
              10..13 : begin
                TextAttr := LightGray;
                Write(#15)
                end;
              15 : begin
                TextAttr := Brown + Blue * 16;
                Write(#127)
                end;
              16 : begin
                TextAttr := LightRed + Blue * 16;
                Write('@')
                end;
              20 : begin
                TextAttr := White;
                Write(#9)
                end;
              22 : begin
                TextAttr := Yellow;
                Write(#9)
                end;
              23 : begin
                TextAttr := LightCyan + Red * 16;
                Write('')
                end;
              24 : begin
                TextAttr := LightGray;
                Write(#27)
                end;
              end;         {#7 case}
            '8' : case LevelNum of
              2 : begin
                TextAttr := White + Red * 16;
                Write('È')
                end;
              5 : begin
                TextAttr := LightGray;
                Write('˙')
                end;
              7,12,13 : begin
                TextAttr := White + Magenta * 16;
                Write('Ï')
                end;
              8, 16, 21, 22 : begin
                TextAttr := 0;
                Write(' ')
                end;
              19 : begin
                TextAttr := LightRed + LightGray * 16;
                Write('„')
                end;
              end;         {#8 case}
            '9' : case LevelNum of
              2 : begin
                TextAttr := LightBlue + Blink;
                Write('')
                end;
              5 : begin
                TextAttr := LightGray;
                Write('˙')
                end;
              8 : begin
                TextAttr := LightGray;
                Write(#9)
                end;
              14,16 : begin
                TextAttr := 0;
                Write(' ')
                end;
              19 : begin
                TextAttr := LightRed + Blink;
                Write('')
                end;
              end;         {#9 case}
            #179..#218 : begin                         {rail segments}
              TextAttr := Rail;
              Write(Spot)
              end;
            'g' : begin
              TextAttr := LightMagenta;
              Write('∫')
              end;
            'G' : begin
              TextAttr := LightMagenta;
              Write('Õ')
              end;
            'Â' : begin                                 {common items}
              TextAttr := LightRed;
              Write('Â')
              end;
            'Î' : begin
              TextAttr := LightRed;
              Write('Î')
              end;
            #24 : begin
              TextAttr := LightGreen + Blink;
              Write(#24)
              end;
            'Ë' : begin
              TextAttr := RanCol2;
              Write('Ë')
              end;
            '˛' : begin
              TextAttr := LightBlue + Blue * 16;
              Write(#9)
              end;
            '*' : begin
              TextAttr := RanCol;
              Write('*')
              end;
            #4 : begin
              TextAttr := LightMagenta + Blue * 16;
              Write(#4)
              end;
            'I' : begin
              TextAttr := LightBlue;
              Write(#9)
              end;
            'V' : begin
              TextAttr := LightRed;
              Write('ˆ')
              end;
            'h'..'k' : begin
              TextAttr := LightGray;
              if Trap then if (Spot in ['h','j','k'])
                then TextAttr := DarkGray;  {to open wall in Tower3}
              Write('˙')
              end;
            'r','t'..'v' : begin
              TextAttr := RanCol;
              Write(#21)
              end;
          else begin
            TextAttr := White + Blink;
            Write('?')
            end;
          end; {Spot (all items) case}
        end;                {of one Row}
      Writeln
    end;                {of all Columns}
end;  {DrawLevel}

Procedure LevelName;
begin
  Window(1,1,80,25);
  TextAttr := Brown + LightGray * 16;
  GotoXY(67,5);
  Write(Name)
end;

Procedure PrintMan;
begin
  GotoXY(OldX,OldY);
  case OldSpot of
    1 : begin        {blank}
      TextAttr := Black;
      Write(' ')
      end;
    20 : begin       {water}
      TextAttr := LightBlue + Blue * 16 + Blink;
      Write('±')
      end;
    30 : begin       {lever}
      OldSpot := 1;
      TextAttr := LightGray;
      Write('˙')
      end;
  end; {OldSpot case}
  GotoXY(XCord,YCord);
  case NewSpot of
    1 : begin        {normal man}
      TextAttr := Yellow + Red * 16;
      Write(#1)
      end;
    10 : begin       {invisible}
      TextAttr := Black;
      Write(' ')
      end;
    20 : begin       {boat}
      TextAttr := LightMagenta + Blue * 16;
      Write(#4)
      end;
    30 : begin       {using wings}
      TextAttr := Yellow + LightGray * 16;
      Write(#1)
      end;
  end; {NewSpot case}
end;

Procedure BlankLine;                      {clears standard message line}
begin
  Window(1,1,80,25);
  GotoXY(1,25);
  TextAttr := Blue;
  for i := 1 to 64 do Write('€');
  Window(Twx,Twy,Lwx,Lwy)
end;

Procedure SaveStats;
begin
  NewSpot := 1;
  SScore := Score;
  P1 := Chr(Power div 256);
  P2 := Chr(Power mod 256);
  SMagic := Chr(Magic);
  SBombs := Chr(Bombs);
  SKeys := Chr(Keys);
  if LevelNum = 14 then SLevelNum := Chr(12)
    else SLevelNum := Chr(LevelNum);
  SMaxLevel := Chr(MaxLevel);
  SNumItems := Chr(NumItems);
  SLamp := Chr(Lamp);
  SSuperBombs := Chr(SuperBombs);
  SWings := Chr(Wings);
  if LifeStaff then SStaff := Chr(1) else SStaff := Chr(0);
  SXCord := Chr(XCord);
  SYCord := Chr(YCord)
end;

Procedure LoadGateway;
begin
  LevelNum := 1;
  ReadLevel('LEVEL01.dat',27,24);
  HeadMS^.Next := nil;
  LevelName('  Gateway   ');
  Twx := 1;  Twy := 1;
  Lwx := 64; Lwy := 25;
  Walls := Yellow;
  Walls2 := Brown;
  Rail := Red;
  SaveStats;
  Window(Twx,Twy,Lwx,Lwy);
  TextAttr := Yellow;  ClrScr;
  for i := 1 to 1600 do Write('€');
  BlankLine;  {for opening room only}
  DrawLevel(1,1,27,24);
  PrintMan;
  RemKeys
end;

Procedure LoadCity;
begin
  LevelNum := 2;
  if MaxLevel < 2 then MaxLevel := 2;
  ReadLevel('LEVEL02.dat',57,24);
  HeadMS^.Next := nil;
  Window(1,1,7,24);
  TextAttr := Brown * 16;  ClrScr;
  LevelName('City Proper ');
  Twx := 8;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := Yellow;
  Walls2 := Yellow;
  Rail := Red;
  Tun1.x := 21; Tun1.y := 17;
  Tun2.x := 26; Tun2.y := 13;
  Tun3.x := 29; Tun3.y := 2;
  Tun4.x := 44; Tun4.y := 21;
  SaveStats;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,57,24);
  PrintMan;
  RemKeys
end;

Procedure LoadTower1;
begin
  LevelNum := 3;
  if MaxLevel < 3 then MaxLevel := 3;
  ReadLevel('LEVEL03.dat',19,19);
  LevelName(' The Tower  ');
  Twx := 29; Twy := 5;
  Lwx := 48; Lwy := 24;
  Walls := LightBlue;
  Tun1.x := 12; Tun1.y := 6;
  Tun2.x := 15; Tun2.y := 3;
  XTrap := 3;
  YTrap := 16;
  SaveStats;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,19,19);
  PrintMan;
  RemKeys
end;

Procedure LoadTower2;
begin
  LevelNum := 4;
  if MaxLevel < 4 then MaxLevel := 4;
  ReadLevel('LEVEL04.dat',19,19);
  LevelName(' The Tower  ');
  Twx := 27; Twy := 4;
  Lwx := 46; Lwy := 23;
  Walls := LightGreen;
  Walls2 := Brown;
  SaveStats;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,19,19);
  PrintMan;
  RemKeys
end;

Procedure LoadTower3;
begin
  LevelNum := 5;
  if MaxLevel < 5 then MaxLevel := 5;
  ReadLevel('LEVEL05.dat',19,19);
  LevelName(' The Tower  ');
  Twx := 25; Twy := 3;
  Lwx := 44; Lwy := 22;
  Walls := LightMagenta;
  SaveStats;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,19,19);
  PrintMan;
  RemKeys
end;

Procedure LoadTower4;
begin
  LevelNum := 6;
  if MaxLevel < 6 then MaxLevel := 6;
  ReadLevel('LEVEL06.dat',19,19);
  LevelName(' The Tower  ');
  Twx := 23; Twy := 2;
  Lwx := 42; Lwy := 21;
  Walls := LightRed;
  Walls2 := LightRed;
  SaveStats;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,19,19);
  PrintMan;
  RemKeys
end;

Procedure LoadCatacombs;
begin
  LevelNum := 7;
  if MaxLevel < 7 then MaxLevel := 7;
  ReadLevel('LEVEL07.dat',42,24);
  LevelName(' Catacombs  ');
  Twx := 9;  Twy := 1;
  Lwx := 64; Lwy := 25;
  Walls := Brown;
  Walls2 := Brown;
  Tun1.x := 25; Tun1.y := 21;
  Tun2.x := 25; Tun2.y := 4;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := Brown * 16;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,42,24);
  PrintMan;
  RemKeys
end;

Procedure LoadTunnels;
begin
  LevelNum := 8;
  if MaxLevel < 8 then MaxLevel := 8;
  ReadLevel('LEVEL08.dat',33,17);
  LevelName('  Tunnels   ');
  Twx := 16; Twy := 4;
  Lwx := 50; Lwy := 21;
  Walls := Brown;
  Walls2 := Brown;
  Tun1.x := 5;  Tun1.y := 11;
  Tun2.x := 11; Tun2.y := 2;
  Tun3.x := 10; Tun3.y := 13;
  Tun4.x := 6;  Tun4.y := 6;
  Moves := -3;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := Brown * 16;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,33,17);
  PrintMan;
  RemKeys
end;

Procedure LoadPits;
begin
  LevelNum := 9;
  if MaxLevel < 9 then MaxLevel := 9;
  ReadLevel('LEVEL09.dat',30,17);
  LevelName('  The Pits  ');
  Twx := 17; Twy := 4;
  Lwx := 48; Lwy := 21;
  {no walls in level}
  Tun1.x := 9;  Tun1.y := 11;
  Tun2.x := 9;  Tun2.y := 5;
  Tun3.x := 23; Tun3.y := 13;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(13,6,18,12);
  PrintMan;
  RemKeys
end;

Procedure LoadStair1;
begin
  LevelNum := 10;
  if MaxLevel < 10 then MaxLevel := 10;
  ReadLevel('LEVEL10.dat',15,15);
  LevelName('Spiral Stair');
  Twx := 10; Twy := 5;
  Lwx := 25; Lwy := 20;
  Walls := Green;
  Tun1.x := 4; Tun1.y := 8;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,15,15);
  PrintMan;
  RemKeys
end;

Procedure LoadStair2;
begin
  LevelNum := 11;
  if MaxLevel < 11 then MaxLevel := 11;
  ReadLevel('LEVEL11.dat',15,15);
  LevelName('Spiral Stair');
  Twx := 10; Twy := 5;
  Lwx := 25; Lwy := 20;
  Walls := Blue;
  Walls2 := Brown;
  Tun1.x := 8; Tun1.y := 10;
  Tun2.x := 4; Tun2.y := 4;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,15,15);
  PrintMan;
  RemKeys
end;

Procedure LoadStair3;
begin
  LevelNum := 12;
  if MaxLevel < 12 then MaxLevel := 12;
  ReadLevel('LEVEL12.dat',45,17);
  LevelName('Spiral Stair');
  Twx := 10; Twy := 5;
  Lwx := 54; Lwy := 22;
  Walls := LightBlue;
  Walls2 := LightBlue;
  Tun1.x := 2;  Tun1.y := 13;
  Tun2.x := 11; Tun2.y := 2;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,15,15);
  PrintMan;
  RemKeys
end;

Procedure LoadStair4;
begin
  LevelNum := 13;
  if MaxLevel < 13 then MaxLevel := 13;
  ReadLevel('LEVEL13.dat',15,15);
  LevelName('Spiral Stair');
  Twx := 10; Twy := 5;
  Lwx := 25; Lwy := 20;
  Walls := LightRed;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,15,15);
  PrintMan;
  RemKeys
end;

Procedure LoadCave;
begin
  ReadLevel('LEVEL14.dat',21,24);
  LevelName('Secret Cave ');
  XCord := 11;
  YCord := 23;
  OldX := XCord;
  OldY := YCord;
  Twx := 21; Twy := 1;
  Lwx := 42; Lwy := 25;
  Walls := Brown;
  Walls2 := Brown;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,6,21,24);
  PrintMan;
  RemKeys
end;

Procedure LoadRiver;
begin
  LevelNum := 15;
  if MaxLevel < 15 then MaxLevel := 15;
  ReadLevel('LEVEL15.dat',64,24);
  LevelName('River Rapids');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := Brown;
  Tun1.x := 44; Tun1.y := 12;
  Tun2.x := 51; Tun2.y := 3;
  Tun3.x := 45; Tun3.y := 12;
  Tun4.x := 27; Tun4.y := 15;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,6,15,12);
  PrintMan;
  RemKeys
end;

Procedure LoadFalls;
begin
  LevelNum := 16;
  if MaxLevel < 16 then MaxLevel := 16;
  ReadLevel('LEVEL16.dat',51,24);
  LevelName(' Waterfalls ');
  Twx := 8;  Twy := 1;
  Lwx := 59; Lwy := 25;
  Walls := Brown;
  SaveStats;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,51,15);
  DrawLevel(1,16,35,24);
  PrintMan;
  RemKeys
end;

Procedure LoadLagoon;
begin
  LevelNum := 17;
  if MaxLevel < 17 then MaxLevel := 17;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL17.dat',64,24);
  LevelName('   Lagoon   ');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := Brown;
  Walls2 := Brown;
  Tun1.x := 38; Tun1.y := 15;
  Tun2.x := 2;  Tun2.y := 23;
  Tun3.x := 10; Tun3.y := 11;
  Tun4.x := 37; Tun4.y := 10;
  SaveStats;
  DrawMonsters := TRUE;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,64,24);
  PrintMan;
  RemKeys
end;

Procedure LoadStorm;
begin
  LevelNum := 18;
  if MaxLevel < 18 then MaxLevel := 18;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL18.dat',64,24);
  LevelName('ThunderStorm');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := LightGray;
  Walls2 := LightGray;
  Rail := LightRed;
  SaveStats;
  DrawMonsters := FALSE;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(XCord - 3,YCord - 2,XCord + 3,YCord + 2);
  PrintMan;
  RemKeys
end;

Procedure LoadTemple;
begin
  LevelNum := 19;
  if MaxLevel < 19 then MaxLevel := 19;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL19.dat',64,24);
  LevelName('   Temple   ');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := LightBlue;
  Walls2 := LightBlue;
  Tun1.x := 64; Tun1.y := 15;
  Tun2.x := 33; Tun2.y := 9;
  SaveStats;
  YesNec := TRUE;
  Nec := 1000;
  DrawMonsters := TRUE;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,64,24);
  PrintMan;
  RemKeys
end;

Procedure LoadLabyrinth;
begin
  LevelNum := 20;
  if MaxLevel < 20 then MaxLevel := 20;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL20.dat',64,24);
  LevelName(' Labyrinth  ');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := Red;
  Walls2 := Red;
  Tun1.x := 19; Tun1.y := 13;
  Tun2.x := 11; Tun2.y := 22;
  Tun3.x := 3;  Tun3.y := 16;
  Tun4.x := 22; Tun4.y := 2;
  SaveStats;
  YesNec := TRUE;
  Nec := 1100;
  DrawMonsters := TRUE;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,64,24);
  PrintMan;
  RemKeys
end;

Procedure LoadSanctum;
begin
  LevelNum := 21;
  if MaxLevel < 21 then MaxLevel := 21;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL21.dat',64,24);
  LevelName('InnerSanctum');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := LightMagenta;
  Walls2 := LightMagenta;
  Tun1.x := 11; Tun1.y := 8;
  Tun2.x := 33; Tun2.y := 3;
  Tun3.x := 49; Tun3.y := 19;
  Tun4.x := 16; Tun4.y := 8;
  SaveStats;
  DrawMonsters := TRUE;
  Window(Twx,Twy,Lwx,Lwy);
  if Access = 0 then                             {Forcefield for}
    for i := 23 to 27 do LevelMat[i,8] := 'Z';   {wrong entrance}
  DrawLevel(1,1,64,24);
  if Access > 1 then Sanctum1;
  PrintMan;
  RemKeys
end;

Procedure Sanctum1;
{specialization for this level}
var OldWalls : integer;
begin
  if not (Access > 0) then EXIT;
  OldWalls := Walls;
  for t := 4 to 34
    do begin
      Walls := Random(15) + 1;
      Sound(t * 10);
      DrawLevel(22,3,28,5);
      PrintMan;
      Delay(50)
    end;
  if Access = 1 then LevelMat[22,3] := ' ' else LevelMat[22,3] := '€';
  if Access = 2 then LevelMat[22,5] := ' ' else LevelMat[22,5] := '€';
  if Access = 3 then LevelMat[28,3] := ' ' else LevelMat[28,3] := '€';
  if Access = 5 then LevelMat[28,5] := ' ' else LevelMat[28,5] := '€';
  Walls := OldWalls;
  DrawLevel(22,3,28,5);
  PrintMan;
  NoSound
end;

Procedure LoadSciLab;
begin
  LevelNum := 22;
  if MaxLevel < 22 then MaxLevel := 22;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL22.dat',64,24);
  LevelName(' Laboratory ');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := LightCyan;
  Walls2 := LightCyan;
  Tun1.x := 10; Tun1.y := 21;
  Tun2.x := 30; Tun2.y := 24;
  SaveStats;
  DrawMonsters := TRUE;
  Window(Twx,Twy,Lwx,Lwy);
  DrawLevel(1,1,64,24);
  PrintMan;
  RemKeys
end;

Procedure LoadTheDark;
begin
  LevelNum := 23;
  if MaxLevel < 23 then MaxLevel := 23;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL23.dat',64,24);
  LevelName('  The Dark  ');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := LightGray;
  Walls2 := LightGray;
  Tun1.x := 30; Tun1.y := 7;
  Tun2.x := 4;  Tun2.y := 7;
  if Access = 0 then begin
      LevelMat[55,18] := '€';
      LevelMat[48,5] := '€'
    end;
  SaveStats;
  YesNec := FALSE;
  DrawMonsters := FALSE;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  PrintMan;
  RemKeys
end;

Procedure LoadTrapHall;
begin
  LevelNum := 24;
  if MaxLevel < 24 then MaxLevel := 24;
  HeadMS^.Next := nil;
  ReadLevel('LEVEL24.dat',64,24);
  LevelName('Hall-o-Traps');
  Twx := 1;  Twy := 1;
  Lwx := 65; Lwy := 25;
  Walls := DarkGray;
  Walls2 := LightGray;
  Tun1.x := 24; Tun1.y := 14;
  Tun2.x := 8;  Tun2.y := 13;
  Tun3.x := 3;  Tun3.y := 20;
  Tun4.x := 33; Tun4.y := 15;
  XTrap := 3;
  YTrap := 3;
  SaveStats;
  DrawMonsters := FALSE;
  Window(1,1,64,24);
  TextAttr := 0;  ClrScr;
  Window(Twx,Twy,Lwx,Lwy);
  if XCord = 3 then begin
      DrawLevel(1,1,21,5);  DrawLevel(10,6,14,12)
    end;
  PrintMan;
  RemKeys
end;

end.  {Levels}
