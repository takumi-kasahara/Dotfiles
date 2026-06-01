#!/usr/bin/env bash
case $- in
  *i*) ;;
  *) return;;
esac

set -o noclobber
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize
shopt -s extglob
shopt -s histappend
shopt -u hostcomplete

# https://www.gnu.org/software/bash/manual/bash.html#index-HISTCONTROL
HISTCONTROL=ignoreboth:erasedups
# https://www.gnu.org/software/bash/manual/bash.html#index-HISTFILE
HISTSIZE=-1
# https://www.gnu.org/software/bash/manual/bash.html#index-HISTFILESIZE
HISTFILESIZE=-1

case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='\[\e[1;32m\]\u@\h\[\e[00m\] \[\e[1;35m\]${WSL_DISTRO_NAME:-$OSTYPE} \[\e[1;33m\]\w\[\e[00m\]\n\$ '
else
  PS1='\u@\h ${WSL_DISTRO_NAME:-$OSTYPE} \w\n\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
