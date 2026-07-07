-- ==========================================
-- SaaS Churn & Retention Analysis
-- Milestone 2: Foundation (MRR & Churn)
-- Author: Anuj Saini
-- ==========================================

-- -----------------------------------------------------------------------------
-- Query 1: Current MRR Breakdown by Plan Tier
--
-- DEFINITION: 
-- - 'Active Subscription' is defined as a subscription that has started (start_date <= current_date)
--   and has not ended (end_date IS NULL or end_date > current_date), is NOT on a 'free' plan,
--   and is NOT in a 'trial' status (mrr > 0).
-- - Current MRR is the sum of MRR for these active paid subscriptions as of the latest database state.
-- -----------------------------------------------------------------------------
SELECT 
    plan AS plan_tier,
    COUNT(*) AS active_subscriptions_count,
    SUM(mrr) AS current_mrr,
    ROUND(AVG(mrr), 2) AS average_mrr_per_sub
FROM saas.legacy_subscriptions
WHERE status = 'active'
  AND plan != 'free'
  AND mrr > 0
GROUP BY plan
ORDER BY current_mrr DESC;


-- -----------------------------------------------------------------------------
-- Query 2: Monthly Paid Churn Rate (Last 12 Months)
--
-- DEFINITIONS:
-- - Active Paid Subscriptions (Start of Month): Subscriptions active on the last day of the previous month.
-- - Churned Paid Subscriptions (During Month): Subscriptions with status = 'churned' and end_date within the month.
-- - Subscription Churn Rate = Churned Paid Subs / Starting Active Paid Subs
-- - Gross MRR Churn Rate = Churned Paid MRR / Starting Active Paid MRR
-- -----------------------------------------------------------------------------
WITH RECURSIVE months AS (
    SELECT '2025-05-01'::date AS month_start
    UNION ALL
    SELECT (month_start + INTERVAL '1 month')::date
    FROM months
    WHERE month_start < '2026-04-01'::date
),
month_boundaries AS (
    SELECT 
        month_start,
        (month_start + INTERVAL '1 month' - INTERVAL '1 day')::date AS month_end,
        (month_start - INTERVAL '1 day')::date AS prev_month_end
    FROM months
),
monthly_paid_metrics AS (
    SELECT
        mb.month_start,
        mb.month_end,
        -- Active paid subscriptions at start of month (active at end of previous month)
        (
            SELECT COUNT(*)
            FROM saas.legacy_subscriptions s
            WHERE s.plan != 'free'
              AND s.status != 'trial'
              AND s.start_date <= mb.prev_month_end
              AND (s.end_date IS NULL OR s.end_date > mb.prev_month_end)
        ) AS starting_active_subs,
        (
            SELECT COALESCE(SUM(s.mrr), 0)
            FROM saas.legacy_subscriptions s
            WHERE s.plan != 'free'
              AND s.status != 'trial'
              AND s.start_date <= mb.prev_month_end
              AND (s.end_date IS NULL OR s.end_date > mb.prev_month_end)
        ) AS starting_active_mrr,
        -- Churned paid subscriptions during the month
        (
            SELECT COUNT(*)
            FROM saas.legacy_subscriptions s
            WHERE s.plan != 'free'
              AND s.status = 'churned'
              AND s.end_date >= mb.month_start AND s.end_date <= mb.month_end
        ) AS churned_subs,
        (
            SELECT COALESCE(SUM(s.mrr), 0)
            FROM saas.legacy_subscriptions s
            WHERE s.plan != 'free'
              AND s.status = 'churned'
              AND s.end_date >= mb.month_start AND s.end_date <= mb.month_end
        ) AS churned_mrr
    FROM month_boundaries mb
)
SELECT
    TO_CHAR(month_start, 'YYYY-MM') AS month,
    starting_active_subs,
    starting_active_mrr,
    churned_subs,
    churned_mrr,
    ROUND((churned_subs::numeric / NULLIF(starting_active_subs, 0)) * 100, 2) AS sub_churn_rate_pct,
    ROUND((churned_mrr::numeric / NULLIF(starting_active_mrr, 0)) * 100, 2) AS mrr_churn_rate_pct
FROM monthly_paid_metrics
ORDER BY month;


-- -----------------------------------------------------------------------------
-- Query 3: Monthly Free Churn Rate (Last 12 Months)
--
-- DEFINITION:
-- - Active Free Subscriptions (Start of Month): Free subscriptions active on the last day of the previous month.
-- - Churned Free Subscriptions (During Month): Free subscriptions with status = 'churned' and end_date within the month.
-- - Free Subscription Churn Rate = Churned Free Subs / Starting Active Free Subs
-- -----------------------------------------------------------------------------
WITH RECURSIVE months AS (
    SELECT '2025-05-01'::date AS month_start
    UNION ALL
    SELECT (month_start + INTERVAL '1 month')::date
    FROM months
    WHERE month_start < '2026-04-01'::date
),
month_boundaries AS (
    SELECT 
        month_start,
        (month_start + INTERVAL '1 month' - INTERVAL '1 day')::date AS month_end,
        (month_start - INTERVAL '1 day')::date AS prev_month_end
    FROM months
),
monthly_free_metrics AS (
    SELECT
        mb.month_start,
        -- Active free subscriptions at start of month
        (
            SELECT COUNT(*)
            FROM saas.legacy_subscriptions s
            WHERE s.plan = 'free'
              AND s.start_date <= mb.prev_month_end
              AND (s.end_date IS NULL OR s.end_date > mb.prev_month_end)
        ) AS starting_free_subs,
        -- Churned free subscriptions during the month
        (
            SELECT COUNT(*)
            FROM saas.legacy_subscriptions s
            WHERE s.plan = 'free'
              AND s.status = 'churned'
              AND s.end_date >= mb.month_start AND s.end_date <= mb.month_end
        ) AS churned_free_subs
    FROM month_boundaries mb
)
SELECT
    TO_CHAR(month_start, 'YYYY-MM') AS month,
    starting_free_subs,
    churned_free_subs,
    ROUND((churned_free_subs::numeric / NULLIF(starting_free_subs, 0)) * 100, 2) AS free_churn_rate_pct
FROM monthly_free_metrics
ORDER BY month;
