{{ 
  config(
    materialized='view'
  ) 
}}

-- This query retrieves and transforms COVID-19 data from the specified source.
-- It integrates information from two sources: the primary COVID-19 data and a lookup table.
-- The resulting view contains distinct records, with standardized date formatting and default values for handling nulls.

SELECT DISTINCT
  COALESCE(us_covid.UID, lookup_table.UID) AS uid,                            -- Uses 'UID' from either 'us_covid' or 'lookup_table', prioritizing 'us_covid'.
  
  COALESCE(
      strftime(us_covid.Date, '%Y-%m-%d'),   -- Formats 'Date' from 'us_covid' as 'YYYY-MM-DD'.
      strftime(us_covid.Last_Update, '%Y-%m-%d')  -- If 'Date' is null, formats 'Last_Update' from 'us_covid' as 'YYYY-MM-DD'.
  ) AS date,
  
  COALESCE(us_covid.Province_State, 'No Data') AS province_state,   -- Uses 'Province_State' from 'us_covid', defaulting to 'No Data' if null.
  COALESCE(us_covid.Country_Region, 'No Data') AS country_region,   -- Uses 'Country_Region' from 'us_covid', defaulting to 'No Data' if null.
  
  COALESCE(us_covid.FIPS, lookup_table.FIPS) AS fips,                       -- Uses 'FIPS' from either 'us_covid' or 'lookup_table', prioritizing 'us_covid'.
  COALESCE(us_covid.ISO3, lookup_table.ISO3) AS iso3,                          -- Uses 'ISO3' from either 'us_covid' or 'lookup_table', prioritizing 'us_covid'.
  
  COALESCE(us_covid.Last_Update, strftime('%A, %-d %B %Y - %I:%M:%S %p', us_covid.Date)) AS last_update,         -- Uses 'Last_Update' from 'us_covid', defaulting to a formatted version of 'Date' if 'Last_Update' is null.
  
  COALESCE(us_covid.Lat, 0.0) AS latitude,                    -- Uses 'Lat' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Long_, 0.0) AS longitude,                 -- Uses 'Long_' from 'us_covid', defaulting to 0.0 if null.
  
  COALESCE(us_covid.Confirmed, 0.0) AS num_of_confirmed,      -- Uses 'Confirmed' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Deaths, 0.0) AS num_of_deaths,            -- Uses 'Deaths' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Recovered, 0.0) AS num_of_recovered,  -- Uses 'Recovered' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Active, 0.0) AS num_of_active,       -- Uses 'Active' from 'us_covid', defaulting to 0.0 if null.
  
  COALESCE(us_covid.Incident_Rate, 0.0) AS incident_rate,   -- Uses 'Incident_Rate' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Total_Test_Results, 0.0) AS total_test_result,   -- Uses 'Total_Test_Results' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.People_Hospitalized, 0.0) AS num_of_people_hospitalized,   -- Uses 'People_Hospitalized' from 'us_covid', defaulting to 0.0 if null.
  
  COALESCE(us_covid.Case_Fatality_Ratio, 0.0) AS case_fatality_ratio,   -- Uses 'Case_Fatality_Ratio' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Testing_Rate, 0.0) AS testing_rate,   -- Uses 'Testing_Rate' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Hospitalization_Rate, 0.0) AS hospitalization_rate,   -- Uses 'Hospitalization_Rate' from 'us_covid', defaulting to 0.0 if null.
  
  COALESCE(us_covid.People_Tested, 0.0) AS num_of_people_tested,   -- Uses 'People_Tested' from 'us_covid', defaulting to 0.0 if null.
  COALESCE(us_covid.Mortality_Rate, 0.0) AS mortality_rate   -- Uses 'Mortality_Rate' from 'us_covid', defaulting to 0.0 if null.

FROM {{ source('mage_covid_data', 'us_covid_data_us_load_data') }} AS us_covid
INNER JOIN {{ ref('UID_ISO_FIPS_LookUp_Table') }} AS lookup_table
  ON us_covid.UID = lookup_table.UID

-- Source: 'mage_covid_data' schema and 'us_covid_data_us_load_data' table/view.
-- Lookup table: 'UID_ISO_FIPS_LookUp_Table' referenced for additional information.
