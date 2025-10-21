-- Bhai abhi tak toh indexing, clustering yaad hogaya hoga na.,\

-- Step 1: Create indexes on parent (applied to all partitions)
CREATE INDEX idx_oh_customer ON order_history(customer_id);
CREATE INDEX idx_oh_product ON order_history(product_id);
CREATE INDEX idx_oh_region ON order_history(region);

-- Step 2: Cluster each partition by customer_id for customer-based queries
CLUSTER order_history_2024_q1 USING order_history_2024_q1_customer_id_idx;
CLUSTER order_history_2024_q2 USING order_history_2024_q2_customer_id_idx;
CLUSTER order_history_2024_q3 USING order_history_2024_q3_customer_id_idx;
CLUSTER order_history_2024_q4 USING order_history_2024_q4_customer_id_idx;

-- Step 3: Run ANALYZE
ANALYZE order_history;
