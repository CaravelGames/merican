Unit PEdit1;   

{Used to run "PlayEdit" when playing levels designed in "The Merican Editor"}
{What a pain to duplicate all these procedures...sheesh! (But I have to.)}

Interface

Uses Sounds, ErikSnd, Crt, CrtEXTRA, MerCrt, Quest1;

const
  NOVICE   = 0;     {skill levels}
  ADVANCED = 1;
  EXPERT   = 2;
  Version  = 1.00;  {game version}

  TopVIEW  = 0;  SideVIEW = 1;
        WT = 1;        SL = 2;     MA = 3;

type
  String50  = string[50];
  SpecItemPtr = ^SpecItemRec;
  SpecItemRec = record
                  Data : string50;
                  Next : SpecItemPtr
                end;
  ItemRec   = record
                IType : byte;
                Chr   : char;
                Color : byte;
                Item  : SpecItemPtr
              end;

  LStatRec  = record
                Name : string[30];
                View : byte;
                XFlip, YFlip : boolean;
                WallColor : byte
              end;
  LevelRec  = record
                LStat : LStatRec;
                Level : LevelMat
              end;
  LevelFile = file of LevelRec;

var
  LevelF     : LevelFile;
  TempSpec,
  Specials   : array[1..3] of ItemRec;  {definition of special items}
  LStat      : LStatRec;
  Temp,
  LevelInfo  : LevelRec;
  SpecialF   : text;
  SkillLevel : integer;
  LevelName  : string[25];

Procedure GetSkill2(var Stat : integer; N, E, A : integer);
Procedure ReadLevel2(LevelNumber, Entrance : integer);
Procedure LoadLevel2(Floor, Entrance : integer);
Procedure PrintStatusWindow;

Procedure SaveGame2;
Procedure RestoreGame2;

Procedure PrintScores2(var Place : integer);
Procedure EnterName2(Place : integer);
Procedure HighScoreList2(Fate : integer);
Procedure GameOver2(Fate : integer);

Procedure DrawEditSpot(x,y : integer);

Procedure RemNoMoveSpots(x, y : integer);
Procedure SidewaysPit;
Procedure BottomlessPit;
Procedure GetAdjSpot(var x, y : integer);
Procedure FlashMan;
Procedure SecretTunnel;

Procedure RestoreSpecials;

(***)  Implementation  (***)

Procedure Conclusion2;
  {* Altered epilogue for customized game levels}
begin
  Writeln('* Well, you completed all the levels!!!');
  Writeln('(Don''t you feel proud of yourself?)');
end;

Procedure GetSkill2(var Stat : integer; N, E, A : integer);
  {* Depending on the level of skill, a value is returned for Stat}
begin
  case SkillLevel of
    NOVICE   : Stat := N;
    ADVANCED : Stat := E;
    EXPERT   : Stat := A
  end
end;

Procedure ReadLevel2(LevelNumber, Entrance : integer);
  {* Reads in current level from constant LevelArray}

var  x, y  : integer;

begin
  MonsterGen := 0;

  Seek(LevelF,LevelNumber);
  Read(LevelF,LevelInfo);
  Level := LevelInfo.Level;
  LStat := LevelInfo.LStat;
  RestoreSpecials;           {get customized special items from file}
  if LStat.XFlip and (Random(10) < 5)  {decide if level is reflected}
    then FlipX := TRUE
    else FlipX := FALSE;
  if LStat.YFlip and (Random(10) < 5)
    then FlipY := TRUE
    else FlipY := FALSE;
  LevelView := LStat.View;     {whether level is TopVIEW or SideVIEW}
  WallColor := LStat.WallColor;
  LevelName := LStat.Name;     {name of level}

  for y := 1 to 24 do          {reflect level}
    for x := 1 to 64 do
      Temp.Level[SymX(x),SymY(y)] := Level[x,y];
  Level := Temp.Level;
  XCord := 1;
  YCord := 1;
  for y := 1 to 24 do
    for x := 1 to 64 do
      case Level[x,y] of
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

        '‹' : if FlipY then Level[x,y] := 'ﬂ';
        'ﬂ' : if FlipY then Level[x,y] := '‹';
        '›' : if FlipX then Level[x,y] := 'ﬁ';
        'ﬁ' : if FlipX then Level[x,y] := '›';
        '<' : if FlipX then Level[x,y] := '>';
        '>' : if FlipX then Level[x,y] := '<';

                                   {x,y,spd,hts,dmg,chr}
        '0'..'9' : AppendMonster(x,y,MonSpeed[Ord(Level[x,y]) - 48],
          MonHits[Ord(Level[x,y]) - 48],MonDmg[Ord(Level[x,y]) - 48],Level[x,y]);
      end {Level[x,y] case}
