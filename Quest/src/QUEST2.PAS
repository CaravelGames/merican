Unit Quest2;   {created by Michael Rimer}
               {begun January 10, 1994}

{title screen/instruction procedures for game}

(***) Interface (***)

Uses Sounds, Crt, MerCrt, CrtEXTRA;

(****************)

const  NOVICE   = 0;     {skill levels}
       ADVANCED = 1;
       EXPERT   = 2;
       Version  = 1.00;  {game version}
       MaxDemoMoves = 370;

{*}  DemoKeyArray : array[1..MaxDemoMoves] of byte = (
     0,0,0,0,0,0,0,0,0,0, 0,0,0,0,4,4,4,9,6,6, 6,6,3,1,4,4,2,2,2,2,
     2,2,2,2,2,2,2,0,0,0, 4,3,9,7,8,8,8,8,8,8, 0,0,9,9,9,9,9,6,6,6,
     6,6,6,6,6,6,6,6,6,0, 0,0,8,8,8,2,2,2,2,2, 2,0,0,8,8,8,8,8,8,8,
     8,8,2,2,2,2,3,6,6,6, 6,6,6,6,9,9,8,8,9,6, 6,6,6,6,6,1,1,1,2,2,
     0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,
     0,0,0,2,2,2,2,2,2,2, 2,2,2,2,0,0,0,0,0,0, 0,4,4,4,4,4,4,4,4,4,
     4,4,4,4,4,4,4,4,4,4, 4,4,4,4,4,0,0,2,2,2, 6,6,6,6,6,6,6,3,6,6,
     6,9,9,8,8,8,0,0,0,0, 0,0,0,4,4,4,4,4,4,4, 4,4,7,8,8,8,7,4,4,4,
     4,7,1,2,1,2,1,7,4,7, 8,8,8,2,2,2,3,6,6,6, 9,8,8,8,8,6,6,6,6,3,
     2,3,6,6,6,6,6,6,9,9, 8,9,6,6,6,3,2,2,0,10, 0,2,2,0,10,0,2,2,0,10,
     0,2,2,0,10,0,2,2,2,2, 2,2,2,1,4,4,4,8,8,8, 8,8,1,10,1,4,4,4,4,4,
     4,4,1,1,1,1,1,1,4,4, 4,4,4,4,0,0,4,0,0,4, 0,0,4,0,0,4,0,0,4,0,
     0,4,0,0,4,0,7,1,4,4);

var  GameDelay,              {compensates for speed of machine}
     SkillLevel : integer;
     Demo : boolean;         {demonstration mode on/off}
     Ch   : char;


Procedure PrintStatusWindow;
Procedure Instructions;
Procedure TitleScreen;
Procedure TitleOptions;
Procedure Conclusion;

(***) Implementation (***)

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
  GotoXY(70,13);  Write('Scrolls');
  GotoXY(71,16);  Write('Keys');

  TextAttr := LightMagenta + Blue * 16;   {prints options available}
  GotoXY(68,18);  Write('OPTIONS');
  TextAttr := Yellow + Blue * 16;
  GotoXY(68,19);  Write('ÄÄÄÄÄÄÄÄÄÄ');

  TextAttr := White + Blue * 16;     
  if not DEMO
    then begin
      GotoXY(68,20);  Write('H');
      GotoXY(73,20);  Write('M');
      GotoXY(68,21);  Write('P');
      GotoXY(68,22);  Write('N');
      GotoXY(68,23);  Write('S');
      GotoXY(68,24);  Write('R');
    end;
  GotoXY(68,25);  Write('Q');

  TextAttr := LightGray + Blue * 16;
  if not DEMO
    then begin
      GotoXY(69,20);  Write('ack/');
      GotoXY(74,20);  Write('agic');
      GotoXY(69,21);  Write('ause');
      GotoXY(69,22);  Write('oise Off');
      GotoXY(69,23);  Write('ave');
      GotoXY(69,24);  Write('estore');
    end;
  GotoXY(69,25);  Write('uit')
end;

Procedure AboutMerQuest;
  {* Background on design of game}
