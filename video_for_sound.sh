#!/bin/sh

SOUND="$1"
SOUND_BASENAME=${SOUND%.*}
OUTPUT_TMP="${SOUND_BASENAME}_tmp.mkv"
OUTPUT_TMP_1="${SOUND_BASENAME}_tmp1.mkv"
OUTPUT_TMP_2="${SOUND_BASENAME}_tmp2.mkv"
OUTPUT_TMP_3="${SOUND_BASENAME}_tmp3.mkv"
OUTPUT="${SOUND_BASENAME}_video.mkv"

function prepare_vid_1() {
	#ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]avectorscope=s=1280x720:m=lissajous_xy:draw=line:scale=log,format=yuv420p[v]" -map "[v]" -map 0:a "${OUTPUT_TMP_1}"
	#ffmpeg -y -i "${SOUND}" -filter_complex "[0:a] aphasemeter=s=1280x720:mpc=cyan [a][v]" -map "[v]" -map 0:a "${OUTPUT_TMP_1}"
	#ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]ahistogram=s=1280x720,format=yuv420p[v]" -map "[v]" -map 0:a "${OUTPUT_TMP_1}"
	ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]showspectrum=s=1280x720:mode=combined:win_func=hann:color=fiery:slide=scroll:legend=0:scale=sqrt:saturation=5:gain=2:fscale=lin,format=yuv420p[v]" -map "[v]" -map 0:a -b:v 700k -b:a 360k "${OUTPUT_TMP}"
}

function prepare_vid_2() {
	ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]showwaves=s=1280x720:mode=line:rate=25,format=yuv420p[v]" -map "[v]" -map 0:a "${OUTPUT_TMP_2}"
}

function merge_vid_1_2() {
	ffmpeg -y -i "${OUTPUT_TMP_1}" -i "${OUTPUT_TMP_2}" -filter_complex '[1:v]colorkey=0x000000:0.3:0.2[ckout];[0:v][ckout]overlay[out]' -map '[out]' "${OUTPUT_TMP}"
}

function add_noise() {
	ffmpeg -y -i "${SOUND}" -i "${OUTPUT_TMP}" -codec:a aac -b:a 256k -codec:v huffyuv -bsf:v noise=5000000 "${OUTPUT_TMP_3}"
}

function compress_vid() {
	ffmpeg -y -i "${OUTPUT_TMP}" -codec:a copy "${OUTPUT}"
}

function upload_vid() {
	youtube-upload --title "${SOUND_BASENAME} (GMV)" -d "More: https://t.me/silvansky_music" --category=Music --tags="gmv, music, experimental music" --playlist "My Music (GMV)" --client-secrets=$HOME/yt_client_secret.com.json  "${OUTPUT}"
}

function cleanup() {
	rm "${OUTPUT_TMP}" "${OUTPUT_TMP_1}" "${OUTPUT_TMP_2}" "${OUTPUT_TMP_3}"
}

if [ "$2" = "--upload-only" ]
then
	upload_vid
	exit 0
fi

if [ "$2" = "--skip-upload" ]
then
	prepare_vid_1
	exit 0
fi

# vid 1
prepare_vid_1

# vid 2
#prepare_vid_2

# merge 1 & 2
#merge_vid_1_2

# making final vid (add noise and compress)
#add_noise
compress_vid

# upload
upload_vid

# cleanup
cleanup

