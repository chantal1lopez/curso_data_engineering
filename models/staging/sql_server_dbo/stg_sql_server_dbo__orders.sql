
WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT
    ORDER_ID,
    SHIPPING_SERVICE_ID,
    SHIPPING_COST_EUR,  
    ADDRESS_ID,
    PROMO_ID,
    ORDER_COST_EUR,  
    USER_ID,
    ORDER_TOTAL_EUR,  
    TRACKING_ID,
    ORDER_STATUS_ID,
    CREATED_AT_UTC,
    ESTIMATED_DELIVERY_AT_UTC,
    DELIVERED_AT_UTC,
    _FIVETRAN_DELETED_UTC,
    _FIVETRAN_SYNCED_UTC
FROM source 





-- pensar que tabla sacar de dimseniones y cual de hechos 

-- hacer tabla tiempo dimension 