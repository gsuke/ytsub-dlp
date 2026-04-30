# ytsub-dlp

YouTubeからテキスト部分のみの字幕をダウンロードする。

## Requirements

* [yt-dlp](https://github.com/yt-dlp/yt-dlp): `paru -S yt-dlp`
* [subx](https://github.com/gsuke/subx): `go install github.com/gsuke/subx@latest`

## Install

```sh
ln -snfv "$(realpath ytsub-dlp)" "$HOME/.local/bin/ytsub-dlp"
```

## Usage

```sh
ytsub-dlp <YouTubeURL>
```
