-- snapshots/snap_countryregion.sql
-- ==========================================================
-- Purpose:
-- Tracks historical changes in country-region reference data,
-- including name and currency code updates.
-- ==========================================================

{% snapshot countryregion_snapshot %}

{{
    config(
        target_schema='SNPT',
        unique_key = 'countryregioncode',
        strategy = 'check',                  
        check_cols = [                       
            'name',
            'currencycode'
        ]
    )
}}

-- Select source data directly (no transformations)
select distinct
    countryregioncode,   -- Country or region business key
    name,                -- Country or region name
    currencycode,         -- Associated currency code
    modifieddate          -- Last modified timestamp from source
from {{ source('raw_data_source', 'RAW_COUNTRYREGION') }}

{% endsnapshot %}
