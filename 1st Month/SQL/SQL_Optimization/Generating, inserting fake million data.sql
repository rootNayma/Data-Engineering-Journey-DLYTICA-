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
    'FirstName' || i,
    'LastName' || i,
    'employee' || i || '@company.com',
    (i % 50) + 1,  -- 50 departments
    30000 + (random() * 120000)::numeric(10,2),  -- Salary between 30k-150k
    CURRENT_DATE - (random() * 3650)::integer,  -- Random date within 10 years
    (ARRAY['New York', 'London', 'Tokyo', 'Mumbai', 'Berlin', 'Sydney'])[floor(random() * 6 + 1)],
    (ARRAY['USA', 'UK', 'Japan', 'India', 'Germany', 'Australia'])[floor(random() * 6 + 1)]
FROM generate_series(1, 1000000) AS i;

-- Verify data
SELECT COUNT(*) FROM employees;
