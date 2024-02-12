#!/bin/bash
#
# Script to get a single SQL statement with PosgreSQL connection info
# and recomment index creations analyzing execution plan of the SQL statement
# 
# USAGE: postgresql_index_advice.sh <port> <database> "<SQL statement>;"
# 

print_usage () {
    echo '   USAGE: $0 <port> <database> "<SQL statement>;"'
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

# Get execution plan of the SQL statement in provided PostgreSQL
psql -p$1 -d $2 -c "explain $3"  -t -o explain.out
prev=
cat explain.out | grep -A 3 "Seq Scan" | grep -B 2 Filter | while read line
do
    if [ ! -z "${prev}" ];then
        line1=`echo "${prev}" | grep -E 'Scan.*on\s*([a-zA-Z]+\w*)' `
        line2="${line}"
        tablo=`echo  "${line1}  ${line2}" | grep -E 'Scan.*on\s*([a-zA-Z]+\w*)'  | grep 'Seq Scan' | sed 's/.*Seq Scan on//'  | sed 's/ (cost.*//' | awk '{print $1;}'`
        kolonlar=`echo  "${line1}  ${line2}" | grep -E 'Scan.*on\s*([a-zA-Z]+\w*)'  | grep 'Filter' | sed 's/.*Filter: //'  `
        kolonlar=`echo "${kolonlar}" | grep --perl-regexp '\w+ (?==)'  --only-matching  | sort |  awk '{print}' ORS=''  `
        if [ ! -z "${kolonlar}" ];then
        	index_create_script=`echo "${kolonlar/ /,})"`
        	index_create_script=${index_create_script/,)/)}
        	index_create_script=`echo  "create index ix_sample_$(date '+%Y%m%d%H%M%S') on ${tablo} ( ${index_create_script}"`
        #	echo "table:${tablo} \n adviced_index_columns:${kolonlar} index_create_script : ${index_create_script}  psql_bash_command: psql -p$1 -d $2 -c \"${index_create_script}\" "
        	printf "************ ADVICE below  *************\ntable => ${tablo} \nadviced_index_columns => ${kolonlar} \nindex_create_script => ${index_create_script} \npsql_bash_command => psql -p$1 -d $2 -c \"${index_create_script}\"  \n*************** ADVICE above *************"
        fi
    fi
    prev="${line}"
done

echo

# End