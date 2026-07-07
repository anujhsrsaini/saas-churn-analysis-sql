# Milestone 5 – Synthesis: Which Investigation to Escalate?

**Author:** Anuj Saini  
**Date:** July 7, 2026

---

## The CFO's Question

> "I have one product team and one customer success team. Which finding should I escalate first?"

This is not a question about which analysis is more interesting — it is a question about where limited organizational capacity should be pointed first. To answer it rigorously, I evaluated both investigations against three concrete criteria: **size of effect**, **ease of action**, and **organizational fit**.

---

## The Two Investigations

| Investigation | Core Finding |
|---|---|
| **M3 – Cohort Retention** | Retention is strong overall (rarely below 80% even at 12 months), but a consistent 10–15% churn spike hits every cohort at **Month 3–4**. |
| **M4 – Behavioral Predictors** | Churned customers are **+67% more likely** to have filed urgent/critical support tickets. Retained customers show **+62% more collaboration events** and **+58% more data-export events**. |

---

## Evaluation

### 1. Size of Effect

M4 wins. The behavioral predictor signals are large and specific. A +67% prevalence differential in urgent support tickets is not noise — it is a structural pattern that, if corrected, could realistically reduce churn by 5–7 percentage points. M3's month-3 cliff is real but diffuse: it tells us *when* churn happens, not *why*. Without knowing the mechanism, the effect is hard to attack directly.

### 2. Ease of Action

M4 wins. The M4 finding translates into three concrete actions that require no product release cycle:

- Tighten SLAs on urgent/critical ticket categories
- Implement automated alerts when ticket volume spikes for a customer
- Add proactive success-manager outreach at the first sign of escalating tickets

Addressing the M3 cliff requires a product redesign of the month-3 experience — a multi-quarter initiative with uncertain ROI.

### 3. Organizational Fit

M4 wins. The behavioral predictor findings map directly onto the **customer success team's existing mandate**. They already own ticket triage, customer health scoring, and outreach cadences. Acting on M4 requires no new team, no new process, and no product sprint. M3's implications sit squarely in the product team's backlog, where they will compete with feature work and roadmap priorities.

---

## Recommendation

**Escalate the Behavioral Predictors investigation (M4) to the customer success team first.**

On all three criteria — effect size, actionability, and fit — M4 is the stronger choice. It produces an immediate, measurable intervention: a team that today routes urgent tickets reactively can, within two weeks, deploy proactive outreach to at-risk accounts.

### Immediate Actions (Customer Success Team)
1. **Ticket Hygiene** – Audit the top 5 root causes of urgent tickets; build resolution playbooks.
2. **Proactive Escalation** – Flag any account with >2 urgent tickets in a 30-day window; trigger a success-manager check-in.
3. **Feature Nudging** – Add collaboration and export features to the onboarding flow and month-2 check-in emails.

### Follow-On (Product Team, Q3)
Once support-related churn is stabilised, run a dedicated **Month-3 engagement experiment** using the cohort retention insight: a targeted in-app campaign at day 60–75 designed to deepen product usage before the cliff hits.

---

## Why This Recommendation Matters for the Portfolio

Most analysts would present both findings equally and let the stakeholder decide. That is not analysis — that is delegation. A mature analyst runs multiple lenses, compares them on explicit criteria, and makes a call. The M4 finding wins on every criterion that matters to a resource-constrained organisation. That is the answer.
