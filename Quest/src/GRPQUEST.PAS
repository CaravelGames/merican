Program GraphicsQuest;               {created by Michael Rimer on 10 MAY 94}

(* Runs "The Merican Quest" using an improved character font. *)

{$M  $1000,0,0}

Uses Crt, Graph, Dos;  {load better character graphics font}

var grDriver, grMode : integer;

begin
  DetectGraph(GrDriver,GrMode);
  case GrDriver of
    EGA, VGA : begin
            ClrScr;
            Writeln('Now loading "The Merican Quest"...');
            SwapVectors;
            if grDriver = VGA
              then Exec('Quest.vga','')
              else Exec('Quest.ega','');
            SwapVectors
          end;
  else begin
         Writeln('<EGA or VGA monitor required for this game setting>');
         EXIT
       end
  end; {case}

  SwapVectors;
  Exec('MerQuest.exe',ParamStr(1));
  SwapVectors
end.  {EgaQuest}
