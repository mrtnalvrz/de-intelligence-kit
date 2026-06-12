-- ============================================================
-- ANALYTICS.CUSTOMER_360 — VIEW v2
-- Project: PROJ-C360
-- Owner: Martin Alvarez
-- Version: v2 — 2026-06-07
-- BR006 revision — 2026-06-10: STATUS != 'open' → STATUS = 'resolved'
--
-- Changes from v1:
--   BR007: order_details CTE now filters WHERE ORDER_STATUS = 'delivered'
--          C007 Logistix MOST_RECENT_PRODUCT/DATE/VALUE → NULL (correct)
--   BR008: ROUND(...,2) applied to AVG_ORDER_VALUE_USD and
--          AVG_SATISFACTION_SCORE — clean decimal presentation
--
-- Business rules implemented: BR001-BR008, A001
-- Architecture decisions: ADR001, ADR002
-- ============================================================

CREATE OR REPLACE VIEW ANALYTICS.CUSTOMER_360 AS

WITH

-- ============================================================
-- CTE 1: customer_base
-- Spine of the Customer 360 view.
-- Every CRM customer appears exactly once.
-- BR001: CRM drives row count — 15 rows guaranteed.
-- ============================================================
customer_base AS (
    SELECT
        CUSTOMER_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,                   -- [PII]
        PHONE,                   -- [PII]
        COMPANY,
        INDUSTRY,
        CITY,                    -- NULL for international customers — correct
        STATE,                   -- NULL for international customers — correct
        COUNTRY,
        SIGNUP_DATE,
        ACCOUNT_STATUS,
        ANNUAL_REVENUE_USD,
        SALES_REP,
        CAST(CURRENT_DATE - SIGNUP_DATE AS INTEGER) AS CUSTOMER_TENURE_DAYS
        -- derived: days since signup as of query execution date
    FROM RAW_DATA.CRM_CUSTOMERS
),

-- ============================================================
-- CTE 2: order_metrics
-- Aggregated order signals per customer.
-- BR002: CUST_ID maps to CUSTOMER_ID — values identical, names differ.
-- BR003: count fields default to 0 via COALESCE in final SELECT.
-- BR005: value aggregates on delivered orders only.
-- BR008: AVG_ORDER_VALUE_USD rounded to 2 decimal places.
-- ============================================================
order_metrics AS (
    SELECT
        CUST_ID,

        COUNT(ORDER_ID)                                                AS TOTAL_ORDERS,
        -- BR003: all orders regardless of status

        COUNT(CASE WHEN ORDER_STATUS = 'delivered' THEN ORDER_ID END)  AS DELIVERED_ORDERS,
        -- BR005: delivered orders only

        COUNT(CASE WHEN ORDER_STATUS = 'cancelled' THEN ORDER_ID END)  AS CANCELLED_ORDERS,
        -- BR005: cancelled tracked separately, zero revenue contribution

        SUM(CASE WHEN ORDER_STATUS = 'delivered'
                 THEN TOTAL_AMOUNT_USD END)                            AS TOTAL_ORDER_VALUE_USD,
        -- BR005: delivered only — NULL if no delivered orders (not zero)

        ROUND(AVG(CASE WHEN ORDER_STATUS = 'delivered'
                       THEN TOTAL_AMOUNT_USD END), 2)                  AS AVG_ORDER_VALUE_USD,
        -- BR005 + BR008: delivered only, rounded to 2dp

        MIN(ORDER_DATE)                                                AS FIRST_ORDER_DATE,
        MAX(ORDER_DATE)                                                AS LAST_ORDER_DATE
        -- BR003: date range across all orders regardless of status

    FROM RAW_DATA.ERP_ORDERS
    GROUP BY CUST_ID
),

