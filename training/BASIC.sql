create or replace database featuredemo;

show shares;

use database featuredemo;

CREATE OR REPLACE TABLE SUPPLIER as (select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER);

select * from information_schema.tables where table_schema = 'PUBLIC';

select * from supplier limit 10;

-- CLONING
create or replace table supplier_like like supplier;
create or replace table supplier_clone clone supplier;

-- Operations on the clone
select * from supplier_clone where s_name = 'Supplier#000000002';


delete from supplier_clone where s_name = 'Supplier#000000002'; -- note down the query id of this statement

select * from supplier
where s_name = 'Supplier#000000002'; -- data retained in supplier table

desc table supplier;

select * from supplier_clone where s_name = 'Supplier#000000002' ;

select * from supplier_clone before(statement => '01aa03b0-3201-9151-0000-0001beb22219')  where s_name = 'Supplier#000000002' ;

-- Time travel with offset command
select * from supplier_clone at(offset => -60*5) where s_name = 'Supplier#000000002';

-- drop and undrop
drop table supplier;
undrop table supplier;

-- swap table
alter table supplier_clone swap with supplier;
