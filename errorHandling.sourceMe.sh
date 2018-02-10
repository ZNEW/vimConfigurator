#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------
# Error handling
PROGNAME=$(basename $0)

exitOnError()
{
  if [ "|$2|" = "||" ] || [ "|$3|" = "||" ]
  then
    echo "${PROGNAME}: ${1:-": Unknown Error"}" 1>&2
  else
    echo "${PROGNAME}: ${1:-": Unknown Error"} ($3, line $2) " 1>&2
  fi

	exit 1
}


