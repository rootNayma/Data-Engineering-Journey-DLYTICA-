-- Clear cache for fair comparison
DISCARD ALL;


-- As usual, the analyze to compare.
-- Same query as before
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date BETWEEN '2024-06-01' AND '2024-06-30'
ORDER BY order_date;



|                 | Before Clustering                | After Clustering                 |
|-----------------|----------------------------------|----------------------------------|
| Time            | 48.6 ms                          | 19.5 ms                          |
| Buffers         | 3690 pages                       | 856 pages                        |
| I/O Access Type | Random I/O access                | Sequential I/O access            |
| Performance     | – - - - - -  ❌  - - - - - - - - | 2.5x FASTER + 4.3x LESS I/O      |
