Unit MerCrt;    {created by Michael Rimer - begun 16 APR 94}

(* Contains vars/procedures involving screen effects  *)
(* for games in the "Merican" series                  *)

(*********************)
(***)  Interface  (***)
(*********************)

Uses VntrVars, Crt, CrtEXTRA;

type
  ProcObj  = object
               Alg : Procedure(Param1, Param2 : integer);
             end;
  LevelMat = array[1..64,1..24] of char;

var
  DLevel   : ProcObj;  {proc to draw level}
  TempNum,
  LevelNum : byte;
  Level    : LevelMat;  {level array}

{* Write messages to bottom line of screen}

  Procedure BlankLine;
  Procedure WhiteMessage(Str : string);
  Procedure BlueMessage(Str : string);
  Procedure GoldMessage(Str : string);
  Procedure Message(Str : string);
  Function  OPMessage(Str, Choices : string) : char;

{* Draw level (x1,y1) to (x2,y2) in normal way}

  Procedure UpdateCords(var x1,y1,x2,y2 : integer);
  Procedure DrawLevel  (x1,y1,x2,y2 : integer);

{* Draw level in Window (x1,y1) to (x2,y2) onto screen in various ways}

  Procedure PrintRectangle (a1,b1,a2,b2 : integer);
  Procedure DrawColumnsToCenter(x1,y1,x2,y2 : integer);
  Procedure DrawCenterToColumns(x1,y1,x2,y2 : integer);
  Procedure DrawRowsToCenter(x1,y1,x2,y2 : integer);
  Procedure DrawCenterToRows(x1,y1,x2,y2 : integer);
  Procedure DrawCenterOut  (x1,y1,x2,y2 : integer);
{ Procedure DrawInToCenter(x1,y1,x2,y2 : integer);     }
  Procedure FillBoard(x1,y1,x2,y2 : integer);

{* Blank screen in various ways}

  Procedure BlankBoard(x1,y1,x2,y2 : integer);

(**************************)
(***)  Implementation  (***)
(**************************)

Procedure BlankLine;
  {* Restores solid bottom line}
begin
  Window(1,25,64,25);
  TextAttr := Blue * 16;
  ClrScr;
  Window(1,1,80,25)
end;

Procedure WhiteMessage(Str : string);
  {* Writes message in White}
begin
  BlankLine;
  GotoXY((64 - Length(Str)) div 2 + 1,25);
  TextAttr := White;
  Write(Str)
end;

Procedure BlueMessage(Str : string);
var  Key : char;
begin
  repeat
    GotoXY(((80 - Length(Str)) div 2) + 1,25);
    TextAttr := Random(14) + 2 + Blue * 16;
    Write(Str);
    Delay(15)
  until KeyPressed;
  Key := ReadKey;
  TextAttr := White + Blue * 16
end;

Procedure GoldMessage(Str : string);
  {* Flashes golden message along bottom line of screen}
begin
  BlankLine;
  RemKeys;
  repeat
    GotoXY(((65 - Length(Str)) div 2) + 1,25);
    repeat
      TextAttr := Random(9) + 7
    until (TextAttr in [7,14,15]);  {light gray/yellow/white}
    Write(Str);
    Delay(10)
  until KeyPressed;
  BlankLine
end;

Procedure Message(Str : string);
  {* Flashes message along bottom line of screen}
begin
  BlankLine;
  RemKeys;
  repeat
    GotoXY(((65 - Length(Str)) div 2) + 1,25);
    TextAttr := Random(15) + 1;
    Write(Str);
    Delay(25)
  until KeyPressed;
  BlankLine
end;

Function OPMessage(Str, Choices : string) : char;
  {* Prompts player for character response, which must be in Choices}
var Ch : char;     {response entered by player}
begin
  BlankLine;
  RemKeys;
  repeat  
    repeat
      GotoXY(((65 - Length(Str)) div 2) + 1,25);
      TextAttr := Random(15) + 1;
      Write(Str);
      Delay(25)
    until KeyPressed;
    Ch := UpCase(ReadKey)
  until Pos(Ch,Choices) <> 0;   {character entered must be in string Choices}
  BlankLine;
  OPMessage := Ch
end;

Procedure UpdateCords(var x1,y1,x2,y2 : integer);
  {* Makes sure drawing window is inside screen}
begin
  if x1 < 1  then x1 := 1;
  if y1 < 1  then y1 := 1;
  if x2 > 64 then x2 := 64;
  if y2 > 24 then y2 := 24
end;

Procedure DrawLevel(x1,y1,x2,y2 : integer);
  {* Draws current level from (x1,y1) to (x2,y2) on screen}
  {* Using Procedure DLevel.Alg}
var  x, y : integer;  {counter variables}
begin
  if ((x1 < 1) or (y1 < 1) or (x2 > 64) or (y2 > 24)) {window out of bounds}
    then UpdateCords(x1,y1,x2,y2);   {fit window to screen edges}

  for y := y1 to y2 do    {y = each row}
    for x := x1 to x2 do  {x = each char in row}
      DLevel.Alg(x,y)     {draw char at (x,y)}
end;

Procedure PrintRectangle(a1,b1,a2,b2 : integer);
  {* Draws Level on outline of rectangle (a1,b1) and (a2,b2)}
begin
  DrawLevel(a1,b1,a2,b1);          {top side   }
  DrawLevel(a1,b1 + 1,a1,b2);      {left side  }
  DrawLevel(a1 + 1,b2,a2,b2);      {bottom side}
  DrawLevel(a2,b1 + 1,a2,b2 - 1)   {right side }
end;

