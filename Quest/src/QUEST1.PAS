Unit Quest1;            {written by Michael Rimer - begun October 26, 1993}
{Extra procedures for game - screen & special level procedures}

(***) Interface (***)

Uses Dos, ErikSnd, Sounds, QLevels, Quest2, Crt, MerCrt, CrtEXTRA;

(****************)

type   NumArray = array[0..9] of integer;
       ChrArray = array[0..9] of char;

const
  Number_Of_Messages = 42;
  EatItems = [' ','+','Ù','M','I','*','Â','C','G','F','Q','A','V'];
                        {all items monsters can move onto}
  NORMAL   = 0;               {exit types}
  SPECIAL  = 1;
  TopVIEW  = 0;               {level types}
  SideVIEW = 1;
  SPACE    = 90;              {key types}
  QUIT     = 99;
  DIES     = 1;               {fate of player}
  WINS     = 2;
  MonSpeed : NumArray = ( 18, 18, 12,  8, 16, 11,  7, 14,  8,  6);
  MonHits  : NumArray = (  1,  1,  1,  1,  2,  2,  2,  3,  6, 16);
  MonDmg   : NumArray = (  0,  1,  2,  3,  1,  2,  3,  2,  1,  2);
  MonChar  : ChrArray = ('∞','Ñ','î','Í','é','ô','ö','è','ú','ü');

  ScoreNames : array[0..15] of String[20] = ('',
    'The Merican Master','Bilbo Baggins','Belgarion','Indy Jones',
    'A. Pendragon','Matthias','Gandalf','Launcelot','Conan','Shamino',
    'Rogue','Arnie S.','Peter Pan','J. L. Picard','Mr. Rogers');

(****************)

type
  Monster      = ^MonsterRec;
  MonsterRec   = record
                   Mx, My,
                   Speed,
                   Hits, Damage  : integer;
                   AsciiChar     : char;
                   next, prev    : Monster
                 end;

  MessageArray = array[0..Number_Of_Messages] of boolean;
  FameRec = record
              Name  : string[20];
              Score : longint;
              Level : integer
            end;

(****************)

