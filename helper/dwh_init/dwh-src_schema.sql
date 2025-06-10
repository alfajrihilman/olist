CREATE TABLE public.customers (
    customer_id text NOT NULL,
    customer_unique_id text,
    customer_zip_code_prefix integer,
    customer_city text,
    customer_state text
);

CREATE TABLE public.order_items (
    order_id text NOT NULL,
    order_item_id integer NOT NULL,
    product_id text,
    seller_id text,
    shipping_limit_date text,
    price real,
    freight_value real
);

CREATE TABLE public.order_reviews (
    review_id text NOT NULL,
    order_id text NOT NULL,
    review_score integer,
    review_comment_title text,
    review_comment_message text,
    review_creation_date text
);

CREATE TABLE public.orders (
    order_id text NOT NULL,
    customer_id text,
    order_status text,
    order_purchase_timestamp text,
    order_approved_at text,
    order_delivered_carrier_date text,
    order_delivered_customer_date text,
    order_estimated_delivery_date text
);

CREATE TABLE public.sellers (
    seller_id text NOT NULL,
    seller_zip_code_prefix integer,
    seller_city text,
    seller_state text
);

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT pk_order_items PRIMARY KEY (order_id, order_item_id);

ALTER TABLE ONLY public.order_reviews
    ADD CONSTRAINT pk_order_reviews PRIMARY KEY (review_id, order_id);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT pk_orders PRIMARY KEY (order_id);

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT pk_sellers PRIMARY KEY (seller_id);

ALTER TABLE ONLY public.order_reviews
    ADD CONSTRAINT fk_order_reviews_orders FOREIGN KEY (order_id) REFERENCES public.orders(order_id);

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES public.orders(order_id);

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_order_items_sellers FOREIGN KEY (seller_id) REFERENCES public.sellers(seller_id);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);
