#!/bin/sh
SRT=`mktemp -t XXXXXXXXXX.srt` || exit 1
cat > "$SRT" << end
0
00:00:00,000 --> 99:59:59,999
end
cat "$3" >> "$SRT"

ffmpeg -i "$2" -vf "subtitles='$SRT':force_style='fontsize=${FONTSIZE:-48}'" "$1"

rm "$SRT"