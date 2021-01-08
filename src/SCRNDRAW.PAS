Program TestScreenDraws;     {written by Michael Rimer on 13 OCT 95}

{Shows sample methods for drawing/erasing screens for "'Merican Adventure"}

Uses Crt, CrtEXTRA;

const NumDraws = 20;

var i, j, k, x, y, z : integer;
    SoundOn : boolean;
    Num : integer;

{-----------------------------------}

Procedure PSound(Tone, Dur : integer);
begin
  if SoundOn
    then Sound(Tone);
  Delay(Dur)
end;

Procedure EraseRectangle(a1,b1,a2,b2 : integer);
  {* Erases Level on outline of rectangle (a1,b1) and (a2,b2)}
begin
  for x := a1 to a2 do
    SC(x,b1,' ',Black);      {top side   }
  for y := b1 + 1 to b2 do
    SC(a1,y,' ',Black);      {left side  }
  for x := a1 + 1 to a2 do
    SC(x,b2,' ',Black);      {bottom side}
  for y := b1 + 1 to b2 - 1 do
    SC(a2,y,' ',Black);      {right side }
end;

Procedure EraseColumnsToCenter(x1,y1,x2,y2 : integer);
var  i1, i2 : integer;   {left/right}

begin
  i1 := x1;      {setup columns at extremes of window}
  i2 := x2;
  while i1 <= i2 do
    begin
      for j := y1 to y2 do
        SC(i1,j,' ',Black);
      for j := y1 to y2 do
        SC(i2,j,' ',Black);
      Inc(i1);
      Dec(i2);
      Delay(10)
    end
end;

Procedure EraseCenterToColumns(x1,y1,x2,y2 : integer);
var  i1, i2 : integer;   {left/right}

begin
  i1 := (x1 + x2) div 2;   {setup columns in middle of window}
  i2 := i1 + 1;
  while i1 >= x1 do
    begin
      for j := y1 to y2 do
        SC(i1,j,' ',Black);
      if i2 <= x2
        then for j := y1 to y2 do
               SC(i2,j,' ',Black);
      Dec(i1);
      Inc(i2);
      Delay(10)
    end
end;

Procedure EraseRowsToCenter(x1,y1,x2,y2 : integer);
var  j1, j2 : integer;   {up/down}

begin
  j1 := y1;      {setup rows at extremes of window}
  j2 := y2;
  while j1 <= j2 do
    begin
      for i := x1 to x2 do
        SC(i,j1,' ',Black);
      for i := x1 to x2 do
        SC(i,j2,' ',Black);
      Inc(j1);
      Dec(j2);
      Delay(25)
    end
end;

Procedure EraseCenterToRows(x1,y1,x2,y2 : integer);
var  j1, j2 : integer;   {up/down}

begin
  j1 := (y1 + y2) div 2;   {setup rows in middle of window}
  j2 := j1 + 1;
  while j1 >= y1 do
    begin
      for i := x1 to x2 do
        SC(i,j1,' ',Black);
      for i := x1 to x2 do
        SC(i,j2,' ',Black);
      if j2 <= y2
        then for i := x1 to x2 do
               SC(i,j2,' ',Black);
      Dec(j1);
      Inc(j2);
      Delay(25)
    end
end;

Procedure EraseCenterOut(x1,y1,x2,y2 : integer);
var  MidX, MidY : integer;

begin
  MidX := (x1 + x2) div 2;  {get middle of window}
  MidY := (y1 + y2) div 2;
  i := MidX;
  j := MidY;
  repeat      {erase squares outward to edge of window}
    EraseRectangle(i,j,(2 * MidX) - i,MidY + (MidX - i));
    Dec(i);
    Dec(j);
    Delay(25)
  until (i < x1) or (j < y1);
  if j < y1
    then begin      {horizontal is larger - erase remaining columns}
           for x := i + 1 to (2 * MidX) - (i + 1) do
             SC(x,y2,' ',Black);
           while i >= x1 do
             begin
               for y := y1 to y2 do
                 SC(i,y,' ',Black);  {erases left/right}
               for y := y1 to y2 do
                 SC((2 * MidX) - i,y,' ',Black);
               Dec(i);
               Delay(20)
             end;
           for y := y1 to y2 do
             SC(x2,y,' ',Black)  {erases last line, in case missed}
         end
    else begin      {vertical is larger - erase remaining rows}
           for y := j + 1 to (2 * MidY) - (j + 1) do
             SC(x2,y,' ',Black);
           while j >= y1 do
             begin
               for x := x1 to x2 do
                 SC(x,j,' ',Black);  {erases up/down}
               for x := x1 to x2 do
                 SC(x,(2 * MidY) - j,' ',Black);
               Dec(j);
               Delay(20)
             end;
           for x := x1 to x2 do
             SC(x,y2,' ',Black)  {erases last line}
         end
