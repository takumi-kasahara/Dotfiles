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

if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]]; then
  echo "Usage: $0 <LOCAL> <REMOTE> <BASE> <MERGED>" >&2
  exit 64
fi

WinMerge='C:/Program Files/WinMerge/WinMergeU.exe'
if [[ -z "${WSL_DISTRO_NAME:-}" ]]; then
  LOCAL="$1"
  REMOTE="$2"
  BASE="$3"
  MERGED="$4"
else
  LOCAL=$(wslpath -a -w "$1")
  REMOTE=$(wslpath -a -w "$2")
  BASE=$(wslpath -a -w "$3")
  MERGED=$(wslpath -a -w "$4")
  WinMerge=$(wslpath -a -u "$WinMerge")
fi
if [[ ! -f "$WinMerge" ]]; then
  echo "fatal: WinMerge not found."
  exit 69
fi

"$WinMerge" -e -u -x -r -wl -wm -fr -ar -dl "Base" -dm "Theirs" -dr "Mine" "$BASE" "$REMOTE" "$LOCAL" -o "$MERGED"
