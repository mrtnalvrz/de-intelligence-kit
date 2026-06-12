-- BR006 (revised 2026-06-10): AVG_SATISFACTION_SCORE must be computed only on
-- tickets where STATUS = 'resolved'. Satisfaction score reflects completed
-- interactions only. Any non-resolved status (open, escalated, in_progress, or
-- future statuses) has no score yet and must be excluded.
-- Using = 'resolved' (not != 'open') requires deliberate opt-in for new statuses.
-- Recomputes expected average from source and compares to view output.
-- Fails for each customer where view avg != source-computed resolved-only avg.

select
    v.customer_id,
    v.avg_satisfaction_score                         as view_avg,
    src.expected_avg
from {{ source('analytics', 'customer_360') }} v
left join (
    select
        customer_ref,
        round(avg(satisfaction_score), 2) as expected_avg
    from {{ source('raw_data', 'support_tickets') }}
    where status = 'resolved'
      and satisfaction_score is not null
    group by customer_ref
) src on v.customer_id = src.customer_ref
where round(coalesce(v.avg_satisfaction_score, -1)::decimal, 2)
   != round(coalesce(src.expected_avg,         -1)::decimal, 2)
