#!/bin/sh
#
rm sprites/2cc*.nfo*
rm sprites/nfo/??.nfo

echo Compiling files to one .nfo
cd sprites/nfo
cat 2africa/*.nfo > ./02.nfo
cat 3asia/*.nfo > ./03.nfo
cat 4e-eu/*.nfo > ./04.nfo
cat 5n-am/*.nfo > ./05.nfo
cat 6s-am/*.nfo > ./06.nfo
cat 7ocean/*.nfo > ./07.nfo
cat 8scandinavia/*.nfo > ./08.nfo
cat 9s-eu/*.nfo > ./09.nfo
cat 10w-eu/*.nfo > ./10.nfo

cat *.nfo > ../2ccdj.nfo

cd ../..
renum -w 42,94,141,143,144,147,17 2ccdj.nfo
echo Running GRFCodec. . .
grfcodec -c -e -p 2 2ccdj.grf
