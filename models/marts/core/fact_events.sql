{{
  config(
    materialized='table'
  )
}}

SELECT 
    EVENT_ID,
    PAGE_URL,
    EVENT_TYPE_ID,
    USER_ID,
    PRODUCT_ID,
    SESSION_ID,
    EVENT_CREATED_AT_utc,
    ORDER_ID,
    _FIVETRAN_DELETED_UTC,
    _FIVETRAN_SYNCED_UTC
FROM {{ ref('stg_sql_server_dbo__events') }}
