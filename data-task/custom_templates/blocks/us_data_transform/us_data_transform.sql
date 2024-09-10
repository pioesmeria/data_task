{{ 
  config(
    materialized='view', unlogged=True
  ) 
}}

SELECT
    COALESCE("Date",DATE("Last_Update")) AS date,
    "Province_State" AS province_state,
    "Country_Region" AS country_region,
    "Last_Update" AS last_update,
    "Lat" AS latitude,
    "Long_" AS longitude,
    "Confirmed" AS num_of_confirmed,
    "Deaths" AS num_of_deaths,
    "Recovered" AS num_of_recovered,
    "Active" AS num_of_active,
    "FIPS" AS fips,
    "Incident_Rate" AS incident_rate,
    "Total_Test_Results" AS total_test_result,
    "People_Hospitalized" AS num_of_people_hospitalized,
    "Case_Fatality_Ratio" AS case_fatality_ratio,
    "UID" AS uid,
    "ISO3" AS iso3,
    "Testing_Rate" AS testing_rate,
    COALESCE("Hospitalization_Rate",0.0) AS hospitalization_rate,
    COALESCE("People_Tested", 0.0) AS num_of_people_tested,
    COALESCE("Mortality_Rate", 0.0) AS mortality_rate
FROM {{ source('mage_demo','covid_data_us_load_data') }}