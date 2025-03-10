-- Check the data
SELECT *
FROM ecommerce_data;

-- Get all column names from the table
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'ecommerce_data'
ORDER BY ordinal_position;

-- ========================== Calculate Year-to-Date (YTD) sales (single metric) ========================== 
-- ======================================================================================================== 

/* 
    As for the other metrics like profit, quantity sold, etc, we can just change the SUM(sales_per_order)
    to the desired metric.
*/

WITH max_date AS (
    SELECT MAX(order_date) AS latest_date
    FROM ecommerce_data
)
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(sales_per_order) AS ytd_sales
FROM 
    ecommerce_data, max_date
WHERE 
    order_date BETWEEN DATE_TRUNC('year', max_date.latest_date) AND max_date.latest_date
GROUP BY 
    EXTRACT(YEAR FROM order_date)
ORDER BY 
    year;

-- ==========================  Calculate Year-to-Date (YTD) sales (gouping by customer_region) ==========================
-- ======================================================================================================== 

/* 
    As for the shipping_type, state, city, etc, we can just change the customer_region to desired column.
*/

WITH max_date AS (
    SELECT MAX(order_date) AS latest_date
    FROM ecommerce_data
)
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    customer_region,
    SUM(sales_per_order) AS ytd_sales
FROM 
    ecommerce_data, max_date
WHERE 
    order_date BETWEEN DATE_TRUNC('year', max_date.latest_date) AND max_date.latest_date
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    customer_region
ORDER BY 
    year;

-- ==========================  Calculate YoY growth rate ==========================
-- =================================================================================

-- 1. Total sales by year
WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales_per_order) AS total_sales
    FROM 
        ecommerce_data
    GROUP BY 
        EXTRACT(YEAR FROM order_date)
    ORDER BY 
        year
),

-- 2. Calculate YoY growth
sales_growth AS (
    SELECT 
        current.year,
        current.total_sales,
        previous.total_sales AS prev_year_sales,
        (current.total_sales - previous.total_sales) AS sales_difference,
        CASE 
            WHEN previous.total_sales = 0 THEN NULL
            ELSE ROUND(((current.total_sales - previous.total_sales) / previous.total_sales) * 100, 2)
        END AS growth_percentage
    FROM 
        yearly_sales current
    LEFT JOIN 
        yearly_sales previous ON current.year = previous.year + 1
)

-- 3. Display the results
SELECT 
    year,
    total_sales,
    prev_year_sales,
    sales_difference,
    growth_percentage || '%' AS yoy_growth_rate
FROM 
    sales_growth
ORDER BY 
    year;

-- ==========================  Calculate Monthly sales growth within each year ==========================
-- ========================================================================================================

WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(sales_per_order) AS total_sales
    FROM 
        ecommerce_data
    GROUP BY 
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
    ORDER BY 
        year, month
),

-- Calculate month-over-month growth within each year
monthly_growth AS (
    SELECT 
        current.year,
        current.month,
        current.total_sales,
        previous.total_sales AS prev_month_sales,
        CASE 
            WHEN previous.total_sales = 0 THEN NULL
            ELSE ROUND(((current.total_sales - previous.total_sales) / previous.total_sales) * 100, 2)
        END AS monthly_growth_percentage
    FROM 
        monthly_sales current
    LEFT JOIN 
        monthly_sales previous ON (current.year = previous.year AND current.month = previous.month + 1)
                              OR (current.year = previous.year + 1 AND current.month = 1 AND previous.month = 12)
)

SELECT 
    year,
    month,
    total_sales,
    prev_month_sales,
    monthly_growth_percentage || '%' AS mom_growth_rate
FROM 
    monthly_growth
ORDER BY 
    year, month;

-- ==========================  Calculate YoY growth by product category ==========================
-- ========================================================================================================

WITH category_yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        category_name,
        SUM(sales_per_order) AS total_sales
    FROM 
        ecommerce_data
    GROUP BY 
        EXTRACT(YEAR FROM order_date),
        category_name
    ORDER BY 
        category_name, year
),

-- Calculate YoY growth by category
category_growth AS (
    SELECT 
        current.year,
        current.category_name,
        current.total_sales,
        previous.total_sales AS prev_year_sales,
        CASE 
            WHEN previous.total_sales = 0 THEN NULL
            ELSE ROUND(((current.total_sales - previous.total_sales) / previous.total_sales) * 100, 2)
        END AS growth_percentage
    FROM 
        category_yearly_sales current
    LEFT JOIN 
        category_yearly_sales previous ON current.year = previous.year + 1 
                                      AND current.category_name = previous.category_name
)

SELECT 
    year,
    category_name,
    total_sales,
    prev_year_sales,
    growth_percentage || '%' AS category_yoy_growth_rate
FROM 
    category_growth
ORDER BY 
    category_name, year;

-- ==========================  Top and Bottom products by sales ==========================
-- ========================================================================================

SELECT
    product_name,
    SUM(sales_per_order) AS total_sales
FROM ecommerce_data
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    product_name,
    SUM(sales_per_order) AS total_sales
FROM ecommerce_data
GROUP BY product_name
ORDER BY total_sales ASC
LIMIT 10;







