WITH source AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__promos') }}
)


SELECT  DISTINCT STATUS_ID
        , STATUS_DESC
FROM source