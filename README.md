# Case Study
The company VornexaFit is a fitness company that has invested heavily in paid marketing channels across 2024–2025, with more than 4 million dollars spent on Paid Search alone and several million more across Display, Paid Social, and Influencer campaigns. Yet despite record ad spending, leadership noticed that customer acquisition was stagnating and CAC increasing across channels. The executive team asked the analytics department to investigate which channels truly generate profitable customers and where funnel leakage occurs.

The goal of this project was to perform an end-to-end marketing performance audit using SQL, Power BI modeling, and DAX measures to determine:

1.       Which channels drive the most leads, customers, and revenue?

2.       How CAC and ROAS have trended over time.

3.       Where the marketing funnel leaks.

4.       Which customers deliver the highest LTV?

5.       How attributed vs. realized revenue differ and whether current attribution can be trusted.

6.       Where budgets should be cut, protected, or expanded.

<img width="1545" height="887" alt="image" src="https://github.com/user-attachments/assets/fe4b4097-4562-4f01-ba6e-92cf5f445131" />

## Executive Summary

We found that most of our marketing budget is being burned on channels that don’t attract customers, don’t generate revenue, and create extremely low-quality leads. **Display, Influencer, and Paid Social** have **CACs** so **high** that they **destroy profit,** while organic channels like **Direct, Referral, Email**, and **Organic Search** **attract** most of our customers for **no incremental acquisition cost** and with the **highest LTV.** Our attribution model is also **overstating paid channel revenue by 3×;** this means that we are investing in campaigns that are losing lots of money. The solution is to **cut unprofitable paid channels**, **reinvest in organic and retention programs**, **optimize Paid Search**, and **rebuild attribution** to reduce wasted spending and shift investment toward channels that drive **profitable growth.**

## Deep Dive
<img width="1510" height="876" alt="image" src="https://github.com/user-attachments/assets/c5ae8d26-911f-4126-89c9-c6d3d6c5c11f" />
As we see, the company is overspending on underperforming paid channels.

**Paid Search** attracts most leads and customers, and we are spending heavily on it **($4.2M** to get those results), but **Direct, Referral, Email**, and **Organic Search**, which are organic channels, have **no ad spend** yet drive a **HUGE number of customers**.

**Paid Social, Display**, and **Influencers** give almost no customers relative to cost. Therefore, we need to **reduce spending on Display, Influencer,** and **Paid Social** immediately and invest more in organic channels.

<img width="1257" height="695" alt="image" src="https://github.com/user-attachments/assets/e71e5947-ef81-4053-abdd-03c738c9b9d0" />

When we look at how the customer acquisition cost changes over time and across channels, we see a similar pattern. **Paid Search** is the only paid channel that works. CAC is in the **$600–$800** range, which is still expensive but reasonable, and it shows stable performance over time except with the dip (**$598**) in **August 2025**. This is our only healthy paid channel because for the whole of 2025, we got more than **7k** customers. Likewise, when we see the others, which CAC are also rising, they are extremely **expensive and inefficient**, namely, **Influencer, Display, and Paid Social**. They are burning money and generating almost no customers.

In **Display Ads**, CAC is extremely high (**>$20k per customer**), and we got **15** customers. We either need to stop or reduce the spending because every dollar we spend here is wasted.

**Influencers'** CAC is high **(5k-$43k)** and **inconsistent**, making it terrible for customer acquisition.  Spikes in **July ($24K)** and **August ($43K)** indicate spending, but very few wins (**135** wins for the whole span of 2024-2025) were acquired.

**Paid Social**, on the other hand, goes around **5k-7k$** and has reduced in **July** (**4492$**) but is still **not as efficient** as Paid Search and organic channels, as the sum of wins is just **867**.

Our **Organic Search, Direct, Email, Referral** spend **$0** to acquire customers and have **massive ROI** (more than a thousand customers).

<img width="1532" height="883" alt="image" src="https://github.com/user-attachments/assets/b21cf6e5-238c-4dcc-9935-7b6774b71ff9" />

Another problem is there is a **major gap** between our **attributed ROAS and our realized ROAS** across every paid campaign. Under the attributed model, our campaigns look profitable (≈3.0 ROAS), as if we’re making three dollars for every dollar spent. However, when we look at realized revenue, we see that **every paid channel is losing money**, with realized ROAS around **0.78–0.86*. This means that for every $1 we spend, we only earn about $0.80 back.

