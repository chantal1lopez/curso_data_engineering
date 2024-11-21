
WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT
    ORDER_ID,
    ADDRESS_ID,
    PROMO_ID,
    USER_ID,
    CREATED_AT_UTC,
    TRACKING_ID,
    ORDER_STATUS_ID,
    ESTIMATED_DELIVERY_AT_UTC,
    DELIVERED_AT_UTC,
    _FIVETRAN_DELETED_UTC,
    _FIVETRAN_SYNCED_UTC
FROM source 




