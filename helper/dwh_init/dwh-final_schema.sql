CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE SCHEMA IF NOT EXISTS final AUTHORIZATION postgres;

-- Final
CREATE TABLE final.dim_customers(
    customer_id uuid primary key default uuid_generate_v4(),
    customer_nk varchar(255) primary key NOT NULL,
    customer_zip_code_prefix varchar(255) NOT NULL,
    customer_city varchar(255) NOT NULL,
    customer_state varchar(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE final.dim_sellers (
    seller_id uuid default uuid_generate_v4(),
    seller_nk varchar(255) primary key NOT NULL,
    seller_zip_code_prefix varchar(255) NOT NULL,
    seller_city varchar(255) NOT NULL,
    seller_state varchar(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE final.dim_date(
    date_id              	 INT NOT null primary KEY,
    date_actual              DATE NOT NULL,
    day_suffix               VARCHAR(4) NOT NULL,
    day_name                 VARCHAR(9) NOT NULL,
    day_of_year              INT NOT NULL,
    week_of_month            INT NOT NULL,
    week_of_year             INT NOT NULL,
    week_of_year_iso         CHAR(10) NOT NULL,
    month_actual             INT NOT NULL,
    month_name               VARCHAR(9) NOT NULL,
    month_name_abbreviated   CHAR(3) NOT NULL,
    quarter_actual           INT NOT NULL,
    quarter_name             VARCHAR(9) NOT NULL,
    year_actual              INT NOT NULL,
    first_day_of_week        DATE NOT NULL,
    last_day_of_week         DATE NOT NULL,
    first_day_of_month       DATE NOT NULL,
    last_day_of_month        DATE NOT NULL,
    first_day_of_quarter     DATE NOT NULL,
    last_day_of_quarter      DATE NOT NULL,
    first_day_of_year        DATE NOT NULL,
    last_day_of_year         DATE NOT NULL,
    mmyyyy                   CHAR(6) NOT NULL,
    mmddyyyy                 CHAR(10) NOT NULL,
    weekend_indr             VARCHAR(20) NOT NULL
);

CREATE TABLE final.fct_order_activity(
	order_id uuid default uuid_generate_v4() ,
	order_nk varchar(255) primary key NOT NULL,
	customer_id uuid references final.dim_customer(customer_id),
	order_status text,
    order_purchase_timestamp text,
    order_approved_at text,
    order_delivered_carrier_date text,
    order_delivered_customer_date text,
    order_estimated_delivery_date text
	price int,
    seller_id uuid references final.dim_sellers(seller_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE final.fct_reviews(
	review_id uuid default uuid_generate_v4() ,
	review_nk varchar(255) primary key not null,
	customer_id uuid references final.dim_customer(customer_id),
    review_score integer,
    review_comment_title text,
    review_comment_message text,
    review_creation_date text,
    seller_id uuid references final.dim_sellers(seller_id),
	date_id int references final.dim_date(date_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Populating for staging date dimension 
INSERT INTO final.dim_date
SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS date_id,
       datum AS date_actual,
       TO_CHAR(datum, 'fmDDth') AS day_suffix,
       TO_CHAR(datum, 'TMDay') AS day_name,
       EXTRACT(DOY FROM datum) AS day_of_year,
       TO_CHAR(datum, 'W')::INT AS week_of_month,
       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW') AS week_of_year_iso,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum, 'TMMonth') AS month_name,
       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_actual,
       CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
           END AS quarter_name,
       EXTRACT(YEAR FROM datum) AS year_actual,
       datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS last_day_of_week,
       datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter,
       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year,
       TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
       TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
       CASE
           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN 'weekend'
           ELSE 'weekday'
           END AS weekend_indr
FROM (SELECT '1998-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;