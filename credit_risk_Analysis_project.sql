USe CreditRisk

Select *
From credit_risk

Select Top 5 *
From credit_risk

-- 1.DATA EXPLORATION

-- 1.1Know the size
Select
count(*) as total_rows
From credit_risk

-- 1.2 EXPLORING DEFAULTS IN DATA
Select Top 5 *
From credit_risk

-- 2. DATA CLEANING

-- 2.1 FINDING NULL VALUES

Select 
Sum(Case when person_age is null then 1 else 0 end ) as null_age,
Sum(Case when person_income is null then 1 else 0 end ) as null_income,
Sum(Case when person_home_ownership is null then 1 else 0 end ) as null_ownership,
Sum(Case when person_emp_length is null then 1 else 0 end ) as null_emp_lenth,
Sum(Case when loan_intent is null then 1 else 0 end ) as null_loan_intent,
Sum(Case when loan_grade is null then 1 else 0 end ) as null_loan_grade,
Sum(Case when loan_amnt is null then 1 else 0 end ) as null_loan_amnt,
Sum(Case when loan_int_rate is null then 1 else 0 end ) as null_int_rate,
Sum(Case when loan_status is null then 1 else 0 end ) as null_loan_status,
Sum(Case when loan_percent_income is null then 1 else 0 end ) as null_percentage_income,
Sum(Case when cb_person_default_on_file is null then 1 else 0 end ) as null_default_on_file,
Sum(Case when cb_person_cred_hist_length is null then 1 else 0 end ) as null_cred_hist_length
From credit_risk

-- 2.2 REPLACING NULL VALUES WITH MEDIAN

Select distinct
PERCENTILE_CONT(0.5) within group (order by cast(person_emp_length as float)) Over () as median_emp_length,
PERCENTILE_CONT(0.5) within group (order by cast(loan_int_rate as float)) over () as medain_int_rate
From credit_risk

Update credit_risk
Set person_emp_length = '4'
where person_emp_length  is Null

Update credit_risk
Set loan_int_rate = '10.99'
where loan_int_rate is null

--Verification
Select 
Sum(Case when person_emp_length is null then 1 else 0 end) as verify_emp_length,
Sum(Case when loan_int_rate is null then 1 else 0 end)  as verify_loan_int_rate
From credit_risk

Select distinct person_emp_length
From credit_risk

Select distinct loan_int_rate
From credit_risk

-- 2.2 FINDING DUPLICATES 

Select
person_age,
person_income,
person_home_ownership,
person_emp_length,
loan_intent,
loan_grade,
loan_amnt,
loan_int_rate,
loan_status,
loan_percent_income,
cb_person_default_on_file,
cb_person_cred_hist_length,
count(*) as duplicate_count
From credit_risk
Group by 
person_age,
person_income,
person_home_ownership,
person_emp_length,
loan_intent,
loan_grade,
loan_amnt,
loan_int_rate,
loan_status,
loan_percent_income,
cb_person_default_on_file,
cb_person_cred_hist_length
Having Count(*)>1

-- 2.3 CLEANING DUPLICATES

; With CTE as (
Select *,
ROW_NUMBER () Over (Partition by person_age,
person_income,
person_home_ownership,
person_emp_length,
loan_intent,
loan_grade,
loan_amnt,
loan_int_rate,
loan_status,
loan_percent_income,
cb_person_default_on_file,
cb_person_cred_hist_length Order by (select null)) as row_numb
From credit_risk
)
Delete From Cte where row_numb>1

-- Verification
Select
count(*) as total_rows
From credit_risk

-- 2.4 Checking Outliers or impossible values
Select 
Max(Cast(person_age as int)) as max_age,
Min(Cast(person_age as int)) as min_age,
Max(Cast(person_income as float)) as max_income,
Min(Cast(person_income as float)) as min_income,
Max(Cast(person_emp_length as int)) as max_emp_length,
Min(Cast(person_emp_length as int)) as min_emp_length,
Max(Cast(loan_amnt as float)) as max_loan_amnt,
Min(Cast(loan_amnt as float)) as min_loan_amnt,
Max(Cast(loan_int_rate as float)) as max_loan_int_rate,
Min(Cast(loan_int_rate as float)) as min_loan_int_rate,
Max(Cast(loan_status as int)) as max_loan_status,
Min(Cast(loan_status as int)) as min_loan_status,
Max(Cast(loan_percent_income as float)) as max_loan_percent_income,
Min(Cast(loan_percent_income as float)) as min_loan_percent_income,
Max(Cast(cb_person_default_on_file as int)) as max_cb_person_default_on_file,
Min(Cast(cb_person_default_on_file as int)) as min_cb_person_default_on_file,
Max(Cast(cb_person_cred_hist_length as int)) as max_cb_person_cred_hist_length,
Min(Cast(cb_person_cred_hist_length as int)) as min_cb_person_cred_hist_length
From credit_risk

