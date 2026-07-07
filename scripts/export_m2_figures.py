import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import psycopg2
from dotenv import load_dotenv
import os

sns.set_theme(style="whitegrid")
load_dotenv(dotenv_path="/home/anuj/Personal/DataBuoy-Projects-Testing/SaaS-Churn/.env")

host = os.getenv("host")
port = os.getenv("port")
database = os.getenv("database")
username = os.getenv("username")
password = os.getenv("password")

conn = psycopg2.connect(host=host, port=port, database=database, user=username, password=password)

df = pd.read_sql("SELECT * FROM saas.legacy_subscriptions;", conn)
df['start_date'] = pd.to_datetime(df['start_date'])
df['end_date']   = pd.to_datetime(df['end_date'])
df['cancelled_at'] = pd.to_datetime(df['cancelled_at'])
print(f"Loaded {len(df)} rows")

# ── Chart 1: MRR by plan tier ─────────────────────────────────────────────────
active_df = df[(df['status'] == 'active') & (df['plan'] != 'free') & (df['mrr'] > 0)]
mrr_breakdown = active_df.groupby('plan').agg(
    total_mrr=('mrr', 'sum')
).reset_index().sort_values('total_mrr', ascending=False)

fig, ax = plt.subplots(figsize=(8, 5))
palette = sns.color_palette("viridis", len(mrr_breakdown))
bars = ax.bar(mrr_breakdown['plan'], mrr_breakdown['total_mrr'], color=palette, edgecolor='white', linewidth=1.2)
ax.set_title('Current MRR by Plan Tier', fontsize=15, fontweight='bold', pad=14)
ax.set_xlabel('Plan Tier', fontsize=12)
ax.set_ylabel('Total MRR ($)', fontsize=12)
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'${x:,.0f}'))
for bar in bars:
    h = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2, h + mrr_breakdown['total_mrr'].max()*0.01,
            f'${h:,.0f}', ha='center', va='bottom', fontsize=10, fontweight='semibold')
plt.tight_layout()
plt.savefig('/home/anuj/Personal/DataBuoy-Projects-Testing/SaaS-Churn/figures/mrr_by_tier.png', dpi=150, bbox_inches='tight')
plt.close()
print("Saved mrr_by_tier.png")

# ── Chart 2: Monthly churn rate trend ─────────────────────────────────────────
months = pd.date_range(start='2025-05-01', end='2026-04-30', freq='ME')
monthly_metrics = []

for m in months:
    m_start = m - pd.offsets.MonthBegin(1)
    prev_end = m_start - pd.Timedelta(days=1)

    starting_subs = df[
        (df['plan'] != 'free') &
        (df['status'] != 'trial') &
        (df['start_date'] <= prev_end) &
        ((df['end_date'].isnull()) | (df['end_date'] > prev_end))
    ]
    churned_subs = df[
        (df['plan'] != 'free') &
        (df['status'] == 'churned') &
        (df['end_date'] >= m_start) &
        (df['end_date'] <= m)
    ]
    n_start = len(starting_subs)
    sub_churn_rate = (len(churned_subs) / n_start * 100) if n_start > 0 else 0
    mrr_start = starting_subs['mrr'].sum()
    mrr_churn_rate = (churned_subs['mrr'].sum() / mrr_start * 100) if mrr_start > 0 else 0

    monthly_metrics.append({
        'Month': m.strftime('%b %Y'),
        'SubChurnRatePct': round(sub_churn_rate, 2),
        'MRRChurnRatePct': round(mrr_churn_rate, 2),
    })

monthly_df = pd.DataFrame(monthly_metrics)

fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(monthly_df['Month'], monthly_df['SubChurnRatePct'], marker='o',
        label='Subscription Churn Rate (%)', color='#5B8FF9', linewidth=2.5)
ax.plot(monthly_df['Month'], monthly_df['MRRChurnRatePct'], marker='s',
        label='Gross MRR Churn Rate (%)', color='#F6903D', linewidth=2.5, linestyle='--')
ax.fill_between(range(len(monthly_df)), monthly_df['SubChurnRatePct'], alpha=0.08, color='#5B8FF9')
ax.set_xticks(range(len(monthly_df)))
ax.set_xticklabels(monthly_df['Month'], rotation=45, ha='right', fontsize=9)
ax.set_title('Monthly Churn Rate Trend (Last 12 Months)', fontsize=15, fontweight='bold', pad=14)
ax.set_xlabel('')
ax.set_ylabel('Churn Rate (%)', fontsize=12)
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{x:.1f}%'))
ax.legend(fontsize=11)
ax.grid(True, linestyle=':', alpha=0.5)
plt.tight_layout()
plt.savefig('/home/anuj/Personal/DataBuoy-Projects-Testing/SaaS-Churn/figures/monthly_churn_trend.png', dpi=150, bbox_inches='tight')
plt.close()
print("Saved monthly_churn_trend.png")

conn.close()
print("All figures exported successfully.")
