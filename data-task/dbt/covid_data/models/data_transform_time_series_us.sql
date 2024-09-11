{{
  config(
    materialized='view'
  )
}}

SELECT
    * -- Getting all the values on the table
FROM {{ source('mage_covid_data','us_time_series_covid_data_load_data') }}