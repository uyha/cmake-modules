#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

"$SCRIPT_DIR/gen-pull-modules.sh"

git ls-files --error-unmatch "$SCRIPT_DIR/pull-modules.sh" 1>/dev/null 2>&1
is_new=$?
git diff --exit-code tools/pull-modules.sh 1>/dev/null 2>&1
has_changed=$?

if [[ $is_new -ne 0 || $has_changed -ne 0 ]]; then
  git commit "$SCRIPT_DIR/pull-modules.sh" -m 'Regenerate pull-modules.sh'
  git push origin "$(git rev-parse --abbrev-ref HEAD)"
fi
