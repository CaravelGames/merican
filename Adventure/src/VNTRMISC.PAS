Unit VntrMisc;    {created by Michael Rimer - begun 16 APR 94}

(* Contains vars/procedures for "The 'Merican Adventure" units *)
(* ALSO:  Screen effects for messages & several level draws    *)

(*********************)
(**)   Interface   (**)
(*********************)

Uses Sounds, VntrVars, Crt, CrtEXTRA;

type
  LevelMatrix = array[1..64,1..24] of byte;  {level storage type}
  ProcObj     = object
                  Alg : Procedure(Param1, Param2 : integer);
                end;

var
  DLevel  : ProcObj;  {proc to draw level}
  TempNum : byte;

{* Write messages to bottom line of screen}

  Procedure BlankLine;
  Procedure WhiteMessage(Str : string);
  Procedure BlueMessage(Str : string);
  Procedure GoldMessage(Str : string);
  Procedure Message(Str : string);
  Function  OPMessage(Str, Choices : string) : char;

  Procedure FillWindow(x1, y1, x2, y2 : integer; Chr : char; Col : byte);
  Procedure FillWindowWithHole(x1, y1, x2, y2 : integer;
                  hx1, hy1, hx2, hy2 : integer; Chr : char; Col : byte);

  Procedure SolidWindow(x1, y1, x2, y2 : integer);

{* Player beginning new level}
  Procedure SaveSpecials;
  Procedure DisposeSpecData;
  Procedure RestoreSpecials;

  Procedure UpdateScore;
  Procedure UpdateStats;
  Procedure DisposeMonsters;
  Procedure NewMonster(mx, my, MSpec : byte);
  Procedure DisposeMvgObjs;
  Procedure NewMvgObj(mx, my, MSpec : byte);
  Procedure DisposeItems;
  Procedure NewItem(ix, iy : byte; ISpec, Cust : byte; IType : ItemType);

  Procedure MB;
  Procedure MU;
  Function  SymX(x : integer) : integer;
  Function  SymY(y : integer) : integer;

{* Draw level (x1,y1) to (x2,y2) in normal way}

  Procedure WindowBoundsCheck(var x1,y1,x2,y2 : integer);
  Procedure WindowBoundsCheckW(var x1,y1,x2,y2 : word);
  Procedure DrawLevel(x1,y1,x2,y2 : integer);

{* Draw level in Window (x1,y1) to (x2,y2) onto screen in various ways}

  Procedure PrintRectangle(a1,b1,a2,b2 : word);
  Procedure DrawColumnsToCenter(x1,y1,x2,y2 : word);
  Procedure DrawCenterToColumns(x1,y1,x2,y2 : word);
  Procedure DrawRowsToCenter(x1,y1,x2,y2 : word);
  Procedure DrawCenterToRows(x1,y1,x2,y2 : word);
  Procedure DrawCenterOut(x1,y1,x2,y2 : word);
  Procedure ShrinkCircle(x1,y1, Rad : word);
  Procedure ExpandCircle(x1,y1, Rad : word);
  Procedure Draw8Columns;
  Procedure Draw6Rows;
  Procedure DScatter5;
{ Procedure DrawInToCenter(x1,y1,x2,y2 : word);     }

  Procedure FillBoard(x1,y1,x2,y2 : word);

{* Blank screen in various ways}

    Procedure EraseRectangle(a1,b1,a2,b2 : word);
  Procedure EraseColumnsToCenter(x1,y1,x2,y2 : word);
  Procedure EraseCenterToColumns(x1,y1,x2,y2 : word);
  Procedure EraseRowsToCenter(x1,y1,x2,y2 : word);
  Procedure EraseCenterToRows(x1,y1,x2,y2 : word);
  Procedure EraseCenterOut(x1,y1,x2,y2 : word);
  Procedure EPullAway(x1,y1,x2,y2 : word);
  Procedure EShrinkCircle(x1,y1, Rad : word);
  Procedure EExpandCircle(x1,y1, Rad : word);
  Procedure ESlideDown;
  Procedure ESlideUp;
  Procedure EFoldRight;
  Procedure EFoldLeft;
  Procedure DissolveScreen;
  Procedure Erase8Columns;
  Procedure Erase6Rows;
  Procedure EScatter5;
  Procedure ESlideUpColumns;
  Procedure ESlideDownColumns;
  Procedure EOozeDown;
  Procedure EOozeUp;

  Procedure BlankBoard(x1,y1,x2,y2 : word);

(**************************)
(**)   Implementation   (**)
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
  GotoXY((65 - Length(Str)) div 2 + 1,25);
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
  while KeyPressed do Key := ReadKey; {eat keypress}
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
  while KeyPressed do ReadKey; {eat keypress}
  BlankLine
end;

