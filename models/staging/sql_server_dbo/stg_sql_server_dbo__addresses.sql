{{
  config(
    materialized='incremental'
  )
}}

WITH source AS (
    SELECT * FROM {{ source('SQL_SERVER_DBO', 'ADDRESSES') }}
)

SELECT
    ADDRESS_ID,
    ZIPCODE,
    COUNTRY,
    ADDRESS,
    STATE,
    _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source
;
