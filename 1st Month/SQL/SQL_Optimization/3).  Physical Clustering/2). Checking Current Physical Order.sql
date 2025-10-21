-- what do you mean by checking current physical order ??
-- om namha shiva, lets go

-- So first what is physical order ??
-- The order in which rows are actually stored on disk. This is affected by how and when data was inserted. Often unordered in real-world scenarios.
-- in simple word, it is the order that how we inserted
-- It is also called as unorder 

| Physical Row # | order_date | customer_id |
| -------------- | ---------- | ----------- |
| 1              | 2024-03-10 | 101         |
| 2              | 2024-01-05 | 52          |
| 3              | 2024-07-20 | 87          |
| 4              | 2024-02-28 | 13          |

-- Notice that the rows they are unorder not sorted by "order_date",  they’re in the order how we inserted them while we created the order table.

-- what is column order??
-- exact opposite of physical order, 
-- It is a type of order where it is logically ordered. Done by writing quries [SELECT * FROM orders ORDER BY order_date;]
| Logical Order (Index) | order_date |
| --------------------- | ---------- |
| 1                     | 2024-01-05 |
| 2                     | 2024-02-28 |
| 3                     | 2024-03-10 |
| 4                     | 2024-07-20 |
  
-- basically, it is how we want to see or access the data.
-- It is also called as logical or Index order.


-- what is Correlation ???
-- Correlation measures how close the physical row order is to the logical column order.
-- Range: -1 to 1
-- 1 → perfectly correlated → rows are already in order of the column
-- 0 → no correlation → rows are randomly scattered
-- -1 → reverse order → highest values first, lowest last
==============================================================================================================================================================================
-- Check correlation between physical order and index order
SELECT 
    tablename,
    attname,
    correlation
FROM pg_stats
WHERE tablename = 'orders' AND attname = 'order_date';


-- pg_stats = it is a built in system view in PostgreSQL.

-- think of pg_stats as a “report card” for your columns.
-- When you query pg_stats, it has predefined columns, some of which are:

| Column Name        | Meaning                                                   |
| ------------------ | --------------------------------------------------------- |
|  tablename         | The name of the table the stats are for (e.g.,  orders )  |
|  attname           | The name of the column in that table (e.g.,  order_date ) |
|  correlation       | How well the physical row order matches the column order  |
|  null_frac         | Fraction of NULLs in the column                           |
|  most_common_vals  | Most frequent values                                      |
|  avg_width         | Average storage size of a value in bytes                  |

-- So tablename and attname exist inside pg_stats, not your orders table.




