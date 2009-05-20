#!/bin/bash
# 
# Copy a existing language file with new ID
#
SOURCE="7F_english.nfo"

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

echo "Source: $SOURCE ($SID)
Dest: $DEST ($DID)"
sed "s/ 00 $SID / 00 $DID /" "$SOURCE" > "$DEST"

echo "$DEST made, you still need to hg add/ci/push ;-)"
