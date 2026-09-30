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

# Provides `svn --use-commit-times`

if ! command -v touch >/dev/null 2>&1; then
  printf 'fatal: touch not found.\n' >&2
  exit 69
fi

repo=$(git rev-parse --show-toplevel --show-superproject-working-tree | head -1)
if [[ -z "$repo" ]]; then
  exit 64
fi
echo "$repo"
git ls-files -z | while IFS= read -r -d '' file; do
  echo "$file"
  # authorDate=$(git log --follow --format='%aI' -- "$file" | sort | head -1)
  commitDate=$(git log --follow --format='%cI' -- "$file" | sort | tail -1)
  touch -d "$commitDate" -- "$file" || printf 'touch failed for %s\n' "$file" >&2
done
