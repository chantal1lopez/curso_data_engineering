
WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT
    ORDER_ID,
    SHIPPING_SERVICE_ID,
    SHIPPING_COST_EUR,  
    ORDER_COST_EUR,  
    ORDER_TOTAL_EUR,  
    _FIVETRAN_DELETED_UTC,
    _FIVETRAN_SYNCED_UTC
FROM source 