--2.5 Replacing impossible values which are age max=144 and employment lenght = 123 with median
Select Distinct 
PERCENTILE_CONT(0.5) within group(Order by Cast(person_age as int)) Over() as Median_age,
PERCENTILE_CONT(0.5) Within group(Order By Cast(person_emp_length as int)) Over() as Median_emp_length
From credit_risk

Update credit_risk
Set person_age = '26'
Where cast(person_age as int)>100  --setting a threshold age as 100

Update credit_risk
Set person_emp_length = '4'
Where Cast(person_emp_length as int)>60 --setting a threshold employment length as 60

--Verification
Select 
Max(Cast(person_age as int)) as max_age,
Min(Cast(person_age as int)) as min_age,
Max(Cast(person_emp_length as int)) as max_emp_length,
Min(Cast(person_emp_length as int)) as min_emp_length
From credit_risk

-- 2.6 CHECK FOR INCONSISTENT VALUES
Select distinct person_home_ownership
From credit_risk

Select distinct loan_intent
From credit_risk

Select distinct loan_grade
From credit_risk

Select distinct loan_status
From credit_risk

Select distinct cb_person_default_on_file
From credit_risk

Select *
From credit_risk

-- Result - No inconsistent errors like upper case, lower case, extra space or typo error

-- 3. EXPLORATORY DATA ANALYSIS (Intial Analysis)

Select *
From credit_risk

--3.1 Measure Analysis


--Borrower Age

Select 
Min(person_age) as youngest_borrower,
Max(person_age) as Oldest_borrower,
Avg(person_age) as Avg_age,

--Borrower Income

Min(person_income) as lowest_income,
Max(person_income) as Highest_income,
Avg(person_income) as Avg_income,

--Loan Amount
count(*) as number_of_loans,
Sum(loan_amnt) as total_loan_amount_lent,
Min(loan_amnt) as lowest_loan_amount,
Max(loan_amnt) as Highest_loan_amount,
Avg(loan_amnt) as Avg_loan_amount,

--Interest Rate
Round(Min(loan_int_rate),2) as lowest_loan_interest,
Round(Max(loan_int_rate),2) as Highest_loan_interst,
Round(Avg(loan_int_rate),2) as Avg_loan_interest,

-- Employment length 
Min(person_emp_length) as lowest_employment_length,
Max(person_emp_length) as Highest_employemnt_length,
Round(Avg(person_emp_length),1) as Avg_employemnt_length,

--Loan to income ratio

Min(loan_percent_income) as lowest_loan_percent_income,
Round(Max(loan_percent_income),2) *100 as Highest_loan_percent_income,
Round(Avg(loan_percent_income),2)* 100 as Avg_loan_percent_income,

--Credit_history


Min(cb_person_cred_hist_length) as shortest_credit_history,
Max(cb_person_cred_hist_length) as longest_credit_history,
Round(Avg(cb_person_cred_hist_length), 1) as avg_credit_history,

--Default rate 

count(*) as number_of_loans,
Sum(cast(loan_status as int)) as total_default,
Count(*)-Sum(cast(loan_status as int))as non_defaults,
Round(Sum(cast(loan_status as int))*100.0/Count(*),2) as default_rate
From credit_risk

--Key Findings
--1. Portfolio : 32,416 total loans worth ~311 million
--2. Default : 21.87% - (significantly above 5-10% banking threshold)
--3. Typical Borrower : Young (avg age 27), early career (avg 4.8 yrs experience)
--4. Credit History : Average 5 years -(still building financial track record)
--5. Loan Amount : Average 9,593 ranging from 500 to 35,000
--6. Interest Rate : Average 11.01% ranging from 5.42% to 23.22%
--7. Loan to income Ratio: Average 17% but some borrowers as high as 83%

/*From this Key finding we can say that, This is a high risk portfolio dominated by young, early career borrowers
  with limited credit history carrying meaningful debt burdens which reflected
 in the significantly elevated default rate of 21.87% */



-- Section 3.2 : Magnitude Analysis
-- Total [Measures] By Loan Intent


Select
loan_intent,
Avg(person_age) as Avg_age,
Avg(person_income) as Avg_income,
count(*) as number_of_loans,
Sum(loan_amnt) as total_loan_amount_len,
Avg(loan_amnt) as Avg_loan_amount,
Round(Avg(loan_int_rate),2) as Avg_loan_interest,
Round(Avg(person_emp_length),1) as Avg_employemnt_length,
Round(Avg(loan_percent_income)* 100.0,2) as Avg_loan_percent_income,
Round(Avg(cb_person_cred_hist_length), 1) as avg_credit_history,
Sum(cast(loan_status as int)) as total_default,
Round(Sum(cast(loan_status as int))*100.0/Count(*),2) as default_rate
From credit_risk
group by loan_intent
order by total_loan_amount_len desc

