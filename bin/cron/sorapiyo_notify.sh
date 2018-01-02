#!/bin/bash

PATH=$PATH:~/bin

to_json() {
  if [ -p /dev/stdin ]; then
    echo T:$(date) >> ~/Desktop/sorapiyo.log
    local piyo="$(cat -)"
    [ -z ${piyo} ] && exit 1

    echo piyo=$(piyo) >> ~/Desktop/sorapiyo.log
    local date="$(echo "${piyo}" | grep -oP '(?<=^date ).*')"
    local time="$(echo "${piyo}" | grep -oP '(?<=^time ).*')"
    local messages="$(echo "${piyo}" | grep -oP '(?<=^message ).*')"
    local images="$(echo "${piyo}"   | grep -oP '(?<=^image ).*' | awk 'NF > 0 {printf("{\"image_url\": \"%s\"}", $0)}' | paste -s -d,)"
    cat <<EOF
{
  "channel": "#1091",
  "username": "そらぴよ⊂(＾ω＾)⊃",
  "text": "${messages}\n<http://piyo.fc2.com/soramaru/|${date} ${time}>",
  "attachments": [
    ${images}
  ]
}
EOF
  fi
}

{
  xsorapiyo -d ~/.sorapiyo \
    | to_json \
    | tee ~/Desktop/sorapiyo.json \
    | slk -j
} >/dev/null

