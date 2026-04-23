# Credit-Risk-Analysis
Credit Risk And Default Analysis Using Microsoft Sql
# Credit Risk & Default Analysis Using SQL Server

I built this project while preparing for the FRM Part 1 exam to bridge the gap between the theory I'm studying and real data work. The idea was simple it was to take a lending dataset from Kaggle datasets, treat it like a bank portfolio, and see what actually drives default risk.

The dataset has around 32,000 loans from Kaggle. Everything here data cleaning, analysis, findings was done in Microsoft SQL Server by me.

---

# What I wanted to find out

1. Which borrowers are the riskiest, and why?
2. Is income a good predictor of default, or are there better ones?
3. How does the portfolio's default rate compare to what's considered healthy in banking?
4. If I were advising this bank, what would I change about their lending?

---

# Tools used

Microsoft SQL Server (T-SQL) and ive used the window functions, CTEs, aggregations, CASE-based segmentation properly in this project.
no Power BI (yet — that's the next step).

---

# How the analysis is structured

The SQL file follows a proper analytical flow rather than jumping around:

**1. Data cleaning** — Nulls were handled with median imputation, duplicates were  removed using ROW_NUMBER, and impossible values (like someone aged 144, or 123 years of employment) replaced with sensible thresholds.

**2. Exploratory analysis** — portfolio-level averages first, then breakdowns by loan intent, loan grade, home ownership, and prior default history.

**3. Ranking analysis** — ranking segments by default rate and interest rate to see where the real risk is.

**4. Performance analysis** — comparing each segment against the overall portfolio default rate (21.87%) to classify them as above or below average.

**5. Segmentation** — grouping borrowers by income band, age bracket, and combined risk tiers.

Each section has my own key findings written as comments directly in the SQL file.



# What I found

The portfolio has **32,416** loans worth roughly **$311 million**, and an overall default rate of **21.87%** — which is way above the 5–10% range most banks consider healthy. So this is a risky book to begin with.

The typical borrower here is young (average age 27), early in their career, and still building credit history. That alone explains a lot of the elevated default rate.

A few things that stood out:

**Loan grade is the strongest predictor of default.** Grade A borrowers default at 9.96%, Grade G at 98.44%. There's a huge jump between Grade C (20.75%) and Grade D (59.06%) which basically Grade D onwards should be treated as a different category of risk entirely.

**Home ownership matters more than I expected.** Renters default at 31.61%, homeowners at just 7.49%. Even more than income — homeowners default less despite having a higher DTI than renters. This shows that owning property seems to signal something banks don't capture in income alone.

**High income doesn't mean low risk.** Grade F and G borrowers actually earn the most on average but default the most, because their DTI ratios are through the roof. This was the most counter-intuitive finding for me.

**Borrowers with a prior default on file default again at more than 2x the rate** of clean borrowers (37.87% vs 18.43%). The bank already charges them higher interest, but clearly the premium isn't enough.

**Loan popularity doesn't track with risk.** Education is the most popular reason for a loan but only 5th in default rate. Debt consolidation is less popular but the riskiest at 28.68% — which makes sense because people taking debt-consolidation loans are usually already in financial trouble.

**Rate vs volume matters.** Grade G has a 98.44% default rate but only accounts for 0.89% of total defaults. Grade D has a lower rate (59.06%) but drives 30% of defaults just because there's more of them. A risk team would focus there first.

---

## What I'd recommend if this were a real bank

1. Tighten credit controls for Grades D through G
2. Use DTI as a primary screening metric ,it's more reliable than income
3.Apply stricter approval criteria for renters
4. Look harder into debt consolidation and medical loan applications
5. Put loan amount caps on high-risk segments
6. Keep an eye on Grade C — it's borderline and could slip below average
7.Continue growth in Grade A and B segments ,safest and already the largest

---

## Files in this repo

| `credit_risk_Analysis_project.sql` | The full SQL script — cleaning through to final findings, with my notes in comments |
| `README.md` | This file |

---

## What's next

- Building a Power BI dashboard on top of this to make the findings interactive
- Adding a loan grade × income cross-analysis
- Eventually trying a predictive model (logistic regression) on the cleaned data

---

## About me

I'm Santo P Thomas — MSc Business Analytics graduate based in Ireland, currently preparing for the FRM certification with the goal of moving into a credit risk or risk analytics role. This is one of the projects I'm building as part of that pivot.

Open to entry-level opportunities in Credit Risk, Risk Reporting, and Model Validation.
