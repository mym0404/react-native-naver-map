#!/bin/bash
set -e
for file in "$@"; do
#  echo "🦋 clang-lint ${file}"
  clang-format --dry-run -Werror "${file}"
  if [[ $? = 1 ]]; then
    echo "❌ clang lint failed on '$file'"
    exit 1
  fi
done
