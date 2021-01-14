Unit CityUnit;

Interface

Uses Dos, Sounds2, CLevels, Crt;

const MaxFlow = 350;

type
     ItemList = Array[1..MaxFlow] of Coord;
     MessList = Array[0..69] of boolean;              {message states}

const
       TPath1 : Array[-3..27,1..2] of byte = ((7,11),(8,11),(9,11),(9,12),
     (4,6),(4,7),(5,7),(6,7),(7,7),(8,7),(9,7),(9,8),(9,9),(8,9),(7,9),
     (6,9),(5,9),(4,9),(3,9),(3,10),(3,11),(3,12),(4,12),(4,13),(5,12),
     (6,12),(7,12),(7,11),(8,11),(9,11),(9,12));
       TPath2 : Array[-4..52,1..2] of byte = ((63,16),(63,15),(62,16),
     (61,16),(61,15),(49,23),(49,24),(48,24),(50,24),(51,24),(52,24),
     (53,24),(54,24),(54,23),(54,22),(53,22),(52,22),(52,21),(52,20),
     (53,20),(54,20),(55,20),(55,19),(55,18),(54,18),(54,17),(54,16),
     (54,15),(55,15),(56,15),(57,15),(57,16),(57,17),(58,20),(58,21),
     (57,21),(57,22),(57,23),(58,23),(59,23),(60,22),(61,23),(62,22),
     (63,21),(63,20),(62,20),(61,20),(61,19),(61,18),(62,18),(63,18),
     (63,17),(63,16),(63,15),(62,16),(61,16),(61,15));

var
                  IList : ItemList;
               Messages : MessList;
                   Boat : boolean;
              MagicKey,
      IStart, LastFlow,
       ILast, LastTurn,
     GoKey, XMax, YMax,
            FDir, Integ : integer;

Procedure WarpMan;
Procedure FMan;
Procedure FMan2;
Procedure Mess(Note : String; XPlace : integer);
Procedure Message(MessNum : byte);
 Function OPMess(MessNum : byte) : boolean;
