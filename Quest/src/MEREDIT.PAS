Program MericanEditor;     {created by Michael Rimer}
                           {begun on 17 JAN 94; completed 24 MAY 94}
{$M 5000,0,50000}

{Designs levels using the format of "The Merican Quest".
 The levels are played through "PLAYEDIT.exe".}

Uses Dos, Sounds, ErikSnd, Crt, CrtEXTRA, MerCrt, PEdit1;

const  
  TEST = 1;   
  GAME = 2;   
              
  MenuLength = 10;
  MenuHeight = 8;

                      {character of items in menu}
  MenuChar : array[1..MenuHeight,1..MenuLength] of char = (
   ('€','≤','±','∞','/','\','W','L','#','Z'),
   ('0','1','2','3','4','5','6','7','8','9'),
   ('T','^','+','G','Ù','M','*','Â','È','D'),
   ('C','I','F','A','Q','V','˛','O',':',';'),
   ('-','_','=','Õ','∫','®','<','>','U','R'),
   ('P','','E','S','?','Y','[',']','J','ù'),
   ('H','X',',','Ò','¯','N','B','!','ﬁ','‹'),
   ('{','|','}','~','.','(','˙',')','ﬂ','›'));

                      {visual representation of items in menu}
  MenuItem : array[1..MenuHeight,1..MenuLength] of char = (
   ('€','≤','±','∞','±','≤','±','±','∞','±'),
   ('∞','Ñ','î','Í','é','ô','ö','è','ú','ü'),
   (#6,#127, #4, #4, #9,#24,'*','Â','È','È'),
   (#15,'!','ü','Ë','È','˘', #9,'O',':',';'),
   ('-','_','=','Õ','∫', #9,#27,#26,'Ô','≥'),
   ( #2,'', #1,'','?', #6,'','','J','ù'),
   ('W','X','F','H','P','R','B','I','ﬁ','‹'),
   (#25,#25,#25,#25,'.','1','2','3','ﬂ','›'));

                      {color of items in menu}
  MenuColor : array[1..MenuHeight,1..MenuLength] of integer = (
   (6,-10,-10,-10,-14,2+5*16,9+128,         {128 = blink}
     12+3*16+128,-8,14+6*16+128),             {0 = black}
   (13,4,2,5,12,10,13,14,7,15),               {1 = blue}
   (2,6,11,0,12,13,14,12,13,0),               {2 = green}
   (14+5*16,2,11,10,12,7,9,7,7,7),            {3 = cyan}
   (7,7,7,4,4,14+128,7,7,15,15),              {4 = red}
   (14,12+128,8,9+128,15,14+128,12,14,14,15), {5 = magenta}
   (7,7,7,7,7,7,7,7,6,6),                     {6 = brown}
   (12,14,10,13,7,14,14,14,6,6));             {7 = lt. gray}

                      {names of menu items}
  ItemName  : array[1..MenuHeight,1..MenuLength] of string[14] = (
   ('Solid Wall','Broken Wall 3','Broken Wall 2','Broken Wall 1',
     'Light Forest','Dense Forest','Water','Hot Lava','Bottomless Pit',
     'Force Field'),
   ('Moving Wall','Monster 1','Monster 2','Monster 3','Monster 4',
     'Monster 5','Monster 6','Monster 7','Monster 8','Monster 9'),
   ('Tree','Solid Rock','Health Gem','Inv. Hlth Gem','Power Gem',
     'Magic Scroll','Ancient Relic','Key','Locked Door','Invis. Door'),
   ('Treasure Chest','Invis. Potion','Freeze Spell','Slow Monsters',
     'Haste Monsters','Teleport Trap','Moveable Block','Big Boulder',
     'Invisible Wall','Inv. Brkn Wall'),
   ('Mon No-Move 1','Mon No-Move 2','Mon No-Move 3','H Bridge Rail',
     'V Bridge Rail','Sword Power-Up','Magic Spear L','Magic Spear R',
     'Secret Tunnel','Rope'),
   ('Starting Spot','Stairway','Secret Start','Secret Stairs',
     'Pouch of Gems','Mstr Generator','Monster Zap','Create Mnsters',
     'Reveal Gems','Magic Bomb'),
   ('Wall Surround','Brk. Wall Srnd','Forest Surrnd','Health Surrnd',
     'Power Surround','Relic Surround','Boulder Surrnd','Invs. Surround',
     'Solid Wall 2','Solid Wall 3'),
   ('Rope Extend 1','Rope Extend 2','Rope Extend 3','Rope Extend 4',
     'Inv. Wall Trap','Special 1','Special 2','Special 3','Solid Wall 4',
     'Solid Wall 5'));

                   {more thorough description of items}
  FullItemDesc : array[1..MenuHeight,1..MenuLength] of string[64] = (
   ('Indestructable obstacle',
    'Breakable obstacle (takes up to 3 sword hits)',
    'Breakable obstacle (takes up to 2 sword hits)',
    'Breakable obstacle (50% chance to destroy)',
    'Weakest breakable obstacle (65% chance to break)',
    'Breakable obstacle (40% chance to break)',
    'Top View: obstacle; Side View: damages player',
    'When stepped on, player loses 10 health gems. (Hot Foot!)',
    'Instant death to touch! (Nasty for sure!)',
    'Obstacle (-1 health to touch); can destroy boulders & blocks'),
   ('Hits: 50% to destroy; Speed: Very Slow  (like Broken Wall #1)',
    'Hits: 1; Damage: 1; Speed: Very Slow  (wimps - take up space)',
    'Hits: 1; Damage: 2; Speed: Medium  (nothing special)',
    'Hits: 1; Damage: 3; Speed: Fast  (a bit nasty)',
    'Hits: 2; Damage: 1; Speed: Slow  (more space filler)',
    'Hits: 2; Damage: 2; Speed: Medium  (deceptively harmless)',
    'Hits: 2; Damage: 3; Speed: Fast  (really nasty)',
    'Hits: 3; Damage: 1; Speed: Slow  (not for wading through!)',
    'Hits: 6 (sword only); Damage: 1; Speed: Fast  (ouch!)',
    'Hits: 16! (sword only); Damage: 2; Speed: Very Fast  (deadly!!!)'),
   ('Indestructable obstacle',
    'Indestructable obstacle',
    'Gives player +1 health',
    'Gives player +1 health',
    'Gives player +1 sword',
    'Allows player 1 random teleport',
    'Wah hoo -- 500 points!!',
    'Opens 1 Locked Door',
    'Obstacle, can be removed with 1 Key',
    'Becomes visible (as Locked Door) when touched'),
   ('Contains 2 - 9 health gems, and 2 - 6 power gems!',
    'Makes player invisible for short while',
    'Stops all monsters for a short time',
    'Slows monster to 1/2 speed for a short time',
    'Speeds monsters to twice speed for a short time',
    'Randomly teleports player to new spot',
    'Player can push rows of these around the board',
    'Player can push 1 at a time (squashes monsters); 20% to destroy',
    'Becomes visible (as Solid Wall) when touched',
    'Becomes visible (as Broken Wall #1) when touched'),
   ('Monsters cannot move here until player steps here',
    'Once player steps on one, monsters can step on all touching ones',
    'Monsters can never step here (luckily for the player!)',
    'Indestructable Obstacle',
    'Indestructable Obstacle',
    'Player''s sword does more damage to monsters & obstacles! (Neat.)',
    'Fires left and destroys monsters, doors, etc. (Go experiment.)',
    'Fires right and destroys monsters, doors, etc.',
    'Takes player to different tunnel',
    'Player can climb these on Side View levels; obstacle to monsters'),
   ('Spot where player begins level, after going down Stairs',
    'Takes player to Starting Spot on next lower level',
    'Spot where player begins level, after using Secret Stairs',
    'Takes player to Secret Starting on next lower level',
    'Gives player 13 - 25 health gems (Ah, relief!)',
    'The more of these on a level, the faster NEW monsters are made..',
    'Removes 21 to 50 random monsters from the level',
    'Adds 13 to 40 monsters (Type 1) randomly to the level',
    'Creates 6 to 25 gems randomly in the level',
    'Destroys monsters, doors, walls (with radius of 5 around player)'),
   ('Encloses player in Solid Walls',
    'Encloses player in Broken Walls (Type #1)',
    'Encloses player in Light Forest',
    'Places Health Gems around player (Nice.)',
    'Places Power Gems around player (Nice.)',
    'Places Relics around player (Lotsa points.)',
    'Surrounds player with Big Boulders',
    'Places Invisibility Potions around player',
    'Indestructable obstacle',
    'Indestructable obstacle'),
   ('Extends rope from another Rope Extend #1',
    'Extends rope from another Rope Extend #2',
    'Extends rope from another Rope Extend #3',
    'Extends rope from another Rope Extend #4',
    'Makes 75 - 125 wall sections invisible (Nasty trick.)',
    'Special Item #1 (user-designed)',
    'Special Item #2 (user-designed)',
    'Special Item #3 (user-designed)',
    'Indestructable obstacle',
    'Indestructable obstacle'));

(**********************************************)

var 
  NumStr1,
  NumStr2      : string[3]; {to turn numbers into strings}
  XOff, YOff,               {cursor offset after each item placement}
  Key,                      {key which was entered}
  i, j, Num,                {counters}
  Mx, My, x, y : integer;   {cursor pos (menu/level)}
  Ch, Item     : char;      {char from keyboard, current menu item}
  ExitEditor,               {whether user has quit editor}
  SafetyOn,                 {char overtype}
  FullDesc,                 {full description of item shown}
  LevelSaved,               {if level has been saved after editing}
  FuncKey      : boolean;   {extended key check}

(**********************************************)

Procedure GetEditorKey; forward;

Procedure GetNum(var Num : byte; Digits : integer);
  {* User enters number, only digits allowed}

var SNum  : string;
    Cnt, Error : integer;

begin
  CursorFull;
  SNum := '';
  Cnt := 0;
  repeat
    Ch := ReadKey;
    if (Ch in ['0'..'9']) and (Cnt < Digits)
      then begin
             Inc(Cnt);
             Write(Ch);
             SNum := SNum + Ch
           end
      else if (Ch = #8) and (Length(Snum) > 0)
             then begin
               Dec(Cnt);
               Write(#8,' ',#8);
               Delete(SNum,Cnt + 1,1)
             end
             else if Ch <> #13
                    then Write(#7);    {beep on error}
  until (Ch = #13) and (Length(SNum) > 0);
  CursorOff;
  Val(SNum,Num,Error)
end;

Procedure GetNum2(var Num : integer; Digits : integer);
  {* User enters number, only digits allowed}

var SNum  : string;
    Cnt, Error : integer;

begin
  CursorFull;
  SNum := '';
  Cnt := 0;
  repeat
    Ch := ReadKey;
    if (Ch in ['0'..'9']) and (Cnt < Digits)
      then begin
             Inc(Cnt);
             Write(Ch);
             SNum := SNum + Ch
           end
      else if (Ch = #8) and (Length(Snum) > 0)
             then begin
               Dec(Cnt);
               Write(#8,' ',#8);
               Delete(SNum,Cnt + 1,1)
             end
             else if Ch <> #13
                    then Write(#7);    {beep on error}
  until (Ch = #13) and (Length(SNum) > 0);
  CursorOff;
  Val(SNum,Num,Error)
end;

Procedure EditorExit;
begin
  Close(LevelF);    {close files}

  TextAttr := LightGray;
  ClrScr;
  CursorOn;
  Writeln('    THE MERICAN EDITOR');
  Writeln('       Version ',Version:1:2);
  Writeln;
  Writeln('Written by: Michael Rimer')
end;

Procedure WriteEditorItems;
begin
  Window(68,8,80,16);
  for j := 1 to MenuHeight do
    begin
      for i := 1 to MenuLength do
        begin
          TextAttr := MenuColor[j,i] + Blue * 16;
          Write(MenuItem[j,i])
        end;
      Writeln
    end; {j}
  Window(1,1,80,25)
end;

Procedure SolidWindow(x1, y1, x2, y2 : integer);
  {* Draws window on screen and puts cursor in top-left corner}
begin
  Window(x1,y1,x2,y2 + 1);
  for i := y1 to y2 do
    begin
      TextAttr := DarkGray + LightGray * 16;
      Write('›');
      for j := (x1 + 1) to (x2 - 1) do
        Write(' ');
      TextAttr := White + LightGray * 16;
      Write('ﬁ')
    end;
  Window(x1+1,y1,x2-1,y2 + 1)
end;

Procedure DrawEditor;
begin
  TextAttr := Black;  {borders}
  Window(1,1,80,25);
  ClrScr;
  TextAttr := Cyan * 16;
  Window(65,1,80,25);
  ClrScr;
  TextAttr := LightGray * 16;   {level}
  Window(66,5,79,5);
  ClrScr;
  Window(66,7,79,7);            {item}
  ClrScr;
  TextAttr := Blue * 16;
  Window(78 - MenuLength,8,77,15);
  ClrScr;
  WriteEditorItems;
  BlankLine;

  Window(65,1,80,25);
  TextAttr := White + Cyan * 16;
  Write(' MERICAN EDITOR ');
  Write('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
  Writeln;
  TextColor(Yellow);
  Writeln('      Level');
  Writeln;
  Writeln('      Item');

  Window(66,17,80,25);
  Writeln('ƒƒ¥OPTIONS√ƒƒ');
  Writeln;
  TextColor(LightCyan);
  Writeln('''?''  Help');
  Writeln('F1>  Load');
  Writeln('F2>  Save');
  Writeln('F4>  Playtest');
  Writeln('F10> Options');
  Writeln('ESC> Exit');
  Window(1,1,80,25)
end;

Procedure Message(Str : string);
  {* Writes message in White}

begin
  BlankLine;
  GotoXY((64 - Length(Str)) div 2 + 1,25);
  TextAttr := White;
  Write(Str)
end;

Procedure FlashMessage(Str : string);
  {* Flashes message in all colors until KeyPressed}

begin
  BlankLine;
  RemKeys;
  repeat
    GotoXY(((65 - Length(Str)) div 2) + 1,25);
    TextAttr := Random(15) + 1;
    Write(Str);
    Delay(25)
  until KeyPressed;
  RemKeys;
  BlankLine
end;

Procedure FlashMenuItem;
  {* Draws selected menu item in flashing colors}

begin
  TextAttr := Random(15) + 1;
  GotoXY(67 + Mx,7 + My);
  Write(MenuItem[My,Mx])
end;

Procedure FlashLevelItem;
  {* Displays flashing spot on level where cursor is}

begin
  TextAttr := Random(15) + 1;
  GotoXY(x,y);
  Write('€')
end;

Procedure WriteCursor;
  {* Places cursor at (x,y) - with wraparound}

begin
  if x < 1 
    then Inc(x,64)
    else if x > 64
      then Dec(x,64);
  if y < 1
    then Inc(y,24)
    else if y > 24
      then Dec(y,24);
  GotoXY(x,y)
end;

Procedure WriteLevelNum;
  {* Prints current level number}
begin
  TextAttr := LightGray * 16;
  GotoXY(72,5);
  if LevelNum <> 0
    then Write(LevelNum:2)
    else Write('--')
end;

Procedure WriteItemDesc;
  {* Writes name of selected item}

begin
  Window(66,7,79,7);
  TextAttr := LightGray * 16;
  ClrScr;
  Window(66,7,80,8);
  GotoXY(8 - (Length(ItemName[My,Mx]) div 2),1);
  Write(ItemName[My,Mx]);
  Window(1,1,80,25);
  if FullDesc
    then Message(FullItemDesc[My,Mx])
end;

Procedure MoveMenuCursor(OffSet : integer);
  {* Moves menu cursor one item to the left or right}

begin
  GotoXY(67 + Mx,7 + My);     {rewrite old item}
  TextAttr := MenuColor[My,Mx] + Blue * 16;
  Write(MenuItem[My,Mx]);

  Inc(Mx,OffSet);             {move to new item}
  if Mx < 1                   {check for line wrap-around}
    then begin
           Mx := MenuLength;
           Dec(My)
         end
    else if Mx > MenuLength
      then begin
             Mx := 1;
             Inc(My)
           end;
  if My < 1
    then begin
           My := MenuHeight;
           Mx := MenuLength
         end
    else if My > MenuHeight
      then begin
             My := 1;
             Mx := 1
           end;
  
  WriteItemDesc        {update screen for new item}
end;

Procedure DrawMonster(x, y, Hits : integer; AsciiChar : char);
  {* Updates monster at screen position (x,y), color according to Hits}
  {* WOW! This is great!}

begin
  GotoXY(x,y);
  case AsciiChar of
    '0' : begin                     {moving wall, sword destroys}
            TextAttr := Magenta;
            Write('∞')
          end;
    '1' : begin                 {1 - 3 hit once}
            TextAttr := Red;
            Write('Ñ')
          end;
    '2' : begin
            TextAttr := Green;
            Write('î')
          end;
    '3' : begin
            TextAttr := Magenta;
            Write('Í')
          end;
    '4' : begin                {4 - 6 hit twice}
            if Hits = 1
              then TextAttr := Red
              else TextAttr := LightRed;   {Hits = 2}
            Write('é')
          end;
    '5' : begin
            if Hits = 1
              then TextAttr := Green
              else TextAttr := LightGreen; {Hits = 2}
            Write('ô')
          end;
    '6' : begin
            if Hits = 1
              then TextAttr := Magenta
              else TextAttr := LightMagenta;  {Hits = 2}
            Write('ö')
          end;
    '7' : begin                {7 hits thrice}
            case Hits of
              1 : TextAttr := Red;
              2 : TextAttr := LightRed;
            else TextAttr := Yellow      {Hits = 3}
            end; {Hits}
            Write('è')
          end;
    '8' : begin                 {8 is undead - only sword hits}
            case Hits of
              1,2 : TextAttr := DarkGray;
            else TextAttr := LightGray   {Hits = 3..6}
            end; {Hits}
            Write('ú') 
          end;
    '9' : begin                {9 is undead - only sword hits}
            case Hits of
              1..4   : TextAttr := DarkGray;
              5..12  : TextAttr := LightGray;
            else TextAttr := White       {Hits = 13..16}
            end; {Hits}
            Write('ü')
          end
  end {AsciiChar case}
end;

Procedure DrawLevel(x1,y1,x2,y2 : integer);
  {* Writes (x1,y1) - (x2,y2) of current level on editor screen}

var  Spot : char;

begin
  for j := y1 to y2 do
    for i := x1 to x2 do
      begin
        GotoXY(i,j);
        Spot := Level[i,j];
        case Spot of
          ' ' : begin                       {blank/invisible spaces}
            TextAttr := Black;
            Write(' ')
          end;
          '-','_','=' : begin               {monster no-move spots}
            TextAttr := LightGray;
            Write(Spot)
          end;                              
          'J','B','X','.',
          ':',';' : begin                   {invisible items/walls}
            TextAttr := LightGray;  Write(Spot)
          end;
          'H' : begin
            TextAttr := LightGray;  Write('W')
          end;
          ',' : begin
            TextAttr := LightGray;  Write('F')
          end;
          'N' : begin
            TextAttr := LightGray;  Write('R')
          end;
          '!' : begin
            TextAttr := LightGray;  Write('I')
          end;
          'Ò' : begin
            TextAttr := LightGray;  Write('H')
          end;
          '¯' : begin
            TextAttr := LightGray;  Write('P')
          end;
          'G' : begin                       {inv. health gem}
            TextAttr := Blue * 16;  Write(#4)
          end;
          'D' : begin                       {inv. door}
            TextAttr := Blue * 16;  Write('È')
          end;
          'P' : begin                       {normal entrance}
            TextAttr := Yellow;     Write(#2)
          end;
          'E' : begin                       {secret entrance}
            TextAttr := Blue;       Write(#1)
          end;
          '∞'..'≤','€'..'ﬂ' : begin         {walls}
            TextAttr := LStat.WallColor;  Write(Spot)
          end;
          'a'..'z' : begin                  {message chars}
            TextAttr := White + LStat.WallColor * 16;  Write(UpCase(Spot))
          end;
          '∫','Õ' : begin                   {bridge rails}
            TextAttr := LightRed;   Write(Spot)
          end;
          'R' : begin                       {rope}
            TextAttr := White;      Write('≥')
          end;
          'W' : begin                       {water}
            TextAttr := LightBlue + Blue * 16 + Blink;  Write('±')
          end;
          'L' : begin                       {lava}
            TextAttr := LightRed + Red * 16 + Blink;  Write('±')
          end;
          '/' : begin                       {forest - thin}
            TextAttr := Green;      Write('±')
          end;
          '\' : begin                       {forest - thick}
            TextAttr := Green + Brown * 16;  Write('≤')
          end;
          'T' : begin                       {tree}
            TextAttr := Green;      Write(#6)
          end;
          '#' : begin                       {bottomless pit}
            TextAttr := DarkGray;   Write('∞')
          end;
          'Z' : begin                       {force field}
            TextAttr := Yellow + LightGray * 16 + Blink;  Write('±')
          end;
          '^' : begin                       {rock, stationary}
            TextAttr := Brown;      Write(#127)
          end;
          'O' : begin                       {boulder, moveable}
            TextAttr := LightGray;  Write('O')
          end;
          '˛' : begin                       {pushable block}
            TextAttr := LightBlue + Blue * 16;  Write(#9)
          end;
          'U' : begin                       {secret tunnel}
            TextAttr := White;      Write('Ô')
          end;
          'V' : begin                       {teleport trap}
            TextAttr := LightGray;  Write('˙')
          end;
          '0'..'9' : DrawMonster(i,j,13,Spot); {monsters at full hits}
          'È' : begin                       {locked door}
            TextAttr := White + Magenta * 16;  Write('È')
          end;
          '' : begin                       {normal stairs}
            TextAttr := LightRed + Blink;  Write('')
          end;
          'S' : begin                       {secret stairs}
            TextAttr := LightBlue * 16;  Write('')
          end;
          '+' : begin                       {health gem}
            TextAttr := 11 {HGColor};  Write(#4)
          end;
          'Ù' : begin                       {power gem}
            TextAttr := 12 {PGColor};  Write(#9)
          end;
          'M' : begin                       {magic}
            TextAttr := LightMagenta;  Write(#24)
          end;
          'Â' : begin                       {key}
            TextAttr := LightRed;   Write('Â')
          end;
          'C' : begin                       {chest}
            TextAttr := Yellow + Brown * 16;  Write(#15)
          end;
          '*' : begin                       {treasure}
            TextAttr := Yellow;     Write(#15);
          end;
          'I' : begin                       {blindness potion}
            TextAttr := Green;      Write('≠')
          end;
          'F' : begin                       {freeze monsters}
            TextAttr := LightCyan;  Write('ü')
          end;
          'Q' : begin                       {quicken monsters}
            TextAttr := LightRed;   Write('È')
          end;
          'A' : begin                       {slow monsters}
            TextAttr := LightGreen; Write('Ë')
          end;
          'ù' : begin                       {magic bomb}
            TextAttr := White;      Write('ù')
          end;
          '<' : begin                       {magic spear - left}
            TextAttr := LightGray;  Write(#27)
          end;
          '>' : begin                       {magic spear - right}
            TextAttr := LightGray;  Write(#26)
          end;
          '[' : begin                       {monster zap}
            TextAttr := LightRed;   Write('')
          end;
          ']' : begin                       {create monsters}
            TextAttr := Yellow;     Write('')
          end;
          'Y' : begin                       {monster generator}
            TextAttr := Yellow + Blink;  Write(#6)
          end;
          '?' : begin                       {pouch of gems}
            TextAttr := White;      Write('?')
          end;
          '®' : begin                       {sword power-up}
            TextAttr := Yellow + Blink;  Write(#9)
          end;
          '{' : begin                       {rope extend (type 1)}
            TextAttr := LightRed;   Write(#25)
          end;
          '|' : begin                       {rope extend (type 2)}
            TextAttr := Yellow;     Write(#25)
          end;
          '}' : begin                       {rope extend (type 3)}
            TextAttr := LightGreen; Write(#25)
          end;
          '~' : begin                       {rope extend (type 4)}
            TextAttr := LightMagenta;  Write(#25)
          end;
          '(' : begin                       {special 1}
            TextAttr := Yellow;     Write('1')
          end;
          '˙' : begin                       {special 2}
            TextAttr := Yellow;     Write('2')
          end;
          ')' : begin                       {special 3}
            TextAttr := Yellow;     Write('3')
          end;
          else begin                        {- unknown char -}
            TextAttr := White + Blink;
            Write(Spot)
          end
        end {Spot case}
      end
end;

Procedure EraseWindow(x1,y1,x2,y2 : integer);
begin
  Window(1,1,80,25);
  DrawLevel(x1,y1,x2,y2)
end;

Procedure HelpMenu;
  {* Gives information on program, how to register, etc.}
begin
  SolidWindow(2,4,63,21);
  TextColor(LightCyan);
  Writeln('          THE MERICAN EDITOR - by Michael Rimer');
  Writeln('                  Copyright (c) May 1994');
  Writeln('                        Version ',Version:1:2);
  Writeln;
  Writeln('     This program,  part of the "MERICA" game series,  is a');
  Writeln(' level designer,  based on  Volume II,   named "THE MERICAN');
  Writeln(' QUEST".  With it,  you,  the game player,  can create your');
  Writeln(' your own  personalized levels!!   The main screen displays');
  Writeln(' the current level  in memory,  and the window to the right');
  Writeln(' lists the level number,  a menu of all items  you may use,');
  Writeln(' and a few options available.  The solid line at the bottom');
  Writeln(' of the screen displays messages from time to time.');
  Writeln('    Use the keyboard''s numeric keypad to move the cursor on');
  Writeln(' on the level map,  the "[" and "]" keys  to scroll through');
  Writeln(' the menu of items,  and the F10 key for game options.  The');
  Writeln(' Spacebar places items, and the Backspace key deletes them.');
  Writeln;
  Write('                       Hit any key...');
  repeat until KeyPressed;  RemKeys;

  SolidWindow(2,5,63,21);
  TextColor(LightCyan);
  Writeln('                  ƒƒƒ¥ MISCELLANEOUS √ƒƒƒ');
  Writeln;
  Writeln('   Up to 40 levels can be designed (saved to disk under the');
  Writeln(' filename  "MEREDIT.LVL").   Special items designed  by the');
  Writeln(' user are placed into the file "MEREDIT.SPC".   In the case');
  Writeln(' that you want to design more than 40 levels, simply rename');
  Writeln(' the two files  under the name of your choice to store them');
  Writeln(' away while you  design more.   (Give them back these names');
  Writeln(' to play them again.)');
  Writeln('   Feel free to experiment with all possibilities included.');
  Writeln(' (However,  due to design features, special functions which');
  Writeln(' you personally create may  never have been intended to run');
  Writeln(' as you have made them.  If the game does not operate as it');
  Writeln(' should (halts, freezes up),  then you need to modify those');
  Writeln(' designs.');
  Writeln;
  Write('                       Hit any key...');
  repeat until KeyPressed;  RemKeys;

  SolidWindow(2,2,63,23);
  TextColor(LightCyan);
  Writeln('                   ƒƒƒ¥ REGISTERING √ƒƒƒ');
  Writeln;
  Writeln('   "The Merican Editor" is not shareware,  but it is user-');
  Writeln(' supported.   A payment of $5 to the author is required in');
  Writeln(' order to use this product  (check or money order).   Your');
  Writeln(' payment entitles you  to receive notification  of further');
  Writeln(' volumes in the  "Merica" series as they are designed,  as');
  Writeln(' well as of other future games created by Adventia!');
  Writeln('   Comments or questions  about any  of the games  in this');
  Writeln(' series are encouraged.   I appreciate the feedback  which');
  Writeln(' you have  to offer,  such as  pointing out any bugs found');
  Writeln(' (though I have tried to make  this game error-free before');
  Writeln(' distribution) and your ideas for future games.   It is my');
  Writeln(' imagination that is the driving force behind these games,');
  Writeln(' but their  continued growth also depends on  the ideas of');
  Writeln(' others.  (All flashes of genius are welcome!)');
  Writeln;
  Writeln(' Send payments or comments to:  Adventia Software');
  Writeln('                                (address)');
  Writeln('                                (city, state, zip)');
  Writeln;
  Write('    Have fun, and thank you for playing! -- Michael Rimer');
  repeat until KeyPressed;  RemKeys;
  EraseWindow(2,2,63,23);
end;

Procedure CursorMenu;
begin
  TextAttr := Yellow + LightGray * 16;
  Writeln('   ƒƒƒ¥ CURSOR OFFSET √ƒƒƒ');
  Writeln;
  Writeln(' After an item is placed, the');
  Writeln(' cursor moves over this many');
  Writeln(' places on the map.');
  Writeln;
  Writeln(' X Offset: ');
  Writeln(' Y Offset: ');
  Writeln(' ESC: Done modifying');
  Write(' OPTIONS: X, Y, ESC');
end;

Procedure EnterOff(C : char; P : integer; var n : integer);
begin
  Message('Enter new offset value for ' + C + ' offset (0 - 9): ');
  GetNum2(n,1);
  BlankLine;
  if n <> 0
    then if OPMessage('Is new ' + C + ' offset positive or negative? (P,N)','PN') = 'N'
           then n := -n
end;

Procedure CursorStats;
  {* User can view/ modify cursor offset}
begin
  SolidWindow(17,8,48,17);
  CursorMenu;
  repeat
    Window(18,8,48,18);
    TextAttr := DarkGray + LightGray * 16;
    GotoXY(12,7);  Write(XOff,' ');
    GotoXY(12,8);  Write(YOff,' ');
    GetEditorKey;
    case Key of
{X}   88 : EnterOff('X',7,XOff);
{Y}   89 : EnterOff('Y',8,YOff);
      99 : {exit};
    end;
  until Key = 99;
  EraseWindow(17,8,48,17)
end;

Procedure PrintOptions;
begin
  SolidWindow(5,8,60,18);
  TextColor(Red);
  Writeln('                 ƒƒƒ¥ OPTIONS √ƒƒƒ');
  Writeln;
  Writeln(' F1 -- Load Level       F2 -- Save Level');
  Writeln(' F3 -- Select Level #   F4 -- Playtest Level');
  Writeln(' F5 -- Swap Levels      F6 -- Toggle Full Description');
  Writeln(' F7 -- Define Specials  F8 -- Level Stats');
  Writeln(' F9 -- View Level       F10 - Go to this menu!');
  Writeln('  * -- Toggle safety mode (overtype)');
  Writeln('  + -- Change cursor movement offset');
  Writeln;
  Write('                   Hit any key...');
  repeat until KeyPressed;  RemKeys;
  EraseWindow(5,8,60,18)
end;

Procedure SpecMenu;
begin
  TextColor(Red);
  Writeln('Type: ');
  Writeln('Pic :    Color: ');
  Writeln('1: ');
  Writeln('2: ');
  Writeln('3: ');
  Writeln('4: ');
  Writeln('5: ');
  Writeln('6: ');
  Writeln('7: ');
  Writeln('8: ');
  Writeln('9: ');
  Writeln;
  Writeln('?: Help Menu');
  Writeln('ESC: Done modifying');
  Writeln('Options : T, P, C, 1 - 9, ?, ESC');
end;

Procedure SpecStats(Spec : ItemRec);
  {* Writes out statistics for Spec}
var Trav : SpecItemPtr;

begin
  GotoXY(7,2);
  TextAttr := Red + LightGray * 16;
  case Spec.IType of
    SL : Write('Secret Lever');
    MA : Write('Magic Spell ')
  end;
  GotoXY(17,3);
  Write(Spec.Color:3);
  GotoXY(7,3);  TextAttr := Spec.Color;
  Writeln(Spec.Chr);
  TextAttr := Yellow + LightGray * 16;
  Trav := Spec.Item;
  while Trav <> nil do
    begin
      GotoXY(3,WhereY);
      Write(Trav^.Data);
      for i := 1 to (40 - Length(Trav^.Data))
        do Write(' ');
      Writeln;
      Trav := Trav^.next
    end;
  GotoXY(3,WhereY);
  for i := 1 to 40 do Write(' ')
end;

Procedure AddStr(var DS : string50);
  {* Add string into DS}
var S : string;

begin
  SolidWindow(5,22,60,22);
  Write('Enter message: ');
  Readln(S);
  DS := DS + ' ' + S;
  EraseWindow(5,22,60,23)
end;

Procedure AddNum(var DS : string50; Digits : byte);
  {* Add number into DS}
var N : byte;
    S : string;

begin
  GetNum(N,Digits);
  Str(N,S);
  DS := DS + ' ' + S
end;

Procedure AddNum2(var DS : string50; Digits : byte);
  {* Add number into DS}
var N : integer;
    S : string;

begin
  GetNum2(N,Digits);
  Str(N,S);
  DS := DS + ' ' + S
end;

Procedure AddItem(var DS : string50);
  {* Choose item from menu to add into DS}
var C : char;

begin
  C := '(';
  while (C in ['(','˙',')']) do
    begin
      FlashMenuItem;
      Delay(40);
      if KeyPressed
        then begin
               GetEditorKey;
               case Key of
                 10 : C := MenuChar[My,Mx]; {SPACE}
                 25 : C := ' ';             {backspace}
                 30 : MoveMenuCursor(-1);   {'['}
                 31 : MoveMenuCursor(+1)    {']'}
               end
             end
    end;
  DS := DS + ' ' + C
end;

Procedure AddPos(var DS : string50);
  {* Add cursor position (x,y) into DS}
var Hit : boolean;
    Sx, Sy : string[2];

begin
  Hit := FALSE;
  repeat
      FlashLevelItem;
      Delay(20);
      DrawLevel(x,y,x,y);
      Delay(20);
      if KeyPressed
        then begin
               GetEditorKey;
               case Key of
                 2 : Inc(y);
                 4 : Dec(x);
                 6 : Inc(x);
                 8 : Dec(y);
                10 : Hit := TRUE
               end;
               WriteCursor
             end
  until Hit;
  Str(x,Sx);  Str(y,Sy);
  DS := DS + ' ' + Sx + ' ' + Sy
end;

Procedure EffectsMenu;
var N, k : byte;
begin
  SolidWindow(3,6,61,18);
  Writeln('           ƒƒƒ¥ Special Effects Menu √ƒƒƒ');
  Writeln;
  Writeln('     sound ƒ¬ø⁄ƒ visual   y = any number from 0 - 3');
  Writeln(' (optional) ≥≥≥          xx = any number from 1 - 40');
  Writeln('            ≥≥≥');
  Writeln('            xxy         <== How an effect is entered.');
  Writeln;
  Writeln('   The last digit of the number you enter corresponds to');
  Writeln(' the visual effect you will see when an item is modified');
  Writeln(' on the screen.   If you have  one or two digits  before');
  Writeln(' this number,  it will match with  a sound which is made');
  Writeln(' every time an item is changed (this is optional).');
  repeat
    Message('Enter a number to hear any sound (1 - 6,0 quits): ');
    GetNum(N,2);
    case N of
    1 : begin
          for k := 1 to 5 do
            PSound(500 + Random(500),10);
          NoSound
        end;
    2 : for k := 1 to 10 do
          begin
            PSound(300,5);
            NoSound;
            Delay(5)
          end;
    3 : Chirp3;
    4 : Spike3;
    5 : Whoop1;
    6 : Spike5;
    end;
  until N = 0;
  EraseWindow(3,6,61,18)
end;

Procedure DefineSpecData(Data : ItemRec; var DS : string50;
                          Num : integer; C : char);
  {* Enter data into string DS for special item}
var S : string;
    N : byte;

begin
  case Num of
    0..3 : begin
          EraseWindow(10,5,55,20);
          Message('Move cursor to upper-left corner of affected area and hit SPACE.');
          AddPos(DS);
          Message('Move cursor to lower-right corner of area and hit SPACE.');
          AddPos(DS);
          BlankLine;
          SolidWindow(10,5,55,20);
          Writeln('Special Item #' + C);
          SpecMenu;
          Window(12,5,54,21);
          SpecStats(Data)
        end;
    4 : AddStr(DS);
    5 : begin
          Message('Choose item to execute and hit SPACE.');
          AddItem(DS);
          Message('Enter number of times to use item (1 - 255): ');
          AddNum(DS,3);
          BlankLine
        end;
    6 : begin
          Message('Enter starting frequency (up to 9999): ');
          AddNum2(DS,4);
          Message('Enter ending frequency (up to 9999): ');
          AddNum2(DS,4);
          Message('Enter frequency increment (up to 999): ');
          AddNum2(DS,3);
          Message('Enter delay (milliseconds) between each step (up to 999): ');
          AddNum2(DS,3);
          BlankLine
        end
  end;
  case Num of
    0 : begin
          Window(1,1,80,25);
          Message('Choose item for area to become and hit SPACE.');
          AddItem(DS);
          BlankLine
        end;
    1..3 : begin
          Window(1,1,80,25);
          Message('Choose 1st item and hit SPACE.');
          AddItem(DS);
          Message('Choose 2nd item and hit SPACE.');
          AddItem(DS);
          BlankLine
        end
  end;

  if (Num in [0..3])
    then begin
           repeat
             Message('Choose visual/sound effect (99 for help): ');
             GetNum(N,3);
             BlankLine;
             if N = 99
               then begin
                      EraseWindow(10,5,55,20);
                      EffectsMenu;
                      SolidWindow(10,5,55,20);
                      Writeln('Special Item #' + C);
                      SpecMenu;
                      Window(12,5,54,21);
                      SpecStats(Data);
                      Window(1,1,80,25)
                    end
           until (N >= 0) and (N <= 63);
           Str(N,S);
           DS := DS + ' ' + S
         end
end;

Procedure SpecEffect(Item : ItemRec; var Spec : SpecItemPtr;
                        N : integer; C : char);
  {* Select effect for special item and locate in list}
var Trav, T2, NewData : SpecItemPtr;
    N2, Eff : byte;
    Cnt : integer;
      S : string[1];

begin
  N2 := N;
  Window(10,6,55,20);
  Trav := Spec;
  if Trav <> nil
    then begin
      Cnt := N - 1;
      while (Cnt > 0) and (Trav^.next <> nil) do
        begin
          Dec(Cnt);
          Trav := Trav^.next
        end;
      Dec(N,Cnt);  {if lines above N, then move N up to first blank line}
      Dec(N2,Cnt);
      if (Trav^.next = nil) and (N < 9) and (Cnt <> 0)
        then begin
               New(NewData);
               NewData^.next := nil;
               Trav^.next := NewData
             end
        else begin
               Dec(N);
               NewData := Trav
             end
    end
    else begin
           N := 1;  N2 := 1;
           New(NewData);
           NewData^.next := nil;
           Spec := NewData
         end;

  GotoXY(5,3 + N);
  for i := 1 to 40 do Write(' ');
  SolidWindow(13,22,52,22);
  Write('Enter Effect Type (0 - 6,9 erases): ');
  repeat
    GetNum(Eff,1)
  until (Eff in [0..6,9]);
  EraseWindow(13,22,52,22);
  if Eff = 9
    then if N2 = 1
           then begin
                  Trav := Spec;
                  Spec := Spec^.next;
                  Dispose(Trav)
                end
           else begin           {remove blank line from list}
                  Trav := Spec;
                  for i := 1 to (N2 - 2) do
                    if Trav^.next <> nil
                      then Trav := Trav^.next;
                  T2 := Trav^.next;
                  Trav^.next := T2^.next;
                  Dispose(T2)
                end
    else begin
           Str(Eff,S);
           NewData^.data := S;
           DefineSpecData(Item,NewData^.data,Eff,C)
         end
end;

Procedure SpecialHelp;
  {* Displays menu listing all options for special data}
begin
  SolidWindow(3,3,62,22);
  TextColor(Blue);
  Writeln('              ƒƒƒ¥ SPECIAL ITEMS HELP √ƒƒƒ');
  TextColor(Magenta);
  Writeln('Listing of effects for special item data slots (1 - 9).');
  Writeln;
  TextColor(Red);
  Writeln(' 0 x1 y1 x2 y2 i e        {all spots become i}');
  Writeln(' 1 x1 y1 x2 y2 i1 i2 e    {if i1, then becomes i2}');
  Writeln(' 2 x1 y1 x2 y2 i1 i2 e    {if not i1, then becomes i2}');
  Writeln(' 3 x1 y1 x2 y2 i1 i2 e    {if i1, then i2 (& vice-versa)}');
  Writeln(' 4 Message                {message (up to 48 chars)}');
  Writeln(' 5 i n                    {activate item i, n times}');
  Writeln(' 6 f1 f2 s d              {sound from freq f1 to f2, w/');
  Writeln('                          step s, with delay d (in ms)}');
  Writeln;
  TextColor(LightBlue);
  Writeln('Symbols:  (x1, y1)  = top-left corner on screen');
  Writeln('          (x2, y2)  = lower-right corner on screen');
  Writeln('          i, i1, i2 = any character symbol (use ',#17,'ÕÕ key');
  Writeln('                        (backspace) for Blank Spot)');
  Writeln('          e         = visual/audio effect used');
  Writeln('          s, d      = sound frequency, delay (milli-sec)');
  Writeln;
  Write('                     Hit any key...');
  repeat until KeyPressed;  RemKeys;
  EraseWindow(3,3,62,22)
end;

Procedure DefineSpecials(var Spec : ItemRec; C : char);
  {* Player chooses special item to customize}
var Saved : boolean;

begin
  Saved := FALSE;
  SolidWindow(10,5,55,20);
  Writeln('Special Item #' + C);
  SpecMenu;
  repeat
    Window(12,5,54,21);
    SpecStats(Spec);
    GetEditorKey;
    Window(1,1,80,25);
    case Key of
  {T} 84 : case OPMessage('Type: Secret Lever or Magic Spell? (L,M)','LM') of
             'L' : Spec.IType := SL;
             'M' : Spec.IType := MA
           end;
  {P} 80 : begin
             Message('Hit any key for picture of item...');
             Spec.Chr := ReadKey;
             BlankLine;
             RemKeys
           end;
  {C} 67 : repeat
             Message('Enter number for color of item (0 - 255): ');
             GetNum(Spec.Color,3);
             BlankLine
           until Spec.Color < 256;
      49..57 : SpecEffect(Spec,Spec.Item,Key - 48,C); {1 - 9}
      63 : begin
             SpecialHelp;
             SolidWindow(10,5,55,20);
             Writeln('Special Item #' + C);
             SpecMenu
           end;
      99 : {exit};  {ESC}
    end;
    if (Key in [84,80,67,49..57])
      then LevelSaved := FALSE
  until Key = 99;
  EraseWindow(10,5,55,20)
end;

Procedure LevelMenu;
begin
  TextColor(Blue);
  Writeln('    ƒƒƒ¥ LEVEL STATISTICS √ƒƒƒ');
  Writeln('Name: ');
  Writeln('Type: ');
  Writeln('Reverse X: ');
  Writeln('Reverse Y: ');
  Writeln('Wall Color: ');
  Writeln('ESC: Done modifying');
  Writeln('OPTIONS: N, T, X, Y, W, ESC')
end;

Procedure LevelStats;
  {* Writes out level statistics}
begin
  Window(14,9,49,17);
  TextAttr := Yellow + LightGray * 16;
  GotoXY(7,2);  Write(LStat.Name);
  for i := 1 to (28 - Length(LStat.Name)) do
    Write(' ');
  GotoXY(7,3);
  if LStat.View = TopVIEW
    then Write('Top View ')
    else Write('Side View');
  GotoXY(12,4);
  if LStat.XFlip
    then Write('ON ')
    else Write('OFF');
  GotoXY(12,5);
  if LStat.YFlip
    then Write('ON ')
    else Write('OFF');
  GotoXY(13,6);
  TextColor(LStat.WallColor);
  Write('€€€€€')
end;

Procedure DefineLevel;
  {* Customizes current level}
var OldWC : integer;

begin
  OldWC := LStat.WallColor;
  SolidWindow(13,9,49,16);
  LevelMenu;
  repeat
    LevelStats;
    GetEditorKey;
    case Key of
 {N}  78 : begin
             GotoXY(7,2);
             CursorFull;
             Readln(LStat.Name);
             CursorOff
           end;
 {T}  84 : begin
             Window(1,1,80,25);
             case OPMessage('Type: Top View or Side View (T,S)','TS') of
               'T' : LStat.View := TopVIEW;
               'S' : LStat.View := SideVIEW
             end
           end;
 {X}  88 : LStat.XFlip := (not LStat.XFlip);
 {Y}  89 : LStat.YFlip := (not LStat.YFlip);
 {W}  87 : repeat
             Window(1,1,80,25);
             Message('Enter number for color of walls (0 - 15): ');
             GetNum(LStat.WallColor,2);
             BlankLine
           until LStat.WallColor < 16;
      99 : {exit};  {ESC}
    end;
    if (Key in [78,84,87..89])
      then LevelSaved := FALSE
  until Key = 99;
  if OldWC <> LStat.WallColor
    then begin
           Window(1,1,80,25);
           DrawLevel(1,1,64,24)
         end
    else EraseWindow(13,9,49,16)
end;

Procedure PlaceLetter(Ch : char);
  {* Places wall character in level}

begin
  Ch := Chr(Ord(Ch) + 32);   {make letter lower case}
  if SafetyOn and (Level[x,y] <> ' ')
    then Write(#7)
    else Level[x,y] := Ch;
  DrawLevel(x,y,x,y);
  Inc(x,XOff);
  Inc(y,YOff);
  WriteCursor;
  LevelSaved := FALSE
end;

Procedure PlaceItem;
  {* Places selected item at pos (x,y) in level}

begin
  if SafetyOn and (Level[x,y] <> ' ')
    then Write(#7)
    else Level[x,y] := MenuChar[My,Mx]; {place item in Level array}
  DrawLevel(x,y,x,y);                   {print item on screen}
  Inc(x,XOff);                   {move cursor to new spot}
  Inc(y,YOff);
  WriteCursor;
  LevelSaved := FALSE
end;

Procedure DeleteItem;
  {* Delete item at pos (x,y) in level}

begin
  Level[x,y] := ' ';
  DrawLevel(x,y,x,y);
  Inc(x,XOff);
  Inc(y,YOff);
  WriteCursor;
  LevelSaved := FALSE
end;

Procedure SaveSpecials;
  {* Saves definitions of special items into text file}
var Trav   : SpecItemPtr;
    sf, nf : text;
    C : char;
    N : integer;
    S : string;

begin
  Assign(sf,'meredit.spc');
  Assign(nf,'meredit.old');
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

  Readln(sf,S);  Writeln(nf,S);  {write new data}
  for i := 1 to 3 do
    begin
      Writeln(nf,'#',i);
      Writeln(nf,Specials[i].IType,' ',Specials[i].Chr,' ',Specials[i].Color);
      Trav := Specials[i].Item;
      while Trav <> nil do
        begin
          Writeln(nf,Trav^.data);
          Trav := Trav^.next
        end
    end;

  repeat        {skip old data}
    Read(sf,C);
    if C <> '*' then Readln(sf,S);
  until C = '*';
  Write(nf,'*');

  while (not Eof(sf)) do  {copy rest of file}
    begin
      Readln(sf,S);
      Writeln(nf,S)
    end;
  Close(sf);  Close(nf);  {remove old file}
  SwapVectors;  Exec(GetEnv('COMSPEC'),'/Cdel meredit.spc');
  SwapVectors;  Exec(GetEnv('COMSPEC'),'/Crename meredit.old meredit.spc');
  SwapVectors
end;

Procedure SaveLevel;
  {* Saves current maze under current level number}

var SNum : string[3];

begin
  if LevelNum = 0
    then repeat
           Message('Enter level number to save this screen on: ');
           GetNum(LevelNum,2);
           BlankLine;
           WriteLevelNum
         until LevelNum < 41;
  Message(' Saving level... ');

  Seek(LevelF,LevelNum); {save level info}
  LevelInfo.Level := Level;
  LevelInfo.LStat := LStat;
  Write(LevelF,LevelInfo);
  SaveSpecials;          {save specials}

  FlashMessage('Level saved.');
  LevelSaved := TRUE
end;

Procedure CheckSave;
begin
  if (not LevelSaved)
    then if OPMessage('Current level not saved. Save now (Y,N)?','YN') = 'Y'
           then SaveLevel
end;

Procedure RestoreLevel;
  {* Restores level - places onto screen}

begin
  CheckSave;
  repeat
    Message('Enter number of level to restore (1 - 40): ');
    GetNum(LevelNum,2)
  until (LevelNum > 0) and (LevelNum < 41);
  WriteLevelNum;
  Message(' Restoring level... ');

  Seek(LevelF,LevelNum);
  Read(LevelF,LevelInfo);
  Level := LevelInfo.Level;
  LStat := LevelInfo.LStat;
  RestoreSpecials;

  DrawLevel(1,1,64,24);
  BlankLine;
  LevelSaved := TRUE
end;

Function VerifyExit : boolean;
  {* Checks whether user really wishes to leave editor}

begin
  CheckSave;
  if OPMessage('Exit "The Merican Editor" now? (Y,N)?','YN') = 'Y'
    then VerifyExit := TRUE
    else VerifyExit := FALSE
end;

Procedure GetEditorKey;
  {* Translates keypress entered on keyboard}

begin
  Ch := UpCase(ReadKey);    {read keypress}
  if Ch = #0                {trap extended keys}
    then begin
           FuncKey := TRUE;
           Ch := ReadKey
         end
    else FuncKey := FALSE;
  Key := 0;       {if key is not defined}
  if FuncKey      {else return value for Key}
    then case Ch of   {EXTENDED}
           #71..#73 : Key := Ord(Ch) - 64;     {7 8 9}
           #75, #77 : Key := Ord(Ch) - 71;     {4   6}
           #79..#81 : Key := Ord(Ch) - 78;     {1 2 3}
           #59..#68 : Key := Ord(Ch) - 48;  {Function Keys}
         end
    else case Ch of   {NORMAL}
           '1'..'9' : Key := Ord(Ch);  {specials}
           ' '      : Key := 10;  {place item}
           #8       : Key := 25;  {delete item}
           '['      : Key := 30;  {menu cursor left}
           ']'      : Key := 31;  {menu cursor right}
           'A'..'Z' : Key := Ord(Ch);  {wall characters}
           '?'      : Key := 63;  {? - help}
           '*'      : Key := 42;  {* - safety toggle}
           '+'      : Key := 43;  {+ - cursor offset}
           #27      : Key := 99;  {ESC - quit}
         end
end;

Procedure DoEditFunction;
  {* Executes certain menu command, based on Key}
var Sx, Sy : integer;
begin
  case Key of
    1 : begin
            Dec(x); Inc(y)
          end;
    2 : Inc(y);
    3 : begin
            Inc(x); Inc(y)
          end;
    4 : Dec(x);
    6 : Inc(x);
    7 : begin
            Dec(x); Dec(y)
          end;
    8 : Dec(y);
    9 : begin
            Inc(x); Dec(y)
          end;
   10 : PlaceItem;      {space}
   11 : RestoreLevel;   {f1}
   12 : SaveLevel;      {f2}
   13 : begin           {f3}
           repeat
             Message('Enter new level number for this screen (1 - 40): ');
             GetNum(LevelNum,2)
           until LevelNum < 41;
           BlankLine;
           WriteLevelNum;
           LevelSaved := FALSE
         end;
   14 : begin           {f4}
          CheckSave;
          Sx := x;  Sy := y;  {test play level LevelNum}
          SwapVectors;
          Str(LevelNum,NumStr1);
          Str(TEST,NumStr2);
          Exec('PLAYEDIT.exe',NumStr1 + ' ' + NumStr2);
          SwapVectors;
          DrawEditor;    {return to editor}
          WriteLevelNum;
          WriteItemDesc;
          DrawLevel(1,1,64,24);
          CursorOff;
          RemKeys;
          x := Sx;  y := Sy
        end;
   15 : begin           {f5}
          if LevelNum = 0
            then begin
                   FlashMessage('Current level number must be between 1 and 40.');
                   EXIT
                 end;
          TempNum := LevelNum;
          Message('Switch this level with level number (1 - 40, 0 exits): ');
          GetNum(LevelNum,2);
          BlankLine;
          if LevelNum = 0
            then begin
                   LevelNum := TempNum;
                   EXIT
                 end
            else Message('Swapping levels...');

          Temp.Level := Level;    {hold L1 info}
          Temp.LStat := LStat;
          TempSpec   := Specials;   

          Seek(LevelF,LevelNum);  {get L2 info}
          Read(LevelF,LevelInfo);
          RestoreSpecials;

          Seek(LevelF,TempNum);   {save L2 info}
          Write(LevelF,LevelInfo);
          SaveSpecials;

          Seek(LevelF,LevelNum);  {save L1 info}
          Write(LevelF,Temp);
          Specials := TempSpec;
          SaveSpecials;

          WriteLevelNum;
          FlashMessage('Success -- The levels have been swapped!');
          LevelSaved := TRUE
        end;
   16 : begin
          FullDesc := (not FullDesc);  {f6}
          if FullDesc
            then GoldMessage('Message descriptions enabled!')
            else GoldMessage('Message descriptions disabled.')
        end;
   17 : case OPMessage('Choose Special Item to customize (1,2,3)','123') of
          '1' : DefineSpecials(Specials[1],'1');
          '2' : DefineSpecials(Specials[2],'2');
          '3' : DefineSpecials(Specials[3],'3')
        end;
   18 : DefineLevel;    {f8}
   19 : begin           {f9}
          TempNum := LevelNum;
          Message('Enter level number to view: ');
          GetNum(LevelNum,2);
          BlankLine;
          WriteLevelNum;
          Temp.Level := Level;
          Temp.LStat := LStat;

          Seek(LevelF,LevelNum);
          Read(LevelF,LevelInfo);
          Level := LevelInfo.Level;
          LStat := LevelInfo.LStat;
          DrawLevel(1,1,64,24);
          FlashMessage('Viewing level...press any key to return...');

          LevelNum := TempNum;
          WriteLevelNum;
          Level := Temp.Level;
          LStat := Temp.LStat;
          DrawLevel(1,1,64,24)
        end;
   20 : PrintOptions;   {f10}
   25 : DeleteItem;     {<backspace>}
   30 : MoveMenuCursor(-1);         {'['}
   31 : MoveMenuCursor(+1);         {']'}
   42 : SafetyOn := (not SafetyOn); {'*'}
   43 : CursorStats;                {'+'}
   63 : HelpMenu;                   {'?'}
   65..90 : PlaceLetter(Chr(Key));  {'A'..'Z'}
   99 : ExitEditor := VerifyExit;   {f10}
  end;  {Key case}
  if Key < 10
    then WriteCursor
end;

Procedure EditorLoop;
  {* Input/draw loop}

begin
  ExitEditor := FALSE;
  repeat
    SetNumLock(OFF);
    FlashMenuItem;
    FlashLevelItem;
    Delay(20);
    DrawLevel(x,y,x,y);
    if KeyPressed
      then begin
             GetEditorKey;
             DoEditFunction
           end;
    Delay(20)
  until ExitEditor
end;

Procedure ResetLevelFile;
  {* Open levels file for i/o; if doesn't exist, create blank file}
var sf : text;

begin
  Assign(LevelF,'meredit.lvl');
  {$I-}  Reset(LevelF);  {$I+}
  if IOResult <> 0   {file does not exist - create new file}
    then begin
           Message('Creating levels file...');
           Assign(sf,'meredit.spc');
           Rewrite(LevelF);  Rewrite(sf);
           for i := 0 to 40 do
             begin
               LevelInfo.Level := Level;
               LevelInfo.LStat := LStat;
               Write(LevelF,LevelInfo);  {place 40 blank levels into file}
               Writeln(sf,'*',i);        {create blank special items file}
               for j := 1 to 3 do
                 begin
                   Writeln(sf,'#',j);
                   Writeln(sf,'1 ',#127,' 9')
                 end
             end;
           Close(LevelF);  Close(sf);
           Reset(LevelF);
           BlankLine
         end;
  LevelSaved := TRUE
end;

Procedure EditorInit;
  {* Sets up variables for level editor}

begin
  CursorOff;
  SafetyOn := FALSE;
  FullDesc := FALSE;
  x  := 1;  y  := 1;
  Mx := 1;  My := 1;
  XOff := 1; YOff := 0;
  LevelNum := 0;
  for i := 1 to 64 do
    for j := 1 to 24 do
      Level[i,j] := ' ';
  with LStat do
    begin
      Name := '';
      View := TopVIEW;
      XFlip := FALSE;
      YFlip := FALSE;
      WallColor := Brown
    end;
  for i := 1 to 3 do
    with Specials[i] do
      begin
        IType := MA;
        Chr   := #127;
        Color := LightCyan;
        Item  := nil
      end;
  DrawEditor;
  WriteLevelNum;
  WriteItemDesc;
  ResetLevelFile
end;

begin   (* MAIN PROG *)
  EditorInit;
  EditorLoop;
  EditorExit
end.  {MericanEditor}
