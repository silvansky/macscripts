#!/bin/sh

# parsing args

SIZE_ARG=""
SPEED_ARG=""
INPUT_FILE=""

VERSION_SHORT="1.0"
VERSION_LONG="$0 version ${VERSION_SHORT}
Original name: togif.sh
Copyright (c): 2013 Valentine Silvansky <v.silvansky@gmail.com>"

LICENSE="This software is distibuted under GNU GPLv3 license.
Visit http://www.gnu.org/licenses/gpl-3.0.txt for more information."

HELP="Usage:
  $0 [options...] video_file_name
  $0 -v
  $0 -h

 Available options:
  -s <WIDTHxHEIGHT>		Specify output gif width and height. If not specified, gif frame size is the same as source video's.
  -x <rate>				Specify duration rate. For example, -x 0.5 causes gif to be double speed. If not specified, no speed correction is made.
  -v					Print version and copyright notice and exit.
  -h					Print this help message and exit.
  -l					Print license info and exit."

while getopts ":x:s:vhl" opt; do
	case $opt in
		x)
			SPEED_ARG="-filter:v setpts=$OPTARG*PTS "
			;;
		s)
			SIZE_ARG="-s $OPTARG "
			;;
		v)
			echo "$VERSION_LONG"
			exit 0
			;;
		h)
			echo "$HELP"
			exit 0
			;;
		l)
			echo "$LICENSE"
			exit 0
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument."
			exit 1
			;;
	esac
done

shift $(($OPTIND - 1))

ARGS=$*
set -- $ARGS

INPUT_FILE="$@"

if [ "${INPUT_FILE}" == "" ]; then
	echo "${HELP}"
	exit 1
fi

FILE_BASE_NAME="${INPUT_FILE%.*}"
TMP_FILE="${FILE_BASE_NAME}_tmp.gif"
OUTPUT_FILE="${FILE_BASE_NAME}.gif"

rm -f $TMP_FILE

# step 0: printing info
printf "Input file: \e[01;32m${INPUT_FILE}\e[00m, info:\n"
ffprobe ${INPUT_FILE} 2>&1 | egrep "Stream|Duration"

# step 1: convert to gif
printf "Converting to gif... "
ffmpeg_cmd="ffmpeg -loglevel panic -i $INPUT_FILE -pix_fmt rgb24 $SIZE_ARG$SPEED_ARG$TMP_FILE"
$($ffmpeg_cmd)

printf "done!\n"

rm -f ${base}.gif

# step 2: optimization
printf "Optimizing... "
convert -layers Optimize "$TMP_FILE" "${OUTPUT_FILE}"

printf "done!\n"

# step 3: remove tmp file
rm -f $TMP_FILE

printf "GIF generated! \e[01;32m$OUTPUT_FILE\e[00m\n"
