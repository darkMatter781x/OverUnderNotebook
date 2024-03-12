#!/bin/bash

# Installs some of the required dependencies and tools for the project:
# - notebookinator: typst template for vrc engineering notebook
# - typst-live: provides live preview of compiled typst pdf
# - typstfmt: provides formatting for typst files
# - typos-cli: provides spell checking
# 
# Also adds the required fonts to the system from the ./assets/fonts
# 
# This script does not install these required tools:
# - git: used to clone notebookinator and update this notebook
# - cargo: used to install typst-live, typstfmt, and typos-cli
# - typst: used to compile typst files
# - just: used to install notebookinator template

# exits with exit code 1 if the command is not found
# borrowed from https://stackoverflow.com/a/7522866
check_command() {
  command_name=$1
  if ! command_loc="$(type -p "$command_name")" || [[ -z $command_loc ]]; then
    return 1
  fi
}

if ! check_command git ; then
  echo "git is not installed. Please install it"
  exit 1
fi
if ! check_command cargo ; then
  echo "cargo is not installed. Please install it"
  exit 1
fi
if ! check_command typst ; then
  echo "typst is not installed. Please install it"
  exit 1
fi
if ! check_command just ; then
  echo "just is not installed. Please install it"
  exit 1
fi

if [ -d "notebookinator" ]; then
  echo "notebookinator directory already exists. Skipping clone."
else
  git clone https://github.com/darkMatter781x/notebookinator
fi

cd notebookinator
just install
cd ..

cargo install typst-live
cargo install --git https://github.com/astrale-sharp/typstfmt.git --tag 0.2.7
cargo install typos-cli

# add fonts
sudo cp -R ./assets/fonts /usr/share/fonts/truetype