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

# https://git-scm.com/docs/githooks#_pre_push
remote=$1
remote_tracking_prefix="refs/remotes/$remote/"
if ! remote_head=$(git symbolic-ref --quiet "refs/remotes/$remote/HEAD"); then
	exit 0
fi
if [[ "$remote_head" != "$remote_tracking_prefix"* ]]; then
  exit 0
fi

head_ref="refs/heads/${remote_head#"$remote_tracking_prefix"}"
if ! push_ref=$(git rev-parse --symbolic-full-name "@{push}" 2>/dev/null); then
  exit 0
fi
if [[ "$push_ref" != "$remote_tracking_prefix"* ]]; then
  exit 0
fi
if [[ "refs/heads/${push_ref#"$remote_tracking_prefix"}" = "$head_ref" ]]; then
  printf 'fatal: pushing to the remote default branch (%s) is not allowed.\n' "$remote_head" >&2
  exit 1
fi

while read -r commit; do
  if ! git verify-commit "$commit" >/dev/null 2>&1; then
    printf 'fatal: unverified commit (%s) detected.\n' "$commit" >&2
    exit 1
  fi
done < <(git rev-list '@{push}'..@)
