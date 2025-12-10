--- Which marketing channels are driving the highest volume of leads and customers, and how does that relate to their total ad spend? 
-- To avoid duplication when pulling customers, aggregated each side first 
WITH m AS ( 
SELECT 
	channel, 
	SUM(leads) AS leads, 
	SUM(wins) AS wins, 
	SUM(ad_spend) AS spend 
FROM marketing 
GROUP BY channel ), s AS ( 
SELECT 
	sc.acquisition_channel AS channel, 
	COUNT(DISTINCT customer_id) AS customers 
FROM sales sc 
GROUP BY sc.acquisition_channel
) 
SELECT 
	m.channel, 
	m.leads, 
	m.wins, 
	s.customers, 
	m.spend 
FROM m 
LEFT join s 
USING (channel) 
ORDER BY m.leads DESC, s.customers desc;



--- How has CAC (Customer Acquisition Cost) trended over time by channel? Are some channels becoming more expensive? 

WITH spend AS ( 
SELECT 
	date_trunc('month', date)::date AS month, 
	channel, 
	SUM(ad_spend) AS spend 
FROM marketing 
GROUP BY 1,2 ), 
	custs AS ( 
SELECT 
	date_trunc('month', acquisition_date)::date AS month, 
	acquisition_channel AS channel, 
	COUNT(DISTINCT customer_id) AS new_customers 
	FROM sales 
GROUP BY 1,2 
) SELECT 
	s.month, 
	s.channel, 
	ROUND((s.spend / NULLIF(c.new_customers, 0))::numeric,2) AS cac 
FROM spend s 
LEFT JOIN custs c 
ON c.month = s.month AND c.channel = s.channel 
ORDER BY s.month, s.channel;



-- For Power BI
CREATE VIEW cac AS
WITH spend AS ( 
SELECT 
	date_trunc('month', date)::date AS month, 
	channel, 
	SUM(ad_spend) AS spend 
FROM marketing 
GROUP BY 1,2 ), 
	custs AS ( 
SELECT 
	date_trunc('month', acquisition_date)::date AS month, 
	acquisition_channel AS channel, 
	COUNT(DISTINCT customer_id) AS new_customers 
	FROM sales 
GROUP BY 1,2 
) SELECT 
	s.month, 
	s.channel, 
	ROUND((s.spend / NULLIF(c.new_customers, 0))::numeric,2) AS cac 
FROM spend s 
LEFT JOIN custs c 
ON c.month = s.month AND c.channel = s.channel 
ORDER BY s.month, s.channel;


--- Which campaigns are delivering the best ROAS and which ones are burning budget with little attributed revenue?
WITH m AS ( 
SELECT 
	campaign_id, 
	campaign_name, 
	channel, 
	SUM(ad_spend) AS spend, 
	SUM(revenue_attributed) AS rev_attr 
FROM marketing GROUP BY 1,2,3 ), 
s AS ( 
SELECT 
	first_touch_campaign_id AS campaign_id, 
	SUM(revenue_amount) AS rev_realized 
FROM sales 
GROUP BY 1 
) 
SELECT 
	m.campaign_id, 
	m.campaign_name, 
	m.channel, 
	m.spend, 
	m.rev_attr, 
	s.rev_realized, 
	m.rev_attr / NULLIF(m.spend,0) AS roas_attr, 
	s.rev_realized / NULLIF(m.spend,0) AS roas_realized 
FROM m 
LEFT JOIN s 
USING (campaign_id) 
WHERE m.spend > 0 
ORDER BY roas_realized DESC NULLS last

--- for power bi
create view roas as 
WITH m AS ( 
SELECT 
	campaign_id, 
	campaign_name, 
	channel, 
	SUM(ad_spend) AS spend, 
	SUM(revenue_attributed) AS rev_attr 
FROM marketing GROUP BY 1,2,3 ), 
s AS ( 
SELECT 
	first_touch_campaign_id AS campaign_id, 
	SUM(revenue_amount) AS rev_realized 
FROM sales 
GROUP BY 1 
) 
SELECT 
	m.campaign_id, 
	m.campaign_name, 
	m.channel, 
	m.spend, 
	m.rev_attr, 
	s.rev_realized, 
	m.rev_attr / NULLIF(m.spend,0) AS roas_attr, 
	s.rev_realized / NULLIF(m.spend,0) AS roas_realized 
