#!/bin/sh

SOUND="$1"
SOUND_BASENAME=${SOUND%.*}

IMAGE="$2"
IMAGE_EXT="${IMAGE##*.}"
IMAGE_BASENAME=${IMAGE%.*}
RESIZED_IMAGE="${IMAGE_BASENAME}_tmp_resized.jpg"
REVERSED_IMAGE="${IMAGE_BASENAME}_rev.mp4"
BOUNCE_IMAGE="${IMAGE_BASENAME}_bounce.mp4"

OUTPUT_TMP="${SOUND_BASENAME}_tmp.mkv"
OUTPUT_TMP_1="${SOUND_BASENAME}_tmp1.mkv"
OUTPUT="${SOUND_BASENAME}_video.mkv"
PRIVACY="unlisted" # (public | unlisted | private) 

function prepare_vid() {
	ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]showspectrum=s=1920x1080:mode=combined:win_func=hann:color=fiery:slide=scroll:legend=0:scale=sqrt:saturation=5:gain=2:fscale=lin,format=yuv420p[v]" -map "[v]" -map 0:a -b:v 700k "${OUTPUT_TMP}"
}

function add_image_overlay() {
	convert "${IMAGE}" -resize 1080x1080 "${RESIZED_IMAGE}"
	ffmpeg -i "${OUTPUT_TMP}" -i "${RESIZED_IMAGE}" -filter_complex "[0:v][1:v] overlay=0:0'" -pix_fmt yuv420p -c:a copy "${OUTPUT_TMP_1}"
}

function add_video_overlay() {
	ffmpeg -y -i "${IMAGE}" -vf reverse "${REVERSED_IMAGE}"

	ffmpeg -y -i "${IMAGE}" -i "${REVERSED_IMAGE}" \
		-filter_complex "[0:v] [1:v] \
		concat=n=2:v=1 [v]" \
		-map "[v]" "${BOUNCE_IMAGE}"


	ffmpeg -y -i "${OUTPUT_TMP}" \
	    -stream_loop -1 -i "${BOUNCE_IMAGE}" \
	    -filter_complex \
	    "[1:v]scale=1080:-1[tmp];[0][tmp]overlay=shortest=1:x=0:y=0" \
	    -c:a copy "${OUTPUT_TMP_1}"
}

function compress_vid() {
	ffmpeg -y -i "${OUTPUT_TMP_1}" -codec:a copy "${OUTPUT}"
}

function upload_vid() {
	# https://github.com/tokland/youtube-upload
	youtube-upload --title "${SOUND_BASENAME} (GMV)" -d "More: https://t.me/silvansky_music" --category=Music --tags="gmv, music, experimental music" --playlist "My Music (GMV)" --client-secrets=$HOME/yt_client_secret.com.json --privacy $PRIVACY "${OUTPUT}"
}

function cleanup() {
	rm "${OUTPUT_TMP}" "${OUTPUT_TMP_1}" "${RESIZED_IMAGE}"
}

if [ "$2" = "--upload-only" ]
then
	upload_vid
	exit 0
fi

if [ "$2" = "--skip-upload" ]
then
	prepare_vid
	exit 0
fi

prepare_vid

if [ -f "${IMAGE}" ]; then
	echo "Adding overlay: ${IMAGE}"
	if [ "${IMAGE_EXT}" = "mp4" ]; then
		add_video_overlay
	else
		add_image_overlay
	fi
else
	mv "${OUTPUT_TMP}" "${OUTPUT_TMP_1}"
fi

# making final vid (add noise and compress)
compress_vid

# upload
upload_vid

# cleanup
cleanup

