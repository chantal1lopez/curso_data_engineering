{{
  config(
    materialized='incremental'
  )
}}

WITH source AS (
    SELECT * FROM {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}
)

SELECT
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    FIVETRAN_DELETED,  
    _FIVETRAN_SYNCED 
FROM source
;

-- incompleto