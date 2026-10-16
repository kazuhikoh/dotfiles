#!/bin/bash

NOW=$(date +%s)
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
CW_USED_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
LIMIT5H_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty | floor | tostring')
LIMIT5H_RESETTIME=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0 | tostring')
LIMIT7D_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty | floor | tostring')
LIMIT7D_RESETTIME=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0 | tostring')

DIR=$(echo "$input" | jq -r '.workspace.current_dir')

format_resettime() {
  local epoch="$1"
  [ -z "$epoch" ] || [ "$epoch" = "0" ] || [ "$epoch" = "null" ] && return

  local rem=$(( epoch - NOW ))
  [ "$rem" -le 0 ] && return

  local d=$(( rem / 86400 )) h=$(( rem % 86400 / 3600 )) m=$(( rem % 3600 / 60 ))
  printf '%2d:%2d:%2d' "$d" "$h" "$m"
  #if   [ "$d" -gt 0 ]; then printf ' %dd %2dh %2dm' "$d" "$h" "$m"
  #elif [ "$h" -gt 0 ]; then printf '     %2d時間 %2d分でリセット' "$h" "$m"
  #else                      printf '            %2d分でリセット' "$m"; fi
}

#LIMIT5H_F1=$(printf '')
#LIMIT5H=$(format_resettime "$LIMIT5H_RESETTIME")
#LIMIT7D=$(format_resettime "$LIMIT7D_RESETTIME")

function get_git_info {
  ! type git >/dev/null && return
  ! git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null && return

  local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  local branch_status=""

  local st=$(git status 2> /dev/null)

  if [[ -n $(echo "$st" | grep "^nothing to") ]]; then
    branch_status="clean"
  elif [[ -n $(echo "$st" | grep "^Untracked files") ]]; then
    branch_status="has_untracked"
  elif [[ -n $(echo "$st" | grep "^Changes not staged for commit") ]]; then
    branch_status="has_not_staged"
  elif [[ -n $(echo "$st" | grep "^Changes to be committed") ]]; then
    branch_status="staged"
  elif [[ -n $(echo "$st" | grep "^rebase in progress") ]]; then
    branch_status="rebase"
  else
    branch_status=""
  fi

  echo -n "$branch_name $branch_status"
}

function print_git_info() {
  local arr=( $(get_git_info) )
  local git_branch=${arr[0]}
  local git_status=${arr[1]}

  if [[ "$git_branch" == '' ]]; then
    return
  fi

  local t_icon=$'\ue725' # nf-dev-git_branch
  local t_branch="$git_branch"
  local t_status=$(
    case "$git_status" in
      (clean)          echo "" ;;
      (has_untracked)  echo "[?]" ;;
      (has_not_staged) echo "[+]" ;;
      (has_staged)     echo "[!]" ;;
      (*) echo "" ;
    esac
  )

  printf '%b %s%s' "${t_icon}" "${t_branch}" "${t_status}" 
}

function colored() {
  local s="$1"
  local n="$2"
  local color=""

  if ! [[ "$n" =~ ^[0-9]+$ ]] || [ "$n" -lt 0 ] || [ "$n" -gt 100 ]; then
    return 1
  fi

  if [ "$n" -le 59 ]; then
    color="\033[32m"      # Green
  elif [ "$n" -le 79 ]; then
    color="\033[33m"      # Yellow
  elif [ "$n" -le 89 ]; then
    color="\033[38;5;208m" # Orange
  else
    color="\033[31m"      # Red
  fi

  local reset="\033[0m"

  printf "${color}%s${reset}" "$s"
}

icon=$'\ue725'

function statusline() {
  local cw="$CW_USED_PCT%"
  local limit5h="$(colored "$LIMIT5H_PCT%" $LIMIT5H_PCT )"
  local limit7d="$(colored "$LIMIT7D_PCT%" $LIMIT7D_PCT )"
  local gitbr="$(print_git_info)"
  echo -e "[$MODEL] $cw | 5h $limit5h | 7d $limit7d | $gitbr" 
}
statusline

