{{
  config(
    materialized='view', unlogged=True
  )
}}

SELECT
    *
FROM {{ source('mage_covid_data','us_time_series_covid_data_us_time_series_load_data') }}