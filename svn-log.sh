#!/bin/sh

KEY=$1
LOG_ARGS=""

if [ "$KEY" == "-r" ]
then
	LOG_ARGS="${LOG_ARGS} -r BASE:$2"
elif [ "$KEY" == "head" ]
then
	LOG_ARGS="${LOG_ARGS} -r BASE:HEAD"
fi

svn log ${LOG_ARGS}
