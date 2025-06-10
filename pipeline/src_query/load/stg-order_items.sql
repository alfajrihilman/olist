INSERT INTO stg.order_items 
    (order_id, order_item_id, seller_id, shipping_limit_date, price) 

SELECT
    order_id, order_item_id, seller_id, shipping_limit_date, price
FROM public.order_items

ON CONFLICT(order_id) 
DO UPDATE SET
    order_item_id = EXCLUDED.order_item_id,
    seller_id = EXCLUDED.seller_id,
    shipping_limit_date = EXCLUDED.shipping_limit_date,
    price = EXCLUDED.price,
    updated_at = CASE WHEN 
                        stg.order_items.order_item_id <> EXCLUDED.order_item_id
                        OR stg.order_items.seller_id <> EXCLUDED.seller_id
                        OR stg.order_items.shipping_limit_date <> EXCLUDED.shipping_limit_date
                        OR stg.order_items.price <> EXCLUDED.price
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        stg.order_items.updated_at
                END;