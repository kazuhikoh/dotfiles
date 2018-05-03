#!/bin/bash

PATH=$PATH:~/bin

readonly OUTPUT="$HOME/Downloads/maru.$(date "+%y%m%d").flv"

agrec 1800 "${OUTPUT}" | slk -w "$1" -c "$2"
