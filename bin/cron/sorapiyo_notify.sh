#!/bin/bash

PATH=$PATH:~/bin

readonly SLACK_WEBHOOK_ID="$1"
readonly SLACK_CHANNEL="$2"

to_json() {
  if [ -p /dev/stdin ]; then
    local piyo="$(cat -)"
    [ -z ${piyo} ] && exit 1

    local date="$(echo "${piyo}" | grep -oP '(?<=^date ).*')"
    local time="$(echo "${piyo}" | grep -oP '(?<=^time ).*')"
    local messages="$(echo "${piyo}" | grep -oP '(?<=^message ).*')"
    local images="$(echo "${piyo}"   | grep -oP '(?<=^image ).*' | awk 'NF > 0 {printf("{\"image_url\": \"%s\"}", $0)}' | paste -s -d,)"
    cat <<EOF
{
  "channel": "${SLACK_CHANNEL}",
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
    | slk -w "${SLACK_WEBHOOK_ID}" -j
} >/dev/null

