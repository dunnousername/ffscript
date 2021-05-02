#!/bin/sh

# will anyone even use this?

WIDTH=`ffprobe -v quiet -show_entries stream=width -of csv="p=0" "$2"` || exit 1
HEIGHT=`ffprobe -v quiet -show_entries stream=height -of csv="p=0" "$2"` || exit 1
WIDTH3=`expr $WIDTH \* 3`
HEIGHT3=`expr $HEIGHT \* 3`
WIDTHDIV2=`expr $WIDTH / 2`
HEIGHTDIV2=`expr $HEIGHT / 2`

ffmpeg -loglevel error -hide_banner -i "$2" "$1/1.$3"
ffmpeg -loglevel error -hide_banner -i "$2" -filter_complex "[0]split[1][2];[1][2]hstack" "$1/2.$3"
ffmpeg -loglevel error -hide_banner -i "$2" -filter_complex "[0]split=3[1][2][3];[1][2][3]hstack=3" "$1/3.$3"
ffmpeg -loglevel error -hide_banner -i "$1/2.$3" -filter_complex "[0]split[1][2];[1][2]vstack" "$1/4.$3"
ffmpeg -loglevel error -hide_banner -i "$1/2.$3" -i "$1/3.$3" -filter_complex "[0]pad=x=$WIDTHDIV2:width=$WIDTH3[2];[1][2]vstack" "$1/5.$3"
ffmpeg -loglevel error -hide_banner -i "$1/3.$3" -filter_complex "[0]split[1][2];[1][2]vstack" "$1/6.$3"
ffmpeg -loglevel error -hide_banner -i "$1/2.$3" -i "$1/3.$3" -filter_complex "[0]pad=x=$WIDTHDIV2:width=$WIDTH3[2];[2]split[3][4];[3][1][4]vstack=3" "$1/7.$3"
ffmpeg -loglevel error -hide_banner -i "$1/2.$3" -i "$1/3.$3" -filter_complex "[0]pad=x=$WIDTHDIV2:width=$WIDTH3[2];[1]split[3][4];[3][2][4]vstack=3" "$1/8.$3"
ffmpeg -loglevel error -hide_banner -i "$1/3.$3" -filter_complex "[0]split=3[1][2][3];[1][2][3]vstack=3" "$1/9.$3"
ffmpeg -loglevel error -hide_banner -i "$1/2.$3" -i "$1/3.$3" -filter_complex "[0]pad=x=$WIDTHDIV2:width=$WIDTH3[2];[2]split[3][4];[1]split[5][6];[3][5][6][4]vstack=4" "$1/10.$3"
