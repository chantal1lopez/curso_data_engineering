
WITH date_spine AS (
    {{ dbt_utils.date_spine(
        start_date="2020-01-01", 
        end_date="2024-12-31",
    ) }}
)

SELECT
    date_spine.date AS date_id,
    EXTRACT(YEAR FROM date_spine.date) AS year,
    EXTRACT(MONTH FROM date_spine.date) AS month,
    EXTRACT(DAY FROM date_spine.date) AS day,
    EXTRACT(QUARTER FROM date_spine.date) AS quarter,
    EXTRACT(DOW FROM date_spine.date) AS day_of_week,
    CASE 
        WHEN EXTRACT(DOW FROM date_spine.date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    -- Puedes añadir más campos si es necesario
    date_spine.date AS full_date
FROM date_spine
