#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

"$SCRIPT_DIR/gen-pull-modules.sh"

if ! git diff --exit-code tools/pull-modules.sh >/dev/null; then
  echo git commit tools/pull-modules.sh -m 'Regenerate pull-modules.sh'
  echo git push origin "$(git rev-parse --abbrev-ref HEAD)"
fi
