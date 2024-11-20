

WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__promos') }}
)


SELECT PROMO_ID
        , PROMO_NAME
        , DISCOUNT_EUR
        ,_FIVETRAN_DELETED
        ,_FIVETRAN_SYNCED_UTC
FROM source
