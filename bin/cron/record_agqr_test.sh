#!/bin/bash

PATH="$PATH:~/bin"

readonly OUTPUT="/tmp/agqr.$(date '+%y%m%d.%H%M%S').flv"

agrec 5 "${OUTPUT}" 3>&1 1>/dev/null 2>&3 | slk -w "$1" -c "$2"
