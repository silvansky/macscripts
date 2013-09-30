#!/bin/sh

USERNAME=$1

if [ "$USERNAME" == "" ]; then
	USERNAME="silvansky"
fi

RESPONSE=$(curl -s "http://habrahabr.ru/api/profile/$USERNAME/")

ERROR=$(echo $RESPONSE | grep "<error>")

if [ "$ERROR" != "" ]; then
	echo "Not found!"
	exit 1;
fi

RAW=$(echo $RESPONSE | xmllint - | sed -ne 's/<[^>]\{1,\}>//gp')

KARMA=$(echo $RAW | cut -d ' ' -f 2)
RATING=$(echo $RAW | cut -d ' ' -f 3)
POSITION=$(echo $RAW | cut -d ' ' -f 4)

echo "User:     $USERNAME"
echo "Karma:    $KARMA"
echo "Rating:   $RATING"
echo "Position: $POSITION"