-- Key Findings
/* 1.Education - Education has the highest number of loans and highest amount lend.
eventhough they have one of the lowest default rate of 17.25%. This might be because the education loan borrowers
are more disciplined with their repayment.

2. Debt consolidation - Debt consolidation have the highest default rate (28.68%).
The reason might be they are already in financial crisis so they are taking loan to
pay the exsiting debt. This makes them high risk category in the list

3. Venture - This category has the lowest default rate of 14.85%. The reason might be
business borrowers are financially more stable with income from their
ventures making them better positioned to repay loans.

4. HOME IMPROVEMENT - Home improvement borrowers earn the most (avg 73,575) and take the largest
loans (avg 10,362) yet still carry a high default rate of 26.15% which suggest 
income alone does not guarantee repayment.

Insights in short--
1. Debt Consolidation and Medical loans are the riskiest segments.
2.Venture loans are the safest. Education dominates in volume.
3.The bank should apply stricter credit controls for debt consolidation and medical loan applicants.*/

-- Total [Measures] By Loan Grade

Select
loan_grade,
Avg(person_age) as Avg_age,
Avg(person_income) as Avg_income,
count(*) as number_of_loans,
Sum(loan_amnt) as total_loan_amount_len,
Avg(loan_amnt) as Avg_loan_amount,
Round(Avg(loan_int_rate),2) as Avg_loan_interest,
Round(Avg(person_emp_length),1) as Avg_employemnt_length,
Round(Avg(loan_percent_income)* 100.0,2) as Avg_loan_percent_income,
Round(Avg(cb_person_cred_hist_length), 1) as avg_credit_history,
Sum(cast(loan_status as int)) as total_default,
Round(Sum(cast(loan_status as int))*100.0/Count(*),2) as default_rate
From credit_risk
Group by loan_grade
order by loan_grade

-- Key findings 
/* Grade A borrowers have the lowest default rate of 9.96% with lowest interest rate of (7.67%) and lowest DTI (15.38%). 
Interestingly, Grade F and G borrowers earn the highest income yet they have the highest default rates of 70.54% and 98.44% respectively
due to their extremely high DTI ratios of 21.56% and 24.39%. This shows  that income alone is not a reliable indicator of creditworthiness — 
DTI and loan grade are far stronger predictors of default risk.*/


-- Total [Measures] By person home ownership
Select 
person_home_ownership,
Avg(person_age) as Avg_age,
Avg(person_income) as Avg_income,
count(*) as number_of_loans,
Sum(loan_amnt) as total_loan_amount_len,
Avg(loan_amnt) as Avg_loan_amount,
Round(Avg(loan_int_rate),2) as Avg_loan_interest,
Round(Avg(person_emp_length),1) as Avg_employemnt_length,
Round(Avg(loan_percent_income)* 100.0,2) as Avg_loan_percent_income,
Round(Avg(cb_person_cred_hist_length), 1) as avg_credit_history,
Sum(cast(loan_status as int)) as total_default,
Round(Sum(cast(loan_status as int))*100.0/Count(*),2) as default_rate
From credit_risk
Group by person_home_ownership
order by default_rate

/*Renters dominate the portfolio with 16,378 loans (50%+ of total) yet carry the highest default rate of 31.61% 
with the lowest average income (55,019), shortest employment history (3.8 years) and no property asset as financial backup. 
Interestingly, homeowners (OWN) have the lowest default rate of just 7.49% despite having the second highest DTI of 18.88% —
suggesting that owning a home provides financial stability that reduces default risk regardless of debt burden.
Mortgage borrowers are the most stable segment with the highest average income (81,150) and longest employment history (5.8 years) reflected in their moderate default rate of 12.62%. 
This confirms that home ownership status is a stronger predictor of default risk than income or DTI alone —
and the bank should apply stricter credit controls for renter applications.*/




-- Total [Measures] By cb_person_default_on_file

Select 
cb_person_default_on_file,
Avg(person_age) as Avg_age,
Avg(person_income) as Avg_income,
count(*) as number_of_loans,
Sum(loan_amnt) as total_loan_amount_len,
Avg(loan_amnt) as Avg_loan_amount,
Round(Avg(loan_int_rate),2) as Avg_loan_interest,
Round(Avg(person_emp_length),1) as Avg_employemnt_length,
Round(Avg(loan_percent_income)* 100.0,2) as Avg_loan_percent_income,
Round(Avg(cb_person_cred_hist_length), 1) as avg_credit_history,
Sum(cast(loan_status as int)) as total_default,
Round(Sum(cast(loan_status as int))*100.0/Count(*),2) as default_rate
From credit_risk
Group by cb_person_default_on_file
order by default_rate

