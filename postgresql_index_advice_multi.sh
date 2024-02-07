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

# Port is first argument
PORT=$1

# DBname is second argument
DBNAME=$2

# Input file is the third argument
INFILE=$3

# Check SQL file 
if [ ! -f ${INFILE} ]; then
    echo "   ERROR: Missing or invalid input file '${INFILE}'"
    echo
    exit 2
fi

# Initialise global variables
LINE=""
SQLSTMT=""
PIA="./postgresql_index_advice.sh"

# Function to process a single line of input from file
process_line () {
    if [ -n "${LINE}" ]; then
        # Add the new line read to the SQL statement being built
        SQLSTMT+=" ${LINE} "
    fi

    # Check if we have end of SQL statement
    if printf '%s\n' "$LINE" | grep -q ";[ ]*$"; then
        echo
        echo "Processing \"$SQLSTMT\""
        # Execute postgresql_index_advice.sh
        $PIA $PORT $DBNAME \"${SQLSTMT}\"
        # Reset SQL statement as latest is concluded by ;
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

# End 