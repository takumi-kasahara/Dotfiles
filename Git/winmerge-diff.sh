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

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <LOCAL> <REMOTE>" >&2
  exit 64
fi

WinMerge='C:/Program Files/WinMerge/WinMergeU.exe'
if [[ -z "${WSL_DISTRO_NAME:-}" ]]; then
  LOCAL="$1"
  REMOTE="$2"
else
  LOCAL=$(wslpath -a -w "$1")
  REMOTE=$(wslpath -a -w "$2")
  WinMerge=$(wslpath -a -u "$WinMerge")
fi
if [[ ! -e "$WinMerge" ]]; then
  echo "fatal: WinMerge not found." >&2
  exit 69
fi

"$WinMerge" -e -u -x -r -wl -fr -dl "Base" -dr "Mine" "$LOCAL" "$REMOTE"
