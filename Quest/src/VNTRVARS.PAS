Unit VntrVars;    {"The 'Merican Adventure" constants/types/variables}
                  {created by Michael Rimer - begun 6 APR 94}

(***)  Interface  (***)

Uses Crt;

const
  NumOfMessages = 75;  {number of item messages - highest item number}
  NumOfLevels = 25;  {maximum number of levels}
  Version = 1.00;  {version number of game}

{Level Types}
  Top      = 0;
  TopDark  = 1;
  Side     = 2;
  SideDark = 3;

{Skill Types}
  NOVICE   = 0;
  ADVANCED = 1;
  EXPERT   = 2;

{Computer Speeds}
  VerySlowGameSpeed = 10;
  SlowGameSpeed = 50;
  MedmGameSpeed = 100;
  FastGameSpeed = 150;
  VeryFastGameSpeed = 500;

{Special keys}
  Space = 0;
  Quit  = 99;

{Player Fate}
  DIES = 0;
 {QUIT = 99}
  WINS = 2;

{Search methods}
  DOWN  = 0;
  UP    = 1;
  FALL  = 2;
  PTo   = 3;
  PFrom = 4;

  TEST = -1;
  MUse  = 1;   SUse = 2;  {special item usage}

  Hiding = 0;
  Stands = 1;
  Fired  = 2;

{------------------}

