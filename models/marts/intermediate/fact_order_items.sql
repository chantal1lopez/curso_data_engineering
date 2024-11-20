WITH products AS (
    SELECT 
        PRODUCT_ID,  
        PRICE
    FROM {{ ref('stg_sql_server_dbo__products') }}
),
order_items AS (
    SELECT
        ORDER_ITEM_ID,
        ORDER_ID,
        PRODUCT_ID,
        QUANTITY
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
),
fact_data AS (
    SELECT 
        oi.ORDER_ITEM_ID,
        oi.ORDER_ID,
        oi.PRODUCT_ID,
        oi.QUANTITY,
        p.PRODUCT_PRICE,
        oi.QUANTITY * p.PRODUCT_PRICE AS ITEMS_TOTAL_COST
        
    FROM order_items oi
    LEFT JOIN products p ON oi.PRODUCT_ID = p.PRODUCT_ID
)


SELECT * 
FROM fact_data
