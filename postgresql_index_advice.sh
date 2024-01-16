psql -p$1 -d $2 -c "explain $3"  -t -o explain.out
 prev=
cat explain.out | grep   -A 3  "Seq Scan" | grep  -B 2  Filter |while read line
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
          echo "table:${tablo} adviced_index_columns:${kolonlar} index_create_script : ${index_create_script}  psql_bash_command: psql -p$1 -d $2 -c \"${index_create_script}\" "
      fi
 fi
    prev="${line}"
done
