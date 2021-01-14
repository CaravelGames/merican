Program MericanCity;  {created by Michael Rimer}
                      {last worked on: 7 JUN 93}

Uses Sounds2, CLevels, CityUnit, Crt;

const  FlowItems = [' ','-','ы',#24,'х','ш','H','*','ј','I','V','љ','і','ф',
                   'a','c'..'e','h'..'k','q'..'x','z','`',#20,#39];
       EatItems = [' ','ы',#24,'х','ш','H','*','r'..'v'];
       FlySpots = [' ','-',#39,'`','R','T','q','w','s','a','d','z','x','c',
                   #179..#218,'W','L','#','ф','і','љ','ј','=',#20,'@','F',#15];

var
                          N : Array[1..15] of String[20];
                          S : Array[1..15] of longint;
                          L : Array[1..15] of char;
                      Spots : Array[1..8] of boolean;
            Debug, DebugOn,
           GenBool, FuncKey : boolean;
            FirstX, FirstY,
      MonsterMove, GoodStep : integer;

{Procedure listings --->
   QuitGame
   CreateSList      <High Scores>
   ScorePlace
   NewHiScore
   PrintMerits
   PlaceNewMerit
   HiScores
   NoPower         <Screen stats>
   PrintPower
   PrintStats
   Pause           <Key Functions>
   SaveGame
   RestoreGame
   PutNewSpot        <"Flowing">
   ItemFlow
   MakeFlow
   RedSpot         <Bombing procs>
   CB2
   ClearBlast
   DrawSpot
   BombSpot
   BreakWalls
   Boom
   GetKeyPress
f: GetItem          <Item Usage>
   UseHorn
   UseLamp
   UseBky
   UseRing
   UseRky
   UseItem
f: BoundCheck    <Location Control>
   DropBlock           <Items>
   PushBlock
   Gate1
   Gate2
   OneWay
   PitFall
   Tunnel
   HotFloor
   SinkRaft
   Mine
   Wall
   SpecMove
   CheckPos
   PhaseKey
   FallsPull
-f--> MoveMan
-f--> MoveMonsters
   GetKey
   NecMove
   MoveCheck
-f--> StartGame }

Procedure MoveMan; forward;
Procedure MoveMonsters; forward;
Procedure StartGame; forward;

Procedure QuitGame;
begin
  Window(1,1,80,25);
  TextAttr := White;
  ClrScr;
  GotoXY(12,1);
  Write('THE MERICAN CITY');
  GotoXY(9,2);
  Write('- The Deeper Depths -');
  GotoXY(3,3);
  Writeln('A production from MER Enterprises');
  GotoXY(19,4);
  Writeln('by');
  GotoXY(9,5);
  Writeln('ЎЎЎ Michael Rimer ЏЏЏ');  Writeln;
  TextAttr := LightGray;
  CursorOn;
  Halt(2)
end;

Procedure CreateSList;
begin
  N[1]  := 'The Merican Master  ';
  N[2]  := 'Arthur Pendragon    ';
  N[3]  := 'Gandalf the Gray    ';
  N[4]  := 'Thor the Barbarian  ';
  N[5]  := 'Merlin the Wizard   ';
  N[6]  := 'Dirk the Daring     ';
  N[7]  := 'Conan the Destroyer ';
  N[8]  := 'Bilbo Baggins       ';
  N[9]  := 'Matthias            ';
  N[10] := 'He - Man            ';
  N[11] := 'Secret Agent 00Ќ    ';
  N[12] := 'Elvis               ';
  N[13] := 'The Mario Brothers  ';
  N[14] := 'Biff                ';
  N[15] := 'Mr. Rogers          ';
  z := 30000;
  for i := 1 to 15 do begin
      S[i] := z;
      Dec(z,2000)
    end;
  z := 15;
  for i := 1 to 15 do begin
      L[i] := Chr(z);
      Dec(z)
    end
end;

Function ScorePlace(ValorSpot : integer) : integer;
begin
  if ValorSpot > 15 then ScorePlace := 16
  else if Score > S[ValorSpot] then ScorePlace := ValorSpot
    else ScorePlace := ScorePlace(ValorSpot + 1)
end;

Procedure NewHiScore(Cntr,Honor : integer);
begin
  while Cntr > Honor do
    begin
      N[Cntr] := N[Cntr - 1];
      S[Cntr] := S[Cntr - 1];
      L[Cntr] := L[Cntr - 1];
      Dec(Cntr)
    end;
  N[Honor] := ' ';
  S[Honor] := Score;
  L[Honor] := Chr(MaxLevel)
end;

Procedure PrintMerits(Cnt,Honor : integer);
begin
  if Cnt > 15 then EXIT;
  TextAttr := (Cnt mod 3) + 10;
  GotoXY(9,Cnt + 6);
  Write(Cnt:2,'. ');
  if Honor = Cnt then NewHiScore(15,Honor) else Write(N[Cnt]);
  GotoXY(35,Cnt + 6);
  Write(S[Cnt]:6);
  GotoXY(49,Cnt + 6);
  Write(Ord(L[Cnt]):2);
  PrintMerits(Cnt + 1,Honor)
end;

Procedure PlaceNewMerit(Honor : integer);
begin
  GotoXY(20,22);
  TextAttr := LightRed + Blue * 16;
  Write('Please enter your name.');
  GotoXY(13,Honor + 6);
  TextAttr := LightMagenta + Brown * 16;
  Write('                    ');
  CursorFull;
  TextAttr := White + Brown * 16;
  GotoXY(13,Honor + 6);
  Readln(N[Honor]);
  if N[Honor] = '' then N[Honor] := 'Slicko';          {Default name}
  while Length(N[Honor]) < 20 do N[Honor] := N[Honor] + ' ';
  CursorOff
end;

Procedure HiScores;
begin
  Window(1,1,64,25);
  TextAttr := (Random(6) + 2) * 16;
  ClrScr;
  Window(2,2,63,24);
  TextAttr := LightBlue;
  ClrScr;
  GotoXY(24,2);
  Write('THE MERICAN CITY');
  Assign(f1,'city.hs');
  {$I-} Reset(f1); {$I+}
  z := IOResult;
  if z <> 0 then
    if z = 2 then CreateSList else begin
      TextAttr := White;
      Write('Program "CITY.HS" damaged - program aborted');
      Halt(2)
    end
  else for i := 1 to 15 do Read(f1,N[i],S[i],L[i]);
  TextAttr := Yellow;
  GotoXY(13,5);
  Write('HERO');
  GotoXY(36,5);
  Write('SCORE');
  GotoXY(48,5);
  Write('LEVEL');
  j := Scoreplace(1);
  PrintMerits(1,j);
  if j < 16 then PlaceNewMerit(j);
  {$I-} Rewrite(f1); {$I+}              {Score saving error trapping}
  z := IOResult;
  if z <> 0 then
    begin
      GotoXY(1,1);
      TextAttr := White + Blink;
      Write('Error writing to disk - try again?');
      if UpCase(ReadKey) = 'Y' then begin
        {$I-} ReWrite(f1); {$I+}
        z := IOResult;
        if z <> 0 then Write('Error writing disk - new scores not recorded.');
        end
      else Write('Updated high scores will not be recorded.');
    end
  else for i := 1 to 15 do Write(f1,N[i],S[i],L[i]);
  repeat
    {$I-} Close(f1); {$I+}
    z := IOResult;
    if z <> 0 then begin
        TextAttr := (Random(8) + 8) + Blink;
        Writeln('Error closing save file - ');
        Write('check disk and hit a key to try again...');
        Ch := ReadKey
      end;
  until z = 0;                              {MUST close file safely!}
  CursorOff
end;

Procedure NoPower;
begin
  Window(1,1,80,25);
  if Power > -100 then Whistle else Whistle2;
  if Power > -99 then                                 {Resurrection?}
    if LifeStaff then begin
      LifeStaff := FALSE;
      PrintItems;
      PowerUp;
      Power := 600;
      Mess('Your magical staff restores you to life!',12);
      EXIT
    end;
  TextAttr := (Random(6) + 2) * 16 + Blink;
  GotoXY(24,25);
  Write('YOU HAVE DIED!!');
  Window(Twx,Twy,Lwx,Lwy);
  RemKeys;
  repeat
    TextAttr := Succ(Random(15));
    GotoXY(XCord,YCord);
    Write('*');
    Delay(50)
  until KeyPressed;
  Window(1,1,64,24);
  case Random(100) of                     {assorted screen blankings}
    0..19 : for i := 1 to 24 do begin
        InsLine;
        Delay(10)
      end;
    20..39 : for i := 1 to 24 do begin
        DelLine;
        Delay(10)
      end;
    40..59 : for i := 1 to 64 do begin
        for z := 1 to 24 do begin
          GotoXY(i,z);
          Write(' ')
          end;
        Delay(5)
      end;
    60..79 : begin
        Window(1,1,65,24);
        for i := 64 downto 1 do begin
          for z := 1 to 24 do begin
            GotoXY(i,z);
            Write(' ')
            end;
          Delay(5)
        end
      end;
    80..99 : begin
        Window(1,1,64,25);
        for i := 1 to 3000 do begin
          GotoXY(Random(64),Succ(Random(24)));
          Write('  ')
        end;
        Window(1,1,64,24);
        ClrScr
      end;
    end; {Blanking case}
  RemKeys;
  HiScores;
  if OPMess(100) then StartGame else QuitGame;
end;

Procedure PrintPower;
begin
  Window(1,1,80,25);
  GotoXY(71,17);
  TextAttr := Brown + LightGray * 16;
  case Power of
    0..99 : begin
      Inc(TextAttr,Blink);
      Write(Power:3,' ')
      end;
    100..32767 : Write(Power,' ');
  else begin
      Inc(TextAttr,Blink);
      Write('  0  ');
      NoPower                                {Power < 0 - GAME OVER!}
    end;
  end; {Power case}
  Window(Twx,Twy,Lwx,Lwy)
end;

Procedure PrintStats;
begin
  Window(1,1,80,25);
  TextAttr := Brown + LightGray * 16;
  GotoXY(68,8);
  Write(Bombs:2);
  GotoXY(75,8);
  Write(Magic:2);
  GotoXY(72,11);
  Write(Keys:2);
  GotoXY(71,17);
  PrintScore;
  PrintPower
end;

Procedure Pause;
begin
  Attention;
  Mess('Press any key to resume game...',16)
end;

Procedure MakeStats;
begin
  Score := SScore;
  Access := Ord(XKey);
  Power := (Ord(P1) * 256) + Ord(P2);
  Magic := Ord(SMagic);
  Bombs := Ord(SBombs);
  Keys := Ord(SKeys);
  LevelNum := Ord(SLevelNum);
  MaxLevel := Ord(SMaxLevel);
  NumItems := Ord(SNumItems);
  Lamp := Ord(SLamp);
  SuperBombs := Ord(SSuperBombs);
  Wings := Ord(SWings);
  if Ord(SStaff) = 1 then LifeStaff := TRUE
    else LifeStaff := FALSE;
  OldX := Ord(SXCord);
  OldY := Ord(SYCord);
  MB
end;

Procedure SaveGame;
var fn : text;
begin
  if OPMess(20) then
    begin
      Window(1,1,80,25);
      GotoXY(23,25);
      TextAttr := White;
      Write('  Saving game...  ');
      Window(Twx,Twy,Lwx,Lwy);
      Assign(fn,'CITY.sav');
{$I-} Rewrite(fn); {$I+}
      z := IOResult;
      if z <> 0 then begin
          BlankLine;
          EXIT
        end;
      Write(fn,SScore,Chr(Access),P1,P2);      {score/access/power}
      Write(fn,SMagic,SBombs,SKeys);                        {stats}
      Write(fn,SLevelNum,SMaxLevel,SNumItems,SLamp,SSuperBombs,SWings,SStaff);
      Write(fn,SXCord,SYCord);                 {starting level pos}
      for i := 1 to 69 do
        if Messages[i] then Write(fn,Chr(255))
          else Write(fn,Chr(32));
      Close(fn);                    {now Close save file!}
      BlankLine
    end
end;

Procedure RestoreGame;
var fn : text;
   Mes : char;
begin
  if OPMess(30) then
    begin
      Window(1,1,80,25);
      GotoXY(21,25);
      TextAttr := White;
      Write('  Restoring game...  ');
      Assign(fn,'CITY.sav');
{$I-} Reset(fn); {$I+}
      z := IOResult;
      if z <> 0 then begin
          Mess('There is no game saved on disk...',15);
          EXIT
        end;
      Boat := FALSE;                             {default settings}
      YesNec := FALSE;
      YesSpec := FALSE;
      OldSpot := 1;
      NewSpot := 1;
      New(HeadMS);
      HeadMS^.Next := nil;
      Read(fn,SScore,XKey,P1,P2);
      Read(fn,SMagic,SBombs,SKeys);
      Read(fn,SLevelNum,SMaxLevel,SNumItems,SLamp,SSuperBombs,SWings,SStaff);
      Read(fn,SXCord,SYCord);
      for i := 1 to 69 do begin
          Read(fn,Mes);
          if Mes = #32 then Messages[i] := FALSE
            else Messages[i] := TRUE
        end;
      Close(fn);     {now Close restore file!}
      MakeStats;
      PrintStats;
      PrintItems;
      TextAttr := 0;
      Window(1,1,64,24);
      ClrScr;
      case LevelNum of
        1 : LoadGateway;
        2 : LoadCity;
        3 : LoadTower1;
        4 : LoadTower2;
        5 : LoadTower3;
        6 : LoadTower4;
        7 : LoadCatacombs;
        8 : LoadTunnels;
        9 : LoadPits;
       10 : LoadStair1;
       11 : LoadStair2;
       12,14 : LoadStair3;
       13 : LoadStair4;
       15 : begin
           LoadRiver;
           YesSpec := TRUE;
           Special := 600
         end;
       16 : begin
           LoadFalls;
           if XCord = 48 then DrawLevel(36,16,51,24)
         end;
       17 : LoadLagoon;
       18 : begin
           LoadStorm;
           YesSpec := TRUE;
           Special := 900;
           YesNec := TRUE;
           Nec := 900
         end;
       19 : LoadTemple;
       20 : LoadLabyrinth;
       21 : LoadSanctum;
       22 : begin
           LoadSciLab;
           YesNec := TRUE;
           Nec := 1200;
         end;
       23 : LoadTheDark;    {anything else?}
       24 : LoadTrapHall;
       25 : {LoadEscape};
      end; {LevelNum case}
      if LevelNum in [10..14] then begin
          Moves := 5;
          YesNec := TRUE;
          Nec := 500;
          YesSpec := TRUE;
          Special := 500
        end;
      BlankLine;
    WarpMan
    end
end;

Procedure PutNewSpot(x,y : integer; Ch : char);
begin
  Inc(LastFlow);
  if (LastFlow > MaxFlow) then
    begin
      LastFlow := 0;
      Window(1,1,80,25);
      Write('Var MaxFlow needs to be enlarged - program aborted.');
      Delay(3000);
      Halt(3)
    end;
  IList[LastFlow].x := x;
  IList[LastFlow].y := y;
  LevelMat[x,y] := Ch;
  GotoXY(x,y);
  case Ch of
    'L' : begin
      TextAttr := LightRed + Red * 16 + Blink;
      Write('Б');
      if (x = XCord) and (y = YCord) then
        begin
          Mess('The lava engulfs you!!',21);
          Power := -100;
          PrintPower
        end
      end;
    '=' : begin
      TextAttr := LightBlue + Blue * 16 + Blink;
      Write('Б');
      if (x = XCord) and (y = YCord) then
        begin
          Mess('You are drowned in the deluge!',17);
          Power := -100;
          PrintPower
        end
      end;
  end; {item case}
end;

Procedure ItemFlow(Ch : char);

var i, CurLast, x, y : integer;

begin
  i := IStart;
  CurLast := LastFlow;
  while (i <= CurLast) do
    begin
      x := IList[i].x;
      y := IList[i].y;
      if x > 1 then
        if LevelMat[x-1,y] in FlowItems then PutNewSpot(x-1,y,Ch);
      if y > 1 then
        if LevelMat[x,y-1] in FlowItems then PutNewSpot(x,y-1,Ch);
      if x < 64 then
        if LevelMat[x+1,y] in FlowItems then PutNewSpot(x+1,y,Ch);
      if y < 24 then
        if LevelMat[x,y+1] in FlowItems then PutNewSpot(x,y+1,Ch);
      Inc(i)
    end;
end;

Procedure MakeFlow(Ch : char);
begin
  if LastFlow <> LastTurn then
    begin
      LastTurn := LastFlow;
      ItemFlow(Ch);
      IStart := LastTurn + 1
    end
  else YesNec := FALSE
end;

Procedure RedSpot(X, Y, PL, S : integer);                  {Bombing procs}
begin
  Spots[s] := TRUE;
  GotoXY(X,Y);
  if PL = 2 then TextAttr := LightBlue
    else TextAttr := LightRed;
  Write('л')
end;

Procedure CB2(X,Y : integer);
begin
  GotoXY(XCord+X,YCord+Y);
  Write(' ')
end;

Procedure ClearBlast;
begin
  TextAttr := 0;
  if Spots[1] then CB2(-1,-1);
  if Spots[2] then CB2(-1,0);
  if Spots[3] then CB2(-1,1);
  if Spots[4] then CB2(0,-1);
  if Spots[5] then CB2(0,1);
  if Spots[6] then CB2(1,-1);
  if Spots[7] then CB2(1,0);
  if Spots[8] then CB2(1,1)
end;

Procedure DrawSpot(X, Y : integer; Chr : char);
begin
  LevelMat[X,Y] := Chr;
  GotoXY(X,Y);
  TextAttr := Walls2;
  Write(Chr)
end;

Procedure BombSpot(X, Y, PL, S : integer);
begin
  case LevelMat[X,Y] of
    ' ',':',';','љ','b','l','y','H' : RedSpot(X,Y,PL,S);
    'U' : if PL in [2,3] then begin
            LevelMat[X,Y] := ' ';
            RedSpot(X,Y,PL,S)
          end;
    'В' : if PL = 1 then DrawSpot(X,Y,'Б')
          else begin
            LevelMat[X,Y] := ' ';
            RedSpot(X,Y,PL,S)
          end;
    'Б' : if PL = 1 then DrawSpot(X,Y,'А')
          else begin
            LevelMat[X,Y] := ' ';
            RedSpot(X,Y,PL,S)
          end;
    'А','-' : begin
            LevelMat[X,Y] := ' ';
            RedSpot(X,Y,PL,S)
          end;
    '0','1','2','3' : begin
            LevelMat[X,Y] := ' ';
            ZapMonster(X,Y);
            RedSpot(X,Y,Pl,S)
          end;
  end; {(x,y) case}
end;

Procedure BreakWalls(PL : integer);
begin
  for i := 1 to 8 do Spots[i] := FALSE;
  if (XCord > 1) then
    begin
      if (YCord > 1) then BombSpot(XCord-1,YCord-1,PL,1);
      BombSpot(XCord-1,YCord,PL,2);
      if (YCord < 24) then BombSpot(XCord-1,YCord+1,PL,3)
    end;
  if (YCord > 1) then BombSpot(XCord,YCord-1,PL,4);
  if (YCord < 25) then BombSpot(XCord,YCord+1,PL,5);
  if (XCord < 64) then
    begin
      if (YCord > 1) then BombSpot(XCord+1,YCord-1,PL,6);
      BombSpot(XCord+1,YCord,PL,7);
      if (YCord < 24) then BombSpot(XCord+1,YCord+1,PL,8)
    end;
  Delay(250);
  ClearBlast;                                    {clean up blast effect}
  NoSound
end;

Procedure Boom(PowerLevel : integer);
begin
  case PowerLevel of
    1 : if Bombs < 1 then NullItem else
      begin
        Dec(Bombs);
        BombBlast;
        BreakWalls(1);
        Dec(Power,5);
        PrintStats
      end;
    2 : if Magic < 1 then NullItem else
      begin
        Dec(Magic);
        SpellCast;
        BreakWalls(2);
        Dec(Power,15);
        PrintStats
      end
  end {PowerLevel case}
end;

Procedure GetKeyPress;
begin
  GoKey := 0;
  Ch := UpCase(ReadKey);
  if Ch <> #0 then FuncKey := FALSE else
    begin
      FuncKey := TRUE;
      Ch := ReadKey
    end;
  case FuncKey of
    TRUE : if Ch in [#71..#81,#32,#99,#113] then
      begin
        GoKey := Ord(Ch) - 70;
        case Ch of
          #71..#73 : Inc(GoKey,6);          {Numeric keypad input}
          #75..#77 : Dec(GoKey);                {without CAPSLOCK}
          #79..#81 : Dec(GoKey,8);
          #32 : GoKey := 100;                         {Debug keys}
          #99 : GoKey := 101;
         #113 : GoKey := 102;
        end; {Ch case}
        Dec(Power)
      end
      else ErrorBeep;
    FALSE : case Ch of
      #49..#52, #54..#57 : begin                  {Keypad w/ CAPS}
          GoKey := Ord(Ch) - 48;
          Dec(Power)
        end;
      'S' : GoKey := 20;                               {Save? key}
      'R' : GoKey := 30;                            {Restore? key}
      'P' : GoKey := 40;                            {Pause... key}
      'B' : GoKey := 50;                                {Bomb key}
      'M' : GoKey := 60;                               {Magic key}
      'U' : GoKey := 70;                           {Use Items key}
 #13, #32 : GoKey := 80;                          {For Items proc}
      'N' : GoKey := 90;                        {Noise toggle key}
 #27, 'Q' : GoKey := 99;                               {Quit? key}
    else ErrorBeep
    end {Ch case}
  end {FuncKey case}
end;

Function GetItem(Num,Max : integer) : integer;
begin
  Window(1,1,80,25);
  repeat
   GotoXY(67 + Num,15);
   TextAttr := Yellow + Blue * 16 + Blink;
   Write(#24);
   case Num of
    1 : Mess('Trumpet',28);
    2 : if Lamp = 1 then
      Mess('Lantern - ' + Chr(Lamp + 48) + ' charge',22)
        else Mess('Lantern - ' + Chr(Lamp + 48) + ' charges',22);
    3 : Mess('Blue Key',28);
    4 : Mess('Magic Ring',27);
    5 : Mess('Red Key',28);
    6 : Mess('SuperBombs (' + Chr(SuperBombs + 48) + ')',25);
    7 : Mess('Green Key',27);
    8 : Mess('Pass Card',27);
    9 : Mess('Icarus Wings (' + Chr(Wings + 48) + ')',24)
   end; {Num case}
   GetKeyPress;
   Window(1,1,80,25);
   GotoXY(67 + Num,15);
   TextAttr := Blue;
   Write('л');
   if (GoKey = 4) or (GoKey = 6) then Inc(Power); {fixes bug/feauture}
   case GoKey of
    4 : if Num > 1 then Dec(Num);
    6 : if Num < Max then Inc(Num);
    80 : GetItem := Num;
    99 : GetItem := 99;
   end; {GoKey case}
  until GoKey = 80;
end;

Procedure UseHorn;
begin
  Prize;
  if LevelNum > 1 then begin
    Mess('Blowing the horn has no effect.',16);
    EXIT
    end;
  case YCord of
    18 : if XCord <> 18 then begin
        Mess('Blowing the horn has no effect.',16);
        EXIT
      end;
    22 : if not (XCord in [17..19]) then begin
          Mess('Blowing the horn has no effect.',16);
          EXIT
        end;
    else begin
      Mess('Blowing the horn has no effect.',16);
      EXIT
      end;
  end;     {of case}
  Mess('The clarion call summons a drawbridge.',13);
  Stairs;
  for i := 19 to 21 do begin        {extend bridge}
      LevelMat[17,i] := 'К';
      LevelMat[18,i] := ' ';
      LevelMat[19,i] := 'К'
    end;
  LevelMat[17,21] := 'Н';
  LevelMat[19,21] := 'г';
  DrawLevel(17,19,19,21)
end;

Procedure UseLamp;
begin
  if Lamp < 1 then
    begin
      Mess('Your lamp has no more fuel.',18);
      EXIT
    end;
  Dec(Lamp);
  if not (LevelNum in [3,5,9,23]) then
    begin
      Mess('Nothing happens...',23);
      EXIT
    end;
  case LevelNum of
    3 : begin
      Trap := TRUE;
      DrawLevel(1,1,19,19)
    end;
    5 : begin
      Trap := TRUE;
      DrawLevel(7,3,16,6);
      DrawLevel(6,13,14,17)
    end;
    9 : begin
      LevelMat[13,7] := ' ';
      DrawLevel(1,1,30,17);
      Message(66)
    end;
   23 : begin
      YesNec := TRUE;
      Nec := 1300;
    end;
  end;  {of case}
  PrintMan;
  YesSpec := TRUE;
  Special := 300;
  Moves := 0;
end;

Procedure UseBky;
begin
  if LevelNum > 1 then begin
      Mess('You can''t find any use for this key here.',12);
      EXIT
    end;
  if not (((YCord = 9) and (XCord in [3..5])) or
    ((YCord = 11) and (XCord in [4,5])))
      then begin
        Mess('You can''t find any use for this key here.',12);
        EXIT
      end;
  Click;
  Mess('You carefully insert the key into the lock...',9);
  for i := 50 to 500 do begin
    TextAttr := Succ(Random(16));
    GotoXY(7,10);
    Write('Б');
    if Noise then Sound(i);
    Delay(3)
    end;
  NoSound;
  LevelMat[7,10] := ' ';
  DrawLevel(7,10,7,10)
end;

Procedure UseRing;
begin
  if LevelNum <> 19 then begin
      Mess('You put on the ring.',22);
      EXIT
    end;
  Mess('You feel your will return as you invoke the ring.',7);
  YesNec := FALSE
end;

Procedure UseRky;
begin
  if LevelNum <> 2 then begin
      Mess('You can''t use this key for anything here.',11);
      EXIT
    end;
  if (YCord = 19) and (XCord = 51)
    then begin
      Click;
      Mess('The lock clicks as you turn the key...',13);
      for i := 500 downto 50 do begin
        TextAttr := Succ(Random(15));
        GotoXY(50,21);
        Write(#6);
        if Noise then Sound(i);
        Delay(3)
        end;
      NoSound;
      LevelMat[50,21] := ' ';
      DrawLevel(50,21,50,21)
    end
  else Mess('You can''t use this key for anything here.',11)
end;

Procedure ShowExplode(Tx, Ty, Lx, Ly : integer);
begin
  for i := Tx to Lx do
    for j := Ty to Ly do
      if LevelMat[i,j] in [' ',':',';','љ','b','l','y','H'] then begin
          GotoXY(i,j);
          Write('л')
        end;
end;

Procedure Explode(Tx, Ty, Lx, Ly : integer);
begin
  if Tx < 1 then begin                                    {bound checks}
    Explode(Tx + 1,Ty,Lx,Ly);
    EXIT
  end;
  if Ty < 1 then begin
    Explode(Tx,Ty + 1,Lx,Ly);
    EXIT
  end;
  if (Lx + Twx) > 65 then begin
    Explode(Tx,Ty,Lx - 1,Ly);
    EXIT
  end;
  if (Ly + Twy) > 25 then begin
    Explode(Tx,Ty,Lx,Ly - 1);
    EXIT
  end;
  TextAttr := LightRed;
  ShowExplode(Tx,Ty,Lx,Ly);
  for i := Tx to Lx do
    for j := Ty to Ly do BombSpot(i,j,3,1);           {Bombing Power #3}
  Delay(500);
  TextAttr := 0;
  ShowExplode(Tx,Ty,Lx,Ly);
end;

Procedure UseSuperBomb;
begin
  if SuperBombs < 1 then
    begin
      Mess('Your supply is exhausted.',19);
      EXIT
    end;
  Dec(SuperBombs);
{A NEW IDEA : cool bombing effect}
  BombBlast;
  Explode(XCord - 3,YCord - 3,XCord + 3,YCord + 3);
  PrintMan;
  NoSound
end;

Procedure UseGky;
begin
  if LevelNum > 1 then begin
      Mess('This key can''t do anything here.',17);
      EXIT
    end;
  if (((XCord = 6) or (XCord = 4)) and (YCord = 2)) then begin
      Click;
      Mess('As you turn the key, the door vanishes into thin air...',5);
      for i := 50 to 500 do begin
        TextAttr := Random(16) + Random(8) * 16;
        GotoXY(5,2);
        Write('щ');
        if Noise then Sound(i);
        Delay(3)
      end;
      NoSound;
      LevelMat[5,2] := ' ';
      DrawLevel(5,2,5,2)
    end
  else Mess('The key is useless here.',21)
end;

Procedure UseCard;
begin
  if LevelNum <> 2 then begin
      Mess('After looking at the card, you decide it can''t be used here.',3);
      EXIT
    end;
  if ((XCord in [43..45]) and (YCord in [1..3]))
    then begin
      Click;
      Mess('You find a slot in the structure and slide the card in.',5);
      for i := 50 to 500 do begin
        TextAttr := Random(16) + Random(8) * 16;
        GotoXY(41,1);
        Write('№');
        if Noise then Sound(i);
        Delay(3)
      end;
      NoSound;
      LevelMat[41,1] := '7';
      DrawLevel(41,1,41,1)
    end
  else Mess('The card won''t do anything for you here.',13)
end;

Procedure UseWings;
begin
  if YesSpec
    then begin
      Slide;
      Mess('A magical force will not allow you to use the wings here!',4);
      EXIT
    end;
  Crystal3;
  Mess('Invoking the wings, you soar into the air...!',9);
  YesSpec := TRUE;
  Special := 1000;
  NewSpot := 30;
  MagicKey := 0
end;

Procedure UseItem;
begin
  if NumItems = 0 then
    begin
      Mess('You have nothing that you may use.',15);
      EXIT
    end;
  Mess('Choose the item that you wish to use.',13);
  RemKeys;
  i := GetItem(1,NumItems);
  Window(Twx,Twy,Lwx,Lwy);
  case i of
   99 : NullItem;
    1 : UseHorn;
    2 : UseLamp;
    3 : UseBky;
    4 : UseRing;
    5 : UseRky;
    6 : UseSuperBomb;
    7 : UseGky;
    8 : UseCard;
    9 : UseWings;
  end; {items case}
end;

Function BoundCheck : boolean;
begin
  if (XCord < 1) or ((XCord + Twx) > 65)
  or (YCord < 1) or ((YCord + Twy) > 25) then
    begin
      MB;                                      {*screen boundaries hit*}
      Thump;
      Dec(Score,5);
      PrintScore;
      RemKeys;
      Message(0);
      BoundCheck := FALSE
    end
  else begin
    Window(Twx,Twy,Lwx,Lwy);
    BoundCheck := TRUE
  end
end;

Procedure PushBlock;
var Spot : char; x, y : integer;
begin
  Spot := LevelMat[XCord,YCord];
  case Spot of
    'ў' : begin     {more than one block}
        ChangeCords;
        PushBlock;
        EXIT
      end;
    ' ' : begin     {push block}
        LevelMat[XCord,YCord] := 'ў';
        GotoXY(XCord,YCord);
        TextAttr := LightBlue + Blue * 16;
        Write(#9)
      end;
    '#' : begin     {push block into pit}
        x := XCord;
        y := YCord
      end;
    'Z' : Crumble;  {zap block}
  else begin
      YesSpec := FALSE;
      OldX := FirstX;
      OldY := FirstY;
      XCord := FirstX;
      YCord := FirstY;
      HitWall;
      EXIT
    end;
  end; {Spot case}
  XCord := OldX;
  YCord := OldY;
  OldX := FirstX;
  OldY := FirstY;
  PrintMan;
  LevelMat[XCord,YCord] := ' ';
  YesSpec := FALSE;
  if Spot = '#' then DropBlock(x,y)
end;

Procedure Gate1;
begin
  TextAttr := Magenta;
  if LevelNum = 1 then GotoXY(15,13) else GotoXY(8,13);
  Write('Э');
  Delay(50);
  if LevelNum = 1 then for i := 15 to 20 do begin
    if Noise then Sound(100);
    GotoXY(i,13);
    Write(' Э');
    Delay(50);  NoSound;
    Delay(35)
    end
  else for i := 8 to 13 do begin
    if Noise then Sound(100);
    GotoXY(i,13);
    Write(' Э');
    Delay(50);  NoSound;
    Delay(35)
    end;
  if LevelNum = 1 then GotoXY(21,13) else GotoXY(14,13);
  Write(' ');
  if LevelNum = 1 then begin
      Message(25);
      Dec(XCord,7);
      Dec(YCord);
      OldX := XCord;
      OldY := YCord;
      LoadCity
    end
    else begin
      Inc(XCord,7);
      Inc(YCord);
      OldX := XCord;
      OldY := YCord;
      LoadGateway
    end;
  Message(46)
end;

Procedure Gate2;
begin
  TextAttr := Magenta;
  if LevelNum = 2 then GotoXY(3,4) else GotoXY(10,4);
  Write('К');
  Delay(35);
  for i := 4 to 6 do begin
      if Noise then Sound(100);
      if LevelNum = 2 then GotoXY(3,i) else GotoXY(10,i);
      Write(' ');
      Delay(50);  NoSound;
      Delay(35);
      if Noise then Sound(100);
      if LevelNum = 2 then GotoXY(3,i+1) else GotoXY(10,i+1);
      Write('К');
      Delay(50);  NoSound;
      Delay(35)
    end;
  if LevelNum = 2 then GotoXY(3,7) else GotoXY(10,7);
  Write(' ');
  if LevelNum = 1
    then begin
      Dec(XCord,6);
      OldX := XCord;
      LoadCity;
    end
    else begin
      Inc(XCord,6);
      OldX := XCord;
      LoadGateway
    end;
end;

Procedure OneWay;
begin
  case LevelMat[XCord,YCord] of
    'q' : GoodStep := 7;
    'w' : GoodStep := 8;
    's' : GoodStep := 9; {"e"'s direction}
    'a' : GoodStep := 4;
    'd' : GoodStep := 6;
    'z' : GoodStep := 1;
    'x' : GoodStep := 2;
    'c' : GoodStep := 3;
  end;
  if GoKey = GoodStep    {must step onto from right direction}
    then begin
      FootFalls;
      PrintMan;
    end
  else begin
      Crystal1;
      MB;
      Message(7);
    end
end;

Procedure PitFall(Note : string; Spot : integer);
begin
  PrintMan;
  t := 1100;
  Window(1,1,64,25);
  repeat
    Sound(t);
    TextAttr := Yellow;
    GotoXY(XCord + Twx - 1,YCord + Twy - 1);
    case t of
       950 : Write('O');
       800 : Write('o');
       650 : Write(#9);
       500 : Write('ј');
       350 : Write('љ');
       200 : Write('њ');
        60 : Write(' ')
    end;
    TextAttr := Random(16);
    GotoXY(Spot,25);
    Write(Note);
    Delay(2);
    Dec(t);
  until t < 37;
  BlankLine;
  Power := -100;
  Splatter;
  Delay(250);
  PrintPower
end;

Procedure Tunnel(TunDest : Coord);
var Spot : char;
begin
  Message(20);
  FMan;
  FirstX := OldX;
  FirstY := OldY;
  with TunDest do begin
      OldX := x;
      OldY := y;
      MB
    end;
  Spot := LevelMat[XCord,YCord];
  if not (Spot in [' ','=']) then begin
      XCord := FirstX;
      YCord := FirstY;
      FMan2;
      Message(65)
    end
  else FMan2
end;

Procedure HotFloor;
begin
  Dec(Power,5);
  PrintMan;
  for i := 1 to 150 do
    begin
      if Noise then Sound(Random(2500));
      TextAttr := Random(16) + Red * 16;
      GotoXY(XCord,YCord);
      Write(#1);
      Delay(3)
    end;
  NoSound;
  PrintPower;
  PrintMan;
  Message(31)
end;

Procedure SinkRaft;
begin
  Drain;
  Mess('You have sunk the raft...and you drown!',13);
  Power := -100;
  XCord := OldX;
  YCord := OldY;
  PrintPower
end;

Procedure Mine;
begin
  PrintMan;
  Mess('You set off an explosive mine!',17);
  RemKeys;
  BombBlast;
  Window(XCord-4,YCord-4,XCord+4,YCord+4);
  TextAttr := Brown * 16 + Blink;
  ClrScr;
  Window(XCord-3,YCord-3,XCord+3,YCord+3);
  TextAttr := Red * 16 + Blink;
  ClrScr;
  Window(XCord-2,YCord-2,XCord+2,YCord+3);
  TextAttr := LightRed + Blink;
  Write('ллллллллллллллллллллллллл');
  Window(XCord-1,YCord-1,XCord+1,YCord+2);
  TextAttr := Yellow + Blink;
  Write('ллллллллл');
  GotoXY(2,2);
  TextAttr := White + Blink;
  Write('л');
  Delay(800);
  Power := -100;
  PrintPower
end;

Procedure Wall;
begin
  if Random(2) > 0 then HitWall else Thump;
  Dec(Score,10);
  PrintScore;
  Dec(Integ,3);
  MB
end;

Procedure CheckPos;
begin
  case LevelMat[XCord,YCord] of      {runs move for corresponding spot}
    ' ',#39,'`' : begin                         {Normal move}
      FootFalls;
      PrintMan;
      end;
    '-' : begin                             {Monster no-move}
      FootFalls;
      PrintMan;
      LevelMat[XCord,YCord] := ' ';
      end;
    '$' : SpecialItem;                             {Specials}
    '4' : Item4;
    '5' : Item5;
    '6' : Item6;
    '7' : Item7;
    '8' : Item8;
    '9' : Item9;
    'r' : LvlMess(1);                              {Messages}
    't' : LvlMess(2);
    'u' : LvlMess(3);
    'h' : SL(1);                              {Secret Levers}
    'i' : SL(2);
    'j' : SL(3);
    'k' : SL(4);
    'л'..'п' : begin                                  {Walls}
      Wall;
      Message(1)
      end;
    'В' : begin
      Wall;
      Message(2)
      end;
    'Б' : begin
      Wall;
      Message(3)
      end;
    'А' : begin
      Wall;
      Message(4)
      end;
    'Z' : begin                                  {ForceField}
      Zap;
      Dec(Score,20);
      Dec(Power,2);
      PrintPower;
      PrintScore;
      MB;
      Message(16)
      end;
    ':','|' : begin                               {Inv. Wall}
      LevelMat[XCord,YCord] := 'л';
      DrawLevel(XCord,YCord,XCord,YCord);
      HitWall;
      Dec(Integ,3);
      MB;
      Message(18)
      end;
    ';','"' : begin                      {Inv. Crumbled Wall}
      LevelMat[XCord,YCord] := 'А';
      DrawLevel(XCord,YCord,XCord,YCord);
      HitWall;
      Dec(Integ,3);
      MB;
      Message(19)
      end;
    'U','\' : begin                                  {Forest}
      HitWall;
      Dec(Integ,3);
      MB;
      Message(35)
      end;
    'R' : begin                                        {Rock}
      Wall;
      Message(5)
      end;
    'T' : begin                                        {Tree}
      Wall;
      Message(6)
      end;
    'G' : Gate1;
    'g' : Gate2;
    'q','w','s','a','d','z','x','c' : OneWay;    {1-way zone}
    #181..#190,#198..#216 : begin              {Bridge Rails}
      Wall;
      Message(8)
      end;
    #179,#180,#191..#197,#217,
      #218 : PitFall('You plummet from the bridge to your doom!',10);
    'W' : begin                                       {Water}
      if Random(2) > 0 then WaterSpot else Stuck;
      MB;
      Dec(Score,10);
      PrintScore;
      Message(9)
      end;
    'L' : begin                                        {Lava}
      LevelMat[XCord,YCord] := ' ';
      PrintMan;
      Inc(Score,1000);
      PrintScore;
      Fry;
      Dec(Power,80);
      PrintPower;
      Message(10)
      end;
    '#' : PitFall('Oh, no! A bottomless pit!',20);      {Pit}
    'щ' : Door;                                        {Door}
    'ў' : begin                              {Pushable Block}
      FirstX := OldX;
      FirstY := OldY;
      YesSpec := TRUE;
      Special := 100;
      MoveMan;
      Message(15)
      end;
    'm','b' : Tunnel(Tun1);                         {Tunnels}
    'n','f' : Tunnel(Tun2);
    'o','l' : Tunnel(Tun3);
    'p','y' : Tunnel(Tun4);
    'ф' : begin                                   {Drop Spot}
      if Keys > 0 then Dec(Keys);
      if Magic > 0 then Dec(Magic);
      if Bombs > 0 then Dec(Bombs);
      Dec(Score,25);
      PrintStats;
      Click;
      PrintMan;
      Message(33)
      end;
    'і' : begin                               {Teleport Trap}
      Dec(Score,25);
      PrintScore;
      PrintMan;
      Message(32);
      OldX := XCord;
      OldY := YCord;
      FMan;
      GotoXY(XCord,YCord);
      TextAttr := LightRed;
      Write('њ');
      OldX := XTrap;
      OldY := YTrap;
      MB;
      FMan2
      end;
    'љ' : HotFloor;                               {Hot Floor}
    '0' : begin                                    {Monsters}
      HitWall;
      MB;
      Dec(Power,1)
      end;
    '1'..'3' : begin
      PrintMan;
      MonsterMove := 1;
      MoveMonsters
      end;
    '*' : begin                                       {Relic}
      Click;
      SumScore(300);
      LevelMat[XCord,YCord] := ' ';
      PrintMan;
      Message(17)
      end;
    'х' : begin                                         {Key}
      Beep2;
      Inc(Keys);
      Inc(Score,250);
      LevelMat[XCord,YCord] := ' ';
      PrintMan;
      PrintStats;
      Message(12)
      end;
    'ы' : begin                                        {Bomb}
      Beep2;
      Inc(Bombs);
      Inc(Score,100);
      LevelMat[XCord,YCord] := ' ';
      PrintMan;
      PrintStats;
      Message(13)
      end;
    'ш','H' : begin                                 {Healing}
      PrintMan;
      Whoop;
      Inc(Power,21 + Random(10));
      Inc(Score,50);
      PrintScore;
      LevelMat[XCord,YCord] := ' ';
      PrintStats;
      Message(14)
      end;
    #24 : begin                                       {Magic}
      Beep2;
      Inc(Magic);
      Inc(Score,500);
      LevelMat[XCord,YCord] := ' ';
      PrintMan;
      PrintStats;
      Message(22)
      end;
    'ј' : begin                                 {Sticky Spot}
      PrintMan;
      Stuck;
      GoodStep := 1 + Random(4);
      YesSpec := TRUE;
      Special := 200;
      Message(21)
      end;
    'I' : begin                                {Invisibility}
      LevelMat[XCord,YCord] := ' ';
      PrintMan;
      OldX := XCord;
      OldY := YCord;
      Click;
      FMan;
      NewSpot := 10;
      Message(23)
      end;
    'V' : begin                                  {Visibility}
      LevelMat[XCord,YCord] := ' ';
      NewSpot := 1;
      PowerUp;
      FMan2;
      PrintMan;
      Message(24)
      end;
    '=' : begin                              {Boatable Water}
      if (not Boat) then begin
        MB;
        WaterSpot;
        Message(9)
      end;
      case Integ of
        -100..0 : SinkRaft;
          1..30 : Message(26);
        31..100 : if (not Messages[26]) then Messages[26] := TRUE
      end;      {of case}
      PrintMan
      end;
     #4 : BoardBoat;                                   {Boat}
    #20 : if (not Boat) then begin                     {Dock}
          PrintMan;
          FootFalls
        end
      else begin
        Boat := FALSE;
        if (LevelNum in [15,16]) then YesNec := FALSE;
        OldSpot := 1;
        NewSpot := 1;
        if LevelNum in [15,16] then LevelMat[OldX,OldY] := '5'
          else LevelMat[OldX,OldY] := #4;
        DrawLevel(OldX,OldY,OldX,OldY);
        OldX := XCord;
        OldY := YCord;
        FMan2;
        FootFalls;
        Message(28)
      end;
    '@' : begin                                   {WhirlPool}
      PrintMan;
      Dec(Integ,27);
      LevelMat[XCord,YCord] := '=';
      WaterSpot;
      Message(30)
      end;
    'F' : PitFall('You go over the falls!',21);   {WaterFall}
    #15 : Mine;                                        {Mine}
  end;          {of items case}
end;         {of proc CheckPos}

Procedure SpecMove;
begin
  case Special of
    100 : PushBlock;
    200 : begin                                          {Sticky spot}
      Stuck;
      MB;
      Dec(GoodStep);
      if GoodStep = 0 then
        if LevelNum in [10,11] then Special := 500
          else YesSpec := FALSE;
      EXIT
    end;
    300 : begin                              {"The Tower1 / The Pits"}
      Inc(Moves);
      if Moves > 5 then begin
        YesSpec := FALSE;
        Trap := FALSE;
        if LevelNum = 3 then DrawLevel(1,1,19,19)
        else if LevelNum = 9 then begin
          if (XCord in [14..18]) and (YCord in [7..11]) then
            begin
              ClrScr;
              LevelMat[13,7] := 'Z';
              DrawLevel(13,6,18,12)
            end;
          end;
        PrintMan;
        Message(67);
      end
    end;
    500 : if XCord < 16 then                          {"Spiral Stair"}
      if Moves < 0 then HotFloor;
    600 : begin                                       {"River Rapids"}
      DrawLevel(OldX - 2,OldY - 1,OldX + 2,OldY + 1);
      GotoXY(OldX,OldY);
      if Boat then begin
        TextAttr := LightMagenta + Blue * 16;
        Write(#4)
        end
      else begin
        TextAttr := Yellow + Red * 16;
        Write(#1)
      end
    end;
    900 : begin                                      {"Thunder Storm"}
      TextAttr := 0;
      Window(1,1,64,24);
      ClrScr;
      Window(1,1,65,25);
      DrawLevel(XCord - 3,YCord - 2,XCord + 3,YCord + 2)
    end;
   1000 : begin                                      { Using Wings }
      Inc(MagicKey);  {my var for flying - duh}
      if MagicKey > 11
        then begin
          Squeak;
          YesSpec := FALSE;
          NewSpot := 1;
        end
      else if (LevelMat[XCord,YCord] in FlySpots) then EXIT;
    end;
  end; {Special case}
  CheckPos
end;

Procedure PhaseKey;
begin
  GenBool := FALSE;                           {key still there?}
  for i := 28 to 32 do
    for j := 10 to 16 do
      if LevelMat[i,j] = 'х' then GenBool := TRUE;
  if (not GenBool) then begin
      YesNec := FALSE;
      EXIT
    end;
  if ((XTrap = XCord) and (YTrap = YCord)) then begin
      YesNec := FALSE;
      Beep3
    end
  else begin
    LevelMat[XTrap,YTrap] := ' ';
    repeat
      i := 28 + Random(5);
      j := 10 + Random(7)
    until not ((i = XCord) and (j = YCord));
    XTrap := i;
    YTrap := j;    {to hold key position}
    LevelMat[XTrap,YTrap] := 'х';
    DrawLevel(28,10,32,16);
    if Noise then Sound(Random(10000));  {extra effect}
    PrintMan
  end
end;

Procedure FallsPull;
begin
  case XCord of
    14..20 : case YCord of
         2..6,12..13 : GoKey := 2;
       10..11,18..23 : GoKey := 8
       end;
    23..25 : case YCord of
        3..6 : GoKey := 8;
      18..22 : GoKey := 2
      end;
    39..42 : case YCord of
      10..13 : GoKey := 2;
      21..23 : GoKey := 8
      end;
    43..48 : if YCord in [3..6] then GoKey := 8;
  end;  {of XCord case}
  case YCord of
      7..9 : if XCord in [47..49] then GoKey := 6;
    10..12 : case XCord of
        5..6 : GoKey := 4;
        7..9 : GoKey := 6
      end;
    15..20 : if XCord in [3..8] then GoKey := 4;
  end;  {of YCord case}
  MoveMan
end;

Procedure MoveMan;
begin
  OldX := XCord;
  OldY := YCord;
  RemKeys;
  case GoKey of
    20 : SaveGame;                                      {special keys}
    30 : RestoreGame;
    40 : Pause;
    50 : Boom(1);
    60 : Boom(2);
    70 : UseItem;
    80 : ErrorBeep;
    90 : Noise := (not Noise);
    99 : begin
      Attention;
      if OPMess(99) then
        begin
          Power := -100;
          NoPower
        end
      end;
   100 : if Debug then         {Debug toggle}
      if DebugOn then begin
          DebugOn := FALSE;
          Mess('Debug : OFF',27)
        end else begin
            DebugOn := TRUE;
            Mess('Debug : ON!',27)
          end
      else ErrorBeep;
   101 : if DebugOn then begin
       Inc(Power,51);
       Beep3
     end else ErrorBeep;
   102 : if DebugOn then begin
       Dec(Power,49);
       Beep1
     end else ErrorBeep;
  else begin
    ChangeCords;
    if BoundCheck then if YesSpec
      then SpecMove               { run SPECIAL proc along with move }
      else CheckPos
    end;
  end {GoKey case}
end;

Procedure MoveMonsters;
begin
  OldX := XCord;      {update man at current spot}
  OldY := YCord;
  MS := HeadMS^.Next;     {start at front of list}
  while (MS <> nil) do with MS^ do
    begin
      ox := MX;
      oy := MY;
      if MX > XCord then Dec(MX)     {home in on player}
        else if MX < XCord then Inc(MX);
      if MY > YCord then Dec(MY)
        else if MY < YCord then Inc(MY);
      TextAttr := 0;
      if ((MX = XCord) and (MY = YCord) and (Pwr <> 0)) then
        begin                                           {monster hits}
          LevelMat[ox,oy] := ' ';
          GotoXY(ox,oy);
          Write(' ');
          Dec(Power,Pwr * 2);
          Beep3;
          Prev^.Next := Next;
          if (Next <> nil) then Next^.Prev := Prev;
          PrintPower
        end
      else if (LevelMat[MX,MY] in EatItems) then
        begin                                    {normal monster move}
          LevelMat[ox,oy] := ' ';
          GotoXY(ox,oy);
          Write(' ');
          if LevelMat[MX,MY] <> ' ' then Squeak else Buzz;
          LevelMat[MX,MY] := Chr(Pwr + 48);
          if DrawMonsters then begin
              DrawLevel(MX,MY,MX,MY);
              PrintMan
            end
        end
        else begin                            {non-eat hit by monster}
          MX := ox;
          MY := oy
        end;
      MS := Next
    end  {with MS^}
end;

Procedure GetKey;
begin
  if KeyPressed then
    begin
      GetKeyPress;
      MoveMan;
      PrintPower
    end
end;

Procedure NecMove;
begin
  Inc(Moves);
  case Nec of
    100 : if Moves > 5 then begin                   {City}
        if Odd(Moves) then MakeFlow('L');
        Delay(40)
      end;
    200 : if (Moves mod 4) = 0 then LavaPath(4,27); {Tower3}
    250 : if (Moves mod 5) = 0 then LavaPath(5,54); {Sanctum}
    300 : if (Moves mod 9) = 0 then begin           {Catacombs}
        for i := 23 to 29 do begin
          z := 10 + Random(6);
          if i <> XCord then for j := 11 to 15 do
            if z = j then LevelMat[i,j] := ' ' else LevelMat[i,j] := 'л'
          end;
        DrawLevel(23,11,29,15);
        OldX := XCord;
        OldY := YCord;
        PrintMan
      end; {300}
    400 : if (Moves mod 3) = 0 then begin           {Tunnels}
        LevelMat[((Moves div 3) mod 10) + 11,7] := ' ';
        LevelMat[(((Moves div 3) + 1) mod 10) + 11,7] := 'л';
        DrawLevel(11,7,20,7);
        if LevelMat[XCord,YCord] = 'л' then begin
          Splatter;
          Power := -100;
          Mess('The wall crushes you! (Ouch!)',17);
          PrintPower
          end;
        OldX := XCord;
        OldY := YCord;
        PrintMan
      end; {400}
    450 : if (Moves mod 3) = 0 then PhaseKey;       {Tunnels}
    500 : begin                                     {Stairs}
      Dec(Moves,2);
      if Moves = 0 then begin
        GotoXY(8,8);
        TextAttr := Yellow + Red * 16 + Blink;
        Write(#15);
        end
      else if Moves = -20 then begin
        GotoXY(8,8);
        TextAttr := LightGray;
        Write(#15);
        Moves := 30 + Random(20)
        end
      end; {500}
    600 : if (Moves mod 10) = 0 then
      if (GoKey in [1..9]) then MoveMan;            {Rapids}
    700 : if (Moves mod 10) = 0 then FallsPull;     {Falls}
    800 : begin                                     {Lagoon}
        if ((Moves mod 3 = 0) or (Moves mod 4 = 0)) then MakeFlow('=');
        Delay(40)
      end;
    900 : if (MonsterMove mod 120) = 0 then         {Storm}
      if Random(100) < 50
        then begin
          Window(1,1,64,24);
          TextAttr := Succ(Random(15)) * 16;
          ClrScr;
          Crumble;
          TextAttr := 0;
          ClrScr;
          Window(1,1,65,25);
          DrawLevel(XCord - 3,YCord - 2,XCord + 3,YCord + 2);
          PrintMan
        end
        else begin
          DrawLevel(XCord - 6,YCord - 4,XCord + 6,YCord + 4);
          Crumble;
          Window(1,1,64,24);
          TextAttr := 0;
          ClrScr;
          Window(1,1,65,25);
          DrawLevel(XCord - 3,YCord - 2,XCord + 3,YCord + 2);
          PrintMan
        end
      else begin
        DrawLevel(XCord - 3,YCord - 2,XCord + 3,YCord + 2);
        PrintMan
      end; {900}
   1000 : if (Moves mod 9) = 0                     {Temple}
      then begin
        GoKey := Succ(Random(9));
        MoveMan
      end;
   1100 : DrawLevel(23,19,23,19);                  {Labyrinth}
   1200 : if (Moves mod 20) = 0                    {Laboratory}
      then begin
        for i := 4 to 6 do
          for j := 4 to 6 do ToggleSpot('Z',i,j);
        for i := 4 to 13 do
          for j := 9 to 15 do ToggleSpot('Z',i,j);
        for i := 14 to 21 do
          for j := 11 to 18 do ToggleSpot('Z',i,j);
        for i := 26 to 33 do
          for j := 17 to 22 do ToggleSpot('Z',i,j);
        for i := 14 to 18 do
          for j := 3 to 7 do ToggleSpot('Z',i,j);
        for j := 3 to 7 do ToggleSpot('Z',24,j)
      end; {1200}
   1250 : if (Moves mod 3) = 0 then begin          {Lab 2}
     for j := 20 downto 17 do if LevelMat[56,j] = #15
       then begin
         LevelMat[56,j] := ' ';
         LevelMat[56,j + 1] := #15;
         DrawLevel(56,j,56,j + 1)
       end;
     for i := 57 to 60 do if LevelMat[i,17] = #15
       then begin
         LevelMat[i,17] := ' ';
         LevelMat[i - 1,17] := #15;
         DrawLevel(i - 1,17,i,17)
       end;
     for j := 18 to 21 do if LevelMat[60,j] = #15
       then begin
         LevelMat[60,j] := ' ';
         LevelMat[60,j - 1] := #15;
         DrawLevel(60,j - 1,60,j)
       end;
     for i := 59 downto 56 do if LevelMat[i,21] = #15
       then begin
         LevelMat[i,21] := ' ';
         LevelMat[i + 1,21] := #15;
         DrawLevel(i,21,i + 1,21)
       end;
     if LevelMat[XCord,YCord] = #15 then Mine;  {ouch!}
     end; {1250}
  1300 : begin      {The Dark}
     end;
  end {Nec case}
end;

Procedure MoveCheck;
begin
  repeat
    Inc(MonsterMove);
    if (MonsterMove mod 15) = 0 then MoveMonsters;
    GetKey;
    if YesNec then NecMove;             {<--- run NEC move every turn}
    Delay(40);                                  {automatic turn delay}
  until FALSE
end;

Procedure StartGame;             {game init}
begin
  CursorOff;
  DebugOn := FALSE;
  Noise := TRUE;
  Trap := FALSE;
  Boat := FALSE;
  YesNec := FALSE;
  YesSpec := FALSE;
  LifeStaff := FALSE;
  GotLifeStaff := FALSE;
  for i := 0 to 69 do Messages[i] := TRUE;
  New(HeadMS);                                     {head monster init}
  HeadMS^.Next := nil;
  Access := 0;                                       {setup variables}
  MaxLevel := 1;
  NumItems := 0;
  Lamp := -1;
  SuperBombs := -1;
  Wings := -1;
  MagicKey := 0;
  Integ := 100;
  Score := 0;
  Bombs := 0;
  Magic := 0;
  Keys := 0;
  NewSpot := 1;
  OldSpot := 1;
  OldX := 3;
  OldY := 22;
  Twx := 1;
  Twy := 1;
  Lwx := 65;
  Lwy := 25;
  MB;
  TitlePage;
  SetUpStats;
  PrintStats;
  LoadGateway;
  WarpMan;
  Message(45);
  MoveCheck
end;

begin       (* MAIN PROG *)
  if ParamStr(1) = '-mer'
    then Debug := TRUE else Debug := FALSE;           {Debug check}
  StartGame
end.  {MericanCity}
