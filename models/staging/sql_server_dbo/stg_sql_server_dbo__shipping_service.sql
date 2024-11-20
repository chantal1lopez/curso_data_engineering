
WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT
    SHIPPING_SERVICE_ID,
    SHIPPING_SERVICE
FROM source 