FROM m 
LEFT JOIN s 
USING (campaign_id) 
WHERE m.spend > 0 
ORDER BY roas_realized DESC NULLS last

--- At which stage of the funnel do we lose the most leads? MQL → SQL, or SQL → Win? 
SELECT 
channel, 
sum(mqls) as mqls, 
sum(sqls) as sqls, 
sum(wins) as wins, 
100.0 * (sum(mqls) - sum(sqls)) / sum(mqls) AS mql_to_sql_dropoff_pct, 
100.0 * (sum(sqls) - sum(wins)) / sum(sqls) AS sql_to_win_dropoff_pct
FROM marketing 
group by channel;



-- for power bi
create view dropoffs as
SELECT 
channel, 
sum(mqls) as mqls, 
sum(sqls) as sqls, 
sum(wins) as wins, 
100.0 * (sum(mqls) - sum(sqls)) / sum(mqls) AS mql_to_sql_dropoff_pct, 
100.0 * (sum(sqls) - sum(wins)) / sum(sqls) AS sql_to_win_dropoff_pct
FROM marketing 
group by channel;


--- How does lead-to-win conversion rate differ by acquisition channel or source? 
select 
	channel, 
	source, 
	sum(mqls) as mqls, 
	sum(sqls) as sqls, 
	sum(wins) as wins, 
	100.0 * sum(wins) / sum(mqls) as lead_to_win_from_mql_pct, 
	100.0 * sum(wins) / sum(sqls) as lead_to_win_from_sql_pct 
from marketing 
group by channel, 
source order by channel;


--- Compare Marketing-attributed revenue vs. realized Sales revenue by channel 
WITH m AS (
  SELECT channel, SUM(revenue_attributed) AS rev_attr
  FROM marketing
  GROUP BY channel
),
s AS (
  SELECT acquisition_channel AS channel, SUM(revenue_amount) AS rev_realized
  FROM sales
  GROUP BY acquisition_channel
)
SELECT
  COALESCE(m.channel, s.channel) AS channel,
  m.rev_attr,
  s.rev_realized,
  (s.rev_realized - m.rev_attr) AS gap,
  CASE WHEN s.rev_realized > 0 THEN (s.rev_realized - m.rev_attr) / s.rev_realized::numeric END AS gap_pct
FROM m
FULL OUTER JOIN s USING (channel)
ORDER BY gap DESC NULLS LAST;


--- Which campaigns generate the highest average revenue per customer?
WITH s_by_camp AS (
  SELECT
    first_touch_campaign_id AS campaign_id,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(revenue_amount)        AS revenue
  FROM sales
  GROUP BY 1
),
dim_campaign AS (
  SELECT
    campaign_id,
    MIN(campaign_name) AS campaign_name,
    MIN(channel)       AS channel
  FROM marketing
  GROUP BY campaign_id
)
SELECT
  s.campaign_id,
  d.campaign_name,
  d.channel,
  s.customers,
  s.revenue,
  s.revenue / NULLIF(s.customers, 0) AS avg_rev_per_customer
FROM s_by_camp s
JOIN dim_campaign d
  ON d.campaign_id = s.campaign_id
ORDER BY avg_rev_per_customer DESC NULLS LAST;

-- for power bi
create view avg_rev_cust as
WITH s_by_camp AS (
  SELECT
    first_touch_campaign_id AS campaign_id,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(revenue_amount)        AS revenue
  FROM sales
  GROUP BY 1
),
dim_campaign AS (
  SELECT
    campaign_id,
    MIN(campaign_name) AS campaign_name,
    MIN(channel)       AS channel
  FROM marketing
  GROUP BY campaign_id
)
SELECT
  s.campaign_id,
  d.campaign_name,
  d.channel,
  s.customers,
  s.revenue,
  s.revenue / NULLIF(s.customers, 0) AS avg_rev_per_customer
