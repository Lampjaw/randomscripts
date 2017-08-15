#! /bin/bash

SCRIPT_CALLER=`basename $0 .sh`

DEFAULT_LOGDIRECTORY="/var/log/scriptlogger"
DEFAULT_LOGFILE="$SCRIPT_CALLER.log"

LOGDIRECTORY=$DEFAULT_LOGDIRECTORY
LOGFILE=$DEFAULT_LOGFILE

while getopts p:f: option; do
  case "${option}" in
    p) LOGDIRECTORY=${OPTARG};;
    f) LOGFILE=${OPTARG};;
  esac
done

echo "Creating log: ${LOGDIRECTORY}/${LOGFILE}"

mkdir -p $LOGDIRECTORY

logLine() {
    while IFS='' read -r line; do
        LOGTIMESTAMP=`date "+%F %T"`
        echo "[$LOGTIMESTAMP] $line" >> "${LOGDIRECTORY}/${LOGFILE}"
    done
}

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1> >(logLine) 2>&1
