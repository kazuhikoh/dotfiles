#!/bin/bash

PATH=$PATH:~/bin

readonly OUTPUT="$HOME/Downloads/marunare.$(date "+%Y%m%d").archive.mp4"

{ hibikiradio download -t sora "${OUTPUT}"; ls -lh "${OUTPUT}"; } | slk -w "$1" -c "$2"
