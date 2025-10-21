-- Complex query with all optimizations working together
EXPLAIN ANALYZE
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total_amount) as total_spent,
    AVG(total_amount) as avg_order
FROM order_history
WHERE order_date BETWEEN '2024-07-01' AND '2024-09-30'  -- Partition pruning
  AND customer_id BETWEEN 10000 AND 15000                 -- Index + clustering benefit
  AND region = 'North America'                            -- Additional index
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 100;
