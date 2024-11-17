{{
  config(
    materialized='incremental'
  )
}}

WITH promo_source AS (
    SELECT
        md5( COALESCE(PROMO_NAME, 'default_value') || COALESCE(STATUS, 'default_value') || COALESCE(DISCOUNT, 'default_status')) AS PROMO_ID, -- Nuevo Promo ID generado
        PROMO_NAME
    FROM {{ source('SQL_SERVER_DBO', 'PROMOS') }}
),
order_source AS (
    SELECT * FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}
)

SELECT
    o.ORDER_ID,
    o.SHIPPING_SERVICE,
    o.SHIPPING_COST  AS SHIPPING_COST_EUR,  
    o.ADDRESS_ID,
    CASE 
        WHEN o.PROMO_ID IS NULL THEN NULL 
        ELSE p.PROMO_ID 
    END AS PROMO_ID,
    o.ORDER_COST  AS ORDER_COST_EUR,  
    o.USER_ID,
    o.ORDER_TOTAL  AS ORDER_TOTAL_EUR,  
    o.TRACKING_ID,
    o.STATUS,
    CONVERT_TIMEZONE('UTC', o.CREATED_AT) AS CREATED_AT_UTC,
    CONVERT_TIMEZONE('UTC', o.ESTIMATED_DELIVERY_AT) AS ESTIMATED_DELIVERY_AT_UTC,
    CONVERT_TIMEZONE('UTC', o.DELIVERED_AT) AS DELIVERED_AT_UTC,
    CONVERT_TIMEZONE('UTC', o._FIVETRAN_DELETED) AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', o._FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM order_source o
LEFT JOIN promo_source p
ON o.PROMO_ID = p.PROMO_NAME 
;
