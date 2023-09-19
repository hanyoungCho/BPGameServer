@echo off
echo Cleaning dummy files...
del /s *.~* *.dsk *.bak *.dcu *.ddp *.cbk *.cfg *.drc *.dsm *.local *.stat *.vrc *.identcache *.skincfg *.tvsconfig %1 %2 %3 %4 %5 %6 %7 %8 %9
for /d /r . %%d in (__history) do @if exist "%%d" rd /Q /S "%%d"
for /d /r . %%d in (__recovery) do @if exist "%%d" rd /Q /S "%%d"
