# merican
This repo preserves the source and history of "THE 'MERICAN ADVENTURE",
a KROZ/ZZT-inspired DOS game written by Mike Rimer in Turbo Pascal 7 in the '90s.

It was the third in a series, succeeding earlier titles called
"THE 'MERICAN CITY" and "THE 'MERICAN QUEST". The first two games may now
be lost to time. A fourth game, "THE 'MERICAN SORCERER", was in early
development but never completed.

You should be able to compile and modify the source with a TP7 compiler.

To run this DOS game with a respectable level of fidelity on modern computers
and OSs, you will likely need to do it via a utility like DOSBox.  Playing in
fullscreen mode is recommended (Alt-Enter in DOSBox).  Using the default game
speed and sound settings will likely work best.

Caveat: the game makes optional use of specialized routines for  modulating
the (ancient) on-board PC speaker.  This functionality doesn't appear
to work correctly in DOSBox, so enabling the "Enhanced Sound" mode is not
recommended.  See below for more details.

-------------------------------------------------------------------------------

The original README text, updated for modern usage:

THE 'MERICAN ADVENTURE
(c) 1995 by Michael Rimer
-------------------------------

This is a game of exploration, puzzles, and strategy.
Try to get through all 25 levels!

TO PLAY:
Run "VNTR" in DOSBox.

TO USE THE LEVEL EDITOR:
Run "VNTREDIT" in DOSBox.


-------------------------------
NOTES and TROUBLESHOOTING:

INSTRUCTIONS:
Read the in-game help from the Title Screen to learn how to play,
and from the editor screen to use the fully-functional level editor.

GRAPHICS:
This is a DOS game that uses a custom ASCII character set and must be run in a
full screen DOS window to view it properly.
(That is, don't just maximize the window...but set it to a full screen,
dedicated window by pressing Alt-Enter in DOSBox or the command terminal
in Windows.)

Try starting a DOS window, making it full screen by hitting Alt-Enter, and
running the game from the command prompt.

Caveat: The game will also "work" with the standard ASCII set in windowed mode,
but it will look and play poorly.

GAME SPEED:
I'm not sure how reliable the built-in timing functions are on different CPUs.
Change the setting for the "Computer Speed" option on the Title Screen if the
game is running too fast or too slow for your taste (saying you have a faster
computer will tell the game to run slower to compensate).  The default option
is probably fine.  You will be able to confirm whether your keyboard movement
repeat rate is too fast or too slow when you begin playing.

SOUND:
The game has a fun set of old school synthesized sounds that play through the
PC speaker.  It also has the option of playing .wav files (under 64KB)
through the PC speaker.  Selecting Full/Enhanced sound will enable them.
However, these sounds might not play properly on modern systems, so
they probably will not work for you either.

If you hear pauses at the beginning of the levels but no
music clips are playing, then just put the sound on "On" instead of "Full" to
avoid attempting to play the .wav files.


-----------------------------
A WORD TO DROD USERS:

This game could be called kind of a cross between DROD and old-school games
like Rogue/NetHack, Kroz, and ZZT.  It's got neat, handcrafted rooms and
exploration puzzles like DROD, and also some RPG elements like player stats,
rooms that don't reset when you come back to them, some quasi-random events,
and it plays in real-time (albeit on a grid, with timed monster movement).
So for those looking for some DROD origins, with some random events, more
ways to build multi-room puzzles, and different kinds of weapons:
this is the game for you.

You wield a sword in this game, and when you use it you can swing it around
and hurt all the adjacent monsters surrounding you -- but its use is limited
(this isn't a hack-and-slash game), so watch your sword energy meter for
how many times you may swing your sword.  Magic spells are basically a more
powerful weapon than your sword, and more rare.

I used the level editor to design all the levels in the game, and I encourage
you to use it to design your own amazing levels!  The editor Help Screen
explains how to make your own level sets by specifying what level file to
load from the command line.  To do this, edit the VNTREDIT shortcut file
Properties and add command line parameters after the VNTREDIT.EXE filename it
says it will run.  Alternately, you can run it with command-line parameters
from a DOS window.  (Remember when we all did that?)

The level editor has help screens that more or less describe everything you
can do with it, but you're welcome to field questions my way.  If there's
enough interest, I might start up a FAQ or something.

I don't plan to maintain this ol' game any further (such as adding new items,
functionality or fixing any bugs you might find), but if there is enough
interest, then a game similar to this one might show up one day with a
modern game engine, many more levels, and a bunch of new fun stuff included.

Enjoy!

-- Mike