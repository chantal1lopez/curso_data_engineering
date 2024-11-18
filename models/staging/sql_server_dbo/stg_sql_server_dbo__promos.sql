{{
  config(
    materialized='incremental'
  )
}}

WITH source AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PROMOS') }}
),

renamed_casted AS (
    SELECT
          PROMO_ID as PROMO_ID
        , PROMO_ID as PROMO_NAME
        , CASE WHEN DISCOUNT IS NULL THEN 0
             WHEN DISCOUNT < 0 THEN 0  
             ELSE DISCOUNT
            END as DISCOUNT_EUR
        , status
        ,  _FIVETRAN_DELETED
        , CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
    FROM source
    union all
    select  'sin_promo'
            ,'sin_promo'
            , 0
            , 'unknown'
            , null
            , null
)

SELECT {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as PROMO_ID
        , PROMO_ID as PROMO_NAME
        , DISCOUNT_EUR
        , status as PROMO_STATUS
        ,_FIVETRAN_DELETED
        ,_FIVETRAN_SYNCED_UTC
FROM renamed_casted