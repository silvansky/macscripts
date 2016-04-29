#!/bin/sh

SLOWDOWN_FACTOR=10
KEEP_TMP_FILES=false

while getopts ":s:k" opt; do
	case $opt in
		s)
			SLOWDOWN_FACTOR=$OPTARG
			;;
		k)
			KEEP_TMP_FILES=true
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			exit 1
			;;
		:)
			echo "Error! Option -$OPTARG requires an argument."
			exit 1
			;;
	esac
done

shift $(($OPTIND - 1))

if [ -z "$1" ]; then
	echo "Usage: $0 [-s factor] [-k] video_file"
	echo "    -s <factor>    Set slowdown factor. Default is ${SLOWDOWN_FACTOR}."
	echo "    -k             Keep temporary files."
	exit 1
fi

VIDEO="$1"

if [ ! -f "${VIDEO}" ]; then
	echo "File ${VIDEO} not found!"
	exit 1
fi

echo "Slowdown factor is ${SLOWDOWN_FACTOR}"
echo "\nTools output is below...\n\n"

SPEED_FACTOR=`echo "print 1./${SLOWDOWN_FACTOR}" | python`

BASENAME="${VIDEO%.*}"
VIDEO_SLOMO_TMP="${BASENAME}_slomo_tmp.mp4"
VIDEO_SLOMO="${BASENAME}_slomo.mp4"
AUDIO_FILE="${BASENAME}.mp3"
AUDIO_FILE_SLOW="${BASENAME}_slow.mp3"

# extract audio
ffmpeg -i "${VIDEO}" -y "${AUDIO_FILE}"

# slowdown audio
sox "${AUDIO_FILE}" "${AUDIO_FILE_SLOW}" speed ${SPEED_FACTOR} rate 48k reverb

# slowdown video
ffmpeg -i "${VIDEO}" -filter:v "setpts=${SLOWDOWN_FACTOR}.0*PTS" -an -y "${VIDEO_SLOMO_TMP}"

# join files
ffmpeg -i "${AUDIO_FILE_SLOW}" -i "${VIDEO_SLOMO_TMP}" -c:v copy -y "${VIDEO_SLOMO}"

if [ "${KEEP_TMP_FILES}" = false ]; then
	echo "\nDeleting temporary files"
	rm -f "${VIDEO_SLOMO_TMP}" "${AUDIO_FILE}" "${AUDIO_FILE_SLOW}"
fi

echo "\nDone! Slow motion video is saved to ${VIDEO_SLOMO}."
