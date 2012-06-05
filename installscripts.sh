#!/bin/sh

SCRIPTS="openrandom.sh svn-changes.sh svn-log.sh"
DEST=/usr/local/bin

for S in $SCRIPTS; do
	cp $S ${DEST}/
done
