#!/bin/bash
set -x

PATH=$PATH:~/bin

to_json() {
  readonly SLACK_CHANNEL="$1"

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
  diff="$(xsorapiyo -d ~/.sorapiyo)"
  echo "$diff" | to_json general  | slk -w 1091 -j
  echo "$diff" | to_json sorapiyo | slk -w 1091 -j
  echo "$diff" | to_json 1091     | slk -w home -j
} >/dev/null