--Key Findings -
/* Only 5,730 borrowers (17.7% of the portfolio) have a previous default on file, yet they represent a disproportionately high risk segment.
Borrowers with a prior default carry a default rate of 37.87% — more than double the 18.43% rate of borrowers with no default history. 
The bank already recognises this risk by charging higher interest rates to this group (14.19% vs 10.33%), however the elevated default rate suggests that interest rate alone is insufficient to compensate for the additional risk. 
This confirms a clear pattern of repeat default behaviour — borrowers who have defaulted before are significantly more likely to default again, posing substantial credit risk to the portfolio.*/


-- Section 3.3 : Ranking Analysis

--Default Rate by loan grade
Select 
loan_grade,
Count(*) as Total_loans,
Sum(cast(loan_status as int)) as Total_default,
Round(Sum(cast(loan_status as int))*100.0/Count(*),2) as default_rate,
Rank()Over(Order by Sum(cast(loan_status as int))*100.0/Count(*) Desc) as Risk_rank
From credit_risk
Group by loan_grade
Order by Risk_rank

--Key Findings 
/*Loan grade is the strongest predictor of default risk in this portfolio.
Grade G ranks as the riskiest segment with a default rate of 98.44% — 63 out of 64 borrowers defaulted, making it an extremely high risk category.
At the other end, Grade A is the safest segment with the highest number of loans (10,703) yet the lowest default rate of just 9.96%, indicating that the bank can lend to Grade A borrowers with high confidence of repayment. 
Notably, there is a significant jump in default rate between Grade C (20.75%) and Grade D (59.06%) — suggesting that Grades D, E, F and G should be treated as high risk segments requiring stricter credit controls or higher interest rates to compensate for the elevated risk.*/


--Default rate by loan intent
Select 
loan_intent,
Count(*) as total_loans,
Sum(cast(loan_status as int)) as Total_default,
Round(Sum(cast(loan_status as int))*100.0/count(*),2) as Default_rate,
Rank()Over(order by Sum(cast(loan_status as int))*100.0/count(*) Desc) as Risk_rank
From credit_risk
Group by loan_intent
Order by Risk_rank

--Key Findings:
/*Debt consolidation loans rank as the riskiest segment with the highest default rate of 28.68% — borrowers taking loans to pay off existing debts are already financially struggling, making them inherently high risk. 
Medical loans follow closely at 26.76% driven by the unexpected nature of medical emergencies where borrowers take urgent loans without fully considering repayment capacity.
At the other end, Venture loans are the safest segment with the lowest default rate of 14.85% — business borrowers take loans to generate income making them better positioned to repay.
Notably, the default rate of Debt Consolidation (28.68%) is almost double that of Venture loans (14.85%) — the bank should apply significantly stricter credit controls for debt consolidation and medical loan applicants while maintaining favourable lending terms for venture borrowers.*/

--Default Rate by home ownership

Select 
person_home_ownership,
Count(*) as total_loans,
Sum(cast(loan_status as int)) as Total_default,
Round(Sum(cast(loan_status as int))*100.0/count(*),2) as Default_rate,
Rank()Over(order by Sum(cast(loan_status as int))*100.0/count(*) Desc) as Risk_rank
From credit_risk
Group by person_home_ownership
Order by Risk_rank

--Key Findings
/*Renters rank as the highest risk segment with a default rate of 31.61% — likely driven by lower financial stability as rental payments consume a significant portion of their income leaving less capacity for loan repayment. 
The Other category mirrors renters closely with a default rate of 31.13% despite having only 106 loans — too small a segment to draw strong conclusions but worth monitoring. 
There is a significant gap between Other (31.13%) and Mortgage borrowers (12.62%) — more than double the default rate 
suggesting that having a mortgage commitment actually correlates with greater financial responsibility. 
Homeowners (OWN) are the safest segment with the lowest default rate of just 7.49% — owning a home outright eliminates rental or mortgage payments freeing up more income for loan repayment. 
The bank should apply stricter credit controls for renter and Other applicants while maintaining favourable lending terms for homeowners and mortgage borrowers.*/

-- Avg interest rate by loan_grade

Select 
loan_grade,
count(*) as total_loans,
Round(Avg(loan_int_rate),2) as Average_int_rate,
Rank() Over( order by (Avg(loan_int_rate)) Desc) as risk_rank 
From credit_risk
Group by loan_grade
order by risk_rank

----Key Findings

/* The interest rate ranking perfectly mirrors the default rate ranking —
Grade G borrowers pay the highest interest rate of 19.53% while Grade A borrowers pay just 7.67%. 
This confirms that the bank already recognises and prices risk accordingly through interest rates. 
However, while higher interest rates compensate the bank for additional risk, they also increase the monthly repayment burden for already struggling borrowers —
potentially contributing to the extremely high default rates seen in Grades D through G. 
The bank should consider combining higher interest rates with stricter approval criteria and lower loan amounts for high risk grades rather than relying solely on interest rate as a risk management too*/

-- Total loans by loan_intent
Select 
loan_intent,
count(*) as total_loans,
Rank() Over( order by count(*) Desc)as rank_risk
From credit_risk
Group by loan_intent
order by rank_risk

