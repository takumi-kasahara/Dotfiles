#!/usr/bin/env bash
if [ -n "$BASH_VERSION" ] && [ -r "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

if [ -d "$LOCALAPPDATA/Programs" ]; then
  PATH="$(cygpath -a "$LOCALAPPDATA/Programs"):$PATH"
fi
