-- models/snapshots/snap_productsubcategory.sql
-- ==========================================================
-- Purpose:
-- Tracks historical changes in product subcategory reference data.
-- Captures updates to names and category relationships over time.
-- ==========================================================

{% snapshot productcategory_snapshot %}

{{
    config(
        target_schema='SNPT',
        unique_key = 'productcategoryid',
        strategy = 'check',                    
        check_cols = [                         
            'name'
        ]
    )
}}

-- Select source data directly (no transformations)
select distinct
    productcategoryid,      -- Foreign key to related product category
    name,                   -- Name of the product subcategory
    modifieddate,           -- Last modified timestamp
from {{ source('raw_data_source', 'RAW_PRODUCTCATEGORY') }}

{% endsnapshot %}
