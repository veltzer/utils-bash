#!/bin/bash

<<'COMMENT'

this is taken from http://stackoverflow.com/questions/1137884/is-there-an-open-source-css-validator-that-can-be-run-locally
(mark veltzer)
W3C CSS Validator Install Script --------------
installs W3C CSS Validator
requires: ant, wget, javac
see: http://jigsaw.w3.org/css-validator/DOWNLOAD.html
see: http://esw.w3.org/CssValidator
see: http://thecodetrain.co.uk/2009/02/running-the-w3c-css-validator-locally-from-the-command-line/
see: http://stackoverflow.com/a/3303298/357774
wget "http://www.w3.org/QA/Tools/css-validator/css-validator.jar"
sudo aptitude install -y ant # uncomment if you don't have ant

COMMENT

CVSROOT=:pserver:anonymous:anonymous@dev.w3.org:/sources/public cvs checkout 2002/css-validator
mkdir 2002/css-validator/lib
TOMCAT6_VERSION='6.0.37'
wget "http://www.apache.org/dist/tomcat/tomcat-6/v$TOMCAT6_VERSION/bin/apache-tomcat-$TOMCAT6_VERSION.tar.gz"
tar xvf apache-tomcat-$TOMCAT6_VERSION.tar.gz
mv apache-tomcat-$TOMCAT6_VERSION/lib/servlet-api.jar 2002/css-validator/lib/servlet.jar
rm -rf apache-tomcat-$TOMCAT6_VERSION apache-tomcat-$TOMCAT6_VERSION.tar.gz
cd 2002/css-validator
ant jar
# usage example: java -jar css-validator.jar "http://csszengarden.com/"
