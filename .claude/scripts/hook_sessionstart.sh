#!/bin/bash

set -euo pipefail
input=$(cat)

# セッション名の設定
#  - 端末タブ名/セッション名を cwd の basename に揃える
#  - 端末タブ名の更新は startup/resume の「毎回」行う (claude -c での再開でも反映)
#    - tmux: set-titles 
#    - else: OSC で端末タブ名を更新
#  - Claude のセッション名(sessionTitle)は未設定のときだけ出力し、 /rename, --name を優先
#  - clear / compact では何もしない
function set_session_name() {
  local src=$(printf '%s' "$input" | jq -r '.source // empty')
  case "$src" in
    startup|resume) ;;
    *) return 0 ;;
  esac
  
  # 設定済みタイトル(/rename/--name済み), cwd を取得
  local title=$(printf '%s' "$input" | jq -r '.session_title // empty')
  local cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
  [ -z "$cwd" ] && cwd=$(pwd)
  local base=$(basename "$cwd")
  
  # 表示名: 既存タイトルがあれば尊重、無ければ basename。
  # set_name=1 のときだけ Claude のセッション名を新規設定する。
  local name='' 
  local set_name=false
  if [ -n "$title" ] && [ "$title" != "null" ]; then
    name="$title"; set_name=false
  else
    name="$base"; set_name=true
  fi
  
  # 端末タブ名の更新
  if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
    # tmux
    tmux set -g set-titles on 2>/dev/null || true
    tmux set -g set-titles-string '#S' 2>/dev/null || true
    tmux rename-session -- "$name" 2>/dev/null || true
  else
    # tmux以外: OSC で端末タブ名を更新 (/dev/ttyが無い環境ではスキップ)
    ( printf '\033]0;%s\007' "$name" > /dev/tty ) 2>/dev/null || true
  fi
  
  # Claude のセッション名
  if "$set_name"; then
    jq -nc --arg t "$name" \
      '{hookSpecificOutput: {hookEventName: "SessionStart", sessionTitle: $t}}'
  fi
}

set_session_name
