#!/bin/bash -e

: <<'COMMENT'

This script checks the books database.

TODO:
- fixup the code so it will work with the a suffixes

This code does not work because of incorrect expansion
the list of suffixes we support for book content
suff=(chm tar.bz2 pdf ps html dvi lit doc djvu zip rtf txt pdb mht)
cmd=""
for x in ${suff[*]}
do
	cmd="$cmd -and -not -name '*.$x'"
done
echo $cmd
this checks that the files are of the right type
find . -mindepth 1 -type f $cmd

COMMENT

# first check that we are in the right folder
if [[ ! -d by_name ]]
then
	echo "put me in the folder where by_name is..."
	exit 1
fi

folders=(by_name by_topic)

echo "EXTENSION PROBLEMS"
find "${folders[@]}" -mindepth 2 -type f -and -not -name "*.chm" -and -not -name "*.tar.bz2" -and -not -name "*.pdf" -and -not -name "*.ps" -and -not -name "*.html" -and -not -name "*.dvi" -and -not -name "*.lit" -and -not -name "*.doc" -and -not -name "*.djvu" -and -not -name "*.zip" -and -not -name "*.rtf" -and -not -name "*.txt" -and -not -name "*.pdb" -and -not -name "*.mht" -and -not -name "*.rar" -and -not -name "*.jpg" -and -not -name "*.js" -and -not -name "*.gif" -and -not -name "*.epub" -and -not -name "*.mobi" -and -not -name "*.nfo" -and -not -name "*.tar.xz"
echo "FILE PERMISSION PROBLEMS"
find "${folders[@]}" -mindepth 2 -type f -and -not -perm 444
echo "FOLDER PERMISSION PROBLEMS"
find "${folders[@]}" -mindepth 2 -type d -and -not -perm 775
echo "DEPTH PROBLEMS"
find by_name -mindepth 4 -type f
echo "ARTICLES FILE PERMISSION PROBLEMS"
find articles -mindepth 2 -type f -and -not -perm 444
echo "ARTICLES EXTENSIONS"
find articles -mindepth 2 -type f -and -not -name "*.pdf"
