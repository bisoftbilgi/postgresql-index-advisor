# postgresql-index-advisor.sh
bash script give sql statement it advices missing indexes and index create script on database .
Run on postgresql database server as postgres operating system user.

parameters : 1. postgresql port number 2. database name 3. sql statement

example :
[postgres@node01 ~]$  sh postgresql_index_advice.sh 5432 dvdrental "select * from customers c,payments p where c.customer_id=p.customer_id and p.rental_id=10 and c.store_id=20; "

output : table | index_create_script | psql_bash_command
***************
table:customers adviced_index_columns:store_id  index_create_script : create index ix_sample_20230912085328 on customers ( store_id)  psql_bash_command: psql -p5432 -d dvdrental -c "create index ix_sample_20230912085328 on customers ( store_id)"
table:payments adviced_index_columns:rental_id  index_create_script : create index ix_sample_20230912085329 on payments ( rental_id)  psql_bash_command: psql -p5432 -d dvdrental -c "create index ix_sample_20230912085329 on payments ( rental_id)"

