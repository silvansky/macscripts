#!/bin/sh

. ./installable.sh

for S in ${SCRIPTS}; do
	SC=${S%.*}
	ln -s -f ${PWD}/${S} ${DEST}/${SC}
done
