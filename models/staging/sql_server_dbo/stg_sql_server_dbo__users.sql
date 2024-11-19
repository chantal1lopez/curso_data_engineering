{{
  config(
    materialized='incremental'  
  )
}}

WITH source AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'USERS') }}
)

SELECT
    USER_ID,
    INITCAP(FIRST_NAME) AS FIRST_NAME,  
    INITCAP(LAST_NAME) AS LAST_NAME,   
    CASE 
        WHEN EMAIL IS NULL THEN 'unknown@example.com'  
        WHEN NOT REGEXP_LIKE(EMAIL, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN 'invalid@example.com'
        ELSE LOWER(EMAIL)  -
    END AS EMAIL,
    CASE 
        WHEN PHONE_NUMBER IS NULL THEN 'unknown'  
        ELSE REGEXP_REPLACE(PHONE_NUMBER, '[^0-9]', '')  
    END AS PHONE_NUMBER,
    TOTAL_ORDERS AS USER_TOTAL_ORDERS,  
    CONVERT_TIMEZONE('UTC', CREATED_AT) AS USER_CREATED_AT_UTC,
    CONVERT_TIMEZONE('UTC', UPDATED_AT) AS USER_UPDATED_AT_UCT,
    CASE 
        WHEN ADDRESS_ID IS NULL THEN 'unknown'
        ELSE ADDRESS_ID
    END AS ADDRESS_ID,
    _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source
;  
