#!/usr/bin/env bash

[[ -z "$1" || ! -e "$1" ]] && {
  echo 'please give a video file to recode to libvpx-vp9'
  exit 1
}

ffmpeg -i "$1" -c:v libvpx-vp9 -c:a libopus "$(date +"%Y%m%d%H%M%S").webm"
