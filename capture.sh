#!/bin/bash
while true; do
CAPTURE_FILE_NAME=`date "+%Y_%m_%d_%H%M%S.jpg"`
screencapture $CAPTURE_FILE_NAME
sleep 2
done
exit 0
