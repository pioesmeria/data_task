{{
  config(
    materialized='view', unlogged=True
  )
}}

SELECT
    *
FROM {{ source('mage_covid_data','time_series_covid_data_time_series_load_data') }}