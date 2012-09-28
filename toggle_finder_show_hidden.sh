#!/bin/bash

if [ "$1" ]; then
	ARG=$1
else
	CURRENT_STATE=`defaults read com.apple.finder AppleShowAllFiles`
	if [ "${CURRENT_STATE}" == "TRUE" ]; then
		ARG="FALSE"
	else
		ARG="TRUE"
	fi
fi 

defaults write com.apple.finder AppleShowAllFiles $ARG
killall Finder
