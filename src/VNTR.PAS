Program MericanAdventure;                    {"The 'Merican Adventure"}
                                  {designed & written by Michael Rimer}
                             {begun May 1994 - last modified 17 Oct 95}
{$M 16000,0,100000}

Uses Dos, Crt, CrtEXTRA, PlayWave, Sounds, Sounds2,
     VntrMisc, VntrVars, VntrMstr, VntrItem;

Procedure CheckPos;  forward;

{PROCEDURE LISTING}

{MakeScoreList  PrintScores  ModifyName  EnterName  HighScoreList  GameOver
 EraseWindow
 SaveInfo  SaveGame  RestoreInfo  RestoreGame
 UseMagic  HitSpot  SwingSword
 Action  GetKeyPress
 ModifySpot  ToggleSpot2  GetSNum  DoSpecAction  DoSpecial
 CheckPos
 DrawStatusBar
 Init  Done
 MonstersFall  PlayerFalls
 Interact  GameLoop
 TitleScreen  AboutMerVntr Instructions OPScr2  OptionScreen
 GetParams}

(**************************  PROCEDURES  **************************)

{------------  HIGH SCORE LIST  ----------------}

Procedure MakeScoreList;
  {* Creates new file on disk to save high scores}

var Res   : integer;
    Famer : FameRec;

begin
  repeat
    {$I-}  ReWrite(ScoreF);  {$I+}     {error checking}
    Res := IOResult;
    if Res <> 0
      then begin
             Writeln('<ERROR - Can''t create high score file>');
             Writeln('(Hit "Q" to quit game, or any other key to try again.)');
             Ch := UpCase(ReadKey);
             if Ch = 'Q' then HALT(1)
           end;
  until (Res = 0) or (Ch = 'Q');

  Write(ScoreF,Famer);   {0th record is dummy}
  for j := 1 to 3 do     {three skill level "files"}
    for i := 1 to 15 do  {15 score rankings}
      begin
        Famer.Name  := ScoreNames[i];
        Famer.Score := 16 - i;
        Famer.Score := Famer.Score * 3000;
        Famer.Level := 21 - i;
        Famer.Fate := '          ';
        Write(ScoreF,Famer)
      end;

  Close(ScoreF);   {save file to disk}
  Reset(ScoreF)
end;

Procedure PrintScores(var Place : integer);
{Writes list of high scores on screen}
var  Famer, Temp : FameRec;
     Cnt         : integer;

begin
  Place := 99;
  GetSkill(Num,1,16,31);
  Seek(ScoreF,Num);
  for i := 1 to 15 do
    begin
      Read(ScoreF,Famer);
      if (P.Score > Famer.Score) and (Place > i)
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
      GotoXY(4,6 + i);
      TextAttr := (i mod 3) + LightGreen;
      Write(i:2,'.  ');
      if i <> Place
        then begin
               Write(Famer.Name);
               GotoXY(31,6 + i);
               Write(Famer.Score:7,'     ');
               if Famer.Level > 25
                 then Write('WIN')
                 else Write(Famer.Level:2,' ');
               Writeln('   ',Famer.Fate);
             end
    end
end;

Procedure ModifyName(var Honor : FameRec);
{Changes certain phrases in high score list -- good for a joke!}
var P : integer;

  Procedure MN2(var Honor : FameRec; Pos, Count : integer; NewName : string);
  {* Cuts out Count chars from Name, and replaces with NewName}
  begin
    if Pos <> 0
      then begin
             Delete(Honor.Name,Pos,Count);
             Insert(NewName,Honor.Name,Pos)
           end
  end;  {MN2}

begin
  if Length(Honor.Name) = 0                {replace empty strings}
    then Honor.Name := 'Lost Adventurer';
  P := Pos('GREAT',Honor.Name);  MN2(Honor,P,5,'GRUMP'); {change names here}
  P := Pos('Great',Honor.Name);  MN2(Honor,P,5,'Grump');
  P := Pos('great',Honor.Name);  MN2(Honor,P,5,'grump');
  P := Pos('SIR',Honor.Name);  MN2(Honor,P,3,'MS.');
  P := Pos('Sir',Honor.Name);  MN2(Honor,P,3,'Ms.');
  P := Pos('sir',Honor.Name);  MN2(Honor,P,3,'ms.');
end;

Procedure EnterName(Place, Fate : integer);
  {* Player enters their name into high score list}
var Honor : FameRec;

begin
  GotoXY(31,6 + Place);
  Write(P.Score:7,'     ');
  if LevelNum > 25
    then Write('WIN')
    else Write(LevelNum:2,' ');
  case Fate of
    WINS : if BigSecret then Honor.Fate := '** JOY **'
             else Honor.Fate := '* Wealth *';
    DIES : case P.OnItem of
             HotSpot : Honor.Fate := ' Hot spot';
             Lava : Honor.Fate := ' Hot Lava';
             Pit  : Honor.Fate := '   Pit';
             ForceField : Honor.Fate := '  Fried';
             Water, DeepWater : Honor.Fate := ' Drowned';
             FB1 : Honor.Fate := ' Crushed';
             MagicSpear : Honor.Fate := 'Shishkabob';
             Fireball : Honor.Fate := ' Fireball';
           else Honor.Fate := '  Eaten'; {monster (probably)}
           end;
    QUIT : Honor.Fate := 'Sabbatical';
  end; {Fate}
  Write('   ',Honor.Fate);
  GotoXY(9,6 + Place);
  TextAttr := White + Magenta * 16;
  Write('                    ');

  CursorFull;       {enter name}
  Window(11,7 + Place,34,8 + Place);
  Readln(Honor.Name);
  ModifyName(Honor);
  CursorOff;

  Honor.Score := P.Score;  {save score}
  Honor.Level := LevelNum;
  GetSkill(i,0,15,30);     {find position in file of chart for skill level}
  Seek(ScoreF,i + Place);
  Write(ScoreF,Honor)
end;

Procedure HighScoreList(Fate : integer);
  {* Displays score list for difficulty level chosen (with level & fate)}
var Place : integer;

