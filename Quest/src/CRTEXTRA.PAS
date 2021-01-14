Unit CrtEXTRA;       {contains specialized keyboard & screen procedures}
                             {collected by Tom Buchanan & Michael Rimer}
Interface

Uses Crt, DOS;

const
  ON  = TRUE;
  OFF = FALSE;
  BEEP = #7;

var SetState      : byte Absolute $0040:$0017;
    h, m, s, s100 : word;
    StartClock,
    StopClock     : real;
    Noise         : boolean;     {if FALSE, sounds do not play}
    Regs          : Registers;
    ScrPtr        : ^byte;


(***************************************)

Procedure ClockOn;
Function  ClockOff : real;

Procedure SChr(x, y : word; Ch : char);
Procedure SCol(x, y : word; Col : byte);
Procedure SC(x, y : word; Chr : char; Col : byte);

Procedure RemKeys;

Procedure CursorOff;
Procedure CursorOn;
Procedure CursorFull;
Procedure BlinkOn;
Procedure BlinkOff;
Procedure SetBorder(Color : byte);

Procedure SetInsert (On : boolean);    {sets state of key}
Procedure SetCapslock (On : boolean);
Procedure SetNumlock (On : boolean);
Procedure SetScrollLock (On : boolean);
Procedure SetAlt (On : boolean);
Procedure SetCtrl (On : boolean);
Procedure SetRShift (On : boolean);
Procedure SetLShift (On : boolean);

Function  InsertOn : boolean;     {checks state of key}
Function  CapslockOn : boolean;
Function  NumLockOn : boolean;
Function  ScrollLockOn : boolean;
Function  AltOn : boolean;
Function  CtrlOn : boolean;
Function  RShiftOn : boolean;
Function  LShiftOn : boolean;
Function  ShiftOn : boolean;

(**************************)
(***)  Implementation  (***)
(**************************)

Procedure ClockOn;
  {* Starts timing}
begin
  GetTime (h, m, s, s100);
  StartClock := (h * 3600) + (m * 60) + s + (s100 / 100)
end;

Function ClockOff : real;
  {* Stops timing - returns time between start & stop}
begin
  GetTime (h, m, s, s100);
  StopClock := (h * 3600) + (m * 60) + s + (s100 / 100);
  ClockOff := StopClock - StartClock
end;

{-------------------------------------------------}

Function Mode : word;   {mono = $B000; color = $B800}
begin
  if Byte(Ptr($40,$49)^) = 7
    then Mode := $B000  {mono}
    else Mode := $B800  {color}
end;
                 {column = Yoff x 10}     {row = Xoff x 2}

Procedure SChr(x, y : word; Ch : char);
{* Directly accesses video memory - sets screen char at (x,y) to Ch}
begin
  ScrPtr := Ptr(Mode + (y - 1) * 10,(x - 1) * 2);
  ScrPtr^ := Ord(Ch)
end;

Procedure SCol(x, y : word; Col : byte);
{* Directly accesses video memory - sets screen color at (x,y) to Col}
begin
  ScrPtr := Ptr(Mode + (y - 1) * 10,(x - 1) * 2 + 1);
  ScrPtr^ := Col
end;

Procedure SC(x, y : word; Chr : char; Col : byte);
{* Accesses video memory - sets screen char & color at pos (x,y)}
begin
  ScrPtr := Ptr(Mode + (y - 1) * 10,(x - 1) * 2);
  ScrPtr^ := Ord(Chr);
  Inc(ScrPtr);
  ScrPtr^ := Col
end;

{-------------------------------------------}

Procedure RemKeys;
  {* Removes extra keystrokes in buffer}
var  Key : char;
begin
  while KeyPressed do
    begin
      Key := ReadKey;
      if Key = #0 then
        Key := ReadKey  {remove extended keys}
    end
end;

Procedure CursorOff;
  {* Makes cursor invisible}
begin
  with Regs do
    begin
      Ax := $0100;
      Cx := $1000
    end;
  Intr($10,Regs)
end;

Procedure CursorOn;
  {* Makes cursor visible}
begin
  with Regs do
    begin
      Ax := $0100;
      Cx := $0607
    end;
  Intr($10,Regs)
end;

Procedure CursorFull;
  {* Makes cursor full char box}
begin
  with Regs do
    begin
      Ax := $0100;
      Cx := $0010
    end;
  Intr($10,Regs)
end;

Procedure BlinkOn;
begin
  with Regs do
    begin
      Ax := $1003;
      Bx := $0001
    end;
  Intr($10, Regs)
end;

Procedure BlinkOff;
begin
  with Regs do
    begin
      Ax := $1003;
      Bx := $0000
    end;
  Intr($10, Regs)
end;

Procedure SetBorder(Color : byte);
begin
  with Regs do
    begin
      Ah := $10;   {INT 10,10}
      Al := $01;   {target border color}
      Bh := Color  {set color}
    end;
  Intr($10, Regs)
end;

Procedure SetInsert;
begin
  if On
    then SetState := SetState or 128
    else SetState := SetState and 127
end;

Procedure SetCapslock;
begin
  if On
    then SetState := SetState or 64
    else SetState := SetState and 191
end;

Procedure SetNumlock;
begin
  if On
    then SetState := SetState or 32
    else SetState := SetState and 223
end;

Procedure SetScrollLock;
begin
  if On
    then SetState := SetState or 16
    else SetState := SetState and 239
end;

Procedure SetAlt;
begin
  if On
    then SetState := SetState or 8
    else SetState := SetState and 247
end;

Procedure SetCtrl;
begin
  if On
    then SetState := SetState or 4
    else SetState := SetState and 251
end;

Procedure SetRShift;
begin
  if On
    then SetState := SetState or 2
    else SetState := SetState and 253
end;

Procedure SetLShift;
begin
  if On
    then SetState := SetState or 1
    else SetState := SetState and 254
end;

Function InsertOn;
begin
  InsertOn := (SetState and 128 > 0)
end;

Function CapslockOn;
begin
  CapslockOn := (SetState and 64 > 0)
end;

Function NumlockOn;
begin
  NumlockOn := (SetState and 32 > 0)
end;

Function ScrollLockOn;
begin
  ScrollLockOn := (SetState and 16 > 0)
end;

Function AltOn;
begin
  AltOn := (SetState and 8 > 0)
end;

Function CtrlOn;
begin
  CtrlOn := (SetState and 4 > 0)
end;

Function RShiftOn;
begin
  RShiftOn := (SetState and 1 > 0)
end;

Function LShiftOn;
begin
  LShiftOn := (SetState and 2 > 0)
end;

Function ShiftOn;
begin
  ShiftOn := (SetState and 3 > 0)
end;

end.  {Unit CrtEXTRA}