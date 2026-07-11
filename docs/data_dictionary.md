# Data Dictionary
## Adult Vocational Education: Course Satisfaction and Dropout Analysis

**Source:** [Kaggle — llovek/dropout-risk](https://www.kaggle.com/datasets/llovek/dropout-risk)
**File:** `origin_data.xlsx`
**Records:** 1,000 rows × 28 columns
**Duplicates:** 0
**Last reviewed:** _[fill in date]_

---

## ⚠️ Important Note on Encoding

The dataset author did not publish a data dictionary. A request was submitted via the Kaggle Discussion page (_[link to discussion topic]_).

All encoding mappings below are **working assumptions** based on:
- Domain knowledge (adult vocational education context)
- Statistical inference (cross-correlations with related variables, to be validated in Process phase)

These assumptions should be re-validated if the analysis is reused or extended.

---

## 1. Demographic Variables

| Column | Type | Values | Assumed Encoding                                                                                                                                              | Missing % | Notes |
|---|---|---|---------------------------------------------------------------------------------------------------------------------------------------------------------------|---|---|
| `Age` | int | 18–64 | Actual age in years                                                                                                                                           | 0.0% | No missing values |
| `Gender` | categorical | 0, 1 | 0 = Male, 1 = Female *(assumption — order not verifiable from data alone)*                                                                                    | 0.1% | Binary |
| `Education_Level` | ordinal | 0–4 | 0 = No formal/Primary, 1 = Junior secondary, 2 = Senior secondary/Vocational, 3 = Associate/Bachelor, 4 = Master *(ascending; bucketing assumed, unverified)* | 0.1% | Validated against Income_Level: Spearman ≈ 0.02 (no correlation) — labels are for readability only, column carries no analytical signal |
| `Employment_Status` | categorical | 0–4 | 0 = Employed full-time, 1 = Part-time, 2 = Self-employed, 3 = Unemployed, 4 = Student/Retired *(illustrative labels; order arbitrary, unverified)*            | 0.3% | Encoding sanity-checked against Income and Age — no relationship found; labels are cosmetic only |
| `Income_Level` | ordinal | 0, 1, 2 | 0 = Low, 1 = Medium, 2 = High                                                                                                                                 | 1.0% | |
| `Location` | categorical | 0, 1 | 0 = Rural, 1 = Urban                                                                                                                                          | 1.2% | Binary. Direction arbitrary/unverified — no relationship with Income/Age. Mapping set so the 75% majority is Urban (more plausible for an online platform); cosmetic only |

---

## 2. Learning Behavior Variables

| Column | Type | Values | Assumed Encoding                                                                                         | Missing % | Notes |
|---|---|---|----------------------------------------------------------------------------------------------------------|---|---|
| `Preferred_Learning_Style` | categorical | 0, 1, 2 | 0 = Visual, 1 = Auditory, 2 = Kinesthetic *(VAK model; labels assumed, order arbitrary, unverified)*     | 1.5% | |
| `Device_Used_for_Learning` | categorical | 0, 1, 2 | 0 = Mobile, 1 = Tablet, 2 = Desktop/Laptop *(labels assumed, order inferred from frequency, unverified)* | 0.5% | |
| `Preferred_Study_Time` | categorical | 0, 1, 2 | 0 = Morning, 1 = Afternoon, 2 = Evening/Night                                                            | 0.3% | |
| `Courses_Enrolled` | int | 0–10 | Number of courses currently enrolled                                                                     | 0.0% | |
| `Average_Study_Time_per_Week` | float | 0.00–11.41 | Hours per week                                                                                           | 1.5% | ⚠️ Min = 0 — flag for engineered feature recalc |

---

## 3. Performance Variables

| Column | Type | Range | Description | Missing % | Notes |
|---|---|---|---|---|---|
| `Course_Completion_Rate` | float | 0.01–0.81 | Proportion of course completed (0–1) | 2.6% | |
| `Number_of_Assessments_Taken` | int | 2–21 | Count of assessments completed | 1.6% | |
| `Average_Assessment_Score` | float | 23.4–100.0 | Average score across assessments (0–100) | 1.6% | |
| `Study_Efficiency` | float | 2.70–**97540.36** | Engineered feature (likely Score / Study_Time) | 2.1% | 🚨 **Severe outliers** — divide-by-near-zero artifact. To recompute or drop in Process phase |
| `Assessment_Intensity` | float | 0.38–**20000.00** | Engineered feature (likely Assessments / Completion_Rate or similar) | 1.1% | 🚨 **Severe outliers** — same issue. To recompute or drop |

---

## 4. Engagement Variables

| Column | Type | Values | Description | Missing % | Notes |
|---|---|---|---|---|---|
| `Forum_Participation` | int | 0–13 | Number of forum posts/contributions | 0.3% | |
| `Peer_Interaction_Score` | float | 13.92–79.66 | Calculated peer interaction score | 1.0% | |
| `Instructor_Interaction_Frequency` | int | 0–10 | Interactions with instructor (count) | 0.3% | |
| `Motivation_Level` | ordinal | 0, 1, 2 | 0 = Low, 1 = Medium, 2 = High | 0.4% | |
| `Engagement_Level` | ordinal | 0, 1, 2 | 0 = Low, 1 = Medium, 2 = High *(engineered)* | 0.5% | Likely derived from interaction metrics |
| `Interaction_Score` | float | 23.93–163.82 | Composite score *(engineered)* | 0.3% | Possibly Peer + Instructor combined |

---

## 5. Outcome Variables (Targets)

| Column | Type | Values | Assumed Encoding | Missing % | Notes |
|---|---|---|---|---|---|
| `Course_Satisfaction_Rating` | float | 1.00–5.00 | Likert-style rating | 0.5% | Continuous, likely averaged |
| `Course_Satisfaction_Level` | ordinal | 0, 1, 2 | 0 = Low, 1 = Medium, 2 = High *(engineered)* | 0.4% | Likely bucketed from Rating |
| `Feedback_Sentiment` | ordinal | 0, 1, 2 | 0 = Negative, 1 = Neutral, 2 = Positive | 0.4% | |
| `Certification_Achieved` | binary | 0, 1 | 0 = No, 1 = Yes | 0.4% | |
| `Learning_Outcome_Status` | binary | 0, 1 | 0 = Did not pass, 1 = Passed | 0.4% | |
| **`Dropout_Risk`** | **binary** | **0, 1** | **0 = No risk, 1 = At risk** ← **PRIMARY TARGET** | 0.4% | ⚠️ Appears to be predicted/derived risk, not observed dropout event |

---

## 6. Suspected Engineered Features (to verify in Process)

These columns appear to be **derived** from other columns, not raw measurements. Use with caution to avoid data leakage in correlation analysis:

- `Study_Efficiency` ← likely from `Average_Assessment_Score` / `Average_Study_Time_per_Week`
- `Assessment_Intensity` ← likely from `Number_of_Assessments_Taken` / `Course_Completion_Rate` (or similar)
- `Interaction_Score` ← likely from `Peer_Interaction_Score` + `Instructor_Interaction_Frequency`
- `Engagement_Level` ← likely bucketed from interaction metrics
- `Course_Satisfaction_Level` ← likely bucketed from `Course_Satisfaction_Rating`

**Recommendation:** in correlation analysis, use either raw columns OR engineered features, not both, to avoid spurious correlations.

---

## 7. Data Quality Summary

| Issue | Severity | Resolution Plan (Process phase) |
|---|---|---|
| Missing values across most columns (0.1–2.6%) | 🟡 Low | Impute median (numeric) / mode (categorical) + add `was_missing_<col>` flag. Drop rows where target columns are missing. |
| Severe outliers in `Study_Efficiency` (max 97540) | 🔴 High | Recompute with denominator guard, or drop in favor of raw components |
| Severe outliers in `Assessment_Intensity` (max 20000) | 🔴 High | Same as above |
| No data dictionary from author | 🟡 Medium | Document all encoding assumptions (this file). Validate via statistical inference. |
| Categorical encoding ambiguity (Gender, Location, etc.) | 🟡 Medium | Use neutral labels in dashboard where direction cannot be confirmed |

---

## 8. Change Log

| Date | Change |
|---|---|
| _[date]_ | Initial version created during Prepare phase |
| _[date]_ | _[update when author responds or assumptions are validated]_ |
