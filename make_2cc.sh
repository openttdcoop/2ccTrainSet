#!/bin/sh
#
rm sprites/2cc*.nfo*
rm sprites/nfo/strings.nfo

region_dirs="2africa 3asia 4e-eu 5n-am 6s-am 7ocean 8scandinavia 9s-eu 10w-eu"
lang_dir="strings"

echo Compiling files to one .nfo
cd ./sprites/nfo
for i in $region_dirs
do
	cat $i/*nfo > $i.nfo
done
cat $lang_dir/*.nfo > $lang_dir.nfo

cat *.nfo > ../2cc_trainset.nfo
cd ../..
sed -i -f scripts/nfo.sed sprites/2cc_trainset.nfo

echo "Using repository version:" > renum.log
hg tip | grep 'changeset' | tee -a renum.log
renum -w 141 2cc_trainset.nfo | tee -a renum.log
echo Running GRFCodec. . .
grfcodec -e -p 2 2cc_trainset.grf | tee grfcodec.log
