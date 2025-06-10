INSERT INTO final.fct_reviews (
    review_id,
    review_nk,
    customer_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    seller_id,
    date_id
)

SELECT
    or.id as review_id,
    or.review_id as review_nk,
    o.customer_id,
    or.review_score,
    or.review_comment_title,
    or.review_comment_message,
    or.review_creation_date,
    oi.seller_id,
    TO_CHAR(or.review_creation_date, 'yyyymmdd')::INT as date_id
FROM
    stg.order_reviews or
JOIN stg.orders o 
    ON or.order_id = o.order_id
JOIN stg.order_items oi
    ON o.order_id = oi.order_id

ON CONFLICT(review_id) 
DO UPDATE SET
    review_nk = EXCLUDED.review_nk,
    customer_id = EXCLUDED.customer_id,
    review_score = EXCLUDED.review_score,
    review_comment_title = EXCLUDED.review_comment_title,
    review_comment_message = EXCLUDED.review_comment_message,
    review_creation_date = EXCLUDED.review_creation_date,
    seller_id = EXCLUDED.seller_id,
    date_id = EXCLUDED.date_id,
    updated_at = CASE WHEN 
                        final.fct_reviews.review_nk <> EXCLUDED.review_nk
                        OR final.fct_reviews.customer_id <> EXCLUDED.customer_id
                        OR final.fct_reviews.review_score <> EXCLUDED.review_score
                        OR final.fct_reviews.review_comment_title <> EXCLUDED.review_comment_title
                        OR final.fct_reviews.review_comment_message <> EXCLUDED.review_comment_message
                        OR final.fct_reviews.review_creation_date <> EXCLUDED.review_creation_date
                        OR final.fct_reviews.seller_id <> EXCLUDED.seller_id
                        OR final.fct_reviews.date_id <> EXCLUDED.date_id
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.fct_reviews.updated_at
                END;