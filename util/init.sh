#!/bin/bash
KEYFILE=~/.ssh/sandy-box_rsa
SRCDIR="$( dirname "${BASH_SOURCE[0]}" )"
set -e
error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  read -p "Press any key to exit..."
  exit "${code}"
}
trap 'error ${LINENO}' ERR

bash $SRCDIR/ensure_key.sh