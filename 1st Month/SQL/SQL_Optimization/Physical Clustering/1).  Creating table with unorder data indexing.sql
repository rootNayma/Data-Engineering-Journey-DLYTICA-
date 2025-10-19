-- Create orders table
-- just a normal table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE,
    customer_id INTEGER,
    total_amount NUMERIC(10, 2),
    status VARCHAR(20)
);


-- Insert data in RANDOM order (simulating real-world scenario)
INSERT INTO orders (order_date, customer_id, total_amount, status)
SELECT 
    DATE '2024-01-01' + (random() * 365)::integer,
    (random() * 10000)::integer + 1,
    (random() * 1000)::numeric(10,2) + 50,
    (ARRAY['pending', 'completed', 'shipped', 'cancelled'])[floor(random() * 4 + 1)]
FROM generate_series(1, 500000);


-- Create index on order_date
CREATE INDEX idx_orders_date ON orders(order_date);
