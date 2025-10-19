-- Create index on parent (automatically creates on all partitions)

-- same as we creted index in btree indexing chapter
-- how do we know its indexing on partition.

-- cause its ON "sales" which is a partion table we created.


CREATE INDEX idx_sales_customer ON sales(customer_id);

-- Now query with both partition pruning AND index
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND customer_id = 50000;
