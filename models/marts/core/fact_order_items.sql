{{
  config(
    materialized='table'
  )
}}

SELECT * 
FROM {{ ref('int_order_items') }}
