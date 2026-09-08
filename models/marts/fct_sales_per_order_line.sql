-- models/marts/fct_sales_order.sql
-- ==========================================================
-- Purpose:
-- Fact table for sales transactions with incremental MERGE logic.
-- Includes a 7-day lookback window to handle late-arriving or updated records.
-- ==========================================================

{{ config(
    incremental_strategy = 'merge',
    unique_key = ['sales_order_detail_id', 'sales_order_id']
) }}

-- Join header and detail to create unified transactional dataset
with joined_sales_data as (
    select distinct
    d.sales_order_detail_id,    -- Line-item unique ID (grain)
    d.sales_order_id,          -- Parent order ID
    h.customer_id,            -- Customer reference
    h.sales_person_id,         -- Salesperson reference
    h.territory_id,           -- Territory reference
    d.product_id,             -- Product sold
    d.order_qty,              -- Quantity ordered
    d.unit_price_usd,             -- Unit price (positive)
    d.unit_price_discount_usd,     -- Unit discount
    d.line_total_usd,             -- Line total
    h.sub_total_usd,              -- Order subtotal
    h.tax_amount_usd,                -- Tax amount
    h.freight_charge_usd,               -- Freight charges
    h.total_due_usd,              -- Total due
    h.order_status,                -- Order status
    h.order_date,             -- Order creation date
    h.due_date,               -- Due date
    h.ship_date,              -- Shipping date
    -- Unified modified timestamp: capture the latest change from all sources
    greatest(h.modified_date, d.modified_date) as modified_at

from {{ ref('stg_salesOrderDetail') }} d
left join {{ ref('stg_salesOrderHeader') }} h
    on d.sales_order_id = h.sales_order_id
)

select *
from joined_sales_data

-- Incremental logic with 7-day lookback window
{% if is_incremental() %}
where order_date >= dateadd(day, -7, (select max(order_date) from {{ this }}))
{% endif %}
