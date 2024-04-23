#!/usr/bin/env bash

if which ktlint >/dev/null; then
  echo "🌊 ktlint android"
  ktlint --relative --color --editorconfig=example/android/.editorconfig android
else
  echo "warning: ktlint not installed, download from https://pinterest.github.io/ktlint/latest/install/setup/"
fi
