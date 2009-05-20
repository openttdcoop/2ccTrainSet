#!/bin/bash
#
# checks all files against $SOURCE

SOURCE="7F_english.nfo"

function count {
# $1	file
	echo "---------------------------------"
	echo "File $1"
	ID=`echo $1 | cut -d_ -f1`
	echo "Lang code: $ID"
	echo "rows: `cat $1 | wc -l`"
	echo "Action4: `cat $1 | grep " 04 00 " | wc -l`"
	echo "Translated: `cat $1 | grep " 00 $ID " | wc -l`"
}

count $SOURCE

for i in `ls -1 *.nfo | grep -v $SOURCE`
do
	count $i	
done