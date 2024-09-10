{{ 
  config(
    materialized='view', unlogged=True
  ) 
}}

SELECT DISTINCT
    COALESCE(strftime(Date, '%Y-%m-%d'), strftime(Last_Update, '%Y-%m-%d')) AS date,
    Province_State AS province_state,
    Country_Region AS country_region,
    Last_Update AS last_update,
    Lat AS latitude,
    Long_ AS longitude,
    Confirmed AS num_of_confirmed,
    Deaths AS num_of_deaths,
    COALESCE(Recovered, 0.0) AS num_of_recovered,
    COALESCE(Active, 0.0) AS num_of_active,
    FIPS AS fips,
    COALESCE(Incident_Rate, 0.0) AS incident_rate,
    COALESCE(Total_Test_Results, 0.0) AS total_test_result,
    COALESCE(People_Hospitalized, 0.0) AS num_of_people_hospitalized,
    Case_Fatality_Ratio AS case_fatality_ratio,
    UID AS uid,
    ISO3 AS iso3,
    COALESCE(Testing_Rate, 0.0) AS testing_rate,
    COALESCE(Hospitalization_Rate, 0.0) AS hospitalization_rate,
    COALESCE(People_Tested, 0.0) AS num_of_people_tested,
    COALESCE(Mortality_Rate, 0.0) AS mortality_rate
FROM {{ source('mage_covid_data','us_covid_data_us_load_data') }}