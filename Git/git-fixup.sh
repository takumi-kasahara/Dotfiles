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

[[ -z "$(git diff --name-status --cached)" ]] && exit 0

if [[ -z "${1:-}" ]]; then
  GIT_COMMITTER_DATE="$(git log -1 --format=%aI)" git commit --verbose --amend --no-edit --signoff
  exit 0
fi

if [[ "$(git rev-parse "$1")" == "$(git rev-list @ --max-parents=0)" ]]; then
  hash=--root
else
  hash="$1~"
fi
# TODO Replace with `git history --fixup <commit>` when [git-history](https://git-scm.com/docs/git-history) adds an equivalent option to `--committer-date-is-author-date`.
git commit --verbose --fixup "$1" && git rebase --verbose --reapply-cherry-picks --interactive --committer-date-is-author-date "$hash" || git reset --soft '@{1}'
