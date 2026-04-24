# Credit Risk & Default Analysis — SQL Server

I built this project while preparing for the FRM Part 1 exam. I wanted something practical to sit alongside the theory — a way to actually work with loan data instead of just reading about PD and expected loss in a textbook.

The dataset is a public Kaggle file with ~32,000 consumer loans. It's synthetic, and the default rate is way higher than what a real regulated bank would ever run with, so I'm not pretending this is a real portfolio. What I wanted to practice is the analytical approach — cleaning messy data, segmenting borrowers, ranking risk, and writing up findings the way an analyst would.

Everything (cleaning, analysis, findings) was done in Microsoft SQL Server. The dashboard is built in Power BI on top of the SQL outputs.

<img width="1277" height="707" alt="dashboard_preview" src="https://github.com/user-attachments/assets/b386caf1-735c-4296-a84c-e1f8abbb5117" />


---

## The dataset at a glance

| | |
|---|---|
| Loans | 32,416 |
| Total amount | ~$311M |
| Overall default rate | 21.87% |
| Average borrower age | 27 |

For context, a healthy consumer lending book usually sits somewhere in the 5–10% default range. This one is sitting at more than double that — mostly because the dataset skews young, early-career, and thin on credit history.

**Dataset:** [Credit Risk Dataset on Kaggle](https://www.kaggle.com/datasets/laotse/credit-risk-dataset)

---

## What I wanted to figure out

1. Which borrowers are driving the defaults, and why?
2. Is income actually a good predictor of default, or is something else doing the work?
3. How does this portfolio compare to what banks consider "healthy"?
4. If I were writing this up for a risk team, what would I flag?
5. Can I land all of it in a single-page dashboard?

---

## How I approached it

The SQL file follows a proper flow rather than jumping around:

**Cleaning first.** Nulls filled with the median (employment length and interest rate had gaps). Duplicates removed using `ROW_NUMBER()`. Impossible values — someone listed as 144 years old, another with 123 years of employment — capped at sensible thresholds.

**Then exploration.** Started with portfolio-wide averages — age, income, loan size, interest rate, DTI, default rate — to get a feel for who the typical borrower is.

**Then magnitude Analysis.** Broke the portfolio down by loan intent, loan grade, home ownership, and prior default history, looking at averages across each group. This is where a lot of the interesting patterns first showed up — like Grade F and G borrowers earning the most but defaulting the most.

**Then ranking Analysis.** Which segments are the riskiest by default rate and interest rate?

**Then performance Analysis.** How does each segment compare to the 21.87% portfolio average? Above or below?

**Then segmentation Analysis.** Grouping borrowers by income band, age bracket, and overall risk tier.

I wrote my reasoning as comments in the SQL file as I went, so the logic is traceable rather than just showing outputs.

---

## What I found

**Loan grade is the biggest driver of default risk.** Grade A defaults at 9.96%, Grade G at 98.44%. But the interesting bit isn't the extreme — it's the jump between Grade C (20.75%) and Grade D (59.06%). That's almost a tripling in one step. In practice, anything D and below should probably be treated as a different product entirely, not just the next rung down.

**Home ownership seems to matter more than income.** Renters default at 31.61%, homeowners at 7.49%. And homeowners in this data actually carry a higher DTI than renters, which surprised me — it suggests owning a home captures something about financial stability that income and DTI alone don't. (Caveat: this is a univariate look. To make a real claim I'd want to control for loan grade and age first.)

**High income doesn't mean low risk.** Grade F and G borrowers earn the most on average but default the most, because their DTI ratios are through the roof. This was the most counter-intuitive finding for me and probably the one I'd talk about in an interview.

**Prior default is a strong repeat signal.** Borrowers with a prior default on file default again at 37.87% vs 18.43% for clean borrowers — more than 2x. The dataset shows they're charged higher interest, but the gap between the premium and the realised default rate looks narrow. A full pricing adequacy check would need LGD and funding cost data I don't have.

**Popularity and risk don't line up.** Education loans are the most common but only 5th riskiest. Debt consolidation is less common but the riskiest at 28.68% — which tracks, because people consolidating debt are usually already in trouble before they apply.

**Rate vs volume matters.** Grade G has a 98.44% default rate but is only 0.89% of total defaults (it's a tiny slice of the book). Grade D has a lower rate — 59.06% — but drives ~30% of defaults because it's bigger. If I were a risk analyst prioritising where to dig in, I'd start with Grade D, not Grade G.

---

## If I were writing this up for a risk team

These are the things I'd flag — framed as observations for a senior to decide on, not policy I'm prescribing.

1. Grades D–G behave as a distinct risk tier, not a smooth continuation of A–C
2. DTI looks more informative than income on its own
3. Renter status is associated with materially higher default rates
4. Debt consolidation and medical loans are worth a closer underwriting look
5. Grade D is where the volume-weighted risk actually sits, not Grade G
6. Grade C is just below the portfolio average — worth monitoring in case it drifts above

---

## Files in the repo

| File | What it is |
|---|---|
| `credit_risk_Analysis_project.sql` | The full SQL script — cleaning through to findings, with my notes in comments |
| `credit_risk_dashboard.pbix` | Power BI dashboard |
| `dashboard_preview.png` | Dashboard screenshot |
| `README.md` | This file |

---

## What this project is (and isn't)

Worth being upfront about the limits:

- **It's a synthetic public dataset**, not a real bank's book. Default rates and borrower profile don't reflect a regulated portfolio.
- **It's a static snapshot** — no time dimension, so no vintage or cohort analysis.
- **The findings are univariate.** Most breakdowns don't control for confounders. A proper scorecard build would need regression.
- **No LGD or EAD** in the data, so I didn't attempt expected loss calculations.
- **No predictive modelling.** The point here was to get the data handling and reasoning right, not to build a scorecard.

---

## About me

I'm Santo P Thomas — MSc Business Analytics graduate based in Ireland, currently working through the FRM certification with the goal of moving into credit risk or risk analytics. This is one of a few projects I'm building as part of that pivot.

Open to entry-level roles in **Credit Risk**, **Risk Reporting**, and **Model Validation**.
**email - santopthomas777@gmail.com**
**Linkedin -www.linkedin.com/in/santo-p-thomas**
