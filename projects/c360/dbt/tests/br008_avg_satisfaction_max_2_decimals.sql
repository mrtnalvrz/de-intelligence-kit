-- BR008: AVG_SATISFACTION_SCORE must be rounded to exactly 2 decimal places.
-- Unrounded scores (e.g. 3.666...) are harder to threshold against at-risk
-- logic and create display inconsistency across reporting surfaces.
-- Fails for each customer where score != round(score, 2).

select customer_id, avg_satisfaction_score
from {{ source('analytics', 'customer_360') }}
where avg_satisfaction_score is not null
  and avg_satisfaction_score != round(avg_satisfaction_score, 2)
