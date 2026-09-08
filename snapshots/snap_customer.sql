-- snapshots/snap_customer.sql
-- ==========================================================

-- Where the historical table will be saved
-- The column that uniquely identifies the entity being tracked
-- Specifies that dbt should look for changes in specific columns
-- List of columns that, if changed, trigger a new historical record

{% snapshot customer_snapshot %}

{{
    config(        
        target_schema='SNPT',
        unique_key='customerid',             
        strategy='check',                    
        check_cols=[                         
            'accountnumber',
            'personid',
            'storeid',
            'territoryid'
        ]
    )
}}

-- Select the source data exactly as it is (no transformations yet)
select
    customerid,
    accountnumber,
    personid,
    storeid,
    territoryid,
    modifieddate,
    rowguid
from {{ source('raw_data_source', 'RAW_CUSTOMER') }}

{% endsnapshot %}
