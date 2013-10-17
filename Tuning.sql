-- 
-- Oracle Performance Tuning
-- Venkata Bhattaram
-- Tinitiate.com
-- (c) on all CODE EXAMPLES
--

1) INTRODUCTION
   * Performance tuning or optimization is required to speedup the execution of DB operations.
   * It is job for Developers and DBAs at different magnitudes, Tuning is done at many levels depending 
     on the nature of the underlying issue for the performance bottleneck.
   * Most common tuning issue arises in poorly written SQL queries.
   * Other factors could be bad or unplanned database design
   * Some super big issues could be poor configuration and DB management.

2) The Query Optimizer

   * A SQL statement is executed by the optimizer.
   * The optimizer considers various factors 
      - Table statistics
         - Storage Characterstics
         - Partitions
         - Indexes
      - Hints provided in the Query
      - CPU
      - I/O
      - Memory   

===================================
==   OPERATIONS OF THE OPTIMIZER ==
===================================

   * Query Transformation
      The Optimizer rewrites the query
         - View Merging
           * rewrite joins with views, to push filters into the view query
         - Predicate Pushing
           * Pushes filter values to joins in UNIONs or VIEWs

         - SubQuery Unnesting
           * Optimizer changes the nested query to a join statement
           Example:
           [BEFORE]
               SELECT *
               FROM   sales
               WHERE  cust_id IN ( SELECT cust_id FROM customers );
           [AFTER]
               SELECT sales.*
               FROM   sales, customers
               WHERE  sales.cust_id = customers.cust_id;

         - Query rewrite with Materialized Views
            * When a Materialized View with Query Rewrite hint is created,
              The optimizer chooses between the table and Mat view when a query is issued
              aganist the table.
         - SubQuery UnNesting
           * Optimizer tries to un-nest the sub queries

   * Estimation
      - Selectivity is the Query predicate or filters.
      - Cardinality number of rows in a rowset in Table/View/SubQuery /InLineView.
      - Cost CPU, Memory and I/O
      * Access Path
         - Table Scan
            * Reads multiple data blocks in a single I/O.
         - Fast Full Index Scan
            * Reads multiple data blocks in a single I/O.
         - Index Scan
            * Read data blocks based on the levels in the b-tree
              and index clustering factor.

   * Bind Variable peeking 
   * Plan Generation
      - Checks Join Order, Query Transformation


==================================
==  OPERATIONS OF THE OPTIMIZER ==
==================================

Access paths are ways in which data is retrived from the Database.

1) FULL TABLE SCAN
   * All Blocks under the HighWaterMark are scanned.
   * Blocks are read sequentially.
   * Initialization parameter: DB_FILE_MULTIBLOCK_READ_COUNT, 
     will be used to read multiblocks for a better full table scan.
   * Full Table Scan Is Faster for Accessing Large Amounts of Data, 
     Making multiple index range scans (Smaller I/O) when accessing a
     large fraction  of the blocks in a table is more expensive.
     Full table scans can use larger I/O calls, and making  fewer large I/O 
     calls is cheaper than making many smaller calls.
   * Full Table Scans are made in the following cases:
      - Very Large data set (More block to scan)
      - Very Smll table
      - High Parallelism degree
      - Full Table Scan hint

2) RowId Scans
   * RowId is the unique identifier in a Database for a Row.
   * It spefcifies the datafile, data block of the row.
   * Optimized does a RowId scan when a index scan happens
   
      
===================================
==  DB Initialization Parameters ==
===================================



3) SQL tuning where to start ?
   * In order to fix something we need to understand what the problem is,
     Oracle provides with the various tools and options to dig through the SQL execution plan.

   ===============================
   = Explain Plan with PlanTable =
   ===============================
      1) Create the ExplainPlan

      Run the Command:
         EXPLAIN PLAN FOR
         select * from MyQuery;

      OR, to ID the plan

         EXPLAIN PLAN
         SET STATEMENT_ID = 'st1'
         FOR
         SELECT last_name FROM MyQuery;   

      2) View the explain plan

         SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
      
      3) Understanding the explain plan:
      



   =============
   = AutoTrace =
   =============

   ========================================================
   = GATHER_PLAN_STATISTICS and V$SQL_PLAN_STATISTICS_ALL =
   ========================================================

   ========================
   = SQL Best practicises =
   ========================
   1) InLine vs Sub-Query
       * Try to use in-line views, avoid subQueries and try to replace sub-queries with analytical functions.
       * Example
         -- BAD Query
            select empid,
                   (select global_id
                    from   global_employee ge
                    where  ge.emp_id = e.emp_id) as global_emp_id
            from   employees e;

         -- Better Query
            select empid,
                   global_id as global_emp_id
            from   employees e
            join   global_employee ge
                   on  ge.emp_id = e.emp_id;

   2) Try to partition tables which tend to grow very large, As partition pruning helps in SQL joins (eliminates lots of unnecessary I/O).
   3) Try to convert functions to Views, when using functions in SELECT clause.
   4) Try to use analytical functions in place of Group By clause, in sub queries.
   5) use WITH clause for repetitive subqueries in the same SQL.

3) Indexes

4) Hints

5) 
