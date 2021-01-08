program sounds4;
uses Crt;
var t, i, x, y, z: integer;
        choice: char;

  procedure landing;
  begin
    t:= 9000;
    repeat
    begin
      sound (t);
      t:= t-10;
      delay (10);
      nosound;
    end;
    until t < 50;
  end;

  procedure falling;
  begin
    t:= 9000;
    repeat
    begin
      sound (t);
      t:= t-10;
      delay (10);
    end;
    until t < 50;
    nosound;
  end;

  procedure inandout;
  begin
    t:= 19000;
    for i:= 1 to 3 do
    begin
      repeat
      begin
        sound (t);
        t:= t - 10;
        delay (10);
        nosound;
      end;
      until t < 50;
      repeat
      begin
        sound (t);
        t:= t + 10;
        delay (10);
        nosound;
      end;
      until t > 8000;
    end;
    repeat
    begin
      sound (t);
      t:= t - 10;
      delay (10);
      nosound;
    end;
    until t < 50;
  end;

  procedure electricpulse;
  begin
    t:= 9000;
    for i:= 1 to 3 do
    begin
      repeat
      begin
        sound (t);
        t:= t - 10;
        delay (1);
        nosound;
      end;
      until t < 50;
      repeat
      begin
        sound (t);
        t:= t + 10;
        delay (1);
        nosound;
      end;
      until t > 8000;
    end;
    repeat
    begin
      sound (t);
      t:= t - 10;
      delay (1);
      nosound
    end;
    until t < 50;
  end;

  procedure radio;
  begin
    t:= 9000;
    repeat
    begin
      sound (t);
      t:= t - 10;
      delay (1);
    end;
    until t < 50;
    repeat
    begin
      sound (t);
      t:= t + 10;
      delay (1);
    end;
    until t > 8000;
  repeat
  begin
    sound (t);
    t:= t - 10;
    delay (1);
  end;
  until t < 50;
  nosound;
 end;

  procedure scramble;
  begin
    i:= 500;
    repeat
    begin
      t:= (random (3000) + 37);
      sound (t);
      i:= i - 1;
      delay (10);
      nosound;
    end;
    until i = 0;
  end;

  procedure fastforward;
  begin
    i:= 500;
    repeat
    begin
      t:= (random (9000) + 37);
      sound (t);
      i:= i - 1;
      delay (10);
      nosound;
    end;
    until i = 0;
  end;

  procedure bubblingup;
  begin
    t:= 50;
    for  i:= 1 to 50 do
    begin
      sound (t);
      delay (1);
      for x:= 1 to 20 do
      begin
        t:= t + 23;
        sound (t);
        delay (3);
      end;
      t:= t - 400;
      nosound;
    end;
  end;

  procedure chirps;
  begin
    x:= 3000;
    y:= 3000;
    z:= 2;
      for i:= 1 to 30 do
      begin
        for t:= 1 to 5 do
        begin
          sound (x);
          x:= x + 10;
          delay (5);
        end;
        begin
          sound (y);
          y:= y - 10;
          delay (5);
        end;
        nosound;
      end;
  end;

  procedure randombubbles;
  begin
    for i := 1 to 25 do
    begin
      x:= (random (500) + 40);
      for y := 1 to 20 do
      begin
        sound (x);
        delay (5);
        x:= x + 20;
      end;
    end;
    nosound;
  end;

  procedure random1;
  begin
    writeln ('Please enter the number of notes.');
    readln (i);
    repeat
      begin
        sound (random (5000) + 37);
        delay ((random (400) + 100));
        i:= i - 1;
      end;
      until i = 0;
      nosound;
    end;

  procedure random2;
  begin
    writeln ('Please enter the number of notes.');
    readln (i);
    repeat
    begin
      x:= (random (10) + 1);
      y:= (random (50) + 25);
      if x = 1 then sound (264);
      delay (y);
      if x = 2 then sound (275);
      delay (y);
      if x = 3 then sound (330);
      delay (y);
      if x = 4 then sound (352);
      delay (y);
      if x = 5 then sound (396);
      delay (y);
      if x = 6 then sound (440);
      delay (y);
      if x = 7 then sound (495);
      delay (y);
      if x = 8 then sound (528);
      delay (y);
      i:= i - 1;
    end;
    until i = 0;
    sound (396);
    delay (500);
    sound (264);
    delay (500);
    nosound;
  end;

  procedure random3;
  begin
    writeln ('Please enter the number of notes.');
    readln (i);
    sound (264);
    delay (50);
    repeat
    begin
      x:= (random (10));
      y:= (random (10) + 5);
      if x = 0 then sound (132);
      delay (y);
      if x = 1 then sound (165);
      delay (y);
      if x = 2 then sound (198);
      delay (y);
      if x = 3 then sound (264);
      delay (y);
      if x = 4 then sound (330);
      delay (y);
      if x = 5 then sound (396);
      delay (y);
      if x = 6 then sound (528);
      delay (y);
      if x = 7 then sound (660);
      delay (y);
      if x = 8 then sound (792);
      delay (y);
      if x = 9 then sound (1056);
      delay (y);
      i:= i - 1;
    end;
    until i = 0;
    sound (396);
    delay (200);
    sound (264);
    delay (500);
    nosound;
  end;

  procedure new;
  begin
    for i:= 1 to 50 do
    begin
      sound (528);
      sound (660);
      sound (792);
      sound (1056);
    end;
    nosound;
  end;

  procedure mainmenu;
  begin
    Textattr := (lightblue);
    ClrScr;
    writeln ('Sound Test');
    writeln;
    writeln ('A : Landing           B : In and Out');
    writeln ('C : Electric Pulse    D : Radio');
    writeln ('E : Falling           F : Scramble');
    writeln ('G : Fast Forward      H : Bubbling Up');
    writeln ('I : Chirps            J : Random # 1');
    writeln ('K : Random # 2        L : Random # 3');
    writeln ('M : Random Bubbles');
    writeln ('Y : new');
    writeln ('Z : Quit');
    choice := readkey;
  end;

begin
  repeat
  begin
    mainmenu;
    if choice = 'a' then landing;
    if choice = 'b' then inandout;
    if choice = 'c' then electricpulse;
    if choice = 'd' then radio;
    if choice = 'e' then falling;
    if choice = 'f' then scramble;
    if choice = 'g' then fastforward;
    if choice = 'h' then bubblingup;
    if choice = 'i' then chirps;
    if choice = 'j' then random1;
    if choice = 'k' then random2;
    if choice = 'l' then random3;
    if choice = 'm' then randombubbles;
    if choice = 'y' then new;
  end;
  until choice = 'z';
end.  {sounds4}
