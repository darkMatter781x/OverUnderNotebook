#!/bin/bash

files=$(npm run --silent format:find)

up_to_date=$(echo $files | xargs typstfmt | sed 's/.*"\([^"]*\)".*/\1/')

format_msg_yet=false
for file in $files; do
  if [[ $up_to_date == *$file* ]]; then
    :
  else
    if [[ $format_msg_yet == false ]]; then
      echo -e "formatting:"
      format_msg_yet=true
    fi
    echo -e "🔧 $file"
  fi
done