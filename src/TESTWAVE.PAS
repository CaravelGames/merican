{$F+}
Program TestSpeaker;

{tests playing .wav files to the pc speaker}
{NOTE: these procedures can be found in the Playwave Unit}

Uses Dos, Crt;

const SPEAKER_PORT = $61;
       PIT_CONTROL = $43;
     PIT_CHANNEL_2 = $42;
          PIT_FREQ = $1234DD;

     DELAY_LENGTH: integer = 250;
     BUFSIZE = 65000;

var f: file;
    data: Pointer;
    snd: Pchar;
    len: longint;
    error: integer;

procedure PlaySound11(sound : PChar; length : word);
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

procedure PlaySound22(sound : PChar; length : word);
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

  procedure playwav (var f: file);
  var buffer1: array [0..128] of byte;
      cnt, res: word;
      samp: word;
      size: longint;
  begin
    assign (f, ParamStr(1));
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
    else writeln ('Wrong speed.  Speed = ', samp);
  end;

begin
  if (ParamCount < 1) then begin
    writeln('  Usage: TestWave filename [delay length]');
    writeln('Example: TestWave sound.wav 250');
    halt;
  end;
  if (ParamCount = 2) then val (ParamStr(2), DELAY_LENGTH, error);
  playwav (f);                      {^-- why can you change this constant?}
  close (f);
end.