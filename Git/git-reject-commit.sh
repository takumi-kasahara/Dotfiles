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

remote=$(git config --get "branch.$branch.remote" 2>/dev/null) || true
[[ -z "$remote" ]] && exit 0

remote_tracking_prefix="refs/remotes/$remote/"
remote_head=$(git symbolic-ref --quiet "refs/remotes/$remote/HEAD" 2>/dev/null) || true
[[ -z "$remote_head" ]] && exit 0
[[ "$remote_head" != "$remote_tracking_prefix"* ]] && exit 0

head_ref="refs/heads/${remote_head#"$remote_tracking_prefix"}"
push_ref=$(git rev-parse --symbolic-full-name "@{push}" 2>/dev/null) || true
[[ -z "$push_ref" ]] && exit 0
[[ "$push_ref" != "$remote_tracking_prefix"* ]] && exit 0

if [[ "refs/heads/${push_ref#"$remote_tracking_prefix"}" = "$head_ref" ]]; then
  printf "fatal: pushing to the remote default branch (%s) is not allowed.\n" "$remote_head" >&2
  exit 1
fi
