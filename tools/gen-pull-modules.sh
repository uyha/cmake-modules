#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

output="$SCRIPT_DIR"/pull-modules.sh

shopt -s globstar
modules=(**/*.cmake)
modules=("${modules[@]/%/'"'}")
modules=("${modules[@]/#/'"'}")

cat >"$output" <<EOF
#!/usr/bin/env bash

set -euo pipefail

repo="https://github.com/uyha/cmake-modules"
raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules/master"
modules=(
$(printf '  %s\n' "${modules[@]}")
)

echo "Downloading modules from \$repo"
printf "%s\n" "\${modules[@]}" |
  xargs -P "\$(nproc)" -I {} \\
    curl \\
         --header "Cache-Control: no-cache, no-store" \\
         --silent \\
         --location \\
         --create-dirs \\
         --output cmake/{} \\
         \$raw_repo/{}
EOF
