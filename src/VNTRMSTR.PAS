Unit VntrMstr;  {created by Michael Rimer on 14 APR 94}

(*  All procedures involving monster creation/stats/movement *)
(*  for the game "The 'Merican Adventure".                   *)

(***)  Interface   (***)

Uses Crt, CrtEXTRA, VntrMisc, Sounds, VntrVars;

Procedure ModScore(var Change : integer);
Procedure PrintMan;

Procedure DrawPos(x, y : integer);

{----------------------}

Procedure ZapMonster(x, y : integer);
Procedure HarmMonster(x, y, Dmg : integer);
Procedure DrawMonster(x, y, Extra : integer);

Procedure MoveStandard(var Trav, Dead : Monster);
Procedure MoveSmart(var Trav, Dead : Monster);
Procedure MoveThief(var Trav, Dead : Monster);
Procedure MoveWizard(var Trav, Dead : Monster);
Procedure MoveGhost(var Trav, Dead : Monster);

Procedure TouchMonster;
Procedure MoveMonsters;

{----------------------}

Procedure ZapMvgObj(x, y : integer);
Procedure DrawMvgObj(x, y, Extra : integer);

Procedure MoveMovingWall(var Trav, Dead : MvgObj);
Procedure MoveDroppingFloor(var Trav, Dead : MvgObj);
Procedure MoveFallingBlock(var Trav, Dead : MvgObj);

Procedure TouchMvgObj;
Procedure MoveMvgObjs;

{----------------------}

Procedure MakeAdjMonster(x, y, Sel : integer);
Procedure MakeRndMonster(Sel : integer);

{----------------------}

Procedure ZapItem(x, y : integer);
Procedure DrawItem(x, y, Species : integer; var Extra : byte);

Procedure FireMagicSpear(sx, sy : integer);
Procedure MoveSpear(var S, Dead : Item);
Procedure MoveFireball(var F, Dead : Item);
Procedure MoveItems;

Procedure TurnOn(x, y : integer; var Res : boolean);

(**************************)
(***)  Implementation  (***)
(**************************)

