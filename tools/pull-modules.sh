#!/usr/bin/env bash

set -euo pipefail

repo="https://github.com/uyha/cmake-modules"
raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules/master"
modules=(
  "CompileOptions.cmake"
  "Conan.cmake"
  "FindConan.cmake"
  "FindPoetry.cmake"
  "Poetry.cmake"
  "Random.cmake"
)

echo "Downloading modules from $repo"
printf "%s\n" "${modules[@]}" |
  xargs -P "$(nproc)" -I {} \
    curl --silent \
         --location \
         --create-dirs \
         --output cmake/{} \
         $raw_repo/{}
