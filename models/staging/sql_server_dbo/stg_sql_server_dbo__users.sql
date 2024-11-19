

WITH source AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'USERS') }}
)

SELECT
    USER_ID,
    INITCAP(FIRST_NAME) AS FIRST_NAME,  
    INITCAP(LAST_NAME) AS LAST_NAME,   
    CASE 
        WHEN NOT REGEXP_LIKE(EMAIL, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN 'invalid@example.com'
        ELSE LOWER(EMAIL)  
    END AS EMAIL,
    PHONE_NUMBER,
    TOTAL_ORDERS AS USER_TOTAL_ORDERS,  
    CONVERT_TIMEZONE('UTC', CREATED_AT) AS USER_CREATED_AT_UTC,
    CONVERT_TIMEZONE('UTC', UPDATED_AT) AS USER_UPDATED_AT_UCT,
    ADDRESS_ID,
    _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source

