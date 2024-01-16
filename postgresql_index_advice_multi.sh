#!/bin/bash
#
# Script to read a *.sql file with multiple (and multi-line) SQL statements
# and then to feed them to postgresql_index_advice.sh
#

#
# TODO: Show usage by default or with --help or lack of argument
#
print_usage () {
    echo "USAGE: $0 <filename with multiple SQL statements>"
    echo
}

if [ "$#" -ne 1 ]; then
    print_usage
    exit 1
fi

if [ "$1" == "--help" ]; then
    print_usage
    exit 0
fi

# Input file is the first argument
INFILE=$1

#
# TODO: Check existance of INFILE
# TODO: Call postgresql_index_advice.sh with single SQL statement on commandline
#
# CURRENTLY: This expects a blank line at the end of the file

#INFILE="testinput.sql"
LINE=""
SQLSTMT=""

process_line () {
    SQLSTMT+="${LINE} "
    if printf '%s\n' "$LINE" | grep -q ";[ ]*$"; then
        echo "$SQLSTMT"
        SQLSTMT=""
    fi

}
while read -r LINE
do
    process_line
done < "$INFILE"
process_line
