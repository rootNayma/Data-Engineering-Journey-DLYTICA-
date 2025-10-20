-- Note: Clustering is NOT automatically maintained
-- Insert new rows (they won't be in order)

INSERT INTO orders (order_date, customer_id, total_amount, status)            --------------->  New Data        
SELECT 
    DATE '2024-01-01' + (random() * 365)::integer,                       
    (random() * 10000)::integer + 1,
    (random() * 1000)::numeric(10,2) + 50,
    'completed'
FROM generate_series(1, 50000);

-- Check correlation again
ANALYZE orders;                                                              -----------------> Checking correlation, how much mismatch it is.

SELECT correlation 
FROM pg_stats 
WHERE tablename = 'orders' AND attname = 'order_date';

-- Output: correlation has decreased (e.g., 0.9123)

-- Re-cluster periodically in maintenance window
CLUSTER orders;                                                          --------------------->  Boom re-cluster.
