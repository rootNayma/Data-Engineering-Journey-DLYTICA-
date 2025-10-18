-- Insert 1 million rows per year (5 million total)
-- like we created 1 million fake data for indexing, here we are doing same for partition too.
INSERT INTO sales (
    sale_date, 
    customer_id, 
    product_id, 
    amount, 
    region
)
SELECT 
    DATE '2020-01-01' + (random() * 365 * 5)::integer,  -- Random date 2020-2024
    (random() * 100000)::integer + 1,  -- Customer ID
    (random() * 1000)::integer + 1,    -- Product ID
    (random() * 5000)::numeric(10,2) + 10,  -- Amount $10-$5010
    (ARRAY['North', 'South', 'East', 'West', 'Central'])[floor(random() * 5 + 1)]
FROM generate_series(1, 5000000);





-- Check distribution across partitions
-- here, SELECT 'sales_2020' as partition = will create a column called "partition" from the child table sales_2020 table, then counts the data how many rows
-- then all code is same for each,
-- it will make each column name as year and counts it

-- the main game is "UNION ALL" it will not remove any duplicate data like "UNION"


SELECT 
    'sales_2020' as partition, COUNT(*) FROM sales_2020
UNION ALL
SELECT 'sales_2021', COUNT(*) FROM sales_2021
UNION ALL
SELECT 'sales_2022', COUNT(*) FROM sales_2022
UNION ALL
SELECT 'sales_2023', COUNT(*) FROM sales_2023
UNION ALL
SELECT 'sales_2024', COUNT(*) FROM sales_2024;
