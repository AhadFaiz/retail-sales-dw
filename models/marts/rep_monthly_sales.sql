-- models/marts/sales/fact_monthly_sales.sql
-- ==========================================================
-- Purpose:
--   Generate monthly-level sales metrics directly from fct_sales_per_order_line table.
--   No need for incremental loading, because this table will be much smaller compared to the fact table, and fct_sales_per_order_line is already an incremental table.
-- ==========================================================

{{ config(
    materialized='table',
    unique_key='month_start_date'
) }}

-- Use a CTE to aggregate data at the order level.
with sales_per_order as (
    select 
    sales_order_id,
    max(order_date) as order_date,
    max(total_due_usd) as order_total_usd,
    max(tax_amount_usd) as total_tax_usd,
    max(freight_charge_usd) as total_freight_usd,
    sum(order_qty) as total_quantity_sold

from {{ ref('fct_sales_per_order_line') }}

where order_date is not null 
and order_status = 'Shipped'

group by
sales_order_id
)

select
    -- Extract month and year from order date
    date_trunc('month', order_date) as month_start_date,
    to_char(order_date, 'YYYY') as sales_year,
    to_char(order_date, 'MM') as sales_month,

    -- Aggregated metrics
    count(distinct sales_order_id) as total_orders,
    sum(order_total_usd - (total_tax_usd + total_freight_usd)) as total_sales_usd,
    sum(total_quantity_sold) as total_quantity_sold,
    sum(total_tax_usd) as total_tax_usd,
    sum(total_freight_usd) as total_freight_usd

from sales_per_order

group by
    date_trunc('month', order_date),
    to_char(order_date, 'YYYY'),
    to_char(order_date, 'MM')
order by month_start_date
