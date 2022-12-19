#!/usr/bin/env bash

set -euo pipefail

repo="https://github.com/uyha/cmake-modules"
raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules/master"
modules=(
  "Ccache.cmake"
  "CompileOptions.cmake"
  "Conan.cmake"
  "FindConan.cmake"
  "FindPoetry.cmake"
  "Poetry.cmake"
)

echo "Downloading modules from $repo"
printf "%s\n" "${modules[@]}" |
  xargs -P "$(nproc)" -I {} \
    curl \
         --header "Cache-Control: no-cache, no-store" \
         --silent \
         --location \
         --create-dirs \
         --output cmake/{} \
         $raw_repo/{}
