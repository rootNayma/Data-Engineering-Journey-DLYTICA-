-- just like before, its a normal partition table query.



-- Create partitioned table for large e-commerce system
CREATE TABLE order_history (
    order_id BIGSERIAL,
    order_date DATE NOT NULL,
    customer_id INTEGER NOT NULL,
    product_id INTEGER,
    quantity INTEGER,
    total_amount NUMERIC(12, 2),
    region VARCHAR(50)
) PARTITION BY RANGE (order_date);

-- Create quarterly partitions for 2024
CREATE TABLE order_history_2024_q1 PARTITION OF order_history
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE order_history_2024_q2 PARTITION OF order_history
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE order_history_2024_q3 PARTITION OF order_history
    FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE order_history_2024_q4 PARTITION OF order_history
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');
