{{
    config(
        materialized = 'table',
        alias        = 'customer_360_mart'
    )
}}

/*
    CUSTOMER_360_MART — full refresh materialized table
    ADR003: materialized mart over live view for BI consumer performance
            and data freshness visibility.

    Refresh cadence : hourly
    Freshness SLA   : data no older than 65 minutes at any query time
    Fallback        : ANALYTICS.CUSTOMER_360 view remains live

    Scheduler (not managed by dbt — infrastructure boundary):
      Windows Task Scheduler:
        Action  : dbt run --select customer_360_mart --profiles-dir .
        Trigger : Daily, repeat every 1 hour indefinitely
        Start in: G:\Projects\DE-Intelligence\dbt
      cron (OI005 — future platform migration):
        0 * * * * cd /path/to/dbt && dbt run --select customer_360_mart --profiles-dir .

    Incremental strategy: blocked until OI009 delivers LOADED_AT columns
    on RAW_DATA source tables. Full refresh is the only correct approach
    without ingestion watermarks — see ADR003 and OI009.
*/

select
    /*
     * All 39 fields from ANALYTICS.CUSTOMER_360 (v3).
     * Logic is owned by the view — this model materializes its output.
     * See 02_customer_360_view_v3.sql for CTE details and business rule annotations.
     */
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    company,
    industry,
    city,
    state,
    country,
    signup_date,
    account_status,
    annual_revenue_usd,
    sales_rep,
    customer_tenure_days,

    total_orders,
    delivered_orders,
    cancelled_orders,
    total_order_value_usd,
    avg_order_value_usd,
    first_order_date,
    last_order_date,

    most_recent_order_date,
    most_recent_product,
    most_recent_order_value_usd,

    total_tickets,
    open_tickets,
    critical_tickets,
    has_open_critical_ticket,
    avg_satisfaction_score,
    avg_resolution_time_hrs,
    first_ticket_date,

    most_recent_ticket_date,
    most_recent_ticket_category,
    most_recent_ticket_status,

    at_risk_flag,
    risk_reason,
    low_satisfaction_flag,
    high_value_flag,               -- BR011: concentration risk (>15% portfolio)

    -- Mart metadata: populated at refresh time, used for freshness SLA monitoring
    current_timestamp as refreshed_at

from {{ source('analytics', 'customer_360') }}
