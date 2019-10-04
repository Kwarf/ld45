@set ASEPRITE="C:\Program Files\Aseprite\Aseprite.exe"

%ASEPRITE% -b tileset.ase^
 --save-as ..\res\tileset.png

%ASEPRITE% -b player.ase^
 --list-tags^
 --sheet-pack^
 --sheet ..\res\player.png^
 --data ..\res\player.json