end;

Procedure LoadLevel2(Floor, Entrance : integer);
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
  ReadLevel2(Floor,Entrance);
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
  Message('  ' + LevelName + '  ')
end;

Procedure PrintStatusWindow;
  {* Draws status area and message bar on screen}

var i : integer;

begin
  TextAttr := Black;   {clears screen areas}
  Window(1,1,80,25);
  ClrScr;
  TextAttr := Blue * 16;
  Window(1,25,64,25);
  ClrScr;
  Window(65,1,80,25);
  ClrScr;

  TextAttr := LightGray * 16;    {clears status windows} 
  for i := 2 to 17 do
    if (i mod 3) = 2
      then begin
        Window(67,i,78,i);
        ClrScr
      end;

  TextAttr := White + Blue * 16;   {writes status names}
  Window(1,1,80,25);
  GotoXY(71,1);   Write('Score');
  GotoXY(71,4);   Write('Level');   {beam/jump/magics - different games?}
  GotoXY(70,7);   Write('Health');          {can't put TOO much into any}
  GotoXY(71,10);  Write('Sword');                 {one of them, ya know!}
  GotoXY(69,13);  Write('Scrolls');
  GotoXY(71,16);  Write('Keys');

  TextAttr := LightMagenta + Blue * 16;   {prints options available}
  GotoXY(68,18);  Write('OPTIONS');
  TextAttr := Yellow + Blue * 16;
  GotoXY(68,19);  Write('ƒƒƒƒƒƒƒƒƒƒ');

  TextAttr := White + Blue * 16;
  GotoXY(68,20);  Write('H');
  GotoXY(73,20);  Write('M');
  GotoXY(68,21);  Write('P');
  GotoXY(68,22);  Write('N');
  GotoXY(68,23);  Write('S');
  GotoXY(68,24);  Write('R');
  GotoXY(68,25);  Write('Q');
  
  TextAttr := LightGray + Blue * 16;
  GotoXY(69,20);  Write('ack/');
  GotoXY(74,20);  Write('agic');
  GotoXY(69,21);  Write('ause');
  GotoXY(69,22);  Write('oise Off');
  GotoXY(69,23);  Write('ave');
  GotoXY(69,24);  Write('estore');
  GotoXY(69,25);  Write('uit')
end;

Procedure SaveGame2;
  {* Saves game stats into file "mereditn.sav"}

var  Sf     : text;  {save file}
     Choice : char;

begin
  PSound(500,100);  PSound(300,100);  PSound(100,100);  NoSound;
  if OPMessage(' Do you want to SAVE {Y / N}? ','YN') = 'N'
    then EXIT;
  Choice := OPMessage(' Save game to file <A - E>? ','ABCDE');
  Assign(Sf,'meredit' + Choice + '.sav');
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

Procedure RestoreGame2;
  {* Restores game from file "mereditn.sav"}

var  Rf     : text;  {restore file}
     Choice : char;
     Result : integer;

begin
  PSound(100,100);  PSound(300,100);  PSound(500,100);  NoSound;
  if OPMessage('Do you want to RESTORE {Y / N}?','YN') = 'N'
    then EXIT;
  Choice := OPMessage(' Restore game from file <A - E>? ','ABCDE');
  Assign(Rf,'meredit' + Choice + '.sav');
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
  LoadLevel2(LevelNum,Ord(SEntrance))
end;

Procedure PrintScores2(var Place : integer);

var  Famer, Temp : FameRec;
     Cnt         : integer;

begin
  Place := 99;
  GetSkill2(Num,1,16,31);
  Seek(ScoreF,Num);
  for i := 1 to 15 do
    begin
      Read(ScoreF,Famer);
      if (Score > Famer.Score) and (Place > i)
        then Place := i          {if qualified, player gets score slot 'i'}
  end;

  GetSkill2(i,0,15,30);    {find position of chart in file for skill level}
  GetSkill2(j,15,30,45);             {last record in chart for skill level}
  for Cnt := (j - 1) downto (Place + i) do     {slide scores down one slot}
    begin                                         {under player's position}
      Seek(ScoreF,i + Cnt);
      Read(ScoreF,Temp);
      Seek(ScoreF,i + Cnt + 1);
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

Procedure EnterName2(Place : integer);
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
  GotoXY(15,6 + Place);
  Readln(Honor.Name);
  if Length(Honor.Name) = 0
    then Honor.Name := 'Slicko';
  CursorOff;

  Honor.Score := Score;
  Honor.Level := LevelNum;
  GetSkill2(i,0,15,30);    {find position in file of chart for skill level}
  Seek(ScoreF,i + Place);
  Write(ScoreF,Honor)
end;

Procedure HighScoreList2(Fate : integer);
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

  PrintScores2(Place);    {print high score list}
  RemKeys;
  if Place <= 15         {player enters name, if qualified}
    then EnterName2(Place);
  Window(1,1,80,25)
end;

Procedure GameOver2(Fate : integer);
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
             HighScoreList2(DIES);
             if OPMessage('Do you want to play again {Y / N}?','YN') = 'N'
               then ExitProg := TRUE
           end;
    QUIT : begin
             HighScoreList2(QUIT);
             if OPMessage('Do you want to play again {Y / N}?','YN') = 'N'
               then ExitProg := TRUE
           end;
    WINS : begin
             HighScoreList2(WINS);
             Message('Hit any key to continue...');
             Conclusion2;
             ExitProg := TRUE
           end;
  end  {case Fate}
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

Procedure DrawEditSpot(x, y : integer);
  {* Draws item at position (x,y) in level}
var  Spot : char;

begin
  GotoXY(x,y);
  Spot := Level[x,y];
  case Spot of
    '-','_','=',':',';','.','D','P','E','G','J',']','H','B','!','N','Ò','¯',',',
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
    '∫','Õ' : begin                   {bridge rails}
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
    '(' : begin                       {special 1}
            TextAttr := Specials[1].Color;
            Write(Specials[1].Chr)
          end;
    '˙' : begin                       {special 2}
            TextAttr := Specials[2].Color;
            Write(Specials[2].Chr)
          end;
    ')' : begin                       {special 3}
            TextAttr := Specials[3].Color;
            Write(Specials[3].Chr)
          end;
    else begin                        {- unknown char -}
           TextAttr := White + Blink;
           Write('?')
         end
  end {Spot case}
end;

Procedure RemNoMoveSpots(x, y : integer);
  {* Removes all connected "_" chars from level}
begin
  if (x < 1) or (x > 64) or (y < 1) or (y > 64)    {boundary check}
    then EXIT;
  if Level[x,y] = '_'         
    then begin
           Level[x,y] := ' ';             {remove no-move spot}
           RemNoMoveSpots(x - 1,y - 1);   {check all connected squares}
           RemNoMoveSpots(x, y - 1);
           RemNoMoveSpots(x + 1,y - 1);
           RemNoMoveSpots(x - 1,y);
           RemNoMoveSpots(x + 1,y);
           RemNoMoveSpots(x - 1,y + 1);
           RemNoMoveSpots(x,y + 1);
           RemNoMoveSpots(x + 1,y + 1)
         end
end;

Procedure SidewaysPit;
  {* Player falls down pit and dies - side view}

var  Last : integer;

begin
  Window(1,1,64,24);    {draw pit}
  TextAttr := LightGray * 16;
  ClrScr;
  Window(22,1,30,25);
  for Num := 1 to 24 do
    Write('∞∞∞∞±±±≤≤');
  Window(36,1,44,25);
  for Num := 1 to 24 do
    Write('≤≤±±±∞∞∞∞');
  Window(31,1,35,24);
  TextAttr := Black;
  ClrScr;
  Window(33,1,33,25);  {player at x = 32}

  TextAttr := Yellow;
  Last := 0;
  j := 0;
  for Num := 2400 downto 35 do
    begin
      PSound(Num,Num div 450);
      if (Num mod 100) = 0
        then begin
               Last := j;
               Inc(j)            {man speeds up as he falls}
             end;
      if (Num mod 10) = 0
        then begin
               GotoXY(1,Last + 1);  {erase player}
               Write(' ');
               GotoXY(1,j + 1);  {draw player}
               Write(#2)
             end
    end;
  GotoXY(1,Last + 1);     {draw 'pancake'}
  Write(' ');
  GotoXY(1,24);
  Write('_')
end;

Procedure BottomlessPit;
  {* Player falls down pit and dies - top view}

begin
  PrintMan;
  for Num := 1200 downto 35 do
    begin
      GotoXY(XCord,YCord);
      TextAttr := ManColor mod 16;  {black background}
      case Num of
        1200 : Write('O');
        1050 : Write(#9 );
         900 : Write('¯');
         650 : Write('˘');
         350 : Write('˙');
         100 : Write(' ')
      end; {Num case}
      PSound(Num,2)
    end
end;

Procedure GetAdjSpot(var x, y : integer);  {in/out}
  {* Returns pos for blank space next to (x,y)}

var  BlankSpots : array[-1..1,-1..1] of boolean;
           Flag : boolean;

begin
  Flag := FALSE;
  for i := -1 to 1 do
    for j := -1 to 1 do
      if ((x + i > 0) and (x + i < 65) and (y + j > 0) and (y + j < 25))
        then if (Level[x + i,y + j] in [' ','-','_'])
               then begin
                      BlankSpots[i,j] := TRUE;  {spot is blank}
                      Flag := TRUE              {one spot is open}
                    end
               else BlankSpots[i,j] := FALSE    {spot not blank}
        else BlankSpots[i,j] := FALSE;          {spot off board}
  if Flag
    then begin
           repeat
             i := Random(3) - 1;                {choose random open spot}
             j := Random(3) - 1
           until BlankSpots[i,j];
           x := x + i;                          {set new (x,y) to spot}
           y := y + j
         end
end;

Procedure FlashMan;
  {* Man blinks before/after disappearing}
begin
  for Num := 1 to 50 do
    begin
      GotoXY(XCord,YCord);         {flash player}
      TextAttr := Random(127) + 1;
      Write(Chr(Random(2) + 1));
      Delay(15)
    end;
  GotoXY(XCord,YCord);  {erase player char}
  TextAttr := Black;
  Write(' ')
end;

Procedure SecretTunnel;
  {* Moves man to another tunnel on level}

var NewX, NewY : integer;  {player's new pos from new tunnel}

begin
  Messages(15);
  NewX := XCord;  NewY := YCord;  {keep 1st tunnel's pos}
  MB;
  FlashMan;                       {visual effect}
  DrawSpot(XCord,YCord);
  XCord := NewX;  YCord := NewY;
  Squish3; {Crackle;}
  
  Num := 1;     {counter - tests whether another tunnel is open}
  repeat
    repeat
      NewX := Random(64) + 1;
      NewY := Random(24) + 1;
      Inc(Num)
    until ((Level[NewX,NewY] = 'U') and ((NewX <> XCord) or (NewY <> YCord)))
        or (Num > 2000);
    GetAdjSpot(NewX,NewY);       {find Spot next to tunnel}
  until (Level[NewX,NewY] in [' ','-','_'])    {make sure tunnel is open}
        or (Num > 2000);

  if Num > 2000
    then begin
           NewX := OldX;
           NewY := OldY;
           Message('You must have been turned around inside the tunnel...')
         end;
  XCord := NewX;  YCord := NewY;  {place player by new tunnel}
  MU;
  FlashMan;
  PrintMan;
  RemKeys
end;

Procedure DisposeSpecData;
  {* Remove all data strings from special item records}
var Trav, Old : SpecItemPtr;

begin
  for i := 1 to 3 do
    begin
      Trav := Specials[i].Item;
      Specials[i].Item := nil;
{      while Trav <> nil do
        begin
          Old := Trav;
          Trav := Trav^.next;
          if Old = nil then Write(#7);
          Dispose(Old)
        end
}    end
end;

Procedure RestoreSpecials;
  {* Loads definitions of special items from text file in var Specials}
var Trav, NewData : SpecItemPtr;
    sf : text;
    C : char;
    N : integer;
    S : string;

begin
  Assign(sf,'meredit.spc');
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
  for i := 1 to 3 do
    begin
      Readln(sf,S);  {#n}
      Read(sf,Specials[i].IType,C,Specials[i].Chr,C);
      Readln(sf,Specials[i].Color);
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

end.
