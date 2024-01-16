#!/bin/bash
#
# Script to read a *.sql file with multiple (and multi-line) SQL statements
# and then to feed them to postgresql_index_advice.sh
# 
# USAGE: postgresql_index_advice_multi.sh <port> <database> <regular file with multiple SQL statements>
# 

print_usage () {
    echo "   USAGE: $0 <port> <database> <regular file with multiple SQL statements>"
    echo
}

echo

if [ "$1" == "--help" ]; then
    print_usage
    exit 0
fi

if [ "$#" -ne 3 ]; then
    echo "   ERROR: Invalid number of arguments"
    echo
    print_usage
    exit 1
fi


# Input file is the third argument
INFILE=$3

# Check SQL file 
if [ ! -f ${INFILE} ]; then
    echo "   ERROR: Missing or invalid input file '${INFILE}'"
    echo
    exit 2
fi

#
# TODO: Call postgresql_index_advice.sh with single SQL statement on commandline
#

# Initialise global variables
LINE=""
SQLSTMT=""

# Function to process a single line of input from file
process_line () {
    if [ -n "${LINE}" ]; then
        # Add the new line read to the SQL statement being built
        SQLSTMT+="${LINE} "
    fi

    # Check if we have end of SQL statement
    if printf '%s\n' "$LINE" | grep -q ";[ ]*$"; then
        echo "$SQLSTMT"
        # Reset SQL statement as latest is concluded
        SQLSTMT=""
    fi
}

# Main loop
while read -r LINE
do
    process_line
done < "$INFILE"
# Handle last line (if any)
process_line
