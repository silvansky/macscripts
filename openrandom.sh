#/bin/sh

FILE=`find . | randstr`
echo Opening $FILE
open $FILE