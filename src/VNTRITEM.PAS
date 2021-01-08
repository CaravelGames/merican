Unit VntrItem;    {created by Michael Rimer on 28 APR 94}

(*  Contains object interactions for "The 'Merican Adventure" *)

(***)  Interface  (***)

Uses Crt, CrtEXTRA, PlayWave, Sounds, Sounds2,
     VntrMisc, VntrVars, VntrMstr;

Procedure PrintMessage(Num : integer);
Procedure GetSkill(var Stat : integer; N, E, A : integer);

Function  BoundCheck : boolean;
  Procedure FlashMan;
Procedure PhaseScrCol(x1, y1, x2, y2, Times : integer);
Procedure PhaseScrChr(x1, y1, x2, y2, Times : integer);
Procedure MoveMan;

Procedure GetStartPos(var Num, Method : integer);
Procedure ItemSetup;
  Procedure NewListObject(i, j : integer);
Procedure RestoreLists;
Procedure FlipLevel(MustFlip : boolean; LStat : LStatRec;
          FLvl, FCus : LevelMatrix; var TLvl, TCus : LevelMatrix);
Procedure LoadLevel(OldNum, Num, Method : integer);

Procedure DoWalls(Spot : byte);
Procedure DoInvSolidW;
Procedure DoInvBW1;
Procedure DoTree;
Procedure DoRock;
Procedure DoForest;
Procedure DoDenseForest;
Procedure DoInvWTrap;
Procedure RemNoMoveSpots(x, y : integer);
Procedure DoLava;
Procedure DoWater;
Procedure DoDeepWater;
Procedure DoIce;
Procedure DoForceField;
Procedure DoHotSpot;
Procedure DoStickySpot;
  Procedure SidewaysPit;
  Procedure BottomlessPit;
Procedure DoPit;
  Procedure GetAdjSpot(var ox, oy, x, y : integer);
Procedure DoTunnel(TunType : byte);
Procedure DoInvTunnel;
Procedure DoHGem(Item : byte);
Procedure DoPGem(Item : byte);
Procedure DoGoldNugget;
Procedure DoMScroll;
Procedure DoStoneKey;
Procedure DoStoneDoor;
Procedure DoInvSDoor;
Procedure DoBronzeKey;
Procedure DoBronzeDoor;
Procedure DoInvBDoor;
Procedure DoMagicKey;
Procedure DoMagicDoor;
Procedure PushBoulder;
Procedure DoPushBlock;
Procedure DoTeleTrap;
Procedure DoWarpTrap;
Procedure DoGemPouch;
Procedure DoChest;
Procedure DoLockedChest;
Procedure DoBuryGems;
Procedure DoUnearthGems;
Procedure DoRevealGems;
Procedure DoHideGems;
Procedure DoFreeze;
Procedure DoSlow;
Procedure DoHaste;
Procedure DoInvPotion1;
Procedure DoInvPotion2;
Procedure DoMagicSpear;
 Procedure LightItem(Effect, x, y : integer);
{ Procedure Lantern2(x, y : integer);}
Procedure DoMagicBomb;
Procedure DoLantern;
Procedure SwordPowerUp;
Procedure DoMonsterZap;
Procedure CreateMonsters;
Procedure DoSurround;
Procedure DoRope;
Procedure DoGreasedRope;
Procedure DoAntiGravity;
Procedure DoRopeExtend(TagNo : byte);
Procedure DoRaft;
Procedure DoUpStairs;
Procedure DoDownStairs;
Procedure DoChute;
Procedure DoPortalTo(Find : byte);

(**************************)
(***)  Implementation  (***)
(**************************)

Procedure PrintMessage(Num : integer);
  {* Prints description of newly-found items}
begin
  if Messages[Num]
    then begin
         case Num of
           1  : Message('You run into a solid stone wall.  (Ouch!)');
           2  : Message('You hit a cracked stone block.');
           3  : Message('You hit a partly crumbled stone block.');
           4  : Message('You hit a crumbled stone block.');
{          5  : Message('You hit a Moving wall.');}
           6  : Message('You ran into an invisible wall.');
           7  : Message('You ran into an invisible crumbled wall.');
           8  : Message('Zzzzzap!  You have hit a force field!  (Lose one health gem.)');
           9  : Message('Arms windmilling, you slide across the glabrous ice.');
           10 : Message('You smack into the trunk of a tall tree.');
           11 : Message('After many nicks and scratches, you decide not to push ahead.');
           12 : Message('The thick jungle terrain prevents you from continuing.');
           13 : Message('Ouch!  Lava causes heavy damage! (Lose 10 health gems!)');
           14 : Message('The strange water prevents you from swimming across.');
           15 : Message('You enter a tunnel!');
           16 : Message('Finding health gems increases your stamina.');
           17 : Message('Power gems allow you to use your sword.');
           18 : Message('Use Magic scrolls to blast those suckers!');
           19 : Message('You pick up the cold Stone Key.');
           20 : Message('The solid Stone Door repels your attempt to open it.');
           21 : Message('The Door opens! (You use one of your keys.)');
           22 : Message('Your head reels as you smash into the hidden Stone Door.');
           23 : Message('You found a gold nugget - 500 points!');
           24 : Message('You stepped into a teleport trap!');
           25 : Message('Your boots splash as you wade through the shallow water.');
           26 : Message('As rotted timbers give way, you fall through the ground.');
           27 : Message('Stairs take you to the next lower level.');
           28 : Message('You ascend lichened steps to the floor above.');
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
           43 : Message('With a hum, the Magic Door fades from sight!');
           44 : Message('You retrieve a shiny Bronze Key.');
           45 : Message('You''re blinded momentarily by the dazzling magic key.');
           46 : Message('A Bronze Key is required to unlock this door.');
           47 : Message('The sparkling door shocks you as you touch it.');
           48 : Message('You behold a new Bronze Door!');
           49 : Message('You grab hold of a rope.');
           50 : Message('Your hands slip down the greased rope.');
           51 : Message('You are nauseated as the world turns topsy-turvy.');
           52 : Message('The lantern burns bright in your grasp.');
           53 : Message('Egad...the magic gems twist into the earth!');
           54 : Message('*Gasp* the earth gives birth to jewels and gems!');
           55 : Message('Yah Hoo! You invoke a reveal hidden gems scroll.');
           56 : Message('Sufferin'' succotash -- vanishin'' valuables!');
           57 : Message('Stumbling into a small nook, you find a secret tunnel!');
           58 : Message('Toast!  Your eyebrows are singed!');
           59 : Message('What a quiescent spot! You feel so very, very sluggish...');
           60 : Message('A vortex swallows you and spits you out elsewhere...');
           61 : Message('"I must have your gems!" the hideous statue bellows.');
           62 : Message('Moored to the bank you discover a raft.');
           63 : Message('Energy crackles in the air as you activate the device!');
           64 : Message('You see a shrieking banshee calling forth her evil kin!');
           65 : Message('You breathe a sigh of relief as you throw the lever...');
           66 : Message('As flies to rotted meat, the creatures are drawn...');
           67 : Message('You hear a sharp crack as you hit your noggin on the ice.');
           68 : Message('You must have a key to open the Locked Chest...');
           69 : Message('The Treasure Chest opens!!');
           70 : Message('You feel sick as you are pushed through space.');
           71 : Message('Drinking the potion, you find yourself with animal vision.');
           72 : Message('You stroke smoothly through the azure waters.');
           73 : Message('This water is quite viscous -- it is hard to swim in!');
           74 : ;
           75 : ;
         end; {case Num}
         Messages[Num] := FALSE
       end
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

(******* EFFECTS ********)

Function BoundCheck : boolean;
  {* Outputs whether player is in bounds of the level}

begin
  if (P.x < 1) or (P.x > 64) or (P.y < 1) or (P.y > 24)
    then begin
           MB;
           BoundCheck := FALSE     {player is out of bounds}
         end
    else BoundCheck := TRUE        {player is in bounds}
end;

Procedure FlashMan;
  {* Man blinks before/after disappearing}
begin
  for Num := 1 to 50 do
    begin
      GotoXY(P.x,P.y);         {flash player}
      TextAttr := Random(127) + 1;
      Write(Chr(Random(2) + 1));
      Delay(15)
    end;
  SC(P.x,P.y,' ',Black)  {erase player char}
end;

Procedure PhaseScrCol(x1, y1, x2, y2, Times : integer);
  {* Modifies colors on screen from (x1,y1) to (x2,y2), then back to normal}
var c : byte;
begin
  for k := 1 to Times do
    begin
      for i := x1 to x2 do
        for j := y1 to y2 do begin
          c := GetSCol(i,j);
          if c = 255  {kludge}
            then c := 0
            else c := c + 1;
          SCol(i,j,c);
        end;
      Delay(10)
    end;
  for k := 1 to Times do
    begin
      for i := x1 to x2 do
        for j := y1 to y2 do begin
          c := GetSCol(i,j);
          if c = 0   {kludge}
            then c := 255
            else c := c - 1;
          SCol(i,j,c);
        end;
      Delay(10)
    end;
