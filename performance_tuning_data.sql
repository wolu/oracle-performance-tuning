------------------------------------------------------------
-- Topic:      Performance tuning Tables Creation script
-- File Name:  performance_tuning_data.sql
-- Author:     tinitiate.com, Venkata Bhattaram
-- Notes:      1) This script creates 5 tables
--             2) tinitiate_small_table   10 Rows
--                tinitiate_medium_table  25000 Rows
--                tinitiate_big_table     200000 Rows
--                tinitiate_large_table   1 Million Rows
--                tinitiate_huge_table    100 Million Rows
--                tinitiate_part_huge_table 
--                        100 Million Rows Partioned table
--             3) Creates Indexes
--
------------------------------------------------------------
declare
   procedure ei (i_sql in varchar2)
   as
   begin
      execute immediate i_sql;
   exception
      when others then null;
   end;
begin
   ei ('drop table tinitiate_small_table');
   ei ('drop table tinitiate_medium_table');
   ei ('drop table tinitiate_big_table');
   ei ('drop table tinitiate_large_table');
   ei ('drop table tinitiate_huge_table');
   ei ('drop table tinitiate_part_huge_table');
end;
/

-- Small Table (10 Rows)
create table tinitiate_small_table
as
select   level    as   st_id            -- Integer Type
        ,sysdate-level
                  as   st_date          -- Varchar2
        ,to_char( sysdate-level, 'Day Month yyyy')
                  as   st_date_char     -- Varchar2
        ,dbms_random.string('a',length(level)*3)
                  as   st_string_data_1 -- Varchar2
        ,dbms_random.string('x',length(level)*3)||dbms_random.string('U',length(level)*3)
                  as   st_string_data_2 -- Varchar2
        ,dbms_random.string('X',length(level)*3)
                  as   st_string_data_3 -- Varchar2
        ,dbms_random.value
                  as   st_value         -- number
from    dual
connect by level < 11;

-- Medium Table (25000 Rows)
create table tinitiate_medium_table
as
select   level    as   mt_id            -- Integer Type
        ,decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                  as   st_join_col      -- Integer Type
        ,ceil(dbms_random.value(1,50))
                  as   join_col         -- Integer 
        ,sysdate-decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                  as   mt_date          -- Date Type
        ,to_char( sysdate-decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                 ,'Day Month yyyy')
                  as   mt_date_char     -- Varchar2
        ,dbms_random.string('a',length(level)*3)
                  as   mt_string_data_1 -- Varchar2
        ,dbms_random.string('x',length(level)*3)||dbms_random.string('U',length(level)*3)
                  as   mt_string_data_2 -- Varchar2
        ,dbms_random.string('X',length(level)*3)
                  as   mt_string_data_3 -- Varchar2
        ,dbms_random.value
                  as   mt_value         -- number
from    dual
connect by level < 10001;

-- Big Table (200000 Rows)
create table tinitiate_big_table
as
select   level    as   bt_id            -- Integer
        ,decode(trunc((level-1)/10000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                  as   st_join_col      -- Integer
        ,ceil(dbms_random.value(1,50))
                  as   join_col         -- Integer
        ,sysdate-decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                  as   bt_date          -- Date Type
        ,to_char( sysdate-decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                 ,'Day Month yyyy')
                  as   bt_date_char     -- Varchar2
        ,dbms_random.string('a',length(level)*3)
                  as   bt_string_data_1 -- Varchar2
        ,dbms_random.string('x',length(level)*3)||dbms_random.string('U',length(level)*3)
                  as   bt_string_data_2 -- Varchar2
        ,dbms_random.string('X',length(level)*3)
                  as   bt_string_data_3 -- Varchar2
        ,dbms_random.value
                  as  bt_value          -- number
from    dual
connect by level < 100001;

-- Large Table (1 Million Rows)
create table tinitiate_large_table
as   
select   level    lt_id                   -- Integer Type
        ,sysdate - decode(trunc((level-1)/10000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                  as  lt_date             -- Date Type
        ,ceil(dbms_random.value(1,50))
                  as  join_col
        ,to_char( sysdate - decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                 ,'Day Month yyyy')
                  as  lt_date_char        -- Varchar2
        ,dbms_random.string('a',length(level)*3)
                  as  lt_string_data_1    -- Varchar2
        ,dbms_random.string('x',length(level)*3)||dbms_random.string('U',length(level)*3)
                  as  lt_string_data_2    -- Varchar2
        ,dbms_random.string('X',length(level)*3)
                  as  lt_string_data_3    -- Varchar2           
        ,dbms_random.value
                  as  lt_value            -- number
from    dual
connect by level < 1000001;

-- Huge Table (100 Million Rows)
create table tinitiate_huge_table
as
select   level    as  ht_id            -- Integer Type
        ,sysdate-decode(trunc((level-1)/10000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                  as  ht_date          -- Date Type
        ,ceil(dbms_random.value(1,50))
                  as  join_col
        ,to_char( sysdate-decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                 ,'Day Month yyyy')
                  as  ht_date_char     -- Varchar2
        ,dbms_random.string('a',length(level)*3)
                  as  ht_string_data_1 -- Varchar2
        ,dbms_random.string('x',length(level)*3)||dbms_random.string('U',length(level)*3)
                  as  ht_string_data_2 -- Varchar2
        ,dbms_random.string('X',length(level)*3)
                  as  ht_string_data_3 -- Varchar2
        ,dbms_random.value
                  as  ht_value         -- number
from    dual
connect by level < 100000001;

-- Huge Partitioned Table (100 Million Rows)
create table tinitiate_part_huge_table
    ( ht_id            integer
     ,ht_date          date
     ,join_col         number 
     ,ht_date_char     varchar2(4000)
     ,ht_string_data_1 varchar2(4000)
     ,ht_string_data_2 varchar2(4000)
     ,ht_string_data_3 varchar2(4000)
     ,ht_value         number
)
PARTITION BY RANGE (join_col)
INTERVAL(1)
( 
   PARTITION pht_p1 VALUES LESS THAN (2),
   PARTITION pht_p2 VALUES LESS THAN (3)
); 

insert into tinitiate_part_huge_table
select   level    as  ht_id            -- Integer Type
        ,trunc(sysdate-decode(trunc((level-1)/10000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9))
                  as  ht_date          -- Date Type
        ,ceil(dbms_random.value(1,50))
                  as  join_col
        ,to_char( sysdate-decode(trunc((level-1)/1000),0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9)
                 ,'Day Month yyyy')
                  as  ht_date_char     -- Varchar2
        ,dbms_random.string('a',length(level)*3)
                  as  ht_string_data_1 -- Varchar2
        ,dbms_random.string('x',length(level)*3)||dbms_random.string('U',length(level)*3)
                  as  ht_string_data_2 -- Varchar2
        ,dbms_random.string('X',length(level)*3)
                  as  ht_string_data_3 -- Varchar2
        ,dbms_random.value
                  as  ht_value         -- number
from    dual
connect by level < 100000001;

create index idx_local_tin_part_huge on tinitiate_part_huge_table(ht_string_data_1) LOCAL;
create index idx1_global_tin_part_huge on tinitiate_part_huge_table(join_col,ht_date);
create index idx2_global_tin_part_huge on tinitiate_part_huge_table(join_col) local;

commit;
--