-- ============================================================
-- CTE 3: order_details (CORRECTED v2 — BR007)
-- Most recent DELIVERED order per customer via window function.
-- BR007: WHERE ORDER_STATUS = 'delivered' applied to inner subquery.
--        Cancelled orders excluded — reflects fulfillment not intent.
--        C007 Logistix returns NULL for all three fields — correct.
-- ============================================================
order_details AS (
    SELECT
        CUST_ID,
        ORDER_DATE        AS MOST_RECENT_ORDER_DATE,
        PRODUCT_NAME      AS MOST_RECENT_PRODUCT,
        TOTAL_AMOUNT_USD  AS MOST_RECENT_ORDER_VALUE_USD
    FROM (
        SELECT
            CUST_ID,
            ORDER_DATE,
            PRODUCT_NAME,
            TOTAL_AMOUNT_USD,
            ROW_NUMBER() OVER (
                PARTITION BY CUST_ID
                ORDER BY ORDER_DATE DESC, ORDER_ID DESC
                -- ORDER_ID DESC as tiebreaker for same-date orders
            ) AS rn
        FROM RAW_DATA.ERP_ORDERS
        WHERE ORDER_STATUS = 'delivered'  -- BR007: delivered only
    ) ranked_orders
    WHERE rn = 1
),

-- ============================================================
-- CTE 4: support_metrics
-- Aggregated support signals per customer.
-- BR002: CUSTOMER_REF maps to CUSTOMER_ID.
-- BR004: count fields default to 0 via COALESCE in final SELECT.
-- BR006: AVG_SATISFACTION_SCORE on closed tickets only.
-- BR008: AVG_SATISFACTION_SCORE rounded to 2 decimal places.
-- ============================================================
support_metrics AS (
    SELECT
        CUSTOMER_REF,

        COUNT(TICKET_ID)                                               AS TOTAL_TICKETS,
        -- BR004: all tickets regardless of status

        COUNT(CASE WHEN STATUS = 'open' THEN TICKET_ID END)            AS OPEN_TICKETS,
        -- BR005: STATUS = 'open' only — not in_progress, not escalated

        COUNT(CASE WHEN PRIORITY = 'critical' THEN TICKET_ID END)      AS CRITICAL_TICKETS,
        -- PRIORITY is a field in source — not inferred

        CAST(
            MAX(CASE WHEN STATUS = 'open' AND PRIORITY = 'critical'
                     THEN 1 ELSE 0 END)
        AS BOOLEAN)                                                    AS HAS_OPEN_CRITICAL_TICKET,
        -- A001 condition (a): TRUE if any open + critical ticket exists

        ROUND(AVG(CASE WHEN STATUS = 'resolved'
                       THEN SATISFACTION_SCORE END), 2)                AS AVG_SATISFACTION_SCORE,
        -- BR006 (revised 2026-06-10): resolved tickets only — STATUS = 'resolved'
        -- BR004: NULL if no closed tickets — not zero
        -- BR008: rounded to 2dp
        -- A001 condition (c): threshold < 3.0

        AVG(RESOLUTION_TIME_HRS)                                       AS AVG_RESOLUTION_TIME_HRS,
        -- ADR002: support health metric across all tickets

        MIN(CREATED_AT)                                                AS FIRST_TICKET_DATE

    FROM RAW_DATA.SUPPORT_TICKETS
    GROUP BY CUSTOMER_REF
),

-- ============================================================
-- CTE 5: support_details
-- Most recent ticket per customer via window function.
-- BR002: CUSTOMER_REF maps to CUSTOMER_ID.
-- ============================================================
support_details AS (
    SELECT
        CUSTOMER_REF,
        CREATED_AT  AS MOST_RECENT_TICKET_DATE,
        CATEGORY    AS MOST_RECENT_TICKET_CATEGORY,
        STATUS      AS MOST_RECENT_TICKET_STATUS
    FROM (
        SELECT
            CUSTOMER_REF,
            CREATED_AT,
            CATEGORY,
            STATUS,
            ROW_NUMBER() OVER (
                PARTITION BY CUSTOMER_REF
                ORDER BY CREATED_AT DESC, TICKET_ID DESC
                -- TICKET_ID DESC as tiebreaker for same-timestamp tickets
            ) AS rn
        FROM RAW_DATA.SUPPORT_TICKETS
    ) ranked_tickets
    WHERE rn = 1
),

