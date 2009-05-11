  @ECHO OFF
ECHO.
Echo Compiling files to one .nfo
cd "Y:\grf\grf\2cc\sprites"
copy /Y nfo\2africa\a0a4.nfo+nfo\2africa\engine.nfo+nfo\2africa\mus.nfo+nfo\2africa\metro.nfo nfo\2.nfo
copy /Y nfo\3asia\a0a4.nfo+nfo\3asia\engine.nfo+nfo\3asia\mus.nfo+nfo\3asia\metro.nfo nfo\3.nfo
copy /Y nfo\4e-eu\a0a4.nfo+nfo\4e-eu\engine.nfo+nfo\4e-eu\mus.nfo+nfo\4e-eu\metro.nfo nfo\4.nfo
copy /Y nfo\5n-am\a0a4.nfo+nfo\5n-am\engine.nfo+nfo\5n-am\mus.nfo+nfo\5n-am\metro.nfo nfo\5.nfo
copy /Y nfo\6s-am\a0a4.nfo+nfo\6s-am\engine.nfo+nfo\6s-am\mus.nfo+nfo\6s-am\metro.nfo nfo\6.nfo
copy /Y nfo\7ocean\a0a4.nfo+nfo\7ocean\engine.nfo+nfo\7ocean\mus.nfo+nfo\7ocean\metro.nfo nfo\7.nfo
copy /Y nfo\8scandinavia\a0a4.nfo+nfo\8scandinavia\engine.nfo+nfo\8scandinavia\mus.nfo+nfo\8scandinavia\metro.nfo nfo\8.nfo
copy /Y nfo\9s-eu\a0a4.nfo+nfo\9s-eu\engine.nfo+nfo\9s-eu\mus.nfo+nfo\9s-eu\metro.nfo nfo\9.nfo
copy /Y nfo\10w-eu\a0a4.nfo+nfo\10w-eu\engine.nfo+nfo\10w-eu\mus.nfo+nfo\10w-eu\metro.nfo nfo\10.nfo
Echo on
copy /Y nfo\header.nfo+nfo\wagons.nfo+nfo\2.nfo+nfo\3.nfo+nfo\4.nfo+nfo\5.nfo+nfo\6.nfo+nfo\7.nfo+nfo\8.nfo+nfo\9.nfo+nfo\10.nfo+nfo\metrorail.nfo+nfo\regsel.nfo "Y:\grf\grf\2cc\sprites\2ccdj.nfo"

cd ..
ECHO Running NFORenum. . .
@ECHO ON
renum.exe -k  2ccdj.nfo
echo :) -w 42 -w 94 -w 141 -w 143 -w 144 -w 147 -w 170
@ECHO OFF
pause
ECHO.
ECHO Running GRFCodec. . .
@ECHO ON
grfcodec.exe -c -e -p 2 2ccdj.nfo.new.nfo
@ECHO OFF
ECHO.
ECHO Remove old file, rename new file and copy file to ottd and ttdp dirs. . .
DEL .\2ccdj.grf
ren 2ccdj.nfo.new.grf 2ccdj.grf
COPY .\2ccdj.grf "C:\Documents and Settings\bluser\Desktop\Privat\ottd\data" /Y

ECHO Done!
pause
exit