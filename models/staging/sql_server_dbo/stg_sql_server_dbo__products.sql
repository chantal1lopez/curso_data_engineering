{{
  config(
    materialized='incremental'  
  )
}}

WITH source AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PRODUCTS') }}
)

SELECT
    PRODUCT_ID,  
    INITCAP(NAME) AS PRODUCT_NAME,
    CASE 
        WHEN PRICE IS NULL THEN 0.0  
        WHEN PRICE < 0 THEN 0.0  
        ELSE PRICE
    END AS PRICE,
    'EUR' AS CURRENCY, 
    CASE 
        WHEN INVENTORY IS NULL THEN 0  
        WHEN INVENTORY < 0 THEN 0  
        ELSE INVENTORY
    END AS INVENTORY,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_DELETED) AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source
;  
