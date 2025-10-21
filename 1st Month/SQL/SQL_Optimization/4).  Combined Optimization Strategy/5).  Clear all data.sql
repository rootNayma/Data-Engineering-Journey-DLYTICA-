-- If you want to clean up after exercises
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_history CASCADE;

-- Or drop entire database
\c postgres
DROP DATABASE optimization_lab;
