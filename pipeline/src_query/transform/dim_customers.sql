INSERT INTO final.dim_customers (
    customer_id,
    customer_nk,
    customer_zip_code_prefix, customer_city, customer_state
)

SELECT
    c.id AS customer_id,
    c.customer_id AS customer_nk,
    customer_zip_code_prefix, customer_city, customer_state
FROM
    stg.customers c
    
ON CONFLICT(id) 
DO UPDATE SET
    customer_nk = EXCLUDED.customer_nk,
    customer_zip_code_prefix = EXCLUDED.customer_zip_code_prefix,
    customer_city = EXCLUDED.customer_city,
    customer_state = EXCLUDED.customer_state,
    updated_at = CASE WHEN 
                        final.dim_customers.customer_nk <> EXCLUDED.customer_nk
                        OR final.dim_customers.customer_zip_code_prefix <> EXCLUDED.customer_zip_code_prefix
                        OR final.dim_customers.customer_city <> EXCLUDED.customer_city
                        OR final.dim_customers.customer_state <> EXCLUDED.customer_state
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.dim_customers.updated_at
                END;