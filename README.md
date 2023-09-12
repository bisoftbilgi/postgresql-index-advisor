# postgresql-index-advisor.sh
bash script give sql statement it advices missing indexes and index create script on database 

parameters : 1. postgresql port number 2. database name 3. sql statement

example :
[postgres@node01 ~]$  sh postgresql_index_advice.sh 5432 dvdrental "select * from payments where payment_id=10  "
output
table:payments adviced_index_columns:payment_id  index_create_script : create index ix_sample_20230912072356 on payments ( payment_id)  psql_bash_command: psql -p5432 -d dvdrental -c "create index ix_sample_20230912072356 on payments ( payment_id)"
