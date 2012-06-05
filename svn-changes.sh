#!/bin/sh

# svn-changes script by V. Silvansky <v.silvansky@gmail.com>
# WARNING: needs diff2html.py script in /usr/local/
# you can download it at http://wiki.droids-corp.org/index.php/Diff2html

KEY=$1
DIFF_ARGS=""
DIFF2HTML=diff2html.py
DIFF2HTML_PATH=/usr/local
REPORT_PATH=/tmp/svn-changes-report-`date "+%Y-%m-%dT%H:%M:%S"`.html

if [ "$KEY" == "head" ]
then
	DIFF_ARGS="-r BASE:HEAD"
elif [ "$KEY" == "-r" ]
then
	DIFF_ARGS="-r BASE:$2"
fi

# echo "svn diff ${DIFF_ARGS}"

if [ ! -e ${DIFF2HTML_PATH}/${DIFF2HTML} ]
then
	echo "${DIFF2HTML} not found! It must be placed in ${DIFF2HTML_PATH}"
	exit 1
fi

svn diff ${DIFF_ARGS} | python ${DIFF2HTML_PATH}/${DIFF2HTML} > ${REPORT_PATH}

FSIZE=`stat -f "%z" ${REPORT_PATH}`
echo "Report file ${REPORT_PATH} created! File size is $FSIZE"

open ${REPORT_PATH}
