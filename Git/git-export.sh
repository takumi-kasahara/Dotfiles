#!/usr/bin/env bash
[[ -n "${TRACE:-}" ]] && set -o xtrace
set -o errexit
set -o errtrace
set -o functrace
set -o noclobber
set -o nounset
set -o pipefail
shopt -s failglob
shopt -s huponexit
shopt -s inherit_errexit
shopt -s lastpipe
shopt -s nullglob
shopt -s shift_verbose

repo=$(basename -- "$(git rev-parse --show-toplevel --show-superproject-working-tree | head -1)")
if [[ -z "$repo" ]]; then
  exit 64
fi
hash=$(git rev-parse --short "${1:-@}")
tag=$(git describe --tags --exact-match "${1:-@}" 2>/dev/null || true)
if [[ -n "$tag" ]]; then
  name="$tag"
else
  name="$(git name-rev --name-only "${1:-@}")/$(git show --no-patch --format='%ad' --date=format:'%Y%m%d%H%M%S' "${1:-@}")"
fi
output="/tmp/.git/$repo/$name.zip"
dir=$(dirname -- "$output")
if [[ ! -d "$dir" ]]; then
  mkdir -p "$dir"
fi

# https://git-scm.com/docs/git-archive
git archive "$hash" --verbose --output "$output" && echo "$output"
