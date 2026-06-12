-- BR008: AVG_ORDER_VALUE_USD must be rounded to exactly 2 decimal places.
-- Unrounded averages (e.g. 1234.5678) create inconsistent display in BI tools
-- and signal that the ROUND(..., 2) in the view was removed or bypassed.
-- Fails for each customer where value != round(value, 2).

select customer_id, avg_order_value_usd
from {{ source('analytics', 'customer_360') }}
where avg_order_value_usd is not null
  and avg_order_value_usd != round(avg_order_value_usd, 2)
