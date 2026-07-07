-- ==========================================
-- SaaS Churn & Retention Analysis
-- Milestone 3: Cohort Retention (SQL)
-- Author: Anuj Saini
-- ==========================================

-- -----------------------------------------------------------------------------
-- This query builds the cohort retention grid for paid subscribers.
--
-- RATIONALE & DEFINITIONS:
-- 1. Cohort Assignment: Companies are grouped into cohorts based on their signup month 
--    (from saas.legacy_companies.signup_date). We filter to only include cohorts 
--    of companies that have an active paid subscription (excluding free and trial) 
--    in their signup month (Month 0).
-- 2. Anytime Active Definition: A company is active in month offset K if they have 
--    at least one paid, non-trial subscription active at ANY time during the target 
--    month (start_date <= target_month_end AND (end_date IS NULL OR end_date >= target_month_start)).
--    This matches user behavior and ensures Month 0 retention is exactly 100%.
-- 3. Output Grid: Rows represent cohort signup months, columns represent the 
--    number of active companies and retention percentages for offsets 0 to 6, and 12.
-- -----------------------------------------------------------------------------
WITH company_cohorts AS (
    -- Group companies into cohorts by signup month
    -- We filter for companies that were active paid subscribers in Month 0
    SELECT 
        c.id AS company_id,
        TO_CHAR(c.signup_date, 'YYYY-MM') AS cohort_month,
        c.signup_date
    FROM saas.legacy_companies c
    WHERE EXISTS (
        SELECT 1 
        FROM saas.legacy_subscriptions s
        WHERE s.company_id = c.id
          AND s.plan != 'free'
          AND s.status != 'trial'
          -- Active during their signup month (Month 0)
          AND s.start_date <= (DATE_TRUNC('month', c.signup_date) + INTERVAL '1 month' - INTERVAL '1 day')::date
          AND (s.end_date IS NULL OR s.end_date >= DATE_TRUNC('month', c.signup_date)::date)
    )
),
cohort_sizes AS (
    -- Calculate cohort size (total paying customers signed up in each month)
    SELECT 
        cohort_month,
        COUNT(*) AS cohort_size
    FROM company_cohorts
    GROUP BY cohort_month
),
offsets AS (
    -- Generate month offsets from 0 to 18
    SELECT s.month_offset
    FROM GENERATE_SERIES(0, 18) AS s(month_offset)
),
cohort_offset_grid AS (
    -- Build the grid of all cohorts and month offsets
    -- Filter out target months in the future relative to the latest data date (April 2026)
    SELECT 
        cs.cohort_month,
        cs.cohort_size,
        o.month_offset,
        (TO_DATE(cs.cohort_month, 'YYYY-MM') + (o.month_offset || ' month')::interval)::date AS target_month_start,
        (TO_DATE(cs.cohort_month, 'YYYY-MM') + ((o.month_offset + 1) || ' month')::interval - INTERVAL '1 day')::date AS target_month_end
    FROM cohort_sizes cs
    CROSS JOIN offsets o
    WHERE (TO_DATE(cs.cohort_month, 'YYYY-MM') + (o.month_offset || ' month')::interval)::date <= '2026-04-01'::date
),
company_activity AS (
    -- Evaluate if each cohort company had a paid active subscription during the target month
    SELECT 
        g.cohort_month,
        g.cohort_size,
        g.month_offset,
        c.company_id,
        CASE WHEN EXISTS (
            SELECT 1 
            FROM saas.legacy_subscriptions s
            WHERE s.company_id = c.company_id
              AND s.plan != 'free'
              AND s.status != 'trial'
              AND s.start_date <= g.target_month_end
              AND (s.end_date IS NULL OR s.end_date >= g.target_month_start)
        ) THEN 1 ELSE 0 END AS is_active
    FROM cohort_offset_grid g
    JOIN company_cohorts c ON c.cohort_month = g.cohort_month
),
retention_counts AS (
    -- Sum active companies by cohort and offset
    SELECT 
        cohort_month,
        cohort_size,
        month_offset,
        SUM(is_active) AS active_companies
    FROM company_activity
    GROUP BY cohort_month, cohort_size, month_offset
)
-- Pivot results into tabular format for offsets 0-6 and 12
SELECT 
    cohort_month,
    cohort_size,
    
    -- Month 0
    COALESCE(SUM(CASE WHEN month_offset = 0 THEN active_companies ELSE NULL END), 0) AS m0_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 0 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m0_pct,
    
    -- Month 1
    COALESCE(SUM(CASE WHEN month_offset = 1 THEN active_companies ELSE NULL END), 0) AS m1_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 1 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m1_pct,
    
    -- Month 2
    COALESCE(SUM(CASE WHEN month_offset = 2 THEN active_companies ELSE NULL END), 0) AS m2_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 2 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m2_pct,
    
    -- Month 3
    COALESCE(SUM(CASE WHEN month_offset = 3 THEN active_companies ELSE NULL END), 0) AS m3_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 3 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m3_pct,
    
    -- Month 4
    COALESCE(SUM(CASE WHEN month_offset = 4 THEN active_companies ELSE NULL END), 0) AS m4_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 4 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m4_pct,
    
    -- Month 5
    COALESCE(SUM(CASE WHEN month_offset = 5 THEN active_companies ELSE NULL END), 0) AS m5_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 5 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m5_pct,
    
    -- Month 6
    COALESCE(SUM(CASE WHEN month_offset = 6 THEN active_companies ELSE NULL END), 0) AS m6_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 6 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m6_pct,
    
    -- Month 12
    COALESCE(SUM(CASE WHEN month_offset = 12 THEN active_companies ELSE NULL END), 0) AS m12_active,
    ROUND((COALESCE(SUM(CASE WHEN month_offset = 12 THEN active_companies ELSE NULL END), 0)::numeric / cohort_size) * 100, 1) AS m12_pct
FROM retention_counts
GROUP BY cohort_month, cohort_size
ORDER BY cohort_month;
