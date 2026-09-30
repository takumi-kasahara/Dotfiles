#!/usr/bin/env bash
history -c
rm -f -- "$HISTFILE"
if [ "$SHLVL" = 1 ]; then
  [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
