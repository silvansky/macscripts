#!/bin/sh

##
## test_run.sh
##

exectable=$1
limit=$2
count=0
code=0

if [ "$exectable" = "" ]; then
	echo "Specify exectable, please!"
fi;

if [ "$limit" = "" ]; then
	limit=100
fi;

echo "Testing $exectable, run limit $limit"

while [ "$code" = "0" -a $count -lt $limit ]; do
	echo "run #$count"
	output="output_$count.txt"
	$exectable &> "$output"
	code=$?
	let count=$count+1
done;
