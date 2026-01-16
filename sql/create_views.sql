-- Heart Disease Risk Analytics (PostgreSQL)

CREATE TABLE public.heart_patient_data (
  age INT,
  sex INT,
  cp INT,
  trestbps INT,
  chol INT,
  fbs INT,
  restecg INT,
  thalach INT,
  exang INT,
  oldpeak NUMERIC,
  slope INT,
  ca INT,
  thal INT,
  target INT
);

-- \copy public.heart_patient_data FROM 'data/heart.csv' WITH (FORMAT csv, HEADER true);

-- Overall KPIs
CREATE VIEW public.v_overall_kpi AS
SELECT
  COUNT(*)        AS total_patients,
  AVG(target)     AS disease_rate,
  AVG(age)        AS avg_age,
  AVG(chol)       AS avg_chol
FROM public.heart_patient_data;

-- Age risk
CREATE VIEW public.v_age_risk AS
SELECT
  CASE
    WHEN age < 40 THEN 'Under 40'
    WHEN age < 50 THEN '40s'
    WHEN age < 60 THEN '50s'
    WHEN age < 70 THEN '60s'
    ELSE '70+'
  END AS age_group,
  COUNT(*)    AS patients,
  AVG(target) AS disease_rate
FROM public.heart_patient_data
GROUP BY age_group;

-- Gender risk
CREATE VIEW public.v_gender_risk AS
SELECT
  CASE WHEN sex = 1 THEN 'Male' ELSE 'Female' END AS gender,
  COUNT(*)    AS patients,
  AVG(target) AS disease_rate
FROM public.heart_patient_data
GROUP BY gender;

-- Chest pain risk
CREATE VIEW public.v_cp_risk AS
SELECT
  CASE cp
    WHEN 0 THEN 'Typical Angina'
    WHEN 1 THEN 'Atypical Angina'
    WHEN 2 THEN 'Non-anginal Pain'
    WHEN 3 THEN 'Asymptomatic'
  END AS chest_pain_type,
  COUNT(*)    AS patients,
  AVG(target) AS disease_rate
FROM public.heart_patient_data
GROUP BY chest_pain_type;

-- Cholesterol distribution
CREATE VIEW public.v_chol_risk AS
SELECT
  CASE
    WHEN chol >= 240 THEN 'High'
    WHEN chol >= 200 THEN 'Borderline'
    ELSE 'Normal'
  END AS chol_risk,
  COUNT(*) AS patients
FROM public.heart_patient_data
GROUP BY chol_risk;