FROM s_by_camp s
JOIN dim_campaign d
  ON d.campaign_id = s.campaign_id
ORDER BY avg_rev_per_customer DESC NULLS LAST;


--- power bi 
create view roas_prev as 
with yearly as ( 
	select 
	extract(year from date) as year, 
	extract(quarter from date) as quarter, 
	channel, 
	sum(revenue_attributed) as revenue, 
	sum(ad_spend) as spend, 
	(sum(revenue_attributed) / nullif(sum(ad_spend), 0)) as roas 
from marketing 
group by extract(year from date), 
	extract(quarter from date), 
	channel 
) select 
	channel, 
	year, 
	quarter, 
	roas, 
	roas - lag(roas) over (partition by channel order by year, quarter) as roas_change_vs_prev 
from yearly 
order by 
	channel, 
	year, 
	quarter; 
with yearly as ( 
select extract(year from date) as year, 
	extract(quarter from date) as quarter, 
	channel, 
	sum(revenue_attributed) as revenue, 
	sum(ad_spend) as spend, 
	case when sum(ad_spend) > 0 then sum(revenue_attributed) / sum(ad_spend) 
	else null end as roas 
from marketing 
group by extract(year from date), 
	extract(quarter from date), 
	channel 
) 
select 
	channel, 
	year, 
	quarter, 
	roas, 
	roas - lag(roas) over (partition by channel order by year, quarter) as roas_change_vs_prev 
from yearly 
where roas is not null 
order by channel, year, quarter;

--- Which acquisition channels produce customers with the highest lifetime value (LTV)?
WITH ltv AS (
  SELECT
    acquisition_channel AS channel,
    customer_id,
    SUM(revenue_amount) AS ltv
  FROM sales
  GROUP BY 1,2
)
SELECT
  channel,
  ROUND((AVG(ltv)::numeric), 2) AS avg_ltv_per_customer,
  COUNT(*) AS customers
FROM ltv
GROUP BY channel
ORDER BY avg_ltv_per_customer DESC;

--- power bi
create view ltv as 
WITH ltv AS (
  SELECT
    acquisition_channel AS channel,
    customer_id,
    SUM(revenue_amount) AS ltv
  FROM sales
  GROUP BY 1,2
)
SELECT
  channel,
  ROUND((AVG(ltv)::numeric), 2) AS avg_ltv_per_customer,
  COUNT(*) AS customers
FROM ltv
GROUP BY channel
ORDER BY avg_ltv_per_customer DESC;

--- Is there a relationship between customer acquisition month and total LTV (cohort profitability)? 
WITH customer_ltv AS ( 
SELECT 
	customer_id, 
	DATE_TRUNC('month', acquisition_date)::date AS acquisition_month, 
	SUM(revenue_amount) AS total_ltv 
FROM sales 
GROUP BY customer_id, 
DATE_TRUNC('month', acquisition_date)::date 
) SELECT 
	acquisition_month, 
	COUNT(DISTINCT customer_id) AS customers, 
	AVG(total_ltv) AS avg_ltv, 
	SUM(total_ltv) AS total_ltv_sum 
FROM customer_ltv 
GROUP BY acquisition_month 
ORDER BY acquisition_month;


--- power bi
create view cohort_ltv as
WITH customer_ltv AS ( 
SELECT 
	customer_id, 
	DATE_TRUNC('month', acquisition_date)::date AS acquisition_month, 
	SUM(revenue_amount) AS total_ltv 
FROM sales 
GROUP BY customer_id, 
DATE_TRUNC('month', acquisition_date)::date 
) SELECT 
	acquisition_month, 
	COUNT(DISTINCT customer_id) AS customers, 
	AVG(total_ltv) AS avg_ltv, 
	SUM(total_ltv) AS total_ltv_sum 
FROM customer_ltv 
GROUP BY acquisition_month 
ORDER BY acquisition_month;



