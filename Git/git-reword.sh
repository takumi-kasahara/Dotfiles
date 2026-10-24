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

if [[ -z "${1:-}" ]]; then
  if [[ -n "$(git diff --name-status --cached)" ]]; then
    exit 0
  fi
  GIT_COMMITTER_DATE="$(git log -1 --format=%aI)" git commit --verbose --amend --signoff
else
  # TODO Replace with `git history --reword <commit>` when [git-history](https://git-scm.com/docs/git-history) adds an equivalent option to `--committer-date-is-author-date`.
  :
fi