--Key Findings
/* Education loans are the most popular intent with 6,411 loans yet rank 5th in default rate at 17.25% — 
confirming that popularity does not necessarily indicate high risk. 
Home Improvement is the least popular with only 3,594 loans but carries a concerning default rate of 26.15%. 
Medical loans present a dual concern — ranking 2nd in both popularity (6,042 loans) and default rate (26.76%) — 
making it a high volume, high risk segment that requires immediate attention and stricter credit controls.
Notably, Debt Consolidation ranks 5th in popularity yet 1st in default rate (28.68%) — a small but extremely risky segment. 
This analysis confirms that there is no direct relationship between loan popularity and default risk — the bank must evaluate each intent independently rather than assuming popular loans are safe loans*/


-- Section 3.4 : Performance Analysis
-- Default Rate Performance by Loan Grade

--Target Value
With Portfolilo_default_rate as (
Select
Round(Sum(cast(loan_status as int))*100.0/count(*),2) as Avg_default_rate
From credit_risk
),
--Current Value
grade_default as (
Select 
loan_grade,
Count(*) as Total_default,
Round(Sum(cast(loan_status as int))*100.0/count(*),2) as default_rate 
From credit_risk
Group by loan_grade
)
Select
g.loan_grade,
g.total_default,
g.default_rate,
p.Avg_default_rate,
Round(g.default_rate-p.Avg_default_rate,2) as difference,
Case
When p.Avg_default_rate>g.default_rate Then 'Above Average Performance'
When p.Avg_default_rate<g.default_rate Then 'Below Average Performance'
else 'Average'
End as Performance
From grade_default as g
Cross join Portfolilo_default_rate as p
order by g.default_rate Desc

--Key Findings
/*Loan grade is the strongest predictor of default performance in this portfolio. 
Grades A, B and C perform above the portfolio average of 21.87% with default rates of 9.96%, 16.32% and 20.75% respectively — 
Grade A being the strongest performer at 11.91% below the target. 
However Grade C is borderline with only -1.12% below average — 
the bank should monitor this segment closely as it is at risk of crossing into below average territory.
Grades D, E, F and G all fall significantly below average performance with differences ranging from +37.19% to +76.57% above the portfolio target —
Grade G being the most extreme with a default rate of 98.44%, nearly 5 times the portfolio average.
The bank should implement immediate and strict credit controls for Grades D through G while continuing to support and grow the Grade A and B segments which demonstrate consistently strong repayment behaviour.*/


--DEfault rate by home ownership

--Target value
;With Overall_avg_default_rate as (
Select 
Round(Sum(cast(loan_status as int))*100.0/count(*),2) as Avg_default_rate
From credit_risk
),
--Current value
Default_rate_Per_Homeownership as (
Select
person_home_ownership,
Count(*) as Total_count,
Round(Sum(cast(loan_status as int))*100.0/count(*),2) as default_rate
From credit_risk
Group by person_home_ownership
)
Select 
d.person_home_ownership,
d.Total_count,
d.default_rate,
o.Avg_default_rate,
Round(d.default_rate-o.Avg_default_rate,2) as Differnce,
Case
When o.Avg_default_rate>d.default_rate Then 'Above Average Performance'
When o.Avg_default_rate<d.default_rate Then 'Below Average Performance'
Else 'Average'
End as Performance_grade
From Default_rate_Per_Homeownership as d
Cross Join Overall_avg_default_rate as o
order by d.default_rate Desc

--Key Findings

/*Renters and 'Other' ownership types both fall below average performance with default rates of 31.61% and 31.13% respectively 
— significantly above the portfolio average of 21.87% by +9.74% and +9.26%. 
Homeowners (OWN) deliver the strongest performance with a default rate of just 7.49% — 14.38% below the portfolio average — 
suggesting that outright home ownership is a strong indicator of financial stability and repayment capacity. 
Mortgage borrowers also perform above average with a default rate of 12.62% — 9.25% below portfolio average.
The bank should implement stricter credit controls and more rigorous approval criteria for renter and 'Other' applicants while maintaining favourable lending terms for homeowners and mortgage borrowers.*/

--3.5 Part-To-Whole Analysis
--loans with total loans by loan intent 
With total_loans as (
Select 
count(*) as Total_loans
From credit_risk
)
Select 
loan_intent,
count(*) as loans_per_intent,
Round(count(*)*100.0/cast(t.Total_loans as float),2) as perce_total_loans_per_intent
From credit_risk
cross join total_loans as t
group by loan_intent,t.Total_loans
order by perce_total_loans_per_intent

--Key Findings:
/*The loan portfolio is relatively well diversified across all six loan intents with no single category dominating heavily.
Education loans represent the largest segment at 19.78% of total loans followed closely by Medical (18.64%) and Venture (17.53%) — 
together accounting for 56% of the portfolio. Home Improvement is the smallest segment at just 11.09%.
Notably when cross referencing with default rate findings — Debt Consolidation represents 16.01% of total loans yet contributes the highest default rate of 28.68% making it a disproportionately risky segment relative to its size. 
Conversely Education represents the largest share (19.78%) yet maintains one of the lowest default rates (17.25%) — confirming that portfolio size does not equal portfolio risk.*/

