-- Create composite index for common query pattern

-- what is composite index ??
-- This is called a composite index because it indexes more than one column. (department_id, salary)

CREATE INDEX idx_dept_salary 
ON employees(department_id, salary);

-- Test it
EXPLAIN ANALYZE
SELECT * 
FROM employees 
WHERE department_id = 25 
  AND salary > 100000;
