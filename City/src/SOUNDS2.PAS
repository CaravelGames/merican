Unit Sounds2;   {62 sounds designed by Erik Anderson}

(***)  Interface  (***)

Uses Sounds, Crt;

Procedure Squish4;
Procedure Chirp1;
Procedure LowChirp1;
Procedure Chirp2;
Procedure DownChirp;
Procedure Wiggle;
Procedure UpScratch1;
Procedure DownScratch;
Procedure UpScratch2;
Procedure Whistle1;
Procedure BubbleUp1;
Procedure Chirp3;
Procedure BubbleUp2;
Procedure BubbleDown1;
Procedure TripleChirp;
Procedure Toast;
Procedure BubbleDown2;
Procedure Whistle2;
Procedure Chirp4;
Procedure FallDown1;
Procedure WiggleFall;
Procedure Spike1;
Procedure Spike2;
Procedure Spike3;
Procedure Rubble;
Procedure WarpUp1;
Procedure LampPost;
Procedure Frog;
Procedure UpTones1;
Procedure Perish1;
Procedure DownSpike1;
Procedure Sticky;
Procedure Perish2;
Procedure Spike4;
Procedure Perish3;
Procedure UpTones2;
Procedure WarpUp2;
Procedure Wave;
Procedure Strange1;
Procedure WarpUp3;
Procedure MetalBall1;
Procedure Beam1;
Procedure Fry;
Procedure Beam2;
Procedure Metal1;
Procedure Zap;
Procedure Fizz1;
Procedure Chirp5;
Procedure Robot;
Procedure Strange2;
Procedure Metal2;
Procedure Rebound;
Procedure Fizz2;
Procedure Drain;
Procedure Laser1;
Procedure Whoop1;
Procedure Chirp6;
Procedure Crumble1;
Procedure LowChirp2;
Procedure Spike5;
Procedure FallDown2;
Procedure MetalBall2;

(***)  Implementation  (***)

Procedure Squish4;
begin
  if (not Noise) then EXIT;
  RandSeed := 8974;
  for Snd := 4747 to 4811 do
    begin
      Sound(Random(Snd));
      Delay(5)
    end;
  NoSound;
end;

Procedure Chirp1;
begin
  if (not Noise) then EXIT;
  for Snd := 4092 downto 3856 do
    begin
      Sound(Snd);
      Delay(1)
    end;
  NoSound
end;

Procedure LowChirp1;
begin
  if (not Noise) then EXIT;
  Snd2 := 584;
  for Snd := 584 to 633 do
    begin
      for Snd1 := 673 downto Snd2 do
        begin
          Sound(Snd);
          Delay(2);
          Sound(Snd1);
          Delay(2);
          Inc(Snd2,3)
        end
    end;
  NoSound
end;

Procedure Chirp2;
begin
  if (not Noise) then EXIT;
  Snd := 757;
  for i1 := 1 to 70 do
    begin
      Sound(Snd);
      Inc(Snd,i1);
      Delay(4)
    end;
  NoSound
end;

Procedure DownChirp;
begin
  if (not Noise) then EXIT;
  RandSeed := 478;
  Snd := 937;
  for i1 := 1 to 89 do
    begin
      case Random(4) of
        0 : Dec(Snd,3);
        1 : Dec(Snd,5);
        2 : Dec(Snd,8);
        3 : Dec(Snd,13)
      end;
      Sound(Snd);
      Delay(6)
    end;
  NoSound
end;

Procedure Wiggle;
begin
  if (not Noise) then EXIT;
  RandSeed := 478;
  Snd := 937;
  for i1 := 1 to 89 do
    begin
      case Random(4) of
        0 : Dec(Snd,3);
        1 : Inc(Snd,5);
        2 : Dec(Snd,8);
        3 : Inc(Snd,13)
      end;
      Sound(Snd);
      Delay(6)
    end;
  NoSound
end;

Procedure UpScratch1;
const time = 4;
begin
  if (not Noise) then EXIT;
  Snd := 89;
  Snd1 := 345;
  Snd2 := 568;
  Snd3 := 632;
  for i1 := 1 to 21 do
    begin
      Sound(Snd);
      Inc(Snd,21);
      Delay(time);
      Sound(Snd1);
      Inc(Snd1,13);
      Delay(time);
      Sound(Snd2);
      Inc(Snd2,8);
      Delay(time);
      Sound(Snd3);
      Inc(Snd3,5);
      Delay(time)
    end;
  NoSound