-- Default with total default by grade

With total_default as (
Select 
Sum(Cast(loan_status AS int)) as total_default
From credit_risk
)
Select 
loan_grade,
Round(Sum(Cast(loan_status AS int)),2) as default_by_grade,
Round(Sum(Cast(loan_status AS int))*100.0/Total_default,2) as perce_Total_default_by_grade
From credit_risk
cross join total_default
group by loan_grade,total_default
order by perce_Total_default_by_grade

--Key Findings
/*While Grade G carries the highest default rate of 98.44%, it contributes only 0.89% of total defaults (63 defaults) due to its very small loan volume of just 64 loans.
In contrast, Grade D has a lower default rate of 59.06% yet contributes the largest share of total defaults at 30.16% (2,138 defaults) 
— driven by its significantly larger loan volume of 3,620 loans. Grades B and C together account for 42.76% of all defaults despite having moderate default rates of 16.32% and 20.75% respectively — 
simply because they represent the largest segments of the portfolio. 
This confirms a critical risk insight: high default rate does not equal high default volume. 
The bank should prioritise fixing Grade D over Grade G as reducing Grade D defaults would have a significantly greater impact on overall portfolio health — saving over 2,000 defaults compared to just 63 for Grade G.*/


--Defalut with Total default by loan_intent

With Total_default as (
Select 
Sum(Cast(loan_status as int)) as total_default
From credit_risk
)
Select 
loan_intent,
Round(Sum(Cast(loan_status AS int)),2) as default_by_intent,
Round(Sum(cast(loan_status as int))*100.0/ total_default,2) as perc_default_by_intent
from credit_risk
cross join Total_default
group by loan_intent,total_default
order by perc_default_by_intent Desc

--Key Findings
/*While Debt Consolidation carries the highest default rate of 28.68%, Medical loans contribute the largest share of total defaults at 22.81% (1,617 defaults) —
driven by their higher loan volume of 6,042 compared to Debt Consolidation's 5,189.
This confirms that default volume is a function of both default rate and loan volume — 
a segment with slightly lower rate but higher volume can contribute more actual defaults.
Venture loans are the safest segment in both dimensions —
lowest default rate (14.85%) and lowest share of total defaults (11.91%) — 
making them the most reliable segment in the portfolio. The bank should prioritise stricter supervision and credit controls over Medical and Debt Consolidation segments as they collectively account for 43.80% of all defaults,
while continuing to grow the Venture segment which demonstrates consistently strong repayment behaviour.*/

--Loan amount with total loan amount by loan_grade

With Total_loan_amount as (
Select
Sum(loan_amnt) as total_amount 
from credit_risk
)
Select
loan_grade,
Sum(loan_amnt)  as loan_by_grade,
SUM(loan_amnt) * 100.0 / total_amount  as perc_total_loan_by_intent
From credit_risk
Cross join Total_loan_amount
Group by total_amount,loan_grade
order by perc_total_loan_by_intent Desc

--Key Insights
/*Grades A and B dominate the portfolio in terms of money lent — together accounting for 62.78% of total loan amount 
yet carrying the lowest default rates of 9.96% and 16.32% respectively.
This is reassuring for the bank as the majority of money is concentrated in the safest segments.
Grade C holds 19.08% of total amount  with a moderate default rate of 20.75% — 
sitting just below the portfolio average making it a segment worth monitoring closely.
Despite having the highest default rate of 98.44%, Grade G represents only 0.35% of total money lent 
— meaning its actual financial impact on the portfolio is minimal. 
However Grade D presents the most concerning combination — holding 12.64% of total money  with a default rate of 59.06% — putting approximately $23 million at risk of default.
The bank should prioritise risk management efforts on Grade D which combines significant money exposure with an extremely high default rate.*/


--Segmentation Analysis

Select 
Case 
When person_income < 30000 Then 'Low Income'
When person_income Between 30000 and 70000 Then 'Medium Income'
When person_age between 70000 and 120000 Then 'High Income'
else 'Very High Income'
End as income_segment,
Count(*) AS total_loans,
Sum(Cast(loan_status as int)) as total_defaults,
Round(Sum(Cast(loan_status as int)) * 100.0 / Count(*), 2) AS default_rate,
Round(Avg(Cast(person_income as float)), 0) as avg_income,
Round(Avg(Cast(loan_amnt as float)), 0) as avg_loan_amount,
Round(Avg(loan_int_rate), 2) as avg_interest_rate,
Round(Avg(loan_percent_income) * 100, 2) as avg_dti
From credit_risk
Group by
Case 
When person_income < 30000 Then 'Low Income'
When person_income Between 30000 and 70000 Then 'Medium Income'
When person_age between 70000 and 120000 Then 'High Income'
else 'Very High Income'
End 
Order by default_rate 

