-- BR003 / A001: C013 (BankWest) and C012 (ManufaCT) are confirmed at-risk.
-- C013: fires A001(a) only — open critical ticket TKT-5007 (23% of portfolio).
--   RISK_REASON must equal exactly 'Open critical ticket' — confirms the
--   single-condition path produces a clean, unconcatenated string with no
--   stray ' | ' artifacts.
-- C012: fires A001(a) AND A001(c) — open critical ticket TKT-5026 (billing,
--   opened 2026-06-16) plus AVG_SATISFACTION_SCORE = 2.0 (TKT-5021, resolved).
--   RISK_REASON must equal exactly 'Open critical ticket | Low satisfaction score'.
--   C012 is the multi-condition regression anchor for BR003 concatenation logic
--   (added Demo 4 / OI008, approved Martin Alvarez 2026-06-16).
--
-- Test fails (returns rows) if:
--   (a) either customer has AT_RISK_FLAG = FALSE, OR
--   (b) RISK_REASON does not match the expected exact string for that customer.

select customer_id, company, at_risk_flag, risk_reason
from {{ source('analytics', 'customer_360') }}
where customer_id in ('C013', 'C012')
  and (
    at_risk_flag = false
    or (customer_id = 'C012' and risk_reason != 'Open critical ticket | Low satisfaction score')
    or (customer_id = 'C013' and risk_reason != 'Open critical ticket')
  )
