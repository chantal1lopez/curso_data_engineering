{{
  config(
    materialized='view'
  )
}}

WITH order_source AS (
        SELECT * FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}

)
SELECT
    ORDER_ID,
    {{ dbt_utils.generate_surrogate_key(['SHIPPING_SERVICE']) }} as SHIPPING_SERVICE_ID,
    SHIPPING_SERVICE,
    SHIPPING_COST  AS SHIPPING_COST_EUR,  
    ADDRESS_ID,
    {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as PROMO_ID,
    ORDER_COST  AS ORDER_COST_EUR,  
    USER_ID,
    ORDER_TOTAL  AS ORDER_TOTAL_EUR,  
    TRACKING_ID,
    {{ dbt_utils.generate_surrogate_key(['STATUS']) }} as ORDER_STATUS_ID,
    STATUS AS ORDER_STATUS,
    CONVERT_TIMEZONE('UTC', CREATED_AT) AS CREATED_AT_UTC,
    CONVERT_TIMEZONE('UTC', ESTIMATED_DELIVERY_AT) AS ESTIMATED_DELIVERY_AT_UTC,
    CONVERT_TIMEZONE('UTC', DELIVERED_AT) AS DELIVERED_AT_UTC,
    _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM order_source 