Procedure DrawColumnsToCenter(x1,y1,x2,y2 : integer);
var  i1, i2 : integer;   {left/right}
begin
  i1 := x1;      {setup columns at extremes of window}
  i2 := x2;
  while i1 <= i2 do
    begin
      DrawLevel(i1,y1,i1,y2);
      DrawLevel(i2,y1,i2,y2);
      Inc(i1);
      Dec(i2)
    end
end;

Procedure DrawCenterToColumns(x1,y1,x2,y2 : integer);
var  i1, i2 : integer;   {left/right}
begin
  i1 := (x1 + x2) div 2;   {setup columns in middle of window}
  i2 := i1 + 1;
  while i1 >= x1 do
    begin
      DrawLevel(i1,y1,i1,y2);
      if i2 <= x2
        then DrawLevel(i2,y1,i2,y2);
      Dec(i1);
      Inc(i2)
    end
end;

Procedure DrawRowsToCenter(x1,y1,x2,y2 : integer);
var  j1, j2 : integer;   {up/down}
begin
  j1 := y1;      {setup rows at extremes of window}
  j2 := y2;
  while j1 <= j2 do
    begin
      DrawLevel(x1,j1,x2,j1);
      DrawLevel(x1,j2,x2,j2);
      Inc(j1);
      Dec(j2)
    end
end;

Procedure DrawCenterToRows(x1,y1,x2,y2 : integer);
var  j1, j2 : integer;   {up/down}
begin
  j1 := (y1 + y2) div 2;   {setup rows in middle of window}
  j2 := j1 + 1;
  while j1 >= y1 do
    begin
      DrawLevel(x1,j1,x2,j1);
      if j2 <= y2
        then DrawLevel(x1,j2,x2,j2);
      Dec(j1);
      Inc(j2)
    end
end;

Procedure DrawCenterOut(x1,y1,x2,y2 : integer);
var  MidX, MidY : integer;
begin
  MidX := (x1 + x2) div 2;  {get middle of window}
  MidY := (y1 + y2) div 2;
  i := MidX;
  j := MidY;
  repeat      {fill squares outward to edge of window}
    PrintRectangle(i,j,(2 * MidX) - i,MidY + (MidX - i));
    Dec(i);
    Dec(j)
  until (i < x1) or (j < y1);
  if j < y1
    then begin      {horizontal is larger - draw remaining columns}
           DrawLevel(i + 1,y2,(2 * MidX) - (i + 1),y2);
           while i >= x1 do
             begin
               DrawLevel(i,y1,i,y2);  {draws left/right}
               DrawLevel((2 * MidX) - i,y1,(2 * MidX) - i,y2);
               Dec(i)
             end;
           DrawLevel(x2,y1,x2,y2)  {draws last line, in case missed}
         end
    else begin      {vertical is larger - draw remaining rows}
           DrawLevel(x2,j + 1,x2,(2 * MidY) - (j + 1));
           while j >= y1 do
             begin
               DrawLevel(x1,j,x2,j);  {draws up/down}
               DrawLevel(x1,(2 * MidY) - j,x2,(2 * MidY) - j);
               Dec(j)
             end;
           DrawLevel(x1,y2,x2,y2)  {draws last line}
         end
end;

(*  Procedure DrawInToCenter(x1,y1,x2,y2 : integer);
var  MidX, MidY : integer;
begin
  MidX := (x1 + x2) div 2;
  MidY := (y1 + y2) div 2;
  
  if MidY - y1 < MidX - x1
    then begin                      {horiz is larger - draw columns}
           DrawLevel(x2,y1,x2,y2);
           i := x1 - 1;
         
         end
    else begin                      {vert is larger - draw rows}
           DrawLevel(x1,y2,x2,y2);
           j := y1 - 1;

         end;
              {fill squares outward}
end;  *)

Procedure FillBoard(x1,y1,x2,y2 : integer);
  {* Randomly calls special screen-drawing routines}
begin
  Window(1,1,80,25);   {redraw screen area in window}             
  UpdateCords(x1,x2,y1,y2);    {check bounds}
  case (Random(5) + 1) of
    1 : DrawColumnsToCenter(x1,y1,x2,y2);
    2 : DrawCenterToColumns(x1,y1,x2,y2);
    3 : DrawRowsToCenter(x1,y1,x2,y2);
    4 : DrawCenterToRows(x1,y1,x2,y2);
    5 : DrawCenterOut  (x1,y1,x2,y2);
(*  6 : DrawInToCenter(x1,y1,x2,y2);  *)
  end; {case (5)}
end;

Procedure BlankBoard(x1,y1,x2,y2 : integer);
  {* Clears screen from (x1,y1) to (x2,y2), outward from middle}
var  MidX, MidY : integer;  {middle point of space to clear}
begin
  MidX := (x1 + x2) div 2;
  MidY := (y1 + y2) div 2;

  TextAttr := (Random(6) + 2) * 16;   {color square outward from center}
  if (x1 + x2) > (y1 + y2)
    then for i := MidX downto x1 do
      begin
        if MidY - (MidX - i) < y1
          then Window(i,y1,(2 * MidX) - i,y2)
          else Window(i,MidY - (MidX - i),(2 * MidX) - i,MidY + (MidX - i));
        ClrScr;
        Delay(5)
      end
    else for j := MidY downto y1 do
      begin
        if MidX - (MidY - j) < x1
          then Window(x1,j,x2,(2 * MidY) - j)
          else Window(MidX - (MidY - j),j,MidX + (MidY - j),(2 * MidY) - j);
        ClrScr;
        Delay(5)
      end;
  Window(x1,y1,x2,y2);    {clears all of window, if any missed}
  ClrScr;
  Window(1,1,80,25)
end;

end.  {Unit MerCrt}
