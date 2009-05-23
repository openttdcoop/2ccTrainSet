echo  @ECHO OFF

set SED_PATH=%PROGRAMFILES%\GnuWin32\bin\sed.exe

ECHO.
Echo Compiling files to one .nfo
cd sprites
copy /Y nfo\2africa\*.nfo nfo\02.nfo
copy /Y nfo\3asia\*.nfo nfo\03.nfo
copy /Y nfo\4e-eu\*.nfo nfo\04.nfo
copy /Y nfo\5n-am\*.nfo nfo\05.nfo
copy /Y nfo\6s-am\*.nfo nfo\06.nfo
copy /Y nfo\7ocean\*.nfo nfo\07.nfo
copy /Y nfo\8scandinavia\*.nfo nfo\08.nfo
copy /Y nfo\9s-eu\*.nfo nfo\09.nfo
copy /Y nfo\10w-eu\*.nfo nfo\10.nfo
copy /Y nfo\strings\*.nfo nfo\strings.nfo
Echo on
copy /Y nfo\*.nfo 2cc_trainset.nfo.pre
pause

ECHO sed...

"%SED_PATH%" -f ..\scripts\nfo.sed 2cc_trainset.nfo.pre > 2cc_trainset.nfo
del 2cc_trainset.nfo.pre
pause
cd ..
ECHO Running NFORenum. . .

renum.exe -k -w 42,94,141,143,144,147,170 2cc_trainset.nfo

pause

ren sprites\2cc_trainset.nfo.new.nfo 2cc.nfo
del 2cc.grf
grfcodec.exe -e -p 2 2cc.nfo


ren 2cc.grf 2cc_trainset.grf
COPY .\2cc_trainset.grf "C:\data\OpenTTD\data" /Y

ECHO Done!
pause