begin
  if LData.View in [Side,Top] then BlankBoard(1,1,64,24);
  Window(1,1,64,25);  TextBackground(Random(7) + 1);  ClrScr;
  GotoXY(21,1);
  Inc(TextAttr,Yellow + Blink);
  case Fate of
    WINS : Write('YOUR QUEST WAS SUCCESSFUL!');
    DIES : Write('      YOU HAVE DIED!!');
    QUIT : Write('YOU TOOK THE EASY WAY OUT!')
  end;
  Window(3,2,62,23);  TextAttr := LightMagenta;  ClrScr;
  GotoXY(29,2);
  case SkillLevel of
    NOVICE   : Write(' NOVICE');
    ADVANCED : Write('ADVANCED');
    EXPERT   : Write('EXPERT')
  end;
  GotoXY(27,3);
  Write('Hall of Fame');
  TextAttr := Red;
  GotoXY(9,5);
  Write('Name                    Score    Level     Fate');
  GotoXY(9,6);
  Write('--------------------   -------   -----  ----------');

  {$I-}  Reset(ScoreF);  {$I+}
  if IOResult <> 0
    then MakeScoreList;  {create new score file if none is found}

  if Fate = QUIT
    then P.Score := 0;    {don't register score on quitting}
  PrintScores(Place);    {print high score list}
  if WaveOn
    then PlayWav('crescent.wav');  {ending music}
  RemKeys;
  if Place <= 15         {player enters name, if qualified}
    then EnterName(Place,Fate);
  Close(ScoreF);
  Window(1,1,80,25)
end;

Procedure Done;
  {* Saves settings, Closes files, Quits game, Returns to caller}
type DataRec = record
                 TurnDelay, SkillLevel : integer;
                 Noise, WaveOn : boolean;
               end;
var  Data  : DataRec;
     DataF : file of DataRec;

begin
  Data.TurnDelay := TurnDelay;
  Data.SkillLevel := SkillLevel;
  Data.Noise := Noise;
  Data.WaveOn := WaveOn;
  Assign(DataF,'vntr.dat');
  Rewrite(DataF);
  Write(DataF,Data);
  Close(DataF);

  Close(LevelF); {Erase(LevelF); has problem - files end up as lost clusters!}

  CursorOn;
  TextAttr := LightGray;  Window(1,1,80,25);  ClrScr;  TextAttr := White;
  Exec('vnormal.com','');
  Writeln('THE ''MERICAN ADVENTURE');
  Writeln('  by: Michael Rimer');
  Writeln('    Version ',Version:1:2);
  TextAttr := LightGray;
  Writeln;
  Halt(0)
end;

{----------------  END OF GAME  ------------------}

Procedure Conclusion;
  {* End of game - the wrap up story}
  {* BigSecret found gives the best ending}
begin
  SetBorder(White);
  Window(1,1,80,25);
  TextAttr := Yellow + Blue * 16;
  ClrScr;
  Window(3,2,80,25);
  GotoXY(31,1);
  Write('BACK AT HOME');
  GotoXY(31,2);
  Write('ƒƒƒƒƒƒƒƒƒƒƒƒ');
  TextAttr := White + Blue * 16;
  GotoXY(1,3);
  Writeln('  In the blink of an eye, you have appeared in front of your humble abode.');
  Writeln('It takes you several moments to readjust to your own world after abiding');
  Writeln('in that world of spirits.  What dazzling beauty was there!  What radiant');
  Writeln('light and energy!  You know you will never look at your mundane, terrestrial');
  Writeln('land in quite the same way from now on.  You breathe a heavy sigh and walk');
  Writeln('up to the door.  Pushing it open, you find everything is as you left it.');
  Writeln('  Sitting back and relaxing in your favorite chair that night, your');
  if BigSecret
    then begin
  Writeln('mind wanders back to that glorious place: tears fill your eyes and a');
  Writeln('warm tingling runs through you.  Oh, what beauty!  You cannot wait till');
  Writeln('you find the way to go and live with your friends, family and loved ones');
  Writeln('long gone in eternal happiness and joy.  And yet...you have found joy in the');
  Writeln('simple things of life.  Seeing each sunrise.  Smelling fresh air.  Having a');
  Writeln('good, warm meal.  Being with those you love and who love you.  The peace that');
  Writeln('comes after a day''s work.  Learning of all the world, filled with its exotic');
  Writeln('peoples and cultures, resplendent with all types of mystery and glory!');
  Writeln('  Thus you are content to remain where you are, in your place, for another');
  Writeln('season.  You know you will be there again someday.  And you are truly happy.');
         end
    else begin
  Writeln('eyes wander and view the vast wealth and riches at your disposal.  Think of');
  Writeln('it!  Now you will be able to own anything which this world is capable of');
  Writeln('giving you.  But still that does not make you happy.  You have found joy in');
  Writeln('the simple things of life.  Seeing each sunrise.  Smelling fresh air.  Eating');
  Writeln('a warm, hearty meal.  Satisfaction after a good day''s work.  Learning of all');
  Writeln('the world, filled with its exotic peoples and mysteries and beauties!');
  Writeln('  And your mind wanders back to that glorious place you have left, and you');
  Writeln('think of those noble people of olde.  And you can''t help feeling you missed');
  Writeln('out on something important...something you were once searching for...');
         end;
  Writeln('  So, until the next time the world needs a hero, you decide to rest.');
  Writeln('And maybe, just maybe, in the near future, it will.  In...');
  TextAttr := Yellow + Blue * 16;  GotoXY(28,22);
  Writeln('THE ''MERICAN SORCERER');
  while KeyPressed do
    Ch := ReadKey;
  Window(1,1,80,25);
  BlueMessage('Press any key to continue...');
  SetBorder(Black)
end;

Procedure GameOver(Fate : integer);
  {* Current game ends - result depends on how ended}
begin
  ExitGame := TRUE;
  FreezeTime := 99;    {fixes bug in main game loop}
  case Fate of
    DIES : begin
             Perish1;
             if P.Health > -100
               then SC(P.x,P.y,'*',Yellow + Blink);   {Flash player '*'}
             Message('You have died!!');
             HighScoreList(DIES);
             if OPMessage('Do you want to play again {Y / N}?','YN') = 'N'
               then Done
           end;
    QUIT : begin
             HighScoreList(QUIT);
             if OPMessage('Do you want to play again {Y / N}?','YN') = 'N'
               then Done
           end;
    WINS : begin
             HighScoreList(WINS);
             Message('Hit any key to continue...');
             Conclusion;
             Done
           end;
  end  {case Fate}
end;

{----------------- SAVE / RESTORE GAME ----------------}

Procedure EraseWindow(x1, y1, x2, y2 : integer);
{redraws level where comment box was}
begin
  if LData.View in [Top,Side]
    then begin
           FillBoard(x1,y1,x2,y2);    {several ways to draw level}
           Window(1,1,80,25)
         end
    else begin
           FillWindow(1,1,64,24, #255, DarkGray);
           DrawLevel(P.x - 3,P.y - 2,P.x + 3,P.y + 2)
         end;
  PrintMan
end;

Procedure SaveInfo(Name : string32; Ch : char);  {# of save slot}
  {* Saves actual game info from memory to disk}
var SF : text;                 {special items file (for current level)}
    SL : file of LevelMatrix;  {levels file (holds all 25 levels)}
    LInfo : LevelRec;
    Mon : Monster;  MO : MvgObj;  Itm : Item;

  Procedure FindMon(var Mon : Monster; i, j : integer);
  {* Get monster in linked list}
  begin
    Mon := HeadMonster^.next;
    while (Mon^.x <> i) or (Mon^.y <> j) do
      Mon := Mon^.next
  end;

  Procedure FindMO(var MO : MvgObj; i, j : integer);
  {* Get moving object from list}
  begin
    MO := HeadMvgObj^.next;
    while (MO^.x <> i) or (MO^.y <> j) do
      MO := MO^.next
  end;

  Procedure FindItem(var Itm : Item; i, j : integer);
  begin
    Itm := HeadItem^.next;
    while (Itm^.x <> i) or (Itm^.y <> j) do
      Itm := Itm^.next
  end;

begin
{  Writeln(SF,'MERICAN ADVENTURE SAVE FILE.' + #9);  {w/ EOF char} {*}
{? How do you do this so file stops printing with the 'type' command?}
  case OPMessage('Rename save slot (Y/N/ESC quits)?','YN' + #27) of
    'Y' : begin   {rename save slot}
            Window(15,Ord(Ch) - 43,47,Ord(Ch) - 41);
            for i := 1 to 32 do Write(' ');
            WhiteMessage('Enter new name for save slot.');
            Window(15,Ord(Ch) - 43,47,Ord(Ch) - 41);
            CursorFull;
            GotoXY(1,1);
            Readln(Name);
            CursorOff
          end;
    #27 : EXIT;  {ESC -- do NOT save}
  end;
  Assign(SF,DataFile + '.sf' + Ch);   {save custom info}
  Rewrite(SF);
  Writeln(SF,Name);

  for i := 0 to NumOfMessages do
    Write(SF,Ord(Messages[i]),' ');
  for i := 0 to NumOfLevels do
    Write(SF,Ord(Exited[i]),' ');

  Writeln(SF,LevelNum,' ',FreezeTime,' ',SlowTime,' ',HasteTime,' ',
             InvisTime,' ',BlankTime,' ',SkillLevel,' ',IncScore,' ',g,' ',
             Ord(HideMonsters));

  Writeln(SF,P.Score,' ',P.Health,' ',P.Sword,' ',P.Magic,' ',P.x,' ',P.y,' ',
           P.OnItem,' ',P.Oxygen,' ',P.SwordPower,' ',P.SKeys,' ',P.BKeys,' ',
           P.MKeys,' ',P.Color,' ',P.Chr);    {player info}

  Writeln(SF,Ord(FlipX),' ',Ord(FlipY));  {is level reflected?}

  for i := 1 to 64 do    {scan level for customized items}
    for j := 1 to 24 do
     begin
      case Level[i,j] of   {monster/object/item info}
        M1a..G3 : begin
                    FindMon(Mon,i,j);
                    Write(SF,Mon^.Hits,' ',Mon^.OnItem,' ')
                  end;
        DF1..DF3 : begin
                FindMO(MO,i,j);
                Write(SF,Ord(MO^.Stable),' ',MO^.WaitToFall,' ')
              end;
        FB1..FB3 : begin
                FindMO(MO,i,j);
                Write(SF,Ord(MO^.Falling),' ',MO^.Hits,' ')
              end;
        Lantern, MonZap, RMonZap : begin
                FindItem(Itm,i,j);
                Write(SF,Ord(Itm^.On),' ')
              end;
        MagicSpear : begin
                FindItem(Itm,i,j);
                Write(SF,Ord(Itm^.Fired),' ',Ord(Itm^.Erratic),' ',
                Itm^.XOff,' ',Itm^.YOff,' ',Itm^.Snd,' ',Itm^.OnItem,' ')
              end;
      end;  {case}
      if (Level[i,j] in [GemPouch,Surround,MagicBomb,Lantern,MagicSpear,
               TChest,LTChest,MonGen,RMonGen,RopeExtend,PortalTo,
               PortalFrom,LetterWall])
        then Write(SF,Custom[i,j],' ')
     end;
  Close(SF);

  LevelInfo.LStat  := LData;   {save current level to file}
  LevelInfo.Level  := Level;
  LevelInfo.Custom := Custom;
  Seek(LevelF,LevelNum);
  Write(LevelF,LevelInfo);

  Assign(SL,DataFile + '.sl' + Ch);   {save all levels}
  Rewrite(SL);
  Seek(LevelF,0);
  for i := 0 to NumOfLevels do
    begin
      Read(LevelF,LevelInfo);
      Write(SL,LevelInfo.Level)
    end;
  Close(SL);
  Message('Game ' + Ch + ' saved.')
end;

Procedure SaveGame;
  {* Allows player to save the game currently in progress to disk}
  {* (in 1 of 9 save slots)}
var  NumStr : string64;
     Names : array[1..9] of string64;
     SF : text;

begin
  SolidWindow(10,5,50,15);
  Writeln('            SAVE GAME MENU');
  for i := 1 to 9 do
    begin
      Str(i,NumStr);
      Assign(SF,DataFile + '.sf' + NumStr);
      {$I-} Reset(SF); {$I+}
      if IOResult = 0
        then begin
               Readln(SF,Names[i]);
               Writeln(i,')  ',Names[i]);
               Close(SF)
             end
        else Writeln(i,')  Empty Slot')
    end;
  Ch := OPMessage('Choose a file to Save (1 - 9, ESC quits)','123456789' + #27);
  if Ch in ['1'..'9']
    then SaveInfo(Names[Ord(Ch) - 48],Ch);
  EraseWindow(10,5,50,15)
end;

Procedure RestoreInfo(Ch : char);  {# of save slot}
  {* Saves actual info from game to disk}
var SF : text;
    SL : file of LevelMatrix;
    LInfo : LevelRec;
    Mon : Monster;  MO : MvgObj;  Itm : Item;   {for list traversals}
    Bool : byte;  {convert byte to boolean}
    C : char;        {read in blank spaces from file}

  Procedure FindMon(var Mon : Monster; i, j : integer);
  {* Get monster in linked list}
  begin
    Mon := HeadMonster^.next;
    while (Mon^.x <> i) or (Mon^.y <> j) do
      Mon := Mon^.next
  end;

  Procedure FindMO(var MO : MvgObj; i, j : integer);
  {* Get moving object from list}
  begin
    MO := HeadMvgObj^.next;
    while (MO^.x <> i) or (MO^.y <> j) do
      MO := MO^.next
  end;

  Procedure FindItem(var Itm : Item; i, j : integer);
  begin
    Itm := HeadItem^.next;
    while (Itm^.x <> i) or (Itm^.y <> j) do
      Itm := Itm^.next
  end;

begin
  WhiteMessage('Restoring Game ' + Ch + '...');
  DisposeMonsters;  {trash old level info}
  DisposeMvgObjs;
  DisposeItems;

  Assign(SL,DataFile + '.sl' + Ch);   {restore levels}
  Reset(SL);
  Seek(LevelF,0);
  for i := 0 to NumOfLevels do    {load all levels into memory}
    begin
      Read(LevelF,LInfo);
      Read(SL,LInfo.Level);  {merge saved level data w/ run-time file}
      Seek(LevelF,i);
      Write(LevelF,LInfo)
    end;
  Close(SL);

  Assign(SF,DataFile + '.sf' + Ch);   {restore custom info}
  Reset(SF);
  Readln(SF);  {name}
  for i := 0 to NumOfMessages do
    begin
      Read(SF,Bool,C);
      Messages[i] := Boolean(Bool)
    end;
  for i := 0 to NumOfLevels do
    begin
      Read(SF,Bool,C);
      Exited[i] := Boolean(Bool)
    end;
  Readln(SF,LevelNum,C,FreezeTime,C,SlowTime,C,HasteTime,C,InvisTime,C,
             BlankTime,C,SkillLevel,C,IncScore,C,g,C,Bool);
  HideMonsters := Boolean(Bool);
  Readln(SF,P.Score,C,P.Health,C,P.Sword,C,P.Magic,C,P.x,C,P.y,C,
           P.OnItem,C,P.Oxygen,C,P.SwordPower,C,P.SKeys,C,P.BKeys,C,
           P.MKeys,C,P.Color,C,P.Chr);   {player info}
  Read(SF,Bool,C);  FlipX := Boolean(Bool);  {level reflection}
  Readln(SF,Bool);  FlipY := Boolean(Bool);

  Seek(LevelF,LevelNum);  Read(LevelF,LInfo);  {setup level player is on}
  LData  := LInfo.LStat;
  Level  := LInfo.Level;
 {Custom := assigned later}
  RestoreSpecials;
  RestoreLists;
  UpdateStats;

  for i := 1 to 64 do    {scan level}
    for j := 1 to 24 do
     begin
      case Level[i,j] of   {monster/object/item info}
        M1a..G3 : begin
                    FindMon(Mon,i,j);
                    Read(SF,Mon^.Hits,C,Mon^.OnItem,C)
                  end;
        DF1..DF3 : begin
                FindMO(MO,i,j);
                Read(SF,Bool,C,MO^.WaitToFall,C);
                MO^.Stable := Boolean(Bool)
              end;
        FB1..FB3 : begin
                FindMO(MO,i,j);
                Read(SF,Bool,C,MO^.Hits,C);
                MO^.Falling := Boolean(Bool)
              end;
        Lantern, MonZap, RMonZap : begin
                FindItem(Itm,i,j);
                Read(SF,Bool,C);
                Itm^.On := Boolean(Bool)
              end;
        MagicSpear : begin
                FindItem(Itm,i,j);
                Read(SF,Bool,C);
                Itm^.Fired := Boolean(Bool);
                Read(SF,Bool,C,
                Itm^.XOff,C,Itm^.YOff,C,Itm^.Snd,C,Itm^.OnItem,C);
                Itm^.Erratic := Boolean(Bool)
              end;
      end;  {case}
      if (Level[i,j] in [GemPouch,Surround,MagicBomb,Lantern,MagicSpear,
               TChest,LTChest,MonGen,RMonGen,RopeExtend,PortalTo,PortalFrom,
               LetterWall])
        then Read(SF,Custom[i,j],C)  {load customized items on level}
        else Custom[i,j] := 0
     end;
  Close(SF);

  HGColor := Random(7) + 1;    {final level setup}
  repeat
    PGColor := Random(7) + 1
  until PGColor <> HGColor;
  if LData.View in [Top,Side]
    then begin
           BlankBoard(1,1,64,24);    {several ways to draw/erase level}
           FillBoard(1,1,64,24)
         end
    else begin   {dark level}
           FillWindow(1,1,64,24, #255, DarkGray);
           DrawLevel(P.x - 3,P.y - 2,P.x + 3,P.y + 2)
         end;
  ItemSetup;               {show item effects on level}

  FlashMan;  PrintMan;          {begin level}
  Message('  ' + LData.Name + '  ')
end;

Procedure RestoreGame;
  {* Allows player to reload saved game}
var  Name, NumStr : string64;
     GoodFile : array[1..9] of boolean;
     SF : text;
     Ch : char;

begin
  SolidWindow(10,5,50,15);
  Writeln('           RESTORE GAME MENU');
  for i := 1 to 9 do
    begin
      Str(i,NumStr);
      Assign(SF,DataFile + '.sf' + NumStr);
      {$I-} Reset(SF); {$I+}
      if IOResult = 0
        then begin
               GoodFile[i] := TRUE;
               Readln(SF,Name);
               Writeln(i,')  ',Name);
               Close(SF)
             end
        else begin
               GoodFile[i] := FALSE;
               Writeln(i,')  Empty Slot')
             end

    end;
  repeat
    Ch := OPMessage('Choose a file to Restore (1 - 9,ESC quits)','123456789' + #27);
  until (Ch = #27) or (GoodFile[Ord(Ch) - 48]);
  EraseWindow(10,5,50,15);
  if Ch in ['1'..'9']
    then RestoreInfo(Ch)
end;

{----------  MAGIC  ------------}

Procedure UseMagic(x, y, S : integer);    {S : Spell power}
  {* Cast magic spell - affects objects in 3 block radius}

 Procedure SpellItem(x,y, Power : integer);
   {* Decides if item at (x,y) is affected by spell}
   {  NOTES : Inv. walls, doors not affected}
   {        : Moving, dropping blocks are frozen in place}
   {        : All monsters are killed, but thief's item is NOT dropped}
 begin
   if (x < 1) or (x > 64) or (y < 1) or (y > 24)  {boundary check}
     then begin
            Delay(7);
            EXIT
          end;
   PSound(Random(150) + 35,0);

   case Level[x,y] of
     Forest..DenseForest,Boulder,TeleTrap,StoneDoor..BronzeDoor,
     NoMove1..NoMove3,MonsterMake,
     BLANK,Dirt : begin
             SCol(x,y,LightCyan + Cyan * 16);
             PSound(100,7);
             Level[x,y] := BLANK
           end;
     Ice..DeepIce : begin
             SCol(x,y,LightCyan + Cyan * 16);
             PSound(100,7);
             Dec(Level[x,y],2)   {turn into water}
           end;
     BW1..BW3 : begin
             SCol(x,y,LightCyan + Cyan * 16);
             PSound(100,7);
             Dec(Level[x,y],Power);
             if Level[x,y] < BW1
               then Level[x,y] := Dirt
           end;
     KStatue : begin
             SCol(x,y,LightCyan + Cyan * 16);
             WormScream;
             ZapItem(x,y);
             Inc(IncScore,1000)
           end;
     MonGen, RMonGen : begin
             SCol(x,y,LightCyan + Cyan * 16);
             MonsterYell;
             ZapItem(x,y);
             Inc(IncScore,250)
           end;
     M1a..G3 : begin
             SCol(x,y,LightCyan + Cyan * 16);
             PSound(70,7);
             ZapMonster(x,y);
             Inc(IncScore,10 * Power)
           end;
     MW1 : begin
             SCol(x,y,LightCyan + Cyan * 16);
             PSound(70,7);
             ZapMvgObj(x,y);
             Level[x,y] := Dirt
           end;
     MW2, DF2, FB2 : begin
             SCol(x,y,LightCyan + Cyan * 16);
             PSound(70,7);
             ZapMvgObj(x,y);
             Level[x,y] := BW1
           end;
     MW3, DF3, FB3 : begin
             SCol(x,y,LightCyan + Cyan * 16);
             PSound(70,7);
             ZapMvgObj(x,y);
             Level[x,y] := BW2
           end;
     else begin
            SCol(x,y,(GetSCol(x,y) mod 16) + Cyan * 16);
            PSound(35,5)
          end
   end {case Level[x,y]}
{*}    {Add other mysterious, unpredictable effects of magic here!}
       {Like: dirt/blank ---> gems/gold?}
 end;  {SpellItem}

var xS, yS : word;
begin
  Dec(P.Magic);
  UpdateStats;
  SpellCast;
  for i := 1 to 3 do    {flows outward from player}
    begin
      for j := (x - i) to (x + i) do
        SpellItem(j,y - i,S);
      for j := (y - i + 1) to (y + i - 1) do
        SpellItem(x - i,j,S);
      for j := (y - i + 1) to (y + i - 1) do
        SpellItem(x + i,j,S);
      for j := (x - i) to (x + i) do
        SpellItem(j,y + i,S);
      Delay(10);
      if (x - i >= 1)  {kludge - type casting}
        then xS := x - i
        else xS := 1;
      if (y - i >= 1)
        then yS := y - 1
        else yS := 1;
      PrintRectangle(xS,yS,x + i,y + i) {redraw section}
    end;
  NoSound
end;

Procedure SwingSword(x, y, S : integer);   {S : Sword strength}
  {* Swings sword around man - uses one power gem}

Procedure HitSpot(x, y, Dmg : integer; Chr : char);
  {* Hit one spot w/ sword, determine damage to item there}
var  M : Monster;  {modify monster, if one is hit}
     O : MvgObj;
     Spot  : byte;

begin
  if (x < 1) or (x > 64) or (y < 1) or (y > 24)  {boundary check}
    then begin
           Delay(25);
           EXIT
         end;

  PSound(Random(150) + 35,0);
  SC(x,y,Chr,Random(15) + 1);  {draw sword}

  Spot := Level[x,y];          {check spot}
  case Spot of
    InvPotion1..InvPotion2 : begin
        ZapItem(x,y);
        Level[x,y] := BLANK;
        LowBeep
      end;
    Teletrap : begin
        Level[x,y] := BLANK;
        LowBeep
      end;
    MonGen, RMonGen : begin         {monster generator}
        ZapItem(x,y);
        MonsterYell;
        Inc(IncScore,250)
      end;

    MW1 : begin
        O := HeadMvgObj^.next;
        while (x <> O^.x) or (y <> O^.y)  {find wall}
          do O := O^.next;
        Level[x,y] := O^.OnItem;
        CrumbleWall;
        Inc(IncScore,5);
        O^.prev^.next := O^.next;
        if O^.next <> nil
          then O^.next^.prev := O^.prev;
        Dispose(O)
      end;  {moving wall}
    MW2, DF3, FB3 : begin
        O := HeadMvgObj^.next;
        while (x <> O^.x) or (y <> O^.y)
          do O := O^.next;
        if Random(100) < (50 + Dmg * 25)  {hit: 50% + 25% strength}
          then begin
              Level[x,y] := O^.OnItem;
              CrumbleWall;
              Inc(IncScore,10);
              O^.prev^.next := O^.next;
              if O^.next <> nil
                then O^.next^.prev := O^.prev;
              Dispose(O)
            end
          else CrumbleWall;
      end;  {dropping floor, falling block}
    MW3, DF2, FB2 : begin
            O := HeadMvgObj^.next;
            while (x <> O^.x) or (y <> O^.y)
              do O := O^.next;
            if Random(100) < (50 + Dmg * 25)  {hit: 50% + 25% strength}
              then begin
                  Level[x,y] := O^.OnItem;
                  CrumbleWall;
                  Inc(IncScore,15);
                  O^.prev^.next := O^.next;
                  if O^.next <> nil
                    then O^.next^.prev := O^.prev;
                  Dispose(O)
                end
              else CrumbleWall;
          end;  {dropping floor, falling block}

   M1a..G3 : begin
              M := HeadMonster^.next;
              while (x <> M^.x) or (y <> M^.y)  {find monster}
                do M := M^.next;
              if not (M^.OnItem in [BW1..DownSW,Lava..DeepWater])
              then begin            {^-- ghost in wall}
                Click1;
                Dec(M^.Hits,Dmg + 1);
                if M^.Hits < 1       {monster dead - remove from list}
                  then begin
                         if (M^.MT = Thief) and (M^.Carrying <> BLANK)
                           then begin
                                  Level[x,y] := M^.Carrying;
                                  NewListObject(x,y)
                                end
                           else Level[x,y] := M^.OnItem;
                         Inc(IncScore,10 * (M^.Hits + Dmg + 1));
                         M^.prev^.next := M^.next;
                         if M^.next <> nil
                           then M^.next^.prev := M^.prev;
                         Dispose(M);
                         M := nil
                       end
                  else begin         {monster weakened}
                         Dec(M^.Species,3 * (Dmg + 1));
                         Dec(Level[x,y],3 * (Dmg + 1))
                       end
               end
             end;  {monster}
    BW1 : begin
            Level[x,y] := Dirt;
            CrumbleWall
          end;
    InvBW1 : begin
               if Custom[x,y] = 1
                 then begin
                   Level[x,y] := Dirt;
                   CrumbleWall
                 end;
             end;
    BW2 : begin
            if (Dmg > 0)
              then Level[x,y] := Dirt
              else Level[x,y] := BW1;
            CrumbleWall
          end;
    BW3 : case (Dmg) of
           2..999 : begin
                 Level[x,y] := Dirt;
                 CrumbleWall
               end;
           1 : begin
                 Level[x,y] := BW1;
                 CrumbleWall
               end;
           0 : begin
                 Level[x,y] := BW2;
                 CrumbleWall
               end;
          end; {Dmg case}
    Ice..DeepIce : begin
                     Dec(Level[x,y],2);   {turn into water}
                     CrumbleWall
                   end;
    Forest : begin
               Level[x,y] := BLANK;
               CrumbleWall
             end;
    DenseForest : if Dmg > 0 then begin
                    Level[x,y] := BLANK;
                    CrumbleWall
                  end;
    Boulder : if Random(100) < (50 + Dmg * 25)  {hit: 50% + 25% strength}
            then begin
                   Level[x,y] := Dirt;
                   Crumble2;
                   Inc(IncScore,500)
                 end
            else CrumbleWall;
    KStatue : if Random(100) < (50 + Dmg * 25)  {hit: 50% + 25% strength}
            then begin
                   ZapItem(x,y);
                   WormScream;
                   Message('"Aargh!" the Statue moans as it crumbles to dust.');
                   Inc(IncScore,1000)
                 end
            else CrumbleWall;
  end;  {Spot}
  Delay(75);
  case Level[x,y] of              {redraw old/new spot}
    M1a..G3  : DrawMonster(x,y,0);
    MW1..MW3 : DrawMvgObj(x,y,0);
    else DrawPos(x,y)
  end  {redraw hit monster}
end;  {HitSpot}

begin
  Dec(P.Sword);
  HitSpot(x,y - 1,S,'?);
  HitSpot(x + 1,y - 1,S,'?);
  HitSpot(x + 1,y,S,'?);
  HitSpot(x + 1,y + 1,S,' ');
  HitSpot(x, y + 1,S,'?);
  HitSpot(x - 1,y + 1,S,'?);
  HitSpot(x - 1,y,S,'?);
  HitSpot(x - 1,y - 1,S,'?);
  NoSound;
  UpdateStats;
  RemKeys
end;  {SwingSword}

{----------------}

Procedure Action;
begin
  MU;
  case GoKey of
    1..9 : begin                {player moves}
             MoveMan;
             if BoundCheck      {check to make sure player is in bounds}
               then CheckPos
               else Thump
           end;
    10 : if P.Sword > 0         {sword}
           then SwingSword(P.x,P.y,P.SwordPower)
           else WrongKey;
    12 : SaveGame;              {save - f2}
    13 : RestoreGame;           {restore - f3}
    20 : if P.Magic > 0         {magic scroll}
           then UseMagic(P.x,P.y,P.SwordPower)
           else WrongKey;
    30 : begin                  {toggle sound off/on/enhanced}
           TextAttr := LightGray + Blue * 16;
           GotoXY(75,21);
           if WaveOn
             then begin
                    NoSound;
                    Noise := FALSE;
                    WaveOn := FALSE;
                    Write('Off ')
                  end
             else if Noise
                    then begin
                           WaveOn := TRUE;
                           Write('Full')
                         end
                    else begin
                           Noise := TRUE;
                           Write('On  ')
                         end
         end;
    40 : begin                  {pause}
           DownWhoop;
           Message('Paused...press any key to resume...')
         end;
    41 : begin                  {reset messages}
           for i := 0 to NumOfMessages do
             Messages[i] := TRUE;
           Message('All messages have been reset.')
         end;
    42 : begin                  {turn off messages}
           for i := 0 to NumOfMessages do
             Messages[i] := FALSE;
           Message('Most messages have been turned off.')
         end;
    100 : begin  {DEBUG mode}
            with P do
              begin
                Health := 199;
                Sword := 99;
                Magic := 49;
                SKeys := 9;
                BKeys := 9;
                MKeys := 9
              end;
            UpdateStats;
            Prize
          end;
    QUIT : begin                {quit game}
              PSound(700,100);  PSound(500,100);
              PSound(300,100);  PSound(100,100);
              NoSound;
              if OPMessage('Are you SURE you want to quit {Y / N}?','YN') = 'Y'
                then GameOver(QUIT)
            end
  end;  {GoKey case}
end;

Procedure GetKeyPress;
  {* Returns a number (as GoKey) for valid keys pressed}

begin
  Ch := UpCase(ReadKey);
  if Ch = #0 then         {checks for extended keys}
    begin
      FuncKey := TRUE;
      Ch := ReadKey
    end
    else FuncKey := FALSE;

  GoKey := 0;             {if key is not valid...}
  if FuncKey              {else return number for key}
    then case Ch of       {EXTENDED}
           #71..#73 : GoKey := Ord(Ch) - 64;  {7 8 9}  {Get # for GoKey}
           #75, #77 : GoKey := Ord(Ch) - 71;  {4   6}
           #79..#81 : GoKey := Ord(Ch) - 78;  {1 2 3}
           #32 : if MASTER then GoKey := 100;         {<ALT-D> Debug on}
           #59..#68 : GoKey := Ord(Ch) - 48;  {f1 - f10}
           else WrongKey
         end  {Ch case}
    else case Ch of
           'S'      : GoKey := 10;  {Hack}
           'M'      : GoKey := 20;  {Magic}
           'N'      : GoKey := 30;  {Noise}
           'P'      : GoKey := 40;  {Pause}
           '+'      : GoKey := 41;  {Reset messages}
           '-'      : GoKey := 42;  {Messages off}
           'Q', #27 : GoKey := QUIT;
           else WrongKey
         end;  {Ch case}
  RemKeys
end;

{--------------- SPECIAL PROCS --------------}

Procedure ModifySpot(x, y, E : integer; var Ch : byte);
begin
  case Level[x,y] of
    M1a..G3  : ZapMonster(x,y);      {monster is drawn over}
    MW1..FB3 : ZapMvgObj(x,y);     {moving object is drawn over}
  else if (Level[x,y] in FlashItems+MorphItems) then ZapItem(x,y){item erased}
  end;

  Level[x,y] := Ch;
  if (x = P.x) and (y = P.y)
    then P.OnItem := Ch;
  NewListObject(x,y);

  case (E mod 10) of    {visual effect}
    0 : {no effect};
    1 : for Num := 219 to 223 do  {blink}
          begin
            SC(x,y,Chr(Num),Random(15) + 1);
            Delay(15)
          end;
    2 : for Num := 1 to 15 do     {pop}
          begin
            SC(x,y,#15,Random(15) + 1);
            Delay(3)
          end;
    3 : for Num := 1 to 10 do     {flash}
          begin
            SC(x,y,'?,Random(15) + 1);
            Delay(5)
          end;
  end;
  DrawPos(x,y);

  case (E div 10) of   {sound effect}
    0 : {no sound};
    1 : begin
          for Num := 1 to 5 do
            PSound(500 + Random(500),10);
          NoSound
        end;
    2 : for Num := 1 to 10 do
          begin
            PSound(300,5);
            NoSound;
            Delay(5)
          end;
    3 : Chirp3;
    4 : Spike3;
    5 : Whoop1;
    6 : Spike5;
    7 : Sticky;
    8 : UpScratch1;
    9 : TripleChirp
  end
end;

Procedure ToggleSpot2(x, y, E : integer; var C1, C2 : byte);
  {* Changes C1 to C2 and vice-versa}
begin
  if Level[x,y] = C1
    then ModifySpot(x,y,E,C2)
    else if Level[x,y] = C2
           then ModifySpot(x,y,E,C1)
end;

Procedure GetSNum(var fS, tS : string; var N, Err : integer);
  {* Gets number from beginning of fS, puts into tS}
begin
  tS := '';
  while (fS[1] <> ' ') and (Length(fS) > 0) do
    begin
      tS := tS + fS[1];
      Delete(fS,1,1)
    end;
  Delete(fS,1,1);  {remove space}
  Val(tS,N,Err)
end;

Procedure DoSpecAction(S : string; var Jump : integer);
  {* Executes command from special item}
var i1, i2 : byte;
    SPos, Err,
    T, x1, y1, x2, y2, N, E : integer;
    Str : string;
    C1, C2, J1, J2 : char;

begin
  Jump := -1;
  GetSNum(S,Str, T,Err);
  case T of
    0 : begin   {spots become i1}
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := Ord(S[1]);  Delete(S,1,2);  {remove char & space}
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              ModifySpot(SymX(i),SymY(j),E,i1)
        end;
    1 : begin   {if i1, then becomes i2}
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := Ord(S[1]);  Delete(S,1,2);
          i2 := Ord(S[1]);  Delete(S,1,2);
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              if Level[SymX(i),SymY(j)] = i1
                then ModifySpot(SymX(i),SymY(j),E,i2)
        end;
    2 : begin   {if (not i1), then becomes i2}
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := Ord(S[1]);  Delete(S,1,2);
          i2 := Ord(S[1]);  Delete(S,1,2);
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              if Level[SymX(i),SymY(j)] <> i1
                then ModifySpot(SymX(i),SymY(j),E,i2)
        end;
    3 : begin   {toggle spots}
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := Ord(S[1]);  Delete(S,1,2);
          i2 := Ord(S[1]);  Delete(S,1,2);
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              ToggleSpot2(SymX(i),SymY(j),E,i1,i2)
        end;
    4 : Message(S);   {print message}
    5 : begin   {alter player stat x1, by ? amount}
          GetSNum(S,Str,x1,Err);
          if S[1] = '-'
            then x2 := -1 else x2 := +1;   {+/- factor}
          Delete(S,1,2);
          GetSNum(S,Str, N,Err);
          N := N * x2;
          case x1 of
            1 : Inc(IncScore,N);
            2 : Inc(P.Health,N);
            3 : Inc(P.Sword,N);
            4 : Inc(P.Magic,N);
            5 : Inc(P.SKeys,N);
            6 : Inc(P.BKeys,N);
            7 : Inc(P.MKeys,N);
            8 : Inc(P.SwordPower,N)
          end {case};
          UpdateStats
        end;
    6 : begin   {sound}
          GetSNum(S,Str, x1,Err);  {start freq}
          GetSNum(S,Str, x2,Err);  {end freq}
          GetSNum(S,Str, N,Err);   {step}
          GetSNum(S,Str, E,Err);   {delay}
          i := x1;
          if x2 > x1
            then while i <= x2 do
                   begin
                     PSound(i,E);
                     Inc(i,N)
                   end
            else while i >= x2 do
                   begin
                     PSound(i,E);
                     Dec(i,N)
                   end
        end;
    7 : begin    {branch to line}
          C1 := S[1];  J1 := S[2];
          C2 := S[3];  J2 := S[4];
          Delete(S,1,4);  {remove letters}
          if OPMessage(S,C1 + C2) = C1
            then Jump := Ord(J1) - 65
            else Jump := Ord(J2) - 65
        end;
    8 : begin    {jump to line}
          C1 := S[1];
          Jump := Ord(C1) - 65
        end;
  end  {item type}
end;

Procedure DoSpecial(Spec : SpecRec; Ch : byte);
  {* Activates special item (1 - 9)}
var Trav : SpecItemPtr;
    c, Jump : integer;

begin
  with Spec do
    begin
      if IType = SUse {activates once}
        then begin
               Level[P.x,P.y] := BLANK;
               P.OnItem := BLANK
             end;
      if MoveOn = 1   {YES}
        then begin
          P.OnItem := Ch;
          PrintMan
        end
        else MB;
      Trav := Item;
      while Trav <> nil do  {execute actions}
        begin
          DoSpecAction(Trav^.Data,Jump);
          if Jump <> -1
            then begin
                   Trav := Item;
                   for c := 1 to Jump do
                     begin
                       if Trav <> nil
                         then Trav := Trav^.next
                     end
                 end  {jump}
            else Trav := Trav^.next  {go to next action}
        end {while}
    end;  {with Spec}
  if Level[P.x,P.y] <> Ch
    then CheckPos         {player's spot has changed - check again}
end;

{-------------------------------------------------------}

Procedure CheckPos;
  {* Status of player's location on board - action taken}
var  Spot : byte; Res : boolean;

begin
  Spot := Level[P.x,P.y];
  case Spot of
    BLANK,Dirt : begin
            P.OnItem := Spot;
            PrintMan;
            if GoKey <> 0 then FootFalls   {no sound when falling}
          end;
    BW1..DownSW, LetterWall : DoWalls(Spot);
    NoMove1 : begin               {monster no-move spot (removeable)}
            Level[P.x,P.y] := BLANK;  P.OnItem := BLANK;
            PrintMan;
            FootFalls
          end;
    NoMove2 : begin               {connected monster no-move spots}
            P.OnItem := BLANK;
            PrintMan;
            FootFalls;
            RemNoMoveSpots(P.x,P.y)
          end;
    NoMove3, NoMove4 : begin      {monster no-move spot (non-removeable)}
            P.OnItem := Spot;
            PrintMan;
            FootFalls
          end;
    InvSolidW   : DoInvSolidW;    {inv. wall}
    InvBW1      : DoInvBW1;       {inv. crumbled wall}
    InvWTrap    : DoInvWTrap;     {invisible walls trap}
    Tree        : DoTree;         {tree}
    Rock        : DoRock;         {immovable boulder}
    Forest      : DoForest;       {forest}
    DenseForest : DoDenseForest;  {dense forest}
    Lava        : DoLava;         {hot lava}
    Water       : DoWater;        {water}
    DeepWater   : DoDeepWater;    {deep water}
    Ice, DeepIce : DoIce;         {ice/deep ice}
    ForceField  : DoForceField;   {force field}
    HotSpot     : DoHotSpot;      {hot spot}
    StickySpot  : DoStickySpot;   {sticky spot}
    Pit         : DoPit;          {pit}
    Tunnel      : DoTunnel(Tunnel);  {tunnel}
    InvTunnel   : DoInvTunnel;    {invisible tunnel}
    HealthGem..InvHGem : DoHGem(Spot);  {health gem}
    PowerGem..InvPGem  : DoPGem(Spot);  {power gem}
    MScroll     : DoMScroll;      {magic}
    StoneKey    : DoStoneKey;     {stone key}
    StoneDoor   : DoStoneDoor;    {locked stone door}
    InvSDoor    : DoInvSDoor;     {inv. locked stone door}
    BronzeKey   : DoBronzeKey;    {bronze key}
    BronzeDoor  : DoBronzeDoor;   {locked bronze door}
    InvBDoor    : DoInvBDoor;     {inv. locked bronze door}
    MagicKey    : DoMagicKey;     {magic key}
    MagicDoor   : DoMagicDoor;    {magic door}
    GoldNugget  : DoGoldNugget;   {treasure}
    InvPotion1  : DoInvPotion1;   {blindness potion}
    InvPotion2  : DoInvPotion2;   {animal vision}
    Boulder     : PushBoulder;    {boulder}
    PushBlock   : DoPushBlock;    {moveable block}
    TeleTrap    : DoTeleTrap;     {teleport trap}
    WarpTrap    : DoWarpTrap;     {warp trap}
    BuryGems    : DoBuryGems;     {bury gems}
    UnearthGems : DoUnearthGems;  {unearth gems}
    RevealGems  : DoRevealGems;   {reveal gems}
    HideGems    : DoHideGems;     {hide gems}
    Freeze      : DoFreeze;       {freeze monsters}
    Slow        : DoSlow;         {slow monsters}
    Haste       : DoHaste;        {haste monsters}
    MagicSpear  : DoMagicSpear;   {magic spear - right}
    MagicBomb   : DoMagicBomb;    {magic bomb}
    Lantern     : DoLantern;      {lantern}
    PowerUp     : SwordPowerUp;   {sword power-up}
    MonsterZap  : DoMonsterZap;   {monster zap}
    MonsterMake : CreateMonsters; {create monster trap}
    Surround    : DoSurround;     {Surround}
    TChest      : DoChest;        {treasure chest}
    LTChest     : DoLockedChest;  {locked treasure chest}
    GemPouch    : DoGemPouch;     {gem pouch}
    Rope        : DoRope;         {rope}
    GreasedRope : DoGreasedRope;  {greased rope}
    AntiGravity : DoAntiGravity;  {reverse gravity}
    UpStairs    : DoUpStairs;     {up stairs}
    DownStairs  : DoDownStairs;   {down stairs}
    Chute       : DoChute;        {chute down}
    PortalTo    : DoPortalTo(PFrom);       {portal to ...}
    PortalFrom  : DoPortalTo(PTo);         {portal form ...}
    RopeExtend  : DoRopeExtend(Custom[P.x,P.y]);   {rope extend}
    Raft        : DoRaft;         {raft}
    KStatue : begin               {killer statue}
      MB;  Thump;
      PrintMessage(61)
    end;
    MonZap : begin                {adjacent monster zapper - turn on/off}
            TurnOn(P.x,P.y,Res);
            if Res = On then Whoop else DownWhoop;
            MB;
            PrintMessage(63)
          end;
    MonGen : begin                {adjacent monster generator}
            MB;  Thump;
            PrintMessage(64)
          end;
    RMonZap : begin               {random monster zapper - turn on/off}
            TurnOn(P.x,P.y,Res);
            if Res = On then Whoop else DownWhoop;
            MB;
            PrintMessage(65)
          end;
    RMonGen : begin               {random monster generator}
            MB;  Thump;
            PrintMessage(66)
          end;
    Special1..Special9 : DoSpecial(Specials[Spot - 139],Spot);
                                  {level specials (1 - 9)}

    M1a..G3  : TouchMonster;  {monsters}
    MW1..FB3 : TouchMvgObj;  {moving objects}
  end {Spot case}
end; {CheckPos}

Procedure DrawStatusBar;
  {* Draws status area and message bar on screen}
var i : integer;

begin
  TextAttr := Black;   {clears screen areas}
  Window(1,1,80,25);
  ClrScr;
  TextAttr := LightCyan + Blue * 16;
  Window(1,25,64,25);
  ClrScr;
  Window(65,1,80,25);
  ClrScr;
  Writeln('  THE ''MERICAN');
  Writeln('    ADVENTURE');
  Writeln('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');

  TextAttr := LightGray * 16;    {clears status windows}
  for i := 5 to 15 do
    if (i mod 2) = 1
      then begin
        Window(67,i,78,i);
        ClrScr
      end;

  TextAttr := White + Blue * 16;   {writes status names}
  Window(1,1,80,25);
  GotoXY(71,4);   Write('Score');
  GotoXY(71,6);   Write('Level');   {beam/jump/magics - different games?}
  GotoXY(70,8);   Write('Health');          {can't put TOO much into any}
  GotoXY(71,10);  Write('Sword');                 {one of them, ya know!}
  GotoXY(70,12);  Write('Scrolls');
  GotoXY(69,14);
  TextColor(LightGray);  Write('?');
  TextColor(LightRed);   Write('  ?');
  TextColor(Yellow);     Write('  ?);

  TextAttr := LightMagenta + Blue * 16;   {prints options available}
  GotoXY(65,17);  Write('  GAME OPTIONS');
  TextAttr := Yellow + Blue * 16;
  GotoXY(65,18);  Write('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');

  TextAttr := White + Blue * 16;
  GotoXY(68,19);  Write('S');
  GotoXY(74,19);  Write('M');
  GotoXY(68,20);  Write('P');
  GotoXY(68,21);  Write('N');
  GotoXY(68,22);  Write('F2');
  GotoXY(68,23);  Write('F3');
  GotoXY(68,24);  Write('Q');

  TextAttr := LightGray + Blue * 16;
  GotoXY(69,19);  Write('word/');
  GotoXY(75,19);  Write('agic');
  GotoXY(69,20);  Write('ause');
  GotoXY(69,21);  Write('oise: ');
  if WaveOn then Write('Full')
    else if Noise then Write('On') else Write('Off');
  GotoXY(71,22);  Write('Save');
  GotoXY(71,23);  Write('Restore');
  GotoXY(69,24);  Write('uit')
end;

Procedure Init;
{* Initialize variables for game}
var TempF : file of LevelRec;  {create temp data file for game play}

begin
  New(HeadMonster);     {head monster begins list of monsters - is not used}
  with HeadMonster^ do
    begin
      x := -1;  y := -1;  {before top-left corner of screen}
      MT := Standard;   {standard monster}
      prev := nil;      {empty list after first record}
      next := nil       {nothing EVER comes BEFORE this record in the list!}
    end;
  New(HeadMvgObj);      {head moving object begins mvg. obj. list - not used}
  with HeadMvgObj^ do
    begin
      x := -1;  y := -1;
      MT := MovingWall;
      prev := nil;
      next := nil
    end;
  New(HeadItem);        {head item begins item list - not used}
  with HeadItem^ do
    begin
      x := -1;  y := -1;
      IT := Switching;
      prev := nil;
      next := nil
    end;

  BigSecret := FALSE;
  ExitGame := FALSE;
  Moves := 0;
  with P do
  begin
    Score := 0;
    Oxygen := 75;
    if PlayTest
      then begin
             Health := 250;  Sword := 100;  Magic := 50;
             SKeys := 9;    BKeys := 9;  MKeys := 9;
             SwordPower := 1;
           end
      else begin
             GetSkill(Health,20,15,10);  Sword := 0;  Magic := 0;
             SKeys := 0;    BKeys := 0;  MKeys := 0;
             SwordPower := 0;  LevelNum := 1;
           end;
    ox := 1;  oy := 1;
    x := 1;   y := 1;
    OnItem := BLANK;
    Color := Yellow;
    Chr := #2
  end;

  for i := 0 to NumOfLevels do       {reset level bonuses}
    Exited[i] := FALSE;
  BlankTime := 0;
  InvisTime := 0;
  FreezeTime := 0;
  SlowTime := 0;
  HasteTime := 0;
  g := 1;

  DLevel.Alg := DrawPos;   {procedure DrawPos is used to draw levels}

  Assign(LevelF,DataFile + '.tmp');   {temporary level file used during play}
  ReWrite(LevelF);
  Assign(TempF,DataFile + '.lvl');   {permanent data file holding level maps}
  Reset(TempF);
  Assign(ScoreF,DataFile + '.hs');
  for i := 0 to NumOfLevels do   {copy level data to run-time file}
    begin
      Read(TempF,LevelInfo);
      Write(LevelF,LevelInfo)
    end;
  Close(TempF)
end;

Procedure MonstersFall(var g : integer);   {g = direction of gravity}
  {* Monsters fall down one space on side-view levels}
var  Hold, Trav : Monster;

begin
  Trav := HeadMonster^.next;
  while Trav <> nil do  {check all monsters}
    with Trav^ do
      begin
        if (x >= 1) and (x <= 64) and (y >= 1) and (y <= 24) and
           ((g = 1) and (y < 24)) or ((g = -1) and (y > 1))
           then if (Trav^.MT <> Wizard)               {wizards float}
               and (not (Level[x,y + g] in StandItems + MonsterStand))
                 then begin                          {monster falls}
                        Level[x,y] := OnItem;
                        DrawPos(x,y);
                        Inc(y,g);
                        if (Level[x,y] in [Lava..DeepWater])
                          then begin  {monster perishes}
                                 Dec(y);
                                 Hold := Trav^.prev; {need this?}
                                 ZapMonster(x,y);
                                 Trav := Hold        {or this?}
                               end
                          else begin  {monster falls/eats item}
                                 if not (Level[x,y] in StepItems)
                                   then Click1;
                                 if Level[x,y] in FlashItems+MorphItems
                                   then ZapItem(x,y);
                                 OnItem := BLANK;
                                 Level[x,y] := Species;
                                 DrawMonster(x,y,0)
                               end
                      end;
        Trav := next
      end {with Trav^}
end;

Procedure PlayerFalls(var g : integer);   {g = direction of gravity}
  {* Player falls down one space on side-view levels}
begin
  if ((g = 1) and (P.y < 24)) or ((g = -1) and (P.y > 1))
    then begin
           MU;
           if not (Level[P.x,P.y] in [Rope..GreasedRope,Water])
           and (P.OnItem <> Raft)
             then Inc(P.y,g);   {if man is not holding onto Rope or in Water}
           GoKey := 0;    {no direction}
           if (Level[P.x,P.y] in StandItems)
           or ((Level[P.x,P.y] in InvStandItems) and (Custom[P.x,P.y] = 1))
             then MB        {player can stand on item}
             else begin
                    DrawPos(P.ox,P.oy);
                    CheckPos  {player falls onto item}
                  end
         end
end;

Procedure Interact(var Item : byte);
{Item player is standing on has certain effect on him}
begin
  if FreezeTime > 0 then Dec(FreezeTime);
  if SlowTime > 0 then Dec(SlowTime);
  if HasteTime > 0 then Dec(HasteTime);
  if BlankTime > 0
    then begin
           Dec(BlankTime);
           if (BlankTime = 0) and (LData.View in [Top,Side])
             then DrawLevel(1,1,64,24)  {level reappears}
         end
    else case LData.View of
           TopDark, SideDark : begin    {light around player}
             FillWindowWithHole(1,1,64,24, P.x - 3,P.y - 2,P.x + 3,P.y + 2, #255, DarkGray);
             DrawLevel(P.x - 3,P.y - 2,P.x + 3,P.y + 2)
           end
         end;
  case Item of
    Ice..DeepIce : if (Moves mod 5) = 0
            then begin
                   MU;
                   P.Color := Yellow;  P.Chr := #2;
                   MoveMan;
                   if BoundCheck then CheckPos
                 end;
    Lava : if (Moves mod 3) = 0
           then begin
                  Click1;
                  Dec(P.Health);  UpdateStats;
                  P.Color := LightRed + Red * 16;  P.Chr := #1
                end
           else P.Color := Yellow + Red * 16;
    Water : if (LData.View in [Side..SideDark])
             then if P.Oxygen > 0
               then Dec(P.Oxygen)
               else begin  {drowning}
                      P.Color := LightCyan + Blue * 16 + Blink;
                      P.Chr := #1;
                      if (Random(6) = 0)
                        then begin
                               Dec(P.Health);  UpdateStats;
                               PSound(2000,10);  NoSound
                             end;
                     PrintMessage(40)
                   end;
    DeepWater : if P.Oxygen > 0
              then Dec(P.Oxygen)
              else begin  {drowning}
                     P.Color := LightGreen + Blue * 16 + Blink;
                     P.Chr := #1;
                     if (Random(3) = 0)
                       then begin
                              Dec(P.Health);  UpdateStats;
                              PSound(2000,10);  NoSound
                            end;
                     PrintMessage(40)
                   end;
    Raft : begin
             P.Color := LightMagenta + Blue * 16;
             P.Chr := #4
           end;
    GreasedRope : if (Moves mod 7) = 0
           then begin
                  Level[P.x,P.y] := BLANK;
                  i := P.x;  j := P.y;
                  PlayerFalls(g);        {slides down rope}
                  Level[i,j] := GreasedRope
                end;
    HotSpot : if (Moves mod 5) = 0
           then begin
                  Click1;
                  Dec(P.Health);  UpdateStats;
                  P.Color := LightRed;  P.Chr := #1
                end
           else P.Color := Red;
    StickySpot : if (Moves mod 4) <> 0
           then begin
                  FreezeTime := 0;
                  SlowTime := 0;
                  Inc(HasteTime,8)
                end;
    Pit : P.Color := 0;
  else begin   {normal}
         P.Color := Yellow;  P.Chr := #2;  P.Oxygen := 75
       end
  end;  {Item case}
  if InvisTime > 0
    then begin
           Dec(InvisTime);
           case P.OnItem of
             Water..DeepWater, Raft : P.Color := Blue + Blue * 16;
             Ice..DeepIce : P.Color := Cyan + LightGray * 16;
             else P.Color := 0
           end
         end;
  PrintMan
end;

Procedure GameLoop;
{Actual game play happens here!}
begin
  repeat      {x,y,MSpec,MType,Stat1,Stat2}
    Inc(Moves);
    SetNumLock(OFF);
    if IncScore <> 0
      then ModScore(IncScore);
    if (LData.View in [Side,SideDark])
     then if ((Moves mod 3) = 0)
      then begin
             MonstersFall(g);  {gravity pulls monsters up/down}
             PlayerFalls(g)    {gravity pulls player up/down}
           end;
    if KeyPressed
      then begin
             GetKeyPress;      {player moves}
             Action
           end;
    Interact(P.OnItem);
    if LevelNum > 25           {finished all 25 levels -- player wins}
      then begin
        GameOver(WINS);
        FreezeTime := 100;
      end;
    if FreezeTime <= 0         {monsters move (if not frozen)}
      then begin
        MoveMonsters;
        MoveMvgObjs;
        MoveItems;             {special item effects...}
      end;
    if P.Health < 0            {no health -- player has perished}
      then GameOver(DIES);
    Delay(TurnDelay)
  until ExitGame
end;

Procedure TitleScreen;
  {* Displays title screen and flashes name "The Merican Adventure"}

 Procedure FlashTitle;
 const Title1 : string =
   '‹€  €€?   €€? €€€€€€? €€€€€€   €€   €€€€€€   €€€€?  €€?   €€' +
   '?  €€€€  €€€€  €€       €€   €€  €€  €€       €€   €€  €€€€   €€' +
   '    €€ €€€€ €€  €€€€?   €€€€€€   €€  €€       €€€€€€? €€ €€  €€';
       Title2 : string =
   '    €€  €€  €€  €€       €€   €€  €€  €€       €€   €€  €€  €€ €€' +
   '    €€      €€  €€€€€€? €€   €€  €€   €€€€€€  €€   €€  €€   €€€€';
 begin
   repeat
     TextAttr := Random(15) + 1;
   until TextAttr in [Yellow,White];
   GotoXY(8,7);
   for x := 1 to 195 do
     begin
       if Title1[x] = ' '
         then GotoXY(WhereX + 1,WhereY) else Write(Title1[x]);
       if WhereX > 72 then GotoXY(8,WhereY + 1)
     end;
   for x := 1 to 130 do
     begin
       if Title2[x] = ' '
         then GotoXY(WhereX + 1,WhereY) else Write(Title2[x]);
       if WhereX > 72 then GotoXY(8,WhereY + 1)
     end;
   Delay(15)
 end;  {FlashTitle}

begin  {TitleScreen}
  Exec('Merican.Tit','');
  if WaveOn
    then PlayWav('cyclone.wav')
    else begin
           PSound(300,100);  PSound(200,100);  PSound(100,100);  NoSound
         end;
  repeat FlashTitle until KeyPressed;
  PSound(100,80);  PSound(300,80);  PSound(500,80);
  PSound(700,80);  PSound(900,80);  NoSound
end;  {TitleScreen}

Procedure AboutMerVntr;
begin
  SetBorder(White);
  TextAttr := Yellow + Blue * 16;
  Window(1,1,80,25);
  ClrScr;
  GotoXY(30,2);
  Writeln('ABOUT THE ''MERICAN ADVENTURE');
  GotoXY(30,3);
  Writeln('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
  Window(7,5,80,25);
  TextAttr := White + Blue * 16;

  Writeln('   "The ''Merican Adventure"  was inspired by the KROZ series.    It');
  Writeln('was developed in Turbo Pascal 7.0,  requiring 13,000 lines and over');
  Writeln('360K of source code.  Over 250 hours were spent coding the game and');
  Writeln('designing levels.   Dozens more were spent play-testing to work out');
  Writeln('bugs.   Special thanks go to Marcus Snyder and Robert Laatsch,  who');
  Writeln('gave countless helpful ideas that have made  this third installment');
  Writeln('in the ''Merican series many times better than the last!');
  Writeln('   New features included are:  new Dark level formats, more monster');
  Writeln('types and  dozens of new creatures,  new sounds and visual effects,');
  Writeln('(including digitized music) and scores of new objects to discover!');
  Writeln;
  Writeln('   Although challenging,  this game is possible to beat!  The games');
  Writeln('I enjoy most  contain  puzzles,  strategy  and  adventure,  so many');
  Writeln('levels in ADVENTURE involve thinking and may take a few attempts to');
  Writeln('solve (such as "The Crypt Trilogy") -- but you can do it. On Expert');
  Writeln('I have completed the game with about 500 health, 65 power, 16 magic');
  Writeln('9 keys remaining (my final score was about 125,000).');
  Writeln('   So, Good Luck, hardy explorer, your Adventure awaits!');
  Window(1,1,80,25);
  BlueMessage('Press any key to continue...');

  TextAttr := Yellow + Blue * 16;
  Window(1,1,80,25);
  ClrScr;
  GotoXY(35,2);
  Writeln('MISCELLANEOUS');
  GotoXY(35,3);
  Writeln('ƒƒƒƒƒƒƒƒƒƒƒƒ?);
  Window(7,5,80,25);
  TextAttr := White + Blue * 16;

  Writeln('  "The ''Merican Adventure" is shareware - if you enjoy this game, a');
  Writeln('gift  of $10 to $20  to Adventia  would be appreciated  (send check');
  Writeln('or money order).  Your payment entitles you to receive notification');
  Writeln('of further volumes in the "Merican" series as they are designed, as');
  Writeln('well as of other future games created by Adventia.');
  Writeln('   Comments or questions  about any of the games in this series are');
  Writeln('also encouraged.   I would appreciate  the feedback which you,  the');
  Writeln('player, have to offer, such as pointing out any bugs found  (though');
  Writeln('I have tried to  make these games  error-free before  distribution)');
  Writeln('and  your ideas for  future games.   My imagination  is the driving');
  Writeln('force  behind these games,  but their continued growth also depends');
  Writeln('on the ideas of others.  All flashes of genius are welcome!');
  Writeln;
  Writeln('Send payments or comments to:  Adventia Software');
  Writeln('                               ');
  Writeln('                               ');
  Writeln;
  Writeln('  Have fun with the game, and thanks for playing! -- Michael Rimer');
  Window(1,1,80,25);
  BlueMessage('Press any key to continue...')
end;

Procedure Instructions;
begin
  Window(1,1,80,25);
  TextAttr := Yellow + Blue * 16;
  ClrScr;
  GotoXY(33,1);
  Writeln('THE STORY SO FAR...');
  GotoXY(33,2);
  Writeln('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ?);
  Writeln;
  TextAttr := White + Blue * 16;

  Writeln('   Over the past year you have been noted by some as a "dubious expert" on');
  Writeln(' the lost race of the ''MERICANS.  You had grown up hearing stories and legends');
  Writeln(' of their ancient wisdom and splendour...but had not believed in them until');
  Writeln(' finding a series of ancient catacombs containing the ''Mericans'' sacred');
  Writeln(' Talisman.  Nobles from many lands offered you a small fortune for the relic.');
  Writeln('   Keeping the Talisman was the best decision of your life...or the worst.');
  Writeln(' Its rediscovery inspired you to set out to rediscover the lost ''Merican');
  Writeln(' civilization.  Its guiding hand led you across the globe into their forgotten');
  Writeln(' realm to find a deserted city preserved over the ages by a power unknown.');
  Writeln(' In a magical chamber deep underground you unlocked the powers of the Talisman.');
  Writeln(' Barely escaping to the surface with your life, you were privileged only by');
  Writeln(' seeing the entire city vanish into thin air...stranger and stranger!');
  Writeln('   After being captured by a horde of vile creatures, you managed to escape');
  Writeln(' to a remote island.  Here, you met an old man which guided you to search for');
  Writeln(' a Book forged by the ''Mericans which contained much power and light.');
  Writeln(' Finding and reading this book, you gleaned much knowledge of the lost people.');
  Writeln(' For one, that they may still exist!  Those words have only burned indelibly');
  Writeln(' into your mind, forcing you to return to the Island in an attempt to unlock');
  Writeln(' the secret of the ''Merican civilization, once and for all...');
  Writeln('   Good luck, adventurer!  The adventure awaits!');
  BlueMessage('Press any key to continue...');

  ClrScr;
  TextAttr := Yellow + Blue * 16;
  GotoXY(35,1);  Write  ('INSTRUCTIONS');
  GotoXY(35,2);  Writeln('ƒƒƒƒƒƒƒƒƒƒƒƒ');
  TextAttr := White + Blue * 16;
  Writeln;
  Writeln('    This game is one of exploration and strategy.  You must find your way');
  Writeln('  through 25 dangerous areas, and will probably not make it through alive!');
  Writeln('  There are many objects you will encounter along your way.  The effect of');
  Writeln('  some will be obvious, but more mysterious things are also left for you to');
  Writeln('  find.  You will come across hordes of bloodthirsty monsters, as well as a');
  Writeln('  few helpful creatures, too...');
  Writeln('    Through the course of your adventure, you can find many magical gems.');
  Writeln('  Finding these gems can increase your strength and vitality, and is necessary');
  Writeln('  in order to stay alive!  When you are attacked by a creature, you will be');
  Writeln('  injured, requiring you to use a few of your health gems to restore your');
  Writeln('  vitality.  (Some monsters are more deadly than others, and will remove more');
  Writeln('  of your health.)  If you have no gems left when a monster attacks you, you');
  Writeln('  will instead lose your life!  Power gems will give you the strength to defeat');
  Writeln('  the monsters adjacent to you (press "S" to use one), as well as endowing you');
  Writeln('  with the ability to smash through some of the weaker walls and terrain.');
  Writeln('    You control your man ( ) by using the cursor pad on the right side of your');
  SCol(35,17,Yellow + Blue * 16);
  SC(27,19,#2,Yellow + Blue * 16);
  Writeln('  keyboard.  You can move in any of the four cardinal directions, as well as');
  Writeln('  diagonally.  Most scenes are viewed from above.  Some are played from the');
  Writeln('  side, where you are affected by a strong gravity (falling from large heights');
  Writeln('  will not harm you).  Others allow only a limited view of the entire area.');
  BlueMessage('Press any key to continue...');

  ClrScr;
  TextAttr := Yellow + Blue * 16;
  GotoXY(34,1);  Write  ('HELPFUL HINTS');
  GotoXY(34,2);  Writeln('ƒƒƒƒƒƒƒƒƒƒƒƒ?);
  TextAttr := White + Blue * 16;
  Writeln;
  Writeln('  ˛ When you touch an item for the first time, a message describing it will be');
  Writeln('  shown.  Pay attention: these messages will help you identify the new object,');
  Writeln('  but it is up to you to decide whether to use it in the future or to leave it');
  Writeln('  alone.  If you become tired of seeing these descriptions every time you come');
  Writeln('  across a new item, most of them may be turned off using the minus (-) key.');
  Writeln('  You may reset all messages so they appear again with the plus (+) key.');
  Writeln;
  Writeln('  ˛ You are able to Save your game in any of nine slots (which you may name).');
  Writeln('  It is usually a good idea to save game at each new level you come to.  This');
  Writeln('  way, if you take a wrong turn or have a stroke of bad luck you can easily');
  Writeln('  Restore where you saved and try, try again.');
  SCol(21,11,Yellow + Blue * 16);
  SCol(3,14,Yellow + Blue * 16);
  Writeln;
  Writeln('  ˛ There are many puzzles to solve in this game, as well as dozens of');
  Writeln('  mysterious objects to find, and even some bizarre twists.  The best way to');
  Writeln('  determine what an unknown item will do is to touch it and read the message');
  Writeln('  displayed at the bottom of the screen.  Pay close attention!');
  Writeln;
  Writeln('  ˛ Don''t forget that your man can move diagonally!  This is useful for');
  Writeln('  entering rooms with only a crack in the wall, or to swiftly evade monsters.');
  BlueMessage('Press any key to continue...');

  ClrScr;
  TextAttr := Yellow + Blue * 16;
  GotoXY(33,1);  Write  ('HELPFUL HINTS 2');
  GotoXY(33,2);  Writeln('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ?);
  TextAttr := White + Blue * 16;
  Writeln;
  Writeln('  ˛ You can only use your sword a limited number of times.  Grab power gems to');
  Writeln('  increase this number.  You can use your sword to fight monsters, but often a');
  Writeln('  better idea is to evade the monsters or run away.  Use strategy and tactics!');
  Writeln;
  Writeln('  ˛ Monsters move straight toward you.  They will get stuck if something is in');
  Writeln('  their way.  Some are smarter, and others have special movement patterns.');
  Writeln;
  Writeln('  ˛ Most monsters will die when they run into crumbled walls.');
  Writeln('  Guide monsters into broken walls to eliminate them and clear your path.');
  Writeln;
  Writeln('  ˛ Some things, both good and bad, are invisible.  Look in specially marked');
  Writeln('  or suspicious nooks and crannies for secrets.  They can help you a lot.');
  Writeln;
  Writeln('  ˛ Here are some of the things you will encounter along your way...');
  Writeln;
  Writeln('     health gems       stairs up/down      broken walls');
  Writeln('     power gems        obstacles           shallow/deep water');
  Writeln('        weak monsters (take 1 hit)         keys');
  Writeln('        stronger monsters  (2 hits)        locked doors');
  Writeln('        tough monsters     (3 hits)        treasures');

  SC(4,19,#4,Yellow + Blue * 16);
  SC(4,20,#9,LightMagenta + Blue * 16);

  SC(20,19,'?,LightBlue + Blue * 16 + Blink);  SC(22,19,'?,LightRed + Blue * 16 + Blink);

  SC(20,20,'?,Brown + Blue * 16); SC(21,20,#6,Green + Blue * 16); SC(22,20,#127,Brown + Blue * 16);

  SC(40,19,'?,Brown + Blue * 16);  SC(41,19,'?,Brown + Blue * 16);  SC(42,19,'?,Brown + Blue * 16);

  SC(40,20,'?,LightBlue + Blue * 16 + Blink); SC(42,20,'?,LightBlue + Blue * 16 + Blink);

  SC(4,21,'Ñ',LightRed + Blue * 16); SC(5,21,'î',LightGreen + Blue * 16); SC(6,21,'?,LightMagenta + Blue * 16);
  SC(4,22,'é',LightRed + Blue * 16); SC(5,22,'ì',LightGreen + Blue * 16); SC(6,22,'ö',LightMagenta + Blue * 16);
  SC(4,23,'è',LightRed + Blue * 16); SC(5,23,'ô',LightGreen + Blue * 16); SC(6,23,'Ä',LightMagenta + Blue * 16);

  SC(40,21,'?,LightGray + Blue * 16); SC(41,21,'?,LightRed + Blue * 16); SC(42,21,'?,Yellow + Blue * 16);
  SC(40,22,'?,LightGray + Blue * 16); SC(41,22,'?,Red + Blue * 16); SC(42,22,'?,Yellow + Blue * 16);
  SC(40,23,#15,Yellow + Blue * 16); SC(41,23,'?,Yellow + Blue * 16); SC(42,23,'?,Yellow + Blue * 16);

  BlueMessage('Press any key to continue...')
end;

Procedure OpScr2;
  {* Choices player may make before playing game}
begin
  SetBorder(0);
  TextAttr := Yellow;  Window(1,1,80,25);  ClrScr;
  GotoXY(29,2);  Write('THE MERICAN ADVENTURE');
  TextAttr := Red;
  GotoXY(22,4);  Write('Copyright (c) 1995 Adventia Software');
  GotoXY(24,6);  Write('Version ',Version:1:2,' -- by Michael Rimer');
  TextAttr := Brown;  GotoXY(5,8);
  Write('THIS GAME MAY BE DISTRIBUTED IN SHAREWARE OR PUBLIC DOMAIN LIBRARIES,');
  GotoXY(9,9);
  Write('ON BBSes OR INTERNET SITES, WHICH IS ENCOURAGED BY THE AUTHOR.');
  GotoXY(20,10);
  Write('PLEASE SHARE IT WITH YOUR FRIENDS, TOO!');
  TextAttr := LightMagenta;  GotoXY(1,11);
  Write('ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
  TextAttr := LightCyan;  Window(20,14,80,25);
  Writeln(' bout "The Merican Adventure"');
  Writeln(' nstructions');
  Write(' ound: ');
  if (not Noise)
    then Writeln('OFF')
    else if (not WaveOn)
           then Writeln('NORMAL')
           else Writeln('ENHANCED');
  Write(' omputer Speed: ');
  case TurnDelay of
    VerySlowGameSpeed : Writeln('VERY SLOW');
    SlowGameSpeed : Writeln('SLOW');
    MedmGameSpeed : Writeln('MEDIUM');
    FastGameSpeed : Writeln('FAST');
    VeryFastGameSpeed : Writeln('VERY FAST')
  end;
  Write(' lay level: ');
  case SkillLevel of
    NOVICE   : Writeln('NOVICE');
    ADVANCED : Writeln('ADVANCED');
    EXPERT   : Writeln('EXPERT')
  end;
  Writeln(' uit game');
  Writeln(' egin the Adventure!');
  TextAttr := Yellow;
  GotoXY(1,1);
  Writeln('A');
  Writeln('I');
  Writeln('S');
  Writeln('C');
  Writeln('P');
  Writeln('Q');
  Writeln('B');
  Writeln;  Writeln;
  TextAttr := LightRed;  Window(18,21,80,25);
  Write('Enter your choice? (A,I,T,C,S,Q,B) [B]?');
  TextAttr := LightRed + Blink;  Write('?);
  RemKeys;
  repeat
    Ch := UpCase(ReadKey)
  until (Ch in ['A','I','S','C','P','Q','B',' ',#13,#27]);
  case Ch of
    'A' : AboutMerVntr;
    'I' : Instructions;
    'S' : if WaveOn   {sound toggles}
            then begin
                   Noise := FALSE;
                   WaveOn := FALSE
                 end
            else if Noise
                   then WaveOn := TRUE
                   else Noise := TRUE;
    'C' : case TurnDelay of
            VerySlowGameSpeed : TurnDelay := SlowGameSpeed;
            SlowGameSpeed : TurnDelay := MedmGameSpeed;
            MedmGameSpeed : TurnDelay := FastGameSpeed;
            FastGameSpeed : TurnDelay := VeryFastGameSpeed;
            VeryFastGameSpeed : TurnDelay := VerySlowGameSpeed;
          end;
    'P' : case SkillLevel of
            NOVICE   : SkillLevel := ADVANCED;
            ADVANCED : SkillLevel := EXPERT;
            EXPERT   : SkillLevel := NOVICE
          end;
    'B',' ',#13 : {Eerie};  {start the game}
    else {Quit game}
  end {Ch case}
end;

Procedure OptionScreen;
  {* Allows player to specify game settings before play}
begin
  if (not PlayTest)
    then repeat OpScr2 until (Ch in ['B','Q',' ',#13,#27]);
  if (Ch in ['Q',#27])
    then begin   {quit game}
           ExitGame := TRUE;  ExitProg := TRUE;  Done
         end;

  if PlayTest or (SkillLevel = ADVANCED)
    then for i := 0 to NumOfMessages do      {messages OFF}
           Messages[i] := FALSE
    else for i := 0 to NumOfMessages do      {set messages ON}
           Messages[i] := TRUE;

  DrawStatusBar;
  IncScore := 0;
  LoadLevel(0,LevelNum,DOWN)   {save junk to Level 0}
end;

Procedure GetParams;
  {* Get game settings, program parameters, debug/playtest commands}
type DataRec = record
                 TurnDelay, SkillLevel : integer;
                 Noise, WaveOn : boolean;
               end;
var Num, Err : integer;
    Data     : DataRec;
    DataF    : file of DataRec;

begin
  Assign(DataF,'vntr.dat');
  {$I-}  Reset(DataF);  {$I+}
  if IOResult <> 0   {no file exists - set defaults}
    then begin
           TurnDelay := SlowGameSpeed;   {slow computer}
           SkillLevel := NOVICE;
           Noise := TRUE;
           WaveOn := FALSE;
         end
    else begin       {read game settings}
           Read(DataF,Data);
           Close(DataF);
           TurnDelay := Data.TurnDelay;
           SkillLevel := Data.SkillLevel;
           Noise := Data.Noise;
           WaveOn := Data.WaveOn
         end;
{*} DELAY_LENGTH := 10000; {set/recalibrate? .wav file sound delay}

  MASTER := FALSE;   {MER debug mode}
  LevelNum := 1;     {beginning level}
  PlayTest := FALSE;   {playtest mode}
  DataFile := 'vntr';  {name of level data files}
  for i := 1 to ParamCount do
    begin
      TextAttr := White;
      Val(ParamStr(i),Num,Err);
      if Err = 0
        then case Num of
                  -1 : PlayTest := TRUE;
               1..25 : LevelNum := Num;  {level to start on}
             end
        else if ParamStr(i) = '-mer'
               then MASTER := TRUE
               else DataFile := ParamStr(i);  {data files named ParamStr(i)}
    end;
end;

Begin   (* MAIN PROGRAM *)
  Randomize;
  ExitProg := FALSE;
  GetParams;
  CursorOff;
  if not PlayTest
    then TitleScreen;
  ClrScr;
  Exec('vntrfont.com','');
  CursorOff;
  BlinkOn;
  repeat
    Init;
    OptionScreen;
    GameLoop;
  until ExitProg;
  Done
End.  {MericanAdventure}
