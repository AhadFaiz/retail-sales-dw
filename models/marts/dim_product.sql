-- models/marts/dim_product.sql
-- ===========================================================
-- Combines product, product category, and subcategory data
-- Product dimension with unified modified timestamp
-- Incremental model using merge strategy
-- Use modifieddate column to filter for new records or changed records.
-- Grain: One row per product
-- ===========================================================

{{
    config(
        incremental_strategy = 'merge',
        unique_key = 'product_id'
    )
}}

-- Determine the latest modification date from the existing table
-- to only process new or changed records during incremental runs
{% if is_incremental() %}
    {% set MAX_START_DATE_query %}
        select ifnull(max(modified_at), '1900-01-01') from {{ this }} as MAX_START_DT
    {% endset %}

    {% if execute %}
        {% set MAX_START_DT = run_query(MAX_START_DATE_query).columns[0][0] %}
    {% endif %}
{% endif %}

-- Combine product, subcategory, and category data
with joined_product_data as (
    select
        p.product_id,
        p.name,
        p.product_number,
        p.product_model_id,
        p.product_subcategory_id,
        s.product_subcategory,
        c.product_category_id,
        c.product_category,
        p.color,
        p.safety_stock_level,
        p.reorder_point,
        p.standard_cost_usd,
        p.list_price_usd,
        p.size,
        p.weight,
        p.product_line,
        p.class,
        p.style,
        p.sell_start_date,
        p.sell_end_date,
        p.discontinued_date,
        -- Capture the most recent modification date from any joined source
        greatest(p.modified_date, s.modified_date, c.modified_date) as modified_at
    from {{ ref('stg_product') }} as p
    left join {{ ref('stg_productSubCategory') }} as s
        on p.product_subcategory_id = s.product_subcategory_id
    left join {{ ref('stg_productCategory') }} as c
        on s.product_category_id = c.product_category_id
)

select *
from joined_product_data

-- Incremental filter: only include records modified after the last load
{% if is_incremental() %}
where modified_at >= '{{ MAX_START_DT }}'
{% endif %}
