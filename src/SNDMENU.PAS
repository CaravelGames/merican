Program SoundMenu;                        {written by Michael Rimer}

{Plays the 88 sounds in the SOUNDS unit, written by me}

Uses Sounds, Crt;

const NumSounds = 88;

Procedure Menu;    {play sounds from library}
var Err, Num : integer;
    St       : string[2];
begin
  repeat
    GotoXY(51,24);  Write('          ');  GotoXY(51,24);
    Readln(St);
    Val(St,Num,Err);
  until (Num in [0..NumSounds]) and (Err = 0);
  case Num of
     0 : HALT;   {stop program}
     1 : LowBeep;
     2 : MidBeep1;
     3 : MidBeep2;
     4 : MediumBeep;
     5 : HighBeep1;
     6 : HighBeep2;
     7 : ErrorBeep;
     8 : WrongKey;
     9 : NullItem;
    10 : Buzz;
    11 : Attention;
    12 : Thump;
    13 : Thump2;
    14 : HitWall;
    15 : HitWall2;
    16 : Squeak;
    17 : FootFalls;
    18 : Footfalls2;
    19 : WarmUp;
    20 : Whoop;
    21 : Whoop2;
    22 : DownWhoop;
    23 : UpSteps;
    24 : UpStairs1;
    25 : DownSteps;
    26 : DownStairs1;
    27 : Fry;
    28 : Zap;
    29 : UseKey;
    30 : OpenDoor;
    31 : LockedDoor;
    32 : Splatter;
    33 : Squish1;
    34 : Squish2;
    35 : Squish3;
    36 : WaterSpot;
    37 : Stuck;
    38 : Prize;
    39 : Prize2;
    40 : BombBlast;
    41 : SpellCast;
    42 : Slide;
    43 : Whistle;
    44 : Whistle2;
    45 : Click1;
    46 : Click2;
    47 : Click3;
    48 : Click4;
    49 : Ascending;
    50 : Descending;
    51 : SlowDown;
    52 : Monster;
    53 : Crumble1;
    54 : Crumble2;
    55 : CrumbleWall;
    56 : Drain;
    57 : Crystal1;
    58 : Crystal2;
    59 : Crystal3;
    60 : MonsterYell;
    61 : WormScream;
    62 : Eerie;
    63 : Echo;
    64 : PhaseShift;
    65 : PowerUp;
    66 : Sparkle;
    67 : Speech;
    68 : Strange;
    69 : Sprinkle;
    70 : SlowingWheel;
    71 : WaveBeam;
    72 : Motor;
    73 : Humm;
    74 : Arrive;
    75 : Depart;
    76 : HandsOnDeck;

    77 : repeat Electric1 until KeyPressed;
    78 : repeat Electric2 until KeyPressed;
    79 : repeat Explosion until KeyPressed;
    80 : repeat Static until KeyPressed;
    81 : repeat Wave until KeyPressed;
    82 : repeat BusySignal until KeyPressed;
    83 : repeat Siren1 until KeyPressed;
    84 : repeat Siren2 until KeyPressed;
    85 : repeat Laser until KeyPressed;
    86 : ;
    87 : ;
    88 : ;
  end; {Num case}
  NoSound
end;

begin    {main prog - display sounds}
  Noise := TRUE;   { turn sounds ON }
  ClrScr;
  TextAttr := Yellow;
  Writeln('                       *** Sounds Menu ***');
  TextAttr := LightGray;
  Writeln(' 1 : Low Beep     23 : UpStairs 1   45 : Click 1       67 : Speech       ');
  Writeln(' 2 : Mid Beep 1   24 : UpStairs 2   46 : Click 2       68 : Strangetalk  ');
  Writeln(' 3 : Mid Beep 2   25 : DownStairs 1 47 : Click 3       69 : Sprinkle     ');
  Writeln(' 4 : Medium Beep  26 : DownStairs 2 48 : Click 4       70 : Slowing Wheel');
  Writeln(' 5 : High Beep 1  27 : Fry          49 : Ascending     71 : Wave Beam    ');
  Writeln(' 6 : High Beep 2  28 : Zap          50 : Descending    72 : Motor        ');
  Writeln(' 7 : ErrorBeep    29 : Reflect      51 : Slowdown      73 : Humming      ');
  Writeln(' 8 : WrongKey     30 : Open Door    52 : Monster       74 : Arrive       ');
  Writeln(' 9 : BadItem      31 : Locked Door  53 : Crumble 1     75 : Depart       ');
  Writeln('10 : Bip/Buzz     32 : Splatter     54 : Crumble 2     76 : HandsOnDeck  ');
  Writeln('11 : Attention    33 : Squish 1     55 : CrumbleWall   77 : Electric 1   ');
  Writeln('12 : Thump 1      34 : Squish 2     56 : Drain         78 : Electric 2   ');
  Writeln('13 : Thump 2      35 : Squish 3     57 : Crystal 1     79 : Explosion    ');
  Writeln('14 : HitWall 1    36 : Waterspot    58 : Crystal 2     80 : Static       ');
  Writeln('15 : HitWall 2    37 : Stuck        59 : Crystal 3     81 : Jackhammer   ');
  Writeln('16 : Squeak       38 : Prize 1      60 : Monster Yell  82 : Busy Signal  ');
  Writeln('17 : Footfalls 1  39 : Prize 2      61 : Worm Scream   83 : Siren 1      ');
  Writeln('18 : Footfalls 2  40 : Bomb         62 : Eerie         84 : Siren 2      ');
  Writeln('19 : Warmup       41 : Spell        63 : Echoes        85 : Laser        ');
  Writeln('20 : Whoop 1      42 : Slide        64 : Phase Shift   86 :              ');
  Writeln('21 : Whoop 2      43 : Whistle 1    65 : Power Up      87 :              ');
  Writeln('22 : DownWhoop    44 : Whistle 2    66 : Sparkle       88 :              ');
  TextAttr := White;
  Write('Choose a number (1-',NumSounds,') to play a sound (0 quits): ');
  repeat
    Menu;
  until FALSE
end. {SoundTest}
