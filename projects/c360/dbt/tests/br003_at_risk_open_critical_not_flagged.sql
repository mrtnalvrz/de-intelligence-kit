-- BR003 / A001 condition (a): HAS_OPEN_CRITICAL_TICKET = TRUE must set AT_RISK_FLAG = TRUE.
-- An open critical ticket is the highest-severity at-risk trigger.
-- Failing this means a customer like C013 BankWest ($457K, security ticket open since
-- 2023-03-20) would not appear in at-risk reporting.
-- Fails for each customer with an open critical ticket that is not flagged at-risk.

select customer_id, company, has_open_critical_ticket, at_risk_flag
from {{ source('analytics', 'customer_360') }}
where has_open_critical_ticket = true
  and at_risk_flag = false
