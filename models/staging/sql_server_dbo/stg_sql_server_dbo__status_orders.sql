
WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
)

SELECT
    ORDER_STATUS_ID,
    ORDER_STATUS
FROM source 


