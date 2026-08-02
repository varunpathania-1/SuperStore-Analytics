-- database creation


CREATE DATABASE superstore_analytics;

USE superstore_analytics;

CREATE TABLE dim_customer (
customer_key INT AUTO_INCREMENT PRIMARY KEY,
customer_id VARCHAR(30) NOT NULL,
customer_name VARCHAR(100) NOT NULL,
age INT,
gender VARCHAR(20)
);

CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    product_name VARCHAR(150) NOT NULL
);

CREATE TABLE dim_region (
    region_key INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(50) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    order_date DATE NOT NULL,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    weekday VARCHAR(20)
);

CREATE TABLE fact_sales (
sale_id INT AUTO_INCREMENT PRIMARY KEY,
order_id VARCHAR(30) NOT NULL,
customer_key INT NOT NULL,
product_key INT NOT NULL,
region_key INT NOT NULL,
date_key INT NOT NULL,
quantity INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
discount_pct DECIMAL(5,2),
sales_amount DECIMAL(12,2),
profit DECIMAL(12,2),
shipping_cost DECIMAL(10,2),
customer_satisfaction DECIMAL(3,2),
return_flag BOOLEAN,
order_status VARCHAR(30),
days_to_ship INT,

CONSTRAINT fk_customer
FOREIGN KEY (customer_key)
REFERENCES dim_customer(customer_key),

CONSTRAINT fk_product
FOREIGN KEY (product_key)
REFERENCES dim_product(product_key),

CONSTRAINT fk_region
FOREIGN KEY (region_key)
REFERENCES dim_region(region_key),

CONSTRAINT fk_date
FOREIGN KEY (date_key)
REFERENCES dim_date(date_key)
);

CREATE INDEX idx_order_id
ON fact_sales(order_id);

CREATE INDEX idx_customer
ON fact_sales(customer_key);

CREATE INDEX idx_product
ON fact_sales(product_key);

CREATE INDEX idx_region
ON fact_sales(region_key);

CREATE INDEX idx_date
ON fact_sales(date_key);


CREATE TABLE stg_retail_sales (
order_id VARCHAR(30),
order_date DATE,
customer_id VARCHAR(30),
customer_name VARCHAR(100),
age INT,
gender VARCHAR(20),
region VARCHAR(50),
city VARCHAR(100),
product_category VARCHAR(100),
product_name VARCHAR(255),
quantity INT,
unit_price DECIMAL(10,2),
discount_pct DECIMAL(5,2),
sales_amount DECIMAL(10,2),
profit DECIMAL(10,2),
shipping_cost DECIMAL(10,2),
payment_method VARCHAR(50),
customer_satisfaction INT,
return_flag BOOLEAN,
order_status VARCHAR(30),
days_to_ship INT
);


SET SQL_SAFE_UPDATES = 0;
ALTER TABLE stg_retail_sales
MODIFY order_date VARCHAR(20);

select * from fact_sales limit 10;
SELECT COUNT(*) AS total_rows
FROM stg_retail_sales;

UPDATE stg_retail_sales
SET order_date = STR_TO_DATE(order_date, '%m/%d/%Y');
UPDATE stg_retail_sales
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y');

SELECT order_date
FROM stg_retail_sales
LIMIT 10;
DESCRIBE stg_retail_sales;
SELECT order_date
FROM stg_retail_sales
LIMIT 10;
ALTER TABLE stg_retail_sales
MODIFY COLUMN order_date DATE;

UPDATE stg_retail_sales
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d');

SELECT order_date
FROM stg_retail_sales
WHERE order_date LIKE '%/%'
LIMIT 20;

CREATE TABLE retail_sales_clean AS
SELECT
    order_id,

    CASE
        WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(order_date,'%d-%m-%Y')

        WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(order_date,'%Y-%m-%d')

        WHEN order_date REGEXP '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
            THEN STR_TO_DATE(order_date,'%M %d, %Y')

        ELSE NULL
    END AS order_date,

    customer_id,
    customer_name,
    age,
    gender,
    region,
    city,
    product_category,
    product_name,
    quantity,
    unit_price,
    discount_pct,
    sales_amount,
    profit,
    shipping_cost,
    payment_method,
    customer_satisfaction,
    return_flag,
    order_status,
    days_to_ship

FROM stg_retail_sales;

describe retail_sales_clean;
select * from retail_sales_clean limit 50;

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM stg_retail_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    customer_id,
    product_name,
    order_date,
    COUNT(*) AS duplicate_count
FROM stg_retail_sales
GROUP BY
    order_id,
    customer_id,
    product_name,
    order_date
HAVING COUNT(*) > 1;


SELECT
    SUM(TRIM(customer_name) = '') AS blank_customer_names,
    SUM(TRIM(product_name) = '') AS blank_products,
    SUM(TRIM(city) = '') AS blank_cities,
    SUM(TRIM(region) = '') AS blank_regions
FROM stg_retail_sales;

SELECT DISTINCT region
FROM stg_retail_sales
ORDER BY region;
select count(*) from stg_retail_sales;

truncate stg_retail_sales;


SHOW COLUMNS
FROM stg_retail_sales
LIKE 'return_flag';
ALTER TABLE stg_retail_sales
MODIFY COLUMN return_flag VARCHAR(10);
describe stg_retail_sales;
SELECT DISTINCT return_flag
FROM stg_retail_sales;