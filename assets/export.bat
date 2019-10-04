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

REM Static sprites
%ASEPRITE% -b platform.ase^
 --save-as ..\res\platform.png