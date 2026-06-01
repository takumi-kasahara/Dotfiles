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
alias restart='taskkill -IM explorer.exe -F >/dev/null && start explorer.exe'

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  ex() { for p in "$@"; do explorer.exe "$(wslpath -a -w "$p")"; done; }
else
  ex() { for p in "$@"; do explorer.exe "$(cygpath -a -w "$p")"; done; }
fi

if command -v sudo >/dev/null 2>&1; then
  alias logout='sudo --disable-input shutdown /l /soft'
  alias reboot='sudo --disable-input shutdown /g /soft'
else
  alias logout='runas /user:"$USERNAME" shutdown /l /soft'
  alias reboot='runas /user:"$USERNAME" shutdown /g /soft'
fi

cinst() { sudo.exe --disable-input choco.exe install "$1" --accept-license --pre "${2-}"; }
cremove() { sudo.exe --disable-input choco.exe uninstall "$1" --all-versions "${2-}"; }
cpurge() { sudo.exe --disable-input choco.exe uninstall "$1" --all-versions --remove-dependencies "${2-}"; }
cup() { sudo.exe --disable-input choco upgrade all --accept-license --pre "$@"; }

winst() { sudo.exe --disable-input winget.exe install --id "$1" --exact --accept-package-agreements --accept-source-agreements "${2-}"; }
wremove() { sudo.exe --disable-input winget.exe uninstall --id "$1" --exact --all-versions "${2-}"; }
wpurge() { sudo.exe --disable-input winget.exe uninstall --id "$1" --exact --all-versions --purge "${2-}"; }
wup() { sudo.exe --disable-input winget.exe upgrade --all --include-unknown "$@"; }
