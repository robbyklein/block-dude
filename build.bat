@echo off
REM Remove previously built files
echo Cleaning up old build files...
del dist\main.o
del dist\main.nes
del dist\main.dbg
echo Cleanup complete.

REM Start new build
echo Starting new build...
ca65 src\main.asm -o dist\main.o --debug-info
ld65 dist\main.o -o dist\main.nes -C nrom128.cfg --dbgfile dist\main.dbg
echo Build complete.
