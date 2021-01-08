Program ChangeVntrLInfo;

{adds/modifies fields in level information file for "'Merican Adventure"}

Uses Crt;

type
  LStatRec  = record
                Name : string[30];  {level title}
                Music,              {intro music}
                Tx, Ty,             {destination of TeleTrap2}
                WC, DC,             {color of walls/dirt}
                View : byte;        {level format}
                XFlip, YFlip : boolean;  {level symmetry}
              end;

  LevelMatrix = array[1..64,1..24] of byte;  {level storage type}

  LevelRec  = record
                LStat  : LStatRec;     {level data}
                Level  : LevelMatrix;  {map data}
                Custom : LevelMatrix;  {object data}
              end;

var
  LStat      : LStatRec;
  NLStat     : LStatRec;
  LevelInfo  : LevelRec;
  NLevelInfo : LevelRec;
  LevelF     : file of LevelRec;
  NLevelF    : file of LevelRec;
  Custom, Level : LevelMatrix;
  i, x, y : integer;


begin  (* MAIN PROG *)
  Writeln('THE ''MERICAN ADVENTURE');
  Writeln('Writing new level file from "vntr.lvl" to "newvntr.lvl"...');
  Assign(LevelF,'vntr.lvl');
  Assign(NLevelF,'newvntr.lvl');
  Reset(LevelF);
  Rewrite(NLevelF);

  for i := 0 to 25 do
    begin
      Read(LevelF,LevelInfo);    {get level info}
      Level := LevelInfo.Level;
      Custom := LevelInfo.Custom;
      LStat := LevelInfo.LStat;

      for x := 1 to 64 do          {<---  modify level info HERE!}
        for y := 1 to 24 do
          case Level[x,y] of
            10..11 : Inc(Level[x,y]); {I modified some constants}
            12..16 : Level[x,y] := Level[x,y] + 3;
          end;
      NLevelInfo.Level := Level;
      NLevelInfo.Custom := Custom;
      NLevelInfo.LStat := LStat;

      Write(NLevelF,NLevelInfo);   {save}
    end;
  Close(LevelF);
  Close(NLevelF);
  Writeln('All done!')
end.
