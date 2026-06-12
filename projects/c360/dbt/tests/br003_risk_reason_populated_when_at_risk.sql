-- BR003 / A001: When AT_RISK_FLAG = TRUE, RISK_REASON must be non-NULL.
-- RISK_REASON names every condition that fired, separated by ' | '.
-- A NULL reason on an at-risk customer means the concatenation logic broke —
-- downstream reports would show flagged customers with no explanation.
-- Fails for each at-risk customer with a NULL RISK_REASON.

select customer_id, company, at_risk_flag, risk_reason
from {{ source('analytics', 'customer_360') }}
where at_risk_flag = true
  and risk_reason is null
