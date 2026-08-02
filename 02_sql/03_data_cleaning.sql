-- data cleaning

-- recreate the clean table
DROP TABLE IF EXISTS retail_sales_clean;

CREATE TABLE retail_sales_cleaned
LIKE stg_retail_sales;

-- load only valid records
INSERT INTO retail_sales_cleaned
SELECT *
FROM stg_retail_sales
WHERE
    TRIM(IFNULL(order_id,'')) <> ''
    AND quantity > 0
    AND days_to_ship >= 0;
    
select * from retail_sales_cleaned limit 10;

-- Add row_id column
ALTER TABLE retail_sales_cleaned
ADD COLUMN row_id INT AUTO_INCREMENT PRIMARY KEY;

-- Remove Duplicate values
DELETE t1
FROM retail_sales_cleaned t1
JOIN retail_sales_cleaned t2
ON t1.order_id = t2.order_id
AND t1.customer_id = t2.customer_id
AND t1.product_name = t2.product_name
AND t1.order_date = t2.order_date
AND t1.row_id > t2.row_id;

-- Trim Spaces
UPDATE retail_sales_cleaned
SET
customer_name = TRIM(customer_name),
customer_id = TRIM(customer_id),
city = TRIM(city),
region = TRIM(region),
product_name = TRIM(product_name),
product_category = TRIM(product_category),
payment_method = TRIM(payment_method),
gender = TRIM(gender),
order_status = TRIM(order_status);

select * from retail_sales_cleaned limit 10;
-- Standardize Gender
UPDATE retail_sales_cleaned
SET gender =
CASE

WHEN UPPER(gender)='M' THEN 'Male'
WHEN UPPER(gender)='MALE' THEN 'Male'

WHEN UPPER(gender)='F' THEN 'Female'
WHEN UPPER(gender)='FEMALE' THEN 'Female'

ELSE 'Other'

END;

-- Standardize Text Case
UPDATE retail_sales_cleaned
SET

region = CONCAT(
UPPER(LEFT(region,1)),
LOWER(SUBSTRING(region,2))
),

city = CONCAT(
UPPER(LEFT(city,1)),
LOWER(SUBSTRING(city,2))
),

product_category = CONCAT(
UPPER(LEFT(product_category,1)),
LOWER(SUBSTRING(product_category,2))
);


-- Convert order_date before it was in varchar
UPDATE retail_sales_cleaned
SET order_date = STR_TO_DATE(order_date,'%Y-%m-%d'); -- Gives the error 
-- then added a new column
ALTER TABLE retail_sales_cleaned
ADD COLUMN order_date_clean DATE;
-- load the clean data into that column
UPDATE retail_sales_cleaned
SET order_date_clean =
CASE
    WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(order_date, '%Y-%m-%d')

    WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
        THEN STR_TO_DATE(order_date, '%d/%m/%Y')

    WHEN order_date REGEXP '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
        THEN STR_TO_DATE(order_date, '%M %d, %Y')

    ELSE NULL
END;
-- verify
SELECT
    order_date,
    order_date_clean
FROM retail_sales_cleaned
LIMIT 20;
-- droped the uncleaned column
ALTER TABLE retail_sales_cleaned
DROP COLUMN order_date;
-- chnaged the name of the column
ALTER TABLE retail_sales_cleaned
CHANGE order_date_clean order_date DATE;


--  Handle Missing Discount
UPDATE retail_sales_cleaned
SET discount_pct = 0
WHERE discount_pct IS NULL;

-- Handle Missing Customer Satisfaction
UPDATE retail_sales_cleaned
SET customer_satisfaction =
(
SELECT avg_rating
FROM
(
SELECT AVG(customer_satisfaction) avg_rating
FROM retail_sales_cleaned
) x
)
WHERE customer_satisfaction IS NULL;

-- Validation
-- null check
SELECT
SUM(order_date IS NULL),
SUM(customer_name IS NULL),
SUM(quantity IS NULL),
SUM(sales_amount IS NULL)
FROM retail_sales_cleaned;
-- duplicate check table
SELECT
order_id,
COUNT(*)
FROM retail_sales_cleaned
GROUP BY order_id
HAVING COUNT(*)>1;
-- quantity check
SELECT *
FROM retail_sales_cleaned
WHERE quantity<=0;
-- shipping date check
SELECT *
FROM retail_sales_cleaned
WHERE days_to_ship<0;
-- date validation
SELECT
MIN(order_date),
MAX(order_date)
FROM retail_sales_cleaned;

SELECT *
FROM retail_sales_cleaned;
SELECT COUNT(*)
FROM retail_sales_cleaned;