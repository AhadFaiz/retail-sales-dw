-- models/staging/stg_salesorderheader.sql
-- Staging model for sales order headers: standardizes order-level information

select distinct
    salesorderid as sales_order_id,
    revisionnumber as revision_number,
    orderdate as order_date,
    duedate as due_date,
    shipdate as ship_date,
    -- Replace digits with words to denote order status.
    case when
    status = 1 then 'In process'
    when status = 2 then 'Approved'
    when status = 3 then 'Backordered'
    when status = 4 then 'Rejected'
    when status = 5 then 'Shipped'
    when status = 6 then 'Cancelled'
    end as order_status,
    onlineorderflag as online_order_flag,
    salesordernumber as sales_order_number,
    purchaseordernumber as purchase_order_number,
    accountnumber as account_number,
    customerid as customer_id,
    salespersonid as sales_person_id,
    territoryid as territory_id,
    billtoaddressid as bill_to_address_id,
    shiptoaddressid as ship_to_address_id,
    shipmethodid as ship_method_id,
    creditcardid as credit_card_id,
    creditcardapprovalcode as credit_card_approval_code,
    currencyrateid as currency_rate_id,
    subtotal as sub_total_usd,
    taxamt as tax_amount_usd,
    freight as freight_charge_usd,
    totaldue as total_due_usd,
    comment as order_comment,
    modifieddate as modified_date

from {{ ref('salesorderheader_snapshot') }}

where dbt_valid_to is null