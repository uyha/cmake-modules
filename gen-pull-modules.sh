#!/usr/bin/env bash

set -euo pipefail

output=pull-modules.sh
cat >$output <<EOF
#!/usr/bin/env bash

set -euo pipefail

if [[ ! -d cmake ]]; then
  mkdir cmake
fi

repo="https://github.com/uyha/cmake-modules"
raw_repo="https://raw.githubusercontent.com/uyha/cmake-modules"
EOF

shopt -s globstar
modules=(**/*.cmake)
modules=("${modules[@]/%/'"'}")
modules=("${modules[@]/#/'"$raw_repo/master/'}")

{
  echo 'modules=('
  printf '  %s\n' "${modules[@]}"
  echo ')'
} >>$output

cat >>$output <<'EOF'

(
  cd cmake
  echo "Downloading modules from $repo"
  printf "%s\n" "${modules[@]}" |
    xargs -P "$(nproc)" -I {} curl --silent --location --remote-header-name --remote-name {}
)
EOF
