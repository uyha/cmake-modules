#!/usr/bin/env bash

set -euo pipefail

output=tools/pull-modules.sh

shopt -s globstar
modules=(**/*.cmake)
modules=("${modules[@]/%/'"'}")
modules=("${modules[@]/#/'"'}")

cat >$output <<EOF
#!/usr/bin/env bash

set -euo pipefail

repo="https://github.com/uyha/cmake-modules"
raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules"
modules=(
$(printf '  %s\n' "${modules[@]}")
)

echo "Downloading modules from \$repo"
printf "%s\n" "\${modules[@]}" |
  xargs -P "\$(nproc)" -I {} \\
    curl --silent \\
         --location \\
         --create-dirs \\
         --output cmake/{} \\
         \$raw_repo/master/{}
EOF
