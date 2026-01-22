# Heart Disease Risk Analytics (PostgreSQL → Power BI)

A compact end‑to‑end analytics project that takes a heart disease dataset (`heart.csv`), loads it into **PostgreSQL**, builds reusable **SQL views**, and visualizes key risk insights in **Power BI**.

Data from [https://www.kaggle.com/datasets/johnsmith88/heart-disease-dataset/data](https://www.kaggle.com/datasets/johnsmith88/heart-disease-dataset/data)
 
  - ## Data clean and aduit
  - checked the 1,025 records for duplicates and null values

![Dashboard](images/dashboard.png) 

  - ## SQL Example – Cholesterol Risk

```sql
SELECT
    CASE
        WHEN chol >= 240 THEN 'High (240+)'
        WHEN chol BETWEEN 200 AND 239 THEN 'Borderline (200–239)'
        ELSE 'Normal (<200)'
    END AS chol_risk
FROM public.heart_patient_data;
```
  - ## SQL Example – Gender Risk

```sql
CREATE VIEW public.v_gender_risk AS
SELECT
  CASE WHEN sex = 1 THEN 'Male' ELSE 'Female' END AS gender,
  COUNT(*)    AS patients,
  AVG(target) AS disease_rate
FROM public.heart_patient_data
GROUP BY gender;
```
---

## Key SQL logic 

- **Disease rate** is computed as:
  - `AVG(target)` since `target` is 0/1
- **Gender labels**:
  - `sex = 1 → Male`, `sex = 0 → Female`
- **Age groups**:
  - Under 40, 40s, 50s, 60s, 70+
- **Chest pain mapping** (`cp`):
  - 0 Typical Angina
  - 1 Atypical Angina
  - 2 Non-anginal Pain
  - 3 Asymptomatic
- **Cholesterol risk buckets** (mg/dL):
  - Normal < 200
  - Borderline 200–239
  - High ≥ 240
 
## 📊 Dataset Overview

This project analyzes **1,025 patient records** from the UCI Heart Disease dataset to identify key risk factors and predictors of cardiovascular disease.

### Data Dictionary

The dataset contains **14 clinical attributes** per patient:

| Column | Feature | Description | Values/Units |
|--------|---------|-------------|--------------|
| `age` | Age | Patient age in years | Numeric |
| `sex` | Sex | Biological sex | 0 = Female, 1 = Male |
| `cp` | Chest Pain Type | Type of chest pain experienced | 0 = Typical Angina<br>1 = Atypical Angina<br>2 = Non-anginal Pain<br>3 = Asymptomatic |
| `trestbps` | Resting Blood Pressure | Blood pressure at rest | mm Hg |
| `chol` | Serum Cholesterol | Cholesterol level | mg/dl |
| `fbs` | Fasting Blood Sugar | Fasting blood sugar > 120 mg/dl | 0 = False, 1 = True |
| `restecg` | Resting ECG Results | Electrocardiographic results at rest | 0 = Normal<br>1 = ST-T Wave Abnormality<br>2 = Left Ventricular Hypertrophy |
| `thalach` | Max Heart Rate | Maximum heart rate achieved | bpm |
| `exang` | Exercise Induced Angina | Angina induced by exercise | 0 = No, 1 = Yes |
| `oldpeak` | ST Depression | ST depression induced by exercise relative to rest | Numeric |
| `slope` | ST Slope | Slope of peak exercise ST segment | 0 = Upsloping<br>1 = Flat<br>2 = Downsloping |
| `ca` | Major Vessels | Number of major vessels colored by fluoroscopy | 0-3 |
| `thal` | Thalassemia | Blood disorder status | 0 = Normal<br>1 = Fixed Defect<br>2 = Reversible Defect |
| `target` | **Target Variable** | **Heart disease diagnosis** | **0 = No Disease, 1 = Disease** |

### Key Statistics

- **Total Patients:** 1,025
- **Disease Prevalence:** 51.3%
- **Male Patients:** 713 (69.6%)
- **Female Patients:** 312 (30.4%)
- **Average Age:** 54.4 years
- **Average Cholesterol:** 246 mg/dl
## Project goals

- Practice a realistic **BI workflow**: raw CSV → relational database → SQL views → Power BI report
- Build a clean set of **business-ready metrics** (disease rate, risk breakdowns, distributions)

---

## What’s in the dashboard

**Top KPIs**
- Overall disease rate
- Total patients
- Average age
- Average cholesterol

**Risk & distribution views**
- Disease rate by **age group**
- Disease rate by **gender**
- Patient distribution by **chest pain type**
- Cholesterol risk bucket distribution (Normal / Borderline / High)

---

## Data

- Source file: [`data/heart.csv`](data/heart.csv)  
- Target variable: `target` (1 = heart disease, 0 = no heart disease)

Columns included in the CSV:
`age, sex, cp, trestbps, chol, fbs, restecg, thalach, exang, oldpeak, slope, ca, thal, target`

---

## Methodology (PostgreSQL → Power BI)

### 1) Load CSV into PostgreSQL
Create a database (example: `heart_analytics`) and run the SQL script:

- [`sql/create_views.sql`](sql/create_views.sql)

That script:
1. Creates `public.heart_patient_data`
2. Loads the CSV (you run the `\copy` line)
3. Builds views used by Power BI:
   - `v_overall_kpi`
   - `v_age_risk`
   - `v_gender_risk`
   - `v_cp_risk`
   - `v_chol_risk`

### 2) Connect Power BI to Postgres
In **Power BI Desktop**:
- **Get Data → PostgreSQL database** (ODBC)
- Import the SQL **views** above
- Build visuals directly on the views (keeps Power BI modeling simple and clean)

---
## Repo structure

```
.
├── data/
│   └── heart.csv
├── images/
│   ├── dashboard.png
│   └── icons/
│       ├── icon_heart.png
│       ├── icon_people.png
│       ├── icon_clock.png
│       ├── icon_postgresql.png
│       └── icon_powerbi.png
├── reports/
│   └── heart_analytics.pdf
└── sql/
    └── create_views.sql
```

---

