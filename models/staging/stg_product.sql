-- models/staging/stg_product.sql
-- Staging model for product data

select distinct
    product_id,
    name,
    product_number,
    color,
    safety_stock_level,
    reorder_point,
    standard_cost as standard_cost_usd,
    list_price as list_price_usd,
    size,
    weight,
    days_to_manufacture,
    product_line,
    class, 
    style,
    product_subcategory_id,
    product_model_id,
    sell_start_date,
    sell_end_date,
    discontinued_date,
    modified_date

from {{ ref('product_snapshot') }}

where dbt_valid_to is null