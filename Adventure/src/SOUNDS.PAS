Unit Sounds;                          {written by Michael Rimer }
                                      {last modified 01 MAY 94  }

{My Sound library for various programs - 86 sounds in all!}

(*********************)
(***)  Interface  (***)
(*********************)

Uses Crt;

var Snd, Snd1, Snd2, Snd3, Snd4 : word;
    i1, i2, i3, i4 : byte;
    Noise : boolean;          {if FALSE, sounds do not play}

Procedure PSound(Tone, Dur : word);
Procedure LowBeep;     {newer sounds - 12th grade}
Procedure MidBeep1;
Procedure HighBeep2;
Procedure WrongKey;
Procedure FootFalls;
Procedure FootFalls2;
Procedure Thump;
Procedure Thump2;
Procedure HitWall;
Procedure HitWall2;
Procedure Whoop;
Procedure Whoop2;
Procedure DownWhoop;
Procedure Squish1;
Procedure Squish2;
Procedure Squish3;
Procedure Click1;
Procedure Click2;
Procedure Click3;
Procedure UpStairs1;
Procedure DownStairs1;
Procedure Prize;
Procedure Prize2;
Procedure SlowDown;
Procedure Monster;
Procedure CrumbleWall;
Procedure Crumble2;
Procedure BusySignal;
Procedure Siren1;
Procedure Siren2;
Procedure Laser;
Procedure HandsOnDeck;
Procedure Attention;
Procedure Electric1;
Procedure Electric2;
Procedure Static;
Procedure Wave;
Procedure Explosion;

Procedure ErrorBeep;   {first sounds - 11th grade}
Procedure MidBeep2;
Procedure MediumBeep;      {Wahoo! I finally found them!}
Procedure HighBeep1;         {Thanks Erik and Tom!}
Procedure Buzz;
Procedure NullItem;
Procedure WarmUp;
Procedure UpSteps;
Procedure DownSteps;
Procedure Fry;
Procedure Zap;
Procedure UseKey;
Procedure OpenDoor;
Procedure LockedDoor;
Procedure Splatter;
Procedure WaterSpot;
Procedure WaterSpot2;
Procedure BombBlast;
Procedure SpellCast;
Procedure Squeak;
Procedure Slide;
Procedure Whistle;
Procedure Whistle2;
Procedure Click4;
Procedure Ascending;
Procedure Descending;
Procedure Stuck;
Procedure Eerie;
Procedure Echo;
Procedure Crumble1;
Procedure Drain;
Procedure Crystal1;
Procedure Crystal2;
Procedure Crystal3;
Procedure MonsterYell;
Procedure WormScream;
Procedure PhaseShift;
Procedure PowerUp;
Procedure Strange;
Procedure Sparkle;
Procedure Speech;
Procedure Sprinkle;
Procedure SlowingWheel;
Procedure WaveBeam;
Procedure Motor;
Procedure Humm;
Procedure Arrive;
Procedure Depart;

(**************************)
(***)  Implementation  (***)
(**************************)

Procedure PSound(Tone, Dur : word);
begin
  if Noise
    then Sound(Tone);
  Delay(Dur)
end;

Procedure LowBeep;
begin
  PSound(100,25);
  NoSound
end;

Procedure MidBeep1;
begin
  PSound(350,25);
  NoSound
end;

Procedure HighBeep2;
begin
  PSound(2000,40);
  NoSound
end;

Procedure WrongKey;
begin
  for Snd1 := 1 to 5 do
    begin
      PSound(500,5);
      PSound(300,5);
      PSound(100,5)
    end;
  NoSound
end;

Procedure FootFalls;
begin
  PSound(220,4);
  NoSound;
  Delay(20);
  PSound(100,2);
  NoSound
end;

Procedure FootFalls2;
begin
  PSound(250,10);
  NoSound;
  Delay(60);
  PSound(50,10);
  NoSound
end;

Procedure Thump;
begin
  for Snd1 := 120 downto 50 do
    PSound(Snd1,2);
  NoSound
end;

Procedure Thump2;
begin
  for Snd1 := 150 downto 37 do
    PSound(Snd1,1);
  NoSound
end;

Procedure HitWall;
begin
  for Snd1 := 200 downto 35 do
    PSound(Snd1,2);
  NoSound
end;

Procedure HitWall2;
begin
  for Snd1 := 170 downto 37 do
    PSound(Snd1,2);
  NoSound
end;

Procedure Whoop;
begin
  for Snd1 := 30 to 500 do
    PSound(Snd1,1);
  NoSound
