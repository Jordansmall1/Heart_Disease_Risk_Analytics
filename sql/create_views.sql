-- Heart Disease Risk Analytics (PostgreSQL)
-- This script creates a table from heart.csv and builds views used by Power BI.
-- Dataset columns (from heart.csv): age, sex, cp, trestbps, chol, fbs, restecg, thalach, exang, oldpeak, slope, ca, thal, target
-- target: 1 = heart disease, 0 = no heart disease

-- 1) Create table
CREATE TABLE public.heart_patient_data (
  age        INT,
  sex        INT,
  cp         INT,
  trestbps   INT,
  chol       INT,
  fbs        INT,
  restecg    INT,
  thalach    INT,
  exang      INT,
  oldpeak    NUMERIC,
  slope      INT,
  ca         INT,
  thal       INT,
  target     INT
);

-- 2) Load data (run this from psql where the file path is accessible to the server/client)
-- \copy public.heart_patient_data FROM 'data/heart.csv' WITH (FORMAT csv, HEADER true);

-- Helper CTE used across views
-- Sex: 1=Male, 0=Female
-- CP (chest pain): 0=Typical Angina, 1=Atypical Angina, 2=Non-anginal Pain, 3=Asymptomatic
-- Chol risk buckets (mg/dL): Normal <200, Borderline 200-239, High >=240

-- 3) KPI view
CREATE VIEW public.v_overall_kpi AS
SELECT
  COUNT(*)::int                                AS total_patients,
  ROUND(AVG(target)::numeric, 3)               AS disease_rate,
  ROUND(AVG(age)::numeric, 2)                  AS avg_age,
  ROUND(AVG(chol)::numeric, 2)                 AS avg_chol
FROM public.heart_patient_data;

-- 4) Disease rate by age group
CREATE VIEW public.v_age_risk AS
WITH base AS (
  SELECT
    CASE
      WHEN age < 40 THEN 'Under 40'
      WHEN age BETWEEN 40 AND 49 THEN '40s'
      WHEN age BETWEEN 50 AND 59 THEN '50s'
      WHEN age BETWEEN 60 AND 69 THEN '60s'
      ELSE '70+'
    END AS age_group,
    target
  FROM public.heart_patient_data
)
SELECT
  age_group,
  COUNT(*)::int                         AS patients,
  ROUND(AVG(target)::numeric, 3)        AS disease_rate
FROM base
GROUP BY age_group
ORDER BY
  CASE age_group
    WHEN 'Under 40' THEN 1
    WHEN '40s' THEN 2
    WHEN '50s' THEN 3
    WHEN '60s' THEN 4
    ELSE 5
  END;

-- 5) Disease rate by gender
CREATE VIEW public.v_gender_risk AS
WITH base AS (
  SELECT
    CASE WHEN sex = 1 THEN 'Male' ELSE 'Female' END AS gender,
    target
  FROM public.heart_patient_data
)
SELECT
  gender,
  COUNT(*)::int                         AS patients,
  ROUND(AVG(target)::numeric, 3)        AS disease_rate
FROM base
GROUP BY gender
ORDER BY gender;

-- 6) Chest pain distribution + disease rate
CREATE VIEW public.v_cp_risk AS
WITH base AS (
  SELECT
    CASE cp
      WHEN 0 THEN 'Typical Angina'
      WHEN 1 THEN 'Atypical Angina'
      WHEN 2 THEN 'Non-anginal Pain'
      WHEN 3 THEN 'Asymptomatic'
      ELSE 'Unknown'
    END AS chest_pain_type,
    target
  FROM public.heart_patient_data
)
SELECT
  chest_pain_type,
  COUNT(*)::int                         AS patients,
  ROUND(AVG(target)::numeric, 3)        AS disease_rate
FROM base
GROUP BY chest_pain_type
ORDER BY patients DESC;

-- 7) Cholesterol risk buckets (distribution)
CREATE VIEW public.v_chol_risk AS
WITH base AS (
  SELECT
    CASE
      WHEN chol >= 240 THEN 'High (240+)'
      WHEN chol BETWEEN 200 AND 239 THEN 'Borderline (200–239)'
      ELSE 'Normal (<200)'
    END AS chol_risk
  FROM public.heart_patient_data
)
SELECT
  chol_risk,
  COUNT(*)::int AS patients
FROM base
GROUP BY chol_risk
ORDER BY patients DESC;
