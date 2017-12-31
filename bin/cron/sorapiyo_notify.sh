#!/bin/bash

PATH=$PATH:~/bin

{
  xsorapiyo -d ~/.sorapiyo \
    | grep -oP '(?<=^message ).*' \
    | slk -c '#1091'
} >/dev/null

