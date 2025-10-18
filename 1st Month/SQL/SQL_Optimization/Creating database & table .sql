-- First you must install postgres on your machine
-- if its installed
-- then give permisson for your psl.exe to be called directly inside powershell, how do we do that guess what " I am here dont  worry"
-- press windows logo + r = it will open run
-- then type "sysdm.cpl" open it
-- go to --> Advance --> Environment Variables --> System Variables --> Right click on "Path" and Edit 
-----------------Now, add path of your psql =  C:\Program Files\PostgreSQL\18\bin ---------------- then click ok for every window popup.


---open powershell
-- type psl -U postgres, then it will ask your postgres password, which we created when installing postgres
-- now after giving password, you can use postgres from powershell

-- NOw, lets create DATABASE in powershell, type
-- CREATE DATABASE optimiaztion_test;
-- GRANT ALL PRIVILEGES ON DATABASE optimization_test TO postgres;

-- Now you good to go---
-- Open Dbeaver and make connection--



-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department_id INTEGER,
    salary NUMERIC(10, 2),
    hire_date DATE,
    city VARCHAR(50),
    country VARCHAR(50)
);
