#!/bin/sh

for X11DISPLAY in /run/user/*/X11-display; do 
  USERNAME="$(stat -c %U $(dirname "${X11DISPLAY}"))"
  export DISPLAY=":$(readlink "${X11DISPLAY}" | sed 's,/tmp/.X11-unix/X,,')"
  sudo -u "${USERNAME}" xdg-screensaver lock
done
