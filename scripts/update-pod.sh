#!/bin/bash
# SPDX-FileCopyrightText: 2023 Deminder <tremminder@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Script to update main.pot and *.po files
#
# This Script is released under GPL v3 license
# Copyright (C) 2021 Javad Rahmatzadeh (changed)

set -e

# cd to the repo root
cd "$( cd "$( dirname "$0" )" && pwd )/.."

xgettext \
    --from-code=UTF-8 \
    --package-name="osd-volume-number" \
    --package-version="v`grep -oP '^ *?\"version\": *?\K(\d+)' src/metadata.json`" \
    --keyword="gtxt" \
    --keyword="_n:1,2" \
    --keyword="C_:1c,2" \
    --output="po/main.pot" \
    src/*.js src/schemas/*.xml

for file in po/*.po
do
    echo -n "Updating $(basename "$file" .po)"
    msgmerge -U "$file" po/main.pot

    if grep --silent "#, fuzzy" "$file"; then
        fuzzy+=("$(basename "$file" .po)")
    fi
done

if [[ -v fuzzy ]]; then
    echo "WARNING: Translations have unclear strings and need an update: ${fuzzy[*]}"
fi
