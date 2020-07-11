#!/bin/sh

set -e

JOBBER_FILE=${JOBBER_WORK_HOME}/.jobber

echo "----- Starting Jobber Runner (daemon) -----"
echo "Jobber Work Home dir: ${JOBBER_WORK_HOME}"
echo "Jobber Job File used: ${JOBBER_FILE}"

# Unix socket for Jobber:
JOBBER_DATA_HOME="/var/jobber/$(id -u)"
mkdir -p "${JOBBER_DATA_HOME}"

# /usr/libexec/jobberrunner -u /var/jobber/0/cmd.sock ${JOBBER_FILE} >> /var/log/jobber.log 2>&1 
/usr/libexec/jobberrunner -u "${JOBBER_DATA_HOME}/cmd.sock" ${JOBBER_FILE}
