INSERT INTO final.fct_order (
    order_id,
    order_nk,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    price,
    seller_id
)

SELECT
    o.id AS order_id,
    o.order_id as order_nk,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    sum(oi.price) as price,
    oi.seller_id
FROM
    stg.orders o
JOIN stg.order_items oi 
    ON o.order_id = oi.order_id
GROUP BY 
    1,2,3,4,5,6,7,8,9,11

ON CONFLICT(order_id) 
DO UPDATE SET
    order_nk = EXCLUDED.order_nk,
    customer_id = EXCLUDED.customer_id,
    order_status = EXCLUDED.order_status,
    order_purchase_timestamp = EXCLUDED.order_purchase_timestamp,
    order_approved_at = EXCLUDED.order_approved_at,
    order_delivered_carrier_date = EXCLUDED.order_delivered_carrier_date,
    order_delivered_customer_date = EXCLUDED.order_delivered_customer_date,
    order_estimated_delivery_date = EXCLUDED.order_estimated_delivery_date,
    seller_id = EXCLUDED.seller_id
    updated_at = CASE WHEN 
                        final.fct_order_activity.order_nk <> EXCLUDED.order_nk
                        OR final.fct_order_activity.customer_id <> EXCLUDED.customer_id
                        OR stg.fct_order_activity.order_status <> EXCLUDED.order_status
                        OR stg.fct_order_activity.order_purchase_timestamp <> EXCLUDED.order_purchase_timestamp
                        OR stg.fct_order_activity.order_approved_at <> EXCLUDED.order_approved_at
                        OR stg.fct_order_activity.order_delivered_carrier_date <> EXCLUDED.order_delivered_carrier_date
                        OR stg.fct_order_activity.order_delivered_customer_date <> EXCLUDED.order_delivered_customer_date
                        OR stg.fct_order_activity.order_estimated_delivery_date <> EXCLUDED.order_estimated_delivery_date
                        OR stg.fct_order_activity.seller_id <> EXCLUDED.seller_id                        
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.fct_order_activity.updated_at
                END;