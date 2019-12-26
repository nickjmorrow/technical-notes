# [SQL Code Smells](https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-code-smells/)

## Problems with database design

- packing lists, complex data, and other multivariate attributes into a table column
  - only fine if that data is atomic / will never be split up
- using inappropriate data types (dates vs varchar, int vs money)

## Problems with table design

- using check constraints to restrict values in a column. instead, use a FK constraint on another table that holds valid values
  - always use referential integrity constraints when available
- using same column name in different tables but with different data types
- forgetting to specify whether a column is nullable
- creating a table without specifying a schema
- using `MONEY` data type - instead, use `DECIMAL`. `MONEY` confuses the storage of data with their display
- using `FLOAT` or `REAL` (useful only in academic settings that require extreme accuracy) instead of `DECIMAL`
- not using a semicolon to terminate SQL statements
- INSERT without column list

## Difficulties with Query Syntax

- creating god queries
- using `SELECT` instead of `SET` to assign values to variables
- not using two-part object names for object references (e.g. not using schema)
- using `INSERT INTO` without column names and order
- referencing an unindexed column within the `IN` predicate of a `WHERE` clause (causes a table scan, very slow)
- using LIKE in a `WHERE` clause with an initial wildcard character
- using `== NULL` or `<> NULL` to filter a nullable column. instead, use `IS NULL` or `IS NOT NULL`
- using `NOT IN` in a `WHERE` clause. instead, use a `LEFT OUTER JOIN` and checking for `NULL`
- using `SELECT DISTINCT` to mask a join problem
- use `DELETE` to remove an entire table. instead, use `TRUNCATE`

## Problems with naming

- Using system-generated object names, particularly for constraints
