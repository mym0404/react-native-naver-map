#!/usr/bin/env bash
set -e

for file in "$@"; do
  echo "🌊 ktlint android $file"
  ktlint --color --relative --editorconfig=example/android/.editorconfig $file
done
