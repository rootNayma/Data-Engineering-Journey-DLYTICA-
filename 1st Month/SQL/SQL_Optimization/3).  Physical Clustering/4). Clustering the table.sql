-- what is clustering ?? 
-- Clustering = physically arranging the table data in the same order as a chosen index. here we are reordering data with help of idx_orders_date.
-- it will reorder the whole table data in ascending oder with respect to order_date.

-- some thing like this 
| order_id | order_date | customer_id | total_amount | status    |
|----------|------------|-------------|--------------|-----------|
| 110      | 2024-01-01 | 2015        | 354.37       | cancelled |
| 1854     | 2024-01-01 | 7617        | 997.96       | cancelled |
| 2666     | 2024-01-01 | 9591        | 297.81       | cancelled |
| 2734     | 2024-01-01 | 537         | 357.81       | completed |
  


-- Cluster orders by order_date index
CLUSTER orders USING idx_orders_date;

-- Check correlation after clustering
ANALYZE orders;

SELECT 
    tablename,
    attname,
    correlation
FROM pg_stats
WHERE tablename = 'orders' AND attname = 'order_date';
