#!/bin/bash
if [ -z "$BASH_SOURCE" ]; then
cd "$(dirname "$(readlink -f "$0")")"
else
cd "$(dirname "${BASH_SOURCE[0]}" )"
fi
ARCH=`uname -m`
if [ "$ARCH" = "x86_64" ]; then
   cd ./linux_x64
elif [ "$ARCH" = "i686" ]; then
   cd ./linux_x86
else
   echo "Unsupported CPU architecture \"$ARCH\""
   read -p "Press any key to continue"
   exit 1
fi
sh machinekit-client --config ../bbb.json
if [ $? -ne 0 ]; then
   read -p "Something went wrong, press [Enter] to continue..."
fi
