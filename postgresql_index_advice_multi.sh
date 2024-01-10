#!/bin/bash
#
# Script to read a *.sql file with multiple (and multi-line) SQL statements
# and then to feed them to postgresql_index_advice.sh
#

#
# TODO: Show usage by default or with --help
#

#
# TODO: Print different SQL statements (even if they are multi line)
#
# CURRENTLY: This expects a blank line at the end of the file

INFILE="testinput.sql"
LINE=''

while read -r LINE
do
    echo -n "$LINE "
    printf '%s\n' "$LINE" | grep -q ";[ ]*$" && echo 
done < "$INFILE"
