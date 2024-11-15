{{
  config(
    materialized='incremental'
  )
}}

WITH source AS (
    SELECT * FROM {{ source('SQL_SERVER_DBO', 'PROMOS') }}
)

SELECT
    md5( COALESCE(PROMO_NAME, 'default_value') || COALESCE(STATUS, 'default_value') || COALESCE(DISCOUNT, 'default_status')) AS PROMO_ID
    PROMO_ID AS PROMO_NAME,
    CASE
        WHEN DISCOUNT IS NULL THEN 0  
        WHEN DISCOUNT < 0 THEN 0  
        ELSE DISCOUNT  
    END AS DISCOUNT,
    STATUS AS PROMOS_STATUS,
    CASE 
        WHEN STATUS IS NULL THEN 'unknown'  
        ELSE STATUS
    END AS PROMOS_STATUS,  
    CONVERT_TIMEZONE('UTC', _FIVETRAN_DELETED) AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC

FROM source
;

-- aqui hay que crear una fila de promos que sea nulo 