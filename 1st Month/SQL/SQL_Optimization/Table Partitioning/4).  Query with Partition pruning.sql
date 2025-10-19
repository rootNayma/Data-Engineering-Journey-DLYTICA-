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
