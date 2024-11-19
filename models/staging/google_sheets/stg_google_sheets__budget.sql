{{
  config(
    materialized='incremental'
  )
}}

WITH source AS (
    SELECT * FROM {{ source('GOOGLE_SHEETS', 'BUDGET') }}
)

SELECT
    _ROW AS ROW_ID, 
    PRODUCT_ID,
    QUANTITY,
    EXTRACT(YEAR FROM TO_DATE(MONTH)) AS YEAR,  -- Extraer el año
    EXTRACT(MONTH FROM TO_DATE(MONTH)) AS MONTH,
    _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source
;