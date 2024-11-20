

WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}

)

SELECT
    EVENT_TYPE_ID,
    EVENT_TYPE
FROM source

