# SaaS Churn & Retention Analysis
## Milestone 2: Foundation (Definitions, MRR, & Topline Churn)

**Author:** Anuj Saini  
**Date:** July 7, 2026  

---

## 1. Definitional Framework

To ensure consistency in subsequent cohort and behavioral analyses (Milestones 3 & 4), we establish the following core definitions:

### Active Subscription
A subscription is classified as **active** on a given date $D$ if:
1.  **Time Bounds**: The subscription has started on or before $D$ (`start_date <= D`) and has not yet ended (`end_date IS NULL OR end_date > D`).
2.  **Paid Status**: The subscription is not on the `'free'` plan and is not in a `'trial'` status. Trial subscriptions generate $\$0$ MRR and represent non-paying prospects rather than active, revenue-generating customers. Paused subscriptions are temporarily excluded from active MRR calculation, but kept in active counts unless explicitly cancelled.

### Churned Subscription
A subscription is classified as **churned** in month $M$ if:
1.  **Status**: Its database status is `'churned'`.
2.  **Cancellation Date**: Its `end_date` (representing the date it was cancelled and terminated) falls within month $M$.

> [!NOTE]
> A subscription that ends but is immediately succeeded by another subscription for the same company (e.g., plan migration or downgrade/upgrade) is **not** counted as a customer churn, as the customer remains active on the platform. Churn is evaluated at the customer/company level when they terminate their final active subscription.

---

## 2. Current MRR Breakdown (Today)

As of the latest dataset snapshot (April 2026), the company's **Current Paid MRR is \$80,362.64**, distributed across **279 active paid subscriptions**:

| Plan Tier | Active Subscriptions | Current MRR | Average MRR per Sub | % of Total MRR |
| :--- | :---: | :---: | :---: | :---: |
| **Enterprise** | 81 | \$59,234.90 | \$731.30 | 73.71% |
| **Pro** | 123 | \$18,212.46 | \$148.07 | 22.66% |
| **Starter** | 75 | \$2,915.28 | \$38.87 | 3.63% |
| **Total Paid** | **279** | **\$80,362.64** | **\$288.04** | **100.00%** |

> [!TIP]
> The Enterprise plan accounts for **73.71%** of total MRR despite representing only **29.03%** of the active subscriber base. This highlights the critical importance of retention in the Enterprise segment, where losing a single client has a disproportionate impact on recurring revenue.

---

## 3. Monthly Churn Rate Trend (Last 12 Months)

The table below outlines monthly subscriber and MRR churn rates for paid plans over the last 12 months (May 2025 – April 2026):

| Month | Starting Active Paid Subs | Starting Active Paid MRR | Churned Paid Subs | Churned Paid MRR | Subscription Churn Rate (%) | Gross MRR Churn Rate (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **2025-05** | 79 | \$26,597.66 | 11 | \$4,166.96 | 13.92% | 15.67% |
| **2025-06** | 84 | \$27,822.84 | 9 | \$2,606.23 | 10.71% | 9.37% |
| **2025-07** | 90 | \$29,798.61 | 6 | \$2,664.81 | 6.67% | 8.94% |
| **2025-08** | 107 | \$34,844.14 | 8 | \$2,721.87 | 7.48% | 7.81% |
| **2025-09** | 121 | \$37,857.28 | 9 | \$2,941.23 | 7.44% | 7.77% |
| **2025-10** | 126 | \$38,269.22 | 5 | \$993.76 | 3.97% | 2.60% |
| **2025-11** | 136 | \$42,035.02 | 5 | \$2,879.09 | 3.68% | 6.85% |
| **2025-12** | 160 | \$48,714.66 | 9 | \$2,643.21 | 5.63% | 5.43% |
| **2026-01** | 174 | \$54,861.05 | 7 | \$4,751.13 | 4.02% | 8.66% |
| **2026-02** | 188 | \$55,370.25 | 11 | \$2,637.91 | 5.85% | 4.76% |
| **2026-03** | 214 | \$63,005.42 | 20 | \$7,071.19 | 9.35% | 11.22% |
| **2026-04** | 231 | \$61,919.70 | 20 | \$4,665.31 | 8.66% | 7.53% |

### Trend Articulation
*   **Initial High Churn (Q2 2025)**: Paid subscription churn was elevated in May and June 2025, peaking at **13.92%** (15.67% MRR churn).
*   **Operational Improvement (Q3–Q4 2025)**: Churn declined steadily through the second half of the year, reaching a healthy low of **3.68%** in November 2025. 
*   **Recent Resurgence (Q1 2026)**: In March and April 2026, subscription churn rose back to **9.35%** and **8.66%**, driven by large account terminations. In March, MRR churn peaked at **11.22%** (\$7,071.19 lost), indicating a potential product or competitor issue that warrants immediate investigation.

---

## 4. Paid Churn vs. Free Churn

Free plan subscribers are structurally distinct from paid plan subscribers:
1.  **No Financial Commitment**: Free users do not undergo a procurement or purchasing decision.
2.  **High Volatility**: Free churn rates are erratic due to low user counts (often fluctuating between 0% and 16.67%).
3.  **Zero Revenue Impact**: Free churn has an MRR impact of exactly \$0.

| Month | Starting Free Subs | Churned Free Subs | Free Churn Rate (%) | Starting Paid Subs | Churned Paid Subs | Paid Churn Rate (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **2025-12** | 19 | 1 | 5.26% | 160 | 9 | 5.63% |
| **2026-01** | 22 | 1 | 4.55% | 174 | 7 | 4.02% |
| **2026-02** | 24 | 2 | 8.33% | 188 | 11 | 5.85% |
| **2026-03** | 25 | 3 | 12.00% | 214 | 20 | 9.35% |
| **2026-04** | 31 | 2 | 6.45% | 231 | 20 | 8.66% |

> [!IMPORTANT]
> Including free-plan churn in the headline metrics would dilute and distort the real business health. While free tier health is important for the conversion pipeline, the **Paid Subscription Churn Rate** should remain the headline metric for investors, recruiters, and internal strategic decisions.
