-- INDEXES
-- Query optimization and performance tuning

-- Analyse as query using explain
EXPLAIN

SELECT
    product_category,
    SUM(sales_amount)
FROM retail_sales_cleaned
GROUP BY product_category;

-- Check existing indexes
SHOW INDEXES
FROM retail_sales_cleaned;

-- Create an index on order_date
CREATE INDEX idx_order_date
ON retail_sales_cleaned(order_date);

SELECT *
FROM retail_sales_cleaned
WHERE order_date >= '2024-01-01';


-- Composite index
CREATE INDEX idx_region_category
ON retail_sales_cleaned
(
    region,
    product_category
);

SELECT *

FROM retail_sales_cleaned

WHERE region='North'

AND product_category='Furniture';


-- Compare before and after index
EXPLAIN

SELECT *

FROM retail_sales_cleaned

WHERE customer_id='C1001';

CREATE INDEX idx_customer
ON retail_sales_cleaned(customer_id);

 -- 