Procedure PrintScore;
Procedure SumScore(Sum                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 m6;
Procedure Item7;
Procedure Item8;
Procedure Item9;
Procedure LvlMess(Num : integer);
Procedure SL(Num : integer);

Implementation

Procedure WarpMan;
begin
  i := 37;
  repeat
    if Noise then Sound(i);
    Delay(9);
    Inc(i,2);
    TextAttr := Random(256);
    GotoXY(XCord,YCord);
    Write(Chr(1));
  until i > 380;
  NoSound;
  PrintMan
end;

Procedure FMan;
begin
  for i := 1200 downto 300 do
    begin
      if Noise then Sound(Random(i));
      Delay(1);
      TextAttr := Random(16);
      GotoXY(OldX,OldY);
      Write(Chr(1))
    end;
  NoSound;
  GotoXY(OldX,OldY);
  Write(Chr(255))
end;

Procedure FMan2;
begin
  for i := 1 to 100 do
    begin
      TextAttr := Random(16);
      GotoXY(XCord,YCord);
      Write(Chr(1));
      Delay(10)
    end;
  PrintMan
end;

Procedure Mess;
begin
  RemKeys;
  Window(1,1,80,25);
  repeat
    GotoXY(XPlace,25);
    TextAttr := Succ(Random(15));
    Write(Note);
    Delay(50);
  until KeyPressed;
  Bla                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ;
      6 : Mess('A giant oak is in your way.',18);
      7 : Mess('An eerie wind pushes you back.',17);
      8 : Mess('A metal railing is blocking your way.',13);
      9 : Mess('You can''t traverse deep water.',17);
     10 : Mess('Lava causes heavy damage!',19);
     11 : Mess('You can''t open the Door without a Key.',13);
     12 : Mess('Use keys to open doors.',20);
     13 : Mess('You pick up a bomb.',22);
     14 : Mess('Healing elixirs add to your power and score!',10);
     15 : Mess('These blocks can be moved.',18);
     16 : Mess('The electrified Forcefield zaps you!',14);
     17 : Mess('Ancient relics give you points!',16);
     18 : Mess('You have struck an invisible wall.',15);
     19 : Mess('An invisible crumbled wall appears.',15);
     20 : Mess('You find a secret tunnel!',19);
     21 : Mess('You are stuck to the spot!',19);
     22 : Mess('You discover a magical wand!',18);
     23 : Mess('An invisibility curse hits you!',16);
     24 : Mess('You discover a spell of visibility!',14);
     25 : Mess('The gate opens before you...',18);
     26 : Mess('Your craft is breaking up!',19);
     27 : Mess('You have boarded a raft.',20);
     28 : Mess('You have disembarked.',21);
     29 : Mess('You hit against an underwater reef.',14);
     30 : Mess('You are caught in a whirlpool!',17);
     31 : Mess('You have been burned!',21);
     32 : Mess('You activated a teleport trap!',17);
     33 : Mess('Gremlins steal part of your holdings...',12);
     34 : Mess('You have activated a secret lever...',14);
     35 : Mess('The dense forest foliage is barring your way.',9);
     36 : Mess('A trumpet was lying on the river bank.',13);
     37 : Mess('You discover a mystical shining lamp.',13);
     38 : Mess('A blue key is found that is surrounded by an aura of magic.',3);
     39 : Mess('When you grab the onyx ring you feel a tingling sensation.',4);
     40 : Mess('This red key feels strangely heavy when you pick it up.',5);
     41 : Mess('Touching the green key gives you a dreamy, peaceful feeling...',2);
     42 : Mess('You claim the shiny white plastic card.',13);
     43 : Mess('You have found an ancient artifact - Icarus'' Wings!',7);
     44 : Mess('The Life Staff is yours!!',19);
     45 : Mess('You begin your adventure with the sun topping the horizon.',4);
     46 : Mess('The city seems deserted...',19);
     47 : Mess('This tower holds a strange magical dweomer.',10);
     48 : Mess('The dark depths send a chill down your spine.',9);
     49 : Mess('These tunnels show the passage of time, covered with dust...',2);
     50 : Mess('A feeling of evil and dispair penetrates these dismal pits.',3);
     51 : Mess('The ceiling above the stairs is lost in the murk above.',5);
     52 : Mess('You find yourself atop the castle wall.',13);
     53 : Mess('You climb down onto the bank of a roaring river.',9);
     54 : Mess('The roar of the falls drounds out all other sound.',8);
     55 : Mess('The murky cave feels ancient, but well maintained.',8);
     56 : Mess('The shores of the lake are teeming with life!',10);
     57 : Mess('Terrible lightning crashes about your head above the water.',3);
     58 : Mess('Upon entering, a gripping force takes over your consciousness.',2);
     59 : Mess('Echoes resound from unseen openings and roll down twisted halls.',1);
     60 : Mess('Blazing torches send long shadows onto the tile floor.',5);
     61 : Mess('Your eyes are dazzled by flashing lights and bubbling flasks.',2);
     62 : Mess('A feeling of deep dread overwhelms you in the utter blackness.',2);
     63 : begin
         Mess('Looking down the corridor, your sixth sense screams in your mind.',1);
         Mess('You know something is not right here!',15)
       end;
     64 : Mess('level 25',1);
{     65 : Mess('The other end of the tunnel is blocked...',12);}
     66 : Mess('Your lamp discovers a flaw in the force field!',10);
     67 : Mess('The light blinks out!',21);
     68 : Mess('You now own...FIVE SUPERBOMBS!',17);
     69 : Mess('You triggered a mystic spear!',17);
    end; {MessNum case}
  Messages[MessNum] := FALSE
end;

Function OPMess;
begin
  case MessNum of
    20 : Mess('Do you wish to SAVE? (Y / N)',18);
    30 : Mess('Do you want to RESTORE? (Y / N)',16);
    40 : Mess('Do you want to sacrifice 50 health points for this new weapon?',2);
    50 : Mess('Is the Talisman in your possession?',15);
    99 : Mess('Are you SURE want to abort game? (Y / N)',12);
   100 : Mess('Do you want to play again? (Y / N)',15);
  end;        {of message case}
  Ch := UpCase(ReadKey);
  if Ch = 'Y' then OPMess := TRUE
    else if Ch in ['N',#32,#13] then OPMess := FALSE
      else begin
        RemKeys;
        ErrorBeep;
        OPMess := OpMess(MessNum)
      end
end;

Procedure PrintScore;
begin
  Window(1,1,80,25);
  if Score < 0 then Score := 0;
  TextAttr := Brown + LightGray * 16;
  GotoXY(70,2);
  if Score < 100 then Write(Score:4,'  ')
    else if (Score < 1000) then Write(Score:5,'  ')
      else Write(Score:6,'  ');
  Window(Twx,Twy,Lwx,Lwy)
end;

Procedure SumScore;
begin
  while Sum > 27 do
    begin
      Inc(Score,37);
      if Noise then Sound(200);
      Delay(30);
      NoSound;
      PrintScore;
      Dec(Sum,27)
    end;
  Inc(Score,Sum);
  PrintScore;
end;

Procedure SetUpStats;
begin
  TextAttr := Black;
  ClrScr;
  Window(65,1,80,25);
  TextBackground(Blue);                            {color status window}
  ClrScr;
  Window(1,1,80,25);
  TextAttr := Yellow + Blue * 16;                   {write window names}
  GotoXY(70,1);  Write('Score');
  GotoXY(70,4);  Write('Level');
  GotoXY(67,7);  Write('Bombs  Magic');
  GotoXY(71,10);  Write('Keys');
  GotoXY(70,13);  Write('Items');
  GotoXY(70,16);  Write('Health');
  TextAttr := LightGray * 16;
  for i := 1 to 6 do                                 {color status bars}
    begin
      GotoXY(67,(3 * i) - 1);
      Write('            ')
    end;
  TextAttr := White + Blue * 16;
  GotoXY(67,19);  Write('B');
  GotoXY(72,19);  Write('M');
  GotoXY(69,20);  Write('N');
  GotoXY(69,21);  Write('U');
  GotoXY(69,22);  Write('P');
  GotoXY(69,23);  Write('Q');
  GotoXY(69,24);  Write('S');
  GotoXY(69,25);  Write('R');
  TextAttr := LightGray + Blue * 16;
  GotoXY(68,19);  Write('omb/');
  GotoXY(73,19);  Write('agic');
  GotoXY(70,20);  Write('oise');
  GotoXY(70,21);  Write('se item');
  GotoXY(70,22);  Write('ause');
  GotoXY(70,23);  Write('uit');
  GotoXY(70,24);  Write('ave');
  GotoXY(70,25);  Write('                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    GotoXY(19,21);
    TextAttr := Succ(Random(15));
    Write('Press any key to continue...')
  until KeyPressed;
  Ch := ReadKey;
  ClrScr;
  TextAttr := Yellow
end;

Procedure Ins1;
begin
  GotoXY(30,1);
  Write('- THE MERICAN CITY -');
  Window(9,3,79,24);
  GotoXY(27,1);
  TextAttr := Yellow;
  Writeln('* THE TALE *');  Writeln;
  TextAttr := Cyan;
  Writeln(' As a hunter of fortune and glory, you have been travelling to');
  Writeln('many lands in search of treasure and riches. Once long ago you');
  Writeln('stumbled upon an underground cavern.   It led into a series of');
  Writeln('catacombs,  which were tunneled out of the very living rock by');
  Writeln('an ancient and powerful race of people known as the MERICANS.');
  Writeln(' Upon entering the labyrinth, you successfully retrieved their');
  Writeln('magical Talisman.   In days of olde the Mericans looked toward');
  Writeln('this artifact as a bringer of prosperity and long life.    But');
  Writeln('long  ago it  was stolen  from them,  and with  it their  good');
  Writeln('fortune.  In time, the Mericans mysteriously died out, and now');
  Writeln('no trace of them is to be seen...');
  Writeln('   You have taken up the quest to search for the Mericans, and');
  Writeln('restore their magical Protector to them if possible.     After');
  Writeln('many months of searching,   you have come upon the frontier of');
  Writeln('their  forgotten  land,  determined to  restore them  to their');
  Writeln('former splendour.   So armed only with the sacred Talisman and');
  Writeln('your boundless courage you journey onward into the unknown...');
  Prompt
end;

Procedure Ins2;
begin
  GotoXY(25,2);
  Writeln('* INSTRUCTIONS *');  Writeln;
  TextAttr := Red;
  Writeln('    At your journey''s outset, you have a limited amount of');
  Writeln('physical strength.  This decreases with fatigue and hunger (every');
  Writeln('step you take will detract from your stamina).  Using certain');
  Writeln('items also requires a small amount of power.  If at any time your');
  Writeln('strength lowers to zero, you will die and your game will end.');
  Writeln('    There are dozens of objects that you will encounter in the');
  Writeln('course of your quest.  Many will aid you with your venture, while');
  Writeln('others may hinder your search...and there are those select few');
  Writeln('that may be deadly!  It is up to you to discover which things to');
  Writeln('touch and which to avoid, and also which items may best be used');
  Writeln('for specific purposes...and when!');
  Write('    You may move your man (');
  TextAttr := Yellow + Red * 16;  Write(#1);  TextAttr := Red;
  Writeln(') in any of the');
  Writeln('cardinal directions: N, S, E and W, in addition');
  Write('to ');
  TextAttr := LightRed;  Write('diagonals');  TextAttr := Red;
  Writeln('.  Each move is entered in on the');
  Writeln('cursor pad:');
  TextAttr := LightGreen;
  Window(58,17,79,24);
  Writeln('     ',#24);  Writeln;
  Writeln('   7 8 9');
  Writeln(#27,'  4 5 6  ',#26);
  Writeln('   1 2 3');  Writeln;
  Writeln('     ',#25);
  Window(9,3,79,24);
  Prompt
end;

Procedure Ins3;
begin
  GotoXY(25,2);
  Writeln('* GAME TACTICS *');  Writeln;
  TextAttr := Magenta;
  Writeln('   "The Merican City" is a game of searching, exploration, and');
  Writeln('survival.  In all, this game is comprised of 25 rooms or scenes,');
  Writeln('each filled with precious treasures and diabolical traps!');
  Writeln('Each new area is different in some way from the last, and it is');
  Writeln('up to you to bravely surmount each obstacle you come to.');
  Writeln('Many challenging puzzles exist within this game, and it may');
  Writeln('take many tries and not a bit of luck to find out each level''s');
  Write('"secret to success". It may be wise to ');
  TextAttr := LightMagenta;  Write('(S)');
  TextAttr := Magenta;       Writeln('ave your game at each');
  Writeln('new level you come to.  Therefore, if you die or become trapped');
  Write('you will easily be able to ');
  TextAttr := LightMagenta;  Write('(R)');
  TextAttr := Magenta;       Writeln('estore game and try, try again...');
  Writeln;
  TextAttr := Yellow + Red * 16;  Write(#1);  TextAttr := 2;
  Writeln(' - you, a dauntless hunter of fortune and glory');
  TextAttr := LightRed;  Write(#235);  TextAttr := 2;
  Write(' - a bomb, which you can use to break old walls (');
  TextAttr := Brown;  Write('°');  TextAttr := 2;  Writeln(')');
  TextAttr := LightGreen + Blink;  Write(#24);  TextAttr := 2;
  Writeln(' - a magical wand, with more blast power than a bomb');
  TextAttr := LightCyan;  Write('è');  TextAttr := 2;
  Writeln(' - elixir, removes some of your fatigue');
  TextAttr := LightGray;  Write('ú');  TextAttr := 2;
  Writeln(' - secret panel.  When you step on these, expect surprises!');
  Prompt
end;

Procedure Ins4;
begin
  GotoXY(21,2);
  Writeln('* A FEW HELPFUL HINTS *');  Writeln;
  TextAttr := LightCyan;
  Writeln('þ  Don''t forget that you can move diagonally.');
  Write('þ  Pick up skeleton keys (');
    TextAttr := LightRed;  Write('å');  TextAttr := 11;
    Write(') to open the locked doors (');
    TextAttr := White + Magenta * 16;  Write('é');  TextAttr := 11;
    Writeln(').');
  Writeln('þ  Never give up - it takes a new approach or a twist');
  Writeln('     in thinking to solve each successive puzzle.');
  Writeln('þ  Use your items! As you progress, you will have to use');
  Writeln('     new objects to open up further areas and/or rooms.');
  Writeln('þ  Many hidden secrets are thrown into the game.  The');
  Writeln('     only catch is to look for them...');
  Writeln('þ  "Dead ends" usually aren''t...so check everywhere!');
  Writeln;  TextAttr := Cyan;
  Writeln('Oh, one last thing: later in the game you will encounter');
  Writeln('huge hoardes of hideous monsters (you will know them when');
  Writeln('you see them)!  They can be hurt by your bombs or magic, and');
  Writeln('can also be fought off...but this hurts you in the process.');
  TextAttr := White + Blink;
  GotoXY(21,19);
  Write('Have fun and good-luck!')
end;

Procedure Instruct;
begin
  Window(2,2,79,24);
  TextAttr := LightBlue;
  ClrScr;
  Ins1;  Ins2;  Ins3;  Ins4;
  Window(1,1,80,25)
end;

Function BlinkTitle : char;
var Ch : char;
begin
  repeat
    repeat
      TextAttr := (Random(14) + 2) + Blue * 16;
      GotoXY(31,4);
      Write('THE MERICAN CITY:');
      Delay(25)
    until KeyPressed;
    Ch := UpCase(ReadKey)
  until (Ch in ['N','E','A']);
  TextAttr := Yellow + Blue * 16 + Blink;
  GotoXY(18,21);
  Write('                                           ');
  case Ch of
    'N' : begin
      Power := 2000;
      GotoXY(37,21);
      Write('NOVICE');
      BlinkTitle := 'N'
      end;
    'E' : begin
      Power := 1500;
      GotoXY(35,21);
      Write('EXPERIENCED');
      BlinkTitle := 'E'
      end;
    'A' : begin
      Power := 1000;
      GotoXY(36,21);
      Write('ADVANCED');
      BlinkTitle := 'A'
      end;
  end; {Ch case}
end;

Procedure TitlePage;
begin
  Randomize;
  TextAttr := (Random(6) + 2) * 16;
  Window(1,1,80,25);
  ClrScr;
  Window(2,2,79,24);
  TextAttr := Blue * 16;
  ClrScr;
  Window(1,1,80,25);
  TextAttr := White + Blue * 16;
  GotoXY(31,9);
  Write('The Deeper Depths');
  GotoXY(31,10);
  Write('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
  TextAttr := LightMagenta + Blue * 16;
  GotoXY(39,13);
  Write('by');
  GotoXY(33,15);
  Write('Michael Rimer');
  TextAttr := LightCyan + Blue * 16;
  GotoXY(27,17);
  Write('THE EAGERLY AWAITED SEQUEL');
  TextAttr := DarkGray + Blue * 16;
  GotoXY(34,19);
  Write('Version 1.00');
  TextAttr := Yellow + Blue * 16;
  GotoXY(18,21);
  Write('Copyright (c) November 1992 MER Enterprises');
  GotoXY(15,23);
  TextAttr := LightRed + Blue * 16;
  Write('Are you a  ovice,  xperienced, or  dvanced player?');
  TextAttr := Yellow + Blue * 16;
  GotoXY(25,23); Write('N');
  GotoXY(33,23); Write('E');
  GotoXY(49,23); Write('A');
  TextAttr := LightMagenta + Blue * 16 + Blink;
  GotoXY(65,23); Write('Û ');
  Sound(250); Delay(200); NoSound;
  Ch := BlinkTitle;
  Sound(200); Delay(90);
  Sound(475); Delay(90);
  Sound(750); Delay(90);
  NoSound;
  TextAttr := LightGray + Blue * 16;
  GotoXY(15,23);
  Write('         Do you want instructions? (Y / N)         ');
  Ch := Upcase(ReadKey);
  Sound(100); Delay(150); NoSound;
  if Ch = 'Y' then Instruct;
  TextAttr := LightRed + Blue * 16;
  GotoXY(24,23);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    MB;
    Message(11)
  end
end;

Procedure ZapMonster(X, Y : integer);
var MP : MonsterPtr;
begin
  MP := HeadMS^.Next;
  while not ((MP^.mx = X) and (MP^.my = Y))
    do MP := MP^.Next;               {find monster at pos(x,y)}
  MP^.Prev^.Next := MP^.Next;    {remove monster from ptr list}
  if (MP^.Next <> nil) then MP^.Next^.Prev := MP^.Prev;
  Dispose(MP);
end;

Procedure ToggleSpot(c : char; x,y : integer);
begin
  if (XCord = x) and (YCord = y) then EXIT;        {man's spot unchanged}
  if LevelMat[x,y] = c then LevelMat[x,y] := ' '
    else if LevelMat[x,y] = ' ' then LevelMat[x,y] := c;
  if (LevelMat[x,y] = c) or (LevelMat[x,y] = ' ') then DrawLevel(x,y,x,y)
end;

Procedure PrintItems;
begin
  Window(1,1,80,25);
  TextAttr := LightGray * 16;
  GotoXY(68,14);
  Write('          ');
  if NumItems > 0 then begin
    GotoXY(68,14);
    TextColor(LightMagenta);
    Write('‘')
  end;
  if NumItems > 1 then begin
    TextColor(Red);
    Write('Œ')
  end;
  if NumItems > 2 then begin
    TextColor(LightBlue);
    Write('å')
  end;
  if NumItems > 3 then begin
    TextColor(Cyan);
    Write(#9)
  end;
  if NumItems > 4 then begin
    TextColor(LightRed);
    Write('å')
  end;
  if NumItems > 5 then begin
    TextColor(Yellow);
    Write('ë')
  end;
  if NumItems > 6 then begin
    TextColor(LightGreen);
    Write('å')
  end;
  if NumItems > 7 then begin
    TextColor(White);
    Write('þ')
  end;
  if NumItems > 8 then begin
    TextColor(Yellow);
    Write('%')
  end;
  if LifeStaff then begin
    GotoXY(77,14);
    TextColor(Blue);
    Write('ç')
  end;
end;

Procedure GetHorn;
begin
  PrintMan;
  Prize;
  LevelMat[XCord,YCord] := ' ';
  if NumItems > 0 then EXIT;
  NumItems := 1;
  PrintItems;
  Message(36);
  SumScore(500)
end;

Procedure GetLamp;
begin
  PrintMan;
  Prize;
  LevelMat[XCord,YCord] := ' ';
  if NumItems > 1 then EXIT;
  NumItems := 2;
  PrintItems;
  Lamp := 9;
  Message(37);
  Inc(Power,50);
  SumScore(1200)
end;

Procedure GetBky;
begin
  PrintMan;
  Prize;
  LevelMat[XCord,YCord] := ' ';
  if NumItems > 2 then EXIT;
  NumItems := 3;
  PrintItems;
  Message(38);
  Inc(Power,250);
  SumScore(2100)
end;

Procedure GetRing;
begin
  PrintMan;
  Prize;
  LevelMat[XCord,YCord] := ' ';
  if NumItems > 3 then EXIT;
  NumItems := 4;
  PrintItems;
  Message(39);
  Inc(Power,450);
  SumScore(3300);
  MF;
  FMan;
  OldX := 21;
  OldY := 14;
  MB;
  FMan2
end;

Procedure GetRky;
begin
  PrintMan;
  Prize;
  LevelMat[XCord,YCord] := ' ';
  if NumItems > 4 then EXIT;
  LevelNum := 12;
  NumItems := 5;
  PrintItems;
  Message(40);
  Inc(Power,650);
  SumScore(4700)
end;

Procedure GetSuperBombs;
begin
  MB;
  if NumItems > 5 then begin
      Speech;
      Mess('Sorry, all sold out, sonny.',19);
      EXIT
    end;
  Speech;  Mess('Welcome to my hidden valley, stranger...',12);
  Speech;  Mess('If you are willing to part with 50 health points...',7);
  Speech;  Mess('I will give you a limited but very powerful weapon!',7);
  if (not OPMess(40)) then begin
      Speech;
      Mess('If that''s the way you feel...',17);
      MB;
      EXIT
    end
  else begin
    Dec(Power,50);
    Prize;
    NumItems := 6;
    SuperBombs := 5;
    PrintItems;
    Message(68);
    SumScore(2000)
  end
end;

Procedure GetLifeStaff;
begin
  MB;
  if GotLifeStaff then begin
      Speech;
      Mess('Fare thee well on thy journey, brave lad!',11);
      EXIT
    end;
  Speech;
  Mess('Welcome, hardy adventurer! My name is Amir.',10);
  Speech;  Mess('You have found me, so you must be smart and brave indeed.',4);
  Speech;  Mess('I am a high priest of the lost ''Merican culture...',7);
  Speech;  Mess('Our race is unseen by the common world, yet we survive.',5);
  Speech;  Mess('But for us to thrive again, we must recover our sacred treasure.',1);
  if (not OPMess(50)) then begin
      Speech;
      Mess('Well then return here if it is ever found...',11);
      EXIT
    end;
  Speech;  Mess('Thank you, kind sir. With this we may prosper again!',7);
  Speech;  Mess('For your service, I will give you something in return...',5);
  Speech;  Mess('Though it may take my own life, it may save yours as well!',4);
  Prize;
  GotLifeStaff := TRUE;
  LifeStaff := TRUE;
  PrintItems;
  Message(44);
  SumScore(3000);
  Speech;  Mess('Venture now into the temple outside the city.',9);
  Speech;  Mess('There thou mayst find the answer to thy quest...',8)
end;

Procedure GetGky;
begin
  PrintMan;
  LevelMat[XCord,YCord] := ' ';
  case MagicKey of
    1 : if not ((XCord = 8) and (YCord = 5)) then begin
        Mess('The key crumbles to dust as you touch it...',10);
        EXIT
      end;
    2 : if not ((XCord = 2) and (YCord = 11)) then begin
        Mess('The key crumbles to dust as you touch it...',10);
        EXIT
      end;
    3 : if not ((XCord = 8) and (YCord = 17)) then begin
        Mess('The key crumbles to dust as you touch it...',10);
        EXIT
      end
  end; {MagicKey case}
  Prize;
  DrawLevel(XCord - 6,YCord - 5,XCord + 6,YCord + 5);
  PrintMan;
  if NumItems < 7 then begin
    NumItems := 7;
    PrintItems;
    Message(41);
    Inc(Power,1000);
    SumScore(6000);
    Mess('But wait - something strange is happening!',10)
    end;
  Eerie;
  Window(1,1,64,25);
  for i := 1 to 3000 do begin
    GotoXY(Random(64),Succ(Random(24)));
    Write('  ')
  end;
  Window(1,1,64,24); ClrScr;
  OldX := 44;
  OldY := 19;
  MB;
  YesSpec := FALSE; YesNec := FALSE;
  Keys := 0;
  HeadMS^.Next := nil;
  LoadCity;
  Mess('You awake to find yourself back on the river''s edge.',7);
  Mess('It appears to be afternoon...',18);
end;

Procedure GetPassCard;
begin
  MB;
  case Access of
    0,6..9 : begin
      Speech;
      Mess('You shouldn''t be in here!',20);
      FMan;
      OldX := 25;
      OldY := 16;
      MB;
      FMan2
      end;
    1 : begin
      Mess('In this verdant grove of trees you find an old man...',6);
      Speech;  Mess('Kudos to you, brave adventurer, for seeking to find me!',4);
      if GotLifeStaff then begin
        Speech;  Mess('Amir is the one who sent you, eh?',16);
        if (not LifeStaff) then begin
          Mess('(The old man seems grieved.)',19);
          Speech;  Mess('In using the Life Staff to heal yourself...',11);
          Speech;  Mess('It took Amir''s life in doing so!',17)
          end
        end;
      Speech;  Mess('Now it is important for you to restore The City.',9);
      Speech;  Mess('Enter the building in the city''s NE quadrant to do this.',5);
      Speech;  Mess('But to enter, you must use a special tool...',11);
      Speech;  Mess('I will give you this tool if you pass my 3 challenges.',6);
      Speech;  Mess('GOOD LUCK!',28);
      Sanctum1
      end;
    2 : begin
      Speech;  Mess('Good work - you have 2 more treasures to collect.',8)
      end;
    3 : begin
      Speech;  Mess('There is one last treasure that you must retrieve.',7)
      end;
    4 : begin
      Speech;  Mess('Congratulations!  You have passed my tests.',11);
      Speech;  Mess('Now take my reward...',22);
      Prize;
      if NumItems < 8 then begin
        NumItems := 8;
        PrintItems;
        Message(42);
        Inc(Power,1000);
        SumScore(8000)
      end;
      Access := 5;
      Sanctum1;
      Speech;  Mess('Now go forth and finish thy quest! The sun is lowering!',5)
      end;
    5 : begin
      Speech;  Mess('Time is of the essence...get going!',15);
      end
  end;  {Access case}
end;

Procedure GetWings;
begin
  PrintMan;
  Prize;
  LevelMat[XCord,YCord] := ' ';
  if NumItems > 8 then EXIT;
  NumItems := 9;
  PrintItems;
  Wings := 5;
  Message(43);
  Inc(Power,1000);
  SumScore(8000)
end;

Procedure SpecialItem;
begin
  case LevelNum of
    1 : GetHorn;
    2 : GetLamp;
    6 : GetBky;
    9 : GetRing;
   14 : GetRky;
   15 : GetSuperBombs;
   16 : GetLifeStaff;
   18 : GetGky;
   21 : GetPassCard;
   22 : GetWings;
  end; {LevelNum case}
  RemKeys
end;

Procedure LavaPath;
var x, y : integer;
begin
  if LevelNum = 21 then begin
    x := TPath2[ILast,1];
    y := TPath2[ILast,2]
  end
  else begin
    x := TPath1[ILast,1];
    y := TPath1[ILast,2]
  end;
  if FDir = 1 then begin
    LevelMat[x,y] := ' ';
    DrawLevel(x,y,x,y)
    end
  else begin
    LevelMat[x,y] := 'L';
    DrawLevel(x,y,x,y)
    end;
  if LevelNum = 21 then begin
    x := TPath2[                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                n Inc(ILast) else Dec(ILast);
  if ILast = (Ending + 1) then ILast := 1;
  if ILast = 0 then ILast := Ending;
end;

Procedure BoardBoat;
begin
  Boat := TRUE;
  Integ := 100;
  LevelMat[XCord,YCord] := '=';
  PrintMan;
  MF;
  OldSpot := 20;
  NewSpot := 20;
  WarpMan;
  Message(27)
end;

Procedure NormFall;
begin
  PrintMan;
  t := 1200;
  repeat
    if Noise then Sound(t);
    TextAttr := Yellow;
    GotoXY(XCord,YCord);
    case t of
      1000 : Write('O');
       800 : Write('o');
       600 : Write('ø');
       400 : Write('ù');
       200 : Write('ú');
        40 : Write(' ')
    end;
    Dec(t);
    Delay(2);
  until t < 37;
  NoSound
end;

Procedure BounceUp;
begin
  TextAttr := Yellow;
  for t := 37 to 1100 do begin
    Sound(t);
    GotoXY(XCord + Twx - 1,YCord + Twy - 1);
    case t of
       950 : Write('O');
       800 : Write('o');
       650 : Write(#9);
       500 : Write('ø');
       350 : Write('ù');
       200 : Write('ú');
        60 : Write(' ')
    end;
    Delay(2);
  end;
  PrintMan
end;

Procedure DropBlock(x,y : integer);
begin
  z := 1200;
  repeat
    Sound(z);
    TextAttr := LightBlue;
    GotoXY(x,y);
    case z of     {neat falling block effect}
     1200 : Write('Û');
      900 : Write('þ');
      600 : Write('ù');
      300 : Write('ú')
    end;
    Dec(z);
  until z < 37;
  NoSound;
  TextAttr := DarkGray;
  GotoXY(x,y);
  Write('°')
end;

Procedure MysticSpear(XPos, YPos, Dir : integer);
begin
  while (LevelMat[XPos,YPos] in [' ','-','W','T','0'..'3','6','7','h'..'k','d'])
    do begin
      GotoXY(XPos,YPos);
      TextAttr := Random(15) + 1;
      if Dir = 6 then Write(#26) else Write(#27);
      if Noise then Sound(Random(3000) + 35);
      Delay(50);
      if (LevelMat[XPos,YPos] in ['-','T'])
             then LevelMat[XPos,YPos] := ' '
      else if (LevelMat[XPos,YPos] in ['1','2','3'])
        then begin
          ZapMonster(XPos,YPos);
          LevelMat[XPos,YPos] := ' '
        end
      else if (XCord = XPos) and (YCord = YPos)
        then begin
          Zap;
          Dec(Power,50);
          Mess('Ouch! You were hit by a mystic spear!',15)
        end;
      DrawLevel(XPos,YPos,XPos,YPos);
      if Dir = 6 then Inc(XPos) else Dec(XPos)
    end;
end;

Procedure Item4;
begin
  case LevelNum of
    1 : begin
      MB;
      HitWall;
      Mess('No matter how hard you try, you can''t push open the Green Door.',1)
      end;
    2 : if NumItems < 4 then begin
        MB;
        Mess('A mysterious force won''t let you enter...',12)
      end
      else begin
        PrintMan;
        OldX := 4;
        OldY := 8;
        MB;
        UpSteps;
        Mess('You begin to ascend a long flight of steps...',10);
        LoadStair1;
        Message(51)
      end;
    3 : begin
      PrintMan;
      OldX := 55;
      OldY := 9;
      MB;
      DownSteps;
      LoadCity
      end;
    4 : begin
      PrintMan;
      OldX := 12;
      OldY := 11;
      MB;
      DownSteps;
      LoadTower1
      end;
    5 : begin
      YesNec := FALSE;
      PrintMan;
      OldX := 16;
      OldY := 16;
      MB;
      DownSteps;
      LoadTower2
      end;
    6 : begin
      PrintMan;
      OldX := 16;
      OldY := 16;
      MB;
      DownSteps;
      LoadTower3
      end;
    7 : begin
      PrintMan;
      OldX := 6;
      OldY := 7;
      MB;
      UpSteps;
      Mess('You come out to the sunlight once again!',13);
      LoadGateway
      end;
    8 : begin
      PrintMan;
      OldX := 6;
      OldY := 14;
      MB;
      UpSteps;
      LoadCatacombs
      end;
    9 : begin
      PrintMan;
      OldX := 29;
      OldY := 4;
      MB;
      UpSteps;
      LoadTunnels
      end;
   10 : begin
      PrintMan;
      OldX := 6;
      OldY := 12;
      MB;
      Keys := 1;
      YesNec := FALSE;
      YesSpec := FALSE;
      DownSteps;
      Mess('You step out of that dreadfully dank tower!',11);
      LoadCity
      end;
   12 : begin
      PrintMan;
      Inc(YCord);
      OldY := YCord;
      Descending;
      LoadStair2
      end;
   15 : begin
      PrintMan;
      OldX := 44;
      OldY := 19;
      MB;
      YesSpec := FALSE;
      UpSteps;
      LoadCity
      end;
   16 : begin
      Crystal2;
      for i := 21 to 23 do LevelMat[35,i] := '=';
      DrawLevel(35,16,51,24);
      PrintMan
      end;
   17 : begin
      PrintMan;
      UpSteps;
      OldX := 55;
      OldY := 9;
      MB;
      LoadStorm;
      Message(57);
      YesSpec := TRUE;
      Special := 900;
      YesNec := TRUE;
      Nec := 900
      end;
   18 : begin
      PrintMan;
      DownSteps;
      YesSpec := FALSE;
      YesNec := FALSE;
      OldX := 3;
      OldY := 3;
      MB;
      LoadLagoon
      end;
   20 : begin
      PrintMan;
      UpSteps;
      OldX := 49;
      OldY := 18;
      MB;
      LoadTemple
      end;
   21 : begin
      LevelMat[XCord,YCord] := ' ';
      if Access < 4 then Inc(Access);
      Sanctum1;
      PrintMan;
      MF;
      FMan;
      OldX := 25;
      OldY := 7;
      MB;
      FMan2
      end;
   22 : begin
      PrintMan;
      UpSteps;
      OldX := 42;
      OldY := 2;
      MB;
      YesNec := FALSE;
      LoadCity
      end;
   23 : begin
      PrintMan;
      UpSteps;
      OldX := 62;
      OldY := 13;
      MB;
      YesNec := TRUE;
      Nec := 1200;
      LoadSciLab
      end;
   24 : begin
      PrintMan;
      UpSteps;
      OldX := 3;
      OldY := 2;
      MB;
      LoadTheDark
      end;
  end {LevelNum case}
end;

Procedure Item5;
begin
  case LevelNum of
    1 : begin
      PrintMan;
      Mess('You enter the large marble structure...',12);
      Access := 0;     {For "Sanctum"}
      OldX := 5;
      OldY := 6;
      MB;
      LoadTemple;
      Message(58)
      end;
    2 : begin
      PrintMan;
      Mess('You climb down to the water''s edge.',14);
      OldX := 4;
      OldY := 9;
      MB;
      LoadRiver;
      YesSpec := TRUE;
      Special := 600;
      Message(53)
      end;
    3 : begin
      PrintMan;
      OldX := 4;
      OldY := 16;
      MB;
      UpSteps;
      LoadTower2
      end;
    4 : begin
      PrintMan;
      OldX := 4;
      OldY := 4;
      MB;
      UpSteps;
      LoadTower3
      end;
    5 : begin
      PrintMan;
      FootFalls;
      if GoKey = 8 then YesNec := FALSE
          else begin
            FDir := 1;
            YesNec := TRUE;
            Nec := 200;
            ILast := 1
          end
      end;
    6 : begin
      PrintMan;
      if LevelMat[12,4] = ' ' then begin
        LevelMat[12,4] := 'é';
        DrawLevel(12,4,12,4);
        Click;
        Mess('The door slams shut behind you!',16)
        end
      end;
    7 : begin
      PrintMan;
      DownSteps;
      OldX := 6;
      OldY := 6;
      MB;
      LoadTunnels;
      Message(49)
      end;
    8 : begin
      PrintMan;
      FootFalls;
      LevelMat[17,5] := 'n'
      end;
   10 : begin
      Beep2;
      Inc(Magic);
      Inc(Score,500);
      LevelMat[XCord,YCord] := ' ';
      PrintMan;
      Window(1,1,80,25);
      TextAttr := Brown + LightGray * 16;
      GotoXY(75,8);
      Write(Magic:2);
      PrintScore
      end;
   11 : begin
      PrintMan;
      Inc(XCord,2);
      OldX := XCord;
      Descending;
      LoadStair1
      end;
   12 : begin
      PrintMan;
      Inc(XCord);
      OldX := XCord;
      Ascending;
      LoadStair4
      end;
   13 : begin
      PrintMan;
      Dec(XCord);
      OldX := XCord;
      Descending;
      LoadStair3
      end;
   15 : begin
      YesNec := TRUE;
      Nec := 600;
      BoardBoat
      end;
   16 : begin
      YesNec := TRUE;
      Nec := 700;
      BoardBoat
      end;
   20 : begin
      MB;
      if Bombs < 1 then begin
          Bombs := 1;
          Window(1,1,80,25);
          TextAttr := Brown + LightGray * 16;
          GotoXY(68,8);
          Write(Bombs:2);
          Window(Twx,Twy,Lwx,Lwy);
          Beep3
        end
      else ErrorBeep
      end;
   21 : begin
      PrintMan;
      UpSteps;
      Mess('A secret tunnel takes you back outside!',13);
      YesNec := FALSE;
      OldX := 4;
      OldY := 5;
      MB;
      LoadGateway
      end;
   22 : begin
      PrintMan;
      DownSteps;
      YesNec := True;
      Nec := 1300;
      OldX := 57;
      OldY := 7;
      MB;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      m6;
var i : integer;
begin
  case LevelNum of
    1 : begin
      PrintMan;
      DownSteps;
      Mess('A tunnel into the earth takes you downward...',9);
      OldX := 6;
      OldY := 21;
      MB;
      LoadCatacombs;
      Message(48)
      end;
    2 : begin
      MB;
      HitWall;
      Mess('You come upon a large metallic edifice...with no visible way in.',1);
      end;
    5 : begin
      PrintMan;
      FootFalls;
      if GoKey = 2 then YesNec := FALSE
          else begin
            FDir := 0;
            YesNec := TRUE;
            Nec := 200;
            ILast := 4
          end
      end;
      7 : begin
        PrintMan;
        if YesNec then Click else FootFalls;
        YesNec := FALSE
        end;
      8 : begin
        PrintMan;
        FootFalls;
        LevelMat[17,5] := 'o'
        end;
     10 : begin
        PrintMan;
        Dec(XCord);
        OldX := XCord;
        Ascending;
        LoadStair2
        end;
     11 : begin
        PrintMan;
        Dec(YCord);
        OldY := YCord;
        Ascending;
        LoadStair3
        end;
     12 : begin
        PrintMan;
        Inc(XCord);
        OldX := XCord;
        Ascending;
        LoadStair4
        end;
     13 : begin
        PrintMan;
        Dec(XCord);
        OldX := XCord;
        Descending;
        LoadStair3
        end;
     15 : begin
        NormFall;
        OldX := 36;
        OldY := 2;
        MB;
        YesSpec := FALSE;
        LoadFalls;
        Message(54)
        end;
     16 : begin
        PrintMan;
        DownSteps;
        Mess('You enter into the gaping maw of a dim cave...',10);
        LoadCave;
        Message(55)
        end;
     20 : begin
        PrintMan;
        DownSteps;
        MB;
        Inc(XCord,2);
        if YCord < 14 then Dec(YCord) else Inc(YCord);
        MF;
        LoadSanctum
        end;
     21 : begin
        PrintMan;
        UpSteps;
        MB;
        Dec(XCord,2);
        if YCord > 14 then Dec(YCord) else Inc(YCord);
        YesNec := FALSE;
        MF;
        LoadLabyrinth
        end;
     22 : begin        {mystic spear}
        PrintMan;
        LevelMat[XCord,YCord] := ' ';
        MysticSpear(XCord + 1,YCord,6);
        Message(69)
        end;
     23 : begin
        MB;
        Mess('You suddenly encounter a wizened old man.',11);
        Mess('His aura is one of natural knowledge and power.',8);
        Mess('His humble expression gives credit to the wisdom that he holds.',1);
        Mess('He slowly raises his eyes up to yours and begins to speak...',3);
        Speech;
        Mess('Welcome at last to the caverns underneath the city, brave one!',2);
        Speech;
        Mess('Though our city is in great disrepair, you have seen a bit',4);
        Speech;
        Mess('of its greatness from antiquity. This greatness was realized',3);
        Speech;
        Mess('only through hard work, dedication, and good-will. Now is your',2);
        Speech;
        Mess('chance to restore this greatness, for all of the world to',5);
        Speech;
        Mess('partake of. Further below is a pedestal. On it is a statue...',3);
        Speech;
        Mess('You must reunite our Talisman with that statue.',10);
        Speech;
        Mess('Be warned! It is guarded, and the way is treacherous!',7);
        Speech;
        Mess('But you, our Chosen One, can do it...  GOOD LUCK!!',9);
        Speech;
        Mess('Now travel to your final destination further below...',6);
        LevelMat[2,2] := '7';
        Stairs
        end;
  end {LevelNum case}
end;

Procedure Item7;
begin
  case LevelNum of
    1 : begin
      MB;
      HitWall;
      Mess('The door seems to be made of water, but you can''t open it.',4)
      end;
    2 : begin
      PrintMan;
      DownSteps;
      Mess('You descend the steep passage into the unknown...',8);
      OldX := 4;
      OldY := 4;
      MB;
      YesNec := TRUE;
      Nec := 1200;
      LoadSciLab
      end;
    5 : begin
      YesNec := FALSE;
      PrintMan;
      OldX := 16;
      OldY := 3;
      MB;
      UpSteps;
      LoadTower4
      end;
    7 : begin
      PrintMan;
      if YesNec then FootFalls else Click;
      YesNec := TRUE;
      Nec := 300;
      end;
    8 : begin
      PrintMan;
      FootFalls;
      YesNec := FALSE
      end;
   15 : begin
      HitWall;
      Dec(Score,10);
      PrintScore;
      Dec(Integ,3);
      MB;
      Message(5)
      end;
   16 : begin
      NormFall;
      YesNec := FALSE;
      Boat := FALSE;
      OldSpot := 1;
      NewSpot := 1;
      OldX := 50;
      OldY := 12;
      MB;
      LoadLagoon;
      Message(56)
      end;
   20 : begin
      PrintMan;
      NormFall;
      Access := 1;        {remove forcefield in "Sanctum"}
      YesNec := FALSE;
      OldX := 4;
      OldY := 21;
      MB;
      LoadSanctum;
      Message(60)
      end;
   21 : begin
      PrintMan;
      FootFalls;
      if GoKey = 8 then YesNec := FALSE
          else begin
            FDir := 1;
            YesNec := TRUE;
            Nec := 250;
            ILast := 1
          end
      end;
   22 : begin
      PrintMan;
      NormFall;
      YesNec := FALSE;
      OldX := 62;
      OldY := 22;
      MB;
      LoadTheDark
      end;
   23 : begin
      PrintMan;
      Downsteps;
      YesNec := FALSE;
      OldX := 3;
      OldY := 3;
      MB;
      LoadTrapHall
      end;
  end {LevelNum case}
end;

Procedure Item8;
begin
  case LevelNum of
    2 : begin
      MB;
      HitWall;
      Mess('A large Red Keyhole is set into the stone wall.',8);
      end;
    5 : begin
      PrintMan;
      Click;
      ToggleSpot('Û',11,9);
      ToggleSpot('Û',11,10);
      OldSpot := 30
      end;
    7 : if not (GoKey = 6) then begin
            MB;
            LevelMat[9,14] := 'Û';
            DrawLevel(9,14,9,14);
            LevelMat[29,8] := 'i';
            GotoXY(29,8);
            TextAttr := White + Blink;
            Write('ú');
            Mess('Door, door...who stole the door?',16)
          end
        else Door;
    8 : begin
      PrintMan;
      FootFalls;
      XTrap := 32;
      YTrap := 10;
      YesNec := TRUE;
      Nec := 450
      end;
   12 : if Keys > 0 then begin
        Door;
        LevelNum := 14;
        if MaxLevel < 14 then MaxLevel := 14;
        DrawLevel(16,1,20,4);
        DrawLevel(21,1,45,16);
        LevelName('The Pinnacle');
        Message(52)
      end
      else Door;
   13 : begin
      MB;
      LockedDoor;
      if Keys > 0 then Mess('No key you have will fit the strange lock.',11)
      end;
   16 : begin
      PrintMan;
      OldX := 48;
      OldY := 17;
      MB;
      UpSteps;
      LoadFalls;
      DrawLevel(36,16,51,24);
      PrintMan
      end;
   19 : begin
      PrintMan;
      OldX := 4;
      OldY := 5;
      MB;
      YesNec := FALSE;
      LoadGateway
      end;
   21 : begin
      PrintMan;
      FootFalls;
      if GoKey = 8 then YesNec := FALSE
          else begin
            FDir := 0;
            YesNec := TRUE;
            Nec := 250;
            ILast := 4
          end
      end;
   22 : begin
      PrintMan;
      FootFalls;
      if GoKey = 6 then Nec := 1250 else Nec := 1200
      end;
   24 : for i := 54 to 64 do
         for j := 15 to 24 do
          if LevelMat[i,j] = '-' then LevelMat[i,j] := ' ';
  end {LevelNum case}
end;

Procedure Item9;
begin
  case LevelNum of
    2 : if NumItems < 2 then begin
        MB;
        Mess('It is too dark inside for you to go in...',11)
      end
    else begin
      PrintMan;
      UpSteps;
      Mess('Lighting your lamp, you enter the city''s eastern tower.',4);
      Window(1,1,64,25);
      TextAttr := 0;
      ClrScr;
      OldX := 3;
      OldY := 16;
      MB;
      LoadTower1;
      WarpMan;
      Message(47)
      end;
    5 : begin
      PrintMan;
      Click;
      ToggleSpot('Û',11,10);
      ToggleSpot('Û',11,11);
      OldSpot := 30
      end;
    8 : begin
      NormFall;
      OldX := 15;
      OldY := 9;
      MB;
      LoadPits;
      Message(49)
      end;
   14 : begin
      Click;
      DrawLevel(16,5,20,16);
      PrintMan
      end;
   16 : begin
      DrawLevel(1,1,21,5);
      PrintMan;
      FootFalls
      end;
   19 : begin
      PrintMan;
      DownSteps;
      OldX := 4;
      OldY := 20;
      MB;
      LoadLabyrinth;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      watching you!',12);
     Moves := 5;
     YesNec := TRUE;    {make "Evil Eye" flash}
     Nec := 500;
     YesSpec := TRUE;
     Special := 500
     end;
   12 : Mess('Follow the wall to reach the bomb.',15);
   18 : Mess('Find 6 keys to open the half dozen doors.',12);
   20 : Mess('Sorry...to no avail - or is it?',16);
   21 : Mess('Trial ONE : PitFalls',22);
   22 : Mess('You seem to have discovered a long forgotten passageway!',5);
   23 : Mess('Thus it all comes to naught! (Moo-ha-ha!)',12);
   24 : Mess('To know the trap is worse than being blind...',11);
  end {LevelNum case}
end;

Procedure LMess2;
begin
  case LevelNum of
    8 : Mess('Here''s where it gets tricky...',16);
   18 : Mess('Your goal lies behind one of the three doors...but which one?',3);
   20 : Mess('Drop the bomb HERE!!',22);
   21 : Mess('Trial TWO : Survival',22);
   22 : Mess('You have come out onto a thin ledge with a gaping chasm below...',1);
   23 : begin
     Mess('A frigid blast hits you full in the face.',13);
     Mess('You realize you might not make it out alive!',11)
     end;
   24 : Mess('By the trap egress is won, but peril is not lost!',8);
  end {LevelNum case}
end;

Procedure LMess3;
begin
  case LevelNum of
    8 : Mess('You can make it!',24);
   18 : Mess('Did you get ALL six keys?',20);
   20 : Mess('Enter: the INVISIMAZE!',21);
   21 : Mess('Trial THREE : There and Back Again',15);
   22 : begin
      Mess('Looking over the water you realize the only way across...',4);
      Mess('...would be if you could fly...',17)
    end;
  end {LevelNum case}
end;

Procedure LvlMess(Num : integer);
begin
  Inc(Score,25);
  PrintScore;
  LevelMat[XCord,YCord] := ' ';
  PrintMan;
  FootFalls;
  case Num of
    1 : LMess1;
    2 : LMess2;
    3 : LMess3
  end;
end;

Procedure SL1;
begin
  case LevelNum of
    2 : begin
      TextAttr := Yellow;
      LevelMat[27,13] := ' ';
      LevelMat[21,18] := 'Û';
      LevelMat[25,18] := ' ';
      LevelMat[25,19] := ' ';
      LevelMat[27,17] := '°';
      DrawLevel(21,13,27,19);
      PrintMan;
      YesNec := TRUE;    {Setup for lavaflow}
      Nec := 100;
      Moves := 0;
      LastFlow := 1;
      LastTurn := 0;
      ILast := 1;
      IStart := 1;
      IList[1].x := 25;
      IList[1].y := 20
    end;
    4 : if LevelMat[3,7] = 'þ' then begin   {remove PushBlock}
      LevelMat[3,7] := ' ';
      DropBlock(3,7);
      DrawLevel(3,7,3,7)
    end;
    5 : begin
      ToggleSpot('Û',11,7);
      ToggleSpot('Û',11,9)
    end;
    6 : LevelMat[9,8] := ' ';
    8 : begin
      YesNec := TRUE;
      Nec := 400
    end;
   14 : for i := 27 to 35 do
          for j := 5 to 13 do ToggleSpot('Z',i,j);
   17 : begin
     LevelMat[20,7] := ' ';
     YesNec := TRUE;     {Setup for Water flow}
     Nec := 800;
     Moves := 0;
     LastFlow := 1;
     LastTurn := 0;
     ILast := 1;
     IStart := 1;
     IList[1].x := 20;
     IList[1].y := 6
     end;
   18 : begin
     LevelMat[8,9] := ' ';
     LevelMat[6,11] := ' ';
     LevelMat[8,13] := ' ';
     LevelMat[8,11] := ' ';
     DrawLevel(6,10,10,12);
     PrintMan;
     MagicKey := Random(3) + 1;  {place (real) green key at one spot}
     end;
   19 : begin
     LevelMat[XCord,YCord] := ' ';
     PrintMan;
     for i := 13 to 30 do
       for j := 1 to 11 do ToggleSpot('-',i,j);
     end;
   20 : if LevelMat[62,9] = 'Z' then begin
         LevelMat[62,9] := ' ';
         DrawLevel(62,9,62,9)
       end
       else begin
         NullItem;
         for z := 6 to 9 do LevelMat[62,z] := 'Z';
         DrawLevel(62,6,62,9)
       end;
   21 : for i := 53 to 61 do
          for j := 5 to 13 do ToggleSpot('Z',i,j);
   23 : if Access = 0 then begin
     Access := 1;
     for i := 1 to 5 do Crumble;
     Mess('In the distance you hear the sound of a wall rolling back.',4);
     end;
   24 : begin
     Window(1,1,64,24);  TextAttr := 0;
     case XCord of
       20 : if GoKey = 6 then begin
           ClrScr;  Crumble;
           LevelMat[19,3] := 'é';  LevelMat[12,11] := 'å';
           DrawLevel(19,1,35,4);  DrawLevel(14,5,34,9);
           DrawLevel(23,6,35,10)
         end;
       33 : if GoKey = 8 then begin
           ClrScr;  Crumble;
           LevelMat[33,7] := 'é';  LevelMat[16,8] := 'å';
           DrawLevel(32,4,35,7);  DrawLevel(36,1,60,9);
           DrawLevel(61,1,64,8)
         end;
       61 : if GoKey = 6 then begin
           ClrScr;  Crumble;
           Window(1,1,65,25);
           LevelMat[60,5] := 'é';  DrawLevel(60,3,64,7);
           DrawLevel(1,5,10,9);  DrawLevel(1,10,11,24);
           DrawLevel(12,12,13,24);  DrawLevel(14,9,23,24);
           DrawLevel(24,10,34,24);  DrawLevel(35,8,40,24);
           DrawLevel(41,9,45,24);  DrawLevel(46,15,46,23);
           DrawLevel(47,18,50,20)
         end;
       49 : if GoKey = 6 then begin
           ClrScr;  Crumble;
           LevelMat[48,19] := 'é';
           DrawLevel(40,9,59,14);  DrawLevel(60,7,64,14);
           DrawLevel(46,15,54,18);  DrawLevel(48,19,53,20)
         end;
       60 : if GoKey = 2 then begin
           ClrScr;  Crumble;
           Window(1,1,65,25);
           LevelMat[60,13] := 'é';
           DrawLevel(53,13,64,24);  DrawLevel(45,20,52,24)
         end;
       45 : if GoKey = 4 then begin
           ClrScr;  Crumble;
           Window(1,1,65,25);
           LevelMat[46,24] := 'é';
           DrawLevel(32,19,38,24);  DrawLevel(39,23,47,24);
           DrawLevel(31,10,35,17);  DrawLevel(36,13,38,17)
         end;
       end; {XCord case}
     MF;
     PrintMan;
     Mess('Suddenly, the way back is blocked and a new room opens up...',3)
    end; {Level 24}
  end {LevelNum case}
end;

Procedure SL2;
begin
  case LevelNum of
    2 : begin
      LevelMat[34,24] := 'Û';
      TextAttr := Yellow;
      GotoXY(34,24);
      Write('Û')
      end;
    5 : begin
      ToggleSpot('Û',11,11);
      ToggleSpot('Û',11,12)
      end;
    7 : begin
      LevelMat[9,14] := 'é';
      DrawLevel(9,14,9,14);
      NewSpot := 1;
      PowerUp;
      FMan2;
      PrintMan;
      Message(24)
      end;
   19 : for i := 44 to 58 do
          for j := 2 to 4 do
            if LevelMat[i,j] = '-' then LevelMat[i,j] := ' ';
   20 : if (LevelMat[62,9] = ' ') and (LevelMat[62,8] = 'Z') then begin
         LevelMat[62,8] := ' ';
         DrawLevel(62,8,62,8)
       end
       else begin
         NullItem;
         for z := 6 to 9 do LevelMat[62,z] := 'Z';
         DrawLevel(62,6,62,9)
       end;
   23 : for i := 36 to 46 do
          for j := 2 to 10 do
            if LevelMat[i,j] = '-' then LevelMat[i,j] := ' ';
   24 : begin
       Moves := -7;
       Access := YCord; {fires correct spear}
       YesNec := TRUE;
       Nec := 1400
     end;
  end {LevelNum case}
end;

Procedure SL3;
begin
  case LevelNum of
    2 : LevelMat[55,8] := '9';
    5 : ToggleSpot('Û',11,10);
   19 : for i := 46 to 57 do
          if LevelMat[i,22] = '-' then LevelMat[i,22] := ' ';
   20 : if (LevelMat[62,8] = ' ') and (LevelMat[62,7] = 'Z') then begin
         LevelMat[62,7] := ' ';
         DrawLevel(62,7,62,7)
       end
       else begin
         NullItem;
         for z := 6 to 9 do LevelMat[62,z] := 'Z';
         DrawLevel(62,6,62,9)
       end;
   24 : begin
       Moves := -10;
       YesNec := TRUE;
       Nec := 1425;
       Mess('Uh, oh! You feel the ceiling start to shake!',11);
     end;
  end {LevelNum case}
end;

Procedure SL4;
begin
  case LevelNum of
    2 : LevelMat[55,8] := 'r';
    5 : begin
      ToggleSpot('Û',11,8);
      ToggleSpot('Û',11,11);
      ToggleSpot('Û',11,12)
      end;
   20 : if (LevelMat[62,7] = ' ') and (LevelMat[62,6] = 'Z') then begin
         LevelMat[62,6] := ' ';
         DrawLevel(62,6,62,6)
       end
       else begin
         NullItem;
         for z := 6 to 9 do LevelMat[62,z] := 'Z';
         DrawLevel(62,6,62,9)
       end;
   24 : begin
      YesNec := TRUE;    {Setup for lavaflow}
      Nec := 100;
      Moves := 0;
      LevelMat[27,14] := ' ';  DrawLevel(27,14,27,14);
      LastFlow := 1;
      LastTurn := 0;
      ILast := 1;
      IStart := 1;
      IList[1].x := 23;
      IList[1].y := 11
    end;
  end {LevelNum case}
end;

Procedure SL(Num : integer);
begin
  PrintMan;
  Click;
  case Num of
    1 : SL1;
    2 : SL2;
    3 : SL3;
    4 : SL4
  end;
  OldSpot := 30   {will redraw lever}
end;

end.  {CityUnit}