Procedure Message(Str : string);
  {* Flashes message along bottom line of screen}
var C  : Word;
    Ch : char;

begin
  BlankLine;  NoSound;
  RemKeys;
  C := 0;
  repeat
    Inc(C);
    GotoXY(((65 - Length(Str)) div 2) + 1,25);
    TextAttr := Random(15) + 1;
    Write(Str);
    Delay(25);
    if KeyPressed and (C < 10)     {delays ending of message}
      then repeat Ch := ReadKey until (not KeyPressed)
  until KeyPressed;
  BlankLine;
  while KeyPressed do Ch := ReadKey; {eat keypress}
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

Procedure FillWindow(x1, y1, x2, y2 : integer; Chr : char; Col : byte);
  {* Fills specified area with given character and color}
begin
  for i := x1 to x2 do
    for j := y1 to y2 do
      SC(i,j, Chr,Col)
end;

Procedure FillWindowWithHole(x1, y1, x2, y2 : integer;
     hx1, hy1, hx2, hy2 : integer;
     Chr : char; Col : byte);
  {* Fills specified area, except in second region, with given character and color}
begin
  for i := x1 to x2 do
    for j := y1 to y2 do
      if (i < hx1) or (i > hx2) or (j < hy1) or (j > hy2)  {only draw outside the hole}
        then SC(i,j, Chr,Col)
end;

Procedure SolidWindow(x1, y1, x2, y2 : integer);
  {* Draws a window widget on screen and puts cursor in top-left corner}
begin
  Window(x1,y1,x2,y2 + 1);
  for i := y1 to y2 do
    begin
      TextAttr := DarkGray + LightGray * 16;
      Write('Ý');
      for j := (x1 + 1) to (x2 - 1) do
        Write(' ');
      TextAttr := White + LightGray * 16;
      Write('Þ')
    end;
  Window(x1+1,y1,x2-1,y2 + 1)
end;

{--------------------}

Procedure SaveSpecials;
  {* Saves definitions of special items into text file}
var Trav   : SpecItemPtr;
    sf, nf : text;
    C : char;
    N : integer;
    S : string;

begin
  Assign(sf,DataFile + '.spc');
  Assign(nf,DataFile + '.old');
  Reset(sf);
  Rewrite(nf);
  repeat    {find current level in file}
    repeat
      Read(sf,C);
      if C <> '*'
        then begin
          Readln(sf,S);
          Writeln(nf,C + S)
        end
        else Write(nf,'*');
    until C = '*';
    Read(sf,N);  Write(nf,N);
    if N <> LevelNum
      then begin
             Readln(sf,S);
             Writeln(nf,S)
           end;
  until N = LevelNum;

  Readln(sf,S);  Writeln(nf,S);  {write new level data}
  for i := 1 to 9 do
    begin
      Writeln(nf,'#',i);
      Writeln(nf,Specials[i].IType,' ',Specials[i].MoveOn,' ',
                 Specials[i].Chr,' ',Specials[i].Color);
      Trav := Specials[i].Item;
      while Trav <> nil do
        begin
          Writeln(nf,Trav^.data);
          Trav := Trav^.next
        end
    end;

  repeat        {skip old level data}
    Read(sf,C);
    if C <> '*' then Readln(sf,S);
  until C = '*';
  Write(nf,'*');

  while (not Eof(sf)) do  {copy rest of file}
    begin
      Readln(sf,S);
      Writeln(nf,S)
    end;
  Close(sf);  Erase(sf);               {remove old file}
  Close(nf);  Rename(nf,DataFile + '.spc');   {rename modified file}
end;

Procedure DisposeSpecData;
  {* Remove all data strings from special item records}
var Trav, Old : SpecItemPtr;

begin
  for i := 1 to 9 do
    begin
      Trav := Specials[i].Item;
      while Trav <> nil do
        begin
          Old := Trav;
          Trav := Trav^.next;
          Dispose(Old)
        end;
      Specials[i].Item := nil
    end
end;

Procedure RestoreSpecials;
  {* Loads definitions of special items from text file in var Specials}
var Trav, NewData : SpecItemPtr;
    sf : text;
    C : char;
    N : integer;
    S : string;