-- ============================================================
-- CTE 6: risk_indicators
-- Derived at-risk logic per A001.
-- All three conditions evaluated independently then combined.
-- Multiple conditions concatenated with ' | ' separator.
-- ============================================================
risk_indicators AS (
    SELECT
        CUSTOMER_REF,

        -- A001: TRUE if ANY ONE of three conditions fires
        CAST(
            CASE WHEN HAS_OPEN_CRITICAL_TICKET = TRUE THEN 1  -- A001 (a)
                 WHEN OPEN_TICKETS > 2                THEN 1  -- A001 (b)
                 WHEN AVG_SATISFACTION_SCORE < 3.0    THEN 1  -- A001 (c)
                 ELSE 0
            END
        AS BOOLEAN)                                            AS AT_RISK_FLAG,

        -- A001: all fired conditions concatenated with ' | '
        -- NULL if no condition fires
        NULLIF(
            TRIM(
                BOTH ' | ' FROM
                CONCAT(
                    CASE WHEN HAS_OPEN_CRITICAL_TICKET = TRUE
                         THEN 'Open critical ticket' ELSE '' END,
                    CASE WHEN HAS_OPEN_CRITICAL_TICKET = TRUE
                              AND (OPEN_TICKETS > 2 OR AVG_SATISFACTION_SCORE < 3.0)
                         THEN ' | ' ELSE '' END,
                    CASE WHEN OPEN_TICKETS > 2
                         THEN 'High open ticket volume' ELSE '' END,
                    CASE WHEN OPEN_TICKETS > 2
                              AND AVG_SATISFACTION_SCORE < 3.0
                         THEN ' | ' ELSE '' END,
                    CASE WHEN AVG_SATISFACTION_SCORE < 3.0
                         THEN 'Low satisfaction score' ELSE '' END
                )
            ),
            ''
        )                                                      AS RISK_REASON,

        CAST(
            CASE WHEN AVG_SATISFACTION_SCORE < 3.0 THEN 1 ELSE 0 END
        AS BOOLEAN)                                            AS LOW_SATISFACTION_FLAG
        -- A001 condition (c) as standalone flag

    FROM support_metrics
)

-- ============================================================
-- FINAL SELECT
-- BR001: customer_base drives row count — 15 rows guaranteed.
-- BR002: all JOIN conditions explicit about mismatched key names.
-- BR003/BR004: COALESCE applies zero defaults for counts.
-- ============================================================
SELECT

    -- GROUP 1: Customer Identity (15 fields)
    cb.CUSTOMER_ID,
    cb.FIRST_NAME,
    cb.LAST_NAME,
    cb.EMAIL,
    cb.PHONE,
    cb.COMPANY,
    cb.INDUSTRY,
    cb.CITY,
    cb.STATE,
    cb.COUNTRY,
    cb.SIGNUP_DATE,
    cb.ACCOUNT_STATUS,
    cb.ANNUAL_REVENUE_USD,
    cb.SALES_REP,
    cb.CUSTOMER_TENURE_DAYS,

    -- GROUP 2: Order Metrics (7 fields)
    COALESCE(om.TOTAL_ORDERS,         0)     AS TOTAL_ORDERS,         -- BR003
    COALESCE(om.DELIVERED_ORDERS,     0)     AS DELIVERED_ORDERS,
    COALESCE(om.CANCELLED_ORDERS,     0)     AS CANCELLED_ORDERS,
    om.TOTAL_ORDER_VALUE_USD,                -- NULL if no orders — BR003
    om.AVG_ORDER_VALUE_USD,                  -- NULL if no orders — BR003, BR008
    om.FIRST_ORDER_DATE,                     -- NULL if no orders
    om.LAST_ORDER_DATE,                      -- NULL if no orders

    -- GROUP 3: Order Details (3 fields)
    od.MOST_RECENT_ORDER_DATE,               -- NULL if no delivered orders — BR007
    od.MOST_RECENT_PRODUCT,                  -- NULL if no delivered orders — BR007
    od.MOST_RECENT_ORDER_VALUE_USD,          -- NULL if no delivered orders — BR007

    -- GROUP 4: Support Metrics (7 fields)
    COALESCE(sm.TOTAL_TICKETS,        0)     AS TOTAL_TICKETS,        -- BR004
    COALESCE(sm.OPEN_TICKETS,         0)     AS OPEN_TICKETS,
    COALESCE(sm.CRITICAL_TICKETS,     0)     AS CRITICAL_TICKETS,
    COALESCE(sm.HAS_OPEN_CRITICAL_TICKET,
             FALSE)                          AS HAS_OPEN_CRITICAL_TICKET,
    sm.AVG_SATISFACTION_SCORE,               -- NULL if no tickets — BR004, BR008
    sm.AVG_RESOLUTION_TIME_HRS,              -- NULL if no tickets — ADR002
    sm.FIRST_TICKET_DATE,                    -- NULL if no tickets

    -- GROUP 5: Support Details (3 fields)
    sd.MOST_RECENT_TICKET_DATE,              -- NULL if no tickets
    sd.MOST_RECENT_TICKET_CATEGORY,          -- NULL if no tickets
    sd.MOST_RECENT_TICKET_STATUS,            -- NULL if no tickets

    -- GROUP 6: Risk Indicators (3 fields)
    COALESCE(ri.AT_RISK_FLAG,         FALSE) AS AT_RISK_FLAG,         -- A001
    ri.RISK_REASON,                          -- NULL if not at risk
    COALESCE(ri.LOW_SATISFACTION_FLAG,FALSE) AS LOW_SATISFACTION_FLAG -- A001 (c)

