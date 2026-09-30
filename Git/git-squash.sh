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

if [[ -n "$(git diff --name-status --cached)" ]]; then
  exit 0
fi

if [[ -z "${1:-}" ]]; then
  hash='@{u}'
else
  hash=$1~
fi

git reset --soft "$hash" && git merge '@{1}' --squash --ff && git commit --verbose || git reset --soft '@{1}'
