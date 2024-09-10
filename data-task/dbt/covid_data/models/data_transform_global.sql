{{
  config(
    materialized='view', unlogged=True
  )
}}

SELECT
    COALESCE(FIPS, 'Not US country') AS fips,
    COALESCE(Admin2, 'Not a US county') AS us_county,
    Province_State AS province_state,
    Country_Region AS country,
    Last_Update AS last_update,
    Lat AS latitude,
    Long_ AS longitude,
    Confirmed AS num_of_confirmed,
    Deaths AS num_of_deaths,
    Recovered AS num_of_recovered,
    Active AS num_of_active,
    COALESCE(Combined_Key, 'No Data') AS province_country_location,
    COALESCE(Incident_Rate, 0.0) AS incident_rate,
    COALESCE(Case_Fatality_Ratio, 0.0) AS case_fatality_ratio
FROM {{ source('mage_covid_data','global_covid_data_global_load_data') }}