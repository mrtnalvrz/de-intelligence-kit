-- BR003 / A001 condition (b): OPEN_TICKETS > 2 must set AT_RISK_FLAG = TRUE.
-- A customer with more than 2 unresolved tickets is a support health signal
-- regardless of ticket severity or satisfaction score.
-- Fails for each customer with more than 2 open tickets that is not flagged at-risk.

select customer_id, company, open_tickets, at_risk_flag
from {{ source('analytics', 'customer_360') }}
where open_tickets > 2
  and at_risk_flag = false
