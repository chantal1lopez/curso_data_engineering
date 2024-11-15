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
    EXTRACT(YEAR FROM MONTH) AS YEAR,  -- Extraer el año y el mes por separado
    EXTRACT(MONTH FROM MONTH) AS MONTH, 
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source
WHERE QUANTITY > 0 -- Filtrar presupuestos no válidos
;