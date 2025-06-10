INSERT INTO final.dim_sellers (
    seller_id,
    seller_nk,
    seller_zip_code_prefix,
    seller_city, seller_state
)

SELECT
    s.id AS seller_id,
    s.seller_id AS seller_nk,
    seller_zip_code_prefix,
    seller_city, 
    seller_state
FROM
    stg.sellers s
    
ON CONFLICT(seller_id) 
DO UPDATE SET
    seller_nk = EXCLUDED.seller_nk,
    seller_zip_code_prefix = EXCLUDED.seller_zip_code_prefix,
    seller_city = EXCLUDED.seller_city,
    seller_state = EXCLUDED.seller_state,
    updated_at = CASE WHEN 
                        final.dim_sellers.seller_nk <> EXCLUDED.seller_nk
                        OR final.dim_sellers.seller_zip_code_prefix <> EXCLUDED.seller_zip_code_prefix
                        OR final.dim_sellers.seller_city <> EXCLUDED.seller_city
                        OR final.dim_sellers.seller_state <> EXCLUDED.seller_state
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.dim_sellers.updated_at
                END;