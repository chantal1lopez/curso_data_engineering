

WITH source AS (
    SELECT * FROM {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        "COALESCE(ORDER_ID, 'default_order_id')",
        "COALESCE(PRODUCT_ID, 'default_product_id')"
    ]) }} AS ORDER_ITEM_ID,
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    _FIVETRAN_DELETED AS _FIVETRAN_DELETED_UTC,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source


