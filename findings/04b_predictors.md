# SaaS Churn & Retention Analysis
## Milestone 4: Churn Predictor Analysis (Behavioral Findings)

**Author:** Anuj Saini  
**Date:** July 7, 2026  

---

## 1. The One Most Important Predictor

> [!IMPORTANT]
> **High/Critical Priority Support Tickets are the single most powerful predictor of customer churn. Churned customers open an average of 1.27 critical/high priority support tickets during their lifecycle, compared to only 0.76 tickets for retained customers—a massive 67.1% higher ticket load for churned accounts.**
> 
> This indicates that customer churn in our dataset is primarily driven by unresolved customer pain points, system blocks, or technical friction rather than quiet disinterest. A customer filing multiple urgent tickets is a high-risk churn indicator.

---

## 2. Top 3 Behavioral Churn Signals

Our descriptive comparison of customer behavior prior to cancellation (for churned accounts) vs. normal usage (for retained accounts) surfaced three highly distinct signals:

### Signal 1: Urgent Support Ticket Load (High/Critical)
*   **Retained Mean**: 0.76 tickets per customer  
*   **Churned Mean**: 1.27 tickets per customer  
*   **Quantified Gap**: Churned customers experience a **+67.1% increase** in urgent ticket filings.
*   **Operational Context**: While overall ticket counts are also higher for churned customers (1.83 vs. 1.39, a 31% difference), the gap widens significantly when looking only at critical/high-severity issues. This suggests that technical blockers, outages, or product failures are directly pushing accounts to cancel.

### Signal 2: Collaboration Activity (Comment Creation)
*   **Retained Mean**: 2.66 comments per customer  
*   **Churned Mean**: 1.65 comments per customer  
*   **Quantified Gap**: Retained customers create **+61.9% more comments** than churned customers.
*   **Operational Context**: Comment creation is a key indicator of collaboration and team integration. Customers who actively collaborate on the platform build high organizational stickiness, making it significantly harder to cancel the service. Conversely, isolated users who do not comment are highly susceptible to churn.

### Signal 3: Value Extraction (Data Exports)
*   **Retained Mean**: 6.34 exports per customer  
*   **Churned Mean**: 4.00 exports per customer  
*   **Quantified Gap**: Retained customers execute **+58.4% more data exports** than churned customers.
*   **Operational Context**: Executing a data export represents extracting direct utility and reporting value from the product. Customers who regularly export report data are deriving continuous business value, whereas lower export activity indicates the product has failed to integrate into their business processes.

---

## 3. Active Engagement Signals (Last 30 Days)

We also observed a decline in login frequency leading up to cancellation:
*   **Logins in Last 30 Days**: Retained customers log in **0.70 times** on average in a 30-day window, compared to only **0.52 times** for churned customers in their final 30 days (a **33.9% increase** for retained users). This classic "engagement decay" represents a quiet withdrawal before the final cancellation.

---

## 4. Caveats & Future Analysis (How to Strengthen)

*   **Lead-Time Analysis**: To make this predictive model truly actionable, we should evaluate features at fixed intervals *before* the cancellation (e.g., 30 or 60 days prior). Analyzing activity up to the exact cancellation day introduces "cancellation-day artifacting," where a customer's final login to hit the cancel button artificially spikes their recency and login count.
*   **Causality vs. Correlation**: High support ticket volume correlates with churn, but it does not tell us whether it was the ticket *resolution time* or the *original bug* that caused the churn. Tracking ticket resolution times (SLAs) between churned and retained customers would clarify this relationship.
*   **Sample Size Constraint**: The analysis is based on 48 churned companies out of 200 total accounts. While the gaps are statistically meaningful, gathering a larger sample size of cancellations would allow us to establish precise operational thresholds (e.g., "an account with >2 critical tickets and <2 logins has a 90% probability of churn").
