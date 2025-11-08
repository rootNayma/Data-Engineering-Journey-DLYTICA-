-- Insert 1 million employees
INSERT INTO employees (
    first_name, 
    last_name, 
    email, 
    department_id, 
    salary, 
    hire_date, 
    city, 
    country
)
SELECT 
    'FirstName' || i,  -----> what is i for,  i will create  1,2,3,4,5,6,7,8,9.....               
    'LastName' || i,   -----> everything inside' ' this is a string,  and || this will just join the things which will be firstname+1 
    'employee' || i || '@company.com',    -----> here it will be empolyee123@company.com
    
    (i % 50) + 1,  -- 50 departments ---> % will give a reminder
    
--| i   | i % 50 | (i % 50) + 1 |
--| --- | ------ | ------------ |
--| 1   | 1      | 2            |
--| 50  | 0      | 1            |
--| 51  | 1      | 2            |
--| 52  | 2      | 3            |
--| 100 | 0      | 1            |--- So every employee is assigned a department ID between 1 and 50.
    

                                    
    
    30000 + (random() * 120000)::numeric(10,2),  -- Salary between 30k-150k
    CURRENT_DATE - (random() * 3650)::integer,  -- Random date within 10 years
    (ARRAY['New York', 'London', 'Tokyo', 'Mumbai', 'Berlin', 'Sydney'])[floor(random() * 6 + 1)],
    (ARRAY['USA', 'UK', 'Japan', 'India', 'Germany', 'Australia'])[floor(random() * 6 + 1)]
FROM generate_series(1, 1000000) AS i;

-- Verify data
SELECT COUNT(*) FROM employees;
