#!/bin/sh

# path to your brightness file
BRFILE="/sys/class/backlight/acpi_video0/brightness"

# possible values for brightness
BRVALS="20 25 30 35 40 45 50 55 60 65 70 80 90 100"


###### Don't edit anything below this line ######

#
# Produce a message and exit with error
#
fail() {
  echo "$(basename $0)[$$]: $@"
  exit 1
}


#
# Find index in array matching the first param
#
index() {
  local NUM=$1
  shift
  local ARRAY="$*"

  [ -z "${ARRAY}" ] && fail "index(): at least two parameters are required"

  # process array
  set -- $(echo "${ARRAY}")
  LAST="$(eval "echo $"$# )"

  # edge cases
  [ ${NUM} -lt $1 ] && echo 1 && return
  [ ${NUM} -gt ${LAST} ] && echo $# && return

  # save previous array value (to avoid extra calculations)
  PREVVAL="$1"
  PREVINDEX=1

  # find the first index which is greater or equal than the value
  for I in $(seq 2 $#); do
    VAL="$(eval "echo $"${I} )"

    if [ ${NUM} -gt ${VAL} ]; then
      # save previous array value (to avoid extra calculations)
      PREVVAL="${VAL}" 
      PREVINDEX="${I}" 

      continue
    fi

    # if the matched number is closer to the previous value print that one
    # instead of the current
    DELTAPREV="$(( ${NUM} - ${PREVVAL} ))"
    DELTAVAL="$(( ${VAL} - ${NUM} ))"

    if [ "${DELTAPREV}" -gt "${DELTAVAL}" ]; then
      echo "${I}"
    else
      echo "${PREVINDEX}"
    fi

    return # we've find the index, nothing to process left
  done
}

#### Main program starts here ####

which bc > /dev/null || fail "'bc' program is required for this script"

case "$1" in
  up) OP="+ 1" ;;
  down) OP="- 1" ;;
  check) OP="" ;;
  *) fail "Wrong operation specified: ${OP}" ;;
esac

CURVALUE="$(cat "${BRFILE}")"
CURINDEX="$( index "${CURVALUE}" "${BRVALS}" )"
NEWINDEX="$(( ${CURINDEX} ${OP} ))"

# edge cases
set -- $(echo "${BRVALS}")
[ ${NEWINDEX} -lt 1 ] && NEWINDEX=1
[ ${NEWINDEX} -gt $# ] && NEWINDEX=$#

TARGET="$(eval "echo $"${NEWINDEX} )"

sleep 0.1 # don't race with other brightness controls
echo $TARGET > /sys/class/backlight/acpi_video0/brightness

cat "${BRFILE}" >> /tmp/brightness # for commandline debugging
