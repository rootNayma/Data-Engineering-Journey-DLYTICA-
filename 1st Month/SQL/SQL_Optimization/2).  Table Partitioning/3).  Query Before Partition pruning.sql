-- Query without filtering by partition key (sale_date)

-- thsi what we did in btree indexing chapter too
-- it is for analyzing the execution time or compare after appling the pruning.
-- do you rememeber, the basline for btree indexing its the same.
EXPLAIN ANALYZE
SELECT COUNT(*), AVG(amount) 
FROM sales 
WHERE customer_id = 50000;
