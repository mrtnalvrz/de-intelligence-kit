-- BR003 / A001: C013 (BankWest) and C012 (ManufaCT) are confirmed at-risk.
-- Validated in Demo 1: C013 via open critical ticket TKT-5007 (23% of portfolio),
-- C012 via AVG_SATISFACTION_SCORE = 2.0.
-- This test pins the known-good state — any regression in the at-risk logic
-- that drops either customer from the flagged set will be caught here.
-- Fails if either customer is not AT_RISK_FLAG = TRUE.

select customer_id, company, at_risk_flag, risk_reason
from {{ source('analytics', 'customer_360') }}
where customer_id in ('C013', 'C012')
  and at_risk_flag = false
