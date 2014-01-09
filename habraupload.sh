#!/bin/sh

curl -F "Filedata=@$1" "http://habrastorage.org/uploadController/?username=silvansky&userkey=${HABR_USER_KEY}"  | json_pp | grep url | awk -F '"' '{print $4}'