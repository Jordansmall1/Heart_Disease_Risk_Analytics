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

--Vessel Block Risk
CREATE VIEW public.v_vessel_risk AS
SELECT 
    CASE 
        WHEN ca = 0 THEN '0 Vessels'
        WHEN ca = 1 THEN '1 Vessel'
        ELSE '2+ Vessels' 
    END AS vessel_group,
    COUNT(*) AS patient_count,
    -- The logic flip: (1 - 0) = 1 for disease
    ROUND((1 - AVG(target)) * 100, 1) AS disease_rate_pct
FROM public.heart_patient_data
GROUP BY 1
ORDER BY 1;

