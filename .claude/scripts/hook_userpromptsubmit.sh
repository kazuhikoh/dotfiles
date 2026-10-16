#!/bin/bash

et -euo pipefail
input=$(cat)

# 端末タブ名の更新
#  - session_title（現在の Claude セッション名）を、 tmux / 端末タイトルに追従させる。
#  - /rename でセッション名が変わった直後のプロンプト送信で tmux / iTerm2 に反映される。
function sync_session_title() {
  local title=$(printf '%s' "$input" | jq -r '.session_title // empty')
  [ -z "$title" ] || [ "$title" = "null" ] && return 0
  
  if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
    tmux rename-session -- "$title" 2>/dev/null || true
    tmux set -g set-titles on 2>/dev/null || true
    tmux set -g set-titles-string '#S' 2>/dev/null || true
  else
    ( printf '\033]0;%s\007' "$title" > /dev/tty ) 2>/dev/null || true
  fi
}

sync_session_title