end;

Procedure DownScratch;
const time = 4;
begin
  if (not Noise) then EXIT;
  Snd := 530;
  Snd1 := 618;
  Snd2 := 736;
  Snd3 := 737;
  for i1 := 1 to 21 do
    begin
      Sound(Snd);
      Dec(Snd,21);
      Delay(time);
      Sound(Snd1);
      Dec(Snd1,13);
      Delay(time);
      Sound(Snd2);
      Dec(Snd2,8);
      Delay(time);
      Sound(Snd3);
      Dec(Snd3,5);
      Delay(time)
    end;
  NoSound
end;

Procedure UpScratch2;
const time = 4;
begin
  if (not Noise) then EXIT;
  Snd := 89;
  Snd1 := 226;
  Snd2 := 345;
  Snd3 := 568;
  Snd4 := 632;
  for i1 := 1 to 21 do
    begin
      Sound(Snd);
      Inc(Snd,34);
      Delay(time);
      Sound(Snd1);
      Delay(time);
      Inc(Snd1,21);
      Sound(Snd2);
      Inc(Snd2,13);
      Delay(time);
      Sound(Snd3);
      Inc(Snd3,8);
      Delay(time);
      Sound(Snd4);
      Inc(Snd4,5);
      Delay(time)
    end;
  NoSound
end;

Procedure Whistle1;
begin
  if (not Noise) then EXIT;
  Snd := 55;
  for i1 := 1 to 60 do
    begin
      Sound(Snd * i1);
      Delay(i1 div 30 + 5)
    end;
  NoSound
end;

Procedure BubbleUp1;
begin
  if (not Noise) then EXIT;
  for i1 := 1 to 20 do
    for i2 := 1 to 5 do
      begin
        Sound(i1 * 10 + i2 * i1 * i1);
        Delay(i1 + i2);
        NoSound
      end;
end;

Procedure Chirp3;
begin
  if (not Noise) then EXIT;
  Snd := 42;
  for i1 := 37 to 89 do
    begin
      Sound(Snd * i1);
      Delay(i1 div 30 + 5)
    end;
  NoSound
end;

Procedure BubbleUp2;
begin
  if (not Noise) then EXIT;
  for Snd := 258 to 369 do
    begin
      Sound(Snd + Snd mod 57);
      Delay(Snd mod 3 + 2)
    end;
  NoSound
end;

Procedure BubbleDown1;
begin
  if (not Noise) then EXIT;
  i1 := 1;
  for Snd := 467 downto 319 do
    begin
      Sound((Snd div (2 + i1)) * i1);
      Delay(3);
      Inc(i1)
    end;
  NoSound
end;

Procedure TripleChirp;
begin
  if (not Noise) then EXIT;
  for Snd := 45 to 47 do
    for Snd1 := 24 to 44 do
      begin
        Sound(Snd * Snd1);
        Delay(Snd - Snd1)
      end;
  NoSound
end;

Procedure Toast;
begin
  if (not Noise) then EXIT;
  RandSeed := 4784;
  for i1 := 1 to 150 do
    begin
      Sound(Random(8) * 100  + 300);
      Delay(Random(8))
    end;
  NoSound
end;

Procedure BubbleDown2;
begin
  if (not Noise) then EXIT;
  RandSeed := 3473;
  for i1 := 1 to 3 do
    begin
      Snd := Random(673) + 37;
      for i2 := 1 to 37 do
        begin
          Sound(Snd);
          Inc(Snd,16);
          Delay(4)
        end
    end;
  NoSound
end;

Procedure Whistle2;
begin
  if (not Noise) then EXIT;
  RandSeed := 10208;
  for i1 := 1 to 4 do
    begin
      Snd := Random(5894);
      for i2 := 1 to 26 do
        begin
          Sound(Snd);
          Inc(Snd,39);
          Delay(4)
        end
    end;
  NoSound
end;

Procedure Chirp4;
begin
  if (not Noise) then EXIT;
  Snd := 169;
  repeat
    Sound(Snd div 2 * 3);
    Delay(Snd div 100 + 1);
    Inc(Snd, 8)
  until Snd > 789;
  NoSound
end;

