#!/bin/bash
set -e
for file in "$@"; do
#  echo "🦋 clang-format ${file}"
  clang-format -i "${file}"
done
