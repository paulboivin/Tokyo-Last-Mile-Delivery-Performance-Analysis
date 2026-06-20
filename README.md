# Tokai Logistics: Tokyo Last-Mile Delivery Performance Analysis

## Executive Summary

Tokai Logistics, a fictional third-party logistics provider serving 
the Greater Tokyo metropolitan area, processed 50,279 deliveries 
across five hubs in 2024 with an overall failure rate of approximately 
10% and an annual revenue impact of ¥5,985,600 under the 
attempt-weighted cost model. Analysis using SQL, Python, AWS S3, 
and Power BI identified three primary drivers of revenue loss: 
customer absence during evening and night delivery windows, 
weather-related delays concentrated in snow and heavy rain conditions, 
and staffing patterns optimized for peak hours but under-resourced 
for transitional periods. Recommended interventions include 
differential delivery window pricing, pre-delivery confirmation for 
night window deliveries projected to recover between ¥358,405 and 
¥502,481 annually, and expansion of alternative delivery options 
through locker pickup and convenience store partnerships.

---

## Business Problem

Stakeholders at Tokai Logistics requested a 2024 performance 
analysis to identify operational patterns driving delivery failures 
and quantify the revenue impact of those failures. This analysis was 
built to answer five core questions:

1. How does delivery failure and delay rate vary across hubs, 
weather conditions, and prefectures?

2. Are there sustained weekly trends or periods of progressive 
performance degradation across 2024?

3. Does delivery performance correlate with hub volume, or are 
busiest hours under-resourced relative to demand?

4. What is the total revenue impact of delivery failures, and how 
does cost modeling methodology affect that estimate?

5. How does failure rate and re-delivery cost vary by delivery time 
window (morning, afternoon, evening, night)?

---

## Dashboard

![Tokai Logistics Performance Dashboard](dashboard/dashboard_screenshot.png)

---

## Methodology

1. **Data Generation (Python)** — Generated a synthetic dataset 
simulating 50,279 total delivery records across 18 columns for the 
year 2024, calibrated against published Japanese logistics industry 
data including Yamato Holdings delivery windows, Japan Meteorological 
Agency weather frequencies, and Ministry of Land, Infrastructure, 
Transport and Tourism delivery failure statistics.

2. **Cloud Integration (AWS S3, boto3)** — Uploaded the cleaned 
dataset to AWS S3 using Python's boto3 library, implementing cloud 
data integration architecture designed to scale to Amazon Redshift 
in a production environment.

3. **SQL Analysis (SQLite)** — Built a SQLite database with 
appropriate indexing on the deliveries table and wrote five 
analytical queries examining hub delay patterns by weather and 
prefecture, rolling weekly delay trends, busiest hours per hub with 
delay correlation, combined revenue impact with attempt-weighted 
cost modeling, and delivery window performance.

4. **Revenue Recovery Simulation (Python)** — Created a simulation 
modeling the financial impact of pre-delivery confirmation 
interventions on Night window deliveries at 25%, 30%, and 35% 
failure reduction rates, calibrated against published Japanese 
logistics research.

5. **Dashboard (Power BI)** — Built an interactive dashboard 
connected to the SQLite database via ODBC, presenting hub 
performance with dual-axis visualization, monthly delay trends, 
revenue impact breakdown, and weather impact analysis with 
interactive filtering.

---

## Skills

**Python:** Synthetic data generation with realistic logistical hub 
delivery time frames and weather condition effects, AWS S3 integration 
via boto3, revenue recovery simulation modeling

**SQL:** DENSE_RANK, ROW_NUMBER, LAG, PARTITION BY, multi-CTE chained 
queries, CASE WHEN aggregation, attempt-weighted revenue modeling

**Power BI:** Data modeling, DAX measures, interactive slicer, 
dashboard design, dual-axis charting

**AWS:** S3 cloud storage configuration, boto3 programmatic upload, 
IAM credential management

---

## Results

**Hub performance is consistent across the network, with variation 
driven by specific factors rather than hub-level differences.** The 
five Tokai Logistics hubs operate within a narrow performance band 
of 46.77% to 47.20% delay rate, indicating consistent operational 
capability across the network. However, the analysis identified 
specific weather, time-of-day, and seasonal factors that drive 
significant variation in delivery success within that overall 
pattern.

**Delivery time window is the most operationally actionable driver 
of failure.** Failure rates climbed progressively from 8.82% in 
morning windows to 11.87% in night windows, a 35% relative increase. 
The night window generated ¥964,800 in re-delivery costs alone, 37% 
higher than the morning window — consistent with documented Japanese 
consumer absence patterns during evening hours.

