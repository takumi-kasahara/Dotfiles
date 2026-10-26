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
ante_head=${1:-@}
post_head=${2:-@}
branch_checkout=${3:-1}
if [[ "$branch_checkout" != "1" ]]; then
  exit 0
fi
if ! git symbolic-ref --quiet HEAD >/dev/null 2>&1; then
  exit 0
fi

for remote in $(git remote); do
  git branch --delete-merged "$remote"
done

current=$(git branch --show-current)
while read -r branch; do
  if [[ "$current" != "$branch" ]]; then
    git branch --delete "$branch"
  fi
done < <(git branch --format='%(refname:short)' --merged "$post_head")
