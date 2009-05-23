echo  @ECHO OFF

set SED_PATH=%PROGRAMFILES%\GnuWin32\bin\sed.exe
set RENUM_WARN=-w 42,94,141,143,144,147,170
set GRF_FILENAME=2cc_trainset

set LOG_RENUM=renum.log
set LOG_GRFCODEC=grfcodec.log

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

ECHO sed... inserting version into file.

"%SED_PATH%" -f ..\scripts\nfo.sed 2cc_trainset.nfo.pre > %GRF_FILENAME%.nfo
del 2cc_trainset.nfo.pre
del nfo\??.nfo
del nfo\strings.nfo
pause
cd ..
ECHO Running NFORenum. . .

renum.exe %RENUM_WARN% %GRF_FILENAME%.nfo | tee %LOG_RENUM%

pause

grfcodec.exe -e -p 2 %GRF_FILENAME%.nfo | tee %LOG_GRFCODEC%

COPY %GRF_FILENAME%.grf "C:\data\OpenTTD\data" /Y

ECHO Done!
pause
