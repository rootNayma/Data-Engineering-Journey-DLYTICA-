-- Insert 2 million orders
INSERT INTO order_history (order_date, customer_id, product_id, quantity, total_amount, region)
SELECT 
    DATE '2024-01-01' + (random() * 365)::integer,
    (random() * 50000)::integer + 1,
    (random() * 5000)::integer + 1,
    (random() * 10)::integer + 1,
    (random() * 2000)::numeric(12,2) + 20,
    (ARRAY['North America', 'Europe', 'Asia', 'South America'])[floor(random() * 4 + 1)]
FROM generate_series(1, 2000000);


-- Check partition sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables 
WHERE tablename LIKE 'order_history%'
ORDER BY tablename;

