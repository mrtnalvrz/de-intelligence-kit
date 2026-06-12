-- BR007: MOST_RECENT_ORDER_DATE must correspond to a delivered order in ERP.
-- Cancelled orders must not surface in the order detail fields — a cancelled order
-- is intent, not fulfillment. C007 (Logistix) has only a cancelled order and must
-- show NULL for all three order detail fields (MOST_RECENT_ORDER_DATE, PRODUCT, VALUE).
-- Fails for each customer whose most-recent order date has no matching delivered order.

select v.customer_id, v.company, v.most_recent_order_date
from {{ source('analytics', 'customer_360') }} v
where v.most_recent_order_date is not null
  and not exists (
    select 1
    from {{ source('raw_data', 'erp_orders') }} e
    where e.cust_id    = v.customer_id
      and e.order_date = v.most_recent_order_date
      and e.order_status = 'delivered'
  )
