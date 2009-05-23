#!/bin/bash
#
# Replaces the {{LID}} and {{HLID}} with their
# respective numbers
#
LANG_ID_STRING		= {{LID}}
HIGH_LANG_ID_STRING = {{HLID}}
LANG_EXT			= lang
NFO_EXT				= test

cd sprites/nfo/strings

for i in `ls -1 *.$LANG_EXT`
do
	echo "File $i"
	LID=`echo $i | cut -d_ -f1`
	NFO=`echo $i | cut -d. -f1`.$NFO_EXT
	echo "Parsing $NFO"
	HLID=`../../../scripts/lang.id2gen.sh "$LID"`
	cat $i | sed s/$LANG_ID_STRING/$LID/ | sed s/$HIGH_LANG_ID_STRING/$HLID/ > $NFO
done

cd ../../..