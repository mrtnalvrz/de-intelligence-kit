-- BR004: C007 (Logistix) has no closed tickets and must have AVG_SATISFACTION_SCORE = NULL.
-- This customer was explicitly validated as the null_satisfaction case in Demo 1.
-- If this field is ever non-NULL for C007, an open ticket score was incorrectly
-- included in the average — a direct violation of BR006 as well.
-- Fails if C007 has any non-NULL satisfaction score.

select customer_id, company, avg_satisfaction_score
from {{ source('analytics', 'customer_360') }}
where customer_id = 'C007'
  and avg_satisfaction_score is not null
