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

repo=$(git rev-parse --show-toplevel --show-superproject-working-tree | head -1)
if [[ -z "$repo" ]]; then
  exit 64
elif [[ -z "$(git diff --name-status --cached)" ]]; then
  exit 0
elif git rev-parse @~ >/dev/null 2>&1; then
  exit 0
fi

git commit --amend --no-edit && git rebase --committer-date-is-author-date --root
