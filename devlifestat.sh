#!/bin/sh

USERNAME=$1

if [ "$USERNAME" == "" ]; then
	USERNAME="silvansky"
fi

RESPONSE=$(curl -s http://developerslife.ru/profile/$USERNAME | grep "<div class=\"code\"><span class=\"title\">rating</span>:<span class=\"value rating bolder\">" | head -n 1)

RATING=$(echo $RESPONSE | sed -ne 's/<[^>]\{1,\}>//gp' | cut -d ':' -f 2 | cut -d ',' -f 1)

echo "User:   $USERNAME"
echo "Rating: $RATING"
