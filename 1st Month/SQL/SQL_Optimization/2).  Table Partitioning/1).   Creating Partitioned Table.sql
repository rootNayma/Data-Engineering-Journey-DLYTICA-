-- Create parent table with partitioning

-- so, this here is a parent table
-- you may ask how again, guess what "I am here"
-- when ever there comes (create table + partition by range) then it is parent table

-- what is parent table ??
-- it is kind of table that doesnt store any data, but only routes to its child.  thats what all parents have been to their childs, they dont keep they give.
-- so, back to the code. parents dont keep they give.


CREATE TABLE sales (
    sale_id SERIAL,
    sale_date DATE NOT NULL,
    customer_id INTEGER,
    product_id INTEGER,
    amount NUMERIC(10, 2),
    region VARCHAR(50)
) PARTITION BY RANGE (sale_date);



-- Create partitions for each year (2020-2024)
-- Now, this is a child table,
-- now you may ask how they are linked then.
-- child is linked throuh "PARTITION OF"

-- now, listen to me carefully, how it works whats the flow
-- when we insert the data it does to parent table but parents dont keep they give, so the parent table will attach the data to its right columns, then give to child table

-- Insert data ------>  Parent table (data + columns)   ---------> becomes row  --------->  Child table

CREATE TABLE sales_2020 PARTITION OF sales
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE sales_2021 PARTITION OF sales
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE sales_2022 PARTITION OF sales
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE sales_2023 PARTITION OF sales
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE sales_2024 PARTITION OF sales
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');




--  INSERT INTO sales (sale_date, customer_id, product_id, amount, region)
           │
           ▼
-- ┌───────────────────┐
-- │    Parent Table   │  <-- sales
-- │ PARTITION BY sale_date
-- └───────────────────┘
           │
           ▼  (checks sale_date)
-- ┌───────────────┐
-- │ sales_2023    │  <-- child partition
-- │ 2023-06-10    │
-- │ 101           │
-- │ 5001          │
-- │ 250.00        │
-- │ USA           │
-- └───────────────┘





-- Verify partitions

-- do you remember, B-Tree Indexing chapter. we did this in section 4). query with index too, that time it was for index now it is for table.
-- still let me tell you, this code is for seeing size of the table. to check whether our code worked or not, okay bayta chalo.


SELECT 
    tablename, 
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables 
WHERE tablename LIKE 'sales%' 
ORDER BY tablename;
