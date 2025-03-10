-- Table Creation for ecommerce data
DROP TABLE IF EXISTS ecommerce_data;

CREATE TABLE IF NOT EXISTS ecommerce_data(
    order_id VARCHAR PRIMARY KEY NOT NULL,
    order_date DATE,
    ship_date DATE,
    shipping_type VARCHAR,
    delivery_status VARCHAR,
    days_for_shipment_scheduled INT,
    days_for_shipment_real INT,
    order_item_discount NUMERIC,
    sales_per_order NUMERIC,
    order_quantity INT,
    profit_per_order NUMERIC,
    product_name VARCHAR,
    category_name VARCHAR,
    customer_id VARCHAR,
    customer_full_name VARCHAR,
    customer_segment VARCHAR,
    customer_city VARCHAR,
    customer_state VARCHAR,
    customer_country VARCHAR,
    customer_region VARCHAR
);

-- Example INSERT statement based on CSV data
COPY ecommerce_data 
FROM 'E:\\Personal Projects\\US Based Ecommerce Company Sales Performance\\US-Based-Ecommerce-Company-Sales-Performance\\Python\\ecommerce_data_cleaned.csv' 
DELIMITER ',' CSV HEADER;

-- Alternative format with forward slashes
-- COPY ecommerce_data 
-- FROM 'E:/Personal Projects/US Based Ecommerce Company Sales Performance/US-Based-Ecommerce-Company-Sales-Performance/Python/ecommerce_data_cleaned.csv' 
-- DELIMITER ',' CSV HEADER;