#!/usr/bin/env bash
set -e

#echo "🌊 ktlint android $file"
ktlint --color --relative --editorconfig=example/android/.editorconfig "$@"
