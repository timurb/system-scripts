### System scripts

This repo holds some system scripts I use in configuration of my Ubuntu laptop.

#### xdg-screensaver

This is a stock Ubuntu 13.10 xdg-screensaver with added support for MATE and its mate-screensaver.

### ACPI scripts

You can run all these by acpid: create /etc/acpi/events/XXXXX for that.
There are some examples for that in `acpi/events` dir.

#### acpi/lock-screen.sh

This script can be run as root to lock all X-sessions of all users.

#### acpi/sleep.sh

This script is a wrapper around pm-suspend which also locks screen with lock-screen.sh

#### acpi/brightness.sh

This script sets/checks the current screen brightness.

**Background**: on my notebook the brightness set by `/sys/class/backlight/acpi_video0/brightness`
gets applied correctly only when set to certain values. All other values are processed incorrectly.
All power-management services don't aware about that so I use that script to make them set only
allowed values.

**Usage**:
* browse the script and set varialbes:
  * BRFILE which is location of file in /sys to change brightness
  * BRVALS which is a list of permitted brightness values. If any value works for you, you just set it to the list
of values for brightness you desire
* `video-brightness.sh up` to increase brightness to the next value in the list
* `video-brightness.sh down` to decrease brightness to the previous value in the list
* `video-brightness.sh check` to set brightness to the value in the list which is the closest to the current one

#### test-acpi-brightness.sh

This script tests is used to check for the permitted values for ACPI brightness.

Run it as root and watch for values for brightness and brightness changes.
