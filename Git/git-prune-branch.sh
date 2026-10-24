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

if ! git symbolic-ref --short "${1:-@}" >/dev/null 2>&1; then
  exit 0
fi

current=$(git branch --show-current)
while read -r branch; do
  if [[ "$current" != "$branch" ]]; then
    git branch --delete "$branch"
  fi
done < <(git branch --format='%(refname:short)' --merged "${1:-@}")
