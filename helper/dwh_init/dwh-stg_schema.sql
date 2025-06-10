CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE SCHEMA IF NOT EXISTS stg AUTHORIZATION postgres;

-- Staging
CREATE TABLE stg.customers (
    id uuid default uuid_generate_v4(),
    customer_id varchar(255) primary key NOT NULL,
    customer_zip_code_prefix varchar(255) NOT NULL,
    customer_city varchar(255) NOT NULL,
    customer_state varchar(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stg.sellers (
    id uuid default uuid_generate_v4(),
    seller_id varchar(255) primary key NOT NULL,
    seller_zip_code_prefix varchar(255) NOT NULL,
    seller_city varchar(255) NOT NULL,
    seller_state varchar(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stg.orders (
    id uuid default uuid_generate_v4(),
    order_id varchar(255) primary key NOT NULL,
    customer_id varchar(255) NOT NULL,
    order_status text,
    order_purchase_timestamp text,
    order_approved_at text,
    order_delivered_carrier_date text,
    order_delivered_customer_date text,
    order_estimated_delivery_date text
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stg.order_items (
    id uuid default uuid_generate_v4(),
    order_id varchar(255) primary key NOT NULL,
    order_item_id varchar(255) primary key NOT NULL,
    seller_id varchar(255) NOT NULL,
    shipping_limit_date text,
    price real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stg.order_reviews (
    id uuid default uuid_generate_v4(),
    review_id varchar(255) primary key NOT NULL,
    order_id varchar(255) primary key NOT NULL,
    review_score integer,
    review_comment_title text,
    review_comment_message text,
    review_creation_date text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE ONLY stg.customers
    ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

ALTER TABLE ONLY stg.order_items
    ADD CONSTRAINT pk_order_items PRIMARY KEY (order_id, order_item_id);

ALTER TABLE ONLY stg.order_reviews
    ADD CONSTRAINT pk_order_reviews PRIMARY KEY (review_id, order_id);

ALTER TABLE ONLY stg.orders
    ADD CONSTRAINT pk_orders PRIMARY KEY (order_id);

ALTER TABLE ONLY stg.sellers
    ADD CONSTRAINT pk_sellers PRIMARY KEY (seller_id);

ALTER TABLE ONLY stg.order_reviews
    ADD CONSTRAINT fk_order_reviews_orders FOREIGN KEY (order_id) REFERENCES stg.orders(order_id);

ALTER TABLE ONLY stg.order_items
    ADD CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES stg.orders(order_id);

ALTER TABLE ONLY stg.order_items
    ADD CONSTRAINT fk_order_items_sellers FOREIGN KEY (seller_id) REFERENCES stg.sellers(seller_id);

ALTER TABLE ONLY stg.orders
    ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES stg.customer(customer_id);
