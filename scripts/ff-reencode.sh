#!/bin/sh

VLENGTH=`ffprobe -v quiet -show_entries format=duration -of csv="p=0" "$2"` || exit 1

BITRATE=`echo "8*$3/($VLENGTH + 1)" | bc`

STATS=`mktemp` || exit 1

ffmpeg -y -i "$2" -c:v libx264 -b:v "${BITRATE}K" -maxrate "${BITRATE}K" -bufsize 1M -pass 1 -x264opts stats=stats.txt -x264opts "stats=$STATS" -f mp4 /dev/null
ffmpeg -y -i "$2" -c:v libx264 -b:v "${BITRATE}K" -maxrate "${BITRATE}K" -bufsize 1M -pass 2 -x264opts stats=stats.txt -x264opts "stats=$STATS" "$1"

rm "$STATS" "$STATS.mbtree"