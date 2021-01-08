Program EriksSounds;      {plays sounds in Sounds2 unit}

Uses Sounds, Sounds2, Crt;

BEGIN
  Noise := TRUE;
  TextAttr := LightBlue;
  repeat
    ClrScr;
    Write('Choose a sound to play (1-62,0 quits): ');
    Readln(i4);
    case i4 of
      1 : Squish4;      {first sounds}
      2 : Chirp1;
      3 : LowChirp1;
      4 : Chirp2;
      5 : DownChirp;
      6 : Wiggle;
      7 : UpScratch1;
      8 : DownScratch;
      9 : UpScratch2;
      10 : Whistle1;
      11 : BubbleUp1;
      12 : Chirp3;
      13 : BubbleUp2;
      14 : BubbleDown1;
      15 : TripleChirp;
      16 : Toast;
      17 : BubbleDown2;
      18 : Whistle2;
      19 : Chirp4;
      20 : FallDown1;
      21 : WiggleFall;
      22 : Spike1;
      23 : Spike2;
      24 : Spike3;
      25 : Rubble;
      26 : WarpUp1;
      27 : LampPost;
      28 : Frog;
      29 : UpTones1;
      30 : Perish1;
      31 : DownSpike1;
      32 : Sticky;
      33 : Perish2;
      34 : Spike4;
      35 : Perish3;
      36 : UpTones2;
      37 : WarpUp2;
      38 : Wave;
      39 : Strange1;
      40 : WarpUp3;       {funny sounds}
      41 : MetalBall1;
      42 : Beam1;
      43 : Fry;
      44 : Beam2;
      45 : Metal1;
      46 : Zap;
      47 : Fizz1;
      48 : Chirp5;
      49 : Robot;
      50 : Strange2;
      51 : Metal2;
      52 : Rebound;
      53 : Fizz2;
      54 : Drain;
      55 : Laser1;
      56 : Whoop1;
      57 : Chirp6;
      58 : Crumble1;
      59 : LowChirp2;
      60 : Spike5;
      61 : FallDown2;
      62 : MetalBall2;
    end {i4 case}
  until (i4 = 0)
END.