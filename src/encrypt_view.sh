#!/bin/bash

# This is based on:
# https://github.com/ptarjan/viencrypt/blob/master/viencrypt

# extract the basename of this script
my_name=$0
my_name=${my_name##*/}
my_name=${my_name%.*}
key=

# -n: no swap file will be used
# -i NONE: no .viminfo file updates
editor="vim -n -i NONE -M"
# shellcheck source=/dev/null
source "$HOME/.config/encrypt.sh"

filename="passwords.gpg"
if [ $# -eq 0 ]
then
    echo "No filename specified. Using default [$filename]"
elif [ $# -gt 1 ]
then
    echo "$0 [filename.gpg]"
    exit 2
else
    filename=$1
fi

if [ "$(command -v shred)" ]
then
    rm='shred -u'
elif [ "$(command -v srm)" ]
then
    rm='srm -z'
else
    rm='rm'
fi

if [ ! -f "$filename" ]
then
    echo "$filename doesn't exist."
    exit 1
elif [ ! -r "$filename" ]
then
    echo "$filename isn't readable."
    exit 2
fi

tmp=$(mktemp --tmpdir="$HOME/tmp" -t "$my_name.XXXXXXXXXX") || exit 1

# decrypt into the tmp file
gpg --quiet --decrypt --default-key "$key" --batch "$filename" > "$tmp"
gpg_code=$?
# if gpg didn't work, exit with the exit code of gpg
if [ "$gpg_code" != 0 ]
then
    $rm "$tmp"
    echo "could not decrypt file with code [$gpg_code]"
    exit "$gpg_code"
fi

# edit the file
$editor "$tmp"

$rm "$tmp"
