-- Heart Disease Risk Analytics (PostgreSQL)
-- Creates base table and analytic views for Power BI
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

-- 2) Load data (run in psql)
-- \copy public.heart_patient_data FROM 'data/heart.csv' WITH (FORMAT csv, HEADER true);

-- --------------------------------------------------
-- 3) Overall KPI view
-- --------------------------------------------------
CREATE VIEW public.v_overall_kpi AS
SELECT
  COUNT(*)::int                  AS total_patients,
  ROUND(AVG(target), 3)          AS disease_rate,
  ROUND(AVG(age), 2)             AS avg_age,
  ROUND(AVG(chol), 2)            AS avg_chol
FROM public.heart_patient_data;

-- --------------------------------------------------
-- 4) Disease rate by age group
-- --------------------------------------------------
CREATE VIEW public.v_age_risk AS
SELECT
  CASE
    WHEN age < 40 THEN 'Under 40'
    WHEN age BETWEEN 40 AND 49 THEN '40s'
    WHEN age BETWEEN 50 AND 59 THEN '50s'
    WHEN age BETWEEN 60 AND 69 THEN '60s'
    ELSE '70+'
  END AS age_group,
  COUNT(*)::int          AS patients,
  ROUND(AVG(target), 3)  AS disease_rate
FROM public.heart_patient_data
GROUP BY age_group
ORDER BY
  CASE age_group
    WHEN 'Under 40' THEN 1
    WHEN '40s' THEN 2
    WHEN '50s' THEN 3
    WHEN '60s' THEN 4
    ELSE 5
  END;

-- --------------------------------------------------
-- 5) Disease rate by gender
-- --------------------------------------------------
CREATE VIEW public.v_gender_risk AS
SELECT
  CASE WHEN sex = 1 THEN 'Male' ELSE 'Female' END AS gender,
  COUNT(*)::int          AS patients,
  ROUND(AVG(target), 3)  AS disease_rate
FROM public.heart_patient_data
GROUP BY gender
ORDER BY gender;

-- --------------------------------------------------
-- 6) Chest pain type vs disease rate
-- --------------------------------------------------
CREATE VIEW public.v_cp_risk AS
SELECT
  CASE cp
    WHEN 0 THEN 'Typical Angina'
    WHEN 1 THEN 'Atypical Angina'
    WHEN 2 THEN 'Non-anginal Pain'
    WHEN 3 THEN 'Asymptomatic'
    ELSE 'Unknown'
  END AS chest_pain_type,
  COUNT(*)::int          AS patients,
  ROUND(AVG(target), 3)  AS disease_rate
FROM public.heart_patient_data
GROUP BY chest_pain_type
ORDER BY patients DESC;

-- --------------------------------------------------
-- 7) Cholesterol risk distribution
-- --------------------------------------------------
CREATE VIEW public.v_chol_risk AS
SELECT
  CASE
    WHEN chol >= 240 THEN 'High (240+)'
    WHEN chol BETWEEN 200 AND 239 THEN 'Borderline (200–239)'
    ELSE 'Normal (<200)'
  END AS chol_risk,
  COUNT(*)::int AS patients
FROM public.heart_patient_data
GROUP BY chol_risk
ORDER BY patients DESC;
