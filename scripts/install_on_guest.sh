#!/bin/bash

# SPDX-FileCopyrightText: 2023 Deminder <tremminder@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

SSHCMD=ssh
# maybe source env file
[ ! -f guest-ssh.env ] || . guest-ssh.env

if [ ! -z "$1" ]; then
    SSHADDR="$1"
fi

if [ -z "$SSHADDR" ]; then
    echo Missing guest ssh address >&2
    exit 1
fi

# build with debugMode enabled
make zip
UUID=$(grep uuid src/metadata.json | cut -d\" -f 4)
ZIPFILE="$UUID".shell-extension.zip
rsync -e "$SSHCMD" target/"$ZIPFILE" "${SSHADDR}:~/Downloads/"
$SSHCMD "$SSHADDR" "gnome-extensions install --force ~/Downloads/$ZIPFILE && killall -SIGQUIT gnome-shell"
