#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------
log()
{
  #echo "${PROGNAME}${1:-": Unknown Log Message" }" 1>&2
  echo -e "$1" 1>&2
  return 0

  if [ "|$2|" = "||" ] || [ "|$3|" = "||" ]
  then
    echo -e "${1:-": Unknown Log Message"}" 1>&2
  else
    echo -e "$3, line $2: ${1:-": Unknown Log Message"}" 1>&2
  fi
}


