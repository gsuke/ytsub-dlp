#!/bin/sh
set -eu

usage() {
    cat <<EOF
ytsub-dlp - YouTubeからテキスト部分のみの字幕をダウンロード

Usage:
  ytsub-dlp <YouTubeURL>

Requirements:
  yt-dlp
  subx
EOF
}

if [ "$#" -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
    exit 0
fi

URL="$1"

# 依存コマンドの存在確認
command -v yt-dlp >/dev/null 2>&1 || { echo "Error: yt-dlp が未導入" >&2; exit 1; }
command -v subx >/dev/null 2>&1 || { echo "Error: subx が未導入" >&2; exit 1; }

# 一時ファイル名のPrefix
PREFIX="/tmp/$(date +%s)_$$"

# 割り込み時クリーンアップ
trap 'rm -f "${PREFIX}.ja.srt" "${PREFIX}.err" 2>/dev/null; exit' INT TERM HUP

# 字幕ダウンロード
yt-dlp -q --skip-download --write-auto-subs --sub-lang ja --sub-format srt -o "$PREFIX" "$URL" 2>"${PREFIX}.err"
SRT_FILE="${PREFIX}.ja.srt"

# SRTファイルの存在確認
if [ ! -f "$SRT_FILE" ]; then
    echo "Error: 字幕ファイルのダウンロードに失敗" >&2
    cat "${PREFIX}.err" >&2
    exit 1
fi

# SRTファイルが空かを確認
if [ ! -s "$SRT_FILE" ]; then
    echo "Error: 字幕ファイルが空" >&2
    cat "${PREFIX}.err" >&2
    rm -f "$SRT_FILE" "${PREFIX}.err"
    exit 1
fi

# subxでの変換 → 出力
subx "$SRT_FILE"

# 正常終了時クリーンアップ
rm -f "$SRT_FILE" "${PREFIX}.err"
