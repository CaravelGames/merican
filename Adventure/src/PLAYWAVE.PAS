{$F+}
{$M 16000,0,100000}
Unit PlayWave;    {plays .wav sound files through pc speaker}

{NOTE: 8-bit mono quality sound, using 11KHz and 22KHz sample rate only}

(***)  Interface  (***)

Uses Dos, Crt;

const SPEAKER_PORT  = $61;
      PIT_CONTROL   = $43;
      PIT_CHANNEL_2 = $42;
      PIT_FREQ      = $1234DD;

     DELAY_LENGTH : integer = 750;   {different for each processor/system}
     BUFSIZE = 65500;

var f      : file;
    data   : Pointer;
    snd    : Pchar;
    len    : longint;
    error  : integer;
    WaveOn : boolean;

{------------------------------}

Procedure PlayWav(fname : string);

(***)  Implementation  (***)

Procedure PlaySound11(sound : PChar; length : word);
var count_values : array[0..255] of byte;
    i, loop : word;
begin

  { Set up the count table }
  for i := 0 to 255 do
    count_values[i] := i * 54 div 255;

  { Set up the PIT and connect the speaker to it }
  Port[PIT_CONTROL] := $90;
  Port[SPEAKER_PORT] := Port[SPEAKER_PORT] or 3;

  { Play the sound }

  asm cli end;
  for i := 0 to length - 1 do
    begin
      Port[PIT_CHANNEL_2] := count_values[byte(sound^)];
      for loop := 0 to DELAY_LENGTH do;
      Port[PIT_CHANNEL_2] := count_values[byte(sound^)];
      for loop := 0 to DELAY_LENGTH do;
      sound := sound + 1;
    end;
  asm sti end;

  { Reprogram the speaker for normal operation }
  Port[SPEAKER_PORT] := Port[SPEAKER_PORT] and $FC;
  Port[PIT_CONTROL] := $B6;
end;

Procedure PlaySound22(sound : PChar; length : word);
var count_values : array[0..255] of byte;
    i, loop : word;
begin

  { Set up the count table }
  for i := 0 to 255 do
    count_values[i] := i * 54 div 255;

  { Set up the PIT and connect the speaker to it }
  Port[PIT_CONTROL] := $90;
  Port[SPEAKER_PORT] := Port[SPEAKER_PORT] or 3;

  { Play the sound }

  asm cli end;
  for i := 0 to length - 1 do
    begin
      Port[PIT_CHANNEL_2] := count_values[byte(sound^)];
      for loop := 0 to DELAY_LENGTH do;
      sound := sound + 1;
    end;
  asm sti end;

  { Reprogram the speaker for normal operation }
  Port[SPEAKER_PORT] := Port[SPEAKER_PORT] and $FC;
  Port[PIT_CONTROL] := $B6;
end;

Procedure PlayWav(fname : string);
var buffer1  : array [0..128] of byte;
    cnt, res : word;
    samp     : word;
    size     : longint;
    f        : file;
begin
  if (not WaveOn) then EXIT;

  assign (f, fname);
  {$I-}  Reset(f, 1);  {$I+}
  if IOResult <> 0   {error - no file exists}
    then EXIT;
  blockread (f, buffer1, 8);
  blockread (f, buffer1, $18 + 4);
  samp := word (buffer1[4+$0c]) + word (buffer1[4+$0d]) * 256;
  blockread (f, buffer1, 8);
  size := 0;
  for res := 7 downto 4 do size := size * 256 + buffer1[res];
  getmem (data, BUFSIZE);
  if size > BUFSIZE then size := BUFSIZE;
  blockread (f, data^, size, res);
  if (samp = 11025) then while (res <> 0) do begin
    PlaySound11 (Pchar (data), res);
    blockread (f, data^, size, res);
  end
  else if (samp = 22050) then while (res <> 0) do begin
    PlaySound22 (Pchar (data), res);
    blockread (f, data^, size, res);
  end
  else writeln ('File has wrong speed. (Speed = ',samp,')');
  freemem (data, BUFSIZE);
  close (f)
end;

end.

(***)  Initialization  (***)

WaveOn := TRUE;

end.