end;

Procedure PhaseScrChr(x1, y1, x2, y2, Times : integer);
  {* Modifies characters on screen from (x1,y1) to (x2,y2), then back}
var c : char;
begin
  for k := 1 to Times do
    begin
      for i := x1 to x2 do
        for j := y1 to y2 do begin
          c := GetSChr(i,j);
          if c = #255  {kludge}
            then c := #0
            else c := Succ(c);
          SChr(i,j,c)
        end;
      Delay(10)
    end;
  for k := 1 to Times do
    begin
      for i := x1 to x2 do
        for j := y1 to y2 do begin
          c := GetSChr(i,j);
          if c = #0  {kludge}
            then c := #255
            else c := Pred(c);
          SChr(i,j,c)
        end;
      Delay(10)
    end;
end;

Procedure MoveMan;
  {* Moves man to new position --> keys (1 - 9)}
var bInBounds, bGInBounds : boolean;
 Procedure SideCheck;
 begin
   case LData.View of
     Side, SideDark : begin
       bInBounds := (P.x >= 1) and (P.x <= 64) and (P.y >= 1) and (P.y <= 24);
       bGInBounds := (P.y + g >= 1) and (P.y + g <= 24);
       if not (
         (bInBounds and (Level[P.x,P.y] in [Rope,GreasedRope,RopeExtend]))
         or (Level[P.Ox,P.Oy] in [Rope,GreasedRope,Water,DeepWater])
         or (bGInBounds and (Level[P.x,P.y + g] in StandItems))
         or (bGInBounds and (Level[P.x,P.y + g] in InvStandItems) and (Custom[P.x,P.y + g] = 1)) )
           then if ((GoKey in [1..3]) and (g = -1))
                or ((GoKey in [7..9]) and (g = 1))
                  then begin
                         GoKey := 0;  {player can't move this way}
                         MB
                       end;
       end;
     Top, TopDark : {no change};
   end; {View case}
 end;

begin
  case GoKey of
    1 : begin
          Dec(P.x);  Inc(P.y);
          SideCheck
        end;
    2 : begin
          Inc(P.y);
          SideCheck
        end;
    3 : begin
          Inc(P.x);  Inc(P.y);
          SideCheck
        end;
    4 : Dec(P.x);
    6 : Inc(P.x);
    7 : begin
          Dec(P.x);  Dec(P.y);
          SideCheck
        end;
    8 : begin
          Dec(P.y);
          SideCheck
        end;
    9 : begin
          Inc(P.x);  Dec(P.y);
          SideCheck
        end;
  end; {GoKey case}
  Level[P.ox,P.oy] := P.OnItem  {<--- do here???}
end;

{-----------------------------------------------}

Procedure GetStartPos(var Num, Method : integer);
  {* Decide where player starts on level through this plan:
     1st: If player is on desired item, then start there.
     2nd: Starting at top-left corner, look through level for desired item;
           if found, start player at first one discovered.
     3rd: Starting at top-left corner, look through level for BLANK spot;
           if found, start player at first one discovered.
     4th: If no spot is available, go to next level and re-do search there.}

var  Find : byte;
     OldNum, Sx, Sy :  integer;
begin
  case Method of
    DOWN  : Find := UpStairs;  {item to look for}
    UP    : Find := DownStairs;
    FALL  : Find := BLANK;
    PTo   : Find := PortalTo;
    PFrom : Find := PortalFrom;
  end;
  if Level[P.x,P.y] <> Find {try to place player at same pos}
    then begin     {on new level...else look for item somewhere on level}
           Sx := 0;  Sy := 0;
           for j := 1 to 24 do
             for i := 1 to 64 do
               if (Level[i,j] = Find) and (Sx = 0)
                 then begin
                        Sx := i;  Sy := j
                      end;
           if (Sx = 0)       {item not found}
             then begin
                    for j := 1 to 24 do
                      for i := 1 to 64 do
                        if (Level[i,j] = BLANK) and (Sx = 0)
                          then begin
                                 Sx := i;  Sy := j
                               end;
                    if (Sx = 0)      {BLANK spot not found}
                      then begin     {skip to next level, search again}
                             OldNum := Num;
                             Inc(Num);
                             LoadLevel(OldNum,Num,Method);
                             EXIT
                           end  {to next level}
                  end  {BLANK search}
         end  {Find search}
    else begin    {1st spot was good}
           Sx := P.x;
           Sy := P.y
         end;
  if (Sx <> 0)    {spot was found}
    then begin
           P.x := Sx;
           P.y := Sy;
           MU;
           if Level[P.x,P.y] <> BLANK
             then P.OnItem := Find
         end;
  P.ox := P.x;
  P.oy := P.y
end;  {GetStartPos}

Procedure ItemSetup;
  {* Show special items' effects on level - only lanterns so far}
var Trav : Item;

begin
  Trav := HeadItem^.next;
  while Trav <> nil do
    begin
      with Trav^ do
        case Species of
          Lantern : begin
            if (Custom[x,y] in [1..3])
              then Inc(Custom[x,y],3) else Dec(Custom[x,y],3);
            if On then for i := 1 to 64 do
                         for j := 1 to 24 do
                           LightItem(Custom[x,y],i,j);
            if (Custom[x,y] in [1..3])
              then Inc(Custom[x,y],3) else Dec(Custom[x,y],3);
          end;
        end;
      Trav := Trav^.next
    end
end;

Procedure NewListObject(i, j : integer);
  {* Appends to dynamic lists the info record for special item at (i,j)}
  {NOTE: Item must be at position (i,j) BEFORE this procedure is called}
begin
  case Level[i,j] of
    M1a..G3     : NewMonster(i,j,Level[i,j]);
    MW1..FB3    : NewMvgObj(i,j,Level[i,j]);
    Tree,Freeze..InvPotion2,PowerUp,PortalTo,PortalFrom,
    AntiGravity : NewItem(i,j,Level[i,j],0,Morphing);
    Lantern, MonZap,
    RMonZap     : NewItem(i,j,Level[i,j],Custom[i,j],Switching);
    HealthGem, PowerGem, HotSpot, KStatue, MonGen, RMonGen, MagicDoor,
    MagicKey, GemPouch, MScroll,
    GoldNugget  : NewItem(i,j,Level[i,j],0,Flashing);
    MagicSpear  : NewItem(i,j,Level[i,j],Custom[i,j],Missile);
  end {case}
end;

Procedure RestoreLists;
  {* Place every moving object in its respective list}
begin
  for i := 1 to 64 do
    for j := 1 to 24 do
      NewListObject(i,j)
end;

Procedure FlipLevel(MustFlip : boolean; LStat : LStatRec;
          FLvl, FCus : LevelMatrix; var TLvl, TCus : LevelMatrix);
  {* If LStat data says to: level is reflected horizontally and/or vertically}
var  Chr1, Chr2  : byte;     {holds one spot of level}

begin
  if (not MustFlip) {MustFlip = reverse-reflect level back to normal}
    then begin
         if LStat.XFlip and (Random(8) < 4)  {50% level is reflected}
           then FlipX := TRUE
           else FlipX := FALSE;
         if LStat.YFlip and (Random(8) < 4)
           then FlipY := TRUE
           else FlipY := FALSE
         end;
  P.x := SymX(P.x);   {put player in reflected (or not) position}
  P.y := SymY(P.y);

  for y := 1 to 24 do
    for x := 1 to 64 do
      begin
        Chr1 := FLvl[SymX(x),SymY(y)];  {get Xth/Sym(Xth) char in row}
        Chr2 := FCus[SymX(x),SymY(y)];
        TLvl[x,y] := Chr1;
        TCus[x,y] := Chr2;
        case Chr1 of             {modify directional characters}
          DownSW  : if FlipY then TLvl[x,y] := UpSW;
          UpSW    : if FlipY then TLvl[x,y] := DownSW;
          LeftSW  : if FlipX then TLvl[x,y] := RightSW;
          RightSW : if FlipX then TLvl[x,y] := LeftSW;
          MagicSpear : begin
              if FlipY then
                case TCus[x,y] of
                  1..3 : Inc(TCus[x,y],6);
                  7..9 : Dec(TCus[x,y],6)
                end;
              if FlipX then
                case TCus[x,y] of
                  1,4,7 : Inc(TCus[x,y],2);
                  3,6,9 : Dec(TCus[x,y],2)
                end;
            end;
        end {Chr1 case}
      end  {one spot}
end;

Procedure LoadLevel(OldNum, Num, Method : integer);
  {* Loads level Num into memory and performs init routines}
var LInfo : LevelRec;

begin
  InvisTime  := 0;
  FreezeTime := 0;  SlowTime := 0;  HasteTime := 0;  {reset spells}
  UpdateStats;
  DisposeMonsters;  {remove all monsters from list}
  DisposeMvgObjs;   {remove all moving objects from list}
  DisposeItems;     {remove all items from list}
  if LData.View in [Top,Side]     {erase level exited}
    then BlankBoard(1,1,64,24)
    else FillWindow(1,1,64,24, #255, DarkGray); {dark level}

  LInfo.LStat  := LData;
  FlipLevel(TRUE,LInfo.LStat,Level,Custom,
               LInfo.Level,LInfo.Custom); {must flip level back, then save}
  Seek(LevelF,OldNum);
  Write(LevelF,LInfo);     {...save old level}

  if Num > 25 then EXIT;

  Seek(LevelF,Num);        {and read new level...}
  Read(LevelF,LInfo);
  LData := LInfo.LStat;
  Level := LInfo.Level;
  GetStartPos(Num,Method);   {find where player starts on level}
  FlipLevel(FALSE,LInfo.LStat,LInfo.Level,
               LInfo.Custom,Level,Custom); {may reflect level map}
  MU;

  RestoreSpecials;
  RestoreLists;

  HGColor := Random(7) + 1;  {set up level colors}
  repeat
    PGColor := Random(7) + 1
  until PGColor <> HGColor;
  if LData.View in [Top,Side]   {draw level entered}
    then FillBoard(1,1,64,24)
    else DrawLevel(P.x - 3,P.y - 2,P.x + 3,P.y + 2);
  ItemSetup;               {init item effects on level}

  Window(1,1,80,25);  FlashMan;  PrintMan;
  WhiteMessage('  ' + LData.Name + '  ');   {level title}
  if LData.Music <> 0      {intro music}
    then PlayWav(MusicFile[LData.Music] + '.wav');
  Message('  ' + LData.Name + '  ')
end;


(************************* ITEMS ***************************)

Procedure DoWalls(Spot : byte);
begin
  MB;
  Dec(IncScore,1);
  UpdateStats;
  if Random(2) = 1
    then Thump
    else HitWall;
  case Spot of
    SolidW..DownSW,     {solid}
    LetterWall : PrintMessage(1);  {message char}
    BW3 : PrintMessage(2);       {3-hit wall}
    BW2 : PrintMessage(3);       {2-hit wall}
    BW1 : PrintMessage(4);       {1-hit wall}
  end {case}
end;

Procedure DoInvSolidW;
begin
  Custom[P.x,P.y] := 1;
  DrawPos(P.x,P.y);
  MB;
  PrintMan;
  Thump;
  PrintMessage(6)
end;

Procedure DoInvBW1;
begin
  Custom[P.x,P.y] := 1;
  DrawPos(P.x,P.y);
  MB;
  PrintMan;
  Thump;
  PrintMessage(7)
end;

Procedure DoTree;
begin
  MB;
  Dec(IncScore,2);
  UpdateScore;
  Thump;
  PrintMessage(10)
end;

Procedure DoRock;
begin
  MB;
  Dec(IncScore,2);
  UpdateScore;
  Thump;
  PrintMessage(30)
end;

Procedure DoForest;
begin
  MB;
  Dec(IncScore,1);
  UpdateScore;
  Thump;
  PrintMessage(11)
end;

Procedure DoDenseForest;
begin
  MB;
  Dec(IncScore,1);
  UpdateScore;
  Thump;
  PrintMessage(12)
end;

Procedure DoInvWTrap;
  {* Turns several wall sections in the level invisible}
var  Wx, Wy, WallsToDo : integer;

begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  GetSkill(WallsToDo,75,100,125);
  repeat
      Num := 1;
      repeat
        Wx := Random(64) + 1;
        Wy := Random(24) + 1;
        Inc(Num)
      until (Level[Wx,Wy] in [SolidW,BW1]) or (Num > 2000);
      if Num <= 2000
        then begin    {make one wall invisible}
               Dec(WallsToDo);
               PSound(2000 + Random(3000),3);
               case Level[Wx,Wy] of
                 SolidW : Level[Wx,Wy] := InvSolidW;
                 BW1    : Level[Wx,Wy] := InvBW1;
               end;
               DrawPos(Wx,Wy);
               NoSound
             end;
  until (WallsToDo = 0) or (Num > 2000);
  PrintMessage(41)
end;

Procedure RemNoMoveSpots(x, y : integer);
  {* Removes all connected NoMove2 items touching (x,y)}
begin
  if (x < 1) or (x > 64) or (y < 1) or (y > 24)    {boundary check}
    then EXIT;
  if Level[x,y] = NoMove2
    then begin
           Level[x,y] := BLANK;           {remove no-move spot}
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

Procedure DoLava;
begin
  P.OnItem := Lava;
  P.Color := LightRed + Red * 16;
  P.Chr := #1;
  PrintMan;
  Fry;
  for i := 1 to 5 do
    begin
      SetBorder(Red); SetBorder(LightRed); SetBorder(Red); SetBorder(Black)
    end;
  Dec(P.Health,10);
  Inc(IncScore,500);
  UpdateStats;
  PrintMessage(13)
end;

Procedure DoWater;
begin
  case LData.View of
    Top, TopDark : begin
           P.OnItem := Water;
           P.Color := Yellow + Blue * 16;
           P.Chr := #2;
           PrintMan;
           WaterSpot2;
           PrintMessage(25)
         end;
    Side, SideDark : begin
           P.OnItem := Water;
           P.Color := LightCyan + Blue * 16;
           PrintMan;
           PrintMessage(72)
         end
  end
end;

Procedure DoDeepWater;
begin
  case LData.View of
    Top, TopDark : if P.OnItem = Raft
      then begin
           Level[P.ox,P.oy] := DeepWater;
           DrawPos(P.ox,P.oy);
           PrintMan
           end
      else begin
           MB;
           Dec(IncScore,1);
           UpdateScore;
           WaterSpot;
           PrintMessage(14)
         end;
    Side, SideDark : if P.OnItem = Raft
      then begin
           Level[P.ox,P.oy] := DeepWater;
           DrawPos(P.ox,P.oy);
           PrintMan
           end
      else begin
           P.OnItem := DeepWater;
           P.Color := LightGreen + Blue * 16;
           P.Chr := #1;
           PrintMan;
           PrintMessage(73)
         end
  end
end;

Procedure DoIce;
begin
  case LData.View of
    Top, TopDark : begin
      P.Color := Yellow + LightGray * 16;
      PrintMan;
      PrintMessage(9);
      P.OnItem := Ice
    end;
    Side, SideDark : begin
      MB;
      Dec(IncScore,1);
      Thump;
      PrintMessage(67)
    end
  end;
end;

Procedure DoForceField;
var x : integer;

begin
  MB;
  SC(P.x,P.y,#2,P.Color);
  Dec(IncScore,2);
  Dec(P.Health);
  UpdateStats;
  if P.Health < 0 then P.OnItem := ForceField;  {for Fate}
  Fry;
  for x := 1 to 4 do
    begin
      SetBorder(Yellow); SetBorder(White); SetBorder(Yellow); SetBorder(Red);
      PhaseScrChr(1,1,64,24, 1)     {special effect}
    end;
  SetBorder(Black);
  PrintMessage(8)
end;

Procedure DoHotSpot;
begin
  P.OnItem := HotSpot;
  P.Color := Red;  P.Chr := #1;
  PrintMan;
  Click1;
  PrintMessage(58)
end;

Procedure DoStickySpot;
begin
  P.OnItem := StickySpot;
  PrintMan;  MU;
  Custom[P.x,P.y] := 1;   {show trap}
  WaterSpot;
  FreezeTime := 0;
  SlowTime := 0;
  Inc(HasteTime,15);
  PrintMessage(59)
end;

Procedure FallIntoSky;
  {* Player "falls" into sky and dies - side view}
var  Last : integer;

begin
  P.Health := -100;
  Window(1,1,64,24);  TextAttr := Blue * 16;  ClrScr;    {draw sky}
  TextAttr := LightGray + Blue * 16;
  for Num := 1 to 24 do
    begin
      GotoXY(Random(59) + 1,Random(24) + 1);
      Write('ÕÕÕÕÕ');
    end;
  Window(32,1,34,24);  TextAttr := Blue * 16;  ClrScr;
  Window(33,1,33,25);  {player at x = 32}

  TextAttr := LightBlue;
  Last := 25;
  j := 25;
  for Num := 35 to 2400 do
    begin
      PSound(Num,Num div 450);
      if (Num mod 100) = 0
        then begin
               Last := j;
               Dec(j)            {man speeds up as he falls}
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
  GotoXY(1,1);
  Write('*')
end;

Procedure SidewaysPit;
  {* Player falls down pit and dies - side view}
var  Last : integer;

begin
  P.Health := -100;
  Window(1,1,64,24);  TextAttr := LightGray * 16;  ClrScr;    {draw pit}
  Window(22,1,30,25);
  for Num := 1 to 24 do
    Write('ÕÕÕÕÖÖÖ××');
  Window(36,1,44,25);
  for Num := 1 to 24 do
    Write('××ÖÖÖÕÕÕÕ');
  Window(31,1,35,24);  TextAttr := Black;  ClrScr;
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
      GotoXY(P.x,P.y);
      TextAttr := P.Color mod 16;  {black background}
      case Num of
        1200 : Write('O');
        1050 : Write(#9 );
         900 : Write('ø');
         650 : Write('ù');
         350 : Write('ú');
         100 : Write(' ')
      end; {Num case}
      PSound(Num,2)
    end
end;

Procedure DoPit;
begin
  PrintMan;
  P.OnItem := Pit;
  Message('Oops -- you find yourself over a large chasm... (Bye!)');
  case LData.View of
    Top, TopDark : BottomlessPit;
    Side, SideDark : if g = 1 then SidewaysPit else FallIntoSky
  end;
  SetBorder(LightRed);
  Squish1;
  SetBorder(0);
  Window(1,1,65,25);
  Message('* SPLAT *');
  RemKeys;
  case LData.View of
    Top, TopDark   : P.Health := -1;     {flashing '*'}
    Side, SideDark : P.Health := -100    {no flashing '*'}
  end;
  FreezeTime := 100;    {to avoid final screen redraws}
  BlankTime := 100;
  LData.View := Top;
  UpdateStats
end;

Procedure DoChest;
begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  Message('Inside the chest you find...');
  case Custom[P.x,P.y] of
    1 : Message('...nothing!');
    2 : begin
      Message('...a long sword, polished and sharpened to perfection!');
      GetSkill(P.Sword,10,7,4);
      UpdateStats;  Prize
    end;
    3 : begin
      Message('...a Stone Key!');
      Inc(P.SKeys);
      UpdateStats
    end;
    4 : begin
      Message('...a Bronze Key!');
      Inc(P.BKeys);
      UpdateStats
    end;
    5 : begin
      Message('...a Magic Key!');
      Inc(P.MKeys);
      UpdateStats
    end;
    6 : begin
      Message('...10 Health Gems!');
      Inc(P.Health,10);
      UpdateStats
    end;
    7 : begin
      Message('...20 Health Gems!!');
      Inc(P.Health,20);
      UpdateStats
    end;
    8 : begin
      Message('...5 Power Gems!');
      Inc(P.Sword,5);
      UpdateStats
    end;
    9 : begin
      Message('...10 Power Gems!');
      Inc(P.Sword,10);
      UpdateStats
    end;
   10 : begin
      Message('...a Magic Scroll!');
      Inc(P.Magic);
      UpdateStats
    end;
   11 : begin
      Message('...2,500 Gold Pieces!');
      Inc(IncScore,2500)
    end;
   12 : begin
      Custom[P.x,P.y] := 14;
      CreateMonsters;  CreateMonsters;
      Message('...monsters!!')
    end;
   13 : begin
      Toast;
      Dec(P.Health,4);  UpdateStats;
      Level[P.x,P.y] := HotSpot;
      P.OnItem := HotSpot;
      NewItem(P.x,P.y,HotSpot,0,Flashing);
      PrintMan;
      Message('...a fire trap!')
    end;
   14 : begin
      Message('...an artifact which powers up your sword!');
      SwordPowerUp
    end;
   99 : begin
      Message('...that you have found the way to Eternal Life and Love!');
      Message('(The journey to this joy has just begun!)');
      BigSecret := TRUE
    end;
  end  {case}
end;

Procedure DoLockedChest;
begin
  if P.SKeys = 0
    then begin
           MB;  LockedDoor;
           PrintMessage(68)
         end
    else begin  {unlock chest}
           Dec(P.SKeys);
           UpdateStats;
           Click1;  Delay(100);
           Level[P.x,P.y] := TChest;  DrawPos(P.x,P.y);  MB;
           Click1;
           PrintMan;
           PrintMessage(69)
         end
end;

Procedure GetAdjSpot(var ox, oy, x, y : integer);  {in/out}
  {* Returns pos for blank space next to tunnel at (x,y)}
var  BlankSpots : array[-1..1,-1..1] of boolean;
           Open : boolean;
           i, j : integer;

begin
  {Compile set of open spots around tunnel}
  Open := FALSE;
  for i := -1 to 1 do
    for j := -1 to 1 do
      if ((x + i < 1) or (x + i > 64) or (y + j < 1) or (y + j > 24))
        then BlankSpots[i,j] := FALSE          {spot is off the board}
        else if (Level[x + i,y + j] in [BLANK,Dirt,NoMove1..NoMove3])
               then begin
                      BlankSpots[i,j] := TRUE;  {spot is blank}
                      Open := TRUE              {at least one spot is open}
                    end
               else BlankSpots[i,j] := FALSE;   {spot not blank}

  {Choose one of open spots at random}
  if Open
    then begin
           repeat
             i := Random(3);                {choose random open spot}
             j := Random(3);
           until BlankSpots[i-1,j-1];
           ox := x;                             {saves (x,y) as (ox,oy)}
           oy := y;
           Inc(x,i-1);                            {set new (x,y) to open spot}
           Inc(y,j-1)
         end
end;

Procedure DoTunnel(TunType : byte);
  {* Moves man to another tunnel on level}
const SearchLimit : word = 5000;   {times can randomly search for tunnel exit}
var  OldX, OldY,            {entrance tunnel}
     NewX, NewY : integer;  {player's new pos from exit tunnel}
begin
  PrintMessage(15);
  OldX := P.x;  OldY := P.y;  {keep 1st tunnel's pos}
  MB;  NoSound;
  FlashMan;                       {visual effect}
  DrawPos(P.x,P.y);
  Squish1;

  Num := 0;     {counter - tests whether another tunnel is open}
  repeat
    repeat
      NewX := Random(64) + 1;
      NewY := Random(24) + 1;
      Inc(Num)
    until ((Level[NewX,NewY] = TunType) and ((NewX <> OldX) or (NewY <> OldY)))
        or (Num > SearchLimit);
    if (Num <= SearchLimit)
      then GetAdjSpot(OldX,OldY,NewX,NewY);  {find Spot next to tunnel}
  until (Level[NewX,NewY] in [BLANK,Dirt,NoMove1..NoMove3])
        or (Num > SearchLimit);  {^--- make sure tunnel is open}

  if Num > SearchLimit
    then begin
           NewX := P.ox;
           NewY := P.oy;
           Message('You were turned around going through the tunnel...')
         end
    else if TunType = InvTunnel
           then begin   {exit tunnel appears}
                  Custom[OldX,OldY] := 1;
                  DrawPos(OldX,OldY)
                end;
  P.x := NewX;  P.y := NewY;  {place player by new tunnel}
  MU;
  P.OnItem := Level[P.x,P.y];
  FlashMan;
  PrintMan;
  RemKeys
end;

Procedure DoInvTunnel;
  {* Concealed tunnel appears - connects to other concealed tunnels}
begin
  Custom[P.x,P.y] := 1;
  DrawPos(P.x,P.y);
  PrintMessage(57);
  DoTunnel(InvTunnel)
end;

Procedure DoHGem(Item : byte);
begin
  P.OnItem := BLANK;
  if Item = HealthGem
    then ZapItem(P.x,P.y);
  PrintMan;
  Click2;
  Inc(P.Health);
  Inc(IncScore,10);
  UpdateStats;
  PrintMessage(16)
end;

Procedure DoPGem(Item : byte);
begin
  P.OnItem := BLANK;
  if Item = PowerGem
    then ZapItem(P.x,P.y);
  PrintMan;
  Click2;
  Inc(P.Sword);
  Inc(IncScore,10);
  UpdateStats;
  PrintMessage(17)
end;

Procedure DoGoldNugget;
begin
  P.OnItem := BLANK;
  ZapItem(P.x,P.y);
  PrintMan;
  Click1;
  Inc(IncScore,500);
  PrintMessage(23)
end;

Procedure DoMScroll;
begin
  P.OnItem := BLANK;
  ZapItem(P.x,P.y);
  PrintMan;
  Click3;
  Inc(P.Magic);
  Inc(IncScore,50);
  UpdateStats;
  PrintMessage(18)
end;

Procedure DoStoneKey;
begin
  Level[P.x,P.y] := BLANK;  P.OnItem := BLANK;
  PrintMan;
  Click3;
  Inc(P.SKeys);
  UpdateStats;
  PrintMessage(19)
end;

Procedure DoStoneDoor;
  {* Player encounters locked Stone door}
begin
  if P.SKeys = 0     {door is locked}
    then begin
           MB;
           LockedDoor;
           PrintMessage(20)
         end
    else begin           {door unlocks}
           Level[P.x,P.y] := BLANK;  P.OnItem := BLANK;
           Dec(P.SKeys);
           Inc(IncScore,100);
           UpdateStats;
           OpenDoor;
           PrintMan;
           PrintMessage(21)
         end
end;

Procedure DoInvSDoor;
  {* Invisible Stone Door appears}
begin
  if Custom[P.x,P.y] = 0
    then begin
           Custom[P.x,P.y] := 1;
           DrawPos(P.x,P.y);
           LockedDoor;
           MB;
           PrintMessage(22)
         end
    else DoStoneDoor
end;

Procedure DoBronzeKey;
begin
  Level[P.x,P.y] := BLANK;  P.OnItem := BLANK;
  PrintMan;
  Click3;
  Inc(P.BKeys);
  UpdateStats;
  PrintMessage(44)
end;

Procedure DoBronzeDoor;
  {* Player encounters locked Bronze door}
begin
  if P.BKeys = 0     {door is locked}
    then begin
           MB;
           LockedDoor;
           PrintMessage(46)
         end
    else begin           {door unlocks}
           Level[P.x,P.y] := BLANK;  P.OnItem := BLANK;
           Dec(P.BKeys);
           Inc(IncScore,250);
           UpdateStats;
           OpenDoor;
           PrintMan;
           PrintMessage(21)
         end
end;

Procedure DoInvBDoor;
  {* Invisible Bronze Door appears}
begin
  if Custom[P.x,P.y] = 0
    then begin
           Custom[P.x,P.y] := 1;
           DrawPos(P.x,P.y);
           LockedDoor;
           MB;
           PrintMessage(48)
         end
    else DoBronzeDoor
end;

Procedure DoMagicKey;
  {* Gives player 1 magic scroll}
begin
  P.OnItem := BLANK;
  ZapItem(P.x,P.y);
  PrintMan;
  Click3;
  Inc(P.MKeys);
  Inc(P.Magic);
  UpdateStats;
  for x := 1 to 50 do    {special visual effect, sound}
    SetBorder(Random(15) + 1);
  SetBorder(0);
  UseKey;
  PrintMessage(45)
end;

Procedure DoMagicDoor;
begin
  if P.MKeys = 0     {door is locked: -1 health}
    then begin
           MB;
           Dec(P.Health);  UpdateStats;
           for x := 1 to 25 do
             SetBorder(Random(3) + 13);
           SetBorder(0);
           Zap;
           PrintMessage(47)
         end
    else begin           {door unlocks}
           P.OnItem := BLANK;
           ZapItem(P.x,P.y);
           Dec(P.MKeys);
           Inc(IncScore,250);
           UpdateStats;
           for x := 1 to 50 do   {special visual effect, sound}
             SetBorder(Random(15) + 1);
           SetBorder(0);
           UseKey;
           PrintMan;
           PrintMessage(43)
         end
end;

Procedure DoInvPotion1;
  {* Blank player, not level}
begin
  P.OnItem := BLANK;
  ZapItem(P.x,P.y);
  P.Color := Black;
  PrintMan;
  for Num := 1 to 4 do  {cloaking sound};
    begin
      PSound(1200,60);
      NoSound;
      Delay(40)
    end;
  GetSkill(InvisTime,200,250,300);
  PrintMessage(29)
end;

Procedure DoInvPotion2;
  {* Blank level, not player}
var s : integer;

begin
  PrintMan;
  P.OnItem := BLANK;
  ZapItem(P.x,P.y);
  TextAttr := 0;
  s := 1700;
  for i := 1 to 64 do
    for j := 1 to 24 do
      begin
        PSound(s,1);
        Dec(s);
        SCol(i,j,0)
      end;
  NoSound;
  PrintMan;
  GetSkill(BlankTime,200,250,300);
  PrintMessage(71)
end;

Procedure PushBoulder;
  {* Player pushes 'O' in same direction as player is moving}
var View, Spot : byte;
    Px, Py     : integer;

begin
  Px := P.x;  Py := P.y;
  View := LData.View;
  LData.View := Top;
  MoveMan;                      {check next spot in same direction}
  LData.View := View;
  if not BoundCheck             {check borders}
    then begin
           MB;
           Thump;
           EXIT
         end;
  Spot := Level[P.x,P.y];
  if (Spot in FlashItems+[Freeze..InvPotion2])
    then ZapItem(P.x,P.y);
  if (Spot in [M1a..G3,MagicBomb,BLANK,Dirt,NoMove1..NoMove4] + EatItems)
    then begin                             {rock moves}
           Crumble1;
           if (Spot in EatItems + [MagicBomb] - [BLANK,Dirt]) {runs over item}
             then MidBeep2
             else if (Spot in [M1a..G3])  {flattens monster}
                    then begin
                           ZapMonster(P.x,P.y);
                           HighBeep2
                         end;
           Level[P.x,P.y] := Boulder;
           DrawPos(P.x,P.y);
           P.x := Px;  P.y := Py;
           Level[P.x,P.y] := BLANK;
           P.OnItem := BLANK;
           PrintMan
         end
    else case Spot of
      ForceField : begin         {hits force field - both destroyed}
            SC(P.x,P.y,'X',LightRed);
            Zap;
            Level[P.x,P.y] := BLANK;
            DrawPos(P.x,P.y);
            P.x := Px;  P.y := Py;
            Level[P.x,P.y] := BLANK;
            PrintMan;
            Inc(IncScore,100)
          end;
    Downstairs,Chute,Lava..DeepWater
        : begin           {boulder falls down hole of some type}
            P.x := Px;  P.y := Py;  {put man at boulder's position}
            Level[P.x,P.y] := BLANK;
            PrintMan;  MU;
            MoveMan;                  {go to pit's position... }
            TextAttr := LightGray;
            for i := 1200 downto 35 do {...and drop boulder in!}
              begin
                PSound(i,1);
                case i of
                  1200 : SC(P.x,P.y,#28,White);
                  1100 : SC(P.x,P.y,'O',White);
                  900  : SC(P.x,P.y,#9 ,White);
                  700  : SC(P.x,P.y,'ù',White);
                  400  : SC(P.x,P.y,'ú',White);
                  75   : DrawPos(P.x,P.y)
                end  {i case}
              end;
            NoSound;
            MB
          end;
    else begin      {boulder can't move - something blocks it}
           Thump;
           Dec(IncScore,1);
           UpdateStats;
           MB
         end
    end; {Spot case}
  PrintMessage(31)
end;

Procedure DoPushBlock;
  {* Pushes 'þ' in same direction as player moves}
  {* NOTES: can smash gems/chests}
var GK, Px, Py, Bx, By : integer;   {hold block's position}
    View, Spot : byte;
    bInBounds : boolean;

begin
  Px := P.x;  Py := P.y;  {store values}
  View := LData.View;
  LData.View := Top;
  repeat                  {more than one can be pushed}
    Click3;    {short push sound}
    MoveMan;
    bInBounds := BoundCheck;
  until (not bInBounds) or (Level[P.x,P.y] <> PushBlock);
  LData.View := View;
  if not bInBounds
    then begin
           {MB; -- already done in BoundCheck}
           Thump;
           EXIT
         end;
  Spot := Level[P.x,P.y];  GK := GoKey;
  if (Spot in FlashItems+[Freeze..InvPotion2])
    then ZapItem(P.x,P.y);
  case Spot of
    NoMove1..NoMove4,Dirt,
    BLANK : begin                     {block(s) pushed forward}
            Level[P.x,P.y] := PushBlock;
            DrawPos(P.x,P.y);
            P.x := Px;  P.y := Py;
            Level[P.x,P.y] := BLANK;
            P.OnItem := BLANK;
            PrintMan
          end;
    HealthGem..InvPGem
        : begin                     {block(s) smash item}
            Squish2;
            Level[P.x,P.y] := PushBlock;
            DrawPos(P.x,P.y);
            MB;  MoveMan;
            Level[P.x,P.y] := BLANK;
            P.OnItem := BLANK;
            PrintMan
          end;
    DownStairs,Chute,Lava..DeepWater
        : begin                     {end block falls in pit}
            Bx := P.x;
            By := P.y;
            P.x := Px;  P.y := Py;
            Level[P.x,P.y] := BLANK;
            P.OnItem := BLANK;
            PrintMan;
            for i := 1200 downto 35 do
              begin
                PSound(i,1);
                case i of
                  1200 : SC(Bx,By,#10,LightCyan + Cyan * 16);
                  1100 : SC(Bx,By,'þ',LightCyan);
                  800  : SC(Bx,By,'ù',Cyan);
                  400  : SC(Bx,By,'ú',Blue);
                  50   : DrawPos(Bx,By);
                end  {i case}
              end;
            NoSound
          end;
    ForceField : begin      {force field destroys block}
            SC(P.x,P.y,'Õ',LightRed + LightGray * 16);
            CrumbleWall;
            DrawPos(P.x,P.y);
            P.x := Px;  P.y := Py;
            Level[P.x,P.y] := BLANK;
            P.OnItem := BLANK;
            PrintMan;
            Inc(IncScore,50)
         end;
    else begin    {block can't move - something in the way}
           Thump;
           Dec(IncScore,1);
           UpdateStats;
           MB
         end
  end; {Spot case}
  PrintMessage(32)
end;

Procedure DoTeleTrap;
  {* Teleports player to random blank spot in level}
begin
  Dec(IncScore,10);
  UpdateStats;
  Level[P.x,P.y] := BLANK;
  PrintMan;  MU;
  for i := 0 to 50 do    {player disappears w/ crackle sound}
    begin
      PSound(Random(2000) + 530 - (i * 10),5);  {tone lowers}
      SC(P.x,P.y,#1,Random(127) + 1)
    end;
  NoSound;
  repeat          {get new spot - (x,y)}
    P.x := Random(64) + 1;
    P.y := Random(24) + 1
  until Level[P.x,P.y] = BLANK;
  PrintMan;  MU;
  FlashMan;
  PrintMan;
  P.OnItem := BLANK;
  PrintMessage(24)
end;

Procedure DoWarpTrap;
  {* Warps player to set (x,y) position}
begin
  PrintMan;  MU;
  Custom[P.x,P.y] := 1;  {show trap}
  for i := 0 to 50 do    {player disappears w/ crackle sound}
    begin
      PSound(Random(2000) + 530 - (i * 10),5);  {tone lowers}
      SC(P.x,P.y,#1,Random(127) + 1)
    end;
  NoSound;
  P.x := SymX(LData.Tx);
  P.y := SymY(LData.Ty);
  PrintMan;  MU;
  FlashMan;
  PrintMan;
  P.OnItem := BLANK;
  PrintMessage(70)
end;

Procedure DoGemPouch;
  {* Gives player health & power gems}
var  H, Po : integer;
    sH, sP : string[2];

begin
  P.OnItem := BLANK;  ZapItem(P.x,P.y);
  PrintMan;
  Prize; {Cash sound/bonus}
  case Custom[P.x,P.y] of
    1 : begin
    GetSkill(H, 0,0,1);
    GetSkill(Po,1,1,0)
    end;
    2 : begin
    GetSkill(H, Random(5) + 0,Random(4) + 1,Random(3) + 2);
    Po := (Random(4) + 2) - H;  if Po < 0 then Po := 0
    end;
    3 : begin
    GetSkill(H, Random(8) + 0,Random(6) + 1,Random(4) + 2);
    Po := (Random(6) + 5) - H;  if Po < 0 then Po := 0
    end;
    4 : begin
    GetSkill(H, Random(10) + 0,Random(8) + 1,Random(6) + 2);
    Po := (Random(12) + 9) - H; if Po < 0 then Po := 0
    end;
    else begin {5}
    GetSkill(H, Random(20) + 2,Random(17) + 5,Random(14) + 8);
    Po := 25 - H
    end;
  end;  {case}
  Inc(P.Health,H);
  Inc(P.Sword,Po);
  UpdateStats;
  Inc(IncScore,H * 10 + Po * 10);
  Str(H,sH);
  Str(Po,sP);
  if H = 0
    then GoldMessage('You found ' + sP + ' power gems inside the pouch!')
    else if Po = 0
           then GoldMessage('You found ' + sH + ' health gems inside the pouch!')
           else GoldMessage('You found ' + sH + ' health gems and ' + sP +
              ' power gems inside the pouch!')
end;

Procedure DoBuryGems;
  {* Randomly removes gems from level}
var  GemsLeft, Gx, Gy, c : integer;

begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  GetSkill(GemsLeft,24 + Random(7),14 + Random(12),7 + Random(15));
  c := 0;
  repeat
    Inc(c);
    Gx := Random(64) + 1;
    Gy := Random(24) + 1;
    if Level[Gx,Gy] in [HealthGem..InvPGem]
      then begin    {remove one gem}
             if (Level[Gx,Gy] in [HealthGem, PowerGem])
               then ZapItem(Gx,Gy);
             c := 0;
             PSound(35 + Random(50),30);
             NoSound;
             Dec(GemsLeft);
             Level[Gx,Gy] := BLANK;
             DrawPos(Gx,Gy);
             Delay(100)
           end
  until (GemsLeft = 0) or (c = 2000);
  PrintMessage(53)
end;

Procedure DoUnearthGems;
  {* Randomly places gems around the level}
var  GemsLeft, Gx, Gy, c : integer;

begin
  PrintMan;
  GetSkill(GemsLeft,20 + Random(6),13 + Random(10),6 + Random(14));
  c := 0;
  repeat
    Inc(c);
    Gx := Random(64) + 1;
    Gy := Random(24) + 1;
    if (Level[Gx,Gy] in [BLANK,Dirt,NoMove1])
      then begin       {place one gem}
             c := 0;
             PSound(35 + Random(2000),30);
             NoSound;
             Dec(GemsLeft);
             if Random(100) > 70
               then Level[Gx,Gy] := PowerGem
               else Level[Gx,Gy] := HealthGem;
             NewItem(Gx,Gy,Level[Gx,Gy],0,Flashing);
             DrawPos(Gx,Gy);
             Delay(75)
           end;
  until (GemsLeft = 0) or (c = 2000);
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMessage(54)
end;

Procedure DoRevealGems;
  {* Makes all invisible gems visible}
var s : integer;

begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  s := 50;
  for i := 1 to 64 do
    for j := 1 to 24 do
      if Level[i,j] in [InvHGem,InvPGem]
        then begin
               Dec(Level[i,j]);  {make visible}
               NewItem(i,j,Level[i,j],0,Flashing);
               DrawPos(i,j);
               PSound(s,6);
               Inc(s,10);
               NoSound
             end;
  PrintMessage(55)
end;

Procedure DoHideGems;
  {* Makes all visible gems invisible}
var s : integer;
    C : byte;

begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  s := 2000;
  for i := 1 to 64 do
    for j := 1 to 24 do
      if Level[i,j] in [HealthGem,PowerGem]
        then begin
               Inc(Level[i,j]);  {make invisible}
               C := Level[i,j];
               ZapItem(i,j);
               Level[i,j] := C;
               PSound(s,6);
               Dec(s,5);
               NoSound
             end;
  PrintMessage(56)
end;

Procedure DoFreeze;
begin
  P.OnItem := BLANK;  ZapItem(P.x,P.y);
  PrintMan;
  Whistle1;
  GetSkill(FreezeTime,300,250,200);
  PrintMessage(33)
end;

Procedure DoSlow;
begin
  P.OnItem := BLANK;  ZapItem(P.x,P.y);
  PrintMan;
  DownSpike1;
  GetSkill(SlowTime,350,300,250);
  if HasteTime > 0  {opposing spells nullify}
    then begin
           Dec(SlowTime,HasteTime);
           HasteTime := 0
         end;
  PrintMessage(34)
end;

Procedure DoHaste;
begin
  P.OnItem := BLANK;  ZapItem(P.x,P.y);
  PrintMan;
  WarpUp3;
  GetSkill(HasteTime,250,300,350);
  if SlowTime > 0   {Slow nullifies Haste}
    then begin
           Dec(HasteTime,SlowTime);
           SlowTime := 0
         end;
  PrintMessage(35)
end;

Procedure DoMagicSpear;
begin
  P.OnItem := BLANK;
  PrintMan;
  PrintMessage(36);
  FireMagicSpear(P.x,P.y)
end;

Procedure DoMagicBomb;
  {* Destroys all smashable items in radius of 5 around player}

 Procedure BombItem(x,y : integer);
   {* Decides if item at (x,y) is destroyed by magic bomb}
   {* NOTES: inv. door not affected, magic spear is}
 begin
  if ((x < 1) or (x > 64) or (y < 1) or (y > 24))
    then EXIT;
  case Custom[P.x,P.y] of
   1 : case Level[x,y] of
     BW1..BW3, Boulder, Forest, TeleTrap, StoneDoor, NoMove1..NoMove3,
     Surround, MagicSpear, BLANK,Dirt : begin
             PSound(100,2);
             Level[x,y] := BLANK;
             SC(x,y,'Û',Red)
           end;
     M1a..G3 : begin
                  PSound(70,2);
                  ZapMonster(x,y);
                  SC(x,y,'Û',Red)
                end;
     else PSound(35,2)
   end; {case Level[x,y]}
  2 : case Level[x,y] of
     M1a..G3 : begin
                  PSound(70,2);
                  ZapMonster(x,y);
                  SC(x,y,'Û',Red)
                end;
     else PSound(35,2)
   end;
  3 : case Level[x,y] of
     M1a..G3 : begin
                  PSound(70,2);
                  HarmMonster(x,y,1);
                  SC(x,y,'Û',Red)
                end;
     else PSound(35,2)
   end;
  4 : case Level[x,y] of
     BW1..BW3, Boulder, Dirt, BLANK : begin
             PSound(100,2);
             Level[x,y] := BLANK;
             SC(x,y,'Û',Red)
           end;
     else PSound(35,2)
   end;
  5 : case Level[x,y] of
     BW1..BW3 : begin
             PSound(150,2);
             Dec(Level[x,y]);
             DrawPos(x,y)
           end;
     BLANK,Dirt : begin
             PSound(100,2);
             SC(x,y,'Û',Red)
           end;
     else PSound(35,2)
   end;
  6 : case Level[x,y] of
     TeleTrap,StoneKey,BronzeKey,StoneDoor,BronzeDoor,HealthGem,PowerGem,MScroll,
     GoldNugget,NoMove1..NoMove3,Surround,MagicSpear,BLANK,Dirt : begin
             if (Level[x,y] in FlashItems)
               then ZapItem(x,y);
             PSound(100,2);
             Level[x,y] := BLANK;
             SC(x,y,'Û',Red)
           end;
     else PSound(35,2)
   end;
  7 : case Level[x,y] of
     BW1..DownSW : begin
             PSound(150,2);
             Level[x,y] := Pit;
             SC(x,y,'Û',LightGray)
           end;
     BLANK,Dirt : begin
             PSound(100,2);
             SC(x,y,'Û',DarkGray)
           end;
     else PSound(35,2)
   end;
  8 : case Level[x,y] of
     Water, DeepWater : begin
             PSound(2000,2);
             Inc(Level[x,y],2);  {inc. to ice}
             SC(x,y,'Û',Cyan)
           end;
     BLANK,Dirt : begin
             PSound(100,2);
             SC(x,y,'Û',Blue)
           end;
     else PSound(35,2)
   end;
  9 : case Level[x,y] of
     Tree : begin
              PSound(150,2);
              ZapItem(x,y);
              SC(x,y,'Û',Red)
            end;
     Forest, DenseForest, BLANK,Dirt : begin
             PSound(100,2);
             Level[x,y] := BLANK;
             SC(x,y,'Û',Red)
           end;
     else PSound(35,2)
   end;
  end  {Custom case}
 end; {BombItem}

var xMin, yMin : word;
begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  for i := 50 to 1050 do {warm-up sound}
    PSound(i,1);
  for i := 3000 downto 50 do
    PSound(i,0);
  for i := 1 to 5 do    {explodes outward from player}
    begin
      for j := (P.x - i) to (P.x + i) do
        BombItem(j,P.y - i);
      for j := (P.y - i + 1) to (P.y + i - 1) do
        BombItem(P.x - i,j);
      for j := (P.y - i + 1) to (P.y + i - 1) do
        BombItem(P.x + i,j);
      for j := (P.x - i) to (P.x + i) do
        BombItem(j,P.y + i);

      if P.x - i < 1 then xMin := 1 else xMin := P.x - i; {kludge - type casting}
      if P.y - i < 1 then yMin := 1 else yMin := P.y - i;

      PrintRectangle(xMin,yMin,P.x + i,P.y + i) {redraw section}
    end;
  NoSound
end;

 Procedure LightItem(Effect, x, y : integer);
   {* Decides if object at (x,y) is lit/unlit by Effect}
 begin
 { if (x < 1) or (x > 64) or (y < 1) or (y > 24)
     then EXIT;}   {for Lantern2 only}
   case Effect of
    1 : case Level[x,y] of
          InvSolidW..InvWTrap : Custom[x,y] := 1;
        end;
    2 : case Level[x,y] of
          InvSDoor, InvBDoor, InvHGem, InvPGem, NoMove1..NoMove4, TeleTrap,
          WarpTrap, UnearthGems..HideGems, InvTunnel,
          MonsterMake : Custom[x,y] := 1;
        end;
    3 : case Level[x,y] of
          BW1..DownSW : Custom[x,y] := 1;
        end;
    4 : case Level[x,y] of
          InvSolidW..InvWTrap : Custom[x,y] := 0;
        end;
    5 : case Level[x,y] of
          InvSDoor, InvBDoor, InvHGem, InvPGem, NoMove1..NoMove4,
          TeleTrap, WarpTrap, UnearthGems..HideGems, InvTunnel,
          MonsterMake : Custom[x,y] := 0;
        end;
    6 : case Level[x,y] of
          BW1..DownSW : Custom[x,y] := 0;
        end;
   end; {Effect}
   if not (LData.View in [TopDark,SideDark]) then DrawPos(x,y)
 end; {LightItem}
(*
Procedure Lantern2(x, y : integer);
  {* Shines outward with radius of 8 from player}
begin
  for i := 1 to 8 do    {shines outward from player}
    begin
      for j := (x - i) to (x + i) do
        LightItem(x,y,j,y - i);
      for j := (y - i + 1) to (y + i - 1) do
        LightItem(x,y,x - i,j);
      for j := (y - i + 1) to (y + i - 1) do
        LightItem(x,y,x + i,j);
      for j := (x - i) to (x + i) do
        LightItem(x,y,j,y + i);
    end;
end;
*)
Procedure DoLantern;
  {* Affects visiblity of certain objects on level}
var Res : boolean;
    i,j : integer;
begin
  if Custom[P.x,P.y] = 0
    then begin
           MB;  Thump;
           Message('This lantern is burned out.');
           EXIT
         end;
  Click4;  Delay(250);
  TurnOn(P.x,P.y,Res);            {switch lamp on/off}
{  Lantern2(P.x,P.y);}
  PhaseScrCol(1,1,64,24, 4);
  if Res then s := 35 else s := 1700;
  for i := 1 to 64 do             {show effect}
    for j := 1 to 24 do
      begin
        PSound(s,1);
        if Res then Inc(s) else Dec(s);
        LightItem(Custom[P.x,P.y],i,j)
      end;
  if (Custom[P.x,P.y] in [1..3])
    then Inc(Custom[P.x,P.y],3)
    else Dec(Custom[P.x,P.y],3);
  MB; NoSound;
  PrintMessage(52)
end;

Procedure SwordPowerUp;
  {* Increases sword strength by (+1)}
begin
  P.OnItem := BLANK;
  ZapItem(P.x,P.y);
  PrintMan;
  for i := 35 to 500 do
    begin
      PSound(i,6);
      SC(P.x,P.y,#1,Random(15) + 1)
    end;
  NoSound;
  PrintMan;
  Inc(P.SwordPower);
  UpdateStats;
  PrintMessage(37)
end;

Procedure DoMonsterZap;
  {* Randomly removes NumToZap monsters from level}
var  Trav   : Monster;  {traverses monster list}
     NumToZap : integer;

begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  GetSkill(NumToZap,25 + Random(26),23 + Random(23),21 + Random(20));
  Trav := HeadMonster^.next;
  repeat
    if HeadMonster^.next = nil then EXIT; {all monsters gone - spell is done}
    for Num := 1 to 5 + Random(50) do   {get random monster}
      begin
        if Trav = nil             {at end of list -- go to head}
          then Trav := HeadMonster^.next;
        Trav := Trav^.next
      end;
    if Trav = nil
      then Trav := HeadMonster^.next;

    with Trav^ do
    begin
     SC(Trav^.x,Trav^.y,#15,Random(3) + LightMagenta);  {or Yellow or White}
     Click2;
     Delay(15);
     Level[x,y] := OnItem;
     DrawPos(x,y);

     prev^.next := next;
     if next <> nil
       then next^.prev := prev;
    end; {with}
    Dispose(Trav);
    Trav := nil;

    Dec(NumToZap);
  until NumToZap = 0;
  PrintMessage(38)
end;

Procedure CreateMonsters;
  {* Places NumToMake monsters into level at random positions}
var  NumToMake, Rx, Ry : integer;
     Mon    : byte;

begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  GetSkill(NumToMake,12 + Random(18),15 + Random(21),18 + Random(24));
  repeat
    MakeRndMonster(Custom[P.x,P.y]);  {create a monster}
    Click1;
    Delay(15);
    Dec(NumToMake)
  until NumToMake = 0;
  PrintMessage(39)
end;

Procedure DoSurround;
  {* Places Item in all blank spots adjacent to player}
var  BlankSpots : array[-1..1,-1..1] of boolean;
   DisplayColor,  RndColor,
         Px, Py : integer;
           Item : byte;
    DisplayChar : char;

begin
  Level[P.x,P.y] := LetterWall;  {fill player's spot}
  PrintMan;

  case Custom[P.x,P.y] of
    1 : begin
          Item := GoldNugget;  DisplayChar := #15;  DisplayColor := Yellow
        end;
    2 : begin
          Item := HealthGem;  DisplayChar := #4; DisplayColor := HGColor
        end;
    3 : begin
          Item := PowerGem;  DisplayChar := #9;  DisplayColor := PGColor
        end;
    4 : begin
          Item := InvPotion1;  DisplayChar := '¤';  DisplayColor := Magenta
        end;
    5 : begin
          Item := BW1;  DisplayChar := 'Õ';  DisplayColor := LData.WC
        end;
    6 : begin
          Item := SolidW;  DisplayChar := ' ';  DisplayColor := LData.WC
        end;
    7 : begin
          Item := Forest;  DisplayChar := 'Ö';  DisplayColor := LightGreen
        end;
    8 : begin
          Item := Boulder;  DisplayChar := #28;  DisplayColor := LightGray
        end;
    9 : begin
          Item := Lava;  DisplayChar := 'Ö';  DisplayColor := LightRed
        end;
   10 : begin
          Item := Water;  DisplayChar := '×';  DisplayColor := LightBlue
        end;
   11 : begin
          Item := DeepWater;  DisplayChar := 'Õ';  DisplayColor := Blue
        end;
   12 : begin
          Item := StoneDoor;  DisplayChar := 'é';  DisplayColor := LightGray * 16
        end;
   13 : begin
          Item := M3a;  DisplayChar := 'ê';  DisplayColor := Magenta
        end;
  end;

  for Px := (P.x - 1) to (P.x + 1) do    {place items around man}
    for Py := (P.y - 1) to (P.y + 1) do
      if (Px >= 1) and (Px <= 64) and (Py >= 1) and (Py <= 24) and
         (Level[Px,Py] in [BLANK,Dirt,NoMove1,Surround])
        then begin                   {place item}
               Level[Px,Py] := Item;
               NewListObject(Px,Py);
               BlankSpots[Px - P.x,Py - P.y] := TRUE
             end
        else BlankSpots[Px - P.x,Py - P.y] := FALSE;

  for Num := 4 to 28 do       {flash items}
    begin
      PSound(Num * 10,40);
      RndColor := DisplayColor + (Random(7) + 1) * 16;
      for Px := -1 to 1 do
        for Py := -1 to 1 do
          if BlankSpots[Px,Py]
            then SC(Px + P.x,Py + P.y,DisplayChar,RndColor);
    end;

  NoSound;
  for Px := -1 to 1 do       {draw items normally}
    for Py := -1 to 1 do
      if BlankSpots[Px,Py]
        then DrawPos(Px + P.x,Py + P.y);
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK
end;

Procedure DoRope;
begin
  P.OnItem := Rope;
  PrintMan;
  PrintMessage(49)
end;

Procedure DoGreasedRope;
begin
  P.OnItem := GreasedRope;
  PrintMan;
  PrintMessage(50)
end;

Procedure DoAntiGravity;
  {* Side: Reverses direction of gravity}
  {* Top:  Reflects level upside-down}
var  Chr1, Chr2 : byte;        {holds one spot of level}
     TLvl, TCus : LevelMatrix;
     Mstr : Monster;
     MObj : MvgObj;
     Itm  : Item;
     s    : integer;

begin
  P.OnItem := BLANK;
  ZapItem(P.x,P.y);
  PrintMan;
  SetBorder(15);
  case LData.View of
    Side, SideDark : begin
        g := -g;
        PhaseScrCol(1,1,64,24, 16);     {special effect}
        PhaseShift;
        PhaseScrChr(1,1,64,24, 16)
      end;  {Side}
    Top, TopDark : begin
      s := 1700;
      for y := 1 to 12 do    {special effect}
        for x := 1 to 64 do
          begin
            PSound(s,1);
            Dec(s);
            SCol(x,y,0);
            SCol(x,25 - y,0)
          end;
      FlipY := not FlipY;
      P.y := 25 - P.y;
      for y := 1 to 24 do       {write vertical reflection to temp vars}
       for x := 1 to 64 do
        begin
          Chr1 := Level[x,25 - y];
          Chr2 := Custom[x,25 - y];
          TLvl[x,y] := Chr1;
          TCus[x,y] := Chr2;
          case TLvl[x,y] of             {modify directional characters}
            DownSW  : TLvl[x,y] := UpSW;
            UpSW    : TLvl[x,y] := DownSW;
            MagicSpear : case TCus[x,y] of
                1..3 : Inc(TCus[x,y],6);
                7..9 : Dec(TCus[x,y],6)
              end;
          end; {TLvl case}
        end;   {x,y loop}
      Level := TLvl;        {restore level vars}
      Custom := TCus;

      Mstr := HeadMonster^.next;    {update dynamic lists' records}
      while Mstr <> nil do
        begin
          Mstr^.y := 25 - Mstr^.y;
          Mstr^.oy := 25 - Mstr^.oy;
          Mstr := Mstr^.next
        end;
      MObj := HeadMvgObj^.next;
      while MObj <> nil do
        begin
          MObj^.y := 25 - MObj^.y;
          MObj^.oy := 25 - MObj^.oy;
          MObj := MObj^.next
        end;
      Itm := HeadItem^.next;
      while Itm <> nil do
        begin
          Itm^.y := 25 - Itm^.y;
          Itm := Itm^.next
        end;

      s := 35;
      for y := 12 downto 1 do    {redraw screen}
        for x := 1 to 64 do
          begin
            PSound(s,1);
            Inc(s);
            DrawPos(x,y);
            DrawPos(x,25 - y)
          end;
      end;  {Top}
  end; {case}
  SetBorder(0);
  NoSound;
  PrintMessage(51)
end;

Procedure DoRopeExtend(TagNo : byte);
  {* Extends rope from other ropes with same tag number}
var  Rx, Ry : integer;

 Procedure ExtendRope(var Rx,Ry : integer);
 begin
   Level[Rx,Ry] := BLANK;
   Num := 50;
   while (Level[Rx,Ry + 1] in [BLANK,Dirt,HealthGem..InvPGem,M1a..G3,RopeExtend])
   and (Ry < 24) do
     begin                           {extend rope until it reaches an item}
       PSound(Num - 25,25);
       SC(Rx,Ry,#25,Random(15) + 1);
       PSound(Num,75);
       if (Level[Rx,Ry] in [HealthGem,PowerGem]) then ZapItem(Rx,Ry);
       Level[Rx,Ry] := Rope;
       if not ((Rx = P.x) and (Ry = P.y))
         then DrawPos(Rx,Ry)        {draw rope}
         else begin                  {rope forms on player's spot}
                MU; PrintMan
              end;
       Inc(Ry);                      {check next lower spot}
       Inc(Num,50)
     end;
   NoSound
 end;  {ExtendRope}

begin
  Level[P.x,P.y] := BLANK;
  P.OnItem := BLANK;
  PrintMan;
  for Rx := 1 to 64 do   {find rope(s) to extend}
    for Ry := 1 to 24 do
      if (Level[Rx,Ry] = RopeExtend) and (Custom[Rx,Ry] = TagNo)
        then ExtendRope(Rx,Ry)
end;

Procedure DoRaft;
begin
  P.OnItem := Raft;
  Level[P.x,P.y] := DeepWater;
  P.Color := LightMagenta + Blue * 16;
  P.Chr := #4;
  PrintMan;
  PrintMessage(62)
end;

Procedure DoUpStairs;
begin
  PrintMan;
  UpStairs1;
  PrintMessage(28);
  if (not Exited[LevelNum])
    then Inc(IncScore,LevelNum * 100);
  Exited[LevelNum] := TRUE;
  repeat
    ModScore(IncScore)     {add points not yet tallied}
  until IncScore = 0;
  Dec(LevelNum);
  LoadLevel(LevelNum + 1,LevelNum,UP)
end;

Procedure DoDownStairs;
begin
  PrintMan;
  DownStairs1;
  PrintMessage(27);
  if (not Exited[LevelNum])
    then Inc(IncScore,LevelNum * 100);
  Exited[LevelNum] := TRUE;
  repeat
    ModScore(IncScore)     {add points not yet tallied}
  until IncScore = 0;
  Inc(LevelNum);
  LoadLevel(LevelNum - 1,LevelNum,DOWN)
end;

Procedure DoChute;
begin
  P.OnItem := BLANK;
  PrintMan;
  BottomlessPit;
  NoSound;
  PrintMessage(26);
  if (not Exited[LevelNum])
    then Inc(IncScore,LevelNum * 100);
  Exited[LevelNum] := TRUE;
  repeat
    ModScore(IncScore)     {add points not yet tallied}
  until IncScore = 0;
  Inc(LevelNum);
  LoadLevel(LevelNum - 1,LevelNum,FALL)
end;

Procedure DoPortalTo(Find : byte);
var OldNum : integer;

begin
  PrintMan;  MU;  FlashMan;
  DrawPos(P.x,P.y);
  PrintMessage(60);
  if (not Exited[LevelNum])
    then Inc(IncScore,LevelNum * 100);
  Exited[LevelNum] := TRUE;
  repeat
    ModScore(IncScore)     {add points not yet tallied}
  until IncScore = 0;
  OldNum := LevelNum;
  LevelNum := Custom[P.x,P.y];
  LoadLevel(OldNum,LevelNum,Find)
end;

end.  {Unit VntrItem}
