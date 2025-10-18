-- Create index on department_id
-- INDEX = is a syntax you cant give name what  ever you like
-- idx_department_id = is not a syntax, you can name it what ever you want,
-- idx = it is just a identifer for the index we created, so that if in future we can use it or drop it. 
-- employees = is a table
-- department_id = is a column
CREATE INDEX idx_department_id ON employees(department_id);    



-- Check index size
--  pg_relation_size= built-in PostgreSQL function. It calculates the size (in bytes) of a table or index.
-- pg_size_pretty = as name suggest. "Pretty" It converts the size in human readable way like in kB,MB, GB.
-- note, this runs first (pg_relation_size('idx_department_id')) ------->   pg_size_pretty -----> as index_size;
SELECT 
    pg_size_pretty(pg_relation_size('idx_department_id')) as index_size;
