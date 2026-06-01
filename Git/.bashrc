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

if [ -f $HOME/.bash_aliases ]; then
  . $HOME/.bash_aliases
fi

PS1='\[\e[1;32m\]\u@\h \[\e[1;35m\]$MSYSTEM \[\e[1;33m\]\w\[\e[1;36m\]`__git_ps1`\[\e[0m\]\n$ \[\]'
