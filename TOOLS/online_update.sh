#!/usr/bin/env bash
if [ ! "$BASH_VERSION" ] ; then
    echo "Warning: this script should be executed with bash"
    exec /bin/bash "$0"
fi
cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../System/update
python update.py
read -p "Press any key to exit..."
