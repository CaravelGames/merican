Program PlayEdit;      {Version 1.00      by    Michael Rimer}
                       {begun 22 SEP 93 : completed 04 APR 94}

(* Variant of game "The Merican Quest", which plays levels designed
   in "MEREDIT.exe" *)

Uses Crt, ErikSnd, Sounds, MerCrt, CrtEXTRA, Quest1, PEdit1;

(****************)

const
  SmashItems = ['0','°'..'²'];   {all items monsters can break}
  StandItems = ['0','°'..'²','Û'..'ß','T','/','\','^','þ','é','Í','O','R','Y'];
         {all items player/monsters can stand on in SideVIEW levels}
  DebugStr = '-mer';        {command parameter for debugging}
  TEST     = 1;
  GAME     = 2;

(****************)

var
  GameDelay,
  GoKey         : integer;   {holds move to execute}
  NumStr        : string[9]; {for turning numbers into strings}
  TestLevel     : byte;
  DEBUG,                     {MER's debug}
  FuncKey       : boolean;   {extended key check}

(*

 DoSpecial(Spec : ItemRec);
 HitSpot(x, y, Dmg  : integer; Chr : char);
 SwingSword(x, y, S : integer);
 FlashBorder;
 Teleport;

 GetKeyPress;
 MoveMan;
 Action;

 TouchMonster;
 InsertMonster(x, y, Spd, Hts, Dmg : integer; Chr : char);
 MonsterInit;
 MonMoveSound(var Spot : char);

 Door;
 PushBoulder;
 PushBlock;
 InvWallsTrap;
 TeleportTrap;
 GetChest;
 RevealGems(GemsLeft : integer);
 MagicSpear(OffSet, x, y : integer);
 BombItem(x,y : integer);
 MagicBomb;
 SwordPowerUp;
 MonsterZap(NumToZap : integer);
 CreateMonsters(NumToMake : integer; MonTypes : string);
 Surround(Item, DisplayChar : char; DisplayColor : integer);
 RopeExtend(RopeCh : char);

 CheckPos;

 MoveMonsters;
 GenerateMonster(var ToCreate : integer);
 MonstersFall;
 ManFalls;
 CheckSpot;
 GameLoop;
 GameInit;  *)

(***************************)

Procedure CheckPos;  forward;

Procedure ModifySpot(var x, y, E : integer; var Ch : char);
begin
  case Level[x,y] of
    '0'..'9' : ZapMonster(x,y);      {monster is drawn over}
    'Y' : Dec(MonsterGen);
  end;

  case (E mod 10) of    {visual effect}
    0 : begin
          Level[x,y] := Ch;
          DrawSpot(x,y)
        end;
    1 : begin
          Level[x,y] := Ch;
          for Num := 219 to 223 do
            begin
              GotoXY(x,y);
              TextAttr := Random(15) + 1;
              Write(Chr(Num));
              Delay(10)
            end;
          DrawSpot(x,y)
        end;
    2 : begin
          Level[x,y] := Ch;
          for Num := 1 to 15 do
            begin
              GotoXY(x,y);
              TextAttr := Random(15) + 1;
              Write(#15);
              Delay(1)
            end;
          DrawSpot(x,y)
        end
  end;

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
  end
end;

Procedure ToggleSpot2(var x, y, E : integer; var C1, C2 : char);
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
  while (fS[1] <> ' ') and (Length(fs) > 0) do
    begin
      tS := tS + fS[1];
      Delete(fS,1,1)
    end;
  Delete(fS,1,1);  {remove space}
  Val(tS,N,Err)
end;

Procedure DoSpecAction(S : string); {var = faster}
  {* Executes command from special item}
var i1, i2 : char;
    SPos, Err,
    T, x1, y1, x2, y2, N, E : integer;
    Str : string;

begin
  GetSNum(S,Str, T,Err);
  case T of
    0 : begin
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := S[1];  Delete(S,1,2);  {remove char & space}
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              ModifySpot(i,j,E,i1)
        end;
    1 : begin
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := S[1];  Delete(S,1,2); 
          i2 := S[1];  Delete(S,1,2);  
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              if Level[i,j] = i1
                then ModifySpot(i,j,E,i2)
        end;
    2 : begin
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := S[1];  Delete(S,1,2);  
          i2 := S[1];  Delete(S,1,2);
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              if Level[i,j] <> i1
                then ModifySpot(i,j,E,i2)
        end;
    3 : begin
          GetSNum(S,Str, x1,Err);
          GetSNum(S,Str, y1,Err);
          GetSNum(S,Str, x2,Err);
          GetSNum(S,Str, y2,Err);
          i1 := S[1];  Delete(S,1,2);  
          i2 := S[1];  Delete(S,1,2);
          GetSNum(S,Str, E,Err);
          for i := x1 to x2 do
            for j := y1 to y2 do
              ToggleSpot2(i,j,E,i1,i2)
        end;
    4 : Message(S);
    5 : begin   {activate item i1, N times}
          i1 := S[1];  Delete(S,1,2);
          GetSNum(S,Str, N,Err);
          for i := 1 to N do
            begin
              MU;
              Level[XCord,YCord] := i1;
              CheckPos
            end
        end;
    6 : begin
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
  end  {item type}
end;

Procedure DoSpecial(Spec : ItemRec; Ch : char);
  {* Activates special item}
var Trav : SpecItemPtr;

begin
  PrintMan;
  with Spec do
    begin
      case IType of
        WT : begin
               Level[XCord,YCord] := ' ';
               Click1;
               Messages(26);
               Inc(IncScore,2500)
             end;
        SL : begin
               Click2;
               Messages(25)
             end;
        MA : Level[XCord,YCord] := ' ';
      end;  {IType}
      Trav := Item;
      while Trav <> nil do  {execute actions}
        begin
          DoSpecAction(Trav^.Data);
          Trav := Trav^.next
        end;
      if IType = SL
        then begin
               OldSpot := 1;
               Level[XCord,YCord] := Ch  {bug fix}
             end;
    end
end;

Procedure HitSpot(x, y, Dmg : integer; Chr : char);
  {* Hit one spot w/ sword, determine damage to item there}

var  Mnstr : Monster;  {modify monster, if one is hit}
     Spot  : char;

begin
  if (x < 1) or (x > 64) or (y < 1) or (y > 24)  {boundary check}
    then EXIT;

  PSound(Random(150) + 35,0);
  GotoXY(x,y);                 {draw sword}
  TextAttr := Random(15) + 1;
  Write(Chr);

  Spot := Level[x,y];          {check spot}
  case Spot of
    'V','I' : begin
            Level[x,y] := ' ';
            LowBeep
          end;
    'Y' : begin                {monster generator}
            Level[x,y] := ' ';
            CrumbleWall;
            Dec(MonsterGen)
          end;
    '0' : begin
            Mnstr := HeadMonster^.next;
            while (x <> Mnstr^.Mx) or (y <> Mnstr^.My)  {find wall}
              do Mnstr := Mnstr^.next;
            if Random(100) < (50 + Dmg * 10)  {hit: 50% + 10% strength}
              then with Mnstr^ do
                begin
                  Level[x,y] := ' ';
                  CrumbleWall;
                  Inc(IncScore,5);
                  Hits := 0;
                  prev^.next := next;
                  next^.prev := prev;
                  Dispose(Mnstr)
                end;
          end;  {moving wall}
    '1'..'9' : begin
{*}              PSound(300,50);
                 Mnstr := HeadMonster^.next;
                 while (x <> Mnstr^.Mx) or (y <> Mnstr^.My)  {find monster}
                   do Mnstr := Mnstr^.next;
                 with Mnstr^ do
                   begin
                     Dec(Hits,Dmg + 1);
                     if Hits < 1       {monster dead - remove from list}
                       then begin
                              Level[x,y] := ' ';
                              Inc(IncScore,10 * (Ord(Spot) - 48));
                              prev^.next := next;
                              next^.prev := prev;
                              Dispose(Mnstr)
                            end
                   end
               end;  {monster}
    '°' : if Random(100) < (50 + Dmg * 10)  {hit: 50% + 10% strength}
            then begin
                   Level[x,y] := ' ';
                   CrumbleWall
                 end;
    '±' : case (Random(100) - Dmg * 9) of
           -99..24 : begin                  {hit: 25% + 9% strength}
                      Level[x,y] := ' ';
                      CrumbleWall
                    end;
            25..64 : begin                  {40%}
                      Level[x,y] := '°';
                      CrumbleWall
                    end;
          end; {ToHit case}
    '²' : case (Random(100) - Dmg * 8) of
           -99..9 : begin                 {hit: 10% + 8% strength}
                      Level[x,y] := ' ';
                      CrumbleWall
                    end;
           10..24 : begin                 {15%}
                      Level[x,y] := '°';
                      CrumbleWall
                    end;
           25..69 : begin                 {45%}
                      Level[x,y] := '±';
                      CrumbleWall
                    end;
          end; {ToHit case}
    '/' : if Random(100) < (65 + Dmg * 11) {normal forest: 65% + 11% strength}
            then begin
                   Level[x,y] := ' ';
                   CrumbleWall
                 end;
    '\' : if Random(100) < (40 + Dmg * 9)   {dense forest: 40% + 9% strength}
            then begin
                   Level[x,y] := ' ';
                   CrumbleWall
                 end;
    'O' : if Random(100) < (20 + Dmg * 10)  {boulder hit: 20% + 10% strength}
            then begin
                   Level[x,y] := ' ';
{*}                CrumbleWall;  {make larger Crumble sound}
                   Inc(IncScore,1000)
                 end
          else CrumbleWall;
    ']' : begin
            GotoXY(x,y);  TextAttr := Yellow;
            Write(#31)
          end;
    '.' : begin
            GotoXY(x,y);  TextAttr := White;
            Write('ù')
          end;
  end;  {Spot}
  Delay(25);
  if not (Level[x,y] in ['0'..'9',']','.'])
    then DrawSpot(x,y)                                 {redraw old/new spot}
    else DrawMonster(x,y,Mnstr^.Hits,Mnstr^.AsciiChar)  {redraw hit monster}
end;

Procedure SwingSword(x, y, S : integer);   {S : strength}
  {* Swings sword around man - uses one power gem}
begin
  Dec(Sword);
  HitSpot(x - 1,y - 1,S,'\');
  HitSpot(x,y - 1,S,'³');
  HitSpot(x + 1,y - 1,S,'/');
  HitSpot(x + 1,y,S,'Ä');
  HitSpot(x + 1,y + 1,S,'\');
  HitSpot(x, y + 1,S,'³');
  HitSpot(x - 1,y + 1,S,'/');
  HitSpot(x - 1,y,S,'Ä');
  NoSound;
  UpdateStats
end;

Procedure FlashBorder(Cnt : integer);
  {* Flash screen border (overscan area)}
var n : integer;
begin
  for n := 1 to Cnt do
    SetBorder(Random(16));
  SetBorder(0)
end;

Procedure Teleport;
  {* Places man in random position in level}
begin
  Dec(Magic);
  UpdateStats;
  Squish3;
  FlashBorder(10);
  FlashMan;
  DrawSpot(XCord,YCord);
  repeat
    XCord := Random(64) + 1;
    YCord := Random(24) + 1
  until Level[XCord,YCord] = ' '; {find new (blank) spot}
  MU;
  FlashMan;
  PrintMan
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
           #32  : GoKey := 100;               {<ALT-D> Debug toggle}
           #98  : if DEBUG then GoKey := 101; {<Ctrl f5> + Health}
           #108 : if DEBUG then GoKey := 102; {<Alt f5>  - Health}
           #99  : if DEBUG then GoKey := 103; {<Ctrl f6> + Power}
           #109 : if DEBUG then GoKey := 104; {<Alt f6>  - Power}
           #100 : if DEBUG then GoKey := 105; {<Ctrl f7> + Magic}
           #110 : if DEBUG then GoKey := 106; {<Alt f7>  - Magic}
           #101 : if DEBUG then GoKey := 107; {<Ctrl f8> + Keys}
           #111 : if DEBUG then GoKey := 108; {<Alt f8>  - Keys}
           #94  : if DEBUG then GoKey := 109; {<Ctrl f1> + Level}
           #104 : if DEBUG then GoKey := 110; {<Alt f1>  - Level}
           else WrongKey
         end {Ch case}
    else case Ch of       {NORMAL}
           'H'      : GoKey := 10;  {Hack}
           'N'      : GoKey := 20;  {Noise}
           'M'      : GoKey := 30;  {Magic}
           'S'      : GoKey := 40;  {Save}
           'R'      : GoKey := 50;  {Restore}
           'P'      : GoKey := 80;  {Pause}
           '+'      : GoKey := 81;  {Reset messages}
           '-'      : GoKey := 82;  {No messages}
           'Q', #27 : GoKey := QUIT;
           else WrongKey
         end; {Ch case}
  RemKeys
end;

Procedure MoveMan;
  {* Moves man to new position --> keys (1 - 9)}
begin
  case GoKey of
    1 : begin          
          Dec(XCord);  Inc(YCord)
        end;
    2 : Inc(YCord);
    3 : begin
          Inc(XCord);  Inc(YCord)
        end;
    4 : Dec(XCord);
    6 : Inc(XCord);
    7 : begin
          Dec(XCord);  Dec(YCord);
          if LevelView = SideVIEW
            then if not ((Level[XCord,YCord] in ['{','}','|','~','R'])
                 or (Level[OldX,OldY] in ['R','W']))
                   then begin
                          GoKey := SPACE;  {player does not move}
                          MB
                        end
        end;
    8 : begin
          Dec(YCord);
          if LevelView = SideVIEW
            then if not ((Level[XCord,YCord] in ['{','}','|','~','R'])
                 or (Level[OldX,OldY] in ['R','W']))
                   then begin
                          G                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                umber given for keypress}
begin
  MU;
  case GoKey of
    1..9 : MoveMan;             {change player's position}
    10 : if Sword > 0           {sword}
              then SwingSword(XCord,YCord,SwordPower)
              else WrongKey;
    20 : begin                  {toggle sound on/off}
           Noise := not Noise;
           TextAttr := LightGray + Blue * 16;
           GotoXY(74,22);
           if Noise
             then Write('Off')
             else Write('On ')
         end;
    30 : if Magic > 0           {teleport scroll}
           then Teleport
           else WrongKey;
    40 : SaveGame2;             {save}
    50 : RestoreGame2;          {restore}
    80 : begin                  {pause}
           DownWhoop;
           Message('Press any key to resume...')
         end;
    81 : begin                  {reset messages}
           for i := 0 to Number_Of_Messages do
             MessageList[i] := TRUE;
           Message('All messages have been reset.')
         end;
    82 : begin                  {turn off messages}
           for i := 0 to Number_Of_Messages do
             MessageList[i] := FALSE;
           Message('Most messages have been turned off.')
         end;
    QUIT : begin                {quit game}
              PSound(700,100);  PSound(500,100);
              PSound(300,100);  PSound(100,100);
              NoSound;
              if OPMessage('Are you SURE you want to quit {Y / N}?','YN') = 'Y'
                then GameOver2(QUIT)
            end;
    100  : if ParamStr(1) = DebugStr
             then begin
                    FlashBorder(10);
                    DEBUG := not DEBUG;
                    if DEBUG
                      then Message('Debug : ON!')
                      else Message('Debug : Off')
                  end;
    101 : begin
            Inc(Health);  HighBeep;
            UpdateStats
          end;
    102 : if Health > 1
            then begin
                   Dec(Health);  LowBeep;
                   UpdateStats
                 end;
    103 : begin
            Inc(Sword);  HighBeep;
            UpdateStats
          end;
    104 : if Sword > 0
            then begin
                   Dec(Sword);  HighBeep;
                   UpdateStats
                 end;
    105 : if Magic < 255
            then begin
                   Inc(Magic);  HighBeep;
                   UpdateStats
                 end;
    106 : if Magic > 0
            then begin
                   Dec(Magic);  LowBeep;
                   UpdateStats
                 end;
    107 : if Keys < 255
            then begin
                   Inc(Keys);  HighBeep;
                   UpdateStats
                 end;
    108 : if Keys > 0
            then begin
                   Dec(Keys);  LowBeep;
                   UpdateStats
                 end;
    109 : if LevelNum < 40
            then begin
                   Inc(LevelNum);
                   LoadLevel2(LevelNum,NORMAL)
                 end;
    110 : if LevelNum > 0
            then begin
                   Dec(LevelNum);
                   LoadLevel2(LevelNum,NORMAL)
                 end;
  end; {case GoKey}
  if GoKey < 10            {if player moves...}
    then if BoundCheck     {check to make sure player is in bounds}
           then CheckPos
           else Thump
end;

(****** MONSTERS ******)

Procedure TouchMonster;
  {* Hurts/removes monster when touched, and damages player}

var  MonsPtr : Monster;

begin
  MonsPtr := HeadMonster^.next;      {find correct monster}
  while (MonsPtr^.Mx <> XCord) or (MonsPtr^.My <> YCord) do
    MonsPtr := MonsPtr^.next;
  
  case MonsPtr^.AsciiChar of
    '0' : begin    {moving wall}
        Thump;
        MB
      end;
    '1'..'7' : with MonsPtr^ do
      begin
        Dec(Health,Damage);     {damage player}
        UpdateStats;
        Dec(Hits);     {monster damaged}
        if Hits = 0
          then begin      {monster dies}
                 HighBeep;
                 Level[XCord,YCord] := ' ';
                 PrintMan;
                 prev^.next := next;    {remove monster}
                 next^.prev := prev;
                 Dispose(MonsPtr)
               end
          else begin      {monster survives}
                 DrawMonster(Mx,My,Hits,AsciiChar);
                 MidBeep;
                 MB
               end
      end; {with}
    '8'..'9' : begin
        Dec(Health,MonsPtr^.Damage);  {damage player, monster unhurt}
        UpdateStats;
        LowBeep;
        MB
      end;
  end {AsciiChar case}
end;

Procedure InsertMonster(x, y, Spd, Hts, Dmg : integer; Chr : char);
  {* Place monster in appropriate location in list}

var  before, after,         {find spot to place node}
     NewMonster : Monster;  {node to be placed}

begin
  after := HeadMonster;   {find correct location}
  while (after^.My < y) or ((after^.My = y) and (after^.Mx < x)) do
    after := after^.next;
  before := after^.prev;

  New(NewMonster);
  with NewMonster^ do
    begin
      Mx := x;        {fill in node info}
      My := y;
      Speed := Spd;
      Hits := Hts;
      Damage := Dmg;
      AsciiChar := Chr;

      next := after;             {insert in correct location}
      after^.prev := NewMonster;
      prev := before;
      before^.next := NewMonster
    end {with}
end;

Procedure MonsterInit;
  {* Creates empty linked-list for monster nodes (with Head & Tail)}

begin
  New(HeadMonster);
  New(TailMonster);
  
  with HeadMonster^ do
    begin
      Mx := 0;    {first location}
      My := 0;
      Speed := MaxInt;
      next := TailMonster;
      prev := nil
    end;
  
  with TailMonster^ do
    begin
      Mx := 65;   {last location}
      My := 25;
      Speed := MaxInt;
      next := nil;
      prev := HeadMonster
    end;
  CurMons := TailMonster
end;

Procedure MonMoveSound(var Spot : char);
  {* Sound monster makes when moving}

begin
  if Spot = ' '
    then if Noise
      then begin
             Sound(2000);  {monster moves normally}
             Delay(1);
             NoSound
           end
      else Click1          {monster gets item}
    else Delay(1)
end;

(******** ITEMS *********)

Procedure Door;
  {* Player encounters locked door}
begin
  if Keys = 0            {door is locked}
    then begin
           MB;
           {LockedDoor sound;} Thump;
           Messages(20)
         end
    else begin           {door unlocks}
           Level[XCord,YCord] := ' ';
           Dec(Keys);
           Inc(IncScore,100);
           UpdateStats;
           Whoop;
           PrintMan;
           Messages(21)
         end
end;

Procedure PushBoulder;
  {* Player pushes 'O' in same direction as player is moving}

var  Spot : char;

begin
  MoveMan;                      {check next spot in same direction}
  if not BoundCheck             {check borders}
    then begin
           MB;
           Thump;
           EXIT
         end;
  Spot := Level[XCord,YCord];
  if (Spot in ['1'..'9','','-','_','=',' '] + EatItems)
    then begin                             {rock moves}
{*}        Click1; {rolling sound;}
           if (Spot in EatItems + [''] - [' '])     {runs over item}
             then MidBeep
             else if (Spot in ['1'..'9'])  {flattens monster}
                    then begin
                           ZapMonster(XCord,YCord);
                           HighBeep
                         end;
           Level[XCord,YCord] := 'O';
           DrawSpot(XCord,YCord);
           MB;  MoveMan;               {move man behind rock}
           Level[XCord,YCord] := ' ';
           PrintMan
         end
    else case Spot of
      'Z' : begin         {hits force field - both destroyed}
            FlashBorder(2);
            GotoXY(XCord,YCord);
            TextAttr := LightRed;
            Write('X');
{*}         {sizzle sound;}  Squish2;
            FlashBorder(2);
            Level[XCord,YCord] := ' ';
            DrawSpot(XCord,YCord);
            MB;  MoveMan;
            Level[XCord,YCord] := ' ';
            PrintMan;
            Inc(IncScore,100)
          end;
    'ð','S','W','L',
    '#' : begin           {boulder falls down hole of some type}
            MB;  MoveMan;        {put man at boulder's position}
            Level[XCord,YCord] := ' ';
            PrintMan;  MU;
            MoveMan;                  {go to pit's position... }
            TextAttr := LightGray;
            for i := 1200 downto 35 do {...and drop boulder in!}
              begin
                if Noise
                  then Sound(i);
                GotoXY(XCord,YCord);
                case i of
                  1200 : Write('O');
                  1100 : Write(#9 );
                  800  : Write('ù');
                  400  : Write('ú');
                  50   : DrawSpot(XCord,YCord)
                end  {i case}
              end;
            NoSound;
            MB
          end;
    else begin      {boulder can't move - something blocks it}
           Thump;
           Dec(Score,5);
           UpdateStats;
           MB
         end
    end; {Spot case}
  Messages(31)
end;

Procedure PushBlock;
  {* Pushes 'þ' in same direction as player moves}
  {* NOTES: can smash gems/chests}

var Bx, By : integer;   {hold block's position}
    Spot : char;

begin
  repeat                  {more than one can be pushed}
    Click3;    {short push sound}
    MoveMan
  until (Level[XCord,YCord] <> 'þ') or (not BoundCheck);  
  if not BoundCheck
    then begin
           MB;
           Thump;
           EXIT
         end;
  Spot := Level[XCord,YCord];
  case Spot of
    '-','_',
    ' ' : begin                     {block(s) pushed forward}
            Level[XCord,YCord] := 'þ';
            DrawSpot(XCord,YCord);
            MB;  MoveMan; 
            Level[XCord,YCord] := ' ';
            PrintMan
          end;
    '+','ô',
    'C' : begin                     {block(s) smash item}
            Squish2;
            Level[XCord,YCord] := 'þ';
            DrawSpot(XCord,YCord);
            MB;  MoveMan;
            Level[XCord,YCord] := ' ';
            PrintMan
          end;
    'ð','S','W','L',
    '#' : begin                     {end block falls in pit}
            Bx := XCord;  
            By := YCord;
            MB;  MoveMan;  PrintMan;  MU;
            Level[XCord,YCord] := ' ';
            for i := 1200 downto 35 do
              begin
                if Noise
                  then Sound(i);
                GotoXY(Bx,By);
                case i of
                  1200 : begin
                           TextAttr := LightCyan + Cyan * 16;
                           Write(#9)
                         end;
                  1100 : begin
                           TextAttr := LightCyan;
                           Write('þ')
                         end;
                  800  : begin
                           TextAttr := Cyan;
                           Write('ù')
                         end;
                  400  : begin
                           TextAttr := Blue;
                           Write('ú')
                         end;
                  50   : DrawSpot(Bx,By);
                end  {i case}
              end;
            NoSound;
            MB
          end;
    'Z' : begin      {force field destroys block}
            FlashBorder(2);
            GotoXY(XCord,YCord);
            TextAttr := LightRed + LightGray * 16;
            Write('±');
{*}         Squish2;         {get my old Crumble sound}
            FlashBorder(2);
            DrawSpot(XCord,YCord);
            MB;
            MoveMan;
            Level[XCord,YCord] := ' ';
            PrintMan;
            Inc(IncScore,50)
         end;
    else begin    {block can't move - something in the way}
           Thump;
           Dec(Score,5);
           UpdateStats;
           MB
         end
  end; {Spot case}
  Messages(32)
end;

Procedure InvWallsTrap;
  {* Turns wall sections in the level invisible}

var  Wx, Wy, WallsToDo : integer;

begin
  Level[XCord,YCord] := ' ';
  PrintMan;
  GetSkill2(WallsToDo,75,100,125);
  i := 1;
  while i < WallsToDo do
    begin
      Num := 1;
      repeat
        Wx := Random(64) + 1;
        Wy := Random(24) + 1;
        Inc(Num)
      until (Level[Wx,Wy] = 'Û') or (Num > 2000);
      if Num > 2000
        then i := WallsToDo  {can't find wall to change}
        else begin
               PSound(2000 + Random(3000),2);
               Level[Wx,Wy] := ':';
               DrawSpot(Wx,Wy);
               NoSound
             end;
      Inc(i)
    end;
  Messages(41)
end;

Procedure TeleportTrap;    
  {* Teleports player to random blank spot in level}
begin       
  Dec(Score,50);
  UpdateStats;
  Level[XCord,YCord] := ' ';
  PrintMan;  MU;
  for i := 0 to 50 do    {player disappears w/ crackle sound}
    begin
      FlashBorder(1);
      PSound(Random(2000) + 530 - (i * 10),5);  {tone lowers}
      GotoXY(XCord,YCord);
      TextAttr := Random(127) + 1;
      Write(#1)
    end;
  NoSound;
  repeat          {get new spot - (x,y)}
    XCord := Random(64) + 1;
    YCord := Random(24) + 1
  until Level[XCord,YCord] = ' ';
  PrintMan;  MU;
  FlashMan;
  PrintMan;
  Messages(24)
end;

Procedure GetChest;
  {* Gives player health & power gems}

var  H, P : integer;
    sH, sP : string[2];

begin
  Prize; {Cash sound/bonus}
  GetSkill2(H,Random(8) + 2,Random(6) + 2,Random(4) + 2);
  GetSkill2(P,Random(5) + 2,Random(4) + 2,Random(3) + 2);
  Inc(Health,H);
  Inc(Sword,P);
  UpdateStats;
  Inc(IncScore,H * 10 + P * 10);
  Str(H,sH);
  Str(P,sP);
  GoldMessage('You found ' + sH + ' health gems and ' + sP + ' power gems in the chest!')
end;

Procedure RevealGems(GemsLeft : integer);
  {* Randomly places gems around the screen}

var  Gx, Gy : integer;

begin
  repeat
    Gx := Random(64) + 1;
    Gy := Random(24) + 1;
    if Level[Gx,Gy] in [' ','-']
      then begin              {place one gem}
             PSound(Random(2000) + 35,20);
             NoSound;
             Dec(GemsLeft);
             if Random(100) > 70
               then Level[Gx,Gy] := 'ô'
               else Level[Gx,Gy] := '+';
             DrawSpot(Gx,Gy);
             Delay(70)
           end;
  until GemsLeft = 0;
  NoSound;
  Message('Wah Hoo! You found an Unearth Buried Gems scroll!')
end;

Procedure MagicSpear(OffSet, x, y : integer);
  {* Magic spear fires, destroys all monsters + EatItems}

var  Spot      : char;
     StopSpear : boolean;

  Procedure DrawSpear(x, y : integer);
    {* Draws magic spear on screen at (x,y)}
  begin
    GotoXY(x,y);
    TextAttr := Random(15) + 1;
    Write('-')
  end;

begin
  StopSpear := FALSE;
  Snd1 := 150;
  while (not StopSpear) and (x > 0) and (x < 65) do
  begin
    Spot := Level[x,y];
    if (Spot in SmashItems + ['Û'..'ß','a'..'z','^','T','O','þ','/','\','F'])
      then StopSpear := TRUE            {spear stops}
      else if (Spot in EatItems + ['-','é']) {spear destroys}
        then begin
                Level[x,y] := ' ';
                DrawSpear(x,y);
                PSound(300,10)
              end
        else if (Spot in ['1'..'9'])
               then begin                 {monsters killed}
                 ZapMonster(x,y);
                 DrawSpear(x,y);
                 PSound(300,10)
               end
         else if Spot = 'Y'
                then begin
                       Level[x,y] := ' ';
                       DrawSpear(x,y);
                       PSound(500,10);
                       Dec(MonsterGen)
                     end
        else DrawSpear(x,y);              {spear goes over}
    if Noise
      then Sound(Snd1);
    Dec(Snd1,2);
    Delay(50);           {draw spear & make sound...}
    DrawSpot(x,y);       {...then update spot; go to next in spear's path}
    Inc(x,OffSet)
  end;
  NoSound
end;

Procedure BombItem(x,y : integer);
  {* Decides if item at (x,y) is destroyed by magic bomb}
  {* NOTES: inv. door not affected, magic spear is}
begin
  case Level[x,y] of
    '°'..'²','/','V','é','-','_','=','H','X','!','<','>',
    ' ' : begin
            PSound(100,2);
            Level[x,y] := ' ';
            GotoXY(x,y);
            TextAttr := Red * 16;
            Write(' ')
          end;
    '0'..'9' : begin
                 PSound(70,2);
                 ZapMonster(x,y);
                 GotoXY(x,y);
                 TextAttr := Red * 16;
                 Write(' ')
               end;
    else PSound(35,2)
  end {case Level[x,y]}
end;

Procedure MagicBomb;
  {* Destorys all smashable items in radius of 5 around player}
begin
  Level[XCord,YCord] := ' ';
  PrintMan;
  for i := 50 to 1050 do {warm-up sound}
    PSound(i,1);
  SetBorder(White);
  for i := 3000 downto 50 do
    PSound(i,0);
  for i := 1 to 5 do    {explodes outward from player}
    begin
      SetBorder(Red + Random(2) * 8);
      if (YCord - i) > 0
        then for j := (XCord - i) to (XCord + i) do
               if (j > 0) and (j < 65)
                 then BombItem(j,YCord - i);
      if (XCord - i) > 0
        then for j := (YCord - i + 1) to (YCord + i - 1) do
               if (j > 0) and (j < 25)
                 then BombItem(XCord - i,j);
      if (XCord + i) < 65
        then for j := (YCord - i + 1) to (YCord + i - 1) do
               if (j > 0) and (j < 25)
                 then BombItem(XCord + i,j);
      if (YCord + i) < 25
        the                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  NoSound;
  PrintMan;
  Inc(SwordPower);
  UpdateStats;
  Messages(37)
end;

Procedure MonsterZap(NumToZap : integer);
  {* Removes NumToZap monsters in level}

var  Trav   : Monster;  {traverses monster list}
     Zx, Zy : integer;

begin
  Trav := HeadMonster^.next;
  repeat
    for Num := 1 to (5 + Random(50)) do {get random monster}
      begin
        if Trav^.next = nil         {at end of list -- go to head}
          then begin
                 Trav := HeadMonster^.next;
                 if Trav^.next = nil
                   then EXIT   {all monsters gone - spell is done}
               end;
        Trav := Trav^.next
      end;
    if Trav^.next = nil
      then Trav := HeadMonster^.next;
    Zx := Trav^.Mx;
    Zy := Trav^.My;
    Trav := Trav^.next;
    
    GotoXY(Zx,Zy);
    TextAttr := Random(3) + LightMagenta;  {or Yellow or White}
    Write(#15);
{*} Click2;  {sound effect}
    
    ZapMonster(Zx,Zy);   {remove monster}
    Dec(NumToZap);
  until NumToZap = 0
end;

Procedure CreateMonsters(NumToMake : integer; MonTypes : string);
  {* Places NumToMake monsters into level}
  {* Monster types are listed in MonTypes}

var  Rx, Ry, Mon : integer;

begin
  repeat
    Num := 1;
    repeat                   {find (x,y) position for monster}
      Rx := Random(64) + 1;
      Ry := Random(24) + 1;
      Inc(Num)
    until (Level[Rx,Ry] = ' ') or (Num = 200);
    if Num = 200
      then EXIT;    {can't find blank spot to place monster}

    Mon := Ord(MonTypes[Random(Length(MonTypes)) + 1]) - 48; {choose monster}
    Level[Rx,Ry] := Chr(Mon + 48);
    InsertMonster(Rx,Ry,
      MonSpeed[Mon],MonHits[Mon],MonDmg[Mon],Chr(Mon + 48));
    DrawMonster(Rx,Ry,MonHits[Mon],Chr(Mon + 48));
    {sound effect} Click1;
    Dec(NumToMake)
  until NumToMake = 0
end;

Procedure Surround(Item, DisplayChar : char; DisplayColor : integer);
  {* Places char Item in all blank spots adjacent to player}

var  BlankSpots : array[-1..1,-1..1] of boolean;
         Px, Py : integer;
begin
  Level[XCord,YCord] := 'P';
  PrintMan;
  for Px := (XCord - 1) to (XCord + 1) do    {place items around man}
    for Py := (YCord - 1) to (YCord + 1) do
      if (Px >= 1) and (Px <= 64) and (Py >= 1) and (Py <= 24) and
         (Level[Px,Py] in [' ','-'])
        then begin                   {place item}
               Level[Px,Py] := Item;
               BlankSpots[Px - XCord,Py - YCord] := TRUE
             end
        else BlankSpots[Px - XCord,Py - YCord] := FALSE;
  
  for Num := 4 to 28 do       {flash items}
    begin
      PSound(Num * 10,40);
      TextAttr := DisplayColor + (Random(15) + 1) * 16;
      for Px := -1 to 1 do
        for Py := -1 to 1 do
          if BlankSpots[Px,Py] 
            then begin
                   GotoXY(Px + XCord,Py + YCord);
                   Write(DisplayChar)
                 end
    end;
  
  NoSound;
  for Px := -1 to 1 do       {draw items normally}
    for Py := -1 to 1 do
      if BlankSpots[Px,Py]
        then DrawSpot(Px + XCord,Py + YCord);
  Level[XCord,YCord] := ' '
end;

Procedure RopeExtend(RopeCh : char);
  {* Extends rope from character RopeCh}

var  Rx, Ry : integer;

begin
  Rx := 1;
  Ry := 1;
  while (Level[Rx,Ry] <> RopeCh) and (Ry < 25) do  {find rope to extend}
    begin
      Inc(Rx);
      if Rx > 64
        then begin
               Inc(Ry);
               Rx := 1
             end
    end;
  
  Level[Rx,Ry] := ' ';
  Num := 50;
  while (Level[Rx,Ry + 1] in [' ','+','ô','0'..'9','{','}','|','~']) and (Ry < 24) do
    begin                           {extend rope until it reaches an item}
      PSound(Num - 25,25);
      GotoXY(Rx,Ry);
      TextAttr := Random(15) + 1;
      Write(#25);
      PSound(Num,75);
      Level[Rx,Ry] := 'R';
      if not ((Rx = XCord) and (Ry = YCord))
        then DrawSpot(Rx,Ry)        {draw rope}
        else begin
               MU; PrintMan;
               OldSpot := 2         {rope forms on player's spot}
             end;
      Inc(Ry);                      {check next lower spot}
      Inc(Num,50)
    end;
  NoSound
end;

Procedure CheckPos;
  {* Status of player's location on board - action taken}

var  Spot : char;

begin
  Spot := Level[XCord,YCord];
  case Spot of
    ' ' : begin                  {blank}
            if GoKey <> 0        {no sound when falling}
              then FootFalls;
            PrintMan
          end;
    '-' : begin                  {monster no-move spot (removeable)}
            Level[XCord,YCord] := ' ';
            FootFalls;
            PrintMan
          end;
    '_' : begin                  {connected monster no-move spots}
            FootFalls;
            PrintMan;
            RemNoMoveSpots(XCord,YCord)
          end;
    '=' : begin                  {monster no-move spot (non-removeable)}
            FootFalls;
            PrintMan
          end;
    'R' : begin                  {rope}
            PrintMan;
            OldSpot := 2
          end;
    '°'..'²','0','a'..'z',
    'Û'..'ß' : begin             {walls}
            MB;
            Dec(Score,5);
            UpdateScore;
            if Random(2) = 1
              then Thump
              else HitWall;
            case Spot of
              'Û'..'ß',               {solid}
              'a'..'z' : Messages(1);  {message char}
              '²' : Messages(2);       {3-hit wall}
              '±' : Messages(3);       {2-hit wall}
              '°' : Messages(4);       {1-hit wall}
              '0' : Messages(5);       {moving wall}
            end {case}
          end;
    ':' : begin                  {inv. wall}
            Level[XCord,YCord] := 'Û';
            DrawSpot(XCord,YCord);
            MB;
            PrintMan;
            if Level[XCord,YCord] = 'R'  {fixes bug/feature}
              then OldSpot := 2;
            Thump;
            Messages(6)
          end;
    ';' : begin                  {inv. crumbled wall}
            Level[XCord,YCord] := '°';
            DrawSpot(XCord,YCord);
            MB;
            PrintMan;
            if Level[XCord,YCord] = 'R'
              then OldSpot := 2;
            Thump;
            Messages(7)
          end;
    '.' : InvWallsTrap;           {invisible walls trap}
    'º','Í' : begin               {bridge rail}
            MB;
            Dec(Score,10);
            UpdateScore;
            Thump;
            Messages(9)
          end;
    'T' : begin                  {tree}
            MB;
            Dec(Score,20);
            UpdateScore;
            Thump;
            Messages(10)
          end;
    '^' : begin                  {immovable boulder}
            MB;
            Dec(Score,20);
            UpdateScore;
            Thump;
            Messages(30)
          end;
    '/','\' : begin              {forest}
            MB;
            Dec(Score,10);
            UpdateScore;
            Thump;
            if Spot = '/'
              then Messages(11)
              else Messages(12)
          end;
    'L' : begin                  {lava}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Toast;
            for i := 1 to 5 do
              begin
                SetBorder(Red);
                SetBorder(LightRed);
                SetBorder(Red);
                SetBorder(Black)
              end;
            Dec(Health,10);
            Inc(IncScore,1000);
            UpdateStats;
            Messages(13)
          end;
    'W' : if LevelView = TopVIEW {water}
            then begin
                   MB;
                   Dec(Score,10);
                   UpdateScore;
                   Fizz2;
                   Messages(14)
                 end
            else begin
                   ManColor := LightCyan + Blue * 16;
                   PrintMan;
                   OldSpot := 3;
                   Messages(40)
                 end;
    'Z' : begin                  {force field}
            MB;
            GotoXY(XCord,YCord);  TextAttr := ManColor;  Write(#2);
            Dec(Score,15);
            Dec(Health);
            UpdateStats;
            for i := 1 to 3 do
              begin
                SetBorder(Yellow);
                SetBorder(White);
                SetBorder(LightGray);
                SetBorder(Red)
              end;
              SetBorder(0);
{*            Electric Zap;} Squish3;
            Messages(8)
          end;
    '#' : begin                  {bottomless pit}
            PrintMan;
            Message('Oops -- you find yourself over a large chasm... (Bye!)');
            if LevelView = TopVIEW
              then BottomlessPit
              else SidewaysPit;
            SetBorder(LightRed);
            Squish1;
            SetBorder(0);
            Window(1,1,65,25);
            Message('* SPLAT *');
            RemKeys;
            if LevelView = SideVIEW
              then Health := -100    {no flashing '*'}
              else Health := -1;     {flashing '*'}
            UpdateStats
          end;
    'U' : SecretTunnel;          {tunnel}
    '1'..'9' : TouchMonster;     {monsters}
    '+','G' : begin              {health gem}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Click2;
            Inc(Health);
            Inc(IncScore,10);
            UpdateStats;
            if Spot = '+' then Messages(16)
          end;
    'ô' : begin                  {power gem}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Click2;
            Inc(Sword);
            Inc(IncScore,10);
            UpdateStats;
            Messages(17)
          end;
    'M' : begin                  {magic}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Click3;
            Inc(Magic);
            Inc(IncScore,50);
            UpdateStats;
            Messages(18)
          end;
    'å' : begin                  {key}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Click3;
            Inc(Keys);
            UpdateStats;
            Messages(19)
          end;
    'é' : Door;                  {locked door}
    'D' : begin                  {inv. locked door}
            Level[XCord,YCord] := 'é';
            DrawSpot(XCord,YCord);
            MB;
            Thump;
            Messages(22)
          end;
    'C' : begin                  {treasure chest}
            Level[XCord,YCord] := ' ';
            PrintMan;
            GetChest
          end;
    '*' : begin                  {treasure}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Click1;
            Inc(IncScore,500);
            Messages(23)
          end;
    'I' : begin                  {blindness potion}
            Level[XCord,YCord] := ' ';
            ManColor := Black;
            PrintMan;
            for Num := 1 to 4 do  {cloaking sound};
              begin
                PSound(1200,30);
                NoSound;
                Delay(20)
              end;
            GetSkill2(InvisiMan,200,250,300);
            Messages(29)
          end;
    'O' : PushBoulder;           {boulder}
    'þ' : PushBlock;             {moveable block}
    'V' : TeleportTrap;          {teleport trap}
    'J' : begin                  {reveal gems}
            Level[XCord,YCord] := ' ';
            PrintMan;
            GetSkill2(Num,20 + Random(6),13 + Random(10),6 + Random(14));
            RevealGems(Num)      {6 - 25 gems}
          end;
    'F' : begin                  {freeze monsters}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Whistle1;
            GetSkill2(Freeze,300,250,200);
            Messages(33)
          end;
    'A' : begin                  {slow monsters}
            Level[XCord,YCord] := ' ';
            PrintMan;
            DownSpike1;
            GetSkill2(Slow,300,250,200);
            if Haste > 0  {opposing spells nullify}
              then begin
                     Dec(Slow,Haste);
                     Haste := 0
                   end;
            Messages(34)
          end;
    'Q' : begin                  {haste monsters}
            Level[XCord,YCord] := ' ';
            PrintMan;
            WarpUp3;
            GetSkill2(Haste,200,250,300);
            if Slow > 0   {Slow nullifies Haste}
              then begin
                     Dec(Haste,Slow);
                     Slow := 0
                   end;
            Messages(35)
          end;
    '<','>' : begin              {magic spear}
            Level[XCord,YCord] := ' ';
            PrintMan;
            if Spot = '<'         
              then MagicSpear(-1,XCord - 1,YCord)   {fires left } 
              else MagicSpear(+1,XCord + 1,YCord);  {fires right}
            Messages(36)
          end;
    '' : MagicBomb;             {magic bomb}
    '¨' : SwordPowerUp;          {sword power-up}
    '[' : begin                  {monster zap}
            Level[XCord,YCord] := ' ';
            PrintMan;
            GetSkill2(Num,25 + Random(26),23 + Random(23),21 + Random(20));
            MonsterZap(Num);          {21 - 50 monsters}
            Messages(38)
          end;
    ']' : begin                  {create monsters}
            Level[XCord,YCord] := ' ';
            PrintMan;
            GetSkill2(Num,13 + Random(18),15 + Random(21),17 + Random(24));
            CreateMonsters(Num,'1');  {13 - 40 monsters}
            Messages(39)
          end;
    'Y' : begin                  {monster generator}
            MB;
            Thump;
            Message('You have discovered a Creature Summoner!')
          end;
    'H' : Surround('Û','Û',WallColor); {Surround: Solid Wall}
    'B' : Surround('O','O',LightGray);         {: Boulder}
    '!' : Surround('I','!',Green);             {: Blindness Potion}
    'N' : Surround('*',#15,Yellow);            {: Relic}
    'ñ' : Surround('+', #4,Random(15) + 1);    {: Health Gem}
    'ø' : Surround('ô', #9,Random(15) + 1);    {: Power Gem}
    'X' : Surround('°','°',WallColor);         {: 1-hit Wall}
    ',' : Surround('/','±',LightGreen);        {: Forest}
    '?' : begin                  {pouch of gems}
            Level[XCord,YCord] := ' ';
            PrintMan;
            Click3;
            GetSkill2(Num,15 + Random(11),14 + Random(9),13 + Random(7));
            Inc(Health,Num);             {13 - 25 health gems}
            Str(Num,NumStr);
            UpdateStats;
            GoldMessage('You found a pouch holding ' + NumStr + ' health gems!')
          end;
    '{','}','|','~' : begin      {rope extend (types 1 - 4)}
            Level[XCord,YCord] := ' ';
            PrintMan;
            RopeExtend(Spot)
          end;
    '(' : DoSpecial(Specials[1],'('); {level special #1}
    'ú' : DoSpecial(Specials[2],'ú'); {level special #2}
    ')' : DoSpecial(Specials[3],')'); {level special #3}
    'ð' : begin
            PrintMan;
            DownStairs1;
            Messages(27);
            Inc(IncScore,LevelNum * 100);
            repeat
              AddScore(IncScore)     {add points not yet tallied}
            until IncScore = 0;
            Inc(LevelNum);
            if TestLevel = TEST         {normal stairs}
              then begin
                     ExitGame := TRUE;    {sample level has been played}
                     ExitProg := TRUE
                   end
              else LoadLevel2(LevelNum,NORMAL)
          end;
    'S' : begin
            PrintMan;
            DownStairs1;
            Messages(28);
            Inc(IncScore,LevelNum * 200);
            repeat
              AddScore(IncScore)
            until IncScore = 0;
            Inc(LevelNum);
            if TestLevel = TEST         {secret stairs}
              then begin
                     ExitGame := TRUE;
                     ExitProg := TRUE
                   end
              else LoadLevel2(LevelNum,SPECIAL)
          end;
  end  {Spot case}
end;   {CheckPos}

Procedure MoveMonsters;
  {* Moves all monsters according to their pattern, from CurMons one on}

var    Temp   : Monster;  {holds monster to be zapped}
       Cntr,              {if KeyPressed, then move 25 monsters and EXIT}
       Speed,             {movement speed of current monster}
       Wx, Wy,            {if monster hits moving wall : '0'}
       Ox, Oy : integer;  {monster's old pos}
       Spot   : char;     {Level[Mx,My]}

begin
  if CurMons^.next = nil               {if at end of list, go to beginning}
    then CurMons := HeadMonster^.next;
  Cntr := 0;
  while (CurMons^.next <> nil) do      {while before TailMonster}
    begin
      Speed := CurMons^.Speed;
      if Haste > 0                     {adjust monster speeds}
        then Speed := Speed div 2
        else if Slow > 0
          then Speed := Speed * 2;
      while (CurMons^.next <> nil) and ((Moves mod Speed) <> 0) do
        begin                          {monster can't move yet...check next}
          CurMons := CurMons^.next;    
          Speed := CurMons^.Speed;     
          if Haste > 0                 {adjust speed}
            then Speed := Speed div 2
            else if Slow > 0
              then Speed := Speed * 2
        end;
      if CurMons^.next = nil
        then EXIT;                     {at end of list}
      if KeyPressed and (Cntr >= 20)   {interrupt after 20 monsters...}
        then begin                     {...if player's move is ready}
               Dec(Moves);             {move rest of monsters next turn}
               EX                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                d
                then Inc(My);

          Spot := Level[Mx,My];        {item monster moves onto}

          if (Spot in EatItems)
            then case AsciiChar of
                   '0' : if ((Mx = XCord) and (My = YCord))  {Moving Wall}
                            or (Spot <> ' ')
                     then begin
                            Mx := Ox;  {wall runs into player or item}
                            My := Oy
                          end
                     else begin               {normal move}
                            Level[Ox,Oy] := ' ';
                            DrawSpot(Ox,Oy);    {erase old spot}
                            Level[Mx,My] := AsciiChar;  {draw new spot}
                            DrawMonster(Mx,My,Hits,AsciiChar);
                            MonMoveSound(Spot)
                          end;
                   '1'..'7' : if (Mx = XCord) and (My = YCord)  {* NORMAL *}
                     then begin                       {monster hits player}
                            Dec(Health,Damage);
                            UpdateStats;
                            Dec(Hits);        {monster hurt}
                            if Hits = 0
                              then begin      {monster dies}
                                     HighBeep;
                                     Level[Ox,Oy] := ' ';  {spot is valid}
                                     DrawSpot(Ox,Oy);      {erase old spot}
                                     prev^.next := next;   {remove from list}
                                     next^.prev := prev;
                                     Temp := CurMons
                                   end
                              else begin      {monster lives}
                                     MidBeep;
                                     Mx := Ox;
                                     My := Oy;
                                     DrawMonster(Mx,My,Hits,AsciiChar)
                                   end
                          end {hits player}
                     else begin                            {normal move}
                            Level[Ox,Oy] := ' ';
                            DrawSpot(Ox,Oy);               {erase old spot}
                            if Level[Mx,My] <> ' '
                              then Click1;                 {eating sound}
                            Level[Mx,My] := AsciiChar;     {draw new spot}
                            DrawMonster(Mx,My,Hits,AsciiChar);
                            MonMoveSound(Spot)
                         end;
                   '8'..'9' : if (Mx = XCord) and (My = YCord)  {Undead}
                          then begin          {hits player}
                                 Mx := Ox;
                                 My := Oy;
{*}                              HighBeep;    {short sizzle sound}
                                 Dec(Health,Damage);
                                 UpdateStats
                               end
                          else begin          {normal move}
                                 Level[Ox,Oy] := ' ';
                                 DrawSpot(Ox,Oy);
                                 Level[Mx,My] := AsciiChar;
                                 DrawMonster(Mx,My,Hits,AsciiChar);
                                 MonMoveSound(Spot)
                               end;
                 end  {case AsciiChar - Spot in EatItems}
            
            else if (Spot in SmashItems)
                   then if AsciiChar = '0'
                           then begin           {wall hits wall}
                                  Mx := Ox;
                                  My := Oy
                                end
                           else begin       {AsciiChar = '1'..'9'}
                                  Dec(Hits);
                                  if (Spot in [#176..#178])  {damage wall}
                                    then begin
                                           Level[Mx,My] := Chr(Ord(Spot) - 1);
                                           if Level[Mx,My] < #176
                                             then Level[Mx,My] := ' ';
                                           DrawSpot(Mx,My);
                                           Mx := Ox;
                                           My := Oy
                                         end
                                    else begin     {Spot = '0'}
                                           Wx := Mx;
                                           Wy := My;
                                           Mx := Ox;
                                           My := Oy;
                                           ZapMonster(Wx,Wy)  {remove wall}
                                         end;
                                  if Hits = 0 
                                    then begin           {remove from list}
                                           Level[Ox,Oy] := ' ';
                                           DrawSpot(Ox,Oy);
                                           prev^.next := next;
                                           next^.prev := prev;
                                           Temp := CurMons
                                         end
                                    else DrawMonster(Mx,My,Hits,AsciiChar);
                                  MidBeep;
                                  NoSound
                                end    {AsciiChar = '1'..'9'}
                   
                   else begin        {monster doesn't move}
                          Mx := Ox;  
                          My := Oy
                        end;  {Spot NOT in EatItems OR SmashItems}

          if Temp <> nil
            then Dispose(Temp);  {remove dead monster}
          CurMons := next
        end  {with CurMons^}
    end  {CurMons^.next <> nil}
end;  {MoveMonsters}

Procedure GenerateMonster(var ToCreate : integer);
  {* Places monster onto screen}

var  Cntr, Nx, Ny, Mons : integer;

begin
  Cntr := 1;
  repeat
    Nx := Random(64) + 1;
    Ny := Random(24) + 1;
    Inc(Cntr)
  until (Level[Nx,Ny] = ' ') or (Cntr > 2000);
  if Cntr > 2000
    then EXIT;    {could not find spot to place monster}

  Mons := Random((ToCreate mod 10)) + 1;  {choose monster}
  Level[Nx,Ny] := Chr(Mons + 48);
  InsertMonster(Nx,Ny,
    MonSpeed[Mons],MonHits[Mons],MonDmg[Mons],Chr(Mons + 48));
  DrawMonster(Nx,Ny,MonHits[Mons],Chr(Mons + 48));
  {sound effect} Click3
end;

Procedure MonstersFall;
  {* Monsters fall down one space on side-view levels}

var  Hold, Trav : Monster;

begin
  Trav := HeadMonster^.next;
  while Trav^.next <> nil do  {check all monsters}
    with Trav^ do
      begin
        if (My < 24)
          then if not (Level[Mx,My + 1] in StandItems + ['U','0'..'9','Z',
            ':',';','D',']','{','}','|','~','¨','(',')','$'])
                 then begin                          {does monster fall?}
                        Level[Mx,My] := ' ';
                        DrawSpot(Mx,My);
                        Inc(My);
                        if (Level[Mx,My] in ['#','W','L'])
                          then begin
{*}                              Hold := Trav^.prev; {need this?}
                                 Dec(My);
                                 ZapMonster(Mx,My);
                                 Trav := Hold
                               end
                          else begin
                                 Level[Mx,My] := AsciiChar;
                                 DrawMonster(Mx,My,Hits,AsciiChar)
                               end
                      end;
        Trav := Trav^.next
      end
end;

Procedure ManFalls;
  {* Player falls down one space on side-view levels}
begin
  if (YCord < 24)
    then begin
           MU;
           if Level[XCord,YCord] <> 'R'  {if man is not holding onto Rope}
             then Inc(YCord);
           GoKey := 0;    {no direction}
           if (Level[XCord,YCord] in StandItems)
             then MB        {player can stand on item}
             else begin
                    DrawSpot(OldX,OldY);
                    CheckPos  {player falls onto item}
                  end
         end
end;

Procedure CheckSpot;
  {* On SideVIEW levels - player interacts with character he stands on}
begin
  case Level[XCord,YCord] of
    '1'..'9' : TouchMonster;  {monster & player overlap}
    'W' : begin               {player is drowning}
            OldSpot := 3;
            PSound(5000,5);
            NoSound;
            Dec(Health);
            UpdateStats
          end
    else ManColor := Yellow;
  end; {(x,y) case}
end;

Procedure GameLoop;
  {* Repeats movement checks & executes move}
begin
  repeat
    SetNumLock(OFF);
    Inc(Moves);
    if IncScore > 0
      then AddScore(IncScore);    {count points yet to be tallied}
    if (LevelView = SideVIEW) and ((Moves mod 3) = 0)
      then begin
             MonstersFall;        {gravity pulls monsters down}
             ManFalls;            {gravity pulls man down}
             CheckSpot            {if player is on certain item}
           end;
    if KeyPressed          {key was hit}
      then begin
             GetKeyPress;  {player's move read from keyboard}
             Action
           end;
    if Health < 0
      then begin
             GameOver2(DIES);     {no health -- player has perished}
             EXIT
           end;
    if Freeze = 0                 {monsters move (if not frozen)}
      then MoveMonsters;
    Num := Random(50) + 1;
    if Num <= MonsterGen
      then GenerateMonster(Num);  {monster generated}
    if Invisiman > 0
      then begin
             Dec(Invisiman);
             if InvisiMan = 0     {player reappears}
               then begin
                      ManColor := Yellow;
                      PrintMan
                    end
           end;
    if Freeze > 0 then Dec(Freeze);
    if Slow   > 0 then Dec(Slow);
    if Haste  > 0 then Dec(Haste);
    Delay(GameDelay)              {place DELAY here?}
  until ExitGame
end;

Procedure GameInit;
  {* Initializes factors for game}
begin
  ExitGame := FALSE;
  MonsterInit;
  for i := 0 to Number_Of_Messages do
    MessageList[i] := TRUE;       {TRUE  = Messages will be displayed}
  PrintStatusWindow;
  ManColor := Yellow;
  OldSpot := 0;
  IncScore := 0;

  if ParamCount >= 2
    then begin
           Val(ParamStr(1),LevelNum,i);  {start on level ParamStr(1)}
           Val(ParamStr(2),TestLevel,i)  {test one level}
         end
    else LevelNum := 1;
  SkillLevel := NOVICE;
  Score := 0;
  SwordPower := 0;  {normal strength}
  if TestLevel = TEST
    then begin
           Health := 250;
           Sword := 100;
           Magic := 50;
           Keys := 10
         end
    else begin
           GetSkill2(Health,25,10,5);
           Sword := 0;
           Magic := 0;
           Keys := 0
         end;
  UpdateStats;

  LoadLevel2(LevelNum,NORMAL)
end;

begin  (* Main Game Procedure *)
  Randomize;
  NoSound;
  ExitProg := FALSE;
  Noise := TRUE;          {sound ON - default}
  GameDelay := 35;        {SLOW computer - default}
  DEBUG := FALSE;         {Debug mode OFF - default}
  DLevel.Alg := DrawEditSpot;   {Procedure used to draw levels}
  Assign(LevelF,'meredit.lvl');
  Assign(ScoreF,'meredit.hs');
  Reset(LevelF);
  CursorOff;
  repeat
    GameInit;
    GameLoop
  until ExitProg;
  CursorOn;
  Writeln
end.