end;

Procedure Whoop2;
begin;
  for Snd1 := 100 to 600 do
    PSound(Snd1,1);
  NoSound
end;

Procedure DownWhoop;
begin
  for Snd1 := 500 downto 30 do
    PSound(Snd1,1);
  NoSound
end;

Procedure Squish1;
begin
  for Snd1 := 1 to 100 do
    PSound(Random(2000) + 50,2);
  NoSound
end;

Procedure Squish2;
begin
  for Snd1 := 1 to 12 do
    begin
      PSound(Random(800) + 450,5);
      PSound(Random(400) + 50,5)
    end;
  NoSound
end;

Procedure Squish3;
begin
  for Snd1 := 1 to 30 do
    PSound(Random(300) + 400,4);
  NoSound
end;

Procedure Click1;
begin
  for Snd1 := 1 to 12 do
    begin
      PSound(Random(2000 + 200 * Snd1),1);
      NoSound
    end
end;

Procedure Click2;
begin
  PSound(1000,5);
  NoSound
end;

Procedure Click3;
begin
  PSound(2000,5);
  NoSound
end;

Procedure UpStairs1;
begin
  for Snd1 := 0 to 5 do
    begin
      for Snd2 := 1 to 12 do
        begin
          PSound(Random(1500 + 320 * Snd1),1);
          NoSound
        end;
      Delay(220)
    end;
end;

Procedure DownStairs1;
begin
  for Snd1 := 5 downto 0 do
    begin
      for Snd2 := 1 to 12 do
        begin
          PSound(Random(1500 + 320 * Snd1),1);
          NoSound
        end;
      Delay(220)
    end;
end;

Procedure Prize;
begin
  Snd1 := 250;
  while Snd1 < 550 do
    begin
      PSound(Snd1,3);
      NoSound;
      Inc(Snd1,4)
    end;
  while Snd1 > 250 do
    begin
      PSound(Snd1,3);
      NoSound;
      Dec(Snd1,5)
    end;
  while Snd1 < 800 do
    begin
      PSound(Snd1,3);
      NoSound;
      Inc(Snd1,4)
    end;
end;

Procedure Prize2;
begin
  Snd1 := 200;
  repeat
    PSound(Snd1,3);
    NoSound;
    Inc(Snd1,3)
  until Snd1 > 450;
  repeat
    PSound(Snd1,3);
    NoSound;
    Dec(Snd1,4)
  until Snd1 < 200;
  repeat
    PSound(Snd1,3);
    NoSound;
    Inc(Snd1,3)
  until Snd1 > 700
end;

Procedure SlowDown;
begin
  for Snd1 := 500 downto 35 do
    begin
      PSound(Snd1,1);
      PSound(Snd1 + Random(500),1)
    end;
  NoSound
end;

Procedure Monster;
begin
  for Snd1 := 500 downto 35 do
    PSound(Snd1 + Random(500),1);
  NoSound
end;

Procedure CrumbleWall;
begin
  for Snd1 := 200 downto 1 do
    PSound(Snd1 + Random(350),2);
  NoSound
end;

Procedure Crumble2;
begin
  for Snd1 := 600 downto 35 do
    PSound(Snd1 + Random(350),1);
  NoSound
end;

Procedure BusySignal;
begin
  PSound(100,500);
  NoSound;
  Delay(500)
end;

Procedure Siren1;
begin
  for Snd1 := 400 to 650 do
    PSound(Snd1 * 2, 5);
  NoSound;
  Delay(100)
end;

Procedure Laser;
begin
  for Snd1 := 400 to 650 do
    PSound(2000-Snd1 * 2, 2);
  NoSound;
  Delay(100)
end;

Procedure Siren2;
begin
  PSound(700,250);
  for Snd1 := 700 downto 500 do
    PSound(Snd1,1);
  PSound(500,250);
  NoSound;
  Delay(100)
end;

Procedure HandsOnDeck;
begin
   PSound(900,375);
   Snd1 := 900;
   While Snd1 < 1300 do
      begin
         PSound(Snd1,1);
         Inc(Snd1,5)
      end;
   PSound(1300,750);
   While Snd1 > 900 do
      begin
         PSound(Snd1,1);
         Dec(Snd1,5)
      end;
   PSound(900,350);
   Nosound
end;

Procedure Attention;
begin
  PSound(600,100);
  PSound(400,100);
  PSound(200,100);
  NoSound
end;

Procedure Electric1;
begin
  for Snd1 := 1 to 25 do
    begin
      PSound(Random (100) + 1,25);
      NoSound;
      Delay(25)
    end
