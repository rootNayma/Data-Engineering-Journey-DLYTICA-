-- what is range query ??
-- it is a query that asks for value between any two points or limits.
| Column Type | Example Query                                            | Meaning                            |
| ----------- | -------------------------------------------------------- | ---------------------------------- |
| `DATE`      | `WHERE order_date BETWEEN '2024-06-01' AND '2024-06-30'` | Get all orders from June           |
| `INTEGER`   | `WHERE price BETWEEN 100 AND 200`                        | Get all products costing $100–$200 |
| `FLOAT`     | `WHERE rating BETWEEN 4.0 AND 5.0`                       | Get all highly rated products      |
| `TEXT`      | `WHERE name BETWEEN 'A' AND 'M'`                         | Get names alphabetically from A–M  |


  
-- Query one month of data
-- yeh toh yaad hogya hoga,
-- as usual, to compare before and after, we do analyze.
  
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date BETWEEN '2024-06-01' AND '2024-06-30'
ORDER BY order_date;
            
