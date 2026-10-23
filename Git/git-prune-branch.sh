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

# https://git-scm.com/docs/githooks#_post_checkout
for remote in $(git remote); do
  git branch --delete-merged "$remote"
done
current=$(git rev-parse --abbrev-ref "${1:-@}")
if [[ -n "$current" ]] && [[ "$current" != "HEAD" ]]; then
  git branch --format="%(refname:short)" --merged "$current" | grep -v "^${current}$" | xargs -r -n 1 git branch -d
fi
