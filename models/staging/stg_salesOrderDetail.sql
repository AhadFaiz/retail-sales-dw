-- models/staging/stg_salesorderdetail.sql
-- Staging model for sales order details: cleans and standardizes line item data
-- No need for snapshot table. Existing records for sales_order_detail_id will not change under any circumstances, so there is no need to track historical changes.


select distinct
    salesorderid as sales_order_id,
    salesorderdetailid as sales_order_detail_id,
    carriertrackingnumber as carrier_tracking_number,
    orderqty as order_qty,
    productid as product_id,
    specialofferid as special_offer_id,
    abs(unitprice) as unit_price_usd,
    unitpricediscount as unit_price_discount_usd,
    linetotal as line_total_usd,
    modifieddate as modified_date

from {{ source('raw_data_source', 'RAW_SALESORDERDETAIL') }}