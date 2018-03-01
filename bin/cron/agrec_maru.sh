#!/bin/bash

PATH=$PATH:~/bin

readonly OUTPUT=~/Downloads/maru.$(date '+%y%m%d').flv

agrec 30 $OUTPUT | slk -c 1091 >/dev/null
