# 💳 Credit Card Fraud Detection
Credit Card Fraud Dataset — End-to-End Data Analytics & Machine Learning Project

---

## 📌 Overview
This project is a full-stack fraud detection case study built on the Kaggle Credit Card Fraud dataset. It covers the entire pipeline — from SQL-based exploratory data analysis and rule-based fraud flagging in BigQuery, through machine learning classification in Python, to an interactive risk monitoring dashboard in Power BI.

The dataset contains **284,807 transactions** over a 48-hour window with a fraud rate of just **0.17%** (492 fraud cases) — making class imbalance the central analytical challenge of the project.

---

## 🗂️ Project Structure

```
credit-card-fraud-detection/
│
├── bigquery/
│   ├── proxy_account_id.sql        # Proxy account ID engineering from V1
│   ├── kpi_summary.sql             # Core fraud KPIs
│   ├── rule1_high_amount.sql       # Flag transactions above 3 SD
│   ├── rule2_velocity.sql          # Flag >5 transactions in 1 hour
│   └── hourly_fraud_analysis.sql   # Fraud volume by hour
│
├── notebooks/
│   └── fraud_detection_model.ipynb # ML pipeline — preprocessing, SMOTE, RF, XGBoost
│
└── dashboard/
    └── fraud_detection.pbix        # Power BI dashboard (3 pages)
```

---

## 📊 Dataset

| Field | Detail |
|---|---|
| Source | Kaggle — Credit Card Fraud Detection (ULB) |
| Transactions | 284,807 |
| Features | V1–V28 (PCA-transformed), Amount, Time |
| Target | Class (0 = Legitimate, 1 = Fraud) |
| Fraud Rate | 0.17% — severely imbalanced |
| Time Window | 48 hours |

> V1–V28 are PCA components applied to protect cardholder confidentiality. Original feature names were not disclosed with the dataset.

---

## 🔍 Key Findings

| Finding | Detail |
|---|---|
| Avg fraud amount | $0.21 vs $88.14 for legitimate transactions |
| Fraud pattern | Small, rapid transactions — not large amounts |
| Peak fraud hours | Concentrated in specific hour buckets across the 48-hour window |
| Strongest features | V11, V14, V17 — highest importance in Random Forest |
| Rule-based signal | Velocity rule (rapid transactions) outperforms amount-based flagging |

---

## 🛠️ BigQuery Pipeline

**Proxy Account ID**
Since the dataset has no account identifier, one was derived from V1:
```sql
CAST(ABS(ROUND(V1 * 10)) AS INT64) AS account_id
```

**Rule 1 — High Amount Flag**
Flags transactions more than 3 standard deviations above the account's average amount. Accounts with fewer than 3 transactions are excluded to avoid unreliable estimates.

**Rule 2 — Velocity Flag**
Uses a window function to count transactions within a rolling 1-hour window per account:
```sql
COUNT(*) OVER (
  PARTITION BY account_id
  ORDER BY Time
  RANGE BETWEEN CURRENT ROW AND 3600 FOLLOWING
) AS txn_in_1hr_window
```

---

## 🤖 Machine Learning Pipeline

**Models**

| Metric | Random Forest | XGBoost |
|---|---|---|
| Precision (Fraud) | 0.80 | 0.56 |
| Recall (Fraud) | 0.89 | 0.89 |
| F1 Score (Fraud) | 0.84 | 0.68 |

Random Forest was selected as the primary model based on superior precision and F1 score.

**Handling Class Imbalance**
SMOTE (Synthetic Minority Oversampling Technique) was applied exclusively on the training set to generate synthetic fraud examples — the test set was kept in its original imbalanced state to ensure honest evaluation metrics.

**Feature Set**
```
X = V1–V28, Amount, hour_of_day (30 features)
y = Class
```

---

## 📈 Dashboard — Power BI

**Page 1 — Executive Overview**
KPI cards: total transactions, fraud count, fraud rate, total fraud amount, average transaction amounts

**Page 2 — Fraud Pattern Analysis**
- Donut chart: fraud vs legitimate distribution (why accuracy is a false indicator)
- Line + bar combo: transaction frequency and fraud volume by hour
- Bar chart: accounts with highest z-scores

**Page 3 — Transaction Risk Table**
- Top 100 highest risk transactions ranked by predicted fraud probability
- Risk classification: Low / Medium / High
- Slicers: hour of day, amount range, risk level

---

## ⚙️ Setup & Usage

**Prerequisites**
- Python 3.10+
- Google BigQuery account
- Google Colab
- Power BI Service (browser)

**Python dependencies**
```bash
pip install pandas numpy scikit-learn imbalanced-learn xgboost matplotlib seaborn
```

**Run order**
1. Run BigQuery SQL scripts in `/bigquery` in order
2. Export aggregated tables as CSV
3. Open `fraud_detection_model.ipynb` in Google Colab
4. Upload `creditcard.csv` from Kaggle and run all cells
5. Import exported CSVs into Power BI Service

---

## Author
**Prashant Singh Chauhan**
Data Analyst | BI Developer | Toronto, ON
