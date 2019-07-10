#!/bin/bash

<<'COMMENT'

The script is stolen from http://stackoverflow.com/questions/1137884/is-there-an-open-source-css-validator-that-can-be-run-locally

COMMENT

set -e

mkdir -p lib
curl -LO http://www.w3.org/QA/Tools/css-validator/css-validator.jar
echo "\
http://repo1.maven.org/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar
http://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar
http://repo1.maven.org/maven2/org/w3c/jigsaw/jigsaw/2.2.6/jigsaw-2.2.6.jar jigsaw.jar
http://repo1.maven.org/maven2/org/ccil/cowan/tagsoup/tagsoup/1.2/tagsoup-1.2.jar
http://repo1.maven.org/maven2/org/apache/velocity/velocity/1.7/velocity-1.7.jar
http://repo1.maven.org/maven2/xerces/xercesImpl/2.11.0/xercesImpl-2.11.0.jar xercesImpl.jar
http://repo1.maven.org/maven2/nu/validator/htmlparser/htmlparser/1.2.1/htmlparser-1.2.1.jar\
" | while read url shortname; do
	if [ -z "$shortname" ]; then
		shortname="${url##*/}"
	fi
	curl -L -o "lib/${shortname}" "${url}"
done
