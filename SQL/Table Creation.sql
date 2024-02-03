-- Table Creation for ecommerce data
CREATE TABLE IF NOT EXISTS ecommerce_data(
    customer_id VARCHAR PRIMARY KEY NOT NULL,
    customer_first_name VARCHAR,
    customer_second_name VARCHAR,
    category_name VARCHAR,
	product_name VARCHAR,
	customer_segment VARCHAR,
	customer_city VARCHAR,
	customer_state VARCHAR,
	customer_country VARCHAR,
	customer_region VARCHAR,
	customer_status VARCHAR,
	order_date VARCHAR,
	order_id VARCHAR,
	ship_date VARCHAR,
	shipping_type VARCHAR,
	days_for_shipment_scheduled INT,
	days_for_shipment_real INT,
	order_item_discount NUMERIC,
	sales_per_order NUMERIC, 
	order_quantity INT,
	profit_per_order NUMERIC
);

drop table ecommerce_data