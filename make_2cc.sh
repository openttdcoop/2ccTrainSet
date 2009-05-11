#!/bin/sh
#

Echo Compiling files to one .nfo
cd sprites/nfo
cd 2africa
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../2.nfo
cd ../3asia
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../3.nfo
cd ../4e-eu
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../4.nfo
cd ../5n-am
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../5.nfo
cd ../6s-am
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../6.nfo
cd ../7ocean
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../7.nfo
cd ../8scandinavia
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../8.nfo
cd ../9s-eu
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../9.nfo
cd ../10w-eu
cat a0a4.nfo engine.nfo mus.nfo metro.nfo > ../A.nfo
cd ..
cat header.nfo wagons.nfo 2.nfo 3.nfo 4.nfo 5.nfo 6.nfo 7.nfo 8.nfo 9.nfo A.nfo metrorail.nfo regsel.nfo > ../2cc.nfo

cd ../..
renum -k 2cc.nfo
ECHO Running GRFCodec. . .
grfcodec -c -e -p 2 2cc.nfo