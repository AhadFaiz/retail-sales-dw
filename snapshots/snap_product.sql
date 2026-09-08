-- models/snapshots/snap_product.sql
-- ==========================================================

-- Where the historical table will be saved
-- The column that uniquely identifies the entity being tracked
-- Specifies that dbt should look for changes in specific columns
-- List of columns that, if changed, trigger a new historical record

{% snapshot product_snapshot %}

{{
    config(
        target_schema='SNPT',  
        unique_key = 'product_id',                 
        strategy = 'check',                       
        check_cols = [                             
            'name',
            'product_number',
            'make_flag',
            'finished_goods_flag',
            'color',
            'safety_stock_level',
            'reorder_point',
            'standard_cost',
            'list_price',
            'size',
            'size_unit_measure_code',
            'weight',
            'weight_unit_measure_code',
            'days_to_manufacture',
            'product_line',
            'class',
            'style',
            'product_subcategory_id',
            'product_model_id',
            'sell_start_date',
            'sell_end_date',
            'discontinued_date'
        ]
    )
}}

-- Select raw product data as-is (no transformations)
select
    product_id,
    name,
    product_number,
    make_flag,
    finished_goods_flag,
    color,
    safety_stock_level,
    reorder_point,
    standard_cost,
    list_price,
    size,
    size_unit_measure_code,
    weight,
    weight_unit_measure_code,
    days_to_manufacture,
    product_line,
    class,
    style,
    product_subcategory_id,
    product_model_id,
    sell_start_date,
    sell_end_date,
    discontinued_date,
    rowguid,
    modified_date
from {{ source('raw_data_source', 'RAW_PRODUCT') }}

{% endsnapshot %}
