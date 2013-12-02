#!/bin/sh

for X11DISPLAY in /run/user/*/X11-display; do 
  USERNAME="$(stat -c %U $(dirname "${X11DISPLAY}"))"
  sudo -u "${USERNAME}" xdg-screensaver lock
done
