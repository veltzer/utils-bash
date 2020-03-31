#!/bin/sh

# This is based on:
# https://github.com/ptarjan/viencrypt/blob/master/viencrypt

# extract the basename of this script
my_name=$0
my_name=${my_name##*/}
my_name=${my_name%.*}

# -n: no swap file will be used
# -i NONE: no .viminfo file updates
editor="vim -n -i NONE"
. $HOME/.config/encrypt.sh

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

if [ `which shred` ]
then
    rm='shred -u'
elif [ `which srm` ]
then
    rm='srm -z'
else
    rm='rm'
fi

if [ ! -f $filename ]
then
    echo "$filename doesn't exist. Starting from empty file."
    exit 1
elif [ ! -r $filename ]
then
    echo "$filename isn't readable."
    exit 2
elif [ ! -w $filename ]
then
    echo "$filename isn't writable."
    exit 3
fi

tmp=`mktemp --tmpdir=$HOME/tmp -t $my_name.XXXXXXXXXX` || exit 1

# decrypt into the tmp file
gpg --quiet --decrypt --default-key $key --batch $filename > $tmp
gpg_code=$?
# if gpg didn't work, exit with the exit code of gpg
if [ $gpg_code != 0 ]
then
    $rm $tmp
    echo "could not decrypt file with code [$gpg_code]"
    exit $gpg_code
fi

# edit the file
$editor $tmp

# write changes back
gpg --default-key $key --batch --yes --output $filename --encrypt $tmp
gpg_code=$?
$rm $tmp
# if gpg didn't work, exit with the exit code of gpg
if [ $gpg_code != 0 ]
then
    exit $gpg_code
fi
