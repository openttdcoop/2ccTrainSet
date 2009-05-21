#!/bin/bash
# 
# Copy a existing language file with new ID
#
SOURCE="7F_english.nfo"

cd sprites/nfo/strings

if [ $# -eq 2 ]
then
	SOURCE=$1
	DEST=$2
else	
	if [ $1 ]
	then
		DEST=$1 
	else
		echo "Usage: $0 [source] dest
(if source is empty it will use $SOURCE)"
		exit
	fi
fi

SID=`echo "$SOURCE" | cut -d_ -f1`
DID=`echo "$DEST" | cut -d_ -f1`
GSID=`../../../scripts/lang.id2gen.sh $SID`
GDID=`../../../scripts/lang.id2gen.sh $DID`

echo "Source: $SOURCE ($SID)
Dest: $DEST ($DID)"
sed "s/ 00 $SID / 00 $DID /;s/ 00 $GSID / 00 $GDID /" "$SOURCE" > "$DEST"

cd ../../..

echo "$DEST made, you still need to hg add/ci/push ;-)"