end;

Procedure Electric2;
begin
  for Snd1 := 1 to 50 do
    begin
      PSound(Random (100) + 1,25);
      NoSound;
      Delay(10)
    end
end;

Procedure Static;
begin
  for Snd1 := 2500 downto 1 do
    begin
      PSound(Snd1 + Random(350),0);
      NoSound
    end
end;

Procedure Wave;
begin
   Snd1 := 0;
   While Snd1 < 90 do
      begin
         PSound(Round(Cos(Snd1 * Pi / 180) * 400),1);
         Inc(Snd1,5)
      end;
   While Snd1 > 0 do
      begin
         PSound(Round(Cos(Snd1 * Pi / 180) * 400),1);
         Dec(Snd1,5)
      end;
   NoSound
end;

Procedure Explosion;
begin
   PSound(Random(200) + 25, 25);
   NoSound;
   Delay(1)
end;

{------------------------------------------------------------------------}

Procedure ErrorBeep;
begin
  for Snd := 400 downto 370 do
    PSound(Snd,1);
  NoSound
end;

Procedure MidBeep2;
begin
  PSound(350,50);
  NoSound
end;

Procedure MediumBeep;
begin
  PSound(800,110);
  NoSound
end;

Procedure HighBeep1;
begin
  PSound(2000,20);
  NoSound
end;

Procedure Buzz;
begin
  for Snd := 1 to 6 do
    PSound(300,1);
  NoSound
end;

Procedure NullItem;
begin
  PSound(37,110);
  PSound(300,110);
  PSound(37,110);
  NoSound
end;

Procedure WarmUp;
begin
  Snd := 37;
  repeat
    PSound(Snd,9);
    Inc(Snd,2);
  until Snd > 380;
  NoSound
end;

Procedure UpSteps;
begin
  Snd3 := 650;
  Snd2 := 1350;
  for Snd1 := 1 to 6 do
    begin
      Inc(Snd3,150);
      Inc(Snd2,150);
      for Snd4 := 1 to 10 do
        begin
          PSound(Snd3 + Random(200),1);
          PSound(Snd2 + Random(200),1)
        end;
      NoSound;
      Delay(250)
    end
end;

Procedure DownSteps;
begin
  Snd3 := 1550;
  Snd2 := 2250;
  for Snd1 := 1 to 6 do
    begin
      Dec(Snd3,150);
      Dec(Snd2,150);
      for Snd4 := 1 to 10 do
        begin
          PSound(Snd3 + Random(200),1);
          PSound(Snd2 + Random(200),1)
        end;
      NoSound;
      Delay(250)
    end
end;

Procedure Fry;
begin
  for Snd := 1 to 500 do
    begin
      PSound(Random(1000),1);
      NoSound
    end
end;

Procedure Zap;
begin
  if (not Noise) then Exit;
  for Snd := 1 to 3200 do
    begin
      Sound(1000);
      Sound(100);
      Sound(800);
      Sound(300);
      Sound(600);
      Sound(500)
    end;
  NoSound
end;

Procedure UseKey;
var val : integer;
begin
  for Snd := 1 to 100 do
    begin
      val := 250-(integer(Snd) * 5);
      if (val > 0)
        then PSound(val,4)
        else Delay(4);
      NoSound;
      Delay(1)
    end
end;

Procedure OpenDoor;
begin
  for Snd1 := 0 to 5 do
    for Snd3 := 0 to 8 do
      begin
        Snd4 := (Snd3 * 10) + (Snd1 * 80);
        Snd2 := Snd4;
        while Snd2 < 120 + Snd4 do
          begin
            PSound(Snd2,1);
            Inc(Snd2,10)
          end;
      end;
  NoSound
end;

Procedure LockedDoor;
begin
  for Snd := 1 to 50 do
    PSound(Random(180) + 37,10);
  NoSound
end;

Procedure Splatter;
begin
  for Snd := 1 to 200 do
    PSound(Random(1800),2);
  NoSound
end;

Procedure WaterSpot;
begin
  if (not Noise) then Exit;
  Snd4 := 70;
  for Snd1 := 1 to 300 do
    begin
      for Snd2 := 1 to 20 do
        begin
          Sound(Snd4);
          Dec(Snd4,45)
        end;
      Inc(Snd4,907)
    end;
  NoSound
end;

Procedure WaterSpot2;
begin
  if (not Noise) then Exit;
  Snd4 := 70;
  for Snd := 1 to 600 do
    begin
      for Snd2 := 1 to 20 do
        begin
          Sound(Snd4);
          Dec(Snd4,45)
        end;
      Inc(Snd4,907)
    end;
  NoSound
