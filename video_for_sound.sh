#!/bin/sh

SOUND="$1"
SOUND_BASENAME=${SOUND%.*}
OUTPUT_TMP="${SOUND_BASENAME}_tmp.mkv"
OUTPUT_TMP_1="${SOUND_BASENAME}_tmp1.mkv"
OUTPUT_TMP_2="${SOUND_BASENAME}_tmp2.mkv"
OUTPUT_TMP_3="${SOUND_BASENAME}_tmp3.mkv"
OUTPUT="${SOUND_BASENAME}_video.mkv"

# vid 1

#ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]avectorscope=s=1280x720:m=lissajous_xy:draw=line:scale=log,format=yuv420p[v]" -map "[v]" -map 0:a "${OUTPUT_TMP_1}"
#ffmpeg -y -i "${SOUND}" -filter_complex "[0:a] aphasemeter=s=1280x720:mpc=cyan [a][v]" -map "[v]" -map 0:a "${OUTPUT_TMP_1}"
ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]ahistogram=s=1280x720,format=yuv420p[v]" -map "[v]" -map 0:a "${OUTPUT_TMP_1}"

# vid 2

ffmpeg -y -i "${SOUND}" -filter_complex "[0:a]showwaves=s=1280x720:mode=line:rate=25,format=yuv420p[v]" -map "[v]" -map 0:a "${OUTPUT_TMP_2}"

# merge 1 & 2

ffmpeg -y -i "${OUTPUT_TMP_1}" -i "${OUTPUT_TMP_2}" -filter_complex '[1:v]colorkey=0x000000:0.3:0.2[ckout];[0:v][ckout]overlay[out]' -map '[out]' "${OUTPUT_TMP}"

# final vid (add noise and compress)

ffmpeg -y -i "${SOUND}" -i "${OUTPUT_TMP}" -codec:v huffyuv -bsf:v noise=5000000 "${OUTPUT_TMP_3}"
ffmpeg -y -i "${OUTPUT_TMP_3}" "${OUTPUT}"

# upload

youtube-upload --title "${SOUND_BASENAME} (GMV)" --category=Music --tags="gmv, music, experimental music" --playlist "My Music (GMV)" --client-secrets=$HOME/yt_client_secret.com.json  "${OUTPUT}"

# cleanup

rm "${OUTPUT_TMP}" "${OUTPUT_TMP_1}" "${OUTPUT_TMP_2}" "${OUTPUT_TMP_3}"