Procedure FallDown1;
begin
  if (not Noise) then EXIT;
  Snd := 3783;
  repeat
    Sound(Snd);
    Delay(5);
    Inc(Snd,100);
    for i1 := 1 to 20 do
      begin
        Sound(Snd);
        Delay(4);
        Dec(Snd,9)
      end
  until Snd < 50;
  NoSound
end;

Procedure WiggleFall;
begin
  if (not Noise) then EXIT;
  Snd := 4563;
  repeat
    Sound(Snd);
    Delay(4);
    Dec(Snd,246);
    for i1 := 1 to 27 do
      begin
        Sound(Snd);
        Delay(3);
        Inc(Snd,7)
      end
  until Snd < 2567;
  NoSound
end;

Procedure Spike1;
begin
  if (not Noise) then EXIT;
  Snd := 58;
  repeat
    for i1 := 1 to 22 do
      begin
        Sound(Snd);
        Inc(Snd,745);
        Delay(5)
      end;
    for i2 := 1 to 34 do
      begin
        Sound(Snd);
        Dec(Snd,245);
        Delay(5)
      end
  until Snd > 6789;
  NoSound
end;

Procedure Spike2;
begin
  if (not Noise) then EXIT;
  Snd := 491;
  for Snd1 := 1 to 9 do
    begin
      Snd3 := Snd;
      for Snd2 := 1 to 852 do
        begin
          Sound(Snd3);
          Inc(Snd)
        end;
      Snd3 := Snd + 657
    end;
  NoSound
end;

Procedure Spike3;
begin
  if (not Noise) then EXIT;
  Snd := 102;
  for i1 := 1 to 56 do
    begin
      Sound(Snd * i1 * (i1 mod 3));
      Delay(4 + i1 mod 2)
    end;
  NoSound
end;

Procedure Rubble;
begin
  if (not Noise) then EXIT;
  Snd := 5357;
  for i1 := 75 downto 17 do
    begin
      Sound(Snd div (Snd mod i1));
      Delay(4 + i1 mod 3)
    end;
  NoSound
end;

Procedure WarpUp1;
begin
  if (not Noise) then EXIT;
  RandSeed := 3478;
  for i1 := 0 to 255 do
    begin
      Sound(Random(i1) * 10 + 55);
      Delay(Random(i1) div 50 + 2)
    end;
  NoSound
end;

Procedure LampPost;
begin
  if (not Noise) then EXIT;
  for Snd := 384 to 467 do
    begin
      Sound(((2378 div Snd) mod Snd) * 438);
      Delay(5)
    end;
  NoSound
end;

Procedure Frog;
begin
  if (not Noise) then EXIT;
  Snd := 1347;
  for i1 := 243 downto 154 do
    begin
      Sound((Snd mod i1) * Snd div 3);
      Delay(5)
    end;
  NoSound
end;

Procedure UpTones1;
begin
  if (not Noise) then EXIT;
  Snd := 6632;
  for i1 := 38 downto 35 do
    for i2 := 134 to 146 do
      begin
        Sound(((Snd div i1) mod 59) * i2);
        Delay(i2 mod i1)
      end;
  NoSound
end;

Procedure Perish1;
begin
  if (not Noise) then EXIT;
  Snd := 8373;
  repeat
    Sound((Snd div 5) * 3);
    Dec(Snd,Snd mod 77 + 256);
    Delay(Snd mod 3 + 3)
  until Snd < 500;
  NoSound
end;

Procedure DownSpike1;
begin
  if (not Noise) then EXIT;
  Snd := 7866;
  repeat
    Sound(Snd);
    Delay(4);
    Sound(Snd div 2);
    Delay(4);
    Dec(Snd,78)
  until Snd < 2500;
  NoSound
end;

Procedure Sticky;
begin
  if (not Noise) then EXIT;
  Snd := 678;
  repeat
    Sound(Snd);
    Delay(4);
    Sound((Snd mod 456) * 2);
    Delay(4);
    Inc(Snd,478)
  until Snd > 9339;
  NoSound
end;

Procedure Perish2;
begin
  if (not Noise) then EXIT;
  Snd := 4555;
  repeat
    Sound(Snd);
    Snd1 := Snd;
    Dec(Snd,(Snd1 mod 199) + 189);
    Delay((Snd div 100) - 1)
  until Snd < 300;
  NoSound
end;

