#!/usr/bin/env bash
if [ -x /usr/bin/dircolors ]; then
  [ -r "$HOME/.dircolors" ] && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias cls='clear'
alias g='git'
alias h='history'
alias restart='taskkill -IM explorer -F >/dev/null && start explorer'

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  ex() { for p in "$@"; do explorer "$(wslpath -a -w "$p")"; done; }
else
  ex() { for p in "$@"; do explorer "$(cygpath -a -w "$p")"; done; }
fi

if command -v sudo >/dev/null 2>&1; then
  alias logout='sudo shutdown /l /soft'
  alias reboot='sudo shutdown /g /soft'
else
  alias logout='runas /user:"$USERNAME" shutdown /l /soft'
  alias reboot='runas /user:"$USERNAME" shutdown /g /soft'
fi

cinst() { sudo choco install "$1" --accept-license --pre "${2-}"; }
cremove() { sudo choco uninstall "$1" --all-versions "${2-}"; }
cpurge() { sudo choco uninstall "$1" --all-versions --remove-dependencies "${2-}"; }
cup() { sudo choco upgrade all --accept-license --pre "$@"; }

winst() { sudo winget install --id "$1" --exact --accept-package-agreements --accept-source-agreements "${2-}"; }
wremove() { sudo winget uninstall --id "$1" --exact --all-versions "${2-}"; }
wpurge() { sudo winget uninstall --id "$1" --exact --all-versions --purge "${2-}"; }
wup() { sudo winget upgrade --all --include-unknown "$@"; }
