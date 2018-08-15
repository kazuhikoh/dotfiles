# Vim Oneliner
# ================================ 

# fenc <from> <to> <filepath>
fenc() {
  if ! type vim > /dev/null; then
    echo "Vim is our help and shield."
    exit 1;
  fi

  local from="$1"
  local to="$2"
  local filepath="$3"
  : ${from:?} ${to:?} ${filepath:?}

  vim -c ":e ++enc=${from}" -c "set fenc=${to}" -c ":wq" "$filepath"
}

# ff <file-format>
ff() {
  if ! type vim > /dev/null; then
    echo "Vim is our help and shield."
    exit 1;
  fi

  local format="$1"
  local filepath="$2"
  : ${format:?} ${filepath:?}

  vim -c ":set ff=${format}" -c ":wq" "$filepath"
}

