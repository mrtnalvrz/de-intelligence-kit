-- BR005: TOTAL_ORDER_VALUE_USD must equal the sum of delivered orders only.
-- Cancelled orders carry no revenue. Including them would overstate customer value
-- and distort portfolio concentration calculations.
-- Recomputes expected total from source and compares to view output.
-- Fails for each customer where view total != source-computed delivered-only total.

select
    v.customer_id,
    v.total_order_value_usd                         as view_total,
    coalesce(src.delivered_total, 0)                as expected_total
from {{ source('analytics', 'customer_360') }} v
left join (
    select
        cust_id,
        sum(total_amount_usd) as delivered_total
    from {{ source('raw_data', 'erp_orders') }}
    where order_status = 'delivered'
    group by cust_id
) src on v.customer_id = src.cust_id
where round(coalesce(v.total_order_value_usd, 0)::decimal, 2)
   != round(coalesce(src.delivered_total,    0)::decimal, 2)