<img width="463" height="546" alt="image" src="https://github.com/user-attachments/assets/9dfe85ee-0803-47d8-8a8b-372559bb1a0e" />

<img width="1258" height="691" alt="image" src="https://github.com/user-attachments/assets/141165b1-62d4-4f6c-ba83-2093d3f8b04f" />

Moreover, we found that we **lose FAR more leads in the SQL**. MQL → SQL drop-off is **~65–85%**, and SQL → Win drop-off is **~70–92%**. Sales are losing most opportunities late in the process. Especially **Display, Influencer, and Paid Social** generate very **poor-quality MQLs (78–84% drop)**. When we look at how many sales qualified leads never become customers, it only closes **8%–28% of SQLs**. And the biggest losses come from **SQL → Win**. Therefore, we need to improve sales conversion and cut spending on channels like Display, Influencer, and Paid Social, since they attract very few customers and poor SQL-to-Win rates. 

<img width="1532" height="872" alt="image" src="https://github.com/user-attachments/assets/ac2a46b8-5395-458e-ac3d-491428adf7f4" />

In addition to that, most of our acquisition budget is tied to channels that generate **low-value, low-intent customers**, resulting in **negative profit per customer**. Across all campaigns, the channels that consistently acquire the **most valuable long-term customers are Paid Search, Referral, and Email**, all producing revenue per customer in the **$530–$565 range**. On the other hand, **Display, Influencer, and Paid Social** generate significantly **lower-value customers (typically $250–$450 per customer)**, which aligns with earlier findings of high CAC and low funnel conversion quality. 

<img width="1501" height="873" alt="image" src="https://github.com/user-attachments/assets/353bf4f8-0e8d-4cee-bb08-7f08f0e55b5a" />

However, we observe **some exceptions** when we analyze them at the campaign level.
**Display – AdRoll Prospecting ($856 LTV)**
**Influencer – Instagram (multiple campaigns) ($659–$717 LTV)**

These campaigns perform far above their channel averages, suggesting that while the overall channels are weak, **specific targeting or creative strategies** can yield **high-value segments**. Therefore, we need to reallocate spending within channels towards these micro-segments (e.g., AdRoll Prospecting, Instagram BAU).

### Key Findings
1.	The company is massively overspending on underperforming paid channels.
2.	Organic channels outperform every paid channel despite $0 spend
3.	Paid Search is the only “healthy” paid channel, but it is still not profitable under realized revenue.
4.	The attribution model is broken and is causing millions in misallocated budget.
5.	The biggest funnel leakage occurs in SQL → Win.

### Key Recommendations
1.	Cut or Dramatically Reduce Spending on Underperforming Paid Channels
2.	Reallocate Budget to Organic & High-Intent Channels like Email, Referral and retention programs
3.	Keep Paid Search, but Optimize and Reduce Over-Dependence 
4.	Rebuild the Attribution Model because Current Model Overstates Revenue by 3×
5.	Fix SQL → Win Conversion
6.	Shift Paid Budgets Toward High-LTV Micro-Segments

## Methodology / Technical Approach
This project began with removing duplicates on excel, continued with SQL-based data cleaning, exploration and analyzing where I created aggregated views such as CAC, ROAS, LTV, funnel drop-offs, and cohort performance. These SQL outputs were imported into Power BI, where I modeled the data and built a dim_channel table to unify channel-level relationships across marketing and sales. To extend insights beyond the raw SQL results, I created several DAX measures (e.g., Cost per Customer, ROAS Gap, LTV/CAC Ratio, Profit per Customer).

Full SQL codes are available [here](https://github.com/lyamanis/Marketing-ROAS-Analysis/blob/main/sqlcode.sql)

Full DAX definitions are available [here](https://github.com/lyamanis/Marketing-ROAS-Analysis/blob/main/Data%20Exploration%2C%20Modeling%20%26%20DAX.md)

Full Power BI Dashboard [here](https://github.com/lyamanis/Marketing-ROAS-Analysis/blob/main/VornexaFit%20Marketing.pbix)
