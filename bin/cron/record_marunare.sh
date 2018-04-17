#!/bin/bash

PATH=$PATH:~/bin

readonly OUTPUT="$HOME/Downloads/maru.$(date "+%y%m%d").flv"

agrec 1 "${OUTPUT}" | slk -w home -c 1091