Procedure Spike4;
begin
  if (not Noise) then EXIT;
  Snd := 489;
  for i1 := 23 to 61 do
    begin
      Sound(Snd + 18 * i1);
      Delay(3);
      Sound(Snd + i1 * 2);
      Delay(4);
      Sound(Snd - i1 * 5);
      Delay(4);
      Sound(Snd + 18 * (Snd mod i1));
      Delay(3);
      Inc(Snd,357)
    end;
  NoSound
end;

Procedure Perish3;
begin
  if (not Noise) then EXIT;
  Snd := 6898;
  for i1 := 1 to 22 do
    begin
      Sound(Snd - 904);
      Delay(4);
      Sound(Snd - 456);
      Delay(4);
      Sound(Snd - 109);
      Delay(4);
      Sound(Snd - 23);
      Delay(4);
      Dec(Snd,678)
    end;
  NoSound
end;

Procedure UpTones2;
begin
  if (not Noise) then EXIT;
  for Snd1 := 1 to 18 do
    begin
      Snd := Snd1 * 150;
      Sound(Snd);
      for Snd2 := 25 downto 1 do
        begin
          Snd3 := Snd2 * 150;
          Sound(Snd - Trunc(ln(Snd3)));
          Delay(5)
        end
    end;
  NoSound
end;

Procedure WarpUp2;
begin
  if (not Noise) then EXIT;
  for Snd1 := 1 to 15 do
    for Snd := 1 to Snd1 do
      begin
        Sound(Snd * 100);
        Delay(5)
      end;
  NoSound
end;

Procedure Wave;
begin
  if (not Noise) then EXIT;
  for Snd := 1 to 15 do
    begin
      Sound(Snd * 100);
      Delay(25)
    end;
  for Snd := 14 downto 1 do
    begin
      Sound(Snd * 100);
      Delay(25);
    end;
  NoSound
end;

Procedure Strange1;
begin
  if (not Noise) then EXIT;
  for Snd := 1 to 10 do
    begin
      Sound(Trunc(Exp(Snd)));
      Delay(90)
    end;
  NoSound
end;

Procedure WarpUp3;
begin
  if (not Noise) then EXIT;
  for Snd1 := 1 to 15 do
    begin
      Snd := Snd1 * 100;
      Sound(Snd);
      Delay(30);
      for Snd2 := 15 downto Snd1 do
        begin
          Snd := Snd2 * 100;
          Sound(Snd);
          Delay(5)
        end
    end;
  NoSound
end;

Procedure MetalBall1;
begin
  if (not Noise) then EXIT;
  for Snd1 := 1 to 10 do
    for Snd2 := 10 downto Snd1 do
      begin
        Snd := Trunc(Exp(Snd2));
        Sound(Snd);
        Delay(15)
      end;
  NoSound
end;

Procedure Beam1;
begin
  if (not Noise) then EXIT;
  for Snd := 9874 downto 9775 do
    begin
      Sound(Snd);
      Delay(2);
      NoSound
    end
end;

Procedure Fry;
begin
  if (not Noise) then EXIT;
  for Snd := 1 to 147 do
    begin
      Sound(Random(1000) + 1000);
      Delay(5);
      NoSound
    end
end;

Procedure Beam2;
begin
  if (not Noise) then EXIT;
  for Snd := 100 to 1500 do
    begin
      Sound(Snd);
      Delay(1);
      NoSound
    end
end;

Procedure Metal1;
const delaytime = 5;
begin
  if (not Noise) then EXIT;
  Snd := 1000;
  Snd1 := 2000;
  for i1 := 1 to 100 do
    begin
      Sound(Snd);
      Delay(delaytime);
      Inc(Snd,5);
      NoSound;
      Sound(Snd1);
      Delay(delaytime);
      Dec(Snd1,5);
      NoSound
    end
end;

Procedure Zap;
begin
  if (not Noise) then EXIT;
  for Snd := 2000 to 2050 do
    begin
      Sound(Snd);
      Delay(7);
      NoSound;
      Sound(Snd + 7);
      Delay(5);
      NoSound;
      Sound(Snd + 3);
      Delay(5);
      NoSound;
      Sound(Snd + 5);
      Delay(5);
      NoSound
    end
end;

Procedure Fizz1;
begin
  if (not Noise) then EXIT;
  for Snd1 := 3000 to 3015 do
    begin
      Sound(Snd1);
      Delay(2);
      for Snd2 := (Snd1*2) downto Snd1 do
        Sound(Snd2)
    end;
  NoSound
