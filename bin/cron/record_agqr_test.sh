#!/bin/bash

PATH="$PATH:~/bin"

readonly OUTPUT="/tmp/agqr.$(date '+%y%m%d.%H%M%S').flv"

agrec 5 "${OUTPUT}" | slk -w "$1" -c "$2"