end;

Procedure EPullAway(x1,y1,x2,y2 : integer);
begin
  for j := y1 to y2 do
    begin
      for i := x1 to x2 do
        begin
          Window(i,y1,i,y2);
          if Odd(i)
            then DelLine
            else InsLine
        end;
      Delay(25)
    end
end;

Procedure EShrinkCircle(x1,y1, Rad : integer);
  {* Erasing circle converges from borders down to player}
  {* Rad = furthest possible distance from player to corner of screen}
const SCALING : real = 0.65;    {to make elliptical pattern appear as circle}
var R   : integer; {current radius of circle}
    Pos : array[1..24] of integer;
    nX  : integer;

begin
  Window(1,1,64,25);
  for j := 1 to 24 do
    Pos[j] := x1 - Rad;
  for R := Rad downto 1 do
    begin
      for j := 1 to 24 do  {draw changes row by row}
        while (Pos[j] <= 64) and (Sqr(R) <= (Sqr(y1 - j) + (Sqr(x1 - Pos[j]) * SCALING))) do
          begin
            if (Pos[j] >= 1) and (Pos[j] <= 64)
              then begin
                     GotoXY(Pos[j],j);
                     Write(' ')
                   end;
            nX := 2 * x1 - Pos[j];
            if (nX >= 1) and (nX <= 64)
              then begin
                     GotoXY(nX,j);
                     Write(' ')
                   end;
            Inc(Pos[j])
          end;
      Delay(15)
    end
end;

Procedure EExpandCircle(x1,y1, Rad : integer);
  {* Erasing circle converges from player out to borders}
  {* Rad = furthest possible distance from player to corner of screen}
const SCALING : real = 0.65;    {to make elliptical pattern appear as circle}
var R   : integer; {current radius of circle}
    Pos : array[1..24] of integer;
    nX  : integer;

begin
  Window(1,1,64,25);
  for j := 1 to 24 do
    Pos[j] := x1;
  for R := 1 to Rad do
    begin
      for j := 1 to 24 do     {draw changes row by row}
        while (Pos[j] >= 1) and (Sqr(R) >= (Sqr(y1 - j) + (Sqr(x1 - Pos[j]) * SCALING))) do
          begin
            if (Pos[j] >= 1) and (Pos[j] <= 64)
              then begin
                     GotoXY(Pos[j],j);
                     Write(' ')
                   end;
            nX := 2 * x1 - Pos[j];
            if (nX >= 1) and (nX <= 64)
              then begin
                     GotoXY(nX,j);
                     Write(' ')
                   end;
            Dec(Pos[j])
          end;
      Delay(15)
    end
end;

Procedure ESlideDown;
begin
  Window(1,1,64,24);
  for i := 1 to 24 do
    begin
      InsLine;
      Delay(15)
    end
end;

Procedure ESlideUp;
begin
  Window(1,1,64,24);
  for i := 1 to 24 do
    begin
      DelLine;
      Delay(15)
    end;
end;

Procedure EFoldRight;
begin
  for i := 1 to 64 do
    begin
      for j := 1 to 24 do
        SC(i,j,' ',Black);
      Delay(7)
    end                   
end;

Procedure EFoldLeft;
begin
  for i := 64 downto 1 do
    begin
      for j := 1 to 24 do
        SC(i,j,' ',Black);
      Delay(7)
    end
end;

Procedure DissolveScreen;
begin
  Window(1,1,64,25);
  for i := 1 to 3000 do
    begin
      GotoXY(Random(64),Succ(Random(24)));
      Write('  ');
      Delay(1)
    end;
  Window(1,1,64,24);
  ClrScr
end;

Procedure Erase8Columns;
begin
  for i := 1 to 8 do
    for j := 0 to 7 do
      begin
        Window(j * 8 + i,1,j * 8 + i,24);
        for z := 1 to 24 do
          DelLine;
        Delay(7)
      end;
end;

Procedure Erase6Rows;
begin
  for i := 1 to 6 do
    for j := 0 to 3 do
      begin
        Window(1,j * 6 + i,64,j * 6 + i);
        for z := 1 to 64 do
          Write(' ');
        Delay(20)
      end;
end;

Procedure EScatter5;
begin
  j := 0;
  for i := 0 to 1700 do
    begin
      if (i mod 128) = 0
        then Inc(j);
      SC((i mod 64) + 1,(j mod 24) + 1,' ',Black);
      Inc(j,5);
      Delay(1)
    end;
end;

Procedure ESlideUpColumns;
begin
  for i := 1 to 64 do
    begin
      Window(1,1,i,24);
      DelLine;
      Delay(20)
    end;
  for i := 1 to 24 do
    begin
      Window(24 + i,1,64,24);
      DelLine;
      Delay(20)
    end;
