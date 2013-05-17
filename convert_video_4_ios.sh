#!/bin/sh

FILES=$@

for F in $FILES; do
	BASENAME="${F%.*}"
	ffmpeg -i $F -acodec libfaac -ab 128k -vcodec mpeg4 -b:v 1200k -mbd 2 -ac 2 -cmp 2 -subcmp 2 -metadata title="$BASENAME" $BASENAME.mp4
done;