begin
  Assign(sf,DataFile + '.spc');
  Reset(sf);
  repeat    {find current level in file}
    repeat
      Read(sf,C);
      if C <> '*'
        then Readln(sf);
    until C = '*';
    Readln(sf,N)
  until N = LevelNum;

  DisposeSpecData;
  for i := 1 to 9 do
    begin
      Readln(sf,S);  {#n}
      Read(sf,Specials[i].IType,C,Specials[i].MoveOn,C);
      Readln(sf,Specials[i].Chr,C,Specials[i].Color);
      Trav := nil;
      Read(sf,C);
      while (C <> '#') and (C <> '*') do  {add data (effects) into list}
        begin
          Readln(sf,S);
          S := C + S;
          New(NewData);
          NewData^.Data := S;
          NewData^.next := nil;
          if Trav <> nil
            then Trav^.next := NewData
            else Specials[i].Item := NewData;
          Trav := NewData;
          Read(sf,C)
        end
    end;
  Close(sf)
end;

{--------------------}

Procedure UpdateScore;
begin
  if P.Score < 0 then P.Score := 0;
  TextAttr := White + LightGray * 16;
  GotoXY(71,5);  Write(P.Score:3,'   ');
end;

Procedure UpdateStats;
  {* Rewrite current player info in status bar}

  Procedure PrintHealth;
  begin
    if (P.Health > 9) then Write(P.Health:3,' ')
      else begin
             TextAttr := LightRed + LightGray * 16 + Blink;
             if P.Health <= 0
               then Write('  0') else Write(P.Health:3,' ');
             TextAttr := White + LightGray * 16
           end
  end;

begin
  UpdateScore;
  GotoXY(72,7);  Write(LevelNum:2);
  GotoXY(72,9);  PrintHealth;
  GotoXY(72,11);  Write(P.Sword:2,' ');
  if P.SwordPower > 0 then Write('+',P.SwordPower,' ');
  GotoXY(72,13); Write(P.Magic:2,' ');
  GotoXY(68,15); Write(P.SKeys:2,' ',P.BKeys:3,' ',P.MKeys:3,' ');
end;

Procedure DisposeMonsters;
  {* Remove ALL monsters from monster list (but HeadMonster)}
  {* NOTE: If monsters are on other items, remove them and leave item}
  {* so as not to disrupt landscape of level (e.g. ghosts in walls)}
var  Trav, Old : Monster;

begin
  Trav := HeadMonster^.next;
  while Trav <> nil do
    begin
      Old := Trav;
      Trav := Trav^.next;  {go to next monster}
      if not (Old^.OnItem in [BLANK,Dirt])
        then Level[x,y] := Old^.OnItem;
      Dispose(Old)    {remove previous monster}
    end;
  HeadMonster^.next := nil
end;

Procedure NewMonster(mx, my : byte;        {position}
                     MSpec : byte);        {monster "species"}
{* Creates new monster record, enters data, and inserts into Monster list}
var NewMon : Monster;

begin
  if Level[mx,my] <> MSpec   {ERROR -- other item already occupies spot}
    then EXIT;

  New(NewMon);
  with NewMon^ do  {initialize record}
    begin
      x := mx;
      y := my;
      Next := HeadMonster^.next;   {placed right after dummy}
      Prev := HeadMonster;
      OnItem := BLANK;  {item monster is "standing on"}
      Species := MSpec;
      case Species of   {give values of speed, hits, damage, etc.}
        M1a : begin
               MT := Standard;
               Speed := 18;
               Hits := 1;
               Damage := 1
             end;
        M2a : begin
               MT := Standard;
               Speed := 14;
               Hits := 1;
               Damage := 2
             end;
        M3a : begin
               MT := Standard;
               Speed := 10;
               Hits := 1;
               Damage := 3
             end;
        M1b : begin
               MT := Standard;
               Speed := 17;
               Hits := 2;
               Damage := 1
             end;
        M2b : begin
               MT := Standard;
               Speed := 13;
               Hits := 2;
               Damage := 2
             end;
        M3b : begin
               MT := Standard;
               Speed := 9;
               Hits := 2;
               Damage := 3
             end;
        M1c : begin
               MT := Standard;
               Speed := 16;
               Hits := 3;
               Damage := 1
             end;
        M2c : begin
               MT := Standard;
               Speed := 12;
               Hits := 3;
               Damage := 2
             end;
        M3c : begin
               MT := Standard;
               Speed := 8;
               Hits := 3;
               Damage := 3
             end;

       SM1a : begin
               MT := Smart;
               Speed := 18;
               Hits := 1;
               Damage := 1
             end;
       SM2a : begin
               MT := Smart;
               Speed := 14;
               Hits := 1;
               Damage := 2
             end;
       SM3a : begin
               MT := Smart;
               Speed := 10;
               Hits := 1;
               Damage := 3
             end;
       SM1b : begin
               MT := Smart;
               Speed := 17;
               Hits := 2;
               Damage := 1
             end;
       SM2b : begin
               MT := Smart;
               Speed := 13;
               Hits := 2;
               Damage := 2
             end;
       SM3b : begin
               MT := Smart;
               Speed := 9;
               Hits := 2;
               Damage := 3
             end;
       SM1c : begin
               MT := Smart;
               Speed := 16;
               Hits := 3;
               Damage := 1
             end;
       SM2c : begin
               MT := Smart;
               Speed := 12;
               Hits := 3;
               Damage := 2
             end;
       SM3c : begin
               MT := Smart;
               Speed := 8;
               Hits := 3;
               Damage := 3
             end;

        T1 : begin
               MT := Thief;
               Speed := 8;
               Hits := 1;
               Damage := 1;
               Carrying := BLANK;
             end;
        T2 : begin
               MT := Thief;
               Speed := 6;
               Hits := 1;
               Damage := 2;
               Carrying := BLANK;
             end;
        T3 : begin
               MT := Thief;
               Speed := 4;
               Hits := 1;
               Damage := 3;
               Carrying := BLANK;
             end;

        W1a : begin
               MT := Wizard;
               Speed := 24;
               Hits := 1;
               Damage := 1;
               MoveRound := FIRED;
               WaitTime := 1;
             end;
        W2a : begin
               MT := Wizard;
               Speed := 16;
               Hits := 1;
               Damage := 2;
               MoveRound := FIRED;
               WaitTime := 1;
             end;
        W3a : begin
               MT := Wizard;
               Speed := 8;
               Hits := 1;
               Damage := 3;
               MoveRound := FIRED;
               WaitTime := 1;
             end;
        W1b : begin
               MT := Wizard;
               Speed := 24;
               Hits := 2;
               Damage := 1;
               MoveRound := FIRED;
               WaitTime := 1;
             end;
        W2b : begin
               MT := Wizard;
               Speed := 16;
               Hits := 2;
               Damage := 2;
               MoveRound := FIRED;
               WaitTime := 1;
             end;
        W3b : begin
               MT := Wizard;
               Speed := 8;
               Hits := 2;
               Damage := 3;
               MoveRound := FIRED;
               WaitTime := 1;
             end;

        G1 : begin
               MT := Ghost;
               Speed := 16;
               Hits := 1;
               Damage := 1;
               Visible := TRUE;
             end;
        G2 : begin
               MT := Ghost;
               Speed := 14;
               Hits := 1;
               Damage := 2;
               Visible := TRUE;
             end;
        G3 : begin
               MT := Ghost;
               Speed := 12;
               Hits := 1;
               Damage := 3;
               Visible := TRUE;
             end;
      end {Species case}
    end;  {with NewMon^}
  HeadMonster^.next := NewMon;    {hook new monster into list}
  if NewMon^.next <> nil
    then NewMon^.next^.prev := NewMon
end;

(**********************************)

Procedure DisposeMvgObjs;
  {* Remove ALL items from Items list (but HeadItem)}
var  Trav, Old : MvgObj;
begin
  Trav := HeadMvgObj^.next;
  while Trav <> nil do
    begin
      Old := Trav;
      Trav := Trav^.next;  {go to next monster}
      Dispose(Old)    {remove previous monster}
    end;
  HeadMvgObj^.next := nil
end;

Procedure NewMvgObj(mx, my : byte;         {position}
                     MSpec : byte);        {mvg obj. "species"}
{* Creates new MvgObj record, enters data, and inserts into mvg obj. list}
var NewMObj : MvgObj;

begin
  if Level[mx,my] <> MSpec   {other object already occupies spot}
    then EXIT;

  New(NewMObj);
  with NewMObj^ do
    begin
      x := mx;
      y := my;
      Next := HeadMvgObj^.next;
      Prev := HeadMvgObj;
      OnItem := BLANK;
      Species := MSpec;
      case Species of   {give values of speed, hits, damage, etc.}
       MW1 : begin
               MT := MovingWall;
               Speed := 18;
               HitChance := 65  {65% destroy}
             end;
       MW2 : begin
               MT := MovingWall;
               Speed := 16;
               HitChance := 50  {50% destroy}
             end;
       MW3 : begin
               MT := MovingWall;
               Speed := 14;
               HitChance := 35  {35% destroy}
             end;

       DF1 : begin
               MT := DroppingFloor;
               Speed := 1;      {check every turn}
               Stable := TRUE;  {not loose}
               WaitToFall := 9
             end;
       DF2 : begin
               MT := DroppingFloor;
               Speed := 1;
               Stable := TRUE;
               WaitToFall := 8
             end;
       DF3 : begin
               MT := DroppingFloor;
               Speed := 1;
               Stable := TRUE;
               WaitToFall := 7
             end;

       FB1 : begin
               MT := FallingBlock;
               Speed := 3;
               Hits := 99;  {survives fall}
               Falling := FALSE; {not falling}
               Proximity := 0
             end;
       FB2 : begin
               MT := FallingBlock;
               Speed := 3;
               Hits := 2;  {survives one fall}
               Falling := FALSE;
               Proximity := 1
             end;
       FB3 : begin
               MT := FallingBlock;
               Speed := 3;
               Hits := 1;  {cracks on impact}
               Falling := FALSE;
               Proximity := 0
             end;
      end {Species case}
    end;
  HeadMvgObj^.next := NewMObj;        {hook into list}
  if NewMObj^.next <> nil
    then NewMObj^.next^.prev := NewMObj
end;

(*************************************)

Procedure DisposeItems;
  {* Remove ALL items from Items list (but HeadItem)}
var  Trav, Old : Item;
begin
  Trav := HeadItem^.next;
  while Trav <> nil do
    begin
      Old := Trav;
      Trav := Trav^.next;  {go to next monster}
      Dispose(Old)    {remove previous monster}
    end;
  HeadItem^.next := nil
end;

Procedure NewItem(ix, iy : byte; ISpec, Cust : byte; IType : ItemType);
{* Creates new Item record, enters data, and inserts into item list}
{* QUESTION: Is Cust really only for Lanterns/projectiles?}
var  NewI : Item;

begin
  if Level[ix,iy] <> ISpec   {ERROR -- other item already occupies spot}
    then EXIT;

  New(NewI);
  with NewI^ do
    begin
      x := ix;
      y := iy;
      Next := HeadItem^.next;
      Prev := HeadItem;
      IT := IType;
      Species := ISpec;
      case Species of   {give values of speed, hits, damage, etc.}
       Tree : begin             {morphing}
         CurFrame := 0; FrameNo := 2; FrameSpeed := 15
       end;
       Freeze..Haste : begin
         CurFrame := 0; FrameNo := 2; FrameSpeed := 4
       end;
       InvPotion1..InvPotion2 : begin
         CurFrame := 0; FrameNo := 4; FrameSpeed := 3
       end;
       PowerUp : begin
         CurFrame := 0; FrameNo := 8; FrameSpeed := 2
       end;
       PortalTo, PortalFrom : begin
         CurFrame := 0; FrameNo := 4; FrameSpeed := 5
       end;
       AntiGravity : begin
         CurFrame := 0; FrameNo := 2; FrameSpeed := 3
       end;

       Lantern : case Cust of   {switching}
         1..3 : On := FALSE;
         4..6 : On := TRUE
       end;
       MonZap  : On := FALSE;
       RMonZap : On := FALSE;

       HotSpot, MagicDoor, MagicKey, HealthGem, PowerGem,  {flashing}
       GemPouch, GoldNugget, KStatue, MonGen, RMonGen : Energy := 0;

       MagicSpear : begin       {missile}
               Fired := FALSE;
               if Cust = 5
                 then Erratic := TRUE
                 else Erratic := FALSE;
               Dmg := 5;
               XOff := ((Cust-1) mod 3) - 1;
               YOff := 1 - ((Cust-1) div 3);
               Speed := 2;
               OnItem := BLANK;
             end;
       Fireball : begin
               Fired := TRUE;
               Erratic := FALSE;
               Dmg :=  (Cust div 10) + 1;  Cust := Cust mod 10;
               XOff := (Cust div 3) - 1;
               YOff := (Cust mod 3) - 1;
               Speed := 2;
               OnItem := BLANK;
             end;

      end {Species case}
    end;
  HeadItem^.next := NewI;        {hook into list}
  if NewI^.next <> nil
    then NewI^.next^.prev := NewI
end;

(***************************************)

Procedure MB;
  {* Move Back -- player returns to last location}
begin
  GoKey := 0;   {"extra" movement stops}
  P.x := P.ox;
  P.y := P.oy
end;

Procedure MU;
begin
  P.ox := P.x;
  P.oy := P.y
end;

Function SymX(x : integer) : integer;
  {* Give new position if level is x-reflected}
begin
  if FlipX
    then SymX := 65 - x
    else SymX := x
end;

Function SymY(y : integer) : integer;
  {* Give new position if level is y-reflected}
begin
  if FlipY
    then SymY := 25 - y
    else SymY := y
end;

Procedure WindowBoundsCheck(var x1,y1,x2,y2 : integer);
  {* Makes sure drawing window is inside screen}
begin
  if x1 < 1  then x1 := 1;
  if y1 < 1  then y1 := 1;
  if x2 > 64 then x2 := 64;
  if y2 > 24 then y2 := 24
end;

Procedure WindowBoundsCheckW(var x1,y1,x2,y2 : word);
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
  WindowBoundsCheck(x1,y1,x2,y2);   {fit window to screen edges}

  for y := y1 to y2 do    {y = each row}
    for x := x1 to x2 do  {x = each char in row}
      DLevel.Alg(x,y)     {draw char at (x,y)}
end;

{-----------------------------------------------------------}

Procedure PrintRectangle(a1,b1,a2,b2 : word);
  {* Draws Level on outline of rectangle (a1,b1) and (a2,b2)}
begin
  DrawLevel(a1,b1,a2,b1);          {top side   }
  DrawLevel(a1,b1 + 1,a1,b2);      {left side  }
  DrawLevel(a1 + 1,b2,a2,b2);      {bottom side}
  DrawLevel(a2,b1 + 1,a2,b2 - 1)   {right side }
end;

Procedure DrawColumnsToCenter(x1,y1,x2,y2 : word);
var  i1, i2 : integer;   {left/right}

begin
  i1 := x1;      {setup columns at extremes of window}
  i2 := x2;
  while i1 <= i2 do
    begin
      DrawLevel(i1,y1,i1,y2);
      DrawLevel(i2,y1,i2,y2);
      Inc(i1);
      Dec(i2);
      PSound(i2 * 10,10)
    end
end;

Procedure DrawCenterToColumns(x1,y1,x2,y2 : word);
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
      Inc(i2);
      PSound(i2 * 10,10)
    end
end;

Procedure DrawRowsToCenter(x1,y1,x2,y2 : word);
var  j1, j2 : integer;   {up/down}

begin
  j1 := y1;      {setup rows at extremes of window}
  j2 := y2;
  while j1 <= j2 do
    begin
      DrawLevel(x1,j1,x2,j1);
      DrawLevel(x1,j2,x2,j2);
      Inc(j1);
      Dec(j2);
      PSound(j2 * 10,10)
    end
end;

Procedure DrawCenterToRows(x1,y1,x2,y2 : word);
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
      Inc(j2);
      PSound(j2 * 10,10)
    end
end;

Procedure DrawCenterOut(x1,y1,x2,y2 : word);
var  MidX, MidY : integer;

begin
  MidX := (x1 + x2) div 2;  {get middle of window}
  MidY := (y1 + y2) div 2;
  i := MidX;
  j := MidY;
  repeat      {fill squares outward to edge of window}
    PrintRectangle(i,j,(2 * MidX) - i,MidY + (MidX - i));
    Dec(i);
    Dec(j);
    PSound(j * 10,25)
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

Procedure ShrinkCircle(x1,y1, Rad : word);
  {* Drawing circle converges from borders down to player}
  {* Rad = furthest possible distance from player to corner of screen}
const SCALING : real = 0.55;    {to make elliptical pattern appear as circle}
var R   : integer; {radius of circle}
    Pos : array[1..24] of integer;
    nX  : integer;

begin
  for j := 1 to 24 do
    Pos[j] := P.x - Rad;
  for R := Rad downto 0 do
    begin
      PSound(R * 25 + 35,20);
      for j := 1 to 24 do     {draw changes row by row}
        while (Pos[j] <= 64) and (Sqr(R) <= (Sqr(P.y - j) + (Sqr(P.x - Pos[j]) * SCALING))) do
          begin
            if (Pos[j] >= 1) and (Pos[j] <= 64)
              then DLevel.Alg(Pos[j],j);
            nX := (2 * x1 - Pos[j]);
            if (nX >= 1) and (nX <= 64)
              then DLevel.Alg(nX,j);
            Inc(Pos[j])
          end;
    end
end;

Procedure ExpandCircle(x1,y1, Rad : word);
  {* Drawing circle converges from player out to borders}
  {* Rad = furthest possible distance from player to corner of screen}
const SCALING : real = 0.55;    {to make elliptical pattern appear as circle}
var R   : integer; {radius of circle}
    Pos : array[1..24] of integer;
    nX  : integer;

begin
  for j := 1 to 24 do
    Pos[j] := P.x;
  for R := 0 to Rad do
    begin
      PSound(R * 25 + 35,20);
      for j := 1 to 24 do     {draw changes row by row}
        while (Pos[j] >= P.x - Rad) and (Sqr(R) >= (Sqr(P.y - j) + (Sqr(P.x - Pos[j]) * SCALING))) do
          begin
            if (Pos[j] >= 1) and (Pos[j] <= 64)
              then DLevel.Alg(Pos[j],j);
            nX := (2 * x1 - Pos[j]);
            if (nX >= 1) and (nX <= 64)
              then DLevel.Alg(nX,j);
            Dec(Pos[j])
          end;
    end
end;

Procedure Draw8Columns;
begin
  for i := 1 to 8 do
    for j := 0 to 7 do
      begin
        for z := 1 to 24 do
          DLevel.Alg(j * 8 + i,z);
        PSound(i * 5 + 30,7)
      end;
end;

Procedure Draw6Rows;
begin
  for i := 1 to 6 do
    for j := 0 to 3 do
      begin
        for z := 1 to 64 do
          DLevel.Alg(z,j * 6 + i);
        PSound(i * 5 + 30,20)
      end;
end;

Procedure DScatter5;
begin
  j := 0;
  for i := 0 to 1700 do
    begin
      if (i mod 128) = 0
        then Inc(j);
      DLevel.Alg(i mod 64 + 1,j mod 24 + 1);
      Inc(j,5);
      PSound(i + 35,1)
    end;
  NoSound;
  DrawLevel(1,1,64,24)
end;

{doesn't work}
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

Procedure FillBoard(x1,y1,x2,y2 : word);
  {* Randomly calls special level-drawing routines}
const NumDraws : word = 10;
begin
  WindowBoundsCheckW(x1,x2,y1,y2);    {check bounds}
  Window(1,1,64,24);   {redraw screen area in window}
  Window(1,1,64,24); {kludge}
  case (Random(NumDraws)) of
    0 : DrawColumnsToCenter(x1,y1,x2,y2);
    1 : DrawCenterToColumns(x1,y1,x2,y2);
    2 : DrawRowsToCenter(x1,y1,x2,y2);
    3 : DrawCenterToRows(x1,y1,x2,y2);
    4 : DrawCenterOut  (x1,y1,x2,y2);
    5 : ShrinkCircle(P.x,P.y,67);
    6 : ExpandCircle(P.x,P.y,67);
    7 : Draw8Columns;
    8 : Draw6Rows;
    9 : DScatter5;
(* 10 : DrawInToCenter(x1,y1,x2,y2);  *)
  end; {case (10)}
  NoSound
end;

{--------------------------------------------------------------}

Procedure EraseRectangle(a1,b1,a2,b2 : word);
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

Procedure EraseColumnsToCenter(x1,y1,x2,y2 : word);
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
      PSound(i2 * 10,10)
    end
end;

Procedure EraseCenterToColumns(x1,y1,x2,y2 : word);
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
      PSound(i2 * 10,10)
    end
end;

Procedure EraseRowsToCenter(x1,y1,x2,y2 : word);
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
      PSound(j2 * 10,25)
    end
end;

Procedure EraseCenterToRows(x1,y1,x2,y2 : word);
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
      PSound(i2 * 10,25)
    end
end;

Procedure EraseCenterOut(x1,y1,x2,y2 : word);
  {* Clears screen in area (x1,y1) to (x2,y2), outward from middle}
var  MidX, MidY : integer;  {middle point of space to clear}

begin
  MidX := (x1 + x2) div 2;  {get middle of window}
  MidY := (y1 + y2) div 2;
  i := MidX;
  j := MidY;
  repeat      {erase squares outward to edge of window}
    EraseRectangle(i,j,(2 * MidX) - i,MidY + (MidX - i));
    Dec(i);
    Dec(j);
    PSound(j * 10,25)
  until (i < x1) or (j < y1);
  NoSound;
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
               Delay(10)
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
               Delay(10)
             end;
           for x := x1 to x2 do
             SC(x,y2,' ',Black)  {erases last line}
         end
end;

Procedure EPullAway(x1,y1,x2,y2 : word);
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
      PSound(j * 10,25)
    end
end;

Procedure EShrinkCircle(x1,y1, Rad : word);
  {* Erasing circle converges from borders down to player}
  {* Rad = furthest possible distance from player to corner of screen}
const SCALING : real = 0.55;    {to make elliptical pattern appear as circle}
var R   : integer; {current radius of circle}
    Pos : array[1..24] of integer;
    nX  : integer;

begin
  Window(1,1,64,25);
  for j := 1 to 24 do
    Pos[j] := P.x - Rad;
  for R := Rad downto 0 do
    begin
      PSound(R * 25 + 35,15);
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
    end
end;

Procedure EExpandCircle(x1,y1, Rad : word);
  {* Erasing circle converges from player out to borders}
  {* Rad = furthest possible distance from player to corner of screen}
const SCALING : real = 0.55;    {to make elliptical pattern appear as circle}
var R   : integer; {current radius of circle}
    Pos : array[1..24] of integer;
    nX  : integer;

begin
  Window(1,1,64,25);
  for j := 1 to 24 do
    Pos[j] := P.x;
  for R := 1 to Rad do
    begin
      PSound(R * 25 + 35,15);
      for j := 1 to 24 do     {draw changes row by row}
        while (Pos[j] >= P.x - Rad) and (Sqr(R) >= (Sqr(y1 - j) + (Sqr(x1 - Pos[j]) * SCALING))) do
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
    end
end;

Procedure ESlideDown;
begin
  for i := 1 to 24 do
    begin
      InsLine;
      PSound(i * 10 + 25,15)
    end
end;

Procedure ESlideUp;
begin
  for i := 1 to 24 do
    begin
      DelLine;
      PSound(i * 10 + 25,15)
    end;
end;

Procedure EFoldRight;
begin
  for i := 1 to 64 do
    begin
      for j := 1 to 24 do
        SC(i,j,' ',Black);
      PSound(i * 5 + 30,7)
    end
end;

Procedure EFoldLeft;
begin
  for i := 64 downto 1 do
    begin
      for j := 1 to 24 do
        SC(i,j,' ',Black);
      PSound(i * 5 + 30,7)
    end
end;

Procedure DissolveScreen;
begin
  Window(1,1,64,25);
  for i := 3000 downto 35 do
    begin
      GotoXY(Random(64),Succ(Random(24)));
      Write('  ');
      PSound(i,1)
    end;
  NoSound;
  for i := 1 to 24 do
    begin
      Window(1,i,64,i);
      ClrScr
    end;
end;

Procedure Erase8Columns;
begin
  for i := 1 to 8 do
    for j := 0 to 7 do
      begin
        Window(j * 8 + i,1,j * 8 + i,24);
        for z := 1 to 24 do
          DelLine;
        PSound(i * 5 + 30,7)
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
        PSound(i * 5 + 30,20)
      end;
end;

Procedure EScatter5;
begin
  j := 0;
  for i := 0 to 1700 do
    begin
      if (i mod 128) = 0
        then Inc(j);
      SC(i mod 64 + 1,j mod 24 + 1,' ',Black);
      Inc(j,5);
      PSound(i + 35,1)
    end;
  NoSound;
  for i := 1 to 64 do
    begin
      Window(i,1,i,24);
      ClrScr
    end;
end;

Procedure ESlideUpColumns;
begin
  Snd1 := 1;
  for i := 1 to 64 do
    begin
      Window(1,1,i,24);
      DelLine;
      PSound(Snd1 * 10 + 35,20);
      Inc(Snd1)
    end;
  for i := 1 to 24 do
    begin
      Window(24 + i,1,64,24);
      DelLine;
      PSound(Snd1 * 10 + 35,20);
      Inc(Snd1)
    end;
end;

Procedure ESlideDownColumns;
begin
  Snd1 := 88;
  for i := 1 to 64 do
    begin
      Window(1,1,i,24);
      InsLine;
      PSound(Snd1 * 10 + 35,20);
      Dec(Snd1)
    end;
  for i := 1 to 24 do
    begin
      Window(24 + i,1,64,24);
      InsLine;
      PSound(Snd1 * 10 + 35,20);
      Dec(Snd1)
    end;
end;

Procedure EOozeDown;
var H : array[1..64] of integer;
    N : integer;
    Done : boolean;

begin
  for i := 1 to 64 do H[i] := 24;
  Snd1 := 90;

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
      PSound(Snd1 * 10 + 35,15);
      Dec(Snd1)
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
    PSound(Snd1 * 10 + 35,15);
    Dec(Snd1)
  until Done
end;

Procedure EOozeUp;
var H : array[1..64] of integer;
    N : integer;
    Done : boolean;

begin
  for i := 1 to 64 do H[i] := 0;
  Snd1 := 1;

  for j := 1 to 25 do    {pull up jagged columns}
    begin
      for i := 1 to 64 do
        if H[i] < 24
          then begin
                 N := Random(3);
                 Window(i,1,i,24 - H[i]);
                 for k := 1 to N do
                   DelLine;
                 Inc(H[i],N)
               end;
      PSound(Snd1 * 10 + 35,15);
      Inc(Snd1)
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
    PSound(Snd1 * 10 + 35,15);
    Inc(Snd1)
  until Done
end;

Procedure BlankBoard(x1,y1,x2,y2 : word);
  {* Randomly calls special level-erasing routines}
const NumDraws : word = 20;
begin
  WindowBoundsCheckW(x1,x2,y1,y2);    {check bounds}
  Window(1,1,64,24);   {redraw screen area in window}
  Window(1,1,64,24); {kludge}
  TextAttr := 0;
  case (Random(NumDraws)) of
    0 : EraseColumnsToCenter(x1,y1,x2,y2);
    1 : EraseCenterToColumns(x1,y1,x2,y2);
    2 : EraseRowsToCenter(x1,y1,x2,y2);
    3 : EraseCenterToRows(x1,y1,x2,y2);
    4 : EraseCenterOut (x1,y1,x2,y2);
    5 : EPullAway(x1,y1,x2,y2);
    6 : EShrinkCircle(P.x,P.y,67);
    7 : EExpandCircle(P.x,P.y,67);
    8 : ESlideDown;
    9 : ESlideUp;
   10 : EFoldRight;
   11 : EFoldLeft;
   12 : DissolveScreen;
   13 : Erase8Columns;
   14 : Erase6Rows;
   15 : EScatter5;
   16 : ESlideUpColumns;
   17 : ESlideDownColumns;
   18 : EOozeDown;
   19 : EOozeUp;
  end; {case (20)}
  NoSound
end;

end.  {VntrMisc}