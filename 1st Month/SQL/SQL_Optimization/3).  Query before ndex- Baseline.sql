-- what is index ??
-- Think of it as a shorcut key to search or grap your data super fast.
-- why do we need it or when to use it ??
-- we need it for reducing excution time, saving the storage
-- we use it only when there are way too more data like in our case 1 million data.
-- if there is only few thousands we can query without any indexing

-- in real world it can be more than a million so



-- Clear cache for accurate timing
DISCARD ALL;


-- Query WITHOUT Index ----> Baseline
-- what is basline??
-- anything that is done before result.
-- here we are doing this to analyze the executation time and later we will compare this with index-query.



-- here this code will take more time to execute.
EXPLAIN ANALYZE
SELECT * 
FROM employees 
WHERE department_id = 25;



