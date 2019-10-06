@set ASEPRITE="C:\Program Files\Aseprite\Aseprite.exe"

REM Tileset
%ASEPRITE% -b tileset.ase^
 --save-as ..\res\tileset.png

REM Animated sprites
%ASEPRITE% -b player.ase^
 --list-tags^
 --sheet-pack^
 --sheet ..\res\player.png^
 --data ..\res\player.json

 %ASEPRITE% -b door.ase^
 --list-tags^
 --sheet-pack^
 --sheet ..\res\door.png^
 --data ..\res\door.json

REM Static sprites
%ASEPRITE% -b platform.ase^
 --save-as ..\res\platform.png

 %ASEPRITE% -b interact.ase^
 --save-as ..\res\interact.png

 %ASEPRITE% -b messagebox.ase^
 --save-as ..\res\messagebox.png

 %ASEPRITE% -b spikes.ase^
 --save-as ..\res\spikes.png