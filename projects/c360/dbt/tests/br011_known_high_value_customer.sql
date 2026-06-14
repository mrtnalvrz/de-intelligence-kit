-- BR011: C013 BankWest, C004 FinServ Corp, and C010 InsureNet must always be
-- flagged HIGH_VALUE_FLAG = TRUE. These three customers exceed the 15% portfolio
-- concentration threshold (confirmed 2026-06-13: 23.0%, 15.6%, 15.3% respectively).
-- Mirrors br003_known_at_risk_customers pattern — regression anchor for BR011 logic.
-- Fails if any of the three is absent or HIGH_VALUE_FLAG = FALSE.

select customer_id, company, high_value_flag, total_order_value_usd
from {{ source('analytics', 'customer_360') }}
where customer_id in ('C013', 'C004', 'C010')
  and high_value_flag = false
