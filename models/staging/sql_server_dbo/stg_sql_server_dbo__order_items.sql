{{
  config(
    materialized='incremental'
  )
}}

WITH source AS (
    SELECT * FROM {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}
)

SELECT
    md5(COALESCE(ORDER_ID, 'default_order_id') || COALESCE(PRODUCT_ID, 'default_product_id')) AS ORDER_ITEM_ID
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_DELETED) AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source
;

-- como comprobamos que el order_id y el product_id son validos ?? 