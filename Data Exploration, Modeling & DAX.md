**The process**
I began by cleaning the raw data, removing 200 duplicates, fixing channel name typos, and converting all date fields from text to proper date types. After cleaning, I performed SQL-based analysis where I created aggregated views such as CAC, ROAS, LTV, funnel drop-offs, and cohort LTV. 
Once the SQL outputs were imported into Power BI, I created a dim_channel table because ‘channel’ existed separately in the raw marketing table, the sales table, and the SQL result tables. This allowed me to connect everything using a single channel reference and fix previously disconnected relationships.
After the model was connected, I created DAX measures, including CAC, ROAS Gap, LTV/CAC Ratio, Lead-to-Customer Conversion, and Profit per Customer, to calculate KPIs that were not directly available from SQL.

**DAX Measures**

Lead_to_Customer_Conversion = DIVIDE(SUM(marketing[wins]), SUM(marketing[leads]))

Cost per Customer (CPC)
Total_Ad_Spend = SUM(marketing[ad_spend])
Total_Customers = DISTINCTCOUNT(sales[customer_id])
Cost_Per_Customer = DIVIDE([Total_Ad_Spend], [Total_Customers])

ROAS Gap (Attributed vs Realized)
ROAS_Gap = AVERAGE(roas[roas_realized]) - AVERAGE(roas[roas_attr])

CAC & LTV by Channel
Avg_CAC_By_Channel = AVERAGE ( cac[cac] )
Avg LTV = AVERAGE(ltv[avg_ltv_per_customer])
LTV CAC Ratio = DIVIDE([Avg LTV], [Avg_CAC_By_Channel], BLANK())
Profit Per Customer = [Avg LTV] - [Avg CAC]