{All Items in game}

  Blank       = 0;
  BW1         = 1;    {broken walls}
  BW2         = 2;
  BW3         = 3;
  SolidW      = 4;    {solid walls}
  LeftSW      = 5;
  RightSW     = 6;
  UpSW        = 7; {<--BELL, don't use next game}
  DownSW      = 8; {backspace - don't use}
  InvSolidW   = 9;    {invisible walls}
               {10}
  InvBW1      = 11;
  InvWTrap    = 12;
               {13}
               {14}
  NoMove1     = 15;   {special Blank spots}
  NoMove2     = 16;
  NoMove3     = 17;
  NoMove4     = 18;
  Dirt        = 19;   {background}

  Tree        = 20;   {obstacles}
  Rock        = 21;
  Lava        = 22;
  Pit         = 23;
  Water       = 24;
  DeepWater   = 25;
  Ice         = 26;
  DeepIce     = 27;
  Forest      = 28;
  DenseForest = 29;
  ForceField  = 30;
  HotSpot     = 31;
  PushBlock   = 32;
  Boulder     = 33;
  StickySpot  = 34;
  Raft        = 35;

  HealthGem   = 40;   {items}
  InvHGem     = 41;
  PowerGem    = 42;
  InvPGem     = 43;
  GemPouch    = 44;
  MScroll     = 45;
  GoldNugget  = 46;
  StoneKey    = 47;
  BronzeKey   = 48;
  MagicKey    = 49;
  TeleTrap    = 50;
  WarpTrap    = 51;
  Freeze      = 52;
  Slow        = 53;
  Haste       = 54;
  InvPotion1  = 55;
  InvPotion2  = 56;

  StoneDoor   = 60;   {doors}
  BronzeDoor  = 61;
  MagicDoor   = 62;
  InvSDoor    = 63;
  InvBDoor    = 64;

  Rope        = 70;   {sideways items}
  GreasedRope = 71;
  AntiGravity = 72;
  RopeExtend  = 73;

  UnearthGems = 80;   {gem modifiers}
  BuryGems    = 81;
  RevealGems  = 82;
  HideGems    = 83;
  PowerUp     = 84;

  UpStairs    = 100;  {stairs}
  DownStairs  = 101;
  Chute       = 102;
  PortalTo    = 103;
  PortalFrom  = 104;
  Tunnel      = 105;
  InvTunnel   = 106;

  KStatue     = 110;  {monster items}
  MonsterZap  = 111;  {zaps ~50 monsters}
  MonsterMake = 112;  {summons ~50 monsters}
  MonZap      = 113;  {zaps monsters who move next to}
  MonGen      = 114;  {makes monsters next to}
  RMonZap     = 115;  {zaps monsters in random spots}
  RMonGen     = 116;  {makes monsters in random spots}

  MagicSpear  = 120;  {special item}
  Surround    = 121;
  MagicBomb   = 122;
  Lantern     = 123;
  TChest      = 124;
  LTChest     = 125;

  Special1    = 140;  {level specials}
  Special2    = 141;
  Special3    = 142;
  Special4    = 143;
  Special5    = 144;
  Special6    = 145;
  Special7    = 146;
  Special8    = 147;
  Special9    = 148;
  LetterWall  = 149;  {wall letters}


  M1a         = 200;  {monsters}
  M2a         = 201;
  M3a         = 202;
  M1b         = 203;
  M2b         = 204;
  M3b         = 205;
  M1c         = 206;
  M2c         = 207;
  M3c         = 208;

  SM1a        = 210;  {smart monsters}
  SM2a        = 211;
  SM3a        = 212;
  SM1b        = 213;
  SM2b        = 214;
  SM3b        = 215;
  SM1c        = 216;
  SM2c        = 217;
  SM3c        = 218;

  T1          = 220;  {thief}
  T2          = 221;
  T3          = 222;
  W1a         = 223;  {wizard}
  W2a         = 224;
  W3a         = 225;
  W1b         = 226;
  W2b         = 227;
  W3b         = 228;
  G1          = 229;  {ghost}
  G2          = 230;
  G3          = 231;

  MW1         = 240;  {moving wall}
  MW2         = 241;
  MW3         = 242;
  DF1         = 243;  {dropping floor}
  DF2         = 244;
  DF3         = 245;
  FB1         = 246;  {falling block}
  FB2         = 247;
  FB3         = 248;

  Fireball    = 250;  {Wizard's projectile}

  {----------------}

  Stationary = 0;      {falling block}
  Falling = 1;

  StepItems  = [BLANK,Dirt,Ice,DeepIce];
              {items monsters can step onto}
  EatItems   = [HealthGem..BronzeKey,TeleTrap,Freeze..InvPotion2];
              {items monsters can eat}
  MorphItems = [Tree,Freeze..InvPotion2,PowerUp,PortalTo,PortalFrom,
                AntiGravity];
              {animated chars}
  FlashItems = [HealthGem,PowerGem,GemPouch,MScroll,GoldNugget];
              {items that change color}
  StandItems = [BW1..DownSW,MW1..FB3,Tree..Rock,Ice..DenseForest,PushBlock,
                Boulder,StoneDoor..MagicDoor,KStatue,MonGen,RMonGen,Lantern,
                LTChest,LetterWall];
              {objects player can stand on in SideView levels}
  MonsterStand = [DownSW..NoMove4,ForceField,RopeExtend,
                  UpStairs..InvTunnel,M1a..FB3,Special1..Special9];
              {objects monsters can stand on in SideView levels}
  InvStandItems = [InvSolidW..InvBW1,InvSDoor..InvBDoor];
              {objects player can stand on, if visible}

  MusicName : array[0..19] of string[15] = ('none',
    'Black Hole','Chinatown','Danger Lurks','Desert','Gothic Night','Guitar',
    'Indian','Jungle','Mystic','Escape!','The Orient','Quest','Showdown',
    'Splendour','Strange','Voidness','What?','What''s That?','The Zone');
  MusicFile : array[0..19] of string[8] = ('',
    'blackhol','chinatwn','danger','desert','gothic','guitar','indian',
    'jungle','mystic','escape','orient','quest','showdown','splendor',
    'strange','void','what','whatstha','zone');
  ScoreNames : array[0..15] of String[20] = ('',
    'The Merican Master','Belgarion','Bilbo Baggins','Indy Jones',
    'A. Pendragon','Matthias','Gandalf','Launcelot','Conan','Shamino',
    'Rogue','Arnie S.','Peter Pan','J. L. Picard','Mr. Rogers');

(*************************************************)

type
  LStatRec     = record
                   Name : string[30];  {level title}
                   Music,              {level intro tune}
                   Tx, Ty,             {destination of TeleTrap2}
                   WC, DC,             {color of walls/dirt}
                   View : byte;        {level format}
                   XFlip, YFlip : boolean;  {level symmetry}
                 end;
  LevelMatrix  = array[1..64,1..24] of byte;  {level storage type}
  CustomFile   = File of Byte;
  LevelRec     = record
                   LStat  : LStatRec;     {level data}
                   Level  : LevelMatrix;  {map data}
                   Custom : LevelMatrix;  {custom object data}
                 end;
  PlayerRec    = record      {holds player's attributes}
                   Score : longint;
                   Health, Sword, Magic,
                   Color,
                   ox, oy, x, y : integer;
                   OnItem,
                   Oxygen,
                   SwordPower,
                   SKeys, BKeys, MKeys : byte;
                   Chr : char;
                 end;

  MonsterType  = (Standard,Smart,Ghost,Wizard,Thief);
  Monster      = ^MonsterRec;
  MonsterRec   = record
                   Ox, Oy, x, y,  {old, current position}
                   Speed, Hits,   {turns per move / Hit Points}
                   Damage     : integer;
                   OnItem,        {object monster is standing on}
                   Species    : byte;
                   Next, Prev : Monster;
                   case MT : MonsterType of
                     Standard      : ({no extra fields});
                     Smart         : ({no extra fields});
                     Ghost         : (Visible : boolean);
                     Wizard        : (MoveRound : byte;
                                      WaitTime  : byte);
                     Thief         : (Carrying : byte);
                   end; {case MT/MonsterRec}

  MvgObjType  = (MovingWall,DroppingFloor,FallingBlock);
  MvgObj      = ^MvgObjRec;
  MvgObjRec   = record
                   Ox, Oy, x, y,  {old, current position}
                   Speed,         {turns per move}
                   Damage     : integer;
                   HitChance,     {% chance to break with sword}
                   OnItem,        {object MvgObj moves onto}
                   Species    : byte;
                   Next, Prev : MvgObj;
                   case MT : MvgObjType of
                     MovingWall    : ({no extra fields});  {HP : byte}
                     DroppingFloor : (Stable     : boolean;
                                      WaitToFall : byte);
                     FallingBlock  : (Falling : boolean;
                                      Hits, Proximity : byte);
                   end; {case MT/MvgObjRec}

  ItemType = (Switching,Morphing,Flashing,Missile);
  Item     = ^ItemRec;
  ItemRec  = record
               x, y : integer;  {current position}
               Species : byte;
               Next, Prev : Item;
               case IT : ItemType of
                 Morphing  : (CurFrame, FrameNo, FrameSpeed : byte);
                 Switching : (On : boolean);
                 Flashing  : (Energy : byte);
                 Missile   : (Fired, Erratic : boolean;
                              XOff, YOff, Speed : shortint;
                              Dmg, Snd, OnItem : byte);
               end; {case IT/ItemRec}

  String32    = string[32];
  String64    = string[64];
  SpecItemPtr = ^SpecItemRec;
  SpecItemRec = record
                  Data : String64;
                  Next : SpecItemPtr
                end;
  SpecRec   = record
                IType, MoveOn : byte;
                Chr    : char;
                Color  : byte;
                Item   : SpecItemPtr
              end;

  MessageArray = array[0..NumOfMessages] of boolean;
  ExitArray    = array[0..NumOfLevels] of boolean;

  FameRec = record
              Name  : string[20];
              Score : longint;
              Level : byte;
              Fate  : string[10]
            end;

(*************************************************)

var
  CurMon,                   {for searching through monster list}
  HeadMonster : Monster;
  CurMObj,                  {" moving object list}
  HeadMvgObj  : MvgObj;
  CurItem,                  {" item list}
  HeadItem    : Item;
  TempSpec,
  Specials    : array[1..9] of SpecRec;  {definition of special items}
  SpecialF    : text;
  LStat       : LStatRec;

  Messages    : MessageArray;
  Exited      : ExitArray;
  Temp,
  LevelInfo   : LevelRec;
  Custom,                    {customized item data}
  Level       : LevelMatrix; {level data}
  LData       : LStatRec;
  P           : PlayerRec;

  ScoreF   : file of FameRec;  {high score file}
  LevelF   : file of LevelRec; {holds data for all levels during game play}
  DataFile,             {name of level data file(s)}
  NumStr   : string[9]; {for turning numbers into strings}
  HGColor, PGColor,
  LevelNum : byte;
  g,                    {direction of fall in sideways levels}
  BlankTime, InvisTime, FreezeTime, SlowTime, HasteTime,
  SkillLevel,
  IncScore,
  TurnDelay,            {waiting period per turn}
  GoKey,                {holds move to execute}
  Moves,                {turn counter}
  Num, Cnt,
  x, y, z,              {looping/counter variables}
  i, j, k  : integer;
  HideMonsters,         {monsters invisible/visible}
  MASTER,               {MER's debug}
  PlayTest,             {to try one level from editor}
  BigSecret,            {for best game ending}
  FlipX, FlipY,         {when TRUE, levels are reflected horiz/vert}
  ExitGame,             {when TRUE, current game ends}
  ExitProg,             {when TRUE, program exits}
  FuncKey  : boolean;   {extended key check}
  Ch       : char;

(***)  Implementation  (***)

end.  {Unit VntrVars}
