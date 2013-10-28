#!/bin/sh

SEARCH_PATH="${1}"

if [ "${SEARCH_PATH}" == "" ]; then
	SEARCH_PATH="."
fi

function process_item()
{
	ITEM="$1"
	if [ "${ITEM}" == "" ]; then
		echo "ERROR"
		exit 0
	fi
	# size in blocks
	ITEM_SIZE=$(du -s "${ITEM}" | cut -f 1)
	# block size for du is 512 bytes
	let ITEM_SIZE=${ITEM_SIZE}*512
	# human readable size
	ITEM_SIZE_HR=$(awk -v sum="$ITEM_SIZE" ' BEGIN {hum[1024^3]="Gb"; hum[1024^2]="Mb"; hum[1024]="Kb"; for (x=1024^3; x>=1024; x/=1024) { if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x]; break; } } if (sum<1024) print "< 1 Kb"; } ')
	# result
	printf "${ITEM_SIZE} (${ITEM_SIZE_HR})\t\t${ITEM}\n"
}

export -f process_item

find "${SEARCH_PATH}" -d 1 -exec bash -c 'process_item "${0}"' {} \; | sort -rn -k1
