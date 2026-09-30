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

_convert() {
  if [[ $1 == /* ]]; then
    echo "$1"
  else
    wslpath -a -u "$1"
  fi
}
if [[ "$2" == "True" ]]; then
  FLAGS='-f'
else
  FLAGS='-i'
fi
_copy() {
  declare -r src="$(_convert "$1")"
  declare -r dst=$2
  declare -r target="$dst/$(basename -- "$src")"
  if [[ -e "$src" ]]; then
    if [[ -e "$target" ]]; then
      if [[ ! -L "$target" ]]; then
        if [[ -f "$src" && -f "$target" ]]; then
          if cmp -s "$src" "$target"; then
            printf 'Skiped:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
            return
          fi
        fi
        if [[ -d "$src" && -d "$target" ]]; then
          if diff -rq "$src" "$target" > /dev/null; then
            printf 'Skiped:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
            return
          fi
          fi
        fi
        printf 'Replace:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
        if [[ -w "$dst" && -w "$target" ]]; then
          rm $FLAGS "$target"
        else
          sudo rm $FLAGS "$target"
      fi
    else
      printf 'Create:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
    fi
    if [[ -w "$dst" ]]; then
      cp -r $FLAGS "$src" "$target"
    else
      sudo cp -r $FLAGS "$src" "$target"
    fi
  else
    printf 'Skiped:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
  fi
}
if [[ "$1" == "True" ]]; then
  _ln() {
    declare -r src="$(_convert "$1")"
    declare -r dst=$2
    declare -r target="$dst/$(basename -- "$src")"
    if [[ -e "$src" ]]; then
      if [[ "$target" && "$(readlink -f "$target")" == "$src" ]]; then
        printf 'Skiped:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
        return
      elif [[ -e "$target" ]]; then
        printf 'Replace:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
        if [[ -w "$dst" && -w "$target" ]]; then
          rm $FLAGS "$target"
        else
          sudo rm $FLAGS "$target"
        fi
      else
        printf 'Create:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
      fi
      if [[ -w "$dst" && -w "$target" ]]; then
        ln -nfs "$src" "$target"
      else
        sudo ln -nfs "$src" "$target"
      fi
    else
      printf 'Skiped:\t%s\t->\t%s\n' "$1" "${target/$HOME/"~"}"
    fi
  }
else
  _ln() {
    _copy "$1" "$2"
  }
fi

_copy "$(dirname -- "$0")/wsl.conf" '/etc'
_copy "$(dirname -- "$0")/hosts" '/etc'
_copy "$(dirname -- "$0")/resolv.conf" '/etc'
_copy "$USERPROFILE/.ssh" "$HOME"
if [[ -d "$HOME/.ssh" ]]; then
  sudo chown -R "$(whoami):$(whoami)" ~/.ssh
  sudo chmod 700 ~/.ssh
  sudo chmod 600 ~/.ssh/*
  sudo chmod 644 ~/.ssh/*.pub
fi

_ln "$(dirname -- "$0")/.bash_logout" "$HOME"
_ln "$(dirname -- "$0")/.bashrc" "$HOME"
_ln "$(dirname -- "$0")/.profile" "$HOME"
_ln "$(dirname -- "$0")/.psqlrc" "$HOME"
_ln "$USERPROFILE/.bash_aliases" "$HOME"
_ln "$USERPROFILE/.gitconfig" "$HOME"
_ln "$USERPROFILE/.inputrc" "$HOME"
_ln "$USERPROFILE/.vimrc" "$HOME"
for gitconfig in "$USERPROFILE"/*.gitconfig; do
  _ln "$gitconfig" "$HOME"
done

bin=$HOME/.local/bin
mkdir -p "$HOME/.local/bin"
for script in Git/*.sh; do
  _ln "$script" "$bin"
done
find "$HOME" -xtype l -print0 | while IFS= read -r -d '' broken; do
  printf 'Remove:\t%s\n' "${broken/$HOME/"~"}"
  rm -f "$broken"
done
find "$bin" -xtype l -print0 | while IFS= read -r -d '' broken; do
  printf 'Remove:\t%s\n' "${broken/$HOME/"~"}"
  rm -f "$broken"
done
