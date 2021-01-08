Program Animate;
{demonstrates text character animation (4-8 frames)}
Uses Crt, CrtEXTRA;
var i : integer;
   Ch : char;
begin
  TextAttr := Yellow;
  CursorOff;
  repeat
    for i := 169 to 172 do
      begin
        GotoXY(10,10);
        Write(Chr(i),Chr(i + 43));
        Delay(350)
      end
  until KeyPressed;
  Ch := ReadKey;
  repeat
    for i := 198 to 205 do
      begin
        GotoXY(12,12);
        Write(Chr(i));
        Delay(250)
      end
  until KeyPressed;

  CursorOn
end.