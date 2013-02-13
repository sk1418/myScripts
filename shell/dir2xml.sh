#!/bin/bash
#############################################################
# convert a directory tree structure to xml file.
# 
# Usage: dir2xml <direcotry>
# Version 1.0   -  2011.02.10
#
# Author: Kai Yuan (Kent.yuan at gmail dot com)
# 
#############################################################

toXml(){

    local DIR="$1"
    local OUTFILE="$2"
    local BASENAME=""


    #check if the dir is empty
    ls "$DIR"/* &>/dev/null
    if [ $? -ne 0 ]; then
        echo "<dir name=\"$(basename "$DIR")\"/>" >> $OUTFILE
        return
    fi
    
    echo "<dir name=\"$(basename "$DIR")\">" >> $OUTFILE

    for file in `ls -d --group-directories-first "$DIR"/*`
    do
        if [ -d "$file" ]; then
            toXml "$file" "$OUTFILE"
        elif [ -f "$file" ]; then
            echo "<file>$(basename "$file")</file>" >> $OUTFILE
        fi
    done

    echo "</dir>" >> $OUTFILE

}


XMLFILE=`pwd`"/$(basename "$1")".xml

SHORTNAME=`basename $XMLFILE`
if [ -e $XMLFILE ]; then
    echo "output xml file "$SHORTNAME" exists, rename to $SHORTNAME.`date +%y%m%d%k%M%S`"
    mv "$XMLFILE" "$XMLFILE.`date +%y%m%d%k%M%S`"
fi
touch $XMLFILE

toXml "$1" "$XMLFILE"
sed -i "s/&/&amp;/g" $XMLFILE > /dev/null
xmllint -format "$XMLFILE" --output "$XMLFILE"
echo "$XMLFILE generated."
