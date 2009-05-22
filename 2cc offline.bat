echo  @ECHO OFF
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
"C:\Program Files\GnuWin32\bin\sed.exe" -f ..\scripts\nfo.sed 2cc_trainset.nfo.pre > 2cc_trainset.nfo
del 2cc_trainset.nfo.pre
pause
cd ..
ECHO Running NFORenum. . .
@ECHO ON
renum.exe -k -w 42,94,141,143,144,147,17 2cc_trainset.nfo
echo :) -w 42 -w 94 -w 141 -w 143 -w 144 -w 147 -w 170
@ECHO OFF
pause
ECHO.
ECHO Running GRFCodec. . .
@ECHO ON
grfcodec.exe -e -p 2 2cc_trainset.nfo.new.nfo
@ECHO OFF
ECHO.
ECHO Remove old file, rename new file and copy file to ottd and ttdp dirs. . .
DEL .\2cc_trainset.grf
ren 2cc_trainset.nfo.new.new.new 2cc_trainset.grf
COPY .\2cc_trainset.grf "C:\data\OpenTTD\data" /Y

ECHO Done!
pause
