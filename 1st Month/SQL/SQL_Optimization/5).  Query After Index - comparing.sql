-- Clear cache
-- it is very important do this everytime you want to see reslut, it is like refresh button
DISCARD ALL;



-- Same query as before
ion
-- here we are trying to compare the previous execution time with current execution time after applying indexing. 
-- remember, that baseline we talked about before indexing.

   --  1) baseline/before -------> 2) Apply indexing -----> again the baseline code for comparing if it works or not
EXPLAIN ANALYZE
SELECT * 
FROM employees 
WHERE department_id = 25;
