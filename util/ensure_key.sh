#!/bin/bash
KEYFILE=~/.ssh/sandy-box_rsa
echo -en "Testing connection ... "
target=192.168.7.2
count=$( ping -c 1 $target | grep icmp* | wc -l )

if [ $count -eq 0 ]; then
    echo -en "not ok\n"
    echo "Can not ping host."
    echo "Please make sure the Sandy-Box is connected to your computer."
    echo "Make sure all drivers are installed and networking is working correctly."
    exit 1
else
    echo -en "ok\n"
fi

function generate_key {
    echo "Generating new RSA key ..."
    ssh-keygen -t rsa -f $KEYFILE -N ''
}

function copy_key {
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Copying key to host - please enter the password machinekit"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    cat "$KEYFILE.pub" | ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null machinekit@192.168.7.2 "mkdir -p .ssh; touch .ssh/authorized_keys; cat >> .ssh/authorized_keys"
}

if ! [ -e "$KEYFILE" ]; then
    echo "No RSA key found."
    generate_key
    copy_key
else
    echo -en "Testing existing RSA key ... "
    ssh -i $KEYFILE -oBatchMode=yes -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null machinekit@192.168.7.2 true 2> /dev/null
    if ! [ $? -eq 0 ]; then
        echo -en "RSA Key not accepted\n"
        copy_key
    else
        echo -en "ok\n"
        exit 0
    fi
fi
