-- =============================================================
-- 03_exploratory_queries.sql
-- Adult Vocational Education: Course Satisfaction & Dropout Analysis
-- Phase 4 (Analyze) — Exploratory Data Analysis (EDA)
-- Dataset: dropout_project.students (996 rows, cleaned)
-- =============================================================
-- NOTE: replace `praxis-backup-371112.dropout_project.students`
-- with your own project path if it changes.
-- =============================================================


-- -------------------------------------------------------------
-- Q1: Distribution of the target variable (Dropout_Risk)
-- Finding: perfectly balanced 498 / 498 — a sign of synthetic data
-- (real-world dropout almost never splits exactly 50/50).
-- -------------------------------------------------------------
SELECT Dropout_Risk,
    COUNT(*) AS n
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Dropout_Risk;


-- -------------------------------------------------------------
-- Q2: Dropout rate by Gender
-- (Dropout_Risk is 0/1, so AVG = share of at-risk students.)
-- Finding: 51% (female) vs 47% (male) — within noise, not a
-- meaningful difference (unequal group sizes; values hover ~0.50).
-- -------------------------------------------------------------
SELECT Gender,
    COUNT(*) AS n,
    AVG(Dropout_Risk) AS dropout_rate
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Gender;


-- -------------------------------------------------------------
-- Q3: Dropout rate by Education_Level
-- Finding: flat across groups (47-51%). Master shows 59% but
-- n=46 (small group, likely noise). Education does not
-- differentiate dropout.
-- -------------------------------------------------------------
SELECT Education_Level,
    COUNT(*) AS n,
    AVG(Dropout_Risk) AS dropout_rate
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Education_Level
ORDER BY dropout_rate DESC;


-- -------------------------------------------------------------
-- Q4: Dropout rate by Course_Completion_Rate (bucketed)
-- Finding: clear monotonic gradient — dropout falls from 76%
-- (completion 0.0) to 0% (completion 0.8). Strongest signal in
-- the data, BUT completion and dropout are near-tautological
-- (both measure course (non)progress) — descriptive overlap,
-- not a causal driver. Small n in top buckets (4-19).
-- -------------------------------------------------------------
SELECT
  ROUND(Course_Completion_Rate, 1) AS completion_bucket,
  COUNT(*) AS n,
  AVG(Dropout_Risk) AS dropout_rate
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY completion_bucket
ORDER BY completion_bucket;


-- -------------------------------------------------------------
-- Q5: Dropout rate by Engagement_Level
-- Finding: extreme gradient — 86% (Low) -> 35% (Medium) -> 0% (High).
-- WARNING: data leakage. Engagement_Level is NOT derived from actual
-- engagement metrics (flat across Interaction_Score / Forum, see Q7).
-- It appears generated jointly with Dropout_Risk from a shared latent
-- factor. EXCLUDE as a predictor; report only as a leakage example.
-- -------------------------------------------------------------
SELECT Engagement_Level,
    COUNT(*) AS n,
    AVG(Dropout_Risk) AS dropout_rate
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Engagement_Level
ORDER BY Engagement_Level;