end;

Procedure Chirp5;
begin
  if (not Noise) then EXIT;
  for Snd := 4500 to 4750 do
    if Random(2) = 0
      then begin
             Sound(Snd);
             Delay(4)
           end;
  NoSound
end;

Procedure Robot;
begin
  if (not Noise) then EXIT;
  for Snd := 20 downto 10 do
    begin
      Sound(Round(Exp(Snd)) div Snd);
      Delay(90);
      NoSound
    end
end;

Procedure Strange2;
begin
  if (not Noise) then EXIT;
  for Snd := 10 downto 1 do
    begin
      Sound(Round(Exp(Snd)) div Snd);
      Delay(90);
      NoSound
    end
end;

Procedure Metal2;
const delaytime = 5;
begin
  if (not Noise) then EXIT;
  Snd := 1000;
  Snd1 := 2000;
  for i1 := 1 to 100 do
    begin
      Sound(Snd);
      Delay(delaytime);
      Dec(Snd,5);
      NoSound;
      Sound(Snd1);
      Delay(delaytime);
      Inc(Snd1,5);
      NoSound
    end;
end;

Procedure Rebound;
begin
  if (not Noise) then EXIT;
  Snd := 6837;
  for i1 := 1 to 33 do
    begin
      Snd := ((Snd + 97) * 9) div i1;
      Sound(Snd);
      Delay(30)
    end;
  NoSound
end;

Procedure Fizz2;
begin
  if (not Noise) then EXIT;
  RandSeed := 479;
  for i1 := 1 to 45 do
    begin
      case Random(8) of
        0 : Sound(4593);
        1 : Sound(4747);
        2 : Sound(3637);
        3 : Sound(2849);
        4 : Sound(8354);
        5 : Sound(6487);
        6 : Sound(5553);
        7 : Sound(4647)
      end;
      Delay(5)
    end;
  NoSound
end;

Procedure Drain;
begin
  if (not Noise) then EXIT;
  Snd1 := 0;
  Snd2 := 1;
  for i1 := 1 to 130 do
    begin
      Snd3 := Snd1 + Snd2;
      Sound(Snd3);
      Snd1 := Snd2;
      Snd2 := Snd3;
      Delay(4)
    end;
  NoSound
end;

Procedure Laser1;
begin
  if (not Noise) then EXIT;
  for i1 := 64 downto 57 do
    for i2 := 14 to 29 do
      begin
        Sound(i1 * i2);
        Delay(5)
      end;
  NoSound
end;

Procedure Whoop1;
begin
  if (not Noise) then EXIT;
  Snd := 62;
  repeat
    Sound(Snd);
    Inc(Snd,3);
    Delay(1)
  until Snd > 915;
  NoSound
end;

Procedure Chirp6;
begin
  if (not Noise) then EXIT;
  Snd := 1934;
  i1 := 3;
  repeat
    Sound(Snd);
    Inc(Snd,i1);
    Inc(i1,1);
    Delay(5)
  until Snd > 2934;
  NoSound
end;

Procedure Crumble1;
begin
  if (not Noise) then EXIT;
  RandSeed := 4784;
  for i1 := 3 to 55 do
    begin
      Sound(Random(10) * i1);
      Delay(5)
    end;
  NoSound
end;

Procedure LowChirp2;
begin
  if (not Noise) then EXIT;
  for Snd := 252 to 317 do
    begin
      Sound(Snd * 2);
      Delay(5)
    end;
  NoSound
end;

Procedure Spike5;
begin
  if (not Noise) then EXIT;
  for i1 := 1 to 47 do
    begin
      Snd := 367;
      Sound(Snd * i1);
      Delay(5)
    end;
  NoSound
end;

Procedure FallDown2;
begin
  if (not Noise) then EXIT;
  for Snd := 489 downto 397 do
    begin
      Snd1 := 5;
      Sound(Snd1 * Snd);
      Delay((Snd div Snd1) div 10)
    end;
  NoSound
end;

Procedure MetalBall2;
begin
  if (not Noise) then EXIT;
  RandSeed := 666;
  for i1 := 1 to 255 do
    begin
      Sound(Trunc(Exp(Random(20))));
      Delay((Random(5)) + 1)
    end;
  NoSound
end;

end.  {Unit ErikSnd}
