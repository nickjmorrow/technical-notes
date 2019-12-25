# Query Optimization

[The SQL server query optimizer](https://www.red-gate.com/simple-talk/sql/sql-training/the-sql-server-query-optimizer/)

The SQL Server Query Optimizer is a cost-based optimizer. It analyzes a number of candidate execution plans for a given query, estimates the cost of each of these plans and selects the plan with the lowest cost of the choices considered.

AdventureWorks database from CodePlex website

Sql Server Db Engine

- Storage Engine
  - Reading data between disk and memory. Optimize concurrency while maintaining data integrity
- Query Processor

  - Accepts all queries submitted to SQL server, devises a plan for their optimal execution, then executes plan and delivers results

- T-SQL: The Microsoft SQL Server extension to SQL
- SQL is declarative, it doesn't define steps to retrieve data, only the data to be retrieved

Query Processor

- query optimizer: devises plan and passes it to execution engine
- execution engine: actually execute plan and get results from the database

Query Processing Process

1. SQL statement
2. Parsing (-> parse tree)
3. Binding (-> algebrized tree)
   a. mostly name resolution
4. Query Optimization (-> execution plan)
5. Query Execution
6. Query Results

Some operations map to the same physical operation (like Sort), while others can be vary (JOIN -> Nested Loops Join, Merge Join, Hash Join)

Query optimizer estimaates cost of each plan and considers resources like I/O, CPI, and memory. This cost estimation depends mostly on the algorithm used by the physical operator, as well as the estimated number of records taht will need to be processed; this estimate of the number of records is known as the _cardinality estimation_.

SQL Server uses and maintains optimizer statistics, or info describing distirubtion of values in one or mroe columns of a table. Once cost of each operator is estimated using estimations of cardinality and resource demands, the Query Optimizer adds up the costs to estimate the cost of the entire plan.

If there is a valid plan in the plan cache, SSMS can skip the optimization process entirely.

Query plan may be bad if parameters are used in the query that result in different performance depending on parameters passed in.

Plans can be rendered invalid if certain metadata about the table changes, like an index is dropped and that plan used the index.

Plans may be removed when SSMS is under memory pressure or certain statements are executed, like changing max degree of parallelism will clear the entire plan cache.

Running `ALTER DATABASE` can also clear the entire plan cache if certain options are used.

Important to differentiate poor query performance between "Not giving query optimizer the info it needs" and "Query optimizer is limited in this capacity to choose an appropriate plan."

Hints allow you to override the query optimizer. They are dangerous. Ex - use hints to direct query optimizer to use a particular index or specific join algorithm. Can even specify a specific execution plan in XML format.

Even if the query optimizer searched the entire search space, caridnality and cost estimation errors can still make a query optimizer select the wrong plan.

SQL Server implemented ints own cost-based Quey Opt based on the cascades Framework in 1999. The extensible arch of the Casc Framew has made it much easier for new functionality, like transformation rules or physical poerators, to be implemented in the Query Optimizer. This allows the Query Opt to be tuned and improved.

Execution plans: Ultimately trees consistingo f a number of physical operators, which in turn contain algorithms ot produce results from the database

Logical join operation can be implemented by any of three different phys join operators: Nested Loops Join, Merge Join, or Hash Join

Operators may read from the database, or may read records from aonther operator
Physical operators implement the following three methods:

- Open(): causes an operator to be initialized
- GetRow(): request a row from the operator. operators can get rows from other operators by calling their GetRow() method. This method produces one row at a time. The acutal number of rows shown in the exec plan is how many times GetRow() was called. An additional call to GetRow() is used by the operator to indicate the enfo the result set.
- Close(): shut down the operator once it's performed its role

## Join Ordering

- number of possible plans in a search space grows rapidly depending on number of tables joined

* predicate which defines which columns are used to join the tables is called a join predicate
* a join works with only 2 tables at a time. a qeury requesting data from `n` tables must be executed as a sequence of `n - 1` joins. note that the first join does not have ot be completed before the next join can be started.

the optimizer needs to make two important decisions regarding joins: 1. the selection of a join order 2. the choice of a join algorithm

because of the _commutative_ and _associative_ properties of joins, even simple queries offer many different possible join orders. number increases exponentially with # of tabels that need to be joined. the task of QO is to find optimal sequence of JOINs between tables used in the query.

commutative property of a join:
`A JOIN B` is equivalent to `B JOIN A`

`(A JOIN B) JOIN C` is equivalent to `A JOIN (B JOIN C)`

The query optimizer may choose a more efficient join order than that proposed in the query. May also choose different physical operators (merge join vs hash match join) for each join.

`OPTION (FORCE ORDER)` can be used to enforce an order for the query optimizer to follow the order specified in the query.

the shape of the query tree, as dictated by the nature of the join ordering, is so imporatnt to query optimization taht some of these trees ahve names: left-deep, right-deep, and bushy trees.

left-deep:
`JOIN( JOIN( JOIN(A, B), C), D)`

bushy:
`JOIN(JOIN(A, B), JOIN(C, D))`

left-deep is also referred to as linear or linear processing trees. bushy trees can take any arbitrary shape, so bushy trees actually includes the set of both left-deep and right-deep trees.

query optimizer has to evaluate physical join operators, data access methods (table scan, index scan, index seek), as well as optimize other parts of the query like aggregations, subqueries, and so on

query optimizer must find a balance between the optimization time and the quality of the resulting plan
