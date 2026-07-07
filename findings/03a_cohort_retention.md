# SaaS Churn & Retention Analysis
## Milestone 3: Cohort Retention Analysis (Heatmap Findings)

**Author:** Anuj Saini  
**Date:** July 7, 2026  

---

## 1. The One Most Important Observation

> [!IMPORTANT]
> **Paid subscriber retention is exceptionally strong and stable, rarely dropping below 80% even after 12 months. The business does not suffer from an early "onboarding cliff" (Month 1 retention is a near-perfect 100% across almost all cohorts); instead, the minor churn that does occur is concentrated around Month 3 and Month 4.**
> 
> This indicates high product-market fit and effective initial onboarding. Churn is a delayed event rather than an immediate rejection of the product, suggesting that retention efforts should focus on the 90-day mark rather than the first 30 days.

---

## 2. Retention Curve Shape & Steepest Drops

Analysis of the cohort heatmap reveals a highly resilient retention shape:

*   **Month 1 Perfect Score**: Out of the 19 monthly cohorts analyzed, **18 cohorts achieved exactly 100.0% retention in Month 1**. The only exception is the December 2025 cohort, which dropped to 90.0%. This indicates that customers are successfully activated and find enough value to stay past their first billing cycle.
*   **The Month 3/4 Cliff**: Unlike typical SaaS platforms where the steepest drop occurs in Month 1, our primary drop occurs between **Month 3 and Month 4**. 
    *   For the **March 2025 cohort**, retention drops from 93.3% in Month 2 to **80.0% in Month 3** and **73.3% in Month 4**.
    *   For the **May 2025 cohort**, retention holds at 100.0% through Month 2, then drops to **87.5% in Month 3** and **75.0% in Month 4**.
    *   For the **December 2025 cohort**, retention drops to **80.0% in Month 4** and **70.0% in Month 5**.
*   **Long-Term Flattening**: Once cohorts survive past Month 4, the curve flattens completely. For example, the December 2024 cohort holds at **88.2% retention from Month 4 through Month 16** (with a brief dip/resurrection profile). This confirms that customers who pass the 90-day threshold achieve high stickiness.

---

## 3. Comparison: Old vs. Recent Cohorts

There is no evidence of systemic decay in cohort quality. In fact, cohort retention remains remarkably stable:

*   **Older Cohorts (Q4 2024 – Q1 2025)**: December 2024 retained **88.2%** at Month 6 and **88.2%** at Month 12. January 2025 retained **100.0%** at Month 6 and **92.9%** at Month 12.
*   **Mid Cohorts (Q2 2025 – Q3 2025)**: June 2025 retained **87.5%** at Month 6. August 2025 retained **83.3%** at Month 6. September 2025 retained **100.0%** at Month 6.
*   **Recent Cohorts (Q4 2025 – Q1 2026)**: November 2025 stands at **90.9%** at Month 4. January 2026 is at **85.7%** at Month 3. February 2026 is at **91.7%** at Month 2.
*   **Conclusion**: Newer cohorts are performing on par with or slightly better than historical cohorts, indicating that product updates and marketing alignment have successfully maintained a high standard of customer quality.

---

## 4. Anomalies & Resurrection Profiles

*   **The December 2025 Dip**: The `2025-12` cohort is the only cohort in the entire dataset that experienced immediate Month 1 churn (dropping to 90.0%). This anomaly likely correlates with year-end budget closures, holiday slowdowns, or a specific cohort of trial signups that converted under holiday promotions but quickly cancelled.
*   **Customer Resurrection (Cohort 2025-11)**: The November 2025 cohort displays a rare "resurrection" curve, going from **81.8% in Month 2** back up to **90.9% in Month 3**. This occurs when a customer downgrades to a free tier (becoming inactive under the paid definition) and subsequently upgrades back to a paid tier in the next month. This suggests that the downgrade/upgrade path is active and successfully saves churned accounts.