--Key Findings
/*Income level is a strong predictor of default risk in this portfolio.
Low income borrowers (below 30,000) carry the highest default rate of 47.20% — more than four times the rate of very high income borrowers (11.15%) — 
making them the most vulnerable segment in the portfolio.
A clear inverse relationship exists between income and default risk: as income increases, default rate consistently decreases from 47.20% to 22.96% to 11.15%. 
This pattern is further explained by the DTI ratio — low income borrowers carry the highest average DTI of 23.39% meaning they commit a significantly larger proportion of their income to loan repayment, leaving little financial buffer for unexpected expenses. 
In contrast, very high income borrowers maintain a healthy DTI of just 12.58% — explaining their strong repayment behaviour. 
Medium income borrowers at 22.96% default rate sit close to the portfolio average of 21.87% — suggesting this segment requires monitoring. 
The bank should apply stricter income verification and lower loan limits for low income applicants while maintaining favourable terms for high and very high income borrowers who demonstrate consistently strong repayment capacity.*/



--Age Segmentation

Select
min(person_age) as minimum_age,
max(person_age)as max_age
From credit_risk

Select 
Case
When person_age between 20 and 28 Then 'Early career'
When person_age between 28 and 36 Then 'Mid career'
When person_age between 36 and 44 Then 'Experienced'
Else 'Senior'
End as Age_Segmentation,
Count(*) as Total_loans,
Sum(Cast(loan_status as int)) as total_defaults,
Round(Sum(Cast(loan_status as int)) * 100.0 / Count(*), 2) AS default_rate,
Round(Avg(Cast(person_income as float)), 0) as avg_income,
Round(Avg(Cast(loan_amnt as float)), 0) as avg_loan_amount,
Round(Avg(loan_int_rate), 2) as avg_interest_rate,
Round(Avg(loan_percent_income) * 100, 2) as avg_dti
From credit_risk
Group by
Case
When person_age between 20 and 28 Then 'Early career'
When person_age between 28 and 36 Then 'Mid career'
When person_age between 36 and 44 Then 'Experienced'
Else 'Senior'
end
Order by Age_Segmentation desc

--Key Findings
/*Early career borrowers (age 20-25) dominate the portfolio with 21,687 loans representing 66% of total loans — 
consistent with our earlier finding that the typical borrower is young with an average age of 27.
An interesting U-shaped pattern emerges in default rates across age segments — rates decrease from Early Career (22.58%) through Mid Career (20.33%) to Experienced (20.01%) before rising again for Senior borrowers (22.68%). 
Mid Career and Experienced borrowers are the safest segments — benefiting from growing income stability, established credit histories and stronger financial management skills. 
The Senior segment presents a paradox — carrying the highest average income of 82,990 yet showing a higher default rate of 22.68% — possibly explained by approaching retirement where fixed post-retirement income reduces repayment capacity despite currently high earnings.
The bank should focus growth efforts on Mid Career and Experienced segments which demonstrate the strongest repayment behaviour, while applying additional scrutiny to Senior applicants despite their high income levels — as income alone does not guarantee repayment capacity in this segment*/



SELECT
    CASE
        WHEN loan_grade IN ('A', 'B') THEN ' Low Risk'
        WHEN loan_grade IN ('C') THEN ' Medium Risk'
        WHEN loan_grade IN ('D', 'E') THEN ' High Risk'
        ELSE ' Very High Risk'
    END AS risk_segment,

    
    COUNT(*) AS total_loans,
    SUM(CAST(loan_status AS INT)) AS total_defaults,

    
    ROUND(SUM(CAST(loan_status AS INT)) * 100.0 / COUNT(*), 2) AS default_rate,

    
    ROUND(AVG(CAST(person_income AS FLOAT)), 0) AS avg_income,
    ROUND(AVG(CAST(loan_amnt AS FLOAT)), 0) AS avg_loan_amount,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(loan_percent_income) * 100, 2) AS avg_dti,
    ROUND(AVG(CAST(person_emp_length AS FLOAT)), 1) AS avg_emp_length

FROM credit_risk
GROUP BY
    CASE
        WHEN loan_grade IN ('A', 'B') THEN ' Low Risk'
        WHEN loan_grade IN ('C') THEN ' Medium Risk'
        WHEN loan_grade IN ('D', 'E') THEN ' High Risk'
        ELSE ' Very High Risk'
    END
ORDER BY default_rate DESC

