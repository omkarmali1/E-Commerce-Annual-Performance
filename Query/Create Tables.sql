-- STAGE 1 :- Creating Database

-- 1) Create the database
CREATE DATABASE ecommerce_miniproject;

-- 2) Use the newly created database
USE ecommerce_miniproject;

-- 3) Create tables with appropriate data types and constraints
CREATE TABLE customers_dataset (
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(255),
    customer_city VARCHAR(255),
    customer_state VARCHAR(255),
    PRIMARY KEY (customer_id)
);

CREATE TABLE sellers_dataset (
    seller_id VARCHAR(255),
    seller_zip_code_prefix VARCHAR(255),
    seller_city VARCHAR(255),
    seller_state VARCHAR(255),
    PRIMARY KEY (seller_id)
);

CREATE TABLE geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(255),
    geolocation_lat DECIMAL(10, 8),
    geolocation_lng DECIMAL(11, 8),
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(255)
);

CREATE TABLE product_dataset (
    product_id VARCHAR(255),
    product_category_name VARCHAR(255),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10, 2),
    product_length_cm DECIMAL(10, 2),
    product_height_cm DECIMAL(10, 2),
    product_width_cm DECIMAL(10, 2),
    PRIMARY KEY (product_id)
);

CREATE TABLE orders_dataset (
    order_id VARCHAR(255),
    customer_id VARCHAR(255),
    order_status VARCHAR(255),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id)
);

CREATE TABLE order_items_dataset (
    order_id VARCHAR(255),
    order_item_id INT,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES product_dataset(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id)
);

CREATE TABLE order_payments_dataset (
    order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(255),
    payment_installments INT,
    payment_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id)
);

CREATE TABLE order_reviews_dataset (
    review_id VARCHAR(255),
    order_id VARCHAR(255),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message VARCHAR(255),
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id),
    FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id)
);

-- 4) Import CSV data into tables using the Import/Export Data feature in your database management tool

-- 5) Generate ERD using your database management tool