end;

Procedure BombBlast;
begin
  Snd4 := 3000;
  for Snd1 := 1 to 139 do
    begin
      PSound(Snd4,3);
      Dec(Snd4,25)
    end;
  Sound(40)
end;

Procedure SpellCast;
begin
  Snd4 := 1000;
  for Snd1 := 1 to 150 do
    begin
      PSound(10000,1);
      PSound(Snd4,3);
      PSound(5000,1);
      Inc(Snd4,25)
    end;
  Sound(2300)
end;

Procedure Squeak;
begin
  if (not Noise) then Exit;
  for Snd2 := 1000 downto 40
    do Sound(Snd2);
  NoSound
end;

Procedure Slide;
begin
  for Snd := 1000 downto 40 do
    PSound(Snd,1);
  NoSound
end;

Procedure Whistle;
begin
  for Snd := 3000 downto 40 do
    if (Snd mod 18) = 0
      then PSound(Snd,1);
  NoSound
end;

Procedure Whistle2;
begin
  if (not Noise) then Exit;
  Snd2 := 1000;
  for Snd4 := 1 to 1600 do
    begin
      for Snd1 := 1 to 20 do
        begin
          Sound(Snd2);
          Dec(Snd2,45)
        end;
      Inc(Snd2,907)
    end;
  NoSound
end;

Procedure Click4;
begin
  for Snd := 1 to 10 do
    begin
      PSound(800 + Random(200),1);
      PSound(1500 + Random(200),1)
    end;
  NoSound
end;

Procedure Ascending;
begin
  Snd1 := 950;
  Snd2 := 5;
  Snd4 := 6;
  for Snd3 := 1 to 4 do
  begin
    repeat
      PSound(Snd1,Snd2);
      Inc(Snd1,Snd4);
      NoSound
    until Snd1 > 1350;
    Snd1 := 950;
    Dec(Snd2);
    Dec(Snd4)
  end;
end;

Procedure Descending;
begin
  Snd1 := 1350;
  Snd2 := 2;
  Snd4 := 3;
  for Snd3 := 1 to 4 do
  begin
    repeat
      PSound(Snd1,Snd2);
      Dec(Snd1,Snd4);
      NoSound
    until Snd1 < 950;
    Snd1 := 1350;
    Inc(Snd2);
    Inc(Snd4)
  end;
end;

Procedure Stuck;
begin
  if (not Noise) then Exit;
  Snd4 := 100;
  for Snd2 := 1 to 200 do
    begin
      for Snd1 := 1 to 20 do
        begin
          Sound(Snd4);
          Dec(Snd4,45)
        end;
      Inc(Snd4,907)
    end;
  NoSound
end;

Procedure Eerie;
begin
  if (not Noise) then Exit;
  Snd2 := 1050;
  for Snd4 := 1 to 380 do
  begin
    for Snd1 := 1 to 600 do
    begin
      Sound(Snd2);
      Inc(Snd2);
    end;
  Dec(Snd2,604);
  end;
  NoSound
end;

Procedure Echo;
begin
  if (not Noise) then Exit;
  Snd2 := 550;
  for Snd4 := 1 to 530 do
  begin
    for Snd := 1 to 400 do
    begin
      Sound(Snd2);
      Dec(Snd2,2);
    end;
  Inc(Snd2,799);
  end;
  NoSound
end;

Procedure Crumble1;
begin
  if (not Noise) then Exit;
  Snd2 := 500;
  for Snd4 := 1 to 510 do
  begin
    for Snd := 1 to 34 do
    begin
      Sound(Snd2);
      Dec(Snd2,14);
    end;
  Inc(Snd2,475);
  end;
  NoSound
end;

Procedure Drain;
begin
  for Snd := 1 to 1000 do
    PSound(Random(15000),2);
  NoSound
end;

Procedure Crystal1;
begin
  if (not Noise) then Exit;
  Snd2 := 37;
  for Snd1 := 1 to 900 do
    begin
      for Snd4 := 1 to 20 do
        begin
          Sound(Snd2);
          Inc(Snd2);
        end;
      Dec(Snd2,10);
      NoSound
    end;
end;

Procedure Crystal2;
begin
  if (not Noise) then Exit;
  Snd2 := 37;
  for Snd1 := 1 to 900 do
    begin
      for Snd4 := 1 to 40 do
        begin
          Sound(Snd2);
          Inc(Snd2);
        end;
      Dec(Snd2,15);
      NoSound
    end;
