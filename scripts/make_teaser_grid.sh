#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 8 ]; then
  echo "Usage: $0 <tl_file> <tl_label> <tr_file> <tr_label> <bl_file> <bl_label> <br_file> <br_label> [output_path]"
  echo "Example:"
  echo "  \$0 \"static/videos/sprac_train_17.mp4\" \"Sparc\" \"static/videos/ours_train_17.mp4\" \"Ours\" \"static/videos/dpft seq17_train.mp4\" \"DPFT\" \"static/videos/gt_train_17.mp4\" \"ground truth\""
  exit 1
fi

cd "$(dirname "$0")/.."

TL_FILE=$1; TL_LABEL=$2
TR_FILE=$3; TR_LABEL=$4
BL_FILE=$5; BL_LABEL=$6
BR_FILE=$7; BR_LABEL=$8
OUT=${9:-static/videos/teaser_grid.mp4}

FFMPEG=/snap/bin/ffmpeg
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

label() {
  echo "drawtext=fontfile=${FONT}:text='$1':fontsize=20:fontcolor=white:box=1:boxcolor=black@0.6:boxborderw=6:x=(w-text_w)/2:y=h-text_h-14"
}

"$FFMPEG" -y \
  -i "$TL_FILE" \
  -i "$TR_FILE" \
  -i "$BL_FILE" \
  -i "$BR_FILE" \
  -filter_complex "
    [0:v]scale=640:360,$(label "$TL_LABEL")[tl];
    [1:v]scale=640:360,$(label "$TR_LABEL")[tr];
    [2:v]scale=640:360,$(label "$BL_LABEL")[bl];
    [3:v]scale=640:360,$(label "$BR_LABEL")[br];
    [tl][tr][bl][br]xstack=inputs=4:layout=0_0|w0_0|0_h0|w0_h0[outv]
  " \
  -map "[outv]" -an \
  -c:v libx264 -preset slow -crf 23 -pix_fmt yuv420p -movflags +faststart \
  "$OUT"

echo "Wrote $OUT"