begin
  SetBorder(White);
  TextAttr := White + Blue * 16;
  Window(1,1,80,25);
  ClrScr;
  GotoXY(34,2);
  Writeln('GAME BACKGROUND');
  GotoXY(34,3);
  Writeln('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?);
  Window(7,5,80,25);

  Writeln('   "The Merican Quest",  designed by Michael Rimer,  was written in');
  Writeln('Turbo Pascal 6.0,  requiring  6000+ lines, in over  200K of  source');
  Writeln('code!   Up to  200 hours  was spent coding the  game and  designing');
  Writeln('levels.   Dozens more were spent play-testing  to work out  all the');
  Writeln('bugs.   Special  thanks go to  Marcus Snyder,  Robert Laatsch,  and');
  Writeln('Vladimir  Frisby,  who gave  scores of  helpful  comments  and died');
  Writeln('countless gruesome deaths to make  this game possible as you see it');
  Writeln('now.  (Their wonderful ideas which I have not used will go into the');
  Writeln('future games in this series.)');
  Writeln('   Additions made in future games will include  more level formats,');
  Writeln('many more  monster types,  several new  sounds and  visual effects,');
  Writeln('and dozens of new objects to discover!');
  Writeln;
  Writeln('   In case any of you are wondering, this game is possible to beat!');
  Writeln('I enjoy games which contain puzzles,  mixed with action.   A few of');
  Writeln('the levels may take a few attempts to solve  (such as "Barriers" or');
  Writeln('"Cubicles - Take Two"), but you can do it.  On the Expert setting I');
  Writeln('have ended Level 25 with 47 health, 116 power,  5 teleports,  and 3');
  Writeln('keys (my final score was 288,615).  Good luck, brave adventurer!');
  Window(1,1,80,25);
  BlueMessage('Press any key to continue...');

  Window(1,1,80,25);
  ClrScr;
  GotoXY(35,2);
  Writeln('MISCELLANEOUS');
  GotoXY(34,3);
  Writeln('ÄÄÄÄÄÄÄÄÄÄÄÄ?);
  Window(7,5,80,25);

  Writeln('   "Merican Quest" is shareware - if you enjoy this game, a payment');
  Writeln('of $5 to $10 to the author would be appreciated  (please send check');
  Writeln('or  money order). Your payment entitles you to receive notification');
  Writeln('of further volumes in the "Merica" series as they are designed,  as');
  Writeln('well as of other future games created by Adventia!');
  Writeln('   Comments or questions  about any of the games in this series are');
  Writeln('also encouraged.   I would appreciate  the feedback which you,  the');
  Writeln('user, have to offer, such as pointing out any bugs found  (though I');
  Writeln('have tried to make these games error-free before distribution)  and');
  Writeln('your ideas for  future games.   My imagination is the driving force');
  Writeln('behind these games,  but their continued growth also depends on the');
  Writeln('ideas of others.  (All flashes of genius are welcome!)');
  Writeln;
  Writeln('Send payments or comments to:  Adventia Software');
  Writeln('                               (address)');
  Writeln('                               (city),(st) (zip)');
  Writeln;
  Writeln('  Have fun with the game, and thank you for playing! -- Mike Rimer');
  Window(1,1,80,25);
  BlueMessage('Press any key to continue...')
end;

Procedure Instructions;
  {* Shows game instructions}
begin
  SetBorder(LightGray);
  TextAttr := White + Blue * 16;
  Window(1,1,80,25);
  ClrScr;
  GotoXY(36,1);  Write  ('THE STORY');
  GotoXY(36,2);  Writeln('ÄÄÄÄÄÄÄÄ?);
  Writeln;
  Writeln('   It was only a year ago when you, a fortune hunter, found a labyrinth made by');
  Writeln(' the lost race of the MERICANS.  You had heard legends of their ancient wisdom');
  Writeln(' and splendour, but had not believed in it until you stumbled onto this maze of');
  Writeln(' catacombs.  From the bottom of these catacombs you retrieved the Mericans''');
  Writeln(' sacred Talisman which, undoubtedly, was worth a small fortune...');
  Writeln('   Just recently you set out to rediscover the lost Merican civilization.');
  Writeln(' Searching through foreign and strange lands, you came upon their forgotten');
  Writeln(' realm, finding a deserted city preserved over the ages by a power unknown.');
  Writeln(' Entering the city with the rising of the sun, you unearthed many of the city''s');
  Writeln(' wonders...and dangers.  Finding a magical chamber deep underground, you were');
  Writeln(' able to unlock the powers of the Talisman.  Suddenly a massive quake occured,');
  Writeln(' from which you barely escaped with your life.  Fleeing to the surface, your');
  Writeln(' first sight was to watch the city vanish with the setting of the sun...');
  Writeln('   Back at your camp that night, your mind wandered, unable to comprehend what');
  Writeln(' took place.  You felt determined to solve the mystery.  In the dark of night,');
  Writeln(' a band of monsters crept up on you.  After a quick fight, you were taken');
  Writeln(' captive and carried into a concealed underground cave.  Their motives are');
  Writeln(' unknown to you, but you dread to think of what could be your fate.  Now you');
  Writeln(' must try to escape, and then find your way back to the surface.');
  Writeln('   Good luck, adventurer!  Your freedom is nigh!');
  BlueMessage('Press any key to continue...');

  ClrScr;
  GotoXY(35,1);  Write  ('INSTRUCTIONS');
  GotoXY(35,2);  Writeln('ÄÄÄÄÄÄÄÄÄÄÄÄ');
  Writeln;
  Writeln('    This game is one of exploration and strategy.  You must find your way');
  Writeln('  through 25 dangerous areas, and will probably not make it through alive!');
  Writeln('  There are many objects you will encounter along your way.  The effect of');
  Writeln('  some will be obvious, but more mysterious things are also left for you to');
  Writeln('  find.  You will come across hordes of bloodthirsty monsters, as well as a');
  Writeln('  few helpful creatures, too...');
  Writeln('    Through the course of your adventure, you can find many magical gems.');
  Writeln('  Finding these gems can increase your strength and vitality, and is necessary');
  Writeln('  in order to stay alive!  When you are attacked by a monster, you will be');
  Writeln('  injured, requiring you to use a few of your health gems to restore your');
  Writeln('  vitality.  (                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Writeln(') by using the cursor pad on the right');
  Writeln('  side of your keyboard.  You can move in any of the four cardinal directions,');
  Writeln('  as well as diagonally.  Most scenes are viewed from above, but some are');
  Writeln('  played from the side.  On these levels you are affected by a strong gravity,');
  Writeln('  but falling from large heights will not harm you.');
  BlueMessage('Press any key to continue...');

  ClrScr;
  GotoXY(34,1);  Write  ('HELPFUL HINTS');
  GotoXY(34,2);  Writeln('ÄÄÄÄÄÄÄÄÄÄÄÄ?);
  Writeln;
  Writeln('  þ When you come across an item for the first time, you will be given a');
  Writeln('  message describing it.  These messages will help you identify the new object,');
  Writeln('  but it is up to you to decide whether to use it in the future or to leave it');
  Writeln('  alone.  If you become tired of seeing these descriptions every time you come');
  Writeln('  across a new item, most of them may be turned off using the minus (-) key, or');
  Writeln('  you can reset them with the plus (+) key.');
  Writeln;
  Writeln('  þ You are able to S)ave your game on any of five files (named A through E).');
  Writeln('  It is usually a good idea to save game at each new level you come to.  This');
  Writeln('  way, if you take a wrong turn or have a stroke of bad luck you can easily');
  Writeln('  R)estore where you saved and try, try again.');
  Writeln;
  Writeln('  þ There are many puzzles to solve in this game, as well as dozens of');
  Writeln('  mysterious objects to find, and even a few bizarre twists.  The best way to');
  Writeln('  determine what an unknown item will do is to touch it and read the message');
  Writeln('  displayed at the bottom of the screen.');
  Writeln;
  Writeln('  þ Don''t forget that your man can move diagonally!  This is useful for');
  Writeln('  entering rooms with only a crack in the wall, or to swiftly evade monsters.');
  BlueMessage('Press any key to continue...')
end;

Procedure FlashTitleName;
  {* Flashes name of game on title screen}
var  Color : integer;

begin
  repeat
    Color := Random(16)
  until Color <> 6;
  TextAttr := Color + Brown * 16;
  Window(16,4,80,7);
  Writeln('ÕÍËÍ???ÕÍÍ¸    ÍËÍ» ÕÍÍ¸ ??ÕÍËÍ?ÕÍ? Í»  Í¸');
  Writeln('  ?  ÌÍ?ÆÍ?   ???ÆÍ? ³Ö?  ?  ?  ÌÍ???);
  Writeln('  ?  ??ÔÍÍ¾   ???ÔÍÍ¾ À½  ÔÍÊÍ?ÔÍ?????);
  Window(29,8,80,11);
  Writeln(' ÍÍ???ÕÍÍ¸ ÕÍÍ¸ ÕÍËÍ?);
  Writeln('? ???ÆÍ? ÔÍÍ»   ? ');
  Writeln('ÈÍÑ¼ ÔÍ?ÔÍÍ¾ ÔÍÍ¼   ? ');
  Window(1,1,80,24);
  TextBackground(Blue);
  Delay(50)
end;

Procedure TitleScreen;
  {* Displays title screen and flashes name}
var Rnd : integer;

begin
  Window(1,1,80,25);          {border}
  Rnd := (Random(6) + 2) * 16;
  SetBorder(Rnd);
  TextAttr := Rnd;
  ClrScr;
  TextAttr := Blue * 16;      {main screen}
  Window(3,2,78,24);
  ClrScr;
  TextAttr := Black;
  Window(16,4,68,12);
  ClrScr;
  TextAttr := Brown * 16;
  Window(14,3,66,11);
  ClrScr;
  Window(1,1,80,25);
  FlashTitleName;

  TextColor(LightGray);       {info}
  GotoXY(35,14);
  Write('Version ',Version:1:2);
  TextColor(LightMagenta);
  GotoXY(26,16);
  Write('Presented by Adventia Software');
  TextColor(LightCyan);
  GotoXY(21,18);
  Write('Copyright (c) January 1994 Michael Rimer');

  TextColor(Yellow);            {skill setting}
  GotoXY(20,22);
  Write('Are you a  ovice,  dvanced, or an  xpert?');
  TextColor(White);
  GotoXY(30,22);   Write('N');
  GotoXY(38,22);   Write('A');
  GotoXY(54,22);   Write('E');
  TextAttr := LightRed + Blue * 16 + Blink;
  GotoXY(61,22);
  Write('?);

  PSound(300,100);  PSound(200,100);  PSound(100,100);
  NoSound;
  RemKeys;
  repeat
    repeat
      FlashTitleName
    until KeyPressed;
    Ch := UpCase(ReadKey)
  until (Ch in ['N','A','E',' ',#13]);  {enter skill level}
  PSound(100,80);  PSound(300,80);  PSound(500,80);
  PSound(700,80);  PSound(900,80);
  NoSound;

  Window(3,22,78,22);
  ClrScr;
  Window(1,1,80,24);
  TextAttr := Yellow + Blue * 16 + Blink;
  GotoXY(37,22);
  case Ch of
    'N',' ',#13 : begin
        SkillLevel := NOVICE;
        Write(' NOVICE')
      end;
    'A' : begin
        SkillLevel := ADVANCED;
        Write('ADVANCED')
      end;
    'E' : begin
        SkillLevel := EXPERT;
        Write(' EXPERT')
      end
  end; {Ch case}
  TextAttr := Blue * 16 + Blink;
  GotoXY(29,24);
  Write('Hit any key to continue.');
  repeat
    FlashTitleName
  until KeyPressed;
  Ch := ReadKey;
  PSound(100,150);
  NoSound
end;  {TitleScreen}

Procedure TitleOptions;
  {* Choices player can make before playing game}

begin
  repeat
    SetBorder(0);
    Window(1,1,80,25);
    TextAttr := Yellow;
    ClrScr;
    GotoXY(31,2);
    Write('THE MERICAN QUEST');
    GotoXY(22,4);
    TextAttr := Red;
    Write('Copyright (c) 1994 Adventia Software');
    GotoXY(23,6);
    Write('Version ',Version:1:2,' -- by Michael Rimer');
    TextAttr := Yellow;
    GotoXY(5,8);
    TextAttr := Brown;
    Write('THIS GAME MAY BE DISTRIBUTED BY SHAREWARE OR PUBLIC DOMAIN LIBRARIES,');
    GotoXY(9,9);
    Write('OR BULLETIN BOARD SYSTEMS, WHICH IS ENCOURAGED BY THE AUTHOR.');
    GotoXY(20,10);
    Write('PLEASE SHARE IT WITH YOUR FRIENDS, TOO!');
    GotoXY(1,11);
    TextAttr := LightMagenta;
    Write('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    Window(20,14,80,25);
    TextAttr := LightCyan;
    Writeln(' bout "The Merican Quest"');
    Writeln(' nstructions');
    Writeln(' iew Demonstration Level');
    if Noise
      then Writeln(' urn sound OFF (sound is ON)')
      else Writeln(' urn sound ON (sound is OFF)');
    Write(' omputer Speed (');
    case GameDelay of
      35 : Writeln('SLOW - IBM PC)');
      70 : Writeln('MEDIUM - PC AT, etc.)');
      99 : Writeln('FAST - turbo 386 chip, etc.)')
    end;
    Writeln(' egin your Quest');
    TextAttr := Yellow;
    GotoXY(1,1);
    Writeln('A');
    Writeln('I');
    Writeln('V');
    Writeln('T');
    Writeln('C');
    Writeln('B');
    Writeln;  Writeln;
    Window(18,21,80,25);
    TextAttr := LightRed;
    Write('Enter your choice? (A,I,V,T,C,B) [B]?');
    TextAttr := LightRed + Blink;
    Write('?);
    RemKeys;
    repeat
      Ch := UpCase(ReadKey);
    until (Ch in ['A','I','V','T','C','B',' ',#13]);
    case Ch of
      'A' : AboutMerQuest;
      'I' : Instructions;
      'V' : Demo := TRUE;
      'T' : Noise := (not Noise);
      'C' : case GameDelay of
              35 : GameDelay := 70;
              70 : GameDelay := 99;
              99 : GameDelay := 35
            end;
{*}   else DownWhoop  {descending sound - game begins}
    end {Ch case}
  until (Ch in ['V','B',' ',#13])
end;

Procedure Conclusion;
  {* Story to explain game's ending}
begin
  SetBorder(White);
  Window(1,1,80,25);
  TextAttr := Yellow + Blue * 16;
  ClrScr;
  Window(7,2,80,25);
  GotoXY(29,1);
  Write('BACK AT CAMP');
  GotoXY(29,2);
  Write('ÄÄÄÄÄÄÄÄÄÄÄÄ');
  TextAttr := White + Blue * 16;
  GotoXY(1,4);
  Writeln('  After having escaped from the subterranean world, you sit back');
  Writeln('against a log near your roaring fire.    You decide to break the');
  Writeln('seal on the book and read what is written inside...');
  Writeln('  Tenderly turning the yellowed pages, you read a history of the');
  Writeln('Merican civilization  -  its conception, its rise to glory,  and');
  Writeln('its  downfall.    While  strong,  the Mericans were  universally');
  Writeln('respected as the benefactors of the World, as it is known today.');
  Writeln('However, a powerful enemy,  the Book reads,  led by an ambitious');
  Writeln('and wicked wizard, attacked the Merican City.   Though strong in');
  Writeln('technology and courage,  the Mericans had the  disadvantage, for');
  Writeln('this evil wizard had spent many years in the  preparation of his');
  Writeln('weapons of war.    Pushed to  desperation,  the Mericans  made a');
  Writeln('machine which would transport them to another dimension,  though');
  Writeln('realizing  they might  never have a  chance to  return to  their');
  Writeln('native world...');
  Writeln('  After reading this, you feel inspired to search out these lost');
  Writeln('people and,  if possible,  bring them  back to  their  homeland.');
  Writeln('Indeed, this book may bring about your death, for  the adventure');
  Writeln('must go on, in...');
  TextAttr := Yellow + Blue * 16;  GotoXY(24,22);
  Writeln('THE MERICAN ADVENTURE');
  while KeyPressed do
    Ch := ReadKey;
  Window(1,1,80,25);
  BlueMessage('Press any key to continue...');
  SetBorder(Black)
end;

end.  {Quest2}