FROM customer_base cb

LEFT JOIN order_metrics   om ON cb.CUSTOMER_ID = om.CUST_ID
    -- BR002: CUSTOMER_ID (CRM) = CUST_ID (ERP)

LEFT JOIN order_details   od ON cb.CUSTOMER_ID = od.CUST_ID
    -- BR002: same mapping

LEFT JOIN support_metrics sm ON cb.CUSTOMER_ID = sm.CUSTOMER_REF
    -- BR002: CUSTOMER_ID (CRM) = CUSTOMER_REF (Support)

LEFT JOIN support_details sd ON cb.CUSTOMER_ID = sd.CUSTOMER_REF
    -- BR002: same mapping

LEFT JOIN risk_indicators ri ON cb.CUSTOMER_ID = ri.CUSTOMER_REF
    -- BR002: risk_indicators inherits CUSTOMER_REF from support_metrics

ORDER BY cb.CUSTOMER_ID;

-- ============================================================
-- VERIFICATION — run after CREATE OR REPLACE VIEW
-- ============================================================

-- V1: BR007 check — C007 order detail fields should be NULL
SELECT
    CUSTOMER_ID,
    COMPANY,
    TOTAL_ORDERS,
    DELIVERED_ORDERS,
    CANCELLED_ORDERS,
    MOST_RECENT_PRODUCT,
    MOST_RECENT_ORDER_DATE,
    MOST_RECENT_ORDER_VALUE_USD
FROM ANALYTICS.CUSTOMER_360
WHERE CUSTOMER_ID = 'C007'
   OR CANCELLED_ORDERS > 0;

-- V2: BR008 check — AVG fields should show clean 2dp
SELECT
    CUSTOMER_ID,
    COMPANY,
    AVG_ORDER_VALUE_USD,
    AVG_SATISFACTION_SCORE
FROM ANALYTICS.CUSTOMER_360
WHERE AVG_ORDER_VALUE_USD IS NOT NULL
   OR AVG_SATISFACTION_SCORE IS NOT NULL
ORDER BY CUSTOMER_ID;

-- V3: Full sanity check
SELECT
    COUNT(*)                                              AS total_rows,
    SUM(CASE WHEN AT_RISK_FLAG = TRUE  THEN 1 ELSE 0 END) AS at_risk_count,
    SUM(TOTAL_ORDER_VALUE_USD)                            AS portfolio_value,
    SUM(CASE WHEN AVG_SATISFACTION_SCORE IS NULL
             THEN 1 ELSE 0 END)                           AS null_satisfaction_count
FROM ANALYTICS.CUSTOMER_360;
-- Expected: 15 / 2 / 1986450.00 / 1
