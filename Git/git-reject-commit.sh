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

# https://git-scm.com/docs/githooks#_pre_commit
if ! git config --get commit.gpgsign >/dev/null; then
  echo 'fatal: commit.gpgsign is not configured.' >&2
  exit 1
fi

branch=$(git rev-parse --abbrev-ref @)
if [[ "$branch" = "$(git config --get init.defaultBranch)" ]]; then
  printf "fatal: committing on the default branch (%s) is not allowed.\n" "$branch" >&2
  exit 1
fi
