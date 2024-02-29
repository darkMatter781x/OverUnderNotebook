#!/bin/bash

RED='\x1b[31m'
GREEN='\x1b[32m'
YELLOW='\x1b[33m'
BLUE='\x1b[34m'
PURPLE='\x1b[35m'
CYAN='\x1b[36m'
WHITE='\x1b[37m'
NO_COLOR='\x1b[0m'

output=$(npm run --silent format:find | xargs typstfmt --check --verbose | sed "/needs formatting/s/.*/${RED}&${NO_COLOR}/g" | sed "s/is already formatted./✅/g" | sed "s/needs formatting./❌/g")
echo "$output"
if echo "$output" | grep -q "❌"; then
  exit 255
fi