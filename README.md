# PostgreSQL Index Advisor

This is a set of bash scripts to be used to analyze a single or a set of SQL statements in connection with a PostgreSQL database that will generate suggestions for indexes to be added.

## postgresql_index_advice.sh
`postgresql_index_advice.sh` is a bash script that takes an SQL statement and it advices missing indexes and index create script on database.

The script is to be run on PostgreSQL database server as `postgres` operating system user.

Usage:
`$ postgresql_index_advice.sh <postgresql port number> <database name> <SQL statement>`

Example:
```
[postgres@node01 ~]$  sh postgresql_index_advice.sh 5432 dvdrental "select * from customers c,payments p where c.customer_id=p.customer_id and p.rental_id=10 and c.store_id=20; "

output : table | index_create_script | psql_bash_command
***************
table:customers adviced_index_columns:store_id  index_create_script : create index ix_sample_20230912085328 on customers ( store_id)  psql_bash_command: psql -p5432 -d dvdrental -c "create index ix_sample_20230912085328 on customers ( store_id)"
table:payments adviced_index_columns:rental_id  index_create_script : create index ix_sample_20230912085329 on payments ( rental_id)  psql_bash_command: psql -p5432 -d dvdrental -c "create index ix_sample_20230912085329 on payments ( rental_id)"
```
## postgresql_index_advice_multi.sh
Script to read a *.sql file with multiple (and multi-line) SQL statements and then to feed them to `postgresql_index_advice.sh`


Usage:
`$ postgresql_index_advice_multi.sh <port> <database> <regular file with multiple SQL statements>`

Example:
```
[postgres@node01]$ /postgresql_index_advice_multi.sh  5432 dvdrental sql_statements.sql


Processing "select * from rent where inventory_id=10; "
************ADVICE*********************
table => rent 
adviced_index_columns => inventory_id  
index_create_script => create index ix_sample_20240208105022 on rent ( inventory_id) 
psql_bash_command => psql -p5432 -d dvdrental -c "create index ix_sample_20240208105022 on rent ( inventory_id)"  
***************ADVICE*****************

Processing "select * from rent where customer_id=100 and staff_id=20; "
************ADVICE*********************
table => rent 
adviced_index_columns => customer_id staff_id  
index_create_script => create index ix_sample_20240208105023 on rent ( customer_id,staff_id ) 
psql_bash_command => psql -p5432 -d dvdrental -c "create index ix_sample_20240208105023 on rent ( customer_id,staff_id )"  
***************ADVICE*****************
```