Procedure ModScore(var Change : integer);
  {* Adds points to player's Score turn by turn - nice effect}

var  ToAdd, ToSub : integer;

begin
  if Change >= 0
    then begin
      case Change of
          0..12    : ToAdd := Change;
          13..99   : ToAdd := 13;
          100..499 : ToAdd := 47;
          500..999 : ToAdd := 91;
          else ToAdd := 179
      end; {Change case}
      Dec(Change,ToAdd);
      Inc(P.Score,ToAdd);
      PSound(300,5)
    end
    else begin
      case -Change of
          0..12    : ToSub := -Change;
          13..99   : ToSub := 13;
          100..499 : ToSub := 47;
          500..999 : ToSub := 91;
          else ToSub := 179
      end; {Change case}
      Inc(Change,ToSub);
      Dec(P.Score,ToSub);
      PSound(55,5)
    end;
  UpdateScore;
  NoSound
end;

Procedure PrintMan;
  {* Erases player from old position and draws him at new position}
begin
  DrawPos(P.ox,P.oy);
  SC(P.x,P.y,P.Chr,P.Color)
end;

Procedure DrawPos(x, y : integer);
  {* Draws object at level location (x,y)}
var  Pos : byte;

begin
  if (x < 1) or (x > 64) or (y < 1) or (y > 24) then EXIT;

  {Draw only in visible areas for dark levels}
  if (LData.View in [TopDark,SideDark]) and
      ((x < P.x - 3) or (x > P.x + 3) or (y < P.y - 2) or (y > P.y + 2))
    then begin
      SC(x,y,#255,DarkGray);  {draw filler}
      EXIT
    end;

  Pos := Level[x,y];
  case Pos of
    BLANK       : SC(x,y,' ',Black);
    Dirt        : SC(x,y,#255,LData.DC); {dirt patch}
    BW1         : if Custom[x,y] <> 1    {broken walls (1 - 3)}
                    then SC(x,y,'’',LData.WC)
                    else SC(x,y,' ',Black);
    BW2         : if Custom[x,y] <> 1
                    then SC(x,y,'÷',LData.WC)
                    else SC(x,y,' ',Black);
    BW3         : if Custom[x,y] <> 1
                    then SC(x,y,'◊',LData.WC)
                    else SC(x,y,' ',Black);
    SolidW      : if Custom[x,y] <> 1    {full solid wall}
                    then SC(x,y,'€',LData.WC)
                    else SC(x,y,' ',Black);
    LeftSW      : if Custom[x,y] <> 1    {half solid walls}
                    then SC(x,y,'›',LData.WC)
                    else SC(x,y,' ',Black);
    RightSW     : if Custom[x,y] <> 1
                    then SC(x,y,'ﬁ',LData.WC)
                    else SC(x,y,' ',Black);
    UpSW        : if Custom[x,y] <> 1
                    then SC(x,y,'ﬂ',LData.WC)
                    else SC(x,y,' ',Black);
    DownSW      : if Custom[x,y] <> 1
                    then SC(x,y,'‹',LData.WC)
                    else SC(x,y,' ',Black);
    LetterWall  : SC(x,y,Chr(Custom[x,y]),White + LData.WC * 16);
    InvSolidW   : if Custom[x,y] <> 1         {inv. solid wall}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'€',DarkGray);
    InvBW1      : if Custom[x,y] <> 1         {inv. broken wall}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'’',DarkGray);
    InvWTrap    : if Custom[x,y] <> 1         {invisible walls trap}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'˙',LightGray);
    Tree        : SC(x,y,#6,Green);      {tree}
    Rock        : SC(x,y,#127,Brown);    {rock, stationary}
    Lava        : SC(x,y,'÷',LightRed + Red * 16 + Blink); {lava}
    Pit         : SC(x,y,'’',DarkGray);  {bottomless pit}
    Water       : SC(x,y,'◊',LightBlue + Blue * 16 + Blink); {shallow water}
    DeepWater   : SC(x,y,'’',LightBlue + Blue * 16 + Blink); {deep water}
    Ice         : SC(x,y,'÷',LightCyan + LightGray * 16); {ice (over shallow water)}
    DeepIce     : SC(x,y,'÷',LightCyan + LightGray * 16); {ice (over deep water)}
    Forest      : SC(x,y,'’',LightGray + Green * 16); {forest - thin}
    DenseForest : SC(x,y,'◊',LightGreen + LightGray * 16); {forest - thick}
    ForceField  : SC(x,y,'’',Yellow + LightGray * 16 + Blink); {force field}
    HotSpot     : SC(x,y,'X',Red);       {hot spot}
    NoMove1..NoMove4 : if Custom[x,y] <> 1 {monster no-move spots (1 - 4)}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'˘',DarkGray);
    PushBlock   : SC(x,y,#10,LightBlue + Blue * 16); {pushable block}
    Boulder     : SC(x,y,#28,LightGray); {boulder, moveable}
    StickySpot  : if Custom[x,y] <> 1    {sticky spot}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'¯',Red);
    StoneDoor   : SC(x,y,'È',LightGray * 16); {locked stone door}
    BronzeDoor  : SC(x,y,'È',Red * 16);       {locked bronze door}
    MagicDoor   : SC(x,y,'ª',Yellow);         {magic door}
    InvSDoor    : if Custom[x,y] <> 1         {inv. stone door}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'È',LightGray);
    InvBDoor    : if Custom[x,y] <> 1         {inv. bronze door}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'È',Red);
    HealthGem   : SC(x,y,#4,HGColor);    {health gem}
    InvHGem     : if Custom[x,y] <> 1    {inv. health gem}
                    then SC(x,y,' ',Black)
                    else SC(x,y,#4,DarkGray);
    PowerGem    : SC(x,y,#9,PGColor);    {power gem}
    InvPGem     : if Custom[x,y] <> 1    {inv. power gem}
                    then SC(x,y,' ',Black)
                    else SC(x,y,#9,DarkGray);
    GemPouch    : SC(x,y,'Î',Yellow);    {pouch of gems}
    MScroll     : SC(x,y,'∑',LightBlue); {magic scroll}
    GoldNugget  : SC(x,y,#15,Yellow);    {treasure}
    StoneKey    : SC(x,y,'Â',LightGray); {stone key}
    BronzeKey   : SC(x,y,'Â',LightRed);  {bronze key}
    MagicKey    : SC(x,y,'Â',Yellow);    {magic key}
    TeleTrap    : if Custom[x,y] <> 1    {teleport trap}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'˘',LightGreen);
    WarpTrap    : if Custom[x,y] <> 1    {warp trap}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'˘',LightRed);
    Freeze      : SC(x,y,'¥',LightCyan); {freeze monsters}
    Slow        : SC(x,y,'¥',LightGreen);{slow monsters}
    Haste       : SC(x,y,'¥',LightRed);  {quicken monsters}
    InvPotion1  : SC(x,y,'§',Green);     {invisibility potion}
    InvPotion2  : SC(x,y,'§',Red);       {blindness potion}
    Rope        : SC(x,y,'≥',White);     {rope}
    GreasedRope : SC(x,y,'≥',LightGray); {greased rope}
    AntiGravity : SC(x,y,'Ÿ',LightCyan); {reverse gravity}
    RopeExtend  : SC(x,y,#25,White);     {rope extend}
    UnearthGems : if Custom[x,y] <> 1    {unearth gems}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'+',Yellow);
    BuryGems    : if Custom[x,y] <> 1    {bury gems}
                    then SC(x,y,' ',Black)
                    else SC(x,y,'-',Brown);
    RevealGems  : if Custom[x,y] <> 1    {reveal gems}
                    then SC(x,y,' ',Black)
                    else SC(x,y,#4,Yellow + LightGray * 16);
    HideGems    : if Custom[x,y] <> 1    {hide gems}
                    then SC(x,y,' ',Black)
                    else SC(x,y,#4,LightGray * 16);
    PowerUp     : SC(x,y,'Ù',Yellow);    {sword power-up}
    Tunnel      : SC(x,y,'Ô',White);     {teleport tunnel}
    InvTunnel   : if Custom[x,y] <> 1    {secret tunnel}
                   then SC(x,y,' ',Black)
                   else SC(x,y,'Ô',DarkGray);
    UpStairs    : SC(x,y,'',LightBlue + Blink); {stairs upward}
    DownStairs  : SC(x,y,'Ò',LightRed + Blink);  {stairs downward}
    Chute       : SC(x,y,'O',DarkGray);  {chute down}
    PortalTo    : SC(x,y,'©',LightGreen);{portal to level ...}
    PortalFrom  : SC(x,y,'©',LightRed);  {portal from level ...}
    MagicSpear  : case Custom[x,y] of    {magic spears}
                   2 : SC(x,y,#25,LightGray);
                   4 : SC(x,y,#27,LightGray);
                   6 : SC(x,y,#26,LightGray);
                   8 : SC(x,y,#24,LightGray);
                 1,9 : SC(x,y,'/',LightGray);
                 3,7 : SC(x,y,'\',LightGray);
                   5 : SC(x,y,Chr(Random(4) + 24),LightGray)
                  end;
    Surround    : SC(x,y,' ',Black);     {item surround}
    MagicBomb   : SC(x,y,'ù',White);     {magic bomb}
    Lantern     : SC(x,y,'Ë',Yellow);    {lantern}
    TChest      : SC(x,y,'≤',Yellow);    {treasure chest}
    LTChest     : SC(x,y,'±',Brown);     {locked treasure chest}
    MonsterZap  : SC(x,y,'',Red);       {instant monster zap}
    MonsterMake : if Custom[x,y] = 1     {instant create monsters}
                    then SC(x,y,'',Yellow)
                    else SC(x,y,' ',Black);
    MonZap      : SC(x,y,#11,Brown);     {zaps adjacent monsters}
    MonGen      : SC(x,y,#12,Red);       {generates adjacent monsters}
    RMonZap     : SC(x,y,#11,Cyan);      {zaps monsters in random areas}
    RMonGen     : SC(x,y,#12,Magenta);   {creates monsters in random areas}

    M1a..G3     : DrawMonster(x,y,0);    {monsters at full hits}
    MW1..FB3    : DrawMvgObj(x,y,0);     {moving walls, etc.}

    KStatue     : SC(x,y,#1,White + Blink); {killer statue}
    Raft        : SC(x,y,#4,LightMagenta + Blue * 16);  {boat}
    Special1..Special9 : SC(x,y,Specials[Pos - 139].Chr,Specials[Pos - 139].Color);   {Specials (1 - 9)}
  else SC(x,y,Chr(Pos),White + Blink)
  end {Pos case}
end;

(****************************************************)

Procedure ZapMonster(x, y : integer);
  {* Removes monster from monster list, level array, and screen}
var  M : Monster;

begin
  if ((x < 1) or (x > 64) or (y < 1) or (y > 24)) then EXIT;

  M := HeadMonster^.next; {find correct monster}
  while (M^.x <> x) or (M^.y <> y) do
    M := M^.next;

  Level[x,y] := M^.OnItem;      {remove from array}
  DrawPos(x,y);                 {erase from screen}
  {if monster getting zapped is a thief, and it was carrying something...}
  {...then drop it if it won't wreck the integrity of the level}
  if (M^.MT = Thief) and (M^.Carrying <> BLANK)
    then if M^.OnItem in [BLANK,NoMove1..Dirt,HealthGem..InvPGem]
      then Level[x,y] := M^.Carrying;

  M^.prev^.next := M^.next;       {remove from list}
  if M^.next <> nil
    then M^.next^.prev := M^.prev;
  Dispose(M)
end;

Procedure HarmMonster(x, y, Dmg : integer);
  {* Damages monster, kills if Hits < 1}
var  M : Monster;

begin
  M := HeadMonster^.next; {find correct monster}
  while (M^.x <> x) or (M^.y <> y) do
    M := M^.next;
  Dec(M^.Hits);
  if M^.Hits < 1       {monster dead - remove from list}
    then begin
           if (M^.MT = Thief) and (M^.Carrying <> BLANK)
             then begin
                    Level[x,y] := M^.Carrying;
                    if (Level[x,y] in FlashItems)
                      then NewItem(x,y,Level[x,y],0,Flashing);
                  end
             else Level[x,y] := M^.OnItem;
           M^.prev^.next := M^.next;
           if M^.next <> nil
             then M^.next^.prev := M^.prev;
           Dispose(M)
         end
    else begin         {monster weakened}
           Dec(M^.Species,3 * (Dmg + 1));
           Dec(Level[x,y],3 * (Dmg + 1))
         end
end;

Procedure DrawMonster(x, y, Extra : integer);
{* Draws monster at its position onscreen}
begin
  if (LData.View in [Top,Side])
  or ((x >= P.x - 3) and (x <= P.x + 3) and (y >= P.y - 2) and (y <= P.y + 2))
  then case Level[x,y] of
    M1a : SC(x,y,'Ñ',Red);       {standard}
    M2a : SC(x,y,'î',Green);
    M3a : SC(x,y,'Í',Magenta);
    M1b : SC(x,y,'é',Red);
    M2b : SC(x,y,'ì',Green);
    M3b : SC(x,y,'ö',Magenta);
    M1c : SC(x,y,'è',Red);
    M2c : SC(x,y,'ô',Green);
    M3c : SC(x,y,'Ä',Magenta);

   SM1a : SC(x,y,'Ñ',LightRed);  {smart}
   SM2a : SC(x,y,'î',LightGreen);
   SM3a : SC(x,y,'Í',LightMagenta);
   SM1b : SC(x,y,'é',LightRed);
   SM2b : SC(x,y,'ì',LightGreen);
   SM3b : SC(x,y,'ö',LightMagenta);
   SM1c : SC(x,y,'è',LightRed);
   SM2c : SC(x,y,'ô',LightGreen);
   SM3c : SC(x,y,'Ä',LightMagenta);

   T1 : SC(x,y,'∏',Brown);       {thief}
   T2 : SC(x,y,'∏',Green);
   T3 : SC(x,y,'∏',Red);

   W1a : case Extra of           {wizard}
           0 : SC(x,y,'ú',Cyan);
           1 : SC(x,y,'ú',DarkGray);
           2 : SC(x,y,'ú',Blue);
         end;
   W2a : case Extra of
           0 : SC(x,y,'ú',LightCyan);
           1 : SC(x,y,'ú',DarkGray);
           2 : SC(x,y,'ú',Blue);
         end;
   W3a : case Extra of
           0 : SC(x,y,'ú',White);
           1 : SC(x,y,'ú',Yellow);
           2 : SC(x,y,'ú',Red);
         end;
   W1b : case Extra of
           0 : SC(x,y,'æ',Cyan);
           1 : SC(x,y,'æ',DarkGray);
           2 : SC(x,y,'æ',Blue);
         end;
   W2b : case Extra of
           0 : SC(x,y,'æ',LightCyan);
           1 : SC(x,y,'æ',DarkGray);
           2 : SC(x,y,'æ',Blue);
         end;
   W3b : case Extra of
           0 : SC(x,y,'æ',White);
           1 : SC(x,y,'æ',Yellow);
           2 : SC(x,y,'æ',Red);
         end;

   G1..G3 : begin                {ghost}
             case Level[x,y] of
               G1 : k := DarkGray;
               G2 : k := LightGray;
               G3 : k := White;
             end;
             case Extra of
              0, Pit  : SC(x,y,'º',k);
              SolidW  : SC(x,y,'€',k);
              LeftSW  : SC(x,y,'›',k);
              RightSW : SC(x,y,'ﬁ',k);
              UpSW    : SC(x,y,'ﬂ',k);
              DownSW  : SC(x,y,'‹',k);
              Lava : SC(x,y,'º',k + Red * 16);
              Water..DeepWater : SC(x,y,'º',k + Blue * 16);
              Ice..DeepIce : SC(x,y,'º',k + LightGray * 16);
             end
            end;
  end {"Species" case}
end;

Procedure MoveStandard(var Trav, Dead : Monster);
  {* Converge directly on player's position - diagonally if possible}
  {* Cannot move through solid, etc. obstacles, BUT...}
  {* ...will break down breakable walls, and are hurt in the process}
  {* If comes into contact with player, both are damaged}
var  Wx, Wy : integer;

begin
  with Trav^ do
    begin
      Ox := x;
      Oy := y;
      if x < P.x
        then Inc(x)
        else if x > P.x
               then Dec(x);
      if not (LData.View in [Side,SideDark])
       then if y < P.y
              then Inc(y)
              else if y > P.y
                     then Dec(y);
      if (x = P.x) and (y = P.y)   {hits player}
        then begin
               HighBeep1;
               Dec(Hits);
               Dec(P.Health,Damage);
               UpdateStats;
               x := Ox;
               y := Oy;
               if Hits > 0
                 then begin       {monster is weakened}
                        Dec(Level[x,y],3);
                        Dec(Trav^.Species,3);
                        DrawMonster(x,y,0)
                      end
                 else begin
                        Level[Ox,Oy] := OnItem;
                        DrawPos(Ox,Oy);
                        Dead := Trav
                      end
             end
        else case Level[x,y] of
               BLANK,Dirt,Ice,DeepIce,HealthGem..BronzeKey,TeleTrap,
               Freeze..InvPotion2 : begin
                 if not (Level[x,y] in StepItems)
                   then Click1;   {eat sound}
                 if Level[x,y] in FlashItems+MorphItems
                   then ZapItem(x,y)
                   else if Level[x,y] in EatItems
                          then Level[x,y] := BLANK;
                 Level[Ox,Oy] := OnItem;
                 DrawPos(Ox,Oy);
                 OnItem := Level[x,y];
                 Level[x,y] := Species;
                 DrawMonster(x,y,0);
                 {movement sound}
               end;
               BW1..BW3 : begin
                 Dec(Hits);
                 Dec(Level[x,y]);
                 DrawPos(x,y);
                 x := Ox;
                 y := Oy;
                 if Hits > 0
                   then begin       {monster is weakened}
                          Dec(Level[x,y],3);
                          Dec(Trav^.Species,3);
                          DrawMonster(x,y,0)
                        end
                   else begin           {remove from list}
                          Level[x,y] := BLANK;
                          DrawPos(x,y);
                          Dead := Trav
                        end;
                 MidBeep1
               end;
               MW1..MW3 : begin     {Spot = moving wall, etc.}
                 Dec(Hits);
                 Wx := x;
                 Wy := y;
                 x := Ox;
                 y := Oy;
                 ZapMvgObj(Wx,Wy);  {remove wall}
                 if Hits > 0
                   then begin       {monster is weakened}
                          Dec(Level[x,y],3);
                          Dec(Trav^.Species,3);
                          DrawMonster(x,y,0)
                        end
                   else begin           {remove from list}
                          Level[x,y] := BLANK;
                          DrawPos(x,y);
                          Dead := Trav
                        end;
                 MidBeep1
               end;
             else begin      {solid object}
                    x := Ox;
                    y := Oy
                  end
             end {case}
    end
end;

Procedure MoveSmart(var Trav, Dead : Monster);
  {* Behaves as Standard type, BUT..,}
  {* ...if diagonal is blocked, will try to move sideways toward player}
var Wx, Wy : integer;

begin
  with Trav^ do
    begin
      Ox := x;
      Oy := y;
      if x < P.x
        then Inc(x)
        else if x > P.x
               then Dec(x);
      if not (LData.View in [Side,SideDark])
       then if y < P.y
              then Inc(y)
              else if y > P.y
                     then Dec(y);
      if (x = P.x) and (y = P.y)   {hits player}
        then begin
               HighBeep1;
               Dec(Hits);
               Dec(P.Health,Damage);
               UpdateStats;
               x := Ox;
               y := Oy;
               if Hits > 0
                 then begin       {monster is weakened}
                        Dec(Level[x,y],3);
                        Dec(Trav^.Species,3);
                        DrawMonster(x,y,0)
                      end
                 else begin
                        Level[Ox,Oy] := OnItem;
                        DrawPos(Ox,Oy);
                        Dead := Trav
                      end
             end
        else begin  {if monster can't go toward Player, try other directions}
               case Level[x,y] of
                 BLANK,Dirt,Ice,DeepIce,HealthGem..BronzeKey,TeleTrap,
                 Freeze..InvPotion2,BW1..BW3, MW1..MW3 : {can move here};
                 else begin  {(x,y) is blocked}
                        case Level[ox,y] of
                          BLANK,Dirt,Ice,DeepIce,HealthGem..BronzeKey,
                          TeleTrap,Freeze..InvPotion2, BW1..BW3,
                          MW1..MW3 : x := ox; {try another direction}
                          else y := oy   {try remaining direction}
                        end
                      end
               end; {"Smart" case}
               case Level[x,y] of
                 BLANK,Dirt,Ice,DeepIce,HealthGem..BronzeKey,TeleTrap,
                 Freeze..InvPotion2 : begin
                   if not (Level[x,y] in StepItems)
                     then Click1;   {eat sound}
                 if Level[x,y] in FlashItems+MorphItems
                   then ZapItem(x,y)
                   else if Level[x,y] in EatItems
                          then Level[x,y] := BLANK;
                   Level[Ox,Oy] := OnItem;
                   DrawPos(Ox,Oy);
                   OnItem := Level[x,y];
                   Level[x,y] := Species;
                   DrawMonster(x,y,0);
                   {movement sound}
                 end;
                 BW1..BW3 : begin
                   Dec(Hits);
                   Dec(Level[x,y]);
                   DrawPos(x,y);
                   x := Ox;
                   y := Oy;
                 if Hits > 0
                   then begin       {monster is weakened}
                          Dec(Level[x,y],3);
                          Dec(Trav^.Species,3);
                          DrawMonster(x,y,0)
                        end
                   else begin           {remove from list}
                            Level[x,y] := BLANK;
                            DrawPos(x,y);
                            Dead := Trav
                          end;
                   MidBeep1
                 end;
                 MW1..MW3 : begin     {Spot = moving wall, etc.}
                   Dec(Hits);
                   Wx := x;
                   Wy := y;
                   x := Ox;
                   y := Oy;
                   ZapMvgObj(Wx,Wy);  {remove wall}
                   if Hits > 0
                     then begin       {monster is weakened}
                            Dec(Level[x,y],3);
                            Dec(Trav^.Species,3);
                            DrawMonster(x,y,0)
                          end
                     else begin           {remove from list}
                            Level[x,y] := BLANK;
                            DrawPos(x,y);
                            Dead := Trav
                          end;
                   MidBeep1
                 end;
               else begin      {solid object}
                      x := Ox;
                      y := Oy
                    end
               end {case}
             end {not at player's potition}
    end
end;

Procedure MoveThief(var Trav, Dead : Monster);
  {* Behaves as Smart type, BUT...}
  {* ...will steal item from player, and run away from player with it!}
var Wx, Wy : integer;

  Procedure StealItem(var Carrying : byte);
  {Thief's desires:  Magic Key > Bronze Key > Stone Key >
                        > Magic Spell > Power Gems > Health Gems}
  var Item : byte;
  begin
    Item := 6;  {health least preferable}
    if P.Sword > 0 then Item := 5;
    if P.Magic > 0 then Item := 4;
    if P.SKeys > 0 then Item := 3;
    if P.BKeys > 0 then Item := 2;
    if P.MKeys > 0 then Item := 1;   {magic key most preferable}
    case Item of
      1 : begin
            Dec(P.MKeys);
            if P.Magic > 1
              then Dec(P.Magic);  {spell comes w/ key}
            Carrying := MagicKey
          end;
      2 : begin
            Dec(P.BKeys);
            Carrying := BronzeKey
          end;
      3 : begin
            Dec(P.SKeys);
            Carrying := StoneKey
          end;
      4 : begin
            Dec(P.Magic);
            Carrying := MScroll
          end;
      5 : begin
            Dec(P.Sword,2);
            Carrying := PowerGem
          end;
      6 : begin
            Dec(P.Health,3);
            Carrying := HealthGem
          end
    end  {case}
  end;  {StealItem}

begin  {MoveThief}
  with Trav^ do
    begin
      Ox := x;
      Oy := y;
      if Carrying = BLANK
        then begin    {move toward player - to get stolen item}
          if x < P.x
            then Inc(x)
            else if x > P.x
                   then Dec(x);
          if not (LData.View in [Side,SideDark])
            then if y < P.y
                   then Inc(y)
                   else if y > P.y
                          then Dec(y)
        end
        else begin    {move away from player - to keep stolen item}
          if x < P.x
            then Dec(x)
            else if x > P.x
                   then Inc(x)
                   else begin
                     Inc(x,Random(3));  {erratic fleeing}
                     Dec(x)  {type kludge}
                   end;
          if not (LData.View in [Side,SideDark])
            then if y < P.y
                   then Dec(y)
                   else if y > P.y
                          then Inc(y)
                          else begin
                            Inc(y,Random(3));  {erratic fleeing}
                            Dec(y);  {type kludge}
                          end;
          if x < 1 then x := 1 else if x > 64 then x := 64;
          if y < 1 then y := 1 else if y > 24 then y := 24;
        end;
      if (x = P.x) and (y = P.y)   {hits player - steals item}
        then begin
               Sprinkle;
               Dec(P.Health,Damage);
               StealItem(Carrying);
               UpdateStats;
               x := Ox;
               y := Oy;
             end
        else begin  {if monster can't go toward Player, try other directions}
               case Level[x,y] of
                 BLANK,Dirt,Ice,DeepIce,HealthGem..BronzeKey,TeleTrap,
                 Freeze..InvPotion2,BW1..BW3, MW1..MW3 : {can move here};
                 else begin  {(x,y) is blocked}
                        case Level[ox,y] of
                          BLANK,Dirt,Ice,DeepIce,HealthGem..BronzeKey,
                          TeleTrap,Freeze..InvPotion2, BW1..BW3,
                          MW1..MW3 : x := ox; {try another direction}
                          else y := oy   {try remaining direction}
                        end
                      end
               end; {"Smart" case}
               case Level[x,y] of
                 BLANK,Dirt,Ice,DeepIce,HealthGem..BronzeKey,TeleTrap,
                 Freeze..InvPotion2 : begin
                   if not (Level[x,y] in StepItems)
                     then Click1;   {eat sound}
                 if Level[x,y] in FlashItems+MorphItems
                   then ZapItem(x,y)
                   else if Level[x,y] in EatItems
                          then Level[x,y] := BLANK;
                   Level[Ox,Oy] := OnItem;
                   DrawPos(Ox,Oy);
                   OnItem := Level[x,y];
                   Level[x,y] := Species;
                   DrawMonster(x,y,0);
                   {movement sound}
                 end;
                 BW1..BW3 : begin
                   Dec(Hits);
                   Dec(Level[x,y]);
                   DrawPos(x,y);
                   x := Ox;
                   y := Oy;
                   if Hits > 0
                     then begin       {monster is weakened}
                            Dec(Level[x,y],3);
                            Dec(Trav^.Species,3);
                            DrawMonster(x,y,0)
                          end
                     else begin           {remove from list}
                            Level[x,y] := BLANK;
                            DrawPos(x,y);
                            Dead := Trav
                          end;
                   MidBeep1
                 end;
                 MW1..MW3 : begin     {Spot = moving wall, etc.}
                   Dec(Hits);
                   Wx := x;
                   Wy := y;
                   x := Ox;
                   y := Oy;
                   ZapMvgObj(Wx,Wy);  {remove wall}
                   if Hits > 0
                     then begin       {monster is weakened}
                            Dec(Level[x,y],3);
                            Dec(Trav^.Species,3);
                            DrawMonster(x,y,0)
                          end
                     else begin           {remove from list}
                            Level[x,y] := BLANK;
                            DrawPos(x,y);
                            Dead := Trav
                          end;
                    MidBeep1
                 end;
               else begin      {solid object}
                      x := Ox;
                      y := Oy
                    end
               end {case}
             end {not at player's potition}
    end
end;

Procedure MoveWizard(var Trav, Dead : Monster);
  {* Appears in random pos, in line with player;
     Shoots fireball at player;
     Disappears }
var  TItem, Cust : integer;
begin
  with Trav^ do
    begin
      Dec(WaitTime);
      case MoveRound of
        Hiding : begin
                   if WaitTime <= 0
                     then begin    {wizard pops up}
                            MoveRound := Stands;
                            WaitTime := 2;
                            repeat
                              x := Random(64) + 1;
                              y := Random(24) + 1
                            until (Level[x,y] = BLANK)
                              and ((x = P.x) xor (y = P.y));
                            Level[x,y] := Species;
                            DrawPos(x,y);
                            SCol(x,y,DarkGray);  {dim}
                          end
                 end;
        Stands : begin
                   DrawPos(x,y);
                   if WaitTime <= 0
                     then begin    {fire shot - make correct trajectory}
                            MoveRound := Fired;
                            WaitTime := 3;
                            Cust := 4;
                            if x < P.x
                              then Inc(Cust,3)
                                else if x > P.x
                                then Dec(Cust,3);
                            if y < P.y
                              then Inc(Cust)
                              else if y > P.y
                                     then Dec(Cust);
                            Inc(Cust,10 * ((Species - W1a) mod 3));
                            TItem := Level[x,y];
                            Level[x,y] := Fireball;
                            NewItem(x,y,Fireball,Cust,Missile);
                            Level[x,y] := TItem;
                            Sprinkle
                          end
                 end;
        Fired  : begin
                   if WaitTime <= 0
                     then begin   {wizard disappears}
                            MoveRound := Hiding;
                            WaitTime := 4;
                            Level[x,y] := BLANK;
                            DrawPos(x,y)
                          end
                 end;
      end {case}
    end
end;

Procedure MoveGhost(var Trav, Dead : Monster);
  {* Behaves as Standard type, but will pass through walls to reach player}
begin
  with Trav^ do
    begin
      Ox := x;
      Oy := y;
      if x < P.x
        then Inc(x)
        else if x > P.x
               then Dec(x);
      if y < P.y
        then Inc(y)
        else if y > P.y
               then Dec(y);
      if (x = P.x) and (y = P.y)  {ghost cannot move into player}
        then begin
               Zap;
               Dec(P.Health,Damage);
               UpdateStats;
               x := Ox;
               y := Oy
             end
      else case Level[x,y] of
             BLANK, Dirt, HealthGem..MagicKey, Freeze..Haste : begin
               Level[Ox,Oy] := OnItem;
               DrawPos(Ox,Oy);
               OnItem := Level[x,y];  {save item ghost moves onto}
               Level[x,y] := Species;
               DrawMonster(x,y,0)
             end;
             BW1..DownSW, Lava..DeepIce : begin
               Level[Ox,Oy] := OnItem;
               DrawPos(Ox,Oy);
               OnItem := Level[x,y];
               Level[x,y] := Species;
               DrawMonster(x,y,OnItem)
             end;
           else begin
             x := Ox;
             y := Oy
           end
      end {case}
    end  {with Trav^}
end;


{-------------------------}

Procedure TouchMonster;
  {* Hurts/removes monster when touched, and damages player}
var  M : Monster;

begin
  M := HeadMonster^.next;      {find correct monster}
  while (M^.x <> P.x) or (M^.y <> P.y) do
    M := M^.next;

  case M^.Species of
    M1a..M3c : begin    {normal type}
        Dec(P.Health,M^.Damage);     {damage player}
        UpdateStats;
        Dec(M^.Hits);     {monster damaged}
        if M^.Hits < 1
          then begin      {monster dies}
                 HighBeep2;
                 Level[P.x,P.y] := M^.OnItem;
                 P.OnItem := Level[P.x,P.y];
                 Inc(IncScore,10 * (M^.Species - M1a + 1));
                 PrintMan;
                 M^.prev^.next := M^.next;    {remove monster}
                 if M^.next <> nil
                   then M^.next^.prev := M^.prev;
                 Dispose(M)
               end
          else begin      {monster survives, but is weaker}
                 Dec(Level[M^.x,M^.y],3);
                 Dec(M^.Species,3);
                 DrawMonster(M^.x,M^.y,0);
                 MidBeep1;
                 MB
               end
      end; {with}
    SM1a..SM3c : begin    {smart}
        Dec(P.Health,M^.Damage);     {damage player}
        UpdateStats;
        Dec(M^.Hits);     {monster damaged}
        if M^.Hits < 1
          then begin      {monster dies}
                 HighBeep2;
                 Level[P.x,P.y] := M^.OnItem;
                 P.OnItem := Level[P.x,P.y];
                 Inc(IncScore,15 * (M^.Species - SM1a + 1));
                 PrintMan;
                 M^.prev^.next := M^.next;    {remove monster}
                 if M^.next <> nil
                   then M^.next^.prev := M^.prev;
                 Dispose(M)
               end
          else begin      {monster survives, but is weaker}
                 Dec(Level[M^.x,M^.y],3);
                 Dec(M^.Species,3);
                 DrawMonster(M^.x,M^.y,0);
                 MidBeep1;
                 MB
               end
      end; {with}
    T1..T3 : begin    {thief}
        Dec(P.Health,M^.Damage);     {damage player}
        UpdateStats;
        Dec(M^.Hits);     {monster damaged}
        if M^.Hits < 1
          then begin      {monster dies}
                 HighBeep2;
                 Level[P.x,P.y] := M^.Carrying;
                 if (Level[P.x,P.y] in FlashItems+MorphItems)
                   then NewItem(P.x,P.y,Level[P.x,P.y],0,Flashing);
                 MB;
                 Inc(IncScore,25 * (M^.Species - T1 + 1));
                 PrintMan;
                 M^.prev^.next := M^.next;    {remove monster}
                 if M^.next <> nil
                   then M^.next^.prev := M^.prev;
                 Dispose(M)
               end
          else begin      {monster survives, but is weaker}
                 Dec(Level[M^.x,M^.y]);
                 Dec(M^.Species);
                 DrawMonster(M^.x,M^.y,0);
                 MidBeep1;
                 MB
               end
      end; {with}
    W1a..W3b : begin    {wizard}
        Dec(P.Health,M^.Damage);     {damage player}
        UpdateStats;
        Dec(M^.Hits);     {monster damaged}
        if M^.Hits < 1
          then begin      {monster dies}
                 HighBeep2;
                 Level[P.x,P.y] := M^.OnItem;
                 P.OnItem := Level[P.x,P.y];
                 Inc(IncScore,20 * (M^.Species - W1a + 1));
                 PrintMan;
                 M^.prev^.next := M^.next;    {remove monster}
                 if M^.next <> nil
                   then M^.next^.prev := M^.prev;
                 Dispose(M)
               end
          else begin      {monster survives, but is weaker}
                 Dec(Level[M^.x,M^.y],3);
                 Dec(M^.Species,3);
                 DrawMonster(M^.x,M^.y,0);
                 MidBeep1;
                 MB
               end
      end; {with}
    G1..G3 : begin    {ghost}
        Dec(P.Health,M^.Damage);  {damage player, monster unhurt}
        UpdateStats;
        Zap;
        MB
      end;
  end {Species case}
end;

Procedure MoveMonsters;
  {* Traverse entire monster list, moving each one according to behavior}
var  DeadMonster,     {holds any monster records to be removed from list}
     Trav : Monster;  {traverses list}
     T, speed : integer;     {speed offset}

begin
  T := 3;                      {time-modifiers}
  if HasteTime > 0 then T := 6;
  if SlowTime > 0 then T := 1;

  DeadMonster := nil;          {no monsters to remove yet}
  Trav := HeadMonster^.next;   {start past first (unused) node in list}

  while Trav <> nil do         {go through list}
    begin
      while (Trav <> nil) and ((Moves mod (1 + (Trav^.Speed * 3 div T))) <> 0) do
        Trav := Trav^.next;    {monster can't move yet...check next}
      if Trav = nil
        then EXIT;             {found end of list - stop procedure}

      if ((Trav^.x >= 1) and (Trav^.x <= 64) and (Trav^.y >= 1) and (Trav^.y <= 24))
      then case Trav^.MT of     {move monster according to behavior type}
            Standard      : MoveStandard(Trav,DeadMonster);
            Smart         : MoveSmart(Trav,DeadMonster);
            Thief         : MoveThief(Trav,DeadMonster);
            Wizard        : MoveWizard(Trav,DeadMonster);
            Ghost         : MoveGhost(Trav,DeadMonster);
          end {case Trav^.MT}
      else DeadMonster := Trav; {!!temp fix -- monster out of bounds for some reason -- remove it}

      Trav := Trav^.next;      {go to next monster in list}
      if DeadMonster <> nil    {remove dead monster}
        then begin
               DeadMonster^.prev^.next := DeadMonster^.next;
               if DeadMonster^.next <> nil
                 then DeadMonster^.next^.prev := DeadMonster^.prev;
               Dispose(DeadMonster);
               DeadMonster := nil
             end
    end {while Trav <> nil}
end;

(****************************************************)

Procedure ZapMvgObj(x, y : integer);
  {* Removes moving object from mov. obj. list, level array, and screen}
var  O : MvgObj;

begin
  Level[x,y] := BLANK;          {remove from array}
  DrawPos(x,y);                 {erase from screen}

  O := HeadMvgObj^.next; {find correct monster}
  while (O^.x <> x) or (O^.y <> y) do
    O := O^.next;
  O^.prev^.next := O^.next;       {remove from list}
  if O^.next <> nil
    then O^.next^.prev := O^.prev;
  Dispose(O)
end;

Procedure DrawMvgObj(x, y, Extra : integer);
{* Draws moving item at its position on-screen}
begin
  if (LData.View in [Top,Side])
  or ((x >= P.x - 3) and (x <= P.x + 3) and (y >= P.y - 2) and (y <= P.y + 2))
  then case Level[x,y] of
    MW1 : SC(x,y,'’',LData.WC);
    MW2 : SC(x,y,'÷',LData.WC);
    MW3 : SC(x,y,'◊',LData.WC);
    DF1 : SC(x,y,'€',LData.WC);
    DF2 : SC(x,y,#28,LightGray);
    DF3 : SC(x,y,'◊',LData.WC);
    FB1 : SC(x,y,'€',LData.WC);
    FB2 : SC(x,y,#28,LightGray);
    FB3 : SC(x,y,'◊',LData.WC);
  end {Species case}
end;

Procedure MoveMovingWall(var Trav, Dead : MvgObj);
{* Behave as Standard type, BUT...
{* ...will not damage breakable walls, or player on contact}

begin
  with Trav^ do
    begin
      Ox := x;
      Oy := y;
      if x < P.x
        then Inc(x)
        else if x > P.x
               then Dec(x);
      if not (LData.View in [Side,SideDark])
        then if y < P.y
               then Inc(y)
               else if y > P.y
                      then Dec(y);
      if (x = P.x) and (y = P.y)  {wall cannot move into player}
        then begin
               x := Ox;
               y := Oy
             end
      else case Level[x,y] of
             BLANK,Dirt : begin
                       Level[Ox,Oy] := OnItem;
                       DrawPos(Ox,Oy);
                       OnItem := Level[x,y];
                       Level[x,y] := Species;
                       DrawMvgObj(x,y,0);
                       {movement sound}
                     end;
             else begin
               x := Ox;
               y := Oy
             end
      end {case}
    end
end;

Procedure MoveDroppingFloor(var Trav, Dead : MvgObj);
{* After player steps on it, will fall out from under him after n turns}
{* When falling, acts as FallingBlock type}

begin
  with Trav^ do
    if (not Stable) then
      begin   {floor is loose}
        Dec(WaitToFall);
        case Species of   {block flashes}
          DF1 : SC(x,y,'€',Random(2) + 7);
          DF2 : SC(x,y,#28,Random(2) + 7);
          DF3 : SC(x,y,'◊',Random(2) + 7)
        end; {case}
        if WaitToFall <= 0
          then begin    {floor falls}
                 MT := FallingBlock;  {becomes falling block type}
                 case Species of
                   DF1 : begin
                           Species := FB1;
                           Falling := TRUE;
                           Speed := 3
                         end;
                   DF2 : begin
                           Species := FB2;
                           Falling := TRUE;
                           Speed := 3
                         end;
                   DF3 : begin
                           Species := FB3;
                           Falling := TRUE;
                           Speed := 3
                         end;
                 end {Species}
               end  {floor falls}
      end
    else if (x = P.x) and (y - g = P.y) and
         not (Level[x,y + g] in StandItems + MonsterStand)
           then Stable := FALSE
end;

Procedure MoveFallingBlock(var Trav, Dead : MvgObj);
{* Travel downward on screen until it falls into hole, etc.}
{* Will sustain one damage point if it hits solid ground, and stop}
{* If contacts player, will damage him 10 points and be destroyed}

begin
  with Trav^ do
    if Falling
      then begin
             Oy := y;
             Inc(y,g);
             if y > 24
               then begin   {falls off screen}
                      Level[x,Oy] := OnItem;
                      DrawPos(x,Oy);
                      Dead := Trav
                    end
             else if (x = P.x) and (y = P.y)  {block falls on player}
               then begin
                      Squish2;
                      Dec(P.Health,10);
                      UpdateStats;
                      if P.Health < 0 then P.OnItem := FB1; {for Fate}
                      Level[x,Oy] := OnItem;
                      DrawPos(x,Oy);
                      Dead := Trav
                    end
               else case Level[x,y] of
                      BLANK,Dirt,HealthGem..BronzeKey,TeleTrap,Freeze..InvPotion2,
                      NoMove1..NoMove4 : begin
                        Level[x,Oy] := OnItem;
                        DrawPos(x,Oy);
                        if Level[x,y] in FlashItems+MorphItems
                          then ZapItem(x,y)
                          else if Level[x,y] in EatItems
                                 then Level[x,y] := BLANK;
                        OnItem := Level[x,y];
                        Level[x,y] := Species;
                        DrawMvgObj(x,y,0)
                      end;
                      Lava..DeepWater : begin     {block swallowed}
                        Level[x,Oy] := OnItem;
                        DrawPos(x,Oy);
                        Dead := Trav
                      end;
                    else begin  {block hits ground - stops falling}
                           Crumble1;
                           Falling := FALSE;
                           Dec(Hits);
                           if Hits = 0  {block breaks}
                             then begin
                                    Level[x,Oy] := OnItem;
                                    DrawPos(x,Oy);
                                    Dead := Trav
                                  end
                             else y := Oy  {block is intact, sits on ground}
                         end
                    end {case}
           end  {Falling}
      else case Species of
             FB1..FB3 : if (Abs(x - P.x) <= Proximity) and (y < P.y) and
                          not (Level[x,y + g] in StandItems + MonsterStand)
                          then Falling := TRUE;
           end {case}
end;

Procedure TouchMvgObj;
  {* Hurts/removes mvg obj. when touched, and damages player}
var  MObj : MvgObj;

begin
  MObj := HeadMvgObj^.next;      {find correct mvg obj.}
  while (MObj^.x <> P.x) or (MObj^.y <> P.y) do
    MObj := MObj^.next;

  case MObj^.Species of
    MW1..MW3,FB1..FB3 : begin  {moving wall, falling block}
        Thump;
        MB
      end;
    DF1..DF3 : begin           {block becomes loose}
        MObj^.Stable := FALSE;
        MB
      end;
  end {Species case}
end;

Procedure MoveMvgObjs;
  {* Traverse entire object list, moving each one according to behavior}
var  DeadMObj,     {holds any mvg obj. records to be removed from list}
     Trav : MvgObj;  {traverses entire mvg obj. list}
     T : integer;    {speed offset}

begin
  T := 3;                    {time-modifiers}
  if HasteTime > 0 then T := 6;
  if SlowTime > 0 then T := 1;

  DeadMObj := nil;           {no mvg obj's to remove yet}
  Trav := HeadMvgObj^.next;  {start past first (unused) node in list}

  while Trav <> nil do     {go through list}
    begin
      while (Trav <> nil) and ((Moves mod Trav^.Speed * 3 div T) <> 0) do
        Trav := Trav^.next;    {mvg obj. can't move yet...check next}
      if Trav = nil
        then EXIT;         {found end of list - stop procedure}

      case Trav^.MT of     {move mvg obj. according to behavior type}
          MovingWall    : MoveMovingWall(Trav,DeadMObj);
          DroppingFloor : MoveDroppingFloor(Trav,DeadMObj);
          FallingBlock  : MoveFallingBlock(Trav,DeadMObj);
        end; {case Trav^.MT}

      Trav := Trav^.next;      {go to next mvg obj. in list}
      if DeadMObj <> nil    {remove dead mvg obj.}
        then begin
               DeadMObj^.prev^.next := DeadMObj^.next;
               if DeadMObj^.next <> nil
                 then DeadMObj^.next^.prev := DeadMObj^.prev;
               Dispose(DeadMObj);
               DeadMObj := nil
             end
    end {while Trav <> nil}
end;

(**********************************************)

Procedure ZapAdjMonsters(x, y : integer);
  {* Remove any monsters adjacent to (x,y)}
begin
  for i := (x - 1) to (x + 1) do
    for j := (y - 1) to (y + 1) do
      if ((i >= 1) and (i <= 64) and (j >= 1) and (j <= 24))
        then case Level[i,j] of
{*}            M1a..G3 : begin
                           SC(i,j,#15,White);
                           Squeak;
                           ZapMonster(i,j);
                           Delay(3)
                         end;
             end
end;

Procedure ZapRndMonster(c : integer);
  {* Remove a random monster of some type from the level}
var Trav : Monster;
    ToZap : set of byte;
begin
  if HeadMonster^.next = nil then EXIT;  {all monsters gone}
  Trav := HeadMonster;
  case c of
    1 : ToZap := [M1a,M1b,M1c];
    2 : ToZap := [M2a,M2b,M2c];
    3 : ToZap := [M3a,M3b,M3c];
    4 : ToZap := [M1a..M3a];
    5 : ToZap := [M1b..M3b];
    6 : ToZap := [M1c..M3c];
    7 : ToZap := [M1a..M3c];
    8 : ToZap := [SM1a,SM1b,SM1c];
    9 : ToZap := [SM2a,SM2b,SM2c];
   10 : ToZap := [SM3a,SM3b,SM3c];
   11 : ToZap := [SM1a..SM3a];
   12 : ToZap := [SM1b..SM3b];
   13 : ToZap := [SM1c..SM3c];
   14 : ToZap := [SM1a..SM3c];
   15 : ToZap := [T1..T3];
   16 : ToZap := [W1a..W1b];
   17 : ToZap := [W2a..W2b];
   18 : ToZap := [W3a..W3b];
   19 : ToZap := [G1..G3];
  end;
  if c = 20  {zap random monster}
    then for Num := 1 to 1 + Random(75) do   {get random monster}
      begin
        Trav := Trav^.next;
        if Trav = nil             {at end of list -- go to head}
          then Trav := HeadMonster^.next;
      end
    else repeat
      Trav := Trav^.next
    until (Trav^.Species in ToZap) or (Trav = nil);
  if Trav = nil then EXIT;  {no monster of desired type found}

  with Trav^ do
  begin
    SC(Trav^.x,Trav^.y,#15,Random(3) + LightMagenta); {or Yellow or White}
    Click2;
    Delay(20);
    Level[x,y] := OnItem;
    DrawPos(x,y);

    prev^.next := next;
    if next <> nil
      then next^.prev := prev;
  end; {with}
  Dispose(Trav)
end;

Procedure MakeAdjMonster(x, y, Sel : integer);
  {* Create certain monster of type 'Sel' adjacent to generator at (x,y)}
var cnt : integer;
    NM  : byte;
begin
  cnt := 0;
  repeat
    i := x + Random(3);
    j := y + Random(3);
    Dec(i);
    Dec(j);  {kludge}
    Inc(cnt)
  until (((i >= 1) and (i <= 64) and (j >= 1) and (j <= 24) and (Level[i,j] = BLANK))
    and ((i <> P.x) or (j <> P.y))) or (cnt > 50);
  if (cnt > 50) then EXIT;   {no open spot found next to generator}
  case Sel of
    1 : NM := M1a + Random(3) * 3;
    2 : NM := M2a + Random(3) * 3;
    3 : NM := M3a + Random(3) * 3;
    4 : NM := M1a + Random(3);
    5 : NM := M1b + Random(3);
    6 : NM := M1c + Random(3);
    7 : NM := M1a + Random(9);
    8 : NM := SM1a + Random(3) * 3;
    9 : NM := SM2a + Random(3) * 3;
   10 : NM := SM3a + Random(3) * 3;
   11 : NM := SM1a + Random(3);
   12 : NM := SM1b + Random(3);
   13 : NM := SM1c + Random(3);
   14 : NM := SM1a + Random(9);
   15 : NM := T1 + Random(3);
   16 : NM := W1a + Random(2) * 3;
   17 : NM := W2a + Random(2) * 3;
   18 : NM := W3a + Random(2) * 3;
   19 : NM := G1 + Random(3);
  end;
  Level[i,j] := NM;
  NewMonster(i,j,NM);
  DrawMonster(i,j,0)
end;

Procedure MakeRndMonster(Sel : integer);
  {* Create certain monster (type Sel) in random location}
var i, j, cnt : integer;
    NM : byte;
begin
  cnt := 0;
  repeat
    i := Random(64) + 1;
    j := Random(24) + 1;
    Inc(cnt)
  until ((Level[i,j] = BLANK) and ((i <> P.x) or (j <> P.y))) or (cnt > 150);
  if cnt > 150 then EXIT;   {no empty spot found}
  NM := 0;
  case Sel of   {choose species of monster formed}
    1 : NM := M1a + Random(3) * 3;
    2 : NM := M2a + Random(3) * 3;
    3 : NM := M3a + Random(3) * 3;
    4 : NM := M1a + Random(3);
    5 : NM := M1b + Random(3);
    6 : NM := M1c + Random(3);
    7 : NM := M1a + Random(9);
    8 : NM := SM1a + Random(3) * 3;
    9 : NM := SM2a + Random(3) * 3;
   10 : NM := SM3a + Random(3) * 3;
   11 : NM := SM1a + Random(3);
   12 : NM := SM1b + Random(3);
   13 : NM := SM1c + Random(3);
   14 : NM := SM1a + Random(9);
   15 : NM := T1 + Random(3);
   16 : NM := W1a + Random(2) * 3;
   17 : NM := W2a + Random(2) * 3;
   18 : NM := W3a + Random(2) * 3;
   19 : NM := G1 + Random(3);
  end;
  if NM > 0 then begin
    Level[i,j] := NM;
    NewMonster(i,j,NM);
    DrawMonster(i,j,0)
  end;
end;

Procedure ZapItem(x, y : integer);
  {* Removes item from item list, level array, and screen}
var  I : Item;

begin
  Level[x,y] := BLANK;          {remove from array}
  DrawPos(x,y);                 {erase from screen}

  I := HeadItem^.next; {find correct item}
  while ((I^.x <> x) or (I^.y <> y)) and (I <> nil) do
    I := I^.next;
  if I = nil
    then EXIT;   {item not found in list (this is normally an error)}
  I^.prev^.next := I^.next;       {remove from list}
  if I^.next <> nil
    then I^.next^.prev := I^.prev;
  Dispose(I)
end;

Procedure DrawItem(x, y, Species : integer; var Extra : byte);
{* Draws moving item at its position on-screen}
begin
 case Species of
   KStatue : if Random(60) = 0
               then begin
                      HighBeep2;
                      Dec(P.Health);
                      UpdateStats;
                      Extra := 1
                    end;
   MonGen : if Random(70) = 0
              then begin
                     MakeAdjMonster(x,y,Custom[x,y]);
                     Click2;
                     Extra := 1
                   end;
   RMonGen : if Random(50) = 0
               then begin
                      MakeRndMonster(Custom[x,y]);
                      Click2;
                      Extra := 1
                    end;
 end; {case}
 if not ( ((P.x = x) and (P.y = y))   {player on item}
     or ( (LData.View in [TopDark,SideDark]) and
          ((x < P.x - 3) or (x > P.x + 3) or (y < P.y - 2) or (y > P.y + 2)) ))
 then case Species of
   Tree : SC(x,y,Chr(5+Extra),Green);   {morphing}
   Freeze : if Random(3) = 0
              then SC(x,y,Chr(180+Extra),LightBlue)
              else SC(x,y,Chr(180+Extra),LightCyan);
   Slow   : if Random(3) = 0
              then SC(x,y,Chr(180+Extra),Green)
              else SC(x,y,Chr(180+Extra),LightGreen);
   Haste  : if Random(3) = 0
              then SC(x,y,Chr(180+Extra),Red)
              else SC(x,y,Chr(180+Extra),LightRed);
   InvPotion1 : if Random(2) = 0
              then SC(x,y,Chr(164+Extra),Magenta)
              else SC(x,y,Chr(164+Extra),LightMagenta);
   InvPotion2 : if Random(2) = 0
              then SC(x,y,Chr(164+Extra),Blue)
              else SC(x,y,Chr(164+Extra),LightBlue);
   PowerUp    : if Random(3) = 0
              then SC(x,y,Chr(198+Extra),Yellow)
              else SC(x,y,Chr(198+Extra),White);
   PortalTo   : SC(x,y,Chr(169+Extra),LightGreen);
   PortalFrom : SC(x,y,Chr(169+Extra),LightRed);
   AntiGravity : if Random(2) = 0
              then SC(x,y,Chr(217+Extra),Cyan)
              else SC(x,y,Chr(217+Extra),LightCyan);

   Lantern : if Extra = 0        {flashing}
               then SC(x,y,'Ë',DarkGray)
               else if Random(3) = 0
                      then SC(x,y,'Ë',White) else SC(x,y,'Ë',Yellow);
   MonZap  : if Extra = 0
               then SC(x,y,#11,Brown)
               else begin
                      ZapAdjMonsters(x,y);
                      SC(x,y,#12,Yellow)
                    end;
   RMonZap : if Extra = 0
              then SC(x,y,#11,Cyan)
              else begin
                     if Random(30) = 0
                       then begin
                              ZapRndMonster(Custom[x,y]);
                              Squeak
                            end;
                     SC(x,y,#12,LightCyan)
                   end;

   HotSpot    : if Random(3) = 0
                  then SC(x,y,'X',LightRed) else SC(x,y,'X',Red);
   MagicDoor  : SC(x,y,'ª',Random(15) + 1);
   MagicKey   : SC(x,y,'Â',Random(15) + 1);
   HealthGem  : if Random(6) = 0
                  then SC(x,y,#4,HGColor + 8) else SC(x,y,#4,HGColor);
   PowerGem   : if Random(6) = 0
                  then SC(x,y,#9,PGColor + 8) else SC(x,y,#9,PGColor);
   GemPouch   : if Random(4) = 0
                  then SC(x,y,'Î',White) else SC(x,y,'Î',Yellow);
   MScroll    : if Random(3) = 0
                  then SC(x,y,'∑',LightBlue) else SC(x,y,'∑',LightCyan);
   GoldNugget : case Random(10) of
                  0..4 : SC(x,y,#15,Yellow);
                  5..6 : SC(x,y,#15,LightGray);
                  7..9 : SC(x,y,#15,White);
                end;
   KStatue : if Extra = 0
               then SC(x,y,#1,DarkGray)
               else begin
                      SC(x,y,#2,Random(7) + 8);
                      if Random(12) = 0 then Extra := 0
                    end;
   MonGen : if Extra = 0
              then SC(x,y,#12,Red)
              else begin
                     SC(x,y,#12,LightRed);
                     if Random(14) = 0 then Extra := 0
                   end;
   RMonGen : if Extra = 0
               then SC(x,y,#12,Magenta)
               else begin
                      SC(x,y,#12,LightMagenta);
                      if Random(10) = 0 then Extra := 0
                    end;
 end {case}
end;

Procedure FireMagicSpear(sx, sy : integer);
  {* Magic spear fires, destroys all monsters + EatItems}
var  S : Item;
begin
  S := HeadItem^.next;
  while ((S^.x <> sx) or (S^.y <> sy))  {find spear in item list}
    do S := S^.next;
  if (S^.x = P.x) and (S^.y = P.y) and S^.Fired   {spear hits player}
    then begin
           PrintMan;  Crumble2;
           ZapItem(sx,sy);
           Dec(P.Health,S^.Dmg);
           UpdateStats
         end
    else begin
           Level[sx,sy] := BLANK;
           S^.Fired := TRUE
         end
end;

Procedure MoveSpear(var S, Dead : Item);
  {* Move magic spear during flight (with droning sound), if activated}
var  Spot : byte;

  Procedure DrawSpear(var x, y : integer; var XOff, YOff : shortint);
    {* Draws magic spear on screen at (x,y), in direction (XOff,YOff)}
  begin
    if (LData.View in [TopDark, SideDark]) and
       ((x < P.x - 3) or (x > P.x + 3) or (y < P.y - 2) or (y > P.y + 2))
    then {}
    else case XOff of
      -1 : case YOff of
             -1 : SC(x,y,'\',Random(15) + 1);
              0 : SC(x,y,'ƒ',Random(15) + 1);
              1 : SC(x,y,'/',Random(15) + 1)
           end;
       0 : SC(x,y,'≥',Random(15) + 1);
       1 : case YOff of
             -1 : SC(x,y,'/',Random(15) + 1);
              0 : SC(x,y,'ƒ',Random(15) + 1);
              1 : SC(x,y,'\',Random(15) + 1)
           end;
    end;  {case}
  end;  {DrawSpear}

begin  {MoveSpear}
 if S^.Fired then
  with S^ do
    begin
      Level[x,y] := OnItem; {update spot; go to next in spear's path}
      DrawPos(x,y);
      Inc(x,XOff);
      Inc(y,YOff);
      if (x < 1) or (x > 64) or (y < 1) or (y > 24)  {off screen}
        then begin
               Fired := FALSE;
               Dead := S;
               EXIT
             end;
      if (x = P.x) and (y = P.y)  {spear hits player}
        then begin
               Fired := FALSE;
               Dead := S;
               Dec(P.Health,Dmg);
               UpdateStats;
               if P.Health < 0 then P.OnItem := MagicSpear; {for Fate}
               Crumble2;
               EXIT
             end;

      Spot := Level[x,y];
      if (Spot in [BW1..DownSW,LetterWall,Tree..Rock,Forest..ForceField,
        PushBlock..Boulder,MW1..FB3])
      then begin
             Fired := FALSE;   {spear stops}
             Dead := S;
             Thump;
             EXIT
           end
      else if (Spot in EatItems + [NoMove1,StoneDoor]) {spear destroys}
        then begin
               if (Spot in FlashItems+MorphItems)
                 then begin
                        Dec(x,XOff);  Dec(y,YOff);
                        ZapItem(x + XOff,y + YOff);
                        Inc(x,XOff);  Inc(y,YOff)
                      end
                 else Level[x,y] := BLANK;
               DrawSpear(x,y,XOff,YOff);
               PSound(300,10)
             end
        else if (Spot in [M1a..W3b])
          then begin                 {monsters killed (not ghosts)}
                 ZapMonster(x,y);
                 DrawSpear(x,y,XOff,YOff);
                 PSound(300,10)
               end
          else if (Spot = MagicSpear)
                 then begin
                        Dec(x,XOff);  Dec(y,YOff);
                        FireMagicSpear(x + XOff,y + YOff);
                        Inc(x,XOff);  Inc(y,YOff);
                      end
                 else DrawSpear(x,y,XOff,YOff);    {spear flies over}
      OnItem := Level[x,y];
      if Erratic          {change direction}
        then repeat
               XOff := Random(3);
               YOff := Random(3);
               Dec(XOff);  {type kludging}
               Dec(YOff);
             until (XOff <> 0) or (YOff <> 0);
{      PSound(Snd,0);}
      if Snd >= 38 then Dec(Snd,1)
        else NoSound
    end  {with S^}
    else begin          {spear is inactive}
           if (LData.View in [TopDark, SideDark]) and
             ((x < P.x - 3) or (x > P.x + 3) or (y < P.y - 2) or (y > P.y + 2))
           then EXIT;
           DrawPos(S^.x,S^.y);
           SCol(S^.x,S^.y,(Random(2) * 8) + 7)
         end
end;

Procedure MoveFireball(var F, Dead : Item);
  {* Move fireball during flight (without sound)}
var  Spot : byte;

  Procedure DrawFireball(var x, y : integer);
    {* Draws fireball on screen at (x,y)}
  begin
    if (LData.View in [TopDark, SideDark]) and
       ((x < P.x - 3) or (x > P.x + 3) or (y < P.y - 2) or (y > P.y + 2))
      then EXIT;
    if (Moves mod 4) = 0   {animate}
      then SC(x,y,#18,Random(15) + 1)
      else SC(x,y,#19,Random(15) + 1);
  end;  {DrawFireball}

begin  {MoveFireball}
  with F^ do
    begin
      DrawPos(x,y);
      Inc(x,XOff);
      Inc(y,YOff);
      if (x < 1) or (x > 64) or (y < 1) or (y > 24)  {off screen}
        then begin
               Fired := FALSE;
               Dead := F;
               EXIT
             end;
      if (x = P.x) and (y = P.y)  {fireball hits player}
        then begin
               Fired := FALSE;
               Dead := F;
               Dec(P.Health,Dmg);
               UpdateStats;
               if P.Health < 0 then P.OnItem := Fireball; {for Fate}
               Crumble2;
               EXIT
             end;

      if (Level[x,y] in [M1a..T3])
          then begin               {monsters killed (not ghosts/wizards)}
                 ZapMonster(x,y);
                 Fired := FALSE;   {fireball stops}
                 Dead := F;
                 DrawFireball(x,y);
                 Click1;
                 SC(x,y,' ',Black)
               end
          else begin
                 DrawFireball(x,y);
                 if Erratic          {change direction}
                   then repeat
                          XOff := Random(3) - 1;
                          YOff := Random(3) - 1
                        until (XOff <> 0) or (YOff <> 0)
               end;
    end  {with F^}
end;

Procedure MoveItems;
  {* Performs special effects for certain items}
var  DeadItem,     {holds any item records to be removed from list}
     Trav : Item;  {traverses entire item list}
     i : byte;
begin
  DeadItem := nil;            {no items to remove yet}
  Trav := HeadItem^.next;     {start past first (unused) node in list}
  while Trav <> nil do        {go through list}
    with Trav^ do
    begin
      case IT of        {move item according to behavior type}
        Morphing      : begin
                          if (Moves mod FrameSpeed) = 0
                            then begin    {show next animation frame}
                                   Inc(CurFrame);
                                   if CurFrame >= FrameNo
                                     then CurFrame := 0
                                 end;
                          DrawItem(x,y,Species,CurFrame)
                        end;
        Flashing      : DrawItem(x,y,Species,Energy);
        Missile       : if (Moves mod Speed) = 0 then
                          case Species of
                            MagicSpear : MoveSpear(Trav,DeadItem);
                            Fireball   : MoveFireball(Trav,DeadItem);
                          end;
        Switching     : begin
                          i := Ord(On);
                          DrawItem(x,y,Species,i)
                        end;
      end; {case Trav^.MT}

      Trav := Trav^.next;      {go to next item in list}
      if DeadItem <> nil    {remove dead item}
        then begin
               NoSound;
               DeadItem^.prev^.next := DeadItem^.next;
               if DeadItem^.next <> nil
                 then DeadItem^.next^.prev := DeadItem^.prev;
               Dispose(DeadItem);
               DeadItem := nil
             end
    end {while Trav <> nil do with Trav^}
end;

Procedure TurnOn(x, y : integer; var Res : boolean);
  {* Turn on/off item at (x,y)}
var  Trav : Item;

begin
  Trav := HeadItem^.next;
  while (Trav^.x <> x) or (Trav^.y <> y) do
    Trav := Trav^.next;
  Trav^.On := not Trav^.On;
  Res := Trav^.On
end;

end.  {Unit VntrMstr}
