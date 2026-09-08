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

if [[ -z "$(git diff --name-status --cached)" ]]; then
  exit 0
elif [[ -z "${1:-}" ]]; then
  GIT_COMMITTER_DATE="$(git log -1 --format=%aI)" git commit --verbose --amend --no-edit
else
  if [[ "$(git rev-parse "$1")" == "$(git rev-list @ --max-parents=0)" ]]; then
    hash=--root
  else
    hash="$1~"
  fi
  git commit --verbose --fixup "$1" && git rebase --verbose --reapply-cherry-picks --interactive --committer-date-is-author-date "$hash" || git reset --soft '@{1}'
fi
