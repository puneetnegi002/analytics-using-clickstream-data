
##user table

CREATE external TABLE IF NOT EXISTS clickstream.users(swid STRING, birth_dt STRING, 
gender_cd STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED by '\t' 
location '/user/cloudera/clickstream/users'
tblproperties("skip.header.line.count"="1");


##product table

CREATE external TABLE IF NOT EXISTS clickstream.products(url STRING, category STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED by '\t'
location '/user/cloudera/clickstream/products'
tblproperties("skip.header.line.count"="1");


##omniture_logs

CREATE EXTERNAL TABLE if not EXISTS omntlog(col_1 STRING, col_2 STRING, col_3 STRING,col_4 STRING,
col_5 STRING,col_6 STRING,col_7 STRING,col_8 STRING,col_9 STRING,col_10 STRING,
col_11 STRING,col_12 STRING,col_13 STRING,col_14 STRING,col_15 STRING, col_16 STRING, 
col_17 STRING,Col_18 STRING,col_19 STRING,COl_20 STRING,COl_21 STRING,Col_22 STRING,
Col_23 STRING,col_24 STRING,col_25 STRING,col_26 STRING,col_27 STRING,col_28 STRING,
col_29 STRING,col_30 STRING,col_31 STRING,col_32 STRING,col_33 STRING,col_34 STRING,
col_35 STRING,col_36 STRING,col_37 STRING,col_38 STRING,col_39 STRING,col_40 STRING,
col_41 STRING,col_42 STRING,col_43 STRING,col_44 STRING,col_45 STRING,col_46 STRING,
col_47 STRING,col_48 STRING,col_49 STRING,col_50 STRING,col_51 STRING,col_52 STRING,
col_53 STRING,col_54 STRING) ROW FORMAT DELIMITED FIELDS TERMINATED by '\t' 
stored as TEXTFILE
location '/user/cloudera/clickstream/omniture'
tblproperties("skip.header.line.count"="1");


##Refined_omniture_table

CREATE VIEW omniture AS SELECT col_1 sessionid,COL_2 timestp,COL_8 ipaddress,COL_13 url,COL_14 sw_id,
COL_50 city,COL_51 country,COL_53 state FROM omntlog;

##Refined_user_table_after_calculating_age

create table reguser as select swid,CAST(DATEDIFF(FROM_UNIXTIME(UNIX_TIMESTAMP()),
FROM_UNIXTIME(UNIX_TIMESTAMP(birth_dt,'dd-MMM-yy')))/365 as int) as age,gender_cd as gender from users


##Final_table_for visualizating_and_analysing

create table  final_omnitt as select o.*,p.category as category,
u.gender as gender,u.age as age 
from omniture o inner join products p on o.url=p.url  
left outer join reguser u on substr(o.sw_id,2,length(sw_id)-2)=u.swid