end;

Procedure Crystal3;
begin
  if (not Noise) then Exit;
  Snd2 := 37;
  for Snd1 := 1 to 900 do
    begin
      for Snd4 := 1 to 60 do
        begin
          Sound(Snd2);
          Inc(Snd2);
        end;
      Dec(Snd2,30);
      NoSound
    end;
end;

Procedure MonsterYell;
begin
  if (not Noise) then Exit;
  Snd2 := 1000;
  for Snd4 := 1 to 1300 do
    begin
      for Snd1 := 1 to 20 do
        begin
          Dec(Snd2,45);
          Sound(800);
          Sound(Snd2);
        end;
      Inc(Snd2,907);
    end;
  NoSound;
end;

Procedure WormScream;
begin
  if (not Noise) then Exit;
  Snd2 := 1000;
  for Snd4 := 1 to 1000 do
    begin
      Sound(5000);
      Delay(1);
      for Snd1 := 1 to 20 do
        begin
          Sound(Snd2);
          Dec(Snd2,45);
        end;
      Inc(Snd2,907);
    end;
  NoSound;
end;

Procedure PhaseShift;
begin
  if (not Noise) then Exit;
  Snd2 := 1000;
  for Snd4 := 1 to 2000 do
    begin
      for Snd1 := 1 to 20 do
        begin
          Sound(Snd2);
          Dec(Snd2,45);
        end;
      Inc(Snd2,907);
      Delay(1);
      NoSound;
    end;
  NoSound;
end;

Procedure PowerUp;
begin
  Snd2 := 37;
  for Snd4 := 1 to 50 do
    begin
      PSound(Snd2,1);
      for Snd1 := 1 to 22 do
        begin
          Inc(Snd2,23);
          PSound(Snd2,3)
        end;
      Dec(Snd2,400);
      NoSound
    end;
end;

Procedure Strange;
begin
  for Snd := 1 to 150 do
    begin
      PSound(Random(3000)-1500,30);
      NoSound
    end
end;

Procedure Sparkle;
begin
  Snd2 := 600;
  for Snd1 := 1 to 5 do
    begin
      PSound(Snd2,90);
      PSound(Snd2 + 400,130);
      PSound(Snd2 + 900,150);
      Inc(Snd2,150)
    end;
  NoSound
end;

Procedure Speech;
begin
  for Snd := 1 to 100 do
    PSound(Random(400) + 37,20);
  NoSound
end;

Procedure Sprinkle;
begin
  PSound(600 ,30);
  PSound(1000,30);
  PSound(1500,30);
  PSound(2100,30);
  NoSound
end;

Procedure SlowingWheel;
begin
  for Snd := 1 to 100 do
    PSound(Trunc(100*Sin(Snd)),Snd)
end;

procedure WaveBeam;
begin
  for Snd := 1 to 100 do
    PSound(Trunc(20*Sin(Snd)+525),Trunc(10*Cos(Snd)+10))
end;

Procedure Motor;
begin
  for Snd := 1 to 30 do
  begin
    PSound(38,30);
    PSound(39,30);
    NoSound
  end;
end;

Procedure Humm;
begin
  PSound(36,30);
  PSound(37,30);
  PSound(38,30);
  PSound(39,30);
  PSound(40,30);
  for Snd := 1 to 10 do
  begin
    PSound(41,160);
    PSound(35,30);
  end;
  PSound(40,30);
  PSound(39,30);
  PSound(38,30);
  PSound(37,30);
  PSound(36,30);
  NoSound
end;

Procedure Arrive;
begin
  Snd3 := 0;
  repeat
    Snd := 580;
    repeat
      PSound(Snd,1);
      PSound(Snd-50,1);
      PSound(Snd-425,1);
      PSound(Snd-850,1);
      PSound(Snd-425,1);
      PSound(Snd-50,0);
      Inc(Snd,3);
    until Snd >= 5000;
    Inc(Snd3)
  until Snd3 = 1;
  NoSound;
end;

Procedure Depart;
begin
  Snd3 := 0;
  repeat
    Snd := 5000;
    repeat
      PSound(Snd,1);
      PSound(Snd-425,1);
      PSound(Snd-850,1);
      PSound(Snd-425,1);
      PSound(Snd-50,1);
      Dec(Snd,2);
    until Snd <= 900;
    Inc(Snd3)
  until Snd3 = 1;
  NoSound;
end;

end.

(**************************)
(***)  Initialization  (***)
(**************************)

Noise := TRUE;

end.  {Unit Sounds}
