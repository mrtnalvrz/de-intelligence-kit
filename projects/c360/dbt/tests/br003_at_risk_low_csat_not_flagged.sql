-- BR003 / A001 condition (c): AVG_SATISFACTION_SCORE < 3.0 must set AT_RISK_FLAG = TRUE.
-- A customer with average satisfaction below 3.0 is at risk regardless of
-- whether tickets are open or critical. C012 ManufaCT (CSAT=2.0) is the
-- confirmed case from Demo 1 validation.
-- Fails for each customer with low CSAT that is not flagged at-risk.

select customer_id, company, avg_satisfaction_score, at_risk_flag
from {{ source('analytics', 'customer_360') }}
where avg_satisfaction_score < 3.0
  and at_risk_flag = false
