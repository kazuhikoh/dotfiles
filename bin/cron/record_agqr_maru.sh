#!/bin/bash

PATH=$PATH:~/bin

readonly OUTPUT="$HOME/Downloads/marunare.$(date "+%Y%m%d").live.flv"

agrec 1800 "${OUTPUT}" | slk -w "$1" -c "$2"
