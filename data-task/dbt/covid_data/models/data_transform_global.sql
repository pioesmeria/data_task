{{
  config(
    materialized='view'
  )
}}

-- This query retrieves and transforms global COVID-19 data from a specified source.
-- It integrates data from a primary COVID-19 dataset and a lookup table.
-- The resulting view contains distinct records with standardized and default values for handling nulls.

SELECT DISTINCT
    COALESCE(
      strftime(global_covid.Date, '%Y-%m-%d'),   -- Formats 'Date' from 'global_covid' as 'YYYY-MM-DD'.
      strftime(global_covid.Last_Update, '%Y-%m-%d')  -- If 'Date' is null, formats 'Last_Update' from 'global_covid' as 'YYYY-MM-DD'.
    ) AS date,
    
    COALESCE(
      global_covid.FIPS,                           -- Uses 'FIPS' from 'global_covid', if present.
      COALESCE(lookup_table.FIPS, 'Not US country')  -- If 'FIPS' is null, uses 'FIPS' from 'lookup_table' or defaults to 'Not US country'.
    ) AS fips,
    
    COALESCE(
      global_covid.Admin2,                         -- Uses 'Admin2' from 'global_covid', if present.
      COALESCE(lookup_table.Admin2, 'Not a US county')  -- If 'Admin2' is null, uses 'Admin2' from 'lookup_table' or defaults to 'Not a US county'.
    ) AS us_county,
    
    COALESCE(
      global_covid.Combined_Key,                    -- Uses 'Combined_Key' from 'global_covid', if present.
      lookup_table.Combined_Key                    -- If 'Combined_Key' is null, uses 'Combined_Key' from 'lookup_table'.
    ) AS province_country_location,
    
    COALESCE(
      global_covid.Province_State,                  -- Uses 'Province_State' from 'global_covid', if present.
      lookup_table.Province_State                  -- If 'Province_State' is null, uses 'Province_State' from 'lookup_table'.
    ) AS province_state,
    
    COALESCE(
      global_covid.Country_Region,                  -- Uses 'Country_Region' from 'global_covid', if present.
      lookup_table.Country_Region                  -- If 'Country_Region' is null, uses 'Country_Region' from 'lookup_table'.
    ) AS country,
    
    COALESCE(
      global_covid.Last_Update,                     -- Uses 'Last_Update' from 'global_covid', if present.
      strftime('%A, %-d %B %Y - %I:%M:%S %p', global_covid.Date)  -- If 'Last_Update' is null, formats 'Date' as a detailed string.
    ) AS last_update, 
    
    COALESCE(
      global_covid.Lat,                            -- Uses 'Lat' from 'global_covid', if present.
      lookup_table.Lat                            -- If 'Lat' is null, uses 'Lat' from 'lookup_table'.
    ) AS latitude,
    
    COALESCE(
      global_covid.Long_,                          -- Uses 'Long_' from 'global_covid', if present.
      lookup_table.Long_                          -- If 'Long_' is null, uses 'Long_' from 'lookup_table'.
    ) AS longitude,
    
    COALESCE(
      global_covid.Confirmed,                      -- Uses 'Confirmed' from 'global_covid', if present.
      0                                          -- If 'Confirmed' is null, defaults to 0.
    ) AS num_of_confirmed,
    
    COALESCE(
      global_covid.Deaths,                         -- Uses 'Deaths' from 'global_covid', if present.
      0                                          -- If 'Deaths' is null, defaults to 0.
    ) AS num_of_deaths,
    
    COALESCE(
      global_covid.Recovered,                      -- Uses 'Recovered' from 'global_covid', if present.
      0                                          -- If 'Recovered' is null, defaults to 0.
    ) AS num_of_recovered,
    
    COALESCE(
      global_covid.Active,                        -- Uses 'Active' from 'global_covid', if present.
      0                                          -- If 'Active' is null, defaults to 0.
    ) AS num_of_active,
    
    COALESCE(
      global_covid.Incident_Rate,                  -- Uses 'Incident_Rate' from 'global_covid', if present.
      0.0                                        -- If 'Incident_Rate' is null, defaults to 0.0.
    ) AS incident_rate,
    
    COALESCE(
      global_covid.Case_Fatality_Ratio,            -- Uses 'Case_Fatality_Ratio' from 'global_covid', if present.
      0.0                                        -- If 'Case_Fatality_Ratio' is null, defaults to 0.0.
    ) AS case_fatality_ratio

FROM {{ source('mage_covid_data', 'global_covid_data_global_load_data') }} AS global_covid
LEFT JOIN {{ ref('UID_ISO_FIPS_LookUp_Table') }} AS lookup_table
  ON global_covid.Country_Region = lookup_table.Country_Region

-- Source: 'mage_covid_data' schema and 'global_covid_data_global_load_data' table/view.
-- Lookup table: 'UID_ISO_FIPS_LookUp_Table' used to fill in missing information.
