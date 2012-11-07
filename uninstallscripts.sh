#!/bin/sh

. ./installable.sh

for S in ${SCRIPTS}; do
	SC=${S%.*}
	rm -f ${DEST}/${SC}
done
