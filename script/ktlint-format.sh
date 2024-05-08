#!/usr/bin/env bash
set -e
#echo "🌊 ktlint android $file"
ktlint --color --format --relative --editorconfig=example/android/.editorconfig "$@"
