WITH events AS (
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
    FROM {{ ref('fact_events') }}
),
event_types AS (
    SELECT 
        EVENT_TYPE_ID,
        EVENT_TYPE
    FROM {{ ref('stg_sql_server_dbo__events_type') }}
),
user_info AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__users') }}
),
session_metrics AS (
    SELECT 
        e.SESSION_ID,
        e.USER_ID,
        MIN(e.EVENT_CREATED_AT_utc) AS FIRST_EVENT_TIME_UTC,
        MAX(e.EVENT_CREATED_AT_utc) AS LAST_EVENT_TIME_UTC,
        DATEDIFF(MINUTE, MIN(e.EVENT_CREATED_AT_utc), MAX(e.EVENT_CREATED_AT_utc)) AS SESSION_DURATION_MINUTES,
        
        COUNT(DISTINCT CASE WHEN et.EVENT_TYPE = 'add_to_cart' THEN e.EVENT_ID ELSE NULL END) AS ADD_TO_CART_EVENTS,
        COUNT(DISTINCT CASE WHEN et.EVENT_TYPE = 'checkout' THEN e.EVENT_ID ELSE NULL END) AS CHECKOUT_EVENTS,
        COUNT(DISTINCT CASE WHEN et.EVENT_TYPE = 'package_shipped' THEN e.EVENT_ID ELSE NULL END) AS PACKAGE_SHIPPED_EVENTS,
        COUNT(DISTINCT CASE WHEN et.EVENT_TYPE = 'page_view' THEN e.EVENT_ID ELSE NULL END) AS PAGE_VIEW_EVENTS
    FROM events e
    LEFT JOIN event_types et
        ON e.EVENT_TYPE_ID = et.EVENT_TYPE_ID
    GROUP BY e.SESSION_ID, e.USER_ID
)

SELECT
    sm.SESSION_ID,
    sm.USER_ID,
    ui.FIRST_NAME,
    ui.EMAIL,
    
    sm.FIRST_EVENT_TIME_UTC AS SESSION_FIRST_EVENT_TIME_UTC,
    sm.LAST_EVENT_TIME_UTC AS SESSION_LAST_EVENT_TIME_UTC,
    sm.SESSION_DURATION_MINUTES AS SESSION_DURATION_MINUTES,
    
    sm.PAGE_VIEW_EVENTS,
    sm.ADD_TO_CART_EVENTS,
    sm.CHECKOUT_EVENTS,
    sm.PACKAGE_SHIPPED_EVENTS

FROM session_metrics sm
JOIN user_info ui
    ON sm.USER_ID = ui.USER_ID
