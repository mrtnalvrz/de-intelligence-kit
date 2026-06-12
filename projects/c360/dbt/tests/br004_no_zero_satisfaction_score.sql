-- BR004: AVG_SATISFACTION_SCORE = 0 is semantically invalid and must never appear.
-- Zero is not a valid CSAT rating in this dataset — it would be misread as
-- a recorded score of zero rather than the absence of any rating.
-- Customers with no closed tickets must have NULL, not 0.
-- Fails for each customer where satisfaction score is exactly zero.

select customer_id, company, avg_satisfaction_score
from {{ source('analytics', 'customer_360') }}
where avg_satisfaction_score = 0