end;

Procedure ESlideDownColumns;
begin
  for i := 1 to 64 do
    begin
      Window(1,1,i,24);
      InsLine;
      Delay(20)
    end;
  for i := 1 to 24 do
    begin
      Window(24 + i,1,64,24);
      InsLine;
      Delay(20)
    end;
end;

Procedure EOozeDown;
var H : array[1..64] of integer;
    N : integer;
    Done : boolean;

begin
  for i := 1 to 64 do H[i] := 24;

  for j := 1 to 25 do    {pull down jagged columns}
    begin
      for i := 1 to 64 do
        if H[i] > 0
          then begin
                 N := Random(3);
                 Window(i,25 - H[i],i,24);
                 for k := 1 to N do
                   InsLine;
                 Dec(H[i],N)
               end;
      Delay(15)
    end;

  repeat
    Done := TRUE;
    for i := 1 to 64 do
      if H[i] > 0
        then begin
               Done := FALSE;
               Window(i,25 - H[i],i,24);
               InsLine;
               Dec(H[i])
             end;
    Delay(15)
  until Done
end;

Procedure EOozeUp;
var H : array[1..64] of integer;
    N : integer;
    Done : boolean;

begin
  for i := 1 to 64 do H[i] := 0;

  for j := 1 to 25 do    {pull up jagged columns}
    begin
      for i := 1 to 64 do
        if H[i] < 24
          then begin
                 N := Random(3);
                 Window(i,1,i,24);
                 for k := 1 to N do
                   DelLine;
                 Inc(H[i],N)
               end;
      Delay(15)
    end;

  repeat
    Done := TRUE;
    for i := 1 to 64 do
      if H[i] < 24
        then begin
               Done := FALSE;
               Window(i,1,i,25 - H[i]);
               DelLine;
               Inc(H[i])
             end;
    Delay(15)
  until Done
end;

Procedure BlankBoard(x1,y1,x2,y2, Num : integer);
  {* Randomly calls special level-erasing routines}
begin
  Window(1,1,80,25);   {redraw screen area in window}
  TextAttr := Blue * 16;
  ClrScr;
  Window(1,1,64,25);
  for i := 1 to 64 do
    for j := 1 to 24 do
      SC(i,j,Chr(Random(256)),Random(256));
  Window(1,1,64,24);
  TextAttr := 0;

  case Num of
    1 : EraseColumnsToCenter(x1,y1,x2,y2);
    2 : EraseCenterToColumns(x1,y1,x2,y2);
    3 : EraseRowsToCenter(x1,y1,x2,y2);
    4 : EraseCenterToRows(x1,y1,x2,y2);
    5 : EraseCenterOut(x1,y1,x2,y2);
    6 : EPullAway(x1,y1,x2,y2);
    7 : EShrinkCircle(Random(64) + 1,Random(24) + 1,67);
    8 : EExpandCircle(Random(64) + 1,Random(24) + 1,67);
    9 : ESlideDown;
   10 : ESlideUp;
   11 : EFoldRight;
   12 : EFoldLeft;
   13 : DissolveScreen;
   14 : Erase8Columns;
   15 : Erase6Rows;
   16 : EScatter5;
   17 : ESlideUpColumns;
   18 : ESlideDownColumns;
   19 : EOozeDown;
   20 : EOozeUp;
  end; {case (20)}
  NoSound
end;

Procedure Menu;
begin
  Window(1,1,80,25);
  TextAttr := LightGray;
  ClrScr;
  Writeln('GAME LEVEL DRAW ROUTINES');
  Writeln;
  Writeln(' 1> Columns to Center   11> Fold Right');
  Writeln(' 2> Center to Columns   12> Fold Left');
  Writeln(' 3> Rows to Center      13> Dissolve Screen');
  Writeln(' 4> Center to Rows      14> Erase 8 Columns');
  Writeln(' 5> Center Out          15> Erase 6 Rows');
  Writeln(' 6> Pull Away           16> Scatter 5');
  Writeln(' 7> Shrink Circle       17> Slide Up Columns');
  Writeln(' 8> Expand Circle       18> Slide Down Columns');
  Writeln(' 9> Slide Down          19> Ooze Down');
  Writeln('10> Slide Up            20> Ooze Up');
  Writeln;
  Write('Choose a number (0 - ',NumDraws,'): ')
end;

Begin  (*MAIN PROG*)
  Randomize;
  SoundOn := FALSE;
  repeat
    Menu;
    repeat
      Readln(Num)
    until (Num in [0..NumDraws]);
    BlankBoard(1,1,64,24,Num);
  until Num = 0
End.  {TestScreenDraws}
