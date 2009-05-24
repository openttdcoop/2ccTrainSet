echo  @ECHO OFF

rem set RENUM_WARN=-w 42,94,141,143,144,147,170
set RENUM_WARN=-w141
set GRF_FILENAME=2cc_trainset
set REGION_DIRS=
set SPRITEDIR=sprites
set NFODIR=%SPRITEDIR%/nfo

set REGION_DIRS=2africa 3asia 4e-eu 5n-am 6s-am 7ocean 8scandinavia 9s-eu 10w-eu
set LANG_DIR=strings
set HEADER=00header
set OTHER=01wagons 00sounds
set FOOTER=regsel

set LOG_RENUM=renum.log
set LOG_GRFCODEC=grfcodec.log

Echo Compiling files to one .nfo
echo "%REGION_DIRS%"
cd %NFODIR%
FOR %%i IN (%REGION_DIRS%) DO COPY /Y .\%%i\*.nfo %%i.nfo
COPY /Y %LANG_DIR%\*.nfo %LANG_DIR%.nfo
copy /Y *.nfo ..\%GRF_FILENAME%.nfo.pre

ECHO sed... inserting version into file.
cd ..
sed -f ..\scripts\nfo.sed %GRF_FILENAME%.nfo.pre > %GRF_FILENAME%.nfo

rem del 2cc_trainset.pre
rem del nfo\??.nfo
rem del nfo\strings.nfo
cd ..
ECHO Running NFORenum. . .

renum %RENUM_WARN% %GRF_FILENAME%.nfo | tee %LOG_RENUM%

grfcodec -e -p 2 %GRF_FILENAME%.nfo | tee %LOG_GRFCODEC%

COPY %GRF_FILENAME%.grf "C:\data\OpenTTD\data" /Y

ECHO Done!
pause