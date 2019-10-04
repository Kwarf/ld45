@echo off
set EXE_NAME=ld45

if exist export rmdir /s /q export

echo Exporting win64
mkdir export\win64
godot --no-window --export "Windows Desktop" export\win64\%EXE_NAME%.exe

echo Exporting linux64
mkdir export\linux64
godot --no-window --export "Linux/X11" export\linux64\%EXE_NAME%

echo Exporting HTML5
mkdir export\html
godot --no-window --export "HTML5" export\html\%EXE_NAME%.html

echo Done
pause