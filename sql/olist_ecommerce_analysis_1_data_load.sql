CREATE DATABASE olist_ecommerce_analysis_1;
USE olist_ecommerce_analysis_1;

CREATE TABLE orders 
(
    order_id VARCHAR(32),
    customer_id VARCHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME
);

CREATE TABLE order_items 
(
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DOUBLE,
    freight_value DOUBLE
);

CREATE TABLE reviews
(
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

CREATE TABLE payments 
(
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DOUBLE
);

USE olist_ecommerce_analysis_1;

LOAD DATA LOCAL INFILE
'C:/Users/Dell/Desktop/Python/Python Project/Olist_Ecommerce_Analytics/data/processed/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
);

LOAD DATA LOCAL INFILE
'C:/Users/Dell/Desktop/Python/Python Project/Olist_Ecommerce_Analytics/data/processed/order_items.csv'
INTO TABLE olist_ecommerce_analysis_1.order_items
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
);

USE olist_ecommerce_analysis_1;
LOAD DATA LOCAL INFILE
'C:/Users/Dell/Desktop/Python/Python Project/Olist_Ecommerce_Analytics/data/processed/reviews_mysql.csv'
INTO TABLE reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    review_id,
    order_id,
    review_score,
    @review_title,
    @review_message,
    review_creation_date,
    review_answer_timestamp
)
SET
    review_comment_title = NULLIF(@review_title, ''),
    review_comment_message = NULLIF(@review_message, '');
    
USE olist_ecommerce_analysis_1;
LOAD DATA LOCAL INFILE
'C:/Users/Dell/Desktop/Python/Python Project/Olist_Ecommerce_Analytics/data/processed/payments.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
);