var
  SMessageList,                 {save file list}
  MessageList   : MessageArray; {if each message has been displayed yet}

  HeadMonster,                {first node}
  TailMonster,                {last node}
  CurMons       : Monster;    {Current node of double-linked monster list}

                              {PLAYER}
  ManColor,                   {* color of player}
  SwordPower,                 {* sword's magic level}
  Health, SHealth,            {* strength}
  Sword,                      {* swings available}
  Magic,                      {* teleport scrolls}
  Keys          : integer;    {* keys held}
  Score, SScore : longint;    {* up to 2.1 Billion points}

  Ch,                         {keyboard input}
  SSword,                     {* SAVE stats}
  SMagic, SKeys,
  SEntrance,                  {* entrance player enters into level by}
  SSwordPower,
  SLevelNum     : char;

  XCord, YCord,               {* player's position}
  OldX, OldY,                 {* player's previous position}
  OldSpot,                    {* square player steps from}

  Moves,                      {clocks monster speed, etc.}
  MonsterGen,                 {% chance of generating new monster}
  InvisiMan,                  {# of moves player is invisible}
  Freeze,
  Slow, Haste,                {various monster speed modifiers}
  LevelView,                  {whether level is Top or Side view}
  IncScore,                   {points left to be added to score}
  HGColor,                    {color of health gems}
  PGColor,                    {color of power gems}
  WallColor,                  {level's wall color}
  Num, i, j      : integer;   {loop-counting}

  ExitGame,                   {player returns to menu}
  ExitProg,                   {player quits game}
  FlipX, FlipY   : boolean;   {level reflection status}

  ScoreF         : file of FameRec;  {high score file}

(****************)

{* Misc.}

  Procedure MU;
  Procedure MB;
  Function  BoundCheck : boolean;
  Procedure FinalMessage;

  Procedure MakeScoreList;
  Procedure GameOver(Fate : integer);

{* Screen setup routines}

  Procedure PrintMan;
  Procedure UpdateScore;
  Procedure UpdateStats;
  Procedure AddScore(var IncScore : integer);
  Procedure GetSkill(var Stat : integer; N, E, A : integer);
  Procedure Messages(Num : integer);

  Procedure DrawMonster(x, y, Hits : integer; AsciiChar : char);
  Procedure DrawSpot   (x, y : integer);

{* Monster manipulation routines}

  Procedure DisposeMonsters;
  Procedure AppendMonster(x, y, Spd, Hts, Dmg : integer; Chr : char);

{* Saves, Loads and Modifies new levels & player status}

  Procedure SaveGame;
  Procedure RestoreGame;
  Procedure ReadLevel(LevelNumber, Entrance : integer);
  Procedure LoadLevel(Floor, Entrance : integer);

{* Special level routines}

  Function  SymX(x : integer) : integer;
  Function  SymY(y : integer) : integer;
  Procedure ZapMonster(x, y : integer);
  Procedure ZapBlock(x, y : integer; Item : char);
  Procedure SecretLever(Floor : integer);
  Procedure SpecialItem(Floor : integer);
  Procedure Magic1(Floor : integer);
  Procedure Magic2(Floor : integer);
  Procedure WisdomTablet(Floor : integer);

(***) Implementation (***)

Procedure MU;
  {* Move Update (variables modified)}

begin
  OldX := XCord;
  OldY := YCord
end;

Procedure MB;
  {* Move Back (to last spot occupied)}

begin
  XCord := OldX;
  YCord := OldY
end;

Function BoundCheck : boolean;
  {* Outputs whether player is in bounds of the level}

begin
  if (XCord < 1) or (XCord > 64) or (YCord < 1) or (YCord > 24)
    then begin
           MB;
           BoundCheck := FALSE     {player is out of bounds}
         end
    else BoundCheck := TRUE        {player is in bounds}
end;

Procedure FinalMessage;
  {* Message given when game ends and returns to DOS}

begin
  CursorOn;
  TextAttr := LightGray;
  ClrScr;
  TextAttr := Yellow;
  Writeln('--- THE MERICAN QUEST ---');
  TextAttr := LightGray;
  Writeln('           by');
  Writeln('     Michael Rimer');
  Writeln;
  Writeln('   Thanks for playing!');
  Writeln
end;

Procedure MakeScoreList;
  {* Creates new file on disk to save high scores}

var Res   : integer;
    Famer : FameRec;

begin
  repeat
    {$I-}  Rewrite(ScoreF);  {$I+}     {error checking}
    Res := IOResult;
    if Res <> 0
      then begin
             Writeln('<ERROR - Can''t create high score file>');
             Writeln('(Hit "Q" to quit game, or any other key to try again.)');
             Ch := UpCase(ReadKey);
             if Ch = 'Q' then HALT
           end;
  until (Res = 0) or (Ch = 'Q');

  Write(ScoreF,Famer);   {0th record is dummy}
  for j := 1 to 3 do     {three skill level "files"}
    for i := 1 to 15 do  {15 score places}
      begin
        Famer.Name  := ScoreNames[i];
        Famer.Score := 32000 - i * 2000;
        Famer.Level := 16 - i;
        Write(ScoreF,Famer)
      end;

  Close(ScoreF);   {save file to disk}
  Reset(ScoreF)
end;

Procedure PrintScores(var Place : integer);

var  Famer, Temp : FameRec;
     Cnt         : integer;

begin
  Place := 99;
  GetSkill(Num,1,16,31);
  Seek(ScoreF,Num);
  for i := 1 to 15 do
    begin
      Read(ScoreF,Famer);
      if (Score > Famer.Score) and (Place > i)
        then Place := i          {if qualified, player gets score slot 'i'}
  end;

  GetSkill(i,0,15,30);     {find position of chart in file for skill level}
  GetSkill(j,15,30,45);              {last record in chart for skill level}
  for Cnt := (j - 1) downto (Place + i) do     {slide scores down one slot}
    begin                                         {under player's position}
      Seek(ScoreF,Cnt);
      Read(ScoreF,Temp);
      Seek(ScoreF,Cnt + 1);
      Write(ScoreF,Temp)
    end;

  Seek(ScoreF,Num);       {write out names}
  for i := 1 to 15 do
    begin
      Read(ScoreF,Famer);
      GotoXY(10,6 + i);
      TextAttr := (i mod 3) + LightGreen;
      Write(i:2,'.  ');
      if i <> Place
        then begin
               Write(Famer.Name);
               GotoXY(37,6 + i);
               Write(Famer.Score:7,'     ');
               if Famer.Level > 25
                 then Writeln('FIN')
                 else Writeln(' ',Famer.Level)
             end
    end
end;

Procedure EnterName(Place : integer);
  {* Player enters their name into high score list}

var Honor : FameRec;

begin
  GotoXY(37,6 + Place);
  Write(Score:7,'     ');
  if LevelNum > 25
    then Writeln('FIN')
    else Writeln(' ',LevelNum);
  GotoXY(15,6 + Place);
  TextAttr := White + Magenta * 16;
  for i := 1 to 20 do
    Write(' ');

  CursorFull;
  if DEMO
    then begin
           Honor.Name := 'Lost Adventurer';
           GotoXY(15,6 + Place);
           Write(Honor.Name)
         end
    else begin
           GotoXY(15,6 + Place);
           Readln(Honor.Name);
           if Length(Honor.Name) = 0
             then Honor.Name := 'Slicko'
         end;
  CursorOff;

  Honor.Score := Score;
  Honor.Level := LevelNum;
  GetSkill(i,0,15,30);     {find position in file of chart for skill level}
  Seek(ScoreF,i + Place);
  Write(ScoreF,Honor)
end;

Procedure HighScoreList(Fate : integer);
  {* Displays score list for difficulty level chosen}

var Place : integer;

begin
  BlankBoard(1,1,64,25);
  Window(1,1,64,25);
  TextAttr := (Random(7) + 1) * 16;
  ClrScr;
  GotoXY(21,1);
  Inc(TextAttr,Yellow + Blink);
  case Fate of
    WINS : Write('YOUR QUEST WAS SUCCESSFUL!');
    DIES : Write('      YOU HAVE DIED!!');
    QUIT : Write('YOU TOOK THE EASY WAY OUT!')
  end;
  Window(3,2,62,24);
  TextAttr := LightMagenta;
  ClrScr;
  GotoXY(29,2);
  case SkillLevel of
    NOVICE   : Write(' NOVICE');
    ADVANCED : Write('ADVANCED');
    EXPERT   : Write('EXPERT')
  end;
  GotoXY(27,3);
  Write('Hall of Fame');
  TextAttr := Red;
  GotoXY(15,5);
  Write('Name                    Score    Level');
  GotoXY(15,6);
  Write('--------------------   -------    ---');

  {$I-}  Reset(ScoreF);  {$I+}
  if IOResult <> 0
    then MakeScoreList;  {create new score file if none is found}

  PrintScores(Place);    {print high score list}
  RemKeys;
  if Place <= 15         {player enters name, if qualified}
    then EnterName(Place);
  Window(1,1,80,25)
end;

Procedure GameOver(Fate : integer);
  {* Current game ends - result depends on how ended}

begin
  ExitGame := TRUE;
  Freeze := 99;    {fixes bug in main game loop}
  case Fate of
    DIES : begin
             Perish1;
             if Health <> - 100
               then begin
                      GotoXY(XCord,YCord);   {Flash player '*'}
                      TextAttr := Yellow + Blink;
                      Write('*')
                    end;
             Message('You have died!!');
             HighScoreList(DIES);
             if OPMessage('Do you want to play again {Y / N}?','YN') = 'N'
               then ExitProg := TRUE
           end;
    QUIT : begin
             HighScoreList(QUIT);
             if OPMessage('Do you want to play again {Y / N}?','YN') = 'N'
               then ExitProg := TRUE
           end;
    WINS : begin
             HighScoreList(WINS);
             Message('Hit any key to continue...');
             Conclusion;
             ExitProg := TRUE
           end;
  end  {case Fate}
end;

(*****************)

Procedure PrintMan;
  {* Visually moves man on screen}

begin
  GotoXY(OldX,OldY);               {erase old spot}
  case OldSpot of
    0 : begin  {normal}
          TextAttr := Black;
          Write(' ')
        end;
    1 : begin  {secret lever}
          TextAttr := DarkGray;
          Write('˙');
          OldSpot := 0
        end;
    2 : begin  {rope}
          TextAttr := White;
          Write('≥');
          OldSpot := 0
        end;
    3 : begin
          TextAttr := LightBlue + Blue * 16 + Blink;
          Write('±');
          OldSpot := 0
        end;
  end;  {OldSpot}
  GotoXY(XCord,YCord);             {print new spot}
  TextAttr := ManColor;
  Write(#2)
end;

Procedure UpdateScore;
  {* Writes player's score}

begin
  TextAttr := Yellow + LightGray * 16;
  GotoXY(70,2);
  if Score > 99999
    then Write(Score:6,' ')     {xxxxxx_}
    else if Score > 9999
      then Write(Score:6,' ')   {_xxxxx_}
      else case Score of
             1000..9999 : Write(Score:5,' ');    {_xxxx_}
             100..999   : Write(Score:4,'  ');   {_xxx__}
             else Write(Score:4,'  ')            {__xx__}
           end;
end;

Procedure UpdateStats;
  {* Refreshes all of player's attributes}

begin
  UpdateScore;
  GotoXY(72,5);    Write(LevelNum:2);
  GotoXY(71,11);   Write(Sword:3);
  if SwordPower > 0
    then Write('+',SwordPower);     {extra sword magic}
  GotoXY(72,14);   Write(Magic:2);
  GotoXY(72,17);   Write(Keys:2);
  
  GotoXY(71,8);    
  if Health < 10          {player has low power}
    then TextAttr := LightRed + LightGray * 16 + Blink;
  if Health >= 0
    then Write(Health:3)
    else Write('  0 ')    {player is dead}
end;

Procedure AddScore(var IncScore : integer);
  {* Adds points to player's Score turn by turn - nice effect}

var  ToAdd : integer;

begin
  case IncScore of
    0..12    : ToAdd := IncScore;
    13..99   : ToAdd := 13;
    100..499 : ToAdd := 47;
    500..999 : ToAdd := 91;
    else ToAdd := 179
  end; {IncScore case}
  Dec(IncScore,ToAdd);
  Inc(Score,ToAdd);
  UpdateScore;
  PSound(300,5);
  NoSound
end;

Procedure GetSkill(var Stat : integer; N, E, A : integer);
  {* Depending on the level of skill, a value is returned for Stat}
begin
  case SkillLevel of
    NOVICE   : Stat := N;
    ADVANCED : Stat := E;
    EXPERT   : Stat := A
  end
end;

Procedure Messages(Num : integer);
  {* Writes message #Num, if not yet displayed}
begin
  if MessageList[Num]
    then case Num of
           1  : Message('You run into a solid stone wall.  (Ouch!)');
           2  : Message('You hit a cracked stone block.');
           3  : Message('You hit a partly crumbled stone block.');
           4  : Message('You hit a crumbled stone block.');
           5  : Message('You hit a Moving wall.');
           6  : Message('You ran into an invisible wall.');
           7  : Message('You ran into an invisible crumbled wall.');
           8  : Message('Zzzzzap!  You have hit a force field!  (Lose one health gem.)');
           9  : Message('The bridge rail prevents you from falling in.');
           10 : Message('You smacked into the trunk of a solid oak tree.');
           11 : Message('You cannot travel through dense foliage.');
           12 : Message('The thick jungle terrain prevents you from continuing.');
           13 : Message('Ouch!  Lava causes heavy damage! (Lose 10 health gems!)');
           14 : Message('The strange water prevents you from swimming across.');
           15 : Message('You found a secret tunnel!');
           16 : Message('Finding health gems increases your stamina.');
           17 : Message('Power gems allow you to use your sword.');
           18 : Message('Use Magic scrolls to teleport to a new spot.');
           19 : Message('Use Keys to open locked Doors.');
           20 : Message('To open the locked Door you need a Key.');
           21 : Message('The Door opens! (You use one of your keys.)');
           22 : Message('You discovered an invisible locked Door.');
           23 : Message('You found an ancient relic - 500 points!');
           24 : Message('You stepped into a teleport trap!');
           25 : Message('You flipped a secret switch!');
           26 : Message('You find Words of Forgotten Lore - 2,500 points!');
           27 : Message('Stairs take you to the next lower level.');
           28 : Message('Kudos - you found the Secret Exit!!');
           29 : Message('You drank a potion of blindness!');
           30 : Message('You ran into an immovable boulder.');
           31 : Message('You pushed a big boulder!');
           32 : Message('You pushed a sliding block.');
           33 : Message('You activated a Freeze Monster spell!');
           34 : Message('You activated a Slow-Monster spell...');
           35 : Message('You set off a Haste-Monster spell..');
           36 : Message('You triggered a magic spear!');
           37 : Message('A Magical Artifact powers up your sword!!');
           38 : Message('You invoked a Monster Zap spell!');
           39 : Message('You set off a Monster Creation trap!');
           40 : Message('You are drowning in the murky water!');
           41 : Message('A magical trap makes many wall sections invisible!');
           42 : Message('You detonated an ancient Mini-Nuke Spell!');
         end; {Num case}
  MessageList[Num] := FALSE
end;

Procedure DrawMonster(x, y, Hits : integer; AsciiChar : char);
  {* Updates monster at screen position (x,y), color according to Hits}
  {* WOW! This is great!}

begin
  GotoXY(x,y);
  case AsciiChar of
    '0' : begin  {∞}                {moving wall, sword destroys}
            TextAttr := WallColor;
            Write('∞')
          end;
    '1' : begin {íAéèÜÉÑa}      {1 - 3 hit once}
            TextAttr := Red;
            Write('Ñ')
          end;
    '2' : begin  {Oôîo}
            TextAttr := Green;
            Write('î')
          end;
    '3' : begin  {ÍÔöÅ}
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
    '8' : begin  {‰·êÓüú}       {8 is undead - only sword hits}
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

Procedure DrawSpot(x, y : integer);
  {* Draws item at position (x,y) in level}

var  Spot : char;

begin
  GotoXY(x,y);
  Spot := Level[x,y];
  case Spot of
    '-','_','=',':',';','.','D','P','E','G','J',']','H','B','!','N','Ò','¯',
    'X',' ' : begin                       {blank/invisible spaces}
            TextAttr := Black;
            Write(' ')
          end;
    '∞'..'≤','€'..'ﬂ' : begin         {walls}
            TextAttr := WallColor;
            Write(Spot)
          end;
    'a'..'z' : begin                  {message chars}
            TextAttr := White + WallColor * 16;
            Write(UpCase(Spot))
          end;
    '∫','Õ','Œ' : begin               {bridge rails}
            TextAttr := LightRed;
            Write(Spot)
          end;
    'R' : begin                       {rope}
            TextAttr := White;
            Write('≥')
          end;
    'W' : begin                       {water}
            TextAttr := LightBlue + Blue * 16 + Blink;
            Write('±')
          end;
    'L' : begin                       {lava}
            TextAttr := LightRed + Red * 16 + Blink;
            Write('±')
          end;
    '/' : begin                       {forest - thin}
            TextAttr := Green;
            Write('±')
          end;
    '\' : begin                       {forest - thick}
            TextAttr := Green + Brown * 16;
            Write('≤')
          end;
    'T' : begin                       {tree}
            TextAttr := Green;
            Write(#6)
          end;
    '#' : begin                       {bottomless pit}
            TextAttr := DarkGray;
            Write('∞')
          end;
    'Z' : begin                       {force field}
            TextAttr := Yellow + LightGray * 16 + Blink;
            Write('±')
          end;
    '^' : begin                       {rock, stationary}
            TextAttr := Brown;
            Write(#127)
          end;
    'O' : begin                       {boulder, moveable}
            TextAttr := LightGray;
            Write('O')
          end;
    '˛' : begin                       {pushable block}
            TextAttr := LightBlue + Blue * 16;
            Write(#9)
          end;
    'U' : begin                       {secret tunnel}
            TextAttr := White;
            Write('Ô')
          end;
    'V' : begin                       {teleport trap}
            TextAttr := LightGray;
            Write('˙')
          end;
    '0'..'9' : DrawMonster(x,y,13,Spot); {monsters}
          {13 for h.p. value - only accurate when level first begins...}

    'È' : begin                       {locked door}
            TextAttr := White + Magenta * 16;
            Write('È')
          end;
    '' : begin                       {normal stairs}
            TextAttr := LightRed + Blink;
            Write('')
          end;
    'S' : begin                       {secret stairs}
            TextAttr := LightBlue * 16;
            Write('')
          end;
    '+' : begin                       {health gem}
            TextAttr := HGColor;
            Write(#4)
          end;
    'Ù' : begin                       {power gem}
            TextAttr := PGColor;
            Write(#9)
          end;
    'M' : begin                       {magic}
            TextAttr := LightMagenta;
            Write(#24)
          end;
    'Â' : begin                       {key}
            TextAttr := LightRed;
            Write('Â')
          end;
    'C' : begin                       {chest}
            TextAttr := Yellow + Brown * 16;
            Write(#15)
          end;
    '*' : begin                       {treasure}
            TextAttr := Yellow;
            Write(#15);
          end;
    'I' : begin                       {blindness potion}
            TextAttr := Green;
            Write('≠')
          end;
    'F' : begin                       {freeze monsters}
            TextAttr := LightCyan;
            Write('ü')
          end;
    'Q' : begin                       {quicken monsters}
            TextAttr := LightRed;
            Write('È')
          end;
    'A' : begin                       {slow monsters}
            TextAttr := LightGreen;
            Write('Ë')
          end;
    '<' : begin                       {magic spear - left}
            TextAttr := LightGray;
            Write(#27)
          end;
    '>' : begin                       {magic spear - right}
            TextAttr := LightGray;
            Write(#26)
          end;
    'ù' : begin                       {magic bomb}
            TextAttr := White;
            Write('ù')
          end;
    '[' : begin                       {monster zap}
            TextAttr := LightRed;
            Write('')
          end;
    'Y' : begin                       {monster generator}
            TextAttr := Yellow + Blink;
            Write(#6)
          end;
    '?' : begin                       {pouch of gems}
            TextAttr := White;
            Write('?')
          end;
    '®' : begin                       {sword power-up}
            TextAttr := Yellow + Blink;
            Write(#9)
          end;
    '{','}','|','~' : begin           {rope extend (types 1 - 4)}
            TextAttr := White;
            Write(#25)
          end;
    'K' : begin                       {tablet of wisdom}
            TextAttr := LightBlue;
            Write('˛')
          end;
    '˙' : begin                       {secret panel}
            TextAttr := DarkGray;
            Write('˙')
          end;
    '(' : begin                       {magic 1}
            TextAttr := Magic1Color[LevelNum];
            Write(Magic1Char[LevelNum])
          end;
    ')' : begin                       {magic 2}
            TextAttr := Magic2Color[LevelNum];
            Write(Magic2Char[LevelNum])
          end;
    '$' : begin                       {special item}
            TextAttr := SpecialColor[LevelNum];
            Write(SpecialChar[LevelNum])
          end;
    else begin                        {- unknown char -}
           TextAttr := White + Blink;
           Write('?')
         end
  end {Spot case}
end;

(******************)

Procedure DisposeMonsters;
  {* Removes all monster nodes from list (except Head & Tail)}

var  OldNode,
     TravNode : Monster;   {traverse list}

begin
  TravNode := HeadMonster^.next;
  while TravNode^.next <> nil        {erase all nodes between ends}
    do begin
          OldNode := TravNode;
          TravNode := TravNode^.next;
          Dispose(OldNode)
        end;
  HeadMonster^.next := TailMonster;  {reset empty list}
  TailMonster^.prev := HeadMonster;
  CurMons := TailMonster
end;

Procedure AppendMonster(x, y, Spd, Hts, Dmg : integer; Chr : char);
  {* Place monster at end of list}

var NewMonster : Monster;

begin
  New(NewMonster);
  with NewMonster^ do
    begin
      Mx := x;   {fill in info}
      My := y;
      Speed := Spd;
      Hits := Hts;
      Damage := Dmg;
      AsciiChar := Chr;

      next := TailMonster;         {put at end, before TailMonster}     
      prev := TailMonster^.prev;
      next^.prev := NewMonster;
      prev^.next := NewMonster
    end; {with}
end;

(******************)

Procedure SaveGame;
  {* Saves game stats into file "quest-n.sav"}

var  Sf     : text;  {save file}
     Choice : char;

begin
  PSound(500,100);  PSound(300,100);  PSound(100,100);  NoSound;
  if OPMessage(' Do you want to SAVE {Y / N}? ','YN') = 'N'
    then EXIT;
  Choice := OPMessage(' Save game to file <A - E>? ','ABCDE');
  Assign(Sf,'quest-' + Choice + '.sav');
  Rewrite(Sf);
  Writeln(Sf,SLevelNum,SSwordPower,SEntrance,SScore);
  Writeln(Sf,SSword,SMagic,SKeys,SHealth);
  for i := 0 to Number_Of_Messages do
    if SMessageList[i]
      then Write(Sf,#0)
      else Write(Sf,#32);
  Close(Sf);
  Message('  Game saved on File ' + Choice + '.  ')
end;

Procedure RestoreGame;
  {* Restores game from file "quest-n.sav"}

var  Rf     : text;  {restore file}
     Choice : char;
     Result : integer;

begin
  PSound(100,100);  PSound(300,100);  PSound(500,100);  NoSound;
  if OPMessage('Do you want to RESTORE {Y / N}?','YN') = 'N'
    then EXIT;
  Choice := OPMessage(' Restore game from file <A - E>? ','ABCDE');
  Assign(Rf,'quest-' + Choice + '.sav');
{$I-}  Reset(Rf);  {$I+}
  Result := IOResult;
  if Result <> 0   {save file is not on disk}
    then begin
           Message('Save file ' + Choice + ' is not on disk.');
           EXIT
         end;
  Readln(Rf,SLevelNum,SSwordPower,SEntrance,SScore);
  Readln(Rf,SSword,SMagic,SKeys,SHealth);
  for i := 0 to Number_Of_Messages do
    begin
      Read(Rf,Ch);
      if Ch = #0
        then SMessageList[i] := TRUE
        else SMessageList[i] := FALSE
    end;
  Close(Rf);

  LevelNum   := Ord(SLevelNum);    {restore stats}
  SwordPower := Ord(SSwordPower);
  Score  := SScore;
  Sword  := Ord(SSword);
  Magic  := Ord(SMagic);
  Keys   := Ord(SKeys);
  Health := SHealth;
  MessageList := SMessageList;

  UpdateStats;
  LoadLevel(LevelNum,Ord(SEntrance))
end;

Procedure ReadLevel(LevelNumber, Entrance : integer);
  {* Reads in current level from constant LevelArray}

var  x, y  : integer;
     Line  : string[64];  {holds one row of level}
     Chr   : char;        {holds one spot of level}

begin
  if XSymmetry[LevelNum] and (Random(10) < 5)  {decide if level is reflected}
    then FlipX := TRUE
    else FlipX := FALSE;
  if YSymmetry[LevelNum] and (Random(10) < 5)
    then FlipY := TRUE
    else FlipY := FALSE;
  LevelView := LevelViews[LevelNum]; {whether level is TopVIEW or SideVIEW}
  WallColor := WallColors[LevelNum]; {wall color}
  MonsterGen := 0;

  for y := 1 to 24 do
    begin
      Line := LevelArray[LevelNumber,SymY(y)];   {get Yth string in Level}
      for x := 1 to 64 do
        begin
          Chr := Line[SymX(x)];      {get Xth char in Yth string in Level}
          Level[x,y] := Chr;
          case Chr of
            'P' : if Entrance = NORMAL
                    then begin                  {Normal starting position}
                           Level[x,y] := ' ';   
                           XCord := x;           
                           YCord := y;
                           MU
                         end
                    else Level[x,y] := ' ';
            'E' : if Entrance = SPECIAL
                    then begin                  {Special starting position}
                           Level[x,y] := ' ';
                           XCord := x;
                           YCord := y;
                           MU
                         end
                    else Level[x,y] := ' ';
            'Y' : Inc(MonsterGen);              {monster generator - 2%}
                 
            '‹' : if FlipY  then Level[x,y] := 'ﬂ';
            'ﬂ' : if FlipY  then Level[x,y] := '‹';
            '›' : if FlipX  then Level[x,y] := 'ﬁ';
            'ﬁ' : if FlipX  then Level[x,y] := '›';
            '<' : if FlipX  then Level[x,y] := '>';
            '>' : if FlipX  then Level[x,y] := '<';

                                    {x,y,spd,hts,dmg,chr}
            '0'..'9' : AppendMonster(x,y,MonSpeed[Ord(Chr) - 48],
              MonHits[Ord(Chr) - 48],MonDmg[Ord(Chr) - 48],Chr);
          end {Chr case}
        end
    end
end;

Procedure LoadLevel(Floor, Entrance : integer);
  {* Loads level into memory and warps man in}

begin
  DisposeMonsters;      {remove all monsters from last level}
  IncScore  := 0;
  Moves     := 1;
  InvisiMan := 0;
  Freeze    := 0;  Slow := 0;  Haste := 0;  {reset spells}
  ManColor  := Yellow;
  LevelNum  := Floor;
  HGColor   := Random(15) + 1;       {health gem color}
  repeat
    PGColor := Random(15) + 1        {power gem color}
  until PGColor <> HGColor;

  SLevelNum   := Chr(LevelNum);    {store stats for saving game}
  SSwordPower := Chr(SwordPower);
  SEntrance   := Chr(Entrance);
  SSword      := Chr(Sword);
  SMagic      := Chr(Magic);
  SKeys       := Chr(Keys);
  SScore  := Score;
  SHealth := Health;
  SMessageList := MessageList;

  UpdateStats;
  ReadLevel(Floor,Entrance);
  BlankBoard(1,1,64,24);
  FillBoard(1,1,64,24);
  for Num := 35 to 300 do
    begin
      PSound(Num,0);
      GotoXY(XCord,YCord);
      TextAttr := Random(127) + 1;
      Write(#1)
    end;
  PrintMan;
  NoSound;
  Message('  ' + LevelName[Floor] + '  ')
end;

(*****************)

Procedure TallyStat(var Stat : integer; Dur, Raise, Pts : integer;
                        Mess : string);
  {* Counts item remaining in player's possession toward score}
begin
  TextAttr := White;  GotoXY((65 - Length(Mess)) div 2 + 1,25);
  Write(Mess);
  i := 35;
  while Stat > 0 do
    begin
      PSound(i,Dur);
      Inc(i,Raise);
      Inc(Score,Pts);
      Dec(Stat);
      UpdateStats
    end;
  NoSound;
  Message(Mess)
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

Procedure ZapMonster(x, y : integer);
  {* Removes monster from list/array/screen}

var  MonsPtr : Monster;

begin
  MonsPtr := HeadMonster^.next;      {find correct monster}
  while (MonsPtr^.Mx <> x) or (MonsPtr^.My <> y) do
    MonsPtr := MonsPtr^.next;
  with MonsPtr^ do
    begin
      prev^.next := next;     {remove from list}
      next^.prev := prev;
      Dispose(MonsPtr)
    end;
  Level[x,y] := ' ';          {remove from array}
  DrawSpot(x,y)               {erase from screen}
end;

Procedure ZapBlock(x, y : integer; Item : char);
  {* Replaces Level[x,y] with char Item}

var  Cntr : integer;

begin
  if Level[x,y] = Item  {item is already there}
    then EXIT;
  if Level[x,y] in ['0'..'9']  
    then ZapMonster(x,y);      {monster is drawn over}
  Level[x,y] := Item;
  for Cntr := 219 to 223 do
    begin
      PSound(500 + Random(500),10);
      GotoXY(x,y);
      TextAttr := Random(15) + 1;
      Write(Chr(Cntr))
    end;
  DrawSpot(x,y);
  NoSound
end;

Procedure ExplodeBlock(x, y : integer; Item : char);
  {If char at (x,y) = Item, then replaces with ' '}

begin
  if Level[x,y] <> Item
    then EXIT
    else Level[x,y] := ' ';
  for Num := 1 to 10 do
    begin
      PSound(300,5);
      NoSound;
      Delay(5)
    end;
  DrawSpot(x,y)
end;

Procedure ToggleSpot(x, y : integer; Chr : char);
  {* Reverses Chr to <SPACE> and vice-versa}
begin
  if Level[x,y] = Chr
    then begin
           Level[x,y] := ' ';
           DrawSpot(x,y)
         end
    else if Level[x,y] = ' '
           then begin
                  Level[x,y] := Chr;
                  DrawSpot(x,y)
                end
end;

Procedure SecretLever(Floor : integer);
begin
  case Floor of
    1 : ZapBlock(10,11,' ');
    6 : for i := 2 to 10 do
          for j := 1 to 10 do
            ToggleSpot(SymX(i),SymY(j),'Z');
    7 : for i := 51 to 64 do
          for j := 6 to 19 do
            if Level[i,SymY(j)] = '€'
              then ZapBlock(i,SymY(j),' ');
    9 : ZapBlock(SymX(47),9,' ');
   17 : begin
          Num := SymX(25);
          while Num <> SymX(34) do
            begin
              if Level[Num,1] <> ' '
                then begin
                       ZapBlock(Num,1,' ');
                       Num := SymX(34)
                     end;
              if Num <> SymX(34)
                then if FlipX
                       then Dec(Num)
                       else Inc(Num)
            end
        end;
   18 : begin
          Num := 1;
          repeat
            j := Random(23) + 2;
            Inc(Num)
          until (Level[SymX(63),j] = '€') or (Num > 200);
          if Num <= 200
            then ZapBlock(SymX(63),j,' ')
        end;
   23 : case SymX(XCord) of
          5 : begin
                for i := 12 to 28 do
                  ZapBlock(SymX(i),SymY(6),' ');
                for j := 5 to 7 do
                  for i := 17 to 23 do
                    if Level[SymX(i),SymY(j)] = 'W'
                      then ZapBlock(SymX(i),SymY(j),'Õ')
              end;
         30 : begin
                for i := 39 to 44 do
                  ZapBlock(SymX(i),SymY(10),' ');
                for j := 9 to 11 do
                  for i := 40 to 44 do
                    if Level[SymX(i),SymY(j)] = 'W'
                      then ZapBlock(SymX(i),SymY(j),'Õ')
              end;
         36 : begin
                for i := 25 to 29 do
                  ZapBlock(SymX(i),SymY(20),' ');
                for j := 19 to 21 do
                  for i := 25 to 29 do
                    if Level[SymX(i),SymY(j)] = 'W'
                      then ZapBlock(SymX(i),SymY(j),'Õ')
              end;
         40 : begin
                ZapBlock(SymX(59),SymY(18),' ');
                for i := 58 to 60 do
                  if Level[SymX(i),SymY(18)] = 'W'
                    then ZapBlock(SymX(i),SymY(18),'∫')
              end;
         54 : begin
                for j := 14 to 16 do
                  ZapBlock(SymX(35),SymY(j),' ');
                for j := 15 to 16 do
                  for i := 34 to 36 do
                    if Level[SymX(i),SymY(j)] = 'W'
                      then ZapBlock(SymX(i),SymY(j),'∫')
              end;
        end; {case SymX(XCord)}
   25 : begin
          Level[XCord,YCord] := ' ';
          OldSpot := 0;
          for i := 1 to 9 do
            for j := 1 to 24 do
              if Level[i,j] = '€'
                then ZapBlock(i,j,'=');
          for i := 56 to 64 do
            for j := 1 to 24 do
              if Level[i,j] = '€'
                then ZapBlock(i,j,'=');
          repeat
            i := Random(64) + 1;
            j := Random(17) + 5
          until Level[i,j] = ' ';
          Level[i,j] := '˙';
          DrawSpot(i,j)
        end;
  end {Floor}
end;  {SecretLever}

Procedure SpecialItem(Floor : integer);
begin
  case Floor of
    1 : begin
          Prize;
          GetSkill(Sword,Sword + 5,Sword + 3,Sword + 1);
          UpdateStats;
          Message('You find an old, rusty blade in this hidden room.');
          Inc(IncScore,100)
        end;
    4 : begin
          for i := 30 to 34 do
            for j := 15 to 19 do
              if Level[SymX(i),SymY(j)] = '€'
                then ZapBlock(SymX(i),SymY(j),' ');
          Message('You opened a secret area!')
        end;
    5 : begin
          Message('Cooling your temper makes heat disappear!');
          for i := 14 to 21 do
            for j := 15 to 20 do
              if Level[SymX(i),SymY(j)] = 'L'
                then ZapBlock(SymX(i),SymY(j),'∞')
        end;
    6 : begin
          ZapBlock(SymX(5),SymY(12),'S');
          Message('Magic has been released nearby...')
        end;
    7 : begin
          Message('You come across a trader with a scruffy, black beard.');
          Message('"Welcome to my Market of Curiosities, stranger," he says.');
          Message('"If you were to give me 1,000 points, we could make a deal."');
          if OPMessage('Will you pay 1,000 points to the man (Y / N)?','YN') = 'Y'
            then begin
                   Dec(Score,1000);
                   UpdateStats;
                   Message('He cackles, then says to you, "Agreed!"');
                   Message('"You may take with you one of the following:"');
                   case OPMessage('25 Health, 12 Sword, 5 Magic, or 1 Key (H,S,M,K)?','HSMK') of
                     'H' : Inc(Health,25);
                     'S' : Inc(Sword, 12);
                     'M' : Inc(Magic, 5);
                     'K' : Inc(Keys,  1)
                   end;
                   UpdateStats;
                   Message('"Good luck!" the Trader cries, and vanishes.')
                 end
            else Message('Too bad.  It was a real bargain...')
        end;
    8 : begin
          Message('You encounter an old man, who says with a cackle:');
          Message('"The fate you meet is in the path you choose!"');
          ZapBlock(SymX(26),SymY(6),'-');
          ZapBlock(SymX(38),SymY(6),'-');
          Message('Then the man whispers softly into your ear:');
          Message('I have a secret to tell you...');
          Message('Hidden somewhere underground lies an ancient book...');
          Message('It tells a history of the lost Merican people...');
          Message('...and will lead to much wealth, if you seek it out.');
          Message('....BUT WAIT!');
          Message('Much power is contained in the Book, and it is dangerous!');
          Message('...only one who is strong in heart and mind may claim it.');
          Message('Good Luck!!');
          Message('The man then disappears with maniacal laughter.');
          Message('You think of this book, and the merit of seeking it out...');
          Message('Knowing it may solve your questions, you decide to find it!');
          Message('(With determination, you feel unstoppable!)')
        end;
   10, 23 : begin
          for i := 1200 downto 35 do
            begin
              PSound(i,1);
              GotoXY(XCord,YCord);
              case i of
                1200 : Write('O');
                1050 : Write( #9);
                800  : Write('¯');
                500  : Write('˘');
                300  : Write('˙');
                150  : Write(' ');
              end
            end;
          NoSound;
          Message('You fall into the next level...');
          Inc(LevelNum);
          LoadLevel(LevelNum,NORMAL)
        end;
   15 : ZapBlock(SymX(5),SymY(10),'S');
   17 : begin
          Message('In the corner of this dusty chamber lies a box.');
          Message('Upon the lid of the box is a scrawled message, which reads:');
          Message('"The desire of your heart ye will see..."');
          Message('"...ye have but to open me!"');
          case OPMessage('What do you wish for...wealth, power, long life? (W,P,L)?','WPL') of
            'W' : begin
                    Message('Within is a huge gold nugget worth 5,000 points!');
                    Inc(IncScore,5000)
                  end;
            'P' : begin
                    Message('Out pops a pouch holding 25 power gems!');
                    Inc(Sword,25)
                  end;
            'L' : begin
                    Message('Inside you find a sack containing 40 health gems!');
                    Inc(Health,40)
                  end
          end;  {case}
          UpdateStats;
          Message('The box turns to dust in your hands, but your treasure remains.')
        end;
   22 : begin
          DownScratch;
          if SwordPower > 0
            then Dec(SwordPower);
          GotoXY(74,11);
          TextAttr := LightGray * 16; 
          Write('  ');      {to erase '+1' if goes to +0}
          UpdateStats;
          Message('You find your strength weakened!!')
        end;
   24 : for i := 53 to 57 do
          ZapBlock(SymX(i),9,'W');
   25 : begin
          Message('You see an ivory pedestal on the edge of the abyss...');
          Message('On the pedestal you see a sealed book.');
          Message('There is something special about this book...');
          Message('(You can feel it!)');
          Message('With sweating palms you slowly reach for the relic.');
          Message('AND YET...!');
          Message('You sense it may be the cause of your death!');
          Num := 0;
          while Num < 5 do
            begin
              if Num < 2
                then if OPMessage('Will you take The Book (Y / N)? ','YN') = 'N'
                       then begin
                              Inc(Num);
                              Message('But it is the object of your Quest...');
                              Message('You realize no stone may be left unturned!')
                            end
                       else Num := 5
                else if OPMessage('You WILL take the book! (Y)','Y') = 'Y'
                       then Num := 5
            end;
          Message('You take the mysterious tome in your hands...');
          Message('Suddenly its power surges through your body!!');
          for i := 35 to 2000 do
            begin
              PSound(i,5);
              GotoXY(XCord,YCord);
              TextAttr := Random(15) + 1;
              Write(Chr(Random(2) + 1));
              GotoXY(23,25);
              Write('What is happening?!?')
            end;
          TextAttr := Yellow;
          i := 3000;
          while i > 35 do
            begin
              PSound(i,1);
              GotoXY(XCord,YCord);
              Write(Chr(Random(5) + 219));
              Dec(i,3)
            end;
          GotoXY(XCord,YCord);  Write(' ');
          NoSound;
          Message('The power of the Book has taken you to the surface!');
          TallyStat(Health,50,10,100,'Your health gems are worth 100 points each...');
          TallyStat(Sword,50,20,200,'Your power gems are worth 200 points each...');
          TallyStat(Magic,100,50,500,'Your magic scrolls are worth 500 points each...');
          TallyStat(Keys,250,200,10000,'Your keys are worth 10,000 points each!');
          Inc(IncScore,25000);
          repeat
            AddScore(IncScore)
          until IncScore = 0;
          Message('...and the Book is worth 25,000 points!  (Wow.)');
          LevelNum := 26;   {FIN}
          GameOver(WINS)
        end;
  end {Floor}
end;  {SpecialItem}

Procedure Magic1(Floor : integer);
begin
  case Floor of
    0 : begin
          for i := 60 to 61 do
            for j := 17 to 19 do
              ZapBlock(i,j,' ');
          Message('You have triggered a magic spell!')
        end;
    2 : begin
          for i := 12 to 18 do
            for j := 1 to 8 do
              ZapBlock(SymX(i),SymY(j),'€');
          Message('The passage falls in, leaving no way through!')
        end;
    4 : begin
          for j := 11 to 12 do
            ZapBlock(SymX(11),SymY(j),'≤');
          Message('You have triggered a magical spell...')
        end;
    5 : for i := 13 to 22 do
          for j := 5 to 12 do
            if Level[SymX(i),SymY(j)] = 'L'
              then ZapBlock(SymX(i),SymY(j),'∞');
    6 : ZapBlock(SymX(2),SymY(10),'Z');
    7 : begin
          Message('A wrinkled piece of parchment lies on the ground.');
          Message('You pick it up and read its message to you.');
          Message('"You found the way onto the island, Wise One.  Congrats!"')
        end;
    9 : Message('You hear a voice bellow, "Welcome to the first SIDEWAYS level!"');
   10 : for i := 31 to 51 do
          if Level[i,SymY(15)] = '∞'
            then ZapBlock(i,SymY(15),'+');
   11 : begin
          MU;
          Inc(XCord,33);
          YCord := 1;
          PrintMan;
          MU
        end;
   13 : for Num := 1 to 30 do
          begin
            PSound(3000,2);
            repeat
              i := Random(64) + 1;
              j := Random(24) + 1
            until Level[i,j] = ' ';
            Level[i,j] := 'I';
            NoSound;
            DrawSpot(i,j)
          end;
   14 : for j := 3 to 11 do
          ZapBlock(SymX(63),j,' ');
   15 : for i := 38 to 56 do
          for j := 21 to 23 do
            ExplodeBlock(SymX(i),SymY(j),'∞');
   16 : Message('If you want wealth, here is the key...Two, One, Three, Three.');
   17 : begin
          for i := 6 to 19 do
            ZapBlock(SymX(i),12,'€');
          for i := 6 to 19 do
            ZapBlock(SymX(i),20,' ')
        end;
   18 : if YCord = 9
          then begin
                 for i := 3 to 4 do
                   ZapBlock(SymX(i),2,' ');
                 for i := 44 to 59 do
                   ZapBlock(SymX(i),6,' ')
               end
          else begin
                 for i := 3 to 4 do
                   ZapBlock(SymX(i),24,' ');
                 for i := 44 to 59 do
                   ZapBlock(SymX(i),20,' ')
               end;
   19 : Message('The way is deceptive, but the riches are many...');
   21 : for i := 40 to 49 do
          for j := 23 to 24 do
            if Level[SymX(i),SymY(j)] = '€'
              then ZapBlock(SymX(i),SymY(j),' ');
   22 : begin
          Message('You take a deep breath and pull the lever...');
          for j := 1 to 7 do
            ExplodeBlock(SymX(55),j,'/')
        end;
   24 : for i := 18 to 24 do
          ZapBlock(Symx(i),12,'€');
   25 : begin
          for i := 1 to 9 do
            for j := 1 to 24 do
              if Level[i,j] = '='
                then ZapBlock(i,j,'€');
          for i := 56 to 64 do
            for j := 1 to 24 do
              if Level[i,j] = '='
                then ZapBlock(i,j,'€')
        end;
  end {Floor}
end;  {Magic1}

Procedure Magic2(Floor : integer);
begin
  case Floor of
    2 : begin
          Message('You can see sunlight streaming in from the stairway ahead...');
          Message('...and realize you have broken out from the monsters'' lair!');
          Message('All that remains is to find your way back to your camp...');
          Message('...But after meeting this horde, what else might await you?')
        end;
    4 : begin
          for i := 9 to 11 do
            for j := 16 to 18 do
              if (XCord <> SymX(i)) or (YCord <> SymY(j))
                then ZapBlock(SymX(i),SymY(j),'≤');
          Message('You become trapped by a cave-in!')
        end;
    5 : begin
          for i := 60 to 62 do
            ZapBlock(SymX(i),SymY(20),' ');
          Message('You invoke a magical spell, and the water parts!')
        end;
    6 : begin
          Message('You pick up an old, wrinkled scroll and begin to read...');
          Message('"One can be close yet far...');
          Message('...though the secret is at hand to be found."');
          for i := 54 to 63 do
            for j := 2 to 12 do
              ExplodeBlock(i,SymY(j),'≤')
        end;
    7 : for j := 8 to 12 do
          ExplodeBlock(6,SymY(j),'≤');
    9 : begin
          for i := 29 to 47 do
            ZapBlock(SymX(i),9,'€');
          for i := 28 to 48 do
            ZapBlock(SymX(i),20,'€');
          for i := 57 to 62 do
            for j := 21 to 23 do
              if Level[SymX(i),j] = '€'
                then ZapBlock(SymX(i),j,' ')
        end;
   10 : if Random(2) = 0
          then Level[57,SymY(15)] := 'B'
          else Level[61,SymY(15)] := 'B';
   11 : begin
          PrintMan;
          Message('You fall into the next level...');
          Inc(LevelNum);
          LoadLevel(LevelNum,NORMAL)
        end;
   12, 15 : begin
           PrintMan;
           Message('A tunnel brings you to the next level...');
           Inc(LevelNum);
           LoadLevel(LevelNum,NORMAL)
         end;
   13 : for Num := 1 to 30 do
          begin
            PSound(5000,2);
            repeat
              i := Random(64) + 1;
              j := Random(24) + 1
            until Level[i,j] = ' ';
            Level[i,j] := 'Q';
            NoSound;
            DrawSpot(i,j)
          end;
   14 : Message('You''ll need two keys from the last level!');
   17 : begin
          for j := 2 to 24 do
            for i := 32 to 33 do
              ExplodeBlock(SymX(i),j,'€');
          for i := 32 to 33 do
            begin
              Level[i,24] := '';
              DrawSpot(i,24);
              PSound(1000,250);
              NoSound
            end;
          Message('The core of the pillar dissolves!')
        end;
   18 : begin
          ZapBlock(SymX(17),13,' ');
          ZapBlock(SymX(42),20,' ')
        end;
   21 : for i := 44 to 63 do
          for j := 15 to 22 do
            if Level[SymX(i),SymY(j)] = '∞'
              then ZapBlock(SymX(i),SymY(j),'-');
   22 : begin
          for i := 31 to 42 do
            for j := 4 to 5 do
              begin
                ExplodeBlock(SymX(i),j,'€');
                ExplodeBlock(SymX(i),j,'≤')
              end
        end;
   24 : for i := 5 to 16 do
          ZapBlock(SymX(i),12,'€');
  end {Floor}
end;  {Magic2}

Procedure WisdomTablet(Floor : integer);
begin
  case Floor of
    1 : begin
          Message('You pick up the tablet and begin to read...');
          Message('"A few areas contain a hidden exit...');
          Message('Finding them often results in a bonus!!"');
          ZapBlock(SymX(43),SymY(22),'S')
        end;
    2 : Message('Monsters will be hurt if they hit Crumbled Walls!');
    3 : begin
          Message('You find a message carved into the surface of a strange stone.');
          Message('You pick it up and begin to read...'); 
          Message('"Being valiant of heart is the Key!"');
          Message('It cracks open to reveal a key inside, which will open any door!');
          Inc(Keys);
          UpdateStats
        end;
    6 : begin
          Message('A message is inscribed into a tile on the floor here.');
          Message('It reads, "Can you find the hidden exit?"');
          Message('Hmm...well can you?')
        end;
    7 : begin
          Message('You find a Tablet of Forgotten Lore.');
          Message('You brush away layers of dust and eagerly read...');
          Message('"There is a secret entrance onto the Island, adventurer...');
          Message('...Can you find it?"')
        end;
   16 : begin
          Message('You pick up an old piece of marble and read...');
          Message('"Through fire and wind, your path will be cleared."');
          for i := 1 to 15 do
            for j := 9 to 24 do
              if Level[i,SymY(j)] = '\'
                then Level[i,SymY(j)] := 'L';
          DrawLevel(1,1,15,24);
          for Num := 1 to 5 do
            Electric1;  {sound effect}
          for i := 1 to 15 do
            for j := 9 to 24 do
              if Level[i,SymY(j)] = 'L'
                then Level[i,SymY(j)] := ' ';
          DrawLevel(1,1,15,24)
        end;
   19 : begin
          Message('There is much sunken treasure here...');
          for i := 1 to 64 do
            for j := 1 to 24 do
              if Level[i,j] = 'W'
                then ZapBlock(i,j,'*')
        end;
   21 : Message('The monsters here can only be defeated by barrier or sword!');
   22 : Message('Search the ID for relief not yet found.');
   24 : Message('To succeed, the ropes must be triggered in the right order.');
  end {Floor}
end;

end.  {Unit Quest1}
