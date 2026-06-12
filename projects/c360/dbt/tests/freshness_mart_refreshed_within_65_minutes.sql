-- Freshness SLA: CUSTOMER_360_MART must have been refreshed within the last 65 minutes.
-- SLA definition: data no older than 65 minutes at any point in time.
-- Rationale: source database refreshes hourly; 5-minute buffer for processing time.
--
-- Note: source-level freshness testing (dbt source freshness) requires LOADED_AT
-- timestamp columns on RAW_DATA tables. That is blocked on OI009. This test
-- covers the mart's own REFRESHED_AT as the operative freshness signal.
--
-- Fails if REFRESHED_AT is NULL or older than 65 minutes from current time.

select
    max(refreshed_at)                                                as last_refreshed_at,
    current_timestamp                                                as checked_at,
    datediff('minute', max(refreshed_at), current_timestamp)        as minutes_since_refresh,
    65                                                               as sla_minutes
from {{ ref('customer_360_mart') }}
having max(refreshed_at) is null
    or datediff('minute', max(refreshed_at), current_timestamp) > 65
