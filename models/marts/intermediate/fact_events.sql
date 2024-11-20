WITH events AS (
    SELECT 
        EVENT_ID,
        PAGE_URL,
        EVENT_TYPE_ID,
        USER_ID,
        PRODUCT_ID,
        SESSION_ID,
        CONVERT_TIMEZONE('UTC', CREATED_AT) AS EVENT_CREATED_AT_utc,
        ORDER_ID,
        _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__events') }}
),
event_types AS (
    SELECT 
        EVENT_TYPE_ID,
        EVENT_TYPE
    FROM {{ ref('stg_sql_server_dbo__event_type') }}
)

SELECT 
    e.EVENT_ID,
    e.PAGE_URL,
    e.EVENT_TYPE_ID,
    et.EVENT_TYPE,
    e.USER_ID,
    e.PRODUCT_ID,
    e.SESSION_ID,
    e.ORDER_ID,
    e.EVENT_CREATED_AT_utc,
    e._FIVETRAN_DELETED_UTC,
    e._FIVETRAN_SYNCED_UTC,
    
    COUNT(CASE WHEN et.EVENT_TYPE = 'add_to_cart' THEN 1 END) AS ADD_TO_CART_EVENTS,
    COUNT(CASE WHEN et.EVENT_TYPE = 'checkout' THEN 1 END) AS CHECKOUT_EVENTS,
    COUNT(CASE WHEN et.EVENT_TYPE = 'package_shipped' THEN 1 END) AS PACKAGE_SHIPPED_EVENTS,
    COUNT(CASE WHEN et.EVENT_TYPE = 'page_view' THEN 1 END) AS PAGE_VIEW_EVENTS,

    
    DATEDIFF(SECOND, 
        MIN(e.EVENT_CREATED_AT_utc) OVER (PARTITION BY e.SESSION_ID), 
        MAX(e.EVENT_CREATED_AT_utc) OVER (PARTITION BY e.SESSION_ID)   
    ) AS SESSION_DURATION_SECONDS

FROM events e
LEFT JOIN event_types et
    ON e.EVENT_TYPE_ID = et.EVENT_TYPE_ID

GROUP BY 
    e.EVENT_ID,
    e.PAGE_URL,
    e.EVENT_TYPE_ID,
    et.EVENT_TYPE,
    e.USER_ID,
    e.PRODUCT_ID,
    e.SESSION_ID,
    e.ORDER_ID,
    e.EVENT_CREATED_AT_utc,
    e._FIVETRAN_DELETED_UTC,
    e._FIVETRAN_SYNCED_UTC
