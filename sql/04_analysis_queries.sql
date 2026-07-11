-- =============================================================
-- 04_analysis_queries.sql
-- Adult Vocational Education: Course Satisfaction & Dropout Analysis
-- Phase 4 (Analyze) — Hypothesis testing (H1-H4) + Risk segmentation
-- Dataset: dropout_project.students (996 rows, cleaned)
-- =============================================================
-- Hypotheses (from project_log):
--   H1 (primary): weaker performance (lower score / efficiency) -> higher dropout
--   H2: lower peer/instructor interaction -> higher dropout
--   H3: satisfaction and dropout are NOT perfectly inversely linked
--   H4: employment/income moderate the performance->dropout link
-- =============================================================


-- -------------------------------------------------------------
-- Q6: H1 test — performance vs Dropout_Risk
-- Method: compare avg score & efficiency between dropout groups.
-- Finding: H1 REJECTED. Avg score nearly identical: 70.6 (stayed)
-- vs 69.5 (dropped) — 1.1 pt gap. Study_Efficiency even slightly
-- higher for dropouts (opposite of H1; note near-zero outliers).
-- Performance does not predict dropout in this dataset.
-- -------------------------------------------------------------
SELECT
  Dropout_Risk,
  COUNT(*) AS n,
  AVG(Average_Assessment_Score) AS avg_score,
  AVG(Study_Efficiency) AS avg_efficiency
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Dropout_Risk;


-- -------------------------------------------------------------
-- Q7: H2 test — real engagement metrics vs Dropout_Risk
-- Finding: H2 REJECTED. All flat: Peer 51.1 vs 49.6,
-- Instructor 3.01 vs 2.92, Forum 4.90 vs 5.03.
-- KEY: real engagement metrics show NO link to dropout, while the
-- synthetic Engagement_Level (Q5) shows 86%->0%. This proves
-- Engagement_Level is leakage, not behavior-derived.
-- -------------------------------------------------------------
SELECT
  Dropout_Risk,
  COUNT(*) AS n,
  AVG(Peer_Interaction_Score) AS avg_peer,
  AVG(Instructor_Interaction_Frequency) AS avg_instructor,
  AVG(Forum_Participation) AS avg_forum
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Dropout_Risk;


-- -------------------------------------------------------------
-- Q8: H3 test — Course_Satisfaction_Rating vs Dropout_Risk
-- Finding: H3 supported (technically). Satisfaction near-identical:
-- 3.49 (stayed) vs 3.41 (dropped). Satisfaction does NOT predict
-- dropout — consistent with H3's claim that the two aren't inversely
-- linked. But this reflects the dataset's overall lack of real
-- relationships, not a discovered mechanism.
-- -------------------------------------------------------------
SELECT
  Dropout_Risk,
  COUNT(*) AS n,
  AVG(Course_Satisfaction_Rating) AS avg_satisfaction
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Dropout_Risk;


-- -------------------------------------------------------------
-- Q9: H4 test — Income_Level vs Dropout_Risk (simplified moderation)
-- Finding: H4 REJECTED. Dropout flat across income: 0.50 / 0.51 / 0.49.
-- Score flat too: ~70 in all. Income neither predicts dropout nor
-- moderates the score->dropout link.
-- Note: full moderation (score x income interaction) is not
-- meaningfully testable on this data; simplified to a direct-effect
-- check, which already shows no effect.
-- -------------------------------------------------------------
SELECT
  Income_Level,
  COUNT(*) AS n,
  AVG(Dropout_Risk) AS dropout_rate,
  AVG(Average_Assessment_Score) AS avg_score
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY Income_Level
ORDER BY Income_Level;


-- -------------------------------------------------------------
-- Q10: Risk segmentation by Course_Completion_Rate (CASE WHEN)
-- Finding: segments DO separate (high 60% / medium 43% / low 20%)
-- BUT this is tautological — completion ≈ dropout. No EARLY
-- predictors exist (demographics / engagement all flat), and
-- completion is only known mid-course, so actionable early-warning
-- segmentation is NOT possible on this dataset.
-- Real segmentation would require genuine early-stage predictors
-- (carried forward as a recommendation in the Act phase).
-- -------------------------------------------------------------
SELECT
  CASE
    WHEN Course_Completion_Rate < 0.3 THEN 'high_risk'
    WHEN Course_Completion_Rate < 0.5 THEN 'medium_risk'
    ELSE 'low_risk'
  END AS risk_segment,
  COUNT(*) AS n,
  AVG(Dropout_Risk) AS actual_dropout_rate
FROM `praxis-backup-371112.dropout_project.students`
GROUP BY risk_segment
ORDER BY actual_dropout_rate DESC;
