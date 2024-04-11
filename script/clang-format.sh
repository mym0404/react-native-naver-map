#!/bin/bash

if which clang-format >/dev/null; then
  find ios -type f \( -name "*.h" -o -name "*.cpp" -o -name "*.m" -o -name "*.mm" \) -print0 | while read -d $'\0' file; do
    echo "⭐️clang-format $file"
    clang-format -i "$file"
  done
else
  echo "warning: clang-format not installed, download from https://clang.llvm.org/docs/ClangFormat.html (or run brew install clang-format)"
fi