-- Query with partition key in WHERE clause

-- okay, so this is a pruning query, 
-- you may ask but this query looks like a normal query,
-- how do you indentify if its pruning query or not, okay im here beyta so chill

-- remember, we created a partitioned table,
-- CREATE TABLE sales (...) PARTITION BY RANGE (sale_date); ----------------> here "sale_date"
-- "sale_date" is the connection here
-- You can tell by just reading this that pruning will occur (because the WHERE uses sale_date).

EXPLAIN ANALYZE
SELECT COUNT(*), AVG(amount) 
FROM sales 
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31' --------------> "sale_date"
  AND customer_id = 50000;


+--------------------------------+--------------------------------+
| Without Pruning                | With Pruning                   |
+--------------------------------+--------------------------------+
| Time: 857 ms                   | Time: 171 ms                   |
| Partitions Scanned: 5          | Partitions Scanned: 1          |
| Rows Checked: 5 Million        | Rows Checked: 1 Million        |
| Performance: -                 | Performance: 5x Faster         |
+--------------------------------+--------------------------------+
