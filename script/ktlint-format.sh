#!/usr/bin/env bash
set -e
for file in "$@"; do
  echo "🌊 ktlint android $file"
  ktlint --color --format --relative --editorconfig=example/android/.editorconfig $file
done
