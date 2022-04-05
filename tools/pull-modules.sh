#!/usr/bin/env bash

set -euo pipefail

if [[ ! -d cmake ]]; then
  mkdir cmake
fi

repo="https://github.com/uyha/cmake-modules"
raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules"
modules=(
  "$raw_repo/master/CompileOptions.cmake"
  "$raw_repo/master/Conan.cmake"
  "$raw_repo/master/FindConan.cmake"
  "$raw_repo/master/FindPoetry.cmake"
  "$raw_repo/master/Poetry.cmake"
)

(
  cd cmake
  echo "Downloading modules from $repo"
  printf "%s\n" "${modules[@]}" |
    xargs -P "$(nproc)" -I {} curl --silent --location --remote-header-name --remote-name {}
)
