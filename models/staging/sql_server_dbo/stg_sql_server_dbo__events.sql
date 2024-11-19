

WITH source AS (
    SELECT * FROM {{ source('SQL_SERVER_DBO', 'EVENTS') }}
)

SELECT
    EVENT_ID,
    PAGE_URL,
    EVENT_TYPE,
    USER_ID,
    PRODUCT_ID,
    SESSION_ID,
    CONVERT_TIMEZONE('UTC', CREATED_AT) AS EVENT_CREATED_AT_utc
    ORDER_ID,
    _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source

-- que se hace si aqui las claves product_id, session_id y order_id son nulas ??