--Key Findings
/*The risk segmentation confirms that the portfolio is predominantly composed of low risk borrowers — with 21,090 loans (65% of total) in the Low Risk segment (Grades A and B) carrying a default rate of just 13.09%.
This is reassuring as the majority of the portfolio is concentrated in the safest segment. However the High Risk segment (Grades D and E) presents a significant concern — 4,583 loans with a default rate of 60.20% — meaning 3 out of every 5 borrowers in this segment defaulted. 
The Very High Risk segment (Grades F and G) carries an alarming default rate of 76.39% yet interestingly has the highest average income of 76,959 and largest average loan amount of 15,237 — confirming our earlier finding that income alone does not determine creditworthiness.
A clear escalation pattern exists across all risk metrics as segment risk increases — interest rates rise from 9.31% to 18.13%, DTI increases from 16.44% to 22.16% and loan amounts grow from 9,258 to 15,237 — suggesting higher risk borrowers take larger loans at higher rates yet still fail to repay.
The bank should strictly limit loan approvals for High and Very High Risk segments and consider implementing a maximum loan amount cap for Grade D and above to reduce overall portfolio risk exposure.*/






/* Summary

 CREDIT RISK ANALYSIS PROJECT
 Final Key Findings Summary




PORTFOLIO OVERVIEW

- Total loans : 32,416
- Total amount lent : ~311 million
- Total defaults : 7,089
- Overall default rate : 21.87% 
  (significantly above 5-10% banking threshold)
- Average loan amount : 9,593
- Average interest rate : 11.01%


BORROWER PROFILE

- Average age : 27 years — predominantly young borrowers
- Average income : 66,091
- Average employment length : 4.8 years — early career stage
- Average credit history : 5 years — still building track record
- Average DTI : 17% — some borrowers as high as 83%

Overall : This is a portfolio of young, early career borrowers
with limited credit history carrying meaningful debt burdens


LOAN GRADE FINDINGS

- Grade A is safest : 9.96% default rate
- Grade G is riskiest : 98.44% default rate
- Significant jump between Grade C (20.75%) and D (59.06%)
- Grades A and B hold 62.78% of total money lent
- Grade D contributes most defaults in volume : 30.16%
- Grade G has highest rate but only 0.35% of total money

Key : Treat Grades D, E, F, G as high risk segments
      requiring immediate stricter credit controls


LOAN INTENT FINDINGS

- Education : most popular (19.78% of loans) yet 5th in default rate
- Debt Consolidation : riskiest (28.68% default rate)
- Venture : safest (14.85% default rate)
- Medical : highest default volume (22.81% of all defaults)
- No direct relationship between popularity and default risk

Key : Apply strict controls for Debt Consolidation and Medical
      Maintain favourable terms for Venture loans


HOME OWNERSHIP FINDINGS

- Renters : riskiest (31.61% default rate) — 50%+ of portfolio
- Homeowners (OWN) : safest (7.49% default rate)
- Mortgage borrowers : stable (12.62% default rate)
- Home ownership is stronger predictor than income or DTI

Key : Apply stricter credit controls for renter applications


PERFORMANCE ANALYSIS FINDINGS

- Grades A, B, C perform above portfolio average
- Grades D, E, F, G perform below portfolio average
- Grade C is borderline — only 1.12% above average
- Renters and OTHER perform below average (+9.74%, +9.26%)
- Homeowners and Mortgage perform above average

Key : Monitor Grade C closely — at risk of crossing
      into below average territory


SEGMENTATION FINDINGS

INCOME SEGMENTATION:
- Low income borrowers most vulnerable : 47.20% default rate
- Clear inverse relationship — higher income = lower default rate
- Low income DTI highest at 23.39%

AGE SEGMENTATION:
- Early career dominates : 66% of total loans
- U-shaped default rate — Mid Career and Experienced safest
- Senior paradox — high income yet higher default rate (22.68%)

RISK SEGMENTATION:
- 65% of loans in Low Risk segment — reassuring
- High Risk segment : 60.20% default rate — 3 in 5 defaulted
- Very High Risk : highest income yet 76.39% default rate


KEY RISK INSIGHTS

1. High default RATE ≠ High default VOLUME
   Grade G has 98.44% rate but only 0.89% of total defaults
   Grade D has 59.06% rate but 30.16% of total defaults

2. High income ≠ Low risk
   Grade F and G earn most yet default most
   Very High Risk segment has highest avg income

3. Popularity ≠ Risk
   Education most popular but 5th in default rate
   Debt Consolidation least popular but riskiest

4. Home ownership stronger predictor than income
   OWN borrowers safest despite second highest DTI

5. DTI is strongest combined predictor
   Higher DTI consistently correlates with higher default rate


BANK RECOMMENDATIONS

1. Implement strict credit controls for Grades D, E, F, G
2. Apply lower loan limits for low income borrowers
3. Increase scrutiny for Debt Consolidation and Medical loans
4. Treat renter applications with stricter approval criteria
5. Monitor Grade C segment closely — borderline performance
6. Consider loan amount caps for High and Very High Risk segments
7. Prioritise Grade A and B growth — safest and largest segments
8. Use DTI as primary risk screening tool alongside loan grade

*/