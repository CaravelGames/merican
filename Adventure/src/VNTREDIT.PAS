Program MericanEditor;    {created by Michael Rimer}
                           {begun on 15 FEB 94; last modified 9 JUL 95}

{$M 4000,0,10000}   {allocate minimum memory required}

{Designs levels by the format used in "The 'Merican Adventure".
 Level libraries may be played with "MERVNTR" using their file name
 as a command line parameter.}

Uses Dos, Crt, CrtEXTRA,            {general libraries}
     Sounds2, Sounds,               {sound libraries}
     VntrMisc, VntrVars, VntrMstr;  {for specific game}

const
  Version = 1.07;

  MenuLength = 12;
  MenuHeight = 11;
                      {descriptions of customized items}
  GemL : array[0..5] of string[11] = ('none',
    'One gem','2 - 5 gems','5 - 10 gems','9 - 20 gems','25 gems!');
  ChestL : array[0..14] of string[20] = ('none',
    '...nothing!','Magic Sword','1 Stone Key','1 Bronze Key','1 Magic Key',
    '10 health gems','20 health gems','5 power gems','10 power gems',
    '1 magic scroll','2,500 gold pieces!','Monsters!','Fire trap!',
    'Power-up!');
  BombL : array[0..9] of string[24] = ('none',
    'Monsters, Obstacles','Destroy Monsters only','Harm Monsters only',
    'Destroy walls only','Harm walls only','Destroy Items only',
    'Walls to pits','Freeze water','Destroy trees only');
  LantL : array[0..6] of string[26] = ('none',
    'Show invisible walls (off)','Map (off)','Walls Disappear (off)',
    'Show invisible walls (on)','Map (on)','Walls Disappear (on)');
  MGenL : array[0..19] of string[15] = ('none',
    'Monster 1''s','Monster 2''s','Monster 3''s','Monster A''s','Monster B''s',
    'Monster C''s','Random Monsters','Smart 1''s','Smart 2''s','Smart 3''s',
    'Smart A''s','Smart B''s','Smart C''s','Random Smart','Thieves',
    'Wizard 1''s','Wizard 2''s','Wizard 3''s','Ghosts');
  RMZapL : array[0..20] of string[15] = ('none',
    'Monster 1''s','Monster 2''s','Monster 3''s','Monster A''s','Monster B''s',
    'Monster C''s','Random Monsters','Smart 1''s','Smart 2''s','Smart 3''s',
    'Smart A''s','Smart B''s','Smart C''s','Random Smarts','Thieves',
    'Wizard 1''s','Wizard 2''s','Wizard 3''s','Ghosts','Any type');
  RMGenL : array[0..19] of string[15] = ('none',
    'Monster 1''s','Monster 2''s','Monster 3''s','Monster A''s','Monster B''s',
    'Monster C''s','Random Monsters','Smart 1''s','Smart 2''s','Smart 3''s',
    'Smart A''s','Smart B''s','Smart C''s','Random Smart','Thieves',
    'Wizard 1''s','Wizard 2''s','Wizard 3''s','Ghosts');
  SurrL : array[0..13] of string[13] = ('none',
    'Gold','Health gems','Power gems','Inv. Potions','Crumbled Wall',
    'Solid Wall','Forest','Boulders','Lava','Water','Deep Water',
    'Stone Doors','Monsters!');
  SpearL : array[0..9] of string[9] = ('none',
    'SouthWest','South','SouthEast','West','Erratic',
    'East','NorthWest','North','NorthEast');

                      {character of items in menu}
  MenuChar : array[1..MenuHeight,1..MenuLength] of byte = (
   (Blank,BW1,BW2,BW3,SolidW,LeftSW,RightSW,UpSW,DownSW,InvSolidW,InvBW1,
     Dirt),
   (Tree,Rock,Lava,Pit,Water,DeepWater,Ice,DeepIce,Forest,DenseForest,
     ForceField,HotSpot),
   (NoMove1,NoMove2,NoMove3,NoMove4,PushBlock,Boulder,StickySpot,StoneDoor,
     BronzeDoor,MagicDoor,InvSDoor,InvBDoor),
   (HealthGem,PowerGem,InvHGem,InvPGem,GemPouch,MScroll,GoldNugget,StoneKey,
     BronzeKey,MagicKey,Raft,KStatue),
   (Freeze,Slow,Haste,InvPotion1,InvPotion2,Rope,GreasedRope,RopeExtend,
     AntiGravity,TeleTrap,WarpTrap,InvWTrap),
   (UnearthGems,BuryGems,RevealGems,HideGems,PowerUp,Tunnel,InvTunnel,
     UpStairs,DownStairs,Chute,PortalTo,PortalFrom),
   (MagicSpear,Surround,MagicBomb,Lantern,TChest,LTChest,MonsterZap,
     MonsterMake,MonZap,MonGen,RMonZap,RMonGen),
   (M1a,M2a,M3a,M1b,M2b,M3b,M1c,M2c,M3c,MW1,DF1,FB1),
   (SM1a,SM2a,SM3a,SM1b,SM2b,SM3b,SM1c,SM2c,SM3c,MW2,DF2,FB2),
   (T1,T2,T3,W1a,W2a,W3a,W1b,W2b,W3b,MW3,DF3,FB3),
   (G1,G2,G3,Special1,Special2,Special3,Special4,Special5,Special6,Special7,Special8,
     Special9));
                      {visual representation of items in menu}
{NOTE: Viewed with vntrfont.com executed to see special chars}
  MenuItem : array[1..MenuHeight,1..MenuLength] of char = (
   ('€','’','÷','◊','€','›','ﬁ','ﬂ','‹','€','◊',#255),
   (#6,#127,'÷','’','◊','’','÷','÷','’','◊','’','X'),
   ('-','-','-','-',#10,#28,'¯','È','È','ª','È','È'),
   ( #4, #9, #4, #9,'Î','∑',#15,'Â','Â','Â',#4 , #1),
   ('¥','¥','¥','§','§','≥','≥',#25,'Ÿ','˙','˙','.'),
   ('+','-', #4, #4,'∆','Ô','Ô','','Ò','O','©','©'),
   (#26,'˛','ù','Ë','≤','±','','',#11,#12,#11,#12),
   ('Ñ','î','Í','é','ì','ö','è','ô','Ä','’','€','€'),
   ('Ñ','î','Í','é','ì','ö','è','ô','Ä','÷',#28,#28),
   ('∏','∏','∏','ú','ú','ú','æ','æ','æ','◊','◊','◊'),
   ('º','º','º','1','2','3','4','5','6','7','8','9'));

                      {color of items in menu}
  MenuColor : array[1..MenuHeight,1..MenuLength] of integer = (
   (0,6,6,6,6,6,6,6,6,8,8,6),                 {128 = blink}
   (2,6,12+4*16+128,8,9+1*16+128,9+1*16+128,
    11+7*16,9+7*16,7+2*16,10+7*16,14+7*16+128,
    12),                                        {0 = black}
   (2,12,9,14,9+1*16,7,4,7*16,4*16,14,7,4),     {1 = blue}
   (11,12,1*16,1*16,14,11,14,7,12,14,13+1*16,
    15),                                        {2 = green}
   (11,10,12,13,9,15,7,10,11,10,12,15),         {3 = cyan}
   (14,6,15+6*16,6*16,14,15,8,11+128,12+128,8,
    10,12),                                     {4 = red}
   (15,7,15,14,14,6,4,14,6,4,3,5),              {5 = magenta}
   (4,2,5,4,2,5,4,2,5,7+128,4+128,5+128),       {6 = brown}
   (12,10,13,12,10,13,12,10,13,7+128,4,5),
   (6,2,4,3,11,15,3,11,15,7+128,4+128,5+128),   {7 = lt. gray}
   (8,7,15,14,14,14,14,14,14,14,14,14));

                      {names of menu items}
  ItemName  : array[1..MenuHeight,1..MenuLength] of string[14] = (
   ('Blank','Broken Wall 1','Broken Wall 2','Broken Wall 3','Solid Wall',
     'Solid Wall 2','Solid Wall 3','Solid Wall 4','Solid Wall 5',
     'Inv Solid Wall','Inv Brokn Wall','Dirt Patch'),
   ('Tree','Solid Rock','Hot Lava','Bottomless Pit','Water','Deep Water',
     'Ice','Deep Ice','Light Forest','Dense Forest','Forcefield','Hot Spot'),
   ('No-Move 1','No-Move 2','No-Move 3','No-Move 4','Moveable Block',
     'Big Boulder','Sticky Spot','Stone Door','Bronze Door','Magic Door',
     'Inv Stone Door','Inv Brnze Door'),
   ('Health Gem','Power Gem','Inv Health Gem','Inv Power Gem','Pouch of Gems',
     'Magic Scroll','Gold Nugget','Stone Key','Bronze Key','Magic Key',
     'Raft','Killer Statue'),
   ('Freeze Spell','Slow Monsters','Haste Monsters','Invis. Potion',
     'Blind Potion','Rope','Greased Rope','Rope Extend','ReverseGravity',
     'Teleport Trap','Warp Trap','Inv Walls Trap'),
   ('Unearth Gems','Bury Gems','Reveal Gems','Hide Gems','Power-Up',
     'Tunnel','Secret Tunnel','Stairs Up','Stairs Down','Chute Down',
     'Portal To...','Portal From...'),
   ('Magic Spear','Surround','Magic Bomb','Lantern','Treasure Chest',
     'Locked TrChest','Monster Zapper','Summon Monstrs','Monster Zap',
     'Mstr Generator','Random MstrZap','Rnd MstrGnratr'),
   ('Monster A-1','Monster B-1','Monster C-1','Monster A-2','Monster B-2',
     'Monster C-2','Monster A-3','Monster B-3','Monster C-3',
     'Moving Wall 1','Dropping Flr 1','Falling Blck 1'),
   ('Smart Mstr A-1','Smart Mstr B-1','Smart Mstr C-1','Smart Mstr A-2',
     'Smart Mstr B-2','Smart Mstr C-2','Smart Mstr A-3','Smart Mstr B-3',
     'Smart Mstr C-3','Moving Wall 2','Dropping Flr 2','Falling Blck 2'),
   ('Thief 1','Thief 2','Thief 3','Wizard A-1','Wizard B-1','Wizard C-1',
     'Wizard A-2','Wizard B-2','Wizard C-2','Moving Wall 3','Dropping Flr 3',
     'Falling Blck 3'),
   ('Ghost 1','Ghost 2','Ghost 3','Special 1','Special 2','Special 3',
     'Special 4','Special 5','Special 6','Special 7','Special 8','Special 9'));

     {more thorough item descriptions, written on bottom line of screen}

  FullItemDesc : array[1..MenuHeight,1..MenuLength] of string[64] = (
   ('Open space - anything can move here',
    'Breakable obstacle (60% chance to destroy with sword)',
    'Breakable obstacle (25% chance - takes up to 2 sword hits)',
    'Breakable obstacle (10% chance - takes up to 3 sword hits)',
    'Indestructable obstacle',
    'Indestructable obstacle',
    'Indestructable obstacle',
    'Indestructable obstacle',
    'Indestructable obstacle',
    'Becomes visible (as Solid Wall) when touched',
    'Becomes visible (as Broken Wall #1) when touched',
    'Background design - like blank space'),
   ('Indestructable obstacle',
    'Indestructable obstacle',
    'Player loses 10 health gems. (Hot Foot!)',
    'Instant death to touch! (Nasty for sure!)',
    'Top View: can wade through; Side View: drains oxygen level',
    'Top View: obstacle; Side View: drains oxygen/damages player',
    'Can be smashed with sword (75% chance; turns into Water)',
    'Can be smashed with sword (75% chance; turns into Deep Water)',
    'Weakest breakable obstacle (65% chance to break)',
    'Breakable obstacle (40% chance to break)',
    'Obstacle (-1 health to touch); can destroy boulders & blocks',
    'Player loses 1 health when stepped on'),
   ('Monsters cannot move here until player steps here',
    'Once player steps on, monsters can step on all CONNECTING ones',
    'Monsters can never step here (luckily for the player!)',
    'Player cannot appear here from tunnel/monsters can''t move here',
    'Player can push rows of these around the board',
    'Player can push 1 at a time (squashes monsters); 20% to destroy',
    'Slows player for a few moments',
    'Obstacle, can be removed with 1 Stone Key',
    'Obstacle, can be removed with 1 Bronze Key',
    'Obstacle (-1 health to touch), can be removed with 1 Magic Key',
    'Becomes visible (as Stone Door) when touched',
    'Becomes visible (as Bronze Door) when touched'),
   ('Gives player +1 health',
    'Gives player +1 sword',
    'Gives player +1 health (can''t be seen)',
    'Gives player +1 sword (can''t be seen)',
    'Gives player gems -- Ah, relief! (customizable)',
    'Allows player 1 magic spell',
    'Wah hoo -- 500 gold pieces!!',
    'Opens 1 Stone Door',
    'Opens 1 Bronze Door',
    'Opens 1 Magic Door; Gives player +1 magic spell',
    'Player can use to cross Deep Water (but not normal Water)',
    'Saps health gems away from player until destroyed (12% chance)'),
   ('Stops all monsters for a short time',
    'Slows monster to 1/2 speed for a short time',
    'Speeds monsters to twice speed for a short time',
    'Makes player invisible for short while',
    'Makes level invisible for short while',
    'Player can climb these on Side View levels; obstacle to monsters',
    'Player can climb these on Side View levels, but slides down',
    'Extends ropes with same Rope Tag Number',
    'Side View: Reverses gravity; Top View: reflects level',
    'Teleports player to random new spot (one time effect)',
    'Teleports player to user-specified spot (stays permanently)',
    'Makes 75 - 125 wall sections invisible (Nasty trick.)'),
   ('Creates 6 to 25 gems randomly in the level',
    'Destroys 6 to 25 random gems in the level',
    'Makes all invisible gems visible',
    'Makes all visible gems invisible',
    'Player''s sword does more damage to monsters & obstacles! (Neat.)',
    'Takes player to different visible Tunnel',
    'Takes player to different Secret Tunnel (invisible until entered)',
    'Takes player to Stairs Down on prior (upper) level',
    'Takes player to Stairs Up on following (lower) level',
    'Player falls down to same position on following (lower) level',
    'Transports player to a user-specified level, to a Portal there',
    'Portal player is brought to from a Portal on another level'),
   ('Destroys monsters, doors, etc. (customizable)',
    'Surrounds player with an item (customizable)',
    'Destroys nearby objects (radius = 5 from player; customizable)',
    'Affects viewing of entire level (customizable)',
    'Contains booty inside! (customizable)',
    'Needs 1 Stone Key to unlock, then becomes Chest (customizable)',
    'Removes 21 to 50 random monsters from the level',
    'Adds 13 to 40 monsters randomly to the level',
    'Destroys nearby monsters (customizable)',
    'Sends out monsters (customizable)',
    'The more of these on a level, the faster monsters are REMOVED...',
    'The more of these on a level, the faster NEW monsters are made..'),
   ('Hits: 1; Damage: 1; Speed: Very Slow  (wimps - take up space)',
    'Hits: 1; Damage: 2; Speed: Medium  (more dangerous)',
    'Hits: 1; Damage: 3; Speed: Fast  (a bit nasty)',
    'Hits: 2; Damage: 1; Speed: Very Slow  (tough wimps)',
    'Hits: 2; Damage: 2; Speed: Medium  (tough thugs)',
    'Hits: 2; Damage: 3; Speed: Fast  (nasty)',
    'Hits: 3; Damage: 1; Speed: Very Slow  (hard to wade through!)',
    'Hits: 3; Damage: 2; Speed: Medium  (formidable)',
    'Hits: 3; Damage: 3; Speed: Fast  (very nasty)',
    'Hits: 65% to destroy; Speed: Very Slow  (like Broken Wall #1)',
    'When stepped on, will become Falling Block #1 and fall',
    'Falls when player approaches beneath (unbreakable)'),
   ('Smart = Monster A-1, but moves around corners',
    'Smart = Monster B-1, but moves around corners',
    'Smart = Monster C-1, but moves around corners',
    'Smart = Monster A-2, but moves around corners',
    'Smart = Monster B-2, but moves around corners',
    'Smart = Monster C-2, but moves around corners',
    'Smart = Monster A-3, but moves around corners',
    'Smart = Monster B-3, but moves around corners',
    'Smart = Monster C-3, but moves around corners',
    'Hits: 50% to destroy; Speed: Very Slow  (like Broken Wall #2)',
    'When stepped on, will become Falling Block #2 and fall',
    'Falls when player approaches beneath (survives one fall)'),
   ('Thief = Hits: 1; Damage: 1; Speed: Fast (steal player''s items)',
    'Thief = Hits: 1; Damage: 2; Speed: Very Fast (steal items)',
    'Thief = Hits: 1; Damage: 3; Speed: Very Fast!! (steal items)',
    'Wizard = Hits: 1; Damage: 1; Speed: Very Slow (shoot fire)',
    'Wizard = Hits: 1; Damage: 2; Speed: Medium (shoot fire)',
    'Wizard = Hits: 1; Damage: 3; Speed: Very Fast (shoot fire)',
    'Wizard = Hits: 2; Damage: 1; Speed: Very Slow (shoot fire)',
    'Wizard = Hits: 2; Damage: 2; Speed: Medium (shoot fire)',
    'Wizard = Hits: 2; Damage: 3; Speed: Very Fast (shoot fire)',
    'Hits: 35% to destroy; Speed: Very Slow  (like Broken Wall #3)',
    'When stepped on, will become Falling Block #3 and fall',
    'Falls when player goes underneath (breaks on impact)'),
   ('Hits: 1; Dmg: 1; Speed: Slow (floats through solids)',
    'Hits: 1; Dmg: 2; Speed: Medium (floats through solids)',
    'Hits: 1; Dmg: 3; Speed: Fast (floats through solids)',
    'Special Item #1 (user-designed)',
    'Special Item #2 (user-designed)',
    'Special Item #3 (user-designed)',
    'Special Item #4 (user-designed)',
    'Special Item #5 (user-designed)',
    'Special Item #6 (user-designed)',
    'Special Item #7 (user-designed)',
    'Special Item #8 (user-designed)',
    'Special Item #9 (user-designed)'));

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
  {* User enters number, only digits allowed - ESC key exits}
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
      else if not (Ch in [#13,#27])   {ESC key exits}
             then Write(BEEP);    {beep on error}
  until ((Ch = #13) and (Length(SNum) > 0)) or (Ch = #27);
  if Ch <> #27
    then Val(SNum,Num,Error)
    else Num := 255;  {ESC}
  CursorOff
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
                    then Write(BEEP);    {beep on error}
  until (Ch = #13) and (Length(SNum) > 0);
  CursorOff;
  Val(SNum,Num,Error)
end;

Procedure EditorExit;
{Quit editor - closing screen}
begin
  Close(LevelF);    {close files}
  CursorOn;
  TextAttr := LightGray;  ClrScr;  TextAttr := White;
  Exec('vnormal.com','');
  Writeln('   THE ''MERICAN EDITOR 2');
  Writeln('       Version ',Version:1:2);
  Writeln;
  Writeln('Written by:  Michael Rimer');
  TextAttr := LightGray;
  Writeln
end;

Procedure DrawMenuItems;
{draws menu of items in info box on right side of screen}
begin
  for j := 1 to MenuHeight do
    for i := 1 to MenuLength do
      SC(66 + i,7 + j,MenuItem[j,i],MenuColor[j,i])
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
  DrawMenuItems;
  BlankLine;

  Window(65,1,80,25);
  TextAttr := White + Cyan * 16;
  Write('MERICAN EDITOR 2');
  Write('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
  Writeln;
  TextColor(Yellow);
  Writeln('      Level');
  Writeln;
  Writeln('      Item');

  Window(65,19,80,25);
  Writeln('ƒƒƒ[COMMANDS]ƒƒƒ');
  TextColor(LightCyan);
  GotoXY(1,2);  Writeln('  F1> Help');
  Writeln('  F2> Save');
  Writeln('  F3> Load');
  Writeln('  F4> Playtest');
  Writeln(' F10> Options');
  Write(' ESC> Exit');
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
  SC(66 + Mx,7 + My,MenuItem[My,Mx],Random(15) + 1)
end;

Procedure FlashLevelItem;
  {* Displays flashing spot on level where cursor is}
begin
  SC(x,y,'€',Random(15) + 1)
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
  GotoXY(68,3);  TextAttr := Yellow + Cyan * 16;
  Write('(x:',x:2,',y:',y:2,')');
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
  SC(66 + Mx,7 + My,MenuItem[My,Mx],MenuColor[My,Mx]);  {rewrite old item}

  Inc(Mx,OffSet);             {move to new item}
  if Mx < 1                   {check for line wrap-around}
    then begin
           Inc(Mx,MenuLength);
           Dec(My)
         end
    else if Mx > MenuLength
      then begin
             Dec(Mx,MenuLength);
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

Procedure DrawLevel(x1,y1,x2,y2 : integer);
  {* Draws items in (x1,y1) to (x2,y2) of current level on editor screen}
var  Spot : byte;

begin
  for j := y1 to y2 do
    for i := x1 to x2 do
      begin
        Spot := Level[i,j];
        case Spot of
          BLANK       : SC(i,j,' ',Black);
          Dirt        : SC(i,j,#255,LStat.DC);
          LetterWall  : SC(i,j,Chr(Custom[i,j]),White + LStat.WC * 16);
          BW1         : SC(i,j,'’',LStat.WC); {broken walls (1 - 3)}
          BW2         : SC(i,j,'÷',LStat.WC);
          BW3         : SC(i,j,'◊',LStat.WC);
          SolidW      : SC(i,j,'€',LStat.WC); {solid wall}
          LeftSW      : SC(i,j,'›',LStat.WC); {half solid walls}
          RightSW     : SC(i,j,'ﬁ',LStat.WC);
          UpSW        : SC(i,j,'ﬂ',LStat.WC);
          DownSW      : SC(i,j,'‹',LStat.WC);
          InvSolidW   : SC(i,j,'€',DarkGray); {inv. solid wall}
          InvBW1      : SC(i,j,'◊',DarkGray); {inv. broken wall}
          InvWTrap    : SC(i,j,'.',White);    {invisible walls trap}
          Tree        : SC(i,j,#6,Green);
          Rock        : SC(i,j,#127,Brown);   {rock, stationary}
          Lava        : SC(i,j,'÷',LightRed + Red * 16 + Blink);
          Pit         : SC(i,j,'’',DarkGray); {bottomless pit}
          Water       : SC(i,j,'◊',LightBlue + Blue * 16 + Blink);
          DeepWater   : SC(i,j,'’',LightBlue + Blue * 16 + Blink);
          Ice         : SC(i,j,'÷',LightCyan + LightGray * 16);
          DeepIce     : SC(i,j,'÷',LightBlue + LightGray * 16);
          Forest      : SC(i,j,'’',LightGray + Green * 16);
          DenseForest : SC(i,j,'◊',LightGreen + LightGray * 16);
          ForceField  : SC(i,j,'’',Yellow + LightGray * 16 + Blink);
          HotSpot     : SC(i,j,'X',LightRed);
          NoMove1     : SC(i,j,'-',Green);     {monster no-move spots (1 - 4)}
          NoMove2     : SC(i,j,'-',LightRed);
          NoMove3     : SC(i,j,'-',LightBlue);
          NoMove4     : SC(i,j,'-',Yellow);
          PushBlock   : SC(i,j,#10,LightBlue + Blue * 16); {pushable block}
          Boulder     : SC(i,j,#28,LightGray);   {boulder, moveable}
          StickySpot  : SC(i,j,'¯',Red);
          StoneDoor   : SC(i,j,'È',LightGray * 16);
          BronzeDoor  : SC(i,j,'È',Red * 16);
          MagicDoor   : SC(i,j,'ª',Yellow);
          InvSDoor    : SC(i,j,'È',LightGray);   {inv. stone door}
          InvBDoor    : SC(i,j,'È',Red);         {inv. bronze door}
          HealthGem   : SC(i,j,#4,11 {HGColor});
          InvHGem     : SC(i,j,#4,Blue * 16);    {inv. health gem}
          PowerGem    : SC(i,j,#9,12 {PGColor});
          InvPGem     : SC(i,j,#9,Blue * 16);    {inv. power gem}
          GemPouch    : SC(i,j,'Î',Yellow);
          MScroll     : SC(i,j,'∑',LightCyan);   {magic scroll}
          GoldNugget  : SC(i,j,#15,Yellow);
          StoneKey    : SC(i,j,'Â',LightGray);
          BronzeKey   : SC(i,j,'Â',LightRed);
          MagicKey    : SC(i,j,'Â',Yellow);
          TeleTrap    : SC(i,j,'˙',LightGreen);  {teleport trap}
          WarpTrap    : SC(i,j,'˙',LightRed);
          Freeze      : SC(i,j,'¥',LightCyan);   {freeze monsters}
          Slow        : SC(i,j,'¥',LightGreen);  {slow monsters}
          Haste       : SC(i,j,'¥',LightRed);    {quicken monsters}
          InvPotion1  : SC(i,j,'§',LightMagenta);{invisibility potion}
          InvPotion2  : SC(i,j,'§',LightBlue);   {blindness potion}
          Rope        : SC(i,j,'≥',White);
          GreasedRope : SC(i,j,'≥',LightGray);
          AntiGravity : SC(i,j,'Ÿ',LightCyan);   {reverse gravity}
          RopeExtend  : SC(i,j,#25,LightGreen);
          KStatue     : SC(i,j,#1,White);        {killer statue}
          Raft        : SC(i,j,#4,LightMagenta + Blue * 16);
          UnearthGems : SC(i,j,'+',Yellow);
          BuryGems    : SC(i,j,'-',Brown);
          RevealGems  : SC(i,j,#4,White + Brown * 16);
          HideGems    : SC(i,j,#4,Brown * 16);
          PowerUp     : SC(i,j,'∆',Yellow);      {sword power-up}
          Tunnel      : SC(i,j,'Ô',White);       {teleport tunnel}
          InvTunnel   : SC(i,j,'Ô',DarkGray);    {secret tunnel}
          UpStairs    : SC(i,j,'',LightCyan + Blink); {stairs upward}
          DownStairs  : SC(i,j,'Ò',LightRed + Blink);  {stairs downward}
          Chute       : SC(i,j,'O',DarkGray);    {chute down}
          PortalTo    : SC(i,j,'©',LightGreen);  {portal to level ...}
          PortalFrom  : SC(i,j,'©',LightRed);    {portal from level ...}
          MagicSpear  : case Custom[i,j] of      {magic spears}
                    2 : SC(i,j,#25,LightGray);
                    4 : SC(i,j,#27,LightGray);
                    6 : SC(i,j,#26,LightGray);
                    8 : SC(i,j,#24,LightGray);
                  1,9 : SC(i,j,'/',LightGray);
                  3,7 : SC(i,j,'\',LightGray);
                    5 : SC(i,j,#29,LightGray);
                   else SC(i,j,'?',LightGray)    {?}
                        end;
          Surround    : SC(i,j,'˛',LightGray);   {item surround}
          MagicBomb   : SC(i,j,'ù',White);
          Lantern     : SC(i,j,'Ë',Yellow);
          TChest      : SC(i,j,'≤',Yellow);      {treasure chest}
          LTChest     : SC(i,j,'±',Brown);       {locked chest}
          MonsterZap  : SC(i,j,'',Red);
          MonsterMake : SC(i,j,'',Yellow);      {create monsters}
          MonZap      : SC(i,j,#11,Brown);
          MonGen      : SC(i,j,#12,Red);         {monster generator}
          RMonZap     : SC(i,j,#11,Cyan);
          RMonGen     : SC(i,j,#12,Magenta);     {monster remover}
          MW1         : SC(i,j,'’',LightGray + Blink); {moving walls}
          MW2         : SC(i,j,'÷',LightGray + Blink);
          MW3         : SC(i,j,'◊',LightGray + Blink);
          DF1         : SC(i,j,'€',Red + Blink); {dropping floors}
          DF2         : SC(i,j,#28,Red);
          DF3         : SC(i,j,'◊',Red + Blink);
          FB1         : SC(i,j,'€',Magenta + Blink); {falling blocks}
          FB2         : SC(i,j,#28,Magenta);
          FB3         : SC(i,j,'◊',Magenta + Blink);
          M1a..G3     : DrawMonster(i,j,0); {monsters at full hits}
          Special1..Special9 : SC(i,j,Chr(Spot - 91),Yellow);
          else SC(i,j,'?',White + Blink)         {- unknown char -}
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
  Writeln('     This program,  part of the "''MERICA" game series, is a');
  Writeln(' level designer,  based on  Volume III,  named "THE MERICAN');
  Writeln(' ADVENTURE". With it, you, the game player, can create your');
  Writeln(' your own  personalized levels!!   The main screen displays');
  Writeln(' the current level  in memory,  and the window to the right');
  Writeln(' lists the level number,  a menu of all items  you may use,');
  Writeln(' and a few options available.  The solid line at the bottom');
  Writeln(' of the screen displays messages from time to time.');
  Writeln('    Use the keyboard''s numeric keypad to move the cursor on');
  Writeln(' on the level map, the "[]" and "{}" keys to scroll through');
  Writeln(' the menu of items,  and the F10 key for game options.  The');
  Writeln(' Spacebar places items, and the Backspace key deletes them.');
  Writeln;
  Write('                       Hit any key...');
  repeat until KeyPressed;  RemKeys;

  SolidWindow(2,5,63,22);
  TextColor(LightCyan);
  Writeln('                  ƒƒƒ[ LEVEL DESIGN ]ƒƒƒ');
  Writeln;
  Writeln('    You are able to design up to 25 levels and save them to');
  Writeln(' file on disk (levels are in file with the extension ".LVL"');
  Writeln(' and items  designed by the user  are placed  into the file');
  Writeln(' with extension ".SPC").  To design more than 25 levels you');
  Writeln(' must store each set under a different filename.     Create');
  Writeln(' your own game file by typing at the command prompt:');
  Writeln('                     "VNTREDIT <name of my file>"');
  Writeln('   Run your file by: "VNTR <name of my file>"');
  Writeln('   Feel free to experiment with all possibilities included.');
  Writeln(' (However, due to design features,  special functions which');
  Writeln(' you personally create may  never have been intended to run');
  Writeln(' as you have made them.  If the game does not operate as it');
  Writeln(' should (halts, freezes up), then all that needs to be done');
  Writeln(' is to modify those designs.  (Enough said.)');
  Writeln;
  Write('                       Hit any key...');
  repeat until KeyPressed;  RemKeys;

  SolidWindow(2,2,63,23);
  TextColor(LightCyan);
  Writeln('                   ƒƒƒ[ REGISTERING ]ƒƒƒ');
  Writeln;
  Writeln('   "The ''Merican Editor" is not shareware, but it is user-');
  Writeln(' supported.   A payment of $10 to the author is  requested');
  Writeln(' in order to use this product (check or money order).  Your');
  Writeln(' payment entitles you  to receive notification  of further');
  Writeln(' volumes in the "''Merica" series as they are designed,  as');
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
  Writeln('                                ');
  Writeln('                                ');
  Writeln;
  Write('    Have fun, and thank you for playing! -- Michael Rimer');
  repeat until KeyPressed;  RemKeys;
  EraseWindow(2,2,63,23);
end;

Procedure CursorMenu;
begin
  TextAttr := Yellow + LightGray * 16;
  Writeln('   ƒƒƒ[ CURSOR OFFSET ]ƒƒƒ');
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
  Writeln('                 ƒƒƒ[ OPTIONS ]ƒƒƒ');
  Writeln;
  Writeln(' F1 -- Help screen      F2 -- Save Level');
  Writeln(' F3 -- Load Level       F4 -- Playtest Level');
  Writeln(' F5 -- Swap Levels      F6 -- Toggle Full Description');
  Writeln(' F7 -- Define Specials  F8 -- Level Stats');
  Writeln(' F9 -- Select Level #   F10 - Go to this menu!');
  Writeln('  * -- Toggle safety mode (overtype)');
  Writeln('  + -- Change cursor movement offset');
  Writeln;
  Write('                   Hit any key...');
  repeat until KeyPressed;  RemKeys;
  EraseWindow(5,8,60,18)
end;

(********************* SPECIAL ITEMS **************************)

Procedure SpecMenu;
begin
  TextColor(Red);
  Writeln('Type:                 Shade:      Pic:        Walk On:');
  Writeln('A: ');
  Writeln('B: ');
  Writeln('C: ');
  Writeln('D: ');
  Writeln('E: ');
  Writeln('F: ');
  Writeln('G: ');
  Writeln('H: ');
  Writeln('I: ');
  Writeln('J: ');
  Writeln('K: ');
  Writeln('L: ');
  Writeln('M: ');
  Writeln;
  Writeln('?: Help Menu');
  Writeln('ESC: Done modifying');
  Writeln('Options : T, S, P, W, A - M, ?, ESC');
end;

Procedure SpecStats(Spec : SpecRec);
  {* Writes out statistics for Spec}
var Trav : SpecItemPtr;

begin
  GotoXY(7,2);
  TextAttr := Blue + LightGray * 16;
  case Spec.IType of
    MUse : Write('Multiple Use');
    SUse : Write('Single Use  ')
  end;
  GotoXY(56,2);
  if Spec.MoveOn = 1
    then Write('YES') else Write('NO ');
  GotoXY(30,2);
  Write(Spec.Color:3);
  GotoXY(40,2);  TextAttr := Spec.Color;
  Writeln(Spec.Chr);
  TextAttr := Yellow + LightGray * 16;
  Trav := Spec.Item;
  while Trav <> nil do
    begin
      GotoXY(4,WhereY);
      for i := 1 to Length(Trav^.Data) do
        if i < 56 then Write(Trav^.Data[i]);
      for i := 1 to (56 - Length(Trav^.Data))
        do Write(' ');
      Writeln;
      Trav := Trav^.next
    end;
  GotoXY(3,WhereY);
  for i := 1 to 56 do Write(' ')
end;

Procedure AddStr(var DS : String64);
  {* Add string into DS}
var S : string;

begin
  SolidWindow(1,23,64,24);
  Writeln('Enter your message below (max. 62 chars): ');
  TextColor(Yellow);  Readln(S);
  DS := DS + ' ' + S;
  while Length(DS) > 64 do
    Delete(DS,65,1);
  EraseWindow(1,23,64,24)
end;

Procedure AddNum(var DS : String64; Digits : byte);
  {* Add number into DS}
var N : byte;
    S : string;

begin
  GetNum(N,Digits);
  Str(N,S);
  DS := DS + ' ' + S
end;

Procedure AddNum2(var DS : String64; Digits : byte);
  {* Add number into DS}
var N : integer;
    S : string;

begin
  GetNum2(N,Digits);
  Str(N,S);
  DS := DS + ' ' + S
end;

Procedure AddItem(var DS : String64);
  {* Choose item from menu to add into DS}
var C : byte;

begin
  C := LetterWall;
  while (C = LetterWall) do
    begin
      FlashMenuItem;
      Delay(40);
      if KeyPressed
        then begin
               GetEditorKey;
               case Key of
                 10 : C := MenuChar[My,Mx]; {SPACE}
                 25 : C := BLANK;           {backspace}
                 30 : MoveMenuCursor(-1);   {'['}
                 31 : MoveMenuCursor(+1);   {']'}
                 32 : MoveMenuCursor(-MenuLength);  {'{'}
                 33 : MoveMenuCursor(+MenuLength);  (*}*)
               end
             end
    end;

  DS := DS + ' ' + Chr(C)
end;

Procedure AddPos(var DS : String64);
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
  {* Help menu for special effects of customized items}
var N, k : byte;

begin
  SolidWindow(3,6,61,18);
  Writeln('           ƒƒƒ[ Special Effects Menu ]ƒƒƒ');
  Writeln;
  Writeln('     sound ƒ\/ƒ visual   y = any number from 0 - 3');
  Writeln(' (optional) ≥≥           x = any number from 0 - 9');
  Writeln('            ≥≥');
  Writeln('            xy         <== How an effect is entered.');
  Writeln;
  Writeln('   The last digit of the number you enter corresponds to');
  Writeln(' the visual effect you will see when an item is modified');
  Writeln(' on the screen.  If you have a number before this number');
  Writeln(' this number,   it will match with a sound which is made');
  Writeln(' every time an item is changed (this is optional).');
  repeat
    Message('Enter a number to hear any sound (1 - 9,0 exits): ');
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
    6 : Sticky;
    7 : UpScratch1;
    8 : WarpUp1;
    9 : TripleChirp;
    end;
  until N = 0;
  EraseWindow(3,6,61,18)
end;

Procedure DefineSpecData(Data : SpecRec; var DS : String64;
                          Num : integer; C : char);
  {* Enter data into string DS for special item}
var S : string;  C1, L : char;
    N : byte;

begin
  BlankLine;
  case Num of
    0..3 : begin
          EraseWindow(2,3,63,22);
          Message('Move cursor to upper-left corner of affected area and hit SPACE.');
          AddPos(DS);
          Message('Move cursor to lower-right corner of area and hit SPACE.');
          AddPos(DS);
          BlankLine;
          SolidWindow(2,3,63,22);
          Writeln('Special Item #' + C);
          SpecMenu;
          Window(3,3,64,23);
          SpecStats(Data)
        end;
    4 : AddStr(DS);
    5 : begin
          SolidWindow(15,6,50,12);  TextColor(Yellow);
          Writeln('        ƒƒ[ STATISTICS ]ƒƒ');
          Writeln;
          Writeln('1>  Score      5>  Stone Keys');
          Writeln('2>  Health     6>  Bronze Keys');
          Writeln('3>  Sword      7>  Magic Keys');
          Writeln('4>  Magics     8>  Power-Ups');
          Window(1,1,80,25);
          Message('Choose player statistic to modify (1 - 8): ');
          AddNum2(DS,1);
          Message('Increase or Decrease value (+,-)? ');
          repeat C1 := ReadKey until (C1 in ['+','-']);
          DS := DS + ' ' + C1;  BlankLine;
          Message('Enter amount to change info by (1 - 9999): ');
          AddNum2(DS,4);
          BlankLine;
          TextAttr := LightGray * 16;  Window(15,6,50,12);  ClrScr;
          Window(1,1,80,25)
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
        end;
    7 : begin
          AddStr(DS);  Delete(DS,1,2);  {remove "7 "}
          Message('Enter key to hit to select choice #1: ');
          repeat C1 := UpCase(ReadKey) until (C1 in [#32..#127]);
          S := '7 ' + C1;  BlankLine;
          Message('Branch to line (A - M) when "' + C1 + '" is hit: ');
          repeat C1 := UpCase(ReadKey) until (C1 in ['A'..'M']);
          S := S + C1;  BlankLine;
          Message('Enter key to hit to select choice #2: ');
          repeat C1 := UpCase(ReadKey) until (C1 in [#32..#127]);
          S := S + C1;  BlankLine;
          Message('Branch to line (A - M) when "' + C1 + '" is hit: ');
          repeat C1 := UpCase(ReadKey) until (C1 in ['A'..'M']);
          S := S + C1;  BlankLine;
          DS := S + DS
        end;
    8 : begin
          Message('Jump to line (A - M): ');
          repeat C1 := UpCase(ReadKey) until (C1 in ['A'..'M']);
          DS := '8 ' + C1;  BlankLine
        end;
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
          Message('Highlight item type to replace and hit SPACE.');
          AddItem(DS);
          Message('Highlight item to replace with and hit SPACE.');
          AddItem(DS);
          BlankLine
        end
  end;

  if (Num in [0..3])
    then begin
           repeat
             Message('Choose sound/visual effect (99 for help): ');
             GetNum(N,3);
             BlankLine;
             if N = 99
               then begin
                      EraseWindow(2,3,63,22);
                      EffectsMenu;
                      SolidWindow(2,3,63,22);
                      Writeln('Special Item #' + C);
                      SpecMenu;
                      Window(3,3,64,23);
                      SpecStats(Data);
                      Window(1,1,80,25)
                    end
           until (N >= 0) and (N <= 93);
           Str(N,S);
           DS := DS + ' ' + S
         end
end;

Procedure SpecEffect(Item : SpecRec; var Spec : SpecItemPtr;
                        N : integer;   {action line chosen}
                        C : char);     {special item #}
  {* Select effect for special item and place into list}
var Trav, T2, NewData : SpecItemPtr;
    N2, Eff : byte;
    Cnt : integer;
      S : string[1];

begin
  Message('Enter Effect Type (0 - 8,9 erases line,ESC to end): ');
  GetNum(Eff,1);
  BlankLine;
  if Eff = 255 then EXIT;   {ESC hit - abort}

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
      Dec(N,Cnt);  {if blank action lines above N...}
      Dec(N2,Cnt);  {...then move N up to first blank line}
      if (Trav^.next = nil) and (N < 13) and (Cnt <> 0)
        then begin
               Inc(N2);   {end of list...move to 1st blank line}
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
  SolidWindow(3,1,62,24);
  TextColor(Blue);
  Writeln('              ƒƒƒ[ SPECIAL ITEMS HELP ]ƒƒƒ');
  TextColor(Magenta);
  Writeln('Listing of effects for special item data slots (1 - 9).');
  Writeln;
  TextColor(Red);
  Writeln(' 0 x1 y1 x2 y2 i e        {all affected spots become i}');
  Writeln(' 1 x1 y1 x2 y2 i1 i2 e    {all i1''s here become i2}');
  Writeln(' 2 x1 y1 x2 y2 i1 i2 e    {all not i1''s become i2}');
  Writeln(' 3 x1 y1 x2 y2 i1 i2 e    {i1''s become i2, & vice-versa}');
  Writeln(' 4 Message                {message (up to 62 chars)}');
  Writeln(' 5 i <+/->n               {alter player info i, n amount}');
  Writeln(' 6 f1 f2 s d              {sound from freq f1 to f2, w/');
  Writeln('                           step s, with delay d (in ms)}');
  Writeln(' 7 Message i1 L1 i2 L2    {branch to action L1 if i1 hit,');
  Writeln('                           or branch to L2 if i2 hit}');
  Writeln(' 8 L1                     {jump to action L1}');
  Writeln;
  TextColor(LightBlue);
  Writeln('Symbols:  (x1, y1)  = top-left corner on screen');
  Writeln('          (x2, y2)  = lower-right corner on screen');
  Writeln('          i, i1, i2 = any character symbol (use ',#17,'ƒƒ key');
  Writeln('                        (backspace) for Blank Spot)');
  Writeln('          e         = visual/audio effect used');
  Writeln('          s, d      = sound frequency, delay (milli-sec)');
  Writeln('          L1, L2    = any letter/action line');
  Writeln;
  Write('                     Hit any key...');
  repeat until KeyPressed;  RemKeys;
  EraseWindow(3,1,62,24)
end;

Procedure DefineSpecials(var Spec : SpecRec; C : char);
  {* Player chooses special item to customize}
var Saved : boolean;

begin
  Saved := FALSE;
  SolidWindow(2,3,63,22);
  Writeln('                ƒƒƒ  Special Item #' + C + ' ƒƒƒ');
  SpecMenu;
  repeat
    Window(3,3,64,23);
    SpecStats(Spec);
    GetEditorKey;
    Window(1,1,80,25);
    case Key of
  {T} 84 : if Spec.IType = MUse
             then Spec.IType := SUse
             else Spec.IType := MUse;
  {W} 87 : if Spec.MoveOn = 1
             then Spec.MoveOn := 2
             else Spec.MoveOn := 1;
  {P} 80 : begin
             Message('Hit any key for picture of item...');
             Spec.Chr := ReadKey;
             BlankLine;
             RemKeys
           end;
  {S} 83 : repeat
             Message('Enter number for color of item (0 - 255): ');
             GetNum(Spec.Color,3);
             BlankLine
           until Spec.Color < 256;
      65..77 : SpecEffect(Spec,Spec.Item,Key - 64,C); {A - M}
  {?} 61 : begin
             SpecialHelp;
             SolidWindow(2,3,63,22);
             Writeln('                ƒƒƒ  Special Item #' + C + ' ƒƒƒ');
             SpecMenu
           end;
      99 : {exit};  {ESC}
    else Write(BEEP)
    end;
    if (Key in [84,87,80,83,65..77])
      then LevelSaved := FALSE
  until Key = 99;
  EraseWindow(2,3,63,22)
end;

Procedure LevelMenu;
begin
  TextColor(Blue);
  Writeln('    ƒƒƒ[ LEVEL STATISTICS ]ƒƒƒ');
  Writeln('Name: ');
  Writeln('Type: ');
  Writeln('Music: ');
  Writeln('Reverse X: ');
  Writeln('Reverse Y: ');
  Writeln('Wall Color: ');
  Writeln('Dirt Color: ');
  Writeln('A> Warp to X: ');
  Writeln('B> Warp to Y: ');
  Writeln('ESC: Done modifying');
  Writeln('OPTIONS: N, T, M, X, Y, W, D, A, B, ESC')
end;

Procedure LevelStats;
  {* Writes out level statistics}
begin
  Window(14,7,54,19);
  TextAttr := Yellow + LightGray * 16;
  GotoXY(7,2);  Write(LStat.Name);
  for i := 1 to (28 - Length(LStat.Name)) do
    Write(' ');
  GotoXY(7,3);
  case LStat.View of
    Top      : Write('Top View   ');
    TopDark  : Write('Top (Dark) ');
    Side     : Write('Side View  ');
    SideDark : Write('Side (Dark)');
  end;
  GotoXY(8,4);
  Write(MusicName[LStat.Music]);
  GotoXY(12,5);
  if LStat.XFlip
    then Write('ON ')
    else Write('OFF');
  GotoXY(12,6);
  if LStat.YFlip
    then Write('ON ')
    else Write('OFF');
  GotoXY(15,9);
  Write(LStat.Tx:2);
  GotoXY(15,10);
  Write(LStat.Ty:2);
  GotoXY(13,7);
  TextColor(LStat.WC);
  Write('€€€€€');
  GotoXY(13,8);
  TextColor(LStat.DC);
  Write('’’’’’');
end;

Procedure DefineLevel;
  {* Customizes current level}
var OldWC : integer;

begin
  OldWC := LStat.WC;
  SolidWindow(13,7,54,18);
  LevelMenu;
  repeat
    LevelStats;
    GetEditorKey;
    case Key of
 {A}  65 : repeat
             Window(1,1,80,25);
             Message('Enter x coordinate of warp destination (1 - 64): ');
             GetNum(LStat.Tx,2);
             BlankLine
           until LStat.Tx in [1..64];
 {B}  66 : repeat
             Window(1,1,80,25);
             Message('Enter y coordinate of warp destination (1 - 24): ');
             GetNum(LStat.Ty,2);
             BlankLine
           until LStat.Ty in [1..24];
 {D}  68 : repeat
             Window(1,1,80,25);
             Message('Enter number for color of dirt (0 - 255): ');
             GetNum(LStat.DC,3);
             BlankLine
           until LStat.WC < 256;
 {M}  77 : repeat
             SolidWindow(35,3,60,23);
             for i := 0 to 19 do Writeln(i,': ',MusicName[i]);
             Message('Enter new music (1 - 19): ');
             GetNum(LStat.Music,2);
{*} {        PlayWav(MusicFile[LStat.Music] + '.wav');} {have no heap memory!}
             BlankLine;
             EraseWindow(35,3,60,23);
             SolidWindow(13,7,54,18);
             LevelMenu
           until (Num in [0..19]);
 {N}  78 : begin
             GotoXY(7,2);
             CursorFull;
             Readln(LStat.Name);
             CursorOff
           end;
 {T}  84 : case LStat.View of
             Top      : LStat.View := TopDark;
             TopDark  : LStat.View := Side;
             Side     : LStat.View := SideDark;
             SideDark : LStat.View := Top
           end;
 {W}  87 : repeat
             Window(1,1,80,25);
             Message('Enter number for color of walls (0 - 15): ');
             GetNum(LStat.WC,2);
             BlankLine
           until LStat.WC < 16;
 {X}  88 : LStat.XFlip := (not LStat.XFlip);
 {Y}  89 : LStat.YFlip := (not LStat.YFlip);
      99 : {exit};  {ESC}
    end;
    if Key <> 99
      then LevelSaved := FALSE
  until Key = 99;
  if OldWC <> LStat.WC
    then begin
           Window(1,1,80,25);
           DrawLevel(1,1,64,24)
         end
    else EraseWindow(13,7,54,18)
end;

Procedure PlaceLetter(Ch : byte);
  {* Places wall character in level}
begin
  if SafetyOn and (Level[x,y] <> BLANK)
    then begin
           PSound(300,25);
           NoSound
         end
    else begin
           Level[x,y] := LetterWall;
           Custom[x,y] := Ch
         end;
  DrawLevel(x,y,x,y);
  Inc(x,XOff);
  Inc(y,YOff);
  WriteCursor;
  LevelSaved := FALSE
end;

Procedure CustomOptions(Item : byte);
  {* Menu displayed, and user chooses new function for item to perform}
var Num : byte;   {take in new values}

begin
 repeat
  case Item of
    GemPouch : begin
      SolidWindow(44,10,60,16);  Writeln;
      for i := 1 to 5 do Writeln(i,': ',GemL[i]);
      Message('Choose new contents (1 - 5): ');
      GetNum(Num,1);
      BlankLine;
      EraseWindow(44,10,60,16);
      if Num in [1..5] then Custom[x,y] := Num
    end;
    TChest, LTChest : begin
      SolidWindow(25,10,50,24);
      for i := 1 to 14 do Writeln(i,': ',ChestL[i]);
      Message('Choose new contents (1 - 14): ');
      GetNum(Num,2);
      BlankLine;
      EraseWindow(25,10,50,24);
      if Num in [1..14,99] then Custom[x,y] := Num  {#99 is BigSecret}
    end;
    Surround : begin
      SolidWindow(33,8,61,22);  Writeln;
      for i := 1 to 13 do Writeln(i,': ',SurrL[i]);
      Message('Choose new object (1 - 13): ');
      GetNum(Num,2);
      BlankLine;
      EraseWindow(33,8,61,22);
      if Num in [1..13] then Custom[x,y] := Num
    end;
    MagicBomb : begin
      SolidWindow(30,10,59,20);  Writeln;
      for i := 1 to 9 do Writeln(i,': ',BombL[i]);
      Message('Choose new effect (1 - 9): ');
      GetNum(Num,1);
      BlankLine;
      EraseWindow(30,10,59,20);
      if Num in [1..9] then Custom[x,y] := Num
    end;
    Lantern : begin
      SolidWindow(30,10,61,17);  Writeln;
      for i := 1 to 6 do Writeln(i,': ',LantL[i]);
      Message('Choose new effect (1 - 6): ');
      GetNum(Num,2);
      BlankLine;
      EraseWindow(30,10,61,17);
      if Num in [1..6] then Custom[x,y] := Num
    end;
    MagicSpear : begin
      SolidWindow(45,10,60,20);  Writeln;
      for i := 1 to 9 do Writeln(i,': ',SpearL[i]);
      Message('Enter new direction (1 - 9): ');
      GetNum(Num,1);
      BlankLine;
      EraseWindow(45,10,60,20);
      if Num in [1..9] then Custom[x,y] := Num;
      DrawLevel(x,y,x,y)
    end;
    MonGen : begin
      SolidWindow(35,4,60,23);
      for i := 1 to 19 do Writeln(i,': ',MGenL[i]);
      Message('Enter new monster type (1 - 19): ');
      GetNum(Num,2);
      BlankLine;
      EraseWindow(35,4,60,23);
      if Num in [1..19] then Custom[x,y] := Num
    end;
    RMonZap : begin
      SolidWindow(35,4,60,23);
      for i := 1 to 19 do Writeln(i,': ',RMZapL[i]);
      Message('Enter new monster type (1 - 20): ');
      GetNum(Num,2);
      BlankLine;
      EraseWindow(35,4,60,23);
      if Num in [1..20] then Custom[x,y] := Num
    end;
    RMonGen, MonsterMake : begin
      SolidWindow(35,4,60,23);
      for i := 1 to 19 do Writeln(i,': ',RMGenL[i]);
      Message('Enter new monster type (1 - 19): ');
      GetNum(Num,2);
      BlankLine;
      EraseWindow(35,4,60,23);
      if Num in [1..19] then Custom[x,y] := Num
    end;
    RopeExtend : begin
      Message('Choose rope tag number (1 - 255): ');
      GetNum(Num,2);
      BlankLine;
      if Num < 256 then Custom[x,y] := Num
    end;
    PortalTo, PortalFrom : begin
      Message('Choose new connecting level (1 - 25): ');
      GetNum(Num,2);
      BlankLine;
      if Num in [1..NumOfLevels] then Custom[x,y] := Num
    end;
  end  {case}
 until Custom[x,y] <> 0
end;

Procedure CustomCheck(Option : integer);
  {* User specifies function for customized items}
const MandADD = 1;
      MODIFY  = 2;
var Ch : char;

begin
  if (MenuChar[My,Mx] in [GemPouch,TChest,LTChest,Surround,MagicBomb,Lantern,
               MagicSpear,MonGen,RMonZap,RMonGen,MonsterMake,RopeExtend,
               PortalTo,PortalFrom])
    then begin
           SolidWindow(5,2,40,8);  TextColor(Yellow);
           Writeln('         ƒƒ ',ItemName[My,Mx],' ƒƒ');
           Writeln;
           case MenuChar[My,Mx] of
             GemPouch : begin
               Writeln('Contents: ',Custom[x,y]);
               Writeln('(',GemL[Custom[x,y]],')');
               end;
             TChest, LTChest : begin
               Writeln('Contents: ',Custom[x,y]);
               if Custom[x,y] <> 99
                 then Writeln('(',ChestL[Custom[x,y]],')')
                 else Writeln('(Big Secret)')
               end;
             Surround : begin
               Writeln('Object: ',Custom[x,y]);
               Writeln('(',SurrL[Custom[x,y]],')');
               end;
             MagicBomb : begin
               Writeln('Effect: ',Custom[x,y]);
               Writeln('(',BombL[Custom[x,y]],')');
               end;
             Lantern : begin
               Writeln('Effect: ',Custom[x,y]);
               Writeln('(',LantL[Custom[x,y]],')');
               end;
             MagicSpear : begin
               Writeln('Direction: ',Custom[x,y]);
               Writeln('(',SpearL[Custom[x,y]],')');
               end;
             MonGen : begin
               Writeln('Monster Type: ',Custom[x,y]);
               Writeln('(',MGenL[Custom[x,y]],')')
               end;
             RMonZap : begin
               Writeln('Monster Type: ',Custom[x,y]);
               Writeln('(',RMZapL[Custom[x,y]],')')
               end;
             RMonGen,MonsterMake : begin
               Writeln('Monster Type: ',Custom[x,y]);
               Writeln('(',RMGenL[Custom[x,y]],')')
               end;
             RopeExtend : begin
               Writeln('Rope tag number: ',Custom[x,y]);
               if Custom[x,y] = 0 then Writeln('(none)')
               end;
             PortalTo, PortalFrom : begin
               Writeln('Connecting Level: ',Custom[x,y]);
               if Custom[x,y] = 0 then Writeln('(none)')
               end;
           end;  {case}
           Writeln;
           if Option = MODIFY
             then begin
               Writeln('ENTER> Alter item function');
               Write('ESC> Quit without changing')
             end
         end
    else EXIT;
  Ch := #13;
  if Option = MODIFY
    then repeat
           Ch := ReadKey;
         until Ch in [#13,#27];
  if Ch = #13 then
    CustomOptions(MenuChar[My,Mx]);   {user gives function to item}
  EraseWindow(5,2,40,8)
end;

Procedure PlaceItem;
  {* Places selected item at pos (x,y) in level}
const MandADD = 1;
      MODIFY  = 2;
var Option : integer;

begin
  if SafetyOn and ((Level[x,y] <> BLANK) and (Level[x,y] <> MenuChar[Mx,My]))
    then begin
           PSound(150,25);
           NoSound
         end
    else if Level[x,y] = MenuChar[My,Mx]
           then Option := MODIFY
           else begin
                  Option := MandADD;
                  Custom[x,y] := 0;
                  Level[x,y] := MenuChar[My,Mx]  {place item in Level array}
                end;
  DrawLevel(x,y,x,y);                   {print item on screen}
  CustomCheck(Option);           {specify function for customized item}
  Inc(x,XOff);                   {move cursor to new spot}
  Inc(y,YOff);
  WriteCursor;
  LevelSaved := FALSE
end;

Procedure DeleteItem;
  {* Delete item at pos (x,y) in level}
begin
  Level[x,y] := BLANK;
  Custom[x,y] := 0;
  DrawLevel(x,y,x,y);
  Inc(x,XOff);
  Inc(y,YOff);
  WriteCursor;
  LevelSaved := FALSE
end;

Procedure ViewLevel;
{* Views level until key is pressed, then reloads current level (in TempNum)}
begin
  WriteLevelNum;
  Temp.Level := Level;
  Temp.LStat := LStat;

  Seek(LevelF,LevelNum);
  Read(LevelF,LevelInfo);
  Level := LevelInfo.Level;
  LStat := LevelInfo.LStat;
  DrawLevel(1,1,64,24);
  FlashMessage('Viewing this level...press any key to return...');

  LevelNum := TempNum;
  WriteLevelNum;
  Level := Temp.Level;
  LStat := Temp.LStat;
  DrawLevel(1,1,64,24)
end;

{---------------------}

Procedure SaveLevel;
  {* Saves current maze under current level number}
var SNum : string[3];
    Old  : integer;

begin
  if LevelNum = 0
    then begin
          repeat
           Message('Enter level number to save this screen on (1 - 25,0 to exit): ');
           TempNum := LevelNum;
           GetNum(LevelNum,2);
           BlankLine;
           if LevelNum = 255
             then begin
               LevelNum := TempNum;  {ESC pressed - abort}
               EXIT
             end;
           WriteLevelNum
          until LevelNum <= NumOfLevels;
          ViewLevel;
          if OPMessage('Are you SURE you want to save over that level (Y/N)?','YN') = 'N'
            then EXIT
         end;
  Message(' Saving level... ');

  Seek(LevelF,LevelNum); {save level info}
  LevelInfo.Level := Level;
  LevelInfo.Custom := Custom;
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
  {* Restores level - draws onto screen}
begin
  CheckSave;
  TempNum := LevelNum;
  repeat
    Message('Enter number of level to restore (1 - 25,0 for none): ');
    GetNum(LevelNum,2)
  until LevelNum <= NumOfLevels;
  if LevelNum in [0,255]
    then begin
           LevelNum := TempNum;
           BlankLine;
           EXIT
         end;
  WriteLevelNum;
  Message(' Restoring level... ');

  Seek(LevelF,LevelNum);
  Read(LevelF,LevelInfo);
  Level := LevelInfo.Level;
  LStat := LevelInfo.LStat;
  Custom := LevelInfo.Custom;
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

{----------------------}

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
           ' '      : Key := 10;  {place item}
           #8       : Key := 25;  {delete item}
           '['      : Key := 30;  {menu cursor left}
           ']'      : Key := 31;  {menu cursor right}
           '{'      : Key := 32;  {fast left}
           '}'      : Key := 33;  {fast right}
           '*'      : Key := 42;  {* - safety toggle}
           '+'      : Key := 43;  {+ - cursor offset}
           '1'..'9' : Key := Ord(Ch);  {wall characters: 1..9} {SPECIALS?}
           ','      : Key := 58;
           '.'      : Key := 59;
           '!'      : Key := 60;
           '?'      : Key := 61;
           ':'      : Key := 62;
           ''''     : Key := 63;
           '"'      : Key := 64;
           'A'..'Z' : Key := Ord(Ch);  {wall characters: A..Z}
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
   11 : HelpMenu;       {f1}
   12 : SaveLevel;      {f2}
   13 : RestoreLevel;   {f3}
   14 : begin           {f4}
          CheckSave;
          Sx := x;  Sy := y;  {playtest level LevelNum}
          Str(LevelNum,NumStr1);
          SwapVectors;
          Exec('VNTR.exe',DataFile + ' ' + NumStr1 + ' ' + '-1' {test});
          SwapVectors;
          Exec('vntrfont.com',''); {return to editor}
          DrawEditor;
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
                   FlashMessage('Current level number must be between 1 and 25.');
                   EXIT
                 end;
          TempNum := LevelNum;
          Message('Switch this level with level number (1 - 25, 0 exits): ');
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
   17 : case OPMessage('Choose Special Item to customize (1 - 9)','123456789') of
          '1' : DefineSpecials(Specials[1],'1');
          '2' : DefineSpecials(Specials[2],'2');
          '3' : DefineSpecials(Specials[3],'3');
          '4' : DefineSpecials(Specials[4],'4');
          '5' : DefineSpecials(Specials[5],'5');
          '6' : DefineSpecials(Specials[6],'6');
          '7' : DefineSpecials(Specials[7],'7');
          '8' : DefineSpecials(Specials[8],'8');
          '9' : DefineSpecials(Specials[9],'9')
        end;
   18 : DefineLevel;    {f8}
   19 : begin           {f9}
           repeat
             Message('Enter new level number for this screen (1 - 25): ');
             GetNum(LevelNum,2)
           until LevelNum <= NumOfLevels;
           BlankLine;
           WriteLevelNum;
           LevelSaved := FALSE
         end;
(*   19 : begin           {f9}
          TempNum := LevelNum;
          Message('Enter level number to view: ');
          GetNum(LevelNum,2);
          BlankLine;
          ViewLevel
        end;   *)
   20 : PrintOptions;   {f10}
   25 : DeleteItem;     {<backspace>}
   30 : MoveMenuCursor(-1);         {'['}
   31 : MoveMenuCursor(+1);         {']'}
   32 : MoveMenuCursor(-MenuLength);{'{'}
   33 : MoveMenuCursor(+MenuLength);(*}*)
   42 : SafetyOn := (not SafetyOn); {'*'}
   43 : CursorStats;                {'+'}
   48..57 : PlaceLetter(Key);       {'1'..'9'}    {PLACE SPECIALS?}
   58 : PlaceLetter(Ord(','));      {','}
   59 : PlaceLetter(Ord('.'));      {'.'}
   60 : PlaceLetter(Ord('!'));      {'!'}
   61 : PlaceLetter(Ord('?'));      {'?'}
   62 : PlaceLetter(Ord(':'));      {':'}
   63 : PlaceLetter(Ord(''''));     {'''}
   64 : PlaceLetter(Ord('"'));      {'"'}
   65..90 : PlaceLetter(Key);       {'A'..'Z'}
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
  Assign(LevelF,DataFile + '.lvl');
  {$I-}  Reset(LevelF);  {$I+}
  if IOResult <> 0   {file does not exist - create new file}
    then begin
           Message('Creating levels file...');
           Assign(sf,DataFile + '.spc');
           Rewrite(LevelF);  Rewrite(sf);
           for i := 0 to NumOfLevels do
             begin
               LevelInfo.Level := Level;
               LevelInfo.LStat := LStat;
               Write(LevelF,LevelInfo);  {place 25 blank levels into file}
               Writeln(sf,'*',i);        {create blank special items file}
               for j := 1 to 9 do
                 begin
                   Writeln(sf,'#',j);
                   Writeln(sf,1,' ',SUse,' ',#127,' ',LightCyan,' ')
                 end
             end;
           Writeln(sf,'*','END OF LEVEL DATA');
           Close(LevelF);  Close(sf);
           Reset(LevelF);
           BlankLine
         end;
  LevelSaved := TRUE
end;

Procedure EditorInit;
  {* Sets up variables for level editor}
begin
  if ParamCount > 0
    then DataFile := ParamStr(1)
    else DataFile := 'vntr';
  CursorOff;  NoSound;
  Exec('vntrfont.com','');
  BlinkOn;
  Noise := TRUE;  {WaveOn := TRUE;}
  SafetyOn := FALSE;
  FullDesc := TRUE;
  x  := 1;  y  := 1;
  Mx := 1;  My := 1;
  XOff := 1; YOff := 0;
  LevelNum := 0;
  for i := 1 to 64 do
    for j := 1 to 24 do begin
      Level[i,j] := BLANK;
      Custom[i,j] := 0;
      end;
  with LStat do
    begin
      Name := '';
      Music := 0;
      View := Top;
      XFlip := FALSE;
      YFlip := FALSE;
      WC := Brown;
      DC := Brown;
      Tx := 1;  Ty := 1
    end;
  for i := 1 to 9 do
    with Specials[i] do
      begin
        IType  := SUse;
        MoveOn := 1;  {YES}
        Chr    := #127;
        Color  := LightCyan;
        Item   := nil
      end;
  DrawEditor;
  WriteCursor;
  WriteLevelNum;
  WriteItemDesc;
  ResetLevelFile
end;

begin   (* MAIN PROG *)
  Randomize;
  EditorInit;
  RestoreLevel;
  EditorLoop;
  EditorExit
end.  {MericanEditor}