**A sustained four-week degradation period aligned with typhoon 
season.** Performance progressively declined from week 32 through 
week 35 (August 5–26), consistent with Japan's typhoon season impact 
on Tokyo metropolitan deliveries. October and December each showed 
elevated monthly average delay (6.32 and 6.37 minutes respectively), 
reflecting holiday peak volume combined with winter weather 
variability. Delay rates tied to snow or heavy rainfall — 
particularly at Chiba and Yokohama Hubs — indicate operational or 
routing issues rather than distance-driven factors.

**Staffing appears optimized for known peaks but under-resourced 
during transitional periods.** Only Chiba Hub showed the expected 
pattern of higher delay rates correlating with higher volume; the 
remaining four hubs showed inverse or flat patterns, with their 
busiest hours performing better than medium-volume hours.

**The standard revenue impact methodology significantly understates 
true cost.** The flat re-delivery cost calculation understates 
actual costs by approximately ¥1,967,200 annually by not accounting 
for multi-attempt failures. The attempt-weighted model captures this 
previously invisible cost component, raising total annual revenue 
impact from ¥4,825,900 to ¥5,985,600.

---

## Business Recommendation

The revenue recovery model projects that implementing pre-delivery 
confirmation for Night window deliveries alone, calibrated against 
the 25–35% failure reduction documented in published Japanese 
logistics research, would prevent an estimated 301 to 422 failed 
deliveries annually and recover between ¥358,405 and ¥502,481 in 
attempt-weighted re-delivery costs. Recommended actions include:

**Implement differential pricing for delivery windows.** Premium 
rates for evening and night slots would encourage customers to opt 
for more reliable morning and afternoon delivery windows, reducing 
exposure to the highest-failure time periods.

**Deploy pre-delivery confirmation for evening and night windows.** 
Requiring customer acknowledgment of presence before dispatch, via 
SMS or mobile app, directly targets the customer-absence pattern 
identified as the primary driver of night-window failures.

**Establish and promote alternative delivery options.** Locker 
pickup (PUDO locations) and convenience store delivery for customers 
selecting evening or night windows address the customer absence 
problem at the root rather than relying on redelivery attempts.

Combining these interventions would extend recovery beyond the night 
window scope and address customer absence patterns across both 
evening and night delivery windows.

---

## Next Steps

**Staffing mismatch investigation.** Determine efficient staffing 
solutions for lower-performing time windows across all hubs, given 
that current staffing appears optimized for known peaks rather than 
actual demand patterns.

**Weather-specific operational protocols.** Develop vehicle 
preparation, route adjustments, and predictive scheduling procedures 
for forecasted adverse weather events, particularly for Chiba and 
Yokohama Hubs given their elevated snow- and rain-related delays.

**Inter-hub coordination opportunities.** Investigate options to 
balance volume distribution during weather events or seasonal peaks, 
allowing better-positioned hubs to absorb overflow from heavily 
impacted hubs.

---

## Repository Structure

```bash
Tokyo-Last-Mile-Delivery-Performance-Analysis/
│
├── README.md                                         — This document
│
├── data/raw/
│   └── tokai_logistics_deliveries.csv                — Synthetic delivery records (50,279 rows, 18 columns)
│
├── python/
│   ├── Tokai_Logistics_Data_Generation.ipynb         — Synthetic data generation notebook
│   └── Tokai_Logistics_Recovery_Simulation.ipynb     — Revenue recovery simulation notebook
│
├── sql/
│   ├── tokai_logistics.db                            — SQLite database (Power BI connects via ODBC)
│   ├── 00_create_schema.sql                          — Schema definition with indexing
│   ├── 01_hub_delay_analysis.sql                     — Hub delay patterns by weather and prefecture
│   ├── 02_rolling_weekly_trend.sql                   — Rolling weekly delay trend
│   ├── 03_busiest_hours_per_hub.sql                  — Busiest hours per hub with delay correlation
│   ├── 04_revenue_impact.sql                         — Combined revenue impact, attempt-weighted modeling
│   └── 05_delivery_window_analysis.sql               — Delivery window performance comparison
│
├── dashboard/
│   ├── Tokai_Logistics_Dashboard.pbix                — Interactive Power BI dashboard
│   └── dashboard_screenshot.png                      — Dashboard screenshot
│
├── aws/
│   └── s3_upload_screenshot.png                      — boto3 S3 upload confirmation screenshot
│
└── insights/
    └── Tokai_Logistics_Insight_Narrative.docx        — Full business narrative and recommendations
```

---

## How to Run

Requires Python with pandas, numpy, and boto3 installed, a data management tool with SQLite for the database and queries, Power BI Desktop for the dashboard, and an AWS account with IAM credentials configured via the AWS CLI for the S3 upload script.
