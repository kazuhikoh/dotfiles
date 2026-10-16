#!/usr/bin/env bash

set -euo pipefail

find_device() {
  device_list=$(
    flutter devices --machine |
      jq -r '.[] | select( .emulator == false and (.targetPlatform | test("^(android|ios)")) ) | "\(.id) \(.targetPlatform)"'
  )

  if [ -z "$device_list" ]; then
    echo "⚠️ E: Real device not found!" >&2
    return 1
  fi

  device_info=$(echo "$device_list" | head -n 1)
  target_device=$(echo "$device_info" | awk '{print $1}')
  platform=$(echo "$device_info" | awk '{print $2}')
  echo "📲 $target_device ($platform)"
}

build() {
  local opts="$OPT_DEV_FLAVOR $OPT_DEV_TARGET"
  if [[ "$platform" == android* ]]; then
    flutter build apk --debug $opts
  elif [[ "$platform" == ios* ]]; then
    flutter build ios --debug $opts
  else
    echo "⚠️ E: Unsupported platform: $platform" >&2
    return 1
  fi
}

install() {
  flutter install --debug $OPT_DEV_FLAVOR -d "$target_device"
}

launch() {
  if [[ "$platform" == android* ]]; then
    local pkg="$OPT_DEV_ANDROID_PKG"
    adb -s $target_device shell am start -n "$pkg"
  elif [[ "$platform" == ios* ]]; then
    :
  fi
}

find_device && build && install && launch

